"""`lab cite <unit> <key>` -- print a value so a program can paste it.

PHASE 5 of `analysis/2026-09-02/lab_design.md`. The design's § The agent
interface says:

    "A brief carries keys and unit ids. A report carries a generated
     block. No digit crosses either boundary as a keystroke. `lab cite`
     is how a value reaches prose; a model asking for a number gets it
     from the program."

And § The CLI lists it as:

    lab cite <unit> <key>     print the value, for a program to paste

The output is the raw value from `values.tsv`, one line, no decoration.
A script capturing it gets exactly what the file holds; an agent pasting
it into prose gets what the pool will match against, with no retyping
and no rounding.

Exit codes follow the uniform scheme:

    0   the value was printed
    1   the key does not exist in that unit's values.tsv
    2   the unit could not be loaded
"""

from .unit import UnitError, load

__all__ = ["CiteError", "cite_value", "run"]


class CiteError(Exception):
    """The key does not exist in the unit's values.tsv."""


def cite_value(unit_arg, key, cwd=None):
    """Return the raw value for `key` in the unit's values.tsv.

    Raises `UnitError` if the unit cannot be loaded. Raises `CiteError`
    if the key does not exist, with the available keys in the message.
    """
    unit = load(unit_arg, cwd=cwd)
    if key not in unit.values:
        available = sorted(unit.values.keys())
        raise CiteError(
            f"{key!r} is not a key in {unit.path.name}/values.tsv. "
            f"{len(available)} available key(s):\n"
            + "\n".join(f"  {k}" for k in available))
    return unit.values[key]


def run(unit_arg, key, out, err, cwd=None):
    """`lab cite <unit> <key>`: 0 printed, 1 no such key, 2 no such unit."""
    try:
        value = cite_value(unit_arg, key, cwd=cwd)
    except UnitError as exc:
        print(f"lab cite: {exc}", file=err)
        return 2
    except CiteError as exc:
        print(f"lab cite: {exc}", file=err)
        return 1
    print(value, file=out)
    return 0
