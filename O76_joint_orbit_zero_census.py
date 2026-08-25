#!/usr/bin/env python3
"""O76 — EXPLORATORY. No prereg, no verdict.

The joint cross-base test, run on the exact zeros' own object: a
backward-difference triangle built on the joint {2^m 3^n} orbit.

WHY THIS EXISTS. Entry 62 (Julian's scope observation): O18 coupled
incommensurate ladders and detection worked jointly where each base
alone was blind — but its object was the gammas. O44 scanned the
exact zeros across bases 2-9 — but one table at a time. "Blind singly"
and "blind jointly" are different questions, and for the exact zeros
only the first had been asked. Entry 62 closed: "no test proposed, no
prereg, nothing run." This is the run, combining the tree's two
existing designs exactly as the entry describes: O18's joint orbit as
the ladder, O16/O27's exact-integer backward-difference triangle as
the construction.

CONSTRUCTION. Rungs x_0 < x_1 < ... are the sorted joint orbit
{2^m 3^n <= xmax} (x_0 = 1, pi(1) = 0 — the first-block convention of
O27). Depth 0: N(i) = pi(x_i) - pi(x_{i-1}), exact via primecountpy.
Depth d: T(i,d) = T(i,d-1) - T(i-1,d-1). One number per cell, built
from both ladders at once — the construction entry 62 asked for.

THE COMMENSURABILITY CHECK FIRST (entries 54 and 56's trap: O45's
base set was commensurate with pi/(4 gamma_1) BY CONSTRUCTION, so
alignment was forced rather than found). Here the generator logs
against u = pi/(4 gamma_1): ln 2 / u and ln 3 / u are printed, and
neither is within --commens-tol of an integer, or the script exits 1
before measuring anything.

WHAT IS REPORTED. The census of exact-zero cells T(i,d) = 0, d >= 1,
each with its context: depth, rung index, x-window, the equal pair
that produces it (a zero at (i,d) is exactly T(i,d-1) = T(i-1,d-1),
the pair-identity framing of O44), and the row's depth-0 count as a
magnitude scale. Small-x cells produce zeros by chance (consecutive
smooth numbers trap 0 or 1 primes), so the census is split at
--x-floor; the deep census above the floor is the informative one.
Base-2's four exact zeros are the comparison object, stated for
orientation: (2,1), (4,1), (8,3), (20,6) in the base-2 table.

This script states numbers; interpretation is not its job.

Reads with: notes/lab_notebook_2.md entries 49, 52, 54, 56, 62;
O18_joint_multiplicative_ladder.py, O44_cross_base_zero_scan.py,
O16_centered_difference_table.py, O27_joint_dyadic_triadic_table.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O76_joint_orbit_zero_census.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

import primecountpy

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "joint_orbit_zero_census.json")
GAMMA1 = 14.134725141734693790


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def orbit(xmax):
    pts = []
    p2 = 1
    while p2 <= xmax:
        v = p2
        while v <= xmax:
            pts.append(v)
            v *= 3
        p2 *= 2
    return sorted(pts)


def main():
    ap = argparse.ArgumentParser(
        description=("O76 - exact-zero census of the backward-difference "
                     "triangle on the joint {2^m 3^n} orbit, "
                     "commensurability-gated. EXPLORATORY: no prereg, "
                     "no decision rule, no verdict."))
    ap.add_argument("--xmax", type=float, default=2.0 ** 41,
                    help="orbit ceiling (default 2^41 ~ 2.2e12)")
    ap.add_argument("--x-floor", type=float, default=100.0,
                    help="census split: zeros whose window top is above "
                         "this are the deep census (default 100)")
    ap.add_argument("--commens-tol", type=float, default=0.05,
                    help="gate: |ln g / (pi/(4 g1)) - nearest int| must "
                         "exceed this for both generators (default 0.05)")
    ap.add_argument("--max-print", type=int, default=40,
                    help="deep-census rows printed (default 40)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    print("O76 — joint-orbit exact-zero census.  EXPLORATORY.")
    u = math.pi / (4 * GAMMA1)
    print("\nCOMMENSURABILITY GATE (the entry 54/56 trap):")
    gate_ok = True
    commens = {}
    for name, g in (("ln 2", math.log(2)), ("ln 3", math.log(3))):
        q = g / u
        frac = abs(q - round(q))
        ok = frac > args.commens_tol
        gate_ok &= ok
        commens[name] = {"ratio_to_u": q, "dist_to_int": frac}
        print(f"   {name} / (pi/(4 g1)) = {q:.4f}   distance to nearest "
              f"integer {frac:.4f}   {'ok' if ok else 'COMMENSURATE'}")
    if not gate_ok:
        print("GATE FAILED — a generator is commensurate with pi/(4 g1); "
              "any alignment found would be forced by construction.")
        raise SystemExit(1)
    print("   gate PASSED — neither generator is commensurate; alignment "
          "cannot be forced by the base set.\n")

    xs = orbit(int(args.xmax))
    n = len(xs)
    print(f"  orbit: {n} rungs to {xs[-1]} (~{xs[-1]:.3e})")
    pi_at = [0] * n
    memo = {}
    for i, x in enumerate(xs):
        pi_at[i] = memo.setdefault(x, primecountpy.prime_pi(x))
    N = [None] * n
    for i in range(1, n):
        N[i] = pi_at[i] - pi_at[i - 1]

    # triangle: rows are rung indices i >= 1; depth d needs i-d >= 1
    T = {}
    for i in range(1, n):
        T[(i, 0)] = N[i]
        for d in range(1, i):
            T[(i, d)] = T[(i, d - 1)] - T[(i - 1, d - 1)]
    n_cells = sum(1 for _ in T)
    print(f"  triangle: {n_cells} cells "
          f"(rows 1..{n - 1}, depth d <= row-1)\n")

    zeros = []
    for (i, d), v in T.items():
        if d >= 1 and v == 0:
            zeros.append({"i": i, "d": d,
                          "x_lo": xs[i - 1], "x_hi": xs[i],
                          "pair_value": T[(i, d - 1)],
                          "depth0": N[i]})
    zeros.sort(key=lambda z: (-z["x_hi"], -z["d"]))
    deep = [z for z in zeros if z["x_hi"] > args.x_floor]
    shallow_count = len(zeros) - len(deep)

    print(f"CENSUS: {len(zeros)} exact-zero cells (d >= 1); "
          f"{shallow_count} at window top <= {args.x_floor:g} "
          f"(small-count region), {len(deep)} above.\n")
    print(f"DEEP CENSUS (x_hi > {args.x_floor:g}), by descending window "
          f"then depth — zero at (i,d) means T(i,d-1) = T(i-1,d-1) = "
          f"pair_value:")
    print(f"   {'i':>5} {'d':>3} {'x window':>28} {'pair_value':>12} "
          f"{'depth0':>8}")
    for z in deep[:args.max_print]:
        print(f"   {z['i']:>5} {z['d']:>3} "
              f"({z['x_lo']:>12}, {z['x_hi']:>12}] {z['pair_value']:>12} "
              f"{z['depth0']:>8}")
    if len(deep) > args.max_print:
        print(f"   ... and {len(deep) - args.max_print} more (all in the "
              f"JSON)")
    if deep:
        dmax = max(z["d"] for z in deep)
        xtop = max(z["x_hi"] for z in deep)
        print(f"\n   deepest zero above the floor: d = {dmax}; "
              f"highest window top: {xtop}")
    print("\n  orientation only: base 2's own table has exactly four "
          "exact zeros — (2,1), (4,1), (8,3), (20,6) — out to r = 92 "
          "(O43).")

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": "O76_joint_orbit_zero_census.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "xmax": args.xmax, "x_floor": args.x_floor,
                       "commens_tol": args.commens_tol,
                       "n_rungs": n, "n_cells": n_cells,
                       "construction": "sorted {2^m 3^n} orbit; N(i) = "
                                       "pi(x_i)-pi(x_{i-1}); backward-"
                                       "difference triangle on rung "
                                       "index"},
            "commensurability": commens,
            "n_zeros_total": len(zeros),
            "n_zeros_shallow": shallow_count,
            "deep_zeros": deep}
        try:
            with open(args.out, "w") as f:
                json.dump(payload, f, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
