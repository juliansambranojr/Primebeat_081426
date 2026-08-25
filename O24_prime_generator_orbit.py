#!/usr/bin/env python3
"""
O24 — Prime-generator orbit: how does detection scale with the NUMBER of prime
      generators, and does it saturate?

Reads with: O18_joint_multiplicative_ladder.py (this script reuses its machinery
VERBATIM — sieve_primes, pi_at, smooth_multipliers, gap_stats, RCache /
riemannr_at, hann, project, classify_projection, local_peaks, surrogate_null,
gate_b_check, _jsonable, _write_results, _safe_div, the formatters); O17;
O12-O16; DT-A5; DT-A6; this bench's `pi2n_cache.json` (READ ONLY).

NAMING
------
The O-series in this tree runs O1-O9, O11..O18 and onward. There is NO O10:
that number is a known, DELIBERATE GAP, and this script does not fill it,
because filling a reserved gap with unrelated work would silently rewrite the
series' history. This file takes O24. Capital "O" per `CLAUDE.md` § "Naming
convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

O18 showed that the integer bases are blind to the zeros SINGLY but not
JOINTLY: at x0 = 2, the pure dyadic ladder L2 and the pure triadic ladder L3
both returned NULL, while the joint orbit L23 = {2^m 3^n} detected gamma_2 at
P_max/median = 6.95, and the three-generator orbit L235 = {2^m 3^n 5^k}
detected gamma_4 at 16.37.

Only PRIME bases add generators. Bases 4, 8, 9 lie INSIDE the multiplicative
semigroup that 2 and 3 already generate, so adjoining them does not densify the
orbit at all — {2^m 3^n 4^p 8^q 9^r} is the same point set as {2^m 3^n}. The
distinct generators available from a triadic-through-enneadic family are
therefore exactly 2, 3, 5, 7.

O18 hardcoded at most three generators. This script makes the generator set a
PARAMETER and sweeps the NESTED family

    G1 = {2}        G2 = {2,3}        G3 = {2,3,5}        G4 = {2,3,5,7}

on identical settings — identical sieve, identical block tiling, identical
Riemann R smooth term, identical ehat, identical Hann window, identical
projection, identical surrogate control, identical gates, identical house
envelope. Each set is a SUPERSET of the previous one, which is the whole point:
the only thing that changes from step to step is that one more prime generator
is adjoined and the orbit densifies.

The question is how detection SCALES with the number of prime generators, and
whether it SATURATES.

This script does NOT interpret the mathematics; it states numbers and applies
pre-registered rules mechanically.

=============================================================================
WHAT IS COMPUTED — identical pipeline per generator set
=============================================================================

For each G in the nested family:

1. LADDER = all products of the generators of G with non-negative exponents,
   times x0, that are <= xmax. Sorted ascending and deduplicated EXACTLY (the
   multipliers are built as exact Python integers, so the dedup is exact and
   not a float tolerance). Reported: rung count, first x, last x, and the
   min / median / max log-gap.
2. BLOCKS are the consecutive intervals (x_j, x_{j+1}] of that sorted ladder —
   disjoint, tiling. c_j = pi(x_{j+1}) - pi(x_j) by np.searchsorted on the
   sieved prime array: EXACT integer counts, no float approximation to pi(x)
   anywhere.
3. SMOOTH TERM L_j = R(x_{j+1}) - R(x_j) with R = mpmath.riemannr at --dps,
   differenced in mpf and cast to float only afterwards. e_j = c_j - L_j.
4. ehat_j = e_j / sqrt(x_j).
5. PROJECTION — a NON-UNIFORM DFT, i.e. a direct sum, valid for arbitrary x_j:

       P(gamma) = | sum_j w_j * ehat_j * exp(-i * gamma * log x_j) |

   w_j a Hann window over j; gamma grid 0 to --gamma-max in steps of
   --gamma-step.
6. REPORTED per G: the frequency resolution 2*pi/(log x_last - log x_first)
   over the projection's own points; the band half-width max(0.6, resolution);
   median(P); the gamma of the global maximum and P_max/median; the ten largest
   local peaks; and P(gamma_n)/median at the first SIX zeros
   gamma = 14.134725, 21.022040, 25.010858, 30.424876, 32.935062, 37.586178.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

PER-G VERDICT, the SAME rule as O18. BAND HALF-WIDTH per G = max(0.6, that G's
frequency resolution); the value actually used is RECORDED.

    DETECT  the GLOBAL maximum of P lies within the band of one of the six
            gamma_n AND exceeds 5.0 x median(P)
    WEAK    a LOCAL peak within the band of one of the six exceeds 5.0 x
            median(P), but the global maximum is elsewhere
    NULL    neither

THE SCALING BAND, on P_max/median across the chain G1 -> G2 -> G3 -> G4:

    GROWS       increases at every step, AND the final step gains >= 10%
    SATURATES   increases at every step, BUT the final step gains < 10%
    FALLS       decreases at any step

Precedence FALLS > GROWS > SATURATES > UNCLASSIFIED; UNCLASSIFIED covers the
case where a step is exactly flat (neither an increase nor a decrease) or a
value is non-finite. All four values and the per-step percentage changes are
reported.

SEPARATELY and mechanically: at which G the per-G verdict FIRST becomes DETECT,
and whether it STAYS DETECT for every G thereafter.

=============================================================================
CONTROL
=============================================================================

SURROGATE CONTROL, per G. ehat_j is replaced by a surrogate that preserves the
amplitude distribution exactly: a random permutation of the ehat values across
j, drawn with numpy default_rng at the FIXED seed recorded in params.
--surrogates surrogates per G (default 200), identical projection. Reported per
G: the surrogate distribution of P_max/median (min, median, 95th percentile,
max) and the percentile at which the real value falls in it; and the same for
P/median AT gamma_1.

THIS IS THE CONTROL THAT MATTERS: combining irregular samples can manufacture
peaks, and if the real value is not beyond the surrogate 95th percentile the
detection is not established.

=============================================================================
GATES — all three RUN inside the script and recorded in the payload
=============================================================================

GATE A — EXACT TILING, per G. sum_j c_j must equal pi(x_last) - pi(x_0)
EXACTLY, verified with exact integers via searchsorted at the two outer
endpoints.

GATE B — TIES TO THE TABLE. G1 is the pure dyadic ladder; with --x0 2 its
counts must reproduce N(r) = pi(2^r) - pi(2^(r-1)) from `pi2n_cache.json`
(READ ONLY) for every r in range. The cache is READ, never hardcoded. Cells
compared and mismatches are reported. When x0 is not a power of two the gate is
recorded as "not applicable" with that reason.

GATE C — SANITY ON R. R(10^6) against pi(10^6) = 78498 from the sieve;
|R(10^6) - 78498| is recorded and the PASS criterion is that it is smaller than
|li(10^6) - 78498| = 129.549.

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` — ONE ROW PER (generator set, block), carrying the
generator-set name, its generators, j, x_j, x_{j+1}, c_j, L_j, e_j, ehat_j.
`params.code_version` is the sha256 of THIS file, read from `__file__` at
runtime. `params.precision` records the mix.

REQUIREMENTS
------------
    numpy, mpmath   (both already present in this bench's .venv)

USAGE
-----
    python3 O24_prime_generator_orbit.py
    python3 O24_prime_generator_orbit.py --x0 2 --generators "2,3,5,7" \
        --out results/O24_prime_generator_orbit_results.json
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
        "term L_j = R(x_{j+1}) - R(x_j) is computed at high precision and there "
        "is no float fallback. This bench's O8/O9/O3/O17/O18 already depend on "
        "mpmath; if the import failed the .venv is not the one described in "
        "REFERENCES.md. Install with: pip install mpmath")

# --------------------------------------------------------------------------
# Smooth-model backend detection, done ONCE at import — same contract as O18.
# --------------------------------------------------------------------------
_HAS_RIEMANNR = hasattr(mpmath, "riemannr")
RIEMANNR_IMPL = "mpmath.riemannr" if _HAS_RIEMANNR else "mobius_sum"

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

# Pre-registered band constants — identical to O18.
BAND_HALFWIDTH_FLOOR = 0.6
BAND_MEDIAN_FACTOR = 5.0

# Pre-registered scaling band: the final step must gain at least this fraction
# for GROWS rather than SATURATES.
SCALING_FINAL_STEP_MIN_GAIN_FRAC = 0.10

# Gate C reference values.
GATE_C_X = 1000000
GATE_C_PI_KNOWN = 78498
GATE_C_LI_KNOWN = 78627.549
GATE_C_LI_ABS_KNOWN = 129.549      # |li(10^6) - 78498|, quoted in the brief


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
    O18_joint_multiplicative_ladder.py: the result is kept as sorted int64,
    because this script counts primes by searchsorted and must not lose
    exactness at 1.5e8.
    """
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.int64)


