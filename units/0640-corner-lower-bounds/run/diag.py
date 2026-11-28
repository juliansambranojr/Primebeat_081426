"""Lower bounds for the corner's almost-periodic sums along diagonals whose leaders change. EXPLORATORY.
The model: a cell = Riemann's R, differenced, less each zero's explicit-formula term -2 Re li(2^(m rho)),
differenced; first K of Odlyzko's 100000 zeros (imported/twin_count/zeros1.txt).
 1. validation on unit 0597's corner (rows 12..92, 2r < 7d) against the exact table, K = 2000, 10000, 30000, 100000;
 2. past row 92, inside Capstone.OpenCorner, along eight diagonals to depth 420, where the comb's leader changes
    twice (14.135 -> 40.919 at depth 67, -> 49.774 at depth 354): how far the model moves between K = 30000 and
    100000; the leader against the rest (absolute sum: the dominance a pointwise bound needs; root-square: the
    size the rest actually has); the smallest cells against an independent-phase benchmark;
 3. the zero height a truncated explicit formula would need to certify each cell's sign, by the order estimate
    T = 2^r (3/2)^(d+1) r log 2 / |cell| (the truncation error x log x / T per boundary, weighted by the
    binomial jumps C(d+1, j) at the boundaries 2^(r-j)); an order estimate, not a theorem."""
import json, math
import numpy as np
from scipy.special import exp1
from mpmath import mp, mpf, ei, riemannr, log as mlog
L2 = math.log(2)
g = np.loadtxt('../../../imported/twin_count/zeros1.txt'); NZ = len(g)
f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2)); near = np.cos(g * L2) < 0
lf, lg = np.log(f), np.log(g)
def leader(d): return int(np.argmax(d * lf - lg))
def opencorner(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and r >= 3.7 * d + 39)
DMAX = 420
diags = {f"ray{a}": [(round(a * d), d) for d in range(17, DMAX + 1)] for a in (1.5, 2.0, 2.5, 3.0, 3.3)}
diags.update({f"edge{q}": [(d + q, d) for d in range(17, DMAX + 1)] for q in (1, 8, 32)})
diags = {k: [c for c in v if opencorner(*c)] for k, v in diags.items()}
pi = [int(x) for x in open('pi_2pow.txt')]
val_cells = [(r, d) for r in range(12, 93) for d in range(1, r) if 2 * r < 7 * d]
deep_cells = [c for v in diags.values() for c in v]
cells = val_cells + deep_cells; n = len(cells); nv = len(val_cells)
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
RMAX = int(ri.max())
# exact table on rows <= 92
a = [0] + [pi[m] - pi[m - 1] for m in range(1, 93)]
true = np.array([float(sum((-1) ** j * math.comb(d, j) * a[r - j] for j in range(d + 1))) for r, d in val_cells])
# smooth part: rows <= 92 by R; past 92 by li(2^m) - li(2^(m-1)) less half of li at the square root (R's next term)
mp.dps = int(0.302 * (RMAX + 1.6 * DMAX)) + 40
Rrow = [mpf(0)] * (RMAX + 1)
prev = mpf(0)
for m in range(1, RMAX + 1):
    if m <= 92: cur = riemannr(mpf(2) ** m)
    else: cur = ei(m * mlog(2)) - ei(m * mlog(2) / 2) / 2
    Rrow[m] = cur - prev if m > 1 else cur; prev = cur
# the jump at m = 93 between the two definitions does not matter: no cell mixes R rows and li rows except through
# differences of the same function, so use one definition per cell: cells with r <= 92 use R throughout
Rli = [mpf(0)] * (RMAX + 1); prev = mpf(0)
for m in range(1, RMAX + 1):
    cur = ei(m * mlog(2)) - ei(m * mlog(2) / 2) / 2
    Rli[m] = cur - prev if m > 1 else cur; prev = cur
