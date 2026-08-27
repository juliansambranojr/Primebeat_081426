#!/usr/bin/env python3
"""
O95 — multibase synthesis: the master-lattice arm family {b_j = exp(pi j /
      (4 gamma_1))}, j = 4..9, read as ONE instrument. Shakedown mode builds
      the pi cache and exercises the O17/O18 pipeline on synthetics only;
      real mode (gated) runs the joint measurement.

Reads with: notes/lab_notebook_2.md entry 211 (the approved design: the CRT
collapse of the joint alias set to nu == +/-1 (mod 8), the locked subsets,
the 2^40 ceiling, the power pricing), entry 210 (the synthetic-aperture
thesis), entry 199 (arm j = 4 as the boundary member), entry 209 (the R-at-
floor-points residual convention); O17_disjoint_block_residual.py and
O18_joint_multiplicative_ladder.py (the pipeline reproduced verbatim: Hann
window, NUFFT projection P(gamma) = |sum_j w_j ehat_j exp(-i gamma log x_j)|,
band half-width max(0.6, resolution), 5x median); O94_joint_localization.py
(the guarded pi-cache precedent); O93_overlap_identity.py (pi backend,
file_record, _jsonable — reused).

NAMING
------
The O-series runs O1-O9, O11..O95 with deliberate gaps at O10 and O28. The
next free number after O94 is O95; this file takes it. Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

STATUS
------
EXPLORATORY SHAKEDOWN. No prereg governs this script yet, no decision rule
fires, and NO VERDICT is written anywhere in its output. Every number the
shakedown prints is computed from synthetic residual vectors on the real
site GEOMETRY. The blind arm of entry 211's design is the union residual
vector e = c - Delta R on the real prime field: in shakedown mode this
script never computes, prints, or stores any residual, periodogram, or
statistic on the real prime data. The pi values themselves are public and
are written to the cache (allowed by the design); the pipeline's readout of
them is what stays unrun until the prereg is locked.

THE GEOMETRY (entry 211, restated)
----------------------------------
Master lattice spacing s = pi/(4 gamma_1) in log x. Sites

    x_i = floor(exp(i * s))          (exact integer floor at mp.dps 50)

Arm j samples the sites i == 0 (mod j); its log-x spacing is j*s, its
sampling frequency 2*pi/(j*s) = 8*gamma_1/j, so arm j confuses
nu == +/- 1 (mod 8/j) in units nu = gamma/gamma_1. Per-arm fold images of
gamma_1: j=5 -> 3*gamma_1/5 = 8.481, j=6 -> gamma_1/3 = 4.712,
j=7 -> gamma_1/7 = 2.019, j=8 -> 0 exactly (gamma_1 IS arm 8's sampling
frequency — the O48/O49 null base 1.5597), j=9 -> gamma_1/9 = 1.571.
Any coprime pair of aliased arms collapses the joint set to
nu == +/- 1 (mod 8): confusables {gamma_1, 7 gamma_1, 9 gamma_1, ...},
nearest 7*gamma_1 = 98.94, far outside the scan band [2, 45].

Locked subsets (entry 211): {5,6,7,8,9} primary, {8,9} secondary,
{4,5,6,7,8,9} as the labelled j = 4 sensitivity column. Ceiling 2^40.
x0 = 1000 primary, x0 = 2 sensitivity. Arms are INDEX MASKS over one site
array; N_eff is the union count, never the arm sum.

THE PIPELINE (O17/O18 verbatim; no new estimator)
-------------------------------------------------
Sites of a subset = union of its arms' rungs above x0, sorted, exact-integer
deduplicated. Blocks = the consecutive intervals (x_j, x_{j+1}]. Residual
e_j = c_j - (R(x_{j+1}) - R(x_j)) with c_j the exact count and R Riemann's
function AT THE FLOOR POINTS (entry 209's convention); ehat_j = e_j /
sqrt(x_j). Projection: Hann window over blocks,

    P(gamma) = | sum_j w_j ehat_j exp(-i gamma log x_j) |

on the grid gamma = 2.00 .. 45.00 step 0.01, log x_j the EXACT log of the
floored left endpoint. Detection threshold 5x median(P) over the band;
band half-width max(0.6, one frequency resolution element 2*pi/span).
The alias-candidate table (per-arm fold images of the target) is printed
with P evaluated at the exact candidate frequencies (off-grid).

SHAKEDOWN MODE (default) — everything except the real-field readout
-------------------------------------------------------------------
1. CACHE. Build (or verify) results/pi_master_lattice_cache.json: pi at
   every union site of arms {4..9}, x_i > 2, ceiling 2^40, via primecountpy
   (sympy fallback). Self-describing rows (i, x_i, pi(x_i)); guarded_write.
   The pi values are LOADED FOR THE CACHE REPORT ONLY; shakedown passes
   only the site geometry onward.
2. POWER GATE. Synthetic residuals ehat_j = A cos(gamma_p log x_j + phi) +
   N(0, sigma), sigma = 0.042 — O18's measured dyadic ehat rms
   (results/O18_joint_multiplicative_ladder_results.json,
   summary.ladders.L2.ehat_stats.rms = 0.04194), a PLACEHOLDER; the real
   rms is measured at prereg time. Plants: gamma_1, the per-arm aliases
   {1.571, 2.019, 4.712, 8.481}, and 7*gamma_1 = 98.94 as the must-confuse
   check — 7*gamma_1 is in gamma_1's JOINT alias class (nu = 7 == -1 mod
   8), so the instrument is SUPPOSED to read gamma_1 there; resolving it
   would signal a bug. 200 trials per cell, A/sigma in {0.5, 1, 2}, all
   three subsets. Phases uniform, one default_rng(2026) stream. TWO
   readouts per cell: (a) the DETECTION-GATED rate — grid argmax with
   P > 5x median assigned to a candidate within the band half-width, the
   O17/O18 detection discipline; (b) the DOMINANCE rate — entry 211's
   attribution readout, "the joint peak at the target dominating every
   per-arm fold image": P evaluated at the exact target frequency exceeds
   P at every other candidate frequency, threshold-free.
3. PER-ARM CONTROLS. Each arm alone through the identical pipeline on a
   synthetic gamma_1 plant: it must show its alias comb — fold images at
   comparable height (arm 8 reads through the higher images 2*gamma_1,
   3*gamma_1 only, because gamma_1 folds to DC and the band starts at 2).
   One noiseless run per arm (the criterion carrier) plus noisy trials at
   A/sigma = 2 for the ratio distribution.
4. COMPROMISED-DETECTOR. Entry 211: "if any single-arm control cleanly
   resolves gamma_1, the run is compromised — the theorem
   (Nyquist.nyquist_no_go) says that cannot happen." Concrete criterion,
   applied to the NOISELESS control of each aliased arm (j = 5..9; j = 4
   is the boundary member and is reported as a labelled sensitivity row,
   outside the criterion):

       comb_ratio_j = max over in-band fold images g != gamma_1 of P(g),
                      divided by P(gamma_1), both at exact frequencies.
       FIRES iff  (the grid argmax lies within the band half-width of
                   gamma_1)  AND  comb_ratio_j < 1 - X.

   X = 0.10 (--comb-x). Justification: aliasing on a uniform arm is an
   identity of the SAMPLING SET — exp(-i g' log x_k) = exp(-i g log x_k)
   at every arm site when g' - g is a multiple of 8 gamma_1/j — so the
   projection magnitude at every fold image equals the magnitude at
   gamma_1 for ANY residual vector, noise included. The only leakage is
   the floor jitter |log floor(e^{is}) - i*s| < 1e-3 above x0 = 1000,
   and this shakedown measures the resulting ratio deviations at ~1e-5,
   noiseless and noisy alike. X = 0.10 therefore sits four orders of
   magnitude above everything the arithmetic can produce: a ratio below
   0.90 is unreachable by an honest pipeline on an aliased arm and can
   only mean the pipeline manufactured the distinction (resampling,
   interpolation, wrong sites). The noisy-ratio distribution at
   A/sigma = 2 is reported alongside as the jitter measurement backing
   this margin.
5. PRECISION CHECK. The smooth term Delta R for one SYNTHETIC cell (the
   first primary-union block above x0 = 1000 — geometry only, no count)
   computed at dps 50 and recomputed at dps 80; both values and the
   relative difference reported. R is the only mpmath consumer in the
   pipeline; the synthetic statistics are float64 throughout.

ATTRIBUTION — the readout, stated mechanically (EXPLORATORY; the locked
rule is written at prereg time):
    The candidate set of a plant f under a subset = {f} union the in-band
    (2 <= g <= 45) per-arm fold images of f and of gamma_1 over the
    subset's arms, merged at 1e-6. Per trial, two readouts:
    DETECTION-GATED: the grid argmax g* with P(g*) > 5x median is
    assigned to the nearest candidate within the band half-width, else
    "unassigned"; below threshold is "no_detection". Headline per plant:
      gamma_1 plant      : fraction assigned to gamma_1
      in-band alias plant: fraction assigned to the plant itself
      1.571 plant        : fraction NOT assigned to gamma_1 (the plant sits
                           BELOW the scan band; the failure mode priced is
                           false gamma_1 attribution)
      7*gamma_1 plant    : fraction assigned to gamma_1 — the must-confuse
                           rate, expected HIGH; a low rate signals a bug.
    DOMINANCE (entry 211's attribution, threshold-free): the target
    frequency — gamma_1 for the gamma_1 / 7*gamma_1 / 1.571 plants, the
    plant itself for the in-band alias plants — evaluated off-grid,
    against every other candidate. Headline: fraction of trials where
    the target strictly dominates (for 1.571, the fraction where gamma_1
    does NOT dominate).

REAL MODE — implemented, gated, NOT run in this session
-------------------------------------------------------
--mode real refuses to run without --confirm-real: the prereg comes first.
When confirmed it reads the cache, forms c_j at the union sites, subtracts
Delta R at dps --dps, projects per subset and per arm, prints the alias-
candidate table on the real field, and guarded_writes
results/multibase_real.json. Nothing in this session invokes it.

GATES (shakedown)
-----------------
GATE A — SITE EXACTNESS. Every cached site re-satisfies
x_i = floor(exp(i*s)) at mp.dps 50, and x_i <= 2^40.
GATE B — GEOMETRY vs ENTRY 211. Union rung count above x0 = 1000 for
{5..9} = 199, arm-sum = 281, {8,9} = 84, resolution 0.303 — the approved
design's numbers, recomputed from scratch.
GATE C — PI SPOT AUDIT. pi at the first, last, and five fixed-seed random
cache sites re-evaluated against the backend (the cache values enter no
statistic in shakedown; the audit guards the artifact itself).

ENVELOPE
--------
House envelope, schema_version "1": script, generated_utc, params,
constants, summary, rows (one row per power-gate cell).
`params.code_version` is the sha256 of THIS file at runtime. All JSON goes
through utilities/resultsguard.guarded_write.

HOW IT IS RUN
-------------
    python3 utilities/run.py --python .venv/bin/python \
        --log results/O95_multibase_synthesis_run1.log O95_multibase_synthesis.py

REQUIREMENTS: numpy, mpmath, primecountpy (sympy fallback).
"""

