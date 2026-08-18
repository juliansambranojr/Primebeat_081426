#!/usr/bin/env python3
"""
O4 — Local radius exponent, with no functional form assumed.

Reads with: dyadic-table-v2.md §7.3, DT-A6 §1.

WHY
---
v2.0 §7.3 obtains alpha by fitting |D^d e| ~ 2^(alpha*r + a*d + b) over r <= 60.
DT-A6 §1(b) reads that alpha as the table's estimate of Re(rho) = beta.  But
alpha came from ASSUMING that functional form.  If beta is real, it should be
visible without the assumption.

WHAT THIS DOES
--------------
Compute the local exponent directly:

    beta(r, d) = log2 |D^d e(r+1)|  -  log2 |D^d e(r)|

No fit, no assumed form, one subtraction per regime.

    If beta is a property of the object -> the sequence is noisy but has a
        stable centre, and that centre should sit near 0.43-0.5.
    If alpha is an artifact of the fit  -> no stable centre.

KNOWN WEAKNESS, STATED UP FRONT
-------------------------------
The fluctuation oscillates and passes near zero.  Consecutive log-ratios blow
up there — this is exactly what wrecked O3's decay statistic (a 43.19 appeared
from dividing 0.029 by 0.0007).  So the raw mean is useless.  This script
therefore reports MEDIAN and trimmed statistics, and windowed estimates, and
shows the raw sequence so the blow-ups are visible rather than hidden.

A median is robust to the blow-ups but is NOT unbiased for an oscillating
signal; treat the centre as indicative, not as a measurement.  Test O5 is the
sharper instrument.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy      # optional, much faster past r ~ 40

USAGE
-----
    python3 O4_local_exponent.py
    python3 O4_local_exponent.py --rmax 60 --depths 4,6,8,10
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
            print("    primecountpy not found; sympy fallback (slow past 40)",
                  flush=True)
            for n in need:
                P[n] = int(primepi(2 ** n))
                print(f"    pi(2^{n}) = {P[n]}", flush=True)
        json.dump({str(k): v for k, v in P.items()}, open(CACHE, "w"))
    return [P[n] - P[n - 1] for n in range(1, rmax + 1)]


def diff(seq, r, d):
    return sum((-1) ** (d - k) * math.comb(d, k) * seq[r - d + k - 1]
               for k in range(d + 1))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=60)
    ap.add_argument("--depths", type=str, default="2,4,6,8,10,12",
                    help="comma-separated depths to examine")
    ap.add_argument("--window", type=int, default=8,
                    help="window length for windowed slope estimates")
    args = ap.parse_args()

    R = args.rmax
    depths = [int(x) for x in args.depths.split(",")]

    print("=" * 78)
    print("O4 — local radius exponent, no functional form assumed")
    print("=" * 78)
    print("  computing exact prime counts...")
    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]

    # fluctuation e_n = c_n - smooth_n  (r = 1 excluded: li diverges at li(1))
    e = [c[i] - s[i] for i in range(R)]

    all_centres = []
    for d in depths:
        vals, rs = [], []
        for r in range(d + 2, R + 1):
            v = diff(e, r, d)
            if v != 0:
                rs.append(r)
                vals.append(float(abs(v)))
        rs = np.array(rs)
        vals = np.array(vals)
        lb = np.log2(vals)
        beta = np.diff(lb)              # local exponent, one per step
        rmid = rs[:-1]

        print(f"\n{'-' * 78}")
        print(f"depth {d}:  {len(beta)} local exponents, r = {rs[0]}..{rs[-1]}")
        print(f"{'-' * 78}")
        print(f"  {'r':>4} {'|D^d e|':>16} {'local beta':>12}")
        for i in range(len(beta)):
            flag = "  <-- blow-up" if abs(beta[i]) > 3 else ""
            print(f"  {rmid[i]:>4} {vals[i]:>16.4g} {beta[i]:>12.4f}{flag}")

        med = np.median(beta)
        trimmed = beta[(beta > np.percentile(beta, 10)) &
                       (beta < np.percentile(beta, 90))]
        print(f"\n  mean      {beta.mean():>8.4f}   (contaminated by blow-ups)")
        print(f"  median    {med:>8.4f}")
        print(f"  10-90 trimmed mean {trimmed.mean():>8.4f}  (n={len(trimmed)})")
        print(f"  sd        {beta.std():>8.4f}")

        # windowed least-squares slope of log2|D^d e| vs r
        print(f"\n  windowed slopes (length {args.window}, no assumed form "
              f"beyond local linearity):")
        slopes = []
        for i in range(len(lb) - args.window + 1):
            xs = rs[i:i + args.window].astype(float)
            ys = lb[i:i + args.window]
            A = np.vstack([np.ones_like(xs), xs]).T
            coef, *_ = np.linalg.lstsq(A, ys, rcond=None)
            slopes.append(coef[1])
            print(f"    r {int(xs[0]):>2}-{int(xs[-1]):>2}:  slope {coef[1]:+.4f}")
        slopes = np.array(slopes)
        print(f"    windowed slope: mean {slopes.mean():+.4f}, "
              f"sd {slopes.std():.4f}, last {slopes[-1]:+.4f}")
        all_centres.append((d, med, trimmed.mean(), slopes.mean(), slopes[-1]))

    print("\n" + "=" * 78)
    print("SUMMARY — is there a stable centre?")
    print("=" * 78)
    print(f"  {'depth':>6} {'median':>9} {'trimmed':>9} {'win mean':>10} {'win last':>10}")
    for d, med, tm, wm, wl in all_centres:
        print(f"  {d:>6} {med:>9.4f} {tm:>9.4f} {wm:>10.4f} {wl:>10.4f}")

    arr = np.array([[x[1], x[2], x[3], x[4]] for x in all_centres])
    print(f"\n  across depths, sd of median      : {arr[:,0].std():.4f}")
    print(f"  across depths, sd of trimmed     : {arr[:,1].std():.4f}")
    print(f"  across depths, sd of window mean : {arr[:,2].std():.4f}")
    print(f"\n  v2.0 §7.3 fitted alpha at r<=60 : 0.4334")
    print(f"  v2.0 §7.3 fitted alpha at r<=40 : 0.3500")
    print(f"  RH asymptotic value              : 0.5000")

    print("""
READ THE RESULT
---------------
  A stable centre near 0.43-0.50, consistent across depths, supports DT-A6
  §1(b): alpha is measuring beta = Re(rho) and not an artifact of the fit.

  Centres that scatter across depths, or drift with no centre, mean the
  envelope fit is supplying the number rather than reading it, and DT-A6
  §1(b) should be withdrawn.

  Read the windowed slopes for drift: if the LAST window sits above the mean
  at every depth, the estimate is still climbing with range, which is what a
  genuine convergence toward 1/2 would look like.

  Caveat repeated: medians of an oscillating signal are indicative, not
  unbiased.  O5 is the falsifiable version of this question.
""")


if __name__ == "__main__":
    main()
