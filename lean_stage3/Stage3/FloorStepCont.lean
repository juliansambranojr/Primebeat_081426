/-
# FloorStepCont — block S12 of `lean_stage3/design/stencil.md`, piece 5b, one height: continuity in `σ`. 2026-11-25.

`LevinsonWindowNear.levinson_window_diff` asks its mean bound `hK` for every `σ ∈ [σ₀ − δ, σ₀]`;
`Unsmooth.unsmooth_near_levinson` gives it at `σ = σ₀` alone. For one `T` the integrand
`Fint c M β σ t = ‖(ζ + c ζ′)(σ + t i) · molli M β (σ + t i)‖²` is jointly continuous off
`σ = 1`, so uniformly continuous on the compact `[σ₀ − 1/8, σ₀] × [T/2, T]`: some `δ(T) > 0`
moves it by at most `ε/2` for `|σ − σ₀| ≤ δ`, uniformly in `t`, and the mean over any
`[a′, b′] ⊆ [T/2, T]` moves by at most `ε/2`. `δ` depends on `T`; `levinson_window_diff`
takes `δ` per height, and no size of `δ` enters its conclusion.

| name | content | status |
|---|---|---|
| `Fint` | the integrand of `hK` | defined |
| `continuous_molli` | `molli M β` is continuous | proved |
| `continuousOn_Fint`, `continuous_Fint` | joint continuity off `σ = 1`; continuity in `t` | proved |
| `Fint_shift` | `Fint σ t ≤ Fint σ₀ t + ε` for `σ ∈ [σ₀ − δ, σ₀]`, `t ∈ [A, B]` | proved |
| `mean_shift` | the pointwise shift moves the mean by `ε` | proved |
| `hK_shift` | `hK` on `[σ₀ − δ, σ₀]` from the bound at `σ₀` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Unsmooth
import Stage3.LevinsonWindowNear

namespace FloorStep

open Complex MeasureTheory Set Filter Topology

/-- The integrand of `levinson_window_diff`'s `hK` at `σ + t i`. -/
noncomputable
def Fint (c : ℝ) (M : ℕ) (β : ℕ → ℂ) (σ t : ℝ) : ℝ :=
  ‖(riemannZeta (↑σ + ↑t * I) + c * deriv riemannZeta (↑σ + ↑t * I))
    * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2

theorem continuous_molli (M : ℕ) (β : ℕ → ℂ) : Continuous (LevinsonMollEdge.molli M β) := by
  unfold LevinsonMollEdge.molli
  refine continuous_finsetSum _ fun h hh => ?_
  have h1 : 1 ≤ h := (Finset.mem_Icc.mp hh).1
  have hne : (h : ℂ) ≠ 0 := by exact_mod_cast (show h ≠ 0 by omega)
  exact continuous_const.mul (continuous_neg.const_cpow (Or.inl hne))

theorem continuousOn_Fint (c : ℝ) (M : ℕ) (β : ℕ → ℂ) :
    ContinuousOn (fun p : ℝ × ℝ => Fint c M β p.1 p.2) {p | p.1 ≠ 1} := by
  have hmap : Continuous fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I := by fun_prop
  have hmaps : MapsTo (fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I) {p | p.1 ≠ 1} {1}ᶜ := by
    intro p hp h
    have h1 := congrArg Complex.re (Set.mem_singleton_iff.mp h)
    simp at h1
    exact hp h1
  have hG : ContinuousOn (fun s : ℂ => ‖(riemannZeta s + c * deriv riemannZeta s)
      * LevinsonMollEdge.molli M β s‖ ^ 2) {1}ᶜ := by
    refine ((ContinuousOn.add Operator.zeta_diffOn.continuousOn
      (continuousOn_const.mul Operator.dzeta_diffOn.continuousOn)).mul
      (continuous_molli M β).continuousOn).norm.pow 2
  exact hG.comp hmap.continuousOn hmaps

theorem continuous_Fint (c : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ : ℝ} (hσ : σ ≠ 1) :
    Continuous (Fint c M β σ) := by
  have h := continuousOn_Fint c M β
  have hmap : Continuous fun t : ℝ => ((σ, t) : ℝ × ℝ) := by fun_prop
  have h2 : ContinuousOn ((fun p : ℝ × ℝ => Fint c M β p.1 p.2) ∘ fun t : ℝ => ((σ, t) : ℝ × ℝ))
      Set.univ := h.comp hmap.continuousOn (fun t _ => hσ)
  have h3 : ((fun p : ℝ × ℝ => Fint c M β p.1 p.2) ∘ fun t : ℝ => ((σ, t) : ℝ × ℝ)) =
      Fint c M β σ := rfl
  rw [h3] at h2
  exact continuousOn_univ.mp h2

