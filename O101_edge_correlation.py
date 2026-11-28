"""O101 — does the zeros' known correlation explain unit 0642's edge excess? (prereg
preregs/edge_excess_correlation_v1_20261128.md). EXPLORATORY until that prereg is locked and run.

Unit 0642 counted cells near the corner's edge below a fraction t of their root-square size and found about a
third more than benchmark 1, which keeps each zero's true amplitude and gives it an independent phase. Here the
same cells (twelve edges, row = depth + q, q = 1..64, depths to 600; two rays, row = 2d and 3d, depths to 420; all
inside Capstone.OpenCorner) are recounted with the first K = 10000 zeros, against:
  1. benchmark 1, as in 0642: the fifty largest terms at their own amplitudes and independent phases over a
     Gaussian rest, 4000 Monte Carlo draws per cell;
  2. GUE: heights from beta = 2 Hermite spectra (Dumitriu-Edelman tridiagonal model), the central eigenvalues
     unfolded by the semicircle law to unit mean spacing and mapped to heights through the zeros' smooth counting
     function N(T) = (T / 2 pi) log(T / 2 pi e) + 7/8;
  3. Poisson: unit-mean exponential spacings, mapped the same way.
Benchmarks 2 and 3 put each synthetic height through the same explicit-formula engine as the true zeros, so their
amplitudes and phases come from their own heights. Outputs results/O101_edge_correlation.json, by guarded_write."""
import json, math, sys, os, hashlib, time
import numpy as np
from scipy.special import exp1
from scipy.linalg import eigvalsh_tridiagonal
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from utilities.resultsguard import guarded_write
L2 = math.log(2); LG = math.log(1 + 2 ** -0.5)
ZEROS = 'imported/odlyzko/zeros6'
ZEROS_SHA = '2ef7b752c2f17405222e670a61098250c8e4e09047f823f41e2b41a7b378e7c6'
K = 10000; THR = (0.02, 0.05, 0.1); QS = (1, 2, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64)
NSET = 100; SEED_GUE = 20261129; SEED_POI = 20261130; SEED_MC = 20261128
def opencorner(r, d): return d >= 17 and r >= 93 and r < 4 * d + 30 and not (d >= 30 and r >= 3.7 * d + 39)
def geometry():
    diags = {f"edge{q}": [(d + q, d) for d in range(17, 601)] for q in QS}
    diags.update({f"ray{a}": [(round(a * d), d) for d in range(17, 421)] for a in (2.0, 3.0)})
    diags = {k: [c for c in v if opencorner(*c)] for k, v in diags.items()}
    cells = [c for v in diags.values() for c in v]
    ri = np.array([c[0] for c in cells]); di = np.array([c[1] for c in cells])
    lsc = ri * L2 / 2 + di * LG
    RMAX = int(ri.max())
    W = np.zeros((len(cells), RMAX + 1))
    for i, (r, d) in enumerate(cells):
        for j in range(d + 1):
            W[i, r - j] = (-1) ** j * math.exp(math.lgamma(d + 1) - math.lgamma(j + 1) - math.lgamma(d - j + 1) + (r - j) * L2 / 2 - lsc[i])
    return diags, cells, W, RMAX
def engine(heights, W, RMAX, keep_top=0, CH=2500):
    """cell values (each over its scale), sum of squared term sizes, and the keep_top largest term sizes."""
    ms = np.arange(RMAX + 1); n = W.shape[0]; cum = np.zeros(n); sq = np.zeros(n); top = None
    for k0 in range(0, len(heights), CH):
        gg = heights[k0:k0 + CH]; rho = 0.5 + 1j * gg
        z = ms[:, None] * rho[None, :] * L2
        E = np.where(ms[:, None] > 0, -exp1(-np.where(ms[:, None] > 0, z, 1)) + 1j * math.pi, 0)
        row = np.zeros_like(E); row[1:] = (E[1:] - E[:-1]) * np.exp(-ms[1:] * L2 / 2)[:, None]
        C = -2 * (W @ row)
        cum += C.real.sum(1); A = np.abs(C); sq += (A ** 2).sum(1)
        if keep_top:
            top = A if top is None else np.concatenate([top, A], 1)
            if top.shape[1] > 4 * keep_top: top = -np.sort(-top, 1)[:, :keep_top]
    if keep_top: top = -np.sort(-top, 1)[:, :keep_top]
    return cum, sq, top
