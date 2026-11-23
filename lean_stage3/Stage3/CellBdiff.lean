/-
CellBdiff — block T1b of `lean_stage3/design/joints.md`. 2026-11-22.

Joint T1 on the table tree's own operator. `CellZeros.stencil` is a second
writing of `d` backward differences. The table tree's writing is `Chain.bdiff`
iterated `d` times, the operator `Chain.A4` and `Superposition` are stated on.
Here the two are shown equal on any row, and the cell theorem is restated with
`bdiff^[d]`, `Sym`, `mode` and `modeSum`, all four from the table tree.

  bdZ                         one backward difference on rows ℤ → ℂ
  iter_bdZ_eq_fwdDiff         bdZ^[n] is (−1)^n times the forward difference at step −1
  iter_bdZ_eq_stencil         bdZ^[n] a r = CellZeros.stencil n a r
  bdiff_iter_eq_bdZ           g = a on the integers ⊢ bdiff^[d] g r = bdZ^[d] a r
  stencil_eq_bdiff_iter       g = a on the integers ⊢ stencil d a r = bdiff^[d] g r
  psiRow                      the row of the log-weighted count, on ℂ
  psiRow_int                  psiRow n = ψ(2^n)
  cell_eq_modeSum_bdiff       `CellModes.cell_eq_modeSum` with bdiff^[d] psiRow

What the next slice needs: `CellZeros.stencil` retired in favour of
`bdiff^[d]` in the modules that follow it.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CellModes

namespace CellBdiff

open Finset

noncomputable section

/-- One backward difference on a row indexed by the integers. -/
def bdZ (a : ℤ → ℂ) : ℤ → ℂ := fun x => a x - a (x - 1)

/-- `n` backward differences of a row are `(−1)^n` times its `n`-th forward difference at step `−1`. -/
theorem iter_bdZ_eq_fwdDiff (a : ℤ → ℂ) (r : ℤ) (n : ℕ) :
    (bdZ^[n]) a r = (-1 : ℂ) ^ n * (fwdDiff (-1 : ℤ))^[n] a r := by
  induction n generalizing r with
  | zero => simp
  | succ m ih =>
      rw [Function.iterate_succ_apply' bdZ m a]
      show (bdZ^[m]) a r - (bdZ^[m]) a (r - 1) = _
      rw [ih r, ih (r - 1), Function.iterate_succ_apply' (fwdDiff (-1 : ℤ)) m a]
      show _ = (-1 : ℂ) ^ (m + 1) *
        ((fwdDiff (-1 : ℤ))^[m] a (r + (-1)) - (fwdDiff (-1 : ℤ))^[m] a r)
      rw [show r + (-1 : ℤ) = r - 1 by ring, pow_succ]
      ring

/-- **`n` backward differences are the stencil.** -/
theorem iter_bdZ_eq_stencil (a : ℤ → ℂ) (r : ℤ) (n : ℕ) :
    (bdZ^[n]) a r = CellZeros.stencil n a r := by
  rw [iter_bdZ_eq_fwdDiff, fwdDiff_iter_eq_sum_shift, CellZeros.stencil, Finset.mul_sum]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hkd : k ≤ n := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hsign : (-1 : ℂ) ^ n * (-1 : ℂ) ^ (n - k) = (-1 : ℂ) ^ k := by
    rw [← pow_add, show n + (n - k) = 2 * (n - k) + k by omega, pow_add, pow_mul]
    norm_num
  have hshift : r + k • (-1 : ℤ) = r - (k : ℤ) := by
    simp [sub_eq_add_neg]
  rw [hshift]
  simp only [zsmul_eq_mul]
  push_cast
  linear_combination ((n.choose k : ℂ)) * a (r - (k : ℤ)) * hsign

/-- The table tree's operator on a function of `ℂ` agrees with the row's on
the integers. -/
theorem bdiff_iter_eq_bdZ {a : ℤ → ℂ} {g : ℂ → ℂ} (hag : ∀ n : ℤ, g (n : ℂ) = a n)
    (d : ℕ) (r : ℤ) : (Chain.bdiff^[d]) g (r : ℂ) = (bdZ^[d]) a r := by
  induction d generalizing r with
  | zero => simpa using hag r
  | succ m ih =>
      rw [Function.iterate_succ_apply' Chain.bdiff m g, Function.iterate_succ_apply' bdZ m a]
      show (Chain.bdiff^[m]) g (r : ℂ) - (Chain.bdiff^[m]) g ((r : ℂ) - 1)
        = (bdZ^[m]) a r - (bdZ^[m]) a (r - 1)
      rw [ih r, ← ih (r - 1)]
      push_cast
      ring

/-- **The stencil is the table tree's operator, iterated.** -/
theorem stencil_eq_bdiff_iter {a : ℤ → ℂ} {g : ℂ → ℂ} (hag : ∀ n : ℤ, g (n : ℂ) = a n)
    (d : ℕ) (r : ℤ) : CellZeros.stencil d a r = (Chain.bdiff^[d]) g (r : ℂ) := by
  rw [bdiff_iter_eq_bdZ hag, iter_bdZ_eq_stencil]

/-- The row of the log-weighted prime count along the doublings, on `ℂ`. -/
def psiRow : ℂ → ℂ := fun z => (Chebyshev.psi ((2:ℝ) ^ z.re) : ℂ)

/-- On an integer the row is the log-weighted prime count at that doubling. -/
theorem psiRow_int (n : ℤ) : psiRow (n : ℂ) = (Chebyshev.psi ((2:ℝ) ^ n) : ℂ) := by
  unfold psiRow
  rw [Complex.intCast_re, Real.rpow_intCast]

/-- **The cell on the table tree's operators.** `d` backward differences of the
row, with `Chain.bdiff`, are the main mode minus the reweighted sum of the
zeros' modes, within the stated error. -/
theorem cell_eq_modeSum_bdiff (d : ℕ) (r : ℤ) {T : ℝ}
    [Fintype {ρ : Kadiri.NontrivialZeros // |(ρ : ℂ).im| < T}]
    (h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)))
    (hT : 2 ≤ T) (hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2) :
    ‖(Chain.bdiff^[d]) psiRow (r : ℂ)
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
  rw [← stencil_eq_bdiff_iter psiRow_int d r]
  exact CellModes.cell_eq_modeSum d r h16 hT hTx

end

/-- info: 'CellBdiff.stencil_eq_bdiff_iter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stencil_eq_bdiff_iter

/-- info: 'CellBdiff.cell_eq_modeSum_bdiff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms cell_eq_modeSum_bdiff

end CellBdiff
