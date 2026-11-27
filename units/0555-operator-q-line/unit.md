---
id: 0555
date: 2026-11-25
type: formalization
title: "operator-q-line"
refs: [lean_stage3/Stage3/OperatorQ.lean::im_I_pow_iteratedDeriv, lean_stage3/Stage3/OperatorQ.lean::re_iteratedDeriv_odd, lean_stage3/Stage3/OperatorQ.lean::re_sum_line, lean_stage3/Stage3/OperatorQ.lean::coeff_comp_neg_X, lean_stage3/Stage3/OperatorQ.lean::taylor_coeff_even_eq_zero, lean_stage3/Stage3/OperatorQ.lean::re_W_line, lean_stage3/Stage3/OperatorQ.lean::zeta_line_zero_iff_W, lean_stage3/Stage3/OperatorQ.lean::cubic_sym, lean_stage3/Stage3/OperatorQ.lean::cubic_re_W_line]
supersedes: []
follows: 0554
context: block S13 of `lean_stage3/design/stencil.md`, step B4, puts a general polynomial in Levinson's operator; unit 0551 computed that a cubic one is what lets the floor approach one
sealed: false
---

**Question.** Block S13 of `lean_stage3/design/stencil.md`, step B4. For a general polynomial with the symmetry of its derivative about one half, which function of zeta's completed derivatives has its zeros on the critical line exactly at the zeros of zeta there?

**What was proved.** `lean_stage3/Stage3/OperatorQ.lean`: `module_lines` 306 lines, `theorems_proved` 14 theorems, `defs` 3 definitions, `sorries` 0 sorries, `pins` 9 axiom pins. The first build had `errors_first` 5 error lines; clean on build `builds` 4. The package builds at `jobs_package` 8957 jobs, the module at `jobs_module` 3174. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`im_I_pow_iteratedDeriv` and `re_iteratedDeriv_odd`: on the line, the completed zeta's derivatives of odd order are purely imaginary. `re_sum_line`: a combination of those derivatives whose even coefficients above order zero vanish has real part the order-zero coefficient times the completed zeta. `taylor_coeff_even_eq_zero`: the symmetry of the polynomial's derivative about one half is exactly the vanishing of its even Taylor coefficients at one half above order zero. `re_W_line` and `zeta_line_zero_iff_W`: for `W`, the polynomial at one half less one over the logarithm times the derivative, applied to the completed zeta, the real part on the line is the polynomial's value at one half times the completed zeta, so the zeros of zeta on the line are the zeros of that real part. `cubic_sym` and `cubic_re_W_line`: a cubic polynomial meeting the hypotheses.

**What failed.** The same identity for the operator applied to zeta itself, Levinson's form, holds only for a linear polynomial: for a nonlinear one the real part on the line carries the second derivative with a coefficient that moves with the height. The worker found it on paper and checked it numerically. Conrey's paper on the derivatives of xi, read this session, counts through a function of the same kind as `W`, with the same shift.

**Who wrote it.** One worker. The file was searched here for `sorry`, added axioms and `native_decide`, of which it has none, the package was rebuilt here, and each pin reads the standard axioms. No new trap row; the worker's candidates are recorded in its report.

What remains. Conrey's identity and the count through `W`, the mean value with a general polynomial, and the closed form.
