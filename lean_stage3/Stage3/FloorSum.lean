/-
# FloorSum — block S12 of `lean_stage3/design/stencil.md`, piece 5c, the sum: a positive proportion of the zeros on the line. 2026-11-25.

At Levinson's `P(x) = x`, `θ = 49/100`, `R = 13/10`: for every `ε > 0`, from some height on,

  `(1/3 − ε) N T ≤ lineCount T`.

The route.
1. `FloorConst.floor_const`: `Re D[c](T) → K = Kfl 1 (1/2) (1/3) (49/100) (13/10)` and
   `1/3 ≤ 1 − log K / R`, so `log K ≤ 13/15`. `1 ≤ K` from `Kfl_levinson_eq` and the Taylor
   bound on `e^(13/10)` (`K_ge_one`), so the `max 1` of `floor_step` is harmless: eventually
   `max 1 (Re D + ε₁) ≤ K + 2ε₁` and `log (K + 2ε₁) ≤ log K + 2ε₁`, so `log(max …)/R ≤ 2/3 + 2ε₁`.
2. `FloorStep.floor_step` at `ε₁`, with `N T − N(T/2) ≥ 0` (`ArgCount.N_mono`):
   `(1/3 − 2ε₁)(N T − N(T/2)) − ε₁ T log T ≤ lineCount T − lineCount(T/2)` (`step_X`).
3. `FloorSumTele.tele_floor`: `(1/3 − 2ε₁)(N T − N T₁) − 2ε₁ T log T ≤ lineCount T`.
4. `N T ≥ T log T / 20` eventually, from `FloorStep.N_window_ge` (`N T ≥ N T − N(T/2) ≥
   T log T/(4π) − T − 224 log T − 1396`, and `1/(4π) − 1/20 ≥ 1/40`) (`N_ge`).

The sizes, checked before the proof. With `ε' = min ε (1/6)` and `ε₁ = ε'/80`:
`2ε₁ T log T = (ε'/40) T log T ≤ (ε'/2) N T` by step 4; `(1/3) N T₁ ≤ (ε'/3) N T` once
`ε' N T ≥ 80 N T₁`, which holds for `T ≥ 1600 N T₁ / ε'` since `N T ≥ T/20`. Total loss
`(ε'/40)(N T) + (ε'/2) N T + (ε'/3) N T ≤ ε' N T`. The telescoping loses no factor of `log T`
(`Σ_j (T/2^j) log(T/2^j) ≤ 2 T log T`, `FloorSumTele.tele`); the halving step `T/2` is fixed, so
the count of windows, about `log₂ (T/T₁)`, enters nowhere. The proportion is `1/3` because
`kappa_levinson_ge` proves `κ ≥ 1/3`; the computed `κ = 0.3353…` is unproved.

| name | content | status |
|---|---|---|
| `K_ge_one` | `1 ≤ Kfl 1 (1/2) (1/3) (49/100) (13/10)` | proved |
| `log_K_le` | `log K ≤ 13/15` | proved |
| `logmax_le` | `log (max 1 x) / (13/10) ≤ 2/3 + 2ε₁` for `x ≤ K + 2ε₁` | proved |
| `step_X` | the window floor at `P = X` with proportion `1/3 − 2ε₁` | proved |
| `N_ge` | `T log T / 20 ≤ N T` eventually | proved |
| `levinson_floor` | `(1/3 − ε) N T ≤ lineCount T` from some height on | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorStep
import Stage3.FloorConst
import Stage3.FloorSumTele

namespace FloorSum

open Complex Filter Topology TwistedMoment FloorConst

/-- `1 ≤ K` at `P(x) = x`, `θ = 49/100`, `R = 13/10`. -/
theorem K_ge_one : 1 ≤ Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) := by
  rw [Kfl_levinson_eq]
  have h := exp_13_10_bounds.1
  have h2 : ((1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13) ^ 2 ≤ Real.exp (13 / 10) ^ 2 :=
    pow_le_pow_left₀ (by norm_num) h 2
  have h3 : (1 : ℝ) ≤ -760154441 / 645918000 + 3405769 / 12918360 *
      ((1 + 1 / 10 + 1 / 200 + 1 / 6000 : ℝ) ^ 13) ^ 2 := by norm_num
  linarith

/-- `log K ≤ 13/15`, from `1/3 ≤ κ`. -/
theorem log_K_le : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) ≤ 13 / 15 := by
  have h := kappa_levinson_ge
  unfold kappaL at h
  have e : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) / (13 / 10) =
      Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) * (10 / 13) := by ring
  rw [e] at h
  linarith

