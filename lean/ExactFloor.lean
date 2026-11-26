/-
ExactFloor — the main-term stencil of `2^m · g(m)`, computed exactly.

Unit 0594 found that `Nonvanishing.Mlow` reaches the stencil through the d-th
derivative of `2^x/x` and loses `(1/log 2)^d`. The backward difference acts on
the exponential exactly: `Δ(2^m g) = 2^(m−1)·(g + Δg)`. Iterated,

    Δ^d (2^m · g)(r) = 2^(r−d) · Σ_{i ≤ d} C(d,i) · Δ^i g (r)

(`iter_exp_mul_eq_sum`). The `i = 0` term is the main term `2^(r−d)·g(r)`; only
the differences of `g` are left to bound (`stencil_exp_mul_floor`).
-/
import Mathlib
import Nonvanishing

namespace ExactFloor

open Finset Nonvanishing

noncomputable section

/-- `f + Δf`, i.e. `2f(x) − f(x−1)`: what the backward difference of `2^m·f` leaves
after `2^(m−1)` is pulled out. -/
def plusD (f : ℤ → ℝ) : ℤ → ℝ := fun x => f x + bdiffZ f x

/-- **The exponential passes through the difference exactly.** -/
theorem iter_exp_mul (g : ℤ → ℝ) (d : ℕ) (r : ℤ) :
    (bdiffZ^[d]) (fun m => (2 : ℝ) ^ m * g m) r = (2 : ℝ) ^ (r - d) * (plusD^[d]) g r := by
  induction d generalizing r with
  | zero => simp
  | succ n ih =>
    rw [Function.iterate_succ_apply', Function.iterate_succ_apply']
    show (bdiffZ^[n]) _ r - (bdiffZ^[n]) _ (r - 1) = _
    rw [ih r, ih (r - 1)]
    simp only [plusD, bdiffZ]
    have h1 : (2 : ℝ) ^ (r - (n : ℤ)) = 2 * 2 ^ (r - ((n + 1 : ℕ) : ℤ)) := by
      rw [show r - (n : ℤ) = 1 + (r - ((n + 1 : ℕ) : ℤ)) by push_cast; ring,
        zpow_one_add₀ (by norm_num)]
    have h2 : (2 : ℝ) ^ (r - 1 - (n : ℤ)) = 2 ^ (r - ((n + 1 : ℕ) : ℤ)) := by
      congr 1; push_cast; ring
    rw [h1, h2]; ring

/-- `bdiffZ` is linear over a finite sum with constant coefficients. -/
theorem bdiffZ_sum (s : Finset ℕ) (c : ℕ → ℝ) (F : ℕ → ℤ → ℝ) (x : ℤ) :
    bdiffZ (fun y => ∑ i ∈ s, c i * F i y) x = ∑ i ∈ s, c i * bdiffZ (F i) x := by
  simp only [bdiffZ, ← Finset.sum_sub_distrib, mul_sub]

