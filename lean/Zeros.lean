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

WHERE THE REST IS: item 2, and the base-2 half of item 3, are proved in
`ZerosStencil.lean`, which stays in namespace `Zeros` so every citation of
`Zeros.<name>` still resolves. That file holds the fifteen theorems whose
`#print axioms` carries `Classical.choice`, and `tableFrom_eq_fwdDiff`,
which joined them because its STATEMENT names Mathlib's `fwdDiff` and so
cannot leave the import behind. The fifteen below carry none of it. Notes
entries 66 and 187.

**This module does not import Mathlib.** Lean core only, the convention
`Construction.lean` set — see `lean/BUILD.md` § Mathlib-free core. Every
statement below is about ℤ and ℕ, so nothing in Mathlib is needed to say it,
and dropping the import dropped Mathlib's assumptions with it: measured on
this file, `window_shared_of_composite_exponent` went to no axioms at all and
`neg_below_zero` shed `Quot.sound`. Six proofs needed a core replacement:
`sub_eq_zero` became `Int.sub_eq_zero`, one `ring` became `Int.zero_sub _`,
`push_cast; ring` became `omega`, and three `norm_num` became `decide`.
`omega` IS available in core on this toolchain, against what
`Construction.lean` records, and it costs `[propext, Quot.sound]` — which
`pair_shares_diagonal` was already paying.
-/
import Construction

-- Core has no `ℕ`/`ℤ` notation; Mathlib's is what we gave up. `local` keeps
-- these inside this file so downstream modules still get Mathlib's own.
local notation "ℤ" => Int
local notation "ℕ" => Nat

namespace Zeros

/-! ## A zero is a repeat -/

variable {f : ℤ → ℕ → ℤ}

/-- The table recurrence: each cell is the difference of the two above it.

Depth is carried in ℕ. An earlier version quantified `d` over ℤ, which is
satisfiable but not by the bench's table: `Construction.tableFrom` has type
`ℤ → ℕ → ℤ` and cannot be passed at all, and the obvious `toNat` adapter makes
the recurrence at `d = -1` read `N r = N r - N (r-1)`, forcing `N (r-1) = 0` at
every rung. So the theorem below was quantified over a class the object it is
about is not in. -/
def IsTable (f : ℤ → ℕ → ℤ) : Prop :=
  ∀ (r : ℤ) (d : ℕ), f r (d + 1) = f r d - f (r - 1) d

/-- **The bench's table is one.** The hypothesis of `zero_iff_repeat` now has a
witness: it is the second conjunct of `Construction.tableFrom_isTableOf`, which
itself depends on no axioms. -/
theorem tableFrom_isTable (N : ℤ → ℤ) : IsTable (Construction.tableFrom N) :=
  (Construction.tableFrom_isTableOf N).2

/-- **A zero is exactly a repeat one depth up.** This is definitional, and it is
the only characterisation of a zero the chain supplies. -/
theorem zero_iff_repeat (hf : IsTable f) (r : ℤ) (d : ℕ) :
    f r (d + 1) = 0 ↔ f r d = f (r - 1) d := by
  rw [hf r d]
  exact Int.sub_eq_zero

/-! ## What a zero forces next

`papers/The-Fold.md` § C2 records that a zero propagates a sign-flipped copy
one depth down, and that the copy lands on the diagonal one in. Both are
consequences of the recurrence, so both belong here rather than in a
measurement. -/

/-- **A zero puts its left neighbour, negated, directly beneath it.** With the
cell above vanishing, the recurrence has nothing to subtract from. -/
theorem neg_below_zero (N : ℤ → ℤ) (r : ℤ) (d : ℕ)
    (hz : Construction.tableFrom N r d = 0) :
    Construction.tableFrom N r (d + 1) = -Construction.tableFrom N (r - 1) d := by
  show Construction.tableFrom N r d - Construction.tableFrom N (r - 1) d = _
  rw [hz]; exact Int.zero_sub _

