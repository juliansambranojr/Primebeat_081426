"""
O92 - CERTIFICATION COST at the table's cells: the minimum number of zero
      pairs K such that the K-mode explicit-formula model pins cell (r,d)
      to within +-0.5 -- i.e. certifies the integer.

Reads with: notes/lab_notebook_2.md entry 201 (the approval and the prediction
this instrument tests), entry 192 (the Delta^(d+1) index correction, honored
and gated below), entries 193/194 (O90's run and its reading);
O90_mode_coherence.py (the psi- and pi-form mode construction, imported rather
than re-derived, exactly as O91 imports it); O34_zeta_residual_model.py (the
pi-form model and the main-term convention this matches); O25 (the
rate/distortion economics on pi(x) itself, which this asks at the cells).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis locked in advance, no decision rule, no
verdict.  Per `CLAUDE.md` "Prereg discipline", nothing this script prints may
be described as a verdict, and no verdict line is written anywhere in its
output.

THE QUESTION
------------
Entry 201, approved instrument 1: for each cell, the minimum K such that the
K-zero model pins Delta^(d+1) pi(2^.) to within +-0.5.  O34's sign-flip at
(25,21) predicts K blows up with depth; a bounded K at (20,6) falsifies entry
201's inference 2 ("the certification arrow runs from arithmetic to
spectrum").  Either outcome is informative and neither is shaded toward.

THE MODEL
---------
The model value of cell (r,d) is

    model_K(r,d) = M(r,d) + S_K(r,d)

  M(r,d)    the smooth-stencil main term: Delta^(d+1) applied to R(2^.) at
            r, R = Riemann's function -- O34's measured convention; the
            li-stencil is carried as a comparison.  See MAIN-TERM CONVENTION.
  S_K(r,d)  the partial sum over the first K zero pairs of the pi-form mode
            contributions c_k, exactly as O90's PiModes builds them:
            c_k = -2 Re[ sum_j (-1)^j C(d+1,j) Ei(rho_k*(r-j)*ln2) ].

CERTIFIED at K means |model_K - cell_true| < 0.5, where cell_true is the exact
integer Delta^(d+1) backward difference of pi(2^m) from pi2n_cache.json.

  K_first   the smallest K <= 600 with |err| < 0.5 (first touch)
  K_stable  the smallest K <= 600 with |err| < 0.5 for ALL K' in [K, 600]
            -- a transient dip below 0.5 that pops back out is NOT
            certification; both are reported and a difference is flagged
  UNCERTIFIED at 600 when |err(600)| >= 0.5, with the terminal |err|.

K = 0 (main term alone certifies) is allowed and reported as such.

THE STENCIL INDEX, gated before anything else
---------------------------------------------
Entry 192's correction: `Zeros.dyadicRow` is already one backward difference,
so cell (r,d) is Delta^(d+1) of pi(2^.) at r -- the exponent is d+1, never d.
The FIRST thing this script prints is the six-kernel-value gate: the
Delta^(d+1) column must reproduce (2,1)=0, (4,1)=0, (8,3)=0, (20,6)=0,
(7,3)=5, (19,6)=343 from pi2n_cache.json, and the Delta^d column is printed
alongside to show it reproduces none of them.  On any mismatch the script
exits non-zero and computes nothing further.

MAIN-TERM CONVENTION, adopted and stated -- and it is R, measured, not li
-------------------------------------------------------------------------
O34's main-term handling was read AND measured before this convention was
chosen.  O34 computes no main term in code; its residual object is the
TRUE_RES_R20 literal list.  Recomputing the r = 20 residual ladder both ways
against pi2n_cache.json settles which stencil those literals are:

    d    cell - Delta^(d+1) R      cell - Delta^(d+1) li     O34 literal
    0            -24.8864789               -48.7162517         -24.886
    1            -48.1900915               -54.0979638         -48.190
    2            -82.0861475               -83.605663          -82.086
    6           -453.42419                -453.431918         -453.424

The R-stencil (Riemann's function, mpmath's riemannr) reproduces every O34
literal to its full printed precision; the li-stencil reproduces none of the
first three depths, and the li-minus-R column decays ~3.5-4x per depth --
O29's measured li-vs-R gap profile.  This is also what the mathematics says
the Ei modes target: osc(x) = -sum 2*Re(li(x^rho)) is the oscillating part
of Riemann's J-expansion whose smooth part is R(x) = sum mu(n)/n li(x^(1/n)),
so pairing the modes with the li-stencil leaves the li - R gap as an
unmodeled floor NO number of zeros removes -- 23.8 at (20,0), 5.9 at (20,1),
each far above the 0.5 criterion, 0.008 at (20,6) where it is immaterial.

ADOPTED: M(r,d) = Delta^(d+1) of R(2^.) at r, PRIMARY -- it is the main term
O34's residuals demonstrably carry, and it is the smooth part the pi-form
modes actually complement.  The li-stencil (unoffset li(x) = Ei(log x); the
offset Li = li - li(2) differs by a constant the stencil annihilates, so
offset vs unoffset changes nothing in scope) is CARRIED AS A COMPARISON at
every headline cell, so the reader sees exactly which certifications are
convention-sensitive.  The brief's spec named the li-stencil; the brief also
said to read O34's handling and match it, and O34's handling is R -- the
sanity gate below prints the measurement that decides it.  Sanity gates:
(a) at d = 0, M(r,0) vs the true prime count at r = 15 and 20, both
conventions; (b) the full r = 20 residual ladder against O34's TRUE_RES_R20
literals, R-stencil matching to printed precision.

The stencil reaches m = r-(d+1).  At m = 0 the pi-form Ei modes are singular
-- Ei(rho*log 1) = Ei(0) = -inf for every zero (O90's PI_UNDEFINED) -- and
li(1) = -inf as well (R(1) alone is finite).  So cells with
r - (d+1) < 1 are MODEL-UNDEFINED and reported as such with the reason,
never silently dropped.  This costs the target (2,1) and the first cell
(r = d+1) of each background row.

WHY CERTIFICATION RUNS IN THE PI FORM ONLY
------------------------------------------
cell_true is a pi count.  O34's model -- whose regime figures (94%/92%/80% of
the row-20 residual at d = 0/3/6) are what put (20,6) inside the tested
regime -- is the pi form: Ei modes of pi_osc through the same stencil, never
psi.  Entry 193 verified O90's pi column IS O34's construction to seven
digits.  The psi-form modes target Delta^(d+1) psi(2^.), a different
quantity; converting psi modes to a pi target needs the Riemann mu-sum over
prime powers and the 1/log weight, which O34 never implements and this
script does not invent.  So certification of the integer is asked in the pi
form only, and the psi form appears as a CROSS-CHECK column: the same
K-to-within-0.5 question asked of the psi table itself (cell_true_psi =
Delta^(d+1) psi(2^.) computed exactly from prime powers, main term
Delta^(d+1)[x - (1/2)log(1 - x^-2)], the -log(2pi) constant annihilated by
the stencil).  The psi cells are not integers, so +-0.5 has no
integer-certification meaning there; the column is a parallel-behaviour
check on the same cells, labelled as exactly that.  psi(x) jumps at every
x = 2^m (Lambda(2^m) = ln 2), and the explicit formula converges to the
midpoint psi(x) - ln2/2 there; that offset is constant across stencil nodes
and is annihilated by the stencil, so it does not enter any psi cell.  On
the pi side the only jump node is m = 1 (x = 2, midpoint offset 1/2), which
enters only cells with r-(d+1) = 1, all far outside the regime; noted, not
corrected.

PRECISION
---------
dps 50 working, inherited from O90 with the same budget: ~25-digit data floor
in zeros600.json, ~5 digits to argument reduction at r*gamma*ln2, ~5 to the
2^(r/2) scale, ~3 to 600 summed terms, 2-3 to the Delta^7 binomial weights.
--precision-check (default on) recomputes every headline cell -- the four
zeros, the two controls, and the r = 20 depth ladder d = 0..6 -- at dps + 30
= 80 and reports whether any K_first / K_stable moves and the max shift in
the terminal error.  psi true values are exact prime-power sums of log p
recomputed at whatever dps is current.

HOW IT WAS RUN
--------------
    python3 utilities/run.py --log results/O92_certification_cost_run1.log \
        O92_certification_cost.py

Direct interpreter invocation of a root O*.py is blocked by
`utilities/hooks/check_direct_run.py`; the runner clones results/ first,
archives anything it changes and writes the manifest.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import statistics
import sys
from math import comb

from mpmath import mp, mpf, mpmathify, ei, log, fabs, power, riemannr
from mpmath import re as mre

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

# The mode construction is O90's, imported rather than re-derived, exactly as
# O91 imports it. Entry 201 item 1 specifies "the c_k as in O90".
import O90_mode_coherence as O90
from O90_mode_coherence import (PsiModes, PiModes, TARGETS, CONTROLS,
                                LEAN_CELL, REGIME, PI_UNDEFINED)

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "certification_cost.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")
PI_CACHE = os.path.join(_HERE, "pi2n_cache.json")

MODEL_UNDEFINED = ("model undefined: the Delta^(d+1) stencil reaches m = 0, "
                   "x = 1, where Ei(rho*log 1) = -inf for every zero (and "
                   "li(1) = -inf); the true cell is exact but no "
                   "explicit-formula model value exists")

BACKGROUND_DEPTHS = [1, 3, 6]
LADDER_R = 20
LADDER_DEPTHS = list(range(0, 7))
CHECKPOINTS = [0, 25, 50, 100, 200, 400, 600]


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


# ------------------------------------------------------------ exact tables

def load_pi_cache():
    with open(PI_CACHE) as fh:
        raw = json.load(fh)
    return {int(k): int(v) for k, v in raw.items()}


def table_cell(pi, r, d):
    """cell (r,d) = Delta^(d+1) of pi(2^.) at r -- exact integer."""
    n = d + 1
    return sum(((-1) ** j) * comb(n, j) * pi[r - j] for j in range(n + 1))


def table_cell_wrong_index(pi, r, d):
    """Delta^d -- the exponent entry 192 corrected AWAY from. Gate column."""
    if d == 0:
        return pi[r]
    return sum(((-1) ** j) * comb(d, j) * pi[r - j] for j in range(d + 1))


def psi_ladder(rmax):
    """psi(2^m) for m = 0..rmax, exact: sum of log p over prime powers
    p^a <= 2^m.  Computed at the CURRENT mp.dps."""
    import sympy
    X = 2 ** rmax
    delta = [mpf(0)] * (rmax + 1)
    for p in sympy.primerange(2, X + 1):
        lp = log(mpf(p))
        q = p
        while q <= X:
            m0 = (q - 1).bit_length()          # smallest m with 2^m >= q
            if m0 <= rmax:
                delta[m0] += lp
            q *= p
    out = [mpf(0)] * (rmax + 1)
    acc = mpf(0)
    for m in range(rmax + 1):
        acc += delta[m]
        out[m] = acc
    return out


# ------------------------------------------------------------- main terms

def smooth_stencil(r, d, vals):
    """Delta^(d+1) of a smooth ladder vals[m] at r.  None where the stencil
    reaches m = 0, matching the modes' domain (Ei(0) = -inf there)."""
    n = d + 1
    if r - n < 1:
        return None
    return sum(((-1) ** j) * comb(n, j) * vals[r - j] for j in range(n + 1))


