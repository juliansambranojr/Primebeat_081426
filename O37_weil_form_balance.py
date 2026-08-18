"""
O37 (companion) — THE WEIL FORM BALANCE at the converged archimedean cutoff:
      the same corrected construction as O37_weil_form_on_stencil.py, stripped to
      the single balance line, with the archimedean integral carried to |t| < 3000
      plus an analytic tail and the spectral sum given a matching tail estimate.

Reads with: O37_weil_form_on_stencil.py (same h, T, kernel and weights — this file
is its reduced form, and carries the SAME O-number deliberately); tail.py (the
spectral tail estimate, developed separately); archtest.py (the archimedean-cutoff
sweep that fixed 3000 as the working range); O36_weil_calibration.py (normalization);
O21_archimedean_convergence.py (the cutoff's validity window at the O21 scale).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `final.py`), run
there, and moved into the tree afterwards.  The code logic is unchanged from the
scratch version; only this docstring was added.

WHAT THIS MEASURES
------------------
With b = 2, N = 7, W = 0.05, K = 2 fixed, it prints four lines and one difference:

    prime term   2 * sum_n Lambda(n) n^(-1/2) f(log n) over the kernel support
    arch         main part, quadrature on a uniform node set over |t| < 3000,
                 PLUS an analytic tail 2*a0*(3/8)/(W t)^4 * (log(t/2) - log pi)
                 integrated from 3000 to infinity
    ARITHMETIC   H(0) + H(1) - prime + arch
    SPECTRAL     2*Re H(1/2 + i*gamma) over all 600 zeros in `zeros600.json`,
                 plus an estimated tail beyond gamma_600 using the same
                 sinc^4 mean 3/8 and zero density log(t/2pi)/2pi

and finally their absolute and relative difference.  That relative difference is the
whole point of the script: it is how closely the two sides of the explicit formula
balance once both truncations are tail-corrected.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  b = 2, N = 7,
W = 0.05, K = 2, mp.dps = 20, the archimedean cutoff Tc = 3000 and its node spacing
(Tc/1.2 intervals), and both tail formulae are written inline.  There is no `--out`
and no results JSON — the console transcript is the entire record.  This is a
deviation from house convention (CONTEXT.md § "Output schema"); an open NOTEPAD
thread already records the same deviation for O30/O31/O32 and this script falls
under it.

The zero list is read as the bare relative path `zeros600.json`, so the script is
NOT cwd-independent — it must be run from the project root.

Both tails are ESTIMATES from the asymptotic mean of the symbol, not bounds.  They
are not error bars.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O37_weil_form_balance.py

No flags, no arguments.  Run from the project root; reads `zeros600.json`.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import (mp,mpf,mpc,binomial,log,pi,digamma,quad,re,sinh,exp,factorial,inf)
from sympy import primerange
import json
mp.dps = 20
b,N,W,K = mpf(2),7,mpf('0.05'),2 ; LB=log(b); NK=2*K
COEF={}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j]=COEF.get(k-j,mpf(0))+(-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
a0=COEF[0]
def h(s): return (1-b**(-s))**N*(1-b**(s-1))**N
def T(s):
    z=W*(s-mpf('0.5')); return mpf(1) if z==0 else (sinh(z)/z)**(2*K)
def H(s): return h(s)*T(s)
def bspl(x,n):
    if x<=0 or x>=n: return mpf(0)
    return sum((-1)**k*binomial(n,k)*(x-k)**(n-1) for k in range(int(x)+1))/factorial(n-1)
def Kern(v): return bspl(v/(2*W)+NK/mpf(2),NK)/(2*W)
def f(u): return sum(c*b**(mpf(m)/2)*Kern(u-m*LB) for m,c in COEF.items())
SUP=N*LB+NK*W
prime=mpf(0)
for p in primerange(2,int(exp(SUP))+1):
    m=1
    while m*log(p)<=SUP:
        prime+=log(p)*mpf(p)**(-mpf(m)/2)*2*f(m*log(p)); m+=1
def integ(t):
    return re(H(mpc(mpf('0.5'),t)))*(re(digamma(mpf('0.25')+mpc(0,t)/2))-log(pi))
Tc=3000; nn=int(Tc/mpf('1.2')); nodes=[mpf(-Tc)+2*mpf(Tc)*i/nn for i in range(nn+1)]
arch_main=quad(integ,nodes)/(2*pi)
arch_tail=2*quad(lambda t: a0*(mpf(3)/8)/(W*t)**4*(log(t/2)-log(pi)),[Tc,10*Tc,inf])/(2*pi)
arch=arch_main+arch_tail
rhs=H(mpf(0))+H(mpf(1))-prime+arch
Z=[mpf(x) for x in json.load(open("zeros600.json"))]
sp=sum(2*re(H(mpc(mpf('0.5'),g))) for g in Z)
sptail=quad(lambda t:2*a0*(mpf(3)/8)/(W*t)**4*log(t/(2*pi))/(2*pi),[Z[-1],10*Z[-1],inf])
print(f"prime term (2*sum Lambda(n)n^-1/2 f(log n)) = {mp.nstr(prime,14)}")
print(f"arch  main(|t|<3000) {mp.nstr(arch_main,14)}  + tail {mp.nstr(arch_tail,6)}  = {mp.nstr(arch,14)}")
print(f"ARITHMETIC  = H0+H1-prime+arch = {mp.nstr(rhs,14)}")
print(f"SPECTRAL    600 pairs {mp.nstr(sp,14)}  + est tail {mp.nstr(sptail,6)} = {mp.nstr(sp+sptail,14)}")
print(f"difference  {mp.nstr(rhs-(sp+sptail),6)}   relative {mp.nstr((rhs-(sp+sptail))/rhs,6)}")
