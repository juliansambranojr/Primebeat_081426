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

Expected: compiles clean, **8037 jobs**, zero `sorry`, **111 theorems**. Two
unused-simp-argument linter warnings are harmless.

## What is in here

Eleven modules. Every theorem carries a `#guard_msgs`-pinned `#print axioms`,
111 of them, so `lake build` fails the moment a proof starts depending on
something new. That is the regression check, and it is why the build is worth
protecting from `lake update`.

```text
EulerFactorChain   the algebraic core against Mathlib — A1, A2, A3, B2a, B2b, B4, C1
Chain              the paper's arrows as implications; A1, A2, A3, B4 and C1 are
                   discharged, so A4, B5, C2 and C3 are unconditional
Construction       the table is the unique solution of its recurrence — NO AXIOMS
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
