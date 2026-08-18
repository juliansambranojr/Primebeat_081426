"""
O37 — THE WEIL FORM on the dyadic difference stencil, corrected: build the test
      function h(s) = (1-b^-s)^N (1-b^(s-1))^N — the Mellin symbol of the N-fold
      dyadic difference — mollify it with a sinc^(2K) factor centered at s = 1/2,
      and check the explicit formula's two sides against each other.

Reads with: O36_weil_calibration.py, whose calibrated normalization this script
uses; O38_weil_bug_diagnosis.py and O38_weil_form_BUGGY.py, the superseded attempt
and its diagnosis.  Companion to O37_weil_form_balance.py, which is the same
construction stripped to the balance line and pushed to the converged archimedean
cutoff with tail estimates on both sides.  Downstream of O8_weil_inner_product.py.

This is the CORRECT implementation.  `O38_weil_form_BUGGY.py` is the earlier,
incorrect one, kept only as evidence.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `weil_fixed.py`),
run there, and moved into the tree afterwards.  The code logic is unchanged from the
scratch version; only this docstring was added.  Its own one-line scratch header read:
"Corrected version of weil3.py, using the calibrated normalization from calib.py."

WHAT THIS MEASURES
------------------
With b = 2, N = 7, W = 0.05 and mollifier order K (default 2):

    h(s) = (1-b^-s)^N (1-b^(s-1))^N          symmetric, h(s) = h(1-s)
    T(s) = (sinh(W(s-1/2))/(W(s-1/2)))^(2K)  mollifier CENTERED AT s = 1/2
    H(s) = h(s) T(s)

The real-space side is built as a cardinal B-spline kernel of order 2K (the 2K-fold
convolution of a unit box of half-width W, whose transform is sinc^(2K), matching
the symbol), with the difference coefficients weighted a_m * b^(m/2) so that f is
even.  The script then prints, in order:

  1. a direct quadrature check that int f(u) e^{iut} du equals H(1/2+it) at
     t = 0, 1.3, 5.0, 14.1347;
  2. the functional-equation check H(0.3) vs H(0.7), and reality/positivity of H on
     the critical line;
  3. the arithmetic side H(0) + H(1) - prime + arch, with the prime term summed over
     prime powers inside the kernel support and the archimedean integral taken over
     [-400, 400];
  4. the spectral side, 2*Re H(1/2 + i*gamma) accumulated over the first 100, 200,
     400 and 600 zeros from `zeros600.json`, each reported with its difference from
     and ratio to the arithmetic side.

The closing ratio is the quantity of interest: whether the two sides of the explicit
formula agree once the corrections diagnosed in O38 are applied.

LIMITATION — HARDCODED PARAMETERS
---------------------------------
Only K is exposed, and as a bare positional argument rather than a CLI flag.  b = 2,
N = 7, W = 0.05, mp.dps = 25, the archimedean range [-400, 400] and its quadrature
nodes, the FT probe points and the zero-count checkpoints are all written inline.
There is no `--out` and no results JSON — the console transcript is the entire
record.  This is a deviation from house convention (CONTEXT.md § "Output schema");
an open NOTEPAD thread already records the same deviation for O30/O31/O32 and this
script falls under it.

The zero list is read as the bare relative path `zeros600.json`, so the script is
NOT cwd-independent — it must be run from the project root.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O37_weil_form_on_stencil.py 2

TAKES ONE OPTIONAL POSITIONAL ARGUMENT: K, the mollifier half-order, so the
mollifier is sinc^(2K).  Defaults to 2 when omitted.  Run from the project root;
reads `zeros600.json`.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import (mp, mpf, mpc, binomial, log, pi, digamma, quad, re, im,
                    sinh, exp, sqrt)
from sympy import primerange
import json, sys
mp.dps = 25

b, N, W = mpf(2), 7, mpf('0.05')
LB = log(b)
K = int(sys.argv[1]) if len(sys.argv) > 1 else 2      # mollifier = (sinc)^(2K)

# ---- h(s) = (1-b^-s)^N (1-b^(s-1))^N = sum_m a_m b^(m s)
COEF = {}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j] = COEF.get(k-j, mpf(0)) + (-1)**(j+k)*binomial(N, j)*binomial(N, k)*b**(-k)
def h(s): return (1-b**(-s))**N * (1-b**(s-1))**N

# ---- mollifier CENTERED AT s=1/2 so that T(s)=T(1-s)
def T(s):
    z = W*(s - mpf('0.5'))
    return mpf(1) if z == 0 else (sinh(z)/z)**(2*K)
def H(s): return h(s)*T(s)

# ---- real-space kernel: 2K-fold convolution of the unit-mass box of half-width W
#      FT = (sin(Wt)/(Wt))^(2K); support [-2K*W, 2K*W]
def bspline(x, n):
    """cardinal B-spline of order n (n-fold conv of unit box on [0,1]), support [0,n]"""
    if x <= 0 or x >= n: return mpf(0)
    # explicit truncated-power formula
    tot = mpf(0)
    for k in range(0, int(x)+1):
        tot += (-1)**k * binomial(n, k) * (x-k)**(n-1)
    from mpmath import factorial
    return tot/factorial(n-1)
NK = 2*K
def Kern(v):   # unit mass, support [-NK*W, NK*W]
    return bspline(v/(2*W) + NK/mpf(2), NK)/(2*W)

# ---- f(u): weights a_m * b^(m/2) (NOT a_m alone)
def f(u): return sum(cn*b**(mpf(m)/2)*Kern(u - m*LB) for m, cn in COEF.items())

SUP = N*LB + NK*W  # kernel half-support = NK*W

# ---- direct numerical check that H(1/2+it) == int f(u) e^{iut} du
print(f"K={K}  kernel support +-{mp.nstr(NK*W,4)}  total support +-{mp.nstr(SUP,6)}")
print("Mellin/FT check  int f(u)e^{iut}du   vs   H(1/2+it):")
for t in ('0', '1.3', '5.0', '14.1347'):
    t = mpf(t)
    nodes = [-SUP] + [m*LB + j*W for m in range(-N, N+1) for j in range(-NK, NK+1)] + [SUP]
    nodes = sorted(set(x for x in nodes if -SUP <= x <= SUP))
    q = quad(lambda u: f(u)*exp(mpc(0, 1)*u*t), nodes)
    Hv = H(mpc(mpf('0.5'), t))
    print(f"   t={float(t):>8}  quad {mp.nstr(q,10):>28}   H {mp.nstr(Hv,10):>28}   |diff| {mp.nstr(abs(q-Hv),4)}")

# ---- symmetry / reality checks
print(f"\nH(s)=H(1-s)?  H(0.3)={mp.nstr(H(mpf('0.3')),10)}  H(0.7)={mp.nstr(H(mpf('0.7')),10)}")
z = H(mpc(mpf('0.5'), mpf('14.1347')))
print(f"H real & >=0 on critical line?  H(1/2+14.1347i) = {mp.nstr(z,10)}")

# ---- arithmetic side
primes = list(primerange(2, int(exp(SUP))+1))
prime = mpf(0); contrib = {}
for p in primes:
    sp = mpf(0); m = 1
    while m*log(p) <= SUP:
        sp += log(p)*mpf(p)**(-mpf(m)/2)*2*f(m*log(p)); m += 1
    if sp != 0: contrib[p] = sp
    prime += sp
arch = quad(lambda t: re(H(mpc(mpf('0.5'), t)))
                      * (re(digamma(mpf('0.25')+mpc(0, t)/2)) - log(pi)),
            [-400, -100, -20, 0, 20, 100, 400])/(2*pi)
H0, H1 = H(mpf(0)), H(mpf(1))
rhs = H0 + H1 - prime + arch
print(f"\nprimes in play: {len(primes)}  nonzero: {sorted(contrib)}")
print(f"H(0) {mp.nstr(H0,8)}  H(1) {mp.nstr(H1,8)}  prime {mp.nstr(prime,12)}  arch {mp.nstr(arch,12)}")
print(f"ARITHMETIC = H0+H1-prime+arch = {mp.nstr(rhs,12)}\n")

ZEROS = [mpf(x) for x in json.load(open("zeros600.json"))]
tot = mpf(0); n = 0
for M in (100, 200, 400, 600):
    while n < M:
        tot += 2*re(H(mpc(mpf('0.5'), ZEROS[n]))); n += 1
    print(f"  spectral {M:>4} pairs {mp.nstr(tot,12):>18}   diff {mp.nstr(tot-rhs,8):>14}  ratio {mp.nstr(tot/rhs,10)}")
