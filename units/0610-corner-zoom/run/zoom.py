"""The corner as one comb, zoomed (Julian's self-similarity posit). EXPLORATORY.
Each depth step multiplies a zero rho = 1/2 + i gamma by the same factor, so the depth-d filter is the depth-1
filter to the d-th power. Three tests:
 1. width law: the zeros carrying depth d sit within about 1/sqrt(d) of an odd harmonic of pi/log b;
 2. record sequence: the leader at depth d is the zero maximising d log|b^rho - 1| - log gamma;
 3. base 3: the base-3 table's corner is led by the zeros near the odd harmonics of pi/log 3.
Base 2: unit 0597's corner (rows 12..92, 2r < 7d). Base 3: rows 1..41, cells where the oscillation leads,
|true - smooth| > |smooth|. Rows: Riemann's R less each zero's explicit-formula term, first 2000 zeros."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf, log
mp.dps = 20
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
K = len(g)
def setup(base, pifile, M):
    pi = [int(x) for x in open(pifile)][:M + 1]
    a = np.array([0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)], dtype=float)
    Lb = float(log(base))
    def table(row):
        T = np.zeros((M + 1, M + 1)); T[:, 0] = row
        for d in range(1, M + 1):
            T[1:, d] = T[1:, d - 1] - T[:-1, d - 1]; T[0, d] = T[0, d - 1]
        return T
    Tt = table(a)
    R = np.array([0.0] + [float(riemannr(mpf(base) ** m) - riemannr(mpf(base) ** (m - 1))) for m in range(1, M + 1)])
    Ts = table(R)
    Zr = np.zeros((K, M + 1))
    for k, gam in enumerate(g):
        rho = mpc(0.5, gam); prev = 0
        for m in range(1, M + 1):
            cur = ei(m * rho * Lb); Zr[k, m] = -2 * float((cur - prev).real); prev = cur
    return table, Tt, Ts, Zr, Lb, M
def contrib(table, Zr, ri, di):
    C = np.zeros((K, len(ri)))
    for k in range(K):
        C[k] = table(Zr[k])[ri, di]
    return C
def spearman(x, y):
    rx = np.argsort(np.argsort(x)); ry = np.argsort(np.argsort(y)); return float(np.corrcoef(rx, ry)[0, 1])
out = {}
# ---------- base 2
table2, Tt2, Ts2, Zr2, L2, M2 = setup(2, 'pi_2pow.txt', 92)
cells = [(r, d) for r in range(12, M2 + 1) for d in range(1, r) if 2 * r < 7 * d]
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
C2 = contrib(table2, Zr2, ri, di)
f2 = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))
dev2 = np.abs(((g * L2) % (2 * math.pi)) - math.pi)   # distance of gamma log 2 from the nearest odd multiple of pi
# test 1: contribution-weighted rms distance from a harmonic, by depth; fit against log d
ds, ws = [], []
for d in sorted(set(di.tolist())):
    m = di == d
    w = np.abs(C2[:, m]).sum(1)
    ds.append(d); ws.append(float(np.sqrt((w * dev2 ** 2).sum() / w.sum())))
ds = np.array(ds); ws = np.array(ws)
slope, icept = np.polyfit(np.log(ds), np.log(ws), 1)
out["width"] = {"slope_loglog": round(float(slope), 3), "predicted_slope": -0.5,
    "rms_at": {f"d{d}": round(float(ws[ds == d][0]), 4) for d in (10, 20, 40, 80) if d in ds},
    "depths": int(len(ds))}
# test 2: predicted leader vs the zero carrying the most of each depth's corner cells
pred, act = {}, {}
for d in sorted(set(di.tolist())):
    pred[d] = int(np.argmax(d * np.log(f2) - np.log(g)))
    m = di == d
    act[d] = int(np.argmax(np.abs(C2[:, m]).sum(1)))
agree = sum(1 for d in pred if pred[d] == act[d])
def runs(seq):
    out_ = []
    for d in sorted(seq):
        if not out_ or out_[-1][1] != seq[d]: out_.append([d, seq[d]])
    return [[d, round(float(g[k]), 3)] for d, k in out_]
out["record"] = {"depths": len(pred), "agree": agree, "agree_share": round(agree / len(pred), 3),
    "predicted_leaders": runs(pred), "actual_leaders": runs(act)}
# second check of test 2 on a wider pool: the predicted record sequence among 100000 zeros, depths to 10000
gall = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()])
fall = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(gall * L2))
seq = {}
for d in (10, 30, 100, 300, 1000, 3000, 10000):
    k = int(np.argmax(d * np.log(fall) - np.log(gall)))
    seq[f"d{d}"] = {"gamma": round(float(gall[k]), 3), "harmonic": round(float(gall[k] * L2 / math.pi), 4)}
out["record_wide"] = {"zeros": int(len(gall)), "leader": seq}
# ---------- base 3
table3, Tt3, Ts3, Zr3, L3, M3 = setup(3, 'pi_3pow.txt', 41)
cells3 = [(r, d) for r in range(2, M3 + 1) for d in range(1, r)
          if abs(Tt3[r, d] - Ts3[r, d]) > abs(Ts3[r, d])]
ri3 = np.array([c[0] for c in cells3]); di3 = np.array([c[1] for c in cells3])
C3 = contrib(table3, Zr3, ri3, di3)
f3 = np.sqrt(4 - 2 * math.sqrt(3) * np.cos(g * L3))
true3 = Tt3[ri3, di3]
share3 = (np.abs(C3) / np.maximum(np.abs(true3), 1)).mean(1)
top3 = np.argsort(-share3)[:5]
out["base3"] = {"cells": len(cells3), "rho_vs_factor3": round(spearman(share3, f3), 3),
    "rho_vs_factor2": round(spearman(share3, f2), 3),
    "top5_gamma": [round(float(g[t]), 3) for t in top3],
    "top5_harmonic3": [round(float(g[t] * L3 / math.pi), 3) for t in top3],
    "factor3_max": round(1 + math.sqrt(3), 4)}
near3 = np.cos(g * L3) < 0
def score(model, true):
    return int(np.sum(np.sign(model) == np.sign(true)))
sm3 = Ts3[ri3, di3]
out["base3"]["sign_smooth"] = score(sm3, true3)
out["base3"]["sign_all"] = score(sm3 + C3.sum(0), true3)
out["base3"]["sign_near3"] = score(sm3 + C3[near3].sum(0), true3)
out["base3"]["sign_far3"] = score(sm3 + C3[~near3].sum(0), true3)
out["base3"]["sign_near2"] = score(sm3 + C3[np.cos(g * L2) < 0].sum(0), true3)
json.dump(out, open("zoom.json", "w"), indent=1); print(json.dumps(out, indent=1))
