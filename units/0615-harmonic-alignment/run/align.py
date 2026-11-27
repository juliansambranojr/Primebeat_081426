"""When the near-harmonic zeros line up (after unit 0614). EXPLORATORY.
A zero near an odd harmonic, gamma log 2 = (2j+1) pi + delta, turns by about pi per row plus a slow drift
delta. So two near-harmonic zeros keep a phase difference that drifts by (delta_k - delta_l) per row: they
beat against each other, and line up every 2 pi / |delta_k - delta_l| rows.
On unit 0597's corner (rows 12..92, 2r < 7d), first 2000 zeros, the comb's leader and runner-up (unit 0610):
 1. coherence of the near-harmonic family (leader excluded): |sum Z_k| / sum |Z_k| over its complex terms,
    in the real losses (unit 0614) and elsewhere;
 2. the leader-runner-up alignment: cos of the difference of their phases, in the real losses and elsewhere;
 3. whether that difference follows the predicted slow drift (delta_lead - delta_second) per row."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf
mp.dps = 20
L2 = math.log(2); M = 92
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
K = len(g); f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2)); near = np.cos(g * L2) < 0
delta = ((g * L2) % (2 * math.pi)) - math.pi           # offset from the nearest odd multiple of pi
pi = [int(x) for x in open('pi_2pow.txt')]
a = np.array([0] + [pi[m] - pi[m - 1] for m in range(1, M + 1)], dtype=float)
def table(row):
    T = np.zeros((M + 1, M + 1), dtype=row.dtype); T[:, 0] = row
    for dd in range(1, M + 1):
        T[1:, dd] = T[1:, dd - 1] - T[:-1, dd - 1]; T[0, dd] = T[0, dd - 1]
    return T
Tt = table(a)
R = np.array([0.0] + [float(riemannr(mpf(2) ** m) - riemannr(mpf(2) ** (m - 1))) for m in range(1, M + 1)])
Ts = table(R)
cells = [(r, d) for r in range(12, M + 1) for d in range(1, r) if 2 * r < 7 * d]
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells]); n = len(cells); idx = np.arange(n)
Zc = np.zeros((K, n), dtype=complex); Tfull = {}
for k, gam in enumerate(g):
    rho = mpc(0.5, gam); prev = 0; row = np.zeros(M + 1, dtype=complex)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); row[m] = complex(-2 * (cur - prev)); prev = cur
    T = table(row); Zc[k] = T[ri, di]
    if k < 20: Tfull[k] = T
score = di[None, :] * np.log(f)[:, None] - np.log(g)[:, None]
order = np.argsort(-score, axis=0); lead, second = order[0], order[1]
Cl = Zc[lead, idx].real; env = np.abs(Zc[lead, idx])
rest = (Tt[ri, di] - Ts[ri, di]) - Cl
real = env < np.abs(rest)
famask = near[:, None] & (np.arange(K)[:, None] != lead[None, :])
Zf = Zc * famask
coh = np.abs(Zf.sum(0)) / np.abs(Zf).sum(0)
out = {"cells": n, "real_losses": int(real.sum()),
       "coherence_median": {"real": round(float(np.median(coh[real])), 3), "elsewhere": round(float(np.median(coh[~real])), 3)}}
dphi = np.angle(Zc[lead, idx] * np.conj(Zc[second, idx]))
out["lead_second_cos_median"] = {"real": round(float(np.median(np.cos(dphi[real]))), 3),
                                 "elsewhere": round(float(np.median(np.cos(dphi[~real]))), 3)}
out["lead_second_aligned_share"] = {"real": round(float((np.cos(dphi[real]) > 0).mean()), 3),
                                    "elsewhere": round(float((np.cos(dphi[~real]) > 0).mean()), 3)}
# 3. drift of the phase difference along a row of the table at fixed depth, for the pairs that lead
drift = {}
for (kl, ks) in ((0, 6), (6, 9), (0, 9)):     # 14.135, 40.919, 49.774 by index
    d = 50
    rows = np.arange(d + 1, M + 1)
    ph = np.unwrap(np.angle(Tfull[kl][rows, d] * np.conj(Tfull[ks][rows, d])))
    slope = float(np.polyfit(rows, ph, 1)[0])
    pred = float(delta[kl] - delta[ks])
    resid = float(np.std(ph - np.polyval(np.polyfit(rows, ph, 1), rows)))
    drift[f"{g[kl]:.3f}_vs_{g[ks]:.3f}"] = {"measured_per_row": round(slope, 4), "predicted_per_row": round(pred, 4),
        "beat_period_rows": round(2 * math.pi / abs(pred), 1), "residual_sd": round(resid, 4)}
out["drift_depth50"] = drift
out["delta_first_harmonic_zeros"] = {f"{g[k]:.3f}": round(float(delta[k]), 4) for k in (0, 6, 9, 12, 19)}
json.dump(out, open("align.json", "w"), indent=1); print(json.dumps(out, indent=1))
