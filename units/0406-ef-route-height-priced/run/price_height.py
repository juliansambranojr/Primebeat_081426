#!/usr/bin/env python3
"""EXPLORATORY, no prereg. The explicit-formula route priced over the height T.

Proved pieces, each read from its statement:
  Glue.explicit_formula_poly  for 16 <= x, 2 <= T <= x^2:
      |psi x - x + Z(x,T)| <= c1 x log^2(xT)/T + c2 log x
  Assembly.norm_zeroPartialSum_le_logsq  under RH, T = 2^(K+1):
      |Z(x,T)| <= 2 sqrt(x) (2 [log2/(2 pi) (K+1)(K+2) + 3 (K+1)/pi
                                + 2 (b1 log T + b3 + 7/8)] + 2 W)
  ArgCount.rvM_crude  (b1, b2, b3) = (112, 0, 698)
  PsiToPi.schoenfeldWeak_of_psiWeak  C sqrt(t) log^2 t on [x0, oo) gives
      (3 C + 13) sqrt(x) log x on [x0^2, oo)
The model: T the power of two in (x^a/2, x^a], 1 <= a <= 2, so log T <= a L,
x/T <= 2 x^(1-a), log(xT) <= (1+a) L, with L = log x. Dividing by sqrt(x) L^2
every term is decreasing in x, so the constant on [x0, oo) is its value at x0:
  C_psi(x0, a) = 4 [ a (a L0 + log 2) / (2 pi log 2 L0) + 3 a / (pi log 2 L0)
                     + 2 (b1 a / L0 + (b3 + 7/8) / L0^2) ]
                 + 2 c1 (1+a)^2 x0^(1/2 - a) + c2 / (sqrt(x0) L0)        (W = 0)
Assembly.psiWeak_of_RH_EF_NT is the case a = 1 with each term then bounded by
its L^2 multiple at L >= 1 and the last two by sqrt(x) L^2: 7404 + 9 c1 + c2.
c1, c2 are floors, as in unit 0405: `as_built` and `freed` radii.
The gate is O68's R_of, imported unchanged, k = 1, floor x0^2.
"""
import importlib.util, json, math, pathlib
import mpmath
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
spec = importlib.util.spec_from_file_location("o68", ROOT / "O68_weak_bound_tolerance.py")
o68 = importlib.util.module_from_spec(spec); spec.loader.exec_module(o68)
CEIL = o68.O43_EXTENT + 1
L2 = math.log(2)
B1, B3 = 112, 698
CZ = float(mpmath.zeta(3) / mpmath.zeta(1.5))
A_FLOOR = math.log(136 * 81 / (4 * CZ) + 2) / L2 + 4
W0 = 15 + 88 / L2


def consts(G):
    Ce = G / 2 * A_FLOOR + 8 * W0 + 1 + 1 / L2
    Ch = Ce * 2 * (180 + 1060 / L2) * 3 * 9 / 4
    c1 = 2400 + 2 * Ch + 8 * W0
    c2 = 13 + 72 * 256 * (36 * Ce + 9 / L2) / 2 + 1
    return c1, c2


def parts(e, a, c1, c2):
    x0 = 2.0 ** e
    L0 = e * L2
    zero = 4 * (a * (a * L0 + L2) / (2 * math.pi * L2 * L0) + 3 * a / (math.pi * L2 * L0)
                + 2 * (B1 * a / L0 + (B3 + 7 / 8) / L0 ** 2))
    t1 = 2 * c1 * (1 + a) ** 2 * x0 ** (0.5 - a)
    t2 = c2 / (math.sqrt(x0) * L0)
    return zero, t1, t2


def depth(C, x0):
    D, Rs = 0, {}
    for d in range(1, 13):
        Rs[d] = o68.R_of(d, C, 1, x0)
        if Rs[d] is not None and Rs[d] <= CEIL and D == d - 1:
            D = d
    return D, Rs


CASES = {"as_built": 212127.73526830415, "freed": 14080.1}
out = {"exploratory": True, "prereg": None, "ceiling_rung": CEIL,
       "A_floor": round(A_FLOOR, 2)}
for name, G in CASES.items():
    c1, c2 = consts(G)
    out[name] = {"c1_floor": float(f"{c1:.4g}"), "c2_floor": float(f"{c2:.4g}")}
    for a in (1.0, 1.5, 2.0):
        best = None
        for e in [q / 4 for q in range(16, 200)]:
            z, t1, t2 = parts(e, a, c1, c2)
            Cpsi = z + t1 + t2
            D, Rs = depth(3 * Cpsi + 13, 4.0 ** e)
            key = (min(D, 6), -(Rs[6] or 10 ** 9))
            if best is None or key > best[0]:
                best = (key, e, z, t1, t2, Cpsi, D, Rs)
        _, e, z, t1, t2, Cpsi, D, Rs = best
        out[name][f"a{a:g}".replace(".", "p")] = {
            "log2_psi_floor": e, "log2_pi_floor": 2 * e,
            "zero_part": round(z, 1), "c1_part": float(f"{t1:.3g}"),
            "c2_part": round(t2, 1), "C_psi": round(Cpsi, 1),
            "depth_covered": D, "R6": Rs[6], "margin_rungs": CEIL - Rs[6]}
(HERE / "price_height.json").write_text(json.dumps(out, indent=1) + "\n")
print(json.dumps(out, indent=1))
