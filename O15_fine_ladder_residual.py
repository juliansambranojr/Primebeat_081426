#!/usr/bin/env python3
"""
O15 — Fine-ladder residual: the SAME residual function O14 measured, resampled
      on a geometric ladder fine enough that a cos(gamma log N) oscillation is
      no longer aliased, plus a fit-free projection onto that oscillation.

Reads with: O14_residual_depth.py; O12_dyadic_block_ratio.py; DT-A5; DT-A6;
this bench's `results/O14_residual_depth_ext.json`.

NAMING
------
The O-series in this tree runs O1-O9, O11, O12, O13, O14.  There is NO O10:
that number is a known, DELIBERATE GAP, and this script does not fill it,
because filling a reserved gap with unrelated work would silently rewrite the
series' history.  The next free number after O14 is O15; this file takes it.
Capital "O" per `CLAUDE.md` § "Naming convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

O14 sampled

    g(N) = |Delta_N| / N^(1 - sigma)

on a DYADIC ladder N = 125 * 2^k, i.e. log N in steps of log 2 = 0.6931472.
A residual that oscillates as cos(gamma * log N + phi) is therefore sampled at
an angular-frequency spacing whose Nyquist limit is

    pi / log 2 = 4.5323601

Every Riemann zero height is far above that limit (gamma_1 = 14.134725), so on
a dyadic ladder those oscillations ALIAS and cannot be resolved.  That is a
property of the SAMPLING, not of the data, and it is why O14's sign runs came
out at 1-2 rungs at every depth.

This script samples the SAME function on a finer geometric ladder of ratio r,
so that

    Nyquist = pi / log(r)

At the default r = 1.1, Nyquist = 32.97, which clears gamma_1 = 14.134725,
gamma_2 = 21.022040 and gamma_3 = 25.010858.

Definitions are UNCHANGED from O14:

    Delta_N = sum over primes[N:2N] of p^(-sigma) * exp(-i t log p)
              (EXACTLY N terms, direct numpy sum over the slice)
    g(N)    = |Delta_N| / N^(1 - sigma)

Only the SAMPLING of N changes.  The block is still N -> 2N; consecutive
ladder points therefore OVERLAP, which is intended — this is oversampling a
function, not re-defining it.

A DIFFERENCE ALONG THE LADDER INDEX j IS NOW A DIFFERENCE OVER A LOG-N STEP OF
log(r), NOT log(2).  Depth-d differences on this ladder are therefore NOT
numerically comparable to O14's depth-d differences except at r = 2.

    G[j, 0] = g(N_j)
    G[j, d] = G[j, d-1] - G[j-1, d-1]        (backward along j, d <= j)

=============================================================================
WHAT IS COMPUTED
=============================================================================

1. Sieve to --pmax.  Same sieve_primes as O14/O9.

2. Geometric ladder  N_j = round(ladder_base * r^j),  j = 0, 1, 2, ...  kept
   while 2*N_j <= n_primes.  Rounding can make early N_j repeat, so the ladder
   is DEDUPLICATED to strictly increasing values and the number of collapsed
   raw steps is reported.

3. Delta_N by DIRECT np.sum over primes[N:2N].  Cumulative sums are never
   differenced.

4. g_j and the full backward-difference table along j to --max-depth.

5. ENVELOPE EXPONENT, RMS-BASED.  This is the fix for O14's failure mode:
   geometric means of |g| were dragged down by near-zero cells.  For each
   (sigma, t, depth d) the available rungs are split into a lower and an upper
   half (the middle rung is dropped when the count is odd) and

       RMS_lo, RMS_hi = sqrt(mean(G[j,d]^2))   over each half
       NM_lo,  NM_hi  = geometric mean of N_j  over each half
       theta_rms      = -( ln(RMS_hi) - ln(RMS_lo) ) / ( ln(NM_hi) - ln(NM_lo) )

   THIS IS A TWO-POINT RATIO, NOT A LEAST-SQUARES FIT.  Nothing is optimised.
   Robustness: theta_rms is also recomputed with the single LARGEST |G[j,d]|
   excluded and with the single SMALLEST excluded, so both tails are probed.

6. PROJECTION ONTO OSCILLATION.  No fitting — an inner product.  For each
   (sigma, t, d) and each gamma on the grid:

       P(gamma) = | sum_j w_j * Ghat[j,d] * exp(-i * gamma * log N_j) |

   where  Ghat[j,d] = G[j,d] * N_j^(theta_rms of that cell)  — flattened by the
   MEASURED envelope so the projection is not dominated by the largest-N end —
   and w_j is a HANN window over the available j of that depth, to suppress
   edge leakage.  When theta_rms is not finite for a cell, theta 0.0 is used
   for the flattening and the cell is flagged.

   Reported per cell: the gamma of the global maximum of P; P at
   gamma_1 = 14.134725, gamma_2 = 21.022040, gamma_3 = 25.010858; the MEDIAN of
   P over the grid; and P(gamma_i)/median(P) for each of the three.  The grid's
   frequency resolution 2*pi / (log N_last - log N_first) is also reported.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

Per (sigma, t, d), on the projection:

    DETECT  P has its GLOBAL MAXIMUM within 0.5 of one of gamma_1, gamma_2,
            gamma_3, AND that peak exceeds 5.0 x median(P)
    WEAK    a LOCAL peak within 0.5 of one of the three exceeds 5.0 x
            median(P), but the global maximum is elsewhere
    NULL    neither

Reported for every cell, counted across all cells, and reported separately for
sigma = 0.5, t = 0 — the headline case, where there is no t-oscillation to
confuse the gamma-oscillation.

=============================================================================
GATES — both RUN on every invocation and recorded in the payload
=============================================================================

GATE A — exact and analytic.  At sigma = 0.0, t = 0 every term is exactly 1, so
Delta_N = N EXACTLY, g_j = 1.0 EXACTLY on every rung, and every difference at
depth >= 1 is EXACTLY 0.0.  Verified to exact float equality.

GATE B — cross-instrument.  When invoked with --ratio 2.0 --ladder-base 125 the
ladder IS the dyadic one, and g_j must reproduce
`results/O14_residual_depth_ext.json` -> summary.series[*].g_triangle[k][0]
EXACTLY for every shared (sigma, t, N).  Expected values are READ FROM THAT
FILE; nothing is hardcoded.  When --ratio is not 2.0, gate B is recorded as
"not applicable" rather than failed.

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows`.  `params.code_version` is the sha256 of THIS file, read
from `__file__` at runtime.  `params.precision` is "float64".

REQUIREMENTS
------------
    pip install numpy

USAGE
-----
    python3 O15_fine_ladder_residual.py
    python3 O15_fine_ladder_residual.py --ratio 2.0 --out results/o15_dyadic.json
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
O14_EXT_RESULTS = os.path.join(_HERE, "results",
                               "O14_residual_depth_ext.json")

GAMMA_1 = 14.134725
GAMMA_2 = 21.022040
GAMMA_3 = 25.010858
GAMMAS = (GAMMA_1, GAMMA_2, GAMMA_3)

BAND_HALFWIDTH = 0.5
BAND_MEDIAN_FACTOR = 5.0


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
    """Exact primes by sieve of Eratosthenes. Mirrors O14/O9."""
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
    Byte-for-byte the same expression as O12's and O14's block_delta, so that
    gate B can require EXACT agreement rather than a tolerance.
    """
    p = primes[N:2 * N]
    lg = np.log(p)
    w = p ** (-sigma)
    return complex(np.sum(w * np.cos(t * lg)), -np.sum(w * np.sin(t * lg)))


