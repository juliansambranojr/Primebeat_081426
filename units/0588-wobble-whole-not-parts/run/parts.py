# Exploratory: the wobble of HalfSieve, split three ways along Stage3/HalfSplit.lean, each part
# measured against the square root. Writes parts.json.
import math, json, numpy as np, mpmath as mp
from sympy import primerange

def products(N):
    P = list(primerange(2, math.isqrt(N) + 1)); ds = [1]; ss = [1]; tops = [1]
    stack = [(0, 1, 1)]
    while stack:
        i, d, s = stack.pop()
        for j in range(i, len(P)):
            e = d * P[j]
            if e > N: break
            ds.append(e); ss.append(-s); tops.append(P[j]); stack.append((j + 1, e, -s))
    return P, np.array(ds, dtype=np.int64), np.array(ss, float), np.array(tops)

out = {"balance": {}, "recursion": {}, "by_parts": {}}
for N in (10**5, 3 * 10**5, 10**6, 3 * 10**6, 10**7):
    P, d, s, _ = products(N); r = math.sqrt(N)
    A = float(np.sum(s * (N / d))); B = float(np.sum(s * ((N % d) / d - 0.5))); C = 0.5 * float(s.sum())
    sm = 1 + float(mp.li(N) - mp.li(2)) - float(mp.li(math.isqrt(N)) - mp.li(2))
    out["balance"][str(N)] = {"balance_over_sqrt": (sm - A + C) / r, "centered_over_sqrt": B / r,
                              "wobble_over_sqrt": (sm - A + C + B) / r, "products": int(len(d))}
for N in (10**5, 10**6):
    P, d, s, tops = products(N); r = math.sqrt(N)
    terms = s * np.cos(2 * np.pi * N / d)
    piece = {p: 0.0 for p in P}
    for t, p in zip(terms[1:], tops[1:]): piece[int(p)] += t
    h = np.array([piece[p] for p in P]); ratio = np.array([abs(piece[p]) / math.sqrt(N / p) for p in P])
    out["recursion"][str(N)] = {"harmonic": float(terms.sum()), "sum_abs_pieces": float(np.abs(h).sum()),
        "sum_sqrt_scales_over_sqrt": sum(math.sqrt(N / p) for p in P) / r,
        "median_piece_over_scale": float(np.median(ratio)), "max_piece_over_scale": float(ratio.max())}
    mu = np.zeros(N + 1); mu[d] = s; M = np.cumsum(mu)
    out["by_parts"][str(N)] = {"max_abs_mertens_over_sqrt": float(np.abs(M[1:]).max()) / r}
json.dump(out, open("parts.json", "w"), indent=1)
print(json.dumps(out, indent=1))
