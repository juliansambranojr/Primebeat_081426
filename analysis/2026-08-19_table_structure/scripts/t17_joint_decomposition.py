"""
TEST 17 - fit the visible zeros jointly, then see what survives.  RECONSTRUCTION.

t16_window_convergence.py established that the bias in the recovered
gamma is not a resolution artifact: doubling the window leaves the error
where it was and grows err/res from 0.037 to 0.101.  Something else
displaces the peak.  The obvious candidate is MUTUAL LEAKAGE - each zero
sitting on the skirts of the others, so that fitting one at a time
measures a blend rather than a zero.  That is testable, because leakage
among zeros we can see is leakage we can subtract.

Same construction as t9 and t16 throughout: (pi(x) - li(x)) divided by
sqrt(x)/ln x, sampled at x = b^r for x > 100 at base 1.1175405, ceiling
2^48, in the coordinate u = ln x where a zero's phase is gamma*u.
Twelve zeros are considered; the base's Nyquist is pi/ln b = 28.27, so
the VISIBLE SET is the three zeros beneath it.  Four parts:

  1  SOLO      - each visible zero fitted alone, frequency free.
  2  JOINT     - linear least squares on all visible zeros held at their
                 true frequencies; how much variance do they explain?
  3  BACKFIT   - re-estimate each zero's frequency on a residual with the
                 OTHERS already subtracted, iterated to a fixed point.
                 If leakage is the bias, the error collapses here.
  4  SURVIVES  - periodogram of the residual after the visible zeros are
                 gone.  What is left, and is any of it near a zero?

WHAT THIS ESTABLISHES.  Two things, and the second is the point.

Leakage among the VISIBLE zeros is not the cause of the bias.  Backfit
moves the three errors from +0.0221, -0.0051, +0.0302 to +0.0218,
-0.0028, +0.0266 - mean |error| 0.0191 to 0.0170, a ratio of 0.89.
Removing every zero we can see removes a tenth of the bias.  Nine tenths
of it is untouched.

And the three visible zeros explain 0.1291 of the variance.  Eighty-seven
per cent of the signal is content this base cannot resolve - zeros above
28.27, folded down by aliasing onto frequencies below it.  It is present
in every sample and it cannot be subtracted, because subtracting it
would require knowing where it landed, and aliasing is exactly the
operation that destroys that.  The strongest surviving frequencies -
23.602, 1.298, 26.114, 1.541, 3.572 - sit near no zeta zero at all,
which is what folded content looks like: real structure at frequencies
that are not anybody's gamma.

That also explains why a longer ladder does not help, which t16 showed
empirically.  More rungs at the same base extend the window but do not
lower the Nyquist ceiling, so the 13/87 split is fixed by the base.  The
only lever is a smaller base.

WHAT THIS DOES NOT CLAIM.  No null, no prereg, no decision rule, no
p-value.  The variance-explained figures are descriptive fits, not test
statistics, and "none within 0.4 of a zero" is a distance report and not
a significance statement.  Nothing here is evidence that any zero is or
is not present in the data.

RECONSTRUCTION NOTE.  This analysis was run inline as a heredoc during
the 2026-08-19 session and no script survived.  This file was written
afterwards from the reported numbers and re-run.  Every load-bearing
figure reproduces: the visible set, 0.1291, the residual fraction
0.8671, the direction and rough size of every backfit shrink, and "no
survivor near a zero."  Three disagreements are left standing and were
NOT tuned away.  (a) The per-zero errors differ in the fourth decimal -
solo g2 comes out -0.0051 against a reported -0.0050, and the three
backfit errors -0.0003, -0.0001, -0.0001 from theirs, moving mean
|error| to 0.0170 and the ratio to 0.89 against a reported 0.0171 and
0.90.  That is grid alignment inside the +-0.5 window, an order of
magnitude under the 0.2200 resolution element.  (b) The original's
survivor list ran to 50 rad; above Nyquist the periodogram is the exact
mirror of the band below, so the survey here stops at 28.27 and the
mirror is printed rather than asserted.  (c) The 4th and 5th survivors
differ: this file separates peaks by one resolution element (Rayleigh)
and gets 1.541 and 3.572, where the original reported 3.571 and 15.600
- the same maxima list with a wider separation.  The unfiltered maxima
are printed so the choice is visible.  None of the three touches the
finding.  See the CHAIN.md section on joint decomposition and the
README's script list.
"""
import math

