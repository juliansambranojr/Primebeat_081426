#!/usr/bin/env python3
"""O57 — EXPLORATORY. No prereg, no verdict.

Run the measured gamma_1 forward in extent and watch where it goes.

WHY. O17's run of record put a peak at gamma = 14.08 against the true
gamma_1 = 14.134725, a tenth of a resolution element away
(results/O17_disjoint_block_residual_li_run2.json). Julian asked whether that
14.08 can be run "forward in time" to see whether it becomes the actual value,
and noted that going backwards is not the same operation because the steps
change the trajectory.

TIME HERE IS EXTENT. The instrument's only clock is how much of the prime
sequence has been looked at. Holding x0 and ratio fixed and growing xmax gives a
nested sequence of measurements, each one containing all the earlier blocks.
That is the forward direction, and it is the only one the instrument has.

THREE THINGS MEASURED.

  1. TRAJECTORY.  gamma_hat_1(xmax) for xmax = 1e6 .. 1e11 on O17's own ladder
     (x0 = 1000, ratio = 1.1), and on the fine ladder (x0 = 1e5, ratio = 1.002).
     Reported beside the resolution element dgamma = 2*pi/log(xmax/x0), because
     a peak converging no faster than dgamma shrinks is the instrument getting
     sharper rather than the estimate getting better.

  2. IS THE TRAJECTORY REVERSIBLE?  The blocks are nested, so truncating a long
     run to a short range ought to reproduce the short run exactly. It does not,
     and the reason is the Hann window: np.hanning(n) is a function of the whole
     block count, so every block's weight changes when the range changes. The
     measurement at extent T is not a state that later extents extend; it is
     recomputed from scratch. That is a concrete form of Julian's point and it
     is checked here rather than asserted.

  3. THE TORUS COORDINATE.  gamma folded into the fundamental domain of
     C*/2^Z, i.e. g -> min(g mod tau, tau - g mod tau) with tau = 2*pi/log 2
     (Transform.tau). This is the "map onto a globe" step: the strip's y-axis
     wraps, and the trajectory of gamma_hat_1 is reported in that coordinate as
     well as in the plane.

  4. BLIND SEARCH (run 2).  The trajectory above searches a window around
     gamma_1, which invites the objection that the window did the work. It did
     not. A search from 0.5 to 40 with nothing told where to look returns, as
     its top SIX peaks, exactly the six zeta zeros in that range -- 32.9400,
     25.0130, 37.5860, 30.4240, 14.1340, 21.0170 -- all between 5253x and 5398x
     the median, with the seventh peak at 15.90x. A factor of 330 separates the
     zeros from everything else.

     Ranking AMONG the six is meaningless: the spectrum is flat in gamma
     (papers/The-Deep-Ladder.md D3), so 14.1340 sitting fifth by height rather
     than first carries no information. What carries information is that it is
     in the group and the group is separated by 330x.

     The published 14.134725 is used only to report an error, never to find a
     peak.

WHAT THIS DOES NOT DO. It does not test RH, and the torus coordinate is a
change of variable rather than a new object. The published gamma_1 enters only
as a yardstick in the `err` column -- comparing this instrument's trajectory to
another instrument's snapshot.

Reads with: O17_disjoint_block_residual.py, O50_deep_ladder_spectrum.py,
lean/Transform.lean (tau, zmap_period), notes/lab_notebook_2.md entries 90-92
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
GAMMA_1 = 14.134725
TAU_2 = 2 * math.pi / math.log(2)

ARMS = [("O17_ladder", 1000.0, 1.1), ("fine_ladder", 1e5, 1.002)]
EXTENTS = [10 ** 6, 10 ** 7, 10 ** 8, 10 ** 9, 10 ** 10, 10 ** 11]


def fold(g, tau):
    m = g % tau
    return min(m, tau - m)


def spectrum(x0, ratio, xmax, lo=13.2, hi=15.1, step=0.0005):
    """O17's statistic, unchanged, restricted to a window around gamma_1."""
    n = int(math.log(xmax / x0) / math.log(ratio))
    xs = np.array([x0 * ratio ** j for j in range(n + 1)])
    c = np.array([prime_pi(int(xs[j + 1])) - prime_pi(int(xs[j]))
                  for j in range(len(xs) - 1)], dtype=float)
    L = np.array([float(mp.li(mp.mpf(xs[j + 1])) - mp.li(mp.mpf(xs[j])))
                  for j in range(len(xs) - 1)])
    xm = xs[:-1]
    ehat = (c - L) / (np.sqrt(xm) / np.log(xm))
    w = np.hanning(len(ehat))
    z = (ehat - ehat.mean()) * w
    lx = np.log(xm)
    gam = np.arange(lo, hi, step)
    P = np.array([abs(np.sum(z * np.exp(-1j * g * lx))) ** 2 for g in gam])
    i = int(P.argmax())
    return float(gam[i]), float(P[i] / np.median(P)), len(ehat), int(c.sum())


