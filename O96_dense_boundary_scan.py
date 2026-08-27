#!/usr/bin/env python3
"""
O96 — dense boundary scan: does exact-zero density STEP at the Nyquist
      boundary b* = exp(pi/gamma_1) = 1.248897?  Plus a companion arm that
      separates the three candidate accounts of O45's 2^(1/3) anomaly.

STATUS: PREREGISTERED.
Reads with: preregs/dense_boundary_scan_v1_20260827.md

  That prereg's filename carries no status, per preregs/FORMAT.md section
  "Prereg file naming and status"; the sidecar
  preregs/dense_boundary_scan_v1_20260827.sha256 is the authority on lock
  and the STATUS block inside the file is the second reading.  DO NOT RUN
  THIS SCRIPT while the prereg reads STATUS: DRAFT and no sidecar exists.
  While the prereg is locked, this script still does NOT stamp a verdict:
  it reports the decision rule's mechanical output and the verdict line is
  Julian's to write.  CLAUDE.md section "Prereg discipline": "An agent may
  compute the SHA and report the decision rule's mechanical output; it does
  not stamp the verdict."

PROVENANCE, stated here and in the prereg's own section.  Written
2026-08-27, before the prereg was locked.  The empirical null (116 placebo
windows) and the power table were computed on real prime counts during
design and are disclosed as SEEN.  The 26 measurement bases of the b* grid
were evaluated during design by the GEOMETRY gate only: the tuple
(r_max, r_thick, cells, resolved) was displayed and nothing else.  No zero
count, no per-side total, no D and no p at the b* grid has been displayed
to any agent or to Julian.  Arm 2's bases were partially inspected during
feasibility work (see the prereg), which is why arm 2 carries NO verdict
label and is reported as a descriptive companion.

Also reads with: results/sub_integer_base_scan.json  (O45, the instrument
                     this densifies: b* is O45's family member k = 2, with
                     r_max 99, r_thick 12, 3828 resolved cells, 14 resolved
                     zeros at the ceiling 2^32)
                 O45_sub_integer_base_scan.py  (the geometry conventions
                     are O45's, reused and re-verified, not imported)
                 notes/lab_notebook_2.md entry 199 (the question), entry
                     211 (why the dense scan stayed a separate line)
                 preregs/FORMAT.md section "Lock, commit, then run"
                 CONTEXT.md section "Core quantities" (the convention)
                 REFERENCES.md section "Constants" (gamma_1)

=============================================================================
ARM 1 — THE BOUNDARY SCAN
=============================================================================

lean/Nyquist.lean base_bound_of_resolvable caps a base that resolves
gamma_1 at exp(pi/gamma_1) = 1.2488968.  Entry 199 showed that in O45's own
coordinate that condition is exactly theta = gamma_1 * log b < 180 degrees,
and that O45's eleven bases cannot test it: theta is strictly increasing in
b, so splitting at theta = 180 IS splitting at b = 1.2488968, and O45's
whole table varies monotonically along that same axis.  A level difference
between two groups is what a smooth trend produces anyway.

What separates a threshold from a trend is a DISCONTINUITY: bases sampled
densely on both sides of b*, close enough that the smooth trend is locally
flat, asking whether the statistic steps.  That is this arm.

NO MECHANISM PREDICTS A STEP.  The difference filter's per-rung gain at
gamma_1 is |1 - exp(i*theta)|^d = (2 sin(theta/2))^d, which is smooth at
theta = pi and in fact STATIONARY there — b* is a smooth maximum of the
gamma_1 response, not a break in it.  Every other ingredient of the table
(floor(b^r), W(r), pi, r_thick, the resolved stratum) is either continuous
in b or piecewise constant on intervals that do not end at b*.  The
expected outcome is `no_step`.  That is stated before the run, in the
prereg, and it is why the interesting outcome would be a step.

THE CEILING IS DELIBERATELY GENERIC.  V = exp(99.5 * log b*) =
4.021540e9 = 2^31.9051, chosen so b* sits at the centre of the r_max = 99
plateau b in (1.2475097, 1.2502995], where r_thick = 12 and the resolved
cell count 3828 are CONSTANT.  A varying denominator would invalidate the
design, so that constancy is a run-time gate over all 26 grid bases, not
an assumption.  V is not 2^32: an exact power of two puts 2^(1/2) and
2^(1/3) on r_max staircase edges, which is one of the three accounts arm 2
exists to separate.

THE STATISTIC.  Z_below = zeros in the resolved stratum summed over the 13
bases below b*, Z_above the same above, and

    D = (Z_above - Z_below) / (Z_above + Z_below).

The raw difference Z_above - Z_below is what the design proposed; the ratio
is the studentised form, and the justification is measured rather than
assumed.  Binomially thinning every placebo window to half its counts (the
level moved, the location held fixed) moves the null sd of the raw
difference by -46.6%, of the sqrt-studentised form (Zh-Zl)/sqrt(Zh+Zl) by
-24.0%, and of the ratio D by +8.5%.  The counts fluctuate MULTIPLICATIVELY,
not as Poisson counts, so the total in the denominator is exactly the scale
the placebo/b* level mismatch would otherwise move.  Numbers in the
prereg's section "The null and the level mismatch".

THE NULL IS EMPIRICAL, AND THAT IS LOAD-BEARING.  Zero counts are strongly
autocorrelated in b, so a Poisson or binomial null understates the spread
by a factor of two to six in variance and MUST NOT be used.  The null is
116 placebo windows of matched geometry — same r_max = 99 plateau class,
same 13 bases per side, same 1e-4 spacing, centres locked by the explicit
list below, every one of them disjoint from the b* plateau.  The p-value is
the standard rank form

    p = 2 * min(1 + #{D_i <= D_obs}, 1 + #{D_i >= D_obs}) / (N + 1),

which is exactly valid under exchangeability and needs no distributional
assumption at all.  The internal circular-rotation null is carried as a
LABELLED SECONDARY and can never move the label: it is slightly
anti-conservative, since a real step inflates the rotation spread that
would have to detect it.

=============================================================================
ARM 2 — THE COMPANION.  AN ARITHMETIC QUESTION, NOT A NYQUIST ONE.
=============================================================================

O45's 2^(1/3) carried the lowest zeros-per-resolved-cell of all eleven
bases, 0.00084, a factor of four under its neighbours on either side.
Entry 199 offered it as a hint at n = 1.  It has THREE candidate accounts,
not two:

  (i)   ABOVE THE BOUNDARY.  theta(2^(1/3)) = 187.1 degrees, the closest
        base above 180.
  (ii)  INTEGER-ROOT ARITHMETIC.  floor(b^r) is EXACT whenever m | r, so
        every m-th rung of 2^(1/m) lands on a power of two and the rung
        populations are not generic.
  (iii) CEILING ATTAINMENT.  At O45's V = 2^32, log V / log b is exactly
        96.0000 for 2^(1/3) and 64.0000 for 2^(1/2).  Both sit ON r_max
        staircase edges where the eight transcendental bases sit at generic
        fractional positions.

This arm scans 2^(1/m) for m = 2..8 at the GENERIC ceiling V above, which
breaks (iii) by construction — log V / log b has fractional part 0.810,
0.715, 0.620, 0.526, 0.431, 0.336, 0.241 for m = 2..8, every one of them
interior.  Each b_m is read against 12 local non-root neighbours inside its
own r_max plateau, so the smooth trend in b is differenced out.  n = 7
instead of n = 1.

The three accounts have three distinct signatures, and the arm is designed
so they cannot be confused:

    account            which m should read low
    (i)  Nyquist       m = 2, 3 only        (theta 280.7, 187.1 > 180)
    (ii) arithmetic    all seven            (m | r is an m-independent fact)
    (iii) ceiling      none                 (broken by the generic V)

ARM 2 CARRIES NO VERDICT LABEL.  Its bases were partially inspected during
feasibility work, its readout is descriptive, and the decision rule below
does not read it.

=============================================================================
THE INSTRUMENT TRAP, PAID FOR ONCE
=============================================================================

At dps 60 mpmath loses the top rung for 2^(1/2): floor(b^64) reads
4294967295 where the exact answer is 4294967296, because b^r rounds just
under the exact integer, and r_max comes out 63 instead of 64.  O45 uses
EXACT INTEGER m-th roots for its two refinement bases for precisely this
reason.  Arm 2 does the same, and this script measures the trap rather than
citing it: for m = 2..8 the mpmath route loses the top rung at m = 2, 5, 7
and disagrees with the exact roots at 31 or 32 interior rungs at m = 4, 6, 8
(every rung where m | r).  Printed in section 2.

Arm 1's grid bases are ordinary reals with no such structure and use the
mpmath route at dps 60, gated by a floor-determinacy check at 1e-30
relative, exactly as O45 does.

=============================================================================
THE CONVENTION IN FORCE
=============================================================================

THIS PROJECT'S convention, not the imported one:

    2 and 3 are COUNTED AS PRIMES; pi(1) = 0;
    N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))) on the half-open rung
    (b^(r-1), b^r], with floor(b^0) = 1.

CONTEXT.md section "Core quantities".  Identical to O45's.

=============================================================================
THE DECISION RULE IS A PREDICATE TABLE
=============================================================================

This is the first prereg in the tree whose decision rule is implemented as
a predicate TABLE rather than an if/elif chain.  Each row carries a label
and a boolean predicate.  The rows before the residue are mutually
exclusive by construction; the residue row's predicate is the literal
constant True, so the table is TOTAL — some row always matches, whatever a
future edit does to the rows above it.

The assertion is that EXACTLY ONE non-residue row fires, so the residue is
never the selection.  If it fires wrong — zero rows, or two — the residue
`undetermined` is selected, `decision_rule_partition_failed` is appended to
the compromised list, and the run reports that instead of a label.  That
outcome is a finding about the convention, not about the boundary.

=============================================================================
ARITHMETIC
=============================================================================

Exact Python integers for every floor, every W, every N, every table cell
and every stencil mass.  mpmath at dps 60 appears only to obtain floor(b^r)
at the ordinary real bases; the seven integer-root bases use exact integer
m-th roots and no floating point.  Floats appear in ln, in D, in p, in
printed values — never in a zero test.

Randomness: none in the measurement.  The power table was measured before
lock with seed 2026 and is carried as a locked constant; `--power-check`
recomputes it with the same seed and is off by default so the run stays
deterministic.

=============================================================================
OUTPUTS
=============================================================================

results/dense_boundary_scan.json   house envelope, schema_version "1",
                                   written through utilities.resultsguard
                                   guarded_write.

HOW IT WILL BE RUN (do not run while the prereg says DRAFT)
-----------------------------------------------------------
    python3 utilities/run.py --python .venv/bin/python \
        --log results/O96_dense_boundary_scan_run1.log \
        O96_dense_boundary_scan.py \
        --cache pi2n_cache.json \
        --prereg preregs/dense_boundary_scan_v1_20260827.md \
        --out results/dense_boundary_scan.json

REQUIREMENTS: standard library, plus primecountpy and mpmath.
"""

