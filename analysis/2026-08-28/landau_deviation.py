"""C1 — the Landau deviation, measured properly.  EXPLORATORY (no prereg).

The metric, in the project's words (ROADMAP.md C1): "deviation vs d and vs b,
against Landau's known error-term shape. Question: does it scale like the
unconditional error term, or exceed it? Is its base-dependence Lambda(b) like
the main term, or something else?"  Entry 236 measured the drift
1.00000 -> 1.00042 as d: 1 -> 9 at b = 2 and left it unexamined.

The object (entry 236, sym_moment.py):

    measured(b,d) = Re sum_{0<g<=T} (1 - b^-rho)^d,   rho = 1/2 + i g
    P(b,d)        = N(T) + (T/2pi) Lambda(b) (1 - (1-1/b)^d)
    D(b,d)        = measured - P                      (the deviation)

Landau-Gonek as recorded in-repo (lab_notebook_2.md:545):
Re sum x^{ig} ~ -(T/2pi) Lambda(x)/sqrt(x).  Define the per-x deviation

    delta(x) = sum_{g<=T} cos(g log x) + (T/2pi) Lambda(x)/sqrt(x)

Binomial expansion makes the decomposition EXACT (an identity, no analysis):

    D(b,d) = sum_{k=1}^{d} C(d,k) (-1)^k b^{-k/2} delta(b^k)

so the whole question reduces to how delta(x) scales in x.  Two reference
shapes:  the unconditional (Gonek-type) envelope grows like sqrt(x)*log(xT);
a flat oscillation scale sits at ~sqrt(N).  Slope of log|delta| vs log x:
1/2 tracks the envelope, 0 is flat.

Outputs: per-x delta scan with octave-binned medians and a least-squares
slope; the exact decomposition check; D(b,d) across bases and depths with
dominant-k attribution; base-dependence of D against Lambda(b); T-stability
at three cuts.
"""
import numpy as np
from math import log, pi, sqrt, comb

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T_FULL = 74920.0


def vonMangoldt(n):
    m, p = n, None
    for q in range(2, int(n ** 0.5) + 1):
        if m % q == 0:
            p = q
            while m % q == 0:
                m //= q
            break
    if p is None:
        return log(n)          # n prime
    return log(p) if m == 1 else 0.0


def delta(x, g, T):
    return float(np.sum(np.cos(g * log(x)))) + (T / (2 * pi)) * vonMangoldt(x) / sqrt(x)


def run(T):
    g = gam[gam <= T]
    N = len(g)
    rho = 0.5 + 1j * g
    return g, N, rho


g, N, rho = run(T_FULL)
print(f"C1 — Landau deviation.  EXPLORATORY, no prereg.  T={T_FULL}  N(T)={N}")
print(f"  sqrt(N) = {sqrt(N):.1f}   sqrt(N/2) = {sqrt(N/2):.1f}")

# ---------------------------------------------------------------- per-x scan
print("\nPER-X SCAN  delta(x) for all integer x in [2, 512]")
xs = np.arange(2, 513)
ds = np.array([delta(int(x), g, T_FULL) for x in xs])
absd = np.abs(ds)

print("  octave-binned medians of |delta|, against the two shapes:")
print("    bin           n   med|delta|   med/sqrt(x)   med/(sqrt(x)log(xT))")
for lo in (2, 4, 8, 16, 32, 64, 128, 256):
    hi = lo * 2
    m = (xs >= lo) & (xs < hi)
    if m.sum() == 0:
        continue
    med = float(np.median(absd[m]))
    xmid = sqrt(lo * hi)
    print(f"    [{lo:3d},{hi:3d})   {m.sum():3d}   {med:9.2f}   {med/sqrt(xmid):9.2f}"
          f"   {med/(sqrt(xmid)*log(xmid*T_FULL)):9.3f}")

good = absd > 0
A = np.vstack([np.ones(good.sum()), np.log(xs[good])]).T
coef, *_ = np.linalg.lstsq(A, np.log(absd[good]), rcond=None)
print(f"  least-squares slope of log|delta| vs log x: {coef[1]:+.3f}"
      f"   (envelope shape = +0.500, flat oscillation = 0.000)")

