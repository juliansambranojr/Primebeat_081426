"""lab — the program that keeps the container of sealed units honest.

Design: `analysis/2026-09-02/lab_design.md`. PHASE 0 of its phase table
built the entrypoint, the unit loader, `lab check` and two fixtures.
PHASE 1 built the unit's lifecycle: `lab new` scaffolds one, `lab values`
generates its pool from `run/`, `lab seal` makes it immutable, and
`lab check` holds a sealed unit to its manifest. PHASE 2 moved the exemption
list into `lab/exempt.py` and gave the commit gate `utilities/check_units.py`.
PHASE 2b audited that list, admitted numbers stored inside string values, and
built `lab run` -- the verb that puts a result in a file before it reaches a
sentence. PHASE 3 built `lab index` -- the verb that regenerates INDEX.md and
INDEX-values.tsv from the units tree. PHASE 4 built `lab chain` -- the verb
that walks the follows: chain, groups units into bounded segments with
deterministic labels, detects forks and gaps, and generates CHAIN.tsv.
PHASE 5 built the agent interface: `lab cite` prints a value for a program
to paste, `lab brief` generates a brief block carrying keys and unit ids
for an agent prompt, and `lab report` generates a tagged report block from
a unit.

Standard library only. The design's line is "Python, standard library only
for the program itself" (§ The CLI), and it is load-bearing: the program has
to run from any checkout with nothing installed but itself.
"""

__version__ = "0.0.0"

__all__ = ["__version__"]
