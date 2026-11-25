/-
# OperatorCauchy — block S12 of `lean_stage3/design/stencil.md`, piece 3, the operator: Cauchy's estimate. 2026-11-25.

Levinson's operator `D = (1 + (1/L)∂α)(1 + (1/L)∂β)`, written out as
`D f = f + (1/L)(∂α f + ∂β f) + (1/L²) ∂β ∂α f` at a point, and the three facts about it that
the mollified mean uses, all of them one complex variable at a time.

| name | content | status |
|---|---|---|
| `pa`, `pb`, `pab`, `Dop` | `∂α f`, `∂β f`, `∂β∂α f` at `(α, β)`; `D f` | defined |
| `cauchy_bounds` | `‖f‖ ≤ S`, `‖∂α f‖, ‖∂β f‖ ≤ S/ρ`, `‖∂β∂α f‖ ≤ S/ρ²` from `‖f‖ ≤ S` on the closed polydisc of radius `ρ` | proved |
| `Dop_norm_le` | `‖D f‖ ≤ S (1 + 2/r + 1/r²)` at `ρ = r/L`: no power of `L` is left over | proved |
| `Dop_sub_mul` | `D (A − B·c) = D A − (D B)·c` | proved |
| `analytic_partials` | for `f` analytic on an open `U ⊆ ℂ²`: both partials exist on `U` and `β ↦ ∂α f(α, β)` is differentiable on `U` | proved |

The mixed derivative is the derivative in `β` of the derivative in `α`; Cauchy's estimate is
applied in `α` on each circle `|β − β₀| = ρ` and then in `β`, so no several-variable Cauchy
formula is needed.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib

namespace Operator

open Complex Metric Filter Topology

noncomputable section

/-- `∂α f (α, β)`. -/
def pa (f : ℂ → ℂ → ℂ) (α β : ℂ) : ℂ := deriv (fun x => f x β) α

/-- `∂β f (α, β)`. -/
def pb (f : ℂ → ℂ → ℂ) (α β : ℂ) : ℂ := deriv (fun y => f α y) β

/-- `∂β ∂α f (α, β)`. -/
def pab (f : ℂ → ℂ → ℂ) (α β : ℂ) : ℂ := deriv (fun y => pa f α y) β

/-- Levinson's operator with `Q(x) = 1 − x`:
`D f = (1 + (1/L)∂α)(1 + (1/L)∂β) f = f + (1/L)(∂α f + ∂β f) + (1/L²) ∂α∂β f`. -/
def Dop (L : ℝ) (f : ℂ → ℂ → ℂ) (α β : ℂ) : ℂ :=
  f α β + 1 / (L : ℂ) * (pa f α β + pb f α β) + 1 / (L : ℂ) ^ 2 * pab f α β

end

/-- **Cauchy's estimate, one variable at a time**, on the closed polydisc of radius `ρ`. -/
theorem cauchy_bounds {F : ℂ → ℂ → ℂ} {α₀ β₀ : ℂ} {ρ S : ℝ} (hρ : 0 < ρ)
    (hFa : ∀ y ∈ closedBall β₀ ρ, ∀ x ∈ closedBall α₀ ρ, DifferentiableAt ℂ (fun x => F x y) x)
    (hFb : ∀ y ∈ closedBall β₀ ρ, DifferentiableAt ℂ (fun y => F α₀ y) y)
    (hg : ∀ y ∈ closedBall β₀ ρ, DifferentiableAt ℂ (fun y => pa F α₀ y) y)
    (hS : ∀ x ∈ closedBall α₀ ρ, ∀ y ∈ closedBall β₀ ρ, ‖F x y‖ ≤ S) :
    ‖F α₀ β₀‖ ≤ S ∧ ‖pa F α₀ β₀‖ ≤ S / ρ ∧ ‖pb F α₀ β₀‖ ≤ S / ρ ∧
      ‖pab F α₀ β₀‖ ≤ S / ρ / ρ := by
  have hc : ∀ c : ℂ, c ∈ closedBall c ρ := fun c => mem_closedBall_self hρ.le
  have hsph : ∀ c z : ℂ, z ∈ sphere c ρ → z ∈ closedBall c ρ :=
    fun c z hz => sphere_subset_closedBall hz
  have hcl : ∀ c : ℂ, closure (ball c ρ) = closedBall c ρ := fun c => closure_ball c hρ.ne'
  have hpa : ∀ y ∈ closedBall β₀ ρ, ‖pa F α₀ y‖ ≤ S / ρ := by
    intro y hy
    show ‖deriv (fun x => F x y) α₀‖ ≤ S / ρ
    apply norm_deriv_le_of_forall_mem_sphere_norm_le hρ
    · apply DifferentiableOn.diffContOnCl
      rw [hcl]
      intro x hx
      exact (hFa y hy x hx).differentiableWithinAt
    · intro z hz
      exact hS z (hsph _ _ hz) y hy
  refine ⟨hS α₀ (hc _) β₀ (hc _), hpa β₀ (hc _), ?_, ?_⟩
  · show ‖deriv (fun y => F α₀ y) β₀‖ ≤ S / ρ
    apply norm_deriv_le_of_forall_mem_sphere_norm_le hρ
    · apply DifferentiableOn.diffContOnCl
      rw [hcl]
      intro y hy
      exact (hFb y hy).differentiableWithinAt
    · intro z hz
      exact hS α₀ (hc _) z (hsph _ _ hz)
  · show ‖deriv (fun y => pa F α₀ y) β₀‖ ≤ S / ρ / ρ
    apply norm_deriv_le_of_forall_mem_sphere_norm_le hρ
    · apply DifferentiableOn.diffContOnCl
      rw [hcl]
      intro y hy
      exact (hg y hy).differentiableWithinAt
    · intro z hz
      exact hpa z (hsph _ _ hz)