def psi_main_stencil(r, d):
    """Delta^(d+1) of [x - (1/2)log(1 - x^-2)] at x = 2^.; the -log(2pi)
    constant is annihilated by the stencil.  None where the stencil reaches
    m = 0 (the trivial-zeros term diverges at x = 1)."""
    n = d + 1
    if r - n < 1:
        return None
    acc = mpf(0)
    for j in range(n + 1):
        m = r - j
        x = power(mpf(2), m)
        term = x - mpf('0.5') * log(1 - power(x, -2))
        acc += ((-1) ** j) * comb(n, j) * term
    return acc


# ----------------------------------------------------------- certification

def certify(M, true_v, cs, thr):
    """Error curve err(K) = |M + S_K - true|, K = 0..len(cs).  Returns
    (K_first, K_stable, terminal_err, errs)."""
    errs = []
    acc = M - true_v
    errs.append(fabs(acc))
    for c in cs:
        acc += c
        errs.append(fabs(acc))
    first = None
    for K, e in enumerate(errs):
        if e < thr:
            first = K
            break
    stable = None
    if errs[-1] < thr:
        K = len(errs) - 1
        while K - 1 >= 0 and errs[K - 1] < thr:
            K -= 1
        stable = K
    return first, stable, errs[-1], errs


def crossings(errs, thr):
    """How many times the error curve crosses the threshold (in either
    direction).  > 1 means at least one transient dip or pop-out."""
    n = 0
    below = errs[0] < thr
    for e in errs[1:]:
        b = e < thr
        if b != below:
            n += 1
            below = b
    return n


