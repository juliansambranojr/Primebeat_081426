/-
ExactRH — the Schoenfeld-shaped ceiling against the exact floor.

The relative ceiling `ρ·2^r·(3/2)^(d+1)` loses about half a bit per unit of depth
against the error stencil (measured to row 92 this session): an error of size `2^(m/2)`
charged the window bottom's relative error everywhere. `Nonvanishing.Ehigh` charges each
value its own `√x·log x/(8π)` and sums to `2^(r/2)·(1 + 2^(−1/2))^(d+1)`. Here it meets
the exact floor `ExactGate.floorX`.
-/
import Mathlib
import ExactBand

namespace ExactRH
open Finset Nonvanishing ExactGate

/-- **The gate: Schoenfeld's window against the exact floor.** -/
theorem tableFrom_ne_zero_rh {N : ℤ → ℤ} {f : ℤ → ℝ} {r : ℤ} {d : ℕ}
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k))
    (hS : StmtSchoenfeldWindow f (fun k : ℤ => Interpolant.liRow k) r (d + 1))
    (hband : 3 * (d : ℝ) + 1 < r)
    (hgap : Ehigh r (d + 1) < floorX r d) :
    Construction.tableFrom N r d ≠ 0 := by
  intro hzero
  have hM := floorX_le d r hband
  have hdr : ((d + 1 : ℕ) : ℤ) ≤ r := by
    have : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    push_cast; omega
  have hnz : stencilR (d + 1) f r ≠ 0 := by
    intro h0
    have herr := error_bound hdr hS
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

/-- **The four zeros under Schoenfeld's window.** Every zero in rows to 92, or past row 92 at
a cell of the band `3d + 1 < r` where Schoenfeld's ceiling is under the exact floor, is one of
the four. The input `hRH` is Schoenfeld's inequality `|π(x) − Li(x)| ≤ √x·log x/(8π)` at the
points `x = 2^m` the windows read, named and not proved. -/
theorem only_four_zeros_rh (hpi : DepthSix.StmtPiData)
    (hRH : ∀ r : Int, 92 < r → ∀ d : Nat,
      StmtSchoenfeldWindow ToInfinity.piRow (fun k : Int => Interpolant.liRow k) r (d + 1))
    {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r)
    (hin : r ≤ 92 ∨ (3 * (d : ℝ) + 1 < r ∧ Ehigh r (d + 1) < floorX r d))
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92 (by rw [ToInfinity.cell_eq_true hpi r d hlo h92]; exact hz)
  · exfalso
    obtain ⟨hband, hgap⟩ := hin.resolve_left h92
    refine tableFrom_ne_zero_rh (f := ToInfinity.piRow) ?_ (hRH r (by omega) d) hband hgap hz
    intro k hk
    have := Finset.mem_range.mp hk
    have hbZ : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    exact ToInfinity.trueRow_eq_bdiff (by omega)

end ExactRH

/-- info: 'ExactRH.only_four_zeros_rh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactRH.only_four_zeros_rh
