# Exploratory follow-up: is the doorway's tip D(x) tied to the twin count's error
# pi_2(x) - 2 C_2 Li_2(x)? Raw, then with the squares' bias and slow drift out, and a misaligned
# control. Writes tie.json.
import json, math, numpy as np, mpmath as mp
from scipy import integrate
X = 10**8
s = np.ones(X + 3, dtype=bool); s[:2] = False
for p in range(2, math.isqrt(X + 2) + 1):
    if s[p]: s[p*p::p] = False
P = np.nonzero(s[:X + 1])[0]; P = P[P > 3]
lower = P[s[P + 2]]; sign = np.where(P % 6 == 5, 1, -1); cs = np.cumsum(sign)
xs = np.unique(np.logspace(4, 8, 800).astype(np.int64))
D = np.array([cs[np.searchsorted(P, x, 'right') - 1] for x in xs], dtype=float)
C2 = 0.6601618158
L2 = lambda x: integrate.quad(lambda t: 1 / math.log(t)**2, 2, x, limit=200)[0]
R2 = np.array([np.searchsorted(lower, x, 'right') - 2 * C2 * L2(x) for x in xs])
raw = float(np.corrcoef(D / np.sqrt(xs), R2 / np.sqrt(xs))[0, 1])
a = D / np.sqrt(xs) - np.array([0.5 * float(mp.li(math.sqrt(x)) - mp.li(2)) for x in xs]) / np.sqrt(xs)
b = R2 / np.sqrt(xs); lx = np.log(xs)
ra = a - np.polyval(np.polyfit(lx, a, 2), lx); rb = b - np.polyval(np.polyfit(lx, b, 2), lx)
k = 37
out = {"raw_corr": raw, "clean_corr": float(np.corrcoef(ra, rb)[0, 1]),
       "control_corr": float(np.corrcoef(ra[k:], rb[:-k])[0, 1])}
json.dump(out, open("tie.json", "w"), indent=1); print(out)
