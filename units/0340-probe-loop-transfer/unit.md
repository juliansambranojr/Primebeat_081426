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

Outcome: pending; filled in when the agent reports.
