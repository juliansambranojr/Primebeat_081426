# Exploratory. Move gamma_1 to 14 in the explicit formula; everything else cancels,
# so the change on the prime side is D(x) = 2 Re( x^rho1/rho1 - x^rho1'/rho1' ).
import mpmath as mp
mp.mp.dps = 20
g1 = mp.zetazero(1).imag
print("gamma_1 =", g1)
rho  = mp.mpc(0.5, g1)
rhoP = mp.mpc(0.5, 14)
def D(x):
    x = mp.mpf(x)
    return 2*mp.re(x**rho/rho - x**rhoP/rhoP)
def env(x):  # full amplitude of one zero's term, 2 sqrt(x)/|rho|
    return 2*mp.sqrt(x)/abs(rho)
dg = g1 - 14
print("delta gamma =", dg, " beat period in log x =", 2*mp.pi/dg,
      " half-period (sign flip) at x = e^(pi/dg) =", mp.exp(mp.pi/dg))
print()
print("      x        D(x)      2sqrt(x)/|rho1|   ratio")
for x in [2,3,5,7,10,100,1000,1e4,1e6,1e8,1e10,1.3e10,1e12]:
    d = D(x); e = env(x)
    print(f"{x:>10.3g}  {float(d):>9.4f}   {float(e):>9.3f}   {float(abs(d)/e):>6.3f}")
print()
# where does the displaced zero first misplace a whole unit of psi-mass?
x = 2
while abs(D(x)) < 1: x *= 1.05
print("first x with |D(x)| >= 1 :", f"{x:.4g}")
# psi(x) - x is O(sqrt x): at what x does D(x) reach the size of the whole prime error band, ~2 sqrt(x)?
