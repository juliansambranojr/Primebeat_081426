"""O98 — does the golden step, run from the first zeta zero, give the next zeros'
places in their basins?  Prereg: preregs/golden_step_basin_v1_20261126.md.

The place of a zero gamma in its basin: p = theta(gamma)/pi mod 1, theta the
Riemann-Siegel theta function, so Gram points sit at p = 0.  The prediction:
pred_n = p_1 + (n - 1)/phi mod 1, phi the golden ratio, for n = 2..228, the
228 zeros up to the point run's height 219313/500.  Score S: the share of
n in 2..228 with circular distance |pred_n - p_n| <= 0.1.  Null: the same score
against 100000 random orders of p_2..p_228 (a random start would keep the
golden step and so contain the hypothesis; the power study showed it never
fires).  No flags.
"""
import json, math, time
import numpy as np
import mpmath as mp

mp.mp.dps = 30
T1 = mp.mpf(219313) / 500
N_ZEROS = 228
TOL = 0.1
N_NULL = 100000
SEED = 2026
PHI = (1 + math.sqrt(5)) / 2

def score(pred, p):
    d = np.abs(((pred - p) + 0.5) % 1.0 - 0.5)
    return float(np.mean(d <= TOL))

def null_scores(pred, p, rng, n_null):
    """Scores of the fixed predictions against random orders of the places."""
    out = np.empty(n_null)
    for i in range(0, n_null, 1000):
        k = min(1000, n_null - i)
        perm = rng.permuted(np.broadcast_to(p, (k, len(p))), axis=1)
        d = np.abs(((pred[None, :] - perm) + 0.5) % 1.0 - 0.5)
        out[i:i + k] = np.mean(d <= TOL, axis=1)
    return out

def decide(S, pval, ok):
    if not ok: return "compromised"
    if S >= 0.5 and pval < 0.001: return "falls_out"
    if pval >= 0.05: return "does_not_fall_out"
    return "ambiguous"

def main():
    t0 = time.time()
    res = {"T1": float(T1), "tol": TOL, "n_null": N_NULL, "seed": SEED, "phi": PHI}
    gam = [mp.im(mp.zetazero(k)) for k in range(1, N_ZEROS + 1)]
    count_ok = int(mp.nzeros(T1)) == N_ZEROS and gam[-1] <= T1
    gram_err = max(abs(mp.siegeltheta(mp.grampoint(k)) / mp.pi - k) for k in (0, 10, 100, 200))
    p = np.array([float((mp.siegeltheta(g) / mp.pi) % 1) for g in gam])
    ok = bool(count_ok and gram_err < 1e-9 and np.all(np.isfinite(p)))
    res.update({"count_ok": bool(count_ok), "gram_err": float(gram_err), "integrity_ok": ok})
    rng = np.random.default_rng(SEED)
    for name, step in (("golden", 1 / PHI), ("mirror", 1 / PHI**2)):
        n = np.arange(1, N_ZEROS)
        pred = (p[0] + n * step) % 1.0
        S = score(pred, p[1:])
        nulls = null_scores(pred, p[1:], rng, N_NULL)
        pval = float((1 + np.sum(nulls >= S)) / (1 + N_NULL))
        res[f"{name}_S"] = S
        res[f"{name}_p"] = pval
        res[f"{name}_null_mean"] = float(np.mean(nulls))
        res[f"{name}_null_sd"] = float(np.std(nulls))
    res["mechanical_output"] = decide(res["golden_S"], res["golden_p"], ok)
    res["p_basin"] = [float(x) for x in p]
    res["wall_s"] = time.time() - t0
    json.dump(res, open("results/O98_golden_step_basin.json", "w"), indent=1)
    print("mechanical output:", res["mechanical_output"], " S =", res["golden_S"], " p =", res["golden_p"])

if __name__ == "__main__":
    main()
