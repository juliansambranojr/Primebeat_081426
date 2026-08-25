#!/usr/bin/env python3
"""O73 — EXPLORATORY. No prereg, no verdict.

The Weil-form balance across the mollifier grid, and the per-prime
breakdown on the corrected implementation.

WHY THIS EXISTS. Entry 40 closed with two carried caveats, both open
NOTEPAD lines since 2026-08-17: "the mollifier is not canonical — W and
k are free and the numbers move with them, so nothing here is yet a
parameter-independent statement"; and the only per-prime breakdown on
record comes from the buggy first implementation, whose docstring
forbids citing its numbers. This script answers both.

WHAT IS MEASURED. O37_weil_form_balance.py's construction, replicated
verbatim (same h, T, B-spline kernel, prime loop, archimedean
quadrature and node layout, spectral sum over zeros600.json), with two
extensions:

  K-GENERAL TAILS. O37's analytic tails hardcode K = 2: mean(sinc^4)
  = 3/8 and decay (Wt)^(-4). Both tails here use the general constant
  binomial(2K, K)/4^K and power (Wt)^(-2K), which reduce to 3/8 and
  (Wt)^(-4) at K = 2 — the anchor setting is bit-compatible.

  PER-PRIME BREAKDOWN. The prime term grouped by p (summed over prime
  powers m), printed for the anchor setting and stored per grid
  setting in the JSON.

SANITY GATE (O68 pattern). Before the sweep, the anchor setting
(b=2, N=7, W=0.05, K=2, Tc=3000) must reproduce entry 40's recorded
numbers — prime term -1435.9137987828, ARITHMETIC 2644.2756560191,
SPECTRAL 600-pair sum 2644.2585543549 — to 1e-9 relative, or the
script exits 1 and prints nothing further. The replication is only
trusted because this gate ties it to the recorded run.

THE QUESTION. Entry 40's balance at the anchor was relative 5.7e-7.
Does that balance survive the grid W in {0.02, 0.05, 0.1, 0.2} x
K in {2, 3}? Each setting prints both sides and the relative
difference; the table is the answer. This script states numbers;
interpretation is not its job.

Reads with: O37_weil_form_balance.py, O37_weil_form_on_stencil.py,
notes/lab_notebook.md entries 39, 40; zeros600.json (dps-25).

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O73_weil_mollifier_sweep.py
"""
import argparse
import datetime
import hashlib
import json
import os

from mpmath import (mp, mpf, mpc, log, exp, sinh, re, digamma, pi, inf,
                    quad, binomial, factorial)
from sympy import primerange

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR,
                                "weil_mollifier_sweep.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")

# Entry 40's recorded anchor numbers (b=2, N=7, W=0.05, K=2, Tc=3000).
GATE_PRIME = mpf('-1435.9137987828')
GATE_ARITH = mpf('2644.2756560191')
GATE_SPECT = mpf('2644.2585543549')
GATE_RTOL = mpf('1e-9')


def _code_version():
    with open(os.path.abspath(__file__), "rb") as f:
        return hashlib.sha256(f.read()).hexdigest()


def _write_results(payload, out_path):
    try:
        with open(out_path, "w") as fh:
            json.dump(payload, fh, indent=2)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: "
              f"{exc}", flush=True)


