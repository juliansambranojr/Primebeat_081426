"""
O37 (companion) — THE WEIL FORM BALANCE at the converged archimedean cutoff:
      the same corrected construction as O37_weil_form_on_stencil.py, stripped to
      the single balance line, with the archimedean integral carried to |t| < 3000
      plus an analytic tail and the spectral sum given a matching tail estimate.

Reads with: O37_weil_form_on_stencil.py (same h, T, kernel and weights — this file
is its reduced form, and carries the SAME O-number deliberately); tail.py (the
spectral tail estimate, developed separately); archtest.py (the archimedean-cutoff
sweep that fixed 3000 as the working range); O36_weil_calibration.py (normalization);
O21_archimedean_convergence.py (the cutoff's validity window at the O21 scale).

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `final.py`), run
there, and moved into the tree afterwards.  The code logic is unchanged from the
scratch version; only this docstring was added.

WHAT THIS MEASURES
------------------
With b = 2, N = 7, W = 0.05, K = 2 (the defaults), it prints four lines and one
difference:

    prime term   2 * sum_n Lambda(n) n^(-1/2) f(log n) over the kernel support
    arch         main part, quadrature on a uniform node set over |t| < Tc
                 (default 3000), PLUS an analytic tail
                 2*a0*(3/8)/(W t)^4 * (log(t/2) - log pi) integrated from Tc
                 to infinity
    ARITHMETIC   H(0) + H(1) - prime + arch
    SPECTRAL     2*Re H(1/2 + i*gamma) over all 600 zeros in the zeros file,
                 plus an estimated tail beyond gamma_600 using the same
                 sinc^4 mean 3/8 and zero density log(t/2pi)/2pi

and finally their absolute and relative difference.  That relative difference is the
whole point of the script: it is how closely the two sides of the explicit formula
balance once both truncations are tail-corrected.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--base 2, --n 7, --w 0.05, --k 2, --dps 20 and --tc 3000 are the old inline
constants — so a no-flag run prints exactly what the original run printed and
prior transcripts remain fully comparable.  The archimedean node spacing
(Tc/1.2 intervals) and both tail formulae stay inline.  The same pass FIXED
the recorded cwd-dependence: the zero list was read as the bare relative path
`zeros600.json`; --zeros now defaults to the _HERE-anchored zeros600.json next
to this script, and the run is cwd-independent.  The run now also writes the
house envelope (CONTEXT.md § "Output schema") to
results/weil_form_balance.json, honouring --out, --no-json and --results-dir.

Both tails are ESTIMATES from the asymptotic mean of the symbol, not bounds.  They
are not error bars.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O37_weil_form_balance.py

No flags: the defaults reproduce the original 2026-08-17 run exactly (from any
cwd, now that the zeros path is anchored), plus the results JSON.  See --base,
--n, --w, --k, --dps, --tc, --zeros, --results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import (mp,mpf,mpc,binomial,log,pi,digamma,quad,re,sinh,exp,factorial,inf)
from sympy import primerange
import argparse
import datetime
import hashlib
import json
import math
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "weil_form_balance.json")
DEFAULT_ZEROS = os.path.join(_HERE, "zeros600.json")


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """Coerce to JSON-safe Python types; non-finite floats -> None."""
    if isinstance(o, dict):
        return {str(k): _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple, set, frozenset)):
        return [_jsonable(v) for v in o]
    if o is None or isinstance(o, str):
        return o
    if isinstance(o, bool):
        return bool(o)
    if isinstance(o, int):
        return int(o)
    if isinstance(o, float):
        return o if math.isfinite(o) else None
    try:
        f = float(o)
    except (TypeError, ValueError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a run."""
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(out_path, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
        print(f"\n  results written to {out_path}", flush=True)
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)


def _parse_args():
    ap = argparse.ArgumentParser(
        description=("O37 (companion) - the Weil form balance at the "
                     "converged archimedean cutoff, both truncations "
                     "tail-corrected. EXPLORATORY: no prereg, no decision "
                     "rule, no verdict."))
    ap.add_argument("--base", type=int, default=2,
                    help="ladder base b (default 2)")
    ap.add_argument("--n", type=int, default=7,
                    help="difference order N of the stencil symbol "
                         "(default 7)")
    ap.add_argument("--w", type=str, default='0.05',
                    help="mollifier half-width W (default 0.05)")
    ap.add_argument("--k", type=int, default=2,
                    help="mollifier half-order K, so the mollifier is "
                         "sinc^(2K) (default 2)")
    ap.add_argument("--dps", type=int, default=20,
                    help="mpmath working precision (default 20)")
    ap.add_argument("--tc", type=int, default=3000,
                    help="archimedean cutoff Tc: main quadrature over "
                         "|t| < Tc, analytic tail beyond (default 3000)")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="zeta-zero imaginary-parts JSON (default the "
                         "zeros600.json next to this script, dps-25 "
                         "precision)")
    ap.add_argument("--results-dir", type=str, default=DEFAULT_RESULTS_DIR,
                    help="directory for outputs (default results/)")
    ap.add_argument("--out", type=str, default=DEFAULT_OUT_JSON,
                    help="results JSON path")
    ap.add_argument("--no-json", action="store_true",
                    help="do not write the results JSON")
    args = ap.parse_args()
    if args.out == DEFAULT_OUT_JSON and args.results_dir != DEFAULT_RESULTS_DIR:
        args.out = os.path.join(args.results_dir,
                                os.path.basename(DEFAULT_OUT_JSON))
    return args


