#!/usr/bin/env python3
"""
O42 — are the four exact zeros turn marks on a spiral? The winding phase.

Reads with: preregs/zero_winding_phase_v1_locked_20260818.md,
            papers/Euler-Factor-Chain.md (A1, D5),
            lean/Zeros.lean, lean/Construction.lean

STATUS: PREREGISTERED — but only once
`preregs/zero_winding_phase_v1_locked_20260818.md` says LOCKED. While that
file says DRAFT this script must not be run for record. Nothing it prints
is a verdict; the mechanical output of the decision rule is reported and
the verdict line is Julian's (CLAUDE.md § Prereg discipline).

PROVENANCE: written 2026-08-18, before the prereg was locked and before
any run.

WHAT THIS MEASURES
  The backward dyadic prime difference table has exactly four exact zeros
  over its whole support. From results/O16_run2.log, section
  "EXACT ZEROS (depth >= 1), all four tables":

        backward_prime:  4 zero(s)
          (r= 2, d= 1)   (r= 4, d= 1)   (r= 8, d= 3)   (r=20, d= 6)

  and section "TABLE EXTENTS" gives that table 1953 cells, max r 62, max
  depth 61. The same four cells appear in
  results/O16_centered_difference_table_run2.json at
  constants.documented_backward_zeros.

  lean/Zeros.lean records that nothing in the chain predicts those
  locations; lean/Construction.lean records that the construction has no
  free parameter, so they were not placed either. The posit under test is
  that they are turn marks on a spiral: each zero a point of balance,
  after which the structure advances a fixed angle and grows again.

  The winding coordinate is the chain's own symbol, not a new one.
  papers/Euler-Factor-Chain.md A1: on the ladder x = b^r the backward
  difference applied to the mode x^rho returns (1 - b^-rho) * x^rho. So
  one step in r multiplies by b^rho and one step in depth multiplies by
  (1 - b^-rho). On Re(rho) = 1/2, taking arguments,

        Phi(r,d) = r*gamma*log b  +  d*arg(1 - b^-rho),   rho = 1/2 + i*gamma

  REFERENCES.md already locks the r-step half at the first zero in base 2:
  omega_1 = 3.514260 rad/regime (gamma_1 * ln 2, aliases to 2.7689).
  Euler-Factor-Chain.md D5 states the same unreduced: 201.3 degrees,
  1.559 turns per rung.

  Five tests, all specified in the prereg before any run:

    A  quarter turn     — is every consecutive gap within tol_quarter of
                          pi/2, at any scanned gamma?
    B  constant angle   — is the circular range of the three gaps at or
                          below tol_spread, at any scanned gamma? Report
                          the minimising gamma and that minimum spread.
    C  same-depth       — (2,1) and (4,1) share d = 1. Both readings:
       collision         four zeros / three gaps, and the merged three
                          zeros / two gaps, computed for BOTH merge
                          representatives. Neither may be selected after
                          the fact.
    D  the null         — the same min-over-gamma spread for random cell
                          sets drawn from the same support, seed 2026.
                          Without this the spread criterion fires on
                          roughly one arbitrary cell set in ten.
    E  rate law         — fit the r-gaps (2, 4, 12) and d-gaps (0, 2, 3)
                          and extrapolate one turn. State whether the
                          predicted fifth zero is inside the r <= 62,
                          d <= 61 box O16 actually searched.

PRECISION
  mpmath at the locked dps for every observed statistic. float64 for the
  null loop only: the largest null phase argument is under 2e4 rad, so the
  mod-2pi error is under 1e-11 rad, eleven orders below tol_spread. That
  split is a locked parameter, not a convenience.

  The zero cache zeros600.json carries 25 significant digits, so the cache
  is the precision floor and the arithmetic is not.

HOW IT WILL BE RUN (do not run while the prereg says DRAFT)
  .venv/bin/python O42_zero_winding_phase.py \
      --base 2 --dps 50 --zeros 200 \
      --tol-quarter 0.10 --tol-spread 0.10 --n-null 20000 \
      --alpha 0.05 \
      --zeros-cache zeros600.json \
      --o16-log results/O16_run2.log \
      --out results/zero_winding_phase.json \
      2>&1 | tee results/O42_zero_winding_phase_run1.log

  Every flag is passed explicitly. There is no --seed flag: the null seed
  is hardcoded at 2026 per REFERENCES.md and the house prereg
  preregs/alpha_depth_trend_v1_locked_20260814.md.

REQUIREMENTS: mpmath, numpy. Both already in the venv (REFERENCES.md).
"""
import argparse
import datetime
import hashlib
import json
import math
import os
import re
import sys

import numpy as np
from mpmath import mp, mpf, mpc, atan2, log as mlog, cos as mcos, sin as msin, sqrt as msqrt

