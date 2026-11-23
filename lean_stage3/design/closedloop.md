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

## J2 The spiral link, stated — `Stage3/SpiralLink.lean`

Julian's paper, §6.3: "the spiral can only converge at σ = 1/2". The walk
closing is a zero of zeta. The sentence, in Lean:

    SpiralLink : ∀ ρ : NontrivialZeros, isHermitianHandshake (Re ρ)

and Julian's other form of it, "there is just one zero":

    OneAtEachHeight : ∀ ρ ρ' : NontrivialZeros, Im ρ = Im ρ' → ρ = ρ'

The mirror of a zero, `mirrorZ ρ = 1 − conj ρ`, is a zero (the functional
equation, `riemannZeta_one_sub`, and `WeilOnLine.conj_mem`), at the same
height, with real part `1 − Re ρ`. `mirrorZ_eq_iff`: it is `ρ` itself exactly
when `Re ρ = 1/2`. `mirror_pair_area`: the two modes' sizes multiply to the
base. `off_line_is_two`: an off-line zero has a different zero at its own
height, and the handshake fails at both.

- `rh_iff_spiralLink`, `rh_iff_one_at_each_height`, `spiralLink_iff_one`.

**Not here.** A proof of `SpiralLink` or `OneAtEachHeight`. Each is RH in
these terms. The paper's reason, that the integers force the offset `0.5` at
every doubling (`ignition_energy_is_half`), is not yet a Lean argument that
reaches the zeros.
