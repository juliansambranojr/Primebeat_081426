#!/usr/bin/env python3
"""
O20 — Connes cutoff sweep: turn a STATED OPEN QUESTION into a MEASURED CURVE.

Reads with: O8_weil_inner_product.py (the existing connes_cvs caller in this
tree); O19_bridge_figure.py (the d-axis this script's results land on);
REFERENCES.md § "Packages and environment" (connes-cvs 0.3.1, python-flint).

NAMING
------
The O-series in this tree runs O1-O9 and O11-O19.  There is NO O10: that
number is a known, DELIBERATE GAP, and this script does not fill it.  The next
free number after O19 is O20; this file takes it.  Capital "O" per `CLAUDE.md`
§ "Naming convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

A. Connes, "The Riemann Hypothesis: Past, Present and a Letter Through Time",
arXiv:2602.04022v1, 3 Feb 2026, extremises the truncated Weil quadratic form
QW_lambda on test functions supported in [lambda^-1, lambda], and reads the
zeros off the Mellin transform of the minimising eigenvector.  Theorem 6.1
(joint with W. van Suijlekom) proves those zeros lie on the critical line,
PROVIDED the smallest eigenvalue is simple, isolated, and has an even
eigenfunction.  Using only the primes <= 13 he reports first-50-zero errors
from 2.60179e-55 to 2.09081e-2.

His §5 states the open question verbatim:

    "What we do not know is that, when we increase the upper limit, which was
     x = 13 here, the corresponding set of zeros will converge towards the
     zeros of zeta.  This is something which at this point is not proved."

and §6.6 names the missing hypothesis:

    "one needs to show that the smallest eigenvalue of the Weil quadratic form
     QW_lambda is simple with even eigenvector"

He computes ONE cutoff.  This script SWEEPS the cutoff and measures the
accuracy curve, and measures the spectral gap that Theorem 6.1's hypothesis
requires.  IT PROVES NOTHING.  It turns a stated open question into a measured
curve.  Interpretation of that curve is NOT this script's job and is not
performed anywhere in this file.

The `connes_cvs` package (0.3.1, already installed in this bench's .venv)
implements the construction; O8 in this tree already calls it.  Its parameter
`c` is the prime cutoff, i.e. Connes' lambda.

=============================================================================
WHAT IS COMPUTED — per cutoff c
=============================================================================

The call sequence MIRRORS O8_weil_inner_product.py exactly:

    Q          = cc.build_galerkin_matrix(c, N=N, T=T, dps=dps)
    lam, vec   = cc.compute_ground_state(Q)
    zeros      = cc.extract_zeros(vec, n_zeros=n_zeros, dps=dps, c=c)

`extract_zeros` returns a LIST OF PER-ZERO DICTS with keys
`k`, `gamma_true`, `gamma_detected`, `error`, `residual`, `converged`,
`failure`, `tolerance` (documented at
`.venv/lib/python3.14/site-packages/connes_cvs/operator.py:779-785`).  Records
are INDEXED BY KEY.  `mp.mpf()` is NEVER called on a record — that is the bug
that crashed O8's original print loop, and it is recorded in REFERENCES.md
§ "API note".  A record with `converged is not True` is written to the output
with a marker rather than crashing the run.

Recorded per c:

  1. n_primes_in_window  — the number of primes <= c, and the list of them.
  2. d = 2*log2(c) - 1   — the BRIDGE COORDINATE, from lambda = 2^((d+1)/2),
     so these results land on the same axis as `O19_bridge_figure.py`.
  3. Q.rows; the symmetry check ||Q - Q^T|| / ||Q|| (the quantity O8 prints);
     and the wall time of the build.
  4. lam_1 = the smallest even-sector eigenvalue, and log10|lam_1|.
  5. THE SPECTRAL GAP.  Theorem 6.1 needs the minimum simple and isolated.
     `connes_cvs`'s PUBLIC API (`connes_cvs.__init__.__all__` =
     build_galerkin_matrix, compute_ground_state, extract_zeros,
     arb_eigenpair_residual_bound) exposes ONLY the smallest eigenvalue:
     `compute_ground_state` returns `(lambda_min, v_full)` and discards the
     rest of the spectrum (operator.py:697-722).  THERE IS NO PUBLIC API FOR
     THE SECOND EIGENVALUE.  Rather than improvise a different matrix, this
     script REPLICATES the package's own even-sector projection VERBATIM —
     the V_even projector of `operator.py:684-694`, columns e_0 and
     (e_k + e_{-k})/sqrt(2), and Q_even = V_even^T Q V_even — and calls
     `mp.eigsy` on THAT SAME MATRIX, which is the same call the package makes
     at `operator.py:697`.  The replication is verified every run: the minimum
     of the replicated spectrum is compared against the `lam` the package
     returned, and the agreement is recorded as `even_sector_replication` on
     every row's cutoff block.  Reported: lam_1 < lam_2, the absolute gap
     lam_2 - lam_1, and the RATIO lam_2/lam_1.
  6. Per zero k = 1..n_zeros: gamma_true, gamma_detected, error, residual,
     converged.
  7. THE FIRST-ZERO ERROR specifically, since that is the number Connes
     quotes (2.60179e-55 at c = 13).  Ours is printed next to his at c = 13.

=============================================================================
GATES — all three RUN inside the script and are recorded in the payload
=============================================================================

GATE A — FLINT IS ACTUALLY IN USE.  Reports whether `import flint` succeeds
and whether `connes_cvs.operator.HAS_FLINT` is True.  If HAS_FLINT is False
the gate prints LOUDLY: the run then takes the mpmath digamma fallback and is
roughly 2.7x slower.  Recorded either way; a False does not stop the run.

GATE B — REPRODUCE O8's RECORDED EIGENVALUE AT c = 13.  The expected value is
READ FROM THE LOG, not hardcoded: the line "smallest even-sector eigenvalue:"
is parsed out of `O8_run_dps150.log` (falling back to `O8_run_dps300.log`),
and the file and 1-based line number actually used are recorded in
`summary.gate_b.source_file` / `source_line`.  Criterion: agreement to at
least 6 significant figures, i.e. |ours - o8| / |o8| < 5e-7.
  PARAMETER DIFFERENCE, STATED UP FRONT: the O8 runs used N = 100, T = 800, at
dps = 300 and dps = 150.  THIS SCRIPT DEFAULTS TO T = 400.  If the value does
not match, the payload records the mismatch AND the parameter difference; that
is reported as a PARAMETER MISMATCH, not as a failure of the package.

GATE C — Q SYMMETRIC.  ||Q - Q^T|| / ||Q|| must be 0 EXACTLY, as O8 reported
at c = 13, N = 100, T = 800 (`O8_run_dps150.log:8`).  Checked at every cutoff.

=============================================================================
ENVELOPE
=============================================================================

House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` (ONE ROW PER (c, zero index)).  `params.code_version` is
the sha256 of THIS file, read from `__file__` at runtime.  `params.precision`
records the mix.  Tables print AS EACH CUTOFF COMPLETES, so a long run stays
legible while it goes.

BUDGET.  `--budget-minutes` stops NEW cutoffs from STARTING once the elapsed
time exceeds it.  A cutoff already under way always finishes.  Skipped cutoffs
are recorded in `summary.cutoffs_skipped` — the JSON is always complete for
the cutoffs that ran and always says which ones did not.

REQUIREMENTS
------------
    connes-cvs, mpmath   (both already present in this bench's .venv;
    python-flint is optional but present, see gate A)

USAGE
-----
    ./.venv/bin/python3 O20_connes_cutoff_sweep.py
    ./.venv/bin/python3 O20_connes_cutoff_sweep.py --cutoffs 13 --N 40 \
        --dps 60 --no-json
"""