/-- The `max 1` and the `ε₁` of `floor_step`, priced: `log (max 1 x) / R ≤ 2/3 + 2ε₁`. -/
theorem logmax_le {x ε₁ : ℝ} (hε₁ : 0 < ε₁)
    (hx : x ≤ Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) + 2 * ε₁) :
    Real.log (max 1 x) / (13 / 10) ≤ 2 / 3 + 2 * ε₁ := by
  have hK1 := K_ge_one
  have hlK := log_K_le
  obtain ⟨K, hKdef⟩ : ∃ K : ℝ, K = Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) := ⟨_, rfl⟩
  rw [← hKdef] at hK1 hlK hx
  have hK0 : 0 < K := by linarith
  have hm : max 1 x ≤ K + 2 * ε₁ := max_le (by linarith) hx
  have h1 : Real.log (max 1 x) ≤ Real.log (K + 2 * ε₁) :=
    Real.log_le_log (by positivity) hm
  have h2 : Real.log (K + 2 * ε₁) - Real.log K ≤ 2 * ε₁ := by
    rw [← Real.log_div (by positivity) hK0.ne']
    have h3 := Real.log_le_sub_one_of_pos (show 0 < (K + 2 * ε₁) / K by positivity)
    have h4 : (K + 2 * ε₁) / K - 1 = 2 * ε₁ / K := by field_simp; ring
    have h5 : 2 * ε₁ / K ≤ 2 * ε₁ := div_le_self (by positivity) hK1
    linarith
  rw [div_le_iff₀ (by norm_num)]
  linarith

/-- **The window floor at `P = X`.** For `ε₁ > 0`, from some height `T₁ ≥ 1` on,
`(1/3 − 2ε₁)(N T − N(T/2)) − ε₁ T log T ≤ lineCount T − lineCount(T/2)`. -/
theorem step_X {ε₁ : ℝ} (hε₁ : 0 < ε₁) : ∃ T₁ : ℝ, 1 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
    (1 / 3 - 2 * ε₁) * (riemannZeta.N T - riemannZeta.N (T / 2)) - ε₁ * T * Real.log T
      ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
  obtain ⟨T₂, h₂⟩ := FloorStep.floor_step Polynomial.X Polynomial.eval_X Polynomial.eval_X
    (θ := 49 / 100) (by norm_num) (by norm_num) (R := 13 / 10) (by norm_num) ε₁ hε₁
  have hlim := (floor_const.1).eventually
    (Iic_mem_nhds (lt_add_of_pos_right (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) hε₁))
  obtain ⟨T₃, h₃⟩ := eventually_atTop.mp hlim
  refine ⟨max 1 (max T₂ T₃), le_max_left _ _, fun T hT => ?_⟩
  have hT1 : 1 ≤ T := (le_max_left _ _).trans hT
  have hT2 : T₂ ≤ T := (le_max_left _ _).trans ((le_max_right _ _).trans hT)
  have hT3 : T₃ ≤ T := (le_max_right _ _).trans ((le_max_right _ _).trans hT)
  have hs := h₂ T hT2
  have hD : (Operator.Dop (Real.log T) (cY Polynomial.X (Mof T (49 / 100)) T)
      ((-((13 / 10) / Real.log T) : ℝ) : ℂ) ((-((13 / 10) / Real.log T) : ℝ) : ℂ)).re
        ≤ Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10) + ε₁ := h₃ T hT3
  have ha := logmax_le hε₁ (x := (Operator.Dop (Real.log T) (cY Polynomial.X (Mof T (49 / 100)) T)
      ((-((13 / 10) / Real.log T) : ℝ) : ℂ) ((-((13 / 10) / Real.log T) : ℝ) : ℂ)).re + ε₁)
    (by linarith)
  have hN : 0 ≤ riemannZeta.N T - riemannZeta.N (T / 2) := by
    have := ArgCount.N_mono (show T / 2 ≤ T by linarith)
    linarith
  have hm := mul_le_mul_of_nonneg_right ha hN
  linarith

