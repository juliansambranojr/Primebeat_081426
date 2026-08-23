#!/usr/bin/env python3
"""O59 — EXPLORATORY. No prereg, no verdict.

Run the proved identities forward on real numbers and look at the geometry.

WHY. The Lean tree proves a chain of maps. Nothing has ever pushed data through
them and drawn the result. Every step below is a theorem in
/Users/juliansambrano/GitHub/Primebeat_081426/lean/Transform.lean; this script
evaluates them.

THE IDENTITIES BEING RUN, each with the theorem that licenses it:

  z = b^(-s)                              the map
  ||z|| = b^(-Re s)                       Transform.norm_zmap
  Re s = 1/2  <->  ||z|| = b^(-1/2)       Transform.on_critical_line_iff_norm
  s -> s + tau*i leaves z fixed           Transform.zmap_period_tau
  s -> 1-s  becomes  z -> b^(-1)/z        Transform.zmap_functional_equation
  ||z_s|| * ||z_(1-s)|| = b^(-1)          Transform.zmap_pair_product
  inversion fixes exactly ||z|| = b^(-1/2)  Transform.inversion_fixes_circle
  b^(-1) < ||z|| < 1 for every nontrivial zero
                                          Transform.zeros_in_fundamental_annulus
  the strip is ONE fundamental domain     Transform.strip_is_fundamental_domain

SO EACH ZERO HAS AN ANNULUS COORDINATE:

  radius  = b^(-Re rho)
  angle   = (gamma mod tau_b) * 2*pi/tau_b,  tau_b = 2*pi/log b

The angle is the periodicity zmap_period_tau proves: s and s + tau*i are the
same point of the torus, so gamma is an ANGLE and not a line. That is what makes
this a picture rather than a scatter.

TWO RADIAL SOURCES, kept apart and drawn differently:

  ASSUMED   zeros600.json lists gamma only. Re rho = 1/2 is the hypothesis, so
            those 600 points sit on the circle BY CONSTRUCTION and prove nothing.
  MEASURED  results/per_zero_exponent_run2.json carries beta_hat per zero from
            O58, fitted from prime counts. Six points, radius b^(-beta_hat),
            and those are the only ones carrying information about radius.

WHAT IS ALSO DRAWN. Each zero's inversion partner at b^(-1)/z. By
zmap_pair_product their moduli multiply to b^(-1) whatever the radius is, so a
zero and its partner always straddle the middle circle. On the line they
coincide.

RESOLUTION. The fold packs every gamma into [0, tau_b/2]. Two zeros collide when
their folded positions are closer than the run's resolution dgamma. This script
reports, per base, how many of the 600 fold to within dgamma of a neighbour --
that is when the torus stops resolving and starts smearing.

Reads with: lean/Transform.lean, O57_gamma1_trajectory.py,
O58_per_zero_exponent.py, notes/lab_notebook_2.md entries 84, 88, 95, 97, 99
"""
import json, math, pathlib
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

_HERE = pathlib.Path(__file__).resolve().parent
ZEROS = [float(z) for z in json.load(open(_HERE / "zeros600.json"))]
BASES = [2.0, 3.0, 10.0]
DGAMMA = 2 * math.pi / math.log(10 ** 11 / 1e5)     # O58's fine ladder


def tau(b):
    return 2 * math.pi / math.log(b)


def fold(g, t):
    m = g % t
    return min(m, t - m)


def coord(b, gamma, re_rho):
    """The annulus coordinate of a zero: (radius, angle)."""
    t = tau(b)
    return b ** (-re_rho), fold(gamma, t) * 2 * math.pi / t


