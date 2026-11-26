# Exploratory: the zero of V near height 5010.87, for the function unit 0572 measured
# (zeta-derivatives, coefficients at 0) and for the Lean V (Lambda-derivatives,
# Taylor coefficients at 1/2, divided by Gamma_R), with L = log 5000.
# From the adversary review's loc.py; writes results.json.
import json, math
from vlib import *
L = math.log(5000)
n0, n1 = int(mp.nzeros(5009.5)) + 1, int(mp.nzeros(5011.5)) + 1
res = {"L": float(L), "zeta_zeros": [float(mp.zetazero(n).imag) for n in range(n0, n1)]}
for qn in ["Q0", "m02"]:
    for kind, mk in [("script", V_script), ("lean", V_lean)]:
        f = mk(QS[qn], L)
        best = None
        for i in range(1, 30):
            for j in range(0, 21):
                s = mp.mpc(0.5 + 0.01 * i, 5010 + 0.05 * j); v = abs(f(s))
                if best is None or v < best[0]: best = (v, s)
        r = mp.findroot(f, best[1])
        res[f"{qn}_{kind}_re_minus_half"] = float(mp.re(r)) - 0.5
        res[f"{qn}_{kind}_im"] = float(mp.im(r))
        res[f"{qn}_{kind}_abs_f"] = float(abs(f(r)))
        print(qn, kind, complex(r), flush=True)
res["Q_roots"] = {qn: [complex(x).real for x in __import__("numpy").roots(QS[qn][::-1])] for qn in ["lev", "Q0", "m02"]}
json.dump(res, open("results.json", "w"), indent=1)
