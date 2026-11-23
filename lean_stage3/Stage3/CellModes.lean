/-
CellModes — block T1 of `lean_stage3/design/joints.md`, second part. 2026-11-22.

`CellZeros.cell_eq_zero_sum` in the table tree's own terms. That tree's
`Superposition.tableFrom_eq_modeSum_reweighted` says: a row that is a sum of
modes gives cells that are the same sum with each mode multiplied by the
symbol at each depth. Its hypothesis, that the row is a sum of modes, was
discharged nowhere. Here the row is `ψ` at the doublings, the modes are the
zeros of ζ below a height with coefficients `m(ρ)/ρ`, and the conclusion holds
within the explicit formula's error. `Chain` and `Superposition` are the
ported copies in `Stage3/TablePort/`.

  mode_two_int      Chain.mode 2 ρ r = ((2:ℂ)^ρ)^r on integer r
  sym_two           Chain.Sym 2 ρ = 1 − ((2:ℂ)^ρ)⁻¹
  cell_eq_modeSum   16 ≤ 2^(r−d), 2 ≤ T ≤ (2^(r−d))²
                      ⊢ ‖stencil d (n ↦ ψ(2^n)) r − Sym 2 1 ^ d · mode 2 1 r
                           + modeSum 2 ρ (ρ ↦ m(ρ)/ρ · Sym 2 ρ ^ d) (zeros below T) r‖
                        ≤ Σ_{j ≤ d} C(d,j)·E(2^(r−j), T)

Read: the residuals of the differences of the prime count along the doublings
are the zeros of ζ, each a mode, each multiplied by the symbol once per depth.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CellZeros
import Stage3.TablePort.Superposition

namespace CellModes

open Finset

noncomputable section

/-- At an integer `r`, the base-2 mode of exponent `ρ` is the integer power `(2^ρ)^r`. -/
theorem mode_two_int (ρ : ℂ) (r : ℤ) : Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r := by
  unfold Chain.mode
  have h2 : (((2:ℝ)) : ℂ) = 2 := by norm_num
  rw [h2, Complex.cpow_def_of_ne_zero (by norm_num : (2:ℂ) ≠ 0),
    Complex.cpow_def_of_ne_zero (by norm_num : (2:ℂ) ≠ 0), ← Complex.exp_int_mul]
  congr 1
  ring

/-- The base-2 symbol at `ρ` is `1 − (2^ρ)⁻¹`. -/
theorem sym_two (ρ : ℂ) : Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ := by
  unfold Chain.Sym
  have h2 : (((2:ℝ)) : ℂ) = 2 := by norm_num
  rw [h2, Complex.cpow_neg]

/-- **The cell as a reweighted sum of modes, one for each zero.** -/
theorem cell_eq_modeSum (d : ℕ) (r : ℤ) {T : ℝ}
    [Fintype {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T}]
    (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖CellZeros.stencil d (fun n : ℤ => (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r
        - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ)
        + Superposition.modeSum 2
            (fun ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T} =>
              ((ρ : Kadiri.NontrivialZeros) : ℂ))
            (fun ρ => ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
              / ((ρ : Kadiri.NontrivialZeros) : ℂ)
              * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d)
            Finset.univ (r : ℂ)‖
      ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ)
          * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T
              + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ)))
              + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2
                  * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) := by
  have h := CellZeros.cell_eq_zero_sum d r h16 hT hTx
  have hmain : Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ)
      = (2:ℂ) ^ r * (1 - (2:ℂ)⁻¹) ^ d := by
    rw [mode_two_int, sym_two, Complex.cpow_one]
    ring
  have hsum : Superposition.modeSum 2
        (fun ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T} =>
          ((ρ : Kadiri.NontrivialZeros) : ℂ))
        (fun ρ => ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
          / ((ρ : Kadiri.NontrivialZeros) : ℂ)
          * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d)
        Finset.univ (r : ℂ)
      = ∑' ρ : {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T},
          ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ)
            * (((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ)) ^ r
                * (1 - ((2:ℂ) ^ ((ρ : Kadiri.NontrivialZeros) : ℂ))⁻¹) ^ d
                / ((ρ : Kadiri.NontrivialZeros) : ℂ)) := by
    rw [tsum_fintype]
    unfold Superposition.modeSum
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [mode_two_int]
    beta_reduce
    rw [sym_two]
    ring
  rw [hmain, hsum]
  exact h

end

/-- info: 'CellModes.cell_eq_modeSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_modeSum

end CellModes
