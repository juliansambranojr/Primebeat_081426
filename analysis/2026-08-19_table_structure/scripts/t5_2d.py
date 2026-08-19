"""
TEST 5 - the two-dimensional transform.

Every spectrum before this was taken along r at fixed d, which projects
away one of the two axes a mode actually lives on. A zero contributes

    b^(r rho) * (1 - b^(-rho))^d

so its phase is  r*gamma*ln b + d*arg(1 - b^(-rho))  - LINEAR IN BOTH,
i.e. a plane over the (r,d) rectangle with a two-component frequency

    (w_r, w_d) = ( gamma*ln b ,  arg(1 - b^(-rho)) )

Transforming along r alone collapses w_d and lets modes that differ only
in that component pile on top of each other. gamma2 and gamma4 land at
w_r = 2.005 and 2.239 - a third of a radian apart against a resolution
of ~0.2 - but their w_d are different numbers entirely.

So: take the rectangle, flatten both envelopes, window in both
directions, 2D FFT, and mark where each zero is predicted to sit.

Envelope handling, stated because it is the one judgement call here:
 - along r, divide by b^(r/2), the growth every critical-line mode has
 - along d, normalise each row to unit RMS. The depth envelope is
   |1 - b^(-rho)|^d, which DIFFERS per mode, so no single divisor works.
   Row normalisation removes the growth while leaving the phase rotation
   that carries w_d, which is the part being measured.
"""
import math
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import mpmath as mp
from primecountpy import prime_pi

mp.mp.dps = 30
B = 2.0
V = 2 ** 48
DMAX = 15                     # depths 0..DMAX ; r columns = rungs - DMAX
NZ = 8

GAMMAS = [float(mp.zetazero(k).imag) for k in range(1, NZ + 1)]


def table(b):
    rmax = int(math.floor(math.log(V) / math.log(b)))
    pis = [prime_pi(int(math.floor(b ** r))) for r in range(0, rmax + 1)]
    rows = [[pis[r] - pis[r - 1] for r in range(1, rmax + 1)]]
    while len(rows[-1]) > 1:
        p = rows[-1]
        rows.append([p[i] - p[i - 1] for i in range(1, len(p))])
    return rows, rmax


def predicted(gamma, b):
    """(w_r, w_d) for this zero, folded into the half-plane the FFT shows."""
    lnb = math.log(b)
    rho = complex(0.5, gamma)
    wd = math.atan2((1 - b ** (-rho)).imag, (1 - b ** (-rho)).real)
    wr = (gamma * lnb) % (2 * math.pi)
    if wr > math.pi:                      # fold r into [0,pi], conjugate w_d
        wr = 2 * math.pi - wr
        wd = -wd
    return wr, wd


rows, rmax = table(B)
NR = rmax - DMAX                          # columns available at every depth
M = np.zeros((DMAX + 1, NR))
lnb = math.log(B)

for d in range(DMAX + 1):
    row = rows[d]
    seg = row[DMAX - d: DMAX - d + NR]    # align: same r range at every depth
    v = np.array([0.0 if x == 0 else
                  math.copysign(math.exp(math.log(abs(x)) - ((i + DMAX + 1) / 2) * lnb), x)
                  for i, x in enumerate(seg)])
    rms = np.sqrt((v ** 2).mean())
    M[d] = v / rms if rms > 0 else v

wr_win = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(NR) / (NR - 1))
wd_win = 0.5 - 0.5 * np.cos(2 * np.pi * np.arange(DMAX + 1) / DMAX)
W = M * wd_win[:, None] * wr_win[None, :]

F = np.fft.fftshift(np.fft.fft2(W), axes=0)
P = np.abs(F[:, :NR // 2 + 1])
P /= P.max()

wr_ax = 2 * np.pi * np.arange(NR // 2 + 1) / NR
wd_ax = 2 * np.pi * (np.arange(DMAX + 1) - (DMAX + 1) // 2) / (DMAX + 1)

print(f"rectangle {DMAX+1} depths x {NR} rungs   "
      f"resolution  w_r {2*math.pi/NR:.3f}   w_d {2*math.pi/(DMAX+1):.3f}")
print()
print(f"{'zero':>6}{'gamma':>11}{'w_r':>9}{'w_d':>9}   nearest peak / power there")
pts = []
for k, g in enumerate(GAMMAS, 1):
    wr, wd = predicted(g, B)
    i = int(np.argmin(np.abs(wd_ax - wd)))
    j = int(np.argmin(np.abs(wr_ax - wr)))
    pts.append((wr, wd, g, k))
    print(f"{k:>6}{g:>11.4f}{wr:>9.4f}{wd:>9.4f}   bin({wd_ax[i]:+.3f},{wr_ax[j]:.3f})"
          f"  P={P[i, j]:.3f}")

# how crowded is the 1D projection vs the 2D plane
wrs = sorted(p[0] for p in pts)
mind1 = min(wrs[i+1] - wrs[i] for i in range(len(wrs)-1))
mind2 = min(math.hypot(a[0]-b_[0], a[1]-b_[1])
            for i, a in enumerate(pts) for b_ in pts[i+1:])
print()
print(f"closest pair along w_r alone : {mind1:.4f} rad")
print(f"closest pair in the plane    : {mind2:.4f} rad")
print(f"r-resolution {2*math.pi/NR:.4f}   d-resolution {2*math.pi/(DMAX+1):.4f}")

GR, INK, MUT = "#0B0E14", "#C3CBDA", "#6B7689"
fig, ax = plt.subplots(figsize=(9.6, 6.4), facecolor=GR)
ax.set_facecolor(GR)
im = ax.pcolormesh(wr_ax, wd_ax, P, cmap="magma", shading="nearest", vmin=0, vmax=1)
for wr, wd, g, k in pts:
    ax.plot(wr, wd, marker="o", ms=13, mfc="none", mec="#7FC8F2", mew=1.6)
    ax.annotate(f"γ{k}", (wr, wd), color="#7FC8F2", fontsize=9,
                xytext=(11, 5), textcoords="offset points", fontfamily="monospace")
ax.set_xlabel("ω_r   rad per rung", color=MUT)
ax.set_ylabel("ω_d   rad per depth", color=MUT)
ax.set_title(f"2D spectrum of the dyadic table   {DMAX+1} depths × {NR} rungs",
             color=INK, fontsize=12, fontfamily="monospace", pad=10)
ax.tick_params(colors=MUT, labelsize=8)
for s in ax.spines.values():
    s.set_color("#232A38")
cb = fig.colorbar(im, ax=ax)
cb.ax.tick_params(colors=MUT, labelsize=8)
cb.outline.set_edgecolor("#232A38")
fig.text(0.5, 0.005, "circles are where each zero is predicted to sit — "
         "not fitted, computed from γ and the chain's own symbol",
         color=MUT, fontsize=8.6, ha="center", fontfamily="monospace")
p = ("/private/tmp/claude-501/-Users-juliansambrano-GitHub-Primebeat-081426/"
     "4d0caf67-f72a-4554-a9cc-a363251155d9/scratchpad/spectrum2d.png")
fig.savefig(p, dpi=150, facecolor=GR, bbox_inches="tight")
print("\nwrote", p)
