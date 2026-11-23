/-
LandauTaylor — the derivatives of `Phi` on `Re s > 1`, from the primes:

    iteratedDeriv k Phi s = ∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy.

Block 2c of `lean_stage3/design/landau.md`. 2026-11-22.

`Phi` is `LandauMellinG.Phi`, the Mellin transform of `G` (`mellin_G`). The
integral on the right is `mellinLog k s`. One derivative under the integral
sign takes `mellinLog k` to `mellinLog (k+1)`; the domination is
`|G(y)| ≤ 8y(1 + log y)` (`LandauChebyshev.abs_G_le_log`) against the
integrable kernels of `LandauKernel`. Then induction on `k`.

  mellinLog              the integral (the one definition)
  mellinLog_integrable   (hs : 1 < s.re) (k) : its integrand is integrable on (1, ∞)
  mellinLog_hasDerivAt   (hs : 1 < s.re) (k) :
                           HasDerivAt (mellinLog k) (mellinLog (k+1) s) s
  iteratedDeriv_Phi      (k) (hs : 1 < s.re) : iteratedDeriv k Phi s = mellinLog k s
  mellinLog_real         (σ) (k) :
                           mellinLog k σ = (−1)^k · ∫₁^∞ G(y)·(log y)^k·y^(−σ−1) dy

What the next slice needs: at a real `σ₀ > 1`, the Taylor coefficient of `Phi`
is `(−1)^k/k!` times a real integral of `G` against `(log y)^k y^(−σ₀−1)`; the
window bound on `G` and the tail of the kernel (block 4b) bound it from
above, the poles (block 3) from below.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauMellinG
import Stage3.LandauChebyshev
import Stage3.LandauKernel

namespace LandauTaylor

noncomputable section

open Complex MeasureTheory Set Filter Topology

/-- `∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy`. -/
def mellinLog (k : ℕ) (s : ℂ) : ℂ :=
  ∫ y in Ioi (1 : ℝ),
    (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)

/-- The domination: for `Re s ≥ 1 + a` the integrand is at most this. -/
private lemma integrand_norm_le {a : ℝ} {s : ℂ} (has : 1 + a ≤ s.re) (k : ℕ)
    {y : ℝ} (hy : 1 < y) :
    ‖(LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)‖
      ≤ 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1)) := by
  have hy0 : 0 < y := by linarith
  have hL : 0 ≤ Real.log y := Real.log_nonneg hy.le
  have hG := LandauChebyshev.abs_G_le_log hy.le
  have hre : (-s - 1).re = -s.re - 1 := by simp
  rw [norm_mul, norm_mul, norm_pow, norm_neg, Complex.norm_real, Complex.norm_real,
    Real.norm_eq_abs, Real.norm_of_nonneg hL, Complex.norm_cpow_eq_rpow_re_of_pos hy0, hre]
  have hP : 0 ≤ y ^ (-s.re - 1) := Real.rpow_nonneg hy0.le _
  have hyP : y * y ^ (-s.re - 1) ≤ y ^ (-a - 1) := by
    have e : y * y ^ (-s.re - 1) = y ^ (-s.re) := by
      rw [mul_comm, ← Real.rpow_add_one hy0.ne']; congr 1; ring
    rw [e]
    exact Real.rpow_le_rpow_of_exponent_le hy.le (by linarith)
  have hLk : 0 ≤ Real.log y ^ k := pow_nonneg hL k
  calc |LandauWindow.G y| * Real.log y ^ k * y ^ (-s.re - 1)
      ≤ (8 * y * (1 + Real.log y)) * Real.log y ^ k * y ^ (-s.re - 1) :=
        mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right hG hLk) hP
    _ = 8 * (1 + Real.log y) * Real.log y ^ k * (y * y ^ (-s.re - 1)) := by ring
    _ ≤ 8 * (1 + Real.log y) * Real.log y ^ k * y ^ (-a - 1) :=
        mul_le_mul_of_nonneg_left hyP (by positivity)
    _ = 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1)) := by ring

/-- Helper: for `a > 0`, the dominating function
`8·((log y)^k·y^(−a−1) + (log y)^(k+1)·y^(−a−1))` is integrable on `(1, ∞)`. -/
private lemma bound_integrable {a : ℝ} (ha : 0 < a) (k : ℕ) :
    IntegrableOn (fun y : ℝ =>
      8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1))) (Ioi 1) :=
  ((LandauKernel.log_pow_integrable ha k).add
    (LandauKernel.log_pow_integrable ha (k + 1))).const_mul 8

/-- For `Re s > 1` and every `k`, the integrand of `mellinLog k s`,
`G(y)·(−log y)^k·y^(−s−1)`, is integrable on `(1, ∞)`. -/
theorem mellinLog_integrable {s : ℂ} (hs : 1 < s.re) (k : ℕ) :
    IntegrableOn (fun y : ℝ =>
      (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)) (Ioi 1) := by
  have ha : 0 < s.re - 1 := by linarith
  have hcont : ContinuousOn (fun y : ℝ => (-(Real.log y : ℂ)) ^ k) (Ioi 1) := by
    intro y hy
    have hy0 : y ≠ 0 := by linarith [mem_Ioi.mp hy]
    have h1 : ContinuousAt (fun y : ℝ => (Real.log y : ℂ)) y :=
      Complex.continuous_ofReal.continuousAt.comp (Real.continuousAt_log hy0)
    exact (h1.neg.pow k).continuousWithinAt
  have hmeas : AEStronglyMeasurable (fun y : ℝ =>
      (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1))
      (volume.restrict (Ioi 1)) := by
    have h1 := (LandauMellinG.G_mellin_integrable hs).aestronglyMeasurable.mul
      (hcont.aestronglyMeasurable measurableSet_Ioi)
    refine h1.congr (Filter.Eventually.of_forall fun y => ?_)
    simp only [Pi.mul_apply]
    ring
  refine Integrable.mono' (bound_integrable ha k) hmeas ?_
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  exact integrand_norm_le (by linarith) k (mem_Ioi.mp hy)

