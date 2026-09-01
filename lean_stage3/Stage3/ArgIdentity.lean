/-
ArgIdentity — slice 1: the entire completion `xi`, and its two symmetries.

The rectangle argument-principle identity (`ArgCrude.StmtArgIdentity`)
runs a contour whose border passes through `s = 0` and `s = 1`, exactly
where Mathlib's `completedRiemannZeta` has its poles. The fix is
algebra, not analysis: with `Λ = Λ₀ − 1/s − 1/(1−s)`
(`completedRiemannZeta_eq`),

    s(s−1)·Λ(s) = s(s−1)·Λ₀(s) − (s−1) + s = s(s−1)·Λ₀(s) + 1,

so `xi s := s(s−1)·Λ₀(s) + 1` is entire BY CONSTRUCTION, equals
`s(s−1)·Λ(s)` off `{0,1}`, and takes the value `1` at both former
poles. Slice 1 proves:

    differentiable_xi     entire
    xi_zero / xi_one      the values at the former poles
    xi_eq_completed       the factorised form off {0,1}
    xi_one_sub            the functional equation, from Λ₀'s
    completedZeta₀_conj   Λ₀(conj s) = conj (Λ₀ s), by the identity
                          theorem from the Euler-product region
    xi_conj               the reflection symmetry

The two symmetries are what fold the rectangle `[−1,2] × [0,T]` onto
the right-half path in slice 3.

Slice 2A adds the one classical fact the rectangle's bottom edge
needs and no library holds: `ζ(σ) < 0` for real `σ ∈ (0,1)` — hence
nonvanishing there. Route: upstream's `ZetaAltFormula`
(`ζ = 1 + 1/(s−1) − s·∫₁^∞ {u}·u^(−s−1)`) with the fract-integral
real and nonnegative at real `σ`, so `Re ζ(σ) ≤ σ/(σ−1) < 0`. No eta
function, no alternating series.
-/
import Mathlib
import PrimeNumberTheoremAnd.StrongPNT
import PrimeNumberTheoremAnd.RectangleArgumentPrinciple
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting

namespace Stage3

open Complex
open scoped ComplexConjugate

noncomputable section

/-- The entire completion: `xi s = s(s−1)Λ₀(s) + 1`. Away from `{0,1}`
this is `s(s−1)Λ(s)`; at `0` and `1` it is `1`. -/
def xi (s : ℂ) : ℂ := s * (s - 1) * completedRiemannZeta₀ s + 1

theorem differentiable_xi : Differentiable ℂ xi :=
  ((differentiable_id.mul (differentiable_id.sub_const 1)).mul
    differentiable_completedZeta₀).add_const 1

theorem xi_zero : xi 0 = 1 := by simp [xi]

theorem xi_one : xi 1 = 1 := by simp [xi]

/-- Off the two former poles, `xi` is the classical `s(s−1)Λ(s)`. -/
theorem xi_eq_completed {s : ℂ} (hs : s ≠ 0) (hs1 : s ≠ 1) :
    xi s = s * (s - 1) * completedRiemannZeta s := by
  have h1s : (1 : ℂ) - s ≠ 0 := sub_ne_zero.mpr (Ne.symm hs1)
  rw [xi, completedRiemannZeta_eq]
  field_simp
  ring

/-- The functional equation on `xi`, from `Λ₀`'s: pure algebra. -/
theorem xi_one_sub (s : ℂ) : xi (1 - s) = xi s := by
  rw [xi, xi, completedRiemannZeta₀_one_sub]
  ring

/-! ## Reflection: `Λ₀(conj s) = conj (Λ₀ s)`

Proved on the region `1 < Re s` from `ζ`'s own conjugation symmetry
(`riemannZeta_conj`) through `Λ = Γℝ · ζ`, then extended to all of `ℂ`
by the identity theorem, both sides being entire. -/

/-- `Γℝ` commutes with conjugation. -/
theorem gammaR_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s) := by
  rw [Gammaℝ_def, Gammaℝ_def, map_mul]
  have harg : (Real.pi : ℂ).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
    exact Ne.symm Real.pi_ne_zero
  congr 1
  · -- `π ^ (−conj s / 2) = conj (π ^ (−s/2))`
    have hexp : -conj s / 2 = conj (-s / 2) := by
      simp [map_div₀, Complex.conj_ofNat]
    calc (Real.pi : ℂ) ^ (-conj s / 2)
        = (Real.pi : ℂ) ^ conj (-s / 2) := by rw [hexp]
      _ = conj (Real.pi : ℂ) ^ conj (-s / 2) := by rw [Complex.conj_ofReal]
      _ = conj ((Real.pi : ℂ) ^ conj (conj (-s / 2))) :=
          Complex.conj_cpow _ _ harg
      _ = conj ((Real.pi : ℂ) ^ (-s / 2)) := by rw [Complex.conj_conj]
  · -- `Γ(conj s / 2) = conj (Γ(s/2))`
    have hdiv : conj s / 2 = conj (s / 2) := by
      simp [map_div₀, Complex.conj_ofNat]
    rw [hdiv, Complex.Gamma_conj]

