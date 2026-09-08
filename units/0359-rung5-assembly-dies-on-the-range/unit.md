---
id: 0359
date: 2026-09-07
type: decision
title: "The assembly of section 13 dies: the range where members decay is shorter than the threshold the range must start above"
refs: [none]
supersedes: []
follows: 0358
context: seven modules of the averaging route are proved and the circularity unit 0351 found is closed; pricing the assembly before writing its block shows the route fails on a comparison that no free parameter touches
sealed: false
---

**Question.** Step 1 of the loop for the assembly of worksheet section `thirteen` 13. Blocks 13a to 13i are proved, `blocks_proved` 7 of them as Lean modules, with `leaf_open` 1 leaf open. Does the weighted sum over a range actually come out negative, and what range does it need?

**What ran.** No Lean. `run/assembly_price.py` evaluates the two demands on the range against each other over the free parameters, and `run/price.log` is its output. The estimates are the proved blocks read at the working point, not new analysis.

**What it shows.** The route fails, and the failure has no free parameter in it.

Section `eight` 8 selects the target as a zero of largest real part in the box, so every other member has `ε' ≤ ε` and its weighted amplitude carries `exp(2(ε'² − Δ² − ε²)u) ≤ exp(−2Δ²u)` with `u ≈ h/(λπ²)`: every member decays, at a rate set by its own height offset. Summed over `h` that is at most `λπ²/(decay_coeff·Δ²)`, with `decay_coeff` 2. Block 13g frees the members whose phase never turns, `Δ·b ≤ lo` with `lo = λπ³/(lo_coeff·ε')` and `lo_coeff` 8. The rest cost at most that sum each, and the worst case puts all `N` of them just above the boundary, at `Δ = lo/b`. The target gives at least `1` per `h`, so at least `b` over the range. The comparison is

    N · λπ² b²/(2 lo²)  <  b,   i.e.   b < λπ⁴/(`bmax_denom` 32 · N ε'²) =: b_max.

Against that, the range must start above the threshold where the target beats the on-line background and the lost prefactors, `h₀ ≈ 2π²λ log(P)/ε²` from section `twelve` 12. The ratio is

    b_max/h₀ = π²ε²/(`ratio_denom` 64 · N ε'² log P),

and at the target's own `ε' ≈ ε` that is `ratio_const` 0.1542 divided by `N log P`. `λ` cancels: `b_max` and `h₀` are both linear in it, so no window width helps. `ε` cancels. The ratio is under `1` at every setting: `ratio_N1_logP1` 0.1542 at the most favourable point, one member and a background of size `e`, and `ratio_N100_logP10` 0.00015 at a hundred members and a log-background of ten. The range the members allow is shorter than the range the background demands, always.

The mechanism is a gap between the two proved bounds, at the one place they meet. A member at `Δ = lo/b` sits just past block 13g's sign condition, so it is not free. Its decay over the range is `exp(−2lo²/(λπ²b))`, which is near `1` for exactly the `b` that beats the background. And block 13f's geometric bound at that `Δ` is the range itself: the phase advances `π/(2b)` per step, so the bound is the amplitude times `b`, the same order as the target's own contribution. Both bounds are correct and neither is slack; the member simply costs what the target earns. `N` such members cost `N` times it.

The shortfall at the most favourable parameters is a factor `shortfall_best` 6.48, which crude constants could plausibly cover. It does not matter: the shortfall is proportional to `N`, and `N` is the band count at the target's height, at least `band_a` 15 times the log of that height plus `band_b` 73. Sharpening constants moves a factor of order one against a factor that grows with the height. Under `CLAUDE.md` § Rule — a lost factor is a design failure this is design, and it is the third time this rung has died on the same shape: section `nine` 9 on the range against the height, the intermediate shell in unit `unit_shell` 0351, and now the range against its own threshold.

**Decision.** Section 13's head records this, and the seven modules stay. They are not wasted: `WeilPowerSharp`, `WeilPowerPhase`, `WeilPowerSigma`, `WeilPowerGeom`, `WeilPowerGeomGen`, `WeilPowerShell`, `WeilPowerNear`, `WeilPowerClean` and `WeilPowerCount` are stated for an abstract member and an abstract count, and every one of them is a statement about the switched window rather than about the averaging route. The clean-shell pigeonhole and the leaf with its budget are reusable by any route that needs a zero count.

What is not decided here is what replaces it. Three candidates, none priced: widen block 13g's reach, which needs a sign that survives a phase of order the square root of `N log P` rather than a right angle, and pointwise it does not; find a window whose off-axis decay beats `exp(−2Δ²u)` at small `Δ`, since that decay vanishing as `Δ → 0` is what makes the boundary member free to hurt; or drop detection-by-averaging and read the rung's statement off a different vehicle. Pricing those is the next decision unit, and it comes before any more Lean.
