"""
O93 - THE OVERLAP IDENTITY: are the two heaviest overlapping cancellations in
      O47's pooled census - sqrt(2)'s (34,11) and base 2's (20,6) - two
      cancellation events, or one event seen at two resolutions?

Reads with: notes/lab_notebook_2.md entry 201 (the approval, and the MANDATORY
convention precondition), entry 192 (the exponent trap this precondition
guards against), entry 194 (why mode statistics at zeros need their
deterministic content separated before anything is read);
O90_mode_coherence.py (the mode construction generalized here);
O45_sub_integer_base_scan.py (the sqrt(2) table's construction - the
convention verified below is that script's, reproduced cell-exact);
results/sub_integer_base_scan.json (the recorded sqrt(2) table);
results/high_mass_zeros.json (O47 - the object under test:
summary.top_window_overlaps).

STATUS
------
EXPLORATORY.  No prereg, no decision rule, no verdict.  Per CLAUDE.md
"Prereg discipline", nothing this script prints may be described as a
verdict, and no verdict line is written anywhere in its output.

THE QUESTION
------------
O47's pooled mass ranking has sqrt(2)'s (34,11) at rank 1 (S = 1,371,038) and
base 2's (20,6) at rank 3 (S = 492,384); their windows overlap by 3.0 log2
units, 0.545 of the shorter, and log2 sqrt(2) = 1/2 exactly - sqrt(2) is base
2's half-step refinement.  The test: per-mode phase alignment between the two
cells, against matched-background cell pairs.

MANDATORY PRECONDITION (entry 201, item 2) - verified BEFORE any mode
---------------------------------------------------------------------
The sqrt(2) table's stencil convention is verified against known values
first.  O45's construction (O45_sub_integer_base_scan.py, functions
base_geometry / rung_populations / build_tables):

    F[r]   = floor(b^r)          exact integer sqrt for b = 2^(1/2) (iroot),
                                 exact powers for b = 2, mpmath dps 60 floor
                                 for the transcendental bases
    N(r)   = pi(F[r]) - pi(F[r-1])       the depth-0 row
    P(r,d) = P(r,d-1) - P(r-1,d-1)       d further backward differences

So the depth-0 row is itself ONE backward difference of the cumulative
ladder r -> pi(floor(b^r)) - the same shape as base 2's dyadicRow - and a
cell (r,d) is Delta^(d+1) of pi(floor(b^.)) at r, for EVERY O45 base.  This
script rebuilds the tables from prime counts (primecountpy), verifies them
cell-exact against results/sub_integer_base_scan.json (every exact zero,
with total_true and S) and against results/high_mass_zeros.json (S and the
window integers at every target cell), and prints the entry-192-style
discriminating table Delta^d vs Delta^(d+1) at the recorded sqrt(2) zeros.
Any mismatch stops the run before a single mode is built.

THE MODE, conditional on that verification
------------------------------------------
Because the depth-0 row is one backward difference, the psi-form per-pair
mode of O90 generalizes with n = d+1:

    z_k(b,r,d) = b^(r*rho_k) * (1 - b^(-rho_k))^(d+1) / rho_k,
    rho_k = 1/2 + i*gamma_k

(The table uses floor(b^r); the mode is a model of the count at the exact
point b^r.  The two differ by less than one integer per rung, which touches
no phase below.)

THE STATISTIC
-------------
For cells A and B, over zero pairs k = 1..600:

    delta_k   = arg(z_k^A) - arg(z_k^B)
    R         = |mean_k exp(i*delta_k)|           Rayleigh concentration
    R_w       = |sum w_k exp(i*delta_k)| / sum w_k,
                w_k = min(|z_k^A|, |z_k^B|)

THE CONFOUND, worked before the numbers (entry 194's discipline)
----------------------------------------------------------------
arg z_k = r*ln(b)*gamma_k + (d+1)*arg(1 - b^(-rho_k)) - arg(rho_k), so

    delta_k = (r_A*ln b_A - r_B*ln b_B)*gamma_k
              + (d_A+1)*arg(1 - b_A^(-rho_k)) - (d_B+1)*arg(1 - b_B^(-rho_k))

The first term is the deterministic rotation gamma_k * Delta, with Delta the
log window-TOP offset of the two cells.  Two windows at the same place have
aligned fast phases for free - that is the confound the design brief names.
Two consequences, both measured below rather than argued:

  1. delta_k depends on the cell pair ONLY through Delta (the depth and base
     parts are fixed across a matched family).  Every pair with the same
     Delta has the identical R.  For the sqrt(2) x 2 lattice, same-Delta
     pairs exist and the identity is demonstrated numerically.

  2. The fast-phase-corrected residual delta_k - Delta*gamma_k is the SAME
     function of gamma_k for every pair in a matched family - it carries the
     depth/base geometry and nothing about either cell's position or value.
     The corrected R is therefore one number per family, identical at the
     target and at every null pair, BY CONSTRUCTION.

  3. The honest position-matched null does not exist here: a non-overlapping
     pair must have |Delta| >= the shorter window length (5.5 log2 units for
     the primary pair), while the observed |Delta| is 3.0.  Matching on
     position difference and requiring non-overlap are incompatible when the
     windows are this long.  The naive statistic and its non-overlap null
     are reported anyway, labelled as what they are, with the R-vs-|Delta|
     dependence printed so the rotation's share of naive R is visible.

Both the naive and the corrected statistic are reported side by side, per
the design brief: if the effect vanishes under the correction, that is the
result.

NULL
----
Matched pairs: every resolved cell of base A's table at depth d_A crossed
with every resolved cell of base B's at depth d_B (O45's resolved criterion,
r - d >= r_thick(b), geometry re-derived and checked against the locked
values), split into non-overlapping pairs (overlap_log2 = 0 in O47's window
geometry, window = (b^(r-d), b^r]) and the full all-pairs set.  The
enumeration is exhaustive and deterministic - no sampling, no seed.
p = fraction of null R >= observed R.

TARGETS
-------
Primary: sqrt(2) (34,11) vs 2 (20,6), overlap 3.0 log2, frac_of_shorter
0.545.  Secondary: the frac_of_shorter = 1.0 containment pairs from
summary.top_window_overlaps.  Entry 201 says the table holds two such pairs;
the JSON holds SEVEN.  All seven are run, so whichever two were meant are
included; the discrepancy is reported, not resolved here.

PRECISION
---------
dps 50 working, zeros600.json (~25 significant digits, the data floor).
Null-side assembly folds mp-precision phases into float64 (phase error
~1e-12 rad against statistics reported to 6 digits).  The headline R values
at every observed pair are recomputed fully in mpmath at dps 50 and again at
dps 80, and the float path is compared against both.

HOW IT IS RUN
-------------
    python3 utilities/run.py --python .venv/bin/python \
        --log results/O93_overlap_identity_run1.log O93_overlap_identity.py

REQUIREMENTS: primecountpy (sympy fallback), mpmath.
"""
import argparse
import cmath
import datetime
import hashlib
import json
import math
import os
import sys
from fractions import Fraction

