"""O102 — is unit 0642's edge excess real? (prereg preregs/edge_excess_frozen_phase_v1_20261128.md).
EXPLORATORY until that prereg is locked and run.

Unit 0642 found about a third more cells near zero on the corner's edges than a benchmark giving each cell its own
independent phases. In a real table one zero's phase is shared by all its cells, so one table's count spreads far
more than that benchmark allows (the O101 power study). Null here: the true first K = 100000 zeros, each zero's
complex term in every cell rotated by one random phase theta_k shared by all its cells, theta_k independent and
uniform; the sizes, and each zero's pattern across cells, stay as they are. The observed count (theta = 0) against
1000 such draws. Cells, thresholds and engine are unit 0642's (O101_edge_correlation.geometry, .engine).
Output results/O102_edge_excess_frozen_phase.json, by guarded_write."""
import json, math, sys, os, hashlib, time
import numpy as np
from scipy.special import exp1
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from utilities.resultsguard import guarded_write
import O101_edge_correlation as O
K = 100000; NDRAW = 1000; SEED = 20261131; THR = (0.02, 0.05, 0.1); QS = O.QS
def terms(heights, W, RMAX, CH=2500):
    """the complex term of every zero in every cell (each cell over its scale) as complex64, with the observed cell
    values and the squared sizes summed in float64 as the terms are made (as in unit 0642's engine)."""
    ms = np.arange(RMAX + 1); L2 = O.L2; C = np.empty((W.shape[0], len(heights)), dtype=np.complex64)
    obs = np.zeros(W.shape[0]); sq = np.zeros(W.shape[0])
    for k0 in range(0, len(heights), CH):
        gg = heights[k0:k0 + CH]; rho = 0.5 + 1j * gg
        z = ms[:, None] * rho[None, :] * L2
        E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
        row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * L2 / 2)[:, None]
        T = -2 * (W @ row); obs += T.real.sum(1); sq += (np.abs(T) ** 2).sum(1)
        C[:, k0:k0 + len(gg)] = T.astype(np.complex64)
    return C, obs, sq
def edge_counts(diags, vals, sig):
    out = {}; i0 = 0
    for name, cl in diags.items():
        s = slice(i0, i0 + len(cl)); i0 += len(cl)
        out[name] = {str(t): (np.abs(vals[s]) < t * sig[s][:, None] if vals.ndim == 2 else np.abs(vals[s]) < t * sig[s]).sum(0).tolist() for t in THR}
    out["edges_total"] = {str(t): (np.sum([out[f"edge{q}"][str(t)] for q in QS], 0)).tolist() for t in THR}
    return out
def draws(C, diags, sig, rng, n, block=50):
    """counts over n frozen-phase draws, block draws at a time: vals = Re(C @ exp(i theta))."""
    tot = {str(t): [] for t in THR}; per = {}
    for b0 in range(0, n, block):
        nb = min(block, n - b0)
        ph = np.exp(1j * rng.uniform(0, 2 * np.pi, (C.shape[1], nb))).astype(np.complex64)
        vals = (C @ ph).real.astype(np.float64)
        c = edge_counts(diags, vals, sig)
        for t in THR: tot[str(t)] += c["edges_total"][str(t)]
        for name in diags:
            per.setdefault(name, {str(t): [] for t in THR})
            for t in THR: per[name][str(t)] += c[name][str(t)]
    return tot, per
def rule(Oc, null):
    null = np.asarray(null); p = float((1 + (null >= Oc).sum()) / (1 + len(null)))
    lab = "excess_real" if p <= 0.01 else ("consistent_with_chance" if p >= 0.10 else "ambiguous")
    return lab, p
def main():
    t0 = time.time()
    sha = hashlib.sha256(open(O.ZEROS, 'rb').read()).hexdigest()
    g = np.loadtxt(O.ZEROS, max_rows=K)
    diags, cells, W, RMAX = O.geometry()
    C, obs_vals, sq = terms(g, W, RMAX)
    sig = np.sqrt(sq / 2)
    obs = edge_counts(diags, obs_vals, sig)
    ref = json.load(open('units/0642-corner-edge-excess/run/edge.json'))["diagonals"]
    ref100 = sum(ref[f"edge{q}"]["t0.05"]["observed_K100000"] for q in QS)
    zero_phase = edge_counts(diags, (C @ np.ones((K, 1), dtype=np.complex64)).real.astype(np.float64), sig)
    tot, per = draws(C, diags, sig, np.random.default_rng(SEED), NDRAW)
    integrity = {"zeros_sha_ok": sha == O.ZEROS_SHA, "observed_edges_005": int(obs["edges_total"]["0.05"]), "unit0642_K100000_edges_005": ref100,
                 "observed_matches_0642": int(obs["edges_total"]["0.05"]) == ref100,
                 "zero_phase_count_edges_005": int(zero_phase["edges_total"]["0.05"][0]),
                 "zero_phase_draw_reproduces_observed": abs(zero_phase["edges_total"]["0.05"][0] - int(obs["edges_total"]["0.05"])) <= 2}
    ok = all(v for v in integrity.values() if isinstance(v, bool))
    Oc = int(obs["edges_total"]["0.05"]); label, p = rule(Oc, tot["0.05"])
    if not ok: label = "compromised"
    def q(x): x = np.asarray(x); return {"mean": round(float(x.mean()), 2), "sd": round(float(x.std()), 2), "q05": float(np.quantile(x, 0.05)), "q50": float(np.median(x)), "q95": float(np.quantile(x, 0.95))}
    sec = {str(t): {"observed": int(obs["edges_total"][str(t)]), "null": q(tot[str(t)]), "p": rule(int(obs["edges_total"][str(t)]), tot[str(t)])[1]} for t in THR}
    perd = {name: {"observed": int(obs[name]["0.05"]), "null": q(per[name]["0.05"]), "p": rule(int(obs[name]["0.05"]), per[name]["0.05"])[1]} for name in diags}
    out = {"schema_version": "1", "script": "O102_edge_excess_frozen_phase.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "params": {"K": K, "draws": NDRAW, "seed": SEED, "thresholds": THR, "zeros": O.ZEROS},
           "integrity": integrity, "integrity_ok": ok,
           "summary": {"primary": {"observed": Oc, "null": q(tot["0.05"]), "p": p}, "thresholds": sec, "per_diagonal_005": perd,
                       "decision_rule_output": label},
           "meta": {"wall_s": round(time.time() - t0, 1)}}
    guarded_write(out, "results/O102_edge_excess_frozen_phase.json")
    print(json.dumps(out["summary"]["primary"]), label)
if __name__ == "__main__":
    main()
