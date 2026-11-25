/-
# FloorQCont — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: continuity in `σ` for `V ψ`. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

`FloorStepCont` with `G = ζ + cζ′` replaced by `V = W/Gammaℝ`. `GrRatio.window_V_lt_half'`
gives the mean of `‖V ψ‖²` at `σ = σ₀` alone; `FloorQWindow.conrey_window_diff` asks it on
`[σ₀ − δ, σ₀]`. The integrand `FintV σ t = ‖V(σ + it) ψ(σ + it)‖²` is jointly continuous on
`t > 0` (`V` is analytic on `Im > 0`, `FloorQGamma.analyticAt_V_im`), so uniformly continuous
on `[σ₀ − 1/8, σ₀] × [T/2, T]`, and some `δ(T) > 0` moves the mean by at most `ε/2`. `δ`
depends on `T`; no size of `δ` enters the window's conclusion.

| name | content | status |
|---|---|---|
| `FintV` | the integrand | defined |
| `continuousOn_FintV`, `continuous_FintV` | joint continuity on `t > 0`; continuity in `t` on `t > 0` | proved |
| `FintV_shift`, `meanV_shift`, `hK_shiftV` | the copies of `Fint_shift`, `mean_shift`, `hK_shift` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorQGamma
import Stage3.FloorStepCont

namespace FloorQ

open Complex MeasureTheory Set Filter Topology

/-- The integrand of the window's mean for `V ψ` at `σ + t i`. -/
noncomputable
def FintV (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) (σ t : ℝ) : ℝ :=
  ‖ConreyCount.V Q L (↑σ + ↑t * I) * LevinsonMollEdge.molli M β (↑σ + ↑t * I)‖ ^ 2

theorem continuousOn_FintV (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) :
    ContinuousOn (fun p : ℝ × ℝ => FintV Q L M β p.1 p.2) {p | 0 < p.2} := by
  have hmap : Continuous fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I := by fun_prop
  have hmaps : MapsTo (fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I) {p | 0 < p.2}
      {w : ℂ | 0 < w.im} := by
    intro p hp
    show 0 < ((p.1 : ℂ) + (p.2 : ℂ) * I).im
    simpa using hp
  have hV : ContinuousOn (ConreyCount.V Q L) {w : ℂ | 0 < w.im} :=
    fun w hw => (analyticAt_V_im Q L hw).continuousAt.continuousWithinAt
  have hG : ContinuousOn (fun s : ℂ => ‖ConreyCount.V Q L s
      * LevinsonMollEdge.molli M β s‖ ^ 2) {w : ℂ | 0 < w.im} :=
    (hV.mul (FloorStep.continuous_molli M β).continuousOn).norm.pow 2
  exact hG.comp hmap.continuousOn hmaps

theorem continuousOn_FintV_t (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) (σ : ℝ) :
    ContinuousOn (FintV Q L M β σ) (Ioi 0) := by
  have h := continuousOn_FintV Q L M β
  have hmap : Continuous fun t : ℝ => ((σ, t) : ℝ × ℝ) := by fun_prop
  have h2 : ContinuousOn ((fun p : ℝ × ℝ => FintV Q L M β p.1 p.2) ∘
      fun t : ℝ => ((σ, t) : ℝ × ℝ)) (Ioi 0) :=
    h.comp hmap.continuousOn (fun t ht => ht)
  have h3 : ((fun p : ℝ × ℝ => FintV Q L M β p.1 p.2) ∘ fun t : ℝ => ((σ, t) : ℝ × ℝ)) =
      FintV Q L M β σ := rfl
  rw [h3] at h2
  exact h2

/-- **Continuity in `σ`, uniform in `t ∈ [A, B]`, `A > 0`.** -/
theorem FintV_shift (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ₀ A B ε : ℝ}
    (hA : 0 < A) (hε : 0 < ε) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 / 8 ∧ ∀ σ ∈ Icc (σ₀ - δ) σ₀, ∀ t ∈ Icc A B,
      FintV Q L M β σ t ≤ FintV Q L M β σ₀ t + ε := by
  set S : Set (ℝ × ℝ) := Icc (σ₀ - 1 / 8) σ₀ ×ˢ Icc A B with hS
  have hSc : IsCompact S := isCompact_Icc.prod isCompact_Icc
  have hSsub : S ⊆ {p | 0 < p.2} := by
    intro p hp
    have := (Set.mem_prod.mp hp).2.1
    show 0 < p.2
    linarith
  have hU := hSc.uniformContinuousOn_of_continuous ((continuousOn_FintV Q L M β).mono hSsub)
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

