"""The kept members' sign under the annihilating multiplier. EXPLORATORY.

Section 16 of lean_stage3/design/rung5.md, theorem line T9, open item (b).
Setting, from unit 0375: target s0 = eps0 + i*g0, window tuned to g0, lam = 1,
m + 1 = h = M; ladder theta_i = theta_0 * xi^(-i), theta_0 = pi^3/(8h), xi = 12N;
i* the first empty annulus; members with |s0 - a| > theta_{i*} are annihilated,
members with |s0 - a| <= theta_{i*}/xi are kept;

    p(s) = (s^2 - c)^2 * prod_{k in A} (s^2 - a_k^2)(s^2 - conj(a_k)^2),

and the rotator c makes p(s0)^2 what(s0)^2 positive real. A kept member at
a = s0 + delta has term -Re(p(a)^2 what(a)^2) (unit 0375, identity.py), so it has
the target's sign exactly when the phase

    Phi = arg( p(a)^2 what(a)^2 / (p(s0)^2 what(s0)^2) )

lies in (-pi/2, pi/2). With a_k = s0 + delta_k:

    Phi = 2 * [ sum_k arg(1 - delta/delta_k)                 annihilated zero itself
              + sum_k arg(1 + delta/(s0 + conj a_k))         its mirror, at distance >= eps
              + sum_k arg(1 + delta/(s0 + a_k))              the two far points, at
              + sum_k arg(1 + delta/(s0 - conj a_k))         distance about 2*g0
              + 2 arg(1 + delta(2 s0 + delta)/(s0^2 - c)) ]  rotator, |s0^2 - c| >= 2 eps0 g0
          + 2 * arg( what(s0 + delta)/what(s0) )             the window's own transform

Parts:
  A  the bound on each piece and their sum, at the nine cells of unit 0375
  B  the worst case computed exactly (mpmath) at each cell: every other member
     annihilated at the least allowed distance, in the worst direction
  C  random ladder configurations at each cell
  D  planted ladders on the tree's term at small scale, the actual p with its
     rotator and the actual what: the sign of every kept term, counted
  E  the ladder ratio at which the sign can flip, and a planted flip below it
     (the check can fail)
"""
import json, math, sys
import numpy as np
import mpmath as mp
from math import pi, asin, log

mp.mp.dps = 60
rng = np.random.default_rng(20260828)
RC = 0.9
HALF_PI = pi/2

# cells and h0 from unit 0375's values.tsv
vals = {}
for line in open(sys.argv[1]):
    if line.startswith('price.'):
        k, v = line.rstrip('\n').split('\t')
        vals[k] = v
cells = []
for eps, et in ((0.5, 'e05'), (0.25, 'e025'), (0.1, 'e01')):
    for T, tt in ((1e3, 'T3'), (1e6, 'T6'), (1e12, 'T12')):
        cells.append(dict(eps=eps, T=T, N=int(vals[f'price.N_{tt}']), h=int(vals[f'price.h0_{et}_{tt}']), key=f'{et}_{tt}'))

def L_logderiv(M, w):
    """d/dw log S (M-1) w, from the Gamma closed form."""
    z = 1j*w/mp.pi
    return 1/w - (1j/mp.pi)*(mp.digamma(M+1+z) - mp.digamma(M+1-z))
def logS(M, w):
    z = 1j*w/mp.pi
    return mp.log(w) - mp.loggamma(M+1+z) - mp.loggamma(M+1-z)

def pieces(eps, N, h, g0):
    xi = 12*N; theta0 = pi**3/(8*h); d = theta0/xi          # the largest kept distance
    ann = 2*N*asin(1/xi)
    mirror = 2*N*asin(d/eps)
    large = 4*N*asin(d/(2*g0 - RC))
    rot = 4*asin(d*(2*g0 + 1 + d)/(2*eps*g0))
    w0 = mp.mpf(eps)*h
    Lmax = max(abs(L_logderiv(h, w0 + d*h*mp.exp(1j*mp.pi*k/8))) for k in range(16))
    what = 2*float(Lmax)*d*h
    return dict(ann=ann, mirror=mirror, large=large, rot=rot, what=what, total=ann+mirror+large+rot+what, d=d, xi=xi, theta0=theta0)

