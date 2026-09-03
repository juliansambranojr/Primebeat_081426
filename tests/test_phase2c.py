"""Phase 2c tests: the seven findings unit 0308 recorded, closed.

    python3 -m pytest tests/test_phase2c.py -q

`units/0308-phase-2b-run-capture-and-one-home/unit.md` § Where the design did
not survive contact with this unit is the source; each test below names the
finding it closes. Like the earlier suites, every command is exercised in
process through the `run` function it exports, and every path is absolute.

THE SEALED UNIT 0308 IS NEVER TOUCHED. It is the corpus these rules were
judged against and it is immutable; the phrases it supplies are quoted into
the tests instead.
"""

import io
import json
import pathlib
import shutil
import subprocess
import sys
import time

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import check as check_mod                        # noqa: E402
from lab import counts as counts_mod                      # noqa: E402
from lab import new as new_mod                            # noqa: E402
from lab import run as run_mod                            # noqa: E402
from lab import seal as seal_mod                          # noqa: E402
from lab import values as values_mod                      # noqa: E402
from lab import unit as unit_mod                          # noqa: E402

CLEAN = ROOT / "units" / "0001-smoke-clean"
SMOKE = ROOT / "units" / "0003-run-smoke"


def _run(fn, *args, **kwargs):
    out, err = io.StringIO(), io.StringIO()
    code = fn(*args, out, err, **kwargs)
    return code, out.getvalue(), err.getvalue()


def check(arg):
    return _run(check_mod.run, str(arg))


def new(slug, cwd, **kwargs):
    return _run(new_mod.run, slug, cwd=cwd, **kwargs)


@pytest.fixture
def units(tmp_path):
    """An empty `units/` directory to scaffold into."""
    root = tmp_path / "units"
    root.mkdir()
    return root


def unit_with(tmp_path, body, front=None):
    """A minimal loadable unit whose prose is `body`. Returns its path."""
    path = tmp_path / "units" / "0100-probe"
    (path / "run").mkdir(parents=True)
    fields = {"id": "0100", "date": "2026-09-03", "type": "run",
              "title": "probe", "refs": [], "supersedes": [], "sealed": False}
    fields.update(front or {})
    (path / "unit.md").write_text(
        "---\n" + unit_mod.format_front_matter(fields) + "\n---\n\n" + body,
        encoding="utf-8")
    (path / "values.tsv").write_text(values_mod.EMPTY, encoding="utf-8")
    return path


# --- 1. counts are written in digits ----------------------------------------
# 0308 § Where the design did not survive contact with this unit: "A unit
# cannot count its own runs. The paragraph above says four, and it says it in
# words". The design's § Counts are written in digits is the rule.

BOUNDARY = [
    # 0308's own prose, the three phrases the boundary has to separate.
    ("The four corrections the build made", "4 corrections"),
    ("the four-line call into the commit gate", "4-line"),
    ("bare four-or-more-digit id", None),
    # the design's own examples of ordinary English, which keep their words
    ("one execution", None),
    ("the second half", None),
    ("a third of the tokens", None),
    # counts of things the archive holds
    ("Four runs, lab_run.001 through lab_run.004", "4 runs"),
    ("Two files are new", "2 files"),
    ("three entries", "3 entries"),
]


@pytest.mark.parametrize("text,want", BOUNDARY)
def test_the_digits_boundary_separates_counts_from_ordinary_english(text, want):
    got = counts_mod.findings(text)
    if want is None:
        assert got == [], f"{text!r} should not be a finding"
    else:
        assert [f[1] for f in got] == [want]


def test_a_number_word_inside_a_code_span_is_not_a_finding():
    """`lab/exempt.py`'s spans apply here for the reason they apply to digits."""
    from lab import exempt as exempt_mod
    text = "the key `four-line-total` is not a count"
    assert counts_mod.findings(text, skip=exempt_mod.spans(text)) == []


def test_check_reports_a_count_spelled_in_words(tmp_path):
    path = unit_with(tmp_path, "**What ran.** Four runs, and nothing else.\n")
    code, out, err = check(path)
    assert code == 1, out + err
    assert "DIGITS" in out
    assert "4 runs" in out
    assert "count(s) spelled in words" in out.splitlines()[-1]


