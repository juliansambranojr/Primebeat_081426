/-
DeepZeroBand — the deep zero, inverted, and the band between the two.

Joins three things already in this tree:

  `Zeros.zero_20_6`            the prime cell at (20,6) is zero, computed
  `PairIdentity.pair_identity` the prime cell and the composite cell of a cell
                               add to the cell's total, a power of two
  `Transform`                  the map `z = b^(−s)`, its inversion
                               `s ↦ 1 − s`, the outer circle `|z| = 1`, the
                               inner circle `|z| = b^(−1)` and the middle one

THE JOIN. Divide a cell by its total: its SHARE. The prime share and the
composite share of a cell add to one (`share_add`), so passing from the prime
table to the composite table is `x ↦ 1 − x` on shares (`share_mirror`). That
is the map `Transform` calls the inversion, read on a real number.

At the deep zero the prime share is `0` and the composite share is `1`
(`deep_zero_share`, `deep_zero_inverse_share`). Under `z = b^(−x)` the share
`0` is the outer circle and the share `1` is the inner circle
(`deep_zero_on_outer_circle`, `deep_zero_inverse_on_inner_circle`): the deep
zero and its inverse are the two edges of the band. The outer circle is where
`Transform.sym_zero_on_outer_circle` puts the zeros of the table's own symbol.

At every cell the two images multiply to `b^(−1)` (`share_pair_product`), and
an image is on the middle circle exactly at share one half
(`share_on_middle_circle_iff`, `share_eq_iff_half`).

THE BAND. A count and its complement that are both nonnegative have shares in
`[0, 1]` (`share_in_band`), and a share in `[0, 1]` lands in the closed band
between the two circles (`band_in_annulus`). At depth zero both counts are
counts, so the shares are in the band. A differenced cell can leave it: the
cell (15,6) is `−112` (`deep_cell_15_6`, `share_15_6_neg`).

WHAT THIS DOES NOT SAY. The share of a cell is a real number made from the
table. Nothing here identifies it with the real part of a zero of ζ. The
reflection `x ↦ 1 − x` and its fixed point one half are common to both; that
is the whole of the join.

STATUS: proved outright. The measured input is `Zeros.pi2`, 21 integers.
-/
import Mathlib
import Zeros
import PairIdentity
import Transform

open Complex Construction

namespace DeepZeroBand

/-- The composites in the rung `(2^(r−1), 2^r]`: the integers it holds, less the
primes it holds. -/
def compRow : ℤ → ℤ := fun r => 2 ^ (r - 1).toNat - Zeros.dyadicRow r

/-- A cell over its total `2^e`, `e = r − 1 − d`. -/
noncomputable def share (P : ℤ → ℤ) (r : ℤ) (d e : ℕ) : ℝ :=
  (tableFrom P r d : ℝ) / 2 ^ e

/-- **The inverse of the deep zero.** The composite cell at (20,6) is the whole
total, `2^13`, computed. -/
theorem composite_cell_20_6 : tableFrom compRow 20 6 = 8192 := by decide

