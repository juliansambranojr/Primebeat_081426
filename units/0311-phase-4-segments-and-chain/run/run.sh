# Unit 0311's runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory.
#
# Phase 4's figures are structural counts — segments in CHAIN.tsv, tests in
# test_phase4.py, lines in chain.py, total test count from pytest — recomputed
# from source by figures.py.
echo "recomputing unit 0311's figures"
python3 figures.py
echo "done"
