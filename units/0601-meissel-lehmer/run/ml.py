"""Exploratory check of MeisselLehmer.meissel_lehmer at the rows: for x = 2^R and s = cube root,
pi x + 1 + sum_{p in lowP} (pi(x/p) - pi(p-1)) = phi(x, primes <= s) + pi s, and the size of
the phi tree against Legendre's (s = square root)."""
import json, math, sympy, sys
sys.setrecursionlimit(100000)
def phi(x,L):
    if not L or x<=1: return x,1
    a,na=phi(x,L[1:]); b,nb=phi(x//L[0],L[1:]); return a-b,na+nb+1
pi=lambda n:int(sympy.primepi(n))
out={}
for R in (16,20,22,26):
    X=2**R; s=round(X**(1/3))
    while (s+1)**3<=X: s+=1
    while s**3>X: s-=1
    ps=[p for p in range(s,1,-1) if sympy.isprime(p)]
    f,nodes=phi(X,ps)
    low=[p for p in sympy.primerange(s+1,X+1) if p*p<=X]
    lhs=pi(X)+1+sum(pi(X//p)-pi(p-1) for p in low)
    s2=math.isqrt(X); ps2=[p for p in range(s2,1,-1) if sympy.isprime(p)]
    nodes2=phi(X,ps2)[1] if R<=22 else None
    out[f"r{R}"]={"s":s,"holds":lhs==f+pi(s),"phi_nodes":nodes,"legendre_nodes":nodes2,"max_x_over_p":X//low[0] if low else 0}
json.dump(out,open("ml.json","w"),indent=1); print(out)
