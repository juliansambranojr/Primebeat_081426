#!/usr/bin/env python3
"""O63 — EXPLORATORY. No prereg, no verdict.

Where does a given density value appear, at what difference order, across bases?

WHY. O44 scanned the eight b-adic tables for exact ZEROS. Nothing has tracked a
non-zero VALUE across bases and orders. The question arrived from an independent
analysis of the same tables (notes entry 102) which claimed a "refraction": a
density of 5 appearing as an acceleration (Delta_2) in a silenced triadic system
and as a velocity (Delta_1) in a silenced pentadic one. That specific instance
did not reproduce -- silenced base 5 has no cell equal to 5 at Delta_0, 1 or 2 --
but the question is well posed and unasked, so this asks it properly.

WHAT IS MEASURED. For each base b in 2..9, both unsilenced and with 2 and 3
removed as lattice, the full backward-difference table to a common value ceiling.
For each small value v, every (depth, regime) where a cell equals v, and the
minimum depth at which v occurs.

THE CONTROL IS THE POINT. A small value is not rare at large depth: differencing
drives cells toward zero and then oscillates, so "5 appears at depth 2" means
nothing without knowing how many cells are small at depth 2. This reports, per
base and depth, the count of cells with |value| <= 20 alongside the total, so any
claimed hit can be read against its own background.

A SECOND CONTROL. The same statistic on a row of the same length drawn from a
Poisson with the base's own per-rung mean -- what a structureless count of the
same magnitude would give.

Reads with: O44_cross_base_zero_scan.py, lean/SeedPerturbation.lean,
lean/Isogeny.lean, notes/lab_notebook_2.md entry 102
"""
import json, math, pathlib
import numpy as np
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
CEIL = 10 ** 12
BASES = [2, 3, 4, 5, 6, 7, 8, 9]
VALUES = [1, 2, 3, 5, 7, 11, 13]
SMALL = 20
RNG = np.random.default_rng(2026)


def row_for(b, silence, rmax):
    out = {}
    for r in range(1, rmax + 1):
        lo, hi = b ** (r - 1), b ** r
        c = prime_pi(hi) - prime_pi(lo)
        c -= sum(1 for p in silence if lo < p <= hi)
        out[r] = c
    return out


def table(row, rmax):
    T = {(r, 0): row[r] for r in row}
    for d in range(1, rmax):
        for r in range(d + 1, rmax + 1):
            if (r, d - 1) in T and (r - 1, d - 1) in T:
                T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def profile(T):
    """per depth: cells, and how many are small."""
    by = {}
    for (r, d), v in T.items():
        c, s = by.get(d, (0, 0))
        by[d] = (c + 1, s + (1 if abs(v) <= SMALL else 0))
    return by


def main():
    print("O63 — value refraction across bases.  EXPLORATORY, no prereg, no verdict.")
    print(f"ceiling {CEIL:.0e}, values {VALUES}, small = |v| <= {SMALL}\n")

    out = {}
    for silence, lbl in (([], "unsilenced"), ([2, 3], "silenced 2,3")):
        print(f"=== {lbl}")
        print(f"   {'b':>2} {'rungs':>6} {'cells':>7} " +
              " ".join(f"{'v='+str(v):>7}" for v in VALUES))
        rows = []
        for b in BASES:
            rmax = int(math.log(CEIL) / math.log(b))
            T = table(row_for(b, silence, rmax), rmax)
            mind = {}
            for v in VALUES:
                hits = sorted((d, r) for (r, d), x in T.items() if x == v)
                mind[v] = hits[0][0] if hits else None
            rows.append({"base": b, "rungs": rmax, "cells": len(T),
                         "min_depth": {str(v): mind[v] for v in VALUES},
                         "profile": {str(d): p for d, p in profile(T).items()}})
            print(f"   {b:>2} {rmax:>6} {len(T):>7} " +
                  " ".join(f"{(str(mind[v]) if mind[v] is not None else '-'):>7}"
                           for v in VALUES))
        out[lbl] = rows
        print()

    # background: how small-valued is each depth, before reading anything into a hit
    print("=== BACKGROUND, base 2 unsilenced: cells with |v| <= 20, per depth")
    rmax = int(math.log(CEIL) / math.log(2))
    T2 = table(row_for(2, [], rmax), rmax)
    p2 = profile(T2)
    print(f"   {'d':>3} {'cells':>6} {'small':>6} {'frac':>7}")
    for d in sorted(p2)[:16]:
        c, s = p2[d]
        print(f"   {d:>3} {c:>6} {s:>6} {s/c:>7.3f}")

    # Poisson control at base 2's own per-rung mean, N draws
    N_DRAWS = 400
    print(f"\n=== POISSON CONTROL, {N_DRAWS} draws, base 2's per-rung means")
    base_row = row_for(2, [], rmax)
    acc = {}
    for _ in range(N_DRAWS):
        ctrl = {r: int(RNG.poisson(base_row[r])) for r in base_row}
        pcd = profile(table(ctrl, rmax))
        for d, (c, s) in pcd.items():
            acc.setdefault(d, []).append(s / c)
    pc = {d: (float(np.mean(v)), float(np.std(v, ddof=1)),
              float(np.max(v))) for d, v in acc.items()}
    print(f"   {'d':>3} {'real':>8} {'poisson mean':>13} {'sd':>8} {'max of 400':>11}"
          f" {'z':>8} {'draws >= real':>14}")
    zrows = {}
    for d in sorted(p2)[:16]:
        c, s = p2[d]
        real = s / c
        if d not in pc:
            continue
        mu, sd, mx = pc[d]
        z = (real - mu) / sd if sd > 0 else float('inf')
        ge = sum(1 for v in acc[d] if v >= real)
        zrows[str(d)] = {"real": real, "poisson_mean": mu, "poisson_sd": sd,
                         "poisson_max": mx, "z": z, "draws_ge_real": ge,
                         "n_draws": N_DRAWS}
        print(f"   {d:>3} {real:>8.3f} {mu:>13.3f} {sd:>8.3f} {mx:>11.3f}"
              f" {z:>8.1f} {ge:>8}/{N_DRAWS}")

    (_HERE / "results" / "value_refraction.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O63_value_refraction.py",
         "exploratory": True, "prereg": None,
         "params": {"ceiling": CEIL, "bases": BASES, "values": VALUES,
                    "small_threshold": SMALL, "seed": 2026},
         "rows": out,
         "background_base2": {str(d): {"cells": c, "small": s}
                              for d, (c, s) in p2.items()},
         "poisson_control_base2": zrows}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'value_refraction.json'}")


if __name__ == "__main__":
    main()
