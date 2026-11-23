"""Row r from the rows up to r/2. EXPLORATORY.

The sieve (Legendre): the integers up to x with no prime factor <= sqrt(x) are
1 and the primes in (sqrt(x), x]. Counting them by inclusion and exclusion over
the squarefree d whose prime factors are all <= sqrt(x):

    pi(x) - pi(sqrt x) + 1  =  sum_d  mu(d) * floor(x/d)

Only primes up to sqrt(x) enter the right side: on the ladder, row r is built
from the rows up to r/2. The sum is taken level by level, the level k being the
number of primes in d (sign (-1)^k), which is the shape of a row of Pascal.

Each term splits as  floor(x/d) = x/d - {x/d}.  The first parts are exact
fractions, the second are roundings, each below 1. Measured, per row:
  - whether the sum reproduces the table's pi(2^r) exactly;
  - the smooth part  M = sum mu(d) x/d  and the net rounding  F = sum mu(d){x/d},
    count = M - F - (pi(sqrt x) - 1) ... see `net_rounding`;
  - the roundings' total mass, sum over d of {x/d}, beside their net;
  - the table's residual pi - li, beside both.
Usage: python3 half.py <pi2n_cache.json> <out.json>
"""
import json, math, sys
import numpy as np
import mpmath as mp

cache, out_path = sys.argv[1], sys.argv[2]
R_LO, R_HI = 10, 24
d0 = json.load(open(cache))
pi_tab = {int(k): int(v) for k, v in d0.get("pi", d0).items() if str(k).isdigit()}

def small_primes(n):
    s = np.ones(n + 1, dtype=bool); s[:2] = False
    for p in range(2, int(n ** 0.5) + 1):
        if s[p]:
            s[p * p::p] = False
    return [int(p) for p in np.nonzero(s)[0]]

out = {"row_lo": R_LO, "row_hi": R_HI, "rows": []}
for r in range(R_LO, R_HI + 1):
    x = 2 ** r
    y = math.isqrt(x)
    ps = small_primes(y)
    omega = np.zeros(x + 1, dtype=np.int8)
    prod = np.ones(x + 1, dtype=np.int64)
    sqfree = np.ones(x + 1, dtype=bool)
    for p in ps:
        omega[p::p] += 1
        prod[p::p] *= p
        sqfree[p * p::p * p] = False
    d = np.arange(x + 1, dtype=np.int64)
    ok = sqfree & (prod == d); ok[0] = False        # squarefree, every prime factor <= sqrt(x)
    dd = d[ok]; kk = omega[ok].astype(int)
    q = x // dd
    frac = (x - q * dd) / dd                          # {x/d}
    sign = np.where(kk % 2 == 0, 1, -1)
    count = int(np.sum(sign * q)) + len(ps) - 1       # pi(x) by the sieve
    M = float(np.sum(sign * (x / dd)))
    F = float(np.sum(sign * frac))
    mass = float(np.sum(frac))
    kmax = int(kk.max())
    resid = float(pi_tab[r] - mp.li(mp.mpf(x)))
    row = {"r": r, "primes_used_up_to": y, "primes_used": len(ps), "terms": int(len(dd)),
           "levels": kmax + 1, "pi_by_sieve": count, "pi_in_table": pi_tab[r],
           "exact": bool(count == pi_tab[r]),
           "smooth_part": round(M, 3), "net_rounding": round(F, 3),
           "rounding_mass": round(mass, 3),
           "net_over_mass": round(abs(F) / mass, 6),
           "residual_pi_minus_li": round(resid, 3),
           "residual_over_mass": round(abs(resid) / mass, 8),
           "residual_over_sqrt": round(resid / math.sqrt(x), 4)}
    if r == R_HI:
        row["level_mass"] = [round(float(np.sum(frac[kk == k])), 3) for k in range(kmax + 1)]
        row["level_terms"] = [int(np.sum(kk == k)) for k in range(kmax + 1)]
    out["rows"].append(row)
    print({k: v for k, v in row.items() if not isinstance(v, list)})
last = out["rows"][-1]
print("levels at top row", last["level_terms"], last["level_mass"])
out["all_exact"] = bool(all(rw["exact"] for rw in out["rows"]))
out["rows_checked"] = len(out["rows"])
json.dump(out, open(out_path, "w"), indent=1)