class PrimecountPi:
    """
    PI BACKEND (instrument-fix pass, 2026-08-25). Exact prime counting
    without the sieve: pi(floor(x)) via primecountpy (Deleglise-Rivat),
    memoized per distinct floored key. Purpose: the sieve backend needs
    ~xmax bytes of RAM (400 GB at xmax = 4e11 — The-Four-Prime-Peak D4's
    "far beyond what this instrument reaches" was a memory fact), while
    primecountpy computes pi(4e11) in 8 ms with no array at all.

    Floor semantics are IDENTICAL to pi_at's array path: both count
    {p prime : p <= floor(x)}, so for every key the two backends return
    the same integer, and results are backend-independent. Verified by
    running both backends at identical flags and diffing result JSONs
    (see the instrument-fix entry of 2026-08-25).
    """

    def __init__(self):
        import primecountpy
        self._pi = primecountpy.prime_pi
        self._memo = {}

    def __call__(self, x):
        k = math.floor(x)
        v = self._memo.get(k)
        if v is None:
            v = int(self._pi(k))
            self._memo[k] = v
        return v


def pi_at(primes, x):
    """
    EXACT pi(x) = number of primes <= x, by binary search on the sorted prime
    array. side="right" so the interval (x_j, x_{j+1}] is half-open on the left
    and closed on the right — the same convention as the dyadic table's
    (2^(r-1), 2^r].

    INSTRUMENT FIX 2026-08-17 — PERFORMANCE ONLY, RESULTS UNCHANGED.
    ---------------------------------------------------------------
    WHAT CHANGED. The search key is now floored to an exact Python int before
    being handed to np.searchsorted. Previously the key arrived as a Python
    float (ladder_from_multipliers returns float(x0) * float(m)), and numpy
    promotes int64-array-vs-float-scalar to float64, so EVERY call materialised
    a float64 copy of the WHOLE prime array. Measured at ~50M primes: 12.1 ms
    per call with a float key against 0.0013 ms with an integer key. Cost scales
    as (number of rungs) x pi(xmax), which is why the xmax = 1e9 sweep took
    ~30 min and xmax = 3e9 ~2 h. Nothing else in this function, and nothing
    anywhere else in this script, was touched.

    WHY IT IS SEMANTICALLY IDENTICAL, not merely faster. `primes` holds
    integers. For any real key k, {p in primes : p <= k} == {p in primes :
    p <= floor(k)}, because no integer lies in (floor(k), k]. side="right"
    returns exactly that count, so flooring the key cannot move the answer —
    and it is the floor, not a round or a truncate-toward-zero, that is
    required, which is why math.floor is used rather than int(); on this
    ladder x > 0 always (smooth_multipliers rejects x0 <= 0 and every
    multiplier is >= 1) so the two agree, but math.floor is the correct
    statement of the invariant. math.floor of a Python float yields the exact
    integer with no rounding at any magnitude. The float path it replaces was
    itself exact here only because both the keys and the primes stay below
    2^53 (the sieve is an in-memory bool array, so xmax can never approach
    that); the int path is exact unconditionally. Boundary behaviour is
    therefore preserved at every rung, including keys that land exactly on a
    prime.

    COMPARABILITY. Results produced by the previous version REMAIN FULLY
    COMPARABLE to results produced by this one. This is a speed fix with no
    effect on any measured quantity: same counts, same residuals, same
    projections, same surrogates, same verdicts. Verified 2026-08-17 by
    running the pre-fix and post-fix scripts on identical flags and comparing
    the result JSONs cell by cell — byte-identical apart from timestamps and
    the recorded code_version sha.

    This is the ONE place where this script no longer matches O18's pi_at
    verbatim; the difference is the key coercion above and nothing else.

    PI BACKEND DISPATCH (instrument-fix pass, 2026-08-25): when `primes`
    is a PrimecountPi object rather than an int64 array, the count comes
    from primecountpy under the identical floor semantics — see the
    PrimecountPi docstring. The array path below is byte-unchanged.
    """
    if isinstance(primes, PrimecountPi):
        return primes(x)
    return int(np.searchsorted(primes, math.floor(x), side="right"))


# --------------------------------------------------------------------------
# Ladder construction. Multipliers are EXACT Python integers, so the sort and
# the deduplication are exact and not a float tolerance. Verbatim from O18.
# --------------------------------------------------------------------------

def smooth_multipliers(generators, x0, xmax):
    """
    Every product of the given generators (with non-negative exponents) m such
    that x0 * m <= xmax. Returned sorted ascending and deduplicated EXACTLY, as
    Python ints. With generators = (2,) this is the pure dyadic multiplier set;
    with (2, 3) the joint multiplicative semigroup; with (2, 3, 5) and
    (2, 3, 5, 7) the three- and four-generator ones.
    """
    x0f = float(x0)
    xmaxf = float(xmax)
    if x0f <= 0.0:
        raise SystemExit("--x0 must be > 0")
    acc = {1}
    for g in generators:
        nxt = set()
        for base in acc:
            v = base
            while x0f * v <= xmaxf:
                nxt.add(v)
                v *= g
        acc = nxt
        if not acc:
            break
    return sorted(acc)


def ladder_from_multipliers(x0, mults):
    """x_j = x0 * m for each exact integer multiplier m, ascending."""
    return [float(x0) * float(m) for m in mults]


def gap_stats(pts):
    """min / median / max / mean / n of the log-x gaps between consecutive
    rungs, plus the total log-x span of the ladder."""
    lg = np.log(np.asarray(pts, dtype=np.float64))
    if lg.size < 2:
        return {"n_gaps": 0, "min": None, "median": None, "max": None,
                "mean": None, "spread_max_minus_min": None,
                "log_span_full_ladder": 0.0}
    d = np.diff(lg)
    return {
        "n_gaps": int(d.size),
        "min": float(np.min(d)),
        "median": float(np.median(d)),
        "max": float(np.max(d)),
        "mean": float(np.mean(d)),
        "spread_max_minus_min": float(np.max(d) - np.min(d)),
        "log_span_full_ladder": float(lg[-1] - lg[0]),
    }


# --------------------------------------------------------------------------
# Smooth model — Riemann's R, same backend contract as O18.
# --------------------------------------------------------------------------

def _mobius_table(nmax):
    """mu(n) for n = 0..nmax by a small linear sieve. mu[0] unused, set 0."""
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


class RCache:
    """
    R(x) at mp.dps = dps, memoised on the float x. The generator sets are
    NESTED (G1 subset G2 subset G3 subset G4), so memoising is what keeps the
    mpmath work proportional to the number of DISTINCT ladder points — i.e. to
    |G4's ladder| alone rather than the sum over all four.
    """

    def __init__(self, dps):
        self.dps = int(dps)
        self._d = {}
        self.n_computed = 0

    def get(self, x):
        key = float(x)
        v = self._d.get(key)
        if v is None:
            old = mp.dps
            try:
                mp.dps = self.dps
                v = riemannr_at(key)
            finally:
                mp.dps = old
            self._d[key] = v
            self.n_computed += 1
        return v

    def diffs(self, pts):
        """L_j = R(x_{j+1}) - R(x_j), differenced in mpf, cast to float after."""
        vals = [self.get(x) for x in pts]
        return [float(vals[j + 1] - vals[j]) for j in range(len(pts) - 1)]


# --------------------------------------------------------------------------
# Projection machinery — copied from O18 so the two instruments agree exactly.
# --------------------------------------------------------------------------

def hann(n):
    """Hann window over n points: 0.5 - 0.5 cos(2 pi i / (n-1)). n<=1 -> ones."""
    if n <= 1:
        return np.ones(max(n, 0), dtype=np.float64)
    i = np.arange(n, dtype=np.float64)
    return 0.5 - 0.5 * np.cos(2.0 * math.pi * i / (n - 1))


def project(logx, ehat, w, gammas):
    """
    P(gamma) = | sum_j w_j ehat_j exp(-i gamma log x_j) | on a gamma grid.
    This is a NON-UNIFORM DFT — a direct sum — and is valid for arbitrary,
    irregularly spaced x_j. No FFT and no resampling anywhere.
    """
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
    Identical to O18's classify_projection.

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


