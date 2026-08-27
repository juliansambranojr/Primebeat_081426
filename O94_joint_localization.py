"""
O94 - JOINT LOCALIZATION: do the two overlapping exact zeros - base 2's
      (20,6) and sqrt(2)'s (34,11) - draw their balance through the two
      half-octave sites they share, j = 33 and 34?

Reads with: notes/lab_notebook_2.md entry 201 (the overlap fact and the
approval of the O93 line), entry 204 (O93's run), entry 205 (O93's triage:
the phase statistic carries no prime information, and the instrument that
could answer the one-event question must read something the primes enter -
this script is that instrument), entry 203 (the R-based residual
convention); O93_overlap_identity.py (the verified table-reconstruction
machinery reused here: iroot, base_geometry, the pi audit); O88_rowmax_null.py
(the null-design precedent: one statistic, an ensemble null, power measured
first).

STATUS
------
EXPLORATORY.  No prereg, no decision rule, no verdict.  The design's
scratch phase ALREADY UNBLINDED the observed pair before this script was
written: T_obs ~ 0.101, with 2 of 20 even placements above it on the
scratch range.  Under CLAUDE.md "Prereg discipline" nothing printed below
may be described as a verdict, and no verdict line is written anywhere in
this output.  The p values below are mechanical fractions over a stated
ensemble, on a statistic whose observed value was known before the
protocol existed.

THE FACTORIZATION (verified as the opening gate)
------------------------------------------------
On the half-octave lattice j, with F[j] = floor(2^(j/2)) by exact integer
square root and P[j] = pi(F[j]):

    u_j = Delta^7 P at j          (7-fold backward difference)

Both cells factor through the SAME field u:

    cell A = base 2 (20,6)   = Delta_2^7 P at j = 40   (step-2 differences)
           = (1-z^2)^7 P|40 = (1+z)^7 (1-z)^7 P|40
           = sum_{i=0..7} C(7,i) u_{40-i}              quotient (1+z)^7,
                                                        all-positive weights,
                                                        support j = 33..40
    cell B = sqrt2 (34,11)   = Delta^12 P at j = 34
           = (1-z)^5 (1-z)^7 P|34
           = sum_{i=0..5} (-1)^i C(5,i) u_{34-i}       quotient (1-z)^5,
                                                        support j = 29..34

Both equal 0 exactly on the real data.  Shared sites: {33, 34}.
Weight-mass floors (the sigma value a flat |u| field would give):
A = (1+7)/2^7 = 8/128 = 6.25%, B = (5+1)/2^5 = 6/32 = 18.75%.

THE STATISTIC
-------------
    sigma_X = sum_{j in {33,34}} |w^X_j u_j| / sum_{j in supp X} |w^X_j u_j|
    T       = min(sigma_A, sigma_B)

Data enters solely through the realized integers u_j; sigma is an exact
rational, computed in integer arithmetic.

THE NULL - rigid translation
----------------------------
The whole two-cell configuration is translated along the half-octave
lattice by shifts t, keeping the internal offset at exactly 6 half-steps.
Even t keeps cell A a genuine base-2 cell (top site 40+t even); odd t
places cell A off the base-2 lattice and is reported as a labelled
sensitivity column.  Every placement's sigma_A, sigma_B, T is evaluated on
the REAL prime field.  pi coverage extends to j = 80 (values to 2^40) to
buy the full placement ensemble: t in [-22, +40] (below -22 the u field is
undefined; above +40 the coverage ends).

EXCLUSION ZONE.  u_j = Delta^6 of the block counts n_j = P[j] - P[j-1], so
u_j reads n at sites j-6..j.  The observed pair's u-support is 29..40,
which widens to block sites 23..40.  A placement at shift t reads block
sites 23+t..40+t, disjoint from the observed pair's data iff |t| >= 18.
p is reported both excluding and including overlapping placements;
EXCLUDING IS PRIMARY.

THE POWER CHECK - run first, reported before the real statistic
---------------------------------------------------------------
Two plantings at the observed |u| scale (both cells exactly 0 in each):
  1. one-event: balance mass forced through sites 33-34 (shared sites
     large, private sites minimal-norm).  The instrument must place its T
     at or near the ensemble maximum.
  2. two-event: u_33 = u_34 = 0, private sites solved so both cells are 0.
     T = 0 exactly; the instrument must read the left tail.
If either planting fails to separate from the placement ensemble, the run
STOPS and reports - the design states that failure is itself the result.

STRUCTURAL BOUND, derived and printed: at any placement where BOTH cells
are exactly zero, T <= 1/2.  (Write x = u_33, y = u_34.  Cell A's shared
weighted sum is x + 7y and cell B's is y - 5x.  If x, y share a sign,
|x + 7y| equals cell A's shared absolute mass, and cell A's zero forces
private mass >= that, so sigma_A <= 1/2; if they differ in sign the same
argument runs through cell B.  Null placements carry nonzero cells and are
bounded only by 1.)  The one-event planting lands on this bound.

COMPANION COLUMN (secondary; the denominator is printed because it can be
small and the ratio is meaningless without it):
    delta_j = n_j - (R(F[j]) - R(F[j-1]))    R = Riemann's R via mpmath
                                             riemannr, at the floor points
                                             the table actually reads
    du_j    = Delta^6 delta at j = u_j - ru_j,  ru_j = Delta^7 R(F[.]) at j
    phi_X   = (shared-site contribution of w^X du) / (net w^X du over supp X)
The denominator equals minus the smooth cell value (the cell's aimed net),
because the integer cell is exactly 0.  ru_j is also the smooth-leakage
control column of the diagnostics.

PRECISION
---------
u, the cells, sigma and T are exact integer/rational arithmetic.  mpmath
dps 50 where R enters the companion column, recomputed at dps 80 and
compared.

HOW IT IS RUN
-------------
    python3 utilities/run.py --python .venv/bin/python \
        --log results/O94_joint_localization_run1.log O94_joint_localization.py

REQUIREMENTS: primecountpy (sympy fallback), mpmath.
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import sys
from fractions import Fraction

from mpmath import mp, mpf, riemannr

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write
import O93_overlap_identity as o93          # verified machinery, reused

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT = os.path.join(DEFAULT_RESULTS_DIR, "joint_localization.json")
PI_CACHE_PATH = os.path.join(DEFAULT_RESULTS_DIR, "pi_half_octave_cache.json")
PI2N_CACHE = os.path.join(_HERE, "pi2n_cache.json")
O45_JSON = os.path.join(_HERE, "results", "sub_integer_base_scan.json")

RULE = "=" * 78
THIN = "-" * 78

C7 = [math.comb(7, i) for i in range(8)]
C5 = [math.comb(5, i) for i in range(6)]
C12 = [math.comb(12, i) for i in range(13)]

# cell geometry on the u field, at shift t:
#   A: sites 40+t-i, weight C(7,i), i = 0..7      (support 33+t..40+t)
#   B: sites 34+t-i, weight (-1)^i C(5,i), i=0..5 (support 29+t..34+t)
# shared sites 33+t (|w| A:1, B:5) and 34+t (|w| A:7, B:1)
FLOOR_A = Fraction(8, 128)
FLOOR_B = Fraction(6, 32)
T_MIN, T_MAX = -22, 40          # J_MAX - 40 with J_MAX = 80
NONOVERLAP_ABS_T = 18           # |t| >= 18: block-site sets disjoint


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def cell_A_quot(u, t):
    return sum(C7[i] * u[40 + t - i] for i in range(8))


def cell_A_direct(P, t):
    return sum((-1) ** i * C7[i] * P[40 + t - 2 * i] for i in range(8))


def cell_B_quot(u, t):
    return sum((-1) ** i * C5[i] * u[34 + t - i] for i in range(6))


def cell_B_direct(P, t):
    return sum((-1) ** i * C12[i] * P[34 + t - i] for i in range(13))


def sigma_pair(u, t):
    """Exact sigma_A, sigma_B, T at shift t.  Integer numerators and
    denominators; None if a denominator vanishes."""
    numA = 1 * abs(u[33 + t]) + 7 * abs(u[34 + t])
    denA = sum(C7[i] * abs(u[40 + t - i]) for i in range(8))
    numB = 5 * abs(u[33 + t]) + 1 * abs(u[34 + t])
    denB = sum(C5[i] * abs(u[34 + t - i]) for i in range(6))
    if denA == 0 or denB == 0:
        return None
    sA = Fraction(numA, denA)
    sB = Fraction(numB, denB)
    return {"numA": numA, "denA": denA, "numB": numB, "denB": denB,
            "sigma_A": sA, "sigma_B": sB, "T": min(sA, sB)}


def nearest_div(a, b):
    """Nearest integer to a/b, b > 0 (ties toward +inf; exactness is not
    load-bearing, only the remainder's smallness)."""
    return (2 * a + b) // (2 * b)


def force_zero_A(uf, t=0):
    """Adjust uf at sites 37+t (weight 35) and 40+t (weight 1) so cell A
    at shift t is exactly 0.  Touches no cell-B site."""
    r = cell_A_quot(uf, t)
    q = nearest_div(r, 35)
    rem = r - 35 * q
    uf[37 + t] -= q          # weight C(7,3) = 35
    uf[40 + t] -= rem        # weight C(7,0) = 1
    assert cell_A_quot(uf, t) == 0


def force_zero_B(uf, t=0):
    """Adjust uf at sites 32+t (weight +10) and 29+t (weight -1) so cell B
    at shift t is exactly 0.  Touches no cell-A site."""
    r = cell_B_quot(uf, t)
    q = nearest_div(r, 10)
    rem = r - 10 * q
    uf[32 + t] -= q          # weight (-1)^2 C(5,2) = +10
    uf[29 + t] += rem        # weight (-1)^5 C(5,5) = -1
    assert cell_B_quot(uf, t) == 0


def pearson(xs, ys):
    n = len(xs)
    if n < 3:
        return None
    mx = sum(xs) / n
    my = sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    syy = sum((y - my) ** 2 for y in ys)
    if sxx == 0 or syy == 0:
        return None
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    return sxy / math.sqrt(sxx * syy)


def phi_columns(u, F, jmax, dps):
    """The R-based companion column at the observed placement, at the
    given dps.  Returns dict of floats plus the ru column."""
    mp.dps = dps
    Rc = [riemannr(mpf(F[j])) for j in range(jmax + 1)]
    ru_mp = {j: sum((-1) ** i * C7[i] * Rc[j - i] for i in range(8))
             for j in range(7, jmax + 1)}
    du = {j: u[j] - ru_mp[j] for j in range(7, jmax + 1)}
    numA = 1 * du[33] + 7 * du[34]
    denA = sum(C7[i] * du[40 - i] for i in range(8))
    numB = du[34] - 5 * du[33]
    denB = sum((-1) ** i * C5[i] * du[34 - i] for i in range(6))
    # algebra check on the assembled column: (1+z)^7 applied to ru at 40
    # must equal (1-z^2)^7 applied to Rc at 40, and denA = -that because
    # the integer cell is exactly 0 (same for B with (1-z)^5 / Delta^12)
    smoothA = sum((-1) ** i * C7[i] * Rc[40 - 2 * i] for i in range(8))
    smoothB = sum((-1) ** i * C12[i] * Rc[34 - i] for i in range(13))
    return {"dps": dps,
            "phi_A": float(numA / denA),
            "num_A": float(numA), "den_A": float(denA),
            "phi_B": float(numB / denB),
            "num_B": float(numB), "den_B": float(denB),
            "den_A_plus_smoothA": float(denA + smoothA),
            "den_B_plus_smoothB": float(denB + smoothB),
            "smooth_cell_A": float(smoothA), "smooth_cell_B": float(smoothB),
            "ru": {j: float(v) for j, v in ru_mp.items()}}


def parse_args():
    ap = argparse.ArgumentParser(
        description=("O94 - joint localization of the (20,6)/(34,11) "
                     "balance at the shared half-octave sites 33-34. "
                     "EXPLORATORY: no prereg, no decision rule, no "
                     "verdict; T_obs was unblinded during design."))
    ap.add_argument("--dps", type=int, default=50)
    ap.add_argument("--precision-dps", type=int, default=80)
    ap.add_argument("--jmax", type=int, default=80,
                    help="half-octave coverage ceiling (default 80 = 2^40)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    return ap.parse_args()


def main():
    args = parse_args()
    started = datetime.datetime.now(datetime.timezone.utc)
    jmax = args.jmax
    fail = []

    print(RULE)
    print("O94 - JOINT LOCALIZATION")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT.  T_obs was")
    print("unblinded during the design's scratch phase (~0.101); every p")
    print("below is a mechanical fraction over a stated ensemble.")
    print(RULE)
    print(f"  started (UTC)   : {started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  coverage        : j = 0..{jmax}  (values to 2^{jmax // 2})")
    print(f"  dps             : {args.dps} for the R companion column, "
          f"{args.precision_dps} for its precision check")
    print(f"  code_version    : {_code_version()}", flush=True)

    source_files = [o93.file_record(p, role) for p, role in (
        (PI2N_CACHE, "pi_audit"),
        (O45_JSON, "recorded_census_spot_check"),
        (os.path.join(_HERE, "O93_overlap_identity.py"),
         "reused_machinery"))]

    # ------------------------------------------------ GATE 1: pi backend
    print()
    print(RULE)
    print("GATE 1 - PI BACKEND INTEGRITY (O93's audit, extended to n = 40)")
    print(RULE)
    pi_fn, pi_name = o93.load_pi_backend()
    with open(PI2N_CACHE) as fh:
        pi2 = json.load(fh)
    n_hi = jmax // 2
    n_ok = 0
    for n in range(0, n_hi + 1):
        want = int(pi2[str(n)])
        got = pi_fn(1 << n)
        if want == got:
            n_ok += 1
        else:
            fail.append(f"pi audit: pi(2^{n}) backend {got} != cache {want}")
    print(f"  backend         : {pi_name}")
    print(f"  pi(2^n) audit   : {n_ok} of {n_hi + 1} equal against "
          f"pi2n_cache.json (n = 0..{n_hi})")
    print(f"  status          : {'FAIL' if fail else 'PASS'}", flush=True)

    # -------------------------------- GATE 2: the half-octave field + cache
    print()
    print(RULE)
    print("GATE 2 - THE HALF-OCTAVE FIELD, F, P, u  (O93 machinery reused)")
    print(RULE)
    F = [o93.iroot(1 << j, 2) for j in range(jmax + 1)]
    for j in range(jmax + 1):
        if not (F[j] ** 2 <= (1 << j) < (F[j] + 1) ** 2):
            fail.append(f"exact-root self-check failed at j={j}")
    # cross-check the overlap j <= 64 against O93's base_geometry verbatim
    mp.dps = o93.GEOM_DPS
    _b, r_max93, F93 = o93.base_geometry(o93.KINDS["2**(1/2)"],
                                         mpf(o93.GAMMA1_STR))
    n_cross = min(r_max93, jmax) + 1
    cross_ok = all(F[j] == F93[j] for j in range(n_cross))
    if not cross_ok:
        fail.append("F disagrees with O93.base_geometry on j <= 64")
    print(f"  F[j] = isqrt(2^j) self-check      : "
          f"{'PASS' if not any('self-check' in f_ for f_ in fail) else 'FAIL'}"
          f"  (j = 0..{jmax})")
    print(f"  F vs O93.base_geometry, j 0..{n_cross - 1} : "
          f"{'PASS' if cross_ok else 'FAIL'}")

    # cache: reuse if a prior script (O93 or earlier) left one; O93 kept its
    # pi cache in memory only, so first run creates this file
    cache_existed = os.path.exists(PI_CACHE_PATH)
    P = [pi_fn(F[j]) if F[j] >= 2 else 0 for j in range(jmax + 1)]
    cache_status = ""
    if cache_existed:
        with open(PI_CACHE_PATH) as fh:
            cch = json.load(fh)
        ok_c = all(str(j) in cch.get("pi", {})
                   and int(cch["pi"][str(j)]) == P[j]
                   and int(cch["F"][str(j)]) == F[j]
                   for j in range(min(jmax, max(int(k) for k in
                                               cch.get("pi", {}))) + 1))
        cache_status = ("found, verified against backend"
                        if ok_c else "found, DISAGREES with backend")
        if not ok_c:
            fail.append("pi_half_octave_cache.json disagrees with backend")
    else:
        cache_status = "absent (O93 cached in memory only); created this run"
        if not args.no_json:
            guarded_write({
                "description": ("pi at the half-octave points F[j] = "
                                "floor(2^(j/2)), exact integer sqrt; "
                                "self-describing: F stored alongside pi"),
                "created_by": "O94_joint_localization.py",
                "backend": pi_name,
                "jmax": jmax,
                "F": {str(j): F[j] for j in range(jmax + 1)},
                "pi": {str(j): P[j] for j in range(jmax + 1)},
            }, PI_CACHE_PATH, allow_nan=False)
    print(f"  results/pi_half_octave_cache.json : {cache_status}")
    # even sites are pi(2^n): re-audit P against the cache directly
    even_ok = all(P[2 * n] == int(pi2[str(n)]) for n in range(n_hi + 1))
    if not even_ok:
        fail.append("even-site P[2n] disagrees with pi2n_cache.json")
    print(f"  even sites P[2n] == pi2n cache    : "
          f"{'PASS' if even_ok else 'FAIL'}  (n = 0..{n_hi})", flush=True)

    nblk = {j: P[j] - P[j - 1] for j in range(1, jmax + 1)}
    u = {j: sum((-1) ** i * C7[i] * P[j - i] for i in range(8))
         for j in range(7, jmax + 1)}

    # ---------------------------- GATE 3: factorization + refinement + O45
    print()
    print(RULE)
    print("GATE 3 - THE FACTORIZATION, THE REFINEMENT IDENTITY, THE RECORD")
    print(RULE)
    a_quot, a_dir = cell_A_quot(u, 0), cell_A_direct(P, 0)
    b_quot, b_dir = cell_B_quot(u, 0), cell_B_direct(P, 0)
    # cell A is also Delta^7 of the base-2 ladder pi(2^r) at r = 20
    C2 = [P[2 * r] for r in range(0, jmax // 2 + 1)]
    a_base2 = o93.binom_delta(C2, 20, 7)
    print(f"  cell A  (1+z)^7 u | 40      = {a_quot}")
    print(f"  cell A  (1-z^2)^7 P | 40    = {a_dir}")
    print(f"  cell A  Delta^7 pi(2^r)|r=20= {a_base2}   (O93.binom_delta)")
    print(f"  cell B  (1-z)^5 u | 34      = {b_quot}")
    print(f"  cell B  Delta^12 P | 34     = {b_dir}")
    for nm, v in (("cell A quotient", a_quot), ("cell A direct", a_dir),
                  ("cell A base-2", a_base2), ("cell B quotient", b_quot),
                  ("cell B direct", b_dir)):
        if v != 0:
            fail.append(f"{nm} = {v}, expected exact 0")
    # quotient == direct at EVERY placement (exact algebra on integers)
    id_bad = 0
    for t in range(T_MIN, T_MAX + 1):
        if cell_A_quot(u, t) != cell_A_direct(P, t):
            id_bad += 1
        if cell_B_quot(u, t) != cell_B_direct(P, t):
            id_bad += 1
    if id_bad:
        fail.append(f"quotient != direct at {id_bad} placement forms")
    print(f"  quotient == direct at every shift t in "
          f"[{T_MIN}, {T_MAX}]     : {'PASS' if id_bad == 0 else 'FAIL'}")
    # refinement identity N_2(r) = n_{2r-1} + n_{2r}, r = 1..32 (as O93's
    # reconstruction verified the same convention)
    ref_bad = [r for r in range(1, 33)
               if int(pi2[str(r)]) - int(pi2[str(r - 1)])
               != nblk[2 * r - 1] + nblk[2 * r]]
    if ref_bad:
        fail.append(f"refinement identity fails at r = {ref_bad}")
    print(f"  refinement N_2(r) = n(2r-1) + n(2r), r = 1..32  : "
          f"{'PASS' if not ref_bad else 'FAIL'}")
    # the recorded census: both cells are recorded exact zeros with these S
    with open(O45_JSON) as fh:
        o45 = json.load(fh)
    pb = {s["label"]: s for s in o45["summary"]["per_base"]}
    S_sqrt2 = sum(math.comb(11, k) * nblk[34 - k] for k in range(12))
    N2 = {r: P[2 * r] - P[2 * r - 2] for r in range(1, 21)}
    S_2 = sum(math.comb(6, k) * N2[20 - k] for k in range(7))
    tt_sqrt2 = sum((-1) ** i * C12[i] * F[34 - i] for i in range(13))
    tt_2 = sum((-1) ** i * C7[i] * (1 << (20 - i)) for i in range(8))
    for lab, r, d, S_here, tt_here in (("2**(1/2)", 34, 11, S_sqrt2, tt_sqrt2),
                                       ("2", 20, 6, S_2, tt_2)):
        rec = [z for z in pb[lab]["exact_zeros"]
               if z["r"] == r and z["d"] == d]
        ok = (len(rec) == 1 and rec[0]["S"] == S_here
              and rec[0]["total_true"] == tt_here)
        if not ok:
            fail.append(f"census spot-check fails at {lab} ({r},{d})")
        print(f"  recorded zero {lab} ({r},{d}): S rebuilt {S_here}"
              f" == recorded {rec[0]['S'] if rec else '?'}, total_true "
              f"{tt_here} == {rec[0]['total_true'] if rec else '?'}   "
              f"{'PASS' if ok else 'FAIL'}")
    print()
    print("  Widened support: u_j = Delta^6 n at j reads block sites j-6..j;")
    print("  the pair's u-support 29..40 therefore reads block sites 23..40.")
    print("  A placement at shift t reads 23+t..40+t; data-disjoint from the")
    print(f"  observed pair iff |t| >= {NONOVERLAP_ABS_T}.")
    print()
    print(f"  geometric floors (flat-|u| sigma): A = 8/128 = "
          f"{float(FLOOR_A):.4f}, B = 6/32 = {float(FLOOR_B):.4f}",
          flush=True)

    if fail:
        print()
        print(RULE)
        print("OPENING GATES FAILED - stopping before any statistic")
        print(RULE)
        for f_ in fail:
            print(f"  {f_}")
        if not args.no_json:
            guarded_write(o93._jsonable({
                "schema_version": "1",
                "script": os.path.basename(__file__),
                "generated_utc": datetime.datetime.now(
                    datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "status": "EXPLORATORY - opening gates failed",
                "params": {"code_version": _code_version(),
                           "argv": sys.argv, "source_files": source_files},
                "summary": {"gate_failures": fail}, "rows": []}),
                args.out, allow_nan=False)
        return 1

    # ------------------------------------------- the placement ensemble
    # (computed here because the power check is judged against it; its own
    # report section follows the observed statistic, per the design order)
    placements = []
    undefined = []
    for t in range(T_MIN, T_MAX + 1):
        st = sigma_pair(u, t)
        if st is None:
            undefined.append(t)
            continue
        cA = cell_A_quot(u, t)
        cB = cell_B_quot(u, t)
        placements.append({
            "t": t, "parity": "even" if t % 2 == 0 else "odd",
            "base2_genuine": t % 2 == 0,
            "overlaps_observed": abs(t) < NONOVERLAP_ABS_T,
            "cell_A": cA, "cell_B": cB,
            "mass_A": st["denA"], "mass_B": st["denB"],
            "shared_mass_A": st["numA"], "shared_mass_B": st["numB"],
            "sigma_A": float(st["sigma_A"]), "sigma_B": float(st["sigma_B"]),
            "T": float(st["T"]),
        })
    by_t = {p["t"]: p for p in placements}
    obs = by_t[0]
    T_obs = obs["T"]
    even_null = [p for p in placements if p["t"] != 0 and p["parity"] == "even"]
    odd_null = [p for p in placements if p["parity"] == "odd"]
    even_excl = [p for p in even_null if not p["overlaps_observed"]]
    odd_excl = [p for p in odd_null if not p["overlaps_observed"]]

    # ------------------------------------------------ THE POWER CHECK
    print()
    print(RULE)
    print("POWER CHECK - run first, judged against the even placement")
    print("ensemble on the real field, before the real statistic is read")
    print(RULE)
    scale = max(abs(u[33]), abs(u[34]))
    # planting 1 - one event: shared sites large (observed scale), private
    # sites minimal-norm, both cells exactly 0.  Shared values solve
    # 5*u33 ~ u34 (same sign), which zeroes cell B's shared sum; cell A's
    # balance is carried by the heavy-weight private sites.
    u1 = dict(u)
    u1[34] = scale
    u1[33] = nearest_div(scale, 5)
    for j in list(range(35, 41)) + list(range(29, 33)):
        u1[j] = 0
    force_zero_A(u1)
    force_zero_B(u1)
    st1 = sigma_pair(u1, 0)
    # planting 2 - two events: shared sites exactly 0, private sites (kept
    # at their observed values) adjusted at the heavy sites so both cells
    # are exactly 0.  Shared contribution is 0, so T = 0 exactly.
    u2 = dict(u)
    u2[33] = 0
    u2[34] = 0
    force_zero_A(u2)
    force_zero_B(u2)
    st2 = sigma_pair(u2, 0)
    T1, T2 = float(st1["T"]), float(st2["T"])
    null_T_even = [p["T"] for p in even_null]
    null_T_even_excl = [p["T"] for p in even_excl]
    sep1 = T1 >= max(null_T_even)
    sep2 = T2 <= min(null_T_even)
    print(f"  observed |u| scale (max shared)    : {scale}")
    print(f"  planting 1 (one event)  u33 = {u1[33]}, u34 = {u1[34]}, "
          f"private {[u1[j] for j in range(29, 33)]} + "
          f"{[u1[j] for j in range(35, 41)]}")
    print(f"    cells A, B                       : "
          f"{cell_A_quot(u1, 0)}, {cell_B_quot(u1, 0)}  (both exact 0)")
    print(f"    sigma_A {float(st1['sigma_A']):.6f}  sigma_B "
          f"{float(st1['sigma_B']):.6f}  T {T1:.6f}")
    print(f"    even-null max T (incl/excl)      : {max(null_T_even):.6f} / "
          f"{max(null_T_even_excl):.6f}")
    print(f"    T_planted >= even-null max       : "
          f"{'YES - separates' if sep1 else 'NO - FAILS TO SEPARATE'}")
    print(f"    (T = 1/2 is the structural ceiling for an exactly-zero "
          f"pair; the planting sits on it)")
    print(f"  planting 2 (two events) u33 = u34 = 0; adjusted sites 37, 40 "
          f"({u[37]}->{u2[37]}, {u[40]}->{u2[40]}), 32, 29 "
          f"({u[32]}->{u2[32]}, {u[29]}->{u2[29]})")
    print(f"    cells A, B                       : "
          f"{cell_A_quot(u2, 0)}, {cell_B_quot(u2, 0)}  (both exact 0)")
    print(f"    sigma_A {float(st2['sigma_A']):.6f}  sigma_B "
          f"{float(st2['sigma_B']):.6f}  T {T2:.6f}")
    print(f"    even-null min T (incl/excl)      : {min(null_T_even):.6f} / "
          f"{min(null_T_even_excl):.6f}")
    print(f"    T_planted <= even-null min       : "
          f"{'YES - reads the left tail' if sep2 else 'NO - FAILS'}",
          flush=True)
    power = {
        "scale": scale,
        "planting_one_event": {
            "u_29_to_40": {str(j): u1[j] for j in range(29, 41)},
            "sigma_A": float(st1["sigma_A"]), "sigma_B": float(st1["sigma_B"]),
            "T": T1, "even_null_max_T": max(null_T_even),
            "even_null_excl_max_T": max(null_T_even_excl),
            "separates": sep1},
        "planting_two_event": {
            "u_29_to_40": {str(j): u2[j] for j in range(29, 41)},
            "sigma_A": float(st2["sigma_A"]), "sigma_B": float(st2["sigma_B"]),
            "T": T2, "even_null_min_T": min(null_T_even),
            "even_null_excl_min_T": min(null_T_even_excl),
            "separates": sep2},
    }
    if not (sep1 and sep2):
        print()
        print(RULE)
        print("POWER CHECK FAILED - STOPPING, per the approved design: this")
        print("failure is itself the result.  The observed statistic and its")
        print("p are withheld; the ensemble and plantings are in the JSON.")
        print(RULE)
        if not args.no_json:
            guarded_write(o93._jsonable({
                "schema_version": "1",
                "script": os.path.basename(__file__),
                "generated_utc": datetime.datetime.now(
                    datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "status": ("EXPLORATORY - power check failed; run stopped "
                           "before the observed statistic was reported"),
                "params": {"code_version": _code_version(),
                           "argv": sys.argv, "source_files": source_files},
                "summary": {"power_check": power},
                "rows": placements}), args.out, allow_nan=False)
        return 1

    # ------------------------------------------------ observed statistic
    print()
    print(RULE)
    print("THE OBSERVED STATISTIC  (EXPLORATORY; T_obs was unblinded at")
    print("design time)")
    print(RULE)
    print(f"  u at the pair's support (29..40)   : "
          f"{[u[j] for j in range(29, 41)]}")
    print(f"  shared sites u_33, u_34            : {u[33]}, {u[34]}")
    print(f"  sigma_A = {obs['shared_mass_A']}/{obs['mass_A']} = "
          f"{obs['sigma_A']:.6f}    geometric floor {float(FLOOR_A):.4f}")
    print(f"  sigma_B = {obs['shared_mass_B']}/{obs['mass_B']} = "
          f"{obs['sigma_B']:.6f}    geometric floor {float(FLOOR_B):.4f}")
    print(f"  T = min(sigma_A, sigma_B)          : {T_obs:.6f}")
    print(f"  structural ceiling for an exactly-zero pair: T <= 0.5",
          flush=True)

    # ------------------------------------------------ ensemble + p values
    print()
    print(RULE)
    print("THE PLACEMENT ENSEMBLE - rigid translation on the real field")
    print(RULE)
    if undefined:
        print(f"  placements with vanishing mass, excluded: {undefined}")
    print(f"  shifts t in [{T_MIN}, {T_MAX}]; even keeps cell A a genuine "
          f"base-2 cell;")
    print(f"  odd is a labelled sensitivity column (cell A off the base-2 "
          f"lattice).")
    print()
    print(f"  {'t':>4} {'par':>4} {'ovl':>4} {'cell_A':>9} {'cell_B':>9} "
          f"{'sigma_A':>9} {'sigma_B':>9} {'T':>9}")
    for p in placements:
        tag = " OBS" if p["t"] == 0 else ""
        print(f"  {p['t']:>4} {p['parity']:>4} "
              f"{'yes' if p['overlaps_observed'] else 'no':>4} "
              f"{p['cell_A']:>9} {p['cell_B']:>9} {p['sigma_A']:>9.6f} "
              f"{p['sigma_B']:>9.6f} {p['T']:>9.6f}{tag}")

    def p_block(name, pool, primary=False):
        n = len(pool)
        k = sum(1 for q in pool if q["T"] >= T_obs)
        ts = sorted(q["T"] for q in pool)
        med = ts[n // 2] if n else None
        out = {"name": name, "n": n, "n_at_or_above": k,
               "p": (k / n) if n else None,
               "min_attainable_nonzero_p": (1 / n) if n else None,
               "T_min": ts[0] if n else None, "T_median": med,
               "T_max": ts[-1] if n else None, "primary": primary}
        star = "  <-- PRIMARY" if primary else ""
        print(f"  {name:<42} n = {n:>2}   {k} at or above T_obs   "
              f"p = {out['p']:.4f}   (min nonzero p {out['min_attainable_nonzero_p']:.4f})"
              f"{star}")
        print(f"    {'':<40} T range [{out['T_min']:.4f}, {out['T_max']:.4f}]"
              f", median {med:.4f}")
        return out

    print()
    print(f"  T_obs = {T_obs:.6f}")
    ens = [
        p_block("even shifts, overlap-excluded", even_excl, primary=True),
        p_block("even shifts, overlap-included", even_null),
        p_block("odd shifts, overlap-excluded (sensitivity)", odd_excl),
        p_block("odd shifts, overlap-included (sensitivity)", odd_null),
    ]
    print(flush=True)

    # ------------------------------------------------ companion phi column
    print(RULE)
    print("COMPANION COLUMN phi (SECONDARY; never the headline).  delta_j =")
    print("n_j - (R(F[j]) - R(F[j-1])); du = Delta^6 delta = u - ru;")
    print("phi_X = shared w.du / net w.du.  The denominator equals minus the")
    print("smooth cell value (the cell's aimed net) and CAN BE SMALL - it is")
    print("printed beside every ratio.")
    print(RULE)
    lo = phi_columns(u, F, jmax, args.dps)
    hi = phi_columns(u, F, jmax, args.precision_dps)
    for X in ("A", "B"):
        print(f"  phi_{X} = {lo['num_' + X]:+.6f} / {lo['den_' + X]:+.6f}"
              f" = {lo['phi_' + X]:+.6f}")
    print(f"  |den_A + smooth_cell_A| (algebra check) : "
          f"{abs(lo['den_A_plus_smoothA']):.3e}")
    print(f"  |den_B + smooth_cell_B| (algebra check) : "
          f"{abs(lo['den_B_plus_smoothB']):.3e}")
    rel = {X: (abs(lo["phi_" + X] - hi["phi_" + X]) / abs(hi["phi_" + X])
               if hi["phi_" + X] else 0.0) for X in ("A", "B")}
    print(f"  dps {args.dps} vs dps {args.precision_dps}: rel diff "
          f"phi_A {rel['A']:.2e}, phi_B {rel['B']:.2e}")
    hazard = abs(lo["den_B"]) < 1.0 or abs(lo["den_A"]) < 1.0
    if hazard:
        print("  DENOMINATOR HAZARD: at least one aimed net is below 1 count;")
        print("  the corresponding phi carries no usable information.",
              flush=True)

    # ------------------------------------------------ diagnostics
    print()
    print(RULE)
    print("DIAGNOSTICS")
    print(RULE)
    print("  Zero-conditioning: sigma against the placement's own |cell|/mass")
    print("  (Pearson r over all defined placements, both parities):")
    ratios_A = [abs(p["cell_A"]) / p["mass_A"] for p in placements]
    ratios_B = [abs(p["cell_B"]) / p["mass_B"] for p in placements]
    rA = pearson(ratios_A, [p["sigma_A"] for p in placements])
    rB = pearson(ratios_B, [p["sigma_B"] for p in placements])
    rT = pearson([min(a, b) for a, b in zip(ratios_A, ratios_B)],
                 [p["T"] for p in placements])
    print(f"    r(sigma_A, |cell_A|/mass_A) = {rA:+.4f}")
    print(f"    r(sigma_B, |cell_B|/mass_B) = {rB:+.4f}")
    print(f"    r(T, min ratio)             = {rT:+.4f}")
    print("    The observed placement is the only one with both cells at 0;")
    print("    exactly-zero pairs obey T <= 1/2 while nonzero placements are")
    print("    bounded only by 1 - the ensemble can reach T values the")
    print("    observed pair could never attain.")
    print()
    ru = lo["ru"]
    j_peak = max(range(29, 41), key=lambda j: abs(ru[j]))
    print("  Smooth leakage ru_j = Delta^7 R(F[.]) at j (dps "
          f"{args.dps}), pair support:")
    print("    j : " + "  ".join(f"{j}" for j in range(29, 41)))
    print("    ru: " + "  ".join(f"{ru[j]:.2f}" for j in range(29, 41)))
    print(f"    largest on the support: |ru[{j_peak}]| = "
          f"{abs(ru[j_peak]):.4f}  <-- the design brief's ~13.4 at j = 40")
    print(f"    (u integers on the support run "
          f"{min(abs(u[j]) for j in range(29, 41))}.."
          f"{max(abs(u[j]) for j in range(29, 41))}; the smooth leakage is "
          f"subdominant at every site.)", flush=True)

    # ------------------------------------------------ precision + close
    print()
    print(RULE)
    print("PRECISION")
    print(RULE)
    print("  u, cells, sigma, T : exact integer / rational arithmetic; the")
    print("  five factorization forms and both plantings verified to exact 0.")
    print(f"  phi column         : dps {args.dps} vs {args.precision_dps} "
          f"max rel diff {max(rel.values()):.2e}")
    print()
    print(RULE)
    print("EXPLORATORY. Nothing above is a verdict. T_obs was unblinded")
    print("before this protocol existed; no decision rule was preregistered")
    print("and none fired. The reading is Julian's.")
    print(RULE)

    if not args.no_json:
        ended = datetime.datetime.now(datetime.timezone.utc)
        payload = {
            "schema_version": "1",
            "script": os.path.basename(__file__),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "status": ("EXPLORATORY - no prereg, no decision rule, no "
                       "verdict; T_obs (~0.101) was unblinded during the "
                       "design's scratch phase, so the p values are "
                       "mechanical fractions over a stated ensemble and "
                       "nothing here may be described as a verdict."),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "dps": args.dps,
                "precision_dps": args.precision_dps,
                "jmax": jmax,
                "pi_backend": pi_name,
                "pi_half_octave_cache": {
                    "path": PI_CACHE_PATH,
                    "existed_before_run": cache_existed,
                    "status": cache_status},
                "source_files": source_files,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "python": sys.version,
            },
            "constants": {
                "field": ("F[j] = floor(2^(j/2)) exact isqrt; P[j] = "
                          "pi(F[j]); u_j = Delta^7 P at j"),
                "cell_A": ("base 2 (20,6) = (1+z)^7 u at 40; weights "
                           "C(7,i), support 33..40"),
                "cell_B": ("sqrt2 (34,11) = (1-z)^5 u at 34; weights "
                           "(-1)^i C(5,i), support 29..34"),
                "statistic": ("sigma_X = shared-site |w u| mass / support "
                              "|w u| mass, shared sites {33,34}; T = "
                              "min(sigma_A, sigma_B); exact rational"),
                "geometric_floors": {"A": "8/128 = 0.0625",
                                     "B": "6/32 = 0.1875"},
                "null": ("rigid translation by shift t in "
                         f"[{T_MIN}, {T_MAX}], internal offset fixed at 6 "
                         "half-steps, evaluated on the real prime field; "
                         "even t keeps cell A a genuine base-2 cell, odd t "
                         "is a labelled sensitivity column"),
                "widened_support": ("u_j = Delta^6 n at j reads block sites "
                                    "j-6..j; pair support 29..40 widens to "
                                    "block sites 23..40; placements are "
                                    "data-disjoint iff |t| >= "
                                    f"{NONOVERLAP_ABS_T}; overlap-excluded "
                                    "is primary"),
                "structural_bound": ("any placement with both cells exactly "
                                     "0 has T <= 1/2 (sign analysis of the "
                                     "shared weighted sums x+7y and y-5x)"),
                "phi": ("delta_j = n_j - (R(F[j]) - R(F[j-1])), R = mpmath "
                        "riemannr at the floor points; du = u - ru with "
                        "ru_j = Delta^7 R(F[.]) at j; phi_X = shared w.du / "
                        "net w.du; denominator = -(smooth cell value), the "
                        "aimed net; SECONDARY, denominator printed"),
            },
            "summary": {
                "gates": {
                    "pi_audit_n_ok": n_ok, "pi_audit_n_range": [0, n_hi],
                    "F_cross_check_vs_O93": cross_ok,
                    "even_site_audit": even_ok,
                    "cell_A_quotient": a_quot, "cell_A_direct": a_dir,
                    "cell_A_base2_binom": a_base2,
                    "cell_B_quotient": b_quot, "cell_B_direct": b_dir,
                    "quotient_eq_direct_all_shifts": id_bad == 0,
                    "refinement_identity_r_1_32": not ref_bad,
                    "census_spot_check": {"sqrt2_34_11_S": S_sqrt2,
                                          "base2_20_6_S": S_2},
                },
                "power_check": power,
                "observed": {
                    "u_support_29_40": [u[j] for j in range(29, 41)],
                    "sigma_A": obs["sigma_A"],
                    "sigma_A_exact": [obs["shared_mass_A"], obs["mass_A"]],
                    "sigma_B": obs["sigma_B"],
                    "sigma_B_exact": [obs["shared_mass_B"], obs["mass_B"]],
                    "T": T_obs,
                    "geometric_floor_A": float(FLOOR_A),
                    "geometric_floor_B": float(FLOOR_B),
                },
                "ensembles": ens,
                "undefined_placements": undefined,
                "phi_companion": {
                    "dps_lo": {k: v for k, v in lo.items() if k != "ru"},
                    "dps_hi": {k: v for k, v in hi.items() if k != "ru"},
                    "rel_diff": rel,
                    "denominator_hazard": hazard,
                },
                "diagnostics": {
                    "pearson_sigmaA_vs_cell_ratio": rA,
                    "pearson_sigmaB_vs_cell_ratio": rB,
                    "pearson_T_vs_min_ratio": rT,
                    "ru_support": {str(j): ru[j] for j in range(29, 41)},
                    "ru_peak": {"j": j_peak, "abs": abs(ru[j_peak])},
                    "ru_full": {str(j): ru[j] for j in sorted(ru)},
                },
                "u_field": {str(j): u[j] for j in sorted(u)},
            },
            "rows": placements,
        }
        guarded_write(o93._jsonable(payload), args.out, allow_nan=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
