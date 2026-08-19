"""
TEST 15 - cell coverage, and why it cannot discriminate.  RECONSTRUCTION.

The attractor model wanted the four exact dyadic zeros to sit where a
coarser base's rungs land unusually sparsely inside the cell's window.
Each dyadic cell (r,d) reads values from 2^(r-d-1) up to 2^r, so for a
coarser base b the number of b-rungs inside that window is

    count(r,d,b) = floor( r*ln2 / ln b ) - floor( (r-d-1)*ln2 / ln b )

Computed over r = 1..32, d = 0..31, cells with d < r, for bases 3..9,
with the four exact zeros (2,1) (4,1) (8,3) (20,6) marked.

THE MEASURE DOES NOT DISCRIMINATE, and that is this file's finding.
The window is 2^(r-d-1) to 2^r, so its width in b-rungs is (d+1)*ln2/ln b
- a function of d ALONE, with no r in it.  A fixed-width log window
always holds the same number of rungs up to a one-rung floor wobble, so
at any fixed depth the count takes AT MOST TWO VALUES across the twenty
to thirty cells at that depth.  Coverage is depth wearing another name.
The z ~ -1.0 reported at every base below is therefore not an alignment:
it is the four zeros being shallow (d = 1, 1, 3, 6 against a mean depth
of about 10 over the triangle), read back out through a statistic that
carries depth and nothing else.  Part 2 prints the distinct-value count
per depth so the claim can be read off rather than argued about.

WHAT THIS DOES NOT CLAIM.  There is no null, no prereg and no decision
rule here.  The z column is (mean at the four zeros - mean over all
cells) / sd over all cells, a descriptive standardisation over a
population of 528 cells, not a test statistic against a null of four
draws.  n = 4 could not support a claim about where zeros sit even if
the measure did discriminate, and it does not.  Nothing here is
evidence for or against the attractor model; the measure is reported so
that its failure is on the record with the arithmetic attached.

RECONSTRUCTION NOTE.  Originally run inline as a heredoc during the
2026-08-19 session; no script survived, and figures/coverage.png was
committed without one.  Written afterwards from the reported numbers
and re-run.  Every per-base mean, zero-mean and z reproduces exactly.
One disagreement, left standing and not tuned: base 6's per-zero counts
come out [0, 1, 2, 2] here against the reported [0, 1, 1, 3].  Both sum
to 5, so the mean 1.25 and the z -1.04 are unchanged; the original's
per-zero split for that one base does not reproduce.  See the NOTEPAD
line for the chronology.
"""
import math

import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

# --- locked constants ---------------------------------------------------
R = 32                                       # r = 1..R, d = 0..R-1
ZER = [(2, 1), (4, 1), (8, 3), (20, 6)]      # the four exact dyadic zeros
BASES = [3, 4, 5, 6, 7, 8, 9]
LN2 = math.log(2)


def count(r, d, b):
    """b-rungs inside the window cell (r,d) reads: 2^(r-d-1) .. 2^r."""
    s = LN2 / math.log(b)
    return math.floor(r * s) - math.floor((r - d - 1) * s)


def triangle(b):
    """count over every cell with d < r, as a (d, r-1) array with NaN above."""
    M = np.full((R, R), np.nan)
    for d in range(R):
        for r in range(d + 1, R + 1):
            M[d, r - 1] = count(r, d, b)
    return M


GR, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, axes = plt.subplots(2, 4, figsize=(16.0, 7.4), facecolor=GR)
fig.subplots_adjust(left=.05, right=.97, top=.89, bottom=.09, hspace=.34, wspace=.24)

print("TEST 15 - b-rungs inside each dyadic cell's window.  Reconstruction; "
      "exploratory.")
print(f"r = 1..{R}, d = 0..{R-1}, cells with d < r; "
      f"the four exact zeros are {' '.join('(%d,%d)' % z for z in ZER)}")
