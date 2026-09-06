---
id: 0324
date: 2026-09-06
type: formalization
title: WeilOnLine.lean: negative heights by conjugation, the low band finite, and the on-line background bounded at all heights
refs: [lean_stage3/Stage3/WeilOnLine.lean::term_conj, lean_stage3/Stage3/WeilOnLine.lean::lowSet_finite, lean_stage3/Stage3/WeilOnLine.lean::tsum_onLine_le]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Rung `rung` 4b, second half, slice B3, the last. Unit 0323
bounds the on-line sum over heights at least `height_min` 11/10. The count's
window reaches neither the negative heights nor the low band. Can both be
closed, and the on-line background bounded at every height?

**What ran.** `lean_stage3/Stage3/WeilOnLine.lean`, new, `module_lines` 329
lines, imported from `Stage3.lean`. `errors_first` 0 errors on the first
build. Full package built, `jobs_package` 8745 jobs. `run/build.log` is the
record.

**What it shows.** `theorems_proved` 17 theorems and `defs` 7 definitions
(`conjZ`, `B`, `lowSet`, `lowU`, `lowCount`, `onLineBound`, `OnLine`), each
theorem pinned by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0 sorries.

Negative heights. `Psi_neg`: the transform `Ψ` is odd. `term_conj`: the
on-line term at the conjugate zero equals the term at the zero, since
conjugation flips the height and `Ψ` flips sign twice inside a square.
`conj_mem`: conjugates of nontrivial zeros are nontrivial zeros, by
Mathlib's `riemannZeta_conj`. `weightedTerm_conjZ`: the weighted term is
conjugation-invariant, the multiplicity by upstream's
`Kadiri.riemannZeta_order_conj`. `sum_lower_le`: a finite set of on-line
zeros of height at most `-11/10` conjugates injectively into one of height
at least 11/10, so unit 0323's bound `B h γ = A h γ·π²/6` applies to it too.

The low band. `lowSet_finite`: the on-line zeros of height at most 11/10 in
absolute value are finite. An accumulation point on the compact segment
would force `ζ` to vanish on the half-plane `Re z < 3/4`, which is convex,
so preconnected, and where `ζ` is analytic since the pole sits at 1; that
contradicts `ζ(0) = −1/2` (`riemannZeta_zero`). `lowCount` is their total
multiplicity, carried by name: its value is a computation this ladder does
not make. `sum_low_le`: the low sum is at most `4h²·lowCount`, each term by
unit 0320's near bound.

The assembly. `sum_onLine_le` splits any finite on-line set three ways by
height and adds the three bounds: `onLineBound h γ = 2·B h γ + 4h²·lowCount`.
`tsum_onLine_le`: the full weighted sum over all on-line zeros is at most
`onLineBound h γ` for `h > 0` and `γ ≥ 11/10`, and `summable_onLine` gives
summability of the on-line series, both from the finite-sum bound alone.
`onLineBound_le` puts it in `γ` and `h`:
`2·88·(γ+3)⁴·(4h² + cFar/h²)·π²/6 + 4h²·lowCount`.

What this closes. Rung 4b: the on-line background is bounded, explicitly,
by a quantity that grows as `h²`. Rung 5's main term, the square of the
off-line zero's own contribution, grows as `h⁴`. That gap in the power of
`h` is what the assembly will use.

What `lowCount` is. Mathematically 0: the lowest zero has height above
`first_zero_height` 14. Proving that in Lean is a numerical verification of
the kind this ladder does not attempt; the name keeps the dependence
visible.
