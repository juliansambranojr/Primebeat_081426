"""G(y), the function of the Landau window criterion, measured on the bench. EXPLORATORY.

    G(y) = sum_{n <= y} Lambda(n) (y/n - 1) - y log y + (1 + gamma) y

This is the function Alpoge's archive calls `Deduction.G`
(Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean); its
criterion `Deduction.zeroFree_of_rpow_window` says, for zeta: if for arbitrarily
large Y one has G(y) <= C y^theta on all of [Y, Y^(1+delta)], then zeta has no zero
with real part above theta. Nothing here tests that or the Riemann hypothesis: RH
is verified elsewhere far beyond this range, and a finite computation of G can
neither prove nor refute a statement about arbitrarily large Y. What is measured
is what G looks like, and whether the bench's own zeros reproduce it.

The identity it is checked against (derived for this unit, by the residues of
-zeta'/zeta(s) y^s/(s(s-1)); the double pole at s = 1 is exactly the y log y and
(1 + gamma) y terms of G):

    G(y) = sum_rho y^rho / (rho (1 - rho)) + log(2 pi) - sum_{k>=1} y^(-2k)/(2k(2k+1)).

With every zero on the line, rho(1 - rho) = 1/4 + g^2, so
    G(y) = sqrt(y) * sum_{g>0} 2 cos(g log y)/(1/4 + g^2) + log(2 pi) - (tiny),
and |G(y) - log 2 pi + T(y)| <= K sqrt(y), with T(y) = sum_{k>=1} y^(-2k)/(2k(2k+1)) the
trivial zeros' term and K = sum_rho 1/|rho(1-rho)| = 2 + gamma - log(4 pi). T is under 0.05
at y = 2 and falls like y^-2; the first run of this script left it out of the bound and its
gate failed at n = 2, which is how it got here.

Computed exactly from a sieve to N: Lambda(n) for every n <= N, psi and
A(y) = sum Lambda(n)/n in extended precision, G(n) = n A(n) - psi(n) - n log n + (1+gamma) n
at every integer n (G is continuous and nearly flat between integers).
"""
import json, math, sys
import numpy as np

N = 10**8
EULER = np.longdouble('0.5772156649015328606065120900824024310421')
LOG2PI = math.log(2*math.pi)
K = 2 + float(EULER) - math.log(4*math.pi)

# ---- sieve --------------------------------------------------------------------------
sieve = np.ones(N + 1, dtype=bool); sieve[:2] = False
for p in range(2, int(N**0.5) + 1):
    if sieve[p]:
        sieve[p*p::p] = False
primes = np.nonzero(sieve)[0]
del sieve
lam = np.zeros(N + 1, dtype=np.float64)
logp = np.log(primes.astype(np.float64))
lam[primes] = logp
k = 2
while 2**k <= N:
    lim = int(round(N ** (1.0/k))) + 1
    ps = primes[primes <= lim]
    pk = ps.astype(np.int64) ** k
    ok = pk <= N
    lam[pk[ok]] = np.log(ps[ok].astype(np.float64))
    k += 1
nprimes = int(len(primes)); npp = int(np.count_nonzero(lam))

# ---- G at every integer, in chunks, extended precision ------------------------------
CH = 10**7
psi_c = np.longdouble(0); A_c = np.longdouble(0)
gmax = -np.inf; gmin = np.inf; nmax = nmin = 0; viol = 0; viol_noT = 0
dec = {}            # per decade: (max ratio, min ratio)
G_keep = {}         # G at sample integers for the zero comparison
samples = np.unique(np.round(np.exp(np.linspace(math.log(100), math.log(N), 4000))).astype(np.int64))
# windows of the criterion at delta = 1: [Y, Y^2]
WIN = [(10, 100), (100, 10**4), (1000, 10**6), (10**4, 10**8)]
win = {w: {'r50': -np.inf, 'r45': -np.inf, 'r40': -np.inf} for w in WIN}
for lo in range(1, N + 1, CH):
    hi = min(lo + CH - 1, N)
    n = np.arange(lo, hi + 1, dtype=np.int64)
    l = lam[lo:hi + 1].astype(np.longdouble)
    nl = n.astype(np.longdouble)
    psi = psi_c + np.cumsum(l)
    A = A_c + np.cumsum(l / nl)
    psi_c = psi[-1]; A_c = A[-1]
    G = nl*A - psi - nl*np.log(nl) + (1 + EULER)*nl
    Gd = G.astype(np.float64)
    r = Gd / np.sqrt(n)
    m = n >= 2
    i = int(np.argmax(np.where(m, r, -np.inf))); j = int(np.argmin(np.where(m, r, np.inf)))
    if r[i] > gmax: gmax, nmax = float(r[i]), int(n[i])
    if r[j] < gmin: gmin, nmin = float(r[j]), int(n[j])
    nf = n.astype(np.float64)
    T = np.zeros(len(n))
    for kk in range(1, 40):
        T += nf**(-2.0*kk) / (2*kk*(2*kk+1))
    viol += int(np.count_nonzero(np.abs(Gd[m] - LOG2PI + T[m]) > K*np.sqrt(n[m]) + 1e-9))
    viol_noT += int(np.count_nonzero(np.abs(Gd[m] - LOG2PI) > K*np.sqrt(n[m]) + 1e-9))
    for d in range(2, 9):
        a, b = 10**(d-1), 10**d
        sel = (n > a) & (n <= b)
        if sel.any():
            cur = dec.get(d, (-np.inf, np.inf))
            dec[d] = (max(cur[0], float(r[sel].max())), min(cur[1], float(r[sel].min())))
    for (a, b) in WIN:
        sel = (n >= a) & (n <= b)
        if sel.any():
            w = win[(a, b)]
            w['r50'] = max(w['r50'], float(r[sel].max()))
            w['r45'] = max(w['r45'], float((Gd[sel] / n[sel]**0.45).max()))
            w['r40'] = max(w['r40'], float((Gd[sel] / n[sel]**0.40).max()))
    sel = samples[(samples >= lo) & (samples <= hi)]
    for sidx in sel:
        G_keep[int(sidx)] = float(Gd[sidx - lo])
