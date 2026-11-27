# Exploratory: the two orders of unit 0586 on more pairs of neighbouring zeta zeros: the five
# closest pairs below the point run's height that unit 0578 found (heights about 221, 295, 334,
# 376, 415) and zeros 725/726. Same window rule and count as order.py.
import json, math
import numpy as np, mpmath as mp
def lpf(n):
    p, m, q = 1, n, 2
    while q * q <= m:
        while m % q == 0: p, m = q, m // q
        q += 1
    return max(p, m) if m > 1 else p
def pair_index(h):
    k = int(mp.nzeros(h))          # zeros with height <= h
    return k                       # pair is (k, k+1) when h sits between them
targets = [221.07, 295.27, 333.93, 376.08, 415.24]
pairs = [pair_index(h) for h in targets] + [725]
out = {}
for k in pairs:
    g = {j: float(mp.im(mp.zetazero(j))) for j in (k - 1, k, k + 1, k + 2)}
    a, b = (g[k - 1] + g[k]) / 2, (g[k + 1] + g[k + 2]) / 2
    t = np.linspace(a, b, 3001)
    th = np.array([float(mp.siegeltheta(x)) for x in t])
    M = int(math.floor(t.mean() / 2))
    nat = list(range(1, M + 1)); sv = sorted(nat, key=lambda n: (lpf(n), n))
    row = {"k": k, "heights": [g[k], g[k + 1]], "M": M}
    for name, order in (("natural", nat), ("sieve", sv)):
        S = np.zeros_like(t); below = 0
        for n in order:
            S += n ** -0.5 * np.cos(th - t * math.log(n))
            if np.sum(np.sign(S[:-1]) * np.sign(S[1:]) < 0) < 2: below += 1
        row[name + "_stages_off_line"] = below
    out[f"pair{k}"] = row
    print(k, row, flush=True)
json.dump(out, open("pairs.json", "w"), indent=1)
