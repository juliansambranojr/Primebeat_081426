/-
Assembly — step 5, slice 1: RH meets the zero sum.

The explicit formula's zero side is `Σ_{|γ|<T} m(ρ)·x^ρ/ρ`. This module
defines that sum (`zeroPartialSum`), states the hEF leaf
(`StmtExplicitFormula` — the truncated explicit formula with explicit
remainder, the one genuinely open piece), and proves what RH does to the
zero side, kernel-checked:

  re_eq_half_of_RH        every nontrivial zero has `re = 1/2`
  norm_cpow_of_RH         `‖x^ρ‖ = √x` — the RH collapse
  norm_term_le_of_RH      `‖x^ρ/ρ‖ ≤ 2√x` from `|ρ| ≥ 1/2`
  norm_zeroPartialSum_le  ‖zeroPartialSum x 2^(K+1)‖
                            ≤ 2√x·(2|N(2^(K+1))| + W)
                          — the zero side controlled by the count,
                          through IEANTN's sorry-free
                          `weighted_cumulative_count_le`

With ZeroSum's `N_abs_le` this bounds the zero side by
`√x · T·log T`-arithmetic under hNT. The dyadic refinement is half
done: `inv_le_dyadic_sum` (scalar domination by indicator weights) and
`norm_term_le_dyadic` (per-zero dyadic bound) are proved; what remains
is the sum swap plus the per-level identification
`Σ_{ρ:|γ|<2^(K+1)} m·[|γ|<2^(j+1)] = Σ_{ρ:|γ|<2^(j+1)} m` — route:
`Fintype.sum_equiv` with `Equiv.subtypeSubtypeEquivSubtype`, bridging
filter and subtype via `Finset.sum_filter` and `subtypeEquivRight` —
then `weighted_cumulative_count_le` per level and ZeroSum's
`dyadic_abs_N_sum_le` close the √x·(log T)² bound. After that: the
assembly — hRH + hEF + hNT → `StmtPsiWeak`, closing into PsiToPi's
transfer.

Consumes (same tree, no weld): `NontrivialZeros`, `riemannZeta.order`,
`weighted_cumulative_count_le`, `nontrivialZeros_abs_im_lt_finite` from
PrimeNumberTheoremAnd/IEANTN; `RiemannHypothesis` from Mathlib. The
weld caveat from Stage3.lean applies to composition with the bench.
Companion to notes entry 125.
-/
import Mathlib
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting
import Stage3.ZeroSum

namespace Stage3

open Kadiri Complex Chebyshev
open scoped Chebyshev

noncomputable section

/-- **Under RH every nontrivial zero sits on the critical line.** The
strip membership rules out the trivial zeros and `s = 1`, so Mathlib's
`RiemannHypothesis` applies directly. -/
theorem re_eq_half_of_RH (hRH : RiemannHypothesis) (ρ : NontrivialZeros) :
    (ρ : ℂ).re = 1 / 2 := by
  have hre : (ρ : ℂ).re ∈ Set.Ioo (0 : ℝ) 1 := ρ.property.1
  have hzero : riemannZeta (ρ : ℂ) = 0 := ρ.property.2.2
  refine hRH (ρ : ℂ) hzero ?_ (nontrivialZero_ne_one ρ)
  rintro ⟨n, hn⟩
  have h0 : (0 : ℝ) < (ρ : ℂ).re := hre.1
  rw [hn] at h0
  simp at h0
  all_goals nlinarith [Nat.cast_nonneg (α := ℝ) n]

/-- Under RH, `|ρ| ≥ 1/2`. -/
theorem half_le_norm_of_RH (hRH : RiemannHypothesis) (ρ : NontrivialZeros) :
    1 / 2 ≤ ‖(ρ : ℂ)‖ := by
  calc (1 : ℝ) / 2 = |(ρ : ℂ).re| := by
        rw [re_eq_half_of_RH hRH ρ]
        norm_num
    _ ≤ ‖(ρ : ℂ)‖ := Complex.abs_re_le_norm _

