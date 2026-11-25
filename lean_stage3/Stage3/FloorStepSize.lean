/-
# FloorStepSize — block S12 of `lean_stage3/design/stencil.md`, piece 5b, one height: the sizes. 2026-11-25.

The sizes `FloorStep.floor_step` feeds to `LevinsonWindowNear.levinson_window_diff` at
`a = T/2`, `b = T`, `L = log T`, `M = Mof T θ = ⌊T^θ⌋`, `σ₀ = sig0 T R = 1/2 − R/L`.

* `β = betaC`, Young's `aY` cut to `[1, M]`: `molli M betaC = molli M aY` (the mollifier reads
  only `h ∈ [1, M]`), `betaC 1 = P(1) = 1` once `M ≥ 2`, and `‖betaC h‖ ≤ B` for every `h`, `B`
  a constant (`Diagonal.aY_bound'`: `‖a_h‖ ≤ B h^(σ₀−1/2) ≤ B`). The uncut `aY` is not bounded
  in `h` uniformly in `T`, which `levinson_window_diff`'s `hβ` asks.
* `X = log₂(A T)` with `A τ = 64 (B + 1)`: `tailDelta M B X ≤ τ` and `32 M B ≤ 2^X`
  (`M ≤ T`), `3 ≤ X ≤ 4L` once `log A ≤ L`.
  **The lost factor this avoids.** With only `2^X ≥ 32 M B`, `tailDelta ≈ 1/4`, and the
  window's term `(b − a)·2·tailDelta ≈ T/4`, times the prefactor `1/(π(1/2 − σ₀)) = L/(πR)`,
  is `T L/(4πR)`: the size of the main term `(T L/(4πR)) log K`. With `tailDelta ≤ τ`,
  `τ ≤ επR/4`, the term is `≤ (ε/4) T L`. `X = O(L)` keeps the rest polynomial in `L`.
* the window's other edge terms `Xπ + 2Xπ((8X − 1)(L + log M + log B + 8) + 1) ≤ π C_w L³`
  (`W2_le`, `C_w = 12 + 256(10 + B)`); times `L/(πR)` this is `C_w L⁴/R = o(T L)`.
* `N T − N(T/2) ≥ T L/(4π) − T − 224 L − 1396` from the tree's unconditional
  Riemann–von Mangoldt band `ArgCount.rvM_crude` (`112 log T + 698`); the exact difference of
  the main terms is `(T/(4π))(L − log π − 1)`.

| name | content | status |
|---|---|---|
| `betaC`, `molli_betaC`, `betaC_one`, `betaC_bound` | the cut coefficients | proved |
| `tail_le`, `XMB_le`, `X_bounds` | the choice of `X` | proved |
| `W2_le` | the edge terms, `O(L³)` | proved |
| `eventually_logpow_le` | `C (log T)^n ≤ T` eventually | proved |
| `N_window_ge` | Riemann–von Mangoldt on `[T/2, T]` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Unsmooth
import Stage3.LevinsonWindowNear
import Stage3.Diagonal

namespace FloorStep

open Complex MeasureTheory Set Filter Topology TwistedMoment

/-- Young's coefficients cut to `[1, M]`. -/
noncomputable
def betaC (P : Polynomial ℝ) (T θ R : ℝ) (h : ℕ) : ℂ :=
  if 1 ≤ h ∧ h ≤ Mof T θ then aY P T θ R h else 0

