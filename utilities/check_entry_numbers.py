#!/usr/bin/env python3
"""Check that numbers in a notebook entry match the .numbers keys they are cited by.

    python3 utilities/check_entry_numbers.py --entry N

The convention (notes/notes_format.md § Rule): a number is cited as a backticked
.numbers key followed by the value, `ladder.k=10|eps=0.01|M=16|w=1/2.L_c` 3.07,
and the value is read from the `.numbers` file that utilities/flatten_results.py
made from the results JSON. This script closes the loop: it finds the entry,
finds the .numbers files it cites (a `.numbers` path, or a `.json` path whose
sibling `.numbers` exists), and for every backticked token that could be a key
(contains a dot, `|` or `[`; is not a file path) looks the key up and compares the
nearest number after the token, in the same sentence, rounding-aware -- the
entry's `3.07` matches the file's `3.070311505664645`.

One line per key:
  OK          key found, number follows, matches at the entry's precision
  MISMATCH    key found, number follows, differs
  UNRESOLVED  key not in any cited .numbers file, no number follows, the value
              is a string, or the entry cites no .numbers file at all

Entries written before the convention show UNRESOLVED for every token; that is
the expected output, not a failure.

Exit 0 when no MISMATCH, 1 on any MISMATCH, 2 when the entry is not found
exactly once (a header can be quoted; fenced blocks are skipped) or on usage.
"""
import argparse, json, pathlib, re, sys
from decimal import Decimal

ROOT = pathlib.Path(__file__).resolve().parent.parent
NOTEBOOK = ROOT / "notes" / "lab_notebook_2.md"

# Copied from utilities/check_values.py (NUM, nums, matches). That module runs
# its whole paper check at import time and exits, so it cannot be imported.
NUM = re.compile(r"-?\d{1,3}(?:,\d{3})+(?:\.\d+)?|-?\d+(?:\.\d+)?(?:[eE]-?\d+)?")

def matches(want, have):
    """want appears in have, at want's own precision."""
    exp = want.as_tuple().exponent
    places = -exp if isinstance(exp, int) and exp < 0 else 0
    tol = Decimal(5).scaleb(-places - 1)      # half a unit in the last stated place
    return any(abs(v - want) <= tol for v in have)
# end of copy

FILE_EXT = re.compile(r"\.(?:py|md|json|numbers|log|txt|lean|csv)(?::\d[\d\-]*)?$")
PATH_PREFIX = ("analysis/", "results/", "preregs/", "papers/", "lean/",
               "lean_stage3/", "utilities/", "notes/", "imported/", "files (2)/")
CITED = re.compile(r"(?<![\w/.])((?:[\w\-]+/)*[\w\-]+\.(?:numbers|json))\b")
SENTENCE_END = re.compile(r"[.!?;](?=\s|$)|\n\s*\n")


def entry_text(n):
    """Body of `## ... Entry n ...` outside fences, or None. Exits 2 unless exactly one."""
    lines = NOTEBOOK.read_text(encoding="utf-8").split("\n")
    fence, heads = False, []
    for i, line in enumerate(lines):
        if line.startswith("```"):
            fence = not fence
            continue
        if not fence and re.match(rf"^## .*Entry {n}(?!\d)", line):
            heads.append(i)
    if len(heads) != 1:
        print(f"entry {n}: {len(heads)} header(s) found in {NOTEBOOK.relative_to(ROOT)}",
              file=sys.stderr)
        sys.exit(2)
    start = heads[0]
    fence, end = False, len(lines)
    for i in range(start + 1, len(lines)):
        if lines[i].startswith("```"):
            fence = not fence
        elif not fence and lines[i].startswith("## "):
            end = i
            break
    body = "\n".join(lines[start:end])
    return re.sub(r"```.*?```", "", body, flags=re.S)


def resolve(name):
    p = ROOT / name
    if p.is_file():
        return p
    hits = [q for q in ROOT.rglob(pathlib.PurePath(name).name) if q.is_file()]
    return hits[0] if len(hits) == 1 else None


def load_numbers(path):
    """{key: raw value text}; meta.* keys are indexed both with and without the prefix."""
    table = {}
    for line in path.read_text(encoding="utf-8").split("\n"):
        if not line or line.startswith("#") or "\t" not in line:
            continue
        k, v = line.split("\t", 1)
        table[k] = v
        if k.startswith("meta."):
            table.setdefault(k[5:], v)
    return table


def cited_numbers_files(text):
    files, notes = {}, []
    for name in dict.fromkeys(CITED.findall(text)):
        p = resolve(name)
        if p is None:
            notes.append(f"note      {name}: not found in repo")
            continue
        if p.suffix == ".json":
            p = p.with_suffix(".numbers")
            if not p.is_file():
                notes.append(f"note      {name}: no sibling .numbers "
                             f"(make it: python3 utilities/flatten_results.py {name})")
                continue
        files[str(p.relative_to(ROOT))] = load_numbers(p)
    return files, notes


def candidates(text):
    """(token, end offset) for each backticked token that could be a .numbers key."""
    out = []
    for m in re.finditer(r"`([^`\n]+)`", text):
        tok = m.group(1).strip()
        if not any(c in tok for c in ".|["):
            continue
        if FILE_EXT.search(tok) or tok.startswith(PATH_PREFIX) or tok.startswith("/"):
            continue
        out.append((tok, m.end()))
    return out


def number_after(text, pos):
    """Nearest number after pos, within the sentence and before the next backtick."""
    stop = len(text)
    for rx in (SENTENCE_END, re.compile("`")):
        m = rx.search(text, pos)
        if m:
            stop = min(stop, m.start())
    m = NUM.search(text, pos, stop)
    return m.group(0) if m else None


def main(argv):
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--entry", type=int, required=True, help="entry number in notes/lab_notebook_2.md")
    a = ap.parse_args(argv)

    text = entry_text(a.entry)
    files, notes = cited_numbers_files(text)
    for line in notes:
        print(line)
    if not files:
        print(f"note      entry {a.entry} cites no .numbers file (or .json with a sibling)")

    counts = {"OK": 0, "MISMATCH": 0, "UNRESOLVED": 0}
    def say(status, tok, why=""):
        counts[status] += 1
        print(f"{status:<10} {tok}" + (f"  {why}" if why else ""))

    for tok, end in candidates(text):
        hits = [(f, t[tok]) for f, t in files.items() if tok in t]
        if not hits:
            say("UNRESOLVED", tok, "key not in any cited .numbers file")
            continue
        fname, raw = hits[0]
        found = number_after(text, end)
        if found is None:
            say("UNRESOLVED", tok, f"no number follows in the sentence  (file: {raw})")
            continue
        if raw in ("true", "false", "null"):
            # a literal cited by key: the sentence must carry the same literal
            seg = text[end:end + 80].lower()
            say("OK" if raw in seg else "MISMATCH", tok, f"{raw}")
            continue
        try:
            have = Decimal(raw)
        except Exception:
            say("UNRESOLVED", tok, f"value is not a number  (file: {raw[:60]})")
            continue
        want = Decimal(found.replace(",", ""))
        if matches(want, {have}):
            say("OK", tok, f"{found}  ({fname}: {raw})")
        else:
            say("MISMATCH", tok, f"entry says {found}, {fname} has {raw}")

    print(f"\nentry {a.entry}: {counts['OK']} OK, {counts['MISMATCH']} MISMATCH, "
          f"{counts['UNRESOLVED']} UNRESOLVED; .numbers files: "
          + (", ".join(files) if files else "none"))
    return 1 if counts["MISMATCH"] else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
