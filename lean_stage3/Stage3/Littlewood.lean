/-
Littlewood — block S10 of `lean_stage3/design/stencil.md`, step 4a. 2026-11-24.

Littlewood's lemma on a rectangle, with no branch of arg anywhere. The
argument principle (PNT+ `rectangleIntegral_logDeriv_eq_sum_meromorphicOrderAt`)
is applied on `[σ, b] × [c, d]` for every `σ` whose vertical line misses the
zeros, its imaginary part is integrated over `σ ∈ [a, b]`, and the order of
integration on the left edge's term is swapped by Fubini. Along a horizontal
line the real part of `logDeriv f` is the `x`-derivative of `log ‖f‖`, so the
two vertical terms are integrals of `log ‖f‖`. The singularities of
`logDeriv f` are `n/(s − ρ)` plus a bounded term (PNT+
`logDeriv_sub_principal_isBigO_one_of_meromorphicOrderAt`), and `‖s − ρ‖⁻¹` is
locally integrable on `ℂ` (Mathlib `locallyIntegrable_of_norm_le_rpow`, with
`finrank ℝ ℂ = 2`), which is what Fubini needs.

Rectangle `R = Rectangle z w`, `a = z.re < b = w.re`, `c = z.im < d = w.im`;
`f` analytic at every point of `R` and nonzero on its border; `D` the divisor of
`f` on `R` (`D ρ` is the order of the zero `ρ`); `S` its support, the zeros in
`R`, all in the open rectangle; `L = logDeriv f`;
`edgeH f b y σ = Im ∫_σ^b L(x + iy) dx`; `countRight σ = Σ_{ρ ∈ S, Re ρ > σ} D ρ`.

  mem_support_divisor     U ⊆ R ⊢ ρ ∈ supp (divisor f U) ↔ ρ ∈ U ∧ f ρ = 0
  support_interior        ρ ∈ S ⊢ a < Re ρ < b ∧ c < Im ρ < d
  rectIntegral_eq_count   σ ∈ [a,b], no zero on Re = σ ⊢
                            ∮_{[σ,b]×[c,d]} L = 2πi · countRight σ
  two_pi_count_eq         same ⊢ 2π · countRight σ = edgeH c σ − edgeH d σ
                            + Re ∫_c^d L(b+it) dt − Re ∫_c^d L(σ+it) dt
  integral_countRight     ∫_a^b countRight σ dσ = Σ_{ρ ∈ S} D ρ · (Re ρ − a)
  integrableOn_logDeriv   L is integrable on R (no hypothesis on the zeros)
  integral_re_logDeriv_horizontal
                          no zero on Im = t ⊢ ∫_a^b Re L(x+it) dx
                            = log ‖f(b+it)‖ − log ‖f(a+it)‖
  littlewood_rect         2π · Σ_{ρ ∈ S} D ρ · (Re ρ − a)
                            = ∫_c^d log ‖f(a+it)‖ dt − ∫_c^d log ‖f(b+it)‖ dt
                              + (b − a) · Re ∫_c^d L(b+it) dt
                              + ∫_a^b edgeH c σ dσ − ∫_a^b edgeH d σ dσ
  littlewood_rect_zero_free   no zero in R ⊢ the right side above is 0

The term `(b − a) · Re ∫_c^d L(b+it) dt` is the right edge's share: with a
branch it is the arg of `f` carried up the right edge, which the classical
statement folds into the two horizontal args. Here it stays an integral.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib
import PrimeNumberTheoremAnd.RectangleArgumentPrinciple

namespace Littlewood

open Complex MeasureTheory Set Filter Topology
open scoped Interval

variable {f : ℂ → ℂ}

theorem corner_mem (z w : ℂ) : z ∈ Rectangle z w := by
  rw [Rectangle]
  exact mem_reProdIm.mpr ⟨left_mem_uIcc, left_mem_uIcc⟩

theorem corner_mem_border (z w : ℂ) : z ∈ RectangleBorder z w := by
  rw [RectangleBorder]
  left; left; left
  exact mem_reProdIm.mpr ⟨left_mem_uIcc, rfl⟩

theorem order_ne_top {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hz : f z ≠ 0) : ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤ := by
  intro p hp htop
  rw [(hf p hp).meromorphicOrderAt_eq] at htop
  have h2 : analyticOrderAt f p = ⊤ := by
    cases hn : analyticOrderAt f p
    · rfl
    · rw [hn] at htop; simp [ENat.map_coe] at htop
  have hev := analyticOrderAt_eq_top.mp h2
  have hconv : Convex ℝ (Rectangle z w) := by
    rw [Complex.rectangle_eq_convexHull]; exact convex_convexHull ℝ _
  have hzero := hf.eqOn_zero_of_preconnected_of_eventuallyEq_zero hconv.isPreconnected hp hev
  exact hz (hzero (corner_mem z w))

