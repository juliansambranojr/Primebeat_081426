#!/usr/bin/env python3
"""
O29 — Depth residuals: subtract the SAME (d+1)-fold backward difference of a
      smooth model from every cell of the exact prime difference table, for
      base 2 and base 3, depths 0..6, over each base's own full ladder.

Reads with: O27_joint_dyadic_triadic_table.py (the exact-integer backward
difference table and its first-block convention — REUSED VERBATIM);
O17_disjoint_block_residual.py (the li / Riemann-R smooth models and the
"difference in mpf, cast to float only afterwards" discipline — REUSED
VERBATIM); `pi2n_cache.json` and `pi3n_cache.json` (both READ ONLY).
CONTEXT.md § "Core quantities" defines e(r) = c_n - (li(2^n) - li(2^(n-1))),
which is exactly the d = 0 row of this script's dyadic li residual.

NAMING
------
The O-series in this tree runs O1-O9 and O11-O27.  There is NO O10: that
number is a known, DELIBERATE GAP and this script does not fill it.  O28 is
also unoccupied at the time of writing; this file was assigned the number O29
by its brief and takes it rather than silently renumbering itself into O28,
because quietly closing a gap rewrites the series' history.  Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

STATUS
------
EXPLORATORY.  There is no prereg for this script, no hypothesis, and no
decision rule.  It emits residual tables and a precision audit; it does not
return a verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script
prints may be described as a verdict.

=============================================================================
WHAT IS COMPUTED
=============================================================================

For base b in {2, 3}, row r, depth d:

    cell(r, d)      the exact prime difference-table cell — the (d+1)-fold
                    BACKWARD difference of pi evaluated on the ladder b^r,
                    built exactly as O27 builds it:
                        T[0][r] = pi(b^r) - pi(b^(r-1))
                        T[d][r] = T[d-1][r] - T[d-1][r-1]
                    exact Python int, support r = d+1 .. R.

    smooth(r, d)    the SAME operator applied to a smooth model M:
                        S[0][r] = M(b^r) - M(b^(r-1))
                        S[d][r] = S[d-1][r] - S[d-1][r-1]
                    carried in mpf at mp.dps throughout — never rounded to
                    float before differencing.

    residual(r, d)  = cell(r, d) - smooth(r, d)

Two smooth models, both taken from O17 without modification:

    M = li   ordinary logarithmic integral
    M = R    Riemann's R(x) = sum_{n>=1} mu(n)/n li(x^(1/n))
             = li(x) - (1/2)li(sqrt(x)) - (1/3)li(x^(1/3)) - ...
             `mpmath.riemannr` when available, else O17's explicit Mobius sum.
             Which one was used is recorded in params.riemannr_impl.

FIRST-BLOCK ANCHOR — a documented CHOICE, not a derivation
----------------------------------------------------------
O27's convention is pi(1) = 0, so the depth-0 prime row starts at
N_b(1) = pi(b) - pi(1) = pi(b).  The smooth models do not extend to x = 1 in
any agreed way: li(1) = -infinity (a genuine singularity) and R(1) = 1.  This
script therefore ANCHORS both smooth models at

    M(b^0) = M(1) := 0

so the smooth depth-0 row mirrors the prime depth-0 row exactly.  The anchor
is arbitrary and it is NOT hidden: the only cells that depend on it are the
LEADING DIAGONAL r = d+1 (a cell at (r, d) reads depth-0 rows r-d .. r, and
row 1 enters only when r <= d+1).  Those cells are flagged
`anchor_dependent: true` in the JSON, marked with a trailing `*` in the
console table, and listed in summary.anchor_dependent_cells.  Every other
cell is anchor-free.

=============================================================================
PRECISION — the part that can actually go wrong
=============================================================================

A 7-fold difference of a quantity of size ~1e17 is a cancellation that
destroys many significant digits.  Two defences, both mandatory:

 1. The smooth values are carried as mpf at mp.dps = --dps (default 120) and
    differenced AT THAT PRECISION.  Nothing is cast to float until the
    residual is finished.

 2. VERIFICATION PASS.  The whole computation is repeated at
    mp.dps = --verify-dps (default 200) and the two sets of residuals are
    compared cell by cell.  The maximum absolute disagreement is reported.
    Any cell whose two passes disagree by more than --precision-tol
    (default 1e-6) is UNTRUSTWORTHY: it is flagged `trusted: false` in the
    JSON, written as the literal string `UNTRUSTWORTHY` in the CSV, and
    excluded from the reported trustworthy (r, d) envelope.  It is never
    presented as a number.

    Disagreement is measured in ABSOLUTE terms because the residual is a
    count residual — it lives on the same scale as a prime count, and a
    relative tolerance would silently pass a large cell.

RANGE
-----
Each base runs its OWN full ladder.  The dyadic side is NOT truncated to the
triadic one; the two r_max values are reported separately and the difference
is stated.  r = 1 .. (contiguous cache maximum), depths d = 0 .. --max-depth
(default 6).  pi() is read from the caches only — this script never calls
primecountpy and never writes a cache.

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params, constants,
summary, rows.  `params.code_version` is the sha256 of THIS file, read from
`__file__` at runtime.

USAGE
-----
    python3 O29_depth_residuals.py
    python3 O29_depth_residuals.py --dps 150 --verify-dps 250 --max-depth 6
"""

