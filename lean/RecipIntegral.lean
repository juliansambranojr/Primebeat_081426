/-
RecipIntegral — the term bound of `RecipBound` carried under the integral.

`H w m = ∫₀¹ w(u)/(m − u) du` for a continuous weight `w ≥ 0`. The smooth row is
`2^m · H w m` with `w(u) = 2^(−u)`. Its differences are the weighted averages of those
of `1/(m − u)` (`iter_H`), so each term of the exact floor obeys
`C(d,i)·|Δ^i H(m)| ≤ q^i · H(m)` with `q = d/(m − 1 − d)` (`H_term_le`).
-/
import Mathlib
import RecipBound

namespace ExactFloor
open Finset Nonvanishing Set

noncomputable section

/-- The weighted average of `1/(m − u)` over `u ∈ [0,1]`. -/
def H (w : ℝ → ℝ) (m : ℤ) : ℝ := ∫ u in (0 : ℝ)..1, w u * (1 / ((m : ℝ) - u))

/-- `1/(m − u)` as a sequence in `m`, for a fixed offset `u`. -/
def phi (u : ℝ) : ℤ → ℝ := fun x => 1 / ((x : ℝ) - u)

theorem cont_recip {k : ℝ} (hk : 1 < k) :
    ContinuousOn (fun u : ℝ => 1 / (k - u)) (uIcc 0 1) := by
  refine continuousOn_const.div (continuousOn_const.sub continuousOn_id) fun u hu => ?_
  rw [Set.uIcc_of_le zero_le_one] at hu
  have := hu.2; intro h0; linarith

theorem cont_iter_phi (i : ℕ) (m : ℤ) (hm : (i : ℝ) + 1 < m) :
    ContinuousOn (fun u => (bdiffZ^[i]) (phi u) m) (uIcc 0 1) := by
  simp only [iter_bdiffZ_eq_stencilR, stencilR]
  refine continuousOn_finset_sum _ fun k hk => continuousOn_const.mul ?_
  have hk' : (k : ℝ) ≤ i := by exact_mod_cast Nat.lt_succ_iff.mp (mem_range.mp hk)
  simp only [phi]
  exact cont_recip (by push_cast; linarith)

/-- **The differences pass under the integral.** -/
theorem iter_H {w : ℝ → ℝ} (hw : ContinuousOn w (uIcc 0 1)) (i : ℕ) (m : ℤ)
    (hm : (i : ℝ) + 1 < m) :
    (bdiffZ^[i]) (H w) m = ∫ u in (0 : ℝ)..1, w u * (bdiffZ^[i]) (phi u) m := by
  have hint : ∀ k ∈ range (i + 1), IntervalIntegrable
      (fun u => (-1 : ℝ) ^ k * (i.choose k) * (w u * (1 / (((m - k : ℤ) : ℝ) - u))))
      MeasureTheory.volume 0 1 := by
    intro k hk
    have hk' : (k : ℝ) ≤ i := by exact_mod_cast Nat.lt_succ_iff.mp (mem_range.mp hk)
    exact (continuousOn_const.mul (hw.mul (cont_recip (by push_cast; linarith)))).intervalIntegrable
  calc (bdiffZ^[i]) (H w) m
      = ∑ k ∈ range (i + 1), (-1 : ℝ) ^ k * (i.choose k) * H w (m - k) := by
        rw [iter_bdiffZ_eq_stencilR]; rfl
    _ = ∑ k ∈ range (i + 1), ∫ u in (0 : ℝ)..1,
          (-1 : ℝ) ^ k * (i.choose k) * (w u * (1 / (((m - k : ℤ) : ℝ) - u))) := by
        refine sum_congr rfl fun k _ => ?_
        rw [intervalIntegral.integral_const_mul]; rfl
    _ = ∫ u in (0 : ℝ)..1, ∑ k ∈ range (i + 1),
          (-1 : ℝ) ^ k * (i.choose k) * (w u * (1 / (((m - k : ℤ) : ℝ) - u))) :=
        (intervalIntegral.integral_finset_sum hint).symm
    _ = _ := by
        refine intervalIntegral.integral_congr fun u _ => ?_
        simp only [iter_bdiffZ_eq_stencilR, stencilR, phi, mul_sum]
        refine sum_congr rfl fun k _ => by ring

