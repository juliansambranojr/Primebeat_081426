# Unit 0309's runnable. `lab run` invokes this as `/bin/sh -e run.sh` with the
# working directory set to this run/ directory.
#
# Phase 2c's figures are structural counts — findings, decisions, corrections —
# read out of the transcript, and the test count from pytest. figures.py
# recomputes every number the prose states.
echo "recomputing unit 0309's figures"
python3 figures.py
echo "done"
