#!/usr/bin/env python3
"""
O5 — Does alpha agree across depths?  The falsifiable version.

Reads with: dyadic-table-v2.md §7.3, DT-A6 §1(b).

THE ARGUMENT
------------
v2.0 §7.3 fits ONE envelope, |D^d e| ~ 2^(alpha*r + a*d + b), pooling every
depth.  Pooling can only produce one alpha, so the fit cannot tell you whether
alpha is a property of the object or of the pooling.

But beta = Re(rho) is a property of the ZEROS.  Depth changes the comb gain
(2 sin(omega/2))^d — v2.0 §7.1 — and nothing else.  The comb is a constant
multiplier at fixed depth; it does not touch the growth rate in r.

    => if alpha is measuring beta, fitting alpha SEPARATELY at each depth must
       give the same number every time, to within noise.

    => if the ten values scatter, alpha is a property of the pooled fit and
       DT-A6 §1(b) must be withdrawn.

This is the cleanest test of the three because it is a prediction the existing
fit never checked, and it can fail.

THE CONTROL
-----------
Scatter alone means nothing without knowing how much scatter a correct fit
produces on this much data.  So: generate synthetic rows with a KNOWN beta,
the same comb structure, the same number of regimes, and independent Gaussian
phases; fit alpha per depth exactly as above; and record the spread.

    observed spread <= synthetic spread  -> consistent with one beta
    observed spread >> synthetic spread  -> alpha is depth-dependent, so it is
                                            not beta

The synthetic uses independent phases, which DT-A §4 already notes is a WEAKER
null than the correlated zeta-zero sum the real fluctuation is.  Stated here
so it is not discovered later.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy      # optional

USAGE
-----
    python3 O5_cross_depth_alpha.py
    python3 O5_cross_depth_alpha.py --rmax 60 --rmin 20 --trials 200
"""

import argparse
import json
import math
import os

import numpy as np
from mpmath import mp, mpf, li

mp.dps = 80
CACHE = "pi2n_cache.json"


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
                print(f"    pi(2^{n}) = {P[n]}", flush=True)
        except ImportError:
            from sympy import primepi
            for n in need:
                P[n] = int(primepi(2 ** n))
                print(f"    pi(2^{n}) = {P[n]}", flush=True)
        json.dump({str(k): v for k, v in P.items()}, open(CACHE, "w"))
    return [P[n] - P[n - 1] for n in range(1, rmax + 1)]


def diff(seq, r, d):
    return sum((-1) ** (d - k) * math.comb(d, k) * seq[r - d + k - 1]
               for k in range(d + 1))


def fit_alpha(rs, vals):
    """Least-squares slope of log2|value| against r.  Returns (slope, R^2, n)."""
    ok = vals > 0
    xs = rs[ok].astype(float)
    ys = np.log2(vals[ok])
    if len(xs) < 4:
        return np.nan, np.nan, len(xs)
    A = np.vstack([np.ones_like(xs), xs]).T
    coef, *_ = np.linalg.lstsq(A, ys, rcond=None)
    pred = A @ coef
    r2 = 1 - np.sum((ys - pred) ** 2) / np.sum((ys - ys.mean()) ** 2)
    return coef[1], r2, len(xs)


