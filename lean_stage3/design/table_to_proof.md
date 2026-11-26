# table_to_proof.md — from Julian's table to the proof

Written 2026-11-26 on Julian's word ("Sure design it and then check it against
everything you already tried"). Every name below was opened in the tree this
session. Each line is marked PROVED (a Lean theorem, standard axioms),
MEASURED (a unit, exploratory), or OPEN.

## The chain, in the table's own objects

**T0. The goal is a statement about the table.** PROVED.
`CellResidual.RH_iff_cells : RiemannHypothesis ↔ ∃ C r₀, CellsSqrt C r₀`, and
`OneChain.one_chain` joins it to the spiral link. `CellsSqrt`: every cell's
residual is at most `C · cellSize r d`, the square-root size of its window.

**T1. Depth carries the bound; it does not make it.** PROVED.
`CellResidual.stencilR_abs_le`: if the values a stencil reads shrink by a factor
`t` per step down its window, the cell is at most the top bound times `(1+t)^n`.
`cells_of_schoenfeldWeak` and `schoenfeldWeak_of_cells`: the cells at square-root
size are the bottom row at square-root size. The depth axis transports whatever
the row has; it adds no cancellation of its own (`Euler-Factor-Chain.md` C3).

**T2. The row is carried by its half.** PROVED.
`HalfSieve.resid_step : resid N = resid (√N) − wobble N`. The count at `N` is
fixed by the primes up to `√N` (`SieveExact`, R2, "the half carries the row"); the
residual at `N` is the residual at `√N` less the sieve's wobble, the Möbius-signed
rounding of the primes up to `√N` less its smooth part
(`wobble N = netRounding N − smoothNet N`).

**T3. The halves telescope.** PROVED.
`HalfSieve.resid_of_wobble`, `schoenfeld_of_wobble`: unwinding T2 through
`N, √N, N^{1/4}, …` sums the wobbles, and the sum is dominated by the first, so a
square-root bound on the wobble at every `N` is a square-root bound on the row.

**T4. The whole goal is one line of the sieve.** PROVED as an equivalence.
`HalfSieve.spiralLink_iff_wobble : SpiralLink ↔ WobbleSqrt`, with
`WobbleSqrt := ∃ C N₀, ∀ N ≥ N₀, |wobble N| ≤ C · √N · log N`.
With T0: `RiemannHypothesis ↔ WobbleSqrt`.

**T5. The line.** OPEN.
`WobbleSqrt`: the Möbius-signed roundings of the primes up to `√N`, less their
smooth part, stay within `C · √N · log N` at every `N`.

## What each try touched, and why it did not close T5

| try | where in the chain | what stopped it |
|---|---|---|
| sizes of the roundings (unit 0475, R13 `NoHoles`) | T5 by absolute values | 2^π(√N) roundings, each below one: sizes give N log N, a lost factor |
| the doubling across scales (R15 `Doubling`, unit 0506) | T5 by alternating scales | the induction loses the count of scales; needs the alternating residuals to cancel among themselves |
| the scales N/m (unit 0492) | T5 by adding scales | pieces large and of one sign; the residual is a small difference of them |
| the rounding remembers the primes (unit 0499) | MEASURED inside T5 | neighbouring steps correlate 0.998; the net rounding 7.75 √x against 0.63 for random signs — the cancellation is structured, not random |
| Möbius-signed errors (unit 0504) | MEASURED, T5's shape | 0.25 √N from 10⁴ to 10⁷; no proof that they must |
| Levinson and Conrey floors (units 0551–0564) | outside the chain | count a share of zeros; no bound on a single row |
| no right zeros of V, Weil positivity, rung 5 (units 0573, 0576) | a face of T0 | each equivalent to the goal; none proved |
| the heat flow (units 0577, 0578) | a face of T0 (`Λ = 0`) | the flow's settling is the goal restated |
| the golden step (unit 0579) | none | the zeros' places in the basins are not a rotation |
| the sediment (unit 0583) | beside T2 | see below |

## The one new link

Unit 0583's truncation and T2 use the same scale. The sediment function settles
its band when its sum runs to `√(t/2π)`, the Riemann–Siegel length; the sieve
carries the row at `N` with the primes up to `√N`. Both say the half carries the
whole. In the sieve that is proved (T2); in the truncation it is measured for
`N ≤ 5` and preregistered for `N = 6..12` (`preregs/sediment_bands_v1_20261126.md`,
draft). Whether the two halves are one object is OPEN and is the next thing to
write down: the wobble of T5 as the error of the truncation at its own band.

## The answer

The table reduces the Riemann hypothesis, with every step proved in Lean, to one
line: **`WobbleSqrt`** — the sieve's Möbius-signed rounding over the primes up to
`√N`, less its smooth part, stays within `C · √N · log N`. Nothing tried so far
bounds it. The measurements say it cancels, and that the cancellation is
structured: the rounding remembers the primes before it.
