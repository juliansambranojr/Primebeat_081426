/-
# FloorLongStep — block S13 of `lean_stage3/design/stencil.md`, B1, the floor for every length: one dyadic window. 2026-11-25.

`FloorStep.floor_step` for every `θ > 0`, from the mollified mean (`Operator.StmtMollMeanO`,
given at length `θ` by `FloorLongMean.mollMean_long`): for `P(1) = 1`, `R > 0`, every `ε > 0`,
from some height on,

  `(N T − N(T/2)) − (log K / R)·(N T − N(T/2)) − ε T log T ≤ lineCount T − lineCount (T/2)`,

`K = max 1 (Re D[c](−R/L, −R/L) + ε)`. The proof is `floor_step`'s with three changes, all
where `floor_step` used `θ < 1/2` as `θ ≤ 1`, i.e. `M ≤ T`:
* `M ≤ T^n`, `n = ⌈θ⌉₊`, and `X = log₂(A T^n)` (was `log₂(A T)`), so `tailDelta ≤ τ` and
  `32 M B ≤ 2^X` hold as before (`tail_le`, `XMB_le` at `T^n`);
* `X ≤ 4 n L`, `log M ≤ n L`, so the edge terms are `≤ π C_w n³ L³` (`W2_long`), and
  `2X ≤ T/2` from `2000 n L ≤ T`;
* `‖D[c]‖ ≤ K₀` from `dop_bdd_long`.

The sizes, checked before the proof: `n` is fixed with `θ`, so the edge terms stay `O(L⁴)`
against the error `ε T L`, and the tail term `T L tailDelta/(πR)` is unchanged since
`tailDelta ≤ τ` does not see `n`. No factor that grows with `T` is lost; the constant `C_w`
grows as `n³ = O(θ³)`, which only moves the height.

| name | content | status |
|---|---|---|
| `W2_long` | the window's edge terms `≤ π C_w n³ L³` for `X ≤ 4nL`, `log M ≤ nL` | proved |
| `floor_step_long` | Levinson's floor on `[T/2, T]` from `StmtMollMeanO`, every `θ > 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorLongMean
import Stage3.FloorStep

namespace FloorLong

open Complex MeasureTheory Set Filter Topology TwistedMoment FloorStep

/-- **The edge terms for every length**: `W2_le` at `n L`, and the expression is monotone in `L`. -/
theorem W2_long {X L lM lB B n : ℝ} (hn : 1 ≤ n) (hX3 : 3 ≤ X) (hX : X ≤ 4 * (n * L))
    (hL : 1 ≤ L) (hlM0 : 0 ≤ lM) (hlM : lM ≤ n * L) (hlB0 : 0 ≤ lB) (hlB : lB ≤ B) :
    X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1) * (L + lM + lB + 8) + 1)))
      ≤ Real.pi * ((12 + 256 * (10 + B)) * n ^ 3) * L ^ 3 := by
  have hπ := Real.pi_pos
  have hnL : L ≤ n * L := le_mul_of_one_le_left (by linarith) hn
  have h := W2_le hX3 hX (by linarith) hlM0 hlM hlB0 hlB
  have hm : (8 * X - 1) * (L + lM + lB + 8) ≤ (8 * X - 1) * (n * L + lM + lB + 8) :=
    mul_le_mul_of_nonneg_left (by linarith) (by linarith)
  have hm2 : X * (Real.pi * ((8 * X - 1) * (L + lM + lB + 8) + 1)) ≤
      X * (Real.pi * ((8 * X - 1) * (n * L + lM + lB + 8) + 1)) := by
    apply mul_le_mul_of_nonneg_left _ (by linarith)
    apply mul_le_mul_of_nonneg_left _ hπ.le
    linarith
  have e : Real.pi * (12 + 256 * (10 + B)) * (n * L) ^ 3 =
      Real.pi * ((12 + 256 * (10 + B)) * n ^ 3) * L ^ 3 := by ring
  linarith

