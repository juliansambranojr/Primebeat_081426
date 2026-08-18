#!/usr/bin/env python3
"""
O33 - Base-ladder crossing: does the smooth trend of a base-b prime difference
      table lose to the first Riemann zero's mode as depth grows, and does the
      loss happen at the depth the depth transfer function predicts?

Reads with: O27_joint_dyadic_triadic_table.py (the backward-difference table
construction T[d][r] = T[d-1][r] - T[d-1][r-1] and the half-open first-block
convention) and O29_depth_residuals.py (the (b-1)/b trend-gain arithmetic and
the "record the prediction, then measure against it" layout).  CONTEXT.md
§ "Core quantities" defines N(r) = pi(b^r) - pi(b^(r-1)) and the backward
difference table on it; CONTEXT.md's O29 line records the transfer function
confirmation (3.53x per depth in base 2 against 1/(1-2^(-1/2)) = 3.414).

This script does NOT build its own table.  It READS eight already-built,
exact-integer CSV difference tables from a DIFFERENT project,

    /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit/

which is treated as STRICTLY READ-ONLY.  Nothing is written there.

NAMING
------
The O-series in this tree runs O1-O9, O11-O27 and O29-O32.  O10 and O28 are
known, DELIBERATE GAPS and this script does not fill either of them.  The
next free number is O33; this file takes it.  Capital "O" per `CLAUDE.md`
§ "Naming convention (do not re-break)".

STATUS
------
EXPLORATORY.  There is no prereg for this script, no hypothesis stated in a
locked protocol, and no decision rule.  It emits measured crossing depths
next to pre-stated predicted ones; it does NOT return a verdict, and no
number it prints may be described as one.  Per `CLAUDE.md` § "Prereg
discipline", the word "verdict" is reserved for 07/O7.

=============================================================================
THE CLAIM BEING MEASURED (pre-stated, supplied by the brief, NOT fitted here)
=============================================================================

The depth transfer function says one backward difference on a base-b ladder
multiplies a mode x^rho by (1 - b^(-rho)).  Two consequences:

  * the smooth trend is the rho = 1 mode, multiplied by (1 - b^(-1)) =
    (b-1)/b per depth -- a DECAY, since (b-1)/b < 1;
  * the first Riemann zero's mode is rho = 1/2 + i*gamma1, multiplied by
    |1 - b^(-1/2 - i*gamma1)| per depth.

Their ratio per depth is

    ratio(b) = |1 - b^(-1/2 - i*gamma1)| / ((b-1)/b)

and where ratio(b) > 1 the oscillation eventually overtakes the trend, so the
row of the difference table stops decaying monotonically and crosses or turns
around.  Where ratio(b) < 1 it never does.

The PRE-STATED prediction table is recorded verbatim in the constants block of
the results JSON as `prestated_predictions`.  It is an INPUT.  This script
recomputes trend and |1 - b^(-rho)| independently and reports both, but it
never substitutes its own numbers for the pre-stated ones and never adjusts a
predicted crossing depth to fit what was measured.

Bases 4, 6 and 9 are 2^2, 2*3 and 3^2 and carry ratio < 1.  The pre-stated
prediction is that they behave QUALITATIVELY differently from 2, 3, 5, 7, 8 --
no crossing at any depth.  That split is the discriminating observation.

=============================================================================
THE SOURCE TABLES -- schema, verified not assumed
=============================================================================

Eight CSVs, one per base b = 2..9, named <greek>_difference_table_<R>.csv.
Header:

    regime,A_count,delta_1,delta_2,...,delta_<R-1>

  * ROWS are the regime r = 1..R, one per row, running DOWN.
  * DEPTH runs ACROSS columns: A_count is depth 0, delta_k is depth k.
  * Support is lower-triangular, depth d present only for d <= r-1.
  * Values are PRIME counts, not composite counts.
  * The trailing number in the filename is R, the regime count, set by the
    generator as min(32, floor(log(2^64)/log b)).

VERIFIED PROPERTIES (this script re-verifies all of them at run time and
aborts the affected base if any fails):

  1. delta_d(r) = delta_{d-1}(r) - delta_{d-1}(r-1), a BACKWARD difference
     down the regime axis -- the same operator O27 and O29 use.  (The
     generator's docstring calls these "forward differences"; the data says
     otherwise and the data wins.)
  2. Support is exactly d <= r-1.
  3. A_count(r) = pi(b^r) - pi(b^(r-1)) over the half-open block
     (b^(r-1), b^r], MINUS the primes 2 and 3.

THE SCAFFOLD SILENCING -- the one material schema difference
------------------------------------------------------------
lattice_mapper silences 2 and 3: its generator `difference_table.py` defines
silenced_pi(x) = pi(x) - 2 for x >= 3, on the stated ground that 2 and 3 are
"the scaffold that generates the 6k+/-1 lattice".  Primebeat's O27 does not
silence anything.  (The lattice_mapper README describes a WEAKER convention,
2-only silencing; the README is stale, the generator source and the data both
say 2 and 3.)

Effect on this measurement, worked out rather than waved at.  The silencing
subtracts a constant from the depth-0 row of ONE regime only: r = 1 for every
base (and additionally r = 2 for b = 2, since 3 lies in the block (2, 4]).
Writing the d-fold backward difference as

    T[d][r] = sum_{k=0..d} (-1)^k C(d,k) T[0][r-k],

row 1 enters cell (r, d) only when r - 1 <= d.  The support is d <= r-1, so
the ONLY cells touched are r - 1 = d, the leading diagonal (plus the
sub-diagonal for b = 2).  The perturbation there is +/- a small integer
(at most 2) against cell magnitudes that reach 1e6 and beyond.

This is not asserted, it is CHECKED: with --unsilence-check (default on) the
script rebuilds each table with the scaffold primes added back into the
depth-0 rows they belong to, re-runs the whole crossing measurement, and
reports every row whose sign-change depth or turnaround depth moves.  If a
crossing depth is an artifact of the silencing convention, this is where it
shows up, and `summary.unsilence_check` records it per base.

=============================================================================
WHAT IS MEASURED, PER BASE AND PER ROW
=============================================================================

(a) TREND GAIN.  Along a row, the depth-to-depth ratio

        g(r, d) = cell(r, d) / cell(r, d-1)

    At shallow depth the trend dominates and g should sit at (b-1)/b.
    Reported per row: `trend_ratio_shallow`, the mean of g(r, d) over
    d = 1..--trend-depths, and `trend_depart_depth`, the first d at which
    |g(r,d) - (b-1)/b| exceeds --trend-tol.

(b) CROSSING DEPTH.  Two events, reported SEPARATELY because they are not the
    same event:

    `sign_change_depth`  the first d >= 1 at which cell(r,d) has the opposite
                         sign to the last preceding nonzero cell in that row.
                         An exact zero is not a sign change on its own; it is
                         recorded in `exact_zero_depths`.

    `turnaround_depth`   the argmin over available d of |cell(r,d)|, reported
                         ONLY when that argmin is interior -- i.e. at least
                         --turnaround-margin depths of the row lie beyond it
                         and |cell| is strictly larger at the end of them.
                         An argmin sitting at the last available depth is a
                         row that has not turned yet, not a turnaround, and is
                         reported as null with `turnaround_censored: true`.

(c) Both are reported as a function of r, one CSV line per (base, r), not
    collapsed to one number per base.

(d) ROW-DEPENDENCE DIAGNOSTIC.  The pre-stated table gives ONE crossing
    depth per base -- a depth that does not depend on the row r, i.e. slope 0
    when regressed on r.  This script measures whether that holds, by
    regressing the observed sign-change and turnaround depths on r
    (`crossing_depth_vs_row.*_ols_slope_vs_r`), and records alongside it

        slope_needed = ln(b) / (2 ln ratio)

    computed from the PRE-STATED ratio.  That is the slope implied if the two
    modes enter row r at depth 0 with amplitudes scaling as b^r (trend, rho=1)
    and b^(r/2) (the zero, Re rho = 1/2), so that ratio^(d+1) ~ b^(r/2).
    Because row r carries only depths d <= r-1, a slope_needed at or above 1
    means NO row of any length on a triangular support could show the
    crossing; `reachable_on_triangular_support` records that.  This whole
    block is DERIVED and is reported ALONGSIDE the pre-stated numbers.  It
    does not replace them, and nothing in this file edits them.

(e) DEPTH CEILING.  `max_depth_available` per row is r-1; per base it is
    R-1.  A base whose pre-stated predicted crossing depth exceeds the deepest
    depth at which any row could show it is reported as UNTESTED, never as a
    confirmation.  `summary.testable` carries that determination per base.

=============================================================================
OUTPUTS
=============================================================================

results/base_ladder_crossing.csv    one line per (base, r)
results/base_ladder_crossing.json   house envelope, schema_version "1":
                                    script, generated_utc, params, constants,
                                    summary, rows.  `params.code_version` is
                                    the sha256 of THIS file read at run time;
                                    `params.source_files` records each CSV
                                    read with its size and mtime.

Both paths are anchored to _HERE, so runs are cwd-independent.  --out,
--out-csv, --no-json and --no-csv are honoured per CONTEXT.md
§ "Output schema".

EXAMPLE
-------
    python3 O33_base_ladder_crossing.py \
        --data-dir /Users/juliansambrano/GitHub/lattice_mapper/difference_tables/32bit \
        --bases 2,3,4,5,6,7,8,9 --min-row 8 --trend-depths 3 --trend-tol 0.02
"""

