"""
TEST 4, one figure per base - dyadic through enneadic.

Same two panels as the original dyadic/triadic figure, repeated for every
base rather than summarised:

  top     depth 0, measured residual over the zeta-zero sum, symlog
  bottom  correlation of the two, depth by depth

  measured   R(r) = N(r) - [li(b^r) - li(b^(r-1))]
  predicted  Z(r) = -2 Re sum_k [ Ei(r*rho_k*ln b) - Ei((r-1)*rho_k*ln b) ]

R sees only prime counts. Z sees only zeta zeros. Nothing is shared.

Point count is printed on the correlation panel at every depth, because
it is the thing that decides whether a correlation means anything. Depths
below ten points are drawn hollow and should be read as decoration.
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
V = 2 ** 48
SOLID = 10                       # below this many points, hollow marker

OUT = str(FIGURES) + "/"

NAMES = {2: "dyadic", 3: "triadic", 4: "tetradic", 5: "pentadic",
         6: "hexadic", 7: "heptadic", 8: "octadic", 9: "enneadic"}
COLS = {2: "#3D6FE0", 3: "#3EAF63", 4: "#7FC8F2", 5: "#E8C15A",
        6: "#D0685F", 7: "#A98BD0", 8: "#5FB8A8", 9: "#C98A4B"}


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
        t = mp.mpf(0)
        for g in GAMMAS:
            rho = mp.mpc(0.5, g)
            t += mp.re(mp.ei(r * rho * lnb)
                       - (mp.ei((r - 1) * rho * lnb) if r > 1 else 0))
        out.append(float(-2 * t))
    return out


def diff_rows(row):
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


GR, INK, MUT, GOLD = "#0B0E14", "#C3CBDA", "#6B7689", "#E8C15A"
made = []

# ---- pass 1: gather everything, so every panel can share one set of axes
data = {}
for b in range(2, 10):
    N, rmax = rung_counts(b)
    R, Z = measured(b, rmax, N), predicted(b, rmax)
    rr, zz = diff_rows(R), diff_rows(Z)
    corr, npts = [], []
    for d in range(min(len(rr), len(zz))):
        if len(rr[d]) < 3:
            break
        a, c = np.array(rr[d]), np.array(zz[d])
        if a.std() == 0 or c.std() == 0:
            break
        corr.append(float(np.corrcoef(a, c)[0, 1]))
        npts.append(len(a))
    data[b] = (R, Z, rmax, corr, npts)

XR = max(d[2] for d in data.values()) + 0.6          # rung axis, all bases
XD = max(len(d[3]) for d in data.values()) - 0.4     # depth axis, all bases
allv = [v for d in data.values() for v in list(d[0]) + list(d[1])]
YL = 10 ** math.ceil(math.log10(max(abs(min(allv)), abs(max(allv)))))
print(f"shared axes:  rungs 0-{XR:.1f}   depth 0-{XD:.1f}   residual +/-{YL:g}")

# ---- pass 2: draw, identical axes everywhere
for b in range(2, 10):
    R, Z, rmax, corr, npts = data[b]
    col = COLS[b]
    fig, (ax, bx) = plt.subplots(2, 1, figsize=(7.6, 6.6), facecolor=GR)
    # fixed margins, not tight - every figure must crop identically
    fig.subplots_adjust(left=0.13, right=0.97, top=0.92, bottom=0.10, hspace=0.46)

    r = np.arange(1, len(R) + 1)
    ax.set_facecolor(GR)
    ax.plot(r, R, color=col, lw=2, marker="o", ms=4, label="measured residual")
    ax.plot(r, Z, color=GOLD, lw=1.5, ls=(0, (4, 3)), marker="s", ms=3,
            label=f"sum over {K} zeta zeros")
    ax.set_yscale("symlog", linthresh=1)
    ax.set_xlim(0, XR)
    ax.set_ylim(-YL, YL)
    ax.set_xlabel("rung r", color=MUT, fontsize=9)
    ax.set_ylabel("residual (symlog)", color=MUT, fontsize=9)
    ax.set_title(f"base {b} · {NAMES[b]} · depth 0 · {rmax} rungs · ceiling 2^48",
                 color=INK, fontsize=11.5, fontfamily="monospace", pad=8)
    ax.legend(facecolor="#141924", edgecolor="#232A38", labelcolor=INK, fontsize=8.5)

    bx.set_facecolor(GR)
    xs = np.arange(len(corr))
    bx.plot(xs, corr, color=col, lw=2, zorder=2)
    for i, (v, n) in enumerate(zip(corr, npts)):
        solid = n >= SOLID
        bx.plot([i], [v], marker="o", ms=6.5, zorder=3,
                mfc=col if solid else GR, mec=col, mew=1.5)
        bx.annotate(str(n), (i, v), color=MUT, fontsize=6.6,
                    xytext=(0, 8), textcoords="offset points", ha="center")
    bx.axhline(0, color=MUT, lw=1)
    bx.axhline(1, color=MUT, lw=0.8, ls=(0, (3, 4)))
    bx.set_xlim(-0.5, XD)
    bx.set_ylim(-1.12, 1.18)
    bx.set_xlabel("depth   (number above each point = points it was computed from)",
                  color=MUT, fontsize=8.5)
    bx.set_ylabel("corr(measured, zeros)", color=MUT, fontsize=9)
    bx.set_title("hollow marker = fewer than 10 points, not readable",
                 color=MUT, fontsize=9, fontfamily="monospace", pad=7)

    for a in (ax, bx):
        a.tick_params(colors=MUT, labelsize=8)
        for s in a.spines.values():
            s.set_color("#232A38")

    p = OUT + f"t4b48_base{b}.png"
    fig.savefig(p, dpi=145, facecolor=GR)
    plt.close(fig)
    made.append((b, p, rmax, corr, npts))
    plt.close("all")
    solid_n = sum(1 for n in npts if n >= SOLID)
    print(f"base {b} {NAMES[b]:9} rungs={rmax:3d}  depths={len(corr):3d}  "
          f"readable={solid_n:3d}  d0={corr[0]:+.3f}")

print("\nwrote", len(made), "figures")
