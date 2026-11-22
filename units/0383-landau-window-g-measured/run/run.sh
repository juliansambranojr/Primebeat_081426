#!/bin/sh
# G(y) exactly from a sieve to 1e8, against the bench's zeros, with the criterion's windows
python3 gmeasure.py zeros600.txt gmeasure.json > gmeasure.log
