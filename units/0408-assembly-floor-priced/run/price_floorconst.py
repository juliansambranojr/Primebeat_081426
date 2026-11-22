#!/usr/bin/env python3
"""EXPLORATORY, no prereg. The gate priced from the theorem's own constant.

AssemblyFloor.schoenfeldWeak_floor_of_RH (unit 0407): under RH, for x0 >= 16,
   |pi x - Li x| <= (3 floorConst c1 c2 112 0 698 W x0 + 13) sqrt(x) log x,
   x >= max(x0^2, 9),
   floorConst = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                + 18 c1/(x0 sqrt x0) + c2/(sqrt x0 log x0).
c1, c2 are existential in the theorem. Here they are the floors of unit 0405
(`as_built`, `freed` radii; A at its floor, M0, Mc, K0 at zero), and W = 0.
`c_zero` sets c1 = c2 = 0: what the route costs with no contour constant.
The gate is O68's R_of, imported unchanged, k = 1.
"""
import importlib.util, json, math, pathlib
import mpmath
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
spec = importlib.util.spec_from_file_location("o68", ROOT / "O68_weak_bound_tolerance.py")
o68 = importlib.util.module_from_spec(spec); spec.loader.exec_module(o68)
CEIL = o68.O43_EXTENT + 1
L2 = math.log(2)
B1, B2, B3, W = 112, 0, 698, 0
CZ = float(mpmath.zeta(3) / mpmath.zeta(1.5))
A_FLOOR = math.log(136 * 81 / (4 * CZ) + 2) / L2 + 4
W0 = 15 + 88 / L2


def consts(G):
    Ce = G / 2 * A_FLOOR + 8 * W0 + 1 + 1 / L2
    Ch = Ce * 2 * (180 + 1060 / L2) * 3 * 9 / 4
    return 2400 + 2 * Ch + 8 * W0, 13 + 72 * 256 * (36 * Ce + 9 / L2) / 2 + 1


def floor_const(c1, c2, e):
    x0 = 2.0 ** e
    L0 = e * L2
    band = 4 + (16 + 16 * B1 + 16 * B2) / L0 + (8 * B3 + 8 + 4 * W) / L0 ** 2
    return band, 18 * c1 / (x0 * math.sqrt(x0)), c2 / (math.sqrt(x0) * L0)


def depth(C, x0):
    D, Rs = 0, {}
    for d in range(1, 13):
        Rs[d] = o68.R_of(d, C, 1, x0)
        if Rs[d] is not None and Rs[d] <= CEIL and D == d - 1:
            D = d
    return D, Rs


CASES = {"as_built": consts(212127.73526830415), "freed": consts(14080.1),
         "c_zero": (0.0, 0.0)}
out = {"exploratory": True, "prereg": None, "ceiling_rung": CEIL}
for name, (c1, c2) in CASES.items():
    best = None
    for e in [q / 4 for q in range(16, 200)]:
        band, t1, t2 = floor_const(c1, c2, e)
        C = band + t1 + t2
        D, Rs = depth(3 * C + 13, max(4.0 ** e, 9.0))
        key = (min(D, 6), -(Rs[6] or 10 ** 9), D)
        if best is None or key > best[0]:
            best = (key, e, band, t1, t2, C, D, Rs)
    _, e, band, t1, t2, C, D, Rs = best
    out[name] = {"log2_psi_floor": e, "log2_pi_floor": 2 * e,
                 "band_part": round(band, 1), "c1_part": float(f"{t1:.3g}"),
                 "c2_part": round(t2, 1), "floorConst": round(C, 1),
                 "C_pi": round(3 * C + 13, 1), "depth_covered": D,
                 "R6": Rs[6], "margin_rungs": CEIL - Rs[6]}
(HERE / "price_floorconst.json").write_text(json.dumps(out, indent=1) + "\n")
print(json.dumps(out, indent=1))
