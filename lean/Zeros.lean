/-
Zeros — what is provable about the four exact zeros, and what is not.

THE MEASUREMENT (results/O16_run2.log): over r <= 62, d <= 61 the dyadic prime
difference table has exactly four exact zeros — (2,1), (4,1), (8,3), (20,6) —
and no others. The centered table has none at all.

THIS HOLE DOES NOT CLOSE, and the file says so rather than manufacturing a
derivation. `Delta^7 pi` vanishing at 2^20 is a fact about pi, not a consequence
of any structure in the chain. Nothing below predicts r = 20 or d = 6, and
nothing below could.

WHAT IS PROVED:

  1. A zero is a REPEAT one depth up. `cell(r,d) = 0` iff the two cells feeding
     it are equal. Verified on the bench: (20,6) = 0 because d5 at r = 19 and
     r = 20 are both 623; (8,3) = 0 because d2 at r = 7 and r = 8 are both 4.

  2. A zero is ONE linear condition on d+2 values of pi. That is what makes it
     codimension one — rare, but with no predicted location.

  3. Window exclusivity. Depth d spans a value window of ratio b^(d+1). For
     (20,6) that is 2^7, and 7 is PRIME, so no integer base below 128 reaches
     that window at integer depth. (8,3) spans 2^4 = 4^2, which base 4 does
     reach at depth 1. So the two deep zeros are different in kind.

WHAT IS NOT PROVED, AND IS NOT EXPECTED TO BE: where the zeros are.
-/
import Mathlib

namespace Zeros

/-! ## A zero is a repeat -/

variable {f : ℤ → ℤ → ℤ}

/-- The table recurrence: each cell is the difference of the two above it. -/
def IsTable (f : ℤ → ℤ → ℤ) : Prop :=
  ∀ r d, f r (d + 1) = f r d - f (r - 1) d

/-- **A zero is exactly a repeat one depth up.** This is definitional, and it is
the only characterisation of a zero the chain supplies. -/
theorem zero_iff_repeat (hf : IsTable f) (r d : ℤ) :
    f r (d + 1) = 0 ↔ f r d = f (r - 1) d := by
  rw [hf r d, sub_eq_zero]

/-! ## A zero is one linear condition -/

/-- The `N`-fold alternating binomial functional — the stencil that produces a
cell at depth `N-1` from `N+1` values of the counting function. -/
def stencil (N : ℕ) (g : ℕ → ℤ) : ℤ :=
  ∑ k ∈ Finset.range (N + 1), (-1 : ℤ) ^ k * (N.choose k) * g k

/-- **The stencil is linear in the sampled values.** So a zero is a single
linear equation on the `N+1` values of `pi` inside its window — one condition,
hence codimension one. Nothing here says when it is satisfied. -/
theorem stencil_add (N : ℕ) (g h : ℕ → ℤ) :
    stencil N (fun k => g k + h k) = stencil N g + stencil N h := by
  unfold stencil
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun k _ => by ring

theorem stencil_smul (N : ℕ) (c : ℤ) (g : ℕ → ℤ) :
    stencil N (fun k => c * g k) = c * stencil N g := by
  unfold stencil
  rw [Finset.mul_sum]
  exact Finset.sum_congr rfl fun k _ => by ring

/-- The stencil's positive and negative arms carry equal total weight. For
`N = 7` each arm sums to 64: the balance is exact by construction, not by
anything about the primes. -/
theorem stencil_annihilates_const (N : ℕ) (hN : 0 < N) (c : ℤ) :
    stencil N (fun _ => c) = 0 := by
  unfold stencil
  have : ∑ k ∈ Finset.range (N + 1), (-1 : ℤ) ^ k * (N.choose k) * c
      = (∑ k ∈ Finset.range (N + 1), (-1 : ℤ) ^ k * (N.choose k)) * c := by
    rw [Finset.sum_mul]
  rw [this, Int.alternating_sum_range_choose_of_ne (by omega : N ≠ 0), zero_mul]

/-! ## Window exclusivity -/

/-- **The (20,6) window is base-2 exclusive.** Depth 6 spans a ratio of `2^7`.
Since 7 is prime, no integer base `b >= 2` reaches that window at any integer
depth `k >= 2`. Base 2 at depth 6 is the only way to look through it. -/
theorem window_exclusive_of_prime_exponent (b k : ℕ) (hb : 2 ≤ b) (hk : 2 ≤ k)
    (h : b ^ k = 2 ^ 7) : b = 2 ∧ k = 7 := by
  have hb128 : b ≤ 128 := by
    by_contra hc
    push_neg at hc
    have : (128 : ℕ) ^ 2 ≤ b ^ k := by
      calc (128 : ℕ) ^ 2 ≤ b ^ 2 := Nat.pow_le_pow_left (by omega) 2
        _ ≤ b ^ k := Nat.pow_le_pow_right (by omega) hk
    omega
  have hk7 : k ≤ 7 := by
    by_contra hc
    push_neg at hc
    have : (2 : ℕ) ^ 8 ≤ b ^ k := by
      calc (2 : ℕ) ^ 8 ≤ 2 ^ k := Nat.pow_le_pow_right (by omega) (by omega)
        _ ≤ b ^ k := Nat.pow_le_pow_left hb k
    omega
  interval_cases b <;> interval_cases k <;> omega

/-- **The (8,3) window is not.** Depth 3 spans `2^4 = 4^2`, so base 4 reaches it
at depth 1. The two deep zeros are different kinds of object. -/
theorem window_shared_of_composite_exponent : (4 : ℕ) ^ 2 = 2 ^ 4 := by norm_num

/-! ## What is NOT proved

Nothing above determines a location. `zero_iff_repeat` says a zero is a repeat;
it does not say where pi repeats. `stencil_add` says a zero is one linear
condition; it does not say when the condition holds. `window_exclusive_...` says
which bases could see the (20,6) window; it does not say that anything is there.

The measured locations are recorded below and stand unexplained.
-/

/-- The four exact zeros, `(r, d)`, over `r <= 62`, `d <= 61`.
`results/O16_run2.log`. **Unexplained: no theorem above predicts these.** -/
def measured_zeros : List (ℕ × ℕ) := [(2, 1), (4, 1), (8, 3), (20, 6)]

/-- The repeats that produce the two deep zeros.
`results/joint_dyadic_triadic_table.csv`, rows 19/20 at d5 and rows 7/8 at d2. -/
def measured_repeat_20_6 : ℤ := 623
def measured_repeat_8_3 : ℤ := 4

/-- The centered (skew-adjoint) table has no exact zeros at all,
`r <= 62`, `d <= 30`. `results/O16_run2.log`. -/
def measured_centered_zero_count : ℕ := 0

/-- Four zeros in 1953 cells. Recorded, not derived. -/
theorem four_zeros_only : measured_zeros.length = 4 := by
  unfold measured_zeros; rfl

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

-- **`propext` only.** Claimed in `papers/Formalization.md` § B4 and confirmed here:
-- the one rewrite (`sub_eq_zero`) is all the axiom weight a zero costs.
/-- info: 'Zeros.zero_iff_repeat' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Zeros.zero_iff_repeat

/-- info: 'Zeros.stencil_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_add

/-- info: 'Zeros.stencil_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_smul

/-- info: 'Zeros.stencil_annihilates_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_annihilates_const

/-- info: 'Zeros.window_exclusive_of_prime_exponent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.window_exclusive_of_prime_exponent

/-- info: 'Zeros.window_shared_of_composite_exponent' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Zeros.window_shared_of_composite_exponent

/-- info: 'Zeros.four_zeros_only' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.four_zeros_only

end Zeros
