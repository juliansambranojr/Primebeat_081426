"""`lab run <unit>` — execute the unit's runnable and record what produced it.

PHASE 2b of `analysis/2026-09-02/lab_design.md`, whose § The CLI gives this
verb one line:

    lab run <unit>        execute run/, capture outputs into the unit

WHAT THIS VERB IS FOR. Entry 306 found a false accept while writing the
fixture that exercises it; entry 307 found a false exemption while writing the
dry run that measures it. Both were caught because a file existed before a
sentence did. `lab run` is that ordering made mechanical: a result gets a log,
a provenance record and a regenerated `values.tsv` before anyone writes a
claim about it, so the window in which a number exists only in a chat message
is closed. The design's § The agent interface states the endpoint -- "No digit
crosses either boundary as a keystroke" -- and a digit cannot cross as a
keystroke if it was in a file first.

THERE IS NO WAY TO RUN SOMETHING OUTSIDE A UNIT. The design's § No scratchpad:

    "Every run creates a unit first. `lab run` refuses to execute anything
     outside a unit, so the record exists before the first number does."

That is a property of the argument, not a check bolted on: this verb takes a
UNIT, never a script or a command line, and the only thing it will execute is
`<unit>/run/run.sh` with the working directory set to `<unit>/run/`. A path
that holds no `unit.md` is refused with that sentence quoted. There is no flag
for a loose script and no environment escape, because the section records what
the escape costs -- twenty-four files in a session scratchpad, and five more a
later audit found that the first sweep had missed.

Consistent with the design's § Enforcement is over artifacts, never over
process, the refusal is over the ARTIFACT: what makes a directory a unit is
that it holds a parsing `unit.md`, not that `lab new` made it. A hand-written
unit runs.

HOW A UNIT DECLARES WHAT TO RUN: `run/run.sh`, and nothing else.

The three candidates were a `run/run.sh`, the single `*.py` under `run/`, and
a front-matter key. Each was weighed against what the container already
promises.

  - A SINGLE `*.py` is implicit, and it stops working the first time a unit
    holds a script plus a helper module, or two scripts. Entry 306 records two
    result JSONs in one unit as a case the values generator had to handle, so
    two scripts in one unit is not hypothetical. It also cannot hold the
    FLAGS, and `lab new`'s own scaffold body asks the author for "the script
    and its flags" -- an invocation without its flags is not a record of what
    ran.
  - A FRONT-MATTER KEY puts the declaration in `unit.md`, outside `run/`. The
    design's § The unit says `run/` is "the code, its results, its logs -- as
    produced", so `run/` should be self-contained: copy it somewhere else and
    it should still say what to do with it. A key in the prose file also makes
    the strict front-matter parser responsible for a path, and every shape it
    rejects becomes a unit that cannot run.
  - `run/run.sh` is explicit, travels with `run/`, holds the flags verbatim,
    imposes no interpreter, and extends to several steps without a format
    change. It is also the exact line that was typed, which is the artifact
    the container audit found missing everywhere else in this tree.

So `run/run.sh`, invoked as `/bin/sh run.sh` with the working directory set to
`run/`. The interpreter is named explicitly rather than relying on the execute
bit or a shebang: git tracks only one permission bit, a `cp -R` or an archive
round trip can lose it, and a unit that stops running because of a file mode
would fail for a reason that is invisible in its own contents. A unit with no
`run/run.sh` is refused by name; there is no fallback, because an implicit
rule is one a reader has to already know.

WHERE THE PROVENANCE LIVES: `run/lab_run.<NNN>.json`, beside its log.

`analysis/2026-09-02/container_audit_report.md` § 5.1 is the finding this
answers: "Zero of the six scripts ... records the interpreter or library
versions it ran under", and its finding 7, "No script records its
environment. ... Python 3.14.3 / numpy 2.5.2 / mpmath 1.3.0 is recorded
nowhere but here." The record therefore goes in the unit, not in a report
about the unit.

It is a JSON UNDER `run/` rather than a sidecar of another shape, and that is
the load-bearing part of the choice. `lab values` takes every `*.json` under
`run/` as a source, so the provenance flattens into `values.tsv` like any
other result and its leaves become citable evidence. A unit whose prose says
"the run took 41.2 s" then has a line to point at. Under any other file shape
that sentence would be a finding -- a true statement reported as a number
without evidence, which is the exact defect PHASE 2b fixed in `lab/check.py`
for string values. Provenance is evidence about the run, so it belongs in the
pool.

The volatile leaves take the `meta.` prefix from `lab/values.py`'s own rule
(`run_start`, `run_end`, `wall_s`, `runnable_sha256`), so `lab/digest.py`
excludes them from the unit digest exactly as the design's § The unit
prescribes. The unit digest still moves between two runs of the same code,
because the provenance JSON enters the manifest by the hash of its bytes and
those bytes carry a timestamp -- but that was already true of every results
JSON carrying a `generated_utc`, including the sealed fixture's, and
`lab/digest.py` records the reading under which it is bit-identity that
matches.

THE RECORD IS WRITTEN SO THAT IT IS NOT EVIDENCE FOR ANYTHING BUT ITSELF.
Every string value in it is a shape `lab/exempt.py` already exempts, which is
why the version fields are written `v3.14.3` rather than `3.14.3` and the
timestamps end in `Z` rather than `+00:00`. Without that, a provenance record
would quietly put `3.14`, `0` and `2026` into the unit's pool, and a prose
number could then find evidence in the metadata of its own run. The run index
appears only in the FILENAME for the same reason: `"log": "lab_run.001.log"`
as a value would contribute the number 1. `tests/test_phase2b.py` asserts the
whole of it: a provenance record contributes exactly two numbers to the pool,
the exit code and the wall time, and both are facts about the run.

LIBRARY VERSIONS ARE NOT RECORDED, deliberately. `lab` cannot know which
libraries a runnable imports, and importing candidates in order to version
them would give the program dependencies -- the design's § The CLI says
"standard library only for the program itself". The runnable knows; `run.sh`
is free to print `numpy.__version__` into the log, and the log is in the unit.

DECISIONS taken here where the design is silent:

  - NOTHING IS EVER OVERWRITTEN. The log and the provenance record share an
    index, and the index is the lowest for which NEITHER file exists. A second
    run of a unit writes `lab_run.002.*` beside the first. The design makes a
    unit immutable only once sealed; before that, an accumulating record is
    the honest one, and the failure mode this avoids -- a re-run destroying
    the run it is compared against -- is what `utilities/resultsguard.py` and
    entry 166 exist for.
  - STDOUT AND STDERR GO TO ONE LOG, INTERLEAVED, and stream to the terminal
    as they arrive. One log because the design's § The unit says "its logs --
    as produced" and a reader diagnosing a crash wants the error next to the
    output that preceded it. The cost is real and stated: the two streams
    cannot be told apart afterwards.
  - A SEALED UNIT IS REFUSED. The design's § The unit makes a sealed unit
    immutable and a re-run "a new unit that `supersedes:` the old one". Refusal
    is exit 1 with the supersede recipe, matching `lab seal`'s wording.
  - VALUES ARE REGENERATED ONLY ON SUCCESS. The brief's wording, and the
    right reading: regenerating after a crash would fold a half-written result
    into the evidence pool, so a prose number could take its evidence from a
    run that failed. On failure `values.tsv` is left exactly as it was and the
    message says so.
  - A FAILURE IS DIAGNOSABLE AND LOUD. The log and the provenance record are
    written whatever the exit code, so the reader gets the output, the exact
    command, the environment and the code that came back. `lab run` then exits
    1 -- the uniform "the command refused, or something is wrong" code of
    `lab/cli.py`, not the runnable's own code, which is recorded rather than
    propagated.
  - THE UNIT NEED NOT ALREADY HAVE A `values.tsv`. Unlike `lab check`, this
    resolves the unit through `locate` and reads the front matter directly, so
    a unit whose values file has not been generated yet can still be run --
    which is the ordinary case, since generating it is what this ends with.
"""

