"""
TEST 12 - chain versus orphan.  RECONSTRUCTION.

t11 shows that 4, 8, 9 are decimations of 2, 2, 3 - their rung sequences
are their parents' summed in blocks, so whatever structure the parent
carries reaches them through a boxcar.  Bases 5, 6, 7 are prime and have
no parent in 2..9: they are orphans, sampling the same number line with
nothing upstream.

If having a parent in the set mattered to what a base's seed row looks
like spectrally, chain members and orphans should separate.  Measured
here on one statistic, at one depth, on one common ceiling: the fraction
of a row's spectral power that is NOT at DC.  Same split as
t2_crossover.py's power_split, evaluated at depth 0 only, so no
differencing has happened yet - this is the raw rung sequence.

Grouping used:
    roots   2, 3    - parents, decimated by others in the set
    chain   4, 8, 9 - have a parent in the set (2^2, 2^3, 3^2)
    orphan  5, 6, 7 - no parent in the set

WHAT THIS DOES NOT CLAIM.  Three bases per group is not a sample that
can support a separation claim in either direction, and no null,
significance test, prereg or decision rule is applied.  "No separation"
below means the eight numbers sit in a narrow band, not that a
difference has been ruled out.  One statistic at one depth at one
ceiling; results are not comparable across ceilings.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived.  Written afterwards from the
reported numbers and re-run.  Every figure reproduced.  See the NOTEPAD
line for the chronology.
"""
import math

import numpy as np
from primecountpy import prime_pi

# --- locked constants ---------------------------------------------------
VALUE_CEILING = 2 ** 48
DEPTH = 0                       # raw seed row, before any differencing
BASES = [2, 3, 4, 5, 6, 7, 8, 9]

PARENT = {4: (2, 2), 8: (2, 3), 9: (3, 2)}      # base -> (parent, k)
ROOTS = [2, 3]
CHAIN = [4, 8, 9]
ORPHAN = [5, 6, 7]


def seed_row(b, ceiling):
    r_max = int(math.floor(math.log(ceiling) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(r_max + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, r_max + 1)], r_max


def osc_fraction(row, b, depth):
    """Fraction of spectral power away from DC, after dividing out the
    b^(r/2) growth every critical-line mode carries and windowing.  Same
    construction as t2_crossover.py's power_split."""
    lnb = math.log(b)
    n = len(row)
    u = np.empty(n)
    for i, v in enumerate(row):
        r = i + depth + 1
        mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
        win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (n - 1))
        u[i] = math.copysign(mag, v) * win
    F = np.abs(np.fft.rfft(u)) ** 2
    dc, osc = F[0], F[1:].sum()
    return osc / (dc + osc)


print("TEST 12 - chain versus orphan.  Reconstruction; exploratory.")
print(f"value ceiling 2^48 = {VALUE_CEILING}   depth {DEPTH}")
print()
print(f"{'base':>6}{'group':>9}{'parent':>10}{'r_max':>7}{'osc fraction':>14}")

frac = {}
for b in BASES:
    row, r_max = seed_row(b, VALUE_CEILING)
    frac[b] = osc_fraction(row, b, DEPTH)
    if b in PARENT:
        p, k = PARENT[b]
        par, grp = f"{p}^{k}", "chain"
    elif b in ROOTS:
        par, grp = "-", "root"
    else:
        par, grp = "none", "orphan"
    print(f"{b:>6}{grp:>9}{par:>10}{r_max:>7}{frac[b]:>14.4f}")

vals = np.array([frac[b] for b in BASES])
print()
print(f"all eight span {vals.min():.4f} .. {vals.max():.4f}   "
      f"(width {vals.max()-vals.min():.4f})")
for name, group in (("root  ", ROOTS), ("chain ", CHAIN), ("orphan", ORPHAN)):
    g = np.array([frac[b] for b in group])
    print(f"   {name} {group}  mean {g.mean():.4f}   sd {g.std(ddof=1):.4f}")

ch = np.array([frac[b] for b in CHAIN])
orp = np.array([frac[b] for b in ORPHAN])
print()
print(f"chain mean - orphan mean = {ch.mean()-orp.mean():+.4f}, against a "
      f"total spread of {vals.max()-vals.min():.4f} across all eight.")
print("Three bases per group: this is a description of eight numbers, not")
print("a test of whether the two groups differ.")
