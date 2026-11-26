# Exploratory: the depth-6 cell with its top fixed at 2^20, as the base b of the table moves
# continuously from 1.9 to 2.1; and the base-4 table (the shrinking quarter table read upward) to 4^13.
import json, math, numpy as np
from math import comb
X = 4**13
s = np.ones(X + 1, dtype=bool); s[:2] = False
for p in range(2, math.isqrt(X) + 1):
    if s[p]: s[p*p::p] = False
pc = np.cumsum(s)
pi = lambda y: int(pc[int(math.floor(y))]) if y >= 1 else 0
def cell(b, top, dd): return sum((-1)**k * comb(dd, k) * (pi(top / b**k) - pi(top / b**(k + 1))) for k in range(dd + 1))
bs = np.linspace(1.9, 2.1, 4001); v = np.array([cell(b, 2**20, 6) for b in bs])
crossings = int(np.sum(np.sign(v[:-1]) * np.sign(v[1:]) <= 0))
row = {r: int(pc[4**r] - pc[4**(r - 1)]) for r in range(1, 14)}
z4 = sum(1 for r in range(2, 14) for dd in range(1, r) if sum((-1)**k * comb(dd, k) * row[r - k] for k in range(dd + 1)) == 0)
out = {"base2_cell_20_6": cell(2, 2**20, 6), "crossings_b_1_9_to_2_1": crossings, "base4_zero_cells": z4}
json.dump(out, open("bases.json", "w"), indent=1); print(out)
