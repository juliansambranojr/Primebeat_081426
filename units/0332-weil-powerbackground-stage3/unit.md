---
id: 0332
date: 2026-09-06
type: formalization
title: "WeilPowerBackground.lean: the switched window as a test function, every term minus a square, the on-line terms as real squares with near and far bounds"
refs: [lean_stage3/Stage3/WeilPowerBackground.lean::laplace_phiW, lean_stage3/Stage3/WeilPowerBackground.lean::term_eq_neg_sq, lean_stage3/Stage3/WeilPowerBackground.lean::online_term_eq, lean_stage3/Stage3/WeilPowerBackground.lean::online_term_le_far]
supersedes: []
follows: 0331
sealed: false
---

**Question.** Rung `rung` 5, fifth slice. Units 0320 and 0326 read the
raised-cosine window into the explicit formula: the test function, its
Laplace transform, every term of the zero form as minus a square, the
on-line terms as real squares, and the near and far bounds. Does the
switched window of unit 0330 go through the same reading, with unit
0331's bounds in place of unit 0319's lobe?

**What ran.** `lean_stage3/Stage3/WeilPowerBackground.lean`, new,
`module_lines` 264 lines, imported from `Stage3.lean`. `errors_first` 0
errors on the first build. Full package built, `jobs_package` 8750 jobs.
`run/build.log` is the record.

**What it shows.** `theorems_proved` 16 theorems and `defs` 3 definitions
(`phiW`, `phiWC`, `PsiW`), the pinned theorems by `#guard_msgs` to
`axioms` 3 axioms, `sorries` 0 sorries.

The test function. `phiW` is the switched window cut to `[−h, h]` and
multiplied by `e^{−u/2}`, real-valued. `laplace_phiW`: its Laplace
transform in the explicit formula's convention is the window's transform
read at `−z − 1/2`, by unit 0320's argument word for word.

Minus a square. `S_neg`: the odd envelope's transform is odd, through
unit 0318's odd-part lemma and the oddness of `sinh`. `what_neg`: the
window's transform is odd. `term_eq_neg_sq`: for every `ρ` the term of
the zero form is minus the square of the transform at `ρ − 1/2`;
`term_re_eq` reads its real part as the imaginary part squared minus the
real part squared.

The line. `S_I_mul`: at an imaginary argument the odd transform is `i`
times the real number `PsiW m t`, the integral of the envelope against
`sin(tx)`. `what_I` and `online_term_eq`: on the line the term is `h/2`
squared times the square of `PsiW` at `h(γ_ρ + γ)` plus `PsiW` at
`h(γ_ρ − γ)`, and `online_term_nonneg` follows.

The bounds. `abs_q_le_one` and `PsiW_le_two`: the envelope is at most 1
in absolute value, so `PsiW` is at most `psi_bound` 2, and
`online_term_le_near` gives the on-line term at most `near_coeff` 4
times `h²`, as before. `PsiW_le_far`: unit 0331's far bound at real part
zero, `PsiW` at most `cS m` times `(2/t²)` to the power `m+1` when `t²`
is at least `far_mult` 2 times `π²(m+1)²`. `online_term_le_far`: the
on-line term at most `h/2` squared times the square of the sum of the two
far bounds at `h(γ_ρ − γ)` and `h(γ_ρ + γ)`, when both are far enough.

What this closes. The switched window is a test function of the explicit
formula with every term of its zero form in the sign structure of unit
0326, and its on-line terms carry the decay of order `2m+2` in the
height in place of unit 0320's order 2.

What is open in it. No theorem yet says `phiWC` is in `IsTest`, the C¹
class of unit 0316; the envelope vanishes to order `2m+1` at the cut, so
for `m` at least 1 it is, and that proof is a slice of its own. The
on-line background of units 0321 to 0324 reads the old window by name;
the next slice restates it with the term as a parameter.
