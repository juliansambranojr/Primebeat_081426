"""The gap between the corner's leaders (Julian's comb, unit 0610). EXPLORATORY.
Predicted: each zero rho = 1/2 + i gamma carries the depth-d corner with weight w_k(d) = f_k^d / gamma_k,
f_k = |2^rho - 1|. At each depth: the leader, the runner-up, the gap log(w_lead / w_second), and the
dominance w_lead / sum of the rest, over the first 2000 and the first 100000 zeros.
Actual: on unit 0597's corner of the true table (rows 12..92, 2r < 7d), each cell's share carried by the
predicted leader against everything else the zeros put there."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf, log
mp.dps = 20
L2 = math.log(2)
gall = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()])
fall = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(gall * L2))
lf, lg = np.log(fall), np.log(gall)
def predicted(Kz, depths):
    res = {}
    for d in depths:
        s = d * lf[:Kz] - lg[:Kz]
        o = np.argsort(-s)
        lead, sec = o[0], o[1]
        w = np.exp(s - s[lead])
        res[f"d{d}"] = {"lead": round(float(gall[lead]), 3), "second": round(float(gall[sec]), 3),
                        "gap": round(float(s[lead] - s[sec]), 4),
                        "dominance": round(float(1 / (w.sum() - 1)), 5)}
    return res
depths = (10, 20, 36, 50, 67, 80, 100, 300, 1000, 3000, 10000)
out = {"pred_2000": predicted(2000, depths), "pred_100000": predicted(100000, depths)}
# where the gap closes: depths 1..2000 at 100000 zeros, the switches and the smallest gaps
gaps, leads = [], []
for d in range(1, 2001):
    s = d * lf - lg
    o = np.argpartition(-s, 2)[:2]; o = o[np.argsort(-s[o])]
    gaps.append(float(s[o[0]] - s[o[1]])); leads.append(int(o[0]))
gaps = np.array(gaps)
sw = [d + 1 for d in range(1, 2000) if leads[d] != leads[d - 1]]
out["switches_to_2000"] = {"count": len(sw), "depths": sw[:12],
    "leaders": [round(float(gall[leads[d - 1]]), 3) for d in [1] + sw[:12]],
    "median_gap": round(float(np.median(gaps)), 4), "min_gap": round(float(gaps.min()), 5)}
# actual, on the true table
g = gall[:2000]; K = len(g); M = 92
pi = [int(x) for x in open('pi_2pow.txt')]
a = np.array([0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)], dtype=float)
def table(row):
    T = np.zeros((M + 1, M + 1)); T[:, 0] = row
    for dd in range(1, M + 1):
        T[1:, dd] = T[1:, dd - 1] - T[:-1, dd - 1]; T[0, dd] = T[0, dd - 1]
    return T
Tt = table(a)
R = np.array([0.0] + [float(riemannr(mpf(2) ** m) - riemannr(mpf(2) ** (m - 1))) for m in range(1, M + 1)])
Ts = table(R)
cells = [(r, d) for r in range(12, M + 1) for d in range(1, r) if 2 * r < 7 * d]
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
C = np.zeros((K, len(cells)))
for k, gam in enumerate(g):
    rho = mpc(0.5, gam); prev = 0; row = np.zeros(M + 1)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); row[m] = -2 * float((cur - prev).real); prev = cur
    C[k] = table(row)[ri, di]
osc = Tt[ri, di] - Ts[ri, di]
pl = np.array([int(np.argmax(d * lf[:K] - lg[:K])) for d in di])
lead_c = C[pl, np.arange(len(cells))]
ratio = np.abs(lead_c) / np.maximum(np.abs(osc - lead_c), 1e-300)
act = {}
for lo, hi in ((10, 19), (20, 35), (36, 66), (67, 91)):
    m = (di >= lo) & (di <= hi)
    act[f"d{lo}_{hi}"] = {"cells": int(m.sum()), "lead_wins": round(float((ratio[m] > 1).mean()), 3),
                          "median_ratio": round(float(np.median(ratio[m])), 3)}
out["actual"] = act
out["actual_all"] = {"cells": len(cells), "lead_wins": round(float((ratio > 1).mean()), 3),
                     "median_ratio": round(float(np.median(ratio)), 3)}
json.dump(out, open("gap.json", "w"), indent=1); print(json.dumps(out, indent=1))
