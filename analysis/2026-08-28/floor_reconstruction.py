"""Entry 246's check: reconstruct the floor from the primes.  EXPLORATORY.

Model: the measured S(x) = sum_{0<g<=T} e^{i g log x} should, if the floor is
deterministic prime-skirt interference, be reproduced by the sharp-truncation
ringing of every tooth:

    S_model(u) = sum_{n prime power <= Nmax} c_n [K(u - v_n) + K(u + v_n)]
    c_n = -(1/2pi) Lambda(n)/sqrt(n),   v_n = log n
    K(w) = (e^{iTw} - 1)/(iw),  K(0) = T

Calibration is automatic: at u = v_n the own-tooth term is c_n T =
-(T/2pi) Lambda(n)/sqrt(n), Landau's main term. No fitted constants.

The truncated far-tail contributes a u-independent divergent-in-Nmax
constant, so both sides are mean-removed before comparison; everything
u-dependent converges.  Metrics: complex correlation |r|, per-component
Pearson r, fitted complex scale (should be ~1 if the model is physical),
residual floor fraction per octave, Nmax stability at 1e4/1e5/1e6, a
jittered-teeth null, and the integer-grid delta comparison against entry
243's measured deltas.
"""
import numpy as np
from math import log, pi, sqrt

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
gam = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0
g = gam[gam <= T]
N = len(g)

# ---------------------------------------------------------------- teeth
NMAXES = [10**4, 10**5, 10**6]
NMAX = NMAXES[-1]
sieve = np.ones(NMAX + 1, dtype=bool)
sieve[:2] = False
for p in range(2, int(NMAX ** 0.5) + 1):
    if sieve[p]:
        sieve[p * p::p] = False
primes = np.nonzero(sieve)[0]
ns, lams = [], []
for p in primes:
    q = p
    while q <= NMAX:
        ns.append(q)
        lams.append(log(p))
        q *= p
ns = np.array(ns, dtype=float)
lams = np.array(lams)
order = np.argsort(ns)
ns, lams = ns[order], lams[order]
vs = np.log(ns)
cs = -(1.0 / (2 * pi)) * lams / np.sqrt(ns)
print(f"FLOOR RECONSTRUCTION.  EXPLORATORY, no prereg.  T={T}  N(T)={N}")
print(f"  teeth: {len(ns)} prime powers <= {NMAX}")

# ---------------------------------------------------------------- grids
M = 4096
us = np.linspace(log(2), log(512), M, endpoint=False) + (log(512) - log(2)) / (2 * M)
xi = np.arange(2, 513)
ui = np.log(xi.astype(float))


def measure(u):
    out = np.empty(len(u), dtype=complex)
    for i in range(0, len(u), 256):
        out[i:i + 256] = np.exp(1j * np.outer(u[i:i + 256], g)).sum(axis=1)
    return out


def K(w):
    out = np.empty(w.shape, dtype=complex)
    small = np.abs(w) < 1e-12
    wb = np.where(small, 1.0, w)
    out = (np.exp(1j * T * wb) - 1.0) / (1j * wb)
    out[small] = T
    return out


def model(u, v, c, checkpoints):
    """Partial model sums at each Nmax checkpoint (v,c sorted ascending in n)."""
    snaps, acc = [], np.zeros(len(u), dtype=complex)
    start = 0
    for nm in checkpoints:
        stop = int(np.searchsorted(ns, nm, side="right"))
        for j in range(start, stop, 4000):
            blk = slice(j, min(j + 4000, stop))
            for i in range(0, len(u), 256):
                uu = u[i:i + 256, None]
                acc[i:i + 256] += (c[None, blk] * (K(uu - v[None, blk])
                                                   + K(uu + v[None, blk]))).sum(axis=1)
        snaps.append(acc.copy())
        start = stop
    return snaps


Smeas = measure(us)
snaps = model(us, vs, cs, NMAXES)


def stats(a, b):
    """mean-removed complex correlation, per-component r, fitted scale."""
    A = a - a.mean()
    B = b - b.mean()
    rC = abs(np.vdot(A, B)) / (np.linalg.norm(A) * np.linalg.norm(B))
    rRe = np.corrcoef(A.real, B.real)[0, 1]
    rIm = np.corrcoef(A.imag, B.imag)[0, 1]
    scale = np.vdot(B, A) / np.vdot(B, B)          # fit a = scale*b
    resid = A - scale * B
    return rC, rRe, rIm, scale, resid


