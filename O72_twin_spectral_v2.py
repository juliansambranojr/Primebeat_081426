#!/usr/bin/env python3
"""O72 — EXPLORATORY. No prereg, no verdict. O66 v2.

The twin process on the 6k lattice: rigidity and correlations, with
stated uncertainty at every height.

WHY THIS EXISTS. O66 measured three heights with one window and one
Bernoulli draw each. Entry 111's fresh-eyes review found the load-bearing
endpoint DEGENERATE with its own control: at x ~ 6e10, F(256) read 0.929
for the twin process and 0.932 for its single Bernoulli draw — "rigidity
gone" rested on a three-point trend whose top point could not distinguish
signal from null. The review's demand, recorded as the NOTEPAD line this
script answers: "more heights with stated uncertainty; the current
endpoint is degenerate with its control."

WHAT IS MEASURED (entry 105's axis, unchanged). Does the twin process
inherit the primes' rigidity, or does it fluctuate like a Bernoulli
thinning of the lattice? Three statistics per window, as O66:

  1. F(B): variance/mean of twin counts in blocks of B sites.
  2. R(h): pair correlation at site lag h = 1..30 against the
     Hardy-Littlewood prediction S4/(6*S2^2) — O66 run 2's corrected
     normalization, copied verbatim.
  3. Low-frequency power ratio (lowest decile / overall).

WHAT V2 ADDS.

  HEIGHTS   seven site-index decades, default K = 1e6 .. 1e12
            (x ~ 6e6 .. 6e12), against O66's three.
  WINDOWS   W disjoint windows per height (default 8), so every
            statistic carries an across-window mean and sd.
  POWER     window size M scales with ln^2(x): 2^20 below K = 1e9,
            2^21 to K < 1e11, 2^22 above — expected twins per window
            stays comparable instead of thinning with height.
  NULL      B Bernoulli replicates per height (default 32) at the
            pooled twin density give the control a DISTRIBUTION:
            null mean, null sd, and a separation
            z = (twin_mean - null_mean) / sqrt(sem_twin^2 + sem_null^2)
            per statistic. A height that cannot distinguish signal
            from null now says so in its own row.

This script states numbers; interpretation is not its job.

Reads with: O66_twin_spectral.py (v1, frozen with its run logs and
results/twin_spectral.json), notes/lab_notebook_2.md entries 103, 105,
107, 111, papers/The-Twin-Lattice.md.

HOW IT WAS RUN
--------------
    python3 O72_twin_spectral_v2.py
"""
import argparse
import hashlib
import json
import math
import os
from datetime import datetime, timezone

import numpy as np
from sympy import primerange

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_BASENAME = "twin_spectral_v2.json"


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def _write_results(payload, out_path):
    try:
        with open(out_path, "w") as f:
            json.dump(payload, f, indent=2)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: "
              f"{exc}", flush=True)


