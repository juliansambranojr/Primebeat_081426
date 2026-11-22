"""Part C: the price of a uniform L(eps, T) with the annihilating multiplier. EXPLORATORY.

Object. The term of the zero form at a zero rho for the multiplied window is
-(p(s))^2 (what(s))^2, s = rho - 1/2 (identity.py), what = (h/2)(S(w+) + S(w-))
(WeilOddPower.what_eq, WeilPowerBridge.term_eq_sidebands), lam = 1, m + 1 = h = M.
|S| is evaluated in log space from the Gamma closed form identity.py checks
against WeilOddPower.S_mul_QS:

    log|S m (x+iy)| = log cS m + log|w| - 2M log pi
                      - Re[lgamma(M+1 - y/pi + i x/pi) + lgamma(M+1 + y/pi - i x/pi)].

Configuration, worst case. Target s0 = eps + i*g0, any zero of the box
(real part offset >= eps, |height| <= T); the window is tuned to g0. The CLUSTER is
every other off-line zero within RC = 0.9 in height of the target: at most
N = 15 log T + 73 of them with multiplicity (JensenCount.zeta_local_zero_count; the
disk of that theorem covers |height - g0| <= sqrt(13)/4 = 0.9014 for every real part
in [1/2, 1]). The radius is 0.9 and not 1/2 because of C4 below: at lam = 1 a zero at
real part offset 1/2 and height distance 1/2 has a term that GROWS with h (the
quartic term of the exponent), and at 0.9 none does; the count is the same.

The ladder. theta_i = theta_0 * xi^(-i), theta_0 = lam pi^3/(8h), xi = 12 N,
i = 0..N. N members and N+1 annuli (theta_{i+1}, theta_i]: one annulus is empty;
take the first, i*. Members with |s0 - a_j| > theta_{i*} are ANNIHILATED: p has
the factor (s^2 - a_j^2)(s^2 - conj(a_j)^2). Members with |s0 - a_j| <= theta_{i*+1}
are KEPT; their terms have the target's sign (block 13g's boundary lo/h, with the
multiplier's phase drift over that distance under pi/4 because of the ratio xi)
and are dropped from the bound. Two rotator factors (s^2 - c)^2 put
p(s0)^2 what(s0)^2 on the positive real axis (planted.py).

The loss. For a zero at s = eps' + i(g0 + tau), 0 <= eps' <= 1/2:

    |p(s)/p(s0)|^2 <= Mult(tau) :=
        [1 + (|tau| + 1/2)(2 g0 + |tau| + 1)/(2 eps g0)]^4                     rotators
      * prod_j [ (|tau|+RC+1/2)(|tau|+RC+1)/(d_j eps) * ((2g0+|tau|+RC+1)/(2g0-RC))^2 ]^2

    with prod_j 1/d_j <= theta_0^(-N) * xi^(N(N+1)/2): the worst placement is one
    member just inside each annulus, the empty one last.

What the target must beat (orbit weight 4 on every term, a crude over-count):
  NEAR  on-line zeros within RC of g0: at most N, each term <= (h/2)^2 (2+2)^2
        (WeilPowerBackground.PsiW_le_two on both sidebands), times Mult(RC)
  FAR   every zero with |tau| >= RC, on-line or not, in cells of width 1/2, at most
        15 log(g0 + |tau| + 2) + 73 per cell: |S| is increasing in the real part
        (|Gamma(a+ib)| decreases in |b|), so the cell's bound is at eps' = 1/2 and
        the cell's near edge; times Mult at the far edge.

h0(eps, T) is the least integer h with target > 4 (NEAR + FAR), maximised over
g0 in {14.134725, T}; L = 2 h0.

Gates before the table: (1) the Gamma form against unit 0366's product form;
(2) unit 0366's recorded h0 at three cells, recomputed with this file's log|S|;
(3) the double-precision log|S| against mpmath at M = 10^9.
"""
import json, math, sys
import numpy as np
from math import lgamma, log, pi
from scipy.special import loggamma
import mpmath as mp

LOGPI = log(pi)

def log_cS(m):
    return log(2) + (2*m+1)*LOGPI + lgamma(2*m+2) - m*log(4)

