/-
ZeroSummable — block C6b of `lean_stage3/design/carlson.md`. 2026-11-23.

The zeros of ζ to the right of a line `Re s = σ > 1/2` have summable weights `m(ρ)/|ρ|`. A zero
in the shell `2^j ≤ |Im ρ| < 2^(j+1)` has order at most `103·(j + 1)` (the local count of
`Stage3.zeta_local_zero_count`, with conjugation for the lower half plane) and modulus at least
`2^j`. `ZeroDensity.zero_density` at height `2^(j+1) + 2`, applied to the upper half and to the
conjugates of the lower half, bounds the number of zeros in the shell by `2·C·(2^(j+2))^θ'`,
`θ' = max θ 0 < 1`. The shell then weighs at most `K·(j + 1)·r^j` with `r = 2^θ'/2 < 1`. The
zeros below the first shell used are finitely many (`FiniteOffLine.ZF`), so every finite partial
sum is at most one constant.

  w                      the weight `m(ρ)/|ρ|` of a nontrivial zero
  w_nonneg               the weight is nonnegative
  mem_nt                 a nontrivial zero is a zero of ζ with `0 < Re ρ < 1`
  order_le_log_pos       a zero with `Re ρ > 1/2`, `Im ρ ≥ 2` has order `≤ 15 log(Im ρ + 1) + 73`
  order_le_log           the same with `|Im ρ| ≥ 2`, by conjugation
  order_le_shell         in the shell `2^j ≤ |Im ρ| < 2^(j+1)`, `j ≥ 1`, the order is `≤ 103(j+1)`
  card_shell_le          a finite set of zeros in a shell has at most `2·C·(2^(j+1)+2)^θ` elements
  shell_sum_le           the weights over a finite set in a shell sum to at most count × bound
  shell_bound_le         that bound is at most `206·C·4^θ'·(j+1)·(2^θ'/2)^j`
  summable_shell         `Σ_j K·(j+1)·r^j` converges for `0 ≤ r < 1`
  dyadic_index           for `x ≥ 1`, `k = Nat.log 2 ⌊x⌋₊` has `2^k ≤ x < 2^(k+1)`
  sum_le_const           for `1/2 < σ ≤ 1`, one bound for every finite sum of weights right of σ
  summable_order_div     the weights of the zeros with `Re ρ ≥ σ` are summable, for `σ > 1/2`
  norm_coef              `‖LadderMean.coef ρ‖` is the weight `w ρ`
  summable_norm_coef     the form `Summable fun ρ : S => ‖LadderMean.coef ρ‖` for a set right of σ

What the next slice needs: block C7 of the design, joint 10 when the largest real part is
attained, from `summable_norm_coef`, `LadderMean.line_not_fading_summable` and the splitting of
unit 0431. It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib
import Stage3.ZeroDensity
import Stage3.FiniteOffLine
import Stage3.WeilOnLine
import Stage3.WeilBands

namespace ZeroSummable

open Kadiri

noncomputable section

/-- The weight of a nontrivial zero: its order over its modulus. -/
def w (ρ : NontrivialZeros) : ℝ :=
  ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖

/-- The weight `w ρ` of a nontrivial zero is nonnegative. -/
theorem w_nonneg (ρ : NontrivialZeros) : 0 ≤ w ρ :=
  div_nonneg (FiniteOffLine.order_nonneg ρ) (norm_nonneg _)

/-- A nontrivial zero is a zero of ζ with real part strictly between zero and one. -/
theorem mem_nt (ρ : NontrivialZeros) :
    riemannZeta (ρ : ℂ) = 0 ∧ 0 < (ρ : ℂ).re ∧ (ρ : ℂ).re < 1 := by
  have hmem := ρ.2
  simp only [Kadiri.NontrivialZeros, riemannZeta.zeroes_rect, riemannZeta.zeroes,
    Set.mem_setOf_eq] at hmem
  obtain ⟨hre, -, hz⟩ := hmem
  exact ⟨hz, hre.1, hre.2⟩

