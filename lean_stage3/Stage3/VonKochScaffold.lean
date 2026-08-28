/-
# Von Koch converse — SCAFFOLD (roadmap B1)

    (∃ C x₀, ∀ t ≥ x₀, |ψ t − t| ≤ C·√t·(log t)³)  →  RiemannHypothesis

SCRATCH: this file carries named `sorry`s by design. It is the slice map for
B1, compiling so the obligations are real Lean statements rather than prose.
Each sorry is one slice. Do not count this module in any sorry-free claim.

Route (all ingredients verified present 2026-08-28):
  V1  E-integral analytic on re s > 1/2      mellin_differentiableAt_of_isBigO_rpow
  V2  −ζ'/ζ = s/(s−1) + s·∫E  on re s > 1    AbelSummation + LSeries_vonMangoldt
  V3  agreement extends to re > 1/2 off zeros    eqOn_of_preconnected +
                                             Countable.isPathConnected_compl
  V4  ζ'/ζ blows up at a zero, F does not    Meromorphic/Order library
  V5  no zeros re > 1/2 → RH                 riemannZeta_one_sub + conj
-/
import Stage3.LineBound

namespace VonKoch

open Complex Set MeasureTheory

local notation "ψ" => ChebyshevPsi

/-- The error function. -/
noncomputable def E (x : ℝ) : ℝ := ψ x - x

/-- The completed right-hand object: `s/(s−1) + s·∫₁^∞ E(x)·x^(−s−1) dx`. -/
noncomputable def F (s : ℂ) : ℂ :=
  s / (s - 1) + s * ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1)

/-- The truncated error, as a function on `(0,∞)`: `E` on `(1,∞)`, zero below. -/
noncomputable def Etr : ℝ → ℂ := Set.indicator (Set.Ioi 1) (fun t : ℝ ↦ ((E t : ℝ) : ℂ))

theorem measurable_psi' : Measurable (fun t : ℝ ↦ ψ t) := by
  have : (fun t : ℝ ↦ ψ t)
      = (fun n : ℕ ↦ ∑ k ∈ Finset.Ioc 0 n, ArithmeticFunction.vonMangoldt k)
        ∘ (fun t : ℝ ↦ ⌊t⌋₊) := rfl
  rw [this]
  exact Measurable.comp (.of_discrete) Nat.measurable_floor