args = _parse_args()
_started = datetime.datetime.now(datetime.timezone.utc)
mp.dps = args.dps
b,N,W,K = mpf(args.base),args.n,mpf(args.w),args.k ; LB=log(b); NK=2*K
COEF={}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j]=COEF.get(k-j,mpf(0))+(-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
a0=COEF[0]
def h(s): return (1-b**(-s))**N*(1-b**(s-1))**N
def T(s):
    z=W*(s-mpf('0.5')); return mpf(1) if z==0 else (sinh(z)/z)**(2*K)
def H(s): return h(s)*T(s)
def bspl(x,n):
    if x<=0 or x>=n: return mpf(0)
    return sum((-1)**k*binomial(n,k)*(x-k)**(n-1) for k in range(int(x)+1))/factorial(n-1)
def Kern(v): return bspl(v/(2*W)+NK/mpf(2),NK)/(2*W)
def f(u): return sum(c*b**(mpf(m)/2)*Kern(u-m*LB) for m,c in COEF.items())
SUP=N*LB+NK*W
prime=mpf(0)
for p in primerange(2,int(exp(SUP))+1):
    m=1
    while m*log(p)<=SUP:
        prime+=log(p)*mpf(p)**(-mpf(m)/2)*2*f(m*log(p)); m+=1
def integ(t):
    return re(H(mpc(mpf('0.5'),t)))*(re(digamma(mpf('0.25')+mpc(0,t)/2))-log(pi))
Tc=args.tc; nn=int(Tc/mpf('1.2')); nodes=[mpf(-Tc)+2*mpf(Tc)*i/nn for i in range(nn+1)]
arch_main=quad(integ,nodes)/(2*pi)
arch_tail=2*quad(lambda t: a0*(mpf(3)/8)/(W*t)**4*(log(t/2)-log(pi)),[Tc,10*Tc,inf])/(2*pi)
arch=arch_main+arch_tail
rhs=H(mpf(0))+H(mpf(1))-prime+arch
Z=[mpf(x) for x in json.load(open(args.zeros))]
sp=sum(2*re(H(mpc(mpf('0.5'),g))) for g in Z)
sptail=quad(lambda t:2*a0*(mpf(3)/8)/(W*t)**4*log(t/(2*pi))/(2*pi),[Z[-1],10*Z[-1],inf])
print(f"prime term (2*sum Lambda(n)n^-1/2 f(log n)) = {mp.nstr(prime,14)}")
print(f"arch  main(|t|<{Tc}) {mp.nstr(arch_main,14)}  + tail {mp.nstr(arch_tail,6)}  = {mp.nstr(arch,14)}")
print(f"ARITHMETIC  = H0+H1-prime+arch = {mp.nstr(rhs,14)}")
print(f"SPECTRAL    {len(Z)} pairs {mp.nstr(sp,14)}  + est tail {mp.nstr(sptail,6)} = {mp.nstr(sp+sptail,14)}")
print(f"difference  {mp.nstr(rhs-(sp+sptail),6)}   relative {mp.nstr((rhs-(sp+sptail))/rhs,6)}")

if not args.no_json:
    _ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": ("EXPLORATORY - no prereg, no decision rule, no verdict. "
                   "Nothing here may be described as a verdict."),
        "params": {
            "code_version": _code_version(),
            "base": args.base,
            "n": N,
            "w": args.w,
            "k": K,
            "dps": args.dps,
            "tc": Tc,
            "zeros": args.zeros,
            "n_zeros_loaded": len(Z),
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "symbol": "h(s) = (1-b^-s)^N (1-b^(s-1))^N",
            "mollifier": "T(s) = (sinh(W(s-1/2))/(W(s-1/2)))^(2K), "
                         "centered at s = 1/2",
            "kernel_support": float(SUP),
            "a0": float(a0),
            "arch_nodes": nn + 1,
            "tails_note": "Both tails are ESTIMATES from the asymptotic "
                          "mean of the symbol, not bounds.",
        },
        "summary": {
            "prime_term": float(prime),
            "arch_main": float(arch_main),
            "arch_tail": float(arch_tail),
            "arch": float(arch),
            "arithmetic": float(rhs),
            "spectral_pairs": len(Z),
            "spectral_sum": float(sp),
            "spectral_tail_est": float(sptail),
            "spectral_total": float(sp + sptail),
            "difference": float(rhs - (sp + sptail)),
            "relative_difference": float((rhs - (sp + sptail)) / rhs),
        },
        "rows": [],
    }
    _write_results(payload, args.out)
