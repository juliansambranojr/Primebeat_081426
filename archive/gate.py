#!/usr/bin/env python3
"""Report references broken since the baseline. Wired to PostToolUse on edits.

Prints nothing when the tree is no worse than utilities/refs_baseline.txt, so it
is silent in the normal case and speaks only when an edit broke something.
Never blocks -- the git pre-commit hook is the block. This is the early warning.
"""
import pathlib, subprocess, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
base = ROOT / "utilities/refs_baseline.txt"

def broken(script):
    r = subprocess.run([sys.executable, str(ROOT / "utilities" / script)],
                       capture_output=True, text=True, cwd=ROOT)
    return r.stdout.splitlines()

refs = sorted(l for l in broken("check_refs.py") if l.startswith("BROKEN"))
known = sorted(base.read_text().splitlines()) if base.exists() else []
new = [l for l in refs if l not in known]
vals = [l for l in broken("check_values.py") if l.startswith("MISMATCH")]

if new or vals:
    print("gate: an edit broke something not in the baseline", file=sys.stderr)
    for l in new + vals:
        print("  " + l, file=sys.stderr)
    print("  fix it, or: python3 utilities/check_refs.py | grep '^BROKEN' | sort "
          "> utilities/refs_baseline.txt", file=sys.stderr)
sys.exit(0)          # advisory only; pre-commit is the gate that blocks
