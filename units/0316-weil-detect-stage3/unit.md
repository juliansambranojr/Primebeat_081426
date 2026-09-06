---
id: 0316
date: 2026-09-06
type: formalization
title: WeilDetect.lean: the zero side of Weil's form on bounded support, RH => positivity, and the rung-to-strip arrow stated
refs: [lean_stage3/Stage3/WeilDetect.lean::zeroForm_nonneg_of_RH, lean_stage3/Stage3/WeilDetect.lean::weilPositive_of_RH, lean_stage3/Stage3/WeilDetect.lean::box_empty_of_positive_of_detect, lean_stage3/Stage3/WeilDetect.lean::laplace_conj]
supersedes: []
follows: 0308
sealed: false
---

**Question.** Entry 297 sketched the rung-to-strip arrow and entry 303 §(d)
drafted `StmtWeilPositive L → RH_up_to (T L)` and did not add it, because a
leaf enters with a budget and a route and the arrow had neither. Julian's
instruction on 2026-09-06: do not log it as motivation until you try it.
Before trying, both Lean packages were searched for any statement of Weil
positivity or any height-bounded zero theorem: none exists (`grep` over
`lean/*.lean` and `lean_stage3/Stage3/*.lean` for WeilPositive, RH_up_to,
rectangle; the only hits are the argument-principle rectangle in
`ArgCrude.lean` and `ArgIdentity.lean`, which counts zeros in a box and
excludes none). So: can the zero side of Weil's form, the test-function
class, positivity on support L, the off-line box, and the detection
statement be written in Stage 3 in upstream's own terms, and what is
provable on day one?

**What ran.** `lean_stage3/Stage3/WeilDetect.lean`, new, `module_lines` 169
lines, imported from `lean_stage3/Stage3.lean`. `lake build Stage3.WeilDetect`
compiled it in `build_s_first` 13 s over `jobs_module` 3665 jobs with `errors_fixed` 1
error, an unqualified upstream name (`Kadiri.riemannZeta_order_pos_nontrivialZero`
lives in `namespace Kadiri`); after the fix the module rebuilt in
`build_s_rebuild` 1.9 s and the full package built, `jobs_package` 8737 jobs. The
run record is `run/build.log`.

**What it shows.** `defs` 6 definitions and `theorems_proved` 5 theorems, every
theorem pinned by `#guard_msgs` to `axioms` 3 axioms (`propext`,
`Classical.choice`, `Quot.sound`), `sorries` 0 sorries.

`laplace G z = ∫ G(u) e^{−zu} du`, the two-sided transform in Kadiri's sign;
  `zeroForm G = Σ_ρ Ĝ(−ρ)·Ĝ(−(1−ρ))·ord ρ` over
  `riemannZeta.zeroes_rect (.Ioo 0 1) .univ` via upstream's `zeroes_sum`;
  `IsTest L G` (real-valued, C², support in [−L/2, L/2]); `StmtWeilPositive L`;
  `OffLineBox ε T` (`Re ρ ≥ 1/2 + ε`, `|Im ρ| ≤ T`); `StmtDetect ε T L`.
`laplace_conj`: for real `G`, `Ĝ(conj z) = conj Ĝ(z)`.
`zeroForm_nonneg_of_RH` and `weilPositive_of_RH`: **RH ⇒ StmtWeilPositive L
  for every L.** Under RH each ρ has real part 1/2 (`re_eq_half_of_RH`, from
  Mathlib's `RiemannHypothesis` with the trivial zeros and `s = 1` excluded
  by `Re ρ ∈ (0, 1)`), so `−(1−ρ) = conj(−ρ)`, each term is
  `|Ĝ(−ρ)|²·ord ρ` with `ord ρ ≥ 1` (upstream), and the tsum of nonnegative
  reals is nonnegative; a non-summable tsum is 0. The easy half of Weil's
  criterion, zero side, kernel-checked: the first Weil-form theorem in
  either package.
`box_empty_of_positive_of_detect`: `StmtDetect ε T L → StmtWeilPositive L →
  OffLineBox ε T = ∅`. Pure logic; the arrow of entry 297, with the
  detection lemma as its one hypothesis.

What is not proved: `StmtDetect ε T L` for any explicit `L(ε, T)` — the
bounded-height rectangle theorem. It is now a named statement in Lean with a
route on record: Bombieri (2000) Theorem 8 and Theorem 10 (a finite multiset
of off-line zeros forces negative eigenvalues; no formula for the support),
made explicit by entry 302's raised-cosine window, with the zeros above `T`
bounded by `JensenCount.zeta_local_zero_count` (`15·log T + 73`, proved).
Adding it to the ledger with that budget is Julian's call. Nothing here
touches the arithmetic side; `StmtWeilExplicit` (entry 303 §(c)) stays
upstream with two sorries. `statements_open` 1 statement is open.
