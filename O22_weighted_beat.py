#!/usr/bin/env python3
"""
O22 — Weighted Beat: does restoring Connes' (log p) weight and the prime powers
      improve the Prime Beat's ability to LOCATE Riemann zeros?

Reads with: O20_connes_cutoff_sweep.py (its c-sweep and its first-zero errors,
one of which this script reads at runtime); O8_weil_inner_product.py;
REFERENCES.md.

NAMING
------
The O-series in this tree runs O1-O9, O11-O21.  There is NO O10: that number is
a known, DELIBERATE GAP, and this script does not fill it, because filling a
reserved gap with unrelated work would silently rewrite the series' history.
This file takes O22.  Capital "O" per `CLAUDE.md` § "Naming convention (do not
re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

The Prime Beat, as defined in Julian's January 2026 write-up, is

    B_N(t) = | sum over primes p <= N of  p^(-1/2) sin(t ln p) |

Connes' Weil local term (arXiv:2602.04022 §4.1, eq. 9) is

    W_p(f) = (log p) * sum over m>=1 of  p^(-m/2) * [ f(p^m) + f(p^(-m)) ]

So the Beat is the m = 1 term of the Weil local term with the (log p) weight
DROPPED and the PRIME POWERS DROPPED.  This script tests whether restoring them
improves the Beat's ability to locate Riemann zeros, and quantifies how much of
Connes' accuracy comes from the WEIGHTING versus from his VARIATIONAL
construction.

Three variants, same primes, same t grid, NO FITTING ANYWHERE:

    V0 "plain"        sum_p               p^(-1/2) sin(t log p)
    V1 "logp"         sum_p      (log p)  p^(-1/2) sin(t log p)
    V2 "vonmangoldt"  sum_{p,m}  (log p)  p^(-m/2) sin(t m log p)   (m <= --mmax)

V2 is the classical explicit-formula prime side, i.e.
sum_n Lambda(n) n^(-1/2) sin(t log n).

=============================================================================
WHAT IS COMPUTED
=============================================================================

1. PRIME SETS.  Two families, both recorded, and every one of them is a PREFIX
   of the sorted prime list, which is why one incremental pass computes them
   all:

     (a) WINDOW SETS matched to Connes' cutoff: all primes <= c for c in
         --cvals (default "13,17,19,23,29").  c = 13 gives {2,3,5,7,11,13},
         which is exactly the window Connes computes in, and corresponds to
         bridge depth d = 2*log2(c) - 1 = 6.40.
     (b) COUNT SETS: the first n primes for n in --nvals (default
         "10,100,1000,4000,25000").  n = 4000 is the size of Julian's December
         surface; n = 25000 is the largest N in his Z-score table.

2. For each (variant, prime set): |B(t)| is evaluated on a grid
   t in [--tmin, --tmax] at step --tstep, every strict LOCAL MINIMUM (strictly
   less than both neighbours) is found, and each one is REFINED by
   GOLDEN-SECTION SEARCH on its bracketing triple to a tolerance of
   --refine-tol (default 1e-12).  Grid-resolution minima are NOT reported: the
   grid alone would floor every error at --tstep.  The number of minima found
   is reported.

   GRID METHOD.  The grid sum is evaluated by the exact angle-addition
   identity, not term-by-term over the whole grid: with t_k = tmin + k*h and
   k = a*nb + b,

       sin(freq * t_k) = sin(P_a) cos(Q_b) + cos(P_a) sin(Q_b)
       P_a = freq*(tmin + a*nb*h),   Q_b = freq*(b*h)

   so the grid becomes two matrix products per chunk of terms.  This is an
   IDENTITY, not an approximation; it is nevertheless VERIFIED every run
   against a direct np.sin evaluation on randomly chosen grid points, and the
   max absolute deviation is recorded under `summary.grid_method_check`.  The
   golden-section refinement does NOT use the decomposition — it sums the terms
   directly at each scalar t.

3. MATCH.  For each of the first --n-zeros (default 8) true zero heights
   gamma_n, the NEAREST refined minimum is found and the SIGNED difference
   (minimum - gamma_n) and its absolute value are recorded.  gamma_n comes from
   mpmath.zetazero(n).imag at mp.dps = --dps (default 30), cast to float; the
   values used are recorded so the comparison is reproducible.

4. Per (variant, prime set): the per-zero absolute differences, their MEDIAN,
   their MAX, and the difference at gamma_1 specifically.

5. THE HEADLINE COMPARISON.  For the c = 13 window set, each variant's
   |difference| at gamma_1 is printed next to Connes' measured first-zero error
   at the SAME cutoff.  That number is READ AT RUNTIME from
   `results/O20_connes_cutoff_sweep_T1600.json` (the converged-T value) — it is
   NOT hardcoded.  If that file is missing the script falls back to
   `results/O20_connes_cutoff_sweep_results.json` and RECORDS which file it
   used.  The RATIO beat_error / connes_error is reported.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

On the MEDIAN absolute difference across the --n-zeros zeros, evaluated
SEPARATELY for each prime set, comparing a test variant against V0 (plain):

    IMPROVES   median(test) <= median(V0) / 2
    WORSENS    median(test) >= 2 * median(V0)
    NEUTRAL    otherwise (within a factor of 2 in either direction)

Precedence: IMPROVES, then WORSENS, then NEUTRAL.  Reported for V1-vs-V0 and
for V2-vs-V0, for EVERY prime set.  Also reported, mechanically and without
interpretation: whether the ORDERING of the three variants by median error is
the same across all prime sets or changes with set size.

The bands are fixed here and are not adjusted by the script.  Interpretation of
what they mean is NOT this script's job and is not performed anywhere in this
file.

=============================================================================
GATES — all three RUN inside the script and are recorded in the payload
=============================================================================

GATE A — REPRODUCES THE DECEMBER SURFACE.  With the first 4000 primes, V0 must
have a local minimum within 0.05 of each of gamma_1 = 14.134725,
gamma_2 = 21.022040, gamma_3 = 25.010858 (the three canyons in Julian's
December surface).  Pass/fail with the three distances.

GATE B — REFINEMENT IS DOING WORK.  For one NAMED (variant, prime set) — V0 on
the first 4000 primes, at the minimum nearest gamma_1 — the difference between
the RAW GRID minimum and the GOLDEN-SECTION refined minimum is reported.  It
must be strictly greater than 0 and strictly smaller than the grid step.

GATE C — THE GRID CONTAINS THE ZEROS.  tmin, tmax and gamma_{--n-zeros} are
reported and every gamma used must lie inside [tmin, tmax].

=============================================================================
ENVELOPE
=============================================================================

House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` (ONE ROW PER (variant, prime set, zero)).
`params.code_version` is the sha256 of THIS file, read from `__file__` at
runtime.  `params.precision` records the mix: float64 for the beat, mpmath at
the recorded dps for the zeta zeros.

REQUIREMENTS
------------
    numpy, mpmath   (both already present in this bench's .venv)

USAGE
-----
    ./.venv/bin/python3 O22_weighted_beat.py
    ./.venv/bin/python3 O22_weighted_beat.py --nvals 10,100 --no-json
"""