/-- On `Re s > 1` the completed zeta factors as `Γℝ · ζ`. -/
theorem completed_eq_gammaR_mul_zeta {s : ℂ} (hre : 1 < s.re) :
    completedRiemannZeta s = Gammaℝ s * riemannZeta s := by
  have hs : s ≠ 0 := by
    intro h
    rw [h] at hre
    simp at hre
    linarith
  have hΓ : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos (by linarith)
  have h := riemannZeta_def_of_ne_zero hs
  rw [h]
  field_simp

/-- **`Λ₀` commutes with conjugation.** Both sides are entire; they
agree on the open half-plane `1 < Re s` through the Euler-product
region's `ζ`-symmetry; the identity theorem does the rest. -/
theorem completedZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) := by
  -- the reflected function
  set g : ℂ → ℂ := fun z => conj (completedRiemannZeta₀ (conj z)) with hg
  suffices h : ∀ z : ℂ, g z = completedRiemannZeta₀ z by
    have := h s
    rw [hg] at this
    simpa using congrArg conj this
  -- both entire
  have hgdiff : Differentiable ℂ g := by
    intro z
    have h := (differentiable_completedZeta₀ (conj z)).conj_conj
    rw [Complex.conj_conj] at h
    simpa [hg, Function.comp_def] using h
  have hganal : AnalyticOnNhd ℂ g Set.univ :=
    analyticOnNhd_univ_iff_differentiable.mpr hgdiff
  have hfanal : AnalyticOnNhd ℂ completedRiemannZeta₀ Set.univ :=
    analyticOnNhd_univ_iff_differentiable.mpr differentiable_completedZeta₀
  -- agreement on the open half-plane `1 < Re`
  have hopen : IsOpen {z : ℂ | 1 < z.re} := isOpen_lt continuous_const continuous_re
  have hagree : ∀ z ∈ {z : ℂ | 1 < z.re}, g z = completedRiemannZeta₀ z := by
    intro z hz
    have hzre : 1 < z.re := hz
    have hczre : 1 < (conj z).re := by rwa [Complex.conj_re]
    have hz0 : z ≠ 0 := by
      intro h; rw [h] at hzre; simp at hzre; linarith
    have hz1 : (1 : ℂ) - z ≠ 0 := by
      intro h
      have : z = 1 := by linear_combination -h
      rw [this] at hzre; simp at hzre
    have hcz0 : conj z ≠ 0 := by
      intro h
      apply hz0
      simpa using congrArg conj h
    have hcz1 : (1 : ℂ) - conj z ≠ 0 := by
      intro h
      apply hz1
      have := congrArg conj h
      simpa using this
    -- `Λ₀ = Λ + 1/s + 1/(1−s)` at both `z` and `conj z`
    have hL0z : completedRiemannZeta₀ z
        = completedRiemannZeta z + 1 / z + 1 / (1 - z) := by
      rw [completedRiemannZeta_eq]
      ring
    have hL0cz : completedRiemannZeta₀ (conj z)
        = completedRiemannZeta (conj z) + 1 / conj z + 1 / (1 - conj z) := by
      rw [completedRiemannZeta_eq]
      ring
    -- factor both through `Γℝ · ζ`
    have hfz : completedRiemannZeta z = Gammaℝ z * riemannZeta z :=
      completed_eq_gammaR_mul_zeta hzre
    have hfcz : completedRiemannZeta (conj z) = Gammaℝ (conj z) * riemannZeta (conj z) :=
      completed_eq_gammaR_mul_zeta hczre
    show conj (completedRiemannZeta₀ (conj z)) = completedRiemannZeta₀ z
    rw [hL0cz, hfcz, gammaR_conj, riemannZeta_conj, hL0z, hfz]
    rw [map_add, map_add, map_mul, Complex.conj_conj, Complex.conj_conj]
    congr 1
    · congr 1
      rw [map_div₀, map_one, Complex.conj_conj]
    · rw [map_div₀, map_one, map_sub, map_one, Complex.conj_conj]
  -- identity theorem on the connected `univ`, seeded at `2`
  have h2 : (2 : ℂ) ∈ {z : ℂ | 1 < z.re} := by
    simp only [Set.mem_setOf_eq]
    norm_num
  have hev : g =ᶠ[nhds (2 : ℂ)] completedRiemannZeta₀ :=
    Filter.eventuallyEq_of_mem (hopen.mem_nhds h2) hagree
  intro z
  exact AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hganal hfanal
    isPreconnected_univ (Set.mem_univ 2) hev (Set.mem_univ z)

