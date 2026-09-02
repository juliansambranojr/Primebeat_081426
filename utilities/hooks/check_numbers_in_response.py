#!/usr/bin/env python3
"""Stop hook: every precise number in a response must exist in a .numbers file.

Denies (blocks) a response that states a number — three or more decimal
places, or scientific notation — that no `analysis/**/results/*.numbers` or
`results/*.numbers` file holds, rounding-aware at the response's own
precision. Numbers reach a response from the .numbers file, by key
(AGENT_CARD.md § Numbers); a number typed from memory, a brief, or a report
is the failure this closes. Entry 219 reported a maximum wrong by 2.3x for
four entries; the value never came from a file.

What is scanned: the final assistant message, read from the transcript the
same way check_response_prefix.py reads it, with fenced code blocks removed.
Tokens: `-?\\d+\\.\\d{3,}` or `-?\\d+(\\.\\d+)?[eE][-+]?\\d+`. Skipped: tokens
inside a hex run of 8+ characters (hashes), tokens glued to a word, and
tokens immediately preceded by `line`, `lines`, `entry`, `:`, `#`, `L`.

What counts as "in a file": every numeric value of every line, plus every
number appearing inside a key (`ladder.k=10|eps=0.001|...` puts 0.001 on the
table, so citing a key is never a violation). The comparison is
check_values.py's `matches` — that module runs its check at import time and
exits, so the function is imported from check_entry_numbers.py, which holds
the verified copy.

Protocol (identical to check_response_prefix.py): stdin is the Stop hook
JSON; on violation stdout is {"decision": "block", "reason": ...}; exit 0
always, failing open on any parse error. The stop_hook_active loop guard
lets a second failure through with a systemMessage rather than hanging.

    --selftest    feeds one passing and one failing message through the
                  extractor and the lookup; exits 0 when both behave.
"""
import json
import pathlib
import re
import sys
from decimal import Decimal, InvalidOperation

HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent))
from check_response_prefix import last_assistant_text          # noqa: E402
from check_entry_numbers import matches, NUM as KEY_NUM        # noqa: E402

TOKEN = re.compile(r"-?\d+\.\d{3,}|-?\d+(?:\.\d+)?[eE][-+]?\d+")
HEX_RUN = re.compile(r"[0-9a-fA-F]{8,}")
FENCE = re.compile(r"```.*?```", re.S)
# the preceding text, whitespace allowed between it and the token
SKIP_BEFORE = re.compile(r"(?:\blines?|\bentry|:|#|\bL)\s*$", re.I)


def number_tokens(text):
    """[(token, Decimal, start)] for every citable-precision number outside fences.

    `start` is the offset into the fence-stripped text (FENCE.sub("", text))."""
    text = FENCE.sub("", text)
    hex_spans = [m.span() for m in HEX_RUN.finditer(text)]
    out = []
    for m in TOKEN.finditer(text):
        s, e = m.span()
        if any(a <= s and e <= b for a, b in hex_spans):
            continue
        if s > 0 and (text[s - 1].isalnum() or text[s - 1] == "_"):
            continue                      # glued to a word or identifier
        if e < len(text) and (text[e].isalnum() or text[e] == "_"):
            continue
        if SKIP_BEFORE.search(text[:s]):
            continue
        try:
            out.append((m.group(0), Decimal(m.group(0)), s))
        except InvalidOperation:
            continue
    return out


def numbers_files(root=ROOT):
    files = []
    an = root / "analysis"
    if an.is_dir():
        files += [p for p in an.rglob("*.numbers")
                  if p.parent.name == "results" and p.is_file()]
    rs = root / "results"
    if rs.is_dir():
        files += [p for p in rs.glob("*.numbers") if p.is_file()]
    return sorted(files)


def table_values(files):
    """Every number a .numbers file holds: numeric values, and numbers in keys."""
    have = set()
    for p in files:
        for line in p.read_text(encoding="utf-8", errors="replace").split("\n"):
            if not line or line.startswith("#") or "\t" not in line:
                continue
            k, v = line.split("\t", 1)
            try:
                have.add(Decimal(v.strip()))
            except InvalidOperation:
                pass
            for m in KEY_NUM.finditer(k):
                try:
                    have.add(Decimal(m.group(0).replace(",", "")))
                except InvalidOperation:
                    pass
    return have


def offenders(text, root=ROOT):
    toks = number_tokens(text)
    if not toks:
        return []
    have = table_values(numbers_files(root))
    seen, bad = set(), []
    for tok, want, _ in toks:
        if tok in seen:
            continue
        seen.add(tok)
        if not matches(want, have):
            bad.append(tok)
    return bad


def reason(bad):
    return ("Response rejected by check_numbers_in_response.py: "
            + ", ".join(bad)
            + " appear(s) in no analysis/**/results/*.numbers or "
              "results/*.numbers file. Numbers come from .numbers files; grep "
              "the key, read the value there, and cite it by key. A number that "
              "has no file yet goes in a fenced block, labelled exploratory.")


def selftest():
    files = numbers_files()
    have = table_values(files)
    # one value that IS in a file, at file precision
    sample = None
    for p in files:
        for line in p.read_text(encoding="utf-8").split("\n"):
            if "\t" in line and not line.startswith("#"):
                k, v = line.split("\t", 1)
                try:
                    d = Decimal(v.strip())
                except InvalidOperation:
                    continue
                if d != d.to_integral_value() and abs(d) > Decimal("0.001"):
                    sample = (k, v.strip()); break
        if sample: break
    assert sample, "selftest needs at least one non-integer value in a .numbers file"
    key, val = sample
    passing = (f"`{key}` {val} (sha c2717f263ef7cb1435942ecddeb701ad7f9dd0f88ba6d02e34d1e031c64ff1bf)\n"
               f"see line 12.3456 and entry 3.14159, L1.000001, #2.7182818\n"
               f"```\n0.123456 in a fence is fine\n```\n")
    failing = "the slope is 3.14159265 and the tail is 7.77e-12; " + passing
    bad_pass = offenders(passing)
    bad_fail = offenders(failing)
    print(f"files: {len(files)}  values: {len(have)}")
    print(f"pass message -> offenders {bad_pass}")
    print(f"fail message -> offenders {bad_fail}")
    ok = (bad_pass == [] and set(bad_fail) == {"3.14159265", "7.77e-12"})
    print("selftest", "OK" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
        transcript_path = payload.get("transcript_path")
        if not transcript_path:
            return
        text = last_assistant_text(transcript_path)
        if not text:
            return
        bad = offenders(text)
        if not bad:
            return
        if payload.get("stop_hook_active"):
            print(json.dumps({
                "systemMessage":
                    "check_numbers_in_response: still citing numbers in no "
                    ".numbers file after one block (" + ", ".join(bad)
                    + "); letting it through."}))
            return
        print(json.dumps({"decision": "block", "reason": reason(bad)}))
    except Exception:
        return


if __name__ == "__main__":
    main()
