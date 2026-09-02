# Exploratory. gamma_1 -> 14, every other zero fixed. What the number line is, 0..100.
#
# Prime side: psi_new(x) - psi(x) = D(x) = 2 Re(x^rho1/rho1 - x^rho1'/rho1').
# (line_0_100.py had this with the wrong sign: fluid = -(D(n)-D(n-1)). Corrected here.)
# Prime *count* side: dPi_new - dPi = D'(x)/log x  dx.
#
# Integer side: zeta_new(s) = zeta(s) * R(s), R = (s-rho1')(s-rho1'bar)/((s-rho1)(s-rho1bar)),
# R = 1 + a/(s-rho1) + abar/(s-rho1bar), a = (rho1-rho1')(rho1-rho1'bar)/(rho1-rho1bar).
# 1/(s-rho) is the Mellin transform of x^(rho-1) on [1,inf), so
#   dN_new = dN + dN * g(x)dx,  g(y) = 2 Re(a y^(rho1-1)),
# i.e. every whole number stays an atom of mass 1, and between whole numbers there is
# a continuous number-density  sum_{m<=x} g(x/m)/m.
import mpmath as mp
from sympy import isprime, factorint
mp.mp.dps = 20
g1 = mp.zetazero(1).imag
rho, rhoP = mp.mpc(0.5, g1), mp.mpc(0.5, 14)
a = (rho - rhoP) * (rho - mp.conj(rhoP)) / (rho - mp.conj(rho))
print("gamma1 =", g1, " a =", a)

def D(x):
    x = mp.mpf(x)
    return 2 * mp.re(x**rho / rho - x**rhoP / rhoP) if x > 0 else mp.mpf(0)
def Dprime(x):
    x = mp.mpf(x)
    return 2 * mp.re(x**(rho - 1) - x**(rhoP - 1))
def g(y):
    return 2 * mp.re(a * mp.mpf(y)**(rho - 1))
def intdens(x):
    x = mp.mpf(x)
    return sum(g(x / m) / m for m in range(1, int(mp.floor(x)) + 1))

def Lam(n):
    f = factorint(n)
    return mp.log(list(f)[0]) if len(f) == 1 else mp.mpf(0)

print("  n  kind    atom  Lam(n)  Lam-fill  prime-fill  number-fill   Pi'(n)    N'(n)")
Pi = PiP = N = NP = mp.mpf(0)
for n in range(0, 101):
    if n == 0:
        print("  0  --         0   0.000     0.000       0.000        0.000    0.000    0.000"); continue
    L = Lam(n)
    if n == 1:
        lfill = pfill = nfill = mp.mpf(0)
    else:
        lfill = D(n) - D(n - 1)
        pfill = mp.quad(lambda t: Dprime(t) / mp.log(t), [n - 1, n])
        # number-fill: integrand has kinks at each integer m ≤ x only via floor; on (n-1,n) floor is n-1
        nfill = mp.quad(intdens, [n - 1, n])
    isp = isprime(n)
    Pi += 1 if isp else 0
    PiP += (1 if isp else 0) + pfill
    N += 1; NP += 1 + nfill
    kind = "prime" if isp else ("p^k" if L > 0 else ("unit" if n == 1 else "comp"))
    print(f"{n:>3}  {kind:<6}     1 {float(L):>7.3f} {float(lfill):>9.3f}  {float(pfill):>10.3f}  {float(nfill):>11.3f}  {float(PiP):>8.3f} {float(NP):>8.3f}")
print("pi(100) =", int(Pi), " pi'(100) =", PiP, " N'(100) =", NP)