/-- **The reflection symmetry on `xi`.** -/
theorem xi_conj (s : ℂ) : xi (conj s) = conj (xi s) := by
  rw [xi, xi, completedZeta₀_conj]
  simp only [map_add, map_mul, map_sub, map_one]

/-! ## Slice 2A: `ζ(σ) < 0` on the real interval `(0,1)` -/

open MeasureTheory in
/-- **The real zeta is strictly negative on `(0,1)`.** From
`ZetaAltFormula`: `ζ(σ) = 1 + 1/(σ−1) − σ·J` with `J ≥ 0` real, and
`1 + 1/(σ−1) = σ/(σ−1) < 0`. -/
theorem zeta_re_neg_of_real_mem_Ioo {σ : ℝ} (h0 : 0 < σ) (h1 : σ < 1) :
    (riemannZeta (σ : ℂ)).re < 0 := by
  have hre : (0 : ℝ) < ((σ : ℂ)).re := by simpa using h0
  have hne1 : (σ : ℂ) ≠ 1 := by
    intro h
    have : σ = 1 := by exact_mod_cast h
    linarith
  rw [ZetaAltFormula hre hne1]
  unfold riemannZeta1
  -- the integral is a coerced nonnegative real
  set J : ℝ := ∫ u in Set.Ioi (1 : ℝ), Int.fract u * u ^ (-σ - 1) with hJdef
  have hcoe : (∫ u in Set.Ioi (1 : ℝ), (Int.fract u : ℝ) * (u : ℂ) ^ (-(σ : ℂ) - 1))
      = (J : ℂ) := by
    have hcongr : ∀ u ∈ Set.Ioi (1 : ℝ),
        (Int.fract u : ℝ) * (u : ℂ) ^ (-(σ : ℂ) - 1)
          = ((Int.fract u * u ^ (-σ - 1) : ℝ) : ℂ) := by
      intro u hu
      have hu0 : (0 : ℝ) ≤ u := by
        have := Set.mem_Ioi.mp hu
        linarith
      have hexp : -(σ : ℂ) - 1 = ((-σ - 1 : ℝ) : ℂ) := by push_cast; ring
      rw [hexp, ← Complex.ofReal_cpow hu0, ← Complex.ofReal_mul]
    rw [setIntegral_congr_fun measurableSet_Ioi hcongr, integral_complex_ofReal, hJdef]
  have hJ0 : 0 ≤ J := by
    rw [hJdef]
    refine setIntegral_nonneg measurableSet_Ioi fun u hu => ?_
    have hu0 : (0 : ℝ) ≤ u := by
      have := Set.mem_Ioi.mp hu
      linarith
    exact mul_nonneg (Int.fract_nonneg u) (Real.rpow_nonneg hu0 _)
  rw [hcoe]
  -- everything is now the real part of a coerced real
  have hσ1 : σ - 1 ≠ 0 := by intro h; linarith
  have hval : (1 : ℂ) + 1 / ((σ : ℂ) - 1) - (σ : ℂ) * (J : ℂ)
      = ((1 + 1 / (σ - 1) - σ * J : ℝ) : ℂ) := by
    push_cast
    ring
  rw [hval, Complex.ofReal_re]
  have hmain : 1 + 1 / (σ - 1) = σ / (σ - 1) := by
    field_simp
    ring
  rw [hmain]
  have hneg : σ / (σ - 1) < 0 := div_neg_of_pos_of_neg h0 (by linarith)
  nlinarith

/-- Hence `ζ` does not vanish on the real interval `(0,1)`. -/
theorem zeta_ne_zero_of_real_mem_Ioo {σ : ℝ} (h0 : 0 < σ) (h1 : σ < 1) :
    riemannZeta (σ : ℂ) ≠ 0 := by
  intro h
  have := zeta_re_neg_of_real_mem_Ioo h0 h1
  rw [h] at this
  simp at this

/-! ## Slice 2B: the zero set of `xi` is exactly ζ's nontrivial zeros,
with matching orders -/