import hashlib
import json
import pathlib
import platform
import re
import shutil
import subprocess
import sys
import time
from datetime import datetime, timezone

from . import values as values_mod
from .unit import UnitError, locate, parse_front_matter, split_front_matter

__all__ = ["RUNNABLE", "STEM", "next_index", "provenance", "execute", "run"]

RUNNABLE = "run.sh"
STEM = "lab_run"
SHELL = "/bin/sh"
# `-e`, and this was found by the verification rather than designed in. The
# first failing-runnable test raised a ValueError out of python3, `run.sh`
# carried on to its next line, and `sh` returned the exit status of that last
# successful `echo` -- so `lab run` reported exit 0, regenerated values.tsv
# from a crashed run, and the failure was silent. That is the defect class
# this whole program exists to close, reproduced inside the program itself.
# With `-e` the shell aborts at the first failing command and returns its
# status. Residue, stated: POSIX `-e` does not fire for a command whose status
# is being tested (inside `if`, or on the left of `&&`), nor for a non-final
# member of a pipeline. A runnable that hides a failure in one of those places
# still reports success, and the log is where a reader sees it.
SHELL_FLAGS = ["-e"]
INDEX = re.compile(rf"^{STEM}\.(\d+)\.(?:log|json)$")


def _utc():
    """An ISO timestamp the `date` exemption class covers whole.

    `%SZ` rather than `isoformat()`: the latter renders the offset `+00:00`,
    whose trailing `00` the class does not reach, and the value would put a
    zero into the pool.
    """
    return datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def _version(text):
    """A dotted version written so `lab/exempt.py`'s `version` class holds it."""
    return f"v{text}" if text and not text.startswith("v") else (text or None)