import argparse
import hashlib
import json
import math
import os
import sys
from datetime import datetime, timezone

try:
    import mpmath
    from mpmath import mp
except ImportError:
    raise ImportError(
        "mpmath is required and is NOT optional for this script: the smooth "
        "term is differenced (d+1) times and that is a cancellation with no "
        "float fallback. Install with: pip install mpmath")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]

DEFAULT_CACHE_DYADIC = os.path.join(_HERE, "pi2n_cache.json")
DEFAULT_CACHE_TRIADIC = os.path.join(_HERE, "pi3n_cache.json")
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "depth_residuals.json")

BASE_DYADIC = 2
BASE_TRIADIC = 3

# Smooth-model backend detection, done ONCE at import — identical to O17.
_HAS_RIEMANNR = hasattr(mpmath, "riemannr")
RIEMANNR_IMPL = "mpmath.riemannr" if _HAS_RIEMANNR else "mobius_sum"

SMOOTH_MODELS = ("R", "li")

# CSV filenames, one per (model, base). New names only; nothing existing in
# results/ is touched.
CSV_NAMES = {
    ("R", "dyadic"): "depth_residuals_dyadic.csv",
    ("R", "triadic"): "depth_residuals_triadic.csv",
    ("li", "dyadic"): "depth_residuals_li_dyadic.csv",
    ("li", "triadic"): "depth_residuals_li_triadic.csv",
}

UNTRUSTWORTHY = "UNTRUSTWORTHY"

FIRST_BLOCK_CONVENTION = (
    "pi(1) = 0 (1 is neither prime nor composite). Block r covers the "
    "half-open interval (b^(r-1), b^r], so block 1 is (1, b] and excludes 1. "
    "Hence N_2(1) = pi(2) = 1 and N_3(1) = pi(3) = 2.")

SMOOTH_ANCHOR_NOTE = (
    "M(b^0) = M(1) := 0 for BOTH smooth models, mirroring pi(1) = 0. This is "
    "a CHOICE: li(1) = -infinity and R(1) = 1, so neither model extends to "
    "x = 1 naturally. Only the leading diagonal r = d+1 depends on it; those "
    "cells are flagged anchor_dependent.")


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