/-- A nontrivial zero with real part above `1/2` and imaginary part at least two has order at
most `15·log(Im ρ + 1) + 73`. -/
theorem order_le_log_pos (ρ : NontrivialZeros) (h1 : 1 / 2 < (ρ : ℂ).re)
    (h2 : 2 ≤ (ρ : ℂ).im) :
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log ((ρ : ℂ).im + 1) + 73 := by
  obtain ⟨hz, -, hre1⟩ := mem_nt ρ
  obtain ⟨n, hndef⟩ : ∃ n : ℕ, n = ⌊(ρ : ℂ).im - 2⌋₊ := ⟨_, rfl⟩
  have hn1 : (n : ℝ) ≤ (ρ : ℂ).im - 2 := by rw [hndef]; exact Nat.floor_le (by linarith)
  have hn2 : (ρ : ℂ).im - 2 < (n : ℝ) + 1 := by rw [hndef]; exact Nat.lt_floor_add_one _
  have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  have hw := ZeroSquares.window_mem hz h1 hre1 n (by linarith) (by linarith)
  have hT2 : (2 : ℝ) ≤ (n : ℝ) + 5 / 2 := by linarith
  have hmem : (ρ : ℂ) ∈ (Stage3.zetaWindow_finite hT2).toFinset :=
    (Set.Finite.mem_toFinset _).mpr hw
  have hle : (analyticOrderNatAt riemannZeta (ρ : ℂ) : ℝ)
      ≤ ∑ z ∈ (Stage3.zetaWindow_finite hT2).toFinset, (analyticOrderNatAt riemannZeta z : ℝ) :=
    Finset.single_le_sum (f := fun z => (analyticOrderNatAt riemannZeta z : ℝ))
      (fun _ _ => Nat.cast_nonneg _) hmem
  have hc := Stage3.zeta_local_zero_count hT2
  have hlog : Real.log ((n : ℝ) + 5 / 2) ≤ Real.log ((ρ : ℂ).im + 1) :=
    Real.log_le_log (by linarith) (by linarith)
  rw [WeilBands.order_eq_analyticOrderNatAt]
  linarith

/-- A nontrivial zero with real part above `1/2` and `|Im ρ| ≥ 2` has order at most
`15·log(|Im ρ| + 1) + 73`. -/
theorem order_le_log (ρ : NontrivialZeros) (h1 : 1 / 2 < (ρ : ℂ).re)
    (h2 : 2 ≤ |(ρ : ℂ).im|) :
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 15 * Real.log (|(ρ : ℂ).im| + 1) + 73 := by
  rcases le_or_gt 0 (ρ : ℂ).im with h | h
  · rw [abs_of_nonneg h] at h2 ⊢
    exact order_le_log_pos ρ h1 h2
  · have hc : ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ) = (starRingEnd ℂ) (ρ : ℂ) := rfl
    have hre : ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ).re = (ρ : ℂ).re := by
      rw [hc, Complex.conj_re]
    have him : ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ).im = -(ρ : ℂ).im := by
      rw [hc, Complex.conj_im]
    have ho : riemannZeta.order ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ)
        = riemannZeta.order (ρ : ℂ) := by
      rw [hc]
      exact Kadiri.riemannZeta_order_conj (Kadiri.nontrivialZero_ne_one ρ)
    rw [abs_of_neg h] at h2 ⊢
    have key := order_le_log_pos (WeilOnLine.conjZ ρ) (by rw [hre]; exact h1)
      (by rw [him]; exact h2)
    rw [ho, him] at key
    exact key

/-- A nontrivial zero with real part above `1/2` in the shell `2^j ≤ |Im ρ| < 2^(j+1)`, `j ≥ 1`,
has order at most `103·(j + 1)`. -/
theorem order_le_shell {j : ℕ} (hj : 1 ≤ j) (ρ : NontrivialZeros) (h1 : 1 / 2 < (ρ : ℂ).re)
    (hlo : (2 : ℝ) ^ j ≤ |(ρ : ℂ).im|) (hhi : |(ρ : ℂ).im| < 2 ^ (j + 1)) :
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) ≤ 103 * ((j : ℝ) + 1) := by
  have h2j : (2 : ℝ) ≤ 2 ^ j := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ j := pow_le_pow_right₀ (by norm_num) hj
  have hol := order_le_log ρ h1 (h2j.trans hlo)
  have hx : |(ρ : ℂ).im| + 1 ≤ 2 ^ (j + 2) := by
    have e : (2 : ℝ) ^ (j + 2) = 2 * 2 ^ (j + 1) := by ring
    have : (1 : ℝ) ≤ 2 ^ (j + 1) := one_le_pow₀ (by norm_num)
    linarith
  have hl : Real.log (|(ρ : ℂ).im| + 1) ≤ Real.log (2 ^ (j + 2)) :=
    Real.log_le_log (by positivity) hx
  rw [Real.log_pow] at hl
  push_cast at hl
  have hl2 := Real.log_two_lt_d9
  have hl1 : Real.log 2 ≤ 1 := by linarith
  have hm : ((j : ℝ) + 2) * Real.log 2 ≤ (j : ℝ) + 2 :=
    mul_le_of_le_one_right (by positivity) hl1
  have hj0 : (0 : ℝ) ≤ j := Nat.cast_nonneg j
  linarith

