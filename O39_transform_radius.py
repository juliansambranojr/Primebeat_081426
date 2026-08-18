#!/usr/bin/env python3
"""
O39 - Transform radius: take each depth column of the dyadic difference table as
      the coefficient list of a finite power series, find that polynomial's
      complex roots, and ask what radius they sit on - against a smooth control
      built by the identical construction.

Reads with: O27_joint_dyadic_triadic_table.py (the exact-integer backward
difference table T(r,d) = T(r,d-1) - T(r-1,d-1) and its half-open first-block
convention); O29_depth_residuals.py (the smooth model differenced by the SAME
operator, and the prime-minus-smooth residual table); O33_base_ladder_crossing.py
(the "record the pre-stated numbers verbatim, then measure against them" layout
and the full CLI flag set).  CONTEXT.md § "Core quantities" defines
N(r) = pi(2^r) - pi(2^(r-1)) and the backward difference table on it.

NAMING
------
The O-series in this tree runs O1-O9, O11-O27 and O29-O38.  O10 and O28 are
known, DELIBERATE GAPS and this script does not fill either of them.  The next
free number is O39; this file takes it.  Capital "O" per `CLAUDE.md` § "Naming
convention (do not re-break)".

STATUS
------
EXPLORATORY.  There is no prereg for this script, no hypothesis stated in a
locked protocol, and no decision rule.  It emits measured root radii next to
pre-stated expected ones; it does NOT return a verdict, and no number it prints
may be described as one.  Per `CLAUDE.md` § "Prereg discipline", the word
"verdict" is reserved for 07/O7.

PROVENANCE
----------
The measurement was first computed INLINE during a session on 2026-08-17 and was
never written to a file.  This script is the RECONSTRUCTION of that computation.
The numbers produced inline are recorded verbatim below as
`EXPECTED_VERBATIM` - they are an INPUT to this run, not its output.  The script
recomputes everything independently and reports measured-minus-expected for each
cell, so that a failure to reproduce is visible in the output rather than
absorbed silently.

=============================================================================
WHAT IS COMPUTED
=============================================================================

Three triangles over r = 1..R (R = --rmax, default 45), base b = --base
(default 2), all from the SAME backward-difference operator:

    T_prime(r, 0)  = pi(b^r) - pi(b^(r-1))          exact integers
    T_smooth(r, 0) = R(b^r) - R(b^(r-1))            mpmath.riemannr, at --dps
    T_resid        = T_prime - T_smooth             cellwise

    T(r, d) = T(r, d-1) - T(r-1, d-1)   for all three, support r = d+1 .. R

Then for each depth d, the cells down that depth's column,

    coeffs = [ T(r, d) for r = d+1 .. R ]

are read as the coefficients of the FINITE-TRUNCATION z-transform

    G_d(z) = sum_r T(r, d) z^r

and its complex roots are taken with `numpy.roots`, which expects
highest-degree-first, so the coefficient array is REVERSED before the call:
`np.roots(np.array(coeffs[::-1]))`.  This is the same convention the original
inline computation used and it is not a free choice - reversing changes which
end of the column is the leading coefficient.

Per (triangle, depth) the script reports: n_roots, mean |z|, min |z|, max |z|,
and the relative spread std(|z|) / mean(|z|).

=============================================================================
WHAT IT MEANS - and what it does NOT mean
=============================================================================

The radius of convergence of sum_r a_r z^r with a_r growing like b^(sigma r) is
b^(-sigma).  So:

    the SMOOTH part grows like x^1        -> radius b^(-1)   = 0.5      (b = 2)
    the RESIDUAL   grows like x^(1/2)     -> radius b^(-1/2) = 0.70711  (b = 2)

JENTZSCH'S THEOREM - the reason the control is mandatory.  The roots of the
partial sums of ANY power series accumulate on its circle of convergence.  So
the mere existence of a circle of roots is GENERIC and carries NO information
whatsoever about primes.  Finding one here would be finding nothing.

What is NOT generic is WHERE the circle sits.  The smooth control is what
separates the two claims: it is built by the identical construction from a
purely smooth model, and it stays PINNED near b^(-1) = 0.5 at every depth, while
the prime table's circle MIGRATES OUTWARD from about 0.54 at d = 0 to about 0.75
by d = 14 - toward the residual's b^(-1/2).  The control is the measurement; the
prime circle alone is not.

TRUNCATION OFFSET.  Both measured radii sit ABOVE their theoretical values by
very nearly the same fraction (about +6.7%: 0.5330 against 0.5, and 0.7543
against 0.70711).  A finite truncation of a power series does not place its
roots exactly on the circle of convergence, so an offset is expected.  Because
the offset is the SAME for both, it is a truncation artifact and not a real
difference between them.  This script COMPUTES both offsets and prints them side
by side, so their equality is visible in the output rather than asserted in
prose.  See `--offset-smooth-depth` / `--offset-resid-depth`.

THE ANNULUS.  In the region

    b^(-1) < |z| < b^(-1/2)      i.e.  0.5 < |z| < 0.70711  for b = 2

the residual's transform is analytic and the smooth part's is not.  Its
conformal modulus is

    m = (1 / 2pi) * log(R_outer / R_inner) = log(b) / (4 pi)

which for b = 2 is (log 2) / (4 pi) = 0.05515890.  (The inline session recorded
0.055132 for this constant; the script computes it and reports the difference
rather than adopting either number by fiat.)

BREAKDOWN AT DEEP d.  A depth-d column holds only R - d coefficients.  As d
grows the polynomial degree falls and the root cloud stops being a circle: the
prime table's roots at d = 20 span 0.6813 to 2.0723, a relative spread of 0.30.
The script does not hardcode where this begins.  It reports `breakdown_depth`
per triangle in two forms, both derived from --breakdown-tol:

    onset            smallest d whose relative spread exceeds the tolerance at
                     d AND at the next --breakdown-run - 1 depths.  The run
                     requirement matters: at d = 1 the prime table's spread is
                     0.155, but that is not breakdown - it is the exact table
                     zero at cell (2, 1) (one of the four known zeros,
                     CONTEXT.md § "Core quantities") sitting in the constant
                     term of the polynomial and putting one root exactly at
                     z = 0, and the very next depth is back under tolerance.
                     Depths whose leading-diagonal cell is an exact zero are
                     flagged `has_zero_root`.

    last_sustained   smallest d that exceeds the tolerance at d and at EVERY
                     deeper d.  At the very bottom of the triangle only a
                     handful of coefficients remain and the few surviving roots
                     can re-cluster tightly, so this sits much deeper than the
                     onset and is the weaker of the two.  Both are reported;
                     neither is ruled on.

=============================================================================
OUTPUTS
=============================================================================

results/transform_radius.csv    one line per (triangle, depth):
                                triangle, d, n_roots, mean_abs, min_abs,
                                max_abs, rel_spread
results/transform_radius.json   house envelope, schema_version "1": script,
                                generated_utc, params, constants, summary, rows.
                                `constants` carries the two theoretical radii,
                                the annulus and its modulus, and
                                `expected_verbatim` - the inline session's
                                numbers recorded as an INPUT.  `summary`
                                carries the measured-minus-expected differences
                                and the two truncation offsets.

Both filenames are NEW; nothing existing under results/ is touched.  Both paths
are anchored to _HERE so runs are cwd-independent.  --out, --out-csv, --no-json
and --no-csv are honoured per CONTEXT.md § "Output schema".

NO HARDCODED PARAMETERS.  Every quantity above is a flag: --rmax, --base,
--depths, --dps, --breakdown-tol, --breakdown-run,
--offset-smooth-depth, --offset-resid-depth,
--min-coeffs, --smooth-anchor, --cache, --results-dir, --out, --out-csv,
--no-json, --no-csv.  The open NOTEPAD thread recording hardcoded parameters as
a defect in O30/O31/O32 does not extend to this file.

EXAMPLE
-------
    python3 O39_transform_radius.py
    python3 O39_transform_radius.py --rmax 45 --base 2 --dps 60 \\
        --depths 0,1,3,6,10,14,20 --breakdown-tol 0.05

REQUIREMENTS
------------
    pip install mpmath numpy primecountpy
"""

