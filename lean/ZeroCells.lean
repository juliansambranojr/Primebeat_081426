/-
ZeroCells — the four zeros are one object with four names, and the
kernel now says so.

`notes/lab_notebook_2.md` entry 78 closed the def-citation hazard at
its most-cited instance: `Zeros.measured_zeros_all_vanish` derives the
vanishing of all four cells from `pi(2^n)` at zero axioms, so a
citation to it is a citation to a proof. That entry recorded what it
did NOT close — three further transcriptions of the same list, each
hand-typed, each with a docstring asserting it is "the same list":

```text
Construction.measured_zeros      Construction.lean:145
SeedPerturbation.zero_cells      SeedPerturbation.lean:214
PairIdentity.zero_cells          PairIdentity.lean:304
```

The hazard is the one `CLAUDE.md` names: `utilities/check_refs.py`
resolves a `def` and a `theorem` identically, so a citation to any of
those three is indistinguishable from a citation to a result — and
their agreement rested on three people typing the same four pairs.

This module removes that. Each list is proved EQUAL to the computed
one, and each therefore inherits `measured_zeros_all_vanish` rather
than restating it. The equalities are `rfl`, which is the point: they
cost nothing, and the moment anyone edits one of the four transcribed
lists the build stops. Three independent hand-typed claims become one
object with four names, checked.

WHAT THIS DOES NOT DO, restated from entry 78 because the distinction
is the whole discipline: the zeros' VANISHING is derived from `pi` by
the kernel. Their LOCATION is not. Nothing here predicts why 8 and 20
and no other cell below `r = 92`.

Companion to notes entries 60, 78.
-/
import Zeros
import SeedPerturbation
import PairIdentity

namespace ZeroCells

/-- **The construction module's list is the computed one.** `rfl`, and
that is what makes it a check: edit either list and this stops
compiling. -/
theorem construction_eq :
    Construction.measured_zeros = Zeros.measured_zeros := rfl

/-- **The seed-perturbation module's list is the computed one.** It was
re-read independently from
`imported/lattice_mapper/32bit/dyadic_difference_table_32.csv`, so this
equality is also a statement that the imported table and `pi2n_cache`
agree at those four cells. -/
theorem seedPerturbation_eq :
    SeedPerturbation.zero_cells = Zeros.measured_zeros := rfl

/-- **The pair-identity module's list is the computed one.** -/
theorem pairIdentity_eq :
    PairIdentity.zero_cells = Zeros.measured_zeros := rfl

/-- **Every cell `Construction.measured_zeros` names vanishes** — now
derived, not transcribed. -/
theorem construction_all_vanish :
    ∀ c ∈ Construction.measured_zeros,
      Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 := by
  rw [construction_eq]; exact Zeros.measured_zeros_all_vanish

/-- **Every cell `SeedPerturbation.zero_cells` names vanishes.** -/
theorem seedPerturbation_all_vanish :
    ∀ c ∈ SeedPerturbation.zero_cells,
      Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 := by
  rw [seedPerturbation_eq]; exact Zeros.measured_zeros_all_vanish

/-- **Every cell `PairIdentity.zero_cells` names vanishes.** -/
theorem pairIdentity_all_vanish :
    ∀ c ∈ PairIdentity.zero_cells,
      Construction.tableFrom Zeros.dyadicRow (c.1 : ℤ) c.2 = 0 := by
  rw [pairIdentity_eq]; exact Zeros.measured_zeros_all_vanish

/-- **All four names, one length.** The "exactly four" of the papers is
now a property of a single object rather than of four lists that happen
to agree. -/
theorem all_four_have_length_four :
    Construction.measured_zeros.length = 4 ∧
    SeedPerturbation.zero_cells.length = 4 ∧
    PairIdentity.zero_cells.length = 4 ∧
    Zeros.measured_zeros.length = 4 := by
  refine ⟨rfl, rfl, rfl, rfl⟩

end ZeroCells

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'ZeroCells.construction_eq' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.construction_eq

/-- info: 'ZeroCells.seedPerturbation_eq' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.seedPerturbation_eq

/-- info: 'ZeroCells.pairIdentity_eq' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.pairIdentity_eq

/-- info: 'ZeroCells.construction_all_vanish' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.construction_all_vanish

/-- info: 'ZeroCells.seedPerturbation_all_vanish' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.seedPerturbation_all_vanish

/-- info: 'ZeroCells.pairIdentity_all_vanish' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.pairIdentity_all_vanish

/-- info: 'ZeroCells.all_four_have_length_four' does not depend on any axioms -/
#guard_msgs in
#print axioms ZeroCells.all_four_have_length_four
