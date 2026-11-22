/-
Construction — the table has no free parameter, so the zeros were not placed.

`Zeros.lean` records that nothing predicts WHERE the four exact zeros are. That
is true and stays true. This file proves the complementary thing, which is what
makes them structural rather than arbitrary:

  given the depth-0 row, EVERY cell is forced.

There is no parameter anywhere in the construction. The recurrence determines
the whole table, the weights are Pascal's and not a design choice, and the
depth-0 row is itself fixed by pi. So a zero is a determined function of pi
alone — nobody put it there, and nobody could have put it somewhere else.

That is the sense in which the zeros are structural: not that their location is
derivable, but that their existence involves no freedom.

**This module does not import Mathlib.** It is Lean core only, and that is
deliberate — see `lean/BUILD.md` § Mathlib-free core. Every statement here is
about ℤ and ℕ, so nothing in Mathlib is needed to say it; importing Mathlib
only imported Mathlib's assumptions. `Classical.choice` and `Quot.sound` both
left the file when the import did. Modules downstream still import Mathlib and
are unaffected: an axiom list is fixed in the proof term at elaboration, so a
later `import Mathlib` cannot raise it.

Two consequences worth knowing before editing:

* `omega` is available in core and costs `[propext, Quot.sound]`. Nothing here
  needs it, and that is worth keeping: adding it back to the cast step in
  `zero_determined_by_row` raises this module's pin and two downstream ones.
  The Nat-to-Int cast itself is definitional — `((k+1 : ℕ) : ℤ) = (k : ℤ) + 1`
  is `rfl` at no axioms. The step around it is not; see the `hc` block below,
  which needs `show` and `Int.sub_sub` and costs `[propext]`.
* Mathlib's generic algebra lemmas (`mul_sub`, `ring`) are stated over general
  rings whose instances are classical, so reaching for one *raises* the axiom
  count. Use core's `Int.` lemmas, or `decide`.
-/

-- Core has no `ℕ`/`ℤ` notation; Mathlib's is what we gave up. `local` keeps
-- these inside this file so downstream modules still get Mathlib's own.
local notation "ℤ" => Int
local notation "ℕ" => Nat

namespace Construction

/-! ## The table -/

/-- The table built from a depth-0 row by repeated backward differencing. -/
def tableFrom (N : ℤ → ℤ) : ℤ → ℕ → ℤ
  | r, 0     => N r
  | r, d + 1 => tableFrom N r d - tableFrom N (r - 1) d

/-- The defining recurrence, as a property a function may or may not have. -/
def IsTableOf (N : ℤ → ℤ) (f : ℤ → ℕ → ℤ) : Prop :=
  (∀ r, f r 0 = N r) ∧ (∀ r d, f r (d + 1) = f r d - f (r - 1) d)

/-- `tableFrom` satisfies its own recurrence. -/
theorem tableFrom_isTableOf (N : ℤ → ℤ) : IsTableOf N (tableFrom N) :=
  ⟨fun _ => rfl, fun _ _ => rfl⟩

/-! ## No freedom -/

/-- **Uniqueness.** Any function satisfying the recurrence with the same depth-0
row IS the table. There is no choice at any cell — fix the row and the entire
table, to every depth, is determined.

This is the whole content. A zero is not a placement; it is a consequence. -/
theorem unique_of_isTableOf {N : ℤ → ℤ} {f : ℤ → ℕ → ℤ} (hf : IsTableOf N f) :
    ∀ r d, f r d = tableFrom N r d := by
  intro r d
  induction d generalizing r with
  | zero => exact hf.1 r
  | succ n ih => rw [hf.2 r n, ih r, ih (r - 1)]; rfl

/-- Two tables over the same row agree everywhere. -/
theorem eq_of_same_row {N : ℤ → ℤ} {f g : ℤ → ℕ → ℤ}
    (hf : IsTableOf N f) (hg : IsTableOf N g) : ∀ r d, f r d = g r d := fun r d => by
  rw [unique_of_isTableOf hf, unique_of_isTableOf hg]

