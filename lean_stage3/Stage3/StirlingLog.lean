/-
# StirlingLog — block S12 of `lean_stage3/design/stencil.md`, the Γ-shift with its phase. 2026-11-25.

A logarithm of `Γ` on the right half-plane, `logG z = lim logGammaSeq z n` (PNT+'s
`Complex.logGammaSeq`, Cauchy by `cauchySeq_logGammaSeq`, `exp (logGammaSeq z n) = GammaSeq z n`),
and the shift `logG (z + a) − logG z = a log z + O(1/|Im z|)` for `Re z ≥ 1/4`, `‖a‖ ≤ 1/8`,
`|Im z| ≥ 1/2`, with the constant `2`. The route: `logGammaSeq (z+a) n − logGammaSeq z n =
a log n − Σ_{m≤n} (log(z+a+m) − log(z+m))`; each term is `a (log(z+m+1) − log(z+m)) + e_m`
with `‖e_m‖ ≤ 2‖a‖(1+‖a‖)/‖z+m‖²` (`log_step`, the mean value inequality on
`s ↦ log(c + s d) − s d/c`), the first part telescopes to `a (log(z+n+1) − log z)`, and
`Σ_m 1/‖z+m‖² ≤ 6/|Im z|` (`sum_inv_sq_le`, telescoping `1/u² ≤ 3/u − 3/(u+1)` for `u ≥ 1/2`).
`log(z+n+1) − log n → 0`, so the limit keeps the bound.

The size check. The bound is `O(1/|Im z|)` with no logarithm: the sum `Σ 1/‖z+m‖²` is
`≍ 1/|Im z|`, and nothing grows with `n` (the leftover `a (log n − log(z+n+1))` tends to `0`).

| name | content | status |
|---|---|---|
| `logG` | `lim_n logGammaSeq z n` | def |
| `tendsto_logG`, `exp_logG` | the limit exists for `Re z > 0`; `exp (logG z) = Γ z` | proved |
| `log_step` | `‖log(c+d) − log c − d/c‖ ≤ 2‖d‖²/‖c‖²` on a segment in `Re > 0` with `‖c‖ ≤ 2‖c+sd‖` | proved |
| `sum_inv_sq_le`, `sum_inv_normSq_le` | `Σ_{m<N} 1/(m+Y)² ≤ 3/Y`; `Σ_{m<N} 1/‖z+m‖² ≤ 6/|Im z|` | proved |
| `tendsto_log_shift` | `log(z+(n+1)) − log n → 0` | proved |
| `logG_shift` | `‖logG(z+a) − logG z − a log z‖ ≤ 2/|Im z|`, `Re z ≥ 1/4`, `‖a‖ ≤ 1/8`, `|Im z| ≥ 1/2` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Mathlib
import PrimeNumberTheoremAnd.Mathlib.Analysis.SpecialFunctions.Gamma.DigammaSeries

namespace Stirling

open Complex Filter Topology Set

noncomputable section

/-- A logarithm of `Γ` on the right half-plane: the limit of PNT+'s `logGammaSeq`. -/
def logG (z : ℂ) : ℂ := limUnder atTop (Complex.logGammaSeq z)

theorem tendsto_logG {z : ℂ} (hz : 0 < z.re) :
    Tendsto (Complex.logGammaSeq z) atTop (𝓝 (logG z)) :=
  (Complex.cauchySeq_logGammaSeq hz).tendsto_limUnder

theorem exp_logG {z : ℂ} (hz : 0 < z.re) : cexp (logG z) = Gamma z := by
  have h1 : Tendsto (fun n => cexp (Complex.logGammaSeq z n)) atTop (𝓝 (cexp (logG z))) :=
    (Complex.continuous_exp.tendsto _).comp (tendsto_logG hz)
  have h2 : Tendsto (fun n => cexp (Complex.logGammaSeq z n)) atTop (𝓝 (Gamma z)) := by
    refine (Complex.GammaSeq_tendsto_Gamma z).congr' ?_
    filter_upwards [eventually_ge_atTop 1] with n hn
    exact (Complex.exp_logGammaSeq hz (by omega)).symm
  exact tendsto_nhds_unique h1 h2

