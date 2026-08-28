"""What is the 0.67%?  Checking entry 248's recorded expectation.  EXPLORATORY.

Entry 248 expected the remainder to live at the scale of zeros-file
precision and edge effects. The file has 9 decimals, so quantization
predicts ~1e-6 absolute against a residual of ~0.034 — that clause should
measure as refuted. The live candidates:

  A. zeros quantization  perturb every gamma by U(-h/2, h/2), h = 1e-9,
                         re-measure the quiet points, report the shift
  B. edge placement      the model's T is a choice inside the last gap
                         (gamma_N, gamma_{N+1}); the measured sum is
                         identical for any such T. Sweep T across the gap
                         and report the residual swing (at Nmax = 1e6)
  C. mirror kernel       the K(u+v) term entered by symmetry guess; drop
                         it at Nmax = 1e7 and report the change
  D. detrend order       cubic -> quartic at the base config

Base config: Nmax = 1e7, T = 74920, skirts + density, cubic detrend,
quiet points as entries 247/248.
"""
import numpy as np
from math import log, pi

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T0 = 74920.0
g = gam[gam <= T0]
N = len(g)
gN = g[-1]
gNext = gam[gam > T0][0]
print(f"RESIDUAL EXPECTATION CHECK.  EXPLORATORY, no prereg.")
print(f"  T0={T0}  N={N}  last zero in: {gN:.6f}  first out: {gNext:.6f}"
      f"  gap width: {gNext-gN:.4f}")

NMAX7, NMAX6 = 10**7, 10**6
sieve = np.ones(NMAX7 + 1, dtype=bool)
sieve[:2] = False
for p in range(2, int(NMAX7 ** 0.5) + 1):
    if sieve[p]:
        sieve[p * p::p] = False
primes = np.nonzero(sieve)[0]
ns, lams = [], []
for p in primes:
    q = int(p)
    while q <= NMAX7:
        ns.append(q)
        lams.append(log(p))
        q *= int(p)
ns = np.array(ns, dtype=float)
lams = np.array(lams)
order = np.argsort(ns)
ns, lams = ns[order], lams[order]
vs = np.log(ns)
cs = -(1.0 / (2 * pi)) * lams / np.sqrt(ns)
n6 = int(np.searchsorted(ns, NMAX6, side="right"))

M = 4096
us = np.linspace(log(2), log(512), M, endpoint=False) + (log(512) - log(2)) / (2 * M)
xg = np.exp(us)


def measure(zz):
    out = np.empty(M, dtype=complex)
    for i in range(0, M, 256):
        out[i:i + 256] = np.exp(1j * np.outer(us[i:i + 256], zz)).sum(axis=1)
    return out


def build(T, stop, mirror=True, split=False):
    accA = np.zeros(M, dtype=complex)
    accB = np.zeros(M, dtype=complex)
    for j in range(0, stop, 16000):
        blk = slice(j, min(j + 16000, stop))
        for i in range(0, M, 512):
            uu = us[i:i + 512, None]
            w1 = uu - vs[None, blk]
            accA[i:i + 512] += (cs[None, blk]
                                * (np.exp(1j * T * w1) - 1.0) / (1j * w1)).sum(axis=1)
            if mirror or split:
                w2 = uu + vs[None, blk]
                accB[i:i + 512] += (cs[None, blk]
                                    * (np.exp(1j * T * w2) - 1.0) / (1j * w2)).sum(axis=1)
    dens = log(T / (2 * pi)) / (2 * pi) * np.exp(1j * us * T) / (1j * us)
    if split:
        return accA, accB, dens
    return accA + (accB if mirror else 0) + dens


def detrend(y, deg=3):
    V = np.vander(us, deg + 1)
    coef, *_ = np.linalg.lstsq(V, y, rcond=None)
    return y - V @ coef


Smeas = measure(g)
mr, mi = detrend(Smeas.real), detrend(Smeas.imag)
amp = np.hypot(mr, mi)
quiet = np.zeros(M, dtype=bool)
for lo in (2, 4, 8, 16, 32, 64, 128, 256):
    sel = (xg >= lo) & (xg < lo * 2)
    quiet[sel] = amp[sel] < np.median(amp[sel])
floor_med = np.median(amp[quiet])


def resid_frac(model, deg=3, meas_r=None, meas_i=None):
    a = detrend(model.real, deg)
    b = detrend(model.imag, deg)
    r = meas_r if meas_r is not None else (detrend(Smeas.real, deg) if deg != 3 else mr)
    im = meas_i if meas_i is not None else (detrend(Smeas.imag, deg) if deg != 3 else mi)
    res = np.hypot(r[quiet] - a[quiet], im[quiet] - b[quiet])
    return np.median(res) / floor_med


# base at 1e7, kernels split for the mirror attribution
accA, accB, dens = build(T0, len(ns), split=True)
base = resid_frac(accA + accB + dens)
noMirror = resid_frac(accA + dens)
quartic = resid_frac(accA + accB + dens, deg=4)
print(f"\nBASE (Nmax=1e7, T={T0}): resid/floor = {base:.4f}"
      f"   floor median = {floor_med:.2f}")
print(f"  C. drop mirror kernel:  {noMirror:.4f}   (change {noMirror-base:+.4f})")
print(f"  D. quartic detrend:     {quartic:.4f}   (change {quartic-base:+.4f})")

# A. quantization
rng = np.random.default_rng(20260828)
shifts = []
for _ in range(2):
    gq = g + rng.uniform(-0.5e-9, 0.5e-9, size=N)
    Sq = measure(gq)
    shifts.append(np.median(np.abs(Sq[quiet] - Smeas[quiet])))
print(f"\nA. QUANTIZATION (h=1e-9, two draws): median |dS| on quiet points ="
      f" {shifts[0]:.2e}, {shifts[1]:.2e}")
print(f"   vs absolute residual {base * floor_med:.3f} — "
      f"ratio {shifts[0] / (base * floor_med):.1e}")

# B. edge placement, at Nmax = 1e6 for runtime
print(f"\nB. EDGE PLACEMENT (Nmax=1e6, T swept across the gap"
      f" [{gN:.3f}, {gNext:.3f}]):")
print("      T          resid/floor")
for Tt in (gN + 0.01, (gN + gNext) / 2, T0, gNext - 0.01):
    fr = resid_frac(build(Tt, n6))
    tag = "  <- entry 248's choice" if Tt == T0 else ""
    print(f"  {Tt:12.4f}   {fr:.4f}{tag}")

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
