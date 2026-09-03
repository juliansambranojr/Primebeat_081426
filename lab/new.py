"""`lab new <slug>` — scaffold a unit directory under `units/`.

PHASE 1 of `analysis/2026-09-02/lab_design.md`. The directory it writes is
the design's § The unit, exactly:

    units/<id>-<slug>/
      unit.md          authored prose + front matter
      question.md      the transcript bracket the question was posed in
      run/             the code, its results, its logs -- as produced
      values.tsv       GENERATED: key<TAB>value, one line per leaf

THE ID IS ALLOCATED BY SCANNING `units/`. The design's § The CLI says
"id from INDEX", and there is no INDEX yet -- `lab index` is Phase 3. So
this reads the directory: every name matching `<4+ digits>-<slug>` is an
allocated id, and the new unit takes the highest plus one, zero-padded to
four places. When Phase 3 lands, INDEX.md becomes the faster path to the
same answer; the directory stays the ground truth, because it is the thing
the id has to be unique against.

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
"""

import datetime
import pathlib
import re

from . import values as values_mod
from .unit import UnitError, format_front_matter, units_root

__all__ = ["SLUG", "next_id", "scaffold", "run"]

SLUG = re.compile(r"^[A-Za-z0-9]+(?:[-_][A-Za-z0-9]+)*$")
ID = re.compile(r"^(\d{4,})-")

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


def next_id(root):
    """The next free unit id under `root`, zero-padded to four places."""
    highest = -1
    for path in pathlib.Path(root).iterdir():
        if not path.is_dir():
            continue
        m = ID.match(path.name)
        if m:
            highest = max(highest, int(m.group(1)))
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