/-- One step of the logarithm along a segment in the right half-plane. -/
theorem log_step {c d : ℂ} (hpos : ∀ s ∈ Icc (0 : ℝ) 1, 0 < (c + (s : ℂ) * d).re)
    (hlow : ∀ s ∈ Icc (0 : ℝ) 1, ‖c‖ ≤ 2 * ‖c + (s : ℂ) * d‖) :
    ‖log (c + d) - log c - d / c‖ ≤ 2 * ‖d‖ ^ 2 / ‖c‖ ^ 2 := by
  have hne : ∀ s ∈ Icc (0 : ℝ) 1, c + (s : ℂ) * d ≠ 0 := by
    intro s hs h
    have := hpos s hs
    rw [h] at this
    simp at this
  have hc0 : c ≠ 0 := by
    have := hne 0 ⟨le_rfl, zero_le_one⟩
    simpa using this
  set f : ℝ → ℂ := fun s => log (c + (s : ℂ) * d) - (s : ℂ) * (d / c) with hf
  have hderiv : ∀ s ∈ Icc (0 : ℝ) 1, HasDerivAt f (d / (c + (s : ℂ) * d) - d / c) s := by
    intro s hs
    have h1 : HasDerivAt (fun s : ℝ => c + (s : ℂ) * d) d s := by
      have := ((hasDerivAt_id s).ofReal_comp).mul_const d
      simpa using this.const_add c
    have h2 := h1.clog_real (mem_slitPlane_iff.mpr (Or.inl (hpos s hs)))
    have h3 : HasDerivAt (fun s : ℝ => (s : ℂ) * (d / c)) (d / c) s := by
      simpa using ((hasDerivAt_id s).ofReal_comp).mul_const (d / c)
    exact h2.sub h3
  have hb : ∀ s ∈ Ico (0 : ℝ) 1, ‖d / (c + (s : ℂ) * d) - d / c‖ ≤ 2 * ‖d‖ ^ 2 / ‖c‖ ^ 2 := by
    intro s hs
    have hs' : s ∈ Icc (0 : ℝ) 1 := Ico_subset_Icc_self hs
    have hq0 := hne s hs'
    have e : d / (c + (s : ℂ) * d) - d / c = -((s : ℂ) * d ^ 2) / (c * (c + (s : ℂ) * d)) := by
      rw [div_sub_div _ _ hq0 hc0, show d * c - (c + (s : ℂ) * d) * d = -((s : ℂ) * d ^ 2) by ring,
        mul_comm (c + (s : ℂ) * d) c]
    rw [e, norm_div, norm_neg, norm_mul, norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs,
      abs_of_nonneg hs.1]
    have hl := hlow s hs'
    have hcpos : 0 < ‖c‖ := norm_pos_iff.mpr hc0
    have hq : 0 < ‖c + (s : ℂ) * d‖ := norm_pos_iff.mpr hq0
    rw [div_le_div_iff₀ (by positivity) (by positivity)]
    have h4 : s * ‖c‖ ≤ 2 * ‖c + (s : ℂ) * d‖ := by nlinarith [hs.2, hs.1]
    calc s * ‖d‖ ^ 2 * ‖c‖ ^ 2 = (‖d‖ ^ 2 * ‖c‖) * (s * ‖c‖) := by ring
      _ ≤ (‖d‖ ^ 2 * ‖c‖) * (2 * ‖c + (s : ℂ) * d‖) :=
          mul_le_mul_of_nonneg_left h4 (by positivity)
      _ = 2 * ‖d‖ ^ 2 * (‖c‖ * ‖c + (s : ℂ) * d‖) := by ring
  have hmv := norm_image_sub_le_of_norm_deriv_le_segment_01' (f := f)
    (fun s hs => (hderiv s hs).hasDerivWithinAt) hb
  have e : log (c + d) - log c - d / c = f 1 - f 0 := by
    simp only [hf, ofReal_one, one_mul, ofReal_zero, zero_mul, add_zero]
    ring
  rw [e]
  exact hmv

/-- `Σ_{m<N} 1/(m+Y)² ≤ 3/Y − 3/(N+Y)` for `Y ≥ 1/2`. -/
theorem sum_inv_sq_le {Y : ℝ} (hY : 1 / 2 ≤ Y) (N : ℕ) :
    ∑ m ∈ Finset.range N, 1 / ((m : ℝ) + Y) ^ 2 ≤ 3 / Y - 3 / ((N : ℝ) + Y) := by
  induction N with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ]
    have hu : 1 / 2 ≤ (n : ℝ) + Y := by
      have : (0 : ℝ) ≤ n := Nat.cast_nonneg n
      linarith
    have key : 1 / ((n : ℝ) + Y) ^ 2 ≤ 3 / ((n : ℝ) + Y) - 3 / (((n + 1 : ℕ) : ℝ) + Y) := by
      push_cast
      have h1 : 0 < (n : ℝ) + Y := by linarith
      have h2 : 0 < (n : ℝ) + 1 + Y := by linarith
      rw [div_sub_div _ _ h1.ne' h2.ne', div_le_div_iff₀ (by positivity) (by positivity)]
      nlinarith
    linarith

