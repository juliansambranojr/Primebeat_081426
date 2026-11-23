/-
OneChain — block J4 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The capstone: Julian's closed loop tied to the tree's main theorems, so that
the loop and the tree are one chain of theorems.

Blocks J1 to J3 put the closed loop's statements in Stage 3 and tied them to
the mirror of a mode and to the zeros. This module ties the loop's central
proposition, `SpiralLink` (the handshake at every zero; equivalently one zero
at each height; equivalently the restoring force at rest at every zero), to:

  the table (T5)        `CellResidual.RH_iff_cells`, `table_cell_resid`
  joint 10, the count   `FiniteOffLinePi.finite_off_line_pi`,
                        `AttainedPi.attained_off_line_pi`,
                        `CountEuler.euler_exposed_false`
  joint 10, ψ           `FilterAttained.attained_psi`,
                        `FilterAccum.rh_of_finite_accumulation`

Through those it rests on the explicit formula at every height, the
zero-density bound, the filters and the count's modes: its axiom pins read
through the whole tree.

  one_chain                     RH, the spiral link, one zero at each height,
                                the force at rest, and every cell of every
                                dyadic ladder at square-root size: one statement
  spiralLink_iff_cells          the loop's proposition ↔ a statement about the
                                table with no zero in it
  table_of_spiralLink           the spiral link ⊢ every cell of the integer
                                table within square-root size
  spiralLink_of_finite          the count's ladder bound + finitely many zeros
                                off the line ⊢ the spiral link
  spiralLink_of_attained        … + a largest real part attained ⊢ the spiral link
  spiralLink_of_attained_psi, spiralLink_of_finite_accumulation   on ψ's ladder
  no_exposed_zero               the count's ladder bound ⊢ no zero right of E
                                stands outside a disc holding the others

What this does not contain: a proof of `SpiralLink` with no hypothesis.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ClosedLoopChain
import Stage3.CellResidual
import Stage3.AttainedPi
import Stage3.FilterAccum
import Stage3.CountEuler

namespace OneChain

open Kadiri ClosedLoopJoin SpiralLink

/-- **The loop and the table.** The spiral link holds exactly when every cell of
every dyadic ladder stays at square-root size: a statement about the count of
primes with no zero in it. -/
theorem spiralLink_iff_cells :
    SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀ :=
  rh_iff_spiralLink.symm.trans CellResidual.RH_iff_cells