import argparse
import datetime
import hashlib
import json
import math
import os
import sys

from mpmath import (mp, mpf, floor as mpfloor, log as mplog, exp as mpexp,
                    pi as MPPI)

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write            # noqa: E402

DEFAULT_OUT_JSON = os.path.join(_HERE, "results", "dense_boundary_scan.json")
DEFAULT_CACHE = os.path.join(_HERE, "pi2n_cache.json")
DEFAULT_PREREG = os.path.join(_HERE, "preregs",
                              "dense_boundary_scan_v1_20260827.md")
O45_RESULTS = os.path.join(_HERE, "results", "sub_integer_base_scan.json")

RULE = "=" * 78
THIN = "-" * 78


# ---------------------------------------------------------------------------
# LOCKED, NOT FLAGS
#
# Every constant in this block is a locked parameter of
# preregs/dense_boundary_scan_v1_20260827.md.  None is exposed as a flag;
# changing one after lock is a protocol violation, not a re-run.
# ---------------------------------------------------------------------------

PREREG_PATH_REL = "preregs/dense_boundary_scan_v1_20260827.md"

VERDICT_LABELS = ("compromised", "step_above", "step_below", "no_step",
                  "undetermined")
PRECEDENCE = ("compromised > step_above > step_below > no_step > "
              "undetermined (residue, predicate is the constant True)")

# REFERENCES.md section Constants: "gamma_1  14.134725141734693".
GAMMA1_STR = "14.134725141734693"

DPS = 60
D_MIN = 1                       # zeros counted at d >= 1
MASS_FLOOR = 88                 # S(8,3) at base 2; diagnostic only here
FLOOR_DETERMINACY = 1e-30       # relative; O45's threshold
PI_AUDIT_MAX_N = 32

# --- arm 1 geometry -------------------------------------------------------
PLATEAU_INDEX = 99              # r_max of the plateau b* is centred in
PLATEAU_OFFSET = "99.5"         # log V = PLATEAU_OFFSET * log b*
GRID_PER_SIDE = 13
GRID_SPACING = "0.0001"
# grid base i on each side is b* -/+ (i + 1/2) * GRID_SPACING, i = 0..12,
# so b* itself is never evaluated and the two sides are exactly symmetric.
LOCKED_GRID_GEOMETRY = (99, 12, 4851, 3828)   # r_max, r_thick, cells, resolved

# --- arm 1 null -----------------------------------------------------------
# 116 placebo centres.  Deterministic output of a GEOMETRY-ONLY rule: step
# 0.0005 from 1.2260 to below 1.3350, keep b0 iff its own r_max = 99
# plateau contains all 26 window bases AND the window's
# (r_max, r_thick, resolved) is constant across them AND the plateau is
# disjoint from b*'s.  No prime is counted to select a centre.  The list is
# locked here so a later reader does not have to re-derive it.
PLACEBO_CENTRES = (
    "1.2265", "1.2270", "1.2275", "1.2280", "1.2285", "1.2345", "1.2350",
    "1.2355", "1.2360", "1.2365", "1.2370", "1.2400", "1.2405", "1.2410",
    "1.2415", "1.2420", "1.2520", "1.2550", "1.2555", "1.2560", "1.2565",
    "1.2570", "1.2575", "1.2605", "1.2610", "1.2640", "1.2645", "1.2650",
    "1.2655", "1.2660", "1.2665", "1.2670", "1.2675", "1.2680", "1.2685",
    "1.2690", "1.2695", "1.2725", "1.2730", "1.2735", "1.2740", "1.2745",
    "1.2750", "1.2780", "1.2785", "1.2790", "1.2795", "1.2800", "1.2805",
    "1.2835", "1.2840", "1.2845", "1.2850", "1.2855", "1.2860", "1.2865",
    "1.2870", "1.2875", "1.2880", "1.2885", "1.2890", "1.2895", "1.2900",
    "1.2940", "1.2945", "1.2950", "1.2955", "1.2985", "1.2990", "1.2995",
    "1.3000", "1.3005", "1.3010", "1.3015", "1.3020", "1.3025", "1.3030",
    "1.3035", "1.3040", "1.3070", "1.3075", "1.3080", "1.3085", "1.3090",
    "1.3095", "1.3100", "1.3105", "1.3110", "1.3115", "1.3120", "1.3125",
    "1.3130", "1.3135", "1.3140", "1.3145", "1.3220", "1.3225", "1.3230",
    "1.3235", "1.3240", "1.3245", "1.3250", "1.3255", "1.3260", "1.3265",
    "1.3270", "1.3275", "1.3280", "1.3285", "1.3290", "1.3295", "1.3300",
    "1.3305", "1.3310", "1.3315", "1.3320",
)
N_PLACEBO_LOCKED = 116
ALPHA_LEVEL = 0.05              # two-sided

