"""The leader's phase at the cells it loses (after units 0611, 0612). EXPLORATORY.
On unit 0597's corner of the true table (rows 12..92, 2r < 7d), the comb's predicted leader (unit 0610) puts
C_lead = Re Z into a cell, Z the leader's complex explicit-formula term differenced like the table. So
C_lead = |Z| cos(phi), phi = arg Z: |Z| is the leader's envelope, |cos phi| how far it is from a zero crossing.
The leader loses a cell when |C_lead| < |rest|, rest = everything else the zeros put there (true - smooth - C_lead).
Questions: do the losing cells sit at small |cos phi|; does the envelope |Z| beat the rest where cos phi is not small."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf
mp.dps = 20
L2 = math.log(2); M = 92
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))
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
ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells]); n = len(cells)
lead = np.array([int(np.argmax(d * np.log(f) - np.log(g))) for d in di])
Z = np.zeros(n, dtype=complex)
for k in sorted(set(lead.tolist())):
    rho = mpc(0.5, g[k]); prev = 0; row = np.zeros(M + 1, dtype=complex)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); dz = -2 * (cur - prev); row[m] = complex(dz); prev = cur
    Tk = table(row); sel = lead == k; Z[sel] = Tk[ri[sel], di[sel]]
Cl = Z.real; env = np.abs(Z); cphi = np.abs(Cl) / env
rest = (Tt[ri, di] - Ts[ri, di]) - Cl
lose = np.abs(Cl) < np.abs(rest)
out = {"cells": n, "losing": int(lose.sum()), "winning": int((~lose).sum()),
       "abscos_median_losing": round(float(np.median(cphi[lose])), 3),
       "abscos_median_winning": round(float(np.median(cphi[~lose])), 3),
       "abscos_median_uniform_phase": round(2 ** -0.5, 3)}
# share of losing cells by |cos phi| bin
bins = [0, 0.2, 0.4, 0.6, 0.8, 1.0001]
out["lose_share_by_abscos"] = {f"{bins[i]:.1f}_{min(bins[i+1],1):.1f}": round(float(lose[(cphi >= bins[i]) & (cphi < bins[i + 1])].mean()), 3)
                               for i in range(5)}
out["cells_by_abscos"] = {f"{bins[i]:.1f}_{min(bins[i+1],1):.1f}": int(((cphi >= bins[i]) & (cphi < bins[i + 1])).sum()) for i in range(5)}
# envelope against the rest: if the leader were at full swing
env_wins = env > np.abs(rest)
out["envelope_beats_rest"] = round(float(env_wins.mean()), 3)
out["losing_cells_envelope_beats_rest"] = round(float(env_wins[lose].mean()), 3)
out["envelope_over_rest_median"] = round(float(np.median(env / np.abs(rest))), 3)
json.dump(out, open("phase.json", "w"), indent=1); print(json.dumps(out, indent=1))