/-- `Λ = Γℝ · ζ` on the whole right half-plane `Re s > 0`. -/
theorem completed_eq_gammaR_mul_zeta' {s : ℂ} (h0 : 0 < s.re) :
    completedRiemannZeta s = Gammaℝ s * riemannZeta s := by
  have hs : s ≠ 0 := by
    intro h; rw [h] at h0; simp at h0
  have hΓ : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos h0
  rw [riemannZeta_def_of_ne_zero hs]
  field_simp

/-- The factorised form of `xi` on the right half-plane. -/
theorem xi_eq_prod {s : ℂ} (h0 : 0 < s.re) (hs1 : s ≠ 1) :
    xi s = s * (s - 1) * Gammaℝ s * riemannZeta s := by
  have hs : s ≠ 0 := by
    intro h; rw [h] at h0; simp at h0
  rw [xi_eq_completed hs hs1, completed_eq_gammaR_mul_zeta' h0]
  ring

/-- `xi` does not vanish on `Re s ≥ 1`. -/
theorem xi_ne_zero_of_one_le_re {s : ℂ} (h : 1 ≤ s.re) : xi s ≠ 0 := by
  by_cases hs1 : s = 1
  · rw [hs1, xi_one]; exact one_ne_zero
  · rw [xi_eq_prod (by linarith) hs1]
    have hs : s ≠ 0 := by
      intro hh; rw [hh] at h; simp at h; linarith
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero hs (sub_ne_zero.mpr hs1))
      (Gammaℝ_ne_zero_of_re_pos (by linarith))) (riemannZeta_ne_zero_of_one_le_re h)

/-- `xi` does not vanish on `Re s ≤ 0`, by the functional equation. -/
theorem xi_ne_zero_of_re_nonpos {s : ℂ} (h : s.re ≤ 0) : xi s ≠ 0 := by
  rw [← xi_one_sub]
  apply xi_ne_zero_of_one_le_re
  rw [Complex.sub_re, Complex.one_re]
  linarith

/-- `xi` does not vanish anywhere on the real axis — the rectangle's
bottom edge. The interval `(0,1)` is slice 2A's negativity; the rest is
the two half-plane lemmas and the values at `0` and `1`. -/
theorem xi_ne_zero_of_real (σ : ℝ) : xi (σ : ℂ) ≠ 0 := by
  rcases le_or_gt σ 0 with h | h
  · exact xi_ne_zero_of_re_nonpos (by simpa using h)
  rcases le_or_gt 1 σ with h1 | h1
  · exact xi_ne_zero_of_one_le_re (by simpa using h1)
  · have hs1 : (σ : ℂ) ≠ 1 := by
      intro hh
      have : σ = 1 := by exact_mod_cast hh
      linarith
    have hs : (σ : ℂ) ≠ 0 := by
      intro hh
      have : σ = 0 := by exact_mod_cast hh
      linarith
    rw [xi_eq_prod (by simpa using h) hs1]
    exact mul_ne_zero (mul_ne_zero (mul_ne_zero hs (sub_ne_zero.mpr hs1))
      (Gammaℝ_ne_zero_of_re_pos (by simpa using h)))
      (zeta_ne_zero_of_real_mem_Ioo h h1)

/-- **The zero set.** `xi` vanishes exactly at ζ's nontrivial zeros. -/
theorem xi_eq_zero_iff {s : ℂ} :
    xi s = 0 ↔ riemannZeta s = 0 ∧ 0 < s.re ∧ s.re < 1 := by
  constructor
  · intro h
    by_cases h0 : 0 < s.re
    · by_cases h1 : s.re < 1
      · have hs1 : s ≠ 1 := by
          intro hh; rw [hh] at h1; simp at h1
        rw [xi_eq_prod h0 hs1] at h
        have hs : s ≠ 0 := by
          intro hh; rw [hh] at h0; simp at h0
        rcases mul_eq_zero.mp h with h' | hζ
        · exfalso
          rcases mul_eq_zero.mp h' with h'' | hΓ
          · rcases mul_eq_zero.mp h'' with h3 | h3
            · exact hs h3
            · exact (sub_ne_zero.mpr hs1) h3
          · exact Gammaℝ_ne_zero_of_re_pos h0 hΓ
        · exact ⟨hζ, h0, h1⟩
      · exact absurd h (xi_ne_zero_of_one_le_re (by linarith))
    · exact absurd h (xi_ne_zero_of_re_nonpos (by linarith))
  · rintro ⟨hζ, h0, h1⟩
    have hs1 : s ≠ 1 := by
      intro hh; rw [hh] at h1; simp at h1
    rw [xi_eq_prod h0 hs1, hζ, mul_zero]

