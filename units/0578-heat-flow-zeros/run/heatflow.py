# Exploratory: the real zeros of the de Bruijn-Newman function
#   H_lam(x) = int_0^inf e^{lam u^2} Phi(u) cos(x u) du,
#   Phi(u)   = sum_n (2 pi^2 n^4 e^{9u} - 3 pi n^2 e^{5u}) exp(-pi n^2 e^{4u}),
# so that H_0(x) = Xi(x/2)/8 and the zeros of H_0 are x = 2*gamma.
# Heights: x up to 2 * 219313/500, the point run's T1 (Stage3/TuringRun.lean).
# Method: H_lam(x) = (1/2) int_R e^{lam u^2} Phi(u) e^{ixu} du, the contour moved
# to u = v + i*theta, theta = pi/8 - DELTA, which removes the cancellation
# (H is of size e^{-pi x/8}); Phi is even, so Phi(u) = Phi(-u) for Re u < 0.
# The trapezoid rule on [-V, V] in v. Validated at lam = 0 against the zeros
# of zeta in ../../../lean_stage3/checks/turingrun/zeros.txt.
import json, math, numpy as np
from scipy.optimize import brentq

DELTA = 0.02
THETA = math.pi / 8 - DELTA
V, DV = 2.6, 2.0e-4
NMAX = 40
X1 = 2 * 219313 / 500
XSTEP = 0.02
LAMS = [round(-0.2 + 0.02 * k, 2) for k in range(21)]

v = np.arange(-V, V + DV / 2, DV)
u = v + 1j * THETA
w = np.where(v >= 0, u, -u)                       # Re w >= 0, Phi(u) = Phi(w)
e4 = np.exp(4 * w)
phi = np.zeros_like(w)
for n in range(1, NMAX + 1):
    phi += (2 * math.pi**2 * n**4 * np.exp(9 * w) - 3 * math.pi * n**2 * np.exp(5 * w)) * np.exp(-math.pi * n**2 * e4)

def G(lam, xs):
    """e^{x theta} H_lam(x) on an array of x (real for real x up to rounding)."""
    F = 0.5 * np.exp(lam * u**2) * phi * DV
    out = np.empty(len(xs))
    for i in range(0, len(xs), 400):
        xc = xs[i:i + 400]
        out[i:i + 400] = (np.exp(1j * np.outer(xc, v)) @ F).real
    return out

def real_zeros(lam):
    xs = np.arange(1.0, X1 + XSTEP, XSTEP)
    g = G(lam, xs)
    idx = np.nonzero(np.sign(g[:-1]) * np.sign(g[1:]) < 0)[0]
    f = lambda x: G(lam, np.array([x]))[0]
    return [brentq(f, xs[i], xs[i + 1], xtol=1e-10) for i in idx]

gam = [float(l.split()[1]) for l in open("../../../lean_stage3/checks/turingrun/zeros.txt")]
gam = [g for g in gam if 2 * g <= X1]
res = {"delta": DELTA, "theta": THETA, "V": V, "dv": DV, "nmax": NMAX, "x1": X1,
       "xstep": XSTEP, "lams": LAMS, "zeta_zeros_below": len(gam)}
Z = {}
for lam in LAMS:
    Z[lam] = real_zeros(lam)
    print(lam, len(Z[lam]), flush=True)
z0 = np.array(Z[0.0])
res["validate_count_lam0"] = len(z0)
if len(z0) == len(gam):
    res["validate_max_abs_err_lam0"] = float(np.max(np.abs(z0 - 2 * np.array(gam))))
for lam in LAMS:
    z = np.array(Z[lam]); gaps = np.diff(z)
    key = f"lam_{lam:+.2f}"
    res[key + "_real_zeros"] = len(z)
    res[key + "_min_gap"] = float(gaps.min())
    # spacing normalised by the local mean gap 4*pi/log(x/(4 pi)) (x = 2t)
    mid = (z[1:] + z[:-1]) / 2
    s = gaps / (4 * math.pi / np.log(mid / (4 * math.pi)))
    sel = mid > 100
    res[key + "_spacing_sd"] = float(np.std(s[sel]))
    res[key + "_spacing_min"] = float(np.min(s[sel]))
json.dump(res, open("results.json", "w"), indent=1)
json.dump({str(k): v for k, v in Z.items()}, open("zeros_by_lam.json", "w"))