/-- Given the zero-density bound at all heights from `T₀`, a finite set of nontrivial zeros with
`Re ρ ≥ σ` in the shell `2^j ≤ |Im ρ| < 2^(j+1)`, `j ≥ 1`, `2^(j+1) + 2 ≥ T₀`, has at most
`2·C·(2^(j+1) + 2)^θ` elements. -/
theorem card_shell_le {σ θ C T₀ : ℝ}
    (hd : ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ,
      (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) →
      (Z.card : ℝ) ≤ C * T ^ θ)
    {j : ℕ} (hj : 1 ≤ j) (hT : T₀ ≤ (2 : ℝ) ^ (j + 1) + 2) (F : Finset NontrivialZeros)
    (hF : ∀ ρ ∈ F, σ ≤ (ρ : ℂ).re ∧ (2 : ℝ) ^ j ≤ |(ρ : ℂ).im| ∧ |(ρ : ℂ).im| < 2 ^ (j + 1)) :
    (F.card : ℝ) ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) := by
  classical
  have h2j : (2 : ℝ) ≤ 2 ^ j := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ j := pow_le_pow_right₀ (by norm_num) hj
  have hcard := Finset.card_filter_add_card_filter_not (s := F)
    (fun ρ : NontrivialZeros => 0 < (ρ : ℂ).im)
  have hP : ((F.filter (fun ρ : NontrivialZeros => 0 < (ρ : ℂ).im)).card : ℝ)
      ≤ C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ := by
    have hinj : Function.Injective (fun ρ : NontrivialZeros => (ρ : ℂ)) := Subtype.val_injective
    rw [← Finset.card_image_of_injective _ hinj]
    apply hd _ hT
    intro z hz
    obtain ⟨ρ, hρ, hzeq⟩ := Finset.mem_image.mp hz
    obtain ⟨hρF, hpos⟩ := Finset.mem_filter.mp hρ
    obtain ⟨hs, hlo, hhi⟩ := hF ρ hρF
    obtain ⟨hz0, -, hre1⟩ := mem_nt ρ
    rw [abs_of_pos hpos] at hlo hhi
    have hzρ : z = (ρ : ℂ) := hzeq.symm
    subst hzρ
    exact ⟨hz0, hs, hre1, by linarith, by linarith⟩
  have hQ : ((F.filter (fun ρ : NontrivialZeros => ¬ 0 < (ρ : ℂ).im)).card : ℝ)
      ≤ C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ := by
    have hinj : Function.Injective
        (fun ρ : NontrivialZeros => ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ)) :=
      Subtype.val_injective.comp WeilOnLine.conjZ_injective
    rw [← Finset.card_image_of_injective _ hinj]
    apply hd _ hT
    intro z hz
    obtain ⟨ρ, hρ, hzeq⟩ := Finset.mem_image.mp hz
    obtain ⟨hρF, hneg⟩ := Finset.mem_filter.mp hρ
    obtain ⟨hs, hlo, hhi⟩ := hF ρ hρF
    rw [abs_of_nonpos (le_of_not_gt hneg)] at hlo hhi
    obtain ⟨hz0, -, hre1⟩ := mem_nt (WeilOnLine.conjZ ρ)
    have hc : ((WeilOnLine.conjZ ρ : NontrivialZeros) : ℂ) = (starRingEnd ℂ) (ρ : ℂ) := rfl
    have hzc : z = (starRingEnd ℂ) (ρ : ℂ) := hzeq.symm.trans hc
    rw [hc] at hz0 hre1
    rw [Complex.conj_re] at hre1
    subst hzc
    rw [Complex.conj_re, Complex.conj_im]
    exact ⟨hz0, hs, hre1, by linarith, by linarith⟩
  have hsum : (F.card : ℝ)
      = ((F.filter (fun ρ : NontrivialZeros => 0 < (ρ : ℂ).im)).card : ℝ)
        + ((F.filter (fun ρ : NontrivialZeros => ¬ 0 < (ρ : ℂ).im)).card : ℝ) := by
    exact_mod_cast hcard.symm
  rw [hsum]
  linarith

