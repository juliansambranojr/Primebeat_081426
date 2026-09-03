# Unit 0312's runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory.
#
# Phase 5's figures are structural counts — lines in cite/brief/report modules,
# tests in test_phase5.py, total test count from pytest — recomputed from source
# by figures.py.
echo "recomputing unit 0312's figures"
python3 figures.py
echo "done"
