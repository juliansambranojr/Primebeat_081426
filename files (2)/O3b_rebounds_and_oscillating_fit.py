#!/usr/bin/env python3
"""
O3b/O3c — two follow-ups to O3's negative result, and the controls that killed
          both of them.

Reads with: O3_collapse_radius_vs_rotation.py, DT-A6.

WHY THIS EXISTS
---------------
O3 returned a clean negative: the collapse residual does not track rotation
phase (amplitude 0.1017, null 95th pct 0.1689, p = 0.85).

Before accepting it I looked at the raw ratios and saw non-monotone behaviour —
depth 6 reads 1.000, 0.960, 0.670, 0.336, 0.101, 0.021, then REBOUNDS to 0.042,
0.066, before falling again.  Two follow-ups suggested themselves:

    TEST A — count rebounds.  I claimed at the time that "pure envelope decay
             predicts zero rebounds."
    TEST B — fit envelope * |cos(w*r + phi)| against a pure exponential and
             see whether the oscillating model wins.

Both looked positive.  Both die under control.  That is the point of the file.

TEST A — rebound count
    observed  : 38/120 steps, i.e. 3.8 per depth of 12
    my claim  : pure envelope decay predicts ZERO rebounds
    THE CLAIM IS WRONG.  It holds for NOISELESS decay only.  With lognormal
    noise at the observed scale the null gives 4.17 rebounds per 12 steps.
    Observed 3.8 is FEWER than noise.  p(null >= observed) = 0.733.
    No signal.  The claim was made before the control was run.

TEST B — oscillating model fit
    observed R^2 improvement : +0.1736
    null 95th percentile     : +0.1719      p = 0.050
    Marginal, sitting exactly on the line.  Worse: the frequencies fitted to
    PURE NOISE scatter with sd 0.9221, against sd 0.9724 for the real data.
    Statistically identical.  So the apparent clustering of fitted w near
    omega_1 = 2.7689 (depths 2, 6, 8, 9 giving 2.435, 2.450, 2.505, 2.595) is
    what a 4-parameter fit to 13 points produces out of nothing.

CONCLUSION
----------
Three tests, three controls, three negatives.  The collapse past each depth's
boundary is consistent with envelope decay plus noise.  DT-A5's radius/rotation
split is algebra and stands; this consequence of it does not.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy        # optional

USAGE
-----
    python3 O3b_rebounds_and_oscillating_fit.py
"""

import json
import math
import os

import numpy as np
from mpmath import mp, mpf, li

mp.dps = 60

BOUNDARY = {1: 4, 2: 6, 3: 8, 4: 11, 5: 16, 6: 20, 7: 23, 8: 24, 9: 29, 10: 33}
GAMMA_1 = 14.134725141734693
CACHE = "pi2n_cache_o3.json"


def prime_counts(rmax):
    P = {}
    if os.path.exists(CACHE):
        P = {int(k): v for k, v in json.load(open(CACHE)).items()}
    need = [n for n in range(rmax + 1) if n not in P]
    if need:
        try:
            import primecountpy as pc
            for n in need:
                P[n] = int(pc.prime_pi(2 ** n))
        except ImportError:
            from sympy import primepi
            for n in need:
                P[n] = int(primepi(2 ** n))
        json.dump({str(k): v for k, v in P.items()}, open(CACHE, "w"))
    return [P[n] - P[n - 1] for n in range(1, rmax + 1)]


def diff(seq, r, d):
    return sum((-1) ** (d - k) * math.comb(d, k) * seq[r - d + k - 1]
               for k in range(d + 1))


def fit_models(rs, v):
    """Return (R^2 of pure exponential, R^2 of envelope*|cos|, best w)."""
    y = np.log(v)
    A = np.vstack([np.ones_like(rs), rs]).T
    coef, _, _, _ = np.linalg.lstsq(A, y, rcond=None)
    r2_exp = 1 - np.sum((y - A @ coef) ** 2) / np.sum((y - y.mean()) ** 2)
    best = (-9.0, None)
    for w in np.arange(0.1, math.pi, 0.005):
        for phi in np.arange(0, 2 * math.pi, 0.1):
            m = np.maximum(np.abs(np.cos(w * rs + phi)), 1e-6)
            y2 = y - np.log(m)
            c2, _, _, _ = np.linalg.lstsq(A, y2, rcond=None)
            r2 = 1 - np.sum((y2 - A @ c2) ** 2) / np.sum((y - y.mean()) ** 2)
            if r2 > best[0]:
                best = (r2, w)
    return r2_exp, best[0], best[1]


