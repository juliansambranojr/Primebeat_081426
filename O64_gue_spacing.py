#!/usr/bin/env python3
"""O64 — EXPLORATORY. No prereg, no verdict.

Does the spectrum measured from prime counts inherit the zeros' repulsion?

WHY. Montgomery's pair-correlation conjecture — the zeta zeros repel like GUE
eigenvalues — is the standing physics link to RH, and nothing in this tree has
touched it. This bench detects zeros out of prime counts (O50, O57, O58). The
question nobody has asked: do the DETECTED peaks show the repulsion, at the
resolution this instrument has?

THE CONFOUND, WHICH IS THE DESIGN. Finite resolution fakes level repulsion:
two frequencies closer than dgamma merge into one peak, so ANY spectrum read
through this pipeline is repelled at short range by the instrument alone. A
bare histogram of measured spacings proves nothing.

So: three arms through ONE identical pipeline.

  real       the actual prime residual on O50's fine ladder
  model      synthetic residual built from the TRUE zeros (explicit-formula
             shape: amplitude x^(1/2)/|rho| per mode, actual gamma_n)
  poisson    synthetic residual with POISSON-placed frequencies at the zeros'
             own unfolded density, same amplitudes, random phases

If the pipeline preserves the model/poisson distinction, reading the real arm
is meaningful; if it does not, the honest answer is "unmeasurable at this
resolution" and that is the result.

THE STATISTIC. Peaks above 5x median, nearest-neighbour spacings UNFOLDED by
the zeros' density rho(g) = log(g/2pi)/2pi, so mean spacing is 1. Reported per
arm: n peaks, mean unfolded spacing, fraction below s = 0.5 (GUE ~ 0.106,
Poisson ~ 0.393), and KS distances to the Wigner surmise and to exp(-s).

REFERENCE VALUES. Wigner surmise (GUE): p(s) = (32/pi^2) s^2 exp(-4 s^2 / pi).
Poisson: p(s) = exp(-s). The 600 true zeros unfolded directly (no instrument)
give the calibration row.

Reads with: O50_deep_ladder_spectrum.py, O57_gamma1_trajectory.py, zeros600.json,
notes/lab_notebook_2.md entries 93-95, 102
"""
import json, math, pathlib
import numpy as np
import mpmath as mp
from primecountpy import prime_pi

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
X0, RATIO, XMAX = 1e5, 1.002, 10 ** 11
GLO, GHI, GSTEP = 10.0, 500.0, 0.005
PEAK_FACTOR = 5.0
RNG = np.random.default_rng(2026)
ZEROS = np.array([float(z) for z in json.load(open(_HERE / "zeros600.json"))])


def density(g):
    """Unfolded density of zeta zeros at height g."""
    return np.log(np.asarray(g) / (2 * math.pi)) / (2 * math.pi)


def build_ladder():
    n = int(math.log(XMAX / X0) / math.log(RATIO))
    xs = np.array([X0 * RATIO ** j for j in range(n + 1)])
    return xs


def real_residual(xs):
    c = np.array([prime_pi(int(xs[j + 1])) - prime_pi(int(xs[j]))
                  for j in range(len(xs) - 1)], dtype=float)
    L = np.array([float(mp.li(mp.mpf(xs[j + 1])) - mp.li(mp.mpf(xs[j])))
                  for j in range(len(xs) - 1)])
    xm = xs[:-1]
    return (c - L) / (np.sqrt(xm) / np.log(xm))


def synth_residual(xs, gammas, phases):
    """Explicit-formula-shaped synthetic: sum of cos(g log x + phase)/|rho|,
    on the same normalisation as the real arm."""
    xm = xs[:-1]
    lx = np.log(xm)
    eh = np.zeros(len(xm))
    for g, ph in zip(gammas, phases):
        eh += np.cos(g * lx + ph) / abs(0.5 + 1j * g)
    return eh * 2  # explicit formula's factor of 2 over conjugate pairs; scale free


def spectrum_peaks(eh, lx):
    """The O50 statistic; returns peak gamma positions above PEAK_FACTOR x median."""
    w = np.hanning(len(eh))
    z = (eh - eh.mean()) * w
    gam = np.arange(GLO, GHI, GSTEP)
    P = np.empty(len(gam))
    CH = 4000
    for i in range(0, len(gam), CH):
        gc = gam[i:i + CH]
        P[i:i + CH] = np.abs(np.exp(-1j * np.outer(gc, lx)) @ z) ** 2
    med = np.median(P)
    loc = np.where((P[1:-1] > P[:-2]) & (P[1:-1] > P[2:]))[0] + 1
    pk = loc[P[loc] > PEAK_FACTOR * med]
    return gam[pk], P, med