import argparse
import datetime
import hashlib
import json
import math
import os
import sys
import time

import numpy as np
from mpmath import mp, mpf, riemannr
from mpmath import pi as mp_pi, exp as mp_exp, log as mp_log, floor as mp_floor

_HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, _HERE)
from utilities.resultsguard import guarded_write
import O93_overlap_identity as o93          # pi backend, file_record, _jsonable

DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT = os.path.join(DEFAULT_RESULTS_DIR, "multibase_shakedown.json")
DEFAULT_REAL_OUT = os.path.join(DEFAULT_RESULTS_DIR, "multibase_real.json")
DEFAULT_CACHE = os.path.join(DEFAULT_RESULTS_DIR, "pi_master_lattice_cache.json")
O18_RESULTS = os.path.join(DEFAULT_RESULTS_DIR,
                           "O18_joint_multiplicative_ladder_results.json")

RULE = "=" * 78
THIN = "-" * 78

GAMMA1_STR = "14.134725141734693"           # O93's constant, entry 211's
GAMMA1 = float(GAMMA1_STR)

ARMS = (4, 5, 6, 7, 8, 9)
SUBSETS = (
    ("primary_5to9", (5, 6, 7, 8, 9)),
    ("secondary_89", (8, 9)),
    ("sensitivity_4to9", (4, 5, 6, 7, 8, 9)),
)
ALIASED_ARMS = (5, 6, 7, 8, 9)              # j > 4; j = 4 is the boundary

BAND_LO, BAND_HI, GAMMA_STEP = 2.0, 45.0, 0.01
BAND_HALFWIDTH_FLOOR = 0.6                  # O17/O18 verbatim
BAND_MEDIAN_FACTOR = 5.0                    # O17/O18 verbatim

SIGMA_PLACEHOLDER = 0.042    # O18 dyadic ehat rms 0.04194 (see docstring)
A_OVER_SIGMA = (0.5, 1.0, 2.0)
SEED = 2026                                 # house fixed seed (O18, O7)

# The plants: gamma_1, the four per-arm fold images of gamma_1, 7*gamma_1.
PLANTS = (
    ("gamma1", GAMMA1),
    ("alias_j9_g1_over9", GAMMA1 / 9.0),        # 1.570525 — below the band
    ("alias_j7_g1_over7", GAMMA1 / 7.0),        # 2.019246
    ("alias_j6_g1_over3", GAMMA1 / 3.0),        # 4.711575
    ("alias_j5_3g1_over5", 3.0 * GAMMA1 / 5.0), # 8.480835
    ("seven_gamma1", 7.0 * GAMMA1),             # 98.943076 — must-confuse
)

FREQ_TOL = 1e-6

# Entry 211's design numbers, rechecked as GATE B.
GATE_B_EXPECT = {"primary_rungs": 199, "primary_arm_sum": 281,
                 "pair_rungs": 84}


def _code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def _utc():
    return datetime.datetime.now(datetime.timezone.utc)


def _stamp(dt):
    return dt.strftime("%Y-%m-%dT%H:%M:%SZ")


# --------------------------------------------------------------------------
# Geometry — the master lattice, at mp.dps 50.
# --------------------------------------------------------------------------

def lattice_spacing():
    """s = pi/(4 gamma_1) as an mpf at the CURRENT mp.dps."""
    return mp_pi / (4 * mpf(GAMMA1_STR))


def build_site_records(ceiling_pow, dps=50):
    """
    Every (i, x_i) with x_i = floor(exp(i*s)) an exact integer floor at
    mp.dps = dps, i a multiple of at least one arm in ARMS, x_i > 2 and
    x_i <= 2^ceiling_pow. Returns (records, s_as_float, s_as_str, imax).
    """
    old = mp.dps
    try:
        mp.dps = int(dps)
        s = lattice_spacing()
        ceiling = mpf(2) ** int(ceiling_pow)
        imax = int(mp_floor(mp_log(ceiling) / s))
        recs = []
        for i in range(1, imax + 1):
            if not any(i % j == 0 for j in ARMS):
                continue
            x = int(mp_floor(mp_exp(i * s)))
            if x <= 2:
                continue
            if x > (1 << int(ceiling_pow)):
                continue
            recs.append((i, x))
        return recs, float(s), mp.nstr(s, 40), imax
    finally:
        mp.dps = old


