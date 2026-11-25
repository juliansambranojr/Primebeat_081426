/-
# Lemma3 — block S12 of `lean_stage3/design/stencil.md`: Young's Lemma 3 with o(T) error, unconditional. 2026-11-25.

Young's twisted moment (arXiv 1002.4403, Lemma 3), up to its remainder `Ires`, with error
`ε·errO W` from some height on, for every polynomial with `P(0) = 0`, every length exponent
`0 < θ < 1/2`, every `R`, and Lemma 6's range with constant `κ > 0`, over the windows bounded
to every order (`WeightAll`).

| name | content | status |
|---|---|---|
| `lemma3_resO_holds` | `StmtLemma3resO P θ R κ` | proved |

It composes `Stirling.lemma3_resO_of_mainO'` (the twisted moment from the main term) with
`Arith.stmtDiagMainO_holds'` (the main term, with the six arithmetic facts proved).

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingX
import Stage3.Arith

namespace Lemma3

open TwistedMoment DiagonalO

/-- **Young's Lemma 3 at o(T), unconditional.** -/
theorem lemma3_resO_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) : StmtLemma3resO P θ R κ :=
  Stirling.lemma3_resO_of_mainO' P hθ R hκ (Arith.stmtDiagMainO_holds' P hP0 hθ0 hθ R hκ)

/-- info: 'Lemma3.lemma3_resO_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_holds

end Lemma3