theorem Etr_measurable : Measurable Etr :=
  ((Complex.measurable_ofReal.comp
    (measurable_psi'.sub measurable_id)).indicator measurableSet_Ioi)

/-- Crude bound, no hypothesis: `|E t| ≤ (log 4 + 5)·t` for `t ≥ 0`. -/
theorem E_le_linear {t : ℝ} (ht : 0 ≤ t) : ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t := by
  have h1 := Chebyshev.psi_le_const_mul_self ht
  have h2 : (0:ℝ) ≤ ψ t := Chebyshev.psi_nonneg t
  rw [E, Real.norm_eq_abs, abs_le]
  constructor <;> nlinarith [Real.log_nonneg (by norm_num : (1:ℝ) ≤ 4)]

/-- The E-integral IS the Mellin transform of `Etr` at `-s` — as raw integrals,
no convergence needed. -/
theorem E_integral_eq_mellin (s : ℂ) :
    ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) := by
  rw [mellin]
  rw [show ∀ f : ℝ → ℂ, ∫ t in Set.Ioi (0:ℝ), f t = ∫ t in Set.Ioi (0:ℝ), f t from fun _ ↦ rfl]
  have h : ∀ t : ℝ, (t : ℂ) ^ (-s - 1) • Etr t
      = Set.indicator (Set.Ioi 1) (fun x : ℝ ↦ (E x : ℂ) * (x : ℂ) ^ (-s - 1)) t := by
    intro t
    by_cases ht : t ∈ Set.Ioi (1:ℝ)
    · simp [Etr, Set.indicator_of_mem ht, smul_eq_mul]; ring
    · simp [Etr, Set.indicator_of_notMem ht]
  simp_rw [h]
  rw [MeasureTheory.integral_indicator measurableSet_Ioi,
    Measure.restrict_restrict measurableSet_Ioi]
  have hset : Set.Ioi (1:ℝ) ∩ Set.Ioi (0:ℝ) = Set.Ioi (1:ℝ) := by
    apply Set.inter_eq_left.mpr
    intro t ht
    exact Set.mem_Ioi.mpr (lt_trans zero_lt_one (Set.mem_Ioi.mp ht))
  rw [hset]

/-- `Etr` is locally integrable on `(0,∞)`. -/
theorem Etr_locallyIntegrable : MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) := by
  intro x hx
  obtain ⟨ε, hε, hball⟩ := Metric.nhdsWithin_basis_ball.mem_iff.mp
    (self_mem_nhdsWithin (a := x) (s := Set.Ioi (0:ℝ)))
  refine ⟨Metric.ball x ε ∩ Set.Ioi 0, Metric.nhdsWithin_basis_ball.mem_iff.mpr
    ⟨ε, hε, Set.Subset.rfl⟩, ?_⟩
  have hbdd : ∀ t ∈ Metric.ball x ε ∩ Set.Ioi (0:ℝ), ‖Etr t‖ ≤ (Real.log 4 + 5) * (x + ε) := by
    intro t ht
    have htb : |t - x| < ε := by
      have := ht.1
      rwa [Metric.mem_ball, Real.dist_eq] at this
    have ht0 : (0:ℝ) < t := ht.2
    have htle : t ≤ x + ε := by cases abs_lt.mp htb; linarith
    calc ‖Etr t‖ ≤ ‖(E t : ℂ)‖ := by
          rw [Etr]
          by_cases h : t ∈ Set.Ioi (1:ℝ)
          · rw [Set.indicator_of_mem h]
          · rw [Set.indicator_of_notMem h]; simp
      _ = ‖(E t : ℝ)‖ := by rw [Complex.norm_real]
      _ ≤ (Real.log 4 + 5) * t := E_le_linear ht0.le
      _ ≤ (Real.log 4 + 5) * (x + ε) := by
          have : (0:ℝ) ≤ Real.log 4 + 5 := by positivity
          nlinarith
  have hfin : (volume (Metric.ball x ε ∩ Set.Ioi 0)) < ⊤ :=
    lt_of_le_of_lt (measure_mono Set.inter_subset_left) measure_ball_lt_top
  haveI : MeasureTheory.IsFiniteMeasure
      (volume.restrict (Metric.ball x ε ∩ Set.Ioi (0:ℝ))) :=
    ⟨by rwa [Measure.restrict_apply_univ]⟩
  refine MeasureTheory.Integrable.mono' (g := fun _ ↦ (Real.log 4 + 5) * (x + ε))
    (MeasureTheory.integrable_const _)
    (Etr_measurable.aestronglyMeasurable.restrict) ?_
  filter_upwards [MeasureTheory.ae_restrict_mem
    ((Metric.isOpen_ball.inter isOpen_Ioi).measurableSet)] with t ht
  exact hbdd t ht

/-- **V1 — F is differentiable on `re s > 1/2`, given the von Koch bound.**
The hypothesis is consumed here: `E = O(t^{1/2+δ})` at infinity makes the
Mellin transform of `Etr` differentiable at `-s` whenever `re s > 1/2 + δ`. -/
theorem F_differentiableAt {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3)
    {s : ℂ} (hs : 1/2 < s.re) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ F s := by
  set δ : ℝ := (s.re - 1/2) / 2 with hδ
  have hδ0 : 0 < δ := by rw [hδ]; linarith
  -- Etr = O(t^(1/2 + δ)) at infinity
  have htop : Etr =O[Filter.atTop] (fun t : ℝ ↦ t ^ (-(-(1/2) - δ))) := by
    have hlog : (fun t : ℝ ↦ (Real.log t) ^ 3) =o[Filter.atTop]
        (fun t : ℝ ↦ t ^ δ) := by
      have hδ3 : (0:ℝ) < δ/3 := by positivity
      have h := (isLittleO_log_rpow_atTop hδ3).pow (n := 3) (by norm_num : (0:ℕ) < 3)
      refine h.congr' (Filter.EventuallyEq.refl _ _) ?_
      filter_upwards [Filter.eventually_ge_atTop (0:ℝ)] with t ht
      rw [← Real.rpow_natCast (t ^ (δ/3)) 3, ← Real.rpow_mul ht]
      norm_num
    have hbig : (fun t : ℝ ↦ C * Real.sqrt t * (Real.log t) ^ 3)
        =O[Filter.atTop] (fun t : ℝ ↦ t ^ (1/2 + δ)) := by
      have hsq : (fun t : ℝ ↦ Real.sqrt t) =O[Filter.atTop]
          (fun t : ℝ ↦ t ^ (1/2 : ℝ)) := by
        apply Asymptotics.IsBigO.of_bound 1
        filter_upwards [Filter.eventually_ge_atTop (0:ℝ)] with t ht
        rw [Real.sqrt_eq_rpow, one_mul]

      have := ((hsq.const_mul_left C).mul hlog.isBigO)
      refine this.trans (Asymptotics.IsBigO.of_bound 1 ?_)
      filter_upwards [Filter.eventually_ge_atTop (1:ℝ)] with t ht
      have ht0 : (0:ℝ) < t := lt_of_lt_of_le zero_lt_one ht
      rw [one_mul, Real.norm_of_nonneg (by positivity), Real.norm_of_nonneg
        (Real.rpow_nonneg ht0.le _), ← Real.rpow_add ht0, add_comm (1/2 : ℝ) δ]
    have hEO : Etr =O[Filter.atTop] (fun t : ℝ ↦ C * Real.sqrt t * (Real.log t) ^ 3) := by
      apply Asymptotics.IsBigO.of_bound 1
      filter_upwards [Filter.eventually_ge_atTop (max x₀ 1)] with t ht
      have ht1 : (1:ℝ) ≤ t := le_trans (le_max_right _ _) ht
      have htx : x₀ ≤ t := le_trans (le_max_left _ _) ht
      have hb := hbound t htx
      rw [one_mul, Etr]
      by_cases h : t ∈ Set.Ioi (1:ℝ)
      · rw [Set.indicator_of_mem h, Complex.norm_real]
        calc ‖E t‖ = |ψ t - t| := by rw [E, Real.norm_eq_abs]
          _ ≤ C * Real.sqrt t * (Real.log t) ^ 3 := hb
          _ ≤ ‖C * Real.sqrt t * (Real.log t) ^ 3‖ := Real.le_norm_self _
      · rw [Set.indicator_of_notMem h]
        simp only [norm_zero]
        positivity
    refine (hEO.trans hbig).congr' (Filter.EventuallyEq.refl _ _) ?_
    filter_upwards with t
    congr 1
    ring
  -- Etr vanishes near 0, so it is O(t^(-b)) for the b we need
  have hbot : Etr =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ ↦ t ^ (-(-s.re - 1))) := by
    apply Asymptotics.IsBigO.of_bound 0
    filter_upwards [Ioo_mem_nhdsGT zero_lt_one] with t ht
    have hnot : t ∉ Set.Ioi (1:ℝ) := by
      simp only [Set.mem_Ioi, not_lt]
      exact le_of_lt ht.2
    rw [Etr, Set.indicator_of_notMem hnot]
    simp
  have hmel : DifferentiableAt ℂ (mellin Etr) (-s) :=
    mellin_differentiableAt_of_isBigO_rpow Etr_locallyIntegrable htop
      (by simp only [Complex.neg_re]; linarith) hbot
      (by simp only [Complex.neg_re]; linarith)
  -- F agrees globally with the composite
  have hFeq : F = fun z : ℂ ↦ z / (z - 1) + z * mellin Etr (-z) := by
    funext z
    rw [F]
    rw [show (∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-z - 1))
        = mellin Etr (-z) from E_integral_eq_mellin z]
  rw [hFeq]
  have h1 : DifferentiableAt ℂ (fun z : ℂ ↦ z / (z - 1)) s := by
    apply DifferentiableAt.div differentiableAt_id (by fun_prop)
    intro h
    exact hs1 (by linear_combination h)
  have h2 : DifferentiableAt ℂ (fun z : ℂ ↦ mellin Etr (-z)) s :=
    hmel.comp s differentiable_neg.differentiableAt
  exact h1.add (differentiableAt_id.mul h2)