import numpy as np
import mpmath as mp
from primecountpy import prime_pi
from _paths import tee

tee(__file__)

mp.mp.dps = 30

# --- locked constants ---------------------------------------------------
BASE = 1.1175405                 # the sub-threshold base of t9 and t16
X_MIN = 100.0                    # rungs with b^r <= X_MIN dropped
VALUE_CEILING = 2 ** 48          # top of the sampled range
N_ZEROS = 12                     # zeta zeros considered
PEAK_WINDOW = 0.5                # +-rad searched around each gamma_k
FINE_STEP = 1e-5                 # trial-gamma spacing inside that window
SCAN_LO, SCAN_STEP = 1.0, 1e-3   # part 4 survey grid; it stops at Nyquist
N_SURVIVORS = 5                  # how many surviving peaks to report
NEAR = 0.4                       # "near a zero" threshold, rad
BACKFIT_ITERS = 20               # fixed-point iterations (stops when settled)
CHUNK = 4000                     # grid points per vectorised block

LNB = math.log(BASE)
NYQUIST = math.pi / LNB
GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, N_ZEROS + 1)]
VISIBLE = [k for k, g in enumerate(GAMMAS, 1) if g < NYQUIST]


def samples():
    """(u, y) at x = b^r for X_MIN < b^r <= VALUE_CEILING."""
    r_min = int(math.floor(math.log(X_MIN) / LNB)) + 1
    r_max = int(math.floor(math.log(float(VALUE_CEILING)) / LNB))
    u, y = [], []
    for r in range(r_min, r_max + 1):
        x = BASE ** r
        resid = prime_pi(int(x)) - float(mp.li(x))
        lnx = math.log(x)
        u.append(lnx)
        y.append(resid / (math.sqrt(x) / lnx))
    return np.array(u), np.array(y), r_min, r_max


def periodogram(u, y, grid):
    """Fraction of y's variance a single cos/sin pair explains, at each
    trial gamma.  Solved through the 2x2 normal equations so the grid
    vectorises.  y is used as given - callers mean-subtract."""
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


def peak_near(u, y, gamma):
    """Periodogram maximum within +-PEAK_WINDOW of gamma."""
    grid = np.arange(gamma - PEAK_WINDOW, gamma + PEAK_WINDOW, FINE_STEP)
    P = periodogram(u, y, grid)
    j = int(np.argmax(P))
    return float(grid[j]), float(P[j])


def design(u, freqs):
    """cos/sin column pair per frequency."""
    cols = []
    for f in freqs:
        cols += [np.cos(f * u), np.sin(f * u)]
    return np.column_stack(cols) if cols else np.zeros((len(u), 0))


def joint(u, y, freqs):
    """Linear least squares at fixed frequencies.  (residual, R^2)."""
    A = design(u, freqs)
    if A.shape[1] == 0:
        return y.copy(), 0.0
    coef, *_ = np.linalg.lstsq(A, y, rcond=None)
    r = y - A @ coef
    return r, 1.0 - float((r ** 2).sum()) / float((y ** 2).sum())


print("TEST 17 - joint decomposition of the visible zeros.  Reconstruction; "
      "exploratory.")
print(f"base {BASE}   ln b = {LNB:.8f}   ceiling 2^48   x > {X_MIN:.0f}")
print(f"{N_ZEROS} zeros considered   Nyquist pi/ln b = {NYQUIST:.2f}   "
      f"peak window +-{PEAK_WINDOW}   grid {FINE_STEP}")