out = {}
print("A. the phase budget of a kept member, piece by piece (radians), at unit 0375's cells; pi/2 = %.4f" % HALF_PI)
print(f"   {'eps':>5} {'T':>6} {'N':>4} {'h0':>11} {'annihilated':>12} {'mirror':>10} {'far pts':>10} {'rotator':>10} {'what':>10} {'total':>8} {'pi/2 over total':>15}")
worstA = 0.0
for c in cells:
    best = None
    for g0 in (14.134725, c['T']):
        pc = pieces(c['eps'], c['N'], c['h'], g0)
        if best is None or pc['total'] > best['total']:
            best = pc; best['g0'] = g0
    c['bound'] = best
    worstA = max(worstA, best['total'])
    print(f"   {c['eps']:5} {c['T']:6.0e} {c['N']:4d} {c['h']:11d} {best['ann']:12.6f} {best['mirror']:10.2e} {best['large']:10.2e} {best['rot']:10.2e} {best['what']:10.2e} {best['total']:8.5f} {HALF_PI/best['total']:15.2f}")
out['bound_total_max'] = round(worstA, 5)
out['bound_margin_min'] = round(HALF_PI/worstA, 2)
out['bound_ann_max'] = round(max(c['bound']['ann'] for c in cells), 5)
out['bound_rest_max'] = float('%.2e' % max(c['bound']['total'] - c['bound']['ann'] for c in cells))

print()
print("B. the worst case, exact: N-1 members annihilated at the least allowed distance theta_0, all in the worst direction; the kept member at theta_0/xi")
worstB = 0.0; over = 0
for c in cells:
    eps, N, h = c['eps'], c['N'], c['h']
    xi = 12*N; theta0 = mp.pi**3/(8*h); d = theta0/xi
    phimax = mp.mpf(0)
    for g0 in (mp.mpf('14.134725'), mp.mpf(c['T'])):
        s0 = mp.mpc(eps, g0)
        w0 = mp.mpf(eps)*h
        lS0 = logS(h, w0)
        for X in (-2*eps*g0, 0, 2*eps*g0):
            r0 = mp.mpc(X, 2*eps*g0)                     # s0^2 - c
            for ia in range(0, 72):
                alpha = 2*mp.pi*ia/72
                delta = d*mp.exp(1j*alpha)
                for sgn in (1, -1):
                    # annihilated offset: |delta_k| = theta0 (1 + 1e-12), direction making arg(1 - delta/delta_k) extreme
                    psi = sgn*mp.acos(mp.mpf(1)/xi)
                    dk = theta0*(1 + mp.mpf('1e-12'))*mp.exp(1j*(alpha - psi))
                    ak = s0 + dk
                    one = mp.arg(1 - delta/dk) + mp.arg(1 + delta/(s0 + mp.conj(ak))) \
                        + mp.arg(1 + delta/(s0 + ak)) + mp.arg(1 + delta/(s0 - mp.conj(ak)))
                    phi_p = 2*((N-1)*one + 2*mp.arg(1 + delta*(2*s0 + delta)/r0))
                    phi_w = 2*mp.im(logS(h, w0 + delta*h) - lS0)
                    phimax = max(phimax, abs(phi_p + phi_w))
    c['exact'] = float(phimax)
    worstB = max(worstB, c['exact']); over += (c['exact'] > c['bound']['total'])
    print(f"   eps={c['eps']:<5} T={c['T']:<7.0e} exact worst |Phi| = {c['exact']:.6f}   bound {c['bound']['total']:.6f}   exact/bound {c['exact']/c['bound']['total']:.4f}")
out['exact_worst_max'] = round(worstB, 5)
out['exact_over_bound'] = int(over)
out['exact_margin_min'] = round(HALF_PI/worstB, 2)

