#!/usr/bin/env python3
"""
O16 — Centered difference table on dyadic prime counts: exact-integer construction
      of the (S - S^-1) table alongside the house (S - I) backward table, and the
      exact zero sets of both, on both the prime and the composite side.

Reads with: dyadic-difference-tables.xlsx (project root); `files (2)/`
unit_weighted_dyadic_table.csv and composite_unit_dyadic_table.csv;
O1_operator_selfadjointness.py; O8_weil_inner_product.py; pi2n_cache.json.

NAMING
------
The O-series in this tree runs O1-O9, O11, O12, O13, O14, O15.  There is NO O10:
that number is a known, DELIBERATE GAP, and this script does not fill it, because
filling a reserved gap with unrelated work would silently rewrite the series'
history.  The next free number after O15 is O16; this file takes it.  Capital "O"
per `CLAUDE.md` § "Naming convention (do not re-break)".

ENVELOPE
--------
The house JSON envelope is unchanged in shape (schema_version, script,
generated_utc, params, constants, summary, flat `rows`) and `schema_version`
stays "1".  As on O12/O13/O14/O15, `params.code_version` carries the sha256 of
THIS script file, computed at runtime by reading `__file__`.

=============================================================================
WHAT THIS IS
=============================================================================

The dyadic prime difference table (see `dyadic-difference-tables.xlsx` at the
project root) is built from BACKWARD differences of dyadic prime counts:

    N(r)   = pi(2^r) - pi(2^(r-1))     primes in the half-open interval
                                       (2^(r-1), 2^r]
    B(r,0) = N(r)
    B(r,d) = B(r,d-1) - B(r-1,d-1)

The operator behind that is Delta = S - I, which is ONE-SIDED.  O1 proved Delta
cannot be self-adjoint under any positive diagonal weight (D[i,i+1] = +1 while
D[i+1,i] = 0 forces the weights to zero), and O8 measured that the
Connes-van Suijlekom Weil form does not rescue it either (failure 0.99844421
against a random-matrix baseline of 0.85234065 and a control of 0.038227574).

One-sidedness is removable.  The CENTERED difference operator (S - S^-1)/2 is
skew-adjoint, so i times it is Hermitian with real spectrum.  This script builds
the centered-difference table on the same counts and asks what its exact zeros
are.

NORMALISATION
-------------
This script uses the UNNORMALISED centered difference so that every entry stays
an exact integer:

    C(r,0) = N(r)
    C(r,d) = C(r+1,d-1) - C(r-1,d-1)

The factor of 1/2 in (S - S^-1)/2 is a nonzero scalar per depth; it rescales
every entry at a given depth by the same positive constant and therefore DOES
NOT MOVE ZEROS.  It is omitted.  This is recorded in the payload as
`constants.centered_normalisation`.

INDEX SUPPORT
-------------
Centered differencing loses one row at EACH end per depth.  If the counts run
r = 1..R then C(r,d) is defined for

    r = d+1 .. R-d

and the maximum usable depth is floor((R-1)/2).  The script computes and reports
this explicitly and emits no cell outside the support.  The backward table by
contrast loses one row at the low end only: B(r,d) is defined for r = d+1 .. R,
maximum depth R-1.

COMPOSITE SIDE
--------------
Composite counts in the same dyadic interval are

    M(r) = 2^(r-1) - N(r)

(the interval (2^(r-1), 2^r] holds exactly 2^(r-1) integers).  Both difference
tables are built on M as well.

THE TWO IDENTITY CHECKS
-----------------------
(a) BACKWARD.  The d-th backward difference of the sequence 2^(r-1) is
    2^(r-d-1): one step gives 2^(r-1) - 2^(r-2) = 2^(r-2), and iterating drops
    the exponent by one each time.  Differencing is linear, so

        composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)

    must hold in EVERY cell of the backward support.

(b) CENTERED.  Applying the unnormalised S - S^-1 to 2^(r-1) gives

        2^r - 2^(r-2) = 4*2^(r-2) - 2^(r-2) = 3 * 2^(r-2) = 3^1 * 2^(r-1-1)

    i.e. one centered step multiplies by 3 and drops the exponent by one.
    Iterating d times gives 3^d * 2^(r-1-d).  By linearity

        composite_C(r,d) == 3^d * 2^(r-1-d) - prime_C(r,d)

    must hold in EVERY cell of the centered support.  Note r >= d+1 on the
    support, so the exponent r-1-d is never negative and the check stays in the
    integers.

ARITHMETIC
----------
EXACT PYTHON INTEGERS THROUGHOUT.  numpy is deliberately NOT imported: numpy
int64 would silently overflow (the counts reach ~1.1e17 at r = 62 and the deep
differences exceed 1e35), and any float anywhere in these tables would be a
defect.  `params.precision` records "exact integer (Python int)".

The xlsx caps at r = 50 because a spreadsheet carries only about 15 significant
decimal digits.  Python ints have no such limit, so this script runs the full
cached range exactly.

=============================================================================
PRE-REGISTERED BANDS — fixed before the run, applied mechanically
=============================================================================
Comparing the centered table's exact zero set Z_C against the backward table's
Z_B (prime side, over each table's own full support):

    SAME       Z_C == Z_B
    SUPERSET   Z_C is a strict superset of Z_B
    SUBSET     Z_C is a strict subset of Z_B and non-empty (some but not all,
               no new ones)
    DISJOINT   Z_C and Z_B share no coordinates and Z_C is non-empty
    EMPTY      Z_C is empty
    OVERLAP    none of the above (shares some, adds some) — recorded as
               `unbanded_overlap` so the band table can never be silently
               stretched to fit

=============================================================================
GATES — both RUN inside the script and recorded in the payload
=============================================================================

GATE A — reproduction.  The BACKWARD prime table must reproduce
`files (2)/unit_weighted_dyadic_table.csv` exactly, and the BACKWARD composite
table must reproduce `files (2)/composite_unit_dyadic_table.csv` exactly.  Those
CSVs are depth-as-rows, regime-as-columns, header `depth,r=1,...,r=25`, 13 data
rows (depth 0-12).  They are read, transposed, and compared cell by cell as
exact integers.  Cell counts and mismatch counts are reported.  The CSVs are
READ ONLY; nothing under `files (2)/` is ever written.

GATE B — documented zero set.  The backward prime table's exact zeros must be
exactly {(2,1), (4,1), (8,3), (20,6)} within r <= 50, d <= 30 — the set
documented in the xlsx "Read me" sheet.  Reported pass/fail with the actual set
found.  Whether any ADDITIONAL zeros appear beyond r = 50 or d = 30 is reported
separately, because that range is outside what the xlsx covers and so is not
part of the gate.

USAGE
-----
    python3 O16_centered_difference_table.py
    python3 O16_centered_difference_table.py --rmax 50 --max-depth 30
    python3 O16_centered_difference_table.py --out results/o16_run2.json
"""

