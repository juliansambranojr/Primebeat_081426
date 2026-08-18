#!/usr/bin/env python3
"""
O18 — Joint multiplicative ladder: are the integer bases blind to the zeros
      JOINTLY, or only one at a time?

Reads with: O17_disjoint_block_residual.py (this script reuses its machinery
verbatim — sieve_primes, pi_at, hann, project, classify_projection, local_peaks,
_jsonable, _write_results, _safe_div, the formatters); O12-O16; DT-A5; DT-A6;
this bench's `pi2n_cache.json` (READ ONLY).

NAMING
------
The O-series in this tree runs O1-O9, O11, O12, O13, O14, O15, O16, O17. There
is NO O10: that number is a known, DELIBERATE GAP, and this script does not fill
it, because filling a reserved gap with unrelated work would silently rewrite
the series' history. The next free number after O17 is O18; this file takes it.
Capital "O" per `CLAUDE.md` § "Naming convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

O17 showed that a geometric value-ladder of ratio r samples log x at spacing
log(r), so the projection Nyquist is pi/log(r). For integer bases that is

    base 2 :  pi/log 2 = 4.5324
    base 3 :  pi/log 3 = 2.8595

both far below gamma_1 = 14.134725. Each integer base is therefore blind to
EVERY zero, and O17's dyadic control returned NULL while its ratio-1.1 run
returned DETECT.

This script tests whether the bases are blind JOINTLY. The multiplicative
semigroup {2^m * 3^n} is dense in log-space (Furstenberg), and its points are
IRREGULARLY spaced, so a ladder built on it has no uniform Nyquist limit —
irregular sampling is not bound by the uniform-rate bound. The question is
whether the zeros become recoverable from integer bases jointly when neither
base alone can see them. If so, that is the multiplicative independence of 2
and 3 doing measurable work; log2/log3 is irrational, so the two sampling sets
are incommensurable and their aliasing patterns differ.

Everything else follows O17: disjoint value-interval blocks tiling the range,
exact integer counts, Riemann R as the smooth model, residual projected onto
exp(-i gamma log x). This script does NOT interpret the mathematics; it states
numbers and applies pre-registered rules mechanically.

=============================================================================
LADDERS BUILT — four of them, same x range, same everything else
=============================================================================

Given --x0 (default 1000) and --xmax (default 150000000):

    L2    : x = x0 * 2^m              m >= 0,     x <= xmax   (pure dyadic)
    L3    : x = x0 * 3^n              n >= 0,     x <= xmax   (pure triadic)
    L23   : x = x0 * 2^m * 3^n        m,n >= 0,   x <= xmax   (the joint orbit)
    L235  : x = x0 * 2^m * 3^n * 5^k  m,n,k >= 0, x <= xmax   (three generators)

Each is sorted ascending and deduplicated exactly (the multipliers are built as
exact Python integers, so the dedup is exact and not a float tolerance). For
each ladder the rung count, first and last x, and the min / median / max gap in
log x between consecutive rungs are reported. For L2 and L3 those gaps are
constant (log 2, log 3); for L23 and L235 they are irregular and the spread is
reported explicitly.

The uniform-equivalent Nyquist pi/median_gap is reported for every ladder. FOR
THE IRREGULAR LADDERS THIS IS A DESCRIPTIVE NUMBER ONLY, NOT A BOUND, because
irregular sampling is not limited by the uniform rate.

=============================================================================
WHAT IS COMPUTED — identical pipeline per ladder
=============================================================================

1. Sieve to --xmax, numpy boolean, mirroring sieve_primes in O17. Prime count
   and largest prime reported.
2. Blocks are the consecutive intervals of the sorted ladder, (x_j, x_{j+1}].
   Disjoint, tiling.
3. c_j = pi(x_{j+1}) - pi(x_j) by np.searchsorted on the prime array — EXACT
   integer counts. No float approximation to pi(x) anywhere.
4. L_j = R(x_{j+1}) - R(x_j) with R = mpmath.riemannr at --dps (default 30),
   differenced in mpf and cast to float only afterwards. e_j = c_j - L_j.
5. ehat_j = e_j / sqrt(x_j).
6. PROJECTION — a NON-UNIFORM DFT, i.e. a direct sum, valid for arbitrary x_j:

       P(gamma) = | sum_j w_j * ehat_j * exp(-i * gamma * log x_j) |

   w_j a Hann window over j; gamma grid 0 to --gamma-max (default 40) in steps
   of --gamma-step (default 0.01).
7. Reported per ladder: the frequency resolution 2*pi/(log x_last - log x_first)
   over the projection's own points; median(P); the gamma of the global maximum;
   the ten largest local peaks with gamma and P/median; and P(gamma_n)/median
   for the first six zeros
   gamma = 14.134725, 21.022040, 25.010858, 30.424876, 32.935062, 37.586178.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

BAND HALF-WIDTH per ladder = max(0.6, that ladder's frequency resolution). The
value actually used is RECORDED.

    DETECT  the GLOBAL maximum of P lies within the band of one of the six
            gamma_n AND exceeds 5.0 x median(P)
    WEAK    a LOCAL peak within the band of one of the six exceeds 5.0 x
            median(P), but the global maximum is elsewhere
    NULL    neither

THE HEADLINE PREDICTION, fixed before the run, precedence order
H-SINGLE > H-JOINT > H-NONE > UNCLASSIFIED:

    H-JOINT   L2 = NULL and L3 = NULL and L23 = DETECT
    H-NONE    L2 = NULL and L3 = NULL and L23 = NULL
    H-SINGLE  either L2 or L3 alone comes out DETECT — which would contradict
              the Nyquist argument, and is the outcome that would falsify the
              framing
    UNCLASSIFIED  none of the three matches (e.g. a WEAK verdict on L23)

=============================================================================
CONTROLS
=============================================================================

C1. PHASE-RANDOMISED NULL. For each ladder, ehat_j is replaced by a surrogate
    that preserves the amplitude distribution exactly: a random permutation of
    the ehat values across j, drawn with numpy default_rng at the FIXED seed
    recorded in params (default 2026). The identical projection is run.
    --surrogates surrogates per ladder (default 200). Reported per ladder: the
    distribution of surrogate P_max/median (min, median, 95th percentile, max)
    and the percentile at which the real P_max/median falls in it; and the same
    for P/median AT gamma_1 specifically.
    THIS IS THE CRITICAL CONTROL: combining irregular samples can manufacture
    peaks, and if the real value is not beyond the surrogate 95th percentile the
    detection is not established.

C2. GAP-STRUCTURE CONTROL. One more ladder, L_irr, with the SAME number of rungs
    as L23 and the same first and last x, but with the interior rung positions
    drawn as a sorted uniform random sample in log x (same fixed seed). The
    identical pipeline is run on it. This separates "irregular sampling helps"
    from "the multiplicative structure specifically helps". Its verdict and its
    P/median at the six gamma_n are reported alongside L23's.

=============================================================================
GATES — all three RUN inside the script and recorded in the payload
=============================================================================

GATE A — EXACT TILING, per ladder. sum_j c_j must equal pi(x_last) - pi(x_0)
EXACTLY. Verified with exact integers via searchsorted at the two outer
endpoints.

GATE B — TIES TO THE TABLE. L2's counts must reproduce
N(r) = pi(2^r) - pi(2^(r-1)) from `pi2n_cache.json` (READ ONLY) for every r
where x0 * 2^m lands on a power of two. When x0 is not a power of two the gate
is recorded as "not applicable" with that reason. Run with --x0 2 to exercise
it.

GATE C — SANITY ON R. R(10^6) against pi(10^6) = 78498 from the sieve;
|R(10^6) - 78498| is recorded and the PASS criterion is that it is smaller than
|li(10^6) - 78498| = 129.549.

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` — ONE ROW PER (ladder, block), carrying ladder, j, x_j,
x_{j+1}, c_j, L_j, e_j, ehat_j. `params.code_version` is the sha256 of THIS
file, read from `__file__` at runtime. `params.precision` records the mix.

REQUIREMENTS
------------
    numpy, mpmath   (both already present in this bench's .venv)

USAGE
-----
    python3 O18_joint_multiplicative_ladder.py
    python3 O18_joint_multiplicative_ladder.py --x0 2 \
        --out results/O18_joint_multiplicative_ladder_x0_2.json
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
        "is no float fallback. This bench's O8/O9/O3/O17 already depend on "
        "mpmath; if the import failed the .venv is not the one described in "
        "REFERENCES.md. Install with: pip install mpmath")

# --------------------------------------------------------------------------
# Smooth-model backend detection, done ONCE at import — same contract as O17.
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

# Pre-registered band constants.
BAND_HALFWIDTH_FLOOR = 0.6
BAND_MEDIAN_FACTOR = 5.0

# Gate C reference values.
GATE_C_X = 1000000
GATE_C_PI_KNOWN = 78498
GATE_C_LI_KNOWN = 78627.549
GATE_C_LI_ABS_KNOWN = 129.549      # |li(10^6) - 78498|, quoted in the brief

LADDER_ORDER = ("L2", "L3", "L23", "L235", "L_irr")


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
    O17_disjoint_block_residual.py: the result is kept as sorted int64, because
    this script counts primes by searchsorted and must not lose exactness at
    1.5e8.
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
    array. side="right" so the interval (x_j, x_{j+1}] is half-open on the left
    and closed on the right — the same convention as the dyadic table's
    (2^(r-1), 2^r].
    """
    return int(np.searchsorted(primes, x, side="right"))


