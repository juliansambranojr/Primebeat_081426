#!/usr/bin/env python3
"""run.py — invoke a measurement script so nothing it writes can be lost,
and so every artifact points back at the run that made it.

WHY THIS AND NOT THE RETROFIT. `utilities/resultsguard.py` protects a
script only if that script calls it, and 75 of the tree's 84 writers do
not. Retrofitting them is 75 edits across three different write-site
shapes, each owing a re-run. This intercepts one layer up instead: the
INVOCATION. No script changes, and it covers every script including the
ones nobody has touched since August.

WHAT IT DOES.

  BEFORE   clones results/ with `cp -Rc` — an APFS copy-on-write clone,
           instant and near-free regardless of the 181 MB there, and
           independent of the original, so a script that truncates its
           output cannot reach the clone.
  RUN      execs the script with the interpreter and arguments given,
           streaming its output, and returns its exit code.
  AFTER    for every results file whose bytes changed, copies the PRE
           version to results/archive/<stem>_<utc>_<sha8><ext>. Files
           that did not change are discarded with the clone.
  RECORD   writes results/runs/<utc>_<script>.json — the manifest that
           connects artifact to run: exact argv, interpreter, script
           sha256, git HEAD and dirty flag, start and end times, exit
           code, and for every touched file its pre and post sha256 and
           its archive path.

The archive half is what entry 166 built resultsguard for: O63, O65 and
O66 each lost run 1 to a re-run, and git did not save them because the
clobber preceded any commit. The manifest half is what entries 167 and
168 wanted: O52 has artifacts and no record of the run that made them,
and O61's cited numbers were in no artifact at all.

USE
---
    python3 utilities/run.py O34_zeta_residual_model.py --dps 40
    python3 utilities/run.py --python .venv/bin/python O85_dh_aggregate.py

Anything after the script name is passed through untouched.
"""
import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import tempfile
from datetime import datetime, timezone

_HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(_HERE)
RESULTS = os.path.join(ROOT, "results")
ARCHIVE = os.path.join(RESULTS, "archive")
RUNS = os.path.join(RESULTS, "runs")


VOLATILE = ("generated_utc", "run_start_at", "run_end_at")


def _sha(path):
    """Content hash. For JSON, the volatile timestamp fields are blanked
    first, so a deterministic re-run that differs only in when it ran is
    recognised as unchanged and does not fill the archive with
    near-duplicates. Same rule as utilities/resultsguard.py."""
    if path.endswith(".json"):
        try:
            with open(path) as f:
                obj = json.load(f)
            if isinstance(obj, dict):
                obj = {k: ("" if k in VOLATILE else v)
                       for k, v in obj.items()}
            return hashlib.sha256(
                json.dumps(obj, sort_keys=True).encode()).hexdigest()
        except Exception:
            pass
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for blk in iter(lambda: f.read(1 << 20), b""):
            h.update(blk)
    return h.hexdigest()


def _snapshot(d):
    out = {}
    for base, _dirs, files in os.walk(d):
        if os.path.basename(base) in ("archive", "runs"):
            continue
        for fn in files:
            p = os.path.join(base, fn)
            out[os.path.relpath(p, d)] = _sha(p)
    return out


def _git(*args):
    try:
        return subprocess.run(["git", "-C", ROOT, *args],
                              capture_output=True, text=True).stdout.strip()
    except Exception:
        return ""


def main():
    ap = argparse.ArgumentParser(
        description=("Run a measurement script with its results protected "
                     "and its provenance recorded."),
        usage="run.py [--python PY] SCRIPT [script args ...]")
    ap.add_argument("--python", default=sys.executable,
                    help="interpreter (default: the one running this)")
    ap.add_argument("script")
    ap.add_argument("rest", nargs=argparse.REMAINDER)
    args = ap.parse_args()

    script = args.script if os.path.isabs(args.script) else os.path.join(
        ROOT, args.script)
    if not os.path.isfile(script):
        print(f"run.py: no such script: {args.script}")
        sys.exit(2)

    os.makedirs(ARCHIVE, exist_ok=True)
    os.makedirs(RUNS, exist_ok=True)
    tmp = tempfile.mkdtemp(prefix="pb_run_")
    clone = os.path.join(tmp, "results")
    # APFS copy-on-write clone: instant, independent of the original.
    cp = subprocess.run(["cp", "-Rc", RESULTS, clone], capture_output=True)
    if cp.returncode != 0:                       # non-APFS fallback
        shutil.copytree(RESULTS, clone)
    before = _snapshot(clone)

    started = datetime.now(timezone.utc)
    print(f"run.py: {os.path.basename(script)}  "
          f"({len(before)} results files cloned)\n", flush=True)
    proc = subprocess.run([args.python, script, *args.rest], cwd=ROOT)
    ended = datetime.now(timezone.utc)

    after = _snapshot(RESULTS)
    created, modified = [], []
    for rel, sha in after.items():
        if rel not in before:
            created.append({"path": rel, "sha256": sha})
        elif before[rel] != sha:
            stem, ext = os.path.splitext(os.path.basename(rel))
            dest = os.path.join(
                ARCHIVE,
                f"{stem}_{started.strftime('%Y%m%dT%H%M%SZ')}"
                f"_{before[rel][:8]}{ext}")
            if not os.path.exists(dest):
                shutil.copy2(os.path.join(clone, rel), dest)
            modified.append({"path": rel, "sha256_before": before[rel],
                             "sha256_after": sha,
                             "archived_to": os.path.relpath(dest, ROOT)})
    shutil.rmtree(tmp, ignore_errors=True)

    manifest = {
        "schema_version": "1",
        "script": os.path.relpath(script, ROOT),
        "script_sha256": _sha(script),
        "interpreter": args.python,
        "argv": [os.path.relpath(script, ROOT), *args.rest],
        "run_start_at": started.isoformat(),
        "run_end_at": ended.isoformat(),
        "exit_code": proc.returncode,
        "git_head": _git("rev-parse", "HEAD"),
        "git_dirty": bool(_git("status", "--porcelain")),
        "files_created": created,
        "files_modified": modified,
    }
    mpath = os.path.join(
        RUNS, f"{started.strftime('%Y%m%dT%H%M%SZ')}_"
              f"{os.path.splitext(os.path.basename(script))[0]}.json")
    with open(mpath, "w") as f:
        json.dump(manifest, f, indent=2)

    print(f"\nrun.py: exit {proc.returncode}   "
          f"created {len(created)}   modified {len(modified)}")
    for m in modified:
        print(f"  archived prior {m['path']} -> {m['archived_to']}")
    print(f"  manifest {os.path.relpath(mpath, ROOT)}")
    sys.exit(proc.returncode)


if __name__ == "__main__":
    main()
