"""The scaffold of 2 and 3 (EXPLORATORY), in Julian's two readings.
1. Halves: count 2 (row 1) and 3 (row 2) as 1/2 each; recompute the table exactly (fractions) to row 92: its zeros,
   which cells change, the edge signs.
2. The lattice: after 2 and 3 only the numbers 6k +- 1 can be prime; c(r) = slots in the block (2^(r-1), 2^r].
   Check c(r) = (2^(r-1) - 2 (-1)^r) / 3 for r >= 2, so a slot cell is (2^(r-1-d) - (-1)^r 2^(d+1)) / 3 when its
   window avoids row 1; split each zero into its slot cell and its primes->=5 cell; and along the slot table's
   balance line r = 2d + 2 compare the prime cell with the cells two rows either side at the same depth."""
import json, statistics as st
from fractions import Fraction as F
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92
def table(row):
    T = {}
    for r in range(1, M + 1): T[(r, 0)] = row[r]
    for d in range(1, M):
        for r in range(d + 1, M + 1): T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T
a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
h = list(a); h[1] = F(1, 2); h[2] = F(1, 2)
T = table(a); H = table(h)
zeros = lambda X: sorted([list(c) for c, v in X.items() if c[1] >= 1 and v == 0])
sg = lambda v: '+' if v > 0 else ('-' if v < 0 else '0')
ch = [c for c in T if T[c] != H[c]]
out = {"halves": {"zeros_true": zeros(T), "zeros_half": zeros(H), "cells_changed": len(ch),
                  "changed_edges_row_minus_depth": sorted(set(c[0] - c[1] for c in ch)),
                  "edge_signs_identical_to_depth_90": all(sg(T[(d + q, d)]) == sg(H[(d + q, d)]) for q in (1, 2) for d in range(1, 91)),
                  "edge1_first_true": [T[(d + 1, d)] for d in range(1, 9)], "edge1_first_half": [str(H[(d + 1, d)]) for d in range(1, 9)]}}
def cop6(x): return x - x // 2 - x // 3 + x // 6
c = [0] + [cop6(2 ** m) - cop6(2 ** (m - 1)) for m in range(1, M + 1)]
p5 = list(a); p5[1] -= 1; p5[2] -= 1
C = table(c); P = table(p5)
out["lattice"] = {"slots_rows_1_12": c[1:13], "formula_holds_rows_2_92": all(3 * c[m] == 2 ** (m - 1) - 2 * (-1) ** m for m in range(2, M + 1)),
    "cell_formula_holds": all(3 * C[(r, d)] == 2 ** (r - 1 - d) - (-1) ** r * 2 ** (d + 1) for r in range(3, M + 1) for d in range(1, r - 1)),
    "balance_line_slot_cells_zero_d_1_45": all(C[(2 * d + 2, d)] == 0 for d in range(1, 46)),
    "zeros_split": {f"{r}_{d}": {"true": T[(r, d)], "slots": C[(r, d)], "primes_ge5": P[(r, d)]} for (r, d) in ((2, 1), (4, 1), (8, 3), (20, 6))}}
rows = []
for d in range(1, 46):
    r = 2 * d + 2
    if r + 2 > M: break
    on = abs(T[(r, d)]); off = st.median([abs(T[(r + k, d)]) for k in (-2, -1, 1, 2) if r + k > d])
    rows.append((d, on / off))
out["balance_line"] = {"depths": len(rows), "ratio_d1_6": [round(q, 3) for _, q in rows[:6]],
                       "ratio_median": round(st.median([q for _, q in rows]), 3), "share_below_1": round(sum(q < 1 for _, q in rows) / len(rows), 2)}
json.dump(out, open("scaffold.json", "w"), indent=1); print(json.dumps(out, indent=1))