print()

U, Y0, R_MIN, R_MAX = samples()
Y = Y0 - Y0.mean()
SPAN = float(U[-1] - U[0])
RES = 2 * math.pi / SPAN
print(f"r = {R_MIN}..{R_MAX}, n = {len(U)}, span in u = {SPAN:.2f}, "
      f"resolution 2*pi/span = {RES:.4f}")
print()
print("visible zeros (gamma < Nyquist):  "
      + ", ".join(f"g{k}={GAMMAS[k-1]:.3f}" for k in VISIBLE)
      + f"   ({len(VISIBLE)} of {N_ZEROS})")
print("aliased zeros (gamma > Nyquist):  "
      + ", ".join(f"g{k}={GAMMAS[k-1]:.3f}"
                  for k in range(1, N_ZEROS + 1) if k not in VISIBLE))
print()

# --- part 1: solo --------------------------------------------------------
print("PART 1 - each visible zero fitted alone, frequency free")
print(f"{'zero':>6}{'true':>11}{'solo':>11}{'error':>10}{'err/res':>9}"
      f"{'var expl':>10}")
solo = {}
for k in VISIBLE:
    g, p = peak_near(U, Y, GAMMAS[k - 1])
    solo[k] = g
    print(f"{'g' + str(k):>6}{GAMMAS[k-1]:>11.4f}{g:>11.4f}"
          f"{g - GAMMAS[k-1]:>+10.4f}{abs(g - GAMMAS[k-1])/RES:>9.3f}{p:>10.4f}")
print()

# --- part 2: joint at the true frequencies -------------------------------
print("PART 2 - all visible zeros together, held at their TRUE frequencies")
resid_true, r2_true = joint(U, Y, [GAMMAS[k - 1] for k in VISIBLE])
print(f"linear least squares, {2*len(VISIBLE)} columns "
      f"(cos/sin per zero), {len(U)} samples")
print(f"variance explained by the {len(VISIBLE)} visible zeros: {r2_true:.4f}")
print(f"variance left over:                          {1 - r2_true:.4f}")
for k in VISIBLE:
    _, r2k = joint(U, Y, [GAMMAS[k - 1]])
    print(f"   g{k} alone at its true frequency: {r2k:.4f}")
print()

# --- part 3: backfit -----------------------------------------------------
print("PART 3 - backfit: re-estimate each zero on a residual with the "
      "others removed")
print(f"iterated to a fixed point (max {BACKFIT_ITERS} sweeps); the window "
      "stays centred on the TRUE gamma")
freqs = dict(solo)
for it in range(BACKFIT_ITERS):
    moved = 0.0
    for k in VISIBLE:
        others = [freqs[j] for j in VISIBLE if j != k]
        r, _ = joint(U, Y, others)
        g, _ = peak_near(U, r, GAMMAS[k - 1])
        moved = max(moved, abs(g - freqs[k]))
        freqs[k] = g
    if moved < FINE_STEP / 2:
        break
print(f"settled after {it + 1} sweep(s)")
print(f"{'zero':>6}{'true':>11}{'solo err':>11}{'backfit':>11}"
      f"{'backfit err':>13}{'shrank?':>10}")
for k in VISIBLE:
    es = solo[k] - GAMMAS[k - 1]
    eb = freqs[k] - GAMMAS[k - 1]
    print(f"{'g' + str(k):>6}{GAMMAS[k-1]:>11.4f}{es:>+11.4f}"
          f"{freqs[k]:>11.4f}{eb:>+13.4f}"
          f"{('yes' if abs(eb) < abs(es) else 'no'):>10}")