def logabsS(M, x, y):
    """log |S (M-1) (x + i y)|, Gamma closed form. x, y floats or arrays; not for x = 0 with y > pi*M."""
    x = np.asarray(x, dtype=np.float64); y = np.asarray(y, dtype=np.float64)
    a = loggamma((M + 1 - y/pi) + 1j*(x/pi)).real + loggamma((M + 1 + y/pi) - 1j*(x/pi)).real
    return log_cS(M-1) + 0.5*np.log(x*x + y*y) - 2*M*LOGPI - a

# ---- unit 0366's product form, verbatim, for the gates -------------------------------
def log_abs_sinh(x, y):
    ax = abs(x)
    t = math.exp(-2*ax) if ax < 700 else 0.0
    c = complex(1 - t*math.cos(2*y), t*math.sin(2*y))
    return ax - log(2) + log(abs(c))
def log_abs_S_0366(m, x, y):
    j = np.arange(m+1, dtype=np.float64)
    pj2 = (pi*(j+1))**2
    re = (x*x - y*y) + pj2
    im = 2*x*y
    s = 0.5*np.sum(np.log(re*re + im*im))
    return log_cS(m) + log_abs_sinh(x, y) - s
def h0_0366(eps, T, delta, S, lam=1, hmax=2_000_000):
    """unit 0366's gap_price.h0, with log|S| passed in."""
    def log_target(h, m, eps): return 2*log(h/2) + 2*S(m, eps*h, 0.0)
    def log_member(h, m, gamma, ep, D):
        return 2*log(h/2) + 2*np.logaddexp(S(m, ep*h, D*h), S(m, ep*h, (D + 2*gamma)*h))
    def log_BG(h, m, gamma):
        lam_r = max(1.0, 5*(m+1)/h)
        log_cFarM = 2*log_cS(m) + 2*log(200/81) - 2*m*log(10*(m+1)**2)
        inner = np.logaddexp(log(4) + 2*log(h), log_cFarM - 2*log(h))
        return log(2*88) + 4*log(gamma + lam_r + 2) + inner + log(pi*pi/6)
    def log_rhs(h, m):
        gamma = T
        bg = log_BG(h, m, gamma)
        Nc = 15*log(T) + 73
        Dgrid = np.unique(np.concatenate([[delta], np.linspace(delta, 0.5, 8)]))
        egrid = [eps, eps/2, eps/4]
        worst = max(log_member(h, m, gamma, ep, D) for ep in egrid for D in Dgrid)
        cl = log(Nc) + worst
        NT = T/(2*pi)*log(T/(2*pi)) + 112*log(T) + 698
        far = log(NT) + max(log_member(h, m, gamma, ep, 0.5) for ep in egrid)
        return np.logaddexp(np.logaddexp(bg, cl), far)
    def ok(h):
        m = lam*h - 1
        return log_target(h, m, eps) > log_rhs(h, m)
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
gate = True
print("G1. Gamma form against unit 0366's product form: max |difference of log|S||")
g1 = 0.0
for m, x, y in [(59, 15.0, 0.0), (599, 150.0, 12.0), (5994, 1498.75, 0.0), (5994, 1498.75, 599.5), (5994, 2997.5, 2997.5), (29999, 3000.0, 15000.0)]:
    d = abs(float(logabsS(m+1, x, y)) - log_abs_S_0366(m, x, y))
    g1 = max(g1, d)
    print(f"   m = {m:6d}  w = {x} + {y} i   diff {d:.2e}")
out['gate1_max_diff'] = float('%.2e' % g1)
gate &= g1 < 1e-6

print("G2. unit 0366's recorded h0, recomputed here with the Gamma form")
rec = {}
for line in open(sys.argv[1]):
    if line.startswith('gap_price.h0_'):
        k, v = line.split()
        rec[k] = v