/-- For `Re s > 1` and every `k`, the function `mellinLog k` has complex derivative
`mellinLog (k+1) s` at `s`. -/
theorem mellinLog_hasDerivAt {s : ℂ} (hs : 1 < s.re) (k : ℕ) :
    HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s := by
  have ha : 0 < (s.re - 1) / 2 := by linarith
  have hball : ∀ x ∈ Metric.ball s ((s.re - 1) / 2), 1 + (s.re - 1) / 2 ≤ x.re := by
    intro x hx
    have h1 : |(x - s).re| ≤ ‖x - s‖ := Complex.abs_re_le_norm _
    have h2 : ‖x - s‖ < (s.re - 1) / 2 := by simpa [dist_eq_norm] using hx
    have h3 := abs_le.mp (h1.trans h2.le)
    rw [Complex.sub_re] at h3
    linarith [h3.1]
  have key := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (μ := volume.restrict (Ioi (1 : ℝ)))
    (F := fun (x : ℂ) (y : ℝ) =>
      (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-x - 1))
    (F' := fun (x : ℂ) (y : ℝ) =>
      (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ (k + 1) * (y : ℂ) ^ (-x - 1))
    (x₀ := s) (s := Metric.ball s ((s.re - 1) / 2))
    (bound := fun y : ℝ => 8 * (Real.log y ^ (k + 1) * y ^ (-((s.re - 1) / 2) - 1)
      + Real.log y ^ (k + 1 + 1) * y ^ (-((s.re - 1) / 2) - 1)))
    (Metric.ball_mem_nhds s ha)
    (by
      filter_upwards [Metric.ball_mem_nhds s ha] with x hx
      exact (mellinLog_integrable (by linarith [hball x hx]) k).aestronglyMeasurable)
    (mellinLog_integrable hs k)
    (mellinLog_integrable hs (k + 1)).aestronglyMeasurable
    (by
      filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy x hx
      exact integrand_norm_le (hball x hx) (k + 1) (mem_Ioi.mp hy))
    (bound_integrable ha (k + 1))
    (by
      filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy x _
      have hy0 : (0 : ℝ) < y := by linarith [mem_Ioi.mp hy]
      have hyC : (y : ℂ) ≠ 0 := by exact_mod_cast hy0.ne'
      have h1 : HasDerivAt (fun z : ℂ => -z - 1) (-1) x :=
        ((hasDerivAt_id x).neg).sub_const 1
      have h2 := (h1.const_cpow (c := (y : ℂ)) (Or.inl hyC)).const_mul
        ((LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k)
      refine h2.congr_deriv ?_
      rw [← Complex.ofReal_log hy0.le]
      ring)
  exact key.2

/-- For `Re s > 1`, the `k`-th derivative of `Phi` at `s` equals `mellinLog k s`,
the integral `∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy`. -/
theorem iteratedDeriv_Phi (k : ℕ) {s : ℂ} (hs : 1 < s.re) :
    iteratedDeriv k LandauMellinG.Phi s = mellinLog k s := by
  induction k generalizing s with
  | zero =>
    rw [iteratedDeriv_zero, ← LandauMellinG.mellin_G hs, mellinLog]
    simp
  | succ k ih =>
    have hopen : {z : ℂ | 1 < z.re} ∈ 𝓝 s :=
      (isOpen_lt continuous_const Complex.continuous_re).mem_nhds hs
    have heq : iteratedDeriv k LandauMellinG.Phi =ᶠ[𝓝 s] mellinLog k := by
      filter_upwards [hopen] with z hz
      exact ih hz
    rw [iteratedDeriv_succ, heq.deriv_eq]
    exact (mellinLog_hasDerivAt hs k).deriv

/-- At a real point `σ`, `mellinLog k σ` equals `(−1)^k` times the real integral
`∫₁^∞ G(y)·(log y)^k·y^(−σ−1) dy`. -/
theorem mellinLog_real (σ : ℝ) (k : ℕ) :
    mellinLog k (σ : ℂ) = (-1) ^ k *
      ((∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1) : ℝ) : ℂ) := by
  rw [mellinLog, ← integral_complex_ofReal, ← integral_const_mul]
  refine setIntegral_congr_fun measurableSet_Ioi (fun y hy => ?_)
  have hy0 : (0 : ℝ) ≤ y := by linarith [mem_Ioi.mp hy]
  have e : ((y ^ (-σ - 1) : ℝ) : ℂ) = (y : ℂ) ^ (-(σ : ℂ) - 1) := by
    rw [Complex.ofReal_cpow hy0]; push_cast; rfl
  simp only [Complex.ofReal_mul, Complex.ofReal_pow, e]
  rw [neg_pow]
  ring

/-- info: 'LandauTaylor.mellinLog_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellinLog_hasDerivAt

/-- info: 'LandauTaylor.iteratedDeriv_Phi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_Phi

/-- info: 'LandauTaylor.mellinLog_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mellinLog_real

end

end LandauTaylor