import argparse
import csv
import datetime
import glob
import hashlib
import json
import math
import os
import sys

try:
    from mpmath import mp, mpf, mpc, fabs as mp_fabs
    _HAVE_MPMATH = True
except Exception:                                    # pragma: no cover
    _HAVE_MPMATH = False


_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "base_ladder_crossing.json")
DEFAULT_OUT_CSV = os.path.join(DEFAULT_RESULTS_DIR, "base_ladder_crossing.csv")
DEFAULT_DATA_DIR = ("/Users/juliansambrano/GitHub/lattice_mapper/"
                    "difference_tables/32bit")

# CONTEXT.md § "Core quantities"
GAMMA1_DEFAULT = "14.134725141734693"

# lattice_mapper/difference_table.py NAMES -- a naming convention of the
# source project, not a parameter of this measurement.  Overridable per base
# with --table b=PATH.
BASE_NAMES = {2: "dyadic", 3: "triadic", 4: "tetradic", 5: "pentadic",
              6: "hexadic", 7: "heptadic", 8: "octadic", 9: "enneadic"}

# The primes lattice_mapper silences.  See the docstring's scaffold section.
SCAFFOLD_PRIMES = (2, 3)

# ---------------------------------------------------------------------------
# PRE-STATED PREDICTIONS -- supplied by the brief BEFORE this run, recorded
# verbatim, never adjusted to fit.  This is an INPUT, not a result.
# ---------------------------------------------------------------------------
PRESTATED_PREDICTIONS_VERBATIM = """\
  b   trend (b-1)/b   |1-b^(-1/2-i g1)|   ratio/depth   predicted crossing depth
  2       0.5000            1.6784           3.3569            6
  3       0.6667            1.5715           2.3572            8.5
  4       0.7500            0.7177           0.9570         never (ratio < 1)
  5       0.8000            1.3600           1.7000           13.7
  6       0.8333            0.6045           0.7254         never (ratio < 1)
  7       0.8571            1.2984           1.5148           17.5
  8       0.8750            1.1976           1.3687           23.2
  9       0.8889            0.6978           0.7850         never (ratio < 1)"""