import argparse
import hashlib
import json
import math
import os
import re
import time
from datetime import datetime, timezone

try:
    import mpmath as mp
except ImportError:
    raise ImportError(
        "mpmath is required and is NOT optional: the Galerkin matrix, the "
        "eigensolve and the zero extraction are all arbitrary-precision. "
        "Install with: pip install mpmath")

try:
    import connes_cvs as cc
except ImportError:
    raise ImportError(
        "connes-cvs is required. This bench's .venv has 0.3.1 "
        "(REFERENCES.md § 'Packages and environment'). "
        "Install with: pip install connes-cvs")

import connes_cvs.operator as cc_op

_HERE = os.path.dirname(os.path.abspath(__file__))
_STEM = os.path.splitext(os.path.basename(__file__))[0]
DEFAULT_OUT = os.path.join(_HERE, "results", _STEM + "_results.json")

# Gate B reads its expected value out of these logs, in this order. The file
# and 1-based line number actually used are recorded in the payload.
GATE_B_LOGS = ("O8_run_dps150.log", "O8_run_dps300.log")
GATE_B_PATTERN = re.compile(
    r"smallest even-sector eigenvalue:\s*([0-9eE.+\-]+)")
GATE_B_C = 13
GATE_B_RELTOL = 5e-7          # 6 significant figures
GATE_B_O8_N = 100             # the O8 runs' parameters, for the mismatch note
GATE_B_O8_T = 800
GATE_B_O8_DPS = (150, 300)

# Connes, arXiv:2602.04022v1, §6: the first-zero error at x = 13.
CONNES_FIRST_ZERO_ERROR_C13 = 2.60179e-55
CONNES_ERROR_RANGE = (2.60179e-55, 2.09081e-2)
CONNES_CUTOFF = 13

DEFAULT_CUTOFFS = "13,17,19,23,29"


def _code_version():
    """sha256 of this script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(__file__), "rb") as fh:
            return hashlib.sha256(fh.read()).hexdigest()
    except Exception as exc:
        return f"unavailable: {exc}"


def _jsonable(o):
    """Coerce mpf / numpy-ish scalars to JSON-safe types; non-finite -> None."""
    if isinstance(o, dict):
        return {str(k): _jsonable(v) for k, v in o.items()}
    if isinstance(o, (list, tuple)):
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
    except (TypeError, ValueError, OverflowError):
        return str(o)
    return f if math.isfinite(f) else None


def _write_results(payload, out_path):
    """Write the results envelope; never let a write failure kill a long run."""
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


def _safe_div(a, b):
    """Guarded division: returns nan rather than raising or returning inf."""
    try:
        if b is None:
            return float("nan")
        bv = float(b)
        if not math.isfinite(bv) or bv == 0.0:
            return float("nan")
        av = float(a)
        if not math.isfinite(av):
            return float("nan")
        return av / bv
    except (TypeError, ValueError, ZeroDivisionError, OverflowError):
        return float("nan")


def _f(v):
    """mpf/number -> float, or None when it is not representable."""
    if v is None:
        return None
    try:
        f = float(v)
    except (TypeError, ValueError, OverflowError):
        return None
    return f if math.isfinite(f) else None


def _s(v, n=25):
    """mpf/number -> full-precision decimal STRING; floats lose the exponent."""
    if v is None:
        return None
    try:
        return mp.nstr(v, n)
    except (TypeError, ValueError):
        return str(v)


def _fmtg(v, w=18, p=10, dash="—"):
    """Guarded general-format formatter for table cells."""
    if v is None:
        return f"{dash:>{w}}"
    try:
        f = float(v)
    except (TypeError, ValueError, OverflowError):
        return f"{str(v):>{w}}"
    if not math.isfinite(f):
        return f"{dash:>{w}}"
    return f"{f:>{w}.{p}g}"


def frob(M):
    """Frobenius norm of an mpmath matrix. Same helper O8 uses."""
    return mp.sqrt(sum(abs(M[i, j]) ** 2
                       for i in range(M.rows) for j in range(M.cols)))


def primes_up_to(n):
    """Primes <= n by trial division. n here is tiny (tens), not a hot path."""
    out = []
    for k in range(2, int(n) + 1):
        lim = int(k ** 0.5)
        if all(k % d for d in range(2, lim + 1)):
            out.append(k)
    return out


def parse_cutoffs(s):
    """Comma-separated cutoff list -> list of ints, order preserved."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        try:
            v = int(tok)
        except ValueError:
            raise SystemExit(f"--cutoffs: '{tok}' is not an integer")
        if v < 2:
            raise SystemExit(f"--cutoffs: '{tok}' must be >= 2 "
                             "(connes_cvs rejects c < 2)")
        out.append(v)
    if not out:
        raise SystemExit("--cutoffs is empty")
    return out