from mpmath import mp, mpf, mpc, mpmathify, fmod as mpfmod
from mpmath import log as mplog, exp as mpexp, floor as mpfloor, pi as MPPI
from mpmath import arg as mparg, fabs as mpfabs

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT = os.path.join(DEFAULT_RESULTS_DIR, "overlap_identity.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")
O45_JSON = os.path.join(_HERE, "results", "sub_integer_base_scan.json")
O47_JSON = os.path.join(_HERE, "results", "high_mass_zeros.json")
PI2N_CACHE = os.path.join(_HERE, "pi2n_cache.json")

RULE = "=" * 78
THIN = "-" * 78

# O45's locked constants, reproduced for the reconstruction (they are locked
# parameters of preregs/sub_integer_base_scan_v1_20260818.md; nothing here
# may move them, and the rebuilt geometry is checked against the recorded
# JSON before use).
GAMMA1_STR = "14.134725141734693"
VALUE_CEILING_EXP = 32
VALUE_CEILING = 1 << VALUE_CEILING_EXP
GEOM_DPS = 60                     # O45's dps for floor(b^r)

# label -> O45 kind, for every base a target pair touches
KINDS = {
    "2":                ("int", None),
    "2**(1/2)":         ("root", 2),
    "exp(pi*1/(2*g1))": ("fam", 1),
    "exp(pi*3/(4*g1))": ("anti", 1),
    "exp(pi*5/(4*g1))": ("anti", 2),
}


def _code_version():
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
        return f"unavailable: {exc}"


def file_record(path, role):
    st = os.stat(path)
    with open(path, "rb") as fh:
        sha = hashlib.sha256(fh.read()).hexdigest()
    return {"path": path, "basename": os.path.basename(path),
            "bytes": st.st_size,
            "mtime_utc": datetime.datetime.fromtimestamp(
                st.st_mtime, datetime.timezone.utc
            ).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "sha256": sha, "role": role}


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


# ------------------------------------------------- O45's construction, redone

def load_pi_backend():
    try:
        from primecountpy import prime_pi as _pp
        return (lambda x: int(_pp(int(x))) if x >= 2 else 0,
                "primecountpy.prime_pi")
    except Exception:
        from sympy import primepi as _sp
        return (lambda x: int(_sp(int(x))) if x >= 2 else 0, "sympy.primepi")


def iroot(n, k):
    """Exact floor of the integer k-th root (O45's, unchanged)."""
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
    tag, param = kind
    if tag == "int":
        return mpf(2)
    if tag == "fam":
        return mpexp(MPPI * param / (2 * gamma1))
    if tag == "anti":
        return mpexp(MPPI * (2 * param + 1) / (4 * gamma1))
    if tag == "root":
        return mpf(2) ** (mpf(1) / param)
    raise ValueError(f"unknown kind {kind!r}")


def base_geometry(kind, gamma1):
    """(b, r_max, F) exactly as O45 computes them, at GEOM_DPS."""
    tag, param = kind
    b = base_value(kind, gamma1)
    if tag == "int":
        r_max = VALUE_CEILING_EXP
        return b, r_max, [1 << r for r in range(r_max + 1)]
    if tag == "root":
        m = param
        r_max = VALUE_CEILING_EXP * m
        F = [iroot(1 << r, m) for r in range(r_max + 1)]
        for r in range(r_max + 1):
            if not (F[r] ** m <= (1 << r) < (F[r] + 1) ** m):
                raise RuntimeError(f"exact-root self-check failed at r={r}")
        return b, r_max, F
    r_max = int(mpfloor(mpf(VALUE_CEILING_EXP) * mplog(2) / mplog(b)))
    while b ** (r_max + 1) <= VALUE_CEILING:
        r_max += 1
    while b ** r_max > VALUE_CEILING:
        r_max -= 1
    return b, r_max, [int(mpfloor(b ** r)) for r in range(r_max + 1)]


