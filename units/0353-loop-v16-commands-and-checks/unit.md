---
id: 0353
date: 2026-09-07
type: instrument-fix
title: "LOOP.md v16: the loop as commands, its prose rules moved into check_lean_unit.py"
refs: [none]
supersedes: []
follows: 0352
context: after the first relay run the builder's read of LOOP.md was the largest fixed cost of a module; the file carried the reason behind every command, and a gate does not need persuading
sealed: false
---

**Question.** `lean_stage3/LOOP.md` at version `v_old` 15 was `lines_old` 249 lines and `words_old` 1847 words, of which `code_old` 24 lines were commands; the rest was the reason behind each command with the unit that paid for it. The builder reads it top to bottom on every run. Where a rule is enforced by a checker, the paragraph that argues for it is dead weight in that read, and the record of why is already in the unit each rule cites. Which rules were prose only, and can they be checks?

**What ran.** Nothing numerical. The prose-only rules were: the name grep before writing, the scratch pass before the module, the `field_simp` grep, the header before any proof, the pins before the work, delete `Scratch.lean`, one try then `sorry`, the two stop points of the relay, the retrospective. Four of them became checks in `utilities/check_lean_unit.py`: SORRY (the module has no `sorry`, every unit), SCRATCH (`Stage3/Scratch.lean` is out of the tree, every unit), RING (no bare `ring` on the line after a `field_simp`), HEADER (the header before the first `import` names the block, the part of the `design` row after `#`), PINS (`PINS.md` names the module or the block). The last three apply to units at loop version `v_new` 16 and up, so no earlier unit is refused by a rule it was not built under. The name grep, the one-try rule, the stop points and the retrospective stay as one-line instructions. `LOOP.md` was rewritten as the commands in order with one line per rule, version `v_new` 16: `lines_new` 135 lines, `words_new` 840 words, the same section numbers `0` to `7` and `4b` so every reference from `DESIGN.md`, `TRAPS.md` and the units still resolves.

**What it shows.** The checker refuses nothing that passed before: every unit carrying `loop_version` gives the same result as at version 15, and the three that are refused (`unit_first` 0336 to `unit_third` 0338, the loop's own early units with no module counts) were refused before this change on the same lines. The test suite gives the same `tests_failing` 19 failures with and without the change, none in a test that reads the checker. What the builder reads on its first pass drops from `words_old` 1847 to `words_new` 840 words, and the reasons are where they were, in the units.

What remains. The next module is built at version `v_new` 16 and is the first the three gated checks see; its `errors_first` and minutes against units `unit_sigma` 0348 to `unit_shell` 0352 say whether the shorter read cost anything.
