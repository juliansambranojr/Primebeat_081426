/-
ZeroSum — step 4: the dyadic zero-count arithmetic under hNT.

The hNT leaf is IEANTN's `riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃`
(Rosser Th. 19 shape; the literature instantiates (0.137, 0.443, 6.1)).
O69 measured what it asserts: the angle count IS the logarithm curve, the
fluctuation under 2 windings in 10⁵. This module proves the counting
arithmetic that the explicit-formula assembly (step 5) consumes:

  N_abs_le             |N(T)| ≤ (T/2π)(log T + 3) + RvM(T) + 7/8
                       — the T·log T majorant with explicit constants,
                       the shape the census needs (entry 119: the
                       unconditional T^(3/2) majorant is dead here)
  dyadic_abs_N_sum_le  Σ_{j≤K} (2^j)⁻¹·|N(2^(j+1))|
                         ≤ (log 2/2π)(K+1)(K+2) + 3(K+1)/π
                           + 2(RvM(2^(K+1)) + 7/8)
                       — the (log T)² zero-sum arithmetic: the bound
                       that makes Σ 1/|ρ| ≤ c·(log T)² under RH

Slice 1 is pure real arithmetic from the hypothesis — no zero types.
Slice 2 (open) links the sum to Σ' over `NontrivialZeros` through
IEANTN's sorry-free `weighted_cumulative_count_le`.

Consumes (same tree, no weld): `zetaCountingMainTerm`, `riemannZeta.RvM`,
`riemannZeta.Riemann_vonMangoldt_bound` from
PrimeNumberTheoremAnd/IEANTN. The weld caveat from Stage3.lean applies
to composition with the bench. Companion to notes entry 124.
-/
import Mathlib
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting

namespace Stage3

open Finset Kadiri

noncomputable section

/-- `log(2π) ≤ 2`, i.e. `2π ≤ e²`. Carries the main-term constant. -/
theorem log_two_pi_le : Real.log (2 * Real.pi) ≤ 2 := by
  have hπ : Real.pi < 3.15 := Real.pi_lt_d2
  have he : (2.7182818283 : ℝ) < Real.exp 1 := Real.exp_one_gt_d9
  have hexp2 : Real.exp 2 = Real.exp 1 * Real.exp 1 := by
    rw [← Real.exp_add]
    norm_num
  rw [Real.log_le_iff_le_exp (by positivity)]
  nlinarith

/-- The RvM band is monotone in `T` on `[2, ∞)` for nonnegative `b₁, b₂`. -/
theorem RvM_mono {b₁ b₂ b₃ T T' : ℝ} (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂)
    (h2 : 2 ≤ T) (hTT' : T ≤ T') :
    riemannZeta.RvM b₁ b₂ b₃ T ≤ riemannZeta.RvM b₁ b₂ b₃ T' := by
  unfold riemannZeta.RvM
  have hlog : Real.log T ≤ Real.log T' :=
    Real.log_le_log (by linarith) hTT'
  have hlogpos : 0 < Real.log T := Real.log_pos (by linarith)
  have hloglog : Real.log (Real.log T) ≤ Real.log (Real.log T') :=
    Real.log_le_log hlogpos hlog
  have e1 : b₁ * Real.log T ≤ b₁ * Real.log T' :=
    mul_le_mul_of_nonneg_left hlog hb₁
  have e2 : b₂ * Real.log (Real.log T) ≤ b₂ * Real.log (Real.log T') :=
    mul_le_mul_of_nonneg_left hloglog hb₂
  linarith

/-- The main term is at most `(T/2π)(log T + 3) + 7/8` in absolute value:
`|log(T/2π)| ≤ log T + log 2π ≤ log T + 2`. -/
theorem abs_mainterm_le {T : ℝ} (h2 : 2 ≤ T) :
    |zetaCountingMainTerm T| ≤ T / (2 * Real.pi) * (Real.log T + 3) + 7 / 8 := by
  unfold zetaCountingMainTerm
  have hπ : 0 < Real.pi := Real.pi_pos
  have hA : 0 < T / (2 * Real.pi) := by positivity
  have hlogT : 0 < Real.log T := Real.log_pos (by linarith)
  have hdiv : Real.log (T / (2 * Real.pi))
      = Real.log T - Real.log (2 * Real.pi) :=
    Real.log_div (by linarith) (by positivity)
  have hlog2π : 0 < Real.log (2 * Real.pi) := by
    apply Real.log_pos
    nlinarith [Real.pi_gt_three]
  have habs : |Real.log (T / (2 * Real.pi))| ≤ Real.log T + 2 := by
    rw [hdiv, abs_sub_le_iff]
    constructor <;> nlinarith [log_two_pi_le]
  have t1 : |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
        - T / (2 * Real.pi) + 7 / 8|
      ≤ |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
        - T / (2 * Real.pi)| + 7 / 8 := by
    refine le_trans (abs_add_le _ _) ?_
    norm_num
  have t2 : |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
        - T / (2 * Real.pi)|
      ≤ |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))|
        + T / (2 * Real.pi) := by
    calc |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi)) - T / (2 * Real.pi)|
        = |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
          + -(T / (2 * Real.pi))| := by ring_nf
      _ ≤ |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))|
          + |-(T / (2 * Real.pi))| := abs_add_le _ _
      _ = |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))|
          + T / (2 * Real.pi) := by rw [abs_neg, abs_of_pos hA]
  have t3 : |T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))|
      ≤ T / (2 * Real.pi) * (Real.log T + 2) := by
    rw [abs_mul, abs_of_pos hA]
    exact mul_le_mul_of_nonneg_left habs hA.le
  linarith

