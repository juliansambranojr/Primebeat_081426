#!/usr/bin/env python3
"""O83 — EXPLORATORY. No prereg, no verdict.

Can a pooled incommensurate orbit detect the modes O81's single ladder
could not? The power measurement, run BEFORE any prereg is written.

WHY THIS EXISTS, and why in this order. O81 was preregistered, gated,
and returned `null` — 0 hits of 15 on list A, 0 of 8 on list B, with
the surrogate maximum already at 4.352 against a threshold of 5.
Entry 171 records the format defect it exposed: the prereg's
vacuousness check asks whether a criterion can fire in BOTH
directions and never asks whether the instrument has the POWER to make
it fire. This script asks the second question first, so that any
successor prereg can quote a measured number instead of promising one.

WHY POOLING, and why now. lean/Nyquist.lean (entry 172) proves what
entry 26 recorded as theorem-shaped: on a b-adic ladder any frequency
past pi/log b has a strictly-smaller-modulus alias, so it is not
identifiable — not noisy, UNIDENTIFIABLE. O81 sampled 2^(j/4), whose
Nyquist frequency is pi/(log 2 / 4) = 18.1, and asked about targets up
to 40. Half the grid was past the wall. Pooling incommensurate ladders
is the standard escape and is exactly O18's design: base 2 alone NULL,
base 3 alone NULL, the joint orbit {2^m 3^n} detecting gamma_2 at
P/median 6.95. This script builds that orbit and measures what it can
see.

THE OBJECT, unchanged from O81 and entry 163: psi_DH(x) = sum over
prime powers p^k <= x of log p * a(p^k mod 5), with a the DH sequence
(1, tau, -tau, -1, 0). Entry 163's factoring says its residual should
carry the zeros of L(s,chi) and not DH's own.

WHAT IS MEASURED. Three things, in order.
  1. ALIASING, made concrete. The Nyquist frequency of each single
     ladder against the orbit's own rung spacing, so the wall O81 hit
     is a number rather than an argument.
  2. POWER, by injection. Take the real residual, permute it to
     destroy its structure, add a synthetic mode A*cos(gamma_0 log x)
     at a target frequency, and find the smallest A that clears
     P/median > 5 in at least 90% of draws. Report that A against the
     amplitude the explicit formula predicts for a zero at that
     height, which is of order 1/|rho|.
  3. The unblinded spectrum is NOT computed here. This script may not
     be used to look at the answer; it exists to size the instrument.

Reads with: notes/lab_notebook_2.md entries 163, 164, 171, 172;
lean/Nyquist.lean; O18_joint_multiplicative_ladder.py;
O81_dh_coalition_spectrum.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O83_pooled_power.py
"""
import argparse
import hashlib
import json
import math
import os
import sys
from datetime import datetime, timezone

import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "pooled_power.json")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def orbit(gens, xmax):
    """The joint multiplicative orbit {prod g^e <= xmax}, sorted. O18's
    ladder. Exact integers."""
    pts = [1]
    for g in gens:
        new = []
        for v in pts:
            w = v
            while w <= xmax:
                new.append(w)
                w *= g
        pts = new
    return sorted(set(p for p in pts if 2 <= p <= xmax))


