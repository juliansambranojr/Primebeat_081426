#!/usr/bin/env python3
"""Check that a unit's context prose and its link fields agree.

    python3 utilities/check_unit_context.py units/0000-operator-selfadjointness

Three fields, one invariant:

    context: 'one line of prose naming what the test does and connects to'
    precedes: [0008, 0010]
    follows: 0004

Every 4-digit id in `precedes` and `follows` must appear in the `context`
string. Every 4-digit id found in the `context` string must appear in
`precedes`, `follows`, `refs`, or `supersedes`. Disagreement is drift.

Exit 0 clean, 1 finding, 2 unloadable.
"""
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from lab.unit import UnitError, load, units_of

UNIT_ID = re.compile(r"\b(\d{4})\b")


def ids_in_prose(text):
    """Every 4-digit number in the context string."""
    return set(UNIT_ID.findall(text))


def context_problems(unit):
    """[problem, ...] for context/precedes/follows disagreement."""
    fm = unit.front_matter
    problems = []

    context = fm.get("context")
    precedes = fm.get("precedes")
    follows = fm.get("follows")

    if context is None and precedes is None:
        return []

    if context is None and precedes is not None:
        problems.append("CONTEXT    precedes is set but context is missing")
        return problems

    if precedes is None and context is not None:
        problems.append("CONTEXT    context is set but precedes is missing")
        return problems

    if not isinstance(context, str):
        problems.append(f"CONTEXT    context must be a quoted scalar, "
                        f"got {context!r}")
        return problems

    if not isinstance(precedes, list):
        problems.append(f"CONTEXT    precedes must be a flow list, "
                        f"got {precedes!r}")
        return problems

    link_ids = set(precedes)
    if isinstance(follows, str) and follows:
        link_ids.add(follows)

    prose_ids = ids_in_prose(context)

    other_fields = set()
    for key in ("refs", "supersedes"):
        val = fm.get(key)
        if isinstance(val, list):
            other_fields.update(val)

    own_id = str(fm.get("id", ""))

    for lid in sorted(link_ids):
        if lid not in prose_ids and lid != own_id:
            problems.append(
                f"CONTEXT    {lid} is in precedes/follows but not in "
                f"context prose")

    known = units_of(unit.path.parent)
    for pid in sorted(prose_ids):
        if pid == own_id:
            continue
        if pid not in known:
            continue
        if pid in link_ids:
            continue
        if pid in other_fields:
            continue
        problems.append(
            f"CONTEXT    {pid} appears in context prose but not in "
            f"precedes, follows, refs, or supersedes")

    for lid in sorted(link_ids):
        if lid not in known and lid != own_id:
            problems.append(
                f"CONTEXT    {lid} in precedes/follows is not a unit "
                f"under {unit.path.parent}")

    return problems


def main():
    if len(sys.argv) < 2:
        print("usage: check_unit_context.py <unit>", file=sys.stderr)
        return 2

    try:
        unit = load(sys.argv[1])
    except UnitError as exc:
        print(f"check_unit_context: {exc}", file=sys.stderr)
        return 2

    problems = context_problems(unit)
    for p in problems:
        print(p)

    if problems:
        print(f"{unit.path}: {len(problems)} context problem(s)")
        return 1

    fm = unit.front_matter
    context = fm.get("context", "")
    precedes = fm.get("precedes", [])
    follows = fm.get("follows", "")
    print(f"{unit.path}: context ok — "
          f"{len(precedes)} precedes, "
          f"follows {follows or '(none)'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
