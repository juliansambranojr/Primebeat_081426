# Paper format — WIP, not canonical

Papers are the record: measured, failed, unexplained. Negative results stay.

## Structure

- Section: `## X · Title` — capital letter, middle dot `·` (U+00B7),
  contiguous from `A`.
- Statement: `**Xn.**` at line start. Numbering restarts each section.
- Source line: **one backtick span, nothing else on the line** — it may run
  over several lines. Every statement has one. A code block may sit between the
  statement and its source line.
- Last section is `Not established`. Exception: an all-negative paper
  (`What-Didnt-Work.md`).

## Source line

Free prose. Say where the statement comes from — an artifact, an earlier
statement, a citation, a derivation, or nothing (`open`, `stated`, `untested`).

Four kinds of token are **checked wherever they appear** in it. Everything else
is prose and is ignored.

```text
The-Fold.md § A3              a paper section or statement — must exist
Zeros.zero_iff_repeat         a Lean declaration — must exist in lean/
t23_fold.py                   a script — must exist
results/high_mass_zeros.json  an artifact — must exist
```

Bare letters (`A1`, `B3 + C3`) refer to statements in the same paper.

## Numbers

A statement whose source line names an artifact has its numbers checked against
that artifact, rounding-aware — `0.486` matches a printed `0.4860234`.

If the numbers are **computed from** artifacts rather than printed in them, say
so and they are skipped:

```text
derived from results/O22_run2.log: 5.015e53 / 3.485e53 = 1.439; not printed
O24_gen_xmax3e9_run.log against O24_gen_xmax1e9_run.log
```

## Rules

- Every number traces to an artifact through its source line.
- Never cite a script or results file before it exists — write `PENDING t25`.
- A checked token that does not resolve is an error, not a warning.
