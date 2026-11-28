"""O100 power study, synthetic data only, run before the lock of preregs/two_adic_power_depths_v1_20261128.md.
It reads no prime count: the cells use rows 26..92 only, and every synthetic table draws those rows' low 20 bits
uniformly at random. The null distribution is built exactly as O100_two_adic_depths.py builds it (10000 draws,
default_rng(20261128)). Each replicate is one more random table (default_rng(1128) stream) with a planted effect:
each cell of the planted arm independently gains one trailing zero with probability q. The decision rule of the
prereg is then applied to the replicate's primary and placebo statistics.
Output results/O100_two_adic_power.json."""
import json, time
import numpy as np
import O100_two_adic_depths as O
t0 = time.time()
arms = {"primary": O.PRIMARY, "placebo": O.PLACEBO}
C = {k: O.cells_for(v) for k, v in arms.items()}; Wt = {k: O.weights(v) for k, v in C.items()}
def tables(rng, n):
    R = np.zeros((n, O.RMAX + 1), dtype=np.int64)
    R[:, O.LOWROW:] = rng.integers(0, O.MOD, size=(n, O.RMAX + 1 - O.LOWROW), dtype=np.int64)
    return R
rng = np.random.default_rng(O.SEED); nullT = {k: np.empty(O.NNULL) for k in arms}
for s in range(0, O.NNULL, 500):
    R = tables(rng, 500)
    for k in arms: nullT[k][s:s + 500] = O.v2cap(O.cell_residues(Wt[k], R)).mean(1)
def pval(k, t): return (1 + (nullT[k] >= t).sum()) / (1 + O.NNULL)
def rule(pp, pl):
    if pp <= 0.01 and pl > 0.01: return "excess"
    if pp >= 0.10: return "no_excess"
    return "ambiguous"
REPS = 1000; rng2 = np.random.default_rng(1128); rows = {}
for name, q, where in (("null", 0.0, ()), ("primary q=0.1", 0.1, ("primary",)), ("primary q=0.2", 0.2, ("primary",)),
                       ("primary q=0.3", 0.3, ("primary",)), ("primary q=0.5", 0.5, ("primary",)),
                       ("both arms q=0.3", 0.3, ("primary", "placebo"))):
    cnt = {"excess": 0, "no_excess": 0, "ambiguous": 0}
    for s in range(0, REPS, 250):
        R = tables(rng2, 250)
        T = {}
        for k in arms:
            v = np.minimum(O.v2cap(O.cell_residues(Wt[k], R)) + (rng2.random((250, len(C[k]))) < q if k in where else 0), O.CAP)
            T[k] = v.mean(1)
        for i in range(250): cnt[rule(pval("primary", T["primary"][i]), pval("placebo", T["placebo"][i]))] += 1
    rows[name] = {k: v / REPS for k, v in cnt.items()}
out = {"schema_version": "1", "script": "O100_two_adic_power.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
       "params": {"replicates": REPS, "null_draws": O.NNULL, "null_seed": O.SEED, "replicate_seed": 1128},
       "summary": {"cells": {k: len(v) for k, v in C.items()}, "null_mean": {k: float(nullT[k].mean()) for k in arms},
                   "null_sd": {k: float(nullT[k].std()) for k in arms}, "rule_rates": rows},
       "meta": {"wall_s": round(time.time() - t0, 1)}}
json.dump(out, open("results/O100_two_adic_power.json", "w"), indent=1); print(json.dumps(out["summary"], indent=1))
