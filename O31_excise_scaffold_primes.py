#!/usr/bin/env python3
"""
O31 — EXCISING the scaffold primes 2, 3, 5: delete them from the number line
      entirely, close the line up so every position above them reindexes, and
      ask whether the dyadic table's exact zeros survive.

Reads with: O16_centered_difference_table.py (the backward-difference table and
its exact zero set {(2,1), (4,1), (8,3), (20,6)}).  Companion to
O30_silence_scaffold_primes.py, which performs the OTHER operation — zeroing the
counts while leaving every block boundary in place.  The pair is the point: one
operation changes HOW MANY primes lie below a stencil, the other changes WHERE
the block boundaries fall.

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
Two excision variants, each rebuilt into a full backward-difference table on
r = 1..RMAX, d = 0..DMAX (default r = 1..22, d = 0..8), each printing its
triangle and its exact-zero list:

    A   delete only the three integers 2, 3, 5
    B   delete 2, 3, 5 and all of their multiples (the 30-wheel)

In both, surviving integers are walked in order, assigned a NEW position, and
their primality (in the original integers) is counted against the dyadic block
that new position falls in.  So the counts are the same primes, re-blocked.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--rmax 22, --dmax 8 and --lim 20000000 are the old module-level constants — so
a no-flag run prints exactly what the original run printed and prior
transcripts remain fully comparable.  The excised set {2, 3, 5} stays inline
in both variants: it is the object of the test.  The run now also writes the
house envelope (CONTEXT.md § "Output schema") to
results/excise_scaffold_primes.json, honouring --out, --no-json and
--results-dir; paths are anchored to _HERE so the run is cwd-independent.

--rmax and --lim are COUPLED: variant B fills 2^rmax positions from 30-wheel
totatives, walking the number line to about 2^rmax * 30/8, and every walked
value indexes the sieve.  The script computes the exact walk bound up front
and refuses to start if it exceeds --lim, naming the --lim that would be
required.  At the default lim of 2e7 the ceiling is rmax = 22; rmax = 23
already needs lim >= 31,457,279.

HOW IT WAS RUN
--------------
    python3 O31_excise_scaffold_primes.py

No flags: the defaults reproduce the original 2026-08-17 run exactly, plus the
results JSON.  See --rmax, --dmax, --lim, --results-dir, --out, --no-json.

REQUIREMENTS
------------
    stdlib only
"""

import argparse
import datetime
import hashlib
import json
import math
import os
import sys

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "excise_scaffold_primes.json")

# 30-wheel totatives (v = 1 is also kept by variant B's predicate)
_TOTATIVES_30 = (1, 7, 11, 13, 17, 19, 23, 29)


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


def _required_walk_bound(npos):
    """Largest integer either variant must walk to (and sieve-index).

    Variant A keeps everything except the three integers 2, 3, 5, so it walks
    to at most npos + 3.  Variant B keeps v = 1 and the 30-wheel totatives —
    8 survivors per block of 30 — so filling npos positions walks to exactly
    the npos-th kept value.
    """
    full, rem = divmod(npos, 8)
    if rem == 0:
        wheel_bound = 30 * (full - 1) + _TOTATIVES_30[-1]
    else:
        wheel_bound = 30 * full + _TOTATIVES_30[rem - 1]
    return max(npos + 3, wheel_bound)


def _parse_args():
    ap = argparse.ArgumentParser(
        description=("O31 - excise the scaffold primes 2, 3, 5, close the "
                     "number line up, and ask whether the dyadic table's "
                     "exact zeros survive. EXPLORATORY: no prereg, no "
                     "decision rule, no verdict."))
    ap.add_argument("--rmax", type=int, default=22,
                    help="ladder top: rows r = 1..RMAX (default 22). COUPLED "
                         "to --lim: variant B fills 2^rmax positions from "
                         "30-wheel totatives, walking to about 2^rmax * 30/8, "
                         "which must not exceed --lim")
    ap.add_argument("--dmax", type=int, default=8,
                    help="deepest difference depth d = 0..DMAX (default 8)")
    ap.add_argument("--lim", type=int, default=20_000_000,
                    help="sieve limit (default 20000000). COUPLED to --rmax: "
                         "must cover variant B's walk bound of about "
                         "2^rmax * 30/8; the script checks the exact bound "
                         "before any work and exits naming the required lim "
                         "if it falls short")
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
NPOS = 2**RMAX
LIM = args.lim

