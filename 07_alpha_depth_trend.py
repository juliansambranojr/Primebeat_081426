"""
O7 — Is alpha depth-DEPENDENT?  The pre-registered trend test.

Reads with: preregs/alpha_depth_trend_v1_locked_20260814.md, and with
05_cross_depth_alpha.py, whose machinery this script reuses without
modifying it.

THE ARGUMENT
------------
05 asks whether the per-depth alphas AGREE, by comparing their SPREAD (sd)
against a synthetic null built on a single true beta.  Spread is blind to
ORDER: a clean monotone drift in alpha with depth and a random scatter of the
same magnitude give the same sd.  The DT-A6 §1(b) decision rule has two arms —
the alphas agree, or they scatter — and ordered drift is a third outcome that
neither arm covers.  The spread test passes precisely BECAUSE the departure is
orderly.

So this script replaces the statistic, not the machinery:

    primary statistic = OLS slope b_obs of per-depth alpha on depth d

If beta = Re(rho) is a property of the ZEROS, depth changes only the comb gain
(v2.0 §7.1) and not the radius exponent, so the slope of alpha on d must be
zero up to fitting noise.  A nonzero slope that the apparatus cannot produce on
a single-beta signal says alpha is a property of the fit, not of the zeros.

THE NULL
--------
05's synthetic replicates are built with a SINGLE TRUE BETA by construction.
Any alpha-on-depth slope they produce is therefore pure apparatus artifact, and
is exactly the right null.  Same generator, same seed, same construction:

    p = fraction of trials with |b_syn| >= |b_obs|

Distribution-free; assumes nothing about the alpha residual distribution.

PRE-REGISTRATION
----------------
Every parameter below (rmax=60, rmin=20, depths 2..18, blind depths 13..18,
trials=200, beta=0.4334, seed=2026, alpha_level=0.05 two-sided) and the
four-way decision rule were locked BEFORE this script was run, in
preregs/alpha_depth_trend_v1_locked_20260814.md (sha256 in the sidecar
.sha256 file).  Depths 13-18 had never been fitted at any rmax by anyone and
are the genuine held-out arm.  `verdict` is emitted as a field because it is
pre-registered — unlike the earlier scripts, where no verdict field is
licensed.

REUSED FROM 05 (not reimplemented)
----------------------------------
`fit_alpha`, `prime_counts`, `diff`, `synthetic_rows` are loaded from
05_cross_depth_alpha.py via importlib (its leading digit makes it unimportable
by name) and called unchanged.  05's real-data fluctuation construction and its
per-depth fit loop live inside its main() rather than at module level, so those
two code paths are replicated VERBATIM here (see `real_fluctuation` and
`real_per_depth`) rather than refactoring 05 to expose them.

REQUIREMENTS
------------
    pip install mpmath numpy
    pip install primecountpy      # optional

USAGE
-----
    python3 07_alpha_depth_trend.py
"""

import argparse
import importlib.util
import json
import math
import os
from datetime import datetime, timezone

import numpy as np
from mpmath import mp, mpf, li  # type: ignore

mp.dps = 80
_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")
CACHE = os.path.join(_HERE, "pi2n_cache.json")

SEED = 2026                    # hardcoded, per prereg: no --seed flag
ALPHA_LEVEL = 0.05             # two-sided
BLIND_DEPTHS = [13, 14, 15, 16, 17, 18]
RMAX_SWEEP = [40, 45, 50, 55, 60]
PERM_N = 10000                 # label shuffles for the Spearman permutation p

# Decision-rule guards, locked in the prereg.
MIN_FINITE_DEPTHS = 8
MIN_N_POINTS = 20
MIN_VALID_TRIALS = 150

# Two-sided t critical values at the 0.975 quantile, df 1..30.  scipy is not
# installed in this venv, so the table is hardcoded rather than computed; df>30
# falls back to the normal approximation 1.95996.  Recorded in the results JSON
# as `t_source` so the choice is auditable.
_T975 = {
    1: 12.7062, 2: 4.30265, 3: 3.18245, 4: 2.77645, 5: 2.57058,
    6: 2.44691, 7: 2.36462, 8: 2.30600, 9: 2.26216, 10: 2.22814,
    11: 2.20099, 12: 2.17881, 13: 2.16037, 14: 2.14479, 15: 2.13145,
    16: 2.11991, 17: 2.10982, 18: 2.10092, 19: 2.09302, 20: 2.08596,
    21: 2.07961, 22: 2.07387, 23: 2.06866, 24: 2.06390, 25: 2.05954,
    26: 2.05553, 27: 2.05183, 28: 2.04841, 29: 2.04523, 30: 2.04227,
}
_Z975 = 1.95996


