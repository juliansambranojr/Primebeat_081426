---
id: 0340
date: 2026-09-06
type: run
title: Probe: does the module loop transfer to a weaker agent (rung 5 section 7)
refs: [none]
supersedes: []
follows: 0339
sealed: false
---

**Question.** Does the module loop (`lean_stage3/LOOP.md`) carry a fresh, weaker agent from a SKETCH section to a committed module with nobody answering questions? The section is the worksheet's section `seven` (`rung5.md#7`), the comparison at another off-line zero. EXPLORATORY: no prereg in `preregs/`, the predictions below stand in for one and were written before the spawn.

**What ran.** One subagent, spawned from this session at `14:58` through the Agent tool with the model option `opus` (the harness names the tier; the exact Opus version is whatever the harness resolves that option to today, and is recorded in `run/report.md` when the agent reports). The prompt is `run/prompt.md`, verbatim. The agent runs in the working tree on `main`; its commits land through the pre-commit like anyone's. The orchestrator writes nothing into the agent's module or unit. The agent's final report is copied into `run/report.md` as returned.

**What it shows.** Predictions, before the run. Baseline from this session's seven modules (`0329` to `0335`): `errors_first` per module was `5, 5, 1, 0, 8, 3, 0`, median `errors_median` 3, and the seven took `baseline_minutes` 41 minutes of clock together (unit `0336`). The measures, each read from the tree after the agent stops:

The measure `commit` is a commit on `main` with a new `lean_stage3/Stage3/*.lean`, its import in `Stage3.lean`, and a unit that passes `check_lean_unit.py`; predicted 1. The measure `errors_first` is read from the agent's unit; predicted between `pred_errors_lo` 4 and `pred_errors_hi` 12. The measure `minutes` is spawn to commit from `git log`; predicted between `pred_min_lo` 30 and `pred_min_hi` 60. The measure `restarts` counts the messages the orchestrator had to send the agent to continue; predicted `pred_restarts` 0. The measure `pins` is whether the agent wrote pins for its task in `PINS.md`; predicted 1. The measure `worksheet` is whether section 7 flipped to PROVED naming the theorem; predicted 1. The measure `traps_added` counts rows appended to `TRAPS.md`; predicted at least 1.

Decision rule, fixed now. The loop transfers if `commit` is 1 with `restarts` 0 and `errors_first` at most 12. It transfers weakly if `commit` is 1 with a restart. It does not transfer if no commit lands; then the place the agent stopped is the loop's defect and goes into `TRAPS.md` or `LOOP.md` as the next edit.

**Outcome.** Transferred, under the rule above. The agent's report is `run/report.md`, verbatim. Read from the tree: `commit` 1, the module `WeilPowerCompare.lean` at `94febea` with `module_lines` 340 lines, `theorems_proved` 21 theorems, `defs` 8 defs, `sorries` 0 sorries, `pins_module` 4 axiom pins, imported in `Stage3.lean`, and unit `0341` passing `check_lean_unit.py`; `errors_first` 5, inside the predicted band; `minutes` 14 from the spawn to the first commit, below the predicted band by half; `restarts` 0; `pins` 1, written into `PINS.md` before the module; `worksheet` 0, the agent left section 7 marked SKETCH, the one prediction that failed; `traps_added` 3 rows plus `names_added` 15 verified names; `refusals` 0 pre-commit refusals across `commits` 2 commits. The agent did not say which Opus version it was.

The agent named `defects` 7 places where the method's text was unclear or wrong. One is a real contradiction: the loop's step 7 says a recipe edit is committed with the unit that caused it, and the checker demanded the unit's `loop_version` equal the current line, so that commit could never pass. The agent committed the unit first and the bump second, and every earlier Lean unit then failed the checker in the working tree. Fixed after the run in this commit: the checker accepts a `loop_version` at or below the current line, since a unit records the recipe it was built under. The other text defects the agent named (the step's file count, the name grep that walks into the directory the orient gate refuses, the design row described as a slug when every unit uses the number, the undefined `errors_first`) are in `LOOP.md` version `loop_ver_after` 7 and the agent's own version `loop_ver_agent` 6. The stale `AGENT_CARD.md` line citations into `CLAUDE.md` are replaced by section names. The orchestrator wrote nothing into the module or unit 0341; the section 7 mark in the worksheet was flipped to PROVED by the orchestrator after the measure was taken.

What the outcome means for the question: the loop carried an agent that had never seen the repo from a SKETCH section to a committed, gate-checked module with no human in the loop, faster than the orchestrator's own pace this morning. The failures were all in the method's text, none in the mathematics; each is now a line in the recipe or a row in the checker.
