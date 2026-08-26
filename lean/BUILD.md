# Building

Standalone Lean 4 project. Requires `elan`, which supplies `lake` and `lean`.

```bash
cd lean
lake exe cache get     # prebuilt Mathlib .olean files (large download)
lake build             # compiles all 14 modules
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

Expected: compiles clean, **8049 jobs**, zero `sorry`, **262 theorems**. A few
unused-variable and unused-simp-argument linter warnings are harmless.

## Mathlib-free core

`Construction.lean` does not `import Mathlib`. It is Lean core only, and that is
a deliberate convention, not an oversight. **Keep it that way when editing, and
extend it to the other integer modules rather than reversing it.**

Why. Every statement in that module is about ℤ and ℕ, so nothing in Mathlib is
needed to *say* it — but importing Mathlib imported Mathlib's assumptions.
Measured both ways (notes entry 59, which has a fifth row, `tableFrom_smul`,
dropped when this table was transcribed):

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

* **`omega` is available in core and costs `[propext, Quot.sound]`. Reach for
  `rfl` or `decide` first.** `Construction` carries no `omega` because it does
  not need one, and keeping it that way is measured, not stylistic: rewriting
  the cast step in `zero_determined_by_row` to `omega` raises three pins to
  `[propext, Quot.sound]` — that theorem, `PairIdentity.tableFrom_add_window`,
  and `SeedPerturbation.tableFrom_eq_zero_of_vanishing_above`, which commit
  `95bb9c1` calls the gating theorem for the seed protections.
  What is definitional there is the cast alone — `((k+1 : ℕ) : ℤ) = (k : ℤ) + 1`
  is `rfl` at no axioms. The step around it,
  `r - ((k+1 : ℕ) : ℤ) = r - 1 - (k : ℤ)`, is **not**: bare `rfl` fails with
  `is not definitionally equal to`, and it closes at `[propext]` via
  `Int.sub_sub` and `Int.add_comm`. `Zeros`, `PairIdentity`, `SeedPerturbation`
  and `Propagation` all use `omega` and already pay `Quot.sound`.
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
`import Mathlib` cannot raise it, and a Mathlib-importing module reads
`Construction`'s theorems at their reduced counts. Six of the 23 modules are now
Mathlib-free, closed transitively: `Construction` (the root), `PairIdentity`,
`SeedPerturbation`, `Zeros`, `Propagation`, `ZeroCells`.
Pins *do* move by inheritance in the improving direction — landing this dropped
`Quot.sound` from `PairIdentity.tableFrom_add_window` — and `#guard_msgs` fails
the build until the pin is updated. That is the check working.

### What can never move

Of the 181 theorems at `Classical.choice`, the ones mentioning ℝ or ℂ can never
drop it: ℝ is constructed with choice in Mathlib. The integer modules have now
moved — `SeedPerturbation` and `PairIdentity` at `95bb9c1`, `Zeros` at `279e40b`
by splitting its 15 Mathlib-dependent theorems into `ZerosStencil` — so the
axiom line *is* the arithmetic/analytic boundary, printed by the compiler rather
than argued in prose.

`Zeros` was expected to need a `Finset.range` fold and a `Nat.factorization`
step first. Splitting instead of rewriting made both unnecessary: the theorems
needing them left with `ZerosStencil`, which keeps Mathlib and keeps
`namespace Zeros`, so no citation moved. Cost of that move, measured after
deleting the olean (`touch` does not force a rebuild — Lake traces content):
8027 jobs / 2.8 s / 5.37 GB peak RSS, down to 3 jobs / 240 ms / 0.68 GB.

## What is in here

23 modules. Every theorem carries a `#guard_msgs`-pinned `#print axioms`,
262 of them, so `lake build` fails the moment a proof starts depending on
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
TwinLattice        a twin pair is a site on the 2·3 lattice; the pocket is 6k
Transform          block G's geometry — z = b^(−s), the two generators, τ
Isogeny            the isogeny acts on the row as block-summation by k
```

The table above describes 14 of the 23 and has not been extended;
`Propagation`, `Nonvanishing`, `MainTerm`, `Expansion`, `Schoenfeld`, `Nyquist`,
`ZeroCells` and `ZerosStencil` are missing from it. `lean/THEOREMS.md` is
generated by `utilities/theorem_index.py` and is the current index; whether this
table should be regenerated from it or replaced by a pointer to it is an open
question.

`lakefile.toml`'s `globs` is an **explicit list, not a wildcard**. A new module
does not build until it is named there.

What is **not** formalised: every numerical value citing a zeta zero, and the
parts of block G that are measurement or literature — G1's Cauchy–Hadamard
radius, G3's Jentzsch, G5's measured migration, G8's RH equivalence, G9 and G10.
Those are observations.

**Block G's geometry is formalised.** `Transform.lean` carries the map
`z = b^(−s)`, the two lattice generators, the functional equation as an
inversion in the circle `|z| = b^(−1/2)`, and G7's modulus. The second
generator — `s ↦ s + 1` giving `z ↦ z/b`, which closes the annulus into
`ℂ* / b^ℤ` — was absent from the record entirely. See notes entry 84.

**The isogeny has an arithmetic shadow.** `Isogeny.lean` proves
`row_k(r) = Σ_{j<k} row_1(k·r + j)` — passing from a ladder to its `k`-th power
sums the row in blocks of `k`. So a base inside an isogeny class carries no
count its generator's row does not already carry, and `Isogeny.rowN_comp` makes
`{2,4,8}` a chain rather than three relations. The general-`k` statement needs
`Finset.sum` and pays `Classical.choice` for it; the concrete `k = 2` and
`k = 3` cases avoid Finset and stay at `[propext, Quot.sound]`, and the two
**measured** rows carry no axioms at all. See notes entry 87.

**Block D — the winding — is now formalised.** D1's floor and ceiling, D2's
smooth term on the floor, D3's amplification inequality and D4's ceiling-base
formula are `Chain.gain_sq_at_floor` through `Chain.ceiling_base`; they also
supply the *attainment* `StmtC2` lacked, which proved containment only. D5 and
D6 are numeric and stay observations. See notes entry 77.
`papers/Euler-Factor-Chain.md` § J states the boundary.
