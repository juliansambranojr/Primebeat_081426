---
id: 0343
date: 2026-09-06
type: run
title: Probe: the module loop on a Sonnet agent, rung 5 section 8, after the Opus agent's fixes
refs: [none]
supersedes: []
follows: 0342
sealed: false
---

**Question.** Two questions, one run. Does the module loop at version `loop_ver` 7 carry a weaker agent than the last one from a SKETCH section to a committed module, with nobody answering questions? And did the fixes the Opus agent's run produced (unit `0340`, unit `0342`) remove the defects it named, so that a new agent meets none of them? The section is `eight` (`rung5.md#8`), selection of the target: a maximum over a finite set of zeros and an induction with a bounded-increase step, a different shape from section `seven`'s inequalities. EXPLORATORY: no prereg in `preregs/`, the predictions below stand in for one and were written before the spawn.

**What ran.** One subagent, spawned from this session at `15:25` through the Agent tool with the model option `sonnet`; the harness resolves the version and the agent's report is asked to state it. The prompt is `run/prompt.md`: the Opus agent's prompt with the section changed, `prompt_lines_changed` 2 lines differing in `diff`. The agent runs in the working tree on `main`; its commits land through the pre-commit. The orchestrator writes nothing into the agent's module or unit. The report is copied to `run/report.md` as returned.

**What it shows.** Predictions, before the run. Baseline for this agent tier is the Opus run: `errors_first` `opus_errors` 5, `opus_minutes` 14 minutes to the first commit, `opus_defects` 7 defects named. The measures, read from the tree after the agent stops: `commit`, a commit on `main` with a new module, its import, and a unit passing `check_lean_unit.py`, predicted 1. `errors_first`, from the agent's unit, predicted between `pred_errors_lo` 8 and `pred_errors_hi` 20. `minutes`, spawn to first commit from `git log`, predicted between `pred_min_lo` 20 and `pred_min_hi` 50. `restarts`, predicted `pred_restarts` 0. `pins`, predicted 1. `worksheet`, section 8 flipped to PROVED in the same commit as the module, predicted 1 now that step 1 says so. `recurrence`, how many of the Opus agent's seven named defects this agent hits again, predicted `pred_recurrence` 0; each recurrence means the fix did not take. `new_defects`, places this agent names that the Opus agent did not, predicted at least 1.

Decision rule, the same as unit 0340's, quoted in `question.md`: transfers if `commit` is 1 with no restart and `errors_first` at most `pred_errors_hi` 20 (the band widened for the tier); weakly with a restart; fails without a commit, and then the stopping place is the loop's next edit. The fixes held if `recurrence` is 0.

Outcome: pending; filled in when the agent reports.