/-- The partial sums of `Λ` over `Icc 1 n` are `ψ n`. -/
theorem sum_Icc_vonMangoldt (n : ℕ) :
    ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n := by
  show _ = Chebyshev.psi _
  rw [Chebyshev.psi, Nat.floor_natCast, ← Finset.Icc_add_one_left_eq_Ioc]
  norm_num

/-- ψ is O(x) unconditionally, in big-O form on ℕ. -/
theorem psi_partial_bigO :
    (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k)
      =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) := by
  apply Asymptotics.IsBigO.of_bound (Real.log 4 + 4)
  filter_upwards [Filter.eventually_ge_atTop 1] with n hn
  rw [sum_Icc_vonMangoldt]
  have h1 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
  have h2 := Chebyshev.psi_le_const_mul_self h1
  have h3 : (0:ℝ) ≤ ψ (n:ℝ) := Chebyshev.psi_nonneg _
  rw [Real.norm_of_nonneg h3, Real.norm_of_nonneg (by positivity : (0:ℝ) ≤ (n:ℝ) ^ (1:ℝ)),
    Real.rpow_one]
  exact h2

/-- The ψ-integrand is integrable on `Ioi 1` for `re s > 1`. -/
theorem measurable_psi : Measurable (fun t : ℝ ↦ ψ t) := by
  have : (fun t : ℝ ↦ ψ t)
      = (fun n : ℕ ↦ ∑ k ∈ Finset.Ioc 0 n, ArithmeticFunction.vonMangoldt k)
        ∘ (fun t : ℝ ↦ ⌊t⌋₊) := rfl
  rw [this]
  exact Measurable.comp (.of_discrete) Nat.measurable_floor

