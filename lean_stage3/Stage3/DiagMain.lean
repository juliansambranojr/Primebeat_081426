/-
# Stage3.DiagMain — the diagonal's main term, little-o (Young's Lemma 7): the reduction and the
Möbius input. 2026-11-25.

Target: `DiagMainStmt.StmtDiagMainO P θ R κ`, `ζ(1+α+β) S(α,β,0) − c₁(α,β) → 0` uniformly on
`Regime κ T`, with `S = Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0`
`= Σ_{h,k ≤ M} μ(h)μ(k) P_h P_k (h,k)^{1+α+β} / (h^{1+β} k^{1+α})`, `c₁ = c1Y = I/((α+β) log M)`.

What is built. (1) The `ζ` factor is gone: `stmtDiagMainO_of_lead` derives `StmtDiagMainO` from
`StmtSdiagLead`, `S = I(α,β)/log M + o(1/L)`, by `ζ(1+s) = 1/s + O(1)` (`zeta_taylor`, from
Mathlib's `isBigO_riemannZeta_sub_one_div`), `‖I‖ ≤ C` on the range (`IY_bound`) and
`θL/2 ≤ log M ≤ θL` (`logM_ge`, `logM_le`); it uses `θ > 0`, `κ > 0` only. (2) The Möbius input
of the arithmetic route, `ψ_μ(N) = Σ_{n ≤ N} μ(n)/n · log(N/n) → 1` (`psiMu_tendsto`, in
`Stage3/DiagMainMu.lean`), elementary from `mu_pnt` and `mu_pnt_alt`.

What is open: `StmtSdiagLead`, the whole arithmetic content of Lemma 7.

The size check (the project rule "a lost factor is a design failure"). `S ≍ 1/L` and `ζ(1+α+β)
≍ L`, so `S` is needed to `o(1/L)`. On the suggested route `S = Σ_{d ≤ M} J(d) d^{−2−α−β}
A_d(α) A_d(β)` with `A_d(β) = μ(d) Σ_{n ≤ M/d, (n,d)=1} μ(n) P(log(M/(dn))/log M) n^{−1−β}`, the
main term of `A_d` is `≍ (d/φ(d))/log M` and the weight is `J(d)/d² ≍ 1/d`, with
`Σ_{d ≤ M} μ²(d)/φ(d) ≍ log M`. If the per-`d` error of `A_d` is `o(1)` — what `mu_pnt_alt`
(`Σ_{n ≤ y} μ(n)/n = o(1)`) gives for the `j = 1` term `Σ μ(n)/n log(y/n) = ∫₁^y m(t) dt/t =
o(log y)`, divided by `log M` — then the `d`-sum carries `o(1) · (1/log M) · log M = o(1)`
against the `o(1/L)` needed: **the factor lost is `log M ≍ θL`**. The cure is in the size of the
per-`d` error, not in the tactics: with `P(0) = 0` every term of `P(log(y/n)/log M)` carries
`1/log M`, and partial summation against `ψ_μ` (`ψ_μ(s) → 1`, `∫₁^y |ψ_μ − 1| ds/s = o(log y)`)
gives `A_d = main + o(1/log M)` uniformly for `M/d ≥ Y`; the `d > M/Y` are `O(log Y)` of the
`log M`. So the route stands with `psiMu_tendsto` as its Möbius input in place of
`mu_pnt_alt`. `StmtMuSmooth` states that per-`d` (`d = 1`) step. A second, smaller point for the
remaining steps: the coprimality `(n,d) = 1` through `μ·1_{(·,d)=1} = μ * 1_{rad(·) | d}` has a
tail `Σ_{rad m | d, m > Z} 1/m` that is not uniform in `d`; it is small on average over `d`
against `μ²(d)/φ(d)` (`Σ_m 1/(m·rad m) < ∞`), so the `d`-sum must be bounded on average.

| name | content | status |
|---|---|---|
| `IY`, `c1Y_eq` | `I(α,β) = ∫₀¹ (P′+α log M P)(P′+β log M P)`; `c₁ = I/((α+β) log M)` | def, proved |
| `IY_bound` | `‖I(α,β)‖ ≤ C` when `‖α‖ log M, ‖β‖ log M ≤ A` | proved |
| `zeta_taylor` | `‖ζ(1+s) − 1/s‖ ≤ C` for `‖s‖ < δ` | proved |
| `logM_le`, `logM_ge` | `log M ≤ θ log T`; `θ log T/2 ≤ log M` once `log T ≥ 4 log 2/θ` | proved |
| `key_bound`, `final_real` | the algebra `ζS − I/(s lm) = (ζ − 1/s)(I/lm + E) + E/s` and its size | proved |
| `StmtSdiagLead` | `S(α,β,0) = I(α,β)/log M + o(1/L)` uniformly on `Regime κ T` | OPEN (named Prop) |
| `stmtDiagMainO_of_lead` | `StmtSdiagLead → StmtDiagMainO`, `θ > 0`, `κ > 0` | proved |
| `psiMu_tendsto` (`DiagMainMu`) | `Σ_{n ≤ N} μ(n)/n · log(N/n) → 1` | proved |
| `StmtMuSmooth` | `Σ_{n ≤ x} μ(n) P(log(x/n)/log M) n^{−1−β} = βP(ℓ) + P′(ℓ)/log M + o(1/log M)`, `P(0) = 0` | OPEN (named Prop) |

`stmtDiagMainO_holds` (unconditional) is not built: it is `stmtDiagMainO_of_lead` once
`StmtSdiagLead` is discharged, by `StmtMuSmooth` (from `psiMu_tendsto` by partial summation), the
coprimality step, the `d`-sum `Σ_{d ≤ x} μ²(d) J(d) d^{−2−α−β} Π_{p|d}(…) F(log(M/d)/log M)`
and the swap `(h,k)^z = Σ_{d | (h,k)} (id^z * μ)(d)`. Hypotheses Lemma 7 uses there:
`P(0) = 0`, `0 < θ`; `θ < 1/2` is not needed for this lemma.

Axioms: [propext, Classical.choice, Quot.sound], pinned below on each main theorem.
-/
import Stage3.DiagMainStmt
import Stage3.DiagMainMu

namespace DiagMain

open Complex Filter Topology TwistedMoment Diagonal DiagMainStmt
open scoped ArithmeticFunction.Moebius

noncomputable section

/-! ## The integral of Young's (5.3) -/

/-- `I(α,β) = ∫₀¹ (P′(u) + α log M P(u))(P′(u) + β log M P(u)) du`, so `c₁ = I/((α+β) log M)`. -/
def IY (P : Polynomial ℝ) (M : ℕ) (α β : ℂ) : ℂ :=
  ∫ u in (0 : ℝ)..1,
    (((P.derivative.eval u : ℝ) : ℂ) + α * Real.log M * (P.eval u : ℝ)) *
      (((P.derivative.eval u : ℝ) : ℂ) + β * Real.log M * (P.eval u : ℝ))

theorem c1Y_eq (P : Polynomial ℝ) (M : ℕ) (α β : ℂ) :
    c1Y P M α β = 1 / ((α + β) * Real.log M) * IY P M α β := rfl

/-- `‖I(α,β)‖` is bounded once `‖α‖ log M, ‖β‖ log M ≤ A`. -/
theorem IY_bound (P : Polynomial ℝ) {A : ℝ} (hA : 0 ≤ A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ (M : ℕ) (α β : ℂ), ‖α‖ * Real.log M ≤ A → ‖β‖ * Real.log M ≤ A →
      ‖IY P M α β‖ ≤ C := by
  obtain ⟨B1, hB1⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (P.derivative.continuous.continuousOn (s := Set.Icc 0 1))
  obtain ⟨B0, hB0⟩ := (isCompact_Icc (a := (0 : ℝ)) (b := 1)).exists_bound_of_continuousOn
    (P.continuous.continuousOn (s := Set.Icc 0 1))
  have hB1' : 0 ≤ B1 := le_trans (norm_nonneg _) (hB1 0 ⟨le_refl _, zero_le_one⟩)
  have hB0' : 0 ≤ B0 := le_trans (norm_nonneg _) (hB0 0 ⟨le_refl _, zero_le_one⟩)
  refine ⟨(B1 + A * B0) * (B1 + A * B0), by positivity, fun M α β hα hβ => ?_⟩
  have hlog : 0 ≤ Real.log M := Real.log_natCast_nonneg M
  have fac : ∀ γ : ℂ, ‖γ‖ * Real.log M ≤ A → ∀ u ∈ Set.Icc (0 : ℝ) 1,
      ‖((P.derivative.eval u : ℝ) : ℂ) + γ * Real.log M * (P.eval u : ℝ)‖ ≤ B1 + A * B0 := by
    intro γ hγ u hu
    have h1 : ‖((P.derivative.eval u : ℝ) : ℂ)‖ ≤ B1 := by
      rw [Complex.norm_real]; exact hB1 u hu
    have h2 : ‖γ * (Real.log M : ℂ) * ((P.eval u : ℝ) : ℂ)‖ ≤ A * B0 := by
      rw [norm_mul, norm_mul, Complex.norm_real, Complex.norm_real, Real.norm_eq_abs,
        abs_of_nonneg hlog]
      have hp : ‖P.eval u‖ ≤ B0 := hB0 u hu
      calc ‖γ‖ * Real.log M * ‖P.eval u‖ ≤ A * ‖P.eval u‖ :=
            mul_le_mul_of_nonneg_right hγ (norm_nonneg _)
        _ ≤ A * B0 := mul_le_mul_of_nonneg_left hp hA
    have h2' : ‖γ * ((Real.log M : ℝ) : ℂ) * ((P.eval u : ℝ) : ℂ)‖ ≤ A * B0 := h2
    exact le_trans (norm_add_le _ _) (by linarith)
  have hint := intervalIntegral.norm_integral_le_of_norm_le_const
    (a := (0 : ℝ)) (b := 1) (C := (B1 + A * B0) * (B1 + A * B0))
    (f := fun u : ℝ => (((P.derivative.eval u : ℝ) : ℂ) + α * Real.log M * (P.eval u : ℝ)) *
      (((P.derivative.eval u : ℝ) : ℂ) + β * Real.log M * (P.eval u : ℝ))) (by
      intro u hu
      rw [Set.uIoc_of_le zero_le_one] at hu
      have hu' : u ∈ Set.Icc (0 : ℝ) 1 := ⟨hu.1.le, hu.2⟩
      rw [norm_mul]
      exact mul_le_mul (fac α hα u hu') (fac β hβ u hu') (norm_nonneg _) (by positivity))
  simpa [IY] using hint

/-! ## The Taylor step for `ζ(1+s)` -/

/-- `ζ(1+s) − 1/s` is bounded near `s = 0` (`isBigO_riemannZeta_sub_one_div`). -/
theorem zeta_taylor : ∃ C δ : ℝ, 0 ≤ C ∧ 0 < δ ∧ ∀ s : ℂ, ‖s‖ < δ →
    ‖riemannZeta (1 + s) - 1 / s‖ ≤ C := by
  obtain ⟨C, hC⟩ := (isBigO_riemannZeta_sub_one_div (F := ℂ)).bound
  rw [Metric.eventually_nhds_iff] at hC
  obtain ⟨δ, hδ, hball⟩ := hC
  refine ⟨max C 0, δ, le_max_right _ _, hδ, fun s hs => ?_⟩
  have hd : dist (1 + s) 1 < δ := by
    rw [dist_eq_norm, add_sub_cancel_left]; exact hs
  have := hball hd
  rw [add_sub_cancel_left, norm_one, mul_one] at this
  exact le_trans this (le_max_left _ _)

/-! ## `log M` against `L = log T` -/

theorem logM_le {T θ : ℝ} (hT : 1 ≤ T) (hθ : 0 ≤ θ) :
    Real.log (Mof T θ) ≤ θ * Real.log T := by
  unfold Mof
  rcases Nat.eq_zero_or_pos ⌊T ^ θ⌋₊ with h0 | hpos
  · rw [h0]; simp only [Nat.cast_zero, Real.log_zero]
    exact mul_nonneg hθ (Real.log_nonneg hT)
  · have hpos' : (0 : ℝ) < (⌊T ^ θ⌋₊ : ℝ) := by exact_mod_cast hpos
    have hle : (⌊T ^ θ⌋₊ : ℝ) ≤ T ^ θ := Nat.floor_le (by positivity)
    calc Real.log (⌊T ^ θ⌋₊ : ℝ) ≤ Real.log (T ^ θ) := Real.log_le_log hpos' hle
      _ = θ * Real.log T := Real.log_rpow (by linarith) θ

theorem logM_ge {T θ : ℝ} (hT : 1 < T) (hθ : 0 < θ)
    (hTθ : 4 * Real.log 2 / θ ≤ Real.log T) :
    θ * Real.log T / 2 ≤ Real.log (Mof T θ) := by
  unfold Mof
  have hT0 : 0 < T := by linarith
  have hx : Real.log 4 ≤ Real.log (T ^ θ) := by
    rw [Real.log_rpow hT0, show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    rw [div_le_iff₀ hθ] at hTθ
    have hc := mul_comm (Real.log T) θ
    have hl2 := Real.log_pos (by norm_num : (1 : ℝ) < 2)
    push_cast; linarith
  have hx4 : (4 : ℝ) ≤ T ^ θ := by
    have := Real.exp_le_exp.mpr hx
    rwa [Real.exp_log (by norm_num), Real.exp_log (by positivity)] at this
  have hfl : T ^ θ / 2 ≤ (⌊T ^ θ⌋₊ : ℝ) := by
    have := Nat.lt_floor_add_one (T ^ θ)
    linarith
  have hpos : (0 : ℝ) < T ^ θ / 2 := by positivity
  have h1 : Real.log (T ^ θ / 2) ≤ Real.log (⌊T ^ θ⌋₊ : ℝ) := Real.log_le_log hpos hfl
  rw [Real.log_div (by positivity) (by norm_num), Real.log_rpow hT0] at h1
  have h2 : Real.log 2 ≤ θ * Real.log T / 2 := by
    rw [div_le_iff₀ hθ] at hTθ; nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 2)]
  linarith

/-! ## The algebra of the reduction -/

/-- `ζ S − I/(s lm) = (ζ − 1/s)(I/lm + E) + E/s` with `S = I/lm + E`, bounded termwise. -/
theorem key_bound {z s I E : ℂ} {lm L Cz CI e κ : ℝ} (hlm : 0 < lm) (hL : 0 < L) (hκ : 0 < κ)
    (hz : ‖z - 1 / s‖ ≤ Cz) (hI : ‖I‖ ≤ CI) (hE : ‖E‖ ≤ e / L)
    (hsL : 1 / (κ * L) ≤ ‖s‖) :
    ‖z * (I / lm + E) - 1 / (s * lm) * I‖ ≤ Cz * (CI / lm + e / L) + κ * e := by
  have hs0 : 0 < ‖s‖ := lt_of_lt_of_le (by positivity) hsL
  have hs : s ≠ 0 := norm_pos_iff.mp hs0
  have hlm' : (lm : ℂ) ≠ 0 := by exact_mod_cast hlm.ne'
  have hid : z * (I / lm + E) - 1 / (s * lm) * I = (z - 1 / s) * (I / lm + E) + E / s := by
    field_simp; ring
  rw [hid]
  have hCz : 0 ≤ Cz := le_trans (norm_nonneg _) hz
  have hIE : ‖I / (lm : ℂ) + E‖ ≤ CI / lm + e / L := by
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_div, Complex.norm_real, Real.norm_eq_abs, abs_of_pos hlm]
    have : ‖I‖ / lm ≤ CI / lm := div_le_div_of_nonneg_right hI hlm.le
    linarith
  have hEs : ‖E / s‖ ≤ κ * e := by
    rw [norm_div, div_le_iff₀ hs0]
    have h1 : 1 ≤ κ * L * ‖s‖ := by
      rw [div_le_iff₀ (by positivity)] at hsL; linarith
    have he : 0 ≤ e / L := le_trans (norm_nonneg _) hE
    have he' : 0 ≤ e := by
      have := mul_nonneg he hL.le; rwa [div_mul_cancel₀ _ hL.ne'] at this
    calc ‖E‖ ≤ e / L := hE
      _ = e / L * 1 := by ring
      _ ≤ e / L * (κ * L * ‖s‖) := mul_le_mul_of_nonneg_left h1 he
      _ = κ * e * ‖s‖ := by field_simp
  calc ‖(z - 1 / s) * (I / lm + E) + E / s‖
      ≤ ‖(z - 1 / s) * (I / lm + E)‖ + ‖E / s‖ := norm_add_le _ _
    _ ≤ Cz * (CI / lm + e / L) + κ * e := by
      rw [norm_mul]
      have := mul_le_mul hz hIE (norm_nonneg _) hCz
      linarith

/-- The real arithmetic closing the reduction: the three pieces are each `≤ ε/3`. -/
theorem final_real {Cz CI lm L e κ ε θ : ℝ} (hCz : 0 ≤ Cz) (hCI : 0 ≤ CI) (hθ : 0 < θ)
    (hε : 0 < ε) (hκ : 0 < κ) (hL : 0 < L) (hlm : θ * L / 2 ≤ lm)
    (hL1 : 6 * Cz * CI / (θ * ε) ≤ L) (hL2 : Cz ≤ L) (he : e = ε / (3 * (κ + 1))) :
    Cz * (CI / lm + e / L) + κ * e ≤ ε := by
  have hlm0 : 0 < lm := lt_of_lt_of_le (by positivity) hlm
  have he0 : 0 ≤ e := by rw [he]; positivity
  have h1 : Cz * (CI / lm) ≤ ε / 3 := by
    have hq : CI / lm ≤ CI / (θ * L / 2) :=
      div_le_div_of_nonneg_left hCI (by positivity) hlm
    have h6 : 6 * Cz * CI ≤ L * (θ * ε) := by
      rwa [div_le_iff₀ (by positivity)] at hL1
    have hq2 : Cz * (CI / (θ * L / 2)) ≤ ε / 3 := by
      rw [show Cz * (CI / (θ * L / 2)) = (2 * Cz * CI) / (θ * L) by field_simp,
        div_le_iff₀ (by positivity)]
      nlinarith
    calc Cz * (CI / lm) ≤ Cz * (CI / (θ * L / 2)) := mul_le_mul_of_nonneg_left hq hCz
      _ ≤ ε / 3 := hq2
  have h2 : Cz * (e / L) ≤ e := by
    rw [show Cz * (e / L) = e * (Cz / L) by ring]
    have : Cz / L ≤ 1 := by rw [div_le_one hL]; exact hL2
    calc e * (Cz / L) ≤ e * 1 := mul_le_mul_of_nonneg_left this he0
      _ = e := mul_one e
  have h3 : (κ + 1) * e = ε / 3 := by rw [he]; field_simp
  have : Cz * (CI / lm + e / L) = Cz * (CI / lm) + Cz * (e / L) := by ring
  nlinarith

/-! ## The reduction -/

/-- OPEN, **the leading term of `S`**: `S(α,β,0) = I(α,β)/log M + o(1/L)` uniformly on
`Regime κ T`. This is the whole arithmetic content of Young's Lemma 7; the `ζ` factor is
`stmtDiagMainO_of_lead`. -/
def StmtSdiagLead (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
    ‖Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 -
      IY P (Mof T θ) α β / (Real.log (Mof T θ) : ℂ)‖ ≤ ε / Real.log T

/-- **The Taylor step**: `StmtSdiagLead → StmtDiagMainO`, for `θ > 0`, `κ > 0`. -/
theorem stmtDiagMainO_of_lead (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 < θ) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (h : StmtSdiagLead P θ R κ) : StmtDiagMainO P θ R κ := by
  intro ε hε
  obtain ⟨Cz, δ, hCz, hδ, hzeta⟩ := zeta_taylor
  obtain ⟨CI, hCI0, hCI⟩ := IY_bound P (A := κ * θ) (by positivity)
  set e := ε / (3 * (κ + 1)) with he
  have he0 : 0 < e := by positivity
  obtain ⟨T₁, hT₁⟩ := h e he0
  set L₀ := max (max 1 (4 * Real.log 2 / θ)) (max (4 * κ / δ) (max (6 * Cz * CI / (θ * ε)) Cz))
    with hL₀
  refine ⟨max T₁ (Real.exp L₀), fun T hT α β hreg => ?_⟩
  have hTe : Real.exp L₀ ≤ T := le_trans (le_max_right _ _) hT
  have hL0T : L₀ ≤ Real.log T := by
    rw [← Real.log_exp L₀]; exact Real.log_le_log (Real.exp_pos _) hTe
  have hL1 : 1 ≤ Real.log T := le_trans (le_trans (le_max_left _ _) (le_max_left _ _)) hL0T
  have hLpos : 0 < Real.log T := by linarith
  have hL₀1 : 1 ≤ L₀ := le_trans (le_max_left _ _) (le_max_left _ _)
  have hT1 : 1 < T := lt_of_lt_of_le (Real.one_lt_exp_iff.mpr (by linarith)) hTe
  have hLθ : 4 * Real.log 2 / θ ≤ Real.log T :=
    le_trans (le_trans (le_max_right _ _) (le_max_left _ _)) hL0T
  have hLδ : 4 * κ / δ ≤ Real.log T :=
    le_trans (le_trans (le_max_left _ _) (le_max_right _ _)) hL0T
  have hLC1 : 6 * Cz * CI / (θ * ε) ≤ Real.log T :=
    le_trans (le_trans (le_max_left _ _) (le_trans (le_max_right _ _) (le_max_right _ _))) hL0T
  have hLC2 : Cz ≤ Real.log T :=
    le_trans (le_trans (le_max_right _ _) (le_trans (le_max_right _ _) (le_max_right _ _))) hL0T
  obtain ⟨hα, hβ, hαβ⟩ := hreg
  set L := Real.log T with hLdef
  set lm := Real.log (Mof T θ) with hlmdef
  have hlm_ge : θ * L / 2 ≤ lm := logM_ge hT1 hθ0 hLθ
  have hlm_le : lm ≤ θ * L := logM_le hT1.le hθ0.le
  have hlm0 : 0 < lm := lt_of_lt_of_le (by positivity) hlm_ge
  -- `‖α+β‖ < δ`
  have hsδ : ‖α + β‖ < δ := by
    have h2 : ‖α + β‖ ≤ 2 * κ / L := by
      have := norm_add_le α β
      rw [show 2 * κ / L = κ / L + κ / L by ring]; linarith
    have h3 : 2 * κ / L < δ := by
      rw [div_le_iff₀ hδ] at hLδ
      rw [div_lt_iff₀ hLpos]; nlinarith
    linarith
  have hz := hzeta (α + β) hsδ
  -- `‖α‖ log M ≤ κθ`
  have hA : ∀ γ : ℂ, ‖γ‖ ≤ κ / L → ‖γ‖ * Real.log (Mof T θ) ≤ κ * θ := by
    intro γ hγ
    calc ‖γ‖ * lm ≤ κ / L * (θ * L) :=
          mul_le_mul hγ hlm_le hlm0.le (by positivity)
      _ = κ * θ := by field_simp
  have hI := hCI (Mof T θ) α β (hA α hα) (hA β hβ)
  have hE := hT₁ T (le_trans (le_max_left _ _) hT) α β ⟨hα, hβ, hαβ⟩
  have hkey := key_bound (z := riemannZeta (1 + (α + β))) (s := α + β)
    (I := IY P (Mof T θ) α β)
    (E := Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 -
      IY P (Mof T θ) α β / (Real.log (Mof T θ) : ℂ)) hlm0 hLpos hκ hz hI hE hαβ
  rw [add_sub_cancel] at hkey
  rw [c1Y_eq, add_assoc]
  refine le_trans hkey ?_
  exact final_real hCz hCI0 hθ0 hε hκ hLpos hlm_ge hLC1 hLC2 he

/-! ## The per-`d` step, `d = 1` -/

/-- OPEN, **the smooth Möbius sum to `o(1/log M)`** (the per-`d` step of the route at `d = 1`):
for `P(0) = 0`, `Σ_{n ≤ x} μ(n) P(log(x/n)/log M) n^{−1−β} = βP(ℓ) + P′(ℓ)/log M + o(1/log M)`,
`ℓ = log x/log M`, uniformly for `Y ≤ x ≤ M` and `‖β‖ log M ≤ κ`. Route: `n^{−β} = x^{−β}
e^{β log(x/n)}`, partial summation of `F(u) = e^{βu} P(u/log M)` (`F(0) = 0`) against
`psiMu_tendsto`; `F″ = O(1/log² M)` and `∫₁^x |ψ_μ − 1| ds/s = o(log x)`. -/
def StmtMuSmooth (P : Polynomial ℝ) (κ : ℝ) : Prop :=
  P.eval 0 = 0 → ∀ ε : ℝ, 0 < ε → ∃ Y N₀ : ℕ, ∀ M : ℕ, N₀ ≤ M → ∀ x : ℕ, Y ≤ x → x ≤ M →
    ∀ β : ℂ, ‖β‖ * Real.log M ≤ κ →
      ‖∑ n ∈ Finset.Ioc 0 x, ((μ n : ℝ) : ℂ) *
          ((P.eval (Real.log ((x : ℝ) / n) / Real.log M) : ℝ) : ℂ) * (n : ℂ) ^ (-(1 + β)) -
        (β * ((P.eval (Real.log x / Real.log M) : ℝ) : ℂ) +
          ((P.derivative.eval (Real.log x / Real.log M) : ℝ) : ℂ) / (Real.log M : ℂ))‖ ≤
        ε / Real.log M

end

/-- info: 'DiagMain.stmtDiagMainO_of_lead' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtDiagMainO_of_lead

/-- info: 'DiagMain.zeta_taylor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_taylor

/-- info: 'DiagMain.IY_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms IY_bound

/-- info: 'DiagMain.logM_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logM_ge

end DiagMain
