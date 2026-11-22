"""Section 16 priced on inequalities in the shape of Lean statements. EXPLORATORY.

Unit 0375 priced the annihilating multiplier on the exact S. This re-prices the
same nine cells using, for every zero, a bound that is either a theorem of the
tree with its hypotheses checked here, or a NEW lemma stated here and checked
against the exact S on a grid before it is used.

Setting as unit 0375: lam = 1, m + 1 = h = M, target s0 = eps + i g0, cluster
radius RC = 0.9, N = floor(15 log T + 73), ladder ratio xi = 12 N,
theta_0 = pi^3/(8h), and the multiplier bound Mult(tau) of price.py, unchanged
(it is elementary: distances between points of the strip).

Which bound carries which zero.

  TARGET, near sideband.  WeilPowerSharp.S_real_ge_sharp, hypothesis
      s^2 <= pi^2 (m+2)^2 / 2 with s = eps h:
      Re S m s >= cS/D * s * exp( s^2/(pi^2 (m+2)) - s^4/(pi^4 (m+1)^3) ).
  TARGET, far sideband.  WeilPowerBounds.norm_S_le_far at w = eps h + 2 i g0 h,
      hypothesis 2 (Re w^2... ) i.e. 2((Re w)^2 + pi^2 (m+1)^2) <= (Im w)^2:
      |S m w| <= cS * cosh(Re w) * (2/(Im w)^2)^(m+1).
  ON-LINE, |tau| < RC.  WeilPowerBackground.online_term_le_near: term <= 4 h^2.
  ANY OTHER ZERO, RC <= |tau| <= TAU_SW, real part offset in [0, 1/2].
      NEW LEMMA N1 (tail bound, every w, no regime):
          |S m w| <= cS/D * |w| * exp( Re(w^2) * sigma m + |w|^4 / (6 pi^4 (m+1)^3) ),
      from the tree's product S = cS/D * w * prod_{j>m} (1 + w^2/(pi^2 (j+1)^2))
      (WeilPowerGauss.tendsto_S), |1 + z| <= exp(Re z + |z|^2/2), and
      sum_{i >= m+2} i^-4 <= 1/(3 (m+1)^3). With Re(w^2) <= 0 the tree's
      WeilPowerPhase.sigma_ge gives sigma m >= 1/(pi^2 (m+2)).
      The tree's own WeilPowerSharp.norm_S_le_c_neg has the exponent
      Re(w^2)(m+2)/(pi^2 (2m+3)^2) + |w|^4/(pi^4 (m+1)^3) and the regime
      |w|^2 <= pi^2 (m+2)^2/2; part P2 below shows where that one stops closing.
  ANY OTHER ZERO, |tau| >= TAU_SW.  norm_S_le_far again, its hypothesis checked.
  Every other zero's far sideband: norm_S_le_far at height distance >= g0.

No monotonicity of the exact S is used: each bound is an explicit expression,
increasing in the real part offset (worst at 1/2) and with its dependence on tau
read off the formula, cell by cell (the exponent of N1 at the cell's near edge,
its |w| at the far edge).
"""
import json, math, sys
import numpy as np
from math import lgamma, log, pi
from scipy.special import loggamma

LOGPI = log(pi); RC = 0.9; TAU_SW = 4.6; KCELLS = 400
rng = np.random.default_rng(20260828)

def log_cS(m): return log(2) + (2*m+1)*LOGPI + lgamma(2*m+2) - m*log(4)
def log_D(m): return (2*m+2)*LOGPI + 2*lgamma(m+2)
def log_cSD(m): return log_cS(m) - log_D(m)

def logabsS_exact(M, x, y):
    x = np.asarray(x, dtype=np.float64); y = np.asarray(y, dtype=np.float64)
    a = loggamma((M + 1 - y/pi) + 1j*(x/pi)).real + loggamma((M + 1 + y/pi) - 1j*(x/pi)).real
    return log_cS(M-1) + 0.5*np.log(x*x + y*y) - 2*M*LOGPI - a