import argparse
import csv
import datetime
import hashlib
import json
import math
import os
import sys

try:
    import numpy as np
except ImportError:
    raise ImportError(
        "numpy is required and is NOT optional: the whole measurement is "
        "numpy.roots on the depth columns. Install with: pip install numpy")

try:
    import mpmath
    from mpmath import mp, mpf
except ImportError:
    raise ImportError(
        "mpmath is required and is NOT optional: the smooth model is "
        "differenced d+1 times and that cancellation has no float fallback. "
        "Install with: pip install mpmath")


_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "transform_radius.json")
DEFAULT_OUT_CSV = os.path.join(DEFAULT_RESULTS_DIR, "transform_radius.csv")

# pi(b^n) caches, READ ONLY. This script never writes a cache.
CACHE_NAMES = {2: "pi2n_cache.json", 3: "pi3n_cache.json"}

TRIANGLES = ("prime", "smooth", "resid")
TRIANGLE_LABELS = {
    "prime": "prime table",
    "smooth": "smooth control",
    "resid": "residual only",
}

FIRST_BLOCK_CONVENTION = (
    "pi(1) = 0. Block r covers the half-open interval (b^(r-1), b^r], so block "
    "1 is (1, b] and excludes 1. Same convention as O27 and O29.")

# ---------------------------------------------------------------------------
# EXPECTED VALUES -- computed INLINE in the session of 2026-08-17, supplied by
# the brief, recorded VERBATIM.  These are an INPUT to this run.  Nothing below
# adjusts them, and no measured number is ever substituted into them.
# ---------------------------------------------------------------------------
EXPECTED_VERBATIM = """\
mean |z| by depth:

 d    prime table   smooth control   residual only
 0       0.5406         0.5330          0.7625
 1       0.5216         0.5286          0.7483
 3       0.5543         0.5227          0.7527
 6       0.6013         0.5176          0.7543
10       0.6652         0.5139          0.7577
14       0.7537         0.5117            -

Also expected: at d=0 the prime table's 44 roots span 0.5293 to 0.5488
(relative spread 0.0079); at d=6 its 38 roots span 0.5628 to 0.6242 (spread
0.0282); the smooth control's min and max are within about 0.001 of each other
at every depth; the residual's spread is 0.0202 at d=3 and 0.0164 at d=6.  At
d=20 the prime table breaks down -- roots span 0.6813 to 2.0723, spread 0.30 --
because too few coefficients remain."""