_HERE = os.path.dirname(os.path.abspath(__file__))

# ---------------------------------------------------------------------------
# LOCKED, NOT FLAGS
# ---------------------------------------------------------------------------

# Seed. Hardcoded on purpose. REFERENCES.md section "Constants used across the
# bench" records seed 2026 with the note "do not add a --seed flag"; the house
# prereg repeats it. Adding a flag here would break prereg discipline.
NULL_SEED = 2026

# The zero set under test. results/O16_run2.log, section EXACT ZEROS,
# backward_prime. Re-read from that log at run time and compared; a mismatch
# trips the `compromised` branch.
LOCKED_ZEROS = ((2, 1), (4, 1), (8, 3), (20, 6))

# The null domain. results/O16_run2.log section TABLE EXTENTS gives the
# backward_prime table 1953 cells over depths 0..61 with max r 62. The support
# is r = d+1 .. R, so the d = 0 row holds 62 of those cells and depths d >= 1
# hold 1891. Zeros are only counted at d >= 1 in that log, so the null draws
# from the d >= 1 part of the support. The rectangle r <= 62, d <= 61 is NOT
# the support and drawing from it would draw cells that do not exist.
SUPPORT_RMAX = 62
SUPPORT_DMAX = 61
SUPPORT_DMIN = 1

# compromised-branch thresholds, locked in the prereg's decision rule.
MIN_VALID_NULL_DRAWS = 19000
MIN_SYMBOL_MODULUS = 1e-12

TWO_PI_F = 2.0 * np.pi


# ---------------------------------------------------------------------------
# housekeeping
# ---------------------------------------------------------------------------

def code_version():
    """sha256 of this file. CONTEXT.md records the known weakness: this is
    read at write time, not at import time, so an edit landing mid-run
    mislabels the result. Recorded, not fixed here."""
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def utcnow():
    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


# ---------------------------------------------------------------------------
# inputs
# ---------------------------------------------------------------------------

def read_o16_zeros(path):
    """Re-read the backward_prime exact zeros out of the O16 log.

    Returns a tuple of (r, d) pairs in file order. The log's block reads

        backward_prime:  4 zero(s)
          (r= 2, d= 1)  partner[backward_composite]=1  ...
    """
    with open(path) as fh:
        lines = fh.read().splitlines()
    out, inside = [], False
    cell = re.compile(r"^\s*\(r=\s*(\d+),\s*d=\s*(\d+)\)")
    for ln in lines:
        if re.match(r"^\s*backward_prime:\s+\d+ zero", ln):
            inside = True
            continue
        if inside:
            m = cell.match(ln)
            if m:
                out.append((int(m.group(1)), int(m.group(2))))
            elif ln.strip() and not ln.startswith("    "):
                break
            elif ln.strip() == "":
                break
    return tuple(out)


def read_gammas(path, count):
    """First `count` imaginary parts from the zero cache. CONTEXT.md section
    Caches: zeros600.json holds 600 entries at dps 25, written by mkzeros.py
    from mpmath.zetazero. Stored as decimal strings; mpf parses them at the
    current working precision."""
    with open(path) as fh:
        raw = json.load(fh)
    if len(raw) < count:
        return None, len(raw)
    return [mpf(s) for s in raw[:count]], len(raw)


# ---------------------------------------------------------------------------
# the phase map  (papers/Euler-Factor-Chain.md A1)
# ---------------------------------------------------------------------------

def step_phases(gamma, base):
    """Return (phi_r, phi_d, modulus) at this gamma.

    phi_r   = gamma * log(base)          — one step in r multiplies by b^rho
    phi_d   = arg(1 - base^-rho)         — one step in depth multiplies by
                                           (1 - b^-rho)
    modulus = |1 - base^-rho|            — guards the compromised branch;
                                           arg is undefined at 0.

    On Re(rho) = 1/2, base^-rho = base^-1/2 * exp(-i * gamma * log base).
    """
    lb = mlog(mpf(base))
    phi_r = gamma * lb
    amp = 1 / msqrt(mpf(base))
    theta = phi_r                      # gamma * log base
    z = mpc(1 - amp * mcos(theta), amp * msin(theta))   # 1 - b^-rho
    return phi_r, atan2(z.imag, z.real), abs(z)


def wrap_mp(x):
    """Reduce an mpmath angle into [0, 2*pi)."""
    two_pi = 2 * mp.pi
    y = mp.fmod(x, two_pi)
    return y + two_pi if y < 0 else y


def circ_range_mp(angles):
    """Circular range of angles already reduced into [0, 2*pi): sort on the
    circle, find the largest wrap-around gap G, return 2*pi - G. Rotation
    invariant, so it cannot smuggle in a preferred angle. Zero iff all the
    angles coincide."""
    if len(angles) < 2:
        return mpf(0)
    a = sorted(angles)
    two_pi = 2 * mp.pi
    gaps = [a[i + 1] - a[i] for i in range(len(a) - 1)]
    gaps.append(a[0] + two_pi - a[-1])
    return two_pi - max(gaps)


