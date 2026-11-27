---
id: 0582
date: 2026-11-26
type: result-triage
title: "A seeing problem: every apparent off-line zero of zeta in the tree was an error of the instrument, and Turing's method removes the error up to a height"
refs: [lean_stage3/Stage3/TuringRun.lean::rh_up_to, lean/Nyquist.lean::nyquist_no_go, lean/Construction.lean::unique_of_isTableOf]
supersedes: []
follows: 0581
context: Julian, "It's a seeing problem not off the line"; this reads the tree's own apparent off-line zeros of zeta against that
sealed: false
---

**Question.** In this tree, has any apparent off-line zero of zeta survived a second look, and what removes the error of seeing?

**What ran.** No run. A reading of unit 0572, unit 0575, unit 0580 and three theorems. EXPLORATORY: no prereg, no verdict.

**The errors of seeing.**
- Unit 0572 counted a zero right of the line near height five thousand. Unit 0575 found its script measured a different function from the Lean V; for the Lean V the same zero sits left of the line.
- Unit 0580's first run lost whole turns of the winding above height one hundred, because its edges started too coarse, and gave a count that fell. Its second run counts correctly.
- One base cannot resolve the first zero, `nyquist_no_go`: a limit of the instrument.

None of these is a zero of zeta off the line.

**The cure up to a height.** Turing's method closes the count with Littlewood's bound, so nothing can go unseen below the closing height: `rh_up_to` proves every zero of zeta on the line up to the point run's height.

**Determinism.** Julian, the same day: "if we can prove the future is encoded from its past like the pascal in the table is deterministic it can't be off the line". The table is deterministic: `unique_of_isTableOf`, fix the row and every cell is forced, with no axioms. The zeros of zeta are fixed by the primes through the explicit formula. Where the table's arms vanish is still open in `lean/Zeros.lean`, as `lean/PairIdentity.lean` records, so determinism fixes the answer without yet saying it.

What remains. One instrument that sees at every height at once, unit 0574's count over a fixed range carried to every height.
