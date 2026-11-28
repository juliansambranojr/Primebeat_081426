"""The zero cells of the b-adic tables (EXPLORATORY). Row r of base b is pi(b^r) - pi(b^(r-1)); a cell is the
d-th backward difference. Exact prime counts: base 2 from pi_2pow.txt (rows to 92), bases 4 and 8 read off it,
base 3 from pi3n_cache.json (rows to 41, from O27), bases 5, 6, 7, 9, 10 by Lucy's method (lucy_pi.c) for every
power up to 10^13. Also checks that every base-4 cell is sum_j C(d+1, j) times the base-2 cell (2k - j, d)."""
import json, subprocess
from math import comb
pi2 = [int(x) for x in open('pi_2pow.txt')]
pi3 = json.load(open('pi3n_cache.json'))
P = {2: pi2, 3: [pi3[str(k)] for k in range(42)], 4: [pi2[2 * k] for k in range(47)], 8: [pi2[3 * k] for k in range(31)]}
for b in (5, 6, 7, 9, 10):
    L = [0]; r = 1
    while b ** r <= 10 ** 13:
        L.append(int(subprocess.run(['./lucy_pi', str(b ** r)], capture_output=True, text=True, check=True).stdout)); r += 1
    P[b] = L
checks = {"pi_1e6": int(subprocess.run(['./lucy_pi', '1000000'], capture_output=True, text=True).stdout),
          "pi_2pow20_matches_list": int(subprocess.run(['./lucy_pi', str(2 ** 20)], capture_output=True, text=True).stdout) == pi2[20],
          "pi_3pow20_matches_cache": int(subprocess.run(['./lucy_pi', str(3 ** 20)], capture_output=True, text=True).stdout) == pi3["20"]}
def table(pi):
    M = len(pi) - 1; a = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]; T = {}
    for r in range(1, M + 1): T[(r, 0)] = a[r]
    for d in range(1, M):
        for r in range(d + 1, M + 1): T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T, M, a
out = {"checks": checks, "bases": {}}
for b in sorted(P):
    T, M, a = table(P[b])
    Z = sorted(c for c, v in T.items() if c[1] >= 1 and v == 0)
    out["bases"][str(b)] = {"rows": M, "zeros": len(Z), "zero_cells": [list(z) for z in Z],
        "windows": [[b ** (r - d - 1), b ** r] for r, d in Z], "first_rows": a[1:5]}
T2, _, _ = table(pi2); T4, K, _ = table(P[4]); ok = tot = 0
for k in range(2, K + 1):
    for d in range(0, k):
        if 2 * k - (d + 1) - d < 1: continue
        s = sum(comb(d + 1, j) * T2[(2 * k - j, d)] for j in range(d + 2) if (2 * k - j, d) in T2 and 2 * k - j > d)
        tot += 1; ok += (s == T4[(k, d)])
out["base4_as_base2_sum"] = {"cells": tot, "hold": ok}
json.dump(out, open("census.json", "w"), indent=1); print(json.dumps(out, indent=1))
