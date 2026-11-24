---
id: 0516
date: 2026-11-24
type: formalization
title: "Hardy's function: the completed zeta is real on the critical line, and a sign change there is a zero on the line"
refs: [lean_stage3/Stage3/HardyZ.lean::xi_line_real, lean_stage3/Stage3/HardyZ.lean::signChange_zero_on_line]
supersedes: []
follows: 0515
context: unit 0515 framed the zeros as sign changes of Hardy's function against the phase of the gamma factor; this is steps one and two of block S10 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Steps one and two of block S10 of `lean_stage3/design/stencil.md`. Is the completed zeta real on the critical line, and does a sign change of it there give a zero of zeta exactly on the line?

**What was proved.** `lean_stage3/Stage3/HardyZ.lean`: `module_lines` 127 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 2 axiom pins. The first build had `errors_first` 3 error lines; clean on build `builds` 2. The package builds at `jobs_package` 8893 jobs, the module at `jobs_module` 3172. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`xi_line_real`: the completed zeta at one half plus i t has imaginary part zero for every real t. Neither Mathlib nor the dependency had conjugation for the completed zeta, so the file proves it right of the imaginary axis from `riemannZeta_conj` and `Complex.Gamma_conj`, and the functional equation `completedRiemannZeta_one_sub` sends the point to its conjugate. `signChange_zero_on_line`: a sign change of its real part between two heights gives a zero of zeta on the line between them, by the intermediate value theorem and the nonvanishing of the gamma factor on the line.

Hardy's function is taken as the completed zeta on the line, which differs from it by the positive size of the gamma factor; no continuous phase is defined.

**Who wrote it.** One worker, whose first build stopped on a composition and a simp step. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The count of steps three and four of the block; nothing here proves the hypothesis.
