---
id: 0512
date: 2026-11-24
type: decision
title: "The wall on the ψ ladder: every general route loses a factor exponential in the zero count; a separation bound on the top zeros would close it"
refs: [lean_stage3/Stage3/ResidueRoute.lean::isolated_boundary_mode_false, lean_stage3/Stage3/ReachRoute.lean::reached_mode_false, lean_stage3/Stage3/LadderFading.lean::not_tendsto_powerSum, lean_stage3/Stage3/AliasClass.lean::alias_weight_ne_zero]
supersedes: []
follows: 0511
context: after the reach route, the open arrangement on the ψ ladder was a limit set that walls the modes off from zero; Julian asked for the wall, then the Turán rescue, then its two checks, 2026-11-24; this is block S7 of `lean_stage3/design/stencil.md`, rounds two and three
sealed: false
---

**Question.** On the ψ ladder, under H, can the power sums of the zeros near the top real part stay at the size H allows when the top is never reached and the modes wall themselves off from zero?

**What ran.** Nothing was computed. This unit records derivations on paper in block S7 of `lean_stage3/design/stencil.md`, made here and unchecked by anyone else, and a literature search of `searches` 5 queries that found no theorem on the doublings alone. EXPLORATORY: no prereg, no verdict.

**Turán.** Take the zeros right of a line below a height: finitely many, their top attained among them. Turán's power sum method bounds their normalized sum below on a window, at a loss of a fixed factor per zero. The errors from H and from the zeros left of the line are beaten by a long shift. The zeros above the height are not: their real parts can exceed the finite set's top, and their weight falls only by the density saving, a power of the height. The loss grows exponentially with the number of zeros in the set, and the saving is a power. That is a lost factor that grows with the parameter.

**The rescue and its two checks.** The Montgomery–Vaughan mean value theorem replaces Turán's loss by the inverse of the least angular separation of the top modes, with no power of their number. It survives the radial factors of the modes inside the circle by banding the modes near the top, at a cost polynomial in the band's count and a logarithm of the top weight. The alignment of the weights, all close to minus i over the height for zeros above the axis, makes a near-alias cluster act as one heavy mode, but only at shifts below the inverse of its diameter. The shift the bound needs is longer, and every general way to choose the clusters, or to align every phase at once, costs a factor exponential in the zero count again.

**The lost factor, named.** Without a lower bound on how close the top zeros come to the alias lattice, every route found loses a factor exponential in the number of zeros near the top, against a power of the height. With a separation bound polynomial in the height, the banded mean value step closes the wall at every height whose creep, the gap between the top real part and the largest real part attained below that height, is small against the separation times the logarithm of the height over the square root of the band's count.

**The decision.** The route through general bounds on power sums is closed: the steps are right and the design is wrong. The design question for the wall is now the separation of the top zeros from the alias lattice, which is a property of the zeros of zeta, as unit `unit_obstruction` 431 said. The isolated, reached and finitely accumulating arrangements are closed in Lean (units `unit_residue` 508, `unit_reach` 511). H stays an input.

**What it is not.** No Lean, no run, no independent check. It does not test the Riemann hypothesis.
