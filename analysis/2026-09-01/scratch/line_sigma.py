# Exploratory. gamma_1 held at its true value; the zero's real part moved 1/2 -> sigma.
# Every other zero fixed; no mirror zero added (the functional-equation partner 1-sigma+i*gamma
# is NOT introduced), so this is one zero sliding sideways and nothing else.
# Same construction as line_0_100_v2.py:
#   prime side   dpsi' - dpsi = 2 Re(x^(rho-1) - x^(rho'-1)) dx,  prime-fill = int of that / log x
#   number side  zeta' = zeta * R, R = (s-rho')(s-rho'bar)/((s-rho)(s-rhobar)) = 1 + a/(s-rho) + c.c.
#                dN' = dN + dN * g,  g(y) = 2 Re(a y^(rho-1))
# A number's new value = N'(n); its primeness = (1 if prime) + prime-fill in (n-1, n].
import sys
import mpmath as mp
from sympy import isprime
mp.mp.dps = 20
g1 = mp.zetazero(1).imag
rho = mp.mpc(0.5, g1)

def run(sigma):
    rhoP = mp.mpc(sigma, g1)
    a = (rho - rhoP) * (rho - mp.conj(rhoP)) / (rho - mp.conj(rho))
    R1 = abs(1 - rhoP)**2 / abs(1 - rho)**2
    def Dprime(x):
        x = mp.mpf(x); return 2 * mp.re(x**(rho - 1) - x**(rhoP - 1))
    def g(y): return 2 * mp.re(a * mp.mpf(y)**(rho - 1))
    def intdens(x):
        x = mp.mpf(x); return sum(g(x / m) / m for m in range(1, int(mp.floor(x)) + 1))
    rows = []
    PiP = NP = mp.mpf(0)
    for n in range(1, 101):
        if n == 1:
            pfill = nfill = mp.mpf(0)
        else:
            pfill = mp.quad(lambda t: Dprime(t) / mp.log(t), [n - 1, n])
            nfill = mp.quad(intdens, [n - 1, n])
        isp = isprime(n)
        PiP += (1 if isp else 0) + pfill
        NP += 1 + nfill
        rows.append((n, NP, (1 if isp else 0) + pfill, PiP))
    return a, R1, rows

out = {}
for s in (0.7, 2.5):
    out[s] = run(s)
    print(f"sigma={s}: a={out[s][0]}  R(1)={out[s][1]}")
print("      |      sigma = 0.7                       |      sigma = 2.5")
print("old   |  new number  primeness  prime index   |  new number  primeness  prime index")
for i in range(100):
    n, N7, p7, P7 = out[0.7][2][i]
    _, N25, p25, P25 = out[2.5][2][i]
    print(f"{n:>3}   | {float(N7):>10.3f} {float(p7):>10.3f} {float(P7):>11.3f}   | {float(N25):>11.2f} {float(p25):>11.2f} {float(P25):>11.2f}")
