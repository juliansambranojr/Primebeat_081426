#!/usr/bin/env python3
"""O79 — EXPLORATORY. No prereg, no verdict.

The same primes, sorted mod 5: four integer difference tables whose
L-functions have Euler products, and the Davenport-Heilbronn
combination of them, which does not.

WHY THIS EXISTS. Entry 160 retired O78's reading and an adversarial
review proposed rebuilding the bench's table over the
Davenport-Heilbronn coefficients, to separate "our structure is a
functional-equation fact" from "our structure is an Euler-product
fact". Instantiating that proposal first (the entry 158 rule) found it
degenerate: the DH coefficients (1, tau, -tau, -1, 0) sum to zero over
a period, so their partial sum is periodic and bounded, carrying no
zero information at all.

Julian's question fixed it: our table is integers, so what integers
are there. The answer is that DH is built from the SAME primes.
DH(s) = c*L(s,chi) + conj(c)*L(s,conj(chi)) for chi the order-4
character mod 5, and each L has an Euler product over the ordinary
primes. What destroys the Euler product is the combination, not the
ingredients. So the integer objects are the prime counts refined by
residue class,

    N_a(r) = pi(2^r ; p = a mod 5) - pi(2^(r-1) ; p = a mod 5)

four integer sequences summing exactly to the bench's own N(r), and
the bench's backward-difference construction applies to each verbatim.

THE THREE ARMS, all sharing one functional-equation shape:
  zeta        pi(2^r)                 Euler product, zeros on the line
                                      under RH — the existing bench
  Dirichlet   pi(2^r ; a mod 5), a=1..4   Euler products, zeros on the
                                      line under GRH — four new
                                      integer tables
  DH          1*c1 + tau*c2 - tau*c3 - c4   no Euler product, zeros
                                      provably off the line, and NOT
                                      an integer table

tau = (sqrt(10 - 2 sqrt 5) - 2)/(sqrt 5 - 1) = 0.284079..., the
positive root of tau^2 + (1 + sqrt 5) tau - 1 = 0. Both forms are
checked against each other at run time, and the completed function's
functional equation is spot-checked, because a recalled constant is
not a loaded one.

WHAT IS REPORTED. Per arm: the exact-zero census (d >= 1) of the
integer table, with each zero's (r,d); whether the zeta arm's four —
(2,1), (4,1), (8,3), (20,6) — appear in any class table; and for the
DH combination, how often the irrational weights leave an integer at
all.

This script states numbers; interpretation is not its job.

Reads with: notes/lab_notebook_2.md entries 158, 160;
O16_centered_difference_table.py and O27_joint_dyadic_triadic_table.py
(the construction), papers/The-Zero-Surface.md.

HOW IT WAS RUN
--------------
    .venv/bin/python O79_residue_class_tables.py
"""
import argparse
import hashlib
import json
import os
from datetime import datetime, timezone

