"""
O36 — CALIBRATING the explicit-formula implementation against a test function whose
      two sides are both known in closed form: a modulated Gaussian, for which the
      arithmetic side and the zero side can be computed independently and differenced.

Reads with: O37_weil_form_on_stencil.py, which uses the normalization calibrated
here; O38_weil_bug_diagnosis.py, which documents what went wrong before this
calibration existed.  Downstream of O8_weil_inner_product.py and
O21_archimedean_convergence.py (the archimedean cutoff's validity window).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree, run there, and
moved into the tree afterwards.  The code logic is unchanged from the scratch
version; only this docstring was added.  The normalization block below is the
original scratch docstring, preserved verbatim.

WHAT THIS MEASURES
------------------
Normalization used (derived from scratch; matches Iwaniec-Kowalski Thm 5.12
specialised to zeta, and Weil's original):

  Let H(s) be entire, H(s)=H(1-s), rapidly decaying on vertical lines.
  Let f(u) = (1/2pi) int_R H(1/2+it) e^{-iut} dt   (so H(1/2+it)=int f(u)e^{iut}du, f even)

      SUM_rho H(rho)  =  H(0) + H(1)
                         - 2 * SUM_{n>=2} Lambda(n) n^{-1/2} f(log n)
                         + (1/2pi) * int_R H(1/2+it) [ Re psi(1/4+it/2) - log pi ] dt

  Derivation: (1/2pi i)*contour around the critical strip of H(s)*(Xi'/Xi)(s),
  Xi(s)=pi^{-s/2}Gamma(s/2)zeta(s); poles of Xi at s=0,1 give -H(0)-H(1);
  functional equation folds the left line onto the right giving the factor 2.

For each of three (sigma, tau, Ucut, Tcut) settings the script (a) checks by
quadrature that H(1/2+it) really is the Fourier transform of f at t = 3.7,
(b) evaluates H(0), H(1), the prime term and the archimedean term and reports the
arithmetic side, and (c) sums 2*Re H(1/2 + i*gamma) over the first 50, 200 and 600
zeros from `zeros600.json`, printing the difference against the arithmetic side.
The residual difference at 600 pairs is the calibration number: if the normalization
is right it should be small and shrinking with the number of pairs.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Unlike the rest of the O-series this script takes NO CLI flags.  mp.dps = 25 and the
three settings ('1.0','14',9,45), ('0.5','20',5,70), ('1.5','10',13,35) are written
inline, as are the zero-count checkpoints (50, 200, 600) and the FT probe point
t = 3.7.  There is no `--out` and no results JSON — the console transcript is the
entire record.  This is a deviation from house convention (CONTEXT.md § "Output
schema"); an open NOTEPAD thread already records the same deviation for O30/O31/O32
and this script falls under it.

The zero list is read as the bare relative path `zeros600.json`, so the script is
NOT cwd-independent — it must be run from the project root.  That also deviates from
house convention (CONTEXT.md: "Paths are anchored to `_HERE` so runs are
cwd-independent").

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O36_weil_calibration.py

No flags, no arguments.  Run from the project root; reads `zeros600.json`
(600 zeta zero imaginary parts at dps 25, produced by `mkzeros.py`).

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import mp, mpf, mpc, log, pi, digamma, quad, re, exp, cos, sqrt, cosh
import json
mp.dps = 25

ZEROS = [mpf(z) for z in json.load(open("zeros600.json"))]

def vonmangoldt_upto(M):
    """list of (n, Lambda(n)) for 2<=n<=M with Lambda(n)!=0"""
    from sympy import primerange
    out = []
    for p in primerange(2, M+1):
        n = p
        while n <= M:
            out.append((n, log(p)))
            n *= p
    return out

def explicit_formula(H, f, Ucut, Tcut):
    H0, H1 = H(mpf(0)), H(mpf(1))
    M = int(exp(Ucut))
    prime = mpf(0)
    for n, L in vonmangoldt_upto(M):
        prime += L * mpf(n)**mpf('-0.5') * f(log(mpf(n)))
    prime *= 2
    arch = quad(lambda t: re(H(mpc(mpf('0.5'), t)))
                          * (re(digamma(mpf('0.25')+mpc(0, t)/2)) - log(pi)),
                [-Tcut, 0, Tcut]) / (2*pi)
    return H0, H1, prime, arch, H0 + H1 - prime + arch

def zero_sum(H, npairs):
    return sum(2*re(H(mpc(mpf('0.5'), g))) for g in ZEROS[:npairs])

# ---- test function: modulated Gaussian  f(u) = exp(-u^2/(2 sig^2)) cos(tau u)
def make(sig, tau):
    sig, tau = mpf(sig), mpf(tau)
    A = sig*sqrt(2*pi)/2
    def f(u): return exp(-u**2/(2*sig**2))*cos(tau*u)
    def H(s):
        z = s - mpf('0.5')
        return 2*A*exp(sig**2*(z**2 - tau**2)/2)*cos(sig**2*tau*z)
    return H, f

for sig, tau, Ucut, Tcut in [('1.0', '14', 9, 45), ('0.5', '20', 5, 70), ('1.5','10',13,35)]:
    H, f = make(sig, tau)
    # sanity: H(1/2+it) must equal FT of f
    ft = quad(lambda u: f(u)*exp(mpc(0,1)*u*mpf('3.7')), [-12, 0, 12])
    print(f"sigma={sig} tau={tau}")
    print(f"  FT check at t=3.7:  quad {mp.nstr(ft,10)}   H {mp.nstr(H(mpc(mpf('0.5'),mpf('3.7'))),10)}")
    H0, H1, prime, arch, rhs = explicit_formula(H, f, Ucut, Tcut)
    print(f"  H0 {mp.nstr(H0,8)}  H1 {mp.nstr(H1,8)}  prime {mp.nstr(prime,10)}  arch {mp.nstr(arch,10)}")
    print(f"  ARITHMETIC = H0+H1-prime+arch = {mp.nstr(rhs,12)}")
    for np_ in (50, 200, 600):
        zs = zero_sum(H, np_)
        print(f"    zeros {np_:>4} pairs: {mp.nstr(zs,12):>18}   diff {mp.nstr(zs-rhs,6)}")
    print()
