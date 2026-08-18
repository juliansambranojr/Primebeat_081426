#!/usr/bin/env python3
"""
O6 — Isolate the radius by dividing the comb out, with no envelope fit at all.

Reads with: dyadic-table-v2.md §7.1, §7.3, DT-A5, DT-A6 §1.

THE IDEA
--------
v2.0 §7.1 derives, from the operator and with nothing fitted, that differencing
multiplies a zero of height gamma by

    G(gamma, d) = (2 sin(omega/2))^d,     omega = gamma * ln2 mod 2pi

DT-A5 confirmed this is the spectrum of Delta*Delta.  So the comb factor is
KNOWN, not fitted.

At a FIXED regime r, the only thing that changes with depth is the comb.  So
ratios ACROSS DEPTHS at fixed r isolate the comb and say nothing about growth:

    |D^(d+1) e(r)| / |D^d e(r)|  ~=  G(gamma_eff, d+1) / G(gamma_eff, d)

Divide the comb out and what remains grows purely as 2^(beta*r) — the radius,
with no envelope fit anywhere in the procedure.

    beta_hat(r) = log2 [ Dtilde(r+1) ] - log2 [ Dtilde(r) ]

where Dtilde(r) = |D^d e(r)| / G(gamma_1, d), the comb-corrected magnitude.

WHAT MAKES THIS DIFFERENT FROM O4
---------------------------------
O4 takes local log-differences of the raw fluctuation, which mixes radius and
comb together and is destroyed by sign changes.  O6 removes the known comb
first, using a factor derived from the operator rather than fitted from the
data, and averages over depths at each r before differencing — which suppresses
the near-zero blow-ups because the depths do not cross zero at the same r.

TWO CHECKS BUILT IN
-------------------
  (1) Does the measured cross-depth ratio actually match the predicted comb
      ratio?  If not, gamma_1 is not the dominant mode at that depth and the
      correction is wrong there.  Reported per depth so it can be inspected.

  (2) A control on synthetic data with a KNOWN beta, run through the identical
      pipeline, to measure the procedure's own bias.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy      # optional

USAGE
-----
    python3 O6_comb_corrected_radius.py
    python3 O6_comb_corrected_radius.py --rmax 60 --depths 4,5,6,7,8
"""

import argparse
import json
import math
import os

import numpy as np
from mpmath import mp, mpf, li

mp.dps = 80
CACHE = "pi2n_cache.json"
GAMMA_1 = 14.134725141734693


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


