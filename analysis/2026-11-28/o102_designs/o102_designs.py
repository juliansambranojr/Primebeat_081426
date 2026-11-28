# EXPLORATORY design comparison for O102, synthetic GUE heights only (no true zero read).
import sys, json, numpy as np
sys.path.insert(0, '/home/user/Primebeat_081426')
import O101_edge_correlation as O1, O102_edge_excess_frozen_phase as O
diags, cells, W, RMAX = O1.geometry(); rng = np.random.default_rng(7201); rngd = np.random.default_rng(7202)
names = list(diags); edge_idx = np.concatenate([np.arange(sum(len(diags[n]) for n in names[:i]), sum(len(diags[n]) for n in names[:i + 1])) for i, n in enumerate(names) if n.startswith('edge')])
def stat(vals, sig, design):
    # vals: (cells,) or (cells, n)
    if vals.ndim == 1: vals = vals[:, None]
    if design == 'pooled':
        return sum((np.abs(vals) < t * sig[:, None]).sum(0) for t in (0.02, 0.05, 0.1))
    return (np.abs(vals[edge_idx]) < 0.05 * sig[edge_idx][:, None]).sum(0)
designs = {'D0 edges t=0.05': ('edges', 0), 'D1 pooled thresholds, all diagonals': ('pooled', 0), 'D2 first 10 zeros fixed': ('edges', 10), 'D3 first 50 zeros fixed': ('edges', 50)}
res = {k: {"sd_over_mean": [], "as_is": {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0}, "third": {"excess_real": 0, "consistent_with_chance": 0, "ambiguous": 0}} for k in designs}
N = 20
for j in range(N):
    h = O1.heights_from_unfolded(O1.gue_unfolded(rng, 10000))
    C, obsv, sq = O.terms(h, W, RMAX); sig = np.sqrt(sq / 2)
    for k, (st, M) in designs.items():
        Oc = int(stat(obsv, sig, st)[0])
        ph = np.exp(1j * rngd.uniform(0, 2 * np.pi, (C.shape[1], 200))).astype(np.complex64); ph[:M] = 1
        null = stat((C @ ph).real.astype(np.float64), sig, st)
        res[k]["sd_over_mean"].append(float(null.std() / max(null.mean(), 1e-9)))
        res[k]["as_is"][O.rule(Oc, null)[0]] += 1; res[k]["third"][O.rule(round(Oc * 4 / 3), null)[0]] += 1
out = {k: {"sd_over_mean_median": round(float(np.median(v["sd_over_mean"])), 3), "as_is": {a: b / N for a, b in v["as_is"].items()}, "raised_a_third": {a: b / N for a, b in v["third"].items()}} for k, v in res.items()}
print(json.dumps(out, indent=1))