def bridge_d(c):
    """d = 2*log2(c) - 1, from lambda = 2^((d+1)/2). O19's axis."""
    return 2.0 * math.log(float(c), 2.0) - 1.0


# --------------------------------------------------------------------------
# GATE A — is flint actually in use?
# --------------------------------------------------------------------------
def gate_a():
    """Report whether flint imports and whether connes_cvs is using it."""
    try:
        import flint
        flint_import = True
        flint_version = str(getattr(flint, "__version__", "unknown"))
        flint_error = None
    except Exception as exc:
        flint_import = False
        flint_version = None
        flint_error = f"{type(exc).__name__}: {exc}"
    has_flint = bool(getattr(cc_op, "HAS_FLINT", False))
    pkg_flint_version = getattr(cc_op, "_FLINT_VERSION", None)
    passed = bool(flint_import and has_flint)
    out = {
        "statement": ("`import flint` succeeds AND "
                      "connes_cvs.operator.HAS_FLINT is True"),
        "flint_import_ok": flint_import,
        "flint_version": flint_version,
        "flint_import_error": flint_error,
        "connes_cvs_HAS_FLINT": has_flint,
        "connes_cvs_reported_flint_version": (
            None if pkg_flint_version is None else str(pkg_flint_version)),
        "passed": passed,
        "fallback_note": ("when HAS_FLINT is False the digamma evaluations "
                          "take the mpmath fallback and the run is roughly "
                          "2.7x slower; the run is NOT stopped"),
    }
    print("\n" + "-" * 78, flush=True)
    print("GATE A — is flint actually in use?", flush=True)
    print("-" * 78, flush=True)
    print(f"  import flint                      : "
          f"{'OK' if flint_import else 'FAILED'}"
          f"{'' if flint_import else '  (' + str(flint_error) + ')'}",
          flush=True)
    print(f"  flint.__version__                 : {flint_version}", flush=True)
    print(f"  connes_cvs.operator.HAS_FLINT     : {has_flint}", flush=True)
    print(f"  connes_cvs reported flint version : {pkg_flint_version}",
          flush=True)
    if passed:
        print("  GATE A: PASS — flint is in use.", flush=True)
    else:
        print("  " + "!" * 70, flush=True)
        print("  !!  GATE A: FAIL — connes_cvs is NOT using flint.", flush=True)
        print("  !!  The run takes the mpmath digamma fallback and is roughly",
              flush=True)
        print("  !!  2.7x SLOWER. The run continues; budget accordingly.",
              flush=True)
        print("  " + "!" * 70, flush=True)
    return out


# --------------------------------------------------------------------------
# GATE B — read O8's recorded eigenvalue OUT OF THE LOG, do not hardcode it
# --------------------------------------------------------------------------
def read_o8_eigenvalue():
    """
    Parse 'smallest even-sector eigenvalue: <value>' out of the O8 logs.

    Returns (value_str, file_path, line_number_1based) or (None, None, None).
    The file and line actually used are recorded in the payload so the number
    is traceable rather than asserted.
    """
    for name in GATE_B_LOGS:
        path = os.path.join(_HERE, name)
        try:
            with open(path, "r") as fh:
                for ln, line in enumerate(fh, start=1):
                    m = GATE_B_PATTERN.search(line)
                    if m:
                        return m.group(1).strip(), path, ln
        except OSError:
            continue
    return None, None, None


def gate_b(lam_c13, args):
    """Compare our c=13 eigenvalue against the one recorded in the O8 log."""
    val_str, path, ln = read_o8_eigenvalue()
    out = {
        "statement": ("at c = 13 the smallest even-sector eigenvalue "
                      "reproduces the value recorded in the O8 log to at "
                      "least 6 significant figures "
                      f"(relative tolerance {GATE_B_RELTOL:g})"),
        "source_file": path,
        "source_line": ln,
        "source_line_text": None,
        "expected_str": val_str,
        "expected": None,
        "ours_str": _s(lam_c13, 25),
        "ours": _f(lam_c13),
        "relative_difference": None,
        "reltol": GATE_B_RELTOL,
        "passed": None,
        "parameter_difference": {
            "o8_N": GATE_B_O8_N, "o8_T": GATE_B_O8_T,
            "o8_dps": list(GATE_B_O8_DPS),
            "this_run_N": int(args.N), "this_run_T": int(args.T),
            "this_run_dps": int(args.dps),
            "note": ("the O8 runs used N = 100, T = 800 at dps = 300 and "
                     "dps = 150; this script defaults to T = 400. A mismatch "
                     "under a different T is a PARAMETER MISMATCH, not a "
                     "failure of the package"),
        },
        "verdict": None,
    }
    print("\n" + "-" * 78, flush=True)
    print("GATE B — reproduce O8's recorded eigenvalue at c = 13", flush=True)
    print("-" * 78, flush=True)
    if path is not None and ln is not None:
        try:
            with open(path, "r") as fh:
                lines = fh.readlines()
            out["source_line_text"] = lines[ln - 1].rstrip("\n")
        except OSError:
            pass
    if val_str is None:
        out["verdict"] = "UNAVAILABLE"
        out["unavailable_reason"] = (
            "no 'smallest even-sector eigenvalue:' line found in "
            + ", ".join(GATE_B_LOGS))
        print(f"  expected value: NOT FOUND in {', '.join(GATE_B_LOGS)}",
              flush=True)
        print("  GATE B: UNAVAILABLE (expected value could not be read)",
              flush=True)
        return out
    print(f"  expected read from : {path}:{ln}", flush=True)
    print(f"  that line reads    : {out['source_line_text']!r}", flush=True)
    if lam_c13 is None:
        out["verdict"] = "NOT RUN"
        out["unavailable_reason"] = "c = 13 was not among the cutoffs that ran"
        print("  c = 13 did not run; gate B not evaluated.", flush=True)
        return out
    expected = mp.mpf(val_str)
    out["expected"] = _f(expected)
    rel = _safe_div(abs(lam_c13 - expected), abs(expected))
    out["relative_difference"] = rel
    ok = (math.isfinite(rel) and rel < GATE_B_RELTOL)
    out["passed"] = bool(ok)
    out["verdict"] = "PASS" if ok else "MISMATCH"
    print(f"  O8 recorded  : {val_str}", flush=True)
    print(f"  ours         : {_s(lam_c13, 12)}", flush=True)
    print(f"  |ours - O8| / |O8| = {rel:.6g}   (tolerance {GATE_B_RELTOL:g})",
          flush=True)
    if ok:
        print("  GATE B: PASS", flush=True)
    else:
        print("  GATE B: MISMATCH", flush=True)
        print(f"    O8 runs : N = {GATE_B_O8_N}, T = {GATE_B_O8_T}, "
              f"dps in {GATE_B_O8_DPS}", flush=True)
        print(f"    this run: N = {args.N}, T = {args.T}, dps = {args.dps}",
              flush=True)
        print("    STATED, not adjudicated: a different T is a parameter "
              "difference,", flush=True)
        print("    not a failure of the package.", flush=True)
    return out