# --------------------------------------------------------------------------
# Ladder construction. Multipliers are EXACT Python integers, so the sort and
# the deduplication are exact and not a float tolerance.
# --------------------------------------------------------------------------

def smooth_multipliers(generators, x0, xmax):
    """
    Every product of the given generators (with non-negative exponents) m such
    that x0 * m <= xmax. Returned sorted ascending and deduplicated EXACTLY, as
    Python ints. With generators = (2,) this is the pure dyadic multiplier set;
    with (2, 3) it is the joint multiplicative semigroup; with (2, 3, 5) the
    three-generator one.
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


def random_log_uniform_ladder(x_first, x_last, n_rungs, rng):
    """
    C2's L_irr: n_rungs points with the SAME first and last x, the interior
    n_rungs - 2 drawn as a uniform random sample in log x and sorted. Same
    fixed-seed rng as the surrogates.
    """
    n = int(n_rungs)
    if n <= 2:
        return [float(x_first), float(x_last)][:max(n, 0)]
    a = math.log(float(x_first))
    b = math.log(float(x_last))
    interior = np.sort(rng.uniform(a, b, size=n - 2))
    logs = [a] + [float(v) for v in interior] + [b]
    return [float(math.exp(v)) for v in logs]


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
# Smooth model — Riemann's R, same backend contract as O17.
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
    R(x) at mp.dps = dps, memoised on the float x. The four ladders overlap
    heavily (L2 subset L23 subset L235), so memoising is what keeps the mpmath
    work proportional to the number of DISTINCT ladder points.
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
# Projection machinery — copied from O17 so the two instruments agree exactly.
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
# C1 — phase-randomised (amplitude-preserving permutation) surrogates.
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
    C1. n_surr surrogates, each a random PERMUTATION of the ehat values across
    j — the amplitude distribution is preserved exactly and only the pairing
    with the sample positions is destroyed. The identical projection is run on
    each. Returns the surrogate distributions of P_max/median and of
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
# The pipeline, run identically on every ladder.
# --------------------------------------------------------------------------

def run_ladder(name, pts, primes, rcache, gammas, g1_index, n_surr, seed,
               description):
    """
    The identical pipeline: exact counts, R difference, ehat, projection,
    pre-registered band, gate A, and the C1 surrogate null.
    """
    n_pts = len(pts)
    n_blocks = max(0, n_pts - 1)
    if n_blocks < 1:
        raise SystemExit(f"ladder {name}: no block survives; raise --xmax or "
                         "lower --x0.")

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

    # GATE A — exact tiling, per ladder.
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
        "ladder": name,
        "description": description,
        "n_rungs": n_pts,
        "n_blocks": n_blocks,
        "x_first": float(pts[0]),
        "x_last": float(pts[-1]),
        "log_gap_stats": gaps,
        "uniform_equivalent_nyquist": uniform_equiv_nyquist,
        "uniform_equivalent_nyquist_note": (
            "pi / median(log-gap). For the IRREGULAR ladders (L23, L235, "
            "L_irr) this is a DESCRIPTIVE NUMBER ONLY and NOT A BOUND, "
            "because irregular sampling is not limited by the uniform rate. "
            "For L2 and L3 the gaps are constant and it IS the uniform "
            "Nyquist limit"),
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


def classify_headline(v2, v3, v23):
    """
    The headline prediction, applied mechanically in the declared precedence
    order H-SINGLE > H-JOINT > H-NONE > UNCLASSIFIED.
    """
    if v2 == "DETECT" or v3 == "DETECT":
        return "H-SINGLE"
    if v2 == "NULL" and v3 == "NULL" and v23 == "DETECT":
        return "H-JOINT"
    if v2 == "NULL" and v3 == "NULL" and v23 == "NULL":
        return "H-NONE"
    return "UNCLASSIFIED"


def gate_b_check(pts, counts, cache_path):
    """
    GATE B. Compare L2's counts against N(r) = pi(2^r) - pi(2^(r-1)) from
    pi2n_cache.json (READ ONLY) for every block whose two endpoints are
    consecutive powers of two. When x0 is not a power of two no endpoint lands
    on a power of two, and the gate is recorded as "not applicable".
    """
    out = {"statement": ("L2's c_j == N(r) = pi(2^r) - pi(2^(r-1)) from "
                         "pi2n_cache.json, for every r where x0 * 2^m lands on "
                         "a power of two"),
           "cache_path": cache_path, "note": None, "n_compared": 0,
           "r_range": None, "mismatches": 0, "mismatch_detail": [],
           "passed": None}

    x0v = float(pts[0])
    l0 = math.log2(x0v)
    if abs(l0 - round(l0)) > 1e-9:
        out["note"] = (f"not applicable: x0 = {x0v:g} is not a power of two, so "
                       "no L2 ladder point lands on a power of two and there is "
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


def main():
    ap = argparse.ArgumentParser(
        description="O18 — joint multiplicative ladder: are the integer bases "
                    "blind to the zeros jointly, or only one at a time?")
    ap.add_argument("--x0", type=float, default=1000.0,
                    help="first ladder point x_0 (default 1000); --x0 2 makes "
                         "L2 the dyadic ladder and arms gate B")
    ap.add_argument("--xmax", type=int, default=150000000,
                    help="sieve limit / top of every value ladder "
                         "(default 150000000)")
    ap.add_argument("--gamma-max", type=float, default=40.0,
                    help="upper end of the gamma projection grid (default 40)")
    ap.add_argument("--gamma-step", type=float, default=0.01,
                    help="gamma projection grid step (default 0.01)")
    ap.add_argument("--dps", type=int, default=30,
                    help="mpmath decimal precision for R (default 30; the "
                         "script refuses to run below 30)")
    ap.add_argument("--surrogates", type=int, default=200,
                    help="C1 surrogates per ladder (default 200)")
    ap.add_argument("--seed", type=int, default=2026,
                    help="fixed seed for the C1 permutations and the C2 random "
                         "ladder (default 2026)")
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

    print("=" * 78, flush=True)
    print("O18 — joint multiplicative ladder  (fit-free; exact counts; "
          "projection, not fit)", flush=True)
    print("=" * 78, flush=True)
    print("  O17 showed a geometric ladder of ratio r samples log x at spacing "
          "log(r), so the", flush=True)
    print("  projection Nyquist is pi/log(r): 4.5324 for base 2 and 2.8595 for "
          "base 3, both far", flush=True)
    print(f"  below gamma_1 = {GAMMA_1}. Each integer base alone is therefore "
          "blind to every zero.", flush=True)
    print("  This script asks whether the bases are blind JOINTLY. The "
          "semigroup {2^m 3^n} is", flush=True)
    print("  IRREGULARLY spaced in log x, and irregular sampling is NOT bound "
          "by the uniform", flush=True)
    print("  rate. Interpretation of the numbers below is NOT this script's "
          "job.", flush=True)
    print("", flush=True)
    print(f"  x0 = {x0:g}   xmax = {xmax}   dps = {dps}   "
          f"surrogates = {n_surr}   seed = {seed}", flush=True)
    print(f"  pi/log2 = {math.pi / math.log(2.0):.6f}     "
          f"pi/log3 = {math.pi / math.log(3.0):.6f}", flush=True)

    # ---------------- sieve ------------------------------------------------
    print(f"\n  sieving primes to {xmax}...", flush=True)
    primes = sieve_primes(xmax)
    n_primes = int(primes.size)
    largest_prime = int(primes[-1]) if n_primes else None
    print(f"  {n_primes} primes, largest = {largest_prime}", flush=True)

    # ---------------- ladders ----------------------------------------------
    print("\n  building ladders (multipliers as EXACT Python integers; sort "
          "and dedup exact)...", flush=True)
    mult2 = smooth_multipliers((2,), x0, xmax)
    mult3 = smooth_multipliers((3,), x0, xmax)
    mult23 = smooth_multipliers((2, 3), x0, xmax)
    mult235 = smooth_multipliers((2, 3, 5), x0, xmax)

    ladders = {
        "L2": (ladder_from_multipliers(x0, mult2),
               "x = x0 * 2^m, m >= 0 (pure dyadic; uniform log-gap = log 2)"),
        "L3": (ladder_from_multipliers(x0, mult3),
               "x = x0 * 3^n, n >= 0 (pure triadic; uniform log-gap = log 3)"),
        "L23": (ladder_from_multipliers(x0, mult23),
                "x = x0 * 2^m * 3^n, m,n >= 0 (the joint orbit; irregular)"),
        "L235": (ladder_from_multipliers(x0, mult235),
                 "x = x0 * 2^m * 3^n * 5^k, m,n,k >= 0 (three generators; "
                 "irregular)"),
    }

    # C2 — L_irr: same rung count and same endpoints as L23, positions uniform
    # random in log x. Built with a fresh default_rng at the SAME fixed seed.
    l23_pts = ladders["L23"][0]
    irr_rng = np.random.default_rng(seed)
    l_irr_pts = random_log_uniform_ladder(l23_pts[0], l23_pts[-1],
                                          len(l23_pts), irr_rng)
    ladders["L_irr"] = (l_irr_pts,
                        "C2 gap-structure control: same rung count and same "
                        "first/last x as L23, interior rungs a sorted uniform "
                        "random sample in log x at the fixed seed")

    print(f"\n  {'ladder':>7} {'rungs':>7} {'first x':>18} {'last x':>18} "
          f"{'gap min':>11} {'gap med':>11} {'gap max':>11} "
          f"{'pi/gap_med':>12}", flush=True)
    for nm in LADDER_ORDER:
        pts, _ = ladders[nm]
        g = gap_stats(pts)
        print(f"  {nm:>7} {len(pts):>7} {_fmtg(pts[0], 18, 12)} "
              f"{_fmtg(pts[-1], 18, 12)} "
              f"{_fmt(g['min'], 11, 7)} {_fmt(g['median'], 11, 7)} "
              f"{_fmt(g['max'], 11, 7)} "
              f"{_fmt(_safe_div(math.pi, g['median']), 12, 6)}", flush=True)
    print(f"\n  reference: log 2 = {math.log(2.0):.7f}   "
          f"log 3 = {math.log(3.0):.7f}   log 5 = {math.log(5.0):.7f}",
          flush=True)
    print("  For L2 and L3 the log-gaps are CONSTANT, so pi/gap IS the uniform "
          "Nyquist limit.", flush=True)
    print("  For L23, L235 and L_irr the gaps are IRREGULAR and pi/median_gap "
          "is a DESCRIPTIVE", flush=True)
    print("  NUMBER ONLY, NOT A BOUND — irregular sampling is not limited by "
          "the uniform rate.", flush=True)

    # ---------------- pipeline per ladder ----------------------------------
    gammas = np.arange(0.0, args.gamma_max + 0.5 * args.gamma_step,
                       args.gamma_step, dtype=np.float64)
    n_gamma = int(gammas.size)
    g1_index = int(np.argmin(np.abs(gammas - GAMMA_1)))

    rcache = RCache(dps)
    results = {}
    for nm in LADDER_ORDER:
        pts, desc = ladders[nm]
        print(f"\n  running pipeline on {nm} ({len(pts)} rungs, "
              f"{len(pts) - 1} blocks); computing R at mp.dps = {dps} "
              f"({RIEMANNR_IMPL}) ...", flush=True)
        results[nm] = run_ladder(nm, pts, primes, rcache, gammas, g1_index,
                                 n_surr, seed, desc)
        print(f"  {nm}: total primes counted = "
              f"{results[nm]['total_count']}, block size "
              f"{results[nm]['block_size_min']}.."
              f"{results[nm]['block_size_max']}, verdict "
              f"{results[nm]['verdict']}", flush=True)
    print(f"\n  distinct R(x) evaluations : {rcache.n_computed}", flush=True)

    # ---------------- per-ladder block tables ------------------------------
    for nm in LADDER_ORDER:
        rr = results[nm]
        print("\n" + "-" * 78, flush=True)
        print(f"BLOCKS — {nm} — one row per disjoint interval (x_j, x_{{j+1}}]",
              flush=True)
        print("-" * 78, flush=True)
        print(f"  {rr['description']}", flush=True)
        print(f"  {'j':>4} {'x_j':>18} {'x_{j+1}':>18} {'c_j':>10} "
              f"{'L_j':>18} {'e_j':>16} {'ehat_j':>14}", flush=True)
        for j in range(rr["n_blocks"]):
            print(f"  {j:>4} {_fmtg(rr['_xj'][j], 18, 12)} "
                  f"{_fmtg(rr['_xj1'][j], 18, 12)} "
                  f"{rr['_counts'][j]:>10} {_fmtg(rr['_Lj'][j], 18, 12)} "
                  f"{_fmtg(rr['_ej'][j], 16, 8)} "
                  f"{_fmtg(rr['_ehat'][j], 14, 7)}", flush=True)
        es = rr["ehat_stats"]
        print(f"\n  ehat: n = {es['n']}  min = {es['min']:.10g}  "
              f"max = {es['max']:.10g}  mean = {es['mean']:.10g}  "
              f"RMS = {es['rms']:.10g}", flush=True)

    # ---------------- projection summary -----------------------------------
    print("\n" + "-" * 78, flush=True)
    print("PROJECTION  P(gamma) = |sum_j w_j ehat_j exp(-i gamma log x_j)|  "
          "(NON-UNIFORM DFT,", flush=True)
    print("            a direct sum valid for arbitrary x_j; an inner product, "
          "NOT a fit)", flush=True)
    print("-" * 78, flush=True)
    print(f"  gamma grid : 0 to {args.gamma_max:g} step {args.gamma_step:g}  "
          f"({n_gamma} points)   window: hann", flush=True)
    print(f"  band half-width per ladder = max({BAND_HALFWIDTH_FLOOR:g}, that "
          f"ladder's frequency resolution)", flush=True)
    print(f"  threshold : P > {BAND_MEDIAN_FACTOR:g} x median(P)", flush=True)
    print(f"\n  {'ladder':>7} {'n_blk':>7} {'log-x span':>12} {'2pi/span':>11} "
          f"{'band hw':>10} {'median(P)':>14} {'argmax g':>10} "
          f"{'P_max/med':>12} {'verdict':>9}", flush=True)
    for nm in LADDER_ORDER:
        rr = results[nm]
        pr = rr["projection"]
        print(f"  {nm:>7} {rr['n_blocks']:>7} "
              f"{_fmt(rr['projection_log_x_span'], 12, 6)} "
              f"{_fmt(rr['frequency_resolution'], 11, 6)} "
              f"{_fmt(rr['band_halfwidth_used'], 10, 6)} "
              f"{_fmtg(pr['P_median'], 14, 8)} "
              f"{_fmt(pr['argmax_gamma'], 10, 4)} "
              f"{_fmt(pr['P_max_over_median'], 12, 6)} "
              f"{rr['verdict']:>9}", flush=True)

    print(f"\n  P/median AT THE SIX gamma_n", flush=True)
    print(f"  {'ladder':>7} " + " ".join(f"{'g'+str(i+1):>11}"
                                         for i in range(len(GAMMAS))),
          flush=True)
    for nm in LADDER_ORDER:
        vals = results[nm]["projection"]["P_at_gamma_over_median"]
        print(f"  {nm:>7} " + " ".join(_fmt(v, 11, 5) for v in vals),
              flush=True)
    print(f"\n  gamma_n = " + ", ".join(format(g, ".6f") for g in GAMMAS),
          flush=True)

    for nm in LADDER_ORDER:
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

    # ---------------- C1 ----------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("C1 — PHASE-RANDOMISED NULL (amplitude-preserving permutation of "
          "ehat across j)", flush=True)
    print("-" * 78, flush=True)
    print(f"  {n_surr} surrogates per ladder, numpy default_rng(seed={seed}), "
          f"identical projection.", flush=True)
    print("  THIS IS THE CRITICAL CONTROL: combining irregular samples can "
          "manufacture peaks.", flush=True)
    print("  If the real value is not beyond the surrogate 95th percentile the "
          "detection is not", flush=True)
    print("  established.", flush=True)
    print(f"\n  SURROGATE P_max/median", flush=True)
    print(f"  {'ladder':>7} {'surr min':>12} {'surr med':>12} {'surr p95':>12} "
          f"{'surr max':>12} {'REAL':>12} {'real pct':>10} {'> p95':>7}",
          flush=True)
    for nm in LADDER_ORDER:
        s = results[nm]["surrogate_null"]["P_max_over_median"]
        d = s["surrogate_distribution"]
        print(f"  {nm:>7} {_fmt(d['min'], 12, 6)} {_fmt(d['median'], 12, 6)} "
              f"{_fmt(d['p95'], 12, 6)} {_fmt(d['max'], 12, 6)} "
              f"{_fmt(s['real_value'], 12, 6)} "
              f"{_fmt(s['real_percentile_in_surrogates'], 10, 3)} "
              f"{str(s['real_exceeds_surrogate_p95']):>7}", flush=True)

    print(f"\n  SURROGATE P/median AT gamma_1 = {GAMMA_1}", flush=True)
    print(f"  {'ladder':>7} {'surr min':>12} {'surr med':>12} {'surr p95':>12} "
          f"{'surr max':>12} {'REAL':>12} {'real pct':>10} {'> p95':>7}",
          flush=True)
    for nm in LADDER_ORDER:
        s = results[nm]["surrogate_null"]["P_at_gamma_1_over_median"]
        d = s["surrogate_distribution"]
        print(f"  {nm:>7} {_fmt(d['min'], 12, 6)} {_fmt(d['median'], 12, 6)} "
              f"{_fmt(d['p95'], 12, 6)} {_fmt(d['max'], 12, 6)} "
              f"{_fmt(s['real_value'], 12, 6)} "
              f"{_fmt(s['real_percentile_in_surrogates'], 10, 3)} "
              f"{str(s['real_exceeds_surrogate_p95']):>7}", flush=True)

    # ---------------- C2 ----------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("C2 — GAP-STRUCTURE CONTROL: L_irr vs L23", flush=True)
    print("-" * 78, flush=True)
    print("  L_irr has the SAME rung count and the SAME first and last x as "
          "L23, with the", flush=True)
    print("  interior rungs a sorted uniform random sample in log x at the "
          "fixed seed. This", flush=True)
    print("  separates 'irregular sampling helps' from 'the multiplicative "
          "structure specifically", flush=True)
    print("  helps'.", flush=True)
    print(f"\n  {'ladder':>7} {'rungs':>7} {'gap min':>11} {'gap med':>11} "
          f"{'gap max':>11} {'argmax g':>10} {'P_max/med':>12} "
          f"{'verdict':>9}", flush=True)
    for nm in ("L23", "L_irr"):
        rr = results[nm]
        g = rr["log_gap_stats"]
        pr = rr["projection"]
        print(f"  {nm:>7} {rr['n_rungs']:>7} {_fmt(g['min'], 11, 7)} "
              f"{_fmt(g['median'], 11, 7)} {_fmt(g['max'], 11, 7)} "
              f"{_fmt(pr['argmax_gamma'], 10, 4)} "
              f"{_fmt(pr['P_max_over_median'], 12, 6)} "
              f"{rr['verdict']:>9}", flush=True)
    print(f"\n  P/median AT THE SIX gamma_n — L23 against L_irr", flush=True)
    print(f"  {'ladder':>7} " + " ".join(f"{'g'+str(i+1):>11}"
                                         for i in range(len(GAMMAS))),
          flush=True)
    for nm in ("L23", "L_irr"):
        vals = results[nm]["projection"]["P_at_gamma_over_median"]
        print(f"  {nm:>7} " + " ".join(_fmt(v, 11, 5) for v in vals),
              flush=True)

    # ---------------- GATES -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — EXACT TILING, per ladder: sum_j c_j == pi(x_last) - pi(x_0)",
          flush=True)
    print("-" * 78, flush=True)
    print(f"  {'ladder':>7} {'pi(x_0)':>12} {'pi(x_last)':>12} "
          f"{'expected':>12} {'sum c_j':>12} {'diff':>8} {'gate A':>9}",
          flush=True)
    gate_a_all = True
    for nm in LADDER_ORDER:
        ga = results[nm]["gate_a"]
        gate_a_all = gate_a_all and bool(ga["passed"])
        print(f"  {nm:>7} {ga['pi_x0']:>12} {ga['pi_x_last']:>12} "
              f"{ga['expected']:>12} {ga['sum_c_j']:>12} "
              f"{ga['difference']:>8} "
              f"{('PASSED' if ga['passed'] else 'FAILED'):>9}", flush=True)
    print(f"  GATE A overall: {'PASSED' if gate_a_all else 'FAILED'}",
          flush=True)

    print("\n" + "-" * 78, flush=True)
    print("GATE B — TIES TO THE TABLE: L2's c_j vs N(r) = pi(2^r) - pi(2^(r-1))",
          flush=True)
    print("         from pi2n_cache.json (READ ONLY)", flush=True)
    print("-" * 78, flush=True)
    gate_b = gate_b_check(ladders["L2"][0], results["L2"]["_counts"],
                          args.cache)
    print(f"  source : {args.cache}   (READ ONLY)", flush=True)
    if gate_b.get("cache_entries") is not None:
        print(f"  cache entries : {gate_b['cache_entries']}  n range "
              f"{gate_b['cache_n_range'][0]}..{gate_b['cache_n_range'][1]}",
              flush=True)
    if gate_b["note"]:
        print(f"  {gate_b['note']}", flush=True)
    print(f"  r values compared : {gate_b['n_compared']}"
          + (f"   (r = {gate_b['r_range'][0]}..{gate_b['r_range'][1]})"
             if gate_b["r_range"] else ""), flush=True)
    print(f"  mismatches        : {gate_b['mismatches']}", flush=True)
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

    # ---------------- headline ---------------------------------------------
    v2 = results["L2"]["verdict"]
    v3 = results["L3"]["verdict"]
    v23 = results["L23"]["verdict"]
    v235 = results["L235"]["verdict"]
    virr = results["L_irr"]["verdict"]
    headline = classify_headline(v2, v3, v23)

    print("\n" + "-" * 78, flush=True)
    print("BAND VERDICTS + HEADLINE PREDICTION — pre-registered, applied "
          "mechanically", flush=True)
    print("-" * 78, flush=True)
    for nm in LADDER_ORDER:
        print(f"  {nm:>7} : {results[nm]['verdict']}", flush=True)
    print("\n  H-JOINT   : L2 = NULL and L3 = NULL and L23 = DETECT", flush=True)
    print("  H-NONE    : L2 = NULL and L3 = NULL and L23 = NULL", flush=True)
    print("  H-SINGLE  : either L2 or L3 alone comes out DETECT", flush=True)
    print("  precedence: H-SINGLE > H-JOINT > H-NONE > UNCLASSIFIED",
          flush=True)
    print(f"\n  HEADLINE: {headline}", flush=True)

    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  c_j are EXACT INTEGER prime counts by binary search; no float "
          "approximation to", flush=True)
    print(f"  pi(x) is used anywhere. L_j is an mpmath R difference at dps "
          f"{dps}, cast to float", flush=True)
    print("  only after the cancellation. The projection is float64 and is a "
          "NON-UNIFORM DFT.", flush=True)
    print("  P(gamma) is an INNER PRODUCT, not a fit. The bands and the "
          "headline prediction were", flush=True)
    print("  fixed before the run.", flush=True)
    print(f"  gate A (exact tiling, all ladders) : "
          f"{'PASSED' if gate_a_all else 'FAILED'}", flush=True)
    print(f"  gate B (ties to table, L2)         : "
          f"{'PASSED' if gate_b['passed'] else ('NOT APPLICABLE / NOT RUN' if gate_b['passed'] is None else 'FAILED')}",
          flush=True)
    print(f"  gate C (R sanity)                  : "
          f"{'PASSED' if gate_c_passed else 'FAILED'}", flush=True)
    print(f"  verdicts : L2 {v2} / L3 {v3} / L23 {v23} / L235 {v235} / "
          f"L_irr {virr}", flush=True)
    print(f"  headline : {headline}", flush=True)
    print("  Interpretation of these numbers is NOT this script's job.",
          flush=True)

    # ---------------- payload -----------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT

        rows = []
        for nm in LADDER_ORDER:
            rr = results[nm]
            for j in range(rr["n_blocks"]):
                rows.append({
                    "ladder": nm,
                    "j": j,
                    "x_j": float(rr["_xj"][j]),
                    "x_j_plus_1": float(rr["_xj1"][j]),
                    "c_j": int(rr["_counts"][j]),
                    "L_j": float(rr["_Lj"][j]),
                    "e_j": float(rr["_ej"][j]),
                    "ehat_j": float(rr["_ehat"][j]),
                })

        ladder_summaries = {}
        for nm in LADDER_ORDER:
            rr = dict(results[nm])
            for k in ("_counts", "_xj", "_xj1", "_Lj", "_ej", "_ehat"):
                rr.pop(k, None)
            sn = dict(rr["surrogate_null"])
            sn.pop("_max_ratios", None)
            sn.pop("_g1_ratios", None)
            rr["surrogate_null"] = sn
            ladder_summaries[nm] = rr

        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "x0": x0,
                "xmax": xmax,
                "gamma_max": args.gamma_max,
                "gamma_step": args.gamma_step,
                "n_gamma": n_gamma,
                "dps": dps,
                "surrogates": n_surr,
                "seed": seed,
                "riemannr_impl": RIEMANNR_IMPL,
                "cache_path": args.cache,
                "n_primes": n_primes,
                "largest_prime": largest_prime,
                "ladders": list(LADDER_ORDER),
                "band_halfwidth_floor": BAND_HALFWIDTH_FLOOR,
                "band_median_factor": BAND_MEDIAN_FACTOR,
                "window": "hann",
                "distinct_riemannr_evaluations": rcache.n_computed,
                "ladder_definition":
                    "L2: x = x0*2^m; L3: x = x0*3^n; L23: x = x0*2^m*3^n; "
                    "L235: x = x0*2^m*3^n*5^k, all with non-negative exponents "
                    "and x <= xmax, sorted ascending and deduplicated exactly "
                    "(multipliers built as exact Python integers). L_irr is "
                    "the C2 control: same rung count and same first/last x as "
                    "L23, interior rungs a sorted uniform random sample in "
                    "log x at the fixed seed",
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
                    "C1: ehat replaced by a random permutation of its own "
                    "values across j — the amplitude distribution is preserved "
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
                "o10_note": (
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script"),
                "nyquist_note": (
                    "a geometric ladder of ratio r samples log x at spacing "
                    "log(r), so the uniform projection Nyquist is pi/log(r): "
                    "4.5324 for base 2 and 2.8595 for base 3, both below "
                    "gamma_1 = 14.134725. The uniform-equivalent Nyquist "
                    "pi/median_gap reported for the IRREGULAR ladders is a "
                    "DESCRIPTIVE NUMBER ONLY and NOT A BOUND, because "
                    "irregular sampling is not limited by the uniform rate"),
                "band_rule": (
                    "DETECT: global max of P within the band half-width of one "
                    "of gamma_1..gamma_6 AND > 5x median(P); WEAK: a local "
                    "peak within the band of one of the six > 5x median(P) but "
                    "the global max is elsewhere; NULL: neither"),
                "band_halfwidth_rule": (
                    "per ladder, max(0.6, that ladder's frequency resolution "
                    "2*pi/(log x_last - log x_first) over the projection's own "
                    "points); the value used is recorded"),
                "headline_rule": (
                    "precedence H-SINGLE > H-JOINT > H-NONE > UNCLASSIFIED. "
                    "H-JOINT: L2 = NULL and L3 = NULL and L23 = DETECT. "
                    "H-NONE: L2 = NULL and L3 = NULL and L23 = NULL. "
                    "H-SINGLE: either L2 or L3 alone comes out DETECT, which "
                    "would contradict the Nyquist argument and is the outcome "
                    "that would falsify the framing"),
                "c1_note": (
                    "C1 is the critical control: combining irregular samples "
                    "can manufacture peaks, and if the real value is not "
                    "beyond the surrogate 95th percentile the detection is not "
                    "established"),
                "c2_note": (
                    "C2 separates 'irregular sampling helps' from 'the "
                    "multiplicative structure specifically helps'"),
                "gate_c_pi_known": GATE_C_PI_KNOWN,
                "gate_c_li_known": GATE_C_LI_KNOWN,
                "gate_c_li_abs_known": GATE_C_LI_ABS_KNOWN,
            },
            "summary": {
                "ladders": ladder_summaries,
                "verdicts": {nm: results[nm]["verdict"]
                             for nm in LADDER_ORDER},
                "headline": headline,
                "gate_a_all_passed": bool(gate_a_all),
                "gate_b": gate_b,
                "gate_c": gate_c,
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
