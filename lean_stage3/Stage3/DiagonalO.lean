/-
# DiagonalO — block S12 of `lean_stage3/design/stencil.md`, the diagonal and Lemma 3 with the main term carried as o(1). 2026-11-25.

Julian's decision (unit 0538): the diagonal main term `ζ(1+α+β) S(α,β,0) = c₁(α,β)` is carried
with `o(1)` (`DiagMainStmt.StmtDiagMainO`), since Levinson's floor needs only the leading term.
This file builds the `o(T)` layer on it. Notation as in `TwistedMoment`, `Diagonal`,
`DiagMainStmt`: `L = log T`, `M = Mof T θ`, Young's `a_h = aY`, `σ₀ = sig0`, `ŵ(0) = what0`,
`c₁ = c1Y`, `errY W = (1 + C₁ + C₂) T/L`, `errO W = (1 + C₁ + C₂) T`.

The route. (1) `diag_young` gives `diagSum − ŵ(0) ζ(1+α+β) S(α,β,0) = O(T/L)` unconditionally;
`|ŵ(0)| ≤ 2T` (support `[T/4, 2T]`, `0 ≤ w ≤ 1`) and `StmtDiagMainO` at `ε/4` give
`‖ŵ(0)(ζ S − c₁)‖ ≤ εT/2`, and `C·T/L ≤ εT/2` once `L ≥ 2C/ε` (`small_of_log`); `T ≤ errO W`.
(2) The assembly copies `lemma3_res_of_parts`: `I = I₁ + I_X − I_res`, `I₁ = diag + off` at
`(α,β)` and at `(−β,−α)`, `cY = c₁(α,β) + T^(−α−β) c₁(−β,−α)`, `‖T^(−α−β)‖ ≤ e^(2κ)`
(`norm_Tpow_le`). The two diagonal terms are `≤ ε₁ errO` with `ε₁ = ε/(2(1+e^(2κ)))`; the
off-diagonal terms and the X-term are `O(errY)`, and `K·errY ≤ (ε/2)·errO` once
`L ≥ 2K/ε` (`errY_absorb`).

| name | content | status |
|---|---|---|
| `small_of_log` | `C·(T/log T) ≤ ε·T` for `T > 1`, `e^(C/ε) ≤ T` | proved |
| `errY_absorb` | `K·errY W ≤ ε·errO W` for `T > 1`, `e^(K/ε) ≤ T` | proved |
| `T_le_errO` | `T ≤ errO W`, `T ≥ 0` | proved |
| `what0_le` | `‖ŵ(0)‖ ≤ 2T` | proved |
| `StmtDiagO` | `diagSum = c₁(α,β) ŵ(0) + o(T)`, uniformly in `Weight T (log T)`, on `Regime κ T` | defined |
| `stmtDiagO_of_mainO` | `StmtDiagMainO → StmtDiagO`, `θ < 1/2`, `κ > 0` | proved |
| `StmtLemma3resO` | Lemma 3 up to `I_res` with `o(T)`, over `WeightAll` with `C_j ≤ Cs j` | defined |
| `lemma3_resO_of_parts` | `StmtDiagO → StmtOffDiagAll → StmtX → StmtLemma3resO`, `κ > 0` | proved |
| `lemma3_resO_of_mainO_X` | `StmtDiagMainO → StmtX → StmtLemma3resO`, `θ < 1/2`, `κ > 0` (with `stmtOffDiag_holds`) | proved |

Differences from the targets. (i) The off-diagonal is proved over `WeightAll` only
(`OffDiagClose.StmtOffDiagAll`, constants `C_j ≤ Cs j` for a family `Cs` fixed first), while
`StmtDiagO` and `StmtX` are over `Weight`; so `StmtLemma3resO` is stated over
`WeightAll T (log T)`, coerced with `.toWeight`, with `∀ Cs` outside and the hypothesis
`∀ j, W.Cj j ≤ Cs j`, exactly as `StmtOffDiagAll`. (ii) `StmtDiagO` and the `X`-term stay over
`Weight`. (iii) `lemma3_resO_of_parts` needs no `θ < 1/2`; the corollary needs it for
`stmtDiagO_of_mainO` and `stmtOffDiag_holds`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.DiagMainStmt

namespace DiagonalO

open Complex MeasureTheory TwistedMoment Diagonal DiagMainStmt OffDiagClose

/-! ## Absorbing `T/L` into `ε·T` -/

/-- `C·(T/log T) ≤ ε·T` once `log T ≥ C/ε`. -/
theorem small_of_log {C ε T : ℝ} (hε : 0 < ε) (hT : 1 < T)
    (hTe : Real.exp (C / ε) ≤ T) : C * (T / Real.log T) ≤ ε * T := by
  have hT0 : 0 < T := by linarith
  have hL0 : 0 < Real.log T := Real.log_pos hT
  have hCL : C / ε ≤ Real.log T := by
    rw [← Real.log_exp (C / ε)]
    exact Real.log_le_log (Real.exp_pos _) hTe
  have hC' : C ≤ ε * Real.log T := by
    rw [div_le_iff₀ hε] at hCL
    linarith
  rw [show C * (T / Real.log T) = (C * T) / Real.log T by ring, div_le_iff₀ hL0]
  have := mul_le_mul_of_nonneg_left hC' hT0.le
  nlinarith

