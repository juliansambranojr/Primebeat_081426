#!/usr/bin/env python3
"""
O12 — The dyadic block ratio: a fit-free reading of how the prime block sum
      grows, measured directly rather than regressed.

Reads with: dyadic-table-v2.md; DT-A5; DT-A6; and O9_convergence_abscissa.py
(this bench's `results/O9_convergence_abscissa_results*.json`).

NAMING
------
The O-series in this tree runs O1-O9 and O11.  There is NO O10: that number is
a known, deliberate gap and this script does not fill it, because filling a
reserved gap with unrelated work would silently rewrite the series' history.
The next free numbers after O11 are O12 and O13; this file takes O12 and the
companion smoothness-null script takes O13.  Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

ENVELOPE ADDITION (new on O12/O13 only)
---------------------------------------
The house JSON envelope is unchanged in shape (schema_version, script,
generated_utc, params, constants, summary, rows) and `schema_version` stays
"1".  ONE key is added inside `params`: `code_version`, the sha256 of THIS
script file, computed at runtime by reading `__file__`.  That makes each
result self-identifying about which code produced it.  No existing script's
envelope is touched.

WHY A FIT-FREE INSTRUMENT
-------------------------
O9 measures growth by regressing log|S_2N - S_N| on log N over a six-rung
ladder and reporting a slope plus r^2.  That is a fit: it imposes a power law,
it is sensitive to the window, and its verdict lives behind a threshold on a
fitted statistic.  O12 removes all of that.  There is no least squares, no
r^2, no window, and no threshold on a fitted quantity.

Define, for prime-count cutoff N:

    Delta_N = sum over primes[N : 2N] of p^(-sigma) * exp(-i t log p)
              (EXACTLY N terms — the dyadic block, taken directly)
    r_N     = |Delta_N| / N
    rho     = r_2N / r_N   between consecutive rungs of a DOUBLING ladder

Because the ladder doubles, rho IS the exponent.  If |Delta_N| ~ N^a then

    r_N ~ N^(a-1),  so  rho = r_2N / r_N = 2^(a-1),  hence  a = 1 + log2(rho).

Landmarks:

    a = 1     (fully additive, no cancellation)      -> rho = 1.0
    a = 1/2   (square-root cancellation)             -> rho = 0.70710678

A KNOWN DESIGN FLAW, STATED UP FRONT
------------------------------------
The ADD band and the SQRT band COINCIDE at sigma = 0.5.  The additive law is
a = 1 - sigma (each block has N terms of typical size p^(-sigma), and
p_N ~ N log N), so at sigma = 0.5 the purely additive prediction is a = 1/2 —
numerically identical to square-root cancellation.  A SQRT verdict at
sigma = 0.5 is therefore NOT evidence of cancellation; it is what an additive
sum with a p^(-1/2) weight looks like.  sigma = 0 is the DISCRIMINATING row:
there the additive prediction is a = 1 (rho = 1) and genuine square-root
cancellation would read rho = 0.7071, so the two are 0.29 apart in rho and the
rule can tell them apart.  This is printed in the run output as well as stated
here; it must not be buried.

NUMERICS
--------
Delta_N is computed DIRECTLY as a numpy sum over the slice primes[N:2*N].  It
is NOT formed by differencing two cumulative sums, so no catastrophic
cancellation of large partial sums enters.  The sieve and the summand formula
mirror O9 exactly: p^(-sigma) * (cos(t log p) - i sin(t log p)).

A validation gate RUNS as part of every invocation: at the rungs O9's ladder
shares (N = 125, 250, 500, 1000, 2000, 4000) the direct block sum is compared
against the O9-style difference prime_sum(2N) - prime_sum(N) at sigma = 0.5,
t = 14.5, and must agree to at least 10 significant figures.  Failure prints
loudly and sets `gate_passed: false`, but the JSON is still written.

DECISION RULE (documented defaults, all exposed as flags, all recorded)
----------------------------------------------------------------------
    SETTLED  iff  max |rho_k - mean| < eps  over the LAST THREE rho
                  (eps default 0.03)
    ADD      iff  SETTLED and |mean - 1.00000000| < eps
    SQRT     iff  SETTLED and |mean - 0.70710678| < eps
    OTHER    iff  SETTLED but near neither landmark
    TRANS    iff  not SETTLED

    One-outlier rule: if excluding exactly ONE rho from the LAST FOUR makes
    the remaining three SETTLED, report SETTLED-WITH-OUTLIER, name the
    excluded rung, and report BOTH verdicts (the strict verdict is TRANS).
    Never exclude more than one.  If several single exclusions would work,
    the one giving the smallest spread is taken and all candidates are
    recorded.

rho is labelled by its UPPER rung: rho at row N means r_N / r_(N/2).

ALSO REPORTED
-------------
Per sigma, the mean of a = 1 + log2(rho_mean) across the SETTLED series, the
deviation from the additive prediction a = 1 - sigma, and the predicted
log-log correction -sigma/log(N) at the top rung.  The finite-N additive law
is a_eff = 1 - sigma - sigma/log N (from p_N ~ N log N), so that correction is
the size of the shortfall one should expect WITHOUT invoking any cancellation.

REQUIREMENTS
------------
    pip install numpy

Runtime: a couple of minutes at the defaults (--pmax 10000000).

USAGE
-----
    python3 O12_dyadic_block_ratio.py
    python3 O12_dyadic_block_ratio.py --pmax 2000000 --out /tmp/o12.json
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
    """
    Truncated prime sum  sum_{p <= p_n} p^(-sigma - i t).  Identical formula to
    O9's prime_sum.  Used ONLY by the validation gate, never by the block ratio.
    """
    p = primes[:n_terms]
    lg = np.log(p)
    w = p ** (-sigma)
    return complex(np.sum(w * np.cos(t * lg)), -np.sum(w * np.sin(t * lg)))


def block_delta(primes, N, sigma, t):
    """
    Delta_N = sum over primes[N:2N] of p^(-sigma) * (cos(t log p) - i sin(t log p)).
    EXACTLY N terms, summed directly. No differencing of cumulative sums.
    """
    p = primes[N:2 * N]
    lg = np.log(p)
    w = p ** (-sigma)
    return complex(np.sum(w * np.cos(t * lg)), -np.sum(w * np.sin(t * lg)))


def classify(mean_rho, eps, add_landmark, sqrt_landmark):
    """Landmark classification of a settled mean rho."""
    if mean_rho is None or not math.isfinite(mean_rho):
        return "OTHER"
    if abs(mean_rho - add_landmark) < eps:
        return "ADD"
    if abs(mean_rho - sqrt_landmark) < eps:
        return "SQRT"
    return "OTHER"


def settled_spread(vals):
    """
    Return (max |v - mean|, mean) over vals.  If any value is missing or
    non-finite the pair is (nan, nan) — a series with a hole can never settle.
    """
    vs = [v for v in vals if v is not None and math.isfinite(v)]
    if len(vs) != len(vals) or not vs:
        return float("nan"), float("nan")
    m = sum(vs) / len(vs)
    return max(abs(v - m) for v in vs), m


def decide(rhos, eps, add_landmark, sqrt_landmark, last_n, outlier_pool):
    """
    Apply the decision rule to a list of (rung_N, rho) pairs, oldest first.

    Returns a dict with the primary verdict, the strict verdict, the mean rho
    used, the spread, and — when the one-outlier rule fires — the excluded
    rung and the full candidate list.
    """
    out = {
        "verdict": None, "verdict_strict": None,
        "landmark_class": None, "mean_rho": None, "spread": None,
        "eps": eps, "n_rho": len(rhos),
        "rungs_used": None, "outlier_excluded_rung": None,
        "outlier_candidate_rungs": None,
    }
    if len(rhos) < last_n:
        out["verdict"] = "TRANS"
        out["verdict_strict"] = "TRANS"
        out["note"] = f"fewer than {last_n} rho available"
        return out

    tail = rhos[-last_n:]
    spread, mean_rho = settled_spread([r for _, r in tail])
    out["spread"] = spread
    out["mean_rho"] = mean_rho
    out["rungs_used"] = [int(n) for n, _ in tail]

    if math.isfinite(spread) and spread < eps:
        cls = classify(mean_rho, eps, add_landmark, sqrt_landmark)
        out["landmark_class"] = cls
        out["verdict"] = cls
        out["verdict_strict"] = cls
        return out

    # strict verdict is TRANS; try the one-outlier rule on the last `outlier_pool`
    out["verdict_strict"] = "TRANS"
    if len(rhos) >= outlier_pool:
        pool = rhos[-outlier_pool:]
        cands = []
        for j in range(len(pool)):
            keep = [pool[k] for k in range(len(pool)) if k != j]
            spread_j, mean_j = settled_spread([r for _, r in keep])
            if math.isfinite(spread_j) and spread_j < eps:
                cands.append((pool[j][0], spread_j, mean_j,
                              [int(n) for n, _ in keep]))
        if cands:
            cands.sort(key=lambda c: c[1])
            excl_rung, spread_o, mean_o, kept = cands[0]
            out["verdict"] = "SETTLED-WITH-OUTLIER"
            out["outlier_excluded_rung"] = int(excl_rung)
            out["outlier_candidate_rungs"] = [int(c[0]) for c in cands]
            out["mean_rho"] = mean_o
            out["spread"] = spread_o
            out["rungs_used"] = kept
            out["landmark_class"] = classify(mean_o, eps, add_landmark,
                                             sqrt_landmark)
            return out

    out["verdict"] = "TRANS"
    return out


def main():
    ap = argparse.ArgumentParser(
        description="O12 — fit-free dyadic block ratio rho = r_2N / r_N")
    ap.add_argument("--pmax", type=int, default=10000000,
                    help="sieve limit for the prime list (default 10000000)")
    ap.add_argument("--ladder-base", type=int, default=125,
                    help="first rung N of the doubling ladder (default 125)")
    ap.add_argument("--ladder-rungs", type=int, default=12,
                    help="number of doubling rungs requested (default 12); a "
                         "rung is kept only if 2N <= n_primes")
    ap.add_argument("--sigmas", type=str, default="0.0,0.5,1.0",
                    help="comma-separated sigma values (default 0.0,0.5,1.0)")
    ap.add_argument("--tvals", type=str,
                    default="10,14.5,20,30,40,50,80,160,320",
                    help="comma-separated t values")
    ap.add_argument("--eps", type=float, default=0.03,
                    help="decision-rule tolerance eps (default 0.03)")
    ap.add_argument("--add-landmark", type=float, default=1.0,
                    help="rho landmark for the additive law a=1 (default 1.0)")
    ap.add_argument("--sqrt-landmark", type=float, default=0.70710678,
                    help="rho landmark for a=1/2 (default 0.70710678)")
    ap.add_argument("--settle-last", type=int, default=3,
                    help="number of trailing rho tested for SETTLED (default 3)")
    ap.add_argument("--outlier-pool", type=int, default=4,
                    help="size of the trailing pool the one-outlier rule may "
                         "drop exactly one member from (default 4)")
    ap.add_argument("--gate-sigma", type=float, default=0.5,
                    help="sigma for the direct-vs-difference validation gate")
    ap.add_argument("--gate-t", type=float, default=14.5,
                    help="t for the direct-vs-difference validation gate")
    ap.add_argument("--gate-ladder", type=str,
                    default="125,250,500,1000,2000,4000",
                    help="rungs shared with the O9 ladder, used by the gate")
    ap.add_argument("--gate-sigfigs", type=float, default=10.0,
                    help="minimum significant figures of agreement required "
                         "by the validation gate (default 10)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path (default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    sigmas = [float(x) for x in args.sigmas.split(",")]
    tvals = [float(x) for x in args.tvals.split(",")]
    gate_ladder = [int(x) for x in args.gate_ladder.split(",")]
    gate_tol = 10.0 ** (-args.gate_sigfigs)

    print("=" * 78, flush=True)
    print("O12 — dyadic block ratio  rho = r_2N / r_N   (fit-free)", flush=True)
    print("=" * 78, flush=True)
    print("  Delta_N = sum over primes[N:2N] of p^(-sigma) exp(-i t log p)",
          flush=True)
    print("  r_N     = |Delta_N| / N", flush=True)
    print("  rho     = r_2N / r_N ;  a = 1 + log2(rho)", flush=True)
    print(f"  landmarks: a=1 -> rho={args.add_landmark:.8f} ;  "
          f"a=1/2 -> rho={args.sqrt_landmark:.8f}", flush=True)
    print("  no least squares, no r^2, no window, no fitted threshold",
          flush=True)

    print("\n" + "!" * 78, flush=True)
    print("KNOWN DESIGN FLAW IN THE DECISION RULE — read before the tables",
          flush=True)
    print("!" * 78, flush=True)
    print("  The ADD and SQRT bands COINCIDE at sigma = 0.5.  The additive law",
          flush=True)
    print("  a = 1 - sigma gives a = 1/2 there, which is numerically identical",
          flush=True)
    print("  to square-root cancellation.  A SQRT verdict at sigma = 0.5 is NOT",
          flush=True)
    print("  evidence of cancellation.  sigma = 0 is the DISCRIMINATING row:",
          flush=True)
    print("  additive predicts rho = 1.0 there and sqrt-cancellation predicts",
          flush=True)
    print(f"  rho = {args.sqrt_landmark:.8f}, which the rule can separate.",
          flush=True)
    print("!" * 78, flush=True)

    print(f"\n  sieving primes to {args.pmax}...", flush=True)
    primes = sieve_primes(args.pmax)
    n_primes = int(len(primes))
    print(f"  {n_primes} primes, largest = {int(primes[-1])}", flush=True)

    ladder_all = [args.ladder_base * (2 ** k) for k in range(args.ladder_rungs)]
    ladder = [N for N in ladder_all if 2 * N <= n_primes]
    print(f"  ladder requested : {ladder_all}", flush=True)
    print(f"  ladder kept      : {ladder}  ({len(ladder)} of "
          f"{len(ladder_all)} rungs, 2N <= n_primes)", flush=True)
    if not ladder:
        print("  ERROR: no ladder rung survives; raise --pmax.", flush=True)
        ladder_top = None
    else:
        ladder_top = ladder[-1]
        idx_used = 2 * ladder_top - 1
        print(f"  largest prime index used : {idx_used} "
              f"(value {int(primes[idx_used])})", flush=True)
    print(f"  sigmas: {sigmas}", flush=True)
    print(f"  t vals: {tvals}", flush=True)
    print(f"  eps = {args.eps} ; SETTLED over the last {args.settle_last} rho ; "
          f"one-outlier pool = {args.outlier_pool}", flush=True)

    # ---------------- validation gate ------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("VALIDATION GATE — direct block sum vs the O9-style difference",
          flush=True)
    print("-" * 78, flush=True)
    print(f"  sigma = {args.gate_sigma}, t = {args.gate_t}; requires agreement "
          f"to >= {args.gate_sigfigs:g} significant figures", flush=True)
    print(f"  {'N':>8} {'|direct|':>22} {'|difference|':>22} "
          f"{'rel err':>12} {'sig figs':>10}", flush=True)
    gate_rows = []
    gate_passed = True
    for N in gate_ladder:
        if 2 * N > n_primes:
            print(f"  {N:>8} {'skipped — 2N > n_primes':>60}", flush=True)
            gate_rows.append({"N": N, "skipped": True})
            continue
        d_direct = block_delta(primes, N, args.gate_sigma, args.gate_t)
        d_diff = (prime_sum(primes, 2 * N, args.gate_sigma, args.gate_t)
                  - prime_sum(primes, N, args.gate_sigma, args.gate_t))
        rel = _safe_div(abs(d_direct - d_diff), abs(d_direct))
        sig = (-math.log10(rel) if math.isfinite(rel) and rel > 0
               else float("inf") if rel == 0.0 else float("nan"))
        ok = math.isfinite(rel) and rel <= gate_tol
        if rel == 0.0:
            ok = True
        gate_passed = gate_passed and ok
        gate_rows.append({
            "N": N, "skipped": False,
            "abs_direct": abs(d_direct), "abs_difference": abs(d_diff),
            "direct_re": d_direct.real, "direct_im": d_direct.imag,
            "difference_re": d_diff.real, "difference_im": d_diff.imag,
            "rel_err": rel,
            "sig_figs": None if not math.isfinite(sig) else sig,
            "passed": bool(ok),
        })
        sig_txt = "exact" if not math.isfinite(sig) else f"{sig:>10.2f}"
        print(f"  {N:>8} {abs(d_direct):>22.15g} {abs(d_diff):>22.15g} "
              f"{rel:>12.3e} {sig_txt:>10}", flush=True)
    if gate_passed:
        print("\n  GATE PASSED — direct and differenced block sums agree.",
              flush=True)
    else:
        print("\n  " + "*" * 70, flush=True)
        print("  *** GATE FAILED *** direct block sum disagrees with the "
              "O9-style", flush=True)
        print("  *** difference beyond tolerance. Every number below is "
              "suspect.", flush=True)
        print("  " + "*" * 70, flush=True)

    # ---------------- the block-ratio series ------------------------------
    print("\n" + "-" * 78, flush=True)
    print("BLOCK RATIO LADDER — one table per (sigma, t)", flush=True)
    print("-" * 78, flush=True)

    rows = []
    series = []
    for sg in sigmas:
        for t in tvals:
            print(f"\n  sigma = {sg:g}   t = {t:g}", flush=True)
            print(f"  {'N':>8} {'|Delta_N|':>18} {'r_N=|D|/N':>16} "
                  f"{'rho=r_N/r_N/2':>16} {'a=1+log2(rho)':>15}", flush=True)
            prev_r = None
            rhos = []
            srows = []
            for N in ladder:
                d = block_delta(primes, N, sg, t)
                ad = abs(d)
                r = _safe_div(ad, N)
                rho = _safe_div(r, prev_r) if prev_r is not None else None
                a = (1.0 + math.log2(rho)
                     if rho is not None and math.isfinite(rho) and rho > 0
                     else None)
                srows.append({"N": N, "absD": ad, "r": r, "rho": rho, "a": a})
                rows.append({
                    "sigma": sg, "t": t, "N": N,
                    "absD": ad, "r": r, "rho": rho, "a": a,
                    "absD_over_sqrtN": _safe_div(ad, math.sqrt(N)),
                })
                if rho is not None:
                    rhos.append((N, rho))
                rho_txt = "—" if rho is None else f"{rho:>16.8f}"
                a_txt = "—" if a is None else f"{a:>15.6f}"
                print(f"  {N:>8} {ad:>18.10g} {r:>16.10g} {rho_txt:>16} "
                      f"{a_txt:>15}", flush=True)
                prev_r = r

            dec = decide(rhos, args.eps, args.add_landmark, args.sqrt_landmark,
                         args.settle_last, args.outlier_pool)
            mr = dec["mean_rho"]
            a_mean = (1.0 + math.log2(mr)
                      if mr is not None and math.isfinite(mr) and mr > 0
                      else None)
            dec["a_from_mean_rho"] = a_mean
            rec = {"sigma": sg, "t": t, "n_rungs": len(ladder),
                   "n_rho": len(rhos), "decision": dec, "rungs": srows}
            series.append(rec)

            mr_txt = "—" if mr is None or not math.isfinite(mr) else f"{mr:.8f}"
            sp_txt = ("—" if dec["spread"] is None
                      or not math.isfinite(dec["spread"])
                      else f"{dec['spread']:.8f}")
            a_txt = "—" if a_mean is None else f"{a_mean:.6f}"
            print(f"    VERDICT: {dec['verdict']:<22} "
                  f"strict={dec['verdict_strict']:<8} "
                  f"mean rho={mr_txt}  spread={sp_txt}  a={a_txt}", flush=True)
            if dec["outlier_excluded_rung"] is not None:
                print(f"    one-outlier rule fired: excluded rung "
                      f"N={dec['outlier_excluded_rung']} "
                      f"(candidates {dec['outlier_candidate_rungs']}); "
                      f"landmark class of the remainder = "
                      f"{dec['landmark_class']}", flush=True)
            if abs(sg - 0.5) < 1e-12 and dec["verdict"] == "SQRT":
                print("    NOTE: at sigma = 0.5 the ADD and SQRT bands "
                      "coincide in law;", flush=True)
                print("          this SQRT is NOT evidence of cancellation.",
                      flush=True)

    # ---------------- verdict summary -------------------------------------
    print("\n" + "-" * 78, flush=True)
    print("VERDICT MATRIX", flush=True)
    print("-" * 78, flush=True)
    hdr = f"  {'sigma':>7} " + "".join(f"{('t='+f'{t:g}'):>22}" for t in tvals)
    print(hdr, flush=True)
    print("  " + "-" * (len(hdr) - 2), flush=True)
    for sg in sigmas:
        row = f"  {sg:>7.2f} "
        for t in tvals:
            v = next(s["decision"]["verdict"] for s in series
                     if s["sigma"] == sg and s["t"] == t)
            row += f"{v:>22}"
        mark = "   <- DISCRIMINATING ROW" if abs(sg) < 1e-12 else ""
        mark = ("   <- ADD/SQRT bands coincide here"
                if abs(sg - 0.5) < 1e-12 else mark)
        print(row + mark, flush=True)

    counts = {}
    for s in series:
        v = s["decision"]["verdict"]
        counts[v] = counts.get(v, 0) + 1
    print("\n  verdict counts over "
          f"{len(series)} series:", flush=True)
    for k in sorted(counts):
        print(f"    {k:<22} {counts[k]:>3}", flush=True)

    outlier_rungs = {}
    for s in series:
        er = s["decision"]["outlier_excluded_rung"]
        if er is not None:
            outlier_rungs[er] = outlier_rungs.get(er, 0) + 1
    if outlier_rungs:
        print("\n  one-outlier exclusions by rung:", flush=True)
        for k in sorted(outlier_rungs):
            print(f"    N={k:<10} {outlier_rungs[k]:>3}", flush=True)
    else:
        print("\n  one-outlier rule never fired.", flush=True)

    # ---------------- exponent vs the additive law ------------------------
    print("\n" + "-" * 78, flush=True)
    print("MEAN EXPONENT a BY SIGMA, AGAINST THE ADDITIVE LAW a = 1 - sigma",
          flush=True)
    print("-" * 78, flush=True)
    print("  finite-N additive law: a_eff = 1 - sigma - sigma/log(N)", flush=True)
    if ladder_top:
        print(f"  (log N at the top rung N={ladder_top}: "
              f"{math.log(ladder_top):.6f})", flush=True)
    print(f"  {'sigma':>7} {'n settled':>10} {'mean a':>12} "
          f"{'1 - sigma':>12} {'deviation':>12} {'-sigma/logN':>13} "
          f"{'n settled+out':>14} {'mean a incl':>12}", flush=True)
    by_sigma = []
    log_top = math.log(ladder_top) if ladder_top else float("nan")
    strict_set = {"ADD", "SQRT", "OTHER"}
    for sg in sigmas:
        strict_as = [s["decision"]["a_from_mean_rho"] for s in series
                     if s["sigma"] == sg
                     and s["decision"]["verdict"] in strict_set
                     and s["decision"]["a_from_mean_rho"] is not None]
        incl_as = [s["decision"]["a_from_mean_rho"] for s in series
                   if s["sigma"] == sg
                   and s["decision"]["verdict"] in strict_set
                   | {"SETTLED-WITH-OUTLIER"}
                   and s["decision"]["a_from_mean_rho"] is not None]
        mean_a = (sum(strict_as) / len(strict_as)) if strict_as else None
        mean_a_incl = (sum(incl_as) / len(incl_as)) if incl_as else None
        pred = 1.0 - sg
        dev = (mean_a - pred) if mean_a is not None else None
        corr = _safe_div(-sg, log_top)
        by_sigma.append({
            "sigma": sg,
            "n_settled_strict": len(strict_as),
            "mean_a_settled_strict": mean_a,
            "n_settled_incl_outlier": len(incl_as),
            "mean_a_settled_incl_outlier": mean_a_incl,
            "additive_prediction_a": pred,
            "deviation_from_additive": dev,
            "loglog_correction_top_rung": corr,
            "top_rung_N": ladder_top,
        })
        ma = "—" if mean_a is None else f"{mean_a:>12.6f}"
        dv = "—" if dev is None else f"{dev:>12.6f}"
        mi = "—" if mean_a_incl is None else f"{mean_a_incl:>12.6f}"
        print(f"  {sg:>7.2f} {len(strict_as):>10} {ma:>12} {pred:>12.6f} "
              f"{dv:>12} {corr:>13.6f} {len(incl_as):>14} {mi:>12}", flush=True)
    print("\n  Compare 'deviation' against '-sigma/logN': if they are the same",
          flush=True)
    print("  size, the shortfall below a = 1 - sigma is the finite-N log-log",
          flush=True)
    print("  correction, not cancellation.", flush=True)

    # ---------------- read the result -------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("READ THE RESULT", flush=True)
    print("=" * 78, flush=True)
    print("  rho is the exponent, not a fit of one.  a = 1 + log2(rho).",
          flush=True)
    print("  sigma = 0 is the only row where ADD and SQRT are distinguishable;",
          flush=True)
    print("  at sigma = 0.5 the additive law itself predicts a = 1/2, so a SQRT",
          flush=True)
    print("  label there carries no cancellation content.", flush=True)
    print(f"  validation gate: {'PASSED' if gate_passed else 'FAILED'}",
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
                "largest_prime": int(primes[-1]) if n_primes else None,
                "ladder_base": args.ladder_base,
                "ladder_rungs_requested": args.ladder_rungs,
                "ladder_all": ladder_all,
                "ladder": ladder,
                "ladder_top": ladder_top,
                "largest_prime_index_used": (2 * ladder_top - 1
                                             if ladder_top else None),
                "largest_prime_value_used": (int(primes[2 * ladder_top - 1])
                                             if ladder_top else None),
                "sigmas": sigmas,
                "tvals": tvals,
                "eps": args.eps,
                "add_landmark": args.add_landmark,
                "sqrt_landmark": args.sqrt_landmark,
                "settle_last": args.settle_last,
                "outlier_pool": args.outlier_pool,
                "gate_sigma": args.gate_sigma,
                "gate_t": args.gate_t,
                "gate_ladder": gate_ladder,
                "gate_sigfigs_required": args.gate_sigfigs,
                "gate_rel_tolerance": gate_tol,
                "rho_label_convention": "rho at row N means r_N / r_(N/2)",
                "delta_definition": ("direct numpy sum over primes[N:2N] of "
                                     "p^(-sigma)*(cos(t log p) - i sin(t log p))"),
                "fit_free": True,
                "precision": "float64",
            },
            "constants": {
                "additive_law": "a = 1 - sigma",
                "finite_N_additive_law": "a_eff = 1 - sigma - sigma/log(N)",
                "rho_additive": 1.0,
                "rho_sqrt_cancellation": 0.70710678,
                "exponent_relation": "rho = 2^(a-1); a = 1 + log2(rho)",
                "band_coincidence_sigma": 0.5,
                "discriminating_sigma": 0.0,
                "band_coincidence_note": (
                    "ADD and SQRT bands coincide at sigma=0.5 because the "
                    "additive law a=1-sigma also gives a=1/2 there; sigma=0 "
                    "is the discriminating row"),
            },
            "summary": {
                "gate_passed": bool(gate_passed),
                "gate": gate_rows,
                "n_series": len(series),
                "verdict_counts": counts,
                "outlier_exclusions_by_rung": {str(k): v for k, v
                                               in outlier_rungs.items()},
                "by_sigma": by_sigma,
                "series": [
                    {"sigma": s["sigma"], "t": s["t"],
                     "n_rungs": s["n_rungs"], "n_rho": s["n_rho"],
                     "decision": s["decision"]}
                    for s in series
                ],
            },
            "rows": rows,
        }
        _write_results(payload, out_path)


if __name__ == "__main__":
    main()
