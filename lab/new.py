"""`lab new <slug>` — scaffold a unit directory under `units/`.

PHASE 1 of `analysis/2026-09-02/lab_design.md`. The directory it writes is
the design's § The unit, exactly:

    units/<id>-<slug>/
      unit.md          authored prose + front matter
      question.md      the transcript bracket the question was posed in
      run/             the code, its results, its logs -- as produced
      values.tsv       GENERATED: key<TAB>value, one line per leaf

THE ID IS ALLOCATED BY SCANNING `units/`. The design's § The CLI says
"id from INDEX", and Phase 3 generates INDEX.md, but this reads the
directory: every name matching `<4+ digits>-<slug>` is an allocated id,
and the new unit takes the highest plus one, zero-padded to four places.
INDEX.md is the faster path to the same answer; the directory stays the
ground truth, because it is the thing the id has to be unique against.

PHASE 2c: THE DIRECTORY IS NOT THE ONLY FLOOR. Unit 0308 records what that
allocation did on the first real unit -- "it produced `0005-` while the
container's ids continue the notebook's numbering and this one has to be
0308 ... Nothing in the program knows the notebook's last number." The
design's § Phases says why the two numberings are one: "`notes/
lab_notebook_2.md` freezes exactly as volume 1 froze at entry 44; unit 0305
onward are directories."

So the floor is the notebook's last entry number, and it is READ out of
`notes/lab_notebook_2.md` rather than written down here as a constant. Two
reasons, and the second is the load-bearing one:

  - The notebook is the only place that number exists. A constant in this
    file would be a second copy of a count, which is the defect class the
    design's § The one measurement names -- every fact that drifted across
    three project trees was a count, an inventory or a status.
  - The file is FROZEN, so the read is stable: it returns 307 today and 307
    in a year, and it costs one regex over one file at scaffold time.

The notebook is found beside `units/` -- `<repo>/notes/lab_notebook_2.md`,
the repo root being the parent of the units directory. A tree with no
notebook (a bare `units/` in a test, another project's container) has no
floor, and the directory alone answers, which is Phase 1's behaviour
unchanged. The id taken is `max(highest directory id, notebook floor) + 1`.

A FRESHLY SCAFFOLDED UNIT LOADS AND CHECKS CLEAN. The `values.tsv` is
empty -- only the header comment lines `lab values` writes for a `run/`
with nothing in it -- and the body states no numbers. An empty pool plus no
claims satisfies the invariant, which is the correct reading: the check
fires on a number without evidence, never on the absence of numbers.

DECISIONS taken here where the design is silent:

  - The slug is `[a-z0-9]` separated by `-` or `_`, letters allowed in any
    case, and nothing else. A slug is half a directory name and is quoted
    in prose as `unit 0305 § ...`; a space or a slash in it would make the
    unit hard to name and impossible to cite.
  - `date:` is today, `type:` defaults to `run` (the design's own example),
    `title:` defaults to the slug, `refs: []`, `supersedes: []`,
    `sealed: false`. `--type` and `--title` override the two that are
    guesses. The type vocabulary is not checked here; the container's
    types are settled when entries migrate, which is not this phase.
  - `run/` gets a `.gitkeep`, matching the two Phase 0 fixtures, so an
    empty `run/` survives a clone.
  - The body is three bold lead-ins with angle-bracket placeholders and no
    digits anywhere. Bold lead-ins are the design's § Citations substrate,
    so a scaffold that has none would teach the wrong shape.
  - An existing directory is never touched: `lab new` refuses rather than
    merging into it.
  - PHASE 2c: `follows:` is written, pointing at the newest SEALED unit, per
    the design's § What a unit declares. It is OMITTED when no unit under
    `units/` is sealed, because the parser rejects an empty value and a
    placeholder would be a unit id naming no unit. `lab check` validates the
    field -- it names an existing unit, and a unit does not follow itself --
    and nothing walks it: the walk, forks, gaps and segments are Phase 4.
"""

import datetime
import pathlib
import re

from . import values as values_mod
from .unit import (
    FrontMatterError,
    UnitError,
    format_front_matter,
    parse_front_matter,
    split_front_matter,
    units_of,
    units_root,
)

__all__ = ["SLUG", "next_id", "notebook_floor", "newest_sealed", "scaffold",
           "run"]

SLUG = re.compile(r"^[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*$")
ID = re.compile(r"^(\d{4,})-")
NOTEBOOK = ("notes", "lab_notebook_2.md")
ENTRY = re.compile(r"^## \d{4}-\d{2}-\d{2} . Entry (\d+)\b", re.M)

BODY = """\
**Question.** <one line: what this unit set out to measure. The transcript
bracket it was posed in is in `question.md`.>

**What ran.** <the script and its flags. The code, its results and its logs
are in `run/`, copied in as produced.>

**What it shows.** <the finding, in prose. Every number written here has to
have a line in `values.tsv`: run `lab values`, then `lab check`.>
"""

