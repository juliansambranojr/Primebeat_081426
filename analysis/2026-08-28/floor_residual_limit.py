"""Does the floor residual keep shrinking with Nmax?  EXPLORATORY.

Entry 247: the zero-parameter skirt model leaves 10.3% / 9.3% / 8.6% of the
floor at Nmax = 1e4/1e5/1e6, shrinking. Before a prereg: extend the ladder
to 1e7 and watch the trend — continuing decline, or saturation at a
floor-of-the-floor the primes do not knit.

Second panel, also zero-parameter: the smooth zero DENSITY has its own
truncation ringing. dN_smooth = (1/2pi) log(t/2pi) dt, and the sharp cutoff
at T leaves the boundary term

    D(u) = log(T/2pi)/(2pi) * e^{iuT}/(iu)

(fixed coefficient from Riemann-von Mangoldt; the lower-boundary piece is
u-smooth and dies in the detrend). It carries the same fast phase e^{iuT}
as the skirts and is exactly residual-sized (~0.25-0.75), so the run
reports resid/floor with and without it at every rung.

Same grid, same quiet-point selection, same cubic detrend as entry 247.
"""
import numpy as np
from math import log, pi, sqrt

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0
g = gam[gam <= T]
N = len(g)

NMAXES = [10**4, 10**5, 10**6, 3 * 10**6, 10**7]
NMAX = NMAXES[-1]
sieve = np.ones(NMAX + 1, dtype=bool)
sieve[:2] = False
for p in range(2, int(NMAX ** 0.5) + 1):
    if sieve[p]:
        sieve[p * p::p] = False
primes = np.nonzero(sieve)[0]
ns, lams = [], []
for p in primes:
    q = int(p)
    while q <= NMAX:
        ns.append(q)
        lams.append(log(p))
        q *= int(p)
ns = np.array(ns, dtype=float)
lams = np.array(lams)
order = np.argsort(ns)
ns, lams = ns[order], lams[order]
vs = np.log(ns)
cs = -(1.0 / (2 * pi)) * lams / np.sqrt(ns)
print(f"FLOOR RESIDUAL LIMIT.  EXPLORATORY, no prereg.  T={T}  N(T)={N}")
print(f"  teeth: {len(ns)} prime powers <= {NMAX:.0e}")

M = 4096
us = np.linspace(log(2), log(512), M, endpoint=False) + (log(512) - log(2)) / (2 * M)
xg = np.exp(us)


def measure(u):
    out = np.empty(len(u), dtype=complex)
    for i in range(0, len(u), 256):
        out[i:i + 256] = np.exp(1j * np.outer(u[i:i + 256], g)).sum(axis=1)
    return out


def K(uu, vv):
    w = uu - vv
    return (np.exp(1j * T * w) - 1.0) / (1j * w)


Smeas = measure(us)
Dens = log(T / (2 * pi)) / (2 * pi) * np.exp(1j * us * T) / (1j * us)


def detrend(y, u):
    V = np.vander(u, 4)
    coef, *_ = np.linalg.lstsq(V, y, rcond=None)
    return y - V @ coef


mr = detrend(Smeas.real, us)
mi = detrend(Smeas.imag, us)
amp = np.hypot(mr, mi)
quiet = np.zeros(M, dtype=bool)
for lo in (2, 4, 8, 16, 32, 64, 128, 256):
    sel = (xg >= lo) & (xg < lo * 2)
    quiet[sel] = amp[sel] < np.median(amp[sel])
floor_med = np.median(amp[quiet])
print(f"  quiet points: {quiet.sum()}   median floor amplitude: {floor_med:.2f}")

print("\nLADDER — detrended floor-only residual, without / with density term")
print("    Nmax      r_Re     r_Im    resid/floor   +density   marginal")
acc = np.zeros(M, dtype=complex)
start = 0
prev = None
for nm in NMAXES:
    stop = int(np.searchsorted(ns, nm, side="right"))
    for j in range(start, stop, 8000):
        blk = slice(j, min(j + 8000, stop))
        for i in range(0, M, 512):
            uu = us[i:i + 512, None]
            acc[i:i + 512] += (cs[None, blk] * (K(uu, vs[None, blk])
                                                + K(uu, -vs[None, blk]))).sum(axis=1)
    start = stop
    for label, extra in (("plain", 0), ("dens", Dens)):
        Sm = acc + extra
        br = detrend(Sm.real, us)
        bi = detrend(Sm.imag, us)
        res = np.hypot(mr[quiet] - br[quiet], mi[quiet] - bi[quiet])
        frac = np.median(res) / floor_med
        if label == "plain":
            rRe = np.corrcoef(mr[quiet], br[quiet])[0, 1]
            rIm = np.corrcoef(mi[quiet], bi[quiet])[0, 1]
            frac_plain = frac
        else:
            frac_dens = frac
    marg = "" if prev is None else f"{prev - frac_plain:+.4f}"
    print(f"  {nm:8.0e}  {rRe:+6.3f}  {rIm:+6.3f}     {frac_plain:6.4f}"
          f"     {frac_dens:6.4f}    {marg}")
    prev = frac_plain

print("\n  (marginal = drop in resid/floor from the previous rung, plain model)")
print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
