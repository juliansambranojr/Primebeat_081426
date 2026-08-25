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
zeros from the zeros file, printing the difference against the arithmetic side.
The residual difference at 600 pairs is the calibration number: if the normalization
is right it should be small and shrinking with the number of pairs.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--dps 25 is the old inline constant — so a no-flag run prints exactly what the
original run printed and prior transcripts remain fully comparable.  The three
settings rows ('1.0','14',9,45), ('0.5','20',5,70), ('1.5','10',13,35), the
zero-count checkpoints (50, 200, 600) and the FT probe point t = 3.7 stay
inline.  The same pass FIXED a recorded cwd-dependence defect: the zero list
was read as the bare relative path `zeros600.json`, so the script only worked
from the project root; --zeros now defaults to the _HERE-anchored
zeros600.json next to this script, and the run is cwd-independent.  The run
now also writes the house envelope (CONTEXT.md § "Output schema") to
results/weil_calibration.json, honouring --out, --no-json and --results-dir.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O36_weil_calibration.py

No flags: the defaults reproduce the original 2026-08-17 run exactly (from any
cwd, now that the zeros path is anchored), plus the results JSON.  See --dps,
--zeros, --results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install mpmath sympy
"""
from mpmath import mp, mpf, mpc, log, pi, digamma, quad, re, exp, cos, sqrt, cosh
import argparse
import datetime
import hashlib
import json
import math
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "weil_calibration.json")
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
        description=("O36 - calibrate the explicit-formula implementation on "
                     "modulated Gaussians, both sides known in closed form. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict."))
    ap.add_argument("--dps", type=int, default=25,
                    help="mpmath working precision (default 25)")
    ap.add_argument("--zeros", type=str, default=DEFAULT_ZEROS,
                    help="zeta-zero imaginary-parts JSON (default the "
                         "zeros600.json next to this script; the cache is "
                         "dps-25 precision, produced by mkzeros.py)")
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

ZEROS = [mpf(z) for z in json.load(open(args.zeros))]

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

_rows = []
for sig, tau, Ucut, Tcut in [('1.0', '14', 9, 45), ('0.5', '20', 5, 70), ('1.5','10',13,35)]:
    H, f = make(sig, tau)
    # sanity: H(1/2+it) must equal FT of f
    ft = quad(lambda u: f(u)*exp(mpc(0,1)*u*mpf('3.7')), [-12, 0, 12])
    print(f"sigma={sig} tau={tau}")
    print(f"  FT check at t=3.7:  quad {mp.nstr(ft,10)}   H {mp.nstr(H(mpc(mpf('0.5'),mpf('3.7'))),10)}")
    H0, H1, prime, arch, rhs = explicit_formula(H, f, Ucut, Tcut)
    print(f"  H0 {mp.nstr(H0,8)}  H1 {mp.nstr(H1,8)}  prime {mp.nstr(prime,10)}  arch {mp.nstr(arch,10)}")
    print(f"  ARITHMETIC = H0+H1-prime+arch = {mp.nstr(rhs,12)}")
    row = {"sigma": sig, "tau": tau, "ucut": Ucut, "tcut": Tcut,
           "ft_check_quad": mp.nstr(ft, 10),
           "ft_check_H": mp.nstr(H(mpc(mpf('0.5'), mpf('3.7'))), 10),
           "H0": float(H0), "H1": float(H1),
           "prime": float(prime), "arch": float(arch),
           "arithmetic": float(rhs), "zero_sums": {}}
    for np_ in (50, 200, 600):
        zs = zero_sum(H, np_)
        print(f"    zeros {np_:>4} pairs: {mp.nstr(zs,12):>18}   diff {mp.nstr(zs-rhs,6)}")
        row["zero_sums"][str(np_)] = {"sum": float(zs),
                                      "diff": float(zs - rhs)}
    print()
    _rows.append(row)

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
            "dps": args.dps,
            "zeros": args.zeros,
            "n_zeros_loaded": len(ZEROS),
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "settings": [["1.0", "14", 9, 45], ["0.5", "20", 5, 70],
                         ["1.5", "10", 13, 35]],
            "settings_note": "(sigma, tau, Ucut, Tcut) rows, inline by design",
            "zero_checkpoints": [50, 200, 600],
            "ft_probe_t": 3.7,
            "test_function": "f(u) = exp(-u^2/(2 sig^2)) cos(tau u), "
                             "modulated Gaussian",
        },
        "summary": {
            "diff_at_600_pairs": {
                f"sigma={row['sigma']},tau={row['tau']}":
                    row["zero_sums"]["600"]["diff"]
                for row in _rows},
        },
        "rows": _rows,
    }
    _write_results(payload, args.out)
