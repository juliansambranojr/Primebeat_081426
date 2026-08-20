"""
TEST 6 - all bases bound to one number line.

Every earlier transform was indexed by r, a base's own rung number. There
a zero's frequency is gamma*ln(b) - 9.8 for base 2 - which folds mod 2pi,
and that folding is why nothing could be resolved.

Put each sample at its true position instead:

    u = ln x = r * ln b

and the residual pi(x) - li(x) is ONE function, sampled by every base at
its own spacing ln b. A zero contributes x^rho / (rho ln x), whose phase
in u is simply gamma*u. No ln b anywhere. Every base carries the same
frequency for the same zero; only the sample spacing differs.

Each base alone is Nyquist-limited to gamma < pi/ln b - 4.53 for base 2,
2.86 for base 3 - so no single base can see gamma1 = 14.13. But the
aliases of different bases land in different places, so a fit over the
COMBINED non-uniform sample set is not limited by any one of them. That
is the whole point of the construction, and it is why the bases being
incommensurate helps instead of hurting.

Method: least-squares periodogram (Lomb-Scargle by hand). At each trial
gamma, fit a*cos(gamma u) + b*sin(gamma u) to the residual and report the
variance it explains. No aliasing is assumed and none is corrected for.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import mpmath as mp
from primecountpy import prime_pi
from _paths import FIGURES, tee

tee(__file__)

mp.mp.dps = 30
V = 2 ** 48
BASES = [2, 3, 4, 5, 6, 7, 8, 9]
GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, 9)]


def samples(bases):
    """(u, y) : residual of pi at x = b^r, in the coordinate u = ln x.

    x^(1/2)/ln x is the natural size of a single zero's term, so dividing
    by it puts every sample on the same footing regardless of how far out
    it sits. Without that the far samples swamp everything."""
    U, Y, B = [], [], []
    for b in bases:
        rmax = int(math.floor(math.log(V) / math.log(b)))
        for r in range(2, rmax + 1):
            x = float(b) ** r
            resid = prime_pi(int(x)) - float(mp.li(x))
            u = math.log(x)
            U.append(u)
            Y.append(resid / (math.sqrt(x) / u))
            B.append(b)
    return np.array(U), np.array(Y), np.array(B)


def periodogram(u, y, gammas):
    y = y - y.mean()
    var = (y ** 2).sum()
    out = np.empty(len(gammas))
    for i, g in enumerate(gammas):
        c, s = np.cos(g * u), np.sin(g * u)
        A = np.column_stack([c, s])
        coef, *_ = np.linalg.lstsq(A, y, rcond=None)
        out[i] = 1 - ((y - A @ coef) ** 2).sum() / var
    return out


grid = np.linspace(1.0, 50.0, 6000)

print("Nyquist ceiling for each base on its own, pi / ln b:")
for b in BASES:
    print(f"   base {b}: gamma < {math.pi/math.log(b):6.2f}")
print(f"   gamma1 = {GAMMAS[0]:.4f} - above every one of them\n")

for label, bs in (("base 2 alone", [2]),
                  ("base 3 alone", [3]),
                  ("2 and 3", [2, 3]),
                  ("all eight", BASES)):
    u, y, _ = samples(bs)
    P = periodogram(u, y, grid)
    top = np.argsort(P)[::-1]
    peaks, seen = [], []
    for t in top:
        g = grid[t]
        if any(abs(g - s) < 0.8 for s in seen):
            continue
        seen.append(g); peaks.append((g, P[t]))
        if len(peaks) == 5:
            break
    hits = []
    for g, p in peaks:
        near = min(GAMMAS, key=lambda G: abs(G - g))
        hits.append(f"{g:.3f}({p:.3f})" + (f"~γ{GAMMAS.index(near)+1}"
                    if abs(near - g) < 0.5 else ""))
    print(f"{label:14} n={len(u):4d}   top peaks: " + "  ".join(hits))

# --- figure -------------------------------------------------------------
GR, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, axes = plt.subplots(4, 1, figsize=(11, 10), facecolor=GR, sharex=True)
fig.subplots_adjust(left=0.09, right=0.97, top=0.93, bottom=0.07, hspace=0.28)

for ax, (label, bs, col) in zip(axes, (
        ("base 2 alone", [2], "#3D6FE0"),
        ("base 3 alone", [3], "#3EAF63"),
        ("bases 2 and 3", [2, 3], "#7FC8F2"),
        ("all eight bases", BASES, "#E8C15A"))):
    u, y, _ = samples(bs)
    P = periodogram(u, y, grid)
    ax.set_facecolor(GR)
    ax.plot(grid, P, color=col, lw=1.3)
    for k, g in enumerate(GAMMAS, 1):
        ax.axvline(g, color=MUT, lw=0.8, ls=(0, (3, 4)))
        if ax is axes[0]:
            ax.text(g, 1.02, f"γ{k}", color=MUT, fontsize=7.5, ha="center",
                    transform=ax.get_xaxis_transform(), fontfamily="monospace")
    for b in bs:
        ny = math.pi / math.log(b)
        ax.axvline(ny, color="#D0685F", lw=1, alpha=0.7)
    ax.set_ylabel("variance explained", color=MUT, fontsize=8.5)
    ax.set_title(f"{label}   ({len(u)} samples)", color=INK, fontsize=10,
                 fontfamily="monospace", pad=5, loc="left")
    ax.tick_params(colors=MUT, labelsize=8)
    for s in ax.spines.values():
        s.set_color("#232A38")

axes[-1].set_xlabel("γ   (trial frequency in u = ln x)", color=MUT)
fig.suptitle("One number line, eight samplings — least-squares periodogram",
             color=INK, fontsize=13, fontfamily="monospace", y=0.972)
fig.text(0.5, 0.012, "dashed grey = the first eight zeta zeros · "
         "red = that base's own Nyquist ceiling π/ln b",
         color=MUT, fontsize=8.4, ha="center", fontfamily="monospace")

p = str(FIGURES / "multirate.png")
fig.savefig(p, dpi=150, facecolor=GR)
print("\nwrote", p)