theorem molli_betaC (P : Polynomial ℝ) (T θ R : ℝ) :
    LevinsonMollEdge.molli (Mof T θ) (betaC P T θ R) =
      LevinsonMollEdge.molli (Mof T θ) (aY P T θ R) := by
  funext s
  unfold LevinsonMollEdge.molli
  refine Finset.sum_congr rfl fun h hh => ?_
  have hh' := Finset.mem_Icc.mp hh
  unfold betaC
  rw [if_pos hh']

theorem betaC_one (P : Polynomial ℝ) (hP1 : P.eval 1 = 1) {T θ R : ℝ} (hM : 2 ≤ Mof T θ) :
    betaC P T θ R 1 = 1 := by
  unfold betaC
  rw [if_pos ⟨le_rfl, by omega⟩]
  unfold aY
  have hM1 : (1 : ℝ) < (Mof T θ : ℝ) := by exact_mod_cast (show 1 < Mof T θ by omega)
  have hl : Real.log (Mof T θ : ℝ) ≠ 0 := (Real.log_pos hM1).ne'
  simp [hl, hP1]

theorem betaC_bound (P : Polynomial ℝ) : ∃ B : ℝ, 1 ≤ B ∧ ∀ (T θ R : ℝ), sig0 T R ≤ 1 / 2 →
    ∀ h : ℕ, ‖betaC P T θ R h‖ ≤ B := by
  obtain ⟨B₀, hB₀, hB⟩ := Diagonal.aY_bound' P
  refine ⟨max B₀ 1, le_max_right _ _, fun T θ R hσ h => ?_⟩
  unfold betaC
  split_ifs with hh
  · have hh0 : (0 : ℝ) < h := by exact_mod_cast hh.1
    have hh1 : (1 : ℝ) ≤ h := by exact_mod_cast hh.1
    have h1 := hB T θ R h hh.1 hh.2
    have hp : 0 < (h : ℝ) ^ (sig0 T R) := Real.rpow_pos_of_pos hh0 _
    have e1 : ‖aY P T θ R h‖ = ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) * (h : ℝ) ^ (sig0 T R) := by
      rw [mul_assoc, ← Real.rpow_add hh0, neg_add_cancel, Real.rpow_zero, mul_one]
    have e2 : (h : ℝ) ^ (-(1 / 2) : ℝ) * (h : ℝ) ^ (sig0 T R) = (h : ℝ) ^ (sig0 T R - 1 / 2) := by
      rw [← Real.rpow_add hh0]; ring_nf
    have h3 : (h : ℝ) ^ (sig0 T R - 1 / 2) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos hh1 (by linarith)
    have h4 : ‖aY P T θ R h‖ ≤ B₀ := by
      rw [e1]
      calc ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) * (h : ℝ) ^ (sig0 T R)
          ≤ B₀ * (h : ℝ) ^ (-(1 / 2) : ℝ) * (h : ℝ) ^ (sig0 T R) :=
            mul_le_mul_of_nonneg_right h1 hp.le
        _ = B₀ * (h : ℝ) ^ (sig0 T R - 1 / 2) := by rw [mul_assoc, e2]
        _ ≤ B₀ * 1 := mul_le_mul_of_nonneg_left h3 hB₀
        _ = B₀ := mul_one _
    exact h4.trans (le_max_left _ _)
  · simp

/-- `tailDelta ≤ τ` once `2^X = A T` with `64 (B + 1) ≤ A τ`, `M ≤ T`. -/
theorem tail_le {M : ℕ} {B X A T τ : ℝ} (hB : 0 ≤ B) (hτ : 0 < τ) (hτ1 : τ ≤ 1)
    (hA : 64 * (B + 1) ≤ A * τ) (hT : 1 ≤ T) (hMT : (M : ℝ) ≤ T)
    (hq : (2 : ℝ) ^ X = A * T) : LevinsonMollEdge.tailDelta M B X ≤ τ := by
  unfold LevinsonMollEdge.tailDelta
  rw [hq]
  have hA0 : 0 < A := by
    by_contra h
    push Not at h
    nlinarith
  have hq0 : 0 < A * T := by positivity
  have hM0 : (0 : ℝ) ≤ M := Nat.cast_nonneg _
  have h1 : (M : ℝ) * B / (A * T) ≤ τ / 64 := by
    rw [div_le_iff₀ hq0]
    have : (M : ℝ) * B ≤ T * B := mul_le_mul_of_nonneg_right hMT hB
    nlinarith
  have h2 : 8 / (A * T) ≤ τ / 8 := by
    rw [div_le_iff₀ hq0]
    nlinarith
  have h3 : 0 ≤ (M : ℝ) * B / (A * T) := by positivity
  have h4 : 8 / (A * T) * (1 + M * B / (A * T)) ≤ τ / 8 * 2 := by
    apply mul_le_mul h2 (by linarith) (by positivity) (by positivity)
  linarith