/-- **The size of `D f`** at the radius `ρ = r/L`: `‖D f‖ ≤ S (1 + 2/r + 1/r²)`. The `1/L` of
each derivative cancels the `L` of Cauchy's `1/ρ`; nothing grows with `L`. -/
theorem Dop_norm_le {F : ℂ → ℂ → ℂ} {α₀ β₀ : ℂ} {L r S : ℝ} (hL : 0 < L) (hr : 0 < r)
    (hFa : ∀ y ∈ closedBall β₀ (r / L), ∀ x ∈ closedBall α₀ (r / L),
      DifferentiableAt ℂ (fun x => F x y) x)
    (hFb : ∀ y ∈ closedBall β₀ (r / L), DifferentiableAt ℂ (fun y => F α₀ y) y)
    (hg : ∀ y ∈ closedBall β₀ (r / L), DifferentiableAt ℂ (fun y => pa F α₀ y) y)
    (hS : ∀ x ∈ closedBall α₀ (r / L), ∀ y ∈ closedBall β₀ (r / L), ‖F x y‖ ≤ S) :
    ‖Dop L F α₀ β₀‖ ≤ S * (1 + 2 / r + 1 / r ^ 2) := by
  have hρ : 0 < r / L := div_pos hr hL
  obtain ⟨h0, h1, h2, h3⟩ := cauchy_bounds hρ hFa hFb hg hS
  have hnL : ‖1 / (L : ℂ)‖ = 1 / L := by
    rw [norm_div, norm_one, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hL]
  have hnL2 : ‖1 / (L : ℂ) ^ 2‖ = 1 / L ^ 2 := by
    rw [norm_div, norm_one, norm_pow, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hL]
  unfold Dop
  have e1 : 1 / L * (S / (r / L) + S / (r / L)) = S * (2 / r) := by
    field_simp
    ring
  have e2 : 1 / L ^ 2 * (S / (r / L) / (r / L)) = S * (1 / r ^ 2) := by
    field_simp
  calc ‖F α₀ β₀ + 1 / (L : ℂ) * (pa F α₀ β₀ + pb F α₀ β₀) + 1 / (L : ℂ) ^ 2 * pab F α₀ β₀‖
      ≤ ‖F α₀ β₀‖ + ‖1 / (L : ℂ)‖ * (‖pa F α₀ β₀‖ + ‖pb F α₀ β₀‖) +
          ‖1 / (L : ℂ) ^ 2‖ * ‖pab F α₀ β₀‖ := by
        refine (norm_add_le _ _).trans (add_le_add ((norm_add_le _ _).trans
          (add_le_add le_rfl ?_)) (norm_mul _ _).le)
        rw [norm_mul]
        exact mul_le_mul_of_nonneg_left (norm_add_le _ _) (norm_nonneg _)
    _ ≤ S + 1 / L * (S / (r / L) + S / (r / L)) + 1 / L ^ 2 * (S / (r / L) / (r / L)) := by
        rw [hnL, hnL2]
        have hL1 : 0 ≤ 1 / L := by positivity
        have hL2 : 0 ≤ 1 / L ^ 2 := by positivity
        exact add_le_add (add_le_add h0 (mul_le_mul_of_nonneg_left (add_le_add h1 h2) hL1))
          (mul_le_mul_of_nonneg_left h3 hL2)
    _ = S * (1 + 2 / r + 1 / r ^ 2) := by rw [e1, e2]; ring

