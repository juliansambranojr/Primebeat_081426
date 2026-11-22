---
id: 0381
date: 2026-11-22
type: formalization
title: "lean_bridge/Bridge/WeilBridge.lean: the bridge to primes proved against zeta23's explicit formula, kernel-checked; the third tree"
refs: [lean_stage3/Stage3/WeilDetect.lean::laplace, lean_stage3/Stage3/WeilDetect.lean::IsTest, lean_stage3/Stage3/WeilDetect.lean::zeroForm]
supersedes: []
follows: 0380
context: unit 0379 fixed the bridge statement and priced three ways to compose Stage 3 with zeta23 across two toolchains; Julian chose the third tree on 2026-11-22; this is that tree and its one module
sealed: false
---

**Question.** Stage 3's Weil form has a zero side and no prime side; the explicit formula it needs is upstream with `upstream_sorries` 2 sorries. Can the join to `zeta23`'s proved explicit formula be checked by the kernel, with Stage 3's own definitions and no added hypothesis?

**What was built.** A new tree, `lean_bridge/`, the third of `trees` 3. It is a Lake project on `zeta23`'s toolchain that requires `anthropics/formal-math` at a pinned commit, subdirectory `zeta23`, and so gets Mathlib at `zeta23`'s own revision. No `zeta23` code is copied. The part of `zeta23` the explicit formula depends on, `closure_modules` 57 modules, built here clean at `jobs_zeta23` 3736 jobs.

**What was proved.** `lean_bridge/Bridge/WeilBridge.lean`: `module_lines` 220 lines, `theorems_proved` 13 theorems, `defs` 5 definitions, `pins` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`weil_bridge`: for every `G` with `IsTest L G`, the zero side `Σ_ρ mult(ρ)·laplace G (−ρ)·laplace G (−(1 − ρ))` over the nontrivial zeros of Mathlib's `riemannZeta`, with multiplicity `(analyticOrderAt riemannZeta ρ).toNat`, is summable and equals `primeSide (kOf G)`: the pole terms, minus `Σ Λ(n)/√n·(k(log n) + k(−log n))`, plus the archimedean integral. `primeSide` is `zeta23`'s `literatureRHS` written out, equal to it by `rfl`. The proof applies `Zeta23.WeilEF.EF_lit_zetaZeroConfig` at `k = F ⋆ F̃`.

The steps are unit `unit_statement` 0379's dictionary, now theorems. `laplace_neg_eq` and `laplace_reflect_eq` put the two transforms in `zeta23`'s variable. `conj_paperFT_conj` uses that `G` is real-valued. `paperFT_kOf` is the term at a zero in both languages. `contDiff_two_convolution` is the regularity step: the convolution of two compactly supported `C¹` functions is `C²`, so `IsTest`'s `ContDiff ℝ 1` is enough and no hypothesis was added. Unit 0379 had checked the same identity numerically to `rel_diff` 3.54e-16.

**The weld.** `laplace` and `IsTest` are copied from `Stage3/WeilDetect.lean` character for character, and `utilities/check_weld.py` now gates them: `welds` 2 new welds, `welds_total` 4 in all, every one OK. The checker's pattern was widened to accept a definition written `noncomputable def`, which is how Stage 3 writes `laplace`.

**The build.** `errors_first` 3 error lines on the first build from `roots` 1 root cause: `fun_prop` has no `ContDiff` lemma for the real-to-complex cast, so the smoothness of `tiltF` is now an explicit composition; the remaining lines were the pins of theorems downstream of it. `builds` 2 builds. Package at `jobs_package` 3740 jobs. Built under `LOOP.md` at version `loop_ver` 22 where it applies to a tree outside `lean_stage3`; the Lean-unit checker reads only `lean_stage3` modules and was not run on this unit.

What remains. Stage 3 cannot use the bridge yet. Its `zeroForm` sums over upstream's `riemannZeta.zeroes_sum` with `riemannZeta.order`; the bridge sums over Mathlib's zero set with `analyticOrderAt`. They are the same multiset, and the lemma saying so is Stage 3 work. After it, `zeroForm G = primeSide (kOf G)` enters Stage 3 as a named leaf discharged by this tree, by statement identity.