theorem integrable_psi_cpow {s : ℂ} (hs : 1 < s.re) :
    IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1)))
      (Set.Ioi (1:ℝ)) := by
  have hmeas : AEStronglyMeasurable
      (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1)))
      (volume.restrict (Set.Ioi (1:ℝ))) := by
    apply AEStronglyMeasurable.mul
    · exact (Complex.measurable_ofReal.comp measurable_psi).aestronglyMeasurable
    · refine (ContinuousOn.aestronglyMeasurable (fun t ht ↦ ?_) measurableSet_Ioi)
      have ht0 : (0:ℝ) < t := lt_trans zero_lt_one ht
      exact ((Complex.continuous_ofReal.continuousAt).cpow
        continuousAt_const (Or.inl (by exact_mod_cast ht0))).continuousWithinAt
  have hmaj : IntegrableOn (fun t : ℝ ↦ (Real.log 4 + 4) * t ^ (-s.re))
      (Set.Ioi (1:ℝ)) :=
    (integrableOn_Ioi_rpow_of_lt (by linarith) zero_lt_one).const_mul _
  refine hmaj.integrable.mono' hmeas ?_
  filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with t ht
  have ht1 : (1:ℝ) < t := ht
  have ht0 : (0:ℝ) < t := lt_trans zero_lt_one ht1
  rw [norm_mul, Complex.norm_real, Complex.norm_cpow_eq_rpow_re_of_pos ht0]
  have hre : (-(s+1)).re = -s.re - 1 := by
    simp only [Complex.neg_re, Complex.add_re, Complex.one_re]
    ring
  have hψ0 : (0:ℝ) ≤ ψ t := Chebyshev.psi_nonneg t
  have hψle : ψ t ≤ (Real.log 4 + 4) * t := Chebyshev.psi_le_const_mul_self ht0.le
  rw [Real.norm_of_nonneg hψ0, hre]
  have hsplit : t ^ (-s.re - 1) = t ^ (-s.re) * t⁻¹ := by
    rw [show -s.re - 1 = -s.re + (-1) by ring, Real.rpow_add ht0, Real.rpow_neg_one]
  rw [hsplit]
  have hpos : (0:ℝ) ≤ t ^ (-s.re) := Real.rpow_nonneg ht0.le _
  calc ψ t * (t ^ (-s.re) * t⁻¹) ≤ ((Real.log 4 + 4) * t) * (t ^ (-s.re) * t⁻¹) := by
        gcongr
    _ = (Real.log 4 + 4) * t ^ (-s.re) := by field_simp

