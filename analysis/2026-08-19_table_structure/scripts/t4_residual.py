"""
TEST 4 - the residual of the zeros, laid over the table.

The explicit formula says the rung counts are a smooth term plus a sum of
oscillations, one per zeta zero. So build both halves independently and
put them in the same space:

  measured   R(r) = N(r) - [li(b^r) - li(b^(r-1))]
  predicted  Z(r) = -2 Re sum_k [ Ei(r*rho_k*ln b) - Ei((r-1)*rho_k*ln b) ]

R comes from prime counts and nothing else. Z comes from zeta zeros and
nothing else. They share no input. Then difference BOTH through the table
and compare depth by depth - if the table is carrying the zeros, the two
should track each other, and keep tracking as depth amplifies them.

li(x^rho) = Ei(rho log x) is used rather than a series, which is the fix
recorded in the notebook after a Gram-series run diverged at 1e182.
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
GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, 41)]   # 40 zeros
V = 2 ** 32


def rung_counts(b):
    rmax = int(math.floor(math.log(V) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(0, rmax + 1)]
    return [pis[r] - pis[r - 1] for r in range(1, rmax + 1)], rmax


def li(x):
    return float(mp.li(x)) if x > 2 else 0.0


def measured_residual(b, rmax):
    N, _ = rung_counts(b)
    out = []
    for r in range(1, rmax + 1):
        smooth = li(b ** r) - li(b ** (r - 1))
        out.append(N[r - 1] - smooth)
    return out


def zero_residual(b, rmax, K):
    """-2 Re sum_k [ Ei(r rho ln b) - Ei((r-1) rho ln b) ]"""
    lnb = mp.log(b)
    out = []
    for r in range(1, rmax + 1):
        tot = mp.mpf(0)
        for g in GAMMAS[:K]:
            rho = mp.mpc(0.5, g)
            a = mp.ei(r * rho * lnb)
            c = mp.ei((r - 1) * rho * lnb) if r > 1 else mp.mpc(0)
            tot += mp.re(a - c)
        out.append(float(-2 * tot))
    return out


def diff_rows(row):
    rows = [list(row)]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows


results = {}
for name, b in (("dyadic", 2.0), ("triadic", 3.0)):
    _, rmax = rung_counts(b)
    R = measured_residual(b, rmax)
    Z = zero_residual(b, rmax, K=40)
    rr, zz = diff_rows(R), diff_rows(Z)
    corr = []
    for d in range(min(len(rr), len(zz))):
        if len(rr[d]) < 5:
            break
        a, c = np.array(rr[d]), np.array(zz[d])
        s = a.std() * c.std()
        corr.append(float(np.corrcoef(a, c)[0, 1]) if s > 0 else float("nan"))
    results[name] = (R, Z, rr, zz, corr, rmax)
    print(f"{name:8} rungs={rmax:3d}   corr(measured residual, zero sum) by depth:")
    print("         " + "  ".join(f"d{d}:{v:+.3f}" for d, v in enumerate(corr[:11])))

# --- figure -------------------------------------------------------------
G, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, axes = plt.subplots(2, 2, figsize=(13.5, 8.4), facecolor=G,
                         gridspec_kw=dict(hspace=0.38, wspace=0.22))

for col, (name, colr) in enumerate((("dyadic", "#3D6FE0"), ("triadic", "#3EAF63"))):
    R, Z, rr, zz, corr, rmax = results[name]

    ax = axes[0][col]
    ax.set_facecolor(G)
    r = np.arange(1, len(R) + 1)
    ax.plot(r, R, color=colr, lw=1.9, marker="o", ms=3.4, label="measured residual")
    ax.plot(r, Z, color="#E8C15A", lw=1.5, ls=(0, (4, 3)), marker="s", ms=2.8,
            label="sum over 40 zeta zeros")
    ax.set_yscale("symlog", linthresh=1)
    ax.set_title(f"{name} · depth 0", color=INK, fontsize=11, fontfamily="monospace")
    ax.set_xlabel("rung r", color=MUT, fontsize=9)
    ax.set_ylabel("residual (symlog)", color=MUT, fontsize=9)
    ax.legend(facecolor="#141924", edgecolor="#232A38", labelcolor=INK, fontsize=8)

    bx = axes[1][col]
    bx.set_facecolor(G)
    bx.plot(range(len(corr)), corr, color=colr, lw=2, marker="o", ms=4.5)
    bx.axhline(0, color=MUT, lw=1)
    bx.axhline(1, color=MUT, lw=0.8, ls=(0, (3, 4)))
    bx.set_ylim(-1.05, 1.05)
    bx.set_title(f"{name} · correlation by depth", color=INK, fontsize=11,
                 fontfamily="monospace")
    bx.set_xlabel("depth", color=MUT, fontsize=9)
    bx.set_ylabel("corr(measured, zeros)", color=MUT, fontsize=9)

    for a in (ax, bx):
        a.tick_params(colors=MUT, labelsize=8)
        for s in a.spines.values():
            s.set_color("#232A38")

fig.suptitle("Measured residual against the zeta-zero sum, differenced together",
             color=INK, fontsize=13, fontfamily="monospace", y=0.975)
fig.text(0.5, 0.012,
         "the two curves share no input - one is prime counts, the other is 40 zeta zeros",
         color=MUT, fontsize=8.6, ha="center", fontfamily="monospace")

out = str(FIGURES / "residual.png")
fig.savefig(out, dpi=150, facecolor=G, bbox_inches="tight")
print("\nwrote", out)
