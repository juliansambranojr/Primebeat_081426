#!/usr/bin/env python3
"""
O23 — Alignment replication: re-run the Prime Beat "extreme alignment" MEAN-AMPLITUDE
      statistic under the original's exact control flow, then measure how much the
      published Z-scores move under (a) seed, (b) scramble count, and (c) a different
      null.

NAMING
------
The O-series in this tree runs O1-O9, O11-O22.  There is NO O10: that number is a
known, DELIBERATE GAP, and this script does not fill it.  The next free number after
O22 is O23; this file takes it.  Capital "O" per `CLAUDE.md` § "Naming convention
(do not re-break)".

=============================================================================
WHAT THIS REPLICATES
=============================================================================

The Prime Beat paper's headline table reports Z-scores of

    -10.71, -16.03, -16.96, -17.61   at N = 1000, 5000, 10000, 25000
                                     against zeros 1-5000

plus a collapse/recovery result of

    -1.33  at N=1000  and  -12.04 at N=5000   against zeros 5001-10000

Those numbers were produced by

    /Users/juliansambrano/GitHub/primebeat/.archive/tests/suites/
        extreme_alignment_logging.py

whose statistic is NOT a minima statistic.  It computes the MEAN AMPLITUDE of
|B_N(t)| evaluated at the true zero heights, against the mean at uniformly random t
drawn from the same range, 100 scrambles, global seed 2025:

    real_mean = mean( |B_N| at the true zeros )
    for each of 100 scrambles:
        t_rnd ~ Uniform(zeros.min(), zeros.max()), size = len(zeros)
        scr_mean = mean( |B_N| at t_rnd )
    Z = (real_mean - mean(scr_means)) / std(scr_means, ddof=1)

with

    B_N(t) = sum_p  p^(-1/2) * sin(t * log p)          (original: weights = p ** -0.5)

The archived CSV beside that script

    /Users/juliansambrano/GitHub/primebeat/archived_results/runs/
        primebeat_extreme_alignment_20251220_022922/results_extreme.csv

records -10.71, -1.14, -16.55, -13.79, -16.78, -15.56, -19.85, -15.70 — only the
FIRST cell matches the published table.  The raw data for the published run does not
exist in that repo; only a prose note.  This script re-runs the statistic to see what
reproduces.

=============================================================================
STEP 0 — THE ONE AMBIGUITY, RESOLVED FROM SOURCE
=============================================================================

`prime_limits = [1000, 5000, 10000, 25000]`.  Value bound, or prime count?  The
original's builder, quoted VERBATIM with its line numbers in
extreme_alignment_logging.py:

    111  def build_primes_up_to(N_max):
    112      # Sieve of Eratosthenes
    113      sieve = np.ones(N_max+1, dtype=bool)
    114      sieve[:2] = False
    115      for i in range(2, int(np.sqrt(N_max)) + 1):
    116          if sieve[i]:
    117              sieve[i*i:N_max+1:i] = False
    118      primes = np.nonzero(sieve)[0]
    119      log_p = np.log(primes)
    120      weights = primes ** -0.5
    121      return primes, log_p, weights

The sieve array has length `N_max+1` and `np.nonzero(sieve)[0]` returns the INDICES
that survive, i.e. the prime VALUES <= N_max.  There is no truncation to a count.
So `prime_limits` is a **VALUE bound**: N_max = 25000 gives the 2762 primes below
25000, NOT 25000 primes.  This is the PRIMARY convention here, recorded as
`params.prime_limit_convention = "value"`.

The other reading — "first N primes", where 25000 reaches primes near 287,000 — is
ALSO computed, as a SECONDARY table, so the size of the difference is visible.  The
secondary table is not the replication; it is a contrast.

Note the original's docstring at line 128 ("5000 * 25000 * 8 = 1GB RAM") assumes
25000 COLUMNS, i.e. the count reading — but the code does the value reading.  That
mismatch is STATED here, not adjudicated.

The zero loader, quoted VERBATIM:

     89  def load_odlyzko_zeros(start, end, path="data/zeros/zeros1.txt"):
     90      if not os.path.exists(path):
     91          # Fallback Mock Data for dry run if file missing
     92          print(f"⚠️ Warning: {path} not found. Using Mock Data.")
     93          return np.linspace(14.13, 10000.0, end-start+1)
     94
     95      try:
     96          data = np.loadtxt(path)
     97      except OSError:
     98          return np.array([])
     99
    100      # Handle 1-col or 2-col format
    101      if data.ndim == 1:
    102          indices = np.arange(1, len(data) + 1)
    103          gammas = data
    104      else:
    105          indices = data[:, 0]
    106          gammas = data[:, 1]
    107
    108      mask = (indices >= start) & (indices <= end)
    109      return gammas[mask]

zeros1.txt is ONE column, so the `data.ndim == 1` branch fires and `indices` is
1..len(data).  The mask is on INDICES.  Therefore the windows (1, 5000) and
(5001, 10000) are by **zero INDEX**, not by height t.  Confirmed: index window
1-5000 spans t in [14.134725, 3778.320], index window 5001-10000 spans
t in [3778.837, 6820.052] — neither matches its own index numbers as heights.

A separate provenance note, STATED not adjudicated: the original's default path
"data/zeros/zeros1.txt" is RELATIVE, and the real file in that repo is at
primebeat/data/zeros/zeros1.txt.  Run from the wrong cwd, the original silently
falls through to `np.linspace` MOCK DATA (line 93) rather than erroring.  This
script takes an absolute path and has no mock fallback: if the zero file is missing
or fails Gate A, it exits.

=============================================================================
WHAT IS COMPUTED
=============================================================================

1. EXACT REPLICATION.  The original's control flow is mirrored precisely, including
   that `np.random.seed(2025)` is called ONCE before the WHOLE sweep (original line
   241, in __main__) rather than per cell — so the null draws depend on cell
   ordering.  Cells are iterated in the original's order: outer loop over
   prime_limits, inner loop over zero_windows.  The legacy `np.random.uniform`
   global RNG is used, not `default_rng`, because that is what the original used and
   the two do not produce the same stream.  Z is reported for all 8 cells
   (4 prime limits x 2 zero windows) beside the archived CSV values and beside the
   published values, with both differences.

2. SEED SENSITIVITY — the addition that matters.  The published table reports Z with
   NO uncertainty.  The full sweep is re-run for each seed in --seeds (default
   "2025,1,2,3,4,5,6,7,8,9") using `np.random.default_rng(seed)` per sweep, and per
   cell the mean / sd / min / max of Z across seeds is reported.  How much Z moves
   from the seed alone is then a stated number.

   NOTE: seed 2025 under `default_rng` is NOT the same stream as seed 2025 under the
   legacy `np.random.seed`, so the 2025 row of this table is not expected to equal
   the exact-replication row.  It is a different draw from the same null.

3. SCRAMBLE-COUNT SENSITIVITY.  At seed 2025 (legacy RNG, exact-replication control
   flow), Z is recomputed for each count in --scrambles-list (default "100,1000").
   Z's denominator is the sd of the null MEANS, which shrinks like 1/sqrt(scrambles)
   only in the ESTIMATE of that sd, not in the sd itself — the estimate merely gets
   tighter.  Both are reported and the change is stated.

4. A SECOND NULL, for contrast, NOT as the primary.  The phase-scramble null that
   the repo's own METHODOLOGY_AUDIT_AND_FIXES.md prescribes: draw one
   Uniform(0, 2pi) phase per prime, recompute |B| at the SAME true zeros, take the
   mean.  Same number of draws.

       B_phi(t) = sum_p p^(-1/2) * sin(t * log p + phi_p),  phi_p ~ U(0, 2pi) iid

   Z under this null is reported beside Z under the uniform-random-t null for all 8
   cells.  The script does NOT adjudicate between the two nulls.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================

On the EXACT REPLICATION at seed 2025, per cell, comparing to the ARCHIVED CSV
value:

    REPRO     |Z_ours - Z_csv| <  0.01
    CLOSE     0.01 <= |Z_ours - Z_csv| < 1.0
    DIVERGES  |Z_ours - Z_csv| >= 1.0

and SEPARATELY, comparing to the PUBLISHED value where one exists (6 of the 8
cells), the same three bands.  The band for every cell against both references is
reported, with a count of each.  Cells with no published value are recorded as
`n/a` against the published reference and are excluded from that count.

=============================================================================
GATES — all three RUN inside the script and recorded in the payload
=============================================================================

GATE A — ZERO FILE.  The zero file must have exactly 100000 lines and its first
three values must match 14.134725142, 21.022039639, 25.010857580 to 9 decimals.
Hard gate: the script exits if it fails.

GATE B — REAL MEAN IN RANGE.  For N=1000, zeros 1-5000, `real_mean` must be finite
and in the open interval (0, 5).  Printed.

GATE C — BEAT FORMULA.  |B| at t = 14.134725142 with the FIRST 100 PRIMES computed
two ways — a direct loop in pure Python (`math.sin`, `math.sqrt`) and the vectorized
matrix form used everywhere else — must agree to 1e-12.

=============================================================================
ENVELOPE
=============================================================================

House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows`.  `params.code_version` is the sha256 of THIS file read from
`__file__` at runtime.  `params.zeros_file_sha256` and `params.zeros_file_path` pin
the input.  `params.replicates_script` is the absolute path of the original being
replicated.

PERFORMANCE NOTE
----------------
The inner kernel is |sin(t[:, None] * log_p[None, :]) @ w|, exactly the original's
`prime_beat_vectorized`.  It is evaluated in ROW CHUNKS across a ThreadPoolExecutor
(numpy ufuncs release the GIL) purely to bound peak memory and to finish inside a
sane wall clock.  Rows are independent, so the result is bit-identical to the
single-threaded form; --threads 1 reproduces it serially.  All random draws are
generated in the original's loop order BEFORE any threading, so the RNG stream never
depends on thread scheduling.

REQUIREMENTS
------------
    numpy  (stdlib otherwise; matplotlib is NOT used)

USAGE
-----
    python3 O23_alignment_replication.py
    python3 O23_alignment_replication.py --scrambles-list 100 --seeds 2025 --no-json
"""

