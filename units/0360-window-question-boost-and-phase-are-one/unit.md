---
id: 0360
date: 2026-09-07
type: decision
title: "The window question answers no: the boost that makes an off-line zero detectable is the same parameter that equidistributes the other off-line zeros' signs"
supersedes: []
follows: 0359
refs: [none]
context: sections 9 and 13 of the rung 5 worksheet both died of one cause, and the reply to what route remained was to stop fixing phases after the fact and design the window instead; pricing that question closes it, and the reason it closes explains both earlier deaths
sealed: false
---

**Question.** Sections `nine` 9 and `thirteen` 13 died of the same thing: an off-line zero contributes twice the real part of the square of the window's transform, the sign of that turns on a phase, and the other off-line candidates can cancel the target. Section `fourteen` 14 asks the design question instead. Is there a window for which the sign never turns, so every off-line zero helps and none can cancel?

**What ran.** `run/window_price.py`, output in `run/window_price.log`. No Lean. Unit `unit_phase` 0347 proves the transform factors as a constant times the argument times the exponential of the argument squared against a tail sum, with a controlled error, and the factorization comes from the window's product shape, so it holds for any window of that shape with its own tail sum. The window enters only through that one number. The script sweeps it and the support over the box and measures where the sign is wrong.

**What it shows.** No, in both the strong form and the weak one, and the reason is worth more than the answer.

Strong form. The phase is the argument of the zero's offset plus twice the real part times the offset times the support squared times the tail sum. As the offset goes to zero the first term goes to zero and so does the second, so the cosine goes to one: a zero at the target's own height always hurts, for every window and every support. So no window makes the sign fixed over the box.

Weak form, which is the one that looked promising. The bad set's first stripe does shrink, like the reciprocal of the tail sum times the support squared, and the threshold at which it falls below the average zero gap grows only linearly in the window's slope and in the log of the height. That reading is wrong, and the script's fourth section is where I caught it. The phase does not stop at the first crossing; it keeps turning, so the bad set is not a neighbourhood of zero but a union of stripes. Its measure over the box tends to `bad_fraction_limit` 0.5: at a sweep rate of a hundred it is `bad_fraction_X100` 0.5051 of the box, at a million it is `bad_fraction_X1e6` 0.5 with stripes `stripe_width_X1e6` 1.57e-06 wide. Making the stripes finer does not make them fewer. Half the possible positions of another off-line zero hurt, at every window and every support.

**Why, and this is the finding.** The boost and the phase are one object. The transform carries the exponential of the argument squared against the tail sum. Its modulus is the exponential of the real part of that, which is the boost that makes an off-line zero visible above the background. Its argument is the imaginary part of the same thing, which is the phase whose turning equidistributes the signs. One tail sum sets both, at the same rate: the log of the boost is the real part's coefficient times the sweep, and the phase per unit offset is twice the real part times the same sweep. Asking for a bigger boost is asking for a faster sweep, in the same breath.

Setting the tail sum to zero removes the sweep. The sign then reads off the offset against the real part, fixed rather than oscillating, which is what the design question wanted. It also removes the boost, so the target no longer beats the on-line background, and detection fails at the other end. The two requirements are not merely hard to satisfy together; they are the same parameter pulled in opposite directions.

That explains all `deaths` 3 deaths at once. Section `nine` 9 tried to align the phases by choosing the support and needed a range exponential in the number of candidates. Section `thirteen` 13 tried to average them away over a range and found the range that beats the background is the range that kills the members' decay. Both were fighting the sweep with the support, and the sweep is what the support buys.

**Decision.** Sections 9, 13 and 14 are dead, `sections_dead` 2 of them by size and this one by structure. The detection method, as the worksheet frames it — one window family, one target zero, the other off-line zeros to be controlled — does not work, and the reason is an identity, in one line each, about the modulus and the argument of one exponential. That belongs in `papers/What-Didnt-Work.md` beside the two dead arguments already recorded, written up with this unit's numbers.

The `modules_standing` 9 Lean modules stand and are not part of the loss. Each is a statement about the switched window with the member, the count and the sequence abstract: the exact off-line factorization, the tail sum to order one over the support at any slope, the geometric and harmonic sums for an affine exponent, one member's weighted sum by explicit constants, the near members' sign, the clean-shell pigeonhole and the short-interval count leaf with its budget and its literature route. The last two are about counting and shells rather than about zeta and serve any argument that needs one clean slot out of many.

What remains is Julian's call and it is not a repair to this route. The identity says a real test function whose transform has a Gaussian factor cannot separate one off-line zero from the rest. What it does not say is that no test function can, and it says nothing about a family of test functions read together rather than one at a time. Pricing that is a fresh start, not a section of this worksheet, and it wants its own motivation entry before any Lean.
