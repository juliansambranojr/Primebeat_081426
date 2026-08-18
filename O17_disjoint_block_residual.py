#!/usr/bin/env python3
"""
O17 — Disjoint-block residual: tile VALUE space with disjoint geometric intervals,
      count primes exactly in each, subtract the smooth li-prediction, and project
      the residual onto exp(-i gamma log x).  No fitting anywhere.

Reads with: O12_dyadic_block_ratio.py; O14_residual_depth.py;
O15_fine_ladder_residual.py; O16_centered_difference_table.py; DT-A5; DT-A6;
this bench's `pi2n_cache.json` (READ ONLY).

NAMING
------
The O-series in this tree runs O1-O9, O11, O12, O13, O14, O15, O16.  There is NO
O10: that number is a known, DELIBERATE GAP, and this script does not fill it,
because filling a reserved gap with unrelated work would silently rewrite the
series' history.  The next free number after O16 is O17; this file takes it.
Capital "O" per `CLAUDE.md` § "Naming convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

O12-O15 all summed over primes[N:2N], indexed by PRIME INDEX.  Two consequences
made those instruments blind:

  1. Consecutive rungs OVERLAPPED.  At ladder ratio 1.1 two neighbouring rungs
     shared ~90% of their primes, so O15's 110 rungs carried only ~16 blocks'
     worth of independent data.  Oversampling a function is legitimate, but it
     does not create independent samples.

  2. Indexing by PRIME INDEX fixes the COUNT per block by construction — the
     slice primes[N:2N] holds exactly N terms whatever the primes do.  A count
     that is fixed by construction carries no fluctuation at all.  Whatever
     fluctuates lives in the VALUES, not in the count.

This script tiles VALUE space instead.  That is the fine-grained analogue of the
dyadic difference table's own construction, whose blocks are the half-open
intervals (2^(r-1), 2^r]:

    x_j = x0 * r^j                                (value ladder, ratio r)
    c_j = pi(x_{j+1}) - pi(x_j)                   (primes in (x_j, x_{j+1}])
    L_j = li(x_{j+1}) - li(x_j)                   (the smooth prediction)
    e_j = c_j - L_j                               (the residual)

`e` is the project's core quantity — CONTEXT.md § "Core quantities" defines
`e(r)` as `c_n - (li(2^n) - li(2^(n-1)))`, which is exactly the above at
x0 = 2, r = 2.

The blocks are DISJOINT and they TILE the range, so every prime in
(x_0, x_last] is used exactly once and every block is an independent sample.
The count now fluctuates, because the interval is fixed in VALUE space rather
than in index space.

SAMPLING
--------
log x steps by log(r), so the projection's Nyquist limit is pi / log(r).  At the
default r = 1.1 that is 32.963, which clears gamma_1 = 14.134725,
gamma_2 = 21.022040 and gamma_3 = 25.010858.

=============================================================================
WHAT IS COMPUTED
=============================================================================

1. Sieve to --xmax with a numpy boolean sieve (mirrors sieve_primes in
   O15/O16's lineage), kept as a sorted int64 array.  Prime count and largest
   prime reported.

2. The value ladder x_j = x0 * r^j, j = 0.. while x_j <= xmax.  Rung count,
   first and last x, and the achieved Nyquist reported.

3. c_j by np.searchsorted(primes, x, side="right") differenced at the two
   endpoints — EXACT INTEGER counts.  No float approximation to pi(x) is used
   anywhere.

4. L_j, the smooth term, selected by --smooth {li, R}, DEFAULT R:

       --smooth li   L_j = li(x_{j+1}) - li(x_j)
       --smooth R    L_j = R(x_{j+1}) - R(x_j)

   with R Riemann's function R(x) = sum_{n>=1} mu(n)/n * li(x^(1/n))
   = li(x) - (1/2)li(sqrt(x)) - (1/3)li(x^(1/3)) - ...  The dropped
   -(1/2)li(sqrt(x)) term of the li model accounts for the prime SQUARES and
   grows like x^(1/2), the same exponent the residual envelope measures.
   R is `mpmath.riemannr` when available; otherwise an explicit Mobius sum
   truncated where x^(1/n) < 2. Which one was used is recorded in
   params.riemannr_impl. Both computed in mpf at mp.dps >= 30, differenced at
   high precision and cast to float only at the end.

   DIAGNOSTIC, computed every run regardless of --smooth:

       D_j = (li(x_{j+1}) - li(x_j)) - (R(x_{j+1}) - R(x_j))

   with min / max / mean / RMS of D_j / sqrt(x_j) reported, alongside the
   closed-form (sqrt(ratio) - 1)/log(x_j) at the first and last rung. Both are
   STATED; the script does not interpret them.

5. e_j = c_j - L_j, and its normalisation

       ehat_j = e_j / sqrt(x_j)

   min / max / mean / RMS of ehat over the ladder are reported, so whether the
   residual envelope is O(1) at the half-power is directly visible.

   ALSO, as a PARAMETER-FREE SCAN and NOT A FIT: ehat with sqrt replaced by
   x_j^theta over a FIXED GRID theta = --theta-min .. --theta-max inclusive in
   steps of --theta-step (default 0.20 .. 0.80 step 0.02, 31 values).  For each
   theta the RMS over the lower half and the upper half of the ladder and their
   ratio are reported.  A ratio near 1 means that theta flattens it.  Nothing
   is optimised and no theta is selected.  The ORIGINAL five values
   {0.25, 0.375, 0.5, 0.625, 0.75} are ALSO reported, separately, under the key
   `theta_scan_legacy5`, so the earlier runs stay comparable.

5b. THETA CUTOFF SCAN — WHY IT EXISTS.  The ladder starts at x0 = 1000, where a
   block holds only ~13 primes, so the LOW END is dominated by DISCRETENESS
   rather than by the residual's asymptotic behaviour, and it can drag the
   envelope-exponent estimate.  This scan makes that effect VISIBLE rather than
   assumed.  For each cutoff in the FIXED list --theta-cutoffs (default
   0, 1e4, 1e5, 1e6, 1e7, where 0 means no cutoff, i.e. the whole ladder):

       - keep only the blocks with x_j >= cutoff; report the number of blocks
         retained and the first and last x retained
       - re-run the SAME half-ladder RMS theta scan on that subset over the
         SAME fine grid
       - report the theta at which the ratio RMS_upper/RMS_lower crosses 1, by
         LINEAR INTERPOLATION between the two bracketing grid values; null when
         it does not cross
       - re-run the SAME projection (Hann window, same gamma grid, same 5x
         median threshold, same band rule) on the retained blocks only, and
         report the log-x span, the frequency resolution 2*pi/span, the band
         half-width actually used, the global max gamma, P_max/median, P/median
         at the six gamma_n, and the band verdict

   The cutoff list is FIXED and the theta grid is FIXED, and both are evaluated
   EXHAUSTIVELY.  This is NOT a fit and NOT a search for the best cutoff.

   TRADEOFF, stated up front: trimming the low end SHORTENS the log-x span and
   therefore WORSENS the frequency resolution 2*pi/span, so the band half-width
   max(0.6, resolution) GROWS with the cutoff.  That is a tradeoff being
   measured, not a defect.  All of this is stored under
   `summary.theta_cutoff_scan`.

6. PROJECTION — an inner product, not a fit:

       P(gamma) = | sum_j w_j * ehat_j * exp(-i * gamma * log x_j) |

   with w_j a HANN window over j, on a gamma grid 0 .. --gamma-max in steps of
   --gamma-step.  Reported: the frequency resolution
   2*pi / (log x_last - log x_first); the gamma of the global maximum; the ten
   largest local peaks with gamma and height; the median of P; and
   P(gamma_n)/median for the first SIX zeros.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

BAND HALF-WIDTH = max(0.6, one frequency resolution element), and the value
actually used is RECORDED.  This is deliberate: in O15 the pre-registered band
half-width (0.5) was NARROWER than one frequency resolution element (0.605), so
the band could barely fire.  That is not repeated here — the band is at least
one resolution element wide by construction.

    DETECT  the GLOBAL maximum of P lies within the band half-width of one of
            the six gamma_n AND exceeds 5.0 x median(P)
    WEAK    a LOCAL peak within the band of one of the six exceeds 5.0 x
            median(P), but the global maximum is elsewhere
    NULL    neither

SECOND PRE-REGISTERED BAND — the theta crossing under the cutoff scan.  Applied
to the interpolated theta crossing as the cutoff rises through the fixed list
0, 1e4, 1e5, 1e6, 1e7, in this PRECEDENCE ORDER:

    CONVERGE  the crossing increases monotonically across the five cutoffs AND
              reaches within 0.05 of 0.50 at some cutoff
    RISES     increases monotonically but never reaches within 0.05 of 0.50
    FLAT      the total change across all five cutoffs is less than 0.02
    ERRATIC   not monotone AND total change >= 0.02

Fixed before the run and applied mechanically.  If any of the five crossings is
null, the band is recorded as UNDEFINED rather than forced.

This instrument has NO sigma and NO t — it works on the raw count residual — so
there is exactly ONE verdict per (x0, ratio, xmax) setting.

=============================================================================
GATES — all three RUN inside the script and recorded in the payload
=============================================================================

GATE A — EXACT TILING.  sum_j c_j must equal pi(x_last) - pi(x_0) EXACTLY, i.e.
the blocks tile the range with no gap and no overlap.  Verified with exact
integers via searchsorted at the two outer endpoints.

GATE B — TIES TO THE TABLE.  When invoked with --x0 2 --ratio 2.0 the ladder IS
the dyadic one (x_j = 2^(j+1)) and c_j must reproduce
N(r) = pi(2^r) - pi(2^(r-1)) EXACTLY for every r in range, read from
`pi2n_cache.json` (READ ONLY — this script never writes to it).  The number of r
compared and any mismatch are reported.  When --ratio is not 2.0 the gate is
recorded as "not applicable" rather than failed.

GATE C — SANITY ON li.  li(10^6) is reported against the known value
78627.549... and pi(10^6) = 78498 is reported from the sieve, so the smooth term
is visibly in the right place.  Both recorded.

GATE D — SANITY ON riemannr.  R(10^6) is reported against pi(10^6) = 78498 from
the sieve, together with |R(10^6) - 78498|.  For reference li(10^6) = 78627.549.
PASS criterion: |R(10^6) - 78498| < |li(10^6) - 78498|, i.e. R is the closer
model at that point.  Recorded.

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` (one row per block: j, x_j, x_{j+1}, c_j, L_j, e_j,
ehat_j).  `params.code_version` is the sha256 of THIS file, read from `__file__`
at runtime.  `params.precision` records the mix: exact integer counts, mpmath li
at the recorded dps, float64 projection.

REQUIREMENTS
------------
    numpy, mpmath   (both already present in this bench's .venv)

USAGE
-----
    python3 O17_disjoint_block_residual.py
    python3 O17_disjoint_block_residual.py --x0 2 --ratio 2.0 \
        --out results/O17_disjoint_block_residual_dyadic.json
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

try:
    import mpmath
    from mpmath import mp
except ImportError:
    raise ImportError(
        "mpmath is required and is NOT optional for this script: the smooth "
        "term L_j = li(x_{j+1}) - li(x_j) is computed at high precision and "
        "there is no float fallback. This bench's O8/O9/O3 already depend on "
        "mpmath; if the import failed the .venv is not the one described in "
        "REFERENCES.md. Install with: pip install mpmath")

# --------------------------------------------------------------------------
# Smooth-model backend detection, done ONCE at import.
# R(x) = sum_{n>=1} mu(n)/n * li(x^(1/n)) is Riemann's function. mpmath ships
# it as `riemannr`; if this mpmath does not have it, the explicit Mobius sum
# below is used instead and the choice is RECORDED in params.riemannr_impl.
# --------------------------------------------------------------------------
_HAS_RIEMANNR = hasattr(mpmath, "riemannr")
RIEMANNR_IMPL = "mpmath.riemannr" if _HAS_RIEMANNR else "mobius_sum"

SMOOTH_CHOICES = ("li", "R")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
DEFAULT_CACHE = os.path.join(_HERE, "pi2n_cache.json")

# First six Riemann zero heights, as used across this bench.
GAMMA_1 = 14.134725
GAMMA_2 = 21.022040
GAMMA_3 = 25.010858
GAMMA_4 = 30.424876
GAMMA_5 = 32.935062
GAMMA_6 = 37.586178
GAMMAS = (GAMMA_1, GAMMA_2, GAMMA_3, GAMMA_4, GAMMA_5, GAMMA_6)

# Pre-registered band constants. The half-width FLOOR is 0.6; the half-width
# actually used is max(0.6, one frequency resolution element) and is recorded.
BAND_HALFWIDTH_FLOOR = 0.6
BAND_MEDIAN_FACTOR = 5.0

# Parameter-free theta scan. Not a fit, not a search: fixed printed grids.
# THETA_SCAN_LEGACY5 is the ORIGINAL five-value list, retained VERBATIM so the
# earlier runs stay comparable; it is reported separately under the key
# `theta_scan_legacy5`. The PRIMARY scan is a fixed grid built from
# --theta-min / --theta-max / --theta-step (default 0.20 .. 0.80 step 0.02,
# 31 values). Both are fixed grids evaluated EXHAUSTIVELY: nothing is optimised
# and no theta is selected by the script.
THETA_SCAN_LEGACY5 = (0.25, 0.375, 0.5, 0.625, 0.75)
THETA_SCAN = THETA_SCAN_LEGACY5

# Fixed low-end cutoff list for the theta cutoff scan. 0 means no cutoff, i.e.
# the whole ladder. FIXED list, evaluated exhaustively — NOT a search for a
# best cutoff.
DEFAULT_THETA_CUTOFFS = "0,1e4,1e5,1e6,1e7"

# Pre-registered band on the interpolated theta crossing across the cutoffs.
THETA_CROSSING_TARGET = 0.50
THETA_CROSSING_TOL = 0.05
THETA_CROSSING_FLAT_TOL = 0.02

# Gate C reference values.
GATE_C_X = 1000000
GATE_C_LI_KNOWN = 78627.549
GATE_C_PI_KNOWN = 78498

# Gate D reference values (riemannr sanity). Same x and same pi(x) as gate C.
GATE_D_X = GATE_C_X
GATE_D_PI_KNOWN = GATE_C_PI_KNOWN
GATE_D_LI_KNOWN = GATE_C_LI_KNOWN


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
        return {str(k): _jsonable(v) for k, v in o.items()}
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
    """
    Exact primes by sieve of Eratosthenes, mirroring sieve_primes in
    O15_fine_ladder_residual.py, except that the result is kept as sorted
    int64 rather than float64 — this script counts primes by searchsorted and
    must not lose exactness at 1.5e8.
    """
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.int64)


def pi_at(primes, x):
    """
    EXACT pi(x) = number of primes <= x, by binary search on the sorted prime
    array. side="right" so the count is inclusive of x itself when x is prime,
    which makes the interval (x_j, x_{j+1}] half-open on the left and closed on
    the right — the same convention as the dyadic table's (2^(r-1), 2^r].
    """
    return int(np.searchsorted(primes, x, side="right"))


def build_ladder(x0, ratio, xmax):
    """
    Value ladder x_j = x0 * ratio^j for j = 0.. while x_j <= xmax.

    x_j is computed as x0 * ratio**j directly (NOT accumulated by repeated
    multiplication), so rounding error does not compound along the ladder and
    x_j is exact whenever x0 and ratio^j are exactly representable — which is
    the case for the dyadic gate-B setting x0 = 2, ratio = 2.

    Returns the list of ladder points. Blocks are the len-1 consecutive pairs.
    """
    pts = []
    j = 0
    while True:
        x = float(x0) * (float(ratio) ** j)
        if not math.isfinite(x) or x > float(xmax):
            break
        if pts and x <= pts[-1]:
            break
        pts.append(x)
        j += 1
        if j > 10 ** 7:
            break
    return pts


def li_values(pts, dps):
    """
    li(x) at every ladder point, at mp.dps = dps. Returns a list of mpf.
    The DIFFERENCE is taken in mpf and only then cast to float, so the
    cancellation between two nearly equal li values is done at full precision.
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        return [mpmath.li(mpmath.mpf(x)) for x in pts]
    finally:
        mp.dps = old


