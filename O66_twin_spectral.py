#!/usr/bin/env python3
"""O66 — EXPLORATORY. No prereg, no verdict.

The twin arm as a point process on the 6k lattice: rigidity and correlations.

WHY. Physics list #5. The twin process's ZETA-side spectrum is already a
measured null — imported/twin_count's zeta_power_ratio = 0.347 against 1.0 for
no signal, recorded in The-Deep-Ladder § F6 — and pi_2 has no proven explicit
formula, so nothing predicted otherwise. What that null leaves open are the
two questions this bench has since built instruments for:

  RIGIDITY (entry 105's axis). Prime counts are sub-Poisson at every scale,
  F falling to ~0.15. Does the TWIN process inherit that rigidity, or do
  twins fluctuate like a Bernoulli thinning of the lattice?

  CORRELATIONS (entry 103's axis, arithmetic side). The twin indicator's
  pair correlation R(h) = E[t_k t_{k+h}] / E[t]^2 at site lag h is predicted
  by Hardy-Littlewood: R(h) -> S(0,2,6h,6h+2) / S(0,2)^2, the 4-tuple
  singular series over the twin constant squared. Logs cancel in the ratio,
  so it is height-robust to first order. Measured against that prediction,
  with a Bernoulli control pinned at 1.

WHAT IS MEASURED. Windows of M = 2^20 consecutive sites 6k at three heights,
occupancy by segmented sieve. Per window:

  1. F(B) variance/mean of twin counts in blocks of B sites, vs Bernoulli.
  2. R(h) for h = 1..30, vs the HL prediction (singular series over primes
     to 1e5) and vs Bernoulli.
  3. The spectral summary: mean power in the lowest decile of frequencies
     over mean power, for twin / prime-site / Bernoulli indicators. Rigidity
     shows as low-frequency suppression; Poisson is flat at 1.

Reads with: O51_twin_lattice_census.py, O65_variance_ratio.py,
imported/twin_count/README.md, papers/The-Twin-Lattice.md,
notes/lab_notebook_2.md entries 103, 105
"""
import json, math, pathlib, sys
import numpy as np
from sympy import primerange

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from utilities.resultsguard import guarded_write

_HERE = pathlib.Path(__file__).resolve().parent
RNG = np.random.default_rng(2026)
M = 2 ** 20                       # sites per window
KS = [10 ** 6, 10 ** 8, 10 ** 10]  # window start, in site index k  (x ~ 6K)
LAGS = list(range(1, 31))
BLOCKS = [256, 1024, 4096]
P_SS = 10 ** 5                    # singular-series prime cutoff


