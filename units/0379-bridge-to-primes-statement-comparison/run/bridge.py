"""C, the bridge to primes: the dictionary between the tree's zero side and
zeta23's explicit formula, checked numerically. EXPLORATORY.

The tree (lean_stage3/Stage3/WeilDetect.lean):
    laplace G z = int G(u) e^{-zu} du
    zeroForm G  = sum over nontrivial zeros rho, with multiplicity, of
                  laplace G (-rho) * laplace G (-(1 - rho))

zeta23 (anthropics/formal-math, zeta23/Zeta23/ExplicitFormula.lean, Defs.lean):
    paperFT k z = int k(u) e^{izu} du,   gammaOf rho = (rho - 1/2)/i
    EF_lit: for k in C_c^2,
        sum_rho mult(rho) * paperFT k (gammaOf rho) = literatureRHS k
    literatureRHS k = paperFT k (i/2) + paperFT k (-i/2)
                      - sum_n Lambda(n)/sqrt(n) * (k(log n) + k(-log n))
                      + (1/2pi) int paperFT k (r) * gammaBracket r dr
    gammaBracket r = Re digamma(1/4 + i r/2) - log pi

The dictionary. For a test function G put F(u) = G(u) e^{u/2} and
Fm(u) = F(-u), and k = F * Fm (convolution). Then
    laplace G (-rho)       = int F(u) e^{(rho - 1/2) u} du = paperFT F  (gammaOf rho)
    laplace G (-(1 - rho)) = int F(u) e^{(1/2 - rho) u} du = paperFT Fm (gammaOf rho)
and the product is paperFT k (gammaOf rho). So
    zeroForm G = sum_rho mult * paperFT k (gammaOf rho) = literatureRHS k.
If G is C^1 with compact support (the tree's IsTest), k is C^2 with compact
support, which is what EF_lit asks: the regularity gap closes in the convolution.

Checked here on the tree's own window: G = phiW h gamma m, so F = W h gamma m,
odd, Fm = -F, k = -(F * F). Zero side: the bench's 600 zeros, both signs of the
height. Prime side: every prime power below e^{2h}, the pole terms, and the
archimedean integral. The two sides are computed independently and compared.
"""
import json, sys
import mpmath as mp
mp.mp.dps = 30

zeros = [mp.mpf(x) for x in json.load(open(sys.argv[1]))]
h = mp.mpf(3); m = 6

def run(gam):
    def q(x): return mp.sin(mp.pi*x) * mp.cos(mp.pi*x/2)**(2*m)
    def W(u):
        return q(u/h) * mp.cos(gam*u) if abs(u) <= h else mp.mpf(0)
    def cS(mm): return 2 * mp.pi**(2*mm+1) * mp.factorial(2*mm+1) / mp.mpf(4)**mm
    def S(w):
        pr = mp.mpc(1)
        for j in range(m+1):
            pr *= (w*w + mp.pi**2 * (j+1)**2)
        return cS(m) * mp.sinh(w) / pr
    def what(z):                      # int W e^{zu} du, WeilOddPower.what_eq
        return (h/2) * (S((z + 1j*gam)*h) + S((z - 1j*gam)*h))
    # k = F * Fm, k(u) = int F(t) Fm(u - t) dt = int W(t) W(t - u) dt ... with Fm(v) = W(-v) = -W(v)
    def k(u):
        u = mp.mpf(u)
        lo, hi = max(-h, u - h), min(h, u + h)
        if lo >= hi: return mp.mpf(0)
        pts = [lo + (hi - lo)*i/8 for i in range(9)]
        return mp.quad(lambda t: W(t) * W(-(u - t)), pts)
    def FTk(z):                       # paperFT k z = paperFT F z * paperFT Fm z
        a = what(1j*z)                # int W e^{izu}
        b = what(-1j*z)               # int W(-u) e^{izu} = int W e^{-izu}
        return a*b
    # --- zero side: sum over the table, both signs of gamma (rho = 1/2 + i g: gammaOf rho = g)
    zero_side = mp.mpf(0); last = mp.mpf(0)
    for g in zeros:
        t = FTk(g) + FTk(-g)
        zero_side += t; last = abs(t)
    # the tree's own expression for the same thing: sum of laplace(-rho) laplace(-(1-rho)) = -(what(rho - 1/2))^2
    tree_side = sum(-(what(1j*g))**2 - (what(-1j*g))**2 for g in zeros)
    # --- prime side: literatureRHS k
    pole = FTk(1j/2) + FTk(-1j/2)
    N = int(mp.floor(mp.exp(2*h))) + 1
    lam = {}
    sieve = [True]*(N+1)
    for p in range(2, N+1):
        if sieve[p]:
            for mult in range(p*p, N+1, p): sieve[mult] = False
            pk = p
            while pk <= N:
                lam[pk] = mp.log(p); pk *= p
    prime = mp.mpf(0)
    for n, L in lam.items():
        ln = mp.log(n)
        prime += L/mp.sqrt(n) * (k(ln) + k(-ln))
    def bracket(r): return mp.re(mp.digamma(mp.mpf(1)/4 + 1j*r/2)) - mp.log(mp.pi)
    R = 400
    pts = [mp.mpf(i) for i in range(-R, R+1, 2)]
    arch = mp.quad(lambda r: FTk(r) * bracket(r), pts) / (2*mp.pi)
    rhs = pole - prime + arch
    return dict(zero_side=zero_side, tree_side=tree_side, rhs=rhs, pole=pole, prime=prime, arch=arch,
                last=last, nprime=len(lam), kimag=abs(mp.im(zero_side)))