/-- **Each term of the exact floor against `H`.** -/
theorem H_term_le {w : ℝ → ℝ} (hw : ContinuousOn w (uIcc 0 1))
    (hw0 : ∀ u ∈ Icc (0 : ℝ) 1, 0 ≤ w u) {d i : ℕ} (hi : i ≤ d) (m : ℤ)
    (hm : (d : ℝ) + 1 < m) :
    (d.choose i : ℝ) * |(bdiffZ^[i]) (H w) m|
      ≤ ((d : ℝ) / ((m : ℝ) - 1 - d)) ^ i * H w m := by
  have hid : (i : ℝ) ≤ d := by exact_mod_cast hi
  have hmi : (i : ℝ) + 1 < m := by linarith
  rw [iter_H hw i m hmi, H, ← intervalIntegral.integral_const_mul]
  have hC : (0 : ℝ) ≤ d.choose i := by positivity
  have hcont := hw.mul (cont_iter_phi i m hmi)
  calc (d.choose i : ℝ) * |∫ u in (0 : ℝ)..1, w u * (bdiffZ^[i]) (phi u) m|
      ≤ (d.choose i : ℝ) * ∫ u in (0 : ℝ)..1, |w u * (bdiffZ^[i]) (phi u) m| := by
        gcongr
        exact intervalIntegral.abs_integral_le_integral_abs zero_le_one
    _ = ∫ u in (0 : ℝ)..1, (d.choose i : ℝ) * |w u * (bdiffZ^[i]) (phi u) m| := by
        rw [intervalIntegral.integral_const_mul]
    _ ≤ ∫ u in (0 : ℝ)..1, ((d : ℝ) / ((m : ℝ) - 1 - d)) ^ i * (w u * (1 / ((m : ℝ) - u))) := by
        refine intervalIntegral.integral_mono_on zero_le_one
          ((continuousOn_const.mul hcont.abs).intervalIntegrable)
          ((continuousOn_const.mul (hw.mul (cont_recip (by linarith)))).intervalIntegrable)
          fun u hu => ?_
        have hwu := hw0 u hu
        have hb := recip_term_le u hu.2 hi m hm
        simp only at hb ⊢
        rw [abs_mul, abs_of_nonneg hwu]
        calc (d.choose i : ℝ) * (w u * |(bdiffZ^[i]) (fun x : ℤ => 1 / ((x : ℝ) - u)) m|)
            = w u * ((d.choose i : ℝ) * |(bdiffZ^[i]) (fun x : ℤ => 1 / ((x : ℝ) - u)) m|) := by ring
          _ ≤ w u * (((d : ℝ) / ((m : ℝ) - 1 - d)) ^ i * (1 / ((m : ℝ) - u))) :=
              mul_le_mul_of_nonneg_left hb hwu
          _ = _ := by ring

end

end ExactFloor

/-- info: 'ExactFloor.H_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.H_term_le

namespace ExactFloor
open Finset Nonvanishing Set

theorem geom_tail_le {q : ℝ} (hq0 : 0 ≤ q) (hq1 : q < 1) (d : ℕ) :
    ∑ i ∈ range d, q ^ (i + 1) ≤ q / (1 - q) := by
  have hg := geom_sum_mul q d
  have hpow : 0 ≤ q ^ d := pow_nonneg hq0 d
  have h1q : 0 < 1 - q := by linarith
  have hs : (∑ i ∈ range d, q ^ i) * (1 - q) ≤ 1 := by nlinarith
  have hs' : ∑ i ∈ range d, q ^ i ≤ 1 / (1 - q) := by rw [le_div_iff₀ h1q]; linarith
  calc ∑ i ∈ range d, q ^ (i + 1) = q * ∑ i ∈ range d, q ^ i := by
        rw [mul_sum]; exact sum_congr rfl fun i _ => by ring
    _ ≤ q * (1 / (1 - q)) := mul_le_mul_of_nonneg_left hs' hq0
    _ = q / (1 - q) := by ring

