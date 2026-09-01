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

/-- info: 'Stage3.completedZeta₀_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.completedZeta₀_conj

/-- info: 'Stage3.xi_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_conj

end Stage3
