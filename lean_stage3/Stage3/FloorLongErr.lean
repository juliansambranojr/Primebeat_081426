/-
# FloorLongErr — block S13 of `lean_stage3/design/stencil.md`, B1, the floor for every length: the one named input. 2026-11-25.

Stage A (`FloorSum.levinson_floor`) holds at `θ = 49/100`. The length exponent `θ < 1/2`
enters the chain only through three error statements, each an `O(T/L)` term; everything else
(the main term, the assembly of Lemma 3, the operator, unsmoothing, the window, the sum) is
general in `θ > 0`. This file names the three as one Prop, `StmtLongErr P θ R`, and builds the
`o(T)` Lemma 3 from it for every `θ > 0`.

Where `θ < 1/2` enters, traced from `grep -n "θ < 1 / 2" Stage3/*.lean`:
* the diagonal: `Diagonal.diag_young`, through `final_size_diag` (`T^(3/4+θ/2) ≤ T/L⁵`) and
  `SB_young` (`pow_shift_le`, `j^(−1/4+x)` for `j ≤ T^θ`);
* the off-diagonal: `OffDiagClose.stmtOffDiag_holds`, through `final_size`, `Tpow_le` and
  `r_choice` (`r(1 − 2θ) ≥ 2`);
* the X-term: `Stirling.stmtXAll_of'`, which calls `stmtOffDiag_holds`, `diag_young`,
  `SwapX.c1Y_bound` and `size_X` (`T^(1/2+θ+2η)`).
Carried and unused: `SdiagLead.stmtSdiagLead_holds` (`_hθ`), hence `stmtDiagMainO_holds`,
`Arith.stmtDiagMainO_holds'`; `Unsmooth.dop_cY_bdd` and `Operator.Ires_o`, `FloorStep.floor_step`
use it only as `θ ≤ 1` (`log M ≤ log T`, `M ≤ T`), which `FloorLongMean`, `FloorLongStep`
replace by `θ ≤ ⌈θ⌉₊`.

