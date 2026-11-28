"""The cells in binary (EXPLORATORY; the look that preceded preregs/two_adic_power_depths_v1_20261128.md, kept as it
ran in analysis/2026-11-28/two_adic_look/). v2 = trailing zero bits; a zero cell has v2 = infinity. Real table against
200 tables whose rows' low 20 bits are random (random.seed 5). Cells: rows <= 92 with lowest row r - d >= 26."""
import json, random
from collections import Counter
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92; a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
def table(row):
    T = {}
    for r in range(1, M + 1): T[(r, 0)] = row[r]
    for d in range(1, M):
        for r in range(d + 1, M + 1): T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T
def v2(n): return None if n == 0 else (n & -n).bit_length() - 1
T = table(a)
cells = [(r, d) for r in range(2, M + 1) for d in range(1, r) if r - d >= 26]
real = [v2(T[c]) for c in cells]
random.seed(5); NULL = 200; MASK = (1 << 20) - 1
hr = [0] * 25; hn = [0] * 25; pdr = {}; pdn = {}
for c, v in zip(cells, real): hr[min(v, 24)] += 1; pdr.setdefault(c[1], []).append(v)
for t in range(NULL):
    row = [0] + [(a[m] & ~MASK) | random.getrandbits(20) if a[m] > MASK else a[m] for m in range(1, M + 1)]
    Tn = table(row)
    for c in cells:
        v = v2(Tn[c]); v = 24 if v is None else min(v, 24); hn[v] += 1; pdn.setdefault(c[1], []).append(v)
hn = [h / NULL for h in hn]
dev = []
for d in sorted(pdr):
    r_ = pdr[d]; n_ = pdn[d]; mr = sum(r_) / len(r_); mn = sum(n_) / len(n_)
    sd = (sum((x - mn) ** 2 for x in n_) / len(n_)) ** 0.5 / len(r_) ** 0.5
    dev.append(((mr - mn) / sd if sd > 0 else 0, d, len(r_), round(mr, 2), round(mn, 2)))
dev.sort(); zs = [x[0] for x in dev]
cnt = Counter(T[c] % 16 for c in cells); exp = len(cells) / 16
ones = tot = 0
for c in cells:
    n = abs(T[c]); L = n.bit_length()
    if L >= 24:
        for b in range(4, L - 4): ones += (n >> b) & 1; tot += 1
out = {"cells": len(cells), "zeros_among_cells": sum(v is None for v in real),
       "hist_real": {str(k): hr[k] for k in range(13)}, "hist_null_mean": {str(k): round(hn[k], 1) for k in range(13)},
       "v2_ge_10": {"real": sum(v >= 10 for v in real), "null_mean": round(sum(hn[10:]), 1)},
       "per_depth_top3": [{"d": x[1], "z": round(x[0], 2), "cells": x[2], "real": x[3], "null": x[4]} for x in dev[-3:]],
       "per_depth_bottom3": [{"d": x[1], "z": round(x[0], 2), "cells": x[2], "real": x[3], "null": x[4]} for x in dev[:3]],
       "per_depth_z": {"depths": len(zs), "mean": round(sum(zs) / len(zs), 2), "rms": round((sum(z * z for z in zs) / len(zs)) ** 0.5, 2)},
       "mod16_chi2": round(sum((cnt[i] - exp) ** 2 / exp for i in range(16)), 1), "middle_bits_ones": round(ones / tot, 4), "middle_bits": tot,
       "zero_neighbours": {f"{z}": [[list(c), T[c], v2(T[c])] for c in [(z[0] + i, z[1] + j) for i in (-1, 0, 1) for j in (-1, 0, 1) if (i, j) != (0, 0)] if c in T and c[1] >= 1]
                           for z in ((8, 3), (20, 6))}}
json.dump(out, open("bits.json", "w"), indent=1); print(json.dumps(out, indent=1))
