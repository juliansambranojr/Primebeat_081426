"""Phase 1 tests for `lab`: new, values, seal, and immutability in check.

    python3 -m pytest tests/test_phase1.py -q

Like `tests/test_lab.py`, the commands are exercised in process through the
`run` function each one exports, which is what `lab.cli.main` calls and what
returns the exit code, so nothing here depends on the console script having
been installed. Every path is absolute, so nothing depends on the working
directory either.

THE COMMITTED FIXTURE IS NEVER TOUCHED. `units/0002-smoke-sealed` is sealed,
and a test that edited it would break the very guarantee it is testing. The
tamper test copies the whole unit into `tmp_path` and damages the copy.
"""

import io
import json
import pathlib
import shutil
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                        # noqa: E402
from lab import digest as digest_mod                      # noqa: E402
from lab import new as new_mod                            # noqa: E402
from lab import seal as seal_mod                          # noqa: E402
from lab import values as values_mod                      # noqa: E402
from lab.unit import load                                 # noqa: E402

FAILING = ROOT / "units" / "0000-smoke"
CLEAN = ROOT / "units" / "0001-smoke-clean"
SEALED = ROOT / "units" / "0002-smoke-sealed"


def _run(fn, *args, **kwargs):
    out, err = io.StringIO(), io.StringIO()
    code = fn(*args, out, err, **kwargs)
    return code, out.getvalue(), err.getvalue()


def check(arg):
    return _run(check_mod.run, str(arg))


def values(arg):
    return _run(values_mod.run, str(arg))


def seal(arg):
    return _run(seal_mod.run, str(arg))


def new(slug, cwd, **kwargs):
    return _run(new_mod.run, slug, cwd=cwd, **kwargs)


@pytest.fixture
def units(tmp_path):
    """An empty `units/` directory to scaffold into."""
    root = tmp_path / "units"
    root.mkdir()
    return root


RESULT = {
    "schema_version": "1",
    "generated_utc": "2026-09-02T00:00:00Z",
    "ladder": {"ratio": 3.070311505664645, "residual": 0.018401},
    "census": {"rows": 422},
    "timings": {"elapsed_s": 12.5},
}