pp = np.array([vonMangoldt(int(x)) > 0 for x in xs])
print(f"  median |delta|: prime powers {np.median(absd[pp]):.2f}"
      f"  vs Lambda=0 x {np.median(absd[~pp]):.2f}"
      f"   (main term subtracted only where Lambda>0)")

# ------------------------------------------------- decomposition + D(b,d)
BASES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 16, 25, 27]
DMAX = 12
print(f"\nD(b,d) = measured - P, with exact-decomposition check (max rel err)")
hdr = "   b  Lam(b) |" + "".join(f"  d={d:<8d}" for d in (1, 2, 3, 6, 9, 12))
print(hdr)
worst = 0.0
Dtab = {}
for b in BASES:
    lam = vonMangoldt(b)
    row = []
    for d in range(1, DMAX + 1):
        meas = float(np.sum((1 - float(b) ** (-rho)) ** d).real)
        P = N + (T_FULL / (2 * pi)) * lam * (1 - (1 - 1 / b) ** d)
        D = meas - P
        Dtab[(b, d)] = D
        recon = sum(comb(d, k) * (-1) ** k * b ** (-k / 2) * delta(b ** k, g, T_FULL)
                    for k in range(1, d + 1))
        if abs(D) > 1e-9:
            worst = max(worst, abs(D - recon) / abs(D))
        row.append(D)
    cells = "".join(f"  {Dtab[(b,dd)]:+9.2f} " for dd in (1, 2, 3, 6, 9, 12))
    print(f"  {b:3d}  {lam:5.3f} |{cells}")
print(f"  decomposition identity max relative error: {worst:.2e}")

# dominant k at b=2, d=9
print("\nDOMINANT k IN D(2,9)  — term_k = C(9,k)(-1)^k 2^(-k/2) delta(2^k)")
tot = 0.0
for k in range(1, 10):
    t = comb(9, k) * (-1) ** k * 2 ** (-k / 2) * delta(2 ** k, g, T_FULL)
    tot += t
    print(f"    k={k}  x={2**k:4d}  delta={delta(2**k, g, T_FULL):+9.2f}"
          f"   term={t:+9.2f}")
print(f"    sum = {tot:+.2f}   D(2,9) = {Dtab[(2,9)]:+.2f}")

# ------------------------------------------------- base dependence
print("\nBASE DEPENDENCE at d=9:  |D| against Lambda(b)")
lams = np.array([vonMangoldt(b) for b in BASES])
D9 = np.array([abs(Dtab[(b, 9)]) for b in BASES])
r = np.corrcoef(lams, D9)[0, 1]
print(f"    corr(Lambda(b), |D(b,9)|) = {r:+.3f}")
z = [b for b in BASES if vonMangoldt(b) == 0]
nz = [b for b in BASES if vonMangoldt(b) > 0]
print(f"    mean |D(b,9)|:  Lambda=0 bases {np.mean([abs(Dtab[(b,9)]) for b in z]):.2f}"
      f"  ({z})")
print(f"                    Lambda>0 bases {np.mean([abs(Dtab[(b,9)]) for b in nz]):.2f}"
      f"  ({nz})")

# ------------------------------------------------- T-stability
print("\nT-STABILITY  delta(x,T) at three cuts, x = 2, 6, 64:")
print("      T        N     sqrt(N) |  d(2)      d(2)/sqN | d(6)      d(6)/sqN"
      " | d(64)     d(64)/sqN")
for Tc in (18730.0, 37460.0, 74920.0):
    gc = gam[gam <= Tc]
    Nc = len(gc)
    row = []
    for x in (2, 6, 64):
        dv = float(np.sum(np.cos(gc * log(x)))) + (Tc / (2 * pi)) * vonMangoldt(x) / sqrt(x)
        row += [dv, dv / sqrt(Nc)]
    print(f"  {Tc:8.0f} {Nc:8d}  {sqrt(Nc):7.1f} | {row[0]:+8.2f}  {row[1]:+7.3f}"
          f" | {row[2]:+8.2f}  {row[3]:+7.3f} | {row[4]:+8.2f}  {row[5]:+7.3f}")

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
