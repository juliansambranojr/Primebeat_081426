"""Characterise the eight curves at ceiling 2^32 - the family as plotted.
No data added, no null, no p-value. Where does each curve sag, how deep,
and on which side of its own run."""
import math, numpy as np, mpmath as mp
from primecountpy import prime_pi
from _paths import tee

tee(__file__)
mp.mp.dps = 40
K, V = 40, 2**32
G = [float(mp.zetazero(k).imag) for k in range(1, K+1)]
NAMES = {2:"dyadic",3:"triadic",4:"tetradic",5:"pentadic",
         6:"hexadic",7:"heptadic",8:"octadic",9:"enneadic"}

def counts(b):
    rmax = int(math.floor(math.log(V)/math.log(b)))
    pis = [prime_pi(int(math.floor(b**r))) for r in range(0, rmax+1)]
    return [pis[r]-pis[r-1] for r in range(1, rmax+1)], rmax

def meas(b, rmax, N):
    f = lambda x: float(mp.li(x)) if x > 2 else 0.0
    return [N[r-1] - (f(b**r) - f(b**(r-1))) for r in range(1, rmax+1)]

def pred(b, rmax):
    lnb, o = mp.log(b), []
    for r in range(1, rmax+1):
        t = mp.mpf(0)
        for g in G:
            rho = mp.mpc(0.5, g)
            t += mp.re(mp.ei(r*rho*lnb) - (mp.ei((r-1)*rho*lnb) if r > 1 else 0))
        o.append(float(-2*t))
    return o

def rows(x):
    R = [list(x)]
    while len(R[-1]) > 1:
        p = R[-1]; R.append([p[i]-p[i-1] for i in range(1, len(p))])
    return R

print("SHAPE OF THE FAMILY AT 2^32 - characterised, not tested.")
print("Depth axis normalised to [0,1] per base, so position means")
print("'how far along its own run', not absolute depth.\n")
print(f"{'base':17}{'depths':>7}{'level':>8}{'dip':>8}{'at':>6}{'side':>7}{'drop':>7}")
for b in range(2, 10):
    N, rmax = counts(b)
    rr, zz = rows(meas(b, rmax, N)), rows(pred(b, rmax))
    c = []
    for d in range(min(len(rr), len(zz))):
        if len(rr[d]) < 3: break
        a, q = np.array(rr[d]), np.array(zz[d])
        if a.std() == 0 or q.std() == 0: break
        c.append(float(np.corrcoef(a, q)[0, 1]))
    c = np.array(c); n = len(c)
    x = np.linspace(0, 1, n); i = int(np.argmin(c))
    lvl, dip, at = float(np.median(c)), float(c[i]), float(x[i])
    side = "left" if at < 0.34 else ("mid" if at < 0.67 else "right")
    print(f"{str(b)+' '+NAMES[b]:17}{n:7d}{lvl:+8.3f}{dip:+8.3f}{at:6.2f}{side:>7}{lvl-dip:7.3f}")
