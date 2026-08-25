#!/usr/bin/env python3
"""
O30 — SILENCING the scaffold primes 2, 3, 5: zero out their counts in the blocks
      that contain them, leave every block boundary where it is, and ask whether
      the dyadic table's exact zeros survive.

Reads with: O16_centered_difference_table.py (the backward-difference table and
its exact zero set {(2,1), (4,1), (8,3), (20,6)}); O27_joint_dyadic_triadic_table.py
(same construction, two bases).  Companion to O31_excise_scaffold_primes.py, which
performs the OTHER operation — deleting the integers and closing the line up.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree, run there, and
moved into the tree afterwards.  The code logic is unchanged from the scratch
version; only this docstring was added.

WHAT THIS MEASURES
------------------
Three tables on r = 1..RMAX, d = 0..DMAX (default r = 1..22, d = 0..8), all from
the same backward-difference construction T(r,d) = T(r,d-1) - T(r-1,d-1):

    BASELINE   depth-0 row N(r) = pi(2^r) - pi(2^(r-1)), untouched
    SILENCED   the same row with the counts of 2, 3 and 5 removed from the
               blocks that hold them (blocks 1, 2, 3).  Block boundaries are
               NOT moved; the emptied leading blocks stay in place as zeros.
    REINDEXED  the silenced row with the leading emptied regimes dropped and
               r relabelled from 1, to see how the zero coordinates shift.

Each table prints its full triangle and its exact-zero coordinate list.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--rmax 22 and --dmax 8 are the old module-level constants — so a no-flag run
prints exactly what the original run printed and prior transcripts remain
fully comparable.  The silenced prime set {2, 3, 5} and its block indices
{1, 2, 3} stay inline: they are the object of the test, and generalizing them
would be new capability, not an instrument fix.  The run now also writes the
house envelope (CONTEXT.md § "Output schema") to
results/silence_scaffold_primes.json, honouring --out, --no-json and
--results-dir; paths are anchored to _HERE so the run is cwd-independent.

HOW IT WAS RUN
--------------
    python3 O30_silence_scaffold_primes.py

No flags: the defaults reproduce the original 2026-08-17 run exactly, plus the
results JSON.  See --rmax, --dmax, --results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install sympy
"""

import argparse
import datetime
import hashlib
import json
import math
import os

from sympy import primepi

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "silence_scaffold_primes.json")


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """Coerce to JSON-safe Python types; non-finite floats -> None."""
    if isinstance(o, dict):
        return {str(k): _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple, set, frozenset)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str):
        return o
    if isinstance(o, bool):
        return bool(o)
    if isinstance(o, int):
        return int(o)
    if isinstance(o, float):
        return o if math.isfinite(o) else None
    try:
        f = float(o)
    except (TypeError, ValueError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)


def _parse_args():
    ap = argparse.ArgumentParser(
        description=("O30 - silence the scaffold primes 2, 3, 5 in place and "
                     "ask whether the dyadic table's exact zeros survive. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict."))
    ap.add_argument("--rmax", type=int, default=22,
                    help="ladder top: rows r = 1..RMAX (default 22)")
    ap.add_argument("--dmax", type=int, default=8,
                    help="deepest difference depth d = 0..DMAX (default 8)")
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
    return args


args = _parse_args()
_started = datetime.datetime.now(datetime.timezone.utc)
RMAX, DMAX = args.rmax, args.dmax

def build(N):
    # N is 1-indexed list of depth-0 block counts; T[d][r]
    n = len(N)
    T = [[None]*(n+1) for _ in range(DMAX+1)]
    for r in range(1, n+1):
        T[0][r] = N[r-1]
    for d in range(1, DMAX+1):
        for r in range(d+1, n+1):
            if T[d-1][r] is not None and T[d-1][r-1] is not None:
                T[d][r] = T[d-1][r] - T[d-1][r-1]
    return T

def show(T, title, n):
    print("\n" + title)
    hdr = "   r" + "".join(f"{'d'+str(d):>9}" for d in range(DMAX+1))
    print(hdr)
    for r in range(1, n+1):
        row = f"{r:>4}"
        for d in range(DMAX+1):
            v = T[d][r] if r < len(T[d]) else None
            row += "         " if v is None else f"{v:>9}"
        print(row)
    zs = [(r,d) for d in range(DMAX+1) for r in range(1,n+1)
          if r < len(T[d]) and T[d][r] == 0]
    print("  zeros:", sorted(zs, key=lambda t:(t[0],t[1])))

def _zeros(T, n):
    """Exact-zero coordinate list, same rule as show()."""
    zs = [(r, d) for d in range(DMAX+1) for r in range(1, n+1)
          if r < len(T[d]) and T[d][r] == 0]
    return sorted(zs, key=lambda t: (t[0], t[1]))

def _rows(T, table, n):
    """One rows[] record per r: every depth cell of that row."""
    return [{"table": table, "r": r,
             "cells": {str(d): (T[d][r] if r < len(T[d]) else None)
                       for d in range(DMAX+1)}}
            for r in range(1, n+1)]

# baseline
base = [int(primepi(2**r) - primepi(2**(r-1))) for r in range(1, RMAX+1)]
T_base = build(base)
show(T_base, "BASELINE  (all primes)", RMAX)

# silence 2,3,5 -> they live in blocks 1,2,3
sil = list(base)
for p, blk in ((2,1),(3,2),(5,3)):
    sil[blk-1] -= 1
print("\nsilenced depth-0 row:", sil[:8], "...")
T_sil = build(sil)
show(T_sil, "SILENCED  (2,3,5 removed, regimes kept in place)", RMAX)

# reindexed: drop leading empty regimes, relabel from r=1
first = next(i for i,v in enumerate(sil) if v != 0)
re = sil[first:]
print(f"\ndropped {first} leading empty regimes; new depth-0 row:", re[:8], "...")
T_re = build(re)
show(T_re, f"REINDEXED (2,3,5 removed, r shifted by {first})", len(re))

if not args.no_json:
    _ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": ("EXPLORATORY - no prereg, no decision rule, no verdict. "
                   "Nothing here may be described as a verdict."),
        "params": {
            "code_version": _code_version(),
            "rmax": RMAX,
            "dmax": DMAX,
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "silenced_primes_and_blocks": [[2, 1], [3, 2], [5, 3]],
            "silenced_set_note": ("The silenced set {2, 3, 5} and its blocks "
                                  "{1, 2, 3} are the object of the test and "
                                  "are inline by design."),
            "construction": "T(r,d) = T(r,d-1) - T(r-1,d-1) on "
                            "N(r) = pi(2^r) - pi(2^(r-1))",
        },
        "summary": {
            "baseline_zeros": _zeros(T_base, RMAX),
            "silenced_zeros": _zeros(T_sil, RMAX),
            "reindexed_zeros": _zeros(T_re, len(re)),
            "dropped_leading_regimes": first,
            "baseline_depth0": base,
            "silenced_depth0": sil,
            "reindexed_depth0": re,
        },
        "rows": (_rows(T_base, "baseline", RMAX)
                 + _rows(T_sil, "silenced", RMAX)
                 + _rows(T_re, "reindexed", len(re))),
    }
    _write_results(payload, args.out)
