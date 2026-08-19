"""
TEST 18 - does a larger visible fraction buy a smaller bias?  It does not.

t17_joint_decomposition.py measured the split at base 1.1175: the three
zeros beneath that base's Nyquist explain 0.1291 of the variance, and
0.8671 is content above the ceiling folded down by aliasing.  A
prediction follows immediately, and it was MINE, not Julian's - if the
bias in the recovered gamma is the aliased majority pushing the peak
around, then a finer base, which sees more zeros and carries a larger
visible fraction, should show a SMALLER bias.  Straight monotone
relationship, testable in one sweep.

So sweep it.  Ten bases from 1.2000 down to 1.0200, ceiling 2^44, sixty
zeros considered.  Same construction as t9, t16 and t17 throughout:
sample (pi(x) - li(x)) / (sqrt(x)/ln x) at x = b^r for x > 100, work in
u = ln x where a zero's phase is gamma*u with no ln b in it, subtract
the mean.  Per base: the Nyquist ceiling pi/ln b, how many of the sixty
zeros fall beneath it, the sample count, the variance those visible
zeros jointly explain when held at their TRUE frequencies (the visible
fraction), the solo estimate of gamma_1 on a fine grid, and its error.
Then the correlation between visible fraction and |error|, and a
leave-one-out jackknife on that correlation.

THE PREDICTION FAILS, AND THE JACKKNIFE IS WHY.  Across the ten bases
the correlation between visible fraction and |error| is r = -0.642,
t = -2.37 - the right sign, and at a glance it looks like the
prediction landing.  It is one point.  Dropping the single coarsest
base, 1.2000, takes the correlation to r = -0.259 and t = -0.71; every
other single drop leaves it between -0.62 and -0.76.  Base 1.2000 sees
exactly one zero and carries the largest error by a factor of three, so
it sits alone in the corner of the scatter and drags the line through
itself.  The other nine errors span a factor of 7.7 with no relation to
visible fraction at all.  A correlation that one observation of ten
carries is not a finding, and this one is retracted rather than
reported.

WHAT SURVIVES IS THE THING I DID NOT PREDICT.  The visible fraction
SATURATES near 0.25.  Going from one visible zero to two gains 0.0363 of
it; going from forty-one to fifty-seven gains 0.0168.  At base 1.0200 -
Nyquist 158.65, fifty-seven zeros beneath it, 1308 samples - the visible
fraction is still only 0.2498, so three quarters of the signal is
irreducibly aliased content.  The reason is that each zero contributes
roughly 1/gamma^2 to the variance, so the series over zeros converges:
the reachable fraction has a limit and refining the base cannot buy past
it.  Section 8's lever - go to a smaller base - is real but bounded, and
this is where it stops.

A THIRD WRONG SIGN.  Base 1.0500's error is -0.0069.  With t16's
gamma_2 at -0.0051 that is the third negative error recorded, and
"the bias is systematically positive" is closed out for good.

WHAT THIS DOES NOT CLAIM.  No null, no prereg, no decision rule.  The
t-statistics printed here are descriptive summaries of a ten-point
scatter, not test statistics against a preregistered rule, and the
jackknife is a fragility check rather than an inference procedure.  The
per-base estimates are not independent of one another either - every
base samples the same pi(x).  Nothing here is evidence that any zero is
or is not present in the data.

WRITTEN AFTER THE FACT.  Like t16 and t17 this analysis was run inline
during the 2026-08-19 session; the script was written afterwards and
re-run.  Every load-bearing figure reproduces - the ten Nyquists, the
visible counts, the sample counts, all ten visible fractions, r = -0.642
at t = -2.37, the jackknife's collapse to -0.71 on dropping 1.2000, the
0.0363/0.0168 gains and the 0.250 ceiling.  Three fourth-decimal
disagreements are left standing and were NOT tuned away: base 1.0250's
error comes out +0.0042 against a reported +0.0043 and base 1.0200's
+0.0118 against +0.0117, which is where a printed estimate rounded to
four places falls relative to gamma_1 = 14.1347251; and the jackknife's
first row is r = -0.258 against a reported -0.259.  All three are one
part in ten thousand, two orders under the resolution element.  See
CHAIN.md section 12 and the README's script list.
"""
import math

