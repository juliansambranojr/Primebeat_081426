/-
# FloorQ — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: a proved floor above one third. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

At Conrey's `Q₀(x) = 1 − (27/50)x − (36/25)x² + (24/25)x³`, `P₀(x) = (87/100)x − (1/100)x² +
(7/50)x³`, `θ = 49/100`, `R = 3/2`: for every `ε > 0`, from some height on,

  `(224/625 − ε) N T ≤ lineCount T`,

the zeros of `ζ` on the line with height in `(0, T]`, with multiplicity. `224/625 = 0.3584 > 1/3`.

The route, a copy of `FloorSum`.
1. `FloorConstQ.floor_constQ`: `Re DopQ(cY)(T) → K = KflQ Q₀ A B C (49/100) (3/2)` and
   `log K < (3/2)(1 − 224/625)`. With `K' = max 1 K`, `log K' ≤ (3/2)(1 − 224/625)` (the
   right side is positive), and eventually `max 1 (Re D + ε₁) ≤ K' + 2ε₁`, so
   `log(max …)/R ≤ 1 − 224/625 + 2ε₁` (`logmaxQ_le`). No lower bound on `K` is needed.
2. `FloorQStep.floor_stepQ` at `ε₁`, `N T − N(T/2) ≥ 0`: the window floor with proportion
   `224/625 − 2ε₁` (`stepQ`).
3. `FloorSumTele.tele_floor` and `FloorSum.N_ge` as in `FloorSum.levinson_floor`.

The sizes are those of `FloorSum` with `1/3` replaced by `224/625 < 1/2`: with
`ε' = min ε (1/6)`, `ε₁ = ε'/80`, the losses are `(ε'/40) N T`, `(ε'/2) N T` and
`(224/625) N T₁ ≤ (ε'/80) N T` once `T ≥ 1600 N T₁/ε'`.

| name | content | status |
|---|---|---|
| `logmaxQ_le` | `log (max 1 x)/(3/2) ≤ 1 − 224/625 + 2ε₁` for `x ≤ K + 2ε₁` | proved |
| `stepQ` | the window floor at `P₀`, `Q₀` with proportion `224/625 − 2ε₁` | proved |
| `levinson_floorQ` | `(224/625 − ε) N T ≤ lineCount T` from some height on | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorQStep
import Stage3.FloorConstQ
import Stage3.FloorSum

namespace FloorQ

open Complex Filter Topology TwistedMoment FloorConstQ