# --------------------------------------------------------------------------
# Surrogate control — amplitude-preserving permutation. Verbatim from O18's C1.
# --------------------------------------------------------------------------

def _percentile_of(value, sample):
    """
    Percentile at which `value` falls in `sample`: 100 * (#sample < value) / n.
    Guarded; returns nan on an empty sample or a non-finite value.
    """
    a = np.asarray(sample, dtype=np.float64)
    a = a[np.isfinite(a)]
    try:
        v = float(value)
    except (TypeError, ValueError):
        return float("nan")
    if a.size == 0 or not math.isfinite(v):
        return float("nan")
    return float(100.0 * np.count_nonzero(a < v) / a.size)


def _dist(sample):
    """min / median / p95 / max / n of a sample, guarded."""
    a = np.asarray(sample, dtype=np.float64)
    a = a[np.isfinite(a)]
    if a.size == 0:
        return {"n": 0, "min": None, "median": None, "p95": None, "max": None}
    return {"n": int(a.size), "min": float(np.min(a)),
            "median": float(np.median(a)),
            "p95": float(np.percentile(a, 95.0)),
            "max": float(np.max(a))}


def _real_vs_surrogates(real, sample):
    """
    One statistic against its surrogate distribution: the distribution itself,
    the real value, the percentile at which the real value falls in it, and
    whether the real value is beyond the surrogate 95th percentile. Guarded
    throughout; a non-finite real value or an empty sample gives None.
    """
    d = _dist(sample)
    try:
        rv = float(real)
        rv = rv if math.isfinite(rv) else None
    except (TypeError, ValueError):
        rv = None
    exceeds = None
    if rv is not None and d["p95"] is not None:
        exceeds = bool(rv > d["p95"])
    return {
        "surrogate_distribution": d,
        "real_value": rv,
        "real_percentile_in_surrogates": _percentile_of(real, sample),
        "real_exceeds_surrogate_p95": exceeds,
    }


def surrogate_null(logx, ehat, w, gammas, n_surr, seed, real_max_ratio,
                   real_g1_ratio, g1_index):
    """
    n_surr surrogates, each a random PERMUTATION of the ehat values across j —
    the amplitude distribution is preserved exactly and only the pairing with
    the sample positions is destroyed. The identical projection is run on each.
    Returns the surrogate distributions of P_max/median and of
    P(gamma_1)/median, and the percentile at which the real values fall.
    """
    rng = np.random.default_rng(int(seed))
    n = int(len(ehat))
    max_ratios = []
    g1_ratios = []
    # Precompute the phase matrices once: the surrogate changes only the vector.
    ph = np.outer(gammas, np.asarray(logx, dtype=np.float64))
    C = np.cos(ph)
    S = np.sin(ph)
    wv = np.asarray(w, dtype=np.float64)
    ev = np.asarray(ehat, dtype=np.float64)
    for _ in range(int(n_surr)):
        perm = rng.permutation(n)
        a = wv * ev[perm]
        re = C @ a
        im = -(S @ a)
        Ps = np.sqrt(re * re + im * im)
        med = float(np.median(Ps))
        max_ratios.append(_safe_div(float(np.max(Ps)), med))
        g1_ratios.append(_safe_div(float(Ps[g1_index]), med))
    return {
        "definition": ("amplitude-preserving surrogate: a random permutation "
                       "of the ehat values across j, projected identically"),
        "n_surrogates": int(n_surr),
        "seed": int(seed),
        "P_max_over_median": _real_vs_surrogates(real_max_ratio, max_ratios),
        "P_at_gamma_1_over_median": _real_vs_surrogates(real_g1_ratio,
                                                        g1_ratios),
        "_max_ratios": [float(v) for v in max_ratios],
        "_g1_ratios": [float(v) for v in g1_ratios],
    }


# --------------------------------------------------------------------------
# The pipeline, run identically on every generator set.
# --------------------------------------------------------------------------

def run_ladder(name, generators, pts, primes, rcache, gammas, g1_index,
               n_surr, seed, description):
    """
    The identical pipeline: exact counts, R difference, ehat, projection,
    pre-registered band, gate A, and the surrogate control.
    """
    n_pts = len(pts)
    n_blocks = max(0, n_pts - 1)
    if n_blocks < 1:
        raise SystemExit(f"generator set {name}: no block survives; raise "
                         "--xmax or lower --x0.")

    gaps = gap_stats(pts)
    med_gap = gaps["median"]
    uniform_equiv_nyquist = _safe_div(math.pi, med_gap)

    pi_pts = [pi_at(primes, x) for x in pts]
    counts = [pi_pts[j + 1] - pi_pts[j] for j in range(n_blocks)]
    total_count = int(sum(counts))

    L = rcache.diffs(pts)

    xj = np.asarray(pts[:n_blocks], dtype=np.float64)
    xj1 = np.asarray(pts[1:n_pts], dtype=np.float64)
    cj = np.asarray(counts, dtype=np.float64)
    Lj = np.asarray(L, dtype=np.float64)
    ej = cj - Lj
    ehat = ej / np.sqrt(xj)

    ehat_stats = {
        "n": int(ehat.size),
        "min": float(np.min(ehat)),
        "max": float(np.max(ehat)),
        "mean": float(np.mean(ehat)),
        "rms": _rms(ehat),
    }

    logx = np.log(xj)
    span = float(logx[-1] - logx[0]) if n_blocks > 1 else 0.0
    freq_res = _safe_div(2.0 * math.pi, span)
    band_halfwidth = max(BAND_HALFWIDTH_FLOOR,
                         freq_res if math.isfinite(freq_res) else 0.0)

    w = hann(n_blocks)
    P = project(logx, ehat, w, gammas)
    cls = classify_projection(gammas, P, band_halfwidth, BAND_MEDIAN_FACTOR)

    # GATE A — exact tiling, per generator set.
    pi_x0 = pi_at(primes, pts[0])
    pi_xlast = pi_at(primes, pts[-1])
    gate_a_expected = pi_xlast - pi_x0
    gate_a = {
        "statement": "sum_j c_j == pi(x_last) - pi(x_0)",
        "pi_x0": pi_x0,
        "pi_x_last": pi_xlast,
        "expected": gate_a_expected,
        "sum_c_j": total_count,
        "difference": total_count - gate_a_expected,
        "passed": bool(total_count == gate_a_expected),
    }

    real_max_ratio = cls["P_max_over_median"]
    real_g1_ratio = cls["P_at_gamma_over_median"][0]
    surr = surrogate_null(logx, ehat, w, gammas, n_surr, seed,
                          real_max_ratio, real_g1_ratio, g1_index)

    return {
        "generator_set": name,
        "generators": [int(g) for g in generators],
        "n_generators": int(len(generators)),
        "description": description,
        "n_rungs": n_pts,
        "n_blocks": n_blocks,
        "x_first": float(pts[0]),
        "x_last": float(pts[-1]),
        "log_gap_stats": gaps,
        "uniform_equivalent_nyquist": uniform_equiv_nyquist,
        "uniform_equivalent_nyquist_note": (
            "pi / median(log-gap). For a SINGLE generator the log-gaps are "
            "constant and this IS the uniform Nyquist limit. For every "
            "multi-generator set the gaps are IRREGULAR and this is a "
            "DESCRIPTIVE NUMBER ONLY and NOT A BOUND, because irregular "
            "sampling is not limited by the uniform rate"),
        "total_count": total_count,
        "block_size_min": int(min(counts)),
        "block_size_max": int(max(counts)),
        "ehat_stats": ehat_stats,
        "projection_log_x_span": span,
        "frequency_resolution": freq_res,
        "band_halfwidth_used": band_halfwidth,
        "projection": cls,
        "verdict": cls["verdict"],
        "gate_a": gate_a,
        "surrogate_null": surr,
        "_counts": counts,
        "_xj": xj,
        "_xj1": xj1,
        "_Lj": Lj,
        "_ej": ej,
        "_ehat": ehat,
    }


# --------------------------------------------------------------------------
# The pre-registered scaling band, applied mechanically.
# --------------------------------------------------------------------------

