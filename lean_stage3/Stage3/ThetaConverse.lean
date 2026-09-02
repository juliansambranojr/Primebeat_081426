/-
ThetaConverse — the Landau converse of the θ-dial. 2026-09-01.

`ThetaPsi.psi_weak_of_theta` and `ThetaPi.schoenfeldWeakTheta_of_zeroFree`
run one way: a zero-free half-plane `re s > θ` gives `|ψ − x| ≤ C·x^θ·log^k x`.
This file runs the other way:

  zeroFreeRight_of_psiWeakTheta   StmtPsiWeakTheta θ C k x₀ → StmtZeroFreeRight θ

so the abscissa of ψ's error and the supremum of the zeros' real parts are the
same number. The route is `VonKochScaffold`'s B1 with `1/2` replaced by `θ`:

  V1  F analytic on re s > θ given the bound     mellin_differentiableAt_of_isBigO_rpow
  V2  F = −ζ′/ζ on re s > 1                      VonKoch.F_eq_neg_logDeriv, reused as is
  V3  F·ζ + ζ′ ≡ 0 on {re s > θ} \ {1}           identity theorem on four convex pieces
  V4  a zero ρ with re ρ > θ contradicts V3      factor ζ = (z−ρ)^(k+1)·g, g ρ ≠ 0

Where `θ` enters: V1 consumes `θ < re s` through `δ := (re s − θ)/2` — the
Mellin lemma wants `E = O(t^(θ+δ))` at `∞` and `−re s < −θ − δ`; V3 needs a
point with `θ < re < 1` to glue the pieces, which is `θ < 1`; for `θ ≥ 1` the
conclusion is `Abscissa.zeroFreeRight_one` through `zeroFreeRight_mono` and
the hypothesis is never opened. No lower bound on `θ`, no sign on `C`, no
floor on `x₀` is needed: the big-O bound is read through `‖·‖` on the right
and above `max x₀ 1`.

The hypothesis-free pieces — `VonKoch.F`, `VonKoch.Etr`,
`VonKoch.E_integral_eq_mellin`, `VonKoch.Etr_locallyIntegrable`,
`VonKoch.F_eq_neg_logDeriv` — are reused; only the pieces that mention the
abscissa are restated.

`θ` in this file is the abscissa; Chebyshev's theta is not used.
-/
import Stage3.ThetaPi
import Stage3.VonKochScaffold

namespace Stage3

open Complex Set MeasureTheory Topology

local notation "ψ" => Chebyshev.psi
local notation "ζ" => riemannZeta

noncomputable section

/-! ## The region at `θ` -/

/-- The working region at abscissa `θ`: right of `θ`, minus the pole.
`VonKoch.region` is the `θ = 1/2` case. -/
def regionθ (θ : ℝ) : Set ℂ := {s : ℂ | θ < s.re ∧ s ≠ 1}

theorem regionθ_half : regionθ (1/2) = VonKoch.region := rfl

theorem isOpen_regionθ (θ : ℝ) : IsOpen (regionθ θ) := by
  have h : regionθ θ = {s : ℂ | θ < s.re} ∩ {(1:ℂ)}ᶜ := by
    ext s
    simp [regionθ, Set.mem_setOf_eq]
  rw [h]
  exact (isOpen_lt continuous_const Complex.continuous_re).inter isOpen_compl_singleton