/-- **V2 — the identity on `re s > 1`.** The Mellin–Stieltjes representation is
Mathlib's `LSeries_eq_mul_integral_of_nonneg` (partial sums `O(n^1)`, from
unconditional Chebyshev); `LSeries_vonMangoldt_eq_deriv_riemannZeta_div` names
the left side; `integral_Ioi_cpow_of_lt` evaluates the main term. -/
theorem F_eq_neg_logDeriv {s : ℂ} (hs : 1 < s.re) :
    F s = -deriv riemannZeta s / riemannZeta s := by
  have h0 : (0:ℝ) ≤ 1 := zero_le_one
  have hrep := LSeries_eq_mul_integral_of_nonneg
    (fun n ↦ ArithmeticFunction.vonMangoldt n) h0 (by exact_mod_cast hs)
    psi_partial_bigO (fun n ↦ ArithmeticFunction.vonMangoldt_nonneg)
  have hL : LSeries (fun n ↦ (ArithmeticFunction.vonMangoldt n : ℂ)) s
      = -deriv riemannZeta s / riemannZeta s :=
    ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs
  -- rewrite the integrand's partial sum as ψ
  have hint : ∀ t : ℝ, t ∈ Set.Ioi (1:ℝ) →
      (∑ k ∈ Finset.Icc 1 ⌊t⌋₊, ((ArithmeticFunction.vonMangoldt k : ℝ) : ℂ))
        * (t : ℂ) ^ (-(s + 1))
      = ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1)) := by
    intro t ht
    congr 1
    show _ = ((Chebyshev.psi t : ℝ) : ℂ)
    rw [Chebyshev.psi]
    push_cast
    rfl
  rw [hL] at hrep
  -- split ψ = t + E
  have hsplit : ∀ t : ℝ, t ∈ Set.Ioi (1:ℝ) →
      ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))
      = (t : ℂ) ^ (-s) + ((E t : ℝ) : ℂ) * (t : ℂ) ^ (-s - 1) := by
    intro t ht
    have ht0 : (0:ℝ) < t := lt_trans zero_lt_one ht
    have htC : (t : ℂ) ≠ 0 := by exact_mod_cast ht0.ne'
    have hE : ((E t : ℝ) : ℂ) = ((ψ t : ℝ) : ℂ) - (t : ℂ) := by
      rw [E]; push_cast; ring
    have hpow : (t : ℂ) ^ (-(s+1)) * (t : ℂ) = (t : ℂ) ^ (-s) := by
      rw [show -(s+1) = -s + (-1) by ring, Complex.cpow_add _ _ htC,
        Complex.cpow_neg_one]
      field_simp
    rw [hE, show -s - 1 = -(s+1) by ring]
    rw [sub_mul, ← hpow]
    ring
  -- integrability of the two pieces
  have hint_t : IntegrableOn (fun t : ℝ ↦ (t : ℂ) ^ (-s)) (Set.Ioi (1:ℝ)) :=
    integrableOn_Ioi_cpow_of_lt (by simp [Complex.neg_re]; linarith) zero_lt_one
  have hint_psi := integrable_psi_cpow hs
  have hint_E : IntegrableOn (fun t : ℝ ↦ ((E t : ℝ) : ℂ) * (t : ℂ) ^ (-s - 1))
      (Set.Ioi (1:ℝ)) := by
    have hEeq : Set.EqOn
        (fun t : ℝ ↦ ((E t : ℝ) : ℂ) * (t : ℂ) ^ (-s - 1))
        (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1)) - (t : ℂ) ^ (-s))
        (Set.Ioi (1:ℝ)) := by
      intro t ht
      have h := hsplit t ht
      simp only at h ⊢
      linear_combination -h
    exact (IntegrableOn.congr_fun (hint_psi.sub hint_t) hEeq.symm measurableSet_Ioi)
  -- rewrite the representation's integrand to the psi form
  have hcongr : ∫ t in Set.Ioi (1:ℝ),
      (∑ k ∈ Finset.Icc 1 ⌊t⌋₊, ((ArithmeticFunction.vonMangoldt k : ℝ) : ℂ))
        * (t : ℂ) ^ (-(s + 1))
      = ∫ t in Set.Ioi (1:ℝ), ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1)) :=
    MeasureTheory.setIntegral_congr_fun measurableSet_Ioi hint
  -- split the psi integral
  have hsplit_int : ∫ t in Set.Ioi (1:ℝ), ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))
      = (∫ t in Set.Ioi (1:ℝ), (t : ℂ) ^ (-s))
        + ∫ t in Set.Ioi (1:ℝ), ((E t : ℝ) : ℂ) * (t : ℂ) ^ (-s - 1) := by
    rw [← MeasureTheory.integral_add hint_t hint_E]
    exact MeasureTheory.setIntegral_congr_fun measurableSet_Ioi hsplit
  -- evaluate the main term
  have hmain : (∫ t in Set.Ioi (1:ℝ), (t : ℂ) ^ (-s)) = 1 / (s - 1) := by
    rw [integral_Ioi_cpow_of_lt (by simp [Complex.neg_re]; linarith) zero_lt_one]
    rw [Complex.ofReal_one, Complex.one_cpow]
    have hs1 : s - 1 ≠ 0 := by
      intro h
      have : s = 1 := by linear_combination h
      rw [this] at hs; simp at hs
    have hne : (-s + 1) ≠ 0 := by
      intro h
      exact hs1 (by linear_combination -h)
    field_simp
    ring
  -- assemble
  rw [hcongr, hsplit_int, hmain] at hrep
  rw [F, hrep]
  ring