def comb_gain(gamma, d):
    """v2.0 §7.1, derived not fitted: (2 sin(omega/2))^d, omega = gamma*ln2."""
    omega = (gamma * math.log(2)) % (2 * math.pi)
    return (2 * math.sin(omega / 2)) ** d


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=60)
    ap.add_argument("--rmin", type=int, default=20)
    ap.add_argument("--depths", type=str, default="4,5,6,7,8,9,10")
    ap.add_argument("--trials", type=int, default=100)
    ap.add_argument("--beta", type=float, default=0.4334)
    args = ap.parse_args()

    R = args.rmax
    depths = [int(x) for x in args.depths.split(",")]

    print("=" * 78)
    print("O6 — comb-corrected radius, no envelope fit")
    print("=" * 78)
    omega = (GAMMA_1 * math.log(2)) % (2 * math.pi)
    print(f"  gamma_1 = {GAMMA_1:.6f},  omega = {omega:.6f} rad/regime")
    print(f"  single-step comb gain 2 sin(omega/2) = {2*math.sin(omega/2):.6f}")
    print("  (derived in v2.0 §7.1; confirmed as the spectrum of D*D in DT-A5)")

    print("\n  computing exact prime counts...")
    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]
    e = [c[i] - s[i] for i in range(R)]

    # ---- CHECK 1: does the observed cross-depth ratio match the comb? -----
    print("\n" + "-" * 78)
    print("CHECK 1 — observed cross-depth ratio vs predicted comb ratio")
    print("-" * 78)
    g = 2 * math.sin(omega / 2)
    print(f"  predicted |D^(d+1)e| / |D^d e| at fixed r = {g:.4f} "
          f"(if gamma_1 dominates)")
    print(f"  {'depth':>6} {'median observed':>17} {'ratio to predicted':>20}")
    for d in depths[:-1]:
        rats = []
        for r in range(max(d + 3, args.rmin), R + 1):
            a = diff(e, r, d)
            b = diff(e, r, d + 1)
            if a != 0:
                rats.append(float(abs(b / a)))
        if rats:
            m = float(np.median(rats))
            print(f"  {d:>6} {m:>17.4f} {m / g:>20.4f}")
    print("\n  values near 1.00 in the last column mean gamma_1 dominates and")
    print("  the correction below is valid at that depth.  Values far from 1")
    print("  mean another mode dominates there and that depth should be")
    print("  discounted when reading the result.")

    # ---- comb-corrected radius estimate -----------------------------------
    print("\n" + "-" * 78)
    print("COMB-CORRECTED RADIUS")
    print("-" * 78)
    print(f"  Dtilde(r,d) = |D^d e(r)| / (2 sin(omega/2))^d")
    print(f"  averaged over depths at each r, then log-differenced\n")

    rs, tilde = [], []
    for r in range(args.rmin, R + 1):
        vals = []
        for d in depths:
            if r >= d + 2:
                v = diff(e, r, d)
                if v != 0:
                    vals.append(float(abs(v)) / comb_gain(GAMMA_1, d))
        if len(vals) >= 3:
            rs.append(r)
            tilde.append(float(np.median(vals)))   # median across depths
    rs = np.array(rs)
    tilde = np.array(tilde)

    print(f"  {'r':>4} {'Dtilde (median over depths)':>30} {'local beta':>12}")
    lb = np.log2(tilde)
    beta_loc = np.diff(lb)
    for i in range(len(rs)):
        bl = f"{beta_loc[i]:>12.4f}" if i < len(beta_loc) else f"{'—':>12}"
        print(f"  {rs[i]:>4} {tilde[i]:>30.6g} {bl}")

    A = np.vstack([np.ones_like(rs, dtype=float), rs.astype(float)]).T
    coef, *_ = np.linalg.lstsq(A, lb, rcond=None)
    pred = A @ coef
    r2 = 1 - np.sum((lb - pred) ** 2) / np.sum((lb - lb.mean()) ** 2)
    print(f"\n  overall slope (comb-corrected)  : {coef[1]:.4f}   R^2 {r2:.4f}")
    print(f"  median local beta               : {np.median(beta_loc):.4f}")
    print(f"  mean local beta                 : {beta_loc.mean():.4f}")

    # last-half slope, to see drift with range
    half = len(rs) // 2
    A2 = np.vstack([np.ones(len(rs) - half), rs[half:].astype(float)]).T
    coef2, *_ = np.linalg.lstsq(A2, lb[half:], rcond=None)
    print(f"  slope on the upper half (r>={int(rs[half])})    : {coef2[1]:.4f}")

    # ---- CHECK 2: pipeline bias on a known beta ---------------------------
    print("\n" + "-" * 78)
    print(f"CHECK 2 — same pipeline on synthetic data with KNOWN beta = {args.beta}")
    print("-" * 78)
    rng = np.random.default_rng(2026)
    gammas = np.array([14.134725, 21.022040, 25.010858, 30.424876, 32.935062,
                       37.586178, 40.918719, 43.327073, 48.005151, 49.773832])
    recov = []
    for t in range(args.trials):
        rr = np.arange(1, R + 1)
        ph = rng.uniform(0, 2 * np.pi, len(gammas))
        base = np.zeros(len(rr))
        for gm, p in zip(gammas, ph):
            base += np.cos(gm * rr * np.log(2) + p) / abs(0.5 + 1j * gm)
        base = base * 2.0 ** (args.beta * rr)

        rs2, td2 = [], []
        for r in range(args.rmin, R + 1):
            vals = []
            for d in depths:
                if r >= d + 2:
                    v = sum((-1) ** (d - k) * math.comb(d, k) * base[r - d + k - 1]
                            for k in range(d + 1))
                    if v != 0:
                        vals.append(abs(v) / comb_gain(GAMMA_1, d))
            if len(vals) >= 3:
                rs2.append(r)
                td2.append(float(np.median(vals)))
        if len(rs2) > 5:
            rs2 = np.array(rs2, dtype=float)
            y2 = np.log2(np.array(td2))
            A3 = np.vstack([np.ones_like(rs2), rs2]).T
            c3, *_ = np.linalg.lstsq(A3, y2, rcond=None)
            recov.append(c3[1])
        if (t + 1) % 25 == 0:
            print(f"    {t + 1}/{args.trials} trials...", flush=True)

    recov = np.array(recov)
    bias = recov.mean() - args.beta
    print(f"\n  recovered slope on synthetic: mean {recov.mean():.4f}, "
          f"sd {recov.std():.4f}")
    print(f"  true beta                   : {args.beta:.4f}")
    print(f"  PIPELINE BIAS               : {bias:+.4f}")
    print(f"  5-95 percentile of recovery : {np.percentile(recov,5):.4f} .. "
          f"{np.percentile(recov,95):.4f}")

    corrected = coef[1] - bias
    print("\n" + "=" * 78)
    print("READ THE RESULT")
    print("=" * 78)
    print(f"""
  raw comb-corrected slope on the real table : {coef[1]:.4f}
  pipeline bias measured on a known answer   : {bias:+.4f}
  bias-corrected estimate of beta = Re(rho)  : {corrected:.4f}

  upper-half slope (drift check)             : {coef2[1]:.4f}
  v2.0 §7.3 pooled alpha, r<=60              : 0.4334
  RH asymptotic value                        : 0.5000

  If the bias-corrected estimate lands near 0.43-0.50 with the upper half
  above the lower, this is the radius measured WITHOUT an envelope fit — the
  comb divided out came from the operator (v2.0 §7.1 / DT-A5), not from the
  data.  That would make DT-A6 §1(b) a measurement rather than a relabeling.

  If the estimate is far from the pooled alpha, or if CHECK 1 showed gamma_1
  does not dominate at these depths, the correction is not valid and the
  number should not be read as beta.

  Limits: only gamma_1's comb is divided out, though other modes contribute;
  the median across depths is robust but not unbiased; adjacent depths share
  cells; and the synthetic control uses independent phases, which DT-A §4
  already flags as weaker than the correlated zeta-zero sum.
""")


if __name__ == "__main__":
    main()
