"""
O34 (FAILED) — SUPERSEDED AND DIVERGENT.  The first attempt at modelling pi(x)
      from the zeta zeros, built on the Gram series.  It DIVERGED.  Its numbers
      are meaningless and MUST NOT BE CITED.  It is kept in the tree only as
      evidence of the trajectory that produced O34_zeta_residual_model.py.

DO NOT USE THIS SCRIPT FOR ANY MEASUREMENT.  The working version is
`O34_zeta_residual_model.py`, which avoids the Gram series entirely by using
li(x^rho) = Ei(rho * log x) — a form mpmath evaluates directly at complex
arguments, with no term-count or precision problem.

STATUS
------
EXPLORATORY, SUPERSEDED AND DIVERGENT.  No prereg, no hypothesis stated in
advance, no decision rule, no verdict.  Per `CLAUDE.md` § "Prereg discipline",
nothing this script prints may be described as a verdict — and here the
stronger statement also holds: nothing it prints may be described as a result
at all, or quoted as a number anywhere.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `model.py`),
run there, found divergent the same day, and moved into the tree afterwards as
evidence.  The code logic is unchanged from the scratch version — deliberately,
the defect included; only this docstring was added.  Its successor in the same
scratch session (`model2.py`) became `O34_zeta_residual_model.py`.

WHAT IT ATTEMPTED
-----------------
Build pi(x) from the explicit formula by evaluating the Gram series

    R(z) = 1 + sum_{k>=1} (ln z)^k / (k * k! * zeta(k+1))

at the complex arguments x^rho, i.e. calling it with L = rho * log x, and
summing -2*Re R(rho log x) over the first NZ = 120 zero pairs.  It then ran the
resulting ladder through the same backward-difference construction the table
uses, T(r,d) = T(r,d-1) - T(r-1,d-1), and compared against exact primepi.

WHY IT FAILED
-------------
It returned 1.29e+182 for pi(2^20), where the true value is 82025.

The cause is term count, not a coding error.  The Gram series is entire but its
partial sums do not begin to converge until roughly |ln z| terms have been
summed.  With NZ = 120 zero pairs and x = 2^20, |rho * log(2^20)| reaches about
2772, so on the order of thousands of terms are needed — against a KMAX of 90.
The intermediate terms peak enormously before the factorial takes over, so the
truncated sum is dominated by that peak.  Making it converge would need
thousands of terms AND roughly 1300 digits of working precision to survive the
cancellation, against the mp.dps = 40 set here.  That is not a fix, it is a
different instrument — hence the li/Ei formulation in the working version.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  mp.dps = 40,
NZ = 120, RMAX = 22 and KMAX = 90 are written inline, and there is no `--out`
and no results JSON.  This is a deviation from house convention (CONTEXT.md
§ "Output schema"); an open NOTEPAD thread already records the same deviation
for O30/O31/O32.  Moot here — the script is retained as evidence, not for
re-running.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python model.py

No flags, no arguments.  Recorded for provenance only — DO NOT RE-RUN, and do
not quote anything it prints.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import mp, mpf, mpc, zetazero, zeta, log, exp, re, factorial
from sympy import primepi
mp.dps = 40

NZ   = 120          # zero pairs
RMAX = 22
KMAX = 90           # Gram series terms

print(f"dps={mp.dps}  zero pairs={NZ}  ladder r=1..{RMAX}")

# Gram series: R(z) = 1 + sum_k (ln z)^k / (k * k! * zeta(k+1))
ZK = [zeta(k+1) for k in range(1, KMAX+1)]
def Rlog(L):                       # L = log(z), complex ok
    s = mpc(1); term_pow = mpc(1)
    for k in range(1, KMAX+1):
        term_pow *= L
        s += term_pow / (k * factorial(k) * ZK[k-1])
    return s

print("loading zeros...", flush=True)
rho = [mpc(mpf('0.5'), zetazero(n).imag) for n in range(1, NZ+1)]

def pi_model(x):
    L = log(mpf(x))
    tot = Rlog(L)                                  # R(x)
    for r_ in rho:                                 # -sum over zero pairs
        tot -= 2*re(Rlog(r_*L))
    return tot

print("evaluating ladder...", flush=True)
mod = [pi_model(2**r) for r in range(0, RMAX+1)]
tru = [mpf(int(primepi(2**r))) for r in range(0, RMAX+1)]

# depth-0 rows, then difference down
def triangle(vals):                 # vals indexed by r=0..RMAX
    N = [vals[r]-vals[r-1] for r in range(1, RMAX+1)]
    T = {(r,0): N[r-1] for r in range(1, RMAX+1)}
    for d in range(1, RMAX):
        for r in range(d+1, RMAX+1):
            T[(r,d)] = T[(r,d-1)] - T[(r-1,d-1)]
    return T
TM, TT = triangle(mod), triangle(tru)

print(f"\npi(2^20): true {int(tru[20])}   model {mp.nstr(mod[20],12)}   err {mp.nstr(mod[20]-tru[20],4)}")
print("\nrow 20, depths 0..8:")
print(f"{'d':>3}{'true':>12}{'model':>16}{'diff':>14}")
for d in range(0, 9):
    t, m = TT[(20,d)], TM[(20,d)]
    print(f"{d:>3}{int(t):>12}{mp.nstr(m,10):>16}{mp.nstr(m-t,6):>14}")

print("\nall four known zero cells:")
for (r,d) in ((2,1),(4,1),(8,3),(20,6)):
    print(f"  ({r},{d})  true {int(TT[(r,d)]):>4}   model {mp.nstr(TM[(r,d)],8)}")