Sg = lambda m, x, y: float(logabsS(m+1, x, y))
g2 = 0
for key, (eps, T, delta) in {'gap_price.h0_e025_T6_d10': (0.25, 1e6, 1.0), 'gap_price.h0_e05_T3_d10': (0.5, 1e3, 1.0), 'gap_price.h0_e01_T12_d001': (0.1, 1e12, 0.01)}.items():
    got = h0_0366(eps, T, delta, Sg)
    want = int(rec[key])
    print(f"   {key}: recorded {want}, recomputed {got}")
    g2 += (got == want)
out['gate2_cells'] = 3; out['gate2_reproduced'] = g2
gate &= (g2 == 3)

print("G3. double precision against mpmath at M = 10^9")
mp.mp.dps = 60
def logabsS_mp(M, x, y):
    w = mp.mpc(x, y); z = w/mp.pi; m = M - 1
    lc = mp.log(2) + (2*m+1)*mp.log(mp.pi) + mp.loggamma(2*m+2) - m*mp.log(4)
    return float(mp.re(lc + mp.log(w) - 2*M*mp.log(mp.pi) - mp.loggamma(M+1+1j*z) - mp.loggamma(M+1-1j*z)))
g3 = 0.0
for x, y in [(1e8, 0.0), (5e8, 5e8), (5e8, 2.5e9), (1e8, 2e12)]:
    a = float(logabsS(10**9, x, y)); b = logabsS_mp(10**9, x, y)
    g3 = max(g3, abs(a - b))
    print(f"   w = {x:.1e} + {y:.1e} i   double {a:.6f}   mpmath {b:.6f}   diff {abs(a-b):.2e}")
out['gate3_max_diff'] = float('%.2e' % g3)
gate &= g3 < 1e-2
out['gate_pass'] = 1 if gate else 0
print("GATES", "pass" if gate else "FAIL")
if not gate:
    json.dump(out, open(sys.argv[2], 'w'), indent=1); sys.exit(1)

# ---- the price ----------------------------------------------------------------------
KCELLS = 400
RC = 0.9      # cluster radius in height; sqrt(13)/4 = 0.9014 is what the count's disk covers

def Ncount(T):
    return math.floor(15*log(T) + 73)

def log_mult(tau, eps, g0, N, h, rc=RC):
    theta0 = pi**3/(8*h)
    xi = 12*N
    rot = 4*np.log1p((tau + 0.5)*(2*g0 + tau + 1)/(2*eps*g0))
    per = 2*N*(np.log(tau + rc + 0.5) + np.log(tau + rc + 1) - log(eps) + 2*np.log((2*g0 + tau + rc + 1)/(2*g0 - rc)))
    ladder = N*(N+1)*log(xi)
    theta = 2*N*log(1/theta0)
    return rot + per + ladder + theta, ladder, theta

def sides(h, eps, T, g0, rc=RC):
    M = h; N = Ncount(T)
    lm = float(logabsS(M, eps*h, 0.0)); lp = float(logabsS(M, eps*h, 2*g0*h))
    target = 2*log(h/2) + 2*(lm + math.log1p(-math.exp(min(lp - lm, -1e-300)))) if lp < lm else -math.inf
    mnear, ladder, theta = log_mult(rc, eps, g0, N, h, rc)
    near = log(N) + log(4*h*h) + mnear
    k = np.arange(0, KCELLS, dtype=np.float64)
    tlo, thi = rc + k/2, rc + (k+1)/2
    Sm = logabsS(M, 0.5*h, tlo*h)
    Sp = float(logabsS(M, 0.5*h, g0*h))
    cnt = np.log(15*np.log(g0 + thi + 2) + 73)
    mfar, _, _ = log_mult(thi, eps, g0, N, h, rc)
    cells = log(2) + cnt + 2*log(h/2) + 2*np.logaddexp(Sm, Sp) + mfar
    far = float(np.logaddexp.reduce(cells))
    rhs = log(4) + float(np.logaddexp(near, far))
    mono = int(np.sum(np.diff(Sm) > 0))
    return target, rhs, near, far, ladder, theta, float(cells[-1]), mono

def h0(eps, T, g0, rc=RC, hmax=10**13):
    def ok(h):
        t, r, *_ = sides(h, eps, T, g0, rc)
        return t > r
    lo, hi = 64, 128
    while not ok(hi):
        lo, hi = hi, hi*2
        if hi > hmax: return None
    while hi - lo > 1:
        mid = (lo + hi)//2
        if ok(mid): hi = mid
        else: lo = mid
    return hi

