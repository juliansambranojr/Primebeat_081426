"""Phase 4 tests: `lab chain`, segments, branch detection, label arithmetic.

    python3 -m pytest tests/test_phase4.py -q

`lab chain` walks every unit's `follows:` field, groups units into bounded
segments, assigns deterministic labels (spreadsheet order for the main line,
dotted labels for branches), computes inherits/handoff digests, and generates
CHAIN.tsv at the project root.

The label is a pure function of the tree, recomputable from the unit ids
alone:
  - the root segment holds the lowest unit id and is A;
  - at any fork the line continues through the child with the lower first
    unit id, and the others become branches;
  - segments along a line take the next label in spreadsheet order;
  - branches off a segment are ordered by their own first unit id and take
    the dotted labels in that order.
"""

import io
import pathlib
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab import chain as chain_mod                             # noqa: E402
from lab import unit as unit_mod                               # noqa: E402
from lab import values as values_mod                           # noqa: E402


def _run(fn, *args, **kwargs):
    out, err = io.StringIO(), io.StringIO()
    code = fn(*args, out, err, **kwargs)
    return code, out.getvalue(), err.getvalue()


# ---------------------------------------------------------------------------
# helpers — build units in a temp tree
# ---------------------------------------------------------------------------

def make_unit(root, uid, slug, sealed=False, follows=None, body="",
              values_text=None):
    """A loadable unit under `root/units/<uid>-<slug>/`."""
    path = root / "units" / f"{uid}-{slug}"
    (path / "run").mkdir(parents=True, exist_ok=True)
    fields = {"id": uid, "date": "2026-09-03", "type": "run",
              "title": slug, "refs": [], "supersedes": [], "sealed": sealed}
    if follows is not None:
        fields = {**{k: v for k, v in fields.items() if k != "sealed"},
                  "follows": follows, "sealed": fields["sealed"]}
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


# ===================================================================
# 1. spreadsheet_label
# ===================================================================

def test_label_a():
    assert chain_mod.spreadsheet_label(0) == "A"


def test_label_z():
    assert chain_mod.spreadsheet_label(25) == "Z"


def test_label_aa():
    assert chain_mod.spreadsheet_label(26) == "AA"


def test_label_ab():
    assert chain_mod.spreadsheet_label(27) == "AB"


def test_label_az():
    assert chain_mod.spreadsheet_label(51) == "AZ"


def test_label_ba():
    assert chain_mod.spreadsheet_label(52) == "BA"


def test_label_zz():
    assert chain_mod.spreadsheet_label(701) == "ZZ"


def test_label_aaa():
    assert chain_mod.spreadsheet_label(702) == "AAA"


def test_label_negative_raises():
    with pytest.raises(ValueError):
        chain_mod.spreadsheet_label(-1)


# ===================================================================
# 2. handoff_digest
# ===================================================================

def test_handoff_deterministic():
    a = chain_mod.handoff_digest(["0001", "0002"])
    b = chain_mod.handoff_digest(["0001", "0002"])
    assert a == b


def test_handoff_order_invariant():
    a = chain_mod.handoff_digest(["0002", "0001"])
    b = chain_mod.handoff_digest(["0001", "0002"])
    assert a == b


def test_handoff_different_ids():
    a = chain_mod.handoff_digest(["0001"])
    b = chain_mod.handoff_digest(["0002"])
    assert a != b


def test_handoff_is_sha256_hex():
    h = chain_mod.handoff_digest(["0001"])
    assert len(h) == 64
    assert all(c in "0123456789abcdef" for c in h)


# ===================================================================
# 3. build_forest
# ===================================================================

def test_forest_all_unchained():
    fm = {"0001": None, "0002": None}
    known = {"0001", "0002"}
    children, roots, gaps, forks, unchained = chain_mod.build_forest(fm, known)
    assert unchained == ["0001", "0002"]
    assert roots == ["0001", "0002"]
    assert gaps == []
    assert forks == []


def test_forest_simple_chain():
    fm = {"0001": None, "0002": "0001"}
    known = {"0001", "0002"}
    children, roots, gaps, forks, unchained = chain_mod.build_forest(fm, known)
    assert children["0001"] == ["0002"]
    assert roots == ["0001"]
    assert gaps == []
    assert forks == []
    assert unchained == ["0001"]


