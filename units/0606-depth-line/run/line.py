# The two-floor route constant at the floor 2^38, the constant depth 16 accepts at row 93, the line's
# arithmetic at its start (WeakDepths.line_base), and the closing row of each depth at constant 13.
import json, math
L2 = math.log(2)
c1, c3, c4 = 88216610000, 15, 6468930000
def F(x0):
    l = math.log(x0)
    return (4 + (16 + 16 * 15) / l + (8 * 626 + 8) / l ** 2 + 18 * c1 / (x0 * math.sqrt(x0))
            + c3 / (math.sqrt(x0) * l) + c4 * x0 ** (-0.25) / math.sqrt(x0))
x0 = 2.0 ** 38
U = F(x0 ** 2) + (2 * F(x0) + 13) / math.log(x0 ** 2)
s = 1 + 2 ** -0.5
def c_(r, d):
    q = d / (r - 1 - d); return 1 - q / (1 - q)
def need(d, r):
    return c_(r, d) * 2 ** (r / 2) / (2 * L2 ** 2 * r ** 2 * s ** (d + 1) * 2 ** d)
def closing(d, C):
    return next(r for r in range(max(93, 3 * d + 2), 10 ** 5) if need(d, r) > C and r - d - 1 >= 76)
base16 = 52 * 0.4805 * 1.70711 * (4 * 16 + 30) ** 2 * 3.41422 ** 16 / 2 ** (2 * 16 + 15)
out = {"F_2p76": round(F(x0 ** 2), 3), "F_2p38": round(F(x0), 3), "routeU": round(U, 2),
       "stated": 13, "need_d16_r93": round(need(16, 93), 2),
       "line_base_ratio_d16": round(base16, 3),
       "closing13": {f"d{d}": closing(d, 13) for d in (17, 20, 30, 50, 100)},
       "line": {f"d{d}": 4 * d + 30 for d in (17, 20, 30, 50, 100)},
       "closing_true": {f"d{d}": closing(d, 1 / (8 * math.pi)) for d in (17, 20, 30, 50, 100)}}
json.dump(out, open("line.json", "w"), indent=1); print(out)