/-- **Orders match.** At a strip point, `xi` and `ζ` have the same
meromorphic order: `ζ = B · xi` near the point with `B` analytic and
nonvanishing there. -/
theorem meromorphicOrderAt_xi_eq_zeta {ρ : ℂ} (h0 : 0 < ρ.re) (h1 : ρ.re < 1) :
    meromorphicOrderAt xi ρ = meromorphicOrderAt riemannZeta ρ := by
  have hρ1 : ρ ≠ 1 := by
    intro hh; rw [hh] at h1; simp at h1
  have hρ0 : ρ ≠ 0 := by
    intro hh; rw [hh] at h0; simp at h0
  -- the correcting factor
  set B : ℂ → ℂ := fun s => (s * (s - 1))⁻¹ * (Gammaℝ s)⁻¹ with hB
  have hBanal : AnalyticAt ℂ B ρ := by
    refine AnalyticAt.mul ?_ ?_
    · exact ((analyticAt_id.mul (analyticAt_id.sub analyticAt_const)).inv
        (mul_ne_zero hρ0 (sub_ne_zero.mpr hρ1)))
    · exact (analyticOnNhd_univ_iff_differentiable.mpr differentiable_Gammaℝ_inv)
        ρ (Set.mem_univ ρ)
  have hBne : B ρ ≠ 0 := by
    rw [hB]
    exact mul_ne_zero (inv_ne_zero (mul_ne_zero hρ0 (sub_ne_zero.mpr hρ1)))
      (inv_ne_zero (Gammaℝ_ne_zero_of_re_pos h0))
  -- ζ agrees with B · xi on a neighbourhood
  have hUopen : IsOpen {s : ℂ | 0 < s.re ∧ s ≠ 1} :=
    (isOpen_lt continuous_const continuous_re).inter isOpen_compl_singleton
  have hmem : ρ ∈ {s : ℂ | 0 < s.re ∧ s ≠ 1} := ⟨h0, hρ1⟩
  have hagree : ∀ s ∈ {s : ℂ | 0 < s.re ∧ s ≠ 1}, riemannZeta s = (B * xi) s := by
    intro s hs
    obtain ⟨hs0, hs1⟩ := hs
    have hsne : s ≠ 0 := by
      intro hh; rw [hh] at hs0; simp at hs0
    have hΓ : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos hs0
    show riemannZeta s = (s * (s - 1))⁻¹ * (Gammaℝ s)⁻¹ * xi s
    rw [xi_eq_prod hs0 hs1]
    field_simp
  have hev : riemannZeta =ᶠ[nhds ρ] (B * xi) :=
    Filter.eventuallyEq_of_mem (hUopen.mem_nhds hmem) hagree
  -- assemble the order computation
  have hxiMer : MeromorphicAt xi ρ :=
    ((analyticOnNhd_univ_iff_differentiable.mpr differentiable_xi) ρ
      (Set.mem_univ ρ)).meromorphicAt
  have hBMer : MeromorphicAt B ρ := hBanal.meromorphicAt
  have hBzero : meromorphicOrderAt B ρ = 0 := by
    rw [hBanal.meromorphicOrderAt_eq, hBanal.analyticOrderAt_eq_zero.mpr hBne]
    rfl
  calc meromorphicOrderAt xi ρ
      = meromorphicOrderAt B ρ + meromorphicOrderAt xi ρ := by rw [hBzero, zero_add]
    _ = meromorphicOrderAt (B * xi) ρ := (meromorphicOrderAt_mul hBMer hxiMer).symm
    _ = meromorphicOrderAt riemannZeta ρ :=
        (meromorphicOrderAt_congr (hev.filter_mono nhdsWithin_le_nhds)).symm

/-! ## Slice 2C: the rectangle contour integral IS the zero count

`RectangleIntegral' (logDeriv xi)` over `[−1,2] × [0,T]` equals
`riemannZeta.N T` at any good height (no zero at `Im = T`), by
upstream's `rectangleIntegral_logDeriv_eq_sum_meromorphicOrderAt`
plus the identification of `xi`'s divisor support with
`zeroes_rect univ (Ioo 0 T)`. -/

theorem xi_analyticAt (s : ℂ) : AnalyticAt ℂ xi s :=
  (analyticOnNhd_univ_iff_differentiable.mpr differentiable_xi) s (Set.mem_univ s)

