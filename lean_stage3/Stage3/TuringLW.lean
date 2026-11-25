/-
# TuringLW — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's pieces assembled. 2026-11-25.

Littlewood's bound on `∫ S`, with explicit constants and no open hypothesis:
`TuringLWSplit.littlewood_of_lower` (the split and the oscillation proved) with
`TuringLWHoriz.horizLower_holds` (the lower horizontal bound, `a₂ = 102`, `b₂ = 500`).

| name | content | status |
|---|---|---|
| `littlewood_holds` | `Turing.StmtLittlewood ((3/2 + 102)/π) ((2 + (3/2) log 9 + 500)/π) 2` | proved |

With it, `Turing.defect_zero_of_signs` needs only the sign data `Turing.StmtSignData`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringLWSplit
import Stage3.TuringLWHoriz

namespace TuringLW

/-- **Littlewood's bound on `∫ S`, unconditional.** -/
theorem littlewood_holds :
    Turing.StmtLittlewood ((3 / 2 + 102) / Real.pi)
      ((2 + (3 / 2) * Real.log 9 + 500) / Real.pi) 2 :=
  littlewood_of_lower horizLower_holds (by norm_num)

/-- info: 'TuringLW.littlewood_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms littlewood_holds

end TuringLW