def build_ladder(base, ratio, n_primes):
    """
    Geometric ladder N_j = round(base * ratio^j), kept while 2*N_j <= n_primes,
    DEDUPLICATED to strictly increasing values.

    Returns (ladder, raw_steps, collapsed_steps).
    """
    ladder = []
    raw = 0
    j = 0
    while True:
        Nf = float(base) * (float(ratio) ** j)
        N = int(round(Nf))
        if N < 1:
            N = 1
        if 2 * N > n_primes:
            break
        raw += 1
        if not ladder or N > ladder[-1]:
            ladder.append(N)
        j += 1
        if j > 10 ** 7:
            break
    return ladder, raw, raw - len(ladder)


def difference_table(g0, max_depth):
    """
    Backward-difference table along the ladder index j.

        G[j][0] = g0[j]
        G[j][d] = G[j][d-1] - G[j-1][d-1]      for 1 <= d <= min(j, max_depth)

    Returns a list of lists; row j has min(j, max_depth) + 1 entries.
    """
    tab = []
    for j, v in enumerate(g0):
        row = [v]
        for d in range(1, min(j, max_depth) + 1):
            prev = tab[j - 1]
            if (d - 1) >= len(prev):
                row.append(float("nan"))
                continue
            a, b = row[d - 1], prev[d - 1]
            if (a is None or b is None or not math.isfinite(a)
                    or not math.isfinite(b)):
                row.append(float("nan"))
            else:
                row.append(a - b)
        tab.append(row)
    return tab


def _rms(vals):
    """sqrt(mean(v^2)) over finite values; nan when empty or non-finite."""
    vs = [float(v) for v in vals if v is not None and math.isfinite(float(v))]
    if not vs:
        return float("nan")
    return math.sqrt(sum(v * v for v in vs) / len(vs))


def _geomean(vals):
    """Geometric mean of strictly positive values; nan otherwise."""
    vs = [float(v) for v in vals
          if v is not None and math.isfinite(float(v)) and float(v) > 0.0]
    if not vs:
        return float("nan")
    return math.exp(sum(math.log(v) for v in vs) / len(vs))


def theta_rms_two_point(pairs):
    """
    Two-point RMS envelope exponent over (N_j, value) pairs, ordered by j.

        theta_rms = -( ln RMS_hi - ln RMS_lo ) / ( ln NM_hi - ln NM_lo )

    Halves are pairs[:n//2] and pairs[-(n//2):]; when n is odd the middle rung
    is dropped so the two halves are the same size and disjoint.

    NOT a least-squares fit — a two-point ratio.  Returns a dict.
    """
    out = {"n": len(pairs), "n_half": 0,
           "rms_lo": None, "rms_hi": None, "nm_lo": None, "nm_hi": None,
           "theta_rms": None}
    n = len(pairs)
    half = n // 2
    out["n_half"] = half
    if half < 1:
        out["theta_rms"] = float("nan")
        return out
    lo = pairs[:half]
    hi = pairs[-half:]
    rms_lo = _rms([v for _, v in lo])
    rms_hi = _rms([v for _, v in hi])
    nm_lo = _geomean([N for N, _ in lo])
    nm_hi = _geomean([N for N, _ in hi])
    out["rms_lo"], out["rms_hi"] = rms_lo, rms_hi
    out["nm_lo"], out["nm_hi"] = nm_lo, nm_hi
    if (not math.isfinite(rms_lo) or not math.isfinite(rms_hi)
            or rms_lo <= 0.0 or rms_hi <= 0.0
            or not math.isfinite(nm_lo) or not math.isfinite(nm_hi)
            or nm_lo <= 0.0 or nm_hi <= 0.0):
        out["theta_rms"] = float("nan")
        return out
    den = math.log(nm_hi) - math.log(nm_lo)
    if den == 0.0:
        out["theta_rms"] = float("nan")
        return out
    out["theta_rms"] = -(math.log(rms_hi) - math.log(rms_lo)) / den
    return out


