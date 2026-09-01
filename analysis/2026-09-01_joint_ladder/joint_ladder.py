#!/usr/bin/env python3
"""Joint 2-3 ladder: the incommensurate two-base difference instrument.

EXPLORATORY — no prereg. Everything printed here is exploration, and no
line of it is a verdict.

The single-base no-go (lean/Nyquist.lean): a b-adic ladder samples log x
on the lattice r·ln b, so frequencies gamma and gamma - 2*pi*k/ln b are
indistinguishable, and base 2's Nyquist pi/ln 2 = 4.53 sits a factor ~3
below gamma_1 = 14.13. The joint instrument samples log x on
{r·ln2 + m·ln3}, and since ln3/ln2 is irrational the two alias lattices
(2*pi/ln2)*Z and (2*pi/ln3)*Z meet only at 0 — the joint grid has NO
nonzero alias offset at all (lean/Chain.lean second_ladder_winds_densely
is the torus form of this). Two measurements:

  A. The 2D table N(r,m) = pi(2^r * 3^m) under the mixed operator
     Delta_2^a Delta_3^b (symbol (1-2^{-s})^a (1-3^{-s})^b, a product of
     two Euler factors): exact zeros of genuinely mixed cells (a,b >= 1),
     against the four single-ladder zeros.
  B. The alias test: nonuniform power spectrum of the RH-normalized
     residual (pi(x) - li(x)) * ln x / sqrt(x) on (i) the base-2 rungs
     alone and (ii) the joint grid. The single ladder must show a comb
     with period 2*pi/ln2 = 9.06 (the entry-16 signature: peaks of equal
     height, frequency unidentifiable). The joint grid, having no alias
     lattice, is where a peak near gamma_1 = 14.1347 could be unique.

Usage: python3 joint_ladder.py --xmax 10000000 --out results/joint_ladder.json
"""

import argparse
import json
import math
import os
import sys
from functools import lru_cache

GAMMA_1 = 14.134725141734693
EULER_GAMMA = 0.5772156649015329


def sieve_pi_at(targets, xmax):
    """pi(t) for each t in targets, one sieve pass."""
    sieve = bytearray([1]) * (xmax + 1)
    sieve[0:2] = b"\x00\x00"
    for p in range(2, int(xmax ** 0.5) + 1):
        if sieve[p]:
            sieve[p * p:: p] = bytearray(len(range(p * p, xmax + 1, p)))
    targets = sorted(set(targets))
    out = {}
    count = 0
    ti = 0
    for x in range(xmax + 1):
        count += sieve[x]
        while ti < len(targets) and targets[ti] == x:
            out[x] = count
            ti += 1
    return out


def li(x):
    """Logarithmic integral via the rapidly convergent series
    li(x) = gamma + ln ln x + sum_{k>=1} (ln x)^k / (k * k!)."""
    lx = math.log(x)
    s = EULER_GAMMA + math.log(lx)
    term = 1.0
    for k in range(1, 200):
        term *= lx / k
        s += term / k
        if term / k < 1e-16 * abs(s):
            break
    return s


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--xmax", type=int, required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--gmax", type=float, default=30.0)
    ap.add_argument("--gstep", type=float, default=0.005)
    args = ap.parse_args()

    X = args.xmax
    rmax = int(math.log2(X))
    mmax = int(math.log(X) / math.log(3))

    # the 3-smooth grid
    grid = [(r, m) for r in range(rmax + 1) for m in range(mmax + 1)
            if 2 ** r * 3 ** m <= X]
    values = {(r, m): 2 ** r * 3 ** m for r, m in grid}
    pi_at = sieve_pi_at(list(values.values()), X)
    N = {(r, m): pi_at[v] for (r, m), v in values.items()}

    # ---- A. mixed difference table -------------------------------------
    @lru_cache(maxsize=None)
    def cell(r, m, a, b):
        if a > 0:
            return cell(r, m, a - 1, b) - cell(r - 1, m, a - 1, b)
        if b > 0:
            return cell(r, m, a, b - 1) - cell(r, m - 1, a, b - 1)
        return N[(r, m)]

    mixed_zeros, mixed_cells = [], 0
    pure2_zeros, pure2_cells = [], 0
    for (r, m) in grid:
        for a in range(0, r + 1):
            for b in range(0, m + 1):
                if a + b == 0:
                    continue
                if (r - a, m - b) not in values:
                    continue
                v = cell(r, m, a, b)
                if a >= 1 and b >= 1:
                    mixed_cells += 1
                    if v == 0:
                        mixed_zeros.append((r, m, a, b))
                elif b == 0 and m == 0:
                    pure2_cells += 1
                    if v == 0:
                        pure2_zeros.append((r, a))

    # ---- B. alias test --------------------------------------------------
    def residual(x):
        return (pi_at[x] - li(x)) * math.log(x) / math.sqrt(x)

    def spectrum(points):
        ts = [math.log(v) for v in points]
        ws = [residual(v) for v in points]
        mean = sum(ws) / len(ws)
        ws = [w - mean for w in ws]
        gammas, powers = [], []
        g = 0.5
        while g <= args.gmax:
            re = sum(w * math.cos(g * t) for w, t in zip(ws, ts))
            im = sum(w * math.sin(g * t) for w, t in zip(ws, ts))
            gammas.append(g)
            powers.append(math.hypot(re, im) / len(ws))
            g += args.gstep
        return gammas, powers

    def top_peaks(gammas, powers, n=6):
        peaks = [(powers[i], gammas[i]) for i in range(1, len(powers) - 1)
                 if powers[i] > powers[i - 1] and powers[i] > powers[i + 1]]
        return [(round(g, 3), round(p, 5)) for p, g in
                sorted(peaks, reverse=True)[:n]]

    base2_points = [values[(r, 0)] for r in range(1, rmax + 1)]
    joint_points = sorted(v for v in values.values() if v >= 2)

    g2, p2 = spectrum(base2_points)
    gj, pj = spectrum(joint_points)
    peaks2 = top_peaks(g2, p2)
    peaksj = top_peaks(gj, pj)

    # distance of the joint grid's top peak from gamma_1
    top_gamma = peaksj[0][0] if peaksj else None

    out = {
        "label": "EXPLORATORY - no prereg, no verdict",
        "params": {"xmax": X, "gmax": args.gmax, "gstep": args.gstep,
                   "rmax": rmax, "mmax": mmax, "grid_points": len(grid)},
        "table": {
            "mixed_cells": mixed_cells,
            "mixed_zeros": mixed_zeros,
            "pure_base2_cells": pure2_cells,
            "pure_base2_zeros": pure2_zeros,
        },
        "spectrum": {
            "base2_top_peaks": peaks2,
            "joint_top_peaks": peaksj,
            "base2_alias_period": round(2 * math.pi / math.log(2), 4),
            "gamma_1": GAMMA_1,
            "joint_top_peak_minus_gamma1":
                (round(top_gamma - GAMMA_1, 3) if top_gamma else None),
        },
    }
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    with open(args.out, "w") as fh:
        json.dump(out, fh, indent=2)
    json.dump(out, sys.stdout, indent=2)
    print()


if __name__ == "__main__":
    main()
