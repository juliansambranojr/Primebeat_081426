#!/usr/bin/env python3
"""
O13 — The null distribution of O9's smoothness statistic, and what its
      threshold is actually worth.

Reads with: O9_convergence_abscissa.py part 3; this bench's
`results/O9_convergence_abscissa_results_fine.json`; dyadic-table-v2.md §6.4.

NAMING
------
The O-series in this tree runs O1-O9 and O11.  There is NO O10: that number is
a known, deliberate gap and this script does not fill it, because filling a
reserved gap with unrelated work would silently rewrite the series' history.
The next free numbers after O11 are O12 and O13; the fit-free block-ratio
script takes O12 and this file takes O13.  Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

ENVELOPE ADDITION (new on O12/O13 only)
---------------------------------------
The house JSON envelope is unchanged in shape (schema_version, script,
generated_utc, params, constants, summary, rows) and `schema_version` stays
"1".  ONE key is added inside `params`: `code_version`, the sha256 of THIS
script file, computed at runtime by reading `__file__`.  That makes each
result self-identifying about which code produced it.  No existing script's
envelope is touched.

WHY
---
O9 part 3 asks whether sigma = 1/2 is distinguished.  Its test: fit a cubic to
the mean decay-exponent curve OUTSIDE a +-0.02 window around 0.5, measure the
largest departure of the points inside that window from the extrapolation, and
divide by the residual sd outside.  Call that max_z.  O9 declares
"STRUCTURE at 1/2" if max_z > 3 and "smooth through 1/2" otherwise, and
reported max_z = 2.55 at the fine step.

That number is only interpretable against a null.  A statistic of this shape —
cubic extrapolated over a small gap, compared to in-gap points — has a
distribution driven by the geometry of the fit, not by anything special about
0.5.  O13 measures that distribution directly: it slides O9's ENTIRE geometry
across 91 centres from 0.30 to 1.20 and records max_z at every one.  0.500 is
then just one draw from that set, and the question "is 2.55 large?" becomes
answerable rather than asserted.

The threshold sweep asks the follow-on question: what would O9's verdict have
been at other thresholds, and how many OTHER centres would have to be called
"structure" to call 0.500 structure?

WHAT IS REPRODUCED EXACTLY
--------------------------
At each centre c the geometry is O9's, unchanged:

    band     = np.round(np.arange(c - 0.08, c + 0.08 + 0.0001, 0.005), 4)
               -> 33 sigma points
    win      = 0.02 ;  win_tol = 1e-9
    out_mask = np.abs(fs - c) > win + win_tol ;  in_mask = ~out_mask
    co       = np.polyfit(fs[out_mask], fm[out_mask], 3)
    pred     = np.polyval(co, ...)
    resid_dof = n_outside - 4
    resid_sd  = sqrt(sum(resid**2) / resid_dof)
    departure = max |fm[in_mask] - pred_in|
    max_z     = departure / resid_sd

At c = 0.5 the band is exactly [0.42, 0.58] step 0.005 — O9's fine sweep —
so the centre-0.500 draw IS O9's published statistic, not an approximation.

The curve fm is the MEAN across t of O9's `decay_exponent` slope with
xvar = "count" (x = log N, the prime-count ladder index), computed on O9's
ladder [125, 250, 500, 1000, 2000, 4000] with O9's own guards (rungs with
2N > n_primes dropped, zero increments dropped, fewer than 4 usable rungs
-> nan).  The four per-t curves are computed and swept as well.

VALIDATION GATES (both RUN on every invocation)
-----------------------------------------------
  (a) the recomputed mean-slope curve must match
      summary.fine_sweep[*].mean_slope in
      results/O9_convergence_abscissa_results_fine.json (33 points)
  (b) the recomputed departure_over_sd at centre 0.500 must match
      summary.smoothness_control.departure_over_sd in that same file
      (2.552110329098862 as stored)

The expected values are READ FROM THAT FILE, not hardcoded here.  Failure
prints loudly and sets `gates_passed: false`, but the JSON is still written.

REQUIREMENTS
------------
    pip install numpy

Runtime: about a minute at the defaults.

USAGE
-----
    python3 O13_smoothness_null.py
    python3 O13_smoothness_null.py --out /tmp/o13.json
"""

