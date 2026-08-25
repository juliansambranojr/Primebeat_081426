#!/usr/bin/env python3
"""check_weld — the toolchain weld is textual; this makes drift break a gate.

lean_stage3/ (toolchain v4.32.2, PNT+ dependency) composes with the bench
tree lean/ (v4.28.0) by statement identity: definitions shared across the
weld must be character-level copies. The kernel checks neither direction
until the toolchains converge, so this script is the only thing standing
between "identical statements" and silent drift.

For each (name, file_a, file_b) below: extract the full `def <name>` block
from both files (from the def line to the first line that is not a
continuation), compare after stripping trailing whitespace. Any difference
is a broken weld: exit 1 and print both blocks.
"""
import pathlib, re, sys

_HERE = pathlib.Path(__file__).resolve().parent.parent

WELDS = [
    ("StmtSchoenfeldWindow",
     _HERE / "lean" / "Nonvanishing.lean",
     _HERE / "lean_stage3" / "Stage3.lean"),
]


def extract_def(path, name):
    text = path.read_text()
    lines = text.splitlines()
    starts = [i for i, ln in enumerate(lines)
              if re.match(rf'^def {re.escape(name)}\b', ln)]
    if len(starts) != 1:
        sys.exit(f"WELD ERROR: {path} has {len(starts)} defs named {name}")
    i = starts[0]
    block = [lines[i].rstrip()]
    for ln in lines[i + 1:]:
        if ln.strip() == "" or re.match(r'^\S', ln):
            break
        block.append(ln.rstrip())
    return "\n".join(block)


def main():
    broken = 0
    for name, fa, fb in WELDS:
        a, b = extract_def(fa, name), extract_def(fb, name)
        if a == b:
            print(f"WELD OK      {name}  ({fa.name} == {fb.name})")
        else:
            broken += 1
            print(f"WELD BROKEN  {name}")
            print(f"--- {fa}\n{a}\n--- {fb}\n{b}")
    print(f"\n{broken} broken weld(s)")
    sys.exit(1 if broken else 0)


if __name__ == "__main__":
    main()
