# Exploratory: Julian's readings of the seal as an order of the sediment, on the same 311 pairs as
# allpairs.py (heights 100..600). Orders: least prime factor groups ascending (CompositeSplit's
# least-prime split); largest prime factor groups descending (outward then inward); primes first
# (1, then primes ascending, then composites ascending); sieve groups alternating direction (the
# fold: odd-numbered groups ascending, even-numbered descending). Counts as allpairs.py.
import json, math
import numpy as np, mpmath as mp
def factors(n):
    f, m, q = [], n, 2
    while q * q <= m:
        while m % q == 0: f.append(q); m //= q
        q += 1
    if m > 1: f.append(m)
    return f
def lpf(n): f = factors(n); return max(f) if f else 1
def spf(n): f = factors(n); return min(f) if f else 1
def isprime(n): return n > 1 and len(factors(n)) == 1
def orders(M):
    ns = list(range(1, M + 1))
    out = {"least_prime": sorted(ns, key=lambda n: (spf(n), n)),
           "largest_desc": sorted(ns, key=lambda n: (-lpf(n), n)),
           "primes_first": [1] + [n for n in ns if isprime(n)] + [n for n in ns if n > 1 and not isprime(n)]}
    groups = {}
    for n in ns: groups.setdefault(lpf(n), []).append(n)
    fold = []
    for i, p in enumerate(sorted(groups)):
        fold += groups[p] if i % 2 == 0 else groups[p][::-1]
    out["fold"] = fold
    return out
k0, k1 = int(mp.nzeros(100)) + 1, int(mp.nzeros(600)) - 1
gam = {j: float(mp.im(mp.zetazero(j))) for j in range(k0 - 1, k1 + 3)}
names = ["least_prime", "largest_desc", "primes_first", "fold"]
leave = dict.fromkeys(names, 0); stages = dict.fromkeys(names, 0)
for k in range(k0, k1 + 1):
    a, b = (gam[k - 1] + gam[k]) / 2, (gam[k + 1] + gam[k + 2]) / 2
    t = np.linspace(a, b, 1201)
    th = np.array([float(mp.siegeltheta(x)) for x in t])
    M = int(math.floor(t.mean() / 2))
    terms = {n: n ** -0.5 * np.cos(th - t * math.log(n)) for n in range(1, M + 1)}
    for name, order in orders(M).items():
        S = np.zeros_like(t); c = 0
        for n in order:
            S += terms[n]
            if np.sum(np.sign(S[:-1]) * np.sign(S[1:]) < 0) < 2: c += 1
        stages[name] += c; leave[name] += c > 0
res = {"pairs": k1 - k0 + 1}
for name in names:
    res[name + "_pairs_leave"] = leave[name]; res[name + "_stages_off"] = stages[name]
json.dump(res, open("orders.json", "w"), indent=1); print(res)
