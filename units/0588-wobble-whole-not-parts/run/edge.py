# Exploratory follow-up: the pairing form (Stage3/HalfPair.lean) against the sieve's own products,
# and the split of the wobble at d = N/2. Writes edge.json.
import math, json, random, numpy as np, mpmath as mp
from sympy import primerange, primepi

def products(N):
    P = list(primerange(2, math.isqrt(N) + 1)); ds = [1]; ss = [1]; st = [(0, 1, 1)]
    while st:
        i, d, s = st.pop()
        for j in range(i, len(P)):
            e = d * P[j]
            if e > N: break
            ds.append(e); ss.append(-s); st.append((j + 1, e, -s))
    return np.array(ds, dtype=np.int64), np.array(ss, float)

out = {"form": {}, "split": {}}
for X in (10**3, 10**4, 10**5):
    d, s = products(X); Q = 0.0
    for i in range(0, len(d), 1000):
        g = np.gcd.outer(d[i:i+1000], d).astype(float)
        Q += float(s[i:i+1000] @ (((g**2 + 2) / np.outer(d[i:i+1000], d)) @ s))
    Q /= 12
    D = float(np.sum((d.astype(float)**2 + 2) / (12 * d.astype(float)**2)))
    out["form"][str(X)] = {"form_over_X": Q / X, "pairs_over_diagonal": (Q - D) / D}
random.seed(3)
for X, n in ((10**4, 200), (10**5, 200), (10**6, 60)):
    saw = []; smooth = []; wob = []
    for N in random.sample(range(X, 2 * X), n):
        d, s = products(N); c = ((N % d) / d - 0.5) * s
        S = float(c[d <= N // 2].sum())
        w = -((int(primepi(N)) - float(mp.li(N) - mp.li(2)))
              - (int(primepi(math.isqrt(N))) - float(mp.li(math.isqrt(N)) - mp.li(2))))
        saw.append(S); smooth.append(w - S); wob.append(w)
    r = lambda v: math.sqrt(np.mean(np.square(v))) / math.sqrt(X)
    out["split"][str(X)] = {"sawtooth_rms_over_sqrt": r(saw), "smooth_rms_over_sqrt": r(smooth),
                            "wobble_rms_over_sqrt": r(wob)}
json.dump(out, open("edge.json", "w"), indent=1)
print(json.dumps(out, indent=1))
