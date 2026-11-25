/-
# Stage3.SdiagLeadCore — the leading term of `S(α,β,0)`, Young's Lemma 7 to `o(1/L)`. 2026-11-25.

Target: `DiagMain.StmtSdiagLead P θ R κ`, `S(α,β,0) = I(α,β)/log M + o(1/L)` on `Regime κ T`.

The route (`Stage3/DiagMain.lean`'s docstring), in three layers.
(1) Exact (`SdiagLeadSwap.Sdiag_swap`): `S = Σ_{d ≤ M} W_d A_d(β) A_d(α)`, `W_d = J_{1+α+β}(d)
d^{−(2+α+β)}`, `A_d(γ) = Σ_{n ≤ M/d} μ(dn) P(log(M/(dn))/log M) n^{−(1+γ)}`.
(2) Per `d`, on average (`StmtAdApprox`): `A_d(γ)` is replaced by `Â_d(γ) = μ(d) (d/φ(d))
(γP(ℓ_d) + P′(ℓ_d)/log M)`, `ℓ_d = log(M/d)/log M`, with `Σ_d ‖W_d‖ ‖A_d A_d − Â_d Â_d‖ =
o(1/log M)`. Its Möbius input is `SdiagLeadSmooth.muSmoothR` (proved, `o(1/λ)` uniformly in
`x ≥ Y`) through `μ(dn) = μ(d)μ(n)1_{(n,d)=1}` and `μ·1_{(·,d)=1} = μ * 1_{rad(·) | d}`.
(3) The `d`-sum (`StmtDsum`): `Σ_d W_d Â_d(β) Â_d(α) = I(α,β)/log M + o(1/log M)`.
`stmtSdiagLead_of_steps` composes (1)–(3) with `θL/2 ≤ log M ≤ θL` (`logM_ge`, `logM_le`).

The size check, done before any proof (the rule "a lost factor is a design failure").
`S ≍ 1/L`, needed to `o(1/L)`. In (2): `‖W_d‖ ≤ e^{2A} σ_{−1}(d)/d`, `‖A_d‖, ‖Â_d‖ ≤ C (d/φ(d))/log M`
(`muSmooth_crude`), and the per-`d` error is `e^A (d/φ(d)) ε/log M` from `muSmoothR` on the
`m ∈ ⟨d⟩` with `M/(dm) ≥ Y`, plus `(C/log M) Σ_{m ∈ ⟨d⟩, m > M/(dY)} 1/m` from the rest, plus
`C Σ_{m ∈ ⟨d⟩} (log m)/m / log² M` from `ℓ_{dm} = ℓ_d − log m/log M` and `m^{−γ} = 1 + O(log m/log M)`.
Against the weight `(d/φ(d))²/d` with `Σ_{d ≤ M} (d/φ(d))³/d ≍ log M` this is
`ε/log M + C log Y/log² M + C/log² M`: `o(1/log M)`, the tails bounded on average through
`Σ_m (1 + log m)/(m rad m) < ∞`. In (3): `W_d (d/φ(d))² = μ²(d)/φ(d) · Π_{p|d}(1 − p^{−1−α−β})/(1 − p^{−1})`,
the product is `1 + O(Σ_{p|d} log p/(p log M))`, `O(1)` on average against `1/φ(d)`;
`Σ_{d ≤ x} μ²(d)/φ(d) = log x + O(1)` and `|F|, |F′| = O(1/log² M)` give
`Σ_d μ²(d)/φ(d) F(ℓ_d) = log M ∫₀¹ F + O(1/log² M)`. No factor growing with `M` is lost on this
route; the one the docstring of `DiagMain` names (`log M`, from `mu_pnt_alt` alone) is cured by
`muSmoothR`, which is proved.

| name | content | status |
|---|---|---|
| `Wd`, `sig`, `Ahat` | `J(d) d^{−(2+α+β)}`; `d/φ(d)`; `μ(d)(d/φ(d))(γP(ℓ_d) + P′(ℓ_d)/log M)` | def |
| `S_eq` | `S(α,β,0) = Σ_d W_d A_d(β) A_d(α)` | proved (`Sdiag_swap`) |
| `StmtAdApprox` | (2): `Σ_d ‖W_d‖ ‖A_d(β)A_d(α) − Â_d(β)Â_d(α)‖ ≤ ε/log M` | OPEN (named Prop) |
| `StmtDsum` | (3): `‖Σ_d W_d Â_d(β)Â_d(α) − I/log M‖ ≤ ε/log M` | OPEN (named Prop) |
| `Mof_ge`, `stmtSdiagLead_of_steps` | (1)+(2)+(3) → `StmtSdiagLead`, `θ > 0`, `κ > 0` | proved |
| `stmtMuSmooth_holds` (`SdiagLeadSmooth`) | `DiagMain.StmtMuSmooth P κ`, the `d = 1` step | proved |

`StmtAdApprox` is reduced to four arithmetic facts in `SdiagLeadAd` (`stmtAdApprox_of_arith`),
`StmtDsum` to two in `SdiagLeadDsum` (`stmtDsum_of_arith`); `SdiagLead` composes them.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.SdiagLeadCop

namespace SdiagLead

open Complex Finset TwistedMoment Diagonal DiagMain DiagMainStmt
open scoped ArithmeticFunction.Moebius

noncomputable section

/-- `W_d = J_{1+α+β}(d) d^{−(2+α+β)}`. -/
def Wd (α β : ℂ) (d : ℕ) : ℂ := Jz (1 + α + β) d * (d : ℂ) ^ (-(2 + α + β))

/-- `d/φ(d)`. -/
def sig (d : ℕ) : ℝ := (d : ℝ) / (Nat.totient d : ℝ)

/-- `Â_d(γ) = μ(d) (d/φ(d)) (γ P(ℓ_d) + P′(ℓ_d)/log M)`, `ℓ_d = log(M/d)/log M`. -/
def Ahat (P : Polynomial ℝ) (M d : ℕ) (γ : ℂ) : ℂ :=
  ((μ d : ℤ) : ℂ) * ((sig d : ℝ) : ℂ) * mainS P (Real.log M) ((M : ℝ) / d) γ

theorem S_eq (P : Polynomial ℝ) (T θ R : ℝ) (α β : ℂ) :
    Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 =
      ∑ d ∈ Icc 1 (Mof T θ), Wd α β d * Ad P (Mof T θ) d β * Ad P (Mof T θ) d α := by
  rw [Sdiag_swap]; rfl

/-- OPEN, **(2) the per-`d` step on average**: `A_d(γ) = Â_d(γ) + error`, the errors summed
against `‖W_d‖` are `o(1/log M)`, uniformly in `‖α‖ log M, ‖β‖ log M ≤ A`. Route: `μ(dn) =
μ(d)μ(n)1_{(n,d)=1}`, `μ·1_{(·,d)=1} = μ * 1_{rad(·)|d}`, `A_d(γ) = μ(d) Σ_{m ∈ ⟨d⟩} m^{−(1+γ)}
Smu(M/(dm), γ)`, `muSmoothR` for `M/(dm) ≥ Y` and `muSmooth_crude` below; the tails on average
over `d` (`Σ_m (1 + log m)/(m rad m) < ∞`). -/
def StmtAdApprox (P : Polynomial ℝ) (A : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N₀ : ℕ, ∀ M : ℕ, N₀ ≤ M → ∀ α β : ℂ, ‖α‖ * Real.log M ≤ A →
    ‖β‖ * Real.log M ≤ A →
      ∑ d ∈ Icc 1 M, ‖Wd α β d‖ * ‖Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α‖ ≤
        ε / Real.log M

/-- OPEN, **(3) the `d`-sum**: `Σ_{d ≤ M} W_d Â_d(β) Â_d(α) = I(α,β)/log M + o(1/log M)`.
Route: `W_d (d/φ(d))² μ²(d) = μ²(d)/φ(d) · Π_{p|d}(1 − p^{−1−α−β})/(1 − p^{−1})`, the product
`1 + O(Σ_{p | d} log p/(p log M))`; `Σ_{d ≤ x} μ²(d)/φ(d) = log x + O(1)` and partial summation
against `F(ℓ) = (P′(ℓ) + β log M P(ℓ))(P′(ℓ) + α log M P(ℓ))/log² M`. -/
def StmtDsum (P : Polynomial ℝ) (A : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ N₀ : ℕ, ∀ M : ℕ, N₀ ≤ M → ∀ α β : ℂ, ‖α‖ * Real.log M ≤ A →
    ‖β‖ * Real.log M ≤ A →
      ‖∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α -
        IY P M α β / (Real.log M : ℂ)‖ ≤ ε / Real.log M

/-- `N ≤ M = ⌊T^θ⌋` once `log T ≥ log(N+1)/θ`. -/
theorem Mof_ge {T θ : ℝ} (hT : 1 < T) (hθ : 0 < θ) {N : ℕ}
    (hN : Real.log (N + 1) / θ ≤ Real.log T) : N ≤ Mof T θ := by
  unfold Mof
  apply Nat.le_floor
  have hT0 : 0 < T := by linarith
  have h1 : Real.log (N + 1) ≤ θ * Real.log T := by rwa [div_le_iff₀ hθ, mul_comm] at hN
  have h2 : (N : ℝ) + 1 ≤ T ^ θ := by
    rw [Real.rpow_def_of_pos hT0]
    calc (N : ℝ) + 1 = Real.exp (Real.log (N + 1)) := (Real.exp_log (by positivity)).symm
      _ ≤ Real.exp (Real.log T * θ) := Real.exp_le_exp.mpr (by linarith)
  linarith

/-- **The composition**: (1) exact, (2) and (3) with `A = κθ` give `StmtSdiagLead`. -/
theorem stmtSdiagLead_of_steps (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (h2 : StmtAdApprox P (κ * θ)) (h3 : StmtDsum P (κ * θ)) :
    StmtSdiagLead P θ R κ := by
  intro ε hε
  set e := ε * θ / 4 with he
  have he0 : 0 < e := by positivity
  obtain ⟨N₂, hN₂⟩ := h2 e he0
  obtain ⟨N₃, hN₃⟩ := h3 e he0
  set L₀ := max 1 (max (4 * Real.log 2 / θ) (Real.log (((max N₂ N₃ : ℕ) : ℝ) + 1) / θ)) with hL₀
  refine ⟨Real.exp L₀, fun T hT α β hreg => ?_⟩
  have hL0T : L₀ ≤ Real.log T := by
    rw [← Real.log_exp L₀]; exact Real.log_le_log (Real.exp_pos _) hT
  have hL1 : 1 ≤ Real.log T := le_trans (le_max_left _ _) hL0T
  have hLpos : 0 < Real.log T := by linarith
  have hT1 : 1 < T := by
    have := Real.add_one_le_exp L₀
    have : 1 < Real.exp L₀ := Real.one_lt_exp_iff.mpr (by linarith [le_max_left 1 (max (4 * Real.log 2 / θ)
      (Real.log (((max N₂ N₃ : ℕ) : ℝ) + 1) / θ))])
    linarith
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T :=
    le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hL0T
  have hLN : Real.log ((max N₂ N₃ : ℕ) + 1) / θ ≤ Real.log T := by
    exact le_trans (le_trans (le_max_right _ _) (le_max_right _ _)) hL0T
  have hM : max N₂ N₃ ≤ Mof T θ := Mof_ge hT1 hθ0 hLN
  obtain ⟨hα, hβ, -⟩ := hreg
  set L := Real.log T with hLdef
  set M := Mof T θ with hMdef
  have hlm_ge : θ * L / 2 ≤ Real.log M := logM_ge hT1 hθ0 hLθ
  have hlm_le : Real.log M ≤ θ * L := logM_le hT1.le hθ0.le
  have hlm0 : 0 < Real.log M := lt_of_lt_of_le (by positivity) hlm_ge
  have hA : ∀ γ : ℂ, ‖γ‖ ≤ κ / L → ‖γ‖ * Real.log M ≤ κ * θ := by
    intro γ hγ
    calc ‖γ‖ * Real.log M ≤ κ / L * (θ * L) :=
          mul_le_mul hγ hlm_le hlm0.le (by positivity)
      _ = κ * θ := by field_simp
  have e2 := hN₂ M (le_trans (le_max_left _ _) hM) α β (hA α hα) (hA β hβ)
  have e3 := hN₃ M (le_trans (le_max_right _ _) hM) α β (hA α hα) (hA β hβ)
  rw [S_eq]
  have hsplit : ∑ d ∈ Icc 1 M, Wd α β d * Ad P M d β * Ad P M d α - IY P M α β / (Real.log M : ℂ) =
      ∑ d ∈ Icc 1 M, Wd α β d * (Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α) +
        (∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α -
          IY P M α β / (Real.log M : ℂ)) := by
    rw [← sub_add_cancel (∑ d ∈ Icc 1 M, Wd α β d * Ad P M d β * Ad P M d α)
      (∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α)]
    rw [← Finset.sum_sub_distrib]
    simp only [mul_sub, mul_assoc]
    ring
  rw [hsplit]
  have hW : ‖∑ d ∈ Icc 1 M, Wd α β d * (Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α)‖ ≤
      e / Real.log M := by
    refine le_trans (norm_sum_le _ _) (le_trans (le_of_eq ?_) e2)
    refine Finset.sum_congr rfl fun d _ => ?_
    rw [norm_mul]
  have htot : 2 * e / Real.log M ≤ ε / L := by
    rw [div_le_div_iff₀ hlm0 hLpos, he]
    nlinarith
  calc _ ≤ ‖∑ d ∈ Icc 1 M, Wd α β d * (Ad P M d β * Ad P M d α - Ahat P M d β * Ahat P M d α)‖ +
        ‖∑ d ∈ Icc 1 M, Wd α β d * Ahat P M d β * Ahat P M d α - IY P M α β / (Real.log M : ℂ)‖ :=
        norm_add_le _ _
    _ ≤ e / Real.log M + e / Real.log M := add_le_add hW e3
    _ = 2 * e / Real.log M := by ring
    _ ≤ ε / L := htot

/-- **The corollary through the Taylor step**: (2) and (3) give `StmtDiagMainO`. -/
theorem stmtDiagMainO_of_steps (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (h2 : StmtAdApprox P (κ * θ)) (h3 : StmtDsum P (κ * θ)) :
    StmtDiagMainO P θ R κ :=
  stmtDiagMainO_of_lead P hθ0 R hκ (stmtSdiagLead_of_steps P hθ0 R hκ h2 h3)

end

/-- info: 'SdiagLead.stmtSdiagLead_of_steps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtSdiagLead_of_steps

/-- info: 'SdiagLead.stmtDiagMainO_of_steps' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagMainO_of_steps

/-- info: 'SdiagLead.S_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_eq

end SdiagLead
