# The cells Capstone.OpenCorner leaves open: depth >= 17, row >= 93, below both lines (r < 4d + 30, and r < 3.7d + 39
# when d >= 30). Counted to several rows, with the cells the capstone covers past row 92.
import json
def open_(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and 3.7 * d + 39 <= r)
out = {}
for R in (100, 160, 200, 400):
    past = sum(r - 1 for r in range(93, R + 1))
    o = sum(1 for r in range(93, R + 1) for d in range(1, r) if open_(r, d))
    out[f"to{R}"] = {"cells_past_92": past, "open": o, "covered": past - o}
out["cells_to_92"] = sum(r - 1 for r in range(1, 93))
json.dump(out, open("corner.json", "w"), indent=1); print(out)
