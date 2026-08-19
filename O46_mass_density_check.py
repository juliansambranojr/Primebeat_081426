#!/usr/bin/env python3
"""
O46 - mass-density check: does stencil mass alone account for O45's
      cross-base zero-density trend?

STATUS: EXPLORATORY.  NOT PREREGISTERED.  NOTHING HERE IS A VERDICT.

  This script does not test a preregistered hypothesis, does not compute a
  p-value, and does not select a verdict label.  It is a read-and-compute
  pass over data already produced by O45 under
  preregs/sub_integer_base_scan_v1_20260818.md, and its outputs are
  labelled `status: exploratory` in the results JSON accordingly.
  CLAUDE.md, section "Prereg discipline": "Numbers produced outside that
  discipline are exploratory and must be labelled as such."

Reads with: preregs/sub_integer_base_scan_v1_20260818.md
                (mass_bound, mass_floor, resolved_criterion, and the
                 definition of S(r,d))
            O45_sub_integer_base_scan.py
                (imported read-only for its geometry, table and mass
                 routines, so the stratum here is O45's own and not a
                 re-derivation; O45's main() is NOT run)
            results/sub_integer_base_scan.json
                (read only, for the locked/observed per-base counts this
                 run is checked against)

=============================================================================
THE MECHANISM BEING CHECKED
=============================================================================

The prereg's `mass_bound` is exact: |cell(r,d)| <= S(r,d), with
S(r,d) = sum_k C(d,k) N(r-k) the unsigned prime stencil mass.  A cell is
therefore a signed integer confined to [-S, S], i.e. 2S+1 admissible
values.

IF cell values sat roughly spread over that range, the chance of landing
exactly on 0 would go like 1/S.  That is a parameter-free prediction with
no free constant:

    zero density x mean(S)   should be constant across bases
    zero density             should equal mean(1/S)      [the sharper form]

If it holds, O45's observed trend - zero density rising with b, base 2 the
maximum - is explained by stencil mass alone and sampling resolution never
enters.  If it does not hold, mass does not explain it.

The premise is checkable too, and is checked here: the distribution of
|cell|/S over the resolved stratum.  The mechanism assumes cells spread
across the available range.  If |cell|/S piles up near 0 or near 1, the
uniform-spread premise fails and the 1/S prediction has no basis whatever
the product does.

=============================================================================
STRATUM, AND WHY IT IS O45'S AND NOT A NEW ONE
=============================================================================

The stratum is the prereg's `resolved_criterion`, taken from O45's own
code path rather than reimplemented:

    d >= 1,  1 <= d <= r-1,  2 <= r <= r_max(b),  and  r - d >= r_thick(b)

with r_thick from O45's r_thick_of().  n_resolved is reported against the
prereg's locked `resolved_cells` table and any disagreement is printed as
a finding.

=============================================================================
ARITHMETIC
=============================================================================

Exact Python int for every N, W, cell and S.  Exact fractions.Fraction for
every ratio entering a comparison (the |cell|/S order statistics) and for
density and mean(S), both of which are exact rationals.  mpmath at dps 80
carries sum(1/S), where an exact rational would need a common denominator
of astronomical size for no gain, and formats the large means for output.
No float64 quantity is ever compared or ranked: S at depth ~198 involves
binomials far past anything float64 holds, and an inf there would be a bug,
not a data property.

S is built by the Pascal recurrence S(r,d) = S(r,d-1) + S(r-1,d-1), which
is identically sum_k C(d,k) N(r-k), and is cross-checked against O45's own
stencil_mass() at a sample of cells per base (--verify-mass).

Every path is anchored to _HERE, so runs are cwd-independent.
"""

import argparse
import datetime
import hashlib
import importlib.util
import json
import math
import os
import sys
from fractions import Fraction

from mpmath import mp, mpf

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_O45 = os.path.join(_HERE, "O45_sub_integer_base_scan.py")
DEFAULT_O45_JSON = os.path.join(_HERE, "results", "sub_integer_base_scan.json")
DEFAULT_OUT = os.path.join(_HERE, "results", "mass_density_check.json")

RULE = "=" * 78
THIN = "-" * 78

DPS = 80                # mpmath precision for sum(1/S) and for formatting
STATUS = "exploratory"


def _resolve(path):
    return path if os.path.isabs(path) else os.path.join(_HERE, path)


