"""Part B: the gap-dependent range, priced on the tree's object.

Target rho0 = 1/2 + eps + i*gamma at gamma = T (section 8 puts it within
T + h/(8 K' pi^2 lam) of the box). Its term, by term_eq_sidebands, is
-(h/2)^2 * Re((S_+ + S_-)^2) with S_- = S m (eps*h) real; S_+ is the far
sideband, under 1e-50 of S_- (part A), dropped here and accounted below.

Against it, at support h (lam = 1, m + 1 = lam*h):
  BG      the on-line background, WeilPowerOnLine.onLineBound_le with lowCount = 0:
          2 * 88 (gamma + r + 2)^4 (4 h^2 + cFarM m / h^2) pi^2/6,
          r = max 1 (5(m+1)/h), cFarM m = cS^2 (200/81)^2 (1/(10(m+1)^2))^(2m)
  CLUSTER N_c = 15 log T + 73 off-line members with eps' <= eps (section 8) and
          delta <= |Delta| < 1/2, each hurting at most (h/2)^2 (|S_-| + |S_+|)^2
          at its own w; the worst over eps' in (0, eps], Delta in [delta, 1/2]
  FAR     every other zero in the box, |Delta| >= 1/2, count N_T =
          T/(2 pi) log(T/(2 pi)) + 112 log T + 698 (unit 0365's band), each at
          most the worst term at |Delta| = 1/2.
Members with |Delta| <= lo/b, lo = lam pi^3/(8 eps'), help (block 13g), and
members with lo/b < |Delta| < delta are what the hypothesis excludes.

|S m w| is evaluated exactly in log space: log cS + log|sinh w| - sum_j log|w^2 + pi^2 (j+1)^2|
(WeilOddPower.S_mul_QS). h0(eps, T, delta) is the least integer h with
|target| > BG + CLUSTER + FAR; L = 2 h0.
"""
import math, json, sys
import numpy as np
from math import lgamma, log, pi

def log_cS(m):
    return log(2) + (2*m+1)*log(pi) + lgamma(2*m+2) - m*log(4)

def log_abs_sinh(x, y):
    # |sinh(x+iy)| = e^{|x|}/2 * |1 - e^{-2|x|} e^{-2i y sign}|
    ax = abs(x)
    t = math.exp(-2*ax) if ax < 700 else 0.0
    c = complex(1 - t*math.cos(2*y), t*math.sin(2*y))
    return ax - log(2) + log(abs(c))

def log_abs_S(m, x, y):
    """log |S m (x + i y)|, exact."""
    j = np.arange(m+1, dtype=np.float64)
    pj2 = (pi*(j+1))**2
    # |w^2 + pj2| with w^2 = (x^2 - y^2) + 2ixy
    re = (x*x - y*y) + pj2
    im = 2*x*y
    s = 0.5*np.sum(np.log(re*re + im*im))
    return log_cS(m) + log_abs_sinh(x, y) - s

def log_target(h, m, eps):
    return 2*log(h/2) + 2*log_abs_S(m, eps*h, 0.0)

def log_member(h, m, gamma, ep, D):
    lm = log_abs_S(m, ep*h, D*h)
    lp = log_abs_S(m, ep*h, (D + 2*gamma)*h)
    return 2*log(h/2) + 2*np.logaddexp(lm, lp)

def log_BG(h, m, gamma):
    lam_r = max(1.0, 5*(m+1)/h)
    log_cFarM = 2*log_cS(m) + 2*log(200/81) - 2*m*log(10*(m+1)**2)
    inner = np.logaddexp(log(4) + 2*log(h), log_cFarM - 2*log(h))
    return log(2*88) + 4*log(gamma + lam_r + 2) + inner + log(pi*pi/6)

def log_rhs(h, m, eps, T, delta, lam):
    gamma = T
    bg = log_BG(h, m, gamma)
    Nc = 15*log(T) + 73
    Dgrid = np.unique(np.concatenate([[delta], np.linspace(delta, 0.5, 8)]))
    egrid = [eps, eps/2, eps/4]
    worst = max(log_member(h, m, gamma, ep, D) for ep in egrid for D in Dgrid)
    cl = log(Nc) + worst
    NT = T/(2*pi)*log(T/(2*pi)) + 112*log(T) + 698
    far = log(NT) + max(log_member(h, m, gamma, ep, 0.5) for ep in egrid)
    return np.logaddexp(np.logaddexp(bg, cl), far), bg, cl, far

def h0(eps, T, delta, lam=1, hmax=2_000_000):
    def ok(h):
        m = lam*h - 1
        lt = log_target(h, m, eps)
        rhs, *_ = log_rhs(h, m, eps, T, delta, lam)
        return lt > rhs
    lo, hi = 4, 8
    while not ok(hi):
        lo, hi = hi, hi*2
        if hi > hmax: return None
    while hi - lo > 1:
        mid = (lo+hi)//2
        if ok(mid): hi = mid
        else: lo = mid
    return hi

out = {}
print("B1. h0(eps, T, delta), lam = 1: the least h with |target| > background + cluster + far")
print(f"   {'eps':>5} {'T':>6} {'delta':>7} {'h0':>9} {'L=2h0':>9} {'lo/h0':>9} {'gap 2pi/logT':>13} {'binding':>8}")
rows = []
for eps in (0.5, 0.25, 0.1):
    for T in (1e3, 1e6, 1e12):
        for delta in (1.0, 0.3, 0.1, 0.03, 0.01):
            h = h0(eps, T, delta)
            if h is None:
                print(f"   {eps:5} {T:6.0e} {delta:7} {'>2e6':>9}"); continue
            m = h - 1
            rhs, bg, cl, far = log_rhs(h, m, eps, T, delta, 1)
            binding = 'bg' if bg >= max(cl, far) else ('cluster' if cl >= far else 'far')
            lo_over = (pi**3/(8*eps))/h
            gap = 2*pi/log(T)
            print(f"   {eps:5} {T:6.0e} {delta:7} {h:9d} {2*h:9d} {lo_over:9.2e} {gap:13.3f} {binding:>8}")
            rows.append(dict(eps=eps, T=T, delta=delta, h0=h, L=2*h, lo_over_h0=lo_over, gap=gap, binding=binding))
out['B1'] = rows
print()
print("B2. scaling of h0 in delta at eps = 1/4, T = 1e6: h0 * delta^2 (constant if the cluster term binds as 1/delta^2)")
for r in rows:
    if r['eps'] == 0.25 and r['T'] == 1e6:
        print(f"   delta={r['delta']:<5} h0={r['h0']:<8d} h0*delta^2={r['h0']*r['delta']**2:9.1f}  binding={r['binding']}")
cited = {}
for r in rows:
    k = f"h0_e{str(r['eps']).replace('.','')}_T{int(math.log10(r['T']))}_d{str(r['delta']).replace('.','')}"
    cited[k] = r['h0']
cited['h0_delta2_limit'] = round(min(r['h0']*r['delta']**2 for r in rows if r['eps']==0.25 and r['T']==1e6 and r['binding']=='cluster'), 1)
cited['cells'] = len(rows); cited['cells_closed'] = sum(1 for r in rows if r['h0'] is not None)
cited['cells_cluster_bound'] = sum(1 for r in rows if r['binding']=='cluster')
cited['lo_over_h0_e025_T6_d003'] = float('%.2e' % [r for r in rows if r['eps']==0.25 and r['T']==1e6 and r['delta']==0.03][0]['lo_over_h0'])
json.dump(cited, open(sys.argv[1], 'w'), indent=1)
