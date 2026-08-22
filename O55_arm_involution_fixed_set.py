#!/usr/bin/env python3
"""O55 — EXPLORATORY. No prereg, no verdict.

The arm swap is an involution. Where are its fixed points?

WHY. Entry 90 recorded that `prime + composite = (b-1)^(d+1) * b^e` exactly
(PairIdentity.pair_identity), with no primes on the right, and that the residual
flips sign under the arm swap (Euler-Factor-Chain.md I3). Julian then wrote the
correspondence down as two involutions:

    s -> 1 - s              fixed set: the critical line
    prime <-> composite     fixed set: cells where prime(r,d) = composite(r,d)

Normalising by S = prime + composite makes the parallel exact. With
sigma = prime/S, the arm swap is sigma -> 1 - sigma, and its fixed point is
sigma = 1/2, the same shape as s + (1-s) = 1 fixed at 1/2.

The s-side fixed set is a LINE. This asks what the arm-side fixed set is, which
is finite and computable and had never been looked at.

ENTRY 90 CONFLATED TWO QUANTITIES and this script separates them. Writing M for
the smooth model and rho for the residual:

    prime = M_p + rho       composite = M_c - rho       M_p + M_c = S
    I3 says rho flips sign under the swap.  TRUE.
    But M_p != S/2, so "prime = S/2 + rho" is FALSE.

`e = prime - S/2` is the ARM ASYMMETRY, a different quantity from rho. Three
conditions the record had been treating as one family:

    (1) cell_prime(r,d) = 0        the four exact zeros
    (2) prime(r,d) = composite(r,d) the arm-swap fixed set     <- this script
    (3) rho(r,d) = 0                residual vanishing, needs the smooth model

All three are reported side by side so they stop being confusable.

MEASURED, base 2, r <= 62, every cell at d >= 0:
  - pair_identity as a numerical self-check (a failure would be a bug)
  - the fixed set of the arm involution
  - the sigma = prime/S profile and its closest approaches to 1/2
  - rho and its smallest magnitudes, against the li-difference model

Reads with: lean/PairIdentity.lean, papers/Euler-Factor-Chain.md I1-I3,
papers/The-Composite-Arm.md, notes/lab_notebook_2.md entries 84, 87, 88, 90
"""
import json, math, pathlib
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 40
R = 62
FOUR_ZEROS = [(2, 1), (4, 1), (8, 3), (20, 6)]


def difference_table(row):
    """row is indexed r = 1..R; returns T[d][i] with r = i + 1 + d."""
    T = [list(row)]
    for _ in range(R - 1):
        prev = T[-1]
        T.append([prev[i] - prev[i - 1] for i in range(1, len(prev))])
    return T


def cell(T, r, d):
    return T[d][r - 1 - d]


def main():
    print("O55 - the arm involution's fixed set.  EXPLORATORY, no prereg, no verdict.")
    print(f"base 2, r <= {R}, every cell at d >= 0\n")

    prime_row = [prime_pi(2 ** r) - prime_pi(2 ** (r - 1)) for r in range(1, R + 1)]
    comp_row = [2 ** (r - 1) - prime_row[r - 1] for r in range(1, R + 1)]
    model_row = [float(mp.li(mp.mpf(2) ** r) - mp.li(mp.mpf(2) ** (r - 1)))
                 for r in range(1, R + 1)]

    TP, TC, TM = (difference_table(prime_row), difference_table(comp_row),
                  difference_table(model_row))
    cells = [(r, d) for d in range(R) for r in range(d + 1, R + 1)]

    # 1. pair_identity, numerically
    bad = [(r, d) for r, d in cells
           if cell(TP, r, d) + cell(TC, r, d) != 2 ** (r - 1 - d)]
    print(f"1. PAIR IDENTITY  prime + composite == 2^(r-1-d)")
    print(f"   holds at every one of {len(cells)} cells: {not bad}")
    if bad:
        print(f"   FAILURES: {bad[:5]}")

    # 2. the fixed set
    fixed = [(r, d) for r, d in cells if cell(TP, r, d) == cell(TC, r, d)]
    print(f"\n2. FIXED SET  prime(r,d) == composite(r,d)   i.e. sigma == 1/2")
    print(f"   {len(fixed)} cells: {fixed}")
    for r, d in fixed:
        print(f"     (r={r},d={d})  prime={cell(TP,r,d)}  composite={cell(TC,r,d)}"
              f"  S=2^{r-1-d}={2**(r-1-d)}")

    # 3. sigma profile and near misses
    sig = {(r, d): cell(TP, r, d) / 2 ** (r - 1 - d) for r, d in cells}
    print(f"\n3. SIGMA = prime/S   along d = 0")
    for r in (2, 3, 4, 8, 16, 32, 48, 62):
        print(f"     r={r:2d}  sigma = {sig[(r,0)]:.8f}")
    near = sorted(cells, key=lambda k: abs(sig[k] - 0.5))[:8]
    print("   closest approaches to 1/2:")
    for r, d in near:
        print(f"     (r={r:2d},d={d:2d})  sigma = {sig[(r,d)]:+.8f}"
              f"   |sigma-1/2| = {abs(sig[(r,d)]-0.5):.8f}")

    # 4. the three conditions, side by side
    rho = {(r, d): cell(TP, r, d) - cell(TM, r, d) for r, d in cells}
    zero_cells = [(r, d) for r, d in cells if d >= 1 and cell(TP, r, d) == 0]
    small_rho = sorted((k for k in cells if k[1] >= 1), key=lambda k: abs(rho[k]))[:8]
    print(f"\n4. THREE CONDITIONS, SEPARATED")
    print(f"   (1) cell_prime = 0      : {zero_cells}")
    print(f"       (the four of record : {FOUR_ZEROS})")
    print(f"   (2) prime = composite   : {fixed}")
    print(f"   (3) rho = 0             : exactly {sum(1 for k in cells if rho[k] == 0.0)}"
          f" cells; smallest |rho| at d >= 1:")
    for r, d in small_rho:
        print(f"       (r={r:2d},d={d:2d})  rho = {rho[(r,d)]:+.6f}")
    print(f"\n   overlap (1) & (2): {sorted(set(zero_cells) & set(fixed))}")

    out = {"schema_version": "1", "script": "O55_arm_involution_fixed_set.py",
           "exploratory": True, "prereg": None,
           "params": {"base": 2, "r_max": R, "dps": 40, "pi_backend": "primecountpy"},
           "constants": {"four_zeros_of_record": FOUR_ZEROS, "n_cells": len(cells)},
           "rows": {
               "pair_identity_holds_everywhere": not bad,
               "fixed_set": fixed,
               "fixed_set_size": len(fixed),
               "sigma_at_depth0": {str(r): sig[(r, 0)] for r in range(1, R + 1)},
               "closest_to_half": [{"r": r, "d": d, "sigma": sig[(r, d)],
                                    "gap": abs(sig[(r, d)] - 0.5)} for r, d in near],
               "exact_zero_cells": zero_cells,
               "rho_exactly_zero_count": sum(1 for k in cells if rho[k] == 0.0),
               "smallest_rho": [{"r": r, "d": d, "rho": rho[(r, d)]}
                                for r, d in small_rho]}}
    p = _HERE / "results" / "arm_involution_fixed_set.json"
    p.write_text(json.dumps(out, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
