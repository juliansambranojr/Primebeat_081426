/-
ZerosStencil — the Mathlib-dependent half of `Zeros.lean`.

Split out of `Zeros.lean` on 2026-08-26. The classification is by axiom pin,
not by subject: these are exactly the fifteen theorems whose `#print axioms`
carries `Classical.choice`, and every one of them acquires it from Mathlib —
`Finset.range` and the alternating-sum lemmas for the stencil family,
`Nat.factorization` and `Nat.dvd_prime_pow` for the four ladder results.
Notes entries 59, 66 and 187 are the record; 66 predicted this exact list two
weeks before it was measured.

THE NAMESPACE IS STILL `Zeros`. That is the point of the split rather than a
side effect of it: `papers/The-Four-Zeros.md`, `papers/The-Fold.md` and
`papers/Commensurate-Ladders.md` cite these results as `Zeros.<name>`, and
`Nonvanishing.lean` rewrites with `Zeros.tableFrom_eq_stencil` by that name.
Nothing was renamed and no statement was touched.

WHAT STAYS IN `Zeros.lean`: the sixteen theorems with no `Classical.choice` —
the repeat characterisation, the four computed zeros and their two non-zero
neighbours, and the measured-zero results.
-/
import Mathlib
import Construction
import Zeros

namespace Zeros

/-! ## A zero is one linear condition -/

/-- The `N`-fold alternating binomial functional — the stencil that produces a
cell at depth `N-1` from `N+1` values of the counting function. -/
def stencil (N : ℕ) (g : ℕ → ℤ) : ℤ :=
  ∑ k ∈ Finset.range (N + 1), (-1 : ℤ) ^ k * (N.choose k) * g k

/-- **The operator IS Pascal.** The cell at `(r,d)` — `d` backward differences
of the row — equals the alternating binomial stencil of order `d` applied to the
`d+1` row values in its window.