# every cell is carried divided by its scale 2^(r/2) (1 + 2^(-1/2))^d, the size of a zero term at the top of the
# comb; without it the terms past row 600 overflow double precision
LG = math.log(1 + 2 ** -0.5)
lsc = ri * L2 / 2 + di * LG
def smooth(r, d, l):
    row = Rrow if r <= 92 else Rli
    return float(sum((-1) ** j * math.comb(d, j) * row[r - j] for j in range(d + 1)) / mp.exp(l))
sm = np.array([smooth(r, d, l) for (r, d), l in zip(cells, lsc)])
true = true / np.exp(lsc[:nv])
W = np.zeros((n, RMAX + 1))
for i, (r, d) in enumerate(cells):
    for j in range(d + 1): W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * L2 / 2 - lsc[i])
ms = np.arange(RMAX + 1)
KS = (2000, 10000, 30000, 100000)
cum = np.zeros(n); at = {}
abs_all = np.zeros(n); sq_all = np.zeros(n); fam = np.zeros(n, complex); famabs = np.zeros(n)
abs_at = {}
KEEP = 2000; Ckeep = None
CH = 5000
for k0 in range(0, NZ, CH):
    gg = g[k0:k0 + CH]; rho = 0.5 + 1j * gg
    z = ms[:, None] * rho[None, :] * L2
    E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
    row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * L2 / 2)[:, None]
    C = -2 * (W @ row)                       # complex: the real part is the zero's term in the cell
    if k0 == 0: Ckeep = C[:, :KEEP].copy()
    for K in KS:
        if k0 < K <= k0 + CH: at[K] = cum + C[:, :K - k0].real.sum(1); abs_at[K] = abs_all + np.abs(C[:, :K - k0]).sum(1)
    cum += C.real.sum(1); abs_all += np.abs(C).sum(1); sq_all += (np.abs(C) ** 2).sum(1)
    nm = near[k0:k0 + CH]; fam += C[:, nm].sum(1); famabs += np.abs(C[:, nm]).sum(1)
model = {K: sm + at[K] for K in KS}
out = {"zeros": NZ, "gamma_max": round(float(g[-1]), 1)}
# 1. validation
v = slice(0, nv); out["validation"] = {"cells": nv}
for K in KS:
    err = model[K][v] - true
    out["validation"][f"K{K}"] = {"signs": int((np.sign(model[K][v]) == np.sign(true)).sum()),
        "rms_err_over_rms_true": round(float(np.sqrt((err ** 2).mean() / (true ** 2).mean())), 4),
        "median_rel_err": round(float(np.median(np.abs(err) / np.maximum(np.abs(true), np.exp(-lsc[:nv])))), 4)}
