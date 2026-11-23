---
id: 0449
date: 2026-11-23
type: decision
title: "Zero-density block C1 loses a factor that grows with the length: the mean value must charge each term its own index"
refs: [lean_stage3/Stage3/DirichletMean.lean::dirichlet_mean_value_window, lean_stage3/Stage3/Mollified.lean::sum_coef_sq_weighted_le, lean_stage3/Stage3/ZetaEM.lean::norm_zeta_sub_partial_le]
supersedes: []
follows: 0448
context: `lean_stage3/design/carlson.md` splits a zero-density bound into blocks; before block C4 was built the sizes were worked through again on the statements of blocks C1 to C3 as proved, 2026-11-23
sealed: false
---

**Question.** With blocks C1, C2 and C3 proved as stated, does block C4 come out below the first power of the height?

**What ran.** `run/record.json` holds the counts written here. Nothing was computed. This unit is a size check on paper of `record.blocks_proved` 3 statements, units `record.unit_c1` 0446, `record.unit_c2` 0447 and `record.unit_c3` 0448. EXPLORATORY: no prereg, no verdict.

**The factor.** Block C1 bounds the mean square of a finite Dirichlet sum by the length of the stretch of heights, plus a constant times the length of the sum times its logarithm, all times the sum of the squared coefficients. The length of the sum is charged to every term. In block C4 the sum is zeta's finite sum times the short Möbius sum, its length is the product of the two lengths, and its coefficients fall off like a power of the index. Charged the full length, the terms near the start cost as much as the terms at the end. The bound comes out as the first length times a power of the second, which is above the first power of the height at every real part. The classical statement charges each term its own index, and then the same sum is the product of the lengths to a power below one. The ratio of the two grows with the length.

**What it is.** A design failure in the statement of block C1. The proof of unit `record.unit_c1` 0446 is correct and stays.

**The repair.** `record.new_blocks` 2 additions to the design. Block C1b: the mean value with each coefficient charged its own index. It is elementary: the same double sum, with the symmetrising step weighted by the reciprocal of the index, and row sums at most `record.row_const` 6 times the index times one plus the logarithm of the length. Block C2b: the squared coefficients of the mollified sum weighted by the index to one minus twice the real part, summed up to a point; by dyadic blocks it is the point to a power below one, times logarithms.

**Checked again with the repair.** The three parts of block C4 then are: the mollified sum, below the first power for a short Möbius sum and a length a small power above the height; the smooth term times the Möbius sum, likewise; the Euler–Maclaurin error times the Möbius sum, far below. No other block of the `record.blocks` 7 is changed.

**Decision.** Block C1b is being built. Block C4 waits for it.
