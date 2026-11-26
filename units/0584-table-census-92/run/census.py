# Exploratory: every cell of the exact dyadic prime difference table for rows 1..92,
# T[0][r] = pi(2^r) - pi(2^(r-1)), T[d][r] = T[d-1][r] - T[d-1][r-1], from the OEIS
# b-file of pi(2^n) at the repo root (../../../b007053.txt), cross-checked against the
# repo's own cache (../../../pi2n_cache.json) on the rows both hold.
import json
pi = {}
for l in open("../../../b007053.txt"):
    l = l.strip()
    if l and not l.startswith("#"):
        n, v = l.split()[:2]; pi[int(n)] = int(v)
cache = {int(k): v for k, v in json.load(open("../../../pi2n_cache.json")).items()}
R = max(k for k in pi if all(j in pi for j in range(k + 1)))
P = {r: pi[r] - pi[r - 1] for r in range(1, R + 1)}
T = [dict(P)]
for d in range(1, R):
    T.append({r: T[d - 1][r] - T[d - 1][r - 1] for r in range(d + 1, R + 1)})
zeros = [[r, d] for d in range(R) for r in sorted(T[d]) if T[d][r] == 0]
d6 = {r: T[6][r] for r in range(7, R + 1)}
res = {"rows": R, "cells": sum(len(t) for t in T), "zeros": zeros,
       "cache_rows_compared": len([k for k in cache if k in pi]),
       "cache_agrees": all(pi[k] == cache[k] for k in cache if k in pi),
       "depth6_negative_rows": [r for r in d6 if d6[r] < 0],
       "depth6_zero_rows": [r for r in d6 if d6[r] == 0],
       "depth6_positive_from": min(r for r in d6 if all(d6[q] > 0 for q in d6 if q >= r))}
json.dump(res, open("census.json", "w"), indent=1)
print(res)
