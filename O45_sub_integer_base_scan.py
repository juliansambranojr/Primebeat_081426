#!/usr/bin/env python3
"""
O45 — sub-integer base scan: is base 2 the finest sampling of the scaling
      flow, or is it special in itself?  Exact zeros of the prime difference
      table at ten bases in (1, 2), against base 2 as the reference point,
      all matched on one value ceiling.

STATUS: PREREGISTERED.
Reads with: preregs/sub_integer_base_scan_v1_20260818.md

  That prereg's filename carries no status, per CLAUDE.md section "Prereg
  file naming and status"; the sidecar preregs/sub_integer_base_scan_v1_
  20260818.sha256 is the authority on lock and the STATUS block inside the
  file is the second reading.  DO NOT RUN THIS SCRIPT while the prereg
  reads STATUS: DRAFT and no sidecar exists.  While the prereg is locked,
  this script still does NOT stamp a verdict: it reports the decision
  rule's mechanical output and the verdict line is Julian's to write.
  CLAUDE.md section "Prereg discipline": "An agent may compute the SHA and
  report the decision rule's mechanical output; it does not stamp the
  verdict."

PROVENANCE: written 2026-08-18, before the prereg was locked and before any
run.  No sub-integer prime table existed anywhere in this project when this
file was written, and none was computed to write it.

Also reads with: results/cross_base_zero_scan.json  (O44, the measurement
                     this follows from: base 2 has 4 exact zeros in 496
                     cells, base 3 has 0 in the same 496)
                 results/O44_cross_base_zero_scan_run1.log, section 1
                 lean/PairIdentity.lean  (pair_identity,
                     tableFrom_add_window, tableFrom_of_geometric,
                     coeff_eq_one_iff_base_two)
                 lean/Zeros.lean  (window_exclusive_of_prime_exponent,
                     measured_zeros)
                 papers/Euler-Factor-Chain.md  (D4, D5, H4, I1, J2)
                 CONTEXT.md section "Core quantities" (the convention)
                 REFERENCES.md section "Constants" (gamma_1)
                 O43_extended_zero_census.py, O44_cross_base_zero_scan.py
                     (house plumbing and report shape - reused, not
                      imported)

=============================================================================
THE FORK BEING TESTED
=============================================================================

O44 found base 2 is the only base with exact zeros: 4 in 496 cells at
d >= 1, against base 3's 0 in the same 496.  Bases 4-9 are extent-censored
or empty.  Two accounts:

  FINENESS.  Base 2 is the finest INTEGER sampling.  Bases 4 and 8 are
  literal sub-samplings of it (4^r = 2^(2r), 8^r = 2^(3r)), and
  Zeros.window_exclusive_of_prime_exponent proves the (20,6) window is 2^7
  with 7 prime, so no coarser integer base reaches it.  If a cancellation
  needs fine resolution, bases BELOW 2 - finer still - should produce zeros
  at comparable or higher density.

  INTRINSIC.  Base 2 is special in itself.  Sub-integer bases stay empty.

Nothing in the Lean restricts the base.  PairIdentity.pair_identity takes no
hypothesis on b at all; Chain.C1 needs only 0 < b; and
pi(b^r) - pi(b^(r-1)) is well defined for real b > 1, with cells staying
integers because pi is integer-valued.

=============================================================================
THE THREE COMPLICATIONS, AND WHAT THIS SCRIPT DOES ABOUT THEM
=============================================================================

(a) THE PAIR IDENTITY IS ONLY APPROXIMATE FOR NON-INTEGER b.

    lean/PairIdentity.lean proves the identity in two halves.
    tableFrom_add_window - linearity plus locality - is exact for ANY seed
    rows and any b.  tableFrom_of_geometric - the collapse to (b-1)^d times
    the bottom entry - needs the rung (b^(r-1), b^r] to hold exactly
    (b-1)*b^(r-1) integers.  For real b it holds floor(b^r) - floor(b^(r-1))
    instead, and the collapse fails.

    So O44's nu = |cell| / [(b-1)^(d+1) * b^(r-1-d)] is NOT reused as the
    normalisation.  This script computes two totals and reports both:

        total_geo(b,r,d)  = (b-1)^(d+1) * b^(r-1-d)        [O44's]
        total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k),
                            W(r) = floor(b^r) - floor(b^(r-1))

    total_true is EXACT for every base, integer or not, because it is
    tableFrom_add_window applied to the true rung populations; for integer b
    it equals total_geo identically.  The primary normalisation is

        nu_pair = |cell| / |total_true|          exact Fraction

    and nu_geo = |cell| / total_geo is reported ONLY so the drift is on the
    record.  The drift is not small: at b = exp(pi/(2*gamma_1)) and
    (r,d) = (199,20), total_geo is 1.16e-11 while total_true is -86804.

(b) FAIR COMPARISON IS BY VALUE RANGE, NOT BY r.

    Base 2 at r <= 32 reaches 2^32; b = 1.2489 needs r = 99 to reach the
    same value.  Every base is run to the SAME value ceiling V = 2^32, with
    r_max(b) = the largest r with b^r <= V, locked per base below.  A finer
    base has far more cells over that range (19701 at b = 1.11754 against
    496 at b = 2) - that is the fineness prediction and it is also why raw
    zero counts are not comparable.  THE COMPARABLE QUANTITY IS ZEROS PER
    CELL, and every count printed below carries its denominator.

(c) (b-1)^(d+1) BEHAVES DIFFERENTLY BELOW 2, AND THE OBVIOUS READING OF
    THAT IS WRONG.

    For b < 2, b-1 < 1, so (b-1)^(d+1) shrinks with depth instead of staying
    1 (b = 2, PairIdentity.coeff_eq_one_iff_base_two) or growing (b > 2).
    At b = 1.11754 the geometric total at the ceiling falls below 1 from
    d = 9 of a support running to d = 198.  Read naively that is O43's
    magnitude floor in reverse.

    Read naively it is also wrong, and (a) is why: total_geo is not the size
    of anything at a non-integer base.  The true total carries the floor
    jaggedness of floor(b^r), O(1) per rung, amplified by the stencil's L1
    weight 2^d.  9601 of that base's 19701 cells have total_true <= 0, which
    a positive geometric quantity cannot do.  Deep cells at a sub-integer
    base are LARGE, not small.

    The confound that IS real is coarseness at low r.  For b = 1.11754,
    floor(b^r) = 1 for r = 0..6 - the first six rungs hold no integers at
    all - so N(r) = 0 there and cell(2,1) = 0 exactly, a zero about an empty
    rung and nothing else.  Every sub-2 base has such a region, so zeros on
    the FULL support are guaranteed before the run starts.  Two locked
    parameters answer it:

      1. THE RESOLVED STRATUM.  A cell counts only if every rung its stencil
         reads is expected to hold at least one prime:
         W(r')/ln(b^(r')) >= 1 for all r' in [r-d, r].  Thickness is
         monotone in r, so this is r - d >= r_thick(b), with r_thick locked
         per base.  Pure geometry - no prime is counted to evaluate it.
         At b = 2 the whole support satisfies it
         (min_r 2^(r-1)/(r ln 2) = 1.4426950408889634), so base 2 loses
         nothing and keeps all four zeros.

      2. THE MASS FLOOR.  S(r,d) = sum_k C(d,k)*N(r-k), the unsigned prime
         mass the alternating sum cancels.  |cell(r,d)| <= S(r,d) EXACTLY -
         a hard bound, not a model - so a cell with S < 1 has its zero
         forced.  Base 2's four zeros carry S = 2, 4, 88, 492384, and
         mass_floor = 88 is S at (8,3).  The `thin_rung_forced` branch is
         keyed on it.

(d) A THIRD OUTCOME EXISTS.  Zeros might appear only at the optimal-base
    family exp(pi*k/(2*gamma_1)) and not at arbitrary sub-2 bases.  That is
    neither fineness nor intrinsic, so the base list carries NON-FAMILY
    CONTROLS in the same range - four antiphase bases exp(pi(2k+1)/(4*g1)),
    a half quarter-turn off the family, and two dyadic refinements
    2^(1/2), 2^(1/3) of which base 2 is a literal sub-sampling - and the
    decision rule carries `family_only` and `refinement_only`.

=============================================================================
THE CONVENTION IN FORCE
=============================================================================

THIS PROJECT'S convention, not the imported one:

    2 and 3 are COUNTED AS PRIMES; pi(1) = 0;
    N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))) on the half-open rung
    (b^(r-1), b^r], with floor(b^0) = 1.

CONTEXT.md section "Core quantities": "N(r) = pi(2^r) - pi(2^(r-1)) -
primes in the dyadic interval (2^(r-1), 2^r]".  This is explicitly NOT the
imported lattice_mapper convention (2 and 3 excluded as lattice), which
CONTEXT.md section "imported/lattice_mapper/" records as not comparable at
low r with anything in results/.  O44 measured under the imported
convention; this script does not.  The convention is printed below and
stored at constants.convention in the results JSON.

=============================================================================
WHAT IS MEASURED, IN THE ORDER IT IS REPORTED
=============================================================================

  1  PI BACKEND INTEGRITY.  pi(2^n) for n = 0..32 against all 33
     corresponding entries of pi2n_cache.json, exact integer equality.  Any
     mismatch trips `compromised` and the run stops before any table is
     built.

  2  GEOMETRY INTEGRITY.  r_max, cells at d >= 1, r_thick and resolved-cell
     count recomputed per base and compared to the locked table; plus the
     minimum relative distance of b^r to an integer.  The support is a
     locked parameter and does not get to move.

  3  BASE-2 REPRODUCTION.  Base 2 through the identical code path at the
     same value ceiling.  Its exact zeros at d >= 1, r <= 32 must be exactly
     {(2,1),(4,1),(8,3),(20,6)} in 496 cells.  Failure trips `compromised`.
     This is a REPRODUCTION CHECK, NOT EVIDENCE (prereg, provenance 1).

  4  THE SUB-INTEGER SCAN.  Per base: value ceiling, r_max, cells at
     d >= 1, resolved cells, every exact zero with coordinates, zeros per
     cell and per resolved cell, min nu_pair and where, and the --top-k
     smallest nu_pair.

  5  THE RATE TEST.  Z, E[Z] under H0, the exact conditional-binomial p,
     the Poisson p (secondary, cannot move the verdict), and the
     family / antiphase / refinement split.

  6  THE MASS PROFILE.  S at every zero found, and the count of resolved
     sub-2 zeros clearing mass_floor.

  Then the MECHANICAL DECISION-RULE OUTPUT, which is not a verdict.

=============================================================================
ARITHMETIC
=============================================================================

EXACT PYTHON INTEGERS THROUGHOUT for every cell, every W, every total_true
and every stencil mass S; exact fractions.Fraction for every nu used in a
ranking or a sort.  numpy is deliberately NOT imported.  mpmath appears only
to obtain floor(b^r) at the eight transcendental bases, at dps 60; the two
dyadic refinement bases use EXACT INTEGER m-th roots of 2^r and no floating
point at all, which is why r_max(2^(1/2)) is 64 and not 63.  Floats appear
in ln, in total_geo, in nu_geo, in printed values and in the two p-values -
never in a ranking and never in a zero test.

No randomness anywhere: no Monte Carlo, no resampling, no --seed flag and
nothing to seed.  REFERENCES.md section Constants records seed 2026 for
tests that need one; this is not one.

=============================================================================
OUTPUTS
=============================================================================

results/sub_integer_base_scan.json   house envelope, schema_version "1":
                                     script, generated_utc, params,
                                     constants, summary, rows.
                                     params.code_version is the sha256 of
                                     THIS file read at run time - CONTEXT.md
                                     records the known weakness that this is
                                     a write-time not an import-time read.
                                     params.source_files records every file
                                     opened, with sha256, bytes and mtime,
                                     as O33 and O44 do, and includes the
                                     prereg itself.

Console output is the human-readable summary; tee it to
results/O45_sub_integer_base_scan_run1.log.

Every path is anchored to _HERE, so runs are cwd-independent.  Nothing is
written outside results/.  pi2n_cache.json is read and NOT written.

HOW IT WILL BE RUN (do not run while the prereg says DRAFT)
-----------------------------------------------------------
    .venv/bin/python O45_sub_integer_base_scan.py \
        --cache pi2n_cache.json \
        --prereg preregs/sub_integer_base_scan_v1_20260818.md \
        --top-k 10 \
        --out results/sub_integer_base_scan.json \
        2>&1 | tee results/O45_sub_integer_base_scan_run1.log

Every flag is passed explicitly.  --cache, --prereg and --out are resolved
against _HERE when relative, so the line above is cwd-independent too.

REQUIREMENTS: standard library, plus primecountpy (primary pi backend, with
sympy as the stated fallback) and mpmath.
"""

