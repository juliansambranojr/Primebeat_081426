"""Part B: a planted cluster, on the tree's term. EXPLORATORY; a control, no claim about zeta.

The zero set is the bench's 600 on-line zeros (zeros600.txt, both signs of the
height) plus three PLANTED off-line orbits {rho, conj rho, 1 - rho, 1 - conj rho}:

  target   rho0 = 1/2 + eps0 + i*gamma0
  hurting  rho1 = 1/2 + eps1 + i*(gamma0 + D1), eps1 > eps0, D1 chosen where its
           unmultiplied term is most positive (the lobe sections 9 and 13 die on)
  near     rho2 = rho0 + d2*e^{i*0.7}, d2 small: a member the multiplier keeps

The term at a zero is the tree's -(what(rho - 1/2))^2 (term_eq_neg_sq) with
what = (h/2)(S(w+) + S(w-)) (what_eq, term_eq_sidebands) and the window tuned to
gamma = gamma0, lam = 1, m + 1 = h. S is evaluated in the Gamma closed form that
identity.py checks against S_mul_QS.

The multiplier: p(s) = (s^2 - c)^2 * (s^2 - a1^2)(s^2 - conj(a1)^2), a1 = rho1 - 1/2,
with one real c chosen so that p(s0)^2 * what(s0)^2 is positive real (the
rotator, used twice). The multiplied term at a zero is
-(p(rho - 1/2))^2 (what(rho - 1/2))^2 (identity.py, (2)).

Printed: the form without the multiplier and with it, each as
sum over the orbit-weighted zeros of the real part of the term. Negative means
the form detects.
"""
import json, sys
import mpmath as mp
mp.mp.dps = 60

zeros = [mp.mpf(x) for x in json.load(open(sys.argv[1]))]
h = mp.mpf(800); m = 799; M = m + 1
gamma0 = mp.mpf(500); eps0 = mp.mpf('0.4')
eps1 = mp.mpf('0.42')
d2 = mp.mpf('2e-5')

log_cS = mp.log(2) + (2*m+1)*mp.log(mp.pi) + mp.loggamma(2*m+2) - m*mp.log(4)
def S(w):
    z = w/mp.pi
    return w * mp.exp(log_cS - 2*M*mp.log(mp.pi) - mp.loggamma(M+1+1j*z) - mp.loggamma(M+1-1j*z))
def what(s):
    return (h/2) * (S((s + 1j*gamma0)*h) + S((s - 1j*gamma0)*h))
def term(s, p=None):
    v = what(s)
    if p is not None:
        v = p(s) * v
    return -mp.re(v*v)

s0 = mp.mpc(eps0, gamma0)
# the hurting member: scan D1 for the most positive unmultiplied term
best = None
for k in range(1, 400):
    D = mp.mpf(k)/4000
    t = term(mp.mpc(eps1, gamma0 + D))
    if best is None or t > best[0]:
        best = (t, D)
D1 = best[1]
s1 = mp.mpc(eps1, gamma0 + D1)
s2 = s0 + d2 * mp.exp(1j*mp.mpf('0.7'))

def pA(s):
    return (s*s - s1*s1) * (s*s - mp.conj(s1)**2)
# rotator: r(s) = s^2 - c, arg r(s0) = phi in [pi/4, 3pi/4), 4*phi = -theta mod 2pi
theta = mp.arg(pA(s0)**2 * what(s0)**2)
phi = ((-theta) % (2*mp.pi)) / 4
while phi < mp.pi/4:
    phi += mp.pi/2
X = 2*eps0*gamma0 * mp.cot(phi)
c = eps0**2 - gamma0**2 - X
def p(s):
    return (s*s - c)**2 * pA(s)
resid = mp.arg(p(s0)**2 * what(s0)**2)

def form(pp):
    on = mp.mpf(0)
    for g in zeros:
        on += 2 * term(mp.mpc(0, g), pp)        # rho and conj rho
    t0 = 4 * term(s0, pp); t1 = 4 * term(s1, pp); t2 = 4 * term(s2, pp)
    return on, t0, t1, t2

def sgn(x):
    return 1 if x > 0 else (-1 if x < 0 else 0)