def test_forest_gap():
    fm = {"0002": "0001"}
    known = {"0002"}
    children, roots, gaps, forks, unchained = chain_mod.build_forest(fm, known)
    assert gaps == [("0002", "0001")]
    assert roots == ["0002"]


def test_forest_fork():
    fm = {"0001": None, "0002": "0001", "0003": "0001"}
    known = {"0001", "0002", "0003"}
    children, roots, gaps, forks, unchained = chain_mod.build_forest(fm, known)
    assert forks == [("0001", ["0002", "0003"])]
    assert children["0001"] == ["0002", "0003"]


# ===================================================================
# 4. compute_segments — linear chain
# ===================================================================

def test_linear_chain_labels():
    """A simple A -> B -> C chain produces sequential labels."""
    fm = {"0001": None, "0002": "0001", "0003": "0002"}
    known = {"0001", "0002", "0003"}
    segments, gaps, forks, unchained = chain_mod.compute_segments(
        fm, known, segment_size=25
    )
    assert len(segments) == 1
    assert segments[0]["label"] == "A"
    assert segments[0]["unit_ids"] == ["0001", "0002", "0003"]


def test_linear_chain_two_segments():
    """A chain longer than segment_size splits into 2 segments."""
    fm = {"0001": None}
    known = {"0001"}
    for i in range(2, 8):
        uid = f"{i:04d}"
        prev = f"{i - 1:04d}"
        fm[uid] = prev
        known.add(uid)
    segments, gaps, forks, unchained = chain_mod.compute_segments(
        fm, known, segment_size=3
    )
    # 7 units, segment_size=3 -> ceil(7/3) = 3 segments
    assert len(segments) == 3
    assert segments[0]["label"] == "A"
    assert segments[1]["label"] == "B"
    assert segments[2]["label"] == "C"
    assert segments[0]["unit_ids"] == ["0001", "0002", "0003"]
    assert segments[1]["unit_ids"] == ["0004", "0005", "0006"]
    assert segments[2]["unit_ids"] == ["0007"]


def test_linear_chain_inherits_handoff():
    """Each segment's inherits equals the previous segment's handoff."""
    fm = {}
    known = set()
    for i in range(1, 7):
        uid = f"{i:04d}"
        prev = f"{i - 1:04d}" if i > 1 else None
        fm[uid] = prev
        known.add(uid)
    segments, _, _, _ = chain_mod.compute_segments(
        fm, known, segment_size=3
    )
    assert segments[0]["inherits"] is None
    assert segments[1]["inherits"] == segments[0]["handoff"]


# ===================================================================
# 5. compute_segments — fork detection
# ===================================================================

def test_fork_detected():
    """2 units following the same predecessor is a fork."""
    fm = {"0001": None, "0002": "0001", "0003": "0001"}
    known = {"0001", "0002", "0003"}
    _, _, forks, _ = chain_mod.compute_segments(fm, known)
    assert len(forks) == 1
    assert forks[0] == ("0001", ["0002", "0003"])


# ===================================================================
# 6. compute_segments — gap detection
# ===================================================================

def test_gap_detected():
    """A unit following a missing predecessor is a gap."""
    fm = {"0002": "0001", "0003": "0002"}
    known = {"0002", "0003"}
    _, gaps, _, _ = chain_mod.compute_segments(fm, known)
    assert len(gaps) == 1
    assert gaps[0] == ("0002", "0001")


# ===================================================================
# 7. compute_segments — branch naming
# ===================================================================

def test_branch_label_is_dotted():
    """A fork produces a dotted label for the branch."""
    fm = {"0001": None, "0002": "0001", "0003": "0001"}
    known = {"0001", "0002", "0003"}
    segments, _, forks, _ = chain_mod.compute_segments(
        fm, known, segment_size=25
    )
    labels = [s["label"] for s in segments]
    # Main line: 0001 -> 0002 (lower id continues). Branch: 0003.
    assert "A" in labels
    assert "A.A" in labels
    main = [s for s in segments if s["label"] == "A"][0]
    branch = [s for s in segments if s["label"] == "A.A"][0]
    assert "0001" in main["unit_ids"]
    assert "0002" in main["unit_ids"]
    assert branch["unit_ids"] == ["0003"]