/-- The `max 1` and the `ε₁` of `floor_stepQ`, priced at `Q₀`, `P₀`, `θ = 49/100`, `R = 3/2`. -/
theorem logmaxQ_le {x ε₁ : ℝ} (hε₁ : 0 < ε₁)
    (hx : x ≤ KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2)
      + 2 * ε₁) :
    Real.log (max 1 x) / (3 / 2) ≤ (1 - 224 / 625) + 2 * ε₁ := by
  have hlK := (floor_constQ).2.1
  obtain ⟨K, hKdef⟩ : ∃ K : ℝ,
      K = KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2) :=
    ⟨_, rfl⟩
  rw [← hKdef] at hlK hx
  obtain ⟨K', hK'def⟩ : ∃ K' : ℝ, K' = max 1 K := ⟨_, rfl⟩
  have hK'1 : 1 ≤ K' := by rw [hK'def]; exact le_max_left _ _
  have hlK' : Real.log K' ≤ 3 / 2 * (1 - 224 / 625) := by
    rw [hK'def]
    rcases le_total K 1 with h | h
    · rw [max_eq_left h, Real.log_one]; norm_num
    · rw [max_eq_right h]; exact hlK.le
  have hK'0 : 0 < K' := by linarith
  have hm : max 1 x ≤ K' + 2 * ε₁ := by
    refine max_le (by linarith) ?_
    have : K ≤ K' := by rw [hK'def]; exact le_max_right _ _
    linarith
  have h1 : Real.log (max 1 x) ≤ Real.log (K' + 2 * ε₁) :=
    Real.log_le_log (by positivity) hm
  have h2 : Real.log (K' + 2 * ε₁) - Real.log K' ≤ 2 * ε₁ := by
    rw [← Real.log_div (by positivity) hK'0.ne']
    have h3 := Real.log_le_sub_one_of_pos (show 0 < (K' + 2 * ε₁) / K' by positivity)
    have h4 : (K' + 2 * ε₁) / K' - 1 = 2 * ε₁ / K' := by field_simp; ring
    have h5 : 2 * ε₁ / K' ≤ 2 * ε₁ := div_le_self (by positivity) hK'1
    linarith
  rw [div_le_iff₀ (by norm_num)]
  linarith

/-- **The window floor at `P₀`, `Q₀`.** For `ε₁ > 0`, from some height `T₁ ≥ 1` on,
`(224/625 − 2ε₁)(N T − N(T/2)) − ε₁ T log T ≤ lineCount T − lineCount(T/2)`. -/
theorem stepQ {ε₁ : ℝ} (hε₁ : 0 < ε₁) : ∃ T₁ : ℝ, 1 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
    (224 / 625 - 2 * ε₁) * (riemannZeta.N T - riemannZeta.N (T / 2)) - ε₁ * T * Real.log T
      ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
  obtain ⟨T₂, h₂⟩ := floor_stepQ Q0 P0 Q0_deriv_symm (by
      rw [show Q0.eval (1 / 2) = 49 / 100 by simp [Q0]; norm_num]; norm_num) Q0_zero
    P0_zero P0_one (θ := 49 / 100) (by norm_num) (by norm_num) (R := 3 / 2) (by norm_num)
    ε₁ hε₁
  have hlim := (floor_constQ.1).eventually
    (Iic_mem_nhds (lt_add_of_pos_right
      (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2)) hε₁))
  obtain ⟨T₃, h₃⟩ := eventually_atTop.mp hlim
  refine ⟨max 1 (max T₂ T₃), le_max_left _ _, fun T hT => ?_⟩
  have hT2 : T₂ ≤ T := (le_max_left _ _).trans ((le_max_right _ _).trans hT)
  have hT3 : T₃ ≤ T := (le_max_right _ _).trans ((le_max_right _ _).trans hT)
  have hs := h₂ T hT2
  have hD : (MeanQ.DopQ Q0 (Real.log T) (cY P0 (Mof T (49 / 100)) T)
      ((-((3 / 2) / Real.log T) : ℝ) : ℂ) ((-((3 / 2) / Real.log T) : ℝ) : ℂ)).re
        ≤ KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2)
          + ε₁ := h₃ T hT3
  have ha := logmaxQ_le hε₁ (x := (MeanQ.DopQ Q0 (Real.log T) (cY P0 (Mof T (49 / 100)) T)
      ((-((3 / 2) / Real.log T) : ℝ) : ℂ) ((-((3 / 2) / Real.log T) : ℝ) : ℂ)).re + ε₁)
    (by linarith)
  have hN : 0 ≤ riemannZeta.N T - riemannZeta.N (T / 2) := by
    have := ArgCount.N_mono (show T / 2 ≤ T by linarith [(le_max_left _ _).trans hT])
    linarith
  have hm := mul_le_mul_of_nonneg_right ha hN
  linarith

/-- **B4 step 5, a proved floor above one third.** At `Q₀`, `P₀`, `θ = 49/100`, `R = 3/2`: for
every `ε > 0`, from some height on, at least `(224/625 − ε) N T` of the zeros of `ζ` with height
in `(0, T]` lie on the critical line, counted with multiplicity. -/
theorem levinson_floorQ : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (224 / 625 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) := by
  intro ε hε
  obtain ⟨ε', hε'def⟩ : ∃ ε' : ℝ, ε' = min ε (1 / 6) := ⟨_, rfl⟩
  have hε'0 : 0 < ε' := by rw [hε'def]; exact lt_min hε (by norm_num)
  have hε'ε : ε' ≤ ε := by rw [hε'def]; exact min_le_left _ _
  have hε'6 : ε' ≤ 1 / 6 := by rw [hε'def]; exact min_le_right _ _
  obtain ⟨T₁, hT₁, hstep⟩ := stepQ (ε₁ := ε' / 80) (by positivity)
  have hfl := FloorSum.tele_floor (f := fun T => (LineCount.lineCount T : ℝ)) (g := riemannZeta.N)
    (c := 224 / 625 - 2 * (ε' / 80)) (e := ε' / 80) hT₁ (by positivity) (by linarith)
    (fun T => by exact_mod_cast LevinsonWindowNear.lineCount_nonneg T)
    (fun a b h => ArgCount.N_mono h) hstep
  obtain ⟨T₄, h₄⟩ := eventually_atTop.mp
    (FloorSum.N_ge.and (Real.tendsto_log_atTop.eventually_ge_atTop 1))
  refine ⟨max (max T₁ T₄) (max 1 (1600 * riemannZeta.N T₁ / ε')), fun T hT => ?_⟩
  have hTT₁ : T₁ ≤ T := (le_max_left _ _).trans ((le_max_left _ _).trans hT)
  have hTT₄ : T₄ ≤ T := (le_max_right _ _).trans ((le_max_left _ _).trans hT)
  have hT1 : 1 ≤ T := (le_max_left _ _).trans ((le_max_right _ _).trans hT)
  have hTN : 1600 * riemannZeta.N T₁ / ε' ≤ T :=
    (le_max_right _ _).trans ((le_max_right _ _).trans hT)
  have hfT := hfl T hTT₁
  obtain ⟨hNT, hlog1⟩ := h₄ T hTT₄
  have hN0 := ArgCount.N_nonneg T
  have hN10 := ArgCount.N_nonneg T₁
  rw [div_le_iff₀ hε'0] at hTN
  have hA : ε' * (T * Real.log T / 20) ≤ ε' * riemannZeta.N T :=
    mul_le_mul_of_nonneg_left hNT hε'0.le
  have hTL : T ≤ T * Real.log T := by nlinarith
  have hC : ε' * T ≤ ε' * (T * Real.log T) := mul_le_mul_of_nonneg_left hTL hε'0.le
  have hD : 0 ≤ ε' * riemannZeta.N T₁ := mul_nonneg hε'0.le hN10
  have hB : (224 / 625 - ε) * riemannZeta.N T ≤ (224 / 625 - ε') * riemannZeta.N T :=
    mul_le_mul_of_nonneg_right (by linarith) hN0
  have e1 : ε' * (T * Real.log T / 20) = ε' * (T * Real.log T) / 20 := by ring
  have e2 : (224 / 625 - 2 * (ε' / 80)) * (riemannZeta.N T - riemannZeta.N T₁)
      - 2 * (ε' / 80) * T * Real.log T = 224 / 625 * riemannZeta.N T
        - ε' * riemannZeta.N T / 40 - 224 / 625 * riemannZeta.N T₁
        + ε' * riemannZeta.N T₁ / 40 - ε' * (T * Real.log T) / 40 := by
    ring
  rw [e1] at hA
  rw [e2] at hfT
  have e3 : (224 / 625 - ε') * riemannZeta.N T =
      224 / 625 * riemannZeta.N T - ε' * riemannZeta.N T := by ring
  rw [e3] at hB
  linarith

/-- info: 'FloorQ.logmaxQ_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logmaxQ_le

/-- info: 'FloorQ.stepQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stepQ

/-- info: 'FloorQ.levinson_floorQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_floorQ

end FloorQ
