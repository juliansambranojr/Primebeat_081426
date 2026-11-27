"""Does one zero take over the deep corner in the root-square sense as depth grows? EXPLORATORY.
Each zero rho = 1/2 + i gamma carries depth d with weight w = f^d / gamma, f = |2^rho - 1| (unit 0610). At each depth:
the leader (largest w) and the root of the sum of the others' squared weights over the leader's, over the first 2000
and the first 100000 zeros. If it went to zero, a single zero would take over deep along the corner."""
import json, math
import numpy as np
L2 = math.log(2)
g = np.array([float(x) for x in open('../../../imported/twin_count/zeros1.txt').read().split()])
lf = np.log(np.sqrt(3 - 2 * math.sqrt(2) * np.cos(g * L2))); lg = np.log(g)
out = {}
for K in (2000, 100000):
    row = {}
    for d in (10, 100, 1000, 10000, 100000):
        s = 2 * (d * lf[:K] - lg[:K]); i = int(np.argmax(s)); w = np.exp(s - s[i])
        row[f"d{d}"] = {"leader": round(float(g[i]), 3), "rest_rms_over_leader": round(float(np.sqrt(w.sum() - 1)), 4)}
    out[f"K{K}"] = row
json.dump(out, open("reach.json", "w"), indent=1); print(json.dumps(out, indent=1))