def _write_json(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


# --- lab new ----------------------------------------------------------------

def test_new_scaffolds_a_unit_that_loads_and_checks_clean(units, tmp_path):
    code, out, err = new("fixed-window-Lc", cwd=tmp_path)
    assert (code, err) == (0, "")
    path = units / "0000-fixed-window-Lc"
    assert path.is_dir()
    for name in ("unit.md", "question.md", "values.tsv", "run/.gitkeep"):
        assert (path / name).is_file(), name

    unit = load(str(path))
    assert unit.id == "0000"
    assert unit.front_matter["sealed"] is False
    assert unit.front_matter["title"] == "fixed-window-Lc"
    assert unit.front_matter["refs"] == []
    assert unit.values == {}

    code, out, _ = check(path)
    assert code == 0
    assert "0 number(s) in prose, 0 matched, 0 unmatched" in out


def test_new_values_file_is_what_lab_values_regenerates(units, tmp_path):
    """A fresh scaffold is already the output `lab values` would write."""
    new("empty-run", cwd=tmp_path)
    path = units / "0000-empty-run"
    before = (path / "values.tsv").read_text()
    assert before == values_mod.EMPTY
    code, _, _ = values(path)
    assert code == 0
    assert (path / "values.tsv").read_text() == before


def test_new_allocates_the_next_id_by_scanning_the_directory(units, tmp_path):
    (units / "0000-one").mkdir()
    (units / "0007-seven").mkdir()
    (units / "not-a-unit").mkdir()
    new("eight", cwd=tmp_path)
    assert (units / "0008-eight").is_dir()
    assert load(str(units / "0008-eight")).id == "0008"


def test_new_refuses_a_path_that_already_exists(units, tmp_path):
    """Only a non-directory can occupy the next id, since ids come from dirs."""
    (units / "0000-twice").write_text("a file where a unit would go\n")
    code, _, err = new("twice", cwd=tmp_path)
    assert code == 1
    assert "already exists" in err


def test_new_refuses_a_slug_that_is_not_a_slug(units, tmp_path):
    for bad in ("has space", "has/slash", "", "-leading", "trailing-"):
        code, _, err = new(bad, cwd=tmp_path)
        assert code == 2, bad
        assert "is not a slug" in err


def test_new_type_and_title_reach_the_front_matter(units, tmp_path):
    new("typed", cwd=tmp_path, type_="instrument-fix", title="A real title")
    front = load(str(units / "0000-typed")).front_matter
    assert front["type"] == "instrument-fix"
    assert front["title"] == "A real title"


# --- lab values -------------------------------------------------------------

def test_values_flattens_a_result_and_prefixes_it_with_the_stem(units, tmp_path):
    new("one-result", cwd=tmp_path)
    path = units / "0000-one-result"
    _write_json(path / "run" / "ladder.json", RESULT)
    code, out, err = values(path)
    assert (code, err) == (0, "")
    assert "6 key(s) from 1 of 1 result file(s)" in out

    table = load(str(path)).values
    assert table["ladder.ladder.ratio"] == "3.070311505664645"
    assert table["ladder.census.rows"] == "422"
    assert table["meta.ladder.timings.elapsed_s"] == "12.5"
    assert table["meta.ladder.generated_utc"] == '"2026-09-02T00:00:00Z"'


def test_values_is_idempotent(units, tmp_path):
    new("twice-over", cwd=tmp_path)
    path = units / "0000-twice-over"
    _write_json(path / "run" / "ladder.json", RESULT)
    values(path)
    first = (path / "values.tsv").read_bytes()
    values(path)
    assert (path / "values.tsv").read_bytes() == first


def test_two_result_files_with_the_same_inner_key_do_not_collide(units, tmp_path):
    new("two-results", cwd=tmp_path)
    path = units / "0000-two-results"
    _write_json(path / "run" / "first.json", {"rows": 422})
    _write_json(path / "run" / "second.json", {"rows": 61})
    code, _, _ = values(path)
    assert code == 0
    table = load(str(path)).values
    assert table["first.rows"] == "422"
    assert table["second.rows"] == "61"


def test_a_nested_result_keeps_its_path_as_the_prefix(units, tmp_path):
    new("nested", cwd=tmp_path)
    path = units / "0000-nested"
    _write_json(path / "run" / "sweep" / "first.json", {"rows": 422})
    _write_json(path / "run" / "first.json", {"rows": 61})
    values(path)
    table = load(str(path)).values
    assert table["first.rows"] == "61"
    assert table["sweep/first.rows"] == "422"


def test_values_reports_and_skips_a_file_it_cannot_parse(units, tmp_path):
    new("broken-result", cwd=tmp_path)
    path = units / "0000-broken-result"
    _write_json(path / "run" / "good.json", {"rows": 422})
    (path / "run" / "bad.json").write_text("not json at all\n", encoding="utf-8")
    code, out, err = values(path)
    assert code == 1
    assert "SKIPPED" in err and "run/bad.json" in err
    text = (path / "values.tsv").read_text()
    assert "# skipped run/bad.json" in text          # durable, not only on stderr
    assert load(str(path)).values["good.rows"] == "422"


def test_values_needs_a_unit(tmp_path):
    code, _, err = values(tmp_path / "nothing-here")
    assert code == 2
    assert "nothing-here" in err


# --- lab seal ---------------------------------------------------------------

def _sealable(units, tmp_path, slug="sealable"):
    new(slug, cwd=tmp_path)
    path = units / f"0000-{slug}"
    _write_json(path / "run" / "ladder.json", RESULT)
    values(path)
    return path


def test_seal_writes_a_manifest_and_flips_the_front_matter(units, tmp_path):
    path = _sealable(units, tmp_path)
    code, out, err = seal(path)
    assert (code, err) == (0, "")
    assert "SEALED" in out
    assert load(str(path)).front_matter["sealed"] is True

    manifest = path / digest_mod.MANIFEST
    files, stable, unit_digest = digest_mod.parse(
        manifest.read_text(encoding="utf-8"))
    assert set(files) == {"unit.md", "question.md", "values.tsv",
                          "run/.gitkeep", "run/ladder.json"}
    assert digest_mod.MANIFEST not in files      # never hashes itself
    assert len(unit_digest) == 64 and stable is not None
    assert digest_mod.verify(path) == []


def test_a_sealed_unit_checks_clean_and_says_so(units, tmp_path):
    path = _sealable(units, tmp_path)
    seal(path)
    code, out, err = check(path)
    assert (code, err) == (0, "")
    assert "sealed and unchanged" in out


def test_seal_refuses_a_unit_that_does_not_check_clean(units, tmp_path):
    path = _sealable(units, tmp_path, slug="claims-too-much")
    md = path / "unit.md"
    md.write_text(md.read_text() + "\nThe second reading gave 9.99.\n",
                  encoding="utf-8")
    code, out, _ = seal(path)
    assert code == 1
    assert "REFUSED" in out and "does not pass" in out
    assert not (path / digest_mod.MANIFEST).exists()
    assert load(str(path)).front_matter["sealed"] is False


def test_seal_refuses_to_reseal(units, tmp_path):
    path = _sealable(units, tmp_path)
    assert seal(path)[0] == 0
    before = (path / digest_mod.MANIFEST).read_bytes()
    code, out, _ = seal(path)
    assert code == 1
    assert "already sealed" in out
    assert (path / digest_mod.MANIFEST).read_bytes() == before


def test_the_digest_ignores_a_change_confined_to_meta_keys(units, tmp_path):
    """A re-run that reproduces the measurements keeps the digest."""
    path = _sealable(units, tmp_path, slug="rerun")
    seal(path)
    recorded = digest_mod.parse(
        (path / digest_mod.MANIFEST).read_text())[2]

    again = dict(RESULT, timings={"elapsed_s": 41.6})
    rerun = units / "0001-rerun-again"
    new("rerun-again", cwd=tmp_path)
    _write_json(rerun / "run" / "ladder.json", again)
    values(rerun)
    lines, stable = digest_mod.manifest_lines(rerun)
    # values.tsv's stable content is the same measurement either way
    sealed_stable = digest_mod.parse(
        (path / digest_mod.MANIFEST).read_text())[1]
    assert stable == sealed_stable
    # the raw values.tsv is not, which is why the digest takes it stably
    raw = dict(line.split("\t", 1) for line in lines)["values.tsv"]
    sealed_raw = digest_mod.parse(
        (path / digest_mod.MANIFEST).read_text())[0]["values.tsv"]
    assert raw != sealed_raw
    assert len(recorded) == 64


# --- immutability, checked on a copy ----------------------------------------

@pytest.fixture
def tampered(tmp_path):
    """A copy of the committed sealed fixture, in tmp_path, ready to damage."""
    root = tmp_path / "units"
    root.mkdir()
    copy = root / SEALED.name
    shutil.copytree(SEALED, copy)
    assert check(copy)[0] == 0, "the copy must start clean"
    return copy


def test_the_committed_fixture_is_sealed_and_verifies():
    unit = load(str(SEALED))
    assert unit.front_matter["sealed"] is True
    assert digest_mod.verify(SEALED) == []
    code, out, err = check(SEALED)
    assert (code, err) == (0, "")
    assert "sealed and unchanged" in out


def test_tampering_with_a_sealed_units_prose_fails_check(tampered):
    md = tampered / "unit.md"
    md.write_text(md.read_text() + "\nA sentence nobody sealed.\n",
                  encoding="utf-8")
    code, out, err = check(tampered)
    assert code == 1
    assert err == ""
    changed = [l for l in out.splitlines() if l.startswith("CHANGED")]
    assert len(changed) == 1
    assert "unit.md" in changed[0]
    assert any(l.startswith("DIGEST") for l in out.splitlines())


def test_tampering_with_a_sealed_units_result_fails_check(tampered):
    result = tampered / "run" / "smoke_results.json"
    result.write_text(result.read_text().replace("422", "423"),
                      encoding="utf-8")
    code, out, _ = check(tampered)
    assert code == 1
    assert any(l.startswith("CHANGED") and "run/smoke_results.json" in l
               for l in out.splitlines())


def test_deleting_and_adding_files_in_a_sealed_unit_fails_check(tampered):
    (tampered / "question.md").unlink()
    (tampered / "extra.md").write_text("Added after the seal.\n",
                                       encoding="utf-8")
    code, out, _ = check(tampered)
    assert code == 1
    lines = out.splitlines()
    assert any(l.startswith("MISSING") and "question.md" in l for l in lines)
    assert any(l.startswith("UNSEALED") and "extra.md" in l for l in lines)


def test_a_missing_manifest_on_a_sealed_unit_fails_check(tampered):
    (tampered / digest_mod.MANIFEST).unlink()
    code, out, _ = check(tampered)
    assert code == 1
    assert any(l.startswith("MISSING") and digest_mod.MANIFEST in l
               for l in out.splitlines())


def test_an_unsealed_unit_is_not_held_to_a_manifest(tmp_path):
    """Phase 0's fixtures carry no manifest and still pass and fail as before."""
    assert check(CLEAN)[0] == 0
    assert check(FAILING)[0] == 1


# --- the digest itself ------------------------------------------------------

def test_stable_text_drops_comments_and_meta_keys():
    text = ("# a header line\n"
            "ladder.ratio\t3.07\n"
            "meta.timings.elapsed_s\t12.5\n"
            "census.rows\t422\n")
    assert digest_mod.stable_values_text(text) == (
        "ladder.ratio\t3.07\ncensus.rows\t422\n")


def test_the_manifest_round_trips_through_parse(units, tmp_path):
    path = _sealable(units, tmp_path, slug="round-trip")
    seal(path)
    text = (path / digest_mod.MANIFEST).read_text(encoding="utf-8")
    files, stable, unit_digest = digest_mod.parse(text)
    lines, recomputed_stable = digest_mod.manifest_lines(path)
    assert dict(line.split("\t", 1) for line in lines) == files
    assert recomputed_stable == stable
    assert digest_mod.digest_of(lines, stable) == unit_digest
    assert digest_mod.render(path) == text
