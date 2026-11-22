#!/usr/bin/env python3
"""EXPLORATORY, no prereg. The gate priced from the kernel-checked ceilings.

RouteNum.relErrWindow_route_num (unit 0419): under RH, for x0 >= 16, the pi-side
constant is routeConst x0 = 3 floorConstSplit c1n c3n c4n 112 0 698 0 x0 + 13,
   floorConstSplit = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                     + 18 c1/(x0 sqrt x0) + c3/(sqrt x0 log x0)
                     + c4 x0^(-1/4)/sqrt x0,
on sqrt(x) log x, x >= x0^2. The three constants are taken at the ceilings
proved in RouteNum: c1n <= 88216610000, c3n <= 15, c4n <= 6468930000.
floorConstSplit is increasing in each, so the result is an upper bound on the
theorem's constant. The gate is O68's R_of, imported unchanged, k = 1; it is a
script's gate and not the Lean gate.
"""
import importlib.util, json, math, pathlib
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
spec = importlib.util.spec_from_file_location("o68", ROOT / "O68_weak_bound_tolerance.py")
o68 = importlib.util.module_from_spec(spec); spec.loader.exec_module(o68)
CEIL = o68.O43_EXTENT + 1
L2 = math.log(2)
C1, C3, C4 = 88216610000.0, 15.0, 6468930000.0
B1, B2, B3, W = 112, 0, 698, 0


def terms(e):
    x0 = 2.0 ** e
    L0 = e * L2
    S0 = math.sqrt(x0)
    return (4 + (16 + 16 * B1 + 16 * B2) / L0 + (8 * B3 + 8 + 4 * W) / L0 ** 2,
            18 * C1 / (x0 * S0), C3 / (S0 * L0), C4 * x0 ** -0.25 / S0)


def depth(C, x0):
    D, Rs = 0, {}
    for d in range(1, 13):
        Rs[d] = o68.R_of(d, C, 1, x0)
        if Rs[d] is not None and Rs[d] <= CEIL and D == d - 1:
            D = d
    return D, Rs


best = None
for e in [q / 4 for q in range(16, 200)]:
    t = terms(e)
    C = sum(t)
    D, Rs = depth(3 * C + 13, max(4.0 ** e, 9.0))
    key = (min(D, 6), -(Rs[6] or 10 ** 9), D)
    if best is None or key > best[0]:
        best = (key, e, t, C, D, Rs)
_, e, t, C, D, Rs = best
out = {"exploratory": True, "prereg": None, "ceiling_rung": CEIL,
       "c1": C1, "c3": C3, "c4": C4,
       "log2_psi_floor": e, "log2_pi_floor": 2 * e,
       "band_part": round(t[0], 1), "top_part": float(f"{t[1]:.3g}"),
       "log_part": float(f"{t[2]:.3g}"), "left_part": round(t[3], 1),
       "floorConstSplit": round(C, 1), "routeConst": round(3 * C + 13, 1),
       "depth_covered": D, "R6": Rs[6], "margin_rungs": CEIL - Rs[6]}
(HERE / "price_num.json").write_text(json.dumps(out, indent=1) + "\n")
print(json.dumps(out, indent=1))