def next_index(run_dir):
    """The lowest index for which neither the log nor the record exists."""
    taken = set()
    if run_dir.is_dir():
        for path in run_dir.iterdir():
            m = INDEX.match(path.name)
            if m:
                taken.add(int(m.group(1)))
    n = 1
    while n in taken:
        n += 1
    return n


def _path_python():
    """`python3 --version` as seen on PATH, or None. What a script will use."""
    exe = shutil.which("python3")
    if not exe:
        return None
    try:
        r = subprocess.run([exe, "--version"], capture_output=True, text=True,
                           timeout=30)
    except (OSError, subprocess.SubprocessError):
        return None
    if r.returncode != 0:
        return None
    return _version((r.stdout or r.stderr).strip().split()[-1])


def _git(root):
    """(HEAD sha, dirty flag) for the checkout `root` sits in, or (None, None)."""
    def call(*args):
        try:
            r = subprocess.run(["git", *args], cwd=root, capture_output=True,
                               text=True, timeout=30)
        except (OSError, subprocess.SubprocessError):
            return None
        return r.stdout.strip() if r.returncode == 0 else None

    head = call("rev-parse", "HEAD")
    if head is None:
        return None, None
    status = call("status", "--porcelain")
    return head, (bool(status) if status is not None else None)


def environment(root):
    """The environment block: every value a shape the exemption list covers."""
    head, dirty = _git(root)
    venv = pathlib.Path(sys.prefix).name if sys.prefix != sys.base_prefix \
        else None
    return {
        "lab_python": _version(platform.python_version()),
        "path_python3": _path_python(),
        "shell": SHELL,
        "os": f"{platform.system()} "
              f"{_version(platform.release())} {platform.machine()}",
        "virtual_env": venv,
        "git_head": head,
        "git_dirty": dirty,
    }


def provenance(unit_path, argv, exit_code, started, ended, wall):
    """The record `run/lab_run.<NNN>.json` holds, in the order it is written."""
    unit_path = pathlib.Path(unit_path)
    runnable = unit_path / "run" / RUNNABLE
    return {
        # `v1.0`, not `1`: a bare "1" is a string value the pool now reads,
        # and the record's own schema number would become evidence. Written
        # as a dotted version, `lab/exempt.py`'s `version` class holds it.
        "schema_version": "v1.0",
        "unit": f"units/{unit_path.name}",
        "runnable": f"run/{RUNNABLE}",
        "command": " ".join(argv),
        "argv": list(argv),
        "cwd": "run",
        "exit_code": exit_code,
        "environment": environment(unit_path),
        "meta": {
            "runnable_sha256": hashlib.sha256(
                runnable.read_bytes()).hexdigest(),
            "run_start": started,
            "run_end": ended,
            "wall_s": wall,
        },
    }