def classify_scaling(values, names, min_gain_frac):
    """
    The pre-registered scaling band on P_max/median along the nested chain.

        GROWS       increases at every step AND the final step gains
                    >= min_gain_frac
        SATURATES   increases at every step BUT the final step gains
                    < min_gain_frac
        FALLS       decreases at any step

    Precedence FALLS > GROWS > SATURATES > UNCLASSIFIED. UNCLASSIFIED covers an
    exactly flat step (neither an increase nor a decrease) and any non-finite
    value.
    """
    out = {
        "statement": ("on P_max/median across the nested chain "
                      + " -> ".join(names) + ": GROWS = increases at every "
                      "step and the final step gains >= "
                      f"{100.0 * min_gain_frac:g}%; SATURATES = increases at "
                      "every step but the final step gains < "
                      f"{100.0 * min_gain_frac:g}%; FALLS = decreases at any "
                      "step. Precedence FALLS > GROWS > SATURATES > "
                      "UNCLASSIFIED"),
        "min_gain_frac_final_step": float(min_gain_frac),
        "names": list(names),
        "values": [None] * len(values),
        "steps": [],
        "all_finite": None,
        "increases_at_every_step": None,
        "decreases_at_any_step": None,
        "final_step_pct_change": None,
        "final_step_gain_at_least_threshold": None,
        "band": "UNCLASSIFIED",
    }
    vals = []
    all_finite = True
    for v in values:
        try:
            f = float(v)
        except (TypeError, ValueError):
            f = float("nan")
        if not math.isfinite(f):
            all_finite = False
        vals.append(f)
    out["values"] = [v if math.isfinite(v) else None for v in vals]
    out["all_finite"] = bool(all_finite)

    increases_all = True
    decreases_any = False
    flat_any = False
    for k in range(len(vals) - 1):
        a, b = vals[k], vals[k + 1]
        pct = _safe_div(100.0 * (b - a), a)
        if math.isfinite(a) and math.isfinite(b):
            if b > a:
                direction = "increase"
            elif b < a:
                direction = "decrease"
                decreases_any = True
                increases_all = False
            else:
                direction = "flat"
                flat_any = True
                increases_all = False
        else:
            direction = "non-finite"
            increases_all = False
        out["steps"].append({
            "step": f"{names[k]} -> {names[k + 1]}",
            "from": vals[k] if math.isfinite(vals[k]) else None,
            "to": vals[k + 1] if math.isfinite(vals[k + 1]) else None,
            "absolute_change": (vals[k + 1] - vals[k]
                                if math.isfinite(vals[k])
                                and math.isfinite(vals[k + 1]) else None),
            "pct_change": pct if math.isfinite(pct) else None,
            "direction": direction,
        })

    out["increases_at_every_step"] = bool(increases_all)
    out["decreases_at_any_step"] = bool(decreases_any)
    if out["steps"]:
        fp = out["steps"][-1]["pct_change"]
        out["final_step_pct_change"] = fp
        if fp is not None:
            out["final_step_gain_at_least_threshold"] = bool(
                fp >= 100.0 * min_gain_frac)

    if decreases_any:
        out["band"] = "FALLS"
    elif increases_all and not flat_any and all_finite:
        if out["final_step_gain_at_least_threshold"]:
            out["band"] = "GROWS"
        else:
            out["band"] = "SATURATES"
    else:
        out["band"] = "UNCLASSIFIED"
    return out


def detect_onset(verdicts, names):
    """
    Mechanical, separate from the scaling band: at which generator set the
    per-set verdict FIRST becomes DETECT, and whether it STAYS DETECT for every
    set thereafter.
    """
    first_i = None
    for i, v in enumerate(verdicts):
        if v == "DETECT":
            first_i = i
            break
    stays = None
    if first_i is not None:
        stays = all(v == "DETECT" for v in verdicts[first_i:])
    return {
        "statement": ("the generator set at which the per-set verdict first "
                      "becomes DETECT, and whether every later set is also "
                      "DETECT"),
        "verdicts": list(verdicts),
        "first_detect_set": names[first_i] if first_i is not None else None,
        "first_detect_index": first_i,
        "first_detect_n_generators": (first_i + 1) if first_i is not None
                                     else None,
        "stays_detect_thereafter": stays,
    }


def gate_b_check(pts, counts, cache_path):
    """
    GATE B. Compare G1's counts against N(r) = pi(2^r) - pi(2^(r-1)) from
    pi2n_cache.json (READ ONLY) for every block whose two endpoints are
    consecutive powers of two. When x0 is not a power of two no endpoint lands
    on a power of two, and the gate is recorded as "not applicable". The cache
    is READ; nothing is hardcoded.
    """
    out = {"statement": ("G1's c_j == N(r) = pi(2^r) - pi(2^(r-1)) from "
                         "pi2n_cache.json, for every r where x0 * 2^m lands on "
                         "a power of two"),
           "cache_path": cache_path, "note": None, "n_compared": 0,
           "r_range": None, "mismatches": 0, "mismatch_detail": [],
           "passed": None}

    x0v = float(pts[0])
    l0 = math.log2(x0v)
    if abs(l0 - round(l0)) > 1e-9:
        out["note"] = (f"not applicable: x0 = {x0v:g} is not a power of two, so "
                       "no G1 ladder point lands on a power of two and there is "
                       "nothing in pi2n_cache.json to compare against. Run with "
                       "--x0 2 to exercise this gate")
        return out

    try:
        with open(cache_path, "r") as fh:
            cache = {int(k): int(v) for k, v in json.load(fh).items()}
    except Exception as exc:
        out["note"] = f"cache not readable: {exc}"
        return out
    out["cache_entries"] = len(cache)
    out["cache_n_range"] = [min(cache), max(cache)] if cache else None

    passed = True
    rs = []
    for j in range(len(counts)):
        a = math.log2(pts[j])
        b = math.log2(pts[j + 1])
        ai, bi = int(round(a)), int(round(b))
        if abs(a - ai) > 1e-9 or abs(b - bi) > 1e-9 or bi != ai + 1:
            continue
        if ai not in cache or bi not in cache:
            continue
        expected = cache[bi] - cache[ai]
        out["n_compared"] += 1
        rs.append(bi)
        if counts[j] != expected:
            passed = False
            out["mismatch_detail"].append({
                "j": j, "r": bi, "x_j": pts[j], "x_j1": pts[j + 1],
                "c_j": counts[j], "N_r_from_cache": expected,
                "difference": counts[j] - expected})
    out["mismatches"] = len(out["mismatch_detail"])
    if rs:
        out["r_range"] = [min(rs), max(rs)]
    if out["n_compared"] == 0:
        out["note"] = ("x0 is a power of two but no block endpoints are "
                       "consecutive powers of two present in the cache; "
                       "nothing compared")
        return out
    out["note"] = (f"compared {out['n_compared']} r values against "
                   f"{os.path.basename(cache_path)}")
    out["passed"] = bool(passed)
    return out


def parse_generators(s):
    """
    Parse --generators "2,3,5,7" into a tuple of ints, preserving order and
    rejecting anything that is not an integer >= 2 or that repeats.
    """
    parts = [p.strip() for p in str(s).split(",") if p.strip()]
    if not parts:
        raise SystemExit("--generators must name at least one generator")
    gens = []
    for p in parts:
        try:
            g = int(p)
        except ValueError:
            raise SystemExit(f"--generators: '{p}' is not an integer")
        if g < 2:
            raise SystemExit(f"--generators: {g} must be >= 2")
        if g in gens:
            raise SystemExit(f"--generators: {g} repeats; the family is built "
                             "from successive prefixes and a repeat would not "
                             "densify the orbit")
        gens.append(g)
    return tuple(gens)