theorem mem_support_divisor {z w : ℂ} {U : Set ℂ} (hU : U ⊆ Rectangle z w)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hfin : ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤) (p : ℂ) :
    p ∈ (MeromorphicOn.divisor f U).support ↔ p ∈ U ∧ f p = 0 := by
  have hm : MeromorphicOn f U := fun s hs => (hf s (hU hs)).meromorphicAt
  constructor
  · intro hp
    have hpU : p ∈ U := (MeromorphicOn.divisor f U).supportWithinDomain hp
    refine ⟨hpU, ?_⟩
    by_contra hne
    apply hp
    rw [MeromorphicOn.divisor_apply hm hpU, (hf p (hU hpU)).meromorphicOrderAt_eq,
      analyticOrderAt_eq_zero.mpr (Or.inr hne)]
    simp
  · rintro ⟨hpU, hp0⟩ hD
    rw [MeromorphicOn.divisor_apply hm hpU] at hD
    have hne := hfin p (hU hpU)
    have h0 : analyticOrderAt f p ≠ 0 := by
      rw [Ne, analyticOrderAt_eq_zero]
      push Not
      exact ⟨hf p (hU hpU), hp0⟩
    rw [(hf p (hU hpU)).meromorphicOrderAt_eq] at hD hne
    cases hn : analyticOrderAt f p with
    | top => rw [hn] at hne; exact hne rfl
    | coe n =>
      rw [hn] at hD h0
      have hn0 : n ≠ 0 := by exact_mod_cast h0
      simp at hD
      exact hn0 hD

theorem divisor_eq {z w : ℂ} {U : Set ℂ} (hU : U ⊆ Rectangle z w)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w)) {p : ℂ} (hp : p ∈ U) :
    MeromorphicOn.divisor f U p = MeromorphicOn.divisor f (Rectangle z w) p := by
  rw [MeromorphicOn.divisor_apply (fun s hs => (hf s (hU hs)).meromorphicAt) hp,
    MeromorphicOn.divisor_apply (fun s hs => (hf s hs).meromorphicAt) (hU hp)]

/-- A zero of the support lies strictly inside. -/
theorem support_interior {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) {p : ℂ}
    (hp : p ∈ (MeromorphicOn.divisor f (Rectangle z w)).support) :
    z.re < p.re ∧ p.re < w.re ∧ z.im < p.im ∧ p.im < w.im := by
  have hfin := order_ne_top hf (hB z (corner_mem_border z w))
  obtain ⟨hpR, hp0⟩ := (mem_support_divisor subset_rfl hf hfin p).mp hp
  have hpR' := hpR
  rw [Rectangle, uIcc_of_le hre.le, uIcc_of_le him.le] at hpR'
  obtain ⟨⟨h1, h2⟩, ⟨h3, h4⟩⟩ := mem_reProdIm.mp hpR'
  have hnb : p ∉ RectangleBorder z w := fun h => hB p h hp0
  rw [RectangleBorder, uIcc_of_le hre.le, uIcc_of_le him.le] at hnb
  simp only [mem_union, mem_reProdIm, mem_singleton_iff, mem_Icc, not_or, not_and] at hnb
  refine ⟨lt_of_le_of_ne h1 ?_, lt_of_le_of_ne h2 ?_, lt_of_le_of_ne h3 ?_, lt_of_le_of_ne h4 ?_⟩
  · intro h; exact hnb.1.1.2 h.symm h3 h4
  · intro h; exact hnb.2 h h3 h4
  · intro h; exact hnb.1.1.1 ⟨h1, h2⟩ h.symm
  · intro h; exact hnb.1.2 ⟨h1, h2⟩ h


/-- The zeros right of `σ`, with multiplicity. -/
noncomputable
def countRight (f : ℂ → ℂ) (z w : ℂ) (σ : ℝ) : ℝ :=
  ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
    if σ < p.re then ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) else 0