/-- **The RH collapse:** `‖x^ρ‖ = √x` for `x > 0`. -/
theorem norm_cpow_of_RH (hRH : RiemannHypothesis) (ρ : NontrivialZeros)
    {x : ℝ} (hx : 0 < x) :
    ‖(x : ℂ) ^ (ρ : ℂ)‖ = Real.sqrt x := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hx, re_eq_half_of_RH hRH ρ,
    Real.sqrt_eq_rpow]

/-- Each zero term is at most `2√x` in norm, from `|ρ| ≥ 1/2`. -/
theorem norm_term_le_of_RH (hRH : RiemannHypothesis) (ρ : NontrivialZeros)
    {x : ℝ} (hx : 0 < x) :
    ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖ ≤ 2 * Real.sqrt x := by
  rw [norm_div, norm_cpow_of_RH hRH ρ hx]
  have h2 := half_le_norm_of_RH hRH ρ
  have hpos : 0 < ‖(ρ : ℂ)‖ := lt_of_lt_of_le (by norm_num) h2
  rw [div_le_iff₀ hpos]
  have hs := Real.sqrt_nonneg x
  nlinarith

/-- The order-weighted partial zero sum below height `T`:
`Σ_{|γ|<T} m(ρ)·x^ρ/ρ`. -/
def zeroPartialSum (x T : ℝ) : ℂ :=
  ∑' ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < T},
    ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)
      * ((x : ℂ) ^ ((ρ : NontrivialZeros) : ℂ) / ((ρ : NontrivialZeros) : ℂ))

/-- **The hEF leaf — the truncated explicit formula with explicit
remainder.** The one genuinely open analytic input of stage 3 (entry
119): every proof assistant lacks it; IEANTN targets it. Stated over
Mathlib's Chebyshev `ψ` and the order-weighted partial sum. -/
def StmtExplicitFormula (c₁ c₂ x₁ : ℝ) : Prop :=
  ∀ x T : ℝ, x₁ ≤ x → 2 ≤ T →
    ‖((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T‖
      ≤ c₁ * x * Real.log (x * T) ^ 2 / T + c₂ * Real.log x

/-- **The zero side controlled by the count, under RH:**
`‖zeroPartialSum x 2^(K+1)‖ ≤ 2√x·(2|N(2^(K+1))| + W)`, through
IEANTN's sorry-free `weighted_cumulative_count_le`. With ZeroSum's
`N_abs_le` this is `√x`·(T·log T)-arithmetic under hNT. -/
theorem norm_zeroPartialSum_le (hRH : RiemannHypothesis)
    {x : ℝ} (hx : 0 < x) (K : ℕ) :
    ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖
      ≤ 2 * Real.sqrt x
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (K + 1))|
            + weightedZeroHeightBucket) := by
  classical
  haveI : Fintype {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)} :=
    (nontrivialZeros_abs_im_lt_finite ((2 : ℝ) ^ (K + 1))).fintype
  rw [zeroPartialSum, tsum_fintype]
  refine le_trans (norm_sum_le _ _) ?_
  have hterm : ∀ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
      ‖((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)
          * ((x : ℂ) ^ ((ρ : NontrivialZeros) : ℂ) / ((ρ : NontrivialZeros) : ℂ))‖
        ≤ ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
            * (2 * Real.sqrt x) := by
    intro ρ
    rw [norm_mul]
    have hnn : (0 : ℝ)
        ≤ ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ) := by
      exact_mod_cast riemannZeta_order_nonneg (nontrivialZero_ne_one ρ.1)
    have hcast : ‖((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)‖
        = ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ) := by
      rw [Complex.norm_intCast]
      exact abs_of_nonneg (by exact_mod_cast hnn)
    rw [hcast]
    exact mul_le_mul_of_nonneg_left (norm_term_le_of_RH hRH ρ.1 hx) hnn
  refine le_trans (Finset.sum_le_sum fun ρ _ => hterm ρ) ?_
  rw [← Finset.sum_mul]
  have hcount := weighted_cumulative_count_le (k := K)
  rw [tsum_fintype] at hcount
  have h2s : (0 : ℝ) ≤ 2 * Real.sqrt x := by positivity
  calc (∑ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
        ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ))
          * (2 * Real.sqrt x)
      ≤ (2 * |riemannZeta.N ((2 : ℝ) ^ (K + 1))| + weightedZeroHeightBucket)
          * (2 * Real.sqrt x) :=
        mul_le_mul_of_nonneg_right hcount h2s
    _ = 2 * Real.sqrt x
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (K + 1))|
            + weightedZeroHeightBucket) := by ring