# ---- the bounds, as the statements read ------------------------------------------------
def lower_sharp(m, s):
    """S_real_ge_sharp; returns (log bound, hypothesis holds)."""
    ok = s*s <= pi**2*(m+2)**2/2
    return log_cSD(m) + log(s) + s*s/(pi**2*(m+2)) - s**4/(pi**4*(m+1)**3), ok
def upper_far(m, x, y):
    """norm_S_le_far; returns (log bound, hypothesis holds). x, y arrays or floats."""
    x = np.asarray(x, dtype=np.float64); y = np.asarray(y, dtype=np.float64)
    ok = 2*(x*x + pi**2*(m+1)**2) <= y*y
    logcosh = np.abs(x) + np.log1p(np.exp(-2*np.abs(x))) - log(2)
    return log_cS(m) + logcosh + (m+1)*(log(2) - 2*np.log(np.abs(y))), ok
def upper_N1(m, x, y):
    """NEW lemma N1, with sigma m replaced by its tree bounds."""
    x = np.asarray(x, dtype=np.float64); y = np.asarray(y, dtype=np.float64)
    re2 = x*x - y*y; n2 = x*x + y*y
    sig = np.where(re2 >= 0, 1/(pi**2*(m+1)), 1/(pi**2*(m+2)))
    return log_cSD(m) + 0.5*np.log(n2) + re2*sig + n2*n2/(6*pi**4*(m+1)**3)
def upper_c_neg(m, x, y):
    """the tree's norm_S_le_c_neg; returns (log bound, hypotheses hold)."""
    x = np.asarray(x, dtype=np.float64); y = np.asarray(y, dtype=np.float64)
    re2 = x*x - y*y; n2 = x*x + y*y
    ok = (n2 <= pi**2*(m+2)**2/2) & (re2 <= 0)
    return log_cSD(m) + 0.5*np.log(n2) + re2*(m+2)/(pi**2*(2*m+3)**2) + n2*n2/(pi**4*(m+1)**3), ok

out = {}
print("P1. the new lemma N1 and the tree's bounds against the exact S (log bound minus log exact must be >= 0)")
viol = {'N1': 0, 'far': 0, 'sharp': 0, 'c_neg': 0}; pts = {'N1': 0, 'far': 0, 'sharp': 0, 'c_neg': 0}
slack_N1_min = math.inf
for M in (50, 800, 10**4, 10**6, 10**8):
    m = M - 1
    u = rng.uniform(0.001, 0.5, 4000); t = np.concatenate([rng.uniform(0, 8, 3000), rng.uniform(8, 60, 1000)])
    x = u*M; y = t*M
    ex = logabsS_exact(M, x, y)
    tol = 1e-9*np.maximum(1.0, np.abs(ex)) + 3e-3*(M >= 10**8)      # double-precision floor of the exact form at large M
    d = upper_N1(m, x, y) - ex
    viol['N1'] += int(np.sum(d < -tol)); pts['N1'] += len(d); slack_N1_min = min(slack_N1_min, float(np.min(d + tol)))
    b, ok = upper_far(m, x, y)
    viol['far'] += int(np.sum((b - ex < -tol) & ok)); pts['far'] += int(np.sum(ok))
    b, ok = upper_c_neg(m, x, y)
    viol['c_neg'] += int(np.sum((b - ex < -tol) & ok)); pts['c_neg'] += int(np.sum(ok))
    s = rng.uniform(0.001, 0.5, 2000)*M
    for si in s[:400]:
        lb, ok = lower_sharp(m, float(si))
        e = float(logabsS_exact(M, float(si), 0.0))
        if ok:
            pts['sharp'] += 1; viol['sharp'] += (lb - e > 1e-9*max(1.0, abs(e)) + 3e-3*(M >= 10**8))