print()
print("C1. h0(eps, T): the least h at which the target beats every other zero's worst case; no gap hypothesis")
print(f"   {'eps':>5} {'T':>6} {'N':>4} {'deg p':>6} {'h0':>13} {'L=2h0':>13} {'ladder':>10} {'theta':>9} {'rate*h0':>10} {'binding':>7} {'worst g0':>9} {'h0/unit0366':>11}")
rows = []
base = {(0.5, 1e3): 'gap_price.h0_e05_T3_d10', (0.5, 1e6): 'gap_price.h0_e05_T6_d10', (0.5, 1e12): 'gap_price.h0_e05_T12_d10',
        (0.25, 1e3): 'gap_price.h0_e025_T3_d10', (0.25, 1e6): 'gap_price.h0_e025_T6_d10', (0.25, 1e12): 'gap_price.h0_e025_T12_d10',
        (0.1, 1e3): 'gap_price.h0_e01_T3_d10', (0.1, 1e6): 'gap_price.h0_e01_T6_d10', (0.1, 1e12): 'gap_price.h0_e01_T12_d10'}
mono_total = 0; tail_max = -math.inf; stable = 0
for eps in (0.5, 0.25, 0.1):
    for T in (1e3, 1e6, 1e12):
        cand = [(h0(eps, T, g0), g0) for g0 in (14.134725, T)]
        h, g0 = max(cand)
        t, r, near, far, ladder, theta, last, mono = sides(h, eps, T, g0)
        mono_total += mono; tail_max = max(tail_max, last - r)
        # the inequality must stay true above h0
        st = all(sides(f*h, eps, T, g0)[0] > sides(f*h, eps, T, g0)[1] for f in (2, 10, 100))
        stable += st
        N = Ncount(T)
        rate = 2*eps*eps/pi**2
        b0366 = int(rec[base[(eps, T)]])
        binding = 'near' if near >= far else 'far'
        print(f"   {eps:5} {T:6.0e} {N:4d} {4*N+4:6d} {h:13d} {2*h:13d} {ladder:10.4e} {theta:9.3e} {rate*h:10.4e} {binding:>7} {g0:9.4g} {h/b0366:11.1f}")
        rows.append(dict(eps=eps, T=T, N=N, h0=h, L=2*h, ladder=ladder, theta=theta, rate_h0=rate*h, binding=binding, g0=g0,
                         over0366=h/b0366, target=t, rhs=r))
print(f"   monotone-in-height violations of the cell bound: {mono_total};  last cell relative to the total, log: {tail_max:.3e};  cells still closed at 2, 10, 100 times h0: {stable} of {len(rows)}")

print()
print("C2. what the loss is made of, and how h0 scales")
print("   log loss = N(N+1) log(12N) [ladder] + 2N log(8h/pi^3) [theta, from theta_0 = pi^3/(8h)] + 2N log(const/eps) + lower order;")
print("   gain = (2 eps^2/pi^2) h to leading order. Ratio h0 * (2 eps^2/pi^2) / ladder:")
for r_ in rows:
    print(f"   eps={r_['eps']:<5} T={r_['T']:<7.0e} ratio {r_['rate_h0']/r_['ladder']:.4f}   theta/ladder {r_['theta']/r_['ladder']:.4f}")

print()
print("C3. the same route with a ladder ratio that did not grow with N would lose only N log: compare N^2 log(12N) with section 9's Q^N")
for T in (1e3, 1e6, 1e12):
    N = Ncount(T)
    print(f"   T={T:<7.0e} N={N}   ladder N(N+1)log(12N) = {N*(N+1)*log(12*N):.4e}   section 9, N log 8 as the LOG of the range = {N*log(8):.4e}  (range itself e^that)")

print()
print("C4. why the cluster radius is 0.9: the exact exponent of |S|^2 per unit h at lam = 1,")
print("    2F(u) = -2 Re[(1+z)log(1+z) + (1-z)log(1-z)], z = i u/pi  (Stirling on the Gamma form), and the same from log|S| at h = 10^7")
def F2(u):
    z = 1j*u/pi
    return float(-2*((1+z)*np.log(1+z) + (1-z)*np.log(1-z)).real)