PRESTATED_PREDICTIONS = {
    2: {"trend": 0.5000, "zero_gain": 1.6784, "ratio": 3.3569,
        "crossing_depth": 6.0,  "crosses": True},
    3: {"trend": 0.6667, "zero_gain": 1.5715, "ratio": 2.3572,
        "crossing_depth": 8.5,  "crosses": True},
    4: {"trend": 0.7500, "zero_gain": 0.7177, "ratio": 0.9570,
        "crossing_depth": None, "crosses": False},
    5: {"trend": 0.8000, "zero_gain": 1.3600, "ratio": 1.7000,
        "crossing_depth": 13.7, "crosses": True},
    6: {"trend": 0.8333, "zero_gain": 0.6045, "ratio": 0.7254,
        "crossing_depth": None, "crosses": False},
    7: {"trend": 0.8571, "zero_gain": 1.2984, "ratio": 1.5148,
        "crossing_depth": 17.5, "crosses": True},
    8: {"trend": 0.8750, "zero_gain": 1.1976, "ratio": 1.3687,
        "crossing_depth": 23.2, "crosses": True},
    9: {"trend": 0.8889, "zero_gain": 0.6978, "ratio": 0.7850,
        "crossing_depth": None, "crosses": False},
}

PRESTATED_SPLIT = {
    "no_crossing_predicted": [4, 6, 9],
    "crossing_predicted": [2, 3, 5, 7, 8],
    "note": ("4 = 2^2, 6 = 2*3, 9 = 3^2. The pre-stated claim is that these "
             "three behave qualitatively differently from 2,3,5,7,8: no sign "
             "change and no turnaround at any available depth."),
}


# ---------------------------------------------------------------------------
# house plumbing (O29's, unchanged)
# ---------------------------------------------------------------------------

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


