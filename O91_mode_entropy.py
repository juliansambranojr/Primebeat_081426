"""
O91 - MODE ENTROPY at the four exact zeros: how many of the 600 zeta modes
      actually participate in a table cell, and does that count separate a
      zero from its proved non-zero neighbour?

O90 measured coherence, an alignment ratio.  This measures information.

Reads with: notes/lab_notebook_2.md entry 195 (the design, and Julian's call
that entropy runs first); entry 194 (the r-invariance correction this script
verifies before it measures anything); entry 193 (the O90 run this extends);
entry 192 (the stencil index correction, Delta^(d+1) not Delta^d);
O90_mode_coherence.py (the mode construction, imported rather than re-derived);
lean/Zeros.lean (the four zeros and the two proved non-zero neighbours).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis registered in advance, no decision rule,
no verdict.  Per `CLAUDE.md` section "Prereg discipline", nothing this script
prints may be described as a verdict, and no verdict line is written anywhere
in its output.

THE STATISTIC
-------------
For a cell (r,d), over k = 1..K zero pairs, with z_k the complex mode term and
c_k = -2*Re(z_k) the real contribution actually summed -- both exactly as
O90_mode_coherence.py builds them --

    p_k  = |c_k| / sum_j |c_j|          a probability distribution over modes
    H    = - sum_k p_k * log(p_k)       Shannon entropy, natural log
    Neff = exp(H)                       effective number of participating modes

and the same three quantities a second time on

    q_k  = |z_k| / sum_j |z_j|          giving H_z and Neff_z

Both are computed in BOTH explicit-formula forms O90 implements, psi and pi, so
there are four (H, Neff) pairs per cell.

A SECOND EFFECTIVE-COUNT ESTIMATOR, reported alongside
------------------------------------------------------
    PR = (sum_k |c_k|)^2 / sum_k |c_k|^2

the participation ratio, and its |z| twin.  PR and Neff both return exactly n
on a distribution uniform over n modes and both return 1 on a point mass, so
they are two estimators of the same count and can be compared.  They disagree
in general: PR is the inverse collision probability (Renyi order 2), Neff the
exponential of the Shannon entropy (Renyi order 1), and order-2 always weighs
the head of the distribution more heavily, so PR <= Neff for any distribution.

REFERENCE POINTS
----------------
    Neff = K exactly if every mode contributed equally; at K = 600 that is
           H = log 600 = 6.396930.
    Neff = 1 if one mode carried everything; H = 0.

Neff is therefore reported raw AND as a fraction of K, so the reader sees where
between those two poles each cell sits.

THE r-INVARIANCE PREDICTION, verified BEFORE the main table
-----------------------------------------------------------
Entry 194 established by measurement, correcting entry 192, that the two
profiles behave differently and that the difference is form-dependent:

    psi  |z|  d = 1/3/6   max |d profile| 1.3e-51  5.0e-52  1.7e-51   INVARIANT
    psi  |c|  d = 1/3/6                   4.5e-02  8.8e-02  1.3e-01   r-DEPENDENT
    pi   |z|  d = 1/3/6                   1.7e-03  4.3e-03  3.2e-03   r-DEPENDENT
    pi   |c|  d = 1/3/6                   5.8e-02  1.0e-01  1.2e-01   r-DEPENDENT

The mechanism for the one invariant row is the factorisation entry 192 gives:
|z_k| = 2^(r/2) * |1 - 2^(-rho_k)|^(d+1) / |rho_k| in the psi form, so r enters
as a single common scale which cancels under normalisation.  Nothing factors in
the pi form.

Entropy is a functional of the normalised profile alone, so the prediction
transfers exactly: psi Neff_z must be IDENTICAL across every cell of a given
depth, and the other three must vary with r.  Section 2 tests all four
statements explicitly and prints CONFIRMED or REFUTED before any cell number is
shown.  A refutation means either O90 or this script is wrong, and the script
says so rather than proceeding quietly.

CROSS-CHECK AGAINST O90, run first as a gate
--------------------------------------------
The mode classes are imported from O90_mode_coherence.py, so the coherence
|S|/A recomputed here must reproduce `results/mode_coherence.json` exactly at
the six target and control cells.  Section 1 does that comparison and prints
the disagreement.  If mode_coherence.json is absent the gate reports SKIPPED
and the run continues; it never writes to that file.

REGIME LIMIT, inherited from O34/O35 and stated per cell
-------------------------------------------------------
(2,1), (4,1) and (8,3) sit at x = 4, 16 and 256, and the control (7,3) at
x = 128 -- outside the range where the explicit formula tracks pi(x).  They are
reported and labelled.  (20,6) with (19,6) is the one pair inside it.

(2,1) is UNDEFINED in the pi form.  The Delta^(d+1) stencil reaches m = 0,
x = 1, and Ei(rho * log 1) = Ei(0) = -inf for every zero.  O90 reports that
cell null with the reason; so does this.  It also kills the first cell of each
pi background row.

THE INDEX
---------
The exponent is d+1, NOT d.  `lean/Zeros.lean`'s dyadicRow is already one
backward difference of the cumulative ladder and `lean/Construction.lean`'s
tableFrom applies d more, so cell (r,d) is Delta^(d+1) of pi(2^.) at r.  Entry
192 carries that correction and its check table; coded with d instead, this
script would measure (2,0), (4,0), (8,2), (20,5), (7,2), (19,5) -- none of them
an exact zero -- and report them under the zeros' names.

PRECISION
---------
dps 50 working, zeros from `zeros600.json` whose strings carry ~25 significant
digits, which is the data floor no working precision improves on.  The budget
is O90's and is unchanged: argument reduction at r = 30, gamma_600 costs five
digits, the 2^15 scale five more, 600 summed terms about three, the pi form's
Delta^7 binomial weights two or three, leaving ~37 digits of arithmetic
headroom under a ~24-digit data floor.  Entropy adds one logarithm per mode and
one exponential per cell, neither of which is cancellation-prone: the p_k are
all positive and the sum has no sign changes, unlike the coherence numerator.
--precision-check recomputes every target and control at dps + 30 and prints
the relative disagreement, so the headroom is measured rather than asserted.

HOW IT WAS RUN
--------------
    .venv/bin/python utilities/run.py --python .venv/bin/python \
        O91_mode_entropy.py

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

from mpmath import mp, mpf, mpmathify, exp, log, fabs
from mpmath import re as mre

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

# The mode construction is O90's, imported rather than re-derived. Entry 195
# calls this "one small extension of O90"; importing is what makes that true
# rather than approximately true.
import O90_mode_coherence as O90
from O90_mode_coherence import (PsiModes, PiModes, TARGETS, CONTROLS,
                                LEAN_CELL, REGIME, PI_UNDEFINED, _jsonable)

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "mode_entropy.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")
O90_RESULTS = os.path.join(DEFAULT_RESULTS_DIR, "mode_coherence.json")

# Entry 194's measured table, quoted so the prediction under test is visible in
# the source of the script that tests it. Values are max |delta profile| across
# the cells of one depth, from notes/lab_notebook_2.md entry 194.
ENTRY_194 = {
    ("psi", "z"): ("1.3e-51 / 5.0e-52 / 1.7e-51", "INVARIANT"),
    ("psi", "c"): ("4.5e-02 / 8.8e-02 / 1.3e-01", "VARIES"),
    ("pi", "z"):  ("1.7e-03 / 4.3e-03 / 3.2e-03", "VARIES"),
    ("pi", "c"):  ("5.8e-02 / 1.0e-01 / 1.2e-01", "VARIES"),
}

PROFILE_NAME = {"c": "|c_k| = 2|Re z_k|  (the real contribution summed)",
                "z": "|z_k|              (the complex modulus)"}


class _GateSkip(Exception):
    """Raised to leave the section 1 gate early without failing it."""


def _sha256_of(path):
    try:
        with open(path, "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    return _sha256_of(os.path.abspath(__file__))


# ------------------------------------------------------------- the statistic

def entropy_stats(amps, K):
    """Every quantity this script measures, for one cell.

    From the complex amplitudes z_k: the real contributions c_k = -2 Re z_k,
    the two normalised profiles p (on |c|) and q (on |z|), and for each of them
    the entropy H, the effective mode count Neff = exp(H), the participation
    ratio PR, and the top-1 share.  The net S and mass A are carried too, so
    O90's coherence |S|/A is recomputable from this dict as the cross-check
    gate in section 1.
    """
    c = [-2 * mre(z) for z in amps]
    absc = [fabs(v) for v in c]
    absz = [fabs(z) for z in amps]
    S = sum(c)
    A = sum(absc)

    out = {"A": float(A), "S": float(S),
           "coherence": float(fabs(S) / A) if A != 0 else None,
           "n_modes": K}
    for tag, mags in (("c", absc), ("z", absz)):
        T = sum(mags)
        if T == 0:
            out[tag] = None
            continue
        p = [m / T for m in mags]
        # 0*log 0 = 0. No p_k can be negative; the sum has no sign changes, so
        # this is the one quantity here that is not cancellation-prone.
        H = -sum(v * log(v) for v in p if v > 0)
        Neff = exp(H)
        PR = (T * T) / sum(m * m for m in mags)
        out[tag] = {
            "total_mass": float(T),
            "H": float(H),
            "Neff": float(Neff),
            "Neff_frac": float(Neff) / K,
            "PR": float(PR),
            "PR_frac": float(PR) / K,
            "Neff_over_PR": float(Neff / PR),
            "top1": float(max(mags) / T),
        }
    return out


# ------------------------------------------------------------------- the run

def parse_args():
    ap = argparse.ArgumentParser(
        description=("O91 - mode entropy and effective mode count at the four "
                     "exact zeros, psi and pi forms, on |c| and |z|. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict."))
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
    ap.add_argument("--o90-json", type=str, default=O90_RESULTS,
                    help="O90's results JSON, read-only, for the section 1 "
                         "cross-check gate")
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
    forms = [t.strip() for t in args.forms.split(",") if t.strip()]

    with open(args.zeros) as fh:
        raw = json.load(fh)
    gammas = [mpmathify(s) for s in raw[:args.nzeros]]
    K = len(gammas)

    for r, d in TARGETS + CONTROLS:
        if d not in depths:
            depths.append(d)
    depths = sorted(set(depths))
    rmax = max(args.rmax, max(r for r, _ in TARGETS + CONTROLS))

    H_uniform = float(log(mpf(K)))

    print("=" * 78)
    print("O91 - MODE ENTROPY AT THE FOUR EXACT ZEROS")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT. Nothing")
    print("printed below may be described as a verdict.")
    print("=" * 78)
    print(f"  zeros        {K} pairs from {os.path.basename(args.zeros)}, "
          f"gamma_1 = {mp.nstr(gammas[0], 12)} .. "
          f"gamma_{K} = {mp.nstr(gammas[-1], 12)}")
    print(f"  dps          {args.dps} working; the zero strings carry ~25 "
          f"significant digits, which is the data floor")
    print(f"  stencil      cell (r,d) = Delta^(d+1) of pi(2^.) at r "
          f"(lean/Construction.lean + lean/Zeros.lean)")
    print(f"  modes        imported from O90_mode_coherence.py "
          f"(sha256 {_sha256_of(O90.__file__)[:16]}...)")
    print(f"  forms        {', '.join(forms)}")
    print(f"  background   depths {depths}, r = d+1 .. {rmax}")
    print()
    print("  STATISTIC   p_k = |c_k| / sum_j |c_j| ;  H = -sum p log p ;  "
          "Neff = exp(H)")
    print("              q_k = |z_k| / sum_j |z_j| ;  H_z, Neff_z the same "
          "way")
    print("              PR  = (sum|c_k|)^2 / sum|c_k|^2, a second "
          "effective-count estimator")
    print()
    print("  REFERENCE   every mode equal:  Neff = "
          f"{K}   H = log {K} = {H_uniform:.6f}   Neff/{K} = 1.000")
    print("              one mode carries all: Neff = 1     H = 0"
          f"           Neff/{K} = {1.0 / K:.6f}")

    engines = {}
    for f in forms:
        print(f"\n  building {f}-form modes ...", flush=True)
        engines[f] = build(f, gammas, rmax, depths)

    cache = {}

    def stats(form, r, d):
        key = (form, r, d)
        if key in cache:
            return cache[key]
        eng = engines[form]
        ok, why = eng.defined(r, d)
        st = None if not ok else entropy_stats(eng.amps(r, d), K)
        cache[key] = (st, why)
        return cache[key]

    # ------------------------------------- 1. CROSS-CHECK GATE against O90
    print()
    print("=" * 78)
    print("1. GATE - coherence recomputed here against results/"
          "mode_coherence.json")
    print("=" * 78)
    print("The mode classes are O90's, imported. |S|/A recomputed from them")
    print("must reproduce O90's stored numbers at the six cells. This is a")
    print("check on the reuse, not a new measurement.")
    print()
    gate = {"status": None, "pairs": {}, "max_rel_diff": None,
            "o90_json": args.o90_json}
    try:
        with open(args.o90_json) as fh:
            o90 = json.load(fh)
        o90_nz = o90.get("params", {}).get("nzeros")
        gate["o90_nzeros"] = o90_nz
        gate["o91_nzeros"] = K
        if o90_nz is not None and o90_nz != K:
            # The statistic is a sum over zero pairs, so a run at a different
            # truncation is a different number and comparing them would
            # manufacture a mismatch. Refuse rather than report one.
            gate["status"] = "NOT COMPARABLE"
            print(f"  O90's stored run used nzeros = {o90_nz}; this run uses "
                  f"{K}.")
            print("  Coherence is a sum over zero pairs, so the two are")
            print("  different numbers by construction. Gate NOT COMPARABLE,")
            print("  run continues. Re-run at the stored nzeros to gate it.")
            raise _GateSkip
        stored = {}
        for row in o90.get("rows", {}).get("cells", []):
            for form, v in row.get("forms", {}).items():
                if v.get("defined"):
                    stored[(form, row["r"], row["d"])] = v["coherence"]
        print(f"{'cell':>8}{'form':>6}{'O90 stored':>18}{'O91 recomputed':>18}"
              f"{'rel diff':>14}")
        worst = 0.0
        for r, d in TARGETS + CONTROLS:
            for form in forms:
                key = (form, r, d)
                if key not in stored:
                    continue
                st, _ = stats(form, r, d)
                if st is None or st["coherence"] is None:
                    continue
                a, b = stored[key], st["coherence"]
                rel = abs(a - b) / abs(a) if a else None
                gate["pairs"][f"{form}_{r}_{d}"] = {
                    "o90": a, "o91": b, "rel_diff": rel}
                if rel is not None:
                    worst = max(worst, rel)
                print(f"{str((r, d)):>8}{form:>6}{a:>18.10e}{b:>18.10e}"
                      f"{rel:>14.2e}")
        gate["max_rel_diff"] = worst
        gate["status"] = "PASS" if worst < 1e-12 else "MISMATCH"
        print(f"\n  max relative disagreement {worst:.2e} across "
              f"{len(gate['pairs'])} cell-form pairs -> {gate['status']}")
        if gate["status"] != "PASS":
            print("  THE GATE DID NOT PASS. The mode construction imported")
            print("  here does not reproduce O90's numbers; every number")
            print("  below is suspect until that is resolved.")
    except _GateSkip:
        pass
    except FileNotFoundError:
        gate["status"] = "SKIPPED"
        print(f"  {args.o90_json} not present - gate SKIPPED, run continues.")
    except Exception as exc:
        gate["status"] = f"ERROR: {exc}"
        print(f"  gate could not run: {exc}")

    # ------------------------------- 2. THE r-INVARIANCE PREDICTION, first
    print()
    print("=" * 78)
    print("2. THE r-INVARIANCE PREDICTION - tested BEFORE the main table")
    print("=" * 78)
    print("Entry 194 measured that in the psi form the |z| profile is")
    print("r-INVARIANT while |c| is r-DEPENDENT, and that in the pi form BOTH")
    print("are r-dependent. Entropy is a functional of the normalised profile")
    print("alone, so the prediction transfers exactly:")
    print()
    print("    psi  Neff_z   IDENTICAL across all cells of a given depth")
    print("    psi  Neff_c   varies with r")
    print("    pi   Neff_z   varies with r")
    print("    pi   Neff_c   varies with r")
    print()
    print("Entry 194's measured max |delta profile|, d = 1/3/6, quoted:")
    for (form, tag), (nums, verdictless) in ENTRY_194.items():
        print(f"    {form:>3}  |{tag}|   {nums:>28}   {verdictless}")
    print()

    # tolerances. The invariance is exact in exact arithmetic, so IDENTICAL is
    # a roundoff-level claim; VARIES needs only to clear roundoff by orders of
    # magnitude, and entry 194's varying rows sit at 1e-3 to 1e-1 in profile.
    TOL_IDENTICAL = 10.0 ** (-(args.dps - 15))
    TOL_VARIES = 1e-6

    inv = {}
    predicted = {("psi", "z"): "IDENTICAL", ("psi", "c"): "VARIES",
                 ("pi", "z"): "VARIES", ("pi", "c"): "VARIES"}
    for form in forms:
        inv[form] = {}
        print(f"--- {form} form " + "-" * (62 - len(form)))
        print(f"{'prof':>5}{'depth':>6}{'cells':>7}{'min Neff':>15}"
              f"{'median Neff':>15}{'max Neff':>15}{'max-min':>13}"
              f"{'rel spread':>13}")
        for tag in ("z", "c"):
            inv[form][tag] = {}
            for d in depths:
                vals, prs = [], []
                for r in range(d + 1, rmax + 1):
                    st, _ = stats(form, r, d)
                    if st is None or st.get(tag) is None:
                        continue
                    vals.append(st[tag]["Neff"])
                    prs.append(st[tag]["PR"])
                if len(vals) < 2:
                    print(f"{tag:>5}{d:>6}{len(vals):>7}   "
                          f"(too few defined cells)")
                    continue
                med = statistics.median(vals)
                spread = max(vals) - min(vals)
                rel = spread / med if med else None
                print(f"{tag:>5}{d:>6}{len(vals):>7}{min(vals):>15.6f}"
                      f"{med:>15.6f}{max(vals):>15.6f}"
                      f"{spread:>13.3e}{rel:>13.3e}")
                inv[form][tag][d] = {
                    "cells": len(vals),
                    "Neff_min": min(vals), "Neff_median": med,
                    "Neff_max": max(vals),
                    "Neff_spread": spread, "Neff_rel_spread": rel,
                    "PR_min": min(prs), "PR_max": max(prs),
                    "PR_rel_spread": ((max(prs) - min(prs))
                                      / statistics.median(prs))
                    if statistics.median(prs) else None,
                }
        print()

    print("READING - each statement is CONFIRMED or REFUTED on its own:")
    outcomes = {}
    all_ok = True
    for form in forms:
        for tag in ("z", "c"):
            want = predicted[(form, tag)]
            rels = [v["Neff_rel_spread"] for v in inv[form][tag].values()
                    if v["Neff_rel_spread"] is not None]
            if not rels:
                continue
            worst = max(rels)
            if want == "IDENTICAL":
                ok = worst < TOL_IDENTICAL
            else:
                ok = worst > TOL_VARIES
            all_ok = all_ok and ok
            outcomes[f"{form}_{tag}"] = {
                "predicted": want, "max_rel_spread": worst,
                "reading": "CONFIRMED" if ok else "REFUTED"}
            print(f"  {form:>3}  Neff on |{tag}|  predicted {want:>9}  "
                  f"max rel spread over depths {worst:.3e}  -> "
                  f"{'CONFIRMED' if ok else 'REFUTED'}")
    print(f"\n  tolerances: IDENTICAL requires rel spread < "
          f"{TOL_IDENTICAL:.0e} (dps {args.dps}, 15 digits of margin); "
          f"VARIES requires > {TOL_VARIES:.0e}")
    print(f"  ALL FOUR STATEMENTS: "
          f"{'CONFIRMED' if all_ok else 'NOT ALL CONFIRMED'}")
    if not all_ok:
        print()
        print("  THE PREDICTION DID NOT HOLD. Entry 194 measured these four")
        print("  profiles directly and this script derives its four entropies")
        print("  from the same imported mode construction, so a disagreement")
        print("  means something is wrong in O90 or in this script rather")
        print("  than being a finding about the table. Read no number in")
        print("  section 3 onward as a measurement until it is resolved.")
    print()
    print("  Note the invariance is a statement about cells of ONE depth. Neff")
    print("  on the psi |z| profile still differs BETWEEN depths, because the")
    print("  factor |1 - 2^(-rho)|^(d+1) carries d and does not cancel.")

    # -------------------------------------------- 3. TARGETS AND CONTROLS
    print()
    print("=" * 78)
    print("3. TARGETS AND CONTROLS - four exact zeros, two proved non-zeros")
    print("=" * 78)
    print("The four zeros are lean/Zeros.lean's measured_zeros; the controls")
    print("are nonzero_7_3 = 5 and nonzero_19_6 = 343. Three of the four")
    print("zeros sit at r = 2, 4, 8 and are OUTSIDE the regime where the")
    print("explicit formula tracks pi(x); they are reported and they are not")
    print("equally meaningful. (20,6) with (19,6) is the one pair inside it.")
    print()
    cells_out = []
    for tag in ("c", "z"):
        print(f"--- profile {tag}:  {PROFILE_NAME[tag]}")
        hdr = (f"{'cell':>8}{'lean':>7}{'role':>9}"
               f"{'H(psi)':>11}{'Neff(psi)':>12}{'/600':>9}{'PR(psi)':>11}"
               f"{'H(pi)':>11}{'Neff(pi)':>12}{'/600':>9}{'PR(pi)':>11}")
        print(hdr)
        print("-" * len(hdr))
        for r, d in TARGETS + CONTROLS:
            cols = []
            for form in ("psi", "pi"):
                if form not in forms:
                    cols += ["-", "-", "-", "-"]
                    continue
                st, why = stats(form, r, d)
                if st is None:
                    cols += ["undefined", "-", "-", "-"]
                else:
                    v = st[tag]
                    cols += [f"{v['H']:.6f}", f"{v['Neff']:.4f}",
                             f"{v['Neff_frac']:.4f}", f"{v['PR']:.4f}"]
            role = "zero" if (r, d) in TARGETS else "control"
            print(f"{str((r, d)):>8}{LEAN_CELL[(r, d)]:>7}{role:>9}"
                  f"{cols[0]:>11}{cols[1]:>12}{cols[2]:>9}{cols[3]:>11}"
                  f"{cols[4]:>11}{cols[5]:>12}{cols[6]:>9}{cols[7]:>11}")
        print()

    for r, d in TARGETS + CONTROLS:
        role = "zero" if (r, d) in TARGETS else "control"
        row = {"r": r, "d": d, "role": role,
               "lean_cell_value": LEAN_CELL[(r, d)],
               "regime": REGIME[(r, d)], "forms": {}}
        for form in forms:
            st, why = stats(form, r, d)
            if st is None:
                row["forms"][form] = {"defined": False, "reason": why}
            else:
                row["forms"][form] = dict(defined=True, **st)
        cells_out.append(row)

    print("Regime, per cell:")
    for r, d in TARGETS + CONTROLS:
        print(f"  ({r},{d})  {REGIME[(r, d)]}")
    for row in cells_out:
        for form, v in row["forms"].items():
            if not v.get("defined"):
                print(f"  ({row['r']},{row['d']})  {form}: {v['reason']}")

    # ------------------------------------------------- 4. THE BACKGROUND
    print()
    print("=" * 78)
    print(f"4. BACKGROUND - every cell (r,d), d in {depths}, r = d+1 .. {rmax}")
    print("=" * 78)
    bg = {}
    for form in forms:
        bg[form] = {}
        print(f"--- {form} form " + "-" * (62 - len(form)))
        print(f"{'prof':>5}{'depth':>6}{'cells':>7}{'min Neff':>13}"
              f"{'median Neff':>13}{'max Neff':>13}"
              f"{'med Neff/600':>14}{'median PR':>12}")
        for tag in ("c", "z"):
            bg[form][tag] = {}
            for d in depths:
                vals, prs, rows = [], [], []
                for r in range(d + 1, rmax + 1):
                    st, why = stats(form, r, d)
                    if st is None:
                        rows.append({"r": r, "d": d, "defined": False,
                                     "reason": why})
                        continue
                    v = st[tag]
                    vals.append(v["Neff"])
                    prs.append(v["PR"])
                    rows.append({"r": r, "d": d, "defined": True,
                                 "H": v["H"], "Neff": v["Neff"],
                                 "Neff_frac": v["Neff_frac"], "PR": v["PR"],
                                 "top1": v["top1"]})
                if not vals:
                    print(f"{tag:>5}{d:>6}{0:>7}   (no defined cells)")
                    bg[form][tag][d] = {"cells": 0, "rows": rows}
                    continue
                print(f"{tag:>5}{d:>6}{len(vals):>7}{min(vals):>13.4f}"
                      f"{statistics.median(vals):>13.4f}{max(vals):>13.4f}"
                      f"{statistics.median(vals) / K:>14.4f}"
                      f"{statistics.median(prs):>12.4f}")
                bg[form][tag][d] = {
                    "cells": len(vals),
                    "Neff_min": min(vals),
                    "Neff_median": statistics.median(vals),
                    "Neff_max": max(vals),
                    "Neff_frac_median": statistics.median(vals) / K,
                    "PR_min": min(prs),
                    "PR_median": statistics.median(prs),
                    "PR_max": max(prs),
                    "undefined_cells": sum(1 for x in rows
                                           if not x["defined"]),
                    "rows": rows,
                }
        print()

    # -------------------------------------------------- 5. THE PERCENTILES
    print("=" * 78)
    print("5. WHERE THE TARGETS AND CONTROLS SIT IN THEIR OWN DEPTH'S "
          "BACKGROUND")
    print("=" * 78)
    print("Percentile = share of same-depth defined cells with a SMALLER Neff.")
    print()
    print("DEGENERATE marks a row where every same-depth cell carries the")
    print("SAME Neff to printed precision. That is the r-invariant case of")
    print("section 2, where the percentile is 0.0 by the strict-less-than")
    print("rule and orders nothing. Read those rows as 'no position'.")
    print()
    pct_out = {}
    hdr5 = (f"{'form':>5}{'prof':>5}{'cell':>9}{'Neff':>12}"
            f"{'percentile':>12}{'of cells':>10}{'ties':>7}  note")
    print(hdr5)
    print("-" * len(hdr5))
    for form in forms:
        for tag in ("c", "z"):
            for r, d in TARGETS + CONTROLS:
                st, _ = stats(form, r, d)
                if st is None or d not in bg[form][tag]:
                    continue
                if not bg[form][tag][d].get("cells"):
                    continue
                vals = [x["Neff"] for x in bg[form][tag][d]["rows"]
                        if x["defined"]]
                mine = st[tag]["Neff"]
                below = sum(1 for v in vals if v < mine)
                # a tie at 1e-12 relative is a tie for every purpose here
                ties = sum(1 for v in vals
                           if abs(v - mine) <= 1e-12 * abs(mine))
                degen = ties == len(vals)
                pct = 100.0 * below / len(vals)
                pct_out[f"{form}_{tag}_{r}_{d}"] = {
                    "Neff": mine, "percentile": pct, "n_cells": len(vals),
                    "ties": ties, "degenerate": degen}
                print(f"{form:>5}{tag:>5}{str((r, d)):>9}{mine:>12.4f}"
                      f"{pct:>11.1f}%{len(vals):>10}{ties:>7}  "
                      f"{'DEGENERATE - all same-depth cells equal' if degen else ''}")
    print()
    print("The (20,6) / (19,6) pair, which is the one inside the regime:")
    for form in forms:
        for tag in ("c", "z"):
            a = pct_out.get(f"{form}_{tag}_20_6")
            b = pct_out.get(f"{form}_{tag}_19_6")
            if not a or not b:
                continue
            note = "  [DEGENERATE: r-invariant, percentiles order nothing]" \
                if (a["degenerate"] and b["degenerate"]) else ""
            print(f"  {form:>3} |{tag}|  (20,6) Neff {a['Neff']:.4f} at "
                  f"pct {a['percentile']:.1f}   (19,6) Neff {b['Neff']:.4f} "
                  f"at pct {b['percentile']:.1f}   ratio "
                  f"{a['Neff'] / b['Neff']:.4f}{note}")

    # ------------------------- 6. DO Neff AND PR AGREE AS COUNT ESTIMATORS
    print()
    print("=" * 78)
    print("6. Neff AGAINST PR - two estimators of the same effective count")
    print("=" * 78)
    print("Both return n on a uniform distribution over n modes and 1 on a")
    print("point mass. PR is the inverse collision probability (Renyi order")
    print("2), Neff the exponential of the Shannon entropy (order 1), so PR")
    print("<= Neff for any distribution and the gap measures how heavy the")
    print("head is. The question here is whether they RANK cells the same.")
    print()
    agree = {}
    hdr6 = (f"{'form':>5}{'prof':>5}{'cells':>7}{'min Neff/PR':>14}"
            f"{'median':>12}{'max Neff/PR':>14}{'rank corr':>12}"
            f"{'PR<=Neff':>10}")
    print(hdr6)
    print("-" * len(hdr6))
    for form in forms:
        for tag in ("c", "z"):
            pairs = []
            for d in depths:
                for x in bg[form][tag].get(d, {}).get("rows", []):
                    if x.get("defined"):
                        pairs.append((x["Neff"], x["PR"]))
            if len(pairs) < 3:
                continue
            ratios = [n / p for n, p in pairs]
            n_rank = {v: i for i, v in
                      enumerate(sorted(p[0] for p in pairs))}
            p_rank = {v: i for i, v in
                      enumerate(sorted(p[1] for p in pairs))}
            rn = [n_rank[n] for n, _ in pairs]
            rp = [p_rank[p] for _, p in pairs]
            m = len(pairs)
            mn = sum(rn) / m
            mp_ = sum(rp) / m
            num = sum((a - mn) * (b - mp_) for a, b in zip(rn, rp))
            den = (math.sqrt(sum((a - mn) ** 2 for a in rn))
                   * math.sqrt(sum((b - mp_) ** 2 for b in rp)))
            rho = num / den if den else None
            ok = all(p <= n * (1 + 1e-12) for n, p in pairs)
            agree[f"{form}_{tag}"] = {
                "cells": m,
                "Neff_over_PR_min": min(ratios),
                "Neff_over_PR_median": statistics.median(ratios),
                "Neff_over_PR_max": max(ratios),
                "spearman_rank_corr": rho,
                "PR_le_Neff_everywhere": ok,
            }
            print(f"{form:>5}{tag:>5}{m:>7}{min(ratios):>14.4f}"
                  f"{statistics.median(ratios):>12.4f}{max(ratios):>14.4f}"
                  f"{rho:>12.4f}{str(ok):>10}")
    print()
    print("Per target and control, Neff / PR:")
    for form in forms:
        for r, d in TARGETS + CONTROLS:
            st, _ = stats(form, r, d)
            if st is None:
                continue
            print(f"  {form:>3} ({r},{d})  |c| Neff {st['c']['Neff']:8.4f} "
                  f"PR {st['c']['PR']:8.4f} ratio "
                  f"{st['c']['Neff_over_PR']:.4f}   "
                  f"|z| Neff {st['z']['Neff']:8.4f} "
                  f"PR {st['z']['PR']:8.4f} ratio "
                  f"{st['z']['Neff_over_PR']:.4f}")

    # ------------------------------------------------ 7. precision check
    pcheck = {}
    if args.pcheck:
        print()
        print("=" * 78)
        print(f"7. PRECISION CHECK - targets and controls recomputed at "
              f"dps {args.dps + 30}")
        print("=" * 78)
        hi = args.dps + 30
        mp.dps = hi
        gam_hi = [mpmathify(s) for s in raw[:args.nzeros]]
        eng_hi = {f: build(f, gam_hi, rmax, depths) for f in forms}
        print(f"{'cell':>8}{'form':>6}{'prof':>5}{'Neff lo':>16}"
              f"{'Neff hi':>16}{'rel diff':>12}{'H rel diff':>12}")
        for r, d in TARGETS + CONTROLS:
            for form in forms:
                lo, _ = stats(form, r, d)
                ok, _why = eng_hi[form].defined(r, d)
                if lo is None or not ok:
                    continue
                st_hi = entropy_stats(eng_hi[form].amps(r, d), K)
                for tag in ("c", "z"):
                    a, b = lo[tag], st_hi[tag]
                    rel = abs(b["Neff"] - a["Neff"]) / abs(b["Neff"])
                    relH = abs(b["H"] - a["H"]) / abs(b["H"])
                    pcheck[f"{form}_{tag}_{r}_{d}"] = {
                        "Neff_rel": rel, "H_rel": relH}
                    print(f"{str((r, d)):>8}{form:>6}{tag:>5}"
                          f"{a['Neff']:>16.8f}{b['Neff']:>16.8f}"
                          f"{rel:>12.2e}{relH:>12.2e}")
        mp.dps = args.dps
        if pcheck:
            wN = max(v["Neff_rel"] for v in pcheck.values())
            wH = max(v["H_rel"] for v in pcheck.values())
            print(f"\n  max relative disagreement  Neff {wN:.2e}   "
                  f"H {wH:.2e}   across {len(pcheck)} cell-form-profile "
                  f"triples")

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
                "mode_source_script": os.path.basename(O90.__file__),
                "mode_source_sha256": _sha256_of(O90.__file__),
                "dps": args.dps,
                "nzeros": K,
                "rmax": rmax,
                "depths": depths,
                "forms": forms,
                "zeros_file": args.zeros,
                "precision_check": bool(args.pcheck),
                "o90_json": args.o90_json,
                "out": args.out,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            },
            "constants": {
                "stencil": ("cell (r,d) = Delta^(d+1) of pi(2^.) at r; "
                            "lean/Construction.lean tableFrom + "
                            "lean/Zeros.lean dyadicRow"),
                "statistic_p": ("p_k = |c_k| / sum_j |c_j|, "
                                "c_k = -2 Re z_k; H = -sum p log p "
                                "(natural log); Neff = exp(H)"),
                "statistic_q": ("q_k = |z_k| / sum_j |z_j|; H_z and Neff_z "
                                "the same way"),
                "participation_ratio": ("PR = (sum_k |c_k|)^2 / sum_k "
                                        "|c_k|^2, and its |z| twin; a second "
                                        "effective-count estimator"),
                "reference_uniform": {"Neff": K, "H": H_uniform,
                                      "Neff_frac": 1.0},
                "reference_point_mass": {"Neff": 1, "H": 0.0,
                                         "Neff_frac": 1.0 / K},
                "mode_psi": ("z_k(r,d) = 2^(r*rho_k) (1-2^(-rho_k))^(d+1) "
                             "/ rho_k, rho_k = 1/2 + i*gamma_k"),
                "mode_pi": ("Z_k(r,d) = sum_j (-1)^j C(d+1,j) "
                            "Ei(rho_k*(r-j)*ln2); matches O34's osc"),
                "targets": TARGETS,
                "controls": CONTROLS,
                "lean_cell_values": {f"{r},{d}": v
                                     for (r, d), v in LEAN_CELL.items()},
                "regime": {f"{r},{d}": v for (r, d), v in REGIME.items()},
                "regime_source": ("O34/O35: the explicit formula reproduces "
                                  "94% of the row-20 residual at d=0, 92% at "
                                  "d=3, 80% at d=6, measured in the pi form."),
                "pi_undefined_reason": PI_UNDEFINED,
                "entry_194_profile_deviations": {
                    f"{f}_{t}": {"max_abs_profile_diff_d136": v[0],
                                 "reading": v[1]}
                    for (f, t), v in ENTRY_194.items()},
                "data_floor": ("zeros600.json carries ~25 significant digits; "
                               "no working precision improves on that"),
            },
            "summary": {
                "o90_gate": gate,
                "r_invariance": {
                    "predicted": {f"{f}_{t}": v
                                  for (f, t), v in predicted.items()},
                    "outcomes": outcomes,
                    "all_confirmed": all_ok,
                    "tol_identical": TOL_IDENTICAL,
                    "tol_varies": TOL_VARIES,
                    "per_depth": inv,
                },
                "percentiles": pct_out,
                "neff_vs_pr": agree,
                "background": {f: {t: {str(d): {k: v for k, v in
                                                bg[f][t][d].items()
                                                if k != "rows"}
                                       for d in bg[f][t]}
                                   for t in bg[f]} for f in bg},
                "precision_check_rel": pcheck,
            },
            "rows": {
                "cells": cells_out,
                "background": {f: {t: {str(d): bg[f][t][d].get("rows", [])
                                       for d in bg[f][t]}
                                   for t in bg[f]} for f in bg},
            },
        }
        guarded_write(_jsonable(payload), args.out, allow_nan=False)


if __name__ == "__main__":
    main()
