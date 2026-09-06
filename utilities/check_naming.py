#!/usr/bin/env python3
"""
check_naming.py -- hold the O-series naming convention that CLAUDE.md
carried as prose until 2026-09-06.

The O-series is one series.  O5, O6 and O7 were partially renamed to
05_, 06_, 07_; their docstrings still say O5/O6/O7, and the leading digit
is why 07_alpha_depth_trend.py imports 05 via importlib rather than by
name.  Nothing is renamed further in either direction without an
instrument-fix entry; the prereg cites 07_alpha_depth_trend.py by path.

Checks, exit 1 if any fails:

  KEEP     05_cross_depth_alpha.py, 06_comb_corrected_radius.py,
           07_alpha_depth_trend.py exist
  NO-BACK  no O5_*.py, O6_*.py, O7_*.py has appeared (a rename back)
  NO-MORE  no other 0N_*.py has appeared (a rename forward)
  IMPORT   07_alpha_depth_trend.py still imports 05 via importlib
  PREREG   some file under preregs/ cites 07_alpha_depth_trend.py

Read-only over the tree.
"""
import glob
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
KEEP = ["05_cross_depth_alpha.py", "06_comb_corrected_radius.py", "07_alpha_depth_trend.py"]


def main():
    os.chdir(ROOT)
    fails = []
    for f in KEEP:
        if not os.path.exists(f):
            fails.append(f"KEEP     {f} missing")
    back = sorted(glob.glob("O5_*.py") + glob.glob("O6_*.py") + glob.glob("O7_*.py"))
    if back:
        fails.append(f"NO-BACK  renamed back: {', '.join(back)}")
    more = sorted(f for f in glob.glob("0[0-9]_*.py") if f not in KEEP)
    if more:
        fails.append(f"NO-MORE  renamed forward: {', '.join(more)}")
    if os.path.exists(KEEP[2]):
        src = open(KEEP[2], encoding="utf-8").read()
        if "importlib" not in src or "05_cross_depth_alpha" not in src:
            fails.append("IMPORT   07_alpha_depth_trend.py no longer imports 05 via importlib")
    cited = [p for p in glob.glob("preregs/*") if os.path.isfile(p)
             and "07_alpha_depth_trend.py" in open(p, encoding="utf-8", errors="ignore").read()]
    if not cited:
        fails.append("PREREG   no file under preregs/ cites 07_alpha_depth_trend.py")
    if fails:
        print("naming: REFUSED")
        for f in fails:
            print("  " + f)
        sys.exit(1)
    print("naming: OK")


if __name__ == "__main__":
    main()
