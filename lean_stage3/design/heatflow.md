# heatflow.md — the basins settle: the de Bruijn–Newman flow

Written 2026-11-26 on Julian's word ("Yes please"). Unit 0577 records why.
Read first after any compaction; do not re-derive what is here. On paper, here,
unchecked by anyone else. No Lean target is built yet.

## Julian's picture, verbatim

Julian, 2026-11-26: "If the basins couple, then as they couple, the energy
doesn't move from basin to basin. At some point, previous basins have to
calcify, but the surface of the basin will always be at the same height. So
what if it's inevitable for every zero to be half on the line, because in the
end it takes moving through each basin to settle into the half."

## What the picture already matches in the tree

- **The surface is at one half.** The functional equation `Λ(s) = Λ(1 − s)`;
  `Re s = 1/2` is the line the reflection fixes, and an off-line zero comes with
  its mirror.
- **No net transfer between basins.** Littlewood's bound on `∫S`,
  `LittlewoodSharp.littlewood_sharp`; the local anti-correlation measured in
  unit 0565.
- **Calcified basins.** `TuringRun.rh_up_to`: the defect is zero up to
  `219313/500`, fixed for good.
- **Moving sediment.** The Riemann–Siegel sum at height `t` runs over
  `n ≤ √(t/2π)`; a term enters at each `t = 2πn²`.

## The step that changes

The zeros of `ζ` do not move with the height. Height is a position. A process in
which the basins settle needs a parameter that is a clock.

## The clock: de Bruijn–Newman

`H_λ(z) = ∫₀^∞ e^{λu²} Φ(u) cos(zu) du`, `Φ` the classical kernel with
`H_0(z) = Ξ(z)/8` (normalisation to be read from the source before use). The
zeros of `H_λ` are all real exactly when `λ ≥ Λ`. In the picture: `Λ` is the
time at which every basin has settled, and RH is `Λ ≤ 0`, the basins settled
already at time zero.

Known, from the search of 2026-11-26 (sources to be opened before any Lean):
- de Bruijn 1950: `Λ ≤ 1/2`; Ki, Kim and Lee: `Λ < 1/2`.
- Polymath 15, 2019: `Λ ≤ 0.22`. Platt and Trudgian: `Λ ≤ 0.2`, using RH
  verified to a large height.
- Rodgers and Tao, 2018: `Λ ≥ 0` (Newman's conjecture). So RH is `Λ = 0`.
- Preprints of 2026 claim smaller upper bounds; none is refereed.

## Blocks

### H1 The measurement — OPEN
Zeros of `H_λ` for `λ` from `−0.2` to `0.2` at heights up to the point run's
`219313/500`: their distance from the real axis and from each other as `λ`
moves. A unit, exploratory.

### H2 de Bruijn's theorem in Lean — OPEN
Every zero of `H_λ` is real for `λ ≥ 1/2`. Unconditional; not in Mathlib or
PNT+ by the audit of 2026-11-26 (to be rechecked by name before building).

### H3 An adversary on H1 and H2 — OPEN
Before any Lean: what each block adds toward `Λ ≤ 0`, and whether the step from
a bound `Λ ≤ c` with `c > 0` toward `c = 0` has a route weaker than RH.