def test_the_committed_fixtures_still_pass(tmp_path):
    """0001 and 0003 write "two numbers"; the closed noun list leaves them."""
    for fixture in (CLEAN, SMOKE):
        code, out, err = check(fixture)
        assert code == 0, out + err


# --- 2. a unit sealed before an enforcement existed --------------------------
# 0308 is sealed and immutable, and Phase 2c gives `lab check` two findings it
# was not held to. It is baselined with its reason, the way
# `units/0000-smoke` is: the design's § A changed count supersedes rather than
# mutates is about the GENERATED layer, and a superseding unit would not
# repair a predecessor's prose in any case.

UNIT_0308 = "units/0308-phase-2b-run-capture-and-one-home"


def test_0308_fails_its_own_check_and_says_why():
    code, out, err = check(ROOT / UNIT_0308)
    assert code == 1, out + err
    assert "DIGITS" in out and "FOLLOWS" in out
    assert "sealed and unchanged" in out          # the seal itself is intact


def test_0308_is_baselined_with_a_reason():
    from utilities import check_units
    known = check_units.baseline()
    assert UNIT_0308 in known, sorted(known)
    reason = known[UNIT_0308]
    assert "sealed" in reason and len(reason) > 40, reason


# --- 3. nested `agents:` in the parser --------------------------------------
# 0308 § Where the design did not survive contact with this unit: "`agents:`
# cannot be written as the design draws it. `lab/unit.py` parses a flat subset
# of YAML and rejects every indented line by construction". The design's
# § The fingerprint draws the shape; the parser moves to meet it.

FINGERPRINT = """\
id: 0305
agents:
  - id: a0a8bf60ac645202f
    role: build
    block: transcript/b01-phase2b-report.md
  - id: acafdbdc4f5818254
    role: build-stopped
    block: transcript/b02-partial.md
"""

AGENTS = [
    {"id": "a0a8bf60ac645202f", "role": "build",
     "block": "transcript/b01-phase2b-report.md"},
    {"id": "acafdbdc4f5818254", "role": "build-stopped",
     "block": "transcript/b02-partial.md"},
]


def test_the_fingerprint_shape_parses_as_the_design_draws_it():
    got = unit_mod.parse_front_matter(FINGERPRINT.rstrip("\n"))
    assert got == {"id": "0305", "agents": AGENTS}


def test_the_fingerprint_shape_round_trips():
    got = unit_mod.parse_front_matter(FINGERPRINT.rstrip("\n"))
    text = unit_mod.format_front_matter(got)
    assert unit_mod.parse_front_matter(text) == got
    assert "  - id: a0a8bf60ac645202f" in text


def test_a_unit_carrying_the_nested_block_loads_and_checks(tmp_path):
    path = tmp_path / "units" / "0100-probe"
    (path / "run").mkdir(parents=True)
    (path / "unit.md").write_text(
        "---\nid: 0100\ndate: 2026-09-03\ntype: run\ntitle: probe\n"
        "refs: []\nsupersedes: []\n"
        "agents:\n  - id: a0a8bf60ac645202f\n    role: build\n"
        "    block: transcript/b01.md\n"
        "sealed: false\n---\n\n**What ran.** Nothing.\n", encoding="utf-8")
    (path / "values.tsv").write_text(values_mod.EMPTY, encoding="utf-8")
    loaded = unit_mod.load(str(path))
    assert loaded.front_matter["agents"] == [AGENTS[0] | {
        "block": "transcript/b01.md"}]
    code, out, err = check(path)
    assert code == 0, out + err


REJECTED = [
    # a nested MAPPING, which is not a sequence of flat mappings
    "agents:\n  id: a0a8bf60ac645202f\n",
    # a second level of nesting under an item
    "agents:\n  - id: a0\n    blocks:\n      - one\n",
    # an item whose indent disagrees with the first item's
    "agents:\n  - id: a0\n   - id: a1\n",
    # a continuation line that does not line up under the item's first key
    "agents:\n  - id: a0\n     role: build\n",
    # a block sequence of bare scalars, which no field asks for
    "agents:\n  - a0a8bf60ac645202f\n",
    # an indented line under a key that already has a value
    "id: 0305\n  - role: build\n",
    # an indented line with no key above it at all
    "  - id: a0\n",
    # tabs
    "agents:\n\t- id: a0\n",
]


