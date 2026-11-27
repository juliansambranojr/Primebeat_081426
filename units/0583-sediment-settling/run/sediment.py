# Exploratory: Julian, 2026-11-26 -- the basins settle as the sediment arrives.
# Lambda_N(s) = pi^{-s/2} Gamma(s/2) sum_{n<=N} n^{-s} + (same at 1-s): the
# completed function built from the first N integers only, with zeta's reflection
# Lambda_N(1-s) = Lambda_N(s) exactly. For N = 1..12 count its zeros right of the
# line (Re s in (1/2, 3]) strip by strip in height, t in [1, 200], by the winding
# of Lambda_N around each strip, edges started at spacing 0.05 and subdivided until
# the change of argument per segment is below 0.3 (unit 0580's corrected count).
# Question: below what height is every zero on the line, and how does that height
# move as N grows?
import json, math
import mpmath as mp
mp.mp.dps = 20
def make(N):
    ns = [mp.mpf(n) for n in range(1, N + 1)]
    def half(s):
        return mp.pi ** (-s / 2) * mp.gamma(s / 2) * mp.fsum(n ** (-s) for n in ns)
    return lambda s: half(s) + half(1 - s)
def seg(F, a, b, Fa, Fb, depth=0):
    d = float(mp.arg(Fb / Fa))
    if abs(d) < 0.3 or depth > 18:
        return d
    m = (a + b) / 2; Fm = F(m)
    return seg(F, a, m, Fa, Fm, depth + 1) + seg(F, m, b, Fm, Fb, depth + 1)
def winding(F, x0, x1, y0, y1, h=0.05):
    c = [mp.mpc(x0, y0), mp.mpc(x1, y0), mp.mpc(x1, y1), mp.mpc(x0, y1), mp.mpc(x0, y0)]
    tot = 0.0
    for i in range(4):
        n = max(8, math.ceil(abs(complex(c[i + 1] - c[i])) / h))
        pts = [c[i] + (c[i + 1] - c[i]) * k / n for k in range(n + 1)]
        vals = [F(p) for p in pts]
        for k in range(n):
            tot += seg(F, pts[k], pts[k + 1], vals[k], vals[k + 1])
    return tot / (2 * math.pi)
res = {"x0": 0.5 + 1e-6, "x1": 3.0, "t0": 1.0, "t1": 200.0, "strip": 5.0}
for N in range(1, 13):
    F = make(N)
    right, strips, y = [], [], 1.0
    while y < 200:
        w = winding(F, 0.5 + 1e-6, 3.0, y, y + 5.0)
        right.append(round(w)); strips.append(w); y += 5.0
    first = next((1.0 + 5 * i for i, k in enumerate(right) if k > 0), None)
    res[f"N{N}_right_by_strip"] = right
    res[f"N{N}_right_total"] = sum(right)
    res[f"N{N}_first_offline_strip_start"] = first
    res[f"N{N}_max_dev_from_integer"] = max(abs(w - round(w)) for w in strips)
    print(N, "right zeros", sum(right), "first strip with one at t =", first, flush=True)
json.dump(res, open("results.json", "w"), indent=1)
