"""
O35 — NEAR-MISS cells: at eight table cells that come close to zero but do not hit
      it, compare the cell value, the true residual (pi minus Riemann R, run through
      the same difference construction) and the zero-built model, and report the
      fraction of the residual the zeros explain.

Reads with: O34_zeta_residual_model.py (the same explicit-formula model, at r = 20
only); O16_centered_difference_table.py and O27_joint_dyadic_triadic_table.py (the
backward-difference table and its exact zeros); O29_depth_residuals.py (li vs R).

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
Three triangles are built on r = 1..RMAX (default 45) from the same
backward-difference recursion T(r,d) = T(r,d-1) - T(r-1,d-1), differing only in
the depth-0 row:

    Tpi   from exact counts pi(2^r) via primecountpy.prime_pi
    TR    from the Riemann R function riemannr(2^r)
    To    from the zero-built oscillating part, NZ pairs per the --nz sweep
          (default 200, 600)

At each of the cells in --cells (default the eight near-miss cells

    (15,4) (17,5) (20,6) (22,6) (24,7) (25,21) (37,12) (39,14)

) it prints the cell value Tpi, the true residual Tpi - TR, the model To, and the
fraction To/(Tpi - TR).  A fraction near 1 means the zeros account for the whole
residual at that cell; the sweep over 200 vs 600 pairs shows whether the fraction
is converging or still moving with truncation.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--dps 60, --rmax 45, --nz 200,600 and the --cells default
15,4;17,5;20,6;22,6;24,7;25,21;37,12;39,14 are the old module-level
constants — so a no-flag run prints exactly what the original run printed and
prior transcripts remain fully comparable.  The run now also writes the house
envelope (CONTEXT.md § "Output schema") to results/nearmiss_residuals.json,
honouring --out, --no-json and --results-dir; paths are anchored to _HERE so
the run is cwd-independent.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O35_nearmiss_residuals.py

No flags: the defaults reproduce the original 2026-08-17 run exactly, plus the
results JSON.  See --dps, --rmax, --nz, --cells, --results-dir, --out,
--no-json.

REQUIREMENTS
------------
    pip install mpmath primecountpy
"""
import argparse
import datetime
import hashlib
import json
import math
import os

from mpmath import mp, mpf, mpc, zetazero, ei, log, re, riemannr
from primecountpy import prime_pi

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "nearmiss_residuals.json")
DEFAULT_CELLS = "15,4;17,5;20,6;22,6;24,7;25,21;37,12;39,14"


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


def _parse_cells(s):
    out = []
    for tok in s.split(";"):
        tok = tok.strip()
        if not tok:
            continue
        r, d = tok.split(",")
        out.append((int(r), int(d)))
    return out


def _parse_args():
    ap = argparse.ArgumentParser(
        description=("O35 - at the near-miss cells, compare the cell value, "
                     "the true residual (pi minus Riemann R) and the "
                     "zero-built model, and report the fraction the zeros "
                     "explain. EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--dps", type=int, default=60,
                    help="mpmath working precision (default 60)")
    ap.add_argument("--rmax", type=int, default=45,
                    help="ladder top: triangles on r = 1..RMAX (default 45)")
    ap.add_argument("--nz", type=str, default="200,600",
                    help="comma list of zero-pair truncations to sweep "
                         "(default 200,600)")
    ap.add_argument("--cells", type=str, default=DEFAULT_CELLS,
                    help="semicolon list of r,d cells to report (default "
                         f"{DEFAULT_CELLS})")
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
mp.dps = args.dps
R = args.rmax
CELLS = _parse_cells(args.cells)
NZ_SWEEP = _parse_nz(args.nz)

def tri(vals):                      # vals[r] for r=0..R
    N = [vals[r]-vals[r-1] for r in range(1,R+1)]
    T = {(r,0): N[r-1] for r in range(1,R+1)}
    for d in range(1,R):
        for r in range(d+1,R+1):
            T[(r,d)] = T[(r,d-1)] - T[(r-1,d-1)]
    return T

pi_v = [mpf(0)] + [mpf(prime_pi(2**r)) for r in range(1,R+1)]
R_v  = [mpf(1)] + [riemannr(mpf(2)**r)  for r in range(1,R+1)]
Tpi, TR = tri(pi_v), tri(R_v)

_rows = []
for NZ in NZ_SWEEP:
    rho = [mpc(mpf('0.5'), zetazero(n).imag) for n in range(1,NZ+1)]
    osc = [mpf(0)]
    for r in range(1,R+1):
        L = log(mpf(2)**r); t = mpf(0)
        for r_ in rho: t -= 2*re(ei(r_*L))
        osc.append(t)
    To = tri(osc)
    print(f"\n=== {NZ} zero pairs ===")
    print(f"{'cell':>10}{'value':>14}{'true resid':>16}{'from zeros':>16}{'frac':>9}")
    for (r,d) in CELLS:
        cell = Tpi[(r,d)]; res = cell - TR[(r,d)]; mod = To[(r,d)]
        frac = mod/res if res != 0 else mpf('nan')
        print(f"  ({r:>2},{d:>2}){mp.nstr(cell,8):>14}{mp.nstr(res,8):>16}{mp.nstr(mod,8):>16}{mp.nstr(frac,4):>9}")
        _rows.append({"nz": NZ, "r": r, "d": d,
                      "value": float(cell), "true_resid": float(res),
                      "from_zeros": float(mod),
                      "frac": (None if not math.isfinite(float(frac))
                               else float(frac))})

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
            "rmax": R,
            "nz": NZ_SWEEP,
            "cells": [[r, d] for r, d in CELLS],
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "triangles": {
                "Tpi": "exact counts pi(2^r) via primecountpy.prime_pi",
                "TR": "Riemann R function riemannr(2^r)",
                "To": "zero-built oscillating part, "
                      "-sum over rho of 2*Re(Ei(rho*log x))",
            },
            "recursion": "T(r,d) = T(r,d-1) - T(r-1,d-1)",
        },
        "summary": {
            "frac_by_cell_by_nz": {
                str(NZ): {f"({row['r']},{row['d']})": row["frac"]
                          for row in _rows if row["nz"] == NZ}
                for NZ in NZ_SWEEP},
        },
        "rows": _rows,
    }
    _write_results(payload, args.out)