theorem H_nonneg {w : ℝ → ℝ} (hw0 : ∀ u ∈ Icc (0 : ℝ) 1, 0 ≤ w u) {m : ℤ} (hm : (1 : ℝ) < m) :
    0 ≤ H w m := by
  unfold H
  refine intervalIntegral.integral_nonneg zero_le_one fun u hu => ?_
  have : 0 < (m : ℝ) - u := by linarith [hu.2]
  exact mul_nonneg (hw0 u hu) (by positivity)

/-- **The floor on the stencil of `2^m · H(m)`.** With `q = d/(r − 1 − d) < 1`, the stencil
sits within `2^(r−d)·H(r)·q/(1−q)` of its main term `2^(r−d)·H(r)`. -/
theorem stencil_H_floor {w : ℝ → ℝ} (hw : ContinuousOn w (uIcc 0 1))
    (hw0 : ∀ u ∈ Icc (0 : ℝ) 1, 0 ≤ w u) (d : ℕ) (r : ℤ) (hr : (d : ℝ) + 1 < r)
    (hq1 : (d : ℝ) / ((r : ℝ) - 1 - d) < 1) :
    |stencilR d (fun m => (2 : ℝ) ^ m * H w m) r - (2 : ℝ) ^ (r - d) * H w r|
      ≤ (2 : ℝ) ^ (r - d) * (H w r * ((d : ℝ) / ((r : ℝ) - 1 - d) / (1 - (d : ℝ) / ((r : ℝ) - 1 - d)))) := by
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hqdef
  have hq0 : 0 ≤ q := div_nonneg (Nat.cast_nonneg d) (by linarith)
  have hH := H_nonneg hw0 (m := r) (by linarith [(Nat.cast_nonneg d : (0:ℝ) ≤ d)])
  refine (stencil_exp_mul_floor (H w) d r).trans ?_
  have hp : (0 : ℝ) < (2 : ℝ) ^ (r - d) := zpow_pos (by norm_num) _
  gcongr
  calc ∑ i ∈ range d, (d.choose (i + 1) : ℝ) * |(bdiffZ^[i + 1]) (H w) r|
      ≤ ∑ i ∈ range d, q ^ (i + 1) * H w r :=
        sum_le_sum fun i hi => H_term_le hw hw0 (by have := mem_range.mp hi; omega) r hr
    _ = H w r * ∑ i ∈ range d, q ^ (i + 1) := by rw [mul_sum]; exact sum_congr rfl fun _ _ => by ring
    _ ≤ H w r * (q / (1 - q)) := mul_le_mul_of_nonneg_left (geom_tail_le hq0 hq1 d) hH

/-- **The stencil is positive in the band.** With `q < 1/2`, i.e. `3d + 1 < r`, and `H(r) > 0`. -/
theorem stencil_H_pos {w : ℝ → ℝ} (hw : ContinuousOn w (uIcc 0 1))
    (hw0 : ∀ u ∈ Icc (0 : ℝ) 1, 0 ≤ w u) (d : ℕ) (r : ℤ) (hband : 3 * (d : ℝ) + 1 < r)
    (hHpos : 0 < H w r) :
    0 < stencilR d (fun m => (2 : ℝ) ^ m * H w m) r := by
  have hd0 : (0 : ℝ) ≤ d := Nat.cast_nonneg d
  have hr : (d : ℝ) + 1 < r := by linarith
  have hden : 0 < (r : ℝ) - 1 - d := by linarith
  set q := (d : ℝ) / ((r : ℝ) - 1 - d) with hqdef
  have hqh : q < 1 / 2 := by rw [hqdef, div_lt_iff₀ hden]; linarith
  have hq0 : 0 ≤ q := div_nonneg hd0 hden.le
  have hF := stencil_H_floor hw hw0 d r hr (by linarith)
  rw [← hqdef] at hF
  have hp : (0 : ℝ) < (2 : ℝ) ^ (r - d) := zpow_pos (by norm_num) _
  have h1q : 0 < 1 - q := by linarith
  have hfrac : q / (1 - q) < 1 := by rw [div_lt_one h1q]; linarith
  have hlt : H w r * (q / (1 - q)) < H w r := by nlinarith
  have := (abs_le.mp hF).1
  nlinarith

end ExactFloor

/-- info: 'ExactFloor.stencil_H_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.stencil_H_floor

/-- info: 'ExactFloor.stencil_H_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.stencil_H_pos
