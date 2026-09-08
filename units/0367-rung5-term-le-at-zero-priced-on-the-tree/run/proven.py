"""Price rung 5's whole term on the tree's PROVEN inequalities — log space
so h can reach 10^10 without blowing factorials.  Every bound is stated as
log L, log R; closure is log L > log R.  Regime hypotheses named and checked
at each (h, lam).
"""
import json, math, sys
import mpmath as mp
mp.mp.dps = 30

LP = float(mp.log(mp.pi))    # log pi
L2 = math.log(2.0)
L4 = math.log(4.0)
L10 = math.log(10.0)
LPI2 = 2 * LP                # log(pi^2)
LPI4 = 4 * LP                # log(pi^4)
PI2 = float(mp.pi**2)
PI4 = float(mp.pi**4)

def lgamma(x):  # scipy-free
    return float(mp.log(mp.gamma(x)))

def log_cS(m):
    # cS m = 2 * pi^{2m+1} * (2m+1)! / 4^m
    return L2 + (2*m+1)*LP + lgamma(2*m+2) - m*L4

def log_D(m):
    # D m = pi^{2m+2} * ((m+1)!)^2
    return (2*m+2)*LP + 2*lgamma(m+2)

def log_cS_over_D(m):
    return log_cS(m) - log_D(m)

def log_cosh(x):
    if x > 40: return x - L2
    return float(mp.log(mp.cosh(x)))

def log_target(h, lam, eps, gamma):
    """log of target's proven lower bound = (h/2)^2 * (S_lo - S_far)^2."""
    m = lam*h - 1
    s = eps * h
    s2 = s*s
    # F4 at target
    if s2 > PI2 * (m + 2)**2 / 2: return None, 'target_F4'
    # F5 at target
    if s2*s2 > PI4 * (m + 1)**3: return None, 'target_F5'
    # F2 at w_+ = (eps + 2i gamma) h
    b2 = 4 * gamma*gamma * h*h
    if 2*(s2 + PI2*(m+1)**2) > b2: return None, 'target_F2_far'
    # log S_lo = log(cS/D) + log s + ex
    ex = s2 / (PI2*(m+2)) - s2*s2 / (PI4*(m+1)**3)
    log_S_lo = log_cS_over_D(m) + math.log(s) + ex
    # log S_far = log cS + log cosh(s) + (m+1) log(2/b^2)
    log_S_far = log_cS(m) + log_cosh(s) + (m+1)*math.log(2/b2)
    # need S_lo > S_far
    if log_S_far >= log_S_lo: return None, 'S_far_beats_S_target'
    # L = (h/2)^2 * (S_lo - S_far)^2 = (h/2)^2 * S_lo^2 * (1 - e^{d})^2, d = log_S_far - log_S_lo
    d = log_S_far - log_S_lo  # negative
    log_L = 2*math.log(h/2) + 2*log_S_lo + 2*math.log(1 - math.exp(d))
    return log_L, None

def log_S_member(h, lam, ep, D):
    m = lam*h - 1
    wn2 = (ep*ep + D*D) * h*h
    if wn2 > PI2 * (m + 2)**2 / 2: return None
    rew2 = (ep*ep - D*D) * h*h
    if rew2 >= 0:
        ex = rew2 / (PI2*(m+1)) + wn2*wn2 / (PI4*(m+1)**3)
    else:
        ex = rew2 * (m + 2) / (PI2*(2*m+3)**2) + wn2*wn2 / (PI4*(m+1)**3)
    return log_cS_over_D(m) + 0.5*math.log(wn2) + ex

def log_OLB(h, gamma, m):
    r = max(1.0, 5*(m+1)/h)
    log_cFarM = 2*log_cS(m) + 2*math.log(200/81) - 2*m*math.log(10*(m+1)**2)
    # inner = 4 h^2 + cFarM / h^2
    a = math.log(4) + 2*math.log(h)
    b = log_cFarM - 2*math.log(h)
    log_inner = max(a, b) + math.log(1 + math.exp(-abs(a-b)))
    return math.log(2*88) + 4*math.log(gamma + r + 2) + log_inner + math.log(PI2/6)

