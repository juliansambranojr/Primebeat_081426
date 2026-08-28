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

/-- **V1 — the E-integral converges and is differentiable for `re s > 1/2`,
given the hypothesis.** Via `mellin_differentiableAt_of_isBigO_rpow`:
`E = O(x^(1/2+δ))` at infinity for any `δ > 0` from the hypothesis, and `E`
is locally bounded on `[1,∞)`. -/
theorem F_differentiableAt {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3)
    {s : ℂ} (hs : 1/2 < s.re) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ F s := by
  sorry

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
  sorry

/-- **B1 — the converse, assembled from V1–V5.** -/
theorem RH_of_psiWeak {C x₀ : ℝ}
    (hbound : ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * (Real.log t) ^ 3) :
    RiemannHypothesis :=
  RH_of_no_zero_right_of_half (fun _ hρ hρ1 => no_zero_right_of_half hbound hρ hρ1)

end VonKoch