import argparse
import hashlib
import json
import math
import os
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone

try:
    import numpy as np
except ImportError:
    raise ImportError("numpy is required. Install with: pip install numpy")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")

# The script being replicated, and the archived CSV beside it. READ ONLY.
ORIGINAL_SCRIPT = ("/Users/juliansambrano/GitHub/primebeat/.archive/tests/suites/"
                   "extreme_alignment_logging.py")
ARCHIVED_CSV = ("/Users/juliansambrano/GitHub/primebeat/archived_results/runs/"
                "primebeat_extreme_alignment_20251220_022922/results_extreme.csv")
DEFAULT_ZEROS = ("/Users/juliansambrano/GitHub/primebeat/primebeat/data/zeros/"
                 "zeros1.txt")

# ---------------------------------------------------------------------------
# REFERENCE VALUES — both transcribed by hand, both fixed before the run.
# Keys are (prime_limit, "lo-hi") with the window by ZERO INDEX.
# ---------------------------------------------------------------------------

# The paper's headline table. Two of the eight cells have no published value.
PUBLISHED_Z = {
    (1000, "1-5000"): -10.71,
    (5000, "1-5000"): -16.03,
    (10000, "1-5000"): -16.96,
    (25000, "1-5000"): -17.61,
    (1000, "5001-10000"): -1.33,
    (5000, "5001-10000"): -12.04,
    (10000, "5001-10000"): None,
    (25000, "5001-10000"): None,
}

# results_extreme.csv from the 20251220_022922 run, Z_Score column, full precision.
ARCHIVED_CSV_Z = {
    (1000, "1-5000"): -10.714821757591816,
    (1000, "5001-10000"): -1.1440116188424918,
    (5000, "1-5000"): -16.548501058448654,
    (5000, "5001-10000"): -13.787042935244717,
    (10000, "1-5000"): -16.78319964630741,
    (10000, "5001-10000"): -15.556175080499855,
    (25000, "1-5000"): -19.846052128852612,
    (25000, "5001-10000"): -15.69570706638035,
}

# Gate A reference: the first three Odlyzko zeros, to the file's 9 decimals.
GATE_A_N_LINES = 100000
GATE_A_FIRST3 = (14.134725142, 21.022039639, 25.010857580)
GATE_A_TOL = 5e-10

# Gate B band on real_mean at N=1000, zeros 1-5000.
GATE_B_LO = 0.0
GATE_B_HI = 5.0

# Gate C: pure-python vs vectorized beat, first 100 primes at gamma_1.
GATE_C_T = 14.134725142
GATE_C_N_PRIMES = 100
GATE_C_TOL = 1e-12

# Pre-registered band thresholds on |Z_ours - Z_reference|.
BAND_REPRO = 0.01
BAND_CLOSE = 1.0

# Original's global seed, and the original's scramble count.
ORIGINAL_SEED = 2025
ORIGINAL_SCRAMBLES = 100

# Row-chunk cap for the threaded kernel: bounds peak memory at
# ROW_CHUNK_CAP * n_primes * 8 bytes per in-flight chunk.
ROW_CHUNK_CAP = 512


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _file_sha256(path):
    """sha256 of an arbitrary file; never raises."""
    try:
        h = hashlib.sha256()
        with open(path, "rb") as fh:
            for block in iter(lambda: fh.read(1 << 20), b""):
                h.update(block)
        return h.hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _file_size(path):
    """Byte size of a file; None when unavailable."""
    try:
        return int(os.path.getsize(path))
    except Exception:
        return None


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


def _fmt(v, w=12, p=4, dash="—"):
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


# ---------------------------------------------------------------------------
# PRIMES — both conventions
# ---------------------------------------------------------------------------

