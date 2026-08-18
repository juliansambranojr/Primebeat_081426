#!/usr/bin/env python3
"""
O3 — Is the ratio collapse past each depth's boundary the RADIUS or the ROTATION?

Reads with: dyadic-table-v2.md (§7.2, §7.3), DT-A §5.3, DT-A4 §4.3, DT-A5, DT-A6.
Run by the author on an M-series Mac, 2026-08-14.  RESULT: NEGATIVE.
See O3b/O3c for the two follow-ups, both also negative under control.

BACKGROUND
----------
At x = 2^r a zeta zero rho = beta + i*gamma contributes

    x^rho = 2^(beta*r) * exp(i * gamma * r * ln2)
            \_________/   \___________________/
              RADIUS            ROTATION

DT-A5 records that split.  Everything the table measures is one or the other:
v2.0 §7.3's alpha is the radius exponent (0.350 at r<=40, 0.4334 at r<=60);
§7.1's comb filter is a rotation-rate calculation (omega = gamma*ln2 mod 2pi).

THE CLAIM TESTED
----------------
The ratio  |D^d e| / D^d s  collapses past each depth's boundary.  DT-A §5.3
observed this at depth 10 (0.976, 0.453, 0.085, 0.029, 0.0007) and used it to
close off the "displaced zero" reading.  The collapse itself was never
explained.

Radius-only prediction, no free parameter:

    |D^d e| ~ 2^(alpha*r),   D^d s ~ 2^r / r
    => ratio(r+1)/ratio(r) = 2^-(1-alpha) * r/(r+1)  ~= 0.675 per regime

  matches, geometric and steady  -> pure envelope decay, instrument
  faster and erratic             -> something else acting, candidate: rotation

Discriminator: does the residual (observed decay - predicted) track the
rotation phase omega_1 * r mod 2pi?  With a phase-scrambled control.

RESULT AS RUN
-------------
    n = 120 regime-steps, depths 1-10
    corr(residual, cos) = +0.0239
    corr(residual, sin) = -0.0988
    amplitude           =  0.1017
    null 95th pct       =  0.1689     p = 0.8525

NEGATIVE.  The residual does not track rotation phase.  The collapse is
consistent with envelope decay.  DT-A5's split is algebra and is unaffected;
this particular consequence of it does not hold.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy        # optional, much faster

r <= 45 is ample: the deepest boundary used is d=10 at r=33 and the collapse
is fully visible within 12 regimes.  Do NOT go past 50.
"""

import argparse
import json
import math
import os

import numpy as np
from mpmath import mp, mpf, li

mp.dps = 80

# v2.0 §7.2, empirical: last regime at which ratio >= 1, per depth.
BOUNDARY = {
    1: 4, 2: 6, 3: 8, 4: 11, 5: 16, 6: 20, 7: 23, 8: 24, 9: 29,
    10: 33, 11: 35, 12: 36, 13: 37, 14: 48, 15: 51, 16: 53, 17: 54,
}

GAMMA_1 = 14.134725141734693
CACHE = "pi2n_cache_o3.json"


def prime_counts(rmax):
    """c_r = pi(2^r) - pi(2^(r-1)), exact integers, cached to disk."""
    P = {}
    if os.path.exists(CACHE):
        P = {int(k): v for k, v in json.load(open(CACHE)).items()}
    need = [n for n in range(rmax + 1) if n not in P]
    if need:
        try:
            import primecountpy as pc
            for n in need:
                P[n] = int(pc.prime_pi(2 ** n))
                print(f"  pi(2^{n})={P[n]}", flush=True)
        except ImportError:
            from sympy import primepi
            print("  primecountpy not found; using sympy (slower)", flush=True)
            for n in need:
                P[n] = int(primepi(2 ** n))
                print(f"  pi(2^{n})={P[n]}", flush=True)
        json.dump({str(k): v for k, v in P.items()}, open(CACHE, "w"))
    return [P[n] - P[n - 1] for n in range(1, rmax + 1)]


