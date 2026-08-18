"""
O38 — SUPERSEDED AND INCORRECT.  The first Weil-form attempt on the dyadic
      difference stencil.  Its numbers are WRONG and must not be cited.  It is kept
      in the tree only as evidence, so that O38_weil_bug_diagnosis.py has the object
      it dissects and so the correction in O37 is auditable.

DO NOT USE THIS SCRIPT FOR ANY MEASUREMENT.  The correct implementation is
`O37_weil_form_on_stencil.py`, with `O37_weil_form_balance.py` as its reduced form
and `O36_weil_calibration.py` as the calibration of their shared normalization.

Reads with: O38_weil_bug_diagnosis.py, which probes these exact definitions verbatim
and exposes the four defects listed below.

STATUS
------
EXPLORATORY AND SUPERSEDED.  No prereg, no hypothesis stated in advance, no decision
rule, no verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints
may be described as a verdict — and here the stronger statement also holds: nothing
it prints may be described as a result at all.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `weil3.py`), run
there, superseded the same day, and moved into the tree afterwards as evidence.  The
code logic is unchanged from the scratch version — deliberately, defects included;
only this docstring was added.  Two earlier intermediates (`weil.py`, `weil2.py`)
were NOT moved into the tree; this file plus the diagnosis document that lineage.

WHAT IT ATTEMPTED TO MEASURE
----------------------------
With b = 2, N = 7, W = 0.05 it builds h(s) = (1-b^-s)^N (1-b^(s-1))^N — the Mellin
symbol of the N-fold dyadic difference — mollifies it, sums the prime-power side
over the kernel support, adds an archimedean integral, and compares that arithmetic
side against 2*Re H(1/2 + i*gamma) accumulated over the first 100, 200 and 400
zeros obtained from `mpmath.zetazero`.  The printed ratio of spectral to arithmetic
does not converge, because of the defects below.

THE FOUR DEFECTS
----------------
    (a) The mollifier T(s) is centered at s = 0 rather than s = 1/2, which breaks
        the required symmetry H(s) = H(1-s).
    (b) The real-space weights in f are missing a factor b^(m/2), so f is not even.
    (c) The real-space kernel is the triangle `Lam`, whose transform is sinc^2, and
        that is inconsistent with the sinc^4 symbol used on the spectral side.
    (d) The archimedean term enters with an inverted sign (`rhs = H0 + H1 - prime
        - arch`), and its integral is truncated at +/-120 when +/-3000 is needed.

O38_weil_bug_diagnosis.py demonstrates each of these; O37_weil_form_on_stencil.py
corrects all four.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  b = 2, N = 7,
W = 0.05, mp.dps = 15, the archimedean range [-120, 120] and the zero-count
checkpoints are written inline.  There is no `--out` and no results JSON.  This is a
deviation from house convention (CONTEXT.md § "Output schema"); an open NOTEPAD
thread already records the same deviation for O30/O31/O32.  Moot here — the script
is retained as evidence, not for re-running.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O38_weil_form_BUGGY.py

No flags, no arguments.  Recorded for provenance only — do not re-run for numbers.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import mp, mpf, mpc, binomial, log, pi, digamma, quad, zetazero, re, sinh, exp
from sympy import primerange
mp.dps = 15
b, N, W = mpf(2), 7, mpf('0.05')
LB = log(b)

# h(s) = (1-b^-s)^N (1-b^(s-1))^N   -> |1-b^-rho|^(2N) >= 0 on Re s = 1/2, and h(s)=h(1-s)
COEF = {}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j] = COEF.get(k-j, mpf(0)) + (-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
def h(s): return (1-b**(-s))**N * (1-b**(s-1))**N
def T(s): return mpf(1) if s == 0 else (sinh(W*s)/(W*s))**4
def H(s): return h(s)*T(s)
def Lam(v):
    v = abs(v); return (2*W-v)/(4*W*W) if v < 2*W else mpf(0)
def f(u): return sum(cn*Lam(u-n*LB) for n, cn in COEF.items())

print(f"check positivity on the critical line:  h(1/2) = {mp.nstr(h(mpf('0.5')),8)}   h(1/2+14.13i) = {mp.nstr(re(h(mpc(mpf('0.5'),mpf('14.1347')))),8)}")
print(f"check functional equation:  h(0.3) = {mp.nstr(h(mpf('0.3')),10)}   h(0.7) = {mp.nstr(h(mpf('0.7')),10)}")
SUP = N*LB + 2*W
primes = list(primerange(2, int(exp(SUP))+1))
print(f"support x in [1/{mp.nstr(exp(SUP),6)}, {mp.nstr(exp(SUP),6)}]   primes in play: {len(primes)}\n")

prime = mpf(0); contrib = {}
for p in primes:
    sp = mpf(0); m = 1
    while m*log(p) <= SUP:
        sp += log(p)*mpf(p)**(-mpf(m)/2)*2*f(m*log(p)); m += 1
    if sp != 0: contrib[p] = sp
    prime += sp
arch = quad(lambda t: re(H(mpc(mpf('0.5'),t)))*(re(digamma(mpf('0.25')+mpc(0,t)/2))-log(pi)), [-120,0,120])/(2*pi)
H0, H1 = H(mpf(0)), H(mpf(1))
rhs = H0 + H1 - prime - arch
print("  nonzero prime contributions:", {p: mp.nstr(v,6) for p,v in contrib.items()})
print(f"\n  H(0) {mp.nstr(H0,8)}  H(1) {mp.nstr(H1,8)}  primes {mp.nstr(prime,10)}  arch {mp.nstr(arch,10)}")
print(f"  ARITHMETIC SIDE  {mp.nstr(rhs,10)}\n")
tot = mpf(0); n = 0
for M in (100, 200, 400):
    while n < M:
        n += 1; tot += 2*re(H(mpc(mpf('0.5'), zetazero(n).imag)))
    print(f"  spectral {M:>4} pairs  {mp.nstr(tot,10):>16}   ratio to arithmetic {mp.nstr(tot/rhs,8)}")