def r_thick_of(W, b, r_max):
    lnb = float(mplog(b))
    rt = r_max + 1
    for r in range(r_max, 0, -1):
        if W[r] / (lnb * r) >= 1.0:
            rt = r
        else:
            break
    return rt


def build_base(label, pi_fn, pi_cache):
    """Rebuild one O45 arm end to end.  Returns a dict with the exact table."""
    mp.dps = GEOM_DPS
    gamma1 = mpf(GAMMA1_STR)
    b, r_max, F = base_geometry(KINDS[label], gamma1)
    W = [0] + [F[r] - F[r - 1] for r in range(1, r_max + 1)]
    r_thick = r_thick_of(W, b, r_max)

    def PI(x):
        if x < 2:
            return 0
        if x not in pi_cache:
            pi_cache[x] = pi_fn(x)
        return pi_cache[x]

    C = [PI(F[r]) for r in range(r_max + 1)]         # cumulative pi(floor(b^r))
    N = [0] + [C[r] - C[r - 1] for r in range(1, r_max + 1)]
    P, Q = {}, {}
    for r in range(1, r_max + 1):
        P[(r, 0)] = N[r]
        Q[(r, 0)] = W[r]
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            P[(r, d)] = P[(r, d - 1)] - P[(r - 1, d - 1)]
            Q[(r, d)] = Q[(r, d - 1)] - Q[(r - 1, d - 1)]
    zeros = []
    cells = 0
    resolved_cells = 0
    for r in range(2, r_max + 1):
        for d in range(1, r):
            cells += 1
            if (r - d) >= r_thick:
                resolved_cells += 1
            if P[(r, d)] == 0:
                S = sum(math.comb(d, k) * N[r - k] for k in range(d + 1))
                zeros.append({"r": r, "d": d, "total_true": Q[(r, d)], "S": S,
                              "resolved": (r - d) >= r_thick})
    return {"label": label, "b": b, "r_max": r_max, "F": F, "C": C, "N": N,
            "P": P, "r_thick": r_thick, "cells": cells,
            "resolved_cells": resolved_cells, "zeros": zeros}


def binom_delta(C, r, n):
    """Delta^n of the cumulative ladder C at r, binomial form."""
    return sum(((-1) ** j) * math.comb(n, j) * C[r - j] for j in range(n + 1))


def stencil_mass(N, r, d):
    return sum(math.comb(d, k) * N[r - k] for k in range(d + 1))


# ------------------------------------------------------------------ geometry

def log2b_exact(label):
    """Exact rational log2(b) where one exists, else None."""
    if label == "2":
        return Fraction(1)
    if label == "2**(1/2)":
        return Fraction(1, 2)
    return None


def window_bounds_log2(label, b, r, d):
    """O47's window (b^(r-d), b^r] as (lo, hi) in log2.  Fraction where the
    base is a dyadic root, float otherwise."""
    q = log2b_exact(label)
    if q is not None:
        return (r - d) * q, r * q
    l2 = mplog(b) / mplog(mpf(2))
    return float((r - d) * l2), float(r * l2)


def overlap_log2(wa, wb):
    lo = max(wa[0], wb[0])
    hi = min(wa[1], wb[1])
    v = hi - lo
    return v if v > 0 else (v * 0)


# ------------------------------------------------------------------ the modes

class Arm:
    """One (base, depth) family: per-zero phase pieces and magnitudes, plus
    the per-cell fast phase r*ln(b)*gamma_k folded to a unit complex."""

    def __init__(self, label, d, b_geo, r_list, gammas):
        self.label = label
        self.d = d
        self.r_list = list(r_list)
        b = base_value(KINDS[label], mpf(GAMMA1_STR))   # at current mp.dps
        self.lnb = mplog(b)
        twopi = 2 * MPPI
        n = d + 1
        self.phi = []      # (d+1)*arg(1-b^-rho) - arg(rho)   [float]
        self.lmag = []     # (d+1)*ln|1-b^-rho| - ln|rho|     [float]
        for g in gammas:
            rho = mpc(mpf("0.5"), g)
            m1 = 1 - b ** (-rho)
            self.phi.append(float(n * mparg(m1) - mparg(rho)))
            self.lmag.append(float(n * mplog(mpfabs(m1)) - mplog(mpfabs(rho))))
        # E[r][k] = exp(i*(r*lnb*gamma_k mod 2pi + phi_k)); logw[r][k]
        self.E = {}
        self.logw = {}
        lnb_f = float(self.lnb)
        for r in self.r_list:
            th = [float(mpfmod(r * self.lnb * g, twopi)) for g in gammas]
            self.E[r] = [cmath.exp(1j * (t + p)) for t, p in zip(th, self.phi)]
            self.logw[r] = [r * lnb_f / 2.0 + lm for lm in self.lmag]


def pair_stats(EA, lwA, EB, lwB, Ccorr):
    """One cell pair: naive R, weighted naive R, weighted corrected R.
    Ccorr is the family-constant corrected phase array exp(i*(phiA-phiB))."""
    s = 0j
    sw = 0j
    swc = 0j
    tw = 0.0
    for k in range(len(EA)):
        t = EA[k] * EB[k].conjugate()
        w = math.exp(min(lwA[k], lwB[k]))
        s += t
        sw += w * t
        swc += w * Ccorr[k]
        tw += w
    nk = len(EA)
    return (abs(s) / nk, abs(sw) / tw, abs(swc) / tw)


