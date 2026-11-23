# The closed loop joined to Stage 3

Read first after any compaction. 2026-11-23.

Julian's closed loop is `lean_primebeat/PrimeBeat/primebeat_closed_loop.lean`
(toolchain v4.28.0, no `sorry`). Its Part VII defines the restoring force
`|2.5 − 5·(1/2 + ε)|`, `ε = σ − 1/2`; Part VIII the Hermitian handshake
`p^(−σ) = p^(−(1−σ))` at every prime `p > 3`; Part XI proves
`structural_contradiction`: for `σ ≠ 1/2` the force is nonzero and the
handshake fails. Those are statements about a real number `σ`.

Stage 3 has the same two objects on the table's modes:
`StencilWeil.restoringForce b ρ = 2·|Re ρ − 1/2|·log b`, and the two sides
`‖b^ρ‖`, `‖b^(1−ρ)‖` of `MirrorArea`.

## J1 The join — `Stage3/ClosedLoopJoin.lean`

The two packages are separate, so the closed loop's four definitions are
restated word for word.

- `force_eq`: the closed loop's force is `5·|σ − 1/2|`.
- `force_join`: for `1 < b`, `StencilWeil.restoringForce b ρ
  = (2·log b/5)·restoringForce (Re ρ)`. One force.
- `handshake_iff_sides`: the handshake at `Re ρ` holds exactly when at every
  prime `p > 3` the mode `p^ρ` and its mirror `p^(1−ρ)` have the same size.
- `handshake_iff_half`, `structural_contradiction`: as in the closed loop.
- `off_line_zero`: a nontrivial zero off the line has nonzero force, a failed
  handshake, nonzero mirror imbalance at every base, and one side longer than
  `√b`.
- `rh_iff_force_zero`, `rh_iff_handshake`: RH is the force at rest, and the
  handshake holding, at every nontrivial zero.

**Not here.** A statement that the force is zero or the handshake holds at a
zero of zeta. By the last two theorems that is RH in these terms.
