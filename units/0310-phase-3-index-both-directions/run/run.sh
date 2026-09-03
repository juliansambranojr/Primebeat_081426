# Unit 0310's runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory.
#
# Phase 3's figures are structural counts — keys in INDEX-values.tsv, units in
# INDEX.md, tests in test_phase3.py, total test count from pytest — recomputed
# from source by figures.py.
echo "recomputing unit 0310's figures"
python3 figures.py
echo "done"
