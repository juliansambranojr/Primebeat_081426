# `lean_stage3/Stage3/DiagMainStmt.lean`

> **Read from the source text.** This file changed after the last `python3 utilities/lean_map.py --dump`, so the arrows on this page are names occurring in each proof and have not been confirmed by Lean.

# Stage3.DiagMainStmt — the diagonal's main term, little-o form Unit 0538's decision: PNT+'s `mu_pnt` (`Σ_{n<x} μ(n) = o(x)`, no rate) carries the main term `ζ(1+α+β) S(α,β,0) = c₁(α,β) + o(1)`, and Levinson's floor needs only the leading term. This file holds the two statements the little-o route is built on, so that the restatement (`DiagonalO`) and the proof of the main term (`DiagMain`) are written side by side.

0 theorems, 2 definitions, 35 lines. 

**Imports:** [`Diagonal`](../lean_stage3/Diagonal.md)  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`DiagMain`](../lean_stage3/DiagMain.md), [`DiagMainMu`](../lean_stage3/DiagMainMu.md), [`DiagonalO`](../lean_stage3/DiagonalO.md)

## Definitions

<a name="DiagMainStmt-StmtDiagMainO"></a>
### `DiagMainStmt.StmtDiagMainO`

def · line 25

- **Is:** `` StmtDiagMainO (P : Polynomial ℝ) (θ R κ : ℝ) : Prop := ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β → ‖riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 - c1Y P (Mof T θ) α β‖ ≤ ε noncomputable ``
- **Built from:** [`Diagonal.Sdiag`](../lean_stage3/Diagonal.md#Diagonal-Sdiag), [`TwistedMoment.Mof`](../lean_stage3/TwistedMoment.md#TwistedMoment-Mof), [`TwistedMoment.Regime`](../lean_stage3/TwistedMoment.md#TwistedMoment-Regime), [`TwistedMoment.aY`](../lean_stage3/TwistedMoment.md#TwistedMoment-aY), [`TwistedMoment.c1Y`](../lean_stage3/TwistedMoment.md#TwistedMoment-c1Y), [`TwistedMoment.sig0`](../lean_stage3/TwistedMoment.md#TwistedMoment-sig0)
- **Used by 6:** [`Arith.stmtDiagMainO_holds'`](../lean_stage3/Arith.md#Arith-stmtDiagMainO_holds-), [`DiagMain.stmtDiagMainO_of_lead`](../lean_stage3/DiagMain.md#DiagMain-stmtDiagMainO_of_lead), [`DiagonalO.lemma3_resO_of_mainO_X`](../lean_stage3/DiagonalO.md#DiagonalO-lemma3_resO_of_mainO_X), [`DiagonalO.stmtDiagO_of_mainO`](../lean_stage3/DiagonalO.md#DiagonalO-stmtDiagO_of_mainO), [`SdiagLead.stmtDiagMainO_holds`](../lean_stage3/SdiagLead.md#SdiagLead-stmtDiagMainO_holds), [`SdiagLead.stmtDiagMainO_of_steps`](../lean_stage3/SdiagLeadCore.md#SdiagLead-stmtDiagMainO_of_steps)

<a name="DiagMainStmt-errO"></a>
### `DiagMainStmt.errO`

def · line 32

- **Is:** `` errO {T L : ℝ} (W : Weight T L) : ℝ := (1 + W.C1 + W.C2) * T ``
- **Built from:** [`TwistedMoment.Weight`](../lean_stage3/TwistedMoment.md#TwistedMoment-Weight)
- **Used by 6:** [`DiagonalO.StmtDiagO`](../lean_stage3/DiagonalO.md#DiagonalO-StmtDiagO), [`DiagonalO.StmtLemma3resO`](../lean_stage3/DiagonalO.md#DiagonalO-StmtLemma3resO), [`DiagonalO.T_le_errO`](../lean_stage3/DiagonalO.md#DiagonalO-T_le_errO), [`DiagonalO.errY_absorb`](../lean_stage3/DiagonalO.md#DiagonalO-errY_absorb), [`DiagonalO.lemma3_resO_of_parts`](../lean_stage3/DiagonalO.md#DiagonalO-lemma3_resO_of_parts), [`DiagonalO.stmtDiagO_of_mainO`](../lean_stage3/DiagonalO.md#DiagonalO-stmtDiagO_of_mainO)

