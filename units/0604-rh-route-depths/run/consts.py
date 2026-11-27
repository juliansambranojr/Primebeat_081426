# The RH route's constant 3*floorConstSplit + 13 at a floor x0, on the crude and the sharp zero count,
# and the constant each depth's relative gate accepts at row 93 (RHDepths: price r d).
import json, math
c1, c3, c4 = 88216610000, 15, 6468930000
def F(x0, b1, b3):
    l = math.log(x0)
    return (4 + (16 + 16 * b1) / l + (8 * b3 + 8) / l ** 2 + 18 * c1 / (x0 * math.sqrt(x0))
            + c3 / (math.sqrt(x0) * l) + c4 * x0 ** (-0.25) / math.sqrt(x0))
def route(x0, b1, b3): return 3 * F(x0, b1, b3) + 13
def price(r, d):
    q = d / (r - 1 - d); return (1 - q / (1 - q)) / (r * 3 ** (d + 1))
def need(d, r=93):
    # the route's rho = C*(log 2*r)*2^(-(r-d-1)/2) must sit under price(r, d)
    return price(r, d) / (math.log(2) * r * 2 ** (-(r - d - 1) / 2))
out = {"route_crude_2p36": round(route(2.0 ** 36, 112, 698), 2),
       "route_crude_2p40": round(route(2.0 ** 40, 112, 698), 2),
       "route_sharp_2p40": round(route(2.0 ** 40, 15, 626), 2),
       "stated": {"crude_2p36": 414, "crude_2p40": 263, "sharp_2p40": 91},
       "need": {f"d{d}": round(need(d), 2) for d in (10, 11, 12, 13)}}
json.dump(out, open("consts.json", "w"), indent=1); print(out)