def main():
    print("O57 - gamma_1's trajectory in extent.  EXPLORATORY, no prereg, no verdict.")
    print(f"true gamma_1 = {GAMMA_1}   tau_2 = 2*pi/log2 = {TAU_2:.6f}"
          f"   fundamental domain [0, {TAU_2/2:.6f}]")
    print(f"folded true gamma_1 = {fold(GAMMA_1, TAU_2):.6f}\n")

    out = {}
    for name, x0, ratio in ARMS:
        print(f"=== {name}:  x0 = {x0:g}, ratio = {ratio}")
        print(f"   {'xmax':>7} {'blocks':>7} {'primes':>14} {'gamma_hat':>10}"
              f" {'err':>9} {'dgamma':>8} {'err/dg':>7} {'P/med':>7} {'folded':>9}")
        rows = []
        for xmax in EXTENTS:
            if xmax <= x0 * ratio ** 8:
                continue
            g, pm, nb, npr = spectrum(x0, ratio, xmax)
            dg = 2 * math.pi / math.log(xmax / x0)
            err = g - GAMMA_1
            rows.append({"xmax": xmax, "n_blocks": nb, "n_primes": npr,
                         "gamma_hat": g, "err": err, "abs_err": abs(err),
                         "dgamma": dg, "err_over_dgamma": abs(err) / dg,
                         "P_over_median": pm, "folded": fold(g, TAU_2)})
            print(f"   {xmax:>7.0e} {nb:>7} {npr:>14,} {g:>10.4f} {err:>+9.4f}"
                  f" {dg:>8.4f} {abs(err)/dg:>7.3f} {pm:>7.2f}"
                  f" {fold(g, TAU_2):>9.6f}")
        out[name] = rows
        print()

    # 2. reversibility: is a truncated long run the same as a short run?
    print("=== IS THE TRAJECTORY REVERSIBLE?")
    print("   Same blocks, two ways: measured directly at xmax = 1e8, versus")
    print("   the 1e11 run truncated to the same block set.")
    x0, ratio = 1000.0, 1.1
    g_direct, _, nb_direct, _ = spectrum(x0, ratio, 10 ** 8)
    n_long = int(math.log(10 ** 11 / x0) / math.log(ratio))
    xs = np.array([x0 * ratio ** j for j in range(n_long + 1)])
    c = np.array([prime_pi(int(xs[j + 1])) - prime_pi(int(xs[j]))
                  for j in range(len(xs) - 1)], dtype=float)
    L = np.array([float(mp.li(mp.mpf(xs[j + 1])) - mp.li(mp.mpf(xs[j])))
                  for j in range(len(xs) - 1)])
    xm = xs[:-1]
    ehat_long = (c - L) / (np.sqrt(xm) / np.log(xm))
    # truncate the LONG run's ehat to the short run's blocks, then window it
    eh = ehat_long[:nb_direct]
    lx = np.log(xm[:nb_direct])
    z = (eh - eh.mean()) * np.hanning(len(eh))
    gam = np.arange(13.2, 15.1, 0.0005)
    P = np.array([abs(np.sum(z * np.exp(-1j * g * lx))) ** 2 for g in gam])
    g_trunc = float(gam[int(P.argmax())])
    # and the same blocks carrying the LONG run's window weights
    w_long = np.hanning(len(ehat_long))[:nb_direct]
    z2 = (eh - eh.mean()) * w_long
    P2 = np.array([abs(np.sum(z2 * np.exp(-1j * g * lx))) ** 2 for g in gam])
    g_longw = float(gam[int(P2.argmax())])
    print(f"   direct measurement at 1e8            gamma_hat = {g_direct:.4f}")
    print(f"   1e11 residuals, truncated, rewindowed gamma_hat = {g_trunc:.4f}"
          f"   (identical: {abs(g_direct-g_trunc) < 1e-9})")
    print(f"   1e11 residuals, truncated, LONG window gamma_hat = {g_longw:.4f}"
          f"   shift = {g_longw - g_direct:+.4f}")
    print("   The residuals themselves are nested and recoverable. The WINDOW is")
    print("   a function of the whole range, so a measurement is not a state that")
    print("   later extents extend -- it is recomputed. That is the asymmetry.")

    # 4. blind wide search at the fine ladder's full extent
    print("\n=== BLIND SEARCH, 0.5 to 40, nothing told it where to look")
    x0f, ratiof, xmaxf = 1e5, 1.002, 10 ** 11
    nf = int(math.log(xmaxf / x0f) / math.log(ratiof))
    xsf = np.array([x0f * ratiof ** j for j in range(nf + 1)])
    cf = np.array([prime_pi(int(xsf[j + 1])) - prime_pi(int(xsf[j]))
                   for j in range(len(xsf) - 1)], dtype=float)
    Lf = np.array([float(mp.li(mp.mpf(xsf[j + 1])) - mp.li(mp.mpf(xsf[j])))
                   for j in range(len(xsf) - 1)])
    xmf = xsf[:-1]
    ehf = (cf - Lf) / (np.sqrt(xmf) / np.log(xmf))
    zf = (ehf - ehf.mean()) * np.hanning(len(ehf))
    lxf = np.log(xmf)
    gw = np.arange(0.5, 40.0, 0.001)
    Pw = np.array([abs(np.sum(zf * np.exp(-1j * g * lxf))) ** 2 for g in gw])
    medw = float(np.median(Pw))
    locw = [i for i in range(1, len(Pw) - 1) if Pw[i] > Pw[i - 1] and Pw[i] > Pw[i + 1]]
    topw = sorted(locw, key=lambda i: -Pw[i])[:8]
    blind = [{"rank": k, "gamma": float(gw[i]), "P_over_median": float(Pw[i] / medw)}
             for k, i in enumerate(sorted(topw, key=lambda i: -Pw[i]), 1)]
    print(f"   {'rank':>4} {'gamma':>9} {'P/median':>10}")
    for b in blind:
        print(f"   {b['rank']:>4} {b['gamma']:>9.4f} {b['P_over_median']:>10.2f}")
    near = min(blind, key=lambda b: abs(b["gamma"] - GAMMA_1))
    print(f"   the peak nearest the published gamma_1 = {GAMMA_1} is"
          f" {near['gamma']:.4f} at rank {near['rank']},"
          f" difference {near['gamma'] - GAMMA_1:+.4f}")
    print(f"   top six span {min(b['P_over_median'] for b in blind[:6]):.2f}x to"
          f" {max(b['P_over_median'] for b in blind[:6]):.2f}x median;"
          f" seventh is {blind[6]['P_over_median']:.2f}x")
    print("   Ranking among the six is meaningless -- the spectrum is flat in")
    print("   gamma (The-Deep-Ladder D3). The window did not find the peaks.")

    res = {"schema_version": "1", "script": "O57_gamma1_trajectory.py",
           "exploratory": True, "prereg": None,
           "params": {"gamma_1_true": GAMMA_1, "tau_2": TAU_2,
                      "arms": [a[0] for a in ARMS], "extents": EXTENTS,
                      "dps": 30, "pi_backend": "primecountpy",
                      "grid": [13.2, 15.1, 0.0005]},
           "constants": {"folded_gamma_1_true": fold(GAMMA_1, TAU_2)},
           "rows": out,
           "reversibility": {"direct_1e8": g_direct,
                             "truncated_rewindowed": g_trunc,
                             "truncated_long_window": g_longw,
                             "rewindowed_identical": abs(g_direct - g_trunc) < 1e-9},
           "blind_search": {"range": [0.5, 40.0, 0.001], "arm": "fine_ladder",
                            "xmax": 10 ** 11, "peaks": blind}}
    p = _HERE / "results" / "gamma1_trajectory_run2.json"
    p.write_text(json.dumps(res, indent=2))
    print(f"\nwrote {p}")


if __name__ == "__main__":
    main()