/-- **The T·log T majorant under hNT, explicit:**
`|N(T)| ≤ (T/2π)(log T + 3) + RvM(T) + 7/8`. This is the count shape the
census needs — the unconditional route only gives `T^(3/2)`. -/
theorem N_abs_le {b₁ b₂ b₃ T : ℝ}
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃) (h2 : 2 ≤ T) :
    |riemannZeta.N T|
      ≤ T / (2 * Real.pi) * (Real.log T + 3)
        + riemannZeta.RvM b₁ b₂ b₃ T + 7 / 8 := by
  have hband := hNT T h2
  have htri : |riemannZeta.N T|
      ≤ |riemannZeta.N T
          - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
            - T / (2 * Real.pi) + 7 / 8)|
        + |zetaCountingMainTerm T| := by
    unfold zetaCountingMainTerm
    calc |riemannZeta.N T|
        = |(riemannZeta.N T
            - (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
              - T / (2 * Real.pi) + 7 / 8))
          + (T / (2 * Real.pi) * Real.log (T / (2 * Real.pi))
            - T / (2 * Real.pi) + 7 / 8)| := by ring_nf
      _ ≤ _ := abs_add_le _ _
  have hmain := abs_mainterm_le h2
  linarith

/-- Gauss sum over ℝ: `Σ_{j<n} (j+1) = n(n+1)/2`. -/
theorem sum_range_add_one (n : ℕ) :
    (∑ j ∈ range n, ((j : ℝ) + 1)) = n * (n + 1) / 2 := by
  induction n with
  | zero => simp
  | succ m ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      ring

/-- Geometric tail: `Σ_{j<n} (2^j)⁻¹ ≤ 2`. -/
theorem sum_inv_pow_two_le (n : ℕ) :
    (∑ j ∈ range n, ((2 : ℝ) ^ j)⁻¹) ≤ 2 := by
  have h1 : ∀ m : ℕ, (∑ j ∈ range m, ((2 : ℝ) ^ j)⁻¹)
      = 2 - 2 * ((2 : ℝ) ^ m)⁻¹ := by
    intro m
    induction m with
    | zero => norm_num
    | succ p ihp =>
        rw [Finset.sum_range_succ, ihp, pow_succ, mul_inv]
        have hp : ((2 : ℝ) ^ p) ≠ 0 := by positivity
        field_simp
        ring
  rw [h1 n]
  have hn : (0 : ℝ) < ((2 : ℝ) ^ n)⁻¹ := by positivity
  linarith

