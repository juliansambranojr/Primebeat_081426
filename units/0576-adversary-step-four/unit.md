---
id: 0576
date: 2026-11-26
type: decision
title: "An adversary review of the plan to the goal: step 4, no right zeros of V, is the Riemann hypothesis restated, and the basin floor cannot see a zero"
refs: [lean_stage3/Stage3/BasinChainCount.lean::noRightZeros_one_of_rh, lean_stage3/Stage3/BasinChainCount.lean::W_one, lean_stage3/Stage3/BasinChain.lean::rh_of_noRightZeros]
supersedes: []
follows: 0574
context: Julian asked for a search and an adversarial test of the seven steps to the goal; a fresh agent was given the plan and the code and none of the assistant's conclusions, in block S15 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** Which steps of the plan from the tree to the Riemann hypothesis survive an adversary?

**What ran.** One agent, briefed with the plan verbatim and pointers to the code, told to break it and to give a receipt with every finding. Its winding scans are in `run/`, copied in as produced, with `run/vlib.py` holding both versions of V. It could not open the papers it named; its literature points are marked from memory in the transcript. EXPLORATORY: no prereg, no verdict.

**Findings.**
- The core step, no right zeros of V, is the Riemann hypothesis restated. For Q equal to one, `W_one` makes V the zeta function, and the hypothesis is the Riemann hypothesis from a height on. For Levinson's Q, W is Lambda over two plus its derivative over L. Under the Riemann hypothesis, a function with real zeros minus i c times its derivative has all its zeros on one side, and here that side is left of the line, at every height and every L. So the Riemann hypothesis gives the hypothesis, and the chain gives the converse. The chain is a Speiser-type equivalence for W, proved in Lean.
- A mollifier cannot move the zeros of V. V has no mollifier in it, and the zeros of V times psi are those of V and those of psi. Unit 0562 counted `zeros_right_short` 2 right zeros at the shortest mollifier length and `zeros_right_long` 2 at the longest.
- The floor points the wrong way. In Littlewood's formula zeros raise the integral of the log on the left edge, so only an upper bound limits them, and a larger mean lowers kappa. Reflecting a zero in the line through sigma naught leaves the modulus on that line unchanged, so no functional of the modulus on that line sees the side a zero lies on.
- One basin cannot see one zero. The design already found this (`lean_stage3/design/stencil.md`, "So the local Levinson count cannot see one zero").
- Unit 0572 measured a different function from the Lean V. Unit 0575 records the zero it found and where that zero sits for the Lean V.
- Levinson's Lean V, scanned by adaptive winding on the stretch at five thousand: `lean_scan_total` 0 zeros right of the line (`run/scan_lev_lean.out`).

**The decision.** The core step and the sub-steps built on the basin floor are withdrawn as a route. The point run, the lower side of J, the averaging, the evenness step and `rh_iff_defect_zero` stand as logic. The count over a fixed range stands with edge bounds re-proved uniformly in L, and it rests on the core step. The core of a route to the goal has to be a statement outside this family: one whose size can see a single zero, or one that is not a mean square.

What remains. Name that core. Restate the coupling picture as an upper bound with that size, or as a statement of another kind.
