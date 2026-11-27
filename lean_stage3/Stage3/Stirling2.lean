/-
Stirling2 — toward the digamma comparison to second order, which drops the `97·log T` from the
Backlund phase (`Stirling.backlundPhase_holds`) and with it the zero count's `b₁` from `112` to
`15`, enough for depth twelve of the table (see `lean/RHDepths.lean`).

`trapezoid_log_le`: the trapezoid rule for `∫ dx/(w+x)` over a unit step, read through `u = 1/w`,
errs by at most `2‖u‖³` when `‖u‖ ≤ 1/2`.
-/
import Mathlib
import Stage3.Stirling

namespace Stirling2
open Complex

theorem trapezoid_log_le {u : ℂ} (hu : ‖u‖ ≤ 1 / 2) :
    ‖u / 2 * (1 + 1 / (1 + u)) - Complex.log (1 + u)‖ ≤ 2 * ‖u‖ ^ 3 := by
  have hu1 : ‖u‖ < 1 := by linarith
  have hne : (1 : ℂ) + u ≠ 0 := by
    intro h
    have : u = -1 := by linear_combination h
    rw [this] at hu; norm_num at hu
  have hT := Complex.norm_log_sub_logTaylor_le 2 hu1
  have hlt : logTaylor (2 + 1) u = u - u ^ 2 / 2 := by
    simp [logTaylor, Finset.sum_range_succ]; ring
  rw [hlt] at hT
  -- (u/2)(1 + 1/(1+u)) = u − u²/2 + u³/(2(1+u))
  have hid : u / 2 * (1 + 1 / (1 + u)) = (u - u ^ 2 / 2) + u ^ 3 / (2 * (1 + u)) := by
    field_simp; ring
  rw [hid]
  have hsplit : (u - u ^ 2 / 2) + u ^ 3 / (2 * (1 + u)) - Complex.log (1 + u)
      = u ^ 3 / (2 * (1 + u)) - (Complex.log (1 + u) - (u - u ^ 2 / 2)) := by ring
  rw [hsplit]
  have hden : (1 / 2 : ℝ) ≤ ‖(1 : ℂ) + u‖ := by
    have := norm_sub_norm_le (1 : ℂ) (-u)
    simp at this
    have h2 : ‖(1 : ℂ) + u‖ = ‖(1 : ℂ) - -u‖ := by ring_nf
    rw [h2]; linarith
  have hA : ‖u ^ 3 / (2 * (1 + u))‖ ≤ ‖u‖ ^ 3 := by
    rw [norm_div, norm_mul, norm_pow]
    have : ‖(2 : ℂ)‖ = 2 := by simp
    rw [this, div_le_iff₀ (by positivity)]
    have h3 : (0 : ℝ) ≤ ‖u‖ ^ 3 := by positivity
    nlinarith
  have hB : ‖Complex.log (1 + u) - (u - u ^ 2 / 2)‖ ≤ ‖u‖ ^ 3 := by
    refine hT.trans ?_
    have h1 : (1 - ‖u‖)⁻¹ ≤ 2 := by
      rw [inv_le_comm₀ (by linarith) (by norm_num)]; linarith
    have h3 : (0 : ℝ) ≤ ‖u‖ ^ 3 := by positivity
    have : ‖u‖ ^ (2 + 1) * (1 - ‖u‖)⁻¹ ≤ ‖u‖ ^ 3 * 2 := by
      rw [show 2 + 1 = 3 by rfl]; exact mul_le_mul_of_nonneg_left h1 h3
    push_cast
    linarith
  calc _ ≤ ‖u ^ 3 / (2 * (1 + u))‖ + ‖Complex.log (1 + u) - (u - u ^ 2 / 2)‖ := norm_sub_le _ _
    _ ≤ _ := by linarith