import os

# Single-threaded BLAS on purpose: this bench runs long mpmath jobs alongside
# this script, and this script must not take cores away from them. Set BEFORE
# numpy is imported, which is the only point at which these are read.
for _v in ("OMP_NUM_THREADS", "OPENBLAS_NUM_THREADS", "MKL_NUM_THREADS",
           "VECLIB_MAXIMUM_THREADS", "NUMEXPR_NUM_THREADS"):
    os.environ.setdefault(_v, "1")

import argparse
import hashlib
import json
import math
import time
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
        "mpmath is required and is NOT optional for this script: the true zero "
        "heights gamma_n come from mpmath.zetazero and there is no float "
        "fallback. Install with: pip install mpmath")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")

# Connes' measured first-zero error is READ AT RUNTIME from O20's output, never
# hardcoded. Preferred file first, fallback second; which one was used is
# recorded in the payload.
DEFAULT_CONNES_JSON = os.path.join(
    _HERE, "results", "O20_connes_cutoff_sweep_T1600.json")
DEFAULT_CONNES_FALLBACK = os.path.join(
    _HERE, "results", "O20_connes_cutoff_sweep_results.json")
CONNES_CUTOFF = 13

VARIANTS = ("V0_plain", "V1_logp", "V2_vonmangoldt")
VARIANT_FORMULA = {
    "V0_plain": "sum_p p^(-1/2) sin(t log p)",
    "V1_logp": "sum_p (log p) p^(-1/2) sin(t log p)",
    "V2_vonmangoldt":
        "sum_{p,m<=mmax} (log p) p^(-m/2) sin(t m log p) "
        "= sum_n Lambda(n) n^(-1/2) sin(t log n)",
}

# Gate A constants — the three canyons of the December surface, quoted at the
# precision Julian's write-up quotes them.
GATE_A_GAMMAS = (14.134725, 21.022040, 25.010858)
GATE_A_TOL = 0.05
GATE_A_NVAL = 4000

# Gate B is reported for this NAMED (variant, prime set).
GATE_B_VARIANT = "V0_plain"
GATE_B_SET = "n=4000"

# Pre-registered band constants.
BAND_FACTOR = 2.0

DEFAULT_CVALS = "13,17,19,23,29"
DEFAULT_NVALS = "10,100,1000,4000,25000"


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


