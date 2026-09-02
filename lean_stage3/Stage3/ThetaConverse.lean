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

/-- **The region is connected, for every `θ`.** For `θ < 1`: four convex
pieces — upper half, lower half, the strip `θ < re < 1`, and `re > 1` —
glued at `((θ+1)/2, ±1)` and `(2, 1)`; this is `VonKoch.preconnected_region`
with the gluing point `3/4` replaced by `(θ+1)/2`. For `θ ≥ 1` the pole is
already outside the half-plane and the region is the convex set `{re > θ}`. -/
theorem preconnected_regionθ (θ : ℝ) : IsPreconnected (regionθ θ) := by
  rcases lt_or_ge θ 1 with hθ | hθ
  swap
  · have h : regionθ θ = {s : ℂ | θ < s.re} := by
      ext s
      constructor
      · rintro ⟨h, _⟩; exact h
      · intro h
        refine ⟨h, fun he ↦ ?_⟩
        have h' : θ < s.re := h
        rw [he, Complex.one_re] at h'
        linarith
    rw [h]
    exact (convex_halfSpace_re_gt _).isPreconnected
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

/-! ## V3 — the identity `F·ζ + ζ′ = 0` on the region

`VonKoch.F_eq_neg_logDeriv` gives `F = −ζ′/ζ` on `re s > 1` with no
hypothesis. The region is connected and contains a point with `re > 1`, so
the analytic function `F·ζ + ζ′` vanishing there vanishes everywhere on it. -/

/-- The anchor `max θ 1 + 1`: in the region, with `re > 1`, for every `θ`.
`VonKoch` used `2`, which leaves the region once `θ ≥ 2`. -/
theorem anchor_mem_regionθ (θ : ℝ) :
    ((max θ 1 + 1 : ℝ) : ℂ) ∈ regionθ θ ∧ 1 < ((max θ 1 + 1 : ℝ) : ℂ).re := by
  have h1 : (1:ℝ) < max θ 1 + 1 := by linarith [le_max_right θ 1]
  have h2 : θ < max θ 1 + 1 := by linarith [le_max_left θ 1]
  refine ⟨⟨by simp [h2], ?_⟩, by simp⟩
  intro he
  have := congrArg Complex.re he
  simp only [Complex.ofReal_re, Complex.one_re] at this
  linarith

/-- The load-bearing identity: `F·ζ + ζ′` vanishes on the whole region. -/
theorem F_mul_zeta_add_deriv_eqOn_zero_theta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta θ C k x₀) :
    Set.EqOn (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s) 0 (regionθ θ) := by
  have hG : AnalyticOnNhd ℂ (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s) (regionθ θ) :=
    ((F_analyticOnNhd_theta h).mul (zeta_analyticOnNhd_regionθ θ)).add
      (zeta_analyticOnNhd_regionθ θ).deriv
  obtain ⟨hp, hp1⟩ := anchor_mem_regionθ θ
  have hev : (fun s : ℂ ↦ VonKoch.F s * ζ s + deriv ζ s)
      =ᶠ[𝓝 ((max θ 1 + 1 : ℝ) : ℂ)] 0 := by
    have hopen : IsOpen {s : ℂ | 1 < s.re} := isOpen_lt continuous_const Complex.continuous_re
    filter_upwards [hopen.mem_nhds (show _ ∈ {s : ℂ | 1 < s.re} from hp1)] with s hs
    have hz : ζ s ≠ 0 := riemannZeta_ne_zero_of_one_lt_re hs
    have hF : VonKoch.F s = -deriv ζ s / ζ s := VonKoch.F_eq_neg_logDeriv hs
    show VonKoch.F s * ζ s + deriv ζ s = 0
    rw [hF, neg_div, neg_mul, div_mul_cancel₀ _ hz]
    ring
  exact hG.eqOn_zero_of_preconnected_of_eventuallyEq_zero (preconnected_regionθ θ) hp hev

/-! ## V4 — no zero right of `θ` -/