def execute(run_dir, log_path, out):
    """Run the runnable, streaming to `out` and to the log. Returns the code."""
    argv = [SHELL, *SHELL_FLAGS, RUNNABLE]
    started, clock = _utc(), time.monotonic()
    with log_path.open("w", encoding="utf-8") as log:
        # The unit-relative `run/`, never the absolute path: the log enters
        # the unit digest by the hash of its bytes, and an absolute path
        # would make the digest depend on where the checkout happens to sit.
        log.write(f"# {STEM} -- {' '.join(argv)} in run/\n")
        log.write(f"# started {started}\n")
        log.flush()
        proc = subprocess.Popen(argv, cwd=run_dir, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT, text=True,
                                bufsize=1)
        for line in proc.stdout:
            log.write(line)
            print(line, end="", file=out)
        code = proc.wait()
        wall = time.monotonic() - clock
        ended = _utc()
        log.write(f"# exit {code} after {wall:.3f}s, ended {ended}\n")
    return argv, code, started, ended, wall


def run(arg, out, err, cwd=None):
    """`lab run <unit>`: 0 clean, 1 refused or the runnable failed, 2 usage."""
    try:
        path = locate(arg, cwd=cwd)
    except UnitError as exc:
        print(f"lab run: {exc}", file=err)
        return 2
    md = path / "unit.md"
    if not md.is_file():
        print(f"lab run: {path}: no unit.md, so this is not a unit and "
              f"nothing here will be executed. `lab run` refuses to execute "
              f"anything outside a unit, so the record exists before the "
              f"first number does (design § No scratchpad). Make one: "
              f"lab new <slug>", file=err)
        return 2
    try:
        fm_text, _ = split_front_matter(md.read_text(encoding="utf-8"))
        front = parse_front_matter(fm_text)
    except Exception as exc:                     # FrontMatterError and friends
        print(f"lab run: {md}: {exc}", file=err)
        return 2

    if front.get("sealed") is True:
        print(f"REFUSED    {path} is sealed; a re-run is a new unit that "
              f"supersedes this one:  lab new <slug>, then set "
              f"supersedes: [{path.name.split('-')[0]}]", file=out)
        return 1

    run_dir = path / "run"
    runnable = run_dir / RUNNABLE
    if not runnable.is_file():
        print(f"REFUSED    {path}: no {run_dir.name}/{RUNNABLE}. A unit "
              f"declares what to run by holding one; write the exact "
              f"invocation and its flags into it.", file=out)
        return 1

    index = next_index(run_dir)
    log_path = run_dir / f"{STEM}.{index:03d}.log"
    record_path = run_dir / f"{STEM}.{index:03d}.json"

    argv, code, started, ended, wall = execute(run_dir, log_path, out)
    record = provenance(path, argv, code, started, ended, wall)
    record_path.write_text(json.dumps(record, indent=2) + "\n",
                           encoding="utf-8")
    print(f"LOG        {log_path}", file=out)
    print(f"RECORD     {record_path}", file=out)

    if code != 0:
        print(f"FAILED     {' '.join(argv)} exited {code} after {wall:.3f}s; "
              f"values.tsv is unchanged. The output is in {log_path.name} and "
              f"what ran is in {record_path.name}.", file=err)
        return 1

    tsv, keys, skipped = values_mod.write(path)
    for message in skipped:
        print(f"SKIPPED    {message}", file=err)
    print(f"{path}: exit {code} after {wall:.3f}s; {tsv.name} regenerated, "
          f"{keys} key(s)", file=out)
    return 1 if skipped else 0
