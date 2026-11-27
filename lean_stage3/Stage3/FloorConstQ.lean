/-
# FloorConstQ — block S13 of `lean_stage3/design/stencil.md`, B4 step 4, the closed form for a general Q: the limit and its value at a cubic Q. 2026-11-25.

The top module of B4 step 4. `FloorConstQDeriv` computes every partial of Young's `c(α,β)` in
the variables `a = Lα`, `b = Lβ`; `FloorConstQLimit` proves `DopQ Q L c (−R/L, −R/L) =
KflQ Q A B C (log M / log T) R` exactly and `Re DopQ c (T) → KflQ Q A B C θ R`. Here, at one choice:

* `P₀(x) = (87/100)x − (1/100)x² + (7/50)x³` (`P₀(0) = 0`, `P₀(1) = 1`):
  `A = 152147/150000`, `B = 1/2`, `C = 89707/300000`;
* `Q₀(x) = 1 − (27/50)x − (36/25)x² + (24/25)x³` (`Q₀(0) = 1`, `Q₀′(x) = Q₀′(1 − x)`);
* `θ = 49/100 < 1/2`, `R = 3/2`;

`K = KflQ Q₀ A B C θ R = r + c e³`, `r = −43809258948013/28350000000000`,
`c = 82265943397751/396900000000000`, and the Taylor bounds on `e^(1/2)` (eight terms and the
remainder) and on `e^(1203/1250)` (twelve terms) give `K < e^(R(1 − κ₀))` with `κ₀ = 224/625`.

The choice comes from unit 0551's `kappa.py`, its cubic-`P`, cubic-`Q` branch rerun at
`θ = 0.49` (`lean_stage3/checks/fcq/opt.py`, Nelder–Mead from twelve starts): optimum `κ = 0.358595` at
`R = 1.481`, `P ≈ 0.8713x − 0.0129x² + 0.1416x³`, `Q ≈ 1 − 0.5409x − 1.4532x² + 0.9688x³`;
rounded as above, Python gives `K = 2.6178534098…`, `κ = 1 − log K / R = 0.3584302…`,
and Young's (1.3) by quadrature gives the same `K` to 14 digits. Computed, not proved.