/-- **V4 at `θ`.** At a hypothetical zero `ρ` with `re ρ > θ`, factor
`ζ = (z−ρ)^(k+1)·g` with `g ρ ≠ 0`. The identity `F·ζ + ζ′ = 0` factors as
`(z−ρ)^k · [(k+1)·g + (z−ρ)·(F·g + g′)] = 0`; off `ρ` the power is nonzero, so
the bracket vanishes on the punctured neighbourhood — yet it is continuous at
`ρ` with value `(k+1)·g ρ ≠ 0`. Order `⊤` would make `ζ` vanish identically on
the region, against `ζ ≠ 0` at the anchor. `VonKoch.no_zero_right_of_half`,
with the region at `θ`. -/
theorem no_zero_right_of_theta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta θ C k x₀)
    {ρ : ℂ} (hρ : θ < ρ.re) (hρ1 : ρ ≠ 1) :
    ζ ρ ≠ 0 := by
  intro hzρ
  have hρmem : ρ ∈ regionθ θ := ⟨hρ, hρ1⟩
  have hζan : AnalyticAt ℂ ζ ρ := zeta_analyticOnNhd_regionθ θ ρ hρmem
  rcases eq_or_ne (analyticOrderAt ζ ρ) ⊤ with htop | hfin
  · -- order ⊤ : ζ ≡ 0 near ρ, hence on the region, against ζ ≠ 0 at the anchor
    have hev0 : ζ =ᶠ[𝓝 ρ] 0 := by
      filter_upwards [analyticOrderAt_eq_top.mp htop] with z hz
      simpa using hz
    have hall := (zeta_analyticOnNhd_regionθ θ).eqOn_zero_of_preconnected_of_eventuallyEq_zero
      (preconnected_regionθ θ) hρmem hev0
    obtain ⟨hp, hp1⟩ := anchor_mem_regionθ θ
    have hp0 : ζ ((max θ 1 + 1 : ℝ) : ℂ) = 0 := by simpa using hall hp
    exact riemannZeta_ne_zero_of_one_lt_re hp1 hp0
  · -- finite order : factor out the zero and contradict `g ρ ≠ 0`
    have hcast : analyticOrderAt ζ ρ = (analyticOrderNatAt ζ ρ : ℕ∞) :=
      (Nat.cast_analyticOrderNatAt hfin).symm
    obtain ⟨g, hg, hgρ, hfac⟩ := (hζan.analyticOrderAt_eq_natCast).mp hcast
    obtain ⟨m, hm⟩ : ∃ m, analyticOrderNatAt ζ ρ = m + 1 := by
      rcases Nat.eq_zero_or_pos (analyticOrderNatAt ζ ρ) with h0 | hpos
      · exfalso
        have hself := hfac.self_of_nhds
        rw [h0, pow_zero, one_smul, hzρ] at hself
        exact hgρ hself.symm
      · exact ⟨analyticOrderNatAt ζ ρ - 1, by omega⟩
    rw [hm] at hfac
    have hfac' : ∀ᶠ z in 𝓝 ρ, ζ z = (z - ρ) ^ (m + 1) * g z := by
      filter_upwards [hfac] with z hz
      simpa [smul_eq_mul] using hz
    have hζ'ev := Filter.EventuallyEq.deriv
      (show ζ =ᶠ[𝓝 ρ] fun z : ℂ ↦ (z - ρ) ^ (m + 1) * g z from hfac')
    have hderiv : ∀ᶠ z in 𝓝 ρ, deriv (fun w : ℂ ↦ (w - ρ) ^ (m + 1) * g w) z
        = ((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z := by
      filter_upwards [hg.eventually_analyticAt] with z hgz
      have h1 : HasDerivAt (fun w : ℂ ↦ (w - ρ) ^ (m + 1))
          (((m : ℂ) + 1) * (z - ρ) ^ m) z := by
        have h := ((hasDerivAt_id z).sub_const ρ).pow (m + 1)
        simp only [Nat.add_sub_cancel, mul_one, Nat.cast_add, Nat.cast_one, id_eq] at h
        exact h
      have h2 : HasDerivAt g (deriv g z) z := hgz.differentiableAt.hasDerivAt
      have h3 : HasDerivAt (fun w : ℂ ↦ (w - ρ) ^ (m + 1) * g w)
          (((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z) z :=
        h1.mul h2
      rw [h3.deriv]
    have hGev : ∀ᶠ z in 𝓝 ρ, VonKoch.F z * ζ z + deriv ζ z = 0 := by
      filter_upwards [(isOpen_regionθ θ).mem_nhds hρmem] with z hz
      simpa using F_mul_zeta_add_deriv_eqOn_zero_theta h hz
    have hpunct : ∀ᶠ z in 𝓝[≠] ρ,
        ((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z) = 0 := by
      have hall : ∀ᶠ z in 𝓝 ρ,
          (z - ρ) ^ m * (((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z))
            = 0 := by
        filter_upwards [hfac', hζ'ev, hderiv, hGev] with z h1 h2 h3 h4
        calc (z - ρ) ^ m * (((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z))
            = VonKoch.F z * ((z - ρ) ^ (m + 1) * g z)
              + (((m : ℂ) + 1) * (z - ρ) ^ m * g z + (z - ρ) ^ (m + 1) * deriv g z) := by
              ring
          _ = VonKoch.F z * ζ z + deriv ζ z := by rw [← h1, ← h3, ← h2]
          _ = 0 := h4
      filter_upwards [hall.filter_mono nhdsWithin_le_nhds, self_mem_nhdsWithin] with z hz hzρ'
      have hne : z - ρ ≠ 0 := sub_ne_zero.mpr (Set.mem_compl_singleton_iff.mp hzρ')
      exact (mul_eq_zero.mp hz).resolve_left (pow_ne_zero m hne)
    have hcont : ContinuousAt
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z)) ρ := by
      have hFc : ContinuousAt VonKoch.F ρ := (F_differentiableAt_theta h hρ hρ1).continuousAt
      have hgc : ContinuousAt g ρ := hg.continuousAt
      have hg'c : ContinuousAt (deriv g) ρ := hg.deriv.continuousAt
      exact (continuousAt_const.mul hgc).add
        ((continuousAt_id.sub continuousAt_const).mul ((hFc.mul hgc).add hg'c))
    have hlim1 : Filter.Tendsto
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z)) (𝓝[≠] ρ)
        (𝓝 (((m : ℂ) + 1) * g ρ + (ρ - ρ) * (VonKoch.F ρ * g ρ + deriv g ρ))) :=
      hcont.tendsto.mono_left nhdsWithin_le_nhds
    have hlim2 : Filter.Tendsto
        (fun z : ℂ ↦ ((m : ℂ) + 1) * g z + (z - ρ) * (VonKoch.F z * g z + deriv g z)) (𝓝[≠] ρ)
        (𝓝 0) := by
      refine Filter.Tendsto.congr' ?_ tendsto_const_nhds
      filter_upwards [hpunct] with z hz
      exact hz.symm
    have hval : ((m : ℂ) + 1) * g ρ + (ρ - ρ) * (VonKoch.F ρ * g ρ + deriv g ρ) = 0 :=
      tendsto_nhds_unique hlim1 hlim2
    rw [sub_self, zero_mul, add_zero] at hval
    have hm1 : ((m : ℂ) + 1) ≠ 0 := by exact_mod_cast Nat.succ_ne_zero m
    exact hgρ ((mul_eq_zero.mp hval).resolve_left hm1)

/-! ## The converse, and the equivalence -/

/-- **The Landau converse of the θ-dial.** A ψ-bound at exponent `θ` — any
`C`, any `k`, any floor `x₀` — forces `ζ ≠ 0` on `re s > θ`, `s ≠ 1`. No side
hypothesis: `θ`, `C`, `x₀` are unconstrained, because the bound is only read
through `‖·‖` above `max x₀ 1`, and the region is connected for every `θ`. -/
theorem zeroFreeRight_of_psiWeakTheta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta θ C k x₀) : StmtZeroFreeRight θ :=
  fun _ hρ hρ1 => no_zero_right_of_theta h hρ hρ1

/-- **The abscissa of ψ's error is the supremum of the zeros' real parts.**
For `θ ∈ [1/2, 1)`: a zero-free half-plane at `θ` holds iff ψ has a
`C·t^θ·log³ t` bound. Forward is `ThetaPsi.psi_weak_of_theta` (which is where
`[1/2, 1)` is needed); the converse is this file, and holds for every `θ`. -/
theorem zeroFreeRight_iff_psiWeakTheta {θ : ℝ} (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) :
    StmtZeroFreeRight θ ↔ ∃ C > 0, ∃ x₀ : ℝ, StmtPsiWeakTheta θ C 3 x₀ :=
  ⟨fun hθ => psi_weak_of_theta hθ hθlo hθhi,
   fun ⟨_, _, _, h⟩ => zeroFreeRight_of_psiWeakTheta h⟩

/-- **The weld at `θ = 1/2`:** `VonKoch.RH_of_psiWeak`'s statement through
the dial, via `Abscissa`'s `StmtZeroFreeRight (1/2)` and V5's reflection. -/
theorem RH_of_psiWeakTheta_half {C : ℝ} {k : ℕ} {x₀ : ℝ}
    (h : StmtPsiWeakTheta (1/2) C k x₀) : RiemannHypothesis :=
  VonKoch.RH_of_no_zero_right_of_half (zeroFreeRight_of_psiWeakTheta h)

/-! ## The Euler-product wall, as an instance -/

/-- The primes are a subset of the numbers, so `ψ(x) ≤ c·x`
(`Chebyshev.psi_le_const_mul_self`, `c = log 4 + 4`), so the count's
fluctuation is at most `x`, so no zero has real part above `1`. The
Euler-product wall as a corollary of the converse: this is the `θ = 1`,
`k = 0` instance, with `C = log 4 + 5` and floor `1`; the hypothesis is
genuinely opened at `θ = 1` since the region `{re > 1}` is convex. -/
theorem zeroFreeRight_one_of_chebyshev : StmtZeroFreeRight 1 := by
  refine zeroFreeRight_of_psiWeakTheta (θ := 1) (C := Real.log 4 + 5) (k := 0) (x₀ := 1) ?_
  intro t ht
  have h := VonKoch.E_le_linear (show (0:ℝ) ≤ t by linarith)
  rw [VonKoch.E, Real.norm_eq_abs] at h
  rw [Real.rpow_one, pow_zero, mul_one]
  exact h

end

/-! ## Axiom check -/

/-- info: 'Stage3.preconnected_regionθ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.preconnected_regionθ

/-- info: 'Stage3.F_differentiableAt_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.F_differentiableAt_theta

/-- info: 'Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta

/-- info: 'Stage3.no_zero_right_of_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.no_zero_right_of_theta

/-- info: 'Stage3.zeroFreeRight_of_psiWeakTheta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_of_psiWeakTheta

/-- info: 'Stage3.zeroFreeRight_iff_psiWeakTheta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_iff_psiWeakTheta

/-- info: 'Stage3.RH_of_psiWeakTheta_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.RH_of_psiWeakTheta_half

/-- info: 'Stage3.zeroFreeRight_one_of_chebyshev' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_one_of_chebyshev

end Stage3
