---
id: 0460
date: 2026-11-23
type: formalization
title: "The left edge bounded at every height: the explicit formula with no cap and no logarithm of the height"
refs: [lean_stage3/Stage3/LeftSmooth.lean::smooth_side, lean_stage3/Stage3/LeftSmooth.lean::left_edge_bound, lean_stage3/Stage3/LeftSmooth.lean::explicit_formula_all]
supersedes: []
follows: 0459
context: unit 0457 named the square of the logarithm of the height as the factor the left edge loses; unit 0459 bounded the Dirichlet-series half of the edge free of the height; this is blocks F2c and F2 of `lean_stage3/design/leftedge.md`
sealed: false
---

**Question.** Blocks F2c and F2 of `lean_stage3/design/leftedge.md`. Is the left edge of the explicit formula's contour bounded free of the height, so that the formula holds at every height with no logarithm of the height in its last term?

**What was proved.** `lean_stage3/Stage3/LeftSmooth.lean`: `module_lines` 912 lines, `theorems_proved` 40 theorems, `defs` 0 definitions, `sorries` 0 sorries, `pins` 3 axiom pins. The first build had `errors_first` 8 error lines; clean on build `builds` 11. The package builds at `jobs_package` 8850 jobs, the module at `jobs_module` 8738. Traps unchanged, `traps_added` 0; `assumed_pins` 0; loop version `loop_version` 22, `steps_skipped` 2 steps skipped as before.

`explicit_formula_all`: for a doubling at least `floor_x` 16 and every height at least `floor_T` 2, the Chebyshev function less the doubling plus the sum over the zeros below the height is within the tree's first term, which falls with the height, plus a constant times the logarithm of the doubling, plus the constant `Bleft` over the fourth root of the doubling. The height carries no cap and the last term carries no height.

`left_edge_bound`: the left edge of the contour at any height at least `floor_T` 2 is at most `Bleft` over the fourth root of the doubling.

`smooth_side`: the same for the half of the edge that the functional equation leaves beside the Dirichlet series, with constant `Bsm`. `Bleft` is `Bsm` plus the `Bser` of unit 0459.

How. On the line of the left edge the functional equation writes the logarithmic derivative of zeta as a smooth function less the logarithmic derivative at the reflected point (`logDeriv_sum`). The smooth function is the logarithm of twice pi, less the digamma function at the reflected point, plus a multiple of a tangent. Over the variable it splits into `pieces` 3 pieces. The constant piece is the kernel of unit 0459. The digamma piece is a series of reciprocals by the digamma series; sum and integral are exchanged and each term is a kernel bounded free of the height (`kernel_conj`, `digamma_piece`). The tangent piece is integrated by parts against the turning power; its derivative falls like the reciprocal of the square of the height because the cosine of a complex angle is at least the size of its imaginary part (`tan_piece`). No derivative of the digamma function is used.

**Who wrote it.** An Opus worker, from a brief with the statements and a route; it found the termwise route for the digamma piece, which the design had not. Here the file was searched for `sorry`, added axioms and `native_decide`, of which it has none; each pin reads the standard three axioms; and it was built in the package.

**What it says.** The factor unit 0457 named is gone. The tree's explicit formula holds at every height, and as the height grows the error falls to a constant times the logarithm of the doubling. The cap at the square of the doubling, which every use of the formula in the tree has carried, was the price of an absolute value on a single line of the contour.

What remains. Block F3: the cell at a fixed row, through the stencil.
