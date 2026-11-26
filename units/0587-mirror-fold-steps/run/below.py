# Exploratory: the sieve's net rounding as the sum of the primes' steps (PrimeStep.net_by_steps),
# step_p = rough(N,p) - (N/p) prod_{q<p}(1-1/q), split at the cube root. wobble = net - smoothNet,
# smoothNet = N prod_{p<=sqrt N}(1-1/p) - 1 - Li(N) + Li(sqrt N) (SieveResidual). Rows 2^16..2^24.
# Reports, over sqrt N: the part above the cube root, the part below, the smooth correction, and
# the wobble, which must equal -(E(N) - E(sqrt N)), E = pi - Li (checked).
import json, math
import numpy as np, mpmath as mp
TOP = 2 ** 24
spf = np.zeros(TOP + 1, np.int32)
for q in range(2, TOP + 1):
    if q * q > TOP: break
    if spf[q] == 0:
        blk = spf[q * q::q]; blk[blk == 0] = q
spf[2:][spf[2:] == 0] = np.arange(2, TOP + 1)[spf[2:] == 0]
isp = spf == np.arange(TOP + 1); isp[:2] = False
pi = np.cumsum(isp, dtype=np.int64)
def Li(x): return float(mp.li(x) - mp.li(2))
out = {}
for r in range(16, 25, 2):
    N = 2 ** r; sq = math.isqrt(N); c = round(N ** (1 / 3))
    ps = [p for p in range(2, sq + 1) if isp[p]]
    above = below = 0.0; prod = 1.0
    for p in ps:
        M = N // p
        seg = spf[2:M + 1]
        rough = 1 + int(np.count_nonzero(seg >= p))
        step = rough - (N / p) * prod
        if p > c: above += step
        else: below += step
        prod *= (1 - 1 / p)
    smooth = N * prod - 1 - Li(N) + Li(sq)
    wob = above + below - smooth
    check = -((pi[N] - Li(N)) - (pi[sq] - Li(sq)))
    out[f"r{r}"] = dict(above_over_sqrt=above / sq, below_over_sqrt=below / sq,
                        smooth_over_sqrt=smooth / sq, wobble_over_sqrt=wob / sq,
                        identity_error=abs(wob - check))
    print(r, out[f"r{r}"], flush=True)
json.dump(out, open("below.json", "w"), indent=1)