def test_branch_label_depth_two():
    """A branch off a branch produces C.A.A-style labels (depth 2)."""
    fm = {
        "0001": None,
        "0002": "0001",
        "0003": "0001",  # branch off 0001 -> A.A
        "0004": "0003",
        "0005": "0003",  # branch off 0003 -> A.A.A
    }
    known = set(fm)
    segments, _, _, _ = chain_mod.compute_segments(
        fm, known, segment_size=25
    )
    labels = {s["label"] for s in segments}
    # Main line: 0001 -> 0002 -> label A
    # Branch off A (at 0001): 0003 -> 0004 -> label A.A
    # Branch off A.A (at 0003): 0005 -> label A.A.A
    assert "A" in labels
    assert "A.A" in labels
    assert "A.A.A" in labels


def test_multiple_branches_ordered_by_first_uid():
    """Multiple branches off one segment get labels in first-uid order."""
    fm = {
        "0001": None,
        "0002": "0001",  # continues (lowest child)
        "0003": "0001",  # branch 1
        "0004": "0001",  # branch 2
    }
    known = set(fm)
    segments, _, _, _ = chain_mod.compute_segments(
        fm, known, segment_size=25
    )
    # 0002 continues the main line (A).
    # 0003 is the first branch (A.A), 0004 the second (A.B).
    labels = {s["label"]: s for s in segments}
    assert "A" in labels
    assert labels["A"]["unit_ids"] == ["0001", "0002"]
    assert "A.A" in labels
    assert labels["A.A"]["unit_ids"] == ["0003"]
    assert "A.B" in labels
    assert labels["A.B"]["unit_ids"] == ["0004"]


# ===================================================================
# 8. label determinism
# ===================================================================

def test_label_determinism():
    """Same follows_map always produces the same labels."""
    fm = {
        "0001": None, "0002": "0001", "0003": "0001",
        "0004": "0003", "0005": None,
    }
    known = set(fm)
    segs_a, _, _, _ = chain_mod.compute_segments(fm, known, segment_size=25)
    segs_b, _, _, _ = chain_mod.compute_segments(fm, known, segment_size=25)
    assert [(s["label"], s["unit_ids"]) for s in segs_a] == \
           [(s["label"], s["unit_ids"]) for s in segs_b]


# ===================================================================
# 9. multiple disconnected roots
# ===================================================================

def test_disconnected_roots():
    """Disconnected components get sequential main-line labels."""
    fm = {"0001": None, "0005": None, "0010": None}
    known = set(fm)
    segments, _, _, _ = chain_mod.compute_segments(fm, known, segment_size=25)
    labels = [s["label"] for s in segments]
    assert labels == ["A", "B", "C"]
    assert segments[0]["unit_ids"] == ["0001"]
    assert segments[1]["unit_ids"] == ["0005"]
    assert segments[2]["unit_ids"] == ["0010"]


def test_disconnected_root_with_chain():
    """A root with children and an isolated root."""
    fm = {"0001": None, "0002": "0001", "0010": None}
    known = set(fm)
    segments, _, _, _ = chain_mod.compute_segments(fm, known, segment_size=25)
    labels = [s["label"] for s in segments]
    assert labels == ["A", "B"]
    assert segments[0]["unit_ids"] == ["0001", "0002"]
    assert segments[1]["unit_ids"] == ["0010"]


# ===================================================================
# 10. CHAIN.tsv rendering and parsing
# ===================================================================

def test_render_chain_roundtrip():
    """render_chain + parse_chain is identity on data lines."""
    fm = {"0001": None, "0002": "0001", "0003": "0001"}
    known = set(fm)
    segments, gaps, forks, unchained = chain_mod.compute_segments(
        fm, known, segment_size=25
    )
    text = chain_mod.render_chain(segments, gaps, forks, unchained)
    parsed = chain_mod.parse_chain(text)
    assert len(parsed) == len(segments)
    for orig, rt in zip(segments, parsed):
        assert orig["label"] == rt["label"]
        assert orig["unit_ids"] == rt["unit_ids"]
        assert orig["inherits"] == rt["inherits"]
        assert orig["handoff"] == rt["handoff"]


def test_render_chain_is_idempotent():
    """Two calls with the same data produce byte-identical text."""
    fm = {"0001": None, "0002": "0001"}
    known = set(fm)
    s, g, f, u = chain_mod.compute_segments(fm, known)
    a = chain_mod.render_chain(s, g, f, u)
    b = chain_mod.render_chain(s, g, f, u)
    assert a == b


# ===================================================================
# 11. disagreement detection
# ===================================================================

