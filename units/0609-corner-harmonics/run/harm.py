"""Julian's posit: the deep corner is the harmonics. Depth multiplies a zero rho = 1/2 + i gamma by
|2^rho - 1| = sqrt(3 - 2 sqrt2 cos(gamma log 2)), largest (1 + sqrt2) where gamma log 2 is an odd multiple of pi.
Three checks on the corner of the true table (rows 12..92, 2r < 7d, as in unit 0597), with each row's zero
part 2 Re[li(2^{m rho}) - li(2^{(m-1) rho})] over the first 2000 zeros. EXPLORATORY."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf, log
mp.dps = 20
pi = [int(x) for x in open('pi_2pow.txt')]
M = 92
a = np.array([0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)], dtype=float)
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
K = len(g); L2 = float(log(2))
def table(row):
    T = np.zeros((M + 1, M + 1)); T[:, 0] = row
    for d in range(1, M + 1):
        T[1:, d] = T[1:, d - 1] - T[:-1, d - 1]; T[0, d] = T[0, d - 1]
    return T
Ttrue = table(a)
R = np.array([0.0] + [float(riemannr(mpf(2) ** m) - riemannr(mpf(2) ** (m - 1))) for m in range(1, M + 1)])
Ts = table(R)
# per-zero row parts (with the minus sign of the explicit formula)
Zr = np.zeros((K, M + 1))
for k, gam in enumerate(g):
    rho = mpc(0.5, gam); prev = 0
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); Zr[k, m] = -2 * float((cur - prev).real); prev = cur
cells = [(r, d) for r in range(12, M + 1) for d in range(1, r) if 2 * r < 7 * d]
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
# per-zero contribution to each corner cell (linear): C[k, c]
C = np.zeros((K, len(cells)))
for k in range(K):
    Tk = table(Zr[k]); C[k] = Tk[ri, di]
true = Ttrue[ri, di]; smooth = Ts[ri, di]
f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))          # depth factor per zero
near = np.cos(g * L2) < 0                                    # closer to an odd harmonic than to an even one
def score(model):
    agree = int(np.sum(np.sign(model) == np.sign(true)))
    rel = np.abs(model - true) / np.maximum(np.abs(true), 1)
    return agree, float(np.median(rel))
out = {"zeros": K, "cells": len(cells), "near_zeros": int(near.sum()), "far_zeros": int((~near).sum())}
for name, sel in (("smooth_only", np.zeros(K, bool)), ("all", np.ones(K, bool)), ("near", near), ("far", ~near)):
    ag, md = score(smooth + C[sel].sum(0))
    out["check1_" + name] = {"sign_agree": ag, "median_rel_err": round(md, 4)}
# check 2: per depth band, which zeros carry the corner; rank-correlate each zero's share with f, 1/gamma, f^d/gamma
def spearman(x, y):
    rx = np.argsort(np.argsort(x)); ry = np.argsort(np.argsort(y)); return float(np.corrcoef(rx, ry)[0, 1])
c2 = {}
for lo, hi in ((10, 19), (20, 29), (30, 49), (50, 91)):
    m = (di >= lo) & (di <= hi)
    share = (np.abs(C[:, m]) / np.maximum(np.abs(true[m]), 1)).mean(1)
    dm = float(di[m].mean())
    top = np.argsort(-share)[:5]
    c2[f"d{lo}_{hi}"] = {"cells": int(m.sum()), "rho_vs_factor": round(spearman(share, f), 3),
        "rho_vs_inv_height": round(spearman(share, 1 / g), 3),
        "rho_vs_factor_pow_d_over_height": round(spearman(share, f ** dm / g), 3),
        "top5_gamma": [round(float(g[t]), 3) for t in top], "top5_factor": [round(float(f[t]), 3) for t in top]}
out["check2"] = c2
# check 3: does gamma_1 lead? |C_1| > |true - smooth - C_1| cell by cell, by depth
lead = np.abs(C[0]) > np.abs(true - smooth - C[0])
by_d = {}
for d in sorted(set(di.tolist())):
    m = di == d; by_d[d] = float(lead[m].mean())
dstar = next((d for d in sorted(by_d) if all(by_d[e] == 1.0 for e in by_d if e >= d)), None)
out["check3"] = {"lead_share_all": round(float(lead.mean()), 3), "first_depth_all_lead": dstar,
    "lead_share_by_band": {f"d{lo}_{hi}": round(float(lead[(di >= lo) & (di <= hi)].mean()), 3)
                           for lo, hi in ((10, 19), (20, 29), (30, 49), (50, 91))}}
top1 = int(np.argmax(np.abs(C).sum(1)))
out["largest_total_contributor"] = {"gamma": round(float(g[top1]), 3), "factor": round(float(f[top1]), 3)}
out["factor_gamma1"] = round(float(f[0]), 4); out["factor_gamma2"] = round(float(f[1]), 4)
out["factor_max"] = round(1 + math.sqrt(2), 4)
json.dump(out, open("harm.json", "w"), indent=1); print(json.dumps(out, indent=1))
