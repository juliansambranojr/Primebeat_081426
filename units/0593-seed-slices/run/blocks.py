# Exploratory: the primes' binary blocks. For each prime p, its repeat length ord_p(2); per row of
# the dyadic table the share with the full block (2 a primitive root), and the cells of the
# full-block primes beside the cells of all primes. Writes blocks.json.
import json
from math import comb
from sympy import primerange, n_order
rows = {}; full = {}
for r in range(2, 23):
    ps = list(primerange(max(3, 2**(r - 1) + 1), 2**r + 1))
    rows[r] = len(ps); full[r] = sum(1 for p in ps if n_order(2, p) == p - 1)
def cell(f, r, dd): return sum((-1)**k * comb(dd, k) * f.get(r - k, 0) for k in range(dd + 1))
out = {"share_row20": full[20] / rows[20], "share_row22": full[22] / rows[22]}
for c in [(20, 6), (19, 6), (21, 6)]:
    out[f"c{c[0]}_{c[1]}"] = {"primes": cell(rows, *c), "full_block": cell(full, *c)}
json.dump(out, open("blocks.json", "w"), indent=1); print(out)