EXPECTED_MEAN_ABS = {
    0:  {"prime": 0.5406, "smooth": 0.5330, "resid": 0.7625},
    1:  {"prime": 0.5216, "smooth": 0.5286, "resid": 0.7483},
    3:  {"prime": 0.5543, "smooth": 0.5227, "resid": 0.7527},
    6:  {"prime": 0.6013, "smooth": 0.5176, "resid": 0.7543},
    10: {"prime": 0.6652, "smooth": 0.5139, "resid": 0.7577},
    14: {"prime": 0.7537, "smooth": 0.5117, "resid": None},
}

EXPECTED_DETAIL = {
    "prime_d0": {"n_roots": 44, "min_abs": 0.5293, "max_abs": 0.5488,
                 "rel_spread": 0.0079},
    "prime_d6": {"n_roots": 38, "min_abs": 0.5628, "max_abs": 0.6242,
                 "rel_spread": 0.0282},
    "prime_d20": {"min_abs": 0.6813, "max_abs": 2.0723, "rel_spread": 0.30},
    "resid_d3": {"rel_spread": 0.0202},
    "resid_d6": {"rel_spread": 0.0164},
    "smooth_minmax_gap_note": (
        "min and max within about 0.001 of each other at every depth"),
}

# The inline session's value for the annulus modulus. The script computes the
# constant itself and reports the difference; this is recorded, not adopted.
EXPECTED_ANNULUS_MODULUS = 0.055132


# ---------------------------------------------------------------------------
# house plumbing (O29 / O33, unchanged)
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


