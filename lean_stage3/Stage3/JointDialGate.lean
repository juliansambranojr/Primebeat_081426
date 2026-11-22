/-
JointDialGate — joints 3, 4, 5 of `SECTIONS.md`: the dial onto the table's gate.
Block 3 of `lean_stage3/design/joints.md`. 2026-11-22.

The dial gives `|π(x) − Li(x)| ≤ C·x^θ·(log x)^k` for large `x`. The table's
gate (`lean/RelativeGate.lean`) takes a relative error on a window of rows:
`|f(r−j) − L(r−j)| ≤ ρ·2^(r−j)`. Three steps between them:

  thetaWindow_of_global   read the bound at the rows, x = 2^(r−j)        (joint 3)
  log_absorbed            C·x^θ·(log x)^k ≤ A·x^θ' for θ' > θ, x ≥ 1      (joint 4)
  powerSaving_relErr      A·(2^m)^θ' is relative error A·2^((r−n)(θ'−1)) (joint 5)
  relErrWindow_of_theta   the three composed
  relErrWindow_of_window  from a window bound on `G` at θ, for any θ' in (θ, 1]:
                            ∃ A x₀, the gate's statement on the rows of π and Li

`StmtRelErrWindow` is a character-level copy of the table tree's definition;
`utilities/check_weld.py` holds the identity. `powerSaving_relErr` has the
table tree's statement and is reproved here, as `Stage3.window_of_global` was.
The weld caveat of `Stage3.lean` applies: the two trees are on different
toolchains and the kernel does not check the join.

What the next slice needs: the gate itself, `tableFrom_ne_zero_of_relErr` in
the table's tree, with its side conditions `hM` and `hgap` (joint 6).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.JointWindowDial
import Stage3.LandauKernel

namespace JointDialGate

open Finset

noncomputable section

/-- Character-level copy of `RelativeGate.StmtRelErrWindow` from the bench
tree (lean/RelativeGate.lean). The weld: utilities/check_weld.py verifies the
two definition bodies are textually identical. -/
def StmtRelErrWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) (ρ : ℝ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)| ≤ ρ * (2 : ℝ) ^ ((r : ℝ) - k)

theorem thetaWindow_of_global {θ C : ℝ} {k : ℕ} {x₀ : ℝ} {pi li : ℝ → ℝ}
    {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hpi : Stage3.StmtSchoenfeldWeakTheta θ C k x₀ pi li)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)))
    (hbot : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n)) :
    ∀ j ∈ range (n + 1), |f (r - j) - L (r - j)|
      ≤ C * ((2 : ℝ) ^ ((r : ℝ) - j)) ^ θ * Real.log ((2 : ℝ) ^ ((r : ℝ) - j)) ^ k := by
  intro j hj
  have hjn : j ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hcast : ((r - j : ℤ) : ℝ) = (r : ℝ) - j := by push_cast; ring
  have hyn : (r : ℝ) - n ≤ (r : ℝ) - j := by
    have : (j : ℝ) ≤ n := by exact_mod_cast hjn
    linarith
  have hx₀y : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - j) :=
    le_trans hbot (Real.rpow_le_rpow_of_exponent_le (by norm_num) hyn)
  rw [hf (r - j), hL (r - j), hcast]
  exact hpi _ hx₀y