/-- **One chain.** The Riemann hypothesis, the spiral link, one zero at each
height, the restoring force at rest at every zero, and every cell of every
dyadic ladder at square-root size are one statement. -/
theorem one_chain :
    (RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧
    (SpiralLink.SpiralLink ↔ OneAtEachHeight) ∧
    (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, restoringForce (ρ : ℂ).re = 0) ∧
    (SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀) :=
  ⟨rh_iff_spiralLink, spiralLink_iff_one,
    rh_iff_spiralLink.symm.trans rh_iff_force_zero, spiralLink_iff_cells⟩

/-- **From the loop to the integer table.** If the spiral link holds, every cell
of the integer table stays within square-root size of the smooth cell. -/
theorem table_of_spiralLink (h : SpiralLink.SpiralLink) :
    ∃ (C : ℝ) (r₀ : ℤ), ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
      |((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
          - Nonvanishing.stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r|
        ≤ C * CellResidual.cellSize r d :=
  CellResidual.table_cell_resid (rh_iff_spiralLink.mpr h)

/-- **From the count's ladder to the loop, finitely many zeros off the line.** -/
theorem spiralLink_of_finite (F : Finset NontrivialZeros)
    (hF : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≠ 1 / 2 → ρ ∈ F) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) : SpiralLink.SpiralLink :=
  rh_iff_spiralLink.mp (FiniteOffLinePi.finite_off_line_pi F hF C hrows)

/-- **From the count's ladder to the loop, a largest real part attained.** -/
theorem spiralLink_of_attained (ρ₀ : NontrivialZeros)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) : SpiralLink.SpiralLink :=
  rh_iff_spiralLink.mp (AttainedPi.attained_off_line_pi ρ₀ hmax C hrows)

/-- **From ψ's ladder to the loop, a largest real part attained.** -/
theorem spiralLink_of_attained_psi {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (ρ₀ : NontrivialZeros)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) : SpiralLink.SpiralLink :=
  rh_iff_spiralLink.mp (FilterAttained.attained_psi hH ρ₀ hmax)

/-- **From ψ's ladder to the loop, modes accumulating at finitely many points.** -/
theorem spiralLink_of_finite_accumulation {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → ‖(Chebyshev.psi ((2:ℝ)^k) : ℂ) - (((2:ℝ)^k : ℝ) : ℂ)‖
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    (hfin : ∀ σ : ℝ, 1/2 < σ → ∃ P : Finset ℂ, (∀ p ∈ P, p ≠ 0) ∧
      (∀ ε : ℝ, 0 < ε → {z : ℂ | ∃ ρ : NontrivialZeros, σ ≤ (ρ : ℂ).re ∧
        (2:ℂ) ^ (ρ : ℂ) = z ∧ ∀ p ∈ P, ε ≤ ‖z - p‖}.Finite) ∧
      (∀ ρ : NontrivialZeros, σ < (ρ : ℂ).re → (2:ℂ) ^ (ρ : ℂ) ∉ P)) :
    SpiralLink.SpiralLink :=
  rh_iff_spiralLink.mp (FilterAccum.rh_of_finite_accumulation hH hfin)

/-- **The count's ladder excludes an exposed zero.** Under the square-root
bound on the count at the doublings there is an exponent below the bound on the
real parts such that no zero right of it has its mode strictly outside a disc,
centred on the ray opposite to it, that holds the mode of every other zero
right of the line. -/
theorem no_exposed_zero {C : ℝ}
    (hH : ∀ k : ℕ, 1 ≤ k → |(Nat.primeCounting ⌊(2:ℝ)^k⌋₊ : ℝ) - Stage3.Li ((2:ℝ)^k)|
      ≤ C * (k:ℝ)^2 * Real.sqrt 2 ^ k)
    {σ Θ : ℝ} (hσ : 1/2 < σ) (hσΘ : σ < Θ) (hΘ1 : Θ ≤ 1)
    (hΘ : ∀ ρ : NontrivialZeros, (ρ:ℂ).re ≤ Θ) :
    ∃ E : ℝ, σ ≤ E ∧ E < Θ ∧ ∀ (ρ₁ : NontrivialZeros), E < (ρ₁:ℂ).re →
      ∀ κ r₀ : ℝ, 0 ≤ κ → r₀ < ‖(2:ℂ)^(ρ₁:ℂ)‖ + κ →
      (∀ ρ : NontrivialZeros, σ ≤ (ρ:ℂ).re → (2:ℂ)^(ρ:ℂ) ≠ (2:ℂ)^(ρ₁:ℂ) →
        ‖(2:ℂ)^(ρ:ℂ) + (κ:ℂ) * ((2:ℂ)^(ρ₁:ℂ) / ‖(2:ℂ)^(ρ₁:ℂ)‖)‖ ≤ r₀) → False :=
  CountEuler.euler_exposed_false hH hσ hσΘ hΘ1 hΘ

/-- info: 'OneChain.one_chain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms one_chain

/-- info: 'OneChain.table_of_spiralLink' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms table_of_spiralLink

/-- info: 'OneChain.spiralLink_of_finite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_of_finite

/-- info: 'OneChain.spiralLink_of_attained' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_of_attained

/-- info: 'OneChain.spiralLink_of_finite_accumulation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_of_finite_accumulation

/-- info: 'OneChain.no_exposed_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms no_exposed_zero

end OneChain