def l10(x):
    return float(mp.log10(abs(x))) if x != 0 else float('-inf')

out = {}
print(f"h = {int(h)}, m = {m}, gamma0 = {mp.nstr(gamma0, 6)}, eps0 = {mp.nstr(eps0, 3)}; hurting member eps1 = {mp.nstr(eps1, 3)}, D1 = {mp.nstr(D1, 5)}; near member at distance {mp.nstr(d2, 3)}")
print(f"distance target-hurting |s0 - s1| = {mp.nstr(abs(s0 - s1), 5)};  rotator phi = {mp.nstr(phi, 6)}, residual phase after rotation {mp.nstr(resid, 3)}")
print()
for name, pp in (("without the multiplier", None), ("with the multiplier", p)):
    on, t0, t1, t2 = form(pp)
    tot = on + t0 + t1 + t2
    print(f"{name}:")
    print(f"   target   sign {sgn(t0):+d}  log10|.| {l10(t0):10.3f}")
    print(f"   hurting  sign {sgn(t1):+d}  log10|.| {l10(t1):10.3f}")
    print(f"   near     sign {sgn(t2):+d}  log10|.| {l10(t2):10.3f}")
    print(f"   on-line  sign {sgn(on):+d}  log10|.| {l10(on):10.3f}   ({len(zeros)} zeros, both signs of the height)")
    print(f"   FORM     sign {sgn(tot):+d}  log10|.| {l10(tot):10.3f}")
    key = 'plain' if pp is None else 'mult'
    out[f'{key}_target_sign'] = sgn(t0); out[f'{key}_hurting_sign'] = sgn(t1)
    out[f'{key}_near_sign'] = sgn(t2); out[f'{key}_online_sign'] = sgn(on)
    out[f'{key}_form_sign'] = sgn(tot)
    out[f'{key}_target_over_online_log10'] = round(l10(t0) - l10(on), 2)
    if pp is None:
        out['plain_hurting_over_target'] = float(mp.nstr(abs(t1)/abs(t0), 4))
    else:
        out['mult_hurting_over_target_log10'] = round(l10(t1) - l10(t0), 1) if t1 != 0 else None
        out['mult_near_over_target'] = float(mp.nstr(t2/t0, 6))
# the price script's bound on |p(s)/p(s0)|^2, checked against the actual ratio at every on-line zero
RC = mp.mpf('0.9'); d1 = abs(s0 - s1); viol = 0; slack_min = None
for g in zeros:
    tau = abs(g - gamma0)
    actual = abs(p(mp.mpc(0, g)))**2 / abs(p(s0))**2
    bound = (1 + (tau + mp.mpf(1)/2)*(2*gamma0 + tau + 1)/(2*eps0*gamma0))**4 \
        * ((tau + RC + mp.mpf(1)/2)*(tau + RC + 1)/(d1*eps0) * ((2*gamma0 + tau + RC + 1)/(2*gamma0 - RC))**2)**2
    viol += (actual > bound)
    sl = mp.log10(bound/actual)
    slack_min = sl if slack_min is None else min(slack_min, sl)
print(f"the multiplier bound of price.py against the actual |p(s)/p(s0)|^2 at the {len(zeros)} on-line zeros: violations {viol}, least slack {mp.nstr(slack_min, 3)} decades")
out['mult_bound_violations'] = int(viol); out['mult_bound_slack_min_decades'] = float(mp.nstr(slack_min, 3))
out['h'] = int(h); out['gamma0'] = float(gamma0); out['eps0'] = float(eps0); out['eps1'] = float(eps1)
out['D1'] = float(D1); out['dist_target_hurting'] = float(mp.nstr(abs(s0 - s1), 4)); out['d_near'] = float(d2)
out['residual_phase'] = float(mp.nstr(abs(resid), 3)); out['zeros'] = len(zeros); out['planted_orbits'] = 3
ok = viol == 0 and out['plain_form_sign'] == 1 and out['mult_form_sign'] == -1 and out['mult_near_sign'] == -1 and out['mult_online_sign'] == 1
out['gate_pass'] = 1 if ok else 0
print()
print("GATE (form positive without, negative with; kept member helps; on-line stays positive):", "pass" if ok else "FAIL")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
