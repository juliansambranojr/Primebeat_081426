#!/usr/bin/env python3
"""
O27 — Joint dyadic/triadic prime difference table: one table, column-interleaved,
      built from exact integer backward differences of pi(2^r) and pi(3^r), and
      paired by the ROW INDEX r rather than by the value x = b^r.

Reads with: O16_centered_difference_table.py (the backward-difference construction
and the exact-integer discipline); O18_joint_multiplicative_ladder.py (the joint
{2^m 3^n} orbit); `pi2n_cache.json` (READ ONLY) and `pi3n_cache.json` (this
script's triadic companion cache).  CONTEXT.md § "Core quantities" defines
N(r) = pi(2^r) - pi(2^(r-1)) and the backward-difference table on it.

NAMING
------
The O-series in this tree runs O1-O9 and O11-O26.  There is NO O10: that number
is a known, DELIBERATE GAP, and this script does not fill it, because filling a
reserved gap with unrelated work would silently rewrite the series' history.  The
next free number after O26 is O27; this file takes it.  Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

STATUS
------
EXPLORATORY.  There is no prereg for this script, no hypothesis, and no decision
rule.  It builds and emits a table; it does not return a verdict.  Per
`CLAUDE.md` § "Prereg discipline", nothing this script prints may be described as
a verdict.

=============================================================================
WHAT THIS IS
=============================================================================

Two prime difference tables, one per base, built identically:

    depth 0, row r:   N_b(r)   = pi(b^r) - pi(b^(r-1))
                                 primes in the half-open block (b^(r-1), b^r]
    depth d, row r:   T_b(r,d) = T_b(r,d-1) - T_b(r-1,d-1)

Repeated BACKWARD differences down the depth axis, so T_b(r,d) is the
(d+1)-fold difference of pi evaluated along the geometric ladder b^r.  The
support is r = d+1 .. R; a cell with r < d+1 does not exist.

FIRST-BLOCK CONVENTION
----------------------
1 is neither prime nor composite, so pi(1) = 0.  The depth-0 row therefore reads

    N_b(1) = pi(b^1) - pi(b^0) = pi(b) - pi(1) = pi(b) - 0 = pi(b)

and the first block is the half-open interval (1, b], which EXCLUDES 1 and
INCLUDES b.  Concretely N_2(1) = pi(2) = 1 (the prime 2) and N_3(1) = pi(3) = 2
(the primes 2 and 3).  Every block is half-open on the same side, (b^(r-1), b^r],
so the blocks tile (1, b^R] exactly and no integer is counted twice or missed.
This is the convention already carried by `pi2n_cache.json`, whose entry for
n = 0 is 0; this script does not change it, and records it in the payload as
`params.first_block_convention`.

=============================================================================
THE JOINT LAYOUT — this is the deliverable
=============================================================================

ROWS are plain r = 1, 2, 3, ...  The two bases are NOT interleaved down the rows.

COLUMNS are interleaved by depth:

    d0_dyad, d0_tri, d1_dyad, d1_tri, d2_dyad, d2_tri, ...

PAIRING IS BY INDEX r, NOT BY MAGNITUDE.  Dyadic r = 10 (x = 1024) sits on the
same row as triadic r = 10 (x = 59049).  That is intentional and specified.  The
two bases walk their own ladders at their own speeds and the table asks what the
same STEP NUMBER looks like on each, not what the same VALUE looks like.  Do not
"fix" this by aligning on x — a value-aligned comparison is a different
instrument (see O18, which builds the joint {2^m 3^n} orbit in value space).

The consequence to keep in view when reading the table: the dyadic and triadic
entries on one row are counts over blocks of very different sizes, and the ratio
of block widths grows like (3/2)^r.  Any comparison of magnitudes across the two
halves of a row is a comparison of two different scales.

BLANK, NOT ZERO
---------------
A cell at (r, d) with r < d+1 does not exist — the backward difference has run
out of rows above it.  Those cells are emitted BLANK: the empty string in the
CSV, an empty cell in the markdown, JSON `null` in the payload.  They are never
padded with 0, because 0 is a meaningful value in these tables (the documented
backward zeros {(2,1), (4,1), (8,3), (20,6)} on the dyadic side are the whole
point of O16) and a padded zero would be indistinguishable from a real one.

RANGE
-----
The joint table extends only as far as BOTH bases have exact pi values, so

    R_joint = min(R_dyadic, R_triadic)

Depth runs the full triangle, d = 0 .. R_joint - 1.

pi() IS EXACT OR THE SCRIPT STOPS.  Values come from `primecountpy.prime_pi_128`
(the 128-bit entry point, needed because 3^40 > 2^63).  There is no li()
fallback, no asymptotic estimate, and no interpolation anywhere in this script.
If a needed pi(b^r) is not cached and `--compute-missing` was not passed, the
script stops at the last cached r and reports that as the limit.

ARITHMETIC
----------
EXACT PYTHON INTEGERS THROUGHOUT.  numpy is deliberately NOT imported: numpy
int64 would silently overflow (pi(3^41) is ~2.9e20, already past int64, and the
deep differences run past 1e32), and any float anywhere in these tables would be
a defect.  `params.precision` records "exact integer (Python int)".

USAGE
-----
    python3 O27_joint_dyadic_triadic_table.py
    python3 O27_joint_dyadic_triadic_table.py --compute-missing --rmax-triadic 41
    python3 O27_joint_dyadic_triadic_table.py --rmax 25 --md-max-depth 12
"""