def counts(diags, cum, sq):
    sig = np.sqrt(sq / 2); out = {}; i0 = 0
    for name, cl in diags.items():
        s = slice(i0, i0 + len(cl)); i0 += len(cl)
        out[name] = {str(t): int((np.abs(cum[s]) < t * sig[s]).sum()) for t in THR}
    out["edges_total"] = {str(t): sum(out[f"edge{q}"][str(t)] for q in QS) for t in THR}
    return out
def benchmark1(diags, sq, top, rng, NMC=4000):
    sig = np.sqrt(sq / 2); s50 = np.sqrt(np.maximum(sq - (top ** 2).sum(1), 0) / 2); n = len(sq)
    p = {t: np.zeros(n) for t in THR}
    for i0 in range(0, n, 200):
        sl = slice(i0, i0 + 200); nn = top[sl].shape[0]; X = np.zeros((nn, NMC))
        for k in range(top.shape[1]): X += top[sl, k][:, None] * np.cos(rng.uniform(0, 2 * np.pi, (nn, NMC)))
        X += s50[sl][:, None] * rng.standard_normal((nn, NMC))
        for t in THR: p[t][sl] = (np.abs(X) < t * sig[sl][:, None]).mean(1)
    out = {}; i0 = 0
    for name, cl in diags.items():
        s = slice(i0, i0 + len(cl)); i0 += len(cl); out[name] = {str(t): round(float(p[t][s].sum()), 2) for t in THR}
    out["edges_total"] = {str(t): round(sum(out[f"edge{q}"][str(t)] for q in QS), 2) for t in THR}
    return out
def Nsmooth(T): return T / (2 * math.pi) * np.log(T / (2 * math.pi * math.e)) + 7 / 8
def heights_from_unfolded(u):
    """invert N(T) = u + 1/2 (the n-th zero sits near N = n - 1/2) by Newton, T > 2 pi."""
    target = u + 0.5; T = np.maximum(2 * math.pi * np.exp(1.0) + 1.0, 2 * math.pi * (target + 1) / np.log(np.maximum(target, 2.0) + 2))
    for _ in range(60):
        f = Nsmooth(T) - target; fp = np.log(T / (2 * math.pi)) / (2 * math.pi)
        T = np.maximum(T - f / fp, 7.0)
    return T
def gue_unfolded(rng, k):
    n = 3 * k; beta = 2
    a = rng.normal(0, math.sqrt(2), n) / math.sqrt(2)
    b = np.sqrt(rng.chisquare(beta * np.arange(n - 1, 0, -1))) / math.sqrt(2)
    lam = eigvalsh_tridiagonal(a, b)
    R = math.sqrt(2 * beta * n)          # semicircle radius 2 sqrt(n) for beta = 2 in this scaling
    x = np.clip(lam / R, -1, 1)
    F = n * (0.5 + (x * np.sqrt(1 - x * x) + np.arcsin(x)) / math.pi)
    c = np.argsort(np.abs(F - n / 2))[:k]; u = np.sort(F[c]); u = u - u[0]
    return u
def poisson_unfolded(rng, k):
    u = np.cumsum(rng.exponential(1.0, k)); return u - u[0]
def spacing_stats(u):
    s = np.diff(u); return float(s.mean()), float(s.var())

def rule(O, B1, G, P):
    """the locked decision rule, on totals over the twelve edges at t = 0.05."""
    exc = O - B1; Gm = float(np.median(G)); G95 = float(np.quantile(G, 0.95)); Pm = float(np.median(P))
    if exc <= 0: return "ambiguous", Gm, G95, Pm
    if O <= G95 and Gm - B1 >= 0.5 * exc and Pm - B1 < 0.5 * exc: return "explained", Gm, G95, Pm
    if O > G95 and Gm - B1 <= 0.2 * exc: return "unexplained", Gm, G95, Pm
    return "ambiguous", Gm, G95, Pm