/-- **`D` is linear**: `D (A − B·c) = D A − (D B)·c`, given the partials it uses. -/
theorem Dop_sub_mul {A B : ℂ → ℂ → ℂ} {c : ℂ} (L : ℝ) {α₀ β₀ : ℂ}
    (hAa : ∀ᶠ y in 𝓝 β₀, DifferentiableAt ℂ (fun x => A x y) α₀)
    (hBa : ∀ᶠ y in 𝓝 β₀, DifferentiableAt ℂ (fun x => B x y) α₀)
    (hAb : DifferentiableAt ℂ (fun y => A α₀ y) β₀)
    (hBb : DifferentiableAt ℂ (fun y => B α₀ y) β₀)
    (hAg : DifferentiableAt ℂ (fun y => pa A α₀ y) β₀)
    (hBg : DifferentiableAt ℂ (fun y => pa B α₀ y) β₀) :
    Dop L (fun x y => A x y - B x y * c) α₀ β₀ = Dop L A α₀ β₀ - Dop L B α₀ β₀ * c := by
  have hpa : ∀ y, DifferentiableAt ℂ (fun x => A x y) α₀ → DifferentiableAt ℂ (fun x => B x y) α₀ →
      pa (fun x y => A x y - B x y * c) α₀ y = pa A α₀ y - pa B α₀ y * c := by
    intro y ha hb
    unfold pa
    rw [deriv_fun_sub ha (hb.mul_const c), deriv_mul_const hb]
  have hev : (fun y => pa (fun x y => A x y - B x y * c) α₀ y) =ᶠ[𝓝 β₀]
      fun y => pa A α₀ y - pa B α₀ y * c := by
    filter_upwards [hAa, hBa] with y ha hb
    exact hpa y ha hb
  have hpb : pb (fun x y => A x y - B x y * c) α₀ β₀ = pb A α₀ β₀ - pb B α₀ β₀ * c := by
    unfold pb
    rw [deriv_fun_sub hAb (hBb.mul_const c), deriv_mul_const hBb]
  have hpab : pab (fun x y => A x y - B x y * c) α₀ β₀ = pab A α₀ β₀ - pab B α₀ β₀ * c := by
    unfold pab
    rw [hev.deriv_eq, deriv_fun_sub hAg (hBg.mul_const c), deriv_mul_const hBg]
  unfold Dop
  rw [hpa β₀ hAa.self_of_nhds hBa.self_of_nhds, hpb, hpab]
  ring

/-- **Partials of an analytic function of two variables.** For `f` analytic on an open
`U ⊆ ℂ × ℂ`: at every point of `U` the partials in each variable exist, and the partial in
the first variable is differentiable in the second. -/
theorem analytic_partials {f : ℂ × ℂ → ℂ} {U : Set (ℂ × ℂ)} (hU : IsOpen U)
    (hf : AnalyticOnNhd ℂ f U) :
    (∀ p ∈ U, DifferentiableAt ℂ (fun x => f (x, p.2)) p.1) ∧
    (∀ p ∈ U, DifferentiableAt ℂ (fun y => f (p.1, y)) p.2) ∧
    (∀ p ∈ U, DifferentiableAt ℂ (fun y => pa (fun x y => f (x, y)) p.1 y) p.2) := by
  have hx : ∀ (a b : ℂ), HasDerivAt (fun x : ℂ => (x, b)) ((1 : ℂ), (0 : ℂ)) a :=
    fun a b => (hasDerivAt_id a).prodMk (hasDerivAt_const a b)
  have hy : ∀ (a b : ℂ), HasDerivAt (fun y : ℂ => (a, y)) ((0 : ℂ), (1 : ℂ)) b :=
    fun a b => (hasDerivAt_const b a).prodMk (hasDerivAt_id b)
  have hda : ∀ q ∈ U, HasDerivAt (fun x => f (x, q.2)) (fderiv ℂ f q ((1 : ℂ), (0 : ℂ))) q.1 := by
    intro q hq
    have h := ((hf q hq).differentiableAt.hasFDerivAt).comp_hasDerivAt q.1 (hx q.1 q.2)
    exact h
  refine ⟨fun p hp => (hda p hp).differentiableAt, fun p hp => ?_, fun p hp => ?_⟩
  · exact ((hf p hp).differentiableAt.hasFDerivAt.comp_hasDerivAt p.2 (hy p.1 p.2)).differentiableAt
  · have hev : (fun y => pa (fun x y => f (x, y)) p.1 y) =ᶠ[𝓝 p.2]
        fun y => fderiv ℂ f (p.1, y) ((1 : ℂ), (0 : ℂ)) := by
      have hc : Continuous fun y : ℂ => (p.1, y) := by fun_prop
      have hmem : ∀ᶠ y in 𝓝 p.2, (p.1, y) ∈ U :=
        hc.continuousAt.preimage_mem_nhds (hU.mem_nhds (by simpa using hp))
      filter_upwards [hmem] with y hy'
      exact (hda (p.1, y) hy').deriv
    refine DifferentiableAt.congr_of_eventuallyEq ?_ hev
    have hd : DifferentiableAt ℂ (fun y => fderiv ℂ f (p.1, y)) p.2 :=
      ((hf.fderiv p hp).differentiableAt).comp p.2 (hy p.1 p.2).differentiableAt
    exact hd.clm_apply (differentiableAt_const _)

/-- info: 'Operator.cauchy_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cauchy_bounds

/-- info: 'Operator.Dop_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Dop_norm_le

/-- info: 'Operator.Dop_sub_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Dop_sub_mul

/-- info: 'Operator.analytic_partials' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analytic_partials

end Operator
