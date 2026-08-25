#!/usr/bin/env python3
"""O74 — EXPLORATORY. No prereg, no verdict.

Interleaved row sums, machine-verified and extended to r = 41.

WHY THIS EXISTS. Entry 31 recorded, hand-computed and flagged
UNVERIFIED: interleaved row sums (dyadic + triadic cells summed across
a full row) for r = 1..6 as 3, 3, 15, 27, 88, 168, with dyadic
components 1, 1, 4, -1, 21, -18 and triadic components 2, 2, 11, 28,
67, 186; the dyadic component changes sign, the triadic never does;
T(6) = 168 equals pi(1000) without recurring. The intended verifying
run was killed before output (open NOTEPAD line since 2026-08-17).
This script is that run.

CONSTRUCTION (O27's, verbatim). Per base b in {2, 3}:
    depth 0:  N_b(r)   = pi(b^r) - pi(b^(r-1))
    depth d:  T_b(r,d) = T_b(r,d-1) - T_b(r-1,d-1)
Row sum S_b(r) = sum over d = 0..r-1 of T_b(r,d); interleaved total
T(r) = S_2(r) + S_3(r). Exact integers throughout; counts from
pi2n_cache.json and pi3n_cache.json, both READ ONLY (the triadic
cache reaches exactly r = 41, which is why the extension stops there).

GATE. The r = 1..6 values must reproduce entry 31's hand-computed
lists exactly, or the script exits 1.

Reads with: O27_joint_dyadic_triadic_table.py, notes/lab_notebook.md
entry 31, pi2n_cache.json, pi3n_cache.json.

HOW IT WAS RUN
--------------
    python3 O74_interleaved_row_sums.py
"""
import argparse
import hashlib
import json
import os
from datetime import datetime, timezone

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "interleaved_row_sums.json")

HAND = {"total": [3, 3, 15, 27, 88, 168],
        "dyadic": [1, 1, 4, -1, 21, -18],
        "triadic": [2, 2, 11, 28, 67, 186]}


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def table(cache, rmax):
    N = [None] + [cache[str(r)] - cache[str(r - 1)]
                  for r in range(1, rmax + 1)]
    T = {}
    for r in range(1, rmax + 1):
        T[(r, 0)] = N[r]
        for d in range(1, r):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def main():
    ap = argparse.ArgumentParser(
        description=("O74 - interleaved dyadic+triadic row sums, "
                     "gate-verified against entry 31's hand computation, "
                     "extended to r=41. EXPLORATORY: no prereg, no "
                     "decision rule, no verdict."))
    ap.add_argument("--rmax", type=int, default=41,
                    help="top row (default 41 = the pi3n cache ceiling)")
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

    c2 = json.load(open(os.path.join(_HERE, "pi2n_cache.json")))
    c3 = json.load(open(os.path.join(_HERE, "pi3n_cache.json")))
    rmax = min(args.rmax,
               max(int(k) for k in c2), max(int(k) for k in c3))

    T2, T3 = table(c2, rmax), table(c3, rmax)
    S2 = {r: sum(T2[(r, d)] for d in range(r)) for r in range(1, rmax + 1)}
    S3 = {r: sum(T3[(r, d)] for d in range(r)) for r in range(1, rmax + 1)}

    print("O74 — interleaved row sums, machine-verified.  EXPLORATORY.")
    print(f"  construction: O27's; counts from pi2n/pi3n caches; "
          f"rmax = {rmax}\n")

    print("GATE — r = 1..6 against entry 31's hand computation:")
    got = {"total": [S2[r] + S3[r] for r in range(1, 7)],
           "dyadic": [S2[r] for r in range(1, 7)],
           "triadic": [S3[r] for r in range(1, 7)]}
    ok = True
    for k in ("dyadic", "triadic", "total"):
        match = got[k] == HAND[k]
        ok &= match
        print(f"   {k:>8}: got {got[k]}   recorded {HAND[k]}   "
              f"{'ok' if match else 'MISMATCH'}")
    if not ok:
        print("GATE FAILED — the hand computation and this construction "
              "disagree; both cannot stand.")
        raise SystemExit(1)
    print("   gate PASSED\n")

    print(f"   {'r':>3} {'dyadic S2':>14} {'triadic S3':>16} "
          f"{'total T':>16}")
    d_signs, t_signs = set(), set()
    for r in range(1, rmax + 1):
        print(f"   {r:>3} {S2[r]:>14} {S3[r]:>16} {S2[r] + S3[r]:>16}")
        if S2[r] != 0:
            d_signs.add(S2[r] > 0)
        if S3[r] != 0:
            t_signs.add(S3[r] > 0)
    print(f"\n   dyadic component changes sign over r <= {rmax}: "
          f"{len(d_signs) == 2}")
    print(f"   triadic component changes sign over r <= {rmax}: "
          f"{len(t_signs) == 2}")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O74_interleaved_row_sums.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(), "rmax": rmax,
                       "construction": "O27 backward-difference triangles "
                                       "per base; S_b(r) = sum_d T_b(r,d); "
                                       "T(r) = S_2(r) + S_3(r)",
                       "gate": "r=1..6 equal to entry 31's hand-computed "
                               "lists, exactly"},
            "rows": {str(r): {"dyadic": S2[r], "triadic": S3[r],
                              "total": S2[r] + S3[r]}
                     for r in range(1, rmax + 1)},
            "dyadic_changes_sign": len(d_signs) == 2,
            "triadic_changes_sign": len(t_signs) == 2}
        try:
            with open(args.out, "w") as f:
                json.dump(payload, f, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