@pytest.mark.parametrize("text", REJECTED)
def test_the_parser_still_refuses_what_it_cannot_read(text):
    with pytest.raises(unit_mod.FrontMatterError):
        unit_mod.parse_front_matter(text.rstrip("\n"))


# --- 4. `lab new` allocates past the notebook -------------------------------
# 0308 § Where the design did not survive contact with this unit: "`lab new`
# cannot scaffold this unit. It allocates the next id by scanning `units/` and
# taking the highest plus one, so it produced `0005-` while the container's
# ids continue the notebook's numbering and this one has to be 0308 ...
# Nothing in the program knows the notebook's last number."

NOTEBOOK = """\
# Lab notebook, volume 2

## 2026-09-02 — Entry 307 — the last entry this volume holds
type: run

body

## 2026-09-01 — Entry 306 — an earlier one
type: run

body
"""


def notebook_tree(tmp_path, entries=NOTEBOOK, fixtures=("0000-a", "0004-b")):
    """A repo-shaped tmp tree: `units/` beside `notes/lab_notebook_2.md`."""
    (tmp_path / "notes").mkdir()
    if entries is not None:
        (tmp_path / "notes" / "lab_notebook_2.md").write_text(
            entries, encoding="utf-8")
    root = tmp_path / "units"
    root.mkdir()
    for name in fixtures:
        (root / name).mkdir()
    return root


def test_new_allocates_past_the_notebooks_last_entry(tmp_path):
    root = notebook_tree(tmp_path)
    assert new_mod.next_id(root) == "0308"
    code, out, err = new("phase-2c", cwd=tmp_path)
    assert (code, err) == (0, ""), err
    assert (root / "0308-phase-2c").is_dir(), sorted(p.name for p in
                                                     root.iterdir())


def test_the_floor_is_read_from_the_frozen_notebook_itself(tmp_path):
    root = notebook_tree(tmp_path)
    assert new_mod.notebook_floor(root) == 307
    # and from the real one, which froze at entry 307
    assert new_mod.notebook_floor(ROOT / "units") == 307


def test_without_a_notebook_the_directory_alone_answers(tmp_path):
    root = notebook_tree(tmp_path, entries=None)
    assert new_mod.notebook_floor(root) is None
    assert new_mod.next_id(root) == "0005"


def test_the_real_tree_allocates_after_0308():
    assert new_mod.next_id(ROOT / "units") == "0309"


# --- 6. `follows:` implemented ----------------------------------------------
# 0308 § Where the design did not survive contact with this unit: "`follows:`
# has no implementation. The parser accepts it because it accepts any flat
# key, and `lab new` does not write it, so it is present here by hand and
# nothing reads it." The design's § What a unit declares: "`lab new` fills it
# with the newest sealed unit". The walk itself is Phase 4.

def sealed_unit(root, unit_id, slug="sealed"):
    """A minimal SEALED unit under `root`, for `follows:` to point at."""
    path = root / f"{unit_id}-{slug}"
    (path / "run").mkdir(parents=True)
    fields = {"id": unit_id, "date": "2026-09-03", "type": "run",
              "title": slug, "refs": [], "supersedes": [], "sealed": True}
    (path / "unit.md").write_text(
        "---\n" + unit_mod.format_front_matter(fields) + "\n---\n\n"
        "**What ran.** Nothing.\n", encoding="utf-8")
    (path / "values.tsv").write_text(values_mod.EMPTY, encoding="utf-8")
    return path


