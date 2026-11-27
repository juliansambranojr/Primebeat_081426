# Exploratory: Julian's mirror fold of the sieve about sqrt N (HalfTaper.fold_eq), with the taper
# (HalfTaper.taper_eq). The tapered small side and the mirrored side less the smooth counts, over
# sqrt N, and their sum, the wobble. Writes fold.json.
import math, json, numpy as np, mpmath as mp
from sympy import primerange, mobius

def sieve_mu(N):
    P = list(primerange(2, math.isqrt(N) + 1)); mu = np.zeros(N + 1, dtype=np.int8); mu[1] = 1
    st = [(0, 1, 1)]
    while st:
        i, d, s = st.pop()
        for j in range(i, len(P)):
            e = d * P[j]
            if e > N: break
            mu[e] = -s; st.append((j + 1, e, -s))
    return mu

out = {"fold": {}, "small_side": {}}
for N in (10**4, 10**5, 10**6, 10**7, 3 * 10**7):
    mu = sieve_mu(N); M = np.cumsum(mu, dtype=np.int64); y = math.isqrt(N); r = math.sqrt(N)
    B = sum(int(M[N // m]) for m in range(1, N // y + 1))
    sm = 1 + float(mp.li(N) - mp.li(2)) - float(mp.li(y) - mp.li(2))
    d = np.arange(1, y + 1); At = N * float(np.sum(mu[1:y + 1] / d * (1 - d / y)))
    out["fold"][str(N)] = {"mirrored_less_smooth_over_sqrt": (B - sm) / r, "tapered_small_over_sqrt": At / r,
                           "sum_over_sqrt": (B - sm + At) / r, "max_signed_count_over_sqrt": float(np.abs(M).max()) / r}
Y = 10**5
mob = np.array([0] + [int(mobius(k)) for k in range(1, Y + 1)], dtype=float)
for N in (10**8, 10**9, 10**10):
    y = math.isqrt(N); d = np.arange(1, y + 1, dtype=float); m = mob[1:y + 1]
    out["small_side"][str(N)] = {"tapered_over_sqrt": N * float(np.sum(m / d * (1 - d / y))) / math.sqrt(N),
                                 "sharp_over_sqrt": N * float(np.sum(m / d)) / math.sqrt(N)}
json.dump(out, open("fold.json", "w"), indent=1)
print(json.dumps(out, indent=1))