/-- **The two shares add to one**, at every cell of any pair of rows that
partition the rungs. -/
theorem share_add (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ) (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    share P r d e + share C r d e = 1 := by
  have h := PairIdentity.pair_identity 2 P C r d e hr hpair
  have h' : tableFrom P r d + tableFrom C r d = 2 ^ e := by simpa using h
  have hc : (tableFrom P r d : ℝ) + (tableFrom C r d : ℝ) = 2 ^ e := by exact_mod_cast h'
  unfold share
  rw [← add_div, hc]
  exact div_self (by positivity)

/-- **Passing to the composite table is `x ↦ 1 − x` on shares.** -/
theorem share_mirror (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ) (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    share C r d e = 1 - share P r d e := by
  linarith [share_add P C r d e hr hpair]

/-- The two shares are equal exactly at one half. -/
theorem share_eq_iff_half (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ) (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    share P r d e = share C r d e ↔ share P r d e = 1 / 2 := by
  have h := share_add P C r d e hr hpair
  constructor <;> intro h' <;> linarith

/-- At the deep zero the prime share is zero. -/
theorem deep_zero_share : share Zeros.dyadicRow 20 6 13 = 0 := by
  unfold share
  rw [Zeros.zero_20_6]
  simp

/-- At the deep zero the composite share is one. -/
theorem deep_zero_inverse_share : share compRow 20 6 13 = 1 := by
  unfold share
  rw [composite_cell_20_6]
  norm_num

/-- **The deep zero is on the outer circle**, where the zeros of the table's
own symbol are. -/
theorem deep_zero_on_outer_circle (b : ℝ) :
    ‖(b : ℂ) ^ (-((share Zeros.dyadicRow 20 6 13 : ℝ) : ℂ))‖ = 1 := by
  rw [deep_zero_share]
  simp

/-- **Its inverse is on the inner circle.** -/
theorem deep_zero_inverse_on_inner_circle {b : ℝ} (hb : 0 < b) :
    ‖(b : ℂ) ^ (-((share compRow 20 6 13 : ℝ) : ℂ))‖ = b ^ (-(1 : ℝ)) := by
  rw [deep_zero_inverse_share, Transform.norm_zmap hb]
  simp

/-- **At every cell the two images multiply to `b^(−1)`.** -/
theorem share_pair_product {b : ℝ} (hb : 0 < b) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (2 - 1) * 2 ^ (e + (d - k))) :
    ‖(b : ℂ) ^ (-((share P r d e : ℝ) : ℂ))‖ * ‖(b : ℂ) ^ (-((share C r d e : ℝ) : ℂ))‖
      = b ^ (-(1 : ℝ)) := by
  rw [share_mirror P C r d e hr hpair, Complex.ofReal_sub, Complex.ofReal_one]
  exact Transform.zmap_pair_product hb _

/-- **The middle circle is share one half.** -/
theorem share_on_middle_circle_iff {b : ℝ} (hb : 1 < b) (x : ℝ) :
    ‖(b : ℂ) ^ (-(x : ℂ))‖ = b ^ (-(1 : ℝ) / 2) ↔ x = 1 / 2 := by
  rw [← Transform.on_critical_line_iff_norm hb]
  simp

/-- **The band of shares.** A count and its complement, both nonnegative, have
share between zero and one. -/
theorem share_in_band {P C : ℤ} {e : ℕ} (hP : 0 ≤ P) (hC : 0 ≤ C) (h : P + C = 2 ^ e) :
    0 ≤ (P : ℝ) / 2 ^ e ∧ (P : ℝ) / 2 ^ e ≤ 1 := by
  have hpos : (0 : ℝ) < 2 ^ e := by positivity
  have hPr : (0 : ℝ) ≤ P := by exact_mod_cast hP
  have hle : (P : ℝ) ≤ 2 ^ e := by exact_mod_cast (by linarith : P ≤ 2 ^ e)
  exact ⟨div_nonneg hPr hpos.le, (div_le_one hpos).mpr hle⟩

/-- **The band between the circles.** A share between zero and one lands
between the inner circle and the outer circle. -/
theorem band_in_annulus {b : ℝ} (hb : 1 < b) {x : ℝ} (h0 : 0 ≤ x) (h1 : x ≤ 1) :
    b ^ (-(1 : ℝ)) ≤ ‖(b : ℂ) ^ (-(x : ℂ))‖ ∧ ‖(b : ℂ) ^ (-(x : ℂ))‖ ≤ 1 := by
  have hb0 : (0 : ℝ) < b := by linarith
  rw [Transform.norm_zmap hb0]
  simp only [Complex.ofReal_re]
  constructor
  · exact Real.rpow_le_rpow_of_exponent_le hb.le (by linarith)
  · exact Real.rpow_le_one_of_one_le_of_nonpos hb.le (by linarith)

/-- A differenced cell can be negative: (15,6) is `−112`, computed. -/
theorem deep_cell_15_6 : tableFrom Zeros.dyadicRow 15 6 = -112 := by decide

/-- So its share is below the band. -/
theorem share_15_6_neg : share Zeros.dyadicRow 15 6 8 < 0 := by
  unfold share
  rw [deep_cell_15_6]
  norm_num

/-- info: 'DeepZeroBand.composite_cell_20_6' depends on axioms: [propext] -/
#guard_msgs in
#print axioms DeepZeroBand.composite_cell_20_6

/-- info: 'DeepZeroBand.share_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_add

/-- info: 'DeepZeroBand.share_mirror' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_mirror

/-- info: 'DeepZeroBand.share_eq_iff_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_eq_iff_half

/-- info: 'DeepZeroBand.deep_zero_share' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.deep_zero_share

/-- info: 'DeepZeroBand.deep_zero_inverse_share' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.deep_zero_inverse_share

/-- info: 'DeepZeroBand.deep_zero_on_outer_circle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.deep_zero_on_outer_circle

/-- info: 'DeepZeroBand.deep_zero_inverse_on_inner_circle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.deep_zero_inverse_on_inner_circle

/-- info: 'DeepZeroBand.share_pair_product' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_pair_product

/-- info: 'DeepZeroBand.share_on_middle_circle_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_on_middle_circle_iff

/-- info: 'DeepZeroBand.share_in_band' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_in_band

/-- info: 'DeepZeroBand.band_in_annulus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.band_in_annulus

/-- info: 'DeepZeroBand.deep_cell_15_6' does not depend on any axioms -/
#guard_msgs in
#print axioms DeepZeroBand.deep_cell_15_6

/-- info: 'DeepZeroBand.share_15_6_neg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms DeepZeroBand.share_15_6_neg


end DeepZeroBand
