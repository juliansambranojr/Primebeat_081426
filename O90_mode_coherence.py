"""
O90 - MODE COHERENCE at the four exact zeros: is a table zero a cancellation
      across the whole zeta ensemble, or is it carried by a few modes?

Reads with: notes/lab_notebook_2.md entry 192 (the design, and the reason this
instrument exists); lean/Zeros.lean (the four zeros and the two proved non-zero
neighbours); lean/Construction.lean (the stencil); O34_zeta_residual_model.py
(the pi-form explicit-formula model and the regime figures this inherits);
O35_nearmiss_residuals.py (the same question at the near-miss cells).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may
be described as a verdict, and no verdict line is written anywhere in its
output.

THE DERIVATION
--------------
Riemann-von Mangoldt explicit formula for the Chebyshev function:

    psi(x) = x - sum_rho x^rho / rho - log(2*pi) - (1/2)*log(1 - x^-2)

Grouping each zero rho_k = 1/2 + i*gamma_k with its conjugate makes the
oscillating part real, one term per zero PAIR:

    psi_osc(x) = - sum_k 2*Re[ x^(rho_k) / rho_k ]

The stencil is the backward difference along the dyadic ladder,

    (Delta f)(r) = f(2^r) - f(2^(r-1))

On a single mode evaluated at x = 2^r,

    Delta[ 2^(r*rho) ] = 2^(r*rho) - 2^((r-1)*rho) = 2^(r*rho) * (1 - 2^(-rho))

Delta is linear and every application multiplies by the same constant factor, so

    Delta^n[ 2^(r*rho) ] = 2^(r*rho) * (1 - 2^(-rho))^n

WHICH n GOES WITH DEPTH d.  `lean/Construction.lean` defines

    tableFrom N r 0       = N r
    tableFrom N r (d + 1) = tableFrom N r d - tableFrom N (r - 1) d

and `lean/Zeros.lean` defines the depth-0 row as
`dyadicRow r = pi(2^r) - pi(2^(r-1))`, which is ALREADY one backward
difference of the cumulative ladder.  So a table cell (r,d) is Delta^(d+1)
applied to pi(2^.) at r, and n = d+1.  Checked against `pi2n_cache.json` at the
project root: the Delta^(d+1) column reproduces all six kernel-proved values and
the Delta^d column reproduces none --

    cell     Delta^d   Delta^(d+1)   Lean
   (2,1)           1             0      0    Zeros.zero_2_1
   (4,1)           2             0      0    Zeros.zero_4_1
   (8,3)           4             0      0    Zeros.zero_8_3
  (20,6)         623             0      0    Zeros.zero_20_6
   (7,3)           4             5      5    Zeros.nonzero_7_3
  (19,6)         623           343    343    Zeros.nonzero_19_6

Entry 192 first carried the exponent as `d` and was corrected to `d+1` before
this script was written; the correction is recorded in the entry itself.  The
per-pair contribution therefore is

    c_k(r,d) = -2 * Re[ 2^(r*rho_k) * (1 - 2^(-rho_k))^(d+1) / rho_k ]

which is the formula in the corrected entry 192.

TWO FORMS, BOTH REPORTED
------------------------
The derivation above is a mode of the PSI explicit formula, while the table
counts PI.  Both are computed here and neither is picked as the winner.

  psi form   z_k = 2^(r*rho_k) * (1 - 2^(-rho_k))^(d+1) / rho_k ;  c_k = -2 Re z_k
             The complex modulus factors exactly as
             |z_k| = 2^(r/2) * |1 - 2^(-rho_k)|^(d+1) / |rho_k|,
             so r enters |z_k| only as one common scale.

  pi form    w_k(m) = Ei(rho_k * m*ln2), the per-pair term of
             pi_osc(x) = -sum_k 2*Re Ei(rho_k * log x), matching O34's `osc`.
             The stencil is applied to w directly:
             Z_k(r,d) = sum_{j=0..d+1} (-1)^j C(d+1,j) w_k(r-j) ;  c_k = -2 Re Z_k
             Nothing factors here, so whether |z| depends on r is an OPEN
             MEASUREMENT rather than a prediction.

  The pi form is UNDEFINED wherever the stencil reaches m = 0, because
  x = 2^0 = 1 gives Ei(rho * 0) = Ei(0) = -inf for every zero.  Those cells are
  reported as null in the pi column with the reason stated, never silently
  dropped.  This costs the target (2,1) and the first cell of each background
  row.

STATISTICS, per cell, over k = 1..N zero pairs
----------------------------------------------
    A          = sum_k |c_k|            total mode mass
    S          = sum_k c_k              net
    coherence  = |S| / A                THE STATISTIC
    top1       = max_k |c_k| / A
    S_N        = partial sums at N = 25, 50, 100, 200, 400, 600

`coherence` near 0 means the modes cancel each other (ensemble).  Near `top1`
means one mode carries the net (localized).

THE VACUOUSNESS CHECK, reported FIRST
-------------------------------------
Entry 192 predicts that mode MAGNITUDES depend on depth alone, with r entering
as the common scale 2^(r/2) plus phase -- which would make any concentration
statistic (top-1 share, participation ratio, entropy of |c_k|) return the same
number at a zero and at its non-zero neighbour BY CONSTRUCTION.  This script
verifies that numerically before printing anything else, and it separates two
things the entry runs together:

  |z_k|, the COMPLEX modulus.  For the psi form the factorisation above makes
        the normalised profile |z_k| / sum_j |z_j| exactly independent of r at
        fixed depth.  This is a prediction and the check confirms it.

  |c_k| = 2*|Re z_k|, the magnitude of the REAL contribution actually summed.
        This carries cos(arg z_k), and arg z_k depends on r.  Whether the
        normalised profile |c_k| / A is r-independent is therefore a
        measurement, and the check reports what it returns.

For the pi form neither is predicted; both are measured.

REGIME LIMIT, inherited from O34/O35 and stated per cell
-------------------------------------------------------
O34/O35 measured that the explicit formula reproduces 94% of the row-20
residual at d = 0, 92% at d = 3 and 80% at d = 6, in the PI form.  Those
figures are directly citable against this script's pi column and are an
approximate transfer to its psi column.  Three of the four exact zeros sit at
r = 2, 4, 8, where x is 4, 16 and 256 and the explicit formula is nowhere near
pi(x).  They are reported and labelled OUTSIDE the regime where the model
tracks.  (20,6), with (19,6) as its control, is the one target inside it.

PRECISION
---------
Zero data is `zeros600.json`, 600 gamma values as high-precision STRINGS
carrying ~25 significant digits, so ~25 digits is the DATA floor no working
precision can improve on.  The phase argument r*gamma*ln2 reaches
30 * 939.024 * 0.6931 = 1.953e4 radians at r = 30, five integer digits, so
argument reduction costs five digits of the working precision and magnifies the
gamma uncertainty by r*ln2 = 20.8 (an input error of 1e-25 becoming 2e-24
radians).  The largest magnitude is 2^(r/2) = 2^15 = 3.28e4, another five
digits, and 600 summed terms cost about three more.  dps 50 leaves ~37 digits of
arithmetic headroom under a data floor near 24 digits.  The pi form adds the
stencil's own cancellation -- a Delta^7 alternating sum with binomial weights up
to 35 -- worth two or three further digits, and Ei is evaluated by mpmath's
asymptotic expansion at |z| up to 1.95e4 where the series has ~|z| decreasing
terms.  --precision-check recomputes every target and control at dps + 30 and
prints the relative disagreement, so the headroom is measured rather than
asserted.

HOW IT WAS RUN
--------------
    python3 utilities/run.py --python .venv/bin/python O90_mode_coherence.py

Direct interpreter invocation of a root O*.py is blocked by
`utilities/hooks/check_direct_run.py`; the runner clones results/ first,
archives anything it changes and writes the manifest.

REQUIREMENTS
------------
    pip install mpmath
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

from mpmath import mp, mpf, mpc, mpmathify, ei, log, fabs, power
from mpmath import re as mre

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "mode_coherence.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")

TARGETS = [(2, 1), (4, 1), (8, 3), (20, 6)]
CONTROLS = [(7, 3), (19, 6)]

# Kernel-proved cell values, lean/Zeros.lean. Printed alongside so the reader
# sees which cells are the exact zeros and which are the proved non-zeros.
LEAN_CELL = {(2, 1): 0, (4, 1): 0, (8, 3): 0, (20, 6): 0,
             (7, 3): 5, (19, 6): 343}

REGIME = {
    (20, 6): "INSIDE - O34/O35 measured 80% of the row-20 residual at d=6",
    (19, 6): "adjacent to measured row 20, same depth",
    (2, 1):  "OUTSIDE - x = 4; the explicit formula is nowhere near pi(x)",
    (4, 1):  "OUTSIDE - x = 16; the explicit formula is nowhere near pi(x)",
    (8, 3):  "OUTSIDE - x = 256; the explicit formula is nowhere near pi(x)",
    (7, 3):  "OUTSIDE - x = 128; control for (8,3), same regime caveat",
}

PI_UNDEFINED = ("pi form undefined: the Delta^(d+1) stencil reaches m = 0, "
                "x = 1, where Ei(rho*log 1) = Ei(0) = -inf for every zero")


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


# ---------------------------------------------------------------- the modes

class PsiModes:
    """z_k(r,d) = 2^(r*rho_k) * (1 - 2^(-rho_k))^(d+1) / rho_k."""

    name = "psi"

    def __init__(self, gammas, rmax, depths):
        two = mpf(2)
        self.rho = [mpc(mpf('0.5'), g) for g in gammas]
        # 2^(r*rho_k), r = 0..rmax
        self.pw = [[power(two, r * rho) for r in range(rmax + 1)]
                   for rho in self.rho]
        # (1 - 2^(-rho_k))^(d+1) / rho_k, one per depth in use
        self.base = {}
        for d in depths:
            self.base[d] = [power(1 - power(two, -rho), d + 1) / rho
                            for rho in self.rho]

    def defined(self, r, d):
        return r >= 1, None if r >= 1 else "r < 1"

    def amps(self, r, d):
        """Complex mode amplitudes z_k at cell (r,d)."""
        b = self.base[d]
        return [self.pw[k][r] * b[k] for k in range(len(self.rho))]


class PiModes:
    """w_k(m) = Ei(rho_k * m*ln2); the stencil is applied to w directly, so
    Z_k(r,d) = sum_{j=0..d+1} (-1)^j C(d+1,j) w_k(r-j).  Matches O34's
    `osc(x) = -sum 2*Re Ei(rho*log x)` put through the same construction."""

    name = "pi"

    def __init__(self, gammas, rmax, depths):
        ln2 = log(mpf(2))
        self.rho = [mpc(mpf('0.5'), g) for g in gammas]
        # index m = 1..rmax; m = 0 is the singularity and is never filled
        self.w = [[None] + [ei(rho * (m * ln2)) for m in range(1, rmax + 1)]
                  for rho in self.rho]

    def defined(self, r, d):
        ok = (r - (d + 1)) >= 1
        return ok, None if ok else PI_UNDEFINED

    def amps(self, r, d):
        n = d + 1
        coef = [((-1) ** j) * comb(n, j) for j in range(n + 1)]
        out = []
        for k in range(len(self.rho)):
            wk = self.w[k]
            acc = mpc(0)
            for j, c in enumerate(coef):
                acc += c * wk[r - j]
            out.append(acc)
        return out


# ------------------------------------------------------------- the statistic

def cell_stats(amps, sn_points):
    """From complex amplitudes z_k, the real contributions c_k = -2 Re z_k and
    every statistic built on them.  Both profiles are returned: the real one
    that the coherence statistic uses, and the complex-modulus one that the psi
    factorisation makes a prediction about."""
    c = [-2 * mre(z) for z in amps]
    absc = [fabs(v) for v in c]
    A = sum(absc)
    S = sum(c)
    absz = [fabs(z) for z in amps]
    Az = sum(absz)
    sn = {}
    for n in sn_points:
        if n > len(c):
            continue
        Sn = sum(c[:n])
        An = sum(absc[:n])
        sn[n] = {"S_N": float(Sn),
                 "A_N": float(An),
                 "coherence_N": float(fabs(Sn) / An) if An != 0 else None}
    return {
        "A": float(A),
        "S": float(S),
        "coherence": float(fabs(S) / A) if A != 0 else None,
        "top1": float(max(absc) / A) if A != 0 else None,
        "top1_absz": float(max(absz) / Az) if Az != 0 else None,
        "S_N": sn,
        "_profile_c": [v / A for v in absc] if A != 0 else None,
        "_profile_z": [v / Az for v in absz] if Az != 0 else None,
    }


def strip_profiles(st):
    return {k: v for k, v in st.items() if not k.startswith("_")}


def profile_maxdiff(p, q):
    return float(max(fabs(a - b) for a, b in zip(p, q)))


# ------------------------------------------------------------------ the run

def parse_args():
    ap = argparse.ArgumentParser(
        description=("O90 - mode coherence at the four exact zeros, psi and pi "
                     "forms side by side. EXPLORATORY: no prereg, no decision "
                     "rule, no verdict."))
    ap.add_argument("--dps", type=int, default=50,
                    help="mpmath working precision (default 50). The zero data "
                         "carries ~25 significant digits, which is the floor "
                         "no working precision improves on")
    ap.add_argument("--nzeros", type=int, default=600,
                    help="number of zero pairs (default 600, the file's size)")
    ap.add_argument("--rmax", type=int, default=30,
                    help="background ladder top (default 30)")
    ap.add_argument("--depths", type=str, default="1,3,6",
                    help="comma list of background depths (default 1,3,6)")
    ap.add_argument("--sn", type=str, default="25,50,100,200,400,600",
                    help="comma list of partial-sum truncations")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="path to the zero list (default zeros600.json)")
    ap.add_argument("--forms", type=str, default="psi,pi",
                    help="which forms to compute (default psi,pi)")
    ap.add_argument("--precision-check", dest="pcheck", action="store_true",
                    default=True,
                    help="recompute targets and controls at dps+30 and report "
                         "the relative disagreement (default on)")
    ap.add_argument("--no-precision-check", dest="pcheck",
                    action="store_false")
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


def build(form, gammas, rmax, depths):
    return PsiModes(gammas, rmax, depths) if form == "psi" \
        else PiModes(gammas, rmax, depths)


def main():
    args = parse_args()
    started = datetime.datetime.now(datetime.timezone.utc)
    mp.dps = args.dps

    depths = [int(t) for t in args.depths.split(",") if t.strip()]
    sn_points = [int(t) for t in args.sn.split(",") if t.strip()]
    forms = [t.strip() for t in args.forms.split(",") if t.strip()]

    with open(args.zeros) as fh:
        raw = json.load(fh)
    gammas = [mpmathify(s) for s in raw[:args.nzeros]]
    N = len(gammas)

    for r, d in TARGETS + CONTROLS:
        if d not in depths:
            depths.append(d)
    depths = sorted(set(depths))
    rmax = max(args.rmax, max(r for r, _ in TARGETS + CONTROLS))

    print("=" * 78)
    print("O90 - MODE COHERENCE AT THE FOUR EXACT ZEROS")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT. Nothing")
    print("printed below may be described as a verdict.")
    print("=" * 78)
    print(f"  zeros        {N} pairs from {os.path.basename(args.zeros)}, "
          f"gamma_1 = {mp.nstr(gammas[0], 12)} .. "
          f"gamma_{N} = {mp.nstr(gammas[-1], 12)}")
    print(f"  dps          {args.dps} working; the zero strings carry ~25 "
          f"significant digits, which is the data floor")
    print(f"  stencil      cell (r,d) = Delta^(d+1) of pi(2^.) at r "
          f"(lean/Construction.lean + lean/Zeros.lean)")
    print(f"  mode         c_k(r,d) = -2 Re[ 2^(r*rho) (1-2^(-rho))^(d+1) "
          f"/ rho ]   [psi form]")
    print(f"  forms        {', '.join(forms)}")
    print(f"  background   depths {depths}, r = d+1 .. {rmax}")

    engines = {}
    for f in forms:
        print(f"\n  building {f}-form modes ...", flush=True)
        engines[f] = build(f, gammas, rmax, depths)

    # cache of per-cell stats, keyed (form, r, d)
    cache = {}

    def stats(form, r, d):
        key = (form, r, d)
        if key in cache:
            return cache[key]
        eng = engines[form]
        ok, why = eng.defined(r, d)
        st = None if not ok else cell_stats(eng.amps(r, d), sn_points)
        cache[key] = (st, why)
        return cache[key]

    # ------------------------------------------------ 1. VACUOUSNESS CHECK
    print()
    print("=" * 78)
    print("1. VACUOUSNESS CHECK - reported FIRST, before any coherence number")
    print("=" * 78)
    print("Entry 192 predicts mode MAGNITUDES depend on depth alone, r entering")
    print("as the common scale 2^(r/2) plus phase. If that holds for the")
    print("quantity the statistic is built on, every concentration measure")
    print("returns the same number at a zero and at its neighbour BY")
    print("CONSTRUCTION and nothing is measured. Two quantities, separated:")
    print()
    print("  |z_k|          complex modulus. psi form: factors exactly as")
    print("                 2^(r/2)|1-2^(-rho)|^(d+1)/|rho|, so PREDICTED")
    print("                 r-independent at fixed depth. pi form: OPEN.")
    print("  |c_k|=2|Re z|  the REAL contribution actually summed. Carries")
    print("                 cos(arg z_k), and arg z_k depends on r, so this is")
    print("                 an OPEN MEASUREMENT in BOTH forms.")
    print()

    vac = {}
    for form in forms:
        vac[form] = {}
        print(f"--- {form} form " + "-" * (62 - len(form)))
        print(f"{'depth':>6}{'cells':>7}{'ref r':>7}"
              f"{'max|dP_z|':>14}{'max|dP_c|':>14}"
              f"{'top1(z) spread':>18}{'top1(c) spread':>18}")
        for d in depths:
            rs = []
            for r in range(d + 1, rmax + 1):
                st, _ = stats(form, r, d)
                if st is not None:
                    rs.append((r, st))
            if len(rs) < 2:
                print(f"{d:>6}{len(rs):>7}   (too few defined cells)")
                continue
            ref_r, ref = rs[0]
            dz = max(profile_maxdiff(ref["_profile_z"], st["_profile_z"])
                     for _, st in rs[1:])
            dc = max(profile_maxdiff(ref["_profile_c"], st["_profile_c"])
                     for _, st in rs[1:])
            t1z = [st["top1_absz"] for _, st in rs]
            t1c = [st["top1"] for _, st in rs]
            print(f"{d:>6}{len(rs):>7}{ref_r:>7}"
                  f"{dz:>14.3e}{dc:>14.3e}"
                  f"  {min(t1z):.6e}-{max(t1z):.6e}"
                  f"  {min(t1c):.6e}-{max(t1c):.6e}")
            vac[form][d] = {
                "cells": len(rs), "ref_r": ref_r,
                "max_profile_diff_absz": dz,
                "max_profile_diff_c": dc,
                "top1_absz_min": min(t1z), "top1_absz_max": max(t1z),
                "top1_c_min": min(t1c), "top1_c_max": max(t1c),
            }
        print()

    tol = mpf(10) ** (-(args.dps - 12))
    print("READING:")
    for form in forms:
        for d in sorted(vac[form]):
            v = vac[form][d]
            zc = "CONFIRMED" if v["max_profile_diff_absz"] < tol else "REFUTED"
            cc = "CONFIRMED" if v["max_profile_diff_c"] < tol else "REFUTED"
            print(f"  {form:>3} d={d}: |z| profile r-independent {zc:>9} "
                  f"({v['max_profile_diff_absz']:.2e});  "
                  f"|c| profile r-independent {cc:>9} "
                  f"({v['max_profile_diff_c']:.2e})")
    print(f"  tolerance for CONFIRMED: 1e-{args.dps - 12} "
          f"(working dps {args.dps}, 12 digits of margin)")
    print()
    print("WHAT THIS MEANS FOR THE DESIGN: the coherence statistic |S|/A is")
    print("well posed exactly where the |c| profile is NOT r-independent -")
    print("read the |c| column above before reading any number in section 2.")

    # ------------------------------------------- 2. targets and controls
    print()
    print("=" * 78)
    print("2. TARGETS AND CONTROLS - psi and pi side by side")
    print("=" * 78)
    print("The four exact zeros are lean/Zeros.lean's measured_zeros; the two")
    print("controls are nonzero_7_3 = 5 and nonzero_19_6 = 343. Three of the")
    print("four zeros sit at r = 2, 4, 8 and are OUTSIDE the regime where the")
    print("explicit formula tracks pi(x). They are reported and they are not")
    print("equally meaningful. (20,6) with (19,6) is the one pair inside it.")
    print()
    hdr = (f"{'cell':>8}{'lean':>7}{'role':>9}"
           f"{'coh(psi)':>13}{'top1(psi)':>13}"
           f"{'coh(pi)':>13}{'top1(pi)':>13}")
    print(hdr)
    print("-" * len(hdr))
    cells_out = []
    for r, d in TARGETS + CONTROLS:
        role = "zero" if (r, d) in TARGETS else "control"
        row = {"r": r, "d": d, "role": role,
               "lean_cell_value": LEAN_CELL[(r, d)],
               "regime": REGIME[(r, d)], "forms": {}}
        cols = []
        for form in ("psi", "pi"):
            if form not in forms:
                cols += ["-", "-"]
                continue
            st, why = stats(form, r, d)
            if st is None:
                row["forms"][form] = {"defined": False, "reason": why}
                cols += ["undefined", "-"]
            else:
                row["forms"][form] = dict(defined=True, **strip_profiles(st))
                cols += [f"{st['coherence']:.6e}", f"{st['top1']:.6e}"]
        print(f"{str((r, d)):>8}{LEAN_CELL[(r, d)]:>7}{role:>9}"
              f"{cols[0]:>13}{cols[1]:>13}{cols[2]:>13}{cols[3]:>13}")
        cells_out.append(row)
    print()
    for r, d in TARGETS + CONTROLS:
        print(f"  ({r},{d})  {REGIME[(r, d)]}")
    for row in cells_out:
        for form, v in row["forms"].items():
            if not v.get("defined"):
                print(f"  ({row['r']},{row['d']})  {form}: {v['reason']}")

    # ---------------------------------- 3. the (20,6) vs (19,6) separation
    print()
    print("=" * 78)
    print("3. THE (20,6) vs (19,6) SEPARATION - the one pair inside the regime")
    print("=" * 78)
    sep = {}
    hdr3 = (f"{'form':>6}{'coh(20,6)':>14}{'coh(19,6)':>14}{'ratio':>10}"
            f"{'top1(20,6)':>14}{'top1(19,6)':>14}")
    print(hdr3)
    print("-" * len(hdr3))
    for form in forms:
        a, _ = stats(form, 20, 6)
        b, _ = stats(form, 19, 6)
        if a is None or b is None:
            continue
        ratio = a["coherence"] / b["coherence"] if b["coherence"] else None
        sep[form] = {"coherence_20_6": a["coherence"],
                     "coherence_19_6": b["coherence"],
                     "ratio": ratio,
                     "top1_20_6": a["top1"], "top1_19_6": b["top1"],
                     "coh_over_top1_20_6": a["coherence"] / a["top1"],
                     "coh_over_top1_19_6": b["coherence"] / b["top1"]}
        print(f"{form:>6}{a['coherence']:>14.6e}{b['coherence']:>14.6e}"
              f"{ratio:>10.4f}{a['top1']:>14.6e}{b['top1']:>14.6e}")
    print()
    print("coherence / top1 - 1.0 means a single mode carries the entire net:")
    for form in sep:
        print(f"  {form:>3}  (20,6) {sep[form]['coh_over_top1_20_6']:.4f}"
              f"    (19,6) {sep[form]['coh_over_top1_19_6']:.4f}")
    if len(sep) == 2:
        ag = ((sep["psi"]["ratio"] > 1) == (sep["pi"]["ratio"] > 1))
        print()
        print(f"  the two forms agree on the DIRECTION of the separation: "
              f"{'yes' if ag else 'NO'}")
        print(f"  psi ratio {sep['psi']['ratio']:.4f} vs "
              f"pi ratio {sep['pi']['ratio']:.4f}")

    # ------------------------------------------------- 4. the S_N curves
    print()
    print("=" * 78)
    print("4. S_N CONVERGENCE at (20,6) and (19,6)")
    print("=" * 78)
    for form in forms:
        print(f"--- {form} form " + "-" * (62 - len(form)))
        print(f"{'N':>6}"
              f"{'S_N (20,6)':>18}{'coh_N (20,6)':>16}"
              f"{'S_N (19,6)':>18}{'coh_N (19,6)':>16}")
        a, _ = stats(form, 20, 6)
        b, _ = stats(form, 19, 6)
        if a is None or b is None:
            print("   (undefined)")
            continue
        for n in sn_points:
            if n not in a["S_N"]:
                continue
            print(f"{n:>6}{a['S_N'][n]['S_N']:>18.6e}"
                  f"{a['S_N'][n]['coherence_N']:>16.6e}"
                  f"{b['S_N'][n]['S_N']:>18.6e}"
                  f"{b['S_N'][n]['coherence_N']:>16.6e}")
        print()

    # --------------------------------------------------- 5. the background
    print("=" * 78)
    print(f"5. BACKGROUND - every cell (r,d), d in {depths}, r = d+1 .. {rmax}")
    print("=" * 78)
    bg = {}
    for form in forms:
        bg[form] = {}
        print(f"--- {form} form " + "-" * (62 - len(form)))
        print(f"{'depth':>6}{'cells':>7}{'min coh':>14}{'median coh':>14}"
              f"{'max coh':>14}{'median top1':>14}")
        for d in depths:
            vals, t1, rows = [], [], []
            for r in range(d + 1, rmax + 1):
                st, why = stats(form, r, d)
                if st is None:
                    rows.append({"r": r, "d": d, "defined": False,
                                 "reason": why})
                    continue
                vals.append(st["coherence"])
                t1.append(st["top1"])
                rows.append({"r": r, "d": d, "defined": True,
                             "coherence": st["coherence"],
                             "top1": st["top1"],
                             "A": st["A"], "S": st["S"]})
            if not vals:
                print(f"{d:>6}{0:>7}   (no defined cells)")
                bg[form][d] = {"cells": 0, "rows": rows}
                continue
            print(f"{d:>6}{len(vals):>7}{min(vals):>14.6e}"
                  f"{statistics.median(vals):>14.6e}{max(vals):>14.6e}"
                  f"{statistics.median(t1):>14.6e}")
            bg[form][d] = {
                "cells": len(vals),
                "coherence_min": min(vals),
                "coherence_median": statistics.median(vals),
                "coherence_max": max(vals),
                "top1_median": statistics.median(t1),
                "undefined_cells": sum(1 for x in rows if not x["defined"]),
                "rows": rows,
            }
        print()

    print("Where the targets and controls sit inside their own depth's")
    print("background distribution:")
    for form in forms:
        for r, d in TARGETS + CONTROLS:
            st, _ = stats(form, r, d)
            if st is None or d not in bg[form] or not bg[form][d].get("cells"):
                continue
            vals = [x["coherence"] for x in bg[form][d]["rows"]
                    if x["defined"]]
            below = sum(1 for v in vals if v < st["coherence"])
            pct = 100.0 * below / len(vals)
            print(f"  {form:>3} ({r},{d}) coherence {st['coherence']:.6e} "
                  f"-> percentile {pct:5.1f} of {len(vals)} same-depth cells")

    # ------------------------------------------------ 6. precision check
    pcheck = {}
    if args.pcheck:
        print()
        print("=" * 78)
        print(f"6. PRECISION CHECK - targets and controls recomputed at "
              f"dps {args.dps + 30}")
        print("=" * 78)
        hi = args.dps + 30
        mp.dps = hi
        gam_hi = [mpmathify(s) for s in raw[:args.nzeros]]
        eng_hi = {f: build(f, gam_hi, rmax, depths) for f in forms}
        print(f"{'cell':>8}{'form':>6}{'coherence lo':>18}"
              f"{'coherence hi':>18}{'rel diff':>14}")
        for r, d in TARGETS + CONTROLS:
            for form in forms:
                lo, _ = stats(form, r, d)
                ok, _why = eng_hi[form].defined(r, d)
                if lo is None or not ok:
                    continue
                st_hi = cell_stats(eng_hi[form].amps(r, d), sn_points)
                rel = abs(st_hi["coherence"] - lo["coherence"]) \
                    / abs(st_hi["coherence"])
                pcheck[f"{form}_{r}_{d}"] = rel
                print(f"{str((r, d)):>8}{form:>6}{lo['coherence']:>18.10e}"
                      f"{st_hi['coherence']:>18.10e}{rel:>14.2e}")
        mp.dps = args.dps
        if pcheck:
            print(f"\n  max relative disagreement "
                  f"{max(pcheck.values()):.2e} across "
                  f"{len(pcheck)} cell-form pairs")

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
                "rmax": rmax,
                "depths": depths,
                "sn_points": sn_points,
                "forms": forms,
                "zeros_file": args.zeros,
                "precision_check": bool(args.pcheck),
                "out": args.out,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            },
            "constants": {
                "stencil": ("cell (r,d) = Delta^(d+1) of pi(2^.) at r; "
                            "lean/Construction.lean tableFrom + "
                            "lean/Zeros.lean dyadicRow"),
                "mode_psi": ("c_k(r,d) = -2 Re[ 2^(r*rho_k) "
                             "(1-2^(-rho_k))^(d+1) / rho_k ], rho_k = 1/2 + "
                             "i*gamma_k"),
                "mode_pi": ("c_k(r,d) = -2 Re[ sum_j (-1)^j C(d+1,j) "
                            "Ei(rho_k*(r-j)*ln2) ]; matches O34's osc"),
                "targets": TARGETS,
                "controls": CONTROLS,
                "lean_cell_values": {f"{r},{d}": v
                                     for (r, d), v in LEAN_CELL.items()},
                "regime": {f"{r},{d}": v for (r, d), v in REGIME.items()},
                "regime_source": ("O34/O35: the explicit formula reproduces "
                                  "94% of the row-20 residual at d=0, 92% at "
                                  "d=3, 80% at d=6, measured in the pi form. "
                                  "Directly citable against the pi column; an "
                                  "approximate transfer to the psi column."),
                "pi_undefined_reason": PI_UNDEFINED,
                "data_floor": ("zeros600.json carries ~25 significant digits; "
                               "no working precision improves on that"),
            },
            "summary": {
                "vacuousness_check": vac,
                "vacuousness_tolerance_exp": -(args.dps - 12),
                "separation_20_6_vs_19_6": sep,
                "background": {f: {str(d): {k: v for k, v in bg[f][d].items()
                                            if k != "rows"}
                                   for d in bg[f]} for f in bg},
                "precision_check_rel": pcheck,
            },
            "rows": {
                "cells": cells_out,
                "background": {f: {str(d): bg[f][d].get("rows", [])
                                   for d in bg[f]} for f in bg},
            },
        }
        guarded_write(_jsonable(payload), args.out, allow_nan=False)


if __name__ == "__main__":
    main()
