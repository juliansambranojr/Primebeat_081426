#!/usr/bin/env python3
"""
O41 — the rank read off the symbol evaluated at s = 0.

Reads with: papers/convergence.md, O40_elliptic_symbol_zeros.py

STATUS: EXPLORATORY. No prereg, no decision rule, no verdict — see
CLAUDE.md § Prereg discipline.

PROVENANCE: written 2026-08-18.

WHAT THIS MEASURES
  The reciprocal local factor 1 - a_p p^-s + p^(1-2s) evaluated at s = 0 is
        1 - a_p + p  =  #E(F_p),
  the point count. The corresponding evaluation for zeta is 1 - b^0 = 0 —
  which is exactly why the backward difference annihilates constants, why
  Delta^(d+1) kills every polynomial of degree <= d, and why H(0) = H(1) = 0
  for the Weil test function in O37.

  Birch and Swinnerton-Dyer's 1965 numerical observation is that
        prod_{p <= X} #E(F_p)/p  ~  C (log X)^r
  with r the rank. So the quantity that vanishes identically for zeta is the
  quantity whose product carries the rank for an elliptic curve.

  This script computes that product at several cutoffs and fits the exponent
  by least squares on log(product) against log(log X).

  This reproduces a known observation. It is not evidence for the BSD
  conjecture and does not touch it. The product converges slowly; the fitted
  exponent moves with the fitting range by roughly +/- 0.07 at these cutoffs.
  The separation between ranks 0, 1 and 2 is unambiguous; the third decimal
  is not meaningful.

HOW IT WAS RUN
  .venv/bin/python O41_bsd_rank_product.py
  (all defaults; --curve, --cutoffs, --out, --out-csv, --no-json, --no-csv)

REQUIREMENTS: sympy. Curve ranks are LMFDB labels, quoted not computed.
"""
import argparse, csv, json, math, os, hashlib, datetime
from sympy import primerange

_HERE = os.path.dirname(os.path.abspath(__file__))

CURVES = {                                       # (a1,a2,a3,a4,a6, conductor, rank)
    "11a1":  (0, -1, 1, -10, -20, 11,  0),
    "37a1":  (0,  0, 1,  -1,   0, 37,  1),
    "389a1": (0,  1, 1,  -2,   0, 389, 2),
}


def npts(coeffs, p):
    """#E(F_p) including the point at infinity, via Legendre symbols."""
    a1, a2, a3, a4, a6 = coeffs[:5]
    b2 = a1 * a1 + 4 * a2
    b4 = 2 * a4 + a1 * a3
    b6 = a3 * a3 + 4 * a6
    n, h = 1, (p - 1) // 2
    for x in range(p):
        f = (4 * x ** 3 + b2 * x * x + 2 * b4 * x + b6) % p
        n += 1 if f == 0 else (2 if pow(f, h, p) == 1 else 0)
    return n


def fit_slope(xs, ys):
    m = len(xs); sx = sum(xs); sy = sum(ys)
    return (m * sum(a * b for a, b in zip(xs, ys)) - sx * sy) / \
           (m * sum(a * a for a in xs) - sx * sx)


def code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap.add_argument("--curve", action="append", choices=sorted(CURVES))
    ap.add_argument("--cutoffs", default="100,300,1000,3000,10000,30000")
    ap.add_argument("--out", default=os.path.join(_HERE, "results",
                                                  "bsd_rank_product.json"))
    ap.add_argument("--out-csv", default=os.path.join(_HERE, "results",
                                                      "bsd_rank_product.csv"))
    ap.add_argument("--no-json", action="store_true")
    ap.add_argument("--no-csv", action="store_true")
    args = ap.parse_args()
    labels = args.curve or sorted(CURVES)
    XS = [int(t) for t in args.cutoffs.split(",")]

    print("prod_{p<=X} #E(F_p)/p  ~  C (log X)^r     [Birch & Swinnerton-Dyer 1965]")
    print(f"{'curve':>8}" + "".join(f"{X:>11}" for X in XS) +
          f"{'fitted r':>10}{'true r':>8}")
    rows, summary = [], {}
    for lab in labels:
        c = CURVES[lab]
        N, rank = c[5], c[6]
        counts = {p: npts(c, p) for p in primerange(2, XS[-1] + 1) if N % p}
        vals = []
        for X in XS:
            pr = 1.0
            for p, n in counts.items():
                if p <= X:
                    pr *= n / p
            vals.append(pr)
            rows.append(dict(curve=lab, true_rank=rank, cutoff=X,
                             product=pr, n_good_primes=sum(1 for p in counts if p <= X)))
        slope = fit_slope([math.log(math.log(X)) for X in XS],
                          [math.log(v) for v in vals])
        summary[lab] = dict(true_rank=rank, fitted_r=slope,
                            products=dict(zip(map(str, XS), vals)))
        print(f"{lab:>8}" + "".join(f"{v:>11.4f}" for v in vals) +
              f"{slope:>10.3f}{rank:>8}")

    if not args.no_json:
        os.makedirs(os.path.dirname(args.out), exist_ok=True)
        with open(args.out, "w") as fh:
            json.dump(dict(
                schema_version="1", script=os.path.basename(__file__),
                generated_utc=datetime.datetime.now(
                    datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
                params=dict(curves=labels, cutoffs=XS,
                            code_version=code_version()),
                constants=dict(
                    identity="#E(F_p) = 1 - a_p + p = reciprocal local factor at s = 0",
                    zeta_contrast="zeta's symbol at s = 0 is 1 - b^0 = 0",
                    observation="Birch & Swinnerton-Dyer 1965, reproduced not discovered",
                    caveat="product converges slowly; fitted r moves ~+/-0.07 with range"),
                summary=summary, rows=rows), fh, indent=2)
        print("results written to", args.out)

    if not args.no_csv:
        os.makedirs(os.path.dirname(args.out_csv), exist_ok=True)
        with open(args.out_csv, "w", newline="") as fh:
            w = csv.DictWriter(fh, fieldnames=list(rows[0]))
            w.writeheader(); w.writerows(rows)
        print("csv written to", args.out_csv)


if __name__ == "__main__":
    main()
