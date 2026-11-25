---
id: 0526
date: 2026-11-25
type: formalization
title: "The mollifier's edge terms: small on the right edge, logarithmic on the horizontals"
refs: [lean_stage3/Stage3/LevinsonMollEdge.lean::molli_sub_one_le, lean_stage3/Stage3/LevinsonMollEdge.lean::f_sub_one_le, lean_stage3/Stage3/LevinsonMollEdge.lean::right_log_term_le, lean_stage3/Stage3/LevinsonMollEdge.lean::right_arg_term_le, lean_stage3/Stage3/LevinsonMollEdge.lean::right_terms_le, lean_stage3/Stage3/LevinsonMollEdge.lean::real_zero_count_gen, lean_stage3/Stage3/LevinsonMollEdge.lean::edge_le_gen, lean_stage3/Stage3/LevinsonMollEdge.lean::horizontal_terms_le]
supersedes: []
follows: 0525
context: unit 0525 bounded the zeros of the perturbed function by a log mean square plus edge terms; Julian asked for the mollifier's edge terms; block S11 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Block S11 of `lean_stage3/design/stencil.md`, the mollifier's edge terms. For a Dirichlet polynomial mollifier, are the right edge terms at most the length times a quantity that falls with the abscissa plus a constant, and each horizontal edge term a multiple of the logarithms of the height and the mollifier's size?

**What was proved.** `lean_stage3/Stage3/LevinsonMollEdge.lean`: `module_lines` 906 lines, `theorems_proved` 21 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 8 axiom pins. The first build had `errors_first` 4 error lines; clean on build `builds` 3. The package builds at `jobs_package` 8903 jobs, the module at `jobs_module` 8809. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`molli_sub_one_le` and `f_sub_one_le`: far enough right, a Dirichlet polynomial with first coefficient one and bounded coefficients, and its product with zeta plus a multiple of its derivative, are close to one, within `tailDelta`. `right_log_term_le` and `right_arg_term_le`: the logarithm of the size along the right edge is at most the length times twice that distance, and the argument term is at most pi; `right_terms_le` adds them. `real_zero_count_gen` is the Jensen count with general radii; `edge_le_gen` is the Backlund bound on a disc centred on the right edge at the height, and `horizontal_terms_le` integrates it over the abscissas of the edge, giving a multiple of the logarithms of the height, the length of the mollifier and its coefficient bound. The logarithm of the size along the right edge is bounded in the length-times-small form; the constant form through the Dirichlet series of the logarithm is open.

**Who wrote it.** One worker, whose builds stopped on a power rewrite, two timeouts and field_simp steps. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, and each pin reads the standard axioms.

What remains. The avoidance hypotheses, the mean value left of the line and the assembly; nothing here proves the hypothesis.
