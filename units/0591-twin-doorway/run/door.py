# Exploratory: Julian's doorway. Primes above 3 split at each 6k into 6k-1 and 6k+1; the
# difference D(x) of the two sides, against sqrt x, and how much of it the twin pairs carry
# (Stage3/TwinDoor.lean proves: none). Writes door.json.
import json, math, numpy as np
X = 10**8
s = np.ones(X + 3, dtype=bool); s[:2] = False
for p in range(2, math.isqrt(X + 2) + 1):
    if s[p]: s[p*p::p] = False
P = np.nonzero(s[:X + 1])[0]; P = P[P > 3]
twin = s[P - 2] | s[P + 2]; minus = (P % 6 == 5); plus = ~minus
out = {}
for x in (10**4, 10**5, 10**6, 10**7, 10**8):
    m = P <= x
    D = int(np.sum(minus & m)) - int(np.sum(plus & m))
    Dt = int(np.sum(minus & m & twin)) - int(np.sum(plus & m & twin))
    out[str(x)] = {"difference": D, "difference_over_sqrt": D / math.sqrt(x), "twins_difference": Dt,
                   "twin_share": float(np.sum(twin & m) / np.sum(m))}
json.dump(out, open("door.json", "w"), indent=1); print(out)
