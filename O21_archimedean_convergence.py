#!/usr/bin/env python3
"""
O21 — Pin the archimedean cutoff T, then re-stand the c-accuracy curve on it.

Reads with: O20_connes_cutoff_sweep.py (this script REUSES its machinery — the
even-sector V_even replication, the gates, the envelope helpers — and reads its
recorded T = 400 numbers out of results/O20_connes_cutoff_sweep_results.json
rather than hardcoding them); O8_weil_inner_product.py (the original
connes_cvs caller in this tree, and the source of the T = 800 numbers quoted
below via O8_run_dps150.log); REFERENCES.md § "Packages and environment"
(connes-cvs 0.3.1, python-flint 0.9.0).

NAMING
------
The O-series in this tree runs O1-O9 and O11-O20.  There is NO O10: that number
is a KNOWN, DELIBERATE GAP in this tree, and this script does not fill it.  The
next free number after O20 is O21; this file takes it.  Capital "O" per
`CLAUDE.md` § "Naming convention (do not re-break)".

=============================================================================
WHY THIS EXISTS
=============================================================================

O20 swept the prime cutoff c at fixed archimedean cutoff T = 400 and found the
first-zero error falling 65 orders of magnitude, 1.45e-55 at c = 13 down to
3.23e-120 at c = 29.  But T is not pinned, and it is not behaving as a
convergent truncation should.  At c = 13, N = 100, dps = 150, the same package
gives

    T = 400   lambda_1 = 2.0770e-59   first-zero error 1.455e-55   (O20)
    T = 800   lambda_1 = 2.8655e-59   first-zero error 2.005e-55   (O8_run_dps150.log)

Doubling T moved lambda_1 by 27.5% and made the first-zero error WORSE.  T
truncates the archimedean integral in the Weil explicit formula's W_R term, so
larger T is strictly MORE of that integral; a converged construction should be
insensitive to doubling it.  Until T is pinned, every absolute number in O20
sits on an arbitrary choice.

This script sweeps T at fixed c to find where lambda_1 settles, then re-runs
the c sweep at the settled T so the accuracy curve stands on a converged
parameter.

IT PROVES NOTHING and INTERPRETS NOTHING.  It measures where a truncation
parameter stops moving the answer, applies a criterion fixed before the run,
and records the result.  No verdict is stamped anywhere in this file.

=============================================================================
PHASE 1 — T sweep at fixed c.  RUNS FIRST.
=============================================================================

At fixed --c-fixed (default 13), --N 100, --dps 150, sweep --tvals (default
"100,200,400,800,1600,3200").  Per T recorded: T, wall seconds, Q.rows, the
symmetry check ||Q - Q^T|| / ||Q||, lambda_1, log10|lambda_1|, lambda_2 and the
gap ratio lambda_2/lambda_1, and the per-zero records from extract_zeros for
--n-zeros zeros.

The lambda_2 / gap comes from the SAME replicated V_even projector approach O20
uses: the package's public API (compute_ground_state) returns only
(lambda_min, v_full) and discards the rest of the spectrum
(connes_cvs/operator.py:697-722), so `even_sector_spectrum` below replicates
the package's OWN projector (operator.py:684-694, column 0 = e_0 and column
k = (e_k + e_{-k})/sqrt(2)), forms Q_even = V_even^T Q V_even, and calls
mp.eigsy on THAT SAME MATRIX — the same call the package makes at
operator.py:697.  It is NOT a different matrix.  The replication is VERIFIED AT
EVERY POINT against the lambda the package returned and recorded as
`even_sector_replication`.

PRE-REGISTERED CONVERGENCE CRITERION.  Fixed here, before the run, and applied
mechanically:

    lambda_1 is SETTLED at T if the relative change from the previous T in the
    sweep is below --settle-tol (default 1e-3), AND the same holds for the T
    before it — i.e. TWO CONSECUTIVE DOUBLINGS each move lambda_1 by less than
    the tolerance.  The settled T is the FIRST T in sweep order at which this
    holds.  It needs at least three completed points to be evaluable.

The script reports the settled T, or states that NO T in the sweep settled.
The SAME criterion is applied SEPARATELY to the first-zero error, because the
two quantities need not settle together.

=============================================================================
PHASE 2 — c sweep at the settled T
=============================================================================

Re-runs the O20 sweep --cutoffs (default "13,17,19,23,29") at T = the settled T
from phase 1.  If nothing settled, it uses the LARGEST T that completed and
records `t_settled: null` together with an explicit note that the c curve then
stands on an UNCONVERGED T.

The same per-c fields O20 recorded are recorded here, so the two runs are
directly comparable, and O20's own T = 400 values are carried alongside each c
where available.  Those values are READ FROM
results/O20_connes_cutoff_sweep_results.json at runtime — NOT hardcoded — and
the file, its generated_utc, and its params (N, T, dps) are recorded so the
comparability of the two sets is stated rather than assumed.

=============================================================================
OVERNIGHT ROBUSTNESS
=============================================================================

This is built to run unattended for hours.

1. CHECKPOINT AFTER EVERY SINGLE (phase, parameter) POINT.  The results JSON is
   rewritten after each point completes, not at the end, via
   write-to-temp-then-os.replace, so the file on disk is NEVER half-written.
   An interrupted run leaves a valid, readable JSON containing everything
   finished so far, with `summary.completed` and `summary.pending` lists.
2. Every print is flush=True.  Each point prints a timestamped START line and a
   timestamped FINISH line with its wall time, so `tail -f` stays legible.
3. --budget-hours (default 8).  Before STARTING each new point the elapsed time
   is checked against a projection of that point's cost (phase 1 projects
   linearly in T off the last completed point; phase 2 uses the last completed
   point's wall).  If starting it would likely exceed the budget the point is
   SKIPPED, recorded with its reason, and the run moves on to the final
   summary.  A point already under way always finishes; no point is ever left
   partial.
4. Every point is wrapped in try/except.  A failure at one T or one c records
   the traceback STRING in that point's record and continues to the next point
   rather than killing the run.
5. KeyboardInterrupt is handled cleanly: the checkpoint is written and the
   script exits with a clear message (exit code 130).
6. A final summary block prints the T table, the settled T, the c table, and
   the comparison against O20.

=============================================================================
GATES — all run inside the script and recorded in the payload
=============================================================================

GATE A — FLINT IS ACTUALLY IN USE.  `import flint` succeeds AND
connes_cvs.operator.HAS_FLINT is True.  Run once, up front.  A False does not
stop the run, but it prints LOUDLY: the run then takes the mpmath digamma
fallback and is roughly 2.7x slower, which matters for an overnight budget.

GATE C — Q SYMMETRIC.  ||Q - Q^T|| / ||Q|| must be 0 EXACTLY, as O8 reported at
c = 13, N = 100, T = 800 (`O8_run_dps150.log:8`).  Checked AT EVERY POINT, both
phases.

GATE R — V_EVEN REPLICATION.  min(replicated even-sector spectrum) must equal
the lambda returned by cc.compute_ground_state.  Checked AT EVERY POINT, both
phases, and rolled up.

(There is no gate B here.  O20's gate B compared c = 13 against the O8 log's
T = 800 value and reported MISMATCH at T = 400 — that mismatch is the very
thing this script exists to resolve, so re-running it as a gate would be
circular.  The same comparison appears instead as a plain recorded cross-check,
`summary.t_sweep.o8_log_cross_check`, with no pass/fail attached.)

=============================================================================
ENVELOPE
=============================================================================

House envelope, schema_version "1": script, generated_utc, params, constants,
summary, flat `rows` (ONE ROW PER (phase, T, c, zero index)).
`params.code_version` is the sha256 of THIS file, read from `__file__` at
runtime.  `params.o20_code_version` is the sha256 of O20 as it stands on disk,
so the "reuses O20's machinery" claim is checkable.

extract_zeros returns a LIST OF PER-ZERO DICTS with keys k, gamma_true,
gamma_detected, error, residual, converged, failure, tolerance
(connes_cvs/operator.py:779-785).  Records are INDEXED BY KEY.  mp.mpf() is
NEVER called on a record — that is the bug that crashed O8's original print
loop, recorded in REFERENCES.md § "API note".

REQUIREMENTS
------------
    connes-cvs, mpmath   (both present in this bench's .venv; python-flint is
    optional but present, see gate A)

USAGE
-----
    ./.venv/bin/python3 O21_archimedean_convergence.py
    ./.venv/bin/python3 O21_archimedean_convergence.py --tvals "50,100" \
        --cutoffs "13" --N 20 --dps 30 --n-zeros 2 --budget-hours 0.2 \
        --out results/O21_smoke.json
"""