# Power, measured before lock on the 116 placebo windows with planted
# multiplicative steps on the above side, 60 draws per window per rho,
# leave-one-out null, seed 2026.  rho = 1 is the identity, so its row IS
# the calibration and it is measured, not asserted.
POWER_TABLE = (
    (0.25, 0.922), (0.50, 0.227), (0.75, 0.049), (1.00, 0.034),
    (1.25, 0.080), (1.50, 0.237), (2.00, 0.580), (3.00, 0.927),
)
POWER_SEED = 2026
POWER_REPS = 60

# --- arm 2 ----------------------------------------------------------------
ARM2_M = (2, 3, 4, 5, 6, 7, 8)
ARM2_NEIGHBOURS_PER_SIDE = 6
ARM2_DELTA_DIVISOR = 64         # delta_m = (plateau width) / 64

# --- base-2 reproduction (a reproduction check, NOT evidence) -------------
BASE2_CEILING_EXP = 32
KNOWN_ZEROS_B2 = ((2, 1), (4, 1), (8, 3), (20, 6))
KNOWN_MASS_B2 = {(2, 1): 2, (4, 1): 4, (8, 3): 88, (20, 6): 492384}
KNOWN_CELLS_B2 = 496

CONVENTION = (
    "THIS PROJECT'S convention: 2 and 3 are COUNTED AS PRIMES, pi(1) = 0, "
    "N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))) on the half-open rung "
    "(b^(r-1), b^r], with floor(b^0) = 1. Source: CONTEXT.md section "
    "'Core quantities'. Identical to O45's."
)


# ---------------------------------------------------------------------------
# house plumbing
# ---------------------------------------------------------------------------

def _code_version():
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
        return f"unavailable: {exc}"


def _jsonable(o):
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


def _resolve(path):
    return path if os.path.isabs(path) else os.path.join(_HERE, path)


def load_pi_backend():
    """primecountpy.prime_pi primary, sympy.primepi fallback.  Both exact."""
    try:
        from primecountpy import prime_pi as _pp
        try:
            import importlib.metadata as _md
            ver = _md.version("primecountpy")
        except Exception:                                     # pragma: no cover
            ver = "unknown"
        return (lambda x: int(_pp(int(x))) if x >= 2 else 0,
                "primecountpy.prime_pi", ver)
    except Exception as exc_primary:                          # pragma: no cover
        try:
            from sympy import primepi as _sp
            try:
                import importlib.metadata as _md
                ver = _md.version("sympy")
            except Exception:
                ver = "unknown"
            return (lambda x: int(_sp(int(x))) if x >= 2 else 0,
                    "sympy.primepi", ver)
        except Exception as exc_fallback:
            raise RuntimeError(
                "no exact pi backend available: primecountpy failed with "
                f"{exc_primary!r}; sympy failed with {exc_fallback!r}")


# ---------------------------------------------------------------------------
# the kernel — O45's geometry, re-derived here and verified against O45
# ---------------------------------------------------------------------------

def iroot(n, k):
    """Exact floor of the integer k-th root of n, by integer Newton.
    O45_sub_integer_base_scan.py iroot, character for character: a
    floating-point floor lands on the wrong side whenever k divides the
    exponent."""
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


def floors_real(b, V):
    """(r_max, F, min_rel_gap) for an ordinary real base at dps DPS.
    F[r] = floor(b^r); r_max is the largest r with b^r <= V.  O45's
    base_geometry, transcendental branch."""
    r_max = int(mpfloor(mplog(V) / mplog(b)))
    while b ** (r_max + 1) <= V:
        r_max += 1
    while b ** r_max > V:
        r_max -= 1
    F = [int(mpfloor(b ** r)) for r in range(r_max + 1)]
    gap = None
    for r in range(1, r_max + 1):
        x = b ** r
        g = float(abs(x - mp.nint(x)) / x)
        gap = g if gap is None else min(gap, g)
    return r_max, F, gap


def floors_root_of_two(m, V):
    """(r_max, F, selfcheck_failures) for b = 2^(1/m) with EXACT integer
    m-th roots.  floor((2^(1/m))^r) = floor(2^(r/m)) = iroot(2^r, m) is an
    exact integer question and never touches a float."""
    # r_max is the largest r with 2^(r/m) <= V, i.e. r <= m * log2(V).  When
    # V is an exact power of two that boundary is attained and a 1-ulp error
    # would cost the top rung — which is the very trap this branch exists to
    # avoid — so that case is answered in integers.  Otherwise the log
    # comparison is done at four times the working precision.
    e2 = int(mpfloor(mplog(V) / mplog(2)))
    if mpf(2) ** e2 == V:
        r_max = e2 * m
    else:
        old = mp.dps
        try:
            mp.dps = 4 * DPS
            r_max = int(mpfloor(mpf(m) * mplog(V) / mplog(2)))
        finally:
            mp.dps = old
    F = [iroot(1 << r, m) for r in range(r_max + 1)]
    bad = sum(1 for r in range(r_max + 1)
              if not (F[r] ** m <= (1 << r) < (F[r] + 1) ** m))
    return r_max, F, bad


def floors_int_two(exp2):
    """base 2 at V = 2^exp2, exactly."""
    return exp2, [1 << r for r in range(exp2 + 1)], 0


def r_thick_of(W, b, r_max):
    """O45's r_thick_of: smallest R with W(r)/ln(b^r) >= 1 for every
    r >= R.  Pure geometry; no prime is counted."""
    lnb = float(mplog(b))
    rt = r_max + 1
    for r in range(r_max, 0, -1):
        if W[r] / (lnb * r) >= 1.0:
            rt = r
        else:
            break
    return rt


def scan(b, r_max, F, PI, want_mass=False):
    """One base end to end under O45's conventions.

        W(r) = F[r] - F[r-1]
        N(r) = pi(F[r]) - pi(F[r-1]),  pi(1) = 0
        P(r,0) = N(r),  P(r,d) = P(r,d-1) - P(r-1,d-1)

    Cells are counted at d >= D_MIN; a cell is resolved iff r - d >=
    r_thick.  Exact Python integers throughout."""
    W = [0] + [F[r] - F[r - 1] for r in range(1, r_max + 1)]
    r_thick = r_thick_of(W, b, r_max)
    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    row = N[:]
    cells = resolved = z_all = z_res = 0
    zeros_res = []
    for d in range(D_MIN, r_max):
        row = [0] * (d + 1) + [row[r] - row[r - 1]
                               for r in range(d + 1, r_max + 1)]
        for r in range(d + 1, r_max + 1):
            cells += 1
            is_res = (r - d) >= r_thick
            if is_res:
                resolved += 1
            if row[r] == 0:
                z_all += 1
                if is_res:
                    z_res += 1
                    zeros_res.append((r, d))
    out = {"r_max": r_max, "r_thick": r_thick, "cells": cells,
           "resolved": resolved, "z_all": z_all, "z_res": z_res,
           "zeros_res": zeros_res, "W_at_r_max": W[r_max]}
    if want_mass:
        S = {f"{r},{d}": sum(math.comb(d, k) * N[r - k] for k in range(d + 1))
             for (r, d) in zeros_res}
        out["S_at_zeros"] = S
        out["z_star"] = sum(1 for v in S.values() if v >= MASS_FLOOR)
    return out


# ---------------------------------------------------------------------------
# arm 1 — windows and statistics
# ---------------------------------------------------------------------------

def window_bases(b0, spacing, per_side):
    """The 2*per_side bases of a window centred at b0, below then above.
    The centre itself is never a base."""
    half = mpf(1) / 2
    below = [b0 - (mpf(i) + half) * spacing for i in range(per_side)]
    above = [b0 + (mpf(i) + half) * spacing for i in range(per_side)]
    return sorted(below), above


def plateau_of(b0, index, offset):
    """(V, lo, hi) for the r_max = index plateau that b0 is placed in by
    log V = offset * log b0.  The plateau is b in (lo, hi]."""
    lV = mpf(offset) * mplog(b0)
    return mpexp(lV), mpexp(lV / (index + 1)), mpexp(lV / index)


