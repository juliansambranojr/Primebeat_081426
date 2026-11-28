"""Failed turnovers along the deep diagonals (EXPLORATORY). A cell (r,d) is its parent (r,d-1) less its parent
(r-1,d-1); when the parents have opposite signs the cell cannot be zero (lean/CornerSign.lean ne_zero_of_opposite).
A failed turnover is a cell whose parents share a sign. Model: R less each zero's term (0640's engine), first K of
Odlyzko's zeros. Part 1 calibrates on unit 0597's corner (rows 12..92) against the exact table. Part 2 runs the eight
OpenCorner diagonals of unit 0640 to depth 420."""
import json, math, sys
import numpy as np
from scipy.special import exp1
from mpmath import mp, mpf, ei, riemannr, log as mlog
L2 = math.log(2); LG = math.log(1 + 2 ** -0.5)
g = np.loadtxt('../../../imported/twin_count/zeros1.txt')
pi = [int(x) for x in open('pi_2pow.txt')]
def opencorner(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and r >= 3.7 * d + 39)
DMAX = 420
diags = {f"ray{a}": [(round(a * d), d) for d in range(17, DMAX + 1)] for a in (1.5, 2.0, 2.5, 3.0, 3.3)}
diags.update({f"edge{q}": [(d + q, d) for d in range(17, DMAX + 1)] for q in (1, 8, 32)})
diags = {k: [c for c in v if opencorner(*c)] for k, v in diags.items()}
val = [(r, d) for r in range(12, 93) for d in range(2, r) if 2 * r < 7 * d]
def withparents(cl): return [x for (r, d) in cl for x in ((r, d), (r, d - 1), (r - 1, d - 1))]
cells = withparents(val) + withparents([c for v in diags.values() for c in v]); nv3 = 3 * len(val)
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells]); n = len(cells); RMAX = int(ri.max())
lsc = ri * L2 / 2 + di * LG
mp.dps = int(0.302 * (RMAX + 1.6 * DMAX)) + 40
Rrow = [mpf(0)] * 93; prev = mpf(0)
for m in range(1, 93): cur = riemannr(mpf(2) ** m); Rrow[m] = cur - prev if m > 1 else cur; prev = cur
Rli = [mpf(0)] * (RMAX + 1); prev = mpf(0)
for m in range(1, RMAX + 1):
    cur = ei(m * mlog(2)) - ei(m * mlog(2) / 2) / 2; Rli[m] = cur - prev if m > 1 else cur; prev = cur
def smooth(r, d, l):
    row = Rrow if r <= 92 else Rli
    return float(sum((-1) ** j * math.comb(d, j) * row[r - j] for j in range(d + 1)) / mp.exp(l))
sm = np.array([smooth(r, d, l) for (r, d), l in zip(cells, lsc)])
W = np.zeros((n, RMAX + 1))
for i, (r, d) in enumerate(cells):
    for j in range(d + 1):
        W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * L2 / 2 - lsc[i])
ms = np.arange(RMAX + 1); cum = np.zeros(n); at = {}
for k0 in range(0, len(g), 5000):
    gg = g[k0:k0 + 5000]; rho = 0.5 + 1j * gg
    z = ms[:, None] * rho[None, :] * L2
    E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
    row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * L2 / 2)[:, None]
    C = -2 * (W @ row).real
    if k0 < 30000 <= k0 + 5000: at[30000] = cum + C[:, :30000 - k0].sum(1)
    cum += C.sum(1)
at[100000] = cum
out = {}
# part 1: calibration against the exact table
a = [0] + [pi[m] - pi[m - 1] for m in range(1, 93)]
def exact(r, d): return sum((-1) ** j * math.comb(d, j) * a[r - j] for j in range(d + 1))
ex = np.array([exact(r, d) for (r, d) in cells[:nv3]], dtype=object)
exs = np.array([(v > 0) - (v < 0) for v in ex]).reshape(-1, 3)
fail_exact = exs[:, 1] == exs[:, 2]
mod = np.sign(sm[:nv3] + at[100000][:nv3]).reshape(-1, 3)
fail_model = mod[:, 1] == mod[:, 2]
out["calibration"] = {"cells": int(len(val)), "fail_share_exact": round(float(fail_exact.mean()), 4),
    "fail_share_model": round(float(fail_model.mean()), 4), "agree": round(float((fail_exact == fail_model).mean()), 4)}
# part 2: the diagonals, failed-turnover share by depth band
idx = nv3; D = {}
bands = [(17, 60), (60, 120), (120, 200), (200, 300), (300, 421)]
allbands = {b: [0, 0] for b in bands}
for name, cl in diags.items():
    k = len(cl); s = np.arange(idx, idx + 3 * k).reshape(-1, 3); idx += 3 * k
    sg = np.sign(sm[s] + at[100000][s]); sg30 = np.sign(sm[s] + at[30000][s])
    dd = np.array([c[1] for c in cl])
    fail = sg[:, 1] == sg[:, 2]; fail30 = sg30[:, 1] == sg30[:, 2]
    rec = {"cells": k, "fail_share": round(float(fail.mean()), 4), "fail_share_K30000": round(float(fail30.mean()), 4)}
    for b in bands:
        w = (dd >= b[0]) & (dd < b[1])
        if w.sum(): rec[f"d{b[0]}-{b[1]-1}"] = [int(w.sum()), round(float(fail[w].mean()), 4)]; allbands[b][0] += int(w.sum()); allbands[b][1] += int(fail[w].sum())
    rec["slope_per_100_depths"] = round(float(np.polyfit(dd, fail.astype(float), 1)[0] * 100), 4)
    D[name] = rec
out["diagonals"] = D
out["all_diagonals_by_depth"] = {f"d{b[0]}-{b[1]-1}": [v[0], round(v[1] / v[0], 4)] for b, v in allbands.items() if v[0]}
json.dump(out, open("flip.json", "w"), indent=1); print(json.dumps(out, indent=1))
