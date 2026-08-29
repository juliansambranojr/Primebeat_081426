/-
# Zeta growth on the strip `re > −1` (S3a — the load-bearing unknown of S3)

Second-order Euler–Maclaurin: one integration by parts past PNT+'s
`riemannZeta0`. The antiderivative `emA x = ({x} − {x}²)/2` of
`⌊x⌋ + 1/2 − x` vanishes at every integer, so the per-interval boundary
terms die and the new tail converges absolutely on `re s > −1`.

Target: `‖ζ(σ+it)‖ ≤ C·|t|^3` (crude) on `σ ∈ [−1/2, 2]`, `|t| ≥ 2` —
the growth input for the rescaled Landau ball of S3.

SCRATCH until the growth bound lands; do not count in sorry-free claims.
-/
import PrimeNumberTheoremAnd.ZetaBounds

namespace ZetaGrowth

open Complex MeasureTheory Set intervalIntegral

/-- The Euler–Maclaurin antiderivative: `({x} − {x}²)/2`. -/
noncomputable def emA (x : ℝ) : ℝ := (Int.fract x - Int.fract x ^ 2) / 2

theorem emA_nonneg (x : ℝ) : 0 ≤ emA x := by
  rw [emA]
  have h1 := Int.fract_nonneg x
  have h2 := (Int.fract_lt_one x).le
  nlinarith

theorem emA_le (x : ℝ) : emA x ≤ 1/8 := by
  rw [emA]
  nlinarith [sq_nonneg (Int.fract x - 1/2)]

theorem emA_natCast (n : ℕ) : emA n = 0 := by
  rw [emA]
  simp

/-- On `[n, n+1]`, `emA` agrees with the polynomial `((x−n) − (x−n)²)/2`
— including at the right endpoint, where both vanish. -/
theorem emA_eq_poly {n : ℕ} {x : ℝ} (h1 : (n:ℝ) ≤ x) (h2 : x ≤ n+1) :
    emA x = ((x - n) - (x - n)^2)/2 := by
  rcases eq_or_lt_of_le h2 with h3 | h3
  · rw [h3, show ((n:ℝ)+1) = ((n+1 : ℕ):ℝ) by push_cast; ring, emA_natCast]
    push_cast
    ring
  · have h5 : ⌊x⌋ = (n:ℤ) := by
      rw [Int.floor_eq_iff]
      constructor
      · exact_mod_cast h1
      · push_cast
        linarith
    rw [emA, Int.fract, h5]
    push_cast
    ring

/-- The second-order tail integrand is integrable on `Ioi N` whenever
`re s > −1`. -/
theorem integrable_emA_tail {N : ℕ} (Npos : 0 < N) {s : ℂ} (hs : -1 < s.re) :
    IntegrableOn (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2))) (Ioi (N:ℝ)) := by
  have hmeas : AEStronglyMeasurable (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2)))
      (volume.restrict (Ioi (N:ℝ))) := by
    apply AEStronglyMeasurable.mul
    · apply Measurable.aestronglyMeasurable
      apply Measurable.comp Complex.measurable_ofReal
      apply Measurable.div_const
      apply Measurable.sub measurable_fract
      exact measurable_fract.pow_const 2
    · apply ContinuousOn.aestronglyMeasurable ?_ measurableSet_Ioi
      intro x hx
      apply ContinuousAt.continuousWithinAt
      apply ContinuousAt.cpow Complex.continuous_ofReal.continuousAt continuousAt_const
      rw [Set.mem_Ioi] at hx
      rw [Complex.ofReal_mem_slitPlane]
      have hN : (0:ℝ) < (N:ℝ) := by exact_mod_cast Npos
      linarith
  apply Integrable.mono' (g := fun x : ℝ ↦ (1/8) * x ^ (-s.re - 2)) ?_ hmeas
  · filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
    rw [Set.mem_Ioi] at hx
    have hN : (0:ℝ) ≤ (N:ℝ) := Nat.cast_nonneg N
    have hx0 : 0 < x := by linarith
    rw [norm_mul, Complex.norm_real, Complex.norm_cpow_eq_rpow_re_of_pos hx0]
    have h1 : |emA x| = emA x := abs_of_nonneg (emA_nonneg x)
    rw [Real.norm_eq_abs, h1]
    have h2 : (-(s+2)).re = -s.re - 2 := by
      simp
      ring
    rw [h2]
    have h3 : (0:ℝ) ≤ x ^ (-s.re - 2) := Real.rpow_nonneg hx0.le _
    nlinarith [emA_le x]
  · apply Integrable.const_mul
    apply integrableOn_Ioi_rpow_of_lt (by linarith)
    exact_mod_cast Npos

