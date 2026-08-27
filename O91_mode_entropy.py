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

Neff AGAINST N -- THE TRUNCATION QUESTION  (--vs-n)
---------------------------------------------------
Entry 197 published Neff = 172.0 of 600 at (20,6) and recorded, as an explicit
open caveat, that Neff(N) was UNMEASURED: p_k normalises over the first 600
modes, so 172 is a statement at that truncation.  O90 measured its coherence
against N and flagged the result one-sided; O91 did not do the equivalent.
`--vs-n` does it.  Same statistic, cumulative:

    Neff(N) = exp(H_N),   H_N = -sum_{k<=N} p_k^(N) log p_k^(N),
    p_k^(N) = |c_k| / sum_{j<=N} |c_j|

for every N = 1..K, on the six target and control cells, in both forms, on both
profiles.  It is nearly free: the amplitudes are already built, and H_N follows
from two running sums, sum_{k<=N} m_k and sum_{k<=N} m_k log m_k.

THE PREDICTION, WORKED OUT BEFORE THE MEASUREMENT
-------------------------------------------------
Write the psi-form magnitude with the factorisation of entry 192:

    |z_k| = 2^(r/2) * B_k^(d+1) / |rho_k|,   B_k = |1 - 2^(-rho_k)|
    |c_k| = 2 |Re z_k| = 2 |z_k| * |cos(arg z_k)|

Two facts about B_k.  With rho = 1/2 + i*gamma, 2^(-rho) = 2^(-1/2) e^(-i*theta),
theta = gamma*log 2, so

    B_k = sqrt(3/2 - sqrt(2) * cos(theta_k))        in [1 - 1/sqrt2, 1 + 1/sqrt2]

-- bounded, oscillating, and STATIONARY in k, because theta_k = gamma_k log 2
equidistributes mod 2*pi.  It carries no k-trend.  Likewise |cos(arg z_k)| is
stationary in k, and its distribution is where r enters (arg z_k contains
r*gamma_k*log 2).

So under normalisation the 2^(r/2) scale cancels and

    p_k  proportional to  W_k / |rho_k|,   W_k = B_k^(d+1) * |cos(arg z_k)|

a stationary modulation W_k times a DECAY ENVELOPE 1/|rho_k| ~ 1/gamma_k.  The
shape of Neff(N) is decided by the envelope alone; the modulation moves the
level.

(1) WHAT THE ENVELOPE DOES.  For a profile p_k proportional to k^(-s):

        s < 1 :  H_N = log N - s/(1-s) - log(1-s)
                 Neff(N) = (1-s) e^(-s/(1-s)) * N          LINEAR in N
        s = 1 :  H_N ~ (1/2) log N + log log N
                 Neff(N) ~ sqrt(N) * log N                 SUBLINEAR
        s > 1 :  H_N converges
                 Neff(N) -> a finite limit                 SATURATES

    Here gamma_k ~ 2*pi*k / log(k/(2*pi*e)), so the envelope's local log-slope is
    s(k) = dlog gamma / dlog k = 1 - 1/log(k/(2*pi*e)) -- strictly BELOW 1 at every
    finite k, and rising to 1 only as k -> infinity.  Measured on the actual
    zeros600.json list, s runs 0.688 over k = 25..50, 0.745 over 100..200, 0.793
    over 300..600.  So over the whole measured window the profile is in the s < 1
    regime, where Neff is proportional to N, but with s creeping upward the
    proportionality constant falls and the LOCAL exponent sits just below 1.
    Asymptotically the log correction takes over: for a_k ~ (log k)/k,
    H_N ~ (2/3) log N + 2 log log N, i.e. Neff ~ N^(2/3) (log N)^2.

    PREDICTED SHAPE: option 3, sublinear growth WITHOUT saturation.  Local
    exponent near 0.85-0.91 across the measured window, declining slowly; a
    single power-law fit over N = 25..600 should return roughly 0.87.  NOT
    option 1 (there is no limit), and not exactly option 2 either (Neff/N is
    not constant -- it falls).

(2) THE PREDICTED CURVE, NUMERICALLY.  Take the envelope alone, a_k = 1/|rho_k|
    on the real gamma list, and compute Neff_env(N) exactly.  It gives

        N        25      50     100     200     300     400     500     600
        Neff_env 21.56   40.59  75.61  139.34  198.31  254.23  307.92  359.84
        local exponent   0.913  0.897  0.882   0.870   0.864   0.859   0.855

    The modulation W_k is stationary and uncorrelated with the envelope, so its
    only effect is a constant multiplicative factor:

        Neff(N) = exp(-D) * Neff_env(N),   D = E[w log w],  w = W / E[W]

    with D independent of N.  D is computable from the distributions:

        B^(d+1) alone, d = 1 / 3 / 6 (n = 2 / 4 / 7):
            D = 0.2612 / 0.5137 / 0.7491   ->  exp(-D) = 0.7701 / 0.5983 / 0.4728
        |cos(arg z)| alone, phase equidistributed:
            D = 0.1447                     ->  exp(-D) = 0.8653

    Those are checks on entry 196's published levels, not new fits:
    psi |z| is B^(d+1) with no cosine, so predicted Neff = 0.7701/0.5983/0.4728
    times 359.84 = 277.1 / 215.3 / 170.1 at d = 1/3/6, against entry 196's
    measured 276.703 / 220.975 / 175.667.  psi |c| adds 0.8653, predicting a
    typical d = 6 cell at 147, against entry 197's median 0.2502*600 = 150.1.

    Anchoring on entry 197's own N = 600 number instead, (20,6) psi |c| has
    exp(-D) = 172.045 / 359.836 = 0.4781, which PREDICTS

        N          25     50     100     200     300     400     500     600
        Neff     10.31  19.41   36.15   66.62   94.81  121.55  147.22  172.05

    Every one of those is falsifiable.  The script reports kappa_N =
    Neff(N) / Neff_env(N) at each N; the prediction is that kappa_N is FLAT.

