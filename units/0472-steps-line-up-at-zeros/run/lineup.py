"""The first N steps of the staircase, each turned, added up. EXPLORATORY.

Each integer n <= N carries the step Lambda(n) (log p at a prime power, else 0)
less the smooth count's 1. Turn it by the angle gamma*log n, weigh it by
n^(-1/2) and by the ramp (1 - n/N), and add:

    A_N(gamma) = | sum_{n<=N} (Lambda(n) - 1) * n^(-1/2 - i*gamma) * (1 - n/N) |

For each N, scan gamma on a grid, find the local maxima, and compare their
places with the heights of the zeros of zeta from zeros600.json.
Usage: python3 lineup.py <zeros600.json> <out.json>
"""
import json, math, sys
import numpy as np

zeros_path, out_path = sys.argv[1], sys.argv[2]
G_LO, G_HI, STEP = 10.0, 60.0, 0.005
NS = [100, 1000, 10000, 100000]
WINDOW = 1.0          # a zero is "found" if a local maximum lies within this
NEAR = 0.5            # a tall maximum further than this from every zero is "stray"

zeros = [float(z) for z in json.load(open(zeros_path))]
zs = np.array([z for z in zeros if G_LO + WINDOW <= z <= G_HI - WINDOW])
gam = np.arange(G_LO, G_HI + STEP / 2, STEP)

def mangoldt(N):
    lam = np.zeros(N + 1)
    sieve = np.ones(N + 1, dtype=bool); sieve[:2] = False
    for p in range(2, int(N ** 0.5) + 1):
        if sieve[p]:
            sieve[p * p::p] = False
    for p in np.nonzero(sieve)[0]:
        q = int(p)
        while q <= N:
            lam[q] = math.log(p); q *= int(p)
    return lam

out = {"gamma_lo": G_LO, "gamma_hi": G_HI, "gamma_step": STEP,
       "zeros_in_window": int(len(zs)), "window": WINDOW, "near": NEAR, "rows": []}
for N in NS:
    lam = mangoldt(N)
    n = np.arange(1, N + 1, dtype=float)
    coef = (lam[1:] - 1.0) * n ** -0.5 * (1.0 - n / N)
    logn = np.log(n)
    A = np.empty(len(gam))
    CH = 200
    for i in range(0, len(gam), CH):
        g = gam[i:i + CH]
        A[i:i + CH] = np.abs(np.exp(-1j * np.outer(g, logn)) @ coef)
    idx = np.nonzero((A[1:-1] > A[:-2]) & (A[1:-1] >= A[2:]))[0] + 1
    peaks_g, peaks_h = gam[idx], A[idx]
    dev, heights = [], []
    for z in zs:
        m = np.abs(peaks_g - z) <= WINDOW
        if m.any():
            j = np.argmax(np.where(m, peaks_h, -1.0))   # tallest maximum in the window
            dev.append(abs(peaks_g[j] - z)); heights.append(peaks_h[j])
    thr = 0.5 * float(np.median(heights)) if heights else 0.0
    tall = peaks_h >= thr
    dist = np.min(np.abs(peaks_g[:, None] - zs[None, :]), axis=1)
    stray = int(np.sum(tall & (dist > NEAR)))
    allz = np.array(zeros)
    dist_all = np.min(np.abs(peaks_g[:, None] - allz[None, :]), axis=1)
    stray_any = int(np.sum(tall & (dist_all > NEAR)))   # against every zero on file, edge included
    out["rows"].append({
        "N": N, "logN": round(math.log(N), 4),
        "zeros_found": len(dev),
        "max_dev": round(float(max(dev)), 4) if dev else None,
        "mean_dev": round(float(np.mean(dev)), 4) if dev else None,
        "median_peak_height": round(float(np.median(heights)), 4) if heights else None,
        "background_median": round(float(np.median(A)), 4),
        "tall_maxima": int(np.sum(tall)), "stray_tall_maxima": stray,
        "stray_against_all_zeros": stray_any})
    print(out["rows"][-1])
json.dump(out, open(out_path, "w"), indent=1)
