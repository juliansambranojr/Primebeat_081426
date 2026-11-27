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

namespace Stirling2
open Stage3

/-- **The per-term split.** For `t ≥ 4` the telescope's `n`-th term, less half the step
`Re(1/w − 1/(w+1))`, is the trapezoid error at `u = 1/w`, `w = n + z`: at most `2/‖w‖³`. -/
theorem term_split_le {t : ℝ} (ht : 4 ≤ t) (n : ℕ) :
    |((((n : ℂ) + zq t)⁻¹).re
        - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖))
      - (1 / 2) * ((((n : ℂ) + zq t)⁻¹).re - ((((n + 1 : ℕ) : ℂ) + zq t)⁻¹).re)|
      ≤ 2 * (‖(n : ℂ) + zq t‖⁻¹) ^ 3 := by
  set w : ℂ := (n : ℂ) + zq t with hw
  have hw0 : w ≠ 0 := add_zq_ne_zero t n
  have hwpos : (0 : ℝ) < ‖w‖ := norm_pos_iff.mpr hw0
  have hnormsq : ‖w‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := normSq_add_zq t n
  have hw2 : (2 : ℝ) ≤ ‖w‖ := by
    nlinarith [sq_nonneg ((n : ℝ) + 1 / 4), Nat.cast_nonneg (α := ℝ) n]
  set u : ℂ := w⁻¹ with hu
  have hun : ‖u‖ = ‖w‖⁻¹ := by rw [hu, norm_inv]
  have hu2 : ‖u‖ ≤ 1 / 2 := by
    rw [hun]; rw [inv_le_comm₀ hwpos (by norm_num)]; linarith
  have hw1 : ((n + 1 : ℕ) : ℂ) + zq t = w * (1 + u) := by
    rw [hu, mul_add, mul_one, mul_inv_cancel₀ hw0, hw]; push_cast; ring
  have h1u : (1 : ℂ) + u ≠ 0 := by
    intro h; rw [h, mul_zero] at hw1; exact add_zq_ne_zero t (n + 1) hw1
  -- the log step is Re log(1+u)
  have hlog : Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖w‖ = (Complex.log (1 + u)).re := by
    rw [hw1, norm_mul, Real.log_mul (ne_of_gt hwpos) (by rwa [norm_ne_zero_iff]), Complex.log_re]
    ring
  -- 1/(w+1) is u/(1+u)
  have hinv : (((n + 1 : ℕ) : ℂ) + zq t)⁻¹ = u / (1 + u) := by
    rw [hw1, mul_inv, hu]; field_simp
  rw [hlog, hinv]
  have hexpr : u.re - (Complex.log (1 + u)).re - 1 / 2 * (u.re - (u / (1 + u)).re)
      = (u / 2 * (1 + 1 / (1 + u)) - Complex.log (1 + u)).re := by
    have e : u / 2 * (1 + 1 / (1 + u)) = u - (1 / 2 : ℂ) * (u - u / (1 + u)) := by
      field_simp; ring
    rw [e]
    have hh : ((1 / 2 : ℂ) * (u - u / (1 + u))).re = 1 / 2 * (u - u / (1 + u)).re := by
      simp [Complex.mul_re]
    simp only [Complex.sub_re] at hh ⊢
    rw [hh]; ring
  rw [hexpr]
  calc |(u / 2 * (1 + 1 / (1 + u)) - Complex.log (1 + u)).re|
      ≤ ‖u / 2 * (1 + 1 / (1 + u)) - Complex.log (1 + u)‖ := Complex.abs_re_le_norm _
    _ ≤ 2 * ‖u‖ ^ 3 := trapezoid_log_le hu2
    _ = 2 * (‖w‖⁻¹) ^ 3 := by rw [hun]

end Stirling2

/-- info: 'Stirling2.term_split_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.term_split_le

namespace Stirling2
open Stage3

