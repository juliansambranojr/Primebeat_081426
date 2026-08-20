"""
TEST 4, across bases - dyadic through enneadic, plus two sub-integer.

Same construction as before, run for every base:

  measured   R(r) = N(r) - [li(b^r) - li(b^(r-1))]
  predicted  Z(r) = -2 Re sum_k [ Ei(r*rho_k*ln b) - Ei((r-1)*rho_k*ln b) ]

R sees only prime counts. Z sees only zeta zeros. Difference both through
the table and correlate at each depth.

The honest limit is point count. Every base runs to the same ceiling
2^32, so base 9 gets ten rungs and its correlations run out of data by
depth 5. Points remaining are reported at every depth rather than
smoothed over, and any depth with fewer than ten is dropped.
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

mp.mp.dps = 40
K = 40
GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, K + 1)]
V = 2 ** 32
MIN_PTS = 10

G1 = 14.134725141734693
BASES = ([(f"exp(π·{k}/2γ₁)", math.exp(math.pi * k / (2 * G1))) for k in (1, 2)]
         + [(str(b), float(b)) for b in range(2, 10)])


def rung_counts(b):
    rmax = int(math.floor(math.log(V) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(0, rmax + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)], rmax


def measured(b, rmax, N):
    f = lambda x: float(mp.li(x)) if x > 2 else 0.0
    return [N[r - 1] - (f(b ** r) - f(b ** (r - 1))) for r in range(1, rmax + 1)]


def predicted(b, rmax):
    lnb, out = mp.log(b), []
    for r in range(1, rmax + 1):
        tot = mp.mpf(0)
        for g in GAMMAS:
            rho = mp.mpc(0.5, g)
            tot += mp.re(mp.ei(r * rho * lnb)
                         - (mp.ei((r - 1) * rho * lnb) if r > 1 else 0))
        out.append(float(-2 * tot))
    return out


def diff_rows(row):
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


res = []
for name, b in BASES:
    N, rmax = rung_counts(b)
    rr, zz = diff_rows(measured(b, rmax, N)), diff_rows(predicted(b, rmax))
    corr, npts = [], []
    for d in range(min(len(rr), len(zz))):
        if len(rr[d]) < MIN_PTS:
            break
        a, c = np.array(rr[d]), np.array(zz[d])
        if a.std() == 0 or c.std() == 0:
            break
        corr.append(float(np.corrcoef(a, c)[0, 1]))
        npts.append(len(a))
    peak = int(np.argmax(corr)) if corr else None
    res.append((name, b, rmax, corr, npts, peak))
    head = " ".join(f"{v:+.2f}" for v in corr[:11])
    pk = f"peak {corr[peak]:+.3f} @d{peak}" if peak is not None else "—"
    print(f"{name:14} b={b:7.4f} rungs={rmax:4d} depths={len(corr):3d}  {pk:22} {head}")

# --- figure -------------------------------------------------------------
GR, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, (ax, bx) = plt.subplots(1, 2, figsize=(13.5, 5.8), facecolor=GR,
                             gridspec_kw=dict(width_ratios=[1.4, 1], wspace=0.22))
cm = plt.cm.viridis

for i, (name, b, rmax, corr, npts, peak) in enumerate(res):
    c = cm(i / max(len(res) - 1, 1))
    ax.plot(range(len(corr)), corr, color=c, lw=1.8, marker="o", ms=3.2,
            label=f"{name} ({rmax} rungs)")
    if peak is not None:
        ax.plot([peak], [corr[peak]], marker="*", ms=13, color=c, zorder=5)

ax.axhline(0, color=MUT, lw=1)
ax.axhline(1, color=MUT, lw=0.8, ls=(0, (3, 4)))
ax.set_facecolor(GR)
ax.set_ylim(-1.05, 1.08)
ax.set_xlim(-0.4, 14)
ax.set_xlabel("depth", color=MUT)
ax.set_ylabel("corr(measured residual, zero sum)", color=MUT)
ax.set_title("does the table carry the zeros — every base", color=INK,
             fontsize=11, fontfamily="monospace", pad=9)
ax.tick_params(colors=MUT, labelsize=8)
for s in ax.spines.values():
    s.set_color("#232A38")
ax.legend(facecolor="#141924", edgecolor="#232A38", labelcolor=INK,
          fontsize=7.3, ncol=2, loc="lower left")

pk = [(b, max(c), n) for n, b, rm, c, np_, p in res if c]
bx.scatter([b for b, m, n in pk], [m for b, m, n in pk], s=66,
           c=[cm(i / max(len(res) - 1, 1)) for i, (n, b, rm, c, np_, p)
              in enumerate(res) if c], zorder=4)
for (b, m, n), (nm, *_ ) in zip(pk, [r for r in res if r[3]]):
    bx.annotate(nm, (b, m), color=MUT, fontsize=7, xytext=(5, -3),
                textcoords="offset points")
bx.set_facecolor(GR)
bx.set_xscale("log")
bx.set_ylim(-0.05, 1.05)
bx.set_xlabel("base (log)", color=MUT)
bx.set_ylabel("best correlation reached", color=MUT)
bx.set_title("peak agreement against base", color=INK, fontsize=11,
             fontfamily="monospace", pad=9)
bx.tick_params(colors=MUT, labelsize=8)
for s in bx.spines.values():
    s.set_color("#232A38")

fig.suptitle("Measured residual vs a 40-zero sum, dyadic through enneadic",
             color=INK, fontsize=13, fontfamily="monospace", y=0.98)
fig.text(0.5, 0.005,
         "all bases to 2^32 · base 9 has ten rungs so it yields no usable depth · "
         "depths with fewer than ten points dropped",
         color=MUT, fontsize=8.5, ha="center", fontfamily="monospace")

out = str(FIGURES / "residual_family.png")
fig.savefig(out, dpi=150, facecolor=GR, bbox_inches="tight")
print("\nwrote", out)