def circ_dist_mp(a, b):
    """Shortest angular distance between two angles, in [0, pi]."""
    two_pi = 2 * mp.pi
    d = wrap_mp(a - b)
    return d if d <= mp.pi else two_pi - d


def circ_mean_mp(angles):
    """Circular mean, reduced into [0, 2*pi)."""
    sx = sum(mcos(a) for a in angles)
    sy = sum(msin(a) for a in angles)
    return wrap_mp(atan2(sy, sx))


def gaps_of(cells):
    """Consecutive (delta_r, delta_d) for cells ordered by r ascending."""
    c = sorted(cells)
    return [(c[i + 1][0] - c[i][0], c[i + 1][1] - c[i][1]) for i in range(len(c) - 1)]


def scan_spread(cells, phr, phd):
    """Observed arm, mpmath. For each scanned gamma reduce the consecutive gap
    phases mod 2*pi and take their circular range. Return the full per-gamma
    record plus the argmin."""
    steps = gaps_of(cells)
    rows = []
    for i, (pr, pd) in enumerate(zip(phr, phd)):
        g = [wrap_mp(dr * pr + dd * pd) for dr, dd in steps]
        rows.append(dict(index=i, gaps=g, spread=circ_range_mp(g)))
    best = min(rows, key=lambda r: r["spread"])
    return steps, rows, best


# ---------------------------------------------------------------------------
# the null  (Test D)
# ---------------------------------------------------------------------------

def support_cells():
    """Every (r, d) in the backward-prime support with d >= 1."""
    return [(r, d)
            for d in range(SUPPORT_DMIN, SUPPORT_DMAX + 1)
            for r in range(d + 1, SUPPORT_RMAX + 1)]


def null_min_spread(dr, dd, A, B):
    """Vectorised float64 min-over-gamma circular range.

    dr, dd : (ndraw, ngap) integer step counts
    A, B   : (M,) per-r-step and per-d-step phases
    returns: (ndraw,) minimum circular range over the M gammas,
             (ndraw,) index of the minimising gamma,
             (ndraw,) bool — did some gamma put every gap within
                      tol_quarter of pi/2 (filled by the caller)
    """
    # (ndraw, ngap, M)
    ph = (dr[:, :, None] * A[None, None, :] + dd[:, :, None] * B[None, None, :])
    ph = np.mod(ph, TWO_PI_F)
    s = np.sort(ph, axis=1)
    gaps = np.diff(s, axis=1)
    wrapgap = (s[:, 0, :] + TWO_PI_F - s[:, -1, :])[:, None, :]
    biggest = np.max(np.concatenate([gaps, wrapgap], axis=1), axis=1)
    spread = TWO_PI_F - biggest                      # (ndraw, M)
    return ph, spread


def quarter_hits(ph, tol):
    """ph : (ndraw, ngap, M). True where every gap is within `tol` of pi/2."""
    d = np.abs(ph - (np.pi / 2.0))
    d = np.minimum(d, TWO_PI_F - d)
    return np.all(d <= tol, axis=1)                  # (ndraw, M)


def run_null(cells_size, A, B, n_null, tol_quarter, rng,
             require_nondecreasing_d=False, chunk=500):
    """Draw n_null cell sets of size `cells_size` from the support (d >= 1),
    distinct cells and distinct r, ordered by r ascending; return the
    min-over-gamma spread of each and the Test-A firing flag of each."""
    cells = np.array(support_cells(), dtype=np.int64)
    n_cells = len(cells)
    spreads, aflags, drawn = [], [], 0
    attempts, max_attempts = 0, 200 * n_null
    while drawn < n_null and attempts < max_attempts:
        want = min(chunk, n_null - drawn)
        # oversample, then filter; rejection is cheap at this size
        idx = rng.integers(0, n_cells, size=(want * 4, cells_size))
        pick = cells[idx]                                    # (k, size, 2)
        ok = np.ones(len(pick), dtype=bool)
        for i in range(cells_size):
            for j in range(i + 1, cells_size):
                ok &= pick[:, i, 0] != pick[:, j, 0]         # distinct r
        pick = pick[ok]
        attempts += want * 4
        if len(pick) == 0:
            continue
        order = np.argsort(pick[:, :, 0], axis=1)
        pick = np.take_along_axis(pick, order[:, :, None], axis=1)
        if require_nondecreasing_d:
            keep = np.all(np.diff(pick[:, :, 1], axis=1) >= 0, axis=1)
            pick = pick[keep]
            if len(pick) == 0:
                continue
        pick = pick[:want]
        dr = np.diff(pick[:, :, 0], axis=1).astype(np.float64)
        dd = np.diff(pick[:, :, 1], axis=1).astype(np.float64)
        ph, spread = null_min_spread(dr, dd, A, B)
        spreads.append(spread.min(axis=1))
        aflags.append(quarter_hits(ph, tol_quarter).any(axis=1))
        drawn += len(pick)
    if not spreads:
        return np.array([]), np.array([])
    return np.concatenate(spreads), np.concatenate(aflags)