/-- **The per-interval integration by parts.** On `[n, n+1]` with
`n ≥ 1`, the first-order tail integrand integrates to `(s+1)` times the
second-order one — the boundary terms vanish at the integers. -/
theorem interval_ibp {n : ℕ} (hn : 1 ≤ n) {s : ℂ} (hs1 : s ≠ -1) :
    ∫ x in (n:ℝ)..((n:ℝ)+1), ((((⌊x⌋ : ℝ) + 1/2 - x : ℝ)) : ℂ) * (x:ℂ) ^ (-(s+1))
      = (s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) := by
  have hn1 : (1:ℝ) ≤ (n:ℝ) := by exact_mod_cast hn
  have hposI : ∀ x ∈ Set.uIcc (n:ℝ) ((n:ℝ)+1), (0:ℝ) < x := by
    intro x hx
    rw [Set.uIcc_of_le (by linarith)] at hx
    linarith [hx.1]
  have hne : -(s+1) ≠ 0 := by
    intro h
    apply hs1
    linear_combination -h
  have hcpow_cont : ∀ r : ℂ, ContinuousOn (fun x : ℝ ↦ (x:ℂ) ^ r)
      (Set.uIcc (n:ℝ) ((n:ℝ)+1)) := by
    intro r x hx
    apply ContinuousAt.continuousWithinAt
    apply ContinuousAt.cpow Complex.continuous_ofReal.continuousAt continuousAt_const
    rw [Complex.ofReal_mem_slitPlane]
    exact hposI x hx
  have hF : ∀ x ∈ Set.uIcc (n:ℝ) ((n:ℝ)+1), HasDerivAt
      (fun x : ℝ ↦ ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+1)))
      ((((1 - 2*(x - n))/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+1))
        + ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (-(s+1) * (x:ℂ) ^ (-(s+1) - 1))) x := by
    intro x hx
    have hx0 : (0:ℝ) < x := hposI x hx
    apply HasDerivAt.mul
    · have h1 : HasDerivAt (fun y : ℝ ↦ y - (n:ℝ)) 1 x := (hasDerivAt_id x).sub_const _
      have h2 : HasDerivAt (fun y : ℝ ↦ (y - (n:ℝ))^2) (2*(x - n)) x := by
        have h3 := h1.mul h1
        have h4 : (fun y : ℝ ↦ (y - (n:ℝ))^2) = fun y : ℝ ↦ (y - n)*(y - n) := by
          funext y
          ring
        have h5 : (1:ℝ) * (x - n) + (x - n) * 1 = 2*(x - n) := by ring
        rw [h4, ← h5]
        exact h3
      have h4 : HasDerivAt (fun y : ℝ ↦ ((y - n) - (y - n)^2)/2) ((1 - 2*(x - n))/2) x :=
        (h1.sub h2).div_const 2
      exact h4.ofReal_comp
    · exact hasDerivAt_ofReal_cpow_const hx0.ne' hne
  have hint1 : IntervalIntegrable
      (fun x : ℝ ↦ ((((1 - 2*(x - n))/2 : ℝ)) : ℂ) * (x:ℂ) ^ (-(s+1)))
      volume (n:ℝ) ((n:ℝ)+1) := by
    apply ContinuousOn.intervalIntegrable
    apply ContinuousOn.mul ?_ (hcpow_cont _)
    exact (Complex.continuous_ofReal.comp (by fun_prop)).continuousOn
  have hint2 : IntervalIntegrable
      (fun x : ℝ ↦ ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ)
        * (-(s+1) * (x:ℂ) ^ (-(s+1) - 1)))
      volume (n:ℝ) ((n:ℝ)+1) := by
    apply ContinuousOn.intervalIntegrable
    apply ContinuousOn.mul
    · exact (Complex.continuous_ofReal.comp (by fun_prop)).continuousOn
    · exact ContinuousOn.mul continuousOn_const (hcpow_cont _)
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDerivAt hF (hint1.add hint2)
  have hF0 : (fun x : ℝ ↦ ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+1)))
        ((n:ℝ)+1)
      - (fun x : ℝ ↦ ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+1))) (n:ℝ)
      = 0 := by
    simp
  rw [hF0, intervalIntegral.integral_add hint1 hint2] at hFTC
  have hcongr1 : ∫ x in (n:ℝ)..((n:ℝ)+1),
        ((((⌊x⌋ : ℝ) + 1/2 - x : ℝ)) : ℂ) * (x:ℂ) ^ (-(s+1))
      = ∫ x in (n:ℝ)..((n:ℝ)+1),
        ((((1 - 2*(x - n))/2 : ℝ)) : ℂ) * (x:ℂ) ^ (-(s+1)) := by
    apply intervalIntegral.integral_congr_ae
    have hae : ∀ᵐ x ∂(volume : Measure ℝ), x ≠ (n:ℝ)+1 := by
      rw [MeasureTheory.ae_iff]
      have h5 : {x : ℝ | ¬x ≠ (n:ℝ)+1} = {(n:ℝ)+1} := by
        ext y
        simp
      rw [h5]
      exact Real.volume_singleton
    filter_upwards [hae] with x hxne hxI
    rw [Set.uIoc_of_le (by linarith : (n:ℝ) ≤ (n:ℝ)+1)] at hxI
    have hlt : x < (n:ℝ)+1 := lt_of_le_of_ne hxI.2 hxne
    have hfl : ⌊x⌋ = (n:ℤ) := by
      rw [Int.floor_eq_iff]
      constructor
      · exact_mod_cast hxI.1.le
      · push_cast
        linarith
    rw [hfl]
    congr 1
    push_cast
    ring
  have hcongr2 : ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2))
      = ∫ x in (n:ℝ)..((n:ℝ)+1),
          ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+2)) := by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [Set.uIcc_of_le (by linarith)] at hx
    show (emA x : ℂ) * (x:ℂ) ^ (-(s+2))
        = ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+2))
    rw [emA_eq_poly hx.1 hx.2]
  have hpull : ∫ x in (n:ℝ)..((n:ℝ)+1),
      ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (-(s+1) * (x:ℂ) ^ (-(s+1) - 1))
      = -(s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1),
          ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+2)) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_congr
    intro x hx
    have hexp : (x:ℂ) ^ (-(s+1) - 1) = (x:ℂ) ^ (-(s+2)) := by
      congr 1
      ring
    show ((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (-(s+1) * (x:ℂ) ^ (-(s+1) - 1))
        = -(s+1) * (((((x - n) - (x - n)^2)/2 : ℝ) : ℂ) * (x:ℂ) ^ (-(s+2)))
    rw [hexp]
    ring
  rw [hcongr1, hcongr2]
  rw [hpull] at hFTC
  linear_combination hFTC

/-- info: 'ZetaGrowth.interval_ibp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms interval_ibp

/-- info: 'ZetaGrowth.integrable_emA_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integrable_emA_tail

end ZetaGrowth
