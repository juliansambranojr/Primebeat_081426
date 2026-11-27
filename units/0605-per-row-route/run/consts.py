# The per-row route: its constant at the floor 2^38 through the old and the sharp psi-to-pi transfer,
# and the constant the per-row gate accepts at row 93, with the floor integral bounded by 1/(2r)
# (WeakDepths.weak_lt_floor) and by 1/(2 log 2 r) (weak40_lt_floor).
import json, math
L2 = math.log(2)
c1, c3, c4 = 88216610000, 15, 6468930000
x0 = 2.0 ** 38
l = math.log(x0)
F = (4 + (16 + 16 * 15) / l + (8 * 626 + 8) / l ** 2 + 18 * c1 / (x0 * math.sqrt(x0))
     + c3 / (math.sqrt(x0) * l) + c4 * x0 ** (-0.25) / math.sqrt(x0))
old = 3 * F + 13
new = F + (2 * F + 13) / math.log(x0 ** 2)
s = 1 + 2 ** -0.5
def c_(r, d):
    q = d / (r - 1 - d); return 1 - q / (1 - q)
def need_half(d, r=93):
    return c_(r, d) * 2 ** (r / 2) / (2 * L2 * r ** 2 * s ** (d + 1) * 2 ** d)
def need_log(d, r=93):
    return c_(r, d) * 2 ** (r / 2) / (2 * L2 ** 2 * r ** 2 * s ** (d + 1) * 2 ** d)
out = {"route_old_transfer": round(old, 2), "route_sharp_transfer": round(new, 2),
       "stated": {"old": 127, "sharp": 40},
       "need_half": {f"d{d}": round(need_half(d), 2) for d in (13, 14, 15)},
       "need_log": {f"d{d}": round(need_log(d), 2) for d in (14, 15, 16)}}
json.dump(out, open("consts.json", "w"), indent=1); print(out)
