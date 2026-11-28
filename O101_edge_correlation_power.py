"""O101 power study, synthetic data only, run before the lock of preregs/edge_excess_correlation_v1_20261128.md.
It reads no zero and no prime count: 30 GUE and 30 Poisson height sets (seeds 7001, 7002), each through the same
engine as the run, with benchmark 1 computed for each from its own fifty largest terms (1000 draws per cell,
seed 7003). Each GUE set in turn is taken as the truth against the other 29 GUE sets and the 30 Poisson sets; so is
each Poisson set; and each GUE set again with its count raised by a third (an excess the correlation does not
carry). The locked rule is applied to each. Output results/O101_edge_correlation_power.json, by guarded_write."""
import json, sys, os, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import O101_edge_correlation as O
from utilities.resultsguard import guarded_write
t0 = time.time(); N = 30
diags, cells, W, RMAX = O.geometry(); rngmc = np.random.default_rng(7003)
def sets(kind, seed):
    rng = np.random.default_rng(seed); res = []
    for j in range(N):
        u = O.gue_unfolded(rng, O.K) if kind == "gue" else O.poisson_unfolded(rng, O.K)
        cum, sq, top = O.engine(O.heights_from_unfolded(u), W, RMAX, keep_top=50)
        c = O.counts(diags, cum, sq)["edges_total"]["0.05"]; b = O.benchmark1(diags, sq, top, rngmc, NMC=1000)["edges_total"]["0.05"]
        res.append((c, b, O.spacing_stats(u)))
    return res
gue = sets("gue", 7001); poi = sets("poisson", 7002)
G = np.array([x[0] for x in gue]); P = np.array([x[0] for x in poi])
def tally(cases):
    t = {"explained": 0, "unexplained": 0, "ambiguous": 0}
    for O_, B1_, Gref in cases: t[O.rule(O_, B1_, Gref, P)[0]] += 1
    return {k: round(v / len(cases), 3) for k, v in t.items()}
rows = {"truth GUE": tally([(gue[j][0], gue[j][1], np.delete(G, j)) for j in range(N)]),
        "truth Poisson": tally([(poi[j][0], poi[j][1], G) for j in range(N)]),
        "truth GUE, count raised a third": tally([(round(gue[j][0] * 4 / 3), gue[j][1], np.delete(G, j)) for j in range(N)])}
out = {"schema_version": "1", "script": "O101_edge_correlation_power.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
       "params": {"sets_each": N, "seeds": [7001, 7002, 7003], "mc_draws": 1000},
       "summary": {"gue_counts": G.tolist(), "poisson_counts": P.tolist(), "gue_benchmark1": [x[1] for x in gue], "poisson_benchmark1": [x[1] for x in poi],
                   "gue_spacing_mean_var": [round(float(np.mean([x[2][0] for x in gue])), 4), round(float(np.mean([x[2][1] for x in gue])), 4)],
                   "poisson_spacing_mean_var": [round(float(np.mean([x[2][0] for x in poi])), 4), round(float(np.mean([x[2][1] for x in poi])), 4)],
                   "rule_rates": rows},
       "meta": {"wall_s": round(time.time() - t0, 1)}}
guarded_write(out, "results/O101_edge_correlation_power.json")
print(json.dumps(out["summary"], indent=1))