/-- `‖z + m‖² ≥ (m + |Im z|)²/2` for `Re z ≥ 0`. -/
theorem normSq_add_nat_ge {z : ℂ} (hre : 0 ≤ z.re) (m : ℕ) :
    ((m : ℝ) + |z.im|) ^ 2 / 2 ≤ ‖z + m‖ ^ 2 := by
  rw [Complex.sq_norm, Complex.normSq_apply]
  simp only [add_re, natCast_re, add_im, natCast_im, add_zero]
  have hm : (0 : ℝ) ≤ m := Nat.cast_nonneg m
  have habs : |z.im| ^ 2 = z.im * z.im := by rw [sq_abs]; ring
  nlinarith [sq_nonneg ((m : ℝ) - |z.im|), sq_abs z.im]

/-- `Σ_{m<N} 1/‖z+m‖² ≤ 6/|Im z|` for `Re z ≥ 0`, `|Im z| ≥ 1/2`. -/
theorem sum_inv_normSq_le {z : ℂ} (hre : 0 ≤ z.re) (hY : 1 / 2 ≤ |z.im|) (N : ℕ) :
    ∑ m ∈ Finset.range N, 1 / ‖z + m‖ ^ 2 ≤ 6 / |z.im| := by
  have hY0 : 0 < |z.im| := by linarith
  have h1 : ∀ m ∈ Finset.range N, 1 / ‖z + m‖ ^ 2 ≤ 2 * (1 / ((m : ℝ) + |z.im|) ^ 2) := by
    intro m _
    have h := normSq_add_nat_ge hre m
    have hp : 0 < ((m : ℝ) + |z.im|) ^ 2 := by
      have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      positivity
    rw [mul_one_div, div_le_div_iff₀ (by linarith) hp]
    linarith
  calc ∑ m ∈ Finset.range N, 1 / ‖z + m‖ ^ 2
      ≤ ∑ m ∈ Finset.range N, 2 * (1 / ((m : ℝ) + |z.im|) ^ 2) := Finset.sum_le_sum h1
    _ = 2 * ∑ m ∈ Finset.range N, 1 / ((m : ℝ) + |z.im|) ^ 2 := by rw [Finset.mul_sum]
    _ ≤ 2 * (3 / |z.im| - 3 / ((N : ℝ) + |z.im|)) :=
        mul_le_mul_of_nonneg_left (sum_inv_sq_le hY N) (by norm_num)
    _ ≤ 6 / |z.im| := by
        have : 0 ≤ 3 / ((N : ℝ) + |z.im|) := by positivity
        have e : 2 * (3 / |z.im|) = 6 / |z.im| := by ring
        linarith

/-- `log(z + (n+1)) − log n → 0`. -/
theorem tendsto_log_shift (z : ℂ) :
    Tendsto (fun n : ℕ => log (z + ((n : ℂ) + 1)) - (Real.log n : ℂ)) atTop (𝓝 0) := by
  have hdiv : Tendsto (fun n : ℕ => (z + 1) / (n : ℂ)) atTop (𝓝 0) :=
    tendsto_const_div_atTop_nhds_zero_nat (z + 1)
  have h1 : (1 : ℂ) + 0 ∈ slitPlane := by simp
  have hlog : Tendsto (fun n : ℕ => log (1 + (z + 1) / (n : ℂ))) atTop (𝓝 (log (1 + 0))) :=
    ((continuousAt_clog h1).tendsto).comp (tendsto_const_nhds.add hdiv)
  rw [add_zero, log_one] at hlog
  refine hlog.congr' ?_
  have hsmall : ∀ᶠ n : ℕ in atTop, ‖(z + 1) / (n : ℂ)‖ < 1 := by
    have h := hdiv.norm
    rw [norm_zero] at h
    exact (tendsto_order.1 h).2 1 one_pos
  filter_upwards [eventually_ge_atTop 1, hsmall] with n hn hsm
  have hn0 : (0 : ℝ) < n := by exact_mod_cast hn
  have hx : 1 + (z + 1) / (n : ℂ) ≠ 0 := slitPlane_ne_zero (mem_slitPlane_of_norm_lt_one hsm)
  have hnC : (n : ℂ) ≠ 0 := by exact_mod_cast hn0.ne'
  have e : z + ((n : ℂ) + 1) = ((n : ℝ) : ℂ) * (1 + (z + 1) / (n : ℂ)) := by
    rw [Complex.ofReal_natCast, mul_add, mul_one, mul_div_cancel₀ _ hnC]
    ring
  rw [e, log_ofReal_mul hn0 hx]
  ring