def _jsonable(o):
    """Coerce numpy / mpmath scalars to JSON-safe Python types.

    numpy floats -> float, numpy ints -> int, numpy bools -> bool,
    mpmath mpf -> float, non-finite floats -> None (JSON null).
    """
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
        print(f"\n  results written to {out_path}")
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}")


def _load_o5():
    """Load 05_cross_depth_alpha.py by path — a leading digit blocks `import`."""
    path = os.path.join(_HERE, "05_cross_depth_alpha.py")
    spec = importlib.util.spec_from_file_location("o5_cross_depth_alpha", path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


O5 = _load_o5()
fit_alpha = O5.fit_alpha              # reused verbatim; not reimplemented
prime_counts = O5.prime_counts
diff = O5.diff
synthetic_rows = O5.synthetic_rows


# ----------------------------------------------------------------------------
# Replicated VERBATIM from 05's main() — these code paths are not exposed at
# 05's module level, and the prereg forbids modifying 05 to expose them.
# ----------------------------------------------------------------------------

def real_fluctuation(R):
    """05 main(): ci = prime_counts(R); c = mpf; s = li differences; e = c - s."""
    ci = prime_counts(R)
    c = [mpf(v) for v in ci]
    s = [li(mpf(2) ** n) - li(mpf(2) ** (n - 1)) for n in range(1, R + 1)]
    return [c[i] - s[i] for i in range(R)]


def real_per_depth(e, depths, rmin, R):
    """05 main() per-depth fit loop, unchanged: collect nonzero |D^d e(r)|, fit."""
    out = []
    for d in depths:
        rs, vals = [], []
        for r in range(max(d + 2, rmin), R + 1):
            v = diff(e, r, d)
            if v != 0:
                rs.append(r)
                vals.append(float(abs(v)))
        a, r2, n = fit_alpha(np.array(rs), np.array(vals))
        out.append({"depth": d, "alpha": a, "r2": r2, "n_points": n})
    return out


# ----------------------------------------------------------------------------
# The new statistic.
# ----------------------------------------------------------------------------

def ols(x, y):
    """OLS of y on x.  Returns (slope, intercept, r2, se_slope, n)."""
    x = np.asarray(x, dtype=float)
    y = np.asarray(y, dtype=float)
    n = len(x)
    if n < 3:
        return np.nan, np.nan, np.nan, np.nan, n
    A = np.vstack([np.ones_like(x), x]).T
    coef, *_ = np.linalg.lstsq(A, y, rcond=None)
    pred = A @ coef
    sse = float(np.sum((y - pred) ** 2))
    sst = float(np.sum((y - y.mean()) ** 2))
    r2 = 1 - sse / sst if sst > 0 else np.nan
    sxx = float(np.sum((x - x.mean()) ** 2))
    se = math.sqrt(sse / (n - 2) / sxx) if sxx > 0 and n > 2 else np.nan
    return coef[1], coef[0], r2, se, n


def t_crit(df):
    """Two-sided 0.975 critical value; normal approx above df=30 (no scipy)."""
    if df <= 0:
        return np.nan
    return _T975.get(df, _Z975)


def slope_ci(slope, se, n):
    """Two-sided 95% CI on an OLS slope, t with n-2 df."""
    if not (np.isfinite(slope) and np.isfinite(se)) or n < 3:
        return np.nan, np.nan, np.nan
    tc = t_crit(n - 2)
    return slope - tc * se, slope + tc * se, tc


def slope_on(depths, alphas):
    """OLS slope of alpha on depth over the finite entries only."""
    xs = [d for d, a in zip(depths, alphas) if np.isfinite(a)]
    ys = [a for a in alphas if np.isfinite(a)]
    if len(xs) < 3:
        return np.nan, np.nan, np.nan, np.nan, len(xs)
    return ols(xs, ys)


def _rank(v):
    """Average-tie ranks."""
    v = np.asarray(v, dtype=float)
    order = np.argsort(v, kind="mergesort")
    ranks = np.empty(len(v), dtype=float)
    ranks[order] = np.arange(1, len(v) + 1, dtype=float)
    # average ties
    for val in np.unique(v):
        m = v == val
        if m.sum() > 1:
            ranks[m] = ranks[m].mean()
    return ranks


def spearman(x, y):
    """Spearman rho = Pearson correlation of the ranks."""
    rx, ry = _rank(x), _rank(y)
    rx = rx - rx.mean()
    ry = ry - ry.mean()
    den = math.sqrt(float(np.sum(rx ** 2)) * float(np.sum(ry ** 2)))
    return float(np.sum(rx * ry)) / den if den > 0 else np.nan


def synthetic_slopes(beta, depths, blind_depths, rmin, R, trials, rng,
                     progress=True):
    """Per-trial alpha-on-depth slopes from 05's single-true-beta replicates.

    Generation is 05's `synthetic_rows` called unchanged, driven by one
    sequentially-consumed default_rng(SEED), exactly as 05's control loop does.
    """
    b_syn, b_syn_blind, recovered = [], [], []
    n_invalid = 0
    for t in range(trials):
        rows = synthetic_rows(beta, depths, rmin, R, rng)
        ds, alphas = [], []
        for d in depths:
            rs_, vv = rows[d]
            a, _, _ = fit_alpha(rs_, vv)
            if not np.isnan(a):
                ds.append(d)
                alphas.append(a)
        if len(ds) >= MIN_FINITE_DEPTHS:
            s, _, _, _, _ = ols(ds, alphas)
            if np.isfinite(s):
                b_syn.append(s)
                recovered.extend(alphas)
        else:
            n_invalid += 1
        # blind arm on the same replicate; >=3 finite depths is the minimum a
        # slope with >=1 residual df can be taken on (secondary only — it can
        # never move the primary verdict)
        bd = [(d, a) for d, a in zip(ds, alphas) if d in blind_depths]
        if len(bd) >= 3:
            s2, _, _, _, _ = ols([q[0] for q in bd], [q[1] for q in bd])
            if np.isfinite(s2):
                b_syn_blind.append(s2)
        if progress and (t + 1) % 50 == 0:
            print(f"    {t + 1}/{trials} trials...", flush=True)
    return (np.array(b_syn), np.array(b_syn_blind), np.array(recovered),
            n_invalid)


def perm_p(b_obs, b_syn):
    """Two-sided permutation-style p: fraction of |b_syn| >= |b_obs|."""
    if not np.isfinite(b_obs) or len(b_syn) == 0:
        return np.nan
    return float((np.abs(b_syn) >= abs(b_obs)).mean())


def sign_match(a, b):
    if not (np.isfinite(a) and np.isfinite(b)):
        return False
    if a == 0 or b == 0:
        return a == b
    return (a > 0) == (b > 0)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--rmax", type=int, default=60)
    ap.add_argument("--rmin", type=int, default=20,
                    help="lowest regime included in each per-depth fit")
    ap.add_argument("--depths", type=str,
                    default="2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18")
    ap.add_argument("--trials", type=int, default=200)
    ap.add_argument("--beta", type=float, default=0.4334,
                    help="known beta used to build the synthetic control")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path (default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    R = args.rmax
    depths = [int(x) for x in args.depths.split(",")]

    print("=" * 78)
    print("O7 — is alpha depth-DEPENDENT?  (pre-registered trend test)")
    print("=" * 78)
    print("  prereg : preregs/alpha_depth_trend_v1_locked_20260814.md")
    print("  primary: OLS slope of per-depth alpha on depth d")
    print(f"  regimes {args.rmin}..{R}, depths {depths[0]}..{depths[-1]}, "
          f"trials {args.trials}, beta {args.beta}, seed {SEED}")
    print(f"  blind arm (never fitted before): depths {BLIND_DEPTHS}")
    print("\n  computing exact prime counts...")

    # e is a function of n alone, so the widest table serves every rmax in the
    # robustness sweep by truncation: e_R == e_RMAX[:R], exactly.
    RMAXES = sorted(set(RMAX_SWEEP + [R]))
    e_full = real_fluctuation(max(RMAXES))

    print("\n" + "-" * 78)
    print(f"PER-DEPTH FITS ON THE REAL TABLE  (rmax = {R})")
    print("-" * 78)
    print(f"  {'depth':>6} {'alpha':>9} {'R^2':>8} {'n pts':>7} {'blind':>7}")
    per_depth = real_per_depth(e_full[:R], depths, args.rmin, R)
    for row in per_depth:
        blind = "yes" if row["depth"] in BLIND_DEPTHS else ""
        a = row["alpha"]
        astr = f"{a:>9.4f}" if np.isfinite(a) else f"{'nan':>9}"
        r2s = f"{row['r2']:>8.4f}" if np.isfinite(row["r2"]) else f"{'nan':>8}"
        print(f"  {row['depth']:>6} {astr} {r2s} {row['n_points']:>7} "
              f"{blind:>7}")

    alphas = [row["alpha"] for row in per_depth]
    ds_fin = [row["depth"] for row in per_depth if np.isfinite(row["alpha"])]
    a_fin = [a for a in alphas if np.isfinite(a)]
    n_finite = len(a_fin)

    # ---- PRIMARY -----------------------------------------------------------
    b_obs, icept, r2_trend, se_obs, n_trend = slope_on(depths, alphas)
    lo, hi, tc = slope_ci(b_obs, se_obs, n_trend)

    print("\n" + "-" * 78)
    print("PRIMARY STATISTIC — OLS slope of alpha on depth")
    print("-" * 78)
    print(f"  depths with finite alpha : {n_finite} / {len(depths)}")
    print(f"  slope b_obs              : {b_obs:+.6f}")
    print(f"  intercept                : {icept:+.6f}")
    print(f"  R^2 of the trend         : {r2_trend:.4f}")
    print(f"  se(slope)                : {se_obs:.6f}   "
          f"(t crit {tc:.4f}, df {n_trend - 2})")
    print(f"  95% CI                   : [{lo:+.6f}, {hi:+.6f}]")
    print(f"  CI contains zero         : {'yes' if lo <= 0 <= hi else 'NO'}")

    # ---- NULL --------------------------------------------------------------
    print("\n" + "-" * 78)
    print(f"NULL — {args.trials} synthetic tables, single true beta = {args.beta}")
    print("-" * 78)
    print("  05's generator, unchanged; same depths, same regimes, same seed")
    rng = np.random.default_rng(SEED)
    b_syn, b_syn_blind, recovered, n_invalid = synthetic_slopes(
        args.beta, depths, BLIND_DEPTHS, args.rmin, R, args.trials, rng)
    n_valid = len(b_syn)
    p_primary = perm_p(b_obs, b_syn)

    print(f"\n  valid trials             : {n_valid} / {args.trials} "
          f"({n_invalid} had < {MIN_FINITE_DEPTHS} finite depths)")
    print(f"  synthetic slope mean     : {b_syn.mean():+.6f}")
    print(f"  synthetic slope sd       : {b_syn.std():.6f}")
    print(f"  synthetic |slope| 95th   : {np.percentile(np.abs(b_syn), 95):.6f}")
    print(f"  observed |b_obs|         : {abs(b_obs):.6f}")
    print(f"\n  PRIMARY p = frac(|b_syn| >= |b_obs|) = {p_primary:.4f}")

    # ---- SECONDARIES -------------------------------------------------------
    print("\n" + "-" * 78)
    print("PRE-SPECIFIED SECONDARIES  (cannot change the primary verdict)")
    print("-" * 78)

    # (a) blind arm
    b_alphas = [row["alpha"] for row in per_depth if row["depth"] in BLIND_DEPTHS]
    b_ds = [row["depth"] for row in per_depth if row["depth"] in BLIND_DEPTHS]
    b_blind, ib, r2b, seb, nb = slope_on(b_ds, b_alphas)
    blo, bhi, btc = slope_ci(b_blind, seb, nb)
    p_blind = perm_p(b_blind, b_syn_blind)
    print(f"\n  (a) BLIND ARM — depths {BLIND_DEPTHS[0]}..{BLIND_DEPTHS[-1]}, "
          f"never fitted before this run")
    print(f"      slope b_blind : {b_blind:+.6f}   (n = {nb} depths)")
    print(f"      95% CI        : [{blo:+.6f}, {bhi:+.6f}]")
    print(f"      p             : {p_blind:.4f}   "
          f"({len(b_syn_blind)} valid synthetic blind trials)")
    print(f"      sign vs primary: "
          f"{'MATCH' if sign_match(b_obs, b_blind) else 'disagree'}")

    # (b) Spearman + permutation p
    rho = spearman(ds_fin, a_fin)
    prng = np.random.default_rng(SEED)
    y = np.array(a_fin, dtype=float)
    cnt = 0
    for _ in range(PERM_N):
        if abs(spearman(ds_fin, prng.permutation(y))) >= abs(rho):
            cnt += 1
    p_rho = cnt / PERM_N
    print(f"\n  (b) MONOTONICITY — Spearman rho of alpha on depth")
    print(f"      rho           : {rho:+.6f}   (n = {len(a_fin)} depths)")
    print(f"      permutation p : {p_rho:.4f}   ({PERM_N} label shuffles, "
          f"seed {SEED})")

    # (c) rmax robustness
    print(f"\n  (c) rmax ROBUSTNESS — primary slope and p at each rmax")
    print(f"      {'rmax':>6} {'b_obs':>12} {'p':>8} {'valid':>7} "
          f"{'depths':>7}")
    rmax_rows = []
    for rm in RMAX_SWEEP:
        if rm == R:
            b_r, p_r, nv_r, nf_r = b_obs, p_primary, n_valid, n_finite
        else:
            pd_r = real_per_depth(e_full[:rm], depths, args.rmin, rm)
            al_r = [q["alpha"] for q in pd_r]
            b_r, _, _, _, _ = slope_on(depths, al_r)
            nf_r = int(np.isfinite(al_r).sum())
            rng_r = np.random.default_rng(SEED)
            bs_r, _, _, _ = synthetic_slopes(args.beta, depths, BLIND_DEPTHS,
                                             args.rmin, rm, args.trials, rng_r,
                                             progress=False)
            p_r, nv_r = perm_p(b_r, bs_r), len(bs_r)
        rmax_rows.append({"rmax": rm, "b_obs": b_r, "p": p_r,
                          "n_valid_trials": nv_r, "n_finite_depths": nf_r})
        print(f"      {rm:>6} {b_r:>+12.6f} {p_r:>8.4f} {nv_r:>7} {nf_r:>7}")
    print("      (documents range dependence; does NOT select the verdict)")

    # (d) fitting bias
    bias = float(recovered.mean()) - args.beta if len(recovered) else np.nan
    print(f"\n  (d) FITTING BIAS — synthetic recovered alpha vs known truth")
    print(f"      mean recovered alpha : {recovered.mean():.6f}")
    print(f"      true beta            : {args.beta:.6f}")
    print(f"      bias                 : {bias:+.6f}")

    # ---- DECISION RULE -----------------------------------------------------
    min_pts = min((row["n_points"] for row in per_depth
                   if np.isfinite(row["alpha"])), default=0)
    c_few_depths = n_finite < MIN_FINITE_DEPTHS
    c_few_points = min_pts < MIN_N_POINTS
    c_few_trials = n_valid < MIN_VALID_TRIALS
    compromised = c_few_depths or c_few_points or c_few_trials

    if compromised:
        verdict = "compromised"
    elif np.isfinite(p_primary) and p_primary < ALPHA_LEVEL \
            and sign_match(b_obs, b_blind):
        verdict = "depth_dependent"
    elif np.isfinite(p_primary) and p_primary >= ALPHA_LEVEL \
            and np.isfinite(lo) and lo <= 0 <= hi:
        verdict = "depth_independent"
    else:
        verdict = "ambiguous"

    print("\n" + "-" * 78)
    print("DECISION RULE  (locked in the prereg, applied without discretion)")
    print("-" * 78)
    print(f"  compromised gates:")
    print(f"    finite depths {n_finite} < {MIN_FINITE_DEPTHS}          "
          f": {c_few_depths}")
    print(f"    min n_points  {min_pts} < {MIN_N_POINTS}         "
          f": {c_few_points}")
    print(f"    valid trials  {n_valid} < {MIN_VALID_TRIALS}       "
          f": {c_few_trials}")
    print(f"  p < {ALPHA_LEVEL}                        "
          f": {np.isfinite(p_primary) and p_primary < ALPHA_LEVEL}")
    print(f"  sign(b_obs) == sign(b_blind)     : {sign_match(b_obs, b_blind)}")
    print(f"  95% CI on b_obs contains 0       : "
          f"{bool(np.isfinite(lo) and lo <= 0 <= hi)}")

    print("\n" + "=" * 78)
    print("READ THE RESULT")
    print("=" * 78)
    print(f"""
  slope b_obs        : {b_obs:+.6f}   95% CI [{lo:+.6f}, {hi:+.6f}]
  primary p          : {p_primary:.4f}
  blind slope b_blind: {b_blind:+.6f}   (depths 13-18, never fitted before)
  Spearman rho       : {rho:+.6f}   perm p {p_rho:.4f}
  fitting bias       : {bias:+.6f} on a known beta of {args.beta}

  VERDICT : {verdict}

  depth_dependent    -> alpha is not measuring a property of the zeros; the
                        DT-A6 §1(b) reading comes out.
  depth_independent  -> this test does not falsify §1(b).  NOT the same as
                        confirming it: absence of a detectable slope at
                        n={n_finite} depths is weak evidence, and the writeup
                        must say so rather than claiming support.
  ambiguous          -> the data does not discriminate.  A real outcome, not a
                        deferral; design a sharper test.
  compromised        -> the data is corrupt for reasons unrelated to H0.

  Provenance: depths 2-12 at rmax 40-60 were inspected before this prereg was
  written, so the primary arm is confirmatory-on-inspected-data and must be
  labelled as such.  Depths 13-18 are the only fully blind arm.

  Limits, inherited from 05: the null uses independent Gaussian phases, which
  DT-A §4 flags as WEAKER than the correlated zeta-zero sum the real
  fluctuation is; adjacent depths share cells, so the per-depth fits are not
  independent, which the OLS se does not account for; the synthetic uses ten
  modes and the real signal has infinitely many.
""")

    if not args.no_json:
        out_path = args.out if args.out else DEFAULT_OUT
        payload = {
            "schema_version": "1",
            "script": os.path.basename(os.path.abspath(__file__)),
            "generated_utc": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "params": {
                "rmax": args.rmax,
                "rmin": args.rmin,
                "depths": depths,
                "depths_raw": args.depths,
                "blind_depths": BLIND_DEPTHS,
                "trials": args.trials,
                "beta": args.beta,
            },
            "constants": {
                "rng_seed": SEED,
                "alpha_level": ALPHA_LEVEL,
                "pooled_alpha_reference": 0.4334,
                "rmax_sweep": RMAX_SWEEP,
                "permutation_n": PERM_N,
                "min_finite_depths": MIN_FINITE_DEPTHS,
                "min_n_points": MIN_N_POINTS,
                "min_valid_trials": MIN_VALID_TRIALS,
                "t_source": "hardcoded two-sided t_0.975 table df<=30; "
                            "normal approx 1.95996 above (scipy not installed)",
                "prereg": "preregs/alpha_depth_trend_v1_locked_20260814.md",
            },
            "summary": {
                "verdict": verdict,
                "b_obs": b_obs,
                "intercept": icept,
                "trend_r2": r2_trend,
                "se_slope": se_obs,
                "ci_low": lo,
                "ci_high": hi,
                "t_crit": tc,
                "df": n_trend - 2,
                "ci_contains_zero": bool(np.isfinite(lo) and lo <= 0 <= hi),
                "p_primary": p_primary,
                "n_finite_depths": n_finite,
                "min_n_points": min_pts,
                "n_valid_trials": n_valid,
                "n_invalid_trials": n_invalid,
                "synthetic_slope_mean": b_syn.mean() if n_valid else None,
                "synthetic_slope_sd": b_syn.std() if n_valid else None,
                "blind": {
                    "b_blind": b_blind,
                    "ci_low": blo,
                    "ci_high": bhi,
                    "p": p_blind,
                    "n_depths": nb,
                    "n_valid_trials": len(b_syn_blind),
                    "sign_matches_primary": sign_match(b_obs, b_blind),
                },
                "spearman": {"rho": rho, "p_permutation": p_rho,
                             "n_permutations": PERM_N, "n_depths": len(a_fin)},
                "rmax_robustness": rmax_rows,
                "fitting_bias": bias,
                "synthetic_recovered_mean_alpha":
                    recovered.mean() if len(recovered) else None,
                "compromised_gates": {
                    "too_few_finite_depths": c_few_depths,
                    "too_few_points": c_few_points,
                    "too_few_valid_trials": c_few_trials,
                },
            },
            "rows": per_depth,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