def _code_version(path):
    try:
        with open(path, "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:                                  # pragma: no cover
        return f"unavailable: {exc}"


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


def _jsonable(o):
    if isinstance(o, dict):
        return {str(k): _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str) or isinstance(o, bool):
        return o
    if isinstance(o, int):
        return int(o)
    if isinstance(o, float):
        return o if math.isfinite(o) else None
    try:
        f = float(o)
    except (TypeError, ValueError, OverflowError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
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


def load_o45(path):
    """Import O45 read-only for its geometry / table / mass routines.  Its
    main() is guarded by __name__ == '__main__' and is NOT run.  Loaded via
    importlib for the same reason 07_alpha_depth_trend.py loads 05 that way
    (CLAUDE.md, section 'Naming convention')."""
    spec = importlib.util.spec_from_file_location("o45_sub_integer_base_scan",
                                                  path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def build_mass_table(N, r_max):
    """S(r,d) = sum_k C(d,k) N(r-k) by the Pascal recurrence

        S(r,0) = N(r),   S(r,d) = S(r,d-1) + S(r-1,d-1)

    which is the same recurrence as the difference table with the sign
    dropped, i.e. exactly the unsigned stencil mass.  Exact ints; dict keyed
    (r,d), support d = 0..r-1."""
    S = {}
    for r in range(1, r_max + 1):
        S[(r, 0)] = N[r]
    for d in range(1, r_max):
        for r in range(d + 1, r_max + 1):
            S[(r, d)] = S[(r, d - 1)] + S[(r - 1, d - 1)]
    return S


def _fmt(x, n=6):
    """Format an mpf/Fraction/int at n significant digits without ever
    routing a huge value through float()."""
    if x is None:
        return "None"
    return mp.nstr(mpf(x) if not isinstance(x, Fraction)
                   else mpf(x.numerator) / mpf(x.denominator), n)


def _quantile(sorted_vals, q):
    """Order statistic at fraction q of an ascending list, midpoint
    interpolation at even counts for q = 1/2.  Exact Fractions in, exact
    Fraction out."""
    n = len(sorted_vals)
    if n == 0:
        return None
    if q == Fraction(1, 2):
        if n % 2 == 1:
            return sorted_vals[n // 2]
        return (sorted_vals[n // 2 - 1] + sorted_vals[n // 2]) / 2
    idx = int(q * (n - 1))
    return sorted_vals[idx]


def scan_base(o45, arm, label, kind, locked, gamma1, pi_fn, pi_cache,
              verify_mass):
    """One base: the resolved stratum, its zero density, and its mass
    profile.  No threshold is applied and no decision is taken."""
    locked_r_max, locked_cells, locked_r_thick, locked_resolved = locked

    b, r_max, F, min_gap, root_bad = o45.base_geometry(kind, gamma1)
    W = o45.rung_populations(F, r_max)
    r_thick = o45.r_thick_of(W, b, r_max)

    def PI(x):
        if x < 2:
            return 0
        if x not in pi_cache:
            pi_cache[x] = pi_fn(x)
        return pi_cache[x]

    N = [0] + [PI(F[r]) - PI(F[r - 1]) for r in range(1, r_max + 1)]
    P, _Q = o45.build_tables(N, W, r_max)
    S = build_mass_table(N, r_max)

    # cross-check the recurrence against O45's own stencil_mass()
    mass_checked = 0
    mass_mismatch = 0
    if verify_mass > 0:
        step = max(1, (r_max * r_max // 2) // verify_mass)
        c = 0
        for r in range(2, r_max + 1):
            for d in range(1, r):
                c += 1
                if c % step:
                    continue
                mass_checked += 1
                if S[(r, d)] != o45.stencil_mass(N, r, d):
                    mass_mismatch += 1

    n_cells = 0
    n_res = 0
    n_zero_all = 0
    n_zero_res = 0
    sum_S = 0                  # exact int, over resolved cells
    sum_inv_S = mpf(0)         # mpf at dps DPS, over resolved cells with S>0
    n_S_zero = 0               # resolved cells with S = 0 (zero forced)
    n_bound_violations = 0     # |cell| > S anywhere resolved: would be a bug
    ratios = []                # Fraction |cell|/S over resolved cells, S>0
    S_vals = []                # S over all resolved cells
    S_at_zeros = []            # S at the resolved exact zeros
    S_min = None
    S_max = None

    for r in range(2, r_max + 1):
        for d in range(o45.D_MIN, r):
            n_cells += 1
            cell = P[(r, d)]
            if cell == 0:
                n_zero_all += 1
            if (r - d) < r_thick:
                continue
            n_res += 1
            s = S[(r, d)]
            S_vals.append(s)
            if cell == 0:
                n_zero_res += 1
                S_at_zeros.append(s)
            sum_S += s
            if S_min is None or s < S_min:
                S_min = s
            if S_max is None or s > S_max:
                S_max = s
            if s == 0:
                n_S_zero += 1
                continue
            if abs(cell) > s:
                n_bound_violations += 1
            sum_inv_S += mpf(1) / mpf(s)
            ratios.append(Fraction(abs(cell), s))

    S_vals.sort()
    S_at_zeros.sort()

    def _med_int(v):
        if not v:
            return None
        n = len(v)
        return v[n // 2] if n % 2 else Fraction(v[n // 2 - 1] + v[n // 2], 2)

    S_med = _med_int(S_vals)
    S_med_zeros = _med_int(S_at_zeros)

    ratios.sort()
    med = _quantile(ratios, Fraction(1, 2))
    q10 = _quantile(ratios, Fraction(1, 10))
    q25 = _quantile(ratios, Fraction(1, 4))
    q75 = _quantile(ratios, Fraction(3, 4))
    q90 = _quantile(ratios, Fraction(9, 10))

    density = Fraction(n_zero_res, n_res) if n_res else None
    mean_S = Fraction(sum_S, n_res) if n_res else None
    n_inv = len(ratios)
    mean_inv_S = (sum_inv_S / n_inv) if n_inv else None
    harm_S = (mpf(1) / mean_inv_S) if (mean_inv_S and mean_inv_S > 0) else None
    product = (density * mean_S) if (density is not None and mean_S is not None) else None
    ratio_sharp = None
    if density is not None and mean_inv_S is not None and mean_inv_S > 0:
        ratio_sharp = (mpf(density.numerator) / mpf(density.denominator)) / mean_inv_S

    return {
        "arm": arm,
        "label": label,
        "b": float(b),
        "b_str": mp.nstr(b, 22),
        "r_max": r_max,
        "r_thick": r_thick,
        "locked_r_max": locked_r_max,
        "locked_r_thick": locked_r_thick,
        "locked_cells_at_d_ge_1": locked_cells,
        "locked_resolved_cells": locked_resolved,
        "n_cells_at_d_ge_1": n_cells,
        "n_resolved": n_res,
        "resolved_matches_locked": (n_res == locked_resolved),
        "geometry_matches_locked": (r_max == locked_r_max
                                    and r_thick == locked_r_thick
                                    and n_cells == locked_cells
                                    and n_res == locked_resolved),
        "n_zeros_all": n_zero_all,
        "n_zeros_resolved": n_zero_res,
        "density": float(density) if density is not None else None,
        "density_str": _fmt(density, 8),
        "mean_S": float(mean_S) if mean_S is not None else None,
        "mean_S_str": _fmt(mean_S, 8),
        "harmonic_mean_S": float(harm_S) if harm_S is not None else None,
        "harmonic_mean_S_str": _fmt(harm_S, 8),
        "mean_inv_S": float(mean_inv_S) if mean_inv_S is not None else None,
        "mean_inv_S_str": _fmt(mean_inv_S, 8),
        "density_times_mean_S": float(product) if product is not None else None,
        "density_times_mean_S_str": _fmt(product, 8),
        "density_over_mean_inv_S": (float(ratio_sharp)
                                    if ratio_sharp is not None else None),
        "density_over_mean_inv_S_str": _fmt(ratio_sharp, 8),
        "S_min_resolved": S_min,
        "S_median_resolved_str": _fmt(S_med, 8),
        "S_median_at_resolved_zeros_str": _fmt(S_med_zeros, 8),
        "S_max_at_resolved_zeros_str": _fmt(S_at_zeros[-1] if S_at_zeros else None, 8),
        "S_max_resolved_digits": (len(str(S_max)) if S_max is not None else None),
        "S_max_resolved_str": _fmt(S_max, 8),
        "n_resolved_S_zero": n_S_zero,
        "n_mass_bound_violations": n_bound_violations,
        "n_ratio_sample": n_inv,
        "mass_recurrence_cells_checked": mass_checked,
        "mass_recurrence_mismatches": mass_mismatch,
        "abs_cell_over_S_median": float(med) if med is not None else None,
        "abs_cell_over_S_q10": float(q10) if q10 is not None else None,
        "abs_cell_over_S_q25": float(q25) if q25 is not None else None,
        "abs_cell_over_S_q75": float(q75) if q75 is not None else None,
        "abs_cell_over_S_q90": float(q90) if q90 is not None else None,
        "abs_cell_over_S_max": float(ratios[-1]) if ratios else None,
    }


def main():
    ap = argparse.ArgumentParser(
        description="O46 - mass-density check (EXPLORATORY; not a verdict)")
    ap.add_argument("--o45", type=str, default=DEFAULT_O45,
                    help="path to O45_sub_integer_base_scan.py, imported "
                         "read-only for its geometry and table routines")
    ap.add_argument("--o45-json", type=str, default=DEFAULT_O45_JSON,
                    help="path to results/sub_integer_base_scan.json, read "
                         "only, for the counts this run is checked against")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT,
                    help="results JSON path")
    ap.add_argument("--verify-mass", type=int, default=200,
                    help="cells per base at which the Pascal-recurrence S is "
                         "cross-checked against O45's stencil_mass(); 0 to "
                         "skip")
    ap.add_argument("--overwrite", action="store_true", default=False,
                    help="permit overwriting an existing --out; off by "
                         "default, so an existing artifact is never clobbered")
    ap.add_argument("--no-json", action="store_true", default=False,
                    help="print the report and write no JSON")
    args = ap.parse_args()

    o45_path = _resolve(args.o45)
    o45_json = _resolve(args.o45_json)
    out_path = _resolve(args.out)

    if (not args.no_json) and os.path.exists(out_path) and not args.overwrite:
        print(f"REFUSING to overwrite existing {out_path}; pass --overwrite "
              f"only if that is intended.", flush=True)
        return 2

    mp.dps = DPS
    started = datetime.datetime.now(datetime.timezone.utc)

    o45 = load_o45(o45_path)
    gamma1 = mpf(o45.GAMMA1_STR)
    pi_fn, pi_name, pi_ver = o45.load_pi_backend()
    pi_cache = {}

    print(RULE)
    print("O46 - MASS-DENSITY CHECK   (EXPLORATORY - NOT A VERDICT)")
    print(RULE)
    print(f"  started (UTC)          : "
          f"{started.strftime('%Y-%m-%dT%H:%M:%SZ')}")
    print(f"  status                 : {STATUS}")
    print(f"  reads O45 script       : {o45_path}")
    print(f"  reads O45 results      : {o45_json}")
    print(f"  prereg (context only)  : preregs/sub_integer_base_scan_v1_"
          f"20260818.md")
    print(f"  stratum                : O45's resolved_criterion, "
          f"r - d >= r_thick(b), d >= {o45.D_MIN}")
    print(f"  pi backend             : {pi_name} {pi_ver}")
    print(f"  mpmath dps             : {DPS}  (sum of 1/S only)")
    print(f"  sampling               : NONE - every resolved cell is used")
    print(f"  python                 : {sys.version.split()[0]}")
    print(f"  code_version (sha256)  : {_code_version(os.path.abspath(__file__))}")
    print()
    print("  This script is EXPLORATORY.  It tests no preregistered")
    print("  hypothesis, computes no p-value, and stamps nothing.  Nothing")
    print("  printed here is a verdict.")
    print(flush=True)

    print(THIN)
    print("THE PREDICTION BEING CHECKED")
    print(THIN)
    print("  mass_bound (prereg, locked, exact):  |cell(r,d)| <= S(r,d),")
    print("  S(r,d) = sum_k C(d,k) N(r-k).  A cell is a signed integer in")
    print("  [-S, S].  If cell values were spread over that range, the")
    print("  chance of landing exactly on 0 would go like 1/S, giving a")
    print("  parameter-free prediction with no free constant:")
    print()
    print("      density x mean(S)   constant across bases")
    print("      density  =  mean(1/S)                 [the sharper form]")
    print()
    print("  The premise is checked too, at the |cell|/S distribution.")
    print(flush=True)

    with open(o45_json) as fh:
        o45_res = json.load(fh)
    o45_by_label = {p["label"]: p for p in o45_res["summary"]["per_base"]}

    per_base = []
    for (arm, label, kind, l_rmax, l_cells, l_rthick, l_res) in o45.LOCKED_BASES:
        print(f"  scanning {label} ...", flush=True)
        rec = scan_base(o45, arm, label, kind,
                        (l_rmax, l_cells, l_rthick, l_res),
                        gamma1, pi_fn, pi_cache, args.verify_mass)
        ref = o45_by_label.get(label)
        rec["o45_n_resolved_cells"] = ref["n_resolved_cells"] if ref else None
        rec["o45_n_exact_zeros_resolved"] = (ref["n_exact_zeros_resolved"]
                                             if ref else None)
        rec["matches_o45_run"] = bool(
            ref
            and rec["n_resolved"] == ref["n_resolved_cells"]
            and rec["n_zeros_resolved"] == ref["n_exact_zeros_resolved"]
            and rec["n_cells_at_d_ge_1"] == ref["n_cells_at_d_ge_1"])
        per_base.append(rec)

    print()
    print(THIN)
    print("1.  PER-BASE TABLE  (resolved stratum, d >= 1)")
    print(THIN)
    hdr = (f"  {'arm':<11}{'b':>10}  {'n_res':>6} {'n_zero':>6} "
           f"{'density':>11} {'mean(S)':>12} {'mean(1/S)':>11} "
           f"{'dens*meanS':>12} {'dens/mean(1/S)':>14}")
    print(hdr)
    for rec in per_base:
        print(f"  {rec['arm']:<11}{rec['b']:>10.6f}  "
              f"{rec['n_resolved']:>6} {rec['n_zeros_resolved']:>6} "
              f"{rec['density_str']:>11} {rec['mean_S_str']:>12} "
              f"{rec['mean_inv_S_str']:>11} "
              f"{rec['density_times_mean_S_str']:>12} "
              f"{rec['density_over_mean_inv_S_str']:>14}")
    print()
    print("  harmonic mean of S = 1/mean(1/S), per base:")
    for rec in per_base:
        print(f"    {rec['label']:<20} b = {rec['b']:.6f}   "
              f"harm(S) = {rec['harmonic_mean_S_str']:>12}   "
              f"1/harm(S) = {rec['mean_inv_S_str']}")
    print()
    print("  where the mass sits, and where the zeros sit:")
    print(f"    {'label':<20}{'median S (all res)':>20}"
          f"{'median S at zeros':>20}{'max S at zeros':>18}")
    for rec in per_base:
        print(f"    {rec['label']:<20}{rec['S_median_resolved_str']:>20}"
              f"{rec['S_median_at_resolved_zeros_str']:>20}"
              f"{rec['S_max_at_resolved_zeros_str']:>18}")
    print(flush=True)

    def spread(key):
        vals = [r[key] for r in per_base if r[key] not in (None, 0.0)]
        if not vals:
            return None, None, None
        return min(vals), max(vals), (max(vals) / min(vals) if min(vals) else None)

    p_lo, p_hi, p_fac = spread("density_times_mean_S")
    r_lo, r_hi, r_fac = spread("density_over_mean_inv_S")

    print(THIN)
    print("2.  IS EITHER QUANTITY CONSTANT ACROSS THE ELEVEN BASES?")
    print(THIN)
    print(f"  density x mean(S)      min {p_lo:.6g}   max {p_hi:.6g}   "
          f"spread factor {p_fac:.6g}")
    print(f"  density / mean(1/S)    min {r_lo:.6g}   max {r_hi:.6g}   "
          f"spread factor {r_fac:.6g}")
    print()
    print("  A spread factor of 1 would be exactly constant.  The number is")
    print("  reported as it comes out; no band is asserted around it here.")
    print(flush=True)

    print(THIN)
    print("3.  DOES THE UNIFORM-SPREAD PREMISE HOLD?  |cell| / S OVER THE")
    print("    RESOLVED STRATUM  (0 = exact zero, 1 = the mass bound met)")
    print(THIN)
    print(f"  {'label':<20}{'b':>10}  {'q10':>9} {'q25':>9} {'median':>9} "
          f"{'q75':>9} {'q90':>9} {'max':>9}")
    for rec in per_base:
        f = lambda k: ("None" if rec[k] is None else f"{rec[k]:.6f}")
        print(f"  {rec['label']:<20}{rec['b']:>10.6f}  "
              f"{f('abs_cell_over_S_q10'):>9} {f('abs_cell_over_S_q25'):>9} "
              f"{f('abs_cell_over_S_median'):>9} {f('abs_cell_over_S_q75'):>9} "
              f"{f('abs_cell_over_S_q90'):>9} {f('abs_cell_over_S_max'):>9}")
    print(flush=True)

    print(THIN)
    print("4.  INTEGRITY")
    print(THIN)
    dis_locked = [r["label"] for r in per_base if not r["geometry_matches_locked"]]
    dis_o45 = [r["label"] for r in per_base if not r["matches_o45_run"]]
    viol = sum(r["n_mass_bound_violations"] for r in per_base)
    szero = sum(r["n_resolved_S_zero"] for r in per_base)
    print(f"  bases disagreeing with the prereg's locked table : "
          f"{dis_locked if dis_locked else 'none'}")
    print(f"  bases disagreeing with O45's run of record       : "
          f"{dis_o45 if dis_o45 else 'none'}")
    print(f"  mass-bound violations (|cell| > S), all bases    : {viol}")
    print(f"  resolved cells with S = 0 (zero forced)          : {szero}")
    mc = sum(r["mass_recurrence_cells_checked"] for r in per_base)
    mm = sum(r["mass_recurrence_mismatches"] for r in per_base)
    print(f"  S recurrence vs O45 stencil_mass(): {mc} cells checked, "
          f"{mm} mismatches")
    print(flush=True)

    ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.basename(__file__),
        "script_path": os.path.abspath(__file__),
        "generated_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": STATUS,
        "status_note": (
            "EXPLORATORY. Not preregistered. No hypothesis is tested, no "
            "p-value is computed, and no verdict label is selected or "
            "implied. This is a read-and-compute pass over data already "
            "produced by O45 under preregs/sub_integer_base_scan_v1_"
            "20260818.md. CLAUDE.md, section 'Prereg discipline'."),
        "params": {
            "code_version": _code_version(os.path.abspath(__file__)),
            "argv": [os.path.basename(sys.argv[0])] + sys.argv[1:],
            "run_start_utc": started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_utc": ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "o45_script": o45_path,
            "o45_results": o45_json,
            "out": out_path,
            "verify_mass_cells_per_base": args.verify_mass,
            "sampling": "none - every resolved cell used",
            "dps": DPS,
            "d_min": o45.D_MIN,
            "pi_backend": pi_name,
            "pi_backend_version": pi_ver,
            "python": sys.version,
            "source_files": [
                file_record(o45_path, {"role": "analyzer_imported"}),
                file_record(o45_json, {"role": "o45_run_of_record"}),
                file_record(os.path.join(_HERE, "preregs",
                                         "sub_integer_base_scan_v1_20260818.md"),
                            {"role": "prereg_context_only"}),
            ],
        },
        "constants": {
            "gamma_1": o45.GAMMA1_STR,
            "value_ceiling": o45.VALUE_CEILING,
            "mass_bound": "|cell(r,d)| <= S(r,d), S(r,d) = sum_k C(d,k) N(r-k)",
            "resolved_criterion": ("W(r')/ln(b^r') >= 1 for all r' in "
                                   "[r-d, r], equivalently r - d >= "
                                   "r_thick(b)"),
            "prediction_checked": ("density x mean(S) constant across bases; "
                                   "sharper form density = mean(1/S)"),
            "convention": o45.CONVENTION,
        },
        "summary": {
            "n_bases": len(per_base),
            "density_times_mean_S_min": p_lo,
            "density_times_mean_S_max": p_hi,
            "density_times_mean_S_spread_factor": p_fac,
            "density_over_mean_inv_S_min": r_lo,
            "density_over_mean_inv_S_max": r_hi,
            "density_over_mean_inv_S_spread_factor": r_fac,
            "bases_disagreeing_with_locked_table": dis_locked,
            "bases_disagreeing_with_o45_run": dis_o45,
            "total_mass_bound_violations": viol,
            "total_resolved_cells_with_S_zero": szero,
            "mass_recurrence_cells_checked": mc,
            "mass_recurrence_mismatches": mm,
            "verdict": None,
            "verdict_note": ("No verdict. This test is exploratory and no "
                             "decision rule was locked before it."),
        },
        "rows": per_base,
    }
    if not args.no_json:
        _write_results(payload, out_path)

    print(f"  finished (UTC): {ended.strftime('%Y-%m-%dT%H:%M:%SZ')}",
          flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
