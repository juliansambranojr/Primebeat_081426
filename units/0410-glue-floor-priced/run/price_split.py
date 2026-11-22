#!/usr/bin/env python3
"""EXPLORATORY, no prereg. The gate priced from floorConstSplit (unit 0409).

GlueFloor.schoenfeldWeak_floor_split_of_RH: under RH, for x0 >= 16,
   |pi x - Li x| <= (3 floorConstSplit c1 c3 c4 112 0 698 W x0 + 13) sqrt(x) log x,
   x >= max(x0^2, 9),
   floorConstSplit = 4 + (16 + 16 b1 + 16 b2)/log x0 + (8 b3 + 8 + 4 W)/log^2 x0
                     + 18 c1/(x0 sqrt x0) + c3/(sqrt x0 log x0)
                     + c4 x0^(-1/4)/sqrt x0.
c1, c3, c4 are existential in the theorem. Here, as floors:
  c1 = 2400 + 2 Ch + Cs          (Glue.explicit_formula_split)
  c3 = 13 + K0/2, K0 = 0
  c4 = 72 D, D = 36 Ce + 9 (Mc + 1)/log 2, Mc = 0
with Ce, Ch, Cs as in unit 0405 (`as_built`, `freed` radii; A at its floor,
M0 = 0), and W = 0. `c_zero` sets c1 = c3 = c4 = 0.
`classical` puts K0 = log(2 pi) and Mc = 3 (a guess at the size of the
supremum on the short segment, proved nowhere) to show how little they move.
`as_built_slack_factor`: the largest common multiple of the as-built c1, c3, c4
at which some floor still covers depth six.
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


def consts(G, K0=0.0, Mc=0.0):
    Ce = G / 2 * A_FLOOR + 8 * W0 + 1 + 1 / L2
    Ch = Ce * 2 * (180 + 1060 / L2) * 3 * 9 / 4
    return (2400 + 2 * Ch + 8 * W0, 13 + K0 / 2,
            72 * (36 * Ce + 9 * (Mc + 1) / L2))


def terms(c, e):
    c1, c3, c4 = c
    x0 = 2.0 ** e
    L0 = e * L2
    S0 = math.sqrt(x0)
    band = 4 + (16 + 16 * B1 + 16 * B2) / L0 + (8 * B3 + 8 + 4 * W) / L0 ** 2
    return band, 18 * c1 / (x0 * S0), c3 / (S0 * L0), c4 * x0 ** -0.25 / S0


def depth(C, x0):
    D, Rs = 0, {}
    for d in range(1, 13):
        Rs[d] = o68.R_of(d, C, 1, x0)
        if Rs[d] is not None and Rs[d] <= CEIL and D == d - 1:
            D = d
    return D, Rs


G_BUILT, G_FREED = 212127.73526830415, 14080.1
CASES = {"as_built": consts(G_BUILT), "freed": consts(G_FREED),
         "classical": consts(G_BUILT, K0=math.log(2 * math.pi), Mc=3.0),
         "c_zero": (0.0, 0.0, 0.0)}
out = {"exploratory": True, "prereg": None, "ceiling_rung": CEIL}
for name, c in CASES.items():
    best = None
    for e in [q / 4 for q in range(16, 200)]:
        t = terms(c, e)
        C = sum(t)
        D, Rs = depth(3 * C + 13, max(4.0 ** e, 9.0))
        key = (min(D, 6), -(Rs[6] or 10 ** 9), D)
        if best is None or key > best[0]:
            best = (key, e, t, C, D, Rs)
    _, e, t, C, D, Rs = best
    out[name] = {"c4": float(f"{c[2]:.4g}"), "log2_psi_floor": e,
                 "log2_pi_floor": 2 * e, "band_part": round(t[0], 1),
                 "top_part": float(f"{t[1]:.3g}"), "log_part": float(f"{t[2]:.3g}"),
                 "left_part": round(t[3], 1), "floorConstSplit": round(C, 1),
                 "C_pi": round(3 * C + 13, 1), "depth_covered": D,
                 "R6": Rs[6], "margin_rungs": CEIL - Rs[6]}


def covers(c):
    for e in [q / 4 for q in range(16, 200)]:
        if depth(3 * sum(terms(c, e)) + 13, max(4.0 ** e, 9.0))[0] >= 6:
            return True
    return False


# how far the as-built constants can all be multiplied before depth six is lost
c = CASES["as_built"]
lo, hi = 1.0, 1e12
for _ in range(60):
    mid = math.sqrt(lo * hi)
    if covers(tuple(mid * v for v in c)):
        lo = mid
    else:
        hi = mid
out["as_built_slack_factor"] = float(f"{lo:.3g}")
(HERE / "price_split.json").write_text(json.dumps(out, indent=1) + "\n")
print(json.dumps(out, indent=1))
