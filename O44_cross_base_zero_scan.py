#!/usr/bin/env python3
"""
O44 — cross-base zero and near-zero scan of the eight imported b-adic
      difference tables, measured in the scale coordinate the pair identity
      supplies. No primes are counted here; every number is read from a CSV.

STATUS: EXPLORATORY.  There is no prereg for this measurement, no hypothesis
is stated, no decision rule is defined and none fires.  Nothing this script
prints is a verdict, and nothing it prints settles anything or supports any
reading.  CLAUDE.md § "Prereg discipline": a test earns a verdict only under
a locked prereg; everything else is exploratory and must be labelled so.  This
script is one of the exploratory ones.  Which tests are preregistered, and what
verdict each carries, is in CONTEXT.md § "Current state of the world" -- not
enumerated here, because an enumeration goes stale and the one this docstring
used to quote did.

Reads with: imported/lattice_mapper/README.md  (the import manifest and the
                                                convention statement)
            CONTEXT.md § `imported/lattice_mapper/`
            lean/PairIdentity.lean  (pair_identity, coeff_eq_one_iff_base_two)
            lab_notebook_2.md entry 47  (the convention check this follows)
            lab_notebook.md entry 17  ("reaches 1, twice", triadic)
            O33_base_ladder_crossing.py  (table reader, source schema, house
                                          plumbing — reused, not imported)

=============================================================================
WHY A SCALE COORDINATE, AND WHY NOT r, d OR r - d
=============================================================================

`lean/PairIdentity.lean` proves the pair identity

    prime(r,d) + composite(r,d) = (b-1)^(d+1) * b^(r-1-d)

exact at every cell in every base, with no hypothesis about primes anywhere
in the proof.  The right side is the TOTAL a cell holds: the number of
integers the differenced window carries.  Call it

    total(b,r,d) = (b-1)^(d+1) * b^(r-1-d)

and its logarithm the SCALE of the cell,

    s(b,r,d) = (d+1)*log(b-1) + (r-1-d)*log b        [natural log; s = log total]

At b = 2 the first term is (d+1)*log(1) = 0, so s = (r-1-d)*log 2 and the
scale depends on r - d alone.  That is the arithmetic reason r - d emerged as
the coordinate for the dyadic table, and it is the same fact as
`PairIdentity.coeff_eq_one_iff_base_two`: (b-1)^(d+1) = 1 exactly when b = 2.
For every other base both terms are live and r - d does not determine the
scale.  So r, d and r - d are base-2 conveniences.  A comparison ACROSS bases
has to be made in s.

The same identity is why raw |cell| is not comparable either.  |cell| = 1
against a total of 4 and |cell| = 1 against a total of 10^6 are not the same
measurement.  The normalised magnitude

    nu(b,r,d) = |cell(b,r,d)| / total(b,r,d)

divides the total out.  nu = 0 exactly at an exact zero; nu = 1 would be a
cell holding the whole total on one arm.  nu IS THE HEADLINE MEASUREMENT
here.  It is computed as an exact Fraction of exact Python integers and only
then converted to float for printing, so the ranking never depends on
floating point.

=============================================================================
THE CONVENTION, STATED AND NOT ADJUSTED FOR
=============================================================================

Every table read here uses the imported convention:

  power-regime BACKWARD differences, A(n) = pi(b^n) - pi(b^(n-1)), with the
  primes 2 AND 3 EXCLUDED AS LATTICE rather than counted as primes.
  A(1) = pi(b) - 2 for b >= 3; at b = 2 the two lattice primes straddle the
  regime boundary (2 in (1,2], 3 in (2,4]) so one is dropped from each of
  A(1) and A(2).

  -- imported/lattice_mapper/README.md § Convention

This script does NOT silently add the two primes back and does NOT adjust for
the convention in any other way.  (O33 does add them back; that is O33's
choice, made for its own crossing measurement, and it is not made here.)  The
convention is stated in the console output and recorded in the JSON at
constants.convention.  CONTEXT.md § `imported/lattice_mapper/` is explicit
that a number lifted from `imported/` and a number lifted from `results/` are
NOT comparable at low r without stating which convention is in force; the
statement is the whole of the handling.

Consequence worth naming: cell (2,1) is convention-mobile (entry 47), so its
appearance or absence in any list below is a fact about the seed rows, not
about cancellation.

=============================================================================
WHAT IS MEASURED, IN THE ORDER IT IS REPORTED
=============================================================================

  1  EXTENT AND EXACT ZEROS.  Per base: max regime, max depth, cell count at
     all depths and at d >= --d-min, and the full list of exact zeros at
     d >= --d-min with their (r,d).  The eight tables have DIFFERENT depths
     (regime ceilings 32,32,32,27,24,22,21,20 for b = 2..9), so the scopes
     are not equal and each base's extent is printed beside its counts.

  2  NORMALISED MAGNITUDE nu.  Per base: min nu over d >= --d-min and where
     it occurs; min NONZERO nu and where; and the --top-k smallest nu with
     coordinates, |cell|, total and s.  The total is printed at every listed
     cell so that a cell reading |cell| = 1 can be read against what 1 is
     being compared to.

  3  SCALE COORDINATE s.  s is reported at every exact zero and at every
     cell in every base's --top-k list, and the union is printed once more
     sorted by s so that the cross-base picture is in one place.  Per-base s
     range over the whole d >= --d-min support is printed alongside, because
     a base cannot show a near-zero at a scale its table does not reach.
     The script draws no conclusion from any of this.

  4  PAIR-IDENTITY CHECK.  Where both arms exist on disk (the dyadic files),
     prime(r,d) + composite(r,d) is compared to 2^(r-1-d) cell by cell, and
     cells-checked plus mismatches are reported.  A mismatch is reported as a
     mismatch.  Three matched checks are locked in PAIR_CHECKS below; a
     fourth, labelled scan over the SILENCED composite variants is reported
     separately and is EXPECTED to mismatch, because those files are not
     paired with the plain prime arm (entry 47 records that the six composite
     variants differ in A_count at r = 1,2,3).  It is printed so the
     expectation is on the record rather than assumed.

=============================================================================
ARITHMETIC
=============================================================================

Exact Python integers for every cell value and every total; exact
fractions.Fraction for every nu used in a comparison or a sort.  numpy is not
imported.  Floats appear only in s and in the printed/JSON value of nu, never
in a ranking.  No randomness anywhere: no Monte Carlo, no resampling, no
--seed flag and nothing to seed.

=============================================================================
OUTPUTS
=============================================================================

results/cross_base_zero_scan.json   house envelope, schema_version "1":
                                    script, generated_utc, params, constants,
                                    summary, rows.  params.code_version is the
                                    sha256 of THIS file, read at run time --
                                    CONTEXT.md records the known weakness that
                                    this is a write-time not an import-time
                                    read.  params.source_files records every
                                    file opened, with sha256, bytes and mtime,
                                    as O33 does.

Console output is the human-readable summary; tee it to
results/O44_cross_base_zero_scan_run1.log.

Every path is anchored to _HERE, so runs are cwd-independent.  Nothing under
imported/ is opened for anything but reading.

HOW IT WAS RUN
--------------
    .venv/bin/python O44_cross_base_zero_scan.py \
        --data-dir imported/lattice_mapper/32bit \
        --bases 2,3,4,5,6,7,8,9 \
        --d-min 1 \
        --top-k 10 \
        --pair-check \
        --variant-scan \
        --out results/cross_base_zero_scan.json \
        2>&1 | tee results/O44_cross_base_zero_scan_run1.log

Every flag is passed explicitly.  --data-dir is resolved against _HERE when
relative, so the line above is cwd-independent too.

REQUIREMENTS: standard library only.
"""

