/-
ExactBand — the four zeros across the band `3d + 1 < r`, on the exact gate.

`H_w2_ge`: `H(r) ≥ 1/(2r)`, since `2^(−u) ≥ 1/2` and `1/(r − u) ≥ 1/r` on `[0,1]`.
`gap_of_price`: the gate's gap holds once `ρ < (1 − q/(1−q)) / (r·3^(d+1))`.
`only_four_zeros_exact`: under the named π list and a named relative-error bound at that
price past row 92, every zero of the true table in rows to 92 or in the band `3d + 1 < r`
is one of the four. The corner `r ≤ 3d + 1` past row 92 is not covered here.
-/
import Mathlib
import ExactGate
import ToInfinity

namespace ExactBand
open Finset Nonvanishing RelativeGate ExactFloor SmoothRow ExactGate

noncomputable section

/-- The new price at depth `d`, row `r`. -/
def priceX (r : ℤ) (d : ℕ) : ℝ :=
  let q := (d : ℝ) / ((r : ℝ) - 1 - d)
  (1 - q / (1 - q)) / ((r : ℝ) * 3 ^ (d + 1))

theorem H_w2_ge {r : ℤ} (hr : (1 : ℝ) < r) : 1 / (2 * (r : ℝ)) ≤ H w2 r := by
  have hr0 : (0 : ℝ) < r := by linarith
  have hconst : ∫ _u in (0 : ℝ)..1, 1 / (2 * (r : ℝ)) = 1 / (2 * (r : ℝ)) := by simp
  rw [← hconst, H]
  refine intervalIntegral.integral_mono_on zero_le_one (by simp)
    ((w2_cont.mul (cont_recip hr)).intervalIntegrable) fun u hu => ?_
  have hw : (1 / 2 : ℝ) ≤ w2 u := by
    unfold w2
    have hl : Real.log 2 * u ≤ Real.log 2 := by
      have := Real.log_pos (by norm_num : (1 : ℝ) < 2); nlinarith [hu.2]
    have : Real.exp (-Real.log 2) ≤ Real.exp (-(Real.log 2 * u)) := Real.exp_le_exp.mpr (by linarith)
    rw [Real.exp_neg, Real.exp_log (by norm_num)] at this
    linarith
  have hru : 0 < (r : ℝ) - u := by linarith [hu.2]
  have hrec : 1 / (r : ℝ) ≤ 1 / ((r : ℝ) - u) := one_div_le_one_div_of_le hru (by linarith [hu.1])
  calc 1 / (2 * (r : ℝ)) = (1 / 2) * (1 / (r : ℝ)) := by field_simp
    _ ≤ w2 u * (1 / ((r : ℝ) - u)) :=
        mul_le_mul hw hrec (by positivity) (by linarith)

/-- **The price.** -/
theorem gap_of_price {r : ℤ} {d : ℕ} {ρ : ℝ} (hband : 3 * (d : ℝ) + 1 < r)
    (hρ : ρ < priceX r d) : EhighRel r (d + 1) ρ < floorX r d := by
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr1 : (1 : ℝ) < r := by linarith
  have hr0 : (0 : ℝ) < r := by linarith
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hqdef
  have hqh : q < 1 / 2 := by rw [hqdef, div_lt_iff₀ hden]; linarith
  have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
  set c := 1 - q / (1 - q) with hc
  have hcpos : 0 < c := by
    have h1q : 0 < 1 - q := by linarith
    have : q / (1 - q) < 1 := by rw [div_lt_one h1q]; linarith
    linarith
  have hH := H_w2_ge hr1
  unfold floorX EhighRel
  simp only
  rw [← hqdef, ← hc]
  unfold priceX at hρ; simp only at hρ; rw [← hqdef, ← hc] at hρ
  have h3 : (0 : ℝ) < 3 ^ (d + 1) := by positivity
  have hρ' : ρ * ((r : ℝ) * 3 ^ (d + 1)) < c := by rwa [lt_div_iff₀ (by positivity)] at hρ
  -- 2^(r−d) = 2^r / 2^d
  have hz : (2 : ℝ) ^ (r - (d : ℤ)) = (2 : ℝ) ^ (r : ℝ) / 2 ^ d := by
    rw [zpow_sub₀ (by norm_num), zpow_natCast, ← Real.rpow_intCast]
  rw [hz]
  have hP : (0 : ℝ) < (2 : ℝ) ^ (r : ℝ) := Real.rpow_pos_of_pos (by norm_num) _
  have h2d : (0 : ℝ) < 2 ^ d := by positivity
  have hkey : (3 / 2 : ℝ) ^ (d + 1) = 3 ^ (d + 1) / (2 * 2 ^ d) := by
    rw [div_pow, pow_succ 2 d]; ring
  rw [hkey]
  have lhs : ρ * (2 : ℝ) ^ (r : ℝ) * (3 ^ (d + 1) / (2 * 2 ^ d))
      = (2 : ℝ) ^ (r : ℝ) / 2 ^ d * (ρ * ((r : ℝ) * 3 ^ (d + 1)) / (2 * r)) := by
    field_simp
  rw [lhs, mul_assoc]
  apply mul_lt_mul_of_pos_left _ (by positivity)
  calc ρ * ((r : ℝ) * 3 ^ (d + 1)) / (2 * r) < c / (2 * r) := by
        apply div_lt_div_of_pos_right hρ' (by positivity)
    _ = 1 / (2 * (r : ℝ)) * c := by ring
    _ ≤ H w2 r * c := mul_le_mul_of_nonneg_right hH hcpos.le

/-- **Every zero in rows to 92 or in the band `3d + 1 < r` is one of the four.** -/
theorem only_four_zeros_exact (hpi : DepthSix.StmtPiData)
    (hbound : ∀ r : Int, 92 < r → ∀ d : Nat, 1 ≤ d → 3 * (d : ℝ) + 1 < r →
      ∃ ρ : ℝ, StmtRelErrWindow ToInfinity.piRow (fun k : Int => Interpolant.liRow k) r (d + 1) ρ ∧
        ρ < priceX r d)
    {r : Int} {d : Nat} (hd : 1 ≤ d) (hlo : (d : Int) < r) (hin : r ≤ 92 ∨ 3 * (d : ℝ) + 1 < r)
    (hz : Construction.tableFrom ToInfinity.trueRow r d = 0) :
    (r, d) = (2, 1) ∨ (r, d) = (4, 1) ∨ (r, d) = (8, 3) ∨ (r, d) = (20, 6) := by
  by_cases h92 : r ≤ 92
  · exact ToInfinity.census_zero hd hlo h92 (by rw [ToInfinity.cell_eq_true hpi r d hlo h92]; exact hz)
  · exfalso
    have hband : 3 * (d : ℝ) + 1 < r := hin.resolve_left h92
    obtain ⟨ρ, hS, hρ⟩ := hbound r (by omega) d hd hband
    refine tableFrom_ne_zero_exact (f := ToInfinity.piRow) ?_ hS hband (gap_of_price hband hρ) hz
    intro k hk
    have := Finset.mem_range.mp hk
    have hbZ : 3 * (d : ℤ) + 1 < r := by exact_mod_cast hband
    exact ToInfinity.trueRow_eq_bdiff (by omega)

end

end ExactBand

/-- info: 'ExactBand.only_four_zeros_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactBand.only_four_zeros_exact
