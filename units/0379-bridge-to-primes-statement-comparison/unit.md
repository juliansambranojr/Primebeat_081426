---
id: 0379
date: 2026-11-22
type: decision
title: "C, the bridge to primes: zeroForm G equals zeta23's literatureRHS at k = F * F-reflected; checked numerically on the tree's window; upstream still has its two sorries; three ways to compose, priced"
refs: [lean_stage3/Stage3/WeilDetect.lean::zeroForm, lean_stage3/Stage3/WeilDetect.lean::laplace, lean_stage3/Stage3/WeilDetect.lean::IsTest]
supersedes: []
follows: 0378
context: the tree's Weil form has a zero side and no prime side; WeilDetect's header records the explicit formula as upstream with two sorries; anthropics/formal-math zeta23 proves Weil's explicit formula sorry-free over Mathlib alone on a later toolchain; Julian chose on 2026-11-22 to build the bridge after section 16
sealed: false
---

**Question.** What exactly is the statement that gives `zeroForm` a prime side, and how can the tree get it from `zeta23`'s `EF_lit` across two toolchains?

**What ran.** `run/bridge.py`, through `lab run`. EXPLORATORY. It computes `record.sides` 2 sides independently on the tree's own window: the zero side over the bench's `bridge.zeros` 600 zeros, and `zeta23`'s `literatureRHS` from the primes, the pole terms and the archimedean integral. The rest of this unit is reading: `record.statements` 3 statements, opened in this session.

**The upstream race.** `DESIGN.md` § 0 says to probe upstream before building a leaf. PrimeNumberTheoremAnd at HEAD `record.upstream_head` a4fb698, dated `record.upstream_head_date` 2026-11-14, still carries the `record.upstream_sorries` 2 sorries in `kadiri_thm_3_1_q1` that entry `record.entry_leaf` 303 named. A pin bump does not discharge the leaf.

**The dictionary.** For a test function `G` put `F(u) = G(u)·e^{u/2}`, `F⁻(u) = F(−u)` and `k = F ⋆ F⁻`. Then `laplace G (−ρ) = paperFT F (gammaOf ρ)`, `laplace G (−(1−ρ)) = paperFT F⁻ (gammaOf ρ)`, and their product is `paperFT k (gammaOf ρ)`. So

`zeroForm G = Σ_ρ mult(ρ) · paperFT k (gammaOf ρ) = literatureRHS k`,

and the right side is the pole terms, minus `Σ Λ(n)/√n · (k(log n) + k(−log n))`, plus the archimedean integral. That is the bridge.

The regularity gap closes by itself. `IsTest` asks `ContDiff ℝ 1`; `EF_lit` asks `ContDiff ℝ 2` of `k`. The convolution of two compactly supported `C¹` functions is `C²`, so every `IsTest` function is covered and neither statement has to change.

**The check.** On `bridge.windows` 3 windows of the tree's own shape (`h = ` `bridge.h` 3, `m = ` `bridge.m` 6, tuned to three heights) the two sides agree to a relative difference of at most `bridge.rel_diff_max` 3.54e-16, with `bridge.prime_powers` 98 prime powers on the prime side. The tree's expression for the zero side, the sum of `−what(ρ − 1/2)²`, and `zeta23`'s agree exactly (`bridge.rel_diff_tree_max` 0.0). So every sign and every `2π` in the dictionary is right for the tree's window.

**What still differs.** The zero sets. The tree sums over upstream's `riemannZeta.zeroes_sum` with `riemannZeta.order`; `zeta23` sums over `{ρ | IsNontrivialZero ρ}` with `zeroMult`, defined from Mathlib's `analyticOrderAt`. They are the same multiset and that is a lemma somebody has to prove, in whichever toolchain holds both definitions. And the toolchains: Stage 3 is on Lean `v4.32.2` with PrimeNumberTheoremAnd; `zeta23` is on `v4.33.0-rc2` with Mathlib alone.

**Three ways to compose.** `record.options` 3 options.

Weld. State `EF_lit` for `ζ` in Stage 3 as a named leaf, its definitions copied character for character and gated by `check_weld.py`, discharged by `zeta23` at commit `record.zeta23_commit` 16a5ce4. Prove in Stage 3 that the leaf gives the bridge. One module and a longer weld list. The kernel never checks the join; it is the same trust the tree already extends to `lean/`.

A third tree. A small Lake project on `zeta23`'s toolchain that requires `zeta23` as a dependency and proves the bridge against it, with `laplace` and a Mathlib-only `zeroForm` copied from Stage 3 by text. The kernel checks the explicit formula into the bridge. What it must build of `zeta23` is the closure of the explicit formula: `record.closure_modules` 57 modules, `record.closure_lines` 18105 lines, of `record.zeta23_modules` 316 and `record.zeta23_lines` 102265. The join back to Stage 3 is then one weld on the bridge statement and the zero-set lemma.

A port. Copy that closure into Stage 3 with attribution and make it compile one Mathlib version back. One kernel for everything. It is the largest, and going backwards a Mathlib version is the kind of work whose size is not known until it is tried.

**Decision.** None taken; the choice is Julian's, since the second option adds a tree and a toolchain. The statement of the bridge is fixed by this unit whichever way it is composed.
