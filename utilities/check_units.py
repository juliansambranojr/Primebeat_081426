#!/usr/bin/env python3
"""The commit gate's unit check: `lab check` on every unit in the staged diff.

    python3 utilities/check_units.py

PHASE 2 of `analysis/2026-09-02/lab_design.md`, whose § Enforcement puts two
rows at the commit gate:

    | number in prose with no evidence | format + `lab check` at the commit gate |
    | overwritten result               | format -- sealed units are immutable    |

and whose closing line explains why the gate rather than a hook carries them:
"A commit gate is patchable from inside a session where a hook is not, which
is why the gate carries the load."

Three rules, over `git diff --cached --name-only`:

  1. Every `units/<unit>/` directory touched must pass `lab check` (exit 0).
     Units expected to fail are listed with a reason in
     `utilities/lab_check_baseline.txt`, the same shape as
     `utilities/refs_baseline.txt`, because `units/0000-smoke` is a permanent
     FAILING fixture and a gate that refused it would refuse every commit.
  2. A unit that HEAD records as `sealed: true` may not appear in the staged
     diff at all, in any file. A sealed unit is immutable; a changed result is
     a new unit that `supersedes:` it.
  3. PHASE 2b, THE ONE-HOME RULE. A result written from here on lives inside a
     unit. A staged file under `results/` or `analysis/**/results/` that HEAD
     does not already track at that path is refused, and `lab new` plus
     `lab run` are named as where it goes instead. A staged change to a file
     HEAD already tracks there passes untouched: those two trees freeze
     exactly as `notes/lab_notebook_2.md` freezes, and everything they hold
     stays.

THE ONE-HOME RULE IS OVER THE ARTIFACT, per the design's § Enforcement is over
artifacts, never over process: "the gate never asks whether `lab new` was run.
It asks whether the thing on disk has the properties `lab new` produces." So
the test is `git cat-file -e HEAD:<path>` -- is this path already in the
frozen tree -- and nothing else. It does not ask which tool wrote the file,
whether a unit exists for it, or whether the author knew the rule. A file
copied in by hand, emitted by an old script, or produced by a run outside the
repo is refused identically, for where it is. That also makes the rule
survive the thing it is defending against: a run that never called a verb
still cannot land its output outside a unit.

WHY HEAD RATHER THAN THE STATUS LETTER. `git diff --cached --name-status`
reports `A` for an add and `R` for a rename, and a rename INTO `results/` is a
new path in the frozen tree while its letter says otherwise. Asking HEAD
whether the path exists answers the question the rule actually asks, in one
form, for adds, renames and copies alike. A staged DELETION passes: the path
is in HEAD.

SEALED IS READ FROM HEAD, NEVER FROM THE WORKING TREE. A commit that flipped
`sealed: true` to `false` in the same diff would otherwise unseal itself and
pass. Reading HEAD also lets the ordinary flow work: `lab seal` then commit
finds HEAD holding the unit unsealed (or not holding it at all), so the seal
commit lands, and every later edit to it is refused.

WHICH `lab` RUNS. The installed console script when `lab` is on PATH -- that
is `pip install -e .`, per the design's § The CLI -- and `python3 -m lab.cli`
otherwise, which is what a bare terminal without the venv activated has. Both
run the same code out of `lab/`. If NEITHER runs, this exits nonzero and says
so: the unit check is never skipped quietly, because a gate that goes silent
when its tool is missing is a gate that reports clean on the day it matters.

Exit 0 clean, 1 refused, 2 `lab` could not be run. The commit gate refuses on
any nonzero. Rule 3 needs no `lab` at all, so it is evaluated and reported
before the `lab` probe: a checkout without the program installed still cannot
land a result outside a unit.

WHY THIS IS A SEPARATE FILE. Phase 2's brief put both rules directly in
`utilities/hooks/pre-commit`. That file is guarded:
`utilities/hooks/check_protected_write.py` denies any write under
`utilities/hooks/` without `.approve/<basename>`, and
`utilities/hooks/check_bash_guard.py` refuses any command from a session that
would create, list or remove such a flag -- flags are Julian's, from his own
terminal. So the logic lives here, where it is testable on its own, and the
gate gains four lines.

CORRECTION. The version of this docstring Phase 2 shipped closed with "Until
that edit is applied the two rules are not enforced at commit time. Run this
by hand in the meantime." Julian applied it: `utilities/hooks/pre-commit`
carries section 8 and its header entry, and calls this file. The rules here
are enforced at commit time, and adding a rule to this file arms it without
touching the guarded gate.
"""
import pathlib
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
BASELINE = ROOT / "utilities" / "lab_check_baseline.txt"


def lab_command():
    """(argv prefix, one line saying which form was chosen), or (None, why)."""
    candidates = []
    if shutil.which("lab"):
        candidates.append((["lab"], "the installed `lab` console script"))
    candidates.append(([sys.executable, "-m", "lab.cli"],
                       "python3 -m lab.cli"))
    for argv, how in candidates:
        try:
            r = subprocess.run(argv + ["--version"], cwd=ROOT,
                               capture_output=True, text=True)
        except OSError:
            continue
        if r.returncode == 0:
            return argv, how
    return None, ("neither `lab` on PATH nor `python3 -m lab.cli` runs from "
                  f"{ROOT}")


