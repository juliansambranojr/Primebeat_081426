"""The coin turnover on the exact table (EXPLORATORY). Each cell is its parent (r,d-1) less its parent (r-1,d-1);
when the parents have opposite signs the cell is not zero (lean/CornerSign.lean, ne_zero_of_opposite). On unit
0597's corner (rows 12..92, 2r < 7d, depth >= 2) and on the rest of rows 12..92: how often a cell keeps the sign of
the cell one depth up, how often it keeps the sign of the row above, how often its two parents differ in sign, and
the same two persistence shares for parity."""
import json
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92; a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
T = {}
for r in range(1, M + 1): T[(r, 0)] = a[r]
for d in range(1, M):
    for r in range(d + 1, M + 1): T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
sg = lambda v: (v > 0) - (v < 0)
def share(cells, f):
    xs = [f(c) for c in cells]; xs = [x for x in xs if x is not None]; return round(sum(xs) / len(xs), 4), len(xs)
regions = {"corner": [(r, d) for r in range(12, M + 1) for d in range(2, r) if 2 * r < 7 * d],
           "outside": [(r, d) for r in range(12, M + 1) for d in range(2, r) if 2 * r >= 7 * d]}
out = {}
for name, cells in regions.items():
    o = {"cells": len(cells)}
    o["sign_keeps_depth_above"], _ = share(cells, lambda c: sg(T[c]) == sg(T[(c[0], c[1] - 1)]) if T[c] and T[(c[0], c[1] - 1)] else None)
    o["sign_keeps_row_above"], _ = share(cells, lambda c: sg(T[c]) == sg(T[(c[0] - 1, c[1])]) if c[0] - 1 > c[1] and T[c] and T[(c[0] - 1, c[1])] else None)
    o["parents_opposite"], _ = share(cells, lambda c: sg(T[(c[0], c[1] - 1)]) != sg(T[(c[0] - 1, c[1] - 1)]) if T[(c[0], c[1] - 1)] and T[(c[0] - 1, c[1] - 1)] else None)
    o["parity_keeps_depth_above"], _ = share(cells, lambda c: (T[c] - T[(c[0], c[1] - 1)]) % 2 == 0)
    o["parity_keeps_row_a_r"], _ = share(cells, lambda c: (T[c] - a[c[0]]) % 2 == 0)
    out[name] = o
json.dump(out, open("sign.json", "w"), indent=1); print(json.dumps(out, indent=1))
