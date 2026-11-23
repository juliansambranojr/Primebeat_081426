#!/bin/sh
# the count at row r from the primes up to row r/2, by Pascal level, with its roundings
python3 half.py ../../../pi2n_cache.json half.json > half.log
# the net rounding of the full sum, from the exact formula of unit 0481, against the count
python3 net.py ../../../pi2n_cache.json net.json > net.log