import argparse
import datetime
import hashlib
import json
import math
import os
import sys
from fractions import Fraction

from mpmath import mp, mpf, floor as mpfloor, log as mplog, exp as mpexp, pi as MPPI

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "sub_integer_base_scan.json")
DEFAULT_CACHE = os.path.join(_HERE, "pi2n_cache.json")
DEFAULT_PREREG = os.path.join(
    _HERE, "preregs", "sub_integer_base_scan_v1_20260818.md")

RULE = "=" * 78
THIN = "-" * 78


# ---------------------------------------------------------------------------
# LOCKED, NOT FLAGS
#
# Every constant in this block is a locked parameter of
# preregs/sub_integer_base_scan_v1_20260818.md.  None of them is exposed as
# a flag; changing one after lock is a protocol violation, not a re-run.
# ---------------------------------------------------------------------------

PREREG_PATH_REL = "preregs/sub_integer_base_scan_v1_20260818.md"

VERDICT_LABELS = ("thin_rung_forced", "family_only", "refinement_only",
                  "fineness", "rate_below_base_two", "intrinsic_base_two",
                  "ambiguous", "compromised")
PRECEDENCE = ("compromised > thin_rung_forced > family_only > "
              "refinement_only > fineness > rate_below_base_two > "
              "intrinsic_base_two > ambiguous")

# REFERENCES.md section Constants: "gamma_1  14.134725141734693".  The base
# list is DEFINED by this decimal, not by the true zero, so the bases are
# exactly reproducible.
GAMMA1_STR = "14.134725141734693"

# Base 2's extent in results/cross_base_zero_scan.json ->
# summary.per_base[0].max_regime = 32.  Bases are matched on the value they
# reach, not on r.
VALUE_CEILING_EXP = 32
VALUE_CEILING = 1 << VALUE_CEILING_EXP        # 4294967296

DPS = 60                       # mpmath precision for floor(b^r)
D_MIN = 1                      # zeros counted at d >= 1
MASS_FLOOR = 88                # S(8,3) at base 2, from pi2n_cache.json
ALPHA_LEVEL = 0.05             # one-sided; house level
FLOOR_DETERMINACY = 1e-30      # relative; see the prereg's parameter table
PI_AUDIT_MAX_N = 32            # pi(2^n) for n = 0..32 against the cache

