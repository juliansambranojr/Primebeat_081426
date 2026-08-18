#!/usr/bin/env python3
"""
O30 — SILENCING the scaffold primes 2, 3, 5: zero out their counts in the blocks
      that contain them, leave every block boundary where it is, and ask whether
      the dyadic table's exact zeros survive.

Reads with: O16_centered_difference_table.py (the backward-difference table and
its exact zero set {(2,1), (4,1), (8,3), (20,6)}); O27_joint_dyadic_triadic_table.py
(same construction, two bases).  Companion to O31_excise_scaffold_primes.py, which
performs the OTHER operation — deleting the integers and closing the line up.

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
Three tables on r = 1..22, d = 0..8, all from the same backward-difference
construction T(r,d) = T(r,d-1) - T(r-1,d-1):

    BASELINE   depth-0 row N(r) = pi(2^r) - pi(2^(r-1)), untouched
    SILENCED   the same row with the counts of 2, 3 and 5 removed from the
               blocks that hold them (blocks 1, 2, 3).  Block boundaries are
               NOT moved; the emptied leading blocks stay in place as zeros.
    REINDEXED  the silenced row with the leading emptied regimes dropped and
               r relabelled from 1, to see how the zero coordinates shift.

Each table prints its full triangle and its exact-zero coordinate list.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  RMAX = 22 and
DMAX = 8 are module-level constants, the silenced primes {2, 3, 5} and their
blocks {1, 2, 3} are written inline, and there is no `--out` and no results JSON —
the console transcript is the entire record.  This is a deviation from house
convention (CONTEXT.md § "Output schema") and wants an instrument-fix pass.

HOW IT WAS RUN
--------------
    python3 O30_silence_scaffold_primes.py

No flags.

REQUIREMENTS
------------
    pip install sympy
"""

from sympy import primepi

RMAX, DMAX = 22, 8

def build(N):
    # N is 1-indexed list of depth-0 block counts; T[d][r]
    n = len(N)
    T = [[None]*(n+1) for _ in range(DMAX+1)]
    for r in range(1, n+1):
        T[0][r] = N[r-1]
    for d in range(1, DMAX+1):
        for r in range(d+1, n+1):
            if T[d-1][r] is not None and T[d-1][r-1] is not None:
                T[d][r] = T[d-1][r] - T[d-1][r-1]
    return T

def show(T, title, n):
    print("\n" + title)
    hdr = "   r" + "".join(f"{'d'+str(d):>9}" for d in range(DMAX+1))
    print(hdr)
    for r in range(1, n+1):
        row = f"{r:>4}"
        for d in range(DMAX+1):
            v = T[d][r] if r < len(T[d]) else None
            row += "         " if v is None else f"{v:>9}"
        print(row)
    zs = [(r,d) for d in range(DMAX+1) for r in range(1,n+1)
          if r < len(T[d]) and T[d][r] == 0]
    print("  zeros:", sorted(zs, key=lambda t:(t[0],t[1])))

# baseline
base = [int(primepi(2**r) - primepi(2**(r-1))) for r in range(1, RMAX+1)]
show(build(base), "BASELINE  (all primes)", RMAX)

# silence 2,3,5 -> they live in blocks 1,2,3
sil = list(base)
for p, blk in ((2,1),(3,2),(5,3)):
    sil[blk-1] -= 1
print("\nsilenced depth-0 row:", sil[:8], "...")
show(build(sil), "SILENCED  (2,3,5 removed, regimes kept in place)", RMAX)

# reindexed: drop leading empty regimes, relabel from r=1
first = next(i for i,v in enumerate(sil) if v != 0)
re = sil[first:]
print(f"\ndropped {first} leading empty regimes; new depth-0 row:", re[:8], "...")
show(build(re), f"REINDEXED (2,3,5 removed, r shifted by {first})", len(re))
