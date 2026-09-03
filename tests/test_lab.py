"""Phase 0 tests for `lab`: the two fixtures, the parser, the comparison.

    python3 -m pytest tests/test_lab.py -q

`lab check` is exercised in process through `lab.check.run`, which is what
`lab.cli.main` calls and what returns the exit code, so the tests do not
depend on the console script having been installed. Fixture paths are
absolute, so the tests do not depend on the working directory either.
"""

import io
import pathlib
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                       # noqa: E402
from lab.unit import (                                   # noqa: E402
    FrontMatterError,
    format_front_matter,
    load,
    parse_front_matter,
    split_front_matter,
)

FAILING = ROOT / "units" / "0000-smoke"
CLEAN = ROOT / "units" / "0001-smoke-clean"


def run(arg):
    """(exit code, stdout, stderr) for `lab check <arg>`."""
    out, err = io.StringIO(), io.StringIO()
    code = check_mod.run(str(arg), out, err)
    return code, out.getvalue(), err.getvalue()


# --- the two fixtures -------------------------------------------------------

def test_failing_fixture_exits_1_with_findings():
    code, out, err = run(FAILING)
    assert code == 1
    assert err == ""
    lines = [l for l in out.splitlines() if l.startswith("UNMATCHED")]
    assert len(lines) == 3
    assert {l.split()[1] for l in lines} == {"9.99", "61", "7.5"}


def test_failing_fixture_reports_the_fenced_number():
    """The design reads fenced blocks; 7.5 only exists inside one."""
    _, out, _ = run(FAILING)
    assert any(l.startswith("UNMATCHED") and " 7.5 " in l
               for l in out.splitlines())


def test_failing_fixture_summary_counts_matched_numbers():
    _, out, _ = run(FAILING)
    summary = out.splitlines()[-1]
    assert summary.endswith("values.tsv: 4 key(s), 4 numeric")
    assert "7 number(s) in prose, 4 matched, 3 unmatched" in summary


def test_clean_fixture_exits_0_silently():
    code, out, err = run(CLEAN)
    assert code == 0
    assert err == ""
    assert not [l for l in out.splitlines() if l.startswith("UNMATCHED")]
    assert "6 number(s) in prose, 6 matched, 0 unmatched" in out


def test_missing_directory_exits_2():
    code, out, err = run(ROOT / "units" / "9999-does-not-exist")
    assert code == 2
    assert "9999-does-not-exist" in err


def test_unit_without_values_tsv_exits_2(tmp_path):
    unit = tmp_path / "0002-no-values"
    unit.mkdir()
    (unit / "unit.md").write_text(
        "---\nid: 0002\ndate: 2026-09-02\ntype: run\ntitle: x\n"
        "refs: []\nsupersedes: []\nsealed: false\n---\n\nBody.\n")
    code, _, err = run(unit)
    assert code == 2
    assert "values.tsv" in err


def test_fixtures_load_with_the_ids_they_declare():
    assert load(str(FAILING)).id == "0000"
    assert load(str(CLEAN)).id == "0001"
    assert load(str(FAILING)).ids == {"0000", "0001"}


# --- front matter: round trip -----------------------------------------------

ROUND_TRIP = [
    {"id": "0305", "date": "2026-09-03", "type": "run",
     "title": "Fixed-window L_c, third pass",
     "refs": ["0302", "0304"], "supersedes": [], "sealed": False},
    {"id": "0001", "sealed": True, "refs": ["0000"]},
    {"title": "a value with: a colon inside it"},
    {"title": "true"},                     # the string, not the boolean
    {"title": ""},                         # the empty string
    {"title": "  padded  "},
    {"title": "[not a list]"},
    {"note": "trailing hash # is fine", "flag": False},
]


@pytest.mark.parametrize("mapping", ROUND_TRIP)
def test_front_matter_round_trips(mapping):
    assert parse_front_matter(format_front_matter(mapping)) == mapping


def test_front_matter_of_the_fixture_round_trips():
    text = (FAILING / "unit.md").read_text()
    fm_text, body = split_front_matter(text)
    parsed = parse_front_matter(fm_text)
    assert parsed["id"] == "0000"
    assert parsed["refs"] == ["0001"]
    assert parsed["sealed"] is False
    assert body.lstrip().startswith("**Permanent test fixture.**")
    assert parse_front_matter(format_front_matter(parsed)) == parsed