def fmt_K(first, stable, term):
    if stable is not None:
        if first == stable:
            return f"K={stable}"
        return f"K={stable} (first touch {first}, transient)"
    if first is not None:
        return f"UNCERTIFIED (transient touch at {first}; |err(600)|={mp.nstr(term, 6)})"
    return f"UNCERTIFIED (|err(600)| = {mp.nstr(term, 6)})"


def cell_record(r, d, form, M, true_v, cs, thr):
    first, stable, term, errs = certify(M, true_v, cs, thr)
    ncross = crossings(errs, thr)
    rec = {
        "r": r, "d": d, "form": form, "defined": True,
        "true": float(true_v) if isinstance(true_v, mpf) else int(true_v),
        "M": float(M),
        "S_600": float(sum(cs)),
        "K_first": first, "K_stable": stable,
        "certified_at_600": stable is not None,
        "transient": (first is not None and first != stable),
        "threshold_crossings": ncross,
        "terminal_abs_err": float(term),
        "err_at": {str(k): float(errs[k]) for k in CHECKPOINTS
                   if k < len(errs)},
    }
    return rec, errs


# ------------------------------------------------------------------ the run

def parse_args():
    ap = argparse.ArgumentParser(
        description=("O92 - certification cost: minimum zero pairs K pinning "
                     "cell (r,d) to +-0.5. EXPLORATORY: no prereg, no "
                     "decision rule, no verdict."))
    ap.add_argument("--dps", type=int, default=50,
                    help="mpmath working precision (default 50)")
    ap.add_argument("--nzeros", type=int, default=600,
                    help="number of zero pairs (default 600, the file's size)")
    ap.add_argument("--rmax", type=int, default=20,
                    help="background ladder top (default 20)")
    ap.add_argument("--depths", type=str, default="1,3,6",
                    help="comma list of background depths (default 1,3,6)")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="path to the zero list (default zeros600.json)")
    ap.add_argument("--threshold", type=str, default="0.5",
                    help="certification half-width (default 0.5)")
    ap.add_argument("--precision-check", dest="pcheck", action="store_true",
                    default=True,
                    help="recompute headline cells at dps+30 and report "
                         "whether any K_cert moves (default on)")
    ap.add_argument("--no-precision-check", dest="pcheck",
                    action="store_false")
    ap.add_argument("--no-psi-crosscheck", dest="psicheck",
                    action="store_false", default=True,
                    help="skip the psi-form cross-check column")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    a = ap.parse_args()
    if a.out == DEFAULT_OUT_JSON and a.results_dir != DEFAULT_RESULTS_DIR:
        a.out = os.path.join(a.results_dir, os.path.basename(DEFAULT_OUT_JSON))
    return a