/-- **The digamma comparison to second order.** For `t ≥ 4`, with `z = 1/4 + it/2`,
`|Re ψ(z) − log‖z‖ + ½·Re(1/z)| ≤ 48/t²`. -/
theorem digamma_second {t : ℝ} (ht : 4 ≤ t) :
    |phasePoint t - Real.log ‖zq t‖ + (1 / 2) * ((zq t)⁻¹).re| ≤ 48 / t ^ 2 := by
  have ht1 : (1 : ℝ) ≤ t := by linarith
  have ht0 : (0 : ℝ) < t := by linarith
  set a : ℕ → ℝ := fun n => (((n : ℂ) + zq t)⁻¹).re
      - (Real.log ‖((n + 1 : ℕ) : ℂ) + zq t‖ - Real.log ‖(n : ℂ) + zq t‖) with ha
  set b : ℕ → ℝ := fun n => (((n : ℂ) + zq t)⁻¹).re with hb
  set q : ℕ → ℝ := fun n => (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹ with hq
  -- the limits
  have hA := tendsto_telescope ht1
  have hbN : Filter.Tendsto b Filter.atTop (nhds 0) := by
    have hle : ∀ n : ℕ, |b n| ≤ ((n : ℝ) + 1 / 4)⁻¹ := by
      intro n
      have hre : ((n : ℂ) + zq t).re = (n : ℝ) + 1 / 4 := by
        simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
      have hpos : (0 : ℝ) < (n : ℝ) + 1 / 4 := by positivity
      have h1 : (n : ℝ) + 1 / 4 ≤ ‖(n : ℂ) + zq t‖ := by
        calc (n : ℝ) + 1 / 4 = ((n : ℂ) + zq t).re := hre.symm
          _ ≤ ‖(n : ℂ) + zq t‖ := Complex.re_le_norm _
      calc |b n| ≤ ‖((n : ℂ) + zq t)⁻¹‖ := Complex.abs_re_le_norm _
        _ = ‖(n : ℂ) + zq t‖⁻¹ := norm_inv _
        _ ≤ ((n : ℝ) + 1 / 4)⁻¹ := inv_anti₀ hpos h1
    have h0 : Filter.Tendsto (fun n : ℕ => ((n : ℝ) + 1 / 4)⁻¹) Filter.atTop (nhds 0) :=
      (Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop).inv_tendsto_atTop
    exact squeeze_zero_norm (fun n => by rw [Real.norm_eq_abs]; exact hle n) h0
  -- S N = Σ (a − c) = Σ a − ½ (b 0 − b N)
  set S : ℕ → ℝ := fun N => ∑ n ∈ Finset.range N, (a n - (1 / 2) * (b n - b (n + 1))) with hS
  have hSeq : ∀ N, S N = (∑ n ∈ Finset.range N, a n) - (1 / 2) * (b 0 - b N) := by
    intro N
    simp only [hS]
    rw [Finset.sum_sub_distrib, ← Finset.mul_sum, Finset.sum_range_sub']
  have hSlim : Filter.Tendsto S Filter.atTop
      (nhds ((Real.log ‖zq t‖ - (Complex.digamma (zq t)).re) - (1 / 2) * (b 0 - 0))) := by
    have := hA.sub (((tendsto_const_nhds (x := b 0)).sub hbN).const_mul (1 / 2))
    exact this.congr fun N => (hSeq N).symm
  -- the bound on S
  have hq_summ : Summable q := by
    have hg16 : Summable (fun n : ℕ => 16 / ((n : ℝ) + 1) ^ 2) := by
      have h := Complex.summable_one_div_natCast_add_one_sq
      simpa [div_eq_mul_inv] using h.mul_left (16 : ℝ)
    apply Summable.of_nonneg_of_le (fun n => by simp only [hq]; positivity) _ hg16
    intro n
    simp only [hq]
    have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    have hqq : ((n : ℝ) + 1) ^ 2 / 16 ≤ ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := by
      nlinarith [sq_nonneg ((t : ℝ) / 2)]
    calc (((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2)⁻¹
        ≤ (((n : ℝ) + 1) ^ 2 / 16)⁻¹ := inv_anti₀ (by positivity) hqq
      _ = 16 / ((n : ℝ) + 1) ^ 2 := by rw [inv_div]
  have hterm : ∀ n : ℕ, |a n - (1 / 2) * (b n - b (n + 1))| ≤ (4 / t) * q n := by
    intro n
    have h := term_split_le ht n
    have hnormsq : ‖(n : ℂ) + zq t‖ ^ 2 = ((n : ℝ) + 1 / 4) ^ 2 + (t / 2) ^ 2 := normSq_add_zq t n
    have hpos : (0 : ℝ) < ‖(n : ℂ) + zq t‖ := norm_pos_iff.mpr (add_zq_ne_zero t n)
    have ht2 : t / 2 ≤ ‖(n : ℂ) + zq t‖ := by
      nlinarith [sq_nonneg ((n : ℝ) + 1 / 4), Nat.cast_nonneg (α := ℝ) n]
    have hcube : 2 * (‖(n : ℂ) + zq t‖⁻¹) ^ 3 ≤ (4 / t) * q n := by
      simp only [hq]
      rw [← hnormsq]
      have hinv : ‖(n : ℂ) + zq t‖⁻¹ ≤ 2 / t := by
        rw [inv_le_comm₀ hpos (by positivity)]
        rw [inv_div]; linarith
      have hq0 : 0 ≤ (‖(n : ℂ) + zq t‖ ^ 2)⁻¹ := by positivity
      calc 2 * (‖(n : ℂ) + zq t‖⁻¹) ^ 3 = 2 * ‖(n : ℂ) + zq t‖⁻¹ * (‖(n : ℂ) + zq t‖ ^ 2)⁻¹ := by
            rw [inv_pow]; field_simp
        _ ≤ 2 * (2 / t) * (‖(n : ℂ) + zq t‖ ^ 2)⁻¹ := by gcongr
        _ = (4 / t) * (‖(n : ℂ) + zq t‖ ^ 2)⁻¹ := by ring
    have hb1 : b (n + 1) = ((((n + 1 : ℕ) : ℂ) + zq t)⁻¹).re := rfl
    simp only [ha, hb] at h ⊢
    exact h.trans hcube
  have hSbd : ∀ N, |S N| ≤ 48 / t ^ 2 := by
    intro N
    have h1 : |S N| ≤ ∑ n ∈ Finset.range N, (4 / t) * q n :=
      (Finset.abs_sum_le_sum_abs _ _).trans (Finset.sum_le_sum fun n _ => hterm n)
    have h2 : (∑ n ∈ Finset.range N, q n) ≤ 12 / t :=
      (Summable.sum_le_tsum _ (fun n _ => by simp only [hq]; positivity) hq_summ).trans
        (inv_quadratic_tsum_le ht1)
    rw [← Finset.mul_sum] at h1
    calc |S N| ≤ (4 / t) * ∑ n ∈ Finset.range N, q n := h1
      _ ≤ (4 / t) * (12 / t) := by gcongr
      _ = 48 / t ^ 2 := by ring
  have hfinal := le_of_tendsto hSlim.abs (Filter.Eventually.of_forall hSbd)
  have hb0 : b 0 = ((zq t)⁻¹).re := by simp [hb]
  rw [hb0] at hfinal
  rw [phasePoint_eq]
  have e : (Complex.digamma (zq t)).re - Real.log ‖zq t‖ + 1 / 2 * ((zq t)⁻¹).re
      = -((Real.log ‖zq t‖ - (Complex.digamma (zq t)).re) - 1 / 2 * (((zq t)⁻¹).re - 0)) := by ring
  rw [e, abs_neg]
  exact hfinal

end Stirling2

/-- info: 'Stirling2.digamma_second' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.digamma_second

namespace Stirling2
open Stage3

theorem log_norm_zq_le2 {t : ℝ} (ht : 1 ≤ t) :
    |Real.log ‖zq t‖ - Real.log (t / 2)| ≤ 1 / (8 * t ^ 2) := by
  have ht0 : (0 : ℝ) < t := by linarith
  have hsq : ‖zq t‖ ^ 2 = (1 / 4) ^ 2 + (t / 2) ^ 2 := by
    have := normSq_add_zq t 0; simpa using this
  have hpos : (0 : ℝ) < ‖zq t‖ := by
    have h0 := add_zq_ne_zero t 0
    simp only [Nat.cast_zero, zero_add] at h0
    exact norm_pos_iff.mpr h0
  have hx : 0 ≤ 1 / (4 * t ^ 2) := by positivity
  have hratio : (‖zq t‖ / (t / 2)) ^ 2 = 1 + 1 / (4 * t ^ 2) := by
    rw [div_pow, hsq]; field_simp; ring
  have hlog : Real.log ‖zq t‖ - Real.log (t / 2) = (1 / 2) * Real.log (1 + 1 / (4 * t ^ 2)) := by
    rw [← hratio, Real.log_pow, ← Real.log_div (ne_of_gt hpos) (by positivity)]
    push_cast; ring
  rw [hlog]
  have h1 : 0 ≤ Real.log (1 + 1 / (4 * t ^ 2)) := Real.log_nonneg (by linarith)
  have h2 : Real.log (1 + 1 / (4 * t ^ 2)) ≤ 1 / (4 * t ^ 2) := by
    have := Real.log_le_sub_one_of_pos (show (0:ℝ) < 1 + 1 / (4 * t ^ 2) by positivity); linarith
  rw [abs_of_nonneg (by positivity)]
  have : (1 : ℝ) / 2 * (1 / (4 * t ^ 2)) = 1 / (8 * t ^ 2) := by field_simp; ring
  nlinarith

theorem re_inv_zq_le {t : ℝ} (ht : 1 ≤ t) : |((zq t)⁻¹).re| ≤ 1 / t ^ 2 := by
  have ht0 : (0 : ℝ) < t := by linarith
  have hsq : Complex.normSq (zq t) = (1 / 4) ^ 2 + (t / 2) ^ 2 := by
    have := normSq_add_zq t 0
    rw [Complex.normSq_eq_norm_sq]; simpa using this
  have hre : (zq t).re = 1 / 4 := by
    simp [zq, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  rw [Complex.inv_re, hre, hsq, abs_of_nonneg (by positivity), div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith

/-- **The digamma comparison of order `1/t²`.** For `t ≥ 4`, `|Re ψ(z) − log(t/2)| ≤ 49/t²`. -/
theorem digammaLog2 {t : ℝ} (ht : 4 ≤ t) : |phasePoint t - Real.log (t / 2)| ≤ 49 / t ^ 2 := by
  have ht1 : (1 : ℝ) ≤ t := by linarith
  have h1 := digamma_second ht
  have h2 := log_norm_zq_le2 ht1
  have h3 := re_inv_zq_le ht1
  have ht0 : (0 : ℝ) < t := by linarith
  have e1 : (1 : ℝ) / (8 * t ^ 2) = (1 / 8) * (1 / t ^ 2) := by field_simp
  have e2 : (48 : ℝ) / t ^ 2 = 48 * (1 / t ^ 2) := by ring
  have e3 : (49 : ℝ) / t ^ 2 = 49 * (1 / t ^ 2) := by ring
  have hu : 0 ≤ 1 / t ^ 2 := by positivity
  have htri : |phasePoint t - Real.log (t / 2)|
      ≤ |phasePoint t - Real.log ‖zq t‖ + (1 / 2) * ((zq t)⁻¹).re|
        + |(1 / 2) * ((zq t)⁻¹).re| + |Real.log ‖zq t‖ - Real.log (t / 2)| := by
    have := abs_add_three (phasePoint t - Real.log ‖zq t‖ + (1 / 2) * ((zq t)⁻¹).re)
      (-((1 / 2) * ((zq t)⁻¹).re)) (Real.log ‖zq t‖ - Real.log (t / 2))
    rw [abs_neg] at this
    calc _ = |(phasePoint t - Real.log ‖zq t‖ + (1 / 2) * ((zq t)⁻¹).re)
          + (-((1 / 2) * ((zq t)⁻¹).re)) + (Real.log ‖zq t‖ - Real.log (t / 2))| := by ring_nf
      _ ≤ _ := this
  have h4 : |(1 / 2) * ((zq t)⁻¹).re| ≤ (1 / 2) * (1 / t ^ 2) := by
    rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 1 / 2)]; linarith
  linarith

end Stirling2

/-- info: 'Stirling2.digammaLog2' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.digammaLog2

namespace Stirling2
open Stage3

theorem band_int {a b C : ℝ} (ha : 1 ≤ a) (hab : a ≤ b)
    (h : ∀ t, a ≤ t → |phasePoint t - Real.log (t / 2)| ≤ C * (t ^ (-2 : ℤ))) :
    |∫ t in a..b, (phasePoint t - Real.log (t / 2))| ≤ C * (a⁻¹ - b⁻¹) := by
  have h0 : (0 : ℝ) ∉ Set.uIcc a b := by
    rw [Set.uIcc_of_le hab]; rintro ⟨h1, _⟩; linarith
  have hlog : IntervalIntegrable (fun t => Real.log (t / 2)) MeasureTheory.volume a b := by
    apply ContinuousOn.intervalIntegrable
    intro t ht
    rw [Set.uIcc_of_le hab] at ht
    have ht0 : (0 : ℝ) < t := by linarith [ht.1]
    exact ((Real.continuousAt_log (by positivity)).comp
      (by fun_prop : ContinuousAt (fun u : ℝ => u / 2) t)).continuousWithinAt
  have hgi : IntervalIntegrable (fun t : ℝ => C * t ^ (-2 : ℤ)) MeasureTheory.volume a b := by
    apply ContinuousOn.intervalIntegrable
    apply ContinuousOn.mul continuousOn_const
    intro t ht
    have : t ≠ 0 := fun h' => h0 (h' ▸ ht)
    exact (continuousAt_zpow₀ t (-2) (Or.inl this)).continuousWithinAt
  have hb := intervalIntegral.norm_integral_le_of_norm_le (μ := MeasureTheory.volume)
    (f := fun t => phasePoint t - Real.log (t / 2)) (g := fun t => C * t ^ (-2 : ℤ)) hab
    (by filter_upwards with t ht; rw [Real.norm_eq_abs]; exact h t (le_of_lt ht.1)) hgi
  rw [Real.norm_eq_abs] at hb
  refine hb.trans (le_of_eq ?_)
  rw [intervalIntegral.integral_const_mul, integral_zpow (Or.inr ⟨by norm_num, h0⟩)]
  have ha0 : a ≠ 0 := by positivity
  have hb0 : b ≠ 0 := by linarith
  norm_num
  left; ring

/-- **The phase's band integral is bounded by a constant.** For `T ≥ 2`,
`|∫₁ᵀ (Re ψ − log(t/2))| ≤ 147`. -/
theorem band_le_147 {T : ℝ} (hT : 2 ≤ T) :
    |∫ t in (1 : ℝ)..T, (phasePoint t - Real.log (t / 2))| ≤ 147 := by
  have hl4 : Real.log 4 < 1.3863 := by
    have : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]; norm_num
    rw [this]; have := Real.log_two_lt_d9; linarith
  have hband97 : ∀ t : ℝ, 1 ≤ t → |phasePoint t - Real.log (t / 2)| ≤ 97 * (t ^ (-1 : ℤ)) := by
    intro t ht
    have := stmtDigammaLog_holds.1 t ht
    rw [zpow_neg_one, ← div_eq_mul_inv]; exact this
  -- ∫₁ˢ with s ≤ 4 under 97/t: at most 97·log s ≤ 97·log 4
  have hfirst : ∀ s, 1 ≤ s → s ≤ 4 →
      |∫ t in (1 : ℝ)..s, (phasePoint t - Real.log (t / 2))| ≤ 97 * Real.log 4 := by
    intro s hs1 hs4
    have h0 : (0 : ℝ) ∉ Set.uIcc 1 s := by
      rw [Set.uIcc_of_le hs1]; rintro ⟨h1, _⟩; linarith
    have hgi : IntervalIntegrable (fun t : ℝ => 97 * t⁻¹) MeasureTheory.volume 1 s := by
      apply ContinuousOn.intervalIntegrable
      apply ContinuousOn.mul continuousOn_const
      intro t ht
      have : t ≠ 0 := fun h' => h0 (h' ▸ ht)
      exact (continuousAt_inv₀ this).continuousWithinAt
    have hb := intervalIntegral.norm_integral_le_of_norm_le (μ := MeasureTheory.volume)
      (f := fun t => phasePoint t - Real.log (t / 2)) (g := fun t => 97 * t⁻¹) hs1
      (by
        filter_upwards with t ht
        rw [Real.norm_eq_abs]
        have := hband97 t (le_of_lt ht.1)
        rwa [zpow_neg_one] at this) hgi
    rw [Real.norm_eq_abs, intervalIntegral.integral_const_mul, integral_inv h0] at hb
    simp only [div_one] at hb
    have : Real.log s ≤ Real.log 4 := Real.log_le_log (by linarith) hs4
    nlinarith
  by_cases h4 : T ≤ 4
  · have := hfirst T (by linarith) h4; nlinarith
  · push_neg at h4
    have hi1 : IntervalIntegrable (fun t => phasePoint t - Real.log (t / 2)) MeasureTheory.volume 1 4 := by
      refine (intervalIntegrable_phasePoint 1 4).sub ?_
      apply ContinuousOn.intervalIntegrable
      intro t ht; rw [Set.uIcc_of_le (by norm_num)] at ht
      have ht0 : (0 : ℝ) < t := by linarith [ht.1]
      exact ((Real.continuousAt_log (by positivity)).comp
        (by fun_prop : ContinuousAt (fun u : ℝ => u / 2) t)).continuousWithinAt
    have hi2 : IntervalIntegrable (fun t => phasePoint t - Real.log (t / 2)) MeasureTheory.volume 4 T := by
      refine (intervalIntegrable_phasePoint 4 T).sub ?_
      apply ContinuousOn.intervalIntegrable
      intro t ht; rw [Set.uIcc_of_le h4.le] at ht
      have ht0 : (0 : ℝ) < t := by linarith [ht.1]
      exact ((Real.continuousAt_log (by positivity)).comp
        (by fun_prop : ContinuousAt (fun u : ℝ => u / 2) t)).continuousWithinAt
    rw [← intervalIntegral.integral_add_adjacent_intervals hi1 hi2]
    have hA := hfirst 4 (by norm_num) le_rfl
    have hB := band_int (a := 4) (b := T) (C := 49) (by norm_num) h4.le (fun t ht => by
      have := digammaLog2 ht
      rwa [zpow_neg, zpow_ofNat, ← div_eq_mul_inv])
    have hT0 : (0 : ℝ) < T := by linarith
    have hinv : (4 : ℝ)⁻¹ - T⁻¹ ≤ 1 / 4 := by
      have : 0 < T⁻¹ := inv_pos.mpr hT0; norm_num; linarith
    calc _ ≤ |∫ t in (1 : ℝ)..4, (phasePoint t - Real.log (t / 2))|
          + |∫ t in (4 : ℝ)..T, (phasePoint t - Real.log (t / 2))| := abs_add_le _ _
      _ ≤ 97 * Real.log 4 + 49 * ((4 : ℝ)⁻¹ - T⁻¹) := add_le_add hA hB
      _ ≤ 147 := by nlinarith

end Stirling2

/-- info: 'Stirling2.band_le_147' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stirling2.band_le_147
