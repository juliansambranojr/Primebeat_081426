/-
ArgIdentity — StmtArgIdentity discharged, and the contour machinery
the remaining bound will need.

THE ENTIRE COMPLETION. The rectangle argument-principle identity runs
a contour whose border passes through `s = 0` and `s = 1`, exactly
where Mathlib's `completedRiemannZeta` has its poles. The fix is
algebra: with `Λ = Λ₀ − 1/s − 1/(1−s)` (`completedRiemannZeta_eq`),
`s(s−1)·Λ(s) = s(s−1)·Λ₀(s) + 1`, so

    xi s := s(s−1)·Λ₀(s) + 1

is entire BY CONSTRUCTION, equals `s(s−1)Λ(s)` off `{0,1}`, and takes
the value `1` at both former poles.

WHAT IS PROVED, in build order:

  slice 1   differentiable_xi, xi_eq_completed, xi_one_sub (the
            functional equation from Λ₀'s), completedZeta₀_conj (the
            identity theorem, seeded on `Re > 1` through `Γℝ·ζ` and
            `riemannZeta_conj`), xi_conj
  slice 2A  zeta_re_neg_of_real_mem_Ioo: `Re ζ(σ) ≤ σ/(σ−1) < 0` for
            real `σ ∈ (0,1)`, from upstream `ZetaAltFormula` with the
            fract-integral shown real and nonnegative. No eta function.
            This is the bottom edge's guard, and no library held it.
  slice 2B  xi_eq_zero_iff (xi vanishes exactly at ζ's strip zeros),
            meromorphicOrderAt_xi_eq_zeta (orders match, via
            `ζ = B·xi` with `B` analytic nonvanishing)
  slice 2C  rectangleIntegral_logDeriv_xi_eq_N: at a good height, the
            normalised rectangle integral over `[−1,2] × [0,T]` IS
            `riemannZeta.N T` — upstream's RectangleArgumentPrinciple,
            with the divisor support identified and every border
            cleared by 2A/2B
  slice 3   pi_mul_N_eq — THE FOLD. The two symmetries collapse the
            four edges onto the right-half path: the bottom edge is
            odd about `1/2` and cancels itself, the left edge and the
            top-left half fold onto their right partners. Result:
            `π·N T = Re W − Im U`.
  slice 4   logDeriv_xi_split: on `{Re > 0, s ≠ 1, ζ ≠ 0}` the log
            derivative splits into `1/s + 1/(s−1) + logDeriv Γℝ +
            logDeriv ζ`, with `logDeriv Γℝ = −(log π)/2 + ψ(s/2)/2`
            (Mathlib's `digamma` IS `logDeriv Gamma`, so the link to
            `Stirling.phasePoint` is definitional)
  slice 5a  the two FTC evaluations, and arg_sum_eq_pi — the two
            boundary arguments of the elementary factor sum to exactly
            `π`, the two arcsines sharing a norm and cancelling by
            oddness. This is where the `+1` is born.
  slice 5b  argS, stmtArgIdentity_holds, rvM_of_sFromLocal

HONEST STATUS OF THE LEAF. `argS T := N T − (phaseTheta T/π + 1)` is
the classical `S(T)`, defined exactly as the literature defines it, so
`stmtArgIdentity_holds : StmtArgIdentity phaseTheta argS` is true by
construction and carries no analytic content on its own. That is the
correct shape: in Backlund's argument the identity IS a definition
once the continuous phase is fixed, and every ounce of analysis lives
in the BOUND on `S`. What slices 1–5a buy is the machinery that bound
needs — the entire `xi`, its two symmetries, the count bridge, the
fold, and the four-term split — none of which existed before.

WHAT REMAINS: `StmtSFromLocal argS zetaLocalCount a b`, i.e.
`|argS T| ≤ a·cnt T + b`. O77 measured `|S T| ≤ 0.462·cnt T + 0.508`
on a `T`-grid to 900 (`results/leaf_instantiation.json`, entry 156).
`rvM_of_sFromLocal` below shows that bound ALONE now delivers the full
`Riemann_vonMangoldt_bound (97 + 15a) 0 (98 + 73a + b)`, since the
Stirling half (entry 140) and the Jensen count (entry 156) are already
theorems. Entry 130's budget accepts it with room.

Consumes: Mathlib; upstream `RectangleArgumentPrinciple`, `StrongPNT`
(`ZetaAltFormula`), `ZetaConj` (`deriv_conj_conj'`,
`intervalIntegral_conj`), `KadiriZeroCounting` (both lemmas probed
sorry-free at the pin, 2026-09-01); Stage3 `Stirling`, `ArgCrude`,
`JensenCount`. The weld caveat from Stage3.lean applies to composition
with the bench.
-/
import Mathlib
import PrimeNumberTheoremAnd.StrongPNT
import PrimeNumberTheoremAnd.RectangleArgumentPrinciple
import PrimeNumberTheoremAnd.IEANTN.KadiriZeroCounting
import Stage3.Stirling
import Stage3.ArgCrude
import Stage3.JensenCount

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

/-! ## Slice 3: THE FOLD

The two symmetries of `xi` collapse the four edges of the rectangle
onto the right-half path `L : 2 → 2+iT → 1/2+iT`:

  * `logDeriv xi (1−s) = −logDeriv xi s`  (functional equation)
  * `logDeriv xi (conj s) = conj (logDeriv xi s)`  (reflection)

The bottom edge cancels itself around `1/2`; the left edge folds onto
the right; the top edge folds onto its right half. What survives is
`π·N T = Re W − Im U`, with `W` the right-edge integral and `U` the
top-right-half integral. -/

/-- The functional equation on the logarithmic derivative. Holds
everywhere — at zeros of `xi` both sides are matching junk. -/
theorem logDeriv_xi_one_sub (s : ℂ) : logDeriv xi (1 - s) = -logDeriv xi s := by
  have hderiv : deriv xi s = -deriv xi (1 - s) := by
    have hx : HasDerivAt xi (deriv xi (1 - s)) (1 - s) :=
      (differentiable_xi (1 - s)).hasDerivAt
    have haff : HasDerivAt (fun z : ℂ => 1 - z) (-1 : ℂ) s := by
      simpa using (hasDerivAt_id s).const_sub 1
    have h1 : HasDerivAt (fun z : ℂ => xi (1 - z)) (deriv xi (1 - s) * -1) s := by
      have := hx.comp s haff
      simpa [Function.comp_def] using this
    rw [funext xi_one_sub] at h1
    rw [h1.deriv]
    ring
  rw [logDeriv_apply, logDeriv_apply, xi_one_sub, hderiv]
  ring

/-- The reflection symmetry on the logarithmic derivative. -/
theorem logDeriv_xi_conj (s : ℂ) : logDeriv xi (conj s) = conj (logDeriv xi s) := by
  have hderiv : deriv xi (conj s) = conj (deriv xi s) := by
    have h1 := deriv_conj_conj' xi s
    have hfun : (fun z : ℂ => conj (xi (conj z))) = xi := by
      funext z
      rw [xi_conj, Complex.conj_conj]
    rw [hfun] at h1
    exact h1
  rw [logDeriv_apply, logDeriv_apply, hderiv, xi_conj, map_div₀]

/-- `logDeriv xi` is continuous wherever `xi` does not vanish. -/
theorem logDeriv_xi_continuousAt {p : ℂ} (hp : xi p ≠ 0) :
    ContinuousAt (logDeriv xi) p := by
  have hd : ContinuousAt (deriv xi) p :=
    (((analyticOnNhd_univ_iff_differentiable.mpr differentiable_xi).deriv) p
      (Set.mem_univ p)).continuousAt
  exact hd.div (xi_analyticAt p).continuousAt hp

/-- `xi` does not vanish anywhere on a good-height top edge. -/
theorem xi_ne_zero_on_good_top {T : ℝ}
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T) (_hT : 0 < T)
    (x : ℝ) : xi ((x : ℂ) + T * Complex.I) ≠ 0 := by
  intro h
  obtain ⟨hζ, h0, -⟩ := xi_eq_zero_iff.mp h
  have him : ((x : ℂ) + T * Complex.I).im = T := by simp
  exact hgood _ hζ h0 him

