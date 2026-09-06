---
id: 0342
date: 2026-09-06
type: instrument-fix
title: check_lean_unit.py: loop_version at or below the current line; the loop's step 7 and its gate had contradicted each other
refs: [none]
supersedes: []
follows: 0340
sealed: false
---

**Question.** The module loop's step `seven` said a recipe edit bumps the version line and is committed together with the unit that caused it. The checker the pre-commit runs on that unit demanded the unit's `loop_version` equal the current line. Both were written this morning, by the orchestrator, and the contradiction went unnoticed through units `0336` to `0339` because no unit ever tried that commit. The probe agent (unit `0340`) tried it and was refused; it committed the unit first at version `v_unit` 5 and the bump to `v_agent` 6 second, and after that its own unit `0341` failed the checker in the working tree. This unit records the fix to the checker and the re-run.

**What changed.** `utilities/check_lean_unit.py`, LOOP check, in commit `ad7f80c`. The rule was equality with the version line. It is now: refuse a `loop_version` above the current line, accept anything at or below it. A unit is a record of the recipe it was built under and the version line only moves up, so a unit older than the recipe is the normal case and a unit newer than the recipe is the error. The docstring's LOOP line says the same. `lean_stage3/LOOP.md` step 7 now states the accepted range and is at version `v_now` 7.

**The re-run.** `run/run.sh` fetches the checker as it stood at `654150c` and runs old and new over every unit carrying a `loop_version` row; `run/compare.log` is its output. `units_with_row` 4 units carry the row. Under the old checker all `old_fail` 4 fail the LOOP check. Under the new one `new_fail` 0 fail it. Unit `0341` now passes every check. The other `three_decision` 3 units (`0336`, `0337`, `0338`) still refuse on the MODULE check: they are decision units that keyed the row as `loop_version` before `TRAPS.md` row B8 said to key it `loop_ver`; the pre-commit will run the Lean checker on them if they are ever re-staged. Nothing in their prose or values changed, so their numbers stay comparable; the row rename is the fix if one of them is reopened.

**Comparability.** No Lean unit before `0341` carries the row (the modules of units `0329` to `0335` predate the loop), so the old rule never fired on them and the new rule does not either. No result, count or pin changed anywhere; the change affects whether a commit completes.

What remains: the next Lean unit built under version 7 records `loop_version` 7, and a retrospective's bump to `v_next` 8 in the same commit is the first real test of the rule.
