"""The main-term floor Mlow against the exact d-th difference of the smooth row.

Smooth row: s(m) = li(2^m) - li(2^(m-1)).  Exact stencil: sum_k (-1)^k C(d,k) s(r-k).
Mlow(r,d) = 0.5 * 2^(r-d-1) * (log 2)^d / r   (Nonvanishing.Mlow).
Reach under Schoenfeld's relative error rho = log2*r/(8 pi)*2^(-(r-d-1)/2):
the gate closes when rho*2^r*(3/2)^(d+1) < floor.  For each r, the largest d it closes
with the floor Mlow and with the exact stencil.
"""
import json, math
from mpmath import mp, li, mpf, log, pi
mp.dps = 120
L2 = log(2)
def s(m): return li(mpf(2)**m) - li(mpf(2)**(m-1)) if m >= 1 else mpf(0)
def exact(r, d): return sum((-1)**k * math.comb(d, k) * s(r-k) for k in range(d+1))
def mlow(r, d): return mpf(0.5) * mpf(2)**(r-d-1) * L2**d / r
def ceil_(r, d):
    rho = L2*r/(8*pi) * mpf(2)**(-mpf(r-d-1)/2)
    return rho * mpf(2)**r * mpf(1.5)**(d+1)
out = {"ratio": {}, "reach": {}}
for r in (100, 200, 400):
    for d in (10, 20, 40):
        if d >= r//2: continue
        e = exact(r, d)
        out["ratio"][f"{r}.{d}"] = {"exact_over_mlow": float(e/mlow(r, d)),
                                    "inv_log2_pow_d": float((1/L2)**d)}
for r in (100, 200, 400, 800):
    dm = max([d for d in range(1, r//2) if ceil_(r, d) < mlow(r, d)], default=0)
    de = max([d for d in range(1, r//2) if ceil_(r, d) < exact(r, d)], default=0)
    out["reach"][str(r)] = {"d_mlow": dm, "d_exact": de,
                            "r_over_d_mlow": r/dm, "r_over_d_exact": r/de}
json.dump(out, open("floor.json", "w"), indent=1)
print(json.dumps(out, indent=1))
