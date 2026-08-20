"""
Row spectra of the dyadic and triadic difference tables, against the
aliased zeta zeros and a density-matched null.

Nothing is fitted. Each row of the table is transformed along r and its
whole frequency content is reported. The reference lines are where the
first eight zeta zeros land once folded into (0, pi], which is forced by
sampling once per rung.

Seed rows are the scaffold convention -- 2 and 3 are lattice, not primes
-- matching the original workbook. Composite arms are derived from the
pair identity rather than transcribed, so the two arms cannot disagree.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
from _paths import FIGURES, tee

tee(__file__)

# --- seed rows, scaffold convention ------------------------------------
TAIL2 = [2,2,5,7,13,23,43,75,137,255,464,872,1612,3030,5709,10749,20390,
         38635,73586,140336,268216,513708,985818,1894120,3645744,7027290,
         13561907,26207278,50697537,98182656]
TAIL3 = [5,13,31,76,198,520,1380,3741,10129,27837,76805,213610,596911,
         1675905,4724994,13368647,37947482,108029690,308345825,882177037,
         2529347318,7266270535,20912111193,60284108632,174049197968,
         503218277350]
SEED = {2: [0, 0] + TAIL2, 3: [0, 2] + TAIL3}

NPERM = 2000

GAMMAS = [14.134725141734694, 21.022039638771555, 25.010857580145688,
          30.424876125859513, 32.935061587739190, 37.586178158825671,
          40.918719012147495, 43.327073280914999]          # zeros600.json


def rung_total(b, r):
    return b**r - b**(r - 1)


def build(b, arm):
    row = [rung_total(b, r) - SEED[b][r - 1] if arm == "composite"
           else SEED[b][r - 1] for r in range(1, len(SEED[b]) + 1)]
    rows = [row]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


def spectrum(b, arm):
    """Per-row power spectrum, each row normalised to its own peak."""
    rows, lnb = build(b, arm), math.log(b)
    depths, mat = [], []
    nbin = 64                                   # common frequency grid
    grid = np.linspace(0, math.pi, nbin)
    for d, row in enumerate(rows):
        N = len(row)
        if N < 8:
            break
        u = np.empty(N)
        for i, v in enumerate(row):
            r = i + d + 1
            mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
            win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (N - 1))
            u[i] = math.copysign(mag, v) * win
        # direct transform onto the common grid, so every depth is
        # comparable and short rows are not silently re-binned
        idx = np.arange(N)
        P = np.abs(u @ np.exp(-1j * np.outer(idx, grid))) / N
        mx = P.max()
        mat.append(P / mx if mx > 0 else P)
        depths.append(d)
    return grid, np.array(depths), np.array(mat)


def alias(g, lnb):
    w = (g * lnb) % (2 * math.pi)
    return 2 * math.pi - w if w > math.pi else w


def lines(b, shift=0.0):
    lnb = math.log(b)
    return sorted(alias(g + shift, lnb) for g in GAMMAS)


def alignment(grid, mat, ln):
    """Mean radians from each genuine peak to the nearest reference line."""
    tot, n = 0.0, 0
    for row in mat:
        pk = row.max()
        for i in range(1, len(row) - 1):
            if row[i] <= row[i - 1] or row[i] <= row[i + 1]:
                continue
            if row[i] < 0.35 * pk:
                continue
            tot += min(abs(grid[i] - L) for L in ln)
            n += 1
    return (tot / n, n) if n else (float("nan"), 0)


def chance_level(ln):
    """Exact mean distance from a uniform point on (0, pi] to the nearest line.

    The old form here was mean_gap / 4, which is only correct when the
    lines are evenly spaced: it takes the mean of the gaps and then the
    quarter, when the correct order is the reverse.  A point landing in a
    gap of width w averages w/4 from a line, but it lands in that gap with
    probability proportional to w, so wide gaps are weighted by their own
    width and the exact value is sum(w^2)/(4 sum(w)).  The two agree only
    at zero gap variance; aliased zeros are strongly uneven, so for the
    base-2 line set the formula gave 0.0762 against an exact 0.2020, low
    by 2.65x, and read a real effect as a null.

    The interval ends are one-sided: a point in the strip before the first
    line or after the last averages half that strip, not a quarter.
    """
    L = sorted(ln)
    a, z = L[0], math.pi - L[-1]                      # one-sided ends
    tot = a * a / 2 + z * z / 2
    tot += sum(w * w / 4 for w in np.diff(L))         # interior gaps
    return tot / math.pi


def fold_random(rng, n, lnb):
    """n arbitrary values across the gamma range, through the same fold.

    The decisive null.  If folding alone concentrates lines where the
    peaks are, this scores like the real zeros and the alignment says
    nothing about zeta.
    """
    lo, hi = min(GAMMAS), max(GAMMAS)
    return sorted(alias(v, lnb) for v in rng.uniform(lo, hi, n))


def uniform_lines(rng, n):
    """n lines dropped uniformly on (0, pi] — no fold, no arithmetic."""
    return sorted(rng.uniform(0, math.pi, n))


# --- figure -------------------------------------------------------------
GROUND, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
COL = {(2, "prime"): "#3D6FE0", (2, "composite"): "#7FC8F2",
       (3, "prime"): "#3EAF63", (3, "composite"): "#A2C79A"}

panels = [(2, "prime"), (2, "composite"), (3, "prime"), (3, "composite")]

fig = plt.figure(figsize=(13, 11), facecolor=GROUND)
gs = GridSpec(3, 2, height_ratios=[1, 1, 0.52], hspace=0.42, wspace=0.18,
              left=0.07, right=0.97, top=0.9, bottom=0.07)

report = []

for k, (b, arm) in enumerate(panels):
    ax = fig.add_subplot(gs[k // 2, k % 2], facecolor=GROUND)
    grid, depths, mat = spectrum(b, arm)
    real, null = lines(b, 0.0), lines(b, 2.5)

    ax.pcolormesh(grid, depths, mat, cmap="magma", shading="nearest",
                  vmin=0, vmax=1)

    for L in real:
        ax.axvline(L, color=COL[(b, arm)], lw=1.1, alpha=0.85)
    for L in null:
        ax.axvline(L, color="#B98BD0", lw=0.9, alpha=0.5, ls=(0, (2, 3)))

    mr, nr = alignment(grid, mat, real)
    mn, _ = alignment(grid, mat, null)
    ch = chance_level(real)

    # decisive null: does the fold alone produce the alignment?
    rng = np.random.default_rng(2026)               # REFERENCES.md house seed
    lnb = math.log(b)
    frs = [alignment(grid, mat, fold_random(rng, len(GAMMAS), lnb))[0]
           for _ in range(NPERM)]
    uns = [alignment(grid, mat, uniform_lines(rng, len(GAMMAS)))[0]
           for _ in range(NPERM)]
    frs = np.array([v for v in frs if v == v])
    uns = np.array([v for v in uns if v == v])
    pv = (1 + (frs <= mr).sum()) / (1 + len(frs)) if len(frs) else float("nan")
    report.append((b, arm, mr, mn, float(frs.mean()) if len(frs) else float("nan"),
                   float(uns.mean()) if len(uns) else float("nan"), ch, pv, nr))

    ax.set_title(f"base {b} · {arm}", color=INK, fontsize=11, pad=8,
                 fontfamily="monospace")
    ax.set_xlabel("ω  rad per rung", color=MUT, fontsize=9)
    ax.set_ylabel("depth", color=MUT, fontsize=9)
    ax.tick_params(colors=MUT, labelsize=8)
    for s in ax.spines.values():
        s.set_color("#232A38")
    ax.text(0.985, 0.03,
            f"peak↔real {mr:.4f}   ↔shifted {mn:.4f}   chance {ch:.4f}   p={pv:.3f}   n={nr}",
            transform=ax.transAxes, ha="right", va="bottom",
            color=INK, fontsize=8.2, fontfamily="monospace",
            bbox=dict(fc="#141924", ec="#232A38", pad=3.5))

# --- summary bars -------------------------------------------------------
axs = fig.add_subplot(gs[2, :], facecolor=GROUND)
labels = [f"b{b}\n{a}" for b, a, *_ in report]
x = np.arange(len(report))
w = 0.27
axs.bar(x - w, [r[2] for r in report], w, color="#7FC8F2", label="peak ↔ real γ")
axs.bar(x, [r[3] for r in report], w, color="#B98BD0", label="peak ↔ shifted γ")
axs.bar(x + w, [r[6] for r in report], w, color="#6B7689", label="chance level")
axs.set_xticks(x)
axs.set_xticklabels(labels, color=INK, fontsize=8.5, fontfamily="monospace")
axs.set_ylabel("mean radians to nearest line", color=MUT, fontsize=9)
axs.tick_params(colors=MUT, labelsize=8)
for s in axs.spines.values():
    s.set_color("#232A38")
axs.legend(facecolor="#141924", edgecolor="#232A38", labelcolor=INK,
           fontsize=8.5, loc="upper right")
axs.set_title("lower is closer — if real and shifted are level, the lines identify nothing",
              color=MUT, fontsize=9, pad=8, fontfamily="monospace")

fig.suptitle("Row spectra vs the aliased zeta zeros",
             color=INK, fontsize=14, fontfamily="monospace", y=0.955)
fig.text(0.07, 0.918,
         "solid = first eight zeros folded into (0, π] · dotted = same eight shifted +2.5, spacing preserved",
         color=MUT, fontsize=9, fontfamily="monospace")

out = str(FIGURES / "spectra.png")
fig.savefig(out, dpi=155, facecolor=GROUND)

print("mean radians from each genuine peak to the nearest reference line.")
print("lower is closer.  chance is exact, not the mean-gap/4 approximation.")
print(f"p = fraction of {NPERM} folded-random line sets matching at least as")
print("well as the real zeros.\n")
print(f"{'panel':22} {'real':>9} {'shiftG':>9} {'foldRND':>9} {'uniform':>9}"
      f" {'chance':>9} {'p':>7} {'peaks':>6}")
for b, a, mr, mn, fr, un, ch, pv, n in report:
    print(f"base {b} {a:<14} {mr:9.4f} {mn:9.4f} {fr:9.4f} {un:9.4f}"
          f" {ch:9.4f} {pv:7.3f} {n:6d}")
print("\nwrote", out)