import argparse
import csv
import datetime
import hashlib
import json
import math
import os
import sys
from fractions import Fraction

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_DATA_DIR = os.path.join(_HERE, "imported", "lattice_mapper", "32bit")
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "cross_base_zero_scan.json")

RULE = "=" * 78
THIN = "-" * 78

# ---------------------------------------------------------------------------
# LOCKED, NOT FLAGS
# ---------------------------------------------------------------------------

# lattice_mapper/difference_table.py naming, as O33 records it.  A naming
# convention of the source project, not a parameter of this measurement.
BASE_FILES = {
    2: "dyadic_difference_table_32.csv",
    3: "triadic_difference_table_32.csv",
    4: "tetradic_difference_table_32.csv",
    5: "pentadic_difference_table_27.csv",
    6: "hexadic_difference_table_24.csv",
    7: "heptadic_difference_table_22.csv",
    8: "octadic_difference_table_21.csv",
    9: "enneadic_difference_table_20.csv",
}
BASE_NAMES = {2: "dyadic", 3: "triadic", 4: "tetradic", 5: "pentadic",
              6: "hexadic", 7: "heptadic", 8: "octadic", 9: "enneadic"}

# The convention statement, quoted from imported/lattice_mapper/README.md
# § Convention.  Printed and stored; NOT adjusted for.
CONVENTION = (
    "Power-regime BACKWARD differences, A(n) = pi(b^n) - pi(b^(n-1)), with "
    "the primes 2 AND 3 EXCLUDED AS LATTICE rather than counted as primes: "
    "A(1) = pi(b) - 2 for b >= 3, and at b = 2 the two lattice primes "
    "straddle the regime boundary (2 in (1,2], 3 in (2,4]) so one is dropped "
    "from each of A(1) and A(2). "
    "Source: imported/lattice_mapper/README.md, section Convention. "
    "THIS SCRIPT DOES NOT ADJUST FOR IT. Numbers here are therefore not "
    "comparable at low r with numbers in results/, which count 2 and 3 "
    "(CONTEXT.md, section imported/lattice_mapper/)."
)

