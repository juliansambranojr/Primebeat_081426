---
id: 0335
date: 2026-09-06
type: formalization
title: "WeilPowerOnLine.lean: the switched window's on-line background at all heights, negative heights by conjugation, the low band, the assembly"
refs: [lean_stage3/Stage3/WeilPowerOnLine.lean::term_conj, lean_stage3/Stage3/WeilPowerOnLine.lean::tsum_onLine_le, lean_stage3/Stage3/WeilPowerOnLine.lean::onLineBound_le]
supersedes: []
follows: 0334
sealed: false
---

**Question.** Rung `rung` 5, eighth slice. Unit 0334 bounds the switched
window's weighted on-line sum over heights at least `height_min` 11/10.
Unit 0324 closed the negative heights and the low band for the old
window. Does the same closing go through for the switched window, and
what is the on-line background at all heights?

**What ran.** `lean_stage3/Stage3/WeilPowerOnLine.lean`, new,
`module_lines` 227 lines, imported from `Stage3.lean`. `errors_first` 0
errors on the first build. Full package built, `jobs_package` 8753 jobs.
`run/build.log` is the record.

**What it shows.** `theorems_proved` 11 theorems and `defs` 2 definitions
(`B`, `onLineBound`), the pinned theorems by `#guard_msgs` to `axioms` 3
axioms, `sorries` 0 sorries.

Negative heights. `PsiW_neg`: the switched window's transform on the line
is odd. `term_conj`: the on-line term at the conjugate zero equals the
term at the zero, conjugation flipping the height and `PsiW` flipping
sign twice inside a square. `weightedTermW_conjZ`: the weighted term is
conjugation-invariant, unit 0324's conjugate map and upstream's symmetry
of the multiplicity. `sum_lower_le`: a finite set of on-line zeros of
height at most `-11/10` conjugates injectively into one of height at least
11/10, and unit 0334's bound `B h γ m` applies.

The low band. `sum_low_le`: unit 0324's finite set and its `lowCount`, each
term at most `near_coeff` 4 times `h²` by unit 0332.

The assembly. `sum_onLine_le` splits any finite on-line set three ways by
height; `onLineBound h γ m` is `sides` 2 times `B h γ m` plus `4h²` times
`lowCount`. `tsum_onLine_le`: the full weighted sum over all on-line zeros
is at most `onLineBound h γ m` for `h` above zero and `γ` at least 11/10,
and `summable_onLine` gives the summability, both from the finite-sum
bound alone. `onLineBound_le` puts it in `γ`, `h` and `m`: `2` times
`weight_slope` 88 times `(γ + r + 2)⁴` times `4h² + cFarM m/h²` times
`π²/6`, plus `4h²·lowCount`.

What this closes. Rung 4b for the switched window. With `cFarM m` at most
`cfar_bound` 1000 times `(m+1)²` and `r` at most `1 + 5(m+1)/h`, the
whole on-line background is polynomial in `h`, `m` and `γ`. Unit 0333's
main term at the target is exponential in `h`. That is the gap the
assembly will use, the same shape as unit 0324's closing sentence with
the powers replaced by an exponential against a polynomial.

What remains of rung 5. The test-function proof for the switched window
(C¹), the split of the zero form's complex sum into on-line and off-line
parts, the count of off-line zeros in a band through the symmetry of the
order under reflection in the line, the selection of the target, the
alignment of the cluster, and the assembly. The window side of the
switch is done: nine modules, units 0326 to 0335.
