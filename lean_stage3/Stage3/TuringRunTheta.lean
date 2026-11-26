/-
TuringRunTheta — block S14 of `lean_stage3/design/stencil.md`, Turing's point run: the phase `θ`
as the imaginary part of `Stirling.logG`, and its enclosure from Stirling's series. 2026-11-25.

`Stage3.phaseTheta T = ½ ∫₀ᵀ Re ψ(1/4 + it/2) dt − (T/2) log π` is defined by the integral of its
derivative. `Stirling.logG z = lim logGammaSeq z n` is differentiable on `Re z > 0` with derivative
`ψ` (`hasDerivAt_logG`: the proof of PNT+'s `Complex.hasSum_digamma_of_re_pos`, which
differentiates exactly this limit, stopped at the derivative), so `t ↦ Im logG(1/4 + it/2)` has
derivative `½ Re ψ(1/4 + it/2)`, and `logG(1/4)` is real (every `logGammaSeq (1/4) n` is a sum of
logarithms of positive reals). The fundamental theorem of calculus gives

  `phaseTheta T = Im logG(1/4 + iT/2) − (T/2) log π`                 (`phaseTheta_eq_logG`),

and `StirlingSeriesK5.gamma_phase_ball5` with a ball for `log π` encloses it (`phaseTheta_ball`).

| name | content | status |
|---|---|---|
| `hasDerivAt_logG` | `0 < Re z ⊢ HasDerivAt logG (ψ z) z` | proved |
| `logG_quarter_im` | `Im logG(1/4) = 0` | proved |
| `phaseTheta_eq_logG` | `phaseTheta T = Im logG(zz T) − (T/2) log π` | proved |
| `phaseTheta_ball` | balls for `Im logG(zz T)` and `log π` ⊢ a ball for `phaseTheta T` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesK5
import Stage3.TuringS

namespace TuringRun

open Complex Filter Topology

noncomputable section