open Stage3 in
/-- **The digamma telescope's limit**, exposed: the partial sums of `Re(1/(n+z)) − (log‖n+1+z‖ −
log‖n+z‖)` tend to `log‖z‖ − Re ψ(z)`, `z = 1/4 + it/2`. Copied from the first half of
`Stage3.re_digamma_sub_log_le`, which keeps it internal. -/
theorem tendsto_telescope {t : ℝ} (ht : 1 ≤ t) :
    Filter.Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N,
        ((((n : ℂ) + zq t)⁻¹).re
          - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖)))
      Filter.atTop (nhds (Real.log ‖zq t‖ - (Complex.digamma (zq t)).re)) := by
  have ht0 : (0 : ℝ) < t := by linarith
  have hzre : (zq t).re = 1 / 4 := by
    simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  have hcond : ∀ n : ℕ, zq t ≠ -(n : ℂ) := by
    intro n h
    have h2 := congrArg Complex.re h
    rw [hzre] at h2
    simp at h2
    nlinarith [Nat.cast_nonneg (α := ℝ) n, h2]
  have hsum := Complex.hasSum_digamma hcond
  have hre0 := hsum.mapL Complex.reCLM
  have hre : HasSum
      (fun n : ℕ => (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
      ((Complex.digamma (zq t)).re + Real.eulerMascheroniConstant) := by
    simpa using hre0
  have hP := hre.tendsto_sum_nat
  -- bookkeeping
  set ℓ : ℕ → ℝ := fun n => Real.log ‖(n : ℂ) + zq t‖ with hℓdef
  set b : ℕ → ℝ := fun n => (((n : ℂ) + zq t)⁻¹).re with hbdef
  set a : ℕ → ℝ := fun n => b n - (ℓ (n + 1) - ℓ n) with hadef
  set q : ℕ → ℝ := fun n => (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ with hqdef
  -- per-term real part of the series
  have hcre : ∀ n : ℕ,
      (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re
        = ((n : ℝ) + 1)⁻¹ - b n := by
    intro n
    rw [Complex.sub_re]
    congr 1
    · have hcast : (1 : ℂ) / ((n : ℂ) + 1) = ((((n : ℝ) + 1)⁻¹ : ℝ) : ℂ) := by
        push_cast
        ring
      rw [hcast, Complex.ofReal_re]
    · simp only [hbdef]
      congr 1
      rw [one_div]
  -- the finite telescope
  have hdecomp : ∀ N : ℕ,
      (∑ n ∈ Finset.range N, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
        = (∑ n ∈ Finset.range N, ((n : ℝ) + 1)⁻¹) - (ℓ N - ℓ 0)
          - ∑ n ∈ Finset.range N, a n := by
    intro N
    have h1 : (∑ n ∈ Finset.range N,
        (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re)
        = ∑ n ∈ Finset.range N, (((n : ℝ) + 1)⁻¹ - b n) :=
      Finset.sum_congr rfl fun n _ => hcre n
    have h2 : (∑ n ∈ Finset.range N, b n)
        = (∑ n ∈ Finset.range N, a n) + (ℓ N - ℓ 0) := by
      have h3 : ∀ n : ℕ, b n = a n + (ℓ (n + 1) - ℓ n) := by
        intro n
        simp only [hadef]
        ring
      rw [Finset.sum_congr rfl fun n _ => h3 n, Finset.sum_add_distrib,
        Finset.sum_range_sub (f := ℓ)]
    rw [h1, Finset.sum_sub_distrib, h2]
    ring
  -- harmonic cast
  have hharm : ∀ N : ℕ,
      ((harmonic N : ℚ) : ℝ) = ∑ n ∈ Finset.range N, ((n : ℝ) + 1)⁻¹ := by
    intro N
    rw [harmonic]
    push_cast
    rfl
  -- the A-sequence and its limit
  set A : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, a n with hAdef
  have hAeq : ∀ N : ℕ,
      A N = (((harmonic N : ℚ) : ℝ) - Real.log ((N : ℝ) + 1))
        - (ℓ N - Real.log ((N : ℝ) + 1)) + ℓ 0
        - ∑ n ∈ Finset.range N, (1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + zq t)).re := by
    intro N
    have hd := hdecomp N
    have hh := hharm N
    rw [hAdef]
    linarith [hd, hh]
  -- T1: Euler–Mascheroni
  have hT1 : Filter.Tendsto
      (fun N : ℕ => ((harmonic N : ℚ) : ℝ) - Real.log ((N : ℝ) + 1))
      Filter.atTop (nhds Real.eulerMascheroniConstant) := by
    exact Real.tendsto_eulerMascheroniSeq
  -- T2: the log-norm drift vanishes
  have hT2 : Filter.Tendsto
      (fun N : ℕ => ℓ N - Real.log ((N : ℝ) + 1))
      Filter.atTop (nhds 0) := by
    have hnpos : ∀ N : ℕ, (0 : ℝ) < ‖(N : ℂ) + zq t‖ :=
      fun N => norm_pos_iff.mpr (add_zq_ne_zero t N)
    have heq : ∀ N : ℕ, ℓ N - Real.log ((N : ℝ) + 1)
        = Real.log (‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1)) := by
      intro N
      simp only [hℓdef]
      rw [Real.log_div (ne_of_gt (hnpos N)) (by positivity)]
    have hlow : ∀ N : ℕ, ((N : ℝ) + 1 / 4) / ((N : ℝ) + 1)
        ≤ ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1) := by
      intro N
      have hreN : ((N : ℂ) + zq t).re = (N : ℝ) + 1 / 4 := by
        simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
      have h1 : (N : ℝ) + 1 / 4 ≤ ‖(N : ℂ) + zq t‖ := by
        calc (N : ℝ) + 1 / 4 = ((N : ℂ) + zq t).re := hreN.symm
          _ ≤ |((N : ℂ) + zq t).re| := le_abs_self _
          _ ≤ ‖(N : ℂ) + zq t‖ := Complex.abs_re_le_norm _
      gcongr
    have hup : ∀ N : ℕ, ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1)
        ≤ ((N : ℝ) + ‖zq t‖) / ((N : ℝ) + 1) := by
      intro N
      have h1 : ‖(N : ℂ) + zq t‖ ≤ (N : ℝ) + ‖zq t‖ := by
        calc ‖(N : ℂ) + zq t‖ ≤ ‖(N : ℂ)‖ + ‖zq t‖ := norm_add_le _ _
          _ = (N : ℝ) + ‖zq t‖ := by
              rw [Complex.norm_natCast]
      gcongr
    have hden : Filter.Tendsto (fun N : ℕ => (N : ℝ) + 1)
        Filter.atTop Filter.atTop :=
      Filter.tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop
    have hlim_of : ∀ c : ℝ, Filter.Tendsto
        (fun N : ℕ => ((N : ℝ) + c) / ((N : ℝ) + 1))
        Filter.atTop (nhds 1) := by
      intro c
      have hrw : ∀ N : ℕ, ((N : ℝ) + c) / ((N : ℝ) + 1)
          = 1 + (c - 1) / ((N : ℝ) + 1) := by
        intro N
        have hN0 : ((N : ℝ) + 1) ≠ 0 := by positivity
        rw [show (N : ℝ) + c = ((N : ℝ) + 1) + (c - 1) by ring, add_div,
          div_self hN0]
      have hz : Filter.Tendsto (fun N : ℕ => (c - 1) / ((N : ℝ) + 1))
          Filter.atTop (nhds 0) :=
        Filter.Tendsto.div_atTop tendsto_const_nhds hden
      have hone := Filter.Tendsto.const_add (1 : ℝ) hz
      rw [add_zero] at hone
      exact hone.congr fun N => (hrw N).symm
    have hratio : Filter.Tendsto
        (fun N : ℕ => ‖(N : ℂ) + zq t‖ / ((N : ℝ) + 1))
        Filter.atTop (nhds 1) :=
      tendsto_of_tendsto_of_tendsto_of_le_of_le
        (hlim_of (1 / 4)) (hlim_of ‖zq t‖) hlow hup
    have hcomp := ((Real.continuousAt_log one_ne_zero).tendsto).comp hratio
    rw [Real.log_one] at hcomp
    exact (hcomp.congr fun N => (heq N).symm)
  -- the limit of A
  have hA : Filter.Tendsto A Filter.atTop
      (nhds (ℓ 0 - (Complex.digamma (zq t)).re)) := by
    have hcomb := ((hT1.sub hT2).add_const (ℓ 0)).sub hP
    have hval : Real.eulerMascheroniConstant - 0 + ℓ 0
        - ((Complex.digamma (zq t)).re + Real.eulerMascheroniConstant)
        = ℓ 0 - (Complex.digamma (zq t)).re := by
      ring
    rw [hval] at hcomb
    exact hcomb.congr fun N => (hAeq N).symm
  have hℓ0 : ℓ 0 = Real.log ‖zq t‖ := by
    simp only [hℓdef]
    norm_num
  rw [hℓ0] at hA
  exact hA

end Stirling2

/-- info: 'Stirling2.trapezoid_log_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.trapezoid_log_le

/-- info: 'Stirling2.tendsto_telescope' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.tendsto_telescope