print("\nGENERIC GRID (4096 points), mean-removed:")
print("    Nmax     |r|_C    r_Re     r_Im     |scale|  arg(scale)  resid/meas")
for nm, Sm in zip(NMAXES, snaps):
    rC, rRe, rIm, sc, resid = stats(Smeas, Sm)
    frac = np.median(np.abs(resid)) / np.median(np.abs(Smeas - Smeas.mean()))
    print(f"  {nm:8.0e}  {rC:6.3f}  {rRe:+6.3f}  {rIm:+6.3f}   {abs(sc):6.3f}"
          f"   {np.angle(sc):+6.3f}    {frac:6.3f}")

# residual per octave at best Nmax
_, _, _, sc, resid = stats(Smeas, snaps[-1])
print("\n  residual per octave (Nmax=1e6): median|resid| vs median|meas floor|")
xg = np.exp(us)
Sc = Smeas - Smeas.mean()
for lo in (2, 8, 32, 128):
    hi = lo * 4
    m = (xg >= lo) & (xg < hi)
    print(f"    [{lo:3d},{hi:3d})   {np.median(np.abs(resid[m])):7.2f}"
          f"   vs {np.median(np.abs(Sc[m])):7.2f}")

# ---------------------------------------------------------------- null
rng = np.random.default_rng(20260828)
vj = vs + rng.uniform(0.05, 0.15, size=len(vs)) * rng.choice([-1, 1], size=len(vs))
stop5 = int(np.searchsorted(ns, 10**5, side="right"))
Sj = model(us, vj[:stop5], cs[:stop5], [10**5])[0]
rC, rRe, rIm, _, _ = stats(Smeas, Sj)
print(f"\nJITTERED-TEETH NULL (Nmax=1e5, teeth moved 0.05-0.15 in log):")
print(f"    |r|_C {rC:.3f}   r_Re {rRe:+.3f}   r_Im {rIm:+.3f}")

# ---------------------------------------------------------------- integers
Si = measure(ui)
Smi = model(ui, vs, cs, [NMAX])[0]
lam_i = np.zeros(len(xi))
for j, x in enumerate(xi):
    idx = np.searchsorted(ns, float(x))
    if idx < len(ns) and ns[idx] == x:
        lam_i[j] = lams[idx]
main = (T / (2 * pi)) * lam_i / np.sqrt(xi)
dmeas = Si.real + main
dmod = Smi.real + main
A = dmeas - dmeas.mean()
B = dmod - dmod.mean()
r = np.corrcoef(A, B)[0, 1]
print(f"\nINTEGERS (511 points): delta_measured vs delta_model  r = {r:+.3f}")
print(f"    median |delta_meas - delta_model| = "
      f"{np.median(np.abs(dmeas - dmod)):.2f}"
      f"   vs median |delta_meas| = {np.median(np.abs(dmeas)):.2f}")

# ------------------------------------------------- detrended floor-only test
# The truncated far tail adds a slowly-growing smooth-in-u drift (its
# u-linear coefficient sum_p 1/(sqrt(p) log p) diverges slowly), which sits
# on the floor points while barely touching the skirt-dominated correlation.
# Remove a cubic in u from both sides per component, then judge the QUIET
# points only: within each octave, the half with smallest |measured|.
print("\nDETRENDED FLOOR-ONLY TEST (cubic in u removed from both sides):")


def detrend(y, u):
    V = np.vander(u, 4)
    coef, *_ = np.linalg.lstsq(V, y, rcond=None)
    return y - V @ coef


print("    Nmax    r_Re,fl  r_Im,fl   resid/floor (median, floor pts)")
for nm, Sm in zip(NMAXES, snaps):
    mr = detrend(Smeas.real, us)
    mi = detrend(Smeas.imag, us)
    br = detrend(Sm.real, us)
    bi = detrend(Sm.imag, us)
    quiet = np.zeros(M, dtype=bool)
    amp = np.hypot(mr, mi)
    for lo in (2, 4, 8, 16, 32, 64, 128, 256):
        sel = (xg >= lo) & (xg < lo * 2)
        quiet[sel] = amp[sel] < np.median(amp[sel])
    rRe = np.corrcoef(mr[quiet], br[quiet])[0, 1]
    rIm = np.corrcoef(mi[quiet], bi[quiet])[0, 1]
    res = np.hypot(mr[quiet] - br[quiet], mi[quiet] - bi[quiet])
    frac = np.median(res) / np.median(amp[quiet])
    print(f"  {nm:8.0e}  {rRe:+6.3f}  {rIm:+6.3f}     {frac:6.3f}")

print("\nEXPLORATORY — no prereg, no decision rule, no verdict.")