# --------------------------------------------------------------------------
# Even-sector spectrum — replicates connes_cvs operator.py:684-697 VERBATIM
# --------------------------------------------------------------------------
def even_sector_spectrum(Q):
    """
    The FULL even-sector spectrum of Q, ascending.

    The package's public API returns only the minimum (compute_ground_state,
    operator.py:697-722). This replicates the package's OWN projector — the
    V_even of operator.py:684-694, column 0 = e_0 and column k = (e_k +
    e_{-k})/sqrt(2) — forms Q_even = V_even^T Q V_even, and calls mp.eigsy on
    that same matrix, which is the same call the package makes at
    operator.py:697. It is NOT a different matrix.
    """
    DIM = Q.rows
    N = (DIM - 1) // 2
    V_even = mp.matrix(DIM, N + 1)
    V_even[N, 0] = mp.mpf(1)
    inv_sqrt2 = 1 / mp.sqrt(2)
    for k in range(1, N + 1):
        V_even[N + k, k] = inv_sqrt2
        V_even[N - k, k] = inv_sqrt2
    Q_even = V_even.T * Q * V_even
    eigs, _vecs = mp.eigsy(Q_even)
    vals = [eigs[i] for i in range(N + 1)]
    vals.sort()
    return vals


# --------------------------------------------------------------------------
# One cutoff
# --------------------------------------------------------------------------
def run_cutoff(c, args):
    """
    Everything measured at one cutoff. Returns a dict; never raises for a
    non-converged zero — such a record is written with a marker instead.
    """
    block = {"c": int(c)}
    plist = primes_up_to(c)
    block["primes_in_window"] = plist
    block["n_primes_in_window"] = len(plist)
    block["d"] = bridge_d(c)

    print("\n" + "=" * 78, flush=True)
    print(f"CUTOFF c = {c}", flush=True)
    print("=" * 78, flush=True)
    print(f"  primes <= {c} : {plist}   (n = {len(plist)})", flush=True)
    print(f"  bridge coordinate d = 2*log2(c) - 1 = {block['d']:.10f}   "
          "(O19's axis)", flush=True)
    print(f"  N = {args.N}, T = {args.T}, dps = {args.dps}", flush=True)

    # ---- build Q --------------------------------------------------------
    print("\n  building the CvS Galerkin matrix Q(c)...", flush=True)
    t0 = time.time()
    Q = cc.build_galerkin_matrix(c, N=args.N, T=args.T, dps=args.dps)
    t_build = time.time() - t0
    block["Q_rows"] = int(Q.rows)
    block["build_seconds"] = t_build
    print(f"  Q is {Q.rows} x {Q.cols}   (build: {t_build:.2f} s)", flush=True)

    # ---- GATE C ---------------------------------------------------------
    sym = frob(Q - Q.T) / frob(Q)
    sym_f = _f(sym)
    gate_c_ok = (sym_f is not None and sym_f == 0.0)
    block["gate_c"] = {
        "statement": "||Q - Q^T|| / ||Q|| == 0 exactly",
        "symmetry_ratio": sym_f,
        "symmetry_ratio_str": _s(sym, 12),
        "passed": bool(gate_c_ok),
    }
    print(f"  GATE C — ||Q - Q^T|| / ||Q|| = {_s(sym, 6)}   "
          f"-> {'PASS' if gate_c_ok else 'FAIL'}", flush=True)

    # ---- ground state (package public API) ------------------------------
    print("  computing ground state (cc.compute_ground_state)...", flush=True)
    t0 = time.time()
    lam, vec = cc.compute_ground_state(Q)
    t_ground = time.time() - t0
    block["ground_state_seconds"] = t_ground
    block["lambda_1"] = _f(lam)
    block["lambda_1_str"] = _s(lam, 25)
    log10_lam = mp.log10(abs(lam)) if lam != 0 else None
    block["log10_abs_lambda_1"] = _f(log10_lam)
    print(f"  smallest even-sector eigenvalue: {_s(lam, 10)}   "
          f"({t_ground:.2f} s)", flush=True)
    print(f"  log10 |lambda_1| = {_s(log10_lam, 8)}", flush=True)

    # ---- full even-sector spectrum -> THE SPECTRAL GAP -------------------
    print("  computing the FULL even-sector spectrum (mp.eigsy on the "
          "package's own", flush=True)
    print("  projected matrix, operator.py:684-697) for the spectral gap...",
          flush=True)
    t0 = time.time()
    vals = even_sector_spectrum(Q)
    t_spec = time.time() - t0
    block["spectrum_seconds"] = t_spec
    lam1 = vals[0]
    lam2 = vals[1] if len(vals) > 1 else None
    rep_rel = _safe_div(abs(lam1 - lam), abs(lam))
    block["even_sector_replication"] = {
        "statement": ("min of the replicated even-sector spectrum equals the "
                      "lambda returned by cc.compute_ground_state"),
        "package_lambda_str": _s(lam, 25),
        "replicated_min_str": _s(lam1, 25),
        "relative_difference": rep_rel,
        "agrees_to_1e-12": bool(math.isfinite(rep_rel) and rep_rel < 1e-12),
        "api_note": ("connes_cvs 0.3.1 exposes no public accessor for the "
                     "second eigenvalue; compute_ground_state returns only "
                     "(lambda_min, v_full). This is the package's OWN "
                     "projector and the package's OWN mp.eigsy call, not a "
                     "different matrix"),
    }
    block["n_even_eigenvalues"] = len(vals)
    block["lambda_2"] = _f(lam2)
    block["lambda_2_str"] = _s(lam2, 25)
    if lam2 is not None:
        gap = lam2 - lam1
        block["gap_absolute"] = _f(gap)
        block["gap_absolute_str"] = _s(gap, 25)
        block["gap_ratio_lambda2_over_lambda1"] = _safe_div(lam2, lam1)
        block["gap_ratio_str"] = _s(lam2 / lam1, 25) if lam1 != 0 else None
        block["log10_gap_ratio"] = _f(mp.log10(abs(lam2 / lam1))
                                      if lam1 != 0 and lam2 != 0 else None)
    else:
        block["gap_absolute"] = None
        block["gap_absolute_str"] = None
        block["gap_ratio_lambda2_over_lambda1"] = None
        block["gap_ratio_str"] = None
        block["log10_gap_ratio"] = None
    block["smallest_five_eigenvalues_str"] = [_s(v, 20) for v in vals[:5]]
    print(f"  even sector has {len(vals)} eigenvalues   ({t_spec:.2f} s)",
          flush=True)
    print(f"  replication check: |min(replicated) - lambda_pkg| / |lambda_pkg| "
          f"= {rep_rel:.6g}", flush=True)
    print(f"  lambda_1 = {_s(lam1, 12)}", flush=True)
    print(f"  lambda_2 = {_s(lam2, 12)}", flush=True)
    print(f"  gap  lambda_2 - lambda_1 = {_s(lam2 - lam1, 12)}"
          if lam2 is not None else "  gap: unavailable", flush=True)
    print(f"  ratio lambda_2 / lambda_1 = {_s(lam2 / lam1, 12)}"
          if (lam2 is not None and lam1 != 0) else "  ratio: unavailable",
          flush=True)
    print("  five smallest even-sector eigenvalues:", flush=True)
    for i, v in enumerate(vals[:5], start=1):
        print(f"    lambda_{i} = {_s(v, 20)}", flush=True)

    # ---- zeros ----------------------------------------------------------
    print(f"\n  extracting {args.n_zeros} zeros from the ground-state "
          "eigenvector...", flush=True)
    t0 = time.time()
    zero_rows = []
    try:
        zs = cc.extract_zeros(vec, n_zeros=args.n_zeros, dps=args.dps, c=c)
        block["extract_zeros_error"] = None
    except Exception as exc:
        zs = []
        block["extract_zeros_error"] = f"{type(exc).__name__}: {exc}"
        print(f"  zero extraction RAISED: {block['extract_zeros_error']}",
              flush=True)
    t_zeros = time.time() - t0
    block["extract_zeros_seconds"] = t_zeros

    # Records are DICTS. Index by key. Never mp.mpf() a record.
    for i, z in enumerate(zs, start=1):
        if not isinstance(z, dict):
            zero_rows.append({
                "k": i, "converged": False,
                "failure": f"record is not a dict: {type(z).__name__}",
                "gamma_true": None, "gamma_detected": None,
                "error": None, "residual": None, "tolerance": None,
                "marker": "NON-DICT RECORD",
            })
            continue
        conv = z.get("converged")
        row = {
            "k": int(z.get("k", i)),
            "gamma_true": _f(z.get("gamma_true")),
            "gamma_true_str": _s(z.get("gamma_true"), 25),
            "gamma_detected": _f(z.get("gamma_detected")),
            "gamma_detected_str": _s(z.get("gamma_detected"), 25),
            "error": _f(z.get("error")),
            "error_str": _s(z.get("error"), 12),
            "residual": _f(z.get("residual")),
            "residual_str": _s(z.get("residual"), 12),
            "tolerance": _f(z.get("tolerance")),
            "tolerance_str": _s(z.get("tolerance"), 12),
            "converged": (True if conv is True else False),
            "converged_raw": (None if conv is None else str(conv)),
            "failure": (None if z.get("failure") is None
                        else str(z.get("failure"))),
            "marker": (None if conv is True else "NOT CONVERGED"),
        }
        zero_rows.append(row)
    block["zeros"] = zero_rows
    n_conv = sum(1 for r in zero_rows if r["converged"])
    block["n_zeros_converged"] = n_conv
    block["n_zeros_returned"] = len(zero_rows)
    first = next((r for r in zero_rows if r["k"] == 1), None)
    block["first_zero_error"] = (first or {}).get("error")
    block["first_zero_error_str"] = (first or {}).get("error_str")
    block["first_zero_converged"] = bool((first or {}).get("converged"))

    print(f"  ({t_zeros:.2f} s; {n_conv} of {len(zero_rows)} converged)",
          flush=True)
    print(f"\n  {'k':>3} {'gamma_true':>26} {'gamma_detected':>26} "
          f"{'|error|':>22} {'converged':>10}", flush=True)
    print(f"  {'-'*3} {'-'*26} {'-'*26} {'-'*22} {'-'*10}", flush=True)
    for r in zero_rows:
        gt = r["gamma_true_str"] or "—"
        gd = r["gamma_detected_str"] or "NOT CONVERGED"
        er = r["error_str"] or (r["failure"] or "—")
        print(f"  {r['k']:>3} {gt[:26]:>26} {gd[:26]:>26} "
              f"{str(er)[:22]:>22} {str(r['converged']):>10}", flush=True)

    block["wall_seconds"] = t_build + t_ground + t_spec + t_zeros
    print(f"\n  cutoff c = {c} total wall: {block['wall_seconds']:.2f} s",
          flush=True)

    if int(c) == CONNES_CUTOFF:
        print(f"\n  CONNES COMPARISON at c = {CONNES_CUTOFF} "
              "(arXiv:2602.04022v1, §6):", flush=True)
        print(f"    his first-zero error : {CONNES_FIRST_ZERO_ERROR_C13:.6g}",
              flush=True)
        print(f"    ours                 : "
              f"{block['first_zero_error_str'] or 'not converged'}",
              flush=True)
        print("    Both numbers are STATED. This script does not interpret "
              "them.", flush=True)
    return block


