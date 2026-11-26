#!/bin/sh
# A rerun of the locked test (preregs/golden_step_basin_v1_20261126.md) inside the
# unit; the scripts are byte-identical to the ones at the repo root and deterministic.
# The outputs are compared with results/O98_golden_step_*.json at the root.
mkdir -p results
# the power script imports the test script from this folder, so no -I
python3 O98_golden_step_power.py
python3 O98_golden_step_basin.py
mv results/O98_golden_step_basin.json results.json
mv results/O98_golden_step_power.json power.json
rmdir results
