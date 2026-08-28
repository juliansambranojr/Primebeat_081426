#!/usr/bin/env python3
"""O68 — how weak can the RH-conditional bound get before the theorem dies?

EXPLORATORY: no prereg. A verification run, not a measurement: an
adversarial-round agent (entry 116) re-tabulated O67's R(d) under weakened
hypotheses |pi(x) - li(x)| <= C * sqrt(x) * (log x)^k for x >= x0, and
claimed large tolerance. This script recomputes that table with the bench's
own O67 machinery, independently. It gates the stage-3 decomposition
decision (entry 116, option 2).

THE GENERALIZATION. O67's error bound, redone for arbitrary (C, k, x0):
   bound(x) = C * sqrt(x) * (log x)^k, valid for x >= x0.
Summing over the window with binomial weights, using
   sqrt(2^(r-j)) = 2^(r/2) * 2^(-j/2)  and  log(2^(r-j)) <= r*log 2:
   E_high(r,d) = C * (r*log2)^k * 2^(r/2) * (1 + 2^(-1/2))^(d+1).
Validity needs the whole window above x0:  r - d - 1 >= log2(x0).
M_low and the wedge are unchanged from O67. At (C,k,x0) =
(1/(8*pi), 1, 2657) this is exactly O67's E_high, and the first grid row
must reproduce O67's committed table (results/conditional_last_zero.json)
R-for-R — that is the sanity gate.

WHAT A ROW MEANS. R(d) = min r with M_low > E_high, the wedge, and the
window floor. "covered" = R(d) <= 93, so O43's census (r <= 92, published
pi(2^n)) closes the strip and (20,6) is the last exact zero at depth d.
depth_covered = largest D with every d <= D covered.

Reads with: O67_conditional_last_zero.py, notes/lab_notebook_2.md entries
112, 116, lean/Schoenfeld.lean (the C=1/(8*pi), k=1 bridge in-tree).
"""
import json, math, pathlib
import mpmath as mp
import sys as _sys
_sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from utilities.resultsguard import guarded_write

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 40
LOG2 = math.log(2)
O43_EXTENT = 92

GRID = [
    {"name": "schoenfeld",  "C": 1 / (8 * math.pi), "k": 1, "x0": 2657.0},
    {"name": "psi_style",   "C": 1 / (8 * math.pi), "k": 2, "x0": 74.0},
    {"name": "crude",       "C": 1.0,               "k": 2, "x0": 2657.0},
    {"name": "very_crude",  "C": 100.0,             "k": 2, "x0": 2.0 ** 30},
    {"name": "crude_1000",  "C": 1000.0,            "k": 2, "x0": 2.0 ** 30},
    {"name": "brutal",      "C": 1.0e6,             "k": 3, "x0": 2.0 ** 60},
]
DMAX = 24
RMAX = 600


def M_low(r, d):
    return mp.mpf('0.5') * mp.mpf(2) ** (r - d - 1) * mp.mpf(LOG2) ** d / r


def E_high(r, d, C, k):
    return (mp.mpf(C) * (mp.mpf(r) * LOG2) ** k * mp.mpf(2) ** (mp.mpf(r) / 2)
            * mp.mpf(1 + 2 ** -0.5) ** (d + 1))


def R_of(d, C, k, x0):
    floor = math.log2(x0)
    r = max(d + 2 + math.ceil(floor), 14)
    while r <= RMAX:
        if (M_low(r, d) > E_high(r, d, C, k)
                and d <= 0.34 * (r - d - 1)
                and r - d - 1 >= floor):
            return r
        r += 1
    return None


# Cells entry 118 skipped: k=2 with C between 1000 and 1e6. Slice 3 (entry
# 230) delivers a psi-side constant that lands there after the
# C_pi = 3*C_psi + 13 inflation of entry 129, so the row that governs the
# substitute route was never measured. --extra adds them; the default GRID
# above is untouched and its rows reproduce byte-for-byte.
EXTRA_GRID = [
    {"name": "slice3_1e4", "C": 1.0e4, "k": 2, "x0": 2.0 ** 30},
    {"name": "slice3_1e5", "C": 1.0e5, "k": 2, "x0": 2.0 ** 30},
    {"name": "slice3_1e6", "C": 1.0e6, "k": 2, "x0": 2.0 ** 30},
]


def main():
    import argparse
    ap = argparse.ArgumentParser(description="O68 tolerance table")
    ap.add_argument("--extra", action="store_true",
                    help="also run EXTRA_GRID, the k=2 cells between "
                         "C=1000 and C=1e6 that entry 118 skipped")
    ap.add_argument("--out", default=None, help="results path override")
    ap.add_argument("--no-json", action="store_true")
    args = ap.parse_args()
    grid = GRID + (EXTRA_GRID if args.extra else [])

    print("O68 — R(d) under |pi - li| <= C*sqrt(x)*(log x)^k for x >= x0.")
    print("Row 1 must reproduce O67; the rest map the tolerance.\n")

    o67 = json.loads((_HERE / "results" / "conditional_last_zero.json").read_text())
    o67_R = {row["d"]: row["R"] for row in o67["rows"]}

    out_rows = []
    for g in grid:
        Rs = {d: R_of(d, g["C"], g["k"], g["x0"]) for d in range(1, DMAX + 1)}
        depth = 0
        for d in range(1, DMAX + 1):
            if Rs[d] is not None and Rs[d] <= O43_EXTENT + 1:
                depth = d
            else:
                break
        sanity = None
        if g["name"] == "schoenfeld":
            sanity = all(Rs[d] == o67_R.get(d) for d in range(1, DMAX + 1))
            print(f"   SANITY vs O67 committed table: {sanity}")
        span = f"R(1)={Rs[1]} .. R(8)={Rs[8]}"
        print(f"   {g['name']:<11} C={g['C']:<9.4g} k={g['k']} "
              f"log2(x0)={math.log2(g['x0']):5.1f}   {span:<24} "
              f"depth_covered={depth}")
        out_rows.append({"name": g["name"], "C": g["C"], "k": g["k"],
                         "log2_x0": math.log2(g["x0"]),
                         "R": {str(d): Rs[d] for d in range(1, DMAX + 1)},
                         "depth_covered": depth,
                         "sanity_vs_o67": sanity})

    print("\ndepth_covered by row is the gate for the stage-3 decomposition:")
    print("the decomposition target (C computed in Lean, k=2) must land at a")
    print("row whose depth_covered is worth the build.")

    if args.no_json:
        return 0
    _out = pathlib.Path(args.out) if args.out else (
        _HERE / "results" / "weak_bound_tolerance.json")
    payload = {
        "schema_version": "1", "script": "O68_weak_bound_tolerance.py",
        "exploratory": True, "prereg": None,
        "params": {"dps": 40, "o43_extent": O43_EXTENT, "dmax": DMAX,
                   "rmax": RMAX, "main_constant": 0.5,
                   "wedge": "d <= 0.34*(r-d-1)",
                   "window_floor": "r-d-1 >= log2(x0)",
                   "extra_grid": bool(args.extra)},
        "grid": out_rows}
    guarded_write(payload, str(_out))
    print(f"\nwrote {_out}")


if __name__ == "__main__":
    main()