def psi_dh(xs, tau):
    """psi_DH at each rung, exact over a segmented sieve."""
    a = {0: 0.0, 1: 1.0, 2: float(tau), 3: -float(tau), 4: -1.0}
    top = int(xs[-1])
    lim = int(top ** 0.5) + 1
    s = np.ones(lim + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(lim ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)
    extra = []
    for p in base:
        v = int(p) * int(p)
        while v <= top:
            extra.append((v, math.log(int(p))))
            v *= int(p)
    extra.sort()

    vals = np.zeros(len(xs))
    cum, lo, ci, ex = 0.0, 2, 0, 0
    cps = [int(x) for x in xs]
    seg = 1 << 24
    while lo <= top:
        hi = min(lo + seg, top + 1)
        blk = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi:
                break
            st = max(p * p, ((lo + p - 1) // p) * p)
            blk[st - lo::p] = False
        idx = (np.flatnonzero(blk) + lo).astype(np.int64)
        w = np.array([a[int(v) % 5] for v in idx]) * np.log(idx)
        cs = np.cumsum(w)
        while ci < len(cps) and cps[ci] < hi:
            k = int(np.searchsorted(idx, cps[ci], side="right"))
            part = cum + (cs[k - 1] if k > 0 else 0.0)
            while ex < len(extra) and extra[ex][0] <= cps[ci]:
                part += a[extra[ex][0] % 5] * extra[ex][1]
                ex += 1
            vals[ci] = part
            ci += 1
        cum += float(cs[-1]) if len(cs) else 0.0
        lo = hi
    while ci < len(cps):
        vals[ci] = cum
        ci += 1
    return vals


def main():
    ap = argparse.ArgumentParser(
        description=("O83 - power measurement for a pooled incommensurate "
                     "orbit, run before any successor prereg is written. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--generators", type=str, default="2,3",
                    help="orbit generators (default 2,3 — O18's pair)")
    ap.add_argument("--rmax", type=int, default=30,
                    help="ceiling 2^RMAX (default 30, O81's)")
    ap.add_argument("--gammas", type=str, default="6.183578,14.825026,24.365280",
                    help="injection frequencies; default three of "
                         "L(s,chi)'s zeros spanning the grid")
    ap.add_argument("--draws", type=int, default=200,
                    help="permutation draws per amplitude (default 200)")
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    rng = np.random.default_rng(args.seed)
    mp.mp.dps = 20
    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    gens = [int(g) for g in args.generators.split(",")]
    xmax = 1 << args.rmax
    targets = [float(s) for s in args.gammas.split(",")]

    print("O83 — sizing the pooled instrument.  EXPLORATORY.")
    print(f"  generators {gens}   ceiling 2^{args.rmax}   seed {args.seed}\n")

    print("1. ALIASING — the wall O81 hit, as numbers:")
    for b, lab in ((2 ** 0.25, "O81's 2^(j/4)"), (2.0, "base 2"),
                   (3.0, "base 3")):
        print(f"   {lab:>16}: Nyquist = pi/log b = "
              f"{math.pi / math.log(b):8.3f}")
    xs = np.array(orbit(gens, xmax), dtype=float)
    logx = np.log(xs)
    gaps = np.diff(logx)
    print(f"   pooled orbit    : {len(xs)} rungs, median log-gap "
          f"{np.median(gaps):.5f}, min {gaps.min():.5f}")
    print(f"                     pi/median_gap = "
          f"{math.pi / np.median(gaps):8.3f}  (not a true Nyquist —")
    print(f"                     the orbit is NOT evenly spaced, which is "
          f"the point)\n")

    print("2. POWER BY INJECTION — smallest amplitude clearing "
          "P/median > 5 in >= 90% of draws:")
    psi = psi_dh(xs, tau)
    e = np.diff(psi)
    xj = xs[:-1]
    ehat = e / np.sqrt(xj)
    lx = np.log(xj)
    n = len(ehat)
    w = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(n) / (n - 1))
    print(f"   {n} blocks; residual rms {np.sqrt((ehat**2).mean()):.4f}")

    def pmax_ratio(v, g0):
        gam = np.linspace(max(0.5, g0 - 3), g0 + 3, 601)
        P = np.abs(np.exp(-1j * np.outer(gam, lx)) @ (w * v))
        gg = np.linspace(0.5, 40.0, 1200)
        Pall = np.abs(np.exp(-1j * np.outer(gg, lx)) @ (w * v))
        med = np.median(Pall)
        return (P.max() / med) if med > 0 else 0.0

    rows = {}
    print(f"   {'gamma':>10} {'A*':>10} {'1/|rho|':>10} {'A*/(1/|rho|)':>14}")
    for g0 in targets:
        lo_a, hi_a = 1e-4, 10.0
        for _ in range(14):
            mid = math.sqrt(lo_a * hi_a)
            hits = 0
            for _d in range(args.draws // 4):
                surr = rng.permutation(ehat)
                inj = surr + mid * np.cos(g0 * lx)
                if pmax_ratio(inj, g0) > 5:
                    hits += 1
            if hits >= 0.9 * (args.draws // 4):
                hi_a = mid
            else:
                lo_a = mid
        astar = hi_a
        expected = 1.0 / abs(g0)
        rows[str(g0)] = {"gamma": g0, "A_star": astar,
                         "expected_amplitude": expected,
                         "ratio": astar / expected}
        print(f"   {g0:>10.4f} {astar:>10.4f} {expected:>10.4f} "
              f"{astar / expected:>14.2f}")

    print("\n  READ. A* is the amplitude the pooled instrument needs to see")
    print("  a mode. The explicit formula puts a single zero's normalised")
    print("  amplitude near 1/|rho|. A ratio far above 1 means the design")
    print("  cannot detect a single zero and a successor prereg would be")
    print("  underpowered by construction; near or below 1 means it can.")
    print("  The unblinded spectrum is deliberately NOT computed here.")

    if not args.no_json:
        guarded_write({
            "schema_version": "1", "script": "O83_pooled_power.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "generators": gens,
                       "rmax": args.rmax, "targets": targets,
                       "draws": args.draws, "seed": args.seed,
                       "n_rungs": int(len(xs)), "n_blocks": int(n),
                       "note": "power sizing only; the unblinded spectrum "
                               "is not computed by this script"},
            "median_log_gap": float(np.median(gaps)),
            "min_log_gap": float(gaps.min()),
            "residual_rms": float(np.sqrt((ehat ** 2).mean())),
            "rows": rows}, args.out)


if __name__ == "__main__":
    main()
