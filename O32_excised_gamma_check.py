#!/usr/bin/env python3
"""
O32 — Do the detected frequencies move when the scaffold primes are EXCISED?
      Spectrum of the count residual pi(x) - R(x) on the untouched integer line
      and on the two excised lines of O31, compared against gamma_1, gamma_2,
      gamma_3.

Reads with: O31_excise_scaffold_primes.py (defines the two excision variants A
and B whose lines this script re-sieves); O17_disjoint_block_residual.py and
O24_prime_generator_orbit.py (the residual-spectrum instrument and the
log-uniform sampling it uses); CONTEXT.md § "Core quantities" for gamma_1.

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
Sieve to 2e7.  For each of three value sequences —

    baseline   the untouched integers 1..N
    A          integers with 2, 3, 5 deleted
    B          integers with 2, 3, 5 and all their multiples deleted

— sample the residual pi(v(M)) - R(v(M)) at 8192 points uniform in log(position)
from log(3000) up, where v(M) is the value at new position M and R is the
Riemann prime-counting function via its Moebius series (n <= 25).  Normalise out
the sqrt(x)/log x growth, subtract the mean, apply a Hann window, take the rFFT,
and report the peak location in a +/-1.2 band around each of gamma_1, gamma_2,
gamma_3.

Frequency resolution is set by the log-x window width, and is coarse enough that
peak locations must be read against it rather than against the true gammas
directly.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  LIM = 20,000,000,
the 8192 sample points, the log(3000) lower edge, the 0.98 upper trim, the Moebius
cutoff n <= 25, the r > 1.2 guard on Ei, the +/-1.2 search band and the three
target gammas are all module-level or inline constants, and there is no `--out`
and no results JSON — the console transcript is the entire record.  This is a
deviation from house convention (CONTEXT.md § "Output schema") and wants an
instrument-fix pass.

HOW IT WAS RUN
--------------
    python3 O32_excised_gamma_check.py

No flags.

REQUIREMENTS
------------
    pip install numpy scipy sympy
"""

import numpy as np
from scipy.special import expi
from sympy import mobius

LIM = 20_000_000
def sieve(n):
    s = bytearray([1])*(n+1); s[0]=s[1]=0
    i=2
    while i*i<=n:
        if s[i]: s[i*i::i]=bytearray(len(s[i*i::i]))
        i+=1
    return s
isp = sieve(LIM)
pi_cum = np.cumsum(np.frombuffer(isp,dtype=np.uint8).astype(np.int64))

MU = [(n,int(mobius(n))) for n in range(1,26) if mobius(n)!=0]
def R(x):
    x = np.asarray(x,dtype=float); out=np.zeros_like(x)
    for n,m in MU:
        r = x**(1.0/n)
        out += (m/n)*np.where(r>1.2, expi(np.log(np.maximum(r,1.2))), 0.0)
    return out

def spectrum(v, label):
    """v: strictly increasing array of VALUES at positions M=1..len(v).
       residual sampled uniformly in log(position)."""
    M = np.arange(1,len(v)+1)
    lo, hi = np.log(3000.0), np.log(len(v)*0.98)
    u = np.linspace(lo,hi,8192)
    Mi = np.clip(np.exp(u).astype(np.int64),1,len(v))
    val = v[Mi-1]
    res = pi_cum[val] - R(val)
    w = res*np.log(val)/np.sqrt(val)          # normalise the sqrt(x)/log x growth
    w = w - w.mean()
    w *= np.hanning(len(w))
    du = u[1]-u[0]
    F = np.abs(np.fft.rfft(w))
    f = 2*np.pi*np.fft.rfftfreq(len(w), d=du)
    pk=[]
    for g in (14.1347,21.0220,25.0109):
        sel = (f>g-1.2)&(f<g+1.2)
        pk.append(f[sel][np.argmax(F[sel])])
    print(f"{label:<34} peaks near g1,g2,g3: "+"  ".join(f"{p:8.3f}" for p in pk))
    return f,F

N = LIM
allv   = np.arange(1,N+1,dtype=np.int64)
A_v    = allv[(allv!=2)&(allv!=3)&(allv!=5)]
B_v    = allv[(allv==1)|((allv%2!=0)&(allv%3!=0)&(allv%5!=0))]

print(f"true gammas                        {14.1347:>18.3f}{21.0220:>10.3f}{25.0109:>10.3f}\n")
spectrum(allv, "baseline (untouched line)")
spectrum(A_v,  "A: 2,3,5 excised")
spectrum(B_v,  "B: 2,3,5 + multiples excised")
