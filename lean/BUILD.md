# Building

Standalone Lean 4 project. Requires `elan`, which supplies `lake` and `lean`.

```bash
cd lean
lake exe cache get     # prebuilt Mathlib .olean files (large download)
lake build             # compiles all 11 modules
```

`lean-toolchain` pins `leanprover/lean4:v4.28.0`, and `elan` reads the pin
automatically when run from this directory. The pin matters: a newer toolchain
gives `incompatible header` against a v4.28.0 Mathlib build. `elan` defaults to
4.33, so running from the repo root instead of `lean/` will fail this way.

**Do not run `lake update` casually.** Four dependencies in `lake-manifest.json`
track `main` rather than a tag — `plausible`, `LeanSearchClient`, `importGraph`,
`aesop`. `lake update` re-resolves them to whatever `main` is that day, and the
build is the regression check for every theorem here. Use `lake exe cache get`
on a fresh clone; reach for `update` only deliberately.

Expected: compiles clean, **8037 jobs**, zero `sorry`, **119 theorems**. Two
unused-simp-argument linter warnings are harmless.

## Mathlib-free core

`Construction.lean` does not `import Mathlib`. It is Lean core only, and that is
a deliberate convention, not an oversight. **Keep it that way when editing, and
extend it to the other integer modules rather than reversing it.**

Why. Every statement in that module is about ℤ and ℕ, so nothing in Mathlib is
needed to *say* it — but importing Mathlib imported Mathlib's assumptions.
Measured on the same five theorems both ways (notes entry 59):

```text
                                  with Mathlib                      core only
tableFrom_add          [propext, Quot.sound]                        [propext]
zero_determined_by_row [propext, Quot.sound]                        [propext]
tableFrom_zero         [propext]                                    none
vanishing_above        [propext, Classical.choice, Quot.sound]      [propext]
```

`Classical.choice` came from Mathlib's generic ring and order instances.
`Quot.sound` came from `omega`, which was only ever reached for Nat-to-Int casts
that are definitional.

### Rules when editing a Mathlib-free module

* **`omega` is unavailable, and would cost `Quot.sound` if it were.** The casts
  it was used for close by `rfl`: `r - ((k+1 : ℕ) : ℤ) = r - 1 - (k : ℤ)` is
  definitional, because the Nat-to-Int cast is proved by `rfl` in core.
* **A named Mathlib lemma can be worse than a tactic.** Replacing `ring` with
  `mul_sub` in `tableFrom_smul` *raised* the axiom count to include
  `Classical.choice`, because `mul_sub` is stated over a general ring whose
  instances are classical. Core's `Int.mul_sub` does not. Reach for `Int.`
  lemmas, `decide`, or `rfl`.
* **Cost table**, measured in core: `rfl` / `decide` / `induction` / casts cost
  nothing; `simp` and named core `Int` lemmas cost `[propext]`; `omega` costs
  `[propext, Quot.sound]`.
* **Declare `ℕ`/`ℤ` notation `local`.** Core has none. Unqualified, it breaks
  every downstream import with `environment already contains 'termℤ' from
  Mathlib.Data.Int.Notation`.

### Downstream is unaffected

An axiom list is fixed in the proof term at elaboration, so a later
`import Mathlib` cannot raise it. `Zeros`, `PairIdentity` and `SeedPerturbation`
still import Mathlib and read `Construction`'s theorems at their reduced counts.
Pins *do* move by inheritance in the improving direction — landing this dropped
`Quot.sound` from `PairIdentity.tableFrom_add_window` — and `#guard_msgs` fails
the build until the pin is updated. That is the check working.

### What can never move

Of the 84 theorems at `Classical.choice`, the ones mentioning ℝ or ℂ can never
drop it: ℝ is constructed with choice in Mathlib. So once the integer modules
move, the axiom line *is* the arithmetic/analytic boundary, printed by the
compiler rather than argued in prose. Still on Mathlib and portable:
`SeedPerturbation` (uses no Mathlib surface at all) and the ℤ half of
`PairIdentity`. `Zeros` needs a `Finset.range` fold and one `Nat.factorization`
step first.

## What is in here

Eleven modules. Every theorem carries a `#guard_msgs`-pinned `#print axioms`,
119 of them, so `lake build` fails the moment a proof starts depending on
something new. That is the regression check, and it is why the build is worth
protecting from `lake update`.

```text
EulerFactorChain   the algebraic core against Mathlib — A1, A2, A3, B2a, B2b, B4, C1
Chain              the paper's arrows as implications; A1, A2, A3, B4 and C1 are
                   discharged, so A4, B5, C2 and C3 are unconditional
Construction       the table is the unique solution of its recurrence — NO MATHLIB
Zeros              a zero is a repeat; window exclusivity; which ladders meet
PairIdentity       prime + composite = (b−1)^(d+1)·b^(r−1−d), and base two
SeedPerturbation   a convention change cannot reach a cell with r − d > R_e
Superposition      the depth gain extends from one mode to a finite sum
Covering           contribution is Diophantine, not a size condition
Crossover          two geometric families cross at most once
GeneratorPeak      no power-law tradeoff of that form has an interior peak
Measured           the numbers, each beside what a theorem predicts
```

What is **not** formalised: the winding (block D), the transform radius results
(block G), and every numerical value citing a zeta zero. Those are observations.
`papers/Euler-Factor-Chain.md` § J states the boundary.
