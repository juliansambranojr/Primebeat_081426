---
id: 0416
date: 2026-11-22
type: formalization
title: "BoxBounds.lean: the compact patch bounded by a numeral, the band bound with its constant named, and the ratio of zeta at three and at three halves bounded below"
refs: [lean_stage3/Stage3/BoxBounds.lean::sq_zeta_box, lean_stage3/Stage3/BoxBounds.lean::sq_zeta_band_explicit, lean_stage3/Stage3/BoxBounds.lean::zeta_ratio_ge]
supersedes: []
follows: 0415
context: block E7 laid out four quantities the route's constants take from existence statements and a route to each from what the tree holds; Julian chose to build it, 2026-11-22; this unit is the two short sub-blocks, E7a and E7b
sealed: false
---

**Question.** Sub-blocks E7a and E7b of `lean_stage3/design/joints.md`. Is the bound on the compact patch a numeral under the one already used for large heights, and is the ratio of zeta values in the partial fraction bounded below by a numeral?

**What was proved.** `lean_stage3/Stage3/BoxBounds.lean`: `module_lines` 210 lines, `theorems_proved` 6 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 2 error lines, a redundant tactic and the pin above it; clean on build `builds` 2. The package builds at `jobs_package` 8800 jobs, the module at `jobs_module` 8721. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`sq_zeta_box`: on the box where the real part runs from minus one half to four and the height is at most two, the pole-cleared zeta is at most `box_bound` 135 in norm. The proof uses the continued Euler–Maclaurin form at its first level, where the function is one half plus a tail term, with the pole's term cancelling against the cleared factor; its own arithmetic reaches `proof_bound` 132. Block E7's hand figure was `hand_estimate` 89; the proof uses rounder bounds on the three norms and still lands under the target.

`sq_zeta_band_explicit`: on the whole band, the pole-cleared zeta is at most `box_bound` 135 times the fourth power of two plus the height. This is `ZetaGrowth.sq_zeta_band_bound` with no compactness: the constant there was the larger of this numeral and an unnamed supremum, plus one.

`norm_zeta_three_halves_le`, `one_le_norm_zeta_three`, `zeta_ratio_ge`: zeta at three halves is at most seven halves in norm, zeta at three is at least one, and so their ratio is at least `ratio_lo` 2/7.

**What it settles.** Two of block E7's `unnamed_before` 4 quantities are numerals; `unnamed_after` 2 remain, the count of zeros below height six and the supremum on the short segment. Neither numeral is wired in: `EdgeBound.gz_partial_fraction` still takes its two inputs from the existence statement and the bare norm.

What remains. E7c and E7d, each a copy of an existing long argument at bounded height, and then the constants of the explicit formula as definitions.