def synthetic_rows(beta, depths, rmin, rmax, rng):
    """
    Synthetic fluctuation with a KNOWN beta and the real comb structure.
    A base signal at each regime is 2^(beta*r) times a sum of oscillating
    modes with independent phases; depth-d rows are true finite differences
    of that base signal, so the comb gain arises the same way it does in the
    real table rather than being imposed.
    """
    n = rmax + 1
    r = np.arange(1, n)
    # a handful of modes at the first few zeta heights, weighted 1/|rho|
    gammas = np.array([14.134725, 21.022040, 25.010858, 30.424876, 32.935062,
                       37.586178, 40.918719, 43.327073, 48.005151, 49.773832])
    phases = rng.uniform(0, 2 * np.pi, len(gammas))
    base = np.zeros(len(r))
    for g, ph in zip(gammas, phases):
        base += np.cos(g * r * np.log(2) + ph) / abs(0.5 + 1j * g)
    base = base * 2.0 ** (beta * r)

    out = {}
    for d in depths:
        rs, vals = [], []
        for rr in range(max(d + 2, rmin), rmax + 1):
            v = sum((-1) ** (d - k) * math.comb(d, k) * base[rr - d + k - 1]
                    for k in range(d + 1))
            if v != 0:
                rs.append(rr)
                vals.append(abs(v))
        out[d] = (np.array(rs), np.array(vals))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=60)
    ap.add_argument("--rmin", type=int, default=20,
                    help="lowest regime included in each per-depth fit")
    ap.add_argument("--depths", type=str, default="2,3,4,5,6,7,8,9,10,11,12")
    ap.add_argument("--trials", type=int, default=200)
    ap.add_argument("--beta", type=float, default=0.4334,
                    help="known beta used to build the synthetic control")
    args = ap.parse_args()

    R = args.rmax
    depths = [int(x) for x in args.depths.split(",")]

    print("=" * 78)
    print("O5 — does alpha agree across depths?")
    print("=" * 78)
    print(f"  fitting log2|D^d e| ~ alpha*r separately at each depth")
    print(f"  regimes {args.rmin}..{R}, depths {depths}")
    print("\n  computing exact prime counts...")

    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]
    e = [c[i] - s[i] for i in range(R)]

    print("\n" + "-" * 78)
    print("PER-DEPTH FITS ON THE REAL TABLE")
    print("-" * 78)
    print(f"  {'depth':>6} {'alpha':>9} {'R^2':>8} {'n pts':>7}")
    obs = []
    for d in depths:
        rs, vals = [], []
        for r in range(max(d + 2, args.rmin), R + 1):
            v = diff(e, r, d)
            if v != 0:
                rs.append(r)
                vals.append(float(abs(v)))
        a, r2, n = fit_alpha(np.array(rs), np.array(vals))
        obs.append(a)
        print(f"  {d:>6} {a:>9.4f} {r2:>8.4f} {n:>7}")

    obs = np.array([x for x in obs if not np.isnan(x)])
    print(f"\n  mean alpha  {obs.mean():.4f}")
    print(f"  sd          {obs.std():.4f}     <-- THE OBSERVED SPREAD")
    print(f"  min..max    {obs.min():.4f} .. {obs.max():.4f}")
    print(f"  pooled alpha from v2.0 §7.3 (r<=60): 0.4334")

    print("\n" + "-" * 78)
    print(f"CONTROL — {args.trials} synthetic tables with KNOWN beta = {args.beta}")
    print("-" * 78)
    print("  same depths, same regimes, real comb structure, independent phases")

    rng = np.random.default_rng(2026)
    spreads, means = [], []
    for t in range(args.trials):
        rows = synthetic_rows(args.beta, depths, args.rmin, R, rng)
        vals = []
        for d in depths:
            rs_, vv = rows[d]
            a, _, _ = fit_alpha(rs_, vv)
            if not np.isnan(a):
                vals.append(a)
        if len(vals) >= 3:
            spreads.append(np.std(vals))
            means.append(np.mean(vals))
        if (t + 1) % 50 == 0:
            print(f"    {t + 1}/{args.trials} trials...", flush=True)

    spreads = np.array(spreads)
    means = np.array(means)
    print(f"\n  synthetic spread (sd of per-depth alpha):")
    print(f"    mean {spreads.mean():.4f}, 5th pct {np.percentile(spreads,5):.4f}, "
          f"95th pct {np.percentile(spreads,95):.4f}")
    print(f"  synthetic recovered mean alpha: {means.mean():.4f} "
          f"(true beta was {args.beta})")
    bias = means.mean() - args.beta
    print(f"    -> fitting bias on a known answer: {bias:+.4f}")

    p_hi = (spreads >= obs.std()).mean()
    print(f"\n  OBSERVED spread {obs.std():.4f}")
    print(f"  p(synthetic spread >= observed) = {p_hi:.4f}")

    print("\n" + "=" * 78)
    print("READ THE RESULT")
    print("=" * 78)
    print(f"""
  observed per-depth spread : {obs.std():.4f}
  synthetic spread, 5-95%   : {np.percentile(spreads,5):.4f} .. {np.percentile(spreads,95):.4f}
  p(synthetic >= observed)  : {p_hi:.4f}

  p large (observed spread INSIDE the synthetic range)
      -> the ten alphas are consistent with a single underlying beta.
         DT-A6 §1(b) is supported: alpha is reading Re(rho), not the fit.
         Note also the recovered mean {means.mean():.4f} against true
         {args.beta}: the fit's own bias is {bias:+.4f}, which is how much of
         the gap to 1/2 is method rather than range.

  p small (observed spread EXCEEDS the synthetic range)
      -> alpha is depth-dependent.  A property of the zeros cannot be, so
         alpha is not beta, and DT-A6 §1(b) should be withdrawn.

  Limits: the control uses independent Gaussian phases while the real
  fluctuation is a correlated sum over zeta zeros (DT-A §4's limit, restated).
  Adjacent depths share cells, so the per-depth fits are not independent.
  The synthetic uses ten modes; the real signal has infinitely many.
""")


if __name__ == "__main__":
    main()
