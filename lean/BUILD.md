# Building the Euler Factor Chain proof

Standalone Lean 4 project. Requires `elan` (which supplies `lake` and `lean`).

```bash
cd lean
lake update            # resolve Mathlib v4.28.0 into .lake/packages
lake exe cache get     # pull prebuilt Mathlib .olean files (large download)
lake build             # compile EulerFactorChain.lean
```

`lean-toolchain` pins `leanprover/lean4:v4.28.0`. This matters: a newer
toolchain produces an `incompatible header` error against a v4.28.0 Mathlib
build. `elan` reads the pin automatically when run from this directory.

Expected result: compiles clean, zero `sorry`, six theorems. Two
unused-simp-argument linter warnings are harmless.

What is proved is the algebraic core of `papers/Euler-Factor-Chain.md` —
statements A1, B2a, B2b and B4. The gain bound (C2), the winding (D) and the
transform results (G) are not in here; the numerical values in that document
are observations, not theorems, and are not formalisable.
