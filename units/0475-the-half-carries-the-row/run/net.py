"""The net rounding against the count itself. EXPLORATORY; a correction.

half.py set the roundings' net beside their mass, on the sum cut off at d <= x.
`SieveExact.netRounding_eq` (unit 0481) gives the net rounding of the full sum
exactly:

    net rounding = x * prod_{p <= sqrt x} (1 - 1/p) - (1 + pi(x) - pi(sqrt x))

so it can be read at any row from the count alone. Here it is set beside the
count and beside sqrt(x).
Usage: python3 net.py <pi2n_cache.json> <out.json>
"""
import json, math, sys
import numpy as np

cache, out_path = sys.argv[1], sys.argv[2]
ROWS = [10, 14, 18, 22, 26, 30, 40, 50]
d0 = json.load(open(cache))
pi_tab = {int(k): int(v) for k, v in d0.get("pi", d0).items() if str(k).isdigit()}

ymax = math.isqrt(2 ** max(ROWS))
s = np.ones(ymax + 1, dtype=bool); s[:2] = False
for p in range(2, int(ymax ** 0.5) + 1):
    if s[p]:
        s[p * p::p] = False
allp = np.nonzero(s)[0]

out = {"rows": []}
for r in ROWS:
    x = 2 ** r
    y = math.isqrt(x)
    ps = allp[allp <= y]
    prod = float(np.exp(np.sum(np.log1p(-1.0 / ps))))
    count = 1 + pi_tab[r] - len(ps)
    net = x * prod - count
    row = {"r": r, "count": count, "product_part": round(x * prod, 1), "net_rounding": round(net, 1),
           "net_over_count": round(net / count, 4), "net_over_sqrt": round(net / math.sqrt(x), 2)}
    out["rows"].append(row); print(row)
json.dump(out, open(out_path, "w"), indent=1)