| name | content | status |
|---|---|---|
| `StmtDiagErr` | the shifted diagonal: `diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + O(T/L)` (`diag_young`'s conclusion) | defined |
| `StmtLongErr` | for every `κ > 0`: `StmtDiagErr ∧ StmtOffDiagAll ∧ StmtXAll` at `(P, θ, R, κ)` | defined (OPEN for `θ ≥ 1/2`) |
| `mainO_long` | `StmtDiagMainO P θ R κ` for every `θ > 0` (the main term, no length bound) | proved |
| `diagO_of_err` | `StmtDiagErr → StmtDiagMainO → StmtDiagO` | proved |
| `lemma3_of_long` | `StmtLongErr → StmtLemma3resO P θ R κ`, every `κ > 0`, `θ > 0` | proved |
| `longErr_of_lt_half` | `StmtLongErr P θ R` for `0 < θ < 1/2`, `P(0) = 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.Lemma3

namespace FloorLong

open Complex TwistedMoment DiagMainStmt DiagonalO OffDiagClose SwapX

/-- **The shifted diagonal error**, `diag_young`'s conclusion: on Lemma 6's range,
`diagSum = ŵ(0) ζ(1+α+β) S(α,β,0) + O(T/L)`, uniformly over `Weight T (log T)`. -/
noncomputable
def StmtDiagErr (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 - (what0 W : ℂ) *
        (riemannZeta (1 + α + β) * Diagonal.Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0)‖ ≤
        C * (T / Real.log T)

/-- OPEN for `θ ≥ 1/2`, **stage B as one input**: the three error statements of the floor chain
at length `θ`, each in the form its consumer takes, for every `κ > 0`: the shifted diagonal
(`Diagonal.diag_young`), the off-diagonal (`OffDiagClose.StmtOffDiagAll`) and the X-term
(`SwapX.StmtXAll`). Budget: any constants; the chain needs each `O(errY) = O(T/L)` uniformly in
`WeightAll` with `C_j ≤ Cs j`. Route for `θ ≥ 1/2`: S13 B3 (the shifted convolution sums
`Σ_{hm−kn=r} μ(h)μ(k)·…`); the floor chain itself uses only `κ = 2R + 1 + 1/R`. -/
noncomputable
def StmtLongErr (P : Polynomial ℝ) (θ R : ℝ) : Prop :=
  ∀ κ : ℝ, 0 < κ →
    StmtDiagErr P θ R κ ∧ StmtOffDiagAll P θ R κ ∧ StmtXAll P θ R κ

/-- **The main term for every length**: `SdiagLead.stmtDiagMainO_holds` with its unused
`θ < 1/2` dropped (the proof is `stmtSdiagLead_holds`'s, with `Arith.stmtArith_holds`). -/
theorem mainO_long (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) : StmtDiagMainO P θ R κ := by
  obtain ⟨h1, h2, h3, h4, h5, h6⟩ := Arith.stmtArith_holds
  have hκθ : 0 ≤ κ * θ := by positivity
  exact DiagMain.stmtDiagMainO_of_lead P hθ0 R hκ
    (SdiagLead.stmtSdiagLead_of_steps P hθ0 R hκ
      (SdiagLead.stmtAdApprox_of_arith P hP0 hκθ h1 h2 h3 h4)
      (SdiagLead.stmtDsum_of_arith P hκθ h5 h6))

/-- **The diagonal at `o(T)` from its error statement**: `DiagonalO.stmtDiagO_of_mainO` with
`diag_young` replaced by the hypothesis. -/
theorem diagO_of_err (P : Polynomial ℝ) {θ R κ : ℝ} (hdy0 : StmtDiagErr P θ R κ)
    (hmain : StmtDiagMainO P θ R κ) : StmtDiagO P θ R κ := by
  intro ε hε
  obtain ⟨T1, hT1⟩ := hmain (ε / 4) (by positivity)
  obtain ⟨C2, T2, hC20, hC2⟩ := hdy0
  refine ⟨max (max 8 (Real.exp (C2 / (ε / 2)))) (max T1 T2), fun T hT W α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT8, hTe⟩, hTa, hTb⟩ := hT
  have hT0 : 0 < T := by linarith
  set z := riemannZeta (1 + α + β) * Diagonal.Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0
    with hz
  set c1 := c1Y P (Mof T θ) α β with hc1
  set D := diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 with hD
  have hw0 := what0_le W hT0
  have hmT : ‖z - c1‖ ≤ ε / 4 := hT1 T hTa α β hreg
  have hdy : ‖D - (what0 W : ℂ) * z‖ ≤ C2 * (T / Real.log T) := hC2 T hTb W α β hreg
  have habs : C2 * (T / Real.log T) ≤ ε / 2 * T :=
    small_of_log (by positivity) (by linarith) hTe
  have herr := T_le_errO W hT0.le
  have hsplit : D - c1 * (what0 W : ℂ) = (D - (what0 W : ℂ) * z) + (what0 W : ℂ) * (z - c1) := by
    ring
  rw [hsplit]
  calc ‖(D - (what0 W : ℂ) * z) + (what0 W : ℂ) * (z - c1)‖
      ≤ ‖D - (what0 W : ℂ) * z‖ + ‖(what0 W : ℂ)‖ * ‖z - c1‖ := by
        rw [← norm_mul]
        exact norm_add_le _ _
    _ ≤ ε / 2 * T + 2 * T * (ε / 4) :=
        add_le_add (hdy.trans habs) (mul_le_mul hw0 hmT (norm_nonneg _) (by positivity))
    _ = ε * T := by ring
    _ ≤ ε * errO W := mul_le_mul_of_nonneg_left herr hε.le

/-- **Lemma 3 at `o(T)` for every length**, from the one input: `lemma3_resO_of_partsAll` with
the diagonal from `diagO_of_err` and `mainO_long`. -/
theorem lemma3_of_long (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ) {R : ℝ}
    (hL : StmtLongErr P θ R) {κ : ℝ} (hκ : 0 < κ) : StmtLemma3resO P θ R κ := by
  obtain ⟨hD, hO, hX⟩ := hL κ hκ
  exact lemma3_resO_of_partsAll hκ (diagO_of_err P hD (mainO_long P hP0 hθ0 R hκ)) hO hX

/-- **Stage A's length gives the input**: for `0 < θ < 1/2` the three error statements are the
tree's `diag_young`, `stmtOffDiag_holds` and `Stirling.stmtXAll_of'`. -/
theorem longErr_of_lt_half (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (R : ℝ) : StmtLongErr P θ R := fun _ hκ =>
  ⟨Diagonal.diag_young P hθ R hκ, stmtOffDiag_holds P hθ R hκ,
    Stirling.stmtXAll_of' P hθ R hκ Stirling.stmtXStirlingRel_holds
      (Arith.stmtDiagMainO_holds' P hP0 hθ0 hθ R hκ)⟩

/-- info: 'FloorLong.mainO_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mainO_long

/-- info: 'FloorLong.diagO_of_err' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms diagO_of_err

/-- info: 'FloorLong.lemma3_of_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_of_long

/-- info: 'FloorLong.longErr_of_lt_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms longErr_of_lt_half

end FloorLong
