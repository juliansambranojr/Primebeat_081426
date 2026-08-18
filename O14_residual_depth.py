#!/usr/bin/env python3
"""
O14 — Residual depth: differencing the dyadic block sum along the dyadic axis
      after the known envelope has been divided out, so that only the residual
      survives.

Reads with: dyadic-table-v2.md; DT-A5; DT-A6; O9_convergence_abscissa.py;
O12_dyadic_block_ratio.py (this bench's
`results/O12_dyadic_block_ratio_results.json`).

NAMING
------
The O-series in this tree runs O1-O9, O11, O12, O13.  There is NO O10: that
number is a known, DELIBERATE GAP, and this script does not fill it, because
filling a reserved gap with unrelated work would silently rewrite the series'
history.  The next free number after O13 is O14; this file takes it.  Capital
"O" per `CLAUDE.md` § "Naming convention (do not re-break)".

ENVELOPE
--------
The house JSON envelope is unchanged in shape (schema_version, script,
generated_utc, params, constants, summary, rows) and `schema_version` stays
"1".  As on O12/O13, `params.code_version` carries the sha256 of THIS script
file, computed at runtime by reading `__file__`.

=============================================================================
WHAT THIS MEASURES AND WHY
=============================================================================

O12 established, fit-free, that the dyadic block sum obeys a = 1 - sigma:

    Delta_N = sum over primes[N:2N] of p^(-sigma) * exp(-i t log p)
              (EXACTLY N terms)
    |Delta_N| ~ N^(1-sigma)

That is the SMOOTH ENVELOPE — count times magnitude, N terms each of typical
size ~N^(-sigma).  It is the analogue of the d=0 row of a finite-difference
table: the trend, not the structure.

This script does to the block sums what the dyadic difference table does to
prime counts: NORMALISE THE KNOWN LAW OUT, then DIFFERENCE along the dyadic
axis, so that the trend is annihilated and only the residual survives.

    g_k = |Delta_N| / N^(1-sigma)          with   N_k = 125 * 2^k

If the law were exact, g_k is constant in k and every finite difference of it
is zero.  Whatever survives differencing is the departure from the envelope.

Depth axis, exactly as in a difference table (BACKWARD differences along k):

    g[k, 0] = g_k
    g[k, d] = g[k, d-1] - g[k-1, d-1]

The table is lower triangular: g[k, d] exists only for d <= k.

THE QUANTITY OF INTEREST IS THE SCALING OF THE RESIDUAL.  If the residual
carries exponent 1/2 relative to the envelope, then |g[k,1]| ~ N_k^(-1/2), so:

    ratio   rho_res = g[k+1,1] / g[k,1]     should approach 2^(-1/2)
                                            = 0.70710678
    and     h_k      = |g[k,1]| * N_k^(1/2)  should be constant in k

Both are read directly.

NOTHING IS FITTED ANYWHERE IN THIS SCRIPT — no least squares, no r^2, no
window, no threshold.  Normalisation uses the ANALYTIC exponent (1 - sigma),
never a fitted one.  The theta scan below is a parameter-free scan across
three FIXED exponents, not a fit; nothing is optimised over theta.

WHY t = 0 IS INCLUDED AND COMES FIRST
-------------------------------------
t = 0 is in the default t list deliberately, and first.  At t = 0 the summand
is real and non-oscillatory (exp(-i*0*log p) = 1), so Delta_N is a plain
weighted count of the block.  That is the closest analogue to the difference
table's own object, which has no t at all — the dyadic table differences
counts, not oscillating sums.  Every t > 0 row is then the same instrument
with an oscillation switched on.

THE SECOND, LOG-CORRECTED NORMALISATION
---------------------------------------
The finite-N additive law is a_eff = 1 - sigma - sigma/log(N) (from
p_N ~ N log N), i.e.

    a_corr = 1 - sigma * (1 + 1/log(N_k))

This is also ANALYTIC and also UNFITTED.  Reported alongside the plain
normalisation as

    g_corr[k, 0] = |Delta_N| / N_k^(a_corr)

together with its depth-1 backward differences, so that the drift caused by
the known log-log correction is visible and separable from the residual.

NUMERICS
--------
Delta_N is computed DIRECTLY as a numpy sum over the slice primes[N:2*N].  It
is NOT formed by differencing two cumulative sums, so no catastrophic
cancellation of large partial sums enters.  The sieve and the summand formula
mirror O9 and O12 exactly:  p^(-sigma) * (cos(t log p) - i sin(t log p)).

=============================================================================
GATES — both RUN on every invocation and are recorded in the payload
=============================================================================

GATE A — exact and analytic.  At sigma = 0.0 and t = 0 every term is exactly
1, so Delta_N = N EXACTLY, g_k = 1.0 EXACTLY for every rung, and every
difference at depth >= 1 is EXACTLY 0.0.  Verified to exact float equality.
Failure prints loudly and sets `gate_a_passed` false; the JSON is still
written.

GATE B — cross-instrument.  Reads
`results/O12_dyadic_block_ratio_results.json` and, for every (sigma, t, N)
that both instruments share, verifies this script's |Delta_N| against O12's
`absD` to at least 12 significant figures.  Expected values are READ FROM
THAT FILE — nothing is hardcoded.  If the file is missing or unreadable,
`gate_b_passed` is recorded as null and that is stated in the output.

REQUIREMENTS
------------
    pip install numpy

USAGE
-----
    python3 O14_residual_depth.py
    python3 O14_residual_depth.py --pmax 150000000 --out results/o14_ext.json
"""

