"""
TEST 7 - lattice phase, per dyadic cell.

Coverage failed because it counts, and a count in a fixed-width log
window is fixed by the width. What varies is WHERE the window sits
against the coarser lattice:

    phi_b(r,d) = frac( (r-d-1) * ln2 / ln b )

the offset of the window's lower edge from the nearest b-rung, as a
fraction of the b-spacing. That is exactly the quantity deciding whether
the count lands high or low, and unlike the count it takes a different
value in every cell.

It depends on r and d only through r-d, so it is constant along
diagonals. That is not a defect - r-d is the scale coordinate, the
exponent of b in the pair identity, and the reason base 2 is the only
base where it alone sets the scale.

Nothing here is tested against a null. It is a picture of where each
cell sits relative to each coarser sampling, with the four zeros marked
so their alignment can be read off rather than argued about.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

R = 32
ZER = [(2, 1), (4, 1), (8, 3), (20, 6)]
BASES = [3, 4, 5, 6, 7, 8, 9]
LN2 = math.log(2)


def phase(r, d, b):
    return ((r - d - 1) * LN2 / math.log(b)) % 1.0


GR, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, axes = plt.subplots(2, 4, figsize=(16.5, 7.6), facecolor=GR)
fig.subplots_adjust(left=.05, right=.97, top=.89, bottom=.09, hspace=.34, wspace=.24)

print("Lattice phase at each zero.  0 means the window edge sits exactly")
print("on a b-rung; 0.5 means squarely between two.\n")
print(f"{'base':>5}{'ln2/lnb':>10}   " + "".join(f"{'(%d,%d)'%z:>10}" for z in ZER)
      + f"{'spread':>9}")

for ax, b in zip(axes.ravel(), BASES):
    M = np.full((R, R), np.nan)
    for d in range(R):
        for r in range(d + 1, R + 1):
            M[d, r - 1] = phase(r, d, b)

    ph = [phase(r, d, b) for r, d in ZER]
    # circular spread of the four phases: 1 - |mean resultant vector|
    ang = [2 * math.pi * p for p in ph]
    Rv = math.hypot(sum(math.cos(a) for a in ang), sum(math.sin(a) for a in ang)) / 4
    print(f"{b:>5}{LN2/math.log(b):>10.5f}   "
          + "".join(f"{p:>10.4f}" for p in ph) + f"{1-Rv:>9.3f}")

    ax.set_facecolor(GR)
    im = ax.pcolormesh(np.arange(1, R + 1), np.arange(R), M,
                       cmap="twilight", shading="nearest", vmin=0, vmax=1)
    for r, d in ZER:
        ax.plot(r, d, marker="o", ms=10, mfc="none", mec="#FBF7EE", mew=1.9)
    ax.set_title(f"base {b}   ln2/ln b = {LN2/math.log(b):.4f}",
                 color=INK, fontsize=10, fontfamily="monospace", pad=5)
    ax.set_xlabel("r", color=MUT, fontsize=8)
    ax.set_ylabel("d", color=MUT, fontsize=8)
    ax.tick_params(colors=MUT, labelsize=7)
    for s in ax.spines.values():
        s.set_color("#232A38")
    cb = fig.colorbar(im, ax=ax, fraction=.046)
    cb.ax.tick_params(colors=MUT, labelsize=7)
    cb.outline.set_edgecolor("#232A38")

axes.ravel()[-1].axis("off")
fig.suptitle("Where each dyadic cell sits against the coarser lattice",
             color=INK, fontsize=13, fontfamily="monospace", y=.965)
fig.text(.5, .022, "colour is cyclic — 0 and 1 are the same place. "
         "circles are the four exact zeros. bands run along r−d.",
         color=MUT, fontsize=9, ha="center", fontfamily="monospace")

p = ("/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/"
     "4d0caf67-f72a-4554-a9cc-a363251155d9/scratchpad/phase.png")
fig.savefig(p, dpi=140, facecolor=GR)
print("\nspread: 0 = the four zeros share a phase, 1 = maximally scattered")
print("(circular, so it does not care where on the cycle they sit)")
print("\nwrote", p)
