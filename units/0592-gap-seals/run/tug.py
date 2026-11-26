# Exploratory follow-up: every cell of the table to row 27 split into its twin primes and its lone
# primes; how often the two parts pull opposite ways, against a control with random primes in the
# twins' place (same count per row), and the deep balance (20,6) split. Writes tug.json.
import json, math, numpy as np
from math import comb
R = 27; X = 2**R
s = np.ones(X + 3, dtype=bool); s[:2] = False
for p in range(2, math.isqrt(X + 2) + 1):
    if s[p]: s[p*p::p] = False
P = np.nonzero(s[:X + 1])[0]
tw = s[P + 2] | s[np.maximum(P - 2, 0)]; tw[P < 5] = False
def rows(mask): return {r: int((mask & (P > 2**(r - 1)) & (P <= 2**r)).sum()) for r in range(1, R + 1)}
A = rows(np.ones(len(P), bool)); T = rows(tw)
rng = np.random.default_rng(0); m = np.zeros(len(P), bool); m[rng.choice(len(P), int(tw.sum()), replace=False)] = True
S = rows(m)
def cell(rw, r, d): return sum((-1)**k * comb(d, k) * rw.get(r - k, 0) for k in range(d + 1))
def opposite(part):
    o = c = 0; rat = []
    for r in range(4, R + 1):
        for d in range(1, r):
            t = cell(part, r, d); a = cell(A, r, d); l = a - t
            if t == 0 or l == 0: continue
            c += 1; o += ((t > 0) != (l > 0)); rat.append(abs(a) / (abs(t) + abs(l)))
    return c, o / c, float(np.median(rat))
c, ot, med = opposite(T); _, os_, _ = opposite(S)
out = {"cells": c, "twins_opposite_share": ot, "control_opposite_share": os_, "median_cell_over_parts": med,
       "deep_20_6_twins": cell(T, 20, 6), "deep_20_6_lone": cell(A, 20, 6) - cell(T, 20, 6)}
json.dump(out, open("tug.json", "w"), indent=1); print(out)