def diff(seq, r, d):
    """d-th finite difference at regime r. seq is 1-indexed by regime."""
    return sum((-1) ** (d - k) * math.comb(d, k) * seq[r - d + k - 1]
               for k in range(d + 1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=45)
    ap.add_argument("--alpha", type=float, default=0.4334,
                    help="fluctuation growth exponent from v2.0 §7.3")
    ap.add_argument("--span", type=int, default=12)
    a = ap.parse_args()
    R, alpha = min(a.rmax, 50), a.alpha

    print("=" * 78)
    print("O3 — collapse past the boundary: radius or rotation?")
    print("=" * 78)
    print(f"  alpha={alpha}; radius-only decay = {2 ** -(1 - alpha):.4f} * r/(r+1) per regime")

    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]

    w1 = GAMMA_1 * math.log(2) % (2 * math.pi)
    print(f"  omega_1 = {w1:.6f} rad/regime; period {2 * math.pi / w1:.4f} regimes")

    rows = []
    for d in sorted(BOUNDARY):
        rb = BOUNDARY[d]
        if rb + a.span > R:
            continue
        print(f"\n  depth {d}, r_b={rb}")
        print(f"    {'r':>4} {'ratio':>12} {'decay':>9} {'pred':>9} "
              f"{'resid':>10} {'phase':>8}")
        prev = None
        for r in range(rb, min(rb + a.span, R) + 1):
            S = diff(s, r, d)
            F = diff(c, r, d) - S
            if S == 0:
                continue
            ratio = float(abs(F / S))
            ph = (w1 * r) % (2 * math.pi)
            if prev and prev > 0:
                dec = ratio / prev
                pr = 2 ** -(1 - alpha) * (r - 1) / r
                res = dec - pr
                rows.append((d, r, ratio, dec, pr, res, ph))
                print(f"    {r:>4} {ratio:>12.6f} {dec:>9.4f} {pr:>9.4f} "
                      f"{res:>+10.4f} {ph:>8.4f}")
            else:
                print(f"    {r:>4} {ratio:>12.6f} {'—':>9} {'—':>9} "
                      f"{'—':>10} {ph:>8.4f}")
            prev = ratio

    arr = np.array(rows)
    dec, pr, res, ph = arr[:, 3], arr[:, 4], arr[:, 5], arr[:, 6]

    print("\n" + "=" * 78)
    print("SUMMARY")
    print("=" * 78)
    print(f"  n={len(rows)} steps; mean decay {dec.mean():.4f} (sd {dec.std():.4f}) "
          f"vs predicted {pr.mean():.4f}")
    print(f"  mean residual {res.mean():+.4f}; steeper than predicted in "
          f"{(dec < pr).mean():.3f} of steps")

    print("\n" + "=" * 78)
    print("DISCRIMINATING TEST: residual vs rotation phase")
    print("=" * 78)
    rc = np.corrcoef(res, np.cos(ph))[0, 1]
    rs = np.corrcoef(res, np.sin(ph))[0, 1]
    amp = math.hypot(rc, rs)
    print(f"  corr(resid, cos) = {rc:+.4f}")
    print(f"  corr(resid, sin) = {rs:+.4f}")
    print(f"  amplitude = {amp:.4f}")

    rng = np.random.default_rng(2026)
    null = []
    for _ in range(2000):
        p = rng.uniform(0, 2 * math.pi, len(res))
        null.append(math.hypot(np.corrcoef(res, np.cos(p))[0, 1],
                               np.corrcoef(res, np.sin(p))[0, 1]))
    null = np.array(null)
    pval = (null >= amp).mean()
    print(f"\n  CONTROL (2000 random-phase trials): mean {null.mean():.4f}, "
          f"95th pct {np.percentile(null, 95):.4f}, p = {pval:.4f}")

    print(f"""
  amplitude {amp:.4f} vs null 95th pct {np.percentile(null, 95):.4f}, p={pval:.4f}

  above null  -> excess collapse tracks rotation: the zeros' oscillation
                 passing through zero. Object, not instrument.
  inside null -> collapse is envelope decay. The radius/rotation split still
                 stands (DT-A5) but this consequence of it does not.

  Limits: alpha is fitted and range-dependent; adjacent regimes share cells so
  steps aren't independent; only gamma_1's phase is tested.""")


if __name__ == "__main__":
    main()