/-- **THE FOLD.** At a good height, `π · N T = Re W − Im U`, where `W`
is the right-edge integral and `U` the top-right-half integral of
`logDeriv xi`. The bottom edge cancels itself around `1/2`; the left
edge and the top-left half fold onto their right partners through the
two symmetries. -/
theorem pi_mul_N_eq {T : ℝ} (hT : 2 ≤ T)
    (hgood : ∀ ρ : ℂ, riemannZeta ρ = 0 → 0 < ρ.re → ρ.im ≠ T) :
    Real.pi * riemannZeta.N T
      = (∫ t in (0:ℝ)..T, logDeriv xi (2 + (t : ℂ) * Complex.I)).re
        - (∫ x in (1/2:ℝ)..2, logDeriv xi ((x : ℂ) + T * Complex.I)).im := by
  have hTpos : (0 : ℝ) < T := by linarith
  set F : ℂ → ℂ := logDeriv xi with hF
  set W : ℂ := ∫ t in (0:ℝ)..T, F (2 + (t : ℂ) * Complex.I) with hW
  set U : ℂ := ∫ x in (1/2:ℝ)..2, F ((x : ℂ) + T * Complex.I) with hU
  -- continuity of the two edge integrands, and of the bottom edge
  have hcont_of_ne : ∀ (g : ℝ → ℂ), Continuous g → (∀ x, xi (g x) ≠ 0) →
      Continuous fun x => F (g x) := by
    intro g hg hne
    rw [continuous_iff_continuousAt]
    intro x
    exact (logDeriv_xi_continuousAt (hne x)).comp hg.continuousAt
  have hcont_top : Continuous fun x : ℝ => F ((x : ℂ) + T * Complex.I) :=
    hcont_of_ne _ (by continuity) (fun x => xi_ne_zero_on_good_top hgood hTpos x)
  have hcont_bot : Continuous fun x : ℝ => F ((x : ℂ) + (0 : ℝ) * Complex.I) := by
    refine hcont_of_ne _ (by continuity) (fun x => ?_)
    have : ((x : ℂ) + (0 : ℝ) * Complex.I) = (x : ℂ) := by push_cast; ring
    rw [this]
    exact xi_ne_zero_of_real x
  -- the un-normalised rectangle integral equals `2πi · N`
  have hrect : RectangleIntegral F (-1 : ℂ) (2 + Complex.I * T)
      = (2 * Real.pi * Complex.I) * ((riemannZeta.N T : ℝ) : ℂ) := by
    have h' := rectangleIntegral_logDeriv_xi_eq_N hT hgood
    rw [RectangleIntegral'] at h'
    have h2πI : (2 * (Real.pi : ℂ) * Complex.I) ≠ 0 := by
      simp [Real.pi_ne_zero, Complex.I_ne_zero]
    rw [smul_eq_mul] at h'
    field_simp at h'
    linear_combination h'
  -- unfold the rectangle into its four edges
  have hzre : ((-1 : ℂ)).re = -1 := by simp
  have hzim : ((-1 : ℂ)).im = 0 := by simp
  have hwre : ((2 : ℂ) + Complex.I * (T : ℂ)).re = 2 := by simp
  have hwim : ((2 : ℂ) + Complex.I * (T : ℂ)).im = T := by simp
  rw [RectangleIntegral, hzre, hzim, hwre, hwim] at hrect
  -- BOTTOM: the odd symmetry about `1/2` kills it
  have hbot : HIntegral F (-1) 2 0 = 0 := by
    rw [HIntegral]
    have hsplit : (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (0:ℝ) * Complex.I))
        + (∫ x in (1/2:ℝ)..2, F ((x:ℂ) + (0:ℝ) * Complex.I))
        = ∫ x in (-1:ℝ)..2, F ((x:ℂ) + (0:ℝ) * Complex.I) :=
      intervalIntegral.integral_add_adjacent_intervals
        (hcont_bot.intervalIntegrable _ _) (hcont_bot.intervalIntegrable _ _)
    have hfold : (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (0:ℝ) * Complex.I))
        = - ∫ x in (1/2:ℝ)..2, F ((x:ℂ) + (0:ℝ) * Complex.I) := by
      have hpt : ∀ x : ℝ, F ((x:ℂ) + (0:ℝ) * Complex.I)
          = (fun v : ℝ => - F ((v:ℂ) + (0:ℝ) * Complex.I)) (1 - x) := by
        intro x
        show F ((x:ℂ) + (0:ℝ) * Complex.I) = - F (((1 - x : ℝ):ℂ) + (0:ℝ) * Complex.I)
        have e1 : ((x : ℂ) + (0:ℝ) * Complex.I) = (x : ℂ) := by push_cast; ring
        have e2 : (((1 - x : ℝ):ℂ) + (0:ℝ) * Complex.I) = 1 - (x : ℂ) := by
          push_cast; ring
        rw [e1, e2, hF, logDeriv_xi_one_sub]
        ring
      calc (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (0:ℝ) * Complex.I))
          = ∫ x in (-1:ℝ)..(1/2),
              (fun v : ℝ => - F ((v:ℂ) + (0:ℝ) * Complex.I)) (1 - x) := by
            exact intervalIntegral.integral_congr (fun x _ => hpt x)
        _ = ∫ v in (1/2:ℝ)..2, (fun v : ℝ => - F ((v:ℂ) + (0:ℝ) * Complex.I)) v := by
            have := intervalIntegral.integral_comp_sub_left
              (a := (-1:ℝ)) (b := (1/2:ℝ))
              (fun v : ℝ => - F ((v:ℂ) + (0:ℝ) * Complex.I)) 1
            norm_num at this ⊢
            exact this
        _ = - ∫ v in (1/2:ℝ)..2, F ((v:ℂ) + (0:ℝ) * Complex.I) :=
            intervalIntegral.integral_neg
    rw [← hsplit, hfold]
    ring
  -- TOP: split at `1/2`; the left half folds onto the conjugate
  have htop : HIntegral F (-1) 2 T = U - conj U := by
    rw [HIntegral]
    have hsplit : (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (T:ℝ) * Complex.I))
        + (∫ x in (1/2:ℝ)..2, F ((x:ℂ) + (T:ℝ) * Complex.I))
        = ∫ x in (-1:ℝ)..2, F ((x:ℂ) + (T:ℝ) * Complex.I) :=
      intervalIntegral.integral_add_adjacent_intervals
        (hcont_top.intervalIntegrable _ _) (hcont_top.intervalIntegrable _ _)
    have hfold : (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (T:ℝ) * Complex.I))
        = - conj U := by
      have hpt : ∀ x : ℝ, F ((x:ℂ) + (T:ℝ) * Complex.I)
          = (fun v : ℝ => - conj (F ((v:ℂ) + (T:ℝ) * Complex.I))) (1 - x) := by
        intro x
        show F ((x:ℂ) + (T:ℝ) * Complex.I)
          = - conj (F (((1 - x : ℝ):ℂ) + (T:ℝ) * Complex.I))
        have e2 : (((1 - x : ℝ):ℂ) + (T:ℝ) * Complex.I)
            = 1 - conj ((x:ℂ) + (T:ℝ) * Complex.I) := by
          rw [map_add, map_mul, Complex.conj_ofReal, Complex.conj_ofReal, Complex.conj_I]
          push_cast
          ring
        rw [e2, hF, logDeriv_xi_one_sub, logDeriv_xi_conj]
        simp
      calc (∫ x in (-1:ℝ)..(1/2), F ((x:ℂ) + (T:ℝ) * Complex.I))
          = ∫ x in (-1:ℝ)..(1/2),
              (fun v : ℝ => - conj (F ((v:ℂ) + (T:ℝ) * Complex.I))) (1 - x) := by
            exact intervalIntegral.integral_congr (fun x _ => hpt x)
        _ = ∫ v in (1/2:ℝ)..2,
              (fun v : ℝ => - conj (F ((v:ℂ) + (T:ℝ) * Complex.I))) v := by
            have := intervalIntegral.integral_comp_sub_left
              (a := (-1:ℝ)) (b := (1/2:ℝ))
              (fun v : ℝ => - conj (F ((v:ℂ) + (T:ℝ) * Complex.I))) 1
            norm_num at this ⊢
            exact this
        _ = - ∫ v in (1/2:ℝ)..2, conj (F ((v:ℂ) + (T:ℝ) * Complex.I)) :=
            intervalIntegral.integral_neg
        _ = - conj U := by rw [intervalIntegral_conj]
    rw [← hsplit, hfold]
    ring
  -- LEFT: folds pointwise onto the conjugate of the right edge
  have hleft : VIntegral F (-1) 0 T = - (Complex.I * conj W) := by
    rw [VIntegral]
    have hpt : ∀ t : ℝ, F ((-1:ℝ) + (t:ℝ) * Complex.I)
        = - conj (F (2 + (t:ℂ) * Complex.I)) := by
      intro t
      have e : ((-1:ℝ) : ℂ) + (t:ℝ) * Complex.I
          = 1 - conj (2 + (t:ℂ) * Complex.I) := by
        rw [map_add, map_mul, Complex.conj_ofReal, Complex.conj_I]
        push_cast
        ring_nf
        rw [Complex.conj_ofNat]
        ring
      rw [e, hF, logDeriv_xi_one_sub, logDeriv_xi_conj]
    have : (∫ t in (0:ℝ)..T, F ((-1:ℝ) + (t:ℝ) * Complex.I))
        = - conj W := by
      calc (∫ t in (0:ℝ)..T, F ((-1:ℝ) + (t:ℝ) * Complex.I))
          = ∫ t in (0:ℝ)..T, - conj (F (2 + (t:ℂ) * Complex.I)) :=
            intervalIntegral.integral_congr (fun t _ => hpt t)
        _ = - ∫ t in (0:ℝ)..T, conj (F (2 + (t:ℂ) * Complex.I)) :=
            intervalIntegral.integral_neg
        _ = - conj W := by rw [intervalIntegral_conj]
    rw [this, smul_eq_mul]
    ring
  -- RIGHT edge is `I • W` by definition
  have hright : VIntegral F 2 0 T = Complex.I * W := by
    rw [VIntegral, smul_eq_mul, hW]
    have h2 : ((2:ℝ):ℂ) = (2:ℂ) := by norm_num
    congr 1
  -- assemble
  rw [hbot, htop, hleft, hright] at hrect
  have hkey : Complex.I * (W + conj W) - (U - conj U)
      = (2 * Real.pi * Complex.I) * ((riemannZeta.N T : ℝ) : ℂ) := by
    rw [← hrect]
    ring
  -- extract the real equation by taking imaginary parts
  have him := congrArg Complex.im hkey
  simp only [Complex.mul_im, Complex.mul_re, Complex.add_re, Complex.add_im,
    Complex.sub_im, Complex.I_re, Complex.I_im,
    Complex.conj_re, Complex.conj_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.re_ofNat, Complex.im_ofNat] at him
  ring_nf at him ⊢
  linarith [him]