import numpy as np
import mpmath as mp
from primecountpy import prime_pi

mp.mp.dps = 30

# --- locked constants ---------------------------------------------------
BASES = [1.2000, 1.1500, 1.1100, 1.0850, 1.0750,
         1.0500, 1.0400, 1.0317, 1.0250, 1.0200]
X_MIN = 100.0                    # rungs with b^r <= X_MIN dropped
VALUE_CEILING = 2 ** 44          # top of the sampled range, every base
N_ZEROS = 60                     # zeta zeros considered
PEAK_WINDOW = 0.5                # +-rad searched around gamma_1
FINE_STEP = 1e-5                 # trial-gamma spacing inside that window
CHUNK = 4000                     # grid points per vectorised block

GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, N_ZEROS + 1)]


def samples(base):
    """(u, y) at x = base^r for X_MIN < base^r <= VALUE_CEILING."""
    lnb = math.log(base)
    r_min = int(math.floor(math.log(X_MIN) / lnb)) + 1
    r_max = int(math.floor(math.log(float(VALUE_CEILING)) / lnb))
    u, y = [], []
    for r in range(r_min, r_max + 1):
        x = base ** r
        resid = prime_pi(int(x)) - float(mp.li(x))
        lnx = math.log(x)
        u.append(lnx)
        y.append(resid / (math.sqrt(x) / lnx))
    return np.array(u), np.array(y)


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
    return float(grid[j])


def joint_r2(u, y, freqs):
    """Variance explained by a linear least squares fit at fixed
    frequencies - one cos/sin column pair per frequency."""
    if not freqs:
        return 0.0
    cols = []
    for f in freqs:
        cols += [np.cos(f * u), np.sin(f * u)]
    A = np.column_stack(cols)
    coef, *_ = np.linalg.lstsq(A, y, rcond=None)
    r = y - A @ coef
    return 1.0 - float((r ** 2).sum()) / float((y ** 2).sum())


def pearson(a, b):
    """r and its t-statistic on n-2 degrees of freedom."""
    a = np.asarray(a, float); b = np.asarray(b, float)
    n = len(a)
    r = float(np.corrcoef(a, b)[0, 1])
    t = r * math.sqrt(n - 2) / math.sqrt(1 - r * r)
    return r, t, n


print("TEST 18 - visible fraction against bias.  Written after the fact; "
      "exploratory.")
print(f"ceiling 2^44   x > {X_MIN:.0f}   {N_ZEROS} zeros considered   "
      f"peak window +-{PEAK_WINDOW}   grid {FINE_STEP}")
print(f"{len(BASES)} bases, coarse to fine: "
      + ", ".join(f"{b:.4f}" for b in BASES))
print()
print("PART 1 - per base: what it can see, and how far off gamma_1 comes out")
print(f"{'base':>8}{'Nyq':>8}{'vis':>6}{'n':>6}{'vis frac':>11}"
      f"{'g1 est':>10}{'err':>9}")

rows = []
for base in BASES:
    u, y0 = samples(base)
    y = y0 - y0.mean()
    lnb = math.log(base)
    nyq = math.pi / lnb
    visible = [g for g in GAMMAS if g < nyq]
    frac = joint_r2(u, y, visible)
    g1 = peak_near(u, y, GAMMAS[0])
    err = g1 - GAMMAS[0]
    rows.append(dict(base=base, nyq=nyq, vis=len(visible), n=len(u),
                     frac=frac, g1=g1, err=err))
    print(f"{base:>8.4f}{nyq:>8.2f}{len(visible):>6}{len(u):>6}"
          f"{frac:>11.4f}{g1:>10.4f}{err:>+9.4f}")
