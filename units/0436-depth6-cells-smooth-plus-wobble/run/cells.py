"""Depth-6 cells of the table, rows 14..62, split as smooth cell plus wobble.

cell(r,6) is the seventh difference of pi(2^r) along the rows (column 0 is the
first difference); the smooth cell is the same stencil applied to li(2^r); the
wobble is their difference, reported over 2^(r/2).
"""
import json, sys
from math import comb
import mpmath as mp
mp.mp.dps = 40
d = json.load(open(sys.argv[1]))
pi = {int(k): int(v) for k, v in d.get("pi", d).items() if str(k).isdigit()}
li = {r: mp.li(mp.mpf(2) ** r) for r in pi if r >= 1}
st = lambda f, r, n: sum((-1) ** k * comb(n, k) * f[r - k] for k in range(n + 1))
out = {"depth": 6, "stencil_order": 7, "row_min": 14, "q_from": 20, "row_max": 62, "dps": 40}
neg = zero = 0; qs = []
for r in range(14, 63):
    c = st(pi, r, 7); s = st(li, r, 7); w = c - s; q = w / mp.mpf(2) ** (mp.mpf(r) / 2)
    neg += c < 0; zero += c == 0
    if r >= 20: qs.append(q)
    if r in (19, 20, 21, 22, 30, 40, 50, 62):
        out[f"cell_r{r}"] = c; out[f"smooth_r{r}"] = float(mp.nstr(s, 8))
        out[f"wobble_r{r}"] = float(mp.nstr(w, 6)); out[f"q_r{r}"] = float(mp.nstr(q, 4))
    print(r, c, mp.nstr(s, 10), mp.nstr(w, 8), mp.nstr(q, 5))
out.update(rows=49, cells_negative=int(neg), cells_zero=int(zero), q_lo_from20=float(mp.nstr(min(qs), 4)),
           q_hi_from20=float(mp.nstr(max(qs), 4)))
json.dump(out, open(sys.argv[2], "w"), indent=1)