for k in viol:
    print(f"   {k:6s}: {pts[k]:6d} points inside its hypotheses, violations {viol[k]}")
    out[f'check_points_{k}'] = pts[k]; out[f'check_violations_{k}'] = int(viol[k])
gate = all(v == 0 for v in viol.values())

print()
print("P2. where each upper bound closes, lam = 1: its exponent per unit h at real part offset 1/2, against the target's at eps (S_real_ge_sharp)")
def rate_target(eps): return 2*(eps**2/pi**2 - eps**4/pi**4)
def rate_N1(ep, tau): return 2*((ep*ep - tau*tau)/pi**2 + (ep*ep + tau*tau)**2/(6*pi**4))
def rate_cneg(ep, tau): return 2*((ep*ep - tau*tau)/(4*pi**2) + (ep*ep + tau*tau)**2/pi**4)
taus = [0.9, 1.2, 1.6, 2.0, 2.2, 3.0, 4.6]
print("   tau      " + "".join(f"{t:>10}" for t in taus))
print("   N1       " + "".join(f"{rate_N1(0.5, t):10.4f}" for t in taus))
print("   c_neg    " + "".join((f"{rate_cneg(0.5, t):10.4f}" if (0.25 + t*t) <= pi**2/2 else f"{'regime':>10}") for t in taus))
print(f"   target   eps = 0.5: {rate_target(0.5):.4f}   eps = 0.1: {rate_target(0.1):.6f}")
# least tau at which the tree's c_neg exponent is positive at offset 1/2
ts = np.linspace(0.9, 2.2, 13001); rc = np.array([rate_cneg(0.5, t) for t in ts])
t_pos = float(ts[np.argmax(rc > 0)])
out['cneg_positive_from_tau'] = round(t_pos, 3)
out['cneg_regime_end_tau'] = round(math.sqrt(pi**2/2 - 0.25), 3)
out['far_regime_from_tau'] = round(math.sqrt(2*(0.25 + pi**2)), 3)
out['N1_rate_at_09'] = round(rate_N1(0.5, 0.9), 4); out['N1_rate_at_46'] = round(rate_N1(0.5, 4.6), 4)
out['N1_negative_until_tau'] = round(math.sqrt(6*pi**2), 2)
print(f"   the tree's c_neg exponent turns positive at tau = {t_pos:.3f} and its regime ends at {out['cneg_regime_end_tau']}; the far bound starts at {out['far_regime_from_tau']};")
print(f"   so off-line zeros at real part offset 1/2 and height distance between those have no closing bound in the tree. N1 is negative up to tau = {out['N1_negative_until_tau']}.")

# ---- the price on these bounds -------------------------------------------------------
def Ncount(T): return math.floor(15*log(T) + 73)
def log_mult(tau, eps, g0, N, h):
    theta0 = pi**3/(8*h); xi = 12*N
    rot = 4*np.log1p((tau + 0.5)*(2*g0 + tau + 1)/(2*eps*g0))
    per = 2*N*(np.log(tau + RC + 0.5) + np.log(tau + RC + 1) - log(eps) + 2*np.log((2*g0 + tau + RC + 1)/(2*g0 - RC)))
    return rot + per + N*(N+1)*log(xi) + 2*N*log(1/theta0)