def build_primes_up_to(N_max):
    """
    VERBATIM port of the original's `build_primes_up_to` (lines 111-121 of
    extreme_alignment_logging.py): a VALUE sieve. N_max is a VALUE bound, so this
    returns every prime <= N_max. This is the PRIMARY convention.
    """
    N_max = int(N_max)
    sieve = np.ones(N_max + 1, dtype=bool)
    sieve[:2] = False
    for i in range(2, int(np.sqrt(N_max)) + 1):
        if sieve[i]:
            sieve[i * i:N_max + 1:i] = False
    primes = np.nonzero(sieve)[0]
    log_p = np.log(primes)
    weights = primes ** -0.5
    return primes, log_p, weights


def build_first_n_primes(n):
    """
    The OTHER reading of `prime_limits`: the FIRST n primes. Secondary convention,
    computed for contrast only. Sieve limit from the standard n log(n log n) bound
    with slack, grown until enough primes are found.
    """
    n = int(n)
    if n < 1:
        raise SystemExit(f"--prime-limits: {n} is not a valid prime count")
    if n < 6:
        limit = 15
    else:
        limit = int(n * (math.log(n) + math.log(math.log(n)))) + 10
    while True:
        s = np.ones(limit + 1, dtype=bool)
        s[:2] = False
        for i in range(2, int(limit ** 0.5) + 1):
            if s[i]:
                s[i * i::i] = False
        primes = np.flatnonzero(s)
        if primes.size >= n:
            primes = primes[:n].astype(np.int64)
            break
        limit *= 2
    log_p = np.log(primes.astype(np.float64))
    weights = primes.astype(np.float64) ** -0.5
    return primes, log_p, weights


# ---------------------------------------------------------------------------
# ZEROS
# ---------------------------------------------------------------------------

def load_zeros_all(path):
    """
    Load the whole zero file once. Mirrors the original's loader for the ndim == 1
    branch (its lines 100-106), which is the branch zeros1.txt takes: one column, so
    indices are 1..len(data) and the mask is by INDEX. No mock-data fallback here:
    a missing file is an error, not a silent linspace.
    """
    if not os.path.exists(path):
        raise SystemExit(f"zeros file not found: {path}")
    data = np.loadtxt(path)
    if data.ndim != 1:
        raise SystemExit(
            f"zeros file {path} has ndim={data.ndim}; this script and its Gate A "
            "assume the one-column form that the original's ndim==1 branch takes")
    return data


def window_zeros(all_zeros, start, end):
    """Zeros with INDEX in [start, end], 1-based — the original's mask semantics."""
    idx = np.arange(1, all_zeros.size + 1)
    return all_zeros[(idx >= start) & (idx <= end)]


# ---------------------------------------------------------------------------
# THE BEAT KERNEL
# ---------------------------------------------------------------------------

def prime_beat_vectorized(t_array, log_p, weights):
    """
    VERBATIM port of the original's kernel (its lines 123-134):

        arg = t[:, None] * log_p[None, :]
        val = np.sin(arg) @ weights
        return np.abs(val)
    """
    t_array = np.atleast_1d(np.asarray(t_array, dtype=np.float64))
    arg = t_array[:, None] * log_p[None, :]
    val = np.sin(arg) @ weights
    return np.abs(val)


def _n_chunks(n_rows, threads):
    """Chunk count: at least `threads`, and enough to keep chunks <= ROW_CHUNK_CAP."""
    by_mem = int(math.ceil(n_rows / float(ROW_CHUNK_CAP))) if n_rows else 1
    return max(1, max(int(threads), by_mem))


def mean_abs_beat(t_array, log_p, weights, pool, threads, phases=None):
    """
    mean(|B(t)|) over t_array, in row chunks.

    Rows are independent, so chunking is bit-identical to the whole-matrix form and
    to --threads 1; it exists to bound peak memory and wall clock. `phases`, when
    given, is one phase per prime and the kernel becomes
    sin(t log p + phi_p) — the phase-scramble null.
    """
    t_array = np.atleast_1d(np.asarray(t_array, dtype=np.float64))
    n = int(t_array.size)
    if n == 0:
        return float("nan")
    parts = np.array_split(t_array, _n_chunks(n, threads))

    def work(sub):
        arg = sub[:, None] * log_p[None, :]
        if phases is not None:
            arg = arg + phases[None, :]
        return np.abs(np.sin(arg) @ weights).sum()

    if pool is None or len(parts) == 1:
        total = sum(work(p) for p in parts)
    else:
        total = sum(pool.map(work, parts))
    return float(total / n)


def beat_pure_python(t, primes):
    """
    Gate C's independent implementation: a direct loop in pure Python, no numpy.
    |sum_p p^(-1/2) sin(t log p)|.
    """
    s = 0.0
    for p in primes:
        s += math.sin(t * math.log(float(p))) / math.sqrt(float(p))
    return abs(s)


# ---------------------------------------------------------------------------
# THE STATISTIC
# ---------------------------------------------------------------------------

def z_from_means(real_mean, scr_means):
    """
    Z = (real_mean - mean(scr_means)) / std(scr_means, ddof=1).

    The original returns 0 when the sd is exactly zero (its line 186). That branch
    is preserved so the replication is exact, but it is also FLAGGED in the row so a
    degenerate 0 is never mistaken for a measured 0.
    """
    a = np.asarray(scr_means, dtype=np.float64)
    scr_mean_total = float(np.mean(a))
    scr_std = float(np.std(a, ddof=1)) if a.size > 1 else 0.0
    degenerate = (scr_std == 0.0)
    z = 0.0 if degenerate else (float(real_mean) - scr_mean_total) / scr_std
    return z, scr_mean_total, scr_std, degenerate


def band_for(z_ours, z_ref):
    """
    Mechanical application of the pre-registered bands.

        REPRO     |diff| <  0.01
        CLOSE     0.01 <= |diff| < 1.0
        DIVERGES  |diff| >= 1.0

    Returns (band, diff). ("n/a", None) when the reference does not exist.
    """
    if z_ref is None:
        return "n/a", None
    try:
        d = float(z_ours) - float(z_ref)
    except (TypeError, ValueError):
        return "n/a", None
    if not math.isfinite(d):
        return "n/a", None
    a = abs(d)
    if a < BAND_REPRO:
        return "REPRO", d
    if a < BAND_CLOSE:
        return "CLOSE", d
    return "DIVERGES", d


def parse_int_list(s, flag):
    """Comma-separated integers -> list of ints."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        try:
            out.append(int(tok))
        except ValueError:
            raise SystemExit(f"{flag}: '{tok}' is not an integer")
    if not out:
        raise SystemExit(f"{flag} is empty")
    return out


def parse_windows(s):
    """'1-5000,5001-10000' -> [(1, 5000), (5001, 10000)], windows by ZERO INDEX."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        if "-" not in tok:
            raise SystemExit(f"--windows: '{tok}' is not of the form lo-hi")
        lo_s, hi_s = tok.split("-", 1)
        try:
            lo, hi = int(lo_s), int(hi_s)
        except ValueError:
            raise SystemExit(f"--windows: '{tok}' is not of the form lo-hi")
        if lo < 1 or hi < lo:
            raise SystemExit(f"--windows: '{tok}' must satisfy 1 <= lo <= hi")
        out.append((lo, hi))
    if not out:
        raise SystemExit("--windows is empty")
    return out