(3) THE RATIO.  Entry 197 argues the ratio Neff(20,6)/Neff(19,6) = 1.057 is
    safer than the absolute because both cells truncate identically.  Under the
    account above that is exactly right and for a stated reason: both cells
    share one envelope, so the ratio is exp(-D_(20,6)) / exp(-D_(19,6)), and
    both D are N-independent.  PREDICTION: the ratio is FLAT in N, at 1.057
    (psi |c|) and 1.095 (pi |c|), with small-N wobble that is finite-sample
    noise in the phase sample and shrinks like 1/sqrt(N).  On the psi |z|
    profile the ratio is EXACTLY 1.000 at every N, since that profile is
    r-invariant -- the degenerate column of entry 197, carried here as a null.

If the measurement disagrees with any of this, the disagreement is the finding
and is reported as one.

THE SIX-VALUE GATE, PRINTED FIRST under --vs-n
----------------------------------------------
The exponent is d+1 and not d (entry 192).  Under --vs-n the script recomputes
Delta^d and Delta^(d+1) of pi(2^.) from `pi2n_cache.json` at the six cells and
compares both columns against lean/Zeros.lean's proved values BEFORE building a
single mode.  Delta^(d+1) must reproduce 0/0/0/0/5/343 and Delta^d must
reproduce none of them.

DEFAULT BEHAVIOUR IS UNCHANGED
------------------------------
--vs-n is a separate path with its own output file,
`results/mode_entropy_vs_N.json`.  Without the flag not one byte of the
sections above differs, and `results/mode_entropy.json` is never touched by the
--vs-n path.

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

from mpmath import mp, mpf, mpmathify, exp, log, fabs, sqrt
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
# --vs-n writes here. Entries 193/196 own mode_coherence.json and
# mode_entropy.json; this path is separate so neither is touched.
DEFAULT_VS_N_OUT = os.path.join(DEFAULT_RESULTS_DIR,
                                "mode_entropy_vs_N.json")
DEFAULT_PI2N = os.path.join(_HERE, "pi2n_cache.json")

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
    ap.add_argument("--vs-n", dest="vs_n", action="store_true",
                    help="measure Neff(N) against the truncation N "
                         "instead of the default single-N tables, and "
                         "write results/mode_entropy_vs_N.json. The "
                         "default path is untouched by this flag")
    ap.add_argument("--vs-n-points", dest="vs_n_points", type=str,
                    default="25,50,100,200,300,400,500,600",
                    help="which N the --vs-n tables print; the curves "
                         "themselves are computed at every N")
    ap.add_argument("--vs-n-out", dest="vs_n_out", type=str,
                    default=DEFAULT_VS_N_OUT,
                    help="results JSON for --vs-n")
    ap.add_argument("--pi2n", type=str, default=DEFAULT_PI2N,
                    help="pi(2^n) cache, read-only, for the six-value "
                         "kernel gate")
    a = ap.parse_args()
    if a.out == DEFAULT_OUT_JSON and a.results_dir != DEFAULT_RESULTS_DIR:
        a.out = os.path.join(a.results_dir, os.path.basename(DEFAULT_OUT_JSON))
    return a


def build(form, gammas, rmax, depths):
    return PsiModes(gammas, rmax, depths) if form == "psi" \
        else PiModes(gammas, rmax, depths)


# =====================================================================
# Neff AGAINST N - the truncation measurement (--vs-n).  Everything below
# runs only under that flag; the default path above is untouched.
# =====================================================================

