#!/usr/bin/env python3
"""O75 — EXPLORATORY. No prereg, no verdict.

The crossing-slope law, met with data it has never seen.

WHY THIS EXISTS. Entry 36 derived, AFTER seeing the data and labelled
as such, the law: turnaround depth grows linearly in r with slope
ln b / (2 ln ratio), where ratio = |1 - b^(-1/2 - i gamma_1)| /
((b-1)/b). It fit the two bases it was derived on — b=2 to 6% (slope
0.3031 vs 0.2862), b=3 to 15% (0.7353 vs 0.6406) — and the open
NOTEPAD line since 2026-08-17 reads: "needs an out-of-sample test".
Every integer base 4..9 is unreachable (slope >= 1 on triangular
support, entry 36), so the fresh data is NON-INTEGER bases between
and around the two fit points: b = 11/5, 12/5, 13/5, 14/5, 17/5
(2.2, 2.4, 2.6, 2.8, 3.4), none of which existed anywhere in the tree
when the law was written.

CONSTRUCTION. Per base: N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))),
floors exact via integer arithmetic on the rational base (num^r //
den^r), pi exact via primecountpy; backward-difference triangle; the
turnaround and sign-change measurement copied VERBATIM from
O33_base_ladder_crossing.py measure_row (argmin |cell|, risen-for-
--margin depths, censoring), pairs from rows r >= --min-row, OLS
slope of depth on r — O33's regression, O33's defaults.

GATE. Anchor bases 2 and 3 (tables from pi2n/pi3n caches, r <= 32 to
match entry 36's window) must reproduce entry 36's measured slopes
0.3031 and 0.7353 and its derived predictions 0.2862 and 0.6406, or
exit 1.

Reads with: O33_base_ladder_crossing.py, notes/lab_notebook.md entry
36, pi2n_cache.json, pi3n_cache.json.

HOW IT WAS RUN
--------------
    .venv/bin/python O75_crossing_slope_oos.py
"""
import argparse
import cmath
import hashlib
import json
import math
import os
from datetime import datetime, timezone
from fractions import Fraction

import primecountpy

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "crossing_slope_oos.json")
GAMMA1 = 14.134725141734693790
GATE = {2: {"slope": 0.3031, "pred": 0.2862},
        3: {"slope": 0.7353, "pred": 0.6406}}


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def _sign(v):
    return (v > 0) - (v < 0)


def measure_row(T, r, margin):
    """O33 measure_row's sign-change and turnaround blocks, verbatim."""
    dmax = r - 1
    vals = [T[(r, d)] for d in range(0, dmax + 1)]
    sign_change = None
    last_sign = 0
    for d in range(0, dmax + 1):
        s = _sign(vals[d])
        if s == 0:
            continue
        if last_sign != 0 and s != last_sign:
            sign_change = d
            break
        last_sign = s
    absvals = [abs(v) for v in vals]
    dmin = min(range(0, dmax + 1), key=lambda d: (absvals[d], d))
    tail = absvals[dmin + 1:]
    censored = (dmax - dmin) < margin
    risen = (len(tail) >= margin
             and all(tail[k] > absvals[dmin] for k in range(margin)))
    if dmin >= 1 and risen and not censored:
        ta, ta_cens = dmin, False
    else:
        ta, ta_cens = None, bool(censored or dmin == dmax)
    return sign_change, ta, ta_cens


def ols_slope(pairs):
    if len(pairs) < 2:
        return None, None
    n = len(pairs)
    mx = sum(x for x, _ in pairs) / n
    my = sum(y for _, y in pairs) / n
    sxx = sum((x - mx) ** 2 for x, _ in pairs)
    if sxx == 0:
        return None, None
    sxy = sum((x - mx) * (y - my) for x, y in pairs)
    m = sxy / sxx
    return m, len(pairs)


def triangle(N, R):
    T = {}
    for r in range(1, R + 1):
        T[(r, 0)] = N[r]
        for d in range(1, r):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def predicted(b):
    trend = (b - 1.0) / b
    zg = abs(1 - cmath.exp((-0.5 - 1j * GAMMA1) * math.log(b)))
    ratio = zg / trend
    slope = math.log(b) / (2.0 * math.log(ratio)) if ratio > 1 else None
    return trend, zg, ratio, slope


def measure_base(N, R, min_row, margin):
    T = triangle(N, R)
    sc_pairs, ta_pairs = [], []
    for r in range(min_row, R + 1):
        sc, ta, _c = measure_row(T, r, margin)
        if sc is not None:
            sc_pairs.append((float(r), float(sc)))
        if ta is not None:
            ta_pairs.append((float(r), float(ta)))
    ta_slope, ta_n = ols_slope(ta_pairs)
    sc_slope, sc_n = ols_slope(sc_pairs)
    return ta_slope, ta_n, sc_slope, sc_n


