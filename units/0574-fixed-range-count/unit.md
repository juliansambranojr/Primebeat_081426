---
id: 0574
date: 2026-11-26
type: decision
title: "The chain's base needs a count over a fixed range: one V from a fixed height to the top"
refs: [lean_stage3/Stage3/BasinChain.lean::rh_of_noRightZeros, lean_stage3/Stage3/BasinChain.lean::defect_eventually_const, lean_stage3/Stage3/TuringSlope.lean::theta_sub_le_sharp]
supersedes: []
follows: 0573
context: unit 0573 proved the defect eventually constant from no right zeros, and found that the window count cannot reach the base, in block S15 of `lean_stage3/design/stencil.md`
sealed: false
---

**Question.** How does the chain from no right zeros get its base, the defect zero at the height from which it is constant?

**What ran.** No run. The design finding of unit 0573 and its size script, `lean_stage3/checks/basinchain/sizes.py`. EXPLORATORY: no prereg, no verdict.

**The finding.** V with the mollifier's logarithm set by T is controlled only on the window from a quarter of T to twice T. Every count is then a difference of the defect at two heights in one window. Averaging removes the increments and never sees the defect itself, so the chain gives the defect constant from a height whose log log exceeds `loglog_floor` 166. No finite check reaches that height. No sharper size fixes it, because the failure is in what the count measures.

**The decision.** Count over a fixed range. For each top height T, take one V, with the mollifier's logarithm set by T, on the rectangle from a fixed height t₀ to T. Choose t₀ below the point run's closing height, computed near `closing_ideal` 439 in unit 0571. The count then bounds the defect at T minus the defect at t₀, the point run gives the defect zero at t₀, and Turing's averaging at the top gives the defect at T below two. The defect is even, so it is zero.

**What it asks.** I have not checked these sizes.
- The edge bounds on the whole range from t₀ to twice T, at the logarithm of T. The tree proves them on the window only.
- No right zeros of V on the whole range, a stronger hypothesis than unit 0573's.
- The horizontal lower bound at the fixed bottom edge, which is a finite computation.

What remains. A size check of the three before any Lean: whether V at heights far below T, with the logarithm of T, keeps its right edge near one and its bottom edge computable.
