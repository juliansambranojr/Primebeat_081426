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
import Stage3.PsiToPi

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

/-- **The `T ≤ x²`-regime form** — the shape the contour proof
delivers (`Glue.explicit_formula_poly`) and all the assembly consumes
(`T = 2^(K+1) ≤ 2x ≤ x²`). Approved leaf-shape change (entry 271). -/
def StmtExplicitFormulaPoly (c₁ c₂ x₁ : ℝ) : Prop :=
  ∀ x T : ℝ, x₁ ≤ x → 2 ≤ T → T ≤ x^2 →
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

/-- **The sharp zero-side bound, dyadic form.** Under RH, the zero side
is controlled level by level: each level's weighted count enters through
IEANTN's sorry-free `weighted_cumulative_count_le`, reached by the
scalar domination — no shell partition anywhere. -/
theorem norm_zeroPartialSum_le_sharp (hRH : RiemannHypothesis)
    {x : ℝ} (hx : 0 < x) (K : ℕ) :
    ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖
      ≤ 2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1),
          ((2 : ℝ) ^ j)⁻¹
            * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|
              + weightedZeroHeightBucket) := by
  classical
  haveI : Fintype {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)} :=
    (nontrivialZeros_abs_im_lt_finite ((2 : ℝ) ^ (K + 1))).fintype
  rw [zeroPartialSum, tsum_fintype]
  refine le_trans (norm_sum_le _ _) ?_
  have hm : ∀ ρ : NontrivialZeros,
      (0 : ℝ) ≤ ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) :=
    fun ρ => by
      exact_mod_cast riemannZeta_order_nonneg (nontrivialZero_ne_one ρ)
  have hterm : ∀ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
      ‖((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)
          * ((x : ℂ) ^ ((ρ : NontrivialZeros) : ℂ) / ((ρ : NontrivialZeros) : ℂ))‖
        ≤ ∑ j ∈ Finset.range (K + 1),
            2 * Real.sqrt x * (((2 : ℝ) ^ j)⁻¹
              * (((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
                * (if |((ρ : NontrivialZeros) : ℂ).im| < 2 ^ (j + 1) then 1 else 0))) := by
    intro ρ
    rw [norm_mul]
    have hcast : ‖((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℂ)‖
        = ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ) := by
      rw [Complex.norm_intCast]
      exact abs_of_nonneg (by exact_mod_cast hm ρ.1)
    rw [hcast]
    have hd := norm_term_le_dyadic hRH ρ.1 hx K ρ.2
    calc ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
          * ‖(x : ℂ) ^ ((ρ : NontrivialZeros) : ℂ) / ((ρ : NontrivialZeros) : ℂ)‖
        ≤ ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
            * (2 * Real.sqrt x * ∑ j ∈ Finset.range (K + 1),
                ((2 : ℝ) ^ j)⁻¹
                  * (if |((ρ : NontrivialZeros) : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) :=
          mul_le_mul_of_nonneg_left hd (hm ρ.1)
      _ = _ := by
          rw [Finset.mul_sum, Finset.mul_sum]
          exact Finset.sum_congr rfl fun j _ => by ring
  refine le_trans (Finset.sum_le_sum fun ρ _ => hterm ρ) ?_
  rw [Finset.sum_comm, Finset.mul_sum]
  refine Finset.sum_le_sum fun j hj => ?_
  have hjK : j ≤ K := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  haveI : Fintype {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (j + 1)} :=
    (nontrivialZeros_abs_im_lt_finite ((2 : ℝ) ^ (j + 1))).fintype
  have hle : (2 : ℝ) ^ (j + 1) ≤ (2 : ℝ) ^ (K + 1) :=
    pow_le_pow_right₀ (by norm_num) (by omega)
  have hinner : (∑ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
        ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
          * (if |((ρ : NontrivialZeros) : ℂ).im| < 2 ^ (j + 1) then 1 else 0))
      = ∑ σ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (j + 1)},
          ((riemannZeta.order ((σ : NontrivialZeros) : ℂ) : ℤ) : ℝ) := by
    simp only [mul_ite, mul_one, mul_zero]
    rw [← Finset.sum_filter]
    refine Finset.sum_bij'
      (fun ρ hρ => (⟨ρ.1, (Finset.mem_filter.mp hρ).2⟩ :
        {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (j + 1)}))
      (fun σ _ => (⟨σ.1, lt_of_lt_of_le σ.2 hle⟩ :
        {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)}))
      ?_ ?_ ?_ ?_ ?_
    · intro a _
      exact Finset.mem_univ _
    · intro σ _
      rw [Finset.mem_filter]
      exact ⟨Finset.mem_univ _, σ.2⟩
    · intro a _
      rfl
    · intro σ _
      rfl
    · intro a _
      rfl
  calc (∑ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
        2 * Real.sqrt x * (((2 : ℝ) ^ j)⁻¹
          * (((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
            * (if |((ρ : NontrivialZeros) : ℂ).im| < 2 ^ (j + 1) then 1 else 0))))
      = 2 * Real.sqrt x * (((2 : ℝ) ^ j)⁻¹
          * ∑ ρ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (K + 1)},
            ((riemannZeta.order ((ρ : NontrivialZeros) : ℂ) : ℤ) : ℝ)
              * (if |((ρ : NontrivialZeros) : ℂ).im| < 2 ^ (j + 1) then 1 else 0)) := by
        rw [Finset.mul_sum, Finset.mul_sum]
    _ = 2 * Real.sqrt x * (((2 : ℝ) ^ j)⁻¹
          * ∑ σ : {ρ : NontrivialZeros // |(ρ : ℂ).im| < (2 : ℝ) ^ (j + 1)},
            ((riemannZeta.order ((σ : NontrivialZeros) : ℂ) : ℤ) : ℝ)) := by
        rw [hinner]
    _ ≤ 2 * Real.sqrt x * (((2 : ℝ) ^ j)⁻¹
          * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket)) := by
        have hc := weighted_cumulative_count_le (k := j)
        rw [tsum_fintype] at hc
        have h1 : (0 : ℝ) ≤ ((2 : ℝ) ^ j)⁻¹ := by positivity
        have h2 : (0 : ℝ) ≤ 2 * Real.sqrt x := by positivity
        exact mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left hc h1) h2

/-- **The zero side at `√x·(log T)²`, under RH + hNT — the sharp form.**
Combining the dyadic bound with ZeroSum's counting arithmetic: with
`T = 2^(K+1)`, the zero side is at most
`2√x·(2·[(log 2/2π)(K+1)(K+2) + 3(K+1)/π + 2(RvM(T) + 7/8)] + 2W)`. -/
theorem norm_zeroPartialSum_le_logsq (hRH : RiemannHypothesis)
    {b₁ b₂ b₃ : ℝ} (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂)
    (hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2)
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃)
    {x : ℝ} (hx : 0 < x) (K : ℕ) :
    ‖zeroPartialSum x ((2 : ℝ) ^ (K + 1))‖
      ≤ 2 * Real.sqrt x
          * (2 * (Real.log 2 / (2 * Real.pi) * (K + 1) * (K + 2)
                + 3 * (K + 1) / Real.pi
                + 2 * (riemannZeta.RvM b₁ b₂ b₃ ((2 : ℝ) ^ (K + 1)) + 7 / 8))
            + 2 * weightedZeroHeightBucket) := by
  refine le_trans (norm_zeroPartialSum_le_sharp hRH hx K) ?_
  have hW : (0 : ℝ) ≤ weightedZeroHeightBucket := weightedZeroHeightBucket_nonneg
  have hsplit : (∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹
        * (2 * |riemannZeta.N ((2 : ℝ) ^ (j + 1))| + weightedZeroHeightBucket))
      = 2 * (∑ j ∈ Finset.range (K + 1),
          ((2 : ℝ) ^ j)⁻¹ * |riemannZeta.N ((2 : ℝ) ^ (j + 1))|)
        + weightedZeroHeightBucket
          * ∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹ := by
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun j _ => by ring
  have hD := dyadic_abs_N_sum_le hb₁ hb₂ hRvM2 hNT K
  have hgeo := sum_inv_pow_two_le (K + 1)
  have hWs : weightedZeroHeightBucket
        * (∑ j ∈ Finset.range (K + 1), ((2 : ℝ) ^ j)⁻¹)
      ≤ weightedZeroHeightBucket * 2 :=
    mul_le_mul_of_nonneg_left hgeo hW
  have h2s : (0 : ℝ) ≤ 2 * Real.sqrt x := by positivity
  refine mul_le_mul_of_nonneg_left ?_ h2s
  rw [hsplit]
  linarith

/-- Scalar arithmetic of the remainder: `x ≤ T`, `0 ≤ G ≤ 3L`, `1 ≤ L`
give `c₁·x·G²/T + c₂·L ≤ (9c₁+c₂)·L²`. -/
theorem rem_arith {c₁ c₂ xx TT G L : ℝ} (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂)
    (hx0 : 0 ≤ xx) (hT0 : 0 < TT) (hxT : xx ≤ TT)
    (hG0 : 0 ≤ G) (hG : G ≤ 3 * L) (hL : 1 ≤ L) :
    c₁ * xx * G ^ 2 / TT + c₂ * L ≤ (9 * c₁ + c₂) * L ^ 2 := by
  have hdiv : xx / TT ≤ 1 := by rw [div_le_one hT0]; exact hxT
  have hsq : G ^ 2 ≤ 9 * L ^ 2 := by nlinarith
  have h1 : c₁ * xx * G ^ 2 / TT = c₁ * G ^ 2 * (xx / TT) := by ring
  have h2 : c₁ * G ^ 2 * (xx / TT) ≤ c₁ * G ^ 2 :=
    mul_le_of_le_one_right (by positivity) hdiv
  have h3 : c₁ * G ^ 2 ≤ 9 * c₁ * L ^ 2 := by
    nlinarith [mul_nonneg hc₁ (sub_nonneg.mpr hsq)]
  have h4 : c₂ * L ≤ c₂ * L ^ 2 := by
    nlinarith [mul_nonneg hc₂ (sub_nonneg.mpr (by nlinarith : L ≤ L ^ 2))]
  rw [h1]
  linarith

/-- Scalar arithmetic of the zero side's inner factor: the dyadic level
bounds and the RvM bound turn the `(K, RvM)` expression into
`2·(7+4b₁+4b₂+2b₃)·L² + 2W`. -/
theorem zeroinner_arith {b₁ b₂ b₃ W R KK L : ℝ}
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂) (hb₃ : 0 ≤ b₃)
    (hL : 1 ≤ L) (hKK0 : 0 ≤ KK)
    (hK1 : (KK + 1) * Real.log 2 ≤ 2 * L)
    (hK2 : (KK + 2) * Real.log 2 ≤ 3 * L)
    (hR : R ≤ (2 * b₁ + 2 * b₂ + b₃) * L ^ 2) :
    2 * (Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2)
        + 3 * (KK + 1) / Real.pi + 2 * (R + 7 / 8)) + 2 * W
      ≤ 2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W := by
  have hlog2lo : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hlog2hi : Real.log 2 < 0.6931471808 := Real.log_two_lt_d9
  have hπ : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hK1' : KK + 1 ≤ 3 * L := by nlinarith
  have hK2' : KK + 2 ≤ 5 * L := by nlinarith
  have hA : (KK + 1) * (KK + 2) ≤ 15 * L ^ 2 := by nlinarith
  have hP1 : Real.log 2 / (2 * Real.pi) * (KK + 1) * (KK + 2) ≤ 2 * L ^ 2 := by
    rw [div_mul_eq_mul_div, div_mul_eq_mul_div, div_le_iff₀ (by positivity)]
    have h1 : Real.log 2 * (KK + 1) * (KK + 2) ≤ 0.6931471808 * (15 * L ^ 2) := by
      nlinarith
    nlinarith [sq_nonneg L]
  have hP2 : 3 * (KK + 1) / Real.pi ≤ 3 * L ^ 2 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  nlinarith [sq_nonneg L]

