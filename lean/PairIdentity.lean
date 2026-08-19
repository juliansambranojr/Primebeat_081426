/-
PairIdentity — the complementary pair, and why base two is singular.

Encodes statement **I1** of `papers/Euler-Factor-Chain.md` § I ("The
complementary pair"):

  `prime(r,d) + composite(r,d) = (b−1)^(d+1)·b^(r−1−d)`, exact at every cell in
  every base.

and its § I5 consequence, which `papers/The-Four-Zeros.md` § E2 records as a
measurement.

THE CLAIM. Split each rung `(b^(r−1), b^r]` into the primes it holds and the
composites it holds. Difference both counts down the depth axis. At every cell
the two differenced arms sum to `(b−1)^(d+1)·b^(r−1−d)` — a quantity with no
primes in it at all. All the arithmetic lives in the split; the total is pure
geometry.

WHAT IS PROVED HERE
  1. `tableFrom_of_geometric` — a row that steps by a factor `b` collapses under
     `d` backward differences to `(b−1)^d` times its bottom entry. This is
     `EulerFactorChain.symbol_of_backward_difference` (A1) at `ρ = 1`, moved
     into ℤ where the table actually lives.
  2. `tableFrom_add_window` — differencing is linear, and only the `d+1` row
     entries a cell reads can matter. `Construction.tableFrom_add` and
     `Construction.zero_determined_by_row` supply both halves.
  3. `pair_identity` — the two together. No hypothesis about primes is used
     anywhere: the seed rows are arbitrary, and the only thing asked of them is
     that they partition each rung.
  4. `coeff_eq_one_iff_base_two`, `total_eq_pow_iff_base_two` — the corollary.
     `(b−1)^(d+1) = 1` exactly when `b = 2`, for integer `b ≥ 2`. Base two is
     the ONLY base whose cell total is a bare power of the base itself; b = 3
     carries `2^(d+1)·3^(r−1−d)`, b = 4 carries `3^(d+1)·4^(r−1−d)`.

WHAT THIS DOES NOT SAY. It is a statement about the FORM OF THE TOTAL, not
about zeros. Nothing here predicts, or could predict, where either arm
vanishes — that hole is stated in `Zeros.lean` and stays open. What the
corollary does mean is narrower and worth saying exactly: only in base 2 can a
vanished prime arm leave the composite arm sitting exactly on a power of the
grid. In every other base the surviving arm lands on `(b−1)^(d+1)` times a
power, which is not a grid point.

INDEX CONVENTION. `Construction.tableFrom` puts depth `d` at `d` backward
differences of the depth-0 row, and the depth-0 row here is the per-rung count
(itself already one difference of the cumulative count). So `d` below is the
paper's `d`, and the exponent `r−1−d` is carried as a natural number `e` with
`r = d + 1 + e`, which keeps every exponent in ℕ and every rung inside the
table's support.

STATUS: the statements below are proved outright, with no numerical input.
The measured values at the end are inputs to a check, not to a proof.
-/
import Mathlib
import Construction
import EulerFactorChain

namespace PairIdentity

open Construction

/-! ## The step, which is A1 at ρ = 1 -/

/-- **A1 at `ρ = 1`.** `EulerFactorChain.symbol_of_backward_difference` says
backward differencing the mode `b^(rρ)` multiplies it by `1 − b^(−ρ)`. At
`ρ = 1` the multiplier is `1 − b⁻¹`. Stated here only to name the instance the
rest of this file uses; it carries no content of its own. -/
theorem symbol_at_one (b : ℝ) (hb : b ≠ 0) (r : ℂ) :
    (b : ℂ) ^ (r * 1) - (b : ℂ) ^ ((r - 1) * 1)
      = EulerFactorChain.sym b 1 * (b : ℂ) ^ (r * 1) :=
  EulerFactorChain.symbol_of_backward_difference b hb 1 r

/-- The same step inside ℤ, where the table lives: `(1 − b⁻¹)·b^(r) =
(b−1)·b^(r−1)`. One backward difference of a geometric row multiplies it by
`b − 1` and drops the exponent by one. -/
theorem backward_difference_pow (b : ℤ) (r : ℕ) :
    b ^ (r + 1) - b ^ r = (b - 1) * b ^ r := by ring

/-! ## A geometric row collapses

The hypothesis is deliberately local. No total function `ℤ → ℤ` satisfies
`G r = b * G (r−1)` at every `r` except `G = 0`, so a global geometric
hypothesis would be vacuous. What a cell at `(r,d)` actually reads is the
window `r, r−1, …, r−d`, and the hypothesis asks only for the `d` steps inside
it. -/

/-- **The collapse.** If the row steps by `b` across the window a cell reads,
then `d` backward differences leave `(b−1)^d` times the bottom entry of that
window. Iterating `backward_difference_pow`; the whole index difficulty is that
each difference moves the window's bottom down by one. -/
theorem tableFrom_of_geometric (b : ℤ) (G : ℤ → ℤ) (r : ℤ) (d : ℕ)
    (hG : ∀ k : ℕ, k < d → G (r - k) = b * G (r - k - 1)) :
    tableFrom G r d = (b - 1) ^ d * G (r - d) := by
  induction d generalizing r with
  | zero =>
      show G r = (b - 1) ^ 0 * G (r - ((0 : ℕ) : ℤ))
      simp
  | succ n ih =>
      have h1 : tableFrom G r n = (b - 1) ^ n * G (r - (n : ℤ)) :=
        ih r fun k hk => hG k (by omega)
      have h2 : tableFrom G (r - 1) n = (b - 1) ^ n * G (r - 1 - (n : ℤ)) := by
        refine ih (r - 1) fun k hk => ?_
        have hstep := hG (k + 1) (by omega)
        have hcast : r - ((k + 1 : ℕ) : ℤ) = r - 1 - (k : ℤ) := by push_cast; ring
        rwa [hcast] at hstep
      have h3 : G (r - (n : ℤ)) = b * G (r - (n : ℤ) - 1) := hG n (by omega)
      have e2 : r - 1 - (n : ℤ) = r - (n : ℤ) - 1 := by ring
      have e3 : r - ((n + 1 : ℕ) : ℤ) = r - (n : ℤ) - 1 := by push_cast; ring
      show tableFrom G r n - tableFrom G (r - 1) n = _
      rw [h1, h2, e2, h3, e3]
      ring

/-! ## Only the window matters -/

/-- **Linearity, localised.** If two rows partition a third across the window a
cell reads, the two tables sum to the third table at that cell.
`Construction.tableFrom_add` gives that the table of a sum is the sum of
tables; `Construction.zero_determined_by_row` gives that agreement on the
window is all a cell can see. -/
theorem tableFrom_add_window (P C T : ℤ → ℤ) (r : ℤ) (d : ℕ)
    (h : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = T (r - k)) :
    tableFrom P r d + tableFrom C r d = tableFrom T r d := by
  rw [← tableFrom_add P C r d]
  exact zero_determined_by_row r d h

/-! ## The pair identity -/

/-- **I1, the pair identity.** Let `P` and `C` be any two rows that partition
each rung: at rung `r − k` the two counts sum to `(b−1)·b^(r−k−1)`, the number
of integers the rung holds. Then at every cell the differenced arms sum to

  `(b−1)^(d+1) · b^(r−1−d)`.

The right side contains no primes. Nothing in the proof knows that `P` counts
primes — the identity is forced by the partition alone, and the whole content
of the prime/composite split is that it is a partition of a geometric row.

Exponents are carried in ℕ: `e` is `r − 1 − d`, pinned by `hr`. -/
theorem pair_identity (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k))) :
    tableFrom P r d + tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e := by
  have hwin : ∀ k : ℕ, k ≤ d →
      P (r - k) + C (r - k) = (b - 1) * b ^ (r - (k : ℤ) - 1).toNat := by
    intro k hk
    have hexp : (r - (k : ℤ) - 1).toNat = e + (d - k) := by subst hr; omega
    rw [hexp]
    exact hpair k hk
  have hgeom : ∀ k : ℕ, k < d →
      (fun x : ℤ => (b - 1) * b ^ (x - 1).toNat) (r - k)
        = b * (fun x : ℤ => (b - 1) * b ^ (x - 1).toNat) (r - k - 1) := by
    intro k hk
    show (b - 1) * b ^ (r - (k : ℤ) - 1).toNat
        = b * ((b - 1) * b ^ (r - (k : ℤ) - 1 - 1).toNat)
    have hstep : (r - (k : ℤ) - 1).toNat = (r - (k : ℤ) - 1 - 1).toNat + 1 := by
      subst hr; omega
    rw [hstep, pow_succ]
    ring
  have hadd := tableFrom_add_window P C (fun x : ℤ => (b - 1) * b ^ (x - 1).toNat) r d hwin
  have hcollapse :=
    tableFrom_of_geometric b (fun x : ℤ => (b - 1) * b ^ (x - 1).toNat) r d hgeom
  have hbot : (r - (d : ℤ) - 1).toNat = e := by subst hr; omega
  rw [hadd, hcollapse]
  show (b - 1) ^ d * ((b - 1) * b ^ (r - (d : ℤ) - 1).toNat) = _
  rw [hbot]
  ring

