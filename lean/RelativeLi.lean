/-
RelativeLi — the relative-error gate with its main term discharged.

`RelativeGate.tableFrom_ne_zero_of_relErr` makes a cell nonzero from a
relative error on a window of rows, a floor `hM` under the main term's
stencil, and the gap. `Expansion.hD_of_window` with `MainTerm.stencilR_ge_of`
proves that floor for a smooth interpolant `G` of `li` along the doublings
(`G' = 2^x/x`). Nothing composed them: the Schoenfeld-shaped gate had its
composition (`Expansion.tableFrom_ne_zero_of_li`), the shape-free gate did
not. This file is that composition, and nothing else.

  tableFrom_ne_zero_of_relErr_li     relative error ρ on the window, the gap
                                       as stated in `RelativeGate`
  tableFrom_ne_zero_of_relErr_li'    the gap in its reduced form,
                                       ρ < (log 2)^d / (2·r·3^(d+1))
  tableFrom_ne_zero_of_powerSaving   a bound A·(2^m)^θ on the window, θ ≤ 1,
                                       with A·2^((r−d−1)(θ−1)) under the same
                                       threshold

The last is the inlet that `lean_stage3/Stage3/JointDialGate.lean` reaches
from a window bound on `G` (joint 6 of `SECTIONS.md`); the two trees are on
different toolchains and meet by statement, `utilities/check_weld.py`.

The interpolant `G` is a hypothesis here as in `Expansion` and `Schoenfeld`:
globally smooth, `G' = 2^x/x` on `x > 1/2`. No file constructs it.

Companion to units 0400–0402.
-/
import Mathlib
import RelativeGate
import Expansion

namespace RelativeLi

open Finset Set

/-- **The shape-free gate on the table, main term discharged.** -/
theorem tableFrom_ne_zero_of_relErr_li {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ}
    {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ => G k) r (d + 1) ρ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hgap : RelativeGate.EhighRel r (d + 1) ρ < Nonvanishing.Mlow r d) :
    Construction.tableFrom N r d ≠ 0 :=
  RelativeGate.tableFrom_ne_zero_of_relErr hrow hS
    (MainTerm.stencilR_ge_of hG (Expansion.hD_of_window hG' hbot hw)) hgap

/-- The same with the gap reduced to a bound on `ρ` alone. -/
theorem tableFrom_ne_zero_of_relErr_li' {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ}
    {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ => G k) r (d + 1) ρ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hρ : ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) :
    Construction.tableFrom N r d ≠ 0 := by
  have hr : (0 : ℝ) < r := by
    have : (0 : ℝ) ≤ (d : ℝ) := Nat.cast_nonneg d
    linarith
  exact tableFrom_ne_zero_of_relErr_li hG hG' hrow hS hbot hw
    ((RelativeGate.relGate_iff hr).mpr hρ)

/-- **From a power bound on the rows.** `|f(m) − G(m)| ≤ A·(2^m)^θ` on the
window with `θ ≤ 1`, and `A·2^((r−d−1)(θ−1))` under the gate's threshold. -/
theorem tableFrom_ne_zero_of_powerSaving {N : ℤ → ℤ} {f : ℤ → ℝ} {G : ℝ → ℝ}
    {r : ℤ} {d : ℕ} {A θ : ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hG' : ∀ x ∈ Ioi ((1 : ℝ) / 2), HasDerivAt G (Expansion.f2x x) x)
    (hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hA : 0 ≤ A) (hθ : θ ≤ 1)
    (hP : ∀ k ∈ range (d + 1 + 1),
      |f (r - k) - G ((r - k : ℤ) : ℝ)| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hρ : A * (2 : ℝ) ^ (((r : ℝ) - ((d + 1 : ℕ) : ℝ)) * (θ - 1))
      < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) :
    Construction.tableFrom N r d ≠ 0 :=
  tableFrom_ne_zero_of_relErr_li' hG hG' hrow
    (RelativeGate.powerSaving_relErr (f := f) (L := fun k : ℤ => G k) hA hθ hP) hbot hw hρ

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'RelativeLi.tableFrom_ne_zero_of_relErr_li' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeLi.tableFrom_ne_zero_of_relErr_li

/-- info: 'RelativeLi.tableFrom_ne_zero_of_relErr_li'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeLi.tableFrom_ne_zero_of_relErr_li'

/-- info: 'RelativeLi.tableFrom_ne_zero_of_powerSaving' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms RelativeLi.tableFrom_ne_zero_of_powerSaving

end RelativeLi
