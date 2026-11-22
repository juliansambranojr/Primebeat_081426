#!/usr/bin/env python3
"""EXPLORATORY, no prereg. The explicit-formula route with its lost sqrt(x) kept.

Assembly.psiWeak_of_RH_EF_NT proves, inside its proof (`htotal`),
   |psi x - x| <= (9 c1 + c2) L^2 + 2 S (2 (7 + 4 b1 + 4 b2 + 2 b3) L^2 + 2 W),
S = sqrt x, L = log x, and then `assembly_arith` bounds L^2 by S L^2. Kept,
the bound for x >= x0 reads
   |psi x - x| <= (28 + 16 b1 + 16 b2 + 8 b3 + 4 W + (9 c1 + c2)/sqrt(x0)) S L^2.
This script prices that with O68's R_of (imported unchanged), k = 1 on the pi
side, pi floor x0^2 (PsiToPi.schoenfeldWeak_of_psiWeak), for two cases:
  as_built   radii 22/25 < 23/25 < 19/20 < 49/50 (EdgeBound.gz_partial_fraction)
  freed      r' = 7/8 (forced: rescale 2, reach -1/4), r < R' < R < 1 optimised
Floors only: M0, Mc, K0, W taken as 0; A = log D0/log 2 + 4 with
D0 = Cb*81/(4 czeta) + 2, Cb >= 136 (ZetaGrowth.sq_zeta_band_bound: max 135 CK + 1)
and czeta = zeta(3)/zeta(3/2) evaluated by mpmath (a value, proved nowhere here).
  Glue.edge_left_bound   Cl = 72*256*D/2 + 1, D = 36 Ce + 9 (Mc + 1)/log 2
"""
import importlib.util, json, math, pathlib
HERE = pathlib.Path(__file__).resolve().parent
ROOT = HERE.parents[2]
spec = importlib.util.spec_from_file_location("o68", ROOT / "O68_weak_bound_tolerance.py")
o68 = importlib.util.module_from_spec(spec); spec.loader.exec_module(o68)
CEIL = o68.O43_EXTENT + 1
L2 = math.log(2)
MAIN = 28 + 16 * 112 + 8 * 698  # the sqrt(x) log^2 x part, W = 0
import mpmath
CZ = float(mpmath.zeta(3) / mpmath.zeta(1.5))
A_FLOOR = math.log(136 * 81 / (4 * CZ) + 2) / L2 + 4


def Gof(rp, r, Rp, R):
    return 16 * r * r / (r - rp) ** 3 + 1 / ((R * R / Rp - Rp) * math.log(R / Rp))


def loose(G):
    W0 = 15 + 88 / L2
    Ce = G / 2 * A_FLOOR + 8 * W0 + 1 + 1 / L2
    Ch = Ce * 2 * (180 + 1060 / L2) * 3 * 9 / 4
    c1 = 2400 + 2 * Ch + 8 * W0
    Cl = 72 * 256 * (36 * Ce + 9 / L2) / 2 + 1
    c2 = 13 + Cl
    return Ce, 9 * c1 + c2


def depth(C, x0):
    D = 0
    Rs = {}
    for d in range(1, 9):
        Rs[d] = o68.R_of(d, C, 1, x0)
        if Rs[d] is not None and Rs[d] <= CEIL and D == d - 1:
            D = d
    return D, Rs


def scan(Lz):
    best = None
    for e in [x / 4 for x in range(16, 200)]:  # psi floor 2^e
        x0 = 2.0 ** e
        Cpsi = MAIN + Lz / math.sqrt(x0)
        D, Rs = depth(3 * Cpsi + 13, x0 * x0)
        key = (D, -(Rs[6] or 10 ** 9))
        if best is None or key > best[0]:
            best = (key, e, Cpsi, D, Rs)
    return best


G_built = Gof(22 / 25, 23 / 25, 19 / 20, 49 / 50)
gbest = None
N = 400
for i in range(1, N):
    r = 7 / 8 + (1 / 8) * i / N
    for j in range(1, 40):
        Rp = r + (1 - r) * j / 40
        for k in range(1, 40):
            R = Rp + (1 - Rp) * k / 40
            g = Gof(7 / 8, r, Rp, R)
            if gbest is None or g < gbest[0]:
                gbest = (g, r, Rp, R)
out = {"exploratory": True, "prereg": None, "ceiling_rung": CEIL, "main_psi": MAIN, "A_floor": round(A_FLOOR, 2)}
for name, G in (("as_built", G_built), ("freed", gbest[0])):
    Ce, Lz = loose(G)
    _, e, Cpsi, D, Rs = scan(Lz)
    out[name] = {"G": round(G, 1), "Ce_floor": round(Ce, 1),
                 "loose_floor": float(f"{Lz:.4g}"),
                 "best_log2_psi_floor": e, "best_log2_pi_floor": 2 * e,
                 "C_psi_at_best": round(Cpsi, 1), "depth_covered": D,
                 "R1": Rs[1], "R6": Rs[6], "R7": Rs[7]}
out["freed"]["r"], out["freed"]["Rp"], out["freed"]["R"] = (round(v, 4) for v in gbest[1:])
out["G_gain"] = round(G_built / gbest[0], 2)
(HERE / "price_floor.json").write_text(json.dumps(out, indent=1) + "\n")
print(json.dumps(out, indent=1))
