"""
archtest.py — ARCHIMEDEAN CUTOFF sweep for the Weil form: evaluate the archimedean
      integral over |t| < 120, 400, 1000 and 3000 and watch where the value settles.

Supporting script, not an O-numbered test.  This is what fixed 3000 as the working
range used in O37_weil_form_balance.py, and what shows defect (d) of
O38_weil_form_BUGGY.py (truncation at +/-120) to be material.  Reads with
O21_archimedean_convergence.py, which asks the same question at the O21 scale.

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
The integrand is Re[h(s)T(s)] * (Re psi(1/4 + it/2) - log pi) at s = 1/2 + it,
divided by 2pi.  One row per cutoff.  The first row uses a deliberately coarse
three-node quadrature and the rest a uniform node set of spacing about 1.5, so the
sweep varies BOTH the range and the node density — the rows are not a clean
one-variable comparison.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
No CLI flags.  b = 2, N = 7, W = 0.05, K = 2, mp.dps = 15 and the cutoff list are
inline; there is no `--out` and no results JSON.  Deviation from house convention
(CONTEXT.md § "Output schema"); an open NOTEPAD thread already records the same
deviation for O30/O31/O32.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python archtest.py

No flags, no arguments.

REQUIREMENTS
------------
    pip install mpmath
"""
from mpmath import mp, mpf, mpc, binomial, log, pi, digamma, quad, re, sinh
mp.dps = 15
b, N, W, K = mpf(2), 7, mpf('0.05'), 2
def h(s): return (1-b**(-s))**N * (1-b**(s-1))**N
def T(s):
    z = W*(s-mpf('0.5'));  return mpf(1) if z==0 else (sinh(z)/z)**(2*K)
def integ(t):
    s = mpc(mpf('0.5'), t)
    return re(h(s)*T(s))*(re(digamma(mpf('0.25')+mpc(0,t)/2))-log(pi))
import sys
for Tc, step in [(120,'coarse'),(400,'fine'),(1000,'fine'),(3000,'fine')]:
    if step=='coarse': nodes=[-Tc,0,Tc]
    else:
        nn=int(Tc/mpf('1.5'))
        nodes=[mpf(-Tc)+2*mpf(Tc)*i/nn for i in range(nn+1)]
    v = quad(integ, nodes)/(2*pi)
    print(f"  range +-{Tc:>5} {step:>6}  arch = {mp.nstr(v,12)}")
