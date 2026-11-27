"""The remainder in the leader's real losses (after unit 0613). EXPLORATORY.
On unit 0597's corner (rows 12..92, 2r < 7d), first 2000 zeros, the comb's leader (unit 0610). A real loss is a
cell where the leader's envelope |Z| (its full swing) is below the rest = true - smooth - leader's part.
For those cells: where they sit in depth; how the rest splits into the runner-up zero, the other zeros near a
harmonic, the zeros far from one, and the tail past 2000 zeros; and the rest's size against the root of its
squares (unit 0612), to see whether the real losses are cells where the rest happens to add up."""
import json, math
import numpy as np
from mpmath import mp, mpc, ei, riemannr, mpf
mp.dps = 20
L2 = math.log(2); M = 92
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()[:2000]])
K = len(g); f = np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2)); near = np.cos(g * L2) < 0
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
Zc = np.zeros((K, n), dtype=complex)
for k, gam in enumerate(g):
    rho = mpc(0.5, gam); prev = 0; row = np.zeros(M + 1, dtype=complex)
    for m in range(1, M + 1):
        cur = ei(m * rho * L2); row[m] = complex(-2 * (cur - prev)); prev = cur
    Zc[k] = table(row)[ri, di]
C = Zc.real
score = np.outer(np.ones(K), di) * np.log(f)[:, None] - np.log(g)[:, None]
order = np.argsort(-score, axis=0)
lead, second = order[0], order[1]
Cl = C[lead, idx]; env = np.abs(Zc[lead, idx])
osc = Tt[ri, di] - Ts[ri, di]
rest = osc - Cl
real = env < np.abs(rest)
c2 = C[second, idx]
mask_other_near = near[:, None] & (np.arange(K)[:, None] != lead) & (np.arange(K)[:, None] != second)
other_near = (C * mask_other_near).sum(0)
mask_far = (~near)[:, None] & (np.arange(K)[:, None] != lead) & (np.arange(K)[:, None] != second)
far = (C * mask_far).sum(0)
tail = osc - C.sum(0)
Cr = C.copy(); Cr[lead, idx] = 0.0
rms = np.sqrt((Cr ** 2).sum(0))
def part(x, m):  # median signed share of the rest carried by x, in the cells m
    return round(float(np.median(x[m] / rest[m])), 3)
out = {"cells": n, "real_losses": int(real.sum()), "phase_losses": int(((np.abs(Cl) < np.abs(rest)) & ~real).sum())}
for lo, hi in ((10, 19), (20, 35), (36, 66), (67, 91)):
    m = (di >= lo) & (di <= hi)
    out[f"real_share_d{lo}_{hi}"] = round(float(real[m].mean()), 3)
out["rest_share_in_real"] = {"runner_up": part(c2, real), "other_near": part(other_near, real),
                              "far": part(far, real), "tail": part(tail, real)}
out["rest_share_elsewhere"] = {"runner_up": part(c2, ~real), "other_near": part(other_near, ~real),
                               "far": part(far, ~real), "tail": part(tail, ~real)}
out["runner_up_env_over_leader_env"] = {"real": round(float(np.median(np.abs(Zc[second, idx])[real] / env[real])), 3),
                                        "elsewhere": round(float(np.median(np.abs(Zc[second, idx])[~real] / env[~real])), 3)}
out["rest_over_rms"] = {"real": round(float(np.median((np.abs(rest) / rms)[real])), 3),
                        "elsewhere": round(float(np.median((np.abs(rest) / rms)[~real])), 3)}
out["leader_env_over_rms"] = {"real": round(float(np.median((env / rms)[real])), 3),
                              "elsewhere": round(float(np.median((env / rms)[~real])), 3)}
json.dump(out, open("remainder.json", "w"), indent=1); print(json.dumps(out, indent=1))
