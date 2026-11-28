"""How far the RH route reaches below row 93, if its floor is moved down.

Usage: python3 -I below93.py

The route's two-floor constant at floor x0 = 2^k is `routeConstU` (lean_stage3/Stage3/RouteTight.lean):
F(x0^2) + (2 F(x0) + 13) / log(x0^2), with F = floorConstSplit at b1 = 15, b2 = 0, b3 = 626, W = 0
(AssemblyFloor.lean, GlueFloor.lean) and the proved upper bounds c1n <= 88216610000, c3n <= 15,
c4n <= 6468930000 (RouteNum.lean). The formula is unit 0606's, line for line. A window at row r and depth d
has bottom row r - d - 1, and floor 2^k needs that bottom row at least 2k (StmtRoute13: r - n >= 76 at k = 38).
The constant a depth accepts at row r is unit 0606's need(d, r), the WeakDepths gate.

A cell (r, d) is reached when some floor 2^k with 4 <= k <= (r - d - 1) / 2 has routeU(k) <= need(d, r).
Only floor 2^38 is a proved theorem (`RouteSharp.weakWindow13_of_RH`); every other floor is the formula's
value, never stated in Lean.
"""

import json
import math

L2 = math.log(2)
c1, c3, c4 = 88216610000, 15, 6468930000


def F(x0):
    l = math.log(x0)
    return (4 + (16 + 16 * 15) / l + (8 * 626 + 8) / l ** 2 + 18 * c1 / (x0 * math.sqrt(x0))
            + c3 / (math.sqrt(x0) * l) + c4 * x0 ** (-0.25) / math.sqrt(x0))


def routeU(k):
    x0 = 2.0 ** k
    return F(x0 ** 2) + (2 * F(x0) + 13) / math.log(x0 ** 2)


s = 1 + 2 ** -0.5


def need(d, r):
    q = d / (r - 1 - d)
    if q >= 0.5:
        return 0.0
    c = 1 - q / (1 - q)
    return c * 2 ** (r / 2) / (2 * L2 ** 2 * r ** 2 * s ** (d + 1) * 2 ** d)


def reached(r, d):
    kmax = (r - d - 1) // 2
    return any(routeU(k) <= need(d, r) for k in range(4, kmax + 1))


out = {"route_at_bottom_row": {f"r{2 * k}": round(routeU(k), 2) for k in (13, 16, 20, 25, 30, 34, 38)},
       "check_0606_routeU_2p38": round(routeU(38), 2),
       "check_0606_need_d16_r93": round(need(16, 93), 2),
       "deepest": {}, "cells": {}}
total = hit = 0
for r in range(26, 93):
    ds = [d for d in range(1, r) if reached(r, d)]
    out["deepest"][f"r{r}"] = max(ds) if ds else 0
    total += r - 1
    hit += len(ds)
out["cells"] = {"rows_26_92": total, "reached": hit,
                "first_row_reached": next((r for r in range(26, 93) if out["deepest"][f"r{r}"] > 0), 0)}
json.dump(out, open("below93.json", "w"), indent=1, sort_keys=True)
print(json.dumps({k: out[k] for k in ("route_at_bottom_row", "check_0606_routeU_2p38",
                                     "check_0606_need_d16_r93", "cells")}))
print({r: out["deepest"][r] for r in ("r76", "r80", "r85", "r92")})
