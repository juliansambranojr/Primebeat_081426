---
id: 0337
date: 2026-09-06
type: decision
title: "The rung 5 worksheet: the derivations behind units 0326 to 0335 written to a file, and the loop's step one changed to start from it"
refs: [lean_stage3/Stage3/WeilPowerGauss.lean::S_real_ge_gauss]
supersedes: []
follows: 0336
sealed: false
---

**Question.** Unit 0336 said the design analysis between modules lived in
the session's window and left no trace. Julian asked where that window
is and proposed off-loading it to a file to free attention. Where does it
live, what is lost, and what is the file?

**What ran.** Nothing numerical. This unit records the worksheet, the
recipe edit, and the checker's new check. `run/` is empty. The ref is the
theorem whose derivation was redone most often before the worksheet
existed.

**What it shows.**

Where the head is. The context window: the transcript of the session
plus the reasoning between tool calls, which the user never sees and
which is discarded when the turn ends. The Gaussian regime was derived
`rederived` 3 times today, before units 0327, 0331 and 0333, because the
earlier derivation was behind in the transcript and cheaper to redo than
to find. After the compaction earlier in the day the size of every other
off-line zero's term had to be re-derived from the identity; unit 0327's
finding came out of that. A fresh instance gets the files and the memory
note, and none of the reasoning.

**What was built.**

`lean_stage3/design/rung5.md`, the worksheet. `sections` 12 sections,
each marked PROVED with the Lean theorem it names or SKETCH with the
numbers and the plan: the sign structure, the finding, the switched
window's closed forms, the crude bounds and where they lose a factor near
`e` to the `2m`, the Gaussian regime with the exponent
`(ε'² − Δ²)h/(π²λ)` and its quartic error and regime condition, the
on-line background with the near radius and the far constant, the
comparison at another off-line zero, the selection of the target with its
widening steps, the cluster and its alignment with one caveat named and
not yet resolved, the assembly, the probe's numbers, and the open
questions with the numbers that decide them. The rate at the target is
`ε²` over `2π²λ` per unit `h`, at `λ` equal `lambda` 1 about
`rate_coeff` 0.05 times `ε²`.

`lean_stage3/LOOP.md`, version `loop_version` 2. Step one now starts from
the worksheet: the analysis goes there first, the header cites the
section, a route change is also a decision unit, and a probe takes its
predictions from the worksheet before the run. The unit's values name
the section in a row `design`.

`utilities/check_lean_unit.py`, one new check, `checks` 9 in all: the
`design` row names a file under `lean_stage3/design/` and a section
heading in it, by slug or by numbered prefix. Tested on the copy of unit
0335 with the row: refused with a wrong section, passed with `rung5.md`
section `section_test` 6.

**Decision.** The worksheet is the scratch and the unit is the record.
The worksheet is committed with the units that use it; it carries no
quote gate and no values rows, so it does not slow the loop, and it is
never cited as evidence, only as the derivation behind a Lean statement.

What remains. The units from 0338 on carry the `design` row. The
worksheet's SKETCH sections 7 to 10 are the remaining rung 5 modules, in
that order.
