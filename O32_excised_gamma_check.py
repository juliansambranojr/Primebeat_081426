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
Sieve to LIM (default 2e7).  For each of three value sequences —

    baseline   the untouched integers 1..N
    A          integers with 2, 3, 5 deleted
    B          integers with 2, 3, 5 and all their multiples deleted

— sample the residual pi(v(M)) - R(v(M)) at SAMPLES points (default 8192)
uniform in log(position) from log(XMIN) up (default XMIN 3000), where v(M) is
the value at new position M and R is the Riemann prime-counting function via
its Moebius series (n <= 25).  Normalise out the sqrt(x)/log x growth, subtract
the mean, apply a Hann window, take the rFFT, and report the peak location in a
+/-BAND band (default 1.2) around each of gamma_1, gamma_2, gamma_3.

Frequency resolution is set by the log-x window width, and is coarse enough that
peak locations must be read against it rather than against the true gammas
directly.

FLAGS AND RESULTS JSON (instrument-fix pass, 2026-08-25)
--------------------------------------------------------
CLI flags and the results JSON were added in the 2026-08-25 instrument-fix
pass.  Defaults reproduce the original hardcoded invocation byte-for-byte —
--lim 20000000, --samples 8192, --xmin 3000, --trim 0.98 and --band 1.2 are
the old module-level and inline constants — so a no-flag run prints exactly
what the original run printed and prior transcripts remain fully comparable.
The Moebius cutoff n <= 25, the r > 1.2 guard on Ei and the three target
gammas stay inline.  The run now also writes the house envelope (CONTEXT.md
§ "Output schema") to results/excised_gamma_check.json, honouring --out,
--no-json and --results-dir; paths are anchored to _HERE so the run is
cwd-independent.

HOW IT WAS RUN
--------------
    python3 O32_excised_gamma_check.py

No flags: the defaults reproduce the original 2026-08-17 run exactly, plus the
results JSON.  See --lim, --samples, --xmin, --trim, --band, --results-dir,
--out, --no-json.

REQUIREMENTS
------------
    pip install numpy scipy sympy
"""

import argparse
import datetime
import hashlib
import json
import math
import os

import numpy as np
from scipy.special import expi
from sympy import mobius

_HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_RESULTS_DIR = os.path.join(_HERE, "results")
DEFAULT_OUT_JSON = os.path.join(DEFAULT_RESULTS_DIR, "excised_gamma_check.json")


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
        description=("O32 - spectrum of the count residual pi(x) - R(x) on "
                     "the untouched and excised lines of O31, against "
                     "gamma_1, gamma_2, gamma_3. EXPLORATORY: no prereg, no "
                     "decision rule, no verdict."))
    ap.add_argument("--lim", type=int, default=20_000_000,
                    help="sieve limit and line length N (default 20000000)")
    ap.add_argument("--samples", type=int, default=8192,
                    help="sample points, uniform in log(position) "
                         "(default 8192)")
    ap.add_argument("--xmin", type=float, default=3000,
                    help="lower edge of the log(position) window "
                         "(default 3000)")
    ap.add_argument("--trim", type=float, default=0.98,
                    help="upper edge of the window as a fraction of the line "
                         "length (default 0.98)")
    ap.add_argument("--band", type=float, default=1.2,
                    help="half-width of the peak-search band around each "
                         "target gamma (default 1.2)")
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
LIM = args.lim
SAMPLES = args.samples
XMIN = args.xmin
TRIM = args.trim
BAND = args.band

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
    lo, hi = np.log(XMIN), np.log(len(v)*TRIM)
    u = np.linspace(lo,hi,SAMPLES)
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
        sel = (f>g-BAND)&(f<g+BAND)
        pk.append(f[sel][np.argmax(F[sel])])
    print(f"{label:<34} peaks near g1,g2,g3: "+"  ".join(f"{p:8.3f}" for p in pk))
    return pk

N = LIM
allv   = np.arange(1,N+1,dtype=np.int64)
A_v    = allv[(allv!=2)&(allv!=3)&(allv!=5)]
B_v    = allv[(allv==1)|((allv%2!=0)&(allv%3!=0)&(allv%5!=0))]

print(f"true gammas                        {14.1347:>18.3f}{21.0220:>10.3f}{25.0109:>10.3f}\n")
pk_base = spectrum(allv, "baseline (untouched line)")
pk_A    = spectrum(A_v,  "A: 2,3,5 excised")
pk_B    = spectrum(B_v,  "B: 2,3,5 + multiples excised")

if not args.no_json:
    _ended = datetime.datetime.now(datetime.timezone.utc)
    _seqs = [("baseline (untouched line)", pk_base),
             ("A: 2,3,5 excised", pk_A),
             ("B: 2,3,5 + multiples excised", pk_B)]
    payload = {
        "schema_version": "1",
        "script": os.path.abspath(__file__),
        "generated_utc": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        "status": ("EXPLORATORY - no prereg, no decision rule, no verdict. "
                   "Nothing here may be described as a verdict."),
        "params": {
            "code_version": _code_version(),
            "lim": LIM,
            "samples": SAMPLES,
            "xmin": XMIN,
            "trim": TRIM,
            "band": BAND,
            "out": args.out,
            "run_start_at": _started.strftime("%Y-%m-%dT%H:%M:%SZ"),
            "run_end_at": _ended.strftime("%Y-%m-%dT%H:%M:%SZ"),
        },
        "constants": {
            "target_gammas": [14.1347, 21.0220, 25.0109],
            "moebius_cutoff": 25,
            "ei_guard": 1.2,
            "window": "Hann",
            "normalisation": "res * log(val) / sqrt(val), mean-subtracted",
        },
        "summary": {
            "peaks": {label: {"g1": pk[0], "g2": pk[1], "g3": pk[2]}
                      for label, pk in _seqs},
        },
        "rows": [{"sequence": label,
                  "peak_g1": pk[0], "peak_g2": pk[1], "peak_g3": pk[2]}
                 for label, pk in _seqs],
    }
    _write_results(payload, args.out)