def unique_sites(recs):
    """
    Exact-integer dedup of the floored sites. Returns (xs, owner_arms,
    i_lists): xs ascending unique ints; owner_arms[k] = the set of arms j
    with some lattice index i in xs[k]'s i-list divisible by j; i_lists[k]
    the lattice indices mapping to xs[k] (duplicates happen only at the
    small-x end, where floors collide).
    """
    by_x = {}
    for i, x in recs:
        by_x.setdefault(x, []).append(i)
    xs = sorted(by_x)
    owner_arms, i_lists = [], []
    for x in xs:
        ilist = sorted(by_x[x])
        owner_arms.append(frozenset(j for j in ARMS
                                    for i in ilist if i % j == 0))
        i_lists.append(ilist)
    return xs, owner_arms, i_lists


def subset_sites(xs, owner_arms, arms, x0):
    """The union ladder of `arms` above x0: ascending list of exact ints."""
    aset = set(arms)
    return [x for x, own in zip(xs, owner_arms)
            if x > x0 and (own & aset)]


def arm_sum_count(xs, owner_arms, arms, x0):
    """Sum over arms of the per-arm rung count (the number entry 211 says
    N_eff must never be)."""
    tot = 0
    for j in arms:
        tot += sum(1 for x, own in zip(xs, owner_arms)
                   if x > x0 and j in own)
    return tot


# --------------------------------------------------------------------------
# Pipeline pieces — O17/O18 verbatim.
# --------------------------------------------------------------------------

def hann(n):
    """Hann window over n points: 0.5 - 0.5 cos(2 pi i / (n-1)). n<=1 -> ones."""
    if n <= 1:
        return np.ones(max(n, 0), dtype=np.float64)
    i = np.arange(n, dtype=np.float64)
    return 0.5 - 0.5 * np.cos(2.0 * math.pi * i / (n - 1))


def gamma_grid():
    return np.arange(BAND_LO, BAND_HI + 0.5 * GAMMA_STEP, GAMMA_STEP,
                     dtype=np.float64)


def block_geometry(sites):
    """
    Blocks are the consecutive intervals of the site ladder; the projection
    reads the EXACT log of the floored LEFT endpoints (O17's convention:
    logx over pts[:n_blocks]). Returns (logx, w, span, freq_res, halfwidth,
    n_blocks).
    """
    n_blocks = len(sites) - 1
    if n_blocks < 2:
        raise SystemExit("ladder too short for blocks")
    logx = np.log(np.asarray(sites[:n_blocks], dtype=np.float64))
    span = float(logx[-1] - logx[0])
    freq_res = 2.0 * math.pi / span
    halfwidth = max(BAND_HALFWIDTH_FLOOR, freq_res)
    w = hann(n_blocks)
    return logx, w, span, freq_res, halfwidth, n_blocks


def phase_matrices(grid, logx):
    """cos/sin of outer(grid, logx), precomputed once per geometry."""
    ph = np.outer(grid, logx)
    return np.cos(ph), np.sin(ph)


def project_single(logx, w, ehat, freqs):
    """P at arbitrary frequencies for ONE residual vector (off-grid eval)."""
    a = (w * ehat).astype(np.float64)
    ph = np.outer(np.asarray(freqs, dtype=np.float64), logx)
    re = np.cos(ph) @ a
    im = -(np.sin(ph) @ a)
    return np.sqrt(re * re + im * im)


# --------------------------------------------------------------------------
# Alias algebra.
# --------------------------------------------------------------------------

def fold_images(f, j, lo=BAND_LO, hi=BAND_HI):
    """
    In-band members of f's alias class under arm j: {|+-f + k * 8*gamma_1/j|}
    intersected with [lo, hi]. Uniform sampling at spacing j*s makes these
    EXACT confusions (exp(-i g' i j s) = exp(-i g i j s) for all lattice
    points when g' - g is a multiple of 2 pi/(j s) = 8 gamma_1 / j).
    """
    spacing = 8.0 * GAMMA1 / j
    out = set()
    for base in (f, -f):
        k = math.ceil((lo - base) / spacing - 1e-12)
        g = base + k * spacing
        while g <= hi + 1e-12:
            if g >= lo - 1e-12:
                out.add(round(g, 9))
            g += spacing
    return sorted(out)


def candidate_set(plant_f, arms):
    """
    Merged candidate list for attribution: (freq, category) with category
    precedence gamma1 > plant > g1_image > plant_image, merged at FREQ_TOL.
    """
    cands = {}

    def put(freq, cat):
        for existing in list(cands):
            if abs(existing - freq) <= FREQ_TOL:
                freq = existing
                break
        rank = {"gamma1": 0, "plant": 1, "g1_image": 2, "plant_image": 3}
        if freq not in cands or rank[cat] < rank[cands[freq]]:
            cands[freq] = cat

    if BAND_LO <= GAMMA1 <= BAND_HI:
        put(GAMMA1, "gamma1")
    if BAND_LO <= plant_f <= BAND_HI:
        put(plant_f, "plant")
    for j in arms:
        for g in fold_images(GAMMA1, j):
            if abs(g - GAMMA1) > FREQ_TOL:
                put(g, "g1_image")
        for g in fold_images(plant_f, j):
            if abs(g - plant_f) > FREQ_TOL and abs(g - GAMMA1) > FREQ_TOL:
                put(g, "plant_image")
    return sorted(cands.items())


# --------------------------------------------------------------------------
# The cache.
# --------------------------------------------------------------------------

def load_pi_cache(path):
    if not os.path.exists(path):
        return None
    with open(path) as fh:
        return json.load(fh)