# Validate the rmax/lim coupling BEFORE any work: variant B walks the number
# line to the NPOS-th 30-wheel survivor and indexes the sieve at every step.
_walk_bound = _required_walk_bound(NPOS)
if _walk_bound > LIM:
    sys.exit(f"ERROR: --rmax {RMAX} requires walking the number line to "
             f"{_walk_bound:,} (variant B fills 2^rmax = {NPOS:,} positions "
             f"from 30-wheel totatives, about NPOS*30/8), which exceeds "
             f"--lim {LIM:,} and would index past the sieve. "
             f"Re-run with --lim >= {_walk_bound}.")

def sieve(n):
    s = bytearray([1])*(n+1); s[0]=s[1]=0
    i=2
    while i*i<=n:
        if s[i]: s[i*i::i]=bytearray(len(s[i*i::i]))
        i+=1
    return s

def build(N):
    n=len(N); T=[[None]*(n+1) for _ in range(DMAX+1)]
    for r in range(1,n+1): T[0][r]=N[r-1]
    for d in range(1,DMAX+1):
        for r in range(d+1,n+1):
            if T[d-1][r] is not None and T[d-1][r-1] is not None:
                T[d][r]=T[d-1][r]-T[d-1][r-1]
    return T

def show(T,title,n):
    print("\n"+title)
    print("   r"+"".join(f"{'d'+str(d):>9}" for d in range(DMAX+1)))
    for r in range(1,n+1):
        row=f"{r:>4}"
        for d in range(DMAX+1):
            v=T[d][r] if r<len(T[d]) else None
            row+="         " if v is None else f"{v:>9}"
        print(row)
    zs=[(r,d) for d in range(DMAX+1) for r in range(1,n+1)
        if r<len(T[d]) and T[d][r]==0]
    print("  zeros:",sorted(zs,key=lambda t:(t[0],t[1])))

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

def counts(keep, isp, need):
    """walk values, keep those passing 'keep', record primality by NEW position"""
    N=[0]*RMAX; pos=0; v=0; r=1; bound=2
    while pos<need:
        v+=1
        if not keep(v): continue
        pos+=1
        while pos>bound: r+=1; bound=2**r
        if isp[v]: N[r-1]+=1
    return N

isp=sieve(LIM)

# A: delete only the integers 2,3,5; line closes up
gone={2,3,5}
A=counts(lambda v: v not in gone, isp, NPOS)
print("A depth-0:",A[:10],"...")
T_A = build(A)
show(T_A,"A - integers 2,3,5 excised, line closed up",RMAX)

# B: delete 2,3,5 and all their multiples (30-wheel); line closes up
B=counts(lambda v: v==1 or (v%2 and v%3 and v%5), isp, NPOS)
print("\nB depth-0:",B[:10],"...")
T_B = build(B)
show(T_B,"B - 2,3,5 and all multiples excised, line closed up",RMAX)

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
            "lim": LIM,
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "excised_set": [2, 3, 5],
            "excised_set_note": ("The excised set {2, 3, 5} is inline by "
                                 "design: it is the object of the test."),
            "npos": NPOS,
            "walk_bound": _walk_bound,
            "variants": {
                "A": "delete only the integers 2, 3, 5; line closes up",
                "B": "delete 2, 3, 5 and all their multiples (30-wheel); "
                     "line closes up",
            },
            "construction": "T(r,d) = T(r,d-1) - T(r-1,d-1) on the "
                            "re-blocked prime counts",
        },
        "summary": {
            "A_zeros": _zeros(T_A, RMAX),
            "B_zeros": _zeros(T_B, RMAX),
            "A_depth0": A,
            "B_depth0": B,
        },
        "rows": _rows(T_A, "A", RMAX) + _rows(T_B, "B", RMAX),
    }
    _write_results(payload, args.out)