def _write_csv(fieldnames, rows, out_path):
    """Write the per-row CSV; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=fieldnames)
            w.writeheader()
            for r in rows:
                w.writerow({k: ("" if r.get(k) is None else r.get(k))
                            for k in fieldnames})
        print(f"  csv written to {out_path}", flush=True)
    except Exception as exc:
        print(f"  WARNING: could not write CSV to {out_path}: {exc}",
              flush=True)


# ---------------------------------------------------------------------------
# the transfer function, recomputed independently of the pre-stated table
# ---------------------------------------------------------------------------

def transfer_gains(b, gamma1, dps):
    """(1 - b^(-1)) and |1 - b^(-1/2 - i*gamma1)|, recomputed here.

    Reported alongside the pre-stated numbers as a cross-check.  It NEVER
    replaces them: the pre-stated table is the thing being tested against.
    """
    trend = (b - 1.0) / b
    if _HAVE_MPMATH:
        saved = mp.dps
        try:
            mp.dps = dps
            rho = mpc(mpf(1) / 2, mpf(gamma1))
            zero_gain = float(mp_fabs(1 - mpf(b) ** (-rho)))
        finally:
            mp.dps = saved
    else:                                            # pragma: no cover
        rho = complex(0.5, float(gamma1))
        zero_gain = abs(1 - complex(b) ** (-rho))
    return trend, zero_gain


# ---------------------------------------------------------------------------
# reading the source tables -- READ ONLY
# ---------------------------------------------------------------------------

def resolve_table_path(b, data_dir, overrides):
    if b in overrides:
        return overrides[b]
    name = BASE_NAMES.get(b)
    if name is None:
        raise ValueError(f"no filename convention known for base {b}; "
                         f"pass --table {b}=PATH")
    hits = sorted(glob.glob(os.path.join(
        data_dir, f"{name}_difference_table_[0-9]*.csv")))
    # exclude the silenced/variant siblings: keep only <name>_difference_table_<int>.csv
    exact = []
    for h in hits:
        stem = os.path.basename(h)[:-4]
        tail = stem[len(f"{name}_difference_table_"):]
        if tail.isdigit():
            exact.append(h)
    if not exact:
        raise FileNotFoundError(
            f"no {name}_difference_table_<R>.csv under {data_dir}")
    if len(exact) > 1:
        raise RuntimeError(f"ambiguous table for base {b}: {exact}; "
                           f"disambiguate with --table {b}=PATH")
    return exact[0]


def read_table(path):
    """Return (T, R, dmax_col, header, filename_R).

    T maps (r, d) -> int.  d = 0 is the A_count column, d = k is delta_k.
    Nothing is written to `path`; it is opened read-only.
    """
    with open(path, "r", newline="") as fh:
        rdr = csv.reader(fh)
        header = next(rdr)
        body = [row for row in rdr if row and row[0].strip() != ""]
    if header[0].strip().lower() != "regime":
        raise ValueError(f"{path}: first column is {header[0]!r}, expected "
                         f"'regime'")
    if header[1].strip() != "A_count":
        raise ValueError(f"{path}: second column is {header[1]!r}, expected "
                         f"'A_count'")
    for k, h in enumerate(header[2:], start=1):
        if h.strip() != f"delta_{k}":
            raise ValueError(f"{path}: column {k+2} is {h!r}, expected "
                             f"'delta_{k}'")
    T = {}
    for row in body:
        r = int(row[0])
        for d, cell in enumerate(row[1:]):
            s = cell.strip()
            if s != "":
                T[(r, d)] = int(s)
    R = max(r for (r, _) in T)
    stem = os.path.basename(path)[:-4]
    filename_R = int(stem.rsplit("_", 1)[1])
    return T, R, len(header) - 2, header, filename_R


def verify_schema(T, R):
    """Re-verify the two structural claims the docstring makes about the CSV.

    Returns (recursion_violations, support_violations, missing_cells).
    """
    recursion_bad, support_bad, missing = [], [], []
    for r in range(1, R + 1):
        for d in range(0, r):
            if (r, d) not in T:
                missing.append([r, d])
        for d in range(r, R):
            if (r, d) in T:
                support_bad.append([r, d])
    for (r, d) in sorted(T):
        if d == 0:
            continue
        a, c = T.get((r, d - 1)), T.get((r - 1, d - 1))
        if a is None or c is None:
            recursion_bad.append([r, d])
        elif T[(r, d)] != a - c:
            recursion_bad.append([r, d])
    return recursion_bad, support_bad, missing


def rebuild_from_depth0(depth0, R):
    """T[d][r] = T[d-1][r] - T[d-1][r-1] from a depth-0 row. Exact ints."""
    T = {(r, 0): depth0[r] for r in range(1, R + 1)}
    for d in range(1, R):
        for r in range(d + 1, R + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def unsilenced_depth0(T, R, b, scaffold):
    """Add the scaffold primes back into the depth-0 block that contains them.

    Block r is the half-open interval (b^(r-1), b^r].  A prime q belongs to
    the block with b^(r-1) < q <= b^r.
    """
    d0 = {r: T[(r, 0)] for r in range(1, R + 1)}
    placed = {}
    for q in scaffold:
        for r in range(1, R + 1):
            if b ** (r - 1) < q <= b ** r:
                d0[r] += 1
                placed[q] = r
                break
    return d0, placed


# ---------------------------------------------------------------------------
# the measurements
# ---------------------------------------------------------------------------

def _sign(x):
    return (x > 0) - (x < 0)


def measure_row(T, r, b, trend_depths, trend_tol, turnaround_margin):
    """All per-row quantities. Depths available on row r are d = 0..r-1."""
    dmax = r - 1
    vals = [T[(r, d)] for d in range(0, dmax + 1)]
    out = {
        "r": r,
        "max_depth_available": dmax,
        "value_at_depth0": vals[0],
        "n_depths": dmax + 1,
    }

    # (a) trend gain -------------------------------------------------------
    predicted_trend = (b - 1.0) / b
    ratios = []
    for d in range(1, dmax + 1):
        prev = vals[d - 1]
        ratios.append(None if prev == 0 else vals[d] / prev)
    usable = [g for g in ratios[:trend_depths] if g is not None]
    out["trend_ratio_shallow"] = (sum(usable) / len(usable)) if usable else None
    out["trend_ratio_predicted"] = predicted_trend
    out["trend_ratio_by_depth"] = ratios
    depart = None
    for d in range(1, dmax + 1):
        g = ratios[d - 1]
        if g is None or abs(g - predicted_trend) > trend_tol:
            depart = d
            break
    out["trend_depart_depth"] = depart
    out["trend_tol"] = trend_tol

    # (b) sign change ------------------------------------------------------
    exact_zeros = [d for d in range(0, dmax + 1) if vals[d] == 0]
    out["exact_zero_depths"] = exact_zeros
    sign_change = None
    last_sign = 0
    for d in range(0, dmax + 1):
        s = _sign(vals[d])
        if s == 0:
            continue
        if last_sign != 0 and s != last_sign:
            sign_change = d
            break
        last_sign = s
    out["sign_change_depth"] = sign_change

    # (b) turnaround -------------------------------------------------------
    absvals = [abs(v) for v in vals]
    dmin = min(range(0, dmax + 1), key=lambda d: (absvals[d], d))
    out["min_abs_depth"] = dmin
    out["min_abs_value"] = absvals[dmin]
    tail = absvals[dmin + 1:]
    censored = (dmax - dmin) < turnaround_margin
    risen = (len(tail) >= turnaround_margin
             and all(tail[k] > absvals[dmin] for k in range(turnaround_margin)))
    if dmin >= 1 and risen and not censored:
        out["turnaround_depth"] = dmin
        out["turnaround_censored"] = False
    else:
        out["turnaround_depth"] = None
        out["turnaround_censored"] = bool(censored or dmin == dmax)
    return out


def measure_base(T, R, b, args):
    rows = []
    for r in range(1, R + 1):
        rows.append(measure_row(T, r, b, args.trend_depths, args.trend_tol,
                                args.turnaround_margin))
    return rows



def _ols_slope(pairs):
    """Least-squares slope and intercept of d against r. None if < 2 points."""
    if len(pairs) < 2:
        return None, None
    n = len(pairs)
    mx = sum(x for x, _ in pairs) / n
    my = sum(y for _, y in pairs) / n
    sxx = sum((x - mx) ** 2 for x, _ in pairs)
    if sxx == 0:
        return None, None
    sxy = sum((x - mx) * (y - my) for x, y in pairs)
    m = sxy / sxx
    return m, my - m * mx


def summarise_base(b, rows, R, args, trend_recomputed, zero_gain_recomputed):
    pred = PRESTATED_PREDICTIONS[b]
    deep = [x for x in rows if x["r"] >= args.min_row]

    sc = [(x["r"], x["sign_change_depth"]) for x in deep
          if x["sign_change_depth"] is not None]
    ta = [(x["r"], x["turnaround_depth"]) for x in deep
          if x["turnaround_depth"] is not None]

    shallow = [x["trend_ratio_shallow"] for x in deep
               if x["trend_ratio_shallow"] is not None]
    departs = [x["trend_depart_depth"] for x in deep
               if x["trend_depart_depth"] is not None]

    ratio_recomputed = (zero_gain_recomputed / trend_recomputed
                        if trend_recomputed else None)

    max_depth_any_row = R - 1
    predicted_depth = pred["crossing_depth"]
    if predicted_depth is None:
        testable = "n/a - no crossing predicted"
        beyond_ceiling = False
    else:
        beyond_ceiling = predicted_depth > max_depth_any_row
        testable = "UNTESTED - predicted depth beyond ceiling" if beyond_ceiling \
            else "testable"

    med_sc = None
    if sc:
        v = sorted(d for _, d in sc)
        med_sc = v[len(v) // 2] if len(v) % 2 else (v[len(v) // 2 - 1]
                                                   + v[len(v) // 2]) / 2
    med_ta = None
    if ta:
        v = sorted(d for _, d in ta)
        med_ta = v[len(v) // 2] if len(v) % 2 else (v[len(v) // 2 - 1]
                                                   + v[len(v) // 2]) / 2

    # ---- ROW-DEPENDENCE DIAGNOSTIC (derived, reported ALONGSIDE the
    # pre-stated numbers; it never replaces them and never edits them) -------
    #
    # The pre-stated table gives ONE crossing depth per base, i.e. a depth
    # independent of the row r.  This block measures whether the observed
    # crossing depth is in fact row-independent, by regressing the observed
    # sign-change and turnaround depths on r.  It also records the depth a
    # row would have to reach for the two modes to meet if the amplitudes at
    # depth 0 of row r scale as b^r (trend) and b^(r/2) (the zero's mode):
    #
    #     ratio^(d+1) ~ b^(r/2)   =>   d ~ r * ln(b) / (2 ln ratio)
    #
    # `depth_needed_per_row_slope` is that ln(b)/(2 ln ratio), computed from
    # the PRE-STATED ratio, and `reachable_on_triangular_support` is whether
    # that slope is below 1 -- because row r only carries depths d <= r-1, a
    # slope at or above 1 means no row of ANY length on this support could
    # show the crossing.
    pre_ratio = pred["ratio"]
    if pre_ratio and pre_ratio > 1:
        slope_needed = math.log(b) / (2.0 * math.log(pre_ratio))
    else:
        slope_needed = None
    sc_slope, sc_intercept = _ols_slope([(float(r), float(d)) for r, d in sc])
    ta_slope, ta_intercept = _ols_slope([(float(r), float(d)) for r, d in ta])
    crossing_depth_vs_row = {
        "note": ("derived diagnostic, NOT a pre-stated prediction and NOT a "
                 "replacement for one"),
        "depth_needed_per_row_slope_from_prestated_ratio": slope_needed,
        "reachable_on_triangular_support":
            (None if slope_needed is None else bool(slope_needed < 1.0)),
        "sign_change_depth_ols_slope_vs_r": sc_slope,
        "sign_change_depth_ols_intercept": sc_intercept,
        "turnaround_depth_ols_slope_vs_r": ta_slope,
        "turnaround_depth_ols_intercept": ta_intercept,
    }

    return {
        "base": b,
        "R": R,
        "max_depth_available": max_depth_any_row,
        "rows_considered_min_row": args.min_row,
        "n_rows_considered": len(deep),
        "prestated_trend": pred["trend"],
        "prestated_zero_gain": pred["zero_gain"],
        "prestated_ratio_per_depth": pred["ratio"],
        "prestated_crossing_depth": predicted_depth,
        "prestated_crosses": pred["crosses"],
        "recomputed_trend": trend_recomputed,
        "recomputed_zero_gain": zero_gain_recomputed,
        "recomputed_ratio_per_depth": ratio_recomputed,
        "trend_ratio_shallow_mean": (sum(shallow) / len(shallow)) if shallow else None,
        "trend_depart_depth_min": min(departs) if departs else None,
        "trend_depart_depth_max": max(departs) if departs else None,
        "n_rows_with_sign_change": len(sc),
        "sign_change_depth_min": min(d for _, d in sc) if sc else None,
        "sign_change_depth_max": max(d for _, d in sc) if sc else None,
        "sign_change_depth_median": med_sc,
        "sign_change_by_row": [{"r": r, "d": d} for r, d in sc],
        "n_rows_with_turnaround": len(ta),
        "turnaround_depth_min": min(d for _, d in ta) if ta else None,
        "turnaround_depth_max": max(d for _, d in ta) if ta else None,
        "turnaround_depth_median": med_ta,
        "turnaround_by_row": [{"r": r, "d": d} for r, d in ta],
        "crossing_depth_vs_row": crossing_depth_vs_row,
        "observed_crosses": bool(sc or ta),
        "prediction_matches_qualitatively": bool(sc or ta) == bool(pred["crosses"]),
        "testable": testable,
        "predicted_depth_beyond_ceiling": beyond_ceiling,
    }


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def _parse_bases(s):
    return [int(x) for x in s.replace(" ", "").split(",") if x != ""]


def _parse_table_override(items):
    out = {}
    for it in items or []:
        if "=" not in it:
            raise ValueError(f"--table expects BASE=PATH, got {it!r}")
        k, v = it.split("=", 1)
        out[int(k)] = v
    return out


def main():
    ap = argparse.ArgumentParser(
        description=("O33 - base-ladder crossing depth vs the depth transfer "
                     "function. EXPLORATORY: no prereg, no decision rule, no "
                     "verdict."))
    ap.add_argument("--data-dir", type=str, default=DEFAULT_DATA_DIR,
                    help=f"directory holding the source CSVs, READ ONLY "
                         f"(default: {DEFAULT_DATA_DIR})")
    ap.add_argument("--bases", type=str, default="2,3,4,5,6,7,8,9",
                    help="comma-separated bases to measure (default: 2..9)")
    ap.add_argument("--table", action="append", default=None, metavar="B=PATH",
                    help="explicit CSV path for base B; repeatable. Overrides "
                         "the --data-dir glob.")
    ap.add_argument("--gamma1", type=str, default=GAMMA1_DEFAULT,
                    help=f"first Riemann zero ordinate (default: "
                         f"{GAMMA1_DEFAULT})")
    ap.add_argument("--dps", type=int, default=50,
                    help="mpmath precision for the recomputed transfer gains "
                         "(default: 50)")
    ap.add_argument("--min-row", type=int, default=8,
                    help="rows with r >= this are counted in the per-base "
                         "summary; every row is still written to the CSV "
                         "(default: 8)")
    ap.add_argument("--trend-depths", type=int, default=3,
                    help="how many shallow depths d=1.. enter the observed "
                         "trend ratio (default: 3)")
    ap.add_argument("--trend-tol", type=float, default=0.05,
                    help="absolute tolerance on |g(r,d) - (b-1)/b| for the "
                         "departure depth (default: 0.05)")
    ap.add_argument("--turnaround-margin", type=int, default=2,
                    help="how many depths beyond the |cell| minimum must be "
                         "present AND strictly larger for a turnaround to "
                         "count as observed rather than censored (default: 2)")
    ap.add_argument("--unsilence-check", dest="unsilence_check",
                    action="store_true", default=True,
                    help="rebuild each table with the scaffold primes 2,3 "
                         "added back and report any row whose crossing moves "
                         "(default: on)")
    ap.add_argument("--no-unsilence-check", dest="unsilence_check",
                    action="store_false",
                    help="skip the scaffold-silencing robustness check")
    ap.add_argument("--scaffold-primes", type=str, default="2,3",
                    help="primes lattice_mapper silences, added back by the "
                         "unsilence check (default: 2,3)")
    ap.add_argument("--strict-schema", action="store_true", default=False,
                    help="abort the whole run if any base fails schema "
                         "verification (default: skip that base only)")
    ap.add_argument("--print-rmax", type=int, default=None,
                    help="cap the console row listing at this r (JSON/CSV "
                         "always carry every row)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help=f"results directory (default: {DEFAULT_RESULTS_DIR})")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help=f"results JSON path (default: {DEFAULT_OUT_JSON})")
    ap.add_argument("--out-csv", type=str, default=DEFAULT_OUT_CSV,
                    help=f"results CSV path (default: {DEFAULT_OUT_CSV})")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    ap.add_argument("--no-csv", action="store_true",
                    help="do not write the results CSV")
    args = ap.parse_args()

    started = datetime.datetime.now(datetime.timezone.utc)
    bases = _parse_bases(args.bases)
    overrides = _parse_table_override(args.table)
    scaffold = tuple(int(x) for x in args.scaffold_primes.replace(" ", "")
                     .split(",") if x != "")

    print("=" * 78, flush=True)
    print("O33 - BASE-LADDER CROSSING  (EXPLORATORY: no prereg, no decision "
          "rule, no verdict)", flush=True)
    print("=" * 78, flush=True)
    print(f"  source dir (READ ONLY): {args.data_dir}", flush=True)
    print(f"  bases: {bases}", flush=True)
    print(f"  gamma1 = {args.gamma1}", flush=True)
    print("\n  PRE-STATED PREDICTIONS (input, not result):", flush=True)
    for line in PRESTATED_PREDICTIONS_VERBATIM.splitlines():
        print("    " + line, flush=True)

    source_files, per_base, all_rows, schema_reports = [], [], [], []
    unsilence_reports = []

    for b in bases:
        if b not in PRESTATED_PREDICTIONS:
            print(f"\n  base {b}: no pre-stated prediction; skipped.", flush=True)
            continue
        path = resolve_table_path(b, args.data_dir, overrides)
        st = os.stat(path)
        with open(path, "rb") as fh:
            fsha = hashlib.sha256(fh.read()).hexdigest()
        T, R, ncols, header, filename_R = read_table(path)
        source_files.append({
            "base": b,
            "path": path,
            "bytes": st.st_size,
            "mtime_utc": datetime.datetime.fromtimestamp(
                st.st_mtime, datetime.timezone.utc)
                .strftime("%Y-%m-%dT%H:%M:%SZ"),
            "sha256": fsha,
            "header_first_4": header[:4],
            "header_last": header[-1],
            "n_columns": len(header),
            "regimes": R,
            "filename_trailing_number": filename_R,
            "filename_trailing_number_equals_regimes": filename_R == R,
        })

        rec_bad, sup_bad, missing = verify_schema(T, R)
        ok = not (rec_bad or sup_bad or missing)
        schema_reports.append({
            "base": b, "ok": ok,
            "recursion_violations": rec_bad[:20],
            "n_recursion_violations": len(rec_bad),
            "support_violations": sup_bad[:20],
            "n_support_violations": len(sup_bad),
            "missing_cells": missing[:20],
            "n_missing_cells": len(missing),
        })
        if not ok:
            msg = (f"  base {b}: SCHEMA VERIFICATION FAILED "
                   f"(recursion {len(rec_bad)}, support {len(sup_bad)}, "
                   f"missing {len(missing)})")
            print(msg, flush=True)
            if args.strict_schema:
                sys.exit(2)
            continue

        trend_rc, zg_rc = transfer_gains(b, args.gamma1, args.dps)
        rows = measure_base(T, R, b, args)
        summ = summarise_base(b, rows, R, args, trend_rc, zg_rc)
        per_base.append(summ)
        for x in rows:
            y = dict(x)
            y["base"] = b
            all_rows.append(y)

        if args.unsilence_check:
            d0u, placed = unsilenced_depth0(T, R, b, scaffold)
            Tu = rebuild_from_depth0(d0u, R)
            rows_u = measure_base(Tu, R, b, args)
            moved = []
            for x, xu in zip(rows, rows_u):
                if (x["sign_change_depth"] != xu["sign_change_depth"]
                        or x["turnaround_depth"] != xu["turnaround_depth"]):
                    moved.append({
                        "r": x["r"],
                        "sign_change_silenced": x["sign_change_depth"],
                        "sign_change_unsilenced": xu["sign_change_depth"],
                        "turnaround_silenced": x["turnaround_depth"],
                        "turnaround_unsilenced": xu["turnaround_depth"],
                    })
            unsilence_reports.append({
                "base": b,
                "scaffold_primes_added_back": list(scaffold),
                "placed_in_regime": {str(q): r for q, r in placed.items()},
                "n_rows_whose_crossing_moved": len(moved),
                "rows_moved": moved,
            })

    # ---- console -----------------------------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("PER-BASE SUMMARY", flush=True)
    print("=" * 78, flush=True)
    hdr = (f"{'b':>2} {'R':>3} {'dmax':>4} {'pred_d':>7} {'sc_min':>6} "
           f"{'sc_max':>6} {'ta_min':>6} {'ta_max':>6} {'nsc':>4} {'nta':>4} "
           f"{'trend_obs':>9} {'trend_pred':>10}  testable")
    print(hdr, flush=True)
    for s in per_base:
        pd_ = "never" if s["prestated_crossing_depth"] is None \
            else f"{s['prestated_crossing_depth']:.1f}"
        to = s["trend_ratio_shallow_mean"]
        print(f"{s['base']:>2} {s['R']:>3} {s['max_depth_available']:>4} "
              f"{pd_:>7} "
              f"{str(s['sign_change_depth_min']):>6} "
              f"{str(s['sign_change_depth_max']):>6} "
              f"{str(s['turnaround_depth_min']):>6} "
              f"{str(s['turnaround_depth_max']):>6} "
              f"{s['n_rows_with_sign_change']:>4} "
              f"{s['n_rows_with_turnaround']:>4} "
              f"{(f'{to:.4f}' if to is not None else 'n/a'):>9} "
              f"{s['prestated_trend']:>10.4f}  {s['testable']}", flush=True)

    print("\nROW-DEPENDENCE DIAGNOSTIC (derived; the pre-stated table gives one "
          "depth per\nbase, i.e. slope 0 in r. slope_needed = ln(b)/(2 ln ratio) "
          "from the PRE-STATED\nratio; a slope >= 1 cannot be reached on a "
          "d <= r-1 triangular support.)", flush=True)
    print(f"{'b':>2} {'slope_needed':>12} {'reachable':>9} "
          f"{'ta_slope_obs':>12} {'sc_slope_obs':>12}", flush=True)
    for s_ in per_base:
        c = s_["crossing_depth_vs_row"]
        def _f(v):
            return "n/a" if v is None else f"{v:.4f}"
        print(f"{s_['base']:>2} "
              f"{_f(c['depth_needed_per_row_slope_from_prestated_ratio']):>12} "
              f"{str(c['reachable_on_triangular_support']):>9} "
              f"{_f(c['turnaround_depth_ols_slope_vs_r']):>12} "
              f"{_f(c['sign_change_depth_ols_slope_vs_r']):>12}", flush=True)

    print("\nPER-ROW DETAIL (sign-change depth / turnaround depth by row)",
          flush=True)
    for s in per_base:
        b = s["base"]
        rows_b = [x for x in all_rows if x["base"] == b
                  and x["r"] >= args.min_row]
        if args.print_rmax is not None:
            rows_b = [x for x in rows_b if x["r"] <= args.print_rmax]
        print(f"\n  base {b}:", flush=True)
        for x in rows_b:
            to = x["trend_ratio_shallow"]
            print(f"    r={x['r']:>3}  dmax={x['max_depth_available']:>3}  "
                  f"sign_change={str(x['sign_change_depth']):>5}  "
                  f"turnaround={str(x['turnaround_depth']):>5}"
                  f"{' (censored)' if x['turnaround_censored'] else ''}  "
                  f"trend_obs={(f'{to:.4f}' if to is not None else 'n/a')}  "
                  f"depart_d={str(x['trend_depart_depth'])}", flush=True)

    if unsilence_reports:
        print("\nSCAFFOLD-SILENCING ROBUSTNESS CHECK "
              "(2,3 added back, table rebuilt)", flush=True)
        for u in unsilence_reports:
            print(f"  base {u['base']}: rows whose crossing moved = "
                  f"{u['n_rows_whose_crossing_moved']}", flush=True)
            for m in u["rows_moved"]:
                print(f"      r={m['r']} sign_change "
                      f"{m['sign_change_silenced']} -> "
                      f"{m['sign_change_unsilenced']}, turnaround "
                      f"{m['turnaround_silenced']} -> "
                      f"{m['turnaround_unsilenced']}", flush=True)

    # ---- artifacts ---------------------------------------------------------
    ended = datetime.datetime.now(datetime.timezone.utc)

    csv_fields = ["base", "r", "sign_change_depth", "turnaround_depth",
                  "trend_ratio_shallow", "max_depth_available",
                  "trend_ratio_predicted", "trend_depart_depth",
                  "turnaround_censored", "min_abs_depth", "min_abs_value",
                  "value_at_depth0", "n_depths"]
    if not args.no_csv:
        _write_csv(csv_fields, all_rows, args.out_csv)

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": os.path.basename(__file__),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "run_start_utc": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "data_dir": args.data_dir,
                "bases": bases,
                "table_overrides": overrides,
                "gamma1": args.gamma1,
                "dps": args.dps,
                "min_row": args.min_row,
                "trend_depths": args.trend_depths,
                "trend_tol": args.trend_tol,
                "turnaround_margin": args.turnaround_margin,
                "unsilence_check": args.unsilence_check,
                "scaffold_primes": list(scaffold),
                "strict_schema": args.strict_schema,
                "out": args.out,
                "out_csv": args.out_csv,
                "mpmath_available": _HAVE_MPMATH,
                "python": sys.version,
                "source_files": source_files,
                "prereg": None,
                "status": "exploratory",
            },
            "constants": {
                "gamma1": args.gamma1,
                "prestated_predictions_verbatim":
                    PRESTATED_PREDICTIONS_VERBATIM,
                "prestated_predictions": PRESTATED_PREDICTIONS,
                "prestated_split": PRESTATED_SPLIT,
                "prestated_note":
                    "These predictions were supplied BEFORE this run and are "
                    "recorded verbatim. They are an INPUT. Nothing in this "
                    "file adjusts them to fit the measurement.",
                "transfer_function":
                    "one backward difference multiplies a mode x^rho by "
                    "(1 - b^(-rho)); trend is rho = 1, first zero is "
                    "rho = 1/2 + i*gamma1",
                "source_schema":
                    "cell(r,0) = A_count = silenced_pi(b^r) - "
                    "silenced_pi(b^(r-1)) over the half-open block "
                    "(b^(r-1), b^r]; cell(r,d) = delta_d = cell(r,d-1) - "
                    "cell(r-1,d-1); support d <= r-1; values are PRIME "
                    "counts; depth runs ACROSS columns, regime DOWN rows",
                "source_silencing":
                    "lattice_mapper/difference_table.py silences the primes "
                    "2 and 3 (silenced_pi(x) = pi(x) - 2 for x >= 3). This "
                    "perturbs only the leading diagonal r = d+1 (plus the "
                    "sub-diagonal for b = 2); see summary.unsilence_check.",
                "source_project": "/Users/juliansambrano/GitHub/lattice_mapper "
                                  "(READ ONLY; nothing written there)",
            },
            "summary": {
                "per_base": per_base,
                "schema_verification": schema_reports,
                "unsilence_check": unsilence_reports,
                "n_rows_total": len(all_rows),
                "bases_measured": [s["base"] for s in per_base],
                "bases_observed_crossing": [s["base"] for s in per_base
                                            if s["observed_crosses"]],
                "bases_no_crossing_observed": [s["base"] for s in per_base
                                               if not s["observed_crosses"]],
                "bases_untested_predicted_depth_beyond_ceiling":
                    [s["base"] for s in per_base
                     if s["predicted_depth_beyond_ceiling"]],
                "qualitative_split_matches_prestated":
                    all(s["prediction_matches_qualitatively"]
                        for s in per_base),
            },
            "rows": all_rows,
        }
        _write_results(payload, args.out)

    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  Every table cell above is an exact Python integer read from a "
          "source CSV.", flush=True)
    print("  The prediction table is an INPUT, recorded verbatim and never "
          "adjusted.", flush=True)
    print("  This script states no hypothesis and fires no decision rule. Its "
          "output is", flush=True)
    print("  EXPLORATORY per CLAUDE.md § Prereg discipline. Nothing here is a "
          "verdict.", flush=True)


if __name__ == "__main__":
    main()