def _write_text(text, out_path, label):
    """Write a text artifact; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            fh.write(text)
        print(f"  {label} written to {out_path}", flush=True)
    except Exception as exc:
        print(f"  WARNING: could not write {label} to {out_path}: {exc}",
              flush=True)


# ---------------------------------------------------------------------------
# caches — READ ONLY (O27's loader, unchanged)
# ---------------------------------------------------------------------------

def load_cache(path):
    """Read a {n: pi(b^n)} JSON cache. Missing file -> empty dict."""
    if not os.path.exists(path):
        return {}
    with open(path, "r") as fh:
        raw = json.load(fh)
    return {int(k): int(v) for k, v in raw.items()}


def contiguous_from_zero(cache):
    """Largest R such that n = 0..R are all present. -1 if 0 is absent."""
    if 0 not in cache:
        return -1
    R = 0
    while (R + 1) in cache:
        R += 1
    return R


# ---------------------------------------------------------------------------
# table construction — O27's, unchanged
# ---------------------------------------------------------------------------

def counts(cache, R):
    """N_b(r) = pi(b^r) - pi(b^(r-1)) for r = 1..R. Exact ints."""
    return {r: cache[r] - cache[r - 1] for r in range(1, R + 1)}


def backward_table(seq, R, max_depth):
    """
    T[0][r] = seq[r] for r = 1..R;
    T[d][r] = T[d-1][r] - T[d-1][r-1], support r = d+1..R.
    Returns {depth: {r: value}}. Cells outside the support are simply absent —
    never zero-padded. Type-agnostic: exact int for the prime table, mpf for
    the smooth table, and IDENTICAL arithmetic in both cases.
    """
    tab = {0: {r: seq[r] for r in range(1, R + 1)}}
    dmax = R - 1
    if max_depth is not None:
        dmax = min(dmax, max_depth)
    for d in range(1, dmax + 1):
        prev = tab[d - 1]
        tab[d] = {r: prev[r] - prev[r - 1] for r in range(d + 1, R + 1)}
    return tab


# ---------------------------------------------------------------------------
# smooth models — O17's, unchanged
# ---------------------------------------------------------------------------

def _mobius_table(nmax):
    """mu(n) for n = 0..nmax by a small linear sieve. mu[0] unused, set 0."""
    nmax = max(int(nmax), 1)
    mu = [1] * (nmax + 1)
    mu[0] = 0
    is_comp = [False] * (nmax + 1)
    for p in range(2, nmax + 1):
        if is_comp[p]:
            continue
        for m in range(p, nmax + 1, p):
            if m != p:
                is_comp[m] = True
            mu[m] = -mu[m]
        pp = p * p
        for m in range(pp, nmax + 1, pp):
            mu[m] = 0
    return mu


def _riemann_r_mobius(x, nmax_cap=200):
    """
    R(x) = sum_{n=1}^{nmax} mu(n)/n * li(x^(1/n)), truncated where x^(1/n) < 2.
    Fallback used only when mpmath.riemannr is unavailable. Caller sets mp.dps.
    """
    xm = mpmath.mpf(x)
    if xm < 2:
        return mpmath.mpf(0)
    nmax = int(mpmath.floor(mpmath.log(xm) / mpmath.log(2)))
    nmax = max(1, min(nmax, int(nmax_cap)))
    mu = _mobius_table(nmax)
    total = mpmath.mpf(0)
    for n in range(1, nmax + 1):
        if mu[n] == 0:
            continue
        root = xm ** (mpmath.mpf(1) / n)
        if root < 2:
            continue
        total += mpmath.mpf(int(mu[n])) / n * mpmath.li(root)
    return total


def riemannr_at(x):
    """R(x) via whichever backend this mpmath supports. Caller sets mp.dps."""
    if _HAS_RIEMANNR:
        return mpmath.riemannr(mpmath.mpf(x))
    return _riemann_r_mobius(x)


def smooth_at(model, x):
    """M(x) for the named model. Caller sets mp.dps. x is an exact Python int."""
    if model == "li":
        return mpmath.li(mpmath.mpf(x))
    if model == "R":
        return riemannr_at(x)
    raise SystemExit(f"unknown smooth model {model!r}")


def smooth_ladder_values(model, base, R, dps):
    """
    M(b^r) for r = 0..R at mp.dps = dps, as mpf. r = 0 is ANCHORED at 0 (see
    SMOOTH_ANCHOR_NOTE) because neither model extends to x = 1 naturally.
    b^r is formed as an EXACT Python int and handed to mpf, so the argument
    carries no rounding of its own.
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        vals = {0: mpmath.mpf(0)}
        for r in range(1, R + 1):
            vals[r] = smooth_at(model, base ** r)
        return vals
    finally:
        mp.dps = old


def smooth_table(model, base, R, dmax, dps):
    """
    The SAME backward-difference operator as the prime table, applied to M.
    Depth-0 row S[0][r] = M(b^r) - M(b^(r-1)); then differenced down
    identically. All arithmetic at mp.dps = dps in mpf — nothing is cast to
    float here.
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        vals = smooth_ladder_values(model, base, R, dps)
        row0 = {r: vals[r] - vals[r - 1] for r in range(1, R + 1)}
        return backward_table(row0, R, dmax)
    finally:
        mp.dps = old


def residual_table(prime_tab, smooth_tab, R, dmax, dps):
    """
    residual(r, d) = cell(r, d) - smooth(r, d), computed in mpf at mp.dps so
    the exact integer cell is subtracted at full precision. Returns
    {depth: {r: mpf}}.
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        out = {}
        for d in range(0, dmax + 1):
            pd = prime_tab.get(d, {})
            sd = smooth_tab.get(d, {})
            out[d] = {r: mpmath.mpf(pd[r]) - sd[r]
                      for r in sorted(pd) if r in sd}
        return out
    finally:
        mp.dps = old


# ---------------------------------------------------------------------------
# rendering
# ---------------------------------------------------------------------------

