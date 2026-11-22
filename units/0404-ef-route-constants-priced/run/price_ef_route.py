#!/usr/bin/env python3
"""EXPLORATORY, no prereg. Prices the explicit-formula route to the census.

Imports O68_weak_bound_tolerance.py unchanged for R_of. The route:
  Assembly.psiWeak_of_RH_EF_NT   |psi - x| <= C sqrt(x) log^2 x, x >= 16,
      C = 9 c1 + c2 + 28 + 16 b1 + 16 b2 + 8 b3 + 4 W
  Glue.explicit_formula_poly     c1 = 2400 + 2 Ch + Cs, c2 = 13 + Cl + K0/2
  ArgCount.rvM_crude             (b1, b2, b3) = (112, 0, 698)
  PsiToPi.schoenfeldWeak_of_psiWeak   C_pi = 3 C + 13, k - 1, x0 = max(x0^2, 9)
Lower bounds on the existentials, each read from the `refine` that builds it:
  EdgeBound.gz_partial_fraction  C1 = G/2 * A, A = log D0/log 2 + 4, D0 > 2
  EdgeBound.ball_order_sum_le    C2 = M0/log 2 + 8 W0 + 1, M0 >= 0
  EdgeBound.edge_bound_core      Ce = C1 + C2 + 1/log 2
  Glue.zeta_logderiv_good_bound  Cp = Ce * 2 * (180 + 1060/log 2)
  Glue.edge_horizontal_bound     Ch = Cp * 3 * (9/4)
  Glue.band_order_sum_le         Cs = 8 W0, W0 = 15 + 88/log 2
Cl, K0, W are dropped (each is proved >= 0), so every figure is a floor.
"""
import importlib.util, json, math, pathlib
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
spec = importlib.util.spec_from_file_location("o68", ROOT / "O68_weak_bound_tolerance.py")
o68 = importlib.util.module_from_spec(spec); spec.loader.exec_module(o68)
CEIL = o68.O43_EXTENT + 1
X0 = 256.0  # max(16^2, 9)


def depth(C, k, x0=X0):
    Rs = {d: o68.R_of(d, C, k, x0) for d in range(1, o68.DMAX + 1)}
    D = 0
    for d in range(1, o68.DMAX + 1):
        if Rs[d] is not None and Rs[d] <= CEIL:
            D = d
        else:
            break
    return D, Rs


def boundary(k):
    lo, hi = 1.0, 1e12
    for _ in range(200):
        mid = math.sqrt(lo * hi)
        if depth(mid, k)[0] >= 6:
            lo = mid
        else:
            hi = mid
    return lo


L2 = math.log(2)
known_psi = 9 * 2400 + 13 + 28 + 16 * 112 + 16 * 0 + 8 * 698
known_pi = 3 * known_psi + 13
d_known, R_known = depth(known_pi, 1)
ceil_pi_k1 = boundary(1)
ceil_psi_k1 = (ceil_pi_k1 - 13) / 3
G = (16 * (23 / 25) ** 2 / ((23 / 25) - (22 / 25)) ** 3
     + 1 / (((49 / 50) ** 2 / (19 / 20) - 19 / 20) * math.log((49 / 50) / (19 / 20))))
W0 = 15 + 88 / L2
C1 = G / 2 * 5
C2 = 8 * W0 + 1
Ce = C1 + C2 + 1 / L2
Cp = Ce * 2 * (180 + 1060 / L2)
Ch = Cp * 3 * 9 / 4
Cs = 8 * W0
c1 = 2400 + 2 * Ch + Cs
floor_psi = 9 * c1 + 13 + 28 + 16 * 112 + 8 * 698
floor_pi = 3 * floor_psi + 13
d_floor, R_floor = depth(floor_pi, 1)
out = {
    "exploratory": True, "prereg": None, "x0": X0, "ceiling_rung": CEIL,
    "known_numerals_psi": known_psi, "known_numerals_pi": known_pi,
    "known_depth_covered": d_known, "known_R6": R_known[6],
    "ceiling_pi_k1": round(ceil_pi_k1, 1), "ceiling_psi_k1": round(ceil_psi_k1, 1),
    "headroom_psi": round(ceil_psi_k1 - known_psi, 1),
    "G_floor": round(G, 1), "W0": round(W0, 3), "Cs": round(Cs, 1),
    "Ce_floor": round(Ce, 1), "Cp_floor": float(f"{Cp:.4g}"),
    "Ch_floor": float(f"{Ch:.4g}"), "floor_psi": float(f"{floor_psi:.4g}"),
    "floor_pi": float(f"{floor_pi:.4g}"),
    "floor_depth_covered": d_floor, "floor_R1": R_floor[1], "floor_R6": R_floor[6],
    "floor_over_ceiling": float(f"{floor_pi / ceil_pi_k1:.3g}"),
    "gap_factor": round(2 * (180 + 1060 / L2), 1),
}
(HERE / "price_ef_route.json").write_text(json.dumps(out, indent=1) + "\n")
for k, v in out.items():
    print(f"{k:<24} {v}")