def p_value(null_spreads, observed):
    """p = (1 + #{null <= observed}) / (1 + n). Add-one; never exactly 0."""
    n = len(null_spreads)
    return (1 + int(np.sum(null_spreads <= observed))) / (1 + n) if n else float("nan")


# ---------------------------------------------------------------------------
# Test E
# ---------------------------------------------------------------------------

def ols(xs, ys):
    m = len(xs)
    sx, sy = sum(xs), sum(ys)
    den = m * sum(x * x for x in xs) - sx * sx
    slope = (m * sum(x * y for x, y in zip(xs, ys)) - sx * sy) / den
    return slope, (sy - slope * sx) / m


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap.add_argument("--base", type=int, required=True,
                    help="ladder base b (locked: 2)")
    ap.add_argument("--dps", type=int, required=True,
                    help="mpmath working precision for observed statistics (locked: 50)")
    ap.add_argument("--zeros", type=int, required=True,
                    help="M, number of zeta zeros scanned (locked: 200)")
    ap.add_argument("--tol-quarter", type=float, required=True,
                    help="rad; Test A fires only within this of pi/2 (locked: 0.10)")
    ap.add_argument("--tol-spread", type=float, required=True,
                    help="rad; Test B fires only at or below this (locked: 0.10)")
    ap.add_argument("--n-null", type=int, required=True,
                    help="Test D draws (locked: 20000)")
    ap.add_argument("--alpha", type=float, required=True,
                    help="one-sided level (locked: 0.05)")
    ap.add_argument("--zeros-cache", required=True,
                    help="path to zeros600.json (locked: project root)")
    ap.add_argument("--o16-log", required=True,
                    help="path to results/O16_run2.log, re-read to verify the zero set")
    ap.add_argument("--out", required=True,
                    help="results JSON path (locked: results/zero_winding_phase.json)")
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()

    zeros_cache = args.zeros_cache if os.path.isabs(args.zeros_cache) \
        else os.path.join(_HERE, args.zeros_cache)
    o16_log = args.o16_log if os.path.isabs(args.o16_log) \
        else os.path.join(_HERE, args.o16_log)
    out_path = args.out if os.path.isabs(args.out) else os.path.join(_HERE, args.out)

    mp.dps = args.dps
    started = utcnow()
    compromised = []

    print("=" * 78)
    print("O42 — zero winding phase: are the four exact zeros turn marks on a spiral?")
    print("=" * 78)
    print("  prereg   : preregs/zero_winding_phase_v1_locked_20260818.md")
    print("  phase map: Phi(r,d) = r*gamma*log b + d*arg(1 - b^-rho), rho = 1/2 + i*gamma")
    print("             papers/Euler-Factor-Chain.md A1")
    print("  NOTE     : the verdict line is Julian's. What follows is the decision")
    print("             rule's mechanical output, not a verdict.")
    print()
    print("  base            :", args.base)
    print("  dps             :", args.dps)
    print("  zeros scanned M :", args.zeros)
    print("  tol_quarter     :", args.tol_quarter, "rad")
    print("  tol_spread      :", args.tol_spread, "rad")
    print("  n_null          :", args.n_null)
    print("  alpha           :", args.alpha)
    print("  seed            :", NULL_SEED, "(hardcoded; no --seed flag, per REFERENCES.md)")
    print("  zeros cache     :", zeros_cache)
    print("  O16 log         :", o16_log)
    print("  code_version    :", code_version())

    # -- zero set, re-read from the artifact ---------------------------------
    print()
    print("-" * 78)
    print("ZERO SET — re-read from the O16 log, not from memory")
    print("-" * 78)
    log_zeros = read_o16_zeros(o16_log)
    print("  read from log :", list(log_zeros))
    print("  locked        :", list(LOCKED_ZEROS))
    if tuple(log_zeros) != LOCKED_ZEROS:
        compromised.append("zero set read from O16 log differs from the locked zero_set")
        print("  MATCH         : NO  -> compromised")
    else:
        print("  MATCH         : yes")
    cells = list(LOCKED_ZEROS)

    # -- zeros ---------------------------------------------------------------
    gammas, cache_len = read_gammas(zeros_cache, args.zeros)
    print()
    print("-" * 78)
    print("ZETA ZEROS")
    print("-" * 78)
    print("  cache entries :", cache_len)
    if gammas is None:
        compromised.append(f"zeros cache holds {cache_len} entries, fewer than M={args.zeros}")
        print("  M available   : NO  -> compromised")
        gammas = []
    else:
        print("  M used        :", len(gammas))
        print("  gamma_1       :", mp.nstr(gammas[0], 25))
        print("  gamma_M       :", mp.nstr(gammas[-1], 25))

    phr, phd, moduli = [], [], []
    for g in gammas:
        pr, pd, mod = step_phases(g, args.base)
        phr.append(pr); phd.append(pd); moduli.append(mod)
        if mod < MIN_SYMBOL_MODULUS:
            compromised.append(f"|1 - b^-rho| < {MIN_SYMBOL_MODULUS} at gamma index {len(phr)-1}")

    if gammas:
        print()
        print("  per-step phases at gamma_1 (base %d):" % args.base)
        print("    per r-step, unreduced : ", mp.nstr(phr[0], 12), "rad")
        print("    per r-step, mod 2*pi  : ", mp.nstr(wrap_mp(phr[0]), 12), "rad")
        print("      (REFERENCES.md locks omega_1 = 3.514260 rad/regime;")
        print("       Euler-Factor-Chain.md D5 says 201.3 deg, 1.559 turns per rung)")
        print("    per d-step            : ", mp.nstr(phd[0], 12), "rad")
        print("    |1 - b^-rho|          : ", mp.nstr(moduli[0], 12))

    if not gammas:
        print()
        print("No zeros available; cannot proceed to tests A-E.")
        print("MECHANICAL DECISION-RULE OUTPUT: compromised")
        for c in compromised:
            print("  -", c)
        return

    # -- Tests A / B on the primary four-zero reading ------------------------
    steps, rows, best = scan_spread(cells, phr, phd)
    print()
    print("-" * 78)
    print("TEST B — constant angle (primary): four zeros, three gaps")
    print("-" * 78)
    print("  cells :", cells)
    print("  steps :", [(int(a), int(b)) for a, b in steps], " (delta_r, delta_d)")
    print()
    print("  %-6s %-26s %-12s %-12s %-12s %-12s" %
          ("idx", "gamma", "gap1", "gap2", "gap3", "spread"))
    # gamma_1 always shown (provenance: not blind), plus the minimiser, plus
    # the ten smallest spreads.
    show = sorted({0, best["index"]} |
                  {r["index"] for r in sorted(rows, key=lambda r: r["spread"])[:10]})
    for i in show:
        r = rows[i]
        print("  %-6d %-26s %-12s %-12s %-12s %-12s%s" %
              (i, mp.nstr(gammas[i], 18),
               mp.nstr(r["gaps"][0], 8), mp.nstr(r["gaps"][1], 8),
               mp.nstr(r["gaps"][2], 8), mp.nstr(r["spread"], 8),
               "   <- min" if i == best["index"] else ""))
    print()
    print("  minimising gamma index :", best["index"])
    print("  minimising gamma       :", mp.nstr(gammas[best["index"]], 25))
    print("  S_obs (circular range) :", mp.nstr(best["spread"], 12), "rad")
    print("  common angle at min    :", mp.nstr(circ_mean_mp(best["gaps"]), 12), "rad")
    print("  tol_spread             :", args.tol_spread)
    b_spread_ok = float(best["spread"]) <= args.tol_spread
    print("  spread <= tol_spread   :", b_spread_ok)

    print()
    print("-" * 78)
    print("TEST A — quarter turn: every gap within tol_quarter of pi/2")
    print("-" * 78)
    half_pi = mp.pi / 2
    a_hits = []
    for r in rows:
        if all(circ_dist_mp(g, half_pi) <= mpf(args.tol_quarter) for g in r["gaps"]):
            a_hits.append(r["index"])
    print("  pi/2 =", mp.nstr(half_pi, 12), " tol_quarter =", args.tol_quarter)
    print()
    print("  at gamma_1 (NOT BLIND — see the prereg's provenance section;")
    print("  the assistant hand-estimated these before the prereg was written):")
    for k, g in enumerate(rows[0]["gaps"]):
        print("    gap%d = %-14s  |gap - pi/2| = %s" %
              (k + 1, mp.nstr(g, 10), mp.nstr(circ_dist_mp(g, half_pi), 10)))
    print()
    print("  at the Test-B minimising gamma (index %d):" % best["index"])
    for k, g in enumerate(best["gaps"]):
        print("    gap%d = %-14s  |gap - pi/2| = %s" %
              (k + 1, mp.nstr(g, 10), mp.nstr(circ_dist_mp(g, half_pi), 10)))
    print()
    print("  gamma indices where ALL three gaps are within tol_quarter of pi/2:")
    print("   ", a_hits if a_hits else "(none)")
    a_at_min = best["index"] in a_hits
    print("  Test A fires at the Test-B minimiser :", a_at_min)

    # -- Test C --------------------------------------------------------------
    print()
    print("-" * 78)
    print("TEST C — the same-depth collision: (2,1) and (4,1) share d = 1")
    print("-" * 78)
    print("  Both merge representatives are computed. The prereg forbids")
    print("  selecting one after the fact; the merged reading counts only if")
    print("  both representatives fire the same way.")
    merged = {}
    for rep in ((2, 1), (4, 1)):
        mcells = [rep, (8, 3), (20, 6)]
        msteps, mrows, mbest = scan_spread(mcells, phr, phd)
        m_ok = float(mbest["spread"]) <= args.tol_spread
        merged[str(rep)] = dict(
            cells=mcells,
            steps=[[int(a), int(b)] for a, b in msteps],
            best_index=mbest["index"],
            best_gamma=mp.nstr(gammas[mbest["index"]], 25),
            min_spread=float(mbest["spread"]),
            gaps_at_min=[float(g) for g in mbest["gaps"]],
            common_angle_at_min=float(circ_mean_mp(mbest["gaps"])),
            spread_within_tol=bool(m_ok),
        )
        print()
        print("  representative %-7s cells %s" % (str(rep), mcells))
        print("    steps                 :", [(int(a), int(b)) for a, b in msteps])
        print("    minimising gamma index:", mbest["index"])
        print("    minimising gamma      :", mp.nstr(gammas[mbest["index"]], 25))
        print("    min spread (2 gaps)   :", mp.nstr(mbest["spread"], 12), "rad")
        print("    gaps at min           :",
              [mp.nstr(g, 10) for g in mbest["gaps"]])
        print("    spread <= tol_spread  :", m_ok)
    both_agree = (merged["(2, 1)"]["spread_within_tol"] ==
                  merged["(4, 1)"]["spread_within_tol"])
    print()
    print("  representatives agree :", both_agree)

    # -- Test D --------------------------------------------------------------
    print()
    print("-" * 78)
    print("TEST D — the null (mandatory; without it Test B cannot fail)")
    print("-" * 78)
    A = np.array([float(x) for x in phr], dtype=np.float64)
    B = np.array([float(x) for x in phd], dtype=np.float64)
    n_support = len(support_cells())
    print("  null domain      : backward-prime support, d >= 1,")
    print("                     1 <= d <= %d, d+1 <= r <= %d" % (SUPPORT_DMAX, SUPPORT_RMAX))
    print("  cells in domain  :", n_support,
          "(O16 log: 1953 cells over d = 0..61; the d = 0 row holds 62)")
    print("  draw shape       : distinct cells, distinct r, ordered by r ascending")
    print("  arithmetic       : float64 (locked); max |phase| < 2e4 rad,")
    print("                     mod-2pi error < 1e-11 rad, 11 orders below tol_spread")
    print("  seed             :", NULL_SEED)

    rng = np.random.default_rng(NULL_SEED)
    null4, aflag4 = run_null(4, A, B, args.n_null, args.tol_quarter, rng)
    print()
    print("  primary null (4 cells / 3 gaps): draws returned", len(null4))
    if len(null4) < MIN_VALID_NULL_DRAWS:
        compromised.append(
            f"primary null returned {len(null4)} valid draws, below {MIN_VALID_NULL_DRAWS}")
    p_primary = p_value(null4, float(best["spread"]))
    a_null_rate = float(np.mean(aflag4)) if len(aflag4) else float("nan")
    if len(null4):
        print("    null min-spread  mean %.6f  sd %.6f  min %.6f" %
              (null4.mean(), null4.std(), null4.min()))
        print("    quantiles 1/5/50 %%    %.6f  %.6f  %.6f" %
              tuple(np.quantile(null4, [0.01, 0.05, 0.50])))
    print("    S_obs                :", mp.nstr(best["spread"], 12))
    print("    p (primary)          : %.6f" % p_primary)
    print("    alpha                :", args.alpha)
    print("    p <= alpha           :", p_primary <= args.alpha)
    print("    Test A null firing rate (fraction of draws where some gamma")
    print("      puts all 3 gaps within tol_quarter of pi/2): %.6f" % a_null_rate)

    rng3 = np.random.default_rng(NULL_SEED)
    null3, aflag3 = run_null(3, A, B, args.n_null, args.tol_quarter, rng3)
    p_merged = {}
    print()
    print("  merged null (3 cells / 2 gaps): draws returned", len(null3))
    for rep in ("(2, 1)", "(4, 1)"):
        pv = p_value(null3, merged[rep]["min_spread"])
        p_merged[rep] = pv
        print("    representative %-8s S_obs %.6f   p %.6f" %
              (rep, merged[rep]["min_spread"], pv))

    rng_s = np.random.default_rng(NULL_SEED)
    null_s, _ = run_null(4, A, B, args.n_null, args.tol_quarter, rng_s,
                         require_nondecreasing_d=True)
    p_secondary = p_value(null_s, float(best["spread"])) if len(null_s) else float("nan")
    print()
    print("  SECONDARY null (non-decreasing d; reported, cannot change the verdict)")
    print("    draws returned :", len(null_s))
    print("    p (secondary)  : %.6f" % p_secondary)

    # -- Test E --------------------------------------------------------------
    print()
    print("-" * 78)
    print("TEST E — rate law and forward prediction")
    print("-" * 78)
    dr = [int(a) for a, _ in steps]
    dd = [int(b) for _, b in steps]
    ks = [1.0, 2.0, 3.0]
    print("  r-gaps :", dr, "   d-gaps :", dd,
          "  (arithmetic on the locked zero set)")
    slope_r, icpt_r = ols(ks, [math.log(x) for x in dr])
    dr4 = math.exp(icpt_r + slope_r * 4.0)
    slope_d, icpt_d = ols(ks, [float(x) for x in dd])
    dd4 = icpt_d + slope_d * 4.0
    r5 = cells[-1][0] + dr4
    d5 = cells[-1][1] + dd4
    print("  ln(r-gap) ~ a + c*k : c = %.6f  a = %.6f  (growth factor per turn %.6f)"
          % (slope_r, icpt_r, math.exp(slope_r)))
    print("  d-gap     ~ a + c*k : c = %.6f  a = %.6f" % (slope_d, icpt_d))
    print("  extrapolated turn 4 : delta_r = %.4f   delta_d = %.4f" % (dr4, dd4))
    print("  predicted 5th zero  : (r, d) ~ (%.3f, %.3f)  -> nearest cell (%d, %d)"
          % (r5, d5, round(r5), round(d5)))
    inside_box = (round(r5) <= SUPPORT_RMAX and round(d5) <= SUPPORT_DMAX)
    in_support = round(r5) >= round(d5) + 1
    print("  inside the O16 search box (r <= %d, d <= %d) : %s"
          % (SUPPORT_RMAX, SUPPORT_DMAX, inside_box))
    print("  inside the table support (r >= d+1)          :", in_support)
    if not inside_box:
        print("  -> O16's 'exactly four' is a statement about the box only. A")
        print("     predicted zero outside it is UNREFUTED, not refuted.")
    else:
        print("  -> This position IS inside the box O16 searched, and O16 found")
        print("     no zero there. The rate law predicts a zero that is absent.")
    print("  Test E is interpretable only if Test B fires; a rate law through")
    print("  three points with no constant angle behind it is curve fitting.")

    # -- mechanical decision-rule output -------------------------------------
    b_fires = b_spread_ok and (p_primary <= args.alpha)
    if compromised:
        mech = "compromised"
    elif b_fires and a_at_min:
        mech = "quarter_turn"
    elif b_fires and not a_at_min:
        mech = "constant_angle"
    elif not b_fires:
        mech = "no_constant_angle"
    else:
        mech = "ambiguous"
    # ambiguity override: primary fires but the merged reading contradicts it
    if mech in ("quarter_turn", "constant_angle"):
        merged_fires = (merged["(2, 1)"]["spread_within_tol"] and
                        merged["(4, 1)"]["spread_within_tol"])
        if not both_agree or not merged_fires:
            mech = "ambiguous"

    print()
    print("=" * 78)
    print("MECHANICAL DECISION-RULE OUTPUT (NOT A VERDICT)")
    print("=" * 78)
    print("  Test B spread <= tol_spread      :", b_spread_ok)
    print("  Test D p <= alpha                :", p_primary <= args.alpha)
    print("  Test A fires at the minimiser    :", a_at_min)
    print("  Test C representatives agree     :", both_agree)
    print("  compromised conditions tripped   :", compromised if compromised else "(none)")
    print()
    print("  label the decision rule selects  :", mech)
    print()
    print("  The verdict line in the prereg's Run record is Julian's to write.")
    print("  CLAUDE.md § Prereg discipline: an agent may compute the SHA and")
    print("  report the decision rule's mechanical output; it does not stamp")
    print("  the verdict.")

    ended = utcnow()

    # -- results -------------------------------------------------------------
    if not args.no_json:
        payload = dict(
            schema_version="1",
            script=os.path.basename(__file__),
            generated_utc=ended,
            params=dict(
                base=args.base, dps=args.dps, zeros_scanned=args.zeros,
                tol_quarter=args.tol_quarter, tol_spread=args.tol_spread,
                n_null=args.n_null, alpha=args.alpha, seed=NULL_SEED,
                seed_is_flag=False,
                zeros_cache=zeros_cache, zeros_cache_entries=cache_len,
                o16_log=o16_log,
                null_domain=dict(d_min=SUPPORT_DMIN, d_max=SUPPORT_DMAX,
                                 r_max=SUPPORT_RMAX, cells=n_support,
                                 rule="r = d+1 .. 62, d >= 1 (backward-prime support)"),
                null_arithmetic="float64 for the null loop; mpmath dps for observed",
                run_start_at=started, run_end_at=ended,
                code_version=code_version(),
                prereg="preregs/zero_winding_phase_v1_locked_20260818.md",
            ),
            constants=dict(
                phase_map="Phi(r,d) = r*gamma*log b + d*arg(1 - b^-rho), rho = 1/2 + i*gamma",
                phase_map_source="papers/Euler-Factor-Chain.md A1",
                omega_1_reference="3.514260 rad/regime (REFERENCES.md)",
                turns_per_rung_reference="1.559 turns per rung, 201.3 deg (Euler-Factor-Chain.md D5)",
                locked_zeros=[list(c) for c in LOCKED_ZEROS],
                locked_zeros_source="results/O16_run2.log, section EXACT ZEROS, backward_prime",
                zeros_read_from_log=[list(c) for c in log_zeros],
                spread_statistic="circular range: 2*pi minus the largest wrap-around gap",
                p_definition="(1 + #{null <= observed}) / (1 + n_null)",
                verdict_labels=["quarter_turn", "constant_angle",
                                "no_constant_angle", "ambiguous", "compromised"],
                precedence="compromised > quarter_turn > constant_angle > "
                           "no_constant_angle > ambiguous",
                verdict_note="the verdict line is Julian's; this file records the "
                             "decision rule's mechanical output only",
            ),
            summary=dict(
                test_A=dict(
                    gamma_indices_all_gaps_near_half_pi=a_hits,
                    fires_at_test_b_minimiser=bool(a_at_min),
                    gaps_at_gamma_1=[float(g) for g in rows[0]["gaps"]],
                    gaps_at_gamma_1_not_blind=True,
                    null_firing_rate=a_null_rate,
                ),
                test_B=dict(
                    min_spread=float(best["spread"]),
                    minimising_index=best["index"],
                    minimising_gamma=mp.nstr(gammas[best["index"]], 25),
                    gaps_at_min=[float(g) for g in best["gaps"]],
                    common_angle_at_min=float(circ_mean_mp(best["gaps"])),
                    spread_within_tol=bool(b_spread_ok),
                ),
                test_C=merged,
                test_C_representatives_agree=bool(both_agree),
                test_D=dict(
                    n_draws_primary=int(len(null4)),
                    p_primary=p_primary,
                    p_within_alpha=bool(p_primary <= args.alpha),
                    null_mean=float(null4.mean()) if len(null4) else None,
                    null_sd=float(null4.std()) if len(null4) else None,
                    null_q01=float(np.quantile(null4, 0.01)) if len(null4) else None,
                    null_q05=float(np.quantile(null4, 0.05)) if len(null4) else None,
                    null_median=float(np.median(null4)) if len(null4) else None,
                    n_draws_merged=int(len(null3)),
                    p_merged=p_merged,
                    n_draws_secondary=int(len(null_s)),
                    p_secondary=p_secondary,
                ),
                test_E=dict(
                    r_gaps=dr, d_gaps=dd,
                    ln_r_gap_slope=slope_r, ln_r_gap_intercept=icpt_r,
                    r_gap_growth_per_turn=math.exp(slope_r),
                    d_gap_slope=slope_d, d_gap_intercept=icpt_d,
                    predicted_delta_r_turn4=dr4, predicted_delta_d_turn4=dd4,
                    predicted_fifth_zero=[r5, d5],
                    predicted_fifth_zero_nearest_cell=[int(round(r5)), int(round(d5))],
                    inside_o16_search_box=bool(inside_box),
                    inside_table_support=bool(in_support),
                    search_box="r <= 62, d <= 61 (results/O16_run2.log)",
                ),
                mechanical_decision_rule_output=mech,
                compromised_conditions=compromised,
            ),
            rows=[dict(index=r["index"],
                       gamma=mp.nstr(gammas[r["index"]], 25),
                       phi_r=float(phr[r["index"]]),
                       phi_d=float(phd[r["index"]]),
                       gaps=[float(g) for g in r["gaps"]],
                       spread=float(r["spread"])) for r in rows],
        )
        try:
            os.makedirs(os.path.dirname(out_path), exist_ok=True)
            with open(out_path, "w") as fh:
                json.dump(payload, fh, indent=2)
            print()
            print("results written to", out_path)
        except Exception as exc:                      # a write failure must not
            print()                                   # kill the run (CONTEXT.md)
            print("WARNING: results write failed:", exc, file=sys.stderr)


if __name__ == "__main__":
    main()
