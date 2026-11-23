"""EXPLORATORY. The tie across the scales, measured.
For N: r(x) = pi(x) - Li(x), Li as Stage3.Li (x/log x + int_2^x dt/log^2 t = li(x) - li(2) + 2/log 2).
  own      = r(N)
  others   = sum_{m=2}^{floor(sqrt N)} r(N/m)          (floor division: pi(N/m) = pi(floor(N/m)); Li at the real N/m)
  root     = floor(sqrt N) * r(sqrt N)
  comb     = own + others - root   = minus the residual of the count of combinations (Compression.compression)
  absothers= sum_{m=2}^{floor(sqrt N)} |r(N/m)|
"""
import json, math
import numpy as np
from scipy.special import expi
def Li(x): return float(expi(math.log(x)) - expi(math.log(2.0)) + 2/math.log(2.0))
NMAX = 10**8
sieve = np.ones(NMAX+1, dtype=bool); sieve[:2] = False
for i in range(2, int(NMAX**0.5)+1):
    if sieve[i]: sieve[i*i::i] = False
cum = np.cumsum(sieve, dtype=np.int64)
def r(x): return int(cum[int(math.floor(x))]) - Li(x)
rows = []
for e in range(4, 9):
    N = 10**e; s = math.isqrt(N)
    own = r(N)
    parts = [r(N/m) for m in range(2, s+1)]
    others = sum(parts); absothers = sum(abs(p) for p in parts)
    root = s * r(s)
    comb = own + others - root
    rows.append(dict(N=N, sqrtN=round(N**0.5,1), N34=round(N**0.75,1), own=round(own,2), others=round(others,2),
                     absothers=round(absothers,2), root=round(root,2), comb=round(comb,2),
                     own_over_sqrt=round(own/N**0.5,4), others_over_sqrt=round(others/N**0.5,4),
                     others_over_N34=round(others/N**0.75,4), absothers_over_N34=round(absothers/N**0.75,4),
                     comb_over_N34=round(comb/N**0.75,4), comb_over_sqrt=round(comb/N**0.5,4)))
    print(rows[-1])
json.dump(dict(rows=rows), open('scales.json','w'), indent=1)