def main():
    R = 45
    ci = prime_counts(R)
    c = [mpf(x) for x in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]

    w1 = GAMMA_1 * math.log(2) % (2 * math.pi)
    print(f"omega_1 = {w1:.6f} rad/regime  (> pi, aliases to "
          f"{2 * math.pi - w1:.4f})\n")

    data = {}
    for d, rb in BOUNDARY.items():
        rs, vals = [], []
        for r in range(rb, min(rb + 12, R) + 1):
            S = diff(s, r, d)
            F = diff(c, r, d) - S
            if S != 0:
                rs.append(r)
                vals.append(float(abs(F / S)))
        data[d] = (np.array(rs), np.array(vals))

    # ---------------- TEST A ------------------------------------------
    print("=" * 74)
    print("TEST A — rebound count")
    print("=" * 74)
    tot = reb = 0
    for d, (rs, v) in data.items():
        r_ = int(np.sum(v[1:] > v[:-1]))
        n_ = len(v) - 1
        tot += n_
        reb += r_
        print(f"  depth {d:>2}: {r_:>2}/{n_} steps rebound")
    obs_rate = reb / tot * 12
    print(f"\n  TOTAL {reb}/{tot} = {reb / tot:.3f}  ({obs_rate:.2f} per 12 steps)")

    print("\n  CONTROL: pure exponential decay + lognormal noise, 2000 trials")
    rng = np.random.default_rng(2026)
    rs_c = np.arange(20, 33)
    cnts = []
    for _ in range(2000):
        y = -0.42 * rs_c + rng.normal(0, 0.75, len(rs_c))
        vv = np.exp(y)
        cnts.append(int(np.sum(vv[1:] > vv[:-1])))
    cnts = np.array(cnts)
    print(f"    null mean rebounds: {cnts.mean():.2f}/12")
    print(f"    observed          : {obs_rate:.2f}/12")
    print(f"    p(null >= observed) = {(cnts >= obs_rate).mean():.4f}")
    print("\n  VERDICT: observed is FEWER than noise produces. No signal.")
    print("  The claim 'pure decay predicts zero rebounds' is true only for")
    print("  NOISELESS decay, and was made before this control was run.")

    # ---------------- TEST B ------------------------------------------
    print("\n" + "=" * 74)
    print("TEST B — envelope * |cos(w r + phi)| vs pure exponential")
    print("=" * 74)
    print(f"  {'d':>3} {'exp R^2':>10} {'osc R^2':>10} {'improve':>10} {'w':>9}")
    imps, ws = [], []
    for d, (rs, v) in data.items():
        e, o, w = fit_models(rs, v)
        imps.append(o - e)
        ws.append(w)
        print(f"  {d:>3} {e:>10.4f} {o:>10.4f} {o - e:>+10.4f} {w:>9.4f}")
    imps = np.array(imps)
    ws = np.array(ws)
    print(f"\n  mean improvement {imps.mean():+.4f}")
    print(f"  fitted frequencies: mean {ws.mean():.4f}, sd {ws.std():.4f}")
    print(f"  omega_1 aliased to [0,pi]: {min(w1, 2 * math.pi - w1):.4f}")

    print("\n  CONTROL: same fit on pure monotone decay + noise, 60 trials")
    nimp, nws = [], []
    for _ in range(60):
        y = -0.42 * rs_c + rng.normal(0, 0.75, len(rs_c))
        vv = np.exp(y - y.max())
        e, o, w = fit_models(rs_c, vv)
        nimp.append(o - e)
        nws.append(w)
    nimp = np.array(nimp)
    nws = np.array(nws)
    print(f"    null mean improvement {nimp.mean():+.4f}, "
          f"95th pct {np.percentile(nimp, 95):+.4f}")
    print(f"    observed              {imps.mean():+.4f}")
    print(f"    p(null >= observed) = {(nimp >= imps.mean()).mean():.4f}")
    print(f"    null fitted frequencies: mean {nws.mean():.4f}, sd {nws.std():.4f}")
    print(f"    real fitted frequencies: mean {ws.mean():.4f}, sd {ws.std():.4f}")
    print("\n  VERDICT: improvement sits on the null's 95th percentile, and the")
    print("  frequency scatter is indistinguishable from noise. Marginal at")
    print("  best, and the apparent clustering near omega_1 is a fitting")
    print("  artifact of 4 parameters against 13 points.")

    print("\n" + "=" * 74)
    print("OVERALL: three tests, three controls, three negatives.")
    print("The collapse is consistent with envelope decay plus noise.")
    print("=" * 74)


if __name__ == "__main__":
    main()
