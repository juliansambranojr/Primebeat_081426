# Exploratory. gamma_1 -> 14, all else fixed. Per unit cell (n-1, n]: the prime-mass the
# modified formula assigns, Lam'(n) = Lam(n) - (D(n) - D(n-1)), where
# D(x) = 2 Re(x^rho1/rho1 - x^rho1'/rho1') is the whole change on the prime side.
import mpmath as mp
from sympy import factorint, isprime
mp.mp.dps = 20
g1 = mp.zetazero(1).imag
rho, rhoP = mp.mpc(0.5, g1), mp.mpc(0.5, 14)
def D(x):
    if x == 0: return mp.mpf(0)
    x = mp.mpf(x); return 2*mp.re(x**rho/rho - x**rhoP/rhoP)
def Lam(n):
    f = factorint(n)
    return mp.log(list(f)[0]) if len(f) == 1 else mp.mpf(0)
psi = psiP = mp.mpf(0)
print("  n  kind      Lam(n)   fluid(n)   Lam'(n)     psi(n)   psi'(n)")
for n in range(0, 101):
    if n == 0:
        print("  0  --         0.000     0.000     0.000      0.000     0.000"); continue
    L = Lam(n); fl = -(D(n) - D(n-1)); Lp = L + fl
    psi += L; psiP += Lp
    kind = "prime" if isprime(n) else ("p^k" if L > 0 else ("unit" if n == 1 else "comp"))
    print(f"{n:>3}  {kind:<6} {float(L):>9.3f} {float(fl):>9.3f} {float(Lp):>9.3f}  {float(psi):>9.3f} {float(psiP):>9.3f}")
