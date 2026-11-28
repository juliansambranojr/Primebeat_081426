"""The edge excess of small cells (after unit 0640). EXPLORATORY.
Unit 0640 found cells below a twentieth of their root-square size about twice as often as independent phases
predict on the edges (row = depth + 1, + 8) and at the predicted rate on the rays. Here: twelve edges
(row = depth + q, q = 1 .. 64) to depth 600 and two rays (row = 2 depth, 3 depth) to depth 420, all inside
Capstone.OpenCorner, Odlyzko's 2001052 zeros (imported/odlyzko/zeros6; its first 100000 equal
imported/twin_count/zeros1.txt exactly). The smooth part is left out (unit 0640: below 1e-17 of the
root-square size on these diagonals).
 1. the count of cells below 0.02, 0.05 and 0.1 of their root-square size sigma, at K = 100000, 500000 and all;
 2. three benchmarks for that count: a Gaussian with sigma; the leader at its own amplitude and an independent
    phase over a Gaussian rest; the fifty largest terms at their own amplitudes and independent phases over a
    Gaussian rest (Monte Carlo, 4000 draws per cell);
 3. clustering: how many separate runs of consecutive small cells the count falls into."""
import json, math
import numpy as np
from scipy.special import exp1
L2 = math.log(2)
g = np.loadtxt('../../../imported/odlyzko/zeros6'); NZ = len(g)
def opencorner(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and r >= 3.7 * d + 39)
QS = (1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64)
diags = {f"edge{q}": [(d + q, d) for d in range(17, 601)] for q in QS}
diags.update({f"ray{a}": [(round(a * d), d) for d in range(17, 421)] for a in (2.0, 3.0)})
diags = {k: [c for c in v if opencorner(*c)] for k, v in diags.items()}
cells = [c for v in diags.values() for c in v]; n = len(cells)
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells]); RMAX = int(ri.max())
LG = math.log(1 + 2 ** -0.5); lsc = ri * L2 / 2 + di * LG          # each cell carried over its scale
W = np.zeros((n, RMAX + 1))
for i, (r, d) in enumerate(cells):
    for j in range(d + 1):
        W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * L2 / 2 - lsc[i])
ms = np.arange(RMAX + 1)
KS = (100000, 500000, NZ); at = {}; sq_at = {}
cum = np.zeros(n); sq = np.zeros(n); KEEP = 2000; CH = 2500
for k0 in range(0, NZ, CH):
    gg = g[k0:k0 + CH]; rho = 0.5 + 1j * gg
    z = ms[:, None] * rho[None, :] * L2
    E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
    row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * L2 / 2)[:, None]
    C = -2 * (W @ row)
    if k0 == 0: Ck = C.copy()
    elif k0 < KEEP: Ck = np.concatenate([Ck, C], 1)
    for K in KS:
        if k0 < K <= k0 + CH: at[K] = cum + C[:, :K - k0].real.sum(1); sq_at[K] = sq + (np.abs(C[:, :K - k0]) ** 2).sum(1)
    cum += C.real.sum(1); sq += (np.abs(C) ** 2).sum(1)
Ck = Ck[:, :KEEP]
amp = np.abs(Ck); top = np.sort(amp, 1)[:, ::-1][:, :50]
rng = np.random.default_rng(20261128)
sig = np.sqrt(sq / 2)
THR = (0.02, 0.05, 0.1)
# benchmarks
U = np.linspace(0, 2 * np.pi, 256, endpoint=False)
A1 = top[:, 0]; s1 = np.sqrt(np.maximum(sq - A1 ** 2, 0) / 2)
dens_lead = np.exp(-0.5 * (A1[:, None] * np.cos(U)[None, :] / s1[:, None]) ** 2).mean(1) / (s1 * math.sqrt(2 * math.pi))
s50 = np.sqrt(np.maximum(sq - (top ** 2).sum(1), 0) / 2)
mc = {t: np.zeros(n) for t in THR}
NMC = 4000
for i0 in range(0, n, 200):
    sl = slice(i0, i0 + 200); nn = top[sl].shape[0]
    X = np.zeros((nn, NMC))
    for k in range(50):
        X += top[sl, k][:, None] * np.cos(rng.uniform(0, 2 * np.pi, (nn, NMC)))
    X += s50[sl][:, None] * rng.standard_normal((nn, NMC))
    for t in THR: mc[t][sl] = (np.abs(X) < t * sig[sl][:, None]).mean(1)
out = {"zeros": NZ, "cells": n}
idx0 = 0; D = {}
tot = {f"{t}": {"observed": 0, "gauss": 0.0, "leader": 0.0, "top50": 0.0} for t in THR}
for name, cl in diags.items():
    s = np.arange(idx0, idx0 + len(cl)); idx0 += len(cl)
    rec = {"cells": len(s), "depths": [int(di[s].min()), int(di[s].max())]}
    for t in THR:
        small = np.abs(at[NZ][s]) < t * sig[s]
        runs = int(small[0]) + int(((~small[:-1]) & small[1:]).sum())
        e_g = float(2 * t * 0.39894 * len(s)); e_l = float((2 * t * sig[s] * dens_lead[s]).sum()); e_m = float(mc[t][s].sum())
        rec[f"t{t}"] = {"observed": int(small.sum()), "runs": runs,
            "observed_K100000": int((np.abs(at[100000][s]) < t * np.sqrt(sq_at[100000][s] / 2)).sum()),
            "observed_K500000": int((np.abs(at[500000][s]) < t * np.sqrt(sq_at[500000][s] / 2)).sum()),
            "expected_gauss": round(e_g, 1), "expected_leader": round(e_l, 1), "expected_top50": round(e_m, 1)}
        if name.startswith("edge"):
            tot[f"{t}"]["observed"] += int(small.sum()); tot[f"{t}"]["gauss"] += e_g; tot[f"{t}"]["leader"] += e_l; tot[f"{t}"]["top50"] += e_m
    rec["top2_ratio_median"] = round(float(np.median(top[s, 1] / top[s, 0])), 3)
    rec["top50_share_of_square_median"] = round(float(np.median((top[s] ** 2).sum(1) / sq[s])), 3)
    D[name] = rec
out["diagonals"] = D
# 3b. do neighbouring edges share their small cells? share of small-cell depths on edge q that are within one
# depth of a small cell on the next edge in the list, against the share for a random set of the same size
smalld = {}; idx0 = 0
for name, cl in diags.items():
    s_ = np.arange(idx0, idx0 + len(cl)); idx0 += len(cl)
    smalld[name] = set(int(x) for x in di[s_][np.abs(at[NZ][s_]) < 0.05 * sig[s_]])
shared = {}
for q1, q2 in zip(QS[:-1], QS[1:]):
    A_, B_ = smalld[f"edge{q1}"], smalld[f"edge{q2}"]
    hit = sum(1 for x in A_ if any(abs(x - y) <= 1 for y in B_))
    base = min(1.0, 3 * len(B_) / len(diags[f"edge{q2}"]))
    shared[f"{q1}_{q2}"] = {"share": round(hit / max(1, len(A_)), 3), "chance": round(base, 3)}
out["neighbour_edges_shared"] = shared
out["edges_total"] = {k: {kk: (round(vv, 1) if isinstance(vv, float) else vv) for kk, vv in v.items()} for k, v in tot.items()}
json.dump(out, open("edge.json", "w"), indent=1); print(json.dumps(out["edges_total"], indent=1))
