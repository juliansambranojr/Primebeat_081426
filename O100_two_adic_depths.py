"""O100 — trailing zero bits of the table's cells at power-of-two depths (prereg
preregs/two_adic_power_depths_v1_20261128.md). EXPLORATORY until the prereg is locked and run.

A cell is zero iff divisible by every power of 2, so its trailing zero bits v2 measure how close it comes to
zero in binary. Question: at depths 1, 2, 4, 8, 16 do the true cells carry more trailing zeros than the same
cells built from rows whose low 20 bits are random? All arithmetic is modulo 2^20: v2 capped at 20 depends
only on the rows modulo 2^20.

Cells: rows r <= 92, depth d < r, lowest row r - d >= 26 (every row used has at least 21 bits, so replacing its
low 20 bits keeps its size). Primary depths {1, 2, 4, 8, 16}; placebo depths {3, 5, 6, 7, 9, ..., 15};
secondary depths {32, 64}, reported, no verdict.
Statistic: T = mean over the cells of min(v2, 20). Null: 10000 tables from rows with low 20 bits replaced by
uniform random bits, numpy.default_rng(20261128). p = (1 + #{T_null >= T}) / (1 + 10000), one-sided.
No flags. Output results/O100_two_adic_depths.json, by guarded_write (switched after the run, 2026-11-28; see the prereg's run record)."""
import json, hashlib, time, sys, os
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from utilities.resultsguard import guarded_write
B = 20; MOD = 1 << B; CAP = 20; NNULL = 10000; SEED = 20261128; RMAX = 92; LOWROW = 26
PRIMARY = (1, 2, 4, 8, 16); PLACEBO = tuple(d for d in range(3, 16) if d not in (4, 8)); SECONDARY = (32, 64)
SRC = 'b007053.txt'; SRC_SHA = '6f4f5aaca7419f8c3d0a9d41b56617a1347ab4c124eec3f64362e299f7d8179b'

def load():
    raw = open(SRC, 'rb').read()
    sha = hashlib.sha256(raw).hexdigest()
    pi = {}
    for line in raw.decode().split('\n'):
        f = line.split()
        if len(f) == 2: pi[int(f[0])] = int(f[1])
    return sha, pi

def cells_for(depths):
    return [(r, d) for d in depths for r in range(LOWROW + d, RMAX + 1)]

def weights(cells):
    """W[i, m] = (-1)^j C(d, j) mod 2^B for the rows m = r - j of cell i."""
    from math import comb
    W = np.zeros((len(cells), RMAX + 1), dtype=np.int64)
    for i, (r, d) in enumerate(cells):
        for j in range(d + 1): W[i, r - j] = ((-1) ** j * comb(d, j)) % MOD
    return W

def v2cap(x):
    """x: int64 array of residues mod 2^B; trailing zeros, capped at CAP (x == 0 gives CAP)."""
    x = np.asarray(x, dtype=np.int64); out = np.full(x.shape, CAP, dtype=np.int64)
    nz = x != 0
    low = x[nz] & (-x[nz])
    out[nz] = np.minimum(np.log2(low.astype(np.float64)).round().astype(np.int64), CAP)
    return out

def cell_residues(W, rows_mod):
    """rows_mod: (..., RMAX+1) int64 residues; returns (..., ncells) residues mod 2^B. Products stay < 2^63
    because both factors are below 2^20 and at most 65 terms are summed."""
    return (rows_mod @ W.T) % MOD

def main():
    t0 = time.time()
    sha, pi = load()
    a = {m: pi[m] - pi[m - 1] for m in range(1, RMAX + 1)}
    integrity = {"src_sha256": sha, "src_sha_ok": sha == SRC_SHA,
                 "rows_present": all(m in pi for m in range(0, RMAX + 1)),
                 "rows_ge_21_bits": all(a[m].bit_length() >= 21 for m in range(LOWROW, RMAX + 1))}
    arms = {"primary": PRIMARY, "placebo": PLACEBO, "secondary": SECONDARY}
    C = {k: cells_for(v) for k, v in arms.items()}
    integrity["cells"] = {k: len(v) for k, v in C.items()}
    Wt = {k: weights(v) for k, v in C.items()}
    real_rows = np.array([0] + [a[m] % MOD for m in range(1, RMAX + 1)], dtype=np.int64)
    # the true cells, exactly, for the integrity check against the mod-2^B route
    from math import comb
    exact_ok = True
    for (r, d) in C["primary"][:40]:
        v = sum((-1) ** j * comb(d, j) * a[r - j] for j in range(d + 1))
        if v % MOD != int(cell_residues(Wt["primary"][[C['primary'].index((r, d))]], real_rows)[0]): exact_ok = False
    integrity["mod_route_matches_exact"] = exact_ok
    T = {k: float(v2cap(cell_residues(Wt[k], real_rows)).mean()) for k in arms}
    rng = np.random.default_rng(SEED)
    nullT = {k: np.empty(NNULL) for k in arms}
    keep = np.zeros(RMAX + 1, dtype=bool); keep[:LOWROW] = True
    CH = 500
    for s in range(0, NNULL, CH):
        n = min(CH, NNULL - s)
        R = np.tile(real_rows, (n, 1))
        R[:, LOWROW:] = rng.integers(0, MOD, size=(n, RMAX + 1 - LOWROW), dtype=np.int64)
        for k in arms: nullT[k][s:s + n] = v2cap(cell_residues(Wt[k], R)).mean(1)
    p = {k: float((1 + (nullT[k] >= T[k]).sum()) / (1 + NNULL)) for k in arms}
    nullmean = {k: float(nullT[k].mean()) for k in arms}
    integrity["null_mean_primary_in_range"] = 0.85 <= nullmean["primary"] <= 1.15
    integrity_ok = all(v for kk, v in integrity.items() if isinstance(v, bool))
    if not integrity_ok: label = "compromised"
    elif p["primary"] <= 0.01 and p["placebo"] > 0.01: label = "excess"
    elif p["primary"] >= 0.10: label = "no_excess"
    else: label = "ambiguous"
    out = {"schema_version": "1", "script": "O100_two_adic_depths.py",
           "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
           "params": {"B": B, "cap": CAP, "null_draws": NNULL, "seed": SEED, "rows_max": RMAX, "lowest_row": LOWROW,
                      "primary": PRIMARY, "placebo": PLACEBO, "secondary": SECONDARY, "src": SRC},
           "integrity": integrity, "integrity_ok": integrity_ok,
           "summary": {"T": T, "null_mean": nullmean, "null_sd": {k: float(nullT[k].std()) for k in arms}, "p": p,
                       "per_depth_mean_v2": {str(d): float(v2cap(cell_residues(weights(cells_for((d,))), real_rows)).mean())
                                             for d in PRIMARY + SECONDARY},
                       "decision_rule_output": label},
           "meta": {"wall_s": round(time.time() - t0, 1)}}
    guarded_write(out, "results/O100_two_adic_depths.json", indent=1)
    print(json.dumps(out["summary"], indent=1))

if __name__ == "__main__":
    main()
