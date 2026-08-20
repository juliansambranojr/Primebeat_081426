"""
TEST 3 - dyadic through enneadic, against the sub-integer bases, on one
common footing.

Same measurement as test 2: per depth, the fraction of a row's spectral
power that is not at DC. The crossover d* is the first depth where
oscillation carries more than half.

Every base runs to the same value ceiling 2^32, so they cover the same
stretch of the number line. That is also the limitation: base 9 reaches
2^32 in ten rungs, so its rows are short and its spectra are coarse. The
rung count is reported beside every base rather than hidden, because the
high bases are the ones it constrains.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from primecountpy import prime_pi
from _paths import FIGURES, tee

tee(__file__)

GAMMA1 = 14.134725141734693
V = 2 ** 32
MIN_N = 6

SUB = [(f"exp(π·{k}/2γ₁)", math.exp(math.pi * k / (2 * GAMMA1))) for k in (1, 2, 3, 4)]
INT = [(str(b), float(b)) for b in range(2, 10)]
BASES = SUB + INT


def seed_row(b):
    rmax = int(math.floor(math.log(V) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(0, rmax + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)], rmax


def build(row):
    rows = [row]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


def osc_fraction(rows, b):
    lnb, out = math.log(b), []
    for d, row in enumerate(rows):
        N = len(row)
        if N < MIN_N:
            break
        u = np.empty(N)
        for i, v in enumerate(row):
            r = i + d + 1
            mag = 0.0 if v == 0 else math.exp(math.log(abs(v)) - (r / 2) * lnb)
            win = 0.5 - 0.5 * math.cos(2 * math.pi * i / (N - 1))
            u[i] = math.copysign(mag, v) * win
        F = np.abs(np.fft.rfft(u)) ** 2
        tot = F.sum()
        out.append(F[1:].sum() / tot if tot > 0 else float("nan"))
    return out


res = []
for name, b in BASES:
    row, rmax = seed_row(b)
    frac = osc_fraction(build(row), b)
    cross = next((d for d, f in enumerate(frac) if f == f and f > 0.5), None)
    res.append((name, b, rmax, frac, cross))
    print(f"{name:15} b={b:7.4f}  rungs={rmax:4d}  depths={len(frac):3d}  d*={cross}")

# --- figure -------------------------------------------------------------
GROUND, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, (ax, bx) = plt.subplots(1, 2, figsize=(13.5, 5.6), facecolor=GROUND,
                             gridspec_kw=dict(width_ratios=[1.35, 1], wspace=0.22))

cm = plt.cm.viridis
for i, (name, b, rmax, frac, cross) in enumerate(res):
    c = cm(i / max(len(res) - 1, 1))
    ax.plot(range(len(frac)), frac, color=c, lw=1.7, marker="o", ms=3,
            label=f"{name}  d*={cross}")
    if cross is not None:
        ax.plot([cross], [frac[cross]], marker="*", ms=13, color=c, zorder=5)

ax.axhline(0.5, color=MUT, lw=1, ls=(0, (4, 4)))
ax.set_facecolor(GROUND)
ax.set_xlabel("depth", color=MUT)
ax.set_ylabel("fraction of power away from DC", color=MUT)
ax.set_title("oscillation taking over from the trend, every base",
             color=INK, fontsize=11, fontfamily="monospace", pad=9)
ax.set_xlim(-0.4, 14)
ax.tick_params(colors=MUT, labelsize=8)
for s in ax.spines.values():
    s.set_color("#232A38")
ax.legend(facecolor="#141924", edgecolor="#232A38", labelcolor=INK,
          fontsize=7.4, ncol=2, loc="lower right")

ok = [(b, c, n) for n, b, rm, f, c in res if c is not None]
bx.scatter([b for b, c, n in ok], [c for b, c, n in ok],
           s=64, c=[cm(i / max(len(res) - 1, 1))
                    for i, (n, b, rm, f, c) in enumerate(res) if c is not None],
           zorder=4)
for b, c, n in ok:
    bx.annotate(n, (b, c), color=MUT, fontsize=7, xytext=(5, -3),
                textcoords="offset points")
bx.set_facecolor(GROUND)
bx.set_xscale("log")
bx.set_xlabel("base  (log)", color=MUT)
bx.set_ylabel("crossover depth  d*", color=MUT)
bx.set_title("d* against base", color=INK, fontsize=11,
             fontfamily="monospace", pad=9)
bx.tick_params(colors=MUT, labelsize=8)
for s in bx.spines.values():
    s.set_color("#232A38")

fig.suptitle("Dyadic through enneadic, with the sub-integer bases, at one value ceiling",
             color=INK, fontsize=13, fontfamily="monospace", y=0.99)
fig.text(0.5, 0.005,
         f"all bases run to 2^32 · base 9 reaches it in 10 rungs, so its rows are short · min row length {MIN_N}",
         color=MUT, fontsize=8.5, ha="center", fontfamily="monospace")

out = str(FIGURES / "family.png")
fig.savefig(out, dpi=150, facecolor=GROUND, bbox_inches="tight")
print("\nwrote", out)

bs = np.array([b for b, c, n in ok], float)
ds = np.array([c for b, c, n in ok], float)
print(f"corr(log b, d*) = {np.corrcoef(np.log(bs), ds)[0,1]:+.3f} over {len(ok)} bases")