import numpy as np
import mpmath as mp

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "residue_class_tables.json")
ZETA_ZEROS = [(2, 1), (4, 1), (8, 3), (20, 6)]


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def class_counts(rmax, seg=1 << 24):
    """pi(2^r ; p = a mod 5) for a = 0..4 and r = 1..rmax, by segmented
    sieve. Exact integers."""
    top = 1 << rmax
    base_lim = int(top ** 0.5) + 1
    s = np.ones(base_lim + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(base_lim ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    base = np.flatnonzero(s).astype(np.int64)

    checkpoints = [1 << r for r in range(1, rmax + 1)]
    cum = {a: 0 for a in range(5)}
    out = {a: [0] * (rmax + 1) for a in range(5)}
    ci = 0
    lo = 2
    while lo <= top:
        hi = min(lo + seg, top + 1)
        block = np.ones(hi - lo, dtype=bool)
        for p in base:
            if p * p >= hi:
                break
            start = max(p * p, ((lo + p - 1) // p) * p)
            block[start - lo::p] = False
        idx = np.flatnonzero(block) + lo
        while ci < len(checkpoints) and checkpoints[ci] < hi:
            cp = checkpoints[ci]
            part = idx[idx <= cp]
            for a in range(5):
                out[a][ci + 1] = cum[a] + int((part % 5 == a).sum())
            ci += 1
        for a in range(5):
            cum[a] += int((idx % 5 == a).sum())
        lo = hi
    while ci < len(checkpoints):
        for a in range(5):
            out[a][ci + 1] = cum[a]
        ci += 1
    return out


def table(N, rmax):
    T = {}
    for r in range(1, rmax + 1):
        T[(r, 0)] = N[r]
    for d in range(1, rmax):
        for r in range(d + 1, rmax + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def census(T, rmax):
    return [(r, d) for d in range(1, rmax)
            for r in range(d + 1, rmax + 1) if T[(r, d)] == 0]


def main():
    ap = argparse.ArgumentParser(
        description=("O79 - integer difference tables of the prime counts "
                     "refined by residue class mod 5, against the "
                     "Davenport-Heilbronn combination of them. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--rmax", type=int, default=30,
                    help="top row; the ladder runs to 2^RMAX (default 30)")
    ap.add_argument("--dps", type=int, default=30,
                    help="mpmath precision for the tau checks (default 30)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON)
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    mp.mp.dps = args.dps
    tau = (mp.sqrt(10 - 2 * mp.sqrt(5)) - 2) / (mp.sqrt(5) - 1)
    resid = tau ** 2 + (1 + mp.sqrt(5)) * tau - 1

    print("O79 — the same primes, sorted mod 5.  EXPLORATORY.\n")
    print("TAU CHECK — literature form against the eigenvector condition:")
    print(f"   tau = (sqrt(10-2sqrt5)-2)/(sqrt5-1) = {mp.nstr(tau, 12)}")
    print(f"   residual of tau^2 + (1+sqrt5)tau - 1 = {mp.nstr(resid, 5)}")
    if abs(resid) > mp.mpf(10) ** (-args.dps + 5):
        print("   TAU CHECK FAILED"); raise SystemExit(1)

    a_dh = {1: mp.mpf(1), 2: tau, 3: -tau, 4: mp.mpf(-1), 0: mp.mpf(0)}

    def f(s):
        return 5 ** (-s) * sum(a_dh[j] * mp.zeta(s, mp.mpf(j) / 5)
                               for j in (1, 2, 3, 4))

    def xi(s):
        return (5 / mp.pi) ** (s / 2) * mp.gamma((s + 1) / 2) * f(s)

    fe = [abs(xi(s) / xi(1 - s) - 1)
          for s in (mp.mpf('0.3') + 2j, mp.mpf('0.7') + 5j,
                    mp.mpf('0.2') + 11j)]
    print(f"   functional equation |xi(s)/xi(1-s) - 1| at three points: "
          f"max {mp.nstr(max(fe), 5)}")
    if max(fe) > mp.mpf('1e-15'):
        print("   FUNCTIONAL EQUATION CHECK FAILED"); raise SystemExit(1)
    print("   checks PASSED — the object is the one the literature "
          "names.\n")

    print(f"SIEVING to 2^{args.rmax} and splitting by residue class...")
    C = class_counts(args.rmax)
    rmax = args.rmax
    tot = [sum(C[a][r] for a in range(5)) for r in range(rmax + 1)]
    N_tot = [0] + [tot[r] - tot[r - 1] for r in range(1, rmax + 1)]
    N_cls = {a: [0] + [C[a][r] - C[a][r - 1] for r in range(1, rmax + 1)]
             for a in range(1, 5)}
    print(f"   pi(2^{rmax}) = {tot[rmax]}   "
          f"classes 1..4 = " + ", ".join(str(C[a][rmax]) for a in range(1, 5))
          + f", class 0 = {C[0][rmax]}")
    print(f"   sum check: {'OK' if sum(C[a][rmax] for a in range(5)) == tot[rmax] else 'BAD'}\n")

    T_tot = table(N_tot, rmax)
    z_tot = census(T_tot, rmax)
    print("ARM 1 — zeta: pi(2^r), Euler product, zeros on the line "
          "under RH")
    print(f"   exact zeros (d>=1), r <= {rmax}: {z_tot}")

    print("\nARM 2 — Dirichlet: the four classes, Euler products, zeros "
          "on the line under GRH")
    cls_zeros = {}
    for a in range(1, 5):
        Ta = table(N_cls[a], rmax)
        za = census(Ta, rmax)
        cls_zeros[a] = za
        shared = [c for c in za if c in z_tot]
        print(f"   class {a} mod 5: {len(za):>3} exact zeros"
              f"   shared with the zeta arm: {shared if shared else 'none'}")
        if len(za) <= 14:
            print(f"      {za}")
        else:
            print(f"      {za[:14]} ... (+{len(za)-14} more)")

    print("\n   the zeta arm's four, looked for in every class table:")
    for cell in ZETA_ZEROS:
        where = [a for a in range(1, 5) if cell in cls_zeros[a]]
        print(f"      {cell}: " + (f"present in class(es) {where}"
                                   if where else "in no class table"))

    print("\nARM 3 — Davenport-Heilbronn: the tau-weighted combination, "
          "no Euler product")
    combo = [float(a_dh[1]) * C[1][r] + float(tau) * C[2][r]
             - float(tau) * C[3][r] - float(a_dh[1]) * C[4][r]
             for r in range(rmax + 1)]
    n_int = sum(1 for r in range(1, rmax + 1)
                if abs(combo[r] - round(combo[r])) < 1e-9)
    n_bal = sum(1 for r in range(1, rmax + 1) if C[2][r] == C[3][r])
    print(f"   rows where the combination is an integer: {n_int} of "
          f"{rmax}")
    print(f"   rows where c2 = c3 (the tau terms cancel exactly): "
          f"{n_bal}")
    print("   every integer row is a cancellation row: "
          f"{'yes' if n_int == n_bal else 'NO — check'}")
    print("   so the DH arm has no exact-zero object of its own; its "
          "integrality is\n   an accident of class balance, not a "
          "property of the combination.")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O79_residue_class_tables.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "rmax": rmax,
                       "dps": args.dps, "tau": float(tau),
                       "tau_condition": "tau^2 + (1+sqrt5)tau - 1 = 0",
                       "construction": "N_a(r) = pi(2^r; a mod 5) - "
                                       "pi(2^(r-1); a mod 5); backward "
                                       "differences, exact integers"},
            "pi_at_top": tot[rmax],
            "class_counts_at_top": {str(a): C[a][rmax] for a in range(5)},
            "zeta_arm_zeros": [list(c) for c in z_tot],
            "class_arm_zeros": {str(a): [list(c) for c in cls_zeros[a]]
                                for a in range(1, 5)},
            "dh_integer_rows": n_int, "dh_balanced_rows": n_bal}
        try:
            with open(args.out, "w") as fh:
                json.dump(payload, fh, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
