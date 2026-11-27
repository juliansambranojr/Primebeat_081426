/-
# LittlewoodSharp — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: sharper constants in Littlewood's bound. 2026-11-25.

Goal (b) of the pin "Turing at scale" (`PINS.md`, 2026-11-25): lower the constants of
`TuringLW.littlewood_holds`, `a = (3/2 + 102)/π ≈ 32.95`, `b = (2 + (3/2) log 9 + 500)/π ≈ 160.8`,
to lower the closing height of `Turing.defect_zero_of_signs`.

**The budget first** (`checks/littlewoodsharp/budget.py`, `.out`): with everything else fixed,
the closing height (ideal data) moves most under the zero-count radii and a pointwise
Borel–Carathéodory, which together take the lower side's `a₂` from `≈ 99` to `≈ 27`; then
the `97/t` term of `Turing.theta_sub_le` (crude Stirling, the other worker's goal (a)); the
upper side's `3/2` and `c₀ = 2` move it by a few percent.

**What is proved here.** The lower side `Turing.StmtHorizLower (113/4) 128`
(`LittlewoodSharpHoriz.horizLower_sharp`), from three changes to `TuringLWHoriz`'s route:
* zeros removed in `‖z‖ ≤ 25/32` (was `7/8`): count `≤ (50/9) M` (was `15 M`),
* Borel–Carathéodory at the radius `‖z‖` of each point (`LittlewoodSharpPoint.log_blaschke_ge`),
  whose weight integrates to `(25/8) log 25 − 3 ≤ 7.16` per `M` (uniform at `3/4`: `18`),
* the sharp per-zero integral `∫_{1/2}^{2} log|x − β| ≥ −(3/2)(1 + log(4/3)) ≥ −2` (was `−7/2`)
  and the Blaschke numerator `≤ 25/16` (was `2`).
Then `littlewood_sharp` by `TuringLWSplit.littlewood_of_lower`.

| name | content | status |
|---|---|---|
| `horizLower_sharp` | `Turing.StmtHorizLower (113/4) 128` (in `LittlewoodSharpHoriz`) | proved |
| `littlewood_sharp` | `Turing.StmtLittlewood ((3/2 + 113/4)/π) ((2 + (3/2) log 9 + 128)/π) 2` | proved |

`a = (119/4)/π ≈ 9.47`, `b = (130 + (3/2) log 9)/π ≈ 42.43`. Closing height
(`checks/littlewoodsharp/closing_height_sharp.py`, `.out`): ideal data `T₁ ≈ 1.5·10³`
(was `1.4·10⁴`), Gram data `g_n ≈ 3.2·10³` (was `3.5·10⁴`). With these constants the
`97/t` slope term is the largest left: at `1/t` the ideal height is `≈ 430`, Gram `≈ 1.3·10³`
(`budget.out` § 6).

Open, by size: the `97/t` slope term (goal (a)); the disc bound `84 T` (its `log 84` enters
`b₂` times `a₂`; `≈ 24 T` holds for large `T` but not uniformly from `t = 2`); the upper side
`3/2` (convexity); none of these is touched here.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringLWSplit
import Stage3.LittlewoodSharpHoriz

namespace LittlewoodSharp

/-- **Littlewood's bound on `∫ S`, sharper constants, unconditional.** -/
theorem littlewood_sharp :
    Turing.StmtLittlewood ((3 / 2 + 113 / 4) / Real.pi)
      ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi) 2 :=
  TuringLW.littlewood_of_lower horizLower_sharp (by norm_num)

/-- info: 'LittlewoodSharp.horizLower_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizLower_sharp

/-- info: 'LittlewoodSharp.littlewood_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_sharp

end LittlewoodSharp