/-- `K·errY W ≤ ε·errO W` once `log T ≥ K/ε`. -/
theorem errY_absorb {T : ℝ} (W : Weight T (Real.log T)) {K ε : ℝ} (hε : 0 < ε)
    (hT : 1 < T) (hTe : Real.exp (K / ε) ≤ T) : K * errY W ≤ ε * errO W := by
  unfold errY errO
  have hc : 0 ≤ 1 + W.C1 + W.C2 := by
    have := W.C1_nonneg
    have := W.C2_nonneg
    linarith
  have h := small_of_log hε hT hTe
  calc K * ((1 + W.C1 + W.C2) * (T / Real.log T))
      = (1 + W.C1 + W.C2) * (K * (T / Real.log T)) := by ring
    _ ≤ (1 + W.C1 + W.C2) * (ε * T) := mul_le_mul_of_nonneg_left h hc
    _ = ε * ((1 + W.C1 + W.C2) * T) := by ring

/-- `T ≤ errO W` for `T ≥ 0`. -/
theorem T_le_errO {T L : ℝ} (W : Weight T L) (hT : 0 ≤ T) : T ≤ errO W := by
  unfold errO
  have := W.C1_nonneg
  have := W.C2_nonneg
  nlinarith

/-- `‖ŵ(0)‖ ≤ 2T`, from the support `[T/4, 2T]` and `0 ≤ w ≤ 1`. -/
theorem what0_le {T L : ℝ} (W : Weight T L) (hT : 0 < T) : ‖(what0 W : ℂ)‖ ≤ 2 * T := by
  rw [Complex.norm_real]
  have h := norm_integral_le_Icc (f := W.w) (a := T / 4) (b := 2 * T) (K := 1) (by linarith)
    (fun t ht => (W.zero_out ht).1) (fun t _ => by rw [Real.norm_eq_abs]; exact W.abs_le_one t)
  unfold what0
  linarith

/-! ## The diagonal, `o(T)` -/

/-- **The diagonal with `o(T)`** (Young's Lemma 6 for `I₁`'s diagonal, main term `o(1)`):
for every `ε > 0`, from some height on, `‖diagSum − c₁(α,β) ŵ(0)‖ ≤ ε·errO W`. -/
noncomputable
def StmtDiagO (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
    Regime κ T α β →
      ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 -
        c1Y P (Mof T θ) α β * (what0 W : ℂ)‖ ≤ ε * errO W

/-- **`StmtDiagO` from the main term, `o(1)`**: `diag_young` and `StmtDiagMainO`. -/
theorem stmtDiagO_of_mainO (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMainO P θ R κ) : StmtDiagO P θ R κ := by
  intro ε hε
  obtain ⟨T1, hT1⟩ := hmain (ε / 4) (by positivity)
  obtain ⟨C2, T2, hC20, hC2⟩ := diag_young P hθ R hκ
  refine ⟨max (max 8 (Real.exp (C2 / (ε / 2)))) (max T1 T2), fun T hT W α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hT8, hTe⟩, hTa, hTb⟩ := hT
  have hT0 : 0 < T := by linarith
  set z := riemannZeta (1 + α + β) * Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 with hz
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

/-! ## Lemma 3 up to the remainder, `o(T)` -/

/-- **Lemma 3 up to `I_res`, `o(T)`**, over the weights the off-diagonal is proved for:
`WeightAll T (log T)` with `C_j ≤ Cs j` for a family `Cs` fixed first (as `StmtOffDiagAll`). -/
noncomputable
def StmtLemma3resO (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ Cs : ℕ → ℝ, ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    ∀ W : WeightAll T (Real.log T), (∀ j, W.Cj j ≤ Cs j) → ∀ α β : ℂ, Regime κ T α β →
      ‖Imom W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) α β -
          cY P (Mof T θ) T α β * (what0 W.toWeight : ℂ)‖ ≤
        ε * errO W.toWeight + ‖Ires W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) α β‖

