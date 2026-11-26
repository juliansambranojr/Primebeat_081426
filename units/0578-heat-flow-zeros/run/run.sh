#!/bin/sh
# reads ../../../lean_stage3/checks/turingrun/zeros.txt for the check at lam = 0
python3 -I heatflow.py
# imports heatflow.py from this folder, so no -I
python3 collisions.py
