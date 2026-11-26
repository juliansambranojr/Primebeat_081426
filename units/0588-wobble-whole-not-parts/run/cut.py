# Exploratory follow-up: the mirror fold of the sieve about the square root (the hyperbola).
# Its small side A = sum_{d <= sqrt N} mu(d) floor(N/d) against sqrt N. Writes cut.json.
import math, json, numpy as np
from sympy import mobius
Y = 10**5
mu = np.array([0] + [int(mobius(k)) for k in range(1, Y + 1)], dtype=np.int64)
out = {}
for N in (10**4, 10**6, 10**7, 10**8, 10**9, 10**10):
    y = math.isqrt(N); d = np.arange(1, y + 1)
    A = int(np.sum(mu[1:y + 1] * (N // d)))
    exact = N * float(np.sum(mu[1:y + 1] / d))
    out[str(N)] = {"small_side_over_sqrt": A / math.sqrt(N), "rounding_part_over_sqrt": (exact - A) / math.sqrt(N)}
json.dump(out, open("cut.json", "w"), indent=1)
print(json.dumps(out, indent=1))