def parse_int_list(s, flag):
    """Comma-separated positive-int list -> list of ints, order preserved."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        try:
            v = int(tok)
        except ValueError:
            raise SystemExit(f"{flag}: '{tok}' is not an integer")
        if v < 1:
            raise SystemExit(f"{flag}: '{tok}' must be >= 1")
        out.append(v)
    if not out:
        raise SystemExit(f"{flag} is empty")
    return out


def sieve_primes(limit):
    """Exact primes <= limit by a numpy boolean sieve; sorted int64 array."""
    limit = int(limit)
    if limit < 2:
        return np.zeros(0, dtype=np.int64)
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.int64)


def first_n_primes(n):
    """
    The first n primes, by sieving to a bound from the prime-counting estimate
    and enlarging until enough primes are found. No approximation survives into
    the result: the primes themselves are exact.
    """
    n = int(n)
    if n < 1:
        return np.zeros(0, dtype=np.int64)
    if n < 6:
        limit = 15
    else:
        limit = int(n * (math.log(n) + math.log(math.log(n)))) + 10
    while True:
        pr = sieve_primes(limit)
        if pr.size >= n:
            return pr[:n]
        limit *= 2


def build_terms(variant, primes, mmax, term_floor):
    """
    Build the (frequency, coefficient) term list for one variant, together with
    `bounds`: bounds[i] is the number of terms contributed by the first i+1
    primes, so any PREFIX of the prime list maps to a prefix of the term list.

        V0_plain        one term per prime: freq log p, coeff p^(-1/2)
        V1_logp         one term per prime: freq log p, coeff (log p) p^(-1/2)
        V2_vonmangoldt  m = 1..mmax per prime: freq m log p,
                        coeff (log p) p^(-m/2), truncated as soon as the
                        coefficient falls below `term_floor` (recorded)

    The V2 truncation is a magnitude floor, not a fit: the dropped terms are
    smaller than `term_floor` (default 1e-15) and the number dropped is
    recorded.
    """
    p = np.asarray(primes, dtype=np.float64)
    lp = np.log(p)
    if variant == "V0_plain":
        freqs = lp.copy()
        coeffs = p ** -0.5
        bounds = np.arange(1, p.size + 1, dtype=np.int64)
        return freqs, coeffs, bounds, 0
    if variant == "V1_logp":
        freqs = lp.copy()
        coeffs = lp * (p ** -0.5)
        bounds = np.arange(1, p.size + 1, dtype=np.int64)
        return freqs, coeffs, bounds, 0
    if variant == "V2_vonmangoldt":
        fr, co, bd = [], [], []
        dropped = 0
        for i in range(p.size):
            pv = float(p[i])
            lpv = float(lp[i])
            for m in range(1, int(mmax) + 1):
                c = lpv * pv ** (-0.5 * m)
                if c < term_floor:
                    dropped += int(mmax) - m + 1
                    break
                fr.append(m * lpv)
                co.append(c)
            bd.append(len(fr))
        return (np.asarray(fr, dtype=np.float64),
                np.asarray(co, dtype=np.float64),
                np.asarray(bd, dtype=np.int64), dropped)
    raise SystemExit(f"unknown variant {variant}")


def grid_prefix_sums(freqs, coeffs, term_bounds, tmin, h, npts, nb, chunk):
    """
    Evaluate S(t) = sum_j coeff_j sin(freq_j * t) on the uniform grid
    t_k = tmin + k*h, k = 0..npts-1, for every prefix in `term_bounds`
    (ascending), in ONE incremental pass.

    The grid is laid out as k = a*nb + b, and the exact angle-addition identity

        sin(freq*t_k) = sin(P_a) cos(Q_b) + cos(P_a) sin(Q_b)
        P_a = freq*(tmin + a*nb*h),   Q_b = freq*(b*h)

    turns each chunk of terms into two matrix products.  This is an IDENTITY,
    not an approximation, and it is verified separately against direct np.sin.

    Returns a list of float64 arrays of length npts, one per entry of
    `term_bounds`, each the running sum over terms[:bound].
    """
    na = int(math.ceil(npts / float(nb)))
    a_idx = np.arange(na, dtype=np.float64)
    b_idx = np.arange(nb, dtype=np.float64)
    base_a = tmin + a_idx * (nb * h)          # (na,)
    base_b = b_idx * h                        # (nb,)
    S = np.zeros((na, nb), dtype=np.float64)
    out = []
    start = 0
    for bound in term_bounds:
        bound = int(bound)
        while start < bound:
            end = min(start + int(chunk), bound)
            f = freqs[start:end]
            c = coeffs[start:end]
            P = np.outer(base_a, f)           # (na, F)
            Q = np.outer(f, base_b)           # (F, nb)
            S += (np.sin(P) * c) @ np.cos(Q)
            S += (np.cos(P) * c) @ np.sin(Q)
            start = end
        out.append(S.reshape(-1)[:npts].copy())
    return out


def direct_sum_at(freqs, coeffs, t):
    """S(t) at a single scalar t, summed directly. Used by the refinement."""
    return float(np.dot(coeffs, np.sin(freqs * t)))


def grid_local_minima(absS):
    """Indices k with absS[k] < absS[k-1] and absS[k] < absS[k+1]."""
    if absS.size < 3:
        return np.zeros(0, dtype=np.int64)
    interior = absS[1:-1]
    mask = (interior < absS[:-2]) & (interior < absS[2:])
    return np.flatnonzero(mask) + 1


_INVPHI = (math.sqrt(5.0) - 1.0) / 2.0
_INVPHI2 = (3.0 - math.sqrt(5.0)) / 2.0


def golden_section_min(f, a, b, tol):
    """
    Golden-section search for the minimum of f on [a, b], to a bracket width
    of `tol`. Returns (x, f(x), n_evals, n_iters). Unimodality is assumed only
    within the single grid triple that brackets the minimum.
    """
    a, b = float(a), float(b)
    if b < a:
        a, b = b, a
    h = b - a
    n_ev = 0
    if h <= tol:
        x = 0.5 * (a + b)
        return x, f(x), 1, 0
    n_it = int(math.ceil(math.log(tol / h) / math.log(_INVPHI)))
    c = a + _INVPHI2 * h
    d = a + _INVPHI * h
    fc, fd = f(c), f(d)
    n_ev += 2
    for _ in range(n_it):
        if fc < fd:
            b, d, fd = d, c, fc
            h *= _INVPHI
            c = a + _INVPHI2 * h
            fc = f(c)
        else:
            a, c, fc = c, d, fd
            h *= _INVPHI
            d = a + _INVPHI * h
            fd = f(d)
        n_ev += 1
    if fc < fd:
        x, fx = 0.5 * (a + d), fc
    else:
        x, fx = 0.5 * (c + b), fd
    return x, f(x), n_ev + 1, n_it


def band_label(m_test, m_ref, factor=BAND_FACTOR):
    """
    Mechanical application of the pre-registered band, in precedence order:
        IMPROVES  median(test) <= median(ref) / factor
        WORSENS   median(test) >= factor * median(ref)
        NEUTRAL   otherwise
    UNDEFINED when either median is missing or non-finite.
    """
    try:
        a, b = float(m_test), float(m_ref)
    except (TypeError, ValueError):
        return "UNDEFINED"
    if not (math.isfinite(a) and math.isfinite(b)):
        return "UNDEFINED"
    if a <= b / factor:
        return "IMPROVES"
    if a >= factor * b:
        return "WORSENS"
    return "NEUTRAL"


def read_connes_first_zero_error(primary, fallback, cutoff):
    """
    Read Connes' measured first-zero error at the given cutoff from O20's
    output. Preferred file first, fallback second. NOTHING is hardcoded; the
    file actually used and the path are returned with the value.
    """
    for path, tag in ((primary, "primary"), (fallback, "fallback")):
        if not path or not os.path.exists(path):
            continue
        try:
            with open(path, "r") as fh:
                d = json.load(fh)
        except Exception as exc:
            return {"value": None, "source_path": path, "source_kind": tag,
                    "note": f"could not parse: {exc}"}
        for row in d.get("rows", []):
            try:
                if int(row.get("c")) == int(cutoff) and int(row.get("k")) == 1:
                    return {"value": float(row.get("error")),
                            "value_str": row.get("error_str"),
                            "source_path": path, "source_kind": tag,
                            "source_field": "rows[c=%d,k=1].error" % cutoff,
                            "source_T": (d.get("params") or {}).get("T"),
                            "source_N": (d.get("params") or {}).get("N"),
                            "source_dps": (d.get("params") or {}).get("dps"),
                            "note": None}
            except (TypeError, ValueError):
                continue
        for rec in (d.get("summary") or {}).get(
                "first_zero_error_by_cutoff", []) or []:
            try:
                if int(rec.get("c")) == int(cutoff):
                    return {"value": float(rec.get("first_zero_error")),
                            "source_path": path, "source_kind": tag,
                            "source_field":
                                "summary.first_zero_error_by_cutoff",
                            "source_T": (d.get("params") or {}).get("T"),
                            "note": None}
            except (TypeError, ValueError):
                continue
        return {"value": None, "source_path": path, "source_kind": tag,
                "note": f"no c = {cutoff}, k = 1 record in this file"}
    return {"value": None, "source_path": None, "source_kind": None,
            "note": "neither the primary nor the fallback O20 JSON exists"}


def main():
    ap = argparse.ArgumentParser(
        description="O22 — weighted beat: does restoring Connes' (log p) "
                    "weight and the prime powers improve the Prime Beat's "
                    "ability to locate Riemann zeros?")
    ap.add_argument("--cvals", type=str, default=DEFAULT_CVALS,
                    help="comma-separated Connes-style prime cutoffs c; the "
                         "window set is all primes <= c "
                         f"(default '{DEFAULT_CVALS}')")
    ap.add_argument("--nvals", type=str, default=DEFAULT_NVALS,
                    help="comma-separated counts n; the count set is the first "
                         f"n primes (default '{DEFAULT_NVALS}')")
    ap.add_argument("--tmin", type=float, default=10.0,
                    help="lower end of the t grid (default 10)")
    ap.add_argument("--tmax", type=float, default=50.0,
                    help="upper end of the t grid (default 50)")
    ap.add_argument("--tstep", type=float, default=1e-4,
                    help="t grid step (default 1e-4); minima found on this "
                         "grid are REFINED, never reported raw")
    ap.add_argument("--n-zeros", type=int, default=8,
                    help="number of true zero heights gamma_n to match "
                         "(default 8)")
    ap.add_argument("--mmax", type=int, default=20,
                    help="maximum prime-power index m in V2 (default 20)")
    ap.add_argument("--term-floor", type=float, default=1e-15,
                    help="V2 magnitude floor: (log p) p^(-m/2) below this is "
                         "dropped and the count is recorded (default 1e-15)")
    ap.add_argument("--refine-tol", type=float, default=1e-12,
                    help="golden-section bracket tolerance (default 1e-12)")
    ap.add_argument("--dps", type=int, default=30,
                    help="mpmath decimal precision for zetazero (default 30)")
    ap.add_argument("--block-nb", type=int, default=640,
                    help="inner block length of the grid factorisation "
                         "k = a*nb + b (default 640); an implementation "
                         "detail of an exact identity, it does not change the "
                         "quantity computed")
    ap.add_argument("--chunk", type=int, default=512,
                    help="terms per matrix-product chunk (default 512)")
    ap.add_argument("--check-points", type=int, default=2000,
                    help="grid points re-evaluated directly to verify the "
                         "angle-addition identity (default 2000)")
    ap.add_argument("--connes-json", type=str, default=DEFAULT_CONNES_JSON,
                    help="O20 results JSON to read Connes' first-zero error "
                         "from (default results/"
                         "O20_connes_cutoff_sweep_T1600.json)")
    ap.add_argument("--connes-json-fallback", type=str,
                    default=DEFAULT_CONNES_FALLBACK,
                    help="fallback O20 results JSON (default results/"
                         "O20_connes_cutoff_sweep_results.json)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    t_start = time.time()
    run_start_utc = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")

    cvals = parse_int_list(args.cvals, "--cvals")
    nvals = parse_int_list(args.nvals, "--nvals")
    tmin, tmax, h = float(args.tmin), float(args.tmax), float(args.tstep)
    if not (h > 0.0 and math.isfinite(h)):
        raise SystemExit(f"--tstep {h} must be finite and > 0")
    if tmax <= tmin:
        raise SystemExit(f"--tmax {tmax} must exceed --tmin {tmin}")
    n_zeros = int(args.n_zeros)
    if n_zeros < 1:
        raise SystemExit("--n-zeros must be >= 1")
    mmax = int(args.mmax)
    if mmax < 1:
        raise SystemExit("--mmax must be >= 1")
    dps = int(args.dps)
    if dps < 15:
        raise SystemExit(f"--dps {dps} is too low for zetazero; refusing")

    npts = int(math.floor((tmax - tmin) / h + 0.5)) + 1

    print("=" * 78, flush=True)
    print("O22 — weighted beat  (three variants, same primes, same grid, "
          "NO FITTING)", flush=True)
    print("=" * 78, flush=True)
    for v in VARIANTS:
        print(f"  {v:<16} {VARIANT_FORMULA[v]}", flush=True)
    print("", flush=True)
    print("  The Beat is the m = 1 term of Connes' Weil local term with the "
          "(log p) weight", flush=True)
    print("  dropped and the prime powers dropped. This script restores them, "
          "one at a time.", flush=True)
    print("", flush=True)
    print(f"  t grid : [{tmin:g}, {tmax:g}] step {h:g}  ({npts} points)",
          flush=True)
    print(f"  mmax   : {mmax}   term floor : {args.term_floor:g}", flush=True)
    print(f"  refine : golden section to bracket width {args.refine_tol:g}",
          flush=True)

    # ---------------- true zero heights -------------------------------------
    print(f"\n  computing gamma_1..gamma_{n_zeros} from mpmath.zetazero at "
          f"mp.dps = {dps} ...", flush=True)
    old_dps = mp.dps
    gammas, gammas_str = [], []
    try:
        mp.dps = dps
        for k in range(1, n_zeros + 1):
            z = mpmath.zetazero(k)
            gammas.append(float(mpmath.im(z)))
            gammas_str.append(mpmath.nstr(mpmath.im(z), 25))
    finally:
        mp.dps = old_dps
    for k, (g, gs) in enumerate(zip(gammas, gammas_str), start=1):
        print(f"    gamma_{k} = {g!r}   ({gs})", flush=True)

    # ---------------- GATE C -------------------------------------------------
    gate_c_inside = [bool(tmin <= g <= tmax) for g in gammas]
    gate_c_passed = all(gate_c_inside)
    print("\n" + "-" * 78, flush=True)
    print("GATE C — the t grid contains every gamma used", flush=True)
    print("-" * 78, flush=True)
    print(f"  tmin = {tmin:g}   tmax = {tmax:g}", flush=True)
    print(f"  gamma_1 = {gammas[0]:.9f}   gamma_{n_zeros} = "
          f"{gammas[-1]:.9f}", flush=True)
    print(f"  GATE C: {'PASSED' if gate_c_passed else 'FAILED'}", flush=True)

    # ---------------- prime sets --------------------------------------------
    n_max = max(nvals)
    primes_all = first_n_primes(n_max)
    largest_needed_c = max(cvals)
    if int(primes_all[-1]) < largest_needed_c:
        primes_all = sieve_primes(largest_needed_c)
        n_max = int(primes_all.size)

    prime_sets = []           # (label, family, count, cutoff-or-None)
    for c in cvals:
        cnt = int(np.searchsorted(primes_all, c, side="right"))
        if cnt < 1:
            raise SystemExit(f"--cvals {c}: no primes <= {c}")
        prime_sets.append({"label": f"c<={c}", "family": "window",
                           "cutoff_c": int(c), "n_primes": cnt,
                           "d_bridge": 2.0 * math.log(c, 2) - 1.0})
    for n in nvals:
        if n > int(primes_all.size):
            raise SystemExit(f"--nvals {n}: only {primes_all.size} primes built")
        prime_sets.append({"label": f"n={n}", "family": "count",
                           "cutoff_c": None, "n_primes": int(n),
                           "d_bridge": None})
    for ps in prime_sets:
        ps["largest_prime"] = int(primes_all[ps["n_primes"] - 1])

    prefix_counts = sorted({ps["n_primes"] for ps in prime_sets})
    print("\n" + "-" * 78, flush=True)
    print("PRIME SETS — every one is a PREFIX of the sorted prime list",
          flush=True)
    print("-" * 78, flush=True)
    print(f"  {'label':>10} {'family':>8} {'n_primes':>9} "
          f"{'largest_p':>10} {'d = 2log2(c)-1':>16}", flush=True)
    for ps in prime_sets:
        print(f"  {ps['label']:>10} {ps['family']:>8} {ps['n_primes']:>9} "
              f"{ps['largest_prime']:>10} "
              f"{_fmtg(ps['d_bridge'], 16, 8)}", flush=True)
    print(f"\n  distinct prefixes computed once: {prefix_counts}", flush=True)

    # ---------------- per-variant computation --------------------------------
    rng = np.random.default_rng(0)   # only picks which grid points to re-check
    per_variant = {}
    grid_check = {}
    minima_by = {}          # (variant, n_primes) -> dict

    for variant in VARIANTS:
        tv0 = time.time()
        print("\n" + "=" * 78, flush=True)
        print(f"VARIANT {variant} — {VARIANT_FORMULA[variant]}", flush=True)
        print("=" * 78, flush=True)
        freqs, coeffs, bounds, dropped = build_terms(
            variant, primes_all, mmax, float(args.term_floor))
        term_bounds = [int(bounds[c - 1]) for c in prefix_counts]
        print(f"  terms total : {freqs.size}   "
              f"(dropped below the floor: {dropped})", flush=True)
        print(f"  term prefixes for the prime prefixes {prefix_counts} : "
              f"{term_bounds}", flush=True)
        print(f"  max frequency : {float(np.max(freqs)):.6f}   "
              f"max coefficient : {float(np.max(coeffs)):.6g}", flush=True)

        print("  evaluating the grid (angle-addition identity, chunked "
              "matrix products) ...", flush=True)
        sums = grid_prefix_sums(freqs, coeffs, term_bounds, tmin, h, npts,
                                int(args.block_nb), int(args.chunk))
        print(f"  grid done in {time.time() - tv0:.2f} s", flush=True)

        # ---- verification of the identity against a direct np.sin sum ------
        chk_pts = int(args.check_points)
        idx = np.unique(rng.integers(0, npts, size=min(chk_pts, npts)))
        worst = 0.0
        worst_rel = 0.0
        for si, bnd in enumerate(term_bounds):
            if si not in (0, len(term_bounds) - 1):
                continue
            f_s, c_s = freqs[:bnd], coeffs[:bnd]
            for k in idx[:200]:
                t = tmin + int(k) * h
                direct = float(np.dot(c_s, np.sin(f_s * t)))
                d = abs(direct - float(sums[si][int(k)]))
                worst = max(worst, d)
                worst_rel = max(worst_rel, _safe_div(d, max(abs(direct), 1e-30)))
        grid_check[variant] = {"max_abs_deviation": worst,
                               "max_rel_deviation": worst_rel,
                               "points_checked": int(min(200, idx.size)) * 2,
                               "prefixes_checked": [term_bounds[0],
                                                    term_bounds[-1]]}
        print(f"  identity check vs direct np.sin : max |deviation| = "
              f"{worst:.6g}", flush=True)

        # ---- minima per prefix ----------------------------------------------
        for si, cnt in enumerate(prefix_counts):
            bnd = term_bounds[si]
            f_s, c_s = freqs[:bnd], coeffs[:bnd]

            def fabs(t, _f=f_s, _c=c_s):
                return abs(float(np.dot(_c, np.sin(_f * t))))

            absS = np.abs(sums[si])
            mins_idx = grid_local_minima(absS)
            ref_t = np.empty(mins_idx.size, dtype=np.float64)
            ref_v = np.empty(mins_idx.size, dtype=np.float64)
            raw_t = np.empty(mins_idx.size, dtype=np.float64)
            for j, k in enumerate(mins_idx):
                k = int(k)
                a = tmin + (k - 1) * h
                b = tmin + (k + 1) * h
                x, fx, _, _ = golden_section_min(fabs, a, b,
                                                 float(args.refine_tol))
                raw_t[j] = tmin + k * h
                ref_t[j] = x
                ref_v[j] = fx
            minima_by[(variant, cnt)] = {
                "n_minima": int(mins_idx.size),
                "raw_t": raw_t, "ref_t": ref_t, "ref_v": ref_v,
                "n_terms": int(bnd),
            }
            print(f"    prefix n_primes = {cnt:>6}  terms = {bnd:>7}  "
                  f"local minima found = {int(mins_idx.size):>6}", flush=True)
        per_variant[variant] = {"n_terms_total": int(freqs.size),
                                "dropped_below_floor": int(dropped),
                                "max_frequency": float(np.max(freqs)),
                                "wall_seconds": time.time() - tv0}
        del sums

    # ---------------- match minima to zeros ----------------------------------
    print("\n" + "=" * 78, flush=True)
    print("MATCH — nearest refined minimum to each gamma_n", flush=True)
    print("=" * 78, flush=True)

    results = {}    # (variant, set label) -> dict
    rows = []
    for ps in prime_sets:
        for variant in VARIANTS:
            rec = minima_by[(variant, ps["n_primes"])]
            ref_t = rec["ref_t"]
            diffs, absdiffs, near_t, near_v, near_raw = [], [], [], [], []
            for g in gammas:
                if ref_t.size == 0:
                    diffs.append(None)
                    absdiffs.append(float("nan"))
                    near_t.append(None)
                    near_v.append(None)
                    near_raw.append(None)
                    continue
                j = int(np.argmin(np.abs(ref_t - g)))
                d = float(ref_t[j] - g)
                diffs.append(d)
                absdiffs.append(abs(d))
                near_t.append(float(ref_t[j]))
                near_v.append(float(rec["ref_v"][j]))
                near_raw.append(float(rec["raw_t"][j]))
            fin = [x for x in absdiffs if math.isfinite(x)]
            results[(variant, ps["label"])] = {
                "signed": diffs, "abs": absdiffs,
                "median_abs": float(np.median(fin)) if fin else float("nan"),
                "max_abs": float(np.max(fin)) if fin else float("nan"),
                "abs_at_gamma1": absdiffs[0] if absdiffs else float("nan"),
                "n_minima": rec["n_minima"],
                "nearest_t": near_t, "nearest_val": near_v,
                "nearest_raw_t": near_raw,
            }
            for zi, g in enumerate(gammas, start=1):
                rows.append({
                    "variant": variant,
                    "set_label": ps["label"],
                    "set_family": ps["family"],
                    "cutoff_c": ps["cutoff_c"],
                    "d_bridge": ps["d_bridge"],
                    "n_primes": ps["n_primes"],
                    "largest_prime": ps["largest_prime"],
                    "n_minima": rec["n_minima"],
                    "k": zi,
                    "gamma_true": g,
                    "gamma_true_str": gammas_str[zi - 1],
                    "nearest_min_refined": near_t[zi - 1],
                    "nearest_min_raw_grid": near_raw[zi - 1],
                    "abs_B_at_min": near_v[zi - 1],
                    "difference_signed": diffs[zi - 1],
                    "difference_abs": absdiffs[zi - 1],
                })

    for ps in prime_sets:
        print("\n" + "-" * 78, flush=True)
        print(f"SET {ps['label']}  (family {ps['family']}, n_primes = "
              f"{ps['n_primes']}, largest prime = {ps['largest_prime']})",
              flush=True)
        print("-" * 78, flush=True)
        print(f"  {'variant':<16} {'n_minima':>9} " +
              " ".join(f"{'|d|g'+str(i):>13}" for i in range(1, n_zeros + 1)),
              flush=True)
        for variant in VARIANTS:
            r = results[(variant, ps["label"])]
            print(f"  {variant:<16} {r['n_minima']:>9} " +
                  " ".join(_fmtg(x, 13, 6) for x in r["abs"]), flush=True)
        print(f"\n  {'variant':<16} {'median|d|':>16} {'max|d|':>16} "
              f"{'|d| at gamma_1':>16}", flush=True)
        for variant in VARIANTS:
            r = results[(variant, ps["label"])]
            print(f"  {variant:<16} {_fmtg(r['median_abs'], 16, 8)} "
                  f"{_fmtg(r['max_abs'], 16, 8)} "
                  f"{_fmtg(r['abs_at_gamma1'], 16, 8)}", flush=True)

    # ---------------- pre-registered bands -----------------------------------
    print("\n" + "=" * 78, flush=True)
    print("PRE-REGISTERED BANDS — on the MEDIAN absolute difference, "
          "test vs V0_plain", flush=True)
    print("=" * 78, flush=True)
    print("  IMPROVES  median(test) <= median(V0)/2", flush=True)
    print("  WORSENS   median(test) >= 2*median(V0)", flush=True)
    print("  NEUTRAL   otherwise", flush=True)
    print(f"\n  {'set':>10} {'median V0':>16} {'median V1':>16} "
          f"{'median V2':>16} {'V1 vs V0':>10} {'V2 vs V0':>10}", flush=True)
    bands = []
    orderings = []
    for ps in prime_sets:
        m0 = results[("V0_plain", ps["label"])]["median_abs"]
        m1 = results[("V1_logp", ps["label"])]["median_abs"]
        m2 = results[("V2_vonmangoldt", ps["label"])]["median_abs"]
        b1 = band_label(m1, m0)
        b2 = band_label(m2, m0)
        order = [v for v, _ in sorted(
            ((v, results[(v, ps["label"])]["median_abs"]) for v in VARIANTS),
            key=lambda kv: (float("inf") if not math.isfinite(kv[1])
                            else kv[1]))]
        orderings.append(tuple(order))
        bands.append({"set_label": ps["label"], "family": ps["family"],
                      "n_primes": ps["n_primes"],
                      "median_V0_plain": m0, "median_V1_logp": m1,
                      "median_V2_vonmangoldt": m2,
                      "band_V1_vs_V0": b1, "band_V2_vs_V0": b2,
                      "ratio_V1_over_V0": _safe_div(m1, m0),
                      "ratio_V2_over_V0": _safe_div(m2, m0),
                      "ordering_by_median": list(order)})
        print(f"  {ps['label']:>10} {_fmtg(m0, 16, 8)} {_fmtg(m1, 16, 8)} "
              f"{_fmtg(m2, 16, 8)} {b1:>10} {b2:>10}", flush=True)

    ordering_stable = len(set(orderings)) == 1
    print("\n  ORDERING of the three variants by median error, per set:",
          flush=True)
    for ps, o in zip(prime_sets, orderings):
        print(f"    {ps['label']:>10} : {' < '.join(o)}", flush=True)
    print(f"\n  ordering identical across ALL prime sets : "
          f"{'YES' if ordering_stable else 'NO'}   "
          f"({len(set(orderings))} distinct orderings)", flush=True)

    # ---------------- headline comparison ------------------------------------
    connes = read_connes_first_zero_error(args.connes_json,
                                          args.connes_json_fallback,
                                          CONNES_CUTOFF)
    c13_label = f"c<={CONNES_CUTOFF}"
    has_c13 = any(ps["label"] == c13_label for ps in prime_sets)
    print("\n" + "=" * 78, flush=True)
    print(f"HEADLINE — c = {CONNES_CUTOFF} window: beat error at gamma_1 vs "
          "Connes' measured first-zero error", flush=True)
    print("=" * 78, flush=True)
    print(f"  Connes value source : {connes.get('source_path')}   "
          f"({connes.get('source_kind')})", flush=True)
    if connes.get("note"):
        print(f"  NOTE                : {connes['note']}", flush=True)
    print(f"  Connes first-zero error at c = {CONNES_CUTOFF} : "
          f"{_fmtg(connes.get('value'), 18, 10)}", flush=True)
    headline = {"cutoff_c": CONNES_CUTOFF, "connes": connes, "per_variant": []}
    if has_c13:
        print(f"\n  {'variant':<16} {'|d| at gamma_1':>18} "
              f"{'connes error':>18} {'ratio beat/connes':>22}", flush=True)
        for variant in VARIANTS:
            e = results[(variant, c13_label)]["abs_at_gamma1"]
            ratio = _safe_div(e, connes.get("value"))
            headline["per_variant"].append({
                "variant": variant, "beat_abs_diff_at_gamma1": e,
                "connes_first_zero_error": connes.get("value"),
                "ratio_beat_over_connes": ratio})
            print(f"  {variant:<16} {_fmtg(e, 18, 10)} "
                  f"{_fmtg(connes.get('value'), 18, 10)} "
                  f"{_fmtg(ratio, 22, 10)}", flush=True)
    else:
        headline["note"] = (f"c = {CONNES_CUTOFF} is not among --cvals; the "
                            "headline comparison was not computed")
        print(f"  c = {CONNES_CUTOFF} is not among --cvals — headline not "
              "computed", flush=True)

    # ---------------- GATE A -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — V0_plain on the first 4000 primes has a local minimum "
          "within 0.05 of", flush=True)
    print("         gamma_1 = 14.134725, gamma_2 = 21.022040, "
          "gamma_3 = 25.010858", flush=True)
    print("-" * 78, flush=True)
    gate_a = {"statement": ("V0_plain with the first %d primes has a local "
                            "minimum within %g of each of %s"
                            % (GATE_A_NVAL, GATE_A_TOL, str(GATE_A_GAMMAS))),
              "n_primes": GATE_A_NVAL, "tol": GATE_A_TOL,
              "gammas": list(GATE_A_GAMMAS), "distances": [],
              "nearest_minima": [], "passed": None, "note": None}
    if ("V0_plain", GATE_A_NVAL) in minima_by:
        rt = minima_by[("V0_plain", GATE_A_NVAL)]["ref_t"]
        oks = []
        for g in GATE_A_GAMMAS:
            if rt.size == 0:
                gate_a["distances"].append(None)
                gate_a["nearest_minima"].append(None)
                oks.append(False)
                continue
            j = int(np.argmin(np.abs(rt - g)))
            d = float(abs(rt[j] - g))
            gate_a["distances"].append(d)
            gate_a["nearest_minima"].append(float(rt[j]))
            oks.append(bool(d <= GATE_A_TOL))
        gate_a["passed"] = bool(all(oks))
        for g, d, mn, ok in zip(GATE_A_GAMMAS, gate_a["distances"],
                                gate_a["nearest_minima"], oks):
            print(f"    gamma = {g:<12} nearest refined minimum = "
                  f"{_fmtg(mn, 16, 10)}   distance = {_fmtg(d, 14, 6)}   "
                  f"{'ok' if ok else 'MISS'}", flush=True)
    else:
        gate_a["note"] = (f"n = {GATE_A_NVAL} is not among --nvals; gate A "
                          "was NOT RUN")
        print(f"    n = {GATE_A_NVAL} is not among --nvals — GATE A NOT RUN",
              flush=True)
    print(f"  GATE A: {'PASSED' if gate_a['passed'] else ('NOT RUN' if gate_a['passed'] is None else 'FAILED')}",
          flush=True)

    # ---------------- GATE B -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print(f"GATE B — refinement is doing work, at ({GATE_B_VARIANT}, "
          f"{GATE_B_SET}), minimum nearest gamma_1", flush=True)
    print("-" * 78, flush=True)
    gate_b = {"statement": ("0 < |refined - raw grid| < grid step, at the "
                            f"minimum nearest gamma_1 for ({GATE_B_VARIANT}, "
                            f"{GATE_B_SET})"),
              "variant": GATE_B_VARIANT, "set_label": GATE_B_SET,
              "grid_step": h, "raw_grid_min": None, "refined_min": None,
              "abs_shift": None, "gamma_1": gammas[0],
              "abs_B_at_refined": None, "passed": None, "note": None}
    key = (GATE_B_VARIANT, GATE_B_SET)
    if key in results and results[key]["nearest_t"][0] is not None:
        raw = results[key]["nearest_raw_t"][0]
        ref = results[key]["nearest_t"][0]
        shift = abs(ref - raw)
        gate_b["raw_grid_min"] = raw
        gate_b["refined_min"] = ref
        gate_b["abs_shift"] = shift
        gate_b["abs_B_at_refined"] = results[key]["nearest_val"][0]
        gate_b["passed"] = bool(0.0 < shift < h)
        print(f"    raw grid minimum        : {raw!r}", flush=True)
        print(f"    golden-section refined  : {ref!r}", flush=True)
        print(f"    |refined - raw|         : {shift:.6g}", flush=True)
        print(f"    grid step               : {h:g}", flush=True)
        print(f"    |B| at the refined min  : "
              f"{_fmtg(gate_b['abs_B_at_refined'], 16, 8)}", flush=True)
    else:
        gate_b["note"] = (f"({GATE_B_VARIANT}, {GATE_B_SET}) not present in "
                          "this run; gate B was NOT RUN")
        print(f"    ({GATE_B_VARIANT}, {GATE_B_SET}) not in this run — "
              "GATE B NOT RUN", flush=True)
    print(f"  GATE B: {'PASSED' if gate_b['passed'] else ('NOT RUN' if gate_b['passed'] is None else 'FAILED')}",
          flush=True)

    # ---------------- read the result ---------------------------------------
    wall = time.time() - t_start
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  Three variants, the SAME primes and the SAME grid; nothing is "
          "fitted anywhere.", flush=True)
    print("  Minima are refined by golden section, so no error is floored at "
          "the grid step.", flush=True)
    print("  The bands were fixed before the run and are applied "
          "mechanically.", flush=True)
    print(f"  gate A (December canyons) : "
          f"{'PASSED' if gate_a['passed'] else ('NOT RUN' if gate_a['passed'] is None else 'FAILED')}",
          flush=True)
    print(f"  gate B (refinement works) : "
          f"{'PASSED' if gate_b['passed'] else ('NOT RUN' if gate_b['passed'] is None else 'FAILED')}",
          flush=True)
    print(f"  gate C (grid holds zeros) : "
          f"{'PASSED' if gate_c_passed else 'FAILED'}", flush=True)
    print(f"  ordering stable across sets : "
          f"{'YES' if ordering_stable else 'NO'}", flush=True)
    print(f"  wall time : {wall:.2f} s", flush=True)
    print("  Interpretation of these numbers is NOT this script's job.",
          flush=True)

    # ---------------- payload ------------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "cvals": cvals,
                "cvals_raw": str(args.cvals),
                "nvals": nvals,
                "nvals_raw": str(args.nvals),
                "tmin": tmin,
                "tmax": tmax,
                "tstep": h,
                "n_grid_points": npts,
                "n_zeros": n_zeros,
                "mmax": mmax,
                "term_floor": float(args.term_floor),
                "refine_tol": float(args.refine_tol),
                "dps": dps,
                "block_nb": int(args.block_nb),
                "chunk": int(args.chunk),
                "check_points": int(args.check_points),
                "connes_json": args.connes_json,
                "connes_json_fallback": args.connes_json_fallback,
                "out": out_path,
                "numpy_version": np.__version__,
                "mpmath_version": mpmath.__version__,
                "blas_threads_env": {v: os.environ.get(v) for v in (
                    "OMP_NUM_THREADS", "OPENBLAS_NUM_THREADS",
                    "MKL_NUM_THREADS", "VECLIB_MAXIMUM_THREADS")},
                "run_start_utc": run_start_utc,
                "wall_seconds": wall,
                "variant_definitions": dict(VARIANT_FORMULA),
                "grid_method":
                    "S(t_k) with k = a*nb + b evaluated by the exact "
                    "angle-addition identity sin(f*t_k) = sin(P_a)cos(Q_b) + "
                    "cos(P_a)sin(Q_b), P_a = f*(tmin + a*nb*h), Q_b = f*b*h, "
                    "as two matrix products per chunk of terms. An IDENTITY, "
                    "not an approximation; verified every run against direct "
                    "np.sin and recorded in summary.grid_method_check",
                "refinement_method":
                    "every strict grid local minimum of |S| is refined by "
                    "golden-section search on the bracketing triple "
                    "(t_{k-1}, t_{k+1}) to a bracket width of refine_tol; the "
                    "refinement sums the terms DIRECTLY at each scalar t and "
                    "does not use the grid factorisation",
                "match_rule":
                    "for each gamma_n the NEAREST refined minimum is taken; "
                    "the signed difference is (minimum - gamma_n)",
                "v2_truncation":
                    "V2 includes m = 1..mmax per prime, stopping as soon as "
                    "(log p) p^(-m/2) < term_floor; the number of dropped "
                    "(p, m) pairs is recorded per variant",
                "fit_free": True,
                "precision":
                    "mixed: float64 for the beat (terms, grid, refinement) "
                    f"and mpmath at mp.dps = {dps} for the zeta zero heights "
                    "gamma_n, cast to float once and recorded as strings too",
            },
            "constants": {
                "gammas": list(gammas),
                "gammas_str": list(gammas_str),
                "gamma_source": f"mpmath.zetazero(n).imag at mp.dps = {dps}",
                "gate_a_gammas": list(GATE_A_GAMMAS),
                "gate_a_tol": GATE_A_TOL,
                "band_factor": BAND_FACTOR,
                "band_rule":
                    "on the MEDIAN absolute difference across the zeros, per "
                    "prime set, test vs V0_plain, in precedence order: "
                    "IMPROVES = median(test) <= median(V0)/2; WORSENS = "
                    "median(test) >= 2*median(V0); NEUTRAL = otherwise",
                "connes_local_term":
                    "W_p(f) = (log p) sum_{m>=1} p^(-m/2) [f(p^m) + f(p^-m)], "
                    "arXiv:2602.04022 §4.1 eq. 9",
                "beat_definition":
                    "B_N(t) = |sum_{p <= N} p^(-1/2) sin(t ln p)|, Julian's "
                    "January 2026 write-up",
                "bridge_coordinate": "d = 2*log2(c) - 1",
                "o10_note":
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script",
            },
            "summary": {
                "n_prime_sets": len(prime_sets),
                "prime_sets": prime_sets,
                "prefix_counts": prefix_counts,
                "per_variant": per_variant,
                "grid_method_check": grid_check,
                "per_set_per_variant": [
                    {"set_label": ps["label"], "family": ps["family"],
                     "n_primes": ps["n_primes"], "variant": v,
                     "n_minima": results[(v, ps["label"])]["n_minima"],
                     "abs_differences": results[(v, ps["label"])]["abs"],
                     "signed_differences": results[(v, ps["label"])]["signed"],
                     "median_abs": results[(v, ps["label"])]["median_abs"],
                     "max_abs": results[(v, ps["label"])]["max_abs"],
                     "abs_at_gamma1": results[(v, ps["label"])]["abs_at_gamma1"]}
                    for ps in prime_sets for v in VARIANTS],
                "bands": bands,
                "ordering_by_median_per_set": [
                    {"set_label": ps["label"], "ordering": list(o)}
                    for ps, o in zip(prime_sets, orderings)],
                "ordering_stable_across_sets": bool(ordering_stable),
                "n_distinct_orderings": len(set(orderings)),
                "headline_c13": headline,
                "gate_a": gate_a,
                "gate_b": gate_b,
                "gate_c": {
                    "statement": "every gamma used lies inside [tmin, tmax]",
                    "tmin": tmin, "tmax": tmax,
                    "gamma_last": gammas[-1],
                    "n_zeros": n_zeros,
                    "inside": gate_c_inside,
                    "passed": bool(gate_c_passed),
                },
                "wall_seconds": wall,
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