/-- **The assembly, `o(T)`**: the diagonal with `o(T)`, the off-diagonal as proved (over
`WeightAll`) and the X-term give Lemma 3 up to `I_res` with `o(T)`. -/
theorem lemma3_resO_of_parts {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiagO P θ R κ) (hO : StmtOffDiagAll P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3resO P θ R κ := by
  intro Cs ε hε
  set e := Real.exp (2 * κ) with he
  have he0 : 0 < e := Real.exp_pos _
  set ε₁ := ε / (2 * (1 + e)) with hε₁
  have hε₁0 : 0 < ε₁ := by positivity
  have hε₁e : ε₁ * (1 + e) = ε / 2 := by
    rw [hε₁]
    field_simp
  obtain ⟨Td, hd⟩ := hD ε₁ hε₁0
  obtain ⟨Co, To, hCo, ho⟩ := hO Cs
  obtain ⟨Cx, Tx, hCx, hx⟩ := hX
  set K := Co + Cx + e * Co with hK
  refine ⟨max (max Td To) (max Tx (max (max 8 (Real.exp (10 * κ))) (Real.exp (K / (ε / 2))))),
    fun T hT W hW α β hreg => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTd, hTo⟩, hTx, ⟨hT8, hTe⟩, hTK⟩ := hT
  obtain ⟨hα, hβ, hαβ, hL0⟩ := hreg.small hκ hTe
  have hreg' := hreg.swap
  obtain ⟨hα', hβ', hαβ', _⟩ := hreg'.small hκ hTe
  set V := W.toWeight
  set M := Mof T θ
  set a := aY P T θ R
  set σ := sig0 T R
  have hsplit := I_split V (by linarith) M a σ hα hβ hαβ (c := 1) (by norm_num)
  have h1 := I1_diag_off V (by linarith) M a σ hα hβ (c := 1) one_pos
  have h1' := I1_diag_off V (by linarith) M a σ hα' hβ' (c := 1) one_pos
  have bd := hd T hTd V α β hreg
  have bd' := hd T hTd V (-β) (-α) hreg'
  have bo := ho T hTo W hW α β hreg
  have bo' := ho T hTo W hW (-β) (-α) hreg'
  have bx := hx T hTx V α β hreg
  have hTp := norm_Tpow_le (by linarith) hreg
  have habs : K * errY V ≤ ε / 2 * errO V := errY_absorb V (by positivity) (by linarith) hTK
  set Tp : ℂ := (T : ℂ) ^ (-(α + β))
  set wh : ℂ := (what0 V : ℂ)
  set dg := diagSum V M a σ α β 1
  set dg' := diagSum V M a σ (-β) (-α) 1
  set of := offSum V M a σ α β 1
  set of' := offSum V M a σ (-β) (-α) 1
  set ix := IX V M a σ α β 1
  set rs := Ires V M a σ α β
  have key : Imom V M a σ α β - cY P M T α β * wh =
      (dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
        Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of' - rs := by
    rw [hsplit, h1, h1']
    unfold cY
    ring
  rw [key]
  have m1 : ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ ≤ e * (ε₁ * errO V) := by
    rw [norm_mul]
    exact mul_le_mul hTp bd' (norm_nonneg _) he0.le
  have m2 : ‖Tp * of'‖ ≤ e * (Co * errY V) := by
    rw [norm_mul]
    exact mul_le_mul hTp bo' (norm_nonneg _) he0.le
  calc _ ≤ ‖(dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh) + Tp * of'‖ + ‖rs‖ := norm_sub_le _ _
    _ ≤ ‖dg - c1Y P M α β * wh‖ + ‖of‖ + ‖ix - Tp * I1 V M a σ (-β) (-α) 1‖ +
          ‖Tp * (dg' - c1Y P M (-β) (-α) * wh)‖ + ‖Tp * of'‖ + ‖rs‖ := by
        have n1 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1) +
          Tp * (dg' - c1Y P M (-β) (-α) * wh)) (Tp * of')
        have n2 := norm_add_le ((dg - c1Y P M α β * wh) + of + (ix - Tp * I1 V M a σ (-β) (-α) 1))
          (Tp * (dg' - c1Y P M (-β) (-α) * wh))
        have n3 := norm_add_le ((dg - c1Y P M α β * wh) + of) (ix - Tp * I1 V M a σ (-β) (-α) 1)
        have n4 := norm_add_le (dg - c1Y P M α β * wh) of
        linarith
    _ ≤ ε₁ * errO V + Co * errY V + Cx * errY V + e * (ε₁ * errO V) +
          e * (Co * errY V) + ‖rs‖ := by linarith
    _ = ε₁ * (1 + e) * errO V + K * errY V + ‖rs‖ := by rw [hK]; ring
    _ ≤ ε / 2 * errO V + ε / 2 * errO V + ‖rs‖ := by rw [hε₁e]; linarith
    _ = ε * errO V + ‖rs‖ := by ring

/-- **Lemma 3 up to `I_res`, `o(T)`, from the main term and the X-term**: the diagonal by
`stmtDiagO_of_mainO`, the off-diagonal by `stmtOffDiag_holds`, for `θ < 1/2`, `κ > 0`. -/
theorem lemma3_resO_of_mainO_X (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMainO P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3resO P θ R κ :=
  lemma3_resO_of_parts hκ (stmtDiagO_of_mainO P hθ R hκ hmain) (stmtOffDiag_holds P hθ R hκ) hX

/-! ## Axiom pins -/

/-- info: 'DiagonalO.small_of_log' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms small_of_log

/-- info: 'DiagonalO.errY_absorb' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms errY_absorb

/-- info: 'DiagonalO.T_le_errO' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms T_le_errO

/-- info: 'DiagonalO.what0_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms what0_le

/-- info: 'DiagonalO.stmtDiagO_of_mainO' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagO_of_mainO

/-- info: 'DiagonalO.lemma3_resO_of_parts' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_of_parts

/-- info: 'DiagonalO.lemma3_resO_of_mainO_X' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lemma3_resO_of_mainO_X

end DiagonalO