def test_label_disagreement_detected():
    """Changing a segment's label on disk is detected."""
    computed = [{"label": "A", "unit_ids": ["0001", "0002"],
                 "inherits": None, "handoff": "abc"}]
    on_disk = [{"label": "X", "unit_ids": ["0001", "0002"],
                "inherits": None, "handoff": "abc"}]
    findings = chain_mod._check_disagreements(computed, on_disk)
    assert any("LABEL" in f for f in findings)


def test_new_segment_detected():
    """A segment in computed but not on disk is reported as NEW."""
    computed = [{"label": "A", "unit_ids": ["0001"],
                 "inherits": None, "handoff": "abc"},
                {"label": "B", "unit_ids": ["0002"],
                 "inherits": "abc", "handoff": "def"}]
    on_disk = [{"label": "A", "unit_ids": ["0001"],
                "inherits": None, "handoff": "abc"}]
    findings = chain_mod._check_disagreements(computed, on_disk)
    assert any("NEW" in f for f in findings)


def test_missing_segment_detected():
    """A segment on disk but not in computed is reported as MISSING."""
    computed = [{"label": "A", "unit_ids": ["0001"],
                 "inherits": None, "handoff": "abc"}]
    on_disk = [{"label": "A", "unit_ids": ["0001"],
                "inherits": None, "handoff": "abc"},
               {"label": "B", "unit_ids": ["0002"],
                "inherits": "abc", "handoff": "def"}]
    findings = chain_mod._check_disagreements(computed, on_disk)
    assert any("MISSING" in f for f in findings)


def test_no_disagreement_when_matching():
    """Identical computed and on-disk produce no findings."""
    seg = {"label": "A", "unit_ids": ["0001"],
           "inherits": None, "handoff": "abc"}
    findings = chain_mod._check_disagreements([seg], [seg])
    assert findings == []


# ===================================================================
# 12. chain() with real units (temp tree)
# ===================================================================

def test_chain_empty_tree(tree):
    """An empty units/ directory produces no segments."""
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=tree, segment_size=25
    )
    assert segments == []


def test_chain_one_unit_no_follows(tree):
    """A single unit with no follows: is an unchained root segment."""
    make_unit(tree, "0001", "probe")
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=tree, segment_size=25
    )
    assert len(segments) == 1
    assert segments[0]["label"] == "A"
    assert segments[0]["unit_ids"] == ["0001"]
    assert unchained == ["0001"]


def test_chain_simple_follows(tree):
    """Two units linked by follows: form one segment."""
    make_unit(tree, "0001", "first")
    make_unit(tree, "0002", "second", follows="0001")
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=tree, segment_size=25
    )
    assert len(segments) == 1
    assert segments[0]["unit_ids"] == ["0001", "0002"]


def test_chain_gap_in_tree(tree):
    """A unit following a missing id produces a gap."""
    make_unit(tree, "0005", "orphan", follows="0004")
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=tree, segment_size=25
    )
    assert len(gaps) == 1
    assert gaps[0] == ("0005", "0004")


def test_chain_fork_in_tree(tree):
    """Two units following the same id produce a fork."""
    make_unit(tree, "0001", "root")
    make_unit(tree, "0002", "child-a", follows="0001")
    make_unit(tree, "0003", "child-b", follows="0001")
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=tree, segment_size=25
    )
    assert len(forks) == 1
    labels = {s["label"] for s in segments}
    assert "A" in labels
    assert "A.A" in labels


# ===================================================================
# 13. CLI subcommand
# ===================================================================

def test_cli_chain_subcommand(tree):
    """lab chain runs and exits 0 on a fresh tree."""
    make_unit(tree, "0001", "probe")
    code, out, err = _run(chain_mod.run, cwd=tree)
    assert code == 0, out + err
    assert "SEGMENT" in out
    assert "CHAIN.tsv regenerated" in out


def test_cli_chain_exits_2_no_units(tmp_path):
    """lab chain exits 2 when no units/ directory exists."""
    code, out, err = _run(chain_mod.run, cwd=tmp_path)
    assert code == 2


def test_cli_chain_generates_chain_tsv(tree):
    """lab chain writes CHAIN.tsv at the project root."""
    make_unit(tree, "0001", "probe")
    code, _, _ = _run(chain_mod.run, cwd=tree)
    assert code == 0
    chain_path = tree / "CHAIN.tsv"
    assert chain_path.is_file()
    text = chain_path.read_text(encoding="utf-8")
    assert "GENERATED" in text
    assert "0001" in text