def main():
    ap = argparse.ArgumentParser(
        description="O24 — prime-generator orbit: how does detection scale "
                    "with the number of prime generators, and does it "
                    "saturate?")
    ap.add_argument("--x0", type=float, default=2.0,
                    help="first ladder point x_0 (default 2); --x0 2 makes G1 "
                         "the dyadic ladder and arms gate B")
    ap.add_argument("--xmax", type=int, default=150000000,
                    help="sieve limit / top of every value ladder "
                         "(default 150000000)")
    ap.add_argument("--generators", type=str, default="2,3,5,7",
                    help="comma-separated generator list (default '2,3,5,7'); "
                         "the nested family is built from its successive "
                         "prefixes: G1 = first, G2 = first two, and so on")
    ap.add_argument("--gamma-max", type=float, default=40.0,
                    help="upper end of the gamma projection grid (default 40)")
    ap.add_argument("--gamma-step", type=float, default=0.01,
                    help="gamma projection grid step (default 0.01)")
    ap.add_argument("--dps", type=int, default=30,
                    help="mpmath decimal precision for R (default 30; the "
                         "script refuses to run below 30)")
    ap.add_argument("--surrogates", type=int, default=200,
                    help="surrogates per generator set (default 200)")
    ap.add_argument("--seed", type=int, default=2026,
                    help="fixed seed for the surrogate permutations "
                         "(default 2026)")
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE,
                    help="path to pi(2^n) cache JSON, read by gate B "
                         "(READ ONLY; default: pi2n_cache.json at the root)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    ap.add_argument("--pi-backend", type=str, default="sieve",
                    choices=("sieve", "primecount"),
                    help="exact prime counting backend (default sieve). "
                         "sieve needs ~xmax bytes of RAM and enumerates the "
                         "primes; primecount uses primecountpy with no "
                         "array and reaches xmax far beyond RAM. Both are "
                         "exact with identical floor semantics; results are "
                         "backend-independent (verified 2026-08-25).")
    args = ap.parse_args()

    dps = int(args.dps)
    if dps < 30:
        raise SystemExit(f"--dps {dps} is below the required minimum of 30; "
                         "the R difference is a cancellation and needs the "
                         "precision. Refusing to run.")
    x0 = float(args.x0)
    xmax = int(args.xmax)
    if x0 < 2.0:
        raise SystemExit(f"--x0 {x0} must be >= 2.")
    if float(x0) * 2.0 > float(xmax):
        raise SystemExit("--xmax must be at least 2 * --x0 for any ladder to "
                         "have a block.")
    n_surr = int(args.surrogates)
    seed = int(args.seed)
    gens_all = parse_generators(args.generators)

    # The NESTED family: successive prefixes of the generator list.
    set_names = tuple(f"G{k}" for k in range(1, len(gens_all) + 1))
    set_gens = {set_names[k]: gens_all[:k + 1] for k in range(len(gens_all))}

    print("=" * 78, flush=True)
    print("O24 — prime-generator orbit  (fit-free; exact counts; projection, "
          "not fit)", flush=True)
    print("=" * 78, flush=True)
    print("  O18 showed the integer bases are blind to the zeros SINGLY but "
          "not JOINTLY: at", flush=True)
    print("  x0 = 2 the pure dyadic and pure triadic ladders returned NULL, "
          "while the joint", flush=True)
    print("  orbit {2^m 3^n} detected gamma_2 at P/median 6.95 and "
          "{2^m 3^n 5^k} detected", flush=True)
    print("  gamma_4 at 16.37. Only PRIME bases add generators: 4, 8 and 9 lie "
          "inside the", flush=True)
    print("  semigroup 2 and 3 already generate, so they do not densify the "
          "orbit. This script", flush=True)
    print("  makes the generator set a PARAMETER and sweeps the NESTED family "
          "on identical", flush=True)
    print("  settings, to measure how detection scales with the number of "
          "prime generators and", flush=True)
    print("  whether it saturates. Interpretation of the numbers below is NOT "
          "this script's job.", flush=True)
    print("", flush=True)
    print(f"  x0 = {x0:g}   xmax = {xmax}   dps = {dps}   "
          f"surrogates = {n_surr}   seed = {seed}", flush=True)
    print(f"  generators = {args.generators}   nested family:", flush=True)
    for nm in set_names:
        print(f"    {nm} = {{" + ", ".join(str(g) for g in set_gens[nm])
              + "}", flush=True)
    print(f"  pi/log2 = {math.pi / math.log(2.0):.6f}     "
          f"pi/log3 = {math.pi / math.log(3.0):.6f}", flush=True)

    # ---------------- pi backend -------------------------------------------
    if args.pi_backend == "primecount":
        print(f"\n  pi backend: primecountpy (no sieve; exact, memoized)...",
              flush=True)
        primes = PrimecountPi()
        n_primes = primes(xmax)
        largest_prime = None
        print(f"  {n_primes} primes <= xmax (largest not enumerated under "
              f"this backend)", flush=True)
    else:
        print(f"\n  sieving primes to {xmax}...", flush=True)
        primes = sieve_primes(xmax)
        n_primes = int(primes.size)
        largest_prime = int(primes[-1]) if n_primes else None
        print(f"  {n_primes} primes, largest = {largest_prime}", flush=True)

    # ---------------- ladders ----------------------------------------------
    print("\n  building ladders (multipliers as EXACT Python integers; sort "
          "and dedup exact)...", flush=True)
    ladders = {}
    for nm in set_names:
        g = set_gens[nm]
        mults = smooth_multipliers(g, x0, xmax)
        desc = ("x = x0 * " + " * ".join(f"{b}^e{i + 1}"
                                         for i, b in enumerate(g))
                + ", all exponents >= 0, x <= xmax"
                + ("  (single generator; uniform log-gap = log "
                   f"{g[0]})" if len(g) == 1 else "  (irregular)"))
        ladders[nm] = (ladder_from_multipliers(x0, mults), desc)

    # Nesting check, recorded: each ladder must be a SUPERSET of the previous.
    nesting = []
    for k in range(len(set_names) - 1):
        a = set(ladders[set_names[k]][0])
        b = set(ladders[set_names[k + 1]][0])
        nesting.append({
            "pair": f"{set_names[k]} subset {set_names[k + 1]}",
            "n_a": len(a), "n_b": len(b),
            "is_subset": bool(a.issubset(b)),
            "n_added": len(b) - len(a),
        })

    print(f"\n  {'set':>5} {'generators':>16} {'rungs':>7} {'first x':>16} "
          f"{'last x':>16} {'gap min':>11} {'gap med':>11} {'gap max':>11} "
          f"{'pi/gap_med':>12}", flush=True)
    for nm in set_names:
        pts, _ = ladders[nm]
        g = gap_stats(pts)
        gl = ",".join(str(v) for v in set_gens[nm])
        print(f"  {nm:>5} {gl:>16} {len(pts):>7} {_fmtg(pts[0], 16, 10)} "
              f"{_fmtg(pts[-1], 16, 10)} "
              f"{_fmt(g['min'], 11, 7)} {_fmt(g['median'], 11, 7)} "
              f"{_fmt(g['max'], 11, 7)} "
              f"{_fmt(_safe_div(math.pi, g['median']), 12, 6)}", flush=True)
    print(f"\n  reference: log 2 = {math.log(2.0):.7f}   "
          f"log 3 = {math.log(3.0):.7f}   log 5 = {math.log(5.0):.7f}   "
          f"log 7 = {math.log(7.0):.7f}", flush=True)
    print("  For a SINGLE generator the log-gaps are CONSTANT, so pi/gap IS "
          "the uniform Nyquist", flush=True)
    print("  limit. For every multi-generator set the gaps are IRREGULAR and "
          "pi/median_gap is a", flush=True)
    print("  DESCRIPTIVE NUMBER ONLY, NOT A BOUND.", flush=True)

    print(f"\n  NESTING CHECK (each ladder must be a superset of the previous)",
          flush=True)
    for nz in nesting:
        print(f"    {nz['pair']:>16} : {str(nz['is_subset']):>5}   "
              f"{nz['n_a']} -> {nz['n_b']} rungs (+{nz['n_added']})",
              flush=True)

    # ---------------- pipeline per generator set ---------------------------
    gammas = np.arange(0.0, args.gamma_max + 0.5 * args.gamma_step,
                       args.gamma_step, dtype=np.float64)
    n_gamma = int(gammas.size)
    g1_index = int(np.argmin(np.abs(gammas - GAMMA_1)))

    rcache = RCache(dps)
    results = {}
    for nm in set_names:
        pts, desc = ladders[nm]
        print(f"\n  running pipeline on {nm} = {{"
              + ",".join(str(v) for v in set_gens[nm])
              + f"}} ({len(pts)} rungs, {len(pts) - 1} blocks); computing R at "
              f"mp.dps = {dps} ({RIEMANNR_IMPL}) ...", flush=True)
        rr = run_ladder(nm, set_gens[nm], pts, primes, rcache, gammas,
                        g1_index, n_surr, seed, desc)
        results[nm] = rr
        pr = rr["projection"]
        print(f"  {nm}: total primes counted = {rr['total_count']}, block size "
              f"{rr['block_size_min']}..{rr['block_size_max']}", flush=True)
        print(f"  {nm}: resolution = {rr['frequency_resolution']:.6f}, band hw "
              f"= {rr['band_halfwidth_used']:.6f}, median(P) = "
              f"{pr['P_median']:.8g}", flush=True)
        print(f"  {nm}: argmax gamma = {pr['argmax_gamma']:.4f} (nearest "
              f"gamma_n = {pr['argmax_nearest_gamma']:.6f}, dist "
              f"{pr['argmax_distance_to_nearest']:.4f}), P_max/median = "
              f"{pr['P_max_over_median']:.6f}", flush=True)
        print(f"  {nm}: P/median at the six gamma_n = "
              + ", ".join(f"{v:.5f}"
                          for v in pr["P_at_gamma_over_median"]), flush=True)
        s = rr["surrogate_null"]["P_max_over_median"]
        d = s["surrogate_distribution"]
        print(f"  {nm}: surrogate P_max/median min {d['min']:.6f} med "
              f"{d['median']:.6f} p95 {d['p95']:.6f} max {d['max']:.6f}; real "
              f"{s['real_value']:.6f} at pct "
              f"{s['real_percentile_in_surrogates']:.3f}, > p95 "
              f"{s['real_exceeds_surrogate_p95']}", flush=True)
        print(f"  {nm}: gate A "
              f"{'PASSED' if rr['gate_a']['passed'] else 'FAILED'}   "
              f"VERDICT {rr['verdict']}", flush=True)
    print(f"\n  distinct R(x) evaluations : {rcache.n_computed}", flush=True)

    # ---------------- ladder table -----------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("LADDERS — rung count, endpoints, log-gap spread", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'set':>5} {'gens':>12} {'rungs':>7} {'blocks':>7} "
          f"{'first x':>14} {'last x':>16} {'gap min':>11} {'gap med':>11} "
          f"{'gap max':>11}", flush=True)
    for nm in set_names:
        rr = results[nm]
        g = rr["log_gap_stats"]
        gl = ",".join(str(v) for v in set_gens[nm])
        print(f"  {nm:>5} {gl:>12} {rr['n_rungs']:>7} {rr['n_blocks']:>7} "
              f"{_fmtg(rr['x_first'], 14, 8)} {_fmtg(rr['x_last'], 16, 10)} "
              f"{_fmt(g['min'], 11, 7)} {_fmt(g['median'], 11, 7)} "
              f"{_fmt(g['max'], 11, 7)}", flush=True)

    # ---------------- projection summary -----------------------------------
    print("\n" + "-" * 78, flush=True)
    print("PROJECTION  P(gamma) = |sum_j w_j ehat_j exp(-i gamma log x_j)|  "
          "(NON-UNIFORM DFT,", flush=True)
    print("            a direct sum valid for arbitrary x_j; an inner product, "
          "NOT a fit)", flush=True)
    print("-" * 78, flush=True)
    print(f"  gamma grid : 0 to {args.gamma_max:g} step {args.gamma_step:g}  "
          f"({n_gamma} points)   window: hann", flush=True)
    print(f"  band half-width per set = max({BAND_HALFWIDTH_FLOOR:g}, that "
          f"set's frequency resolution)", flush=True)
    print(f"  threshold : P > {BAND_MEDIAN_FACTOR:g} x median(P)", flush=True)
    print(f"\n  {'set':>5} {'n_blk':>7} {'log-x span':>12} {'2pi/span':>11} "
          f"{'band hw':>10} {'median(P)':>14} {'argmax g':>10} "
          f"{'P_max/med':>12} {'verdict':>9}", flush=True)
    for nm in set_names:
        rr = results[nm]
        pr = rr["projection"]
        print(f"  {nm:>5} {rr['n_blocks']:>7} "
              f"{_fmt(rr['projection_log_x_span'], 12, 6)} "
              f"{_fmt(rr['frequency_resolution'], 11, 6)} "
              f"{_fmt(rr['band_halfwidth_used'], 10, 6)} "
              f"{_fmtg(pr['P_median'], 14, 8)} "
              f"{_fmt(pr['argmax_gamma'], 10, 4)} "
              f"{_fmt(pr['P_max_over_median'], 12, 6)} "
              f"{rr['verdict']:>9}", flush=True)

    print(f"\n  P/median AT THE SIX gamma_n", flush=True)
    print(f"  {'set':>5} " + " ".join(f"{'g' + str(i + 1):>11}"
                                      for i in range(len(GAMMAS))), flush=True)
    for nm in set_names:
        vals = results[nm]["projection"]["P_at_gamma_over_median"]
        print(f"  {nm:>5} " + " ".join(_fmt(v, 11, 5) for v in vals),
              flush=True)
    print(f"\n  gamma_n = " + ", ".join(format(g, ".6f") for g in GAMMAS),
          flush=True)

    for nm in set_names:
        rr = results[nm]
        print(f"\n  TEN LARGEST LOCAL PEAKS — {nm}  (strict interior maxima; "
              f"band hw {rr['band_halfwidth_used']:.6f})", flush=True)
        print(f"  {'rank':>5} {'gamma':>12} {'P':>18} {'P/median':>14} "
              f"{'nearest gamma_n':>17} {'dist':>10} {'in band':>9}",
              flush=True)
        pk_list = rr["projection"]["top_local_peaks"]
        for i, pk in enumerate(pk_list, start=1):
            print(f"  {i:>5} {_fmt(pk['gamma'], 12, 4)} "
                  f"{_fmtg(pk['P'], 18, 10)} "
                  f"{_fmt(pk['P_over_median'], 14, 6)} "
                  f"{_fmt(pk['nearest_gamma'], 17, 6)} "
                  f"{_fmt(pk['distance_to_nearest'], 10, 4)} "
                  f"{('yes' if pk['in_band'] else 'no'):>9}", flush=True)
        if not pk_list:
            print("    (none)", flush=True)

    # ---------------- surrogate control -------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("SURROGATE CONTROL (amplitude-preserving permutation of ehat across "
          "j)", flush=True)
    print("-" * 78, flush=True)
    print(f"  {n_surr} surrogates per generator set, numpy "
          f"default_rng(seed={seed}), identical projection.", flush=True)
    print("  THIS IS THE CONTROL THAT MATTERS: combining irregular samples can "
          "manufacture peaks.", flush=True)
    print("  If the real value is not beyond the surrogate 95th percentile the "
          "detection is not", flush=True)
    print("  established.", flush=True)
    print(f"\n  SURROGATE P_max/median", flush=True)
    print(f"  {'set':>5} {'surr min':>12} {'surr med':>12} {'surr p95':>12} "
          f"{'surr max':>12} {'REAL':>12} {'real pct':>10} {'> p95':>7}",
          flush=True)
    for nm in set_names:
        s = results[nm]["surrogate_null"]["P_max_over_median"]
        d = s["surrogate_distribution"]
        print(f"  {nm:>5} {_fmt(d['min'], 12, 6)} {_fmt(d['median'], 12, 6)} "
              f"{_fmt(d['p95'], 12, 6)} {_fmt(d['max'], 12, 6)} "
              f"{_fmt(s['real_value'], 12, 6)} "
              f"{_fmt(s['real_percentile_in_surrogates'], 10, 3)} "
              f"{str(s['real_exceeds_surrogate_p95']):>7}", flush=True)

    print(f"\n  SURROGATE P/median AT gamma_1 = {GAMMA_1}", flush=True)
    print(f"  {'set':>5} {'surr min':>12} {'surr med':>12} {'surr p95':>12} "
          f"{'surr max':>12} {'REAL':>12} {'real pct':>10} {'> p95':>7}",
          flush=True)
    for nm in set_names:
        s = results[nm]["surrogate_null"]["P_at_gamma_1_over_median"]
        d = s["surrogate_distribution"]
        print(f"  {nm:>5} {_fmt(d['min'], 12, 6)} {_fmt(d['median'], 12, 6)} "
              f"{_fmt(d['p95'], 12, 6)} {_fmt(d['max'], 12, 6)} "
              f"{_fmt(s['real_value'], 12, 6)} "
              f"{_fmt(s['real_percentile_in_surrogates'], 10, 3)} "
              f"{str(s['real_exceeds_surrogate_p95']):>7}", flush=True)

    # ---------------- GATES -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — EXACT TILING, per generator set: sum_j c_j == "
          "pi(x_last) - pi(x_0)", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'set':>5} {'pi(x_0)':>12} {'pi(x_last)':>12} "
          f"{'expected':>12} {'sum c_j':>12} {'diff':>8} {'gate A':>9}",
          flush=True)
    gate_a_all = True
    for nm in set_names:
        ga = results[nm]["gate_a"]
        gate_a_all = gate_a_all and bool(ga["passed"])
        print(f"  {nm:>5} {ga['pi_x0']:>12} {ga['pi_x_last']:>12} "
              f"{ga['expected']:>12} {ga['sum_c_j']:>12} "
              f"{ga['difference']:>8} "
              f"{('PASSED' if ga['passed'] else 'FAILED'):>9}", flush=True)
    print(f"  GATE A overall: {'PASSED' if gate_a_all else 'FAILED'}",
          flush=True)

    print("\n" + "-" * 78, flush=True)
    print("GATE B — TIES TO THE TABLE: G1's c_j vs N(r) = pi(2^r) - pi(2^(r-1))",
          flush=True)
    print("         from pi2n_cache.json (READ ONLY; read, not hardcoded)",
          flush=True)
    print("-" * 78, flush=True)
    gate_b = gate_b_check(ladders[set_names[0]][0],
                          results[set_names[0]]["_counts"], args.cache)
    print(f"  source : {args.cache}   (READ ONLY)", flush=True)
    print(f"  G1 generators : {list(set_gens[set_names[0]])}", flush=True)
    if gate_b.get("cache_entries") is not None:
        print(f"  cache entries : {gate_b['cache_entries']}  n range "
              f"{gate_b['cache_n_range'][0]}..{gate_b['cache_n_range'][1]}",
              flush=True)
    if gate_b["note"]:
        print(f"  {gate_b['note']}", flush=True)
    print(f"  cells compared : {gate_b['n_compared']}"
          + (f"   (r = {gate_b['r_range'][0]}..{gate_b['r_range'][1]})"
             if gate_b["r_range"] else ""), flush=True)
    print(f"  mismatches     : {gate_b['mismatches']}", flush=True)
    for m in gate_b["mismatch_detail"][:20]:
        print(f"    j={m['j']} r={m['r']} c_j={m['c_j']} "
              f"N(r)={m['N_r_from_cache']} diff={m['difference']}", flush=True)
    print(f"  GATE B: "
          f"{'PASSED' if gate_b['passed'] else ('NOT APPLICABLE / NOT RUN' if gate_b['passed'] is None else 'FAILED')}",
          flush=True)

    print("\n" + "-" * 78, flush=True)
    print("GATE C — SANITY ON R: R(10^6) vs pi(10^6) = 78498, against "
          "|li(10^6) - 78498| = 129.549", flush=True)
    print("-" * 78, flush=True)
    old_dps = mp.dps
    try:
        mp.dps = dps
        R_1e6 = float(riemannr_at(GATE_C_X))
    finally:
        mp.dps = old_dps
    if xmax >= GATE_C_X:
        pi_1e6 = pi_at(primes, GATE_C_X)
        pi_1e6_note = "from this run's sieve"
    else:
        pi_1e6 = None
        pi_1e6_note = f"not available: --xmax {xmax} < {GATE_C_X}"
    gate_c_R_abs = abs(R_1e6 - GATE_C_PI_KNOWN)
    gate_c_passed = bool(gate_c_R_abs < GATE_C_LI_ABS_KNOWN)
    gate_c = {
        "statement": ("R(10^6) against pi(10^6) = 78498; criterion "
                      "|R(10^6) - 78498| < |li(10^6) - 78498| = 129.549"),
        "x": GATE_C_X,
        "riemannr_impl": RIEMANNR_IMPL,
        "R_computed": R_1e6,
        "pi_from_sieve": pi_1e6,
        "pi_known": GATE_C_PI_KNOWN,
        "pi_from_sieve_matches_known": (None if pi_1e6 is None
                                        else bool(pi_1e6 == GATE_C_PI_KNOWN)),
        "pi_note": pi_1e6_note,
        "R_abs_difference": gate_c_R_abs,
        "li_reference": GATE_C_LI_KNOWN,
        "li_abs_difference_known": GATE_C_LI_ABS_KNOWN,
        "passed": gate_c_passed,
    }
    print(f"  R implementation      : {RIEMANNR_IMPL}", flush=True)
    print(f"  R(10^6) at dps {dps}    : {R_1e6:.6f}", flush=True)
    print(f"  pi(10^6) from sieve   : {pi_1e6}   ({pi_1e6_note})", flush=True)
    print(f"  pi(10^6) known        : {GATE_C_PI_KNOWN}", flush=True)
    print(f"  |R(10^6) - 78498|     : {gate_c_R_abs:.6f}", flush=True)
    print(f"  |li(10^6) - 78498|    : {GATE_C_LI_ABS_KNOWN}   "
          f"(li(10^6) = {GATE_C_LI_KNOWN})", flush=True)
    print(f"  GATE C: {'PASSED' if gate_c_passed else 'FAILED'}", flush=True)

    # ---------------- pre-registered scaling band ---------------------------
    pmax_chain = [results[nm]["projection"]["P_max_over_median"]
                  for nm in set_names]
    scaling = classify_scaling(pmax_chain, set_names,
                               SCALING_FINAL_STEP_MIN_GAIN_FRAC)
    verdict_chain = [results[nm]["verdict"] for nm in set_names]
    onset = detect_onset(verdict_chain, set_names)

    print("\n" + "-" * 78, flush=True)
    print("PRE-REGISTERED SCALING BAND on P_max/median across the nested chain",
          flush=True)
    print("-" * 78, flush=True)
    print("  GROWS     : increases at every step, AND the final step gains "
          ">= 10%", flush=True)
    print("  SATURATES : increases at every step, BUT the final step gains "
          "< 10%", flush=True)
    print("  FALLS     : decreases at any step", flush=True)
    print("  precedence: FALLS > GROWS > SATURATES > UNCLASSIFIED",
          flush=True)
    print(f"\n  {'set':>5} {'generators':>16} {'P_max/median':>16}",
          flush=True)
    for nm, v in zip(set_names, pmax_chain):
        gl = ",".join(str(g) for g in set_gens[nm])
        print(f"  {nm:>5} {gl:>16} {_fmt(v, 16, 6)}", flush=True)
    print(f"\n  {'step':>16} {'from':>14} {'to':>14} {'abs change':>14} "
          f"{'pct change':>13} {'direction':>11}", flush=True)
    for st in scaling["steps"]:
        print(f"  {st['step']:>16} {_fmt(st['from'], 14, 6)} "
              f"{_fmt(st['to'], 14, 6)} "
              f"{_fmt(st['absolute_change'], 14, 6)} "
              f"{_fmt(st['pct_change'], 13, 4)} "
              f"{st['direction']:>11}", flush=True)
    print(f"\n  increases at every step  : "
          f"{scaling['increases_at_every_step']}", flush=True)
    print(f"  decreases at any step    : {scaling['decreases_at_any_step']}",
          flush=True)
    print(f"  final step pct change    : "
          f"{_fmt(scaling['final_step_pct_change'], 0, 4)}%", flush=True)
    print(f"  final step gain >= 10%   : "
          f"{scaling['final_step_gain_at_least_threshold']}", flush=True)
    print(f"\n  SCALING BAND: {scaling['band']}", flush=True)

    print("\n" + "-" * 78, flush=True)
    print("DETECT ONSET — mechanical, reported separately from the scaling band",
          flush=True)
    print("-" * 78, flush=True)
    for nm in set_names:
        print(f"  {nm:>5} : {results[nm]['verdict']}", flush=True)
    print(f"\n  first DETECT at          : {onset['first_detect_set']}"
          + (f"  ({onset['first_detect_n_generators']} generators)"
             if onset["first_detect_n_generators"] else ""), flush=True)
    print(f"  stays DETECT thereafter  : {onset['stays_detect_thereafter']}",
          flush=True)

    # ---------------- read the result ---------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  c_j are EXACT INTEGER prime counts by binary search; no float "
          "approximation to", flush=True)
    print(f"  pi(x) is used anywhere. L_j is an mpmath R difference at dps "
          f"{dps}, cast to float", flush=True)
    print("  only after the cancellation. The projection is float64 and is a "
          "NON-UNIFORM DFT.", flush=True)
    print("  P(gamma) is an INNER PRODUCT, not a fit. The bands were fixed "
          "before the run.", flush=True)
    print(f"  gate A (exact tiling, all sets)     : "
          f"{'PASSED' if gate_a_all else 'FAILED'}", flush=True)
    print(f"  gate B (ties to table, G1)          : "
          f"{'PASSED' if gate_b['passed'] else ('NOT APPLICABLE / NOT RUN' if gate_b['passed'] is None else 'FAILED')}",
          flush=True)
    print(f"  gate C (R sanity)                   : "
          f"{'PASSED' if gate_c_passed else 'FAILED'}", flush=True)
    print("  verdicts : " + " / ".join(f"{nm} {results[nm]['verdict']}"
                                       for nm in set_names), flush=True)
    print("  P_max/median : " + " / ".join(
        f"{nm} {_fmt(v, 0, 6)}" for nm, v in zip(set_names, pmax_chain)),
        flush=True)
    print(f"  scaling band : {scaling['band']}", flush=True)
    print(f"  first DETECT : {onset['first_detect_set']}   stays DETECT : "
          f"{onset['stays_detect_thereafter']}", flush=True)
    print("  Interpretation of these numbers is NOT this script's job.",
          flush=True)

    # ---------------- payload -----------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT

        rows = []
        for nm in set_names:
            rr = results[nm]
            gl = [int(g) for g in set_gens[nm]]
            for j in range(rr["n_blocks"]):
                rows.append({
                    "generator_set": nm,
                    "generators": gl,
                    "j": j,
                    "x_j": float(rr["_xj"][j]),
                    "x_j_plus_1": float(rr["_xj1"][j]),
                    "c_j": int(rr["_counts"][j]),
                    "L_j": float(rr["_Lj"][j]),
                    "e_j": float(rr["_ej"][j]),
                    "ehat_j": float(rr["_ehat"][j]),
                })

        set_summaries = {}
        for nm in set_names:
            rr = dict(results[nm])
            for k in ("_counts", "_xj", "_xj1", "_Lj", "_ej", "_ehat"):
                rr.pop(k, None)
            sn = dict(rr["surrogate_null"])
            sn.pop("_max_ratios", None)
            sn.pop("_g1_ratios", None)
            rr["surrogate_null"] = sn
            set_summaries[nm] = rr

        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "x0": x0,
                "xmax": xmax,
                "generators_arg": args.generators,
                "generators": [int(g) for g in gens_all],
                "generator_sets": {nm: [int(g) for g in set_gens[nm]]
                                   for nm in set_names},
                "set_names": list(set_names),
                "gamma_max": args.gamma_max,
                "gamma_step": args.gamma_step,
                "n_gamma": n_gamma,
                "dps": dps,
                "surrogates": n_surr,
                "seed": seed,
                "riemannr_impl": RIEMANNR_IMPL,
                "cache_path": args.cache,
                "pi_backend": args.pi_backend,
                "n_primes": n_primes,
                "largest_prime": largest_prime,
                "band_halfwidth_floor": BAND_HALFWIDTH_FLOOR,
                "band_median_factor": BAND_MEDIAN_FACTOR,
                "scaling_final_step_min_gain_frac":
                    SCALING_FINAL_STEP_MIN_GAIN_FRAC,
                "window": "hann",
                "distinct_riemannr_evaluations": rcache.n_computed,
                "family_definition":
                    "the NESTED family is built from --generators by taking "
                    "successive prefixes: G1 = {g1}, G2 = {g1,g2}, G3 = "
                    "{g1,g2,g3}, G4 = {g1,g2,g3,g4}. Each set is a superset of "
                    "the previous one, so the only thing that changes from "
                    "step to step is that one more generator is adjoined and "
                    "the orbit densifies",
                "ladder_definition":
                    "x = x0 * (product of the set's generators with "
                    "non-negative exponents), x <= xmax, sorted ascending and "
                    "deduplicated exactly (multipliers built as exact Python "
                    "integers)",
                "block_definition":
                    "disjoint half-open intervals (x_j, x_{j+1}] tiling "
                    "(x_0, x_last]; every prime used exactly once",
                "count_definition":
                    "c_j = pi(x_{j+1}) - pi(x_j), exact integer via "
                    "np.searchsorted(primes, x, side='right')",
                "smooth_definition":
                    "L_j = R(x_{j+1}) - R(x_j), R = Riemann's function "
                    "sum_n mu(n)/n li(x^(1/n)), differenced in mpf at the "
                    "recorded dps and cast to float afterwards",
                "residual_definition": "e_j = c_j - L_j",
                "normalisation": "ehat_j = e_j / sqrt(x_j)",
                "projection_definition":
                    "P(gamma) = |sum_j w_j * ehat_j * exp(-i gamma log x_j)|, "
                    "w = hann; a NON-UNIFORM DFT (direct sum) valid for "
                    "arbitrary x_j; an inner product, not a fit",
                "surrogate_definition":
                    "ehat replaced by a random permutation of its own values "
                    "across j — the amplitude distribution is preserved "
                    "exactly — projected identically, at the fixed seed",
                "fit_free": True,
                "precision":
                    "mixed: EXACT integer prime counts (numpy int64 array + "
                    f"binary search); mpmath riemannr at mp.dps = {dps} with "
                    "the difference taken in mpf; float64 residual, projection "
                    "and surrogates; ladder multipliers exact Python integers",
            },
            "constants": {
                "gamma_1": GAMMA_1,
                "gamma_2": GAMMA_2,
                "gamma_3": GAMMA_3,
                "gamma_4": GAMMA_4,
                "gamma_5": GAMMA_5,
                "gamma_6": GAMMA_6,
                "gammas": list(GAMMAS),
                "pi_over_log2": math.pi / math.log(2.0),
                "pi_over_log3": math.pi / math.log(3.0),
                "log2": math.log(2.0),
                "log3": math.log(3.0),
                "log5": math.log(5.0),
                "log7": math.log(7.0),
                "o10_note": (
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script"),
                "prime_generator_note": (
                    "only PRIME bases add generators: 4, 8 and 9 lie inside "
                    "the multiplicative semigroup that 2 and 3 already "
                    "generate, so adjoining them does not densify the orbit. "
                    "The distinct generators available from a "
                    "triadic-through-enneadic family are 2, 3, 5, 7"),
                "o18_reference": (
                    "O18 at x0 = 2: pure dyadic NULL, pure triadic NULL, "
                    "{2^m 3^n} DETECT at gamma_2 with P/median 6.95, "
                    "{2^m 3^n 5^k} DETECT at gamma_4 with P/median 16.37"),
                "nyquist_note": (
                    "a geometric ladder of ratio r samples log x at spacing "
                    "log(r), so the uniform projection Nyquist is pi/log(r): "
                    "4.5324 for base 2 and 2.8595 for base 3, both below "
                    "gamma_1 = 14.134725. The uniform-equivalent Nyquist "
                    "pi/median_gap reported for the MULTI-GENERATOR sets is a "
                    "DESCRIPTIVE NUMBER ONLY and NOT A BOUND, because "
                    "irregular sampling is not limited by the uniform rate"),
                "band_rule": (
                    "DETECT: global max of P within the band half-width of one "
                    "of gamma_1..gamma_6 AND > 5x median(P); WEAK: a local "
                    "peak within the band of one of the six > 5x median(P) but "
                    "the global max is elsewhere; NULL: neither"),
                "band_halfwidth_rule": (
                    "per generator set, max(0.6, that set's frequency "
                    "resolution 2*pi/(log x_last - log x_first) over the "
                    "projection's own points); the value used is recorded"),
                "scaling_band_rule": (
                    "on P_max/median across G1 -> G2 -> G3 -> G4: GROWS = "
                    "increases at every step and the final step gains >= 10%; "
                    "SATURATES = increases at every step but the final step "
                    "gains < 10%; FALLS = decreases at any step. Precedence "
                    "FALLS > GROWS > SATURATES > UNCLASSIFIED"),
                "detect_onset_rule": (
                    "reported separately and mechanically: the generator set "
                    "at which the per-set verdict first becomes DETECT, and "
                    "whether every later set is also DETECT"),
                "surrogate_note": (
                    "the surrogate control is the control that matters: "
                    "combining irregular samples can manufacture peaks, and if "
                    "the real value is not beyond the surrogate 95th "
                    "percentile the detection is not established"),
                "gate_c_pi_known": GATE_C_PI_KNOWN,
                "gate_c_li_known": GATE_C_LI_KNOWN,
                "gate_c_li_abs_known": GATE_C_LI_ABS_KNOWN,
            },
            "summary": {
                "generator_sets": set_summaries,
                "verdicts": {nm: results[nm]["verdict"] for nm in set_names},
                "P_max_over_median_chain": {
                    nm: results[nm]["projection"]["P_max_over_median"]
                    for nm in set_names},
                "scaling_band": scaling,
                "detect_onset": onset,
                "nesting_check": nesting,
                "gate_a_all_passed": bool(gate_a_all),
                "gate_b": gate_b,
                "gate_c": gate_c,
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
