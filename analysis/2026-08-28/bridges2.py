"""Remaining bridges from the table's filter.

The filter is W_d(rho) = (1 - b^-rho)^d  (Superposition.lean:90, Chain.lean:29).
For psi it enters the explicit formula EXACTLY, with no approximation:

    Delta^{d+1} psi(b^r) = b^r (1 - 1/b)^{d+1}  -  sum_rho (b^{r rho}/rho) W_{d+1}(rho)

because Delta^{d+1} acting on b^{(r-k)rho} pulls out exactly sum_k C(d+1,k)(-1)^k
b^{-k rho}.  So the four exact zeros of the counting table have a direct
explicit-formula statement: main term == zero sum.

BRIDGE 5 - the four exact zeros {(2,1),(4,1),(8,3),(20,6)}.
BRIDGE 6 - Dirichlet characters: coupling to chi carries chi(b)^k, closed form.
BRIDGE 7 - elliptic curves: a_p replaces Lambda; Hecke recursion gives a_{p^k}.
BRIDGE 8 - twin / 6-lattice: base 6, 30 are the twin-lattice bases and are deaf.
"""
import json, numpy as np
from math import log, pi, comb, sqrt

R = "/Users/juliansambrano/GitHub/Primebeat_081426/"
g = np.array([float(l.split()[0]) for l in open(R+"imported/twin_count/zeros1.txt")])
T = 74920.0; z = g[g <= T]; N = len(z)
rho = 0.5 + 1j*z
ZEROS = [(2,1), (4,1), (8,3), (20,6)]

# ---------- BRIDGE 5 ----------
cache = json.load(open(R+"pi2n_cache.json"))
pi2 = {int(k): int(v) for k, v in (cache.items() if isinstance(cache, dict) else [])}
def cell(r, d):
    """Delta^{d+1} pi(2^.) at r -- the counting table."""
    return sum(comb(d+1, k)*(-1)**k*pi2[r-k] for k in range(d+2))

print("BRIDGE 5 - the four exact zeros, and what the filter says at them")
print("  counting table, confirmed from pi2n_cache.json:")
for (r, d) in ZEROS:
    print(f"    cell({r:2d},{d}) = {cell(r,d)}")

def psi_parts(r, d, b=2.0):
    """main term and zero-sum of Delta^{d+1} psi(b^r); they are equal at a zero."""
    W = (1 - b**(-rho))**(d+1)
    main = b**r * (1 - 1/b)**(d+1)
    zs = 2*np.sum((b**(r*rho)/rho) * W).real     # rho and conj(rho)
    return main, zs

print()
print("  psi-table explicit formula (exact factorization):")
print("     r   d      main term        zero sum      zerosum/main")
for (r, d) in ZEROS:
    m, s = psi_parts(r, d)
    print(f"   {r:3d} {d:3d}   {m:14.2f}  {s:14.2f}   {s/m:11.4f}")
print("   -- non-zero cells for contrast --")
for (r, d) in [(20,5),(20,7),(19,6),(21,6),(12,4),(30,6)]:
    m, s = psi_parts(r, d)
    print(f"   {r:3d} {d:3d}   {m:14.2f}  {s:14.2f}   {s/m:11.4f}")

# ---------- BRIDGE 6 ----------
print()
print("BRIDGE 6 - Dirichlet characters.  chi(b^k)=chi(b)^k gives a closed form:")
print("   coupling(chi) = -(T/2pi) log b [ (1 - chi(b)/b)^d - 1 ]   for prime b")
def chars(q):
    gset = [a for a in range(1, q) if np.gcd(a, q) == 1]
    # find a primitive root
    for gr in gset:
        seen, x = set(), 1
        for _ in range(q-1):
            x = x*gr % q; seen.add(x)
        if len(seen) == len(gset): break
    ind = {}; x = 1
    for e in range(len(gset)):
        x = (gr**e) % q; ind[x] = e
    return gset, ind, len(gset)
for q in (11, 13):
    gset, ind, phi = chars(q)
    print(f"   q={q}:  base 2 has index {ind[2%q]} of {phi}")
    for j in range(phi):
        chi_b = np.exp(2j*pi*j*ind[2 % q]/phi)
        d = 4
        c = -(T/(2*pi))*log(2)*(((1 - chi_b/2)**d) - 1)
        tag = " (principal)" if j == 0 else ""
        print(f"     chi_{j:<2d} chi(2)={chi_b.real:+.3f}{chi_b.imag:+.3f}i   "
              f"|coupling| = {abs(c):9.1f}{tag}")

# ---------- BRIDGE 7 ----------
print()
print("BRIDGE 7 - elliptic curves.  a_{p^k} by Hecke: a_{p^{k+1}} = a_p a_{p^k} - p a_{p^{k-1}}")
ell = json.load(open(R+"results/elliptic_symbol_zeros.json"))
ap = {}
for row in ell["rows"]:
    ap.setdefault(row["curve"], {})[row["p"]] = row["a_p"]
def a_pk(a1, p, kmax):
    a = [1.0, float(a1)]
    for k in range(1, kmax): a.append(a[-1]*a1 - p*a[-2])
    return a
print("   filter response  sum_k C(d,k)(-1)^k a_{b^k} b^{-k},  d=4")
print("     curve   rank    b=2         b=3         b=5")
ranks = {r["curve"]: r["true_rank"] for r in json.load(open(R+"results/bsd_rank_product.json"))["rows"]}
for cv in ell["params"]["curves"]:
    out = []
    for b in (2, 3, 5):
        if b not in ap[cv]: out.append(float('nan')); continue
        a = a_pk(ap[cv][b], b, 4)
        out.append(sum(comb(4,k)*(-1)**k*a[k]*float(b)**(-k) for k in range(5)))
    print(f"   {cv:>7}   {ranks.get(cv,'?')}   " + "".join(f"{v:11.5f} " for v in out))

# ---------- BRIDGE 8 ----------
print()
print("BRIDGE 8 - the twin / 6k+-1 lattice bases, measured (d=4):")
def couple(b, d=4):
    return np.sum((1 - float(b)**(-rho))**d).real - N
for b in (6, 12, 30, 2, 3):
    print(f"   b={b:2d}  coupling {couple(b):+9.1f}"
          + ("   <- twin-lattice base (6k+-1 lives here)" if b in (6,12,30) else ""))
