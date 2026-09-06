---
id: 0346
date: 2026-09-06
type: formalization
title: WeilPowerSharp.lean: the Gaussian bounds with the constant kept and the tail sum sharp; the two lost factors removed
refs: [lean_stage3/Stage3/WeilPowerSharp.lean::compare_sharp, lean_stage3/Stage3/WeilPowerSharp.lean::S_real_ge_sharp, lean_stage3/Stage3/WeilPowerSharp.lean::sum_inv_sq_ge_sharp, lean_stage3/Stage3/WeilPowerSharp.lean::norm_S_le_c_pos]
supersedes: []
follows: 0345
sealed: false
---

**Question.** Requirement (a) of worksheet section `thirteen`: the Gaussian bounds of section `five` (`rung5.md#5`) with no factor lost between the target and a competitor. Unit `0345` found two: the constant `cS m / D m` bracketed by a factor `2m+3`, and the tail sum bracketed by a factor near `rate_loss` 4 in the rate.

**What was proved.** `module_lines` 244 lines, `theorems_proved` 7 theorems, `defs` 0 definitions, `pins_module` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries. The constant is kept as `cS m / D m` on both sides. The tail-sum lower bound is the telescoping one, `sum_telescope` and `sum_inv_sq_ge_sharp`: the sum from `m+1` to `n−1` of `1/(j+1)²` is at least `1/(m+2) − 1/(n+1)`. `Tr_ge_sharp` carries it through the tail product, and `S_real_ge_sharp` through the limit, which now moves on both sides (`le_of_tendsto_of_tendsto`, since the bound depends on `n`): the target's real part is at least `cS m / D m` times `s` times `exp(s²/(π²(m+2)) − s⁴/(π⁴(m+1)³))`. `norm_S_le_c_pos` and `norm_S_le_c_neg` restate unit `0333`'s upper bounds with the constant kept. `compare_sharp` divides: for `Re(w²) ≥ 0`, `‖S m w‖` is at most `‖w‖/s` times `exp((Re(w²) − s²)/(π²(m+1)) + s²/(π²(m+1)(m+2)) + (‖w‖⁴ + s⁴)/(π⁴(m+1)³))` times `Re S m s`. The prefactor carries no power of `m`; the exponent's correction `s²/(π²(m+1)(m+2))` is the constant `ε²/(π²λ²)` at `s = εh`, `m+1 = λh`.

**The build.** `errors_first` 4 error lines on the first build, `roots` 2 root causes: a `field_simp` that left a `(m+2)·0` residue because a `− 0` sat inside the expression (fixed by `rw [sub_zero]` first), and a `ring` after a `field_simp` that had already closed the goal (`TRAPS.md` row 1); the other `cascade_lines` 2 lines were the pins' `sorryAx` cascade (`TRAPS.md` row `row_cascade` 19). Second build clean, `jobs_module` 8662 jobs; the package builds at `jobs_package` 8756 jobs. Built under the loop at version `loop_version` 8 by the orchestrator, for comparison with units `0340` and `0343`.

What the next slice needs. Requirement (b) of section 13: the phase of the tail product, `‖T m w n − 1‖` bounded by twice the quartic term, and from it a lower bound on `Re (S m w)²` in terms of the explicit principal part; and the sharp exponent for the `Re(w²) ≤ 0` case, which this module left at unit 0333's `(m+2)/(2m+3)²`.