import argparse
import hashlib
import json
import math
import os
import time
import traceback
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

# O20's recorded T = 400 sweep. READ at runtime, never hardcoded.
O20_RESULTS = os.path.join(_HERE, "results",
                           "O20_connes_cutoff_sweep_results.json")
O20_SCRIPT = os.path.join(_HERE, "O20_connes_cutoff_sweep.py")

# The T = 800 numbers quoted in the docstring live here. Read, not hardcoded.
O8_LOG = os.path.join(_HERE, "O8_run_dps150.log")
O8_LAM_MARKER = "smallest even-sector eigenvalue:"

# Connes, arXiv:2602.04022v1, §6: the first-zero error at x = 13.
CONNES_FIRST_ZERO_ERROR_C13 = 2.60179e-55
CONNES_CUTOFF = 13

DEFAULT_TVALS = "100,200,400,800,1600,3200"
DEFAULT_CUTOFFS = "13,17,19,23,29"


# --------------------------------------------------------------------------
# House helpers — same shapes O20 uses
# --------------------------------------------------------------------------
def _code_version(path=None):
    """sha256 of a script file, read at runtime. Self-identifying results."""
    try:
        with open(os.path.abspath(path or __file__), "rb") as fh:
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


def _write_results(payload, out_path, quiet=False):
    """
    Write the results envelope ATOMICALLY; never let a write failure kill a
    long run.

    Serialises to <out_path>.tmp and then os.replace()s it into place, so a
    reader (or an interrupt) never sees a half-written file. This is called
    after EVERY point, not once at the end.
    """
    tmp = out_path + ".tmp"
    try:
        d = os.path.dirname(out_path)
        if d:
            os.makedirs(d, exist_ok=True)
        with open(tmp, "w") as fh:
            json.dump(_jsonable(payload), fh, indent=2, sort_keys=False,
                      allow_nan=False)
            fh.flush()
            os.fsync(fh.fileno())
        os.replace(tmp, out_path)
        if not quiet:
            print(f"  [checkpoint] results written to {out_path}", flush=True)
        return True
    except Exception as exc:
        print(f"  WARNING: could not write results JSON to {out_path}: {exc}",
              flush=True)
        try:
            if os.path.exists(tmp):
                os.remove(tmp)
        except OSError:
            pass
        return False


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


def _ts():
    """UTC timestamp for the START/FINISH lines a `tail -f` reader watches."""
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _hms(seconds):
    """Seconds -> compact h:mm:ss, for budget lines."""
    try:
        s = int(max(0.0, float(seconds)))
    except (TypeError, ValueError):
        return "—"
    return f"{s // 3600}h{(s % 3600) // 60:02d}m{s % 60:02d}s"


def frob(M):
    """Frobenius norm of an mpmath matrix. Same helper O8 and O20 use."""
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


def bridge_d(c):
    """d = 2*log2(c) - 1, from lambda = 2^((d+1)/2). O19's axis; O20 records it."""
    return 2.0 * math.log(float(c), 2.0) - 1.0


def parse_int_list(s, flag, minimum):
    """Comma-separated list -> list of ints, order preserved, duplicates kept."""
    out = []
    for tok in str(s).split(","):
        tok = tok.strip()
        if not tok:
            continue
        try:
            v = int(tok)
        except ValueError:
            raise SystemExit(f"{flag}: '{tok}' is not an integer")
        if v < minimum:
            raise SystemExit(f"{flag}: '{tok}' must be >= {minimum}")
        out.append(v)
    if not out:
        raise SystemExit(f"{flag} is empty")
    return out


# --------------------------------------------------------------------------
# GATE A — is flint actually in use?  (O20's gate A, verbatim in behaviour)
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
                          "2.7x slower; the run is NOT stopped, but an "
                          "overnight budget should account for it"),
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
# Even-sector spectrum — replicates connes_cvs operator.py:684-697 VERBATIM.
# Copied from O20_connes_cutoff_sweep.py:498-521 unchanged, so the two scripts
# measure lambda_2 with the identical code path.
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
# Reading the prior record — O20's JSON and O8's log. NOT hardcoded.
# --------------------------------------------------------------------------
def read_o20():
    """
    Load O20's recorded sweep. Returns a dict describing the source and a
    per-c map of its headline numbers, or a dict with `available: False`.
    """
    out = {
        "available": False,
        "source_file": O20_RESULTS,
        "read_error": None,
        "generated_utc": None,
        "params": None,
        "by_c": {},
    }
    try:
        with open(O20_RESULTS, "r") as fh:
            d = json.load(fh)
    except Exception as exc:
        out["read_error"] = f"{type(exc).__name__}: {exc}"
        return out
    try:
        p = d.get("params") or {}
        out["generated_utc"] = d.get("generated_utc")
        out["params"] = {
            "N": p.get("N"), "T": p.get("T"), "dps": p.get("dps"),
            "n_zeros": p.get("n_zeros"),
            "code_version": p.get("code_version"),
            "cutoffs_requested": p.get("cutoffs_requested"),
        }
        for b in ((d.get("summary") or {}).get("per_cutoff") or []):
            try:
                key = str(int(b.get("c")))
            except (TypeError, ValueError):
                continue
            out["by_c"][key] = {
                "c": b.get("c"),
                "lambda_1": b.get("lambda_1"),
                "lambda_1_str": b.get("lambda_1_str"),
                "log10_abs_lambda_1": b.get("log10_abs_lambda_1"),
                "lambda_2": b.get("lambda_2"),
                "gap_absolute": b.get("gap_absolute"),
                "gap_ratio_lambda2_over_lambda1":
                    b.get("gap_ratio_lambda2_over_lambda1"),
                "first_zero_error": b.get("first_zero_error"),
                "first_zero_error_str": b.get("first_zero_error_str"),
                "wall_seconds": b.get("wall_seconds"),
                "Q_rows": b.get("Q_rows"),
            }
        out["available"] = bool(out["by_c"])
    except Exception as exc:                       # malformed but readable
        out["read_error"] = f"{type(exc).__name__}: {exc}"
    return out


def read_o8_lambda():
    """
    Parse 'smallest even-sector eigenvalue: <value>' out of O8_run_dps150.log —
    the T = 800 number the docstring quotes. Recorded as a cross-check with NO
    pass/fail attached (see the GATES section of the module docstring).
    """
    out = {"source_file": O8_LOG, "source_line": None,
           "source_line_text": None, "value_str": None, "value": None,
           "read_error": None,
           "note": ("this is the O8 run at c = 13, N = 100, T = 800, "
                    "dps = 150; it is the T = 800 end of the discrepancy this "
                    "script exists to resolve, recorded as a plain "
                    "cross-check, not adjudicated")}
    try:
        with open(O8_LOG, "r") as fh:
            for ln, line in enumerate(fh, start=1):
                if O8_LAM_MARKER in line:
                    out["source_line"] = ln
                    out["source_line_text"] = line.rstrip("\n")
                    out["value_str"] = line.split(O8_LAM_MARKER, 1)[1].strip()
                    out["value"] = _f(mp.mpf(out["value_str"]))
                    return out
        out["read_error"] = f"marker {O8_LAM_MARKER!r} not found"
    except Exception as exc:
        out["read_error"] = f"{type(exc).__name__}: {exc}"
    return out