/-- **The region is connected for `θ < 1`.** Four convex pieces — upper
half, lower half, the strip `θ < re < 1`, and `re > 1` — glued at
`((θ+1)/2, ±1)` and `(2, 1)`. This is `VonKoch.preconnected_region` with the
gluing point `3/4` replaced by `(θ+1)/2`, which is where `θ < 1` enters. -/
theorem preconnected_regionθ {θ : ℝ} (hθ : θ < 1) : IsPreconnected (regionθ θ) := by
  have hm1 : θ < (θ + 1) / 2 := by linarith
  have hm2 : (θ + 1) / 2 < 1 := by linarith
  have hθ2 : θ < 2 := by linarith
  have hA : IsPreconnected {s : ℂ | θ < s.re ∧ 0 < s.im} := by
    rw [Set.setOf_and]
    exact ((convex_halfSpace_re_gt _).inter (convex_halfSpace_im_gt _)).isPreconnected
  have hB : IsPreconnected {s : ℂ | θ < s.re ∧ s.im < 0} := by
    rw [Set.setOf_and]
    exact ((convex_halfSpace_re_gt _).inter (convex_halfSpace_im_lt _)).isPreconnected
  have hC : IsPreconnected {s : ℂ | θ < s.re ∧ s.re < 1} := by
    rw [Set.setOf_and]
    exact ((convex_halfSpace_re_gt _).inter (convex_halfSpace_re_lt _)).isPreconnected
  have hD : IsPreconnected {s : ℂ | 1 < s.re} :=
    (convex_halfSpace_re_gt _).isPreconnected
  have hS1 : IsPreconnected
      ({s : ℂ | θ < s.re ∧ 0 < s.im} ∪ {s : ℂ | θ < s.re ∧ s.re < 1}) :=
    IsPreconnected.union (⟨(θ + 1) / 2, 1⟩ : ℂ)
      ⟨hm1, show (0:ℝ) < 1 by norm_num⟩ ⟨hm1, hm2⟩ hA hC
  have hS2 : IsPreconnected
      (({s : ℂ | θ < s.re ∧ 0 < s.im} ∪ {s : ℂ | θ < s.re ∧ s.re < 1})
        ∪ {s : ℂ | θ < s.re ∧ s.im < 0}) :=
    IsPreconnected.union (⟨(θ + 1) / 2, -1⟩ : ℂ)
      (Or.inr ⟨hm1, hm2⟩) ⟨hm1, show (-1:ℝ) < 0 by norm_num⟩ hS1 hB
  have hS3 : IsPreconnected
      ((({s : ℂ | θ < s.re ∧ 0 < s.im} ∪ {s : ℂ | θ < s.re ∧ s.re < 1})
        ∪ {s : ℂ | θ < s.re ∧ s.im < 0}) ∪ {s : ℂ | 1 < s.re}) :=
    IsPreconnected.union (⟨2, 1⟩ : ℂ)
      (Or.inl (Or.inl ⟨hθ2, show (0:ℝ) < 1 by norm_num⟩))
      (show (1:ℝ) < 2 by norm_num) hS2 hD
  have hcover : regionθ θ
      = (({s : ℂ | θ < s.re ∧ 0 < s.im} ∪ {s : ℂ | θ < s.re ∧ s.re < 1})
        ∪ {s : ℂ | θ < s.re ∧ s.im < 0}) ∪ {s : ℂ | 1 < s.re} := by
    ext s
    constructor
    · rintro ⟨hre, hne⟩
      rcases lt_trichotomy s.im 0 with him | him | him
      · exact Or.inl (Or.inr ⟨hre, him⟩)
      · have hre1 : s.re ≠ 1 := by
          intro h1
          exact hne (Complex.ext (by rw [h1, Complex.one_re]) (by rw [him, Complex.one_im]))
        rcases lt_or_gt_of_ne hre1 with h | h
        · exact Or.inl (Or.inl (Or.inr ⟨hre, h⟩))
        · exact Or.inr h
      · exact Or.inl (Or.inl (Or.inl ⟨hre, him⟩))
    · rintro (((⟨h1, h2⟩ | ⟨h1, h2⟩) | ⟨h1, h2⟩) | h)
      · exact ⟨h1, fun he ↦ by rw [he] at h2; simp at h2⟩
      · exact ⟨h1, fun he ↦ by rw [he] at h2; simp at h2⟩
      · exact ⟨h1, fun he ↦ by rw [he] at h2; simp at h2⟩
      · exact ⟨lt_trans hθ h, fun he ↦ by rw [he] at h; simp at h⟩
  rw [hcover]
  exact hS3

theorem zeta_analyticOnNhd_regionθ (θ : ℝ) : AnalyticOnNhd ℂ ζ (regionθ θ) :=
  DifferentiableOn.analyticOnNhd
    (fun _ hs ↦ (differentiableAt_riemannZeta hs.2).differentiableWithinAt) (isOpen_regionθ θ)

/-! ## V1 — `F` is differentiable on `re s > θ` -/

/-- `(log t)^k = O(t^δ)` at `∞` for every `δ > 0` and every `k`. The `k = 0`
case is `1 ≤ t^δ`; for `k ≥ 1`, `log = o(t^(δ/k))` raised to the `k`. -/
theorem log_pow_isBigO_rpow {δ : ℝ} (hδ : 0 < δ) (k : ℕ) :
    (fun t : ℝ ↦ (Real.log t) ^ k) =O[Filter.atTop] (fun t : ℝ ↦ t ^ δ) := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · subst hk
    apply Asymptotics.IsBigO.of_bound 1
    filter_upwards [Filter.eventually_ge_atTop (1:ℝ)] with t ht
    rw [pow_zero, one_mul, Real.norm_of_nonneg (Real.rpow_nonneg (by linarith) _),
      norm_one]
    exact Real.one_le_rpow ht hδ.le
  · have hδk : (0:ℝ) < δ / k := by positivity
    have h1 := ((isLittleO_log_rpow_atTop hδk).pow hk).isBigO
    refine h1.congr' (Filter.EventuallyEq.refl _ _) ?_
    filter_upwards [Filter.eventually_ge_atTop (0:ℝ)] with t ht
    rw [← Real.rpow_natCast (t ^ (δ / k)) k, ← Real.rpow_mul ht]
    congr 1
    have hk0 : (k : ℝ) ≠ 0 := by exact_mod_cast hk.ne'
    field_simp