def synthetic_sets(kind, seed, nset, diags, W, RMAX):
    rng = np.random.default_rng(seed); res = []; sp = []
    for j in range(nset):
        u = gue_unfolded(rng, K) if kind == "gue" else poisson_unfolded(rng, K)
        sp.append(spacing_stats(u))
        cum, sq, _ = engine(heights_from_unfolded(u), W, RMAX)
        res.append(counts(diags, cum, sq))
    return res, sp
def main():
    t0 = time.time()
    sha = hashlib.sha256(open(ZEROS, 'rb').read()).hexdigest()
    g = np.loadtxt(ZEROS, max_rows=100000)
    diags, cells, W, RMAX = geometry()
    cum, sq, top = engine(g[:K], W, RMAX, keep_top=50)
    obs = counts(diags, cum, sq)
    b1 = benchmark1(diags, sq, top, np.random.default_rng(SEED_MC))
    cum100, sq100, _ = engine(g, W, RMAX)
    obs100 = counts(diags, cum100, sq100)
    ref = json.load(open('units/0642-corner-edge-excess/run/edge.json'))["diagonals"]
    ref100 = sum(ref[f"edge{q}"]["t0.05"]["observed_K100000"] for q in QS)
    gue, spg = synthetic_sets("gue", SEED_GUE, NSET, diags, W, RMAX)
    poi, spp = synthetic_sets("poisson", SEED_POI, NSET, diags, W, RMAX)
    gm = float(np.mean([m for m, v in spg])); gv = float(np.mean([v for m, v in spg]))
    pm = float(np.mean([m for m, v in spp])); pv = float(np.mean([v for m, v in spp]))
    integrity = {"zeros_sha_ok": sha == ZEROS_SHA, "recount_K100000_edges_005": obs100["edges_total"]["0.05"],
                 "unit0642_K100000_edges_005": ref100, "recount_matches_0642": obs100["edges_total"]["0.05"] == ref100,
                 "gue_spacing_mean": round(gm, 4), "gue_spacing_var": round(gv, 4), "poisson_spacing_mean": round(pm, 4), "poisson_spacing_var": round(pv, 4),
                 "gue_spacing_ok": 0.98 <= gm <= 1.02 and 0.15 <= gv <= 0.21, "poisson_spacing_ok": 0.98 <= pm <= 1.02 and 0.9 <= pv <= 1.1}
    ok = all(v for v in integrity.values() if isinstance(v, bool))
    G = [x["edges_total"]["0.05"] for x in gue]; P = [x["edges_total"]["0.05"] for x in poi]
    O = obs["edges_total"]["0.05"]; B1 = b1["edges_total"]["0.05"]
    label, Gm, G95, Pm = rule(O, B1, G, P)
    if not ok: label = "compromised"
    def summ(sets):
        return {name: {t: {"median": float(np.median([s[name][t] for s in sets])), "q05": float(np.quantile([s[name][t] for s in sets], 0.05)),
                           "q95": float(np.quantile([s[name][t] for s in sets], 0.95))} for t in obs[name]} for name in obs}
    out = {"schema_version": "1", "script": "O101_edge_correlation.py", "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "params": {"K": K, "thresholds": THR, "edges": QS, "sets": NSET, "seed_gue": SEED_GUE, "seed_poisson": SEED_POI, "seed_mc": SEED_MC, "zeros": ZEROS},
           "integrity": integrity, "integrity_ok": ok,
           "summary": {"observed_K10000": obs, "observed_K100000": obs100, "benchmark1": b1, "gue": summ(gue), "poisson": summ(poi),
                       "primary": {"O": O, "B1": B1, "gue_median": Gm, "gue_q95": G95, "poisson_median": Pm}, "decision_rule_output": label},
           "meta": {"wall_s": round(time.time() - t0, 1)}}
    guarded_write(out, "results/O101_edge_correlation.json")
    print(json.dumps(out["summary"]["primary"], indent=1), label)
if __name__ == "__main__":
    main()