/-- **And those two cells share a diagonal.** The left neighbour sits at
`(r-1, d)` and the copy at `(r, d+1)`, and `r - d` is the same for both. So
every zero places a `±v` pair as adjacent cells on the diagonal one in --
`±343` at `(20,6)`, `±5` at `(8,3)`, both measured in `The-Fold.md` § C3. -/
theorem pair_shares_diagonal (r : ℤ) (d : ℕ) :
    (r - 1) - (d : ℤ) = r - ((d + 1 : ℕ) : ℤ) := by
  omega

/-! ## Window exclusivity -/

/-- **The (8,3) window is shared.** Depth 3 spans `2^4 = 4^2`, so base 4 reaches
it at depth 1. Against `Zeros.window_exclusive_of_prime_exponent`, which puts
base 2 alone in the (20,6) window, the two deep zeros are different kinds of
object. -/
theorem window_shared_of_composite_exponent : (4 : ℕ) ^ 2 = 2 ^ 4 := by decide

/-! ## What is NOT proved

Nothing above determines a location. `zero_iff_repeat` says a zero is a repeat;
it does not say where pi repeats. `stencil_add` says a zero is one linear
condition; it does not say when the condition holds. `window_exclusive_...` says
which bases could see the (20,6) window; it does not say that anything is there.

The measured locations are recorded below and stand unexplained.
-/

/-- The four exact zeros, `(r, d)`, over `r <= 62`, `d <= 61`.
`results/O16_run2.log`. **Unexplained: no theorem above predicts these** — their
LOCATION is not derived, and nothing here changes that.

**But their vanishing is no longer transcribed.** `measured_zeros_all_vanish`
below computes all four from `pi2`, with no axioms. Anything citing this `def`
should cite that theorem instead: `utilities/check_refs.py` resolves a `def` and
a `theorem` identically, so a citation to a hand-typed list is indistinguishable
from a citation to a proof. `papers/The-Four-Zeros.md` § B9 was doing exactly
that. Notes entry 78. -/
def measured_zeros : List (ℕ × ℕ) := [(2, 1), (4, 1), (8, 3), (20, 6)]

/-! ## The zeros, computed rather than transcribed

`tableFrom_eq_stencil` makes a cell one Pascal-weighted line on the row. The row
is `π(2^r) − π(2^(r−1))`. So each zero is one line of arithmetic on `π`, and the
kernel can check it:

```text
(2,1)    1·1 − 1·1                                                    = 0
(4,1)    1·2 − 1·2                                                    = 0
(8,3)    1·23 − 3·13 + 3·7 − 1·5                                      = 0
(20,6)   1·38635 − 6·20390 + 15·10749 − 20·5709 + 15·3030
           − 6·1612 + 1·872                                           = 0
```

The two non-zero neighbours are proved as well, so the check fires in both
directions rather than only confirming. `(19,6) = 343` is the `+343` of
`papers/The-Fold.md` § C3, whose partner `−343` sits at `(20,7)`. -/

/-- `π(2^n)` for `n = 0…20`, read from `pi2n_cache.json`. **This is the only
measured input to anything below** — 21 integers, and no other data enters. -/
def pi2 : ℕ → ℤ
  | 0 => 0      | 1 => 1      | 2 => 2      | 3 => 4      | 4 => 6
  | 5 => 11     | 6 => 18     | 7 => 31     | 8 => 54     | 9 => 97
  | 10 => 172   | 11 => 309   | 12 => 564   | 13 => 1028  | 14 => 1900
  | 15 => 3512  | 16 => 6542  | 17 => 12251 | 18 => 23000 | 19 => 43390
  | 20 => 82025 | _ => 0

/-- The depth-0 row `N(r) = π(2^r) − π(2^(r−1))`: the primes in `(2^(r−1), 2^r]`. -/
def dyadicRow : ℤ → ℤ := fun r =>
  if 1 ≤ r ∧ r ≤ 20 then pi2 r.toNat - pi2 (r - 1).toNat else 0