/-- `32 M B ≤ 2^X` under the same choice. -/
theorem XMB_le {M : ℕ} {B X A T τ : ℝ} (hB : 0 ≤ B) (hτ : 0 < τ) (hτ1 : τ ≤ 1)
    (hA : 64 * (B + 1) ≤ A * τ) (hMT : (M : ℝ) ≤ T)
    (hq : (2 : ℝ) ^ X = A * T) : 32 * M * B ≤ (2 : ℝ) ^ X := by
  rw [hq]
  have hA0 : 0 < A := by
    by_contra h
    push Not at h
    nlinarith
  have hAB : 32 * B ≤ A := by nlinarith
  have hM0 : (0 : ℝ) ≤ M := Nat.cast_nonneg _
  have hT0 : 0 ≤ T := hM0.trans hMT
  calc 32 * (M : ℝ) * B = (M : ℝ) * (32 * B) := by ring
    _ ≤ T * A := mul_le_mul hMT hAB (by positivity) hT0
    _ = A * T := by ring

/-- `X = log₂(A T)` lies in `[3, 4 log T]` once `8 ≤ A T` and `log A ≤ log T`. -/
theorem X_bounds {A T : ℝ} (hA : 1 ≤ A) (hT : 1 ≤ T) (h8 : 8 ≤ A * T)
    (hAL : Real.log A ≤ Real.log T) :
    3 ≤ Real.logb 2 (A * T) ∧ Real.logb 2 (A * T) ≤ 4 * Real.log T := by
  have hq0 : 0 < A * T := by positivity
  constructor
  · rw [Real.le_logb_iff_rpow_le (by norm_num) hq0]
    norm_num
    linarith
  · have hl2 := Real.log_two_gt_d9
    have hl2' : 0 < Real.log 2 := by linarith
    rw [Real.logb, div_le_iff₀ hl2', Real.log_mul (by positivity) (by positivity)]
    have hLA : 0 ≤ Real.log A := Real.log_nonneg hA
    nlinarith

/-- **The window's polynomial edge terms**, size `O(L³)`. -/
theorem W2_le {X L lM lB B : ℝ} (hX3 : 3 ≤ X) (hX : X ≤ 4 * L) (hL : 1 ≤ L) (hlM0 : 0 ≤ lM)
    (hlM : lM ≤ L) (hlB0 : 0 ≤ lB) (hlB : lB ≤ B) :
    X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1) * (L + lM + lB + 8) + 1)))
      ≤ Real.pi * (12 + 256 * (10 + B)) * L ^ 3 := by
  have hπ := Real.pi_pos
  have hB0 : 0 ≤ B := hlB0.trans hlB
  have hs : L + lM + lB + 8 ≤ (10 + B) * L := by nlinarith
  have hs0 : 0 ≤ L + lM + lB + 8 := by linarith
  have h8 : 8 * X - 1 ≤ 32 * L := by linarith
  have h80 : 0 ≤ 8 * X - 1 := by linarith
  have hp : (8 * X - 1) * (L + lM + lB + 8) ≤ 32 * L * ((10 + B) * L) :=
    mul_le_mul h8 hs hs0 (by positivity)
  have hL2 : 1 ≤ L ^ 2 := by nlinarith
  have hin : (8 * X - 1) * (L + lM + lB + 8) + 1 ≤ (32 * (10 + B) + 1) * L ^ 2 := by nlinarith
  have hin0 : 0 ≤ (8 * X - 1) * (L + lM + lB + 8) + 1 := by positivity
  have hX0 : 0 ≤ X := by linarith
  have hmain : X * ((8 * X - 1) * (L + lM + lB + 8) + 1) ≤ 4 * L * ((32 * (10 + B) + 1) * L ^ 2) :=
    mul_le_mul hX hin hin0 (by positivity)
  have hL3 : L ≤ L ^ 3 := by nlinarith
  have e : X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1) * (L + lM + lB + 8) + 1)))
      = Real.pi * (X + 2 * (X * ((8 * X - 1) * (L + lM + lB + 8) + 1))) := by ring
  rw [e, mul_assoc]
  apply mul_le_mul_of_nonneg_left _ hπ.le
  have e2 : 4 * L * ((32 * (10 + B) + 1) * L ^ 2) = (128 * (10 + B) + 4) * L ^ 3 := by ring
  rw [e2] at hmain
  nlinarith