def main():
    ap = argparse.ArgumentParser(
        description="O20 — Connes cutoff sweep: accuracy curve and spectral "
                    "gap of the truncated Weil form as the prime cutoff c "
                    "grows. Measures; does not interpret.")
    ap.add_argument("--cutoffs", type=str, default=DEFAULT_CUTOFFS,
                    help="comma-separated PRIME CUTOFFS c (Connes' lambda); "
                         f"default '{DEFAULT_CUTOFFS}'")
    ap.add_argument("--N", type=int, default=100,
                    help="trigonometric truncation; the matrix is 2N+1 square. "
                         "Default 100 (Connes' footnote 14 says N = 100)")
    ap.add_argument("--T", type=int, default=400,
                    help="archimedean truncation (default 400; NOTE the O8 "
                         "runs used T = 800 — see gate B)")
    ap.add_argument("--dps", type=int, default=150,
                    help="mpmath decimal precision (default 150)")
    ap.add_argument("--n-zeros", type=int, default=5,
                    help="number of zeros extracted per cutoff (default 5)")
    ap.add_argument("--budget-minutes", type=float, default=45.0,
                    help="stop STARTING new cutoffs once elapsed exceeds this "
                         "(default 45). A cutoff already under way always "
                         "finishes; skipped cutoffs are recorded")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON")
    args = ap.parse_args()

    if args.N < 1:
        raise SystemExit(f"--N {args.N} must be >= 1")
    if args.T < 1:
        raise SystemExit(f"--T {args.T} must be >= 1")
    if args.dps < 15:
        raise SystemExit(f"--dps {args.dps} is below connes_cvs' minimum 15")
    if args.n_zeros < 1:
        raise SystemExit(f"--n-zeros {args.n_zeros} must be >= 1")
    if args.budget_minutes <= 0:
        raise SystemExit(f"--budget-minutes {args.budget_minutes} must be > 0")

    cutoffs = parse_cutoffs(args.cutoffs)
    out_path = args.out or DEFAULT_OUT
    started = datetime.now(timezone.utc)
    t_start = time.time()

    print("=" * 78, flush=True)
    print("O20 — Connes cutoff sweep  (measures an accuracy curve and a "
          "spectral gap;", flush=True)
    print("      proves nothing, interprets nothing)", flush=True)
    print("=" * 78, flush=True)
    print("  Connes, arXiv:2602.04022v1, §5, verbatim:", flush=True)
    print('    "What we do not know is that, when we increase the upper '
          'limit, which was', flush=True)
    print('     x = 13 here, the corresponding set of zeros will converge '
          'towards the', flush=True)
    print('     zeros of zeta. This is something which at this point is not '
          'proved."', flush=True)
    print("  §6.6, verbatim:", flush=True)
    print('    "one needs to show that the smallest eigenvalue of the Weil '
          'quadratic form', flush=True)
    print('     QW_lambda is simple with even eigenvector"', flush=True)
    print("", flush=True)
    print(f"  cutoffs        : {cutoffs}", flush=True)
    print(f"  N              : {args.N}   (matrix is {2*args.N+1} square)",
          flush=True)
    print(f"  T              : {args.T}", flush=True)
    print(f"  dps            : {args.dps}", flush=True)
    print(f"  n_zeros        : {args.n_zeros}", flush=True)
    print(f"  budget-minutes : {args.budget_minutes}", flush=True)
    print(f"  connes_cvs     : {getattr(cc, '__version__', 'unknown')}",
          flush=True)
    print(f"  mpmath         : {getattr(mp, '__version__', 'unknown')}",
          flush=True)

    ga = gate_a()

    blocks = []
    skipped = []
    for c in cutoffs:
        elapsed_min = (time.time() - t_start) / 60.0
        if elapsed_min > args.budget_minutes:
            skipped.append(int(c))
            print(f"\n  BUDGET — {elapsed_min:.2f} min elapsed exceeds "
                  f"--budget-minutes {args.budget_minutes}; SKIPPING c = {c}",
                  flush=True)
            continue
        try:
            blocks.append(run_cutoff(c, args))
        except Exception as exc:
            print(f"\n  cutoff c = {c} FAILED: {type(exc).__name__}: {exc}",
                  flush=True)
            blocks.append({"c": int(c), "failed": True,
                           "failure": f"{type(exc).__name__}: {exc}",
                           "primes_in_window": primes_up_to(c),
                           "n_primes_in_window": len(primes_up_to(c)),
                           "d": bridge_d(c), "zeros": []})

    # ---- GATE B ---------------------------------------------------------
    lam_c13 = None
    for b in blocks:
        if int(b.get("c", -1)) == GATE_B_C and not b.get("failed"):
            s = b.get("lambda_1_str")
            if s is not None:
                lam_c13 = mp.mpf(s)
            break
    gb = gate_b(lam_c13, args)

    # ---- gate C roll-up --------------------------------------------------
    gc_rows = [{"c": b["c"],
                "symmetry_ratio": (b.get("gate_c") or {}).get("symmetry_ratio"),
                "passed": (b.get("gate_c") or {}).get("passed")}
               for b in blocks if not b.get("failed")]
    gc_all = (all(bool(r["passed"]) for r in gc_rows) if gc_rows else None)
    print("\n" + "-" * 78, flush=True)
    print("GATE C — Q symmetric at every cutoff "
          "(||Q - Q^T|| / ||Q|| == 0 exactly)", flush=True)
    print("-" * 78, flush=True)
    for r in gc_rows:
        print(f"  c = {r['c']:>4}   ratio = {_fmtg(r['symmetry_ratio'], 12, 6)}"
              f"   -> {'PASS' if r['passed'] else 'FAIL'}", flush=True)
    print(f"  GATE C overall: "
          f"{'PASS' if gc_all else ('FAIL' if gc_rows else 'NOT RUN')}",
          flush=True)

    # ---- summary table ---------------------------------------------------
    print("\n" + "=" * 78, flush=True)
    print("SWEEP SUMMARY — one row per cutoff", flush=True)
    print("=" * 78, flush=True)
    print(f"  {'c':>4} {'n_p':>4} {'d':>9} {'Qrows':>6} {'lambda_1':>15} "
          f"{'log10|l1|':>11} {'lambda_2':>15} {'gap':>15} {'l2/l1':>13} "
          f"{'first-zero err':>15} {'wall s':>9}", flush=True)
    print(f"  {'-'*4} {'-'*4} {'-'*9} {'-'*6} {'-'*15} {'-'*11} {'-'*15} "
          f"{'-'*15} {'-'*13} {'-'*15} {'-'*9}", flush=True)
    for b in blocks:
        if b.get("failed"):
            print(f"  {b['c']:>4} {b['n_primes_in_window']:>4} "
                  f"{b['d']:>9.5f}   FAILED: {b['failure']}", flush=True)
            continue
        print(f"  {b['c']:>4} {b['n_primes_in_window']:>4} {b['d']:>9.5f} "
              f"{b['Q_rows']:>6} {_fmtg(b['lambda_1'], 15, 8)} "
              f"{_fmtg(b['log10_abs_lambda_1'], 11, 8)} "
              f"{_fmtg(b['lambda_2'], 15, 8)} "
              f"{_fmtg(b['gap_absolute'], 15, 8)} "
              f"{_fmtg(b['gap_ratio_lambda2_over_lambda1'], 13, 6)} "
              f"{_fmtg(b['first_zero_error'], 15, 6)} "
              f"{b['wall_seconds']:>9.2f}", flush=True)
    if skipped:
        print(f"\n  SKIPPED by the {args.budget_minutes}-minute budget: "
              f"{skipped}", flush=True)
    else:
        print("\n  no cutoff was skipped by the budget.", flush=True)

    # ---- monotonicity of the first-zero error, as a STATED FACT ----------
    ok_blocks = [b for b in blocks
                 if not b.get("failed") and b.get("first_zero_error") is not None]
    errs = [(b["c"], b["first_zero_error"]) for b in ok_blocks]
    mono_dec = (all(errs[i + 1][1] < errs[i][1] for i in range(len(errs) - 1))
                if len(errs) >= 2 else None)
    ratios = [(b["c"], b["gap_ratio_lambda2_over_lambda1"]) for b in blocks
              if not b.get("failed")
              and b.get("gap_ratio_lambda2_over_lambda1") is not None]
    ratio_min = min((r for _, r in ratios), default=None)
    print("\n" + "-" * 78, flush=True)
    print("STATED FACTS (mechanical; NOT interpreted here)", flush=True)
    print("-" * 78, flush=True)
    print(f"  first-zero error, cutoff-ordered : "
          f"{[(c, f'{e:.6g}') for c, e in errs]}", flush=True)
    print(f"  strictly decreasing in c?        : {mono_dec}", flush=True)
    print(f"  gap ratio lambda_2/lambda_1      : "
          f"{[(c, f'{r:.6g}') for c, r in ratios]}", flush=True)
    print(f"  smallest ratio over the sweep    : "
          f"{'—' if ratio_min is None else format(ratio_min, '.6g')}",
          flush=True)

    total_wall = time.time() - t_start
    print(f"\n  total wall: {total_wall:.2f} s "
          f"({total_wall/60.0:.2f} min)", flush=True)

    if args.no_json:
        print("\n  --no-json: results JSON not written.", flush=True)
        return

    rows = []
    for b in blocks:
        base = {
            "c": b["c"],
            "n_primes_in_window": b["n_primes_in_window"],
            "primes_in_window": b["primes_in_window"],
            "d": b["d"],
            "Q_rows": b.get("Q_rows"),
            "lambda_1": b.get("lambda_1"),
            "lambda_1_str": b.get("lambda_1_str"),
            "log10_abs_lambda_1": b.get("log10_abs_lambda_1"),
            "lambda_2": b.get("lambda_2"),
            "lambda_2_str": b.get("lambda_2_str"),
            "gap_absolute": b.get("gap_absolute"),
            "gap_ratio_lambda2_over_lambda1":
                b.get("gap_ratio_lambda2_over_lambda1"),
            "cutoff_failed": bool(b.get("failed", False)),
            "cutoff_failure": b.get("failure"),
        }
        zs = b.get("zeros") or []
        if not zs:
            r = dict(base)
            r.update({"k": None, "gamma_true": None, "gamma_detected": None,
                      "error": None, "residual": None, "converged": None,
                      "zero_failure": "no zero record for this cutoff",
                      "marker": "NO ZEROS"})
            rows.append(r)
            continue
        for z in zs:
            r = dict(base)
            r.update({
                "k": z.get("k"),
                "gamma_true": z.get("gamma_true"),
                "gamma_true_str": z.get("gamma_true_str"),
                "gamma_detected": z.get("gamma_detected"),
                "gamma_detected_str": z.get("gamma_detected_str"),
                "error": z.get("error"),
                "error_str": z.get("error_str"),
                "residual": z.get("residual"),
                "residual_str": z.get("residual_str"),
                "tolerance": z.get("tolerance"),
                "converged": z.get("converged"),
                "zero_failure": z.get("failure"),
                "marker": z.get("marker"),
            })
            rows.append(r)

    payload = {
        "schema_version": "1",
        "script": os.path.basename(os.path.abspath(__file__)),
        "generated_utc": started.isoformat().replace("+00:00", "Z"),
        "params": {
            "code_version": _code_version(),
            "cutoffs_requested": cutoffs,
            "cutoffs_raw": str(args.cutoffs),
            "N": int(args.N),
            "T": int(args.T),
            "dps": int(args.dps),
            "n_zeros": int(args.n_zeros),
            "budget_minutes": float(args.budget_minutes),
            "out": out_path,
            "connes_cvs_version": str(getattr(cc, "__version__", "unknown")),
            "mpmath_version": str(getattr(mp, "__version__", "unknown")),
            "call_sequence": ("cc.build_galerkin_matrix(c, N, T, dps) -> "
                              "cc.compute_ground_state(Q) -> "
                              "cc.extract_zeros(vec, n_zeros, dps, c); "
                              "mirrors O8_weil_inner_product.py"),
            "spectral_gap_method": (
                "the package exposes no public accessor for the second "
                "eigenvalue; this script replicates connes_cvs "
                "operator.py:684-694's own V_even projector, forms "
                "Q_even = V_even^T Q V_even, and calls mp.eigsy on that same "
                "matrix (the same call the package makes at operator.py:697). "
                "The replication is checked every run against the lambda the "
                "package returned"),
            "bridge_coordinate": ("d = 2*log2(c) - 1, from "
                                  "lambda = 2^((d+1)/2); the axis "
                                  "O19_bridge_figure.py uses"),
            "precision": (
                f"mixed: connes_cvs arbitrary precision at mp.dps = "
                f"{args.dps} for the Galerkin matrix, the even-sector "
                f"eigensolve and the zero extraction (flint Arb backend when "
                f"connes_cvs.operator.HAS_FLINT, see gate A; flint working "
                f"precision is int(3.5*dps) by the package's default); "
                f"full-precision decimal strings kept in *_str fields; "
                f"float64 in the plain numeric fields and in every printed "
                f"table"),
        },
        "constants": {
            "connes_reference": ("A. Connes, 'The Riemann Hypothesis: Past, "
                                 "Present and a Letter Through Time', "
                                 "arXiv:2602.04022v1, 3 Feb 2026"),
            "connes_open_question_section_5": (
                "What we do not know is that, when we increase the upper "
                "limit, which was x = 13 here, the corresponding set of zeros "
                "will converge towards the zeros of zeta. This is something "
                "which at this point is not proved."),
            "connes_missing_hypothesis_section_6_6": (
                "one needs to show that the smallest eigenvalue of the Weil "
                "quadratic form QW_lambda is simple with even eigenvector"),
            "connes_cutoff": CONNES_CUTOFF,
            "connes_first_zero_error_c13": CONNES_FIRST_ZERO_ERROR_C13,
            "connes_first_50_zero_error_range": list(CONNES_ERROR_RANGE),
            "theorem_6_1_hypothesis": (
                "Theorem 6.1 (Connes & van Suijlekom) puts the zeros on the "
                "critical line PROVIDED the smallest eigenvalue is simple, "
                "isolated, and has an even eigenfunction. The spectral gap "
                "measured here is the quantity that hypothesis requires"),
            "o10_note": ("O10 is a deliberate gap in the series and is not "
                         "filled by this script"),
            "proves_nothing_note": (
                "this script measures; it proves nothing and interprets "
                "nothing. No verdict is stamped anywhere in it"),
            "extract_zeros_record_note": (
                "extract_zeros returns a LIST OF PER-ZERO DICTS with keys k, "
                "gamma_true, gamma_detected, error, residual, converged, "
                "failure, tolerance (operator.py:779-785). Records are "
                "indexed by key; mp.mpf() is never called on a record"),
        },
        "summary": {
            "n_cutoffs_requested": len(cutoffs),
            "n_cutoffs_completed": len([b for b in blocks
                                        if not b.get("failed")]),
            "cutoffs_completed": [b["c"] for b in blocks
                                  if not b.get("failed")],
            "cutoffs_failed": [b["c"] for b in blocks if b.get("failed")],
            "cutoffs_skipped": skipped,
            "budget_minutes": float(args.budget_minutes),
            "total_wall_seconds": total_wall,
            "per_cutoff": blocks,
            "first_zero_error_by_cutoff": [
                {"c": c, "first_zero_error": e} for c, e in errs],
            "first_zero_error_strictly_decreasing_in_c": mono_dec,
            "gap_ratio_by_cutoff": [
                {"c": c, "ratio_lambda2_over_lambda1": r} for c, r in ratios],
            "gap_ratio_min_over_sweep": ratio_min,
            "connes_comparison_c13": {
                "connes_first_zero_error": CONNES_FIRST_ZERO_ERROR_C13,
                "ours_first_zero_error": next(
                    (b.get("first_zero_error") for b in blocks
                     if int(b.get("c", -1)) == CONNES_CUTOFF), None),
                "ours_first_zero_error_str": next(
                    (b.get("first_zero_error_str") for b in blocks
                     if int(b.get("c", -1)) == CONNES_CUTOFF), None),
                "note": "both numbers stated; not interpreted here",
            },
            "gate_a": ga,
            "gate_b": gb,
            "gate_c": {
                "statement": "||Q - Q^T|| / ||Q|| == 0 exactly at every cutoff",
                "per_cutoff": gc_rows,
                "passed": (None if not gc_rows else bool(gc_all)),
            },
        },
        "rows": rows,
    }
    _write_results(payload, out_path)


if __name__ == "__main__":
    main()
