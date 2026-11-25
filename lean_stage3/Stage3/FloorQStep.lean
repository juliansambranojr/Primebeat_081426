/-
# FloorQStep — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: Conrey's floor on `[T/2, T]` for a general `Q`. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

For real `Q` with `Q′(x) = Q′(1 − x)`, `Q(1/2) ≠ 0`, `Q(0) = 1`, and `P(0) = 0`, `P(1) = 1`,
`0 < θ < 1/2`, `R > 0`, every `ε > 0`: from some height on,

  `(N T − N(T/2)) − (log K / R)(N T − N(T/2)) − ε T log T ≤ lineCount T − lineCount (T/2)`,

`K = max 1 (Re DopQ(cY)(−R/L, −R/L) + ε)`, `L = log T`. A copy of `FloorStep.floor_step` with
`V = W/Gammaℝ` for `G = ζ + cζ′`: `FloorQWindow.conrey_window_diff` at `a = T/2`, `b = T`,
`σ₀ = sig0 T R`, `ψ = molli M betaC`, `X = log₂(A T)`; the count from
`DigammaBound.conrey_count_window'`; the mean at `σ₀` from `GrRatio.window_V_lt_half'`, carried
to `[σ₀ − δ(T), σ₀]` by `FloorQCont.hK_shiftV`.

The sizes, each error term `≤ (ε/4) T L`, checked before the proof:

| term | size | why it is small |
|---|---|---|
| main | `(log K/R)·T L/(4π)` | as in `FloorStep` (`N_window_ge`) |
| tail, `(L/(πR))·(T/2)·2δ_R` | `δ_R ≤ tailDelta + 2C_V/L` | `tailDelta ≤ τ ≤ επR/8` (`X = log₂(A T)`), `2C_V/L ≤ επR/8` once `L ≥ 16C_V/(επR)` |
| edges, `(L/(πR))·W` | `W ≤ π C_w L³` | `log(2Mf) = L + log M + log(2(C_D + 1)B)`, `X ≤ 4L` (`FloorStep.W2_le`) |
| count and `N` steps, `134 L + 42 log(3A) + 2654` | `≤ C₀ L` | `T ≥ 4C₀/ε` |

**The factor this avoids.** `V(X + it) = ζ + O_Q(1/L)` far right (`FloorQGamma.V_right_le`),
not `ζ + O(2^{−X})`: the right-edge distance `δ_R` carries `C_V/L`, and the tail term is then
`(L/(πR))(T/2)·2C_V/L = C_V T/(πR) = O(T)`, which is `o(T L)`; no factor of `L` is lost. The
gamma ratio at `Re = X ≍ L` is taken from bounded real part by the shift `s ↦ s + 2`
(`FloorQGamma.gamma_ratio_far`); the crude Stirling directly at `Re = X` would have lost
`e^{O(L log L)}`.

| name | content | status |
|---|---|---|
| `combineQ` | `FloorStep.combine` with a general constant term | proved |
| `constE` | the count's and `N` steps' constant `≤ (ε/4) T L` | proved |
| `floor_stepQ` | Conrey's floor on `[T/2, T]`, every `ε > 0`, from some height on | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorQWindow
import Stage3.FloorQCont
import Stage3.FloorStep
import Stage3.GrRatio
import Stage3.DigammaBound
import Stage3.FloorConstQLimit

namespace FloorQ

open Complex MeasureTheory Set Filter Topology TwistedMoment

