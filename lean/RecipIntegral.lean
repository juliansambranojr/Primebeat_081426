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