/-- **Scalar dyadic domination:** for `1 ≤ γ < 2^(K+1)`,
`γ⁻¹ ≤ Σ_{j≤K} (2^j)⁻¹·[γ < 2^(j+1)]` — the largest surviving indicator
sits at the shell containing `γ`, and its weight already dominates. -/
theorem inv_le_dyadic_sum (K : ℕ) :
    ∀ γ : ℝ, 1 ≤ γ → γ < 2 ^ (K + 1) →
      γ⁻¹ ≤ ∑ j ∈ Finset.range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if γ < 2 ^ (j + 1) then 1 else 0) := by
  induction K with
  | zero =>
      intro γ h1 h2
      simp only [zero_add, Finset.sum_range_one, pow_zero, inv_one, one_mul, pow_one]
      rw [if_pos (by simpa using h2)]
      exact inv_le_one_of_one_le₀ h1
  | succ M ih =>
      intro γ h1 h2
      rw [Finset.sum_range_succ]
      by_cases hcase : γ < 2 ^ (M + 1)
      · have hih := ih γ h1 hcase
        have hnn : (0 : ℝ) ≤ ((2 : ℝ) ^ (M + 1))⁻¹
            * (if γ < 2 ^ (M + 1 + 1) then 1 else 0) := by
          have : (0 : ℝ) ≤ (if γ < 2 ^ (M + 1 + 1) then (1 : ℝ) else 0) := by
            split <;> norm_num
          positivity
        linarith
      · push_neg at hcase
        have hterm : ((2 : ℝ) ^ (M + 1))⁻¹
            * (if γ < 2 ^ (M + 1 + 1) then (1 : ℝ) else 0)
            = ((2 : ℝ) ^ (M + 1))⁻¹ := by
          rw [if_pos h2, mul_one]
        have hrest : (0 : ℝ) ≤ ∑ j ∈ Finset.range (M + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if γ < 2 ^ (j + 1) then 1 else 0) := by
          apply Finset.sum_nonneg
          intro j _
          have : (0 : ℝ) ≤ (if γ < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
            split <;> norm_num
          positivity
        have hinv : γ⁻¹ ≤ ((2 : ℝ) ^ (M + 1))⁻¹ := by
          have hp : (0 : ℝ) < 2 ^ (M + 1) := by positivity
          exact inv_anti₀ hp hcase
        linarith

/-- Each zero term is dominated by the dyadic indicator weights:
`‖x^ρ/ρ‖ ≤ 2√x·Σ_{j≤K} (2^j)⁻¹·[|γ| < 2^(j+1)]` for `|γ| < 2^(K+1)`. -/
theorem norm_term_le_dyadic (hRH : RiemannHypothesis) (ρ : NontrivialZeros)
    {x : ℝ} (hx : 0 < x) (K : ℕ) (him : |(ρ : ℂ).im| < 2 ^ (K + 1)) :
    ‖(x : ℂ) ^ (ρ : ℂ) / (ρ : ℂ)‖
      ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1),
          ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
  rw [norm_div, norm_cpow_of_RH hRH ρ hx]
  have hs := Real.sqrt_nonneg x
  have hρpos : 0 < ‖(ρ : ℂ)‖ :=
    lt_of_lt_of_le (by norm_num) (half_le_norm_of_RH hRH ρ)
  have hSnn : (0 : ℝ) ≤ ∑ j ∈ Finset.range (K + 1),
      ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
    apply Finset.sum_nonneg
    intro j _
    have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
      split <;> norm_num
    positivity
  by_cases hγ : 1 ≤ |(ρ : ℂ).im|
  · have hd := inv_le_dyadic_sum K _ hγ him
    have hγρ : |(ρ : ℂ).im| ≤ ‖(ρ : ℂ)‖ := Complex.abs_im_le_norm _
    have hγpos : (0 : ℝ) < |(ρ : ℂ).im| := by linarith
    have hinv : ‖(ρ : ℂ)‖⁻¹ ≤ |(ρ : ℂ).im|⁻¹ :=
      inv_anti₀ hγpos hγρ
    calc Real.sqrt x / ‖(ρ : ℂ)‖ = Real.sqrt x * ‖(ρ : ℂ)‖⁻¹ := by
          rw [div_eq_mul_inv]
      _ ≤ Real.sqrt x * |(ρ : ℂ).im|⁻¹ :=
          mul_le_mul_of_nonneg_left hinv hs
      _ ≤ Real.sqrt x * ∑ j ∈ Finset.range (K + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) :=
          mul_le_mul_of_nonneg_left hd hs
      _ ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1),
            ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
          nlinarith
  · push_neg at hγ
    have hS1 : (1 : ℝ) ≤ ∑ j ∈ Finset.range (K + 1),
        ((2 : ℝ) ^ j)⁻¹ * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then 1 else 0) := by
      have h0mem : (0 : ℕ) ∈ Finset.range (K + 1) := by
        simp
      have h0term : ((2 : ℝ) ^ (0 : ℕ))⁻¹
          * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) = 1 := by
        rw [if_pos (by norm_num; linarith), pow_zero, inv_one, mul_one]
      calc (1 : ℝ) = ((2 : ℝ) ^ (0 : ℕ))⁻¹
            * (if |(ρ : ℂ).im| < 2 ^ (0 + 1) then (1 : ℝ) else 0) := h0term.symm
        _ ≤ _ := by
            apply Finset.single_le_sum (f := fun j => ((2 : ℝ) ^ j)⁻¹
              * (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0)) _ h0mem
            intro j _
            have : (0 : ℝ) ≤ (if |(ρ : ℂ).im| < 2 ^ (j + 1) then (1 : ℝ) else 0) := by
              split <;> norm_num
            positivity
    have h2ρ : Real.sqrt x / ‖(ρ : ℂ)‖ ≤ 2 * Real.sqrt x := by
      rw [div_le_iff₀ hρpos]
      have h2 := half_le_norm_of_RH hRH ρ
      nlinarith
    calc Real.sqrt x / ‖(ρ : ℂ)‖ ≤ 2 * Real.sqrt x := h2ρ
      _ = 2 * Real.sqrt x * 1 := by ring
      _ ≤ 2 * Real.sqrt x * _ :=
          mul_le_mul_of_nonneg_left hS1 (by positivity)

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.re_eq_half_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.re_eq_half_of_RH

/-- info: 'Stage3.half_le_norm_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.half_le_norm_of_RH

/-- info: 'Stage3.norm_cpow_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_cpow_of_RH

/-- info: 'Stage3.norm_term_le_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_term_le_of_RH

/-- info: 'Stage3.inv_le_dyadic_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.inv_le_dyadic_sum

/-- info: 'Stage3.norm_term_le_dyadic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_term_le_dyadic

/-- info: 'Stage3.norm_zeroPartialSum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_zeroPartialSum_le

end Stage3
