---
id: 0409
date: 2026-11-22
type: formalization
title: "GlueFloor.lean: the left edge of the explicit formula at its own size, the formula restated with that edge as its own term, and the floor assembly on the new statement"
refs: [lean_stage3/Stage3/GlueFloor.lean::edge_left_sharp, lean_stage3/Stage3/GlueFloor.lean::explicit_formula_split, lean_stage3/Stage3/GlueFloor.lean::psiWeak_floor_split, lean_stage3/Stage3/GlueFloor.lean::schoenfeldWeak_floor_split_of_RH]
supersedes: []
follows: 0408
context: unit 0408 priced the route from the theorem of unit 0407 and found one term, the left edge of the contour, carrying the whole constant; reading its proof showed the bound is a negative power of x inside the proof and is rounded to a logarithm at the end; Julian asked what the block was and then for it to be built, 2026-11-22
sealed: false
---

**Question.** Block E2 of `lean_stage3/design/joints.md`. Do the three restatements go through as copies with a different last line?

**What was proved.** `lean_stage3/Stage3/GlueFloor.lean`: `module_lines` 833 lines, `theorems_proved` 6 theorems and `defs` 2 definitions, `sorries` 0 sorries, `pins` 4 axiom pins each at `axioms` 3 axioms. `copies` 3 of the theorems are copies of existing proofs with the closing lines changed; `Glue.lean`, `Assembly.lean` and `AssemblyFloor.lean` are untouched. The first build had `errors_first` 3 error lines, one unknown lemma name and the two pins above it; clean on build `builds` 2, with the two long copied proofs passing unchanged. The package builds at `jobs_package` 8795 jobs, the module at `jobs_module` 8730. A line was added to the traps under Names, `traps_added` 1. Loop version `loop_version` 22; `steps_skipped` 2 steps skipped, the orient hook and the scratch pass, and the scratch pass is where the wrong name would have been caught. No hypothesis beyond the block's, `assumed_pins` 0.

`edge_left_sharp` is the proof of `edge_left_bound` stopped before its last two steps: the left edge is at most `edge_factor` 72 times a constant `D` times the square of the logarithm times `x` to the power minus one quarter.

`explicit_formula_split` is the truncated explicit formula with three terms on the right: the top and bottom edges as before, a multiple of the logarithm whose constant is now `c3_num` 13 plus half the value of the logarithmic derivative at zero, and the left edge at its own size. `StmtExplicitFormulaSplit` names that shape and `stmtEF_split` is the instance.

`psiWeak_floor_split` is unit 0407's assembly on the new statement, from a floor of at least `floor_min` 16. Its constant `floorConstSplit` is `floorConst` with the small logarithmic constant in the place of the old left-edge one, plus the left edge's constant times the floor to the power minus one quarter over its square root. `schoenfeldWeak_floor_split_of_RH` carries it to `π − Li` with one logarithm.

**What it confirms.** Block E2's reading: the left edge never needed to be a multiple of the logarithm. The constant that unit 0408 found carrying the whole bound is gone from the statement; what replaces it falls like the floor to the power three quarters.

**What it is not.** A numeral, and not yet priced: the estimate in block E2 was made before the theorem and is not a logged result. The constants are still taken from existence statements.

What the next slice needs. The gate priced from `floorConstSplit` as proved; then the constants as numerals, which needs the supremum on the short segment, the value at zero, the count of real zeros, the low count, and the compact patch in `ZetaGrowth.sq_zeta_band_bound`.
