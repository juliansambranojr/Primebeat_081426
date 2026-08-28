"""Bridges from the table's filter to the other objects in this bench.

The table's coupling to a spectrum {g} is  Re sum_g (1 - b^-rho)^d, rho = 1/2+ig
(Superposition.lean:90 with Chain.lean:29).  Expanded it is a Dirichlet
polynomial supported on b^k, so it pairs with anything carrying an explicit
formula.  Real zeros at b=2, d=4 give N(T) + 7751.

BRIDGE 1 - GUE / random matrix.  If the +7751 is arithmetic, a spectrum with
the SAME density and the same local repulsion but no primes must give ~0.
Three controls: jittered real zeros, unfolded Poisson, unfolded GUE (Wigner).

BRIDGE 2 - the base law, swept wide.  Couples iff b is a prime power.

BRIDGE 3 - Nyquist.  The filter's alpha-spacing is log b / log T; the bench's
nyquist b = pi / log b (lean/NyquistPeak.lean).  Same log b.

BRIDGE 4 - Shannon.  c_k^2 = C(d,k)^2 b^-k normalized is a distribution over
the prime powers b^k; its entropy is how many rungs the filter actually reads.
"""
import numpy as np
from math import log, pi, comb, exp

rng = np.random.default_rng(20260828)
Zf = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
g = np.array([float(l.split()[0]) for l in open(Zf)])
T = 74920.0; z = g[g <= T]; N = len(z)

def Lam(n):
    m = n
    for p in (2,3,5,7,11,13,17,19,23,29,31,37,41,43,47):
        if m % p == 0:
            while m % p == 0: m //= p
            return log(p) if m == 1 else 0.0
    return 0.0

def couple(gam, b, d):
    """Re sum (1 - b^-rho)^d, minus the trivial count."""
    rho = 0.5 + 1j*np.asarray(gam)
    return np.sum((1 - float(b)**(-rho))**d).real - len(gam)

def predict(b, d, n):
    return -(T/(2*pi))*sum(comb(d,k)*(-1)**k*Lam(b**k)*float(b)**(-k)
                           for k in range(1, d+1))

# ---- unfolding: smooth counting function N(t) ~ (t/2pi)log(t/2pi e) + 7/8
def Nbar(t): return (t/(2*pi))*np.log(t/(2*pi*exp(1))) + 0.875
def unfold_inv(u):
    """invert Nbar by bisection on a grid"""
    tt = np.linspace(1.0, T, 400000); nn = Nbar(tt)
    return np.interp(u, nn, tt)

D = 4; B = 2
print("BRIDGE 1 - is the coupling arithmetic?   b=2, d=4, matched density")
print(f"  real zeros                                 {couple(z,B,D):+10.1f}")
mean_sp = np.diff(z).mean()
for amp in (0.25, 0.5, 1.0):
    j = z + rng.uniform(-amp*mean_sp, amp*mean_sp, N)
    print(f"  real zeros jittered +-{amp:.2f} mean spacing        {couple(np.sort(j),B,D):+10.1f}")
u0 = Nbar(z[0])
gaps = rng.exponential(1.0, N)
poi = unfold_inv(u0 + np.cumsum(gaps))
print(f"  unfolded POISSON, same density             {couple(poi,B,D):+10.1f}")
# Wigner surmise for GUE spacing: p(s) ~ s^2 exp(-4s^2/pi); sample by inverse-cdf grid
s = np.linspace(0, 6, 20000); pdf = s**2*np.exp(-4*s**2/pi); cdf = np.cumsum(pdf); cdf /= cdf[-1]
gg = np.interp(rng.random(N), cdf, s); gg *= 1.0/gg.mean()
gue = unfold_inv(u0 + np.cumsum(gg))
print(f"  unfolded GUE (Wigner surmise), same density{couple(gue,B,D):+10.1f}")
print(f"  predicted for a prime-power base b=2        {predict(B,D,N):+10.1f}")

print()
print("BRIDGE 2 - the base law swept to b=30   (d=4, all 99,998 zeros)")
print("    b   Lambda(b)   measured     predicted     ratio")
for b in range(2, 31):
    m = couple(z, b, D); p = predict(b, D, N)
    r = f"{m/p:7.4f}" if abs(p) > 1 else "      -"
    print(f"   {b:2d}    {Lam(b):.4f}   {m:+10.1f}   {p:+10.1f}   {r}")

print()
print("BRIDGE 4 - Shannon: entropy of the filter's mass over prime powers b^k")
print("    b    d   H (bits)   2^H = effective rungs read")
for b in (2, 3, 6):
    for d in (3, 6, 12):
        c2 = np.array([comb(d,k)**2*float(b)**(-k) for k in range(d+1)], dtype=float)
        c2 /= c2.sum()
        H = -np.sum(c2*np.log2(np.maximum(c2, 1e-300)))
        print(f"   {b:2d}   {d:2d}    {H:6.3f}      {2**H:6.3f}")
