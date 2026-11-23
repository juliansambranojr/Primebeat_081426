#!/bin/sh
# pi(2^r) - li(2^r) at each doubling from the cache, r = 4..62
python3 doubling.py ../../../pi2n_cache.json doubling.json > doubling.log