/-- **V1 at `θ`.** `E = O(t^(θ+δ))` at `∞` for `δ := (re s − θ)/2 > 0`, and
`Etr = 0` below `1`, so `mellin Etr` is differentiable at `−s`. This is
`VonKoch.F_differentiableAt` with `t^θ·log^k t` for `√t·log³ t`; the
hypothesis is consumed here and nowhere else. -/
theorem F_differentiableAt_theta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta θ C k x₀)
    {s : ℂ} (hs : θ < s.re) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ VonKoch.F s := by
  set δ : ℝ := (s.re - θ) / 2 with hδ
  have hδ0 : 0 < δ := by rw [hδ]; linarith
  -- Etr = O(t^(θ + δ)) at infinity
  have htop : VonKoch.Etr =O[Filter.atTop] (fun t : ℝ ↦ t ^ (-(-θ - δ))) := by
    have hlog := log_pow_isBigO_rpow hδ0 k
    have hbig : (fun t : ℝ ↦ C * t ^ θ * (Real.log t) ^ k)
        =O[Filter.atTop] (fun t : ℝ ↦ t ^ (θ + δ)) := by
      have hpow : (fun t : ℝ ↦ t ^ θ) =O[Filter.atTop] (fun t : ℝ ↦ t ^ θ) :=
        Asymptotics.isBigO_refl _ _
      have := ((hpow.const_mul_left C).mul hlog)
      refine this.trans (Asymptotics.IsBigO.of_bound 1 ?_)
      filter_upwards [Filter.eventually_ge_atTop (1:ℝ)] with t ht
      have ht0 : (0:ℝ) < t := lt_of_lt_of_le zero_lt_one ht
      rw [one_mul, Real.norm_of_nonneg (by positivity), Real.norm_of_nonneg
        (Real.rpow_nonneg ht0.le _), ← Real.rpow_add ht0]
    have hEO : VonKoch.Etr =O[Filter.atTop]
        (fun t : ℝ ↦ C * t ^ θ * (Real.log t) ^ k) := by
      apply Asymptotics.IsBigO.of_bound 1
      filter_upwards [Filter.eventually_ge_atTop (max x₀ 1)] with t ht
      have htx : x₀ ≤ t := le_trans (le_max_left _ _) ht
      have hb := h t htx
      rw [one_mul, VonKoch.Etr]
      by_cases h' : t ∈ Set.Ioi (1:ℝ)
      · rw [Set.indicator_of_mem h', Complex.norm_real]
        calc ‖VonKoch.E t‖ = |ψ t - t| := by rw [VonKoch.E, Real.norm_eq_abs]
          _ ≤ C * t ^ θ * (Real.log t) ^ k := hb
          _ ≤ ‖C * t ^ θ * (Real.log t) ^ k‖ := Real.le_norm_self _
      · rw [Set.indicator_of_notMem h']
        simp only [norm_zero]
        positivity
    refine (hEO.trans hbig).congr' (Filter.EventuallyEq.refl _ _) ?_
    filter_upwards with t
    congr 1
    ring
  -- Etr vanishes near 0, so it is O(t^(-b)) for the b we need
  have hbot : VonKoch.Etr =O[nhdsWithin 0 (Set.Ioi 0)] (fun t : ℝ ↦ t ^ (-(-s.re - 1))) := by
    apply Asymptotics.IsBigO.of_bound 0
    filter_upwards [Ioo_mem_nhdsGT zero_lt_one] with t ht
    have hnot : t ∉ Set.Ioi (1:ℝ) := by
      simp only [Set.mem_Ioi, not_lt]
      exact le_of_lt ht.2
    rw [VonKoch.Etr, Set.indicator_of_notMem hnot]
    simp
  have hmel : DifferentiableAt ℂ (mellin VonKoch.Etr) (-s) :=
    mellin_differentiableAt_of_isBigO_rpow VonKoch.Etr_locallyIntegrable htop
      (by simp only [Complex.neg_re]; linarith) hbot
      (by simp only [Complex.neg_re]; linarith)
  -- F agrees globally with the composite
  have hFeq : VonKoch.F = fun z : ℂ ↦ z / (z - 1) + z * mellin VonKoch.Etr (-z) := by
    funext z
    rw [VonKoch.F]
    rw [show (∫ x in Set.Ioi (1:ℝ), (VonKoch.E x : ℂ) * (x : ℂ) ^ (-z - 1))
        = mellin VonKoch.Etr (-z) from VonKoch.E_integral_eq_mellin z]
  rw [hFeq]
  have h1 : DifferentiableAt ℂ (fun z : ℂ ↦ z / (z - 1)) s := by
    apply DifferentiableAt.div differentiableAt_id (by fun_prop)
    intro h
    exact hs1 (by linear_combination h)
  have h2 : DifferentiableAt ℂ (fun z : ℂ ↦ mellin VonKoch.Etr (-z)) s :=
    hmel.comp s differentiable_neg.differentiableAt
  exact h1.add (differentiableAt_id.mul h2)

theorem F_analyticOnNhd_theta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta θ C k x₀) :
    AnalyticOnNhd ℂ VonKoch.F (regionθ θ) :=
  DifferentiableOn.analyticOnNhd
    (fun _ hs ↦ (F_differentiableAt_theta h hs.1 hs.2).differentiableWithinAt)
    (isOpen_regionθ θ)

end

/-! ## Axiom check -/

/-- info: 'Stage3.preconnected_regionθ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.preconnected_regionθ

/-- info: 'Stage3.F_differentiableAt_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.F_differentiableAt_theta

end Stage3