def measure_window(b0, PI, want_detail=False):
    """Evaluate one window.  Returns a dict, or a dict with 'skip' set when
    the geometry gate rejects it.  The gate is geometry only."""
    V, lo, hi = plateau_of(b0, PLATEAU_INDEX, PLATEAU_OFFSET)
    below, above = window_bases(b0, mpf(GRID_SPACING), GRID_PER_SIDE)
    if min(below) <= lo or max(above) > hi:
        return {"skip": "window not contained in its own plateau"}
    geoms = set()
    zl, zh, gaps, detail = [], [], [], []
    for side, bs in (("below", below), ("above", above)):
        for b in bs:
            r_max, F, gap = floors_real(b, V)
            s = scan(b, r_max, F, PI, want_mass=want_detail)
            geoms.add((s["r_max"], s["r_thick"], s["cells"], s["resolved"]))
            gaps.append(gap)
            (zl if side == "below" else zh).append(s["z_res"])
            if want_detail:
                detail.append({"side": side, "b": float(b),
                               "b_str": mp.nstr(b, 20),
                               "r_max": s["r_max"], "r_thick": s["r_thick"],
                               "cells": s["cells"], "resolved": s["resolved"],
                               "z_all": s["z_all"], "z_res": s["z_res"],
                               "z_star": s["z_star"],
                               "min_rel_gap": gap,
                               "zeros_res": [list(t) for t in s["zeros_res"]]})
    if len(geoms) != 1:
        return {"skip": f"geometry varies across the window: {sorted(geoms)}"}
    out = {"b0": float(b0), "b0_str": mp.nstr(b0, 20), "V": float(V),
           "plateau_lo": float(lo), "plateau_hi": float(hi),
           "geometry": list(geoms.pop()), "z_below": zl, "z_above": zh,
           "min_rel_gap": min(gaps)}
    if want_detail:
        out["per_base"] = detail
    return out


def D_of(zl, zh):
    """The studentised statistic.  Returns (D, raw difference, total)."""
    a, b = sum(zl), sum(zh)
    return (((b - a) / (a + b)) if (a + b) else 0.0), b - a, a + b


def rank_p_two_sided(obs, null):
    """p = 2 * min(1 + #{x <= obs}, 1 + #{x >= obs}) / (N + 1), capped at 1.
    Exactly valid under exchangeability; no distributional assumption."""
    n = len(null)
    le = sum(1 for x in null if x <= obs)
    ge = sum(1 for x in null if x >= obs)
    return min(1.0, 2.0 * min(le + 1, ge + 1) / (n + 1))


def rotation_null(zl, zh):
    """SECONDARY, and it cannot move the label.  D over the 25 non-trivial
    circular rotations of the window's own 26-base sequence.  It is
    slightly anti-conservative: a real step inflates the very spread that
    would have to detect it."""
    z = list(zl) + list(zh)
    n = len(z)
    vals = []
    for k in range(1, n):
        rz = z[k:] + z[:k]
        vals.append(D_of(rz[:GRID_PER_SIDE], rz[GRID_PER_SIDE:])[0])
    return vals


# ---------------------------------------------------------------------------
# power (off by default; the locked table was measured before lock)
# ---------------------------------------------------------------------------