/-- A pointwise shift by `ε` on `[a′, b′] ⊆ (0, ∞)` moves the mean by at most `ε`. -/
theorem meanV_shift (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ σ₀ a' b' ε : ℝ}
    (ha : 0 < a') (hab : a' < b')
    (h : ∀ t ∈ Icc a' b', FintV Q L M β σ t ≤ FintV Q L M β σ₀ t + ε) :
    (1 / (b' - a')) * ∫ t in a'..b', FintV Q L M β σ t ≤
      (1 / (b' - a')) * (∫ t in a'..b', FintV Q L M β σ₀ t) + ε := by
  have hsub : uIcc a' b' ⊆ Ioi 0 := by
    rw [uIcc_of_le hab.le]
    intro t ht
    exact lt_of_lt_of_le ha ht.1
  have hi1 : IntervalIntegrable (FintV Q L M β σ) volume a' b' :=
    ((continuousOn_FintV_t Q L M β σ).mono hsub).intervalIntegrable
  have hi0 : IntervalIntegrable (FintV Q L M β σ₀) volume a' b' :=
    ((continuousOn_FintV_t Q L M β σ₀).mono hsub).intervalIntegrable
  have hmono := intervalIntegral.integral_mono_on hab.le hi1
    (hi0.add intervalIntegrable_const) h
  rw [intervalIntegral.integral_add hi0 intervalIntegrable_const,
    intervalIntegral.integral_const, smul_eq_mul] at hmono
  have hd : 0 < b' - a' := by linarith
  have hd' : 0 < 1 / (b' - a') := by positivity
  have e : 1 / (b' - a') * ((b' - a') * ε) = ε := by field_simp
  calc (1 / (b' - a')) * ∫ t in a'..b', FintV Q L M β σ t
      ≤ (1 / (b' - a')) * ((∫ t in a'..b', FintV Q L M β σ₀ t) + (b' - a') * ε) :=
        mul_le_mul_of_nonneg_left hmono hd'.le
    _ = _ := by rw [mul_add, e]

/-- **The mean from `σ₀` to `[σ₀ − δ, σ₀]`.** For `T > 0`: if the mean at `σ₀` is at most
`K + ε/2` on every window `[a′, b′]`, `a′ ∈ [T/2, T/2 + 1]`, `b′ ∈ [T − 1, T]`, then for some
`δ ∈ (0, 1/8]` the mean at every `σ ∈ [σ₀ − δ, σ₀]` is at most `K + ε` there. -/
theorem hK_shiftV (Q : Polynomial ℝ) (L : ℝ) (M : ℕ) (β : ℕ → ℂ) {σ₀ T K ε : ℝ}
    (hT : 0 < T) (hε : 0 < ε)
    (h0 : ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b', FintV Q L M β σ₀ t ≤ K + ε / 2) :
    ∃ δ : ℝ, 0 < δ ∧ δ ≤ 1 / 8 ∧ ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' →
      b' ≤ T → a' < b' → ∀ σ ∈ Icc (σ₀ - δ) σ₀,
      (1 / (b' - a')) * ∫ t in a'..b', FintV Q L M β σ t ≤ K + ε := by
  obtain ⟨δ, hδ, hδ8, hδF⟩ := FintV_shift Q L M β (σ₀ := σ₀) (A := T / 2) (B := T)
    (by linarith) (half_pos hε)
  refine ⟨δ, hδ, hδ8, fun a' b' ha1 ha2 hb1 hb2 hab σ hσ => ?_⟩
  have hpt : ∀ t ∈ Icc a' b', FintV Q L M β σ t ≤ FintV Q L M β σ₀ t + ε / 2 :=
    fun t ht => hδF σ hσ t ⟨by linarith [ht.1], by linarith [ht.2]⟩
  have h1 := meanV_shift Q L M β (by linarith) hab hpt
  have h2 := h0 a' b' ha1 ha2 hb1 hb2
  linarith

/-- info: 'FloorQ.continuousOn_FintV' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuousOn_FintV

/-- info: 'FloorQ.FintV_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms FintV_shift

/-- info: 'FloorQ.meanV_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms meanV_shift

/-- info: 'FloorQ.hK_shiftV' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms hK_shiftV

end FloorQ
