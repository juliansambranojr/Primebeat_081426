"""From one zero's residual to the next. EXPLORATORY.

The steps of the staircase, turned and added (unit 0472):

    A_N(gamma) = | sum_{n<=N} (Lambda(n) - 1) * n^(-1/2 - i*gamma) * (1 - n/N) |

For each of the twelve zeros between 11 and 59 (heights from zeros600.json) and
each cutoff N, the residual is  r_j(N) = (place of the peak of A_N near the
zero) - (the zero's height).  The residuals are followed as the cutoff grows,
and set beside the distance from each zero to its neighbours.

Three readings:
 (1) at each cutoff, the signed sum of the twelve residuals beside the sum of
     their sizes;
 (2) for each zero, the rate at which its residual turns as log N grows (the
     best single frequency), beside the distances to its two neighbours;
 (3) for each neighbouring pair, the correlation of the two residuals over the
     cutoffs.
Usage: python3 beat.py <zeros600.json> <out.json>
"""
import json, math, sys
import numpy as np

zeros_path, out_path = sys.argv[1], sys.argv[2]
N_LO, N_HI, N_COUNT = 1000, 3000000, 48
HALF, STEP = 0.1, 0.005
zeros = [float(z) for z in json.load(open(zeros_path))]
zs = [z for z in zeros if 11.0 <= z <= 59.0]
NS = sorted(set(int(round(x)) for x in np.exp(np.linspace(math.log(N_LO), math.log(N_HI), N_COUNT))))
t = np.log(np.array(NS, dtype=float))

N = NS[-1]
lam = np.zeros(N + 1)
sieve = np.ones(N + 1, dtype=bool); sieve[:2] = False
for p in range(2, int(N ** 0.5) + 1):
    if sieve[p]:
        sieve[p * p::p] = False
for p in np.nonzero(sieve)[0]:
    q = int(p)
    while q <= N:
        lam[q] = math.log(p); q *= int(p)
n = np.arange(1, N + 1, dtype=float)
c = lam[1:] - 1.0
logn = np.log(n)
w0, w1 = c * n ** -0.5, c * n ** 0.5
idx = np.array(NS) - 1
offs = np.arange(-HALF, HALF + STEP / 2, STEP)

res = np.zeros((len(zs), len(NS)))
for j, z in enumerate(zs):
    A = np.zeros((len(offs), len(NS)))
    for i, o in enumerate(offs):
        ph = np.exp(-1j * (z + o) * logn)
        a = np.cumsum(w0 * ph)[idx]
        b = np.cumsum(w1 * ph)[idx]
        A[i] = np.abs(a - b / np.array(NS))
    for k in range(len(NS)):
        m = int(np.argmax(A[:, k]))
        if 0 < m < len(offs) - 1:          # parabola through the top three
            y0, y1, y2 = A[m - 1, k], A[m, k], A[m + 1, k]
            d = 0.5 * (y0 - y2) / (y0 - 2 * y1 + y2)
            res[j, k] = offs[m] + d * STEP
        else:
            res[j, k] = offs[m]

out = {"zeros_used": len(zs), "cutoffs": len(NS), "cutoff_lo": NS[0], "cutoff_hi": NS[-1],
       "span_logN": round(float(t[-1] - t[0]), 3),
       "frequency_resolution": round(2 * math.pi / float(t[-1] - t[0]), 3)}

# (1) the signed sum beside the sum of sizes
signed = res.sum(axis=0); sizes = np.abs(res).sum(axis=0)
out["median_abs_signed_sum"] = round(float(np.median(np.abs(signed))), 5)
out["median_sum_of_sizes"] = round(float(np.median(sizes)), 5)
out["median_ratio_signed_to_sizes"] = round(float(np.median(np.abs(signed) / sizes)), 4)

# (2) each zero's residual: the best single frequency in log N
om = np.arange(0.6, 9.0, 0.01)
def best_freq(y):
    y = y - y.mean(); tot = float(y @ y); best = (0.0, 0.0)
    for w in om:
        X = np.column_stack([np.cos(w * t), np.sin(w * t)])
        cc, *_ = np.linalg.lstsq(X, y, rcond=None)
        sh = 1.0 - float(np.sum((y - X @ cc) ** 2)) / tot
        if sh > best[1]:
            best = (float(w), sh)
    return best
out["zeros"] = []
gaps_near, freqs = [], []
for j, z in enumerate(zs):
    gl = z - zs[j - 1] if j > 0 else None
    gr = zs[j + 1] - z if j + 1 < len(zs) else None
    near = min(g for g in (gl, gr) if g is not None)
    w, sh = best_freq(res[j])
    cand = [g for g in (gl, gr) if g is not None]
    closest = min(cand, key=lambda g: abs(g - w))
    row = {"rank": j + 1, "height": round(z, 4),
           "gap_below": None if gl is None else round(gl, 4),
           "gap_above": None if gr is None else round(gr, 4),
           "turning_rate": round(w, 3), "share": round(sh, 3),
           "nearer_gap_to_rate": round(closest, 4), "rate_minus_gap": round(w - closest, 3),
           "rms_residual": round(float(np.sqrt(np.mean(res[j] ** 2))), 5)}
    out["zeros"].append(row); print(row)
    gaps_near.append(closest); freqs.append(w)
out["corr_rate_with_gap"] = round(float(np.corrcoef(freqs, gaps_near)[0, 1]), 3)
out["median_abs_rate_minus_gap"] = round(float(np.median(np.abs(np.array(freqs) - np.array(gaps_near)))), 3)
out["rates_within_resolution"] = int(np.sum(np.abs(np.array(freqs) - np.array(gaps_near)) <= out["frequency_resolution"]))
closer = [min(g for g in (r["gap_below"], r["gap_above"]) if g is not None) for r in out["zeros"]]
out["matched_gap_is_closer_neighbour"] = int(sum(1 for r, g in zip(out["zeros"], closer) if abs(r["nearer_gap_to_rate"] - g) < 1e-9))
out["corr_rate_with_closer_gap"] = round(float(np.corrcoef(freqs, closer)[0, 1]), 3)
out["closest_pair_gap"] = round(float(min(closer)), 4)

# (3) neighbouring pairs: correlation of the two residuals over the cutoffs
out["pairs"] = []
for j in range(len(zs) - 1):
    r = float(np.corrcoef(res[j], res[j + 1])[0, 1])
    row = {"pair": f"{j+1}-{j+2}", "gap": round(zs[j + 1] - zs[j], 4), "correlation": round(r, 3)}
    out["pairs"].append(row); print(row)
pc = np.array([p["correlation"] for p in out["pairs"]])
out["pairs_negative"] = int(np.sum(pc < 0)); out["pairs_total"] = int(len(pc))
out["mean_pair_correlation"] = round(float(pc.mean()), 3)
far = [float(np.corrcoef(res[j], res[k])[0, 1]) for j in range(len(zs)) for k in range(j + 3, len(zs))]
out["mean_far_correlation"] = round(float(np.mean(far)), 3)
print({k: v for k, v in out.items() if not isinstance(v, list)})
json.dump(out, open(out_path, "w"), indent=1)
