/-
# FloorStep — block S12 of `lean_stage3/design/stencil.md`, piece 5b, one height: Levinson's floor on `[T/2, T]`. 2026-11-25.

For `P(0) = 0`, `P(1) = 1`, `0 < θ < 1/2`, `R > 0` and every `ε > 0`, from some height on,

  `(N T − N(T/2)) − (log K / R)·(N T − N(T/2)) − ε T log T ≤ lineCount T − lineCount (T/2)`,

`K = max 1 (Re D[c](−R/L, −R/L) + ε)`, `L = log T`, `D[c] = Dop L (cY P (Mof T θ) T)`. The
`max 1` is `levinson_window_diff`'s `hK1 : 1 ≤ K`; nothing in the tree yet puts `Re D + ε ≥ 1`,
and where it holds the two forms agree.

The route: `LevinsonWindowNear.levinson_window_diff` at `a = T/2`, `b = T`, its `T := T`,
`c = 1/L`, `σ₀ = sig0 T R` (so `1/2 − σ₀ = R/L` and the prefactor is `L/(πR)`),
`β = betaC` (Young's `aY` cut to `[1, M]`, `β 1 = P(1) = 1`, `‖β h‖ ≤ B` a constant),
`M = Mof T θ`, `X = log₂(A T)`, `K` as above; `hK` from `Unsmooth.unsmooth_near_levinson` at
`ε/2` (`σ = σ₀`) carried to `[σ₀ − δ(T), σ₀]` by `FloorStepCont.hK_shift` at `ε/2`.

The sizes, checked before the proof (`FloorStepSize`), each error term `≤ (ε/4) T L`:

| term | size | why it is small |
|---|---|---|
| main, `(L/(πR))·(T/4)·log K` | `(log K/R)·T L/(4π)` | `T L/(4π) ≤ N T − N(T/2) + T + 224 L + 1396` (`N_window_ge`, from `ArgCount.rvM_crude`); `0 ≤ log K ≤ K₀ + ε + 1`, so the excess is `O(T) ≤ (ε/4) T L` once `L ≥ 8(K₀ + ε + 1)/(Rε)` |
| tail, `(L/(πR))·(T/2)·2·tailDelta` | `T L tailDelta/(πR)` | `tailDelta ≤ τ ≤ επR/4` by `2^X = A T`, `A τ = 64(B + 1)` |
| edges, `(L/(πR))·(Xπ + 2Xπ((8X − 1)(L + log M + log B + 8) + 1))` | `≤ C_w L⁴/R` | `X ≤ 4L`; `(4 C_w/(Rε)) L³ ≤ T` eventually |
| `134 log T + 2918` | `≤ 3052 L` | `T ≥ 4·3052/ε` |

**The lost factor this avoids.** With only `32 M B ≤ 2^X` (`tailDelta ≤ 1/2`, about `1/4` at
equality) the tail term is about `T L/(4πR)`, the size of the main term: a factor `L` against
the error `o(T)` that `windowE` needs. `X = log₂(A T) = O(L)` with `A ≍ 1/ε` gives
`tailDelta ≤ τ`; the cost is `X² L² = O(L⁴)`, `o(T L)`.

The hypotheses of `levinson_window_diff`, at the height: `hT` (`e^26 ≤ T`), `hc` (`rfl`),
`hM` (`M ≥ 2` from `T^θ ≥ 2`), `hβ1` (`betaC_one`), `hβ` (`betaC_bound`, needs `σ₀ ≤ 1/2`),
`hσ₀` (`R/L > 0`), `hδ`, `hσδ` (`σ₀ ≥ 3/8` from `L ≥ 8R`, `δ ≤ 1/8`), `hX` (`A T ≥ 8`),
`hXMB` (`M ≤ T`, `A ≥ 32 B`), `hXa` (`2X ≤ 8L ≤ T/2` from `2000 L ≤ T`), `hab` (`T ≥ 8`),
`hbT` (`le_rfl`), `hK1` (`le_max_left`), `hK`.

| name | content | status |
|---|---|---|
| `combine` | the arithmetic: the window's inequality with its four error terms bounded | proved |
| `floor_step` | Levinson's floor on `[T/2, T]`, every `ε > 0`, from some height on | proved |

Open (piece 5c, not here): the sum over halvings and the `liminf`; the closed form of
`Re D[c]` (piece 5a, `FloorConst`).

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorStepSize
import Stage3.FloorStepCont

namespace FloorStep

open Complex MeasureTheory Set Filter Topology TwistedMoment

/-- **The arithmetic of the floor.** The window's inequality with its terms bounded: each of the
four error terms costs at most `(ε/4) T L`. -/
theorem combine {ND LC L T lK Kb R ε td Wp τ Cw : ℝ}
    (hL1 : 1 ≤ L) (hT0 : 0 < T) (hR : 0 < R) (hε : 0 < ε)
    (hwin : ND - (1 / (Real.pi * (R / L))) * ((T - T / 2) / 2 * lK + ((T - T / 2) * (2 * td) + Wp))
      - (134 * L + 2918) ≤ LC)
    (htd : td ≤ τ) (hτ : τ ≤ ε * Real.pi * R / 4)
    (hWp : Wp ≤ Real.pi * Cw * L ^ 3) (hCw : 4 * Cw / (R * ε) * L ^ 3 ≤ T)
    (hN : T * L / (4 * Real.pi) - ND ≤ T + 224 * L + 1396)
    (hlK0 : 0 ≤ lK) (hlK : lK ≤ Kb) (hT224 : 224 * L + 1396 ≤ T)
    (hKbL : 8 * Kb / (R * ε) ≤ L) (h134 : 4 * 3052 / ε ≤ T) :
    ND - lK / R * ND - ε * T * L ≤ LC := by
  have hπ := Real.pi_pos
  have hL0 : 0 < L := by linarith
  have hF : 1 / (Real.pi * (R / L)) = L / (Real.pi * R) := by field_simp
  rw [hF] at hwin
  have hFp : 0 < L / (Real.pi * R) := by positivity
  -- the main term
  have e1 : L / (Real.pi * R) * ((T - T / 2) / 2 * lK) = lK / R * (T * L / (4 * Real.pi)) := by
    field_simp; ring
  have hlKR : 0 ≤ lK / R := by positivity
  have m1 : lK / R * (T * L / (4 * Real.pi)) ≤ lK / R * ND + lK / R * (T + 224 * L + 1396) := by
    have := mul_le_mul_of_nonneg_left hN hlKR
    nlinarith
  have hKb0 : 0 ≤ Kb := hlK0.trans hlK
  have m2 : lK / R * (T + 224 * L + 1396) ≤ Kb / R * (2 * T) := by
    apply mul_le_mul (div_le_div_of_nonneg_right hlK hR.le) (by linarith) (by positivity)
      (by positivity)
  have m3 : Kb / R * (2 * T) ≤ ε / 4 * T * L := by
    rw [div_le_iff₀ (by positivity)] at hKbL
    have e : Kb / R * (2 * T) = (8 * Kb) * T / (4 * R) := by field_simp; ring
    rw [e, div_le_iff₀ (by positivity)]
    nlinarith
  -- the tail term
  have m4 : L / (Real.pi * R) * ((T - T / 2) * (2 * td)) ≤ ε / 4 * T * L := by
    have e : L / (Real.pi * R) * ((T - T / 2) * (2 * td)) = (L * T / (Real.pi * R)) * td := by
      field_simp; ring
    rw [e]
    have hLT : 0 ≤ L * T / (Real.pi * R) := by positivity
    calc L * T / (Real.pi * R) * td ≤ L * T / (Real.pi * R) * (ε * Real.pi * R / 4) :=
          mul_le_mul_of_nonneg_left (htd.trans hτ) hLT
      _ = ε / 4 * T * L := by field_simp
  -- the polynomial edge terms
  have m5 : L / (Real.pi * R) * Wp ≤ ε / 4 * T * L := by
    have h1 := mul_le_mul_of_nonneg_left hWp hFp.le
    have e : L / (Real.pi * R) * (Real.pi * Cw * L ^ 3) = L * (Cw * L ^ 3 / R) := by
      field_simp
    rw [e] at h1
    have h2 : Cw * L ^ 3 / R ≤ ε / 4 * T := by
      have e2 : 4 * Cw / (R * ε) * L ^ 3 = (Cw * L ^ 3 / R) / (ε / 4) := by field_simp
      rw [e2, div_le_iff₀ (by positivity)] at hCw
      linarith
    have h3 := mul_le_mul_of_nonneg_left h2 hL0.le
    nlinarith
  -- the constant term
  have m6 : 134 * L + 2918 ≤ ε / 4 * T * L := by
    rw [div_le_iff₀ hε] at h134
    nlinarith
  have hsplit : L / (Real.pi * R) * ((T - T / 2) / 2 * lK + ((T - T / 2) * (2 * td) + Wp)) =
      L / (Real.pi * R) * ((T - T / 2) / 2 * lK) + L / (Real.pi * R) * ((T - T / 2) * (2 * td))
        + L / (Real.pi * R) * Wp := by ring
  rw [hsplit, e1] at hwin
  have e3 : ε * T * L = ε / 4 * T * L * 4 := by ring
  rw [e3]
  linarith



/-- **S12 piece 5b, Levinson's floor on one dyadic window.** For `P(0) = 0`, `P(1) = 1`,
`0 < θ < 1/2`, `R > 0`, every `ε > 0`: from some height on, the zeros on the line with height in
`(T/2, T]` number at least `(1 − log K/R)(N T − N(T/2)) − ε T log T`, with
`K = max 1 (Re D[c](−R/L, −R/L) + ε)`, `L = log T`. -/
theorem floor_step (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (riemannZeta.N T - riemannZeta.N (T / 2))
        - Real.log (max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
            ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) / R
          * (riemannZeta.N T - riemannZeta.N (T / 2))
        - ε * T * Real.log T
        ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
  intro ε hε
  obtain ⟨Bc, hBc1, hBc⟩ := betaC_bound P
  obtain ⟨K₀, hK₀0, TK, hD⟩ := Unsmooth.dop_cY_bdd P hθ0 hθ hR
  obtain ⟨T₁, hT₁⟩ := Unsmooth.unsmooth_near_levinson P hP0 hθ0 hθ hR (ε / 2) (half_pos hε)
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
  obtain ⟨Cw, hCwdef⟩ : ∃ Cw : ℝ, Cw = 12 + 256 * (10 + Bc) := ⟨_, rfl⟩
  obtain ⟨Lm, hLmdef⟩ : ∃ Lm : ℝ, Lm = max (8 * R) (max (Real.log A) (max (8 * Kb / (R * ε)) 26)) :=
    ⟨_, rfl⟩
  have ev : ∀ᶠ T : ℝ in atTop, (Real.exp 26 ≤ T ∧ T₁ ≤ T ∧ TK ≤ T ∧ 4 * 3052 / ε ≤ T ∧ 8 ≤ T) ∧
      (2 : ℝ) ≤ T ^ θ ∧ Lm ≤ Real.log T ∧ 2000 * Real.log T ^ 1 ≤ T ∧
      4 * Cw / (R * ε) * Real.log T ^ 3 ≤ T := by
    refine ((((eventually_ge_atTop (Real.exp 26)).and (eventually_ge_atTop T₁)).and
      ((eventually_ge_atTop TK).and ((eventually_ge_atTop (4 * 3052 / ε)).and
      (eventually_ge_atTop (8 : ℝ))))).and
      (((tendsto_rpow_atTop hθ0).eventually_ge_atTop 2).and
      ((Real.tendsto_log_atTop.eventually_ge_atTop Lm).and
      ((eventually_logpow_le 2000 1).and (eventually_logpow_le (4 * Cw / (R * ε)) 3))))).mono ?_
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
  have hMT : (Mof T θ : ℝ) ≤ T := by
    unfold Mof
    refine (Nat.floor_le (Real.rpow_nonneg hT0.le _)).trans ?_
    have := Real.rpow_le_rpow_of_exponent_le hT1 (show θ ≤ 1 by linarith)
    rwa [Real.rpow_one] at this
  have hM0 : (0 : ℝ) < Mof T θ := by exact_mod_cast (show 0 < Mof T θ by omega)
  -- `σ₀`
  have hσe : 1 / 2 - sig0 T R = R / Real.log T := by unfold sig0; ring
  have hRL : R / Real.log T ≤ 1 / 8 := by
    rw [div_le_iff₀ hLpos]; linarith [hLm2.trans hLm]
  have hRL0 : 0 < R / Real.log T := by positivity
  have hσlt : sig0 T R < 1 / 2 := by linarith
  have hσge : 3 / 8 ≤ sig0 T R := by linarith
  -- `X`
  obtain ⟨X, hXdef⟩ : ∃ X : ℝ, X = Real.logb 2 (A * T) := ⟨_, rfl⟩
  have hq : (2 : ℝ) ^ X = A * T := by
    rw [hXdef]; exact Real.rpow_logb (by norm_num) (by norm_num) (by positivity)
  obtain ⟨hX3, hX4⟩ := X_bounds hA1 hT1 (by nlinarith) (hLm3.trans hLm)
  rw [← hXdef] at hX3 hX4
  have htd : LevinsonMollEdge.tailDelta (Mof T θ) Bc X ≤ τ :=
    tail_le (by linarith) hτ0 hτ1 hAτ hT1 hMT hq
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
  have hlM : Real.log (Mof T θ : ℝ) ≤ Real.log T := Real.log_le_log hM0 hMT
  have hlB0 : 0 ≤ Real.log Bc := Real.log_nonneg hBc1
  have hlB : Real.log Bc ≤ Bc := by
    have := Real.log_le_sub_one_of_pos (show 0 < Bc by linarith); linarith
  have hWp : Wp ≤ Real.pi * Cw * Real.log T ^ 3 := by
    rw [hWpdef, hCwdef]; exact W2_le hX3 hX4 hL1 hlM0 hlM hlB0 hlB
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

/-- info: 'FloorStep.combine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms combine

/-- info: 'FloorStep.floor_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_step

end FloorStep
