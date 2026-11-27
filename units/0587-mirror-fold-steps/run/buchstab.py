# Exploratory: each prime's rough count against a smooth model with no overcount.
# rough(N,p) = numbers up to x = N/p with no prime factor below p. Smooth model: Buchstab's
# x*omega(u)/log p, u = log x / log p, omega by its delay equation (u omega(u))' = omega(u-1),
# omega = 1/u on [1,2]; plus 1 for m = 1. Piece e_p = rough - model. Rows 2^16..2^24.
# Over sqrt N: the sum of the pieces, the sum of their sizes, their ratio; and above and below
# the cube root apart.
import json, math
import numpy as np
TOP = 2 ** 24
spf = np.zeros(TOP + 1, np.int32)
for q in range(2, math.isqrt(TOP) + 1):
    if spf[q] == 0:
        blk = spf[q * q::q]; blk[blk == 0] = q
idx = np.arange(TOP + 1); spf[2:][spf[2:] == 0] = idx[2:][spf[2:] == 0]
isp = spf == idx; isp[:2] = False
H = 1e-4; U = np.arange(1.0, 40.0 + H, H); om = np.zeros_like(U)
m2 = U <= 2; om[m2] = 1 / U[m2]
lag = int(round(1 / H)); uw = U * om
for i in range(len(U)):
    if U[i] > 2:
        uw[i] = uw[i - 1] + H * om[i - lag]; om[i] = uw[i] / U[i]
def omega(u): return float(np.interp(u, U, om)) if u >= 1 else 0.0
out = {}
for r in range(16, 25, 2):
    N = 2 ** r; sq = math.isqrt(N); c = round(N ** (1 / 3))
    tot = {"above": 0.0, "below": 0.0}; size = {"above": 0.0, "below": 0.0}
    for p in range(2, sq + 1):
        if not isp[p]: continue
        x = N // p
        rough = 1 + int(np.count_nonzero(spf[2:x + 1] >= p))
        u = math.log(x) / math.log(p)
        model = 1 + (x * omega(u) / math.log(p) if u >= 1 else 0.0)
        e = rough - model; side = "above" if p > c else "below"
        tot[side] += e; size[side] += abs(e)
    s_all = tot["above"] + tot["below"]; z_all = size["above"] + size["below"]
    out[f"r{r}"] = dict(sum_over_sqrt=s_all / sq, sizes_over_sqrt=z_all / sq, ratio=abs(s_all) / z_all,
                        above_sum_over_sqrt=tot["above"] / sq, below_sum_over_sqrt=tot["below"] / sq)
    print(r, out[f"r{r}"], flush=True)
json.dump(out, open("buchstab.json", "w"), indent=1)
