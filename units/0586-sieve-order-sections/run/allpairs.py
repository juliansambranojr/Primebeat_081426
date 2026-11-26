# Exploratory: every pair of neighbouring zeta zeros (k, k+1) with heights in [100, 600], both orders
# of unit 0586. A pair "leaves" in an order if at some stage its window holds fewer than two sign
# changes. Counts per order: pairs that ever leave, total stages off the line, pairs that never leave.
import json, math
import numpy as np, mpmath as mp
def lpf(n):
    p, m, q = 1, n, 2
    while q * q <= m:
        while m % q == 0: p, m = q, m // q
        q += 1
    return max(p, m) if m > 1 else p
k0, k1 = int(mp.nzeros(100)) + 1, int(mp.nzeros(600)) - 1
gam = {j: float(mp.im(mp.zetazero(j))) for j in range(k0 - 1, k1 + 3)}
res = {"k_first": k0, "k_last": k1, "pairs": k1 - k0 + 1}
leave = {"natural": 0, "sieve": 0}; stages = {"natural": 0, "sieve": 0}; both = 0; sieve_only = 0
for k in range(k0, k1 + 1):
    a, b = (gam[k - 1] + gam[k]) / 2, (gam[k + 1] + gam[k + 2]) / 2
    t = np.linspace(a, b, 1201)
    th = np.array([float(mp.siegeltheta(x)) for x in t])
    M = int(math.floor(t.mean() / 2))
    nat = list(range(1, M + 1)); sv = sorted(nat, key=lambda n: (lpf(n), n))
    off = {}
    for name, order in (("natural", nat), ("sieve", sv)):
        S = np.zeros_like(t); c = 0
        for n in order:
            S += n ** -0.5 * np.cos(th - t * math.log(n))
            if np.sum(np.sign(S[:-1]) * np.sign(S[1:]) < 0) < 2: c += 1
        off[name] = c; stages[name] += c; leave[name] += c > 0
    both += off["natural"] > 0 and off["sieve"] > 0
    sieve_only += off["natural"] == 0 and off["sieve"] > 0
for name in ("natural", "sieve"):
    res[name + "_pairs_leave"] = leave[name]; res[name + "_stages_off"] = stages[name]
res["leave_both"] = both; res["leave_sieve_only"] = sieve_only
json.dump(res, open("allpairs.json", "w"), indent=1); print(res)