# --- front matter: rejection ------------------------------------------------

MALFORMED = [
    ("nested mapping", "id: 0305\nrefs:\n  - 0302\n"),
    ("block sequence", "- 0302\n"),
    ("indented continuation", "title: one\n  two\n"),
    ("no colon", "id 0305\n"),
    ("empty value", "title:\n"),
    ("duplicate key", "id: 0305\nid: 0306\n"),
    ("block scalar", "title: |\n"),
    ("anchor", "title: &anchor\n"),
    ("unterminated list", "refs: [0302, 0304\n"),
    ("nested list item", "refs: [[0302]]\n"),
    ("quoted list item", "refs: ['0302']\n"),
    ("empty list item", "refs: [0302, ]\n"),
    ("ambiguous True", "sealed: True\n"),
    ("ambiguous yes", "sealed: yes\n"),
    ("ambiguous null", "refs: null\n"),
    ("inline comment", "id: 0305 # the third pass\n"),
    ("comment line", "# the third pass\nid: 0305\n"),
    ("unterminated quote", "title: 'one\n"),
    ("trailing whitespace", "id: 0305 \n"),
]


@pytest.mark.parametrize("name,text",
                         MALFORMED, ids=[n for n, _ in MALFORMED])
def test_front_matter_rejects(name, text):
    with pytest.raises(FrontMatterError):
        parse_front_matter(text)


SPLIT_MALFORMED = [
    ("no opening delimiter", "id: 0305\n---\nbody\n"),
    ("never closed", "---\nid: 0305\n\nbody\n"),
    ("empty file", ""),
]


@pytest.mark.parametrize("name,text",
                         SPLIT_MALFORMED, ids=[n for n, _ in SPLIT_MALFORMED])
def test_split_front_matter_rejects(name, text):
    with pytest.raises(FrontMatterError):
        split_front_matter(text)


def test_format_rejects_a_value_it_cannot_write_back():
    with pytest.raises(FrontMatterError):
        # needs quoting (it opens with a quote) and holds a single quote
        format_front_matter({"title": "'it opens with an apostrophe"})
    with pytest.raises(FrontMatterError):
        format_front_matter({"refs": ["03,02"]})
    with pytest.raises(FrontMatterError):
        format_front_matter({"id": 305})


# --- the rounding-aware comparison ------------------------------------------

from decimal import Decimal                              # noqa: E402

POOL = {Decimal("3.070311505664645"), Decimal("0.018401"),
        Decimal("422"), Decimal("12.5")}

PRECISIONS = [
    ("3", True),                # one significant figure, tol 0.5
    ("3.1", True),              # tol 0.05, |3.0703 - 3.1| = 0.0297
    ("3.07", True),             # tol 0.005
    ("3.070", True),            # tol 0.0005
    ("3.0703", True),           # tol 0.00005
    ("3.07031", True),
    ("3.070311505664645", True),
    ("3.2", False),             # tol 0.05, off by 0.13
    ("3.08", False),            # tol 0.005, off by 0.0097
    ("3.0704", False),          # tol 0.00005, off by 0.0000885
    ("0.0184", True),           # prose states fewer places than the file
    ("0.01840", True),
    ("0.018401", True),
    ("0.02", True),             # two places is what 0.018401 rounds to
    ("0.03", False),            # tol 0.005, off by 0.0116
    ("0.0185", False),
    ("422", True),
    ("422.0", True),
    ("423", False),
    ("12.5", True),             # a meta. key is still evidence
    ("7.5", False),
    ("61", False),
    ("9.99", False),
]


@pytest.mark.parametrize("token,expected",
                         PRECISIONS, ids=[t for t, _ in PRECISIONS])
def test_matches_at_several_precisions(token, expected):
    assert check_mod.matches(Decimal(token), POOL) is expected


def test_precision_is_taken_from_the_prose_not_the_file():
    """0.0184 matches 0.018401; 0.018401 does not match 0.0184."""
    assert check_mod.matches(Decimal("0.0184"), {Decimal("0.018401")})
    assert not check_mod.matches(Decimal("0.0184009"), {Decimal("0.0184")})