/-- **The Γ-shift with its phase**: `logG(z+a) − logG z = a log z + O(1/|Im z|)`, the constant
`2`, for `Re z ≥ 1/4`, `‖a‖ ≤ 1/8`, `|Im z| ≥ 1/2`. -/
theorem logG_shift {z a : ℂ} (hre : 1 / 4 ≤ z.re) (ha : ‖a‖ ≤ 1 / 8) (hY : 1 / 2 ≤ |z.im|) :
    ‖logG (z + a) - logG z - a * log z‖ ≤ 2 / |z.im| := by
  have hY0 : 0 < |z.im| := by linarith
  have hz0 : 0 < z.re := by linarith
  have hare : -‖a‖ ≤ a.re := (abs_le.mp (Complex.abs_re_le_norm a)).1
  have hza : 0 < (z + a).re := by
    rw [add_re]
    linarith
  set e : ℕ → ℂ := fun m => (log (z + a + m) - log (z + m)) -
      a * (log (z + ((m : ℂ) + 1)) - log (z + m)) with he
  have he_le : ∀ m : ℕ, ‖e m‖ ≤ 2 * ‖a‖ * (1 + ‖a‖) * (1 / ‖z + m‖ ^ 2) := by
    intro m
    set c : ℂ := z + m with hc
    have hcre : 1 / 4 ≤ c.re := by
      rw [hc, add_re, natCast_re]
      have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      linarith
    have hcim : |z.im| ≤ ‖c‖ := by
      have h := Complex.abs_im_le_norm c
      rw [hc, add_im, natCast_im, add_zero] at h
      exact h
    have hcn : 1 / 2 ≤ ‖c‖ := hY.trans hcim
    have hc0 : 0 < ‖c‖ := by linarith
    have hA : ‖log (c + a) - log c - a / c‖ ≤ 2 * ‖a‖ ^ 2 / ‖c‖ ^ 2 := by
      apply log_step
      · intro s hs
        rw [add_re, re_ofReal_mul]
        nlinarith [hs.1, hs.2, norm_nonneg a]
      · intro s hs
        have h1 : ‖(s : ℂ) * a‖ ≤ ‖a‖ := by
          rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hs.1]
          nlinarith [norm_nonneg a, hs.2]
        have h2 : ‖c‖ ≤ ‖c + (s : ℂ) * a‖ + ‖(s : ℂ) * a‖ := by
          have := norm_sub_le (c + (s : ℂ) * a) ((s : ℂ) * a)
          rwa [add_sub_cancel_right] at this
        linarith
    have hB : ‖log (c + 1) - log c - 1 / c‖ ≤ 2 * ‖(1 : ℂ)‖ ^ 2 / ‖c‖ ^ 2 := by
      apply log_step
      · intro s hs
        rw [mul_one, add_re, ofReal_re]
        linarith [hs.1]
      · intro s hs
        rw [mul_one]
        have hsq : ‖c‖ ^ 2 ≤ ‖c + (s : ℂ)‖ ^ 2 := by
          rw [Complex.sq_norm, Complex.sq_norm, Complex.normSq_apply, Complex.normSq_apply]
          simp only [add_re, ofReal_re, add_im, ofReal_im, add_zero]
          nlinarith [hs.1]
        nlinarith [norm_nonneg c, norm_nonneg (c + (s : ℂ))]
    rw [norm_one, one_pow, mul_one] at hB
    have ee : e m = (log (c + a) - log c - a / c) - a * (log (c + 1) - log c - 1 / c) := by
      simp only [he, hc]
      rw [show z + a + (m : ℂ) = z + m + a by ring, show z + ((m : ℂ) + 1) = z + m + 1 by ring]
      ring
    rw [ee]
    calc ‖(log (c + a) - log c - a / c) - a * (log (c + 1) - log c - 1 / c)‖
        ≤ ‖log (c + a) - log c - a / c‖ + ‖a‖ * ‖log (c + 1) - log c - 1 / c‖ := by
          refine (norm_sub_le _ _).trans ?_
          rw [norm_mul]
      _ ≤ 2 * ‖a‖ ^ 2 / ‖c‖ ^ 2 + ‖a‖ * (2 / ‖c‖ ^ 2) :=
          add_le_add hA (mul_le_mul_of_nonneg_left hB (norm_nonneg a))
      _ = 2 * ‖a‖ * (1 + ‖a‖) * (1 / ‖c‖ ^ 2) := by ring
  have hsum_le : ∀ n : ℕ, ‖∑ m ∈ Finset.range (n + 1), e m‖ ≤ 27 / 16 / |z.im| := by
    intro n
    calc ‖∑ m ∈ Finset.range (n + 1), e m‖ ≤ ∑ m ∈ Finset.range (n + 1), ‖e m‖ := norm_sum_le _ _
      _ ≤ ∑ m ∈ Finset.range (n + 1), 2 * ‖a‖ * (1 + ‖a‖) * (1 / ‖z + m‖ ^ 2) :=
          Finset.sum_le_sum fun m _ => he_le m
      _ = 2 * ‖a‖ * (1 + ‖a‖) * ∑ m ∈ Finset.range (n + 1), 1 / ‖z + m‖ ^ 2 := by
          rw [Finset.mul_sum]
      _ ≤ 2 * ‖a‖ * (1 + ‖a‖) * (6 / |z.im|) :=
          mul_le_mul_of_nonneg_left (sum_inv_normSq_le hz0.le hY (n + 1)) (by positivity)
      _ ≤ 2 * (1 / 8) * (1 + 1 / 8) * (6 / |z.im|) := by
          apply mul_le_mul_of_nonneg_right _ (by positivity)
          have := norm_nonneg a
          nlinarith
      _ = 27 / 16 / |z.im| := by ring
  have hD : ∀ n : ℕ, Complex.logGammaSeq (z + a) n - Complex.logGammaSeq z n - a * log z =
      a * ((Real.log n : ℂ) - log (z + ((n : ℂ) + 1))) - ∑ m ∈ Finset.range (n + 1), e m := by
    intro n
    have ht := Finset.sum_range_sub (fun m : ℕ => log (z + (m : ℂ))) (n + 1)
    simp only [Nat.cast_add, Nat.cast_one, Nat.cast_zero, add_zero] at ht
    rw [Finset.sum_sub_distrib] at ht
    have hsum : ∑ m ∈ Finset.range (n + 1), e m =
        ∑ m ∈ Finset.range (n + 1), log (z + a + m) - ∑ m ∈ Finset.range (n + 1), log (z + m) -
        a * (∑ m ∈ Finset.range (n + 1), log (z + ((m : ℂ) + 1)) -
          ∑ m ∈ Finset.range (n + 1), log (z + m)) := by
      simp only [he, Finset.sum_sub_distrib, Finset.mul_sum, mul_sub]
    rw [hsum]
    unfold Complex.logGammaSeq
    linear_combination (-a) * ht
  have hT : Tendsto (fun n : ℕ => ‖Complex.logGammaSeq (z + a) n - Complex.logGammaSeq z n -
      a * log z‖ - ‖a‖ * ‖log (z + ((n : ℂ) + 1)) - (Real.log n : ℂ)‖) atTop
      (𝓝 (‖logG (z + a) - logG z - a * log z‖ - ‖a‖ * ‖(0 : ℂ)‖)) :=
    ((((tendsto_logG hza).sub (tendsto_logG hz0)).sub_const _).norm).sub
      ((tendsto_log_shift z).norm.const_mul _)
  rw [norm_zero, mul_zero, sub_zero] at hT
  refine le_of_tendsto' hT (fun n => ?_)
  rw [hD n]
  have h1 := norm_sub_le (a * ((Real.log n : ℂ) - log (z + ((n : ℂ) + 1))))
    (∑ m ∈ Finset.range (n + 1), e m)
  rw [norm_mul, norm_sub_rev (Real.log n : ℂ)] at h1
  have h2 := hsum_le n
  have h3 : 27 / 16 / |z.im| ≤ 2 / |z.im| := div_le_div_of_nonneg_right (by norm_num) hY0.le
  linarith

/-! ## Axiom pins -/

/-- info: 'Stirling.exp_logG' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms exp_logG

/-- info: 'Stirling.log_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_step

/-- info: 'Stirling.sum_inv_normSq_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_inv_normSq_le

/-- info: 'Stirling.logG_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logG_shift

end

end Stirling
