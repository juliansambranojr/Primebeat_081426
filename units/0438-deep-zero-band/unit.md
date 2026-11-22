---
id: 0438
date: 2026-11-22
type: formalization
title: "DeepZeroBand.lean: the deep zero and its composite inverse are the two edges of the band; the mirror on shares is x to 1 - x"
refs: [lean/DeepZeroBand.lean::share_mirror, lean/DeepZeroBand.lean::deep_zero_on_outer_circle, lean/DeepZeroBand.lean::deep_zero_inverse_on_inner_circle, lean/DeepZeroBand.lean::share_pair_product]
supersedes: []
follows: 0437
context: Julian asked, 2026-11-22, whether there is a theorem about the inversion of the deep zero where it becomes a band; the tree had the inversion and the band for the zeros of the table's symbol, and the composite cell at the deep zero, with nothing joining them; he asked for the join built
sealed: false
---

**Question.** The cell at the deep zero is zero on the prime side. What is it on the composite side, and where do the two sit in the band that `lean/Transform.lean` draws between its outer and inner circles?

**What was proved.** In the table's tree, toolchain `toolchain` 4.28.0: `lean/DeepZeroBand.lean`, `module_lines` 214 lines, `theorems_proved` 14 theorems, `defs` 2 definitions, `sorries` 0 sorries, `pins` 14 axiom pins, clean on build `builds` 1 with `errors_first` 0 errors. The module builds at `jobs_module` 8032 jobs, the tree at `jobs_tree` 8057; its index reads `theorems_lean` 359 theorems across `modules_lean` 31 modules. The welds: `welds` 11, `broken_welds` 0 broken.

The share. A cell divided by its total, a power of two. `share_add`: at every cell the prime share and the composite share add to one. It is the pair identity of the tree, divided through. `share_mirror`: so passing from the prime table to the composite table is the reflection that sends a share to one minus it. `share_eq_iff_half`: the two shares are equal exactly at one half.

The deep zero. `composite_cell_20_6`: the composite cell there is `composite_total` 8192, the whole total, computed by the kernel. `deep_zero_share`, `deep_zero_inverse_share`: the prime share is zero and the composite share is one.

The band. `Transform` sends an exponent to a point of the plane and draws three circles: the outer one, where the zeros of the table's own symbol land; the inner one, their inversion; the middle one, the line. `deep_zero_on_outer_circle`: the deep zero's share lands on the outer circle. `deep_zero_inverse_on_inner_circle`: its composite share lands on the inner one. So the deep zero and its inverse are the two edges of the band. `share_pair_product`: at every cell the two images multiply to the same constant, as a point and its inversion partner do. `share_on_middle_circle_iff`: an image is on the middle circle exactly at share one half.

Inside and outside. `share_in_band`, `band_in_annulus`: a count and its complement, both nonnegative, have shares between zero and one, and such a share lands in the closed band. At depth zero both are counts. A differenced cell can leave: `deep_cell_15_6` computes the cell at row `out_row` 15 and depth `out_depth` 6 as `out_cell` -112, and `share_15_6_neg` puts its share below zero.

**What it says.** The table carries the reflection about one half in its own arithmetic: primes and composites split each total, and exchanging them is that reflection. The deep zero is the cell where the split is all on one side.

What remains. A share is a real number made from the table. Nothing here identifies it with the real part of a zero of zeta; the reflection and its fixed point are what the two have in common.