/-- **I5, the pole.** Where the prime arm vanishes the composite arm carries the
whole total — it has nowhere else to go. This is the identity read at a zero,
and it is the only sense in which a zero says anything about the composite
side. -/
theorem composite_of_prime_zero (b : ℤ) (P C : ℤ → ℤ) (r : ℤ) (d e : ℕ)
    (hr : r = (d : ℤ) + 1 + e)
    (hpair : ∀ k : ℕ, k ≤ d → P (r - k) + C (r - k) = (b - 1) * b ^ (e + (d - k)))
    (hzero : tableFrom P r d = 0) :
    tableFrom C r d = (b - 1) ^ (d + 1) * b ^ e := by
  have h := pair_identity b P C r d e hr hpair
  rw [hzero, zero_add] at h
  exact h

/-! ## Base two is the only base whose total is a bare power

This is a statement about the form of the total. It is NOT a statement about
zeros, and it does not explain why the four zeros sit where they do. -/

/-- **The corollary.** For integer `b ≥ 2`, the coefficient `(b−1)^(d+1)` is `1`
exactly when `b = 2`. Every other base carries a factor strictly greater
than one, at every depth. -/
theorem coeff_eq_one_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d : ℕ) :
    (b - 1) ^ (d + 1) = 1 ↔ b = 2 := by
  constructor
  · intro h
    by_contra hne
    have h1 : (1 : ℤ) < b - 1 := by omega
    have key : ∀ n : ℕ, (1 : ℤ) < (b - 1) ^ (n + 1) := by
      intro n
      induction n with
      | zero => simpa using h1
      | succ m ih =>
          calc (1 : ℤ) < (b - 1) ^ (m + 1) := ih
            _ < (b - 1) ^ (m + 1) * (b - 1) := by nlinarith [ih, h1]
            _ = (b - 1) ^ (m + 1 + 1) := (pow_succ _ _).symm
    have := key d
    omega
  · intro h
    subst h
    norm_num

