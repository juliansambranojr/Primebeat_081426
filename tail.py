"""
tail.py — SPECTRAL TAIL estimate for the Weil-form balance: sum 2*Re H(1/2+i*gamma)
      over all 600 zeros in `zeros600.json`, then estimate analytically what the
      zeros beyond gamma_600 would contribute.

Supporting script, not an O-numbered test.  Reads with O37_weil_form_balance.py,
which folds this estimate into its balance line, and O37_weil_form_on_stencil.py,
whose h and T it copies.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree, run there, and
moved into the tree afterwards under its original name.  The code logic is unchanged
from the scratch version; only this docstring was added.

WHAT THIS MEASURES
------------------
Prints gamma_600, the 600-pair zero sum, the estimated tail beyond it, and their
total.  The tail uses the asymptotic mean of the symbol — a0 for h, 3/8 for sinc^4,
zero density log(t/2pi)/2pi — integrated from gamma_600 to infinity.  It is an
ESTIMATE, not a bound; it is not an error bar.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
No CLI flags.  b = 2, N = 7, W = 0.05, K = 2 and mp.dps = 20 are inline; there is no
`--out` and no results JSON.  Deviation from house convention (CONTEXT.md § "Output
schema"); an open NOTEPAD thread already records the same deviation for O30/O31/O32.
The zero list is read as the bare relative path `zeros600.json`, so the script is NOT
cwd-independent — run it from the project root.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python tail.py

No flags, no arguments.  Run from the project root; reads `zeros600.json`.

REQUIREMENTS
------------
    pip install mpmath
"""
from mpmath import mp, mpf, mpc, binomial, log, pi, quad, re, sinh, sqrt
import json
mp.dps = 20
b,N,W,K = mpf(2),7,mpf('0.05'),2
COEF={}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j]=COEF.get(k-j,mpf(0))+(-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
a0=COEF[0]
def h(s): return (1-b**(-s))**N*(1-b**(s-1))**N
def T(s):
    z=W*(s-mpf('0.5')); return mpf(1) if z==0 else (sinh(z)/z)**(2*K)
Z=[mpf(x) for x in json.load(open("zeros600.json"))]
print("gamma_600 =", mp.nstr(Z[-1],10))
tot=sum(2*re(h(mpc(mpf('0.5'),g))*T(mpc(mpf('0.5'),g))) for g in Z)
print("zero sum 600 pairs =", mp.nstr(tot,12))
G=Z[-1]
# smooth tail: mean of h over t is a0 ; sinc^4 mean 3/8 ; density log(t/2pi)/2pi
tail = quad(lambda t: 2*a0*(mpf(3)/8)/(W*t)**4*log(t/(2*pi))/(2*pi), [G, 10*G, mp.inf])
print("estimated tail beyond gamma_600 =", mp.nstr(tail,8))
print("extrapolated spectral total =", mp.nstr(tot+tail,12))