def test_cli_chain_disagreement_exits_1(tree):
    """lab chain exits 1 when CHAIN.tsv has a label disagreement."""
    make_unit(tree, "0001", "probe")
    # Write a stale CHAIN.tsv with a wrong label.
    chain_path = tree / "CHAIN.tsv"
    chain_path.write_text(
        "# stale\n"
        f"Z\t0001\t-\t{chain_mod.handoff_digest(['0001'])}\n",
        encoding="utf-8",
    )
    code, out, err = _run(chain_mod.run, cwd=tree)
    assert code == 1, out + err
    assert "LABEL" in out


def test_cli_chain_clean_rerun(tree):
    """Running lab chain twice exits 0 on the second run."""
    make_unit(tree, "0001", "probe")
    make_unit(tree, "0002", "next", follows="0001")
    code1, _, _ = _run(chain_mod.run, cwd=tree)
    assert code1 == 0
    code2, out2, _ = _run(chain_mod.run, cwd=tree)
    assert code2 == 0, out2


def test_cli_chain_reports_gap(tree):
    """lab chain reports a gap."""
    make_unit(tree, "0010", "orphan", follows="0009")
    code, out, _ = _run(chain_mod.run, cwd=tree)
    assert code == 0
    assert "GAP" in out
    assert "0009" in out


def test_cli_chain_reports_fork(tree):
    """lab chain reports a fork."""
    make_unit(tree, "0001", "root")
    make_unit(tree, "0002", "child-a", follows="0001")
    make_unit(tree, "0003", "child-b", follows="0001")
    code, out, _ = _run(chain_mod.run, cwd=tree)
    assert code == 0
    assert "FORK" in out


def test_cli_chain_reports_unchained(tree):
    """lab chain reports unchained units."""
    make_unit(tree, "0001", "fixture")
    code, out, _ = _run(chain_mod.run, cwd=tree)
    assert code == 0
    assert "UNCHAINED" in out


def test_cli_chain_segment_size_flag(tree):
    """lab chain respects a custom segment size."""
    make_unit(tree, "0001", "a")
    make_unit(tree, "0002", "b", follows="0001")
    make_unit(tree, "0003", "c", follows="0002")
    make_unit(tree, "0004", "d", follows="0003")
    code, out, _ = _run(chain_mod.run, cwd=tree, segment_size=2)
    assert code == 0
    # 4 units, segment_size=2 -> 2 segments
    assert out.count("SEGMENT") == 2


# ===================================================================
# 14. the real tree
# ===================================================================

def test_real_tree_produces_valid_chain():
    """The actual units/ directory produces a valid chain.

    This test runs against whatever units exist on disk.  It verifies:
      - the chain computes without error
      - every unit with a follows: field appears in some segment
      - every segment has a non-empty handoff
      - no two segments share a label
    """
    root = unit_mod.units_root(cwd=ROOT)
    if root is None:
        pytest.skip("no units/ directory")
    segments, gaps, forks, unchained = chain_mod.chain(
        cwd=ROOT, segment_size=25
    )
    # Every unit should appear in exactly one segment.
    all_ids_in_segments = []
    for seg in segments:
        all_ids_in_segments.extend(seg["unit_ids"])
    known = unit_mod.units_of(root)
    for uid in known:
        assert uid in all_ids_in_segments, \
            f"unit {uid} not in any segment"

    # No duplicate labels.
    labels = [s["label"] for s in segments]
    assert len(labels) == len(set(labels)), f"duplicate labels: {labels}"

    # Every segment has a non-empty handoff.
    for seg in segments:
        assert seg["handoff"], f"empty handoff in {seg['label']}"


def test_real_tree_chain_tsv():
    """lab chain runs and generates CHAIN.tsv on the real tree.

    This test does NOT write to the real tree.  It runs in a copy to
    avoid side effects.
    """
    import shutil
    import tempfile
    real_units = ROOT / "units"
    if not real_units.is_dir():
        pytest.skip("no units/ directory")
    with tempfile.TemporaryDirectory() as td:
        td = pathlib.Path(td)
        shutil.copytree(real_units, td / "units")
        # Copy the notebook for the floor (if present).
        notes = ROOT / "notes"
        if notes.is_dir():
            shutil.copytree(notes, td / "notes")
        code, out, err = _run(chain_mod.run, cwd=td)
        assert code == 0, out + err
        assert (td / "CHAIN.tsv").is_file()