import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

try:
    import numpy as np
except ImportError:
    raise ImportError("numpy is required. Install with: pip install numpy")

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
DEFAULT_GATE_FILE = os.path.join(
    _HERE, "results", "O9_convergence_abscissa_results_fine.json")


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """Coerce numpy scalars to JSON-safe Python types; non-finite -> None."""
    if isinstance(o, dict):
        return {k: _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str):
        return o
    if isinstance(o, (bool, np.bool_)):
        return bool(o)
    if isinstance(o, (int, np.integer)):
        return int(o)
    if isinstance(o, (float, np.floating)):
        f = float(o)
        return f if math.isfinite(f) else None
    try:
        f = float(o)
    except (TypeError, ValueError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a long run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)


def _safe_div(a, b):
    """Guarded division: returns nan rather than raising or returning inf."""
    try:
        if b is None or not math.isfinite(float(b)) or float(b) == 0.0:
            return float("nan")
        return float(a) / float(b)
    except (TypeError, ValueError, ZeroDivisionError):
        return float("nan")


def sieve_primes(limit):
    """Exact primes by sieve of Eratosthenes. Mirrors O9."""
    s = np.ones(limit + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(limit ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.flatnonzero(s).astype(np.float64)


def prime_sum(primes, n_terms, sigma, t):
    """Truncated prime sum sum_{p <= p_n} p^(-sigma - i t). Mirrors O9."""
    p = primes[:n_terms]
    lg = np.log(p)
    w = p ** (-sigma)
    return complex(np.sum(w * np.cos(t * lg)), -np.sum(w * np.sin(t * lg)))


def decay_exponent(primes, sigma, t, ladder, xvar="count"):
    """
    Regress log|S_2N - S_N| on log N (xvar='count') or log p_N (xvar='prime')
    across a ladder of N.  Byte-for-byte the same procedure as O9's
    decay_exponent, including its guards.  Returns (slope, r2, n_used).
    """
    xs, ys = [], []
    for N in ladder:
        if 2 * N > len(primes):
            continue
        a = prime_sum(primes, N, sigma, t)
        b = prime_sum(primes, 2 * N, sigma, t)
        d = abs(b - a)
        if d > 0:
            if xvar == "prime":
                xs.append(math.log(float(primes[N - 1])))
            else:
                xs.append(math.log(N))
            ys.append(math.log(d))
    if len(xs) < 4:
        return float('nan'), float('nan'), len(xs)
    xs = np.array(xs)
    ys = np.array(ys)
    A = np.vstack([np.ones_like(xs), xs]).T
    coef, *_ = np.linalg.lstsq(A, ys, rcond=None)
    pred = A @ coef
    ss = np.sum((ys - ys.mean()) ** 2)
    r2 = 1 - np.sum((ys - pred) ** 2) / ss if ss > 0 else float('nan')
    return coef[1], r2, len(xs)


def smooth_stat(fs, fm, c, win, win_tol, poly_deg):
    """
    O9's part-3 smoothness statistic, evaluated at an arbitrary centre c.
    Returns a dict; max_z is nan when the geometry is degenerate.
    """
    out_mask = np.abs(fs - c) > win + win_tol
    in_mask = ~out_mask
    n_out = int(out_mask.sum())
    n_in = int(in_mask.sum())
    res = {"centre": float(c), "n_inside": n_in, "n_outside": n_out,
           "resid_dof": n_out - (poly_deg + 1),
           "residual_sd_outside": float("nan"),
           "max_departure_inside": float("nan"),
           "max_z": float("nan"), "usable": False}
    if n_out < poly_deg + 2 or n_in < 1 or res["resid_dof"] <= 0:
        return res
    if not np.all(np.isfinite(fm)):
        return res
    co = np.polyfit(fs[out_mask], fm[out_mask], poly_deg)
    resid = fm[out_mask] - np.polyval(co, fs[out_mask])
    sd = float(np.sqrt(np.sum(resid ** 2) / res["resid_dof"]))
    dep = float(np.max(np.abs(fm[in_mask] - np.polyval(co, fs[in_mask]))))
    res["residual_sd_outside"] = sd
    res["max_departure_inside"] = dep
    res["max_z"] = _safe_div(dep, sd)
    res["usable"] = bool(math.isfinite(res["max_z"]))
    return res


def describe(z, centres):
    """min/max/mean/median/sd of a max_z array, with the attaining centres."""
    if len(z) == 0:
        return {"n": 0}
    return {
        "n": int(len(z)),
        "mean": float(np.mean(z)),
        "sd": float(np.std(z, ddof=1)) if len(z) > 1 else float("nan"),
        "median": float(np.median(z)),
        "min": float(np.min(z)),
        "min_at_centre": float(centres[int(np.argmin(z))]),
        "max": float(np.max(z)),
        "max_at_centre": float(centres[int(np.argmax(z))]),
    }


def main():
    ap = argparse.ArgumentParser(
        description="O13 — null distribution of O9's smoothness statistic")
    ap.add_argument("--pmax", type=int, default=100000,
                    help="sieve limit for the prime list (O9 default 100000)")
    ap.add_argument("--tvals", type=str, default="14.5,30.0,50.0,80.0",
                    help="comma-separated t values (O9's part-3 defaults)")
    ap.add_argument("--ladder", type=str, default="125,250,500,1000,2000,4000",
                    help="O9's N ladder; rungs with 2N > n_primes are dropped")
    ap.add_argument("--xvar", type=str, default="count",
                    choices=["count", "prime"],
                    help="decay-exponent regression variable, as in O9")
    ap.add_argument("--master-lo", type=float, default=0.22,
                    help="low end of the master sigma grid")
    ap.add_argument("--master-hi", type=float, default=1.2801,
                    help="np.arange stop for the master sigma grid")
    ap.add_argument("--master-step", type=float, default=0.005,
                    help="master sigma grid step (O9's fine step)")
    ap.add_argument("--centre-lo", type=float, default=0.30,
                    help="first sliding centre")
    ap.add_argument("--centre-hi", type=float, default=1.2001,
                    help="np.arange stop for the sliding centres")
    ap.add_argument("--centre-step", type=float, default=0.01,
                    help="spacing between sliding centres")
    ap.add_argument("--band-halfwidth", type=float, default=0.08,
                    help="half width of the fitted band around each centre")
    ap.add_argument("--band-step", type=float, default=0.005,
                    help="sigma step within a band (O9's fine step)")
    ap.add_argument("--band-pad", type=float, default=0.0001,
                    help="np.arange stop padding for a band, as in O9")
    ap.add_argument("--win", type=float, default=0.02,
                    help="excluded-window half width (O9's smoothness_window)")
    ap.add_argument("--win-tol", type=float, default=1e-9,
                    help="window comparison tolerance, as in O9")
    ap.add_argument("--poly-deg", type=int, default=3,
                    help="polynomial degree fitted outside the window")
    ap.add_argument("--decimals", type=int, default=4,
                    help="rounding applied to sigma grids, as in O9")
    ap.add_argument("--focus-centre", type=float, default=0.500,
                    help="the centre whose rank and percentile are reported")
    ap.add_argument("--thresholds", type=str,
                    default="1.5,2.0,2.25,2.5,2.6,2.75,3.0,3.5,4.0",
                    help="comma-separated verdict thresholds T to sweep")
    ap.add_argument("--percentiles", type=str, default="90,95,99",
                    help="comma-separated percentiles of the null to report")
    ap.add_argument("--expect-n-inside", type=int, default=9,
                    help="required n_inside per centre; others are excluded")
    ap.add_argument("--expect-n-outside", type=int, default=24,
                    help="required n_outside per centre; others are excluded")
    ap.add_argument("--gate-file", type=str, default=DEFAULT_GATE_FILE,
                    help="O9 fine-sweep results JSON supplying the expected "
                         "gate values (read, never written)")
    ap.add_argument("--gate-rel-tol", type=float, default=1e-9,
                    help="relative tolerance for both validation gates")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path (default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    tvals = [float(x) for x in args.tvals.split(",")]
    ladder_raw = [int(x) for x in args.ladder.split(",")]
    thresholds = [float(x) for x in args.thresholds.split(",")]
    pctls = [float(x) for x in args.percentiles.split(",")]

    print("=" * 78, flush=True)
    print("O13 — null distribution of O9's part-3 smoothness statistic",
          flush=True)
    print("=" * 78, flush=True)
    print("  O9 asks: does the mean decay-exponent curve depart from a cubic",
          flush=True)
    print("  extrapolation across a +-0.02 gap at sigma = 0.5, by more than the",
          flush=True)
    print("  residual scatter outside?  O13 slides that ENTIRE geometry across",
          flush=True)
    print("  many centres so 0.500 can be read against its own null.",
          flush=True)

    print(f"\n  sieving primes to {args.pmax}...", flush=True)
    primes = sieve_primes(args.pmax)
    n_primes = int(len(primes))
    print(f"  {n_primes} primes, largest = {int(primes[-1])}", flush=True)
    ladder = [n for n in ladder_raw if 2 * n <= n_primes]
    print(f"  ladder: {ladder}   xvar: {args.xvar}", flush=True)
    print(f"  t values: {tvals}", flush=True)

    master = np.round(np.arange(args.master_lo, args.master_hi,
                                args.master_step), args.decimals)
    print(f"  master sigma grid: {len(master)} points, "
          f"{master[0]:.4f} .. {master[-1]:.4f} step {args.master_step}",
          flush=True)

    print("  computing decay exponents on the master grid...", flush=True)
    SL = np.empty((len(master), len(tvals)))
    for i, sg in enumerate(master):
        for j, t in enumerate(tvals):
            SL[i, j] = decay_exponent(primes, float(sg), t, ladder,
                                      args.xvar)[0]
    MEAN = np.nanmean(SL, axis=1)
    idx = {round(float(v), args.decimals): i for i, v in enumerate(master)}
    print(f"  done; {len(master)} x {len(tvals)} slopes", flush=True)

    curves = {"mean": MEAN}
    for j, t in enumerate(tvals):
        curves[f"t={t:g}"] = SL[:, j]
    curve_names = ["mean"] + [f"t={t:g}" for t in tvals]

    def band_of(c):
        return np.round(np.arange(c - args.band_halfwidth,
                                  c + args.band_halfwidth + args.band_pad,
                                  args.band_step), args.decimals)

    def values_on(vals, band):
        try:
            return np.array([vals[idx[round(float(s), args.decimals)]]
                             for s in band])
        except KeyError:
            return None

    # ---------------- validation gates ------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("VALIDATION GATES — against O9's stored fine-sweep result", flush=True)
    print("-" * 78, flush=True)
    print(f"  gate file: {args.gate_file}", flush=True)
    gate_a = {"name": "fine_sweep mean_slope reproduction", "passed": False}
    gate_b = {"name": "departure_over_sd at centre 0.500", "passed": False}
    saved = None
    try:
        with open(args.gate_file) as fh:
            saved = json.load(fh)
    except Exception as exc:
        print(f"  ERROR: could not read gate file: {exc}", flush=True)
        gate_a["error"] = str(exc)
        gate_b["error"] = str(exc)

    focus_band = band_of(args.focus_centre)
    focus_vals = values_on(MEAN, focus_band)

    if saved is not None:
        fine = saved.get("summary", {}).get("fine_sweep", [])
        saved_sigmas = [round(float(f["sigma"]), args.decimals) for f in fine]
        theirs = np.array([float(f["mean_slope"]) for f in fine])
        ours = values_on(MEAN, np.array(saved_sigmas))
        gate_a["n_points"] = len(fine)
        if ours is None or len(fine) == 0:
            print("  GATE (a) FAILED — saved fine-sweep sigmas are not on the "
                  "master grid", flush=True)
            gate_a["error"] = "saved sigmas not on master grid"
        else:
            denom = np.where(np.abs(theirs) > 0, np.abs(theirs), np.nan)
            relerr = np.abs(ours - theirs) / denom
            worst = int(np.nanargmax(relerr))
            gate_a.update({
                "max_rel_err": float(np.nanmax(relerr)),
                "worst_sigma": float(saved_sigmas[worst]),
                "ours_at_worst": float(ours[worst]),
                "theirs_at_worst": float(theirs[worst]),
                "tolerance": args.gate_rel_tol,
                "passed": bool(np.nanmax(relerr) <= args.gate_rel_tol),
            })
            print(f"  GATE (a) mean_slope over {len(fine)} fine-sweep points",
                  flush=True)
            print(f"           max relative error : "
                  f"{gate_a['max_rel_err']:.3e}  (tol {args.gate_rel_tol:.1e})",
                  flush=True)
            print(f"           worst at sigma={gate_a['worst_sigma']:.4f}: "
                  f"ours={gate_a['ours_at_worst']:.17g} "
                  f"saved={gate_a['theirs_at_worst']:.17g}", flush=True)
            print(f"           {'PASSED' if gate_a['passed'] else 'FAILED'}",
                  flush=True)

        sc = saved.get("summary", {}).get("smoothness_control", {})
        expected = sc.get("departure_over_sd", None)
        if focus_vals is None or expected is None:
            print("  GATE (b) FAILED — expected value or band unavailable",
                  flush=True)
            gate_b["error"] = "expected value or band unavailable"
        else:
            st = smooth_stat(focus_band, focus_vals, args.focus_centre,
                             args.win, args.win_tol, args.poly_deg)
            rel = _safe_div(abs(st["max_z"] - float(expected)),
                            abs(float(expected)))
            gate_b.update({
                "expected": float(expected),
                "expected_source": (f"{os.path.basename(args.gate_file)} "
                                    f"summary.smoothness_control."
                                    f"departure_over_sd"),
                "computed": st["max_z"],
                "abs_diff": abs(st["max_z"] - float(expected)),
                "rel_err": rel,
                "tolerance": args.gate_rel_tol,
                "n_inside": st["n_inside"], "n_outside": st["n_outside"],
                "residual_sd_outside": st["residual_sd_outside"],
                "max_departure_inside": st["max_departure_inside"],
                "passed": bool(math.isfinite(rel) and rel <= args.gate_rel_tol),
            })
            print(f"  GATE (b) departure_over_sd at centre "
                  f"{args.focus_centre:.3f}", flush=True)
            print(f"           computed : {st['max_z']:.17g}", flush=True)
            print(f"           expected : {float(expected):.17g}", flush=True)
            print(f"           abs diff : {gate_b['abs_diff']:.3e}   "
                  f"rel err : {rel:.3e}", flush=True)
            print(f"           n_inside={st['n_inside']} "
                  f"n_outside={st['n_outside']}", flush=True)
            print(f"           {'PASSED' if gate_b['passed'] else 'FAILED'}",
                  flush=True)

    gates_passed = bool(gate_a.get("passed") and gate_b.get("passed"))
    if not gates_passed:
        print("\n  " + "*" * 70, flush=True)
        print("  *** VALIDATION GATE FAILED *** the geometry below is not "
              "O9's.", flush=True)
        print("  " + "*" * 70, flush=True)

    # ---------------- the sliding sweep -----------------------------------
    print("\n" + "-" * 78, flush=True)
    print("SLIDING SWEEP — O9's geometry at every centre", flush=True)
    print("-" * 78, flush=True)
    centres = np.round(np.arange(args.centre_lo, args.centre_hi,
                                 args.centre_step), args.decimals)
    print(f"  {len(centres)} centres, {centres[0]:.4f} .. {centres[-1]:.4f} "
          f"step {args.centre_step}", flush=True)
    print(f"  band: +-{args.band_halfwidth} step {args.band_step} ; "
          f"window +-{args.win} ; poly degree {args.poly_deg}", flush=True)

    rows = []
    sweeps = {}
    geometry_issues = []
    band_sizes = set()
    for name in curve_names:
        vals = curves[name]
        recs = []
        for c in centres:
            band = band_of(float(c))
            band_sizes.add(len(band))
            fmv = values_on(vals, band)
            if fmv is None:
                st = {"centre": float(c), "n_inside": None, "n_outside": None,
                      "resid_dof": None, "residual_sd_outside": float("nan"),
                      "max_departure_inside": float("nan"),
                      "max_z": float("nan"), "usable": False}
                geometry_issues.append({
                    "curve": name, "centre": float(c),
                    "reason": "band leaves the master sigma grid"})
            else:
                st = smooth_stat(band, fmv, float(c), args.win, args.win_tol,
                                 args.poly_deg)
                if (st["n_inside"] != args.expect_n_inside
                        or st["n_outside"] != args.expect_n_outside):
                    geometry_issues.append({
                        "curve": name, "centre": float(c),
                        "reason": (f"n_inside={st['n_inside']} "
                                   f"n_outside={st['n_outside']} "
                                   f"(expected {args.expect_n_inside}/"
                                   f"{args.expect_n_outside})")})
                    st["usable"] = False
            st["curve"] = name
            st["n_band"] = int(len(band))
            recs.append(st)
            rows.append({
                "curve": name, "centre": float(c), "n_band": int(len(band)),
                "n_inside": st["n_inside"], "n_outside": st["n_outside"],
                "resid_dof": st["resid_dof"],
                "residual_sd_outside": st["residual_sd_outside"],
                "max_departure_inside": st["max_departure_inside"],
                "max_z": st["max_z"], "usable": bool(st["usable"]),
            })
        sweeps[name] = recs

    print(f"  band sizes seen: {sorted(band_sizes)}", flush=True)
    if geometry_issues:
        print(f"  GEOMETRY EXCLUSIONS: {len(geometry_issues)}", flush=True)
        for g in geometry_issues:
            print(f"    curve {g['curve']} centre {g['centre']:.4f}: "
                  f"{g['reason']}", flush=True)
    else:
        print(f"  every centre on every curve yielded n_inside="
              f"{args.expect_n_inside}, n_outside={args.expect_n_outside} — "
              f"no exclusions", flush=True)

    def usable_arrays(name):
        recs = sweeps[name]
        keep = [(r["centre"], r["max_z"]) for r in recs if r["usable"]]
        if not keep:
            return np.array([]), np.array([])
        return (np.array([k[0] for k in keep]),
                np.array([k[1] for k in keep]))

    # ---------------- the null distribution -------------------------------
    print("\n" + "-" * 78, flush=True)
    print("NULL DISTRIBUTION OF max_z", flush=True)
    print("-" * 78, flush=True)
    print(f"  {'curve':>10} {'n':>4} {'mean':>9} {'sd':>9} {'median':>9} "
          f"{'min':>9} {'at':>7} {'max':>9} {'at':>7}", flush=True)
    stats = {}
    for name in curve_names:
        cs, zs = usable_arrays(name)
        d = describe(zs, cs)
        stats[name] = d
        if d.get("n", 0) == 0:
            print(f"  {name:>10} {0:>4}   (no usable centres)", flush=True)
            continue
        print(f"  {name:>10} {d['n']:>4} {d['mean']:>9.4f} {d['sd']:>9.4f} "
              f"{d['median']:>9.4f} {d['min']:>9.4f} {d['min_at_centre']:>7.2f} "
              f"{d['max']:>9.4f} {d['max_at_centre']:>7.2f}", flush=True)

    # percentiles of the null, per curve
    print("\n  percentiles of the null (linear interpolation):", flush=True)
    hdr = f"  {'curve':>10}" + "".join(f"{('p'+f'{q:g}'):>10}" for q in pctls)
    print(hdr, flush=True)
    pct_table = {}
    for name in curve_names:
        _, zs = usable_arrays(name)
        if len(zs) == 0:
            pct_table[name] = {f"{q:g}": None for q in pctls}
            continue
        vals = {f"{q:g}": float(np.percentile(zs, q)) for q in pctls}
        pct_table[name] = vals
        print(f"  {name:>10}" + "".join(f"{vals[f'{q:g}']:>10.4f}" for q in pctls),
              flush=True)

    # ---------------- the focus centre ------------------------------------
    print("\n" + "-" * 78, flush=True)
    print(f"THE FOCUS CENTRE  sigma = {args.focus_centre:.3f}", flush=True)
    print("-" * 78, flush=True)
    focus = {}
    for name in curve_names:
        cs, zs = usable_arrays(name)
        hit = [r for r in sweeps[name]
               if abs(r["centre"] - args.focus_centre) < 1e-9]
        z0 = hit[0]["max_z"] if hit else float("nan")
        n_gt = int(np.sum(zs > z0)) if len(zs) else 0
        n_le = int(np.sum(zs <= z0)) if len(zs) else 0
        rank = n_gt + 1
        pct_le = _safe_div(100.0 * n_le, len(zs)) if len(zs) else float("nan")
        pct_lt = (_safe_div(100.0 * int(np.sum(zs < z0)), len(zs))
                  if len(zs) else float("nan"))
        focus[name] = {
            "max_z": z0, "rank_descending": rank, "n_centres": int(len(zs)),
            "n_centres_above": n_gt,
            "percentile_le": pct_le, "percentile_lt": pct_lt,
        }
        print(f"  {name:>10}  max_z = {z0:.17g}   rank {rank} of {len(zs)}   "
              f"percentile {pct_le:.2f}", flush=True)

    # ---------------- threshold sweep -------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("THRESHOLD SWEEP — how many centres fire at each T (max_z > T)",
          flush=True)
    print("-" * 78, flush=True)
    z0_mean = focus["mean"]["max_z"]
    print(f"  {'T':>6} {'fire':>6} {'of':>5} {'pct':>8}   "
          f"sigma={args.focus_centre:.3f} verdict", flush=True)
    thresh_rows = []
    cs_mean, zs_mean = usable_arrays("mean")
    for T in thresholds:
        n_fire = int(np.sum(zs_mean > T)) if len(zs_mean) else 0
        pct = _safe_div(100.0 * n_fire, len(zs_mean)) if len(zs_mean) else float("nan")
        called = ("STRUCTURE" if math.isfinite(z0_mean) and z0_mean > T
                  else "smooth")
        per_curve = {}
        for name in curve_names:
            _, zz = usable_arrays(name)
            c_fire = int(np.sum(zz > T)) if len(zz) else 0
            per_curve[name] = {
                "n_fire": c_fire, "n": int(len(zz)),
                "pct": _safe_div(100.0 * c_fire, len(zz)) if len(zz) else None,
            }
        thresh_rows.append({
            "T": T, "n_fire_mean_curve": n_fire,
            "n_centres": int(len(zs_mean)), "pct_mean_curve": pct,
            "focus_verdict": called, "per_curve": per_curve,
        })
        print(f"  {T:>6.2f} {n_fire:>6} {len(zs_mean):>5} {pct:>7.2f}%   "
              f"{called}", flush=True)

    print(f"\n  per-curve firing counts (count of {len(centres)} centres):",
          flush=True)
    hdr = f"  {'T':>6}" + "".join(f"{n:>16}" for n in curve_names)
    print(hdr, flush=True)
    for tr in thresh_rows:
        row = f"  {tr['T']:>6.2f}"
        for name in curve_names:
            pc = tr["per_curve"][name]
            p = pc["pct"]
            ptxt = "n/a" if p is None else f"{p:.1f}%"
            row += f"{(str(pc['n_fire']) + ' (' + ptxt + ')'):>16}"
        print(row, flush=True)

    # ---------------- the flip point --------------------------------------
    print("\n" + "-" * 78, flush=True)
    print(f"WHAT IT COSTS TO CALL sigma = {args.focus_centre:.3f} STRUCTURE",
          flush=True)
    print("-" * 78, flush=True)
    flip = {"focus_max_z": z0_mean}
    if math.isfinite(z0_mean) and len(zs_mean):
        also = [(float(c), float(z)) for c, z in zip(cs_mean, zs_mean)
                if z > z0_mean]
        flip.update({
            "flips_when_T_below": z0_mean,
            "n_other_centres_firing_at_flip": len(also),
            "other_centres_firing_at_flip": [
                {"centre": c, "max_z": z} for c, z in also],
            "n_centres_ge_focus": int(np.sum(zs_mean >= z0_mean)),
        })
        print(f"  the rule fires when max_z > T, so sigma="
              f"{args.focus_centre:.3f} flips to STRUCTURE only for",
              flush=True)
        print(f"    T < {z0_mean:.17g}", flush=True)
        print(f"  at that threshold {len(also)} OTHER centres also fire "
              f"(plus 0.500 itself):", flush=True)
        if also:
            print("    " + ", ".join(f"{c:.2f}({z:.4f})" for c, z in also),
                  flush=True)
        else:
            print("    (none)", flush=True)
    else:
        print("  focus centre has no usable max_z", flush=True)

    # ---------------- read the result -------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    sd_mean = stats.get("mean", {}).get("sd", float("nan"))
    mu_mean = stats.get("mean", {}).get("mean", float("nan"))
    p95 = pct_table.get("mean", {}).get("95", None)
    print(f"  The statistic's null over {len(centres)} centres has mean "
          f"{mu_mean:.4f} and sd {sd_mean:.4f}.", flush=True)
    if p95 is not None:
        print(f"  Its 95th percentile is {p95:.4f}.  O9's value at 0.500 is "
              f"{z0_mean:.4f},", flush=True)
        print(f"  which sits at rank {focus['mean']['rank_descending']} of "
              f"{focus['mean']['n_centres']}.", flush=True)
    print("  A threshold low enough to call 0.500 STRUCTURE also calls "
          f"{flip.get('n_other_centres_firing_at_flip', 'n/a')} other", flush=True)
    print("  centres STRUCTURE, none of which is distinguished by any theory.",
          flush=True)
    print(f"  validation gates: {'PASSED' if gates_passed else 'FAILED'}",
          flush=True)

    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime(
                "%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "code_version": _code_version(),
                "pmax": args.pmax,
                "n_primes": n_primes,
                "tvals": tvals,
                "ladder_requested": ladder_raw,
                "ladder": ladder,
                "xvar": args.xvar,
                "master_lo": args.master_lo,
                "master_hi": args.master_hi,
                "master_step": args.master_step,
                "master_n": int(len(master)),
                "master_sigmas": [float(x) for x in master],
                "centre_lo": args.centre_lo,
                "centre_hi": args.centre_hi,
                "centre_step": args.centre_step,
                "centres": [float(x) for x in centres],
                "n_centres": int(len(centres)),
                "band_halfwidth": args.band_halfwidth,
                "band_step": args.band_step,
                "band_pad": args.band_pad,
                "win": args.win,
                "win_tol": args.win_tol,
                "poly_deg": args.poly_deg,
                "decimals": args.decimals,
                "focus_centre": args.focus_centre,
                "thresholds": thresholds,
                "percentiles": pctls,
                "expect_n_inside": args.expect_n_inside,
                "expect_n_outside": args.expect_n_outside,
                "gate_file": os.path.basename(args.gate_file),
                "gate_rel_tol": args.gate_rel_tol,
                "curves": curve_names,
                "sd_convention": "ddof=1",
                "percentile_convention": "numpy linear interpolation",
                "precision": "float64",
            },
            "constants": {
                "o9_sd_threshold": 3,
                "critical_line": 0.5,
                "convergence_abscissa": 1.0,
                "statistic": ("max|fm_inside - cubic extrapolation| / "
                              "residual sd outside the window"),
            },
            "summary": {
                "gates_passed": gates_passed,
                "gate_fine_sweep": gate_a,
                "gate_departure_over_sd": gate_b,
                "geometry_exclusions": geometry_issues,
                "band_sizes_seen": sorted(int(b) for b in band_sizes),
                "null_stats": stats,
                "null_percentiles": pct_table,
                "focus": focus,
                "threshold_sweep": thresh_rows,
                "flip": flip,
                "max_z_by_curve": {
                    name: [
                        {"centre": r["centre"], "max_z": r["max_z"]}
                        for r in sweeps[name]
                    ] for name in curve_names
                },
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