def sides(h, eps, T, g0):
    M = h; m = h - 1; N = Ncount(T)
    lo, ok1 = lower_sharp(m, eps*h)
    fa, ok2 = upper_far(m, eps*h, 2*g0*h)
    fa = float(fa)
    if not (ok1 and bool(ok2)) or fa >= lo: return None
    target = 2*log(h/2) + 2*(lo + math.log1p(-math.exp(fa - lo)))
    near = log(N) + log(4*h*h) + float(log_mult(RC, eps, g0, N, h))
    k = np.arange(0, KCELLS, dtype=np.float64); tlo, thi = RC + k/2, RC + (k+1)/2
    x = 0.5*h
    n1 = log_cSD(m) + 0.5*np.log(x*x + (thi*h)**2) + (upper_N1(m, x, tlo*h) - log_cSD(m) - 0.5*np.log(x*x + (tlo*h)**2))
    fb, okf = upper_far(m, x, tlo*h)
    use_far = tlo >= TAU_SW
    if not bool(np.all(okf[use_far])): return None
    Sm = np.where(use_far, fb, n1)
    Sp, okp = upper_far(m, x, g0*h)
    if not bool(okp): return None
    cnt = np.log(15*np.log(g0 + thi + 2) + 73)
    cells = log(2) + cnt + 2*log(h/2) + 2*np.logaddexp(Sm, float(Sp)) + log_mult(thi, eps, g0, N, h)
    far = float(np.logaddexp.reduce(cells))
    rhs = log(4) + float(np.logaddexp(near, far))
    return target, rhs, near, far

def h0(eps, T, g0, hmax=10**13):
    def ok(h):
        r = sides(h, eps, T, g0)
        return r is not None and r[0] > r[1]
    lo, hi = 64, 128
    while not ok(hi):
        lo, hi = hi, hi*2
        if hi > hmax: return None
    while hi - lo > 1:
        mid = (lo + hi)//2
        if ok(mid): hi = mid
        else: lo = mid
    return hi

exact = {}
for line in open(sys.argv[1]):
    if line.startswith('price.h0_e'):
        k, v = line.split(); exact[k] = int(v)
print()
print("P3. h0 on proved-form inequalities against unit 0375's exact h0")
print(f"   {'eps':>5} {'T':>6} {'N':>4} {'h0 proved-form':>15} {'h0 exact':>12} {'lost factor':>12} {'binding':>8} {'worst g0':>9} {'closed at 2,10,100 h0':>22}")
rows = []
for eps, et in ((0.5, 'e05'), (0.25, 'e025'), (0.1, 'e01')):
    for T, tt in ((1e3, 'T3'), (1e6, 'T6'), (1e12, 'T12')):
        cand = [(h0(eps, T, g0), g0) for g0 in (14.134725, T)]
        if any(c[0] is None for c in cand):
            print(f"   {eps:5} {T:6.0e}  does not close"); rows.append(None); gate = False; continue
        h, g0 = max(cand)
        t, r, near, far = sides(h, eps, T, g0)
        st = all((lambda q: q is not None and q[0] > q[1])(sides(f*h, eps, T, g0)) for f in (2, 10, 100))
        he = exact[f'price.h0_{et}_{tt}']
        rows.append(dict(eps=eps, T=T, key=f'{et}_{tt}', h0=h, exact=he, lost=h/he, binding='near' if near >= far else 'far', stable=st))
        print(f"   {eps:5} {T:6.0e} {Ncount(T):4d} {h:15d} {he:12d} {h/he:12.4f} {rows[-1]['binding']:>8} {g0:9.4g} {str(st):>22}")
good = [r for r in rows if r]
for r in good:
    out['h0_' + r['key']] = r['h0']; out['lost_' + r['key']] = round(r['lost'], 4)
out['cells'] = len(rows); out['cells_closed'] = len(good)
out['cells_stable_above'] = sum(1 for r in good if r['stable'])
out['cells_near_bound'] = sum(1 for r in good if r['binding'] == 'near')
out['lost_min'] = round(min(r['lost'] for r in good), 4); out['lost_max'] = round(max(r['lost'] for r in good), 4)
out['h0_max'] = max(r['h0'] for r in good); out['L_max'] = 2*out['h0_max']
out['tau_switch'] = TAU_SW; out['rc'] = RC
gate = gate and out['cells_stable_above'] == len(rows)
out['gate_pass'] = 1 if gate else 0
print()
print("GATE (every bound holds against the exact S on the grid; every cell closes and stays closed):", "pass" if gate else "FAIL")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
sys.exit(0 if gate else 1)
