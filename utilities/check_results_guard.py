#!/usr/bin/env python3
"""check_results_guard — is every results writer clobber-safe?

A script that writes `results/X.json` directly overwrites the previous
run. That is not hypothetical: O63, O65 and O66 each lost run 1 that
way, and git did not save them — those files carry one commit each,
because the clobber happened before anything was committed. Their run-1
numbers survive only inside the run-1 logs.

This gate scans every `O*.py`, `0*.py` and `t*.py` at the project root
for a write into `results/` and reports whether it routes through
`utilities/resultsguard.guarded_write`, which archives the prior run
first.

MODES.
  --report   (default) list the status of every writer, exit 0 always.
             This is the mode to use while the retrofit is in progress.
  --enforce  exit 1 if any writer is unguarded. Flip to this once the
             sweep is complete; wire it beside check_refs and
             check_values then.
  --new-only exit 1 only for scripts newer than the guard itself, so a
             NEW script cannot ship unguarded while the legacy sweep is
             still outstanding.

A script that writes no results JSON is not a writer and is skipped.

DETECTION NOTE. The first version of this gate matched `json.dump(` and
missed `json.dumps(...)` piped through `pathlib.write_text` — which is
exactly how O66, one of the three scripts that motivated the gate,
writes its results. Tested against the motivating case before being
trusted; the pattern now covers dump/dumps, write_text, and a bare
open(..., "w").
"""
import argparse
import glob
import os
import re
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(_HERE)
GUARD = os.path.join(_HERE, "resultsguard.py")

WRITES = re.compile(r"json\.dumps?\s*\(|_write_results\s*\(|"
                    r"guarded_write\s*\(|write_text\s*\(|"
                    r"open\s*\([^)]*['\"]w['\"]")
GUARDED = re.compile(r"guarded_write")
MENTIONS_RESULTS = re.compile(r"results[/\\]|[\"']results[\"']|"
                              r"DEFAULT_RESULTS_DIR|DEFAULT_OUT_JSON")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--report", action="store_true", default=True)
    g.add_argument("--enforce", action="store_true")
    g.add_argument("--new-only", action="store_true")
    args = ap.parse_args()

    guard_mtime = os.path.getmtime(GUARD) if os.path.exists(GUARD) else 0.0
    pats = ["O*.py", "0*.py", "t*.py"]
    files = sorted({f for p in pats for f in glob.glob(os.path.join(ROOT, p))})

    guarded, unguarded, newer_unguarded, skipped = [], [], [], []
    for f in files:
        try:
            src = open(f, encoding="utf-8").read()
        except Exception:
            continue
        name = os.path.basename(f)
        if not (WRITES.search(src) and MENTIONS_RESULTS.search(src)):
            skipped.append(name)
            continue
        if GUARDED.search(src):
            guarded.append(name)
        else:
            unguarded.append(name)
            if os.path.getmtime(f) > guard_mtime:
                newer_unguarded.append(name)

    print(f"results writers: {len(guarded) + len(unguarded)}   "
          f"guarded {len(guarded)}   unguarded {len(unguarded)}   "
          f"(non-writers skipped: {len(skipped)})")
    if unguarded:
        print("\nUNGUARDED — a re-run overwrites the previous results file:")
        for n in unguarded:
            flag = "  <-- newer than the guard" if n in newer_unguarded else ""
            print(f"   {n}{flag}")
    if guarded:
        print(f"\nGUARDED: {', '.join(guarded)}")

    if args.enforce and unguarded:
        print(f"\nFAIL (--enforce): {len(unguarded)} unguarded writer(s).")
        sys.exit(1)
    if args.new_only and newer_unguarded:
        print(f"\nFAIL (--new-only): {len(newer_unguarded)} writer(s) newer "
              f"than the guard are unguarded. New scripts must use "
              f"utilities.resultsguard.guarded_write.")
        sys.exit(1)
    print("\nOK" + (" (report mode; use --enforce once the retrofit lands)"
                    if unguarded else ""))
    sys.exit(0)


if __name__ == "__main__":
    main()
