---
id: 0382
date: 2026-11-22
type: formalization
title: "WeilBridgeLeaf.lean: the zero-set lemma and the bridge leaf; zeroForm has a prime side, from a leaf the third tree discharges"
refs: [lean_stage3/Stage3/WeilBridgeLeaf.lean::order_eq_toNat, lean_stage3/Stage3/WeilBridgeLeaf.lean::zeroes_rect_strip, lean_stage3/Stage3/WeilBridgeLeaf.lean::zeroForm_eq_strip, lean_stage3/Stage3/WeilBridgeLeaf.lean::zeroForm_eq_primeSide]
supersedes: []
follows: 0381
context: unit 0381 proved the bridge in the third tree over Mathlib's zero set with analyticOrderAt; Stage 3's zeroForm sums over upstream's zeroes_sum with riemannZeta.order; the two had to be shown to be the same sum before Stage 3 could use the bridge
sealed: false
---

**Question.** Block `1` of the bridge worksheet (`bridge.md#1`). Is `WeilDetect.zeroForm G`, upstream's sum over a rectangle weighted by a meromorphic order, the same as the sum the third tree's theorem is about, and does `zeroForm` then have a prime side inside Stage 3?

**What was proved.** `module_lines` 140 lines, `theorems_proved` 4 theorems, `defs` 5 definitions, `pins` 4 axiom pins each at `axioms` 3 axioms, `sorries` 0 sorries.

`order_eq_toNat`: away from the pole, upstream's `riemannZeta.order ρ` is `(analyticOrderAt riemannZeta ρ).toNat`. It needs no non-vanishing of `ζ`: at analytic order `⊤` both sides are zero. `zeroes_rect_strip`: upstream's rectangle over `(0, 1)` is the set `{ρ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}`. `zeroForm_eq_strip` is the zero-set lemma: `zeroForm G` is the sum over that set weighted by the analytic order. `zeroForm_eq_primeSide`: from the leaf `StmtWeilBridge`, for every `G` with `IsTest L G`, `zeroForm G = primeSideM (kOfM G)`, the pole terms minus the prime sum plus the archimedean integral.

**The leaf and the weld.** `StmtWeilBridge` is a named statement with no constant. In the third tree it is the same `def`, and `Bridge.stmtWeilBridge_holds` proves it against `zeta23`'s explicit formula; that tree gained `bridge_added` 3 theorems for this and stands at `bridge_lines` 268 lines, `bridge_theorems` 16 theorems, `bridge_defs` 9 definitions, built at `jobs_bridge` 3740 jobs. The five definitions the leaf is stated with are character copies across the two trees: `welds_new` 5 new welds, `welds_total` 9 in all, every one OK. They are written with fully qualified names so the text is the same under either tree's `open` lines. The join between the trees is by statement identity; the kernel checks each side and not the join, as with `lean/`.

So the chain is: `zeta23`'s explicit formula, kernel-checked into the bridge in the third tree; the bridge statement, copied by text; the zero-set lemma, kernel-checked in Stage 3. Upstream's own explicit formula, with its `upstream_sorries` 2 sorries, is not used.

**The build.** `errors_first` 5 error lines on the first build from `roots` 2 root causes, the other `cascade` 3 being pins downstream of a failed proof. One root: `Complex.digamma` is not in scope from `WeilDetect`'s imports, so the archimedean bracket is written `logDeriv Complex.Gamma` in both trees, which is its definition. The other: `simp` did not finish the finite case of the order, and the three rewrites upstream uses there do. `builds` 2 builds, `traps_added` 0 rows, `assumed_pins` 0. Module at `jobs_module` 3666 jobs, package at `jobs_package` 8773. `steps_skipped` 2 steps of the loop, the same as unit 0380. Loop version `loop_version` 22.

What remains. Nothing of C: Stage 3's Weil form now has a prime side. What it is for is open. Positivity of the form is a statement about `primeSideM (kOfM G)`, and nothing in the tree proves or uses one. Units `unit_statement` 0379 and `unit_tree` 0381 are the two steps before this.