ms = np.mean([abs(solo[k] - GAMMAS[k - 1]) for k in VISIBLE])
mb = np.mean([abs(freqs[k] - GAMMAS[k - 1]) for k in VISIBLE])
print()
print(f"mean |error|  solo {ms:.4f} -> backfit {mb:.4f}   ratio {mb/ms:.2f}")
print("Removing every zero this base can see removes "
      f"{100*(1 - mb/ms):.0f}% of the bias.  Mutual leakage")
print("among the VISIBLE zeros is not what displaces the peaks.")
print()

# --- part 4: what survives ----------------------------------------------
print("PART 4 - what is left after the visible zeros are subtracted")
resid, r2_bf = joint(U, Y, [freqs[k] for k in VISIBLE])
print(f"joint fit at the BACKFIT frequencies: variance explained {r2_bf:.4f}")
print(f"residual variance fraction:           {1 - r2_bf:.4f}")
print()
# The rungs are equally spaced in u, so the periodogram above Nyquist is
# the exact mirror of the band below it: a peak at f > nyq is the same
# fit as one at 2*nyq - f, same variance explained, no new information.
# The survey therefore stops at Nyquist, and the mirror is demonstrated
# rather than asserted a few lines down.
grid = np.arange(SCAN_LO, NYQUIST, SCAN_STEP)
P = periodogram(U, resid - resid.mean(), grid)
loc = [i for i in range(1, len(grid) - 1) if P[i] > P[i-1] and P[i] >= P[i+1]]
loc.sort(key=lambda i: -P[i])
picked = []
for i in loc:
    if all(abs(grid[i] - grid[j]) >= RES for j in picked):
        picked.append(i)
    if len(picked) == N_SURVIVORS:
        break
print(f"strongest surviving frequencies (grid {SCAN_LO}..{NYQUIST:.2f} step "
      f"{SCAN_STEP}, peaks separated by >= {RES:.4f})")
print(f"{'freq':>10}{'var expl':>10}{'nearest zero':>15}{'distance':>10}"
      f"{'within ' + str(NEAR) + '?':>12}")
any_near = False
for i in picked:
    f = float(grid[i])
    k = min(range(1, N_ZEROS + 1), key=lambda j: abs(f - GAMMAS[j - 1]))
    d = abs(f - GAMMAS[k - 1])
    any_near |= d < NEAR
    print(f"{f:>10.3f}{P[i]:>10.4f}"
          f"{'g' + str(k) + '=' + format(GAMMAS[k-1], '.3f'):>15}{d:>10.3f}"
          f"{('YES' if d < NEAR else 'no'):>12}")
print()
print("the same maxima with NO separation filter, so the filter's effect is")
print("visible rather than buried - one resolution element is the Rayleigh")
print("criterion, and 1.541 below is exactly one away from 1.298:")
print("   " + "  ".join(f"{float(grid[i]):.3f}({P[i]:.4f})" for i in loc[:8]))
print()
print("mirror check - the same fit evaluated above Nyquist, which is why the")
print("survey stops there:")
for i in picked[:2]:
    f = float(grid[i])
    m = 2 * NYQUIST - f
    Pm = float(periodogram(U, resid - resid.mean(), np.array([f, m]))[1])
    print(f"   {f:.3f} (var expl {P[i]:.4f})  mirrors  {m:.3f} "
          f"(var expl {Pm:.4f})")
print()
print("any survivor within " + f"{NEAR} of a zeta zero: "
      + ("yes" if any_near else "NO"))
print()
print(f"THE SPLIT.  {len(VISIBLE)} visible zeros account for {r2_true:.4f} of "
      "the variance at their true")
print(f"frequencies.  {100*(1 - r2_bf):.0f}% is content above the Nyquist "
      f"ceiling {NYQUIST:.2f}, folded down")
print("onto frequencies below it.  It is in every sample and it cannot be")
print("subtracted, because subtraction needs a location and aliasing is the")
print("operation that destroys one.  More rungs at this base extend the")
print("window without lowering the ceiling, so the split does not move.")