# The analytic prediction of the module docstring, pinned in the source of the
# script that tests it so a later reader sees what was claimed BEFORE the run.
PREDICTION = {
    "shape": ("option 3 - sublinear growth without saturation. Neff(N) rises "
              "with local log-log exponent just below 1 across the measured "
              "window and does not approach a limit."),
    "mechanism": ("p_k prop. W_k / |rho_k| with W_k = |1-2^(-rho)|^(d+1) * "
                  "|cos(arg z)| stationary in k and 1/|rho_k| ~ 1/gamma_k the "
                  "decay envelope. The envelope sets the SHAPE, the "
                  "modulation only the LEVEL, and the level factor exp(-D) is "
                  "independent of N."),
    "envelope_law": ("p_k prop. k^(-s): s<1 gives Neff = (1-s)e^(-s/(1-s))*N "
                     "(linear); s=1 gives Neff ~ sqrt(N) log N; s>1 "
                     "saturates. gamma_k ~ 2 pi k / log(k/(2 pi e)) puts s "
                     "below 1 at every finite k, rising to 1 only as "
                     "k -> infinity; asymptotically Neff ~ N^(2/3)(log N)^2."),
    "local_exponent_expected": {"25_50": 0.913, "50_100": 0.897,
                                "100_200": 0.882, "200_300": 0.870,
                                "300_600": 0.858},
    "powerlaw_fit_expected_25_600": 0.87,
    "Neff_env_expected": {"25": 21.556, "50": 40.593, "100": 75.607,
                          "200": 139.339, "300": 198.313, "400": 254.233,
                          "500": 307.915, "600": 359.836},
    "kappa_flat": ("kappa_N = Neff(N)/Neff_env(N) is predicted CONSTANT in N; "
                   "drift in kappa_N falsifies the account above."),
    "psi_c_20_6_expected": {"25": 10.31, "50": 19.41, "100": 36.15,
                            "200": 66.62, "300": 94.81, "400": 121.55,
                            "500": 147.22, "600": 172.05},
    "psi_c_20_6_anchor": ("exp(-D) = 172.045/359.836 = 0.4781 taken from entry "
                          "197's own N = 600 value; the curve is then a "
                          "prediction at every other N."),
    "modulation_deficits": {
        "B_pow_2_d1": {"D": 0.2612, "exp_minus_D": 0.7701},
        "B_pow_4_d3": {"D": 0.5137, "exp_minus_D": 0.5983},
        "B_pow_7_d6": {"D": 0.7491, "exp_minus_D": 0.4728},
        "abs_cos_phase": {"D": 0.1447, "exp_minus_D": 0.8653},
    },
    "ratio": ("Neff(20,6)/Neff(19,6) is predicted FLAT in N - both cells share "
              "one envelope and both level factors are N-independent - at "
              "1.057 (psi |c|) and 1.095 (pi |c|), and EXACTLY 1.000 at every "
              "N on the r-invariant psi |z| profile."),
}


def kernel_gate(pi2n_path):
    """Delta^(d+1) and Delta^d of pi(2^.) at the six cells, against the
    kernel-proved values in lean/Zeros.lean.  Entry 192's check table,
    recomputed rather than quoted."""
    out = {"pi2n_cache": pi2n_path, "cells": {}, "pass": None,
           "d_plus_1_matches": 0, "d_matches": 0, "n_cells": 0}
    try:
        with open(pi2n_path) as fh:
            pi = json.load(fh)
    except Exception as exc:
        out["pass"] = False
        out["error"] = f"cannot read {pi2n_path}: {exc}"
        return out

    def f(r):
        return int(pi[str(r)])

    def delta(n, r):
        return sum(((-1) ** j) * math.comb(n, j) * f(r - j)
                   for j in range(n + 1))

    ok_all = True
    for r, d in TARGETS + CONTROLS:
        lean = LEAN_CELL[(r, d)]
        dd = delta(d, r)
        dp = delta(d + 1, r)
        hit_dp = (dp == lean)
        hit_d = (dd == lean)
        ok_all = ok_all and hit_dp
        out["cells"][f"{r},{d}"] = {
            "lean": lean, "delta_d": dd, "delta_d_plus_1": dp,
            "d_plus_1_matches_lean": hit_dp, "d_matches_lean": hit_d}
        out["n_cells"] += 1
        out["d_plus_1_matches"] += int(hit_dp)
        out["d_matches"] += int(hit_d)
    # The gate is two-sided: d+1 must reproduce all six AND d must reproduce
    # none. A d column that also matched would mean the index is not
    # discriminating and the whole construction is unpinned.
    out["pass"] = bool(ok_all and out["d_matches"] == 0)
    return out


def print_kernel_gate(kg):
    print("=" * 78)
    print("0. GATE - the exponent is d+1, verified against the six "
          "kernel-proved values")
    print("=" * 78)
    print("lean/Zeros.lean's dyadicRow is ALREADY one backward difference of")
    print("pi(2^.), and lean/Construction.lean's tableFrom applies d more, so")
    print("cell (r,d) = Delta^(d+1).  Recomputed here from pi2n_cache.json,")
    print("not quoted from entry 192.  Delta^(d+1) must reproduce all six and")
    print("Delta^d must reproduce none.")
    print()
    if kg.get("error"):
        print(f"  GATE FAILED TO RUN: {kg['error']}")
        return
    print(f"{'cell':>8}{'lean':>8}{'Delta^d':>12}{'Delta^(d+1)':>14}"
          f"{'d+1 == lean':>14}{'d == lean':>12}")
    for r, d in TARGETS + CONTROLS:
        c = kg["cells"][f"{r},{d}"]
        print(f"{str((r, d)):>8}{c['lean']:>8}{c['delta_d']:>12}"
              f"{c['delta_d_plus_1']:>14}"
              f"{str(c['d_plus_1_matches_lean']):>14}"
              f"{str(c['d_matches_lean']):>12}")
    print(f"\n  Delta^(d+1) reproduces {kg['d_plus_1_matches']} of "
          f"{kg['n_cells']};  Delta^d reproduces {kg['d_matches']} of "
          f"{kg['n_cells']}  ->  "
          f"{'PASS' if kg['pass'] else 'FAILED'}")
    if not kg["pass"]:
        print("  THE GATE DID NOT PASS. The stencil index is wrong or the")
        print("  cache is wrong; every number below would be measured at")
        print("  cells that are not the four zeros. Read nothing further.")