import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

try:
    import numpy as np
except ImportError:
    raise ImportError("numpy is required. Install with: pip install numpy")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
O12_RESULTS = os.path.join(_HERE, "results",
                           "O12_dyadic_block_ratio_results.json")

SQRT_HALF = 0.70710678


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """Coerce numpy scalars to JSON-safe Python types; non-finite -> None."""
    if isinstance(o, dict):
        return {k: _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str):
        return o
    if isinstance(o, (bool, np.bool_)):
        return bool(o)
    if isinstance(o, (int, np.integer)):
        return int(o)
    if isinstance(o, (float, np.floating)):
        f = float(o)
        return f if math.isfinite(f) else None
    try:
        f = float(o)
    except (TypeError, ValueError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a long run."""
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


def _safe_div(a, b):
    """Guarded division: returns nan rather than raising or returning inf."""
    try:
        if b is None or not math.isfinite(float(b)) or float(b) == 0.0:
            return float("nan")
        av = float(a)
        if not math.isfinite(av):
            return float("nan")
        return av / float(b)
    except (TypeError, ValueError, ZeroDivisionError):
        return float("nan")


def _fmt(v, w=16, p=8, dash="—"):
    """Guarded fixed-point formatter for table cells."""
    if v is None:
        return f"{dash:>{w}}"
    try:
        f = float(v)
    except (TypeError, ValueError):
        return f"{dash:>{w}}"
    if not math.isfinite(f):
        return f"{dash:>{w}}"
    return f"{f:>{w}.{p}f}"


def _fmtg(v, w=18, p=10, dash="—"):
    """Guarded general-format formatter for table cells."""
    if v is None:
        return f"{dash:>{w}}"
    try:
        f = float(v)
    except (TypeError, ValueError):
        return f"{dash:>{w}}"
    if not math.isfinite(f):
        return f"{dash:>{w}}"
    return f"{f:>{w}.{p}g}"


def sieve_primes(limit):
    """Exact primes by sieve of Eratosthenes. Mirrors O9/O12."""
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.float64)


def block_delta(primes, N, sigma, t):
    """
    Delta_N = sum over primes[N:2N] of p^(-sigma)*(cos(t log p) - i sin(t log p)).
    EXACTLY N terms, summed directly. No differencing of cumulative sums.
    Identical formula to O12's block_delta.
    """
    p = primes[N:2 * N]
    lg = np.log(p)
    w = p ** (-sigma)
    return complex(np.sum(w * np.cos(t * lg)), -np.sum(w * np.sin(t * lg)))


def difference_triangle(g0):
    """
    Full lower-triangular backward-difference table.

        tri[k][0] = g0[k]
        tri[k][d] = tri[k][d-1] - tri[k-1][d-1]      for 1 <= d <= k

    Returns a list of lists; row k has exactly k+1 entries.
    """
    tri = []
    for k, v in enumerate(g0):
        row = [v]
        for d in range(1, k + 1):
            prev = tri[k - 1]
            if (row[d - 1] is None or prev[d - 1] is None
                    or not math.isfinite(row[d - 1])
                    or not math.isfinite(prev[d - 1])):
                row.append(float("nan"))
            else:
                row.append(row[d - 1] - prev[d - 1])
        tri.append(row)
    return tri


def main():
    ap = argparse.ArgumentParser(
        description="O14 — residual depth: difference the dyadic block sum "
                    "after dividing out the analytic envelope N^(1-sigma)")
    ap.add_argument("--pmax", type=int, default=34000000,
                    help="sieve limit for the prime list (default 34000000)")
    ap.add_argument("--ladder-base", type=int, default=125,
                    help="first rung N of the doubling ladder (default 125)")
    ap.add_argument("--sigmas", type=str, default="0.0,0.5,1.0",
                    help="comma-separated sigma values (default 0.0,0.5,1.0)")
    ap.add_argument("--tvals", type=str,
                    default="0,10,14.5,20,30,40,50,80,160,320",
                    help="comma-separated t values; t=0 is deliberate and "
                         "must come first (default "
                         "0,10,14.5,20,30,40,50,80,160,320)")
    ap.add_argument("--max-depth", type=int, default=6,
                    help="how many difference depths to PRINT (default 6); "
                         "the full triangle is always computed and stored")
    ap.add_argument("--thetas", type=str, default="0.25,0.5,0.75",
                    help="fixed exponents for the h_k(theta) scan "
                         "(default 0.25,0.5,0.75); a scan, not a fit")
    ap.add_argument("--o12-results", type=str, default=O12_RESULTS,
                    help="path to O12's results JSON, read by gate B")
    ap.add_argument("--gate-b-sigfigs", type=float, default=12.0,
                    help="minimum significant figures of agreement required "
                         "by cross-instrument gate B (default 12)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    sigmas = [float(x) for x in args.sigmas.split(",")]
    tvals = [float(x) for x in args.tvals.split(",")]
    thetas = [float(x) for x in args.thetas.split(",")]
    gate_b_tol = 10.0 ** (-args.gate_b_sigfigs)

    print("=" * 78, flush=True)
    print("O14 — residual depth  (fit-free; analytic normalisation only)",
          flush=True)
    print("=" * 78, flush=True)
    print("  Delta_N = sum over primes[N:2N] of p^(-sigma) exp(-i t log p)",
          flush=True)
    print("  envelope (O12, fit-free): |Delta_N| ~ N^(1-sigma)", flush=True)
    print("  g[k,0] = |Delta_N| / N_k^(1-sigma)      N_k = "
          f"{args.ladder_base} * 2^k", flush=True)
    print("  g[k,d] = g[k,d-1] - g[k-1,d-1]          (backward, along k)",
          flush=True)
    print("  rho_res = g[k+1,1] / g[k,1]   landmark 2^(-1/2) = "
          f"{SQRT_HALF:.8f}", flush=True)
    print("  implied exponent  e = -log2(rho_res)   (e = 0.5 <=> N^(-1/2))",
          flush=True)
    print("  h_k(theta) = |g[k,1]| * N_k^theta       thetas = "
          f"{thetas}", flush=True)
    print("  NOTHING IS FITTED: no least squares, no r^2, no window, no "
          "threshold.", flush=True)
    print("  The theta scan is a PARAMETER-FREE SCAN across three FIXED "
          "exponents;", flush=True)
    print("  nothing is optimised over theta and no exponent is estimated "
          "from data.", flush=True)
    print("  Second normalisation (also analytic, also unfitted):", flush=True)
    print("    a_corr(N) = 1 - sigma*(1 + 1/log(N))", flush=True)
    print("    g_corr[k,0] = |Delta_N| / N_k^(a_corr)", flush=True)
    print("  t = 0 is FIRST and DELIBERATE: the summand is real and "
          "non-oscillatory", flush=True)
    print("  there, the closest analogue to the difference table's own "
          "object.", flush=True)

    # ---------------- sieve ------------------------------------------------
    print(f"\n  sieving primes to {args.pmax}...", flush=True)
    primes = sieve_primes(args.pmax)
    n_primes = int(len(primes))
    largest_prime = int(primes[-1]) if n_primes else None
    print(f"  {n_primes} primes, largest = {largest_prime}", flush=True)

    # ---------------- ladder ----------------------------------------------
    ladder = []
    k = 0
    while True:
        N = args.ladder_base * (2 ** k)
        if 2 * N > n_primes:
            break
        ladder.append(N)
        k += 1
    K = len(ladder)
    print(f"  ladder N_k = {args.ladder_base} * 2^k, kept while 2N <= "
          f"n_primes", flush=True)
    print(f"  ladder kept : {ladder}", flush=True)
    print(f"  rungs K = {K}", flush=True)
    if not ladder:
        print("  ERROR: no ladder rung survives; raise --pmax.", flush=True)
        ladder_top = None
    else:
        ladder_top = ladder[-1]
        idx_used = 2 * ladder_top - 1
        print(f"  largest prime index used : {idx_used} "
              f"(value {int(primes[idx_used])})", flush=True)
    print(f"  sigmas : {sigmas}", flush=True)
    print(f"  t vals : {tvals}", flush=True)
    print(f"  depths printed : 0..{args.max_depth} (all "
          f"{max(K - 1, 0)} depths stored)", flush=True)

    # ---------------- the series ------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("RESIDUAL DEPTH TABLES — one block per (sigma, t)", flush=True)
    print("-" * 78, flush=True)

    rows = []
    series = []
    max_d_print = max(0, int(args.max_depth))

    for sg in sigmas:
        for t in tvals:
            absD = []
            g0 = []
            gc0 = []
            acorr = []
            for N in ladder:
                d = block_delta(primes, N, sg, t)
                ad = abs(d)
                absD.append(ad)
                env = float(N) ** (1.0 - sg)
                g0.append(_safe_div(ad, env))
                lgN = math.log(N)
                ac = (1.0 - sg * (1.0 + _safe_div(1.0, lgN))
                      if math.isfinite(lgN) and lgN != 0.0 else float("nan"))
                acorr.append(ac)
                envc = (float(N) ** ac if math.isfinite(ac) else float("nan"))
                gc0.append(_safe_div(ad, envc))

            tri = difference_triangle(g0)
            tric = difference_triangle(gc0)

            d1 = [tri[k][1] if k >= 1 else None for k in range(K)]
            d1c = [tric[k][1] if k >= 1 else None for k in range(K)]

            # rho_res over consecutive depth-1 pairs
            rho_res = [None] * K
            expo = [None] * K
            for k in range(2, K):
                r = _safe_div(d1[k], d1[k - 1])
                rho_res[k] = r
                expo[k] = (-math.log2(r)
                           if r is not None and math.isfinite(r) and r > 0
                           else None)

            # h_k(theta), fixed exponents, no optimisation
            hcols = {}
            for th in thetas:
                col = [None] * K
                for k in range(1, K):
                    if d1[k] is not None and math.isfinite(d1[k]):
                        col[k] = abs(d1[k]) * (float(ladder[k]) ** th)
                hcols[th] = col

            # ---- print ----
            print(f"\n  ==== sigma = {sg:g}   t = {t:g} "
                  f"{'(non-oscillatory row)' if t == 0.0 else ''}", flush=True)

            hdr = f"  {'k':>3} {'N_k':>10} {'|Delta_N|':>20} "
            for d in range(0, min(max_d_print, K - 1) + 1):
                hdr += f"{('g[k,%d]' % d):>18}"
            print(hdr, flush=True)
            for kk in range(K):
                line = f"  {kk:>3} {ladder[kk]:>10} {_fmtg(absD[kk], 20, 12)} "
                for d in range(0, min(max_d_print, K - 1) + 1):
                    v = tri[kk][d] if d <= kk else None
                    line += _fmtg(v, 18, 10)
                print(line, flush=True)

            print(f"\n  {'k':>3} {'N_k':>10} {'g[k,1]':>18} "
                  f"{'rho_res':>16} {'landmark':>12} {'e=-log2(rho)':>14}",
                  flush=True)
            for kk in range(K):
                if kk < 1:
                    continue
                print(f"  {kk:>3} {ladder[kk]:>10} {_fmtg(d1[kk], 18, 10)} "
                      f"{_fmt(rho_res[kk], 16, 8)} "
                      f"{SQRT_HALF:>12.8f} {_fmt(expo[kk], 14, 6)}",
                      flush=True)

            hh = f"\n  {'k':>3} {'N_k':>10} {'|g[k,1]|':>18}"
            for th in thetas:
                hh += f"{('h(theta=%g)' % th):>20}"
            print(hh, flush=True)
            for kk in range(1, K):
                line = (f"  {kk:>3} {ladder[kk]:>10} "
                        f"{_fmtg(abs(d1[kk]) if d1[kk] is not None and math.isfinite(d1[kk]) else None, 18, 10)}")
                for th in thetas:
                    line += _fmtg(hcols[th][kk], 20, 10)
                print(line, flush=True)
            print("    (theta scan: three FIXED exponents read side by side; "
                  "NOT a fit)", flush=True)

            print(f"\n  log-corrected diagnostic  a_corr = 1 - sigma*(1 + "
                  f"1/log N)", flush=True)
            print(f"  {'k':>3} {'N_k':>10} {'a_corr':>12} "
                  f"{'g_corr[k,0]':>18} {'g_corr[k,1]':>18} "
                  f"{'g[k,0]':>18} {'g[k,1]':>18}", flush=True)
            for kk in range(K):
                print(f"  {kk:>3} {ladder[kk]:>10} {_fmt(acorr[kk], 12, 8)} "
                      f"{_fmtg(gc0[kk], 18, 10)} {_fmtg(d1c[kk], 18, 10)} "
                      f"{_fmtg(g0[kk], 18, 10)} {_fmtg(d1[kk], 18, 10)}",
                      flush=True)

            # ---- record ----
            for kk in range(K):
                rows.append({
                    "sigma": sg, "t": t, "k": kk, "N": ladder[kk],
                    "absD": absD[kk],
                    "envelope_exponent": 1.0 - sg,
                    "g0": g0[kk],
                    "g_depth": tri[kk],
                    "g1": d1[kk],
                    "rho_res": rho_res[kk],
                    "implied_exponent": expo[kk],
                    "h_theta": {str(th): hcols[th][kk] for th in thetas},
                    "a_corr": acorr[kk],
                    "g_corr0": gc0[kk],
                    "g_corr_depth": tric[kk],
                    "g_corr1": d1c[kk],
                })

            series.append({
                "sigma": sg, "t": t, "K": K, "ladder": ladder,
                "absD": absD,
                "g0": g0,
                "g_triangle": tri,
                "g1": d1,
                "rho_res": rho_res,
                "implied_exponent": expo,
                "h_theta": {str(th): hcols[th] for th in thetas},
                "a_corr": acorr,
                "g_corr0": gc0,
                "g_corr_triangle": tric,
                "g_corr1": d1c,
            })

    # ---------------- GATE A ----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — exact analytic check at sigma = 0.0, t = 0", flush=True)
    print("-" * 78, flush=True)
    print("  every term is exactly 1 => Delta_N = N exactly, g[k,0] = 1.0 "
          "exactly,", flush=True)
    print("  and every difference at depth >= 1 is exactly 0.0. Tested to "
          "exact float equality.", flush=True)
    gate_a_rows = []
    gate_a_passed = None
    ref = next((s for s in series
                if s["sigma"] == 0.0 and s["t"] == 0.0), None)
    if ref is None:
        gate_a_passed = None
        print("  GATE A NOT RUN — (sigma=0.0, t=0) is not in the requested "
              "grid; recorded as null.", flush=True)
    else:
        gate_a_passed = True
        for kk in range(ref["K"]):
            Nk = ref["ladder"][kk]
            ad = ref["absD"][kk]
            gv = ref["g0"][kk]
            ok_d = (ad == float(Nk))
            ok_g = (gv == 1.0)
            deep = [ref["g_triangle"][kk][d] for d in range(1, kk + 1)]
            ok_deep = all(v == 0.0 for v in deep)
            ok = bool(ok_d and ok_g and ok_deep)
            gate_a_passed = gate_a_passed and ok
            gate_a_rows.append({
                "k": kk, "N": Nk, "absD": ad, "absD_equals_N_exactly": ok_d,
                "g0": gv, "g0_equals_one_exactly": ok_g,
                "n_deep": len(deep),
                "all_deep_exactly_zero": ok_deep,
                "max_abs_deep": (max(abs(v) for v in deep) if deep else 0.0),
                "passed": ok,
            })
        print(f"  {'k':>3} {'N_k':>10} {'|Delta_N|':>20} {'==N':>6} "
              f"{'g[k,0]':>20} {'==1':>6} {'#deep':>6} {'max|deep|':>12} "
              f"{'ok':>4}", flush=True)
        for r in gate_a_rows:
            print(f"  {r['k']:>3} {r['N']:>10} {r['absD']:>20.15g} "
                  f"{str(r['absD_equals_N_exactly']):>6} "
                  f"{r['g0']:>20.17g} {str(r['g0_equals_one_exactly']):>6} "
                  f"{r['n_deep']:>6} {r['max_abs_deep']:>12.3e} "
                  f"{str(r['passed']):>4}", flush=True)
        if gate_a_passed:
            print("\n  GATE A PASSED — exact to float equality on every "
                  "rung and every depth.", flush=True)
        else:
            print("\n  " + "*" * 70, flush=True)
            print("  *** GATE A FAILED *** the analytic identity at "
                  "sigma=0, t=0 does not hold", flush=True)
            print("  *** exactly. Every number above is suspect.", flush=True)
            print("  " + "*" * 70, flush=True)

    # ---------------- GATE B ----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE B — cross-instrument against O12's |Delta_N|", flush=True)
    print("-" * 78, flush=True)
    print(f"  source: {args.o12_results}", flush=True)
    print(f"  requires agreement to >= {args.gate_b_sigfigs:g} significant "
          f"figures on every shared (sigma, t, N)", flush=True)
    gate_b_passed = None
    gate_b_note = None
    gate_b_n_shared = 0
    gate_b_worst_rel = None
    gate_b_worst_cell = None
    gate_b_rows = []
    o12_map = {}
    try:
        with open(args.o12_results, "r") as fh:
            o12 = json.load(fh)
        for r in o12.get("rows", []):
            if r.get("absD") is None:
                continue
            o12_map[(float(r["sigma"]), float(r["t"]), int(r["N"]))] = \
                float(r["absD"])
        gate_b_note = (f"read {len(o12_map)} O12 cells from "
                       f"{os.path.basename(args.o12_results)}")
        print(f"  {gate_b_note}", flush=True)
    except Exception as exc:
        o12_map = None
        gate_b_note = f"O12 results not readable: {exc}"
        print(f"  {gate_b_note}", flush=True)
        print("  GATE B NOT RUN — gate_b_passed recorded as null.", flush=True)

    if o12_map:
        gate_b_passed = True
        worst = -1.0
        for r in rows:
            key = (float(r["sigma"]), float(r["t"]), int(r["N"]))
            if key not in o12_map:
                continue
            exp = o12_map[key]
            got = r["absD"]
            rel = _safe_div(abs(got - exp), abs(exp))
            ok = math.isfinite(rel) and rel <= gate_b_tol
            if rel == 0.0:
                ok = True
            gate_b_n_shared += 1
            gate_b_passed = gate_b_passed and ok
            if math.isfinite(rel) and rel > worst:
                worst = rel
                gate_b_worst_cell = {"sigma": key[0], "t": key[1],
                                     "N": key[2], "o14_absD": got,
                                     "o12_absD": exp, "rel_err": rel}
            if not ok:
                gate_b_rows.append({"sigma": key[0], "t": key[1], "N": key[2],
                                    "o14_absD": got, "o12_absD": exp,
                                    "rel_err": rel, "passed": False})
        gate_b_worst_rel = worst if worst >= 0.0 else None
        print(f"  shared cells compared : {gate_b_n_shared}", flush=True)
        if gate_b_n_shared == 0:
            gate_b_passed = None
            print("  NO SHARED CELLS — gate_b_passed recorded as null.",
                  flush=True)
            gate_b_note = (gate_b_note or "") + "; no shared (sigma,t,N) cells"
        else:
            wr = gate_b_worst_rel
            sf = (float("inf") if wr == 0.0
                  else (-math.log10(wr) if wr and math.isfinite(wr) and wr > 0
                        else float("nan")))
            wr_txt = ("—" if wr is None or not math.isfinite(wr)
                      else format(wr, ".6e"))
            print(f"  worst relative error  : {wr_txt}", flush=True)
            print(f"  worst-cell sig figs   : "
                  f"{'exact' if not math.isfinite(sf) else format(sf, '.2f')}",
                  flush=True)
            if gate_b_worst_cell is not None:
                print(f"  worst cell            : sigma="
                      f"{gate_b_worst_cell['sigma']:g}, "
                      f"t={gate_b_worst_cell['t']:g}, "
                      f"N={gate_b_worst_cell['N']}", flush=True)
            if gate_b_passed:
                print("\n  GATE B PASSED — this instrument reproduces O12 on "
                      "every shared cell.", flush=True)
            else:
                print("\n  " + "*" * 70, flush=True)
                print(f"  *** GATE B FAILED *** {len(gate_b_rows)} shared "
                      "cell(s) disagree with O12", flush=True)
                print("  *** beyond tolerance. Every number above is "
                      "suspect.", flush=True)
                print("  " + "*" * 70, flush=True)
                for r in gate_b_rows[:20]:
                    print(f"    sigma={r['sigma']:g} t={r['t']:g} "
                          f"N={r['N']} rel={r['rel_err']:.3e}", flush=True)

    # ---------------- rho_res summary -------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("rho_res AT THE TOP RUNG, BY (sigma, t)   [landmark "
          f"{SQRT_HALF:.8f}]", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'sigma':>7} {'t':>8} {'k_top':>6} {'rho_res(top)':>16} "
          f"{'e=-log2':>12} {'rho_res(top-1)':>16} {'e=-log2':>12}",
          flush=True)
    top_summary = []
    for s in series:
        rr = s["rho_res"]
        ee = s["implied_exponent"]
        kt = None
        for kk in range(s["K"] - 1, -1, -1):
            if rr[kk] is not None and math.isfinite(rr[kk]):
                kt = kk
                break
        kp = None
        if kt is not None:
            for kk in range(kt - 1, -1, -1):
                if rr[kk] is not None and math.isfinite(rr[kk]):
                    kp = kk
                    break
        rec = {"sigma": s["sigma"], "t": s["t"],
               "k_top": kt,
               "rho_res_top": (rr[kt] if kt is not None else None),
               "implied_exponent_top": (ee[kt] if kt is not None else None),
               "rho_res_prev": (rr[kp] if kp is not None else None),
               "implied_exponent_prev": (ee[kp] if kp is not None else None)}
        top_summary.append(rec)
        print(f"  {s['sigma']:>7.2f} {s['t']:>8g} "
              f"{(kt if kt is not None else -1):>6} "
              f"{_fmt(rec['rho_res_top'], 16, 8)} "
              f"{_fmt(rec['implied_exponent_top'], 12, 6)} "
              f"{_fmt(rec['rho_res_prev'], 16, 8)} "
              f"{_fmt(rec['implied_exponent_prev'], 12, 6)}", flush=True)

    # ---------------- read the result -------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  g[k,0] is |Delta_N| with the ANALYTIC envelope N^(1-sigma) "
          "divided out.", flush=True)
    print("  If the envelope law were exact, g[k,0] would be constant in k "
          "and every", flush=True)
    print("  g[k,d>=1] would be zero. What survives differencing IS the "
          "residual.", flush=True)
    print("  rho_res -> 0.70710678 and a flat h(theta=0.5) column would both "
          "read", flush=True)
    print("  residual exponent 1/2; a flat h(theta=0.25) or h(theta=0.75) "
          "column reads", flush=True)
    print("  that theta instead. Nothing here is fitted; read the columns.",
          flush=True)
    print(f"  gate A (exact, sigma=0,t=0) : "
          f"{'PASSED' if gate_a_passed else ('NOT RUN' if gate_a_passed is None else 'FAILED')}",
          flush=True)
    print(f"  gate B (cross-instrument)   : "
          f"{'PASSED' if gate_b_passed else ('NOT RUN' if gate_b_passed is None else 'FAILED')}",
          flush=True)

    # ---------------- payload ---------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "pmax": args.pmax,
                "n_primes": n_primes,
                "largest_prime": largest_prime,
                "ladder_base": args.ladder_base,
                "ladder": ladder,
                "ladder_rungs": K,
                "ladder_top": ladder_top,
                "largest_prime_index_used": (2 * ladder_top - 1
                                             if ladder_top else None),
                "largest_prime_value_used": (int(primes[2 * ladder_top - 1])
                                             if ladder_top else None),
                "sigmas": sigmas,
                "tvals": tvals,
                "t_zero_first": bool(tvals and tvals[0] == 0.0),
                "thetas": thetas,
                "max_depth_printed": max_d_print,
                "max_depth_stored": max(K - 1, 0),
                "o12_results_path": args.o12_results,
                "gate_b_sigfigs_required": args.gate_b_sigfigs,
                "gate_b_rel_tolerance": gate_b_tol,
                "delta_definition": ("direct numpy sum over primes[N:2N] of "
                                     "p^(-sigma)*(cos(t log p) - i sin(t log p))"),
                "normalisation": "g[k,0] = |Delta_N| / N_k^(1-sigma)",
                "normalisation_corrected":
                    "g_corr[k,0] = |Delta_N| / N_k^(1 - sigma*(1 + 1/log N_k))",
                "difference_convention":
                    "backward along k: g[k,d] = g[k,d-1] - g[k-1,d-1]",
                "fit_free": True,
                "theta_scan_is_not_a_fit": True,
                "precision": "float64",
            },
            "constants": {
                "envelope_law": "|Delta_N| ~ N^(1-sigma)  (O12, fit-free)",
                "envelope_exponent": "a = 1 - sigma",
                "finite_N_corrected_exponent":
                    "a_corr = 1 - sigma*(1 + 1/log N)",
                "residual_half_landmark_rho": SQRT_HALF,
                "residual_half_landmark_exact": 2.0 ** -0.5,
                "exponent_relation":
                    "rho_res = 2^(-e); e = -log2(rho_res)",
                "h_definition": "h_k(theta) = |g[k,1]| * N_k^theta",
                "t_zero_note": (
                    "t=0 is included deliberately and first: the summand is "
                    "real and non-oscillatory, the closest analogue to the "
                    "dyadic difference table's own object, which has no t"),
                "o10_note": (
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script"),
            },
            "summary": {
                "gate_a_passed": (None if gate_a_passed is None
                                  else bool(gate_a_passed)),
                "gate_a": gate_a_rows,
                "gate_b_passed": (None if gate_b_passed is None
                                  else bool(gate_b_passed)),
                "gate_b_note": gate_b_note,
                "gate_b_n_shared_cells": gate_b_n_shared,
                "gate_b_worst_rel_err": gate_b_worst_rel,
                "gate_b_worst_cell": gate_b_worst_cell,
                "gate_b_failures": gate_b_rows,
                "n_series": len(series),
                "ladder_rungs": K,
                "rho_res_top_by_series": top_summary,
                "series": series,
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