/-- `xi` is nowhere locally zero: its order is finite everywhere,
because `xi 0 = 1` and `ℂ` is connected. -/
theorem xi_meromorphicOrderAt_ne_top (p : ℂ) : meromorphicOrderAt xi p ≠ ⊤ := by
  intro h
  rw [(xi_analyticAt p).meromorphicOrderAt_eq] at h
  have htop : analyticOrderAt xi p = ⊤ := by
    cases hn : analyticOrderAt xi p
    · rfl
    · rw [hn] at h; simp [ENat.map_coe] at h
  have hev : xi =ᶠ[nhds p] 0 := analyticOrderAt_eq_top.mp htop
  have hzero : Set.EqOn xi 0 Set.univ :=
    AnalyticOnNhd.eqOn_zero_of_preconnected_of_eventuallyEq_zero
      (analyticOnNhd_univ_iff_differentiable.mpr differentiable_xi)
      isPreconnected_univ (Set.mem_univ p) hev
  have := hzero (Set.mem_univ 0)
  rw [xi_zero] at this
  exact one_ne_zero this

theorem logDeriv_xi_meromorphicAt (s : ℂ) : MeromorphicAt (logDeriv xi) s := by
  have hd : AnalyticAt ℂ (deriv xi) s :=
    ((analyticOnNhd_univ_iff_differentiable.mpr differentiable_xi).deriv) s (Set.mem_univ s)
  exact hd.meromorphicAt.div (xi_analyticAt s).meromorphicAt

/-- **`N` as a finite sum** over the (finite) set of zeros with
imaginary part in `(0, T)`. -/
theorem N_eq_sum (T : ℝ) :
    riemannZeta.N T
      = ∑ ρ ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset,
          (riemannZeta.order ρ : ℝ) := by
  have hfin := Kadiri.zeroes_rect_univ_positive_height_finite T
  haveI : Fintype (riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T)) :=
    hfin.fintype
  rw [riemannZeta.N, riemannZeta.zeroes_sum, tsum_fintype]
  refine Finset.sum_bij (fun ρ _ => (ρ : ℂ)) ?_ ?_ ?_ ?_
  · intro ρ _
    exact hfin.mem_toFinset.mpr ρ.2
  · intro a _ b _ hab
    exact Subtype.ext hab
  · intro z hz
    exact ⟨⟨z, hfin.mem_toFinset.mp hz⟩, Finset.mem_univ _, rfl⟩
  · intro ρ _
    simp