def _cell_str(v, p=6):
    """Fixed-point cell text for the CSV; None -> empty; flagged -> literal."""
    if v is None:
        return ""
    if isinstance(v, str):
        return v
    return format(float(v), f".{p}f")


def render_csv(res, trust, R, dmax, p=6):
    """
    CSV with columns r, d0..dmax. Blank = the cell does not exist (r < d+1).
    A cell that failed the precision check is written as the literal string
    UNTRUSTWORTHY rather than as a number.
    """
    head = "r," + ",".join(f"d{d}" for d in range(0, dmax + 1))
    lines = [head]
    for r in range(1, R + 1):
        cells = []
        for d in range(0, dmax + 1):
            v = res.get(d, {}).get(r)
            if v is None:
                cells.append("")
            elif not trust.get((r, d), True):
                cells.append(UNTRUSTWORTHY)
            else:
                cells.append(_cell_str(v, p))
        lines.append(str(r) + "," + ",".join(cells))
    return "\n".join(lines) + "\n"


def print_table(title, res, trust, R, dmax, anchor_diag, p=3, rmax_print=None):
    """Console residual table, rounded to p decimals for DISPLAY only."""
    rr = R if rmax_print is None else min(R, rmax_print)
    print("\n" + "-" * 78, flush=True)
    print(title, flush=True)
    print("-" * 78, flush=True)
    cols = [["r"] + [str(i) for i in range(1, rr + 1)]]
    for d in range(0, dmax + 1):
        col = [f"d{d}"]
        for r in range(1, rr + 1):
            v = res.get(d, {}).get(r)
            if v is None:
                col.append("")
            elif not trust.get((r, d), True):
                col.append("UNTRUST")
            else:
                s = format(float(v), f".{p}f")
                if anchor_diag and r == d + 1:
                    s += "*"
                col.append(s)
        cols.append(col)
    widths = [max(len(s) for s in col) for col in cols]
    for i in range(0, rr + 1):
        print("  " + "  ".join(c[i].rjust(w) for c, w in zip(cols, widths)),
              flush=True)
    print("  values ROUNDED TO %d DECIMALS FOR DISPLAY ONLY; the CSV and JSON "
          "carry more." % p, flush=True)
    if anchor_diag:
        print("  * = leading diagonal r = d+1, depends on the M(1) := 0 anchor.",
              flush=True)


# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="O29 — depth residuals: exact prime difference-table cell "
                    "minus the same (d+1)-fold difference of a smooth model, "
                    "for base 2 and base 3, with a precision verification pass")
    ap.add_argument("--cache-dyadic", type=str, default=DEFAULT_CACHE_DYADIC,
                    help="pi(2^n) cache JSON, READ ONLY "
                         f"(default: {DEFAULT_CACHE_DYADIC})")
    ap.add_argument("--cache-triadic", type=str, default=DEFAULT_CACHE_TRIADIC,
                    help="pi(3^n) cache JSON, READ ONLY "
                         f"(default: {DEFAULT_CACHE_TRIADIC})")
    ap.add_argument("--rmax-dyadic", type=int, default=None,
                    help="cap r on the dyadic base (default: the full "
                         "contiguous range in its cache)")
    ap.add_argument("--rmax-triadic", type=int, default=None,
                    help="cap r on the triadic base (default: the full "
                         "contiguous range in its cache). The two bases are "
                         "NOT truncated to a common r_max.")
    ap.add_argument("--max-depth", type=int, default=6,
                    help="maximum difference depth d (default 6, i.e. d = 0..6)")
    ap.add_argument("--dps", type=int, default=120,
                    help="mpmath decimal precision for the MAIN pass "
                         "(default 120; the script refuses to run below 60)")
    ap.add_argument("--verify-dps", type=int, default=200,
                    help="mpmath decimal precision for the VERIFICATION pass "
                         "(default 200; must exceed --dps)")
    ap.add_argument("--precision-tol", type=float, default=1e-6,
                    help="a residual whose two passes disagree by more than "
                         "this ABSOLUTE amount is flagged UNTRUSTWORTHY and is "
                         "not presented as a number (default 1e-6)")
    ap.add_argument("--csv-decimals", type=int, default=6,
                    help="decimals written per CSV cell (default 6)")
    ap.add_argument("--print-rmax", type=int, default=None,
                    help="print only the first this-many rows on the console "
                         "(default: all)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help=f"directory for the CSVs (default: {DEFAULT_RESULTS_DIR})")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help=f"results JSON path (default: {DEFAULT_OUT_JSON})")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    ap.add_argument("--no-csv", action="store_true",
                    help="skip writing the CSVs")
    args = ap.parse_args()

    dps = int(args.dps)
    vdps = int(args.verify_dps)
    if dps < 60:
        raise SystemExit(f"--dps {dps} is below the required minimum of 60; a "
                         "7-fold difference of a ~1e17 quantity is a "
                         "cancellation and needs the precision. Refusing.")
    if vdps <= dps:
        raise SystemExit(f"--verify-dps {vdps} must EXCEED --dps {dps}; a "
                         "verification pass at the same precision verifies "
                         "nothing. Refusing.")
    tol = float(args.precision_tol)
    if not (math.isfinite(tol) and tol > 0.0):
        raise SystemExit(f"--precision-tol {tol} must be finite and > 0")

    started = datetime.now(timezone.utc)

    print("=" * 78, flush=True)
    print("O29 — depth residuals  (EXPLORATORY: no prereg, no verdict)",
          flush=True)
    print("=" * 78, flush=True)
    print("  cell(r,d)     = Delta^(d+1) pi at b^r          exact Python int",
          flush=True)
    print("  smooth(r,d)   = the SAME operator applied to M  mpf at mp.dps",
          flush=True)
    print("  residual(r,d) = cell(r,d) - smooth(r,d)", flush=True)
    print(f"  smooth models : {', '.join(SMOOTH_MODELS)}   "
          f"(R implementation: {RIEMANNR_IMPL})", flush=True)
    print(f"  FIRST BLOCK   : {FIRST_BLOCK_CONVENTION}", flush=True)
    print(f"  SMOOTH ANCHOR : {SMOOTH_ANCHOR_NOTE}", flush=True)
    print(f"  main dps = {dps}   verification dps = {vdps}   "
          f"tolerance = {tol:g} (absolute)", flush=True)
    print(f"  python {sys.version.split()[0]} / mpmath {mpmath.__version__}",
          flush=True)

    # ---------------- caches (READ ONLY) ------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("CACHES  (READ ONLY — this script never calls primecountpy and never "
          "writes a cache)", flush=True)
    print("-" * 78, flush=True)
    bases = []
    caches_meta = {}
    for label, base, path, cap in (
            ("dyadic", BASE_DYADIC, args.cache_dyadic, args.rmax_dyadic),
            ("triadic", BASE_TRIADIC, args.cache_triadic, args.rmax_triadic)):
        cache = load_cache(path)
        R_avail = contiguous_from_zero(cache)
        R = R_avail if cap is None else min(R_avail, int(cap))
        print(f"  {label:<8} {path}", flush=True)
        print(f"           entries = {len(cache)}   contiguous n = 0..{R_avail}"
              f"   r_max used = {R}", flush=True)
        if R < 1:
            raise SystemExit(f"{label}: no usable exact pi data (r_max {R}).")
        print(f"           largest x = {base}^{R} = {base ** R}", flush=True)
        caches_meta[label] = {
            "path": os.path.abspath(path),
            "entries": len(cache),
            "contiguous_n_max": R_avail,
            "r_max_used": R,
            "rmax_flag": cap,
            "largest_x": base ** R,
        }
        bases.append((label, base, cache, R))

    dmax = int(args.max_depth)
    print(f"\n  depths d = 0..{dmax}", flush=True)
    r_maxes = {lab: R for lab, _, _, R in bases}
    print(f"  r ranges DIFFER between the bases and are NOT truncated to a "
          f"common maximum:", flush=True)
    for lab in r_maxes:
        print(f"    {lab:<8} r = 1..{r_maxes[lab]}", flush=True)
    print(f"  difference: the dyadic ladder runs "
          f"{r_maxes['dyadic'] - r_maxes['triadic']} rows further in INDEX than "
          f"the triadic one;", flush=True)
    print(f"  in VALUE the triadic top 3^{r_maxes['triadic']} exceeds the "
          f"dyadic top 2^{r_maxes['dyadic']} "
          f"({3 ** r_maxes['triadic'] > 2 ** r_maxes['dyadic']}).", flush=True)

    # ---------------- compute ----------------------------------------------
    all_data = {}
    global_max_disagree = 0.0
    global_max_disagree_at = None

    for label, base, cache, R in bases:
        N = counts(cache, R)
        P = backward_table(N, R, dmax)
        d_eff = max(k for k in P)
        for model in SMOOTH_MODELS:
            print(f"\n  computing {label} / M = {model} at dps {dps} ...",
                  flush=True)
            S_main = smooth_table(model, base, R, dmax, dps)
            res_main = residual_table(P, S_main, R, dmax, dps)
            print(f"  verifying  {label} / M = {model} at dps {vdps} ...",
                  flush=True)
            S_ver = smooth_table(model, base, R, dmax, vdps)
            res_ver = residual_table(P, S_ver, R, dmax, vdps)

            trust = {}
            disagree = {}
            max_dis = 0.0
            max_dis_at = None
            n_untrusted = 0
            for d in range(0, d_eff + 1):
                for r in sorted(res_main.get(d, {})):
                    old = mp.dps
                    try:
                        mp.dps = vdps
                        delta = abs(res_main[d][r] - res_ver[d][r])
                        dv = float(delta)
                    finally:
                        mp.dps = old
                    disagree[(r, d)] = dv
                    ok = dv <= tol
                    trust[(r, d)] = ok
                    if not ok:
                        n_untrusted += 1
                    if dv > max_dis:
                        max_dis, max_dis_at = dv, (r, d)
            if max_dis > global_max_disagree:
                global_max_disagree = max_dis
                global_max_disagree_at = (label, model, max_dis_at)

            all_data[(label, model)] = {
                "base": base, "R": R, "dmax": d_eff,
                "prime": P, "res": res_main, "res_ver": res_ver,
                "trust": trust, "disagree": disagree,
                "max_disagreement": max_dis,
                "max_disagreement_at": max_dis_at,
                "n_untrusted": n_untrusted,
            }
            print(f"    max |residual(dps={dps}) - residual(dps={vdps})| = "
                  f"{max_dis:.6g}" +
                  (f"   at (r={max_dis_at[0]}, d={max_dis_at[1]})"
                   if max_dis_at else ""), flush=True)
            print(f"    cells failing the {tol:g} tolerance : {n_untrusted}",
                  flush=True)

    # ---------------- trustworthy envelope ----------------------------------
    print("\n" + "-" * 78, flush=True)
    print("PRECISION VERIFICATION", flush=True)
    print("-" * 78, flush=True)
    print(f"  main pass dps         : {dps}", flush=True)
    print(f"  verification pass dps : {vdps}", flush=True)
    print(f"  absolute tolerance    : {tol:g}", flush=True)
    print(f"  GLOBAL max disagreement across every base, model and cell : "
          f"{global_max_disagree:.6g}", flush=True)
    if global_max_disagree_at:
        lab, mdl, at = global_max_disagree_at
        print(f"    attained on {lab} / M = {mdl} at "
              f"(r={at[0]}, d={at[1]})", flush=True)

    envelopes = {}
    for (label, model), D in all_data.items():
        bad = sorted(k for k, ok in D["trust"].items() if not ok)
        deepest_ok = max((d for (r, d), ok in D["trust"].items() if ok),
                         default=None)
        largest_r_ok = max((r for (r, d), ok in D["trust"].items() if ok),
                           default=None)
        envelopes[(label, model)] = {
            "deepest_trusted_depth": deepest_ok,
            "largest_trusted_r": largest_r_ok,
            "untrusted_cells": [{"r": r, "depth": d} for (r, d) in bad],
            "n_untrusted": len(bad),
            "all_cells_trusted": len(bad) == 0,
        }
        print(f"  {label:<8} M={model:<3} : deepest trusted d = {deepest_ok}, "
              f"largest trusted r = {largest_r_ok}, untrusted cells = "
              f"{len(bad)}", flush=True)

    # ---------------- tables ------------------------------------------------
    for (label, model), D in all_data.items():
        print_table(
            f"RESIDUALS — {label} (base {D['base']}), smooth model M = {model}",
            D["res"], D["trust"], D["R"], D["dmax"], anchor_diag=True,
            p=3, rmax_print=args.print_rmax)

    # ---------------- li vs R diagnostic ------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("DIAGNOSTIC — li minus R at each depth", flush=True)
    print("-" * 78, flush=True)
    print("  Delta_M(r,d) = residual_li(r,d) - residual_R(r,d)", flush=True)
    print("               = -(Delta^(d+1) li)(r) + (Delta^(d+1) R)(r)",
          flush=True)
    print("  i.e. the SAME operator applied to the dropped "
          "-(1/2)li(sqrt(x)) - ... tail,", flush=True)
    print("  with the sign such that a POSITIVE value means li sits above R.",
          flush=True)
    li_vs_R = {}
    for label, base, cache, R in bases:
        Dl = all_data[(label, "li")]
        Dr = all_data[(label, "R")]
        rows = []
        print(f"\n  {label} (base {base}) — per depth, over r = d+1..{R}:",
              flush=True)
        print(f"    {'d':>3} {'n':>5} {'max|li-R|':>18} {'at r':>6} "
              f"{'min|li-R|':>18} {'|li-R| at r_max':>20}", flush=True)
        for d in range(0, Dl["dmax"] + 1):
            vals = []
            for r in sorted(Dl["res"].get(d, {})):
                if not (Dl["trust"].get((r, d), True) and
                        Dr["trust"].get((r, d), True)):
                    continue
                old = mp.dps
                try:
                    mp.dps = dps
                    v = float(Dl["res"][d][r] - Dr["res"][d][r])
                finally:
                    mp.dps = old
                vals.append((r, v))
            if not vals:
                continue
            amax_r, amax = max(vals, key=lambda t: abs(t[1]))
            amin_r, amin = min(vals, key=lambda t: abs(t[1]))
            last_r, last_v = vals[-1]
            rows.append({"depth": d, "n": len(vals),
                         "max_abs": abs(amax), "max_abs_at_r": amax_r,
                         "min_abs": abs(amin), "min_abs_at_r": amin_r,
                         "at_r_max": last_v, "r_max": last_r})
            print(f"    {d:>3} {len(vals):>5} {abs(amax):>18.6g} {amax_r:>6} "
                  f"{abs(amin):>18.6g} {last_v:>20.6g}", flush=True)
        li_vs_R[label] = rows

    # ---------------- depth behaviour --------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("DEPTH BEHAVIOUR — |residual| by depth, trusted cells only", flush=True)
    print("-" * 78, flush=True)
    depth_stats = {}
    for (label, model), D in all_data.items():
        rows = []
        print(f"\n  {label} (base {D['base']}), M = {model}:", flush=True)
        print(f"    {'d':>3} {'n':>5} {'max|res|':>16} {'at r':>6} "
              f"{'rms|res|':>16} {'|res| at r_max':>18}", flush=True)
        for d in range(0, D["dmax"] + 1):
            vals = []
            for r in sorted(D["res"].get(d, {})):
                if not D["trust"].get((r, d), True):
                    continue
                old = mp.dps
                try:
                    mp.dps = dps
                    vals.append((r, float(D["res"][d][r])))
                finally:
                    mp.dps = old
            if not vals:
                continue
            mr, mv = max(vals, key=lambda t: abs(t[1]))
            rms = math.sqrt(sum(v * v for _, v in vals) / len(vals))
            rows.append({"depth": d, "n": len(vals), "max_abs": abs(mv),
                         "max_abs_at_r": mr, "rms": rms,
                         "at_r_max": vals[-1][1], "r_max": vals[-1][0]})
            print(f"    {d:>3} {len(vals):>5} {abs(mv):>16.6g} {mr:>6} "
                  f"{rms:>16.6g} {vals[-1][1]:>18.6g}", flush=True)
        depth_stats[(label, model)] = rows

    # ---------------- CSVs --------------------------------------------------
    csv_paths = {}
    if not args.no_csv:
        print("\n" + "-" * 78, flush=True)
        print("ARTIFACTS", flush=True)
        print("-" * 78, flush=True)
        for (model, label), name in CSV_NAMES.items():
            D = all_data[(label, model)]
            path = os.path.join(args.results_dir, name)
            if os.path.exists(path):
                print(f"  WARNING: {path} already exists and will be "
                      f"overwritten by this run.", flush=True)
            _write_text(render_csv(D["res"], D["trust"], D["R"], D["dmax"],
                                   args.csv_decimals),
                        path, f"CSV ({label}, M={model})")
            csv_paths[f"{model}_{label}"] = os.path.abspath(path)

    ended = datetime.now(timezone.utc)

    # ---------------- JSON --------------------------------------------------
    if not args.no_json:
        tables = {}
        for (label, model), D in all_data.items():
            cells = []
            for d in range(0, D["dmax"] + 1):
                for r in sorted(D["res"].get(d, {})):
                    old = mp.dps
                    try:
                        mp.dps = dps
                        val = float(D["res"][d][r])
                    finally:
                        mp.dps = old
                    ok = D["trust"].get((r, d), True)
                    cells.append({
                        "r": r,
                        "depth": d,
                        "cell": int(D["prime"][d][r]),
                        "residual": val if ok else None,
                        "residual_str": mpmath.nstr(D["res"][d][r], 25),
                        "precision_disagreement": D["disagree"].get((r, d)),
                        "trusted": bool(ok),
                        "anchor_dependent": bool(r == d + 1),
                    })
            env = envelopes[(label, model)]
            tables[f"{model}_{label}"] = {
                "base": D["base"],
                "smooth_model": model,
                "r_max": D["R"],
                "depth_max": D["dmax"],
                "max_precision_disagreement": D["max_disagreement"],
                "max_precision_disagreement_at":
                    ({"r": D["max_disagreement_at"][0],
                      "depth": D["max_disagreement_at"][1]}
                     if D["max_disagreement_at"] else None),
                "trusted_envelope": env,
                "depth_stats": depth_stats[(label, model)],
                "cells": cells,
            }

        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "bases": {"dyadic": BASE_DYADIC, "triadic": BASE_TRIADIC},
                "smooth_models": list(SMOOTH_MODELS),
                "riemannr_impl": RIEMANNR_IMPL,
                "dps_main": dps,
                "dps_verify": vdps,
                "precision_tolerance_absolute": tol,
                "max_depth": dmax,
                "rmax_dyadic_flag": args.rmax_dyadic,
                "rmax_triadic_flag": args.rmax_triadic,
                "r_max_dyadic": r_maxes["dyadic"],
                "r_max_triadic": r_maxes["triadic"],
                "ranges_truncated_to_common_rmax": False,
                "csv_decimals": args.csv_decimals,
                "results_dir": os.path.abspath(args.results_dir),
                "out_json": os.path.abspath(args.out),
                "csv_paths": csv_paths,
                "caches": caches_meta,
                "cache_access": "read only; primecountpy never called",
                "difference_convention": "T(r,d) = T(r,d-1) - T(r-1,d-1) "
                                         "(backward); T(r,0) = pi(b^r) - "
                                         "pi(b^(r-1))",
                "support": "r = d+1 .. R; cells with r < d+1 do not exist",
                "first_block_convention": FIRST_BLOCK_CONVENTION,
                "smooth_anchor": SMOOTH_ANCHOR_NOTE,
                "precision": "exact Python int for the prime table; mpf at "
                             "dps_main for the smooth table and the residual; "
                             "float only at report time",
                "python_version": sys.version.split()[0],
                "mpmath_version": mpmath.__version__,
                "fit_free": True,
                "prereg": None,
                "status": "exploratory",
            },
            "constants": {
                "li_definition": "li(x) = logarithmic integral",
                "R_definition": "R(x) = sum_{n>=1} mu(n)/n li(x^(1/n)) "
                                "= li(x) - (1/2)li(sqrt(x)) - ...",
                "documented_backward_zeros_dyadic":
                    [[2, 1], [4, 1], [8, 3], [20, 6]],
                "pi_of_1": 0,
            },
            "summary": {
                "r_max_dyadic": r_maxes["dyadic"],
                "r_max_triadic": r_maxes["triadic"],
                "r_max_note": "each base runs its OWN full ladder; the dyadic "
                              "side is not truncated to the triadic one",
                "depth_max": dmax,
                "dps_main": dps,
                "dps_verify": vdps,
                "max_precision_disagreement_global": global_max_disagree,
                "max_precision_disagreement_global_at":
                    ({"base": global_max_disagree_at[0],
                      "smooth_model": global_max_disagree_at[1],
                      "r": global_max_disagree_at[2][0],
                      "depth": global_max_disagree_at[2][1]}
                     if global_max_disagree_at and global_max_disagree_at[2]
                     else None),
                "trusted_envelopes": {
                    f"{m}_{l}": envelopes[(l, m)] for (l, m) in envelopes},
                "anchor_dependent_cells": [
                    {"r": d + 1, "depth": d} for d in range(0, dmax + 1)],
                "li_vs_R_by_depth": li_vs_R,
            },
            "tables": tables,
        }
        _write_results(payload, args.out)

    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  The prime side is exact integer arithmetic. The smooth side is "
          "mpf at the", flush=True)
    print("  recorded dps and is differenced at that precision — never via "
          "float.", flush=True)
    print("  Any cell that moved by more than the tolerance between the two "
          "precisions is", flush=True)
    print("  reported as UNTRUSTWORTHY, not as a number.", flush=True)
    print("  This script states no hypothesis and fires no decision rule. It "
          "is EXPLORATORY", flush=True)
    print("  per CLAUDE.md § Prereg discipline.", flush=True)


if __name__ == "__main__":
    main()
