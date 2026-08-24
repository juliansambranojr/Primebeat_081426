#!/usr/bin/env python3
"""O65 — EXPLORATORY. No prereg, no verdict.

The variance of prime counts in blocks, against Poisson, measured directly.

WHY. O63 found the difference table staying small-valued far deeper than a
Poisson row of the same magnitude — at depth 5, zero of 400 draws reached the
real fraction. The caveat recorded in entry 102: sub-Poisson variance of prime
counts is the likely known cause, and O63 measures it only through the
difference table. This measures the thing itself, so the caveat becomes either
a grounding or a discrepancy.

WHAT IS MEASURED. Prime counts in disjoint blocks of equal width H over
[x0, x0 + W]. The statistic is the variance-to-mean ratio (Poisson gives 1):

    F(H, x0) = Var[pi(x + H) - pi(x)] / E[pi(x + H) - pi(x)]

over the blocks in the window. Swept over H at several x0 decades.

WHAT IS KNOWN, so this is calibration rather than discovery. Prime counts in
short intervals are sub-Poisson; Goldston-Montgomery ties the variance in the
range H ~ x^delta to the pair correlation of the zeta zeros -- the SAME
statistic entry 103 measured from the spectral side. Cramer's model predicts
Poisson only for H ~ (log x)^(2+eps), and the variance falls below Poisson as
H grows past that. The expected shape: F ~ 1 at small H, falling like
~ log(x/H)/log(x) territory for larger H (Montgomery-Soundararajan:
F ~ log(x/H) - (gamma + log 2pi) normalised by log x, under strong
conjectures).

THE DYADIC POINT. The table's blocks are (2^(r-1), 2^r] -- maximal H, H = x/2.
So the table lives at the far sub-Poisson end of the curve, which is why O63's
depth profile beat its Poisson null. This run puts the table's own blocks ON
the measured curve rather than leaving the connection verbal.

CONTROL. The same F computed on synthetic Poisson points at the primes' local
density, same windows, same blocks -- should give F = 1 within sampling error,
and calibrates the estimator's own noise.

Reads with: O63_value_refraction.py, O64_gue_spacing.py, pi2n_cache.json,
notes/lab_notebook_2.md entries 102, 103
"""
import json, math, pathlib
import numpy as np
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
RNG = np.random.default_rng(2026)
DECADES = [10 ** 6, 10 ** 8, 10 ** 10]
N_BLOCKS = 400                     # blocks per (H, x0) cell


def F_ratio(x0, H, n_blocks):
    """DETRENDED variance/mean over n_blocks disjoint width-H blocks from x0.

    Run 1 used raw Var(c)/mean(c) and at large H the window spans a wide range
    of x, so the falling density makes the variance trend-dominated -- F = 750
    at H = x/10 measured the smooth drift, not the fluctuation. Run 2 subtracts
    the li expectation per block first: F = Var(c - dli) / mean(c), which is
    the standard primes-in-short-intervals statistic."""
    import mpmath as mp
    mp.mp.dps = 30
    edges = [int(x0 + i * H) for i in range(n_blocks + 1)]
    pis = [prime_pi(e) for e in edges]
    c = np.diff(pis).astype(float)
    li = np.array([float(mp.li(mp.mpf(e))) for e in edges])
    e = c - np.diff(li)
    m = c.mean()
    return float(e.var(ddof=1) / m), float(m), c


def poisson_F(mean, n_blocks):
    c = RNG.poisson(mean, n_blocks).astype(float)
    return float(c.var(ddof=1) / c.mean())


def main():
    print("O65 — variance-to-mean of prime counts in blocks.  EXPLORATORY.")
    print(f"{N_BLOCKS} blocks per cell; Poisson gives F = 1\n")

    out = []
    print(f"{'x0':>7} {'H':>10} {'mean/blk':>9} {'F real':>8} {'F poisson':>10}"
          f" {'H as':>14}")
    for x0 in DECADES:
        lg = math.log(x0)
        # H from (log x)^2 territory up toward the dyadic scale
        Hs = [int(lg ** 2), int(lg ** 3), int(x0 ** 0.5), int(x0 ** 0.75),
              int(x0 / 10)]
        for H in Hs:
            F, m, _ = F_ratio(x0, H, N_BLOCKS)
            Fp = poisson_F(m, N_BLOCKS)
            if H == int(lg ** 2):
                lbl = "(log x)^2"
            elif H == int(lg ** 3):
                lbl = "(log x)^3"
            elif H == int(x0 ** 0.5):
                lbl = "x^0.5"
            elif H == int(x0 ** 0.75):
                lbl = "x^0.75"
            else:
                lbl = f"x/{int(x0/H)}"
            out.append({"x0": x0, "H": H, "label": lbl, "mean": m,
                        "F_real": F, "F_poisson": Fp})
            print(f"{x0:>7.0e} {H:>10} {m:>9.1f} {F:>8.3f} {Fp:>10.3f} {lbl:>14}")
        print()

    # the dyadic blocks themselves: variance across rungs is ill-posed (one
    # draw per rung), so instead: F inside ONE dyadic block, chopped fine
    print("INSIDE single dyadic blocks (2^r, 2^(r+1)], chopped into 400:")
    print(f"{'r':>4} {'H':>12} {'mean/blk':>9} {'F real':>8} {'F poisson':>10}")
    dy = []
    for r in (20, 27, 33):
        x0, W = 2 ** r, 2 ** r
        H = W // N_BLOCKS
        F, m, _ = F_ratio(x0, H, N_BLOCKS)
        Fp = poisson_F(m, N_BLOCKS)
        dy.append({"r": r, "H": H, "mean": m, "F_real": F, "F_poisson": Fp})
        print(f"{r:>4} {H:>12} {m:>9.1f} {F:>8.3f} {Fp:>10.3f}")

    print("\nREAD. F = 1 is Poisson. Falling F with growing H is the")
    print("sub-Poisson regime Goldston-Montgomery ties to the zeros' pair")
    print("correlation — the statistic entry 103 measured spectrally. The")
    print("dyadic table's blocks sit at the far end of this curve, which is")
    print("what O63's depth profile was seeing through the difference table.")

    (_HERE / "results" / "variance_ratio.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O65_variance_ratio.py",
         "exploratory": True, "prereg": None,
         "params": {"decades": DECADES, "n_blocks": N_BLOCKS, "seed": 2026},
         "rows": out, "dyadic_interior": dy}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'variance_ratio.json'}")


if __name__ == "__main__":
    main()