psiN = float(psi_c)

# ---- against the bench's zeros ------------------------------------------------------
zeros = np.array([float(x) for x in json.load(open(sys.argv[1]))])
wts = 2.0 / (0.25 + zeros**2)
mass600 = float(wts.sum()); tail = K - mass600          # exact remaining mass under RH
ns = np.array(sorted(G_keep)); Gs = np.array([G_keep[int(x)] for x in ns])
Ts = sum(ns.astype(np.float64)**(-2.0*kk) / (2*kk*(2*kk+1)) for kk in range(1, 40))
pred = LOG2PI - Ts + np.sqrt(ns) * (np.cos(np.outer(np.log(ns), zeros)) @ wts)
res = (Gs - pred) / np.sqrt(ns)
res_max = float(np.abs(res).max()); over_tail = int(np.count_nonzero(np.abs(res) > tail + 1e-9))
corr = float(np.corrcoef((Gs - LOG2PI)/np.sqrt(ns), (pred - LOG2PI)/np.sqrt(ns))[0, 1])

print(f"sieve to N = {N:.0e}: {nprimes} primes, {npp} prime powers; psi(N) = {psiN:.6f}, psi(N) - N = {psiN - N:.4f}")
print(f"K = 2 + gamma - log(4 pi) = {K:.7f}: the bound on |G(y) - log 2 pi| / sqrt(y) if every zero is on the line")
print()
print("M1. G(n)/sqrt(n) over every integer 2 <= n <= N")
print(f"   max {gmax:+.6f} at n = {nmax};  min {gmin:+.6f} at n = {nmin}")
print(f"   integers with |G(n) - log 2 pi + T(n)| > K sqrt(n): {viol}   (without the trivial zeros' term T: {viol_noT}, at n = 2)")
for d in sorted(dec):
    print(f"   10^{d-1} < n <= 10^{d}:  max {dec[d][0]:+.6f}  min {dec[d][1]:+.6f}")
print()
print(f"M2. against the bench's {len(zeros)} zeros, at {len(ns)} log-spaced integers from 100 to N")
print(f"   mass of the table sum 2/(1/4 + g^2) = {mass600:.7f} of K = {K:.7f}; the rest, {tail:.7f}, bounds what the zeros above the table can add")
print(f"   max |G - prediction| / sqrt(n) = {res_max:.7f};  samples beyond that bound: {over_tail};  correlation of G with the prediction {corr:.6f}")
print()
print("M3. the criterion's windows at delta = 1, [Y, Y^2]: the least C with G(y) <= C y^theta on the window")
print(f"   {'window':>16} {'theta=0.50':>12} {'theta=0.45':>12} {'theta=0.40':>12}")
for (a, b) in WIN:
    w = win[(a, b)]
    print(f"   [{a:>6}, {b:>9.0e}] {w['r50']:12.5f} {w['r45']:12.5f} {w['r40']:12.5f}")

out = dict(N=N, primes=nprimes, prime_powers=npp, K=round(K, 7), ratio_max=round(gmax, 6), ratio_max_at=nmax,
           ratio_min=round(gmin, 6), ratio_min_at=nmin, bound_violations=viol, bound_violations_without_T=viol_noT, zeros=int(len(zeros)),
           samples=int(len(ns)), mass_table=round(mass600, 7), tail_mass=round(tail, 7),
           residual_max=round(res_max, 7), residual_over_tail=over_tail, correlation=round(corr, 6),
           psi_minus_N=round(psiN - N, 4), windows=len(WIN))
for (a, b) in WIN:
    w = win[(a, b)]; tag = f"Y{a}"
    out[f'C50_{tag}'] = round(w['r50'], 5); out[f'C45_{tag}'] = round(w['r45'], 5); out[f'C40_{tag}'] = round(w['r40'], 5)
ok = viol == 0 and over_tail == 0 and corr > 0.99
out['gate_pass'] = 1 if ok else 0
print()
print("GATE (G within K sqrt(n) of log 2 pi - T everywhere; the zeros reproduce it within the table's tail):", "pass" if ok else "FAIL")
json.dump(out, open(sys.argv[2], 'w'), indent=1)
sys.exit(0 if ok else 1)