/-- **The divisor support of `xi` on the rectangle is exactly the zeros
counted by `N T`**, at a good height. -/
theorem xi_divisor_support_eq {T : ℝ} (hT : 2 ≤ T)
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T)
    (hf : MeromorphicOn xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))) :
    (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))).support
      = riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T) := by
  have hzre : ((-1 : ℂ)).re = -1 := by simp
  have hzim : ((-1 : ℂ)).im = 0 := by simp
  have hwre : ((2 : ℂ) + Complex.I * (T : ℂ)).re = 2 := by simp
  have hwim : ((2 : ℂ) + Complex.I * (T : ℂ)).im = T := by simp
  have hRect : Rectangle (-1 : ℂ) (2 + Complex.I * T)
      = Set.Icc (-1 : ℝ) 2 ×ℂ Set.Icc (0 : ℝ) T := by
    rw [Rectangle, hzre, hzim, hwre, hwim,
      Set.uIcc_of_le (by norm_num : (-1 : ℝ) ≤ 2),
      Set.uIcc_of_le (by linarith : (0 : ℝ) ≤ T)]
  ext p
  constructor
  · intro hp
    have hpR : p ∈ Rectangle (-1 : ℂ) (2 + Complex.I * T) :=
      (MeromorphicOn.divisor xi _).supportWithinDomain hp
    have hdvne : (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))) p ≠ 0 :=
      Function.mem_support.mp hp
    rw [MeromorphicOn.divisor_apply hf hpR] at hdvne
    -- the order is nonzero, so `xi p = 0`
    have horder : meromorphicOrderAt xi p ≠ 0 := by
      intro h; rw [h] at hdvne; simp at hdvne
    have hxip : xi p = 0 := by
      by_contra hne
      exact horder (by
        rw [(xi_analyticAt p).meromorphicOrderAt_eq,
          (xi_analyticAt p).analyticOrderAt_eq_zero.mpr hne]
        rfl)
    obtain ⟨hζ, h0, h1⟩ := xi_eq_zero_iff.mp hxip
    -- position: interior of the height range
    rw [hRect] at hpR
    obtain ⟨hpre, hpim⟩ := Complex.mem_reProdIm.mp hpR
    have him0 : p.im ≠ 0 := by
      intro h
      have hpreal : p = ((p.re : ℝ) : ℂ) := Complex.ext rfl (by simp [h])
      rw [hpreal] at hxip
      exact xi_ne_zero_of_real p.re hxip
    have himT : p.im ≠ T := hgood p hζ h0
    refine ⟨Set.mem_univ _, ⟨lt_of_le_of_ne hpim.1 (Ne.symm him0),
      lt_of_le_of_ne hpim.2 himT⟩, hζ⟩
  · intro hp
    obtain ⟨-, him, hζ⟩ := hp
    have hre : p.re ∈ Set.Ioo (0 : ℝ) 1 :=
      Kadiri.positiveHeightZero_re_mem_Ioo ⟨p, ⟨Set.mem_univ _, him, hζ⟩⟩
    have hp1 : p ≠ 1 := by
      intro h; rw [h] at hre; simp at hre
    have hpR : p ∈ Rectangle (-1 : ℂ) (2 + Complex.I * T) := by
      rw [hRect]
      exact Complex.mem_reProdIm.mpr
        ⟨⟨by linarith [hre.1], by linarith [hre.2]⟩,
         ⟨le_of_lt him.1, le_of_lt him.2⟩⟩
    rw [Function.mem_support, MeromorphicOn.divisor_apply hf hpR]
    -- the order of `ζ` at `p` is finite, nonzero
    have heq := meromorphicOrderAt_xi_eq_zeta hre.1 hre.2
    have hζanal : AnalyticAt ℂ riemannZeta p := analyticAt_riemannZeta hp1
    have hnetop : meromorphicOrderAt riemannZeta p ≠ ⊤ := by
      rw [← heq]; exact xi_meromorphicOrderAt_ne_top p
    have hnezero : meromorphicOrderAt riemannZeta p ≠ 0 := by
      rw [hζanal.meromorphicOrderAt_eq]
      intro h
      have h0 : analyticOrderAt riemannZeta p = 0 := by
        cases hn : analyticOrderAt riemannZeta p
        · rw [hn] at h; simp [ENat.map_top] at h
        · rw [hn] at h
          rw [ENat.map_coe] at h
          norm_cast at h
          simp [h]
      rw [analyticOrderAt_eq_zero] at h0
      rcases h0 with h' | h'
      · exact h' hζanal
      · exact h' hζ
    rw [← heq] at hnetop hnezero
    obtain ⟨n, hn⟩ := WithTop.ne_top_iff_exists.mp hnetop
    rw [← hn]
    intro hcontra
    apply hnezero
    rw [← hn]
    have : n = 0 := by exact_mod_cast hcontra
    rw [this]
    rfl