def _mobius_table(nmax):
    """
    mu(n) for n = 0..nmax by a small linear sieve. mu[0] is unused and set 0.
    Used only by the `mobius_sum` fallback when mpmath has no `riemannr`.
    """
    nmax = max(int(nmax), 1)
    mu = np.ones(nmax + 1, dtype=np.int64)
    mu[0] = 0
    is_comp = np.zeros(nmax + 1, dtype=bool)
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
    nmax = int(math.floor(math.log(float(xm)) / math.log(2.0)))
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


def riemannr_values(pts, dps):
    """
    R(x) at every ladder point, at mp.dps = dps. Returns a list of mpf.
    Same contract as li_values: the DIFFERENCE is taken in mpf and only then
    cast to float, so the cancellation is done at full precision.
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        return [riemannr_at(x) for x in pts]
    finally:
        mp.dps = old


def hann(n):
    """Hann window over n points: 0.5 - 0.5 cos(2 pi i / (n-1)). n<=1 -> ones."""
    if n <= 1:
        return np.ones(max(n, 0), dtype=np.float64)
    i = np.arange(n, dtype=np.float64)
    return 0.5 - 0.5 * np.cos(2.0 * math.pi * i / (n - 1))


def project(logx, ehat, w, gammas):
    """P(gamma) = | sum_j w_j ehat_j exp(-i gamma log x_j) | on a gamma grid."""
    if len(logx) == 0:
        return np.zeros(len(gammas), dtype=np.float64)
    a = (w * ehat).astype(np.float64)
    ph = np.outer(gammas, logx)
    re = np.cos(ph) @ a
    im = -(np.sin(ph) @ a)
    return np.sqrt(re * re + im * im)


def _rms(v):
    """sqrt(mean(v^2)) over a numpy array; nan when empty."""
    a = np.asarray(v, dtype=np.float64)
    a = a[np.isfinite(a)]
    if a.size == 0:
        return float("nan")
    return float(np.sqrt(np.mean(a * a)))


def _nearest_gamma(x):
    """(index, distance) of the nearest of gamma_1..gamma_6 to x."""
    best_i, best_d = None, None
    for i, gm in enumerate(GAMMAS):
        d = abs(x - gm)
        if best_d is None or d < best_d:
            best_i, best_d = i, d
    return best_i, best_d


def local_peaks(gammas, P):
    """Strict interior local maxima as a list of (gamma, height), unsorted."""
    out = []
    if P.size < 3:
        return out
    for k in range(1, P.size - 1):
        if P[k] > P[k - 1] and P[k] > P[k + 1]:
            out.append((float(gammas[k]), float(P[k])))
    return out


def classify_projection(gammas, P, halfwidth, factor):
    """
    Mechanical application of the pre-registered bands over gamma_1..gamma_6.

    DETECT : global max of P lies within `halfwidth` of one of the six AND
             exceeds `factor` x median(P)
    WEAK   : a LOCAL peak within `halfwidth` of one of the six exceeds
             `factor` x median(P), but the global max is elsewhere
    NULL   : neither
    """
    out = {"verdict": "NULL", "argmax_gamma": None, "P_max": None,
           "P_median": None, "P_max_over_median": None,
           "argmax_nearest_gamma_index": None,
           "argmax_nearest_gamma": None,
           "argmax_distance_to_nearest": None,
           "band_halfwidth_used": halfwidth,
           "band_median_factor": factor,
           "weak_peak_gamma": None, "weak_peak_over_median": None,
           "P_at_gamma": [None] * len(GAMMAS),
           "P_at_gamma_over_median": [None] * len(GAMMAS),
           "P_at_gamma_grid_point": [None] * len(GAMMAS),
           "top_local_peaks": []}
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
        out["P_at_gamma_grid_point"][i] = float(gammas[k])
        out["P_at_gamma_over_median"][i] = _safe_div(float(P[k]), med)

    ni, nd = _nearest_gamma(gmax)
    out["argmax_nearest_gamma_index"] = ni
    out["argmax_nearest_gamma"] = GAMMAS[ni] if ni is not None else None
    out["argmax_distance_to_nearest"] = nd

    peaks = local_peaks(gammas, P)
    peaks_sorted = sorted(peaks, key=lambda p: -p[1])[:10]
    out["top_local_peaks"] = [
        {"gamma": g, "P": h, "P_over_median": _safe_div(h, med),
         "nearest_gamma": GAMMAS[_nearest_gamma(g)[0]],
         "distance_to_nearest": _nearest_gamma(g)[1],
         "in_band": bool(_nearest_gamma(g)[1] <= halfwidth)}
        for g, h in peaks_sorted]

    thresh_ok = (math.isfinite(med) and med > 0.0 and pmax > factor * med)
    if nd is not None and nd <= halfwidth and thresh_ok:
        out["verdict"] = "DETECT"
        return out

    best_g, best_r = None, None
    if math.isfinite(med) and med > 0.0:
        for g, h in peaks:
            _, d = _nearest_gamma(g)
            if d > halfwidth:
                continue
            if h > factor * med:
                r = h / med
                if best_r is None or r > best_r:
                    best_g, best_r = g, r
    if best_g is not None:
        out["verdict"] = "WEAK"
        out["weak_peak_gamma"] = best_g
        out["weak_peak_over_median"] = best_r
    return out


def build_theta_grid(tmin, tmax, tstep):
    """
    FIXED theta grid tmin .. tmax INCLUSIVE in steps of tstep. Endpoints are
    snapped by rounding so that 0.20 .. 0.80 step 0.02 yields exactly 31 values
    and not 30 or 32 in IEEE double. Not a fit, not a search.
    """
    tmin, tmax, tstep = float(tmin), float(tmax), float(tstep)
    if not (math.isfinite(tmin) and math.isfinite(tmax) and
            math.isfinite(tstep)):
        raise SystemExit("--theta-min/--theta-max/--theta-step must be finite")
    if tstep <= 0.0:
        raise SystemExit(f"--theta-step {tstep} must be > 0")
    if tmax < tmin:
        raise SystemExit(f"--theta-max {tmax} is below --theta-min {tmin}")
    n = int(math.floor((tmax - tmin) / tstep + 0.5)) + 1
    return [round(tmin + i * tstep, 10) for i in range(n)]


def parse_cutoffs(s):
    """Comma-separated fixed cutoff list -> list of floats. 0 means no cutoff."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        try:
            v = float(tok)
        except ValueError:
            raise SystemExit(f"--theta-cutoffs: '{tok}' is not a number")
        if not math.isfinite(v) or v < 0.0:
            raise SystemExit(f"--theta-cutoffs: '{tok}' must be finite and >= 0")
        out.append(v)
    if not out:
        raise SystemExit("--theta-cutoffs is empty")
    return out