QUESTION = ("> <paste the transcript bracket this unit's question was posed "
            "in, verbatim>\n")


def notebook_floor(root):
    """The last entry number in `<repo>/notes/lab_notebook_2.md`, or None.

    The container continues the notebook's numbering, so the notebook's last
    entry is a floor under every unit id. Read rather than stored: see the
    module docstring for why a constant here would be a second copy of a
    count.
    """
    path = pathlib.Path(root).parent.joinpath(*NOTEBOOK)
    if not path.is_file():
        return None
    numbers = [int(m.group(1))
               for m in ENTRY.finditer(path.read_text(encoding="utf-8"))]
    return max(numbers) if numbers else None


def newest_sealed(root):
    """The highest id among the units under `root` that are sealed, or None.

    What `follows:` points at, per the design's § What a unit declares:
    "`lab new` fills it with the newest sealed unit, so the ordinary case
    needs no thought and deviating is an explicit edit." Newest is by id,
    which the design's § The naming is deterministic makes the ordering key --
    "immutable and only increases" -- rather than by a timestamp.
    """
    best = None
    for unit_id, path in units_of(root).items():
        md = path / "unit.md"
        if not md.is_file():
            continue
        try:
            fm_text, _ = split_front_matter(md.read_text(encoding="utf-8"))
            front = parse_front_matter(fm_text)
        except (FrontMatterError, OSError, UnicodeDecodeError):
            continue                     # unreadable is not sealed
        if front.get("sealed") is True and (best is None or unit_id > best):
            best = unit_id
    return best


def next_id(root):
    """The next free unit id under `root`, zero-padded to four places.

    `max(highest directory id, the notebook's last entry) + 1`. PHASE 2c
    added the second term; unit 0308 is the finding that asked for it.
    """
    highest = -1
    for path in pathlib.Path(root).iterdir():
        if not path.is_dir():
            continue
        m = ID.match(path.name)
        if m:
            highest = max(highest, int(m.group(1)))
    floor = notebook_floor(root)
    if floor is not None:
        highest = max(highest, floor)
    return f"{highest + 1:04d}"


def scaffold(slug, root, today=None, type_="run", title=None):
    """Write a new unit directory. Returns its path. Raises `UnitError`."""
    if not SLUG.match(slug):
        raise UnitError(
            f"{slug!r} is not a slug; use letters and digits separated by "
            f"'-' or '_'")
    root = pathlib.Path(root)
    unit_id = next_id(root)
    path = root / f"{unit_id}-{slug}"
    if path.exists():
        raise UnitError(f"{path}: already exists")
    front = {
        "id": unit_id,
        "date": (today or datetime.date.today()).isoformat(),
        "type": type_,
        "title": title if title is not None else slug,
        "refs": [],
        "supersedes": [],
        "sealed": False,
    }
    follows = newest_sealed(root)
    if follows is not None:
        # After `supersedes:`, where unit 0308 put it by hand. Omitted
        # entirely when no unit is sealed yet: the parser rejects an empty
        # value, and `follows: none` would be a unit id that is not one.
        front = {**{k: v for k, v in front.items() if k != "sealed"},
                 "follows": follows, "sealed": front["sealed"]}
    (path / "run").mkdir(parents=True)
    (path / "run" / ".gitkeep").write_text("", encoding="utf-8")
    (path / "unit.md").write_text(
        "---\n" + format_front_matter(front) + "\n---\n\n" + BODY,
        encoding="utf-8")
    (path / "question.md").write_text(QUESTION, encoding="utf-8")
    (path / "values.tsv").write_text(values_mod.EMPTY, encoding="utf-8")
    return path


def run(slug, out, err, cwd=None, type_="run", title=None):
    """`lab new <slug>`: 0 written, 1 the id is taken, 2 usage.

    A malformed slug and a missing `units/` are usage (2); a directory that
    already exists is the tree's state refusing the write (1).
    """
    if not SLUG.match(slug):
        print(f"lab new: {slug!r} is not a slug; use letters and digits "
              f"separated by '-' or '_'", file=err)
        return 2
    root = units_root(cwd)
    if root is None:
        print("lab new: no units/ directory at or above the working directory",
              file=err)
        return 2
    try:
        path = scaffold(slug, root, type_=type_, title=title)
    except UnitError as exc:
        print(f"lab new: {exc}", file=err)
        return 1
    for name in ("unit.md", "question.md", "values.tsv", "run/.gitkeep"):
        print(f"WROTE      {path / name}", file=out)
    print(f"{path}: scaffolded; write the prose, drop the run into run/, "
          f"then `lab values` and `lab check`", file=out)
    return 0
