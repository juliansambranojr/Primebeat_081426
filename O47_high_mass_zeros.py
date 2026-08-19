#!/usr/bin/env python3
"""
O47 - high-mass zeros: which exact zeros are cancellations rather than
      bookkeeping?  Every exact zero in the resolved stratum at d >= 1,
      across all eleven of O45's bases, ranked by stencil mass S.

STATUS: EXPLORATORY.  NOT PREREGISTERED.  NOTHING HERE IS A VERDICT.

  This script tests no preregistered hypothesis, computes no p-value, and
  selects no verdict label.  It is a read-and-compute pass over data already
  produced by O45 under preregs/sub_integer_base_scan_v1_20260818.md, and
  its output is labelled `status: exploratory` in the results JSON.
  CLAUDE.md, section "Prereg discipline": "Numbers produced outside that
  discipline are exploratory and must be labelled as such."

  Nothing here is re-run, re-measured or re-locked.  O45 and O46 are
  imported READ-ONLY for their routines; neither main() is executed and
  neither result file is written, moved or touched.

Reads with: O45_sub_integer_base_scan.py
                (LOCKED_BASES, base_geometry, rung_populations, r_thick_of,
                 build_tables, stencil_mass, load_pi_backend, D_MIN,
                 GAMMA1_STR, VALUE_CEILING_EXP - so the stratum here is
                 O45's own and not a re-derivation)
            O46_mass_density_check.py
                (build_mass_table - the Pascal recurrence
                 S(r,d) = S(r,d-1) + S(r-1,d-1), identically
                 sum_k C(d,k) N(r-k))
            results/sub_integer_base_scan.json
                (read only: the per-base resolved-zero coordinates and S
                 this run is checked against, cell by cell)
            results/mass_density_check.json
                (read only: O46's median S at the resolved zeros and median
                 S over the whole resolved stratum, quoted for context)
            preregs/sub_integer_base_scan_v1_20260818.md
                (mass_bound, resolved_criterion, mass_floor - recorded with
                 its sha256, not modified)

=============================================================================
WHAT THIS IS FOR
=============================================================================

O46 found that the exact zeros sit in the extreme thin tail of the
stencil-mass distribution: the median S at a resolved zero is 8-516 while
the median S over the resolved stratum is 1e8-1e18.  A typical zero is
therefore a cell where there was almost nothing to cancel - bookkeeping,
not arithmetic.

The prereg's mass_bound is exact: |cell(r,d)| <= S(r,d).  So S is the
amount of prime mass the alternating sum had to annihilate.  The
interesting zeros are the HIGH-S ones: cells where a large amount of prime
mass cancelled exactly.  This script extracts them and ranks them.

It answers six questions and stops:

  1  the top 25 resolved zeros by S, pooled across all eleven bases, each
     with its arm, (r,d), S, r-d, value window and prime count
  2  whether the pooled S-sorted list has a natural break, located by the
     largest consecutive ratio S_i / S_(i+1) - reported as an exact
     Fraction, and reported as absent if the profile is smooth
  3  base 2's four zeros and their POOLED rank
  4  which zeros, if any, exceed base 2's (20,6) at S = 492384
  5  the top 10 windows as intervals in log2(x), and which pairs overlap
  6  the cell at (40,12) at base 2^(1/2) - the image of base 2's (20,6)
     under the factor-2 refinement, same value window at twice the
     resolution - with (34,11) and (42,5) alongside it

=============================================================================
THE STRATUM, AND WHY IT IS O45'S
=============================================================================

The prereg's `resolved_criterion`, taken from O45's own code path:

    d >= 1,  1 <= d <= r-1,  2 <= r <= r_max(b),  and  r - d >= r_thick(b)

with r_thick from O45's r_thick_of() and r_max from O45's base_geometry().
Every per-base geometry recomputed here is compared to O45's LOCKED_BASES
table AND to the observed values in results/sub_integer_base_scan.json;
disagreement is printed as a finding and recorded in the JSON.  Every
resolved zero found here is matched coordinate-by-coordinate and S-by-S
against O45's recorded exact_zeros.

=============================================================================
THE VALUE WINDOW - TWO OF THEM, BOTH REPORTED
=============================================================================

A cell at (r,d) reads rungs r-d .. r.  Rung r' is the half-open interval
(b^(r'-1), b^r'].  Two windows follow and they differ by one rung, so both
are reported and neither is left implicit:

  window       (b^(r-d), b^r]      - the span from the bottom stencil rung's
                                     UPPER edge to the top rung's upper edge.
                                     This is the window the ranking table
                                     reports, and it is the one under which
                                     base 2's (20,6) and base 2^(1/2)'s
                                     (40,12) coincide exactly at
                                     (2^14, 2^20].
                                     primes in it = sum_(k=0..d-1) N(r-k)
                                                  = pi(b^r) - pi(b^(r-d)).

  stencil span (b^(r-d-1), b^r]    - the full support the stencil actually
                                     touches, one rung wider at the bottom.
                                     primes in it = sum_(k=0..d) N(r-k).

Neither is S.  S weights rung r-k by C(d,k); the two prime counts above are
the unweighted populations.  All three are reported per zero.

log2 endpoints: lo = (r-d)*log2(b), hi = r*log2(b).  log2(b) is EXACT as a
Fraction at the three exact bases (2 -> 1, 2^(1/2) -> 1/2, 2^(1/3) -> 1/3)
and is an mpf at dps 60 at the eight transcendental bases, where it is
irrational and no exact rational exists.  Overlap comparisons are carried
at dps 60.

=============================================================================
ARITHMETIC
=============================================================================

Exact Python int for every N, W, cell and S.  The ranking key is S, an
exact int, with a deterministic tiebreak (base index, r, d) - no float is
ever ranked.  Every ratio that is compared is an exact fractions.Fraction:
the consecutive S_i/S_(i+1) gap ratios, and the window-overlap fractions at
the exact bases.  mpmath at dps 60 carries log2(b) at the transcendental
bases and the overlap arithmetic that involves them, because log2(b) there
is irrational; dps 60 is O45's own precision for the same bases.  Floats
appear only in printed and JSON-serialised copies of quantities that were
already decided exactly.

No randomness anywhere: no Monte Carlo, no resampling, no --seed flag and
nothing to seed.

=============================================================================
OUTPUTS
=============================================================================

results/high_mass_zeros.json    house envelope, schema_version "1":
                                script, generated_utc, params, constants,
                                summary, rows.  rows is the FULL pooled
                                ranked list of resolved zeros, not just the
                                top 25.  params.status is "exploratory".

Console output is the human-readable report; tee it to
results/O47_high_mass_zeros_run1.log.

Every path is anchored to _HERE, so runs are cwd-independent.  Nothing is
written outside results/, and --out refuses to clobber an existing file
unless --overwrite is passed.

HOW IT IS RUN
-------------
    .venv/bin/python O47_high_mass_zeros.py \
        --o45 O45_sub_integer_base_scan.py \
        --o46 O46_mass_density_check.py \
        --o45-json results/sub_integer_base_scan.json \
        --o46-json results/mass_density_check.json \
        --prereg preregs/sub_integer_base_scan_v1_20260818.md \
        --top-n 25 \
        --top-window 10 \
        --probe-base "2**(1/2)" \
        --probe-cells "40,12;34,11;42,5" \
        --out results/high_mass_zeros.json \
        2>&1 | tee results/O47_high_mass_zeros_run1.log

REQUIREMENTS: standard library, plus primecountpy (via O45's backend
loader, with sympy as the stated fallback) and mpmath.
"""

