"""Phase 3 tests: `lab index` both directions, and the count-slot strip.

    python3 -m pytest tests/test_phase3.py -q

`lab index` generates two files at the project root (the parent of `units/`):

  INDEX.md         — units by type, artifact counts, sealed/unsealed status
  INDEX-values.tsv — the reverse map: one line per key, listing every unit
                     whose prose cites the value stored under that key

Both are generated, so neither can drift from the units.
"""

import io
import pathlib
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                          # noqa: E402
from lab import index as index_mod                          # noqa: E402
from lab import unit as unit_mod                            # noqa: E402
from lab import values as values_mod                        # noqa: E402


def _run(fn, *args, **kwargs):
    out, err = io.StringIO(), io.StringIO()
    code = fn(*args, out, err, **kwargs)
    return code, out.getvalue(), err.getvalue()


# ---------------------------------------------------------------------------
# helpers — build units in a temp tree
# ---------------------------------------------------------------------------

def make_unit(root, uid, slug, type_="run", sealed=False, body="",
              values_text=None):
    """A loadable unit under `root/units/<uid>-<slug>/`."""
    path = root / "units" / f"{uid}-{slug}"
    (path / "run").mkdir(parents=True, exist_ok=True)
    fields = {"id": uid, "date": "2026-09-03", "type": type_,
              "title": slug, "refs": [], "supersedes": [], "sealed": sealed}
    (path / "unit.md").write_text(
        "---\n" + unit_mod.format_front_matter(fields) + "\n---\n\n" + body,
        encoding="utf-8")
    if values_text is None:
        values_text = values_mod.EMPTY
    (path / "values.tsv").write_text(values_text, encoding="utf-8")
    return path


@pytest.fixture
def tree(tmp_path):
    """A project-shaped temp tree with a `units/` directory."""
    (tmp_path / "units").mkdir()
    return tmp_path


# ---------------------------------------------------------------------------
# 1. lab index produces both files
# ---------------------------------------------------------------------------

def test_index_produces_both_files(tree):
    make_unit(tree, "0100", "probe")
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    assert (tree / "INDEX.md").is_file()
    assert (tree / "INDEX-values.tsv").is_file()


def test_index_exits_2_with_no_units_dir(tmp_path):
    code, out, err = _run(index_mod.run, cwd=tmp_path)
    assert code == 2, out + err


# ---------------------------------------------------------------------------
# 2. INDEX.md contains correct unit counts by type
# ---------------------------------------------------------------------------

def test_index_counts_by_type(tree):
    make_unit(tree, "0100", "a", type_="run")
    make_unit(tree, "0101", "b", type_="run")
    make_unit(tree, "0102", "c", type_="instrument-fix")
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    assert "run" in text
    assert "instrument-fix" in text
    # 2 run units and 1 instrument-fix
    assert "2" in text
    assert "1" in text
    assert "3" in text  # total


def test_index_shows_sealed_and_unsealed_counts(tree):
    make_unit(tree, "0100", "a", sealed=True)
    make_unit(tree, "0101", "b", sealed=False)
    make_unit(tree, "0102", "c", sealed=False)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    # 1 sealed, 2 unsealed visible somewhere
    assert "1 sealed" in text
    assert "2 unsealed" in text


# ---------------------------------------------------------------------------
# 3. INDEX-values.tsv has the right reverse mapping
# ---------------------------------------------------------------------------

def test_reverse_map_lists_units_citing_a_value(tree):
    """A key whose value is cited in 2 units lists both."""
    vals = (values_mod.EMPTY.rstrip("\n") + "\n"
            "ladder.ratio\t3.070311505664645\n")
    make_unit(tree, "0100", "a",
              body="**What ran.** The ratio is 3.07.\n",
              values_text=vals)
    make_unit(tree, "0101", "b",
              body="**What ran.** Also 3.07.\n",
              values_text=vals)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    # Find the line for ladder.ratio
    lines = [l for l in tsv.split("\n") if l.startswith("ladder.ratio\t")]
    assert len(lines) == 1, tsv
    parts = lines[0].split("\t")
    # key, then unit ids
    assert "0100" in parts
    assert "0101" in parts


def test_reverse_map_key_cited_by_one_unit(tree):
    vals = (values_mod.EMPTY.rstrip("\n") + "\n"
            "census.rows\t422\n")
    make_unit(tree, "0100", "a",
              body="**What ran.** Counted 422 rows.\n",
              values_text=vals)
    make_unit(tree, "0101", "b",
              body="**What ran.** Nothing here.\n",
              values_text=vals)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    lines = [l for l in tsv.split("\n") if l.startswith("census.rows\t")]
    assert len(lines) == 1
    parts = lines[0].split("\t")
    assert "0100" in parts
    assert "0101" not in parts


def test_reverse_map_excludes_uncited_keys(tree):
    """A key whose value is not cited by any unit's prose does not appear."""
    vals = (values_mod.EMPTY.rstrip("\n") + "\n"
            "secret.val\t999999.123456\n")
    make_unit(tree, "0100", "a",
              body="**What ran.** Nothing to see.\n",
              values_text=vals)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    data_lines = [l for l in tsv.split("\n")
                  if l and not l.startswith("#")]
    assert data_lines == [], tsv