theorem log_absorbed {θ θ' C : ℝ} {k : ℕ} (hC : 0 ≤ C) (hθ : θ < θ')
    {x : ℝ} (hx : 1 ≤ x) :
    C * x ^ θ * Real.log x ^ k
      ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ' := by
  have hx0 : 0 < x := by linarith
  have hε : 0 < 2 * (θ' - θ) := by linarith
  have h := LandauKernel.log_pow_le hε k hx
  have he : 2 * (θ' - θ) / 2 = θ' - θ := by ring
  rw [he] at h
  have hD : 0 < (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k := by positivity
  have hxθ : 0 ≤ x ^ θ := Real.rpow_nonneg hx0.le _
  have hsplit : x ^ θ' = x ^ θ * x ^ (θ' - θ) := by
    rw [← Real.rpow_add hx0]; congr 1; ring
  calc C * x ^ θ * Real.log x ^ k
      ≤ C * x ^ θ * (x ^ (θ' - θ) / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k) :=
        mul_le_mul_of_nonneg_left h (mul_nonneg hC hxθ)
    _ = C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ' := by
        rw [hsplit]; field_simp

/-- Statement identical to `RelativeGate.powerSaving_relErr` of the bench
tree; reproved on this toolchain. -/
theorem powerSaving_relErr {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} {A θ : ℝ}
    (hA : 0 ≤ A) (hθ : θ ≤ 1)
    (hP : ∀ k ∈ range (n + 1),
      |f (r - k) - L (r - k)| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ) :
    StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) := by
  intro k hk
  refine (hP k hk).trans ?_
  have h2 : (0 : ℝ) < 2 := by norm_num
  have hkn : (k : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hlhs : ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ = (2 : ℝ) ^ (((r : ℝ) - k) * θ) := by
    rw [← Real.rpow_mul h2.le]
  have hrhs : (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1)) * (2 : ℝ) ^ ((r : ℝ) - k)
      = (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1) + ((r : ℝ) - k)) := by
    rw [← Real.rpow_add h2]
  rw [hlhs, mul_assoc, hrhs]
  refine mul_le_mul_of_nonneg_left ?_ hA
  refine Real.rpow_le_rpow_of_exponent_le (by norm_num) ?_
  nlinarith [hkn, hθ]

theorem relErrWindow_of_theta {θ θ' C : ℝ} {k : ℕ} {x₀ : ℝ} {pi li : ℝ → ℝ}
    {f L : ℤ → ℝ} {r : ℤ} {n : ℕ}
    (hpi : Stage3.StmtSchoenfeldWeakTheta θ C k x₀ pi li) (hC : 0 ≤ C)
    (hθ : θ < θ') (hθ' : θ' ≤ 1)
    (hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)))
    (hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)))
    (hbot : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n)) (hpos : 0 ≤ (r : ℝ) - n) :
    StmtRelErrWindow f L r n
      (C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) := by
  have hD : 0 < (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k := by
    have : 0 < 2 * (θ' - θ) := by linarith
    positivity
  refine powerSaving_relErr (div_nonneg hC hD.le) hθ' (fun j hj => ?_)
  have hjn : (j : ℝ) ≤ n := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
  have hx1 : (1 : ℝ) ≤ (2 : ℝ) ^ ((r : ℝ) - j) :=
    Real.one_le_rpow (by norm_num) (by linarith)
  exact le_trans (thetaWindow_of_global hpi hf hL hbot j hj) (log_absorbed hC hθ hx1)

theorem relErrWindow_of_window {θ δ C₀ θ' : ℝ} (hθlo : 1 / 2 ≤ θ) (hθ1 : θ < 1)
    (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C₀) (hθ : θ < θ') (hθ' : θ' ≤ 1) :
    ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) →
      0 ≤ (r : ℝ) - n →
      StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r n
        (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) := by
  obtain ⟨C, hC, x₀, hpi⟩ := JointWindowDial.schoenfeldWeakTheta_of_window hθlo hθ1 hδ hW
  have hD : 0 < (2 * (θ' - θ) / (2 * (((2 : ℕ) : ℝ) + 1))) ^ 2 := by
    have : 0 < 2 * (θ' - θ) := by linarith
    positivity
  refine ⟨C / (2 * (θ' - θ) / (2 * (((2 : ℕ) : ℝ) + 1))) ^ 2, x₀,
    div_nonneg hC.le hD.le, fun r n hbot hpos => ?_⟩
  exact relErrWindow_of_theta hpi hC.le hθ hθ' (fun _ => rfl) (fun _ => rfl) hbot hpos

/-- info: 'JointDialGate.thetaWindow_of_global' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms thetaWindow_of_global

/-- info: 'JointDialGate.powerSaving_relErr' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms powerSaving_relErr

/-- info: 'JointDialGate.relErrWindow_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms relErrWindow_of_window

end

end JointDialGate