def cumulative_curves(mags):
    """Neff(N) and PR(N) for N = 1..len(mags), from two running sums.

    H_N = log T_N - (1/T_N) sum_{k<=N} m_k log m_k with T_N = sum_{k<=N} m_k,
    which is the entropy of the normalised profile without ever forming it.
    PR_N = T_N^2 / sum_{k<=N} m_k^2.
    """
    T = mpf(0)
    Q = mpf(0)      # sum m log m
    S2 = mpf(0)     # sum m^2
    neff, pr = [], []
    for m in mags:
        T += m
        S2 += m * m
        if m > 0:
            Q += m * log(m)
        if T > 0:
            H = log(T) - Q / T
            neff.append(float(exp(H)))
            pr.append(float((T * T) / S2) if S2 > 0 else None)
        else:
            neff.append(None)
            pr.append(None)
    return neff, pr


def _fit_loglog(ns, ys):
    """Least squares of log y on log N.  Returns slope, intercept, r2."""
    pts = [(math.log(n), math.log(y)) for n, y in zip(ns, ys)
           if y is not None and y > 0 and n > 0]
    if len(pts) < 3:
        return None
    mx = sum(p[0] for p in pts) / len(pts)
    my = sum(p[1] for p in pts) / len(pts)
    sxx = sum((p[0] - mx) ** 2 for p in pts)
    sxy = sum((p[0] - mx) * (p[1] - my) for p in pts)
    if sxx == 0:
        return None
    b = sxy / sxx
    a = my - b * mx
    ss_res = sum((p[1] - (a + b * p[0])) ** 2 for p in pts)
    ss_tot = sum((p[1] - my) ** 2 for p in pts)
    return {"slope": b, "intercept": a,
            "r2": (1 - ss_res / ss_tot) if ss_tot else None,
            "n_points": len(pts), "N_lo": min(n for n, y in zip(ns, ys)
                                              if y is not None and y > 0),
            "N_hi": max(n for n, y in zip(ns, ys)
                        if y is not None and y > 0)}


def _at(curve, n):
    """Curve value at N = n (curve is 0-indexed by N-1)."""
    if n < 1 or n > len(curve):
        return None
    return curve[n - 1]