def build_or_verify_cache(cache_path, recs, ceiling_pow, s_str, no_json):
    """
    Build results/pi_master_lattice_cache.json if absent; verify coverage
    and spot-audit if present. Returns the report dict AND the cache rows.
    The pi values returned here are used by the CACHE REPORT and by real
    mode only; shakedown's statistics see the site geometry alone.
    """
    pi_fn, pi_name = o93.load_pi_backend()
    existed = os.path.exists(cache_path)
    t0 = time.time()
    n_calls = 0
    if existed:
        cch = load_pi_cache(cache_path)
        rows = {int(r["i"]): (int(r["x"]), int(r["pi"])) for r in cch["sites"]}
        missing = [(i, x) for i, x in recs if i not in rows]
        mismatched = [(i, x) for i, x in recs
                      if i in rows and rows[i][0] != x]
        for i, x in missing:
            rows[i] = (x, int(pi_fn(x)))
            n_calls += 1
        status = "found"
        if mismatched:
            status = "found, x-values DISAGREE with the lattice"
        elif missing:
            status = f"found, extended by {len(missing)} sites"
    else:
        rows = {}
        for i, x in recs:
            rows[i] = (x, int(pi_fn(x)))
            n_calls += 1
        missing, mismatched = recs, []
        status = "absent; created this run"
    wall = time.time() - t0

    # GATE C — spot audit: first, last, five fixed-seed random sites.
    rng = np.random.default_rng(SEED)
    keys = sorted(rows)
    picks = {keys[0], keys[-1]}
    picks.update(int(keys[k]) for k in
                 rng.integers(0, len(keys), size=5))
    audit_bad = []
    for i in sorted(picks):
        x, p = rows[i]
        if int(pi_fn(x)) != p:
            audit_bad.append(i)
    audit_ok = not audit_bad

    payload = {
        "description": ("pi at the master-lattice sites x_i = "
                        "floor(exp(i*s)), s = pi/(4 gamma_1), exact floor "
                        "at mp.dps 50; union of arms {4..9} (i == 0 mod j), "
                        "x_i > 2, x_i <= 2^" + str(ceiling_pow) +
                        "; self-describing: i, x, pi per row"),
        "created_by": "O95_multibase_synthesis.py",
        "backend": pi_name,
        "gamma1_str": GAMMA1_STR,
        "s_str_dps50": s_str,
        "ceiling_pow": int(ceiling_pow),
        "arms": list(ARMS),
        "x0_floor": 2,
        "n_sites": len(rows),
        "sites": [{"i": i, "x": rows[i][0], "pi": rows[i][1]}
                  for i in sorted(rows)],
    }
    wrote = False
    if (not existed or missing) and not mismatched and not no_json:
        wrote = bool(guarded_write(o93._jsonable(payload), cache_path,
                                   allow_nan=False))
    xs_sorted = [rows[i][0] for i in sorted(rows)]
    report = {
        "path": cache_path,
        "existed_before_run": existed,
        "status": status,
        "backend": pi_name,
        "n_lattice_records": len(rows),
        "n_unique_x": len(set(xs_sorted)),
        "n_pi_calls_this_run": n_calls,
        "largest_pi_argument": max(xs_sorted),
        "smallest_x": min(xs_sorted),
        "wall_seconds": round(wall, 3),
        "spot_audit_sites_i": sorted(picks),
        "spot_audit_ok": audit_ok,
        "spot_audit_bad_i": audit_bad,
        "rewritten_this_run": wrote,
        "mismatched": [list(m) for m in mismatched],
    }
    return report, rows


# --------------------------------------------------------------------------
# The synthetic power cell.
# --------------------------------------------------------------------------

def run_cell(logx, w, C, S, grid, halfwidth, plant_f, amp, sigma, ntrials,
             rng, cands, target_f):
    """
    ntrials synthetic residual vectors ehat = amp*cos(f log x + phi) +
    N(0, sigma), pushed through the identical windowed NUFFT. Returns the
    detection-gated tally, the dominance count for target_f against the
    other candidates (off-grid, threshold-free), and the per-candidate
    mean P/median.
    """
    n = logx.size
    phis = rng.uniform(0.0, 2.0 * math.pi, size=ntrials)
    E = amp * np.cos(plant_f * logx[:, None] + phis[None, :])
    if sigma > 0.0:
        E = E + rng.normal(0.0, sigma, size=(n, ntrials))
    WE = w[:, None] * E
    RE = C @ WE
    IM = -(S @ WE)
    P = np.hypot(RE, IM)                      # (ngrid, ntrials)
    med = np.median(P, axis=0)
    kmax = np.argmax(P, axis=0)
    pk = P[kmax, np.arange(ntrials)]
    gpk = grid[kmax]
    detected = pk > BAND_MEDIAN_FACTOR * med

    cand_f = np.array([f for f, _ in cands], dtype=np.float64)
    cand_cat = [c for _, c in cands]
    # off-grid P at the exact candidate frequencies (the target appended
    # when it is not already a candidate, e.g. gamma_1 always is), per trial
    eval_f = list(cand_f)
    k_target = None
    for k, f in enumerate(eval_f):
        if abs(f - target_f) <= FREQ_TOL:
            k_target = k
            break
    if k_target is None:
        eval_f.append(float(target_f))
        k_target = len(eval_f) - 1
    ph = np.outer(np.asarray(eval_f, dtype=np.float64), logx)
    REc = np.cos(ph) @ WE
    IMc = -(np.sin(ph) @ WE)
    Pc = np.hypot(REc, IMc)                   # (neval, ntrials)

    # dominance: the target's exact-frequency P strictly above every other
    # candidate's, per trial (entry 211's attribution readout)
    others = [k for k in range(len(eval_f)) if k != k_target]
    if others:
        dom = Pc[k_target] > np.max(Pc[others], axis=0)
        n_dominates = int(np.sum(dom))
    else:
        n_dominates = None

    tallies = {"gamma1": 0, "plant": 0, "g1_image": 0, "plant_image": 0,
               "unassigned": 0, "no_detection": 0}
    for t in range(ntrials):
        if not detected[t]:
            tallies["no_detection"] += 1
            continue
        if cand_f.size:
            d = np.abs(cand_f - gpk[t])
            kb = int(np.argmin(d))
            if d[kb] <= halfwidth:
                tallies[cand_cat[kb]] += 1
                continue
        tallies["unassigned"] += 1

    cand_table = [{"freq": float(f), "category": c,
                   "mean_P_over_median": float(np.mean(Pc[k] / med))}
                  for k, (f, c) in enumerate(cands)]
    return {"tally": tallies, "n_trials": ntrials,
            "n_target_dominates": n_dominates,
            "median_peak_over_median": float(np.median(pk / med)),
            "candidates": cand_table}


def plant_target(plant_name, plant_f):
    """The dominance target: gamma_1 for the gamma_1 / 7*gamma_1 / 1.571
    plants, the plant itself for the in-band alias plants."""
    if plant_name in ("gamma1", "seven_gamma1", "alias_j9_g1_over9"):
        return GAMMA1
    return plant_f


def headline_rate(plant_name, tally, ntrials):
    """The per-plant detection-gated headline defined in the docstring."""
    if plant_name == "gamma1":
        return tally["gamma1"] / ntrials, "assigned_to_gamma1"
    if plant_name == "seven_gamma1":
        return tally["gamma1"] / ntrials, "confused_to_gamma1 (expected HIGH)"
    if plant_name == "alias_j9_g1_over9":
        return 1.0 - tally["gamma1"] / ntrials, "NOT_assigned_to_gamma1"
    return tally["plant"] / ntrials, "assigned_to_plant"


def dominance_rate(plant_name, n_dominates, ntrials):
    """The per-plant dominance headline: for the 1.571 plant the fraction
    where gamma_1 does NOT dominate; otherwise the target's dominance."""
    if n_dominates is None:
        return None, "no_other_candidates"
    if plant_name == "alias_j9_g1_over9":
        return (1.0 - n_dominates / ntrials,
                "gamma1_does_NOT_dominate_candidates")
    if plant_name in ("gamma1", "seven_gamma1"):
        return n_dominates / ntrials, "gamma1_dominates_candidates"
    return n_dominates / ntrials, "plant_dominates_candidates"


# --------------------------------------------------------------------------
# Per-arm control + compromised criterion.
# --------------------------------------------------------------------------