def _drop_index(pairs, want_largest):
    """Index of the single largest (or smallest) |value| among finite entries."""
    best_i, best_v = None, None
    for i, (_, v) in enumerate(pairs):
        if v is None or not math.isfinite(float(v)):
            continue
        a = abs(float(v))
        if best_v is None or (a > best_v if want_largest else a < best_v):
            best_i, best_v = i, a
    return best_i


def hann(n):
    """Hann window over n points: 0.5 - 0.5 cos(2 pi i / (n-1)). n<=1 -> ones."""
    if n <= 1:
        return np.ones(max(n, 0), dtype=np.float64)
    i = np.arange(n, dtype=np.float64)
    return 0.5 - 0.5 * np.cos(2.0 * math.pi * i / (n - 1))


def project(logN, ghat, w, gammas):
    """P(gamma) = | sum_j w_j ghat_j exp(-i gamma log N_j) | on a gamma grid."""
    if len(logN) == 0:
        return np.zeros(len(gammas), dtype=np.float64)
    a = (w * ghat).astype(np.float64)
    ph = np.outer(gammas, logN)
    re = np.cos(ph) @ a
    im = -(np.sin(ph) @ a)
    return np.sqrt(re * re + im * im)


def _nearest_gamma(x):
    """(index, distance) of the nearest of gamma_1..gamma_3 to x."""
    best_i, best_d = None, None
    for i, gm in enumerate(GAMMAS):
        d = abs(x - gm)
        if best_d is None or d < best_d:
            best_i, best_d = i, d
    return best_i, best_d


def classify_projection(gammas, P, halfwidth, factor):
    """
    Mechanical application of the pre-registered bands.

    DETECT : global max of P lies within `halfwidth` of one of gamma_1..3 AND
             exceeds `factor` x median(P)
    WEAK   : a LOCAL peak within `halfwidth` of one of the three exceeds
             `factor` x median(P), but the global max is elsewhere
    NULL   : neither
    """
    out = {"verdict": "NULL", "argmax_gamma": None, "P_max": None,
           "P_median": None, "P_max_over_median": None,
           "argmax_nearest_gamma_index": None,
           "argmax_distance_to_nearest": None,
           "weak_peak_gamma": None, "weak_peak_over_median": None,
           "P_at_gamma": [None, None, None],
           "P_at_gamma_over_median": [None, None, None]}
    if P.size == 0:
        return out
    med = float(np.median(P))
    out["P_median"] = med
    imax = int(np.argmax(P))
    gmax = float(gammas[imax])
    pmax = float(P[imax])
    out["argmax_gamma"] = gmax
    out["P_max"] = pmax
    out["P_max_over_median"] = _safe_div(pmax, med)

    for i, gm in enumerate(GAMMAS):
        k = int(np.argmin(np.abs(gammas - gm)))
        out["P_at_gamma"][i] = float(P[k])
        out["P_at_gamma_over_median"][i] = _safe_div(float(P[k]), med)

    ni, nd = _nearest_gamma(gmax)
    out["argmax_nearest_gamma_index"] = ni
    out["argmax_distance_to_nearest"] = nd

    thresh_ok = (math.isfinite(med) and med > 0.0 and pmax > factor * med)
    if nd is not None and nd <= halfwidth and thresh_ok:
        out["verdict"] = "DETECT"
        return out

    # local peaks (strict interior maxima) inside any band
    best_g, best_r = None, None
    if math.isfinite(med) and med > 0.0 and P.size >= 3:
        for k in range(1, P.size - 1):
            if not (P[k] > P[k - 1] and P[k] > P[k + 1]):
                continue
            g = float(gammas[k])
            _, d = _nearest_gamma(g)
            if d > halfwidth:
                continue
            if P[k] > factor * med:
                r = float(P[k]) / med
                if best_r is None or r > best_r:
                    best_g, best_r = g, r
    if best_g is not None:
        out["verdict"] = "WEAK"
        out["weak_peak_gamma"] = best_g
        out["weak_peak_over_median"] = best_r
    return out


