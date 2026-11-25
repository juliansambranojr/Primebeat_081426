---
id: 0535
date: 2026-11-25
type: decision
title: "Two integrations by parts close the off-diagonal of the twisted moment only for short mollifiers; the number must grow with the length"
refs: [lean_stage3/Stage3/TwistedMoment.lean::offSum_bound, lean_stage3/Stage3/TwistedMoment.lean::offdiag_term_young, lean_stage3/Stage3/ApproxDeriv.lean::VY_deriv_bound]
supersedes: []
follows: 0534
context: unit 0534 bounded each off-diagonal term of the twisted moment by two integrations by parts; the summed bound falls short of the size Levinson's method needs for mollifiers of length near the square root of the height
sealed: false
---

**Question.** Does the off-diagonal of Young's Lemma 3 reach the size the method needs for mollifier lengths up to the square root of the height, with the two integrations by parts proved in unit `unit_moment` 534?

**What ran.** A derivation on paper by the worker of unit `unit_moment` 534, and a numerical check of the order of its series `offSeries`. Nothing is in Lean beyond `offSum_bound`. EXPLORATORY: no prereg, no verdict.

**The lost factor.** Each integration by parts gains about twice the logarithm of the height times the square root of the product of the four indices over the height. The weighted terms number about a power of the mollifier length times a power of the height, both growing with the number of integrations. So the summed off-diagonal is of the size Levinson needs only when the number of integrations exceeds one plus twice the length exponent, over one less twice that exponent. That ratio grows without bound as the length exponent approaches one half, the length Levinson's proportion needs. With two integrations the bound holds only for short mollifiers. The proof of each step is right, and the size the steps add up to is what fails: the design is wrong.

**The decision.** Integrate by parts as many times as the length requires, and no fixed number. That needs the derivatives of the weight `VY` in the height to every order, Young's bound for all orders, by induction on the digamma series as unit `unit_deriv` 533 did for the first two, and the smooth window's derivative bounds to every order. Then a general integration-by-parts lemma, and the choice of the number of integrations from the length exponent, close `StmtOffDiag` for every length below the square root of the height.

**What it is not.** No new Lean; the bound on paper is the worker's, checked numerically and not proved.
