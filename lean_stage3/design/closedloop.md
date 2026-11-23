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

## J3 The rest of the closed loop, joined — `Stage3/ClosedLoopChain.lean`

Parts I, III, IV, V, VI of the closed loop restated word for word, each with
its join to the table.

- **Part I, the Holy Family.** `J + M = 1`, `M = 2·J` give `J = 1/3`,
  `M = 2/3`, midpoint `1/2`. JOIN: `holyFamily_is_mirror_pair`, `M = 1 − J`:
  the two are a point and its mirror. `holyFamily_pair_area`,
  `b^J·b^M = b`: the area of `MirrorArea.mirror_area`. `holyFamily_force`:
  the restoring force is `5/6` at both.
- **Part III, the doubling.** `Midpoint n = 2^n − 1/2`, offset `1/2` at every
  doubling. JOIN: `row_at_midpoint`: for `n ≥ 2` the count of primes up to
  `Midpoint n` is `π(2^n)`, the table's row.
- **Parts IV, V.** `boundary_is_two`, `midpoint_base_is_unique`,
  `sextic_lattice`, as in the closed loop.
- **Part VI, the Prime Beat.** JOIN: `primeBeatTerm_eq_im`: a prime's term is
  minus the imaginary part of its step `p^(−(1/2+it))`. `generalized_weight`:
  its weight at `σ` is the handshake's `primeWeight`.

With J1 and J2 every Part of the closed loop from I to XI has its statements
in Stage 3 and a theorem tying it to the table, its mirror, or the zeros.

## J4 One chain — `Stage3/OneChain.lean`

The capstone. `SpiralLink` is tied to the tree's main theorems:

- `one_chain`: RH ↔ `SpiralLink` ↔ `OneAtEachHeight` ↔ the force at rest at
  every zero ↔ every cell of every dyadic ladder at square-root size
  (`CellResidual.RH_iff_cells`).
- `table_of_spiralLink`: the link gives the integer table's cells at
  square-root size (`table_cell_resid`).
- `spiralLink_of_finite`, `spiralLink_of_attained`: the count's ladder bound
  gives the link in the two closed cases of joint 10.
- `spiralLink_of_attained_psi`, `spiralLink_of_finite_accumulation`: on ψ.
- `no_exposed_zero`: `CountEuler.euler_exposed_false`.

Its pins read through the explicit formula at every height, the zero-density
bound, the filters and the count's modes.

## J5 The band and the strip — `Stage3/BandJoin.lean`

`lean/DeepZeroBand.lean` (toolchain v4.28.0, composed by statement) sends a
cell's share `x` to `b^(−x)`: share `0`, the deep zero, on the outer circle;
share `1` on the inner; the prime and composite shares of a cell multiplying
to `b^(−1)`; the middle circle at share one half. Its header says nothing
there identifies a share with the real part of a zero.

The join. `bandR x = 2^(−x)`. `‖2^(−ρ)‖ = bandR (Re ρ)`. So the one map
carries a share and the real part of a zero alike:

- `bandR_zero`, `bandR_one`, `bandR_mirror`, `bandR_in_band`,
  `bandR_middle_iff`, `share_pair`: the band's statements at base `2`.
- `zero_in_band`: every nontrivial zero lands strictly between the circles.
- `zero_pair`: a zero and its mirror multiply to one half, as the two shares
  of a cell do.
- `zero_middle_iff`, `spiralLink_iff_middle`: `SpiralLink` exactly when every
  zero is on the middle circle.

The share of a cell and the real part of a zero are still two numbers. The
join is that the band, its mirror and its middle are the same for both.

## J6 The table inside out — `Stage3/ShareLink.lean`

Julian, 2026-11-23: flip the table inside out and it becomes a line, half
prime table and half composite, meeting in the middle. His paper *Silenced
Difference Tables and the Prime-Composite Butterfly* (`lean_primebeat/notebook`)
holds the partition identity and the regime that is neither prime nor composite.

A cell's total `T` splits by adding, `P + C = T`, and by multiplying:
`‖T^ρ‖ = T^β`, `‖T^(mirror ρ)‖ = T^(1−β)`, product `T`
(`SpiralLink.mirror_pair_area`). On the multiplying scale the share of a mode
is `logb T ‖T^ρ‖ = β`. This is the identification J5 left open: the real part
of a zero is a share of the total.

- `mode_size`, `share_is_re`, `pair_shares_add`, `add_shares_add`.
- `meet_iff`, `meet_sqrt_iff`: the pair is the same size exactly at one half,
  where each is `√T`.
- `swap_flips_residual`: the table's swap changes the sign of the residual and
  moves no mode.
- `spiralLink_iff_meet`.

The need, in this form: the zeros' mirror is the table's swap. The swap fixes
every mode; the zeros' mirror keeps the height and reflects the real part. On
the adding side the split is uneven (the prime share of a rung is near
`1/(r·log 2)`). Nothing here forces the multiplying split to be even.

**Not here.** `SpiralLink` with no hypothesis.
