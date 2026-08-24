/-
TransferOp — bdiff named as the operator it is, in Mathlib's own vocabulary.

`papers/Depth-as-Time.md` reads depth as iteration: each mode `x^ρ` is
multiplied by `(1 − b^(−ρ))` per step (A2), the operator has a growth factor
per mode (A3), and the first Riemann zero is the fastest-growing mode of the
difference operator in base 2 (B4). That is transfer-operator vocabulary —
`bdiff` is the transfer operator of the ladder shift, the modes are its
eigenfunctions, `Sym` its multiplier — and none of it was stated in the
formalization. `Chain.A1` proves the eigen-relation pointwise and stops.

This file says it in Mathlib's terms and proves it:

  * `bdiffL` — `Chain.bdiff` as a `Module.End ℂ (ℂ → ℂ)`. Linearity was used
    everywhere (`bdiff_smul`, `bdiff_sum`) and asserted nowhere.
  * `mode_hasEigenvector` — the mode `r ↦ b^(rρ)` IS an eigenvector with
    eigenvalue `Sym b ρ`, in the sense of `Module.End.HasEigenvector`.
  * `sym_hasEigenvalue` — hence `Sym b ρ` is in the point spectrum.
  * `mode_pow` — depth-`N` is the `N`-th power of the operator acting on the
    eigenline: `(bdiffL^N) mode = (Sym)^N • mode`, which is `Chain.A4` said
    as an operator identity via Mathlib's `HasEigenvector.pow_apply`.
  * `eigenvalue_zero_iff_lattice` — the kernel eigenvalue occurs exactly on
    the pole lattice `(2πi/log b)·ℤ`: `Chain.sym_eq_zero_iff` read as a
    statement about the operator's spectrum.

WHAT IS NOT CLAIMED. Ruelle's transfer-operator theory — trace formulas,
Fredholm determinants, a spectral gap — is not formalised here and is not
close. What is proved is the eigen-structure: the operator, its eigenfunctions,
its multipliers, and which multiplier vanishes where. The dynamical reading of
`papers/Depth-as-Time.md` § B — growth factors, the C2 band as the gain
spectrum on the critical line, γ₁ as the fastest-growing mode in base 2 — is
measurement recorded in that paper; this file supplies the algebra it reads
through.

Companion to papers/Depth-as-Time.md § A-B and notes entry 104.
-/
import Mathlib
import Chain

namespace TransferOp

open Complex Chain Module

/-- `Chain.bdiff`, packaged as a linear endomorphism of the function space.
The linearity was consumed all over the tree (`bdiff_smul`,
`Superposition.bdiff_sum`) and never stated as a structure. -/
noncomputable def bdiffL : Module.End ℂ (ℂ → ℂ) where
  toFun := bdiff
  map_add' f g := by
    funext r
    simp [bdiff]
    ring
  map_smul' c f := by
    funext r
    simp [bdiff]
    ring

/-- The packaging is definitional: applying the endomorphism is applying
`bdiff`. -/
@[simp]
theorem bdiffL_apply (f : ℂ → ℂ) : bdiffL f = bdiff f := rfl

/-- A mode never vanishes: `b^(rρ) ≠ 0` for `b ≠ 0`. -/
theorem mode_ne_zero' {b : ℝ} (hb : b ≠ 0) (ρ r : ℂ) : mode b ρ r ≠ 0 := by
  have hb' : (b : ℂ) ≠ 0 := by exact_mod_cast hb
  rw [Chain.mode]
  exact Complex.cpow_ne_zero_iff.mpr (Or.inl hb')

/-- Hence a mode is not the zero function. -/
theorem mode_ne_zero {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) : mode b ρ ≠ 0 := by
  intro h
  exact mode_ne_zero' hb ρ 0 (congrFun h 0)

/-- **The mode is an eigenvector, in Mathlib's sense.** `Chain.A1` is the
pointwise identity; this is the same fact carried into
`Module.End.HasEigenvector`, which is what makes the operator reading a
structure rather than a description. -/
theorem mode_hasEigenvector {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) :
    bdiffL.HasEigenvector (Sym b ρ) (mode b ρ) := by
  constructor
  · rw [End.mem_eigenspace_iff]
    funext r
    show bdiff (mode b ρ) r = (Sym b ρ • mode b ρ) r
    rw [Chain.A1 hb ρ r]
    rfl
  · exact mode_ne_zero hb ρ

/-- **`Sym b ρ` is in the point spectrum.** Every value of the symbol is an
eigenvalue of the difference operator. -/
theorem sym_hasEigenvalue {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) :
    bdiffL.HasEigenvalue (Sym b ρ) :=
  End.hasEigenvalue_of_hasEigenvector (mode_hasEigenvector hb ρ)

/-- **Depth is the operator power on the eigenline.** `(bdiffL^N) mode =
Sym^N • mode` — `Chain.A4` as an operator identity, via Mathlib's
`HasEigenvector.pow_apply`. -/
theorem mode_pow {b : ℝ} (hb : b ≠ 0) (ρ : ℂ) (N : ℕ) :
    (bdiffL ^ N) (mode b ρ) = (Sym b ρ) ^ N • mode b ρ :=
  (mode_hasEigenvector hb ρ).pow_apply N

/-- **The kernel eigenvalue sits exactly on the pole lattice.** The mode is
annihilated — eigenvalue 0 — precisely when `ρ ∈ (2πi/log b)·ℤ`, which is
`Chain.sym_eq_zero_iff` read as a statement about the operator. This is the
lattice `Transform.sym_zero_on_outer_circle` carries to `|z| = 1`. -/
theorem eigenvalue_zero_iff_lattice {b : ℝ} (hb : 0 < b) (hb1 : b ≠ 1) (ρ : ℂ) :
    bdiffL (mode b ρ) = 0 ↔ ∃ k : ℤ, ρ = (k : ℂ) * (2 * Real.pi * I / Real.log b) := by
  rw [← Chain.sym_eq_zero_iff hb hb1]
  constructor
  · intro h
    have h0 := congrFun h 0
    rw [bdiffL_apply, Chain.A1 hb.ne' ρ 0] at h0
    rcases mul_eq_zero.mp h0 with hs | hm
    · exact hs
    · exact absurd hm (mode_ne_zero' hb.ne' ρ 0)
  · intro hs
    funext r
    rw [bdiffL_apply, Chain.A1 hb.ne' ρ r, hs]
    simp

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'TransferOp.bdiffL_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.bdiffL_apply

/-- info: 'TransferOp.mode_ne_zero'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.mode_ne_zero'

/-- info: 'TransferOp.mode_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.mode_ne_zero

/-- info: 'TransferOp.mode_hasEigenvector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.mode_hasEigenvector

/-- info: 'TransferOp.sym_hasEigenvalue' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.sym_hasEigenvalue

/-- info: 'TransferOp.mode_pow' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.mode_pow

/-- info: 'TransferOp.eigenvalue_zero_iff_lattice' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TransferOp.eigenvalue_zero_iff_lattice

end TransferOp