/-- **The arithmetic of the floor**, `FloorStep.combine` with the constant term `E0`. -/
theorem combineQ {ND LC L T lK Kb R ε td Wp τ Cw E0 : ℝ}
    (hL1 : 1 ≤ L) (hT0 : 0 < T) (hR : 0 < R) (hε : 0 < ε)
    (hwin : ND - (1 / (Real.pi * (R / L))) * ((T - T / 2) / 2 * lK + ((T - T / 2) * (2 * td) + Wp))
      - E0 ≤ LC)
    (htd : td ≤ τ) (hτ : τ ≤ ε * Real.pi * R / 4)
    (hWp : Wp ≤ Real.pi * Cw * L ^ 3) (hCw : 4 * Cw / (R * ε) * L ^ 3 ≤ T)
    (hN : T * L / (4 * Real.pi) - ND ≤ T + 224 * L + 1396)
    (hlK0 : 0 ≤ lK) (hlK : lK ≤ Kb) (hT224 : 224 * L + 1396 ≤ T)
    (hKbL : 8 * Kb / (R * ε) ≤ L) (hE : E0 ≤ ε / 4 * T * L) :
    ND - lK / R * ND - ε * T * L ≤ LC := by
  have hπ := Real.pi_pos
  have hL0 : 0 < L := by linarith
  have hF : 1 / (Real.pi * (R / L)) = L / (Real.pi * R) := by field_simp
  rw [hF] at hwin
  have hFp : 0 < L / (Real.pi * R) := by positivity
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
  have m4 : L / (Real.pi * R) * ((T - T / 2) * (2 * td)) ≤ ε / 4 * T * L := by
    have e : L / (Real.pi * R) * ((T - T / 2) * (2 * td)) = (L * T / (Real.pi * R)) * td := by
      field_simp; ring
    rw [e]
    have hLT : 0 ≤ L * T / (Real.pi * R) := by positivity
    calc L * T / (Real.pi * R) * td ≤ L * T / (Real.pi * R) * (ε * Real.pi * R / 4) :=
          mul_le_mul_of_nonneg_left (htd.trans hτ) hLT
      _ = ε / 4 * T * L := by field_simp
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
  have hsplit : L / (Real.pi * R) * ((T - T / 2) / 2 * lK + ((T - T / 2) * (2 * td) + Wp)) =
      L / (Real.pi * R) * ((T - T / 2) / 2 * lK) + L / (Real.pi * R) * ((T - T / 2) * (2 * td))
        + L / (Real.pi * R) * Wp := by ring
  rw [hsplit, e1] at hwin
  have e3 : ε * T * L = ε / 4 * T * L * 4 := by ring
  rw [e3]
  linarith

/-- The constant term of the window, priced. -/
theorem constE {L T ε Ac C₀ : ℝ} (hL1 : 1 ≤ L) (hε : 0 < ε)
    (hC₀def : C₀ = 2788 + 42 * |Real.log (3 * Ac)|) (hTC₀ : 4 * C₀ / ε ≤ T) :
    72 * L + 42 * Real.log (3 * Ac) + 154 + 62 * L + 2500 ≤ ε / 4 * T * L := by
  have hLpos : 0 < L := by linarith
  have h0 : 0 ≤ 42 * |Real.log (3 * Ac)| := by positivity
  have h1 : 42 * Real.log (3 * Ac) ≤ 42 * |Real.log (3 * Ac)| * L := by
    have := le_abs_self (Real.log (3 * Ac))
    nlinarith
  have h2 : C₀ * L ≤ ε / 4 * T * L := by
    have : C₀ ≤ ε / 4 * T := by
      rw [div_le_iff₀ hε] at hTC₀; linarith
    exact mul_le_mul_of_nonneg_right this hLpos.le
  rw [hC₀def] at h2
  nlinarith

