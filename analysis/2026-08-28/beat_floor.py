"""Is the floor under the beat the zero-zero correlation?  EXPLORATORY.

Entry 244 leaves two threads: entry 243 measured only Re S(x) at integers,
S(x) = sum_{0<g<=T} e^{i g log x}; and entry 235's F machinery predicts the
local-average power of |S|^2 below alpha = 1 at a scale far above the
measured Re-part.  This script measures the complex S directly.

Objects:
  generic grid   4096 log-uniform x in [2, 512], offset off the integers
  integer grid   x = 2..512, split prime-power vs Lambda=0
  GUE line       the zero-zero (Montgomery) prediction for the local power
                 below alpha=1:  E|S|^2 ~ (T log T / 2pi) * alpha,
                 alpha = log x / log T.  Per component (Re or Im), half.
  pinned Re      entry 243's delta(x) = Re S(x) + (T/2pi) Lambda(x)/sqrt(x)

Question: does the generic floor match the GUE line, and where do the
integers sit — Re, Im, and modulus — against that floor?
"""
import numpy as np
from math import log, pi, sqrt

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0
g = gam[gam <= T]
N = len(g)
LOGT = log(T)
POW = T * LOGT / (2 * pi)          # (T log T / 2pi)

def vonMangoldt(n):
    m, p = n, None
    for q in range(2, int(n ** 0.5) + 1):
        if m % q == 0:
            p = q
            while m % q == 0:
                m //= q
            break
    if p is None:
        return log(n)
    return log(p) if m == 1 else 0.0

def S_complex(us):
    """S(e^u) for an array of u, chunked."""
    out = np.empty(len(us), dtype=complex)
    for i in range(0, len(us), 256):
        u = us[i:i + 256]
        ph = np.outer(u, g)                    # (chunk, N)
        out[i:i + 256] = np.exp(1j * ph).sum(axis=1)
    return out

print(f"BEAT FLOOR vs ZERO-ZERO CORRELATION.  EXPLORATORY, no prereg.")
print(f"  T={T}  N(T)={N}  sqrt(N)={sqrt(N):.1f}  (TlogT/2pi)={POW:.0f}")

# generic grid, offset off the integers by construction
M = 4096
us = np.linspace(log(2), log(512), M, endpoint=False) + (log(512) - log(2)) / (2 * M)
Sg = S_complex(us)
xg = np.exp(us)

# integer grid
xi = np.arange(2, 513)
Si = S_complex(np.log(xi.astype(float)))
lam = np.array([vonMangoldt(int(x)) for x in xi])
deltaRe = Si.real + POW * 0 + (T / (2 * pi)) * lam / np.sqrt(xi)   # Re minus main
isPP = lam > 0

print("\nOCTAVE TABLE — median per bin")
print("               |            generic grid              |        integers")
print("    bin    alpha| med|S|  GUEsqrt  med|Re|  med|Im|    | mdRe-pin  med|Im|  n_pp n_l0")
for lo in (2, 4, 8, 16, 32, 64, 128, 256):
    hi = lo * 2
    mg = (xg >= lo) & (xg < hi)
    mi = (xi >= lo) & (xi < hi)
    xmid = sqrt(lo * hi)
    alpha = log(xmid) / LOGT
    gue = sqrt(POW * alpha)
    medS = np.median(np.abs(Sg[mg]))
    medRe = np.median(np.abs(Sg[mg].real))
    medIm = np.median(np.abs(Sg[mg].imag))
    medPin = np.median(np.abs(deltaRe[mi]))
    medImI = np.median(np.abs(Si[mi].imag))
    print(f"  [{lo:3d},{hi:3d}) {alpha:.3f}| {medS:7.1f} {gue:7.1f} {medRe:8.1f}"
          f" {medIm:8.1f}    | {medPin:8.2f} {medImI:8.1f}  {isPP[mi].sum():3d} {(~isPP[mi]).sum():4d}")

# slope of the generic floor vs the GUE line
alphas = np.log(xg) / LOGT
r = np.abs(Sg) ** 2 / (POW * alphas)
print(f"\nGENERIC FLOOR vs GUE LINE  |S|^2 / ((TlogT/2pi)*alpha):")
print(f"    median {np.median(r):.3f}   mean {np.mean(r):.3f}"
      f"   quartiles [{np.percentile(r,25):.3f}, {np.percentile(r,75):.3f}]")
print(f"    (1.000 = the zero-zero correlation carries the floor)")

# Re/Im symmetry on the generic grid
print(f"\nGENERIC Re/Im SPLIT:  median|Re| {np.median(np.abs(Sg.real)):.1f}"
      f"   median|Im| {np.median(np.abs(Sg.imag)):.1f}"
      f"   (equal = isotropic phase)")

# where the integers sit
print("\nINTEGERS AGAINST THE FLOOR (all 511):")
floor_at = np.sqrt(POW * np.log(xi) / LOGT)
pinRatio = np.abs(deltaRe) / floor_at
imRatio = np.abs(Si.imag) / floor_at
print(f"    |Re - main| / floor:  median {np.median(pinRatio):.4f}"
      f"   (prime powers {np.median(pinRatio[isPP]):.4f},"
      f" Lambda=0 {np.median(pinRatio[~isPP]):.4f})")
print(f"    |Im| / floor:         median {np.median(imRatio):.4f}"
      f"   (prime powers {np.median(imRatio[isPP]):.4f},"
      f" Lambda=0 {np.median(imRatio[~isPP]):.4f})")

# the three largest |Im| at integers, for eyeballing
top = np.argsort(-np.abs(Si.imag))[:5]
print("    largest |Im S| at integers:",
      ", ".join(f"x={xi[t]} Im={Si.imag[t]:+.1f}" for t in top))

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