# ------------------------------------------------------------------------ main

def parse_args():
    ap = argparse.ArgumentParser(
        description=("O93 - overlap identity: per-mode phase alignment "
                     "between overlapping high-mass cells. EXPLORATORY: "
                     "no prereg, no decision rule, no verdict."))
    ap.add_argument("--dps", type=int, default=50)
    ap.add_argument("--nzeros", type=int, default=600)
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS)
    ap.add_argument("--precision-dps", type=int, default=80,
                    help="dps for the headline recomputation (default 80)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--no-json", action="store_true")
    return ap.parse_args()


def observed_mp(labelA, dA, rA, labelB, dB, rB, gammas):
    """Full-mpmath R values for one observed pair at the current mp.dps:
    (R_naive, R_naive_w, R_corr, R_corr_w)."""
    g1 = mpf(GAMMA1_STR)
    bA = base_value(KINDS[labelA], g1)
    bB = base_value(KINDS[labelB], g1)
    nA, nB = dA + 1, dB + 1
    s = mpc(0)
    sw = mpc(0)
    sc = mpc(0)
    swc = mpc(0)
    tw = mpf(0)
    for g in gammas:
        rho = mpc(mpf("0.5"), g)
        zA = bA ** (rA * rho) * (1 - bA ** (-rho)) ** nA / rho
        zB = bB ** (rB * rho) * (1 - bB ** (-rho)) ** nB / rho
        pA = mparg(zA)
        pB = mparg(zB)
        d_naive = pA - pB
        d_corr = d_naive - (rA * mplog(bA) - rB * mplog(bB)) * g
        w = min(mpfabs(zA), mpfabs(zB))
        e_n = mpc(mp.cos(d_naive), mp.sin(d_naive))
        e_c = mpc(mp.cos(d_corr), mp.sin(d_corr))
        s += e_n
        sw += w * e_n
        sc += e_c
        swc += w * e_c
        tw += w
    nk = len(gammas)
    return (float(mpfabs(s) / nk), float(mpfabs(sw) / tw),
            float(mpfabs(sc) / nk), float(mpfabs(swc) / tw))