def per_arm_control(j, xs, owner_arms, x0, grid, amp, sigma, n_noisy, rng,
                    comb_x):
    """
    Arm j alone: synthetic gamma_1 plant through the identical pipeline.
    Noiseless run carries the comb table and the compromised criterion;
    n_noisy trials at (amp, sigma) give the ratio distribution.
    """
    sites = subset_sites(xs, owner_arms, (j,), x0)
    logx, w, span, freq_res, halfwidth, n_blocks = block_geometry(sites)
    C, S = phase_matrices(grid, logx)

    images_all = fold_images(GAMMA1, j)
    images = [g for g in images_all if abs(g - GAMMA1) > FREQ_TOL]
    eval_f = [GAMMA1] + images

    # --- noiseless (criterion carrier)
    e0 = amp * np.cos(GAMMA1 * logx)          # phase 0: deterministic
    P0 = np.hypot(C @ (w * e0), -(S @ (w * e0)))
    med0 = float(np.median(P0))
    k0 = int(np.argmax(P0))
    g0, p0 = float(grid[k0]), float(P0[k0])
    Pf0 = project_single(logx, w, e0, eval_f)
    p_g1 = float(Pf0[0])
    comb = [{"freq": float(f), "P": float(p),
             "ratio_to_P_gamma1": (float(p) / p_g1 if p_g1 > 0 else None)}
            for f, p in zip(eval_f, Pf0)]
    ratio0 = (max(c["ratio_to_P_gamma1"] for c in comb[1:])
              if len(comb) > 1 and p_g1 > 0 else None)
    argmax_at_g1 = abs(g0 - GAMMA1) <= halfwidth
    fires = bool(argmax_at_g1 and ratio0 is not None
                 and ratio0 < 1.0 - comb_x)

    # --- noisy ratio distribution
    ratios = []
    for _ in range(n_noisy):
        e = amp * np.cos(GAMMA1 * logx + rng.uniform(0, 2 * math.pi)) \
            + rng.normal(0.0, sigma, size=logx.size)
        Pf = project_single(logx, w, e, eval_f)
        if Pf[0] > 0 and len(Pf) > 1:
            ratios.append(float(np.max(Pf[1:]) / Pf[0]))
    ratios = np.asarray(ratios, dtype=np.float64)

    return {
        "arm": j,
        "is_boundary_member": j == 4,
        "n_rungs": len(sites),
        "n_blocks": n_blocks,
        "log_spacing_j_s": float(j) * float(mp_pi / (4 * mpf(GAMMA1_STR))),
        "nyquist_pi_over_js": 4.0 * GAMMA1 / j,
        "alias_spacing_8g1_over_j": 8.0 * GAMMA1 / j,
        "span": span, "freq_resolution": freq_res,
        "band_halfwidth_used": halfwidth,
        "in_band_images_of_gamma1": images_all,
        "noiseless": {
            "argmax_gamma": g0, "P_max": p0, "P_median": med0,
            "P_max_over_median": (p0 / med0 if med0 > 0 else None),
            "argmax_within_halfwidth_of_gamma1": bool(argmax_at_g1),
            "comb": comb,
            "tallest_image_ratio": ratio0,
        },
        "noisy": {
            "n_trials": int(ratios.size),
            "A_over_sigma": (amp / sigma if sigma > 0 else None),
            "ratio_min": (float(np.min(ratios)) if ratios.size else None),
            "ratio_p5": (float(np.percentile(ratios, 5))
                         if ratios.size else None),
            "ratio_median": (float(np.median(ratios))
                             if ratios.size else None),
        },
        "compromised_criterion": {
            "X": comb_x,
            "rule": ("FIRES iff grid argmax within band half-width of "
                     "gamma_1 AND tallest noiseless in-band fold image "
                     "< (1 - X) * P(gamma_1), exact-frequency evaluation"),
            "applies": j in ALIASED_ARMS,
            "fires": (fires if j in ALIASED_ARMS else None),
            "fires_value_if_boundary": (fires if j == 4 else None),
        },
    }


# --------------------------------------------------------------------------
# Precision check — the smooth term only; no count anywhere near it.
# --------------------------------------------------------------------------

def precision_check(sites, dps_lo, dps_hi):
    """Delta R for the first block (a SYNTHETIC cell: geometry, no count)
    at dps_lo and dps_hi."""
    x_a, x_b = int(sites[0]), int(sites[1])
    out = {"x_left": x_a, "x_right": x_b}
    for tag, d in (("lo", dps_lo), ("hi", dps_hi)):
        old = mp.dps
        try:
            mp.dps = int(d)
            dr = riemannr(mpf(x_b)) - riemannr(mpf(x_a))
            out[f"dps_{tag}"] = int(d)
            out[f"delta_R_dps_{tag}"] = float(dr)
            out[f"delta_R_str_dps_{tag}"] = mp.nstr(dr, 30)
        finally:
            mp.dps = old
    lo, hi = out["delta_R_dps_lo"], out["delta_R_dps_hi"]
    out["rel_diff"] = abs(lo - hi) / abs(hi) if hi != 0 else None
    return out


# --------------------------------------------------------------------------
# REAL MODE — implemented, gated. NOT run in this session.
# --------------------------------------------------------------------------

def run_real(args, xs, owner_arms, pi_rows):
    """
    The joint measurement on the real prime field. Reached only through
    --mode real --confirm-real, after a prereg is locked. Everything here
    mirrors the shakedown pipeline with c_j read from the cache.
    """
    grid = gamma_grid()
    pi_by_x = {}
    for i in sorted(pi_rows):
        x, p = pi_rows[i]
        pi_by_x[x] = p

    old = mp.dps
    results = {}
    try:
        mp.dps = int(args.dps)
        rcache = {}

        def R_at(x):
            if x not in rcache:
                rcache[x] = riemannr(mpf(int(x)))
            return rcache[x]

        units = [("subset", name, arms) for name, arms in SUBSETS] + \
                [("arm", f"arm_{j}", (j,)) for j in ARMS]
        for kind, name, arms in units:
            sites = subset_sites(xs, owner_arms, arms, args.x0)
            logx, w, span, freq_res, halfwidth, n_blocks = \
                block_geometry(sites)
            c = np.array([pi_by_x[sites[k + 1]] - pi_by_x[sites[k]]
                          for k in range(n_blocks)], dtype=np.float64)
            L = np.array([float(R_at(sites[k + 1]) - R_at(sites[k]))
                          for k in range(n_blocks)], dtype=np.float64)
            e = c - L
            ehat = e / np.sqrt(np.asarray(sites[:n_blocks],
                                          dtype=np.float64))
            C, S = phase_matrices(grid, logx)
            a = w * ehat
            P = np.hypot(C @ a, -(S @ a))
            med = float(np.median(P))
            k0 = int(np.argmax(P))
            cands = candidate_set(GAMMA1, arms)
            Pf = project_single(logx, w, ehat, [f for f, _ in cands])
            results[name] = {
                "kind": kind, "arms": list(arms),
                "n_rungs": len(sites), "n_blocks": n_blocks,
                "span": span, "freq_resolution": freq_res,
                "band_halfwidth_used": halfwidth,
                "ehat_rms": float(np.sqrt(np.mean(ehat * ehat))),
                "P_median": med,
                "argmax_gamma": float(grid[k0]), "P_max": float(P[k0]),
                "P_max_over_median": (float(P[k0]) / med if med > 0
                                      else None),
                "alias_candidate_table": [
                    {"freq": float(f), "category": cat,
                     "P": float(p),
                     "P_over_median": (float(p) / med if med > 0 else None)}
                    for (f, cat), p in zip(cands, Pf)],
            }
        prim_sites = subset_sites(xs, owner_arms, SUBSETS[0][1], args.x0)
        prec = precision_check(prim_sites, args.dps, args.precision_dps)
    finally:
        mp.dps = old

    payload = {
        "schema_version": "1",
        "script": os.path.basename(__file__),
        "generated_utc": _stamp(_utc()),
        "status": ("REAL-FIELD JOINT MEASUREMENT — check the governing "
                   "prereg before reading anything below as more than "
                   "mechanical output"),
        "params": {"code_version": _code_version(), "argv": sys.argv,
                   "mode": "real", "x0": args.x0, "dps": args.dps,
                   "precision_dps": args.precision_dps,
                   "ceiling_pow": args.ceiling_pow,
                   "band": [BAND_LO, BAND_HI], "gamma_step": GAMMA_STEP},
        "summary": {"units": results, "precision_check": prec},
        "rows": [],
    }
    if not args.no_json:
        guarded_write(o93._jsonable(payload), args.real_out, allow_nan=False)
    return 0


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------