import argparse
import hashlib
import json
import os
import sys
from datetime import datetime, timezone

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]

DEFAULT_CACHE_DYADIC = os.path.join(_HERE, "pi2n_cache.json")
DEFAULT_CACHE_TRIADIC = os.path.join(_HERE, "pi3n_cache.json")
DEFAULT_OUT_CSV = os.path.join(_HERE, "results",
                               "joint_dyadic_triadic_table.csv")
DEFAULT_OUT_MD = os.path.join(_HERE, "results",
                              "joint_dyadic_triadic_table.md")
DEFAULT_OUT_JSON = os.path.join(_HERE, "results",
                                "joint_dyadic_triadic_table.json")

BASE_DYADIC = 2
BASE_TRIADIC = 3

FIRST_BLOCK_CONVENTION = (
    "pi(1) = 0 (1 is neither prime nor composite). Block r covers the "
    "half-open interval (b^(r-1), b^r], so block 1 is (1, b] and excludes 1. "
    "Hence N_2(1) = pi(2) = 1 and N_3(1) = pi(3) = 2."
)


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
    no float path for table values here.  None passes through as JSON null,
    which is how a nonexistent cell is represented.
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


def _write_text(text, out_path, label):
    """Write a text artifact; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            fh.write(text)
        print(f"  {label} written to {out_path}", flush=True)
    except Exception as exc:
        print(f"  WARNING: could not write {label} to {out_path}: {exc}",
              flush=True)


# ---------------------------------------------------------------------------
# pi() backend
# ---------------------------------------------------------------------------

def _pi_backend():
    """
    Return (callable, name, version).  primecountpy.prime_pi_128 only — the
    128-bit entry point, because 3^40 = 1.2e19 exceeds 2^63.  There is no
    approximate fallback in this script by design: an estimated pi would make
    every difference below it fiction.
    """
    from primecountpy import prime_pi_128
    try:
        from importlib.metadata import version as _v
        ver = _v("primecountpy")
    except Exception as exc:
        ver = f"unavailable: {exc}"
    return prime_pi_128, "primecountpy.prime_pi_128", ver


def load_cache(path):
    """Read a {n: pi(b^n)} JSON cache.  Missing file -> empty dict."""
    if not os.path.exists(path):
        return {}
    with open(path, "r") as fh:
        raw = json.load(fh)
    return {int(k): int(v) for k, v in raw.items()}


def save_cache(cache, path):
    try:
        with open(path, "w") as fh:
            json.dump({str(k): int(cache[k]) for k in sorted(cache)}, fh,
                      indent=2)
    except Exception as exc:
        print(f"  WARNING: could not write cache {path}: {exc}", flush=True)


def contiguous_from_zero(cache):
    """Largest R such that n = 0..R are all present.  -1 if 0 is absent."""
    if 0 not in cache:
        return -1
    R = 0
    while (R + 1) in cache:
        R += 1
    return R


def fill_cache(cache, base, want_rmax, path, pi_fn, compute_missing, label):
    """
    Ensure n = 0..want_rmax are present.  With --compute-missing off, stop at the
    last contiguous cached n and report.  Returns (R_available, computed_list).
    """
    computed = []
    for n in range(0, want_rmax + 1):
        if n in cache:
            continue
        if not compute_missing:
            break
        x = base ** n
        print(f"    computing pi({base}^{n}) = pi({x}) ...", flush=True)
        t0 = datetime.now(timezone.utc)
        cache[n] = int(pi_fn(x))
        dt = (datetime.now(timezone.utc) - t0).total_seconds()
        computed.append({"n": n, "x": x, "pi": cache[n], "seconds": dt})
        print(f"      -> {cache[n]}   ({dt:.2f}s)", flush=True)
        save_cache(cache, path)
    R = contiguous_from_zero(cache)
    print(f"  {label}: contiguous cache n = 0..{R}   ({len(cache)} entries) "
          f"[{path}]", flush=True)
    return R, computed


# ---------------------------------------------------------------------------
# table construction — exact integers only
# ---------------------------------------------------------------------------

def counts(cache, R):
    """N_b(r) = pi(b^r) - pi(b^(r-1)) for r = 1..R.  Exact ints."""
    return {r: cache[r] - cache[r - 1] for r in range(1, R + 1)}


def backward_table(seq, R, max_depth):
    """
    T[0][r] = seq[r] for r = 1..R;
    T[d][r] = T[d-1][r] - T[d-1][r-1], support r = d+1..R.
    Returns {depth: {r: int}}.  Cells outside the support are simply absent —
    never zero-padded.
    """
    tab = {0: {r: seq[r] for r in range(1, R + 1)}}
    dmax = R - 1
    if max_depth is not None:
        dmax = min(dmax, max_depth)
    for d in range(1, dmax + 1):
        prev = tab[d - 1]
        tab[d] = {r: prev[r] - prev[r - 1] for r in range(d + 1, R + 1)}
    return tab


def column_names(dmax):
    """Interleaved header: d0_dyad, d0_tri, d1_dyad, d1_tri, ..."""
    names = []
    for d in range(0, dmax + 1):
        names.append(f"d{d}_dyad")
        names.append(f"d{d}_tri")
    return names


def joint_rows(tab_dyad, tab_tri, R, dmax):
    """
    One list per row r = 1..R, interleaved by depth.  A cell that does not exist
    is None (blank), never 0.
    """
    out = []
    for r in range(1, R + 1):
        cells = []
        for d in range(0, dmax + 1):
            cells.append(tab_dyad.get(d, {}).get(r))
            cells.append(tab_tri.get(d, {}).get(r))
        out.append(cells)
    return out


def render_csv(names, rows):
    lines = ["r," + ",".join(names)]
    for i, cells in enumerate(rows, start=1):
        lines.append(str(i) + "," +
                     ",".join("" if v is None else str(v) for v in cells))
    return "\n".join(lines) + "\n"


def render_md(names, rows, base_a, base_b, R, dmax, md_max_depth, header_note):
    """
    Markdown pipe table, right-aligned, monospace-friendly: every column padded
    to its own widest entry so the pipes line up when read in a fixed-width font.
    """
    if md_max_depth is None:
        n_cols = len(names)
        depth_note = f"depths 0..{dmax} (full triangle)"
    else:
        n_cols = 2 * (min(dmax, md_max_depth) + 1)
        depth_note = (f"depths 0..{min(dmax, md_max_depth)} rendered here; the "
                      f"CSV and JSON carry the full triangle to depth {dmax}")
    use_names = names[:n_cols]

    cols = [["r"] + [str(i) for i in range(1, R + 1)]]
    for j, nm in enumerate(use_names):
        col = [nm]
        for cells in rows:
            v = cells[j]
            col.append("" if v is None else str(v))
        cols.append(col)
    widths = [max(len(s) for s in col) for col in cols]

    def line(vals):
        return "| " + " | ".join(v.rjust(w) for v, w in zip(vals, widths)) + " |"

    body = [line([c[0] for c in cols]),
            "|" + "|".join("-" * (w + 1) + ":" for w in widths) + "|"]
    for i in range(1, R + 1):
        body.append(line([c[i] for c in cols]))

    head = [
        "# Joint dyadic/triadic prime difference table",
        "",
        header_note,
        "",
        f"- bases: dyadic b = {base_a}, triadic b = {base_b}",
        f"- rows: plain r = 1..{R} (NOT interleaved); row r pairs dyadic r with "
        f"triadic r **by index**, so r = 10 pairs x = {base_a**10} against "
        f"x = {base_b**10}",
        f"- columns: interleaved by depth — d0_dyad, d0_tri, d1_dyad, d1_tri, ...",
        f"- {depth_note}",
        "- blank cell = the cell does not exist (r < d+1); it is NOT zero",
        "- all values are exact Python integers; no float, no numpy, no estimate",
        "",
    ]
    return "\n".join(head + body) + "\n"


def main():
    ap = argparse.ArgumentParser(
        description="O27 — joint dyadic/triadic prime difference table, "
                    "column-interleaved by depth, paired by row index r")
    ap.add_argument("--base-dyadic", type=int, default=BASE_DYADIC,
                    help=f"the 'dyad' base (default {BASE_DYADIC})")
    ap.add_argument("--base-triadic", type=int, default=BASE_TRIADIC,
                    help=f"the 'tri' base (default {BASE_TRIADIC})")
    ap.add_argument("--cache-dyadic", type=str, default=DEFAULT_CACHE_DYADIC,
                    help="pi(2^n) cache JSON (READ ONLY unless "
                         "--compute-missing; default: pi2n_cache.json)")
    ap.add_argument("--cache-triadic", type=str, default=DEFAULT_CACHE_TRIADIC,
                    help="pi(3^n) cache JSON (default: pi3n_cache.json)")
    ap.add_argument("--rmax-dyadic", type=int, default=None,
                    help="cap r for the dyadic base (default: the full "
                         "contiguous range available in its cache)")
    ap.add_argument("--rmax-triadic", type=int, default=None,
                    help="cap r for the triadic base (default: the full "
                         "contiguous range available in its cache)")
    ap.add_argument("--rmax", type=int, default=None,
                    help="cap the JOINT r on top of the per-base caps "
                         "(default: min of the two per-base maxima)")
    ap.add_argument("--max-depth", type=int, default=None,
                    help="cap the difference depth (default: the natural "
                         "maximum, R_joint - 1, i.e. the full triangle)")
    ap.add_argument("--compute-missing", action="store_true",
                    help="allow calls to primecountpy to fill cache misses and "
                         "REWRITE the cache file. Off by default: pi(3^41) "
                         "costs minutes and the cost roughly doubles per r.")
    ap.add_argument("--md-max-depth", type=int, default=None,
                    help="render only depths 0..this in the markdown table "
                         "(default: the full triangle). CSV and JSON are "
                         "always full.")
    ap.add_argument("--print-rmax", type=int, default=12,
                    help="print the top-left corner of the joint table out to "
                         "this r on the console (default 12)")
    ap.add_argument("--print-depths", type=int, default=4,
                    help="how many depths of the console corner preview "
                         "(default 4, i.e. 8 interleaved columns)")
    ap.add_argument("--out-csv", type=str, default=DEFAULT_OUT_CSV,
                    help=f"CSV output path (default: {DEFAULT_OUT_CSV})")
    ap.add_argument("--out-md", type=str, default=DEFAULT_OUT_MD,
                    help=f"markdown output path (default: {DEFAULT_OUT_MD})")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help=f"results JSON path (default: {DEFAULT_OUT_JSON})")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    started = datetime.now(timezone.utc)

    print("=" * 78, flush=True)
    print("O27 — joint dyadic/triadic prime difference table  (EXPLORATORY: "
          "no prereg, no verdict)", flush=True)
    print("=" * 78, flush=True)
    print(f"  N_b(r)   = pi(b^r) - pi(b^(r-1))        primes in "
          f"(b^(r-1), b^r]", flush=True)
    print(f"  T_b(r,d) = T_b(r,d-1) - T_b(r-1,d-1)    backward, support "
          f"r = d+1..R", flush=True)
    print(f"  FIRST BLOCK: {FIRST_BLOCK_CONVENTION}", flush=True)
    print("  PAIRING: by ROW INDEX r, not by magnitude. Dyadic r=10 (x=1024) "
          "sits on the", flush=True)
    print("  same row as triadic r=10 (x=59049). Intentional — do not align "
          "on x.", flush=True)
    print("  BLANKS: a cell with r < d+1 does not exist and is emitted BLANK, "
          "never 0.", flush=True)
    print("  ARITHMETIC: exact Python int throughout. numpy is deliberately "
          "NOT imported.", flush=True)

    # ---------------- backend ----------------------------------------------
    pi_fn, pi_name, pi_ver = _pi_backend()
    print("\n" + "-" * 78, flush=True)
    print("pi() BACKEND", flush=True)
    print("-" * 78, flush=True)
    print(f"  callable : {pi_name}", flush=True)
    print(f"  version  : primecountpy {pi_ver}", flush=True)
    print(f"  python   : {sys.version.split()[0]}", flush=True)
    print("  no approximate fallback: if pi is unavailable the script stops "
          "rather than", flush=True)
    print("  estimating.", flush=True)

    # ---------------- caches ------------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("CACHES", flush=True)
    print("-" * 78, flush=True)
    cache_a = load_cache(args.cache_dyadic)
    cache_b = load_cache(args.cache_triadic)

    want_a = args.rmax_dyadic if args.rmax_dyadic is not None else \
        contiguous_from_zero(cache_a)
    want_b = args.rmax_triadic if args.rmax_triadic is not None else \
        contiguous_from_zero(cache_b)

    R_a, computed_a = fill_cache(cache_a, args.base_dyadic, max(want_a, 0),
                                 args.cache_dyadic, pi_fn,
                                 args.compute_missing, "dyadic")
    R_b, computed_b = fill_cache(cache_b, args.base_triadic, max(want_b, 0),
                                 args.cache_triadic, pi_fn,
                                 args.compute_missing, "triadic")

    if args.rmax_dyadic is not None:
        R_a = min(R_a, args.rmax_dyadic)
    if args.rmax_triadic is not None:
        R_b = min(R_b, args.rmax_triadic)

    if R_a < 1 or R_b < 1:
        print("\n  STOP: one of the bases has no usable exact pi data "
              f"(R_dyadic={R_a}, R_triadic={R_b}). Nothing estimated.",
              flush=True)
        return

    R_base = min(R_a, R_b)
    limited_by = ("exact pi data on the dyadic base" if R_a < R_b else
                  "exact pi data on the triadic base" if R_b < R_a else
                  "exact pi data on both bases (equal)")
    R = R_base
    if args.rmax is not None and args.rmax < R_base:
        R = args.rmax
        limited_by = f"--rmax flag ({args.rmax}); exact pi data reached {R_base}"

    dmax = R - 1
    if args.max_depth is not None:
        dmax = min(dmax, args.max_depth)

    print(f"\n  R_dyadic  (exact pi available) : {R_a}   "
          f"largest x = {args.base_dyadic}^{R_a} = {args.base_dyadic ** R_a}",
          flush=True)
    print(f"  R_triadic (exact pi available) : {R_b}   "
          f"largest x = {args.base_triadic}^{R_b} = {args.base_triadic ** R_b}",
          flush=True)
    print(f"  R_joint = min(R_dyadic, R_triadic) = {R}   "
          f"(limited by: {limited_by})", flush=True)
    print(f"  depth range : d = 0..{dmax}  "
          f"({'full triangle' if dmax == R - 1 else 'capped by --max-depth'})",
          flush=True)

    # ---------------- counts and tables -------------------------------------
    Na = counts(cache_a, R)
    Nb = counts(cache_b, R)
    Ta = backward_table(Na, R, dmax)
    Tb = backward_table(Nb, R, dmax)

    print("\n" + "-" * 78, flush=True)
    print("DEPTH-0 COUNTS (first 12 r)", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'r':>3} {'N_dyad(r)':>22} {'N_tri(r)':>24}", flush=True)
    for r in range(1, min(12, R) + 1):
        print(f"  {r:>3} {Na[r]:>22} {Nb[r]:>24}", flush=True)

    names = column_names(dmax)
    rows = joint_rows(Ta, Tb, R, dmax)

    n_cells_total = len(rows) * len(names)
    n_blank = sum(1 for cells in rows for v in cells if v is None)
    n_present = n_cells_total - n_blank
    n_zero_a = sum(1 for d in Ta for r in Ta[d] if Ta[d][r] == 0)
    n_zero_b = sum(1 for d in Tb for r in Tb[d] if Tb[d][r] == 0)
    zeros_a = sorted(((r, d) for d in Ta for r in Ta[d] if Ta[d][r] == 0),
                     key=lambda p: (p[1], p[0]))
    zeros_b = sorted(((r, d) for d in Tb for r in Tb[d] if Tb[d][r] == 0),
                     key=lambda p: (p[1], p[0]))

    print("\n" + "-" * 78, flush=True)
    print("JOINT TABLE EXTENT", flush=True)
    print("-" * 78, flush=True)
    print(f"  rows              : {len(rows)}   (r = 1..{R})", flush=True)
    print(f"  columns           : {len(names)}   (2 x (dmax+1), interleaved)",
          flush=True)
    print(f"  grid cells        : {n_cells_total}", flush=True)
    print(f"  populated cells   : {n_present}", flush=True)
    print(f"  blank cells       : {n_blank}   (r < d+1; NOT zero-padded)",
          flush=True)
    print(f"  exact zeros dyad  : {n_zero_a}  at {zeros_a if zeros_a else '(none)'}",
          flush=True)
    print(f"  exact zeros tri   : {n_zero_b}  at {zeros_b if zeros_b else '(none)'}",
          flush=True)

    # ---------------- console corner preview --------------------------------
    pr = min(args.print_rmax, R)
    pd = min(args.print_depths, dmax + 1)
    show = names[:2 * pd]
    print("\n" + "-" * 78, flush=True)
    print(f"TOP-LEFT CORNER — first {pr} rows, first {len(show)} columns "
          f"(depths 0..{pd - 1})", flush=True)
    print("-" * 78, flush=True)
    cols = [["r"] + [str(i) for i in range(1, pr + 1)]]
    for j, nm in enumerate(show):
        col = [nm]
        for cells in rows[:pr]:
            v = cells[j]
            col.append("" if v is None else str(v))
        cols.append(col)
    widths = [max(len(s) for s in col) for col in cols]
    for i in range(0, pr + 1):
        print("  " + "  ".join(c[i].rjust(w) for c, w in zip(cols, widths)),
              flush=True)

    # ---------------- artifacts ---------------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("ARTIFACTS", flush=True)
    print("-" * 78, flush=True)
    header_note = (
        "Built by `O27_joint_dyadic_triadic_table.py`. EXPLORATORY — no prereg, "
        "no verdict.")
    _write_text(render_csv(names, rows), args.out_csv, "CSV")
    _write_text(render_md(names, rows, args.base_dyadic, args.base_triadic,
                          R, dmax, args.md_max_depth, header_note),
                args.out_md, "markdown")

    ended = datetime.now(timezone.utc)

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "base_dyadic": args.base_dyadic,
                "base_triadic": args.base_triadic,
                "cache_dyadic": args.cache_dyadic,
                "cache_triadic": args.cache_triadic,
                "rmax_dyadic_flag": args.rmax_dyadic,
                "rmax_triadic_flag": args.rmax_triadic,
                "rmax_flag": args.rmax,
                "max_depth_flag": args.max_depth,
                "compute_missing": args.compute_missing,
                "md_max_depth": args.md_max_depth,
                "print_rmax": args.print_rmax,
                "print_depths": args.print_depths,
                "out_csv": os.path.abspath(args.out_csv),
                "out_md": os.path.abspath(args.out_md),
                "out_json": os.path.abspath(args.out),
                "r_max_dyadic": R_a,
                "r_max_triadic": R_b,
                "r_max_joint": R,
                "r_max_joint_limited_by": limited_by,
                "depth_max": dmax,
                "depth_range": "d = 0 .. R_joint - 1 (full triangle)"
                               if dmax == R - 1 else
                               "d = 0 .. --max-depth",
                "first_block_convention": FIRST_BLOCK_CONVENTION,
                "block_interval": "(b^(r-1), b^r]  half-open, blocks tile "
                                  "(1, b^R] exactly",
                "difference_convention": "T(r,d) = T(r,d-1) - T(r-1,d-1) "
                                         "(backward)",
                "support": "r = d+1 .. R; cells with r < d+1 do not exist",
                "missing_cell_encoding": {"csv": "empty field",
                                          "markdown": "empty cell",
                                          "json": "null"},
                "zero_padding": False,
                "pairing": "by ROW INDEX r, not by value x = b^r "
                           "(specified; deliberate)",
                "column_order": "interleaved by depth: d0_dyad, d0_tri, "
                                "d1_dyad, d1_tri, ...",
                "pi_backend": pi_name,
                "pi_backend_package": "primecountpy",
                "pi_backend_version": pi_ver,
                "pi_fallback": "none — exact or stop",
                "python_version": sys.version.split()[0],
                "precision": "exact integer (Python int)",
                "numpy_used": False,
                "fit_free": True,
                "prereg": None,
                "status": "exploratory",
            },
            "constants": {
                "bases": [args.base_dyadic, args.base_triadic],
                "pi_of_1": 0,
                "documented_backward_zeros_dyadic":
                    [[2, 1], [4, 1], [8, 3], [20, 6]],
                "documented_backward_zeros_note":
                    "the dyadic zero set recorded by O16 within r<=50, d<=30; "
                    "reproduced here as a cross-check, not as a gate",
                "block_width_ratio_note":
                    "on row r the triadic block is wider than the dyadic one "
                    "by (3/2)^r; magnitudes across a row are not comparable",
            },
            "summary": {
                "r_max_dyadic": R_a,
                "r_max_triadic": R_b,
                "r_max_joint": R,
                "limited_by": limited_by,
                "largest_x_dyadic": args.base_dyadic ** R_a,
                "largest_x_triadic": args.base_triadic ** R_b,
                "depth_max": dmax,
                "n_rows": len(rows),
                "n_columns": len(names),
                "grid_cells": n_cells_total,
                "populated_cells": n_present,
                "blank_cells": n_blank,
                "columns": names,
                "N_dyadic_first12": [Na[r] for r in range(1, min(12, R) + 1)],
                "N_triadic_first12": [Nb[r] for r in range(1, min(12, R) + 1)],
                "N_dyadic_last": Na[R],
                "N_triadic_last": Nb[R],
                "exact_zeros_dyadic": [{"r": r, "depth": d} for (r, d) in zeros_a],
                "exact_zeros_triadic": [{"r": r, "depth": d} for (r, d) in zeros_b],
                "cache_computed_dyadic": computed_a,
                "cache_computed_triadic": computed_b,
            },
            "rows": [
                {"r": i,
                 "cells": {nm: cells[j] for j, nm in enumerate(names)}}
                for i, cells in enumerate(rows, start=1)
            ],
        }
        _write_results(payload, args.out)

    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  Every number above is an exact Python integer. No float, no "
          "estimate, no li().", flush=True)
    print(f"  Joint range r = 1..{R}, limited by: {limited_by}.", flush=True)
    print("  This script states no hypothesis and fires no decision rule. Its "
          "output is a", flush=True)
    print("  table, and is EXPLORATORY per CLAUDE.md § Prereg discipline.",
          flush=True)


if __name__ == "__main__":
    main()