/-- `(2,1)` vanishes: `1·1 − 1·1 = 0`, computed by the kernel from `pi2`. -/
theorem zero_2_1  : Construction.tableFrom dyadicRow 2 1 = 0 := by decide
/-- `(4,1)` vanishes: `1·2 − 1·2 = 0`. -/
theorem zero_4_1  : Construction.tableFrom dyadicRow 4 1 = 0 := by decide
/-- `(8,3)` vanishes: `23 − 3·13 + 3·7 − 5 = 0`, four values of `π`. -/
theorem zero_8_3  : Construction.tableFrom dyadicRow 8 3 = 0 := by decide
/-- `(20,6)` vanishes: the depth-6 stencil on seven values of `π`, spanning
`2^13` to `2^20`. The deep zero, computed. -/
theorem zero_20_6 : Construction.tableFrom dyadicRow 20 6 = 0 := by decide

/-- **The list's own claim, as a theorem.** Every cell `measured_zeros` names
vanishes on the dyadic row. -/
theorem measured_zeros_all_vanish :
    ∀ c ∈ measured_zeros, Construction.tableFrom dyadicRow (c.1 : ℤ) c.2 = 0 := by
  decide

/-- A non-zero neighbour, so the check can fail. -/
theorem nonzero_7_3 : Construction.tableFrom dyadicRow 7 3 = 5 := by decide

/-- The `+343` of `papers/The-Fold.md` § C3, the partner of the `−343` that a
zero at `(20,6)` forces onto `(20,7)`. -/
theorem nonzero_19_6 : Construction.tableFrom dyadicRow 19 6 = 343 := by decide

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

/-- **The measured repeat gives the deep zero, through the theorem.** `O27` reads
`d5` at `r = 19` and `r = 20` as both 623; `zero_iff_repeat` turns that into
`(20,6) = 0` without computing anything. The measurement is the input and the
vanishing is the output, which is the only direction this file supports. -/
theorem zero_at_20_6_of_repeat (N : ℤ → ℤ)
    (h20 : Construction.tableFrom N 20 5 = measured_repeat_20_6)
    (h19 : Construction.tableFrom N 19 5 = measured_repeat_20_6) :
    Construction.tableFrom N 20 6 = 0 :=
  (zero_iff_repeat (tableFrom_isTable N) 20 5).mpr (by
    have h : (20 : ℤ) - 1 = 19 := by decide
    rw [h, h20, h19])

/-- The same for the other deep zero, where the repeated value is 4. -/
theorem zero_at_8_3_of_repeat (N : ℤ → ℤ)
    (h8 : Construction.tableFrom N 8 2 = measured_repeat_8_3)
    (h7 : Construction.tableFrom N 7 2 = measured_repeat_8_3) :
    Construction.tableFrom N 8 3 = 0 :=
  (zero_iff_repeat (tableFrom_isTable N) 8 2).mpr (by
    have h : (8 : ℤ) - 1 = 7 := by decide
    rw [h, h8, h7])

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

/-- info: 'Zeros.tableFrom_isTable' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.tableFrom_isTable

/-- info: 'Zeros.neg_below_zero' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Zeros.neg_below_zero

/-- info: 'Zeros.pair_shares_diagonal' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms Zeros.pair_shares_diagonal

/-- info: 'Zeros.zero_at_20_6_of_repeat' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Zeros.zero_at_20_6_of_repeat

/-- info: 'Zeros.zero_at_8_3_of_repeat' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Zeros.zero_at_8_3_of_repeat

/-- info: 'Zeros.zero_2_1' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.zero_2_1

/-- info: 'Zeros.zero_4_1' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.zero_4_1

/-- info: 'Zeros.zero_8_3' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.zero_8_3

/-- info: 'Zeros.zero_20_6' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.zero_20_6

/-- info: 'Zeros.measured_zeros_all_vanish' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.measured_zeros_all_vanish

/-- info: 'Zeros.nonzero_7_3' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.nonzero_7_3

/-- info: 'Zeros.nonzero_19_6' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.nonzero_19_6

/-- info: 'Zeros.window_shared_of_composite_exponent' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.window_shared_of_composite_exponent

/-- info: 'Zeros.four_zeros_only' does not depend on any axioms -/
#guard_msgs in
#print axioms Zeros.four_zeros_only

end Zeros
