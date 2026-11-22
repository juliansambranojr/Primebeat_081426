/-
AliasClass — block J10a of `lean_stage3/design/joints.md`. 2026-11-22.

Joint 10 on the table's own ladder, first piece. On the ladder `2^r` a zero
`ρ` of ζ enters only through `z = 2^ρ`: its mode at row `r` is `z^r` and its
symbol is `1 − z⁻¹`. Zeros with the same `z` have the same real part and
heights that differ by a multiple of `2π/log 2`; the ladder folds them
together. This module proves that folding never cancels: the zeros sharing a
`z` contribute to the cell one mode whose weight is not zero, at every depth.

  re_inv_pos             0 < ρ.re ⊢ 0 < (ρ⁻¹).re
  zero_re_pos            a nontrivial zero has positive real part
  re_order_div_pos       0 < Re (m(ρ)/ρ) at a nontrivial zero
  sum_order_div_ne_zero  S nonempty ⊢ Σ ρ ∈ S, m(ρ)/ρ ≠ 0
  sym_eq_of_alias        2^ρ = 2^ρ' ⊢ Chain.Sym 2 ρ = Chain.Sym 2 ρ'
  mode_eq_of_alias       2^ρ = 2^ρ' ⊢ Chain.mode 2 ρ r = Chain.mode 2 ρ' r at integer r
  alias_weight           2^ρ = z on S ⊢ Σ ρ ∈ S, m(ρ)/ρ·Sym 2 ρ^d·mode 2 ρ r
                           = (Σ ρ ∈ S, m(ρ)/ρ)·(1 − z⁻¹)^d·z^r
  alias_weight_ne_zero   S nonempty, 2^ρ = z on S ⊢ that sum is not zero

What the next slice needs: the step from "every folded class has nonzero
weight" to "the cells of one ladder cannot all stay small"; it is open in the
block.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.CellModes

namespace AliasClass

open Finset

noncomputable section

/-- The reciprocal of a point right of the imaginary axis is right of it too. -/
theorem re_inv_pos {ρ : ℂ} (h : 0 < ρ.re) : 0 < (ρ⁻¹).re := by
  have hne : ρ ≠ 0 := fun h0 => by simp [h0] at h
  rw [Complex.inv_re]
  exact div_pos h (Complex.normSq_pos.mpr hne)

/-- A nontrivial zero of ζ has positive real part. -/
theorem zero_re_pos (ρ : Kadiri.NontrivialZeros) : 0 < (ρ : ℂ).re := ρ.2.1.1

/-- The coefficient a zero carries in the cell, `m(ρ)/ρ`, has positive real part. -/
theorem re_order_div_pos (ρ : Kadiri.NontrivialZeros) :
    0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re := by
  have hm : (0 : ℝ) < ((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) := by
    exact_mod_cast Kadiri.riemannZeta_order_pos_nontrivialZero ρ
  have h : (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
      = (((riemannZeta.order (ρ : ℂ) : ℤ) : ℝ) : ℂ) * ((ρ : ℂ))⁻¹ := by
    rw [div_eq_mul_inv]
    push_cast
    rfl
  rw [h, Complex.re_ofReal_mul]
  exact mul_pos hm (re_inv_pos (zero_re_pos ρ))

/-- **No set of zeros cancels.** The coefficients `m(ρ)/ρ` of a nonempty finite
set of zeros never add to zero: each has positive real part. -/
theorem sum_order_div_ne_zero (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0 := by
  intro h0
  have hre : 0 < (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re := by
    rw [Complex.re_sum]
    exact Finset.sum_pos (fun ρ _ => re_order_div_pos ρ) hS
  rw [h0] at hre
  simp at hre

/-- Zeros the ladder folds together have the same symbol. -/
theorem sym_eq_of_alias {ρ ρ' : ℂ} (h : (2 : ℂ) ^ ρ = (2 : ℂ) ^ ρ') :
    Chain.Sym 2 ρ = Chain.Sym 2 ρ' := by
  rw [CellModes.sym_two, CellModes.sym_two, h]

/-- Zeros the ladder folds together have the same mode at every row. -/
theorem mode_eq_of_alias {ρ ρ' : ℂ} (h : (2 : ℂ) ^ ρ = (2 : ℂ) ^ ρ') (r : ℤ) :
    Chain.mode 2 ρ (r : ℂ) = Chain.mode 2 ρ' (r : ℂ) := by
  rw [CellModes.mode_two_int, CellModes.mode_two_int, h]

/-- **A folded class is one mode.** Zeros sharing `2^ρ = z` contribute to the
cell `(r, d)` their coefficients added, times the symbol at `z` to the depth,
times `z^r`. -/
theorem alias_weight (S : Finset Kadiri.NontrivialZeros) {z : ℂ}
    (hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z) (d : ℕ) (r : ℤ) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
        * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ)
      = (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ))
        * (1 - z⁻¹) ^ d * z ^ r := by
  rw [Finset.sum_mul, Finset.sum_mul]
  refine Finset.sum_congr rfl fun ρ hρ => ?_
  rw [CellModes.sym_two, CellModes.mode_two_int, hz ρ hρ]

/-- **Folding loses no zero.** The mode a folded class contributes has weight
not zero, at every depth and every row. -/
theorem alias_weight_ne_zero (S : Finset Kadiri.NontrivialZeros) (hS : S.Nonempty) {z : ℂ}
    (hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z) (d : ℕ) (r : ℤ) :
    ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)
        * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 := by
  rw [alias_weight S hz d r]
  obtain ⟨ρ₀, hρ₀⟩ := hS
  have hzn : ‖z‖ = (2 : ℝ) ^ (ρ₀ : ℂ).re := by
    rw [← hz ρ₀ hρ₀]
    have h2 : ((2 : ℂ)) = ((2 : ℝ) : ℂ) := by norm_num
    rw [h2, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num)]
  have hz1 : 1 < ‖z‖ := by
    rw [hzn]
    exact Real.one_lt_rpow (by norm_num) (zero_re_pos ρ₀)
  have hz0 : z ≠ 0 := fun h0 => by
    rw [h0, norm_zero] at hz1
    linarith
  have hsym : (1 : ℂ) - z⁻¹ ≠ 0 := by
    intro h
    have hz' : z⁻¹ = 1 := (sub_eq_zero.mp h).symm
    have : z = 1 := by
      rw [← inv_inv z, hz', inv_one]
    rw [this, norm_one] at hz1
    linarith
  exact mul_ne_zero (mul_ne_zero (sum_order_div_ne_zero S ⟨ρ₀, hρ₀⟩) (pow_ne_zero d hsym))
    (zpow_ne_zero r hz0)

/-- info: 'AliasClass.sum_order_div_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_order_div_ne_zero

/-- info: 'AliasClass.alias_weight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms alias_weight

/-- info: 'AliasClass.alias_weight_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms alias_weight_ne_zero

end

end AliasClass