/-- **`(1 + Δ)^d` expanded.** -/
theorem iter_plusD (g : ℤ → ℝ) (d : ℕ) :
    (plusD^[d]) g = fun r => ∑ i ∈ range (d + 1), (d.choose i : ℝ) * (bdiffZ^[i]) g r := by
  induction d with
  | zero => funext r; simp
  | succ n ih =>
    funext r
    rw [Function.iterate_succ_apply', ih]
    simp only [plusD]
    rw [bdiffZ_sum]
    have hs := Finset.sum_choose_succ_mul (R := ℝ) (fun i _ => (bdiffZ^[i]) g r) n
    simp only at hs
    rw [hs]
    congr 1
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [Function.iterate_succ_apply']

/-- **The exact stencil.** -/
theorem iter_exp_mul_eq_sum (g : ℤ → ℝ) (d : ℕ) (r : ℤ) :
    stencilR d (fun m => (2 : ℝ) ^ m * g m) r
      = (2 : ℝ) ^ (r - d) * ∑ i ∈ range (d + 1), (d.choose i : ℝ) * (bdiffZ^[i]) g r := by
  rw [← iter_bdiffZ_eq_stencilR, iter_exp_mul, iter_plusD]

/-- **The floor.** The stencil sits within `2^(r−d)·Σ_{1≤i≤d} C(d,i)|Δ^i g(r)|` of the
main term `2^(r−d)·g(r)`. -/
theorem stencil_exp_mul_floor (g : ℤ → ℝ) (d : ℕ) (r : ℤ) :
    |stencilR d (fun m => (2 : ℝ) ^ m * g m) r - (2 : ℝ) ^ (r - d) * g r|
      ≤ (2 : ℝ) ^ (r - d) *
          ∑ i ∈ range d, (d.choose (i + 1) : ℝ) * |(bdiffZ^[i + 1]) g r| := by
  rw [iter_exp_mul_eq_sum, Finset.sum_range_succ', ← mul_sub]
  simp only [Nat.choose_zero_right, Nat.cast_one, one_mul, Function.iterate_zero, id,
    add_sub_cancel_right]
  have hp : (0 : ℝ) < (2 : ℝ) ^ (r - d) := zpow_pos (by norm_num) _
  rw [abs_mul, abs_of_pos hp]
  gcongr
  refine (Finset.abs_sum_le_sum_abs _ _).trans (le_of_eq ?_)
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [abs_mul, abs_of_nonneg (by positivity)]

end

end ExactFloor

/-- info: 'ExactFloor.iter_exp_mul_eq_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.iter_exp_mul_eq_sum

/-- info: 'ExactFloor.stencil_exp_mul_floor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.stencil_exp_mul_floor

namespace ExactFloor

open Finset Nonvanishing

/-! ## The differences of `1/(m − a)`

The smooth row is `2^m·h(m)` with `h(m) = ∫₀¹ 2^(−u)/(m − u) du`; its differences
are those of `1/(m − u)` under the integral, and those are exact: a falling
product in the denominator. -/

/-- The falling product `∏_{j ≤ i} (m − a − j)`. -/
noncomputable def fall (a : ℝ) (i : ℕ) (m : ℤ) : ℝ := ∏ j ∈ range (i + 1), ((m : ℝ) - a - j)

theorem fall_succ_left (a : ℝ) (i : ℕ) (m : ℤ) :
    fall a (i + 1) m = ((m : ℝ) - a) * ∏ j ∈ range (i + 1), ((m : ℝ) - a - (j + 1)) := by
  unfold fall; rw [prod_range_succ']; push_cast; ring

theorem fall_succ_right (a : ℝ) (i : ℕ) (m : ℤ) :
    fall a (i + 1) m = fall a i m * ((m : ℝ) - a - (i + 1)) := by
  unfold fall; rw [prod_range_succ]; push_cast; ring

theorem fall_pred (a : ℝ) (i : ℕ) (m : ℤ) :
    fall a i (m - 1) = ∏ j ∈ range (i + 1), ((m : ℝ) - a - (j + 1)) := by
  unfold fall; refine prod_congr rfl fun j _ => ?_; push_cast; ring

/-- **The differences of `1/(m − a)`, exactly.** -/
theorem iter_recip (a : ℝ) (i : ℕ) (m : ℤ) (h : ∀ j ≤ i, (m : ℝ) - a - j ≠ 0) :
    (bdiffZ^[i]) (fun x : ℤ => 1 / ((x : ℝ) - a)) m = (-1) ^ i * i.factorial / fall a i m := by
  induction i generalizing m with
  | zero => simp [fall]
  | succ n ih =>
    rw [Function.iterate_succ_apply']
    show (bdiffZ^[n]) _ m - (bdiffZ^[n]) _ (m - 1) = _
    have h1 := ih m (fun j hj => h j (by omega))
    have h2 := ih (m - 1) (fun j hj => by
      have := h (j + 1) (by omega); push_cast at this ⊢; intro hc; apply this; linarith)
    rw [h1, h2, fall_pred, fall_succ_right]
    set Q := ∏ j ∈ range n, ((m : ℝ) - a - (j + 1)) with hQ
    have hPm : fall a n m = ((m : ℝ) - a) * Q := by
      cases n with
      | zero => simp [fall, hQ]
      | succ k => rw [fall_succ_left]
    have hPm1 : ∏ j ∈ range (n + 1), ((m : ℝ) - a - (j + 1)) = Q * ((m : ℝ) - a - (n + 1)) := by
      rw [prod_range_succ]
    have h0 : (m : ℝ) - a ≠ 0 := by simpa using h 0 (by omega)
    have hl : (m : ℝ) - a - (n + 1) ≠ 0 := by have := h (n + 1) le_rfl; push_cast at this; exact this
    have hQ0 : Q ≠ 0 := by
      rw [hQ, prod_ne_zero_iff]; intro j hj
      have := h (j + 1) (by have := mem_range.mp hj; omega); push_cast at this; exact this
    rw [hPm, hPm1, Nat.factorial_succ]; push_cast
    field_simp
    ring

end ExactFloor

/-- info: 'ExactFloor.iter_recip' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms ExactFloor.iter_recip
