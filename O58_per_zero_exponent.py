#!/usr/bin/env python3
"""O58 — EXPLORATORY. No prereg, no verdict.

The growth exponent of EACH detected zero, rather than one exponent for all.

WHY. Every theta scan on this bench (O9, and O17's fixed grid at
O17_disjoint_block_residual.py:284) fits ONE exponent across the whole ladder.
That averages over every zero at once, and it averages away the signature this
script looks for.

THE STRUCTURE, which is the functional equation rather than an assumption about
it. Zeros come in fours:

    beta + i*gamma      beta - i*gamma
    1-beta + i*gamma    1-beta - i*gamma

The functional-equation partner of rho sits at the SAME gamma. On the torus
C*/b^Z that pairing is z -> b^(-1)/z, whose fixed set is exactly the circle
|z| = b^(-1/2) -- Transform.inversion_fixes_circle, proved 2026-08-21. So:

    RH  <=>  every nontrivial zero is its own inversion partner

WHAT THAT PREDICTS HERE. A zero at beta + i*gamma contributes to the normalised
residual ehat = e/(x^theta/log x) a mode at frequency gamma with amplitude
scaling as x^(beta - theta). With theta = 1/2 fixed:

    zero ON the line   ->  amplitude at gamma is FLAT in x     slope 0
    zero OFF the line  ->  the pair (beta, 1-beta) straddles 1/2, the larger
                           one dominates, and the slope is |beta - 1/2| > 0

The slope is strictly positive for an off-line zero no matter which side it
falls, because one of beta, 1-beta always exceeds 1/2. That asymmetry is what
makes this a one-sided test.

HOW. Slide overlapping windows along log x, measure the amplitude at each gamma
inside each window, and regress log(amplitude) on log(x) at the window centre.
Report the slope per zero.

TWO NOISE MODELS, AND THEY DIFFER BY 45x. The same fit is run at the MIDPOINTS
between consecutive zeros, where no zero sits. That is the estimator with no
coherent signal to fit, and it is the WRONG yardstick for a peak sitting 330x
above the median (entry 94) -- run 1 used it and understated the sensitivity by
a factor of 45. The right yardstick is the ZERO-TO-ZERO scatter: six independent
zeros measured the same way, so a zero off the line would stand out from the
other five. Both are reported; the second is the one that means anything.

A LIMITATION TO HOLD. Per-window resolution is dgamma = 1.34 and the zeros here
are 2.5 to 7 apart, so neighbouring zeros leak into each other's amplitude. The
midpoint fits carry that leakage too, which is part of why they scatter.

WHAT THIS CANNOT DO. It cannot prove RH. It can only fail to find a positive
slope, and report the smallest |beta - 1/2| it would have caught.

Reads with: O17_disjoint_block_residual.py, O50_deep_ladder_spectrum.py,
lean/Transform.lean (inversion_fixes_circle, zmap_functional_equation),
papers/The-Deep-Ladder.md D3, notes/lab_notebook_2.md entries 92, 93, 94
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
X0, RATIO, XMAX = 1e5, 1.002, 10 ** 11
THETA = 0.5
N_WINDOWS = 9
WIN_FRAC = 0.34          # window half-span as a fraction of the full log range
GAMMA_MAX = 40.0

ZEROS = [float(z) for z in json.load(open(_HERE / "zeros600.json"))]


def build():
    n = int(math.log(XMAX / X0) / math.log(RATIO))
    xs = np.array([X0 * RATIO ** j for j in range(n + 1)])
    c = np.array([prime_pi(int(xs[j + 1])) - prime_pi(int(xs[j]))
                  for j in range(len(xs) - 1)], dtype=float)
    L = np.array([float(mp.li(mp.mpf(xs[j + 1])) - mp.li(mp.mpf(xs[j])))
                  for j in range(len(xs) - 1)])
    xm = xs[:-1]
    ehat = (c - L) / (xm ** THETA / np.log(xm))
    return np.log(xm), ehat, int(c.sum())


def amp_in_window(lx, eh, lo, hi, gammas):
    """Hann-windowed amplitude at each gamma, normalised by block count."""
    m = (lx >= lo) & (lx < hi)
    n = int(m.sum())
    if n < 64:
        return None, n
    z = (eh[m] - eh[m].mean()) * np.hanning(n)
    l = lx[m]
    return np.array([abs(np.sum(z * np.exp(-1j * g * l))) / n
                     for g in gammas]), n


def fit(xs, ys):
    """least squares slope, intercept, r^2"""
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    b = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / sxx
    a = my - b * mx
    ss_res = sum((y - (a + b * x)) ** 2 for x, y in zip(xs, ys))
    ss_tot = sum((y - my) ** 2 for y in ys)
    return b, a, (1 - ss_res / ss_tot if ss_tot > 0 else float("nan"))


def main():
    print("O58 - the growth exponent of each detected zero.")
    print("EXPLORATORY, no prereg, no verdict.")
    print(f"ladder x0={X0:g} ratio={RATIO} xmax={XMAX:.0e}  theta={THETA}")

    lx, eh, nprimes = build()
    L0, L1 = lx.min(), lx.max()
    half = WIN_FRAC * (L1 - L0) / 2
    centres = np.linspace(L0 + half, L1 - half, N_WINDOWS)
    dg_win = 2 * math.pi / (2 * half)
    print(f"{len(lx)} blocks, {nprimes:,} primes, log range {L1-L0:.3f}")
    print(f"{N_WINDOWS} windows, half-span {half:.3f} in log x, "
          f"per-window resolution dgamma = {dg_win:.3f}\n")

    zs = [g for g in ZEROS if 10.0 < g < GAMMA_MAX]
    mids = [(zs[i] + zs[i + 1]) / 2 for i in range(len(zs) - 1)]
    targets = zs + mids
    rows = {g: [] for g in targets}
    for cen in centres:
        A, n = amp_in_window(lx, eh, cen - half, cen + half, targets)
        if A is None:
            continue
        for g, a in zip(targets, A):
            if a > 0:
                rows[g].append((float(cen), float(math.log(a))))

    def report(label, gs):
        out = []
        print(f"=== {label}")
        print(f"   {'gamma':>9} {'slope':>9} {'beta_hat':>9} {'r^2':>7} {'pts':>4}")
        for g in gs:
            pts = rows[g]
            if len(pts) < 4:
                continue
            b, _, r2 = fit([p[0] for p in pts], [p[1] for p in pts])
            out.append({"gamma": g, "slope": b, "beta_hat": THETA + b,
                        "r2": r2, "n_points": len(pts)})
            print(f"   {g:>9.4f} {b:>+9.4f} {THETA+b:>9.4f} {r2:>7.3f} {len(pts):>4}")
        return out

    zrows = report("AT THE ZEROS   (RH predicts slope 0, beta_hat 1/2)", zs)
    mrows = report("AT THE MIDPOINTS   (no zero here - this is the noise floor)", mids)

    zs_sl = [w["slope"] for w in zrows]
    ms_sl = [w["slope"] for w in mrows]
    mu_z, mu_m = float(np.mean(zs_sl)), float(np.mean(ms_sl))
    sd_z, sd_m = float(np.std(zs_sl, ddof=1)), float(np.std(ms_sl, ddof=1))
    print(f"\n=== SUMMARY")
    print(f"   at zeros      mean slope {mu_z:+.5f}   sd {sd_z:.5f}   "
          f"max |slope| {max(abs(v) for v in zs_sl):.5f}")
    print(f"   at midpoints  mean slope {mu_m:+.5f}   sd {sd_m:.5f}   "
          f"max |slope| {max(abs(v) for v in ms_sl):.5f}")
    print(f"   implied beta at the zeros: {THETA+mu_z:.5f} +/- {sd_z:.5f}")
    sens_z, sens_m = 3 * sd_z, 3 * sd_m
    print(f"\n=== SENSITIVITY")
    print(f"   Two noise models, and they differ by {sd_m/sd_z:.0f}x.")
    print(f"   The MIDPOINT scatter ({sd_m:.5f}) is the estimator with NO coherent")
    print(f"   signal to fit; it is the wrong yardstick for a peak that is 330x")
    print(f"   the median (entry 94).  3 sd = {sens_m:.5f}, and that understates.")
    print(f"   The ZERO-TO-ZERO scatter ({sd_z:.5f}) is the right one: six")
    print(f"   independent zeros, each measured the same way.  If one of them sat")
    print(f"   off the line it would stand out from the other five by |beta-1/2|.")
    print(f"\n   So: |beta - 1/2| > {sens_z:.5f} would have shown, for gamma < {GAMMA_MAX:g}.")
    print(f"   Largest |slope| actually seen at a zero: {max(abs(v) for v in zs_sl):.5f}")
    print(f"   MEASURED, from prime counts alone:  Re rho = {THETA+mu_z:.5f}"
          f" +/- {sd_z:.5f}  for each of the first {len(zs)} zeros.")
    print(f"\n   On r^2: values near 0 AT THE ZEROS are the RH prediction, not a")
    print(f"   bad fit.  A flat line has no variance for a slope to explain.")
    print("\n   This cannot prove RH -- six zeros, finite precision, finite range.")
    print("   It measures Re rho instead of assuming it, which the theta scans did not.")

    res = {"schema_version": "1", "script": "O58_per_zero_exponent.py",
           "exploratory": True, "prereg": None,
           "params": {"x0": X0, "ratio": RATIO, "xmax": XMAX, "theta": THETA,
                      "n_windows": N_WINDOWS, "win_frac": WIN_FRAC,
                      "gamma_max": GAMMA_MAX, "dps": 30,
                      "pi_backend": "primecountpy"},
           "constants": {"n_blocks": len(lx), "n_primes": nprimes,
                         "log_range": float(L1 - L0),
                         "window_dgamma": dg_win},
           "rows": {"at_zeros": zrows, "at_midpoints": mrows},
           "summary": {"zeros_mean_slope": mu_z, "zeros_sd": sd_z,
                       "midpoints_mean_slope": mu_m, "midpoints_sd": sd_m,
                       "implied_beta": THETA + mu_z,
                       "sensitivity_3sd_zeros": 3 * sd_z,
                       "sensitivity_3sd_midpoint": 3 * sd_m,
                       "noise_model_ratio": sd_m / sd_z,
                       "max_abs_slope_at_zeros": max(abs(v) for v in zs_sl)}}
    p = _HERE / "results" / "per_zero_exponent_run2.json"
    p.write_text(json.dumps(res, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