This is what makes "a zero is one linear condition" literal rather than a
description: `(8,3)` is `23 − 3·13 + 3·7 − 5 = 0` on four values of `π`, and
`(20,6)` is the same on seven. It does **not** predict a location, and nothing
here says when the condition is met. See notes entry 60. -/
theorem tableFrom_eq_stencil (N : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    Construction.tableFrom N r d = stencil d (fun k => N (r - k)) := by
  rw [tableFrom_eq_fwdDiff, fwdDiff_iter_eq_sum_shift, stencil, Finset.mul_sum]
  refine Finset.sum_congr rfl fun k hk => ?_
  have hkd : k ≤ d := Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hsign : (-1 : ℤ) ^ d * (-1 : ℤ) ^ (d - k) = (-1 : ℤ) ^ k := by
    rw [← pow_add, show d + (d - k) = 2 * (d - k) + k by omega, pow_add, pow_mul]
    norm_num
  have hshift : r + k • (-1 : ℤ) = r - (k : ℤ) := by
    simp [sub_eq_add_neg]
  rw [hshift, smul_eq_mul]
  rw [show (-1 : ℤ) ^ d * (((-1 : ℤ) ^ (d - k) * (d.choose k)) * N (r - k))
        = ((-1 : ℤ) ^ d * (-1 : ℤ) ^ (d - k)) * (d.choose k) * N (r - k) by ring,
      hsign]

/-- **The stencil is linear in the sampled values.** So a zero is a single
linear equation on the `N+1` values of `pi` inside its window — one condition,
hence codimension one. Nothing here says when it is satisfied. -/
theorem stencil_add (N : ℕ) (g h : ℕ → ℤ) :
    stencil N (fun k => g k + h k) = stencil N g + stencil N h := by
  unfold stencil
  rw [← Finset.sum_add_distrib]
  exact Finset.sum_congr rfl fun k _ => by ring

/-- And scalars pass through — linearity's other half, beside `stencil_add`. -/
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

/-! ## The fold, on values

`stencil_weights_antisymm` and `stencil_arms_eq` below are about the *weights*.
These four are about the cell: the stencil splits by parity into two unsigned
arms, and the cell is their difference. `papers/The-Fold.md` § B calls them the
wings — at `(20,6)` they weigh 807295 each, at `(8,3)` 168 each.

The point of stating it this way is that it is an **identity**, true at every
cell (notes entry 55). The wings always exist. A zero is where they balance. -/

/-- The `+` wing: the even-index arm of the stencil, unsigned. -/
def wingPlus (N : ℕ) (g : ℕ → ℤ) : ℤ :=
  ∑ k ∈ (Finset.range (N + 1)).filter (fun k => Even k), (N.choose k : ℤ) * g k

/-- The `−` wing: the odd-index arm, unsigned. -/
def wingMinus (N : ℕ) (g : ℕ → ℤ) : ℤ :=
  ∑ k ∈ (Finset.range (N + 1)).filter (fun k => ¬ Even k), (N.choose k : ℤ) * g k

/-- **The fold is an identity, not a test.** `cell = wing⁺ − wing⁻`, always. -/
theorem stencil_eq_wings (N : ℕ) (g : ℕ → ℤ) :
    stencil N g = wingPlus N g - wingMinus N g := by
  unfold stencil wingPlus wingMinus
  rw [← Finset.sum_filter_add_sum_filter_not (Finset.range (N + 1)) (fun k => Even k)
        (fun k => (-1 : ℤ) ^ k * (N.choose k) * g k), sub_eq_add_neg,
      ← Finset.sum_neg_distrib]
  congr 1
  · refine Finset.sum_congr rfl fun k hk => ?_
    rw [Even.neg_one_pow (Finset.mem_filter.mp hk).2, one_mul]
  · refine Finset.sum_congr rfl fun k hk => ?_
    rw [Odd.neg_one_pow (Nat.not_even_iff_odd.mp (Finset.mem_filter.mp hk).2)]
    ring

/-- **A zero is where the wings balance.** -/
theorem stencil_eq_zero_iff_wings (N : ℕ) (g : ℕ → ℤ) :
    stencil N g = 0 ↔ wingPlus N g = wingMinus N g := by
  rw [stencil_eq_wings, sub_eq_zero]

/-- **The cell, folded.** Through `tableFrom_eq_stencil`: the table's cell at
`(r,d)` vanishes exactly when the two wings of its window balance. -/
theorem tableFrom_eq_zero_iff_wings (N : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    Construction.tableFrom N r d = 0
      ↔ wingPlus d (fun k => N (r - k)) = wingMinus d (fun k => N (r - k)) := by
  rw [tableFrom_eq_stencil, stencil_eq_zero_iff_wings]

/-- **Two readings of one fact.** `zero_iff_repeat` says a cell vanishes iff the
row repeats at the depth below. This says it vanishes iff the wings balance. The
repeat reading and the fold reading are the same statement, and until now nothing
in the tree connected them. -/
theorem repeat_iff_wings (N : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    Construction.tableFrom N r d = Construction.tableFrom N (r - 1) d
      ↔ wingPlus (d + 1) (fun k => N (r - k)) = wingMinus (d + 1) (fun k => N (r - k)) := by
  rw [← tableFrom_eq_zero_iff_wings, ← zero_iff_repeat (tableFrom_isTable N) r d]

/-! ## Why the stencil folds

`papers/The-Fold.md` § A and § B state the deep zero as a balance rather than a
vanishing: the weights pair off about the midpoint of the window, and the two
arms weigh the same. Both are properties of `(-1)^k C(N,k)` alone -- neither
mentions pi -- so both belong here, beside `stencil_annihilates_const`, rather
than in a measurement. -/

/-- **The stencil is antisymmetric when its order is odd.** Reflecting an index
about the midpoint negates its weight, because `(N-k) + k = N` is odd and so the
two indices have opposite parity.

This is what makes `The-Fold.md` § A3's pairing exist: with `N` odd there are
`(N+1)/2` pairs and no leftover term, so a cell is a sum over differences
straddling the window's centre. At `N = 7` the weights are
`+1, -7, +21, -35, +35, -21, +7, -1`. -/
theorem stencil_weights_antisymm {N : ℕ} (hN : Odd N) (k : ℕ) (hk : k ≤ N) :
    ((-1 : ℤ)) ^ (N - k) * (N.choose (N - k))
      = -(((-1 : ℤ)) ^ k * (N.choose k)) := by
  obtain ⟨j, hj⟩ := hN
  have hsum : (N - k) + k = N := Nat.sub_add_cancel hk
  have hmul : ((-1 : ℤ)) ^ (N - k) * ((-1 : ℤ)) ^ k = -1 := by
    rw [← pow_add, hsum, hj, pow_succ, pow_mul]
    norm_num
  have hsq : ((-1 : ℤ)) ^ k * ((-1 : ℤ)) ^ k = 1 := by
    rw [← pow_add, ← two_mul, pow_mul]; norm_num
  have hpar : ((-1 : ℤ)) ^ (N - k) = -((-1 : ℤ)) ^ k := by
    calc ((-1 : ℤ)) ^ (N - k)
        = ((-1 : ℤ)) ^ (N - k) * (((-1 : ℤ)) ^ k * ((-1 : ℤ)) ^ k) := by
          rw [hsq]; ring
      _ = (((-1 : ℤ)) ^ (N - k) * ((-1 : ℤ)) ^ k) * ((-1 : ℤ)) ^ k := by ring
      _ = -((-1 : ℤ)) ^ k := by rw [hmul]; ring
  rw [Nat.choose_symm hk, hpar]; ring

/-- **The two arms weigh the same.** `stencil_annihilates_const` says the signed
weights cancel; written as two sums, that is the positive-index arm equalling
the negative-index arm. `(1 + (-1)^k)` is twice the indicator of even `k` and
`(1 - (-1)^k)` twice the indicator of odd `k`, so this is the split with the
division cleared.

`The-Fold.md` § B1 measures both arms at 64 for `N = 7` and 8 for `N = 4`. -/
theorem stencil_arms_eq {N : ℕ} (hN : N ≠ 0) :
    (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k))
      = ∑ k ∈ Finset.range (N + 1), (1 - (-1 : ℤ) ^ k) * (N.choose k) := by
  have halt := Int.alternating_sum_range_choose_of_ne hN
  simp only [add_mul, sub_mul, one_mul]
  rw [Finset.sum_add_distrib, Finset.sum_sub_distrib, halt]
  ring

/-- **And each arm is `2^(N-1)`.** Doubled, an arm is the whole row, `2^N`. With
`stencil_arms_eq` that fixes both at half the row -- 64 and 64 at `N = 7`, 8 and
8 at `N = 4`, which is what `The-Fold.md` § B1 reports.

The zero of `The-Fold.md` § B3 is the two arms weighing the same once the
weights are applied to pi. This theorem is only why the WEIGHTS permit it; it
says nothing about whether any pi makes it happen. -/
theorem stencil_arm_doubled {N : ℕ} (hN : N ≠ 0) :
    (∑ k ∈ Finset.range (N + 1), (1 + (-1 : ℤ) ^ k) * (N.choose k))
      = 2 ^ N := by
  have halt := Int.alternating_sum_range_choose_of_ne hN
  have hrow : (∑ k ∈ Finset.range (N + 1), (N.choose k : ℤ)) = 2 ^ N := by
    have h := Nat.sum_range_choose N
    exact_mod_cast h
  simp only [add_mul, one_mul]
  rw [Finset.sum_add_distrib, halt, hrow, add_zero]

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

/-! ## Which ladders meet

`papers/Commensurate-Ladders.md` collects five results that all turn on one
question -- whether two ladders share a rung -- and § F3 records that the
general statement is nowhere in this tree. `window_exclusive_of_prime_exponent`
above settles it for a single window; this settles it for every dyadic one. -/

/-- Two ladders share a rung above `x = 1` exactly when some power of one is a
power of the other. `Commensurate-Ladders.md` § A2 states the real-log form,
`log b / log c` rational; this is the same condition in ℕ, which is where the
rungs actually sit and which needs no transcendence. -/
def LaddersMeet (b c : ℕ) : Prop :=
  ∃ n m : ℕ, 0 < n ∧ 0 < m ∧ b ^ n = c ^ m

/-- **Only powers of two reach a dyadic window.** If any positive power of `b`
equals a power of 2, then `b` is itself a power of 2. So the ladders meeting
base 2 are exactly `2, 4, 8, 16, …` and no others -- which is the general form
of `window_exclusive_of_prime_exponent`, stated for every window rather than
for `2^7`.

`Commensurate-Ladders.md` § C1 measures the consequence: among integer bases
2..9 the commensurate pairs are exactly the power chains 2-4-8 and 3-9, and
bases 5, 6, 7 meet nothing. § C3 is what that killed. -/
theorem base_of_meets_two {b k m : ℕ} (hk : k ≠ 0) (h : b ^ k = 2 ^ m) :
    ∃ i, b = 2 ^ i := by
  have hdvd : b ∣ 2 ^ m := h ▸ dvd_pow_self b hk
  obtain ⟨i, _, hi⟩ := (Nat.dvd_prime_pow Nat.prime_two).mp hdvd
  exact ⟨i, hi⟩

/-- **Two ladders that meet have proportional exponents.** If some power of `b`
equals some power of `c`, then at every prime the two exponents stand in the
ratio `m : n`. This is the "shared lineage" of `Commensurate-Ladders.md` § A2 in
exact form -- not that `b` and `c` are related somehow, but that their prime
signatures are one vector scaled two ways. -/
theorem factorization_proportional {b c n m : ℕ} (h : b ^ n = c ^ m) (p : ℕ) :
    n * b.factorization p = m * c.factorization p := by
  have hf := congrArg Nat.factorization h
  rw [Nat.factorization_pow, Nat.factorization_pow] at hf
  have := congrArg (fun f : ℕ →₀ ℕ => f p) hf
  simpa using this

/-- **And they are built from the same primes.** Proportionality with both
exponents nonzero forces the supports to agree, so ladders that meet are made
of one prime set. Bases 2 and 3 meet nowhere above `x = 1` for exactly this
reason -- there is no common ancestor because there is no common prime. -/
theorem primeFactors_eq_of_meets {b c n m : ℕ} (hn : n ≠ 0) (hm : m ≠ 0)
    (h : b ^ n = c ^ m) : b.primeFactors = c.primeFactors := by
  ext p
  simp only [Nat.mem_primeFactors_iff_mem_primeFactorsList,
    ← Nat.support_factorization, Finsupp.mem_support_iff]
  have hp := factorization_proportional h p
  constructor
  · intro hb hc
    rw [hc, Nat.mul_zero] at hp
    rcases Nat.mul_eq_zero.mp hp with h1 | h1
    · exact hn h1
    · exact hb h1
  · intro hc hb
    rw [hb, Nat.mul_zero] at hp
    rcases Nat.mul_eq_zero.mp hp.symm with h1 | h1
    · exact hm h1
    · exact hc h1

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Zeros.tableFrom_eq_stencil' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.tableFrom_eq_stencil

/-- info: 'Zeros.stencil_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_add

/-- info: 'Zeros.stencil_smul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_smul

/-- info: 'Zeros.stencil_annihilates_const' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_annihilates_const

/-- info: 'Zeros.stencil_eq_wings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_eq_wings

/-- info: 'Zeros.stencil_eq_zero_iff_wings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_eq_zero_iff_wings

/-- info: 'Zeros.tableFrom_eq_zero_iff_wings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.tableFrom_eq_zero_iff_wings

/-- info: 'Zeros.repeat_iff_wings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.repeat_iff_wings

/-- info: 'Zeros.stencil_weights_antisymm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_weights_antisymm

/-- info: 'Zeros.stencil_arms_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_arms_eq

/-- info: 'Zeros.stencil_arm_doubled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.stencil_arm_doubled

/-- info: 'Zeros.window_exclusive_of_prime_exponent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.window_exclusive_of_prime_exponent

/-- info: 'Zeros.base_of_meets_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.base_of_meets_two

/-- info: 'Zeros.factorization_proportional' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.factorization_proportional

/-- info: 'Zeros.primeFactors_eq_of_meets' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.primeFactors_eq_of_meets

end Zeros
