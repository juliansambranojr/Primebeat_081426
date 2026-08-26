#!/usr/bin/env python3
"""O78 — EXPLORATORY. No prereg, no verdict.

The zero-surface question, asked over bases that cannot fake the answer.

WHY THIS EXISTS. papers/The-Zero-Surface.md § G1: "Whether the zeros
form a surface. The question is UNMEASURED, not refuted." Its § C found
cross-base nearest-neighbour compression at z = -11.10, and its § D
killed the reading: eight of O45's eleven bases have log2 b an exact
integer multiple (2..9) of the unit pi/(4 gamma_1), carrying 107 of the
125 zeros, so window edges MUST coincide across them (D3, D4). "Cross-
base window alignment is forced by the base selection. C1, C2 and C6
measure the prereg's choice of bases, not the arrangement of the
zeros" (D7).

§ F states what would answer it, and this script is that, filled:
  F1  bases pairwise incommensurate in log — no two with log b1/log b2
      rational
  F2  bases in the range where zeros occur at all, roughly 1.11 <= b <= 2
  F4  "The statistic and its null carry over unchanged — the coordinate
      of § B is a property of the cell, not of the base set."

THE BASE SET, incommensurate BY CONSTRUCTION rather than by luck.
log2(b_j) = ALPHA * sqrt(p_j) over distinct primes p_j. Then
log b_i / log b_j = sqrt(p_i / p_j), irrational for distinct primes
because p_i/p_j is never a perfect square. The scaling ALPHA cancels in
every ratio, so it is free to place the bases inside F2's window. This
is the opposite of O45's family: there the bases were exp(pi*m/(4 g1))
for integer m, commensurate by construction (§ E2).

THE COORDINATE (§ B3, unchanged, not a choice): cell (r,d) at base b
reads the value stretch (b^(r-d-1), b^r], i.e. in log2

    lo = (r-d-1)*log2 b     hi = r*log2 b     w = (d+1)*log2 b

THE STATISTIC (§ C1 and § C6, copied from t22_zero_surface.py): mean
distance from each zero to its nearest neighbour AT ANOTHER BASE, in
the (lo, hi) plane; null drawn from each base's own resolved support,
stratified so base composition matches exactly; then redrawn matching
each zero's window width to +-0.25 in log2.

GATES, both run before any statistic. (1) No EXACT cross-base window-edge
coincidence — the defect § D1 names. A first version of this gate demanded
distance from every rational with denominator <= 50, which Dirichlet's
theorem makes unsatisfiable for any base set; the gate is measured against
the defect instead of against abstract rationality.
(2) Against the pi/(4 gamma_1) unit that trapped O45, no base's log2 b
may sit within --incommens-tol of an integer multiple. A failure of
either exits 1 before measuring anything.

Reads with: papers/The-Zero-Surface.md (the spec, § B, C, D, F),
O45_sub_integer_base_scan.py (table construction, r_thick),
analysis/2026-08-19_table_structure/scripts/t22_zero_surface.py (the
statistic and both nulls), notes/lab_notebook_2.md entries 54, 56.

HOW IT WAS RUN
--------------
    .venv/bin/python O78_incommensurate_zero_surface.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone
from fractions import Fraction

import numpy as np
import primecountpy

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "incommensurate_zero_surface.json")
GAMMA1 = 14.134725141734693790
UNIT_LOG2 = math.pi / (4 * GAMMA1) / math.log(2)   # 0.080163571...


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def best_rational_miss(x, max_den):
    """Distance from x to its best rational approximation with denominator
    <= max_den."""
    fr = Fraction(x).limit_denominator(max_den)
    return abs(x - float(fr)), fr


def base_from_prime(p, alpha):
    return 2.0 ** (alpha * math.sqrt(p))


def scan_base(b, xmax):
    """O45's construction: F[r] = floor(b^r), W(r) = F[r]-F[r-1],
    N(r) = pi(F[r]) - pi(F[r-1]), backward-difference table, r_thick the
    smallest R with W(r)/(ln(b)*r) >= 1 for all r >= R. Returns
    (zeros, support) as lists of (lo, hi) in log2."""
    lg = math.log2(b)
    lnb = math.log(b)
    r_max = int(math.floor(math.log(xmax) / lnb))
    F = [1] + [int(math.floor(b ** r)) for r in range(1, r_max + 1)]
    W = [0] + [F[r] - F[r - 1] for r in range(1, r_max + 1)]

    rt = r_max + 1
    for r in range(r_max, 0, -1):
        if W[r] / (lnb * r) >= 1.0:
            rt = r
        else:
            break

    pi_memo = {}

    def PI(x):
        if x < 2:
            return 0
        if x not in pi_memo:
            pi_memo[x] = int(primecountpy.prime_pi(x))
        return pi_memo[x]

    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    P = {}
    for r in range(1, r_max + 1):
        P[(r, 0)] = N[r]
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            P[(r, d)] = P[(r, d - 1)] - P[(r - 1, d - 1)]

    zeros, support = [], []
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            if r - d < rt:
                continue
            win = ((r - d - 1) * lg, r * lg)
            support.append(win)
            if P[(r, d)] == 0:
                zeros.append(win)
    return zeros, support, r_max, rt


def cross_base_nn(pts, base_of):
    """t22's statistic: mean distance to the nearest neighbour AT ANOTHER
    BASE, in the (lo, hi) plane."""
    D = np.sqrt(((pts[:, None, :] - pts[None, :, :]) ** 2).sum(-1))
    same = base_of[:, None] == base_of[None, :]
    D = np.where(same, np.inf, D)
    return float(D.min(1).mean())


def main():
    ap = argparse.ArgumentParser(
        description=("O78 - the zero-surface test over pairwise-"
                     "incommensurate bases, per The-Zero-Surface.md "
                     "section F. EXPLORATORY: no prereg, no decision "
                     "rule, no verdict."))
    ap.add_argument("--primes", type=str,
                    default="2,3,5,7,11,13,17,19,23,29",
                    help="primes p_j giving log2 b_j = alpha*sqrt(p_j) "
                         "(default 2..29)")
    ap.add_argument("--alpha", type=float, default=0.18,
                    help="scaling placing bases inside [1.11, 2] "
                         "(default 0.18); cancels in every ratio")
    ap.add_argument("--xmax", type=float, default=2.0 ** 32,
                    help="ladder ceiling, matching O45's 2^32 so the "
                         "support geometry is comparable")
    ap.add_argument("--nperm", type=int, default=2000,
                    help="null draws (default 2000, t22's)")
    ap.add_argument("--tol", type=float, default=0.25,
                    help="width-matching tolerance in log2 (t22's 0.25)")
    ap.add_argument("--max-den", type=int, default=50,
                    help="incommensurability gate: largest denominator "
                         "tried (default 50)")
    ap.add_argument("--incommens-tol", type=float, default=0.01,
                    help="gate: required miss from any such rational "
                         "and from any integer multiple of the "
                         "pi/(4 g1) unit (default 0.01)")
    ap.add_argument("--seed", type=int, default=2026,
                    help="house seed (default 2026)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    rng = np.random.default_rng(args.seed)
    primes = [int(s) for s in args.primes.split(",")]
    bases = [base_from_prime(p, args.alpha) for p in primes]

    print("O78 — the zero surface over incommensurate bases.  "
          "EXPLORATORY.")
    print(f"  log2 b = {args.alpha} * sqrt(p), p in {primes}")
    print(f"  ceiling {args.xmax:.4g} (2^{math.log2(args.xmax):.0f}), "
          f"nperm {args.nperm}, seed {args.seed}\n")

    print("GATE 1 — cross-base window-edge coincidence, the defect § D1")
    print("  actually names ('the sorted window list carries exact repeats")
    print("  of lo across different bases'):")

    def edge_list(log2bs, top):
        pts = []
        for i, l in enumerate(log2bs):
            for r in range(1, int(top / l) + 1):
                pts.append((r * l, i))
        pts.sort()
        return pts

    def coincidences(pts, near_tol=1e-3):
        exact = near = 0
        n = len(pts)
        for k in range(n):
            e, i = pts[k]
            for j in range(k + 1, n):
                f, m = pts[j]
                if f - e > near_tol:
                    break
                if m != i:
                    if f - e < 1e-9:
                        exact += 1
                    else:
                        near += 1
        return exact, near

    top = math.log2(args.xmax)
    ours_l = [math.log2(b) for b in bases]
    pts_ours = edge_list(ours_l, top)
    ex_o, nr_o = coincidences(pts_ours)
    o45_l = [m * UNIT_LOG2 for m in range(2, 10)] + [1.0, 0.5, 1.0 / 3.0]
    pts_o45 = edge_list(o45_l, top)
    ex_45, nr_45 = coincidences(pts_o45)
    print(f"   O45's base set: {len(pts_o45)} edges, EXACT cross-base "
          f"coincidences {ex_45}, within 1e-3 {nr_45}")
    print(f"   this base set : {len(pts_ours)} edges, EXACT cross-base "
          f"coincidences {ex_o}, within 1e-3 {nr_o}")
    if ex_o > 0:
        print("   GATE 1 FAILED — exact cross-base edge coincidences, the "
              "§ D1 defect.")
        raise SystemExit(1)
    print("   gate PASSED — no exact coincidence; the near ones are what "
          "generic\n   points give, not a shared lattice.\n")
    m, d2_placeholder = float(ex_o), None

    print("GATE 2 — against the pi/(4 g1) unit that forced O45's "
          f"alignment (unit = {UNIT_LOG2:.9f} in log2):")
    worst2 = (1e9, None)
    for p, b in zip(primes, bases):
        q = math.log2(b) / UNIT_LOG2
        dist = abs(q - round(q))
        if dist < worst2[0]:
            worst2 = (dist, (p, b, q))
    d2, info2 = worst2
    print(f"   closest to an integer multiple: p={info2[0]}, "
          f"b={info2[1]:.6f}, log2b/unit = {info2[2]:.4f} "
          f"(distance {d2:.4f})")
    if d2 <= args.incommens_tol:
        print("   GATE 2 FAILED — a base sits on O45's lattice.")
        raise SystemExit(1)
    print("   gate PASSED — no base is on the lattice that forced "
          "O45's alignment.\n")

    print("THE SCAN:")
    print(f"   {'p':>4} {'base':>10} {'log2 b':>8} {'r_max':>6} "
          f"{'r_thick':>8} {'support':>8} {'zeros':>6}")
    zeros_per, support_per, meta = [], [], []
    for p, b in zip(primes, bases):
        z, s, r_max, rt = scan_base(b, args.xmax)
        zeros_per.append(np.array(z, dtype=float).reshape(-1, 2))
        support_per.append(np.array(s, dtype=float).reshape(-1, 2))
        meta.append({"prime": p, "base": b, "log2_base": math.log2(b),
                     "r_max": r_max, "r_thick": rt,
                     "n_support": len(s), "n_zeros": len(z)})
        print(f"   {p:>4} {b:>10.6f} {math.log2(b):>8.5f} {r_max:>6} "
              f"{rt:>8} {len(s):>8} {len(z):>6}")

    keep = [i for i in range(len(primes)) if len(zeros_per[i]) > 0]
    if len(keep) < 2:
        print("\n   fewer than two bases carry a zero; the cross-base "
              "statistic is undefined. Reported as such.")
        raise SystemExit(0)
    zeros_k = [zeros_per[i] for i in keep]
    support_k = [support_per[i] for i in keep]
    counts = [len(z) for z in zeros_k]
    Z = np.vstack(zeros_k)
    base_ids = np.concatenate([np.full(n, i) for i, n in enumerate(counts)])
    n_tot = len(Z)
    print(f"\n   {n_tot} zeros across {len(keep)} bases carrying any "
          f"(bases with none are excluded from the statistic)")

    obs = cross_base_nn(Z, base_ids.astype(float))
    null = np.empty(args.nperm)
    for t in range(args.nperm):
        draw = np.vstack([sp[rng.choice(len(sp), size=n, replace=False)]
                          for sp, n in zip(support_k, counts)])
        null[t] = cross_base_nn(draw, base_ids.astype(float))
    z_stat = (obs - null.mean()) / null.std()
    p_low = (1 + (null <= obs).sum()) / (1 + args.nperm)
    print("\nSTATISTIC — cross-base nearest neighbour, stratified null "
          "(section C1's):")
    print(f"   observed        {obs:.4f}")
    print(f"   null mean       {null.mean():.4f}   sd {null.std():.4f}")
    print(f"   z               {z_stat:+.2f}")
    print(f"   p (low tail)    {p_low:.4f}     {args.nperm} draws")

    pools = []
    for zi, sp in zip(zeros_k, support_k):
        ws = sp[:, 1] - sp[:, 0]
        per_zero = []
        for w in (zi[:, 1] - zi[:, 0]):
            idx = np.flatnonzero(np.abs(ws - w) <= args.tol)
            if len(idx) == 0:
                idx = np.array([int(np.argmin(np.abs(ws - w)))])
            per_zero.append(idx)
        pools.append((sp, per_zero))
    sizes = [len(ix) for _, pz in pools for ix in pz]
    nullm = np.empty(args.nperm)
    for t in range(args.nperm):
        draw = np.vstack([sp[[int(rng.choice(ix)) for ix in pz]]
                          for sp, pz in pools])
        nullm[t] = cross_base_nn(draw, base_ids.astype(float))
    zm = (obs - nullm.mean()) / nullm.std()
    pm = (1 + (nullm <= obs).sum()) / (1 + args.nperm)
    print(f"\nWIDTH-MATCHED NULL (section C6's, +-{args.tol} in log2; "
          f"pools min {min(sizes)} median {int(np.median(sizes))} "
          f"max {max(sizes)}):")
    print(f"   observed        {obs:.4f}   (unchanged — same zeros)")
    print(f"   matched null    {nullm.mean():.4f}   sd {nullm.std():.4f}")
    print(f"   z               {zm:+.2f}")
    print(f"   p (low tail)    {pm:.4f}")

    print("\n  READ. Section C measured z = -11.10 raw and -5.32 width-"
          "matched on\n  a base set whose alignment section D showed was "
          "forced. These bases\n  cannot force it: the ratios are "
          "sqrt(p_i/p_j). Whatever the numbers\n  above are, they are "
          "the arrangement of the zeros, not the base set.\n  "
          "Interpretation is not this script's job.")

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": "O78_incommensurate_zero_surface.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "primes": primes,
                       "alpha": args.alpha, "xmax": args.xmax,
                       "nperm": args.nperm, "tol": args.tol,
                       "seed": args.seed, "unit_log2": UNIT_LOG2,
                       "coordinate": "lo=(r-d-1)log2 b, hi=r log2 b "
                                     "(The-Zero-Surface.md B3)",
                       "stratum": "d>=1 and r-d>=r_thick (O45's)"},
            "gates": {"exact_cross_base_coincidences": ex_o,
                      "near_cross_base_coincidences": nr_o,
                      "o45_exact_for_comparison": ex_45,
                      "unit_min_distance": d2},
            "per_base": meta,
            "n_zeros_total": int(n_tot),
            "bases_with_zeros": len(keep),
            "cross_base_nn": {"observed": obs, "null_mean": float(null.mean()),
                              "null_sd": float(null.std()),
                              "z": float(z_stat), "p_low": float(p_low)},
            "width_matched": {"observed": obs,
                              "null_mean": float(nullm.mean()),
                              "null_sd": float(nullm.std()),
                              "z": float(zm), "p_low": float(pm),
                              "pool_min": int(min(sizes)),
                              "pool_median": int(np.median(sizes)),
                              "pool_max": int(max(sizes))}}
        try:
            with open(args.out, "w") as f:
                json.dump(payload, f, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