def main():
    print("O59 - the proved identities, run on numbers.")
    print("EXPLORATORY, no prereg, no verdict.\n")

    meas = json.load(open(_HERE / "results" / "per_zero_exponent_run2.json"))
    zrows = meas["rows"]["at_zeros"]
    print(f"MEASURED radii from O58 ({len(zrows)} zeros, beta fitted from primes):")
    for w in zrows:
        print(f"   gamma {w['gamma']:9.4f}   beta_hat {w['beta_hat']:.5f}"
              f"   radius b^-beta at b=2: {2 ** (-w['beta_hat']):.6f}")
    print(f"   critical radius 2^(-1/2) = {2 ** -0.5:.6f}\n")

    fig, axes = plt.subplots(1, len(BASES), figsize=(5.2 * len(BASES), 5.6))
    out = {}
    for ax, b in zip(np.atleast_1d(axes), BASES):
        t = tau(b)
        rin, rmid, rout = b ** -1.0, b ** -0.5, 1.0

        # the fundamental annulus and the three circles the theorems name
        th = np.linspace(0, 2 * math.pi, 720)
        for r, st, lab in ((rout, "-", f"|z|=1  (Re s=0)"),
                           (rmid, "--", f"|z|=b^-1/2  (critical)"),
                           (rin, "-", f"|z|=b^-1  (Re s=1)")):
            ax.plot(r * np.cos(th), r * np.sin(th), st, lw=1.4, color="0.35",
                    label=lab)

        # ASSUMED: 600 zeros at Re rho = 1/2
        pts = [coord(b, g, 0.5) for g in ZEROS]
        R = np.array([p[0] for p in pts]); A = np.array([p[1] for p in pts])
        ax.scatter(R * np.cos(A), R * np.sin(A), s=5, alpha=0.30, color="C0",
                   label=f"600 zeros, Re=1/2 ASSUMED")

        # MEASURED: six zeros at the fitted beta, plus inversion partners
        for w in zrows:
            r, a = coord(b, w["gamma"], w["beta_hat"])
            ax.scatter([r * math.cos(a)], [r * math.sin(a)], s=52, color="C3",
                       zorder=5, edgecolor="k", linewidth=0.5)
            rp = b ** -1.0 / r                       # zmap_pair_product
            ax.scatter([rp * math.cos(-a)], [rp * math.sin(-a)], s=28,
                       facecolor="none", edgecolor="C3", zorder=5)
            ax.plot([r * math.cos(a), rp * math.cos(-a)],
                    [r * math.sin(a), rp * math.sin(-a)],
                    color="C3", lw=0.5, alpha=0.5)

        # resolution: folded collisions
        f = sorted(fold(g, t) for g in ZEROS)
        gaps = np.diff(f)
        collide = int((gaps < DGAMMA).sum())
        out[str(b)] = {"tau": t, "r_in": rin, "r_mid": rmid, "r_out": rout,
                       "fold_domain": t / 2, "dgamma": DGAMMA,
                       "n_zeros": len(ZEROS), "collisions": collide,
                       "min_fold_gap": float(gaps.min()),
                       "median_fold_gap": float(np.median(gaps))}
        ax.set_aspect("equal"); ax.set_xticks([]); ax.set_yticks([])
        ax.set_title(f"b = {b:g}   tau = {t:.4f}\n"
                     f"fold domain [0, {t/2:.3f}]   "
                     f"{collide}/{len(ZEROS)-1} gaps < dgamma")
        ax.legend(fontsize=6, loc="upper right", framealpha=0.9)

    fig.suptitle("O59 — zeros pushed through the proved maps onto the fundamental annulus.  "
                 "filled = measured radius (O58), open = inversion partner, faint = Re=1/2 assumed",
                 fontsize=9)
    fig.tight_layout()
    p = _HERE / "results" / "torus_populate.png"
    fig.savefig(p, dpi=150)

    print("RESOLUTION ON THE TORUS  (dgamma = %.4f, O58's fine ladder)" % DGAMMA)
    print(f"   {'base':>6} {'tau':>9} {'domain':>9} {'min gap':>10} {'median':>10} {'collisions':>11}")
    for b in BASES:
        w = out[str(b)]
        print(f"   {b:>6g} {w['tau']:>9.4f} {w['fold_domain']:>9.4f}"
              f" {w['min_fold_gap']:>10.6f} {w['median_fold_gap']:>10.6f}"
              f" {w['collisions']:>7}/{len(ZEROS)-1}")
    print("\n   Larger b -> smaller tau -> smaller fold domain -> more collisions.")
    print("   The torus resolves the zeros only while the fold domain stays wide")
    print("   relative to dgamma. That is Nyquist, in the angular coordinate.")

    (_HERE / "results" / "torus_populate.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O59_torus_populate.py",
         "exploratory": True, "prereg": None,
         "params": {"bases": BASES, "n_zeros": len(ZEROS), "dgamma": DGAMMA,
                    "measured_source": "results/per_zero_exponent_run2.json"},
         "measured_radii": [{"gamma": w["gamma"], "beta_hat": w["beta_hat"],
                             "radius_b2": 2 ** (-w["beta_hat"])} for w in zrows],
         "rows": out}, indent=2))
    print(f"\nwrote {p}")
    print(f"wrote {_HERE / 'results' / 'torus_populate.json'}")


if __name__ == "__main__":
    main()
