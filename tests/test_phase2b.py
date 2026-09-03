"""Phase 2b tests: `lab run`, and the one home a result is allowed to have.

    python3 -m pytest tests/test_phase2b.py -q

Two subjects. `lab run` is the verb the design's § No scratchpad requires —
"every run creates a unit first ... so the record exists before the first
number does" — so the tests here are mostly about what it REFUSES and about
what it leaves behind when the runnable fails, which is the state a reader has
to be able to open.

The one-home rule is the container half of the same section, and its own
§ One home for a result: a staged file under `results/` or
`analysis/**/results/` that HEAD does not already track is refused. Its
git-index behaviour is exercised from the shell against a throwaway
`GIT_INDEX_FILE`, because its subject is git's index; what is asserted here is
the path predicate and the refusal message, which are pure.

The fixtures are COPIED into `tmp_path` before being run. Running them in
place would accumulate `lab_run.<NNN>.*` files in the tree on every test
invocation, and the committed fixtures are meant to hold exactly one run each,
as the record of what this phase produced.
"""

import io
import json
import pathlib
import shutil
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                          # noqa: E402
from lab import run as run_mod                              # noqa: E402
from lab import values as values_mod                        # noqa: E402
from utilities import check_units                           # noqa: E402

SMOKE = ROOT / "units" / "0003-run-smoke"
FAILS = ROOT / "units" / "0004-run-fails"
SEALED = ROOT / "units" / "0002-smoke-sealed"
CLEAN = ROOT / "units" / "0001-smoke-clean"


def fresh(tmp_path, fixture):
    """A copy of a fixture with any recorded run removed."""
    dest = tmp_path / fixture.name
    shutil.copytree(fixture, dest)
    for path in (dest / "run").glob(f"{run_mod.STEM}.*"):
        path.unlink()
    for path in (dest / "run").glob("*.json"):
        path.unlink()
    values_mod.write(dest)
    return dest


def invoke(path):
    """(exit code, stdout, stderr) for `lab run <path>`."""
    out, err = io.StringIO(), io.StringIO()
    code = run_mod.run(str(path), out, err)
    return code, out.getvalue(), err.getvalue()


# --- what it refuses --------------------------------------------------------

def test_a_directory_that_is_not_a_unit_is_refused(tmp_path):
    """§ No scratchpad, enforced by the shape of the argument."""
    loose = tmp_path / "scratch"
    loose.mkdir()
    (loose / "run").mkdir()
    (loose / "run" / "run.sh").write_text("echo 41.2\n", encoding="utf-8")
    code, out, err = invoke(loose)
    assert code == 2
    assert "refuses to execute anything outside a unit" in err
    assert not list((loose / "run").glob(f"{run_mod.STEM}.*"))


def test_a_sealed_unit_is_refused_and_nothing_is_written(tmp_path):
    unit = tmp_path / SEALED.name
    shutil.copytree(SEALED, unit)
    before = sorted(p.name for p in unit.rglob("*"))
    code, out, err = invoke(unit)
    assert code == 1
    assert "is sealed" in out and "supersedes" in out
    assert sorted(p.name for p in unit.rglob("*")) == before


def test_a_unit_with_no_runnable_is_refused_by_name(tmp_path):
    unit = tmp_path / CLEAN.name
    shutil.copytree(CLEAN, unit)
    code, out, err = invoke(unit)
    assert code == 1
    assert f"no run/{run_mod.RUNNABLE}" in out


# --- what it leaves behind --------------------------------------------------

def test_a_successful_run_writes_a_log_a_record_and_a_values_file(tmp_path):
    unit = fresh(tmp_path, SMOKE)
    assert (unit / "values.tsv").read_text(encoding="utf-8") == values_mod.EMPTY
    code, out, err = invoke(unit)
    assert code == 0, err

    log = unit / "run" / f"{run_mod.STEM}.001.log"
    record = unit / "run" / f"{run_mod.STEM}.001.json"
    assert log.is_file() and record.is_file()
    assert "computing the ladder ratio" in log.read_text(encoding="utf-8")

    got = json.loads(record.read_text(encoding="utf-8"))
    assert got["exit_code"] == 0
    assert got["command"] == "/bin/sh -e run.sh"
    assert got["environment"]["lab_python"].startswith("v")
    assert got["meta"]["wall_s"] > 0
    assert set(got["meta"]) == {"runnable_sha256", "run_start", "run_end",
                                "wall_s"}

    values = (unit / "values.tsv").read_text(encoding="utf-8")
    assert "ladder.ladder.ratio\t3.070311505664645" in values
    assert "ladder.census.rows\t422" in values