# Matched prime/composite pairs on disk.  Each is (label, prime_file,
# composite_file, mode).  mode "sum" checks P + C == 2^(r-1-d); mode
# "diff_plus_2p" checks (C-P) + 2P == 2^(r-1-d), which is the same identity
# read through composite_minus_prime_32.csv.
PAIR_CHECKS = (
    ("plain prime + plain composite",
     "dyadic_difference_table_32.csv",
     "dyadic_composite_difference_table_32.csv", "sum"),
    ("prime_full_silenced + plain composite",
     "dyadic_prime_full_silenced_32.csv",
     "dyadic_composite_difference_table_32.csv", "sum"),
    ("plain prime + (composite - prime)",
     "dyadic_difference_table_32.csv",
     "composite_minus_prime_32.csv", "diff_plus_2p"),
)

# NOT matched pairs.  Scanned and reported under an explicit label because an
# unstated expectation is worse than a stated one.  entry 47: the six
# composite variants differ ONLY in A_count at r = 1,2,3, and each silenced
# prime landing in (b, b^2] moves the arm; so these cannot satisfy the
# identity against the UNsilenced prime table and are not expected to.
VARIANT_SCAN_COMPOSITES = (
    "dyadic_composite_difference_table_32_silence46.csv",
    "dyadic_composite_difference_table_32_silence468.csv",
    "dyadic_composite_extended_emptied_32.csv",
    "dyadic_composite_extended_emptied_32_silence46.csv",
    "dyadic_composite_full_silenced_32.csv",
)
VARIANT_SCAN_PRIME = "dyadic_difference_table_32.csv"


# ---------------------------------------------------------------------------
# house plumbing (O33's / O29's, unchanged)
# ---------------------------------------------------------------------------

def _code_version():
    """sha256 of this script file, read at runtime.  CONTEXT.md records the
    known weakness: read at write time, not import time."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
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
    except Exception as exc:                                  # pragma: no cover
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)


# ---------------------------------------------------------------------------
# reading (O33's read_table, with the filename-number check made optional so
# composite_minus_prime_32.csv, whose second column is A_diff, also parses)
# ---------------------------------------------------------------------------

def read_table(path, second_col="A_count"):
    """Return (T, header).  T maps (r, d) -> exact int; d = 0 is the second
    column, d = k is delta_k.  Opened read-only; nothing is written."""
    with open(path, "r", newline="") as fh:
        rdr = csv.reader(fh)
        header = next(rdr)
        body = [row for row in rdr if row and row[0].strip() != ""]
    if header[0].strip().lower() != "regime":
        raise ValueError(f"{path}: first column is {header[0]!r}, expected "
                         f"'regime'")
    if header[1].strip() != second_col:
        raise ValueError(f"{path}: second column is {header[1]!r}, expected "
                         f"{second_col!r}")
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
    if not T:
        raise ValueError(f"{path}: no cells parsed")
    return T, header


def file_record(path, extra=None):
    """sha256 + size + mtime of an input file, O33's params.source_files shape."""
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


# ---------------------------------------------------------------------------
# the coordinate
# ---------------------------------------------------------------------------

def total_at(b, r, d):
    """(b-1)^(d+1) * b^(r-1-d), the pair identity's total.  Exact integer.
    lean/PairIdentity.lean, theorem pair_identity."""
    e = r - 1 - d
    if e < 0:
        raise ValueError(f"cell (r={r}, d={d}) is off support: r-1-d = {e} < 0")
    return (b - 1) ** (d + 1) * b ** e


def scale_at(b, r, d):
    """s(b,r,d) = (d+1)*log(b-1) + (r-1-d)*log b = log total_at(b,r,d).
    At b = 2 the first term vanishes and s = (r-1-d)*log 2."""
    return (d + 1) * math.log(b - 1) + (r - 1 - d) * math.log(b)


# ---------------------------------------------------------------------------
# per-base scan
# ---------------------------------------------------------------------------

