"""
TEST 16 - does the recovered gamma converge as the window grows?  RECONSTRUCTION.

t9_subthreshold_ladder.py recovered gamma_1 = 14.158 at base 1.1175
against a true 14.1347 and dismissed the third-decimal disagreement as
"well inside the resolution element."  That excuse is only good if the
disagreement is resolution.  If it is, doubling the value ceiling -
which lengthens the window in u = ln x and shrinks the resolution
element 2*pi/span - must shrink the error along with it.

So sweep the ceiling.  Same base, same construction as t9: sample
(pi(x) - li(x)) / (sqrt(x)/ln x) at x = b^r for x > 100, work in
u = ln x where a zero's phase is gamma*u with no ln b in it, subtract
the mean, and run a least-squares periodogram on a fine grid around
each target gamma.  The lower rung r_min is fixed by X_MIN, so each
ceiling's sample set is a prefix of the next one's - the window is
extended, never resampled.  Ceilings 2^28 ... 2^48 for gamma_1, and
2^36 ... 2^48 for gamma_3.

THE FINDING IS THAT IT DOES NOT CONVERGE.  The error does not shrink as
the window doubles - it wanders between +0.014 and +0.033 with no trend
- while the resolution element halves.  So err/res, the error measured
in resolution elements, GROWS: 0.037 at 2^28 to 0.101 at 2^48.  A
resolution artifact would do the opposite.  Whatever displaces the peak
is not the shortness of the window, and adding rungs at this base does
not remove it.  t17_joint_decomposition.py asks what it is instead.

WHAT THIS DOES NOT CLAIM.  No null, no prereg, no decision rule, no
p-value.  This is a convergence diagnostic on a single base, not a
detection test and not evidence for or against any zero being present.
The per-ceiling estimates are also not independent of one another -
every sample set contains all the earlier ones.

RECONSTRUCTION NOTE.  This analysis was run inline as a heredoc during
the 2026-08-19 session and no script survived.  This file was written
afterwards from the reported numbers and re-run.  See the CHAIN.md
section on window convergence and the README's script list.
"""
import math

import numpy as np
import mpmath as mp
from primecountpy import prime_pi

mp.mp.dps = 30

# --- locked constants ---------------------------------------------------
BASE = 1.1175405                 # the sub-threshold base of t9, to 7 figures
X_MIN = 100.0                    # rungs with b^r <= X_MIN dropped
CEILINGS = [28, 32, 36, 40, 44, 48]          # value ceiling 2^k
GAMMA_CEILINGS = {1: CEILINGS, 3: [36, 40, 44, 48]}   # which zero, which ceilings
PEAK_WINDOW = 0.5                # +-rad searched around each gamma_k
GRID_STEP = 1e-5                 # trial-gamma spacing inside that window
CHUNK = 4000                     # grid points evaluated per vectorised block

LNB = math.log(BASE)
NYQUIST = math.pi / LNB
GAMMAS = {k: float(mp.zetazero(k).imag) for k in GAMMA_CEILINGS}


def all_samples(top_ceiling):
    """(u, y) at x = b^r for X_MIN < b^r <= 2^top_ceiling.

    u = ln x; y is pi(x) - li(x) divided by sqrt(x)/ln x, the natural
    size of one zero's term, so far samples do not swamp near ones."""
    r_min = int(math.floor(math.log(X_MIN) / LNB)) + 1
    r_max = int(math.floor(math.log(2.0 ** top_ceiling) / LNB))
    u, y = [], []
    for r in range(r_min, r_max + 1):
        x = BASE ** r
        resid = prime_pi(int(x)) - float(mp.li(x))
        lnx = math.log(x)
        u.append(lnx)
        y.append(resid / (math.sqrt(x) / lnx))
    return np.array(u), np.array(y), r_min, r_max


def periodogram(u, y, grid):
    """Least-squares (Lomb-Scargle by hand): fraction of variance a single
    cos/sin pair at each trial gamma explains.  Solved through the 2x2
    normal equations rather than lstsq so the grid can be vectorised."""
    y = y - y.mean()
    var = float((y ** 2).sum())
    out = np.empty(len(grid))
    for i in range(0, len(grid), CHUNK):
        g = grid[i:i + CHUNK][:, None]
        c, s = np.cos(g * u), np.sin(g * u)
        cc = (c * c).sum(1); ss = (s * s).sum(1); cs = (c * s).sum(1)
        cy = c @ y; sy = s @ y
        det = cc * ss - cs * cs
        a = (ss * cy - cs * sy) / det
        bb = (cc * sy - cs * cy) / det
        out[i:i + CHUNK] = (a * cy + bb * sy) / var
    return out


def estimate(u, y, gamma):
    """Location and height of the periodogram maximum in +-PEAK_WINDOW of
    gamma.  Returns (peak location, variance explained, interior flag)."""
    grid = np.arange(gamma - PEAK_WINDOW, gamma + PEAK_WINDOW, GRID_STEP)
    P = periodogram(u, y, grid)
    j = int(np.argmax(P))
    return float(grid[j]), float(P[j]), 0 < j < len(grid) - 1


print("TEST 16 - window convergence of the recovered gamma.  Reconstruction; "
      "exploratory.")
print(f"base {BASE}   ln b = {LNB:.8f}   Nyquist pi/ln b = {NYQUIST:.4f}")
print(f"x > {X_MIN:.0f}   peak window +-{PEAK_WINDOW}   grid step {GRID_STEP}")
print()

TOP = max(CEILINGS)
U, Y, R_MIN, R_MAX = all_samples(TOP)
print(f"sampled r = {R_MIN}..{R_MAX} at ceiling 2^{TOP}: {len(U)} rungs.")
print("every smaller ceiling is a prefix of this set - the window is extended,")
print("never resampled, so the estimates are not independent of one another.")
print()

for k in sorted(GAMMA_CEILINGS):
    gk = GAMMAS[k]
    print(f"gamma_{k} = {gk:.6f}"
          + ("" if gk < NYQUIST else "   [ABOVE NYQUIST - aliased]"))
    print(f"{'ceiling':>9}{'n':>6}{'span u':>10}{'res':>9}"
          f"{'estimate':>11}{'error':>10}{'err/res':>9}")
    for c in GAMMA_CEILINGS[k]:
        r_top = int(math.floor(math.log(2.0 ** c) / LNB))
        m = r_top - R_MIN + 1
        u, y = U[:m], Y[:m]
        span = float(u[-1] - u[0])
        res = 2 * math.pi / span
        g, p, interior = estimate(u, y, gk)
        flag = "" if interior else "  *edge"
        print(f"{'2^' + str(c):>9}{m:>6}{span:>10.2f}{res:>9.4f}"
              f"{g:>11.4f}{g - gk:>+10.4f}{abs(g - gk) / res:>9.3f}{flag}")
    print()

print("* marks a window-edge maximum rather than an interior peak.")
print()
print("READ IT DOWN THE err/res COLUMN.  The span roughly doubles from 2^28")
print("to 2^48 and the resolution element halves, so a resolution artifact")
print("would show err/res flat and the error itself falling.  Neither")
print("happens: the error wanders with no trend and err/res grows.  The")
print("displacement of the peak is not the shortness of the window.")