def vs_n_main(args):
    """The truncation measurement.  Writes results/mode_entropy_vs_N.json."""
    started = datetime.datetime.now(datetime.timezone.utc)
    mp.dps = args.dps

    depths = [int(t) for t in args.depths.split(",") if t.strip()]
    forms = [t.strip() for t in args.forms.split(",") if t.strip()]
    for r, d in TARGETS + CONTROLS:
        if d not in depths:
            depths.append(d)
    depths = sorted(set(depths))
    rmax = max(args.rmax, max(r for r, _ in TARGETS + CONTROLS))

    with open(args.zeros) as fh:
        raw = json.load(fh)
    gammas = [mpmathify(s) for s in raw[:args.nzeros]]
    K = len(gammas)

    req = [int(t) for t in args.vs_n_points.split(",") if t.strip()]
    req = sorted(n for n in set(req) if 1 <= n <= K)
    # Fit windows, expressed as fractions of K so a smoke run at small
    # --nzeros exercises the same code rather than dividing by an empty
    # window. At K = 600 they are exactly 25, 100 and 300.
    nlo1 = max(2, min(25, K // 4))
    nlo2 = max(3, K // 6)
    nmid = max(2, K // 2)

    print("=" * 78)
    print("O91 --vs-n : Neff AGAINST N, the truncation entry 197 left open")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT. Nothing")
    print("printed below may be described as a verdict.")
    print("=" * 78)
    print(f"  zeros        {K} pairs from {os.path.basename(args.zeros)}, "
          f"gamma_1 = {mp.nstr(gammas[0], 12)} .. "
          f"gamma_{K} = {mp.nstr(gammas[-1], 12)}")
    print(f"  dps          {args.dps} working")
    print(f"  cells        {TARGETS + CONTROLS}")
    print(f"  forms        {', '.join(forms)}   profiles  |c| and |z|")
    print(f"  N grid       every N = 1..{K}; the table prints "
          f"{', '.join(str(n) for n in req)}")
    print(f"  statistic    Neff(N) = exp(H_N), H_N the entropy of "
          f"p_k = |c_k| / sum_(j<=N) |c_j|")
    print()

    # ------------------------------------------------ 0. the six-value gate
    kg = kernel_gate(args.pi2n)
    print_kernel_gate(kg)

    # ------------------------------------------- 1. the prediction, printed
    print()
    print("=" * 78)
    print("1. THE PREDICTION - stated before the numbers, from the decay law")
    print("=" * 78)
    print("|c_k| = 2^(r/2) * B_k^(d+1) * |cos(arg z_k)| * 2 / |rho_k|, with")
    print("B_k = |1 - 2^(-rho_k)| = sqrt(3/2 - sqrt2 cos(gamma_k log 2)).")
    print("B and |cos| are STATIONARY in k; 1/|rho_k| ~ 1/gamma_k is the decay")
    print("envelope. Normalisation kills 2^(r/2). The envelope decides the")
    print("SHAPE of Neff(N); the stationary modulation only the LEVEL, by a")
    print("factor exp(-D) that does not depend on N.")
    print()
    print("  p_k ~ k^(-s):   s < 1  ->  Neff = (1-s) e^(-s/(1-s)) N   LINEAR")
    print("                  s = 1  ->  Neff ~ sqrt(N) log N          SUBLINEAR")
    print("                  s > 1  ->  Neff -> finite limit          SATURATES")
    print()
    print("  gamma_k ~ 2 pi k / log(k/(2 pi e))  =>  s(k) = 1 - 1/log(k/(2 pi e))")
    print("  which is BELOW 1 at every finite k and rises to 1 only as k -> inf.")
    print()
    print(f"  PREDICTED SHAPE: {PREDICTION['shape']}")
    print(f"  PREDICTED power-law fit over N = 25..600: slope ~ "
          f"{PREDICTION['powerlaw_fit_expected_25_600']}")
    print(f"  PREDICTED ratio (20,6)/(19,6): flat in N. {PREDICTION['ratio']}")
    print()

    # the measured local slope of the envelope itself, from the real gammas
    env_slopes = {}
    for a, b in ((2, 25), (25, 50), (50, 100), (100, 200), (200, 300),
                 (300, 600)):
        if b <= K:
            env_slopes[f"{a}_{b}"] = float(
                (log(gammas[b - 1]) - log(gammas[a - 1]))
                / (log(mpf(b)) - log(mpf(a))))
    print("  local log-slope s of gamma_k on the actual zero list:")
    print("   " + "   ".join(f"k={k.replace('_', '..')}: {v:.4f}"
                             for k, v in env_slopes.items()))
    print()

    # ------------------------------------------------ 2. the envelope model
    print("=" * 78)
    print("2. THE ENVELOPE MODEL - Neff_env(N) from a_k = 1 / |rho_k| alone")
    print("=" * 78)
    print("The magnitude profile with the stationary modulation removed. Its")
    print("Neff is the SHAPE the prediction says the real curves must follow,")
    print("up to one N-independent factor per cell.")
    print()
    rho_abs = [sqrt(mpf('0.25') + g * g) for g in gammas]
    env_mags = [1 / v for v in rho_abs]
    env_neff, env_pr = cumulative_curves(env_mags)
    print(f"{'N':>7}{'Neff_env':>13}{'Neff_env/N':>13}{'local exponent':>17}")
    prev = None
    for n in req:
        v = _at(env_neff, n)
        le = (math.log(v / prev[1]) / math.log(n / prev[0])) if prev else None
        print(f"{n:>7}{v:>13.3f}{v / n:>13.4f}"
              + (f"{le:>17.4f}" if le is not None else f"{'-':>17}"))
        prev = (n, v)
    print()

    # ---------------------------------------------------- 3. the curves
    engines = {}
    for f in forms:
        print(f"  building {f}-form modes ...", flush=True)
        engines[f] = build(f, gammas, rmax, depths)

    curves = {}          # (form, tag, r, d) -> {"Neff": [...], "PR": [...]}
    undefined = {}
    for form in forms:
        eng = engines[form]
        for r, d in TARGETS + CONTROLS:
            ok, why = eng.defined(r, d)
            if not ok:
                undefined[f"{form}_{r}_{d}"] = why
                continue
            amps = eng.amps(r, d)
            c = [-2 * mre(z) for z in amps]
            for tag, mags in (("c", [fabs(v) for v in c]),
                              ("z", [fabs(z) for z in amps])):
                ne, pr = cumulative_curves(mags)
                curves[(form, tag, r, d)] = {"Neff": ne, "PR": pr}

    print()
    print("=" * 78)
    print("3. Neff(N) AT THE TARGETS AND CONTROLS")
    print("=" * 78)
    print("Four exact zeros (lean value 0) and the two proved non-zeros,")
    print("nonzero_7_3 = 5 and nonzero_19_6 = 343. (2,1), (4,1), (8,3) and")
    print("(7,3) sit OUTSIDE the regime where the explicit formula tracks")
    print("pi(x); (20,6) with (19,6) is the one pair inside it. (2,1) is")
    print("undefined in the pi form for O90's reason.")
    print()
    for form in forms:
        for tag in ("c", "z"):
            print(f"--- {form} form, profile |{tag}|  " + "-" * 34)
            hdr = f"{'cell':>8}{'role':>9}" + "".join(
                f"{('N=' + str(n)):>10}" for n in req)
            print(hdr)
            print("-" * len(hdr))
            for r, d in TARGETS + CONTROLS:
                key = (form, tag, r, d)
                role = "zero" if (r, d) in TARGETS else "control"
                if key not in curves:
                    print(f"{str((r, d)):>8}{role:>9}" + "".join(
                        f"{'undef':>10}" for _ in req))
                    continue
                cur = curves[key]["Neff"]
                print(f"{str((r, d)):>8}{role:>9}" + "".join(
                    f"{_at(cur, n):>10.2f}" for n in req))
            print()

    # ------------------------------------------- 4. shape: which of the three
    print("=" * 78)
    print("4. WHICH SHAPE - saturating, linear, or sublinear")
    print("=" * 78)
    print("Three discriminators, each of which can fire on its own:")
    print("  local exponent  b = dlog Neff / dlog N near the top of the range.")
    print("                  b -> 0 saturating; b -> 1 linear; 0 < b < 1")
    print("                  sublinear.")
    print("  Neff/N          constant means linear; falling means sublinear;")
    print("                  falling like 1/N means saturating.")
    print(f"  Neff({K})/Neff({nmid})   1.00 saturating, "
          f"{K / nmid:.2f} linear, {K / nmid:.2f}^b between.")
    print()
    shape = {}
    hdr = (f"{'form':>5}{'prof':>5}{'cell':>9}"
           f"{('fit b ' + str(nlo1) + '-' + str(K)):>14}"
           f"{'r2':>8}{('fit b ' + str(nlo2) + '-' + str(K)):>15}"
           f"{('b ' + str(nmid) + '->' + str(K)):>12}"
           f"{('N' + str(K) + '/N' + str(nmid)):>11}"
           f"{('Neff/N ' + str(nlo1)):>11}"
           f"{('Neff/N ' + str(K)):>12}  reading")
    print(hdr)
    print("-" * len(hdr))
    for form in forms:
        for tag in ("c", "z"):
            for r, d in TARGETS + CONTROLS:
                key = (form, tag, r, d)
                if key not in curves:
                    continue
                cur = curves[key]["Neff"]
                ns_all = list(range(1, K + 1))
                w1 = [(n, _at(cur, n)) for n in ns_all if nlo1 <= n <= K]
                w2 = [(n, _at(cur, n)) for n in ns_all if nlo2 <= n <= K]
                f1 = _fit_loglog([p[0] for p in w1], [p[1] for p in w1])
                f2 = _fit_loglog([p[0] for p in w2], [p[1] for p in w2])
                a300, a600 = _at(cur, nmid), _at(cur, K)
                btop = (math.log(a600 / a300) / math.log(K / float(nmid))
                        if a300 and a600 else None)
                ratio = a600 / a300 if a300 else None
                fr25, fr600 = _at(cur, nlo1) / float(nlo1), a600 / K
                if btop is None:
                    read = "-"
                elif btop < 0.10:
                    read = "SATURATES"
                elif btop > 0.97:
                    read = "LINEAR"
                else:
                    read = "SUBLINEAR"
                shape[f"{form}_{tag}_{r}_{d}"] = {
                    "fit_lo_to_top": f1, "fit_mid_to_top": f2,
                    "fit_windows": {"lo": nlo1, "mid": nlo2,
                                    "half": nmid, "top": K},
                    "local_exponent_half_to_top": btop,
                    "Neff_top_over_Neff_half": ratio,
                    "Neff_frac_at_lo": fr25, "Neff_frac_at_top": fr600,
                    "reading": read}
                print(f"{form:>5}{tag:>5}{str((r, d)):>9}"
                      f"{f1['slope']:>14.4f}{f1['r2']:>8.5f}"
                      f"{f2['slope']:>15.4f}{btop:>12.4f}"
                      f"{ratio:>11.4f}{fr25:>11.4f}{fr600:>12.4f}"
                      f"  {read}")
    print()
    print("  For reference the envelope model itself, same columns:")
    fe1 = _fit_loglog(list(range(nlo1, K + 1)), env_neff[nlo1 - 1:])
    fe2 = _fit_loglog(list(range(nlo2, K + 1)), env_neff[nlo2 - 1:])
    be = (math.log(_at(env_neff, K) / _at(env_neff, nmid))
          / math.log(K / float(nmid)))
    print(f"{'env':>5}{'-':>5}{'-':>9}{fe1['slope']:>14.4f}{fe1['r2']:>8.5f}"
          f"{fe2['slope']:>15.4f}{be:>12.4f}"
          f"{_at(env_neff, K) / _at(env_neff, nmid):>11.4f}"
          f"{_at(env_neff, nlo1) / float(nlo1):>11.4f}"
          f"{_at(env_neff, K) / K:>12.4f}")
    env_shape = {"fit_lo_to_top": fe1, "fit_mid_to_top": fe2,
                 "local_exponent_half_to_top": be,
                 "fit_windows": {"lo": nlo1, "mid": nlo2, "half": nmid,
                                 "top": K}}

    # ------------------------------- 5. kappa_N, the flatness of the level
    print()
    print("=" * 78)
    print("5. kappa_N = Neff(N) / Neff_env(N) - the prediction says FLAT")
    print("=" * 78)
    print("If the shape is set by the envelope alone and the modulation only")
    print("moves the level, kappa_N does not depend on N. Drift in kappa_N is")
    print("the account failing, and would be the finding.")
    print()
    kappa = {}
    hdr = (f"{'form':>5}{'prof':>5}{'cell':>9}" +
           "".join(f"{('N=' + str(n)):>9}" for n in req) +
           f"{'max/min':>10}")
    print(hdr)
    print("-" * len(hdr))
    for form in forms:
        for tag in ("c", "z"):
            for r, d in TARGETS + CONTROLS:
                key = (form, tag, r, d)
                if key not in curves:
                    continue
                cur = curves[key]["Neff"]
                ks = [_at(cur, n) / _at(env_neff, n) for n in req]
                # spread over the part of the range where the phase sample is
                # not tiny; N >= 25 is the brief's own floor
                ks_all = [_at(cur, n) / _at(env_neff, n)
                          for n in range(nlo1, K + 1)]
                spread = max(ks_all) / min(ks_all)
                kappa[f"{form}_{tag}_{r}_{d}"] = {
                    "at_required_N": dict(zip((str(n) for n in req), ks)),
                    "N_floor": nlo1,
                    "min_above_floor": min(ks_all),
                    "max_above_floor": max(ks_all),
                    "max_over_min_above_floor": spread,
                    "at_top": ks[-1] if ks else None}
                print(f"{form:>5}{tag:>5}{str((r, d)):>9}" +
                      "".join(f"{v:>9.4f}" for v in ks) +
                      f"{spread:>10.4f}")
    print()

    # --------------------------------------------------- 6. THE RATIO
    print("=" * 78)
    print("6. THE RATIO Neff(20,6) / Neff(19,6) AGAINST N")
    print("=" * 78)
    print("Entry 197: 'The ratio 1.057 is safer, since both cells are")
    print("truncated identically.' This tests it. A flat row supports the")
    print("claim; a drifting row is the claim failing, and the drift is then")
    print("the number to report rather than the endpoint.")
    print()
    ratio_out = {}
    hdr = (f"{'form':>5}{'prof':>5}" +
           "".join(f"{('N=' + str(n)):>9}" for n in req) +
           f"{('min>=' + str(nlo1)):>10}{('max>=' + str(nlo1)):>10}"
           f"{'drift %':>9}{'slope':>10}")
    print(hdr)
    print("-" * len(hdr))
    for form in forms:
        for tag in ("c", "z"):
            ka = (form, tag, 20, 6)
            kb = (form, tag, 19, 6)
            if ka not in curves or kb not in curves:
                continue
            ca, cb = curves[ka]["Neff"], curves[kb]["Neff"]
            vals = [_at(ca, n) / _at(cb, n) for n in req]
            allv = [_at(ca, n) / _at(cb, n) for n in range(nlo1, K + 1)]
            lo, hi = min(allv), max(allv)
            drift = 100.0 * (hi - lo) / vals[-1]
            fit = _fit_loglog(list(range(nlo1, K + 1)), allv)
            ratio_out[f"{form}_{tag}"] = {
                "at_required_N": dict(zip((str(n) for n in req), vals)),
                "N_floor": nlo1,
                "min_above_floor": lo, "max_above_floor": hi,
                "drift_pct_of_top": drift,
                "loglog_slope_above_floor": fit["slope"] if fit else None,
                "at_top": vals[-1]}
            print(f"{form:>5}{tag:>5}" +
                  "".join(f"{v:>9.4f}" for v in vals) +
                  f"{lo:>10.4f}{hi:>10.4f}{drift:>9.2f}"
                  f"{(fit['slope'] if fit else float('nan')):>10.5f}")
    print()
    print("  The psi |z| row is the r-invariant profile of entry 197: it is")
    print("  1.0000 at every N by construction and carries no information")
    print("  about the pair. It is here as the null column.")
    print()
    print("  Same ratio one depth down, (8,3) / (7,3):")
    for form in forms:
        for tag in ("c", "z"):
            ka, kb = (form, tag, 8, 3), (form, tag, 7, 3)
            if ka not in curves or kb not in curves:
                continue
            ca, cb = curves[ka]["Neff"], curves[kb]["Neff"]
            vals = [_at(ca, n) / _at(cb, n) for n in req]
            ratio_out[f"{form}_{tag}_8_3_over_7_3"] = dict(
                zip((str(n) for n in req), vals))
            print(f"  {form:>3} |{tag}|  " +
                  "  ".join(f"N={n}: {v:.4f}" for n, v in zip(req, vals)))

    # ------------------------------------------ 7. PR(N), the second estimator
    print()
    print("=" * 78)
    print("7. PR(N) - the order-2 estimator, same sweep")
    print("=" * 78)
    print("PR <= Neff always. If both grow with the same exponent the")
    print("truncation dependence is a property of the profile rather than of")
    print("the Renyi order.")
    print()
    pr_out = {}
    hdr = (f"{'form':>5}{'prof':>5}{'cell':>9}{'PR fit b':>11}"
           f"{'Neff fit b':>12}{'PR(top)':>11}{'Neff/PR(top)':>14}")
    print(hdr)
    print("-" * len(hdr))
    for form in forms:
        for tag in ("c", "z"):
            for r, d in TARGETS + CONTROLS:
                key = (form, tag, r, d)
                if key not in curves:
                    continue
                prc = curves[key]["PR"]
                nec = curves[key]["Neff"]
                fp = _fit_loglog(list(range(nlo1, K + 1)), prc[nlo1 - 1:])
                fn = _fit_loglog(list(range(nlo1, K + 1)), nec[nlo1 - 1:])
                pr_out[f"{form}_{tag}_{r}_{d}"] = {
                    "PR_fit_lo_to_top": fp, "PR_at_top": _at(prc, K),
                    "Neff_over_PR_at_top": _at(nec, K) / _at(prc, K)}
                print(f"{form:>5}{tag:>5}{str((r, d)):>9}{fp['slope']:>11.4f}"
                      f"{fn['slope']:>12.4f}{_at(prc, K):>11.3f}"
                      f"{_at(nec, K) / _at(prc, K):>14.4f}")

    # ------------------------------------------------ 8. precision check
    pcheck = {}
    if args.pcheck:
        print()
        print("=" * 78)
        print(f"8. PRECISION CHECK - the headline curve recomputed at dps "
              f"{args.dps + 30}")
        print("=" * 78)
        print("psi form, |c| profile, cell (20,6): Neff(N) at every N,")
        print("recomputed from a mode set built at higher precision.")
        print()
        lo_dps = args.dps
        mp.dps = args.dps + 30
        gam_hi = [mpmathify(s) for s in raw[:args.nzeros]]
        eng_hi = PsiModes(gam_hi, rmax, depths)
        amps_hi = eng_hi.amps(20, 6)
        mags_hi = [fabs(-2 * mre(z)) for z in amps_hi]
        ne_hi, _ = cumulative_curves(mags_hi)
        mp.dps = lo_dps
        lo = curves[("psi", "c", 20, 6)]["Neff"]
        worst, worst_n = 0.0, None
        for i in range(K):
            a, b = lo[i], ne_hi[i]
            if b:
                rel = abs(b - a) / abs(b)
                if rel > worst:
                    worst, worst_n = rel, i + 1
        pcheck = {"curve": "psi |c| (20,6) Neff(N)",
                  "dps_lo": lo_dps, "dps_hi": lo_dps + 30,
                  "max_rel_diff": worst, "at_N": worst_n,
                  "n_points": K,
                  "at_required_N": {str(n): {"lo": _at(lo, n),
                                             "hi": _at(ne_hi, n)}
                                    for n in req}}
        print(f"{'N':>7}{'Neff dps ' + str(lo_dps):>20}"
              f"{'Neff dps ' + str(lo_dps + 30):>20}{'rel diff':>12}")
        for n in req:
            a, b = _at(lo, n), _at(ne_hi, n)
            print(f"{n:>7}{a:>20.10f}{b:>20.10f}"
                  f"{abs(b - a) / abs(b):>12.2e}")
        print(f"\n  max relative disagreement {worst:.2e} over all {K} values "
              f"of N (worst at N = {worst_n})")

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
                "mode": "vs_n",
                "mode_source_script": os.path.basename(O90.__file__),
                "mode_source_sha256": _sha256_of(O90.__file__),
                "dps": args.dps,
                "nzeros": K,
                "rmax": rmax,
                "depths": depths,
                "forms": forms,
                "profiles": ["c", "z"],
                "zeros_file": args.zeros,
                "pi2n_cache": args.pi2n,
                "N_grid": f"1..{K}, every N",
                "N_reported": req,
                "precision_check": bool(args.pcheck),
                "out": args.vs_n_out,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            },
            "constants": {
                "question": ("entry 197 left Neff(N) unmeasured: p_k "
                             "normalises over the first 600 modes, so 172.0 "
                             "at (20,6) is a statement at that truncation. "
                             "This measures the N dependence."),
                "statistic": ("Neff(N) = exp(H_N), H_N = -sum_(k<=N) p_k log "
                              "p_k, p_k = |c_k| / sum_(j<=N) |c_j|; and the "
                              "same on q_k = |z_k| / sum_(j<=N) |z_j|"),
                "stencil": ("cell (r,d) = Delta^(d+1) of pi(2^.) at r; "
                            "verified against the six kernel-proved values "
                            "in section 0"),
                "prediction": PREDICTION,
                "envelope_model": ("a_k = 1/|rho_k|, the decay envelope with "
                                   "the stationary modulation removed; "
                                   "Neff_env(N) is its cumulative Neff"),
                "targets": TARGETS,
                "controls": CONTROLS,
                "lean_cell_values": {f"{r},{d}": v
                                     for (r, d), v in LEAN_CELL.items()},
                "regime": {f"{r},{d}": v for (r, d), v in REGIME.items()},
                "pi_undefined_reason": PI_UNDEFINED,
            },
            "summary": {
                "kernel_gate": kg,
                "gamma_local_log_slope": env_slopes,
                "envelope": {
                    "Neff_env_at_required_N": {
                        str(n): _at(env_neff, n) for n in req},
                    "shape": env_shape,
                },
                "shape": shape,
                "kappa": kappa,
                "ratio_20_6_over_19_6": ratio_out,
                "pr": pr_out,
                "undefined_cells": undefined,
                "precision_check": pcheck,
            },
            "rows": {
                "N": list(range(1, K + 1)),
                "Neff_env": env_neff,
                "curves": {f"{form}_{tag}_{r}_{d}": {
                    "form": form, "profile": tag, "r": r, "d": d,
                    "role": "zero" if (r, d) in TARGETS else "control",
                    "Neff": curves[(form, tag, r, d)]["Neff"],
                    "PR": curves[(form, tag, r, d)]["PR"]}
                    for (form, tag, r, d) in curves},
            },
        }
        guarded_write(_jsonable(payload), args.vs_n_out, allow_nan=False)


def main():
    args = parse_args()
    if args.vs_n:
        # A separate path with its own output file. Nothing below
        # runs, and results/mode_entropy.json is never opened.
        return vs_n_main(args)
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