def git(*args):
    r = subprocess.run(["git", *args], cwd=ROOT, capture_output=True,
                       text=True)
    return r.returncode, r.stdout


def staged_files():
    _, out = git("diff", "--cached", "--name-only")
    return [line for line in out.split("\n") if line.strip()]


def touched_units(files):
    """{unit relpath: [staged files under it]}, in path order."""
    units = {}
    for f in files:
        parts = f.split("/")
        if len(parts) >= 3 and parts[0] == "units":
            units.setdefault("/".join(parts[:2]), []).append(f)
    return dict(sorted(units.items()))


def sealed_in_head(unit):
    """True when HEAD's copy of the unit declares `sealed: true`."""
    code, out = git("show", f"HEAD:{unit}/unit.md")
    if code != 0:
        return False                    # new in this commit, so not yet sealed
    lines = out.split("\n")
    for n, line in enumerate(lines):
        if n > 0 and line.strip() == "---":
            break                       # end of the front-matter block
        if line.strip() == "sealed: true":
            return True
    return False


def in_frozen_results(path):
    """True when a repo-relative path sits under a frozen results tree.

    The two the design freezes: `results/` at the root, and any `results/`
    directory under `analysis/`. A component named `results` is required to be
    a DIRECTORY component, never the file itself, so a file called `results`
    is not mistaken for the tree of the same name.
    """
    parts = path.split("/")
    if len(parts) < 2:
        return False
    if parts[0] == "results":
        return True
    return parts[0] == "analysis" and "results" in parts[1:-1]


def tracked_in_head(path):
    """True when HEAD already holds a blob at exactly this path."""
    code, _ = git("cat-file", "-e", f"HEAD:{path}")
    return code == 0


def new_results_files(files):
    """Staged paths under a frozen results tree that HEAD does not hold."""
    return [f for f in files
            if in_frozen_results(f) and not tracked_in_head(f)]


def report_one_home(files, out=print):
    """Rule 3. Returns the refused paths, having printed the refusal."""
    offenders = new_results_files(files)
    if not offenders:
        return offenders
    out("-- A result written from here on lives inside a unit --")
    for f in offenders:
        out(f"   NEW  {f}")
    out("   results/ and analysis/**/results/ are frozen: what they already")
    out("   hold stays, and nothing new is added to them.")
    out("   Put it in a unit instead:")
    out("     lab new <slug>       scaffolds units/<id>-<slug>/")
    out("     lab run <unit>       executes run/run.sh, captures the log and")
    out("                          the provenance record, regenerates values.tsv")
    return offenders


def baseline():
    """{unit relpath: reason} for units `lab check` is expected to fail."""
    out = {}
    if not BASELINE.is_file():
        return out
    for line in BASELINE.read_text(encoding="utf-8").split("\n"):
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        unit, _, reason = line.partition(" ")
        out[unit.rstrip("/")] = reason.strip()
    return out


def main():
    files = staged_files()

    # Rule 3 first: it reads git alone, so it holds in a checkout where the
    # program is not installed.
    one_home = report_one_home(files)

    units = touched_units(files)
    if not units:
        return 1 if one_home else 0

    argv, how = lab_command()
    if argv is None:
        print("-- lab is not runnable, and the unit check is not skippable --")
        print(f"   {how}")
        print("   Install it:  pip install -e .")
        return 2

    known = baseline()
    refused, checked = [], 0
    print(f"   unit check via {how}")

    for unit, staged in units.items():
        if sealed_in_head(unit):
            print(f"-- Staged change to a SEALED unit: {unit} --")
            for f in staged:
                print(f"   {f}")
            print("   A sealed unit is immutable. A changed result is a NEW")
            print("   unit that supersedes it:  lab new <slug>, then set")
            print(f"   supersedes: [{pathlib.PurePath(unit).name.split('-')[0]}]")
            refused.append(unit)
            continue
        if not (ROOT / unit).is_dir():
            continue                    # deleted outright; nothing left to read
        r = subprocess.run(argv + ["check", unit], cwd=ROOT,
                           capture_output=True, text=True)
        checked += 1
        expected_to_fail = unit in known
        if r.returncode == 0 and expected_to_fail:
            print(f"   {unit} now PASSES and is still in "
                  f"{BASELINE.relative_to(ROOT)}; trim it")
            continue
        if r.returncode == 0:
            print(f"   OK  {unit}")
            continue
        if expected_to_fail:
            print(f"   baselined  {unit}  ({known[unit]})")
            continue
        print(f"-- {unit} does not pass `lab check` (exit {r.returncode}) --")
        print(r.stdout.rstrip("\n") or r.stderr.rstrip("\n"))
        print("   Every number in a unit's prose must appear in that unit's")
        print(f"   own values.tsv.  lab values {unit}, or fix the prose.")
        refused.append(unit)

    print(f"   {checked} unit(s) checked, {len(refused)} refused")
    return 1 if (refused or one_home) else 0


if __name__ == "__main__":
    sys.exit(main())