/-- **Levinson's floor on one dyadic window, every length.** `FloorStep.floor_step` from the
mollified mean at length `θ`: for `P(1) = 1`, `θ > 0`, `R > 0`, every `ε > 0`, from some height
on, `(1 − log K/R)(N T − N(T/2)) − ε T log T ≤ lineCount T − lineCount(T/2)`,
`K = max 1 (Re D[c](−R/L, −R/L) + ε)`. -/
theorem floor_step_long (P : Polynomial ℝ) (hP1 : P.eval 1 = 1) {θ : ℝ} (hθ0 : 0 < θ) {R : ℝ}
    (hR : 0 < R) (hMM : Operator.StmtMollMeanO P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (riemannZeta.N T - riemannZeta.N (T / 2))
        - Real.log (max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
            ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) / R
          * (riemannZeta.N T - riemannZeta.N (T / 2))
        - ε * T * Real.log T
        ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
  intro ε hε
  obtain ⟨Bc, hBc1, hBc⟩ := betaC_bound P
  obtain ⟨K₀, hK₀0, TK, hD⟩ := dop_bdd_long P hθ0 hR
  obtain ⟨T₁, hT₁⟩ := unsmooth_near_levinson_long P hθ0 hR hMM (ε / 2) (half_pos hε)
  obtain ⟨n, hndef⟩ : ∃ n : ℕ, n = ⌈θ⌉₊ := ⟨_, rfl⟩
  have hθn : θ ≤ (n : ℝ) := by rw [hndef]; exact Nat.le_ceil θ
  have hn1 : 1 ≤ n := by rw [hndef]; exact Nat.one_le_iff_ne_zero.mpr (Nat.ceil_pos.mpr hθ0).ne'
  have hn1' : (1 : ℝ) ≤ n := by exact_mod_cast hn1
  have hπ := Real.pi_pos
  obtain ⟨τ, hτdef⟩ : ∃ τ : ℝ, τ = min 1 (ε * Real.pi * R / 4) := ⟨_, rfl⟩
  have hτ0 : 0 < τ := by rw [hτdef]; exact lt_min one_pos (by positivity)
  have hτ1 : τ ≤ 1 := by rw [hτdef]; exact min_le_left _ _
  have hτε : τ ≤ ε * Real.pi * R / 4 := by rw [hτdef]; exact min_le_right _ _
  obtain ⟨A, hAdef⟩ : ∃ A : ℝ, A = 64 * (Bc + 1) / τ := ⟨_, rfl⟩
  have hAτ : 64 * (Bc + 1) ≤ A * τ := by rw [hAdef, div_mul_cancel₀ _ hτ0.ne']
  have hA1 : 1 ≤ A := by
    rw [hAdef, le_div_iff₀ hτ0]; nlinarith
  obtain ⟨Kb, hKbdef⟩ : ∃ Kb : ℝ, Kb = K₀ + ε + 1 := ⟨_, rfl⟩
  obtain ⟨Cw, hCwdef⟩ : ∃ Cw : ℝ, Cw = (12 + 256 * (10 + Bc)) * (n : ℝ) ^ 3 := ⟨_, rfl⟩
  obtain ⟨Lm, hLmdef⟩ : ∃ Lm : ℝ, Lm = max (8 * R) (max (Real.log A) (max (8 * Kb / (R * ε)) 26)) :=
    ⟨_, rfl⟩
  have ev : ∀ᶠ T : ℝ in atTop, (Real.exp 26 ≤ T ∧ T₁ ≤ T ∧ TK ≤ T ∧ 4 * 3052 / ε ≤ T ∧ 8 ≤ T) ∧
      (2 : ℝ) ≤ T ^ θ ∧ Lm ≤ Real.log T ∧ 2000 * (n : ℝ) * Real.log T ^ 1 ≤ T ∧
      4 * Cw / (R * ε) * Real.log T ^ 3 ≤ T := by
    refine ((((eventually_ge_atTop (Real.exp 26)).and (eventually_ge_atTop T₁)).and
      ((eventually_ge_atTop TK).and ((eventually_ge_atTop (4 * 3052 / ε)).and
      (eventually_ge_atTop (8 : ℝ))))).and
      (((tendsto_rpow_atTop hθ0).eventually_ge_atTop 2).and
      ((Real.tendsto_log_atTop.eventually_ge_atTop Lm).and
      ((eventually_logpow_le (2000 * (n : ℝ)) 1).and (eventually_logpow_le (4 * Cw / (R * ε)) 3))))).mono ?_
    rintro T ⟨⟨⟨h1, h2⟩, h3, h4, h5⟩, h6, h7, h8, h9⟩
    exact ⟨⟨h1, h2, h3, h4, h5⟩, h6, h7, h8, h9⟩
  obtain ⟨T₀, hT₀⟩ := eventually_atTop.mp ev
  refine ⟨T₀, fun T hT => ?_⟩
  obtain ⟨⟨hT26, hTT₁, hTK, hT134, hT8⟩, hTθ, hLm, hT2000, hTCw⟩ := hT₀ T hT
  -- the height
  have hT27 : (27 : ℝ) ≤ T := by linarith [Real.add_one_le_exp (26 : ℝ)]
  have hT1 : (1 : ℝ) ≤ T := by linarith
  have hT0 : (0 : ℝ) < T := by linarith
  have hLm1 : 26 ≤ Lm := by rw [hLmdef]; exact le_max_of_le_right (le_max_of_le_right (le_max_right _ _))
  have hLm2 : 8 * R ≤ Lm := by rw [hLmdef]; exact le_max_left _ _
  have hLm3 : Real.log A ≤ Lm := by rw [hLmdef]; exact le_max_of_le_right (le_max_left _ _)
  have hLm4 : 8 * Kb / (R * ε) ≤ Lm := by
    rw [hLmdef]; exact le_max_of_le_right (le_max_of_le_right (le_max_left _ _))
  have hL26 : 26 ≤ Real.log T := hLm1.trans hLm
  have hL1 : 1 ≤ Real.log T := by linarith
  have hLpos : 0 < Real.log T := by linarith
  rw [pow_one] at hT2000
  -- `M`
  have hM2 : 2 ≤ Mof T θ := by
    unfold Mof
    exact Nat.le_floor (by exact_mod_cast hTθ)
  have hM : 1 ≤ Mof T θ := by omega
  have hMT : (Mof T θ : ℝ) ≤ T ^ n := by
    unfold Mof
    refine (Nat.floor_le (Real.rpow_nonneg hT0.le _)).trans ?_
    have := Real.rpow_le_rpow_of_exponent_le hT1 hθn
    rwa [Real.rpow_natCast] at this
  have hTn : T ≤ T ^ n := le_self_pow₀ hT1 (by omega)
  have hTn1 : (1 : ℝ) ≤ T ^ n := hT1.trans hTn
  have hlTn : Real.log (T ^ n) = (n : ℝ) * Real.log T := Real.log_pow T n
  have hM0 : (0 : ℝ) < Mof T θ := by exact_mod_cast (show 0 < Mof T θ by omega)
  -- `σ₀`
  have hσe : 1 / 2 - sig0 T R = R / Real.log T := by unfold sig0; ring
  have hRL : R / Real.log T ≤ 1 / 8 := by
    rw [div_le_iff₀ hLpos]; linarith [hLm2.trans hLm]
  have hRL0 : 0 < R / Real.log T := by positivity
  have hσlt : sig0 T R < 1 / 2 := by linarith
  have hσge : 3 / 8 ≤ sig0 T R := by linarith
  -- `X`
  obtain ⟨X, hXdef⟩ : ∃ X : ℝ, X = Real.logb 2 (A * T ^ n) := ⟨_, rfl⟩
  have hq : (2 : ℝ) ^ X = A * T ^ n := by
    rw [hXdef]; exact Real.rpow_logb (by norm_num) (by norm_num) (by positivity)
  have hLn : Real.log T ≤ (n : ℝ) * Real.log T := le_mul_of_one_le_left hLpos.le hn1'
  obtain ⟨hX3, hX4⟩ := X_bounds hA1 hTn1 (by nlinarith) (by rw [hlTn]; linarith)
  rw [← hXdef] at hX3 hX4
  rw [hlTn] at hX4
  have htd : LevinsonMollEdge.tailDelta (Mof T θ) Bc X ≤ τ :=
    tail_le (by linarith) hτ0 hτ1 hAτ hTn1 hMT hq
  have hXMB : 32 * (Mof T θ : ℝ) * Bc ≤ (2 : ℝ) ^ X := XMB_le (by linarith) hτ0 hτ1 hAτ hMT hq
  have hXa : 2 * X ≤ T / 2 := by linarith
  -- `δ` and `K`
  obtain ⟨δ, hδ, hδ8, hδK⟩ := hK_shift (1 / Real.log T) (Mof T θ) (betaC P T θ R)
    (σ₀ := sig0 T R) (T := T)
    (V := (Operator.Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ)).re) (ε := ε) (by linarith) hε (by
      intro a' b' h1 h2 h3 h4
      have := hT₁ T hTT₁ _ rfl a' b' h1 h2 h3 h4
      unfold Fint
      rw [molli_betaC]
      exact this)
  have hK1 : (1 : ℝ) ≤ max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε) := le_max_left _ _
  have hwin := LevinsonWindowNear.levinson_window_diff (T := T) (a := T / 2) (b := T)
    (c := 1 / Real.log T) (σ₀ := sig0 T R) (δ := δ) (X := X) (B := Bc) (M := Mof T θ)
    (β := betaC P T θ R) hT26 rfl hM (betaC_one P hP1 hM2) (hBc T θ R hσlt.le) hσlt hδ
    (by linarith) hX3 hXMB hXa (by linarith) le_rfl hK1 (by
      intro a' b' ha1 ha2 hb1 hb2 hab σ hσ
      have := hδK a' b' ha1 ha2 hb1 hb2 hab σ hσ
      unfold Fint at this
      exact this.trans (le_max_right _ _))
  rw [hσe] at hwin
  -- the window's edge terms
  obtain ⟨Wp, hWpdef⟩ : ∃ Wp : ℝ, Wp = X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1)
      * (Real.log T + Real.log (Mof T θ : ℝ) + Real.log Bc + 8) + 1))) := ⟨_, rfl⟩
  have hWe : LevinsonWindow.windowE (Mof T θ) Bc X T (T / 2) T =
      (T - T / 2) * (2 * LevinsonMollEdge.tailDelta (Mof T θ) Bc X) + Wp := by
    rw [hWpdef]; unfold LevinsonWindow.windowE; ring
  rw [hWe] at hwin
  have hlM0 : 0 ≤ Real.log (Mof T θ : ℝ) := Real.log_nonneg (by exact_mod_cast hM)
  have hlM : Real.log (Mof T θ : ℝ) ≤ (n : ℝ) * Real.log T := by
    rw [← hlTn]; exact Real.log_le_log hM0 hMT
  have hlB0 : 0 ≤ Real.log Bc := Real.log_nonneg hBc1
  have hlB : Real.log Bc ≤ Bc := by
    have := Real.log_le_sub_one_of_pos (show 0 < Bc by linarith); linarith
  have hWp : Wp ≤ Real.pi * Cw * Real.log T ^ 3 := by
    rw [hWpdef, hCwdef]; exact W2_long hn1' hX3 hX4 hL1 hlM0 hlM hlB0 hlB
  -- `log K`
  have hDre := (Complex.re_le_norm (Operator.Dop (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ))).trans (hD T hTK)
  have hlK0 := Real.log_nonneg hK1
  have hlK : Real.log (max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) ≤ Kb := by
    have h1 := Real.log_le_sub_one_of_pos (show (0 : ℝ) < max 1 ((Operator.Dop (Real.log T)
      (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)
      by linarith)
    have h2 : max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε) ≤ K₀ + ε + 1 :=
      max_le (by linarith) (by linarith)
    rw [hKbdef]; linarith
  exact combine hL1 hT0 hR hε hwin htd hτε hWp hTCw (N_window_ge (by linarith)) hlK0 hlK
    (by linarith) (hLm4.trans hLm) hT134

/-- info: 'FloorLong.W2_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms W2_long

/-- info: 'FloorLong.floor_step_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_step_long

end FloorLong