/-- **`logG` is a primitive of `ψ`** on the right half-plane. The argument of
`Complex.hasSum_digamma_of_re_pos` (PNT+), stopped at the derivative. -/
theorem hasDerivAt_logG {z₀ : ℂ} (hz₀ : 0 < z₀.re) :
    HasDerivAt Stirling.logG (digamma z₀) z₀ := by
  set a : ℝ := min (z₀.re / 2) 1 with ha_def
  set R : ℝ := ‖z₀‖ + 1 with hR_def
  have ha : 0 < a := lt_min (by linarith) one_pos
  have ha1 : a ≤ 1 := min_le_right _ _
  set s : Set ℂ := {w : ℂ | a < w.re} ∩ {w : ℂ | ‖w‖ < R} with hs_def
  have hs_open : IsOpen s :=
    (isOpen_lt continuous_const continuous_re).inter (isOpen_lt continuous_norm continuous_const)
  have haz : a < z₀.re := by
    rw [ha_def]
    exact lt_of_le_of_lt (min_le_left _ _) (by linarith)
  have hz₀R : ‖z₀‖ < R := by rw [hR_def]; linarith
  have hz₀s : z₀ ∈ s := ⟨haz, hz₀R⟩
  have hmem : ∀ w ∈ s, a ≤ w.re ∧ ‖w‖ ≤ R := fun w hw => ⟨le_of_lt hw.1, le_of_lt hw.2⟩
  have hre_pos : ∀ w ∈ s, 0 < w.re := fun w hw => lt_trans ha hw.1
  have hu : Summable (fun m : ℕ => (R + 1) / (a * ((m : ℝ) + 1) ^ 2)) := by
    refine (Complex.summable_one_div_natCast_add_one_sq.mul_left ((R + 1) / a)).congr fun m => ?_
    rw [mul_one_div, div_div]
  have hM : TendstoUniformlyOn
      (fun (N : ℕ) (w : ℂ) => ∑ m ∈ Finset.range N, (((m : ℂ) + 1)⁻¹ - (w + m)⁻¹))
      (fun (w : ℂ) => ∑' m : ℕ, (((m : ℂ) + 1)⁻¹ - (w + m)⁻¹)) atTop s :=
    tendstoUniformlyOn_tsum_nat hu fun m w hw =>
      Complex.norm_inv_add_one_sub_inv_le ha ha1 (hmem w hw).1 (hmem w hw).2 m
  have hM1 : TendstoUniformlyOn
      (fun (n : ℕ) (w : ℂ) => ∑ m ∈ Finset.range (n + 1), (((m : ℂ) + 1)⁻¹ - (w + m)⁻¹))
      (fun (w : ℂ) => ∑' m : ℕ, (((m : ℂ) + 1)⁻¹ - (w + m)⁻¹)) atTop s := by
    intro u hu'
    exact (tendsto_add_atTop_nat 1).eventually (hM u hu')
  have hcR : Tendsto (fun n : ℕ => Real.log n - (harmonic n : ℝ) - ((n : ℝ) + 1)⁻¹) atTop
      (𝓝 (-Real.eulerMascheroniConstant)) := by
    have h1 : Tendsto (fun n : ℕ => Real.log n - (harmonic n : ℝ)) atTop
        (𝓝 (-Real.eulerMascheroniConstant)) :=
      Real.tendsto_harmonic_sub_log.neg.congr fun n => by ring
    have h2 : Tendsto (fun n : ℕ => ((n : ℝ) + 1)⁻¹) atTop (𝓝 0) := by
      apply Filter.Tendsto.inv_tendsto_atTop
      exact tendsto_atTop_add_const_right atTop 1 tendsto_natCast_atTop_atTop
    simpa using h1.sub h2
  have hcC : Tendsto (fun n : ℕ => ((Real.log n - (harmonic n : ℝ) - ((n : ℝ) + 1)⁻¹ : ℝ) : ℂ))
      atTop (𝓝 (-(Real.eulerMascheroniConstant : ℂ))) := by
    have h := (continuous_ofReal.tendsto (-Real.eulerMascheroniConstant)).comp hcR
    have hval : ((-Real.eulerMascheroniConstant : ℝ) : ℂ) = -(Real.eulerMascheroniConstant : ℂ) := by
      push_cast
      ring
    rw [← hval]
    exact h
  have hcU := hcC.tendstoUniformlyOn_const s
  have hF' : TendstoUniformlyOn
      (fun (n : ℕ) (w : ℂ) => (Real.log n : ℂ) - ∑ m ∈ Finset.range (n + 1), (w + m)⁻¹)
      (fun (w : ℂ) => -(Real.eulerMascheroniConstant : ℂ)
        + ∑' m : ℕ, (((m : ℂ) + 1)⁻¹ - (w + m)⁻¹)) atTop s := by
    have hadd := hcU.add hM1
    refine hadd.congr ?_
    filter_upwards with n
    intro w hw
    simp only [Pi.add_apply]
    rw [Finset.sum_sub_distrib, Complex.sum_inv_natCast_add_one (n + 1)]
    push_cast [harmonic_succ]
    ring
  have hderiv : ∀ n : ℕ, ∀ x : ℂ, x ∈ s →
      HasDerivAt (fun w => Complex.logGammaSeq w n)
        ((Real.log n : ℂ) - ∑ m ∈ Finset.range (n + 1), (x + m)⁻¹) x := by
    intro n x hx
    have hre : 0 < x.re := hre_pos x hx
    have h1 : HasDerivAt (fun w : ℂ => w * (Real.log n : ℂ) + (Real.log (n.factorial) : ℂ))
        ((Real.log n : ℂ)) x := (hasDerivAt_mul_const _).add_const _
    have h2 : HasDerivAt (fun w : ℂ => ∑ m ∈ Finset.range (n + 1), log (w + m))
        (∑ m ∈ Finset.range (n + 1), (x + m)⁻¹) x := by
      apply HasDerivAt.fun_sum
        (A := fun (m : ℕ) (w : ℂ) => log (w + m)) (A' := fun m : ℕ => (x + m)⁻¹)
      intro m _
      have hmem : x + (m : ℂ) ∈ slitPlane := by
        rw [mem_slitPlane_iff]
        left
        rw [add_re, natCast_re]
        have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
        linarith
      have hinner : HasDerivAt (fun w : ℂ => w + (m : ℂ)) 1 x := (hasDerivAt_id x).add_const _
      simpa using! (hasDerivAt_log hmem).comp x hinner
    simpa only [Complex.logGammaSeq] using! h1.sub h2
  have hptw : ∀ x : ℂ, x ∈ s →
      Tendsto (fun n => Complex.logGammaSeq x n) atTop
        (𝓝 (limUnder atTop (Complex.logGammaSeq x))) :=
    fun x hx => (Complex.cauchySeq_logGammaSeq (hre_pos x hx)).tendsto_limUnder
  have hkey : HasDerivAt (fun w => limUnder atTop (Complex.logGammaSeq w))
      (-(Real.eulerMascheroniConstant : ℂ)
        + ∑' m : ℕ, (((m : ℂ) + 1)⁻¹ - (z₀ + m)⁻¹)) z₀ :=
    hasDerivAt_of_tendstoUniformlyOn hs_open hF'
      (Filter.Eventually.of_forall fun n x hx => hderiv n x hx) hptw hz₀s
  have hdig : digamma z₀ = -(Real.eulerMascheroniConstant : ℂ)
      + ∑' m : ℕ, (((m : ℂ) + 1)⁻¹ - (z₀ + m)⁻¹) := by
    rw [(Complex.hasSum_digamma_of_re_pos hz₀).tsum_eq]
    ring
  rw [hdig]
  exact hkey

/-- Every `logGammaSeq (1/4) n` is real. -/
theorem logGammaSeq_quarter_im (n : ℕ) : (Complex.logGammaSeq (1 / 4) n).im = 0 := by
  unfold Complex.logGammaSeq
  have hterm : ∀ m ∈ Finset.range (n + 1), (log ((1 / 4 : ℂ) + m)).im = 0 := by
    intro m _
    have e : (1 / 4 : ℂ) + m = ((1 / 4 + m : ℝ) : ℂ) := by push_cast; ring
    rw [e, ← Complex.ofReal_log (by positivity), Complex.ofReal_im]
  rw [Complex.sub_im, Complex.im_sum, Finset.sum_eq_zero hterm, Complex.add_im, Complex.mul_im,
    Complex.ofReal_im, Complex.ofReal_im]
  norm_num

/-- **`logG(1/4)` is real.** -/
theorem logG_quarter_im : (Stirling.logG (1 / 4)).im = 0 := by
  have h := (Complex.continuous_im.tendsto _).comp
    (Stirling.tendsto_logG (z := 1 / 4) (by norm_num))
  have h0 : Tendsto (fun n : ℕ => (Complex.logGammaSeq (1 / 4) n).im) atTop (𝓝 0) := by
    simp only [logGammaSeq_quarter_im]
    exact tendsto_const_nhds
  exact tendsto_nhds_unique h h0

theorem zz_eq (t : ℝ) : SignData.zz t = (1 : ℂ) / 4 + (t : ℂ) / 2 * I := by
  unfold SignData.zz
  push_cast
  ring

/-- **The phase as `Im logG`**: `phaseTheta T = Im logG(1/4 + iT/2) − (T/2) log π`. -/
theorem phaseTheta_eq_logG (T : ℝ) :
    Stage3.phaseTheta T = (Stirling.logG (SignData.zz T)).im - T / 2 * Real.log Real.pi := by
  set F : ℝ → ℝ := fun t => (Stirling.logG ((1 : ℂ) / 4 + (t : ℂ) / 2 * I)).im with hF
  have hd : ∀ t : ℝ, HasDerivAt F (Stage3.phasePoint t / 2) t := by
    intro t
    have hre : 0 < ((1 : ℂ) / 4 + (t : ℂ) / 2 * I).re := by simp
    have hL := hasDerivAt_logG hre
    have hin : HasDerivAt (fun w : ℂ => (1 : ℂ) / 4 + w / 2 * I) (I / 2) (t : ℂ) := by
      have h1 := (((hasDerivAt_id (t : ℂ)).div_const 2).mul_const I).const_add ((1 : ℂ) / 4)
      exact h1.congr_deriv (by ring)
    have hc : HasDerivAt (fun w : ℂ => Stirling.logG ((1 : ℂ) / 4 + w / 2 * I))
        (digamma ((1 : ℂ) / 4 + (t : ℂ) / 2 * I) * (I / 2)) (t : ℂ) :=
      HasDerivAt.comp (t : ℂ) (h₂ := Stirling.logG) hL hin
    have hr := hc.comp_ofReal
    have him := Complex.imCLM.hasFDerivAt.comp_hasDerivAt t hr
    have e : Complex.imCLM (digamma ((1 : ℂ) / 4 + (t : ℂ) / 2 * I) * (I / 2))
        = Stage3.phasePoint t / 2 := by
      simp [Stage3.phasePoint, div_eq_mul_inv]
    rw [e] at him
    exact him
  have hint : IntervalIntegrable (fun t => Stage3.phasePoint t / 2) MeasureTheory.volume 0 T :=
    (Stage3.intervalIntegrable_phasePoint 0 T).div_const 2
  have hftc := intervalIntegral.integral_eq_sub_of_hasDerivAt (fun t _ => hd t) hint
  have h0 : F 0 = 0 := by
    simp only [hF, Complex.ofReal_zero, zero_div, zero_mul, add_zero]
    exact logG_quarter_im
  rw [h0, sub_zero, intervalIntegral.integral_div] at hftc
  have hFT : F T = (Stirling.logG ((1 : ℂ) / 4 + (T : ℂ) / 2 * I)).im := rfl
  unfold Stage3.phaseTheta
  rw [zz_eq]
  linarith

/-- **The enclosure of `θ`**: from `|Im logG(zz T) − φ₀| ≤ E` and `|log π − c| ≤ eπ`,
`|phaseTheta T − (φ₀ − (T/2) c)| ≤ E + |T/2| eπ`. -/
theorem phaseTheta_ball {T φ₀ E c eπ : ℝ}
    (hφ : |(Stirling.logG (SignData.zz T)).im - φ₀| ≤ E)
    (hπ : |Real.log Real.pi - c| ≤ eπ) :
    |Stage3.phaseTheta T - (φ₀ - T / 2 * c)| ≤ E + |T / 2| * eπ := by
  rw [phaseTheta_eq_logG]
  have e : (Stirling.logG (SignData.zz T)).im - T / 2 * Real.log Real.pi - (φ₀ - T / 2 * c)
      = ((Stirling.logG (SignData.zz T)).im - φ₀) - T / 2 * (Real.log Real.pi - c) := by ring
  rw [e]
  have h1 := abs_sub ((Stirling.logG (SignData.zz T)).im - φ₀) (T / 2 * (Real.log Real.pi - c))
  have h2 : |T / 2 * (Real.log Real.pi - c)| ≤ |T / 2| * eπ := by
    rw [abs_mul]; exact mul_le_mul_of_nonneg_left hπ (abs_nonneg _)
  linarith

end

/-- info: 'TuringRun.hasDerivAt_logG' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hasDerivAt_logG

/-- info: 'TuringRun.phaseTheta_eq_logG' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phaseTheta_eq_logG

/-- info: 'TuringRun.phaseTheta_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phaseTheta_ball

end TuringRun
