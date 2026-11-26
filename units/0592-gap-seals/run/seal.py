# Exploratory: Julian's seals. For each prime gap in rows 8..27 of the dyadic table, the hardest
# seal: the largest smallest-prime-factor among the composites in the gap. Its row maximum against
# the row's square root, its row mean, and the share of gaps that are twin pairs. Writes seal.json.
import json, math, numpy as np
X = 2**27
lpf = np.zeros(X + 1, dtype=np.int32)
for p in range(2, X + 1):
    if lpf[p] == 0:
        lpf[p] = p
        if p * p <= X:
            idx = np.arange(p * p, X + 1, p); sel = lpf[idx] == 0; lpf[idx[sel]] = p
P = np.nonzero(lpf == np.arange(X + 1))[0]; P = P[P >= 2]
out = {}
for r in range(8, 28):
    lo, hi = 2**(r - 1), 2**r
    ps = P[(P > lo) & (P <= hi)]
    hard = np.array([int(lpf[a + 1:b].max()) for a, b in zip(ps[:-1], ps[1:])])
    tw = int(np.sum(np.diff(ps) == 2))
    out[f"r{r}"] = {"gaps": int(len(hard)), "twin_share": tw / len(hard), "mean_hardest_over_sqrt": float(hard.mean()) / math.sqrt(hi),
                    "max_hardest_over_sqrt": int(hard.max()) / math.sqrt(hi)}
json.dump(out, open("seal.json", "w"), indent=1); print(out)
