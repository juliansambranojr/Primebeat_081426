"""O103 — is the edge excess a property of the zeros? Edges pooled over 24 bases against one shared random phase per
zero (prereg preregs/edge_excess_multibase_v1_20261128.md). EXPLORATORY until that prereg is locked and run.

Unit 0650 found that one base-2 table's near-zero count spreads by about four tenths of itself under shared random
phases, so unit 0642's excess of a third could not be seen. The analysis in analysis/2026-11-28/o103_bases/ found the
counts of different bases uncorrelated under a phase null shared across bases, so pooling bases narrows the spread.
Base b: row r counts primes in (b^(r-1), b^r]; a zero's term in a cell is the explicit-formula term with log b in
place of log 2; each cell over its scale b^(r/2) (1 + b^(-1/2))^d. Cells per base: edges row = depth + q,
q in (1, 2, 4, 8, 16), depths 17..400. The quantity counted is the zeros' sum in each cell (the smooth part left out,
as in unit 0642), below t = 0.05 of its root-square size. Null: every zero's term in every cell of every base turned
by one phase theta_k shared by all of them. Output results/O103_edge_excess_multibase.json, by guarded_write."""
import json, math, sys, os, hashlib, time
import numpy as np
from scipy.special import exp1
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from utilities.resultsguard import guarded_write
ZEROS = 'imported/odlyzko/zeros6'; ZEROS_SHA = '2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6'
K = 100000; NDRAW = 1000; SEED = 20261201; THR = (0.02, 0.05, 0.1); QS = (1, 2, 4, 8, 16); DMIN, DMAX = 17, 400
PHI = (math.sqrt(5) - 1) / 2
XS = sorted([0.5 + 1.3 * ((i * PHI) % 1.0) for i in range(1, 23)])
BASES = [("2", 2.0), ("3", 3.0)] + [(f"2^{x:.4f}", 2 ** x) for x in XS]
def geometry(b):
    lb = math.log(b); lg = math.log(1 + b ** -0.5)
    cells = [(d + q, d) for q in QS for d in range(DMIN, DMAX + 1)]
    RMAX = max(r for r, d in cells); W = np.zeros((len(cells), RMAX + 1))
    for i, (r, d) in enumerate(cells):
        for j in range(d + 1):
            W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * lb / 2 - (r * lb / 2 + d * lg))
    return W, RMAX, lb
def terms(h, W, RMAX, lb, CH=2500):
    """complex64 terms of every zero in every cell, with the zeros' sum and the squared sizes in float64."""
    ms = np.arange(RMAX + 1); C = np.empty((W.shape[0], len(h)), dtype=np.complex64); obs = np.zeros(W.shape[0]); sq = np.zeros(W.shape[0])
    for k0 in range(0, len(h), CH):
        gg = h[k0:k0 + CH]; z = ms[:, None] * (0.5 + 1j * gg)[None, :] * lb
        E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
        row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * lb / 2)[:, None]
        T = -2 * (W @ row); obs += T.real.sum(1); sq += (np.abs(T) ** 2).sum(1); C[:, k0:k0 + len(gg)] = T.astype(np.complex64)
    return C, obs, np.sqrt(sq / 2)
def phases(n, ndraw, seed, block=100):
    """the shared phase draws, generated block by block from one stream so every base sees the same theta."""
    rng = np.random.default_rng(seed)
    return [np.exp(1j * rng.uniform(0, 2 * np.pi, (n, min(block, ndraw - b0)))).astype(np.complex64) for b0 in range(0, ndraw, block)]
def base_counts(h, b, PH):
    W, R, lb = geometry(b); C, obs, sig = terms(h, W, R, lb)
    own = {str(t): int((np.abs(obs) < t * sig).sum()) for t in THR}
    null = {str(t): [] for t in THR}
    for ph in PH:
        v = (C @ ph).real
        for t in THR: null[str(t)] += (np.abs(v) < t * sig[:, None]).sum(0).tolist()
    zp = int((np.abs((C @ np.ones((C.shape[1], 1), dtype=np.complex64)).real[:, 0]) < 0.05 * sig).sum())
    return own, null, zp
def rule(Oc, null):
    null = np.asarray(null); p = float((1 + (null >= Oc).sum()) / (1 + len(null)))
    return ("excess_real" if p <= 0.01 else ("consistent_with_chance" if p >= 0.10 else "ambiguous")), p
def main():
    t0 = time.time()
    sha = hashlib.sha256(open(ZEROS, 'rb').read()).hexdigest()
    h = np.loadtxt(ZEROS, max_rows=K); PH = phases(K, NDRAW, SEED)
    per = {}; zps = {}
    for name, b in BASES:
        own, null, zp = base_counts(h, b, PH); per[name] = {"own": own, "null": null}; zps[name] = zp
        print(name, own["0.05"], round(float(np.mean(null["0.05"])), 1), flush=True)
    tot_own = {t: sum(per[n]["own"][t] for n, _ in BASES) for t in map(str, THR)}
    tot_null = {t: np.sum([per[n]["null"][t] for n, _ in BASES], 0) for t in map(str, THR)}
    zp_total = sum(zps.values())
    integrity = {"zeros_sha_ok": sha == ZEROS_SHA, "bases": len(BASES), "bases_distinct": len(set(round(b, 9) for _, b in BASES)) == len(BASES),
                 "zero_phase_total_005": zp_total, "observed_total_005": tot_own["0.05"],
                 "zero_phase_reproduces_observed": abs(zp_total - tot_own["0.05"]) <= 10}
    ok = all(v for v in integrity.values() if isinstance(v, bool))
    label, p = rule(tot_own["0.05"], tot_null["0.05"])
    if not ok: label = "compromised"
    q = lambda x: {"mean": round(float(np.mean(x)), 2), "sd": round(float(np.std(x)), 2), "q05": float(np.quantile(x, 0.05)), "q95": float(np.quantile(x, 0.95))}
    out = {"schema_version": "1", "script": "O103_edge_excess_multibase.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "params": {"K": K, "draws": NDRAW, "seed": SEED, "thresholds": THR, "edges": QS, "depths": [DMIN, DMAX], "bases": [[n, b] for n, b in BASES], "zeros": ZEROS},
           "integrity": integrity, "integrity_ok": ok,
           "summary": {"primary": {"observed": tot_own["0.05"], "null": q(tot_null["0.05"]), "p": p},
                       "thresholds": {t: {"observed": tot_own[t], "null": q(tot_null[t]), "p": rule(tot_own[t], tot_null[t])[1]} for t in map(str, THR)},
                       "per_base_005": {n: {"observed": per[n]["own"]["0.05"], "null": q(per[n]["null"]["0.05"]), "p": rule(per[n]["own"]["0.05"], per[n]["null"]["0.05"])[1]} for n, _ in BASES},
                       "between_base_corr_mean": round(float((np.corrcoef(np.array([per[n]["null"]["0.05"] for n, _ in BASES])).sum() - len(BASES)) / (len(BASES) ** 2 - len(BASES))), 4),
                       "decision_rule_output": label},
           "meta": {"wall_s": round(time.time() - t0, 1)}}
    guarded_write(out, "results/O103_edge_excess_multibase.json")
    print(json.dumps(out["summary"]["primary"]), label)
if __name__ == "__main__":
    main()
