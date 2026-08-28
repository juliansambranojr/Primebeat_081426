"""First moment of the table's own weight over the zeta zero ensemble.

Superposition.lean:90 (tableFrom_eq_modeSum_reweighted) weights each zero rho
by (Sym 2 rho)^d, with Sym b s = 1 - b^(-s) (Chain.lean:29).  Binomial-expand:

    (1 - 2^-rho)^d = sum_k C(d,k) (-1)^k (2^k)^(-rho)

so the support is exactly the powers of two.  Landau-Gonek gives, for each,
Re sum_{0<g<=T} x^{ig} ~ -(T/2pi) Lambda(x)/sqrt(x).  Resumming (k=0 term is
N(T) since Lambda(1)=0):

    Re sum_{0<g<=T} (1 - 2^-rho)^d  =  N(T) + (T/2pi) log2 (1 - 2^-d)

This script measures both sides.  Also prints the Landau-Gonek check itself.
"""
import numpy as np
from math import log, pi, sqrt

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
g = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0
z = g[g <= T]; N = len(z); rho = 0.5 + 1j*z
main = (T/(2*pi))*log(2)

print("LANDAU-GONEK  Re sum x^{i gamma}  vs  -(T/2pi) Lambda(x)/sqrt(x)")
print("      x       measured        predicted     ratio    class")
for x in (2, 3, 5, 7, 13, 6, 10, 15):
    Zx = np.sum(np.exp(1j*z*log(x))).real
    isp = x in (2, 3, 5, 7, 13)
    pred = -(T/(2*pi))*log(x)/sqrt(x) if isp else 0.0
    r = f"{Zx/pred:8.4f}" if isp else "        "
    print(f"  {x:5d}  {Zx:14.1f}  {pred:14.1f}  {r}   {'prime' if isp else 'composite'}")

print()
print(f"FIRST MOMENT OF THE TABLE WEIGHT   N(T)={N}   (T/2pi)log2={main:.1f}")
print("   d      measured Re         predicted      ratio    (1-2^-d)")
for d in range(0, 10):
    s = np.sum((1 - 2.0**(-rho))**d).real
    pred = N + main*(1 - 2.0**(-d))
    print(f"  {d:2d}   {s:15.1f}   {pred:15.1f}   {s/pred:7.5f}   {1-2.0**(-d):.4f}")