# validation: how big the error is against the cell's own size, at the cells whose sign the model gets wrong
err100 = model[100000][v] - true; wrong = np.sign(model[100000][v]) != np.sign(true)
sig = np.sqrt(sq_all[v] / 2)
out["validation"]["wrong_cells_true_over_sigma_median"] = round(float(np.median(np.abs(true[wrong]) / sig[wrong])), 4)
out["validation"]["all_cells_true_over_sigma_median"] = round(float(np.median(np.abs(true) / sig)), 4)
out["validation"]["err_over_sigma_median"] = round(float(np.median(np.abs(err100) / sig)), 4)
# 2. the diagonals
idx0 = nv; D = {}
for name, cl in diags.items():
    s = np.arange(idx0, idx0 + len(cl)); idx0 += len(cl)
    dd = di[s]; rr = ri[s]
    ld = np.array([leader(d) for d in dd])
    Cl = Ckeep[s, ld]                                    # leaders are among the first 2000 zeros at these depths
    A = np.abs(Cl)
    cell = model[100000][s]; move = np.abs(model[100000][s] - model[30000][s])
    sigma_rest = np.sqrt(np.maximum(sq_all[s] - A ** 2, 0) / 2)  # rms of the rest's real part, independent phases
    dom = {f"K{K}": round(float(np.median((abs_at[K][s] - A) / A)), 2) for K in KS}
    # the leader's share, and what the near-harmonic family adds to it
    famrest = fam[s] - Cl * near[ld]
    lead_fam = Cl + famrest
    small = np.abs(cell) / np.sqrt(sq_all[s] / 2)
    # benchmark with the leader kept: its amplitude A at an independent uniform phase, plus a Gaussian rest of
    # root-square sigma_rest; the expected number of cells below 0.05 sigma is the density at zero times the width
    U = np.linspace(0, 2 * np.pi, 256, endpoint=False)
    dens0 = np.exp(-0.5 * (A[:, None] * np.cos(U)[None, :] / sigma_rest[:, None]) ** 2).mean(1) / (sigma_rest * math.sqrt(2 * math.pi))
    exp_small = 2 * 0.05 * np.sqrt(sq_all[s] / 2) * dens0
    N = len(s)
    rec = {"cells": N, "depths": [int(dd.min()), int(dd.max())], "rows": [int(rr.min()), int(rr.max())],
        "sign_changes_30k_to_100k": int((np.sign(model[100000][s]) != np.sign(model[30000][s])).sum()),
        "move_over_cell_median": round(float(np.median(move / np.abs(cell))), 4),
        "cells_move_exceeds_cell": int((move > np.abs(cell)).sum()),
        "leader_over_rest_rms_median": round(float(np.median(A / sigma_rest)), 3),
        "dominance_deficit_median": dom,
        "cells_leader_dominates_K100000": int((A > abs_at[100000][s] - A).sum()),
        "min_cell_over_sigma": round(float(small.min()), 5),
        "argmin_cell": [int(rr[small.argmin()]), int(dd[small.argmin()])],
        "expected_min_iid": round(1.2533 / N, 5),
        "cells_below_0.05sigma": int((small < 0.05).sum()), "expected_below_0.05sigma_iid": round(0.0399 * N, 1),
        "expected_below_0.05sigma_leader_plus_gaussian": round(float(exp_small.sum()), 1),
        "sign_from_leader_and_family": int((np.sign(lead_fam.real + sm[s]) == np.sign(cell)).sum()),
        "sign_from_leader_alone": int((np.sign(Cl.real + sm[s]) == np.sign(cell)).sum()),
        "smooth_over_sigma_median": float("%.3g" % np.median(np.abs(sm[s]) / np.sqrt(sq_all[s] / 2)))}
    # leader changes along this diagonal: the ratio leader/rest at the change depths
    for dc in (67, 354):
        w = np.where(dd == dc)[0]
        if len(w):
            i = w[0]; k_old = leader(dc - 1)
            rec[f"at_change_d{dc}"] = {"row": int(rr[i]), "old_over_new_amplitude": round(float(np.abs(Ckeep[s[i], k_old]) / A[i]), 3),
                "leader_over_rest_rms": round(float(A[i] / sigma_rest[i]), 3)}
    # 3. the zero height a truncated explicit formula needs for the sign of each cell
    lT = (rr * L2 + (dd + 1) * math.log(1.5) + np.log(rr * L2) - np.log(np.abs(cell)) - lsc[s]) / math.log(10)
    rec["log10_T_needed"] = {"min": round(float(lT.min()), 2), "median": round(float(np.median(lT)), 2), "max": round(float(lT.max()), 2),
                             "slope_per_depth": round(float(np.polyfit(dd, lT, 1)[0]), 4)}
    D[name] = rec
out["diagonals"] = D
out["log10_gamma_max"] = round(math.log10(g[-1]), 2)
out["leader_changes"] = {"d67": [round(float(g[leader(66)]), 3), round(float(g[leader(67)]), 3)],
                         "d354": [round(float(g[leader(353)]), 3), round(float(g[leader(354)]), 3)]}
json.dump(out, open("diag.json", "w"), indent=1); print(json.dumps(out, indent=1))
