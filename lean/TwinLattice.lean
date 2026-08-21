/-
TwinLattice — a twin pair is a lattice site, not a coincidence of spacing.

Every twin pair above 3 is `(6k − 1, 6k + 1)`. The single integer between them
is `6k`. So a twin pair is not two primes that happen to sit two apart: it is a
site on the `2·3` lattice with primes on both shoulders, and counting twins is
counting doubly-flanked lattice sites.

WHY THIS IS IN THIS TREE. The `2·3` lattice is already load-bearing here in two
places that were never connected to each other:

  * `CONTEXT.md` § Current state of the world, O19/O20 — the deep zero `(8,3)`
    lands at Connes' `λ = 4`, whose window holds exactly `{2,3}`, "the mod-6
    lattice, which is the workbook's own reason for that zero".
  * `CONTEXT.md` § `imported/lattice_mapper/` — those tables are built with
    "2 and 3 excluded as lattice rather than counted as primes". That
    convention IS the mod-6 lattice.

WHAT IS PROVED HERE. Only the lattice fact. It is the load-bearing one: if it
failed, the reading above would be a picture rather than a structure.

WHAT IS NOT PROVED, AND IS NOT ATTEMPTED. That the lattice explains anything
about where twins are, or how many there are. The three-way occupancy split of
the lattice — sites flanked on both sides, one side, neither — is not here, and
neither is the character reading of the two arms. Each is a separate step that
can fail on its own. See notes entry 81.

Mathlib has nothing on twin primes; this reproves nothing.
-/
import Mathlib

namespace TwinLattice

/-- **The lattice.** Every twin pair above 3 has its lower member at `6k − 1`.

`3 < p` is not decoration: `(3,5)` is the one exception, and
`three_five_exceptional` below exhibits it rather than leaving it implied. -/
theorem twin_lower_mod_six {p : ℕ} (hp : p.Prime) (hp2 : (p + 2).Prime)
    (h3 : 3 < p) : p % 6 = 5 := by
  have h2 : ¬ (2 ∣ p) := by
    intro h; rcases hp.eq_one_or_self_of_dvd 2 h with h' | h' <;> omega
  have h3' : ¬ (3 ∣ p) := by
    intro h; rcases hp.eq_one_or_self_of_dvd 3 h with h' | h' <;> omega
  have hmod : p % 6 = 1 ∨ p % 6 = 5 := by omega
  rcases hmod with h | h
  · exfalso
    -- `p ≡ 1 (mod 6)` forces `3 ∣ p + 2`, and `p + 2 > 5`, so it is composite
    have hdvd : 3 ∣ (p + 2) := by omega
    rcases hp2.eq_one_or_self_of_dvd 3 hdvd with h' | h' <;> omega
  · exact h

/-- **The pocket.** The single integer between a twin pair is a multiple of 6.
That is the site; the pair is what is attached to it. -/
theorem twin_pocket {p : ℕ} (hp : p.Prime) (hp2 : (p + 2).Prime) (h3 : 3 < p) :
    (p + 1) % 6 = 0 := by
  have := twin_lower_mod_six hp hp2 h3
  omega

/-- **`(3,5)` is the exception, exhibited rather than assumed.** Its pocket is 4,
which is not on the lattice. It is also the first twin pair, so the lattice
reading begins at `(5,7)`.

Its axiom list is the full three, and the cost is entirely Mathlib's: even
`Nat.prime_three` carries `Classical.choice`, and `decide` on `Nat.Prime` routes
through a classical decidability instance. The arithmetic half, `(3+1) % 6 ≠ 0`,
is axiom-free on its own. Pinned as it is rather than worked around, because the
honest list says where the cost comes from. -/
theorem three_five_exceptional :
    (3 : ℕ).Prime ∧ (5 : ℕ).Prime ∧ (3 + 1) % 6 ≠ 0 := by
  refine ⟨by decide, by decide, by decide⟩

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block pins one result's exact axiom list; if a proof starts depending on
something new the docstring stops matching and **`lake build` fails**.

The two lattice theorems carry no `Classical.choice` — they are ℕ-valued and
close through `omega`, which costs `Quot.sound` and nothing more, even with
Mathlib imported. The exception theorem does carry it, and only because
Mathlib's `Nat.prime_three` does. `lean/BUILD.md` § Mathlib-free core has why that distinction
is the one worth watching.
-/

/-- info: 'TwinLattice.twin_lower_mod_six' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms TwinLattice.twin_lower_mod_six

/-- info: 'TwinLattice.twin_pocket' depends on axioms: [propext, Quot.sound] -/
#guard_msgs in
#print axioms TwinLattice.twin_pocket

-- Mathlib's primality, not this file's argument. See the docstring.
/-- info: 'TwinLattice.three_five_exceptional' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms TwinLattice.three_five_exceptional

end TwinLattice
