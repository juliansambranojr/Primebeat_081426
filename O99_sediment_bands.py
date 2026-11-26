"""O99 — does the sediment settle in its own band out of sample?
Prereg: preregs/sediment_bands_v1_20261126.md.

Lambda_N(s) = pi^{-s/2} Gamma(s/2) sum_{n<=N} n^{-s} + (same at 1 - s), the completed
sum over the first N integers with zeta's reflection (unit 0583). For N = 6..12, count
its zeros with Re s in (1/2, 3] and t in its Riemann-Siegel band
[2 pi N^2, 2 pi (N+1)^2], by the winding around strips of height at most 5 tiling the
band, each edge started at spacing 0.05 and subdivided until the change of argument
per segment is below 0.3. Control: the same count on the 50 units of height just
below each band. No flags.
"""
import json, math, time
import mpmath as mp

mp.mp.dps = 20
NS = list(range(6, 13))
X0, X1 = 0.5 + 1e-6, 3.0
STRIP, CONTROL = 5.0, 50.0
TOL_INT = 1e-3

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

def winding(F, y0, y1, h=0.05):
    c = [mp.mpc(X0, y0), mp.mpc(X1, y0), mp.mpc(X1, y1), mp.mpc(X0, y1), mp.mpc(X0, y0)]
    tot = 0.0
    for i in range(4):
        n = max(8, math.ceil(abs(complex(c[i + 1] - c[i])) / h))
        pts = [c[i] + (c[i + 1] - c[i]) * k / n for k in range(n + 1)]
        vals = [F(p) for p in pts]
        for k in range(n):
            tot += seg(F, pts[k], pts[k + 1], vals[k], vals[k + 1])
    return tot / (2 * math.pi)

def count(F, lo, hi):
    ws, y = [], lo
    while y < hi - 1e-12:
        y2 = min(y + STRIP, hi)
        ws.append(winding(F, y, y2)); y = y2
    return ws

def main():
    t0 = time.time()
    res = {"Ns": NS, "x0": X0, "x1": X1, "strip": STRIP, "control": CONTROL}
    worst = 0.0
    for N in NS:
        F = make(N)
        lo, hi = 2 * math.pi * N * N, 2 * math.pi * (N + 1) ** 2
        wb = count(F, lo, hi)
        wc = count(F, lo - CONTROL, lo)
        worst = max([worst] + [abs(w - round(w)) for w in wb + wc])
        res[f"N{N}_band"] = [lo, hi]
        res[f"N{N}_in_band"] = sum(round(w) for w in wb)
        res[f"N{N}_control_below"] = sum(round(w) for w in wc)
        print(N, "in band", res[f"N{N}_in_band"], "control below", res[f"N{N}_control_below"], flush=True)
    res["max_dev_from_integer"] = worst
    if worst > TOL_INT or any(res[f"N{N}_in_band"] < 0 for N in NS):
        out = "compromised"
    elif any(res[f"N{N}_in_band"] > 0 for N in NS):
        out = "does_not_settle"
    else:
        out = "settles"
    res["mechanical_output"] = out
    res["wall_s"] = time.time() - t0
    json.dump(res, open("results/O99_sediment_bands.json", "w"), indent=1)
    print("mechanical output:", out)

if __name__ == "__main__":
    main()
