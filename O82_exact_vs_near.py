#!/usr/bin/env python3
"""O82 — EXPLORATORY. No prereg, no verdict.

Does exact vanishing do any work that near-vanishing does not?

WHY THIS EXISTS. Entry 160's FATAL 2 is the finding that most
constrains any design built on the exact-zero set: run the same
pipeline with the selection criterion changed, and a pure geometric
cut that never reads a cell's value compresses harder than the zeros
do. An audit of the tree (2026-08-25) found those numbers exist ONLY
inside that notebook entry — no script, no artifact, nothing to
re-run. This script is that instrument.

IT ALSO CORRECTS THE COMPARISON. Entry 160's FATAL 4, in the same
entry, established that permutation z scales as sqrt(n). FATAL 2's
table compares selections whose sizes run from 54 to 1659, so its
z-values are not comparable to each other on their face — the very
error FATAL 4 names. O82 therefore reports two panels:

  FULL-n     every cell meeting the criterion; reproduces entry 160
  MATCHED-n  every selection subsampled to the size of the exact-zero
             set, repeated, so the z-values ARE comparable

WHAT IS NOT ASKED. No expected number of exact zeros under any
magnitude null is computed here, and none should be. Entry 17 records
Julian's correction, and it stands: "The cells are not independent
draws; cell(r,d) = sum (-1)^k C(d,k) N(r-k) is a determined binomial
combination, and (20,6) is an exact identity across seven consecutive
counts, not a hit in a lottery. Asking 'how probable is that' imports
a null model the object does not have." The question here is a
comparison between selections on one object, which imports no such
model: does the exact-zero set behave differently from the
nearly-zero set and from a geometric cut, at equal size?

THE OBJECT. O78's base set — log2 b = alpha*sqrt(p) over distinct
primes, pairwise incommensurate by construction — and O45's
resolved stratum (d >= 1, r - d >= r_thick). The coordinate is
The-Zero-Surface.md B3's: lo = (r-d-1) log2 b, hi = r log2 b.
Stencil mass S is the Pascal recurrence S(r,0) = N(r),
S(r,d) = S(r,d-1) + S(r-1,d-1), as in O46 and t14.

THE STATISTIC, both directions, because entry 160's FATAL 1 was the
within-base control being dropped:
  cross-base NN   mean distance to the nearest neighbour at ANOTHER base
  within-base NN  the same, restricted to the SAME base

Reads with: notes/lab_notebook_2.md entries 17, 160; O78_incommensurate
_zero_surface.py; O46_mass_density_check.py;
analysis/2026-08-19_table_structure/scripts/t14_s_matched_control.py.

HOW IT WAS RUN
--------------
    .venv/bin/python O82_exact_vs_near.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

import numpy as np
import primecountpy

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "exact_vs_near.json")


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def scan_base(b, xmax):
    """O78/O45 construction, returning every resolved cell with its
    value, stencil mass and window."""
    lg, lnb = math.log2(b), math.log(b)
    r_max = int(math.floor(math.log(xmax) / lnb))
    F = [1] + [int(math.floor(b ** r)) for r in range(1, r_max + 1)]
    W = [0] + [F[r] - F[r - 1] for r in range(1, r_max + 1)]
    rt = r_max + 1
    for r in range(r_max, 0, -1):
        if W[r] / (lnb * r) >= 1.0:
            rt = r
        else:
            break
    memo = {}

    def PI(x):
        if x < 2:
            return 0
        if x not in memo:
            memo[x] = int(primecountpy.prime_pi(x))
        return memo[x]

    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    P, S = {}, {}
    for r in range(1, r_max + 1):
        P[(r, 0)] = N[r]
        S[(r, 0)] = N[r]
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            P[(r, d)] = P[(r, d - 1)] - P[(r - 1, d - 1)]
            S[(r, d)] = S[(r, d - 1)] + S[(r - 1, d - 1)]
    cells = []
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            if r - d < rt:
                continue
            cells.append((r, d, P[(r, d)], S[(r, d)],
                          (r - d - 1) * lg, r * lg))
    return cells


def nn(pts, ids, cross):
    D = np.sqrt(((pts[:, None, :] - pts[None, :, :]) ** 2).sum(-1))
    same = ids[:, None] == ids[None, :]
    if cross:
        D = np.where(same, np.inf, D)
    else:
        D = np.where(same, D, np.inf)
        np.fill_diagonal(D, np.inf)
    m = D.min(1)
    m = m[np.isfinite(m)]
    return float(m.mean()) if len(m) else float("nan")


def z_of(sel_pts, sel_ids, support, counts, rng, nperm, cross,
         matched_pools=None):
    obs = nn(sel_pts, sel_ids, cross)
    if not np.isfinite(obs):
        return obs, float("nan"), float("nan")
    null = np.empty(nperm)
    for t in range(nperm):
        if matched_pools is None:
            draw = np.vstack([sp[rng.choice(len(sp), size=n,
                                            replace=False)]
                              for sp, n in zip(support, counts) if n > 0])
        else:
            draw = np.vstack([sp[[int(rng.choice(ix)) for ix in pz]]
                              for sp, pz in matched_pools if len(pz)])
        null[t] = nn(draw, sel_ids, cross)
    sd = null.std()
    return obs, float(null.mean()), (float((obs - null.mean()) / sd)
                                     if sd > 0 else float("nan"))


def main():
    ap = argparse.ArgumentParser(
        description=("O82 - does exact vanishing do work that near-"
                     "vanishing does not? Reproduces entry 160's FATAL 2 "
                     "and corrects it to matched sample size. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--primes", type=str,
                    default="2,3,5,7,11,13,17,19,23,29")
    ap.add_argument("--alpha", type=float, default=0.18)
    ap.add_argument("--xmax", type=float, default=2.0 ** 32)
    ap.add_argument("--nperm", type=int, default=500)
    ap.add_argument("--tol", type=float, default=0.25,
                    help="width-matching tolerance in log2 (t22's 0.25)")
    ap.add_argument("--subsamples", type=int, default=60,
                    help="matched-n repeats (default 60)")
    ap.add_argument("--sub-nperm", type=int, default=200,
                    help="null draws inside each matched-n repeat")
    ap.add_argument("--seed", type=int, default=2026)
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    rng = np.random.default_rng(args.seed)
    primes = [int(s) for s in args.primes.split(",")]
    print("O82 — exact vanishing against near vanishing.  EXPLORATORY.")
    print(f"  bases log2 b = {args.alpha}*sqrt(p), p in {primes}")
    print(f"  ceiling 2^{math.log2(args.xmax):.0f}, nperm {args.nperm}, "
          f"subsamples {args.subsamples}, seed {args.seed}\n")

    per_base = []
    for p in primes:
        b = 2.0 ** (args.alpha * math.sqrt(p))
        per_base.append(scan_base(b, args.xmax))
    tot = sum(len(c) for c in per_base)
    print(f"  resolved support: {tot} cells across {len(primes)} bases")

    SELECTIONS = [
        ("P == 0  (the zeros)", lambda c: c[2] == 0),
        ("|P| == 1", lambda c: abs(c[2]) == 1),
        ("|P| == 2", lambda c: abs(c[2]) == 2),
        ("1 <= |P| <= 3", lambda c: 1 <= abs(c[2]) <= 3),
        ("S <= 200  (mass cut)", lambda c: c[3] <= 200),
        ("d <= 3  (never reads P)", lambda c: c[1] <= 3),
    ]

    support = [np.array([[c[4], c[5]] for c in cb], dtype=float)
               for cb in per_base]
    support_w = [s[:, 1] - s[:, 0] for s in support]

    rows = {}
    n_zero = sum(1 for cb in per_base for c in cb if c[2] == 0)
    print(f"  exact-zero set size (the matched-n target): {n_zero}\n")

    print("PANEL 1 — FULL n (reproduces entry 160's FATAL 2, and is "
          "NOT comparable across rows because z scales as sqrt(n)):")
    print(f"   {'selection':>26} {'n':>6} {'z_cross':>9} "
          f"{'z_cross_wm':>11} {'z_within':>9} {'z_within_wm':>12}")
    for name, pred in SELECTIONS:
        sel = [[c for c in cb if pred(c)] for cb in per_base]
        counts = [len(s) for s in sel]
        n = sum(counts)
        if n < 2:
            continue
        pts = np.array([[c[4], c[5]] for cb in sel for c in cb],
                       dtype=float)
        ids = np.concatenate([np.full(k, i) for i, k in
                              enumerate(counts)]).astype(float)
        pools = []
        for sb, sp, ws in zip(sel, support, support_w):
            pz = []
            for c in sb:
                w = c[5] - c[4]
                ix = np.flatnonzero(np.abs(ws - w) <= args.tol)
                if len(ix) == 0:
                    ix = np.array([int(np.argmin(np.abs(ws - w)))])
                pz.append(ix)
            pools.append((sp, pz))
        _o, _m, zc = z_of(pts, ids, support, counts, rng, args.nperm, True)
        _o, _m, zcw = z_of(pts, ids, support, counts, rng, args.nperm,
                           True, pools)
        _o, _m, zw = z_of(pts, ids, support, counts, rng, args.nperm, False)
        _o, _m, zww = z_of(pts, ids, support, counts, rng, args.nperm,
                           False, pools)
        rows[name] = {"n_full": n, "z_cross": zc, "z_cross_wm": zcw,
                      "z_within": zw, "z_within_wm": zww}
        print(f"   {name:>26} {n:>6} {zc:>9.2f} {zcw:>11.2f} "
              f"{zw:>9.2f} {zww:>12.2f}")

    print(f"\nPANEL 2 — MATCHED n = {n_zero}, {args.subsamples} "
          f"subsamples each; these ARE comparable:")
    print(f"   {'selection':>26} {'z_cross':>16} {'z_cross_wm':>16}")
    for name, pred in SELECTIONS:
        sel = [[c for c in cb if pred(c)] for cb in per_base]
        n = sum(len(s) for s in sel)
        if n < n_zero:
            print(f"   {name:>26} {'(n < target)':>16}")
            continue
        zc_s, zcw_s = [], []
        reps = 1 if n == n_zero else args.subsamples
        for _ in range(reps):
            sub = []
            for sb in sel:
                if not sb:
                    sub.append([])
                    continue
                k = max(1, int(round(len(sb) * n_zero / n)))
                k = min(k, len(sb))
                idx = rng.choice(len(sb), size=k, replace=False)
                sub.append([sb[i] for i in idx])
            counts = [len(s) for s in sub]
            if sum(counts) < 2:
                continue
            pts = np.array([[c[4], c[5]] for cb in sub for c in cb],
                           dtype=float)
            ids = np.concatenate([np.full(k, i) for i, k in
                                  enumerate(counts)]).astype(float)
            pools = []
            for sb, sp, ws in zip(sub, support, support_w):
                pz = []
                for c in sb:
                    w = c[5] - c[4]
                    ix = np.flatnonzero(np.abs(ws - w) <= args.tol)
                    if len(ix) == 0:
                        ix = np.array([int(np.argmin(np.abs(ws - w)))])
                    pz.append(ix)
                pools.append((sp, pz))
            _o, _m, a = z_of(pts, ids, support, counts, rng,
                             args.sub_nperm, True)
            _o, _m, c2 = z_of(pts, ids, support, counts, rng,
                              args.sub_nperm, True, pools)
            if np.isfinite(a):
                zc_s.append(a)
            if np.isfinite(c2):
                zcw_s.append(c2)
        if zc_s:
            rows.setdefault(name, {})
            rows[name]["z_cross_matched_mean"] = float(np.mean(zc_s))
            rows[name]["z_cross_matched_sd"] = float(np.std(zc_s))
            rows[name]["z_cross_wm_matched_mean"] = float(np.mean(zcw_s))
            rows[name]["z_cross_wm_matched_sd"] = float(np.std(zcw_s))
            print(f"   {name:>26} {np.mean(zc_s):>9.2f} ± "
                  f"{np.std(zc_s):<4.2f} {np.mean(zcw_s):>9.2f} ± "
                  f"{np.std(zcw_s):<4.2f}")

    print("\n  READ. Panel 1 is entry 160's comparison, reproduced and "
          "kept because\n  it is what that entry recorded. Panel 2 is "
          "the same comparison with\n  the sqrt(n) confound removed, "
          "which entry 160's own FATAL 4 requires.\n  Interpretation is "
          "not this script's job.")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O82_exact_vs_near.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "primes": primes,
                       "alpha": args.alpha, "xmax": args.xmax,
                       "nperm": args.nperm, "tol": args.tol,
                       "subsamples": args.subsamples,
                       "sub_nperm": args.sub_nperm, "seed": args.seed,
                       "support_cells": tot, "n_exact_zeros": n_zero,
                       "not_asked": "no expected zero count under any "
                                    "magnitude null; entry 17 refuses "
                                    "that null model"},
            "rows": rows}
        try:
            with open(args.out, "w") as fh:
                json.dump(payload, fh, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