/-- **The dyadic zero-count sum under hNT — the (log T)² arithmetic:**
`Σ_{j≤K} (2^j)⁻¹·|N(2^(j+1))| ≤ (log 2/2π)(K+1)(K+2) + 3(K+1)/π
+ 2(RvM(2^(K+1)) + 7/8)`. Leading constant `log 2/2π`: the classical
`Σ 1/γ ~ (log T)²/4π` up to the dyadic overcount. -/
theorem dyadic_abs_N_sum_le {b₁ b₂ b₃ : ℝ}
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂)
    (hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2)
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃) (K : ℕ) :
    (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|)
      ≤ Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2)
        + 3 * (K + 1) / Real.pi
        + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) + 7 / 8) := by
  have hπ : 0 < Real.pi := Real.pi_pos
  set B : ℝ := riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) + 7 / 8 with hB
  have hBpos : 0 ≤ B := by
    have h22 : (2 : ℝ) ≤ (2 : ℝ) ^ (K + 1) := by
      calc (2 : ℝ) = 2 ^ 1 := by norm_num
        _ ≤ 2 ^ (K + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
    have := RvM_mono (b₃ := b₃) hb₁ hb₂ (le_refl (2 : ℝ)) h22
    simp only [hB]
    linarith
  -- per-term bound
  have hterm : ∀ j ∈ range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|
        ≤ (((j : ℝ) + 1) * Real.log 2 + 3) / Real.pi
          + ((2 : ℝ) ^ j)⁻¹ * B := by
    intro j hj
    have hjK : j ≤ K := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
    have hT2 : (2 : ℝ) ≤ (2 : ℝ) ^ (j + 1) := by
      calc (2 : ℝ) = 2 ^ 1 := by norm_num
        _ ≤ 2 ^ (j + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
    have hN := N_abs_le hNT hT2
    have hlogpow : Real.log ((2 : ℝ) ^ (j + 1)) = ((j : ℝ) + 1) * Real.log 2 := by
      rw [Real.log_pow]
      push_cast
      ring
    have hmono : riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (j + 1))
        ≤ riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) :=
      RvM_mono hb₁ hb₂ hT2 (pow_le_pow_right₀ (by norm_num) (by omega))
    have hinv : (0 : ℝ) < ((2 : ℝ) ^ j)⁻¹ := by positivity
    have hstep : ((2 : ℝ) ^ j)⁻¹ * ((2 : ℝ) ^ (j + 1)) = 2 := by
      rw [pow_succ]
      have : (0 : ℝ) < 2 ^ j := by positivity
      field_simp
    calc ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|
        ≤ ((2 : ℝ) ^ j)⁻¹
            * ((2 : ℝ) ^ (j + 1) / (2 * Real.pi)
              * (Real.log ((2 : ℝ) ^ (j + 1)) + 3)
              + riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (j + 1)) + 7 / 8) :=
          mul_le_mul_of_nonneg_left hN hinv.le
      _ ≤ ((2 : ℝ) ^ j)⁻¹
            * ((2 : ℝ) ^ (j + 1) / (2 * Real.pi)
              * (Real.log ((2 : ℝ) ^ (j + 1)) + 3) + B) := by
          apply mul_le_mul_of_nonneg_left _ hinv.le
          simp only [hB]
          linarith
      _ = (((j : ℝ) + 1) * Real.log 2 + 3) / Real.pi
            + ((2 : ℝ) ^ j)⁻¹ * B := by
          rw [hlogpow, mul_add]
          congr 1
          have hpow : (0 : ℝ) < 2 ^ j := by positivity
          field_simp
          ring
  refine le_trans (Finset.sum_le_sum hterm) ?_
  rw [Finset.sum_add_distrib, ← Finset.sum_mul]
  have hgauss : (∑ j ∈ range (K + 1), (((j : ℝ) + 1) * Real.log 2 + 3) / Real.pi)
      = (Real.log 2 * ((K + 1) * (K + 2) / 2) + 3 * (K + 1)) / Real.pi := by
    rw [← Finset.sum_div]
    congr 1
    have h1 : (∑ j ∈ range (K + 1), (((j : ℝ) + 1) * Real.log 2 + 3))
        = (∑ j ∈ range (K + 1), ((j : ℝ) + 1)) * Real.log 2 + 3 * (K + 1) := by
      rw [Finset.sum_add_distrib, ← Finset.sum_mul]
      simp [Finset.sum_const, Finset.card_range]
      ring
    rw [h1, sum_range_add_one]
    push_cast
    ring
  rw [hgauss]
  have hgeom : (∑ j ∈ range (K + 1), ((2 : ℝ) ^ j)⁻¹) * B ≤ 2 * B :=
    mul_le_mul_of_nonneg_right (sum_inv_pow_two_le (K + 1)) hBpos
  have hexpand : (Real.log 2 * ((K + 1) * (K + 2) / 2) + 3 * (K + 1)) / Real.pi
      = Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2)
        + 3 * (K + 1) / Real.pi := by
    field_simp
  rw [hexpand]
  linarith

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.log_two_pi_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.log_two_pi_le

/-- info: 'Stage3.RvM_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.RvM_mono

/-- info: 'Stage3.abs_mainterm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.abs_mainterm_le

/-- info: 'Stage3.N_abs_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.N_abs_le

/-- info: 'Stage3.sum_range_add_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.sum_range_add_one

/-- info: 'Stage3.sum_inv_pow_two_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.sum_inv_pow_two_le

/-- info: 'Stage3.dyadic_abs_N_sum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.dyadic_abs_N_sum_le

end Stage3
