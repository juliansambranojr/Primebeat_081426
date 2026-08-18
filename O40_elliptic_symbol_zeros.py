#!/usr/bin/env python3
"""
O40 — where the reciprocal local factor's zeros sit, for an elliptic curve.

Reads with: papers/Euler-Factor-Chain.md (A1-A4), papers/convergence.md

STATUS: EXPLORATORY. No prereg, no decision rule, no verdict — see
CLAUDE.md § Prereg discipline.

PROVENANCE: written 2026-08-18. Extends the O-series construction from
zeta to an elliptic curve L-function.

WHAT THIS MEASURES
  For zeta, the backward difference on the ladder x = b^r has symbol
  (1 - b^-s), the reciprocal Euler factor, whose zeros lie at
  s = 2*pi*i*k/log b — that is, on Re(s) = 0.

  For an elliptic curve E/Q the reciprocal local factor at a good prime is
  degree 2:
        1 - a_p * p^-s + p^(1-2s)
  Substituting x = p^-s gives the quadratic 1 - a_p x + p x^2. Hasse's
  theorem gives |a_p| <= 2*sqrt(p), so the discriminant a_p^2 - 4p is
  non-positive and both roots are complex conjugates with |x| = p^(-1/2),
  i.e. Re(s) = 1/2 exactly.

  This script computes a_p by point-counting, solves the quadratic, and
  reports |x| against p^(-1/2) and the implied Re(s). Re(s) = 1/2 at every
  curve and prime is the Riemann Hypothesis for curves over finite fields
  (Hasse 1933) — a theorem. It is reproduced here, not discovered.

  a_p = p + 1 - #E(F_p), counted via the Legendre symbol on the
  completed-square form v^2 = 4x^3 + b2 x^2 + 2 b4 x + b6.

HOW IT WAS RUN
  .venv/bin/python O40_elliptic_symbol_zeros.py
  (all defaults; --curve, --pmax, --out, --no-json available)

REQUIREMENTS: sympy. Curve ranks are LMFDB labels, quoted not computed.
"""
import argparse, cmath, json, math, os, hashlib, datetime
from sympy import primerange

_HERE = os.path.dirname(os.path.abspath(__file__))

# label: (a1, a2, a3, a4, a6, conductor, rank)  — long Weierstrass form
CURVES = {
    "11a1":  (0, -1, 1, -10, -20, 11,  0),
    "37a1":  (0,  0, 1,  -1,   0, 37,  1),
    "389a1": (0,  1, 1,  -2,   0, 389, 2),
}


def ap(coeffs, p):
    """a_p = p + 1 - #E(F_p), via Legendre symbols. Good primes only."""
    a1, a2, a3, a4, a6 = coeffs[:5]
    b2 = a1 * a1 + 4 * a2
    b4 = 2 * a4 + a1 * a3
    b6 = a3 * a3 + 4 * a6
    n, h = 1, (p - 1) // 2                       # 1 for the point at infinity
    for x in range(p):
        f = (4 * x ** 3 + b2 * x * x + 2 * b4 * x + b6) % p
        n += 1 if f == 0 else (2 if pow(f, h, p) == 1 else 0)
    return p + 1 - n


def code_version():
    with open(os.path.abspath(__file__), "rb") as fh:
        return hashlib.sha256(fh.read()).hexdigest()


def main():
    ap_ = argparse.ArgumentParser(description=__doc__.split("\n")[1])
    ap_.add_argument("--curve", action="append", choices=sorted(CURVES),
                     help="repeatable; default is all three")
    ap_.add_argument("--pmax", type=int, default=50)
    ap_.add_argument("--out", default=os.path.join(_HERE, "results",
                                                   "elliptic_symbol_zeros.json"))
    ap_.add_argument("--no-json", action="store_true")
    args = ap_.parse_args()
    labels = args.curve or sorted(CURVES)

    rows, worst = [], 0.0
    print(f"{'curve':>8}{'rank':>5}{'p':>5}{'a_p':>6}{'|a_p|<=2sqrt p':>16}"
          f"{'|x|':>12}{'p^-1/2':>12}{'Re(s)':>9}")
    for lab in labels:
        c = CURVES[lab]
        N, rank = c[5], c[6]
        for p in primerange(2, args.pmax + 1):
            if N % p == 0:
                continue                          # bad reduction
            A = ap(c, p)
            disc = A * A - 4 * p
            roots = [(A + cmath.sqrt(disc)) / (2 * p),
                     (A - cmath.sqrt(disc)) / (2 * p)]
            mods = [abs(z) for z in roots]
            tgt = p ** -0.5
            re_s = [-math.log(m) / math.log(p) for m in mods]
            worst = max(worst, max(abs(r - 0.5) for r in re_s))
            hasse = abs(A) <= 2 * math.sqrt(p)
            rows.append(dict(curve=lab, rank=rank, p=p, a_p=A,
                             hasse_holds=bool(hasse),
                             abs_x=mods, target=tgt, re_s=re_s))
            print(f"{lab:>8}{rank:>5}{p:>5}{A:>6}{'yes' if hasse else 'NO':>16}"
                  f"{mods[0]:>12.6f}{tgt:>12.6f}{re_s[0]:>9.4f}")

    print(f"\nmax |Re(s) - 1/2| over {len(rows)} curve-prime pairs: {worst:.3e}")
    print("Hasse holds at every pair:",
          all(r["hasse_holds"] for r in rows))

    if not args.no_json:
        os.makedirs(os.path.dirname(args.out), exist_ok=True)
        payload = dict(
            schema_version="1", script=os.path.basename(__file__),
            generated_utc=datetime.datetime.now(
                datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            params=dict(curves=labels, pmax=args.pmax,
                        code_version=code_version()),
            constants=dict(
                claim="roots of 1 - a_p x + p x^2 have |x| = p^(-1/2), i.e. Re(s) = 1/2",
                theorem="Hasse 1933 — RH for curves over finite fields",
                zeta_contrast="zeta's symbol 1 - b^-s has zeros on Re(s) = 0"),
            summary=dict(pairs=len(rows), max_abs_dev_from_half=worst,
                         hasse_holds_everywhere=all(r["hasse_holds"] for r in rows)),
            rows=rows)
        with open(args.out, "w") as fh:
            json.dump(payload, fh, indent=2)
        print("results written to", args.out)


if __name__ == "__main__":
    main()
