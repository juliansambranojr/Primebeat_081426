"""
O35 — NEAR-MISS cells: at eight table cells that come close to zero but do not hit
      it, compare the cell value, the true residual (pi minus Riemann R, run through
      the same difference construction) and the zero-built model, and report the
      fraction of the residual the zeros explain.

Reads with: O34_zeta_residual_model.py (the same explicit-formula model, at r = 20
only); O16_centered_difference_table.py and O27_joint_dyadic_triadic_table.py (the
backward-difference table and its exact zeros); O29_depth_residuals.py (li vs R).

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
Three triangles are built on r = 1..45 from the same backward-difference recursion
T(r,d) = T(r,d-1) - T(r-1,d-1), differing only in the depth-0 row:

    Tpi   from exact counts pi(2^r) via primecountpy.prime_pi
    TR    from the Riemann R function riemannr(2^r)
    To    from the zero-built oscillating part, NZ in (200, 600) pairs

At each of the eight near-miss cells

    (15,4) (17,5) (20,6) (22,6) (24,7) (25,21) (37,12) (39,14)

it prints the cell value Tpi, the true residual Tpi - TR, the model To, and the
fraction To/(Tpi - TR).  A fraction near 1 means the zeros account for the whole
residual at that cell; the sweep over 200 vs 600 pairs shows whether the fraction
is converging or still moving with truncation.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  R = 45, dps = 60,
the eight-cell list CELLS and the NZ sweep (200, 600) are module-level constants.
There is no `--out` and no results JSON — the console transcript is the entire
record.  This is a deviation from house convention (CONTEXT.md § "Output schema");
an open NOTEPAD thread already records the same deviation for O30/O31/O32 and this
script falls under it.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O35_nearmiss_residuals.py

No flags, no arguments.

REQUIREMENTS
------------
    pip install mpmath primecountpy
"""
from mpmath import mp, mpf, mpc, zetazero, ei, log, re, riemannr
from primecountpy import prime_pi
mp.dps = 60
R = 45
CELLS = [(15,4),(17,5),(20,6),(22,6),(24,7),(25,21),(37,12),(39,14)]

def tri(vals):                      # vals[r] for r=0..R
    N = [vals[r]-vals[r-1] for r in range(1,R+1)]
    T = {(r,0): N[r-1] for r in range(1,R+1)}
    for d in range(1,R):
        for r in range(d+1,R+1):
            T[(r,d)] = T[(r,d-1)] - T[(r-1,d-1)]
    return T

pi_v = [mpf(0)] + [mpf(prime_pi(2**r)) for r in range(1,R+1)]
R_v  = [mpf(1)] + [riemannr(mpf(2)**r)  for r in range(1,R+1)]
Tpi, TR = tri(pi_v), tri(R_v)

for NZ in (200, 600):
    rho = [mpc(mpf('0.5'), zetazero(n).imag) for n in range(1,NZ+1)]
    osc = [mpf(0)]
    for r in range(1,R+1):
        L = log(mpf(2)**r); t = mpf(0)
        for r_ in rho: t -= 2*re(ei(r_*L))
        osc.append(t)
    To = tri(osc)
    print(f"\n=== {NZ} zero pairs ===")
    print(f"{'cell':>10}{'value':>14}{'true resid':>16}{'from zeros':>16}{'frac':>9}")
    for (r,d) in CELLS:
        cell = Tpi[(r,d)]; res = cell - TR[(r,d)]; mod = To[(r,d)]
        frac = mod/res if res != 0 else mpf('nan')
        print(f"  ({r:>2},{d:>2}){mp.nstr(cell,8):>14}{mp.nstr(res,8):>16}{mp.nstr(mod,8):>16}{mp.nstr(frac,4):>9}")