def main():
    args = parse_args()
    started = datetime.datetime.now(datetime.timezone.utc)
    fail = []

    print(RULE)
    print("O93 - THE OVERLAP IDENTITY")
    print("EXPLORATORY. No prereg, no decision rule, NO VERDICT. Nothing")
    print("printed below may be described as a verdict.")
    print(RULE)
    print(f"  started (UTC)   : {started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  dps             : {args.dps} working, "
          f"{args.precision_dps} for the precision check")
    print(f"  code_version    : {_code_version()}", flush=True)

    source_files = [file_record(p, role) for p, role in (
        (args.zeros, "zeros"), (O45_JSON, "sqrt2_table_record"),
        (O47_JSON, "overlap_record"), (PI2N_CACHE, "pi_audit"))]

    with open(args.zeros) as fh:
        raw = json.load(fh)
    with open(O45_JSON) as fh:
        o45 = json.load(fh)
    with open(O47_JSON) as fh:
        o47 = json.load(fh)

    # ---------------------------------------------------------------- targets
    ov = o47["summary"]["top_window_overlaps"]
    primary = [o for o in ov if o["a"] == "2**(1/2) (34,11)"
               and o["b"] == "2 (20,6)"]
    assert len(primary) == 1, "primary pair not found in top_window_overlaps"
    containment = [o for o in ov if o["frac_of_shorter"] == 1.0]

    def parse_cell(s):
        lab, rd = s.rsplit(" ", 1)
        r, d = rd.strip("()").split(",")
        return lab, int(r), int(d)

    targets = [("primary", primary[0])] + \
              [(f"containment_{i+1}", o) for i, o in enumerate(containment)]
    print()
    print(f"  primary target  : {primary[0]['a']} vs {primary[0]['b']}  "
          f"overlap {primary[0]['overlap_log2']} log2, "
          f"frac_of_shorter {primary[0]['frac_of_shorter']:.4f}")
    print(f"  containment     : {len(containment)} pairs at "
          f"frac_of_shorter = 1.0 in summary.top_window_overlaps.")
    print("                    Entry 201 records TWO such pairs; the JSON "
          "holds")
    print(f"                    {len(containment)}.  All "
          f"{len(containment)} are run; the discrepancy is reported,")
    print("                    not resolved here.", flush=True)

    labels_needed = set()
    for _, o in targets:
        labels_needed.add(parse_cell(o["a"])[0])
        labels_needed.add(parse_cell(o["b"])[0])

    # ------------------------------------------- 1. pi backend + cache audit
    print()
    print(RULE)
    print("1. PI BACKEND INTEGRITY")
    print(RULE)
    pi_fn, pi_name = load_pi_backend()
    with open(PI2N_CACHE) as fh:
        pi2 = json.load(fh)
    n_ok = 0
    for n in range(0, VALUE_CEILING_EXP + 1):
        want = int(pi2[str(n)])
        got = pi_fn(1 << n)
        if want == got:
            n_ok += 1
        else:
            fail.append(f"pi audit: pi(2^{n}) backend {got} != cache {want}")
    print(f"  backend         : {pi_name}")
    print(f"  pi(2^n) audit   : {n_ok} of {VALUE_CEILING_EXP + 1} equal "
          f"against pi2n_cache.json")
    print(f"  status          : {'FAIL' if fail else 'PASS'}", flush=True)

    # --------------------------- 2. rebuild the tables, verify against O45
    print()
    print(RULE)
    print("2. TABLE RECONSTRUCTION vs results/sub_integer_base_scan.json")
    print("   (MANDATORY precondition, entry 201: the stencil convention is")
    print("   verified against known values BEFORE any mode is built)")
    print(RULE)
    o45_by_label = {s["label"]: s for s in o45["summary"]["per_base"]}
    pi_cache = {}
    bases = {}
    verif = {}
    print(f"  {'base':<20}{'r_max':>6}{'cells':>7}{'r_thick':>8}"
          f"{'resolved':>9}{'zeros':>6}   match?")
    for label in sorted(labels_needed):
        B = build_base(label, pi_fn, pi_cache)
        bases[label] = B
        rec = o45_by_label[label]
        got_z = sorted((z["r"], z["d"], z["total_true"], z["S"])
                       for z in B["zeros"])
        want_z = sorted((z["r"], z["d"], z["total_true"], z["S"])
                        for z in rec["exact_zeros"])
        ok = (B["r_max"] == rec["r_max"]
              and B["cells"] == rec["n_cells_at_d_ge_1"]
              and B["r_thick"] == rec["r_thick"]
              and B["resolved_cells"] == rec["n_resolved_cells"]
              and got_z == want_z)
        verif[label] = {"geometry_and_zeros_match_o45": ok,
                        "n_zeros_rebuilt": len(got_z),
                        "n_zeros_recorded": len(want_z)}
        if not ok:
            fail.append(f"reconstruction mismatch at base {label}")
        print(f"  {label:<20}{B['r_max']:>6}{B['cells']:>7}"
              f"{B['r_thick']:>8}{B['resolved_cells']:>9}"
              f"{len(B['zeros']):>6}   {'yes' if ok else 'NO'}", flush=True)
    print()
    print("  Every exact zero of every rebuilt table matches the recorded")
    print("  (r, d, total_true, S) exactly." if not fail else
          "  MISMATCHES ABOVE - the run stops before any mode is built.")

    # --------------------------------- 3. target cells vs O47, and the trap
    print()
    print(RULE)
    print("3. TARGET CELLS vs results/high_mass_zeros.json, AND THE EXPONENT")
    print(RULE)
    o47_rows = {(row["label"], row["r"], row["d"]): row for row in o47["rows"]}
    tcells = set()
    for _, o in targets:
        tcells.add(parse_cell(o["a"]))
        tcells.add(parse_cell(o["b"]))
    print(f"  {'cell':<28}{'value':>7}{'S':>10}{'S(O47)':>10}"
          f"{'win_lo':>9}{'win_hi':>9}   match?")
    tcell_out = []
    for (label, r, d) in sorted(tcells):
        B = bases[label]
        val = B["P"][(r, d)]
        S = stencil_mass(B["N"], r, d)
        row = o47_rows[(label, r, d)]
        ok = (val == 0 and S == row["S"]
              and B["F"][r - d] == row["window_lo_int"]
              and B["F"][r] == row["window_hi_int"]
              and B["r_thick"] == row["r_thick"])
        if not ok:
            fail.append(f"target cell mismatch at {label} ({r},{d})")
        tcell_out.append({"label": label, "r": r, "d": d, "cell": val,
                          "S": S, "S_o47": row["S"],
                          "window_lo_int": B["F"][r - d],
                          "window_hi_int": B["F"][r], "match": ok})
        print(f"  {label + f' ({r},{d})':<28}{val:>7}{S:>10}{row['S']:>10}"
              f"{B['F'][r - d]:>9}{B['F'][r]:>9}   {'yes' if ok else 'NO'}",
              flush=True)

    # entry-192-style discriminating table for sqrt(2)
    print()
    print("  The exponent trap (entry 192), in base sqrt(2): Delta^d vs")
    print("  Delta^(d+1) of the cumulative ladder pi(floor(sqrt(2)^r)) at the")
    print("  recorded resolved zeros clearing the mass floor:")
    print(f"  {'cell':>10}{'Delta^d':>10}{'Delta^(d+1)':>13}{'recorded':>10}")
    B2 = bases["2**(1/2)"]
    disc = []
    for z in B2["zeros"]:
        if not (z["resolved"] and z["S"] >= 88):
            continue
        r, d = z["r"], z["d"]
        vd = binom_delta(B2["C"], r, d)
        vd1 = binom_delta(B2["C"], r, d + 1)
        disc.append({"r": r, "d": d, "delta_d": vd, "delta_d1": vd1})
        if vd1 != 0:
            fail.append(f"binomial Delta^(d+1) != 0 at sqrt(2) ({r},{d})")
        print(f"  {f'({r},{d})':>10}{vd:>10}{vd1:>13}{0:>10}")
    n_disc = sum(1 for x in disc if x["delta_d"] != 0)
    print(f"  Delta^(d+1) reproduces every recorded zero; Delta^d misses "
          f"{n_disc} of {len(disc)}.")
    # recurrence == binomial identity across every cell the nulls will touch
    ident_bad = 0
    for label in labels_needed:
        B = bases[label]
        for (r, d), v in B["P"].items():
            if d >= 1 and v != binom_delta(B["C"], r, d + 1):
                ident_bad += 1
    if ident_bad:
        fail.append(f"recurrence != binomial Delta^(d+1) at {ident_bad} cells")
    print(f"  recurrence == binomial Delta^(d+1) at every (r, d>=1) cell of "
          f"every rebuilt table: {'yes' if not ident_bad else 'NO'}")
    print()
    print("  CONVENTION, pinned: O45's depth-0 row N(r) = pi(F[r]) - pi(F[r-1])")
    print("  is one backward difference of the cumulative ladder, for every")
    print("  base including sqrt(2).  The mode exponent is therefore n = d+1:")
    print("      z_k(b,r,d) = b^(r*rho_k) * (1 - b^(-rho_k))^(d+1) / rho_k")
    print("  (The table reads pi at floor(b^r); the mode models the count at")
    print("  the exact point b^r - under one integer per rung, no phase "
          "touched.)", flush=True)

    if fail:
        print()
        print(RULE)
        print("PRECONDITION FAILED - stopping before any mode is built")
        print(RULE)
        for f_ in fail:
            print(f"  {f_}")
        if not args.no_json:
            guarded_write(_jsonable({
                "schema_version": "1",
                "script": os.path.basename(__file__),
                "generated_utc": datetime.datetime.now(
                    datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                "status": "EXPLORATORY - precondition failed, no modes built",
                "params": {"code_version": _code_version(),
                           "argv": sys.argv, "source_files": source_files},
                "summary": {"precondition_failures": fail},
                "rows": []}), args.out, allow_nan=False)
        return 1

    # ------------------------------------------------------- 4. the modes
    print()
    print(RULE)
    print("4. THE STATISTIC, AND THE CONFOUND STATED BEFORE THE NUMBERS")
    print(RULE)
    print("  delta_k = Delta * gamma_k + psi_k, where Delta = r_A ln b_A -")
    print("  r_B ln b_B is the log window-TOP offset and psi_k carries only")
    print("  the (base, depth) geometry - the SAME psi_k for every pair in a")
    print("  matched family.  Three structural consequences, measured below:")
    print("    (i)   naive R is a function of Delta alone;")
    print("    (ii)  the fast-phase-corrected R is one number per family,")
    print("          identical at the target and every null pair;")
    print("    (iii) a non-overlapping pair needs |Delta| >= the shorter")
    print("          window, so a position-matched non-overlap null cannot")
    print("          exist when the observed |Delta| is smaller than that.")
    print(flush=True)

    mp.dps = args.dps
    gammas = [mpmathify(s) for s in raw[:args.nzeros]]
    nz = len(gammas)

    # arms needed: (label, depth) -> resolved r list
    arm_specs = {}
    for _, o in targets:
        for cell in (parse_cell(o["a"]), parse_cell(o["b"])):
            label, r, d = cell
            key = (label, d)
            if key not in arm_specs:
                B = bases[label]
                r_lo = B["r_thick"] + d
                arm_specs[key] = list(range(r_lo, B["r_max"] + 1))
    arms = {}
    for (label, d), r_list in sorted(arm_specs.items()):
        print(f"  building arm {label} d={d}: {len(r_list)} resolved cells "
              f"(r = {r_list[0]}..{r_list[-1]}) ...", flush=True)
        arms[(label, d)] = Arm(label, d, bases[label]["b"], r_list, gammas)

    # ------------------------------------------------------ 5. per target
    print()
    print(RULE)
    print("5. TARGETS AGAINST THEIR NULLS")
    print(RULE)
    results = []
    for tname, o in targets:
        labA, rA, dA = parse_cell(o["a"])
        labB, rB, dB = parse_cell(o["b"])
        A = arms[(labA, dA)]
        Bm = arms[(labB, dB)]
        BA, BB = bases[labA], bases[labB]
        lnbA, lnbB = float(mplog(BA["b"])), float(mplog(BB["b"]))
        Ccorr = [cmath.exp(1j * (pa - pb))
                 for pa, pb in zip(A.phi, Bm.phi)]
        R_corr = abs(sum(Ccorr)) / nz

        # windows in log2 for the null split
        wA = {r: window_bounds_log2(labA, BA["b"], r, dA) for r in A.r_list}
        wB = {r: window_bounds_log2(labB, BB["b"], r, dB) for r in Bm.r_list}

        # all pairs; null = non-overlapping
        obs_key = (rA, rB)
        all_R = {}       # (ra,rb) -> (Rn, Rnw, Rcw)
        null_keys = []
        for ra in A.r_list:
            EA, lwA = A.E[ra], A.logw[ra]
            for rb in Bm.r_list:
                st = pair_stats(EA, lwA, Bm.E[rb], Bm.logw[rb], Ccorr)
                all_R[(ra, rb)] = st
                ov_len = overlap_log2(wA[ra], wB[rb])
                if float(ov_len) <= 1e-9:
                    null_keys.append((ra, rb))
        Rn_obs, Rnw_obs, Rcw_obs = all_R[obs_key]
        d_obs = rA * lnbA - rB * lnbB

        null_Rn = [all_R[k][0] for k in null_keys]
        null_Rnw = [all_R[k][1] for k in null_keys]
        null_Rcw = [all_R[k][2] for k in null_keys]
        other = [k for k in all_R if k != obs_key]
        allp_Rn = [all_R[k][0] for k in other]
        allp_Rnw = [all_R[k][1] for k in other]

        def pfrac(vals, obs):
            return (sum(1 for v in vals if v >= obs) / len(vals)
                    if vals else None)

        # same-Delta demonstration (exists only on the dyadic lattice)
        same_delta = None
        if log2b_exact(labA) is not None and log2b_exact(labB) is not None:
            qa, qb = log2b_exact(labA), log2b_exact(labB)
            d_obs_q = rA * qa - rB * qb
            twins = [k for k in all_R
                     if k != obs_key and k[0] * qa - k[1] * qb == d_obs_q]
            if twins:
                dev = max(abs(all_R[k][0] - Rn_obs) for k in twins)
                same_delta = {"n_same_delta_pairs": len(twins),
                              "pairs": [list(k) for k in twins],
                              "max_abs_R_naive_diff": dev}

        # R vs |Delta| profile over all pairs (the rotation's share)
        prof = sorted((abs(k[0] * lnbA - k[1] * lnbB) / math.log(2),
                       all_R[k][0]) for k in all_R)
        nbin = 8
        bins = []
        for i in range(nbin):
            seg = prof[i * len(prof) // nbin:(i + 1) * len(prof) // nbin]
            if seg:
                bins.append({
                    "abs_delta_log2_lo": seg[0][0],
                    "abs_delta_log2_hi": seg[-1][0],
                    "mean_R_naive": sum(v for _, v in seg) / len(seg),
                    "n": len(seg)})

        min_len = min(wA[rA][1] - wA[rA][0], wB[rB][1] - wB[rB][0])
        res = {
            "target": tname,
            "a": o["a"], "b": o["b"],
            "a_rank": o["a_rank"], "b_rank": o["b_rank"],
            "overlap_log2": o["overlap_log2"],
            "frac_of_shorter": o["frac_of_shorter"],
            "delta_ln": d_obs, "delta_log2": d_obs / math.log(2),
            "shorter_window_log2": float(min_len),
            "position_matched_nonoverlap_null_possible":
                abs(d_obs / math.log(2)) >= float(min_len),
            "R_naive": Rn_obs, "R_naive_weighted": Rnw_obs,
            "R_corrected": R_corr, "R_corrected_weighted": Rcw_obs,
            "n_pairs_all": len(all_R), "n_pairs_null_nonoverlap":
                len(null_keys),
            "p_naive_vs_nonoverlap": pfrac(null_Rn, Rn_obs),
            "p_naive_weighted_vs_nonoverlap": pfrac(null_Rnw, Rnw_obs),
            "p_naive_vs_allpairs": pfrac(allp_Rn, Rn_obs),
            "p_naive_weighted_vs_allpairs": pfrac(allp_Rnw, Rnw_obs),
            "p_corrected": ("degenerate: identical at every pair of the "
                            "family by construction"),
            "p_corrected_weighted_vs_nonoverlap": pfrac(null_Rcw, Rcw_obs),
            "null_R_naive_min": min(null_Rn) if null_Rn else None,
            "null_R_naive_median":
                sorted(null_Rn)[len(null_Rn) // 2] if null_Rn else None,
            "null_R_naive_max": max(null_Rn) if null_Rn else None,
            "null_R_corrected_weighted_median":
                sorted(null_Rcw)[len(null_Rcw) // 2] if null_Rcw else None,
            "same_delta": same_delta,
            "R_vs_abs_delta_bins": bins,
        }
        results.append(res)

        print()
        print(THIN)
        print(f"  {tname}: {o['a']} vs {o['b']}   "
              f"overlap {o['overlap_log2']:.4f} log2, "
              f"frac_of_shorter {o['frac_of_shorter']:.4f}")
        print(THIN)
        print(f"    Delta (log2 window-top offset)     : "
              f"{res['delta_log2']:+.6f}")
        print(f"    shorter window length (log2)       : "
              f"{res['shorter_window_log2']:.4f}")
        print(f"    position-matched non-overlap null  : "
              f"{'possible' if res['position_matched_nonoverlap_null_possible'] else 'IMPOSSIBLE (|Delta| < shorter window)'}")
        print(f"    R naive / weighted                 : {Rn_obs:.6f}  /  "
              f"{Rnw_obs:.6f}")
        print(f"    R corrected / corrected weighted   : {R_corr:.6f}  /  "
              f"{Rcw_obs:.6f}")
        print(f"    null pairs (all / non-overlap)     : {len(all_R)} / "
              f"{len(null_keys)}")
        print(f"    p naive vs non-overlap null        : "
              f"{res['p_naive_vs_nonoverlap']:.4f}   "
              f"(weighted {res['p_naive_weighted_vs_nonoverlap']:.4f})")
        print(f"    p naive vs all pairs               : "
              f"{res['p_naive_vs_allpairs']:.4f}   "
              f"(weighted {res['p_naive_weighted_vs_allpairs']:.4f})")
        print(f"    p corrected                        : degenerate - "
              f"identical at every pair by construction")
        print(f"    p corrected-weighted vs non-overlap: "
              f"{res['p_corrected_weighted_vs_nonoverlap']:.4f}")
        if same_delta:
            print(f"    same-Delta pairs                   : "
                  f"{same_delta['n_same_delta_pairs']}, max |R diff| "
                  f"{same_delta['max_abs_R_naive_diff']:.3e}  "
                  f"(naive R is a function of Delta alone)")
        print(f"    naive R vs |Delta| (log2), all pairs, "
              f"{nbin} equal-count bins:")
        for bn in bins:
            print(f"      |Delta| {bn['abs_delta_log2_lo']:7.3f} .. "
                  f"{bn['abs_delta_log2_hi']:7.3f}   mean R "
                  f"{bn['mean_R_naive']:.6f}   n {bn['n']}", flush=True)

    # ----------------------------------------------- 6. precision check
    print()
    print(RULE)
    print(f"6. PRECISION CHECK - observed pairs recomputed fully in mpmath at")
    print(f"   dps {args.dps} and dps {args.precision_dps}; the float "
          f"assembly compared against both")
    print(RULE)
    pcheck = []
    print(f"  {'target':<16}{'stat':<22}{'float path':>14}"
          f"{'mp dps' + str(args.precision_dps):>16}{'rel diff':>12}")
    for res, (tname, o) in zip(results, targets):
        labA, rA, dA = parse_cell(o["a"])
        labB, rB, dB = parse_cell(o["b"])
        mp.dps = args.dps
        lo = observed_mp(labA, dA, rA, labB, dB, rB,
                         [mpmathify(s) for s in raw[:args.nzeros]])
        mp.dps = args.precision_dps
        hi = observed_mp(labA, dA, rA, labB, dB, rB,
                         [mpmathify(s) for s in raw[:args.nzeros]])
        mp.dps = args.dps
        flt = (res["R_naive"], res["R_naive_weighted"],
               res["R_corrected"], res["R_corrected_weighted"])
        names = ("R_naive", "R_naive_weighted",
                 "R_corrected", "R_corrected_weighted")
        for nm, f_, l_, h_ in zip(names, flt, lo, hi):
            rd_float = abs(f_ - h_) / abs(h_) if h_ else 0.0
            rd_mp = abs(l_ - h_) / abs(h_) if h_ else 0.0
            pcheck.append({"target": res["target"], "stat": nm,
                           "float": f_, "mp_lo": l_, "mp_hi": h_,
                           "rel_float_vs_hi": rd_float,
                           "rel_lo_vs_hi": rd_mp})
            print(f"  {res['target']:<16}{nm:<22}{f_:>14.8f}{h_:>16.8f}"
                  f"{rd_float:>12.2e}", flush=True)
    max_rel = max(p["rel_float_vs_hi"] for p in pcheck)
    max_rel_mp = max(p["rel_lo_vs_hi"] for p in pcheck)
    print(f"\n  max rel diff, float path vs dps {args.precision_dps}   : "
          f"{max_rel:.2e}")
    print(f"  max rel diff, dps {args.dps} vs dps {args.precision_dps}    : "
          f"{max_rel_mp:.2e}")

    print()
    print(RULE)
    print("EXPLORATORY. Nothing above is a verdict. No decision rule was")
    print("pre-registered and none fired. The reading is Julian's.")
    print(RULE)

    if not args.no_json:
        ended = datetime.datetime.now(datetime.timezone.utc)
        payload = {
            "schema_version": "1",
            "script": os.path.basename(__file__),
            "script_path": os.path.abspath(__file__),
            "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "status": ("EXPLORATORY - no prereg, no decision rule, no "
                       "verdict. Nothing here may be described as a "
                       "verdict."),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "dps": args.dps,
                "precision_dps": args.precision_dps,
                "nzeros": nz,
                "zeros_file": args.zeros,
                "geom_dps": GEOM_DPS,
                "gamma_1": GAMMA1_STR,
                "value_ceiling_exp": VALUE_CEILING_EXP,
                "pi_backend": pi_name,
                "source_files": source_files,
                "run_start_at": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "run_end_at": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
                "python": sys.version,
            },
            "constants": {
                "mode": ("z_k(b,r,d) = b^(r*rho_k) (1-b^(-rho_k))^(d+1) "
                         "/ rho_k, rho_k = 1/2 + i*gamma_k; n = d+1 because "
                         "O45's depth-0 row N(r) = pi(F[r]) - pi(F[r-1]) is "
                         "one backward difference of the cumulative ladder"),
                "statistic": ("delta_k = arg z_k^A - arg z_k^B; "
                              "R = |mean exp(i delta)|; weighted by "
                              "min(|z^A|,|z^B|); corrected subtracts "
                              "(r_A ln b_A - r_B ln b_B) * gamma_k"),
                "window_definition": o47["constants"]["window_definition"],
                "null": ("all resolved-cell pairs at the target's (base, "
                         "depth) pair; non-overlap subset has window "
                         "overlap_log2 = 0; exhaustive enumeration, no "
                         "sampling, no seed"),
                "containment_note": ("entry 201 records two frac_of_shorter "
                                     "= 1.0 pairs; the JSON holds "
                                     f"{len(containment)}; all are run"),
            },
            "summary": {
                "convention_verification": {
                    "per_base": verif,
                    "target_cells": tcell_out,
                    "sqrt2_discriminating_table": disc,
                    "recurrence_equals_binomial_everywhere": ident_bad == 0,
                    "mode_exponent": "n = d+1",
                },
                "targets": results,
                "precision_check": {
                    "max_rel_float_vs_hi": max_rel,
                    "max_rel_lo_vs_hi": max_rel_mp,
                    "rows": pcheck,
                },
            },
            "rows": [],
        }
        guarded_write(_jsonable(payload), args.out, allow_nan=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