def log_RHS(h, lam, eps, T, delta):
    m = lam*h - 1
    bg = log_OLB(h, T, m)
    Nc = 15*math.log(T) + 73
    NT = 15*math.log(T) + 698
    ep_grid = [eps, eps/2, eps/4]
    D_grid = sorted(set([delta, 0.03, 0.1, 0.3, 0.5]))
    D_grid = [d for d in D_grid if delta <= d <= 0.5]
    worst = -1e300
    for ep in ep_grid:
        for D in D_grid:
            v = log_S_member(h, lam, ep, D)
            if v is None: return None, 'member_F4'
            if v > worst: worst = v
    cluster = math.log(Nc) + 2*math.log(h/2) + 2*worst
    worst_far = -1e300
    for ep in ep_grid:
        v = log_S_member(h, lam, ep, 0.5)
        if v is None: return None, 'far_zero'
        if v > worst_far: worst_far = v
    far = math.log(NT) + 2*math.log(h/2) + 2*worst_far
    # log(bg + cluster + far) = max + log(1 + smaller/max)
    mx = max(bg, cluster, far)
    tot = math.exp(bg-mx) + math.exp(cluster-mx) + math.exp(far-mx)
    return mx + math.log(tot), None

def price_cell(eps, T, delta, lam_grid=None, hmax=int(1e12)):
    """Bisect over h at each lam.  lam bounded above by F2_far at target:
    2 pi^2 (m+1)^2 <= 4 gamma^2 h^2 --> lam <= gamma sqrt(2)/pi (approx)."""
    if lam_grid is None:
        lam_max = max(1, int(T * math.sqrt(2) / math.pi))
        lam_grid = sorted(set([1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024,
                               min(lam_max, 2048), min(lam_max, 4096)]))
    best = None
    reasons = {}
    for lam in lam_grid:
        def ok(h):
            L, r1 = log_target(h, lam, eps, T)
            if L is None: return None, r1
            R, r2 = log_RHS(h, lam, eps, T, delta)
            if R is None: return None, r2
            return L > R, None
        # doubling to find first h where ok is True
        lo, hi = 2, 4
        h = None; last_r = None
        while hi <= hmax:
            r, why = ok(hi)
            last_r = why
            if r is True: h = hi; break
            if r is False: lo = hi; hi *= 2; continue
            # r is None: regime failed; F5 tightens with h, no larger h helps at this lam
            reasons.setdefault(why, []).append(lam)
            break
        else:
            reasons.setdefault('hmax_hit', []).append(lam)
        if h is not None:
            # bisect
            l2, h2 = lo, h
            while h2 - l2 > 1:
                mid = (l2 + h2)//2
                r, _ = ok(mid)
                if r is True: h2 = mid
                else: l2 = mid
            cand = (h2, lam)
            if best is None or cand[0] < best[0]:
                best = cand
    return best, reasons

zeros = [mp.mpf(z) for z in json.load(open(sys.argv[1]))]
gamma_500 = float(zeros[499])
gamma_600 = float(zeros[-1])

print(f"target height notes: gamma_500 = {gamma_500:.3f}, gamma_600 = {gamma_600:.3f}")
print(f"F2-far cap on lam: lam <= gamma sqrt(2)/pi, so lam <= {int(1000*math.sqrt(2)/math.pi)}"
      f" at T=1e3 and larger at larger T")
print()

out = {'cells': [], 'closed': 0, 'blocked': 0}
print(f"{'eps':>5} {'T':>7} {'delta':>7} {'h':>12} {'lam':>6} {'L=2h':>13} {'binding':>18}")
for eps in (0.5, 0.25, 0.1):
    for T in (1e3, 1e6, 1e12):
        for delta in (1.0, 0.3, 0.1, 0.03, 0.01):
            best, reasons = price_cell(eps, T, delta)
            if best is None:
                bl = ','.join(reasons.keys())
                print(f"{eps:>5} {T:>7.0e} {delta:>7} {'---':>12} {'---':>6} {'---':>13} {bl:>18}")
                out['blocked'] += 1
                out['cells'].append(dict(eps=eps, T=T, delta=delta, closed=False, blocked_by=bl))
                continue
            h, lam = best
            L = 2*h
            print(f"{eps:>5} {T:>7.0e} {delta:>7} {h:>12d} {lam:>6d} {L:>13d} {'-':>18}")
            out['closed'] += 1
            out['cells'].append(dict(eps=eps, T=T, delta=delta, closed=True, h=h, lam=lam, L=L))

print()
print(f"closed: {out['closed']} / {len(out['cells'])}")

cited = {'cells_total': len(out['cells']), 'cells_closed': out['closed'], 'cells_blocked': out['blocked']}
for r in out['cells']:
    k = f"h_e{str(r['eps']).replace('.','')}_T{int(math.log10(r['T']))}_d{str(r['delta']).replace('.','')}"
    if r['closed']:
        cited[k] = r['h']
        cited[k + '_lam'] = r['lam']
    else:
        cited[k + '_blocked'] = r['blocked_by']
json.dump(cited, open(sys.argv[2], 'w'), indent=1)