def sieve_window(lo, hi, primes_sqrt):
    """Boolean primality for integers in [lo, hi), segmented.
    Verbatim O66 logic, with the base primes passed in (computed once
    per height rather than per window)."""
    n = hi - lo
    is_p = np.ones(n, dtype=bool)
    if lo <= 1:
        is_p[:max(0, min(2 - lo, n))] = False
    for p in primes_sqrt:
        start = max(p * p, ((lo + p - 1) // p) * p)
        if start < hi:
            is_p[start - lo::p] = False
    return is_p


def occupancy(K, M, primes_sqrt):
    """twin, lo-side, hi-side prime indicators for sites k in [K, K+M).
    Verbatim O66 logic."""
    xlo, xhi = 6 * K - 2, 6 * (K + M) + 2
    is_p = sieve_window(xlo, xhi, primes_sqrt)
    k = np.arange(K, K + M)
    pl = is_p[6 * k - 1 - xlo]
    ph = is_p[6 * k + 1 - xlo]
    return (pl & ph), pl, ph


def F_curve(t, blocks):
    out = {}
    for B in blocks:
        n = len(t) // B
        c = t[:n * B].reshape(n, B).sum(axis=1).astype(float)
        out[B] = float(c.var(ddof=1) / c.mean())
    return out


def pair_corr(t, lags):
    m = t.mean()
    return {h: float((t[:-h] & t[h:]).mean() / m ** 2) for h in lags}


def low_freq_ratio(x):
    z = x.astype(float) - x.mean()
    P = np.abs(np.fft.rfft(z)) ** 2
    P = P[1:]
    k = max(1, len(P) // 10)
    return float(P[:k].mean() / P.mean())


def hl_ratio(h, primes):
    """R(h) predicted = S(0,2,6h,6h+2) / (6 * S(0,2)^2). Verbatim the
    O66 run-2 corrected normalization: the lattice conditioning enters
    the numerator once and the denominator twice, hence the factor 6."""
    H4 = [0, 2, 6 * h, 6 * h + 2]
    r = 1.0
    for p in primes:
        v4 = len({a % p for a in H4})
        v2 = len({a % p for a in (0, 2)})
        num = (1 - v4 / p) / (1 - 1 / p) ** 4
        den = ((1 - v2 / p) / (1 - 1 / p) ** 2) ** 2
        r *= num / den
    return r / 6.0


def auto_m(K):
    if K < 10 ** 9:
        return 2 ** 20
    if K < 10 ** 11:
        return 2 ** 21
    return 2 ** 22


def _agg(vals):
    a = np.asarray(vals, dtype=float)
    return {"mean": float(a.mean()),
            "sd": float(a.std(ddof=1)) if a.size > 1 else 0.0,
            "sem": float(a.std(ddof=1) / math.sqrt(a.size))
                   if a.size > 1 else 0.0,
            "n": int(a.size)}


def _sep(twin_agg, null_agg):
    denom = math.sqrt(twin_agg["sem"] ** 2 + null_agg["sem"] ** 2)
    if denom == 0.0:
        return None
    return float((twin_agg["mean"] - null_agg["mean"]) / denom)


def main():
    ap = argparse.ArgumentParser(
        description=("O72 - twin rigidity and correlations vs Bernoulli, "
                     "multi-height, multi-window, null distributions. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict."))
    ap.add_argument("--heights", type=str,
                    default="1e6,1e7,1e8,1e9,1e10,1e11,1e12",
                    help="comma list of window-start site indices K "
                         "(x ~ 6K; default 1e6..1e12 by decades)")
    ap.add_argument("--windows", type=int, default=8,
                    help="disjoint windows per height (default 8)")
    ap.add_argument("--m", type=int, default=0,
                    help="sites per window; 0 = auto ln^2 scaling "
                         "(2^20 below K=1e9, 2^21 to K<1e11, 2^22 above)")
    ap.add_argument("--bern-reps", type=int, default=32,
                    help="Bernoulli replicates per height for the null "
                         "distribution (default 32)")
    ap.add_argument("--lags-max", type=int, default=30,
                    help="pair-correlation lags 1..LAGS_MAX (default 30)")
    ap.add_argument("--blocks", type=str, default="256,1024,4096",
                    help="F(B) block sizes in sites (default 256,1024,4096)")
    ap.add_argument("--ss-cutoff", type=int, default=100000,
                    help="singular-series prime cutoff (default 1e5)")
    ap.add_argument("--seed", type=int, default=2026,
                    help="numpy default_rng seed (default 2026)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path (default results-dir/"
                         + DEFAULT_OUT_BASENAME + ")")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    rng = np.random.default_rng(args.seed)
    heights = [int(float(s)) for s in args.heights.split(",")]
    blocks = [int(s) for s in args.blocks.split(",")]
    lags = list(range(1, args.lags_max + 1))
    W = args.windows
    out_path = args.out or os.path.join(args.results_dir,
                                        DEFAULT_OUT_BASENAME)

    print("O72 — twin rigidity and correlations, v2: heights x windows "
          "x null distributions.  EXPLORATORY.")
    print(f"  heights K = " + ", ".join(f"{K:.0e}" for K in heights)
          + f"   windows/height = {W}   bern reps = {args.bern_reps}"
          + f"   seed = {args.seed}\n")

    ss_primes = list(primerange(2, args.ss_cutoff))
    hl = {h: hl_ratio(h, ss_primes) for h in lags}

    rows = {}
    for K in heights:
        M = args.m if args.m > 0 else auto_m(K)
        hi_max = 6 * (K + W * M) + 2
        primes_sqrt = list(primerange(2, int(math.isqrt(hi_max)) + 1))

        per = {"F": {B: [] for B in blocks}, "lf": [], "resid": [],
               "n_twins": [], "dens": [],
               "Fb": {B: [] for B in blocks}, "lfb": [], "residb": []}
        for i in range(W):
            t, pl, ph = occupancy(K + i * M, M, primes_sqrt)
            dens = t.mean()
            bern = rng.random(M) < dens
            Ft = F_curve(t, blocks)
            Fb = F_curve(bern, blocks)
            Rt = pair_corr(t, lags)
            Rb = pair_corr(bern, lags)
            for B in blocks:
                per["F"][B].append(Ft[B])
                per["Fb"][B].append(Fb[B])
            per["lf"].append(low_freq_ratio(t))
            per["lfb"].append(low_freq_ratio(bern))
            per["resid"].append(float(np.mean([abs(Rt[h] - hl[h])
                                               for h in lags])))
            per["residb"].append(float(np.mean([abs(Rb[h] - 1.0)
                                                for h in lags])))
            per["n_twins"].append(int(t.sum()))
            per["dens"].append(float(dens))

        pooled_dens = float(np.mean(per["dens"]))
        null = {"F": {B: [] for B in blocks}, "lf": []}
        for _ in range(args.bern_reps):
            b = rng.random(M) < pooled_dens
            Fb = F_curve(b, blocks)
            for B in blocks:
                null["F"][B].append(Fb[B])
            null["lf"].append(low_freq_ratio(b))

        agg = {
            "F_twin": {str(B): _agg(per["F"][B]) for B in blocks},
            "F_null": {str(B): _agg(null["F"][B]) for B in blocks},
            "lf_twin": _agg(per["lf"]),
            "lf_null": _agg(null["lf"]),
            "resid_twin": _agg(per["resid"]),
            "resid_bern_windows": _agg(per["residb"]),
        }
        z = {"lf": _sep(agg["lf_twin"], agg["lf_null"])}
        for B in blocks:
            z[f"F_{B}"] = _sep(agg["F_twin"][str(B)], agg["F_null"][str(B)])

        n_tw = int(np.sum(per["n_twins"]))
        print(f"=== K = {K:.0e}   x ~ {6 * K:.1e}   M = 2^"
              f"{int(math.log2(M))}   twins/window "
              f"{np.mean(per['n_twins']):.0f}   total {n_tw}")
        for B in blocks:
            tw, nl = agg["F_twin"][str(B)], agg["F_null"][str(B)]
            print(f"   F({B:>4}): twin {tw['mean']:.4f} ± {tw['sd']:.4f}"
                  f"   null {nl['mean']:.4f} ± {nl['sd']:.4f}"
                  f"   z = {z[f'F_{B}']:+.2f}")
        tw, nl = agg["lf_twin"], agg["lf_null"]
        print(f"   low-freq: twin {tw['mean']:.4f} ± {tw['sd']:.4f}"
              f"   null {nl['mean']:.4f} ± {nl['sd']:.4f}"
              f"   z = {z['lf']:+.2f}")
        rt, rb = agg["resid_twin"], agg["resid_bern_windows"]
        print(f"   mean|R-HL| twin {rt['mean']:.4f} ± {rt['sd']:.4f}"
              f"   (bernoulli windows vs 1: {rb['mean']:.4f} "
              f"± {rb['sd']:.4f})\n")

        rows[str(K)] = {
            "x_scale": 6 * K, "M": M, "windows": W,
            "pooled_density": pooled_dens,
            "n_twins_per_window": per["n_twins"],
            "per_window": {
                "F_twin": {str(B): per["F"][B] for B in blocks},
                "F_bernoulli": {str(B): per["Fb"][B] for B in blocks},
                "lf_twin": per["lf"], "lf_bernoulli": per["lfb"],
                "mean_abs_R_minus_HL": per["resid"],
                "mean_abs_Rbern_minus_1": per["residb"],
            },
            "aggregates": agg,
            "separation_z": z,
        }

    print("HL prediction is lag-dependent and nontrivial: " +
          ", ".join(f"R({h})={hl[h]:.3f}" for h in (1, 2, 3, 5)))

    if not args.no_json:
        _write_results({
            "schema_version": "1", "script": "O72_twin_spectral_v2.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "heights": heights, "windows": W,
                       "m_flag": args.m, "bern_reps": args.bern_reps,
                       "lags": lags, "blocks": blocks,
                       "ss_prime_cutoff": args.ss_cutoff,
                       "seed": args.seed,
                       "m_rule": "auto ln^2 scaling: 2^20 below K=1e9, "
                                 "2^21 to K<1e11, 2^22 above"
                                 if args.m == 0 else "explicit --m",
                       "window_layout": "W disjoint contiguous windows "
                                        "[K+i*M, K+(i+1)*M)",
                       "null_definition": "bern_reps Bernoulli windows of "
                                          "length M at the pooled twin "
                                          "density; separation z = "
                                          "(twin_mean - null_mean) / "
                                          "sqrt(sem_t^2 + sem_n^2)"},
            "hl_prediction": {str(h): hl[h] for h in lags},
            "rows": rows}, out_path)


if __name__ == "__main__":
    main()
