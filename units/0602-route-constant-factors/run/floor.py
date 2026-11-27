# The route constant at the floor 2^38 piece by piece, and the constant each depth needs at each row.
# Upper bounds as proved in lean_stage3: c1n <= 88216610000, c3n <= 15, c4n <= 6468930000;
# RvM constants of rvM_sharp: b1 = 15, b2 = 0, b3 = 626, W = 0.
import json, math
L2 = math.log(2)
x0 = 2.0 ** 38
l = math.log(x0)
c1, c3, c4, b1, b2, b3, W = 88216610000, 15, 6468930000, 15, 0, 626, 0
pieces = {
    "lead": 4.0,
    "log1": (16 + 16 * b1 + 16 * b2) / l,
    "log2": (8 * b3 + 8 + 4 * W) / l ** 2,
    "c1": 18 * c1 / (x0 * math.sqrt(x0)),
    "c3": c3 / (math.sqrt(x0) * l),
    "c4": c4 * x0 ** (-0.25) / math.sqrt(x0),
}
F = sum(pieces.values())
lpi = math.log(x0 ** 2)
old = 3 * F + 13
new = F + (2 * F + 13) / lpi
s = 1 + 2 ** -0.5
def need(d, r):
    # largest C with 2 C (log 2)^2 r^2 s^(d+1) 2^d < c 2^(r/2), floor H >= 1/(2 log 2 r)
    q = d / (r - 1 - d)
    c = 1 - q / (1 - q)
    return c * 2 ** (r / 2) / (2 * L2 ** 2 * r ** 2 * s ** (d + 1) * 2 ** d)
out = {"floor": {k: round(v, 4) for k, v in pieces.items()},
       "F": round(F, 4), "old_route": round(old, 3), "new_route": round(new, 3),
       "old_transfer_factor": round(old / new, 3),
       "need": {f"d{d}": {f"r{r}": round(need(d, r), 2) for r in (93, 94, 95, 96, 97)}
                for d in (15, 16, 17, 18)},
       "first_row_closed_at_40": {f"d{d}": next(r for r in range(93, 400) if need(d, r) > 40)
                                  for d in (15, 16, 17, 18, 20, 25)}}
json.dump(out, open("floor.json", "w"), indent=1)
print(json.dumps(out, indent=1))