# --------------------------------------------------------------------------
# THE PRE-REGISTERED CONVERGENCE CRITERION — fixed before the run
# --------------------------------------------------------------------------
SETTLE_STATEMENT = (
    "a quantity is SETTLED at T_i if |v_i - v_{i-1}| / |v_{i-1}| < settle_tol "
    "AND |v_{i-1} - v_{i-2}| / |v_{i-2}| < settle_tol — i.e. two consecutive "
    "steps of the T sweep each move it by less than the tolerance. The settled "
    "T is the FIRST T in sweep order at which this holds. At least three "
    "completed points are needed for the criterion to be evaluable.")


def settle_scan(pairs, tol, label):
    """
    Apply the pre-registered criterion to an ordered [(T, value), ...] list.

    Values may be None (that point failed or was skipped); a None breaks the
    chain at that index rather than being interpolated over. Relative changes
    are computed in mpmath from the full-precision strings when supplied as
    strings, so a quantity of size 1e-124 is compared honestly.
    """
    out = {
        "quantity": label,
        "statement": SETTLE_STATEMENT,
        "settle_tol": float(tol),
        "series": [{"T": T, "value": _f(v)} for T, v in pairs],
        "relative_changes": [],
        "settled_T": None,
        "settled_index": None,
        "evaluable": len(pairs) >= 3,
        "note": None,
    }
    rels = [None] * len(pairs)
    for i in range(1, len(pairs)):
        prev = pairs[i - 1][1]
        cur = pairs[i][1]
        if prev is None or cur is None:
            continue
        try:
            p = mp.mpf(prev) if not isinstance(prev, str) else mp.mpf(prev)
            c_ = mp.mpf(cur) if not isinstance(cur, str) else mp.mpf(cur)
        except (TypeError, ValueError):
            continue
        if p == 0:
            continue
        rels[i] = _f(abs(c_ - p) / abs(p))
    out["relative_changes"] = [
        {"T": pairs[i][0],
         "T_prev": (pairs[i - 1][0] if i > 0 else None),
         "relative_change": rels[i]} for i in range(len(pairs))]
    for i in range(2, len(pairs)):
        a, b = rels[i], rels[i - 1]
        if (a is not None and b is not None
                and math.isfinite(a) and math.isfinite(b)
                and a < tol and b < tol):
            out["settled_T"] = pairs[i][0]
            out["settled_index"] = i
            break
    if out["settled_T"] is None:
        out["note"] = (
            f"NO T in this sweep settled for {label} at settle_tol={tol:g}"
            if out["evaluable"] else
            f"fewer than three completed points; criterion not evaluable "
            f"for {label}")
    return out


# --------------------------------------------------------------------------
# One point = one (phase, c, T) computation
# --------------------------------------------------------------------------
def run_point(c, T, args, phase):
    """
    Everything measured at one (c, T). Returns a dict; never raises for a
    non-converged zero — such a record is written with a marker instead.

    The call sequence MIRRORS O8_weil_inner_product.py and O20 exactly:
        Q        = cc.build_galerkin_matrix(c, N=N, T=T, dps=dps)
        lam, vec = cc.compute_ground_state(Q)
        zeros    = cc.extract_zeros(vec, n_zeros=n_zeros, dps=dps, c=c)
    """
    block = {"phase": int(phase), "c": int(c), "T": int(T),
             "N": int(args.N), "dps": int(args.dps),
             "failed": False, "failure": None, "traceback": None,
             "skipped": False, "skip_reason": None}
    plist = primes_up_to(c)
    block["primes_in_window"] = plist
    block["n_primes_in_window"] = len(plist)
    block["d"] = bridge_d(c)

    t_point0 = time.time()
    print("\n" + "=" * 78, flush=True)
    print(f"[{_ts()}] START  phase {phase}  c = {c}  T = {T}  "
          f"N = {args.N}  dps = {args.dps}", flush=True)
    print("=" * 78, flush=True)
    print(f"  primes <= {c} : {plist}   (n = {len(plist)})", flush=True)
    print(f"  bridge coordinate d = 2*log2(c) - 1 = {block['d']:.10f}   "
          "(O19's axis)", flush=True)

    # ---- build Q --------------------------------------------------------
    print(f"  [{_ts()}] building the CvS Galerkin matrix Q(c) "
          f"at T = {T}...", flush=True)
    t0 = time.time()
    Q = cc.build_galerkin_matrix(c, N=args.N, T=T, dps=args.dps)
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
    print(f"  [{_ts()}] computing ground state "
          "(cc.compute_ground_state)...", flush=True)
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

    # ---- full even-sector spectrum -> lambda_2 and THE GAP ---------------
    print(f"  [{_ts()}] computing the FULL even-sector spectrum "
          "(mp.eigsy on the package's", flush=True)
    print("  own projected matrix, operator.py:684-697) for the "
          "spectral gap...", flush=True)
    t0 = time.time()
    vals = even_sector_spectrum(Q)
    t_spec = time.time() - t0
    block["spectrum_seconds"] = t_spec
    lam1 = vals[0]
    lam2 = vals[1] if len(vals) > 1 else None
    rep_rel = _safe_div(abs(lam1 - lam), abs(lam))
    rep_ok = bool(math.isfinite(rep_rel) and rep_rel < 1e-12)
    block["even_sector_replication"] = {
        "statement": ("min of the replicated even-sector spectrum equals the "
                      "lambda returned by cc.compute_ground_state"),
        "package_lambda_str": _s(lam, 25),
        "replicated_min_str": _s(lam1, 25),
        "relative_difference": rep_rel,
        "agrees_to_1e-12": rep_ok,
        "passed": rep_ok,
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
    print(f"  GATE R — |min(replicated) - lambda_pkg| / |lambda_pkg| "
          f"= {rep_rel:.6g}   -> {'PASS' if rep_ok else 'FAIL'}", flush=True)
    print(f"  lambda_1 = {_s(lam1, 12)}", flush=True)
    print(f"  lambda_2 = {_s(lam2, 12)}", flush=True)
    print(f"  gap  lambda_2 - lambda_1 = {_s(lam2 - lam1, 12)}"
          if lam2 is not None else "  gap: unavailable", flush=True)
    print(f"  ratio lambda_2 / lambda_1 = {_s(lam2 / lam1, 12)}"
          if (lam2 is not None and lam1 != 0) else "  ratio: unavailable",
          flush=True)

    # ---- zeros ----------------------------------------------------------
    print(f"\n  [{_ts()}] extracting {args.n_zeros} zeros from the "
          "ground-state eigenvector...", flush=True)
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
                "gamma_true": None, "gamma_true_str": None,
                "gamma_detected": None, "gamma_detected_str": None,
                "error": None, "error_str": None,
                "residual": None, "residual_str": None,
                "tolerance": None, "tolerance_str": None,
                "converged_raw": None,
                "marker": "NON-DICT RECORD",
            })
            continue
        conv = z.get("converged")
        zero_rows.append({
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
        })
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

    block["wall_seconds"] = time.time() - t_point0
    print(f"\n[{_ts()}] FINISH phase {phase}  c = {c}  T = {T}   "
          f"wall {block['wall_seconds']:.2f} s "
          f"({_hms(block['wall_seconds'])})", flush=True)
    return block


# --------------------------------------------------------------------------
# Payload assembly — rebuilt from scratch after EVERY point
# --------------------------------------------------------------------------
def point_id(phase, c, T):
    """Stable identifier for a (phase, c, T) point, used in completed/pending."""
    return {"phase": int(phase), "c": int(c), "T": int(T)}