/-- Under the same hypotheses, with `σ > 1/2`, the weights over a finite set of zeros in the
shell `2^j ≤ |Im ρ| < 2^(j+1)` sum to at most `2·C·(2^(j+1) + 2)^θ·103·(j + 1)/2^j`. -/
theorem shell_sum_le {σ θ C T₀ : ℝ} (hσ : 1 / 2 < σ)
    (hd : ∀ T : ℝ, T₀ ≤ T → ∀ Z : Finset ℂ,
      (∀ ρ ∈ Z, riemannZeta ρ = 0 ∧ σ ≤ ρ.re ∧ ρ.re < 1 ∧ 2 ≤ ρ.im ∧ ρ.im ≤ T - 2) →
      (Z.card : ℝ) ≤ C * T ^ θ)
    {j : ℕ} (hj : 1 ≤ j) (hT : T₀ ≤ (2 : ℝ) ^ (j + 1) + 2) (F : Finset NontrivialZeros)
    (hF : ∀ ρ ∈ F, σ ≤ (ρ : ℂ).re ∧ (2 : ℝ) ^ j ≤ |(ρ : ℂ).im| ∧ |(ρ : ℂ).im| < 2 ^ (j + 1)) :
    ∑ ρ ∈ F, w ρ ≤ 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j) := by
  have hp : (0 : ℝ) < 2 ^ j := by positivity
  have hpt : ∀ ρ ∈ F, w ρ ≤ 103 * ((j : ℝ) + 1) / 2 ^ j := by
    intro ρ hρ
    obtain ⟨hs, hlo, hhi⟩ := hF ρ hρ
    have ho := order_le_shell hj ρ (by linarith) hlo hhi
    have h0 := FiniteOffLine.order_nonneg ρ
    have hn : (2 : ℝ) ^ j ≤ ‖(ρ : ℂ)‖ := hlo.trans (Complex.abs_im_le_norm _)
    calc w ρ = ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / ‖(ρ : ℂ)‖ := rfl
      _ ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) / 2 ^ j := div_le_div_of_nonneg_left h0 hp hn
      _ ≤ 103 * ((j : ℝ) + 1) / 2 ^ j := div_le_div_of_nonneg_right ho hp.le
  have hs := Finset.sum_le_card_nsmul F w _ hpt
  rw [nsmul_eq_mul] at hs
  have hc := card_shell_le hd hj hT F hF
  have hb0 : (0 : ℝ) ≤ 103 * ((j : ℝ) + 1) / 2 ^ j := by positivity
  exact hs.trans (mul_le_mul_of_nonneg_right hc hb0)