import argparse
import hashlib
import json
import os
from datetime import datetime, timezone

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
DEFAULT_CACHE = os.path.join(_HERE, "pi2n_cache.json")
DEFAULT_UNIT_CSV = os.path.join(_HERE, "files (2)",
                                "unit_weighted_dyadic_table.csv")
DEFAULT_COMP_CSV = os.path.join(_HERE, "files (2)",
                                "composite_unit_dyadic_table.csv")

# The zero set documented in the xlsx "Read me" sheet, within r<=50, d<=30.
DOCUMENTED_BACKWARD_ZEROS = {(2, 1), (4, 1), (8, 3), (20, 6)}
GATE_B_RMAX = 50
GATE_B_DMAX = 30


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """
    Coerce to JSON-safe Python types.  Python ints pass through UNCHANGED and
    unrounded — that is the whole point of this script, so there is deliberately
    no float path for table values here.
    """
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
        return o if (o == o and o not in (float("inf"), float("-inf"))) else None
    return str(o)


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


def _safe_div(a, b):
    """Guarded division; returns None rather than raising."""
    try:
        if b is None or int(b) == 0:
            return None
        return a / b
    except (TypeError, ValueError, ZeroDivisionError):
        return None


# ---------------------------------------------------------------------------
# table construction — exact integers only
# ---------------------------------------------------------------------------

def backward_table(seq, R, max_depth):
    """
    BACKWARD table.  T[0][r] = seq[r] for r = 1..R;
    T[d][r] = T[d-1][r] - T[d-1][r-1], support r = d+1..R.
    Returns {depth: {r: int}}.
    """
    tab = {0: {r: seq[r] for r in range(1, R + 1)}}
    dmax = R - 1
    if max_depth is not None:
        dmax = min(dmax, max_depth)
    for d in range(1, dmax + 1):
        prev = tab[d - 1]
        tab[d] = {r: prev[r] - prev[r - 1] for r in range(d + 1, R + 1)}
    return tab


def centered_table(seq, R, max_depth):
    """
    CENTERED table, UNNORMALISED (factor 1/2 omitted; zeros unaffected).
    T[0][r] = seq[r] for r = 1..R;
    T[d][r] = T[d-1][r+1] - T[d-1][r-1], support r = d+1..R-d.
    Returns {depth: {r: int}}.
    """
    tab = {0: {r: seq[r] for r in range(1, R + 1)}}
    dmax = (R - 1) // 2
    if max_depth is not None:
        dmax = min(dmax, max_depth)
    for d in range(1, dmax + 1):
        prev = tab[d - 1]
        tab[d] = {r: prev[r + 1] - prev[r - 1] for r in range(d + 1, R - d + 1)}
    return tab