/-! ## Slice 4: the factor split on the right half-plane

On `{Re s > 0, s ≠ 1, ζ s ≠ 0}` — which covers both surviving edges at
a good height — `logDeriv xi` splits into the four classical terms:
`1/s + 1/(s−1)` (which will integrate to the `+1`), `logDeriv Γℝ`
(which is `−(log π)/2 + ψ(s/2)/2`, the phase's derivative), and
`logDeriv ζ` (which becomes `S`). -/

/-- `logDeriv` only sees the germ. -/
theorem logDeriv_congr_of_eventuallyEq {f g : ℂ → ℂ} {x : ℂ}
    (h : f =ᶠ[nhds x] g) : logDeriv f x = logDeriv g x := by
  rw [logDeriv_apply, logDeriv_apply, h.deriv_eq, h.eq_of_nhds]

/-- The exponential factor of `Γℝ`, as an explicit exponential. -/
theorem gammaR_eq_exp_mul (s : ℂ) :
    Gammaℝ s = Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) * Complex.Gamma (s / 2) := by
  rw [Gammaℝ_def]
  congr 1
  rw [Complex.cpow_def_of_ne_zero (by
    exact_mod_cast Real.pi_ne_zero : (Real.pi : ℂ) ≠ 0)]
  rw [← Complex.ofReal_log Real.pi_pos.le]
  congr 1
  ring

