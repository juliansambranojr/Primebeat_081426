"""lab — the program that keeps the container of sealed units honest.

Design: `analysis/2026-09-02/lab_design.md`. This is PHASE 0 of its phase
table: the entrypoint, the unit loader, `lab check`, and two fixtures.
`lab new`, `lab run`, `lab values`, `lab seal`, `lab index`, `lab chain`
and `lab cite` are later phases and are deliberately absent.

Standard library only. The design's line is "Python, standard library only
for the program itself" (§ The CLI), and it is load-bearing: the program has
to run from any checkout with nothing installed but itself.
"""

__version__ = "0.0.0"

__all__ = ["__version__"]
