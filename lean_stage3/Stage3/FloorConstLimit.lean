/-
# FloorConstLimit — block S12 of `lean_stage3/design/stencil.md`, piece 5a, the closed form: Levinson's constant. 2026-11-25.

With `α = a/L`, `β = b/L`, `L = log T`, `ℓ = log M`, `θ' = ℓ/L`, Young's
`c₁(α,β) = f_{θ'}(a,b) = (1/((a+b)θ'))(A + (a+b)θ'B + abθ'²C)`, `A = ∫₀¹P′²`, `B = ∫₀¹P′P`,
`C = ∫₀¹P²`, and `T^(−α−β) = e^(−(a+b))`; since `(1/L)∂α = ∂a`, Levinson's operator gives
`D[c](−R/L, −R/L) = (1 + ∂a)(1 + ∂b)[f(a,b) + e^(−(a+b)) f(−b,−a)]` at `a = b = −R`. On paper,
with `f(−b,−a) = 2B − f(a,b)` and `c = f(1 − E) + 2BE`, `E = e^(−(a+b))`, this is
`G₀ + 2G₁ + G₂ − e^(2R) G₂`, `G₀ = f`, `G₁ = ∂a f`, `G₂ = ∂b∂a f` at `(−R, −R)`:

  `K(A,B,C,θ,R) = B − A/(2Rθ) − RθC/2 + θC/2 − A/(2R²θ) − θC/(4R) − A/(4R³θ)
                  + e^(2R) (θC/(4R) + A/(4R³θ))`.

Checked against sympy before Lean (scratchpad `kfl.py`): the difference of the differentiated
expression and `Kfl` simplifies to `0`; at `(A,B,C) = (1,1/2,1/3)`, `θ = 1/2`, `R = 1.3`,
`1 − log K / R = 0.34274`, Levinson's `0.342` with `P(x) = x`.

| name | content | status |
|---|---|---|
| `Kfl`, `Ar`, `Br`, `Cr` | the closed form; `∫P′²`, `∫P′P`, `∫P²` as reals | defined |
| `dop_closed` | the algebra: `HF + (Hx + Hy)/L + Hxy/L²` at `(−R/L, −R/L)` is `Kfl` | proved |
| `dop_cY_eq` | `D[c](−R/L, −R/L) = Kfl A B C (log M / log T) R`, exactly, for `log M ≠ 0` | proved |
| `logM_ge'`, `theta_tendsto` | `θ log T − log 2 ≤ log M`; `log M / log T → θ` | proved |
| `tendsto_Kfl` | `Kfl` is continuous in `θ ≠ 0` | proved |
| `re_dop_tendsto` | `Re D[c](T) → Kfl A B C θ R` as `T → ∞`, `θ > 0`, `R ≠ 0` | proved |
| `Ar_X`, `Br_X`, `Cr_X`, `re_dop_tendsto_X` | at `P = X`: `1, 1/2, 1/3`, and the limit | proved |

The numbers at `θ = 49/100`, `R = 13/10` are in `FloorConst`, the top module.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorConstDeriv
import Stage3.DiagMain

namespace FloorConst

open Complex Filter Topology TwistedMoment Operator

noncomputable section

/-- **Levinson's constant in closed form**, `(1 + ∂a)(1 + ∂b)[f(a,b) + e^(−(a+b)) f(−b,−a)]`
at `a = b = −R`, `f(a,b) = (A + (a+b)θB + abθ²C)/((a+b)θ)`. -/
def Kfl (A B C θ R : ℝ) : ℝ :=
  B - A / (2 * R * θ) - R * θ * C / 2 + θ * C / 2 - A / (2 * R ^ 2 * θ) - θ * C / (4 * R) -
    A / (4 * R ^ 3 * θ) + Real.exp (2 * R) * (θ * C / (4 * R) + A / (4 * R ^ 3 * θ))

/-- `A = ∫₀¹ P′²`, real. -/
def Ar (P : Polynomial ℝ) : ℝ := ∫ u in (0 : ℝ)..1, P.derivative.eval u * P.derivative.eval u

/-- `B = ∫₀¹ P′P`, real. -/
def Br (P : Polynomial ℝ) : ℝ := ∫ u in (0 : ℝ)..1, P.derivative.eval u * P.eval u

/-- `C = ∫₀¹ P²`, real. -/
def Cr (P : Polynomial ℝ) : ℝ := ∫ u in (0 : ℝ)..1, P.eval u * P.eval u

end

theorem Aq_eq (P : Polynomial ℝ) : Aq P = ((Ar P : ℝ) : ℂ) := by
  unfold Aq Ar
  rw [← intervalIntegral.integral_ofReal]
  simp only [Complex.ofReal_mul]

theorem Bq_eq (P : Polynomial ℝ) : Bq P = ((Br P : ℝ) : ℂ) := by
  unfold Bq Br
  rw [← intervalIntegral.integral_ofReal]
  simp only [Complex.ofReal_mul]

theorem Cq_eq (P : Polynomial ℝ) : Cq P = ((Cr P : ℝ) : ℂ) := by
  unfold Cq Cr
  rw [← intervalIntegral.integral_ofReal]
  simp only [Complex.ofReal_mul]

