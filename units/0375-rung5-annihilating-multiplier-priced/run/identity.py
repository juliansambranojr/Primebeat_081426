"""Part A: the multiplier identity, on the tree's objects. EXPLORATORY.

The tree's window is W h gamma m u = q m (u/h) * cos(gamma u) on [-h, h]
(WeilOddPower.W), q m x = sin(pi x) * cos(pi x/2)^(2m) (WeilOddPower.q), and
the test function is phiW = indicator * W * exp(-u/2)
(WeilPowerBackground.phiW). The term of the zero form at rho is
-(what(rho - 1/2))^2 (WeilPowerBackground.term_eq_neg_sq), with
what z = int_{-h}^{h} W(u) e^{zu} du = (h/2)(S(w+) + S(w-))
(WeilOddPower.what_eq) and S m w * QS m w = cS m * sinh w
(WeilOddPower.S_mul_QS).

Claim checked here, numerically, at small parameters. Let p be an even
polynomial with real coefficients, deg p <= 2m - 1, D = d/du, and

    G_p(u) = indicator_{[-h,h]}(u) * (p(D) W)(u) * exp(-u/2).

Then with s = rho - 1/2:

    (1) int_{-h}^{h} (p(D)W)(u) e^{su} du = p(-s) * what(s) = p(s) * what(s)
    (2) laplace G_p (-rho) * laplace G_p (-(1 - rho)) = -(p(s))^2 * (what(s))^2
    (3) on the line, s = it: p(it) is real, so the term stays >= 0
    (4) D^k W vanishes at u = +-h for k <= 2m (q has a zero of order 2m+1
        at x = +-1), which is what makes the boundary terms of (1) vanish
        and p(D)W glue C^1 across the cut when deg p <= 2m - 1
    (5) the closed form used by the price script:
        S m w = cS m * w / (pi^(2M) Gamma(M+1+iw/pi) Gamma(M+1-iw/pi)), M = m+1
        (from QS = pi^(2M) Gamma(M+1+iz)Gamma(M+1-iz)/(Gamma(1+iz)Gamma(1-iz)),
        z = w/pi, and Gamma(1+iz)Gamma(1-iz) = w/sinh w)

Nothing here is a statement about zeta; s is an arbitrary complex point.
"""
import json, sys
import mpmath as mp
mp.mp.dps = 40

h, gam, m = mp.mpf(3), mp.mpf('2.5'), 6

def q(x):
    return mp.sin(mp.pi*x) * mp.cos(mp.pi*x/2)**(2*m)
def W(u):
    return q(u/h) * mp.cos(gam*u)
def cS(m):
    return 2 * mp.pi**(2*m+1) * mp.factorial(2*m+1) / mp.mpf(4)**m
def QS(m, w):
    pr = mp.mpc(1)
    for j in range(m+1):
        pr *= (w*w + mp.pi**2 * (j+1)**2)
    return pr
def S_prod(m, w):
    return cS(m) * mp.sinh(w) / QS(m, w)
def S_gamma(m, w):
    M = m + 1
    z = w/mp.pi
    return cS(m) * w / (mp.pi**(2*M) * mp.gamma(M+1+1j*z) * mp.gamma(M+1-1j*z))
def what_closed(z):
    return (h/2) * (S_prod(m, (z + 1j*gam)*h) + S_prod(m, (z - 1j*gam)*h))

# the multiplier: one annihilated orbit {+-a, +-conj a} and one rotator (s^2 - c)
a = mp.mpc('0.3', '2.9')
c = mp.mpf('-5')
def p(s):
    return (s*s - a*a) * (s*s - mp.conj(a)**2) * (s*s - c)
# coefficients of p in powers of D: expand numerically from values (degree 6, even)
# p(s) = c6 s^6 + c4 s^4 + c2 s^2 + c0, real coefficients
A2 = (a*a + mp.conj(a)**2).real        # a^2 + conj(a)^2, real
P2 = (abs(a)**4)                        # a^2 conj(a)^2 = |a|^4, real
c6, c4, c2, c0 = mp.mpf(1), -(A2 + c), (P2 + c*A2), -c*P2
deg = 6

def DkW(k, u):
    return mp.diff(W, u, k) if k else W(u)
