# EXPLORATORY design check for an edge-excess test pooled over bases. Synthetic GUE heights only (no true zero read).
# Base b: row r = primes in (b^(r-1), b^r]; a zero's term in a cell is the explicit-formula term with log b in place of
# log 2. Cells: edges row = depth + q, q in (1, 2, 4, 8, 16), depths 17..400. Each cell over its scale
# b^(r/2) (1 + b^(-1/2))^d. Null: one random phase per zero, shared by every cell of every base.
import sys, json, math, numpy as np
from scipy.special import exp1
sys.path.insert(0, '/home/user/Primebeat_081426')
import O101_edge_correlation as O1, O102_edge_excess_frozen_phase as O2
BASES = {"2": 2.0, "3": 3.0, "sqrt2": math.sqrt(2), "sqrt3": math.sqrt(3), "2^1.5": 2 ** 1.5, "e": math.e}
QS = (1, 2, 4, 8, 16); DMAX = 400
def geometry(b):
    lb = math.log(b); lg = math.log(1 + b ** -0.5)
    cells = [(d + q, d) for q in QS for d in range(17, DMAX + 1)]
    RMAX = max(r for r, d in cells); W = np.zeros((len(cells), RMAX + 1))
    for i, (r, d) in enumerate(cells):
        for j in range(d + 1):
            W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * lb / 2 - (r * lb / 2 + d * lg))
    return W, RMAX, lb
def terms(h, W, RMAX, lb, CH=2500):
    ms = np.arange(RMAX + 1); C = np.empty((W.shape[0], len(h)), dtype=np.complex64); obs = np.zeros(W.shape[0]); sq = np.zeros(W.shape[0])
    for k0 in range(0, len(h), CH):
        gg = h[k0:k0 + CH]; z = ms[:, None] * (0.5 + 1j * gg)[None, :] * lb
        E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
        row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * lb / 2)[:, None]
        T = -2 * (W @ row); obs += T.real.sum(1); sq += (np.abs(T) ** 2).sum(1); C[:, k0:k0 + len(gg)] = T.astype(np.complex64)
    return C, obs, np.sqrt(sq / 2)
G = {k: geometry(b) for k, b in BASES.items()}
rng = np.random.default_rng(7301); rngd = np.random.default_rng(7302); NSET = 12; ND = 200
per_set = []
for j in range(NSET):
    h = O1.heights_from_unfolded(O1.gue_unfolded(rng, 10000))
    ph = np.exp(1j * rngd.uniform(0, 2 * np.pi, (len(h), ND))).astype(np.complex64)
    own = {}; null = {}
    for k, (W, R, lb) in G.items():
        C, obs, sig = terms(h, W, R, lb)
        own[k] = int((np.abs(obs) < 0.05 * sig).sum())
        null[k] = (np.abs((C @ ph).real) < 0.05 * sig[:, None]).sum(0)
    names = list(BASES)
    M = np.array([null[k] for k in names])            # bases x draws
    corr = np.corrcoef(M)
    pooled = M.sum(0); Opool = sum(own.values())
    rec = {"own": own, "null_mean": {k: float(null[k].mean()) for k in names}, "sd_over_mean": {k: float(null[k].std() / null[k].mean()) for k in names},
           "pooled_sd_over_mean": float(pooled.std() / pooled.mean()), "mean_offdiag_corr": float((corr.sum() - len(names)) / (len(names) ** 2 - len(names))),
           "rule_as_is_pooled": O2.rule(Opool, pooled)[0], "rule_third_pooled": O2.rule(round(Opool * 4 / 3), pooled)[0],
           "rule_as_is_base2": O2.rule(own["2"], null["2"])[0], "rule_third_base2": O2.rule(round(own["2"] * 4 / 3), null["2"])[0]}
    per_set.append(rec); print(j, round(rec["pooled_sd_over_mean"], 3), round(rec["mean_offdiag_corr"], 3), rec["rule_third_pooled"], flush=True)
def rate(key): 
    from collections import Counter; c = Counter(r[key] for r in per_set); return {k: v / NSET for k, v in c.items()}
summary = {"bases": list(BASES), "sets": NSET, "draws": ND,
    "sd_over_mean_median_per_base": {k: round(float(np.median([r["sd_over_mean"][k] for r in per_set])), 3) for k in BASES},
    "pooled_sd_over_mean_median": round(float(np.median([r["pooled_sd_over_mean"] for r in per_set])), 3),
    "mean_offdiag_corr_median": round(float(np.median([r["mean_offdiag_corr"] for r in per_set])), 3),
    "pooled_rule_as_is": rate("rule_as_is_pooled"), "pooled_rule_third": rate("rule_third_pooled"),
    "base2_rule_as_is": rate("rule_as_is_base2"), "base2_rule_third": rate("rule_third_base2")}
json.dump({"summary": summary, "per_set": per_set}, open('/home/user/Primebeat_081426/analysis/2026-11-28/o103_bases/bases_design_output.json', 'w'), indent=1)
print(json.dumps(summary, indent=1))
