"""O103 power study, synthetic data only, run before the lock of preregs/edge_excess_multibase_v1_20261128.md.
It reads no zero: 10 GUE height sets of 10000 (O101's generator, seed 7401), each through the same 24 bases, against
200 shared-phase draws (seed 7402). The locked rule on the set's own pooled count, and on it raised a sixth, a
third and a half (planted excesses). Output results/O103_edge_excess_multibase_power.json, by guarded_write."""
import json, sys, os, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import O101_edge_correlation as O1
import O103_edge_excess_multibase as O
from utilities.resultsguard import guarded_write
t0 = time.time(); N = 10; KS = 10000; rng = np.random.default_rng(7401)
cases = {"as is": 1.0, "raised a sixth": 7 / 6, "raised a third": 4 / 3, "raised a half": 1.5}
res = {c: {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0} for c in cases}; spread = []; corr = []
for j in range(N):
    h = O1.heights_from_unfolded(O1.gue_unfolded(rng, KS)); PH = O.phases(KS, 200, 7402 + j)
    own = 0; null = np.zeros(200); M = []
    for name, b in O.BASES:
        o, n, _ = O.base_counts(h, b, PH); own += o["0.05"]; null += np.asarray(n["0.05"]); M.append(n["0.05"])
    M = np.array(M); corr.append(float((np.corrcoef(M).sum() - len(M)) / (len(M) ** 2 - len(M)))); spread.append(float(null.std() / null.mean()))
    for c, f in cases.items(): res[c][O.rule(round(own * f), null)[0]] += 1
    print(j, round(spread[-1], 3), round(corr[-1], 4), {c: O.rule(round(own * f), null)[0] for c, f in cases.items()}, flush=True)
out = {"schema_version": "1", "script": "O103_edge_excess_multibase_power.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
       "params": {"sets": N, "heights": KS, "draws": 200, "seeds": [7401, "7402+j"], "bases": len(O.BASES)},
       "summary": {"rule_rates": {c: {k: v / N for k, v in r.items()} for c, r in res.items()},
                   "pooled_sd_over_mean_median": round(float(np.median(spread)), 3), "between_base_corr_median": round(float(np.median(corr)), 4)},
       "meta": {"wall_s": round(time.time() - t0, 1)}}
guarded_write(out, "results/O103_edge_excess_multibase_power.json"); print(json.dumps(out["summary"], indent=1))
