"""BRIDGE 5, on the counting table itself.

Riemann's formula:  pi(x) = R(x) - sum_rho R(x^rho),  R(x) = sum_n mu(n)/n Li(x^{1/n})

The four exact zeros {(2,1),(4,1),(8,3),(20,6)} are zeros of
Delta^{d+1} pi(2^.), so they have a direct statement here: the smooth part
Delta^{d+1} R and the zero part Delta^{d+1} sum_rho R(x^rho) cancel exactly.
This measures both halves at those cells and at contrast cells.
"""
import json, numpy as np
from math import comb, log
import mpmath as mp

mp.mp.dps = 25
R_ = "/Users/juliansambrano/GitHub/Primebeat_081426/"
g = np.array([float(l.split()[0]) for l in open(R_+"imported/twin_count/zeros1.txt")])

MU = {1:1,2:-1,3:-1,4:0,5:-1,6:1,7:-1,8:0,9:0,10:1,11:-1,12:0,13:-1,14:1,15:1,16:0}
NMAX = 12

def Rz(x):
    """Riemann R at complex or real x."""
    s = mp.mpf(0) if not isinstance(x, mp.mpc) else mp.mpc(0)
    for n in range(1, NMAX+1):
        if MU.get(n, 0) == 0: continue
        s += mp.mpf(MU[n])/n * mp.li(x**(mp.mpf(1)/n))
    return s

def zero_part(x, gammas):
    """sum over rho and conj(rho) of R(x^rho)."""
    tot = mp.mpc(0)
    lx = mp.log(x)
    for gam in gammas:
        rho = mp.mpc(0.5, gam)
        tot += Rz(mp.e**(rho*lx))
    return 2*mp.re(tot)

cache = json.load(open(R_+"pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in cache.items()}
def cell(r, d): return sum(comb(d+1,k)*(-1)**k*pi2[r-k] for k in range(d+2))

# zeros to use: enough for x = 2^r.  truncation error ~ sqrt(x) log x / T
NG = 2000
gam = g[:NG]
print(f"  using {NG} zeros, gamma up to {gam[-1]:.1f};  R-series to n={NMAX}")
print()
print("     r   d   exact cell   smooth part   zero part    smooth-zero")
CELLS = [(2,1),(4,1),(8,3),(20,6), (20,5),(20,7),(19,6),(21,6),(12,4)]
for (r, d) in CELLS:
    sm = sum(comb(d+1,k)*(-1)**k*Rz(mp.mpf(2)**(r-k)) for k in range(d+2))
    zp = sum(comb(d+1,k)*(-1)**k*zero_part(mp.mpf(2)**(r-k), gam) for k in range(d+2))
    tag = "  <- EXACT ZERO" if cell(r,d) == 0 else ""
    print(f"   {r:3d} {d:3d}  {cell(r,d):11d}  {float(sm):12.4f}  {float(zp):11.4f}  "
          f"{float(sm-zp):11.4f}{tag}")
