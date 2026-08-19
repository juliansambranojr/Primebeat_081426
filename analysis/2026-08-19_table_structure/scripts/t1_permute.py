"""
TEST 1 - permutation null on the table itself.

The earlier nulls randomised the reference lines, which was wrong: eight
random lines against fifteen peaks land well by luck regardless of
resolution. This keeps the lines fixed at the aliased zeros and destroys
the ARRANGEMENT of the table instead, holding the multiset of cell values
exactly. If placement carries nothing, a shuffled table scores the same.

Two shuffles, because they answer different questions:
  within-row  - each row's own values reordered. Kills the ordering in r
                while preserving every row's magnitude profile exactly.
  whole-table - all cells pooled and redealt. Kills the depth structure
                too, so it is the looser null.

Reported as a z-score: how many null standard deviations the real
arrangement sits from the shuffled mean, plus an exact permutation p.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import importlib.util

spec = importlib.util.spec_from_file_location("sp", "spectra.py")
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

RNG = np.random.default_rng(2026)          # REFERENCES.md house seed
NPERM = 3000


def spectrum_from_rows(rows, b):
    """Same transform spectra.py uses, but on an arbitrary set of rows."""
    lnb, nbin = math.log(b), 64
    grid = np.linspace(0, math.pi, nbin)
    mat = []
    for d, row in enumerate(rows):
        N = len(row)
        if N < 8:
            break
        u = np.empty(N)
        for i, v in enumerate(row):
            r = i + d + 1
            mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
            win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (N - 1))
            u[i] = math.copysign(mag, v) * win
        idx = np.arange(N)
        P = np.abs(u @ np.exp(-1j * np.outer(idx, grid))) / N
        mx = P.max()
        mat.append(P / mx if mx > 0 else P)
    return grid, np.array(mat)


def score(rows, b, lines):
    grid, mat = spectrum_from_rows(rows, b)
    return m.alignment(grid, mat, lines)


def run(b, arm):
    rows = m.build(b, arm)
    rows = [r for r in rows if len(r) >= 8]
    lines = m.lines(b, 0.0)

    real, n = score(rows, b, lines)

    out = {}
    for mode in ("within-row", "whole-table"):
        vals = []
        pool = [v for r in rows for v in r] if mode == "whole-table" else None
        for _ in range(NPERM):
            if mode == "within-row":
                sh = [list(RNG.permutation(r)) for r in rows]
            else:
                p = list(RNG.permutation(pool))
                sh, k = [], 0
                for r in rows:
                    sh.append(p[k:k + len(r)])
                    k += len(r)
            v, _ = score(sh, b, lines)
            if v == v:
                vals.append(v)
        a = np.array(vals)
        z = (a.mean() - real) / a.std() if a.std() > 0 else float("nan")
        p = (1 + np.sum(a <= real)) / (1 + len(a))
        out[mode] = (a.mean(), a.std(), z, p)
    return real, n, out


print("TEST 1 - arrangement null. Lines fixed at the real aliased zeros;")
print("the table's cell placement is shuffled. z > 0 means the true")
print("arrangement matches the zeros better than a shuffled one.")
print()
print(f"{'panel':20} {'real':>7} {'nullmean':>9} {'sd':>7} {'z':>7} {'p':>8} {'n':>4}  shuffle")
for b, arm in [(2, "prime"), (2, "composite"), (3, "prime"), (3, "composite")]:
    try:
        real, n, out = run(b, arm)
    except Exception as e:
        print(f"base {b} {arm:<12}  FAILED: {e}")
        continue
    for mode, (mu, sd, z, p) in out.items():
        tag = f"base {b} {arm}"
        print(f"{tag:20} {real:7.4f} {mu:9.4f} {sd:7.4f} {z:7.2f} {p:8.4f} {n:4d}  {mode}")
print()
print(f"{NPERM} permutations per cell, seed 2026.")