def parse_args():
    ap = argparse.ArgumentParser(
        description=("O95 — multibase synthesis. Default --mode shakedown "
                     "is EXPLORATORY: cache build + synthetics only; the "
                     "real-field joint measurement is gated behind "
                     "--mode real --confirm-real."))
    ap.add_argument("--mode", choices=("shakedown", "real"),
                    default="shakedown")
    ap.add_argument("--confirm-real", action="store_true",
                    help="required with --mode real; without it the script "
                         "refuses: the prereg comes first")
    ap.add_argument("--ceiling-pow", type=int, default=40,
                    help="value ceiling 2^this (default 40, entry 211)")
    ap.add_argument("--x0", type=float, default=1000.0,
                    help="primary ladder floor (default 1000; x0 = 2 is "
                         "the design's sensitivity setting)")
    ap.add_argument("--trials", type=int, default=200,
                    help="trials per power-gate cell (default 200)")
    ap.add_argument("--control-trials", type=int, default=50,
                    help="noisy trials per per-arm control (default 50)")
    ap.add_argument("--sigma", type=float, default=SIGMA_PLACEHOLDER,
                    help="synthetic noise rms (default 0.042 = O18's "
                         "measured dyadic ehat rms; PLACEHOLDER — the "
                         "real rms is measured at prereg time)")
    ap.add_argument("--comb-x", type=float, default=0.10,
                    help="X in the compromised criterion (default 0.10; "
                         "see docstring for the justification)")
    ap.add_argument("--seed", type=int, default=SEED)
    ap.add_argument("--dps", type=int, default=50,
                    help="mpmath dps for R (default 50)")
    ap.add_argument("--precision-dps", type=int, default=80)
    ap.add_argument("--cache", type=str, default=DEFAULT_CACHE)
    ap.add_argument("--out", type=str, default=DEFAULT_OUT)
    ap.add_argument("--real-out", type=str, default=DEFAULT_REAL_OUT)
    ap.add_argument("--no-json", action="store_true")
    return ap.parse_args()


