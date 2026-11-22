"""pi(2^r) - li(2^r) at each doubling, r = 4..62, from the repo's pi(2^n) cache.

Writes the residual, its ratio to sqrt(x)/log x and to sqrt(x)*log x, and how
often the residual's size grew from one doubling to the next.
"""
import json, sys
import mpmath as mp
mp.mp.dps = 40
d = json.load(open(sys.argv[1]))
pi = {int(k): int(v) for k, v in d.get("pi", d).items() if str(k).isdigit()}
out = {"r_min": 4, "ratio_from": 10, "r_max": max(pi), "dps": 40}
up = dn = 0; prev = None; worst = mp.mpf(0); lo = None; hi = None
for r in sorted(pi):
    if r < 4: continue
    x = mp.mpf(2) ** r
    res = pi[r] - mp.li(x)
    a = res / (mp.sqrt(x) / mp.log(x)); b = res / (mp.sqrt(x) * mp.log(x))
    worst = max(worst, abs(b))
    if r >= 10:
        lo = a if lo is None else min(lo, a); hi = a if hi is None else max(hi, a)
    if prev is not None:
        if abs(res) > abs(prev): up += 1
        else: dn += 1
    prev = res
    if r in (10, 20, 30, 40, 50, 60, 62):
        out[f"res_r{r}"] = float(mp.nstr(res, 8)); out[f"ratio_r{r}"] = float(mp.nstr(a, 5))
    print(r, mp.nstr(res, 10), mp.nstr(a, 6), mp.nstr(b, 6))
out.update(steps=up + dn, grew=up, shrank=dn, ratio_lo_from10=float(mp.nstr(lo, 5)),
           ratio_hi_from10=float(mp.nstr(hi, 5)), worst_over_sqrt_log=float(mp.nstr(worst, 5)),
           positive_residuals=sum(1 for r in pi if r >= 4 and pi[r] - mp.li(mp.mpf(2) ** r) > 0))
json.dump(out, open(sys.argv[2], "w"), indent=1)
