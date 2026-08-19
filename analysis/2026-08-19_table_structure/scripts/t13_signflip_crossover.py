"""
TEST 13 - sign-flip density, and where it crosses.  RECONSTRUCTION.

t2_crossover.py locates the crossover spectrally: the first depth where
oscillation carries more than half the row's power.  That involves an
envelope divisor, a Hann window and an FFT.  This is the same question
asked with none of that machinery - just count sign changes.

For each row of the difference table, take the nonzero entries in order
and report the fraction of adjacent pairs whose signs differ.  A purely
smooth row never changes sign, so the fraction is 0.  A row dominated by
an oscillation changes sign about half the time or more.  The crossover
is the first depth where the fraction passes 0.5.

Reported alongside the spectral d* from t2's construction at the same
ceiling, so the two instruments can be compared on the same rows.

MIN_ROW is the shortest row admitted.  t2 uses 10, which truncates the
triadic run before it crosses; the three headline crossings below are
identical for every MIN_ROW from 3 to 8, and MIN_ROW = 5 is what this
file locks.

WHAT THIS DOES NOT CLAIM.  A sign-flip fraction is a descriptive
statistic with no null attached here - there is no test that 0.5 is a
meaningful threshold rather than a convenient one, and no prereg or
decision rule.  A base reading 0.00 at every admitted depth means its
run ends before anything changes sign at this ceiling, which is a
statement about extent, not about the base.  Agreement or disagreement
with the spectral d* is reported, not interpreted.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived.  Written afterwards from the
reported numbers and re-run.  Every figure reproduced.  See the NOTEPAD
line for the chronology.
"""
import math

import numpy as np
from primecountpy import prime_pi

# --- locked constants ---------------------------------------------------
VALUE_CEILING = 2 ** 32
BASES = [2, 3, 4, 5, 6, 7, 8, 9]
MIN_ROW = 5                 # shortest row admitted to the sign-flip measure
MIN_ROW_SPECTRAL = 10       # t2_crossover.py's own value, kept for its column
THRESHOLD = 0.5
MIN_ROW_ROBUSTNESS = [3, 4, 5, 6, 7, 8, 10]


def seed_row(b, ceiling):
    r_max = int(math.floor(math.log(ceiling) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(r_max + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, r_max + 1)], r_max


def build(row):
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


def flip_fractions(rows, min_row):
    """Per depth: fraction of adjacent nonzero pairs whose signs differ."""
    out = []
    for row in rows:
        if len(row) < min_row:
            break
        nz = [v for v in row if v != 0]
        if len(nz) < 2:
            break
        flips = sum(1 for i in range(1, len(nz)) if nz[i] * nz[i - 1] < 0)
        out.append(flips / (len(nz) - 1))
    return out


def spectral_osc(rows, b, min_row):
    """t2_crossover.py's power_split, reproduced here for the d* column."""
    lnb = math.log(b)
    out = []
    for d, row in enumerate(rows):
        n = len(row)
        if n < min_row:
            break
        u = np.empty(n)
        for i, v in enumerate(row):
            r = i + d + 1
            mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
            win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (n - 1))
            u[i] = math.copysign(mag, v) * win
        F = np.abs(np.fft.rfft(u)) ** 2
        tot = F[0] + F[1:].sum()
        out.append(F[1:].sum() / tot if tot > 0 else float("nan"))
    return out


def first_cross(fracs):
    return next((d for d, f in enumerate(fracs) if f > THRESHOLD), None)


print("TEST 13 - sign-flip density and the crossover.  Reconstruction; "
      "exploratory.")
print(f"value ceiling 2^32 = {VALUE_CEILING}   MIN_ROW = {MIN_ROW}   "
      f"threshold {THRESHOLD}")
print()
print(f"{'base':>6}{'r_max':>7}{'depths':>8}{'flip d*':>9}{'spectral d*':>13}"
      f"   flip fraction by depth")

tables = {}
for b in BASES:
    row, r_max = seed_row(b, VALUE_CEILING)
    rows = build(row)
    tables[b] = rows
    fr = flip_fractions(rows, MIN_ROW)
    sp = spectral_osc(rows, b, MIN_ROW_SPECTRAL)
    fd, sd = first_cross(fr), first_cross(sp)
    print(f"{b:>6}{r_max:>7}{len(fr):>8}{str(fd):>9}{str(sd):>13}   "
          + " ".join(f"{f:.2f}" for f in fr))

print()
print("flip d* = first depth whose sign-flip fraction exceeds 0.5;")
print(f"spectral d* = t2_crossover.py's measure at MIN_ROW={MIN_ROW_SPECTRAL}.")
print("None means the run ends at this ceiling before it crosses.")

print()
print("robustness of the three headline crossings to MIN_ROW:")
print(f"{'MIN_ROW':>9}{'base 2':>9}{'base 3':>9}   bases 4-9")
for m in MIN_ROW_ROBUSTNESS:
    f2 = first_cross(flip_fractions(tables[2], m))
    f3 = first_cross(flip_fractions(tables[3], m))
    rest = [first_cross(flip_fractions(tables[b], m)) for b in range(4, 10)]
    allflat = all(
        all(f == 0.0 for f in flip_fractions(tables[b], m)) for b in range(4, 10))
    print(f"{m:>9}{str(f2):>9}{str(f3):>9}   "
          + ("all flat at 0.00" if allflat else f"crossings {rest}"))