def main():
    ap = argparse.ArgumentParser(
        description="O15 — fine-ladder residual: resample O14's g(N) on a "
                    "geometric ladder that does not alias gamma, and project "
                    "onto cos(gamma log N)")
    ap.add_argument("--pmax", type=int, default=150000000,
                    help="sieve limit for the prime list (default 150000000)")
    ap.add_argument("--ladder-base", type=int, default=125,
                    help="first rung N of the geometric ladder (default 125)")
    ap.add_argument("--ratio", type=float, default=1.1,
                    help="geometric ladder ratio r (default 1.1); r=2.0 "
                         "reproduces O14's dyadic ladder and arms gate B")
    ap.add_argument("--max-depth", type=int, default=8,
                    help="maximum difference depth along j (default 8); the "
                         "full table to this depth is stored")
    ap.add_argument("--sigmas", type=str, default="0.0,0.5,1.0",
                    help="comma-separated sigma values (default 0.0,0.5,1.0)")
    ap.add_argument("--tvals", type=str, default="0,14.5",
                    help="comma-separated t values (default 0,14.5); t=0 "
                         "first and deliberate — no t-oscillation there")
    ap.add_argument("--gamma-max", type=float, default=30.0,
                    help="upper end of the gamma projection grid (default 30)")
    ap.add_argument("--gamma-step", type=float, default=0.02,
                    help="gamma projection grid step (default 0.02)")
    ap.add_argument("--o14-ext-results", type=str, default=O14_EXT_RESULTS,
                    help="path to O14's extended results JSON, read by gate B")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    sigmas = [float(x) for x in args.sigmas.split(",")]
    tvals = [float(x) for x in args.tvals.split(",")]
    max_depth = max(0, int(args.max_depth))
    r = float(args.ratio)

    nyquist = _safe_div(math.pi, math.log(r)) if r > 0 else float("nan")
    dyadic_nyquist = math.pi / math.log(2.0)

    print("=" * 78, flush=True)
    print("O15 — fine-ladder residual  (fit-free; two-point exponent; "
          "projection, not fit)", flush=True)
    print("=" * 78, flush=True)
    print("  Delta_N = sum over primes[N:2N] of p^(-sigma) exp(-i t log p)",
          flush=True)
    print("  g(N)    = |Delta_N| / N^(1-sigma)          (UNCHANGED from O14)",
          flush=True)
    print(f"  ladder  : N_j = round({args.ladder_base} * {r:g}^j), "
          f"kept while 2N_j <= n_primes", flush=True)
    print(f"  log-N step = log(r) = {math.log(r):.7f}   "
          f"(dyadic ladder: log 2 = {math.log(2.0):.7f})", flush=True)
    print(f"  Nyquist = pi/log(r) = {nyquist:.6f}   "
          f"(dyadic ladder: {dyadic_nyquist:.6f})", flush=True)
    print(f"  gamma_1 = {GAMMA_1}, gamma_2 = {GAMMA_2}, "
          f"gamma_3 = {GAMMA_3}", flush=True)
    for gi, gm in enumerate(GAMMAS, start=1):
        print(f"    gamma_{gi} {'BELOW' if gm < nyquist else 'ABOVE'} Nyquist "
              f"({gm} vs {nyquist:.6f})", flush=True)
    print("  a difference along j is a difference over a log-N step of log(r),",
          flush=True)
    print("  NOT log(2) — depth-d values are not comparable to O14's unless "
          "r = 2.", flush=True)
    print("  consecutive rungs OVERLAP (block is still N -> 2N); that is "
          "intended", flush=True)
    print("  oversampling of a function, not a redefinition of it.", flush=True)

    # ---------------- sieve ------------------------------------------------
    print(f"\n  sieving primes to {args.pmax}...", flush=True)
    primes = sieve_primes(args.pmax)
    n_primes = int(len(primes))
    largest_prime = int(primes[-1]) if n_primes else None
    print(f"  {n_primes} primes, largest = {largest_prime}", flush=True)

    # ---------------- ladder ----------------------------------------------
    ladder, raw_steps, collapsed = build_ladder(args.ladder_base, r, n_primes)
    J = len(ladder)
    print(f"  raw ladder steps generated : {raw_steps}", flush=True)
    print(f"  collapsed by rounding      : {collapsed}", flush=True)
    print(f"  rungs kept (strictly increasing) : {J}", flush=True)
    if not ladder:
        print("  ERROR: no ladder rung survives; raise --pmax.", flush=True)
        ladder_first = ladder_last = None
        freq_res = float("nan")
        logN_all = np.zeros(0, dtype=np.float64)
    else:
        ladder_first, ladder_last = ladder[0], ladder[-1]
        logN_all = np.log(np.asarray(ladder, dtype=np.float64))
        span = float(logN_all[-1] - logN_all[0])
        freq_res = _safe_div(2.0 * math.pi, span)
        print(f"  first N = {ladder_first}   last N = {ladder_last}",
              flush=True)
        print(f"  log-N span = {span:.7f}", flush=True)
        print(f"  frequency resolution 2*pi/(log N_last - log N_first) = "
              f"{freq_res:.6f}", flush=True)
        print(f"  largest prime index used : {2 * ladder_last - 1} "
              f"(value {int(primes[2 * ladder_last - 1])})", flush=True)
    print(f"  sigmas : {sigmas}", flush=True)
    print(f"  t vals : {tvals}", flush=True)
    print(f"  depths : 0..{max_depth}", flush=True)

    gammas = np.arange(0.0, args.gamma_max + 0.5 * args.gamma_step,
                       args.gamma_step, dtype=np.float64)
    n_gamma = int(gammas.size)
    print(f"  gamma grid : 0 to {args.gamma_max:g} step {args.gamma_step:g}  "
          f"({n_gamma} points)", flush=True)
    print(f"  bands (PRE-REGISTERED, fixed before the run): |gamma - gamma_i| "
          f"<= {BAND_HALFWIDTH:g} and P > {BAND_MEDIAN_FACTOR:g} x median(P)",
          flush=True)

    # ---------------- the series ------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("LADDER SERIES — one block per (sigma, t)", flush=True)
    print("-" * 78, flush=True)

    rows = []
    series = []
    cells = []

    for sg in sigmas:
        for t in tvals:
            absD = []
            g0 = []
            for N in ladder:
                d = block_delta(primes, N, sg, t)
                ad = abs(d)
                absD.append(ad)
                g0.append(_safe_div(ad, float(N) ** (1.0 - sg)))

            tab = difference_table(g0, max_depth)

            print(f"\n  ==== sigma = {sg:g}   t = {t:g}"
                  f"{'   (non-oscillatory row)' if t == 0.0 else ''}",
                  flush=True)
            hdr = f"  {'j':>4} {'N_j':>10} {'|Delta_N|':>20}"
            for d in range(0, max_depth + 1):
                hdr += f"{('G[j,%d]' % d):>18}"
            print(hdr, flush=True)
            for jj in range(J):
                line = f"  {jj:>4} {ladder[jj]:>10} {_fmtg(absD[jj], 20, 12)}"
                for d in range(0, max_depth + 1):
                    v = tab[jj][d] if d < len(tab[jj]) else None
                    line += _fmtg(v, 18, 10)
                print(line, flush=True)

            # ---- per-depth: theta_rms + projection ----
            print(f"\n  ENVELOPE EXPONENT theta_rms  (TWO-POINT RATIO OF "
                  f"HALF-LADDER RMS, NOT A FIT)", flush=True)
            print(f"  {'d':>3} {'n_rungs':>8} {'n_half':>7} {'RMS_lo':>16} "
                  f"{'RMS_hi':>16} {'NM_lo':>14} {'NM_hi':>14} "
                  f"{'theta_rms':>13} {'theta_no_max':>13} "
                  f"{'theta_no_min':>13}", flush=True)

            depth_recs = []
            for d in range(0, max_depth + 1):
                pairs = []
                for jj in range(J):
                    if d < len(tab[jj]):
                        v = tab[jj][d]
                        if v is not None and math.isfinite(v):
                            pairs.append((float(ladder[jj]), float(v)))
                        else:
                            pairs.append((float(ladder[jj]), float("nan")))
                pairs = [(N, v) for N, v in pairs if math.isfinite(v)]

                base = theta_rms_two_point(pairs)
                i_max = _drop_index(pairs, True)
                i_min = _drop_index(pairs, False)
                p_no_max = ([p for i, p in enumerate(pairs) if i != i_max]
                            if i_max is not None else list(pairs))
                p_no_min = ([p for i, p in enumerate(pairs) if i != i_min]
                            if i_min is not None else list(pairs))
                no_max = theta_rms_two_point(p_no_max)
                no_min = theta_rms_two_point(p_no_min)

                th = base["theta_rms"]
                th_used = th if (th is not None and math.isfinite(th)) else 0.0
                th_fallback = not (th is not None and math.isfinite(th))

                print(f"  {d:>3} {len(pairs):>8} {base['n_half']:>7} "
                      f"{_fmtg(base['rms_lo'], 16, 8)} "
                      f"{_fmtg(base['rms_hi'], 16, 8)} "
                      f"{_fmtg(base['nm_lo'], 14, 7)} "
                      f"{_fmtg(base['nm_hi'], 14, 7)} "
                      f"{_fmt(th, 13, 6)} "
                      f"{_fmt(no_max['theta_rms'], 13, 6)} "
                      f"{_fmt(no_min['theta_rms'], 13, 6)}", flush=True)

                # projection
                Nv = np.asarray([N for N, _ in pairs], dtype=np.float64)
                Gv = np.asarray([v for _, v in pairs], dtype=np.float64)
                if Nv.size:
                    lgN = np.log(Nv)
                    ghat = Gv * (Nv ** th_used)
                    w = hann(Nv.size)
                    P = project(lgN, ghat, w, gammas)
                else:
                    lgN = np.zeros(0, dtype=np.float64)
                    P = np.zeros(n_gamma, dtype=np.float64)
                cls = classify_projection(gammas, P, BAND_HALFWIDTH,
                                          BAND_MEDIAN_FACTOR)

                rec = {
                    "sigma": sg, "t": t, "depth": d,
                    "n_rungs_used": len(pairs),
                    "n_half": base["n_half"],
                    "rms_lo": base["rms_lo"], "rms_hi": base["rms_hi"],
                    "nm_lo": base["nm_lo"], "nm_hi": base["nm_hi"],
                    "theta_rms": th,
                    "theta_rms_excl_largest_abs": no_max["theta_rms"],
                    "theta_rms_excl_smallest_abs": no_min["theta_rms"],
                    "theta_used_for_flattening": th_used,
                    "theta_fallback_to_zero": bool(th_fallback),
                    "excluded_largest_N": (pairs[i_max][0]
                                           if i_max is not None else None),
                    "excluded_largest_value": (pairs[i_max][1]
                                               if i_max is not None else None),
                    "excluded_smallest_N": (pairs[i_min][0]
                                            if i_min is not None else None),
                    "excluded_smallest_value": (pairs[i_min][1]
                                                if i_min is not None else None),
                    "window": "hann",
                    "projection": cls,
                    "verdict": cls["verdict"],
                }
                depth_recs.append(rec)
                cells.append(rec)
                rows.append(rec)

            print(f"\n  PROJECTION P(gamma) = |sum_j w_j Ghat[j,d] "
                  f"exp(-i gamma log N_j)|   (hann window; inner product, "
                  f"NOT a fit)", flush=True)
            print(f"  {'d':>3} {'argmax gamma':>13} {'P_max/med':>12} "
                  f"{'P(g1)/med':>12} {'P(g2)/med':>12} {'P(g3)/med':>12} "
                  f"{'median P':>14} {'verdict':>8}", flush=True)
            for rec in depth_recs:
                pr = rec["projection"]
                print(f"  {rec['depth']:>3} {_fmt(pr['argmax_gamma'], 13, 4)} "
                      f"{_fmt(pr['P_max_over_median'], 12, 4)} "
                      f"{_fmt(pr['P_at_gamma_over_median'][0], 12, 4)} "
                      f"{_fmt(pr['P_at_gamma_over_median'][1], 12, 4)} "
                      f"{_fmt(pr['P_at_gamma_over_median'][2], 12, 4)} "
                      f"{_fmtg(pr['P_median'], 14, 6)} "
                      f"{rec['verdict']:>8}", flush=True)

            series.append({
                "sigma": sg, "t": t, "J": J, "ladder": ladder,
                "absD": absD, "g0": g0, "g_table": tab,
                "depths": depth_recs,
            })

    # ---------------- GATE A ----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — exact analytic check at sigma = 0.0, t = 0", flush=True)
    print("-" * 78, flush=True)
    print("  every term is exactly 1 => Delta_N = N exactly, g_j = 1.0 "
          "exactly,", flush=True)
    print("  and every difference at depth >= 1 is exactly 0.0. Tested to "
          "exact float equality.", flush=True)
    gate_a_passed = None
    gate_a_rows = []
    gate_a_summary = {}
    ref = next((s for s in series if s["sigma"] == 0.0 and s["t"] == 0.0),
               None)
    if ref is None:
        print("  GATE A NOT RUN — (sigma=0.0, t=0) is not in the requested "
              "grid; recorded as null.", flush=True)
    else:
        gate_a_passed = True
        n_bad_d = n_bad_g = n_bad_deep = 0
        worst_deep = 0.0
        for jj in range(ref["J"]):
            Nj = ref["ladder"][jj]
            ad = ref["absD"][jj]
            gv = ref["g0"][jj]
            ok_d = (ad == float(Nj))
            ok_g = (gv == 1.0)
            deep = ref["g_table"][jj][1:]
            ok_deep = all(v == 0.0 for v in deep)
            md = max((abs(v) for v in deep), default=0.0)
            worst_deep = max(worst_deep, md)
            n_bad_d += (0 if ok_d else 1)
            n_bad_g += (0 if ok_g else 1)
            n_bad_deep += (0 if ok_deep else 1)
            ok = bool(ok_d and ok_g and ok_deep)
            gate_a_passed = gate_a_passed and ok
            gate_a_rows.append({
                "j": jj, "N": Nj, "absD": ad,
                "absD_equals_N_exactly": ok_d,
                "g0": gv, "g0_equals_one_exactly": ok_g,
                "n_deep": len(deep), "all_deep_exactly_zero": ok_deep,
                "max_abs_deep": md, "passed": ok,
            })
        gate_a_summary = {
            "n_rungs": ref["J"],
            "n_absD_not_exactly_N": n_bad_d,
            "n_g0_not_exactly_one": n_bad_g,
            "n_rungs_with_nonzero_deep": n_bad_deep,
            "max_abs_deep_over_all_rungs": worst_deep,
        }
        print(f"  rungs tested                        : {ref['J']}", flush=True)
        print(f"  rungs where |Delta_N| != N exactly  : {n_bad_d}", flush=True)
        print(f"  rungs where g_j != 1.0 exactly      : {n_bad_g}", flush=True)
        print(f"  rungs with a nonzero deep difference: {n_bad_deep}",
              flush=True)
        print(f"  max |difference| at depth >= 1      : {worst_deep:.3e}",
              flush=True)
        if gate_a_passed:
            print("\n  GATE A PASSED — exact to float equality on every rung "
                  "and every depth.", flush=True)
        else:
            print("\n  " + "*" * 70, flush=True)
            print("  *** GATE A FAILED *** the analytic identity at sigma=0, "
                  "t=0 does not hold", flush=True)
            print("  *** exactly. Every number above is suspect.", flush=True)
            print("  " + "*" * 70, flush=True)
            for rr in gate_a_rows:
                if not rr["passed"]:
                    print(f"    j={rr['j']} N={rr['N']} absD={rr['absD']!r} "
                          f"g0={rr['g0']!r} maxdeep={rr['max_abs_deep']:.3e}",
                          flush=True)

    # ---------------- GATE B ----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE B — cross-instrument against O14's g_triangle[k][0]",
          flush=True)
    print("-" * 78, flush=True)
    gate_b_passed = None
    gate_b_note = None
    gate_b_n_shared = 0
    gate_b_worst_rel = None
    gate_b_worst_cell = None
    gate_b_failures = []
    if abs(r - 2.0) > 0.0:
        gate_b_note = (f"not applicable: --ratio {r:g} is not 2.0, so this "
                       "ladder is not O14's dyadic ladder")
        print(f"  {gate_b_note}", flush=True)
        print("  gate_b_passed recorded as null; gate_b_note records "
              "'not applicable'.", flush=True)
    else:
        print(f"  source: {args.o14_ext_results}", flush=True)
        print("  requires EXACT equality of g_j against "
              "summary.series[*].g_triangle[k][0]", flush=True)
        o14_map = None
        try:
            with open(args.o14_ext_results, "r") as fh:
                o14 = json.load(fh)
            o14_map = {}
            for s in o14.get("summary", {}).get("series", []):
                lad = s.get("ladder", [])
                tri = s.get("g_triangle", [])
                for k, Nk in enumerate(lad):
                    if k < len(tri) and tri[k] and tri[k][0] is not None:
                        o14_map[(float(s["sigma"]), float(s["t"]),
                                 int(Nk))] = float(tri[k][0])
            gate_b_note = (f"read {len(o14_map)} O14 g_triangle[k][0] cells "
                           f"from {os.path.basename(args.o14_ext_results)}")
            print(f"  {gate_b_note}", flush=True)
        except Exception as exc:
            o14_map = None
            gate_b_note = f"O14 extended results not readable: {exc}"
            print(f"  {gate_b_note}", flush=True)
            print("  GATE B NOT RUN — gate_b_passed recorded as null.",
                  flush=True)

        if o14_map:
            gate_b_passed = True
            worst = -1.0
            for s in series:
                for jj, Nj in enumerate(s["ladder"]):
                    key = (float(s["sigma"]), float(s["t"]), int(Nj))
                    if key not in o14_map:
                        continue
                    exp = o14_map[key]
                    got = s["g0"][jj]
                    gate_b_n_shared += 1
                    ok = (got == exp)
                    rel = (0.0 if ok else _safe_div(abs(got - exp), abs(exp)))
                    gate_b_passed = gate_b_passed and ok
                    if math.isfinite(rel) and rel > worst:
                        worst = rel
                        gate_b_worst_cell = {
                            "sigma": key[0], "t": key[1], "N": key[2],
                            "o15_g0": got, "o14_g0": exp, "rel_err": rel}
                    if not ok:
                        gate_b_failures.append({
                            "sigma": key[0], "t": key[1], "N": key[2],
                            "o15_g0": got, "o14_g0": exp, "rel_err": rel})
            gate_b_worst_rel = worst if worst >= 0.0 else None
            print(f"  shared cells compared : {gate_b_n_shared}", flush=True)
            if gate_b_n_shared == 0:
                gate_b_passed = None
                gate_b_note = (gate_b_note or "") + \
                    "; no shared (sigma,t,N) cells"
                print("  NO SHARED CELLS — gate_b_passed recorded as null.",
                      flush=True)
            else:
                wr = gate_b_worst_rel
                print(f"  worst relative error  : "
                      f"{'0 (exact)' if wr == 0.0 else format(wr, '.6e')}",
                      flush=True)
                if gate_b_worst_cell is not None:
                    print(f"  worst cell            : "
                          f"sigma={gate_b_worst_cell['sigma']:g}, "
                          f"t={gate_b_worst_cell['t']:g}, "
                          f"N={gate_b_worst_cell['N']}", flush=True)
                if gate_b_passed:
                    print("\n  GATE B PASSED — g_j reproduces O14 EXACTLY on "
                          "every shared cell.", flush=True)
                else:
                    print("\n  " + "*" * 70, flush=True)
                    print(f"  *** GATE B FAILED *** {len(gate_b_failures)} "
                          "shared cell(s) differ from O14.", flush=True)
                    print("  " + "*" * 70, flush=True)
                    for rr in gate_b_failures[:20]:
                        print(f"    sigma={rr['sigma']:g} t={rr['t']:g} "
                              f"N={rr['N']} rel={rr['rel_err']:.3e}",
                              flush=True)

    # ---------------- verdict matrix --------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("BAND VERDICT MATRIX — pre-registered, applied mechanically",
          flush=True)
    print("-" * 78, flush=True)
    hdr = f"  {'sigma':>7} {'t':>7} " + "".join(
        f"{('d=' + str(d)):>10}" for d in range(0, max_depth + 1))
    print(hdr, flush=True)
    for sg in sigmas:
        for t in tvals:
            line = f"  {sg:>7.2f} {t:>7g} "
            for d in range(0, max_depth + 1):
                v = next((c["verdict"] for c in cells
                          if c["sigma"] == sg and c["t"] == t
                          and c["depth"] == d), "—")
                line += f"{v:>10}"
            print(line, flush=True)

    verdict_counts = {}
    for c in cells:
        verdict_counts[c["verdict"]] = verdict_counts.get(c["verdict"], 0) + 1
    print(f"\n  verdict counts over {len(cells)} (sigma, t, depth) cells:",
          flush=True)
    for k in sorted(verdict_counts):
        print(f"    {k:<10} {verdict_counts[k]:>4}", flush=True)

    # ---------------- headline case ---------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("HEADLINE CASE — sigma = 0.5, t = 0 (no t-oscillation to confuse "
          "the gamma-oscillation)", flush=True)
    print("-" * 78, flush=True)
    head = [c for c in cells if c["sigma"] == 0.5 and c["t"] == 0.0]
    headline = []
    if not head:
        print("  NOT PRESENT in the requested grid.", flush=True)
    else:
        print(f"  {'d':>3} {'n':>5} {'theta_rms':>12} {'no_max':>12} "
              f"{'no_min':>12} {'argmax g':>10} {'Pmax/med':>10} "
              f"{'P(g1)/med':>10} {'P(g2)/med':>10} {'P(g3)/med':>10} "
              f"{'verdict':>8}", flush=True)
        for c in head:
            pr = c["projection"]
            print(f"  {c['depth']:>3} {c['n_rungs_used']:>5} "
                  f"{_fmt(c['theta_rms'], 12, 6)} "
                  f"{_fmt(c['theta_rms_excl_largest_abs'], 12, 6)} "
                  f"{_fmt(c['theta_rms_excl_smallest_abs'], 12, 6)} "
                  f"{_fmt(pr['argmax_gamma'], 10, 3)} "
                  f"{_fmt(pr['P_max_over_median'], 10, 3)} "
                  f"{_fmt(pr['P_at_gamma_over_median'][0], 10, 3)} "
                  f"{_fmt(pr['P_at_gamma_over_median'][1], 10, 3)} "
                  f"{_fmt(pr['P_at_gamma_over_median'][2], 10, 3)} "
                  f"{c['verdict']:>8}", flush=True)
            headline.append(c)

    # ---------------- read the result -------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  Only the SAMPLING changed from O14; g(N) is the same function.",
          flush=True)
    print(f"  Nyquist on this ladder = {nyquist:.6f}; frequency resolution = "
          f"{freq_res:.6f}.", flush=True)
    print("  theta_rms is a TWO-POINT RATIO of half-ladder RMS values, not a "
          "fit.", flush=True)
    print("  P(gamma) is an INNER PRODUCT against exp(-i gamma log N), not a "
          "fit.", flush=True)
    print("  The bands were fixed before the run and applied mechanically.",
          flush=True)
    print(f"  gate A (exact, sigma=0, t=0) : "
          f"{'PASSED' if gate_a_passed else ('NOT RUN' if gate_a_passed is None else 'FAILED')}",
          flush=True)
    print(f"  gate B (cross-instrument)    : "
          f"{'PASSED' if gate_b_passed else ('NOT RUN / N-A' if gate_b_passed is None else 'FAILED')}",
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
                "ratio": r,
                "ladder": ladder,
                "ladder_rungs": J,
                "ladder_raw_steps": raw_steps,
                "ladder_collapsed_steps": collapsed,
                "ladder_first": ladder_first,
                "ladder_last": ladder_last,
                "log_ratio": math.log(r) if r > 0 else None,
                "nyquist_gamma": nyquist,
                "dyadic_nyquist_gamma": dyadic_nyquist,
                "frequency_resolution": freq_res,
                "largest_prime_index_used": (2 * ladder_last - 1
                                             if ladder_last else None),
                "largest_prime_value_used": (int(primes[2 * ladder_last - 1])
                                             if ladder_last else None),
                "sigmas": sigmas,
                "tvals": tvals,
                "t_zero_first": bool(tvals and tvals[0] == 0.0),
                "max_depth": max_depth,
                "gamma_max": args.gamma_max,
                "gamma_step": args.gamma_step,
                "n_gamma": n_gamma,
                "window": "hann",
                "o14_ext_results_path": args.o14_ext_results,
                "delta_definition": ("direct numpy sum over primes[N:2N] of "
                                     "p^(-sigma)*(cos(t log p) - i sin(t log p))"),
                "normalisation": "g(N) = |Delta_N| / N^(1-sigma)",
                "difference_convention":
                    "backward along ladder index j: G[j,d] = G[j,d-1] - "
                    "G[j-1,d-1]; the log-N step is log(r), not log(2)",
                "theta_definition":
                    "theta_rms = -(ln RMS_hi - ln RMS_lo)/(ln NM_hi - ln NM_lo); "
                    "half-ladder RMS two-point ratio, NOT a least-squares fit",
                "projection_definition":
                    "P(gamma) = |sum_j w_j * G[j,d] * N_j^theta_rms * "
                    "exp(-i gamma log N_j)|, w = hann; inner product, not a fit",
                "band_halfwidth": BAND_HALFWIDTH,
                "band_median_factor": BAND_MEDIAN_FACTOR,
                "fit_free": True,
                "precision": "float64",
            },
            "constants": {
                "gamma_1": GAMMA_1,
                "gamma_2": GAMMA_2,
                "gamma_3": GAMMA_3,
                "envelope_law": "|Delta_N| ~ N^(1-sigma)  (O12, fit-free)",
                "aliasing_note": (
                    "a dyadic ladder samples log N in steps of log 2, Nyquist "
                    "pi/log2 = 4.5323601, far below gamma_1 = 14.134725; every "
                    "zero-height oscillation aliases there. This script's "
                    "ladder ratio r sets Nyquist = pi/log(r)"),
                "band_rule": (
                    "DETECT: global max of P within 0.5 of gamma_1..3 AND > 5x "
                    "median(P); WEAK: a local peak within 0.5 of one of the "
                    "three > 5x median(P) but global max elsewhere; NULL: "
                    "neither"),
                "o10_note": (
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script"),
                "overlap_note": (
                    "consecutive ladder points overlap because the block is "
                    "still N -> 2N; this is oversampling of g(N), not a "
                    "redefinition of it"),
            },
            "summary": {
                "gate_a_passed": (None if gate_a_passed is None
                                  else bool(gate_a_passed)),
                "gate_a_summary": gate_a_summary,
                "gate_a": gate_a_rows,
                "gate_b_passed": (None if gate_b_passed is None
                                  else bool(gate_b_passed)),
                "gate_b_note": gate_b_note,
                "gate_b_n_shared_cells": gate_b_n_shared,
                "gate_b_worst_rel_err": gate_b_worst_rel,
                "gate_b_worst_cell": gate_b_worst_cell,
                "gate_b_failures": gate_b_failures,
                "n_series": len(series),
                "n_cells": len(cells),
                "ladder_rungs": J,
                "verdict_counts": verdict_counts,
                "headline_sigma_0p5_t_0": headline,
                "series": series,
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
