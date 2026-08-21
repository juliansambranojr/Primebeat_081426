#!/usr/bin/env python3
"""O49 — EXPLORATORY. No prereg. Nothing here earns a verdict.

Entry 74: O48's fixed depth window d in [3,8] sat above d* for most of the
base set and measured a base-independent noise plateau at gain ~1.77. This
asks the question the fixed window could not: PER BASE, at what depth does the
per-depth gain leave the symbol and join the plateau, and does the symbol hold
below it?

Reads with: notes/lab_notebook_2.md entries 72, 73, 74
            analysis/2026-08-19_table_structure/CHAIN.md t2_crossover (d*)
"""
import cmath, json, math, pathlib, statistics
import mpmath as mp

_HERE = pathlib.Path(__file__).resolve().parent
mp.mp.dps = 50
from primecountpy import prime_pi as _pi

G1 = 14.134725141734693
RHO1 = complex(0.5, G1)
BASES = [1.1500, 1.2293859, 1.2560, 1.2855907, 1.3160, 1.3483554,
         1.4200, 1.5000, 1.5597432, 1.6200, 1.7500, 2.0000, 3.0000]
DSTAR = {1.1500: None, 1.2293859: None, 1.2560: None, 1.2855907: None,
         1.3160: None, 1.3483554: None, 1.4200: None, 1.5000: None,
         1.5597432: 5, 1.6200: None, 1.7500: None, 2.0000: 7, 3.0000: 10}
FLOOR, CEIL, DMAX, MINCELLS = 10**4, 2**32, 12, 8

def rungs(b):
    lo = math.ceil(math.log(FLOOR)/math.log(b)); hi = math.floor(math.log(CEIL)/math.log(b))
    return list(range(lo, hi+1))

def residual(b, rs):
    out = {}
    for r in rs:
        c = _pi(math.floor(b**r)) - _pi(math.floor(b**(r-1)))
        s = float(mp.li(mp.mpf(b)**r) - mp.li(mp.mpf(b)**(r-1)))
        out[r] = c - s
    return out

print("O49 — gain vs depth, per base.  EXPLORATORY, no prereg, no verdict.\n")
print(f"predictions:  smooth |1-b^-1/2|    gamma1 |1-b^-rho1|    plateau ~1.771\n")
rowsout = []
for b in BASES:
    rs = rungs(b); e = residual(b, rs)
    tab = {0: e}
    for d in range(1, DMAX+1):
        tab[d] = {r: tab[d-1][r]-tab[d-1][r-1] for r in rs if r-1 in tab[d-1] and r in tab[d-1]}
    gains = {}
    for d in range(1, DMAX+1):
        v = [abs(tab[d][r])/abs(tab[d-1][r]) for r in rs
             if r-d >= rs[0] and r in tab[d] and r in tab[d-1] and tab[d-1][r] != 0]
        if len(v) >= MINCELLS: gains[d] = statistics.median(v)
    gs, gg = abs(1-b**-0.5), abs(1-cmath.exp(-RHO1*math.log(b)))
    dep = next((d for d in sorted(gains) if gains[d] > 1.40), None)
    print(f"b={b:<9.4f} log b={math.log(b):.4f}   smooth={gs:.4f}  gamma1={gg:.4f}"
          f"   d*(t2)={DSTAR[b]}   plateau entry d={dep}")
    print("   d :  " + " ".join(f"{d:>6d}" for d in sorted(gains)))
    print("   g :  " + " ".join(f"{gains[d]:6.3f}" for d in sorted(gains)))
    print()
    rowsout.append({"base": b, "log_b": math.log(b), "smooth_pred": gs,
                    "gamma1_pred": gg, "d_star_t2": DSTAR[b],
                    "plateau_entry_d": dep,
                    "gain_by_depth": {str(k): v for k, v in gains.items()}})
p = _HERE/"results"/"gain_vs_depth.json"
p.write_text(json.dumps({"schema_version":"1","script":"O49_gain_vs_depth.py",
    "exploratory": True, "prereg": None,
    "params":{"bases":BASES,"value_floor":FLOOR,"value_ceiling":CEIL,"dmax":DMAX,
              "min_cells":MINCELLS,"dps":50},
    "constants":{"gamma_1":G1}, "rows":rowsout}, indent=2))
print(f"wrote {p}")
