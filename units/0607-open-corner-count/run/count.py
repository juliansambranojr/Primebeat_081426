# The cells past row 92 that the proved theorems cover (WeakDepths.only_four_zeros_rh_line37):
# depth <= 16, or r >= 4d + 30, or d >= 30 and r >= 3.7d + 39. Count the rest, and where the line sits.
import json
def covered(r, d): return d <= 16 or r >= 4 * d + 30 or (d >= 30 and r >= 3.7 * d + 39)
out = {}
for R in (100, 150, 200, 400):
    tot = sum(r - 1 for r in range(93, R + 1))
    n = sum(1 for r in range(93, R + 1) for d in range(1, r) if not covered(r, d))
    out[f"to{R}"] = {"cells": tot, "open": n, "open_share": round(n / tot, 3)}
out["line_at_d100"] = {"old": 4 * 100 + 30, "steep": round(3.7 * 100 + 39)}
json.dump(out, open("count.json", "w"), indent=1); print(out)
