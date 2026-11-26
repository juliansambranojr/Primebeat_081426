# Exploratory: the natural, sieve and fold orders of unit 0586 on every pair of neighbouring zeta
# zeros with heights in [1000, 1500] (orders as orders.py and allpairs.py, window rule as before).
import json, math
import numpy as np, mpmath as mp
def lpf(n):
    p, m, q = 1, n, 2
    while q * q <= m:
        while m % q == 0: p, m = q, m // q
        q += 1
    return max(p, m) if m > 1 else p
def orders(M):
    ns = list(range(1, M + 1)); sv = sorted(ns, key=lambda n: (lpf(n), n))
    groups = {}
    for n in ns: groups.setdefault(lpf(n), []).append(n)
    fold = []
    for i, p in enumerate(sorted(groups)): fold += groups[p] if i % 2 == 0 else groups[p][::-1]
    return {"natural": ns, "sieve": sv, "fold": fold}
k0, k1 = int(mp.nzeros(1000)) + 1, int(mp.nzeros(1500)) - 1
gam = {j: float(mp.im(mp.zetazero(j))) for j in range(k0 - 1, k1 + 3)}
leave = {"natural": 0, "sieve": 0, "fold": 0}; stages = dict(leave)
for k in range(k0, k1 + 1):
    a, b = (gam[k - 1] + gam[k]) / 2, (gam[k + 1] + gam[k + 2]) / 2
    t = np.linspace(a, b, 801)
    th = np.array([float(mp.siegeltheta(x)) for x in t])
    M = int(math.floor(t.mean() / 2))
    terms = {n: n ** -0.5 * np.cos(th - t * math.log(n)) for n in range(1, M + 1)}
    for name, order in orders(M).items():
        S = np.zeros_like(t); c = 0
        for n in order:
            S += terms[n]
            if np.sum(np.sign(S[:-1]) * np.sign(S[1:]) < 0) < 2: c += 1
        stages[name] += c; leave[name] += c > 0
res = {"pairs": k1 - k0 + 1}
for n in leave: res[n + "_pairs_leave"] = leave[n]; res[n + "_stages_off"] = stages[n]
json.dump(res, open("higher.json", "w"), indent=1); print(res)