print()
print("PART 1 - per base, the count at the zeros against the whole triangle")
print(f"{'base':>5}{'ln2/lnb':>10}{'cells':>7}{'mean all':>10}{'sd all':>9}"
      f"{'at zeros':>10}{'z':>8}   zeros' counts")

grids = {}
for ax, b in zip(axes.ravel(), BASES):
    M = triangle(b)
    grids[b] = M
    flat = M[~np.isnan(M)]
    cz = [count(r, d, b) for r, d in ZER]
    z = (np.mean(cz) - flat.mean()) / flat.std()
    print(f"{b:>5}{LN2/math.log(b):>10.5f}{flat.size:>7}{flat.mean():>10.2f}"
          f"{flat.std():>9.2f}{np.mean(cz):>10.2f}{z:>+8.2f}   {cz}")

    ax.set_facecolor(GR)
    im = ax.pcolormesh(np.arange(1, R + 1), np.arange(R), M,
                       cmap="magma", shading="nearest")
    for r, d in ZER:
        ax.plot(r, d, marker="o", ms=10, mfc="none", mec="#6E9BDB", mew=1.9)
    ax.set_title(f"base {b}",
                 color=INK, fontsize=10, fontfamily="monospace", pad=5)
    ax.set_xlabel("r", color=MUT, fontsize=8)
    ax.set_ylabel("d", color=MUT, fontsize=8)
    ax.tick_params(colors=MUT, labelsize=7)
    for s in ax.spines.values():
        s.set_color("#232A38")
    cb = fig.colorbar(im, ax=ax, fraction=.046)
    cb.ax.tick_params(colors=MUT, labelsize=7)
    cb.outline.set_edgecolor("#232A38")

print()
print("z = (mean at the four zeros - mean over all cells) / sd over all cells.")
print("It is the same ~ -1.0 at every base because the zeros are shallow, "
      "not because they align.")

# --- part 2: the finding that kills the measure --------------------------
print()
print("PART 2 - distinct values of the count at each fixed depth")
print("The window spans 2^(r-d-1)..2^r, so its width in b-rungs is")
print("(d+1)*ln2/ln b - a function of d ALONE.  A fixed-width log window")
print("holds a fixed number of rungs up to a floor wobble, so the count")
print("can take at most two values at any fixed depth.")
print()
print(f"{'depth':>6}{'cells':>7}   " + "".join(f"{'b=%d' % b:>8}" for b in BASES)
      + "     (distinct values at that depth)")
worst = 0
for d in range(R):
    cells = R - d
    row = []
    for b in BASES:
        vals = {count(r, d, b) for r in range(d + 1, R + 1)}
        worst = max(worst, len(vals))
        row.append(len(vals))
    print(f"{d:>6}{cells:>7}   " + "".join(f"{v:>8}" for v in row))

print()
print(f"maximum distinct values at any depth, over every base: {worst}")
print("So the count is depth wearing another name.  It cannot separate one")
print("cell from another at the same depth, and the four zeros' z is a")
print("restatement of their depths.  Coverage is dead as a discriminator.")

print()
print("depth of the four exact zeros: "
      + ", ".join(f"({r},{d}) d={d}" for r, d in ZER)
      + f"   mean {np.mean([d for _, d in ZER]):.2f}")
alld = np.concatenate([[d] * (R - d) for d in range(R)])
print(f"mean depth over the whole triangle: {alld.mean():.2f}  "
      f"sd {alld.std():.2f}   "
      f"z of the zeros' mean depth: "
      f"{(np.mean([d for _, d in ZER]) - alld.mean()) / alld.std():+.2f}")

axes.ravel()[-1].axis("off")
fig.suptitle("How many rungs of each coarser base fall inside every dyadic cell",
             color=INK, fontsize=13, fontfamily="monospace", y=.965)
fig.text(.5, .022, "circles are the four exact zeros",
         color=MUT, fontsize=9, ha="center", fontfamily="monospace")

p = ("/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/"
     "4d0caf67-f72a-4554-a9cc-a363251155d9/scratchpad/coverage.png")
fig.savefig(p, dpi=140, facecolor=GR)
print("\nwrote", p)
