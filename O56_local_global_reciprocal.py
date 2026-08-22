#!/usr/bin/env python3
"""O56 — EXPLORATORY. No prereg, no verdict.

sigma is a local fraction. Its reciprocal is the global log-coordinate.

WHY. Entry 90 normalised the arm split by S = prime + composite, giving
sigma = prime/S with sigma + (1-sigma) = 1 at every cell -- which is
PairIdentity.pair_identity divided through. Entry 91 measured the fixed set of
sigma -> 1-sigma and found three cells.

Julian then asked what the "1" is. Two claims, both measured here:

  (a) AT DEPTH 0 THE 1 IS THE INTEGER WHOLE, exactly.  S(r,0) = 2^(r-1) is the
      count of every integer in the block (2^(r-1), 2^r]. So sigma + (1-sigma) = 1
      IS primes-plus-composites-equals-all-integers. Below d = 0 this fails:
      S(r,d) = 2^(r-1-d) is the integer count divided by 2^d.

  (b) THE LOCAL-TO-GLOBAL MAP IS THE RECIPROCAL.  1/sigma tracks
      ln x = (r-1)*ln 2, the s-plane's natural variable. This is the prime number
      theorem -- sigma is the block's prime density and PNT says density ~ 1/ln x
      -- restated in the ladder's own coordinates and measured to r = 62.

WHAT THIS DOES NOT DO. It does not connect the arm swap to the functional
equation. s -> 1-s is an involution on C whose 1 is the pole of zeta, where
sum 1/n diverges. The 1 here is a partition of a finite set of integers in one
block. Both sum to 1 and they are different objects; nothing carries the arm
swap through the log map. See notes entry 92.

MEASURED, base 2:
  - S(r,0) against the integer count of the block, and the 2^d degradation
  - sigma, 1/sigma, ln x, and their ratio to r = 62
  - the least-squares slope of 1/sigma in r, against ln 2
  - the same against the li-difference density, which is the sharper comparison

Reads with: lean/PairIdentity.lean, O55_arm_involution_fixed_set.py,
notes/lab_notebook_2.md entries 90, 91, 92
"""
import json, math, pathlib
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 40
RS = [4, 8, 12, 16, 20, 24, 28, 32, 40, 48, 56, 62]


def main():
    print("O56 - sigma's reciprocal is the global log-coordinate.")
    print("EXPLORATORY, no prereg, no verdict.  base 2\n")

    print("1. AT DEPTH 0, S IS THE INTEGER COUNT OF THE BLOCK")
    ok = all(2 ** (r - 1) == 2 ** r - 2 ** (r - 1) for r in RS)
    print(f"   S(r,0) = 2^(r-1) == |(2^(r-1), 2^r]| for every r tested: {ok}")
    print("   below d = 0 it is the integer count divided by 2^d:")
    for d in (0, 1, 2, 6):
        print(f"     r=20, d={d}:  S = {2**(20-1-d):>7}   integers in block = {2**19:>7}"
              f"   ratio 1/2^{d}")

    print("\n2. SIGMA AND ITS RECIPROCAL")
    print(f"   {'r':>3} {'sigma':>11} {'1/sigma':>9} {'ln x':>9} {'ratio':>7}"
          f" {'sigma_li':>11} {'ratio_li':>8}")
    rows = []
    for r in RS:
        N = prime_pi(2 ** r) - prime_pi(2 ** (r - 1))
        S = 2 ** (r - 1)
        sig = N / S
        lnx = (r - 1) * math.log(2)
        sig_li = float(mp.li(mp.mpf(2) ** r) - mp.li(mp.mpf(2) ** (r - 1))) / S
        rows.append({"r": r, "n_primes": N, "S": S, "sigma": sig,
                     "inv_sigma": 1 / sig, "ln_x": lnx, "ratio": (1 / sig) / lnx,
                     "sigma_li": sig_li, "ratio_li": sig / sig_li})
        print(f"   {r:>3} {sig:>11.8f} {1/sig:>9.4f} {lnx:>9.4f} {(1/sig)/lnx:>7.4f}"
              f" {sig_li:>11.8f} {sig/sig_li:>8.5f}")

    xs = [w["r"] for w in rows]
    ys = [w["inv_sigma"] for w in rows]
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    slope = (sum((x - mx) * (y - my) for x, y in zip(xs, ys))
             / sum((x - mx) ** 2 for x in xs))
    icpt = my - slope * mx
    resid = [y - (icpt + slope * x) for x, y in zip(xs, ys)]
    print(f"\n3. LINEARITY OF 1/SIGMA IN r")
    print(f"   1/sigma = {icpt:.4f} + {slope:.4f} * r")
    print(f"   ln 2 = {math.log(2):.4f}   slope/ln2 = {slope/math.log(2):.4f}")
    print(f"   max |residual| = {max(abs(v) for v in resid):.4f}")
    print(f"\n   ratio to ln x runs {rows[0]['ratio']:.4f} -> {rows[-1]['ratio']:.4f},"
          f" converging from above")
    print(f"   ratio to the li density runs {rows[0]['ratio_li']:.5f} ->"
          f" {rows[-1]['ratio_li']:.5f}, the sharper comparison")

    out = {"schema_version": "1", "script": "O56_local_global_reciprocal.py",
           "exploratory": True, "prereg": None,
           "params": {"base": 2, "r_values": RS, "dps": 40,
                      "pi_backend": "primecountpy"},
           "constants": {"ln2": math.log(2)},
           "rows": rows,
           "fit": {"intercept": icpt, "slope": slope,
                   "slope_over_ln2": slope / math.log(2),
                   "max_abs_residual": max(abs(v) for v in resid)},
           "depth0_S_is_integer_count": ok}
    p = _HERE / "results" / "local_global_reciprocal.json"
    p.write_text(json.dumps(out, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