/-- **Continuity in `σ`, uniform in `t`.** -/
theorem Fint_shift (c : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ₀ A B ε : ℝ} (hσ₀ : σ₀ < 1) (hε : 0 < ε) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 / 8 ∧ ∀ σ ∈ Icc (σ₀ - δ) σ₀, ∀ t ∈ Icc A B,
      Fint c M β σ t ≤ Fint c M β σ₀ t + ε := by
  set S : Set (ℝ × ℝ) := Icc (σ₀ - 1 / 8) σ₀ ×ˢ Icc A B with hS
  have hSc : IsCompact S := isCompact_Icc.prod isCompact_Icc
  have hSsub : S ⊆ {p | p.1 ≠ 1} := by
    intro p hp
    have := (Set.mem_prod.mp hp).1.2
    show p.1 ≠ 1
    linarith
  have hU := hSc.uniformContinuousOn_of_continuous ((continuousOn_Fint c M β).mono hSsub)
  obtain ⟨δ, hδ, hδU⟩ := Metric.uniformContinuousOn_iff.mp hU ε hε
  refine ⟨min (δ / 2) (1 / 8), by positivity, min_le_right _ _, fun σ hσ t ht => ?_⟩
  have hm1 := min_le_left (δ / 2) (1 / 8)
  have hm2 := min_le_right (δ / 2) (1 / 8)
  have hp : ((σ, t) : ℝ × ℝ) ∈ S := Set.mk_mem_prod ⟨by linarith [hσ.1], hσ.2⟩ ht
  have hq : ((σ₀, t) : ℝ × ℝ) ∈ S := Set.mk_mem_prod ⟨by linarith, le_rfl⟩ ht
  have hd : dist ((σ, t) : ℝ × ℝ) (σ₀, t) < δ := by
    rw [Prod.dist_eq, dist_self, Real.dist_eq, abs_of_nonpos (by linarith [hσ.2])]
    rw [max_eq_left (by linarith [hσ.2])]
    linarith [hσ.1]
  have h := hδU _ hp _ hq hd
  rw [Real.dist_eq] at h
  have h2 := (abs_lt.mp h).2
  simp only at h2
  linarith

/-- A pointwise shift by `ε` on `[a′, b′]` moves the mean by at most `ε`. -/
theorem mean_shift (c : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ σ₀ a' b' ε : ℝ} (hσ : σ ≠ 1) (hσ₀ : σ₀ ≠ 1)
    (hab : a' < b') (h : ∀ t ∈ Icc a' b', Fint c M β σ t ≤ Fint c M β σ₀ t + ε) :
    (1 / (b' - a')) * ∫ t in a'..b', Fint c M β σ t ≤
      (1 / (b' - a')) * (∫ t in a'..b', Fint c M β σ₀ t) + ε := by
  have hi1 : IntervalIntegrable (Fint c M β σ) volume a' b' :=
    (continuous_Fint c M β hσ).intervalIntegrable (μ := volume) _ _
  have hi0 : IntervalIntegrable (Fint c M β σ₀) volume a' b' :=
    (continuous_Fint c M β hσ₀).intervalIntegrable (μ := volume) _ _
  have hmono := intervalIntegral.integral_mono_on hab.le hi1
    (hi0.add intervalIntegrable_const) h
  rw [intervalIntegral.integral_add hi0 intervalIntegrable_const,
    intervalIntegral.integral_const, smul_eq_mul] at hmono
  have hd : 0 < b' - a' := by linarith
  have hd' : 0 < 1 / (b' - a') := by positivity
  have e : 1 / (b' - a') * ((b' - a') * ε) = ε := by field_simp
  calc (1 / (b' - a')) * ∫ t in a'..b', Fint c M β σ t
      ≤ (1 / (b' - a')) * ((∫ t in a'..b', Fint c M β σ₀ t) + (b' - a') * ε) :=
        mul_le_mul_of_nonneg_left hmono hd'.le
    _ = _ := by rw [mul_add, e]


/-- **`hK` from `σ₀` to `[σ₀ − δ, σ₀]`.** If the mean at `σ₀` is at most `V + ε/2` on every
window `[a′, b′]`, `a′ ∈ [T/2, T/2 + 1]`, `b′ ∈ [T − 1, T]`, then for some `δ ∈ (0, 1/8]` the
mean at every `σ ∈ [σ₀ − δ, σ₀]` is at most `V + ε` on the same windows. -/
theorem hK_shift (c : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ₀ T V ε : ℝ} (hσ₀ : σ₀ < 1) (hε : 0 < ε)
    (h0 : ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b', Fint c M β σ₀ t ≤ V + ε / 2) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 / 8 ∧ ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' →
      b' ≤ T → a' < b' → ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b', Fint c M β σ t ≤ V + ε := by
  obtain ⟨δ, hδ, hδ8, hδF⟩ := Fint_shift c M β (A := T / 2) (B := T) hσ₀ (half_pos hε)
  refine ⟨δ, hδ, hδ8, fun a' b' ha1 ha2 hb1 hb2 hab σ hσ => ?_⟩
  have hσ1 : σ ≠ 1 := by linarith [hσ.2]
  have hpt : ∀ t ∈ Icc a' b', Fint c M β σ t ≤ Fint c M β σ₀ t + ε / 2 :=
    fun t ht => hδF σ hσ t ⟨by linarith [ht.1], by linarith [ht.2]⟩
  have h1 := mean_shift c M β hσ1 hσ₀.ne hab hpt
  have h2 := h0 a' b' ha1 ha2 hb1 hb2
  linarith

/-- info: 'FloorStep.continuous_molli' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuous_molli

/-- info: 'FloorStep.continuousOn_Fint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuousOn_Fint

/-- info: 'FloorStep.continuous_Fint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuous_Fint

/-- info: 'FloorStep.Fint_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Fint_shift

/-- info: 'FloorStep.mean_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mean_shift

/-- info: 'FloorStep.hK_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hK_shift

end FloorStep