| name | content | status |
|---|---|---|
| `P0`, `Q0`, `kappaQ` | the polynomials; `κ = 1 − log K / R` | defined |
| `P0_zero`, `P0_one`, `Q0_zero`, `Q0_deriv_symm` | `P₀(0) = 0`, `P₀(1) = 1`, `Q₀(0) = 1`, `Q₀′(x) = Q₀′(1−x)` | proved |
| `Ar_P0`, `Br_P0`, `Cr_P0` | the three integrals | proved |
| `SB_Q0`, `SA_Q0`, `SC_Q0`, `KflQ_eq` | `K = r + c e³` | proved |
| `KflQ_lt` | `K < e^(R(1 − κ₀))` | proved |
| `log_KflQ_lt` | `log K < R (1 − κ₀)`, `κ₀ = 224/625 > 1/3` | proved |
| `kappaQ_gt` | `224/625 < κ` | proved |
| `floor_constQ` | the limit at `P₀`, `Q₀`, `θ = 49/100`, `R = 3/2`, with `log K < R(1 − κ₀)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorConstQLimit

namespace FloorConstQ

open Complex Filter Topology TwistedMoment Operator Polynomial

noncomputable section

/-- `P₀(x) = (7/50)x³ − (1/100)x² + (87/100)x`. -/
def P0 : ℝ[X] := C (7 / 50) * X ^ 3 + C (-1 / 100) * X ^ 2 + C (87 / 100) * X

/-- `Q₀(x) = (24/25)x³ − (36/25)x² − (27/50)x + 1`. -/
def Q0 : ℝ[X] := C (24 / 25) * X ^ 3 + C (-36 / 25) * X ^ 2 + C (-27 / 50) * X + C 1

/-- The proportion `κ = 1 − log K / R` at `P₀`, `Q₀`. -/
def kappaQ (θ R : ℝ) : ℝ :=
  1 - Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) θ R) / R

end

theorem P0_zero : P0.eval 0 = 0 := by simp [P0]

theorem P0_one : P0.eval 1 = 1 := by
  simp [P0]
  norm_num

theorem Q0_zero : Q0.eval 0 = 1 := by simp [Q0]

theorem Q0_deriv_symm (x : ℝ) : Q0.derivative.eval x = Q0.derivative.eval (1 - x) := by
  simp [Q0]
  ring

/-! ### The integrals -/

theorem integral_poly (S F : ℝ[X]) (h : ∀ x, F.derivative.eval x = S.eval x) :
    ∫ u in (0 : ℝ)..1, S.eval u = F.eval 1 - F.eval 0 := by
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (f := fun u => F.eval u)]
  · intro x _
    exact (F.hasDerivAt x).congr_deriv (h x)
  · exact S.continuous.intervalIntegrable 0 1

theorem Ar_P0 : FloorConst.Ar P0 = 152147 / 150000 := by
  have e : FloorConst.Ar P0 = ∫ u in (0 : ℝ)..1, (P0.derivative * P0.derivative).eval u := by
    unfold FloorConst.Ar
    simp only [eval_mul]
  rw [e, integral_poly _ (C (441 / 12500) * X ^ 5 + C (-21 / 5000) * X ^ 4 +
    C (457 / 1875) * X ^ 3 + C (-87 / 5000) * X ^ 2 + C (7569 / 10000) * X)]
  · simp
    norm_num
  · intro x
    simp [P0]
    ring

theorem Br_P0 : FloorConst.Br P0 = 1 / 2 := by
  have e : FloorConst.Br P0 = ∫ u in (0 : ℝ)..1, (P0.derivative * P0).eval u := by
    unfold FloorConst.Br
    simp only [eval_mul]
  rw [e, integral_poly _ (C (49 / 5000) * X ^ 6 + C (-7 / 5000) * X ^ 5 +
    C (2437 / 20000) * X ^ 4 + C (-87 / 10000) * X ^ 3 + C (7569 / 20000) * X ^ 2)]
  · simp
    norm_num
  · intro x
    simp [P0]
    ring

theorem Cr_P0 : FloorConst.Cr P0 = 89707 / 300000 := by
  have e : FloorConst.Cr P0 = ∫ u in (0 : ℝ)..1, (P0 * P0).eval u := by
    unfold FloorConst.Cr
    simp only [eval_mul]
  rw [e, integral_poly _ (C (7 / 2500) * X ^ 7 + C (-7 / 15000) * X ^ 6 +
    C (2437 / 50000) * X ^ 5 + C (-87 / 20000) * X ^ 4 + C (2523 / 10000) * X ^ 3)]
  · simp
    norm_num
  · intro x
    simp [P0]
    ring

/-! ### `Q₀` and the sums -/

theorem Q0_natDegree : Q0.natDegree = 3 := natDegree_cubic (by norm_num)

theorem Q0_c0 : Q0.coeff 0 = 1 := by simp [Q0]
theorem Q0_c1 : Q0.coeff 1 = -27 / 50 := by simp [Q0, coeff_one]
theorem Q0_c2 : Q0.coeff 2 = -36 / 25 := by simp [Q0, coeff_one]
theorem Q0_c3 : Q0.coeff 3 = 24 / 25 := by simp [Q0, coeff_one]

theorem ph0 : ph (3 / 2) 0 = -1 / 3 + 1 / 3 * Real.exp 3 := by
  rw [show ph (3 / 2) 0 = (1 - Real.exp (2 * (3 / 2))) / (-(2 * (3 / 2))) from rfl]
  norm_num
  ring

theorem ph_succ (R : ℝ) (n : ℕ) :
    ph R (n + 1) = (-(-1) ^ (n + 1) * Real.exp (2 * R) - ((n : ℝ) + 1) * ph R n) / (-(2 * R)) :=
  rfl

theorem ph1 : ph (3 / 2) 1 = -1 / 9 - 2 / 9 * Real.exp 3 := by
  rw [ph_succ, ph0]; norm_num; ring

theorem ph2 : ph (3 / 2) 2 = -2 / 27 + 5 / 27 * Real.exp 3 := by
  rw [ph_succ, ph1]; norm_num; ring

theorem ph3 : ph (3 / 2) 3 = -2 / 27 - 4 / 27 * Real.exp 3 := by
  rw [ph_succ, ph2]; norm_num; ring

theorem ph4 : ph (3 / 2) 4 = -8 / 81 + 11 / 81 * Real.exp 3 := by
  rw [ph_succ, ph3]; norm_num; ring

theorem ph5 : ph (3 / 2) 5 = -40 / 243 - 26 / 243 * Real.exp 3 := by
  rw [ph_succ, ph4]; norm_num; ring

theorem ph6 : ph (3 / 2) 6 = -80 / 243 + 29 / 243 * Real.exp 3 := by
  rw [ph_succ, ph5]; norm_num; ring

theorem SB_Q0 : SB Q0 (3 / 2) = 1 + 1 / 2500 * Real.exp 3 := by
  unfold SB gB
  rw [Q0_natDegree]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add, Q0_c0, Q0_c1, Q0_c2, Q0_c3]
  norm_num
  ring

theorem SA_Q0 : SA Q0 (3 / 2) = -29197 / 33750 + 5657 / 67500 * Real.exp 3 := by
  unfold SA
  rw [Q0_natDegree]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add, Q0_c0, Q0_c1, Q0_c2, Q0_c3]
  norm_num [ph0, ph1, ph2, ph3, ph4, ph5, ph6]
  ring

theorem SC_Q0 : SC Q0 (3 / 2) = -26057 / 15000 + 6877 / 30000 * Real.exp 3 := by
  unfold SC
  rw [Q0_natDegree]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add, Q0_c0, Q0_c1, Q0_c2, Q0_c3]
  norm_num [ph0, ph1, ph2, ph3, ph4, ph5, ph6]
  ring

/-- **`K = r + c e³`** at `P₀`, `Q₀`, `θ = 49/100`, `R = 3/2`. -/
theorem KflQ_eq :
    KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2) =
      -43809258948013 / 28350000000000 + 82265943397751 / 396900000000000 * Real.exp 3 := by
  rw [KflQ_lin, SB_Q0, SA_Q0, SC_Q0, Ar_P0, Br_P0, Cr_P0]
  ring

/-! ### The exponential bounds -/

theorem exp_half_le : Real.exp (1 / 2) ≤ 45381251 / 27525120 := by
  have h := Real.exp_bound' (x := 1 / 2) (by norm_num) (by norm_num) (n := 8) (by norm_num)
  refine h.trans (le_of_eq ?_)
  simp [Finset.sum_range_succ, Nat.factorial]
  norm_num

theorem exp_half_ge : 354541 / 215040 ≤ Real.exp (1 / 2) := by
  have h := Real.sum_le_exp_of_nonneg (x := 1 / 2) (by norm_num) 8
  refine le_trans (le_of_eq ?_) h
  simp [Finset.sum_range_succ, Nat.factorial]
  norm_num

theorem exp_three_eq : Real.exp 3 = Real.exp (1 / 2) ^ 6 := by
  rw [← Real.exp_nat_mul]
  norm_num

theorem exp_y_ge :
    ∑ i ∈ Finset.range 12, (1203 / 1250 : ℝ) ^ i / i.factorial ≤ Real.exp (1203 / 1250) :=
  Real.sum_le_exp_of_nonneg (by norm_num) 12

theorem KflQ_pos :
    0 < KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2) := by
  rw [KflQ_eq, exp_three_eq]
  have h : (354541 / 215040 : ℝ) ^ 6 ≤ Real.exp (1 / 2) ^ 6 :=
    pow_le_pow_left₀ (by norm_num) exp_half_ge 6
  have h3 : (0 : ℝ) < -43809258948013 / 28350000000000 +
      82265943397751 / 396900000000000 * (354541 / 215040 : ℝ) ^ 6 := by norm_num
  linarith

/-- **`K < e^(R(1 − κ₀))`**, `R(1 − κ₀) = 1203/1250`. -/
theorem KflQ_lt :
    KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2) <
      Real.exp (1203 / 1250) := by
  rw [KflQ_eq, exp_three_eq]
  have h : Real.exp (1 / 2) ^ 6 ≤ (45381251 / 27525120 : ℝ) ^ 6 :=
    pow_le_pow_left₀ (Real.exp_pos _).le exp_half_le 6
  have h2 := exp_y_ge
  have h3 : -43809258948013 / 28350000000000 +
      82265943397751 / 396900000000000 * (45381251 / 27525120 : ℝ) ^ 6 <
      ∑ i ∈ Finset.range 12, (1203 / 1250 : ℝ) ^ i / i.factorial := by
    simp [Finset.sum_range_succ, Nat.factorial]
    norm_num
  linarith

/-- **`log K < R(1 − κ₀)`** at `P₀`, `Q₀`, `θ = 49/100`, `R = 3/2`, `κ₀ = 224/625`. -/
theorem log_KflQ_lt :
    Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100)
      (3 / 2)) < 3 / 2 * (1 - 224 / 625) := by
  rw [show (3 / 2 : ℝ) * (1 - 224 / 625) = 1203 / 1250 by norm_num]
  exact (Real.log_lt_iff_lt_exp KflQ_pos).mpr KflQ_lt

/-- **`κ > κ₀ = 224/625 > 1/3`**. -/
theorem kappaQ_gt : 1 / 3 < (224 / 625 : ℝ) ∧ 224 / 625 < kappaQ (49 / 100) (3 / 2) := by
  refine ⟨by norm_num, ?_⟩
  unfold kappaQ
  have h := log_KflQ_lt
  have e : Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100)
      (3 / 2)) / (3 / 2) = Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0)
      (FloorConst.Cr P0) (49 / 100) (3 / 2)) * (2 / 3) := by ring
  rw [e]
  linarith

/-- **B4 step 4**: at `P₀`, `Q₀`, `θ = 49/100`, `R = 3/2`, `Re DopQ c (T) → K` with
`log K < R(1 − κ₀)`, `κ₀ = 224/625 > 1/3`. -/
theorem floor_constQ :
    Tendsto (fun T => (MeanQ.DopQ Q0 (Real.log T) (cY P0 (Mof T (49 / 100)) T)
      ((-((3 / 2) / Real.log T) : ℝ) : ℂ) ((-((3 / 2) / Real.log T) : ℝ) : ℂ)).re) atTop
      (𝓝 (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100) (3 / 2))) ∧
    Real.log (KflQ Q0 (FloorConst.Ar P0) (FloorConst.Br P0) (FloorConst.Cr P0) (49 / 100)
      (3 / 2)) < 3 / 2 * (1 - 224 / 625) ∧
    1 / 3 < (224 / 625 : ℝ) :=
  ⟨re_dopQ_tendsto Q0 P0 (by norm_num) (by norm_num), log_KflQ_lt, by norm_num⟩

/-- info: 'FloorConstQ.KflQ_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms KflQ_lt

/-- info: 'FloorConstQ.log_KflQ_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_KflQ_lt

/-- info: 'FloorConstQ.kappaQ_gt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms kappaQ_gt

/-- info: 'FloorConstQ.floor_constQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_constQ

end FloorConstQ