set_option maxHeartbeats 4000000 in
/-- **B4 step 5, Conrey's floor on one dyadic window.** For real `Q` with `Q′(x) = Q′(1 − x)`,
`Q(1/2) ≠ 0`, `Q(0) = 1`, `P(0) = 0`, `P(1) = 1`, `0 < θ < 1/2`, `R > 0`, every `ε > 0`: from
some height on, the zeros on the line with height in `(T/2, T]` number at least
`(1 − log K/R)(N T − N(T/2)) − ε T log T`, `K = max 1 (Re DopQ(cY)(−R/L, −R/L) + ε)`. -/
theorem floor_stepQ (Q P : Polynomial ℝ)
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1)
    (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (riemannZeta.N T - riemannZeta.N (T / 2))
        - Real.log (max 1 ((MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
            ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) / R
          * (riemannZeta.N T - riemannZeta.N (T / 2))
        - ε * T * Real.log T
        ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
  intro ε hε
  obtain ⟨Bc, hBc1, hBc⟩ := FloorStep.betaC_bound P
  -- the bound on `Re DopQ`
  obtain ⟨TK, hD⟩ := eventually_atTop.mp ((FloorConstQ.re_dopQ_tendsto Q P hθ0 hR.ne').eventually
    (Iic_mem_nhds (lt_add_one (FloorConstQ.KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R))))
  obtain ⟨K₀, hK₀def⟩ : ∃ K₀ : ℝ,
      K₀ = |FloorConstQ.KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R| + 1 := ⟨_, rfl⟩
  have hK₀0 : 0 ≤ K₀ := by rw [hK₀def]; positivity
  have hDK : ∀ T, TK ≤ T → (MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re ≤ K₀ := by
    intro T hT
    have h := hD T hT
    rw [hK₀def]
    linarith [le_abs_self (FloorConstQ.KflQ Q (FloorConst.Ar P) (FloorConst.Br P) (FloorConst.Cr P) θ R)]
  -- the mean, the count, the sizes of `V`
  obtain ⟨T₁, hT₁⟩ := GrRatio.window_V_lt_half' Q P hP0 hθ0 hθ hR (ε / 2) (half_pos hε)
  obtain ⟨Ac, Tc, hAc, hcnt⟩ := DigammaBound.conrey_count_window' hQ hQh hQ0
  obtain ⟨CV, hCV0, hCV⟩ := V_right_le Q
  obtain ⟨CD, hCD0, hCDb⟩ := V_disc_le Q
  have hQc : Q.coeff 0 = 1 := by rw [Polynomial.coeff_zero_eq_eval_zero]; exact hQ0
  have hπ := Real.pi_pos
  obtain ⟨τ, hτdef⟩ : ∃ τ : ℝ, τ = min (1 / 4) (ε * Real.pi * R / 8) := ⟨_, rfl⟩
  have hτ0 : 0 < τ := by rw [hτdef]; exact lt_min (by norm_num) (by positivity)
  have hτ1 : τ ≤ 1 / 4 := by rw [hτdef]; exact min_le_left _ _
  have hτε : τ ≤ ε * Real.pi * R / 8 := by rw [hτdef]; exact min_le_right _ _
  obtain ⟨A, hAdef⟩ : ∃ A : ℝ, A = 64 * (Bc + 1) / τ := ⟨_, rfl⟩
  have hAτ : 64 * (Bc + 1) ≤ A * τ := by rw [hAdef, div_mul_cancel₀ _ hτ0.ne']
  have hA1 : 1 ≤ A := by
    rw [hAdef, le_div_iff₀ hτ0]; nlinarith
  obtain ⟨Kb, hKbdef⟩ : ∃ Kb : ℝ, Kb = K₀ + ε + 1 := ⟨_, rfl⟩
  obtain ⟨Bm, hBmdef⟩ : ∃ Bm : ℝ, Bm = 2 * (CD + 1) * Bc := ⟨_, rfl⟩
  have hBm1 : 1 ≤ Bm := by rw [hBmdef]; nlinarith
  obtain ⟨Cw, hCwdef⟩ : ∃ Cw : ℝ, Cw = 12 + 256 * (10 + Bm) := ⟨_, rfl⟩
  obtain ⟨C₀, hC₀def⟩ : ∃ C₀ : ℝ, C₀ = 2788 + 42 * |Real.log (3 * Ac)| := ⟨_, rfl⟩
  obtain ⟨Lv, hLvdef⟩ : ∃ Lv : ℝ, Lv = 16 * CV / (ε * Real.pi * R) + 8 * CV := ⟨_, rfl⟩
  obtain ⟨Lm, hLmdef⟩ : ∃ Lm : ℝ,
      Lm = max (8 * R) (max (Real.log A) (max (8 * Kb / (R * ε)) (max 26 Lv))) := ⟨_, rfl⟩
  have ev : ∀ᶠ T : ℝ in atTop, (Real.exp 26 ≤ T ∧ T₁ ≤ T ∧ TK ≤ T ∧ 4 * C₀ / ε ≤ T ∧ Tc ≤ T) ∧
      (2 : ℝ) ≤ T ^ θ ∧ Lm ≤ Real.log T ∧ 2000 * Real.log T ^ 1 ≤ T ∧
      4 * Cw / (R * ε) * Real.log T ^ 3 ≤ T := by
    refine ((((eventually_ge_atTop (Real.exp 26)).and (eventually_ge_atTop T₁)).and
      ((eventually_ge_atTop TK).and ((eventually_ge_atTop (4 * C₀ / ε)).and
      (eventually_ge_atTop Tc)))).and
      (((tendsto_rpow_atTop hθ0).eventually_ge_atTop 2).and
      ((Real.tendsto_log_atTop.eventually_ge_atTop Lm).and
      ((FloorStep.eventually_logpow_le 2000 1).and
        (FloorStep.eventually_logpow_le (4 * Cw / (R * ε)) 3))))).mono ?_
    rintro T ⟨⟨⟨h1, h2⟩, h3, h4, h5⟩, h6, h7, h8, h9⟩
    exact ⟨⟨h1, h2, h3, h4, h5⟩, h6, h7, h8, h9⟩
  obtain ⟨T₀, hT₀⟩ := eventually_atTop.mp ev
  refine ⟨T₀, fun T hT => ?_⟩
  obtain ⟨⟨hT26, hTT₁, hTK, hTC₀, hTc⟩, hTθ, hLm, hT2000, hTCw⟩ := hT₀ T hT
  -- the height
  have hT27 : (27 : ℝ) ≤ T := by linarith [Real.add_one_le_exp (26 : ℝ)]
  have hT1 : (1 : ℝ) ≤ T := by linarith
  have hT0 : (0 : ℝ) < T := by linarith
  have hLm1 : 26 ≤ Lm := by
    rw [hLmdef]
    exact le_max_of_le_right (le_max_of_le_right (le_max_of_le_right (le_max_left _ _)))
  have hLm2 : 8 * R ≤ Lm := by rw [hLmdef]; exact le_max_left _ _
  have hLm3 : Real.log A ≤ Lm := by rw [hLmdef]; exact le_max_of_le_right (le_max_left _ _)
  have hLm4 : 8 * Kb / (R * ε) ≤ Lm := by
    rw [hLmdef]; exact le_max_of_le_right (le_max_of_le_right (le_max_left _ _))
  have hLm5 : Lv ≤ Lm := by
    rw [hLmdef]
    exact le_max_of_le_right (le_max_of_le_right (le_max_of_le_right (le_max_right _ _)))
  have hL26 : 26 ≤ Real.log T := hLm1.trans hLm
  have hL1 : 1 ≤ Real.log T := by linarith
  have hLpos : 0 < Real.log T := by linarith
  rw [pow_one] at hT2000
  have hT64 : (64 : ℝ) ≤ T := by nlinarith
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
  have hq2 : (2 : ℝ) ^ X = A * T := by
    rw [hXdef]; exact Real.rpow_logb (by norm_num) (by norm_num) (by positivity)
  obtain ⟨hX3, hX4⟩ := FloorStep.X_bounds hA1 hT1 (by nlinarith) (hLm3.trans hLm)
  rw [← hXdef] at hX3 hX4
  have htd : LevinsonMollEdge.tailDelta (Mof T θ) Bc X ≤ τ :=
    FloorStep.tail_le (by linarith) hτ0 (by linarith) hAτ hT1 hMT hq2
  have hXMB : 32 * (Mof T θ : ℝ) * Bc ≤ (2 : ℝ) ^ X :=
    FloorStep.XMB_le (by linarith) hτ0 (by linarith) hAτ hMT hq2
  have hXa : 2 * X ≤ T / 2 := by linarith
  have hXT : X ≤ T / 128 := by linarith
  -- the right-edge distance
  have h2X : 0 < (2 : ℝ) ^ X := by positivity
  obtain ⟨q, hqdef⟩ : ∃ q : ℝ, q = (Mof T θ : ℝ) * Bc / (2 : ℝ) ^ X := ⟨_, rfl⟩
  have hq0 : 0 ≤ q := by rw [hqdef]; positivity
  have hq1 : q ≤ 1 / 32 := by
    rw [hqdef, div_le_iff₀ h2X]; linarith
  obtain ⟨δR, hδRdef⟩ : ∃ δR : ℝ,
      δR = (CV / Real.log T + 8 / (2 : ℝ) ^ X) * (1 + q) + q := ⟨_, rfl⟩
  have htd' : LevinsonMollEdge.tailDelta (Mof T θ) Bc X = 8 / (2 : ℝ) ^ X * (1 + q) + q := by
    rw [hqdef]; unfold LevinsonMollEdge.tailDelta; ring
  have hCVL : CV / Real.log T ≤ 1 / 8 * τ + CV / Real.log T := by linarith
  have hCVL1 : 2 * (CV / Real.log T) ≤ ε * Real.pi * R / 8 := by
    have hLv : 16 * CV / (ε * Real.pi * R) ≤ Real.log T := by
      have := hLm5.trans hLm
      rw [hLvdef] at this
      have h8 : 0 ≤ 8 * CV := by positivity
      linarith
    rw [div_le_iff₀ (by positivity)] at hLv
    have h1 : CV / Real.log T ≤ ε * Real.pi * R / 16 := by
      rw [div_le_iff₀ hLpos]; linarith
    linarith
  have hCVL2 : 2 * (CV / Real.log T) ≤ 1 / 4 := by
    have hLv : 8 * CV ≤ Real.log T := by
      have := hLm5.trans hLm
      rw [hLvdef] at this
      have h8 : 0 ≤ 16 * CV / (ε * Real.pi * R) := by positivity
      linarith
    rw [← mul_div_assoc, div_le_iff₀ hLpos]
    linarith
  have hδRle : δR ≤ τ + 2 * (CV / Real.log T) := by
    have hCV' : 0 ≤ CV / Real.log T := by positivity
    have e : δR = LevinsonMollEdge.tailDelta (Mof T θ) Bc X + CV / Real.log T * (1 + q) := by
      rw [htd', hδRdef]; ring
    rw [e]
    have : CV / Real.log T * (1 + q) ≤ CV / Real.log T * 2 :=
      mul_le_mul_of_nonneg_left (by linarith) hCV'
    linarith
  have hδR12 : δR ≤ 1 / 2 := by linarith
  have hδRε : δR ≤ ε * Real.pi * R / 4 := by linarith
  -- `δ` and `K`
  obtain ⟨δ, hδ, hδ8, hδK⟩ := hK_shiftV Q (Real.log T) (Mof T θ) (FloorStep.betaC P T θ R)
    (σ₀ := sig0 T R) (T := T)
    (K := (MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ)).re) (ε := ε) hT0 hε (by
      intro a' b' h1 h2 h3 h4
      have := hT₁ T hTT₁ a' b' h1 h2 h3 h4
      unfold FintV
      rw [FloorStep.molli_betaC]
      exact this)
  have hK1 : (1 : ℝ) ≤ max 1 ((MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε) := le_max_left _ _
  have hβ1 := FloorStep.betaC_one P hP1 (T := T) (θ := θ) (R := R) hM2
  have hβ := hBc T θ R hσlt.le
  -- the window's hypotheses
  have hGa : ∀ w : ℂ, 0 < w.im → AnalyticAt ℂ (ConreyCount.V Q (Real.log T)) w :=
    fun w hw => analyticAt_V_im Q (Real.log T) hw
  have hRe : ∀ t ∈ Icc (T / 2) T,
      ‖ConreyCount.V Q (Real.log T) (↑X + ↑t * I)
        * LevinsonMollEdge.molli (Mof T θ) (FloorStep.betaC P T θ R) (↑X + ↑t * I) - 1‖ ≤ δR := by
    intro t ht
    have hs : ((X : ℂ) + (t : ℂ) * I).re = X := by simp
    have hV := hCV T hT64 hL1 X t hX3 hXT (by linarith [ht.1]) (by linarith [ht.2])
    rw [hQc, Complex.ofReal_one, one_mul] at hV
    have hζ := LevinsonMollEdge.norm_G_sub_one_le_X (c := 0) le_rfl zero_le_one hX3 hs
    simp only [Complex.ofReal_zero, zero_mul, add_zero] at hζ
    have hψ1 := LevinsonMollEdge.molli_sub_one_le hβ1 hβ hM hs (by linarith)
    rw [← hqdef] at hψ1
    set Vs := ConreyCount.V Q (Real.log T) (↑X + ↑t * I) with hVs
    set ψs := LevinsonMollEdge.molli (Mof T θ) (FloorStep.betaC P T θ R) (↑X + ↑t * I) with hψs
    have hV1 : ‖Vs - 1‖ ≤ CV / Real.log T + 8 / (2 : ℝ) ^ X := by
      have : Vs - 1 = (Vs - riemannZeta (↑X + ↑t * I)) + (riemannZeta (↑X + ↑t * I) - 1) := by
        ring
      rw [this]
      exact (norm_add_le _ _).trans (by linarith)
    have hψn : ‖ψs‖ ≤ 1 + q := by
      calc ‖ψs‖ = ‖(ψs - 1) + 1‖ := by rw [sub_add_cancel]
        _ ≤ ‖ψs - 1‖ + ‖(1 : ℂ)‖ := norm_add_le _ _
        _ ≤ 1 + q := by rw [norm_one]; linarith
    have heq : Vs * ψs - 1 = (Vs - 1) * ψs + (ψs - 1) := by ring
    rw [heq, hδRdef]
    have hprod := mul_le_mul hV1 hψn (norm_nonneg _) (by positivity)
    calc _ ≤ ‖(Vs - 1) * ψs‖ + ‖ψs - 1‖ := norm_add_le _ _
      _ ≤ _ := by rw [norm_mul]; linarith
  obtain ⟨Mf, hMfdef⟩ : ∃ Mf : ℝ, Mf = (CD + 1) * T * ((Mof T θ : ℝ) * Bc) := ⟨_, rfl⟩
  have hMfb : ∀ y ∈ Icc (T / 2) T, ∀ w : ℂ, ‖w - (↑X + ↑y * I)‖ ≤ X - 1 / 8 →
      ‖ConreyCount.V Q (Real.log T) w
        * LevinsonMollEdge.molli (Mof T θ) (FloorStep.betaC P T θ R) w‖ ≤ Mf := by
    intro y hy w hw
    have h1 := (Complex.abs_re_le_norm (w - (↑X + ↑y * I))).trans hw
    have h2 := (Complex.abs_im_le_norm (w - (↑X + ↑y * I))).trans hw
    simp only [Complex.sub_re, Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
      Complex.I_im, Complex.ofReal_im, Complex.sub_im, Complex.add_im, Complex.mul_im,
      mul_zero, mul_one, sub_zero, add_zero, zero_add] at h1 h2
    obtain ⟨h1a, h1b⟩ := abs_le.mp h1
    obtain ⟨h2a, h2b⟩ := abs_le.mp h2
    have hVw := hCDb T hT64 (by linarith) w (by linarith) (by linarith)
      (by linarith [hy.1]) (by linarith [hy.2])
    have hψw := LevinsonMollEdge.molli_norm_le (M := Mof T θ) hβ (s := w) (by linarith)
    rw [norm_mul, hMfdef]
    have : CD * T ≤ (CD + 1) * T := by nlinarith
    exact mul_le_mul (hVw.trans this) hψw (norm_nonneg _) (by positivity)
  have hcount : ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T → a' < b' →
      (∀ x ∈ Icc (1/2 : ℝ) 3, ConreyCount.V Q (Real.log T) (↑x + ↑a' * I) ≠ 0) →
      (∀ x ∈ Icc (1/2 : ℝ) 3, ConreyCount.V Q (Real.log T) (↑x + ↑b' * I) ≠ 0) →
      riemannZeta (1/2 + a' * I) ≠ 0 →
      (riemannZeta.N b' - riemannZeta.N a')
        - 2 * Littlewood.countRight (ConreyCount.V Q (Real.log T)) ((1/2 : ℂ) + a' * I)
            ((3 : ℂ) + b' * I) (1/2)
        - (72 * Real.log T + 42 * Real.log (3 * Ac) + 154)
          ≤ (LineCount.lineCount b' : ℝ) - (LineCount.lineCount a' : ℝ) := by
    intro a' b' h1 h2 h3 h4 h5 hBot hTop hζa
    have h := hcnt hTc (by linarith) (by linarith) h5 (by linarith) hBot hTop hζa
    have hlb : Real.log b' ≤ Real.log T := Real.log_le_log (by linarith) h4
    linarith
  have hwin := conrey_window_diff (G := ConreyCount.V Q (Real.log T))
    (ψ := LevinsonMollEdge.molli (Mof T θ) (FloorStep.betaC P T θ R))
    (T := T) (σ₀ := sig0 T R) (δ := δ) (X := X) (a := T / 2) (b := T)
    hGa (LevinsonMollEdge.molli_differentiable _ _) hσlt hδ (by linarith) hX3 hXa
    (by linarith) le_rfl hK1 hδR12 hRe hMfb hcount (by
      intro a' b' ha1 ha2 hb1 hb2 hab σ hσ
      have := hδK a' b' ha1 ha2 hb1 hb2 hab σ hσ
      unfold FintV at this
      exact this.trans (le_max_right _ _))
  rw [hσe] at hwin
  -- the window's edge terms
  obtain ⟨Wp, hWpdef⟩ : ∃ Wp : ℝ, Wp = X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1)
      * Real.log (2 * Mf) + 1))) := ⟨_, rfl⟩
  have hWe : windowEQ δR Mf X (T / 2) T = (T - T / 2) * (2 * δR) + Wp := by
    rw [hWpdef]; unfold windowEQ; ring
  rw [hWe] at hwin
  have hlM0 : 0 ≤ Real.log (Mof T θ : ℝ) := Real.log_nonneg (by exact_mod_cast hM)
  have hlM : Real.log (Mof T θ : ℝ) ≤ Real.log T := Real.log_le_log hM0 hMT
  have hlB0 : 0 ≤ Real.log Bm := Real.log_nonneg hBm1
  have hlB : Real.log Bm ≤ Bm := by
    have := Real.log_le_sub_one_of_pos (show 0 < Bm by linarith); linarith
  have hlog2 : Real.log (2 * Mf) = Real.log T + Real.log (Mof T θ : ℝ) + Real.log Bm := by
    have e : 2 * Mf = T * (Mof T θ : ℝ) * Bm := by rw [hMfdef, hBmdef]; ring
    rw [e, Real.log_mul (by positivity) (by linarith), Real.log_mul hT0.ne' hM0.ne']
  have hWp : Wp ≤ Real.pi * Cw * Real.log T ^ 3 := by
    have hW2 := FloorStep.W2_le hX3 hX4 hL1 hlM0 hlM hlB0 hlB
    have hdiff : 0 ≤ X * (Real.pi * ((8 * X - 1) * 8)) := by
      have : 0 ≤ 8 * X - 1 := by linarith
      positivity
    have e : X * Real.pi + 2 * (X * (Real.pi * ((8 * X - 1) * (Real.log T
        + Real.log (Mof T θ : ℝ) + Real.log Bm + 8) + 1))) =
        Wp + 2 * (X * (Real.pi * ((8 * X - 1) * 8))) := by
      rw [hWpdef, hlog2]; ring
    rw [hCwdef]
    linarith
  -- `log K`
  have hDre := hDK T hTK
  have hlK0 := Real.log_nonneg hK1
  have hlK : Real.log (max 1 ((MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)) ≤ Kb := by
    have h1 := Real.log_le_sub_one_of_pos (show (0 : ℝ) < max 1 ((MeanQ.DopQ Q (Real.log T)
      (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε)
      by linarith)
    have h2 : max 1 ((MeanQ.DopQ Q (Real.log T) (cY P (Mof T θ) T)
      ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε) ≤ K₀ + ε + 1 :=
      max_le (by linarith) (by linarith)
    rw [hKbdef]; linarith
  -- the constant term
  have hE := constE hL1 hε hC₀def hTC₀
  exact combineQ hL1 hT0 hR hε hwin hδRε le_rfl hWp hTCw (FloorStep.N_window_ge (by linarith))
    hlK0 hlK (by linarith) (hLm4.trans hLm) hE

/-- info: 'FloorQ.combineQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms combineQ

/-- info: 'FloorQ.constE' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms constE

/-- info: 'FloorQ.floor_stepQ' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_stepQ

end FloorQ