theorem rectIntegral_eq_count {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) {σ : ℝ} (hσ : σ ∈ Icc z.re w.re)
    (hgood : ∀ p ∈ (divisor_support_rectangle_finite f z w).toFinset, p.re ≠ σ) :
    RectangleIntegral (logDeriv f) (↑σ + ↑z.im * I) w
      = 2 * Real.pi * I * (countRight f z w σ : ℂ) := by
  have hzre : ((σ : ℂ) + (z.im : ℂ) * I).re = σ := by simp
  have hzim : ((σ : ℂ) + (z.im : ℂ) * I).im = z.im := by simp
  have hfin := order_ne_top hf (hB z (corner_mem_border z w))
  have hsub : Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w ⊆ Rectangle z w := by
    intro p hp
    rw [Rectangle, hzre, hzim, uIcc_of_le hσ.2] at hp
    rw [Rectangle, uIcc_of_le hre.le]
    obtain ⟨h1, h2⟩ := mem_reProdIm.mp hp
    exact mem_reProdIm.mpr ⟨⟨hσ.1.trans h1.1, h1.2⟩, h2⟩
  have hS := mem_support_divisor subset_rfl hf hfin
  have hSσ := mem_support_divisor hsub hf hfin
  have hmemσ : ∀ p, p ∈ (MeromorphicOn.divisor f (Rectangle z w)).support →
      (p ∈ Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w ↔ σ < p.re) := by
    intro p hp
    obtain ⟨h1, h2, h3, h4⟩ := support_interior hre him hf hB hp
    have hne : p.re ≠ σ := hgood p ((divisor_support_rectangle_finite f z w).mem_toFinset.mpr hp)
    rw [Rectangle, hzre, hzim, uIcc_of_le hσ.2, uIcc_of_le him.le, mem_reProdIm]
    constructor
    · rintro ⟨⟨h5, -⟩, -⟩; exact lt_of_le_of_ne h5 (Ne.symm hne)
    · intro h; exact ⟨⟨h.le, h2.le⟩, ⟨h3.le, h4.le⟩⟩
  have hfσ : MeromorphicOn f (Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w) :=
    fun s hs => (hf s (hsub hs)).meromorphicAt
  have hlogσ : MeromorphicOn (logDeriv f) (Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w) :=
    fun s hs => ((hf.deriv) s (hsub hs)).meromorphicAt.div (hf s (hsub hs)).meromorphicAt
  have hnob : Disjoint (RectangleBorder ((σ : ℂ) + (z.im : ℂ) * I) w)
      (MeromorphicOn.divisor f (Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w)).support := by
    rw [Set.disjoint_right]
    intro p hpS hpB
    obtain ⟨hpR, hp0⟩ := (hSσ p).mp hpS
    have hpS' := (hS p).mpr ⟨hsub hpR, hp0⟩
    obtain ⟨h1, h2, h3, h4⟩ := support_interior hre him hf hB hpS'
    have hlt : σ < p.re := (hmemσ p hpS').mp hpR
    rw [RectangleBorder, hzre, hzim] at hpB
    simp only [mem_union, mem_reProdIm, mem_singleton_iff] at hpB
    rcases hpB with ((h | h) | h) | h
    · linarith [h.2]
    · linarith [h.1]
    · linarith [h.2]
    · linarith [h.1]
  have hmain := rectangleIntegral_logDeriv_eq_sum_meromorphicOrderAt
    (by rw [hzre]; exact hσ.2) (by rw [hzim]; exact him.le) hfσ hlogσ
    (fun p hp => hfin p (hsub hp)) hnob
  have hsets : (divisor_support_rectangle_finite f ((σ : ℂ) + (z.im : ℂ) * I) w).toFinset =
      (divisor_support_rectangle_finite f z w).toFinset.filter (fun p => σ < p.re) := by
    ext p
    rw [Finset.mem_filter, Set.Finite.mem_toFinset, Set.Finite.mem_toFinset]
    constructor
    · intro hp
      obtain ⟨hpR, hp0⟩ := (hSσ p).mp hp
      have hpS' := (hS p).mpr ⟨hsub hpR, hp0⟩
      exact ⟨hpS', (hmemσ p hpS').mp hpR⟩
    · rintro ⟨hp, hlt⟩
      exact (hSσ p).mpr ⟨(hmemσ p hp).mpr hlt, ((hS p).mp hp).2⟩
  have hsum : ∑ p ∈ (divisor_support_rectangle_finite f ((σ : ℂ) + (z.im : ℂ) * I) w).toFinset,
      ((MeromorphicOn.divisor f (Rectangle ((σ : ℂ) + (z.im : ℂ) * I) w) p : ℤ) : ℂ)
        = ((countRight f z w σ : ℝ) : ℂ) := by
    rw [hsets, Finset.sum_filter, countRight, Complex.ofReal_sum]
    refine Finset.sum_congr rfl ?_
    intro p hp
    split_ifs with hlt
    · have hpS := (divisor_support_rectangle_finite f z w).mem_toFinset.mp hp
      rw [divisor_eq hsub hf ((hmemσ p hpS).mpr hlt)]
      push_cast
      rfl
    · simp
  rw [hsum, RectangleIntegral', smul_eq_mul] at hmain
  have h2 : (2 * (Real.pi : ℂ) * I) ≠ 0 := by simp [Real.pi_ne_zero, Complex.I_ne_zero]
  calc RectangleIntegral (logDeriv f) ((σ : ℂ) + (z.im : ℂ) * I) w
      = (2 * Real.pi * I) * (1 / (2 * Real.pi * I) * RectangleIntegral (logDeriv f)
          ((σ : ℂ) + (z.im : ℂ) * I) w) := by
        field_simp
        try ring
    _ = _ := by rw [hmain]

theorem two_pi_count_eq {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) {σ : ℝ} (hσ : σ ∈ Icc z.re w.re)
    (hgood : ∀ p ∈ (divisor_support_rectangle_finite f z w).toFinset, p.re ≠ σ) :
    2 * Real.pi * countRight f z w σ =
      (∫ x in σ..w.re, logDeriv f (↑x + ↑z.im * I)).im
      - (∫ x in σ..w.re, logDeriv f (↑x + ↑w.im * I)).im
      + (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
      - (∫ t in z.im..w.im, logDeriv f (↑σ + ↑t * I)).re := by
  have h := congrArg Complex.im (rectIntegral_eq_count hre him hf hB hσ hgood)
  simp only [RectangleIntegral, HIntegral, VIntegral, smul_eq_mul, Complex.add_re,
    Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.I_im, Complex.ofReal_im,
    mul_zero, sub_zero, mul_one, zero_mul, add_zero, Complex.add_im, Complex.mul_im,
    zero_add, Complex.sub_im, Complex.re_ofNat, one_mul] at h
  linarith


theorem ite_eq_indicator (β m : ℝ) :
    (fun σ : ℝ => if σ < β then m else 0) = (Iio β).indicator (fun _ => m) := by
  ext σ
  simp [Set.indicator, mem_Iio]

theorem intervalIntegrable_ite (β m u v : ℝ) :
    IntervalIntegrable (fun σ : ℝ => if σ < β then m else 0) volume u v := by
  rw [ite_eq_indicator]
  refine (intervalIntegrable_const (c := m)).mono_fun ?_ ?_
  · exact (aestronglyMeasurable_const.indicator measurableSet_Iio)
  · refine Filter.Eventually.of_forall fun σ => ?_
    by_cases h : σ ∈ Iio β
    · simp [Set.indicator_of_mem h]
    · simp [Set.indicator_of_notMem h]

theorem integral_ite_lt {β m u v : ℝ} (hu : u < β) (hv : β < v) :
    ∫ σ in u..v, (if σ < β then m else 0) = m * (β - u) := by
  rw [intervalIntegral.integral_of_le (hu.trans hv).le, ite_eq_indicator,
    integral_indicator measurableSet_Iio, Measure.restrict_restrict measurableSet_Iio]
  have hset : Iio β ∩ Ioc u v = Ioo u β := by
    ext σ
    simp only [mem_inter_iff, mem_Iio, mem_Ioc, mem_Ioo]
    constructor
    · rintro ⟨h1, h2, -⟩; exact ⟨h2, h1⟩
    · rintro ⟨h1, h2⟩; exact ⟨h2, h1, by linarith⟩
  rw [hset, setIntegral_const, smul_eq_mul, measureReal_def, Real.volume_Ioo,
    ENNReal.toReal_ofReal (by linarith)]
  ring

/-- **The σ-integrated count.** -/
theorem integral_countRight {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    ∫ σ in z.re..w.re, countRight f z w σ =
      ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) * (p.re - z.re) := by
  unfold countRight
  rw [intervalIntegral.integral_finsetSum (fun p _ => intervalIntegrable_ite _ _ _ _)]
  refine Finset.sum_congr rfl fun p hp => ?_
  have hpS := (divisor_support_rectangle_finite f z w).mem_toFinset.mp hp
  obtain ⟨h1, h2, -, -⟩ := support_interior hre him hf hB hpS
  exact integral_ite_lt h1 h2


theorem locallyIntegrable_inv_norm_sub (x : ℂ) :
    LocallyIntegrable (fun s : ℂ => ‖s - x‖⁻¹) volume := by
  have h0 : LocallyIntegrable (fun s : ℂ => ‖s‖⁻¹) volume := by
    refine locallyIntegrable_of_norm_le_rpow (C := 1) (α := 1)
      (by simp [Complex.finrank_real_complex]) (by simp [Complex.finrank_real_complex]) ?_ ?_
    · refine Filter.Eventually.of_forall fun s => ?_
      rw [Real.rpow_neg_one, one_mul, Real.norm_eq_abs,
        abs_of_nonneg (inv_nonneg.mpr (norm_nonneg _))]
    · exact (measurable_norm.inv).aestronglyMeasurable
  have hmap : Measure.map (Homeomorph.subRight x) (volume : Measure ℂ) = volume :=
    map_sub_right_eq_self volume x
  have h1 := (locallyIntegrable_map_homeomorph (Homeomorph.subRight x)
    (f := fun s : ℂ => ‖s‖⁻¹) (μ := (volume : Measure ℂ))).mp
  rw [hmap] at h1
  exact h1 h0

theorem integrableAtFilter_logDeriv {p : ℂ} (hp : AnalyticAt ℂ f p)
    (hord : meromorphicOrderAt f p ≠ ⊤) {K : Set ℂ} (hK : IsCompact K) (hKm : MeasurableSet K)
    (hmeas : AEStronglyMeasurable (logDeriv f) (volume.restrict K)) :
    IntegrableAtFilter (logDeriv f) (𝓝[K] p) volume := by
  obtain ⟨n, hn⟩ := WithTop.ne_top_iff_exists.mp hord
  have hO := logDeriv_sub_principal_isBigO_one_of_meromorphicOrderAt hp.meromorphicAt hn.symm
  obtain ⟨C, hC⟩ := hO.bound
  rw [eventually_nhdsWithin_iff] at hC
  obtain ⟨ε, hε, hball⟩ := Metric.mem_nhds_iff.mp hC
  refine ⟨K ∩ Metric.ball p ε, inter_mem_nhdsWithin K (Metric.ball_mem_nhds p hε), ?_⟩
  have hmeasBK : MeasurableSet (K ∩ Metric.ball p ε) := hKm.inter measurableSet_ball
  have hfinK : volume (K ∩ Metric.ball p ε) ≠ ⊤ :=
    (measure_mono inter_subset_left).trans_lt (hK.measure_lt_top) |>.ne
  have hg : IntegrableOn (fun s => C + |(n : ℝ)| * ‖s - p‖⁻¹) (K ∩ Metric.ball p ε) volume := by
    refine (integrableOn_const hfinK).add ?_
    exact (((locallyIntegrable_inv_norm_sub p).integrableOn_isCompact hK).mono_set
      inter_subset_left).const_mul _
  refine Integrable.mono' hg (hmeas.mono_measure (Measure.restrict_mono inter_subset_left le_rfl)) ?_
  have hne : ∀ᵐ s ∂(volume.restrict (K ∩ Metric.ball p ε)), s ∉ ({p} : Set ℂ) :=
    ae_restrict_of_ae ((Set.countable_singleton p).ae_notMem _)
  filter_upwards [hne, ae_restrict_mem hmeasBK] with s hs hsm
  have hb := hball hsm.2 hs
  simp only [Pi.sub_apply, Pi.one_apply, norm_one, mul_one] at hb
  have hsp : s - p ≠ 0 := sub_ne_zero.mpr hs
  calc ‖logDeriv f s‖
      ≤ ‖logDeriv f s - (n : ℂ) / (s - p)‖ + ‖(n : ℂ) / (s - p)‖ := by
        have := norm_add_le (logDeriv f s - (n : ℂ) / (s - p)) ((n : ℂ) / (s - p))
        rwa [sub_add_cancel] at this
    _ ≤ C + |(n : ℝ)| * ‖s - p‖⁻¹ := by
        gcongr
        rw [norm_div, Complex.norm_intCast, div_eq_mul_inv]

theorem integrableOn_logDeriv {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hfin : ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤) :
    IntegrableOn (logDeriv f) (Rectangle z w) volume := by
  have hK : IsCompact (Rectangle z w) := IsCompact.reProdIm isCompact_uIcc isCompact_uIcc
  have hKm : MeasurableSet (Rectangle z w) := hK.isClosed.measurableSet
  have hmeas : AEStronglyMeasurable (logDeriv f) (volume.restrict (Rectangle z w)) := by
    have h1 : AEMeasurable (deriv f) (volume.restrict (Rectangle z w)) :=
      (hf.deriv.continuousOn).aemeasurable hKm
    have h2 : AEMeasurable f (volume.restrict (Rectangle z w)) :=
      hf.continuousOn.aemeasurable hKm
    exact (h1.div h2).aestronglyMeasurable
  exact LocallyIntegrableOn.integrableOn_isCompact
    (fun p hp => integrableAtFilter_logDeriv (hf p hp) (hfin p hp) hK hKm hmeas) hK

theorem integrableOn_logDeriv_prod {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hfin : ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤) :
    IntegrableOn (fun q : ℝ × ℝ => logDeriv f (↑q.1 + ↑q.2 * I))
      ([[z.re, w.re]] ×ˢ [[z.im, w.im]]) volume := by
  have h := integrableOn_logDeriv hf hfin
  have he := MeasurePreserving.symm _ Complex.volume_preserving_equiv_real_prod
  rw [← he.integrableOn_comp_preimage (MeasurableEquiv.measurableEmbedding _)] at h
  have hfun : (logDeriv f ∘ measurableEquivRealProd.symm)
      = fun q : ℝ × ℝ => logDeriv f (↑q.1 + ↑q.2 * I) := by
    funext q
    simp only [Function.comp, Complex.measurableEquivRealProd_symm_apply]
    congr 1
    apply Complex.ext <;> simp
  have hset : measurableEquivRealProd.symm ⁻¹' Rectangle z w
      = [[z.re, w.re]] ×ˢ [[z.im, w.im]] := by
    ext q
    simp only [mem_preimage, Rectangle, mem_reProdIm, mem_prod,
      Complex.measurableEquivRealProd_symm_apply]
  rw [hfun, hset] at h
  exact h


theorem hasDerivAt_log_norm {g : ℝ → ℂ} {g' : ℂ} {x : ℝ} (hg : HasDerivAt g g' x)
    (h0 : g x ≠ 0) : HasDerivAt (fun y => Real.log ‖g y‖) (g' / g x).re x := by
  have hn : ‖g x‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr h0)
  have h2 := (hg.norm_sq.log hn).const_mul (1 / 2)
  have heq : (fun y => Real.log ‖g y‖) = fun y => (1 / 2) * Real.log (‖g y‖ ^ 2) := by
    funext y
    rw [Real.log_pow]
    push_cast
    ring
  rw [heq]
  refine h2.congr_deriv ?_
  have hns : Complex.normSq (g x) ≠ 0 := by rwa [← Complex.sq_norm]
  rw [Complex.inner, Complex.div_re, Complex.mul_re, Complex.conj_re, Complex.conj_im,
    Complex.sq_norm]
  field_simp
  try ring

theorem continuousAt_logDeriv {s : ℂ} (hs : AnalyticAt ℂ f s) (hds : AnalyticAt ℂ (deriv f) s)
    (h0 : f s ≠ 0) : ContinuousAt (logDeriv f) s := by
  show ContinuousAt (fun s => deriv f s / f s) s
  exact hds.continuousAt.div hs.continuousAt h0

theorem continuousOn_logDeriv_comp {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    {γ : ℝ → ℂ} (hγ : Continuous γ) {S : Set ℝ} (hS : ∀ x ∈ S, γ x ∈ Rectangle z w)
    (hnz : ∀ x ∈ S, f (γ x) ≠ 0) : ContinuousOn (fun x => logDeriv f (γ x)) S := by
  intro x hx
  exact ((continuousAt_logDeriv (hf _ (hS x hx)) (hf.deriv _ (hS x hx)) (hnz x hx)).comp
    hγ.continuousAt).continuousWithinAt

theorem continuousOn_log_norm_comp {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    {γ : ℝ → ℂ} (hγ : Continuous γ) {S : Set ℝ} (hS : ∀ x ∈ S, γ x ∈ Rectangle z w)
    (hnz : ∀ x ∈ S, f (γ x) ≠ 0) : ContinuousOn (fun x => Real.log ‖f (γ x)‖) S := by
  intro x hx
  exact ((((hf _ (hS x hx)).continuousAt.comp hγ.continuousAt).norm).log
    (norm_ne_zero_iff.mpr (hnz x hx))).continuousWithinAt

theorem horiz_mem {z w : ℂ} {x t : ℝ} (hx : x ∈ [[z.re, w.re]]) (ht : t ∈ [[z.im, w.im]]) :
    (↑x + ↑t * I : ℂ) ∈ Rectangle z w :=
  mem_reProdIm.mpr ⟨by simpa using hx, by simpa using ht⟩

/-- **The real part along a horizontal line is a difference of `log ‖f‖`.** No branch. -/
theorem integral_re_logDeriv_horizontal {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    {t : ℝ} (ht : t ∈ [[z.im, w.im]]) (hnz : ∀ x ∈ [[z.re, w.re]], f (↑x + ↑t * I) ≠ 0) :
    ∫ x in z.re..w.re, (logDeriv f (↑x + ↑t * I)).re
      = Real.log ‖f (↑w.re + ↑t * I)‖ - Real.log ‖f (↑z.re + ↑t * I)‖ := by
  apply intervalIntegral.integral_eq_sub_of_hasDerivAt (f := fun x : ℝ => Real.log ‖f (↑x + ↑t * I)‖)
  · intro x hx
    have hd : HasDerivAt (fun s : ℂ => f (s + ↑t * I)) (deriv f (↑x + ↑t * I)) (x : ℂ) :=
      ((hf _ (horiz_mem hx ht)).differentiableAt.hasDerivAt).comp_add_const (x : ℂ) (↑t * I)
    have := hasDerivAt_log_norm hd.comp_ofReal (hnz x hx)
    rw [logDeriv_apply]
    exact this
  · apply ContinuousOn.intervalIntegrable
    exact Complex.continuous_re.comp_continuousOn
      (continuousOn_logDeriv_comp hf (by fun_prop) (fun x hx => horiz_mem hx ht) hnz)


theorem bottom_mem_border {z w : ℂ} {x : ℝ} (hx : x ∈ [[z.re, w.re]]) :
    (↑x + ↑z.im * I : ℂ) ∈ RectangleBorder z w := by
  left; left; left
  exact mem_reProdIm.mpr ⟨by simpa using hx, by simp⟩

theorem top_mem_border {z w : ℂ} {x : ℝ} (hx : x ∈ [[z.re, w.re]]) :
    (↑x + ↑w.im * I : ℂ) ∈ RectangleBorder z w := by
  left; right
  exact mem_reProdIm.mpr ⟨by simpa using hx, by simp⟩

theorem left_mem_border {z w : ℂ} {t : ℝ} (ht : t ∈ [[z.im, w.im]]) :
    (↑z.re + ↑t * I : ℂ) ∈ RectangleBorder z w := by
  left; left; right
  exact mem_reProdIm.mpr ⟨by simp, by simpa using ht⟩

theorem right_mem_border {z w : ℂ} {t : ℝ} (ht : t ∈ [[z.im, w.im]]) :
    (↑w.re + ↑t * I : ℂ) ∈ RectangleBorder z w := by
  right
  exact mem_reProdIm.mpr ⟨by simp, by simpa using ht⟩

/-- The horizontal term: the imaginary part of `∫_σ^b logDeriv f (x + iy) dx`. -/
noncomputable
def edgeH (f : ℂ → ℂ) (b y σ : ℝ) : ℝ :=
  (∫ x in σ..b, logDeriv f (↑x + ↑y * I)).im

theorem littlewood_rect {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    2 * Real.pi * ∑ ρ ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) ρ : ℤ) : ℝ) * (ρ.re - z.re)
      = (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) := by
  classical
  have hfin := order_ne_top hf (hB z (corner_mem_border z w))
  have hS := mem_support_divisor subset_rfl hf hfin
  have hzeroS : ∀ p ∈ Rectangle z w, f p = 0 →
      p ∈ (divisor_support_rectangle_finite f z w).toFinset := fun p hp h0 =>
    (divisor_support_rectangle_finite f z w).mem_toFinset.mpr ((hS p).mpr ⟨hp, h0⟩)
  have hrect := integrableOn_logDeriv_prod hf hfin
  have hint2 : Integrable (Function.uncurry fun (σ t : ℝ) => (logDeriv f (↑σ + ↑t * I)).re)
      ((volume.restrict (Ioc z.re w.re)).prod (volume.restrict (Ioc z.im w.im))) := by
    rw [Measure.prod_restrict, ← Measure.volume_eq_prod]
    have hsub : Ioc z.re w.re ×ˢ Ioc z.im w.im ⊆ [[z.re, w.re]] ×ˢ [[z.im, w.im]] := by
      rw [uIcc_of_le hre.le, uIcc_of_le him.le]
      exact prod_mono Ioc_subset_Icc_self Ioc_subset_Icc_self
    exact (hrect.mono_set hsub).re
  -- Fubini
  have hswap : ∫ σ in z.re..w.re, (∫ t in z.im..w.im, (logDeriv f (↑σ + ↑t * I)).re)
      = ∫ t in z.im..w.im, (∫ σ in z.re..w.re, (logDeriv f (↑σ + ↑t * I)).re) := by
    simp only [intervalIntegral.integral_of_le hre.le, intervalIntegral.integral_of_le him.le]
    exact integral_integral_swap hint2
  have hWint : IntervalIntegrable
      (fun σ : ℝ => ∫ t in z.im..w.im, (logDeriv f (↑σ + ↑t * I)).re) volume z.re w.re := by
    rw [intervalIntegrable_iff_integrableOn_Ioc_of_le hre.le]
    simp only [intervalIntegral.integral_of_le him.le]
    exact hint2.integral_prod_left
  -- each horizontal line that misses the zeros
  have hinner : ∀ᵐ t ∂volume, t ∈ Ι z.im w.im →
      (∫ σ in z.re..w.re, (logDeriv f (↑σ + ↑t * I)).re)
        = Real.log ‖f (↑w.re + ↑t * I)‖ - Real.log ‖f (↑z.re + ↑t * I)‖ := by
    have hc : ((divisor_support_rectangle_finite f z w).toFinset.image Complex.im :
        Set ℝ).Countable := Finset.countable_toSet _
    filter_upwards [hc.ae_notMem volume] with t ht htI
    have htI' : t ∈ [[z.im, w.im]] := uIoc_subset_uIcc htI
    refine integral_re_logDeriv_horizontal hf htI' ?_
    intro x hx h0
    apply ht
    have := hzeroS _ (horiz_mem hx htI') h0
    exact Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨_, this, by simp⟩)
  -- each vertical line that misses the zeros
  have hvert : ∀ σ ∈ [[z.re, w.re]],
      σ ∉ ((divisor_support_rectangle_finite f z w).toFinset.image Complex.re : Set ℝ) →
      (∫ t in z.im..w.im, logDeriv f (↑σ + ↑t * I)).re
        = ∫ t in z.im..w.im, (logDeriv f (↑σ + ↑t * I)).re := by
    intro σ hσ hσS
    have hcont : ContinuousOn (fun t : ℝ => logDeriv f (↑σ + ↑t * I)) [[z.im, w.im]] :=
      continuousOn_logDeriv_comp hf (by fun_prop) (fun t ht => horiz_mem hσ ht)
        (fun t ht h0 => hσS (by
          have := hzeroS _ (horiz_mem hσ ht) h0
          exact Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨_, this, by simp⟩)))
    have := Complex.reCLM.intervalIntegral_comp_comm (hcont.intervalIntegrable (μ := volume))
    simp only [Complex.reCLM_apply] at this
    exact this.symm
  -- the argument principle at almost every σ
  have hcount : ∀ᵐ σ ∂volume, σ ∈ Ι z.re w.re →
      2 * Real.pi * countRight f z w σ =
        edgeH f w.re z.im σ - edgeH f w.re w.im σ
        + (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        - ∫ t in z.im..w.im, (logDeriv f (↑σ + ↑t * I)).re := by
    have hc : ((divisor_support_rectangle_finite f z w).toFinset.image Complex.re :
        Set ℝ).Countable := Finset.countable_toSet _
    filter_upwards [hc.ae_notMem volume] with σ hσS hσI
    have hσ : σ ∈ Icc z.re w.re := by
      rw [uIoc_of_le hre.le] at hσI
      exact Ioc_subset_Icc_self hσI
    have hgood : ∀ p ∈ (divisor_support_rectangle_finite f z w).toFinset, p.re ≠ σ := by
      intro p hp hpσ
      exact hσS (Finset.mem_coe.mpr (Finset.mem_image.mpr ⟨p, hp, hpσ⟩))
    rw [two_pi_count_eq hre him hf hB hσ hgood,
      ← hvert σ (by rw [uIcc_of_le hre.le]; exact hσ) hσS]
    simp only [edgeH]
  have hHint : ∀ y ∈ ({z.im, w.im} : Set ℝ),
      IntervalIntegrable (fun σ => edgeH f w.re y σ) volume z.re w.re := by
    intro y hy
    have hyI : y ∈ [[z.im, w.im]] := by
      rcases hy with rfl | rfl
      · exact left_mem_uIcc
      · exact right_mem_uIcc
    apply ContinuousOn.intervalIntegrable
    have hcont : ContinuousOn (fun x : ℝ => logDeriv f (↑x + ↑y * I)) [[z.re, w.re]] := by
      refine continuousOn_logDeriv_comp hf (by fun_prop) (fun x hx => horiz_mem hx hyI) ?_
      intro x hx
      rcases hy with rfl | rfl
      · exact hB _ (bottom_mem_border hx)
      · exact hB _ (top_mem_border hx)
    have hprim := intervalIntegral.continuousOn_primitive_interval_left
      (hcont.integrableOn_compact (μ := volume) isCompact_uIcc)
    exact Complex.continuous_im.comp_continuousOn hprim
  have hlogInt : ∀ x ∈ ({z.re, w.re} : Set ℝ),
      IntervalIntegrable (fun t : ℝ => Real.log ‖f (↑x + ↑t * I)‖) volume z.im w.im := by
    intro x hx
    have hxI : x ∈ [[z.re, w.re]] := by
      rcases hx with rfl | rfl
      · exact left_mem_uIcc
      · exact right_mem_uIcc
    apply ContinuousOn.intervalIntegrable
    refine continuousOn_log_norm_comp hf (by fun_prop) (fun t ht => horiz_mem hxI ht) ?_
    intro t ht
    rcases hx with rfl | rfl
    · exact hB _ (left_mem_border ht)
    · exact hB _ (right_mem_border ht)
  have hHc := hHint z.im (by simp)
  have hHd := hHint w.im (by simp)
  rw [← integral_countRight hre him hf hB, ← intervalIntegral.integral_const_mul,
    intervalIntegral.integral_congr_ae hcount,
    intervalIntegral.integral_sub ((hHc.sub hHd).add intervalIntegrable_const) hWint,
    intervalIntegral.integral_add (hHc.sub hHd) intervalIntegrable_const,
    intervalIntegral.integral_sub hHc hHd, intervalIntegral.integral_const, smul_eq_mul,
    hswap, intervalIntegral.integral_congr_ae hinner,
    intervalIntegral.integral_sub (hlogInt w.re (by simp)) (hlogInt z.re (by simp))]
  ring

/-- **The zero-free case.** With no zero in the closed rectangle the right
side of Littlewood's identity vanishes. -/
theorem littlewood_rect_zero_free {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hnz : ∀ p ∈ Rectangle z w, f p ≠ 0) :
    (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) = 0 := by
  have hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0 :=
    fun p hp => hnz p (rectangleBorder_subset_rectangle z w hp)
  have h := littlewood_rect hre him hf hB
  have hfin := order_ne_top hf (hnz z (corner_mem z w))
  have hzero : ∑ ρ ∈ (divisor_support_rectangle_finite f z w).toFinset,
      ((MeromorphicOn.divisor f (Rectangle z w) ρ : ℤ) : ℝ) * (ρ.re - z.re) = 0 := by
    refine Finset.sum_eq_zero fun p hp => ?_
    have hp' := (mem_support_divisor subset_rfl hf hfin p).mp
      ((divisor_support_rectangle_finite f z w).mem_toFinset.mp hp)
    exact absurd hp'.2 (hnz p hp'.1)
  rw [hzero, mul_zero] at h
  linarith

/-- info: 'Littlewood.mem_support_divisor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mem_support_divisor

/-- info: 'Littlewood.support_interior' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms support_interior

/-- info: 'Littlewood.rectIntegral_eq_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rectIntegral_eq_count

/-- info: 'Littlewood.two_pi_count_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms two_pi_count_eq

/-- info: 'Littlewood.integral_countRight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_countRight

/-- info: 'Littlewood.integrableOn_logDeriv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integrableOn_logDeriv

/-- info: 'Littlewood.integral_re_logDeriv_horizontal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms integral_re_logDeriv_horizontal

/-- info: 'Littlewood.littlewood_rect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_rect

/-- info: 'Littlewood.littlewood_rect_zero_free' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_rect_zero_free

end Littlewood