print()
if any(r["vis"] == len(GAMMAS) for r in rows):
    print("WARNING: some base's Nyquist exceeds gamma_%d - the visible set is"
          % N_ZEROS)
    print("truncated by N_ZEROS rather than by the base.  Raise N_ZEROS.")
    print()

# --- part 2: the prediction ---------------------------------------------
print("PART 2 - the prediction: finer base -> larger visible fraction -> "
      "smaller |error|")
fr = [r["frac"] for r in rows]
ae = [abs(r["err"]) for r in rows]
r_all, t_all, n_all = pearson(fr, ae)
print(f"corr(visible fraction, |error|) = {r_all:+.3f}   "
      f"t = {t_all:+.2f}   n = {n_all}")
print("The sign is the predicted one and the magnitude looks like the "
      "prediction landing.")
print()

# --- part 3: the jackknife, which is what kills it ----------------------
print("PART 3 - leave-one-out jackknife on that correlation")
print(f"{'dropped':>9}{'r':>9}{'t':>9}")
jack = []
for i in range(len(rows)):
    keep = [j for j in range(len(rows)) if j != i]
    ri, ti, _ = pearson([fr[j] for j in keep], [ae[j] for j in keep])
    jack.append((rows[i]["base"], ri, ti))
    print(f"{rows[i]['base']:>9.4f}{ri:>+9.3f}{ti:>+9.2f}")
print()
worst = max(jack, key=lambda z: z[1])          # least negative r
others = [z for z in jack if z is not worst]
lo = min(z[1] for z in others); hi = max(z[1] for z in others)
print(f"dropping base {worst[0]:.4f} gives r = {worst[1]:+.3f}, "
      f"t = {worst[2]:+.2f};")
print(f"every other drop leaves r between {lo:+.3f} and {hi:+.3f}")
print()
rest = [r for r in rows if r["base"] != worst[0]]
sp = max(abs(r["err"]) for r in rest) / min(abs(r["err"]) for r in rest)
print(f"the correlation is carried by one point of {n_all}.  Without it the "
      f"remaining {len(rest)} errors")
print(f"span a factor of {sp:.1f} with no relation to visible fraction.  "
      "THE PREDICTION FAILS.")
print()

# --- part 4: what does survive - the saturation -------------------------
print("PART 4 - the visible fraction saturates")
print(f"{'step':>19}{'zeros':>12}{'frac':>9}{'gained':>9}")
for a, b in zip(rows, rows[1:]):
    print(f"{a['base']:.4f} -> {b['base']:.4f}"
          f"{str(a['vis']) + ' -> ' + str(b['vis']):>12}"
          f"{b['frac']:>9.4f}{b['frac'] - a['frac']:>+9.4f}")
print()
first = rows[1]["frac"] - rows[0]["frac"]
last = rows[-1]["frac"] - rows[-2]["frac"]
print(f"1 -> 2 zeros gains {first:.4f}.  "
      f"{rows[-2]['vis']} -> {rows[-1]['vis']} zeros gains only {last:.4f}.")
print(f"The fraction tops out at {rows[-1]['frac']:.3f} - at Nyquist "
      f"{rows[-1]['nyq']:.2f}, {rows[-1]['vis']} zeros and "
      f"{rows[-1]['n']} samples,")
print(f"{100*(1 - rows[-1]['frac']):.0f}% of the signal is still aliased "
      "content folded down.")
print()
print("Each zero contributes roughly 1/gamma^2 to the variance, so the series")
print("over zeros converges and the reachable fraction has a limit.  Refining")
print("the base cannot buy past it.  Section 8's lever is real but bounded.")
print()
neg = [r for r in rows if r["err"] < 0]
print("SIGN OF THE ERROR.  "
      + (", ".join(f"base {r['base']:.4f} at {r['err']:+.4f}" for r in neg)
         if neg else "every error positive"))
print("With t16's gamma_2 at -0.0051 that is a third negative error.  The bias")
print("is not systematically positive.")
