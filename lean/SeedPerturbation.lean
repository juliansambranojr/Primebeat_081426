/-
SeedPerturbation — changing the seed convention cannot reach a deep cell.

THE QUESTION. The dyadic tables in `imported/lattice_mapper/` are built on a
seed convention: the primes 2 and 3 are treated as lattice rather than counted
as primes. That is a choice. If a different choice moved the zeros, the zeros
would be artefacts of bookkeeping. So: which cells can a change of convention
reach?

THE ANSWER. A convention change replaces the depth-0 row `N` by `N − e`, where
`e` counts, per rung, whatever the convention excludes. Two facts do the work,
both already in `Construction.lean`:

  * LINEARITY (`tableFrom_add`, `tableFrom_smul`) — the whole table shifts by
    `tableFrom e`, exactly.
  * LOCALITY (`zero_determined_by_row`) — a cell at `(r,d)` reads only the
    `d+1` row entries `r, r−1, …, r−d`.

So if `e` vanishes on every rung strictly above `R`, the window bottom `r − d`
must clear `R` for the cell to be untouched.

WHAT IS PROVED
  1. `tableFrom_sub` — the table of `N − e` is `tableFrom N − tableFrom e`.
     Derived from `Construction.tableFrom_add` and `Construction.tableFrom_smul`.
  2. `tableFrom_eq_zero_of_vanishing_above` — `e` vanishing above `R` plus
     `R < r − d` forces `tableFrom e r d = 0`.
  3. `cell_eq_of_seed_perturbation` — hence the cell itself is identical under
     both conventions.
  4. `zero_stable_of_seed_perturbation` and `zero_iff_of_seed_perturbation` —
     the corollary: a zero at `(r,d)` with `r − d > R` is a zero under both
     conventions, and a non-zero stays non-zero.
  5. `tableFrom_at_boundary`, `boundary_can_move` — the inequality is SHARP.
     At `r − d = R` the cell is exactly `(−1)^d · e R`, which is non-zero
     whenever `e R` is. The hypothesis is `r − d > R` and cannot be relaxed to
     `r − d ≥ R`.

THE INEQUALITY IS STRICT. This is the whole index question and it is settled
against `Construction.tableFrom`'s actual definition, not against prose. The
window a cell reads runs down to `r − d` INCLUSIVE, so `r − d` must be a rung
where `e` already vanishes, i.e. `R < r − d`. Item 5 exhibits the failure at
equality, and the imported tables exhibit it too: see the measured section.

WHAT IS NOT PROVED. Nothing here predicts a zero, locates one, or says a zero
exists. `Zeros.lean` states that hole and it stays open. Nor does anything here
say a cell with `r − d ≤ R` DOES move — only that the theorem stops protecting
it. Two of the measured cases below sit at `r − d = R` and both move; that is
measurement, not a consequence of anything proved.

CONVENTION. Rung `r` is the interval `(b^(r−1), b^r]`. In base 2: rung 1 is
`(1,2]` and holds 2, rung 2 is `(2,4]` and holds 3, rung 3 is `(4,8]` and holds
4, 5, 6, 7, 8. `R` is written `R_e` in prose — the largest rung on which `e` is
non-zero. Depth `d` is `d` backward differences, matching
`imported/lattice_mapper/README.md`'s `delta_d` and `Construction.tableFrom`.
-/
import Construction

-- Mathlib-free: Lean core only. See `lean/BUILD.md` § Mathlib-free core for
-- the rules, the measured cost table, and why a named Mathlib lemma can cost
-- more than a tactic. `omega` is allowed here — it costs `Quot.sound`, not
-- `Classical.choice`.
local notation "ℤ" => Int
local notation "ℕ" => Nat

namespace SeedPerturbation

open Construction

/-! ## The shift is exactly `tableFrom e`

`Construction.tableFrom_add` and `Construction.tableFrom_smul` are the whole
input. Nothing about primes, nothing about the base. -/