def unfolded_spacings(gs):
    gs = np.sort(gs)
    mids = 0.5 * (gs[1:] + gs[:-1])
    return np.diff(gs) * density(mids)


def wigner_cdf(s):
    return 1 - np.exp(-4 * np.asarray(s) ** 2 / math.pi)


def poisson_cdf(s):
    return 1 - np.exp(-np.asarray(s))


def ks(s, cdf):
    s = np.sort(s)
    n = len(s)
    emp = np.arange(1, n + 1) / n
    return float(np.max(np.abs(emp - cdf(s))))


def frac_below(s, cut=0.5):
    return float(np.mean(np.asarray(s) < cut))


def poisson_frequencies():
    """Poisson process on (GLO, GHI) with the zeros' own density."""
    out, g = [], GLO
    while True:
        g += RNG.exponential(1.0 / density(g))
        if g >= GHI:
            break
        out.append(g)
    return np.array(out)


def report(name, s):
    print(f"   {name:>10}  n={len(s):>4}  mean s {np.mean(s):>6.3f}"
          f"  frac<0.5 {frac_below(s):>6.3f}"
          f"  KS-Wigner {ks(s, wigner_cdf):>6.3f}"
          f"  KS-Poisson {ks(s, poisson_cdf):>6.3f}")
    return {"n": len(s), "mean": float(np.mean(s)), "frac_lt_05": frac_below(s),
            "ks_wigner": ks(s, wigner_cdf), "ks_poisson": ks(s, poisson_cdf)}


def main():
    print("O64 — spacing statistics of the measured spectrum.")
    print("EXPLORATORY, no prereg, no verdict.")
    print(f"ladder x0={X0:g} ratio={RATIO} xmax={XMAX:.0e};"
          f" grid ({GLO},{GHI}) step {GSTEP}; peaks > {PEAK_FACTOR}x median\n")
    print("reference: GUE frac<0.5 ~ 0.106, Poisson frac<0.5 ~ 0.393\n")

    xs = build_ladder()
    lx = np.log(xs[:-1])
    dg = 2 * math.pi / (lx[-1] - lx[0])
    zin = ZEROS[(ZEROS > GLO) & (ZEROS < GHI)]
    print(f"{len(xs)-1} blocks, dgamma = {dg:.4f};"
          f" {len(zin)} true zeros in range, mean gap {np.mean(np.diff(zin)):.3f}\n")

    out = {}
    print("CALIBRATION — no instrument:")
    out["true_zeros_direct"] = report("true-dir", unfolded_spacings(zin))
    pf = poisson_frequencies()
    out["poisson_direct"] = report("poiss-dir", unfolded_spacings(pf))
    print()

    print("THROUGH THE PIPELINE:")
    arms = {
        "model": synth_residual(xs, zin, np.zeros(len(zin))),
        "poisson": synth_residual(xs, pf, RNG.uniform(0, 2 * math.pi, len(pf))),
        "real": real_residual(xs),
    }
    peaks = {}
    for name in ("model", "poisson", "real"):
        pg, P, med = spectrum_peaks(arms[name], lx)
        peaks[name] = pg
        s = unfolded_spacings(pg)
        out[name] = report(name, s)
        out[name]["n_input"] = int(len(zin) if name != "poisson" else len(pf))
    print()

    d_mp = abs(out["model"]["frac_lt_05"] - out["poisson"]["frac_lt_05"])
    print(f"pipeline discrimination |model - poisson| in frac<0.5: {d_mp:.3f}")
    if d_mp < 0.05:
        print("   -> the instrument does NOT preserve the distinction at this")
        print("      resolution; the real arm's statistics are uninformative.")
    else:
        which = ("model" if abs(out["real"]["frac_lt_05"] - out["model"]["frac_lt_05"])
                 < abs(out["real"]["frac_lt_05"] - out["poisson"]["frac_lt_05"])
                 else "poisson")
        print(f"   -> distinction survives; the real arm sits nearer the {which} arm.")

    (_HERE / "results" / "gue_spacing.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O64_gue_spacing.py",
         "exploratory": True, "prereg": None,
         "params": {"x0": X0, "ratio": RATIO, "xmax": XMAX,
                    "grid": [GLO, GHI, GSTEP], "peak_factor": PEAK_FACTOR,
                    "seed": 2026, "dgamma": dg},
         "reference": {"gue_frac_lt_05": 0.106, "poisson_frac_lt_05": 0.393},
         "rows": out,
         "n_peaks": {k: int(len(v)) for k, v in peaks.items()}}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'gue_spacing.json'}")


if __name__ == "__main__":
    main()