def wlabel(lo, hi):
    """Canonical window key, matching the reference-table keys."""
    return f"{lo}-{hi}"


# ---------------------------------------------------------------------------
# SWEEPS
# ---------------------------------------------------------------------------

def run_sweep(all_zeros, prime_limits, windows, scrambles, builder, draw_uniform,
              pool, threads, label):
    """
    ONE full sweep over (prime_limit x window) in the ORIGINAL'S ORDER: outer loop
    over prime_limits, inner loop over windows.

    `draw_uniform(lo, hi, size)` supplies the null draws. It is a closure over
    whichever RNG the caller wants, and it is called in exactly the original's order
    and count, so the stream's dependence on cell ordering is preserved.
    """
    rows = []
    for nmax in prime_limits:
        primes, log_p, weights = builder(nmax)
        for (z1, z2) in windows:
            zeros = window_zeros(all_zeros, z1, z2)
            if zeros.size == 0:
                print(f"   [!] {label} N={nmax} {wlabel(z1, z2)}: no zeros, "
                      f"skipped", flush=True)
                continue
            real_mean = mean_abs_beat(zeros, log_p, weights, pool, threads)
            lo = float(zeros.min())
            hi = float(zeros.max())
            scr_means = []
            for _ in range(int(scrambles)):
                t_rnd = draw_uniform(lo, hi, int(zeros.size))
                scr_means.append(
                    mean_abs_beat(t_rnd, log_p, weights, pool, threads))
            z, scr_mean_total, scr_std, degenerate = z_from_means(
                real_mean, scr_means)
            rows.append({
                "label": label,
                "prime_limit": int(nmax),
                "n_primes": int(primes.size),
                "largest_prime": int(primes[-1]) if primes.size else None,
                "window": wlabel(z1, z2),
                "window_start_index": int(z1),
                "window_end_index": int(z2),
                "n_zeros": int(zeros.size),
                "t_min": lo,
                "t_max": hi,
                "scrambles": int(scrambles),
                "real_mean": real_mean,
                "scr_mean": scr_mean_total,
                "scr_std": scr_std,
                "z": z,
                "z_denominator_degenerate": bool(degenerate),
            })
            print(f"   {label:<22} N={nmax:<6} {wlabel(z1, z2):<11} "
                  f"np={primes.size:<6} real={real_mean:.6f} "
                  f"scr={scr_mean_total:.6f} Z={z:+.4f}", flush=True)
    return rows


def run_phase_sweep(all_zeros, prime_limits, windows, draws, builder, rng, pool,
                    threads, label):
    """
    The SECOND null, for contrast: one Uniform(0, 2pi) phase per prime, |B| at the
    SAME true zeros, mean over zeros. `real_mean` is unchanged from the primary
    sweep by construction — it is the same quantity — so only the null moves.
    """
    rows = []
    for nmax in prime_limits:
        primes, log_p, weights = builder(nmax)
        for (z1, z2) in windows:
            zeros = window_zeros(all_zeros, z1, z2)
            if zeros.size == 0:
                continue
            real_mean = mean_abs_beat(zeros, log_p, weights, pool, threads)
            scr_means = []
            for _ in range(int(draws)):
                phi = rng.uniform(0.0, 2.0 * math.pi, size=int(log_p.size))
                scr_means.append(
                    mean_abs_beat(zeros, log_p, weights, pool, threads,
                                  phases=phi))
            z, scr_mean_total, scr_std, degenerate = z_from_means(
                real_mean, scr_means)
            rows.append({
                "label": label,
                "prime_limit": int(nmax),
                "n_primes": int(primes.size),
                "window": wlabel(z1, z2),
                "n_zeros": int(zeros.size),
                "draws": int(draws),
                "real_mean": real_mean,
                "scr_mean": scr_mean_total,
                "scr_std": scr_std,
                "z": z,
                "z_denominator_degenerate": bool(degenerate),
            })
            print(f"   {label:<22} N={nmax:<6} {wlabel(z1, z2):<11} "
                  f"real={real_mean:.6f} scr={scr_mean_total:.6f} "
                  f"Z={z:+.4f}", flush=True)
    return rows