out = {}
print(f"window: h = {int(h)}, m = {m}; zeros: {len(zeros)}, both signs of the height; prime powers below e^(2h)")
worst = mp.mpf(0); worst_tree = mp.mpf(0)
for i, gam in enumerate((mp.mpf('2.5'), mp.mpf('14.134725'), mp.mpf('21.022040'))):
    r = run(gam)
    zs, rhs = mp.re(r['zero_side']), mp.re(r['rhs'])
    rel = abs(zs - rhs)/abs(zs)
    rel_tree = abs(mp.re(r['tree_side']) - zs)/abs(zs)
    worst = max(worst, rel); worst_tree = max(worst_tree, rel_tree)
    print(f"gamma = {mp.nstr(gam, 8)}")
    print(f"   zero side, zeta23's form  sum mult*paperFT k(gammaOf rho) = {mp.nstr(zs, 15)}")
    print(f"   zero side, the tree's form  sum of -(what(rho - 1/2))^2    = {mp.nstr(mp.re(r['tree_side']), 15)}   relative difference {mp.nstr(rel_tree, 3)}")
    print(f"   prime side, literatureRHS k                                = {mp.nstr(rhs, 15)}")
    print(f"       pole {mp.nstr(mp.re(r['pole']), 10)}   prime sum {mp.nstr(mp.re(r['prime']), 10)} ({r['nprime']} prime powers)   archimedean {mp.nstr(mp.re(r['arch']), 10)}")
    print(f"   relative difference of the two sides {mp.nstr(rel, 3)};  last zero's term {mp.nstr(r['last'], 3)}")
    out[f'rel_diff_{i}'] = float(mp.nstr(rel, 3)); out[f'zero_side_{i}'] = float(mp.nstr(zs, 10)); out[f'rhs_{i}'] = float(mp.nstr(rhs, 10))
    out['prime_powers'] = r['nprime']
out['rel_diff_max'] = float(mp.nstr(worst, 3)); out['rel_diff_tree_max'] = float(mp.nstr(worst_tree, 3))
out['windows'] = 3; out['zeros'] = len(zeros); out['h'] = int(h); out['m'] = m
ok = worst < mp.mpf('1e-9') and worst_tree < mp.mpf('1e-20')
out['gate_pass'] = 1 if ok else 0
print()
print("GATE (the two sides agree to 1e-9; the tree's form and zeta23's form of the zero side agree):", "pass" if ok else "FAIL")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
sys.exit(0 if ok else 1)