/-- **The algebra**: at `x = y = −R/L`, `λ = L`, `ℓ = θL`, the operator on `g(1 − E) + 2BE` is
`Kfl`. -/
theorem dop_closed {A B C θ R L : ℝ} (hL : L ≠ 0) (hθ : θ ≠ 0) (hR : R ≠ 0) :
    HF A B C ((θ * L : ℝ) : ℂ) L ((-(R / L) : ℝ) : ℂ) ((-(R / L) : ℝ) : ℂ) +
        1 / (L : ℂ) * (Hx A B C ((θ * L : ℝ) : ℂ) L ((-(R / L) : ℝ) : ℂ) ((-(R / L) : ℝ) : ℂ) +
          Hy A B C ((θ * L : ℝ) : ℂ) L ((-(R / L) : ℝ) : ℂ) ((-(R / L) : ℝ) : ℂ)) +
        1 / (L : ℂ) ^ 2 *
          Hxy A B C ((θ * L : ℝ) : ℂ) L ((-(R / L) : ℝ) : ℂ) ((-(R / L) : ℝ) : ℂ) =
      ((Kfl A B C θ R : ℝ) : ℂ) := by
  have hLc : (L : ℂ) ≠ 0 := by exact_mod_cast hL
  have hθc : (θ : ℂ) ≠ 0 := by exact_mod_cast hθ
  have hRc : (R : ℂ) ≠ 0 := by exact_mod_cast hR
  have hE : EF (L : ℂ) ((-(R / L) : ℝ) : ℂ) ((-(R / L) : ℝ) : ℂ) = cexp (2 * (R : ℂ)) := by
    unfold EF
    congr 1
    push_cast
    field_simp
    ring
  unfold HF Hx Hy Hxy
  rw [hE]
  unfold gF gx gy gxy Kfl
  push_cast
  field_simp
  ring

/-- **`D[c]` in closed form**: `D[c](−R/L, −R/L) = Kfl A B C θ' R`, `θ' = log M / log T`,
exactly, for `T > 1`, `log M ≠ 0`, `R ≠ 0`. -/
theorem dop_cY_eq (P : Polynomial ℝ) {M : ℕ} {T R : ℝ} (hT : 1 < T) (hℓ : Real.log M ≠ 0)
    (hR : R ≠ 0) :
    Dop (Real.log T) (cY P M T) ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ) =
      ((Kfl (Ar P) (Br P) (Cr P) (Real.log M / Real.log T) R : ℝ) : ℂ) := by
  have hT0 : T ≠ 0 := by positivity
  have hL : Real.log T ≠ 0 := (Real.log_pos hT).ne'
  have hx : ((-(R / Real.log T) : ℝ) : ℂ) + ((-(R / Real.log T) : ℝ) : ℂ) ≠ 0 := by
    rw [← Complex.ofReal_add]
    have : -(R / Real.log T) + -(R / Real.log T) ≠ 0 := by
      have : R / Real.log T ≠ 0 := div_ne_zero hR hL
      intro e
      apply this
      linarith
    exact_mod_cast this
  unfold Dop
  rw [cY_eq_HF P M hT0 hℓ hx, pa_cY P M hT0 hℓ hx, pb_cY P M hT0 hℓ hx, pab_cY P M hT0 hℓ hx,
    Aq_eq, Bq_eq, Cq_eq, ← Complex.ofReal_log (by linarith : (0 : ℝ) ≤ T)]
  have hl : ((Real.log M : ℝ) : ℂ) = ((Real.log M / Real.log T * Real.log T : ℝ) : ℂ) := by
    rw [div_mul_cancel₀ _ hL]
  rw [hl]
  exact dop_closed hL (div_ne_zero hℓ hL) hR

/-- `θ log T − log 2 ≤ log M`, `M = ⌊T^θ⌋`, `T ≥ 1`, `θ ≥ 0`. -/
theorem logM_ge' {T θ : ℝ} (hT : 1 ≤ T) (hθ : 0 ≤ θ) :
    θ * Real.log T - Real.log 2 ≤ Real.log (Mof T θ) := by
  unfold Mof
  have hT0 : 0 < T := by linarith
  have h1 : 1 ≤ T ^ θ := Real.one_le_rpow hT hθ
  have hM1 : 1 ≤ ⌊T ^ θ⌋₊ := Nat.le_floor (by exact_mod_cast h1)
  have hM1' : (1 : ℝ) ≤ (⌊T ^ θ⌋₊ : ℝ) := by exact_mod_cast hM1
  have hlt : T ^ θ < (⌊T ^ θ⌋₊ : ℝ) + 1 := Nat.lt_floor_add_one _
  have h2 : T ^ θ ≤ 2 * (⌊T ^ θ⌋₊ : ℝ) := by linarith
  have h3 : Real.log (T ^ θ) ≤ Real.log (2 * (⌊T ^ θ⌋₊ : ℝ)) :=
    Real.log_le_log (by positivity) h2
  rw [Real.log_rpow hT0, Real.log_mul (by norm_num) (by positivity)] at h3
  linarith