def table_stats(tab):
    """(n_cells, max_r, max_abs_value, argmax cell) over a whole table."""
    n = 0
    max_r = None
    best = -1
    best_cell = None
    for d, row in tab.items():
        for r, v in row.items():
            n += 1
            if max_r is None or r > max_r:
                max_r = r
            a = abs(v)
            if a > best:
                best = a
                best_cell = (r, d)
    return n, max_r, (best if best >= 0 else None), best_cell


def zeros_of(tab, min_depth=1):
    """Sorted list of (r, d) with an exact integer zero, depth >= min_depth."""
    z = []
    for d, row in tab.items():
        if d < min_depth:
            continue
        for r, v in row.items():
            if v == 0:
                z.append((r, d))
    return sorted(z, key=lambda p: (p[1], p[0]))


def repeat_counts(tab, gap):
    """
    Per depth: number of pairs (r, r+gap) both in support with EQUAL values.
    gap=1 is 'adjacent equal'; gap=2 is 'equal two apart'.
    """
    out = {}
    for d in sorted(tab):
        row = tab[d]
        c = 0
        for r in row:
            if (r + gap) in row and row[r] == row[r + gap]:
                c += 1
        out[d] = c
    return out


def read_csv_table(path):
    """
    Read a depth-as-rows / regime-as-columns CSV with header
    `depth,r=1,...,r=RMAX`.  Returns ({depth: {r: int}}, n_cells, header_rmax,
    n_data_rows).  Blank cells are skipped.  READ ONLY.
    """
    with open(path, "r") as fh:
        lines = [ln.rstrip("\n") for ln in fh if ln.strip() != ""]
    hdr = lines[0].split(",")
    if hdr[0] != "depth":
        raise ValueError(f"unexpected header start {hdr[0]!r} in {path}")
    rs = [int(h.split("=")[1]) for h in hdr[1:]]
    tab = {}
    n_cells = 0
    for ln in lines[1:]:
        parts = ln.split(",")
        d = int(parts[0])
        row = {}
        for i, cell in enumerate(parts[1:]):
            cell = cell.strip()
            if cell == "":
                continue
            row[rs[i]] = int(cell)
            n_cells += 1
        tab[d] = row
    return tab, n_cells, (max(rs) if rs else None), len(lines) - 1


def compare_to_csv(csv_tab, our_tab):
    """Cell-by-cell exact integer comparison. Returns (n_compared, mismatches)."""
    n = 0
    bad = []
    for d in sorted(csv_tab):
        for r in sorted(csv_tab[d]):
            exp = csv_tab[d][r]
            got = our_tab.get(d, {}).get(r)
            n += 1
            if got is None or got != exp:
                bad.append({"r": r, "depth": d, "csv": exp, "ours": got})
    return n, bad


