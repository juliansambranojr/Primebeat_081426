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
     400 and 600 zeros from the zeros file, each reported with its difference from
     and ratio to the arithmetic side.

The closing ratio is the quantity of interest: whether the two sides of the explicit
formula agree once the corrections diagnosed in O38 are applied.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  The bare positional K argument became --k (default 2, unchanged), and
--base 2, --n 7, --w 0.05 and --dps 25 expose the old inline constants.
Defaults reproduce the original hardcoded invocation byte-for-byte, so a
no-flag run prints exactly what the original `... O37_weil_form_on_stencil.py 2`
run printed and prior transcripts remain fully comparable.  The archimedean
range [-400, 400] and its quadrature nodes, the FT probe points and the
zero-count checkpoints stay inline.  The same pass FIXED the recorded
cwd-dependence: the zero list was read as the bare relative path
`zeros600.json`; --zeros now defaults to the _HERE-anchored zeros600.json next
to this script, and the run is cwd-independent.  The run now also writes the
house envelope (CONTEXT.md § "Output schema") to
results/weil_form_on_stencil.json, honouring --out, --no-json and
--results-dir.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O37_weil_form_on_stencil.py --k 2

No flags needed: the defaults (including --k 2) reproduce the original
2026-08-17 run exactly (from any cwd, now that the zeros path is anchored),
plus the results JSON.  See --k, --base, --n, --w, --dps, --zeros,
--results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import (mp, mpf, mpc, binomial, log, pi, digamma, quad, re, im,
                    sinh, exp, sqrt)
from sympy import primerange
import argparse
import datetime
import hashlib
import json
import math
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "weil_form_on_stencil.json")
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
        description=("O37 - the Weil form on the dyadic difference stencil, "
                     "corrected: explicit formula's two sides checked "
                     "against each other. EXPLORATORY: no prereg, no "
                     "decision rule, no verdict."))
    ap.add_argument("--k", type=int, default=2,
                    help="mollifier half-order K, so the mollifier is "
                         "sinc^(2K) (default 2; replaces the original bare "
                         "positional argument)")
    ap.add_argument("--base", type=int, default=2,
                    help="ladder base b (default 2)")
    ap.add_argument("--n", type=int, default=7,
                    help="difference order N of the stencil symbol "
                         "(default 7)")
    ap.add_argument("--w", type=str, default='0.05',
                    help="mollifier half-width W (default 0.05)")
    ap.add_argument("--dps", type=int, default=25,
                    help="mpmath working precision (default 25)")
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

b, N, W = mpf(args.base), args.n, mpf(args.w)
LB = log(b)
K = args.k                                            # mollifier = (sinc)^(2K)

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

_ft_rows = []
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
    _ft_rows.append({"t": float(t), "quad": mp.nstr(q, 10),
                     "H": mp.nstr(Hv, 10), "abs_diff": float(abs(q-Hv))})

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

ZEROS = [mpf(x) for x in json.load(open(args.zeros))]
_spec_rows = []
tot = mpf(0); n = 0
for M in (100, 200, 400, 600):
    while n < M:
        tot += 2*re(H(mpc(mpf('0.5'), ZEROS[n]))); n += 1
    print(f"  spectral {M:>4} pairs {mp.nstr(tot,12):>18}   diff {mp.nstr(tot-rhs,8):>14}  ratio {mp.nstr(tot/rhs,10)}")
    _spec_rows.append({"pairs": M, "spectral": float(tot),
                       "diff": float(tot-rhs), "ratio": float(tot/rhs)})

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
            "k": K,
            "base": args.base,
            "n": N,
            "w": args.w,
            "dps": args.dps,
            "zeros": args.zeros,
            "n_zeros_loaded": len(ZEROS),
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "symbol": "h(s) = (1-b^-s)^N (1-b^(s-1))^N",
            "mollifier": "T(s) = (sinh(W(s-1/2))/(W(s-1/2)))^(2K), "
                         "centered at s = 1/2",
            "kernel_half_support": float(NK*W),
            "total_half_support": float(SUP),
            "arch_range": [-400, 400],
            "zero_checkpoints": [100, 200, 400, 600],
        },
        "summary": {
            "symmetry_check": {"H_0.3": mp.nstr(H(mpf('0.3')), 10),
                               "H_0.7": mp.nstr(H(mpf('0.7')), 10)},
            "H_at_gamma1": mp.nstr(z, 10),
            "primes_in_play": len(primes),
            "primes_nonzero": sorted(contrib),
            "H0": float(H0),
            "H1": float(H1),
            "prime_term": float(prime),
            "arch": float(arch),
            "arithmetic": float(rhs),
            "spectral_final": _spec_rows[-1] if _spec_rows else None,
        },
        "rows": ([dict(kind="ft_check", **r) for r in _ft_rows]
                 + [dict(kind="spectral", **r) for r in _spec_rows]),
    }
    _write_results(payload, args.out)
