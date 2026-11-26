# Exploratory: Julian's mirror fold on the sieve's steps. Above the cube root a prime's step is
# the prime count's error at the two scales N/p and p (lean_stage3/Stage3/PrimeStepTop.lean):
# D_p = E(N/p) - E(p), E(x) = pi(x) - Li(x), exact pi by a sieve. The two scales are mirrors
# about sqrt N. For N = 2^20..2^26: the paired sum over primes N^(1/3) < p <= sqrt N against
# the sizes, all over sqrt N; and the unpaired sums of E(N/p) and of E(p) alone.
import json, math
import numpy as np, mpmath as mp
TOP = 2 ** 26
s = np.ones(TOP + 1, bool); s[:2] = False
for q in range(2, int(TOP ** .5) + 1):
    if s[q]: s[q * q::q] = False
pi = np.cumsum(s).astype(np.int64)
def E(x): return float(pi[x]) - float(mp.li(x) - mp.li(2))
out = {}
for r in range(20, 27, 2):
    N = 2 ** r; sq = math.isqrt(N); c = round(N ** (1 / 3))
    ps = [p for p in range(c + 1, sq + 1) if s[p]]
    Ep = {p: E(p) for p in ps}; En = {p: E(N // p) for p in ps}
    D = [En[p] - Ep[p] for p in ps]
    row = dict(primes=len(ps),
               paired_sum_over_sqrt=abs(sum(D)) / sq,
               paired_sizes_over_sqrt=sum(abs(x) for x in D) / sq,
               top_scale_sum_over_sqrt=abs(sum(En.values())) / sq,
               low_scale_sum_over_sqrt=abs(sum(Ep.values())) / sq)
    row["paired_ratio"] = row["paired_sum_over_sqrt"] / row["paired_sizes_over_sqrt"]
    out[f"r{r}"] = row; print(r, row, flush=True)
json.dump(out, open("fold.json", "w"), indent=1)
