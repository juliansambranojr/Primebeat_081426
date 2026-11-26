# Exploratory: the deep balance under the de Bruijn-Newman flow. The zeros' part of a cell rebuilt
# from the real zeros of H_lambda computed in unit 0578 (228 below the point run's height), as the
# flow time moves. Writes flow.json.
import json, math, numpy as np
from math import comb
d = json.load(open("../../0578-heat-flow-zeros/run/zeros_by_lam.json"))
def rowzero(r, g):
    def at(x):
        rho = 0.5 + 1j * g; return -2 * np.real(np.sum(np.exp(rho * math.log(x)) / (rho * math.log(x))))
    return at(2.0**r) - at(2.0**(r - 1))
def cellzero(r, dd, g): return sum((-1)**k * comb(dd, k) * rowzero(r - k, g) for k in range(dd + 1))
out = {}
for c in [(20, 6), (19, 6), (21, 6)]:
    base = cellzero(*c, np.array(d["0.0"]) / 2)
    out[f"c{c[0]}_{c[1]}"] = {"zeros_part_t0": base, **{f"change_t{l}": cellzero(*c, np.array(d[l]) / 2) - base
                                                     for l in ("-0.02", "0.02", "0.2")}}
json.dump(out, open("flow.json", "w"), indent=1); print(out)
