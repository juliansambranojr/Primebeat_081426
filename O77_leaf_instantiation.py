#!/usr/bin/env python3
"""O77 — EXPLORATORY. No prereg, no verdict.

Numerical instantiation of a Lean leaf PAIR, before the formalization
is built on it.

WHY THIS EXISTS. Entry 132 checked that a named leaf can be true;
entry 133 checked that a hypothesis pair is not jointly unsatisfiable.
Entry 157's Jensen count passed both and still fed an unsatisfiable
consumer: the count is over the disk ‖rho - (2+iT)‖ <= 3/2, which
meets the critical line only at the single point gamma = T, so under
RH it is 0 for almost every T — while StmtSFromLocal, its consumer,
asserts |S(T)| <= a*cnt(T) + b, i.e. S bounded, which is false.
The defect lived in the INTERFACE between two individually-fine
statements, which no check in this bench was pointed at.

O71 did exactly this instantiation for an upstream statement and
found it undischargeable. This script turns the same instrument on
our own tree.

WHAT IS MEASURED, from zeros600.json (600 zeros, dps-25):
  N(T)      the zero count, exact from the list for T <= gamma_600
  theta(T)  Riemann-Siegel theta (mpmath.siegeltheta)
  S(T)      = N(T) - (theta(T)/pi + 1) — the quantity StmtArgIdentity
            names and StmtSFromLocal must bound
  cnt_r(T)  zero orders in the disk ‖rho - (2+iT)‖ <= r, counted on
            the critical line: |gamma - T| <= sqrt(r^2 - 9/4)

For each candidate radius the script reports the reachable half-width
sqrt(r^2 - 9/4), the count's range over a T grid, and the smallest
(a, b) making |S(T)| <= a*cnt(T) + b hold on the grid — with b forced
to absorb every T where cnt = 0. A radius whose count vanishes while
|S| does not is a radius that cannot feed the consumer, and the
script says so in that language.

Reads with: lean_stage3/Stage3/ArgCrude.lean (StmtLocalCount,
StmtSFromLocal), lean_stage3/Stage3/JensenCount.lean (zetaWindow at
radius 3/2), notes/lab_notebook_2.md entries 132, 133, 141, 157;
O71_horizontal_defect.py (the same instrument, aimed upstream).

HOW IT WAS RUN
--------------
    .venv/bin/python O77_leaf_instantiation.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "leaf_instantiation.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")
SIGMA_GAP = 1.5          # centre 2 + iT, critical line at Re = 1/2


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def half_width(r):
    """Reachable |gamma - T| at Re = 1/2 for disk radius r."""
    v = r * r - SIGMA_GAP * SIGMA_GAP
    return math.sqrt(v) if v > 0 else 0.0


def main():
    ap = argparse.ArgumentParser(
        description=("O77 - numerical instantiation of the "
                     "StmtLocalCount / StmtSFromLocal leaf pair. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--radii", type=str, default="1.5,1.75,1.875",
                    help="disk radii in s-space to instantiate "
                         "(default 1.5 = entry 157's, 1.75 and 1.875 "
                         "= the proposed repair)")
    ap.add_argument("--tmin", type=float, default=20.0,
                    help="grid floor (default 20)")
    ap.add_argument("--tmax", type=float, default=900.0,
                    help="grid ceiling; must stay under gamma_600 so "
                         "N(T) is exact (default 900)")
    ap.add_argument("--tstep", type=float, default=0.5,
                    help="grid step (default 0.5)")
    ap.add_argument("--dps", type=int, default=25,
                    help="mpmath precision (default 25)")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="zero-heights JSON (default _HERE/zeros600.json)")
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

    mp.mp.dps = args.dps
    gam = [float(g) for g in json.load(open(args.zeros))]
    gam.sort()
    radii = [float(s) for s in args.radii.split(",")]

    print("O77 — instantiating the leaf pair before building on it.  "
          "EXPLORATORY.")
    print(f"  zeros: {len(gam)} heights to {gam[-1]:.4f}   grid "
          f"T = {args.tmin}..{args.tmax} step {args.tstep}\n")

    ts, S = [], []
    t = args.tmin
    while t <= args.tmax:
        N = sum(1 for g in gam if g <= t)
        s = N - (float(mp.siegeltheta(t)) / math.pi + 1)
        ts.append(t)
        S.append(s)
        t += args.tstep
    absS = [abs(v) for v in S]
    print(f"  |S(T)| over the grid: max {max(absS):.4f} at "
          f"T = {ts[absS.index(max(absS))]:.1f}, mean {sum(absS)/len(absS):.4f}")
    print(f"  (S(T) is unbounded in T — Selberg — so any consumer that "
          f"forces S bounded is unsatisfiable.)\n")

    rows = {}
    print(f"   {'radius':>7} {'half-width':>11} {'cnt=0 frac':>11} "
          f"{'max cnt':>8} {'max|S| where cnt=0':>19} {'verdict':>14}")
    for r in radii:
        hw = half_width(r)
        cnt = [sum(1 for g in gam if abs(g - T) <= hw) for T in ts]
        zero_frac = sum(1 for c in cnt if c == 0) / len(cnt)
        maxS_at_zero = max([abs(s) for c, s in zip(cnt, S) if c == 0],
                           default=0.0)
        # smallest b that works when cnt = 0; then smallest a for the rest
        b = maxS_at_zero
        a_needed = max([(abs(s) - b) / c for c, s in zip(cnt, S) if c > 0],
                       default=0.0)
        usable = zero_frac < 0.999 and maxS_at_zero < 1e9
        # a radius is unusable when cnt vanishes on essentially the whole
        # grid while |S| does not
        verdict = "FEEDS CONSUMER" if (zero_frac < 0.9) else "CANNOT FEED"
        print(f"   {r:>7.3f} {hw:>11.4f} {zero_frac:>11.3f} "
              f"{max(cnt):>8} {maxS_at_zero:>19.4f} {verdict:>14}")
        rows[f"{r}"] = {"radius": r, "half_width": hw,
                        "frac_grid_with_zero_count": zero_frac,
                        "max_count": max(cnt),
                        "max_absS_where_count_zero": maxS_at_zero,
                        "implied_b": b, "implied_a": a_needed,
                        "feeds_consumer": zero_frac < 0.9}

    print("\n  READ. A radius whose count vanishes on essentially the "
          "whole grid\n  forces |S(T)| <= b, a bounded-S claim, which is "
          "false. The count is\n  true at every radius; only the ones "
          "reaching past the critical line\n  can satisfy "
          "StmtSFromLocal.")
    for r in radii:
        d = rows[f"{r}"]
        if d["feeds_consumer"]:
            print(f"  radius {r}: |S(T)| <= {d['implied_a']:.3f}*cnt(T) + "
                  f"{d['implied_b']:.3f} holds on this grid.")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O77_leaf_instantiation.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "radii": radii, "tmin": args.tmin,
                       "tmax": args.tmax, "tstep": args.tstep,
                       "dps": args.dps, "n_zeros": len(gam),
                       "sigma_gap": SIGMA_GAP,
                       "definitions": "S(T) = N(T) - (theta(T)/pi + 1); "
                                      "cnt_r(T) = #{gamma : |gamma - T| "
                                      "<= sqrt(r^2 - 9/4)}"},
            "S_stats": {"max_abs": max(absS),
                        "argmax_T": ts[absS.index(max(absS))],
                        "mean_abs": sum(absS) / len(absS)},
            "rows": rows}
        try:
            with open(args.out, "w") as f:
                json.dump(payload, f, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
