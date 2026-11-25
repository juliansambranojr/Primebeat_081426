/-
# Stage3.SdiagLead — block S12 of `lean_stage3/design/stencil.md`: `StmtSdiagLead` and `StmtDiagMainO`, from six arithmetic facts. 2026-11-25.

Target: `DiagMain.StmtSdiagLead P θ R κ`, `S(α,β,0) = I(α,β)/log M + o(1/L)` on `Regime κ T`
(Young's Lemma 7), and through `DiagMain.stmtDiagMainO_of_lead` the main term
`ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)` (`StmtDiagMainO`).

All analysis is proved. What remains open is `StmtArith`, six statements about the arithmetic
functions `μ²`, `σ(d) = d/φ(d)` and `⟨d⟩ = {m : primes of m ⊆ primes of d}` alone, with
`S_d(X) = Σ_{m ≤ X, m ∈ ⟨d⟩} 1/m`, `T_d(X) = σ(d) − S_d(X)`:

| fact | content | used in |
|---|---|---|
| `StmtSdmLe` | `S_d(X) ≤ σ(d)` (finite Euler product) | `SdiagLeadAd` |
| `StmtMeanSig3` | `Σ_{d ≤ M} μ²σ³/d ≤ C(1 + log M)` | `SdiagLeadAd` |
| `StmtTailFixed` | `Σ_{d ≤ M} μ²σ² T_d(Z)/d ≤ η(1 + log M)`, `Z = Z(η)` | `SdiagLeadAd` |
| `StmtTailAvg` | `Σ_{d ≤ M} μ²σ² T_d(M/(dY))/d ≤ C(1 + log Y)` | `SdiagLeadAd` |
| `StmtGmuLog` | `Σ_{d ≤ t} μ²(d)/φ(d) = log t + O(1)` | `SdiagLeadDsum` |
| `StmtDivLog` | `Σ_{d ≤ M} μ²σ²/d · Σ_{a|d} log a/a ≤ C(1 + log M)` | `SdiagLeadDsum` |

Each is classical and elementary (no zeros, no PNT): the first by `Π_{p|d} Σ_k p^{−k}`, the means
by `σ^j(d) = Σ_{k | d} h_j(k)` with `h_j(p) = O(1/p)`, the tails by `Σ_m (1 + log m)/(m rad m) < ∞`
after swapping the `d`- and `m`-sums, `StmtGmuLog` by `n ↦ (rad n, n/rad n)`.

The chain. `Sdiag_swap` (exact) → `Ad_eq` (exact, coprimality) → `muSmoothR`/`muSmooth_crude`
(the per-`d` Möbius step, from `psiMu_tendsto`) → `stmtAdApprox_of_arith` (layer 2) and
`stmtDsum_of_arith` (layer 3, Abel summation) → `stmtSdiagLead_of_steps` → `stmtSdiagLead_holds`.

The size check (the rule "a lost factor is a design failure") was done before each layer and is
recorded in `SdiagLeadCore`, `SdiagLeadAd` and `SdiagLeadDsum`: no factor growing with `M` is lost.
`θ < 1/2` is not used (as `DiagMain`'s docstring says); `P(0) = 0`, `θ > 0`, `κ > 0` are.

| name | content | status |
|---|---|---|
| `StmtArith` | the six arithmetic facts | OPEN (named Prop) |
| `stmtSdiagLead_holds` | `StmtArith → StmtSdiagLead P θ R κ`, `P(0) = 0`, `0 < θ`, `0 < κ` | proved |
| `stmtDiagMainO_holds` | `StmtArith → StmtDiagMainO P θ R κ` | proved |
| `stmtMuSmooth_holds` (`SdiagLeadSmooth`) | `DiagMain.StmtMuSmooth P κ` | proved, unconditional |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadDsum

namespace SdiagLead

open DiagMain DiagMainStmt

/-- OPEN, **the six arithmetic facts** the leading term rests on. -/
def StmtArith : Prop :=
  StmtSdmLe ∧ StmtMeanSig3 ∧ StmtTailFixed ∧ StmtTailAvg ∧ StmtGmuLog ∧ StmtDivLog

/-- **Young's Lemma 7 to `o(1/L)`**: `S(α,β,0) = I(α,β)/log M + o(1/L)` on `Regime κ T`,
given `StmtArith`. -/
theorem stmtSdiagLead_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (_hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) (hA : StmtArith) :
    StmtSdiagLead P θ R κ := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := hA
  have hκθ : 0 ≤ κ * θ := by positivity
  exact stmtSdiagLead_of_steps P hθ0 R hκ
    (stmtAdApprox_of_arith P hP0 hκθ h1 h2 h3 h4) (stmtDsum_of_arith P hκθ h5 h6)

/-- **The main term, little-o**: `ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)`, given `StmtArith`. -/
theorem stmtDiagMainO_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) (hA : StmtArith) :
    StmtDiagMainO P θ R κ :=
  stmtDiagMainO_of_lead P hθ0 R hκ (stmtSdiagLead_holds P hP0 hθ0 hθ R hκ hA)

/-- info: 'SdiagLead.stmtSdiagLead_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtSdiagLead_holds

/-- info: 'SdiagLead.stmtDiagMainO_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagMainO_holds

/-- info: 'SdiagLead.stmtMuSmooth_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtMuSmooth_holds

end SdiagLead