/-- **V3 — agreement extends to the punctured half-plane.** The region
`{re > 1/2} \ ({1} ∪ zeros)` is open and path-connected (zeros of an analytic
function are countable; `Set.Countable.isPathConnected_compl_of_one_lt_rank`),
both sides are analytic there, and they agree on the open subset `re > 1`. -/
theorem F_eq_neg_logDeriv_ext {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3)
    {s : ℂ} (hs : 1/2 < s.re) (hs1 : s ≠ 1) (hz : riemannZeta s ≠ 0) :
    F s = -deriv riemannZeta s / riemannZeta s := by
  sorry

/-- **V4 — contradiction at a zero.** If `ζ(ρ) = 0` with `re ρ > 1/2`, then
`‖ζ'/ζ‖ → ∞` along `s → ρ` (zero of finite order `m`: `ζ'/ζ ~ m/(s−ρ)`),
while `F` is continuous at `ρ` by V1 — but they agree near `ρ` by V3. -/
theorem no_zero_right_of_half {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3)
    {ρ : ℂ} (hρ : 1/2 < ρ.re) (hρ1 : ρ ≠ 1) :
    riemannZeta ρ ≠ 0 := by
  sorry

/-- **V5 — reflection.** No zeros right of the line forces every nontrivial
zero onto it: a zero at `re < 1/2` inside the strip reflects through
`riemannZeta_one_sub` to one at `re > 1/2`. -/
theorem RH_of_no_zero_right_of_half
    (h : ∀ ρ : ℂ, 1/2 < ρ.re → ρ ≠ 1 → riemannZeta ρ ≠ 0) :
    RiemannHypothesis := by
  intro s hz htriv hs1
  by_contra hre
  rcases lt_or_gt_of_ne hre with hlt | hgt
  swap
  · exact h s hgt hs1 hz
  have h2 : (2 : ℂ) ≠ 0 := two_ne_zero
  -- re s < 1/2 : reflect through w = 1 - s
  set w : ℂ := 1 - s with hw
  have hwre : 1/2 < w.re := by
    rw [hw]
    simp only [Complex.sub_re, Complex.one_re]
    linarith
  have hs0 : s ≠ 0 := by
    intro h0
    rw [h0, riemannZeta_zero] at hz
    norm_num at hz
  have hw1 : w ≠ 1 := by
    rw [hw]
    intro hcon
    exact hs0 (by linear_combination -hcon)
  have hwn : ∀ n : ℕ, w ≠ -(n : ℂ) := by
    intro n hcon
    have : w.re = -(n : ℝ) := by rw [hcon]; simp
    have hn0 : (0:ℝ) ≤ (n:ℝ) := Nat.cast_nonneg n
    linarith [hwre, this]
  -- functional equation at w : ζ(1 - w) = ζ(s)
  have hfe := riemannZeta_one_sub hwn hw1
  have h1w : (1 : ℂ) - w = s := by rw [hw]; ring
  rw [h1w, hz] at hfe
  -- every factor except ζ(w) is nonzero
  have hbase : ((2:ℂ) * Real.pi) ≠ 0 := by
    simp [Real.pi_ne_zero]
  have hpow : ((2:ℂ) * Real.pi) ^ (-w) ≠ 0 :=
    Complex.cpow_ne_zero_iff.mpr (Or.inl hbase)
  have hGamma : Complex.Gamma w ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m
    exact hwn m
  have hcos : Complex.cos (Real.pi * w / 2) ≠ 0 := by
    rw [Ne, Complex.cos_eq_zero_iff]
    rintro ⟨k, hk⟩
    -- π·w/2 = (2k+1)·π/2  ⟹  w = 2k+1
    have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
    have hwk : w = 2 * (k : ℂ) + 1 := by
      have hπw : (Real.pi : ℂ) * w = (Real.pi : ℂ) * (2 * (k : ℂ) + 1) := by
        linear_combination 2 * hk
      exact mul_left_cancel₀ hπ hπw
    -- w = 2k+1 with re w > 1/2 forces k ≥ 0; k = 0 gives w = 1 (excluded);
    -- k ≥ 1 gives s = 1 - w = -2k, a trivial zero (excluded)
    have hkre : (2 * (k:ℝ) + 1 : ℝ) = w.re := by
      have := congrArg Complex.re hwk
      simp at this
      linarith [this]
    have hk0 : 0 ≤ k := by
      by_contra hneg
      push_neg at hneg
      have : (k : ℝ) ≤ -1 := by exact_mod_cast Int.le_sub_one_of_lt hneg
      linarith [hwre, hkre]
    rcases eq_or_lt_of_le hk0 with hk0' | hkpos
    · apply hw1
      rw [hwk, ← hk0']
      norm_num
    · apply htriv
      have hk1 : 1 ≤ k := hkpos
      refine ⟨(k - 1).toNat, ?_⟩
      have htn : ((k - 1).toNat : ℂ) = (k : ℂ) - 1 := by
        have : ((k - 1).toNat : ℤ) = k - 1 := Int.toNat_of_nonneg (by omega)
        exact_mod_cast congrArg (Int.cast : ℤ → ℂ) this
      have hsw : s = 1 - w := by rw [hw]; ring
      rw [hsw, hwk, htn]
      push_cast
      ring
  -- all factors nonzero, product zero ⟹ ζ(w) = 0
  have hzw : riemannZeta w = 0 := by
    by_contra hne
    exact (mul_ne_zero (mul_ne_zero (mul_ne_zero (mul_ne_zero h2 hpow) hGamma) hcos) hne) hfe.symm
  exact h w hwre hw1 hzw

/-- **B1 — the converse, assembled from V1–V5.** -/
theorem RH_of_psiWeak {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3) :
    RiemannHypothesis :=
  RH_of_no_zero_right_of_half (fun _ hρ hρ1 => no_zero_right_of_half hbound hρ hρ1)

end VonKoch
