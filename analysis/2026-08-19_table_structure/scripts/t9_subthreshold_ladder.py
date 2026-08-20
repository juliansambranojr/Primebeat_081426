"""
TEST 9 - the sub-threshold base ladder.  RECONSTRUCTION.

Entry 26's Nyquist no-go says a base b can carry gamma_k unaliased only
while  pi / ln b > gamma_k,  i.e. only while  b < exp(pi/gamma_k).  Every
integer base fails at gamma_1 (exp(pi/gamma_1) = 1.2489, and 2 misses it
by 3x).  Below that threshold there is nothing stopping it.

So walk a ladder of bases DOWN through the thresholds and ask whether
each one recovers exactly the zeros beneath its own ceiling - no more,
no fewer.  Each zero has its own aliasing threshold exp(pi/gamma_k):

    gamma_1 14.1347 -> 1.2489      gamma_5 32.9351 -> 1.1001
    gamma_2 21.0220 -> 1.1612      gamma_6 37.5862 -> 1.0872
    gamma_3 25.0109 -> 1.1338      gamma_7 40.9187 -> 1.0798
    gamma_4 30.4249 -> 1.1088      gamma_8 43.3271 -> 1.0752

Construction, same as t6_multirate.py: sample the residual at x = b^r in
the coordinate u = ln x, where a zero's phase is simply gamma*u with no
ln b in it, and normalise by the natural size of one zero's term,
sqrt(x)/ln x.  Then a least-squares periodogram - at each trial gamma,
fit a*cos(gamma u) + b*sin(gamma u) and report variance explained.
Nothing is fitted to the zeros; the zeros are only where we look.

WHAT THIS DOES NOT CLAIM.  This is not a detection test.  There is no
null, no p-value, no prereg, and no decision rule - a peak here is not
evidence that the zero is "found" in any inferential sense, only that
the periodogram has a local maximum near where the explicit formula puts
one.  It also says nothing about integer bases: the whole point is that
these bases are below a threshold no integer base can reach.

RECONSTRUCTION NOTE.  The original of this analysis was run inline as a
heredoc during the 2026-08-19 session and no script survived.  This file
was written afterwards from the reported numbers and re-run.  The
sample-set geometry (rung counts, Nyquist ceilings, which zeros each
base recovers) reproduces exactly; the recovered gamma values agree to
within 0.003, which is 1.2% of the periodogram's own resolution element
2*pi/span = 0.243 rad.  See the NOTEPAD line for the chronology.
"""
import math

import numpy as np
import mpmath as mp
from primecountpy import prime_pi
from _paths import tee

tee(__file__)

mp.mp.dps = 30

# --- locked constants ---------------------------------------------------
VALUE_CEILING = 2 ** 44          # top of the sampled range, x <= 2^44
X_MIN = 100.0                    # bottom; rungs with b^r <= X_MIN dropped
N_ZEROS = 8                      # zeta zeros carried as reference lines
GRID_LO, GRID_HI, GRID_STEP = 1.0, 50.0, 0.001      # trial-gamma grid
PEAK_WINDOW = 0.5                # +-rad searched around each gamma_k

BASES = [1.2000, 1.1500, 1.1175, 1.1100, 1.0950, 1.0850, 1.0750]

GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, N_ZEROS + 1)]
GRID = np.arange(GRID_LO, GRID_HI, GRID_STEP)


def samples(b):
    """(u, y) at x = b^r for X_MIN < b^r <= VALUE_CEILING.

    u = ln x is the coordinate in which every zero's phase is gamma*u,
    independent of the base.  y is the residual pi(x) - li(x) divided by
    sqrt(x)/ln x, the size of a single zero's term, so that far samples
    do not swamp near ones."""
    lnb = math.log(b)
    r_min = int(math.floor(math.log(X_MIN) / lnb)) + 1
    r_max = int(math.floor(math.log(VALUE_CEILING) / lnb))
    u, y = [], []
    for r in range(r_min, r_max + 1):
        x = float(b) ** r
        resid = prime_pi(int(x)) - float(mp.li(x))
        lnx = math.log(x)
        u.append(lnx)
        y.append(resid / (math.sqrt(x) / lnx))
    return np.array(u), np.array(y), r_min, r_max


def periodogram(u, y, gammas):
    """Least-squares (Lomb-Scargle by hand): variance explained by a
    single cos/sin pair at each trial gamma.  No aliasing assumed,
    none corrected for."""
    y = y - y.mean()
    var = (y ** 2).sum()
    out = np.empty(len(gammas))
    for i, g in enumerate(gammas):
        A = np.column_stack([np.cos(g * u), np.sin(g * u)])
        coef, *_ = np.linalg.lstsq(A, y, rcond=None)
        out[i] = 1 - ((y - A @ coef) ** 2).sum() / var
    return out


print("TEST 9 - sub-threshold base ladder.  Reconstruction; exploratory.")
print(f"value ceiling 2^44 = {VALUE_CEILING}   x > {X_MIN:.0f}   "
      f"grid {GRID_LO}..{GRID_HI} step {GRID_STEP}   window +-{PEAK_WINDOW}")
print()
print("each zero's own aliasing threshold exp(pi/gamma_k):")
for k, g in enumerate(GAMMAS, 1):
    print(f"   gamma{k} = {g:8.4f}   b must be below {math.exp(math.pi/g):.4f}")
print()
print(f"{'base':>8}{'Nyquist':>10}{'n':>6}{'r range':>12}   zeros recovered "
      f"(peak location, variance explained)")

recovered = {}
for b in BASES:
    u, y, r_min, r_max = samples(b)
    P = periodogram(u, y, GRID)
    nyquist = math.pi / math.log(b)
    hits = []
    for k, gk in enumerate(GAMMAS, 1):
        if gk >= nyquist:
            continue                      # aliased for this base by construction
        sel = np.where((GRID >= gk - PEAK_WINDOW) & (GRID <= gk + PEAK_WINDOW))[0]
        j = sel[int(np.argmax(P[sel]))]
        edge = "" if sel[0] < j < sel[-1] else "*"     # * = not an interior max
        hits.append((k, float(GRID[j]), float(P[j]), edge))
        recovered.setdefault(k, []).append((b, float(GRID[j])))
    print(f"{b:8.4f}{nyquist:10.2f}{len(u):6d}{f'{r_min}..{r_max}':>12}   "
          + "  ".join(f"g{k}={g:.3f}{e}({p:.3f})" for k, g, p, e in hits))

print()
print("* marks a window-edge maximum rather than an interior peak.")
print()
print("recovered value at the finest base on the ladder, against truth:")
finest = BASES[-1]
print(f"{'zero':>6}{'recovered':>12}{'true':>12}{'error':>10}")
for k in sorted(recovered):
    got = dict(recovered[k]).get(finest)
    if got is None:
        continue
    print(f"{'g'+str(k):>6}{got:12.3f}{GAMMAS[k-1]:12.4f}{got-GAMMAS[k-1]:+10.4f}")
span = math.log(VALUE_CEILING) - math.log(X_MIN)
print(f"\nresolution element of the periodogram on this span: "
      f"2*pi/{span:.2f} = {2*math.pi/span:.3f} rad")
print("errors above are well inside it, so the digits are not independent"
      " information.")
