#!/bin/sh
# part A: the multiplier identity on the tree's window; part B: a planted cluster on the tree's term;
# part C: the price of a uniform L(eps, T), gated on unit 0366's recorded cells
python3 identity.py identity.json > identity.log
python3 planted.py zeros600.txt planted.json > planted.log
python3 price.py ../../0366-rung5-gap-dependent-l-priced-on-the-two-sideband-term/values.tsv price.json > price.log