def _write_csv(rows, fieldnames, out_path):
    """Write a CSV artifact; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=fieldnames, extrasaction="ignore")
            w.writeheader()
            for r in rows:
                w.writerow(r)
        print(f"  csv written to {out_path}", flush=True)
    except Exception as exc:
        print(f"  WARNING: could not write CSV to {out_path}: {exc}", flush=True)


# ---------------------------------------------------------------------------
# pi(b^r) -- cache READ ONLY, then primecountpy, then sympy
# ---------------------------------------------------------------------------

def load_cache(path):
    """Read a {n: pi(b^n)} JSON cache. Missing file -> empty dict."""
    if not path or not os.path.exists(path):
        return {}
    try:
        with open(path, "r") as fh:
            raw = json.load(fh)
        return {int(k): int(v) for k, v in raw.items()}
    except Exception as exc:
        print(f"  WARNING: could not read cache {path}: {exc}", flush=True)
        return {}


def prime_counts(base, rmax, cache_path):
    """pi(base^r) for r = 0..rmax, exact ints. Cache first, then primecountpy,
    then sympy. The cache is never written."""
    cache = load_cache(cache_path)
    out = []
    used = {"cache": 0, "primecountpy": 0, "sympy": 0}
    pc = None
    sp = None
    for r in range(0, rmax + 1):
        if r in cache:
            out.append(int(cache[r]))
            used["cache"] += 1
            continue
        x = base ** r
        if pc is None:
            try:
                import primecountpy
                pc = primecountpy
            except ImportError:
                pc = False
        if pc:
            out.append(int(pc.prime_pi(x)))
            used["primecountpy"] += 1
            continue
        if sp is None:
            try:
                from sympy import primepi as _pp
                sp = _pp
            except ImportError:
                raise ImportError(
                    f"pi({base}^{r}) is not in the cache and neither "
                    "primecountpy nor sympy is available.")
        out.append(int(sp(x)))
        used["sympy"] += 1
    return out, used


# ---------------------------------------------------------------------------
# the triangles
# ---------------------------------------------------------------------------

def build_triangle(vals, rmax):
    """Backward difference table from a ladder indexed r = 0..rmax.

    Depth-0 row is vals[r] - vals[r-1]; then T(r,d) = T(r,d-1) - T(r-1,d-1).
    Support is r = d+1 .. rmax. Identical to O27 / O29 / O33."""
    T = {}
    for r in range(1, rmax + 1):
        T[(r, 0)] = vals[r] - vals[r - 1]
    for d in range(1, rmax):
        for r in range(d + 1, rmax + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def smooth_ladder(base, rmax, anchor):
    """R(base^r) for r = 0..rmax at the current mp.dps.

    anchor = 'natural' uses R(1) as mpmath gives it; anchor = 'zero' sets
    R(b^0) := 0, mirroring pi(1) = 0 the way O29 anchors its smooth models.
    Only the leading diagonal r = d+1 can depend on this choice."""
    impl = "mpmath.riemannr" if hasattr(mpmath, "riemannr") else "mobius_sum"
    if impl == "mpmath.riemannr":
        f = mpmath.riemannr
    else:
        from mpmath import mobius, li
        def f(x):
            s = mpf(0)
            n = 1
            while True:
                m = mobius(n)
                if m:
                    t = mpf(m) / n * li(mpf(x) ** (mpf(1) / n))
                    s += t
                n += 1
                if n > 60:
                    break
            return s
    vals = [f(mpf(base) ** r) for r in range(0, rmax + 1)]
    if anchor == "zero":
        vals[0] = mpf(0)
    return vals, impl


def column_roots(T, d, rmax, min_coeffs):
    """Roots of G_d(z) = sum_r T(r,d) z^r over the depth-d column.

    numpy.roots wants highest-degree-first, so the column is REVERSED before
    the call -- exactly as the original inline computation did it."""
    coeffs = [T[(r, d)] for r in range(d + 1, rmax + 1)]
    if len(coeffs) < min_coeffs:
        return None
    arr = np.array([float(c) for c in coeffs[::-1]], dtype=float)
    if not np.all(np.isfinite(arr)):
        return None
    if np.all(arr == 0.0):
        return None
    roots = np.roots(arr)
    if roots.size == 0:
        return None
    mag = np.abs(roots)
    return {
        "n_coeffs": len(coeffs),
        "leading_diagonal_cell_is_zero": bool(float(coeffs[0]) == 0.0),
        "n_roots": int(mag.size),
        "mean_abs": float(mag.mean()),
        "min_abs": float(mag.min()),
        "max_abs": float(mag.max()),
        "rel_spread": (float(mag.std() / mag.mean()) if mag.mean() != 0.0
                       else None),
        "has_zero_root": bool(mag.min() == 0.0),
    }


def breakdown_depth(per_depth, tol, run):
    """Where the root cloud stops being a circle. Two depths, reported apart.

    `onset`: the smallest d whose rel_spread exceeds tol at d and at the next
    `run` - 1 depths as well. The run requirement is what keeps a SINGLE
    anomalous depth from reading as breakdown -- at d = 1 the prime table's
    spread is inflated by the exact table zero at cell (2,1) putting one root
    at z = 0, and the very next depth is back under tol.

    `last_sustained`: the smallest d that exceeds tol at d and at EVERY deeper
    d. At the bottom of a triangle only a handful of coefficients remain and
    the few surviving roots can re-cluster, so this can sit far below the
    onset in usefulness; both are reported and neither is ruled on."""
    ds = sorted(k for k, v in per_depth.items()
                if v is not None and v.get("rel_spread") is not None)
    if not ds:
        return {"onset": None, "last_sustained": None}
    over = {d: (per_depth[d]["rel_spread"] > tol) for d in ds}
    onset = None
    for i, d in enumerate(ds):
        window = ds[i:i + run]
        if len(window) < run:
            break
        if all(over[w] for w in window):
            onset = d
            break
    last = None
    for d in reversed(ds):
        if over[d]:
            last = d
        else:
            break
    return {"onset": onset, "last_sustained": last}


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def parse_depths(s, dmax):
    if s.strip().lower() == "all":
        return list(range(0, dmax + 1))
    out = []
    for tok in s.split(","):
        tok = tok.strip()
        if tok:
            out.append(int(tok))
    return sorted(set(out))


def main(argv=None):
    ap = argparse.ArgumentParser(
        description=("O39 - root radius of the finite-truncation z-transform "
                     "of each depth column, against a smooth control. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict."))
    ap.add_argument("--rmax", type=int, default=45,
                    help="ladder top: rows r = 1..RMAX (default 45)")
    ap.add_argument("--base", type=int, default=2,
                    help="ladder base b (default 2, the dyadic ladder)")
    ap.add_argument("--depths", type=str, default="0,1,3,6,10,14,20",
                    help=("depths highlighted in the console table and in "
                          "summary.highlight; 'all' for every depth. Every "
                          "depth is computed regardless -- this selects what "
                          "is printed (default 0,1,3,6,10,14,20)"))
    ap.add_argument("--dps", type=int, default=60,
                    help="mpmath working precision for the smooth model "
                         "(default 60)")
    ap.add_argument("--smooth-anchor", type=str, default="natural",
                    choices=("natural", "zero"),
                    help="R(b^0): 'natural' = R(1) as mpmath gives it "
                         "(default), 'zero' = 0, mirroring pi(1) = 0")
    ap.add_argument("--min-coeffs", type=int, default=3,
                    help="skip a depth column with fewer coefficients than "
                         "this (default 3)")
    ap.add_argument("--breakdown-tol", type=float, default=0.05,
                    help="relative-spread threshold defining root-structure "
                         "breakdown (default 0.05)")
    ap.add_argument("--breakdown-run", type=int, default=3,
                    help="how many consecutive depths must exceed "
                         "--breakdown-tol for the first of them to count as "
                         "the breakdown onset (default 3)")
    ap.add_argument("--offset-smooth-depth", type=int, default=0,
                    help="depth at which the smooth control's truncation "
                         "offset against b^(-1) is reported (default 0)")
    ap.add_argument("--offset-resid-depth", type=int, default=6,
                    help="depth at which the residual's truncation offset "
                         "against b^(-1/2) is reported (default 6)")
    ap.add_argument("--cache", type=str, default=None,
                    help="pi(b^n) cache JSON, READ ONLY. Default is "
                         "pi2n_cache.json / pi3n_cache.json next to this "
                         "script; missing entries fall through to "
                         "primecountpy then sympy")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--out-csv", type=str, default=DEFAULT_OUT_CSV,
                    help="results CSV path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    ap.add_argument("--no-csv", action="store_true",
                    help="do not write the results CSV")
    args = ap.parse_args(argv)

    started = datetime.datetime.now(datetime.timezone.utc)
    mp.dps = args.dps
    b = args.base
    R = args.rmax
    dmax = R - 2

    cache_path = args.cache
    if cache_path is None:
        name = CACHE_NAMES.get(b)
        cache_path = os.path.join(_HERE, name) if name else None

    print("=" * 78)
    print("O39 - transform radius of the depth columns    EXPLORATORY")
    print("      no prereg, no decision rule, no verdict")
    print("=" * 78)
    print(f"  base b            {b}")
    print(f"  ladder            r = 1..{R}")
    print(f"  mp.dps            {mp.dps}")
    print(f"  pi cache          {cache_path} (READ ONLY)")
    print(f"  smooth anchor     R(b^0) = {args.smooth_anchor}")

    # theory
    r_inner = float(b) ** -1.0
    r_outer = float(b) ** -0.5
    modulus = math.log(b) / (4.0 * math.pi)

    print("\n  theoretical radii (radius of convergence = b^(-sigma)):")
    print(f"    smooth part   grows x^1     -> b^(-1)   = {r_inner:.8f}")
    print(f"    residual      grows x^(1/2) -> b^(-1/2) = {r_outer:.8f}")
    print(f"    annulus       {r_inner:.5f} < |z| < {r_outer:.5f}")
    print(f"    modulus       log(b)/(4 pi) = {modulus:.8f}")
    if b == 2:
        print(f"    (session recorded {EXPECTED_ANNULUS_MODULUS:.6f}; "
              f"difference {modulus - EXPECTED_ANNULUS_MODULUS:+.6e})")
    else:
        print(f"    (the session's recorded modulus "
              f"{EXPECTED_ANNULUS_MODULUS:.6f} is a base-2 number and is not "
              "comparable here)")

    # ladders
    print("\n  loading pi(b^r) ...", flush=True)
    pi_vals, cache_use = prime_counts(b, R, cache_path)
    print(f"    {cache_use}")
    print("  evaluating the smooth model ...", flush=True)
    sm_vals, riemannr_impl = smooth_ladder(b, R, args.smooth_anchor)
    print(f"    impl = {riemannr_impl}")

    T_prime = build_triangle([mpf(v) for v in pi_vals], R)
    T_smooth = build_triangle(sm_vals, R)
    T_resid = {k: T_prime[k] - T_smooth[k] for k in T_prime}
    tris = {"prime": T_prime, "smooth": T_smooth, "resid": T_resid}

    # measure every depth
    per = {t: {} for t in TRIANGLES}
    for t in TRIANGLES:
        for d in range(0, dmax + 1):
            per[t][d] = column_roots(tris[t], d, R, args.min_coeffs)

    highlight = parse_depths(args.depths, dmax)

    # console: the reconstructed table against the expected one
    print("\n" + "=" * 78)
    print("MEAN |z| BY DEPTH  -- measured, with (expected) from the inline "
          "session")
    print("=" * 78)
    print(f"{'d':>3}  {'prime table':>22}  {'smooth control':>22}  "
          f"{'residual only':>22}")
    for d in highlight:
        cells = []
        for t in TRIANGLES:
            m = per[t].get(d)
            exp = EXPECTED_MEAN_ABS.get(d, {}).get(t)
            if m is None:
                cells.append(f"{'-':>22}")
            elif exp is None:
                cells.append(f"{m['mean_abs']:>10.4f} {'(  -   )':>11}")
            else:
                cells.append(f"{m['mean_abs']:>10.4f} ({exp:.4f} "
                             f"{m['mean_abs'] - exp:+.4f})")
        print(f"{d:>3}  " + "  ".join(cells))

    print("\n" + "=" * 78)
    print("FULL PER-DEPTH DETAIL")
    print("=" * 78)
    for t in TRIANGLES:
        print(f"\n  {TRIANGLE_LABELS[t]}")
        print(f"    {'d':>3} {'n':>4} {'mean|z|':>10} {'min|z|':>10} "
              f"{'max|z|':>10} {'spread':>9}")
        for d in range(0, dmax + 1):
            m = per[t].get(d)
            if m is None:
                continue
            flag = "  <- z=0 root (exact table zero on the diagonal)" \
                if m["has_zero_root"] else ""
            print(f"    {d:>3} {m['n_roots']:>4} {m['mean_abs']:>10.4f} "
                  f"{m['min_abs']:>10.4f} {m['max_abs']:>10.4f} "
                  f"{m['rel_spread']:>9.4f}{flag}")

    # truncation offsets -- computed, not asserted
    off = {}
    for t, depth_flag, theory, label in (
            ("smooth", args.offset_smooth_depth, r_inner, "b^(-1)"),
            ("resid", args.offset_resid_depth, r_outer, "b^(-1/2)")):
        m = per[t].get(depth_flag)
        if m is None:
            off[t] = None
            continue
        off[t] = {
            "depth": depth_flag,
            "measured_mean_abs": m["mean_abs"],
            "theoretical_radius": theory,
            "theory_label": label,
            "offset_abs": m["mean_abs"] - theory,
            "offset_frac": m["mean_abs"] / theory - 1.0,
        }
    print("\n" + "=" * 78)
    print("TRUNCATION OFFSET -- the same offset in both is the point")
    print("=" * 78)
    for t in ("smooth", "resid"):
        o = off[t]
        if o is None:
            print(f"  {TRIANGLE_LABELS[t]:>16}: not available at the "
                  f"requested depth")
            continue
        print(f"  {TRIANGLE_LABELS[t]:>16}  d={o['depth']:<3} "
              f"measured {o['measured_mean_abs']:.4f}  vs {o['theory_label']} "
              f"= {o['theoretical_radius']:.5f}  ->  "
              f"{o['offset_frac'] * 100:+.3f}%")
    if off["smooth"] and off["resid"]:
        gap = off["resid"]["offset_frac"] - off["smooth"]["offset_frac"]
        off_gap = {
            "smooth_minus_theory_frac": off["smooth"]["offset_frac"],
            "resid_minus_theory_frac": off["resid"]["offset_frac"],
            "difference_of_offsets": gap,
        }
        print(f"  difference of the two offsets: {gap * 100:+.3f} percentage "
              f"points")
        print("  (a small difference is what makes the common offset a "
              "truncation artifact rather than a real gap between the two "
              "radii; the script reports it, it does not rule on it)")
    else:
        off_gap = None

    # per-depth offset table, both triangles, every depth
    offset_by_depth = []
    for d in range(0, dmax + 1):
        row = {"d": d}
        for t, theory in (("smooth", r_inner), ("resid", r_outer),
                          ("prime", r_inner)):
            m = per[t].get(d)
            row[f"{t}_offset_frac"] = (
                None if m is None else m["mean_abs"] / theory - 1.0)
        offset_by_depth.append(row)

    # breakdown
    bd = {t: breakdown_depth(per[t], args.breakdown_tol, args.breakdown_run)
          for t in TRIANGLES}
    print("\n" + "=" * 78)
    print(f"ROOT-STRUCTURE BREAKDOWN  (rel_spread > {args.breakdown_tol} for "
          f"{args.breakdown_run} consecutive depths)")
    print("=" * 78)
    for t in TRIANGLES:
        v = bd[t]["onset"]
        if v is None:
            print(f"  {TRIANGLE_LABELS[t]:>16}: onset none up to d = {dmax}")
        else:
            print(f"  {TRIANGLE_LABELS[t]:>16}: onset d = {v} "
                  f"({R - v} coefficients remain), rel_spread "
                  f"{per[t][v]['rel_spread']:.4f}")
        w = bd[t]["last_sustained"]
        print(f"  {'':>16}  last-sustained-to-the-bottom d = {w}")

    # comparison against the recorded expectations.  The recorded numbers came
    # from base 2, r = 1..45, natural anchor.  Under any other parameters they
    # are not a reproduction target and the comparison is marked inapplicable
    # rather than printed as a spurious deviation.
    reconstruction_params = {"base": 2, "rmax": 45, "smooth_anchor": "natural"}
    applicable = (b == reconstruction_params["base"]
                  and R == reconstruction_params["rmax"]
                  and args.smooth_anchor == reconstruction_params["smooth_anchor"])
    comparison = {"applicable": applicable,
                  "reconstruction_params": reconstruction_params,
                  "mean_abs": [], "detail": []}
    max_dev = 0.0
    for d, per_t in sorted(EXPECTED_MEAN_ABS.items()):
        for t, exp in per_t.items():
            m = per[t].get(d)
            meas = None if m is None else m["mean_abs"]
            diff = (None if (exp is None or meas is None) else meas - exp)
            if diff is not None:
                max_dev = max(max_dev, abs(diff))
            comparison["mean_abs"].append(
                {"triangle": t, "d": d, "expected": exp, "measured": meas,
                 "difference": diff})

    def _cmp(key, triangle, d, field):
        exp = EXPECTED_DETAIL[key].get(field)
        m = per[triangle].get(d)
        meas = None if m is None else m.get(field)
        return {"key": key, "triangle": triangle, "d": d, "field": field,
                "expected": exp, "measured": meas,
                "difference": (None if (exp is None or meas is None)
                               else meas - exp)}

    for key, t, d in (("prime_d0", "prime", 0), ("prime_d6", "prime", 6),
                      ("prime_d20", "prime", 20), ("resid_d3", "resid", 3),
                      ("resid_d6", "resid", 6)):
        for field in ("n_roots", "min_abs", "max_abs", "rel_spread"):
            if field in EXPECTED_DETAIL[key]:
                comparison["detail"].append(_cmp(key, t, d, field))

    smooth_gaps = {d: (per["smooth"][d]["max_abs"] - per["smooth"][d]["min_abs"])
                   for d in range(0, dmax + 1) if per["smooth"].get(d)}
    comparison["smooth_minmax_gap"] = {
        "note": EXPECTED_DETAIL["smooth_minmax_gap_note"],
        "max_gap_over_depths": max(smooth_gaps.values()) if smooth_gaps else None,
        "argmax_depth": (max(smooth_gaps, key=smooth_gaps.get)
                         if smooth_gaps else None),
        "by_depth": smooth_gaps,
    }

    print("\n" + "=" * 78)
    print("RECONSTRUCTION CHECK against the inline session's numbers")
    print("=" * 78)
    if not applicable:
        print("  NOT APPLICABLE at these parameters. The recorded numbers are "
              "from base 2,")
        print("  r = 1..45, natural anchor; this run is base "
              f"{b}, r = 1..{R}, anchor {args.smooth_anchor}.")
        print("  The differences below are parameter changes, not "
              "reproduction failures.")
    print(f"  largest |measured - expected| over the mean|z| table: "
          f"{max_dev:.2e}")
    worst = max((c for c in comparison["mean_abs"]
                 if c["difference"] is not None),
                key=lambda c: abs(c["difference"]), default=None)
    if worst:
        print(f"  worst cell: {worst['triangle']} d={worst['d']}  "
              f"expected {worst['expected']:.4f}  measured "
              f"{worst['measured']:.4f}  diff {worst['difference']:+.2e}")

    # rows / csv
    rows = []
    for t in TRIANGLES:
        for d in range(0, dmax + 1):
            m = per[t].get(d)
            if m is None:
                continue
            rows.append({
                "triangle": t,
                "d": d,
                "n_roots": m["n_roots"],
                "mean_abs": m["mean_abs"],
                "min_abs": m["min_abs"],
                "max_abs": m["max_abs"],
                "rel_spread": m["rel_spread"],
                "n_coeffs": m["n_coeffs"],
                "has_zero_root": m["has_zero_root"],
            })

    ended = datetime.datetime.now(datetime.timezone.utc)

    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": ("EXPLORATORY - no prereg, no decision rule, no verdict. "
                   "Nothing here may be described as a verdict."),
        "params": {
            "code_version": _code_version(),
            "rmax": R,
            "base": b,
            "depths_highlighted": highlight,
            "depths_computed_range": [0, dmax],
            "dps": args.dps,
            "smooth_anchor": args.smooth_anchor,
            "min_coeffs": args.min_coeffs,
            "breakdown_tol": args.breakdown_tol,
            "breakdown_run": args.breakdown_run,
            "offset_smooth_depth": args.offset_smooth_depth,
            "offset_resid_depth": args.offset_resid_depth,
            "cache_path": cache_path,
            "cache_usage": cache_use,
            "riemannr_impl": riemannr_impl,
            "out": args.out,
            "out_csv": args.out_csv,
            "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "first_block_convention": FIRST_BLOCK_CONVENTION,
            "transform": ("G_d(z) = sum_r cell(r,d) z^r over r = d+1..R; "
                          "roots via numpy.roots on the REVERSED coefficient "
                          "array"),
            "radius_rule": ("radius of convergence of sum a_r z^r with "
                            "a_r ~ b^(sigma r) is b^(-sigma)"),
            "smooth_radius_theory": r_inner,
            "resid_radius_theory": r_outer,
            "annulus": {
                "inner_radius": r_inner,
                "outer_radius": r_outer,
                "region": (f"{r_inner:.8f} < |z| < {r_outer:.8f}: the "
                           "residual's transform is analytic here and the "
                           "smooth part's is not"),
                "conformal_modulus": modulus,
                "conformal_modulus_formula": "(1/2pi) log(R_out/R_in) = "
                                             "log(b)/(4 pi)",
                "session_recorded_modulus": EXPECTED_ANNULUS_MODULUS,
                "session_recorded_modulus_applicable": (b == 2),
                "modulus_minus_session_recorded":
                    (modulus - EXPECTED_ANNULUS_MODULUS) if b == 2 else None,
            },
            "jentzsch_note": (
                "Jentzsch: roots of the partial sums of any power series "
                "accumulate on its circle of convergence. The existence of a "
                "circle is therefore GENERIC and carries no information. Only "
                "the radius does, and only against the smooth control."),
            "expected_verbatim": EXPECTED_VERBATIM,
            "expected_mean_abs": EXPECTED_MEAN_ABS,
            "expected_detail": EXPECTED_DETAIL,
        },
        "summary": {
            "mean_abs_by_depth": {
                str(d): {t: (None if per[t].get(d) is None
                             else per[t][d]["mean_abs"])
                         for t in TRIANGLES}
                for d in highlight},
            "truncation_offsets": off,
            "truncation_offset_comparison": off_gap,
            "offset_by_depth": offset_by_depth,
            "breakdown_depth": bd,
            "breakdown_definition": (
                "onset = smallest d whose rel_spread exceeds breakdown_tol at "
                "d and at the next breakdown_run - 1 depths; last_sustained = "
                "smallest d that exceeds it at d and at every deeper d"),
            "breakdown_rel_spread_by_depth": {
                t: {str(d): per[t][d]["rel_spread"]
                    for d in range(0, dmax + 1) if per[t].get(d)}
                for t in TRIANGLES},
            "reconstruction_check": comparison,
            "max_abs_deviation_from_expected_mean_abs": max_dev,
        },
        "rows": rows,
    }

    if not args.no_json:
        _write_results(payload, args.out)
    if not args.no_csv:
        _write_csv(rows,
                   ["triangle", "d", "n_roots", "mean_abs", "min_abs",
                    "max_abs", "rel_spread", "n_coeffs", "has_zero_root"],
                   args.out_csv)

    print("\n  EXPLORATORY. No prereg, no decision rule, no verdict.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