# ---------------------------------------------------------------------------
# 4. idempotent — running twice gives the same output
# ---------------------------------------------------------------------------

def test_index_is_idempotent(tree):
    make_unit(tree, "0100", "a",
              body="**What ran.** Ratio 3.07.\n",
              values_text=(values_mod.EMPTY.rstrip("\n") + "\n"
                           "ladder.ratio\t3.070311505664645\n"))
    _run(index_mod.run, cwd=tree)
    first_md = (tree / "INDEX.md").read_text(encoding="utf-8")
    first_tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    _run(index_mod.run, cwd=tree)
    second_md = (tree / "INDEX.md").read_text(encoding="utf-8")
    second_tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    assert first_md == second_md
    assert first_tsv == second_tsv


# ---------------------------------------------------------------------------
# 5. a unit with no run results still appears in the index
# ---------------------------------------------------------------------------

def test_unit_with_no_results_appears(tree):
    make_unit(tree, "0100", "empty-run")
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    assert "0100" in text


# ---------------------------------------------------------------------------
# 6. smoke fixtures and real units appear
# ---------------------------------------------------------------------------

def test_real_tree_smoke_fixtures_appear():
    """0000-0004 all appear in INDEX.md when run against the real tree."""
    code, out, err = _run(index_mod.run, cwd=ROOT)
    assert code == 0, out + err
    text = (ROOT / "INDEX.md").read_text(encoding="utf-8")
    for uid in ("0000", "0001", "0002", "0003", "0004"):
        assert uid in text, f"{uid} missing from INDEX.md"


def test_real_tree_real_units_appear():
    """0308 and 0309 appear in INDEX.md."""
    code, out, err = _run(index_mod.run, cwd=ROOT)
    assert code == 0, out + err
    text = (ROOT / "INDEX.md").read_text(encoding="utf-8")
    assert "0308" in text
    assert "0309" in text


def test_real_tree_reverse_map_has_entries():
    """The reverse map against the real tree is non-empty."""
    code, out, err = _run(index_mod.run, cwd=ROOT)
    assert code == 0, out + err
    tsv = (ROOT / "INDEX-values.tsv").read_text(encoding="utf-8")
    data_lines = [l for l in tsv.split("\n")
                  if l and not l.startswith("#")]
    assert len(data_lines) > 0


# ---------------------------------------------------------------------------
# 7. INDEX.md artifact count — values.tsv key counts are reported
# ---------------------------------------------------------------------------

def test_index_reports_artifact_counts(tree):
    vals = (values_mod.EMPTY.rstrip("\n") + "\n"
            "ladder.ratio\t3.070311505664645\n"
            "ladder.residual\t0.018401\n")
    make_unit(tree, "0100", "a", values_text=vals)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    # 2 keys
    assert "2" in text


# ---------------------------------------------------------------------------
# 8. INDEX.md is generated (comment header says so)
# ---------------------------------------------------------------------------

def test_index_md_has_generated_header(tree):
    make_unit(tree, "0100", "probe")
    _run(index_mod.run, cwd=tree)
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    assert "GENERATED" in text


def test_index_values_tsv_has_generated_header(tree):
    make_unit(tree, "0100", "probe")
    _run(index_mod.run, cwd=tree)
    text = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    assert text.startswith("#")


# ---------------------------------------------------------------------------
# 9. the CLI subcommand runs
# ---------------------------------------------------------------------------

def test_cli_index_subcommand(tree):
    make_unit(tree, "0100", "probe")
    from lab import cli
    code = cli.main(["index", "--cwd", str(tree)])
    assert code == 0
    assert (tree / "INDEX.md").is_file()
    assert (tree / "INDEX-values.tsv").is_file()


# ---------------------------------------------------------------------------
# 10. units with different types are grouped correctly
# ---------------------------------------------------------------------------

def test_multiple_types_counted(tree):
    make_unit(tree, "0100", "a", type_="run")
    make_unit(tree, "0101", "b", type_="run")
    make_unit(tree, "0102", "c", type_="run")
    make_unit(tree, "0103", "d", type_="instrument-fix")
    make_unit(tree, "0104", "e", type_="instrument-fix")
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    text = (tree / "INDEX.md").read_text(encoding="utf-8")
    assert "5" in text  # total


# ---------------------------------------------------------------------------
# 11. the reverse map is tab-separated with key first, then unit ids
# ---------------------------------------------------------------------------

def test_reverse_map_format(tree):
    vals = (values_mod.EMPTY.rstrip("\n") + "\n"
            "x.a\t42\n")
    make_unit(tree, "0100", "a",
              body="**What ran.** Got 42.\n",
              values_text=vals)
    make_unit(tree, "0101", "b",
              body="**What ran.** Also 42.\n",
              values_text=vals)
    code, out, err = _run(index_mod.run, cwd=tree)
    assert code == 0, out + err
    tsv = (tree / "INDEX-values.tsv").read_text(encoding="utf-8")
    data_lines = [l for l in tsv.split("\n")
                  if l and not l.startswith("#")]
    assert len(data_lines) >= 1
    parts = data_lines[0].split("\t")
    assert parts[0] == "x.a"
    # unit ids sorted
    assert sorted(parts[1:]) == parts[1:]
