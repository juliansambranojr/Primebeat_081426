# Exploratory correction: the tapered small side over sqrt N is g(x) = x Σ_{d≤x} μ(d)/d − M(x),
# x = sqrt N. Measured past the range of fold.py, to x = 10^7 (N = 10^14). Writes reach.json.
import json, numpy as np
X = 10**7
mu = np.ones(X + 1, dtype=np.int8); isp = np.ones(X + 1, dtype=bool); isp[:2] = False
for p in range(2, X + 1):
    if isp[p]:
        isp[2*p::p] = False; mu[p::p] *= -1; mu[p*p::p*p] = 0
mu[0] = 0
M = np.cumsum(mu, dtype=np.int64); H = np.cumsum(mu / np.arange(X + 1, dtype=float).clip(1))
out = {str(x): float(x * H[x] - M[x]) for x in (10**3, 10**5, 10**6, 10**7)}
xs = np.unique(np.logspace(3, 7, 4000).astype(int)); g = xs * H[xs] - M[xs]
out["range_min"] = float(g.min()); out["range_max"] = float(g.max())
json.dump(out, open("reach.json", "w"), indent=1); print(out)
