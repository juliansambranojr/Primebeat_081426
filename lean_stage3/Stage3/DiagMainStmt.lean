/-
# Stage3.DiagMainStmt — the diagonal's main term, little-o form

Unit 0538's decision: PNT+'s `mu_pnt` (`Σ_{n<x} μ(n) = o(x)`, no rate) carries the main term
`ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)`, and Levinson's floor needs only the leading term. This
file holds the two statements the little-o route is built on, so that the restatement
(`DiagonalO`) and the proof of the main term (`DiagMain`) are written side by side.

| name | content | status |
|---|---|---|
| `StmtDiagMainO` | `ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)` uniformly on `Regime κ T` | OPEN (named Prop) |
| `errO` | the little-o scale `(1 + C₁ + C₂)·T` of a weight | def |

Young's Lemma 7 assumes `P(0) = 0` and `0 < θ`; a proof of `StmtDiagMainO` may take both.
-/
import Stage3.Diagonal

namespace DiagMainStmt

open Complex TwistedMoment Diagonal

/-- OPEN, **the diagonal's main term, little-o** (Young's Lemma 7 with `o(1)` for `O(1/L)`):
for every `ε > 0`, from some height on, `‖ζ(1+α+β) S(α,β,0) − c₁(α,β)‖ ≤ ε` on `Regime κ T`. -/
noncomputable
def StmtDiagMainO (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
    ‖riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 -
      c1Y P (Mof T θ) α β‖ ≤ ε

/-- The little-o scale of a weight: `(1 + C₁ + C₂)·T`, `errY` without the `1/L`. -/
noncomputable
def errO {T L : ℝ} (W : Weight T L) : ℝ := (1 + W.C1 + W.C2) * T

end DiagMainStmt