def F2num(u, h=10**7):
    return float(2*(logabsS(h, u.real*h, u.imag*h) - logabsS(h//2, u.real*h/2, u.imag*h/2))/(h/2))
pts = [("target eps = 0.1", 0.1+0j), ("target eps = 0.05", 0.05+0j), ("far zero 1/2 + i/2", 0.5+0.5j), ("far zero 1/2 + 0.9i", 0.5+0.9j)]
for name, u in pts:
    print(f"   {name:<22} 2F = {F2(u):+.6e}   from log|S|: {F2num(u):+.6e}")
import scipy.optimize as so
eps_star = so.brentq(lambda e: F2(e+0j) - F2(0.5+0.5j), 1e-3, 0.4)
print(f"   radius 1/2: the far zero at 1/2 + i/2 outgrows every target with eps below {eps_star:.4f}")
h_small = h0(0.05, 1e6, 14.134725, rc=0.5, hmax=10**12)
print(f"   radius 1/2, eps = 0.05, T = 1e6: h0 = {h_small}   (None: no h up to 10^12 closes)")
print("   radius 0.9, small eps, T = 1e6:")
small = []
for eps in (0.05, 0.02, 0.01):
    hh = max(h0(eps, 1e6, g0) for g0 in (14.134725, 1e6))
    t, r, near, far, ladder, theta, last, mono = sides(hh, eps, 1e6, 14.134725)
    print(f"   eps = {eps:<5} h0 = {hh:<14d} h0 * (2 eps^2/pi^2) / ladder = {2*eps*eps/pi**2*hh/ladder:.4f}   binding {'near' if near >= far else 'far'}")
    small.append((eps, hh))
out['F2_far_half_half'] = float('%.4e' % F2(0.5+0.5j)); out['F2_far_half_09'] = float('%.4e' % F2(0.5+0.9j))
out['F2_target_e01'] = float('%.4e' % F2(0.1+0j)); out['F2_target_e005'] = float('%.4e' % F2(0.05+0j))
out['eps_star_radius_half'] = round(eps_star, 4)
out['radius_half_e005_closes'] = 0 if h_small is None else 1
out['rc'] = RC; out['rc_disk'] = round(math.sqrt(13)/4, 4)
for eps, hh in small:
    out['h0_small_e' + str(eps).replace('.', '') + '_T6'] = hh

def key(r_):
    return f"h0_e{str(r_['eps']).replace('.','')}_T{int(math.log10(r_['T']))}"
for r_ in rows:
    out[key(r_)] = r_['h0']
    out['L_' + key(r_)[3:]] = r_['L']
    out['N_T%d' % int(math.log10(r_['T']))] = r_['N']
    out['degp_T%d' % int(math.log10(r_['T']))] = 4*r_['N'] + 4
    out['over0366_' + key(r_)[3:]] = round(r_['over0366'], 1)
    out['ratio_' + key(r_)[3:]] = round(r_['rate_h0']/r_['ladder'], 3)
out['cells'] = len(rows); out['cells_closed'] = sum(1 for r_ in rows if r_['h0'] is not None)
out['cells_near_bound'] = sum(1 for r_ in rows if r_['binding'] == 'near')
out['cells_stable_above'] = stable
out['mono_violations'] = mono_total
out['ratio_min'] = round(min(r_['rate_h0']/r_['ladder'] for r_ in rows), 3)
out['ratio_max'] = round(max(r_['rate_h0']/r_['ladder'] for r_ in rows), 3)
out['h0_max'] = max(r_['h0'] for r_ in rows); out['h0_min'] = min(r_['h0'] for r_ in rows)
out['L_max'] = 2*out['h0_max']
out['ladder_T6'] = float('%.4e' % [r_ for r_ in rows if r_['T'] == 1e6][0]['ladder'])
out['kcells'] = KCELLS
json.dump(out, open(sys.argv[2], 'w'), indent=1)