def power_check(windows, rng):
    """Reproduce POWER_TABLE from the placebo windows.  Multiplicative step
    rho on the above side: binomial thinning for rho <= 1, a Poisson
    addition of mean z*(rho-1) for rho > 1.  Leave-one-out null."""
    def plant(zh, rho):
        out = []
        for z in zh:
            if rho <= 1:
                out.append(sum(1 for _ in range(z) if rng.random() < rho))
            else:
                lam = z * (rho - 1)
                L = math.exp(-lam)
                k, p = 0, 1.0
                while True:
                    p *= rng.random()
                    if p <= L:
                        break
                    k += 1
                out.append(z + k)
        return out
    base = [D_of(w["z_below"], w["z_above"])[0] for w in windows]
    rows = []
    for rho, _locked in POWER_TABLE:
        hits = trials = 0
        for i, w in enumerate(windows):
            ref = base[:i] + base[i + 1:]
            reps = 1 if rho == 1.0 else POWER_REPS
            for _ in range(reps):
                zh2 = w["z_above"] if rho == 1.0 else plant(w["z_above"], rho)
                d = D_of(w["z_below"], zh2)[0]
                trials += 1
                if rank_p_two_sided(d, ref) <= ALPHA_LEVEL:
                    hits += 1
        rows.append({"rho": rho, "detect": hits / trials, "trials": trials,
                     "locked": _locked})
    return rows


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(
        description="O96 - dense boundary scan (preregistered; this script "
                    "reports the decision rule's mechanical output and does "
                    "NOT stamp a verdict)")
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE,
                    help="pi(2^n) cache, read-only, for the pi backend audit")
    ap.add_argument("--prereg", type=str, default=DEFAULT_PREREG,
                    help="prereg path, recorded with its sha256")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true", default=False,
                    help="skip the results JSON (console output only)")
    ap.add_argument("--power-check", action="store_true", default=False,
                    help="recompute the locked power table with seed "
                         f"{POWER_SEED}; off by default so the run is "
                         f"deterministic")
    ap.add_argument("--self-test-centre", type=str, default=None,
                    help="run arm 1's grid at a PLACEBO centre instead of "
                         "b*, print SELF TEST and write nothing. Exercises "
                         "the pipeline without evaluating the measurement "
                         "grid.")
    args = ap.parse_args()

    mp.dps = DPS
    gamma1 = mpf(GAMMA1_STR)
    bstar = mpexp(MPPI / gamma1)
    started = datetime.datetime.now(datetime.timezone.utc)
    cache_path = _resolve(args.cache)
    prereg_path = _resolve(args.prereg)
    out_path = _resolve(args.out)
    self_test = args.self_test_centre is not None
    centre = mpf(args.self_test_centre) if self_test else bstar
    compromised = []
    source_files = []

    print(RULE, flush=True)
    print("O96 - DENSE BOUNDARY SCAN   (PREREGISTERED)", flush=True)
    if self_test:
        print("*** SELF TEST at a placebo centre - NOT the measurement, "
              "nothing is written ***", flush=True)
    print(RULE, flush=True)
    print(f"  started (UTC)          : {started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  prereg                 : {PREREG_PATH_REL}")
    print(f"  gamma_1 (locked)       : {GAMMA1_STR}")
    print(f"  b* = exp(pi/gamma_1)   : {mp.nstr(bstar, 22)}")
    print(f"  grid centre            : {mp.nstr(centre, 22)}"
          f"{'   [SELF TEST]' if self_test else ''}")
    print(f"  mpmath dps             : {DPS}")
    print(f"  d-min                  : {D_MIN}")
    print(f"  alpha_level            : {ALPHA_LEVEL}  two-sided")
    print(f"  cache (READ ONLY)      : {cache_path}")
    print(f"  out                    : {out_path}")
    print(f"  python                 : {sys.version.split()[0]}")
    print(f"  code_version (sha256)  : {_code_version()}", flush=True)
    print()
    print("  Nothing printed here is a verdict.  This script reports the")
    print("  decision rule's mechanical output; the verdict line is Julian's")
    print("  to write.  CLAUDE.md, section 'Prereg discipline'.", flush=True)
    print("\n  CONVENTION IN FORCE")
    for line in (CONVENTION[i:i + 74] for i in range(0, len(CONVENTION), 74)):
        print("    " + line)
    print(flush=True)

    # ---------------- 1. pi backend integrity --------------------------------
    print(RULE)
    print("1. PI BACKEND INTEGRITY   (stops the run on failure)")
    print(RULE, flush=True)
    pi_cache = {}

    try:
        pi_fn, pi_name, pi_ver = load_pi_backend()
        print(f"  backend               : {pi_name}  {pi_ver}")
    except Exception as exc:                                  # pragma: no cover
        pi_fn, pi_name, pi_ver = None, "unavailable", "-"
        compromised.append(f"pi_backend_unavailable: {exc}")
        print(f"  backend               : UNAVAILABLE  ({exc})")

    def PI(x):
        x = int(x)
        if x < 2:
            return 0
        v = pi_cache.get(x)
        if v is None:
            v = pi_cache[x] = pi_fn(x)
        return v

    audit = []
    if pi_fn is not None:
        try:
            with open(cache_path) as fh:
                pi2 = json.load(fh)
            source_files.append(file_record(cache_path, {"role": "pi_audit"}))
            for n in range(0, PI_AUDIT_MAX_N + 1):
                key = str(n)
                if key not in pi2:
                    compromised.append(f"cache missing pi(2^{n})")
                    continue
                want, got = int(pi2[key]), pi_fn(1 << n)
                audit.append({"n": n, "cache": want, "backend": got,
                              "equal": want == got})
                if want != got:
                    compromised.append(
                        f"pi audit: pi(2^{n}) backend {got} != cache {want}")
        except Exception as exc:                              # pragma: no cover
            compromised.append(f"cache_read_failed: {exc}")
        n_ok = sum(1 for a in audit if a["equal"])
        print(f"  comparisons           : {n_ok} of {len(audit)} equal "
              f"(need {PI_AUDIT_MAX_N + 1} of {PI_AUDIT_MAX_N + 1})")
        print(f"  status                : "
              f"{'FAIL' if compromised else 'PASS'}", flush=True)

    for p, role in ((prereg_path, "prereg"), (O45_RESULTS, "o45_results")):
        if os.path.exists(p):
            source_files.append(file_record(p, {"role": role}))
        else:
            print(f"  WARNING: {role} not found at {p}", flush=True)

    # ---------------- 2. kernel verification against O45 ---------------------
    print("\n" + RULE)
    print("2. KERNEL VERIFICATION AGAINST O45   (a reproduction check, NOT "
          "evidence)")
    print(RULE, flush=True)
    kernel_check = {}
    o45 = None
    try:
        with open(O45_RESULTS) as fh:
            o45 = json.load(fh)
    except Exception as exc:                                  # pragma: no cover
        compromised.append(f"o45_results_unreadable: {exc}")

    if pi_fn is not None:
        V32 = mpf(2) ** BASE2_CEILING_EXP
        rm, F, _ = floors_int_two(BASE2_CEILING_EXP)
        s2 = scan(mpf(2), rm, F, PI, want_mass=True)
        got = tuple(sorted(s2["zeros_res"]))
        want = tuple(sorted(KNOWN_ZEROS_B2))
        mass_ok = all(s2["S_at_zeros"].get(f"{r},{d}") == v
                      for (r, d), v in KNOWN_MASS_B2.items())
        kernel_check["base_2"] = {
            "cells": s2["cells"], "cells_expected": KNOWN_CELLS_B2,
            "zeros": [list(t) for t in got],
            "zeros_expected": [list(t) for t in want],
            "stencil_mass": s2["S_at_zeros"], "mass_matches": mass_ok,
            "matches": got == want and s2["cells"] == KNOWN_CELLS_B2 and mass_ok,
        }
        print(f"  base 2 @ V = 2^{BASE2_CEILING_EXP}")
        print(f"    cells at d >= 1     : {s2['cells']}  (expected "
              f"{KNOWN_CELLS_B2})")
        print(f"    exact zeros         : {[list(t) for t in got]}")
        print(f"    expected            : {[list(t) for t in want]}")
        print(f"    stencil mass S      : {s2['S_at_zeros']}")
        if not kernel_check["base_2"]["matches"]:
            compromised.append(
                f"kernel base-2 reproduction failed: cells {s2['cells']}, "
                f"zeros {[list(t) for t in got]}, mass_ok {mass_ok}")

        # two ordinary real bases from O45's own table, end to end
        per45 = {p["label"]: p for p in o45["summary"]["per_base"]} if o45 else {}
        for label, k, denom in (("exp(pi*2/(2*g1))", 2, 2),
                                ("exp(pi*5/(4*g1))", 5, 4)):
            b = mpexp(MPPI * k / (denom * gamma1))
            r_max, F, gap = floors_real(b, V32)
            s = scan(b, r_max, F, PI, want_mass=True)
            p45 = per45.get(label)
            ok = p45 is not None and (
                s["r_max"] == p45["r_max"]
                and s["cells"] == p45["n_cells_at_d_ge_1"]
                and s["r_thick"] == p45["r_thick"]
                and s["resolved"] == p45["n_resolved_cells"]
                and s["z_all"] == p45["n_exact_zeros_all"]
                and s["z_res"] == p45["n_exact_zeros_resolved"]
                and s["z_star"] == p45["n_resolved_zeros_clearing_mass_floor"])
            kernel_check[label] = {
                "ours": {kk: s[kk] for kk in
                         ("r_max", "r_thick", "cells", "resolved",
                          "z_all", "z_res", "z_star")},
                "o45": ({"r_max": p45["r_max"],
                         "r_thick": p45["r_thick"],
                         "cells": p45["n_cells_at_d_ge_1"],
                         "resolved": p45["n_resolved_cells"],
                         "z_all": p45["n_exact_zeros_all"],
                         "z_res": p45["n_exact_zeros_resolved"],
                         "z_star": p45["n_resolved_zeros_clearing_mass_floor"]}
                        if p45 else None),
                "matches": bool(ok),
            }
            print(f"  {label} @ V = 2^32")
            print(f"    ours : r_max {s['r_max']}  r_thick {s['r_thick']}  "
                  f"cells {s['cells']}  resolved {s['resolved']}  "
                  f"z_all {s['z_all']}  z_res {s['z_res']}  z* {s['z_star']}")
            if p45:
                print(f"    O45  : r_max {p45['r_max']}  r_thick "
                      f"{p45['r_thick']}  cells {p45['n_cells_at_d_ge_1']}  "
                      f"resolved {p45['n_resolved_cells']}  z_all "
                      f"{p45['n_exact_zeros_all']}  z_res "
                      f"{p45['n_exact_zeros_resolved']}  z* "
                      f"{p45['n_resolved_zeros_clearing_mass_floor']}")
            print(f"    match: {'yes' if ok else 'NO'}", flush=True)
            if not ok:
                compromised.append(f"kernel reproduction failed at {label}")

        # the exact-root branch, against O45's two refinement bases
        for m in (2, 3):
            rmx, Fm, bad = floors_root_of_two(m, V32)
            bm = mpf(2) ** (mpf(1) / m)
            s = scan(bm, rmx, Fm, PI, want_mass=True)
            p45 = per45.get(f"2**(1/{m})")
            ok = p45 is not None and (
                s["r_max"] == p45["r_max"]
                and s["cells"] == p45["n_cells_at_d_ge_1"]
                and s["r_thick"] == p45["r_thick"]
                and s["resolved"] == p45["n_resolved_cells"]
                and s["z_res"] == p45["n_exact_zeros_resolved"]) and bad == 0
            rm_float, _, _ = floors_real(bm, V32)
            kernel_check[f"2**(1/{m})"] = {
                "ours": {kk: s[kk] for kk in
                         ("r_max", "r_thick", "cells", "resolved",
                          "z_all", "z_res", "z_star")},
                "o45_r_max": (p45["r_max"] if p45 else None),
                "o45_z_res": (p45["n_exact_zeros_resolved"] if p45 else None),
                "mpmath_route_r_max": rm_float,
                "selfcheck_failures": bad, "matches": bool(ok)}
            print(f"  2^(1/{m}) @ V = 2^32, EXACT integer roots")
            print(f"    ours r_max {s['r_max']}  z_res {s['z_res']}   "
                  f"O45 r_max {p45['r_max'] if p45 else '-'}  z_res "
                  f"{p45['n_exact_zeros_resolved'] if p45 else '-'}   "
                  f"match: {'yes' if ok else 'NO'}")
            print(f"    the trap: the mpmath route at dps {DPS} would give "
                  f"r_max = {rm_float}")
            if not ok:
                compromised.append(f"kernel reproduction failed at 2^(1/{m})")

        # the trap, measured across the whole arm-2 family rather than cited
        print("  the exact-root trap across m = 2..8 at V = 2^32:")
        print(f"    {'m':>2} {'exact r_max':>12} {'mpmath r_max':>13} "
              f"{'interior floors differing':>26}")
        trap = []
        for m in ARM2_M:
            rme, Fe, _ = floors_root_of_two(m, V32)
            bm = mpf(2) ** (mpf(1) / m)
            rmf, Ff, _ = floors_real(bm, V32)
            nd = sum(1 for r in range(min(len(Fe), len(Ff)))
                     if Fe[r] != Ff[r])
            trap.append({"m": m, "exact_r_max": rme, "mpmath_r_max": rmf,
                         "interior_floors_differing": nd})
            print(f"    {m:>2} {rme:>12} {rmf:>13} {nd:>26}")
        kernel_check["exact_root_trap_at_2_32"] = trap
        print("    The trap is not only the top rung, and the pattern is not "
              "a simple")
        print("    function of m: r_max comes out short at m = 2, 5, 7 while "
              "at m = 4, 6, 8")
        print("    r_max agrees and interior rungs with m | r disagree "
              "instead. Which")
        print("    side the rounding falls on is decided by the rounding of "
              "2^(1/m) itself.")

    # ---------------- 3. arm 1: the plateau-constancy gate -------------------
    print("\n" + RULE)
    print("3. ARM 1 - THE PLATEAU-CONSTANCY GATE   (a varying denominator "
          "would invalidate the design)")
    print(RULE, flush=True)
    V, lo, hi = plateau_of(centre, PLATEAU_INDEX, PLATEAU_OFFSET)
    print(f"  log V                 : {mp.nstr(mplog(V), 20)}")
    print(f"  V                     : {float(V):.6e}  = 2^"
          f"{float(mplog(V) / mplog(2)):.6f}   (deliberately NOT 2^32)")
    print(f"  plateau r_max = {PLATEAU_INDEX}    : ({mp.nstr(lo, 12)}, "
          f"{mp.nstr(hi, 12)}]   width {float(hi - lo):.7f}")
    print(f"  centre offset in it   : "
          f"{float(centre - (lo + hi) / 2):+.3e}")
    print(f"  grid                  : {2 * GRID_PER_SIDE} bases, "
          f"{GRID_PER_SIDE} per side, spacing {GRID_SPACING}, half-window "
          f"{float(mpf(GRID_SPACING) * GRID_PER_SIDE):.4f}")

    grid = measure_window(centre, PI, want_detail=True) if pi_fn else \
        {"skip": "no pi backend"}
    if "skip" in grid:
        compromised.append(f"grid window rejected: {grid['skip']}")
        print(f"  GATE                  : FAIL - {grid['skip']}", flush=True)
    else:
        geo = tuple(grid["geometry"])
        gate_ok = (geo == LOCKED_GRID_GEOMETRY)
        print(f"  (r_max, r_thick, cells, resolved) on ALL "
              f"{2 * GRID_PER_SIDE} grid bases : {geo}")
        print(f"  locked                : {LOCKED_GRID_GEOMETRY}")
        print(f"  min rel gap to an integer : {grid['min_rel_gap']:.3e}  "
              f"(threshold {FLOOR_DETERMINACY:.0e})")
        print(f"  GATE                  : {'PASS' if gate_ok else 'FAIL'}",
              flush=True)
        if not gate_ok:
            compromised.append(
                f"plateau-constancy gate: grid geometry {geo} != locked "
                f"{LOCKED_GRID_GEOMETRY}")
        if grid["min_rel_gap"] is not None and \
                grid["min_rel_gap"] < FLOOR_DETERMINACY:
            compromised.append(
                f"floor determinacy on the grid: {grid['min_rel_gap']:.3e} < "
                f"{FLOOR_DETERMINACY:.0e}")

    # ---------------- 4. arm 1: the empirical null ---------------------------
    print("\n" + RULE)
    print("4. ARM 1 - THE EMPIRICAL NULL   (Poisson and binomial nulls are "
          "WRONG here and are not used)")
    print(RULE, flush=True)
    placebo, rejected = [], []
    if pi_fn is not None:
        for cs in PLACEBO_CENTRES:
            w = measure_window(mpf(cs), PI)
            if "skip" in w:
                rejected.append({"centre": cs, "why": w["skip"]})
            else:
                placebo.append(w)
    print(f"  locked placebo centres: {len(PLACEBO_CENTRES)} "
          f"(locked count {N_PLACEBO_LOCKED})")
    print(f"  evaluated             : {len(placebo)}   rejected by their own "
          f"geometry gate: {len(rejected)}")
    if len(PLACEBO_CENTRES) != N_PLACEBO_LOCKED:
        compromised.append(
            f"placebo list length {len(PLACEBO_CENTRES)} != locked "
            f"{N_PLACEBO_LOCKED}")
    if rejected:
        compromised.append(
            f"{len(rejected)} locked placebo centre(s) failed the geometry "
            f"gate at run time: {rejected[:3]}")
    for w in placebo:
        d, raw, tot = D_of(w["z_below"], w["z_above"])
        w["D"] = d
        w["raw"] = raw
        w["total"] = tot
    nullD = [w["D"] for w in placebo]
    if nullD:
        srt = sorted(nullD)
        mean = sum(nullD) / len(nullD)
        sd = (sum((x - mean) ** 2 for x in nullD) / len(nullD)) ** 0.5
        print(f"  placebo D             : mean {mean:+.4f}  median "
              f"{srt[len(srt) // 2]:+.4f}  sd {sd:.4f}  "
              f"min {srt[0]:+.4f}  max {srt[-1]:+.4f}")
        print(f"  the null is NOT centred at zero: the local trend in b is "
              f"real and the placebo set carries it")
        print(f"  order statistics the rank rule uses at alpha "
              f"{ALPHA_LEVEL}: 2nd smallest {srt[1]:+.4f}, 2nd largest "
              f"{srt[-2]:+.4f}")
        print(f"  mean total Z per window: "
              f"{sum(w['total'] for w in placebo) / len(placebo):.1f}")
    print("\n  POWER, measured before lock (seed "
          f"{POWER_SEED}, {POWER_REPS} draws per window per rho, "
          f"leave-one-out null):")
    print(f"    {'rho':>6} {'detect':>8}")
    for rho, det in POWER_TABLE:
        tag = "   <- calibration; rho = 1 is the identity" if rho == 1.0 else ""
        print(f"    {rho:>6.2f} {det:>8.3f}{tag}")
    power_rows = None
    if args.power_check:
        import random
        power_rows = power_check(placebo, random.Random(POWER_SEED))
        print("    recomputed this run:")
        for r in power_rows:
            flag = "" if abs(r["detect"] - r["locked"]) < 0.02 else "   DRIFT"
            print(f"    {r['rho']:>6.2f} {r['detect']:>8.3f}"
                  f"   (locked {r['locked']:.3f}){flag}")

    # ---------------- 5. arm 1: the measurement ------------------------------
    print("\n" + RULE)
    print("5. ARM 1 - THE MEASUREMENT")
    print(RULE, flush=True)
    D_obs = p_obs = None
    rot_p = None
    if "skip" not in grid:
        print(f"  {'side':>7} {'b':>14} {'z_res':>6}")
        for rec in grid["per_base"]:
            print(f"  {rec['side']:>7} {rec['b']:>14.7f} {rec['z_res']:>6}")
        D_obs, raw_obs, tot_obs = D_of(grid["z_below"], grid["z_above"])
        print(f"\n  Z_below (13 bases)    : {sum(grid['z_below'])}")
        print(f"  Z_above (13 bases)    : {sum(grid['z_above'])}")
        print(f"  raw difference        : {raw_obs:+d}")
        print(f"  D = (above-below)/total: {D_obs:+.6f}")
        print(f"  resolved cells / base : {grid['geometry'][3]}  (constant, "
              f"so no normalisation)")
        if nullD:
            p_obs = rank_p_two_sided(D_obs, nullD)
            below = sum(1 for x in nullD if x <= D_obs)
            above = sum(1 for x in nullD if x >= D_obs)
            print(f"  placebo D <= D_obs    : {below} of {len(nullD)}")
            print(f"  placebo D >= D_obs    : {above} of {len(nullD)}")
            print(f"  rank p (two-sided)    : {p_obs:.6f}   PRIMARY")
            rot = rotation_null(grid["z_below"], grid["z_above"])
            rot_p = rank_p_two_sided(D_obs, rot)
            print(f"  rotation p (25 rotations of this window's own "
                  f"sequence): {rot_p:.6f}")
            print("    SECONDARY, LABELLED, and it cannot move the label: a "
                  "real step inflates")
            print("    the rotation spread that would have to detect it, so "
                  "it is anti-conservative.")

    # ---------------- 6. arm 2 ----------------------------------------------
    print("\n" + RULE)
    print("6. ARM 2 - THE COMPANION.  AN ARITHMETIC QUESTION, NOT A NYQUIST "
          "ONE.")
    print(RULE, flush=True)
    print("  No verdict label reads this arm.  Its bases were partially")
    print("  inspected during feasibility work; see the prereg's provenance.")
    print(f"  ceiling V = {float(V):.6e} is generic, so ceiling attainment is")
    print("  broken by construction at every m.\n")
    arm2 = []
    if pi_fn is not None and "skip" not in grid:
        lV = mplog(V)
        print(f"  {'m':>2} {'b_m':>12} {'theta':>8} {'frac':>6} {'r_max':>6} "
              f"{'r_thick':>8} {'resolv':>7} {'z_res':>6} {'zeta_m':>9} "
              f"{'nbr mean':>9} {'nbr sd':>8} {'rank':>5} {'std dev':>8}")
        for m in ARM2_M:
            bm = mpf(2) ** (mpf(1) / m)
            n_m = int(mpfloor(lV / mplog(bm)))
            lo_m, hi_m = mpexp(lV / (n_m + 1)), mpexp(lV / n_m)
            delta = (hi_m - lo_m) / ARM2_DELTA_DIVISOR
            rmx, Fm, bad = floors_root_of_two(m, V)
            sm = scan(bm, rmx, Fm, PI, want_mass=True)
            if bad:
                compromised.append(
                    f"arm 2 exact-root self-check failed at m = {m}: {bad}")
            zeta_m = sm["z_res"] / sm["resolved"] if sm["resolved"] else None
            nb = []
            contained = True
            for j in list(range(-ARM2_NEIGHBOURS_PER_SIDE, 0)) + \
                    list(range(1, ARM2_NEIGHBOURS_PER_SIDE + 1)):
                b = bm + mpf(j) * delta
                if not (lo_m < b <= hi_m):
                    contained = False
                r_max, F, gap = floors_real(b, V)
                s = scan(b, r_max, F, PI)
                nb.append({"j": j, "b": float(b), "r_max": s["r_max"],
                           "r_thick": s["r_thick"], "resolved": s["resolved"],
                           "z_res": s["z_res"],
                           "zeta": (s["z_res"] / s["resolved"]
                                    if s["resolved"] else None),
                           "min_rel_gap": gap})
            zs = [x["zeta"] for x in nb]
            nmean = sum(zs) / len(zs)
            nsd = (sum((x - nmean) ** 2 for x in zs) / len(zs)) ** 0.5
            nmed = sorted(zs)[len(zs) // 2 - 1: len(zs) // 2 + 1]
            nmed = sum(nmed) / 2
            allz = sorted(zs + [zeta_m])
            rank = allz.index(zeta_m) + 1
            std = (zeta_m - nmean) / nsd if nsd else None
            theta = float(gamma1 * mplog(bm)) * 180.0 / math.pi
            frac = float(lV / mplog(bm)) % 1.0
            row = {"m": m, "b": float(bm), "b_str": mp.nstr(bm, 20),
                   "theta_deg": theta, "log_ratio_frac": frac,
                   "r_max": sm["r_max"], "r_thick": sm["r_thick"],
                   "resolved": sm["resolved"], "z_res": sm["z_res"],
                   "z_star": sm["z_star"], "zeta": zeta_m,
                   "neighbour_mean": nmean, "neighbour_sd": nsd,
                   "neighbour_median": nmed,
                   "rank_of_13": rank, "std_dev": std,
                   "below_neighbour_median": zeta_m < nmed,
                   "r_max_constant": all(x["r_max"] == n_m for x in nb),
                   "plateau_contained": contained,
                   "above_nyquist": theta > 180.0,
                   "neighbours": nb}
            arm2.append(row)
            print(f"  {m:>2} {float(bm):>12.7f} {theta:>8.2f} {frac:>6.3f} "
                  f"{sm['r_max']:>6} {sm['r_thick']:>8} {sm['resolved']:>7} "
                  f"{sm['z_res']:>6} {zeta_m:>9.5f} {nmean:>9.5f} "
                  f"{nsd:>8.5f} {rank:>2}/13 "
                  f"{('-' if std is None else f'{std:+8.2f}')}")
            if not contained or not row["r_max_constant"]:
                print(f"     NOTE m={m}: plateau_contained={contained}, "
                      f"r_max constant across neighbours="
                      f"{row['r_max_constant']}")

        k_low = sum(1 for r in arm2 if r["below_neighbour_median"])
        n_m_tot = len(arm2)
        p_bin = sum(math.comb(n_m_tot, i) for i in range(k_low + 1)) / \
            (2 ** n_m_tot)
        low_aliased = [r["m"] for r in arm2
                       if r["below_neighbour_median"] and r["above_nyquist"]]
        low_resolv = [r["m"] for r in arm2
                      if r["below_neighbour_median"] and not r["above_nyquist"]]
        print(f"\n  m with zeta below its neighbour median : {k_low} of "
              f"{n_m_tot}   (one-sided binomial p = {p_bin:.4f})")
        print(f"    of those, above the Nyquist boundary  : {low_aliased}")
        print(f"    of those, below it                    : {low_resolv}")
        print("\n  the three accounts, and what each predicts:")
        print("    (i)   Nyquist      -> only m = 2, 3 low")
        print("    (ii)  arithmetic   -> all seven low")
        print("    (iii) ceiling      -> none low (broken by the generic V)")
        if o45:
            per45 = {p["label"]: p for p in o45["summary"]["per_base"]}
            print("\n  for contrast, O45's published numbers at V = 2^32 "
                  "(where the ceiling IS attained):")
            for m in (2, 3):
                p45 = per45.get(f"2**(1/{m})")
                if p45:
                    print(f"    2^(1/{m}): log V / log b = "
                          f"{32.0 * m:.4f} exactly, z/resolved cell = "
                          f"{p45['zeros_per_resolved_cell']:.5f}")
    else:
        print("  skipped: no pi backend or the grid gate failed.")

    # ---------------- the predicate table ------------------------------------
    print("\n" + RULE)
    print("MECHANICAL DECISION-RULE OUTPUT (NOT A VERDICT)")
    print(RULE)

    fired_step_above = fired_step_below = fired_no_step = False
    if not compromised and p_obs is not None:
        sig = p_obs <= ALPHA_LEVEL
        med = sorted(nullD)[len(nullD) // 2]
        fired_step_above = bool(sig and D_obs > med)
        fired_step_below = bool(sig and D_obs < med)
        fired_no_step = bool(not sig)

    table = (
        ("compromised", bool(compromised)),
        ("step_above", fired_step_above),
        ("step_below", fired_step_below),
        ("no_step", fired_no_step),
        ("undetermined", True),          # residue: unconditionally true
    )
    non_residue = table[:-1]
    n_fired = sum(1 for _, p in non_residue if p)
    partition_ok = (n_fired == 1)
    if not partition_ok:
        compromised.append(
            f"decision_rule_partition_failed: {n_fired} non-residue "
            f"predicates fired, expected exactly 1")
        table = (("compromised", True),) + table[1:]
        non_residue = table[:-1]
        n_fired = sum(1 for _, p in non_residue if p)
    mech = next(lab for lab, pred in table if pred)

    print("  predicate table (evaluated in precedence order; the last row's")
    print("  predicate is the literal constant True, so the table is total):")
    for lab, pred in table:
        mark = "  <== selected" if lab == mech else ""
        print(f"    {lab:<14} {str(bool(pred)):<6}{mark}")
    print(f"  non-residue predicates that fired : {n_fired}")
    print(f"  assertion 'exactly one fires'     : "
          f"{'HELD' if partition_ok else 'FAILED - that is a finding'}")
    print(f"  precedence                        : {PRECEDENCE}")
    print()
    if D_obs is not None:
        print(f"  Z_below / Z_above                 : "
              f"{sum(grid['z_below'])} / {sum(grid['z_above'])}")
        print(f"  D                                 : {D_obs:+.6f}")
        print(f"  rank p (two-sided, PRIMARY)       : {p_obs:.6f}")
        print(f"  rotation p (SECONDARY, labelled)  : "
              f"{'-' if rot_p is None else f'{rot_p:.6f}'}")
    print(f"  alpha_level                       : {ALPHA_LEVEL} two-sided")
    print(f"  compromised conditions tripped    : "
          f"{compromised if compromised else '(none)'}")
    print(f"  label the decision rule selects   : {mech}")
    print()
    print("  The prereg states, before the run, that no mechanism predicts a")
    print("  step and that the expected outcome is `no_step`.")
    print("  This is the decision rule's mechanical output, NOT a verdict.")
    print("  The verdict line in the prereg's Run record is Julian's to "
          "write.", flush=True)

    ended = datetime.datetime.now(datetime.timezone.utc)

    if self_test:
        print("\n  SELF TEST: nothing written.", flush=True)
        return 0

    if not args.no_json:
        payload = {
            "schema_version": "1",
            "script": os.path.basename(__file__),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "gamma_1": GAMMA1_STR,
                "b_star": mp.nstr(bstar, 22),
                "plateau_index": PLATEAU_INDEX,
                "plateau_offset": PLATEAU_OFFSET,
                "value_ceiling": float(V),
                "value_ceiling_log2": float(mplog(V) / mplog(2)),
                "grid_per_side": GRID_PER_SIDE,
                "grid_spacing": GRID_SPACING,
                "locked_grid_geometry": list(LOCKED_GRID_GEOMETRY),
                "placebo_centres": list(PLACEBO_CENTRES),
                "n_placebo_locked": N_PLACEBO_LOCKED,
                "alpha_level": ALPHA_LEVEL,
                "dps": DPS, "d_min": D_MIN, "mass_floor": MASS_FLOOR,
                "floor_determinacy_threshold": FLOOR_DETERMINACY,
                "arm2_m": list(ARM2_M),
                "arm2_neighbours_per_side": ARM2_NEIGHBOURS_PER_SIDE,
                "arm2_delta_divisor": ARM2_DELTA_DIVISOR,
                "pi_backend": pi_name, "pi_backend_version": pi_ver,
                "n_distinct_pi_arguments": len(pi_cache),
                "cache": cache_path, "out": out_path,
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
                "statistic":
                    "D = (Z_above - Z_below) / (Z_above + Z_below), where "
                    "Z_side sums exact zeros in the resolved stratum "
                    "(r - d >= r_thick) over the 13 bases on that side. The "
                    "resolved-cell count is constant across the window by "
                    "construction, so zeros per resolved cell and zero "
                    "counts differ by a fixed factor and D is identical "
                    "under either. The ratio is the studentised form: "
                    "binomial thinning to half the count level moves the "
                    "null sd of the raw difference by -46.6%, of "
                    "(Zh-Zl)/sqrt(Zh+Zl) by -24.0%, and of D by +8.5%.",
                "null":
                    "EMPIRICAL. 116 locked placebo windows of matched "
                    "geometry, disjoint from the b* plateau. Zero counts are "
                    "strongly autocorrelated in b, so Poisson and binomial "
                    "nulls understate the spread by 2-6x in variance and are "
                    "NOT used anywhere in this test.",
                "p_rule":
                    "p = 2 * min(1 + #{D_i <= D_obs}, 1 + #{D_i >= D_obs}) / "
                    "(N + 1), capped at 1. Exactly valid under "
                    "exchangeability.",
                "rotation_null":
                    "SECONDARY and labelled. D over the 25 non-trivial "
                    "circular rotations of the window's own 26-base "
                    "sequence. It cannot move the label: a real step "
                    "inflates the rotation spread that would have to detect "
                    "it, so it is anti-conservative.",
                "no_mechanism":
                    "No mechanism predicts a step. The difference filter's "
                    "per-rung gain at gamma_1 is (2 sin(theta/2))^d, which "
                    "is smooth and stationary at theta = pi. The expected "
                    "outcome, stated before the run, is `no_step`.",
                "arm2":
                    "An ARITHMETIC question, not a Nyquist one, and it "
                    "carries no verdict label. 2^(1/m), m = 2..8, at a "
                    "generic ceiling so ceiling attainment is broken, each "
                    "against 12 local non-root neighbours in its own r_max "
                    "plateau. Nyquist predicts only m = 2, 3 low; "
                    "integer-root arithmetic predicts all seven; ceiling "
                    "attainment predicts none.",
                "verdict_labels": list(VERDICT_LABELS),
                "precedence": PRECEDENCE,
                "power_table": [{"rho": r, "detect": d} for r, d in POWER_TABLE],
                "power_seed": POWER_SEED,
                "randomness":
                    "none in the measurement. The power table was measured "
                    "before lock with seed 2026 and is a locked constant; "
                    "--power-check recomputes it and is off by default.",
            },
            "summary": {
                "pi_audit": audit,
                "kernel_verification": kernel_check,
                "grid": grid,
                "plateau_constancy_gate": {
                    "observed": (grid.get("geometry")),
                    "locked": list(LOCKED_GRID_GEOMETRY),
                    "pass": grid.get("geometry") == list(LOCKED_GRID_GEOMETRY),
                },
                "Z_below": (sum(grid["z_below"]) if "skip" not in grid else None),
                "Z_above": (sum(grid["z_above"]) if "skip" not in grid else None),
                "D": D_obs,
                "p_rank_two_sided": p_obs,
                "p_rotation_secondary": rot_p,
                "n_placebo_evaluated": len(placebo),
                "placebo_rejected": rejected,
                "placebo_D": nullD,
                "power_recomputed": power_rows,
                "arm2": arm2,
                "predicate_table": [{"label": l, "fired": bool(p)}
                                    for l, p in table],
                "predicate_partition_ok": partition_ok,
                "n_non_residue_fired": n_fired,
                "alpha_level": ALPHA_LEVEL,
                "compromised_conditions": compromised,
                "mechanical_decision_rule_output": mech,
                "verdict": None,
                "verdict_note":
                    "null by design. The verdict line is Julian's to write "
                    "in the prereg's Run record.",
            },
            "rows": [
                {"arm": 1, "kind": "grid", **rec}
                for rec in (grid.get("per_base") or [])
            ] + [
                {"arm": 1, "kind": "placebo", "b0": w["b0"], "D": w["D"],
                 "raw": w["raw"], "total": w["total"],
                 "z_below": w["z_below"], "z_above": w["z_above"]}
                for w in placebo
            ],
        }
        guarded_write(_jsonable(payload), out_path, allow_nan=False)

    print("\n" + RULE)
    print("READ THE RESULT")
    print(RULE)
    print("  Every floor, every W, every N and every table cell above is an")
    print("  exact Python integer. The seven integer-root bases use exact")
    print("  integer m-th roots and no floating point.")
    print("  The null is empirical and is not centred at zero: the local")
    print("  trend in b is real and the placebo windows carry it.")
    print("  Arm 2 is an arithmetic question and carries no verdict label.")
    print("  Nothing above is a verdict.")
    print(f"  finished (UTC): {ended.strftime('%Y-%m-%dT%H:%M:%SZ')}",
          flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