/-- **The corollary, in the identity's own terms.** The cell total is a bare
power of the base — no `(b−1)` factor anywhere — exactly in base two. So base
two is the only grid on which a vanished prime arm leaves the composite arm
sitting on a power of the base itself. -/
theorem total_eq_pow_iff_base_two {b : ℤ} (hb : 2 ≤ b) (d e : ℕ) :
    (b - 1) ^ (d + 1) * b ^ e = b ^ e ↔ b = 2 := by
  have hbpos : (0 : ℤ) < b ^ e := pow_pos (by omega) e
  constructor
  · intro h
    have h' : (b - 1) ^ (d + 1) * b ^ e = 1 * b ^ e := by rw [one_mul]; exact h
    exact (coeff_eq_one_iff_base_two hb d).mp (mul_right_cancel₀ (ne_of_gt hbpos) h')
  · intro h
    subst h
    norm_num

/-- Base three does carry the factor: the total at `(r,d)` is
`2^(d+1)·3^(r−1−d)`, never a bare power of three. -/
theorem base_three_carries_factor (d e : ℕ) :
    ((3 : ℤ) - 1) ^ (d + 1) * 3 ^ e = 2 ^ (d + 1) * 3 ^ e := by norm_num

/-- Base four likewise: `3^(d+1)·4^(r−1−d)`. -/
theorem base_four_carries_factor (d e : ℕ) :
    ((4 : ℤ) - 1) ^ (d + 1) * 4 ^ e = 3 ^ (d + 1) * 4 ^ e := by norm_num

/-! ## What the bench measured

`papers/The-Four-Zeros.md` § E1 records the identity as checked, not derived:
"O16 · identity_a_backward, 1953 cells checked, 0 mismatches, for b = 2",
confirmed in `results/O16_centered_difference_table_run2.json` →
`summary.identity_a_backward` (`cells_checked` 1953, `mismatches` 0). § E2 then
reads the composite arm off at the four zeros. Those four numbers are the
falsifier: the identity above predicts them from the grid alone, and if the
bench disagreed at any of the four the theorem below would not compile. -/

/-- The four exact zeros of the dyadic prime table, `(r, d)`, `r ≤ 62`,
`d ≤ 61`. `results/O16_run2.log`; same list as `Zeros.measured_zeros` and
`Construction.measured_zeros`. -/
def zero_cells : List (ℕ × ℕ) := [(2, 1), (4, 1), (8, 3), (20, 6)]

/-- The composite arm at those four cells, read from
`papers/The-Four-Zeros.md` § E2: "At the four zeros the composite arm therefore
carries the whole term: `1, 4, 16, 8192`." -/
def measured_composite_at_zeros : List ℤ := [1, 4, 16, 8192]

/-- **The falsifier.** Evaluating `(b−1)^(d+1)·b^(r−1−d)` at `b = 2` and the four
measured zero cells reproduces the measured composite arm exactly. The formula
is derived above from the partition alone; the four values were measured. They
agree. -/
theorem measured_composite_matches_pair_identity :
    zero_cells.map (fun c => ((2 : ℤ) - 1) ^ (c.2 + 1) * 2 ^ (c.1 - 1 - c.2))
      = measured_composite_at_zeros := by decide

/-- The deep zero, stated through the identity rather than through arithmetic.
Given that the prime arm vanishes at `(20,6)` — which is measured, not proved —
the partition forces the composite arm to be `8192`, which is what § E2
records. -/
theorem composite_at_zero_20_6 (P C : ℤ → ℤ)
    (hpair : ∀ k : ℕ, k ≤ 6 → P (20 - k) + C (20 - k) = ((2 : ℤ) - 1) * 2 ^ (13 + (6 - k)))
    (hzero : tableFrom P 20 6 = 0) :
    tableFrom C 20 6 = 8192 := by
  have h := composite_of_prime_zero 2 P C 20 6 13 (by norm_num) hpair hzero
  rw [h]
  norm_num

/-! ## What is NOT proved

Nothing above locates a zero. `pair_identity` says the two arms sum to a fixed
geometric total; it does not say when either arm is empty.
`composite_of_prime_zero` says what the composite arm must be AT a zero; it
does not say there is one. The corollary distinguishes base two by the form of
the total, not by the existence of anything in it.

The measured values are recorded to be checked against the formula, and they
are used in no proof of the formula.
-/

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'PairIdentity.symbol_at_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.symbol_at_one

/-- info: 'PairIdentity.backward_difference_pow' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.backward_difference_pow

/-- info: 'PairIdentity.tableFrom_of_geometric' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.tableFrom_of_geometric

/-- info: 'PairIdentity.tableFrom_add_window' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.tableFrom_add_window

/-- info: 'PairIdentity.pair_identity' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.pair_identity

/-- info: 'PairIdentity.composite_of_prime_zero' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.composite_of_prime_zero

/-- info: 'PairIdentity.coeff_eq_one_iff_base_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.coeff_eq_one_iff_base_two

/-- info: 'PairIdentity.total_eq_pow_iff_base_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.total_eq_pow_iff_base_two

/-- info: 'PairIdentity.base_three_carries_factor' depends on axioms: [propext] -/
#guard_msgs in
#print axioms PairIdentity.base_three_carries_factor

/-- info: 'PairIdentity.base_four_carries_factor' depends on axioms: [propext] -/
#guard_msgs in
#print axioms PairIdentity.base_four_carries_factor

/-- info: 'PairIdentity.measured_composite_matches_pair_identity' depends on axioms: [propext] -/
#guard_msgs in
#print axioms PairIdentity.measured_composite_matches_pair_identity

/-- info: 'PairIdentity.composite_at_zero_20_6' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms PairIdentity.composite_at_zero_20_6

end PairIdentity
