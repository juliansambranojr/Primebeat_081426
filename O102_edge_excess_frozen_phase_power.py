"""O102 power study, synthetic data only, run before the lock of preregs/edge_excess_frozen_phase_v1_20261128.md.
It reads no zero: 20 GUE height sets of 10000 (O101's generator, seed 7101), each through the same engine. For each
set, its own count (its own phases) is set against 200 frozen-phase draws of its own terms (seed 7102), and the
locked rule applied; then again with the set's count raised by a third and by two thirds, planted excesses.
Output results/O102_edge_excess_frozen_phase_power.json, by guarded_write."""
import json, sys, os, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import O101_edge_correlation as O1
import O102_edge_excess_frozen_phase as O
from utilities.resultsguard import guarded_write
t0 = time.time(); N = 20; KS = 10000
diags, cells, W, RMAX = O1.geometry(); rng = np.random.default_rng(7101); rngd = np.random.default_rng(7102)
res = {"as is": {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0}, "raised a third": {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0},
       "raised two thirds": {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0}}
ratios = []
for j in range(N):
    h = O1.heights_from_unfolded(O1.gue_unfolded(rng, KS))
    C, obsv, sq = O.terms(h, W, RMAX); sig = np.sqrt(sq / 2)
    Oc = int(O.edge_counts(diags, obsv, sig)["edges_total"]["0.05"])
    tot, _ = O.draws(C, diags, sig, rngd, 200)
    null = np.asarray(tot["0.05"]); ratios.append([Oc, float(null.mean()), float(null.std())])
    for name, f in (("as is", 1.0), ("raised a third", 4 / 3), ("raised two thirds", 5 / 3)):
        res[name][O.rule(round(Oc * f), null)[0]] += 1
rates = {k: {kk: round(vv / N, 3) for kk, vv in v.items()} for k, v in res.items()}
out = {"schema_version": "1", "script": "O102_edge_excess_frozen_phase_power.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
       "params": {"sets": N, "heights": KS, "draws": 200, "seeds": [7101, 7102]},
       "summary": {"rule_rates": rates, "per_set_count_nullmean_nullsd": ratios,
                   "null_sd_over_mean_median": round(float(np.median([r[2] / r[1] for r in ratios])), 3)},
       "meta": {"wall_s": round(time.time() - t0, 1)}}
guarded_write(out, "results/O102_edge_excess_frozen_phase_power.json")
print(json.dumps(out["summary"]["rule_rates"], indent=1), out["summary"]["null_sd_over_mean_median"])
