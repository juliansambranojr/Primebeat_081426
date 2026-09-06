---
id: 0338
date: 2026-09-06
type: decision
title: "Loop retrospective: what the scaffold could lose, five items, three changed now"
refs: [lean_stage3/Stage3/WeilPowerBands.lean::term_le_M]
supersedes: []
follows: 0337
sealed: false
---

**Question.** After the switched-window ladder and the loop's own build,
Julian asked which parts of the scaffold and the loop were useless in
retrospect and could be taken out.

**What ran.** Nothing numerical. `run/` is empty. The ref is the theorem
that had to be re-proved for the switched window because its predecessor
was stated for one window.

**What it shows.** `items` 5 items, in order of cost.

The old-window band chain, units 0321 to 0324. About `lines_copied` 600
lines that had to be copied when the window changed. Stated with the
term as a parameter, the switch would have been two modules instead of
four. Kept as record; the rule changed.

Rows for numbers inside inline math. About `rows_per_unit` 5 rows per
unit carrying nothing. The checker should exempt digits inside backticked
spans.

Unit 0325, the route decision. Overturned by unit 0327 within
`hours` 4 hours; kept as the record of a wrong turn.

The crude real-axis lower bound of unit 0331, about `lines_crude` 60
lines, unusable once `m` is of the order of `h`. The upper bounds in that
module are used.

The boilerplate lines in every question file, the `CONTEXT.md` and
`NOTEPAD` lines, repeated in `units_boiler` 12 units and never read.

Smaller: the odd-window contrast sweeps of the probe were decorative,
and the memory note duplicated what the repo holds.

**Changed now.** `lean_stage3/LOOP.md` is version `loop_version` 3: step
three says anything downstream of the window takes the term as a
parameter. The memory note is cut to pointers at the repo files.

**Decision.** Julian's: the inline-math exemption and the boilerplate
lines both live in `lab/check.py`, which requires the `two` 2 lines and
carries uncommitted edits from before this session; the boilerplate
removal was tried on this unit and refused by the installed checker, so
both are recorded here and left to him. Nothing is deleted; the old modules, unit
0325 and the crude bound stay as record.

What remains. The exemption in `lab/check.py`; the pre-commit call of
`check_lean_unit.py`; rung 5 from the worksheet's section `section_next`
7.
