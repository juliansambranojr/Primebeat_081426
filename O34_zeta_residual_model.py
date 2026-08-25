"""
O34 — MODELLING the dyadic table's residual from the zeta zeros: build the
      oscillating part of pi(x) from the first NZ zero pairs, run it through the
      same backward-difference construction as the table, and ask how much of the
      true residual at r = 20 it reproduces as depth grows.

Reads with: O16_centered_difference_table.py and O27_joint_dyadic_triadic_table.py
(the backward-difference construction and its exact zero set {(2,1), (4,1), (8,3),
(20,6)}); O29_depth_residuals.py (the li-vs-R residual decay with depth).  Companion
to O35_nearmiss_residuals.py, which asks the same question at the near-miss cells.

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
For each truncation NZ in the --nz list (default 50, 200, 500 zero pairs) it forms

    osc(x) = - sum over rho of 2*Re( Ei(rho * log x) ),   rho = 1/2 + i*gamma_n

evaluates it at x = 2^r for r = 0..RMAX (default 22), differences to get a depth-0
block row, and builds the triangle T(r,d) = T(r,d-1) - T(r-1,d-1).  It then prints,
for depths d = 0..6 at r = 20, the hardcoded true residual TRUE_RES_R20 alongside
the zero-built model value, their difference and their ratio, plus the model's value
at the four exact-zero cells (2,1), (4,1), (8,3), (20,6).

The ratio column is the quantity of interest: whether the zero sum accounts for a
stable fraction of the residual as depth increases, and whether that fraction
converges as more zero pairs are added.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--dps 40, --rmax 22 and --nz 50,200,500 are the old inline constants — so a
no-flag run prints exactly what the original run printed and prior transcripts
remain fully comparable.  TRUE_RES_R20 stays a literal list of seven strings
transcribed from an earlier run: the literals are row-20 objects computed at
dps 40, so the script requires --rmax >= 20 and warns in the --dps help that
varying dps breaks comparability with them.  Zeros come from mpmath.zetazero
directly, uncached, as in the original run.  The run now also writes the house
envelope (CONTEXT.md § "Output schema") to results/zeta_residual_model.json,
honouring --out, --no-json and --results-dir; paths are anchored to _HERE so
the run is cwd-independent.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O34_zeta_residual_model.py

No flags: the defaults reproduce the original 2026-08-17 run exactly, plus the
results JSON.  See --dps, --rmax, --nz, --results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install mpmath
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import sys

from mpmath import mp, mpf, mpc, zetazero, ei, log, re

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "zeta_residual_model.json")


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


def _parse_nz(s):
    out = []
    for tok in s.split(","):
        tok = tok.strip()
        if tok:
            out.append(int(tok))
    return out


def _parse_args():
    ap = argparse.ArgumentParser(
        description=("O34 - model the dyadic table's residual at r = 20 from "
                     "the first NZ zeta-zero pairs, through the same "
                     "backward-difference construction. EXPLORATORY: no "
                     "prereg, no decision rule, no verdict."))
    ap.add_argument("--dps", type=int, default=40,
                    help="mpmath working precision (default 40). The "
                         "TRUE_RES_R20 literals were computed at dps 40; "
                         "varying dps breaks comparability with them")
    ap.add_argument("--rmax", type=int, default=22,
                    help="ladder top: x = 2^r for r = 0..RMAX (default 22). "
                         "Must be >= 20: the TRUE_RES_R20 literals are "
                         "row-20 objects")
    ap.add_argument("--nz", type=str, default="50,200,500",
                    help="comma list of zero-pair truncations to sweep "
                         "(default 50,200,500)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    args = ap.parse_args()
    if args.rmax < 20:
        ap.error(f"--rmax {args.rmax} is below 20: the TRUE_RES_R20 literals "
                 "are row-20 objects and the comparison needs r = 20 in the "
                 "triangle. Use --rmax >= 20.")
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))
    return args


args = _parse_args()
_started = datetime.datetime.now(datetime.timezone.utc)
mp.dps = args.dps
RMAX = args.rmax
NZ_SWEEP = _parse_nz(args.nz)

TRUE_RES_R20 = [mpf(v) for v in
    ('-24.886','-48.190','-82.086','-133.761','-212.314','-322.410','-453.424')]

def osc(x, rho):
    """oscillating part of pi(x): -sum over zero pairs of 2*Re(li(x^rho))"""
    L = log(mpf(x)); t = mpf(0)
    for r_ in rho:
        t -= 2*re(ei(r_*L))
    return t

def triangle(vals):
    N = [vals[r]-vals[r-1] for r in range(1, RMAX+1)]
    T = {(r,0): N[r-1] for r in range(1, RMAX+1)}
    for d in range(1, RMAX):
        for r in range(d+1, RMAX+1):
            T[(r,d)] = T[(r,d-1)] - T[(r-1,d-1)]
    return T

_rows = []
for NZ in NZ_SWEEP:
    rho = [mpc(mpf('0.5'), zetazero(n).imag) for n in range(1, NZ+1)]
    T = triangle([osc(2**r, rho) for r in range(0, RMAX+1)])
    print(f"\n--- {NZ} zero pairs ---")
    print(f"{'d':>3}{'true resid':>13}{'from zeros':>14}{'diff':>11}{'ratio':>8}")
    for d in range(0, 7):
        m = T[(20,d)]; t = TRUE_RES_R20[d]
        print(f"{d:>3}{mp.nstr(t,7):>13}{mp.nstr(m,7):>14}{mp.nstr(m-t,4):>11}{mp.nstr(m/t,4):>8}")
        _rows.append({"nz": NZ, "d": d, "r": 20,
                      "true_resid": float(t), "from_zeros": float(m),
                      "diff": float(m-t), "ratio": float(m/t)})
    print("  model at the four zero cells (true residual there is what cancels the smooth part):")
    print("   ", "  ".join(f"({r},{d})={mp.nstr(T[(r,d)],6)}" for r,d in ((2,1),(4,1),(8,3),(20,6))))
    for r, d in ((2,1),(4,1),(8,3),(20,6)):
        _rows.append({"nz": NZ, "d": d, "r": r, "true_resid": None,
                      "from_zeros": float(T[(r,d)]), "diff": None,
                      "ratio": None, "zero_cell": True})

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
            "dps": args.dps,
            "rmax": RMAX,
            "nz": NZ_SWEEP,
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "true_res_r20": [float(v) for v in TRUE_RES_R20],
            "true_res_r20_note": ("Literal strings transcribed from an "
                                  "earlier run at dps 40; row-20 objects, "
                                  "depths d = 0..6."),
            "model": "osc(x) = -sum over rho of 2*Re(Ei(rho*log x)), "
                     "rho = 1/2 + i*gamma_n via mpmath.zetazero, uncached",
            "zero_cells": [[2, 1], [4, 1], [8, 3], [20, 6]],
        },
        "summary": {
            "ratio_at_r20_by_nz": {
                str(NZ): {str(row["d"]): row["ratio"] for row in _rows
                          if row["nz"] == NZ and not row.get("zero_cell")}
                for NZ in NZ_SWEEP},
        },
        "rows": _rows,
    }
    _write_results(payload, args.out)
