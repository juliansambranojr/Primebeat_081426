"""Does a prime's rounding remember the primes before it? EXPLORATORY.
Legendre sieve at x = 2^r: pi(x) - pi(sqrt x) + 1 = sum_d mu(d) floor(x/d), d squarefree
with every prime factor <= sqrt x. A term's rounding is {x/d}. A prime p's step is
s_p = sum over d whose largest prime factor is p of mu(d){x/d}: what the roundings
change when p joins. The net rounding is F = sum_p s_p.
Per row: lag-1..3 correlation of the steps, mean removed (raw) and after a degree-4
curve in log p is removed (fluct); the net over sqrt x; the walk ratio
|F| / sqrt(sum s_p^2); the same ratio, median of 400 draws, after random signs (coin)."""
import math, json
import numpy as np
rng = np.random.default_rng(1)
def primes(n):
    s = np.ones(n + 1, bool); s[:2] = False
    for p in range(2, int(n**.5) + 1):
        if s[p]: s[p*p::p] = False
    return np.nonzero(s)[0]
def corr(a, k): return round(float(np.corrcoef(a[:-k], a[k:])[0, 1]), 3)
out = {}
for r in range(12, 25, 2):
    x = 2**r; y = math.isqrt(x); ps = primes(y)
    big = np.zeros(x + 1, np.int64); prod = np.ones(x + 1, np.int64)
    omega = np.zeros(x + 1, np.int8); sq = np.ones(x + 1, bool)
    for p in ps:
        big[p::p] = p; prod[p::p] *= p; omega[p::p] += 1; sq[p*p::p*p] = False
    d = np.arange(x + 1, dtype=np.int64)
    ok = sq & (prod == d); ok[:2] = False
    dd = d[ok]; sgn = np.where(omega[ok] % 2 == 0, 1.0, -1.0)
    s = np.bincount(np.searchsorted(ps, big[ok]), weights=sgn * ((x % dd) / dd), minlength=len(ps))
    F = float(s.sum()); c = s - s.mean(); norm = math.sqrt(float((s**2).sum()))
    lp = np.log(ps.astype(float)); e = s - np.polyval(np.polyfit(lp, s, 4), lp)
    coin = np.median([abs(float((s * rng.choice([-1, 1], len(s))).sum())) for _ in range(400)])
    row = dict(primes=int(len(ps)), sqrt_x=int(y), net=round(F, 2),
               net_over_sqrt=round(abs(F) / y, 3), walk_ratio=round(abs(F) / norm, 3),
               coin_ratio=round(coin / norm, 3), mean_step=round(float(s.mean()), 3),
               raw_lag1=corr(c, 1), raw_lag2=corr(c, 2), raw_lag3=corr(c, 3),
               fluct_lag1=corr(e, 1), fluct_lag2=corr(e, 2), fluct_lag3=corr(e, 3))
    out[f"r{r}"] = row; print(r, row, flush=True)
json.dump(out, open("memory.json", "w"), indent=1)
