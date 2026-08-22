#!/usr/bin/env python3
"""O52 — EXPLORATORY. No prereg, no verdict.

Does the composite arm carry the same zeta spectrum as the prime arm?

WHY. `papers/The-Composite-Arm.md` § A3 states the residuals are exact
negatives. O50 measured the zeta spectrum of the PRIME residual on a fine
geometric ladder and separated 38 zeros completely below gamma 120, with flat
amplitude out to gamma 939. If A3 holds on this ladder, the composite arm must
carry identical amplitudes.

WHAT THIS IS. A verification with an artifact behind it, and a check for
implementation surprises. The algebra is already settled:

    total_j     = floor(x_{j+1}) - floor(x_j)        every integer in the block
    prime_j     = pi(x_{j+1}) - pi(x_j)
    comp_j      = total_j - prime_j                  above x0 there are no 1s
    L_j         = li(x_{j+1}) - li(x_j)              the smooth prime model
    comp_L_j    = total_j - L_j                      the smooth composite model

    e_prime  = prime_j - L_j
    e_comp   = comp_j - comp_L_j = (total - prime) - (total - L) = L - prime

so e_comp = -e_prime identically, the total cancelling with its floor term.

HONEST NOTE ON WHAT IS BEING TESTED. The composite smooth model is
`total - li` because the pair identity forces it -- there is no independent
choice. So this run confirms arithmetic and produces an artifact. It would
surprise only if the implementation diverged from the algebra.

Reads with: papers/The-Composite-Arm.md sections A2 A3,
O50_deep_ladder_spectrum.py, notes/lab_notebook_2.md entries 79, 84
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
ZEROS = [float(z) for z in json.load(open(_HERE / "zeros600.json"))]
RATIO, X0, XMAX = 1.002, 1e5, 10 ** 11


def main():
    print("O52 - composite arm spectrum.  EXPLORATORY, no prereg, no verdict.\n")
    n = int(math.log(XMAX / X0) / math.log(RATIO))
    xs = np.array([X0 * RATIO ** j for j in range(n + 1)])
    lo = np.floor(xs[:-1]).astype(np.int64)
    hi = np.floor(xs[1:]).astype(np.int64)

    prime = np.array([prime_pi(int(b)) - prime_pi(int(a))
                      for a, b in zip(lo, hi)], dtype=float)
    total = (hi - lo).astype(float)
    comp = total - prime
    L = np.array([float(mp.li(mp.mpf(int(b))) - mp.li(mp.mpf(int(a))))
                  for a, b in zip(lo, hi)])
    e_p = prime - L
    e_c = comp - (total - L)

    print(f"1. PER-CELL NEGATION over {len(e_p):,} blocks")
    s = e_p + e_c
    print(f"   max |e_prime + e_comp| = {np.abs(s).max():.3e}")
    print(f"   max |e_prime|          = {np.abs(e_p).max():.3f}")
    print(f"   ratio                  = {np.abs(s).max() / np.abs(e_p).max():.3e}")

    xm = xs[:-1]
    lx = np.log(xm)
    w = np.hanning(len(e_p))
    norm = np.sqrt(xm) / np.log(xm)
    zp = ((e_p / norm) - (e_p / norm).mean()) * w
    zc = ((e_c / norm) - (e_c / norm).mean()) * w
    amp = lambda z, g: abs(np.sum(z * np.exp(-1j * g * lx)))

    zs = [g for g in ZEROS if 14.0 < g < 939.0]
    Ap = np.array([amp(zp, g) for g in zs])
    Ac = np.array([amp(zc, g) for g in zs])
    print(f"\n2. AMPLITUDE AT {len(zs)} ZETA ZEROS, both arms")
    print(f"   {'gamma':>10} {'prime':>10} {'composite':>10} {'|diff|':>11}")
    for g, a, b in list(zip(zs, Ap, Ac))[:6]:
        print(f"   {g:>10.4f} {a:>10.4f} {b:>10.4f} {abs(a - b):>11.3e}")
    print(f"   ...")
    for g, a, b in list(zip(zs, Ap, Ac))[-3:]:
        print(f"   {g:>10.4f} {a:>10.4f} {b:>10.4f} {abs(a - b):>11.3e}")
    print(f"\n   max |prime - composite| over all {len(zs)} zeros: "
          f"{np.abs(Ap - Ac).max():.3e}")
    print(f"   median amplitude, prime arm     : {np.median(Ap):.4f}")
    print(f"   median amplitude, composite arm : {np.median(Ac):.4f}")

    out = {"schema_version": "1", "script": "O52_composite_arm_spectrum.py",
           "exploratory": True, "prereg": None,
           "params": {"ratio": RATIO, "x0": X0, "xmax": XMAX,
                      "n_blocks": len(e_p), "dps": 30},
           "summary": {
               "max_abs_cell_sum": float(np.abs(s).max()),
               "max_abs_prime_residual": float(np.abs(e_p).max()),
               "n_zeros_tested": len(zs),
               "max_amplitude_difference": float(np.abs(Ap - Ac).max()),
               "median_amp_prime": float(np.median(Ap)),
               "median_amp_composite": float(np.median(Ac))},
           "rows": [{"gamma": g, "amp_prime": float(a), "amp_composite": float(b)}
                    for g, a, b in zip(zs, Ap, Ac)]}
    p = _HERE / "results" / "composite_arm_spectrum.json"
    p.write_text(json.dumps(out, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