def flat_rows(blocks):
    """Flat `rows`: ONE ROW PER (phase, T, c, zero index). House schema."""
    rows = []
    for b in blocks:
        base = {
            "phase": b.get("phase"),
            "T": b.get("T"),
            "c": b.get("c"),
            "N": b.get("N"),
            "dps": b.get("dps"),
            "n_primes_in_window": b.get("n_primes_in_window"),
            "primes_in_window": b.get("primes_in_window"),
            "d": b.get("d"),
            "Q_rows": b.get("Q_rows"),
            "lambda_1": b.get("lambda_1"),
            "lambda_1_str": b.get("lambda_1_str"),
            "log10_abs_lambda_1": b.get("log10_abs_lambda_1"),
            "lambda_2": b.get("lambda_2"),
            "lambda_2_str": b.get("lambda_2_str"),
            "gap_absolute": b.get("gap_absolute"),
            "gap_ratio_lambda2_over_lambda1":
                b.get("gap_ratio_lambda2_over_lambda1"),
            "symmetry_ratio": (b.get("gate_c") or {}).get("symmetry_ratio"),
            "wall_seconds": b.get("wall_seconds"),
            "point_failed": bool(b.get("failed", False)),
            "point_failure": b.get("failure"),
            "point_skipped": bool(b.get("skipped", False)),
            "point_skip_reason": b.get("skip_reason"),
        }
        zs = b.get("zeros") or []
        if not zs:
            r = dict(base)
            r.update({"k": None, "gamma_true": None, "gamma_true_str": None,
                      "gamma_detected": None, "gamma_detected_str": None,
                      "error": None, "error_str": None, "residual": None,
                      "residual_str": None, "tolerance": None,
                      "converged": None,
                      "zero_failure": "no zero record for this point",
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
    return rows


def build_payload(state, args, out_path):
    """
    Rebuild the FULL envelope from current state. Called after every point, so
    an interrupted run leaves a complete, valid, self-describing JSON.
    """
    p1 = state["phase1"]
    p2 = state["phase2"]
    ok1 = [b for b in p1 if not b.get("failed") and not b.get("skipped")]
    ok2 = [b for b in p2 if not b.get("failed") and not b.get("skipped")]

    lam_pairs = [(b["T"], b.get("lambda_1_str")) for b in ok1]
    err_pairs = [(b["T"], b.get("first_zero_error_str")) for b in ok1]
    lam_settle = settle_scan(lam_pairs, args.settle_tol, "lambda_1")
    err_settle = settle_scan(err_pairs, args.settle_tol, "first_zero_error")

    t_settled = lam_settle["settled_T"]
    t_used = state.get("t_used_phase2")

    o20 = state["o20"]
    comparison = []
    for b in ok2:
        prior = (o20.get("by_c") or {}).get(str(int(b["c"])))
        comparison.append({
            "c": b["c"],
            "T_this_run": b["T"],
            "lambda_1": b.get("lambda_1"),
            "lambda_1_str": b.get("lambda_1_str"),
            "first_zero_error": b.get("first_zero_error"),
            "first_zero_error_str": b.get("first_zero_error_str"),
            "gap_ratio_lambda2_over_lambda1":
                b.get("gap_ratio_lambda2_over_lambda1"),
            "o20_available": prior is not None,
            "o20_T": (o20.get("params") or {}).get("T"),
            "o20_lambda_1": (prior or {}).get("lambda_1"),
            "o20_lambda_1_str": (prior or {}).get("lambda_1_str"),
            "o20_first_zero_error": (prior or {}).get("first_zero_error"),
            "o20_first_zero_error_str":
                (prior or {}).get("first_zero_error_str"),
            "o20_gap_ratio_lambda2_over_lambda1":
                (prior or {}).get("gap_ratio_lambda2_over_lambda1"),
            "relative_change_lambda_1_vs_o20": (
                _safe_div(abs((b.get("lambda_1") or 0.0)
                              - ((prior or {}).get("lambda_1") or 0.0)),
                          abs((prior or {}).get("lambda_1") or 0.0))
                if prior else None),
            "relative_change_first_zero_error_vs_o20": (
                _safe_div(abs((b.get("first_zero_error") or 0.0)
                              - ((prior or {}).get("first_zero_error") or 0.0)),
                          abs((prior or {}).get("first_zero_error") or 0.0))
                if prior else None),
        })

    gc_rows = [{"phase": b["phase"], "c": b["c"], "T": b["T"],
                "symmetry_ratio": (b.get("gate_c") or {}).get("symmetry_ratio"),
                "passed": (b.get("gate_c") or {}).get("passed")}
               for b in (ok1 + ok2)]
    gc_all = (all(bool(r["passed"]) for r in gc_rows) if gc_rows else None)
    gr_rows = [{"phase": b["phase"], "c": b["c"], "T": b["T"],
                "relative_difference":
                    (b.get("even_sector_replication") or {})
                    .get("relative_difference"),
                "passed": (b.get("even_sector_replication") or {})
                    .get("passed")}
               for b in (ok1 + ok2)]
    gr_all = (all(bool(r["passed"]) for r in gr_rows) if gr_rows else None)

    all_blocks = p1 + p2
    elapsed = time.time() - state["t_start"]

    return {
        "schema_version": "1",
        "script": os.path.basename(os.path.abspath(__file__)),
        "generated_utc": state["started_iso"],
        "params": {
            "code_version": state["code_version"],
            "o20_code_version": state["o20_code_version"],
            "c_fixed": int(args.c_fixed),
            "tvals": state["tvals"],
            "tvals_raw": str(args.tvals),
            "cutoffs": state["cutoffs"],
            "cutoffs_raw": str(args.cutoffs),
            "N": int(args.N),
            "dps": int(args.dps),
            "n_zeros": int(args.n_zeros),
            "settle_tol": float(args.settle_tol),
            "budget_hours": float(args.budget_hours),
            "out": out_path,
            "no_json": bool(args.no_json),
            "connes_cvs_version": str(getattr(cc, "__version__", "unknown")),
            "mpmath_version": str(getattr(mp, "__version__", "unknown")),
            "call_sequence": ("cc.build_galerkin_matrix(c, N, T, dps) -> "
                              "cc.compute_ground_state(Q) -> "
                              "cc.extract_zeros(vec, n_zeros, dps, c); "
                              "mirrors O8_weil_inner_product.py and O20"),
            "spectral_gap_method": (
                "the package exposes no public accessor for the second "
                "eigenvalue; this script replicates connes_cvs "
                "operator.py:684-694's own V_even projector, forms "
                "Q_even = V_even^T Q V_even, and calls mp.eigsy on that same "
                "matrix (the same call the package makes at operator.py:697). "
                "This is O20's code path, copied unchanged, and the "
                "replication is checked at EVERY point against the lambda the "
                "package returned"),
            "bridge_coordinate": ("d = 2*log2(c) - 1, from "
                                  "lambda = 2^((d+1)/2); O19's axis"),
            "precision": (
                f"mixed: connes_cvs arbitrary precision at mp.dps = "
                f"{args.dps} for the Galerkin matrix, the even-sector "
                f"eigensolve and the zero extraction (flint Arb backend when "
                f"connes_cvs.operator.HAS_FLINT, see gate A; flint working "
                f"precision is int(3.5*dps) by the package's default); "
                f"full-precision decimal strings kept in *_str fields; "
                f"float64 in the plain numeric fields and in every printed "
                f"table. The settle criterion is evaluated on the *_str "
                f"values in mpmath, not on the float64 copies"),
        },
        "constants": {
            "why": ("O20 swept c at fixed T = 400. T is not pinned: at "
                    "c = 13, N = 100, dps = 150, T = 400 gives lambda_1 "
                    "2.0770e-59 / first-zero error 1.455e-55 (O20) while "
                    "T = 800 gives 2.8655e-59 / 2.005e-55 "
                    "(O8_run_dps150.log). Doubling T moved lambda_1 by 27.5% "
                    "and made the first-zero error WORSE. T truncates the "
                    "archimedean integral in the Weil explicit formula's W_R "
                    "term, so larger T is strictly MORE of that integral; a "
                    "converged construction should be insensitive to doubling "
                    "it. Until T is pinned, every absolute number in O20 sits "
                    "on an arbitrary choice"),
            "settle_criterion": SETTLE_STATEMENT,
            "settle_criterion_prereg_note": (
                "this criterion was fixed in the script docstring BEFORE the "
                "run and is applied mechanically. It is applied SEPARATELY to "
                "lambda_1 and to the first-zero error, because the two need "
                "not settle together"),
            "connes_reference": ("A. Connes, 'The Riemann Hypothesis: Past, "
                                 "Present and a Letter Through Time', "
                                 "arXiv:2602.04022v1, 3 Feb 2026"),
            "connes_cutoff": CONNES_CUTOFF,
            "connes_first_zero_error_c13": CONNES_FIRST_ZERO_ERROR_C13,
            "o10_note": ("O10 is a deliberate gap in this tree's O-series and "
                         "is not filled by this script"),
            "proves_nothing_note": (
                "this script measures; it proves nothing and interprets "
                "nothing. No verdict is stamped anywhere in it"),
            "extract_zeros_record_note": (
                "extract_zeros returns a LIST OF PER-ZERO DICTS with keys k, "
                "gamma_true, gamma_detected, error, residual, converged, "
                "failure, tolerance (operator.py:779-785). Records are "
                "indexed by key; mp.mpf() is never called on a record"),
            "T_meaning": (
                "T is the truncation of the archimedean Mellin-multiplier "
                "integral: connes_cvs psi_arch integrates over [-T, T] with "
                "subinterval splitting at tau = 0 and tau = +/- 2*pi*x/L "
                "(operator.py:411-453). Basis index x runs to N, so the "
                "outermost split point sits at 2*pi*N/log(c); when T is below "
                "that, split points fall outside the integration range and "
                "are dropped"),
        },
        "summary": {
            "run_state": state["run_state"],
            "interrupted": bool(state["interrupted"]),
            "elapsed_seconds": elapsed,
            "elapsed_hms": _hms(elapsed),
            "budget_hours": float(args.budget_hours),
            "completed": state["completed"],
            "pending": state["pending"],
            "skipped": state["skipped"],
            "failed": state["failed_ids"],
            "n_points_total": len(state["completed"]) + len(state["pending"]),
            "t_sweep": {
                "c_fixed": int(args.c_fixed),
                "tvals_requested": state["tvals"],
                "tvals_completed": [b["T"] for b in ok1],
                "per_T": p1,
                "lambda_1_settle": lam_settle,
                "first_zero_error_settle": err_settle,
                "t_settled": t_settled,
                "t_settled_note": (
                    f"lambda_1 settled at T = {t_settled} under the "
                    f"pre-registered criterion" if t_settled is not None
                    else "NO T in the sweep settled lambda_1 under the "
                         "pre-registered criterion"),
                "first_zero_error_settled_T": err_settle["settled_T"],
                "o8_log_cross_check": state["o8"],
                "o20_cross_check_c13_T400": state["o20_cross_check"],
            },
            "c_sweep": {
                "T_used": t_used,
                "t_settled": t_settled,
                "T_used_is_settled": bool(
                    t_settled is not None and t_used == t_settled),
                "unconverged_T_note": (
                    None if (t_settled is not None and t_used == t_settled)
                    else ("NO T settled in phase 1; the c curve below stands "
                          "on an UNCONVERGED T (the largest T that "
                          f"completed, T = {t_used}). Every absolute number "
                          "in it inherits that.")),
                "cutoffs_requested": state["cutoffs"],
                "cutoffs_completed": [b["c"] for b in ok2],
                "per_c": p2,
                "first_zero_error_by_cutoff": [
                    {"c": b["c"], "first_zero_error": b.get("first_zero_error")}
                    for b in ok2],
                "first_zero_error_strictly_decreasing_in_c": (
                    all(ok2[i + 1].get("first_zero_error") is not None
                        and ok2[i].get("first_zero_error") is not None
                        and ok2[i + 1]["first_zero_error"]
                        < ok2[i]["first_zero_error"]
                        for i in range(len(ok2) - 1))
                    if len(ok2) >= 2 else None),
                "comparison_against_o20": comparison,
            },
            "o20_source": {k: v for k, v in o20.items() if k != "by_c"},
            "gate_a": state["gate_a"],
            "gate_c": {
                "statement": ("||Q - Q^T|| / ||Q|| == 0 exactly at every "
                              "point, both phases"),
                "per_point": gc_rows,
                "passed": (None if not gc_rows else bool(gc_all)),
            },
            "gate_r": {
                "statement": ("min of the replicated even-sector spectrum "
                              "reproduces cc.compute_ground_state's lambda at "
                              "every point, both phases (relative difference "
                              "< 1e-12)"),
                "per_point": gr_rows,
                "passed": (None if not gr_rows else bool(gr_all)),
            },
        },
        "rows": flat_rows(all_blocks),
    }


def checkpoint(state, args, out_path, quiet=False):
    """Rebuild the payload and write it atomically. Never raises."""
    if args.no_json:
        return
    try:
        payload = build_payload(state, args, out_path)
    except Exception as exc:
        print(f"  WARNING: could not build checkpoint payload: "
              f"{type(exc).__name__}: {exc}", flush=True)
        return
    _write_results(payload, out_path, quiet=quiet)


# --------------------------------------------------------------------------
# main
# --------------------------------------------------------------------------
def main():
    ap = argparse.ArgumentParser(
        description="O21 — pin the archimedean cutoff T by sweeping it at "
                    "fixed prime cutoff c, then re-run O20's c sweep at the "
                    "settled T. Measures; does not interpret.")
    ap.add_argument("--c-fixed", dest="c_fixed", type=int, default=13,
                    help="prime cutoff held fixed during the phase-1 T sweep "
                         "(default 13, Connes' x = 13)")
    ap.add_argument("--tvals", type=str, default=DEFAULT_TVALS,
                    help="comma-separated ARCHIMEDEAN CUTOFFS T for phase 1; "
                         f"default '{DEFAULT_TVALS}'")
    ap.add_argument("--cutoffs", type=str, default=DEFAULT_CUTOFFS,
                    help="comma-separated PRIME CUTOFFS c for phase 2 "
                         f"(O20's sweep); default '{DEFAULT_CUTOFFS}'")
    ap.add_argument("--N", type=int, default=100,
                    help="trigonometric truncation; the matrix is 2N+1 "
                         "square. Default 100 (Connes' footnote 14)")
    ap.add_argument("--dps", type=int, default=150,
                    help="mpmath decimal precision (default 150)")
    ap.add_argument("--n-zeros", dest="n_zeros", type=int, default=5,
                    help="number of zeros extracted per point (default 5)")
    ap.add_argument("--settle-tol", dest="settle_tol", type=float,
                    default=1e-3,
                    help="pre-registered convergence tolerance: two "
                         "consecutive relative changes below this and the "
                         "quantity is SETTLED (default 1e-3)")
    ap.add_argument("--budget-hours", dest="budget_hours", type=float,
                    default=8.0,
                    help="wall-clock budget in hours. A point is not STARTED "
                         "if its projected cost would exceed the budget; a "
                         "point already under way always finishes "
                         "(default 8)")
    ap.add_argument("--out", type=str, default=None,
                    help="results JSON path "
                         "(default: results/<script>_results.json)")
    ap.add_argument("--no-json", action="store_true",
                    help="skip writing the results JSON (also disables "
                         "checkpointing)")
    args = ap.parse_args()

    if args.c_fixed < 2:
        raise SystemExit(f"--c-fixed {args.c_fixed} must be >= 2 "
                         "(connes_cvs rejects c < 2)")
    if args.N < 1:
        raise SystemExit(f"--N {args.N} must be >= 1")
    if args.dps < 15:
        raise SystemExit(f"--dps {args.dps} is below connes_cvs' minimum 15")
    if args.n_zeros < 1:
        raise SystemExit(f"--n-zeros {args.n_zeros} must be >= 1")
    if args.settle_tol <= 0:
        raise SystemExit(f"--settle-tol {args.settle_tol} must be > 0")
    if args.budget_hours <= 0:
        raise SystemExit(f"--budget-hours {args.budget_hours} must be > 0")

    tvals = parse_int_list(args.tvals, "--tvals", 1)
    cutoffs = parse_int_list(args.cutoffs, "--cutoffs", 2)
    out_path = args.out if args.out else DEFAULT_OUT
    if not os.path.isabs(out_path):
        out_path = os.path.join(_HERE, out_path)
    budget_seconds = float(args.budget_hours) * 3600.0

    started = datetime.now(timezone.utc)
    t_start = time.time()

    print("=" * 78, flush=True)
    print("O21 — archimedean convergence: pin T, then re-stand the c curve "
          "on it", flush=True)
    print("     (measures where a truncation parameter stops moving the "
          "answer;", flush=True)
    print("      proves nothing, interprets nothing)", flush=True)
    print("=" * 78, flush=True)
    print(f"  started        : {started.isoformat().replace('+00:00', 'Z')}",
          flush=True)
    print("  the problem    : O20 swept c at T = 400. At c = 13, N = 100, "
          "dps = 150,", flush=True)
    print("                   T = 400 -> lambda_1 2.0770e-59, first-zero err "
          "1.455e-55 (O20)", flush=True)
    print("                   T = 800 -> lambda_1 2.8655e-59, first-zero err "
          "2.005e-55 (O8 log)", flush=True)
    print("                   Doubling T moved lambda_1 27.5% and made the "
          "error WORSE.", flush=True)
    print("  criterion (pre-registered, fixed before this run):", flush=True)
    print("    settled at T_i iff the last TWO relative changes are each "
          f"< {args.settle_tol:g}", flush=True)
    print("", flush=True)
    print(f"  phase 1: c = {args.c_fixed}, T in {tvals}", flush=True)
    print(f"  phase 2: c in {cutoffs}, at the settled T", flush=True)
    print(f"  N              : {args.N}   (matrix is {2*args.N+1} square)",
          flush=True)
    print(f"  dps            : {args.dps}", flush=True)
    print(f"  n_zeros        : {args.n_zeros}", flush=True)
    print(f"  settle-tol     : {args.settle_tol:g}", flush=True)
    print(f"  budget-hours   : {args.budget_hours}  ({_hms(budget_seconds)})",
          flush=True)
    print(f"  out            : {out_path}"
          f"{'  (--no-json: NOT written)' if args.no_json else ''}",
          flush=True)
    print(f"  connes_cvs     : {getattr(cc, '__version__', 'unknown')}",
          flush=True)
    print(f"  mpmath         : {getattr(mp, '__version__', 'unknown')}",
          flush=True)

    ga = gate_a()

    o20 = read_o20()
    o8 = read_o8_lambda()
    print("\n" + "-" * 78, flush=True)
    print("PRIOR RECORD (read at runtime; nothing hardcoded)", flush=True)
    print("-" * 78, flush=True)
    if o20["available"]:
        print(f"  O20 results : {o20['source_file']}", flush=True)
        print(f"    generated : {o20['generated_utc']}", flush=True)
        print(f"    params    : {o20['params']}", flush=True)
        print(f"    cutoffs   : {sorted(int(k) for k in o20['by_c'])}",
              flush=True)
    else:
        print(f"  O20 results : UNAVAILABLE ({o20['read_error']})", flush=True)
        print("    phase 2's comparison column will be empty; the run "
              "continues.", flush=True)
    if o8["value_str"] is not None:
        print(f"  O8 log      : {o8['source_file']}:{o8['source_line']}",
              flush=True)
        print(f"    line      : {o8['source_line_text']!r}", flush=True)
    else:
        print(f"  O8 log      : UNAVAILABLE ({o8['read_error']})", flush=True)

    state = {
        "t_start": t_start,
        "started_iso": started.isoformat().replace("+00:00", "Z"),
        "code_version": _code_version(),
        "o20_code_version": _code_version(O20_SCRIPT),
        "tvals": tvals,
        "cutoffs": cutoffs,
        "phase1": [],
        "phase2": [],
        "completed": [],
        "pending": ([point_id(1, args.c_fixed, T) for T in tvals]
                    + [{"phase": 2, "c": int(c), "T": None} for c in cutoffs]),
        "skipped": [],
        "failed_ids": [],
        "gate_a": ga,
        "o20": o20,
        "o8": o8,
        "o20_cross_check": None,
        "t_used_phase2": None,
        "run_state": "running",
        "interrupted": False,
    }

    def drop_pending(phase, c, T):
        """Remove a point from `pending` once it is finished one way or another."""
        for i, q in enumerate(state["pending"]):
            if q["phase"] == phase and int(q["c"]) == int(c) and (
                    q["T"] is None or int(q["T"]) == int(T)):
                state["pending"].pop(i)
                return

    def project_seconds(phase, T):
        """
        Conservative projection of a point's cost, in seconds.

        Phase 1: cost is dominated by the archimedean quadrature, which grows
        with T, so scale the last completed phase-1 point linearly in T.
        Phase 2: use the largest completed point's wall at the same T.
        Returns None when there is no basis to project from — in that case the
        point is started (never skipped on no evidence).
        """
        done1 = [b for b in state["phase1"]
                 if not b.get("failed") and not b.get("skipped")
                 and b.get("wall_seconds")]
        if phase == 1:
            if not done1:
                return None
            last = done1[-1]
            if not last.get("T"):
                return None
            return float(last["wall_seconds"]) * (float(T) / float(last["T"]))
        done2 = [b for b in state["phase2"]
                 if not b.get("failed") and not b.get("skipped")
                 and b.get("wall_seconds")]
        if done2:
            return max(float(b["wall_seconds"]) for b in done2)
        same_T = [b for b in done1 if int(b["T"]) == int(T)]
        if same_T:
            return float(same_T[-1]["wall_seconds"])
        if done1:
            last = done1[-1]
            return float(last["wall_seconds"]) * (float(T)
                                                  / float(last["T"]))
        return None

    def budget_allows(phase, c, T):
        """(ok, reason). Never leaves a point partial: it is run or skipped."""
        elapsed = time.time() - t_start
        if elapsed >= budget_seconds:
            return False, (f"budget exhausted: {_hms(elapsed)} elapsed "
                           f">= budget {_hms(budget_seconds)}")
        est = project_seconds(phase, T)
        if est is None:
            return True, None
        if elapsed + est > budget_seconds:
            return False, (f"projected cost {_hms(est)} on top of "
                           f"{_hms(elapsed)} elapsed would exceed the "
                           f"{_hms(budget_seconds)} budget")
        return True, None

    def do_point(phase, c, T):
        """Run one point with full isolation, record it, checkpoint. Returns block."""
        ok, reason = budget_allows(phase, c, T)
        if not ok:
            blk = {"phase": phase, "c": int(c), "T": int(T),
                   "N": int(args.N), "dps": int(args.dps),
                   "skipped": True, "skip_reason": reason,
                   "failed": False, "failure": None, "traceback": None,
                   "primes_in_window": primes_up_to(c),
                   "n_primes_in_window": len(primes_up_to(c)),
                   "d": bridge_d(c), "zeros": [], "wall_seconds": 0.0}
            state["skipped"].append({**point_id(phase, c, T),
                                     "reason": reason})
            print(f"\n[{_ts()}] SKIP   phase {phase}  c = {c}  T = {T}  "
                  f"— {reason}", flush=True)
        else:
            try:
                blk = run_point(c, T, args, phase)
            except KeyboardInterrupt:
                raise
            except Exception as exc:
                tb = traceback.format_exc()
                blk = {"phase": phase, "c": int(c), "T": int(T),
                       "N": int(args.N), "dps": int(args.dps),
                       "failed": True,
                       "failure": f"{type(exc).__name__}: {exc}",
                       "traceback": tb,
                       "skipped": False, "skip_reason": None,
                       "primes_in_window": primes_up_to(c),
                       "n_primes_in_window": len(primes_up_to(c)),
                       "d": bridge_d(c), "zeros": [], "wall_seconds": 0.0}
                state["failed_ids"].append({**point_id(phase, c, T),
                                            "failure": blk["failure"]})
                print(f"\n[{_ts()}] FAILED phase {phase}  c = {c}  T = {T}: "
                      f"{blk['failure']}", flush=True)
                print(tb, flush=True)
                print("  continuing to the next point.", flush=True)
        state["phase1" if phase == 1 else "phase2"].append(blk)
        drop_pending(phase, c, T)
        if not blk.get("skipped"):
            state["completed"].append(point_id(phase, c, T))
        checkpoint(state, args, out_path)
        return blk

    exit_code = 0
    try:
        # ---------------- PHASE 1 — the T sweep ---------------------------
        print("\n" + "#" * 78, flush=True)
        print(f"# PHASE 1 — T SWEEP at c = {args.c_fixed}   "
              f"T in {tvals}", flush=True)
        print("#" * 78, flush=True)
        checkpoint(state, args, out_path, quiet=True)
        for T in tvals:
            do_point(1, args.c_fixed, T)

        ok1 = [b for b in state["phase1"]
               if not b.get("failed") and not b.get("skipped")]
        lam_settle = settle_scan(
            [(b["T"], b.get("lambda_1_str")) for b in ok1],
            args.settle_tol, "lambda_1")
        err_settle = settle_scan(
            [(b["T"], b.get("first_zero_error_str")) for b in ok1],
            args.settle_tol, "first_zero_error")

        # cross-check against O20 wherever this sweep overlaps its (c, T)
        if o20["available"]:
            prior = (o20.get("by_c") or {}).get(str(int(args.c_fixed)))
            same = next((b for b in ok1
                         if b["T"] == (o20.get("params") or {}).get("T")), None)
            if prior is not None and same is not None:
                state["o20_cross_check"] = {
                    "statement": ("this run's (c_fixed, T) point that "
                                  "coincides with O20's recorded sweep "
                                  "reproduces O20's lambda_1"),
                    "c": int(args.c_fixed),
                    "T": same["T"],
                    "ours_lambda_1_str": same.get("lambda_1_str"),
                    "o20_lambda_1_str": prior.get("lambda_1_str"),
                    "relative_difference": _safe_div(
                        abs((same.get("lambda_1") or 0.0)
                            - (prior.get("lambda_1") or 0.0)),
                        abs(prior.get("lambda_1") or 0.0)),
                    "note": ("recorded, not adjudicated; N/dps must also "
                             "match for this to mean reproduction — see "
                             "summary.o20_source.params"),
                }
            else:
                state["o20_cross_check"] = {
                    "available": False,
                    "reason": ("this run's phase-1 sweep has no point at "
                               "O20's recorded (c, T)")}

        print("\n" + "=" * 78, flush=True)
        print("PHASE 1 RESULT — T table and the pre-registered criterion",
              flush=True)
        print("=" * 78, flush=True)
        print(f"  {'T':>7} {'Qrows':>6} {'sym':>8} {'lambda_1':>16} "
              f"{'log10|l1|':>11} {'rel chg':>11} {'lambda_2':>16} "
              f"{'l2/l1':>13} {'first-zero err':>15} {'rel chg':>11} "
              f"{'wall s':>9}", flush=True)
        print(f"  {'-'*7} {'-'*6} {'-'*8} {'-'*16} {'-'*11} {'-'*11} "
              f"{'-'*16} {'-'*13} {'-'*15} {'-'*11} {'-'*9}", flush=True)
        lam_rel = {r["T"]: r["relative_change"]
                   for r in lam_settle["relative_changes"]}
        err_rel = {r["T"]: r["relative_change"]
                   for r in err_settle["relative_changes"]}
        for b in state["phase1"]:
            if b.get("skipped"):
                print(f"  {b['T']:>7}   SKIPPED: {b['skip_reason']}",
                      flush=True)
                continue
            if b.get("failed"):
                print(f"  {b['T']:>7}   FAILED: {b['failure']}", flush=True)
                continue
            print(f"  {b['T']:>7} {b.get('Q_rows'):>6} "
                  f"{_fmtg((b.get('gate_c') or {}).get('symmetry_ratio'), 8, 2)} "
                  f"{_fmtg(b.get('lambda_1'), 16, 9)} "
                  f"{_fmtg(b.get('log10_abs_lambda_1'), 11, 8)} "
                  f"{_fmtg(lam_rel.get(b['T']), 11, 4)} "
                  f"{_fmtg(b.get('lambda_2'), 16, 9)} "
                  f"{_fmtg(b.get('gap_ratio_lambda2_over_lambda1'), 13, 6)} "
                  f"{_fmtg(b.get('first_zero_error'), 15, 6)} "
                  f"{_fmtg(err_rel.get(b['T']), 11, 4)} "
                  f"{b.get('wall_seconds', 0.0):>9.2f}", flush=True)
        print(f"\n  criterion: {SETTLE_STATEMENT}", flush=True)
        print(f"  settle_tol = {args.settle_tol:g}", flush=True)
        if lam_settle["settled_T"] is not None:
            print(f"  lambda_1        : SETTLED at T = "
                  f"{lam_settle['settled_T']}", flush=True)
        else:
            print(f"  lambda_1        : NOT SETTLED — {lam_settle['note']}",
                  flush=True)
        if err_settle["settled_T"] is not None:
            print(f"  first-zero error: SETTLED at T = "
                  f"{err_settle['settled_T']}", flush=True)
        else:
            print(f"  first-zero error: NOT SETTLED — {err_settle['note']}",
                  flush=True)

        # ---------------- choose T for phase 2 ----------------------------
        t_settled = lam_settle["settled_T"]
        if t_settled is not None:
            t_used = t_settled
            t_note = f"phase 2 runs at the SETTLED T = {t_used}"
        else:
            completed_T = [b["T"] for b in ok1]
            t_used = max(completed_T) if completed_T else None
            t_note = (f"NOTHING SETTLED. phase 2 runs at the LARGEST T that "
                      f"completed, T = {t_used}; t_settled is null and the c "
                      f"curve stands on an UNCONVERGED T"
                      if t_used is not None else
                      "NOTHING SETTLED and no phase-1 point completed; "
                      "phase 2 cannot choose a T and is skipped")
        state["t_used_phase2"] = t_used
        print(f"\n  {t_note}", flush=True)
        checkpoint(state, args, out_path)

        # ---------------- PHASE 2 — the c sweep ---------------------------
        print("\n" + "#" * 78, flush=True)
        print(f"# PHASE 2 — c SWEEP at T = {t_used}   c in {cutoffs}",
              flush=True)
        print("#" * 78, flush=True)
        if t_used is None:
            for c in cutoffs:
                state["skipped"].append(
                    {"phase": 2, "c": int(c), "T": None,
                     "reason": "no phase-1 point completed, so no T to run at"})
                drop_pending(2, c, 0)
            print("  phase 2 SKIPPED entirely: no T available.", flush=True)
        else:
            for c in cutoffs:
                do_point(2, c, t_used)

        state["run_state"] = "complete"

    except KeyboardInterrupt:
        state["interrupted"] = True
        state["run_state"] = "interrupted"
        exit_code = 130
        print(f"\n\n[{_ts()}] KEYBOARD INTERRUPT — stopping cleanly.",
              flush=True)
        print("  writing the checkpoint before exit; everything finished so "
              "far is in it,", flush=True)
        print("  and summary.pending lists what had not run.", flush=True)
        checkpoint(state, args, out_path)
        print(f"  points completed: {len(state['completed'])}   "
              f"pending: {len(state['pending'])}   "
              f"skipped: {len(state['skipped'])}   "
              f"failed: {len(state['failed_ids'])}", flush=True)
        print(f"  elapsed: {_hms(time.time() - t_start)}", flush=True)
        raise SystemExit(exit_code)

    # ---------------- FINAL SUMMARY --------------------------------------
    payload = None
    try:
        payload = build_payload(state, args, out_path)
    except Exception as exc:
        print(f"\n  WARNING: could not build the final payload: "
              f"{type(exc).__name__}: {exc}", flush=True)

    print("\n" + "=" * 78, flush=True)
    print("FINAL SUMMARY", flush=True)
    print("=" * 78, flush=True)

    ok1 = [b for b in state["phase1"]
           if not b.get("failed") and not b.get("skipped")]
    ok2 = [b for b in state["phase2"]
           if not b.get("failed") and not b.get("skipped")]
    lam_settle = settle_scan([(b["T"], b.get("lambda_1_str")) for b in ok1],
                             args.settle_tol, "lambda_1")
    err_settle = settle_scan(
        [(b["T"], b.get("first_zero_error_str")) for b in ok1],
        args.settle_tol, "first_zero_error")

    print(f"\n  T TABLE (phase 1, c = {args.c_fixed}, N = {args.N}, "
          f"dps = {args.dps})", flush=True)
    print(f"  {'T':>7} {'lambda_1':>16} {'rel chg':>11} "
          f"{'first-zero err':>15} {'rel chg':>11} {'l2/l1':>13} "
          f"{'wall s':>9}", flush=True)
    print(f"  {'-'*7} {'-'*16} {'-'*11} {'-'*15} {'-'*11} {'-'*13} {'-'*9}",
          flush=True)
    lam_rel = {r["T"]: r["relative_change"]
               for r in lam_settle["relative_changes"]}
    err_rel = {r["T"]: r["relative_change"]
               for r in err_settle["relative_changes"]}
    for b in ok1:
        print(f"  {b['T']:>7} {_fmtg(b.get('lambda_1'), 16, 9)} "
              f"{_fmtg(lam_rel.get(b['T']), 11, 4)} "
              f"{_fmtg(b.get('first_zero_error'), 15, 6)} "
              f"{_fmtg(err_rel.get(b['T']), 11, 4)} "
              f"{_fmtg(b.get('gap_ratio_lambda2_over_lambda1'), 13, 6)} "
              f"{b.get('wall_seconds', 0.0):>9.2f}", flush=True)

    print(f"\n  SETTLED T (lambda_1)         : "
          f"{lam_settle['settled_T'] if lam_settle['settled_T'] is not None else 'NONE — no T in the sweep settled'}",
          flush=True)
    print(f"  SETTLED T (first-zero error) : "
          f"{err_settle['settled_T'] if err_settle['settled_T'] is not None else 'NONE — no T in the sweep settled'}",
          flush=True)
    print(f"  T used for phase 2           : {state['t_used_phase2']}",
          flush=True)
    if lam_settle["settled_T"] is None or (
            state["t_used_phase2"] != lam_settle["settled_T"]):
        print("  NOTE: the c curve below stands on an UNCONVERGED T.",
              flush=True)

    print(f"\n  c TABLE (phase 2, T = {state['t_used_phase2']}, "
          f"N = {args.N}, dps = {args.dps})", flush=True)
    print(f"  {'c':>4} {'n_p':>4} {'d':>9} {'lambda_1':>16} "
          f"{'log10|l1|':>11} {'l2/l1':>13} {'first-zero err':>15} "
          f"{'wall s':>9}", flush=True)
    print(f"  {'-'*4} {'-'*4} {'-'*9} {'-'*16} {'-'*11} {'-'*13} {'-'*15} "
          f"{'-'*9}", flush=True)
    for b in ok2:
        print(f"  {b['c']:>4} {b['n_primes_in_window']:>4} {b['d']:>9.5f} "
              f"{_fmtg(b.get('lambda_1'), 16, 9)} "
              f"{_fmtg(b.get('log10_abs_lambda_1'), 11, 8)} "
              f"{_fmtg(b.get('gap_ratio_lambda2_over_lambda1'), 13, 6)} "
              f"{_fmtg(b.get('first_zero_error'), 15, 6)} "
              f"{b.get('wall_seconds', 0.0):>9.2f}", flush=True)

    print(f"\n  COMPARISON AGAINST O20 (its T = "
          f"{(o20.get('params') or {}).get('T')}, read from "
          f"{os.path.basename(O20_RESULTS)})", flush=True)
    if not o20["available"]:
        print(f"    O20 results unavailable ({o20['read_error']}); no "
              "comparison.", flush=True)
    else:
        print(f"    {'c':>4} {'this lambda_1':>16} {'O20 lambda_1':>16} "
              f"{'rel chg':>11} {'this err':>15} {'O20 err':>15} "
              f"{'rel chg':>11}", flush=True)
        print(f"    {'-'*4} {'-'*16} {'-'*16} {'-'*11} {'-'*15} {'-'*15} "
              f"{'-'*11}", flush=True)
        for b in ok2:
            prior = (o20.get("by_c") or {}).get(str(int(b["c"])))
            if prior is None:
                print(f"    {b['c']:>4} {_fmtg(b.get('lambda_1'), 16, 9)} "
                      f"{'—':>16} {'—':>11} "
                      f"{_fmtg(b.get('first_zero_error'), 15, 6)} "
                      f"{'—':>15} {'—':>11}", flush=True)
                continue
            rl = _safe_div(abs((b.get("lambda_1") or 0.0)
                               - (prior.get("lambda_1") or 0.0)),
                           abs(prior.get("lambda_1") or 0.0))
            re_ = _safe_div(abs((b.get("first_zero_error") or 0.0)
                                - (prior.get("first_zero_error") or 0.0)),
                            abs(prior.get("first_zero_error") or 0.0))
            print(f"    {b['c']:>4} {_fmtg(b.get('lambda_1'), 16, 9)} "
                  f"{_fmtg(prior.get('lambda_1'), 16, 9)} "
                  f"{_fmtg(rl, 11, 4)} "
                  f"{_fmtg(b.get('first_zero_error'), 15, 6)} "
                  f"{_fmtg(prior.get('first_zero_error'), 15, 6)} "
                  f"{_fmtg(re_, 11, 4)}", flush=True)
        print("    Both columns are STATED. This script does not interpret "
              "them.", flush=True)

    gc_pass = ((payload or {}).get("summary", {}).get("gate_c", {})
               .get("passed"))
    gr_pass = ((payload or {}).get("summary", {}).get("gate_r", {})
               .get("passed"))
    print("\n  GATES", flush=True)
    print(f"    GATE A (flint in use)            : "
          f"{'PASS' if ga['passed'] else 'FAIL'}", flush=True)
    print(f"    GATE C (Q symmetric every point) : "
          f"{'PASS' if gc_pass else ('FAIL' if gc_pass is False else 'NOT RUN')}",
          flush=True)
    print(f"    GATE R (V_even replication)      : "
          f"{'PASS' if gr_pass else ('FAIL' if gr_pass is False else 'NOT RUN')}",
          flush=True)

    print("\n  BOOKKEEPING", flush=True)
    print(f"    completed : {len(state['completed'])}", flush=True)
    print(f"    pending   : {len(state['pending'])}   {state['pending']}",
          flush=True)
    print(f"    skipped   : {len(state['skipped'])}   {state['skipped']}",
          flush=True)
    print(f"    failed    : {len(state['failed_ids'])}   "
          f"{[f['c'] for f in state['failed_ids']]}", flush=True)

    total_wall = time.time() - t_start
    print(f"\n  total wall: {total_wall:.2f} s ({_hms(total_wall)}), "
          f"budget {_hms(budget_seconds)}", flush=True)

    if args.no_json:
        print("\n  --no-json: results JSON not written.", flush=True)
        return
    if payload is not None:
        _write_results(payload, out_path)
    else:
        checkpoint(state, args, out_path)


if __name__ == "__main__":
    main()
