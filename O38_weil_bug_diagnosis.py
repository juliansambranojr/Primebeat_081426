"""
O38 — DIAGNOSING the buggy Weil-form implementation: take the objects of
      `O38_weil_form_BUGGY.py` verbatim, unmodified, and probe them one property at
      a time until the four defects that broke the explicit formula are visible.

Reads with: O38_weil_form_BUGGY.py — the SUPERSEDED, INCORRECT implementation this
script dissects, kept in the tree only as evidence.  The CORRECT implementation is
O37_weil_form_on_stencil.py (with O37_weil_form_balance.py as its reduced form);
the normalization both rely on is calibrated in O36_weil_calibration.py.

STATUS
------
EXPLORATORY.  No prereg, no hypothesis stated in advance, no decision rule, no
verdict.  Per `CLAUDE.md` § "Prereg discipline", nothing this script prints may be
described as a verdict.  This is a diagnostic, not a measurement.

PROVENANCE
----------
Written 2026-08-17 as a scratch script OUTSIDE the project tree (as `diag.py`), run
there, and moved into the tree afterwards.  The code logic is unchanged from the
scratch version; only this docstring was added.  Its definitions are deliberate
verbatim copies of the buggy script's — do not "fix" them here, that would destroy
the diagnostic.

WHAT THIS MEASURES
------------------
Five probes, labelled A-E in the output:

    A  functional equation:  H(s) vs H(1-s) at s = 0.3, 0.1, 0.5
    B  reality on the critical line:  |Im H| / |Re H| at t = 3.0, 14.1347
    C  evenness in t:  H(1/2+it) vs H(1/2-it) at t = 5.0
    D  Mellin/FT consistency:  int f(u) e^{iut} du vs H(1/2+it)
    E  evenness of f:  f(u) vs f(-u) at u = log 2, 2 log 2

THE FOUR DEFECTS these probes expose in `O38_weil_form_BUGGY.py`
---------------------------------------------------------------
    (a) The mollifier is centered at s = 0 rather than s = 1/2, which breaks the
        required symmetry H(s) = H(1-s).
    (b) The real-space weights are missing a factor b^(m/2), so f was not even.
    (c) The real-space kernel is a triangle, whose transform is sinc^2, and that is
        inconsistent with the sinc^4 symbol actually used on the spectral side.
    (d) The archimedean term's sign is inverted, and its integral is truncated at
        +/-120 when +/-3000 is needed for convergence.

All four are corrected in O37_weil_form_on_stencil.py.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass — output plumbing only: --out, --no-json and --results-dir.  b = 2,
N = 7, W = 0.05, mp.dps = 20 and every probe point stay inside the verbatim
copy of the buggy script's objects, deliberately unexposed, because varying
them would diagnose a different object than the one on record.  No
computation line changed, so a no-flag run prints exactly what the original
run printed and prior transcripts remain fully comparable.  The run now also
writes the house envelope (CONTEXT.md § "Output schema") to
results/weil_bug_diagnosis.json; paths are anchored to _HERE so the run is
cwd-independent.

HOW IT WAS RUN
--------------
    /Users/juliansambrano/GitHub/Primebeat_081426/.venv/bin/python O38_weil_bug_diagnosis.py

No flags: the run reproduces the original 2026-08-17 console output exactly,
plus the results JSON.  See --results-dir, --out, --no-json.

REQUIREMENTS
------------
    pip install mpmath
"""
import argparse
import datetime
import hashlib
import json
import math
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "weil_bug_diagnosis.json")


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
        description=("O38 - diagnose the buggy Weil-form implementation by "
                     "probing its verbatim objects one property at a time. "
                     "EXPLORATORY: no prereg, no decision rule, no verdict. "
                     "The probed constants are deliberately not exposed as "
                     "flags: they belong to the object on record."))
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


_args = _parse_args()
_started = datetime.datetime.now(datetime.timezone.utc)

# Diagnose weil3.py's own objects, unmodified definitions copied verbatim.
from mpmath import mp,mpf,mpc,binomial,log,pi,quad,re,im,sinh,exp
mp.dps=20
b,N,W=mpf(2),7,mpf('0.05'); LB=log(b)
COEF={}
for j in range(N+1):
    for k in range(N+1):
        COEF[k-j]=COEF.get(k-j,mpf(0))+(-1)**(j+k)*binomial(N,j)*binomial(N,k)*b**(-k)
def h(s): return (1-b**(-s))**N*(1-b**(s-1))**N
def T(s): return mpf(1) if s==0 else (sinh(W*s)/(W*s))**4
def H(s): return h(s)*T(s)
def Lam(v):
    v=abs(v); return (2*W-v)/(4*W*W) if v<2*W else mpf(0)
def f(u): return sum(cn*Lam(u-n*LB) for n,cn in COEF.items())
print("A. functional equation of weil3's H:")
for s in ('0.3','0.1','0.5'):
    s=mpf(s); print(f"   H({s}) = {mp.nstr(H(s),10):>18}   H({1-s}) = {mp.nstr(H(1-s),10):>18}   ratio {mp.nstr(H(s)/H(1-s),8)}")
