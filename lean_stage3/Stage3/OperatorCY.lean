/-
# OperatorCY — block S12 of `lean_stage3/design/stencil.md`, piece 3, the operator: `c(α,β)` is analytic. 2026-11-25.

Young's `c(α,β) = c₁(α,β) + T^(−α−β) c₁(−β,−α)` (`TwistedMoment.cY`) is an analytic function of
`(α, β)` off `α + β = 0`, so its partials, and the partial in `β` of its partial in `α`, exist
there (`OperatorCauchy.analytic_partials`). The integral in `c₁` is a polynomial in `α, β`:
`∫₀¹ (P′ + αℓP)(P′ + βℓP) = A + (α+β)ℓB + αβℓ²C`, `ℓ = log M`.

| name | content | status |
|---|---|---|
| `Aq`, `Bq`, `Cq`, `c1form`, `cYform` | `∫ P′²`, `∫ P′P`, `∫ P²`; the closed forms of `c₁` and `c` | defined |
| `c1Y_eq` | `c₁(α,β) = (α+β)⁻¹ ℓ⁻¹ (A + (α+β)ℓB + αβℓ²C)` | proved |
| `cY_eq` | `c(α,β) = cYform (α, β)` for `T ≠ 0` | proved |
| `cYform_analytic` | `cYform` is analytic on `α + β ≠ 0` | proved |
| `cY_partials` | at `α + β ≠ 0`: `∂α c`, `∂β c` exist, and `β ↦ ∂α c(α, β)` is differentiable | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TwistedMoment
import Stage3.OperatorCauchy

namespace Operator

open Complex TwistedMoment

noncomputable section

/-- `A = ∫₀¹ P′(u)² du`. -/
def Aq (P : Polynomial ℝ) : ℂ :=
  ∫ u in (0 : ℝ)..1, ((P.derivative.eval u : ℝ) : ℂ) * ((P.derivative.eval u : ℝ) : ℂ)

/-- `B = ∫₀¹ P′(u) P(u) du`. -/
def Bq (P : Polynomial ℝ) : ℂ :=
  ∫ u in (0 : ℝ)..1, ((P.derivative.eval u : ℝ) : ℂ) * ((P.eval u : ℝ) : ℂ)

/-- `C = ∫₀¹ P(u)² du`. -/
def Cq (P : Polynomial ℝ) : ℂ :=
  ∫ u in (0 : ℝ)..1, ((P.eval u : ℝ) : ℂ) * ((P.eval u : ℝ) : ℂ)

/-- The closed form of `c₁(α,β)`, `ℓ = log M`. -/
def c1form (P : Polynomial ℝ) (M : ℕ) (α β : ℂ) : ℂ :=
  (α + β)⁻¹ * ((Real.log M : ℝ) : ℂ)⁻¹ *
    (Aq P + (α + β) * ((Real.log M : ℝ) : ℂ) * Bq P +
      α * β * ((Real.log M : ℝ) : ℂ) ^ 2 * Cq P)

/-- The closed form of `c(α,β)` on `ℂ × ℂ`, with `T^(−α−β) = exp(log T · (−(α+β)))`. -/
def cYform (P : Polynomial ℝ) (M : ℕ) (T : ℝ) (q : ℂ × ℂ) : ℂ :=
  c1form P M q.1 q.2 + cexp (Complex.log (T : ℂ) * (-(q.1 + q.2))) * c1form P M (-q.2) (-q.1)

end

