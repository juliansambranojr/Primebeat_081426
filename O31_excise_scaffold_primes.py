#!/usr/bin/env python3
"""
O31 — EXCISING the scaffold primes 2, 3, 5: delete them from the number line
      entirely, close the line up so every position above them reindexes, and
      ask whether the dyadic table's exact zeros survive.

Reads with: O16_centered_difference_table.py (the backward-difference table and
its exact zero set {(2,1), (4,1), (8,3), (20,6)}).  Companion to
O30_silence_scaffold_primes.py, which performs the OTHER operation — zeroing the
counts while leaving every block boundary in place.  The pair is the point: one
operation changes HOW MANY primes lie below a stencil, the other changes WHERE
the block boundaries fall.

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
Two excision variants, each rebuilt into a full backward-difference table on
r = 1..22, d = 0..8, each printing its triangle and its exact-zero list:

    A   delete only the three integers 2, 3, 5
    B   delete 2, 3, 5 and all of their multiples (the 30-wheel)

In both, surviving integers are walked in order, assigned a NEW position, and
their primality (in the original integers) is counted against the dyadic block
that new position falls in.  So the counts are the same primes, re-blocked.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  RMAX = 22,
DMAX = 8 and the sieve limit LIM = 20,000,000 are module-level constants, the
excised set {2, 3, 5} is written inline in both variants, and there is no `--out`
and no results JSON — the console transcript is the entire record.  This is a
deviation from house convention (CONTEXT.md § "Output schema") and wants an
instrument-fix pass.

HOW IT WAS RUN
--------------
    python3 O31_excise_scaffold_primes.py

No flags.

REQUIREMENTS
------------
    stdlib only
"""

RMAX, DMAX = 22, 8
NPOS = 2**RMAX

def sieve(n):
    s = bytearray([1])*(n+1); s[0]=s[1]=0
    i=2
    while i*i<=n:
        if s[i]: s[i*i::i]=bytearray(len(s[i*i::i]))
        i+=1
    return s

def build(N):
    n=len(N); T=[[None]*(n+1) for _ in range(DMAX+1)]
    for r in range(1,n+1): T[0][r]=N[r-1]
    for d in range(1,DMAX+1):
        for r in range(d+1,n+1):
            if T[d-1][r] is not None and T[d-1][r-1] is not None:
                T[d][r]=T[d-1][r]-T[d-1][r-1]
    return T

def show(T,title,n):
    print("\n"+title)
    print("   r"+"".join(f"{'d'+str(d):>9}" for d in range(DMAX+1)))
    for r in range(1,n+1):
        row=f"{r:>4}"
        for d in range(DMAX+1):
            v=T[d][r] if r<len(T[d]) else None
            row+="         " if v is None else f"{v:>9}"
        print(row)
    zs=[(r,d) for d in range(DMAX+1) for r in range(1,n+1)
        if r<len(T[d]) and T[d][r]==0]
    print("  zeros:",sorted(zs,key=lambda t:(t[0],t[1])))

def counts(keep, isp, need):
    """walk values, keep those passing 'keep', record primality by NEW position"""
    N=[0]*RMAX; pos=0; v=0; r=1; bound=2
    while pos<need:
        v+=1
        if not keep(v): continue
        pos+=1
        while pos>bound: r+=1; bound=2**r
        if isp[v]: N[r-1]+=1
    return N

LIM=20_000_000
isp=sieve(LIM)

# A: delete only the integers 2,3,5; line closes up
gone={2,3,5}
A=counts(lambda v: v not in gone, isp, NPOS)
print("A depth-0:",A[:10],"...")
show(build(A),"A - integers 2,3,5 excised, line closed up",RMAX)

# B: delete 2,3,5 and all their multiples (30-wheel); line closes up
B=counts(lambda v: v==1 or (v%2 and v%3 and v%5), isp, NPOS)
print("\nB depth-0:",B[:10],"...")
show(build(B),"B - 2,3,5 and all multiples excised, line closed up",RMAX)
