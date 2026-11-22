---
id: 0418
date: 2026-11-22
type: formalization
title: "LowEdge.lean: the logarithmic derivative of zeta on the short segment bounded by a numeral, from the partial fraction at low heights"
refs: [lean_stage3/Stage3/LowEdge.lean::logDerivZeta_short_segment, lean_stage3/Stage3/LowEdge.lean::gz_partial_fraction_low, lean_stage3/Stage3/LowEdge.lean::low_ball_count_wide]
supersedes: []
follows: 0417
context: block E7 of the joints worksheet, sub-block E7d, the last of the four; units 0416 and 0417 gave the numerals it consumes; Julian chose to build E7, 2026-11-22
sealed: false
---

**Question.** Sub-block E7d of `lean_stage3/design/joints.md`. Is the supremum of the logarithmic derivative on the left edge at low heights, which the left-edge bound takes from compactness, bounded by a numeral?

**What was proved.** `lean_stage3/Stage3/LowEdge.lean`: `module_lines` 499 lines, `theorems_proved` 4 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms, clean on build `builds` 1 with `errors_first` 0 errors. `copies` 2 of the proofs are existing ones with the height bounded above in place of below and the numerals changed; `EdgeBound.lean` is untouched. The package builds at `jobs_package` 8802 jobs, the module at `jobs_module` 8724. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`low_ball_count_wide`: at heights between zero and two, the zeros of the pole-cleared function in the partial fraction's ball number at most `wide_count` 250 with multiplicity.

`gz_partial_fraction_low`: at those heights, the logarithmic derivative of the pole-cleared function minus its sum of simple poles over that ball is at most `pf_bound` 1617537 in norm.

`logDerivZeta_low_edge` and `logDerivZeta_short_segment`: on the line with real part minus one quarter, at heights of absolute value at most two, the logarithmic derivative of zeta is at most `mc_bound` 1620000 in norm. Every zero in the ball and the pole are at distance at least one quarter from that line, so the sum of simple poles is at most four times the count; the lower half follows by conjugation.

**The size of the numeral.** It is of the order of the existing edge constant because it uses that proof's radii, whose cube of a gap unit 0405 named. Nothing here depends on it being small: unit 0410 found a factor of tens of thousands of slack in the constants this feeds.

**What it settles.** Every quantity block E7 listed as taken from an existence statement or from compactness now has a numeral proved for it: `unnamed_after` 0 remain, against `unnamed_before` 1 before this unit. None is wired in. The explicit formula's constants are still handed out under an existential, by proofs that call compactness; what exists now is every input a restatement would need.

What remains. The restatement: the edge constant, the left-edge constant and the explicit formula's three constants as definitions with these numerals, each a copy of its proof with the existence step replaced by the lemma proved here. Then the route's theorem states a constant that is a number.
