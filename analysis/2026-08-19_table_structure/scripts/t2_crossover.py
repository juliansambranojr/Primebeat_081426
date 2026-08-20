"""
TEST 2 - the crossover, measured across bases.

Depth damps the smooth mode by (b-1)/b per step and grows a critical-line
mode by |1 - b^(-rho)|. Somewhere the second overtakes the first: the
crossover. Crossover.lean proves there is at most one, and O39 put its
onset at d = 13 for the dyadic prime table.

Here it is measured directly, and for every base on the same footing:
for each depth, split the row's spectral power into DC (the smooth,
frequency-free part) and everything else (oscillation). The crossover is
the first depth where oscillation carries more than half the power.

Bases: 2 and 3, the sub-integer optimal family exp(pi*k/(2*gamma1)), and
two controls that are NOT family members - 2^(1/2) and 2^(1/3), of which
base 2 is a literal sub-sampling.

Every base is run to the same value ceiling 2^32, so they are compared
over the same stretch of the number line rather than the same r.
"""
import math
import numpy as np
from primecountpy import prime_pi
from _paths import tee

tee(__file__)

GAMMA1 = 14.134725141734693
V = 2 ** 32                      # common value ceiling, O45's

FAMILY = [("family k=1", math.exp(math.pi * 1 / (2 * GAMMA1))),
          ("family k=2", math.exp(math.pi * 2 / (2 * GAMMA1))),
          ("family k=3", math.exp(math.pi * 3 / (2 * GAMMA1))),
          ("family k=4", math.exp(math.pi * 4 / (2 * GAMMA1)))]
CONTROLS = [("2^(1/2)", 2 ** 0.5), ("2^(1/3)", 2 ** (1 / 3))]
INTEGERS = [("dyadic", 2.0), ("triadic", 3.0)]

BASES = INTEGERS + FAMILY + CONTROLS


def seed_row(b):
    """N(r) = pi(floor(b^r)) - pi(floor(b^(r-1))), to the common ceiling."""
    rmax = int(math.floor(math.log(V) / math.log(b)))
    cuts = [int(math.floor(b ** r)) for r in range(0, rmax + 1)]
    pis = [prime_pi(c) for c in cuts]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)], rmax


def build(row):
    rows = [row]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


def power_split(rows, b, min_n=10):
    """Per depth: fraction of spectral power that is NOT at DC."""
    lnb = math.log(b)
    out = []
    for d, row in enumerate(rows):
        N = len(row)
        if N < min_n:
            break
        u = np.empty(N)
        for i, v in enumerate(row):
            r = i + d + 1
            mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
            win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (N - 1))
            u[i] = math.copysign(mag, v) * win
        F = np.abs(np.fft.rfft(u)) ** 2
        dc, osc = F[0], F[1:].sum()
        tot = dc + osc
        out.append(osc / tot if tot > 0 else float("nan"))
    return out


def gain_ratio(b):
    """How fast the gamma1 mode gains on the smooth one, per depth."""
    rho = complex(0.5, GAMMA1)
    resid = abs(1 - complex(b) ** (-rho))
    smooth = (b - 1) / b
    return resid / smooth, resid, smooth


print(f"{'base':13} {'b':>8} {'r_max':>6} {'ratio/Δ':>8} {'d*':>5}  osc fraction by depth 0,2,4,…")
rowsout = []
for name, b in BASES:
    row, rmax = seed_row(b)
    rows = build(row)
    frac = power_split(rows, b)
    R, resid, smooth = gain_ratio(b)
    cross = next((d for d, f in enumerate(frac) if f == f and f > 0.5), None)
    rowsout.append((name, b, rmax, R, cross, frac))
    head = "  ".join(f"{frac[d]:.2f}" for d in range(0, min(len(frac), 13), 2))
    print(f"{name:13} {b:8.4f} {rmax:6d} {R:8.3f} {str(cross):>5}  {head}")

print()
print("d* = first depth where oscillation carries more than half the power.")
print("ratio/Δ = |1-b^(-rho)| / ((b-1)/b) at rho = 1/2 + i*gamma1 - how fast")
print("the residual gains on the trend each step. Larger should cross sooner.")
print()
ok = [(n, R, c) for n, b, rm, R, c, f in rowsout if c is not None]
if len(ok) > 2:
    Rs = np.array([r for _, r, _ in ok]); ds = np.array([c for _, _, c in ok], float)
    lr = np.corrcoef(np.log(Rs), ds)[0, 1]
    print(f"corr(log ratio, d*) = {lr:+.3f} over {len(ok)} bases that cross")
    print("negative means a faster gain ratio does cross sooner, as the chain says")