def scan_base(b, path, d_min, top_k):
    T, header = read_table(path)
    all_cells = sorted(T)
    off_support = [(r, d) for (r, d) in all_cells if r - 1 - d < 0]
    if off_support:
        raise ValueError(f"{path}: {len(off_support)} cell(s) off support "
                         f"(r-1-d < 0), first {off_support[:5]}")

    sel = [(r, d) for (r, d) in all_cells if d >= d_min]
    recs = []
    for (r, d) in sel:
        v = T[(r, d)]
        tot = total_at(b, r, d)
        nu = Fraction(abs(v), tot)
        recs.append({
            "base": b, "r": r, "d": d,
            "r_minus_d": r - d,
            "cell": v, "abs_cell": abs(v),
            "total": tot,
            "nu": float(nu),
            "nu_exact": nu,
            "s": scale_at(b, r, d),
        })
    recs_sorted = sorted(recs, key=lambda x: (x["nu_exact"], x["r"], x["d"]))

    zeros = [x for x in recs if x["cell"] == 0]
    nonzero_sorted = [x for x in recs_sorted if x["cell"] != 0]

    s_vals = [x["s"] for x in recs]
    summary = {
        "base": b,
        "name": BASE_NAMES[b],
        "file": os.path.basename(path),
        "max_regime": max(r for (r, _) in all_cells),
        "max_depth": max(d for (_, d) in all_cells),
        "n_cells_all_depths": len(all_cells),
        "d_min": d_min,
        "n_cells_at_or_above_d_min": len(sel),
        "n_delta_columns": len(header) - 2,
        "n_exact_zeros": len(zeros),
        "exact_zeros": [{"r": x["r"], "d": x["d"], "total": x["total"],
                         "s": x["s"], "r_minus_d": x["r_minus_d"]}
                        for x in sorted(zeros, key=lambda x: (x["r"], x["d"]))],
        "min_nu": recs_sorted[0]["nu"] if recs_sorted else None,
        "min_nu_at": ({"r": recs_sorted[0]["r"], "d": recs_sorted[0]["d"],
                       "abs_cell": recs_sorted[0]["abs_cell"],
                       "total": recs_sorted[0]["total"],
                       "s": recs_sorted[0]["s"]} if recs_sorted else None),
        "min_nonzero_nu": nonzero_sorted[0]["nu"] if nonzero_sorted else None,
        "min_nonzero_nu_at": ({"r": nonzero_sorted[0]["r"],
                               "d": nonzero_sorted[0]["d"],
                               "abs_cell": nonzero_sorted[0]["abs_cell"],
                               "total": nonzero_sorted[0]["total"],
                               "s": nonzero_sorted[0]["s"]}
                              if nonzero_sorted else None),
        "s_min_over_support": min(s_vals) if s_vals else None,
        "s_max_over_support": max(s_vals) if s_vals else None,
        "top_k": top_k,
        "smallest_nu": [
            {"rank": i + 1, "r": x["r"], "d": x["d"], "r_minus_d": x["r_minus_d"],
             "cell": x["cell"], "abs_cell": x["abs_cell"],
             "total": x["total"], "nu": x["nu"], "s": x["s"]}
            for i, x in enumerate(recs_sorted[:top_k])],
        "smallest_nonzero_nu": [
            {"rank": i + 1, "r": x["r"], "d": x["d"], "r_minus_d": x["r_minus_d"],
             "cell": x["cell"], "abs_cell": x["abs_cell"],
             "total": x["total"], "nu": x["nu"], "s": x["s"]}
            for i, x in enumerate(nonzero_sorted[:top_k])],
    }
    return summary, recs_sorted[:top_k], zeros


# ---------------------------------------------------------------------------
# pair identity
# ---------------------------------------------------------------------------