# The convention, stated and IN FORCE (unlike O44, which stated the imported
# one and did not adjust for it).
CONVENTION = (
    "THIS PROJECT'S convention: 2 and 3 are COUNTED AS PRIMES, pi(1) = 0, "
    "N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))) on the half-open rung "
    "(b^(r-1), b^r], with floor(b^0) = 1. "
    "Source: CONTEXT.md section 'Core quantities'. "
    "This is explicitly NOT the imported lattice_mapper convention (2 and 3 "
    "excluded as lattice) that O44 measured under; CONTEXT.md section "
    "'imported/lattice_mapper/' records that the two are not comparable at "
    "low r."
)

# The base list.  kind is one of:
#   ("int",   None)  exact integer base
#   ("fam",   k)     exp(pi*k/(2*gamma_1))            theta = k * 90 deg
#   ("anti",  k)     exp(pi*(2k+1)/(4*gamma_1))       theta = (2k+1) * 45 deg
#   ("root",  m)     2^(1/m), exact integer m-th roots of 2^r
# r_max, cells, r_thick and resolved are LOCKED and are re-derived at run
# time; any disagreement trips `compromised`.
LOCKED_BASES = (
    # arm          label        kind          r_max cells r_thick resolved
    ("reference",  "2",          ("int", None),   32,   496,  1,     496),
    ("family",     "exp(pi*1/(2*g1))", ("fam", 1), 199, 19701, 32,  14028),
    ("family",     "exp(pi*2/(2*g1))", ("fam", 2),  99,  4851, 12,   3828),
    ("family",     "exp(pi*3/(2*g1))", ("fam", 3),  66,  2145,  7,   1770),
    ("family",     "exp(pi*4/(2*g1))", ("fam", 4),  49,  1176,  4,   1035),
    ("antiphase",  "exp(pi*3/(4*g1))", ("anti", 1), 133,  8778, 20,   6441),
    ("antiphase",  "exp(pi*5/(4*g1))", ("anti", 2),  79,  3081,  8,   2556),
    ("antiphase",  "exp(pi*7/(4*g1))", ("anti", 3),  57,  1596,  5,   1378),
    ("antiphase",  "exp(pi*9/(4*g1))", ("anti", 4),  44,   946,  3,    861),
    ("refinement", "2**(1/2)",         ("root", 2),  64,  2016,  6,   1711),
    ("refinement", "2**(1/3)",         ("root", 3),  96,  4560, 12,   3570),
)

# Locked aggregates, from the prereg's section "H0 expected count".
C_2_LOCKED = 496
C_SUB_LOCKED = 37178
C_FAMILY_LOCKED = 20661
C_ANTIPHASE_LOCKED = 11236
C_REFINEMENT_LOCKED = 5281
Z_2_LOCKED = 4
E_Z_H0_LOCKED = 4.0 * 37178 / 496          # 299.822580645161

# results/O16_run2.log section EXACT ZEROS; lean/Zeros.lean measured_zeros;
# lean/PairIdentity.lean zero_cells.  Reproduction target, NOT evidence.
KNOWN_ZEROS_B2 = ((2, 1), (4, 1), (8, 3), (20, 6))

# Prime stencil mass S(r,d) = sum_k C(d,k) N(r-k) at those four cells,
# computed while drafting the prereg from pi2n_cache.json.  Disclosed in the
# prereg's provenance item 2; mass_floor = 88 is S(8,3).
KNOWN_MASS_B2 = {(2, 1): 2, (4, 1): 4, (8, 3): 88, (20, 6): 492384}


# ---------------------------------------------------------------------------
# house plumbing (O33's / O43's / O44's, unchanged)
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


def file_record(path, extra=None):
    """sha256 + size + mtime of an input file, O33's params.source_files
    shape.  Opened read-only; nothing is written."""
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


def _resolve(path):
    """Resolve a possibly-relative path against _HERE, so runs are
    cwd-independent."""
    return path if os.path.isabs(path) else os.path.join(_HERE, path)


# ---------------------------------------------------------------------------
# pi backend
# ---------------------------------------------------------------------------

def load_pi_backend():
    """primecountpy.prime_pi primary, sympy.primepi fallback.  REFERENCES.md
    section Packages.  Both are EXACT; nothing approximate is admissible
    anywhere in this test.  Returns (callable, name, version)."""
    try:
        from primecountpy import prime_pi as _pp
        try:
            import importlib.metadata as _md
            ver = _md.version("primecountpy")
        except Exception:                                     # pragma: no cover
            ver = "unknown"
        return (lambda x: int(_pp(int(x))) if x >= 2 else 0,
                "primecountpy.prime_pi", ver)
    except Exception as exc_primary:
        try:
            from sympy import primepi as _sp
            try:
                import importlib.metadata as _md
                ver = _md.version("sympy")
            except Exception:                                 # pragma: no cover
                ver = "unknown"
            return (lambda x: int(_sp(int(x))) if x >= 2 else 0,
                    "sympy.primepi", ver)
        except Exception as exc_fallback:                     # pragma: no cover
            raise RuntimeError(
                "no exact pi backend available: primecountpy failed with "
                f"{exc_primary!r}; sympy failed with {exc_fallback!r}")


# ---------------------------------------------------------------------------
# the bases: exact floors, no floating point where it would matter
# ---------------------------------------------------------------------------

