"""The size rate of the zeros, read from the steps. EXPLORATORY.

lineup.py put the weight n^(-1/2) in by hand. Here the weight n^(-sigma) is
tried at several sigma, and the steps are asked for the size rate themselves.

    S_N(sigma, gamma) = sum_{n<=N} (Lambda(n) - 1) * n^(-sigma - i*gamma) * (1 - n/N)

As N grows, S_N changes by terms of size N^(beta - sigma), beta the real part
of the zeros that drive it. With three cutoffs in ratio 10,

    R = |S_N3 - S_N2| / |S_N2 - S_N1|  ~  10^(beta - sigma),

so  beta_hat = sigma + log10(R),  whatever sigma was tried.
Evaluated at the heights of the zeros (from zeros600.json) and at the
midpoints between neighbouring zeros.
Usage: python3 sizerate.py <zeros600.json> <out.json>
"""
import json, math, sys
import numpy as np

zeros_path, out_path = sys.argv[1], sys.argv[2]
NS = [10**5, 10**6, 10**7]
SIGMAS = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
G_LO, G_HI = 11.0, 59.0

zeros = [float(z) for z in json.load(open(zeros_path))]
zs = [z for z in zeros if G_LO <= z <= G_HI]
mids = [(a + b) / 2 for a, b in zip(zs[:-1], zs[1:])]

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
w0 = {s: c * n ** (-s) for s in SIGMAS}          # for the plain sum
w1 = {s: c * n ** (1.0 - s) for s in SIGMAS}     # for the ramp's n/N part

def S_all(g):
    ph = np.exp(-1j * g * logn)
    res = {}
    for s in SIGMAS:
        a, b = w0[s] * ph, w1[s] * ph
        res[s] = [a[:M].sum() - b[:M].sum() / M for M in NS]
    return res

def beta_hats(heights):
    table = {s: [] for s in SIGMAS}
    for g in heights:
        r = S_all(g)
        for s in SIGMAS:
            s1, s2, s3 = r[s]
            table[s].append(s + math.log10(abs(s3 - s2) / abs(s2 - s1)))
    return table

out = {"cutoffs": NS, "zeros_used": len(zs), "midpoints_used": len(mids), "rows": []}
for name, hs in (("at_zeros", zs), ("at_midpoints", mids)):
    t = beta_hats(hs)
    allv = []
    for s in SIGMAS:
        v = np.array(t[s]); allv += list(v)
        row = {"where": name, "sigma": s, "beta_mean": round(float(v.mean()), 4),
               "beta_min": round(float(v.min()), 4), "beta_max": round(float(v.max()), 4)}
        out["rows"].append(row); print(row)
    out[name + "_overall_mean"] = round(float(np.mean(allv)), 4)
    out[name + "_overall_min"] = round(float(np.min(allv)), 4)
    out[name + "_overall_max"] = round(float(np.max(allv)), 4)
    print(name, out[name + "_overall_mean"], out[name + "_overall_min"], out[name + "_overall_max"])
json.dump(out, open(out_path, "w"), indent=1)