def main():
    args = parse_args()
    started = _utc()

    if args.mode == "real" and not args.confirm_real:
        print(RULE)
        print("O95 — REAL MODE REFUSED")
        print(RULE)
        print("  The real-field joint periodogram is the design's blind arm.")
        print("  The prereg comes first: lock the protocol against the")
        print("  shakedown-exercised pipeline, then run with")
        print("      --mode real --confirm-real")
        print("  Nothing was computed.")
        return 2

    print(RULE)
    print("O95 — MULTIBASE SYNTHESIS — " +
          ("SHAKEDOWN" if args.mode == "shakedown" else "REAL"))
    if args.mode == "shakedown":
        print("EXPLORATORY SHAKEDOWN. No prereg, no decision rule, NO")
        print("VERDICT. All statistics below are computed from SYNTHETIC")
        print("residual vectors on the real site geometry. The union")
        print("residual on the real prime field stays unread.")
    print(RULE)
    print(f"  started (UTC)   : {_stamp(started)}")
    print(f"  code_version    : {_code_version()}")
    print(f"  seed            : {args.seed}")
    print(f"  ceiling         : 2^{args.ceiling_pow}")
    print(f"  band            : [{BAND_LO:g}, {BAND_HI:g}] step "
          f"{GAMMA_STEP:g}")
    print(f"  sigma (synth)   : {args.sigma}  (O18 dyadic ehat rms "
          f"0.04194, placeholder)", flush=True)

    # ---------------------------------------------------------- geometry
    print()
    print(RULE)
    print("THE MASTER LATTICE — s = pi/(4 gamma_1), exact floors at dps 50")
    print(RULE)
    recs, s_float, s_str, imax = build_site_records(args.ceiling_pow)
    xs, owner_arms, i_lists = unique_sites(recs)
    print(f"  s               : {s_str}")
    print(f"  i range         : 1..{imax}  (union members with x > 2: "
          f"{len(recs)} lattice records, {len(xs)} unique sites)")
    print(f"  first sites     : {xs[:6]}")
    print(f"  last site       : {xs[-1]}  (2^{args.ceiling_pow} = "
          f"{1 << args.ceiling_pow})")

    # GATE A — every site re-satisfies its definition
    gate_a_bad = []
    old = mp.dps
    try:
        mp.dps = 50
        s_mp = lattice_spacing()
        for i, x in recs:
            v = mp_exp(i * s_mp)
            if not (mpf(x) <= v < mpf(x + 1)):
                gate_a_bad.append(i)
            if x > (1 << args.ceiling_pow):
                gate_a_bad.append(i)
    finally:
        mp.dps = old
    print(f"  GATE A (x_i = floor(exp(i s)), x_i <= ceiling) : "
          f"{'PASS' if not gate_a_bad else 'FAIL ' + str(gate_a_bad[:8])}")

    # GATE B — entry 211's design numbers, recomputed
    prim = subset_sites(xs, owner_arms, SUBSETS[0][1], args.x0)
    pair = subset_sites(xs, owner_arms, SUBSETS[1][1], args.x0)
    sens = subset_sites(xs, owner_arms, SUBSETS[2][1], args.x0)
    arm_sum = arm_sum_count(xs, owner_arms, SUBSETS[0][1], args.x0)
    gate_b = {"primary_rungs": len(prim), "primary_arm_sum": arm_sum,
              "pair_rungs": len(pair)}
    gate_b_ok = (args.ceiling_pow != 40 or args.x0 != 1000.0
                 or gate_b == GATE_B_EXPECT)
    print(f"  GATE B (entry 211 geometry at 2^40, x0=1000)   : "
          f"{'PASS' if gate_b_ok else 'FAIL'}  "
          f"union {len(prim)} (design 199), arm-sum {arm_sum} (design 281), "
          f"pair {len(pair)} (design 84)")
    if gate_a_bad or not gate_b_ok:
        print("\n  OPENING GATES FAILED — stopping before any statistic.")
        return 1

    # ------------------------------------------------------------- cache
    print()
    print(RULE)
    print("THE CACHE — pi at every union site (arms {4..9}, x > 2)")
    print(RULE)
    cache_report, pi_rows = build_or_verify_cache(
        args.cache, recs, args.ceiling_pow, s_str, args.no_json)
    print(f"  path            : {cache_report['path']}")
    print(f"  status          : {cache_report['status']}")
    print(f"  backend         : {cache_report['backend']}")
    print(f"  lattice records : {cache_report['n_lattice_records']}   "
          f"unique x: {cache_report['n_unique_x']}")
    print(f"  pi calls (run)  : {cache_report['n_pi_calls_this_run']}")
    print(f"  x range         : {cache_report['smallest_x']} .. "
          f"{cache_report['largest_pi_argument']}")
    print(f"  wall            : {cache_report['wall_seconds']} s")
    print(f"  GATE C spot audit (i = {cache_report['spot_audit_sites_i']}) "
          f": {'PASS' if cache_report['spot_audit_ok'] else 'FAIL'}",
          flush=True)
    if cache_report["mismatched"]:
        print("  cache x-values disagree with the lattice — stopping.")
        return 1
    if not cache_report["spot_audit_ok"]:
        print("  pi spot audit failed — stopping.")
        return 1

    if args.mode == "real":
        return run_real(args, xs, owner_arms, pi_rows)

    # From here on, SHAKEDOWN: geometry only. The pi values drop out of
    # scope — no residual, no periodogram, no statistic touches them.
    del pi_rows

    grid = gamma_grid()
    rng = np.random.default_rng(args.seed)

    # -------------------------------------------------- N_eff and spans
    print()
    print(RULE)
    print("N_eff — union counts against arm sums (the union is the "
          "instrument)")
    print(RULE)
    neff = {}
    print(f"  {'subset':>18} {'x0':>6} {'union':>7} {'arm-sum':>9} "
          f"{'span':>9} {'resol':>8} {'halfw':>7}")
    for name, arms in SUBSETS:
        for x0 in (args.x0, 2.0):
            sites = subset_sites(xs, owner_arms, arms, x0)
            _, _, span, res, hw, nb = block_geometry(sites)
            asum = arm_sum_count(xs, owner_arms, arms, x0)
            key = f"{name}_x0_{int(x0)}"
            neff[key] = {"subset": name, "arms": list(arms), "x0": x0,
                         "union_rungs": len(sites), "arm_sum": asum,
                         "n_blocks": nb, "span": span,
                         "freq_resolution": res,
                         "band_halfwidth_used": hw}
            print(f"  {name:>18} {int(x0):>6} {len(sites):>7} {asum:>9} "
                  f"{span:>9.3f} {res:>8.4f} {hw:>7.4f}")
    print("\n  mean log-gap, primary union: "
          f"{neff['primary_5to9_x0_1000']['span'] / neff['primary_5to9_x0_1000']['n_blocks']:.4f}"
          f"  (pi/gamma_1 = {math.pi / GAMMA1:.4f}); pair {'{8,9}'}: "
          f"{neff['secondary_89_x0_1000']['span'] / neff['secondary_89_x0_1000']['n_blocks']:.4f}",
          flush=True)

    # -------------------------------------------- alias-candidate tables
    print()
    print(RULE)
    print("ALIAS CANDIDATES — per-arm fold images (exact confusions of "
          "uniform arms)")
    print(RULE)
    alias_tables = {}
    for j in ARMS:
        imgs = fold_images(GAMMA1, j)
        alias_tables[f"gamma1_arm_{j}"] = imgs
        print(f"  arm {j}: alias spacing {8.0 * GAMMA1 / j:>8.4f}   "
              f"in-band images of gamma_1: "
              f"{', '.join(f'{g:.4f}' for g in imgs)}")
    print(f"  joint (any coprime aliased pair): nu == +/-1 (mod 8) — "
          f"nearest confusable 7 gamma_1 = {7 * GAMMA1:.4f}, outside "
          f"[{BAND_LO:g}, {BAND_HI:g}]", flush=True)

    # ---------------------------------------------------- the power gate
    print()
    print(RULE)
    print(f"THE POWER GATE — {args.trials} trials/cell, synthetic "
          f"plants over N(0, {args.sigma})")
    print(RULE)
    print("  gated  : detection-gated headline (argmax > 5x median within")
    print("           halfwidth) — gamma_1 -> assigned to gamma_1; in-band")
    print("           alias -> assigned to the plant; 1.571 (below band) ->")
    print("           NOT assigned to gamma_1; 7 gamma_1 -> confused to")
    print("           gamma_1 (expected HIGH).")
    print("  domin  : entry 211's attribution — the target's off-grid P")
    print("           strictly dominating every other candidate, no")
    print("           threshold (same headline orientation per plant).")
    power_rows = []
    subset_geo = {}
    for name, arms in SUBSETS:
        sites = subset_sites(xs, owner_arms, arms, args.x0)
        logx, w, span, res, hw, nb = block_geometry(sites)
        C, S = phase_matrices(grid, logx)
        subset_geo[name] = (sites, logx, w, C, S, hw)
    for name, arms in SUBSETS:
        sites, logx, w, C, S, hw = subset_geo[name]
        print(f"\n  SUBSET {name}  arms {list(arms)}  blocks {logx.size}  "
              f"halfwidth {hw:.4f}")
        print(f"  {'plant':>22} {'freq':>9} {'A/sig':>6} {'gated':>7} "
              f"{'domin':>7} "
              f"{'g1':>6} {'plant':>6} {'g1img':>6} {'pimg':>6} "
              f"{'unass':>6} {'nodet':>6}")
        for pname, pf in PLANTS:
            cands = candidate_set(pf, arms)
            tf = plant_target(pname, pf)
            for aos in A_OVER_SIGMA:
                amp = aos * args.sigma
                cell = run_cell(logx, w, C, S, grid, hw, pf, amp,
                                args.sigma, args.trials, rng, cands, tf)
                rate, rate_def = headline_rate(pname, cell["tally"],
                                               cell["n_trials"])
                dom, dom_def = dominance_rate(pname,
                                              cell["n_target_dominates"],
                                              cell["n_trials"])
                t = cell["tally"]
                nt = cell["n_trials"]
                print(f"  {pname:>22} {pf:>9.4f} {aos:>6.1f} "
                      f"{rate:>7.3f} "
                      f"{(dom if dom is not None else float('nan')):>7.3f} "
                      f"{t['gamma1'] / nt:>6.2f} {t['plant'] / nt:>6.2f} "
                      f"{t['g1_image'] / nt:>6.2f} "
                      f"{t['plant_image'] / nt:>6.2f} "
                      f"{t['unassigned'] / nt:>6.2f} "
                      f"{t['no_detection'] / nt:>6.2f}", flush=True)
                power_rows.append({
                    "subset": name, "arms": list(arms),
                    "plant": pname, "plant_freq": pf,
                    "A_over_sigma": aos, "amp": amp,
                    "sigma": args.sigma,
                    "gated_rate": rate,
                    "gated_definition": rate_def,
                    "dominance_rate": dom,
                    "dominance_definition": dom_def,
                    "dominance_target_freq": tf,
                    "tally": t, "n_trials": nt,
                    "median_peak_over_median":
                        cell["median_peak_over_median"],
                    "candidates": cell["candidates"],
                })

    # ------------------------------------------------- per-arm controls
    print()
    print(RULE)
    print("PER-ARM CONTROLS — each arm alone, synthetic gamma_1 plant "
          f"(A/sigma = 2)")
    print(RULE)
    print("  The control is the theorem: every aliased arm must show its")
    print("  comb. Arm 8's gamma_1 folds to DC; its comb reads through the")
    print("  higher images 2 gamma_1 = 28.269, 3 gamma_1 = 42.404 only.")
    controls = {}
    fired = []
    for j in ARMS:
        ctl = per_arm_control(j, xs, owner_arms, args.x0, grid,
                              2.0 * args.sigma, args.sigma,
                              args.control_trials, rng, args.comb_x)
        controls[f"arm_{j}"] = ctl
        nl = ctl["noiseless"]
        print(f"\n  ARM {j}{'  (boundary member, sensitivity row)' if j == 4 else ''}"
              f"  rungs {ctl['n_rungs']}  Nyquist "
              f"{ctl['nyquist_pi_over_js']:.4f}  alias spacing "
              f"{ctl['alias_spacing_8g1_over_j']:.4f}")
        print(f"    noiseless comb (P at exact freqs; ratio to "
              f"P(gamma_1) = {nl['comb'][0]['P']:.6g}):")
        for c in nl["comb"]:
            tag = "gamma_1" if abs(c["freq"] - GAMMA1) < FREQ_TOL else "image"
            print(f"      {c['freq']:>10.4f}  P {c['P']:>12.6g}  "
                  f"ratio {c['ratio_to_P_gamma1']:.4f}  [{tag}]")
        print(f"    grid argmax {nl['argmax_gamma']:.4f}  "
              f"P_max/median {nl['P_max_over_median']:.2f}  "
              f"argmax at gamma_1: "
              f"{'yes' if nl['argmax_within_halfwidth_of_gamma1'] else 'no'}")
        print(f"    tallest-image ratio (noiseless) : "
              f"{nl['tallest_image_ratio']:.4f}")
        ny = ctl["noisy"]
        print(f"    noisy ratio ({ny['n_trials']} trials): min "
              f"{ny['ratio_min']:.4f}  p5 {ny['ratio_p5']:.4f}  median "
              f"{ny['ratio_median']:.4f}")
        cc = ctl["compromised_criterion"]
        if cc["applies"]:
            print(f"    COMPROMISED CRITERION (X = {cc['X']:g}) : "
                  f"{'FIRES' if cc['fires'] else 'does not fire'}")
            if cc["fires"]:
                fired.append(j)
        else:
            print(f"    criterion row (labelled sensitivity, j = 4 is the "
                  f"boundary member): would "
                  f"{'FIRE' if cc['fires_value_if_boundary'] else 'not fire'}",
                  flush=True)
    print()
    if fired:
        print(f"  COMPROMISED: arms {fired} cleanly single out gamma_1 — "
              f"the pipeline is manufacturing the distinction.")
    else:
        print("  No aliased arm singles out gamma_1: every single-arm "
              "control shows its comb.", flush=True)

    # -------------------------------------------------- precision check
    print()
    print(RULE)
    print("PRECISION CHECK — Delta R on one synthetic cell (geometry only)")
    print(RULE)
    prec = precision_check(prim, args.dps, args.precision_dps)
    print(f"  cell            : ({prec['x_left']}, {prec['x_right']}]  "
          f"(first primary-union block above x0 = {args.x0:g})")
    print(f"  Delta R dps {prec['dps_lo']}  : {prec['delta_R_str_dps_lo']}")
    print(f"  Delta R dps {prec['dps_hi']}  : {prec['delta_R_str_dps_hi']}")
    print(f"  rel diff        : {prec['rel_diff']:.3e}", flush=True)

    # -------------------------------------------------------- statement
    print()
    print(RULE)
    print("BLIND-ARM STATEMENT")
    print(RULE)
    print("  No residual, periodogram, or statistic was computed on the")
    print("  real prime field in this run. pi values were computed and")
    print("  written to the cache (allowed by entry 211's design) and were")
    print("  read for the cache report and spot audit only; the shakedown")
    print("  statistics saw the site geometry alone. The union residual")
    print("  vector stays unread until the prereg is locked.", flush=True)

    ended = _utc()
    print(f"\n  ended (UTC)     : {_stamp(ended)}")
    print(f"  elapsed         : {(ended - started).total_seconds():.1f} s")

    if not args.no_json:
        source_files = []
        for p, role in ((os.path.join(_HERE, "O93_overlap_identity.py"),
                         "reused_machinery"),
                        (O18_RESULTS, "sigma_placeholder_source")):
            if os.path.exists(p):
                source_files.append(o93.file_record(p, role))
        payload = {
            "schema_version": "1",
            "script": os.path.basename(__file__),
            "generated_utc": _stamp(ended),
            "status": ("EXPLORATORY SHAKEDOWN — synthetics on the real "
                       "site geometry; no real-field residual, "
                       "periodogram, or statistic computed; no verdict"),
            "params": {
                "code_version": _code_version(),
                "argv": sys.argv,
                "mode": "shakedown",
                "seed": args.seed,
                "ceiling_pow": args.ceiling_pow,
                "x0_primary": args.x0,
                "x0_sensitivity": 2.0,
                "trials_per_cell": args.trials,
                "control_trials": args.control_trials,
                "sigma": args.sigma,
                "sigma_provenance": ("O18 L2 ehat rms 0.04194 "
                                     "(results/O18_joint_multiplicative_"
                                     "ladder_results.json summary.ladders."
                                     "L2.ehat_stats.rms); placeholder — "
                                     "real rms measured at prereg time"),
                "A_over_sigma": list(A_OVER_SIGMA),
                "comb_x": args.comb_x,
                "dps": args.dps, "precision_dps": args.precision_dps,
                "band": [BAND_LO, BAND_HI], "gamma_step": GAMMA_STEP,
                "band_halfwidth_floor": BAND_HALFWIDTH_FLOOR,
                "band_median_factor": BAND_MEDIAN_FACTOR,
                "cache": cache_report,
                "source_files": source_files,
                "run_start_at": _stamp(started),
                "run_end_at": _stamp(ended),
                "python": sys.version,
            },
            "constants": {
                "gamma1_str": GAMMA1_STR,
                "s_str_dps50": s_str,
                "lattice": ("x_i = floor(exp(i * pi/(4 gamma_1))), exact "
                            "floor at dps 50; arm j = the sites i == 0 "
                            "(mod j); arms 4..9; ceiling 2^" +
                            str(args.ceiling_pow)),
                "alias_algebra": ("arm j confuses nu == +/-1 (mod 8/j), "
                                  "nu = gamma/gamma_1; alias spacing "
                                  "8 gamma_1/j; coprime aliased pairs "
                                  "collapse jointly to nu == +/-1 (mod 8)"),
                "pipeline": ("O17/O18 verbatim: blocks (x_j, x_{j+1}], "
                             "ehat_j = e_j/sqrt(x_j), Hann over blocks, "
                             "P(gamma) = |sum w ehat exp(-i gamma "
                             "log x_j)| at the exact logs of the floored "
                             "left endpoints, grid [2,45] step 0.01, "
                             "detection 5x median, band half-width "
                             "max(0.6, 2 pi/span)"),
                "attribution": ("two readouts per trial: DETECTION-GATED "
                                "— grid argmax with P > 5x median "
                                "assigned to the nearest candidate "
                                "(plant, gamma_1, or their per-arm fold "
                                "images) within the band half-width; "
                                "DOMINANCE (entry 211's attribution) — "
                                "the target's off-grid P strictly above "
                                "every other candidate, threshold-free; "
                                "headline rates per plant as documented"),
                "compromised_criterion": (
                    f"X = {args.comb_x:g}: an aliased arm's NOISELESS "
                    "gamma_1 control fires iff its grid argmax lies "
                    "within the band half-width of gamma_1 AND its "
                    "tallest in-band fold image (exact-frequency "
                    "evaluation) < (1-X) * P(gamma_1)"),
                "subsets": {n: list(a) for n, a in SUBSETS},
                "plants": {n: f for n, f in PLANTS},
            },
            "summary": {
                "gates": {"gate_a_site_exactness": not gate_a_bad,
                          "gate_b_entry211_geometry": gate_b,
                          "gate_b_expected": GATE_B_EXPECT,
                          "gate_c_pi_spot_audit":
                              cache_report["spot_audit_ok"]},
                "n_eff": neff,
                "alias_images_of_gamma1": alias_tables,
                "per_arm_controls": controls,
                "compromised_arms": fired,
                "precision_check": prec,
                "blind_arm_statement": (
                    "no real-field residual, periodogram, or statistic "
                    "computed this run; pi values written to the cache "
                    "and read only for the cache report and spot audit"),
            },
            "rows": power_rows,
        }
        guarded_write(o93._jsonable(payload), args.out, allow_nan=False)
    return 0


if __name__ == "__main__":
    sys.exit(main())