def theta_scan_rows(ej_sub, xj_sub, thetas):
    """
    Half-ladder RMS theta scan on one (possibly trimmed) block subset, over a
    FIXED theta grid. Same rule as the full-ladder scan: lower half = the first
    floor(n/2) blocks, upper half = the last floor(n/2) blocks, middle block
    dropped when n is odd. Nothing is optimised; no theta is selected.
    """
    ej_sub = np.asarray(ej_sub, dtype=np.float64)
    xj_sub = np.asarray(xj_sub, dtype=np.float64)
    n = int(xj_sub.size)
    half = n // 2
    rows = []
    for th in thetas:
        v = ej_sub / (xj_sub ** float(th))
        if half >= 1:
            rlo = _rms(v[:half])
            rhi = _rms(v[-half:])
        else:
            rlo = rhi = float("nan")
        rows.append({"theta": float(th), "rms_lower_half": rlo,
                     "rms_upper_half": rhi,
                     "ratio_upper_over_lower": _safe_div(rhi, rlo),
                     "n_half": half})
    return rows


def crossing_theta(rows):
    """
    The theta at which ratio = RMS_upper / RMS_lower crosses 1, by LINEAR
    INTERPOLATION between the two bracketing grid values. Returns None when the
    ratio never crosses 1 over the grid. An exact 1.0 on a grid point is
    returned as that grid point. Only finite ratios take part.
    """
    ths, rs = [], []
    for row in rows:
        v = row.get("ratio_upper_over_lower")
        try:
            fv = float(v)
        except (TypeError, ValueError):
            continue
        if not math.isfinite(fv):
            continue
        ths.append(float(row["theta"]))
        rs.append(fv)
    for k in range(len(rs)):
        if rs[k] == 1.0:
            return ths[k]
    for k in range(len(rs) - 1):
        a = rs[k] - 1.0
        b = rs[k + 1] - 1.0
        if (a < 0.0 < b) or (b < 0.0 < a):
            return ths[k] + (0.0 - a) * (ths[k + 1] - ths[k]) / (b - a)
    return None


def classify_theta_crossings(crossings):
    """
    Mechanical application of the SECOND pre-registered band, in the declared
    precedence order, on the interpolated theta crossings across the cutoffs.

    CONVERGE : monotone non-decreasing across the cutoffs AND within
               THETA_CROSSING_TOL of THETA_CROSSING_TARGET at some cutoff
    RISES    : monotone non-decreasing but never within the tolerance
    FLAT     : |total change| < THETA_CROSSING_FLAT_TOL
    ERRATIC  : not monotone AND |total change| >= THETA_CROSSING_FLAT_TOL

    UNDEFINED when any crossing is null — the band is not forced.
    """
    out = {"band_verdict": None, "crossings": list(crossings),
           "monotone_non_decreasing": None, "total_change": None,
           "min_abs_distance_to_target": None,
           "reaches_target_within_tol": None,
           "target": THETA_CROSSING_TARGET, "tol": THETA_CROSSING_TOL,
           "flat_tol": THETA_CROSSING_FLAT_TOL,
           "band_rule": (
               "precedence order: CONVERGE = monotone non-decreasing across "
               "the cutoffs AND within 0.05 of 0.50 at some cutoff; RISES = "
               "monotone non-decreasing but never within 0.05 of 0.50; FLAT = "
               "total change across all cutoffs < 0.02; ERRATIC = not monotone "
               "and total change >= 0.02. UNDEFINED when any crossing is null")}
    vals = []
    for c in crossings:
        if c is None:
            out["band_verdict"] = "UNDEFINED"
            out["undefined_reason"] = "at least one cutoff has no theta crossing"
            return out
        vals.append(float(c))
    if len(vals) < 2:
        out["band_verdict"] = "UNDEFINED"
        out["undefined_reason"] = "fewer than two cutoffs"
        return out
    mono = all(vals[i + 1] >= vals[i] for i in range(len(vals) - 1))
    total_change = vals[-1] - vals[0]
    dists = [abs(v - THETA_CROSSING_TARGET) for v in vals]
    reaches = min(dists) <= THETA_CROSSING_TOL
    out["monotone_non_decreasing"] = bool(mono)
    out["total_change"] = float(total_change)
    out["min_abs_distance_to_target"] = float(min(dists))
    out["reaches_target_within_tol"] = bool(reaches)
    if mono and reaches:
        out["band_verdict"] = "CONVERGE"
    elif mono:
        out["band_verdict"] = "RISES"
    elif abs(total_change) < THETA_CROSSING_FLAT_TOL:
        out["band_verdict"] = "FLAT"
    else:
        out["band_verdict"] = "ERRATIC"
    return out