def iroot(n, k):
    """Exact floor of the integer k-th root of n, by integer Newton.  Used
    for the dyadic refinement bases: floor((2^(1/m))^r) = floor(2^(r/m)) is
    an EXACT integer question and a floating-point floor lands on the wrong
    side whenever m divides r."""
    if k == 1:
        return n
    if n < 1:
        return 0
    x = 1 << ((n.bit_length() + k - 1) // k + 1)
    while True:
        y = ((k - 1) * x + n // x ** (k - 1)) // k
        if y >= x:
            break
        x = y
    while (x + 1) ** k <= n:
        x += 1
    while x ** k > n:
        x -= 1
    return x


def base_value(kind, gamma1):
    """The base as an mpmath mpf at dps DPS.  Transcendental bases are
    DEFINED by the locked gamma_1 decimal, not by the true zero."""
    tag, param = kind
    if tag == "int":
        return mpf(2)
    if tag == "fam":
        return mpexp(MPPI * param / (2 * gamma1))
    if tag == "anti":
        return mpexp(MPPI * (2 * param + 1) / (4 * gamma1))
    if tag == "root":
        return mpf(2) ** (mpf(1) / param)
    raise ValueError(f"unknown base kind {kind!r}")


def base_geometry(kind, gamma1):
    """Return (b, r_max, F, min_rel_gap, root_selfcheck_fail).

    F[r] = floor(b^r), exact.  r_max is the largest r with b^r <= V.
    min_rel_gap is the smallest relative distance of any b^r, r = 1..r_max,
    to an integer - reported for the transcendental bases and used for the
    determinacy check; None for the exact ones, where an exact integer is
    the point rather than a hazard."""
    tag, param = kind
    b = base_value(kind, gamma1)
    if tag == "int":
        r_max = VALUE_CEILING_EXP
        F = [1 << r for r in range(r_max + 1)]
        return b, r_max, F, None, 0
    if tag == "root":
        # b^r <= 2^32  <=>  2^(r/m) <= 2^32  <=>  r <= 32*m, exactly.
        m = param
        r_max = VALUE_CEILING_EXP * m
        F = [iroot(1 << r, m) for r in range(r_max + 1)]
        bad = sum(1 for r in range(r_max + 1)
                  if not (F[r] ** m <= (1 << r) < (F[r] + 1) ** m))
        return b, r_max, F, None, bad
    # transcendental
    r_max = int(mpfloor(mpf(VALUE_CEILING_EXP) * mplog(2) / mplog(b)))
    while b ** (r_max + 1) <= VALUE_CEILING:
        r_max += 1
    while b ** r_max > VALUE_CEILING:
        r_max -= 1
    F = [int(mpfloor(b ** r)) for r in range(r_max + 1)]
    gap = None
    for r in range(1, r_max + 1):
        x = b ** r
        g = float(abs(x - mp.nint(x)) / x)
        gap = g if gap is None else min(gap, g)
    return b, r_max, F, gap, 0


def rung_populations(F, r_max):
    """W(r) = floor(b^r) - floor(b^(r-1)), the number of integers the rung
    (b^(r-1), b^r] holds.  Exact.  W[0] is unused."""
    return [0] + [F[r] - F[r - 1] for r in range(1, r_max + 1)]


def r_thick_of(W, b, r_max):
    """Smallest R such that every rung r >= R is expected to hold at least
    one prime: W(r)/ln(b^r) >= 1.  Thickness is monotone in r at every base
    in the locked list, so the resolved criterion
    'W(r')/ln(b^(r')) >= 1 for all r' in [r-d, r]' is exactly r - d >= R.
    Pure geometry: no prime is counted here."""
    lnb = float(mplog(b))
    rt = r_max + 1
    for r in range(r_max, 0, -1):
        if W[r] / (lnb * r) >= 1.0:
            rt = r
        else:
            break
    return rt


# ---------------------------------------------------------------------------
# the tables
# ---------------------------------------------------------------------------

def build_tables(N, W, r_max):
    """Backward-difference tables for the prime arm and for the true total.

        P(r,0) = N(r),      P(r,d) = P(r,d-1) - P(r-1,d-1)
        Q(r,0) = W(r),      Q(r,d) = Q(r,d-1) - Q(r-1,d-1)

    Q is total_true: tableFrom_add_window (lean/PairIdentity.lean) applied
    to the true rung populations, exact for every base.  Support d = 0..r-1.
    Exact Python integers throughout.  Returned as dicts keyed (r,d)."""
    P = {}
    Q = {}
    for r in range(1, r_max + 1):
        P[(r, 0)] = N[r]
        Q[(r, 0)] = W[r]
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            P[(r, d)] = P[(r, d - 1)] - P[(r - 1, d - 1)]
            Q[(r, d)] = Q[(r, d - 1)] - Q[(r - 1, d - 1)]
    return P, Q


def stencil_mass(N, r, d):
    """S(r,d) = sum_k C(d,k) N(r-k), the UNSIGNED prime mass the alternating
    sum cancels.  |P(r,d)| <= S(r,d) exactly - a hard bound, not a model -
    which is what makes mass_floor a bound rather than a heuristic."""
    return sum(math.comb(d, k) * N[r - k] for k in range(d + 1))


def total_geo(b, r, d, exact_int):
    """(b-1)^(d+1) * b^(r-1-d), O44's denominator.  Exact integer at an
    integer base; an mpmath value otherwise, converted to float for output.
    REPORTED ONLY, so the drift documented in (a) is on the record; nothing
    keys on it."""
    e = r - 1 - d
    if e < 0:
        raise ValueError(f"cell (r={r}, d={d}) is off support: r-1-d = {e}")
    if exact_int:
        ib = int(b)
        return (ib - 1) ** (d + 1) * ib ** e
    return (b - 1) ** (d + 1) * b ** e


# ---------------------------------------------------------------------------
# the two p-values
# ---------------------------------------------------------------------------

def p_conditional_binomial(Z, Z2, C2, Csub):
    """Exact conditional binomial.  Conditional on T = Z2 + Z over the
    combined C2 + Csub resolved cells, Z | T ~ Binomial(T, Csub/(C2+Csub)).
    One-sided p for a sub-2 deficit: p = P(K <= Z | T).  q drops out - no
    nuisance parameter is estimated and then reused.

    Computed as an exact Fraction while T <= 512 (which covers the whole
    range the prereg tabulates and well past H0's point prediction of
    299.8), and in log space above, where the exact form would need
    thousand-digit binomials for no gain."""
    T = Z2 + Z
    if T <= 0:
        return 1.0, "exact"
    if T <= 512:
        tot = C2 + Csub
        acc = Fraction(0)
        for k in range(0, Z + 1):
            acc += (Fraction(math.comb(T, k))
                    * Fraction(Csub) ** k * Fraction(C2) ** (T - k)
                    / Fraction(tot) ** T)
        return float(acc), "exact"
    q = C2 / (C2 + Csub)
    lq, l1q = math.log(q), math.log1p(-q)
    acc = 0.0
    for k in range(0, Z + 1):
        lt = (math.lgamma(T + 1) - math.lgamma(k + 1) - math.lgamma(T - k + 1)
              + k * l1q + (T - k) * lq)
        acc += math.exp(lt)
    return min(acc, 1.0), "log-space"


def p_poisson(Z, lam):
    """p_pois = P(K <= Z), K ~ Poisson(lam).  SECONDARY: reported always,
    CANNOT change the verdict.  It treats base 2's rate as known without
    error, which it is not - the whole rate estimate rests on four events."""
    lt = -lam
    acc = math.exp(lt)
    for k in range(1, Z + 1):
        lt += math.log(lam) - math.log(k)
        acc += math.exp(lt)
    return min(acc, 1.0)


# ---------------------------------------------------------------------------
# per-base scan
# ---------------------------------------------------------------------------

def scan_base(arm, label, kind, gamma1, pi_fn, pi_cache, top_k):
    """One base, end to end.  Returns a summary dict.  No decision is taken
    here and no threshold is applied that the prereg does not lock."""
    exact_int = (kind[0] == "int")
    b, r_max, F, min_gap, root_bad = base_geometry(kind, gamma1)
    W = rung_populations(F, r_max)
    r_thick = r_thick_of(W, b, r_max)

    # N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))), pi(1) = 0.
    def PI(x):
        if x < 2:
            return 0
        if x not in pi_cache:
            pi_cache[x] = pi_fn(x)
        return pi_cache[x]

    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    P, Q = build_tables(N, W, r_max)

    lnb = float(mplog(b))
    cells = 0
    resolved_cells = 0
    zeros = []
    resolved_zeros = []
    q_zero_cells = 0
    q_neg_cells = 0
    ranked = []          # (Fraction nu_pair, r, d) over cells with Q != 0

    for r in range(2, r_max + 1):
        for d in range(D_MIN, r):
            cells += 1
            is_res = (r - d) >= r_thick
            if is_res:
                resolved_cells += 1
            cell = P[(r, d)]
            qq = Q[(r, d)]
            if qq == 0:
                q_zero_cells += 1
            elif qq < 0:
                q_neg_cells += 1
                ranked.append((Fraction(abs(cell), abs(qq)), r, d))
            else:
                ranked.append((Fraction(abs(cell), abs(qq)), r, d))
            if cell == 0:
                rec = {"r": r, "d": d, "r_minus_d": r - d,
                       "resolved": is_res,
                       "total_true": qq,
                       "S": stencil_mass(N, r, d)}
                rec["clears_mass_floor"] = rec["S"] >= MASS_FLOOR
                try:
                    tg = total_geo(b, r, d, exact_int)
                    rec["total_geo"] = int(tg) if exact_int else float(tg)
                except Exception:                             # pragma: no cover
                    rec["total_geo"] = None
                zeros.append(rec)
                if is_res:
                    resolved_zeros.append(rec)

    ranked.sort(key=lambda t: (t[0], t[1], t[2]))
    smallest = []
    for rank, (nu, r, d) in enumerate(ranked[:top_k], start=1):
        cell = P[(r, d)]
        qq = Q[(r, d)]
        S = stencil_mass(N, r, d)
        try:
            tg = total_geo(b, r, d, exact_int)
            tgf = int(tg) if exact_int else float(tg)
            nug = (abs(cell) / float(tg)) if float(tg) != 0.0 else None
        except Exception:                                     # pragma: no cover
            tgf, nug = None, None
        smallest.append({
            "rank": rank, "r": r, "d": d, "r_minus_d": r - d,
            "resolved": (r - d) >= r_thick,
            "cell": cell, "abs_cell": abs(cell),
            "total_true": qq, "total_geo": tgf,
            "S": S,
            "nu_pair": float(nu),
            "nu_geo": nug,
            "nu_mass": (float(Fraction(abs(cell), S)) if S else None),
            "s_true": (math.log(abs(qq)) if qq else None),
        })

    min_nu = ranked[0] if ranked else None
    n_res_zeros = len(resolved_zeros)
    return {
        "arm": arm,
        "label": label,
        "kind": f"{kind[0]}:{kind[1]}",
        "b": float(b),
        "b_str": mp.nstr(b, 22),
        "theta_deg": (float(gamma1 * mplog(b)) * 180.0 / math.pi) % 360.0,
        "value_ceiling": VALUE_CEILING,
        "r_max": r_max,
        "n_cells_at_d_ge_1": cells,
        "r_thick": r_thick,
        "n_resolved_cells": resolved_cells,
        "min_rel_gap_to_integer": min_gap,
        "root_selfcheck_failures": root_bad,
        "n_total_true_zero_cells": q_zero_cells,
        "n_total_true_negative_cells": q_neg_cells,
        "n_exact_zeros_all": len(zeros),
        "n_exact_zeros_resolved": n_res_zeros,
        "n_resolved_zeros_clearing_mass_floor":
            sum(1 for z in resolved_zeros if z["clears_mass_floor"]),
        "zeros_per_cell": (len(zeros) / cells) if cells else None,
        "zeros_per_resolved_cell":
            (n_res_zeros / resolved_cells) if resolved_cells else None,
        "exact_zeros": zeros,
        "min_nu_pair": (float(min_nu[0]) if min_nu else None),
        "min_nu_pair_at": ({"r": min_nu[1], "d": min_nu[2]}
                           if min_nu else None),
        "top_k": top_k,
        "smallest_nu_pair": smallest,
        "W_at_r_thick": W[r_thick] if r_thick <= r_max else None,
        "W_at_r_max": W[r_max],
        "n_pi_calls_this_base": r_max + 1,
    }


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="O45 - sub-integer base scan (preregistered; this script "
                    "reports the decision rule's mechanical output and does "
                    "NOT stamp a verdict)")
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE,
                    help="pi(2^n) cache, read-only, for the pi backend audit "
                         "(default: pi2n_cache.json at the project root)")
    ap.add_argument("--prereg", type=str, default=DEFAULT_PREREG,
                    help="prereg path, recorded with its sha256 in the "
                         "results JSON")
    ap.add_argument("--top-k", type=int, default=10,
                    help="how many smallest nu_pair to report per base "
                         "(locked at 10; diagnostic only)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true", default=False,
                    help="skip the results JSON (console output only)")
    args = ap.parse_args()

    mp.dps = DPS
    gamma1 = mpf(GAMMA1_STR)
    started = datetime.datetime.now(datetime.timezone.utc)
    cache_path = _resolve(args.cache)
    prereg_path = _resolve(args.prereg)
    out_path = _resolve(args.out)
    compromised = []
    source_files = []

    print(RULE, flush=True)
    print("O45 - SUB-INTEGER BASE SCAN   (PREREGISTERED)", flush=True)
    print(RULE, flush=True)
    print(f"  started (UTC)          : {started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  prereg                 : {PREREG_PATH_REL}")
    print(f"  value ceiling V        : 2^{VALUE_CEILING_EXP} = {VALUE_CEILING}")
    print(f"  gamma_1 (locked)       : {GAMMA1_STR}")
    print(f"  mpmath dps             : {DPS}")
    print(f"  d-min                  : {D_MIN}")
    print(f"  mass_floor             : {MASS_FLOOR}   (S at base 2's (8,3))")
    print(f"  alpha_level            : {ALPHA_LEVEL}  one-sided")
    print(f"  top-k                  : {args.top_k}")
    print(f"  cache (READ ONLY)      : {cache_path}")
    print(f"  out                    : {out_path}")
    print(f"  python                 : {sys.version.split()[0]}")
    print(f"  code_version (sha256)  : {_code_version()}", flush=True)
    print()
    print("  Nothing printed here is a verdict.  This script reports the")
    print("  decision rule's mechanical output; the verdict line is Julian's")
    print("  to write.  CLAUDE.md, section 'Prereg discipline'.", flush=True)

    print("\n" + THIN)
    print("CONVENTION IN FORCE")
    print(THIN)
    for line in (CONVENTION[i:i + 74] for i in range(0, len(CONVENTION), 74)):
        print("  " + line)
    print(flush=True)

    # ---------------- Check 1: pi backend integrity --------------------------
    print(RULE)
    print("1. PI BACKEND INTEGRITY   (reported first; stops the run on failure)")
    print(RULE, flush=True)
    try:
        pi_fn, pi_name, pi_ver = load_pi_backend()
        print(f"  backend               : {pi_name}  {pi_ver}")
    except Exception as exc:
        pi_fn, pi_name, pi_ver = None, "unavailable", "-"
        compromised.append(f"pi_backend_unavailable: {exc}")
        print(f"  backend               : UNAVAILABLE  ({exc})")

    audit = []
    if pi_fn is not None:
        try:
            with open(cache_path, "r") as fh:
                pi2 = json.load(fh)
            source_files.append(file_record(cache_path, {"role": "pi_audit"}))
            for n in range(0, PI_AUDIT_MAX_N + 1):
                key = str(n)
                if key not in pi2:
                    compromised.append(f"cache missing pi(2^{n})")
                    continue
                want = int(pi2[key])
                got = pi_fn(1 << n)
                audit.append({"n": n, "cache": want, "backend": got,
                              "equal": want == got})
                if want != got:
                    compromised.append(
                        f"pi audit: pi(2^{n}) backend {got} != cache {want}")
                if got < 0:
                    compromised.append(f"pi(2^{n}) negative: {got}")
            for a, c in zip(audit, audit[1:]):
                if c["backend"] < a["backend"]:
                    compromised.append(
                        f"pi(2^n) not non-decreasing at n={c['n']}")
        except Exception as exc:
            compromised.append(f"cache_read_failed: {exc}")
        n_ok = sum(1 for a in audit if a["equal"])
        print(f"  comparisons           : {n_ok} of {len(audit)} equal "
              f"(need {PI_AUDIT_MAX_N + 1} of {PI_AUDIT_MAX_N + 1})")
        if audit:
            print(f"  pi(2^32)              : backend {audit[-1]['backend']}  "
                  f"cache {audit[-1]['cache']}")
        print(f"  status                : "
              f"{'FAIL' if compromised else 'PASS'}", flush=True)

    if os.path.exists(prereg_path):
        source_files.append(file_record(prereg_path, {"role": "prereg"}))
    else:
        print(f"\n  WARNING: prereg not found at {prereg_path}; its sha256 "
              f"cannot be recorded.", flush=True)

    if compromised:
        print("\n" + RULE)
        print("MECHANICAL DECISION-RULE OUTPUT (NOT A VERDICT)")
        print(RULE)
        for c in compromised:
            print(f"  tripped: {c}")
        print("\n  Every condition above is a `compromised` trip.  Under the")
        print("  decision rule the mechanical output is `compromised` and")
        print("  there is no verdict.  No count is reported as a number.")
        print(f"  precedence: {PRECEDENCE}", flush=True)
        if not args.no_json:
            _write_results({
                "schema_version": "1",
                "script": os.path.basename(__file__),
                "script_path": os.path.abspath(__file__),
                "generated_utc": datetime.datetime.now(
                    datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "params": {"code_version": _code_version(), "argv": sys.argv,
                           "prereg": PREREG_PATH_REL,
                           "status": "preregistered",
                           "source_files": source_files,
                           "python": sys.version},
                "constants": {"convention": CONVENTION,
                              "verdict_labels": list(VERDICT_LABELS),
                              "precedence": PRECEDENCE},
                "summary": {"pi_audit": audit,
                            "compromised_conditions": compromised,
                            "mechanical_decision_rule_output": "compromised",
                            "verdict": None},
                "rows": [],
            }, out_path)
        return 1

    # ---------------- Checks 2-4: the scan -----------------------------------
    print("\n" + RULE)
    print("2. GEOMETRY INTEGRITY   (the support is a locked parameter)")
    print(RULE, flush=True)
    print(f"  {'arm':<11}{'label':<20}{'r_max':>6}{'cells':>8}{'r_thick':>8}"
          f"{'resolved':>10}   locked?  {'min rel gap':>12}")

    pi_cache = {}
    per_base = []
    for arm, label, kind, r_max_L, cells_L, rthick_L, res_L in LOCKED_BASES:
        s = scan_base(arm, label, kind, gamma1, pi_fn, pi_cache, args.top_k)
        agree = (s["r_max"] == r_max_L and s["n_cells_at_d_ge_1"] == cells_L
                 and s["r_thick"] == rthick_L
                 and s["n_resolved_cells"] == res_L)
        s["locked_r_max"] = r_max_L
        s["locked_cells"] = cells_L
        s["locked_r_thick"] = rthick_L
        s["locked_resolved_cells"] = res_L
        s["geometry_matches_locked"] = agree
        if not agree:
            compromised.append(
                f"geometry drift at base {label}: got "
                f"(r_max={s['r_max']}, cells={s['n_cells_at_d_ge_1']}, "
                f"r_thick={s['r_thick']}, resolved={s['n_resolved_cells']}) "
                f"vs locked ({r_max_L}, {cells_L}, {rthick_L}, {res_L})")
        g = s["min_rel_gap_to_integer"]
        if g is not None and g < FLOOR_DETERMINACY:
            compromised.append(
                f"floor determinacy at base {label}: min relative distance "
                f"to an integer {g:.3e} < {FLOOR_DETERMINACY:.0e}")
        if s["root_selfcheck_failures"]:
            compromised.append(
                f"exact-root self-check failed at base {label}: "
                f"{s['root_selfcheck_failures']} of {s['r_max'] + 1} values")
        gs = "-" if g is None else f"{g:.3e}"
        print(f"  {arm:<11}{label:<20}{s['r_max']:>6}"
              f"{s['n_cells_at_d_ge_1']:>8}{s['r_thick']:>8}"
              f"{s['n_resolved_cells']:>10}   "
              f"{'yes' if agree else 'NO':<8}{gs:>12}", flush=True)
        per_base.append(s)

    b2 = per_base[0]
    subs = per_base[1:]

    print("\n" + RULE)
    print("3. BASE-2 REPRODUCTION   (a reproduction check, NOT evidence)")
    print(RULE, flush=True)
    got = tuple(sorted((z["r"], z["d"]) for z in b2["exact_zeros"]))
    want = tuple(sorted(KNOWN_ZEROS_B2))
    print(f"  known (prereg / O16)  : {[list(t) for t in want]}")
    print(f"  rebuilt here          : {[list(t) for t in got]}")
    print(f"  cells at d >= 1       : {b2['n_cells_at_d_ge_1']} "
          f"(locked {C_2_LOCKED})")
    if got != want:
        compromised.append(
            f"base-2 reproduction: rebuilt zeros {list(got)} != known "
            f"{list(want)}")
    for z in b2["exact_zeros"]:
        k = (z["r"], z["d"])
        if k in KNOWN_MASS_B2 and z["S"] != KNOWN_MASS_B2[k]:
            compromised.append(
                f"base-2 stencil mass at {k}: got {z['S']}, prereg records "
                f"{KNOWN_MASS_B2[k]}")
    print(f"  stencil mass S        : "
          f"{ {(z['r'], z['d']): z['S'] for z in b2['exact_zeros']} }")
    print(f"  status                : {'FAIL' if got != want else 'PASS'}")
    print("  These four cells are among the most inspected objects in this")
    print("  tree (prereg, provenance 1).  Reproducing them confirms the code")
    print("  path; it is not evidence about the hypothesis.", flush=True)

    print("\n" + RULE)
    print("4. THE SUB-INTEGER SCAN")
    print(RULE, flush=True)
    print(f"  {'arm':<11}{'label':<20}{'b':>16}{'theta':>9}{'r_max':>6}"
          f"{'cells':>8}{'resolv':>8}{'zeros':>7}{'z/res':>7}{'z_res':>7}"
          f"{'z*':>5}")
    for s in per_base:
        print(f"  {s['arm']:<11}{s['label']:<20}{s['b']:>16.10f}"
              f"{s['theta_deg']:>9.2f}{s['r_max']:>6}"
              f"{s['n_cells_at_d_ge_1']:>8}{s['n_resolved_cells']:>8}"
              f"{s['n_exact_zeros_all']:>7}"
              f"{(s['zeros_per_resolved_cell'] or 0.0):>7.4f}"
              f"{s['n_exact_zeros_resolved']:>7}"
              f"{s['n_resolved_zeros_clearing_mass_floor']:>5}", flush=True)
    print("\n  zeros   = exact zeros at d >= 1 over the WHOLE support")
    print("  z_res   = exact zeros in the RESOLVED stratum (r - d >= r_thick)")
    print("  z*      = resolved zeros with stencil mass S >= "
          f"{MASS_FLOOR}")
    print("  z/res   = z_res / resolved cells.  Raw counts are not comparable")
    print("            across bases; zeros per cell is.", flush=True)

    for s in per_base:
        print("\n" + THIN)
        print(f"  base {s['label']}  b = {s['b_str']}  "
              f"theta = {s['theta_deg']:.3f} deg  ({s['arm']})")
        print(THIN)
        print(f"    value ceiling            : 2^{VALUE_CEILING_EXP} = "
              f"{VALUE_CEILING}")
        print(f"    r_max                    : {s['r_max']}")
        print(f"    cells at d >= 1          : {s['n_cells_at_d_ge_1']}")
        print(f"    r_thick / resolved cells : {s['r_thick']} / "
              f"{s['n_resolved_cells']}")
        print(f"    W(r_thick) / W(r_max)    : {s['W_at_r_thick']} / "
              f"{s['W_at_r_max']}")
        print(f"    total_true == 0 / < 0    : "
              f"{s['n_total_true_zero_cells']} / "
              f"{s['n_total_true_negative_cells']}   "
              f"(total_geo is positive everywhere; see complication (a))")
        print(f"    exact zeros (all / res)  : {s['n_exact_zeros_all']} / "
              f"{s['n_exact_zeros_resolved']}")
        print(f"    zeros per cell           : "
              f"{s['zeros_per_cell']:.6e}")
        print(f"    zeros per resolved cell  : "
              f"{(s['zeros_per_resolved_cell'] or 0.0):.6e}")
        print(f"    min nu_pair              : {s['min_nu_pair']:.6e}  at "
              f"{s['min_nu_pair_at']}")
        if s["exact_zeros"]:
            print(f"    exact zeros, d >= 1:")
            print(f"      {'r':>5}{'d':>5}{'r-d':>6}{'res':>5}"
                  f"{'total_true':>16}{'S':>18}{'S>=floor':>10}")
            for z in s["exact_zeros"][:200]:
                print(f"      {z['r']:>5}{z['d']:>5}{z['r_minus_d']:>6}"
                      f"{('y' if z['resolved'] else 'n'):>5}"
                      f"{z['total_true']:>16}{z['S']:>18}"
                      f"{('y' if z['clears_mass_floor'] else 'n'):>10}")
            if len(s["exact_zeros"]) > 200:
                print(f"      ... {len(s['exact_zeros']) - 200} more, full "
                      f"list in the results JSON")
        else:
            print("    exact zeros, d >= 1      : none")
        print(f"    {s['top_k']} smallest nu_pair:")
        print(f"      {'#':>3}{'r':>5}{'d':>5}{'res':>5}{'cell':>16}"
              f"{'total_true':>16}{'nu_pair':>13}{'nu_geo':>13}{'nu_mass':>13}")
        for row in s["smallest_nu_pair"]:
            ng = "-" if row["nu_geo"] is None else f"{row['nu_geo']:.6e}"
            nm = "-" if row["nu_mass"] is None else f"{row['nu_mass']:.6e}"
            print(f"      {row['rank']:>3}{row['r']:>5}{row['d']:>5}"
                  f"{('y' if row['resolved'] else 'n'):>5}"
                  f"{row['cell']:>16}{row['total_true']:>16}"
                  f"{row['nu_pair']:>13.6e}{ng:>13}{nm:>13}", flush=True)

    # ---------------- Check 5: the rate test ---------------------------------
    C2 = b2["n_resolved_cells"]
    Csub = sum(s["n_resolved_cells"] for s in subs)
    Cfam = sum(s["n_resolved_cells"] for s in subs if s["arm"] == "family")
    Canti = sum(s["n_resolved_cells"] for s in subs if s["arm"] == "antiphase")
    Cref = sum(s["n_resolved_cells"] for s in subs if s["arm"] == "refinement")
    Z2 = b2["n_exact_zeros_resolved"]
    Z = sum(s["n_exact_zeros_resolved"] for s in subs)
    Zstar = sum(s["n_resolved_zeros_clearing_mass_floor"] for s in subs)
    Zstar_fam = sum(s["n_resolved_zeros_clearing_mass_floor"]
                    for s in subs if s["arm"] == "family")
    Zstar_anti = sum(s["n_resolved_zeros_clearing_mass_floor"]
                     for s in subs if s["arm"] == "antiphase")
    Zstar_ref = sum(s["n_resolved_zeros_clearing_mass_floor"]
                    for s in subs if s["arm"] == "refinement")

    for name, got_v, want_v in (("C_2", C2, C_2_LOCKED),
                                ("C_sub", Csub, C_SUB_LOCKED),
                                ("C_family", Cfam, C_FAMILY_LOCKED),
                                ("C_antiphase", Canti, C_ANTIPHASE_LOCKED),
                                ("C_refinement", Cref, C_REFINEMENT_LOCKED),
                                ("Z_2", Z2, Z_2_LOCKED)):
        if got_v != want_v:
            compromised.append(
                f"aggregate drift: {name} = {got_v}, locked {want_v}")

    E_Z = Z2 * Csub / C2 if C2 else float("nan")
    p_cond, p_mode = p_conditional_binomial(Z, Z2, C2, Csub)
    p_pois = p_poisson(Z, E_Z) if E_Z == E_Z else float("nan")

    print("\n" + RULE)
    print("5. THE RATE TEST")
    print(RULE)
    print(f"  resolved cells        : base 2 {C2}   sub-2 {Csub} "
          f"(family {Cfam}, antiphase {Canti}, refinement {Cref})")
    print(f"  Z_2 (base 2, resolved): {Z2}")
    print(f"  Z   (sub-2, resolved) : {Z}")
    print(f"  Z*  (S >= {MASS_FLOOR})        : {Zstar}   "
          f"(family {Zstar_fam}, antiphase {Zstar_anti}, "
          f"refinement {Zstar_ref})")
    print(f"  E[Z] under H0         : {E_Z:.12f}   "
          f"(locked {E_Z_H0_LOCKED:.12f})")
    print(f"  conditional-binomial p: {p_cond:.6e}   [{p_mode}]  PRIMARY")
    print(f"  Poisson p (lam=E[Z])  : {p_pois:.6e}   SECONDARY, cannot move "
          f"the verdict")
    print(f"  alpha_level           : {ALPHA_LEVEL} one-sided", flush=True)

    print("\n" + RULE)
    print("6. THE MASS PROFILE   (diagnostic; |cell| <= S exactly)")
    print(RULE)
    print("  base 2 (reference, known before the run):")
    for z in b2["exact_zeros"]:
        print(f"    ({z['r']:>2},{z['d']}):  S = {z['S']:>10}   "
              f"clears {MASS_FLOOR}: "
              f"{'yes' if z['clears_mass_floor'] else 'no'}")
    print("  sub-2 resolved zeros by mass:")
    allres = [(s["label"], z) for s in subs for z in s["exact_zeros"]
              if z["resolved"]]
    if not allres:
        print("    none")
    else:
        allres.sort(key=lambda t: -t[1]["S"])
        for lab, z in allres[:50]:
            print(f"    {lab:<20} ({z['r']:>4},{z['d']:>3})  S = {z['S']}   "
                  f"clears {MASS_FLOOR}: "
                  f"{'yes' if z['clears_mass_floor'] else 'no'}")
        if len(allres) > 50:
            print(f"    ... {len(allres) - 50} more, full list in the "
                  f"results JSON")
    print(flush=True)

    # ---------------- mechanical decision-rule output ------------------------
    if compromised:
        mech = "compromised"
    elif Z >= 1 and Zstar == 0:
        mech = "thin_rung_forced"
    elif Zstar >= 1 and Zstar_fam >= 1 and Zstar_anti == 0 and Zstar_ref == 0:
        mech = "family_only"
    elif Zstar >= 1 and Zstar_ref >= 1 and Zstar_fam == 0 and Zstar_anti == 0:
        mech = "refinement_only"
    elif Zstar >= 1 and p_cond > ALPHA_LEVEL:
        mech = "fineness"
    elif Zstar >= 1 and p_cond <= ALPHA_LEVEL:
        mech = "rate_below_base_two"
    elif Z == 0:
        mech = "intrinsic_base_two"
    else:                                                     # pragma: no cover
        mech = "ambiguous"

    print(RULE)
    print("MECHANICAL DECISION-RULE OUTPUT (NOT A VERDICT)")
    print(RULE)
    print(f"  Z  (sub-2 resolved zeros)        : {Z}")
    print(f"  Z* (of those, S >= {MASS_FLOOR})           : {Zstar}  "
          f"(fam {Zstar_fam} / anti {Zstar_anti} / ref {Zstar_ref})")
    print(f"  conditional-binomial p           : {p_cond:.6e}")
    print(f"  alpha_level                      : {ALPHA_LEVEL}")
    print(f"  compromised conditions tripped   : "
          f"{compromised if compromised else '(none)'}")
    print(f"  precedence                       : {PRECEDENCE}")
    print(f"  label the decision rule selects  : {mech}")
    print()
    print("  This is the decision rule's mechanical output, NOT a verdict.")
    print("  The verdict line in the prereg's Run record is Julian's to")
    print("  write.  An agent may compute the SHA and report the decision")
    print("  rule's mechanical output; it does not stamp the verdict.",
          flush=True)

    ended = datetime.datetime.now(datetime.timezone.utc)

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
                "value_ceiling_exp": VALUE_CEILING_EXP,
                "value_ceiling": VALUE_CEILING,
                "gamma_1": GAMMA1_STR,
                "dps": DPS,
                "d_min": D_MIN,
                "mass_floor": MASS_FLOOR,
                "alpha_level": ALPHA_LEVEL,
                "floor_determinacy_threshold": FLOOR_DETERMINACY,
                "pi_backend": pi_name,
                "pi_backend_version": pi_ver,
                "pi_audit_max_n": PI_AUDIT_MAX_N,
                "n_distinct_pi_arguments": len(pi_cache),
                "top_k": args.top_k,
                "cache": cache_path,
                "out": out_path,
                "python": sys.version,
                "source_files": source_files,
                "prereg": PREREG_PATH_REL,
                "status": "preregistered",
                "status_note":
                    "PREREGISTERED. This file reports the decision rule's "
                    "mechanical output at summary."
                    "mechanical_decision_rule_output. It does NOT stamp a "
                    "verdict; summary.verdict is null and the verdict line "
                    "in the prereg's Run record is Julian's to write. "
                    "CLAUDE.md, section Prereg discipline.",
            },
            "constants": {
                "convention": CONVENTION,
                "pair_identity":
                    "prime(r,d) + composite(r,d) = total_true(r,d) exactly at "
                    "every cell in every base, integer or not; this is "
                    "lean/PairIdentity.lean tableFrom_add_window applied to "
                    "the true rung populations W(r) = floor(b^r) - "
                    "floor(b^(r-1)). The FURTHER collapse to "
                    "(b-1)^(d+1)*b^(r-1-d) is tableFrom_of_geometric and "
                    "needs the rung to hold exactly (b-1)*b^(r-1) integers, "
                    "which is false for non-integer b.",
                "total_true":
                    "total_true(b,r,d) = sum_k (-1)^k C(d,k) W(r-k); exact "
                    "for every base; equals total_geo identically at integer "
                    "b. PRIMARY denominator.",
                "total_geo":
                    "total_geo(b,r,d) = (b-1)^(d+1) * b^(r-1-d); O44's "
                    "denominator. REPORTED ONLY, so the drift at non-integer "
                    "b is on the record. Nothing keys on it.",
                "normalisation_primary":
                    "nu_pair(b,r,d) = |cell| / |total_true|, exact Fraction; "
                    "undefined where total_true = 0 and those cells are "
                    "counted at summary.per_base[*]."
                    "n_total_true_zero_cells rather than ranked.",
                "normalisation_reported":
                    "nu_geo = |cell| / total_geo (O44's formula) and "
                    "nu_mass = |cell| / S (bounded in [0,1]).",
                "stencil_mass":
                    "S(r,d) = sum_k C(d,k) N(r-k); |cell(r,d)| <= S(r,d) "
                    "EXACTLY, so a cell with S < 1 has its zero forced. A "
                    "hard bound, not a model.",
                "resolved_criterion":
                    "a cell counts as resolved iff every rung its stencil "
                    "reads is expected to hold at least one prime, "
                    "W(r')/ln(b^(r')) >= 1 for all r' in [r-d, r]; "
                    "equivalently r - d >= r_thick(b). Pure geometry: no "
                    "prime is counted to evaluate it. At b = 2 the whole "
                    "support satisfies it (min 1.4426950408889634), so base "
                    "2 keeps all 496 cells and all four zeros.",
                "base_two_corollary":
                    "PairIdentity.coeff_eq_one_iff_base_two proves "
                    "(b-1)^(d+1) = 1 iff b = 2 for INTEGER b >= 2. It does "
                    "not cover 1 < b < 2, where (b-1)^(d+1) shrinks with "
                    "depth. See the script docstring, complication (c), for "
                    "why that does not make cells small at a non-integer "
                    "base.",
                "window_exclusivity":
                    "lean/Zeros.lean window_exclusive_of_prime_exponent: the "
                    "(20,6) window is 2^7 with 7 prime, so b^k = 2^7 with "
                    "b >= 2, k >= 2 forces b = 2, k = 7. This is the fineness "
                    "account's formal footing and it says nothing about "
                    "non-integer b.",
                "known_zeros_base_2": [list(t) for t in KNOWN_ZEROS_B2],
                "known_mass_base_2":
                    {f"{k[0]},{k[1]}": v for k, v in KNOWN_MASS_B2.items()},
                "locked_bases": [
                    {"arm": a, "label": lab, "kind": f"{k[0]}:{k[1]}",
                     "r_max": rm, "cells": ce, "r_thick": rt, "resolved": rs}
                    for a, lab, k, rm, ce, rt, rs in LOCKED_BASES],
                "locked_aggregates": {
                    "C_2": C_2_LOCKED, "C_sub": C_SUB_LOCKED,
                    "C_family": C_FAMILY_LOCKED,
                    "C_antiphase": C_ANTIPHASE_LOCKED,
                    "C_refinement": C_REFINEMENT_LOCKED,
                    "Z_2": Z_2_LOCKED, "E_Z_H0": E_Z_H0_LOCKED},
                "verdict_labels": list(VERDICT_LABELS),
                "precedence": PRECEDENCE,
                "randomness":
                    "none. No Monte Carlo, no permutation, no resampling, no "
                    "--seed flag and nothing to seed. REFERENCES.md section "
                    "Constants records seed 2026 for tests that need one.",
            },
            "summary": {
                "per_base": per_base,
                "pi_audit": audit,
                "C_2": C2, "C_sub": Csub, "C_family": Cfam,
                "C_antiphase": Canti, "C_refinement": Cref,
                "Z_2": Z2, "Z": Z, "Z_star": Zstar,
                "Z_star_family": Zstar_fam,
                "Z_star_antiphase": Zstar_anti,
                "Z_star_refinement": Zstar_ref,
                "E_Z_under_H0": E_Z,
                "p_conditional_binomial": p_cond,
                "p_conditional_binomial_mode": p_mode,
                "p_poisson_secondary": p_pois,
                "alpha_level": ALPHA_LEVEL,
                "compromised_conditions": compromised,
                "mechanical_decision_rule_output": mech,
                "verdict": None,
                "verdict_note":
                    "null by design. The verdict line is Julian's to write in "
                    "the prereg's Run record.",
            },
            "rows": [
                {"base": s["label"], "arm": s["arm"], **row}
                for s in per_base for row in s["smallest_nu_pair"]
            ],
        }
        _write_results(payload, out_path)

    print("\n" + RULE)
    print("READ THE RESULT")
    print(RULE)
    print("  Every cell, every W, every total_true and every stencil mass "
          "above is")
    print("  an exact Python integer; every nu_pair was ranked as an exact "
          "Fraction.")
    print("  mpmath appears only in floor(b^r) at the transcendental bases; "
          "the two")
    print("  dyadic refinements use exact integer roots and no floating "
          "point.")
    print("  The convention in force is THIS PROJECT'S (2 and 3 counted, "
          "pi(1) = 0),")
    print("  not the imported one O44 measured under, so low-r numbers here "
          "do not")
    print("  compare with O44's.")
    print("  Raw zero counts are not comparable across bases; zeros per cell "
          "is, and")
    print("  the denominator is printed beside every count.")
    print("  Nothing above is a verdict.")
    print(f"  finished (UTC): {ended.strftime('%Y-%m-%dT%H:%M:%SZ')}",
          flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
