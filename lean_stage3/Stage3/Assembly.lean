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
`√x · T·log T`-arithmetic under hNT; the dyadic 1/|γ| refinement to
`√x·(log T)²` (ZeroSum slice 2) sharpens it. Next slice: the
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

/-- info: 'Stage3.norm_zeroPartialSum_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.norm_zeroPartialSum_le

end Stage3
