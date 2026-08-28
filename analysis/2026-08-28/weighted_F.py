"""Pair correlation under the TABLE's own weight.

F_d(alpha,T) = sum_{g,g'} Re[ a(g) conj(a(g')) e^{i alpha logT (g-g')} ] w(g-g')
               / sum_g |a(g)|^2   *   (2 pi N(T) / (T log T))

with a(g) = (1 - 2^-rho)^d, rho = 1/2 + i g   -- Superposition.lean:90's weight.
Normalized so every d has the SAME diagonal as the unweighted d=0 case, so any
difference between rows is pure off-diagonal.  d=0 reproduces standard F.
"""
import numpy as np
from math import log, pi

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
g = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0; CUT = 60.0
z = g[g <= T]; N = len(z); L = log(T)
rho = 0.5 + 1j*z
DIAG = 2*pi*N/(T*L)

ALPHA = np.array([0.2,0.4,0.6,0.8,0.84,0.88,0.92,1.0,1.2,1.5])
DEPTHS = [0,1,2,3,6]

# precompute window bounds once
j0s = np.empty(N, dtype=np.int64); j1s = np.empty(N, dtype=np.int64)
j0 = 0
for i in range(N):
    while z[i]-z[j0] > CUT: j0 += 1
    j0s[i] = j0; j1s[i] = np.searchsorted(z, z[i]+CUT)

print(f"  T={T:.0f}  N={N}  CUT={CUT}  diagonal={DIAG:.4f}")
print(f"  alpha grid: {list(ALPHA)}")
print()
hdr = "   d  |" + "".join(f"{a:7.2f}" for a in ALPHA)
print(hdr); print("  " + "-"*(len(hdr)-2))

rows = {}
for d in DEPTHS:
    a = (1 - 2.0**(-rho))**d
    n2 = np.sum(np.abs(a)**2)
    acc = np.zeros(len(ALPHA))
    for i in range(N):
        lo, hi = j0s[i], j1s[i]
        dg = z[i] - z[lo:hi]
        w = 4.0/(4.0+dg*dg)
        # b_i conj(b_j) = a_i conj(a_j) e^{i alpha L (g_i - g_j)}
        ac = a[i]*np.conj(a[lo:hi])
        for k, al in enumerate(ALPHA):
            ph = al*L*dg
            acc[k] += np.sum((ac.real*np.cos(ph) - ac.imag*np.sin(ph))*w)
    F = acc/n2*DIAG
    rows[d] = F
    print(f"  {d:2d}  |" + "".join(f"{v:7.4f}" for v in F))

print()
print("  OFF-DIAGONAL ONLY  (F_d - diagonal):")
print(hdr); print("  " + "-"*(len(hdr)-2))
for d in DEPTHS:
    print(f"  {d:2d}  |" + "".join(f"{v:7.4f}" for v in rows[d]-DIAG))
print()
print("  DIFFERENCE FROM UNWEIGHTED  (F_d - F_0):")
for d in DEPTHS[1:]:
    print(f"  {d:2d}  |" + "".join(f"{v:7.4f}" for v in rows[d]-rows[0]))