def balance(b_int, N, W, K, Tc, Z):
    """One full balance computation. Verbatim O37_weil_form_balance
    construction; tails K-general (binomial(2K,K)/4^K, (Wt)^(-2K))."""
    b = mpf(b_int)
    LB = log(b)
    NK = 2 * K
    COEF = {}
    for j in range(N + 1):
        for k in range(N + 1):
            COEF[k - j] = COEF.get(k - j, mpf(0)) \
                + (-1) ** (j + k) * binomial(N, j) * binomial(N, k) \
                * b ** (-k)
    a0 = COEF[0]

    def h(s):
        return (1 - b ** (-s)) ** N * (1 - b ** (s - 1)) ** N

    def T(s):
        z = W * (s - mpf('0.5'))
        return mpf(1) if z == 0 else (sinh(z) / z) ** (2 * K)

    def H(s):
        return h(s) * T(s)

    def bspl(x, n):
        if x <= 0 or x >= n:
            return mpf(0)
        return sum((-1) ** k * binomial(n, k) * (x - k) ** (n - 1)
                   for k in range(int(x) + 1)) / factorial(n - 1)

    def Kern(v):
        return bspl(v / (2 * W) + NK / mpf(2), NK) / (2 * W)

    def f(u):
        return sum(c * b ** (mpf(m) / 2) * Kern(u - m * LB)
                   for m, c in COEF.items())

    SUP = N * LB + NK * W
    prime = mpf(0)
    per_prime = {}
    for p in primerange(2, int(exp(SUP)) + 1):
        contrib = mpf(0)
        m = 1
        while m * log(p) <= SUP:
            contrib += log(p) * mpf(p) ** (-mpf(m) / 2) * 2 * f(m * log(p))
            m += 1
        if contrib != 0:
            per_prime[int(p)] = contrib
        prime += contrib

    tail_const = binomial(2 * K, K) / mpf(4) ** K   # 3/8 at K=2

    def integ(t):
        return re(H(mpc(mpf('0.5'), t))) \
            * (re(digamma(mpf('0.25') + mpc(0, t) / 2)) - log(pi))

    nn = int(Tc / mpf('1.2'))
    nodes = [mpf(-Tc) + 2 * mpf(Tc) * i / nn for i in range(nn + 1)]
    arch_main = quad(integ, nodes) / (2 * pi)
    arch_tail = 2 * quad(
        lambda t: a0 * tail_const / (W * t) ** (2 * K)
        * (log(t / 2) - log(pi)), [Tc, 10 * Tc, inf]) / (2 * pi)
    arch = arch_main + arch_tail
    rhs = H(mpf(0)) + H(mpf(1)) - prime + arch

    sp = sum(2 * re(H(mpc(mpf('0.5'), g))) for g in Z)
    sptail = quad(
        lambda t: 2 * a0 * tail_const / (W * t) ** (2 * K)
        * log(t / (2 * pi)) / (2 * pi), [Z[-1], 10 * Z[-1], inf])

    return {"prime": prime, "arch_main": arch_main, "arch_tail": arch_tail,
            "arith": rhs, "spectral": sp, "sp_tail": sptail,
            "support": SUP, "n_primes_contributing": len(per_prime),
            "per_prime": per_prime}