def main():
    ap = argparse.ArgumentParser(
        description="O17 — disjoint-block residual: tile value space with "
                    "disjoint geometric intervals, exact prime counts minus "
                    "li, and project the residual onto exp(-i gamma log x)")
    ap.add_argument("--xmax", type=int, default=150000000,
                    help="sieve limit / top of the value ladder "
                         "(default 150000000)")
    ap.add_argument("--x0", type=float, default=1000.0,
                    help="first ladder point x_0 (default 1000)")
    ap.add_argument("--ratio", type=float, default=1.1,
                    help="value ladder ratio r (default 1.1); r = 2.0 with "
                         "--x0 2 is the dyadic ladder and arms gate B")
    ap.add_argument("--gamma-max", type=float, default=40.0,
                    help="upper end of the gamma projection grid (default 40)")
    ap.add_argument("--gamma-step", type=float, default=0.01,
                    help="gamma projection grid step (default 0.01)")
    ap.add_argument("--smooth", type=str, default="R", choices=list(SMOOTH_CHOICES),
                    help="smooth model subtracted from the exact count: "
                         "'li' -> L_j = li(x_{j+1}) - li(x_j); "
                         "'R'  -> L_j = R(x_{j+1}) - R(x_j) with R Riemann's "
                         "function (default R)")
    ap.add_argument("--theta-min", type=float, default=0.20,
                    help="lower end of the FIXED theta grid (default 0.20)")
    ap.add_argument("--theta-max", type=float, default=0.80,
                    help="upper end of the FIXED theta grid, inclusive "
                         "(default 0.80)")
    ap.add_argument("--theta-step", type=float, default=0.02,
                    help="step of the FIXED theta grid (default 0.02; with the "
                         "defaults this is 31 values)")
    ap.add_argument("--theta-cutoffs", type=str, default=DEFAULT_THETA_CUTOFFS,
                    help="FIXED comma-separated list of low-end cutoffs for "
                         "the theta cutoff scan; a block is retained when "
                         "x_j >= cutoff, and 0 means no cutoff (whole ladder). "
                         f"Default '{DEFAULT_THETA_CUTOFFS}'. Evaluated "
                         "exhaustively — NOT a search for a best cutoff")
    ap.add_argument("--dps", type=int, default=30,
                    help="mpmath decimal precision for li (default 30; the "
                         "script refuses to run below 30)")
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE,
                    help="path to pi(2^n) cache JSON, read by gate B "
                         "(READ ONLY; default: pi2n_cache.json at the root)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    dps = int(args.dps)
    if dps < 30:
        raise SystemExit(f"--dps {dps} is below the required minimum of 30; "
                         "the li difference is a cancellation and needs the "
                         "precision. Refusing to run.")

    smooth = str(args.smooth)
    if smooth not in SMOOTH_CHOICES:
        raise SystemExit(f"--smooth {smooth} not in {SMOOTH_CHOICES}")

    # FIXED grids, built once. Neither is optimised or searched.
    theta_grid = build_theta_grid(args.theta_min, args.theta_max,
                                  args.theta_step)
    theta_cutoffs = parse_cutoffs(args.theta_cutoffs)

    r = float(args.ratio)
    x0 = float(args.x0)
    xmax = int(args.xmax)
    if r <= 1.0:
        raise SystemExit(f"--ratio {r} must be > 1.0 for a geometric ladder.")
    if x0 < 2.0:
        raise SystemExit(f"--x0 {x0} must be >= 2.")

    log_r = math.log(r)
    nyquist = _safe_div(math.pi, log_r)
    dyadic_nyquist = math.pi / math.log(2.0)

    print("=" * 78, flush=True)
    print("O17 — disjoint-block residual  (fit-free; exact counts; "
          "projection, not fit)", flush=True)
    print("=" * 78, flush=True)
    print("  x_j  = x0 * r^j                        value ladder", flush=True)
    print("  c_j  = pi(x_{j+1}) - pi(x_j)           EXACT integer count in "
          "(x_j, x_{j+1}]", flush=True)
    if smooth == "R":
        print("  L_j  = R(x_{j+1}) - R(x_j)             smooth prediction "
              "(--smooth R; R = Riemann's function)", flush=True)
    else:
        print("  L_j  = li(x_{j+1}) - li(x_j)           smooth prediction "
              "(--smooth li)", flush=True)
    print(f"  smooth model : {smooth}   (R implementation: {RIEMANNR_IMPL})",
          flush=True)
    print("  e_j  = c_j - L_j                       the residual", flush=True)
    print("  ehat = e_j / sqrt(x_j)                 half-power normalisation",
          flush=True)
    print("", flush=True)
    print("  Blocks are DISJOINT and TILE the range: every prime in "
          "(x_0, x_last] is used", flush=True)
    print("  exactly once and every block is an independent sample. The COUNT "
          "fluctuates,", flush=True)
    print("  because the interval is fixed in VALUE space, not in index space.",
          flush=True)
    print("  O12-O15 summed primes[N:2N] by PRIME INDEX: consecutive rungs "
          "overlapped, and", flush=True)
    print("  the count was fixed at N by construction, so it carried no "
          "fluctuation at all.", flush=True)
    print("", flush=True)
    print(f"  log-x step = log(r) = {log_r:.7f}   "
          f"(dyadic ladder: log 2 = {math.log(2.0):.7f})", flush=True)
    print(f"  Nyquist = pi/log(r) = {nyquist:.6f}   "
          f"(dyadic ladder: {dyadic_nyquist:.6f})", flush=True)
    for gi, gm in enumerate(GAMMAS, start=1):
        print(f"    gamma_{gi} = {gm:<12} "
              f"{'BELOW' if gm < nyquist else 'ABOVE'} Nyquist", flush=True)

    # ---------------- sieve ------------------------------------------------
    print(f"\n  sieving primes to {xmax}...", flush=True)
    primes = sieve_primes(xmax)
    n_primes = int(primes.size)
    largest_prime = int(primes[-1]) if n_primes else None
    print(f"  {n_primes} primes, largest = {largest_prime}", flush=True)

    # ---------------- ladder ----------------------------------------------
    pts = build_ladder(x0, r, xmax)
    n_pts = len(pts)
    n_blocks = max(0, n_pts - 1)
    print(f"\n  ladder points (rungs) : {n_pts}", flush=True)
    print(f"  blocks (disjoint)     : {n_blocks}", flush=True)
    if n_blocks < 1:
        raise SystemExit("no block survives the ladder; raise --xmax or lower "
                         "--x0 / --ratio.")
    print(f"  first x = {pts[0]!r}", flush=True)
    print(f"  last  x = {pts[-1]!r}", flush=True)
    print(f"  achieved Nyquist pi/log(r) = {nyquist:.6f}", flush=True)

    # ---------------- exact counts -----------------------------------------
    pi_pts = [pi_at(primes, x) for x in pts]
    counts = [pi_pts[j + 1] - pi_pts[j] for j in range(n_blocks)]
    total_count = sum(counts)
    print(f"\n  total primes counted across all blocks : {total_count}",
          flush=True)
    print(f"  block size range : min = {min(counts)}   max = {max(counts)}",
          flush=True)

    # ---------------- smooth term ------------------------------------------
    print(f"\n  computing li at mp.dps = {dps} ...", flush=True)
    li_pts = li_values(pts, dps)
    L_li = [float(li_pts[j + 1] - li_pts[j]) for j in range(n_blocks)]
    print(f"  computing R  at mp.dps = {dps} "
          f"({RIEMANNR_IMPL}) ...", flush=True)
    R_pts = riemannr_values(pts, dps)
    L_R = [float(R_pts[j + 1] - R_pts[j]) for j in range(n_blocks)]
    L = L_R if smooth == "R" else L_li
    print(f"  smooth model in use : {smooth}", flush=True)
    print(f"  mp.dps used : {dps}   (difference taken in mpf, cast to float "
          f"only afterwards)", flush=True)

    # ---------------- residual ---------------------------------------------
    xj = np.asarray(pts[:n_blocks], dtype=np.float64)
    xj1 = np.asarray(pts[1:n_pts], dtype=np.float64)
    cj = np.asarray(counts, dtype=np.float64)
    Lj = np.asarray(L, dtype=np.float64)
    Lj_li = np.asarray(L_li, dtype=np.float64)
    Lj_R = np.asarray(L_R, dtype=np.float64)
    ej = cj - Lj
    ehat = ej / np.sqrt(xj)

    # DIAGNOSTIC — difference between the two smooth models, per block.
    #   D_j = (li(x_{j+1}) - li(x_j)) - (R(x_{j+1}) - R(x_j))
    Dj = Lj_li - Lj_R
    Dhat = Dj / np.sqrt(xj)
    D_stats = {
        "n": int(Dhat.size),
        "min": float(np.min(Dhat)),
        "max": float(np.max(Dhat)),
        "mean": float(np.mean(Dhat)),
        "rms": _rms(Dhat),
        "D_min": float(np.min(Dj)),
        "D_max": float(np.max(Dj)),
        "closed_form_first_rung": _safe_div(math.sqrt(r) - 1.0,
                                            math.log(float(xj[0]))),
        "closed_form_last_rung": _safe_div(math.sqrt(r) - 1.0,
                                           math.log(float(xj[-1]))),
        "closed_form_expression": "(sqrt(ratio) - 1) / log(x_j)",
        "definition": ("D_j = (li(x_{j+1}) - li(x_j)) - (R(x_{j+1}) - R(x_j)); "
                       "normalised form D_j / sqrt(x_j)"),
    }

    ehat_stats = {
        "n": int(ehat.size),
        "min": float(np.min(ehat)),
        "max": float(np.max(ehat)),
        "mean": float(np.mean(ehat)),
        "rms": _rms(ehat),
        "min_at_x": float(xj[int(np.argmin(ehat))]),
        "max_at_x": float(xj[int(np.argmax(ehat))]),
    }

    # ---------------- readable block table ---------------------------------
    print("\n" + "-" * 78, flush=True)
    print("BLOCKS — one row per disjoint interval (x_j, x_{j+1}]", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'j':>4} {'x_j':>18} {'x_{j+1}':>18} {'c_j':>10} "
          f"{'L_j':>18} {'e_j':>16} {'ehat_j':>14}", flush=True)
    for j in range(n_blocks):
        print(f"  {j:>4} {_fmtg(xj[j], 18, 12)} {_fmtg(xj1[j], 18, 12)} "
              f"{counts[j]:>10} {_fmtg(Lj[j], 18, 12)} "
              f"{_fmtg(ej[j], 16, 8)} {_fmtg(ehat[j], 14, 7)}", flush=True)

    print("\n" + "-" * 78, flush=True)
    print("RESIDUAL NORMALISED AT THE HALF POWER — ehat_j = e_j / sqrt(x_j)",
          flush=True)
    print("-" * 78, flush=True)
    print(f"  n     = {ehat_stats['n']}", flush=True)
    print(f"  min   = {ehat_stats['min']:.10g}   (at x = "
          f"{ehat_stats['min_at_x']:.10g})", flush=True)
    print(f"  max   = {ehat_stats['max']:.10g}   (at x = "
          f"{ehat_stats['max_at_x']:.10g})", flush=True)
    print(f"  mean  = {ehat_stats['mean']:.10g}", flush=True)
    print(f"  RMS   = {ehat_stats['rms']:.10g}", flush=True)

    # ---------------- smooth-model difference diagnostic --------------------
    print("\n" + "-" * 78, flush=True)
    print("DIAGNOSTIC — D_j = (li(x_{j+1}) - li(x_j)) - (R(x_{j+1}) - R(x_j))",
          flush=True)
    print("-" * 78, flush=True)
    print(f"  R implementation : {RIEMANNR_IMPL}", flush=True)
    print(f"  n            = {D_stats['n']}", flush=True)
    print(f"  D_j   min    = {D_stats['D_min']:.10g}", flush=True)
    print(f"  D_j   max    = {D_stats['D_max']:.10g}", flush=True)
    print(f"  D_j/sqrt(x)  min  = {D_stats['min']:.10g}", flush=True)
    print(f"  D_j/sqrt(x)  max  = {D_stats['max']:.10g}", flush=True)
    print(f"  D_j/sqrt(x)  mean = {D_stats['mean']:.10g}", flush=True)
    print(f"  D_j/sqrt(x)  RMS  = {D_stats['rms']:.10g}", flush=True)
    print(f"\n  closed-form expectation "
          f"{D_stats['closed_form_expression']}:", flush=True)
    print(f"    at the FIRST rung x = {float(xj[0]):.10g} : "
          f"{D_stats['closed_form_first_rung']:.10g}", flush=True)
    print(f"    at the LAST  rung x = {float(xj[-1]):.10g} : "
          f"{D_stats['closed_form_last_rung']:.10g}", flush=True)
    print("  Both numbers are STATED, not interpreted. Interpretation is not "
          "this script's job.", flush=True)

    # ---------------- theta scan (parameter-free, NOT a fit) ---------------
    print("\n" + "-" * 78, flush=True)
    print("THETA SCAN — e_j / x_j^theta, half-ladder RMS ratio. "
          "PARAMETER-FREE SCAN, NOT A FIT.", flush=True)
    print("-" * 78, flush=True)
    print("  The theta grid is fixed in the source / on the flags and is "
          "evaluated EXHAUSTIVELY.", flush=True)
    print("  Nothing is optimised and no theta is selected by the script. A "
          "ratio near 1 means", flush=True)
    print("  that theta flattens the residual.", flush=True)
    half = n_blocks // 2
    print(f"\n  lower half = blocks 0..{half - 1}, upper half = blocks "
          f"{n_blocks - half}..{n_blocks - 1}  "
          f"(middle block dropped when odd)", flush=True)
    print(f"\n  FINE GRID: theta = {args.theta_min:g} to {args.theta_max:g} "
          f"inclusive, step {args.theta_step:g}  "
          f"({len(theta_grid)} values)", flush=True)
    print(f"\n  {'theta':>8} {'RMS_lower':>18} {'RMS_upper':>18} "
          f"{'RMS_upper/RMS_lower':>22}", flush=True)
    theta_rows = theta_scan_rows(ej, xj, theta_grid)
    for row in theta_rows:
        print(f"  {row['theta']:>8.3f} "
              f"{_fmtg(row['rms_lower_half'], 18, 10)} "
              f"{_fmtg(row['rms_upper_half'], 18, 10)} "
              f"{_fmtg(row['ratio_upper_over_lower'], 22, 10)}", flush=True)
    theta_full_crossing = crossing_theta(theta_rows)
    print(f"\n  interpolated theta where the ratio crosses 1 : "
          f"{'null (no crossing on the grid)' if theta_full_crossing is None else format(theta_full_crossing, '.6f')}",
          flush=True)

    print(f"\n  LEGACY 5-VALUE LIST (reported separately under "
          f"`theta_scan_legacy5` so earlier", flush=True)
    print("  runs stay comparable):", flush=True)
    print(f"\n  {'theta':>8} {'RMS_lower':>18} {'RMS_upper':>18} "
          f"{'RMS_upper/RMS_lower':>22}", flush=True)
    theta_rows_legacy5 = theta_scan_rows(ej, xj, list(THETA_SCAN_LEGACY5))
    for row in theta_rows_legacy5:
        print(f"  {row['theta']:>8.3f} "
              f"{_fmtg(row['rms_lower_half'], 18, 10)} "
              f"{_fmtg(row['rms_upper_half'], 18, 10)} "
              f"{_fmtg(row['ratio_upper_over_lower'], 22, 10)}", flush=True)

    # ---------------- projection -------------------------------------------
    gammas = np.arange(0.0, args.gamma_max + 0.5 * args.gamma_step,
                       args.gamma_step, dtype=np.float64)
    n_gamma = int(gammas.size)
    logx = np.log(xj)
    span = float(logx[-1] - logx[0])
    freq_res = _safe_div(2.0 * math.pi, span)
    band_halfwidth = max(BAND_HALFWIDTH_FLOOR,
                         freq_res if math.isfinite(freq_res) else 0.0)

    w = hann(int(xj.size))
    P = project(logx, ehat, w, gammas)
    cls = classify_projection(gammas, P, band_halfwidth, BAND_MEDIAN_FACTOR)

    print("\n" + "-" * 78, flush=True)
    print("PROJECTION  P(gamma) = |sum_j w_j ehat_j exp(-i gamma log x_j)|  "
          "(inner product, NOT a fit)", flush=True)
    print("-" * 78, flush=True)
    print(f"  window      : hann over {int(w.size)} blocks", flush=True)
    print(f"  gamma grid  : 0 to {args.gamma_max:g} step {args.gamma_step:g}  "
          f"({n_gamma} points)", flush=True)
    print(f"  log-x span used by the projection = {span:.7f}", flush=True)
    print(f"  frequency resolution 2*pi/(log x_last - log x_first) = "
          f"{freq_res:.6f}", flush=True)
    print(f"\n  BAND HALF-WIDTH USED = max({BAND_HALFWIDTH_FLOOR:g}, "
          f"{freq_res:.6f}) = {band_halfwidth:.6f}", flush=True)
    print("  This is DELIBERATE: the band is at least ONE FREQUENCY "
          "RESOLUTION ELEMENT wide.", flush=True)
    print("  In O15 the pre-registered half-width (0.5) was NARROWER than one "
          "resolution", flush=True)
    print("  element (0.605), so the band could barely fire. That is not "
          "repeated here.", flush=True)
    print(f"  threshold : P > {BAND_MEDIAN_FACTOR:g} x median(P)", flush=True)

    print(f"\n  median(P)          = {cls['P_median']:.10g}", flush=True)
    print(f"  global max of P    = {cls['P_max']:.10g}  at gamma = "
          f"{cls['argmax_gamma']:.4f}", flush=True)
    print(f"  P_max / median     = {cls['P_max_over_median']:.6f}", flush=True)
    print(f"  nearest gamma_n to the argmax = "
          f"{cls['argmax_nearest_gamma']}  (distance "
          f"{cls['argmax_distance_to_nearest']:.6f}, band "
          f"{band_halfwidth:.6f})", flush=True)

    print(f"\n  TEN LARGEST LOCAL PEAKS (strict interior maxima)", flush=True)
    print(f"  {'rank':>5} {'gamma':>12} {'P':>18} {'P/median':>14} "
          f"{'nearest gamma_n':>17} {'dist':>10} {'in band':>9}", flush=True)
    for i, pk in enumerate(cls["top_local_peaks"], start=1):
        print(f"  {i:>5} {_fmt(pk['gamma'], 12, 4)} {_fmtg(pk['P'], 18, 10)} "
              f"{_fmt(pk['P_over_median'], 14, 6)} "
              f"{_fmt(pk['nearest_gamma'], 17, 6)} "
              f"{_fmt(pk['distance_to_nearest'], 10, 4)} "
              f"{('yes' if pk['in_band'] else 'no'):>9}", flush=True)
    if not cls["top_local_peaks"]:
        print("    (none)", flush=True)

    print(f"\n  P AT THE FIRST SIX ZERO HEIGHTS", flush=True)
    print(f"  {'n':>3} {'gamma_n':>12} {'grid point':>12} {'P':>18} "
          f"{'P/median':>14} {'below Nyquist':>15}", flush=True)
    for i, gm in enumerate(GAMMAS):
        print(f"  {i + 1:>3} {gm:>12.6f} "
              f"{_fmt(cls['P_at_gamma_grid_point'][i], 12, 4)} "
              f"{_fmtg(cls['P_at_gamma'][i], 18, 10)} "
              f"{_fmt(cls['P_at_gamma_over_median'][i], 14, 6)} "
              f"{('yes' if gm < nyquist else 'no'):>15}", flush=True)

    # ---------------- theta cutoff scan + restricted projection -------------
    print("\n" + "-" * 78, flush=True)
    print("THETA CUTOFF SCAN — low-end cutoffs, same fine theta grid, same "
          "projection", flush=True)
    print("-" * 78, flush=True)
    print("  WHY: the ladder starts at x0 = 1000, where a block holds only "
          "~13 primes, so the", flush=True)
    print("  LOW END is dominated by DISCRETENESS rather than by the "
          "residual's asymptotic", flush=True)
    print("  behaviour, and it can drag the envelope-exponent estimate. This "
          "scan makes that", flush=True)
    print("  effect VISIBLE rather than assumed.", flush=True)
    print("", flush=True)
    print("  The cutoff list is FIXED and the theta grid is FIXED, and both "
          "are evaluated", flush=True)
    print("  EXHAUSTIVELY. This is NOT a fit and NOT a search for the best "
          "cutoff.", flush=True)
    print("", flush=True)
    print("  TRADEOFF, stated: trimming the low end SHORTENS the log-x span "
          "and therefore", flush=True)
    print("  WORSENS the frequency resolution 2*pi/span, so the band "
          "half-width", flush=True)
    print("  max(0.6, resolution) GROWS with the cutoff. That is a tradeoff "
          "being measured,", flush=True)
    print("  not a defect.", flush=True)
    print(f"\n  cutoffs : {', '.join(format(c, 'g') for c in theta_cutoffs)}"
          "    (0 = no cutoff, i.e. the whole ladder)", flush=True)

    cutoff_entries = []
    for cut in theta_cutoffs:
        keep = np.flatnonzero(xj >= float(cut))
        n_keep = int(keep.size)
        entry = {
            "cutoff": float(cut),
            "cutoff_is_no_cutoff": bool(float(cut) <= 0.0),
            "n_blocks_retained": n_keep,
            "x_first_retained": (float(xj[keep[0]]) if n_keep else None),
            "x_last_retained": (float(xj[keep[-1]]) if n_keep else None),
            "theta_scan": [],
            "theta_crossing_interpolated": None,
            "projection": None,
            "projection_log_x_span": None,
            "frequency_resolution": None,
            "band_halfwidth_used": None,
        }
        if n_keep >= 1:
            ej_s = ej[keep]
            xj_s = xj[keep]
            ehat_s = ehat[keep]
            rows_s = theta_scan_rows(ej_s, xj_s, theta_grid)
            entry["theta_scan"] = rows_s
            entry["theta_crossing_interpolated"] = crossing_theta(rows_s)
            logx_s = np.log(xj_s)
            span_s = float(logx_s[-1] - logx_s[0]) if n_keep > 1 else 0.0
            res_s = _safe_div(2.0 * math.pi, span_s)
            bw_s = max(BAND_HALFWIDTH_FLOOR,
                       res_s if math.isfinite(res_s) else 0.0)
            w_s = hann(n_keep)
            P_s = project(logx_s, ehat_s, w_s, gammas)
            entry["projection"] = classify_projection(gammas, P_s, bw_s,
                                                      BAND_MEDIAN_FACTOR)
            entry["projection_log_x_span"] = span_s
            entry["frequency_resolution"] = res_s
            entry["band_halfwidth_used"] = bw_s
        cutoff_entries.append(entry)

    print(f"\n  {'cutoff':>12} {'n_blocks':>10} {'first x':>18} "
          f"{'last x':>18} {'theta crossing':>16}", flush=True)
    for e in cutoff_entries:
        cr = e["theta_crossing_interpolated"]
        print(f"  {e['cutoff']:>12g} {e['n_blocks_retained']:>10} "
              f"{_fmtg(e['x_first_retained'], 18, 12)} "
              f"{_fmtg(e['x_last_retained'], 18, 12)} "
              f"{(_fmt(cr, 16, 6) if cr is not None else 'null'.rjust(16))}",
              flush=True)

    print(f"\n  RESTRICTED PROJECTION on the retained blocks only "
          f"(same Hann window, same gamma", flush=True)
    print(f"  grid, same {BAND_MEDIAN_FACTOR:g}x-median threshold, band "
          f"half-width max({BAND_HALFWIDTH_FLOOR:g}, resolution) recomputed "
          f"per subset):", flush=True)
    print(f"\n  {'cutoff':>10} {'n_blk':>7} {'log-x span':>12} "
          f"{'2pi/span':>11} {'band hw':>10} {'argmax g':>10} "
          f"{'P_max/med':>12} {'verdict':>9}", flush=True)
    for e in cutoff_entries:
        pr = e["projection"] or {}
        print(f"  {e['cutoff']:>10g} {e['n_blocks_retained']:>7} "
              f"{_fmt(e['projection_log_x_span'], 12, 6)} "
              f"{_fmt(e['frequency_resolution'], 11, 6)} "
              f"{_fmt(e['band_halfwidth_used'], 10, 6)} "
              f"{_fmt(pr.get('argmax_gamma'), 10, 4)} "
              f"{_fmt(pr.get('P_max_over_median'), 12, 6)} "
              f"{str(pr.get('verdict')):>9}", flush=True)

    print(f"\n  P/median AT THE SIX gamma_n, per cutoff", flush=True)
    print(f"  {'cutoff':>10} " + " ".join(f"{'g'+str(i+1):>11}"
                                          for i in range(len(GAMMAS))),
          flush=True)
    for e in cutoff_entries:
        pr = e["projection"] or {}
        vals = pr.get("P_at_gamma_over_median") or [None] * len(GAMMAS)
        print(f"  {e['cutoff']:>10g} "
              + " ".join(_fmt(v, 11, 5) for v in vals), flush=True)

    theta_crossings = [e["theta_crossing_interpolated"] for e in cutoff_entries]
    crossing_band = classify_theta_crossings(theta_crossings)

    print("\n  PRE-REGISTERED BAND ON THE THETA CROSSING (fixed before the "
          "run, applied", flush=True)
    print("  mechanically; precedence CONVERGE > RISES > FLAT > ERRATIC):",
          flush=True)
    print("    crossings : "
          + ", ".join("null" if c is None else format(c, ".6f")
                      for c in theta_crossings), flush=True)
    print(f"    monotone non-decreasing : "
          f"{crossing_band['monotone_non_decreasing']}", flush=True)
    print(f"    total change            : "
          f"{_fmtg(crossing_band['total_change'], 12, 6).strip()}", flush=True)
    print(f"    min |crossing - {THETA_CROSSING_TARGET:g}|      : "
          f"{_fmtg(crossing_band['min_abs_distance_to_target'], 12, 6).strip()}"
          f"   (tolerance {THETA_CROSSING_TOL:g})", flush=True)
    print(f"    BAND VERDICT            : {crossing_band['band_verdict']}",
          flush=True)

    theta_cutoff_scan = {
        "note": ("FIXED theta grid and FIXED cutoff list, evaluated "
                 "EXHAUSTIVELY. This is NOT a fit and NOT a search for the "
                 "best cutoff."),
        "motivation": ("the ladder starts at x0 = 1000 where a block holds "
                       "only ~13 primes, so the low end is dominated by "
                       "discreteness rather than by the residual's asymptotic "
                       "behaviour and can drag the envelope-exponent estimate; "
                       "this scan makes the effect visible rather than "
                       "assumed"),
        "resolution_tradeoff_note": (
            "trimming the low end SHORTENS the log-x span and therefore "
            "WORSENS the frequency resolution 2*pi/span, so the band "
            "half-width max(0.6, resolution) GROWS with the cutoff. This is a "
            "tradeoff being measured, not a defect"),
        "cutoff_definition": ("a block is retained when x_j >= cutoff; "
                              "cutoff 0 means no cutoff, i.e. the whole "
                              "ladder"),
        "cutoffs_requested": [float(c) for c in theta_cutoffs],
        "theta_grid": list(theta_grid),
        "entries": cutoff_entries,
        "crossings": theta_crossings,
        "crossing_band": crossing_band,
    }

    # ---------------- GATE A ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — EXACT TILING: sum_j c_j == pi(x_last) - pi(x_0)", flush=True)
    print("-" * 78, flush=True)
    pi_x0 = pi_at(primes, pts[0])
    pi_xlast = pi_at(primes, pts[-1])
    gate_a_expected = pi_xlast - pi_x0
    gate_a_passed = (total_count == gate_a_expected)
    print(f"  pi(x_0)    = pi({pts[0]:.10g}) = {pi_x0}", flush=True)
    print(f"  pi(x_last) = pi({pts[-1]:.10g}) = {pi_xlast}", flush=True)
    print(f"  pi(x_last) - pi(x_0) = {gate_a_expected}", flush=True)
    print(f"  sum_j c_j            = {total_count}", flush=True)
    print(f"  difference           = {total_count - gate_a_expected}",
          flush=True)
    print(f"  GATE A: {'PASSED   (no gap, no overlap)' if gate_a_passed else 'FAILED'}",
          flush=True)

    # ---------------- GATE B ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE B — TIES TO THE TABLE: at --x0 2 --ratio 2.0, c_j must "
          "reproduce", flush=True)
    print("         N(r) = pi(2^r) - pi(2^(r-1)) from pi2n_cache.json "
          "(READ ONLY)", flush=True)
    print("-" * 78, flush=True)
    gate_b_passed = None
    gate_b_note = None
    gate_b_n_compared = 0
    gate_b_mismatches = []
    gate_b_r_range = None
    if abs(r - 2.0) > 0.0:
        gate_b_note = (f"not applicable: --ratio {r:g} is not 2.0, so this "
                       "ladder is not the dyadic one")
        print(f"  {gate_b_note}", flush=True)
        print("  gate_b_passed recorded as null.", flush=True)
    else:
        print(f"  source: {args.cache}   (READ ONLY)", flush=True)
        cache = None
        try:
            with open(args.cache, "r") as fh:
                cache = {int(k): int(v) for k, v in json.load(fh).items()}
            print(f"  cache entries: {len(cache)}  n range "
                  f"{min(cache)}..{max(cache)}", flush=True)
        except Exception as exc:
            gate_b_note = f"cache not readable: {exc}"
            print(f"  {gate_b_note}", flush=True)
            print("  GATE B NOT RUN — gate_b_passed recorded as null.",
                  flush=True)
        if cache is not None:
            gate_b_passed = True
            rs = []
            for j in range(n_blocks):
                a = math.log2(pts[j])
                b = math.log2(pts[j + 1])
                ai, bi = int(round(a)), int(round(b))
                if abs(a - ai) > 1e-9 or abs(b - bi) > 1e-9 or bi != ai + 1:
                    continue
                if ai not in cache or bi not in cache:
                    continue
                expected = cache[bi] - cache[ai]
                gate_b_n_compared += 1
                rs.append(bi)
                if counts[j] != expected:
                    gate_b_passed = False
                    gate_b_mismatches.append({
                        "j": j, "r": bi, "x_j": pts[j], "x_j1": pts[j + 1],
                        "c_j": counts[j], "N_r_from_cache": expected,
                        "difference": counts[j] - expected})
            if rs:
                gate_b_r_range = [min(rs), max(rs)]
            print(f"  r values compared : {gate_b_n_compared}"
                  + (f"   (r = {gate_b_r_range[0]}..{gate_b_r_range[1]})"
                     if gate_b_r_range else ""), flush=True)
            print(f"  mismatches        : {len(gate_b_mismatches)}", flush=True)
            for m in gate_b_mismatches[:20]:
                print(f"    j={m['j']} r={m['r']} c_j={m['c_j']} "
                      f"N(r)={m['N_r_from_cache']} diff={m['difference']}",
                      flush=True)
            if gate_b_n_compared == 0:
                gate_b_passed = None
                gate_b_note = ("ratio is 2.0 but no block endpoints are "
                               "consecutive powers of two present in the "
                               "cache; nothing compared")
                print(f"  {gate_b_note}", flush=True)
                print("  gate_b_passed recorded as null.", flush=True)
            else:
                gate_b_note = (f"compared {gate_b_n_compared} r values against "
                               f"{os.path.basename(args.cache)}")
                print(f"  GATE B: {'PASSED' if gate_b_passed else 'FAILED'}",
                      flush=True)

    # ---------------- GATE C ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE C — SANITY ON li: li(10^6) against the known value, and "
          "pi(10^6) from the sieve", flush=True)
    print("-" * 78, flush=True)
    old_dps = mp.dps
    try:
        mp.dps = dps
        li_1e6 = float(mpmath.li(mpmath.mpf(GATE_C_X)))
    finally:
        mp.dps = old_dps
    if xmax >= GATE_C_X:
        pi_1e6 = pi_at(primes, GATE_C_X)
        pi_1e6_note = "from this run's sieve"
    else:
        pi_1e6 = None
        pi_1e6_note = f"not available: --xmax {xmax} < {GATE_C_X}"
    gate_c_li_abs = abs(li_1e6 - GATE_C_LI_KNOWN)
    gate_c_li_ok = gate_c_li_abs < 0.001
    gate_c_pi_ok = (None if pi_1e6 is None else (pi_1e6 == GATE_C_PI_KNOWN))
    print(f"  li(10^6) computed at dps {dps} : {li_1e6:.6f}", flush=True)
    print(f"  li(10^6) known value           : {GATE_C_LI_KNOWN}...", flush=True)
    print(f"  |difference|                   : {gate_c_li_abs:.6g}   "
          f"(known value quoted to 3 dp)", flush=True)
    print(f"  pi(10^6) from the sieve        : {pi_1e6}   ({pi_1e6_note})",
          flush=True)
    print(f"  pi(10^6) known value           : {GATE_C_PI_KNOWN}", flush=True)
    if pi_1e6 is not None:
        print(f"  li(10^6) - pi(10^6)            : "
              f"{li_1e6 - pi_1e6:.6f}", flush=True)
    print(f"  GATE C: li match "
          f"{'PASSED' if gate_c_li_ok else 'FAILED'}, pi match "
          f"{'PASSED' if gate_c_pi_ok else ('NOT RUN' if gate_c_pi_ok is None else 'FAILED')}",
          flush=True)

    # ---------------- GATE D ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE D — riemannr SANITY: R(10^6) against pi(10^6) = 78498, and "
          "against li(10^6)", flush=True)
    print("-" * 78, flush=True)
    old_dps = mp.dps
    try:
        mp.dps = dps
        R_1e6 = float(riemannr_at(GATE_D_X))
    finally:
        mp.dps = old_dps
    gate_d_R_abs = abs(R_1e6 - GATE_D_PI_KNOWN)
    gate_d_li_abs = abs(GATE_D_LI_KNOWN - GATE_D_PI_KNOWN)
    gate_d_passed = bool(gate_d_R_abs < gate_d_li_abs)
    print(f"  R implementation               : {RIEMANNR_IMPL}", flush=True)
    print(f"  R(10^6) computed at dps {dps}   : {R_1e6:.6f}", flush=True)
    print(f"  pi(10^6) from the sieve        : {pi_1e6}   ({pi_1e6_note})",
          flush=True)
    print(f"  pi(10^6) known value           : {GATE_D_PI_KNOWN}", flush=True)
    print(f"  |R(10^6) - 78498|              : {gate_d_R_abs:.6f}", flush=True)
    print(f"  li(10^6) reference             : {GATE_D_LI_KNOWN}", flush=True)
    print(f"  |li(10^6) - 78498|             : {gate_d_li_abs:.6f}", flush=True)
    print(f"  criterion: |R - pi| < |li - pi|", flush=True)
    print(f"  GATE D: {'PASSED' if gate_d_passed else 'FAILED'}", flush=True)

    # ---------------- verdict -----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("BAND VERDICT — pre-registered, applied mechanically", flush=True)
    print("-" * 78, flush=True)
    print("  This instrument has NO sigma and NO t; it works on the raw count "
          "residual.", flush=True)
    print("  There is therefore exactly ONE verdict per (x0, ratio, xmax) "
          "setting.", flush=True)
    print(f"\n  configuration : x0 = {x0:g}, ratio = {r:g}, xmax = {xmax}",
          flush=True)
    print(f"  band half-width used : {band_halfwidth:.6f}   "
          f"(floor {BAND_HALFWIDTH_FLOOR:g}, one resolution element "
          f"{freq_res:.6f})", flush=True)
    print(f"  threshold            : {BAND_MEDIAN_FACTOR:g} x median(P)",
          flush=True)
    print(f"\n  VERDICT: {cls['verdict']}", flush=True)

    # ---------------- read the result ---------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  c_j are EXACT INTEGER prime counts by binary search; no float "
          "approximation to", flush=True)
    if smooth == "R":
        print("  pi(x) is used anywhere. L_j is an mpmath R difference "
              f"(--smooth R; R = Riemann's function) at dps {dps}, cast to",
              flush=True)
    else:
        print("  pi(x) is used anywhere. L_j is an mpmath li difference "
              f"(--smooth li) at dps {dps}, cast to", flush=True)
    print("  float only after the cancellation. The projection is float64.",
          flush=True)
    print("  The theta scan is a fixed printed list, not a search: no theta is "
          "selected.", flush=True)
    print("  P(gamma) is an INNER PRODUCT, not a fit. The bands were fixed "
          "before the run.", flush=True)
    print(f"  gate A (exact tiling)   : "
          f"{'PASSED' if gate_a_passed else 'FAILED'}", flush=True)
    print(f"  gate B (ties to table)  : "
          f"{'PASSED' if gate_b_passed else ('NOT RUN / N-A' if gate_b_passed is None else 'FAILED')}",
          flush=True)
    print(f"  gate C (li sanity)      : li "
          f"{'PASSED' if gate_c_li_ok else 'FAILED'}, pi "
          f"{'PASSED' if gate_c_pi_ok else ('NOT RUN' if gate_c_pi_ok is None else 'FAILED')}",
          flush=True)
    print(f"  gate D (riemannr sanity): "
          f"{'PASSED' if gate_d_passed else 'FAILED'}", flush=True)
    print(f"  smooth model used       : {smooth}  ({RIEMANNR_IMPL})", flush=True)
    print(f"  verdict                 : {cls['verdict']}", flush=True)
    print(f"  theta-crossing band     : {crossing_band['band_verdict']}  "
          f"(crossings "
          + ", ".join("null" if c is None else format(c, ".6f")
                      for c in theta_crossings) + ")", flush=True)
    print("  Interpretation of these numbers is NOT this script's job.",
          flush=True)

    # ---------------- payload -----------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT

        rows = []
        for j in range(n_blocks):
            rows.append({
                "j": j,
                "x_j": float(xj[j]),
                "x_j_plus_1": float(xj1[j]),
                "c_j": int(counts[j]),
                "L_j": float(Lj[j]),
                "e_j": float(ej[j]),
                "ehat_j": float(ehat[j]),
                "L_j_li": float(Lj_li[j]),
                "L_j_R": float(Lj_R[j]),
                "D_j": float(Dj[j]),
                "D_j_over_sqrt_x": float(Dhat[j]),
            })

        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "xmax": xmax,
                "x0": x0,
                "ratio": r,
                "gamma_max": args.gamma_max,
                "gamma_step": args.gamma_step,
                "n_gamma": n_gamma,
                "dps": dps,
                "smooth": smooth,
                "riemannr_impl": RIEMANNR_IMPL,
                "cache_path": args.cache,
                "n_primes": n_primes,
                "largest_prime": largest_prime,
                "ladder_points": n_pts,
                "n_blocks": n_blocks,
                "x_first": float(pts[0]),
                "x_last": float(pts[-1]),
                "log_ratio": log_r,
                "nyquist_gamma": nyquist,
                "dyadic_nyquist_gamma": dyadic_nyquist,
                "projection_log_x_span": span,
                "frequency_resolution": freq_res,
                "band_halfwidth_floor": BAND_HALFWIDTH_FLOOR,
                "band_halfwidth_used": band_halfwidth,
                "band_median_factor": BAND_MEDIAN_FACTOR,
                "window": "hann",
                "theta_scan": list(theta_grid),
                "theta_min": float(args.theta_min),
                "theta_max": float(args.theta_max),
                "theta_step": float(args.theta_step),
                "theta_grid_n": len(theta_grid),
                "theta_scan_legacy5": list(THETA_SCAN_LEGACY5),
                "theta_cutoffs": [float(c) for c in theta_cutoffs],
                "theta_cutoffs_raw": str(args.theta_cutoffs),
                "block_definition":
                    "disjoint half-open intervals (x_j, x_{j+1}] tiling "
                    "(x_0, x_last]; every prime used exactly once",
                "count_definition":
                    "c_j = pi(x_{j+1}) - pi(x_j), exact integer via "
                    "np.searchsorted(primes, x, side='right')",
                "smooth_definition":
                    ("L_j = li(x_{j+1}) - li(x_j)" if smooth == "li" else
                     "L_j = R(x_{j+1}) - R(x_j), R = Riemann's function "
                     "sum_n mu(n)/n li(x^(1/n))")
                    + ", differenced in mpf at the recorded dps, cast to "
                      "float afterwards",
                "smooth_diagnostic_definition":
                    "D_j = (li(x_{j+1}) - li(x_j)) - (R(x_{j+1}) - R(x_j)); "
                    "normalised D_j / sqrt(x_j). Both smooth models are "
                    "computed every run regardless of --smooth",
                "residual_definition": "e_j = c_j - L_j",
                "normalisation": "ehat_j = e_j / sqrt(x_j)",
                "theta_scan_definition":
                    "e_j / x_j^theta over a FIXED grid of theta "
                    "(--theta-min .. --theta-max inclusive, step "
                    "--theta-step); half-ladder RMS ratio reported per theta. "
                    "A parameter-free scan, NOT a fit — no theta is selected "
                    "by the script. The original five values "
                    "{0.25, 0.375, 0.5, 0.625, 0.75} are reported separately "
                    "under theta_scan_legacy5 so earlier runs stay comparable",
                "theta_cutoff_scan_definition":
                    "the same half-ladder RMS theta scan and the same "
                    "projection re-run on the blocks with x_j >= cutoff, over "
                    "a FIXED cutoff list evaluated EXHAUSTIVELY. NOT a fit and "
                    "NOT a search for the best cutoff. Trimming the low end "
                    "shortens the log-x span and therefore worsens the "
                    "frequency resolution, so the band half-width "
                    "max(0.6, resolution) grows with the cutoff — a tradeoff "
                    "being measured, not a defect",
                "projection_definition":
                    "P(gamma) = |sum_j w_j * ehat_j * exp(-i gamma log x_j)|, "
                    "w = hann; inner product, not a fit",
                "fit_free": True,
                "precision":
                    "mixed: EXACT integer prime counts (numpy int64 array + "
                    f"binary search); mpmath li at mp.dps = {dps} with the "
                    "difference taken in mpf; float64 residual, theta scan "
                    "and projection",
            },
            "constants": {
                "gamma_1": GAMMA_1,
                "gamma_2": GAMMA_2,
                "gamma_3": GAMMA_3,
                "gamma_4": GAMMA_4,
                "gamma_5": GAMMA_5,
                "gamma_6": GAMMA_6,
                "gammas": list(GAMMAS),
                "core_quantity_note": (
                    "e = c - (li(upper) - li(lower)) is the project's core "
                    "residual; CONTEXT.md defines e(r) as that quantity on "
                    "the dyadic ladder, which is this script at x0 = 2, "
                    "ratio = 2"),
                "disjointness_note": (
                    "O12-O15 summed primes[N:2N] indexed by PRIME INDEX: "
                    "consecutive rungs overlapped (~90% shared primes at "
                    "ratio 1.1) and the count was fixed at N by construction, "
                    "so the count carried no fluctuation. Here the blocks are "
                    "disjoint in VALUE space and the count fluctuates"),
                "sampling_note": (
                    "log x steps by log(r), so the projection Nyquist is "
                    "pi/log(r); at r = 1.1 that is 32.96, clearing "
                    "gamma_1..gamma_3"),
                "band_rule": (
                    "DETECT: global max of P within the band half-width of one "
                    "of gamma_1..gamma_6 AND > 5x median(P); WEAK: a local "
                    "peak within the band of one of the six > 5x median(P) but "
                    "the global max is elsewhere; NULL: neither"),
                "band_halfwidth_rule": (
                    "max(0.6, one frequency resolution element). Deliberate: "
                    "in O15 the pre-registered half-width 0.5 was NARROWER "
                    "than one resolution element (0.605) so the band could "
                    "barely fire. The band here is at least one resolution "
                    "element wide by construction"),
                "theta_crossing_band_rule": (
                    "on the interpolated theta crossing as the cutoff rises "
                    "through the fixed list, in precedence order: CONVERGE = "
                    "the crossing increases monotonically across the cutoffs "
                    "AND reaches within 0.05 of 0.50 at some cutoff; RISES = "
                    "increases monotonically but never reaches within 0.05 of "
                    "0.50; FLAT = the total change across all cutoffs is less "
                    "than 0.02; ERRATIC = not monotone and total change >= "
                    "0.02. UNDEFINED when any crossing is null"),
                "one_verdict_note": (
                    "this instrument has no sigma and no t — it works on the "
                    "raw count residual — so there is ONE verdict per "
                    "(x0, ratio, xmax) setting"),
                "o10_note": (
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script"),
                "gate_c_li_known": GATE_C_LI_KNOWN,
                "gate_c_pi_known": GATE_C_PI_KNOWN,
            },
            "summary": {
                "n_blocks": n_blocks,
                "total_count": total_count,
                "block_size_min": int(min(counts)),
                "block_size_max": int(max(counts)),
                "ehat_stats": ehat_stats,
                "smooth_model": smooth,
                "smooth_difference_stats": D_stats,
                "theta_scan": theta_rows,
                "theta_scan_crossing_interpolated": theta_full_crossing,
                "theta_scan_legacy5": theta_rows_legacy5,
                "theta_cutoff_scan": theta_cutoff_scan,
                "projection": cls,
                "verdict": cls["verdict"],
                "gate_a": {
                    "statement": "sum_j c_j == pi(x_last) - pi(x_0)",
                    "pi_x0": pi_x0,
                    "pi_x_last": pi_xlast,
                    "expected": gate_a_expected,
                    "sum_c_j": total_count,
                    "difference": total_count - gate_a_expected,
                    "passed": bool(gate_a_passed),
                },
                "gate_b": {
                    "statement": ("at x0 = 2, ratio = 2.0, c_j == N(r) = "
                                  "pi(2^r) - pi(2^(r-1)) from pi2n_cache.json"),
                    "note": gate_b_note,
                    "n_compared": gate_b_n_compared,
                    "r_range": gate_b_r_range,
                    "mismatches": len(gate_b_mismatches),
                    "mismatch_detail": gate_b_mismatches[:50],
                    "passed": (None if gate_b_passed is None
                               else bool(gate_b_passed)),
                },
                "gate_c": {
                    "statement": ("li(10^6) against the known 78627.549..., "
                                  "and pi(10^6) = 78498 from the sieve"),
                    "x": GATE_C_X,
                    "li_computed": li_1e6,
                    "li_known": GATE_C_LI_KNOWN,
                    "li_abs_difference": gate_c_li_abs,
                    "li_passed": bool(gate_c_li_ok),
                    "pi_from_sieve": pi_1e6,
                    "pi_known": GATE_C_PI_KNOWN,
                    "pi_passed": (None if gate_c_pi_ok is None
                                  else bool(gate_c_pi_ok)),
                    "pi_note": pi_1e6_note,
                    "li_minus_pi": (None if pi_1e6 is None
                                    else li_1e6 - pi_1e6),
                },
                "gate_d": {
                    "statement": ("R(10^6) against pi(10^6) = 78498; criterion "
                                  "|R(10^6) - 78498| < |li(10^6) - 78498| "
                                  "with li(10^6) = 78627.549"),
                    "x": GATE_D_X,
                    "riemannr_impl": RIEMANNR_IMPL,
                    "R_computed": R_1e6,
                    "pi_from_sieve": pi_1e6,
                    "pi_known": GATE_D_PI_KNOWN,
                    "R_abs_difference": gate_d_R_abs,
                    "li_reference": GATE_D_LI_KNOWN,
                    "li_abs_difference": gate_d_li_abs,
                    "passed": gate_d_passed,
                },
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
