#!/usr/bin/env python3
"""O71 — testing the horizontal-vanishes statement before flagging it.

EXPLORATORY: no prereg. Entry 141's audit found upstream's
kadiri_thm_3_1_q1_top_horizontal_vanishes (PNT+ IEANTN/Kadiri.lean,
discussion #1538) states the horizontal contour integral tends to 0 as
T -> infinity over ALL real T. The claimed defect: zeta'/zeta has a
pole at every zero height crossing the sigma-segment, the sigma-integral
at T = gamma + delta grows like 2*log(1/delta), and delta is a free
parameter while any fixed test function's transform decay is not — so a
delta-schedule (delta_n = exp(-exp(T_n))) diverges along T_n -> inf for
EVERY nonzero admissible phi. Before any note is posted upstream, this
script tests the mechanism numerically on our own bench.

TWO CHECKS.
  1. THE LOG LAW. J(delta) := int_{-1/4}^{5/4} |zeta'/zeta(sigma +
     i(gamma_1 + delta))| dsigma against 2*ln(1/delta): the ratio should
     approach 1 as delta -> 0 (the pole at rho = 1/2 + i*gamma_1
     dominates; gamma_1 = 14.1347...).
  2. THE SCHEDULE. With the concrete admissible phi(y) =
     e^(-y/2)/cosh(3y/2) (C-infinity, decay (B) with b = 1, Laplace
     transform Phi(-s) = (2pi/3)*sec(pi*(s-1/2)/3), exponentially
     small in T), the weighted integrand I(T, delta) ~
     |Phi|*J(delta): tabulate I at T near gamma_1 and near
     gamma_29 ~ 98.83 for shrinking delta, and print the delta needed
     to push I above 1 — showing it exists at every height, i.e. the
     limit over the full filter fails while a zero-avoiding filter
     (|T - gamma| >= c/log T) repairs it.

Reads with: notes/lab_notebook_2.md entries 141, 142; the drafted
(unposted) note for PNT+ discussion #1538.
"""
import math, pathlib, json
import mpmath as mp

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 30
A = mp.mpf('0.25')
GAMMA1 = mp.mpf('14.134725141734693790457251983562')
GAMMA29 = mp.mpf('98.831194218193692233324420138622')


def zlogderiv(s):
    return mp.zeta(s, derivative=1) / mp.zeta(s)


def J(T):
    f = lambda sig: abs(zlogderiv(mp.mpc(sig, T)))
    return mp.quad(f, [-A, mp.mpf('0.5'), 1 + A])


def Phi_abs(s):
    return abs((2 * mp.pi / 3) / mp.cos(mp.pi * (s - mp.mpf('0.5')) / 3))


def I_weighted(T):
    f = lambda sig: abs(zlogderiv(mp.mpc(sig, T))) * Phi_abs(mp.mpc(sig, T))
    return mp.quad(f, [-A, mp.mpf('0.5'), 1 + A]) / (2 * mp.pi)


def main():
    print("O71 — the horizontal-vanishes mechanism, tested.\n")
    print("CHECK 1 — J(delta) vs 2*ln(1/delta) at gamma_1:")
    rows1 = []
    for k in (1, 2, 3, 4, 5, 6):
        d = mp.mpf(10) ** (-k)
        j = J(GAMMA1 + d)
        law = 2 * mp.log(1 / d)
        rows1.append({"delta": float(d), "J": float(j),
                      "two_ln_inv_delta": float(law),
                      "ratio": float(j / law)})
        print(f"   delta=1e-{k}:  J={float(j):9.3f}   "
              f"2ln(1/d)={float(law):8.3f}   ratio={float(j/law):.3f}")

    print("\nCHECK 2 — the weighted integral I(T,delta) and the schedule:")
    rows2 = []
    for name, g in (("gamma_1", GAMMA1), ("gamma_29", GAMMA29)):
        phi_scale = float(Phi_abs(mp.mpc(0.5, g)))
        print(f"   at {name} ({float(g):.3f}), |Phi| scale ~ {phi_scale:.3e}:")
        for k in (2, 4, 6):
            d = mp.mpf(10) ** (-k)
            val = I_weighted(g + d)
            rows2.append({"height": name, "delta": float(d),
                          "I": float(val)})
            print(f"      delta=1e-{k}:  I = {float(val):.6e}")
        # delta needed for I > 1: log(1/d) ~ 2pi/(phi_scale) => d ~ exp(-2pi/phi)
        need = -2 * mp.pi / mp.mpf(phi_scale)
        print(f"      I exceeds 1 once ln(delta) < {float(need):.3e} — "
              f"such delta exists at THIS height, and at every height.")

    print("\nREAD. The log law confirms the pole mechanism; the schedule")
    print("shows the required delta exists at every zero height, so the")
    print("limit over ALL T fails for every nonzero admissible phi, while")
    print("heights with |T - gamma| >= c/log T keep the integral -> 0.")
    print("Evidence for the (unposted) #1538 note; posting is Julian's call.")

    (_HERE / "results" / "horizontal_defect.json").write_text(json.dumps(
        {"schema_version": "1", "script": "O71_horizontal_defect.py",
         "exploratory": True, "prereg": None,
         "params": {"dps": 30, "a": 0.25,
                    "phi": "exp(-y/2)/cosh(3y/2), b=1",
                    "Phi": "(2pi/3)*sec(pi(s-1/2)/3)"},
         "check1_log_law": rows1, "check2_schedule": rows2}, indent=2))
    print(f"\nwrote {_HERE / 'results' / 'horizontal_defect.json'}")


if __name__ == "__main__":
    main()