def test_new_writes_follows_pointing_at_the_newest_sealed_unit(units,
                                                               tmp_path):
    sealed_unit(units, "0100")
    sealed_unit(units, "0102")
    (units / "0103-unsealed").mkdir()
    code, out, err = new("next-one", cwd=tmp_path)
    assert (code, err) == (0, ""), err
    loaded = unit_mod.load(str(units / "0104-next-one"))
    assert loaded.front_matter["follows"] == "0102"
    assert list(loaded.front_matter) == [
        "id", "date", "type", "title", "refs", "supersedes", "follows",
        "sealed"]


def test_new_omits_follows_when_no_unit_is_sealed(units, tmp_path):
    code, out, err = new("first-one", cwd=tmp_path)
    assert (code, err) == (0, ""), err
    loaded = unit_mod.load(str(units / "0000-first-one"))
    assert "follows" not in loaded.front_matter


def test_check_refuses_a_follows_that_names_no_unit(tmp_path):
    path = unit_with(tmp_path, "**What ran.** Nothing.\n",
                     front={"follows": "0099"})
    code, out, err = check(path)
    assert code == 1, out + err
    assert "FOLLOWS    0099 is not a unit" in out
    assert "1 follows problem(s)" in out.splitlines()[-1]


def test_check_refuses_a_unit_that_follows_itself(tmp_path):
    path = unit_with(tmp_path, "**What ran.** Nothing.\n",
                     front={"follows": "0100"})
    code, out, err = check(path)
    assert code == 1, out + err
    assert "does not follow itself" in out


def test_a_resolving_follows_passes(tmp_path):
    path = unit_with(tmp_path, "**What ran.** Nothing.\n",
                     front={"follows": "0099"})
    sealed_unit(path.parent, "0099")
    code, out, err = check(path)
    assert code == 0, out + err


# --- 5. the run record exists before the run --------------------------------
# 0308 § Where the design did not survive contact with this unit: "A unit
# cannot count its own runs ... because the fourth run's record does not exist
# while the fourth run is producing `figures.json`." The design's § A run
# record exists before the run: the index is allocated and the record written
# FIRST, `status: started`, then the run executes and the record is completed.

def runnable_unit(tmp_path, script):
    """A unit whose `run/run.sh` is `script`. Returns its path."""
    path = unit_with(tmp_path, "**What ran.** Nothing.\n")
    (path / "run" / "run.sh").write_text(script, encoding="utf-8")
    return path


LISTS_ITSELF = """\
echo "-- during the run, from a directory listing --"
ls lab_run.*.json
cat lab_run.001.json
"""


def test_the_record_exists_during_the_run(tmp_path):
    """A unit's run count is a directory listing at any moment, including now."""
    unit = runnable_unit(tmp_path, LISTS_ITSELF)
    code, out, err = _run(run_mod.run, str(unit))
    assert code == 0, out + err
    log = (unit / "run" / "lab_run.001.log").read_text(encoding="utf-8")
    assert "lab_run.001.json" in log
    assert '"status": "started"' in log


def test_a_completed_run_completes_its_record(tmp_path):
    unit = runnable_unit(tmp_path, "echo done\n")
    assert _run(run_mod.run, str(unit))[0] == 0
    record = json.loads(
        (unit / "run" / "lab_run.001.json").read_text(encoding="utf-8"))
    assert record["status"] == "completed"
    assert record["exit_code"] == 0
    assert record["meta"]["wall_s"] > 0
    assert record["environment"]["lab_python"].startswith("v")


