/-
WeilPowerCount — the short-interval count leaf, and the range that closes.
Rung 5, nineteenth slice; worksheet § 13 block 13i. 2026-09-07.

Unit 0351 killed the route on a circularity: the range `[a, b]` has to hold
more shells than there are members, the member count grows with the target's
height `T'`, and `T'` grows with `b` through § 8's walk, `T' = T + μb` with
`μ = 1/(8K'π²λ)`. At the tree's own count `15 log T' + 73` the range had to
exceed `T'` to a power above `6`. This module names the count as a leaf and
proves the closure: when the leaf's leading constant is small enough the two
demands meet at an explicit `b`, and the circularity is gone.

Write `L = log b`, `D = log(T + μ)`, so `log T' ≤ D + L` for `b ≥ 1`;
`lρ = log ρ`; `E` the constant shell overhead (`log a + lρ`). The shells fit
when `(c₁ log T' + c₂)(W+1)lρ + E ≤ L`, and with `α = c₁(W+1)lρ < 1` that is
a linear inequality in `L`, solved at `L = (c₂(W+1)lρ + E + αD)/(1 − α)`.

Sizes. `α < 1` is the whole condition, and `(W+1)lρ → log(hi/lo)` as the
shell ratio falls (13h), so the route needs `c₁ log(hi/lo) < 1`. `L` is
linear in `D = log(T + μ)`, so `b` is polynomial in `T` with exponent
`α/(1 − α)`: at `α = 1/2` the range is `T` squared, at `α = 1/4` it is `T`
to the one third. Everything else in `L` is an additive constant. No factor
is lost: `1/(1 − α)` is the price of the leaf's constant and is bounded once
`α` is.

Regime, as the block names it:
  C1 `0 < lρ`;  C2 `0 ≤ c₁`;  C3 `0 ≤ c₂`;  C4 `0 ≤ D`;  C5 `0 ≤ E`;
  C6 `c₁·(W+1)·lρ < 1`, the closure condition;
  and 13h's P1 `1 ≤ ρ`, P2 `0 < lo`, P3 `hi < lo · ρ^(W+1)`.

Defs. `StmtShortCount cnt c₁ c₂`, the leaf: `cnt T ≤ c₁ log T + c₂` for
every `T ≥ 2`. This is an open analytic assumption, not proved here.
  Crude-constant budget: `c₁ ≤ 0.48` at a window ratio of `8`, from 13h's
  `c₁ log(hi/lo) < 1`; `c₂` unconstrained.
  Discharge route: Backlund's decomposition of `N(T+1) − N(T)` into the
  phase increment over `π` and `S(T+1) − S(T)`, the increment `≈ (1/2) log T`
  from Stirling and `|S| ≤ B₁ log T + B₃` from `ArgCrude.StmtSCrude`, giving
  `c₁ = 1/(2π) + 2B₁ ≈ 0.159 + 2B₁`. Trudgian 2014 has `B₁ = 0.112`, so
  `c₁ ≈ 0.383`, inside the budget; the tree's own crude chain has `B₁ ≈ 7`
  and is not. The floor `1/(2π) ≈ 0.159` is there even at `B₁ = 0`, so the
  budget is not vacuous.
  Citation shape: T. Trudgian, "An improved upper bound for the argument of
  the Riemann zeta-function on the critical line II", J. Number Theory 134
  (2014).

Theorems, with the hypotheses the block lists:
  card_le_of_leaf            the leaf, `2 ≤ T`      S.card ≤ c₁ log T + c₂
  exists_range_log           C1 to C6               an L with the shells fitting
                                                    at every M ≤ D + L
  count_lt_shells            C1                     N(W+1) < K
  exists_clean_shell_of_leaf the leaf, C1 to C6,    a k < K in no B j
                             13h's P1 P2 P3

Pinned: card_le_of_leaf, exists_range_log, count_lt_shells,
exists_clean_shell_of_leaf.

What the next slice needs: the leaf itself, and the instantiation of `B`
from 13f and 13g so that `hB` is discharged rather than assumed. Both are
the assembly's, § 10.

Axioms: every pinned theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerClean

namespace WeilPowerCount

/-- The short-interval zero-count leaf: the number of zeros the target
carries at height `T` is at most `c₁ log T + c₂`. Budget `c₁ ≤ 0.48`;
route: Backlund plus `ArgCrude.StmtSCrude`, see the module header. -/
def StmtShortCount (cnt : ℝ → ℝ) (c₁ c₂ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → cnt T ≤ c₁ * Real.log T + c₂

/-- A member set counted by the leaf is bounded by `c₁ log T + c₂`. -/
theorem card_le_of_leaf {ι : Type*} (S : Finset ι) {cnt : ℝ → ℝ}
    {c₁ c₂ T : ℝ} (hleaf : StmtShortCount cnt c₁ c₂) (hT : 2 ≤ T)
    (hS : (S.card : ℝ) ≤ cnt T) :
    (S.card : ℝ) ≤ c₁ * Real.log T + c₂ := by
  unfold StmtShortCount at hleaf
  exact le_trans hS (hleaf T hT)

/-- The closure: with `α = c₁(W+1)lρ < 1` there is an `L ≥ 0` — namely
`(c₂(W+1)lρ + E + αD)/(1 − α)` — at which the shells fit for every count
parameter `M` below `D + L`. This is what removes unit 0351's circularity:
the demand is linear in `L` and the coefficient is `α`. -/
theorem exists_range_log {c₁ c₂ lρ D E : ℝ} {W : ℕ}
    (hlρ : 0 < lρ) (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂) (hD : 0 ≤ D) (hE : 0 ≤ E)
    (hα : c₁ * ((W : ℝ) + 1) * lρ < 1) :
    ∃ L : ℝ, 0 ≤ L ∧ ∀ M : ℝ, 0 ≤ M → M ≤ D + L →
      (c₁ * M + c₂) * ((W : ℝ) + 1) * lρ + E ≤ L := by
  have hW1 : (0 : ℝ) ≤ (W : ℝ) + 1 := by positivity
  have hα0 : 0 ≤ c₁ * ((W : ℝ) + 1) * lρ := mul_nonneg (mul_nonneg hc₁ hW1) hlρ.le
  have h1α : 0 < 1 - c₁ * ((W : ℝ) + 1) * lρ := by linarith
  have hne : (1 - c₁ * ((W : ℝ) + 1) * lρ) ≠ 0 := ne_of_gt h1α
  have hc₂0 : 0 ≤ c₂ * ((W : ℝ) + 1) * lρ := mul_nonneg (mul_nonneg hc₂ hW1) hlρ.le
  have hαD : 0 ≤ c₁ * ((W : ℝ) + 1) * lρ * D := mul_nonneg hα0 hD
  have hG0 : 0 ≤ c₂ * ((W : ℝ) + 1) * lρ + E + c₁ * ((W : ℝ) + 1) * lρ * D := by
    linarith
  obtain ⟨L, hL0, key⟩ : ∃ L : ℝ, 0 ≤ L ∧
      (1 - c₁ * ((W : ℝ) + 1) * lρ) * L
        = c₂ * ((W : ℝ) + 1) * lρ + E + c₁ * ((W : ℝ) + 1) * lρ * D :=
    ⟨(c₂ * ((W : ℝ) + 1) * lρ + E + c₁ * ((W : ℝ) + 1) * lρ * D) /
        (1 - c₁ * ((W : ℝ) + 1) * lρ), div_nonneg hG0 h1α.le, by field_simp⟩
  refine ⟨L, hL0, ?_⟩
  intro M _ hML
  have hprod : c₁ * M * ((W : ℝ) + 1) * lρ
      ≤ c₁ * ((W : ℝ) + 1) * lρ * (D + L) := by
    linarith [mul_le_mul_of_nonneg_left hML hα0]
  linarith [key, hprod]

/-- The shell count in `ℕ`, read off the same inequality scaled by `lρ`. -/
theorem count_lt_shells {N K W : ℕ} {lρ : ℝ} (hlρ : 0 < lρ)
    (h : ((N : ℝ) * ((W : ℝ) + 1) + 1) * lρ ≤ (K : ℝ) * lρ) :
    N * (W + 1) < K := by
  have h1 : (N : ℝ) * ((W : ℝ) + 1) + 1 ≤ (K : ℝ) := le_of_mul_le_mul_right h hlρ
  have h2 : ((N * (W + 1) + 1 : ℕ) : ℝ) ≤ ((K : ℕ) : ℝ) := by push_cast; linarith
  have h3 : N * (W + 1) + 1 ≤ K := Nat.cast_le.mp h2
  omega

/-- 13h's clean shell with the member count supplied by the leaf rather
than assumed. -/
theorem exists_clean_shell_of_leaf {ι : Type*} [DecidableEq ι]
    (S : Finset ι) (B : ι → Finset ℕ) (d : ι → ℝ)
    {cnt : ℝ → ℝ} {c₁ c₂ T a ρ lo hi : ℝ} {W K N : ℕ}
    (hleaf : StmtShortCount cnt c₁ c₂) (hT : 2 ≤ T)
    (hS : (S.card : ℝ) ≤ cnt T) (hN : c₁ * Real.log T + c₂ ≤ (N : ℝ))
    (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
    (hB : ∀ j ∈ S, ∀ k ∈ B j,
       lo ≤ d j * (a * ρ ^ k) ∧ d j * (a * ρ ^ k) ≤ hi)
    (hK : N * (W + 1) < K) :
    ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j := by
  have h1 : (S.card : ℝ) ≤ (N : ℝ) :=
    le_trans (card_le_of_leaf S hleaf hT hS) hN
  have h2 : S.card ≤ N := Nat.cast_le.mp h1
  exact WeilPowerClean.exists_clean_shell_of_count S B d hρ hlo hW hB h2 hK

/-- info: 'WeilPowerCount.card_le_of_leaf' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms card_le_of_leaf

/-- info: 'WeilPowerCount.exists_range_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_range_log

/-- info: 'WeilPowerCount.count_lt_shells' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms count_lt_shells

/-- info: 'WeilPowerCount.exists_clean_shell_of_leaf' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exists_clean_shell_of_leaf

end WeilPowerCount