def test_a_failing_runnable_exits_non_zero_and_stays_diagnosable(tmp_path):
    unit = fresh(tmp_path, FAILS)
    untouched = (unit / "values.tsv").read_text(encoding="utf-8")
    code, out, err = invoke(unit)
    assert code == 1
    assert "values.tsv is unchanged" in err

    log = (unit / "run" / f"{run_mod.STEM}.001.log").read_text(encoding="utf-8")
    assert "the grid is empty at this rung" in log
    assert "this line is never reached" not in log      # `sh -e` stopped there

    record = json.loads(
        (unit / "run" / f"{run_mod.STEM}.001.json").read_text(encoding="utf-8"))
    assert record["exit_code"] != 0
    assert (unit / "values.tsv").read_text(encoding="utf-8") == untouched


def test_a_second_run_does_not_overwrite_the_first(tmp_path):
    unit = fresh(tmp_path, SMOKE)
    assert invoke(unit)[0] == 0
    first = (unit / "run" / f"{run_mod.STEM}.001.log").read_bytes()
    assert invoke(unit)[0] == 0
    assert (unit / "run" / f"{run_mod.STEM}.001.log").read_bytes() == first
    assert (unit / "run" / f"{run_mod.STEM}.002.log").is_file()
    assert (unit / "run" / f"{run_mod.STEM}.002.json").is_file()


def test_the_index_skips_a_gap_rather_than_reusing_it(tmp_path):
    run_dir = tmp_path / "run"
    run_dir.mkdir()
    assert run_mod.next_index(run_dir) == 1
    (run_dir / f"{run_mod.STEM}.001.log").write_text("", encoding="utf-8")
    assert run_mod.next_index(run_dir) == 2
    (run_dir / f"{run_mod.STEM}.002.json").write_text("{}", encoding="utf-8")
    assert run_mod.next_index(run_dir) == 3


# --- provenance is evidence about the run, and about nothing else -----------

def test_the_record_contributes_exactly_the_exit_code_and_the_wall_time(
        tmp_path):
    """Every other field is written in a shape the exemption list covers.

    Without that a prose number could take its evidence from the metadata of
    its own run — a version, a timestamp, a git sha or a machine name.
    """
    unit = fresh(tmp_path, SMOKE)
    for path in (unit / "run").glob("*.py"):
        path.unlink()
    (unit / "run" / run_mod.RUNNABLE).write_text("echo ok\n", encoding="utf-8")
    assert invoke(unit)[0] == 0

    values = {}
    for line in (unit / "values.tsv").read_text(encoding="utf-8").split("\n"):
        if line and not line.startswith("#") and "\t" in line:
            key, value = line.split("\t", 1)
            values[key] = value
    numeric, from_strings = check_mod.pool_parts(values)
    assert from_strings - numeric == set(), from_strings
    record = json.loads(
        (unit / "run" / f"{run_mod.STEM}.001.json").read_text(encoding="utf-8"))
    assert len(numeric) == 2
    assert float(record["meta"]["wall_s"]) in {float(v) for v in numeric}
    assert 0 in {int(v) for v in numeric if v == v.to_integral_value()}


# --- the one-home rule: the path predicate and the refusal ------------------

FROZEN = [
    "results/arrow_price.json",
    "results/archive/O47_run1.json",
    "analysis/2026-09-02/results/arrow_price.numbers",
    "analysis/2026-08-19_table_structure/results/x.json",
]
NOT_FROZEN = [
    "units/0003-run-smoke/run/ladder.json",
    "analysis/2026-09-02/lab_design.md",
    "lab/run.py",
    "results",                      # the name alone, not the tree
    "papers/results_of_O47.md",     # a filename that merely starts the same
    "analysis/results.md",          # `results` as the FILE, not a directory
]


@pytest.mark.parametrize("path", FROZEN)
def test_a_frozen_results_path_is_recognised(path):
    assert check_units.in_frozen_results(path)


@pytest.mark.parametrize("path", NOT_FROZEN)
def test_everything_else_is_not(path):
    assert not check_units.in_frozen_results(path)


def test_the_refusal_names_the_two_verbs(monkeypatch):
    """Refused for WHERE it is, with no reference to how it got there."""
    monkeypatch.setattr(check_units, "tracked_in_head", lambda p: False)
    lines = []
    offenders = check_units.report_one_home(
        ["results/new_thing.json", "lab/run.py"], out=lines.append)
    assert offenders == ["results/new_thing.json"]
    text = "\n".join(lines)
    assert "lab new" in text and "lab run" in text
    assert "results/new_thing.json" in text
    assert "lab/run.py" not in text


def test_a_modification_to_a_tracked_results_file_passes(monkeypatch):
    monkeypatch.setattr(check_units, "tracked_in_head", lambda p: True)
    lines = []
    assert check_units.report_one_home(
        ["results/arrow_price.json"], out=lines.append) == []
    assert lines == []