/-- `θ' = log M / log T → θ`. -/
theorem theta_tendsto {θ : ℝ} (hθ : 0 < θ) :
    Tendsto (fun T => Real.log (Mof T θ) / Real.log T) atTop (𝓝 θ) := by
  have hlo : Tendsto (fun T => θ - Real.log 2 / Real.log T) atTop (𝓝 θ) := by
    have h := (tendsto_const_nhds (x := Real.log 2)).div_atTop Real.tendsto_log_atTop
    simpa using (tendsto_const_nhds (x := θ)).sub h
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' hlo tendsto_const_nhds ?_ ?_
  · filter_upwards [eventually_ge_atTop (2 : ℝ)] with T hT
    have hL : 0 < Real.log T := Real.log_pos (by linarith)
    rw [le_div_iff₀ hL]
    have e : (θ - Real.log 2 / Real.log T) * Real.log T = θ * Real.log T - Real.log 2 := by
      field_simp
    rw [e]
    exact logM_ge' (by linarith) hθ.le
  · filter_upwards [eventually_ge_atTop (2 : ℝ)] with T hT
    have hL : 0 < Real.log T := Real.log_pos (by linarith)
    rw [div_le_iff₀ hL]
    exact DiagMain.logM_le (by linarith) hθ.le

/-- `Kfl` is continuous in `θ ≠ 0`. -/
theorem tendsto_Kfl (A B C R : ℝ) {θ : ℝ} (hθ : θ ≠ 0) {f : ℝ → ℝ} {l : Filter ℝ}
    (h : Tendsto f l (𝓝 θ)) :
    Tendsto (fun t => Kfl A B C (f t) R) l (𝓝 (Kfl A B C θ R)) := by
  set k1 : ℝ := -(R * C / 2) + C / 2 - C / (4 * R) + Real.exp (2 * R) * (C / (4 * R)) with hk1
  set k2 : ℝ := -(A / (2 * R)) - A / (2 * R ^ 2) - A / (4 * R ^ 3) +
    Real.exp (2 * R) * (A / (4 * R ^ 3)) with hk2
  have e : ∀ t : ℝ, Kfl A B C t R = B + k1 * t + k2 * t⁻¹ := by
    intro t
    rw [hk1, hk2]
    unfold Kfl
    ring
  simp only [e]
  exact ((tendsto_const_nhds).add (tendsto_const_nhds.mul h)).add
    (tendsto_const_nhds.mul (h.inv₀ hθ))

/-- **The limit of Levinson's constant**: `Re D[c](−R/L, −R/L) → Kfl A B C θ R` as `T → ∞`,
`M = ⌊T^θ⌋`, for `θ > 0`, `R ≠ 0`. -/
theorem re_dop_tendsto (P : Polynomial ℝ) {θ R : ℝ} (hθ : 0 < θ) (hR : R ≠ 0) :
    Tendsto (fun T => (Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ)).re) atTop (𝓝 (Kfl (Ar P) (Br P) (Cr P) θ R)) := by
  refine (tendsto_Kfl (Ar P) (Br P) (Cr P) R hθ.ne' (theta_tendsto hθ)).congr' ?_
  filter_upwards [eventually_ge_atTop (max 2 (Real.exp (4 * Real.log 2 / θ)))] with T hT
  simp only [max_le_iff] at hT
  obtain ⟨hT2, hTe⟩ := hT
  have hT1 : 1 < T := by linarith
  have hT0 : 0 < T := by linarith
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hℓlo := DiagMain.logM_ge hT1 hθ hLθ
  have hℓ0 : 0 < Real.log (Mof T θ) :=
    lt_of_lt_of_le (by have := Real.log_pos hT1; positivity) hℓlo
  rw [dop_cY_eq P hT1 hℓ0.ne' hR, Complex.ofReal_re]

theorem Ar_X : Ar Polynomial.X = 1 := by
  unfold Ar
  simp

theorem Br_X : Br Polynomial.X = 1 / 2 := by
  unfold Br
  simp only [Polynomial.derivative_X, Polynomial.eval_one, Polynomial.eval_X, one_mul]
  rw [integral_id]
  norm_num

theorem Cr_X : Cr Polynomial.X = 1 / 3 := by
  unfold Cr
  simp only [Polynomial.eval_X]
  simp_rw [← sq]
  rw [integral_pow]
  norm_num

/-- **At Levinson's `P(x) = x`**: `Re D[c] → Kfl 1 (1/2) (1/3) θ R`. -/
theorem re_dop_tendsto_X {θ R : ℝ} (hθ : 0 < θ) (hR : R ≠ 0) :
    Tendsto (fun T => (Dop (Real.log T) (cY Polynomial.X (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (Kfl 1 (1 / 2) (1 / 3) θ R)) := by
  have h := re_dop_tendsto Polynomial.X hθ hR
  rwa [Ar_X, Br_X, Cr_X] at h

/-- info: 'FloorConst.dop_cY_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms dop_cY_eq

/-- info: 'FloorConst.re_dop_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_dop_tendsto

/-- info: 'FloorConst.re_dop_tendsto_X' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_dop_tendsto_X

end FloorConst
