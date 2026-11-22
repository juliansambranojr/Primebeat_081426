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

## How Stage 3 uses it

`Bridge.StmtWeilBridge` is the bridge as a statement in Mathlib-only
vocabulary, and `Bridge.stmtWeilBridge_holds` proves it. Stage 3 has the same
`def` (`lean_stage3/Stage3/WeilBridgeLeaf.lean`, welded), proves the zero-set
lemma `zeroForm_eq_strip`, and concludes
`zeroForm_eq_primeSide : StmtWeilBridge → IsTest L G → zeroForm G = primeSideM (kOfM G)`.
The kernel checks each tree; the join is the text of the statement.