def main():
    ap = argparse.ArgumentParser(
        description=("O73 - Weil-form balance across the mollifier grid "
                     "(W x K), K-general tails, per-prime breakdown, "
                     "sanity-gated to entry 40's anchor. EXPLORATORY: "
                     "no prereg, no decision rule, no verdict."))
    ap.add_argument("--base", type=int, default=2,
                    help="ladder base b (default 2)")
    ap.add_argument("--n", type=int, default=7,
                    help="difference order N (default 7)")
    ap.add_argument("--w-grid", type=str, default="0.02,0.05,0.1,0.2",
                    help="mollifier half-widths W to sweep "
                         "(default 0.02,0.05,0.1,0.2)")
    ap.add_argument("--k-grid", type=str, default="2,3",
                    help="mollifier half-orders K to sweep (default 2,3; "
                         "K=1 is numerically too weak, entry 40)")
    ap.add_argument("--dps", type=int, default=20,
                    help="mpmath precision (default 20)")
    ap.add_argument("--tc", type=int, default=3000,
                    help="archimedean cutoff (default 3000)")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="zeta-zero JSON (default _HERE/zeros600.json, "
                         "dps-25 precision)")
    ap.add_argument("--breakdown-top", type=int, default=30,
                    help="per-prime rows printed for the anchor setting "
                         "(default 30)")
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

    mp.dps = args.dps
    Ws = [mpf(s) for s in args.w_grid.split(",")]
    Ks = [int(s) for s in args.k_grid.split(",")]
    Z = [mpf(x) for x in json.load(open(args.zeros))]

    print("O73 — Weil-form balance across the mollifier grid.  "
          "EXPLORATORY.")
    print(f"  b = {args.base}   N = {args.n}   Tc = {args.tc}   "
          f"dps = {args.dps}   zeros = {len(Z)} pairs to "
          f"{mp.nstr(Z[-1], 8)}")
    print(f"  grid: W in {args.w_grid}   K in {args.k_grid}\n")

    print("SANITY GATE — anchor (W=0.05, K=2) against entry 40's "
          "recorded numbers:")
    anchor = balance(args.base, args.n, mpf('0.05'), 2, args.tc, Z)
    checks = [("prime term", anchor["prime"], GATE_PRIME),
              ("ARITHMETIC", anchor["arith"], GATE_ARITH),
              ("SPECTRAL(600)", anchor["spectral"], GATE_SPECT)]
    gate_ok = True
    for name, got, want in checks:
        rel = abs((got - want) / want)
        ok = rel < GATE_RTOL
        gate_ok &= ok
        print(f"   {name:>14}: got {mp.nstr(got, 14)}   recorded "
              f"{mp.nstr(want, 14)}   rel {mp.nstr(rel, 3)}   "
              f"{'ok' if ok else 'FAIL'}")
    if not gate_ok:
        print("SANITY GATE FAILED — replication does not reproduce the "
              "recorded anchor; nothing further is trustworthy.")
        raise SystemExit(1)
    print("   gate PASSED\n")

    print("PER-PRIME BREAKDOWN — anchor setting, corrected "
          "implementation (contribution to the prime term, grouped by "
          "p over prime powers):")
    items = sorted(anchor["per_prime"].items(),
                   key=lambda kv: -abs(kv[1]))
    total = anchor["prime"]
    print(f"   {'p':>6} {'contribution':>18} {'share of total':>15}")
    for p, c in items[:args.breakdown_top]:
        print(f"   {p:>6} {mp.nstr(c, 12):>18} {mp.nstr(c / total, 4):>15}")
    print(f"   {anchor['n_primes_contributing']} primes contribute; "
          f"support |log x| <= {mp.nstr(anchor['support'], 6)}\n")

    print("THE SWEEP:")
    print(f"   {'W':>6} {'K':>3} {'n_p':>5} {'prime term':>16} "
          f"{'ARITHMETIC':>16} {'SPECTRAL+tail':>16} {'rel diff':>12}")
    rows = {}
    for K in Ks:
        for W in Ws:
            if (W, K) == (mpf('0.05'), 2):
                r = anchor
            else:
                r = balance(args.base, args.n, W, K, args.tc, Z)
            spt = r["spectral"] + r["sp_tail"]
            rel = (r["arith"] - spt) / r["arith"]
            print(f"   {mp.nstr(W, 3):>6} {K:>3} "
                  f"{r['n_primes_contributing']:>5} "
                  f"{mp.nstr(r['prime'], 12):>16} "
                  f"{mp.nstr(r['arith'], 12):>16} "
                  f"{mp.nstr(spt, 12):>16} {mp.nstr(rel, 4):>12}",
                  flush=True)
            rows[f"W={mp.nstr(W, 6)},K={K}"] = {
                "W": float(W), "K": K,
                "support": float(r["support"]),
                "n_primes_contributing": r["n_primes_contributing"],
                "prime_term": float(r["prime"]),
                "arch_main": float(r["arch_main"]),
                "arch_tail": float(r["arch_tail"]),
                "arithmetic": float(r["arith"]),
                "spectral_600": float(r["spectral"]),
                "spectral_tail": float(r["sp_tail"]),
                "relative_difference": float(rel),
                "per_prime": {str(p): float(c)
                              for p, c in sorted(r["per_prime"].items())},
            }

    if not args.no_json:
        _write_results({
            "schema_version": "1",
            "script": "O73_weil_mollifier_sweep.py",
            "generated_utc": datetime.datetime.now(
                datetime.timezone.utc).isoformat(),
            "exploratory": True, "prereg": None,
            "params": {"code_version": _code_version(),
                       "base": args.base, "n": args.n,
                       "w_grid": [float(w) for w in Ws], "k_grid": Ks,
                       "dps": args.dps, "tc": args.tc,
                       "zeros_path": args.zeros, "n_zero_pairs": len(Z),
                       "tail_constant": "binomial(2K,K)/4^K, power "
                                        "(Wt)^(-2K); reduces to O37's "
                                        "3/8, (Wt)^(-4) at K=2",
                       "sanity_gate": "anchor (0.05, 2) vs entry 40's "
                                      "recorded prime/ARITHMETIC/SPECTRAL "
                                      "at 1e-9 relative"},
            "rows": rows}, args.out)


if __name__ == "__main__":
    main()
