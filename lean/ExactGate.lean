/-
ExactGate — the census gate on the exact floor.

`RelativeGate.tableFrom_ne_zero_of_relErr` compares the error ceiling `EhighRel` with
`Mlow`, which loses `(1/log 2)^d` (unit 0594). Here the floor is the one `SmoothRow`
proves for the smooth row, `2^(r−d)·H(r)·(1 − q/(1−q))` with `q = d/(r − 1 − d)`, valid
across the whole band `3d + 1 < r`.
-/
import Mathlib
import RelativeGate
import SmoothRow

namespace ExactGate
open Finset Nonvanishing RelativeGate ExactFloor SmoothRow

noncomputable section

/-- The exact floor of the smooth row's depth-`d` stencil at row `r`. -/
def floorX (r : ℤ) (d : ℕ) : ℝ :=
  let q := (d : ℝ) / ((r : ℝ) - 1 - d)
  (2 : ℝ) ^ (r - d) * H w2 r * (1 - q / (1 - q))

/-- **The floor under the main term.** -/
theorem floorX_le (d : ℕ) (r : ℤ) (hband : 3 * (d : ℝ) + 1 < r) :
    floorX r d ≤ |stencilR (d + 1) (fun k : ℤ => Interpolant.liRow k) r| := by
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr : (d : ℝ) + 1 < r := by linarith
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  have hq1 : (d : ℝ) / ((r : ℝ) - 1 - d) < 1 := by rw [div_lt_one hden]; linarith
  rw [← stencilR_row]
  have heq : stencilR d (bdiffZ fun k : ℤ => Interpolant.liRow k) r
      = stencilR d (fun m => (2 : ℝ) ^ m * H w2 m) r := by
    unfold stencilR
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk' : (k : ℝ) ≤ d := by exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
    have hbZ : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    have hkZ : (k : ℤ) ≤ d := by exact_mod_cast hk'
    have h2 : (2 : ℤ) ≤ r - k := by omega
    show _ * (Interpolant.liRow ((r - k : ℤ) : ℝ) - Interpolant.liRow ((r - k - 1 : ℤ) : ℝ)) = _
    rw [liRow_sub_eq (m := r - k) (by exact_mod_cast h2)]
  rw [heq]
  have hF := stencil_H_floor w2_cont w2_nonneg d r hr hq1
  have := (abs_le.mp hF).1
  unfold floorX
  simp only
  refine le_trans ?_ (le_abs_self _)
  nlinarith

/-- **The gate on the exact floor.** -/
theorem tableFrom_ne_zero_exact {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k))
    (hS : StmtRelErrWindow f (fun k : ℤ => Interpolant.liRow k) r (d + 1) ρ)
    (hband : 3 * (d : ℝ) + 1 < r)
    (hgap : EhighRel r (d + 1) ρ < floorX r d) :
    Construction.tableFrom N r d ≠ 0 := by
  intro hzero
  have hM := floorX_le d r hband
  have hnz : stencilR (d + 1) f r ≠ 0 := by
    intro h0
    have herr := relError_bound hS
    rw [stencilR_sub, h0, zero_sub, abs_neg] at herr
    linarith
  apply hnz
  rw [← stencilR_row]
  have hcast : ((Construction.tableFrom N r d : ℤ) : ℝ)
      = stencilR d (fun x => ((N x : ℤ) : ℝ)) r := by
    rw [Zeros.tableFrom_eq_stencil, Zeros.stencil, stencilR]
    push_cast
    rfl
  have hwin : stencilR d (fun x => ((N x : ℤ) : ℝ)) r = stencilR d (bdiffZ f) r := by
    unfold stencilR
    refine Finset.sum_congr rfl fun k hk => ?_
    have hk2 : k ∈ range (d + 2) := by
      have := Finset.mem_range.mp hk
      exact Finset.mem_range.mpr (by omega)
    show (-1 : ℝ) ^ k * (d.choose k) * ((N (r - k) : ℤ) : ℝ) = _
    rw [hrow k hk2]
  rw [← hwin, ← hcast, hzero]
  norm_num

end

end ExactGate

/-- info: 'ExactGate.tableFrom_ne_zero_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactGate.tableFrom_ne_zero_exact
