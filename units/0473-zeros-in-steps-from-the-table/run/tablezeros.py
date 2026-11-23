"""The zeros in steps, from the table's residuals. EXPLORATORY.

No file of zeros is read. Two readings of the same staircase are set against
each other.

(1) The staircase's own peaks. As in unit 0472: the first N steps, each turned
    by gamma*log n and weighed by n^(-1/2), added; the tall local maxima over
    gamma are the heights the steps line up at.

(2) The table's residuals. a_r = (pi(2^r) - li(2^r)) / (sqrt(2^r)/log 2^r) along
    the doublings, from the repo's cache of pi(2^n). On the ladder a height
    gamma can only show as the angle  gamma*log 2  taken mod 2*pi  and folded
    to [0, pi]: heights that differ by 2*pi/log 2 look the same.

Compared: (A) the table's spectrum against the folded angles of the staircase's
lowest peaks; (B) how much of the table's residual the lowest peaks' angles
account for, against the same number of random angles.
Usage: python3 tablezeros.py <pi2n_cache.json> <out.json>
"""
import json, math, sys
import numpy as np
import mpmath as mp
mp.mp.dps = 40

cache, out_path = sys.argv[1], sys.argv[2]
N, G_LO, G_HI, STEP = 100000, 10.0, 45.0, 0.005
R_LO = 10
LOG2 = math.log(2.0)
PERIOD = 2 * math.pi / LOG2

# ---- (1) the staircase's own peaks ------------------------------------------
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
coef = (lam[1:] - 1.0) * n ** -0.5 * (1.0 - n / N)
logn = np.log(n)
gam = np.arange(G_LO, G_HI + STEP / 2, STEP)
A = np.empty(len(gam))
for i in range(0, len(gam), 200):
    A[i:i + 200] = np.abs(np.exp(-1j * np.outer(gam[i:i + 200], logn)) @ coef)
idx = np.nonzero((A[1:-1] > A[:-2]) & (A[1:-1] >= A[2:]))[0] + 1
tall = idx[A[idx] >= 0.6 * A[idx].max()]
peaks = [float(g) for g in gam[tall]]            # ascending in gamma

def fold(g):
    t = (g * LOG2) % (2 * math.pi)
    return min(t, 2 * math.pi - t)

# ---- (2) the table's residuals ----------------------------------------------
d = json.load(open(cache))
pi = {int(k): int(v) for k, v in d.get("pi", d).items() if str(k).isdigit()}
rs = np.array([r for r in sorted(pi) if r >= R_LO], dtype=float)
a = np.array([float((pi[int(r)] - mp.li(mp.mpf(2) ** int(r)))
                    / (mp.sqrt(mp.mpf(2) ** int(r)) / (int(r) * mp.log(2)))) for r in rs])
# remove the level and its slow drift: fit c0 + c1/r
X0 = np.column_stack([np.ones_like(rs), 1.0 / rs])
c, *_ = np.linalg.lstsq(X0, a, rcond=None)
dres = a - X0 @ c
var0 = float(np.sum(dres ** 2))

# (A) spectrum of the table's residual on [0, pi], Hann window
win = np.hanning(len(rs))
alpha = np.arange(0.05, math.pi, 0.0005)
spec = np.abs(np.exp(-1j * np.outer(alpha, rs)) @ (dres * win)) * 2.0 / win.sum()
si = np.nonzero((spec[1:-1] > spec[:-2]) & (spec[1:-1] >= spec[2:]))[0] + 1
order = si[np.argsort(-spec[si])]
top = [(float(alpha[j]), float(spec[j])) for j in order[:5]]

out = {"N": N, "gamma_lo": G_LO, "gamma_hi": G_HI, "staircase_peaks": len(peaks),
       "rows_used": int(len(rs)), "row_lo": R_LO, "row_hi": int(rs[-1]),
       "period_in_height": round(PERIOD, 4), "level": round(float(c[0]), 4),
       "resolution_angle": round(4 * math.pi / len(rs), 4), "peaks": [], "spectrum_top": []}
for k, g in enumerate(peaks[:6]):
    al = fold(g)
    j = si[np.argmin(np.abs(alpha[si] - al))]
    out["peaks"].append({"rank": k + 1, "height": round(g, 3), "folded_angle": round(al, 4),
                         "weight_2_over_height": round(2.0 / g, 4),
                         "nearest_table_max": round(float(alpha[j]), 4),
                         "angle_gap": round(abs(float(alpha[j]) - al), 4),
                         "table_amplitude_there": round(float(spec[j]), 4)})
for k, (al, am) in enumerate(top):
    gaps = [abs(al - fold(g)) for g in peaks]
    m = int(np.argmin(gaps))
    out["spectrum_top"].append({"rank": k + 1, "angle": round(al, 4), "amplitude": round(am, 4),
                                "nearest_peak_height": round(peaks[m], 3),
                                "nearest_peak_rank": m + 1, "angle_gap": round(gaps[m], 4)})

# (B) how much of the table's residual do the lowest peaks' angles account for
def explained(angles):
    cols = [np.ones_like(rs), 1.0 / rs]
    for t in angles:
        cols += [np.sin(rs * t), np.cos(rs * t)]
    X = np.column_stack(cols)
    cc, *_ = np.linalg.lstsq(X, a, rcond=None)
    return 1.0 - float(np.sum((a - X @ cc) ** 2)) / var0

rng = np.random.default_rng(20261123)
out["explained"] = []
for M in (1, 2, 3, 5):
    ang = [fold(g) for g in peaks[:M]]
    rnd = [explained(list(rng.uniform(0.05, math.pi, M))) for _ in range(500)]
    out["explained"].append({"peaks_used": M, "share": round(explained(ang), 4),
                             "random_mean": round(float(np.mean(rnd)), 4),
                             "random_p95": round(float(np.quantile(rnd, 0.95)), 4),
                             "random_max": round(float(np.max(rnd)), 4)})
for k in ("peaks", "spectrum_top", "explained"):
    for row in out[k]:
        print(k, row)
print({k: v for k, v in out.items() if not isinstance(v, list)})
json.dump(out, open(out_path, "w"), indent=1)