def sieve_window(lo, hi):
    """Boolean primality for integers in [lo, hi), segmented."""
    n = hi - lo
    is_p = np.ones(n, dtype=bool)
    if lo <= 1:
        is_p[:max(0, min(2 - lo, n))] = False
    for p in primerange(2, int(math.isqrt(hi)) + 1):
        start = max(p * p, ((lo + p - 1) // p) * p)
        if start < hi:
            is_p[start - lo::p] = False
    return is_p


def occupancy(K, M):
    """twin, lo-only-side, hi-only-side prime indicators for sites k in [K, K+M)."""
    xlo, xhi = 6 * K - 2, 6 * (K + M) + 2
    is_p = sieve_window(xlo, xhi)
    k = np.arange(K, K + M)
    pl = is_p[6 * k - 1 - xlo]       # 6k-1 prime
    ph = is_p[6 * k + 1 - xlo]       # 6k+1 prime
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
    """Mean power in the lowest decile of frequencies / overall mean power."""
    z = x.astype(float) - x.mean()
    P = np.abs(np.fft.rfft(z)) ** 2
    P = P[1:]                          # drop DC
    k = max(1, len(P) // 10)
    return float(P[:k].mean() / P.mean())


def hl_ratio(h, primes):
    """R(h) predicted = S(0,2,6h,6h+2) / (6 * S(0,2)^2).

    Run 1 omitted the factor 6 and read 4.7 mean absolute error. The
    derivation: pairs-of-twins density per SITE is 6*S4/log^4 x (the HL count
    over all n already carries the mod-6 obstruction; sites are 1/6 of the
    integers), while the squared single-twin site density is
    (12 C2 / log^2 x)^2 = 144 C2^2/log^4 x with S2 = 2 C2. So
    R = 6 S4/(144 C2^2) = S4/(6 S2^2): the lattice conditioning enters the
    numerator once and the denominator twice."""
    H4 = [0, 2, 6 * h, 6 * h + 2]
    r = 1.0
    for p in primes:
        v4 = len({a % p for a in H4})
        v2 = len({a % p for a in (0, 2)})
        num = (1 - v4 / p) / (1 - 1 / p) ** 4
        den = ((1 - v2 / p) / (1 - 1 / p) ** 2) ** 2
        r *= num / den
    return r / 6.0


def main():
    print("O66 — the twin process: rigidity and pair correlations.  EXPLORATORY.")
    print(f"windows of {M} sites at k = " + ", ".join(f"{K:.0e}" for K in KS) + "\n")
    primes = list(primerange(2, P_SS))
    hl = {h: hl_ratio(h, primes) for h in LAGS}

    out = {}
    for K in KS:
        t, pl, ph = occupancy(K, M)
        pr = pl | ph                      # sites with at least one prime shoulder
        dens = t.mean()
        bern = RNG.random(M) < dens
        print(f"=== k0 = {K:.0e}   (x ~ {6*K:.1e})   twin density {dens:.5f}"
              f"   n_twins {int(t.sum())}")

        Ft, Fb = F_curve(t, BLOCKS), F_curve(bern, BLOCKS)
        print(f"   rigidity F (twin | bernoulli):  " +
              "   ".join(f"B={B}: {Ft[B]:.3f}|{Fb[B]:.3f}" for B in BLOCKS))

        Rt, Rb = pair_corr(t, LAGS), pair_corr(bern, LAGS)
        show = [1, 2, 3, 5, 10, 30]
        print(f"   {'h':>4} {'R meas':>8} {'R HL':>8} {'R bern':>8}")
        for h in show:
            print(f"   {h:>4} {Rt[h]:>8.3f} {hl[h]:>8.3f} {Rb[h]:>8.3f}")
        resid = [abs(Rt[h] - hl[h]) for h in LAGS]
        rb = [abs(Rb[h] - 1.0) for h in LAGS]
        print(f"   mean |R - HL| over 30 lags: {np.mean(resid):.4f}"
              f"   (bernoulli vs 1: {np.mean(rb):.4f})")

        lf = {"twin": low_freq_ratio(t), "prime_sites": low_freq_ratio(pr),
              "bernoulli": low_freq_ratio(bern)}
        print(f"   low-freq power ratio: twin {lf['twin']:.3f}"
              f"   prime-sites {lf['prime_sites']:.3f}"
              f"   bernoulli {lf['bernoulli']:.3f}\n")

        out[str(K)] = {"x_scale": 6 * K, "density": dens,
                       "n_twins": int(t.sum()),
                       "F_twin": {str(b): v for b, v in Ft.items()},
                       "F_bernoulli": {str(b): v for b, v in Fb.items()},
                       "R_measured": {str(h): Rt[h] for h in LAGS},
                       "R_bernoulli": {str(h): Rb[h] for h in LAGS},
                       "mean_abs_R_minus_HL": float(np.mean(resid)),
                       "low_freq_ratio": lf}

    print("HL prediction is lag-dependent and nontrivial: " +
          ", ".join(f"R({h})={hl[h]:.3f}" for h in (1, 2, 3, 5)))
    guarded_write(
        {"schema_version": "1", "script": "O66_twin_spectral.py",
         "exploratory": True, "prereg": None,
         "params": {"M": M, "window_starts": KS, "lags": LAGS,
                    "blocks": BLOCKS, "ss_prime_cutoff": P_SS, "seed": 2026},
         "hl_prediction": {str(h): hl[h] for h in LAGS},
         "rows": out},
        str(_HERE / "results" / "twin_spectral.json"))


if __name__ == "__main__":
    main()