/-- For `C ≥ 0` the shell bound `2·C·(2^(j+1) + 2)^θ·103·(j + 1)/2^j` is at most
`206·C·4^θ'·(j + 1)·(2^θ'/2)^j` with `θ' = max θ 0`. -/
theorem shell_bound_le {θ C : ℝ} (hC : 0 ≤ C) (j : ℕ) :
    2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j)
      ≤ 206 * C * (4 : ℝ) ^ (max θ 0) * (((j : ℝ) + 1) * ((2 : ℝ) ^ (max θ 0) / 2) ^ j) := by
  have hj1 : (1 : ℝ) ≤ 2 ^ j := one_le_pow₀ (by norm_num)
  have hT1 : (1 : ℝ) ≤ (2 : ℝ) ^ (j + 1) + 2 := by
    have : (1 : ℝ) ≤ 2 ^ (j + 1) := one_le_pow₀ (by norm_num)
    linarith
  have hT4 : (2 : ℝ) ^ (j + 1) + 2 ≤ 4 * 2 ^ j := by
    rw [pow_succ]
    linarith
  have e1 : ((2 : ℝ) ^ (j + 1) + 2) ^ θ ≤ ((2 : ℝ) ^ (j + 1) + 2) ^ (max θ 0) :=
    Real.rpow_le_rpow_of_exponent_le hT1 (le_max_left _ _)
  have e2 : ((2 : ℝ) ^ (j + 1) + 2) ^ (max θ 0) ≤ (4 * 2 ^ j : ℝ) ^ (max θ 0) :=
    Real.rpow_le_rpow (by positivity) hT4 (le_max_right _ _)
  have e3 : (4 * 2 ^ j : ℝ) ^ (max θ 0) = (4 : ℝ) ^ (max θ 0) * ((2 : ℝ) ^ (max θ 0)) ^ j := by
    rw [Real.mul_rpow (by norm_num) (by positivity),
      Real.rpow_pow_comm (by norm_num : (0 : ℝ) ≤ 2) (max θ 0) j]
  have e4 : ((2 : ℝ) ^ (max θ 0) / 2) ^ j = ((2 : ℝ) ^ (max θ 0)) ^ j / 2 ^ j := div_pow _ _ _
  have hb0 : (0 : ℝ) ≤ 103 * ((j : ℝ) + 1) / 2 ^ j := by positivity
  have hle : ((2 : ℝ) ^ (j + 1) + 2) ^ θ ≤ (4 : ℝ) ^ (max θ 0) * ((2 : ℝ) ^ (max θ 0)) ^ j :=
    (e1.trans e2).trans_eq e3
  calc 2 * (C * ((2 : ℝ) ^ (j + 1) + 2) ^ θ) * (103 * ((j : ℝ) + 1) / 2 ^ j)
      ≤ 2 * (C * ((4 : ℝ) ^ (max θ 0) * ((2 : ℝ) ^ (max θ 0)) ^ j))
          * (103 * ((j : ℝ) + 1) / 2 ^ j) :=
        mul_le_mul_of_nonneg_right
          (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hle hC) (by norm_num)) hb0
    _ = 206 * C * (4 : ℝ) ^ (max θ 0) * (((j : ℝ) + 1) * ((2 : ℝ) ^ (max θ 0) / 2) ^ j) := by
        rw [e4]
        ring

/-- For `0 ≤ r < 1` and any constant `K`, the series `Σ_j K·(j + 1)·r^j` converges. -/
theorem summable_shell {r : ℝ} (h0 : 0 ≤ r) (h1 : r < 1) (K : ℝ) :
    Summable fun j : ℕ => K * (((j : ℝ) + 1) * r ^ j) := by
  have hn : ‖r‖ < 1 := by rwa [Real.norm_of_nonneg h0]
  have a := summable_pow_mul_geometric_of_norm_lt_one 1 hn
  have b := summable_geometric_of_lt_one h0 h1
  refine ((a.add b).mul_left K).congr ?_
  intro j
  simp only [pow_one]
  ring

/-- For `x ≥ 1` the index `k = Nat.log 2 ⌊x⌋₊` satisfies `2^k ≤ x < 2^(k+1)`. -/
theorem dyadic_index {x : ℝ} (hx : 1 ≤ x) :
    (2 : ℝ) ^ (Nat.log 2 ⌊x⌋₊) ≤ x ∧ x < 2 ^ (Nat.log 2 ⌊x⌋₊ + 1) := by
  have hf1 : 1 ≤ ⌊x⌋₊ := Nat.le_floor (by exact_mod_cast hx)
  have hf0 : ⌊x⌋₊ ≠ 0 := by omega
  have h1 := Nat.pow_log_le_self 2 hf0
  have h2 : ⌊x⌋₊ + 1 ≤ 2 ^ (Nat.log 2 ⌊x⌋₊ + 1) :=
    Nat.lt_pow_succ_log_self (by norm_num) ⌊x⌋₊
  have h1' : ((2 ^ (Nat.log 2 ⌊x⌋₊) : ℕ) : ℝ) ≤ (⌊x⌋₊ : ℝ) := by exact_mod_cast h1
  have h2' : ((⌊x⌋₊ + 1 : ℕ) : ℝ) ≤ ((2 ^ (Nat.log 2 ⌊x⌋₊ + 1) : ℕ) : ℝ) := by
    exact_mod_cast h2
  push_cast at h1' h2'
  have h3 := Nat.floor_le (by linarith : (0 : ℝ) ≤ x)
  have h4 := Nat.lt_floor_add_one x
  exact ⟨h1'.trans h3, by linarith⟩