print("B. is weil3's H real on the critical line?")
for t in ('3.0','14.1347'):
    v=H(mpc(mpf('0.5'),mpf(t))); print(f"   H(1/2+{t}i) = {mp.nstr(v,10)}   |Im|/|Re| = {mp.nstr(abs(im(v)/re(v)),6)}")
print("C. is weil3's H(1/2+it) even in t?")
for t in ('5.0',):
    print(f"   H(1/2+{t}i)={mp.nstr(H(mpc(mpf('0.5'),mpf(t))),10)}   H(1/2-{t}i)={mp.nstr(H(mpc(mpf('0.5'),-mpf(t))),10)}")
print("D. Mellin/FT check: does int f(u)e^{iut}du equal H(1/2+it)?")
SUP=N*LB+2*W
nodes=sorted(set([-SUP,SUP]+[m*LB+j*W for m in range(-N,N+1) for j in (-2,-1,0,1,2)]))
nodes=[x for x in nodes if -SUP<=x<=SUP]
for t in ('0','1.3','5.0','14.1347'):
    t=mpf(t); q=quad(lambda u: f(u)*exp(mpc(0,1)*u*t),nodes)
    print(f"   t={float(t):>9}   quad {mp.nstr(q,10):>26}   H {mp.nstr(H(mpc(mpf('0.5'),t)),10):>26}")
print("E. f evenness (formula needs f even):")
for u in ('0.693147','1.386294'):
    u=mpf(u); print(f"   f({u})={mp.nstr(f(u),10):>16}   f(-{u})={mp.nstr(f(-u),10):>16}")

# ---------------------------------------------------------------------------
# Results JSON (instrument-fix pass, 2026-08-25).  Everything above is the
# verbatim diagnostic, untouched.  The block below RE-EVALUATES the same
# probes through the same functions purely to record them; it changes nothing.
# ---------------------------------------------------------------------------
if not _args.no_json:
    _probe_rows = []
    for s in ('0.3', '0.1', '0.5'):
        s = mpf(s)
        _probe_rows.append({"probe": "A_functional_equation", "s": float(s),
                            "H_s": mp.nstr(H(s), 10),
                            "H_1ms": mp.nstr(H(1-s), 10),
                            "ratio": mp.nstr(H(s)/H(1-s), 8)})
    for t in ('3.0', '14.1347'):
        v = H(mpc(mpf('0.5'), mpf(t)))
        _probe_rows.append({"probe": "B_reality_on_critical_line",
                            "t": float(mpf(t)), "H": mp.nstr(v, 10),
                            "im_over_re": float(abs(im(v)/re(v)))})
    for t in ('5.0',):
        _probe_rows.append({"probe": "C_evenness_in_t", "t": float(mpf(t)),
                            "H_plus": mp.nstr(H(mpc(mpf('0.5'), mpf(t))), 10),
                            "H_minus": mp.nstr(H(mpc(mpf('0.5'), -mpf(t))), 10)})
    for t in ('0', '1.3', '5.0', '14.1347'):
        t = mpf(t)
        q = quad(lambda u: f(u)*exp(mpc(0, 1)*u*t), nodes)
        _probe_rows.append({"probe": "D_mellin_ft_check", "t": float(t),
                            "quad": mp.nstr(q, 10),
                            "H": mp.nstr(H(mpc(mpf('0.5'), t)), 10)})
    for u in ('0.693147', '1.386294'):
        u = mpf(u)
        _probe_rows.append({"probe": "E_f_evenness", "u": float(u),
                            "f_plus": mp.nstr(f(u), 10),
                            "f_minus": mp.nstr(f(-u), 10)})

    _ended = datetime.datetime.now(datetime.timezone.utc)
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": ("EXPLORATORY - no prereg, no decision rule, no verdict. "
                   "This is a diagnostic, not a measurement."),
        "params": {
            "code_version": _code_version(),
            "out": _args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "verbatim_note": ("b = 2, N = 7, W = 0.05, mp.dps = 20 and every "
                              "probe point live inside the verbatim copy of "
                              "O38_weil_form_BUGGY.py's objects and are "
                              "deliberately not exposed as flags."),
            "defects_exposed": [
                "(a) mollifier centered at s = 0 rather than s = 1/2",
                "(b) real-space weights missing the factor b^(m/2)",
                "(c) triangle kernel (sinc^2) against a sinc^4 symbol",
                "(d) archimedean term sign inverted and truncated at +/-120",
            ],
        },
        "summary": {
            "n_probes": len(_probe_rows),
            "probes": ["A_functional_equation", "B_reality_on_critical_line",
                       "C_evenness_in_t", "D_mellin_ft_check",
                       "E_f_evenness"],
        },
        "rows": _probe_rows,
    }
    _write_results(payload, _args.out)