/-- **THE COUNT BRIDGE.** At a good height, the normalised rectangle
integral of `logDeriv xi` over `[−1,2] × [0,T]` is the zero count. -/
theorem rectangleIntegral_logDeriv_xi_eq_N {T : ℝ} (hT : 2 ≤ T)
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T) :
    RectangleIntegral' (logDeriv xi) (-1 : ℂ) (2 + Complex.I * T)
      = ((riemannZeta.N T : ℝ) : ℂ) := by
  have hzre : ((-1 : ℂ)).re = -1 := by simp
  have hzim : ((-1 : ℂ)).im = 0 := by simp
  have hwre : ((2 : ℂ) + Complex.I * (T : ℂ)).re = 2 := by simp
  have hwim : ((2 : ℂ) + Complex.I * (T : ℂ)).im = T := by simp
  have hf : MeromorphicOn xi (Rectangle (-1 : ℂ) (2 + Complex.I * T)) :=
    fun s _ => (xi_analyticAt s).meromorphicAt
  have hlog : MeromorphicOn (logDeriv xi) (Rectangle (-1 : ℂ) (2 + Complex.I * T)) :=
    fun s _ => logDeriv_xi_meromorphicAt s
  have hfinord : ∀ p ∈ Rectangle (-1 : ℂ) (2 + Complex.I * T),
      meromorphicOrderAt xi p ≠ ⊤ := fun p _ => xi_meromorphicOrderAt_ne_top p
  have hsupp := xi_divisor_support_eq hT hgood hf
  -- border disjointness: the support has `Re ∈ (0,1)`, `Im ∈ (0,T)`;
  -- every border point violates one of the four
  have hnob : Disjoint (RectangleBorder (-1 : ℂ) (2 + Complex.I * T))
      (MeromorphicOn.divisor xi (Rectangle (-1 : ℂ) (2 + Complex.I * T))).support := by
    rw [Set.disjoint_right]
    intro p hpS hpB
    rw [hsupp] at hpS
    obtain ⟨-, him, hζ⟩ := hpS
    have hre : p.re ∈ Set.Ioo (0 : ℝ) 1 :=
      Kadiri.positiveHeightZero_re_mem_Ioo ⟨p, ⟨Set.mem_univ _, him, hζ⟩⟩
    rw [RectangleBorder, hzre, hzim, hwre, hwim] at hpB
    rcases hpB with ((h | h) | h) | h
    · exact absurd (Complex.mem_reProdIm.mp h).2 (by
        simp only [Set.mem_singleton_iff]
        exact ne_of_gt him.1)
    · exact absurd (Complex.mem_reProdIm.mp h).1 (by
        simp only [Set.mem_singleton_iff]
        intro hh
        rw [hh] at hre
        exact absurd hre.1 (by norm_num))
    · exact absurd (Complex.mem_reProdIm.mp h).2 (by
        simp only [Set.mem_singleton_iff]
        exact ne_of_lt him.2)
    · exact absurd (Complex.mem_reProdIm.mp h).1 (by
        simp only [Set.mem_singleton_iff]
        intro hh
        rw [hh] at hre
        exact absurd hre.2 (by norm_num))
  have hmain := rectangleIntegral_logDeriv_eq_sum_meromorphicOrderAt
    (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; linarith)
    hf hlog hfinord hnob
  rw [hmain, N_eq_sum]
  -- the two finsets agree, and so do the values
  have hsets : (divisor_support_rectangle_finite xi (-1 : ℂ) (2 + Complex.I * T)).toFinset
      = (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset := by
    ext p
    rw [Set.Finite.mem_toFinset, Set.Finite.mem_toFinset, hsupp]
  rw [hsets]
  rw [Complex.ofReal_sum]
  refine Finset.sum_congr rfl ?_
  intro p hp
  have hpmem : p ∈ riemannZeta.zeroes_rect (Set.univ : Set ℝ) (Set.Ioo 0 T) :=
    (Kadiri.zeroes_rect_univ_positive_height_finite T).mem_toFinset.mp hp
  obtain ⟨-, him, hζ⟩ := hpmem
  have hre : p.re ∈ Set.Ioo (0 : ℝ) 1 :=
    Kadiri.positiveHeightZero_re_mem_Ioo ⟨p, ⟨Set.mem_univ _, him, hζ⟩⟩
  have hpR : p ∈ Rectangle (-1 : ℂ) (2 + Complex.I * T) := by
    rw [Rectangle, hzre, hzim, hwre, hwim,
      Set.uIcc_of_le (by norm_num : (-1 : ℝ) ≤ 2),
      Set.uIcc_of_le (by linarith : (0 : ℝ) ≤ T)]
    exact Complex.mem_reProdIm.mpr
      ⟨⟨by linarith [hre.1], by linarith [hre.2]⟩,
       ⟨le_of_lt him.1, le_of_lt him.2⟩⟩
  rw [MeromorphicOn.divisor_apply hf hpR, meromorphicOrderAt_xi_eq_zeta hre.1 hre.2]
  rw [riemannZeta.order]
  push_cast
  rfl

end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.differentiable_xi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.differentiable_xi

/-- info: 'Stage3.xi_eq_completed' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_eq_completed

/-- info: 'Stage3.xi_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_one_sub

/-- info: 'Stage3.zeta_re_neg_of_real_mem_Ioo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_re_neg_of_real_mem_Ioo

/-- info: 'Stage3.zeta_ne_zero_of_real_mem_Ioo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_ne_zero_of_real_mem_Ioo

/-- info: 'Stage3.xi_ne_zero_of_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_ne_zero_of_real

/-- info: 'Stage3.xi_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_eq_zero_iff

/-- info: 'Stage3.meromorphicOrderAt_xi_eq_zeta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.meromorphicOrderAt_xi_eq_zeta

/-- info: 'Stage3.xi_meromorphicOrderAt_ne_top' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_meromorphicOrderAt_ne_top

/-- info: 'Stage3.N_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.N_eq_sum

/-- info: 'Stage3.xi_divisor_support_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_divisor_support_eq

/-- info: 'Stage3.rectangleIntegral_logDeriv_xi_eq_N' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rectangleIntegral_logDeriv_xi_eq_N

/-- info: 'Stage3.completedZeta₀_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.completedZeta₀_conj

/-- info: 'Stage3.xi_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_conj

end Stage3