def main():
    ap = argparse.ArgumentParser(
        description="O23 — replicate the Prime Beat extreme-alignment "
                    "mean-amplitude Z statistic and measure its seed, "
                    "scramble-count and null sensitivity")
    ap.add_argument("--zeros-file", type=str, default=DEFAULT_ZEROS,
                    help=f"Odlyzko zero heights, one per line "
                         f"(default {DEFAULT_ZEROS}; READ ONLY)")
    ap.add_argument("--prime-limits", type=str, default="1000,5000,10000,25000",
                    help="comma-separated prime limits (default "
                         "'1000,5000,10000,25000'); PRIMARY convention is a "
                         "VALUE bound, per the original's sieve")
    ap.add_argument("--windows", type=str, default="1-5000,5001-10000",
                    help="comma-separated zero windows by ZERO INDEX "
                         "(default '1-5000,5001-10000')")
    ap.add_argument("--scrambles", type=int, default=ORIGINAL_SCRAMBLES,
                    help=f"scrambles for the exact replication and the seed "
                         f"sweep (default {ORIGINAL_SCRAMBLES})")
    ap.add_argument("--scrambles-list", type=str, default="100,1000",
                    help="comma-separated scramble counts for the "
                         "scramble-count sensitivity table (default '100,1000')")
    ap.add_argument("--seeds", type=str, default="2025,1,2,3,4,5,6,7,8,9",
                    help="comma-separated seeds for the seed-sensitivity sweep "
                         "(default '2025,1,2,3,4,5,6,7,8,9')")
    ap.add_argument("--threads", type=int, default=min(8, os.cpu_count() or 1),
                    help="row-chunk worker threads for the beat kernel; results "
                         "are bit-identical to --threads 1 (default min(8, cpus))")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    prime_limits = parse_int_list(args.prime_limits, "--prime-limits")
    windows = parse_windows(args.windows)
    scrambles_list = parse_int_list(args.scrambles_list, "--scrambles-list")
    seeds = parse_int_list(args.seeds, "--seeds")
    threads = max(1, int(args.threads))
    out_path = args.out or DEFAULT_OUT
    zeros_path = os.path.abspath(args.zeros_file)

    print("=" * 78, flush=True)
    print("O23 — alignment replication  (mean-amplitude statistic, NOT a minima "
          "statistic)", flush=True)
    print("=" * 78, flush=True)
    print("  B_N(t)    = sum_p p^(-1/2) sin(t log p)", flush=True)
    print("  real_mean = mean(|B_N| at the true zeros)", flush=True)
    print("  scr_mean  = mean(|B_N| at t ~ U(zeros.min(), zeros.max()))", flush=True)
    print("  Z         = (real_mean - mean(scr_means)) / std(scr_means, ddof=1)",
          flush=True)
    print("", flush=True)
    print(f"  replicating : {ORIGINAL_SCRIPT}", flush=True)
    print(f"  archived CSV: {ARCHIVED_CSV}", flush=True)
    print("  O10 is a DELIBERATE GAP in this series and is not filled here.",
          flush=True)

    # ---------------- step 0: the convention, resolved from source -----------
    print("\n" + "-" * 78, flush=True)
    print("STEP 0 — prime_limits: VALUE bound or COUNT?", flush=True)
    print("-" * 78, flush=True)
    print("  The original's build_primes_up_to (its lines 111-121) sieves an array "
          "of length", flush=True)
    print("  N_max+1 and returns np.nonzero(sieve)[0] — the surviving INDICES, i.e. "
          "the prime", flush=True)
    print("  VALUES <= N_max. No truncation to a count anywhere. Therefore "
          "prime_limits is a", flush=True)
    print("  VALUE BOUND. PRIMARY convention here = 'value'.", flush=True)
    print("  The COUNT reading is ALSO computed, as a SECONDARY contrast table.",
          flush=True)
    print("  (The original's own comment at its line 128 assumes 25000 COLUMNS, "
          "i.e. the COUNT", flush=True)
    print("   reading, while its code does the VALUE reading. Stated, not "
          "adjudicated.)", flush=True)
    print("\n  Windows: the original masks on INDICES built as "
          "np.arange(1, len(data)+1)", flush=True)
    print("  (its lines 100-109), and zeros1.txt is one column, so the windows are "
          "by ZERO", flush=True)
    print("  INDEX, not by height t.", flush=True)

    # ---------------- gate A -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — zero file", flush=True)
    print("-" * 78, flush=True)
    zeros_sha = _file_sha256(zeros_path)
    zeros_size = _file_size(zeros_path)
    all_zeros = load_zeros_all(zeros_path)
    n_lines = int(all_zeros.size)
    first3 = [float(v) for v in all_zeros[:3]] if n_lines >= 3 else []
    lines_ok = (n_lines == GATE_A_N_LINES)
    first3_ok = (len(first3) == 3 and
                 all(abs(first3[i] - GATE_A_FIRST3[i]) <= GATE_A_TOL
                     for i in range(3)))
    gate_a_passed = bool(lines_ok and first3_ok)
    print(f"  path   : {zeros_path}", flush=True)
    print(f"  size   : {zeros_size} bytes", flush=True)
    print(f"  sha256 : {zeros_sha}", flush=True)
    print(f"  lines  : {n_lines}  (expected {GATE_A_N_LINES})  -> "
          f"{'PASS' if lines_ok else 'FAIL'}", flush=True)
    print(f"  first3 : {first3}", flush=True)
    print(f"           expected {list(GATE_A_FIRST3)} to 9 decimals -> "
          f"{'PASS' if first3_ok else 'FAIL'}", flush=True)
    print(f"  GATE A : {'PASS' if gate_a_passed else 'FAIL'}", flush=True)
    if not gate_a_passed:
        raise SystemExit("GATE A failed — refusing to run on an unverified zero "
                         "file.")

    # ---------------- gate C -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE C — beat formula: pure-python loop vs vectorized matrix", flush=True)
    print("-" * 78, flush=True)
    p100, lp100, w100 = build_first_n_primes(GATE_C_N_PRIMES)
    gate_c_loop = beat_pure_python(GATE_C_T, [int(v) for v in p100])
    gate_c_vec = float(prime_beat_vectorized(np.array([GATE_C_T]), lp100, w100)[0])
    gate_c_diff = abs(gate_c_loop - gate_c_vec)
    gate_c_passed = bool(gate_c_diff <= GATE_C_TOL)
    print(f"  t = {GATE_C_T!r}, first {GATE_C_N_PRIMES} primes "
          f"(2 .. {int(p100[-1])})", flush=True)
    print(f"  pure-python loop : {gate_c_loop!r}", flush=True)
    print(f"  vectorized matrix: {gate_c_vec!r}", flush=True)
    print(f"  |difference|     : {gate_c_diff:.3e}   (tol {GATE_C_TOL:g})",
          flush=True)
    print(f"  GATE C : {'PASS' if gate_c_passed else 'FAIL'}", flush=True)

    pool = ThreadPoolExecutor(max_workers=threads) if threads > 1 else None
    t_wall0 = datetime.now(timezone.utc)

    try:
        # ------------- 1. EXACT REPLICATION -------------------------------
        print("\n" + "-" * 78, flush=True)
        print("1. EXACT REPLICATION — legacy np.random.seed(2025) ONCE before the "
              "WHOLE sweep", flush=True)
        print("-" * 78, flush=True)
        print("  The seed is set once (original line 241, in __main__), not per "
              "cell, so the", flush=True)
        print("  null draws depend on cell ordering. Cells run in the original's "
              "order: outer", flush=True)
        print("  loop prime_limits, inner loop zero_windows.", flush=True)
        print("", flush=True)
        np.random.seed(ORIGINAL_SEED)

        def legacy_draw(lo, hi, size):
            return np.random.uniform(lo, hi, size=size)

        exact_rows = run_sweep(all_zeros, prime_limits, windows, int(args.scrambles),
                               build_primes_up_to, legacy_draw, pool, threads,
                               "exact/value/2025")
        exact_by_cell = {(r["prime_limit"], r["window"]): r for r in exact_rows}

        # ------------- gate B ---------------------------------------------
        gate_b_key = (prime_limits[0], wlabel(*windows[0]))
        gb = exact_by_cell.get(gate_b_key)
        gate_b_real = gb["real_mean"] if gb else None
        gate_b_passed = bool(
            gate_b_real is not None and math.isfinite(gate_b_real) and
            GATE_B_LO < gate_b_real < GATE_B_HI)
        print("\n" + "-" * 78, flush=True)
        print("GATE B — real_mean at N=1000, zeros 1-5000 finite and in (0, 5)",
              flush=True)
        print("-" * 78, flush=True)
        print(f"  cell      : N={gate_b_key[0]}, zeros {gate_b_key[1]}", flush=True)
        print(f"  real_mean : {gate_b_real!r}", flush=True)
        print(f"  GATE B    : {'PASS' if gate_b_passed else 'FAIL'}", flush=True)

        # ------------- pre-registered bands --------------------------------
        print("\n" + "-" * 78, flush=True)
        print("REPLICATION TABLE — Z here vs archived CSV vs published, with the "
              "pre-registered", flush=True)
        print("band applied mechanically to each  (REPRO <0.01, CLOSE <1.0, "
              "DIVERGES >=1.0)", flush=True)
        print("-" * 78, flush=True)
        hdr = (f"  {'N':>6} {'window':>11} {'n_p':>6} {'real':>10} {'scr':>10} "
               f"{'Z_ours':>10} {'Z_csv':>10} {'d_csv':>9} {'band_csv':>9} "
               f"{'Z_pub':>8} {'d_pub':>9} {'band_pub':>9}")
        print(hdr, flush=True)
        band_rows = []
        counts_csv = {"REPRO": 0, "CLOSE": 0, "DIVERGES": 0, "n/a": 0}
        counts_pub = {"REPRO": 0, "CLOSE": 0, "DIVERGES": 0, "n/a": 0}
        for r in exact_rows:
            key = (r["prime_limit"], r["window"])
            z_csv = ARCHIVED_CSV_Z.get(key)
            z_pub = PUBLISHED_Z.get(key)
            b_csv, d_csv = band_for(r["z"], z_csv)
            b_pub, d_pub = band_for(r["z"], z_pub)
            counts_csv[b_csv] = counts_csv.get(b_csv, 0) + 1
            counts_pub[b_pub] = counts_pub.get(b_pub, 0) + 1
            band_rows.append({
                "prime_limit": r["prime_limit"], "window": r["window"],
                "n_primes": r["n_primes"], "z_ours": r["z"],
                "z_archived_csv": z_csv, "diff_vs_csv": d_csv, "band_vs_csv": b_csv,
                "z_published": z_pub, "diff_vs_published": d_pub,
                "band_vs_published": b_pub,
            })
            print(f"  {r['prime_limit']:>6} {r['window']:>11} {r['n_primes']:>6} "
                  f"{_fmt(r['real_mean'], 10, 6)} {_fmt(r['scr_mean'], 10, 6)} "
                  f"{_fmt(r['z'], 10, 4)} {_fmt(z_csv, 10, 4)} "
                  f"{_fmt(d_csv, 9, 4)} {b_csv:>9} {_fmt(z_pub, 8, 2)} "
                  f"{_fmt(d_pub, 9, 4)} {b_pub:>9}", flush=True)
        print(f"\n  band counts vs ARCHIVED CSV : "
              f"REPRO={counts_csv['REPRO']}  CLOSE={counts_csv['CLOSE']}  "
              f"DIVERGES={counts_csv['DIVERGES']}  n/a={counts_csv['n/a']}",
              flush=True)
        print(f"  band counts vs PUBLISHED    : "
              f"REPRO={counts_pub['REPRO']}  CLOSE={counts_pub['CLOSE']}  "
              f"DIVERGES={counts_pub['DIVERGES']}  n/a={counts_pub['n/a']}"
              f"   (n/a = no published value for that cell)", flush=True)

        # ------------- secondary convention --------------------------------
        print("\n" + "-" * 78, flush=True)
        print("SECONDARY CONVENTION — prime_limits read as a COUNT (first N "
              "primes), for contrast", flush=True)
        print("-" * 78, flush=True)
        print("  NOT the replication. Shown so the size of the ambiguity is "
              "visible.", flush=True)
        print("", flush=True)
        np.random.seed(ORIGINAL_SEED)
        count_rows = run_sweep(all_zeros, prime_limits, windows,
                               int(args.scrambles), build_first_n_primes,
                               legacy_draw, pool, threads, "count/2025")
        count_by_cell = {(r["prime_limit"], r["window"]): r for r in count_rows}
        print(f"\n  {'N':>6} {'window':>11} {'n_p(value)':>11} "
              f"{'Z(value)':>10} {'n_p(count)':>11} {'Z(count)':>10} "
              f"{'Z_count-Z_value':>17}", flush=True)
        convention_rows = []
        for r in exact_rows:
            key = (r["prime_limit"], r["window"])
            c = count_by_cell.get(key)
            zc = c["z"] if c else None
            dz = (zc - r["z"]) if zc is not None else None
            convention_rows.append({
                "prime_limit": r["prime_limit"], "window": r["window"],
                "n_primes_value": r["n_primes"],
                "largest_prime_value": r["largest_prime"],
                "z_value": r["z"],
                "n_primes_count": c["n_primes"] if c else None,
                "largest_prime_count": c["largest_prime"] if c else None,
                "z_count": zc, "z_count_minus_z_value": dz,
            })
            print(f"  {r['prime_limit']:>6} {r['window']:>11} "
                  f"{r['n_primes']:>11} {_fmt(r['z'], 10, 4)} "
                  f"{(c['n_primes'] if c else 0):>11} {_fmt(zc, 10, 4)} "
                  f"{_fmt(dz, 17, 4)}", flush=True)

        # ------------- 2. SEED SENSITIVITY ---------------------------------
        print("\n" + "-" * 78, flush=True)
        print(f"2. SEED SENSITIVITY — full sweep re-run for each of "
              f"{len(seeds)} seeds", flush=True)
        print("-" * 78, flush=True)
        print("  np.random.default_rng(seed) per sweep, VALUE convention, "
              f"{args.scrambles} scrambles.", flush=True)
        print("  NOTE: default_rng(2025) is NOT the legacy np.random.seed(2025) "
              "stream, so the", flush=True)
        print("  2025 row here is a different draw from the same null, not the "
              "exact-replication row.", flush=True)
        print("", flush=True)
        seed_rows = []
        per_cell_z = {}
        for sd in seeds:
            rng = np.random.default_rng(int(sd))

            def rng_draw(lo, hi, size, _r=rng):
                return _r.uniform(lo, hi, size=size)

            rows_sd = run_sweep(all_zeros, prime_limits, windows,
                                int(args.scrambles), build_primes_up_to, rng_draw,
                                pool, threads, f"seed/value/{sd}")
            for r in rows_sd:
                r["seed"] = int(sd)
                per_cell_z.setdefault((r["prime_limit"], r["window"]), []).append(
                    (int(sd), r["z"]))
            seed_rows.extend(rows_sd)

        print(f"\n  {'N':>6} {'window':>11} {'n_seeds':>8} {'mean_Z':>11} "
              f"{'sd_Z':>10} {'min_Z':>11} {'max_Z':>11} {'range_Z':>10} "
              f"{'Z_exact2025':>12}", flush=True)
        seed_summary = []
        for r in exact_rows:
            key = (r["prime_limit"], r["window"])
            zs = [z for _, z in per_cell_z.get(key, [])]
            a = np.asarray(zs, dtype=np.float64)
            if a.size:
                mn, sd_ = float(np.mean(a)), (float(np.std(a, ddof=1))
                                              if a.size > 1 else float("nan"))
                lo_, hi_ = float(np.min(a)), float(np.max(a))
                rng_ = hi_ - lo_
            else:
                mn = sd_ = lo_ = hi_ = rng_ = float("nan")
            seed_summary.append({
                "prime_limit": key[0], "window": key[1], "n_seeds": int(a.size),
                "mean_z": mn, "sd_z": sd_, "min_z": lo_, "max_z": hi_,
                "range_z": rng_, "z_exact_replication_2025": r["z"],
                "per_seed": [{"seed": s, "z": z}
                             for s, z in per_cell_z.get(key, [])],
            })
            print(f"  {key[0]:>6} {key[1]:>11} {int(a.size):>8} "
                  f"{_fmt(mn, 11, 4)} {_fmt(sd_, 10, 4)} {_fmt(lo_, 11, 4)} "
                  f"{_fmt(hi_, 11, 4)} {_fmt(rng_, 10, 4)} "
                  f"{_fmt(r['z'], 12, 4)}", flush=True)

        sd_all = [s["sd_z"] for s in seed_summary
                  if s["sd_z"] is not None and math.isfinite(s["sd_z"])]
        rg_all = [s["range_z"] for s in seed_summary
                  if s["range_z"] is not None and math.isfinite(s["range_z"])]
        seed_movement = {
            "n_cells": len(seed_summary),
            "n_seeds": len(seeds),
            "sd_z_min": min(sd_all) if sd_all else None,
            "sd_z_max": max(sd_all) if sd_all else None,
            "sd_z_median": float(np.median(sd_all)) if sd_all else None,
            "range_z_min": min(rg_all) if rg_all else None,
            "range_z_max": max(rg_all) if rg_all else None,
            "range_z_median": float(np.median(rg_all)) if rg_all else None,
        }
        print(f"\n  HOW MUCH Z MOVES FROM SEED ALONE, across the "
              f"{len(seed_summary)} cells:", flush=True)
        print(f"    sd(Z)    over seeds : min {_fmt(seed_movement['sd_z_min'],1,4)} "
              f" median {_fmt(seed_movement['sd_z_median'],1,4)} "
              f" max {_fmt(seed_movement['sd_z_max'],1,4)}", flush=True)
        print(f"    max-min  over seeds : min {_fmt(seed_movement['range_z_min'],1,4)}"
              f"  median {_fmt(seed_movement['range_z_median'],1,4)}"
              f"  max {_fmt(seed_movement['range_z_max'],1,4)}", flush=True)
        print("  Stated as measured. Interpretation is not this script's job.",
              flush=True)

        # ------------- 3. SCRAMBLE-COUNT SENSITIVITY -----------------------
        print("\n" + "-" * 78, flush=True)
        print(f"3. SCRAMBLE-COUNT SENSITIVITY — seed {ORIGINAL_SEED} (legacy RNG), "
              f"counts {scrambles_list}", flush=True)
        print("-" * 78, flush=True)
        scr_by_count = {}
        for sc in scrambles_list:
            np.random.seed(ORIGINAL_SEED)
            rows_sc = run_sweep(all_zeros, prime_limits, windows, int(sc),
                                build_primes_up_to, legacy_draw, pool, threads,
                                f"scr{sc}/value/2025")
            for r in rows_sc:
                scr_by_count.setdefault(int(sc), {})[
                    (r["prime_limit"], r["window"])] = r

        print(f"\n  {'N':>6} {'window':>11}", end="", flush=True)
        for sc in scrambles_list:
            print(f" {('Z@' + str(sc)):>12} {('sd_scr@' + str(sc)):>14}",
                  end="", flush=True)
        print(f" {'Z_last-Z_first':>15}", flush=True)
        scramble_summary = []
        for r in exact_rows:
            key = (r["prime_limit"], r["window"])
            entry = {"prime_limit": key[0], "window": key[1], "by_count": []}
            print(f"  {key[0]:>6} {key[1]:>11}", end="", flush=True)
            zs = []
            for sc in scrambles_list:
                rr = scr_by_count.get(int(sc), {}).get(key)
                zz = rr["z"] if rr else None
                ss = rr["scr_std"] if rr else None
                zs.append(zz)
                entry["by_count"].append({
                    "scrambles": int(sc), "z": zz, "scr_std": ss,
                    "scr_mean": rr["scr_mean"] if rr else None,
                    "real_mean": rr["real_mean"] if rr else None})
                print(f" {_fmt(zz, 12, 4)} {_fmt(ss, 14, 8)}", end="", flush=True)
            dz = (zs[-1] - zs[0]) if (len(zs) > 1 and zs[0] is not None
                                      and zs[-1] is not None) else None
            entry["z_last_minus_z_first"] = dz
            scramble_summary.append(entry)
            print(f" {_fmt(dz, 15, 4)}", flush=True)
        sc_shifts = [abs(e["z_last_minus_z_first"]) for e in scramble_summary
                     if e["z_last_minus_z_first"] is not None]
        scramble_movement = {
            "counts": [int(s) for s in scrambles_list],
            "abs_shift_min": min(sc_shifts) if sc_shifts else None,
            "abs_shift_max": max(sc_shifts) if sc_shifts else None,
            "abs_shift_median": (float(np.median(sc_shifts)) if sc_shifts
                                 else None),
        }
        print(f"\n  |Z change| from {scrambles_list[0]} to {scrambles_list[-1]} "
              f"scrambles: min {_fmt(scramble_movement['abs_shift_min'],1,4)}"
              f"  median {_fmt(scramble_movement['abs_shift_median'],1,4)}"
              f"  max {_fmt(scramble_movement['abs_shift_max'],1,4)}", flush=True)

        # ------------- 4. SECOND NULL --------------------------------------
        print("\n" + "-" * 78, flush=True)
        print("4. SECOND NULL (contrast, NOT primary) — phase scramble: one "
              "U(0,2pi) phase per", flush=True)
        print("   prime, |B| at the SAME true zeros. "
              "METHODOLOGY_AUDIT_AND_FIXES.md's prescription.", flush=True)
        print("-" * 78, flush=True)
        phase_rng = np.random.default_rng(ORIGINAL_SEED)
        phase_rows = run_phase_sweep(all_zeros, prime_limits, windows,
                                     int(args.scrambles), build_primes_up_to,
                                     phase_rng, pool, threads, "phase/value/2025")
        phase_by_cell = {(r["prime_limit"], r["window"]): r for r in phase_rows}
        print(f"\n  {'N':>6} {'window':>11} {'Z_uniform_t':>12} {'Z_phase':>12} "
              f"{'Z_phase-Z_unif':>15} {'scr_mean_unif':>14} "
              f"{'scr_mean_phase':>15}", flush=True)
        null_rows = []
        for r in exact_rows:
            key = (r["prime_limit"], r["window"])
            p = phase_by_cell.get(key)
            zp = p["z"] if p else None
            dz = (zp - r["z"]) if zp is not None else None
            null_rows.append({
                "prime_limit": key[0], "window": key[1],
                "z_uniform_t_null": r["z"], "z_phase_null": zp,
                "z_phase_minus_z_uniform": dz,
                "scr_mean_uniform_t": r["scr_mean"],
                "scr_mean_phase": p["scr_mean"] if p else None,
                "scr_std_uniform_t": r["scr_std"],
                "scr_std_phase": p["scr_std"] if p else None,
                "real_mean": r["real_mean"],
            })
            print(f"  {key[0]:>6} {key[1]:>11} {_fmt(r['z'], 12, 4)} "
                  f"{_fmt(zp, 12, 4)} {_fmt(dz, 15, 4)} "
                  f"{_fmt(r['scr_mean'], 14, 6)} "
                  f"{_fmt(p['scr_mean'] if p else None, 15, 6)}", flush=True)
        print("\n  The two nulls are REPORTED side by side. The script does NOT "
              "adjudicate between", flush=True)
        print("  them; that is not its job.", flush=True)

    finally:
        if pool is not None:
            pool.shutdown(wait=True)

    t_wall1 = datetime.now(timezone.utc)
    elapsed = (t_wall1 - t_wall0).total_seconds()
    print(f"\n  compute wall clock: {elapsed:.1f} s", flush=True)

    print("\n" + "=" * 78, flush=True)
    print("GATE SUMMARY", flush=True)
    print("=" * 78, flush=True)
    print(f"  GATE A (zero file 100000 lines + first three to 9 dp) : "
          f"{'PASS' if gate_a_passed else 'FAIL'}", flush=True)
    print(f"  GATE B (real_mean N=1000 zeros 1-5000 finite in (0,5)): "
          f"{'PASS' if gate_b_passed else 'FAIL'}  "
          f"(real_mean = {gate_b_real!r})", flush=True)
    print(f"  GATE C (pure-python vs vectorized beat, tol 1e-12)    : "
          f"{'PASS' if gate_c_passed else 'FAIL'}  "
          f"(|diff| = {gate_c_diff:.3e})", flush=True)

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "params": {
                "code_version": _code_version(),
                "zeros_file_path": zeros_path,
                "zeros_file_sha256": zeros_sha,
                "zeros_file_size_bytes": zeros_size,
                "zeros_file_lines": n_lines,
                "replicates_script": ORIGINAL_SCRIPT,
                "archived_csv": ARCHIVED_CSV,
                "prime_limits": prime_limits,
                "prime_limit_convention": "value",
                "prime_limit_convention_note": (
                    "PRIMARY = 'value': the original's build_primes_up_to (its "
                    "lines 111-121) sieves an array of length N_max+1 and returns "
                    "np.nonzero(sieve)[0], the prime VALUES <= N_max, with no "
                    "truncation to a count. The COUNT reading (first N primes) is "
                    "computed as a SECONDARY contrast table only. The original's "
                    "own comment at its line 128 assumes the COUNT reading while "
                    "its code does the VALUE reading; stated, not adjudicated"),
                "windows": [wlabel(a, b) for a, b in windows],
                "window_convention": "zero_index",
                "window_convention_note": (
                    "the original masks on indices built as "
                    "np.arange(1, len(data)+1) (its lines 100-109) and zeros1.txt "
                    "is one column, so the windows are by ZERO INDEX, not by "
                    "height t"),
                "scrambles": int(args.scrambles),
                "scrambles_list": [int(s) for s in scrambles_list],
                "seeds": [int(s) for s in seeds],
                "exact_replication_rng": (
                    "legacy np.random.seed(2025) called ONCE before the whole "
                    "sweep, then np.random.uniform per scramble — the original's "
                    "line 241 placement, so the draws depend on cell ordering"),
                "seed_sweep_rng": (
                    "np.random.default_rng(seed) per sweep; NOT the same stream as "
                    "legacy seed(2025)"),
                "phase_null_rng":
                    f"np.random.default_rng({ORIGINAL_SEED}) for the phase sweep",
                "threads": threads,
                "threading_note": (
                    "the kernel is evaluated in row chunks across a "
                    "ThreadPoolExecutor purely to bound memory and wall clock; "
                    "rows are independent so results are bit-identical to "
                    "--threads 1, and all random draws are generated in the "
                    "original's loop order before any threading"),
                "precision": "float64 throughout; no high-precision arithmetic",
                "out": out_path,
            },
            "constants": {
                "statistic": (
                    "Z = (mean(|B_N| at true zeros) - mean(scr_means)) / "
                    "std(scr_means, ddof=1); B_N(t) = sum_p p^(-1/2) sin(t log p). "
                    "This is a MEAN-AMPLITUDE statistic, NOT a minima statistic"),
                "uniform_t_null": (
                    "t_rnd ~ Uniform(zeros.min(), zeros.max()), size = "
                    "len(zeros), one mean per scramble"),
                "phase_null": (
                    "one phi_p ~ Uniform(0, 2pi) per prime, |B| at the SAME true "
                    "zeros; the null prescribed by the repo's own "
                    "METHODOLOGY_AUDIT_AND_FIXES.md. Reported for contrast; NOT "
                    "adjudicated against the uniform-t null"),
                "band_rule": (
                    "on the exact replication at seed 2025, per cell, against each "
                    "reference: REPRO = |Z_ours - Z_ref| < 0.01; CLOSE = 0.01 <= "
                    "|Z_ours - Z_ref| < 1.0; DIVERGES = |Z_ours - Z_ref| >= 1.0. "
                    "Fixed before the run and applied mechanically. n/a when the "
                    "reference has no value for that cell"),
                "band_repro": BAND_REPRO,
                "band_close": BAND_CLOSE,
                "published_z": {f"{k[0]}|{k[1]}": v
                                for k, v in PUBLISHED_Z.items()},
                "archived_csv_z": {f"{k[0]}|{k[1]}": v
                                   for k, v in ARCHIVED_CSV_Z.items()},
                "o10_note": (
                    "O10 is a deliberate gap in this series and is not filled by "
                    "this script"),
                "exploratory_note": (
                    "this test is NOT preregistered. Which tests are, and what "
                    "verdict each carries, is recorded in CONTEXT.md section "
                    "'Current state of the world' -- not enumerated here, because "
                    "an enumeration goes stale and this one did. "
                    "Its outputs are exploratory measurements, not verdicts. The "
                    "pre-registered BANDS above are fixed comparison thresholds "
                    "internal to this script, not a project verdict"),
            },
            "summary": {
                "wall_clock_seconds": elapsed,
                "gate_a": {
                    "statement": ("zero file has exactly 100000 lines and the "
                                  "first three values match to 9 decimals"),
                    "n_lines": n_lines, "expected_lines": GATE_A_N_LINES,
                    "lines_ok": bool(lines_ok),
                    "first3": first3, "first3_expected": list(GATE_A_FIRST3),
                    "first3_ok": bool(first3_ok), "tol": GATE_A_TOL,
                    "passed": gate_a_passed,
                },
                "gate_b": {
                    "statement": ("real_mean at N=1000, zeros 1-5000 is finite and "
                                  "in (0, 5)"),
                    "cell": f"{gate_b_key[0]}|{gate_b_key[1]}",
                    "real_mean": gate_b_real,
                    "lo": GATE_B_LO, "hi": GATE_B_HI,
                    "passed": gate_b_passed,
                },
                "gate_c": {
                    "statement": ("|B| at t = 14.134725142 with the first 100 "
                                  "primes agrees between a pure-python loop and "
                                  "the vectorized matrix form to 1e-12"),
                    "t": GATE_C_T, "n_primes": GATE_C_N_PRIMES,
                    "largest_prime": int(p100[-1]),
                    "pure_python": gate_c_loop, "vectorized": gate_c_vec,
                    "abs_difference": gate_c_diff, "tol": GATE_C_TOL,
                    "passed": gate_c_passed,
                },
                "replication_bands": band_rows,
                "band_counts_vs_archived_csv": counts_csv,
                "band_counts_vs_published": counts_pub,
                "convention_contrast": convention_rows,
                "seed_sensitivity": seed_summary,
                "seed_movement": seed_movement,
                "scramble_sensitivity": scramble_summary,
                "scramble_movement": scramble_movement,
                "null_contrast": null_rows,
            },
            "rows": exact_rows + count_rows + seed_rows + phase_rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
