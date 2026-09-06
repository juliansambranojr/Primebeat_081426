---
id: 0336
date: 2026-09-06
type: decision
title: "The module loop: checklist, traps table and checker built into the bench, with the retrospective step that edits the recipe after every build"
refs: [lean_stage3/Stage3/WeilPowerOnLine.lean::tsum_onLine_le]
supersedes: []
follows: 0335
sealed: false
---

**Question.** After `modules` 7 modules on the switched window in
`minutes` 41 minutes (units `unit_first` 0329 to `unit_last` 0335), Julian
asked for a reflection on the loop that produced them: the sequence of
tool calls, what shifted across the iterations, what ran without a trace
in the record, and how to make the loop a template that an instance
without this session's context can live inside, with a growth step after
every build in the shape of Karpathy's recipe loop. Then he asked for it
to be built.

**What ran.** Nothing numerical. This unit records the `files` 3 files
built into the loop and the test of the checker. `run/` is empty. The ref is
the last theorem the loop produced before it was written down.

**What it shows.**

The loop as it ran. Six steps per module, stabilised over the seven:
the header comment written first as the design contract, naming the
pinned theorems; every Mathlib name verified by one batched grep before
writing; old modules read in full and copied with the term renamed;
build, then every error classified before any is fixed; counts by `wc`
and `grep` after the last edit, never from memory; the unit as a
paraphrase of the header with every number keyed, ending with the next
module's question. The shift across the seven was from serial to
parallel, and the header-first rule is what made each next step already
written when it was reached.

The data. First-build errors per module, from the units in order:
`e0329` 5, `e0330` 5, `e0331` 1, `e0332` 0, `e0333` 8, `e0334` 3,
`e0335` 0. The zeros are the copied modules; the eight is the module on
new ground, infinite products. The errors fall into `classes` 12 classes,
each of which recurred or will.

What ran without a trace. The design analysis between modules: the
near-band width, the far constant's power, the choice of the odd factor.
Each surfaced only as the prose of the unit that used it. Unit 0327 was
the one time it was logged as its own decision before the build.

**What was built.** `files` 3 files.

`lean_stage3/LOOP.md`, version `loop_version` 1. The loop in `sections` 8
sections, zero to seven, every step a command or a file: orient, the
header first, the batched name check, reuse by copying, build and
classify against the traps table, import and counts and log, the unit
with its three checkers, and the retrospective. A unit built under the
loop records `loop_version` in its values.

`lean_stage3/TRAPS.md`. The traps table: `trap_rows` 17 rows of error
pattern, cause and fix, twelve paid for today and five carried over from
CLAUDE.md, plus `bench_rows` 6 bench and gate rows and the list of
Mathlib names verified on this toolchain today. A build that shows a
class with no row adds one.

`utilities/check_lean_unit.py`. A checker with `checks` 8 checks: one
module per unit, line count against `wc`, theorem and definition counts
against `grep`, every ref declared and pinned, the next-slice paragraph
present, the loop version matching `LOOP.md`, and the build log ending in
success. Read-only over the tree.

The test. Unit 0335, built before the loop, is refused on the version row
alone, `refused_0335` 1 line. Unit 0333 is refused on the version row and
on the missing next-slice paragraph, `refused_0333` 2 lines. A copy of
0335 with the version row added passes with `pins_0335` 3 pins. The
checker bites exactly where the loop adds a requirement.

**The growth step.** Section seven of the checklist. After each commit:
classify the errors and add a row for any new class; edit the checklist
for any step that was reordered or batched; bump the version and commit
the recipe edit with the unit that caused it; keep an edit when
`errors_first` and the minutes per module trend down over the following
units, revert it when they do not. The evaluation is fixed and already in
the bench: the build with the pin, both checkers, the counts. The recipe
is the only thing that moves, one edit per iteration, kept on the metric.

**Decision.** Julian's: the pre-commit hook does not call the new checker
yet; adding it needs the approve flag on `utilities/hooks/`. Until then
`LOOP.md` runs it by hand at step six.

What remains. Wire the checker into the pre-commit; add `loop_version`
to the units built from here on; read the error curve before the next
recipe edit.
