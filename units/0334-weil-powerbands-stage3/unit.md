---
id: 0334
date: 2026-09-06
type: formalization
title: "WeilPowerBands.lean: the switched window's on-line background over the upper heights, bands, tiles and the explicit band series, with the far constant polynomial in m"
refs: [lean_stage3/Stage3/WeilPowerBands.lean::term_le_M, lean_stage3/Stage3/WeilPowerBands.lean::cFarM_le, lean_stage3/Stage3/WeilPowerBands.lean::tsum_upper_le_explicit]
supersedes: []
follows: 0333
sealed: false
---

**Question.** Rung `rung` 5, seventh slice. Units 0321 to 0323 bounded
the on-line background of the raised-cosine window over the heights at
least `height_min` 11/10, and their statements name that window's test
function, so they cannot be reused as they stand. Does the same chain go
through for the switched window, and is the far constant, which carries
`cS m` with its factorials, still polynomial in `m`?

**What ran.** `lean_stage3/Stage3/WeilPowerBands.lean`, new,
`module_lines` 488 lines, imported from `Stage3.lean`. `errors_first` 3
errors on the first build, `errors_second` 1 on the second: a scalar
identity that `norm_num` turned into a disjunction, a namespace not
opened, and a tactic left after its goal closed. Full package built,
`jobs_package` 8752 jobs. `run/build.log` is the record.

**What it shows.** `theorems_proved` 21 theorems and `defs` 6 definitions
(`termW`, `weightedTermW`, `r`, `cFarM`, `M`, `A`), the pinned theorems
by `#guard_msgs` to `axioms` 3 axioms, `sorries` 0 sorries.

The chain. `termW` is the real part of the zero form's term at the
switched window, `weightedTermW` that times the multiplicity, nonnegative
on the line by unit 0332. `band_sum_le`, `sum_by_bands`,
`sum_le_bandSeries` and `tsum_upper_le` are units 0321's and 0322's proofs
with the term replaced.

The wider near band. Unit 0332's far bound needs the height gap times `h`
to be at least `√2·π(m+1)`. Read off the band gap, that is `|k − k₀|`
above `r h m`, the larger of 1 and `near_mult` 5 times `(m+1)/h`. So `M`
takes the near bound `near_coeff` 4 times `h²` within `r` of the band of
`γ` and the far bound beyond (`term_le_M`).

The far constant. Beyond `r` the far term is at most `h²·cS²` times
`(2/(h·gap)²)` to the power `2m+2`. With the gap at least `9/10` of the
band gap times `h`, and that at least `5(m+1)`, this is
`cFarM m / (h²·|k − k₀|⁴)` with `cFarM m` equal to `cS m²` times
`(200/81)²` times `(10(m+1)²)` to the power minus `2m`. `cFarM_le`: that
is at most `cfar_bound` 1000 times `(m+1)²`, by `(2m+1)!` at most
`(2m+1)` to the `2m+1` and `π⁴` below `pi4_bound` 100. The power `2m`
absorbs the factorials in `cS`.

The series. `A h γ m` is `weight_slope` 88 times `(idx γ + r + 2)⁴`
times `4h² + cFarM m/h²`. `bandTerm_le_A`: each band term is at most
`A/(k+1)³`, unit 0323's argument with `K + 3` replaced by `K + r + 2`.
`bandSeries_summable`, `bandSeries_le`: the series is summable and at
most `A·π²/6`. `tsum_upper_le_explicit`: the upper on-line sum is at most
`88·(γ + r + 2)⁴·(4h² + cFarM m/h²)·π²/6`.

What this closes. The on-line background of the switched window over the
upper heights is bounded by a quantity polynomial in `h`, `m` and `γ`.
That is the fact unit 0331's crude series could not give and unit 0333
noted the assembly needs: the background is polynomial against a main
term exponential in `h`.

What the next slice does. The negative heights by conjugation and the
low band by unit 0324's finite set, then the assembly over all heights,
unit 0324 with the term replaced.
