#!/bin/sh
# part A: the two-sideband sign on the tree's identity; part B: the gap-dependent range
python3 two_sideband.py zeros600.txt two_sideband.json > two_sideband.log
python3 gap_price.py gap_price.json > gap_price.log
