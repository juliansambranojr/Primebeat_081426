---
id: 0431
date: 2026-11-22
type: decision
title: "Joint 10 on one ladder, the general case: where it stops and why"
refs: [lean_stage3/Stage3/LadderFading.lean::not_tendsto_powerSum, lean_stage3/Stage3/LadderMean.lean::mean_extract, lean_stage3/Stage3/AliasClass.lean::alias_weight_ne_zero]
supersedes: []
follows: 0430
context: joint 10 on the table's own ladder asks whether square-root size of the one ladder's cells gives the Riemann hypothesis; the finite case was proved; Julian asked for the general case, 2026-11-22
sealed: false
---

**Question.** With infinitely many zeros of zeta off the line allowed, does a square-root bound on the cells of the one ladder force them all onto the line? Where does the argument stop?

**What ran.** `run/record.json` holds the counts written here. Nothing was computed. This unit is a derivation on paper and a reading of `record.pieces_built` 3 modules built the same day. EXPLORATORY: no prereg, no verdict.

**The reduction.** Write the residual of the log-weighted count on the rung as its sum over the zeros below a height, with the explicit formula's error. Fix a real part above one half. The zeros to its left contribute at most that power of the rung times the zero count. For the zeros to its right, a zero-density estimate with a power saving makes the sum of multiplicity over modulus converge, so their part is an absolutely summable sum of modes. A square-root bound on the one ladder then forces that summable sum of modes to be small against the chosen power.

**The obstruction.** For finitely many modes, smallness forces every weight to zero (unit `record.unit_finite` 0430). For infinitely many it does not follow. Summable families of modes with nonzero weights exist whose sum is zero at every row: the series of Wolff and Denjoy. They need the modes to accumulate. So the sentence "every zero is present with nonzero weight, hence the cells cannot stay small" is false as a general principle, and the pole of the row's generating function at one zero is no contradiction when poles accumulate at it.

**The cases.** `record.cases` 3 cases.

Finitely many zeros off the line. Closed by unit `record.unit_finite` 0430 together with the zero count; the assembled statement is not yet written.

The largest real part is attained. One line dominates. On it the folded classes have weights with positive real part (unit `record.unit_alias` 0429), and averaging along the rows shows that a summable sum of rotations cannot fade unless every folded class has weight zero (unit `record.unit_mean` 0432). So this case closes, given the summability.

The largest real part is not attained. Zeros approach a line without reaching it and no line dominates. Averaging has nothing to normalise by, and the generating-function argument meets the obstruction above. No argument is known to me for this case. Closing it would need a property of the zeros of zeta themselves, beyond their count.

**What is not in the tree.** `record.inputs_missing` 2 inputs: a zero-density estimate with a power saving, and the truncated explicit formula at heights above the square of the rung. `record.searches` 2 literature searches on 2026-11-22 found no statement of the one-ladder converse in either direction.

**Decision.** None taken. The choice of what to build next is Julian's. Joint `record.joint` 10 on the one ladder stays open, with its open part now named: the case where the largest real part is not attained.