def test_a_killed_run_leaves_a_diagnosable_record(tmp_path):
    """A run that never completes is a durable statement, not an absence."""
    unit = runnable_unit(tmp_path, "touch ../started.flag\nsleep 30\n")
    proc = subprocess.Popen(
        [sys.executable, "-m", "lab.cli", "run", str(unit)], cwd=ROOT,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    try:
        deadline = time.monotonic() + 20
        while time.monotonic() < deadline and \
                not (unit / "started.flag").is_file():
            time.sleep(0.05)
        assert (unit / "started.flag").is_file(), "the runnable never started"
    finally:
        proc.kill()
        proc.wait(timeout=20)

    record_path = unit / "run" / "lab_run.001.json"
    assert record_path.is_file(), "the record was never written"
    record = json.loads(record_path.read_text(encoding="utf-8"))
    assert record["status"] == "started"
    assert "exit_code" not in record
    assert record["command"] == "/bin/sh -e run.sh"
    assert record["meta"]["run_start"].endswith("Z")


# --- 7. check_refs scans units/ ---------------------------------------------
# The design's § The parser matches the spec: "`check_refs` never scanning
# `units/`" is one of the three findings that "were spec and code written
# apart". The walk covered papers/, lean/, notes/*.md and root *.md, so a
# unit's citations were ungated.

def test_check_refs_walks_the_units():
    scanned = subprocess.run(
        [sys.executable, str(ROOT / "utilities" / "check_refs.py"),
         "--list-scanned"], cwd=ROOT, capture_output=True, text=True)
    assert scanned.returncode == 0, scanned.stderr
    lines = scanned.stdout.split("\n")
    assert f"{UNIT_0308}/unit.md" in lines, scanned.stdout
    # the copied-in transcript and the question are NOT the unit's own claims
    assert not [l for l in lines if l.endswith("question.md")]
    assert not [l for l in lines if "/transcript/" in l]


def test_check_refs_reports_a_broken_reference_inside_a_unit(tmp_path):
    """A unit citing a script that does not exist is a BROKEN line."""
    probe = ROOT / "units" / "0100-refs-probe"
    (probe / "run").mkdir(parents=True)
    (probe / "unit.md").write_text(
        "---\nid: 0100\ndate: 2026-09-03\ntype: run\ntitle: probe\n"
        "refs: []\nsupersedes: []\nsealed: false\n---\n\n"
        "**What ran.** `no_such_script_here.py`, which does not exist.\n",
        encoding="utf-8")
    (probe / "values.tsv").write_text(values_mod.EMPTY, encoding="utf-8")
    try:
        r = subprocess.run(
            [sys.executable, str(ROOT / "utilities" / "check_refs.py")],
            cwd=ROOT, capture_output=True, text=True)
        assert r.returncode == 1, r.stdout
        assert "no_such_script_here.py" in r.stdout
        assert f"BROKEN  {probe.name}" in r.stdout or \
            "0100-refs-probe" in r.stdout
    finally:
        shutil.rmtree(probe)


def test_the_state_line_names_the_next_record():
    r = subprocess.run(
        [sys.executable, str(ROOT / "utilities" / "check_refs.py")],
        cwd=ROOT, capture_output=True, text=True)
    assert r.returncode == 0, r.stdout
    state = [l for l in r.stdout.split("\n") if l.startswith("notebook:")]
    assert len(state) == 1, r.stdout
    assert "newest 307" in state[0] and "FROZEN" in state[0], state[0]
    assert "next unit 0309" in state[0], state[0]
    # .github/workflows/audit.yml reads `newest N` out of this line and does
    # arithmetic on it; a zero-padded unit id there would break the shell.
    import subprocess as sp
    got = sp.run(["sed", "-nE", r"s/^notebook: .*newest ([0-9]+) .*$/\1/p"],
                 input=state[0], capture_output=True, text=True)
    assert got.stdout.strip() == "307", got.stdout


# --- 8. a correction's evidence ---------------------------------------------
# 0308 § Where the design did not survive contact with this unit: "A correction
# has no evidence of its own ... A unit correcting a number that was never
# written down anywhere would have no such route." The answer is a practice,
# not a mechanism, and the design's § The parser matches the spec requires a
# spec section to land with a phase row and a test.

DESIGN = ROOT / "analysis" / "2026-09-02" / "lab_design.md"


def test_the_correction_practice_is_a_section_with_a_phase_row():
    text = DESIGN.read_text(encoding="utf-8")
    assert "\n## A correction reads its predecessor\n" in text
    row = [l for l in text.split("\n") if l.startswith("| 2c |")]
    assert len(row) == 1, row
    assert "A correction reads its predecessor" in row[0]


def test_check_records_why_the_correction_practice_is_not_enforced():
    doc = check_mod.__doc__
    assert "A correction reads its predecessor" in doc
    assert "PRACTICE, NOT A MECHANISM" in doc.upper()
