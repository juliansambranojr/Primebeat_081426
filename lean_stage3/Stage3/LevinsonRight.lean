/-
LevinsonRight — block S11 of `lean_stage3/design/stencil.md`, steps 2–4. 2026-11-24.

Littlewood on the left of the line, the concavity of the logarithm, and the passage
from `G` to a product `G · M`. On the rectangle with corners `z`, `w`, with `f`
analytic there and nonzero on its border, `Littlewood.littlewood_rect` reads
`2π · Σ_ρ D ρ · (Re ρ − Re z) = RHS f z w`. Every zero in the support has `D ρ > 0`
and `Re ρ > Re z` (`Littlewood.support_interior`), so dropping the zeros with
`Re ρ ≤ σ₁` and bounding `Re ρ − Re z ≥ σ₁ − Re z` for the rest bounds the count right
of `σ₁` (step 2). The left edge's `∫ log ‖f‖` is at most `((b − a)/2) · log` of the mean
of `‖f‖²`, by the tangent line `log x ≤ x/m − 1 + log m` at the mean `m` (step 4; the
same inequality as Jensen's for the concave logarithm, with no closed-domain side
condition). The zeros of `G` are zeros of `G · M` with at least their order, since the
divisor of a product is the sum of the divisors and both are nonnegative (step 3, the
mollifier's half). The count on the rectangle with left side `1/2` equals the count on
the wider rectangle with left side `σ₀ ≤ 1/2` right of `1/2`: they count the same zeros.

`RHS f z w` is the right side of `littlewood_rect`:
  (∫_c^d log ‖f(a+it)‖ dt) − (∫_c^d log ‖f(b+it)‖ dt) + (b − a) · Re ∫_c^d L(b+it) dt
    + ∫_a^b edgeH f b c σ dσ − ∫_a^b edgeH f b d σ dσ,
with `a = Re z`, `b = Re w`, `c = Im z`, `d = Im w`, `L = logDeriv f`.

  zeros_right_le          Re z < Re w, Im z < Im w, f analytic on R, f ≠ 0 on ∂R,
                            any real σ₁ (the bound has content for σ₁ > Re z)
                            ⊢ 2π · (σ₁ − Re z) · countRight f z w σ₁ ≤ RHS f z w
  log_integral_le         a < b, g and log ∘ g interval integrable, g > 0 on [a, b]
                            ⊢ ∫_a^b log g ≤ (b − a) · log ((1/(b − a)) · ∫_a^b g)
  log_integral_norm_le    a < b, t ↦ F(σ₀+it) continuous and nonzero on [a, b]
                            ⊢ ∫_a^b log ‖F(σ₀+it)‖ dt
                                ≤ ((b − a)/2) · log ((1/(b − a)) · ∫_a^b ‖F(σ₀+it)‖² dt)
  countRight_mul_ge       G, M analytic on R, G · M ≠ 0 on ∂R
                            ⊢ countRight G z w σ ≤ countRight (G · M) z w σ
  countRight_left_eq      Re z ≤ Re z' ≤ σ, Re z' ≤ Re w, Im z' = Im z,
                            f analytic on R(z, w), f z ≠ 0
                            ⊢ countRight f z' w σ = countRight f z w σ
  levinson_right          σ₀ < 1/2 ≤ X, a < b, G, M analytic on R(σ₀ + a i, X + b i),
                            G · M ≠ 0 on its border
                            ⊢ countRight G (1/2 + a i) (X + b i) (1/2)
                                ≤ (1/(2π(1/2 − σ₀))) ·
                                  ( ((b − a)/2) · log ((1/(b − a)) ∫_a^b ‖GM(σ₀+it)‖² dt)
                                    − ∫_a^b log ‖GM(X+it)‖ dt
                                    + (X − σ₀) · Re ∫_a^b logDeriv (GM)(X+it) dt
                                    + ∫_{σ₀}^X edgeH (GM) X a σ dσ − ∫_{σ₀}^X edgeH (GM) X b σ dσ )

The count on the left of `levinson_right` is the one `LevinsonCount.levinson_count`
subtracts, at `X = 3`. The edge terms of Littlewood for `G · M` stay explicit integrals.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonCount
import Stage3.Littlewood

namespace LevinsonRight

open Complex MeasureTheory Set Littlewood
open scoped Interval

/-- The divisor of an analytic function, read in `ℝ`, is nonnegative. -/
theorem divisor_nonneg_real {f : ℂ → ℂ} {U : Set ℂ} (hf : AnalyticOnNhd ℂ f U) (p : ℂ) :
    (0 : ℝ) ≤ ((MeromorphicOn.divisor f U p : ℤ) : ℝ) := by
  have h := MeromorphicOn.AnalyticOnNhd.divisor_nonneg hf p
  have h' : (0 : ℤ) ≤ MeromorphicOn.divisor f U p := by simpa using h
  exact_mod_cast h'

/-- **Step 2.** Littlewood bounds the count right of `σ₁`. -/
theorem zeros_right_le {f : ℂ → ℂ} {z w : ℂ} {σ₁ : ℝ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    2 * Real.pi * (σ₁ - z.re) * countRight f z w σ₁
      ≤ (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) := by
  rw [← littlewood_rect hre him hf hB]
  unfold countRight
  rw [mul_assoc]
  apply mul_le_mul_of_nonneg_left _ (by positivity)
  rw [Finset.mul_sum]
  refine Finset.sum_le_sum fun p hp => ?_
  have hpS := (divisor_support_rectangle_finite f z w).mem_toFinset.mp hp
  obtain ⟨h1, -, -, -⟩ := support_interior hre him hf hB hpS
  have hD := divisor_nonneg_real hf p
  split_ifs with h
  · have hle : σ₁ - z.re ≤ p.re - z.re := by linarith
    have := mul_le_mul_of_nonneg_left hle hD
    linarith
  · rw [mul_zero]
    exact mul_nonneg hD (by linarith)

/-- **Step 4, the concavity.** The integral of `log g` is at most the length times the log of
the mean, by the tangent line of `log` at the mean. -/
theorem log_integral_le {g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hg : IntervalIntegrable g volume a b)
    (hlog : IntervalIntegrable (fun t => Real.log (g t)) volume a b)
    (hpos : ∀ t ∈ Icc a b, 0 < g t) :
    ∫ t in a..b, Real.log (g t) ≤ (b - a) * Real.log ((1 / (b - a)) * ∫ t in a..b, g t) := by
  have hba : 0 < b - a := by linarith
  have hI : 0 < ∫ t in a..b, g t :=
    intervalIntegral.intervalIntegral_pos_of_pos_on hg
      (fun t ht => hpos t (Ioo_subset_Icc_self ht)) hab
  set I := ∫ t in a..b, g t with hIdef
  set m := (1 / (b - a)) * I with hm
  have hm0 : 0 < m := by rw [hm]; positivity
  have hpt : ∀ t ∈ Icc a b, Real.log (g t) ≤ g t / m + (Real.log m - 1) := by
    intro t ht
    have h1 := Real.log_le_sub_one_of_pos (div_pos (hpos t ht) hm0)
    rw [Real.log_div (hpos t ht).ne' hm0.ne'] at h1
    linarith
  have hR : IntervalIntegrable (fun t => g t / m + (Real.log m - 1)) volume a b :=
    (hg.div_const m).add intervalIntegrable_const
  have hmono := intervalIntegral.integral_mono_on hab.le hlog hR hpt
  rw [intervalIntegral.integral_add (hg.div_const m) intervalIntegrable_const,
    intervalIntegral.integral_div, intervalIntegral.integral_const, smul_eq_mul] at hmono
  have hIm : I / m = b - a := by
    rw [hm]
    field_simp
    try ring
  rw [hIm] at hmono
  linarith

/-- **Step 4, the form used.** `∫ log ‖F‖ = (1/2) ∫ log ‖F‖²`. -/
theorem log_integral_norm_le {F : ℂ → ℂ} {σ₀ a b : ℝ} (hab : a < b)
    (hc : ContinuousOn (fun t : ℝ => F (↑σ₀ + ↑t * I)) (Icc a b))
    (hnz : ∀ t ∈ Icc a b, F (↑σ₀ + ↑t * I) ≠ 0) :
    ∫ t in a..b, Real.log ‖F (↑σ₀ + ↑t * I)‖
      ≤ (b - a) / 2 * Real.log ((1 / (b - a)) * ∫ t in a..b, ‖F (↑σ₀ + ↑t * I)‖ ^ 2) := by
  have hsq : ∀ t, Real.log ‖F (↑σ₀ + ↑t * I)‖
      = (1 / 2) * Real.log (‖F (↑σ₀ + ↑t * I)‖ ^ 2) := by
    intro t
    rw [Real.log_pow]
    push_cast
    ring
  have heq : ∫ t in a..b, Real.log ‖F (↑σ₀ + ↑t * I)‖
      = (1 / 2) * ∫ t in a..b, Real.log (‖F (↑σ₀ + ↑t * I)‖ ^ 2) := by
    rw [← intervalIntegral.integral_const_mul]
    exact intervalIntegral.integral_congr fun t _ => hsq t
  have hc2 : ContinuousOn (fun t : ℝ => ‖F (↑σ₀ + ↑t * I)‖ ^ 2) (Icc a b) :=
    hc.norm.pow 2
  have hpos : ∀ t ∈ Icc a b, 0 < ‖F (↑σ₀ + ↑t * I)‖ ^ 2 :=
    fun t ht => pow_pos (norm_pos_iff.mpr (hnz t ht)) 2
  have hclog : ContinuousOn (fun t : ℝ => Real.log (‖F (↑σ₀ + ↑t * I)‖ ^ 2)) (Icc a b) :=
    hc2.log fun t ht => (hpos t ht).ne'
  have hint : ∀ {h : ℝ → ℝ}, ContinuousOn h (Icc a b) → IntervalIntegrable h volume a b := by
    intro h hh
    apply ContinuousOn.intervalIntegrable
    rwa [uIcc_of_le hab.le]
  have hmain := log_integral_le hab (hint hc2) (hint hclog) hpos
  rw [heq]
  have h2 : (b - a) / 2 = (1 / 2) * (b - a) := by ring
  rw [h2, mul_assoc]
  exact mul_le_mul_of_nonneg_left hmain (by norm_num)

/-- **Step 3.** The zeros of `G` are zeros of `G · M`, with at least their order. -/
theorem countRight_mul_ge {G M : ℂ → ℂ} {z w : ℂ} (σ : ℝ)
    (hG : AnalyticOnNhd ℂ G (Rectangle z w)) (hM : AnalyticOnNhd ℂ M (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, G p * M p ≠ 0) :
    countRight G z w σ ≤ countRight (fun s => G s * M s) z w σ := by
  classical
  have hz := hB z (corner_mem_border z w)
  have hfinG := order_ne_top hG (left_ne_zero_of_mul hz)
  have hfinM := order_ne_top hM (right_ne_zero_of_mul hz)
  have hGM : AnalyticOnNhd ℂ (fun s => G s * M s) (Rectangle z w) :=
    fun p hp => (hG p hp).mul (hM p hp)
  have hfinGM := order_ne_top hGM hz
  have hdiv := MeromorphicOn.divisor_fun_mul hG.meromorphicOn hM.meromorphicOn hfinG hfinM
  have hsub : (divisor_support_rectangle_finite G z w).toFinset
      ⊆ (divisor_support_rectangle_finite (fun s => G s * M s) z w).toFinset := by
    intro p hp
    rw [Set.Finite.mem_toFinset] at hp ⊢
    obtain ⟨hpR, hp0⟩ := (mem_support_divisor subset_rfl hG hfinG p).mp hp
    exact (mem_support_divisor subset_rfl hGM hfinGM p).mpr ⟨hpR, by simp [hp0]⟩
  unfold countRight
  calc ∑ p ∈ (divisor_support_rectangle_finite G z w).toFinset,
        (if σ < p.re then ((MeromorphicOn.divisor G (Rectangle z w) p : ℤ) : ℝ) else 0)
      ≤ ∑ p ∈ (divisor_support_rectangle_finite G z w).toFinset,
        (if σ < p.re then
          ((MeromorphicOn.divisor (fun s => G s * M s) (Rectangle z w) p : ℤ) : ℝ) else 0) := by
        refine Finset.sum_le_sum fun p _ => ?_
        split_ifs
        · rw [hdiv]
          have hM0 := divisor_nonneg_real hM p
          simp only [Function.locallyFinsuppWithin.coe_add, Pi.add_apply, Int.cast_add]
          linarith
        · exact le_refl _
    _ ≤ ∑ p ∈ (divisor_support_rectangle_finite (fun s => G s * M s) z w).toFinset,
        (if σ < p.re then
          ((MeromorphicOn.divisor (fun s => G s * M s) (Rectangle z w) p : ℤ) : ℝ) else 0) := by
        refine Finset.sum_le_sum_of_subset_of_nonneg hsub fun p _ _ => ?_
        split_ifs
        · exact divisor_nonneg_real hGM p
        · exact le_refl _

/-- The count right of `σ` does not see the left side of the rectangle, as long as that
side stays left of `σ`. -/
theorem countRight_left_eq {f : ℂ → ℂ} {z z' w : ℂ} {σ : ℝ}
    (hzz : z.re ≤ z'.re) (hzσ : z'.re ≤ σ) (hzw : z'.re ≤ w.re) (him : z'.im = z.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w)) (hz : f z ≠ 0) :
    countRight f z' w σ = countRight f z w σ := by
  classical
  have hfin := order_ne_top hf hz
  have hsubR : Rectangle z' w ⊆ Rectangle z w := by
    intro p hp
    rw [Rectangle] at hp ⊢
    obtain ⟨h1, h2⟩ := mem_reProdIm.mp hp
    refine mem_reProdIm.mpr ⟨?_, ?_⟩
    · refine uIcc_subset_uIcc ?_ right_mem_uIcc h1
      exact mem_uIcc.mpr (Or.inl ⟨hzz, hzw⟩)
    · rwa [him] at h2
  have hsub : (divisor_support_rectangle_finite f z' w).toFinset
      ⊆ (divisor_support_rectangle_finite f z w).toFinset := by
    intro p hp
    rw [Set.Finite.mem_toFinset] at hp ⊢
    obtain ⟨hpR, hp0⟩ := (mem_support_divisor hsubR hf hfin p).mp hp
    exact (mem_support_divisor subset_rfl hf hfin p).mpr ⟨hsubR hpR, hp0⟩
  unfold countRight
  rw [← Finset.sum_subset hsub ?_]
  · refine Finset.sum_congr rfl fun p hp => ?_
    have hpS := (divisor_support_rectangle_finite f z' w).mem_toFinset.mp hp
    have hpR := ((mem_support_divisor hsubR hf hfin p).mp hpS).1
    rw [divisor_eq hsubR hf hpR]
  · intro p hp hpn
    split_ifs with h
    · exfalso
      apply hpn
      have hpS := (divisor_support_rectangle_finite f z w).mem_toFinset.mp hp
      obtain ⟨hpR, hp0⟩ := (mem_support_divisor subset_rfl hf hfin p).mp hpS
      rw [Set.Finite.mem_toFinset]
      refine (mem_support_divisor hsubR hf hfin p).mpr ⟨?_, hp0⟩
      have hpR' := hpR
      rw [Rectangle] at hpR' ⊢
      obtain ⟨h1, h2⟩ := mem_reProdIm.mp hpR'
      refine mem_reProdIm.mpr ⟨?_, by rwa [him]⟩
      rcases mem_uIcc.mp h1 with ⟨_, h4⟩ | ⟨_, h4⟩
      · exact mem_uIcc.mpr (Or.inl ⟨by linarith, h4⟩)
      · exfalso; linarith
    · rfl

/-- **Steps 2–4 combined.** Levinson's count of the zeros of `G` right of the line, through
`G · M`, Littlewood on `[σ₀, X] × [a, b]`, and the concavity of the logarithm. -/
theorem levinson_right {G M : ℂ → ℂ} {σ₀ X a b : ℝ} (hσ₀ : σ₀ < 1 / 2) (hX : 1 / 2 ≤ X)
    (hab : a < b)
    (hG : AnalyticOnNhd ℂ G (Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hM : AnalyticOnNhd ℂ M (Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hB : ∀ p ∈ RectangleBorder ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I), G p * M p ≠ 0) :
    countRight G ((1 / 2 : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2)
      ≤ (1 / (2 * Real.pi * (1 / 2 - σ₀))) *
        ((b - a) / 2 * Real.log ((1 / (b - a)) *
            ∫ t in a..b, ‖G (↑σ₀ + ↑t * I) * M (↑σ₀ + ↑t * I)‖ ^ 2)
          - (∫ t in a..b, Real.log ‖G (↑X + ↑t * I) * M (↑X + ↑t * I)‖)
          + (X - σ₀) * (∫ t in a..b, logDeriv (fun s => G s * M s) (↑X + ↑t * I)).re
          + (∫ σ in σ₀..X, edgeH (fun s => G s * M s) X a σ)
          - (∫ σ in σ₀..X, edgeH (fun s => G s * M s) X b σ)) := by
  have hzre : ((σ₀ : ℂ) + a * I).re = σ₀ := by simp
  have hzim : ((σ₀ : ℂ) + a * I).im = a := by simp
  have hwre : ((X : ℂ) + b * I).re = X := by simp
  have hwim : ((X : ℂ) + b * I).im = b := by simp
  have hhre : ((1 / 2 : ℂ) + a * I).re = 1 / 2 := by simp
  have hhim : ((1 / 2 : ℂ) + a * I).im = a := by simp
  have hre : ((σ₀ : ℂ) + a * I).re < ((X : ℂ) + b * I).re := by
    rw [hzre, hwre]; linarith
  have him : ((σ₀ : ℂ) + a * I).im < ((X : ℂ) + b * I).im := by
    rw [hzim, hwim]; exact hab
  have hGM : AnalyticOnNhd ℂ (fun s => G s * M s) (Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I)) :=
    fun p hp => (hG p hp).mul (hM p hp)
  have hz := hB _ (corner_mem_border _ _)
  -- the left side moves from `1/2` to `σ₀`
  have h1 : countRight G ((1 / 2 : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2)
      = countRight G ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2) :=
    countRight_left_eq (by rw [hzre, hhre]; linarith) (by rw [hhre]) (by rw [hhre, hwre]; exact hX)
      (by rw [hhim, hzim]) hG (left_ne_zero_of_mul hz)
  -- from `G` to `G · M`
  have h2 := countRight_mul_ge (1 / 2) hG hM hB
  -- Littlewood at `σ₁ = 1/2`
  have h3 := zeros_right_le (σ₁ := 1 / 2) hre him hGM hB
  rw [hzre, hzim, hwre, hwim] at h3
  -- the concavity on the left edge
  have hcL : ContinuousOn (fun t : ℝ => G (↑σ₀ + ↑t * I) * M (↑σ₀ + ↑t * I)) (Icc a b) := by
    intro t ht
    have hmem : (↑σ₀ + ↑t * I : ℂ) ∈ Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I) := by
      apply rectangleBorder_subset_rectangle
      have := left_mem_border (z := (σ₀ : ℂ) + a * I) (w := (X : ℂ) + b * I) (t := t)
        (by rw [hzim, hwim, uIcc_of_le hab.le]; exact ht)
      rwa [hzre] at this
    exact (ContinuousAt.comp (g := fun s => G s * M s) (f := fun t : ℝ => (↑σ₀ + ↑t * I : ℂ))
      (hGM _ hmem).continuousAt (by fun_prop)).continuousWithinAt
  have hnzL : ∀ t ∈ Icc a b, G (↑σ₀ + ↑t * I) * M (↑σ₀ + ↑t * I) ≠ 0 := by
    intro t ht
    have := left_mem_border (z := (σ₀ : ℂ) + a * I) (w := (X : ℂ) + b * I) (t := t)
      (by rw [hzim, hwim, uIcc_of_le hab.le]; exact ht)
    rw [hzre] at this
    exact hB _ this
  have h4 := log_integral_norm_le (F := fun s => G s * M s) hab hcL hnzL
  have hc : 0 < 2 * Real.pi * (1 / 2 - σ₀) := by
    have := Real.pi_pos
    have : 0 < 1 / 2 - σ₀ := by linarith
    positivity
  rw [h1, one_div_mul_eq_div, le_div_iff₀ hc]
  have e : countRight G ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2) * (2 * Real.pi * (1 / 2 - σ₀))
      ≤ 2 * Real.pi * (1 / 2 - σ₀)
        * countRight (fun s => G s * M s) ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2) := by
    rw [mul_comm]
    exact mul_le_mul_of_nonneg_left h2 hc.le
  linarith

/-- info: 'LevinsonRight.zeros_right_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeros_right_le

/-- info: 'LevinsonRight.log_integral_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_integral_le

/-- info: 'LevinsonRight.log_integral_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_integral_norm_le

/-- info: 'LevinsonRight.countRight_mul_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms countRight_mul_ge

/-- info: 'LevinsonRight.countRight_left_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms countRight_left_eq

/-- info: 'LevinsonRight.levinson_right' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_right

end LevinsonRight