/-- **`N T ≥ T log T / 20`** eventually, from the Riemann–von Mangoldt bound in the tree. -/
theorem N_ge : ∀ᶠ T : ℝ in atTop, T * Real.log T / 20 ≤ riemannZeta.N T := by
  filter_upwards [Real.tendsto_log_atTop.eventually_ge_atTop 80,
    eventually_ge_atTop (129600 : ℝ)] with T hL hT
  have hw := FloorStep.N_window_ge (T := T) (by linarith)
  have hN2 := ArgCount.N_nonneg (T / 2)
  have hπ := Real.pi_pos
  have hπ2 := Real.pi_lt_d2
  have hP : 0 ≤ T * Real.log T := mul_nonneg (by linarith) (by linarith)
  have h1 : T * Real.log T / (63 / 5) ≤ T * Real.log T / (4 * Real.pi) :=
    div_le_div_of_nonneg_left hP (by positivity) (by linarith)
  have h2 : 80 * T ≤ T * Real.log T := by nlinarith
  have h3 : 1620 * Real.log T * 80 ≤ T * Real.log T := by nlinarith
  have h4 : 224 * Real.log T + 1396 ≤ 1620 * Real.log T := by linarith
  linarith

/-- **S12 piece 5c, Levinson's floor.** At `P(x) = x`, `θ = 49/100`, `R = 13/10`: for every
`ε > 0`, from some height on, at least `(1/3 − ε) N T` of the zeros of `ζ` with height in
`(0, T]` lie on the critical line, counted with multiplicity. -/
theorem levinson_floor : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (1 / 3 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) := by
  intro ε hε
  obtain ⟨ε', hε'def⟩ : ∃ ε' : ℝ, ε' = min ε (1 / 6) := ⟨_, rfl⟩
  have hε'0 : 0 < ε' := by rw [hε'def]; exact lt_min hε (by norm_num)
  have hε'ε : ε' ≤ ε := by rw [hε'def]; exact min_le_left _ _
  have hε'6 : ε' ≤ 1 / 6 := by rw [hε'def]; exact min_le_right _ _
  obtain ⟨T₁, hT₁, hstep⟩ := step_X (ε₁ := ε' / 80) (by positivity)
  have hfl := tele_floor (f := fun T => (LineCount.lineCount T : ℝ)) (g := riemannZeta.N)
    (c := 1 / 3 - 2 * (ε' / 80)) (e := ε' / 80) hT₁ (by positivity) (by linarith)
    (fun T => by exact_mod_cast LevinsonWindowNear.lineCount_nonneg T)
    (fun a b h => ArgCount.N_mono h) hstep
  obtain ⟨T₄, h₄⟩ := eventually_atTop.mp
    (N_ge.and (Real.tendsto_log_atTop.eventually_ge_atTop 1))
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
  -- `ε' T ≥ 1600 N T₁`
  rw [div_le_iff₀ hε'0] at hTN
  -- `ε' N T ≥ ε' T log T / 20`
  have hA : ε' * (T * Real.log T / 20) ≤ ε' * riemannZeta.N T :=
    mul_le_mul_of_nonneg_left hNT hε'0.le
  -- `T ≤ T log T`, so `ε' N T ≥ ε' T / 20 ≥ 80 N T₁`
  have hTL : T ≤ T * Real.log T := by nlinarith
  have hC : ε' * T ≤ ε' * (T * Real.log T) := mul_le_mul_of_nonneg_left hTL hε'0.le
  have hD : 0 ≤ ε' * riemannZeta.N T₁ := mul_nonneg hε'0.le hN10
  have hB : (1 / 3 - ε) * riemannZeta.N T ≤ (1 / 3 - ε') * riemannZeta.N T :=
    mul_le_mul_of_nonneg_right (by linarith) hN0
  have e1 : ε' * (T * Real.log T / 20) = ε' * (T * Real.log T) / 20 := by ring
  have e2 : (1 / 3 - 2 * (ε' / 80)) * (riemannZeta.N T - riemannZeta.N T₁)
      - 2 * (ε' / 80) * T * Real.log T = riemannZeta.N T / 3 - ε' * riemannZeta.N T / 40
        - riemannZeta.N T₁ / 3 + ε' * riemannZeta.N T₁ / 40 - ε' * (T * Real.log T) / 40 := by
    ring
  rw [e1] at hA
  rw [e2] at hfT
  have e3 : (1 / 3 - ε') * riemannZeta.N T = riemannZeta.N T / 3 - ε' * riemannZeta.N T := by ring
  rw [e3] at hB
  linarith

/-- info: 'FloorSum.K_ge_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms K_ge_one

/-- info: 'FloorSum.step_X' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms step_X

/-- info: 'FloorSum.N_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms N_ge

/-- info: 'FloorSum.levinson_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_floor

end FloorSum
