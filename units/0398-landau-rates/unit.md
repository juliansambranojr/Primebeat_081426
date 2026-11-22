---
id: 0398
date: 2026-11-22
type: formalization
title: "LandauRates.lean: the inequality between the two tail rates, the choice of the centre, and a decay lemma; block 7c of the Landau worksheet"
refs: [lean_stage3/Stage3/LandauRates.lean::key_ineq, lean_stage3/Stage3/LandauRates.lean::exists_centre, lean_stage3/Stage3/LandauRates.lean::exists_pow_small]
supersedes: []
follows: 0397
context: the third part of the assembly of the Landau window criterion; the design in the worksheet had the rate inequalities checked on a numeric grid only, and unit 0391 had recorded an earlier hand computation of them
sealed: false
---

**Question.** Block `7c` of the Landau worksheet (`landau.md#7c`). Do the two tails of the primes' integral leave room for a range of indices on which both are small, and is there a centre at which the zeros' rate beats the window's?

**What was proved.** `module_lines` 113 lines, `theorems_proved` 3 theorems, `defs` 0 definitions, `pins` 3 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`key_ineq`: for `0 < δ ≤ 1` and `0 ≤ λ ≤ δ²/lam_bound` with `lam_bound` 240, `4(λ − log(1−δ/12)) < (1+δ)(log(1+δ/3) − λ)`, and both parentheses are positive. Here `λ` is the logarithm of the ratio of the zeros' distance to the trivial rate, and the two logarithms come from shifting the exponent by `a·δ/shift_below` below the window, `shift_below` 3, and by `a·δ/shift_above` above it, `shift_above` 12. The inequality says the index range on which the lower tail is small and the one on which the upper tail is small overlap.

`exists_centre`: for a point `ρ₀` with `0 ≤ θ < Re ρ₀ < 1` and `δ > 0` there is a real `σ₀ > 1` with `|σ₀ − ρ₀| < σ₀ − θ` and `|σ₀ − ρ₀| ≤ (σ₀ − 1)(1 + δ²/240)`. `exists_pow_small`: a constant times `q^k` with `0 ≤ q < 1` is eventually below any positive number.

**What is and is not here.** The proof of `key_ineq` uses one fact about the logarithm, `log y ≤ y − 1`, twice. Nothing in the module mentions `ζ` or `G`.

The worksheet's design fixed a range of indices and checked two brackets. This unit proves the single inequality that the existence of such a range needs, and the range is left to be chosen from it. The rates recorded by hand in unit `unit_tails` 0391 were for another choice of shifts; they are not used.

**The build.** `errors_first` 0 error lines on the first build, `builds` 1 build, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 8655 jobs, package at `jobs_package` 8789. `steps_skipped` 2 steps of the loop, the orient hook and the scratch pass. Loop version `loop_version` 22.

What the next slice needs. The criterion: from a zero to the right of `θ` and the window bound, the centre of this unit, the lower bound of unit 0397 and the upper bound of unit 0396, with the range of indices chosen from `key_ineq`.