/-- The zero row builds the zero table. -/
theorem tableFrom_zero (r : ℤ) (d : ℕ) : tableFrom (fun _ : ℤ => (0 : ℤ)) r d = 0 := by
  induction d generalizing r with
  | zero => rfl
  | succ n ih =>
      show tableFrom _ r n - tableFrom _ (r - 1) n = 0
      rw [ih r, ih (r - 1)]
      decide

/-- **Linearity, in the form the convention change needs.** Replacing the
depth-0 row `N` by `N − e` subtracts `tableFrom e` from every cell of the
table, at every depth. -/
theorem tableFrom_sub (N e : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    tableFrom (fun x => N x - e x) r d = tableFrom N r d - tableFrom e r d := by
  have hneg : tableFrom (fun x => (-1 : ℤ) * e x) r d = -tableFrom e r d := by
    rw [tableFrom_smul, Int.neg_mul, Int.one_mul]
  have hadd : tableFrom (fun x => N x + (-1 : ℤ) * e x) r d
      = tableFrom N r d + tableFrom (fun x => (-1 : ℤ) * e x) r d :=
    tableFrom_add N (fun x => (-1 : ℤ) * e x) r d
  have hfun : (fun x : ℤ => N x - e x) = (fun x : ℤ => N x + (-1 : ℤ) * e x) := by
    funext x
    rw [Int.neg_mul, Int.one_mul, ← Int.sub_eq_add_neg]
  rw [hfun, hadd, hneg, ← Int.sub_eq_add_neg]

/-! ## Locality kills the shift above `R`

`Construction.zero_determined_by_row` says a cell sees only `r, r−1, …, r−d`.
The bottom of that window is `r − d`, and it is IN the window. -/

/-- **The excess table vanishes past the excess.** If `e` is zero on every rung
strictly above `R`, then every cell whose window bottom `r − d` clears `R`
reads only zeros, so the cell is zero.

The inequality is `R < r − d` and it is strict, because the window includes its
own bottom entry `r − d`. See `boundary_can_move` for the failure at equality. -/
theorem tableFrom_eq_zero_of_vanishing_above {e : ℤ → ℤ} {R : ℤ}
    (he : ∀ s : ℤ, R < s → e s = 0) (r : ℤ) (d : ℕ) (hrd : R < r - (d : ℤ)) :
    tableFrom e r d = 0 := by
  have hwin : ∀ k : ℕ, k ≤ d → e (r - (k : ℤ)) = (fun _ : ℤ => (0 : ℤ)) (r - (k : ℤ)) := by
    intro k hk
    have hkd : (k : ℤ) ≤ (d : ℤ) := Int.ofNat_le.mpr hk
    exact he _ (Int.lt_of_lt_of_le hrd (Int.sub_le_sub_left hkd r))
  rw [zero_determined_by_row (M := fun _ : ℤ => (0 : ℤ)) r d hwin, tableFrom_zero]

/-! ## The theorem -/

/-- **The claim.** Changing the seed convention replaces the depth-0 row `N` by
`N − e`. If `e` vanishes on every rung strictly above `R`, then every cell at
`(r,d)` with `r − d > R` is IDENTICAL under both conventions.

No hypothesis about primes, about the base, or about `N` at all. -/
theorem cell_eq_of_seed_perturbation {N e : ℤ → ℤ} {R : ℤ}
    (he : ∀ s : ℤ, R < s → e s = 0) (r : ℤ) (d : ℕ) (hrd : R < r - (d : ℤ)) :
    tableFrom (fun x => N x - e x) r d = tableFrom N r d := by
  rw [tableFrom_sub, tableFrom_eq_zero_of_vanishing_above he r d hrd, Int.sub_zero]

/-! ## The corollary that makes it useful -/

/-- **The corollary.** A zero at `(r,d)` with `r − d > R` is a zero under both
conventions. The seed convention cannot have put it there and cannot take it
away. -/
theorem zero_stable_of_seed_perturbation {N e : ℤ → ℤ} {R : ℤ}
    (he : ∀ s : ℤ, R < s → e s = 0) (r : ℤ) (d : ℕ) (hrd : R < r - (d : ℤ))
    (hz : tableFrom N r d = 0) :
    tableFrom (fun x => N x - e x) r d = 0 := by
  rw [cell_eq_of_seed_perturbation he r d hrd, hz]

/-- The same statement as an equivalence, which is the honest form: past the
excess, the two conventions have the same zero set. Neither direction is a
weaker claim than the other. -/
theorem zero_iff_of_seed_perturbation {N e : ℤ → ℤ} {R : ℤ}
    (he : ∀ s : ℤ, R < s → e s = 0) (r : ℤ) (d : ℕ) (hrd : R < r - (d : ℤ)) :
    tableFrom (fun x => N x - e x) r d = 0 ↔ tableFrom N r d = 0 := by
  rw [cell_eq_of_seed_perturbation he r d hrd]

/-! ## The inequality is sharp

`≥` would be false. At `r − d = R` the window bottom lands exactly on the top
rung where `e` is still alive, and the cell moves by `±e R`. -/

/-- **The boundary cell, exactly.** When the window bottom sits on `R` itself,
`d` backward differences leave `(−1)^d · e R` — the whole excess, signed. Every
higher entry of the window is already zero, so the bottom entry is all there
is. -/
theorem tableFrom_at_boundary {e : ℤ → ℤ} {R : ℤ}
    (he : ∀ s : ℤ, R < s → e s = 0) (r : ℤ) (d : ℕ) (hrd : r - (d : ℤ) = R) :
    tableFrom e r d = (-1) ^ d * e R := by
  induction d generalizing r with
  | zero =>
      have hr : r = R := by omega
      subst hr
      show e r = (-1) ^ 0 * e r
      rw [Int.pow_zero, Int.one_mul]
  | succ n ih =>
      have hr1 : tableFrom e (r - 1) n = (-1) ^ n * e R := ih (r - 1) (by omega)
      have hr0 : tableFrom e r n = 0 :=
        tableFrom_eq_zero_of_vanishing_above he r n (by omega)
      show tableFrom e r n - tableFrom e (r - 1) n = _
      rw [hr0, hr1, Int.zero_sub, Int.pow_succ, Int.mul_neg_one, Int.neg_mul]

/-- **`r − d > R` cannot be relaxed to `r − d ≥ R`.** Take `R` to be the largest
rung where `e` is non-zero, which is what `R_e` means. Then every cell with
`r − d = R` moves, by exactly `±e R`. The strict inequality is not slack in the
proof; it is the boundary. -/
theorem boundary_can_move {e : ℤ → ℤ} {R : ℤ} (he : ∀ s : ℤ, R < s → e s = 0)
    (r : ℤ) (d : ℕ) (hrd : r - (d : ℤ) = R) (hne : e R ≠ 0) :
    tableFrom e r d ≠ 0 := by
  rw [tableFrom_at_boundary he r d hrd]
  exact Int.mul_ne_zero (Int.pow_ne_zero (by decide)) hne

/-- The same fact said about the two conventions rather than about `e`: at the
boundary the cell genuinely differs. -/
theorem cell_ne_at_boundary {N e : ℤ → ℤ} {R : ℤ} (he : ∀ s : ℤ, R < s → e s = 0)
    (r : ℤ) (d : ℕ) (hrd : r - (d : ℤ) = R) (hne : e R ≠ 0) :
    tableFrom (fun x => N x - e x) r d ≠ tableFrom N r d := by
  rw [tableFrom_sub]
  intro h
  exact boundary_can_move he r d hrd hne (by omega)

/-! ## What the bench measured

Everything below is read directly out of `imported/lattice_mapper/32bit/`.
It is input to a check, and is used in no proof above.

The four dyadic zeros were confirmed by reading
`dyadic_difference_table_32.csv`: over its whole extent (regime ≤ 32,
`delta_1`…`delta_31`) the cells that are exactly zero at depth ≥ 1 are exactly
`(2,1), (4,1), (8,3), (20,6)` and no others. Their window bottoms `r − d` are
`1, 3, 5, 14`.

Excluding 2 and 3 as lattice gives `R_e = 2` (2 in rung `(1,2]`, 3 in rung
`(2,4]`). So the theorem protects `(4,1)`, `(8,3)`, `(20,6)` and does NOT
protect `(2,1)`.

Two measured convention pairs are encoded below. In both, the full-table check
run over every cell of both files found ZERO differing cells with `r − d > R_e`
and a non-empty set of differing cells at `r − d = R_e` exactly. -/

/-- The four exact zeros of the dyadic prime table, `(r, d)`. Same list as
`Zeros.measured_zeros`, `Construction.measured_zeros`, `PairIdentity.zero_cells`;
re-read here from `imported/lattice_mapper/32bit/dyadic_difference_table_32.csv`. -/
def zero_cells : List (ℕ × ℕ) := [(2, 1), (4, 1), (8, 3), (20, 6)]

/-- The window bottoms `r − d` of the four zeros. -/
def zero_window_bottoms : List ℤ := [1, 3, 5, 14]

/-- The window bottoms `r − d` of the four zeros are `1, 3, 5, 14`, computed
rather than transcribed. -/
theorem window_bottoms_correct :
    zero_cells.map (fun c => (c.1 : ℤ) - (c.2 : ℤ)) = zero_window_bottoms := by decide

/-- **Which zeros the theorem protects when 2 and 3 are the excluded primes.**
`R_e = 2`, so `(2,1)` is unprotected and the other three are fixed. This is the
prediction, stated before looking at any perturbed table. -/
theorem protected_at_R_two :
    zero_cells.map (fun c => decide (2 < (c.1 : ℤ) - (c.2 : ℤ)))
      = [false, true, true, true] := by decide

/-- **And when the excess reaches rung 3** — which `silence46` does, since 6
sits in `(4,8]`. Now `(4,1)` falls to the boundary as well. -/
theorem protected_at_R_three :
    zero_cells.map (fun c => decide (3 < (c.1 : ℤ) - (c.2 : ℤ)))
      = [false, false, true, true] := by decide

/-! ### Pair 1 — `silence46`, an excess reaching rung 3

`dyadic_composite_difference_table_32.csv` minus
`dyadic_composite_difference_table_32_silence46.csv`, depth-0 rows at rungs
1…8: `[1,2,2,6,11,25,51,105] − [1,1,1,6,11,25,51,105] = [0,1,1,0,0,0,0,0]`.
The silenced number 4 sits in rung 2, the silenced number 6 in rung 3, so
`R_e = 3` and `e 3 = 1 ≠ 0`. -/

/-- The measured excess for `silence46`: one silenced number in rung 2, one in
rung 3, nothing above. -/
def silence46_excess : ℤ → ℤ := fun s => if s = 2 ∨ s = 3 then 1 else 0

/-- The `silence46` excess is confined to rungs 2 and 3 — the hypothesis
`cell_eq_of_seed_perturbation` needs, at `R_e = 3`. -/
theorem silence46_vanishes_above_three : ∀ s : ℤ, 3 < s → silence46_excess s = 0 := by
  intro s hs
  have h : ¬(s = 2 ∨ s = 3) := by omega
  simp [silence46_excess, h]

/-- And rung 3 genuinely carries excess, so `boundary_can_move` has its
`e R ≠ 0`. -/
theorem silence46_alive_at_three : silence46_excess 3 ≠ 0 := by decide

/-- Cells `(4,1)`, `(8,3)`, `(20,6)` of
`dyadic_composite_difference_table_32.csv`. -/
def measured_composite : List ℤ := [4, 16, 8192]

/-- The same three cells of
`dyadic_composite_difference_table_32_silence46.csv`. -/
def measured_composite_silence46 : List ℤ := [5, 16, 8192]

/-- **The falsifier.** Subtracting `tableFrom silence46_excess` from the three
measured base cells reproduces the three measured silenced cells exactly —
including the one that MOVED. `(4,1)` sits at `r − d = 3 = R_e`, and the shift
`tableFrom e 4 1 = −1` carries 4 to 5, which is what the file says. `(8,3)` and
`(20,6)` clear `R_e` and do not move.

If either deep cell had shifted by so much as one, this would not compile. -/
theorem measured_silence46_matches_shift :
    [4 - tableFrom silence46_excess 4 1,
     16 - tableFrom silence46_excess 8 3,
     8192 - tableFrom silence46_excess 20 6] = measured_composite_silence46 := by
  decide

/-- The two deep cells are protected by the theorem, not by arithmetic luck:
`8 − 3 = 5 > 3` and `20 − 6 = 14 > 3`, so `cell_eq_of_seed_perturbation`
applies and no computation is needed. -/
theorem silence46_deep_cells_fixed (N : ℤ → ℤ) :
    tableFrom (fun x => N x - silence46_excess x) 8 3 = tableFrom N 8 3 ∧
      tableFrom (fun x => N x - silence46_excess x) 20 6 = tableFrom N 20 6 :=
  ⟨cell_eq_of_seed_perturbation silence46_vanishes_above_three 8 3 (by decide),
   cell_eq_of_seed_perturbation silence46_vanishes_above_three 20 6 (by decide)⟩

/-- And `(4,1)` is not protected, for the reason the theorem gives rather than
by inspection: `4 − 1 = 3 = R_e`, so `boundary_can_move` fires. -/
theorem silence46_cell_4_1_moves (N : ℤ → ℤ) :
    tableFrom (fun x => N x - silence46_excess x) 4 1 ≠ tableFrom N 4 1 :=
  cell_ne_at_boundary silence46_vanishes_above_three 4 1 (by decide)
    silence46_alive_at_three

/-! ### Pair 2 — an excess stopping at rung 2, the `R_e = 2` case

`dyadic_composite_difference_table_32.csv` minus
`dyadic_composite_extended_emptied_32.csv`, depth-0 rows at rungs 1…8:
`[1,2,2,6,…] − [0,0,2,6,…] = [1,2,0,0,…]`. So `R_e = 2` — the same `R_e` that
excluding 2 and 3 produces. This is the closest measured analogue of the seed
question, since the un-excluded dyadic PRIME table was deliberately not
imported (`imported/lattice_mapper/README.md`, "What was deliberately NOT
imported").

Predicted: `(2,1)` may move, `(4,1)`, `(8,3)`, `(20,6)` are fixed.
Measured: `(2,1)` moved 1 → 0; the other three are 4, 16, 8192 in both files. -/

/-- The measured excess for the emptied variant: rung 1 loses one, rung 2 loses
two, nothing above. -/
def emptied_excess : ℤ → ℤ := fun s => if s = 1 then 1 else if s = 2 then 2 else 0

/-- The emptied variant's excess is confined to rungs 1 and 2 — `R_e = 2`,
the same profile as excluding the primes 2 and 3. -/
theorem emptied_vanishes_above_two : ∀ s : ℤ, 2 < s → emptied_excess s = 0 := by
  intro s hs
  have h1 : ¬(s = 1) := by omega
  have h2 : ¬(s = 2) := by omega
  simp [emptied_excess, h1, h2]

/-- Cells `(2,1)`, `(4,1)`, `(8,3)`, `(20,6)` of
`dyadic_composite_difference_table_32.csv`. -/
def measured_composite_four : List ℤ := [1, 4, 16, 8192]

/-- The same four cells of `dyadic_composite_extended_emptied_32.csv`. -/
def measured_emptied_four : List ℤ := [0, 4, 16, 8192]

/-- **The second falsifier, at `R_e = 2`.** The three cells the theorem
protects are unmoved in the file, and the one it does not protect — `(2,1)`,
window bottom `1` — moved from 1 to 0, by exactly the predicted shift
`tableFrom e 2 1 = e 2 − e 1 = 1`. -/
theorem measured_emptied_matches_shift :
    [1 - tableFrom emptied_excess 2 1,
     4 - tableFrom emptied_excess 4 1,
     16 - tableFrom emptied_excess 8 3,
     8192 - tableFrom emptied_excess 20 6] = measured_emptied_four := by
  decide

/-- The three protected cells, again by theorem rather than by computation:
`4 − 1 = 3 > 2`, `8 − 3 = 5 > 2`, `20 − 6 = 14 > 2`. -/
theorem emptied_protected_cells_fixed (N : ℤ → ℤ) :
    tableFrom (fun x => N x - emptied_excess x) 4 1 = tableFrom N 4 1 ∧
      tableFrom (fun x => N x - emptied_excess x) 8 3 = tableFrom N 8 3 ∧
        tableFrom (fun x => N x - emptied_excess x) 20 6 = tableFrom N 20 6 :=
  ⟨cell_eq_of_seed_perturbation emptied_vanishes_above_two 4 1 (by decide),
   cell_eq_of_seed_perturbation emptied_vanishes_above_two 8 3 (by decide),
   cell_eq_of_seed_perturbation emptied_vanishes_above_two 20 6 (by decide)⟩

/-! ## What is NOT proved

Nothing above locates a zero, and nothing above says any zero exists. The
statement is entirely negative: a convention change with excess bounded by rung
`R` cannot reach any cell whose window bottom clears `R`. Whether such a cell is
zero is settled by pi, which is exactly the hole `Zeros.lean` records.

Nor does anything above say an unprotected cell must move. `(2,1)` and `(4,1)`
fall to the boundary in the two measured pairs and both do move, but that is
what the files say, not what the theorem says — `boundary_can_move` needs
`e R ≠ 0`, which is itself a measured input.

The two measured pairs are composite-arm tables. The un-excluded dyadic PRIME
table is not present in this repository, so the 2-and-3 exclusion is checked
here at the level of its excess profile (`R_e = 2`) against a measured pair
with the same profile, not against a prime-table pair.
-/

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'SeedPerturbation.tableFrom_zero' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.tableFrom_zero

/-- info: 'SeedPerturbation.tableFrom_sub' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.tableFrom_sub

/-- info: 'SeedPerturbation.tableFrom_eq_zero_of_vanishing_above' depends on axioms: [propext] -/
#guard_msgs in
#print axioms SeedPerturbation.tableFrom_eq_zero_of_vanishing_above

/-- info: 'SeedPerturbation.cell_eq_of_seed_perturbation' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.cell_eq_of_seed_perturbation

/-- info: 'SeedPerturbation.zero_stable_of_seed_perturbation' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.zero_stable_of_seed_perturbation

/-- info: 'SeedPerturbation.zero_iff_of_seed_perturbation' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.zero_iff_of_seed_perturbation

/-- info: 'SeedPerturbation.tableFrom_at_boundary' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.tableFrom_at_boundary

/-- info: 'SeedPerturbation.boundary_can_move' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.boundary_can_move

/-- info: 'SeedPerturbation.cell_ne_at_boundary' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.cell_ne_at_boundary

/-- info: 'SeedPerturbation.window_bottoms_correct' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.window_bottoms_correct

/-- info: 'SeedPerturbation.protected_at_R_two' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.protected_at_R_two

/-- info: 'SeedPerturbation.protected_at_R_three' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.protected_at_R_three

/-- info: 'SeedPerturbation.silence46_vanishes_above_three' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.silence46_vanishes_above_three

/-- info: 'SeedPerturbation.silence46_alive_at_three' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.silence46_alive_at_three

/-- info: 'SeedPerturbation.measured_silence46_matches_shift' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.measured_silence46_matches_shift

/-- info: 'SeedPerturbation.silence46_deep_cells_fixed' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.silence46_deep_cells_fixed

/-- info: 'SeedPerturbation.silence46_cell_4_1_moves' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.silence46_cell_4_1_moves

/-- info: 'SeedPerturbation.emptied_vanishes_above_two' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.emptied_vanishes_above_two

/-- info: 'SeedPerturbation.measured_emptied_matches_shift' does not depend on any axioms -/
#guard_msgs in
#print axioms SeedPerturbation.measured_emptied_matches_shift

/-- info: 'SeedPerturbation.emptied_protected_cells_fixed' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms SeedPerturbation.emptied_protected_cells_fixed

end SeedPerturbation