import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import sys
from fractions import Fraction

from mpmath import mp, mpf, log as mplog

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_O45 = os.path.join(_HERE, "O45_sub_integer_base_scan.py")
DEFAULT_O46 = os.path.join(_HERE, "O46_mass_density_check.py")
DEFAULT_O45_JSON = os.path.join(_HERE, "results", "sub_integer_base_scan.json")
DEFAULT_O46_JSON = os.path.join(_HERE, "results", "mass_density_check.json")
DEFAULT_PREREG = os.path.join(
    _HERE, "preregs", "sub_integer_base_scan_v1_20260818.md")
DEFAULT_OUT = os.path.join(_HERE, "results", "high_mass_zeros.json")

RULE = "=" * 78
THIN = "-" * 78

DPS = 60                 # O45's own precision for the transcendental bases
STATUS = "exploratory"

# results/sub_integer_base_scan.json -> summary.per_base[0].exact_zeros:
# base 2's (20,6) carries S = 492384.  Question 4's reference point.
B2_TOP_S = 492384


# ---------------------------------------------------------------------------
# house plumbing (O45's / O46's, unchanged)
# ---------------------------------------------------------------------------

def _resolve(path):
    return path if os.path.isabs(path) else os.path.join(_HERE, path)


def _code_version(path):
    try:
        with open(path, "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
        return f"unavailable: {exc}"


def file_record(path, extra=None):
    st = os.stat(path)
    with open(path, "rb") as fh:
        sha = hashlib.sha256(fh.read()).hexdigest()
    rec = {
        "path": path,
        "basename": os.path.basename(path),
        "bytes": st.st_size,
        "mtime_utc": datetime.datetime.fromtimestamp(
            st.st_mtime, datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "sha256": sha,
    }
    if extra:
        rec.update(extra)
    return rec


def _jsonable(o):
    if isinstance(o, dict):
        return {str(k): _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str) or isinstance(o, bool):
        return o
    if isinstance(o, int):
        return int(o)
    if isinstance(o, float):
        return o if math.isfinite(o) else None
    try:
        f = float(o)
    except (TypeError, ValueError, OverflowError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:                                  # pragma: no cover
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)


def load_module(path, name):
    """Import a sibling O-script read-only for its routines.  Each one's
    main() is guarded by __name__ == '__main__' and is NOT run.  Loaded via
    importlib for the same reason 07_alpha_depth_trend.py loads 05 that way
    (CLAUDE.md, section 'Naming convention')."""
    spec = importlib.util.spec_from_file_location(name, path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def _fmt(x, n=8):
    if x is None:
        return "-"
    if isinstance(x, Fraction):
        return mp.nstr(mpf(x.numerator) / mpf(x.denominator), n)
    return mp.nstr(mpf(x), n)


def _to_mpf(x):
    """mpf() refuses a Fraction; route it through numerator/denominator so a
    mixed exact/transcendental comparison never loses the exact side to a
    float64 intermediate."""
    if isinstance(x, Fraction):
        return mpf(x.numerator) / mpf(x.denominator)
    return mpf(x)


def _sig(x, n=4):
    """Short scientific rendering of a possibly-huge exact integer, without
    routing it through float()."""
    if x is None:
        return "-"
    return mp.nstr(mpf(x), n)


# ---------------------------------------------------------------------------
# log2 of the base: exact where it can be, mpf where it cannot
# ---------------------------------------------------------------------------

def log2_base(kind, b):
    """Return (log2b_exact_or_None, log2b_mpf).

    b = 2        -> exactly 1
    b = 2^(1/m)  -> exactly 1/m
    transcendental -> irrational; no exact rational exists, mpf at dps DPS.
    """
    tag, param = kind
    if tag == "int":
        return Fraction(1), mpf(1)
    if tag == "root":
        return Fraction(1, param), mpf(1) / mpf(param)
    return None, mplog(b) / mplog(2)


# ---------------------------------------------------------------------------
# per-base extraction
# ---------------------------------------------------------------------------

def scan_base(o45, o46, idx, arm, label, kind, locked, gamma1, pi_fn,
              pi_cache, probe_cells):
    """One base: every exact zero in the resolved stratum at d >= 1, with S,
    both value windows and both prime counts.  No threshold is applied and
    no decision is taken."""
    locked_r_max, locked_cells, locked_r_thick, locked_resolved = locked

    b, r_max, F, min_gap, root_bad = o45.base_geometry(kind, gamma1)
    W = o45.rung_populations(F, r_max)
    r_thick = o45.r_thick_of(W, b, r_max)

    def PI(x):
        if x < 2:
            return 0
        if x not in pi_cache:
            pi_cache[x] = pi_fn(x)
        return pi_cache[x]

    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    P, _Q = o45.build_tables(N, W, r_max)
    S = o46.build_mass_table(N, r_max)

    l2_exact, l2_mpf = log2_base(kind, b)

    # cumulative prime counts by rung, so the two window populations are one
    # subtraction each and are exact.
    cumN = [0] * (r_max + 1)
    for r in range(1, r_max + 1):
        cumN[r] = cumN[r - 1] + N[r]

    def cell_record(r, d):
        cell = P[(r, d)]
        s = S[(r, d)]
        # window (b^(r-d), b^r]: rungs r-d+1 .. r
        n_win = cumN[r] - cumN[r - d]
        # stencil span (b^(r-d-1), b^r]: rungs r-d .. r
        n_span = cumN[r] - cumN[r - d - 1] if (r - d - 1) >= 0 else cumN[r]
        rec = {
            "base_index": idx,
            "arm": arm,
            "label": label,
            "b": float(b),
            "b_str": mp.nstr(b, 22),
            "r": r,
            "d": d,
            "r_minus_d": r - d,
            "resolved": (r - d) >= r_thick,
            "r_thick": r_thick,
            "cell": cell,
            "is_zero": (cell == 0),
            "S": s,
            "S_str": _sig(s, 10),
            "S_digits": len(str(s)),
            "abs_cell_over_S_str": (_fmt(Fraction(abs(cell), s), 8)
                                    if s else None),
            "window_lo_int": F[r - d],
            "window_hi_int": F[r],
            "window_lo_log2": float((r - d) * (l2_exact if l2_exact is not None
                                               else l2_mpf)),
            "window_hi_log2": float(r * (l2_exact if l2_exact is not None
                                         else l2_mpf)),
            "window_len_log2": float(d * (l2_exact if l2_exact is not None
                                          else l2_mpf)),
            "log2_base_exact": (str(l2_exact) if l2_exact is not None
                                else None),
            "log2_base": float(l2_mpf),
            "n_primes_in_window": n_win,
            "stencil_span_lo_int": F[r - d - 1] if (r - d - 1) >= 0 else 1,
            "stencil_span_lo_log2": float((r - d - 1)
                                          * (l2_exact if l2_exact is not None
                                             else l2_mpf)),
            "n_primes_in_stencil_span": n_span,
        }
        return rec

    zeros = []
    n_cells = 0
    n_res = 0
    for r in range(2, r_max + 1):
        for d in range(o45.D_MIN, r):
            n_cells += 1
            if (r - d) < r_thick:
                continue
            n_res += 1
            if P[(r, d)] == 0:
                zeros.append(cell_record(r, d))

    probes = []
    for (pr, pd) in probe_cells:
        if not (2 <= pr <= r_max and 1 <= pd <= pr - 1):
            probes.append({"r": pr, "d": pd, "on_support": False,
                           "note": f"off support at this base "
                                   f"(r_max={r_max}, need 1<=d<=r-1)"})
            continue
        rec = cell_record(pr, pd)
        rec["on_support"] = True
        # cross-check S against O45's own stencil_mass() at every probe cell
        rec["S_matches_o45_stencil_mass"] = (
            rec["S"] == o45.stencil_mass(N, pr, pd))
        probes.append(rec)

    return {
        "base_index": idx,
        "arm": arm,
        "label": label,
        "kind": f"{kind[0]}:{kind[1]}",
        "b": float(b),
        "b_str": mp.nstr(b, 22),
        "log2_base_exact": str(l2_exact) if l2_exact is not None else None,
        "log2_base": float(l2_mpf),
        "r_max": r_max,
        "r_thick": r_thick,
        "n_cells_at_d_ge_1": n_cells,
        "n_resolved": n_res,
        "locked_r_max": locked_r_max,
        "locked_cells_at_d_ge_1": locked_cells,
        "locked_r_thick": locked_r_thick,
        "locked_resolved_cells": locked_resolved,
        "geometry_matches_locked": (r_max == locked_r_max
                                    and n_cells == locked_cells
                                    and r_thick == locked_r_thick
                                    and n_res == locked_resolved),
        "root_selfcheck_failures": root_bad,
        "n_zeros_resolved": len(zeros),
        "zeros": zeros,
        "probes": probes,
    }, l2_exact, l2_mpf


# ---------------------------------------------------------------------------
# window overlap
# ---------------------------------------------------------------------------

def overlap_pair(a, b, l2a, l2b):
    """Overlap of two log2 windows.  Exact Fractions when BOTH bases have an
    exact log2; mpf at dps DPS otherwise.  Returns a dict; the two fractions
    are overlap / length of the shorter and of the longer window."""
    exact = (l2a[0] is not None and l2b[0] is not None)
    if exact:
        la, ha = (a["r"] - a["d"]) * l2a[0], a["r"] * l2a[0]
        lb, hb = (b["r"] - b["d"]) * l2b[0], b["r"] * l2b[0]
        zero = Fraction(0)
    else:
        la = (a["r"] - a["d"]) * (l2a[0] if l2a[0] is not None else l2a[1])
        ha = a["r"] * (l2a[0] if l2a[0] is not None else l2a[1])
        lb = (b["r"] - b["d"]) * (l2b[0] if l2b[0] is not None else l2b[1])
        hb = b["r"] * (l2b[0] if l2b[0] is not None else l2b[1])
        la, ha, lb, hb = _to_mpf(la), _to_mpf(ha), _to_mpf(lb), _to_mpf(hb)
        zero = mpf(0)
    lo = la if la > lb else lb
    hi = ha if ha < hb else hb
    ov = (hi - lo) if hi > lo else zero
    len_a = ha - la
    len_b = hb - lb
    short = len_a if len_a < len_b else len_b
    long_ = len_a if len_a > len_b else len_b
    f_short = (ov / short) if short > 0 else None
    f_long = (ov / long_) if long_ > 0 else None
    return {
        "exact": bool(exact),
        "overlap_log2": float(ov),
        "len_a_log2": float(len_a),
        "len_b_log2": float(len_b),
        "frac_of_shorter": (float(f_short) if f_short is not None else None),
        "frac_of_longer": (float(f_long) if f_long is not None else None),
        "frac_of_shorter_str": (_fmt(f_short, 8) if f_short is not None
                                else "-"),
        "frac_of_longer_str": (_fmt(f_long, 8) if f_long is not None else "-"),
        "over_half_of_shorter": bool(f_short is not None
                                     and f_short > (Fraction(1, 2) if exact
                                                    else mpf(1) / 2)),
        "over_half_of_both": bool(f_short is not None and f_long is not None
                                  and f_long > (Fraction(1, 2) if exact
                                                else mpf(1) / 2)),
    }


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def parse_probe_cells(spec):
    """'40,12;34,11;42,5' -> [(40,12),(34,11),(42,5)]"""
    out = []
    for chunk in spec.split(";"):
        chunk = chunk.strip()
        if not chunk:
            continue
        r_s, d_s = chunk.split(",")
        out.append((int(r_s), int(d_s)))
    return out


def main():
    ap = argparse.ArgumentParser(
        description="O47 - high-mass zeros (EXPLORATORY; not a verdict)")
    ap.add_argument("--o45", type=str, default=DEFAULT_O45,
                    help="path to O45_sub_integer_base_scan.py, imported "
                         "read-only for geometry/table/mass routines")
    ap.add_argument("--o46", type=str, default=DEFAULT_O46,
                    help="path to O46_mass_density_check.py, imported "
                         "read-only for build_mass_table()")
    ap.add_argument("--o45-json", type=str, default=DEFAULT_O45_JSON,
                    help="results/sub_integer_base_scan.json, READ ONLY, the "
                         "zeros this run is checked against")
    ap.add_argument("--o46-json", type=str, default=DEFAULT_O46_JSON,
                    help="results/mass_density_check.json, READ ONLY, quoted "
                         "for the median-S context")
    ap.add_argument("--prereg", type=str, default=DEFAULT_PREREG,
                    help="prereg path; recorded with its sha256, not modified")
    ap.add_argument("--top-n", type=int, default=25,
                    help="how many pooled zeros to tabulate by S")
    ap.add_argument("--top-window", type=int, default=10,
                    help="how many pooled zeros enter the log2-window "
                         "overlap analysis")
    ap.add_argument("--probe-base", type=str, default="2**(1/2)",
                    help="base label whose probe cells are reported in "
                         "full (question 6)")
    ap.add_argument("--probe-cells", type=str, default="40,12;34,11;42,5",
                    help="probe cells as 'r,d;r,d;...' at --probe-base")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT,
                    help="results JSON path")
    ap.add_argument("--overwrite", action="store_true", default=False,
                    help="permit overwriting an existing --out; off by "
                         "default, so an existing artifact is never clobbered")
    ap.add_argument("--no-json", action="store_true", default=False,
                    help="print the report and write no JSON")
    args = ap.parse_args()

    o45_path = _resolve(args.o45)
    o46_path = _resolve(args.o46)
    o45_json = _resolve(args.o45_json)
    o46_json = _resolve(args.o46_json)
    prereg_path = _resolve(args.prereg)
    out_path = _resolve(args.out)

    if (not args.no_json) and os.path.exists(out_path) and not args.overwrite:
        print(f"REFUSING to overwrite existing {out_path}; pass --overwrite "
              f"only if that is intended.", flush=True)
        return 2

    mp.dps = DPS
    started = datetime.datetime.now(datetime.timezone.utc)

    o45 = load_module(o45_path, "o45_sub_integer_base_scan")
    o46 = load_module(o46_path, "o46_mass_density_check")
    gamma1 = mpf(o45.GAMMA1_STR)
    pi_fn, pi_name, pi_ver = o45.load_pi_backend()
    pi_cache = {}
    probe_cells = parse_probe_cells(args.probe_cells)
    findings = []

    print(RULE)
    print("O47 - HIGH-MASS ZEROS   (EXPLORATORY - NOT A VERDICT)")
    print(RULE)
    print(f"  started (UTC)          : "
          f"{started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  status                 : {STATUS}")
    print(f"  reads O45 script       : {o45_path}")
    print(f"  reads O46 script       : {o46_path}")
    print(f"  reads O45 results      : {o45_json}")
    print(f"  reads O46 results      : {o46_json}")
    print(f"  prereg (context only)  : {prereg_path}")
    print(f"  stratum                : O45's resolved_criterion, "
          f"r - d >= r_thick(b), d >= {o45.D_MIN}")
    print(f"  value ceiling          : 2^{o45.VALUE_CEILING_EXP} = "
          f"{o45.VALUE_CEILING}")
    print(f"  pi backend             : {pi_name} {pi_ver}")
    print(f"  mpmath dps             : {DPS}")
    print(f"  ranking key            : S, exact int; tiebreak (base, r, d)")
    print(f"  top-n / top-window     : {args.top_n} / {args.top_window}")
    print(f"  probe                  : base {args.probe_base} cells "
          f"{probe_cells}")
    print(f"  out                    : {out_path}")
    print(f"  python                 : {sys.version.split()[0]}")
    print(f"  code_version (sha256)  : "
          f"{_code_version(os.path.abspath(__file__))}")
    print()
    print("  This script is EXPLORATORY.  It tests no preregistered")
    print("  hypothesis, computes no p-value, and stamps nothing.  Nothing")
    print("  printed here is a verdict.  It re-runs nothing: O45 and O46 are")
    print("  imported read-only and their result files are opened read-only.")
    print(flush=True)

    print(THIN)
    print("WHAT S IS, AND WHY THE HIGH END IS THE INTERESTING END")
    print(THIN)
    print("  mass_bound (prereg, locked, exact):  |cell(r,d)| <= S(r,d),")
    print("  S(r,d) = sum_k C(d,k) N(r-k), the unsigned prime stencil mass.")
    print("  S is therefore the amount of prime mass the alternating sum had")
    print("  to annihilate to land on zero.  O46 found the median S at a")
    print("  resolved zero is 8-516 against a stratum median of 1e8-1e18, so")
    print("  the typical zero is a cell with almost nothing to cancel.  The")
    print("  high-S zeros are the ones where a large mass cancelled exactly.")
    print(flush=True)

    # ---------------- source files ------------------------------------------
    source_files = []
    for p, role in ((o45_path, "o45_script"), (o46_path, "o46_script"),
                    (o45_json, "o45_results"), (o46_json, "o46_results"),
                    (prereg_path, "prereg")):
        if os.path.exists(p):
            source_files.append(file_record(p, {"role": role}))
        else:
            findings.append(f"missing input: {p} ({role})")

    with open(o45_json) as fh:
        o45_res = json.load(fh)
    o45_by_label = {p["label"]: p for p in o45_res["summary"]["per_base"]}
    o46_by_label = {}
    if os.path.exists(o46_json):
        with open(o46_json) as fh:
            o46_res = json.load(fh)
        for p in o46_res.get("summary", {}).get("per_base", []):
            o46_by_label[p["label"]] = p

    # ---------------- the scan ----------------------------------------------
    per_base = []
    log2_by_label = {}
    pooled = []
    for idx, (arm, label, kind, l_rmax, l_cells, l_rthick,
              l_res) in enumerate(o45.LOCKED_BASES):
        print(f"  scanning {label} ...", flush=True)
        rec, l2e, l2m = scan_base(
            o45, o46, idx, arm, label, kind,
            (l_rmax, l_cells, l_rthick, l_res), gamma1, pi_fn, pi_cache,
            probe_cells if label == args.probe_base else ())
        log2_by_label[label] = (l2e, l2m)
        ref = o45_by_label.get(label)
        rec["o45_n_resolved_cells"] = ref["n_resolved_cells"] if ref else None
        rec["o45_n_exact_zeros_resolved"] = (ref["n_exact_zeros_resolved"]
                                             if ref else None)
        # coordinate-by-coordinate and S-by-S match against O45's record
        mine = sorted((z["r"], z["d"], z["S"]) for z in rec["zeros"])
        theirs = sorted((z["r"], z["d"], z["S"]) for z in
                        (ref["exact_zeros"] if ref else []) if z["resolved"])
        rec["matches_o45_zeros"] = (mine == theirs)
        if not rec["matches_o45_zeros"]:
            findings.append(
                f"zero-set drift at base {label}: rebuilt {len(mine)} "
                f"resolved zeros, O45 recorded {len(theirs)}; "
                f"coordinate/S lists differ")
        if not rec["geometry_matches_locked"]:
            findings.append(
                f"geometry drift at base {label}: got (r_max={rec['r_max']}, "
                f"cells={rec['n_cells_at_d_ge_1']}, "
                f"r_thick={rec['r_thick']}, resolved={rec['n_resolved']}) vs "
                f"locked ({l_rmax}, {l_cells}, {l_rthick}, {l_res})")
        if rec["root_selfcheck_failures"]:
            findings.append(
                f"exact-root self-check failed at base {label}: "
                f"{rec['root_selfcheck_failures']} values")
        o46ref = o46_by_label.get(label)
        rec["o46_S_median_resolved_str"] = (
            o46ref.get("S_median_resolved_str") if o46ref else None)
        rec["o46_S_median_at_resolved_zeros_str"] = (
            o46ref.get("S_median_at_resolved_zeros_str") if o46ref else None)
        per_base.append(rec)
        pooled.extend(rec["zeros"])

    print()
    print(RULE)
    print("0.  INTEGRITY  (this run against O45's locked table and its JSON)")
    print(RULE)
    print(f"  {'arm':<11}{'label':<20}{'r_max':>6}{'r_thick':>8}"
          f"{'resolved':>10}{'zeros':>7}  {'geom':>5} {'zeros=O45':>10}")
    for rec in per_base:
        print(f"  {rec['arm']:<11}{rec['label']:<20}{rec['r_max']:>6}"
              f"{rec['r_thick']:>8}{rec['n_resolved']:>10}"
              f"{rec['n_zeros_resolved']:>7}  "
              f"{('yes' if rec['geometry_matches_locked'] else 'NO'):>5} "
              f"{('yes' if rec['matches_o45_zeros'] else 'NO'):>10}")
    n_pool = len(pooled)
    print(f"\n  pooled resolved zeros at d >= 1, all eleven bases: {n_pool}")
    print(f"  findings                                          : "
          f"{len(findings)}")
    for f in findings:
        print(f"    - {f}")
    print(flush=True)

    # ---------------- the pooled ranking -------------------------------------
    pooled.sort(key=lambda z: (-z["S"], z["base_index"], z["r"], z["d"]))
    for rank, z in enumerate(pooled, start=1):
        z["pooled_rank"] = rank

    print(RULE)
    print(f"1.  TOP {args.top_n} POOLED RESOLVED ZEROS BY STENCIL MASS S")
    print(RULE)
    print("  window = (b^(r-d), b^r], as powers of 2; pi(win) = primes in it;")
    print("  pi(span) = primes in the full stencil span (b^(r-d-1), b^r].")
    print()
    print(f"  {'#':>3} {'arm':<11}{'label':<20}{'r':>4}{'d':>4}{'r-d':>5}"
          f"{'S':>14} {'log2 window':>20}{'pi(win)':>10}{'pi(span)':>10}")
    for z in pooled[:args.top_n]:
        win = f"[{z['window_lo_log2']:.4f}, {z['window_hi_log2']:.4f}]"
        print(f"  {z['pooled_rank']:>3} {z['arm']:<11}{z['label']:<20}"
              f"{z['r']:>4}{z['d']:>4}{z['r_minus_d']:>5}"
              f"{z['S']:>14} {win:>20}{z['n_primes_in_window']:>10}"
              f"{z['n_primes_in_stencil_span']:>10}")
    print(flush=True)

    print("  the same rows with the integer window bounds:")
    print(f"  {'#':>3} {'label':<20}{'(r,d)':>10}{'S':>14}"
          f"{'win lo (int)':>16}{'win hi (int)':>16}")
    for z in pooled[:args.top_n]:
        print(f"  {z['pooled_rank']:>3} {z['label']:<20}"
              f"{('(%d,%d)' % (z['r'], z['d'])):>10}{z['S']:>14}"
              f"{z['window_lo_int']:>16}{z['window_hi_int']:>16}")
    print(flush=True)

    # ---------------- the break ---------------------------------------------
    print(RULE)
    print("2.  IS THERE A NATURAL BREAK?")
    print(RULE)
    gaps = []
    for i in range(len(pooled) - 1):
        hi, lo = pooled[i]["S"], pooled[i + 1]["S"]
        if lo <= 0:
            continue
        gaps.append({
            "above_rank": pooled[i]["pooled_rank"],
            "below_rank": pooled[i + 1]["pooled_rank"],
            "S_above": hi,
            "S_below": lo,
            "ratio": Fraction(hi, lo),
            "above": f"{pooled[i]['label']} ({pooled[i]['r']},"
                     f"{pooled[i]['d']})",
            "below": f"{pooled[i + 1]['label']} ({pooled[i + 1]['r']},"
                     f"{pooled[i + 1]['d']})",
        })
    gaps_sorted = sorted(gaps, key=lambda g: (-g["ratio"], g["above_rank"]))
    print(f"  consecutive ratios S_i / S_(i+1) over all {n_pool} pooled")
    print(f"  resolved zeros, computed as exact Fractions.  The ten largest:")
    print()
    print(f"  {'cut after #':>12}{'S above':>16}{'S below':>16}"
          f"{'ratio':>12}   above / below")
    for g in gaps_sorted[:10]:
        print(f"  {g['above_rank']:>12}{g['S_above']:>16}{g['S_below']:>16}"
              f"{_fmt(g['ratio'], 6):>12}   {g['above']} / {g['below']}")
    print()
    top_gaps = [g for g in gaps if g["above_rank"] <= args.top_n]
    if top_gaps:
        biggest_top = max(top_gaps, key=lambda g: g["ratio"])
        print(f"  largest ratio inside the top {args.top_n}: "
              f"{_fmt(biggest_top['ratio'], 6)} at the cut after rank "
              f"{biggest_top['above_rank']}")
        print(f"    {biggest_top['above']}  S = {biggest_top['S_above']}")
        print(f"    {biggest_top['below']}  S = {biggest_top['S_below']}")
    print()
    print("  Whether any of these is a BREAK rather than the largest step in")
    print("  a smooth profile is a reading, not a computation.  The numbers")
    print("  above are the whole of what this script asserts.")
    print(flush=True)

    # ---------------- base 2 ------------------------------------------------
    print(RULE)
    print("3.  BASE 2'S FOUR, IN THE POOLED LIST")
    print(RULE)
    b2 = [z for z in pooled if z["label"] == "2"]
    print(f"  {'pooled #':>9}{'(r,d)':>10}{'r-d':>5}{'S':>12}"
          f"{'log2 window':>20}{'pi(win)':>10}{'pi(span)':>10}")
    for z in b2:
        win = f"[{z['window_lo_log2']:.4f}, {z['window_hi_log2']:.4f}]"
        print(f"  {z['pooled_rank']:>9}{('(%d,%d)' % (z['r'], z['d'])):>10}"
              f"{z['r_minus_d']:>5}{z['S']:>12}{win:>20}"
              f"{z['n_primes_in_window']:>10}"
              f"{z['n_primes_in_stencil_span']:>10}")
    print(f"\n  pooled list length: {n_pool}")
    print(flush=True)

    # ---------------- above (20,6) ------------------------------------------
    print(RULE)
    print(f"4.  ZEROS ABOVE BASE 2's (20,6),  S = {B2_TOP_S}")
    print(RULE)
    above = [z for z in pooled if z["S"] > B2_TOP_S]
    if not above:
        print(f"  none.  (20,6) at S = {B2_TOP_S} is the pooled maximum.")
    else:
        print(f"  {len(above)} zero(s) exceed it:")
        for z in above:
            print()
            print(f"    {z['label']}  ({z['arm']})   b = {z['b_str']}")
            print(f"      (r, d)              : ({z['r']}, {z['d']})   "
                  f"r - d = {z['r_minus_d']}   r_thick = {z['r_thick']}")
            print(f"      pooled rank         : {z['pooled_rank']} of "
                  f"{n_pool}")
            print(f"      S                   : {z['S']}")
            print(f"      S / 492384          : "
                  f"{_fmt(Fraction(z['S'], B2_TOP_S), 8)}   (exact Fraction "
                  f"{Fraction(z['S'], B2_TOP_S)})")
            print(f"      window (b^(r-d), b^r] : ({z['window_lo_int']}, "
                  f"{z['window_hi_int']}]")
            print(f"      window in log2      : [{z['window_lo_log2']:.6f}, "
                  f"{z['window_hi_log2']:.6f}]   width "
                  f"{z['window_len_log2']:.6f}")
            print(f"      primes in window    : {z['n_primes_in_window']}")
            print(f"      primes in span      : "
                  f"{z['n_primes_in_stencil_span']}")
    print(flush=True)

    # ---------------- windows -----------------------------------------------
    print(RULE)
    print(f"5.  THE TOP {args.top_window} AS INTERVALS IN log2(x)")
    print(RULE)
    topw = pooled[:args.top_window]
    print(f"  {'#':>3} {'label':<20}{'(r,d)':>10}{'lo':>11}{'hi':>11}"
          f"{'width':>10}{'S':>14}")
    for z in topw:
        print(f"  {z['pooled_rank']:>3} {z['label']:<20}"
              f"{('(%d,%d)' % (z['r'], z['d'])):>10}"
              f"{z['window_lo_log2']:>11.5f}{z['window_hi_log2']:>11.5f}"
              f"{z['window_len_log2']:>10.5f}{z['S']:>14}")
    print()
    pairs = []
    for i in range(len(topw)):
        for j in range(i + 1, len(topw)):
            a, b_ = topw[i], topw[j]
            ov = overlap_pair(a, b_, log2_by_label[a["label"]],
                              log2_by_label[b_["label"]])
            ov["a_rank"], ov["b_rank"] = a["pooled_rank"], b_["pooled_rank"]
            ov["a"] = f"{a['label']} ({a['r']},{a['d']})"
            ov["b"] = f"{b_['label']} ({b_['r']},{b_['d']})"
            pairs.append(ov)
    flagged = [p for p in pairs if p["over_half_of_shorter"]]
    print(f"  {len(pairs)} pairs; {len(flagged)} overlap by more than half "
          f"the SHORTER window.")
    if flagged:
        print(f"  {'a':>4}{'b':>4}  {'overlap':>10}{'of shorter':>12}"
              f"{'of longer':>11}  {'exact?':>7}  pair")
        for p in sorted(flagged,
                        key=lambda p: (-p["frac_of_shorter"], p["a_rank"])):
            print(f"  {p['a_rank']:>4}{p['b_rank']:>4}  "
                  f"{p['overlap_log2']:>10.5f}"
                  f"{p['frac_of_shorter_str']:>12}"
                  f"{p['frac_of_longer_str']:>11}  "
                  f"{('yes' if p['exact'] else 'dps%d' % DPS):>7}  "
                  f"{p['a']}  vs  {p['b']}")
    both = [p for p in flagged if p["over_half_of_both"]]
    print(f"\n  of those, {len(both)} overlap by more than half of BOTH "
          f"windows.")
    for p in both:
        print(f"    ranks {p['a_rank']} and {p['b_rank']}: {p['a']}  vs  "
              f"{p['b']}   overlap {p['overlap_log2']:.5f} "
              f"(shorter {p['frac_of_shorter_str']}, longer "
              f"{p['frac_of_longer_str']})")
    print(flush=True)

    # ---------------- the probe ---------------------------------------------
    print(RULE)
    print(f"6.  PROBE CELLS AT BASE {args.probe_base}")
    print(RULE)
    prec = next((r for r in per_base if r["label"] == args.probe_base), None)
    if prec is None:
        print(f"  base {args.probe_base} is not in O45's LOCKED_BASES; "
              f"nothing to probe.")
        findings.append(f"probe base {args.probe_base} not in LOCKED_BASES")
    else:
        print(f"  b = {prec['b_str']}   log2(b) = "
              f"{prec['log2_base_exact'] or _fmt(prec['log2_base'], 12)}   "
              f"r_thick = {prec['r_thick']}   r_max = {prec['r_max']}")
        print()
        for p in prec["probes"]:
            if not p.get("on_support"):
                print(f"  ({p['r']}, {p['d']}) : {p['note']}")
                continue
            print(f"  ({p['r']}, {p['d']})")
            print(f"      cell value          : {p['cell']}")
            print(f"      is exactly zero     : "
                  f"{'YES' if p['is_zero'] else 'no'}")
            print(f"      S                   : {p['S']}")
            print(f"      |cell| / S          : {p['abs_cell_over_S_str']}")
            print(f"      r - d               : {p['r_minus_d']}   "
                  f"resolved (r-d >= {prec['r_thick']}): "
                  f"{'yes' if p['resolved'] else 'NO'}")
            print(f"      window (b^(r-d), b^r] : ({p['window_lo_int']}, "
                  f"{p['window_hi_int']}]")
            print(f"      window in log2      : [{p['window_lo_log2']:.6f}, "
                  f"{p['window_hi_log2']:.6f}]")
            print(f"      primes in window    : {p['n_primes_in_window']}")
            print(f"      primes in span      : "
                  f"{p['n_primes_in_stencil_span']}")
            print(f"      S == O45 stencil_mass : "
                  f"{p['S_matches_o45_stencil_mass']}")
            if p["is_zero"]:
                z = next((q for q in pooled
                          if q["label"] == args.probe_base
                          and q["r"] == p["r"] and q["d"] == p["d"]), None)
                if z:
                    print(f"      pooled rank         : {z['pooled_rank']} "
                          f"of {n_pool}")
            print()
        # the comparison the probe exists for
        b2_206 = next((z for z in b2 if (z["r"], z["d"]) == (20, 6)), None)
        p4012 = next((p for p in prec["probes"]
                      if p.get("on_support") and (p["r"], p["d"]) == (40, 12)),
                     None)
        if b2_206 and p4012:
            print("  base 2 (20,6) vs base 2^(1/2) (40,12) - same window?")
            print(f"    base 2      window : ({b2_206['window_lo_int']}, "
                  f"{b2_206['window_hi_int']}]   log2 "
                  f"[{b2_206['window_lo_log2']:.6f}, "
                  f"{b2_206['window_hi_log2']:.6f}]")
            print(f"    base 2^(1/2) window: ({p4012['window_lo_int']}, "
                  f"{p4012['window_hi_int']}]   log2 "
                  f"[{p4012['window_lo_log2']:.6f}, "
                  f"{p4012['window_hi_log2']:.6f}]")
            print(f"    identical integer bounds: "
                  f"{b2_206['window_lo_int'] == p4012['window_lo_int'] and b2_206['window_hi_int'] == p4012['window_hi_int']}")
            print(f"    base 2 (20,6)      : cell = 0, S = {b2_206['S']}")
            print(f"    base 2^(1/2) (40,12): cell = {p4012['cell']}, "
                  f"S = {p4012['S']}")
    print(flush=True)

    print(RULE)
    print("END - EXPLORATORY.  No verdict is stamped here and none is "
          "implied.")
    print(RULE, flush=True)

    if args.no_json:
        return 0

    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.basename(__file__),
        "script_path": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "params": {
            "code_version": _code_version(os.path.abspath(__file__)),
            "argv": sys.argv,
            "status": STATUS,
            "status_note": (
                "EXPLORATORY. Not preregistered. No hypothesis is tested, no "
                "p-value is computed and no verdict label is selected. "
                "CLAUDE.md, section 'Prereg discipline': numbers produced "
                "outside prereg discipline are exploratory and must be "
                "labelled as such."),
            "run_start_utc": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "dps": DPS,
            "d_min": o45.D_MIN,
            "value_ceiling_exp": o45.VALUE_CEILING_EXP,
            "value_ceiling": o45.VALUE_CEILING,
            "gamma_1": o45.GAMMA1_STR,
            "pi_backend": pi_name,
            "pi_backend_version": pi_ver,
            "n_distinct_pi_arguments": len(pi_cache),
            "top_n": args.top_n,
            "top_window": args.top_window,
            "probe_base": args.probe_base,
            "probe_cells": [list(t) for t in probe_cells],
            "prereg_context_only": os.path.relpath(prereg_path, _HERE),
            "source_files": source_files,
            "python": sys.version,
        },
        "constants": {
            "convention": o45.CONVENTION,
            "mass_bound": ("|cell(r,d)| <= S(r,d), S(r,d) = sum_k C(d,k) "
                           "N(r-k); exact, from the prereg"),
            "resolved_criterion": ("d >= 1 and r - d >= r_thick(b), "
                                   "r_thick from O45's r_thick_of()"),
            "mass_floor": o45.MASS_FLOOR,
            "base_two_top_S": B2_TOP_S,
            "window_definition": ("window = (b^(r-d), b^r]; stencil span = "
                                  "(b^(r-d-1), b^r], one rung wider at the "
                                  "bottom, the full support the stencil "
                                  "reads"),
            "ranking_key": ("S, exact Python int, descending; tiebreak "
                            "(base_index, r, d).  No float64 quantity is "
                            "ranked."),
        },
        "summary": {
            "n_bases": len(per_base),
            "n_pooled_resolved_zeros": n_pool,
            "findings": findings,
            "all_geometry_matches_locked": all(
                r["geometry_matches_locked"] for r in per_base),
            "all_zero_sets_match_o45": all(
                r["matches_o45_zeros"] for r in per_base),
            "per_base": [{k: v for k, v in r.items()
                          if k not in ("zeros",)} for r in per_base],
            "top_n_by_S": pooled[:args.top_n],
            "gaps_top_10_by_ratio": [
                {**{k: v for k, v in g.items() if k != "ratio"},
                 "ratio": float(g["ratio"]),
                 "ratio_exact": f"{g['ratio'].numerator}/"
                                f"{g['ratio'].denominator}"}
                for g in gaps_sorted[:10]],
            "base_two_zeros_pooled": b2,
            "zeros_above_base_two_top": above,
            "top_window_overlaps": pairs,
            "top_window_overlaps_over_half_shorter": flagged,
            "top_window_overlaps_over_half_both": both,
            "probe_base": args.probe_base,
            "probe_cells": (prec["probes"] if prec else []),
            "verdict": None,
            "verdict_note": ("EXPLORATORY: there is no verdict here. This "
                             "script is not preregistered and does not stamp "
                             "one."),
        },
        "rows": pooled,
    }
    _write_results(payload, out_path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
