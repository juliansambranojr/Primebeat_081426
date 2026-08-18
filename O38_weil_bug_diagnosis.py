"""
O38 — DIAGNOSING the buggy Weil-form implementation: take the objects of
      `O38_weil_form_BUGGY.py` verbatim, unmodified, and probe them one property at
      a time until the four defects that broke the explicit formula are visible.

Reads with: O38_weil_form_BUGGY.py — the SUPERSEDED, INCORRECT implementation this
script dissects, kept in the tree only as evidence.  The CORRECT implementation is
O37_weil_form_on_stencil.py (with O37_weil_form_balance.py as its reduced form);
the normalization both rely on is calibrated in O36_weil_calibration.py.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.  This is a diagnostic, not a measurement.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `diag.py`), run
there, and moved into the tree afterwards.  The code logic is unchanged from the
scratch version; only this docstring was added.  Its definitions are deliberate
verbatim copies of the buggy script's — do not "fix" them here, that would destroy
the diagnostic.

WHAT THIS MEASURES
------------------
Five probes, labelled A-E in the output:

    A  functional equation:  H(s) vs H(1-s) at s = 0.3, 0.1, 0.5
    B  reality on the critical line:  |Im H| / |Re H| at t = 3.0, 14.1347
    C  evenness in t:  H(1/2+it) vs H(1/2-it) at t = 5.0
    D  Mellin/FT consistency:  int f(u) e^{iut} du vs H(1/2+it)
    E  evenness of f:  f(u) vs f(-u) at u = log 2, 2 log 2

THE FOUR DEFECTS these probes expose in `O38_weil_form_BUGGY.py`
---------------------------------------------------------------
    (a) The mollifier is centered at s = 0 rather than s = 1/2, which breaks the
        required symmetry H(s) = H(1-s).
    (b) The real-space weights are missing a factor b^(m/2), so f was not even.
    (c) The real-space kernel is a triangle, whose transform is sinc^2, and that is
        inconsistent with the sinc^4 symbol actually used on the spectral side.
    (d) The archimedean term's sign is inverted, and its integral is truncated at
        +/-120 when +/-3000 is needed for convergence.

All four are corrected in O37_weil_form_on_stencil.py.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  b = 2, N = 7,
W = 0.05, mp.dps = 20 and every probe point are written inline.  There is no `--out`
and no results JSON — the console transcript is the entire record.  This is a
deviation from house convention (CONTEXT.md § "Output schema"); an open NOTEPAD
thread already records the same deviation for O30/O31/O32 and this script falls
under it.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O38_weil_bug_diagnosis.py

No flags, no arguments.

REQUIREMENTS
------------
    pip install mpmath
"""
# Diagnose weil3.py's own objects, unmodified definitions copied verbatim.
from mpmath import mp,mpf,mpc,binomial,log,pi,quad,re,im,sinh,exp
mp.dps=20
b,N,W=mpf(2),7,mpf('0.05'); LB=log(b)
COEF={}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j]=COEF.get(k-j,mpf(0))+(-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
def h(s): return (1-b**(-s))**N*(1-b**(s-1))**N
def T(s): return mpf(1) if s==0 else (sinh(W*s)/(W*s))**4
def H(s): return h(s)*T(s)
def Lam(v):
    v=abs(v); return (2*W-v)/(4*W*W) if v<2*W else mpf(0)
def f(u): return sum(cn*Lam(u-n*LB) for n,cn in COEF.items())
print("A. functional equation of weil3's H:")
for s in ('0.3','0.1','0.5'):
    s=mpf(s); print(f"   H({s}) = {mp.nstr(H(s),10):>18}   H({1-s}) = {mp.nstr(H(1-s),10):>18}   ratio {mp.nstr(H(s)/H(1-s),8)}")
print("B. is weil3's H real on the critical line?")
for t in ('3.0','14.1347'):
    v=H(mpc(mpf('0.5'),mpf(t))); print(f"   H(1/2+{t}i) = {mp.nstr(v,10)}   |Im|/|Re| = {mp.nstr(abs(im(v)/re(v)),6)}")
print("C. is weil3's H(1/2+it) even in t?")
for t in ('5.0',):
    print(f"   H(1/2+{t}i)={mp.nstr(H(mpc(mpf('0.5'),mpf(t))),10)}   H(1/2-{t}i)={mp.nstr(H(mpc(mpf('0.5'),-mpf(t))),10)}")
print("D. Mellin/FT check: does int f(u)e^{iut}du equal H(1/2+it)?")
SUP=N*LB+2*W
nodes=sorted(set([-SUP,SUP]+[m*LB+j*W for m in range(-N,N+1) for j in (-2,-1,0,1,2)]))
nodes=[x for x in nodes if -SUP<=x<=SUP]
for t in ('0','1.3','5.0','14.1347'):
    t=mpf(t); q=quad(lambda u: f(u)*exp(mpc(0,1)*u*t),nodes)
    print(f"   t={float(t):>9}   quad {mp.nstr(q,10):>26}   H {mp.nstr(H(mpc(mpf('0.5'),t)),10):>26}")
print("E. f evenness (formula needs f even):")
for u in ('0.693147','1.386294'):
    u=mpf(u); print(f"   f({u})={mp.nstr(f(u),10):>16}   f(-{u})={mp.nstr(f(-u),10):>16}")
