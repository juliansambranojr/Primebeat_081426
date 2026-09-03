"""The invariant: every number in a unit's prose appears in its values.tsv.

`analysis/2026-09-02/lab_design.md` § The invariant states it in one
sentence and settles two things this module would otherwise have to guess:

    "It covers the entry body and its fenced tables alike, since the check
     reads the file rather than a stripped copy of it."

so FENCED BLOCKS ARE READ. A number inside ```text is checked exactly like
a number in a paragraph. Every other checker in this tree strips fences
first (`utilities/check_refs.py`, `utilities/check_entry_numbers.py`); this
one does not, on the design's instruction.

    "Numbers that are not measurements -- dates, entry ids, line counts of
     the unit itself -- are exempt by pattern and the exemption list lives
     in the program."

so the exemption list is here, and it is the three classes the design
names and no fourth.

Why this discriminates: the design's § The one measurement records that
holding the matching rule fixed and varying only the pool, tree-wide
accepts most invented three-decimal values while one entry's own values
accepts almost none. The pool is one unit's values.tsv. That scoping is
the whole mechanism.

THE ROUNDING-AWARE COMPARISON IS COPIED, NOT IMPORTED. `NUM` and
`matches` below are a verbatim copy from
`utilities/check_entry_numbers.py`, which copied them in turn from
`utilities/check_values.py`. Copied because `lab` installs with
`pip install -e .` and runs from any working directory, while
`utilities/` is a directory of scripts rather than a package, resolves
its own repo paths at import, and is not on the installed program's
import path. An import would tie the installed console script to one
checkout. When the two drift, this file is the one the units answer to.

DECISIONS taken here where the design is silent:

  - Only `unit.md` is prose. `question.md` is a transcript bracket copied
    in verbatim (design § The unit), so its numbers are quoted rather than
    claimed, and holding a copy of a conversation to the invariant would
    make the fixture unwritable. `run/` is code and artifacts as produced.
  - The front matter is not prose. Its `id`, `date`, `refs` and
    `supersedes` are the exempt classes by construction, and scanning the
    block would only re-derive the exemption. The body begins after the
    closing `---`.
  - Every values.tsv value that parses as a number joins the pool,
    `meta.` keys included. The design excludes `meta.` from the DIGEST
    (§ The unit); it says nothing about excluding it from the pool, and a
    timing quoted in prose is still a number with evidence behind it.
  - The prose sets the precision. `matches(want, have)` tolerates half a
    unit in the last place the PROSE states, so `0.0184` in the body
    matches `0.018401` in the file, `0.02` also matches it (two decimal
    places is what `0.018401` rounds to), and `0.03` does not.
  - An ordered-list marker (`1.`, `2.`) is NOT exempt. The design names
    three exempt classes; adding a fourth is a decision for Phase 2, when
    `lab check` is completed against migrated units. Until then a unit
    body uses `-` markers.
  - A finding is located by the bold lead-in above it, never by a line
    number, per the design's § Citations: "No line numbers anywhere, in
    any file."
"""

import re
from decimal import Decimal, InvalidOperation

from .unit import UnitError, load

__all__ = ["check", "run", "matches", "findings", "NUM"]

# Copied from utilities/check_entry_numbers.py (NUM, matches). See the module
# docstring for why this is a copy rather than an import.
NUM = re.compile(r"-?\d{1,3}(?:,\d{3})+(?:\.\d+)?|-?\d+(?:\.\d+)?(?:[eE]-?\d+)?")


def matches(want, have):
    """want appears in have, at want's own precision."""
    exp = want.as_tuple().exponent
    places = -exp if isinstance(exp, int) and exp < 0 else 0
    tol = Decimal(5).scaleb(-places - 1)      # half a unit in the last stated place
    return any(abs(v - want) <= tol for v in have)
# end of copy

# The exemption list the design says lives in the program. Three classes.
DATE = re.compile(r"\b\d{4}-\d{2}-\d{2}\b")           # dates
UNIT_CITE = re.compile(r"\bunits?\s+\d+\b")            # `unit 0305 § ...`
LEAD_IN = re.compile(r"^\*\*(.+?)\*\*", re.M)          # a section's bold lead-in


def _pool(values):
    """The unit's numeric evidence: every values.tsv value that is a number."""
    out = set()
    for raw in values.values():
        try:
            out.add(Decimal(raw.replace(",", "")))
        except (InvalidOperation, ValueError):
            continue
    return out


def _exempt_spans(body):
    """Character ranges the exemption list removes from the scan."""
    spans = [m.span() for m in DATE.finditer(body)]
    spans += [m.span() for m in UNIT_CITE.finditer(body)]
    return spans


def _section(body, pos):
    """The bold lead-in a position sits under, or '-' above the first one."""
    last = None
    for m in LEAD_IN.finditer(body, 0, pos):
        last = m.group(1)
    return last.rstrip(".").strip() if last else "-"


def _snippet(body, start, end, width=64):
    """The finding's line, squeezed to one line and trimmed around the hit."""
    lo = body.rfind("\n", 0, start) + 1
    hi = body.find("\n", end)
    hi = len(body) if hi < 0 else hi
    line = " ".join(body[lo:hi].split())
    if len(line) <= width:
        return line
    hit = " ".join(body[start:end].split())
    at = line.find(hit)
    at = 0 if at < 0 else max(0, at - width // 3)
    trimmed = line[at:at + width]
    return ("..." if at else "") + trimmed + ("..." if at + width < len(line) else "")


def findings(unit):
    """[(token, section, snippet)] for every prose number with no evidence.

    Also returns the number of prose numbers scanned, so the summary can
    report how much the pool actually covered.
    """
    body, pool, ids = unit.body, _pool(unit.values), unit.ids
    spans = _exempt_spans(body)
    out, scanned = [], 0
    for m in NUM.finditer(body):
        if any(lo <= m.start() < hi for lo, hi in spans):
            continue                                   # a date, or a unit citation
        token = m.group(0)
        if token in ids:
            continue                                   # this unit's id, or one it names
        scanned += 1
        try:
            want = Decimal(token.replace(",", ""))
        except InvalidOperation:
            out.append((token, _section(body, m.start()),
                        _snippet(body, m.start(), m.end())))
            continue
        if not matches(want, pool):
            out.append((token, _section(body, m.start()),
                        _snippet(body, m.start(), m.end())))
    return out, scanned


def check(arg, out, cwd=None):
    """Run the invariant over one unit. Returns 0 clean, 1 unmatched.

    Raises `UnitError` when the unit cannot be loaded; the caller turns
    that into exit 2.
    """
    unit = load(arg, cwd=cwd)
    unmatched, scanned = findings(unit)
    for token, section, snippet in unmatched:
        print(f"UNMATCHED  {token:<14} § {section}  |  {snippet}", file=out)
    pool = _pool(unit.values)
    print(f"{unit.path}: {scanned} number(s) in prose, "
          f"{scanned - len(unmatched)} matched, {len(unmatched)} unmatched; "
          f"values.tsv: {len(unit.values)} key(s), {len(pool)} numeric",
          file=out)
    return 1 if unmatched else 0


def run(arg, out, err, cwd=None):
    """`lab check <unit>`: 0 clean, 1 unmatched, 2 unloadable."""
    try:
        return check(arg, out, cwd=cwd)
    except UnitError as exc:
        print(f"lab check: {exc}", file=err)
        return 2
