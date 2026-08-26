#!/usr/bin/env python3
"""resultsguard — never lose a results file to a re-run.

WHY THIS EXISTS. Run logs in this tree are run-stamped
(`O66_twin_spectral_run1.log`), so a second run writes a second file
and both survive. Results JSONs are not (`twin_spectral.json`), so a
second run overwrites the first. Three scripts have already lost run 1
that way — O63, O65 and O66 — and git did not save them: each of those
files carries exactly one commit, because the clobber happened before
anything was committed. Their run-1 numbers survive only inside the
run-1 logs. `CONTEXT.md` § Known defects records the hazard; this
module removes it.

WHAT IT DOES. `guarded_write(payload, out_path)` copies any existing,
DIFFERING file to

    results/archive/<stem>_<utc>_<sha8>.json

before writing the new one. Nothing is deleted — the project's
permissions forbid deleting anything under `results/` — and the
canonical path keeps resolving, so every paper, prereg and notebook
citation of `results/X.json` continues to work untouched. The archive
copy is the prior run, recoverable.

Identical content is not archived: re-running a deterministic script
should not litter the archive. Content is compared with
`generated_utc` and `run_end_at` blanked, so a byte-identical rerun
that differs only in its timestamp counts as identical.

USE IT LIKE THE `_write_results` IT REPLACES:

    from utilities.resultsguard import guarded_write
    guarded_write(payload, out_path)

or, from a script at the project root:

    import sys, os
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    from utilities.resultsguard import guarded_write

A write failure never kills a run, matching the house `_write_results`
convention: it warns and returns False.

Companion gate: `utilities/check_results_guard.py`.
"""
import hashlib
import json
import os
import shutil
import tempfile
from datetime import datetime, timezone

VOLATILE_KEYS = ("generated_utc", "run_end_at", "run_start_at")


def _stable_bytes(path_or_obj):
    """JSON bytes with volatile timestamp fields blanked, so a
    deterministic rerun is recognised as identical.

    Keys are coerced to str before sorting. Without that, a dict mixing
    int and str keys at one level raises TypeError inside
    json.dumps(sort_keys=True), the exception is swallowed below, and an
    identical rerun is archived anyway — archive litter, never data
    loss, but it defeats the point of the comparison. Found by the
    2026-08-26 scope audit and reproduced."""
    def _strkeys(o):
        if isinstance(o, dict):
            return {str(k): _strkeys(v) for k, v in o.items()}
        if isinstance(o, (list, tuple)):
            return [_strkeys(v) for v in o]
        return o
    try:
        if isinstance(path_or_obj, (str, bytes, os.PathLike)):
            with open(path_or_obj) as f:
                obj = json.load(f)
        else:
            obj = path_or_obj
        if isinstance(obj, dict):
            obj = {k: ("" if k in VOLATILE_KEYS else v)
                   for k, v in obj.items()}
        return json.dumps(_strkeys(obj), sort_keys=True).encode()
    except Exception:
        try:
            with open(path_or_obj, "rb") as f:
                return f.read()
        except Exception:
            return b""


def archive_if_needed(out_path, payload=None, archive_dir=None):
    """Copy an existing, differing results file into the archive.

    Returns the archive path if a copy was made, None otherwise."""
    if not os.path.exists(out_path):
        return None
    if payload is not None and _stable_bytes(out_path) == _stable_bytes(payload):
        return None
    d = archive_dir or os.path.join(os.path.dirname(os.path.abspath(out_path)),
                                    "archive")
    os.makedirs(d, exist_ok=True)
    with open(out_path, "rb") as f:
        raw = f.read()
    sha8 = hashlib.sha256(raw).hexdigest()[:8]
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    stem, ext = os.path.splitext(os.path.basename(out_path))
    dest = os.path.join(d, f"{stem}_{stamp}_{sha8}{ext}")
    if not os.path.exists(dest):
        shutil.copy2(out_path, dest)
    return dest


def guarded_write(payload, out_path, indent=2, **dump_kwargs):
    """Archive-then-write, ATOMICALLY. Never raises; warns and returns
    False on failure, matching the house _write_results convention.

    The write serialises to a string FIRST, then writes a temporary file
    beside the target, fsyncs it, and os.replace()s it into place. The
    earlier version opened the target directly, which truncates before
    json.dump runs — so an unserialisable payload archived the prior run
    and then left the canonical file invalid mid-dump. Reproduced by the
    2026-08-26 scope audit at nine bytes on disk. Nothing was lost
    permanently, since the archive already held the prior run, but the
    canonical path stopped parsing. Serialising first means a payload
    that cannot be encoded fails BEFORE anything on disk is touched.

    dump_kwargs pass through to json.dumps, so a caller may keep
    allow_nan=False rather than inheriting json's permissive default.
    """
    try:
        text = json.dumps(payload, indent=indent, **dump_kwargs)
    except Exception as exc:
        print(f"\n  WARNING: results payload is not serialisable, "
              f"{out_path} left untouched: {exc}", flush=True)
        return False
    try:
        arch = archive_if_needed(out_path, payload)
        if arch:
            print(f"  prior run archived to {arch}", flush=True)
        d = os.path.dirname(os.path.abspath(out_path)) or "."
        fd, tmp = tempfile.mkstemp(dir=d, suffix=".tmp")
        try:
            with os.fdopen(fd, "w") as f:
                f.write(text)
                f.flush()
                os.fsync(f.fileno())
            os.replace(tmp, out_path)
        except Exception:
            try:
                os.unlink(tmp)
            except Exception:
                pass
            raise
        print(f"\n  results written to {out_path}", flush=True)
        return True
    except Exception as exc:
        print(f"\n  WARNING: could not write results JSON to {out_path}: "
              f"{exc}", flush=True)
        return False


def guarded_write_text(text, out_path):
    """The same protection for a NON-JSON artifact.

    utilities/check_results_guard.py's --enforce end state was
    unreachable without this: O62_oeis_submission.py writes three .txt
    files and no JSON, so it could never leave the unguarded column
    while the guard was JSON-only. Found by the 2026-08-26 scope audit.
    Comparison here is on raw bytes — there are no volatile fields to
    blank in a text artifact."""
    try:
        arch = archive_if_needed(out_path, None)
        if arch:
            print(f"  prior run archived to {arch}", flush=True)
        d = os.path.dirname(os.path.abspath(out_path)) or "."
        fd, tmp = tempfile.mkstemp(dir=d, suffix=".tmp")
        try:
            with os.fdopen(fd, "w") as f:
                f.write(text)
                f.flush()
                os.fsync(f.fileno())
            os.replace(tmp, out_path)
        except Exception:
            try:
                os.unlink(tmp)
            except Exception:
                pass
            raise
        print(f"\n  results written to {out_path}", flush=True)
        return True
    except Exception as exc:
        print(f"\n  WARNING: could not write {out_path}: {exc}",
              flush=True)
        return False