print()
NRAND = 20000
print(f"C. random ladders: {NRAND} configurations per cell; the annihilated sum exact, the other pieces at their bounds")
worstC = 0.0; flips = 0; total_cfg = 0
for c in cells:
    N = c['N']; xi = 12*N; lxi = log(xi); ltheta0 = log(c['bound']['theta0'])
    rest = c['bound']['total'] - c['bound']['ann']
    mx = 0.0
    for _ in range(NRAND // 200):
        nA = rng.integers(1, N, size=200)
        istar = rng.integers(0, 40, size=200)
        for a_n, i_s in zip(nA, istar):
            lth = ltheta0 - i_s*lxi                                   # log theta_{i*}
            # annihilated log radii: a third at the least distance, the rest log-uniform up to RC
            lr = np.where(rng.random(a_n) < 1/3, lth + 1e-12, rng.uniform(lth, log(RC), a_n))
            phk = rng.uniform(0, 2*pi, a_n)
            # half the time, align the near ones in one direction
            if rng.random() < 0.5:
                phk = np.where(lr < lth + 1e-6, phk[0], phk)
            lrj = lth - lxi - rng.uniform(0, 7)                       # kept: <= theta_{i*}/xi
            phj = rng.uniform(0, 2*pi)
            z = np.exp(lrj - lr) * np.exp(1j*(phj - phk))
            phi = 2*abs(np.sum(np.angle(1 - z))) + rest
            mx = max(mx, phi); flips += (phi >= HALF_PI); total_cfg += 1
    worstC = max(worstC, mx)
    print(f"   eps={c['eps']:<5} T={c['T']:<7.0e} max |Phi| over the sample {mx:.6f}")
out['random_configs'] = total_cfg; out['random_flips'] = int(flips); out['random_worst_max'] = round(worstC, 5)

print()
print("D. planted ladders on the tree's term, h = 800, m = 799, target eps0 = 0.4 at g0 = 500: the actual p (rotator included) and the actual what")
mp.mp.dps = 150
hD = mp.mpf(800); MD = 800; g0D = mp.mpf(500); e0D = mp.mpf('0.4'); s0D = mp.mpc(e0D, g0D)
log_cS = mp.log(2) + (2*(MD-1)+1)*mp.log(mp.pi) + mp.loggamma(2*(MD-1)+2) - (MD-1)*mp.log(4)
def S_D(w):
    z = w/mp.pi
    return w*mp.exp(log_cS - 2*MD*mp.log(mp.pi) - mp.loggamma(MD+1+1j*z) - mp.loggamma(MD+1-1j*z))
def what_D(s):
    return (hD/2)*(S_D((s + 1j*g0D)*hD) + S_D((s - 1j*g0D)*hD))

def run_ladder(n, xi, adversarial):
    """n members; returns (list of kept phases, kept count, wrong-sign count)."""
    theta0 = mp.pi**3/(8*hD)
    if adversarial:
        istar = 0
    else:
        istar = int(rng.integers(0, n))
    th = theta0/mp.mpf(xi)**istar
    nk = 1 if adversarial else int(rng.integers(1, max(2, n - istar)))
    nA = n - nk
    ann = []
    # annuli 0..istar-1 each hold one annihilated member; the rest go anywhere beyond theta_{i*}
    for i in range(min(istar, nA)):
        r = theta0/mp.mpf(xi)**i * mp.mpf(str(rng.uniform(0.2, 1.0))) if xi*0.2 > 1 else theta0/mp.mpf(xi)**i
        r = max(r, theta0/mp.mpf(xi)**(i+1)*(1 + mp.mpf('1e-9')))
        ann.append(r*mp.exp(1j*mp.mpf(str(rng.uniform(0, 2*pi)))))
    if len(ann) < istar:
        return None                      # not enough members to fill the annuli above i*: resample
    alpha = mp.mpf(str(rng.uniform(0, 2*pi)))
    while len(ann) < nA:
        if adversarial:
            psi = mp.acos(mp.mpf(1)/xi)
            ann.append(th*(1 + mp.mpf('1e-12'))*mp.exp(1j*(alpha - psi)))
        else:
            r = mp.exp(mp.mpf(str(rng.uniform(float(mp.log(th)) + 1e-9, math.log(0.05)))))
            ann.append(r*mp.exp(1j*mp.mpf(str(rng.uniform(0, 2*pi)))))
    kept = []
    for q in range(nk):
        r = th/xi * (1 if adversarial else mp.mpf(10)**(-mp.mpf(str(rng.uniform(0, 4)))))
        ang = alpha if adversarial else mp.mpf(str(rng.uniform(0, 2*pi)))
        kept.append(r*mp.exp(1j*ang))
    aA = [s0D + dlt for dlt in ann]
    def pA(s):
        v = mp.mpc(1)
        for a in aA:
            v *= (s*s - a*a)*(s*s - mp.conj(a)**2)
        return v
    theta = mp.arg(pA(s0D)**2 * what_D(s0D)**2)
    phi = ((-theta) % (2*mp.pi))/4
    while phi < mp.pi/4:
        phi += mp.pi/2
    cc = e0D**2 - g0D**2 - 2*e0D*g0D*mp.cot(phi)
    def p(s):
        return (s*s - cc)**2 * pA(s)
    tgt = p(s0D)**2 * what_D(s0D)**2
    assert abs(mp.arg(tgt)) < mp.mpf('1e-100') and mp.re(tgt) > 0
    phases = []; wrong = 0
    for dlt in kept:
        a = s0D + dlt
        v = p(a)**2 * what_D(a)**2
        phases.append(float(abs(mp.arg(v))))
        wrong += (mp.re(v) <= 0)         # term = -Re(v): wrong sign when Re(v) <= 0
    return phases, nk, wrong

trials = 0; kept_total = 0; wrong_total = 0; ph_max = 0.0
while trials < 300:
    n = int(rng.integers(2, 9))
    r = run_ladder(n, 12*n, adversarial=False)
    if r is None: continue
    trials += 1; kept_total += r[1]; wrong_total += r[2]; ph_max = max(ph_max, max(r[0]))
print(f"   random: {trials} ladders, 2 to 8 members, ratio 12n: {kept_total} kept members, wrong sign {wrong_total}, largest |Phi| {ph_max:.6f}")
out['planted_trials'] = trials; out['planted_kept'] = kept_total; out['planted_wrong_sign'] = int(wrong_total); out['planted_phase_max'] = round(ph_max, 5)
adv = []
for n in range(2, 9):
    r = run_ladder(n, 12*n, adversarial=True)
    adv.append((n, r[0][0], 2*(n-1)*asin(1/(12*n)), r[2]))
    print(f"   adversarial, n = {n}: |Phi| = {r[0][0]:.6f}   annihilated piece alone 2(n-1) asin(1/(12n)) = {adv[-1][2]:.6f}   wrong sign {r[2]}")
out['planted_adv_wrong_sign'] = int(sum(a[3] for a in adv))
out['planted_adv_phase_max'] = round(max(a[1] for a in adv), 5)
out['planted_adv_over_ann_max'] = round(max(a[1] - a[2] for a in adv), 4)   # the what piece, larger at small N: d*h = pi^3/(8 xi)

print()
print("E. where the sign flips: the ladder ratio xi at which the worst-case phase reaches pi/2")
for c in cells:
    N = c['N']; rest = c['bound']['total'] - c['bound']['ann']
    xi_flip = 1/math.sin((HALF_PI - rest)/(2*N))
    c['xi_flip'] = xi_flip
    print(f"   eps={c['eps']:<5} T={c['T']:<7.0e} N = {N}: flips at xi = {xi_flip:.2f} = {xi_flip/N:.4f} N   (the block uses 12 N)")
out['xi_flip_over_N_min'] = round(min(c['xi_flip']/c['N'] for c in cells), 4)
out['xi_flip_over_N_max'] = round(max(c['xi_flip']/c['N'] for c in cells), 4)
out['xi_over_flip'] = round(12/max(c['xi_flip']/c['N'] for c in cells), 2)
# the check can fail: n = 8 members; 2(n-1) asin(1/xi) = pi/2 at xi = 8.93, so ratio 6 flips and ratio 12 holds
n = 8
flip = run_ladder(n, 6, adversarial=True)
hold = run_ladder(n, 12, adversarial=True)
print(f"   planted, n = {n}, adversarial: ratio 6 -> |Phi| = {flip[0][0]:.4f}, wrong sign {flip[2]};   ratio 12 -> |Phi| = {hold[0][0]:.4f}, wrong sign {hold[2]}")
out['flip_n'] = n; out['flip_threshold_n8'] = round(1/math.sin(HALF_PI/(2*(n-1))), 2); out['flip_ratio'] = 6; out['flip_phase'] = round(flip[0][0], 4); out['flip_wrong_sign'] = int(flip[2])
out['hold_ratio'] = 12; out['hold_phase'] = round(hold[0][0], 4); out['hold_wrong_sign'] = int(hold[2])
# what a smaller ratio would save in unit 0375's ladder term
N6 = [c for c in cells if c['T'] == 1e6][0]['N']
out['ladder_saving_at_2N'] = round(1 - log(2*N6)/log(12*N6), 3)
print(f"   at ratio 2N the ladder term N(N+1) log(xi) is smaller by {out['ladder_saving_at_2N']:.3f} of itself at T = 1e6 (not re-priced)")

out['cells'] = len(cells); out['half_pi'] = round(HALF_PI, 4)
ok = (over == 0 and flips == 0 and wrong_total == 0 and out['planted_adv_wrong_sign'] == 0
      and worstA < HALF_PI and flip[2] >= 1 and hold[2] == 0)
out['gate_pass'] = 1 if ok else 0
print()
print("GATE (bound holds, no flip in any sample, the planted flip fires below the threshold):", "pass" if ok else "FAIL")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
sys.exit(0 if ok else 1)
