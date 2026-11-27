"""Exact certificates for the corner (Julian: we have exact pieces). EXPLORATORY.
On unit 0597's corner of the true table (rows 12..92, 2r < 7d), exact integer cells from the pi list.
 1. Lucas: cell mod p = sum over i with C(d,i) != 0 mod p of (-1)^i C(d,i) N(r-i) mod p. Every nonzero integer has a
    prime p not dividing it, so the content is the support: how many rows the mod-p certificate reads
    (prod of (base-p digit + 1)). For each cell: the smallest certifying p and its support.
 2. Weighted prime count: cell = P - Q, P the even-i binomial mass of the rows, Q the odd. The imbalance
    |P - Q| / (P + Q) is the relative precision any count of the two sides must reach.
 3. Overlap with the beat: the cells the comb's leader loses (unit 0613) against the certificates."""
import json, math
import numpy as np
from math import comb
from mpmath import mp, mpc, ei, riemannr, mpf
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92
N = [0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)]
cells = [(r, d) for r in range(12, M + 1) for d in range(1, r) if 2 * r < 7 * d]
def cell(r, d): return sum((-1) ** i * comb(d, i) * N[r - i] for i in range(d + 1))
def support(d, p):
    s = 1
    while d: s *= d % p + 1; d //= p
    return s
primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
vals, minp, sup, imb, rows = [], [], [], [], []
for r, d in cells:
    c = cell(r, d); vals.append(c)
    p0 = next((p for p in primes if c % p), None); minp.append(p0)
    sup.append(support(d, p0) if p0 else None)
    P = sum(comb(d, i) * N[r - i] for i in range(0, d + 1, 2)); Q = sum(comb(d, i) * N[r - i] for i in range(1, d + 1, 2))
    imb.append(abs(P - Q) / (P + Q)); rows.append(d + 1)
n = len(cells)
out = {"cells": n, "zero_cells": sum(1 for v in vals if v == 0)}
from collections import Counter
cnt = Counter(minp)
out["smallest_certifying_prime"] = {str(p): cnt.get(p, 0) for p in primes[:6]}
out["uncertified_by_primes_to_47"] = cnt.get(None, 0)
sup2 = [support(d, 2) for r, d in cells]
out["mod2_certified"] = sum(1 for v in vals if v % 2)
out["support_median_smallest_p"] = float(np.median([s for s in sup if s]))
out["rows_median"] = float(np.median(rows))
out["support_over_rows_median"] = round(float(np.median([s / w for s, w in zip(sup, rows) if s])), 4)
out["mod2_support_le_8"] = sum(1 for (r, d), v in zip(cells, vals) if v % 2 and support(d, 2) <= 8)
lo = np.array(imb)
out["imbalance"] = {"median": float(f"{np.median(lo):.3e}"), "max": float(f"{lo.max():.3e}"), "min": float(f"{lo.min():.3e}"),
                    "share_below_1e-6": round(float((lo < 1e-6).mean()), 3)}
# 3. overlap with the beat's trouble cells
mp.dps = 20; L2 = math.log(2)
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
def table(row):
    T = np.zeros((M + 1, M + 1), dtype=row.dtype); T[:, 0] = row
    for dd in range(1, M + 1):
        T[1:, dd] = T[1:, dd - 1] - T[:-1, dd - 1]; T[0, dd] = T[0, dd - 1]
    return T
Rw = np.array([0.0] + [float(riemannr(mpf(2) ** m) - riemannr(mpf(2) ** (m - 1))) for m in range(1, M + 1)])
Ts = table(Rw)
lead = np.array([int(np.argmax(d * np.log(f) - np.log(g))) for d in di])
Cl = np.zeros(n)
for k in sorted(set(lead.tolist())):
    rho = mpc(0.5, g[k]); prev = 0; row = np.zeros(M + 1)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); row[m] = -2 * float((cur - prev).real); prev = cur
    T = table(row); sel = lead == k; Cl[sel] = T[ri[sel], di[sel]]
true = np.array([float(v) for v in vals])
trouble = np.abs(Cl) < np.abs(true - Ts[ri, di] - Cl)
odd = np.array([v % 2 == 1 for v in vals])
mp_ = np.array([p if p else 99 for p in minp])
out["overlap"] = {"trouble_cells": int(trouble.sum()),
                  "mod2_share_trouble": round(float(odd[trouble].mean()), 3), "mod2_share_other": round(float(odd[~trouble].mean()), 3),
                  "minp_gt3_share_trouble": round(float((mp_[trouble] > 3).mean()), 3), "minp_gt3_share_other": round(float((mp_[~trouble] > 3).mean()), 3),
                  "imbalance_median_trouble": float(f"{np.median(lo[trouble]):.3e}"), "imbalance_median_other": float(f"{np.median(lo[~trouble]):.3e}")}
json.dump(out, open("cert.json", "w"), indent=1); print(json.dumps(out, indent=1))