def main():
    args = parse_args()
    started = datetime.datetime.now(datetime.timezone.utc)
    mp.dps = args.dps
    thr = mpf(args.threshold)

    bg_depths = sorted({int(t) for t in args.depths.split(",") if t.strip()})
    pi = load_pi_cache()
    cache_ns = sorted(pi)

    print("=" * 78)
    print("O92 - CERTIFICATION COST AT THE TABLE'S CELLS")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT. Nothing")
    print("printed below may be described as a verdict.")
    print("=" * 78)

    # ------------------------------------------------ 0. THE SIX-VALUE GATE
    print()
    print("=" * 78)
    print("0. STENCIL-INDEX GATE - printed FIRST, before any model number")
    print("=" * 78)
    print("Entry 192's correction: cell (r,d) = Delta^(d+1) of pi(2^.) at r.")
    print("The Delta^(d+1) column must reproduce all six kernel-proved values")
    print("(lean/Zeros.lean); the Delta^d column is shown to reproduce none.")
    print()
    print(f"{'cell':>9}{'Delta^d':>10}{'Delta^(d+1)':>13}{'Lean':>7}{'gate':>7}")
    gate_rows = []
    gate_ok = True
    for (r, d), lean_v in LEAN_CELL.items():
        wrong = table_cell_wrong_index(pi, r, d)
        right = table_cell(pi, r, d)
        ok = (right == lean_v)
        gate_ok &= ok
        gate_rows.append({"r": r, "d": d, "delta_d": int(wrong),
                          "delta_d_plus_1": int(right), "lean": lean_v,
                          "match": ok})
        print(f"{str((r, d)):>9}{wrong:>10}{right:>13}{lean_v:>7}"
              f"{'PASS' if ok else 'FAIL':>7}")
    print()
    if not gate_ok:
        print("GATE FAILED: the Delta^(d+1) table does not reproduce the six")
        print("kernel-proved values. Nothing further is computed.")
        sys.exit(1)
    print("GATE PASSED: all six kernel values reproduced under Delta^(d+1).")
    print(f"pi2n_cache.json holds n = {cache_ns[0]}..{cache_ns[-1]} "
          f"({len(cache_ns)} entries); this run needs m <= {args.rmax}, "
          f"entirely inside the cache. No cell is out of scope for cache "
          f"reasons.")

    # ------------------------------------------------------- zeros and modes
    with open(args.zeros) as fh:
        raw = json.load(fh)
    gammas = [mpmathify(s) for s in raw[:args.nzeros]]
    N = len(gammas)

    all_depths = sorted(set(bg_depths) | set(LADDER_DEPTHS) |
                        {d for _, d in TARGETS + CONTROLS})
    rmax = max(args.rmax, LADDER_R, max(r for r, _ in TARGETS + CONTROLS))

    print()
    print(f"  zeros        {N} pairs from {os.path.basename(args.zeros)}, "
          f"gamma_1 = {mp.nstr(gammas[0], 12)} .. "
          f"gamma_{N} = {mp.nstr(gammas[-1], 12)}")
    print(f"  dps          {args.dps} working; ~25-digit data floor in the "
          f"zero strings")
    print(f"  threshold    |model - cell| < {mp.nstr(thr, 6)} certifies the "
          f"integer")
    print(f"  model        M(r,d) + S_K(r,d), pi form (O34's object; see "
          f"docstring)")
    print(f"  building pi-form modes (O90.PiModes, rmax {rmax}) ...",
          flush=True)
    pimodes = PiModes(gammas, rmax, all_depths)
    ln2 = log(mpf(2))
    li_vals = [None] + [ei(m * ln2) for m in range(1, rmax + 1)]
    R_vals = [None] + [riemannr(power(mpf(2), m)) for m in range(1, rmax + 1)]

    def pi_cs(r, d):
        """Real per-pair contributions c_k in the pi form, O90's construction."""
        return [-2 * mre(z) for z in pimodes.amps(r, d)]

    # ------------------------------------- 1. MAIN-TERM CONVENTION + SANITY
    print()
    print("=" * 78)
    print("1. MAIN-TERM CONVENTION AND SANITY GATES")
    print("=" * 78)
    print("Convention ADOPTED: M(r,d) = Delta^(d+1) of R(2^.) at r, R =")
    print("Riemann's function (mpmath riemannr). O34's TRUE_RES_R20 literals")
    print("are R-stencil residuals -- the gate below shows the R column")
    print("matching every literal to its printed precision while the li")
    print("column misses depths 0-2 by 23.8 / 5.9 / 1.5 -- and R is the")
    print("smooth part of the J-expansion whose oscillating part IS the Ei")
    print("mode sum, so li would leave an unmodeled li - R floor no number")
    print("of zeros removes. The li-stencil (unoffset; the offset constant")
    print("is annihilated by the stencil) is carried as a comparison column")
    print("at every headline cell.")
    print()
    print("(a) d = 0: M(r,0) vs the true block count, both conventions")
    sanity_d0 = []
    for r_chk in (15, 20):
        MR0 = smooth_stencil(r_chk, 0, R_vals)
        Mli0 = smooth_stencil(r_chk, 0, li_vals)
        true0 = table_cell(pi, r_chk, 0)
        sanity_d0.append({"r": r_chk, "M_R": float(MR0), "M_li": float(Mli0),
                          "true": int(true0),
                          "residual_R": float(true0 - MR0),
                          "residual_li": float(true0 - Mli0)})
        print(f"    r={r_chk:>3}  true={true0:>8}  "
              f"M_R={mp.nstr(MR0, 11):>15}  resid_R={mp.nstr(true0 - MR0, 7):>11}  "
              f"M_li={mp.nstr(Mli0, 11):>15}  resid_li={mp.nstr(true0 - Mli0, 7):>11}")
    print("    scale check: both residuals are the differenced |pi - smooth|")
    print("    gap, O(sqrt(x)/log x); li overestimates pi on this range.")
    print()
    print("(b) r = 20 residual ladder vs O34's TRUE_RES_R20 literals (dps 40)")
    o34_lits = ['-24.886', '-48.190', '-82.086', '-133.761', '-212.314',
                '-322.410', '-453.424']
    sanity_r20 = []
    print(f"{'d':>4}{'true - M_R':>16}{'O34 literal':>13}{'diff':>11}"
          f"{'true - M_li':>16}{'li - R gap':>13}")
    for d in LADDER_DEPTHS:
        MR = smooth_stencil(LADDER_R, d, R_vals)
        Mli = smooth_stencil(LADDER_R, d, li_vals)
        true_v = table_cell(pi, LADDER_R, d)
        res = true_v - MR
        res_li = true_v - Mli
        lit = mpf(o34_lits[d])
        sanity_r20.append({"d": d, "residual_R": float(res),
                           "o34_literal": float(lit),
                           "diff": float(res - lit),
                           "residual_li": float(res_li),
                           "li_minus_R_gap": float(Mli - MR)})
        print(f"{d:>4}{mp.nstr(res, 9):>16}{o34_lits[d]:>13}"
              f"{mp.nstr(res - lit, 3):>11}{mp.nstr(res_li, 9):>16}"
              f"{mp.nstr(Mli - MR, 4):>13}")
    print("    O34's literals are 7-significant-digit transcriptions at dps")
    print("    40; the R column matching them to printed precision is the")
    print("    gate that identifies O34's convention as R.")

    # -------------------------------------------------- 2. TARGETS/CONTROLS
    print()
    print("=" * 78)
    print("2. K_cert - THE FOUR ZEROS AND THE TWO CONTROLS (pi form)")
    print("=" * 78)
    print(f"K_first = first K with |err| < {mp.nstr(thr, 4)}; K_stable = "
          f"smallest K certified")
    print(f"for ALL larger K' <= {N}. A transient dip is not certification.")
    print()
    headline_cells = list(dict.fromkeys(
        TARGETS + CONTROLS + [(LADDER_R, d) for d in LADDER_DEPTHS]))
    cells_out = []
    err_curves = {}
    hdr = (f"{'cell':>9}{'lean':>6}{'role':>9}{'true':>8}{'M':>13}"
           f"{'K_first':>9}{'K_stable':>10}{'|err(' + str(N) + ')|':>13}")
    print(hdr)
    print("-" * len(hdr))
    for r, d in TARGETS + CONTROLS:
        role = "zero" if (r, d) in TARGETS else "control"
        true_v = table_cell(pi, r, d)
        M = smooth_stencil(r, d, R_vals)
        if M is None:
            rec = {"r": r, "d": d, "form": "pi", "role": role,
                   "lean": LEAN_CELL[(r, d)], "defined": False,
                   "true": int(true_v), "reason": MODEL_UNDEFINED,
                   "regime": REGIME[(r, d)]}
            cells_out.append(rec)
            print(f"{str((r, d)):>9}{LEAN_CELL[(r, d)]:>6}{role:>9}"
                  f"{true_v:>8}{'undefined':>13}{'-':>9}{'-':>10}{'-':>13}")
            continue
        cs = pi_cs(r, d)
        rec, errs = cell_record(r, d, "pi", M, mpf(true_v), cs, thr)
        Mli = smooth_stencil(r, d, li_vals)
        fl, sl, tl, _ = certify(Mli, mpf(true_v), cs, thr)
        rec.update(role=role, lean=LEAN_CELL[(r, d)], regime=REGIME[(r, d)],
                   M_li=float(Mli), li_minus_R_gap=float(Mli - M),
                   K_first_li=fl, K_stable_li=sl,
                   terminal_abs_err_li=float(tl))
        cells_out.append(rec)
        err_curves[(r, d)] = errs
        kf = "-" if rec["K_first"] is None else rec["K_first"]
        ks = "UNCERT" if rec["K_stable"] is None else rec["K_stable"]
        print(f"{str((r, d)):>9}{LEAN_CELL[(r, d)]:>6}{role:>9}{true_v:>8}"
              f"{mp.nstr(M, 8):>13}{kf:>9}{ks:>10}"
              f"{rec['terminal_abs_err']:>13.4e}")
    print()
    for r, d in TARGETS + CONTROLS:
        print(f"  ({r},{d})  {REGIME[(r, d)]}")
    for rec in cells_out:
        if not rec.get("defined", True):
            print(f"  ({rec['r']},{rec['d']})  {rec['reason']}")
        elif rec.get("transient"):
            print(f"  ({rec['r']},{rec['d']})  first touch K={rec['K_first']} "
                  f"differs from stable K={rec['K_stable']}: the dip popped "
                  f"back out {rec['threshold_crossings'] - 1} more time(s) "
                  f"before settling")

    # ------------------------------------------- 3. DEPTH LADDER AT r = 20
    print()
    print("=" * 78)
    print(f"3. K_cert(d) AT r = {LADDER_R}, d = 0..6 - the direct test of")
    print("   'certification cost blows up with depth' (entry 201)")
    print("=" * 78)
    ladder_out = []
    kmid = max((k for k in CHECKPOINTS if k <= min(200, N)), default=0)
    kend = N
    hdr3 = (f"{'d':>4}{'true':>9}{'M':>15}{'K_first':>9}{'K_stable':>10}"
            f"{'|err(0)|':>12}{'|err(' + str(kmid) + ')|':>12}"
            f"{'|err(' + str(kend) + ')|':>12}")
    print(hdr3)
    print("-" * len(hdr3))
    for d in LADDER_DEPTHS:
        r = LADDER_R
        true_v = table_cell(pi, r, d)
        M = smooth_stencil(r, d, R_vals)
        cs = pi_cs(r, d)
        rec, errs = cell_record(r, d, "pi", M, mpf(true_v), cs, thr)
        Mli = smooth_stencil(r, d, li_vals)
        fl, sl, tl, _ = certify(Mli, mpf(true_v), cs, thr)
        rec.update(M_li=float(Mli), li_minus_R_gap=float(Mli - M),
                   K_first_li=fl, K_stable_li=sl,
                   terminal_abs_err_li=float(tl))
        ladder_out.append(rec)
        err_curves[(r, d)] = errs
        kf = "-" if rec["K_first"] is None else rec["K_first"]
        ks = "UNCERT" if rec["K_stable"] is None else rec["K_stable"]
        print(f"{d:>4}{true_v:>9}{mp.nstr(M, 9):>15}{kf:>9}{ks:>10}"
              f"{float(errs[0]):>12.4e}{float(errs[kmid]):>12.4e}"
              f"{float(errs[kend]):>12.4e}")
    print()
    for rec in ladder_out:
        if rec.get("transient"):
            print(f"  d={rec['d']}: first touch {rec['K_first']} vs stable "
                  f"{rec['K_stable']} ({rec['threshold_crossings']} threshold "
                  f"crossings)")
    certd = [rec for rec in ladder_out if rec["K_stable"] is not None]
    uncert = [rec for rec in ladder_out if rec["K_stable"] is None]
    print(f"  certified at {N}: depths "
          f"{[rec['d'] for rec in certd]}; uncertified: "
          f"{[(rec['d'], round(rec['terminal_abs_err'], 3)) for rec in uncert]}")
    print()
    print("  li-stencil comparison (same modes, main term Delta^(d+1) li):")
    print(f"{'d':>4}{'li-R gap':>12}{'K_stable(R)':>13}{'K_stable(li)':>14}"
          f"{'|err' + str(N) + '|(li)':>14}")
    for rec in ladder_out:
        ksR = "UNCERT" if rec["K_stable"] is None else rec["K_stable"]
        ksL = "UNCERT" if rec["K_stable_li"] is None else rec["K_stable_li"]
        print(f"{rec['d']:>4}{rec['li_minus_R_gap']:>12.4e}{ksR:>13}{ksL:>14}"
              f"{rec['terminal_abs_err_li']:>14.4e}")
    print("  where the gap exceeds the 0.5 criterion (low d), the li")
    print("  convention decides certification by itself; where it is far")
    print("  below (deep d), the two conventions agree cell by cell.")

    # ------------------------------------------------------- 4. BACKGROUND
    print()
    print("=" * 78)
    print(f"4. BACKGROUND - d in {bg_depths}, r = d+1 .. {args.rmax} (pi form)")
    print("=" * 78)
    bg_rows = []
    bg_summary = {}
    for d in bg_depths:
        rows_d = []
        print(f"--- depth {d} " + "-" * 64)
        hdr4 = (f"{'r':>4}{'true':>10}{'K_first':>9}{'K_stable':>10}"
                f"{'|err(' + str(N) + ')|':>13}  note")
        print(hdr4)
        for r in range(d + 1, args.rmax + 1):
            true_v = table_cell(pi, r, d)
            M = smooth_stencil(r, d, R_vals)
            if M is None:
                row = {"r": r, "d": d, "form": "pi", "defined": False,
                       "true": int(true_v), "reason": MODEL_UNDEFINED}
                rows_d.append(row)
                print(f"{r:>4}{true_v:>10}{'-':>9}{'-':>10}{'-':>13}  "
                      f"model undefined (stencil reaches m = 0)")
                continue
            rec, _ = cell_record(r, d, "pi", M, mpf(true_v), pi_cs(r, d), thr)
            rec["li_minus_R_gap"] = float(smooth_stencil(r, d, li_vals) - M)
            rows_d.append(rec)
            kf = "-" if rec["K_first"] is None else rec["K_first"]
            ks = "UNCERT" if rec["K_stable"] is None else rec["K_stable"]
            note = ""
            if rec.get("transient"):
                note = f"transient touch at {rec['K_first']}"
            if (r, d) in LEAN_CELL:
                note = (note + " " if note else "") + \
                    f"[kernel cell, lean = {LEAN_CELL[(r, d)]}]"
            print(f"{r:>4}{true_v:>10}{kf:>9}{ks:>10}"
                  f"{rec['terminal_abs_err']:>13.4e}  {note}")
        bg_rows.extend(rows_d)
        defined = [x for x in rows_d if x.get("defined")]
        cert = [x for x in defined if x["K_stable"] is not None]
        unc = [x for x in defined if x["K_stable"] is None]
        med = (statistics.median(x["K_stable"] for x in cert)
               if cert else None)
        bg_summary[d] = {
            "cells": len(rows_d),
            "model_undefined": len(rows_d) - len(defined),
            "certified_at_600": len(cert),
            "uncertified_at_600": len(unc),
            "median_stable_K_among_certified": med,
            "uncertified_cells": [{"r": x["r"],
                                   "terminal_abs_err": x["terminal_abs_err"]}
                                  for x in unc],
        }
        print(f"  depth {d}: {len(cert)}/{len(defined)} defined cells certify "
              f"at {N}; median stable K among certified = {med}; "
              f"{len(rows_d) - len(defined)} model-undefined")
        print()

    # --------------------------------------------- 5. PSI CROSS-CHECK COLUMN
    psi_out = []
    if args.psicheck:
        print("=" * 78)
        print("5. PSI-FORM CROSS-CHECK - same cells, psi's OWN table")
        print("=" * 78)
        print("The psi modes target Delta^(d+1) psi(2^.), not the pi integer;")
        print("certifying the pi count with psi modes would need the mu-sum /")
        print("1/log conversion O34 never implements. So the cross-check asks")
        print("the SAME +-0.5 question of the psi table itself: true values")
        print("are exact prime-power sums of log p; main term is")
        print("Delta^(d+1)[x - (1/2)log(1-x^-2)] (-log 2pi annihilated by the")
        print("stencil; the ln2/2 jump-midpoint offset at x = 2^m likewise).")
        print("psi cells are NOT integers, so +-0.5 has no integer meaning")
        print("here -- this column is a parallel-behaviour check only.")
        print()
        print("  computing psi(2^m) exactly from prime powers ...", flush=True)
        psis = psi_ladder(rmax)
        print(f"  building psi-form modes (O90.PsiModes) ...", flush=True)
        psimodes = PsiModes(gammas, rmax, all_depths)
        print()
        hdr5 = (f"{'cell':>9}{'true(psi)':>15}{'K_first':>9}{'K_stable':>10}"
                f"{'|err(' + str(N) + ')|':>13}")
        print(hdr5)
        print("-" * len(hdr5))
        for r, d in headline_cells:
            M = psi_main_stencil(r, d)
            n = d + 1
            true_v = (None if r - n < 1 else
                      sum(((-1) ** j) * comb(n, j) * psis[r - j]
                          for j in range(n + 1)))
            if M is None or true_v is None:
                psi_out.append({"r": r, "d": d, "form": "psi",
                                "defined": False,
                                "reason": MODEL_UNDEFINED})
                print(f"{str((r, d)):>9}{'undefined':>15}{'-':>9}{'-':>10}"
                      f"{'-':>13}")
                continue
            cs = [-2 * mre(z) for z in psimodes.amps(r, d)]
            first, stable, term, errs = certify(M, true_v, cs, thr)
            row = {"r": r, "d": d, "form": "psi", "defined": True,
                   "true_psi": float(true_v), "M": float(M),
                   "K_first": first, "K_stable": stable,
                   "transient": (first is not None and first != stable),
                   "terminal_abs_err": float(term),
                   "err_at": {str(k): float(errs[k]) for k in CHECKPOINTS
                              if k < len(errs)}}
            psi_out.append(row)
            kf = "-" if first is None else first
            ks = "UNCERT" if stable is None else stable
            print(f"{str((r, d)):>9}{mp.nstr(true_v, 10):>15}{kf:>9}{ks:>10}"
                  f"{float(term):>13.4e}")
        print()
        print("  Read against section 2/3's pi column: agreement in which")
        print("  cells are cheap and which resist is the cross-check; the")
        print("  absolute K values are not comparable across forms.")

    # ------------------------------------------------ 6. PRECISION CHECK
    pcheck = {}
    if args.pcheck:
        print()
        print("=" * 78)
        print(f"6. PRECISION CHECK - headline cells recomputed at "
              f"dps {args.dps + 30}")
        print("=" * 78)
        hi = args.dps + 30
        mp.dps = hi
        gam_hi = [mpmathify(s) for s in raw[:args.nzeros]]
        pimodes_hi = PiModes(gam_hi, rmax, all_depths)
        R_hi = [None] + [riemannr(power(mpf(2), m)) for m in range(1, rmax + 1)]
        print(f"{'cell':>9}{'K_stable lo':>13}{'K_stable hi':>13}"
              f"{'|errN| lo':>14}{'|errN| hi':>14}{'shift':>12}")
        max_shift = 0.0
        k_moves = 0
        for r, d in headline_cells:
            M = smooth_stencil(r, d, R_hi)
            if M is None:
                continue
            true_v = table_cell(pi, r, d)
            cs = [-2 * mre(z) for z in pimodes_hi.amps(r, d)]
            first_hi, stable_hi, term_hi, _ = certify(M, mpf(true_v), cs, thr)
            lo = next(x for x in (cells_out + ladder_out)
                      if x.get("defined") and x["r"] == r and x["d"] == d)
            shift = abs(float(term_hi) - lo["terminal_abs_err"])
            max_shift = max(max_shift, shift)
            moved = (stable_hi != lo["K_stable"]) or (first_hi != lo["K_first"])
            k_moves += bool(moved)
            pcheck[f"{r}_{d}"] = {
                "K_first_hi": first_hi, "K_stable_hi": stable_hi,
                "terminal_abs_err_hi": float(term_hi),
                "terminal_shift": shift, "K_moved": bool(moved)}
            ks_lo = ("UNCERT" if lo["K_stable"] is None else lo["K_stable"])
            ks_hi = "UNCERT" if stable_hi is None else stable_hi
            print(f"{str((r, d)):>9}{ks_lo:>13}{ks_hi:>13}"
                  f"{lo['terminal_abs_err']:>14.4e}{float(term_hi):>14.4e}"
                  f"{shift:>12.2e}")
        mp.dps = args.dps
        print(f"\n  K_first/K_stable moved on {k_moves} of {len(pcheck)} "
              f"defined headline cells; max terminal-error shift "
              f"{max_shift:.2e}")

    print()
    print("=" * 78)
    print("EXPLORATORY. Nothing above is a verdict. No decision rule was")
    print("pre-registered and none fired. The reading is Julian's.")
    print("=" * 78)

    if not args.no_json:
        ended = datetime.datetime.now(datetime.timezone.utc)
        payload = {
            "schema_version": "1",
            "script": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "status": ("EXPLORATORY - no prereg, no decision rule, no "
                       "verdict. Nothing here may be described as a verdict."),
            "params": {
                "code_version": _code_version(),
                "dps": args.dps,
                "nzeros": N,
                "rmax": args.rmax,
                "background_depths": bg_depths,
                "ladder_r": LADDER_R,
                "ladder_depths": LADDER_DEPTHS,
                "threshold": float(thr),
                "zeros_file": args.zeros,
                "precision_check": bool(args.pcheck),
                "psi_crosscheck": bool(args.psicheck),
                "out": args.out,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            },
            "constants": {
                "stencil": ("cell (r,d) = Delta^(d+1) of pi(2^.) at r; "
                            "entry 192's correction, gated against the six "
                            "kernel values before any model number"),
                "model": ("model_K = M + S_K; M = Delta^(d+1) R(2^.), R = "
                          "Riemann's function via mpmath riemannr -- O34's "
                          "measured convention (its TRUE_RES_R20 literals "
                          "are R-stencil residuals to printed precision); "
                          "the li-stencil is carried as a comparison at "
                          "headline cells; S_K = partial sum of O90 PiModes "
                          "c_k"),
                "certified": "|model_K - cell_true| < threshold, integer "
                             "pinned",
                "targets": TARGETS,
                "controls": CONTROLS,
                "lean_cell_values": {f"{r},{d}": v
                                     for (r, d), v in LEAN_CELL.items()},
                "regime": {f"{r},{d}": v for (r, d), v in REGIME.items()},
                "model_undefined_reason": MODEL_UNDEFINED,
                "prediction_under_test": (
                    "entry 201: O34's sign-flip at (25,21) predicts K_cert "
                    "blows up with depth, possibly beyond 600 at (20,6); a "
                    "bounded small K_cert at (20,6) falsifies the "
                    "'arithmetic pins what spectrum cannot reach' inference"),
            },
            "summary": {
                "gate": {"passed": gate_ok, "rows": gate_rows},
                "cache_range": {"n_min": cache_ns[0], "n_max": cache_ns[-1],
                                "needed_max": args.rmax,
                                "out_of_scope_cells": []},
                "main_term_sanity_d0": sanity_d0,
                "r20_residual_vs_o34_literals": sanity_r20,
                "ladder_r20": ladder_out,
                "background": {str(d): bg_summary[d] for d in bg_summary},
                "precision_check": pcheck,
            },
            "rows": {
                "targets_controls": cells_out,
                "ladder_r20": ladder_out,
                "background": bg_rows,
                "psi_crosscheck": psi_out,
                "err_every_25": {
                    f"{r},{d}": [float(err_curves[(r, d)][k])
                                 for k in range(0, N + 1, 25)]
                    for (r, d) in err_curves},
            },
        }
        guarded_write(_jsonable(payload), args.out, allow_nan=False)


if __name__ == "__main__":
    main()
