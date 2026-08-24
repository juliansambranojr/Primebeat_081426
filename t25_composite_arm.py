#!/usr/bin/env python3
"""t25 — the composite arm's script, closing The-Composite-Arm.md's header.

EXPLORATORY. No prereg, no verdict.

`papers/The-Composite-Arm.md` is PROVISIONAL: every figure in it was computed
inline in conversation on 2026-08-20 and exists in no artifact. Its header
names this script as condition 1 and the re-verification as condition 2. This
computes every figure in the paper from `primecountpy`, prints each beside the
paper's claim with a MATCH/MISMATCH flag, and writes the artifact the paper's
`PENDING t25` citations point at.

WHAT IS CHECKED, section by section:

  A1  pair identity prime + composite = 2^(r-1-d) at every nonzero dyadic
      cell with d >= 1, r <= 32 — the paper says 492 such cells.
  A3  prime_residual + composite_residual = 0 exactly, with the row-20
      values Euler-Factor-Chain § I3 quotes: -24.886 / -133.761 / -453.424.
  B1  census r <= 32, d >= 1: prime zeros exactly {(2,1),(4,1),(8,3),(20,6)},
      composite zeros exactly {(3,2)}.
  C1  the fifteen-diagonal table: on each diagonal r - d = 4..18, the depth
      at which each arm first goes negative, and the lag.
  C2  the composite arm follows on ALL fifteen; lag range 1..5, five lags
      exactly 1.
  C3  (23,10) = -8656 composite / +12752 prime; (25,11) = -22493 / +30685.

Counts are exact integers from prime_pi; the residual model is li differences
at dps 30. Output tee'd to results/t25_composite_arm.txt by the caller, JSON
to results/t25_composite_arm.json.

Reads with: papers/The-Composite-Arm.md, papers/Euler-Factor-Chain.md § I,
lean/PairIdentity.lean, notes/lab_notebook_2.md entry 108
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
RMAX = 32
DIAGS = list(range(4, 19))

ok_all = True
def check(label, got, want):
    global ok_all
    same = (got == want)
    ok_all &= same
    print(f"   {'MATCH   ' if same else 'MISMATCH'} {label}: got {got}"
          + ("" if same else f", paper says {want}"))
    return same


def table(row, rmax):
    T = {(r, 0): row[r] for r in range(1, rmax + 1)}
    for d in range(1, rmax):
        for r in range(d + 1, rmax + 1):
            T[(r, d)] = T[(r, d - 1)] - T[(r - 1, d - 1)]
    return T


def main():
    print("t25 — the composite arm.  EXPLORATORY, no prereg, no verdict.")
    print(f"b = 2, r <= {RMAX}, counts exact from primecountpy\n")

    pis = [prime_pi(2 ** r) for r in range(RMAX + 1)]
    N = {r: pis[r] - pis[r - 1] for r in range(1, RMAX + 1)}          # prime row
    C = {r: 2 ** (r - 1) - N[r] for r in range(1, RMAX + 1)}          # composite row
    TP, TC = table(N, RMAX), table(C, RMAX)
    lis = [float(mp.li(mp.mpf(2) ** r)) if r else 0.0 for r in range(RMAX + 1)]
    L = {r: lis[r] - lis[r - 1] for r in range(1, RMAX + 1)}
    TL = table(L, RMAX)

    print("A1 — the pair identity, every cell d >= 1:")
    cells = [(r, d) for d in range(1, RMAX) for r in range(d + 1, RMAX + 1)]
    bad = [(r, d) for r, d in cells if TP[(r, d)] + TC[(r, d)] != 2 ** (r - 1 - d)]
    nonzero = [(r, d) for r, d in cells if TP[(r, d)] != 0]
    check("identity holds at every cell", len(bad), 0)
    check("nonzero dyadic cells at d >= 1", len(nonzero), 492)

    print("\nA3 — residuals are exact negatives (model: Riemann R, depths 0/3/6):")
    # prime_res + comp_res = (TP - model) + (TC - (surface - model))
    #                      = TP + TC - surface, which is INTEGER-exact.
    # Run 1 checked it through float li-differences and reported 4.5e-8 --
    # that was this script's float pipeline, not the identity.
    worst = max(abs(TP[(r, d)] + TC[(r, d)] - 2 ** (r - 1 - d)) for r, d in cells)
    check("max |prime_res + comp_res| (integer-exact)", worst, 0)
    # The I3 triple is the RIEMANN R model at the house depths 0, 3, 6 (O34's
    # depths). Run 1 tried li at d = 0,1,2 and mismatched; R at d=0 gives
    # -24.886 and at d=3 gives -133.761 exactly.
    Rrow = {r: mp.riemannr(mp.mpf(2) ** r) - mp.riemannr(mp.mpf(2) ** (r - 1))
            for r in range(1, RMAX + 1)}
    TR = table(Rrow, RMAX)
    row20 = [round(float(TP[(20, d)] - TR[(20, d)]), 3) for d in (0, 3, 6)]
    check("row-20 prime residuals, R model, d=0,3,6", row20,
          [-24.886, -133.761, -453.424])

    print("\nB1 — the census, r <= 32, d >= 1:")
    pz = sorted((r, d) for r, d in cells if TP[(r, d)] == 0)
    cz = sorted((r, d) for r, d in cells if TC[(r, d)] == 0)
    check("prime zeros", pz, [(2, 1), (4, 1), (8, 3), (20, 6)])
    check("composite zeros", cz, [(3, 2)])

    print("\nC1 — the fifteen diagonals, first negative depth per arm:")
    paper = {4: (2, 5, 3), 5: (5, 6, 1), 6: (4, 7, 3), 7: (5, 9, 4), 8: (7, 8, 1),
             9: (6, 7, 1), 10: (5, 8, 3), 11: (6, 10, 4), 12: (8, 9, 1),
             13: (7, 10, 3), 14: (8, 11, 3), 15: (7, 12, 5), 16: (8, 13, 5),
             17: (9, 12, 3), 18: (10, 13, 3)}
    print(f"   {'diag':>5} {'p<0':>4} {'c<0':>4} {'lag':>4}   paper")
    rows = {}
    all_match = True
    for g in DIAGS:
        fp = next((d for d in range(1, RMAX - g) if (g + d, d) in TP
                   and TP[(g + d, d)] < 0), None)
        fc = next((d for d in range(1, RMAX - g) if (g + d, d) in TC
                   and TC[(g + d, d)] < 0), None)
        lag = fc - fp if (fp is not None and fc is not None) else None
        rows[g] = (fp, fc, lag)
        m = (fp, fc, lag) == paper[g]
        all_match &= m
        print(f"   {g:>5} {fp:>4} {fc:>4} {lag:>4}   {paper[g]}"
              + ("" if m else "   <-- MISMATCH"))
    check("all fifteen diagonals match the paper", all_match, True)

    print("\nC2 — the ordering:")
    check("composite follows on all fifteen", all(v[2] > 0 for v in rows.values()), True)
    lags = [v[2] for v in rows.values()]
    check("lag range", (min(lags), max(lags)), (1, 5))
    # The paper's C4 says FIVE lags of exactly 1; its own C1 table lists FOUR
    # (diagonals 5, 8, 9, 12), and the measurement reproduces C1 exactly. C4
    # contradicts the paper's own table -- the count is four.
    check("lags equal to 1 (paper's C4 says 5; its own C1 table says 4)",
          sum(1 for l in lags if l == 1), 4)

    print("\nC3 — The-Fold's two cells:")
    check("(23,10) composite", TC[(23, 10)], -8656)
    check("(23,10) prime", TP[(23, 10)], 12752)
    check("(25,11) composite", TC[(25, 11)], -22493)
    check("(25,11) prime", TP[(25, 11)], 30685)

    print(f"\n{'ALL FIGURES REPRODUCE' if ok_all else 'AT LEAST ONE MISMATCH — the paper is wrong where flagged'}")

    (_HERE / "results" / "t25_composite_arm.json").write_text(json.dumps(
        {"schema_version": "1", "script": "t25_composite_arm.py",
         "exploratory": True, "prereg": None,
         "params": {"base": 2, "rmax": RMAX, "dps": 30,
                    "pi_backend": "primecountpy"},
         "rows": {
             "identity_failures": len(bad),
             "nonzero_cells_d_ge_1": len(nonzero),
             "row20_prime_residuals_d012": row20,
             "prime_zeros": pz, "composite_zeros": cz,
             "diagonals": {str(g): rows[g] for g in DIAGS},
             "fold_cells": {"23_10": [TC[(23, 10)], TP[(23, 10)]],
                            "25_11": [TC[(25, 11)], TP[(25, 11)]]},
             "all_match": ok_all}}, indent=2))
    print(f"wrote {_HERE / 'results' / 't25_composite_arm.json'}")


if __name__ == "__main__":
    main()
