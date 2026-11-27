---
id: 0575
date: 2026-11-26
type: run
title: "The right zero unit 0572 found near 5010.87 belongs to its script's function; for the Lean V the same zero sits left of the line"
refs: [lean_stage3/Stage3/OperatorQ.lean::W, lean_stage3/Stage3/ConreyCountLine.lean::V]
supersedes: []
follows: 0572
context: the adversary review of unit 0576 found that unit 0572's script builds V from zeta-derivatives with coefficients at 0, while the Lean V is built from Lambda-derivatives with Taylor coefficients at one half; this reruns the one zero 0572 found, for both
sealed: false
---

**Question.** Where does the right zero found by the earlier measurement near five thousand sit, for that measurement's function and for the Lean V?

**What ran.** `run/zeroside.py`, by `run/run.sh`, through `lab run`, with `run/vlib.py` holding both functions. It is the adversary's location script from the review in unit 0576, writing `run/results.json`. The mollifier's logarithm is `results.L` 8.517193191416238. A grid search right of the line, then Newton's method. The first run failed because `python3 -I` blocked the import of `vlib.py` from the run folder; its record is `run/lab_run.001.json`. EXPLORATORY: no prereg, no verdict.

**What it shows.** The zero sits beside the close pair of zeta zeros at `results.zeta_zeros[0]` 5010.811172544729 and `results.zeta_zeros[1]` 5010.9331981060395. For Conrey's Q0, that unit's function has it at `results.Q0_script_re_minus_half` 0.023396512000737668 right of the line, and the Lean V at `results.Q0_lean_re_minus_half` -0.006048557009979749, left of it. For the cubic with d3 minus a fifth, the same: `results.m02_script_re_minus_half` 0.04203006082338179 right for the script, `results.m02_lean_re_minus_half` -0.004352500677793303 left for the Lean V. At each root the modulus is below `results.Q0_lean_abs_f` 3.441071348220595e-22.

**Correction to unit 0572.** Its counts are of the function in its script, Q of minus D over L applied to zeta, and say nothing about `StmtNoRightZeros`, which is about the Lean V. The two Q that gave a zero each have a root below one half: `results.Q_roots.Q0[0]` -0.8052058107178648 and `results.Q_roots.m02[2]` -0.57915619758885. Levinson's root is `results.Q_roots.lev[0]` 1.0.

What remains. Only this one zero was rerun; the rest of that unit's stretch is not checked for the Lean V with these two Q.