/-- Scalar arithmetic of the final absorption into `C·S·L²`. -/
theorem assembly_arith {c₁ c₂ b₁ b₂ b₃ W A S L : ℝ}
    (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂) (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂)
    (hb₃ : 0 ≤ b₃) (hW : 0 ≤ W) (hS : 4 ≤ S) (hL : 1 ≤ L)
    (hA : A ≤ (9 * c₁ + c₂) * L ^ 2
        + 2 * S * (2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W)) :
    A ≤ (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃ + 4 * W) * S * L ^ 2 := by
  have hS0 : (0 : ℝ) ≤ S := by linarith
  have hL2 : (1 : ℝ) ≤ L ^ 2 := by nlinarith
  have h1S : L ^ 2 ≤ S * L ^ 2 := by nlinarith [sq_nonneg L]
  have habs1 : (9 * c₁ + c₂) * L ^ 2 ≤ (9 * c₁ + c₂) * (S * L ^ 2) :=
    mul_le_mul_of_nonneg_left h1S (by linarith)
  have habs2 : (0 : ℝ) ≤ S * W * (L ^ 2 - 1) :=
    mul_nonneg (mul_nonneg hS0 hW) (by linarith)
  nlinarith [habs1, habs2]

/-- **THE ASSEMBLY — the decomposition closed.** Under hRH (Mathlib's
`RiemannHypothesis`), hEF (`StmtExplicitFormula c₁ c₂ x₁` — the
truncated explicit formula, the open leaf), and hNT
(`Riemann_vonMangoldt_bound b₁ b₂ b₃` — Rosser Th. 19, the other open
leaf), the ψ-side weak bound holds with computed constant:
`StmtPsiWeak (9c₁ + c₂ + 28 + 16b₁ + 16b₂ + 8b₃ + 4W) 2 (max x₁ 16)`.
The dyadic level is chosen from `x` itself (`K = Nat.log 2 ⌊x⌋`, so
`x < 2^(K+1) ≤ 2x`). PsiToPi's `schoenfeldWeak_of_psiWeak` carries the
conclusion to `π − Li`, Statement's `weakWindow_of_global` to the
window, O68's arithmetic to the census. -/
theorem psiWeak_of_RH_EF_NT (hRH : RiemannHypothesis)
    {c₁ c₂ x₁ b₁ b₂ b₃ W : ℝ} (hc₁ : 0 ≤ c₁) (hc₂ : 0 ≤ c₂)
    (hb₁ : 0 ≤ b₁) (hb₂ : 0 ≤ b₂) (hb₃ : 0 ≤ b₃)
    (hWeq : W = weightedZeroHeightBucket)
    (hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2)
    (hEF : StmtExplicitFormulaPoly c₁ c₂ x₁)
    (hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃) :
    StmtPsiWeak
      (9 * c₁ + c₂ + 28 + 16 * b₁ + 16 * b₂ + 8 * b₃
        + 4 * W) 2 (max x₁ 16) := by
  intro x hx
  have hx16 : (16 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
  have hx1 : x₁ ≤ x := le_trans (le_max_left _ _) hx
  have hx0 : (0 : ℝ) < x := by linarith
  set L : ℝ := Real.log x with hLdef
  set S : ℝ := Real.sqrt x with hSdef
  have hW : (0 : ℝ) ≤ W := by
    rw [hWeq]
    exact weightedZeroHeightBucket_nonneg
  have hlog2 : (0.6931471803 : ℝ) < Real.log 2 := Real.log_two_gt_d9
  have hL16 : Real.log 16 ≤ L := Real.log_le_log (by norm_num) hx16
  have hL164 : Real.log 16 = 4 * Real.log 2 := by
    rw [show (16 : ℝ) = 2 ^ 4 by norm_num, Real.log_pow]
    push_cast
    ring
  have hL1 : (1 : ℝ) ≤ L := by nlinarith
  have hLl2 : Real.log 2 ≤ L := by nlinarith
  have hS4 : (4 : ℝ) ≤ S := by
    rw [hSdef, show (4 : ℝ) = Real.sqrt 16 by
      rw [show (16 : ℝ) = 4 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]]
    exact Real.sqrt_le_sqrt hx16
  have hS0 : (0 : ℝ) ≤ S := by linarith
  -- the dyadic level from x itself
  set n : ℕ := ⌊x⌋₊ with hndef
  have hn16 : 16 ≤ n := Nat.le_floor (by exact_mod_cast hx16)
  set K : ℕ := Nat.log 2 n with hKdef
  have h2K : (2 : ℝ) ^ K ≤ x := by
    have h1 := Nat.pow_log_le_self 2 (by omega : n ≠ 0)
    calc (2 : ℝ) ^ K = ((2 ^ K : ℕ) : ℝ) := by push_cast; ring
      _ ≤ (n : ℝ) := by exact_mod_cast h1
      _ ≤ x := Nat.floor_le (by linarith)
  have hxT : x < (2 : ℝ) ^ (K + 1) := by
    have h1 := Nat.lt_pow_succ_log_self (by norm_num : 1 < 2) n
    have hfl : x < (n : ℝ) + 1 := Nat.lt_floor_add_one x
    calc x < (n : ℝ) + 1 := hfl
      _ ≤ ((2 ^ (K + 1) : ℕ) : ℝ) := by exact_mod_cast h1
      _ = (2 : ℝ) ^ (K + 1) := by push_cast; ring
  have hT2x : (2 : ℝ) ^ (K + 1) ≤ 2 * x := by
    rw [pow_succ]
    nlinarith
  set T : ℝ := (2 : ℝ) ^ (K + 1) with hTdef
  have hT0 : (0 : ℝ) < T := by positivity
  have hT2 : (2 : ℝ) ≤ T := by
    calc (2 : ℝ) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ (K + 1) := pow_le_pow_right₀ (by norm_num) (by omega)
  have hlogT : Real.log T = ((K : ℝ) + 1) * Real.log 2 := by
    rw [hTdef, Real.log_pow]
    push_cast
    ring
  have hKL : (K : ℝ) * Real.log 2 ≤ L := by
    calc (K : ℝ) * Real.log 2 = Real.log ((2 : ℝ) ^ K) := by
          rw [Real.log_pow]
      _ ≤ L := Real.log_le_log (by positivity) h2K
  have hK1 : ((K : ℝ) + 1) * Real.log 2 ≤ 2 * L := by nlinarith
  have hK2 : ((K : ℝ) + 2) * Real.log 2 ≤ 3 * L := by nlinarith
  have hzero := norm_zeroPartialSum_le_logsq hRH hb₁ hb₂ hRvM2 hNT hx0 K
  rw [← hTdef, ← hWeq] at hzero
  clear_value n K T
  -- the remainder, through the scalar helper
  have hEFx := hEF x T hx1 hT2 (by nlinarith [hx16, hT2x])
  have hlogxT : Real.log (x * T) ≤ 3 * L := by
    have hmul : x * T ≤ 2 * x ^ 2 := by
      have h := mul_le_mul_of_nonneg_left hT2x hx0.le
      linarith only [h]
    have hlogle : Real.log (x * T) ≤ Real.log (2 * x ^ 2) :=
      Real.log_le_log (mul_pos hx0 hT0) hmul
    have hexp : Real.log (2 * x ^ 2) = Real.log 2 + 2 * L := by
      rw [Real.log_mul (by norm_num) (by positivity), Real.log_pow]
      push_cast
      ring
    linarith only [hlogle, hexp.le, hLl2]
  have hlogxT0 : (0 : ℝ) ≤ Real.log (x * T) := by
    apply Real.log_nonneg
    have h := mul_le_mul hx16 hT2 (by norm_num) (by linarith)
    linarith only [h]
  have hrem := rem_arith hc₁ hc₂ hx0.le hT0 (le_of_lt hxT)
    hlogxT0 hlogxT hL1
  -- the zero side, through the scalar helpers
  have hRvMT : riemannZeta.RvM b₁ b₂ b₃ T ≤ (2 * b₁ + 2 * b₂ + b₃) * L ^ 2 := by
    unfold riemannZeta.RvM
    have hlogT2L : Real.log T ≤ 2 * L := by rw [hlogT]; linarith only [hK1]
    have hlogT0 : (0 : ℝ) < Real.log T := by
      rw [hlogT]
      positivity
    have hloglogT : Real.log (Real.log T) ≤ 2 * L :=
      le_trans (Real.log_le_self hlogT0.le) hlogT2L
    have hLL : L ≤ L ^ 2 := by
      have h := mul_le_mul_of_nonneg_left hL1 (by linarith only [hL1] : (0 : ℝ) ≤ L)
      nlinarith [h]
    have e1 : b₁ * Real.log T ≤ b₁ * (2 * L) :=
      mul_le_mul_of_nonneg_left hlogT2L hb₁
    have e2 : b₂ * Real.log (Real.log T) ≤ b₂ * (2 * L) :=
      mul_le_mul_of_nonneg_left hloglogT hb₂
    have e3 : b₁ * (2 * L) ≤ b₁ * (2 * L ^ 2) :=
      mul_le_mul_of_nonneg_left (by linarith only [hLL]) hb₁
    have e4 : b₂ * (2 * L) ≤ b₂ * (2 * L ^ 2) :=
      mul_le_mul_of_nonneg_left (by linarith only [hLL]) hb₂
    have h1L2 : (1 : ℝ) ≤ L ^ 2 := by linarith only [hLL, hL1]
    have e5 : b₃ ≤ b₃ * L ^ 2 := by
      have hp : (0 : ℝ) ≤ b₃ * (L ^ 2 - 1) :=
        mul_nonneg hb₃ (by linarith only [h1L2])
      linarith only [hp]
    linarith only [e1, e2, e3, e4, e5]
  have hinner := zeroinner_arith (W := W)
    hb₁ hb₂ hb₃ hL1 (Nat.cast_nonneg K) hK1 hK2 hRvMT
  have h2S : (0 : ℝ) ≤ 2 * S := by linarith only [hS0]
  have hzero2 : ‖zeroPartialSum x T‖
      ≤ 2 * S * (2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W) :=
    le_trans hzero (mul_le_mul_of_nonneg_left hinner h2S)
  clear hzero hinner
  -- assemble
  have hsplit : |ψ x - x| ≤ ‖((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T‖
      + ‖zeroPartialSum x T‖ := by
    have hid : ((ψ x - x : ℝ) : ℂ)
        = (((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T)
          - zeroPartialSum x T := by
      push_cast
      ring
    calc |ψ x - x| = ‖((ψ x - x : ℝ) : ℂ)‖ := by
          rw [Complex.norm_real, Real.norm_eq_abs]
      _ = ‖(((ψ x : ℝ) : ℂ) - (x : ℂ) + zeroPartialSum x T)
            - zeroPartialSum x T‖ := by rw [hid]
      _ ≤ _ := norm_sub_le _ _
  have htotal : |ψ x - x|
      ≤ (9 * c₁ + c₂) * L ^ 2
        + 2 * S * (2 * (7 + 4 * b₁ + 4 * b₂ + 2 * b₃) * L ^ 2 + 2 * W) := by
    linarith only [hsplit, hEFx, hrem, hzero2]
  exact assembly_arith hc₁ hc₂ hb₁ hb₂ hb₃ hW hS4 hL1 htotal

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

/-- info: 'Stage3.rem_arith' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rem_arith

/-- info: 'Stage3.zeroinner_arith' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroinner_arith

/-- info: 'Stage3.assembly_arith' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.assembly_arith

/-- info: 'Stage3.psiWeak_of_RH_EF_NT' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.psiWeak_of_RH_EF_NT

/-- info: 'Stage3.norm_zeroPartialSum_le_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_zeroPartialSum_le_sharp

/-- info: 'Stage3.norm_zeroPartialSum_le_logsq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_zeroPartialSum_le_logsq

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
