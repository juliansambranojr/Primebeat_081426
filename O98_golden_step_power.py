"""O98 power — the decision rule of O98_golden_step_basin.py on synthetic data
only (no zeta zero is read). Run before the lock of
preregs/golden_step_basin_v1_20261126.md.

Planted: p_n = u + (n-1)/phi + wrapped Gaussian noise of sd sigma, mod 1.
Null 1: p_n uniform and independent. Null 2: a random walk mod 1 with
Gaussian steps of sd 0.3. 400 replicates each, 2000 null orders each (the real
test uses 100000; p < 0.001 is resolvable at 2000).
"""
import json
import numpy as np
from O98_golden_step_basin import PHI, decide, score, null_scores, N_ZEROS

REPS, N_NULL_P = 400, 2000
rng = np.random.default_rng(7)
n = np.arange(N_ZEROS)

def rate(gen):
    labels = []
    for _ in range(REPS):
        p = gen()
        pred = (p[0] + n[1:] / PHI) % 1.0
        S = score(pred, p[1:])
        nulls = null_scores(pred, p[1:], rng, N_NULL_P)
        pval = (1 + np.sum(nulls >= S)) / (1 + N_NULL_P)
        labels.append(decide(S, pval, True))
    return {k: labels.count(k) / REPS for k in ("falls_out", "does_not_fall_out", "ambiguous")}

out = {}
for sigma in (0.03, 0.05, 0.10, 0.15, 0.20):
    out[f"planted_sigma_{sigma}"] = rate(lambda: (rng.random() + n / PHI + rng.normal(0, sigma, N_ZEROS)) % 1.0)
out["null_uniform"] = rate(lambda: rng.random(N_ZEROS))
out["null_walk"] = rate(lambda: np.cumsum(rng.normal(0, 0.3, N_ZEROS)) % 1.0)
json.dump(out, open("results/O98_golden_step_power.json", "w"), indent=1)
for k, v in out.items():
    print(k, v)
