#!/bin/sh
# The locked run of preregs/induction_bump_difference_table_v1_20260907.md.
# 1. twelve trainings, two at a time (as run on 2026-09-07, 17:51-19:31 UTC):
#      for s in 1 2 3 4 5 6; do
#        python analysis/2026-09-07/induction_bump_train.py --layers 2 --seed $s --steps 32768 &
#        python analysis/2026-09-07/induction_bump_train.py --layers 1 --seed $s --steps 32768 &
#        wait; done
#    The raw per-step curves are run/raw/induction_bump_L{1,2}_seed{1..6}.json.gz
#    (gzipped so that `lab values` does not flatten 1.5 million leaves).
# 2. the analyzer, unmodified since the lock, on the ungzipped raw files:
cd "$(dirname "$0")" && T=$(mktemp -d) && for f in raw/*.json.gz; do gunzip -c "$f" > "$T/$(basename "${f%.gz}")"; done
../../../.venv-torch/bin/python ../../../analysis/2026-09-07/induction_bump_table.py --results "$T" --out induction_bump_table.json
../../../.venv-torch/bin/python ../../../analysis/2026-09-07/induction_bump_table.py --power --power-trials 200 --power-amps 0.5,1,2,4 --out induction_bump_power.json
