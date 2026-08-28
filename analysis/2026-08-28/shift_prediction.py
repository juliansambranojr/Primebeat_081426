"""Does the shift expansion predict the measured F_d, using data already in hand?

Expanding both factors of the table weight a(g) = (1 - 2^-rho)^d:

    a(g) conj(a(g')) = sum_{p,q} c_p c_q e^{-i p g log2} e^{+i q g' log2},
    c_p = C(d,p) (-1)^p 2^{-p/2}

The kernel phase e^{i alpha L (g - g')} absorbs these, so the g-side sees
alpha - p log2/L and the g'-side alpha - q log2/L.  The p = q part is therefore
a c_p^2-weighted average of the UNWEIGHTED F at alpha shifted by multiples of
log2/L = 0.0618:

    F_d(alpha)  ~=  sum_p c_p^2 F_0(alpha - p log2/L) / sum_p c_p^2

The p != q terms are Landau-Gonek resonances: their frequency separation is
(q-p) log2, i.e. x = 2^{q-p}, always a prime power.  Whatever this prediction
misses IS those cross terms.

No new statistic here -- F_0 is the same object entry 235 measured.  This only
evaluates it at the shifted points and compares to the measured rows.
"""
import numpy as np
from math import log, pi, comb

Z = "/Users/juliansambrano/GitHub/Primebeat_081426/imported/twin_count/zeros1.txt"
g = np.array([float(l.split()[0]) for l in open(Z)])
T = 74920.0; CUT = 60.0
z = g[g <= T]; N = len(z); L = log(T)
DIAG = 2*pi*N/(T*L)
SHIFT = log(2)/L

ALPHA = np.array([0.20,0.40,0.60,0.80,0.84,0.88,0.92,1.00,1.20,1.50])
DEPTHS = [1, 2, 3, 6]

# union of every point the prediction needs
need = sorted({round(abs(a - p*SHIFT), 6)
               for a in ALPHA for d in DEPTHS for p in range(d+1)} | set(np.round(ALPHA, 6)))
need = np.array(need)
print(f"  log2/logT = {SHIFT:.6f}   diagonal = {DIAG:.4f}")
print(f"  evaluating unweighted F_0 at {len(need)} shifted points")

j0s = np.empty(N, dtype=np.int64); j1s = np.empty(N, dtype=np.int64)
j0 = 0
for i in range(N):
    while z[i]-z[j0] > CUT: j0 += 1
    j0s[i] = j0; j1s[i] = np.searchsorted(z, z[i]+CUT)

acc = np.zeros(len(need))
for i in range(N):
    lo, hi = j0s[i], j1s[i]
    dg = z[i] - z[lo:hi]
    w = 4.0/(4.0+dg*dg)
    for k, al in enumerate(need):
        acc[k] += np.sum(np.cos(al*L*dg)*w)
F0 = 2*pi*acc/(T*L)
lut = {round(x, 6): v for x, v in zip(need, F0)}

MEAS = {  # from analysis/2026-08-28/results/weighted_F.log
 0: [0.2426,0.3808,0.5888,0.7594,0.7795,0.7909,0.7799,0.7689,0.7456,0.7438],
 1: [0.2913,0.3418,0.5409,0.7289,0.7636,0.7896,0.7816,0.7773,0.7503,0.7351],
 2: [0.4185,0.3147,0.5104,0.7033,0.7407,0.7718,0.7830,0.7805,0.7551,0.7323],
 3: [0.7010,0.2910,0.4834,0.6781,0.7160,0.7501,0.7759,0.7842,0.7580,0.7343],
 6: [2.5371,0.2623,0.4073,0.6033,0.6420,0.6798,0.7178,0.7736,0.7626,0.7486]}

hdr = "        |" + "".join(f"{a:8.2f}" for a in ALPHA)
print(); print("  PREDICTED (p=q part only) vs MEASURED"); print(hdr)
print("  " + "-"*(len(hdr)-2))
for d in DEPTHS:
    c2 = np.array([comb(d, p)**2 * 2.0**(-p) for p in range(d+1)])
    c2 /= c2.sum()
    pred = np.array([sum(c2[p]*lut[round(abs(a-p*SHIFT), 6)] for p in range(d+1)) for a in ALPHA])
    meas = np.array(MEAS[d])
    pmean = sum(p*c2[p] for p in range(d+1))
    print(f"  d={d} pr |" + "".join(f"{v:8.4f}" for v in pred))
    print(f"  d={d} ms |" + "".join(f"{v:8.4f}" for v in meas))
    print(f"  d={d} XT |" + "".join(f"{v:8.4f}" for v in meas-pred)
          + f"   <p>={pmean:.3f}  predicted peak shift {pmean*SHIFT:+.4f}")
    print()

print("  PEAK LOCATION, off-diagonal, on the alpha grid")
print("   d   measured peak   predicted peak (0.88 + <p>*log2/logT)")
for d in [0]+DEPTHS:
    meas = np.array(MEAS[d]) - DIAG
    im = int(np.argmax(meas[3:9])) + 3
    if d == 0:
        pm = 0.0
    else:
        c2 = np.array([comb(d, p)**2 * 2.0**(-p) for p in range(d+1)]); c2 /= c2.sum()
        pm = sum(p*c2[p] for p in range(d+1))
    print(f"  {d:2d}      {ALPHA[im]:.2f}            {0.88 + pm*SHIFT:.3f}")
