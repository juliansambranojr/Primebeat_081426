#!/usr/bin/env python3
"""check_port — the copies in lean_stage3/Stage3/TablePort/ against lean/.

Unit 0423 copied the ten modules of the table's tree that its gate depends on
onto Stage 3's toolchain, so the route and the gate compose in one tree; unit
0426 added the three mode modules (EulerFactorChain, Chain, Superposition). A
copy is only worth what its original is: if either side is edited and the
other is not, the two trees say different things under one name.

For each module: rewrite the original's `import <Module>` lines to
`import Stage3.TablePort.<Module>`, diff against the copy, and compare that
diff with the one recorded in utilities/port_baseline/<Module>.diff. Eight
baselines are empty. Two hold the proof steps a newer Mathlib forced
(MainTerm, Expansion); no statement differs. Any other difference: exit 1.

After a deliberate change to both sides:  python3 utilities/check_port.py --rebase
"""
import difflib, pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
MODULES = ["Construction", "Zeros", "ZerosStencil", "Nonvanishing", "MainTerm",
           "Expansion", "RelativeGate", "RelativeLi", "Interpolant", "RouteCell",
           "EulerFactorChain", "Chain", "Superposition"]
BASE = ROOT / "utilities" / "port_baseline"
PAT = re.compile(r"^import (%s)$" % "|".join(MODULES), re.M)


def current_diff(m):
    orig = PAT.sub(r"import Stage3.TablePort.\1", (ROOT / "lean" / f"{m}.lean").read_text())
    copy = (ROOT / "lean_stage3" / "Stage3" / "TablePort" / f"{m}.lean").read_text()
    return "".join(difflib.unified_diff(orig.splitlines(True), copy.splitlines(True),
                                        f"lean/{m}.lean", f"TablePort/{m}.lean", n=0))


def main():
    rebase = "--rebase" in sys.argv
    BASE.mkdir(exist_ok=True)
    bad = 0
    for m in MODULES:
        d = current_diff(m)
        f = BASE / f"{m}.diff"
        if rebase:
            f.write_text(d)
        want = f.read_text() if f.exists() else None
        changed = sum(1 for ln in d.splitlines()
                      if ln[:1] in "+-" and not ln.startswith(("+++", "---")))
        if d == want:
            print(f"PORT OK      {m:<13} {changed} line(s) differ, as recorded")
        else:
            bad += 1
            print(f"PORT DRIFT   {m}: the copy and the original differ in a way not recorded")
            print(d if want is None else "".join(difflib.unified_diff(
                want.splitlines(True), d.splitlines(True), "recorded", "now", n=0)))
    print(f"\n{bad} drifted module(s)")
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