def main():
    ap = argparse.ArgumentParser(
        description="O16 — centered vs backward dyadic difference tables, "
                    "exact integers, prime and composite sides")
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE,
                    help="path to pi(2^n) cache JSON (READ ONLY; "
                         "default: pi2n_cache.json at the script root)")
    ap.add_argument("--rmax", type=int, default=None,
                    help="cap the regime index r (default: the full range "
                         "available in the cache)")
    ap.add_argument("--max-depth", type=int, default=None,
                    help="cap the difference depth of BOTH tables "
                         "(default: each table's own natural maximum)")
    ap.add_argument("--print-rmax", type=int, default=30,
                    help="print the readable table triangles out to this r "
                         "(default 30)")
    ap.add_argument("--unit-csv", type=str, default=DEFAULT_UNIT_CSV,
                    help="gate A reference CSV, prime side (READ ONLY)")
    ap.add_argument("--composite-csv", type=str, default=DEFAULT_COMP_CSV,
                    help="gate A reference CSV, composite side (READ ONLY)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    print("=" * 78, flush=True)
    print("O16 — centered difference table on dyadic prime counts", flush=True)
    print("=" * 78, flush=True)
    print("  N(r)   = pi(2^r) - pi(2^(r-1))        primes in (2^(r-1), 2^r]",
          flush=True)
    print("  M(r)   = 2^(r-1) - N(r)               composites in the same "
          "interval", flush=True)
    print("  BACKWARD  B(r,d) = B(r,d-1) - B(r-1,d-1)   support r = d+1..R",
          flush=True)
    print("  CENTERED  C(r,d) = C(r+1,d-1) - C(r-1,d-1) support r = d+1..R-d",
          flush=True)
    print("  centered normalisation: UNNORMALISED — the factor 1/2 in "
          "(S - S^-1)/2 is", flush=True)
    print("  omitted so every entry is an exact integer; a positive scalar per "
          "depth", flush=True)
    print("  cannot move zeros.", flush=True)
    print("  ARITHMETIC: exact Python int throughout. numpy is deliberately "
          "NOT imported.", flush=True)

    # ---------------- cache -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("CACHE", flush=True)
    print("-" * 78, flush=True)
    print(f"  source: {args.cache}   (READ ONLY)", flush=True)
    with open(args.cache, "r") as fh:
        raw = json.load(fh)
    key_types = sorted({type(k).__name__ for k in raw})
    val_types = sorted({type(v).__name__ for v in raw.values()})
    P = {int(k): int(v) for k, v in raw.items()}
    ns = sorted(P)
    n_min, n_max = ns[0], ns[-1]
    contiguous = (ns == list(range(n_min, n_max + 1)))
    print(f"  container         : {type(raw).__name__}", flush=True)
    print(f"  key type(s)       : {key_types}   (JSON object keys are strings; "
          f"they hold decimal n)", flush=True)
    print(f"  value type(s)     : {val_types}", flush=True)
    print(f"  entries           : {len(P)}", flush=True)
    print(f"  n range           : {n_min}..{n_max}", flush=True)
    print(f"  contiguous        : {contiguous}", flush=True)
    print(f"  lab notebook entry 4 records n = 0..62, 63 entries -> "
          f"{'CONFIRMED' if (n_min == 0 and n_max == 62 and len(P) == 63) else 'NOT CONFIRMED'}",
          flush=True)
    print(f"  pi(2^0)  = {P[n_min]}", flush=True)
    print(f"  pi(2^{n_max}) = {P[n_max]}", flush=True)

    # ---------------- counts ------------------------------------------------
    r_avail = [r for r in range(n_min + 1, n_max + 1) if (r in P and r - 1 in P)]
    R_full = max(r_avail)
    R = R_full if args.rmax is None else min(R_full, int(args.rmax))
    Nseq = {r: P[r] - P[r - 1] for r in range(1, R + 1)}
    Mseq = {r: (1 << (r - 1)) - Nseq[r] for r in range(1, R + 1)}

    print("\n" + "-" * 78, flush=True)
    print("COUNTS", flush=True)
    print("-" * 78, flush=True)
    print(f"  r available from the cache : 1..{R_full}", flush=True)
    print(f"  r used this run            : 1..{R}", flush=True)
    print(f"  backward max depth (R-1)         : {R - 1}", flush=True)
    print(f"  centered max depth floor((R-1)/2): {(R - 1) // 2}", flush=True)
    print(f"\n  first 10 N(r):", flush=True)
    for r in range(1, min(10, R) + 1):
        print(f"    N({r:>2}) = {Nseq[r]:>22}     M({r:>2}) = {Mseq[r]:>22}",
              flush=True)
    print(f"  last 5 N(r):", flush=True)
    for r in range(max(1, R - 4), R + 1):
        print(f"    N({r:>2}) = {Nseq[r]:>22}     M({r:>2}) = {Mseq[r]:>22}",
              flush=True)

    # ---------------- tables ------------------------------------------------
    B_prime = backward_table(Nseq, R, args.max_depth)
    B_comp = backward_table(Mseq, R, args.max_depth)
    C_prime = centered_table(Nseq, R, args.max_depth)
    C_comp = centered_table(Mseq, R, args.max_depth)

    tables = {
        "backward_prime": B_prime,
        "backward_composite": B_comp,
        "centered_prime": C_prime,
        "centered_composite": C_comp,
    }

    print("\n" + "-" * 78, flush=True)
    print("TABLE EXTENTS", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'table':>22} {'depths':>10} {'cells':>8} {'max r':>7} "
          f"{'max |value|':>42} {'at (r,d)':>12}", flush=True)
    extents = {}
    for name, tab in tables.items():
        n, mr, mv, cell = table_stats(tab)
        extents[name] = {"n_cells": n, "max_r": mr, "max_abs_value": mv,
                         "max_abs_cell": {"r": cell[0], "depth": cell[1]},
                         "max_depth": max(tab), "n_digits_max_abs": len(str(mv))}
        print(f"  {name:>22} {('0..%d' % max(tab)):>10} {n:>8} {mr:>7} "
              f"{mv:>42} {('(%d,%d)' % cell):>12}", flush=True)

    # ---------------- readable triangles ------------------------------------
    pr = min(args.print_rmax, R)
    print("\n" + "-" * 78, flush=True)
    print(f"CENTERED PRIME TABLE C(r,d), r <= {pr}   "
          f"(unnormalised; support r = d+1..R-d, R = {R})", flush=True)
    print("-" * 78, flush=True)
    for r in range(1, pr + 1):
        ds = [d for d in sorted(C_prime) if r in C_prime[d]]
        cells = "  ".join(f"d{d}={C_prime[d][r]}" for d in ds)
        print(f"  r={r:>2} | {cells}", flush=True)

    print("\n" + "-" * 78, flush=True)
    print(f"BACKWARD PRIME TABLE B(r,d), r <= {pr}   (support r = d+1..R)",
          flush=True)
    print("-" * 78, flush=True)
    for r in range(1, pr + 1):
        ds = [d for d in sorted(B_prime) if r in B_prime[d]]
        cells = "  ".join(f"d{d}={B_prime[d][r]}" for d in ds)
        print(f"  r={r:>2} | {cells}", flush=True)

    print("\n" + "-" * 78, flush=True)
    print(f"CENTERED COMPOSITE TABLE C_M(r,d), r <= {pr}", flush=True)
    print("-" * 78, flush=True)
    for r in range(1, pr + 1):
        ds = [d for d in sorted(C_comp) if r in C_comp[d]]
        cells = "  ".join(f"d{d}={C_comp[d][r]}" for d in ds)
        print(f"  r={r:>2} | {cells}", flush=True)

    # ---------------- zeros -------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("EXACT ZEROS (depth >= 1), all four tables", flush=True)
    print("-" * 78, flush=True)
    zero_sets = {}
    zero_detail = {}
    for name, tab in tables.items():
        z = zeros_of(tab, min_depth=1)
        zero_sets[name] = z
        det = []
        for (r, d) in z:
            is_backward = name.startswith("backward")
            other = ("backward_composite" if name == "backward_prime" else
                     "backward_prime" if name == "backward_composite" else
                     "centered_composite" if name == "centered_prime" else
                     "centered_prime")
            det.append({
                "r": r, "depth": d,
                "value": 0,
                "partner_table": other,
                "partner_value": tables[other].get(d, {}).get(r),
                "two_pow_r_minus_d_minus_1": ((1 << (r - d - 1))
                                              if is_backward else None),
                "three_pow_d_times_two_pow": (None if is_backward
                                              else (3 ** d) * (1 << (r - 1 - d))),
                "r_minus_2d": r - 2 * d,
                "r_minus_d": r - d,
            })
        zero_detail[name] = det
        print(f"\n  {name}:  {len(z)} zero(s)", flush=True)
        if not z:
            print("    (none)", flush=True)
        for e in det:
            extra = (f"2^(r-d-1)={e['two_pow_r_minus_d_minus_1']}"
                     if e["two_pow_r_minus_d_minus_1"] is not None
                     else f"3^d*2^(r-1-d)={e['three_pow_d_times_two_pow']}")
            print(f"    (r={e['r']:>2}, d={e['depth']:>2})  "
                  f"partner[{e['partner_table']}]={e['partner_value']}  "
                  f"{extra}  r-2d={e['r_minus_2d']}  r-d={e['r_minus_d']}",
                  flush=True)

    # depth-0 zeros reported separately (M(1) = 0 is a real depth-0 zero)
    d0_zeros = {}
    for name, tab in tables.items():
        d0_zeros[name] = sorted(r for r, v in tab[0].items() if v == 0)
    print(f"\n  depth-0 zeros (reported separately, not part of any band):",
          flush=True)
    for name in tables:
        print(f"    {name:>22}: r = {d0_zeros[name]}", flush=True)

    # ---------------- identity checks ---------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("IDENTITY CHECK (a) — BACKWARD: "
          "composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)", flush=True)
    print("-" * 78, flush=True)
    ident_a_n = 0
    ident_a_bad = []
    for d in sorted(B_prime):
        for r in sorted(B_prime[d]):
            ident_a_n += 1
            exp = (1 << (r - d - 1)) - B_prime[d][r]
            got = B_comp[d][r]
            if got != exp:
                ident_a_bad.append({"r": r, "depth": d, "expected": exp,
                                    "got": got})
    ident_a_pass = (len(ident_a_bad) == 0)
    print(f"  cells checked : {ident_a_n}", flush=True)
    print(f"  mismatches    : {len(ident_a_bad)}", flush=True)
    print(f"  IDENTITY (a)  : {'PASS' if ident_a_pass else 'FAIL'}", flush=True)
    for b in ident_a_bad[:20]:
        print(f"    r={b['r']} d={b['depth']} expected={b['expected']} "
              f"got={b['got']}", flush=True)

    print("\n" + "-" * 78, flush=True)
    print("IDENTITY CHECK (b) — CENTERED: "
          "composite_C(r,d) == 3^d * 2^(r-1-d) - prime_C(r,d)", flush=True)
    print("-" * 78, flush=True)
    ident_b_n = 0
    ident_b_bad = []
    for d in sorted(C_prime):
        for r in sorted(C_prime[d]):
            ident_b_n += 1
            exp = (3 ** d) * (1 << (r - 1 - d)) - C_prime[d][r]
            got = C_comp[d][r]
            if got != exp:
                ident_b_bad.append({"r": r, "depth": d, "expected": exp,
                                    "got": got})
    ident_b_pass = (len(ident_b_bad) == 0)
    print(f"  cells checked : {ident_b_n}", flush=True)
    print(f"  mismatches    : {len(ident_b_bad)}", flush=True)
    print(f"  IDENTITY (b)  : {'PASS' if ident_b_pass else 'FAIL'}", flush=True)
    for b in ident_b_bad[:20]:
        print(f"    r={b['r']} d={b['depth']} expected={b['expected']} "
              f"got={b['got']}", flush=True)

    # ---------------- repeats ----------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("EXACT REPEATS PER DEPTH", flush=True)
    print("-" * 78, flush=True)
    print("  BACKWARD: B(r,d) = 0  <=>  B(r,d-1) == B(r-1,d-1), i.e. a zero at "
          "depth d is", flush=True)
    print("  an ADJACENT (gap-1) repeat at depth d-1.", flush=True)
    print("  CENTERED: C(r,d) = 0  <=>  C(r+1,d-1) == C(r-1,d-1), i.e. a zero "
          "at depth d is", flush=True)
    print("  a GAP-2 repeat at depth d-1 — NOT an adjacent repeat.  Both gap-1 "
          "and gap-2", flush=True)
    print("  counts are given so the difference is visible.", flush=True)
    repeats = {}
    for name, tab in tables.items():
        repeats[name] = {"gap1": repeat_counts(tab, 1),
                         "gap2": repeat_counts(tab, 2)}
    for name in tables:
        g1 = repeats[name]["gap1"]
        g2 = repeats[name]["gap2"]
        nz1 = {d: c for d, c in g1.items() if c}
        nz2 = {d: c for d, c in g2.items() if c}
        print(f"\n  {name}:", flush=True)
        print(f"    gap-1 (adjacent) repeats, nonzero depths: "
              f"{nz1 if nz1 else '{} (none at any depth)'}", flush=True)
        print(f"    gap-2 repeats,            nonzero depths: "
              f"{nz2 if nz2 else '{} (none at any depth)'}", flush=True)

    # ---------------- GATE A ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("GATE A — reproduce the frozen CSVs exactly (READ ONLY)", flush=True)
    print("-" * 78, flush=True)
    gate_a = {}
    gate_a_passed = True
    for label, path, ours in (("unit_weighted_dyadic_table.csv",
                               args.unit_csv, B_prime),
                              ("composite_unit_dyadic_table.csv",
                               args.composite_csv, B_comp)):
        rec = {"path": path}
        try:
            csv_tab, n_cells, hdr_rmax, n_rows = read_csv_table(path)
            n_cmp, bad = compare_to_csv(csv_tab, ours)
            rec.update({"header_rmax": hdr_rmax, "data_rows": n_rows,
                        "depths": sorted(csv_tab),
                        "csv_cells": n_cells, "cells_compared": n_cmp,
                        "mismatches": len(bad), "mismatch_detail": bad[:50],
                        "passed": len(bad) == 0, "note": None})
            print(f"\n  {label}", flush=True)
            print(f"    header r=1..{hdr_rmax}, {n_rows} data rows, depths "
                  f"{min(csv_tab)}..{max(csv_tab)}", flush=True)
            print(f"    cells compared : {n_cmp}", flush=True)
            print(f"    mismatches     : {len(bad)}", flush=True)
            print(f"    -> {'PASS' if not bad else 'FAIL'}", flush=True)
            for b in bad[:20]:
                print(f"      r={b['r']} d={b['depth']} csv={b['csv']} "
                      f"ours={b['ours']}", flush=True)
            gate_a_passed = gate_a_passed and (len(bad) == 0)
        except Exception as exc:
            rec.update({"passed": None, "note": f"not readable: {exc}"})
            gate_a_passed = None
            print(f"\n  {label}: NOT READ — {exc}", flush=True)
        gate_a[label] = rec
    print(f"\n  GATE A: {'PASSED' if gate_a_passed else ('NOT RUN' if gate_a_passed is None else 'FAILED')}",
          flush=True)

    # ---------------- GATE B ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print(f"GATE B — backward prime zeros within r <= {GATE_B_RMAX}, "
          f"d <= {GATE_B_DMAX} must equal", flush=True)
    print(f"         {sorted(DOCUMENTED_BACKWARD_ZEROS)}  (xlsx 'Read me')",
          flush=True)
    print("-" * 78, flush=True)
    zb = zero_sets["backward_prime"]
    in_window = sorted({(r, d) for (r, d) in zb
                        if r <= GATE_B_RMAX and d <= GATE_B_DMAX},
                       key=lambda p: (p[1], p[0]))
    outside = sorted(set(zb) - set(in_window), key=lambda p: (p[1], p[0]))
    gate_b_passed = (set(in_window) == DOCUMENTED_BACKWARD_ZEROS)
    print(f"  in-window zeros found : {in_window}", flush=True)
    print(f"  expected              : {sorted(DOCUMENTED_BACKWARD_ZEROS)}",
          flush=True)
    print(f"  missing               : "
          f"{sorted(DOCUMENTED_BACKWARD_ZEROS - set(in_window))}", flush=True)
    print(f"  unexpected            : "
          f"{sorted(set(in_window) - DOCUMENTED_BACKWARD_ZEROS)}", flush=True)
    print(f"  GATE B: {'PASSED' if gate_b_passed else 'FAILED'}", flush=True)
    print(f"\n  additional zeros OUTSIDE the xlsx window "
          f"(r > {GATE_B_RMAX} or d > {GATE_B_DMAX}), not part of the gate:",
          flush=True)
    print(f"    {outside if outside else '(none)'}", flush=True)
    print(f"    window searched this run: r <= {R}, d <= {max(B_prime)}",
          flush=True)

    # ---------------- pre-registered band -----------------------------------
    print("\n" + "-" * 78, flush=True)
    print("PRE-REGISTERED BAND — centered prime zero set vs backward prime "
          "zero set", flush=True)
    print("-" * 78, flush=True)
    ZB = set(zero_sets["backward_prime"])
    ZC = set(zero_sets["centered_prime"])
    if not ZC:
        band = "EMPTY"
    elif ZC == ZB:
        band = "SAME"
    elif ZB < ZC:
        band = "SUPERSET"
    elif ZC < ZB:
        band = "SUBSET"
    elif not (ZC & ZB):
        band = "DISJOINT"
    else:
        band = "unbanded_overlap"
    print(f"  backward prime zeros Z_B ({len(ZB)}) : "
          f"{sorted(ZB, key=lambda p: (p[1], p[0]))}", flush=True)
    print(f"  centered prime zeros Z_C ({len(ZC)}) : "
          f"{sorted(ZC, key=lambda p: (p[1], p[0]))}", flush=True)
    print(f"  Z_C & Z_B : {sorted(ZC & ZB, key=lambda p: (p[1], p[0]))}",
          flush=True)
    print(f"  Z_C \\ Z_B : {sorted(ZC - ZB, key=lambda p: (p[1], p[0]))}",
          flush=True)
    print(f"  Z_B \\ Z_C : {sorted(ZB - ZC, key=lambda p: (p[1], p[0]))}",
          flush=True)
    print(f"\n  BAND: {band}", flush=True)

    # ---------------- read the result ---------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  Every number above is an exact Python integer. No float enters "
          "any table.", flush=True)
    print(f"  gate A (CSV reproduction)   : "
          f"{'PASSED' if gate_a_passed else ('NOT RUN' if gate_a_passed is None else 'FAILED')}",
          flush=True)
    print(f"  gate B (documented zero set): "
          f"{'PASSED' if gate_b_passed else 'FAILED'}", flush=True)
    print(f"  identity (a) backward       : "
          f"{'PASS' if ident_a_pass else 'FAIL'} over {ident_a_n} cells",
          flush=True)
    print(f"  identity (b) centered       : "
          f"{'PASS' if ident_b_pass else 'FAIL'} over {ident_b_n} cells",
          flush=True)
    print(f"  pre-registered band         : {band}", flush=True)
    print("  Interpretation of the band is NOT this script's job.", flush=True)

    # ---------------- payload -----------------------------------------------
    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT

        rows = []
        for name, tab in tables.items():
            for d in sorted(tab):
                row = tab[d]
                rr = sorted(row)
                vals = [row[r] for r in rr]
                mx = max(vals, key=abs)
                rows.append({
                    "table": name,
                    "depth": d,
                    "r_min": rr[0],
                    "r_max": rr[-1],
                    "n_cells": len(rr),
                    "max_abs_value": abs(mx),
                    "n_zeros": sum(1 for v in vals if v == 0),
                    "zeros_r": [r for r in rr if row[r] == 0],
                    "n_gap1_repeats": repeats[name]["gap1"][d],
                    "n_gap2_repeats": repeats[name]["gap2"][d],
                    "values": vals,
                })

        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "cache_path": args.cache,
                "cache_entries": len(P),
                "cache_n_min": n_min,
                "cache_n_max": n_max,
                "cache_contiguous": contiguous,
                "cache_key_format": "JSON object string keys holding decimal n",
                "r_available_max": R_full,
                "rmax_used": R,
                "rmax_flag": args.rmax,
                "max_depth_flag": args.max_depth,
                "backward_max_depth": max(B_prime),
                "centered_max_depth": max(C_prime),
                "centered_max_depth_formula": "floor((R-1)/2)",
                "print_rmax": args.print_rmax,
                "unit_csv": args.unit_csv,
                "composite_csv": args.composite_csv,
                "backward_convention": "B(r,d) = B(r,d-1) - B(r-1,d-1)",
                "centered_convention": "C(r,d) = C(r+1,d-1) - C(r-1,d-1)",
                "backward_support": "r = d+1 .. R",
                "centered_support": "r = d+1 .. R-d",
                "composite_definition": "M(r) = 2^(r-1) - N(r)",
                "fit_free": True,
                "precision": "exact integer (Python int)",
                "numpy_used": False,
            },
            "constants": {
                "centered_normalisation":
                    "unnormalised (factor 1/2 omitted; zeros are unaffected)",
                "backward_operator": "Delta = S - I (one-sided)",
                "centered_operator":
                    "(S - S^-1)/2 (skew-adjoint; i times it is Hermitian)",
                "backward_binary_identity":
                    "d-th backward difference of 2^(r-1) is 2^(r-d-1)",
                "centered_binary_identity":
                    "d-th unnormalised centered difference of 2^(r-1) is "
                    "3^d * 2^(r-1-d)",
                "documented_backward_zeros":
                    sorted(DOCUMENTED_BACKWARD_ZEROS),
                "gate_b_window": {"rmax": GATE_B_RMAX, "dmax": GATE_B_DMAX},
                "xlsx_cap_note":
                    "dyadic-difference-tables.xlsx caps at r = 50 because a "
                    "spreadsheet carries ~15 significant digits; Python ints "
                    "have no such limit",
                "o10_note":
                    "O10 is a deliberate gap in the series and is not filled "
                    "by this script",
                "prereg_bands": ["SAME", "SUPERSET", "SUBSET", "DISJOINT",
                                 "EMPTY", "unbanded_overlap"],
            },
            "summary": {
                "R": R,
                "N_first10": [Nseq[r] for r in range(1, min(10, R) + 1)],
                "N_last5": [Nseq[r] for r in range(max(1, R - 4), R + 1)],
                "M_first10": [Mseq[r] for r in range(1, min(10, R) + 1)],
                "M_last5": [Mseq[r] for r in range(max(1, R - 4), R + 1)],
                "extents": extents,
                "zeros": {k: [{"r": r, "depth": d} for (r, d) in v]
                          for k, v in zero_sets.items()},
                "zeros_detail": zero_detail,
                "depth0_zeros": d0_zeros,
                "identity_a_backward": {
                    "statement":
                        "composite_B(r,d) == 2^(r-d-1) - prime_B(r,d)",
                    "cells_checked": ident_a_n,
                    "mismatches": len(ident_a_bad),
                    "mismatch_detail": ident_a_bad[:50],
                    "passed": ident_a_pass,
                },
                "identity_b_centered": {
                    "statement":
                        "composite_C(r,d) == 3^d * 2^(r-1-d) - prime_C(r,d)",
                    "cells_checked": ident_b_n,
                    "mismatches": len(ident_b_bad),
                    "mismatch_detail": ident_b_bad[:50],
                    "passed": ident_b_pass,
                },
                "repeats": repeats,
                "repeat_relation": {
                    "backward":
                        "zero at depth d <=> gap-1 (adjacent) repeat at "
                        "depth d-1",
                    "centered":
                        "zero at depth d <=> gap-2 repeat at depth d-1; the "
                        "adjacent-repeat relation does NOT hold",
                },
                "gate_a": gate_a,
                "gate_a_passed": gate_a_passed,
                "gate_b": {
                    "window": {"rmax": GATE_B_RMAX, "dmax": GATE_B_DMAX},
                    "expected": sorted(DOCUMENTED_BACKWARD_ZEROS),
                    "found_in_window": [{"r": r, "depth": d}
                                        for (r, d) in in_window],
                    "missing": sorted(DOCUMENTED_BACKWARD_ZEROS
                                      - set(in_window)),
                    "unexpected": sorted(set(in_window)
                                         - DOCUMENTED_BACKWARD_ZEROS),
                    "outside_window_zeros": [{"r": r, "depth": d}
                                             for (r, d) in outside],
                    "searched": {"rmax": R, "dmax": max(B_prime)},
                    "passed": gate_b_passed,
                },
                "band": band,
                "band_sets": {
                    "Z_backward_prime": [{"r": r, "depth": d}
                                         for (r, d) in sorted(
                                             ZB, key=lambda p: (p[1], p[0]))],
                    "Z_centered_prime": [{"r": r, "depth": d}
                                         for (r, d) in sorted(
                                             ZC, key=lambda p: (p[1], p[0]))],
                    "intersection": [{"r": r, "depth": d}
                                     for (r, d) in sorted(
                                         ZC & ZB, key=lambda p: (p[1], p[0]))],
                    "centered_only": [{"r": r, "depth": d}
                                      for (r, d) in sorted(
                                          ZC - ZB, key=lambda p: (p[1], p[0]))],
                    "backward_only": [{"r": r, "depth": d}
                                      for (r, d) in sorted(
                                          ZB - ZC, key=lambda p: (p[1], p[0]))],
                },
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