/-- `c₁` in closed form. -/
theorem c1Y_eq (P : Polynomial ℝ) (M : ℕ) (α β : ℂ) : c1Y P M α β = c1form P M α β := by
  have hd : Continuous fun u : ℝ => ((P.derivative.eval u : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp P.derivative.continuous
  have hp : Continuous fun u : ℝ => ((P.eval u : ℝ) : ℂ) :=
    Complex.continuous_ofReal.comp P.continuous
  set ℓ : ℂ := ((Real.log M : ℝ) : ℂ) with hℓ
  have hint : (∫ u in (0 : ℝ)..1,
      (((P.derivative.eval u : ℝ) : ℂ) + α * ℓ * (P.eval u : ℝ)) *
        (((P.derivative.eval u : ℝ) : ℂ) + β * ℓ * (P.eval u : ℝ))) =
      Aq P + (α + β) * ℓ * Bq P + α * β * ℓ ^ 2 * Cq P := by
    have e : ∀ u : ℝ, (((P.derivative.eval u : ℝ) : ℂ) + α * ℓ * (P.eval u : ℝ)) *
        (((P.derivative.eval u : ℝ) : ℂ) + β * ℓ * (P.eval u : ℝ)) =
        ((P.derivative.eval u : ℝ) : ℂ) * ((P.derivative.eval u : ℝ) : ℂ) +
          ((α + β) * ℓ) * (((P.derivative.eval u : ℝ) : ℂ) * ((P.eval u : ℝ) : ℂ)) +
          (α * β * ℓ ^ 2) * (((P.eval u : ℝ) : ℂ) * ((P.eval u : ℝ) : ℂ)) := by
      intro u
      ring
    simp_rw [e]
    rw [intervalIntegral.integral_add, intervalIntegral.integral_add,
      intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
    · rfl
    · exact (hd.mul hd).intervalIntegrable _ _
    · exact ((hd.mul hp).const_mul _).intervalIntegrable _ _
    · exact ((hd.mul hd).add ((hd.mul hp).const_mul _)).intervalIntegrable _ _
    · exact ((hp.mul hp).const_mul _).intervalIntegrable _ _
  unfold c1Y c1form
  rw [← hℓ, hint, one_div, mul_inv]

/-- `c` in closed form. -/
theorem cY_eq (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) (α β : ℂ) :
    cY P M T α β = cYform P M T (α, β) := by
  unfold cY cYform
  rw [c1Y_eq, c1Y_eq, cpow_def_of_ne_zero (Complex.ofReal_ne_zero.mpr hT)]

theorem afst {q : ℂ × ℂ} : AnalyticAt ℂ (fun p : ℂ × ℂ => p.1) q := analyticAt_fst

theorem asnd {q : ℂ × ℂ} : AnalyticAt ℂ (fun p : ℂ × ℂ => p.2) q := analyticAt_snd

attribute [local fun_prop] afst asnd

/-- `cYform` is analytic off `α + β = 0`. -/
theorem cYform_analytic (P : Polynomial ℝ) (M : ℕ) (T : ℝ) :
    AnalyticOnNhd ℂ (cYform P M T) {q : ℂ × ℂ | q.1 + q.2 ≠ 0} := by
  intro q hq
  have h1 : q.1 + q.2 ≠ 0 := hq
  have h2 : -q.2 + -q.1 ≠ 0 := by
    intro e
    apply h1
    linear_combination -e
  unfold cYform c1form
  fun_prop (disch := assumption)

/-- **The partials of `c(α,β)`**, at `α + β ≠ 0`. -/
theorem cY_partials (P : Polynomial ℝ) (M : ℕ) {T : ℝ} (hT : T ≠ 0) {x y : ℂ}
    (hxy : x + y ≠ 0) :
    DifferentiableAt ℂ (fun x => cY P M T x y) x ∧ DifferentiableAt ℂ (fun y => cY P M T x y) y ∧
      DifferentiableAt ℂ (fun y => pa (cY P M T) x y) y := by
  have hfun : cY P M T = fun x y => cYform P M T (x, y) := by
    funext x y
    exact cY_eq P M hT x y
  have hU : IsOpen {q : ℂ × ℂ | q.1 + q.2 ≠ 0} :=
    isOpen_ne_fun (by fun_prop) continuous_const
  obtain ⟨h1, h2, h3⟩ := analytic_partials hU (cYform_analytic P M T)
  rw [hfun]
  exact ⟨h1 (x, y) hxy, h2 (x, y) hxy, h3 (x, y) hxy⟩

/-- info: 'Operator.c1Y_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms c1Y_eq

/-- info: 'Operator.cY_partials' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cY_partials

end Operator
