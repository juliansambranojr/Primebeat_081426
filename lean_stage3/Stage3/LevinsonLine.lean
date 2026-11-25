/-
LevinsonLine — block S11 of `lean_stage3/design/stencil.md`, step 1a. 2026-11-24.

On the critical line `s = 1/2 + t i`, with `Λ = completedRiemannZeta = Gammaℝ · ζ`
(right of zero, away from `1`), `g = Gammaℝ' / Gammaℝ` and a real constant `c`:

- `Λ(1/2 + t i)` is real (`HardyZ.xi_line_real`), so its derivative in `t`,
  which is `Λ'(s) · i` by the chain rule, is real; hence `Λ'(s)` is purely
  imaginary.
- `Λ' = Gammaℝ' · ζ + Gammaℝ · ζ'`, so `Gammaℝ · ζ' = Λ' − g · Λ`, and
  `Gammaℝ · (ζ + c ζ') = Λ + c Λ' − c g Λ`. Taking real parts with `Λ` real and
  `Λ'` imaginary gives `Re(Gammaℝ · (ζ + c ζ')) = Λ · (1 − c · Re g)`.

  deriv_xi_line_im     (deriv Λ (1/2 + t i)).re = 0
  re_gammaR_G_line     (Gammaℝ s * (ζ s + c * ζ' s)).re
                         = (Λ s).re * (1 - c * (Gammaℝ' s / Gammaℝ s).re),
                       s = 1/2 + t i, c real
  zeta_line_zero_iff   1 - c * (Gammaℝ' s / Gammaℝ s).re ≠ 0 ⊢
                         ζ s = 0 ↔ (Gammaℝ s * (ζ s + c * ζ' s)).re = 0

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.HardyZ

namespace LevinsonLine

open Complex HardyZ

/-- A point of the critical line is neither `0` nor `1`, and has positive real part. -/
theorem line_facts (t : ℝ) :
    ((1/2 : ℂ) + t * I) ≠ 0 ∧ ((1/2 : ℂ) + t * I) ≠ 1 ∧ 0 < ((1/2 : ℂ) + t * I).re := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have := congrArg Complex.re h
    rw [re_line] at this
    norm_num at this
  · intro h
    have := congrArg Complex.re h
    rw [re_line] at this
    norm_num at this
  · rw [re_line]; norm_num

/-- **Target 1.** `Λ'` is purely imaginary on the critical line. -/
theorem deriv_xi_line_im (t : ℝ) :
    (deriv completedRiemannZeta (1/2 + t * I)).re = 0 := by
  obtain ⟨h0, h1, -⟩ := line_facts t
  set s : ℂ := 1/2 + t * I with hs_def
  -- the complex chain rule for `w ↦ Λ(1/2 + w i)` at `w = t`
  have hlin : HasDerivAt (fun w : ℂ => (1/2 : ℂ) + w * I) I (t : ℂ) := by
    have := ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (1/2 : ℂ)
    simpa using this
  have hΛ : HasDerivAt completedRiemannZeta (deriv completedRiemannZeta s) s :=
    (differentiableAt_completedZeta h0 h1).hasDerivAt
  have hcomp : HasDerivAt (fun w : ℂ => completedRiemannZeta ((1/2 : ℂ) + w * I))
      (deriv completedRiemannZeta s * I) (t : ℂ) :=
    HasDerivAt.comp (t : ℂ) (h₂ := completedRiemannZeta) (h := fun w : ℂ => (1/2 : ℂ) + w * I)
      hΛ hlin
  have hreal : HasDerivAt (fun y : ℝ => completedRiemannZeta ((1/2 : ℂ) + y * I))
      (deriv completedRiemannZeta s * I) t := hcomp.comp_ofReal
  have him : HasDerivAt (Complex.imCLM ∘ fun y : ℝ => completedRiemannZeta ((1/2 : ℂ) + y * I))
      (Complex.imCLM (deriv completedRiemannZeta s * I)) t :=
    Complex.imCLM.hasFDerivAt.comp_hasDerivAt t hreal
  have hfun : (Complex.imCLM ∘ fun y : ℝ => completedRiemannZeta ((1/2 : ℂ) + y * I)) =
      fun _ : ℝ => (0 : ℝ) := by
    funext y
    simp only [Function.comp_apply, Complex.imCLM_apply]
    exact xi_line_real y
  rw [hfun] at him
  have h00 := him.unique (hasDerivAt_const t (0 : ℝ))
  rw [Complex.imCLM_apply, Complex.mul_im, Complex.I_re, Complex.I_im] at h00
  linarith

/-- `Gammaℝ` is differentiable right of zero. -/
theorem differentiableAt_Gammaℝ {s : ℂ} (hs : 0 < s.re) : DifferentiableAt ℂ Gammaℝ s := by
  have h := (differentiable_Gammaℝ_inv s).inv (inv_ne_zero (Gammaℝ_ne_zero_of_re_pos hs))
  have he : (fun z : ℂ => (Gammaℝ z)⁻¹)⁻¹ = Gammaℝ := by
    funext z
    simp
  rwa [he] at h

/-- Right of zero, away from `1`, `Λ' = Gammaℝ' · ζ + Gammaℝ · ζ'`. -/
theorem deriv_completedZeta_eq {s : ℂ} (hs : 0 < s.re) (h1 : s ≠ 1) :
    deriv completedRiemannZeta s =
      deriv Gammaℝ s * riemannZeta s + Gammaℝ s * deriv riemannZeta s := by
  have hopen : IsOpen {z : ℂ | 0 < z.re} :=
    isOpen_lt continuous_const Complex.continuous_re
  have hev : completedRiemannZeta =ᶠ[nhds s] (Gammaℝ * riemannZeta) := by
    filter_upwards [hopen.mem_nhds hs] with z hz
    have hz' : (0 : ℝ) < z.re := hz
    have hz0 : z ≠ 0 := fun h => by simp [h] at hz'
    have hG : Gammaℝ z ≠ 0 := Gammaℝ_ne_zero_of_re_pos hz'
    rw [Pi.mul_apply, riemannZeta_def_of_ne_zero hz0, mul_div_cancel₀ _ hG]
  rw [hev.deriv_eq, deriv_mul (differentiableAt_Gammaℝ hs) (differentiableAt_riemannZeta h1)]

/-- **Target 2.** On the critical line, for real `c`,
`Re(Gammaℝ · (ζ + c ζ')) = Λ · (1 − c · Re(Gammaℝ' / Gammaℝ))`. -/
theorem re_gammaR_G_line (c t : ℝ) :
    (Gammaℝ (1/2 + t * I) *
        (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))).re =
      (completedRiemannZeta (1/2 + t * I)).re *
        (1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re) := by
  obtain ⟨h0, h1, hre⟩ := line_facts t
  have hΛim := xi_line_real t
  have hΛ're := deriv_xi_line_im t
  have hd := deriv_completedZeta_eq hre h1
  set s : ℂ := 1/2 + t * I with hs_def
  have hG : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_pos hre
  have hΛ : completedRiemannZeta s = Gammaℝ s * riemannZeta s := by
    rw [riemannZeta_def_of_ne_zero h0, mul_div_cancel₀ _ hG]
  set Λ := completedRiemannZeta s with hΛ_def
  set Λ' := deriv completedRiemannZeta s with hΛ'_def
  set g := deriv Gammaℝ s / Gammaℝ s with hg_def
  have key : Gammaℝ s * (riemannZeta s + c * deriv riemannZeta s) =
      Λ + c * Λ' - c * g * Λ := by
    rw [hd, hΛ, hg_def]
    field_simp
    try ring
  rw [key]
  have hΛr : Λ = (Λ.re : ℂ) := (Complex.ext rfl (by simp [hΛim]))
  have hΛ'i : Λ' = (Λ'.im : ℂ) * I := Complex.ext (by simp [hΛ're]) (by simp)
  rw [hΛr, hΛ'i]
  simp only [Complex.sub_re, Complex.add_re, Complex.mul_re, Complex.ofReal_re,
    Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.mul_im]
  ring

/-- **Target 3.** Where `1 − c · Re(Gammaℝ' / Gammaℝ) ≠ 0`, the zeros of `ζ` on the
line are exactly the zeros of `Re(Gammaℝ · (ζ + c ζ'))`. -/
theorem zeta_line_zero_iff (c t : ℝ)
    (hc : 1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0) :
    riemannZeta (1/2 + t * I) = 0 ↔
      (Gammaℝ (1/2 + t * I) *
        (riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I))).re = 0 := by
  obtain ⟨h0, -, hre⟩ := line_facts t
  have hG : Gammaℝ (1/2 + t * I) ≠ 0 := Gammaℝ_ne_zero_of_re_pos hre
  have hΛ : completedRiemannZeta (1/2 + t * I) =
      Gammaℝ (1/2 + t * I) * riemannZeta (1/2 + t * I) := by
    rw [riemannZeta_def_of_ne_zero h0, mul_div_cancel₀ _ hG]
  rw [re_gammaR_G_line, mul_eq_zero, or_iff_left hc]
  constructor
  · intro hz
    rw [hΛ, hz, mul_zero, Complex.zero_re]
  · intro hz
    have hΛ0 : completedRiemannZeta (1/2 + t * I) = 0 :=
      Complex.ext hz (xi_line_real t)
    rw [hΛ] at hΛ0
    exact (mul_eq_zero.mp hΛ0).resolve_left hG

/-- info: 'LevinsonLine.deriv_xi_line_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms deriv_xi_line_im

/-- info: 'LevinsonLine.re_gammaR_G_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_gammaR_G_line

/-- info: 'LevinsonLine.zeta_line_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_line_zero_iff

end LevinsonLine
