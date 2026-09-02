#!/usr/bin/env python3
"""PreToolUse hook (matcher "Agent"): a spawn brief opens with the card and carries no retyped numbers.

Denies an Agent call when
  1. the prompt's first non-empty line does not contain `AGENT_CARD.md` or
     `AGENT_CLAUDE.md` — the spawned agent has no memory of this session
     and the card is its only orientation (root CLAUDE.md § Rules,
     "Spawn-time agent orientation"); or
  2. the prompt contains a number of citable precision outside fenced code
     blocks — the same token regex and skips as
     check_numbers_in_response.py. A brief carries values only by pointing
     at where they live: the .numbers key and the file path. A number
     retyped into a brief is the value a downstream entry then retypes
     again (AGENT_CARD.md § Numbers: "never retype a number from a report
     or a brief").

Protocol (identical to check_direct_run.py): stdin is the PreToolUse JSON
with tool_name / tool_input; exit 0 allows, exit 2 denies with the reason
on stderr. Fails open on unparseable input.

    --selftest    canned prompts: two denied, one allowed; exits 0 when all
                  three behave.
"""
import json
import pathlib
import re
import sys

HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
from check_numbers_in_response import number_tokens, FENCE   # noqa: E402

KEY_SPAN = re.compile(r"`[^`\n]*[=|][^`\n]*`")

CARDS = ("AGENT_CARD.md", "AGENT_CLAUDE.md")


def verdict(prompt):
    """None to allow, else the denial text."""
    first = next((ln for ln in prompt.split("\n") if ln.strip()), "")
    if not any(c in first for c in CARDS):
        return ("Agent call denied by check_agent_brief.py: the brief's first "
                "non-empty line must name AGENT_CARD.md or AGENT_CLAUDE.md so the "
                "agent orients before anything else. Open the prompt with "
                "\"Read /Users/juliansambrano/GitHub/Primebeat_081426/AGENT_CARD.md "
                "first, then /Users/juliansambrano/GitHub/AGENT_CLAUDE.md.\"")
    # One skip beyond check_numbers_in_response's: a number inside an inline
    # backtick span shaped like a .numbers key (`...eps=0.001|M=16...`) is
    # the key being cited, which is exactly what the denial text asks for.
    keyish = [m.span() for m in KEY_SPAN.finditer(FENCE.sub("", prompt))]
    toks = []
    for tok, _, pos in number_tokens(prompt):
        if any(a <= pos < b for a, b in keyish):
            continue
        if tok not in toks:
            toks.append(tok)
    if toks:
        return ("Agent call denied by check_agent_brief.py: the brief retypes "
                + ", ".join(toks)
                + ". Cite .numbers keys and file paths; the agent reads the value "
                  "from the file. A number that must appear verbatim goes in a "
                  "fenced block.")
    return None


def selftest():
    good = ("Read /Users/juliansambrano/GitHub/Primebeat_081426/AGENT_CARD.md first.\n"
            "Read `ladder.k=10|eps=0.001|M=16|w=1/2.L_c` from "
            "analysis/2026-09-01/results/weil_Lc_mod.numbers; entry 301, line 40.\n"
            "```\nexpected 3.0703115 in the fence\n```\n")
    no_card = "Please look at the ladder.\nRead AGENT_CARD.md second.\n"
    retyped = ("Read AGENT_CLAUDE.md first.\nThe slope was 1.7712 and the tail 2.5e-9.\n")
    r_good, r_card, r_num = verdict(good), verdict(no_card), verdict(retyped)
    print("allow  ->", r_good)
    print("deny   ->", (r_card or "")[:80])
    print("deny   ->", (r_num or "")[:110])
    ok = (r_good is None and r_card is not None and r_num is not None
          and "1.7712" in r_num and "2.5e-9" in r_num)
    print("selftest", "OK" if ok else "FAILED")
    return 0 if ok else 1


def main():
    if "--selftest" in sys.argv:
        sys.exit(selftest())
    try:
        payload = json.load(sys.stdin)
    except Exception:
        sys.exit(0)
    if payload.get("tool_name") not in (None, "Agent"):
        sys.exit(0)
    prompt = (payload.get("tool_input") or {}).get("prompt") or ""
    if not prompt:
        sys.exit(0)
    why = verdict(prompt)
    if why is None:
        sys.exit(0)
    sys.stderr.write(why + "\n")
    sys.exit(2)


if __name__ == "__main__":
    main()
