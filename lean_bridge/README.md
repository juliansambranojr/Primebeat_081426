# lean_bridge — the third tree

One job: give Stage 3's Weil form a prime side, with the kernel checking the
join to the explicit formula.

`lean_stage3/` is on Lean v4.32.2 with PrimeNumberTheoremAnd, where the
explicit formula for compactly supported test functions is upstream with two
sorries. `zeta23` (`anthropics/formal-math`, Apache-2.0) proves Weil's explicit
formula with no sorry on Lean v4.33.0-rc2 over Mathlib alone. This tree is on
zeta23's toolchain, requires it at a pinned commit, and proves

    Bridge.weil_bridge : IsTest L G →
      the zero side is summable, and
      Σ_ρ mult(ρ) · laplace G (−ρ) · laplace G (−(1 − ρ)) = primeSide (kOf G)

over the nontrivial zeros of Mathlib's `riemannZeta`.

## Conventions

- Stage 3's: every pinned theorem carries `#guard_msgs` on `#print axioms`;
  no `sorry`.
- `laplace` and `IsTest` are copied from `lean_stage3/Stage3/WeilDetect.lean`
  character for character. `utilities/check_weld.py` fails if they drift.
  Composition with Stage 3 is by statement identity only.
- No code is copied from zeta23; it is a Lake dependency. The pin is the
  `rev` in `lakefile.toml`, and `lake-manifest.json` records the rest.
- Do not run `lake update` here once the manifest is committed.

## Building

    cd lean_bridge && lake exe cache get && lake build

The first build compiles the part of zeta23 the explicit formula depends on
(57 modules of its 316).

## What Stage 3 still owes

The lemma that upstream's `riemannZeta.zeroes_sum` with `riemannZeta.order`
is the sum over `{ρ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1}` with
multiplicity `(analyticOrderAt riemannZeta ρ).toNat`. Until then the bridge
is a theorem about the same form written over Mathlib's zero set.
