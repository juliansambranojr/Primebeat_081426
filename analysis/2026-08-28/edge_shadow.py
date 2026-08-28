"""Does the residual travel with the boundary?  Entry 251's check.  EXPLORATORY.

The measured sum (zeros <= 74920) is fixed. Move the model's edge K zeros
deeper — T_K = midpoint of the gap below the K-th-from-last zero — and book
the strip (T_K, T] EXACTLY from the known zeros:

    model_K(u) = skirts(T_K) + density(T_K) + sum_{strip} e^{i gamma u}

Every model_K accounts for the same zero set; they differ only in where the
truncated-representation boundary sits. If the residual is the boundary's
shadow (entry 251), all K give the same residual MEDIAN while the residual
VECTORS decorrelate as the boundary moves. If part of the error is bulk
misrepresentation near the original edge, booking those pages exactly makes
deeper-K models match better.

Config: Nmax = 1e7, quartic detrend, quiet points as entries 247-249.
K = 0 is the baseline (edge at the last gap's midpoint, entry 249's rule).
"""
import numpy as np
from math import log, pi

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T0 = 74920.0
g = gam[gam <= T0]
N = len(g)
gNext = gam[gam > T0][0]

NMAX = 10**7
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

M = 4096
us = np.linspace(log(2), log(512), M, endpoint=False) + (log(512) - log(2)) / (2 * M)
xg = np.exp(us)

print(f"EDGE SHADOW.  EXPLORATORY, no prereg.  T={T0}  N={N}"
      f"  teeth {len(ns)} <= 1e7")


def measure(zz, u):
    out = np.empty(len(u), dtype=complex)
    for i in range(0, len(u), 256):
        out[i:i + 256] = np.exp(1j * np.outer(u[i:i + 256], zz)).sum(axis=1)
    return out


def build(T):
    """skirts + density at edge T; fast phases as outer products."""
    eu = np.exp(1j * T * us)                     # e^{iTu}, 4096
    evm = np.exp(-1j * T * vs)                   # e^{-iTv}, teeth
    evp = np.conj(evm)                           # e^{+iTv}
    acc = np.zeros(M, dtype=complex)
    for j in range(0, len(ns), 16000):
        blk = slice(j, min(j + 16000, len(ns)))
        c = cs[blk]
        v = vs[blk]
        for i in range(0, M, 512):
            uu = us[i:i + 512, None]
            w1 = uu - v[None, :]
            w2 = uu + v[None, :]
            k1 = (eu[i:i + 512, None] * evm[None, blk] - 1.0) / (1j * w1)
            k2 = (eu[i:i + 512, None] * evp[None, blk] - 1.0) / (1j * w2)
            acc[i:i + 512] += (c[None, :] * (k1 + k2)).sum(axis=1)
    dens = log(T / (2 * pi)) / (2 * pi) * np.exp(1j * us * T) / (1j * us)
    return acc + dens


def detrend(y, deg=4):
    V = np.vander(us, deg + 1)
    coef, *_ = np.linalg.lstsq(V, y, rcond=None)
    return y - V @ coef


Smeas = measure(g, us)
mr, mi = detrend(Smeas.real), detrend(Smeas.imag)
ampq = np.hypot(detrend(Smeas.real, 3), detrend(Smeas.imag, 3))
quiet = np.zeros(M, dtype=bool)
for lo in (2, 4, 8, 16, 32, 64, 128, 256):
    sel = (xg >= lo) & (xg < lo * 2)
    quiet[sel] = ampq[sel] < np.median(ampq[sel])
floor_med = np.median(np.hypot(mr, mi)[quiet])
print(f"  quiet points {quiet.sum()}   floor median (quartic) {floor_med:.2f}")

KS = [0, 2, 8, 32, 128]
resids = {}
print("\nLADDER — edge moved K zeros deeper, strip booked exactly")
print("    K      T_edge        resid/floor")
for K in KS:
    if K == 0:
        Tk = (g[-1] + gNext) / 2
        strip = np.zeros(M, dtype=complex)
    else:
        Tk = (g[-K - 1] + g[-K]) / 2
        strip = measure(g[-K:], us)
    Sm = build(Tk) + strip
    rr = mr - detrend(Sm.real)
    ri = mi - detrend(Sm.imag)
    resids[K] = (rr.copy(), ri.copy())
    frac = np.median(np.hypot(rr, ri)[quiet]) / floor_med
    print(f"  {K:4d}   {Tk:12.4f}   {frac:.4f}")

print("\nRESIDUAL-VECTOR CORRELATION vs K=0 (quiet points, Re / Im):")
r0r, r0i = resids[0]
for K in KS[1:]:
    rr, ri = resids[K]
    cr = np.corrcoef(r0r[quiet], rr[quiet])[0, 1]
    ci = np.corrcoef(r0i[quiet], ri[quiet])[0, 1]
    print(f"    K={K:4d}:  {cr:+.3f} / {ci:+.3f}")

print("""
READING KEY (stated before looking, entry 251):
  equal medians + decorrelating vectors  -> error travels with the boundary
  deeper-K matches better                -> bulk error near the original edge
""")
print("EXPLORATORY — no prereg, no decision rule, no verdict.")