/-- `C (log T)^n ≤ T` from some height on. -/
theorem eventually_logpow_le (C : ℝ) (n : ℕ) :
    ∀ᶠ T : ℝ in atTop, C * Real.log T ^ n ≤ T := by
  have h := Real.tendsto_pow_log_div_mul_add_atTop 1 0 n one_ne_zero
  have hC : 0 < |C| + 1 := by positivity
  have h2 := (h.eventually (gt_mem_nhds (show (0 : ℝ) < 1 / (|C| + 1) by positivity)))
  filter_upwards [h2, eventually_ge_atTop (1 : ℝ)] with T hT hT1
  simp only [one_mul, add_zero] at hT
  have hT0 : 0 < T := by linarith
  have hl : 0 ≤ Real.log T ^ n := pow_nonneg (Real.log_nonneg hT1) _
  rw [div_lt_iff₀ hT0] at hT
  have h3 : (|C| + 1) * Real.log T ^ n ≤ T := by
    have := mul_lt_mul_of_pos_left hT hC
    rw [show (|C| + 1) * (1 / (|C| + 1) * T) = T by field_simp] at this
    linarith
  have h4 : C * Real.log T ^ n ≤ (|C| + 1) * Real.log T ^ n :=
    mul_le_mul_of_nonneg_right (by linarith [le_abs_self C]) hl
  linarith


/-- **Riemann–von Mangoldt on `[T/2, T]`.** `T log T/(4π) − (N T − N(T/2)) ≤ T + 224 log T + 1396`. -/
theorem N_window_ge {T : ℝ} (hT : 4 ≤ T) :
    T * Real.log T / (4 * Real.pi) - (riemannZeta.N T - riemannZeta.N (T / 2))
      ≤ T + 224 * Real.log T + 1396 := by
  have hR := ArgCount.rvM_crude
  have h1 := hR T (by linarith)
  have h2 := hR (T / 2) (by linarith)
  unfold riemannZeta.RvM at h1 h2
  have hπ := Real.pi_pos
  have hT0 : 0 < T := by linarith
  have hlT2 : Real.log (T / 2) ≤ Real.log T :=
    Real.log_le_log (by positivity) (by linarith)
  have e1 : Real.log (T / (2 * Real.pi)) = Real.log T - Real.log 2 - Real.log Real.pi := by
    rw [Real.log_div hT0.ne' (by positivity), Real.log_mul (by norm_num) hπ.ne']; ring
  have e2 : Real.log (T / 2 / (2 * Real.pi)) = Real.log T - 2 * Real.log 2 - Real.log Real.pi := by
    rw [Real.log_div (by positivity) (by positivity), Real.log_mul (by norm_num) hπ.ne',
      Real.log_div hT0.ne' (by norm_num)]; ring
  rw [e1] at h1
  rw [e2] at h2
  have a1 := (abs_le.mp h1).1
  have a2 := (abs_le.mp h2).2
  have hlπ : Real.log Real.pi + 1 ≤ 4 * Real.pi := by
    have := Real.log_le_sub_one_of_pos hπ
    linarith
  have hkey : T * Real.log T / (4 * Real.pi) - (T / (2 * Real.pi) * (Real.log T - Real.log 2 -
      Real.log Real.pi) - T / (2 * Real.pi) - (T / 2 / (2 * Real.pi) * (Real.log T - 2 * Real.log 2
      - Real.log Real.pi) - T / 2 / (2 * Real.pi))) = T * (Real.log Real.pi + 1) / (4 * Real.pi) := by
    field_simp
    ring
  have hle : T * (Real.log Real.pi + 1) / (4 * Real.pi) ≤ T := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  have hl0 : 0 ≤ Real.log (Real.log T) * 0 := by simp
  nlinarith

/-- info: 'FloorStep.molli_betaC' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms molli_betaC

/-- info: 'FloorStep.betaC_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms betaC_one

/-- info: 'FloorStep.betaC_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms betaC_bound

/-- info: 'FloorStep.tail_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tail_le

/-- info: 'FloorStep.XMB_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms XMB_le

/-- info: 'FloorStep.X_bounds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms X_bounds

/-- info: 'FloorStep.W2_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms W2_le

/-- info: 'FloorStep.eventually_logpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms eventually_logpow_le

/-- info: 'FloorStep.N_window_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms N_window_ge

end FloorStep