def pair_identity_check(label, prime_path, comp_path, mode, b=2):
    """prime(r,d) + composite(r,d) == (b-1)^(d+1) * b^(r-1-d), cell by cell,
    over the intersection of the two files' supports."""
    Tp, _ = read_table(prime_path, second_col="A_count")
    second = "A_diff" if mode == "diff_plus_2p" else "A_count"
    Tc, _ = read_table(comp_path, second_col=second)
    keys = sorted(set(Tp) & set(Tc))
    mismatches = []
    for (r, d) in keys:
        tot = total_at(b, r, d)
        if mode == "sum":
            lhs = Tp[(r, d)] + Tc[(r, d)]
        else:
            lhs = Tc[(r, d)] + 2 * Tp[(r, d)]
        if lhs != tot:
            mismatches.append({"r": r, "d": d, "lhs": lhs, "total": tot,
                               "lhs_minus_total": lhs - tot,
                               "prime": Tp[(r, d)], "other": Tc[(r, d)]})
    keys_dmin = [k for k in keys if k[1] >= 1]
    return {
        "label": label,
        "prime_file": os.path.basename(prime_path),
        "other_file": os.path.basename(comp_path),
        "mode": mode,
        "identity": ("prime + composite == (b-1)^(d+1)*b^(r-1-d)"
                     if mode == "sum"
                     else "(composite-prime) + 2*prime == (b-1)^(d+1)*b^(r-1-d)"),
        "base": b,
        "cells_checked": len(keys),
        "cells_checked_at_d_ge_1": len(keys_dmin),
        "prime_cells": len(Tp),
        "other_cells": len(Tc),
        "mismatches": len(mismatches),
        "mismatch_detail_first_20": mismatches[:20],
    }


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="O44 - cross-base exact-zero and near-zero scan in the "
                    "pair identity's scale coordinate. EXPLORATORY: no "
                    "prereg, no decision rule, no verdict.")
    ap.add_argument("--data-dir", type=str, default=DEFAULT_DATA_DIR,
                    help="directory holding the imported base tables; "
                         "relative paths resolve against this script's "
                         "directory (default: imported/lattice_mapper/32bit)")
    ap.add_argument("--bases", type=str, default="2,3,4,5,6,7,8,9",
                    help="comma-separated bases to scan (default 2..9)")
    ap.add_argument("--d-min", type=int, default=1,
                    help="minimum depth included in the zero/nu scan; d=0 is "
                         "the A_count column (default 1)")
    ap.add_argument("--top-k", type=int, default=10,
                    help="how many smallest-nu cells to report per base "
                         "(default 10)")
    ap.add_argument("--pair-check", dest="pair_check", action="store_true",
                    default=True,
                    help="run the locked dyadic pair-identity checks (default on)")
    ap.add_argument("--no-pair-check", dest="pair_check", action="store_false",
                    help="skip the pair-identity checks")
    ap.add_argument("--variant-scan", dest="variant_scan", action="store_true",
                    default=True,
                    help="also scan the UNMATCHED silenced composite variants "
                         "against the plain prime arm; mismatches there are "
                         "expected, not defects (default on)")
    ap.add_argument("--no-variant-scan", dest="variant_scan",
                    action="store_false", help="skip the unmatched scan")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path (relative resolves against this "
                         "script's directory)")
    ap.add_argument("--no-json", action="store_true", default=False,
                    help="do not write the results JSON")
    args = ap.parse_args()

    def anchor(p):
        return p if os.path.isabs(p) else os.path.join(_HERE, p)

    data_dir = anchor(args.data_dir)
    out_path = anchor(args.out)
    bases = [int(x) for x in args.bases.replace(" ", "").split(",") if x != ""]
    started = datetime.datetime.now(datetime.timezone.utc)

    print(RULE, flush=True)
    print("O44 - CROSS-BASE ZERO SCAN   (EXPLORATORY: no prereg, no "
          "hypothesis,", flush=True)
    print("                              no decision rule, no verdict)",
          flush=True)
    print(RULE, flush=True)
    print(f"  started (UTC)          : {started.strftime('%Y-%m-%dT%H:%M:%SZ')}",
          flush=True)
    print(f"  source dir (READ ONLY) : {data_dir}", flush=True)
    print(f"  bases                  : {bases}", flush=True)
    print(f"  d-min                  : {args.d_min}", flush=True)
    print(f"  top-k                  : {args.top_k}", flush=True)
    print(f"  pair-check             : {args.pair_check}", flush=True)
    print(f"  variant-scan           : {args.variant_scan}", flush=True)
    print(f"  out                    : {out_path}", flush=True)
    print(f"  code_version (sha256)  : {_code_version()}", flush=True)

    print("\n" + THIN, flush=True)
    print("CONVENTION IN FORCE (stated, NOT adjusted for)", flush=True)
    print(THIN, flush=True)
    print("  Power-regime BACKWARD differences, A(n) = pi(b^n) - pi(b^(n-1)),",
          flush=True)
    print("  with the primes 2 AND 3 EXCLUDED AS LATTICE, not counted as "
          "primes.", flush=True)
    print("  A(1) = pi(b) - 2 for b >= 3; at b = 2 the two lattice primes "
          "straddle", flush=True)
    print("  the regime boundary (2 in (1,2], 3 in (2,4]) so one is dropped "
          "from", flush=True)
    print("  each of A(1) and A(2).   "
          "-- imported/lattice_mapper/README.md, Convention", flush=True)
    print("  Nothing below adds them back.  Numbers here are therefore NOT "
          "comparable", flush=True)
    print("  at low r with numbers in results/, which count 2 and 3 "
          "(CONTEXT.md).", flush=True)
    print("  Cell (2,1) is convention-mobile (lab_notebook_2.md entry 47): "
          "its value", flush=True)
    print("  moves with the seed rows, so its presence or absence below is a "
          "fact", flush=True)
    print("  about the convention, not about cancellation.", flush=True)

    print("\n" + THIN, flush=True)
    print("THE COORDINATE", flush=True)
    print(THIN, flush=True)
    print("  pair identity (lean/PairIdentity.lean, theorem pair_identity):",
          flush=True)
    print("      prime(r,d) + composite(r,d) = (b-1)^(d+1) * b^(r-1-d)  "
          "=: total(b,r,d)", flush=True)
    print("  scale       s(b,r,d) = (d+1)*log(b-1) + (r-1-d)*log b = log total",
          flush=True)
    print("  normalised  nu(b,r,d) = |cell(r,d)| / total(b,r,d)     "
          "[exact Fraction]", flush=True)
    print("  At b = 2, log(b-1) = 0 so s = (r-1-d)*log 2 and r-d alone fixes "
          "the", flush=True)
    print("  scale -- PairIdentity.coeff_eq_one_iff_base_two.  At every other "
          "base", flush=True)
    print("  both terms are live, so r, d and r-d are base-2 conveniences and "
          "the", flush=True)
    print("  cross-base comparison is made in s.", flush=True)

    # ---------------- per-base scan ----------------
    source_files, per_base, rows = [], [], []
    topk_by_base, zeros_by_base = {}, {}

    print("\n" + RULE, flush=True)
    print("1. EXTENT AND EXACT ZEROS", flush=True)
    print(RULE, flush=True)
    print(f"  {'b':>2} {'name':<9} {'file':<34} {'maxr':>4} {'maxd':>4} "
          f"{'cells':>6} {'d>=%d' % args.d_min:>7} {'zeros':>5}", flush=True)
    for b in bases:
        if b not in BASE_FILES:
            raise SystemExit(f"no locked filename for base {b}")
        path = os.path.join(data_dir, BASE_FILES[b])
        summ, topk, zeros = scan_base(b, path, args.d_min, args.top_k)
        source_files.append(file_record(path, {"role": "base_table", "base": b}))
        per_base.append(summ)
        topk_by_base[b] = topk
        zeros_by_base[b] = zeros
        rows.extend([dict(x, kind="smallest_nu", base=b) for x in
                     summ["smallest_nu"]])
        print(f"  {b:>2} {summ['name']:<9} {summ['file']:<34} "
              f"{summ['max_regime']:>4} {summ['max_depth']:>4} "
              f"{summ['n_cells_all_depths']:>6} "
              f"{summ['n_cells_at_or_above_d_min']:>7} "
              f"{summ['n_exact_zeros']:>5}", flush=True)

    print(f"\n  exact zeros at d >= {args.d_min}, per base:", flush=True)
    for summ in per_base:
        if summ["n_exact_zeros"] == 0:
            print(f"    b = {summ['base']}  none  "
                  f"(over {summ['n_cells_at_or_above_d_min']} cells, "
                  f"r <= {summ['max_regime']}, d <= {summ['max_depth']})",
                  flush=True)
        else:
            coords = "  ".join(f"(r={z['r']:>2}, d={z['d']:>2})"
                               for z in summ["exact_zeros"])
            print(f"    b = {summ['base']}  {summ['n_exact_zeros']}  "
                  f"(over {summ['n_cells_at_or_above_d_min']} cells, "
                  f"r <= {summ['max_regime']}, d <= {summ['max_depth']}): "
                  f"{coords}", flush=True)
    print("\n  The eight tables have different regime ceilings, so these "
          "counts are", flush=True)
    print("  over different scopes.  The scope is printed beside each count "
          "for that", flush=True)
    print("  reason.", flush=True)

    # ---------------- nu ----------------
    print("\n" + RULE, flush=True)
    print("2. NORMALISED MAGNITUDE nu = |cell| / total     "
          "(HEADLINE MEASUREMENT)", flush=True)
    print(RULE, flush=True)
    print("  Raw |cell| is not comparable across bases or depths; nu divides "
          "the", flush=True)
    print("  pair identity's total out.  nu = 0 exactly at an exact zero.",
          flush=True)
    print(f"\n  {'b':>2}  {'min nu':>14}  at (r,d)      "
          f"{'min NONZERO nu':>16}  at (r,d)      |cell|  total", flush=True)
    for summ in per_base:
        a, z = summ["min_nu_at"], summ["min_nonzero_nu_at"]
        print(f"  {summ['base']:>2}  {summ['min_nu']:>14.8g}  "
              f"({a['r']:>2},{a['d']:>2})      "
              f"{summ['min_nonzero_nu']:>16.8g}  "
              f"({z['r']:>2},{z['d']:>2})   {z['abs_cell']:>9d}  "
              f"{z['total']}", flush=True)

    for summ in per_base:
        b = summ["base"]
        print(f"\n  --- base {b} ({summ['name']}): {args.top_k} smallest nu "
              f"at d >= {args.d_min} ---", flush=True)
        print(f"      {'#':>2} {'r':>3} {'d':>3} {'r-d':>4} "
              f"{'cell':>14} {'|cell|':>14} {'total':>26} "
              f"{'nu':>13} {'s':>9}", flush=True)
        for x in summ["smallest_nu"]:
            print(f"      {x['rank']:>2} {x['r']:>3} {x['d']:>3} "
                  f"{x['r_minus_d']:>4} {x['cell']:>14d} "
                  f"{x['abs_cell']:>14d} {x['total']:>26d} "
                  f"{x['nu']:>13.6e} {x['s']:>9.5f}", flush=True)

    # ---------------- scale ----------------
    print("\n" + RULE, flush=True)
    print("3. SCALE COORDINATE s = (d+1)*log(b-1) + (r-1-d)*log b", flush=True)
    print(RULE, flush=True)
    all_zero_rows = []
    for b in bases:
        for summ in per_base:
            if summ["base"] != b:
                continue
            for z in summ["exact_zeros"]:
                all_zero_rows.append({"base": b, "r": z["r"], "d": z["d"],
                                      "r_minus_d": z["r_minus_d"],
                                      "total": z["total"], "s": z["s"]})
    print(f"\n  s at every exact zero, all bases (total = e^s, exact "
          f"integer):", flush=True)
    if not all_zero_rows:
        print("    (no exact zeros at any base)", flush=True)
    else:
        print(f"    {'b':>2} {'r':>3} {'d':>3} {'r-d':>4} {'total':>12} "
              f"{'s':>10}", flush=True)
        for z in sorted(all_zero_rows, key=lambda x: x["s"]):
            print(f"    {z['base']:>2} {z['r']:>3} {z['d']:>3} "
                  f"{z['r_minus_d']:>4} {z['total']:>12d} {z['s']:>10.6f}",
                  flush=True)

    print(f"\n  s range over each base's whole d >= {args.d_min} support "
          f"(a base cannot show", flush=True)
    print("  a near-zero at a scale its table does not reach):", flush=True)
    print(f"    {'b':>2}  {'s_min':>10}  {'s_max':>10}", flush=True)
    for summ in per_base:
        print(f"    {summ['base']:>2}  {summ['s_min_over_support']:>10.6f}  "
              f"{summ['s_max_over_support']:>10.6f}", flush=True)

    print(f"\n  the union of all bases' {args.top_k} smallest-nu cells, "
          f"sorted by s:", flush=True)
    print(f"    {'b':>2} {'r':>3} {'d':>3} {'s':>10} {'nu':>13} "
          f"{'|cell|':>14} {'total':>26}", flush=True)
    union = sorted(rows, key=lambda x: x["s"])
    for x in union:
        print(f"    {x['base']:>2} {x['r']:>3} {x['d']:>3} {x['s']:>10.6f} "
              f"{x['nu']:>13.6e} {x['abs_cell']:>14d} {x['total']:>26d}",
              flush=True)
    print("\n  The list above is printed so a reader can ask whether zeros "
          "and near-", flush=True)
    print("  zeros cluster in s across bases or sit at each base's own "
          "scales.  This", flush=True)
    print("  script does not answer that question and states no criterion "
          "for it.", flush=True)

    # ---------------- pair identity ----------------
    pair_results, variant_results = [], []
    if args.pair_check:
        print("\n" + RULE, flush=True)
        print("4. PAIR-IDENTITY CHECK  (sanity check; must pass)", flush=True)
        print(RULE, flush=True)
        print("  prime(r,d) + composite(r,d) == 2^(r-1-d), cell by cell, over "
              "the", flush=True)
        print("  intersection of each pair's support.  b = 2 is the only base "
              "with both", flush=True)
        print("  arms on disk in imported/lattice_mapper/32bit/.", flush=True)
        for label, pf, cf, mode in PAIR_CHECKS:
            pp = os.path.join(data_dir, pf)
            cp = os.path.join(data_dir, cf)
            res = pair_identity_check(label, pp, cp, mode, b=2)
            pair_results.append(res)
            for p in (pp, cp):
                if not any(sf["path"] == p for sf in source_files):
                    source_files.append(file_record(p, {"role": "pair_check"}))
            flag = "PASS" if res["mismatches"] == 0 else "MISMATCH"
            print(f"\n    {label}", flush=True)
            print(f"      {res['prime_file']}", flush=True)
            print(f"      {res['other_file']}", flush=True)
            print(f"      identity      : {res['identity']}", flush=True)
            print(f"      cells checked : {res['cells_checked']}  "
                  f"(of which d >= 1: {res['cells_checked_at_d_ge_1']})",
                  flush=True)
            print(f"      mismatches    : {res['mismatches']}   [{flag}]",
                  flush=True)
            for m in res["mismatch_detail_first_20"]:
                print(f"        (r={m['r']}, d={m['d']}) lhs {m['lhs']} vs "
                      f"total {m['total']}  diff {m['lhs_minus_total']}",
                      flush=True)
        tot_cells = sum(r["cells_checked"] for r in pair_results)
        tot_bad = sum(r["mismatches"] for r in pair_results)
        print(f"\n    matched-pair total: {tot_cells} cells checked, "
              f"{tot_bad} mismatches", flush=True)

    if args.variant_scan:
        print("\n" + THIN, flush=True)
        print("4b. UNMATCHED VARIANT SCAN  (mismatches EXPECTED, not defects)",
              flush=True)
        print(THIN, flush=True)
        print("  The silenced composite variants are not paired with the "
              "UNsilenced prime", flush=True)
        print("  arm.  entry 47: the six composite variants differ only in "
              "A_count at", flush=True)
        print("  r = 1,2,3, and each silenced prime landing in (b, b^2] moves "
              "an arm by", flush=True)
        print("  one.  So the identity cannot hold across a mismatched pair.  "
              "Scanned and", flush=True)
        print("  printed so the expectation is on the record rather than "
              "assumed.", flush=True)
        pp = os.path.join(data_dir, VARIANT_SCAN_PRIME)
        for cf in VARIANT_SCAN_COMPOSITES:
            cp = os.path.join(data_dir, cf)
            res = pair_identity_check(f"UNMATCHED: {VARIANT_SCAN_PRIME} + {cf}",
                                      pp, cp, "sum", b=2)
            res["expected_to_mismatch"] = True
            res["mismatch_detail_first_20"] = res["mismatch_detail_first_20"][:3]
            variant_results.append(res)
            if not any(sf["path"] == cp for sf in source_files):
                source_files.append(file_record(cp, {"role": "variant_scan"}))
            print(f"    {cf:<52s} cells {res['cells_checked']:>4}  "
                  f"mismatches {res['mismatches']:>4}", flush=True)

    ended = datetime.datetime.now(datetime.timezone.utc)

    # ---------------- JSON ----------------
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
                "data_dir": data_dir,
                "bases": bases,
                "d_min": args.d_min,
                "top_k": args.top_k,
                "pair_check": args.pair_check,
                "variant_scan": args.variant_scan,
                "out": out_path,
                "python": sys.version,
                "source_files": source_files,
                "prereg": None,
                "status": "exploratory",
                "status_note":
                    "EXPLORATORY. No prereg, no hypothesis, no decision rule, "
                    "no verdict. Nothing in this file is a verdict or settles "
                    "anything. CLAUDE.md, section Prereg discipline.",
            },
            "constants": {
                "convention": CONVENTION,
                "convention_adjusted_for": False,
                "base_files": BASE_FILES,
                "base_names": BASE_NAMES,
                "pair_identity":
                    "prime(r,d) + composite(r,d) = (b-1)^(d+1) * b^(r-1-d), "
                    "exact at every cell in every base; proved in "
                    "lean/PairIdentity.lean, theorem pair_identity, with no "
                    "hypothesis about primes anywhere in the proof",
                "total":
                    "total(b,r,d) = (b-1)^(d+1) * b^(r-1-d)",
                "scale_coordinate":
                    "s(b,r,d) = (d+1)*log(b-1) + (r-1-d)*log b = log "
                    "total(b,r,d); natural logarithm",
                "base_two_corollary":
                    "at b = 2 the term (d+1)*log(b-1) vanishes and s = "
                    "(r-1-d)*log 2, so the scale depends on r-d alone. This "
                    "is PairIdentity.coeff_eq_one_iff_base_two: (b-1)^(d+1) = "
                    "1 exactly when b = 2, for integer b >= 2. At every other "
                    "base both terms are live, which is why r, d and r-d are "
                    "base-2 conveniences and the cross-base comparison is "
                    "made in s",
                "normalised_magnitude":
                    "nu(b,r,d) = |cell(r,d)| / total(b,r,d), computed as an "
                    "exact Fraction of exact integers and converted to float "
                    "only for output; every ranking is on the exact value",
                "source_schema":
                    "cell(r,0) = A_count = silenced_pi(b^r) - "
                    "silenced_pi(b^(r-1)) over the half-open block "
                    "(b^(r-1), b^r]; cell(r,d) = delta_d = cell(r,d-1) - "
                    "cell(r-1,d-1); support d <= r-1; values are PRIME "
                    "counts; depth runs ACROSS columns, regime DOWN rows",
                "source_project":
                    "/Users/juliansambrano/GitHub/lattice_mapper (origin of "
                    "the imported files; READ ONLY, nothing written there). "
                    "Read path is the in-repo vendored copy, entry 46.",
                "pair_checks_locked": [
                    {"label": lab, "prime_file": pf, "other_file": cf,
                     "mode": md} for lab, pf, cf, md in PAIR_CHECKS],
                "variant_scan_note":
                    "The silenced composite variants are NOT matched to the "
                    "unsilenced prime arm; mismatches in the 4b scan are "
                    "expected and are not defects. entry 47.",
            },
            "summary": {
                "per_base": per_base,
                "bases_measured": bases,
                "bases_with_exact_zeros": [s["base"] for s in per_base
                                           if s["n_exact_zeros"] > 0],
                "bases_without_exact_zeros": [s["base"] for s in per_base
                                              if s["n_exact_zeros"] == 0],
                "n_exact_zeros_total": sum(s["n_exact_zeros"]
                                           for s in per_base),
                "exact_zeros_all_bases_by_scale":
                    sorted(all_zero_rows, key=lambda x: x["s"]),
                "pair_identity_checks": pair_results,
                "pair_identity_cells_checked":
                    sum(r["cells_checked"] for r in pair_results),
                "pair_identity_mismatches":
                    sum(r["mismatches"] for r in pair_results),
                "unmatched_variant_scan": variant_results,
                "n_source_files": len(source_files),
            },
            "rows": union,
        }
        _write_results(payload, out_path)

    print("\n" + RULE, flush=True)
    print("READ THE RESULT", flush=True)
    print(RULE, flush=True)
    print("  Every cell value above is an exact Python integer read from an "
          "imported", flush=True)
    print("  CSV; every total is an exact integer; every nu was ranked as an "
          "exact", flush=True)
    print("  Fraction.  Nothing under imported/ was written to.", flush=True)
    print("  The convention (2 and 3 excluded as lattice) is STATED and NOT "
          "adjusted", flush=True)
    print("  for, so low-r numbers here do not compare with numbers in "
          "results/.", flush=True)
    print("  This script states no hypothesis and fires no decision rule.  "
          "Its output", flush=True)
    print("  is EXPLORATORY per CLAUDE.md, section Prereg discipline.  "
          "Nothing here is", flush=True)
    print("  a verdict, and nothing here settles anything or supports any "
          "reading.", flush=True)
    print(f"  finished (UTC): {ended.strftime('%Y-%m-%dT%H:%M:%SZ')}",
          flush=True)


if __name__ == "__main__":
    main()