/-- For `1/2 < σ ≤ 1` there is one constant bounding the sum of the weights `m(ρ)/|ρ|` over
every finite set of nontrivial zeros with `Re ρ ≥ σ`. -/
theorem sum_le_const {σ : ℝ} (hσ : 1 / 2 < σ) (hσ1 : σ ≤ 1) :
    ∃ M : ℝ, ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, σ ≤ (ρ : ℂ).re) →
      ∑ ρ ∈ v, w ρ ≤ M := by
  classical
  obtain ⟨θ, C, T₀, hθ, hC, hd⟩ := ZeroDensity.zero_density hσ hσ1
  obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt T₀ (by norm_num : (1 : ℝ) < 2)
  have hθ' : max θ 0 < 1 := max_lt hθ (by norm_num)
  have hr0 : (0 : ℝ) ≤ (2 : ℝ) ^ (max θ 0) / 2 := by positivity
  have hr1 : (2 : ℝ) ^ (max θ 0) / 2 < 1 := by
    have h := Real.rpow_lt_rpow_of_exponent_lt (by norm_num : (1 : ℝ) < 2) hθ'
    rw [Real.rpow_one] at h
    linarith
  obtain ⟨b, hb⟩ : ∃ b : ℕ → ℝ, b = fun j : ℕ =>
      206 * C * (4 : ℝ) ^ (max θ 0) * (((j : ℝ) + 1) * ((2 : ℝ) ^ (max θ 0) / 2) ^ j) :=
    ⟨_, rfl⟩
  have hbs : Summable b := by
    rw [hb]
    exact summable_shell hr0 hr1 _
  have hb0 : ∀ j, 0 ≤ b j := fun j => by
    rw [hb]
    positivity
  refine ⟨∑ ρ ∈ FiniteOffLine.ZF ((2 : ℝ) ^ (n + 1)), w ρ + ∑' j, b j, ?_⟩
  intro v hv
  rw [← Finset.sum_filter_add_sum_filter_not v
    (fun ρ : NontrivialZeros => |(ρ : ℂ).im| < (2 : ℝ) ^ (n + 1))]
  refine add_le_add ?_ ?_
  · apply Finset.sum_le_sum_of_subset_of_nonneg
    · intro ρ hρ
      rw [FiniteOffLine.mem_ZF]
      exact (Finset.mem_filter.mp hρ).2
    · intro ρ _ _
      exact w_nonneg ρ
  · have hdy : ∀ ρ ∈ v.filter (fun ρ : NontrivialZeros => ¬ |(ρ : ℂ).im| < (2 : ℝ) ^ (n + 1)),
        σ ≤ (ρ : ℂ).re ∧ (2 : ℝ) ^ (n + 1) ≤ |(ρ : ℂ).im|
          ∧ (2 : ℝ) ^ (Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊) ≤ |(ρ : ℂ).im|
          ∧ |(ρ : ℂ).im| < 2 ^ (Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊ + 1) := by
      intro ρ hρ
      obtain ⟨hρv, hnot⟩ := Finset.mem_filter.mp hρ
      have hge : (2 : ℝ) ^ (n + 1) ≤ |(ρ : ℂ).im| := not_lt.mp hnot
      have h1 : (1 : ℝ) ≤ 2 ^ (n + 1) := one_le_pow₀ (by norm_num)
      exact ⟨hv ρ hρv, hge, dyadic_index (h1.trans hge)⟩
    rw [← Finset.sum_fiberwise_of_maps_to
      (g := fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊)
      (t := (v.filter (fun ρ : NontrivialZeros => ¬ |(ρ : ℂ).im| < (2 : ℝ) ^ (n + 1))).image
        (fun ρ : NontrivialZeros => Nat.log 2 ⌊|(ρ : ℂ).im|⌋₊))
      (fun x hx => Finset.mem_image_of_mem _ hx)]
    refine le_trans (Finset.sum_le_sum (fun j hj => ?_)) (hbs.sum_le_tsum _ (fun j _ => hb0 j))
    obtain ⟨ρ0, hρ0, hk0⟩ := Finset.mem_image.mp hj
    obtain ⟨-, hge0, -, hlt0⟩ := hdy ρ0 hρ0
    have hk0' : Nat.log 2 ⌊|(ρ0 : ℂ).im|⌋₊ = j := hk0
    rw [hk0'] at hlt0
    have hlt : (2 : ℝ) ^ (n + 1) < 2 ^ (j + 1) := lt_of_le_of_lt hge0 hlt0
    have hjn : n + 1 < j + 1 := (pow_lt_pow_iff_right₀ (by norm_num : (1 : ℝ) < 2)).mp hlt
    have hj1 : 1 ≤ j := by omega
    have hT : T₀ ≤ (2 : ℝ) ^ (j + 1) + 2 := by
      have : (2 : ℝ) ^ n ≤ 2 ^ (j + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
      linarith
    have hs := shell_sum_le hσ hd hj1 hT
      ((v.filter (fun ρ : NontrivialZeros => ¬ |(ρ : ℂ).im| < (2 : ℝ) ^ (n + 1))).filter
        (fun x => Nat.log 2 ⌊|(x : ℂ).im|⌋₊ = j)) (fun ρ hρ => by
          obtain ⟨hρW, hkj⟩ := Finset.mem_filter.mp hρ
          obtain ⟨hs, -, hlo, hhi⟩ := hdy ρ hρW
          rw [hkj] at hlo hhi
          exact ⟨hs, hlo, hhi⟩)
    refine hs.trans ?_
    rw [hb]
    exact shell_bound_le hC j

/-- **The zeros right of a line have summable weights.** For `σ > 1/2` the weights
`m(ρ)/|ρ|` of the nontrivial zeros of ζ with `Re ρ ≥ σ` form a summable family. -/
theorem summable_order_div {σ : ℝ} (hσ : 1 / 2 < σ) :
    Summable fun ρ : {ρ : Kadiri.NontrivialZeros // σ ≤ ((ρ : Kadiri.NontrivialZeros) : ℂ).re} =>
      ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℝ)
        / ‖((ρ : Kadiri.NontrivialZeros) : ℂ)‖ := by
  classical
  obtain ⟨M, hM⟩ := sum_le_const (σ := min σ 1) (lt_min hσ (by norm_num)) (min_le_right _ _)
  refine summable_of_sum_le (c := M) (fun ρ => w_nonneg ρ.1) (fun u => ?_)
  have key := hM (u.map (Function.Embedding.subtype _)) (fun ρ hρ => by
    obtain ⟨x, -, hx⟩ := Finset.mem_map.mp hρ
    rw [← hx]
    exact (min_le_left _ _).trans x.2)
  rw [Finset.sum_map] at key
  exact key

/-- The norm of the cell coefficient `LadderMean.coef ρ` is the weight `m(ρ)/|ρ|`. -/
theorem norm_coef (ρ : NontrivialZeros) : ‖LadderMean.coef ρ‖ = w ρ := by
  rw [LadderMean.coef, norm_div]
  have e : (((riemannZeta.order (ρ : ℂ) : ℤ)) : ℂ)
      = ((((riemannZeta.order (ρ : ℂ) : ℤ)) : ℝ) : ℂ) := (Complex.ofReal_intCast _).symm
  rw [e, Complex.norm_real, Real.norm_of_nonneg (FiniteOffLine.order_nonneg ρ)]
  rfl

/-- For `σ > 1/2` and any set `S` of nontrivial zeros all with `Re ρ ≥ σ`, the norms of the cell
coefficients `‖LadderMean.coef ρ‖` are summable over `S`. -/
theorem summable_norm_coef (S : Set NontrivialZeros) {σ : ℝ} (hσ : 1 / 2 < σ)
    (hS : ∀ ρ ∈ S, σ ≤ (ρ : ℂ).re) :
    Summable fun ρ : S => ‖LadderMean.coef ρ‖ := by
  classical
  obtain ⟨M, hM⟩ := sum_le_const (σ := min σ 1) (lt_min hσ (by norm_num)) (min_le_right _ _)
  refine summable_of_sum_le (c := M) (fun ρ => by rw [norm_coef]; exact w_nonneg ρ.1)
    (fun u => ?_)
  have key := hM (u.map (Function.Embedding.subtype _)) (fun ρ hρ => by
    obtain ⟨x, -, hx⟩ := Finset.mem_map.mp hρ
    rw [← hx]
    exact (min_le_left _ _).trans (hS x.1 x.2))
  rw [Finset.sum_map] at key
  simp only [norm_coef]
  exact key

/-- info: 'ZeroSummable.summable_order_div' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms summable_order_div

/-- info: 'ZeroSummable.summable_norm_coef' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms summable_norm_coef

/-- info: 'ZeroSummable.sum_le_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_le_const

end

end ZeroSummable
