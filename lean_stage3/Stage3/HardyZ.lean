/-
HardyZ — block S10 of `lean_stage3/design/stencil.md`, steps 1 and 2. 2026-11-24.

Hardy's function is taken as `t ↦ Λ(1/2 + it)`, the completed zeta on the
critical line. It differs from `Z(t) = e^(iθ(t))·ζ(1/2 + it)` by the positive
factor `|Gammaℝ(1/2 + it)|`, so its sign changes are `Z`'s, and no continuous
phase `θ` is defined here.

Step 1: `Λ` commutes with conjugation (from `riemannZeta_conj`, `Gamma_conj`
and `ζ = Λ / Gammaℝ`), and `1 - (1/2 + it) = conj (1/2 + it)`, so the
functional equation `Λ(1 - s) = Λ(s)` makes `Λ(1/2 + it)` its own conjugate.
Step 2: `Λ` is continuous on the line, so a sign change of its real part on
`[t₁, t₂]` gives a zero of the real part, hence of `Λ`, hence of `ζ`.

  Gammaℝ_conj                Gammaℝ (conj s) = conj (Gammaℝ s)
  completedRiemannZeta_conj_of_re_pos
                             0 < re s ⊢ Λ (conj s) = conj (Λ s)
  xi_line_real               (Λ (1/2 + t i)).im = 0
  signChange_zero_on_line    t₁ ≤ t₂, (Λ(1/2 + t₁ i)).re · (Λ(1/2 + t₂ i)).re ≤ 0
                             ⊢ ∃ γ ∈ [t₁, t₂], ζ (1/2 + γ i) = 0

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Mathlib.NumberTheory.Harmonic.ZetaAsymp
import Mathlib.NumberTheory.LSeries.RiemannZeta
import Mathlib.Analysis.SpecialFunctions.Gamma.Deligne
import Mathlib.Topology.Order.IntermediateValue

namespace HardyZ

open Complex
open scoped ComplexConjugate

/-- `Gammaℝ` commutes with conjugation. -/
theorem Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s) := by
  have hπ : (↑Real.pi : ℂ).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
    exact Real.pi_pos.ne
  have hn : -conj s / 2 = conj (-s / 2) := by
    simp [map_div₀, map_neg, map_ofNat]
  have hd : conj s / 2 = conj (s / 2) := by
    simp [map_div₀, map_ofNat]
  rw [Gammaℝ_def, Gammaℝ_def, hn, hd, Complex.Gamma_conj, map_mul,
    Complex.cpow_conj _ _ hπ, Complex.conj_ofReal]

/-- **Conjugation.** Right of zero, `Λ (conj s) = conj (Λ s)`, from `ζ`'s
conjugation and `ζ = Λ / Gammaℝ`. -/
theorem completedRiemannZeta_conj_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    completedRiemannZeta (conj s) = conj (completedRiemannZeta s) := by
  have hs' : 0 < (conj s).re := by simpa using hs
  have hs0 : s ≠ 0 := fun h => by simp [h] at hs
  have hc0 : conj s ≠ 0 := fun h => by simp [h] at hs'
  have hG : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos hs
  have hGc : Gammaℝ (conj s) ≠ 0 := Gammaℝ_ne_zero_of_re_pos hs'
  have e1 : completedRiemannZeta s = riemannZeta s * Gammaℝ s := by
    rw [riemannZeta_def_of_ne_zero hs0, div_mul_cancel₀ _ hG]
  have e2 : completedRiemannZeta (conj s) = riemannZeta (conj s) * Gammaℝ (conj s) := by
    rw [riemannZeta_def_of_ne_zero hc0, div_mul_cancel₀ _ hGc]
  rw [e2, e1, riemannZeta_conj, Gammaℝ_conj, map_mul]

/-- The point `1/2 + t i` of the critical line has real part one half. -/
theorem re_line (t : ℝ) : ((1 / 2 : ℂ) + t * I).re = 1 / 2 := by
  simp

/-- **Step 1.** `Λ` is real on the critical line. -/
theorem xi_line_real (t : ℝ) : (completedRiemannZeta (1/2 + t * Complex.I)).im = 0 := by
  set s : ℂ := 1/2 + t * Complex.I with hs_def
  have hre : 0 < s.re := by rw [hs_def, re_line]; norm_num
  have h1 : 1 - s = conj s := by
    apply Complex.ext <;> norm_num [hs_def]
  have hx : conj (completedRiemannZeta s) = completedRiemannZeta s := by
    rw [← completedRiemannZeta_conj_of_re_pos hre, ← h1, completedRiemannZeta_one_sub]
  exact Complex.conj_eq_iff_im.mp hx

/-- `t ↦ Λ(1/2 + t i)` is continuous. -/
theorem continuous_xi_line :
    Continuous (fun t : ℝ => completedRiemannZeta (1/2 + t * Complex.I)) := by
  rw [continuous_iff_continuousAt]
  intro t
  have h0 : (1/2 + t * Complex.I : ℂ) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    rw [re_line] at this
    norm_num at this
  have h1 : (1/2 + t * Complex.I : ℂ) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    rw [re_line] at this
    norm_num at this
  have hd := (differentiableAt_completedZeta h0 h1).continuousAt
  have hl : Continuous (fun t : ℝ => (1/2 + t * Complex.I : ℂ)) := by fun_prop
  exact ContinuousAt.comp (g := completedRiemannZeta)
    (f := fun t : ℝ => (1/2 + t * Complex.I : ℂ)) hd hl.continuousAt

/-- **Step 2.** A sign change of `t ↦ Λ(1/2 + t i)` on `[t₁, t₂]` gives a
zero of `ζ` on the critical line at height in `[t₁, t₂]`. -/
theorem signChange_zero_on_line {t₁ t₂ : ℝ} (h : t₁ ≤ t₂)
    (hs : (completedRiemannZeta (1/2 + t₁ * I)).re *
      (completedRiemannZeta (1/2 + t₂ * I)).re ≤ 0) :
    ∃ γ ∈ Set.Icc t₁ t₂, riemannZeta (1/2 + γ * I) = 0 := by
  set f : ℝ → ℝ := fun t => (completedRiemannZeta (1/2 + t * I)).re with hf_def
  have hf : ContinuousOn f (Set.Icc t₁ t₂) :=
    (Complex.continuous_re.comp continuous_xi_line).continuousOn
  have hz : (0 : ℝ) ∈ f '' Set.Icc t₁ t₂ := by
    rcases mul_nonpos_iff.mp hs with ⟨ha, hb⟩ | ⟨ha, hb⟩
    · exact intermediate_value_Icc' h hf ⟨hb, ha⟩
    · exact intermediate_value_Icc h hf ⟨ha, hb⟩
  obtain ⟨γ, hγ, hfγ⟩ := hz
  refine ⟨γ, hγ, ?_⟩
  have hΛ : completedRiemannZeta (1/2 + γ * I) = 0 :=
    Complex.ext hfγ (xi_line_real γ)
  have h0 : ((1/2 : ℂ) + γ * I) ≠ 0 := by
    intro h0
    have := congrArg Complex.re h0
    rw [re_line] at this
    norm_num at this
  rw [riemannZeta_def_of_ne_zero h0, hΛ, zero_div]

/-- info: 'HardyZ.xi_line_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms xi_line_real

/-- info: 'HardyZ.signChange_zero_on_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms signChange_zero_on_line

end HardyZ