def main():
    ap = argparse.ArgumentParser(
        description=("O75 - out-of-sample test of entry 36's crossing-"
                     "slope law on non-integer bases, gate-anchored to "
                     "the recorded b=2,3 slopes. EXPLORATORY: no prereg, "
                     "no decision rule, no verdict."))
    ap.add_argument("--bases", type=str, default="41/20,21/10,43/20,11/5,14/5,31/10,13/4",
                    help="fresh rational bases num/den (default seven "
                         "bases in the two testable windows "
                         "2.05-2.25 and 2.70-3.30; outside them the "
                         "law itself says unreachable, ratio <= 1 or "
                         "slope >= 1)")
    ap.add_argument("--xmax", type=float, default=1e14,
                    help="ladder ceiling: rows while b^r <= xmax "
                         "(default 1e14)")
    ap.add_argument("--anchor-rmax", type=int, default=32,
                    help="anchor-base top row, entry 36's window "
                         "(default 32)")
    ap.add_argument("--min-row", type=int, default=8,
                    help="O33's regression row floor (default 8)")
    ap.add_argument("--margin", type=int, default=2,
                    help="O33's turnaround margin (default 2)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))

    print("O75 — the crossing-slope law out of sample.  EXPLORATORY.")
    print(f"  law (entry 36, post-hoc there): slope = ln b / (2 ln ratio),"
          f"  ratio = |1 - b^(-1/2 - i g1)| / ((b-1)/b)")
    print(f"  turnaround semantics: O33 measure_row verbatim; min_row "
          f"{args.min_row}, margin {args.margin}\n")

    print("GATE — anchors from the caches, r <= "
          f"{args.anchor_rmax}, against entry 36's recorded numbers:")
    gate_rows = {}
    ok = True
    for b_int, cache_name in ((2, "pi2n_cache.json"),
                              (3, "pi3n_cache.json")):
        c = json.load(open(os.path.join(_HERE, cache_name)))
        R = min(args.anchor_rmax, max(int(k) for k in c))
        N = [None] + [c[str(r)] - c[str(r - 1)] for r in range(1, R + 1)]
        ta_slope, ta_n, sc_slope, sc_n = measure_base(
            N, R, args.min_row, args.margin)
        _t, _z, ratio, pred = predicted(float(b_int))
        rec = GATE[b_int]
        s_ok = ta_slope is not None and abs(ta_slope - rec["slope"]) < 5e-4
        p_ok = pred is not None and abs(pred - rec["pred"]) < 5e-4
        ok &= (s_ok and p_ok)
        gate_rows[str(b_int)] = {"measured_slope": ta_slope,
                                 "n_points": ta_n, "predicted": pred}
        print(f"   b={b_int}: measured {ta_slope:.4f} (recorded "
              f"{rec['slope']}) {'ok' if s_ok else 'FAIL'}   predicted "
              f"{pred:.4f} (recorded {rec['pred']}) "
              f"{'ok' if p_ok else 'FAIL'}   [{ta_n} points]")
    if not ok:
        print("GATE FAILED — this replication does not reproduce entry "
              "36's slopes; nothing further is trustworthy.")
        raise SystemExit(1)
    print("   gate PASSED\n")

    print("OUT OF SAMPLE — fresh bases, floors exact, pi via primecount:")
    print(f"   {'b':>6} {'R':>4} {'pred slope':>11} {'measured':>9} "
          f"{'n':>3} {'rel err':>8}   {'sign-chg slope':>14}")
    rows = {}
    for spec in args.bases.split(","):
        frac = Fraction(spec)
        b = float(frac)
        num, den = frac.numerator, frac.denominator
        R = int(math.log(args.xmax) / math.log(b))
        N = [None]
        prev = 0
        for r in range(1, R + 1):
            cur = primecountpy.prime_pi(num ** r // den ** r)
            N.append(cur - prev)
            prev = cur
        ta_slope, ta_n, sc_slope, sc_n = measure_base(
            N, R, args.min_row, args.margin)
        trend, zg, ratio, pred = predicted(b)
        rel = (None if (ta_slope is None or pred is None)
               else (ta_slope - pred) / pred)
        if pred is None or pred >= 1:
            print(f"   {b:>6.2f} {R:>4} {'unreachable':>11} — ratio "
                  f"{ratio:.3f}; the law makes no testable prediction "
                  f"here")
            rows[spec] = {"b": b, "R": R, "trend": trend,
                          "zero_gain": zg, "ratio": ratio,
                          "predicted_slope": pred,
                          "reachable": False}
            continue
        print(f"   {b:>6.2f} {R:>4} {pred:>11.4f} "
              f"{ta_slope if ta_slope is not None else float('nan'):>9.4f} "
              f"{ta_n or 0:>3} "
              f"{('%+.1f%%' % (100 * rel)) if rel is not None else '—':>8}"
              f"   {sc_slope if sc_slope is not None else float('nan'):>14.4f}")
        rows[spec] = {"b": b, "R": R, "trend": trend, "zero_gain": zg,
                      "ratio": ratio, "predicted_slope": pred,
                      "measured_turnaround_slope": ta_slope,
                      "n_turnaround_points": ta_n,
                      "measured_sign_change_slope": sc_slope,
                      "n_sign_change_points": sc_n,
                      "relative_error": rel}

    print("\n  entry 36's in-sample errors were +5.9% (b=2) and +14.8% "
          "(b=3); the table above is the law meeting data that did not "
          "shape it.")

    if not args.no_json:
        payload = {
            "schema_version": "1", "script": "O75_crossing_slope_oos.py",
            "generated_utc": datetime.now(timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "bases": args.bases, "xmax": args.xmax,
                       "anchor_rmax": args.anchor_rmax,
                       "min_row": args.min_row, "margin": args.margin,
                       "gamma1": GAMMA1,
                       "semantics": "O33 measure_row verbatim; OLS of "
                                    "turnaround depth on r, rows >= "
                                    "min_row, non-censored"},
            "gate": gate_rows, "rows": rows}
        try:
            with open(args.out, "w") as f:
                json.dump(payload, f, indent=2)
            print(f"\n  results written to {args.out}")
        except Exception as exc:
            print(f"\n  WARNING: could not write results JSON: {exc}")


if __name__ == "__main__":
    main()