def pDW(u):
    return c6*DkW(6, u) + c4*DkW(4, u) + c2*DkW(2, u) + c0*W(u)

def integ(f):
    pts = [(-h) + (2*h)*i/12 for i in range(13)]
    return mp.quad(f, pts)

out = {}
S_points = [mp.mpc('0.3', '0.7'), mp.mpc('0.45', '-2.4'), mp.mpc('0.1', '2.55'), mp.mpc('0', '2.2')]
err1 = err2 = err5 = mp.mpf(0)
print("A1. int (p(D)W) e^{su} du  against  p(s) * what(s)")
for s in S_points:
    lhs = integ(lambda u: pDW(u) * mp.exp(s*u))
    wq = integ(lambda u: W(u) * mp.exp(s*u))
    rhs = p(s) * wq
    e = abs(lhs - rhs)/abs(rhs)
    err1 = max(err1, e)
    e_closed = abs(wq - what_closed(s))/abs(wq)
    err5 = max(err5, e_closed)
    # (2): the product of the two laplace transforms of G_p
    rho = s + mp.mpf(1)/2
    L1 = integ(lambda u: pDW(u) * mp.exp(-u/2) * mp.exp(rho*u))
    L2 = integ(lambda u: pDW(u) * mp.exp(-u/2) * mp.exp((1-rho)*u))
    prod = L1*L2
    want = -(p(s)**2) * wq**2
    e2 = abs(prod - want)/abs(want)
    err2 = max(err2, e2)
    print(f"   s = {mp.nstr(s, 4):>18}  rel err (1) {mp.nstr(e, 3):>9}   (2) {mp.nstr(e2, 3):>9}   what vs closed form {mp.nstr(e_closed, 3):>9}")
out['rel_err_identity_max'] = float(mp.nstr(err1, 3))
out['rel_err_term_max'] = float(mp.nstr(err2, 3))
out['rel_err_what_closed_max'] = float(mp.nstr(err5, 3))

print()
print("A3. p(it) on the line: imaginary part")
im_max = max(abs(mp.im(p(1j*t))) for t in [mp.mpf(x)/4 for x in range(-40, 41)])
print(f"   max |Im p(it)| over t in [-10, 10]: {mp.nstr(im_max, 3)}")
out['im_p_on_line_max'] = float(im_max)

print()
print("A4. boundary: max over k <= deg + 1 of |D^k W(+-h)|, against max |D^k W| inside")
bmax = mp.mpf(0); imax = mp.mpf(0)
for k in range(deg + 2):
    for u in (h, -h):
        bmax = max(bmax, abs(mp.diff(W, u, k, direction=(-1 if u > 0 else 1))) if k else abs(W(u)))
    imax = max(imax, max(abs(DkW(k, mp.mpf(x)/10)) for x in range(-25, 26)))
print(f"   boundary max {mp.nstr(bmax, 3)}   interior max {mp.nstr(imax, 3)}   order of the zero of q at +-1: {2*m+1}, deg p + 1 = {deg+1}")
out['boundary_max'] = float(mp.nstr(bmax, 3))
out['zero_order_q'] = 2*m + 1
out['deg_p'] = deg

print()
print("A5. the Gamma closed form of S against the product form (S_mul_QS)")
eg = mp.mpf(0)
for mm, w in [(6, mp.mpc('0.9', '7.5')), (40, mp.mpc('12', '3')), (200, mp.mpc('80', '-40')), (200, mp.mpc('0', '700')), (800, mp.mpc('320', '18'))]:
    e = abs(S_gamma(mm, w) - S_prod(mm, w))/abs(S_prod(mm, w))
    eg = max(eg, e)
    print(f"   m = {mm:4d}  w = {mp.nstr(w, 5):>16}  rel err {mp.nstr(e, 3)}")
out['rel_err_gamma_form_max'] = float(mp.nstr(eg, 3))
out['points'] = len(S_points)
out['m_small'] = m

ok = err1 < mp.mpf('1e-15') and err2 < mp.mpf('1e-15') and eg < mp.mpf('1e-25') and im_max == 0
out['gate_pass'] = 1 if ok else 0
print()
print("GATE", "pass" if ok else "FAIL")
json.dump(out, open(sys.argv[1], 'w'), indent=1)
sys.exit(0 if ok else 1)
