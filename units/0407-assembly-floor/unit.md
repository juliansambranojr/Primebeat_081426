---
id: 0407
date: 2026-11-22
type: formalization
title: "AssemblyFloor.lean: the explicit-formula assembly with its floor a parameter and nothing rounded, and the four proved pieces of the route composed into one theorem"
refs: [lean_stage3/Stage3/AssemblyFloor.lean::psiWeak_floor, lean_stage3/Stage3/AssemblyFloor.lean::schoenfeldWeak_floor_of_RH]
supersedes: []
follows: 0406
context: units 0404 to 0406 priced the explicit-formula route and found its constant is spent in the closing arithmetic of the assembly and in the choice of height; Julian chose to price the height and then restate the assembly with the height that wins, 2026-11-22
sealed: false
---

**Question.** Block E1 of `lean_stage3/design/joints.md`. Does the assembly go through with the floor as a parameter, the height just below the square of `x`, and each term kept at its own shape?

**What was proved.** `lean_stage3/Stage3/AssemblyFloor.lean`: `module_lines` 269 lines, `theorems_proved` 6 theorems and `defs` 1 definition, `sorries` 0 sorries, `pins` 2 axiom pins each at `axioms` 3 axioms. The first build had `errors_first` 3 error lines, one proof step and the two pins above it; clean on build `builds` 2. `Assembly.lean` is untouched. The package builds at `jobs_package` 8794 jobs, the module at `jobs_module` 8729. One row added to the traps, `traps_added` 1. Built under loop version `loop_version` 22; `steps_skipped` 2 steps of the loop were skipped, the orient hook, which a cloud session does not have, and the scratch pass. No hypothesis beyond the block's: `assumed_pins` 0.

`psiWeak_floor` takes the hypotheses of `psiWeak_of_RH_EF_NT` and a floor of at least `floor_min` 16, and concludes the `ψ` bound from that floor on with the constant `floorConst`. That constant has a leading `lead` 4 and four terms that fall as the floor rises: the band's numerals over the logarithm of the floor and over its square, the top-edge constant over the floor to the power three halves, and the left-edge constant over the square root of the floor times its logarithm. The height is the power of two between half the square of `x` and the square.

`schoenfeldWeak_floor_of_RH` composes the route, which no theorem did before: under RH there are two non-negative constants, those of `Glue.stmtEF_poly`, such that for every floor the bound on `π − Li` holds with one logarithm, with the band's numerals `band_b1` 112 and `band_b3` 698 in place, constant `pi_factor` 3 times `floorConst` plus `pi_offset` 13, from the square of the floor on.

**What it confirms.** Unit 0405's reading of the old proof: the contour constants never needed the square root, and the zero side never needed to be rounded to the square of the logarithm. Unit 0406's model had this same shape with slightly smaller coefficients on the zero side; the theorem's are the ones to price from now on.

**What it is not.** A numeral. The two constants of the explicit formula are still taken from an existence statement, and under them sit three quantities obtained from compactness. Nothing here touches the gate or the table.

What the next slice needs. The two explicit-formula constants as definitions, which means `Glue.explicit_formula_poly` and the lemmas under it restated with their constants named, and the three compactness quantities bounded by numerals; then the gate read on the shape with one logarithm.
