"""
O34 — MODELLING the dyadic table's residual from the zeta zeros: build the
      oscillating part of pi(x) from the first NZ zero pairs, run it through the
      same backward-difference construction as the table, and ask how much of the
      true residual at r = 20 it reproduces as depth grows.

Reads with: O16_centered_difference_table.py and O27_joint_dyadic_triadic_table.py
(the backward-difference construction and its exact zero set {(2,1), (4,1), (8,3),
(20,6)}); O29_depth_residuals.py (the li-vs-R residual decay with depth).  Companion
to O35_nearmiss_residuals.py, which asks the same question at the near-miss cells.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree, run there, and
moved into the tree afterwards.  The code logic is unchanged from the scratch
version; only this docstring was added.

WHAT THIS MEASURES
------------------
For each truncation NZ in (50, 200, 500) zero pairs it forms

    osc(x) = - sum over rho of 2*Re( Ei(rho * log x) ),   rho = 1/2 + i*gamma_n

evaluates it at x = 2^r for r = 0..22, differences to get a depth-0 block row, and
builds the triangle T(r,d) = T(r,d-1) - T(r-1,d-1).  It then prints, for depths
d = 0..6 at r = 20, the hardcoded true residual TRUE_RES_R20 alongside the
zero-built model value, their difference and their ratio, plus the model's value at
the four exact-zero cells (2,1), (4,1), (8,3), (20,6).

The ratio column is the quantity of interest: whether the zero sum accounts for a
stable fraction of the residual as depth increases, and whether that fraction
converges as more zero pairs are added.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  RMAX = 22, the
dps of 40, the NZ sweep (50, 200, 500) and the depth range 0..6 are all written
inline, and TRUE_RES_R20 is a literal list of seven strings transcribed from an
earlier run rather than recomputed here.  There is no `--out` and no results JSON —
the console transcript is the entire record.  This is a deviation from house
convention (CONTEXT.md § "Output schema"); an open NOTEPAD thread already records
the same deviation for O30/O31/O32 and this script falls under it.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O34_zeta_residual_model.py

No flags, no arguments.

REQUIREMENTS
------------
    pip install mpmath
"""
from mpmath import mp, mpf, mpc, zetazero, ei, log, re
mp.dps = 40
RMAX = 22

TRUE_RES_R20 = [mpf(v) for v in
    ('-24.886','-48.190','-82.086','-133.761','-212.314','-322.410','-453.424')]

def osc(x, rho):
    """oscillating part of pi(x): -sum over zero pairs of 2*Re(li(x^rho))"""
    L = log(mpf(x)); t = mpf(0)
    for r_ in rho:
        t -= 2*re(ei(r_*L))
    return t

def triangle(vals):
    N = [vals[r]-vals[r-1] for r in range(1, RMAX+1)]
    T = {(r,0): N[r-1] for r in range(1, RMAX+1)}
    for d in range(1, RMAX):
        for r in range(d+1, RMAX+1):
            T[(r,d)] = T[(r,d-1)] - T[(r-1,d-1)]
    return T

for NZ in (50, 200, 500):
    rho = [mpc(mpf('0.5'), zetazero(n).imag) for n in range(1, NZ+1)]
    T = triangle([osc(2**r, rho) for r in range(0, RMAX+1)])
    print(f"\n--- {NZ} zero pairs ---")
    print(f"{'d':>3}{'true resid':>13}{'from zeros':>14}{'diff':>11}{'ratio':>8}")
    for d in range(0, 7):
        m = T[(20,d)]; t = TRUE_RES_R20[d]
        print(f"{d:>3}{mp.nstr(t,7):>13}{mp.nstr(m,7):>14}{mp.nstr(m-t,4):>11}{mp.nstr(m/t,4):>8}")
    print("  model at the four zero cells (true residual there is what cancels the smooth part):")
    print("   ", "  ".join(f"({r},{d})={mp.nstr(T[(r,d)],6)}" for r,d in ((2,1),(4,1),(8,3),(20,6))))