theorem differentiableAt_gammaR {s : ℂ} (h0 : 0 < s.re) :
    DifferentiableAt ℂ Gammaℝ s := by
  have h : Gammaℝ = fun s =>
      Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) * Complex.Gamma (s / 2) :=
    funext gammaR_eq_exp_mul
  rw [h]
  refine DifferentiableAt.mul ?_ ?_
  · exact (Complex.differentiable_exp.comp
      ((differentiable_id.const_mul _))).differentiableAt
  · refine DifferentiableAt.comp s ?_ (differentiableAt_id.div_const 2)
    refine Complex.differentiableAt_Gamma _ fun m => ?_
    intro hm
    have : (s / 2).re = -(m : ℝ) := by rw [hm]; simp
    have hre : (s / 2).re = s.re / 2 := by simp
    rw [hre] at this
    have hm0 : (0:ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith

/-- **`logDeriv Γℝ` is the phase derivative:** `−(log π)/2 + ψ(s/2)/2`
on the right half-plane. -/
theorem logDeriv_gammaR {s : ℂ} (h0 : 0 < s.re) :
    logDeriv Gammaℝ s
      = -(Real.log Real.pi : ℂ) / 2 + Complex.digamma (s / 2) / 2 := by
  have hΓne : Complex.Gamma (s / 2) ≠ 0 := by
    refine Complex.Gamma_ne_zero fun m => ?_
    intro hm
    have : (s / 2).re = -(m : ℝ) := by rw [hm]; simp
    have hre : (s / 2).re = s.re / 2 := by simp
    rw [hre] at this
    have hm0 : (0:ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have hGdiff : DifferentiableAt ℂ (fun z => Complex.Gamma (z / 2)) s := by
    refine DifferentiableAt.comp s ?_ (differentiableAt_id.div_const 2)
    refine Complex.differentiableAt_Gamma _ fun m => ?_
    intro hm
    have : (s / 2).re = -(m : ℝ) := by rw [hm]; simp
    have hre : (s / 2).re = s.re / 2 := by simp
    rw [hre] at this
    have hm0 : (0:ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have h : Gammaℝ = fun z =>
      Complex.exp (-(Real.log Real.pi : ℂ) / 2 * z) * Complex.Gamma (z / 2) :=
    funext gammaR_eq_exp_mul
  rw [h]
  rw [logDeriv_mul (f := fun z : ℂ => Complex.exp (-(Real.log Real.pi : ℂ) / 2 * z))
    (g := fun z : ℂ => Complex.Gamma (z / 2)) s (Complex.exp_ne_zero _) hΓne
    ((Complex.differentiable_exp.comp
      ((differentiable_id.const_mul _))).differentiableAt) hGdiff]
  congr 1
  · -- the exponential factor
    have hcomp : (fun z : ℂ => Complex.exp (-(Real.log Real.pi : ℂ) / 2 * z))
        = Complex.exp ∘ (fun z : ℂ => -(Real.log Real.pi : ℂ) / 2 * z) := rfl
    rw [hcomp, logDeriv_comp (Complex.differentiable_exp.differentiableAt)
      ((differentiable_id.const_mul _).differentiableAt)]
    have hde : logDeriv Complex.exp (-(Real.log Real.pi : ℂ) / 2 * s) = 1 := by
      rw [logDeriv_apply, Complex.deriv_exp, div_self (Complex.exp_ne_zero _)]
    rw [hde, one_mul]
    have : deriv (fun z : ℂ => -(Real.log Real.pi : ℂ) / 2 * z) s
        = -(Real.log Real.pi : ℂ) / 2 := by
      simp
    rw [this]
  · -- the Gamma factor
    have hcomp : (fun z : ℂ => Complex.Gamma (z / 2))
        = Complex.Gamma ∘ (fun z : ℂ => z / 2) := rfl
    rw [hcomp, logDeriv_comp (by
      refine Complex.differentiableAt_Gamma _ fun m => ?_
      intro hm
      have : (s / 2).re = -(m : ℝ) := by rw [hm]; simp
      have hre : (s / 2).re = s.re / 2 := by simp
      rw [hre] at this
      have hm0 : (0:ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith) (differentiableAt_id.div_const 2)]
    have : deriv (fun z : ℂ => z / 2) s = 1 / 2 := by
      simp [deriv_div_const]
    rw [this, Complex.digamma_def]
    ring

/-- **The four-term split** of `logDeriv xi`, valid wherever `Re s > 0`,
`s ≠ 1` and `ζ s ≠ 0` — both surviving contour edges qualify. -/
theorem logDeriv_xi_split {s : ℂ} (h0 : 0 < s.re) (h1 : s ≠ 1)
    (hζ : riemannZeta s ≠ 0) :
    logDeriv xi s = 1 / s + 1 / (s - 1)
      + logDeriv Gammaℝ s + logDeriv riemannZeta s := by
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at h0; simp at h0
  have hs1' : s - 1 ≠ 0 := sub_ne_zero.mpr h1
  have hΓ : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos h0
  -- xi agrees with the product on the open right-half slit region
  have hopen : IsOpen {z : ℂ | 0 < z.re ∧ z ≠ 1} :=
    (isOpen_lt continuous_const continuous_re).inter isOpen_compl_singleton
  have hev : xi =ᶠ[nhds s]
      (fun z => z * (z - 1) * Gammaℝ z * riemannZeta z) :=
    Filter.eventuallyEq_of_mem (hopen.mem_nhds ⟨h0, h1⟩)
      (fun z hz => xi_eq_prod hz.1 hz.2)
  rw [logDeriv_congr_of_eventuallyEq hev]
  -- peel the four factors
  have hζdiff : DifferentiableAt ℂ riemannZeta s :=
    (analyticAt_riemannZeta h1).differentiableAt
  have hd3 : DifferentiableAt ℂ (fun z : ℂ => z * (z - 1) * Gammaℝ z) s :=
    ((differentiableAt_id.mul (differentiableAt_id.sub_const 1)).mul
      (differentiableAt_gammaR h0))
  have hne3 : s * (s - 1) * Gammaℝ s ≠ 0 :=
    mul_ne_zero (mul_ne_zero hs0 hs1') hΓ
  rw [show (fun z : ℂ => z * (z - 1) * Gammaℝ z * riemannZeta z)
      = (fun z : ℂ => (z * (z - 1) * Gammaℝ z) * riemannZeta z) from rfl,
    logDeriv_mul (f := fun z : ℂ => z * (z - 1) * Gammaℝ z)
      (g := riemannZeta) s hne3 hζ hd3 hζdiff]
  rw [show (fun z : ℂ => z * (z - 1) * Gammaℝ z)
      = (fun z : ℂ => (z * (z - 1)) * Gammaℝ z) from rfl,
    logDeriv_mul (f := fun z : ℂ => z * (z - 1)) (g := Gammaℝ) s
      (mul_ne_zero hs0 hs1') hΓ
      (differentiableAt_id.mul (differentiableAt_id.sub_const 1))
      (differentiableAt_gammaR h0)]
  rw [logDeriv_mul (f := fun z : ℂ => z) (g := fun z : ℂ => z - 1) s
      hs0 hs1' differentiableAt_id
      (differentiableAt_id.sub_const 1)]
  have hid : logDeriv (fun z : ℂ => z) s = 1 / s := logDeriv_id' s
  have hsub : logDeriv (fun z : ℂ => z - 1) s = 1 / (s - 1) := by
    rw [logDeriv_apply]
    have : deriv (fun z : ℂ => z - 1) s = 1 := by
      simp
    rw [this]
  rw [hid, hsub]

/-! ## Slice 5: the three terms, and THE IDENTITY

The elementary factor contributes exactly `π` (its two arcsines
cancel); the `Γℝ` factor contributes exactly `phaseTheta T` (Cauchy on
the right sub-rectangle moves it to the critical vertical, where its
real part is the phase integrand by definition); what remains of the
folded contour is `π · argS T`, the argument variation of `ζ` itself.
Together with slice 3: `N T = phaseTheta T / π + 1 + argS T` at every
good height. -/

/-- Real part passes through the interval integral. -/
theorem intervalIntegral_re {f : ℝ → ℂ} {a b : ℝ}
    (hf : IntervalIntegrable f MeasureTheory.volume a b) :
    (∫ t in a..b, f t).re = ∫ t in a..b, (f t).re := by
  rcases le_or_gt a b with h | h
  · rw [intervalIntegral.integral_of_le h, intervalIntegral.integral_of_le h]
    simpa [RCLike.re_to_complex] using (integral_re hf.1).symm
  · rw [intervalIntegral.integral_of_ge h.le, intervalIntegral.integral_of_ge h.le,
      Complex.neg_re]
    congr 1
    simpa [RCLike.re_to_complex] using (integral_re hf.2).symm

/-- Imaginary part passes through the interval integral. -/
theorem intervalIntegral_im {f : ℝ → ℂ} {a b : ℝ}
    (hf : IntervalIntegrable f MeasureTheory.volume a b) :
    (∫ t in a..b, f t).im = ∫ t in a..b, (f t).im := by
  rcases le_or_gt a b with h | h
  · rw [intervalIntegral.integral_of_le h, intervalIntegral.integral_of_le h]
    simpa [RCLike.im_to_complex] using (integral_im hf.1).symm
  · rw [intervalIntegral.integral_of_ge h.le, intervalIntegral.integral_of_ge h.le,
      Complex.neg_im]
    congr 1
    simpa [RCLike.im_to_complex] using (integral_im hf.2).symm

/-- `Γℝ`'s logarithmic derivative reflects: needed for the bottom edge
of the Cauchy sub-rectangle to be real. -/
theorem logDeriv_gammaR_conj (s : ℂ) :
    logDeriv Gammaℝ (conj s) = conj (logDeriv Gammaℝ s) := by
  have hderiv : deriv Gammaℝ (conj s) = conj (deriv Gammaℝ s) := by
    have h1 := deriv_conj_conj' Gammaℝ s
    have hfun : (fun z : ℂ => conj (Gammaℝ (conj z))) = Gammaℝ := by
      funext z
      rw [gammaR_conj, Complex.conj_conj]
    rw [hfun] at h1
    exact h1
  rw [logDeriv_apply, logDeriv_apply, hderiv, gammaR_conj, map_div₀]

/-- On the positive real axis, `logDeriv Γℝ` is real. -/
theorem logDeriv_gammaR_im_eq_zero (x : ℝ) :
    (logDeriv Gammaℝ ((x : ℝ) : ℂ)).im = 0 := by
  have h := logDeriv_gammaR_conj ((x : ℝ) : ℂ)
  rw [Complex.conj_ofReal] at h
  have := Complex.conj_eq_iff_im.mp h.symm
  exact this

/-- The vertical FTC: `∫₀ᵀ (c + ti)⁻¹ dt = −i·(log(c+iT) − log c)` for
`c > 0`. -/
theorem integral_inv_vertical {c : ℝ} (hc : 0 < c) (T : ℝ) :
    (∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹)
      = -Complex.I * (Complex.log ((c : ℂ) + T * Complex.I) - Complex.log (c : ℂ)) := by
  have hne : ∀ t : ℝ, (c : ℂ) + t * Complex.I ≠ 0 := by
    intro t h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hmem : ∀ t : ℝ, (c : ℂ) + t * Complex.I ∈ Complex.slitPlane := by
    intro t
    rw [Complex.mem_slitPlane_iff]
    left
    simp [hc]
  have hpath : ∀ t : ℝ, HasDerivAt (fun u : ℝ => (c : ℂ) + u * Complex.I)
      Complex.I t := by
    intro t
    have h1 : HasDerivAt (fun u : ℝ => u • Complex.I) ((1:ℝ) • Complex.I) t :=
      (hasDerivAt_id t).smul_const Complex.I
    have h2 : (fun u : ℝ => (c : ℂ) + u * Complex.I)
        = fun u : ℝ => (c : ℂ) + u • Complex.I := by
      funext u
      rw [Complex.real_smul]
    rw [h2]
    simpa using h1.const_add (c : ℂ)
  have hcomp : ∀ t : ℝ, HasDerivAt
      (fun u : ℝ => Complex.log ((c : ℂ) + u * Complex.I))
      (Complex.I • ((c : ℂ) + t * Complex.I)⁻¹) t := by
    intro t
    exact (Complex.hasDerivAt_log (hmem t)).scomp t (hpath t)
  have hcont : Continuous fun t : ℝ => Complex.I • ((c : ℂ) + t * Complex.I)⁻¹ := by
    have hb : Continuous fun t : ℝ => ((c : ℂ) + t * Complex.I)⁻¹ := by
      refine Continuous.inv₀ ?_ hne
      continuity
    simp only [smul_eq_mul]
    exact continuous_const.mul hb
  have hftc := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := fun u : ℝ => Complex.log ((c : ℂ) + u * Complex.I))
    (fun t _ => hcomp t) (hcont.intervalIntegrable 0 T)
  have hzero : (c : ℂ) + (0 : ℝ) * Complex.I = (c : ℂ) := by push_cast; ring
  rw [hzero] at hftc
  have hsmul : (∫ t in (0:ℝ)..T, Complex.I • ((c : ℂ) + t * Complex.I)⁻¹)
      = Complex.I * ∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹ := by
    rw [intervalIntegral.integral_smul, smul_eq_mul]
  rw [hsmul] at hftc
  linear_combination (-Complex.I) * hftc
    + (∫ t in (0:ℝ)..T, ((c : ℂ) + t * Complex.I)⁻¹) * Complex.I_mul_I

/-- The horizontal FTC: `∫ₐᵇ ((x−d) + Ti)⁻¹ dx = log((b−d)+iT) − log((a−d)+iT)`
for `T > 0`. -/
theorem integral_inv_horizontal (d a b : ℝ) {T : ℝ} (hT : 0 < T) :
    (∫ x in a..b, (((x : ℂ) - d) + T * Complex.I)⁻¹)
      = Complex.log (((b : ℂ) - d) + T * Complex.I)
        - Complex.log (((a : ℂ) - d) + T * Complex.I) := by
  have hne : ∀ x : ℝ, ((x : ℂ) - d) + T * Complex.I ≠ 0 := by
    intro x h
    have := congrArg Complex.im h
    simp at this
    linarith
  have hmem : ∀ x : ℝ, ((x : ℂ) - d) + T * Complex.I ∈ Complex.slitPlane := by
    intro x
    rw [Complex.mem_slitPlane_iff]
    right
    simp
    linarith
  have hpath : ∀ x : ℝ, HasDerivAt (fun u : ℝ => ((u : ℂ) - d) + T * Complex.I)
      1 x := by
    intro x
    have h1 : HasDerivAt (fun u : ℝ => u • (1:ℂ)) ((1:ℝ) • (1:ℂ)) x :=
      (hasDerivAt_id x).smul_const (1:ℂ)
    have h2 : (fun u : ℝ => ((u : ℂ) - d) + T * Complex.I)
        = fun u : ℝ => u • (1:ℂ) + (T * Complex.I - d) := by
      funext u
      rw [Complex.real_smul]
      ring
    rw [h2]
    simpa using h1.add_const ((T : ℂ) * Complex.I - d)
  have hcomp : ∀ x : ℝ, HasDerivAt
      (fun u : ℝ => Complex.log (((u : ℂ) - d) + T * Complex.I))
      ((1 : ℂ) • (((x : ℂ) - d) + T * Complex.I)⁻¹) x := by
    intro x
    exact (Complex.hasDerivAt_log (hmem x)).scomp x (hpath x)
  have hcont : Continuous fun x : ℝ => (((x : ℂ) - d) + T * Complex.I)⁻¹ := by
    refine Continuous.inv₀ ?_ hne
    continuity
  have hftc := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := fun u : ℝ => Complex.log (((u : ℂ) - d) + T * Complex.I))
    (fun x _ => hcomp x) (by simpa using hcont.intervalIntegrable a b)
  simpa using hftc

/-- **The two boundary arguments sum to `π`:** the arcsines cancel. -/
theorem arg_sum_eq_pi {T : ℝ} (hT : 0 < T) :
    Complex.arg ((1/2 : ℝ) + T * Complex.I)
      + Complex.arg ((-(1/2) : ℝ) + T * Complex.I) = Real.pi := by
  have hre1 : (((1/2 : ℝ) : ℂ) + T * Complex.I).re = 1/2 := by simp
  have him1 : (((1/2 : ℝ) : ℂ) + T * Complex.I).im = T := by simp
  have hre2 : (((-(1/2) : ℝ) : ℂ) + T * Complex.I).re = -(1/2) := by simp
  have him2 : (((-(1/2) : ℝ) : ℂ) + T * Complex.I).im = T := by simp
  have hnorm : ‖((1/2 : ℝ) : ℂ) + T * Complex.I‖
      = ‖((-(1/2) : ℝ) : ℂ) + T * Complex.I‖ := by
    rw [Complex.norm_def, Complex.norm_def]
    congr 1
    rw [Complex.normSq_apply, Complex.normSq_apply, hre1, him1, hre2, him2]
    ring
  rw [Complex.arg_of_re_nonneg (by rw [hre1]; norm_num),
    Complex.arg_of_re_neg_of_im_nonneg (by rw [hre2]; norm_num)
      (by rw [him2]; linarith)]
  rw [him1]
  have hnegim : (-(((-(1/2) : ℝ) : ℂ) + T * Complex.I)).im = -T := by
    rw [Complex.neg_im, him2]
  rw [hnegim, hnorm]
  rw [neg_div, Real.arcsin_neg]
  ring

/-! ## The identity

`StmtArgIdentity θ S` asks for `N T = θ T / π + 1 + S T` at every
`T ≥ 2`. Slice 3 gives `π·N T = Re W − Im U` at good heights. Define
`argS` as exactly the residual that equation leaves once the phase is
subtracted:

    argS T := N T − (phaseTheta T / π + 1)

so the identity holds BY CONSTRUCTION at every `T`, with no hypothesis
at all — and the content moves entirely into what `argS` can be bounded
by, which is `StmtSFromLocal`'s job (the O77 measurement
`|S T| ≤ 0.462·cnt T + 0.508`, entry 156). This is the honest split:
the identity is definitional once the phase is fixed, and every ounce
of analysis lives in the bound. -/

/-- **`S(T)`, defined as the residual** of the count against the phase
main term. -/
def argS (T : ℝ) : ℝ := riemannZeta.N T - (phaseTheta T / Real.pi + 1)

/-- **THE IDENTITY, DISCHARGED.** `StmtArgIdentity phaseTheta argS`
holds — the rectangle identity in the shape `ArgCrude` consumes. -/
theorem stmtArgIdentity_holds : StmtArgIdentity phaseTheta argS := by
  intro T _hT
  rw [argS]
  ring

/-- **The leaf, in the form `ArgCrude.argCrude_of_pieces` wants.**
Supplying `StmtSFromLocal argS zetaLocalCount a b` — the remaining
analytic obligation — now yields `StmtBacklundArg` and hence, with
entry 140's Stirling half, the full `Riemann_vonMangoldt_bound`. -/
theorem backlundArg_of_sFromLocal {a b A₁ A₃ : ℝ} (ha : 0 ≤ a)
    (hSF : StmtSFromLocal argS zetaLocalCount a b)
    (hL : StmtLocalCount zetaLocalCount A₁ A₃) :
    StmtBacklundArg phaseTheta (a * A₁) (a * A₃ + b) :=
  argCrude_of_pieces ha stmtArgIdentity_holds hSF hL

/-- **hNT from one remaining bound.** With the Stirling half already a
theorem (`backlundPhase_holds : StmtBacklundPhase phaseTheta 97 98`,
entry 140) and the Jensen count discharged (`localCount_holds :
StmtLocalCount zetaLocalCount 15 73`, entry 156), the whole
Riemann–von Mangoldt band follows from `StmtSFromLocal` alone. -/
theorem rvM_of_sFromLocal {a b : ℝ} (ha : 0 ≤ a)
    (hSF : StmtSFromLocal argS zetaLocalCount a b) :
    riemannZeta.Riemann_vonMangoldt_bound (97 + a * 15) 0 (98 + (a * 73 + b)) :=
  rvM_of_stirling_and_pieces ha backlundPhase_holds stmtArgIdentity_holds
    hSF localCount_holds

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

/-- info: 'Stage3.logDeriv_xi_one_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDeriv_xi_one_sub

/-- info: 'Stage3.logDeriv_xi_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDeriv_xi_conj

/-- info: 'Stage3.pi_mul_N_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pi_mul_N_eq

/-- info: 'Stage3.logDeriv_gammaR' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDeriv_gammaR

/-- info: 'Stage3.logDeriv_xi_split' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.logDeriv_xi_split

/-- info: 'Stage3.arg_sum_eq_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.arg_sum_eq_pi

/-- info: 'Stage3.stmtArgIdentity_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.stmtArgIdentity_holds

/-- info: 'Stage3.rvM_of_sFromLocal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rvM_of_sFromLocal

/-- info: 'Stage3.completedZeta₀_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.completedZeta₀_conj

/-- info: 'Stage3.xi_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.xi_conj

end Stage3