/-- **A zero is determined by the row.** If two counting functions agree on the
window a cell reads, that cell is the same for both — in particular one vanishes
exactly when the other does. Nothing outside the window can move it, and nothing
inside the construction can either. -/
theorem zero_determined_by_row {N M : ℤ → ℤ} (r : ℤ) (d : ℕ)
    (h : ∀ k : ℕ, k ≤ d → N (r - k) = M (r - k)) :
    tableFrom N r d = tableFrom M r d := by
  induction d generalizing r with
  | zero =>
      have h0 := h 0 (Nat.le_refl 0)
      show N r = M r
      rwa [show ((0 : ℕ) : ℤ) = 0 from rfl, Int.sub_zero] at h0
  | succ n ih =>
      have hr : tableFrom N r n = tableFrom M r n :=
        ih r fun k hk => h k (Nat.le_succ_of_le hk)
      have hr1 : tableFrom N (r - 1) n = tableFrom M (r - 1) n := by
        refine ih (r - 1) fun k hk => ?_
        -- the cast step was `omega`; the cast itself is `rfl`, this step is not
        have hc : r - ((k + 1 : ℕ) : ℤ) = r - 1 - (k : ℤ) := by
          show r - ((k : ℤ) + 1) = r - 1 - (k : ℤ)
          rw [Int.sub_sub]
          exact congrArg (r - ·) (Int.add_comm (k : ℤ) 1)
        have hk1 := h (k + 1) (Nat.succ_le_succ hk)
        rwa [hc] at hk1
      show tableFrom N r n - tableFrom N (r - 1) n = _
      rw [hr, hr1]
      rfl

/-! ## The weights are not a choice -/

/-- Differencing is linear, at every depth. The operator carries no parameter to
tune — this is what forces Pascal's weights rather than selecting them. -/
theorem tableFrom_add (N M : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    tableFrom (fun x => N x + M x) r d = tableFrom N r d + tableFrom M r d := by
  induction d generalizing r with
  | zero => rfl
  | succ n ih =>
      show tableFrom _ r n - tableFrom _ (r - 1) n = _
      rw [ih r, ih (r - 1)]
      show _ = tableFrom N r n - tableFrom N (r - 1) n
                 + (tableFrom M r n - tableFrom M (r - 1) n)
      simp [Int.sub_eq_add_neg, Int.neg_add, Int.add_assoc, Int.add_left_comm]

/-- Scalars pass through the table: the table of `c·N` is `c` times the table
of `N`. The other half of linearity, beside `tableFrom_add`. -/
theorem tableFrom_smul (c : ℤ) (N : ℤ → ℤ) (r : ℤ) (d : ℕ) :
    tableFrom (fun x => c * N x) r d = c * tableFrom N r d := by
  induction d generalizing r with
  | zero => rfl
  | succ n ih =>
      show tableFrom _ r n - tableFrom _ (r - 1) n = _
      rw [ih r, ih (r - 1)]
      exact (Int.mul_sub c _ _).symm

/-! ## What this does and does not say

DOES: the table is the unique solution of its recurrence over a given row; a
cell depends only on the `d+1` row entries in its window; the operator is linear
and parameter-free. Fix pi and every cell, including every zero, is forced.

DOES NOT: predict a location. `Zeros.lean` states that hole and it remains open.

Together the two files say the honest thing: the four zeros are neither placed
nor predicted. They are what pi does, read through a construction with no
freedom in it.
-/

/-- The four exact zeros. Determined by pi through a parameter-free
construction; located by nothing. `results/O16_run2.log`. -/
def measured_zeros : List (ℕ × ℕ) := [(2, 1), (4, 1), (8, 3), (20, 6)]

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.

With Mathlib gone, the floor here is `propext` — and `propext` only enters
through `rw` and `simp`. Where a proof is `rfl`, `decide` or bare `induction`,
the list is empty.
-/

/-- info: 'Construction.tableFrom_isTableOf' does not depend on any axioms -/
#guard_msgs in
#print axioms Construction.tableFrom_isTableOf

-- **No axioms at all.** Pure computation — claimed in `papers/Formalization.md` § B4
-- and confirmed here by the compiler.
/-- info: 'Construction.unique_of_isTableOf' does not depend on any axioms -/
#guard_msgs in
#print axioms Construction.unique_of_isTableOf

-- **No axioms at all.** Same as above: the table is unique over its row, with
-- nothing assumed.
/-- info: 'Construction.eq_of_same_row' does not depend on any axioms -/
#guard_msgs in
#print axioms Construction.eq_of_same_row

-- Was `[propext, Quot.sound]` under Mathlib; `Quot.sound` came from `omega`.
/-- info: 'Construction.zero_determined_by_row' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Construction.zero_determined_by_row

/-- info: 'Construction.tableFrom_add' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Construction.tableFrom_add

/-- info: 'Construction.tableFrom_smul' depends on axioms: [propext] -/
#guard_msgs in
#print axioms Construction.tableFrom_smul

end Construction
