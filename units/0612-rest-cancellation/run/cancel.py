"""How much the zeros behind the corner's leader cancel (after unit 0611). EXPLORATORY.
On unit 0597's corner of the true table (rows 12..92, 2r < 7d), each zero's part C_k of each cell, first
2000 zeros; the leader is the comb's prediction (unit 0610). For the rest R = sum over the other zeros:
 cancellation  kappa = |R| / sum_k |C_k|          (1 = no cancellation, small = strong)
 random-phase  |R| / sqrt(sum_k C_k^2)            (about 1 if the phases were independent)
 mean square   E_cells |R|^2 / sum_k E_cells |C_k|^2 by depth band (1 = cross terms average out)
each against the number of zeros K = 100, 500, 2000."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf
mp.dps = 20
L2 = math.log(2)
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
K = len(g); M = 92
f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))
def table(row):
    T = np.zeros((M + 1, M + 1)); T[:, 0] = row
    for dd in range(1, M + 1):
        T[1:, dd] = T[1:, dd - 1] - T[:-1, dd - 1]; T[0, dd] = T[0, dd - 1]
    return T
cells = [(r, d) for r in range(12, M + 1) for d in range(1, r) if 2 * r < 7 * d]
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells]); n = len(cells)
C = np.zeros((K, n))
for k, gam in enumerate(g):
    rho = mpc(0.5, gam); prev = 0; row = np.zeros(M + 1)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); row[m] = -2 * float((cur - prev).real); prev = cur
    C[k] = table(row)[ri, di]
lead = np.array([int(np.argmax(d * np.log(f) - np.log(g))) for d in di])
bands = ((10, 19), (20, 35), (36, 66), (67, 91))
out = {"cells": n}
for Kz in (100, 500, 2000):
    Ck = C[:Kz].copy()
    Ck[lead, np.arange(n)] = 0.0                     # remove the leader (all leaders lie in the first 100)
    Rs = Ck.sum(0); absum = np.abs(Ck).sum(0); rms = np.sqrt((Ck ** 2).sum(0))
    kappa = np.abs(Rs) / absum; rp = np.abs(Rs) / rms
    row = {"kappa_median": round(float(np.median(kappa)), 4), "random_phase_median": round(float(np.median(rp)), 3)}
    for lo, hi in bands:
        m = (di >= lo) & (di <= hi)
        ms = float((Rs[m] ** 2).mean() / (Ck[:, m] ** 2).mean(1).sum())
        row[f"d{lo}_{hi}"] = {"kappa_median": round(float(np.median(kappa[m])), 4),
                              "random_phase_median": round(float(np.median(rp[m])), 3),
                              "mean_square_ratio": round(ms, 3)}
    out[f"K{Kz}"] = row
# the leader against the rest's sum of sizes and against the rest's actual size, K = 2000
Ck = C.copy(); Lc = C[lead, np.arange(n)]; Ck[lead, np.arange(n)] = 0.0
out["leader_vs_rest_sizes_median"] = round(float(np.median(np.abs(Lc) / np.abs(Ck).sum(0))), 4)
rmsr = np.sqrt((Ck ** 2).sum(0))
out["leader_vs_rest_rms_median"] = round(float(np.median(np.abs(Lc) / rmsr)), 3)
out["leader_vs_rest_rms_by_band"] = {f"d{lo}_{hi}": round(float(np.median((np.abs(Lc) / rmsr)[(di >= lo) & (di <= hi)])), 3) for lo, hi in bands}
out["leader_vs_rest_sum_median"] = round(float(np.median(np.abs(Lc) / np.abs(Ck.sum(0)))), 3)
json.dump(out, open("cancel.json", "w"), indent=1); print(json.dumps(out, indent=1))
