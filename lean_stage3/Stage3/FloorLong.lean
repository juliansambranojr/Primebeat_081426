/-
# FloorLong — block S13 of `lean_stage3/design/stencil.md`, B1, the floor for every length. 2026-11-25.

Stage B as one named input. For every length exponent `θ > 0`: if the three error statements
of the floor chain hold at `θ` (`FloorLongErr.StmtLongErr P θ R`: the shifted diagonal, the
off-diagonal, the X-term, each `O(T/L)`), then for `P(0) = 0`, `P(1) = 1`, `R > 0` and every
`ε > 0`, from some height on,

  `(1 − log(max 1 K)/R − ε)·N T ≤ lineCount T`,   `K = Kfl(∫P′², ∫P′P, ∫P², θ, R)`.

At `θ < 1/2` the input is proved (`longErr_of_lt_half`), and at Levinson's `P(x) = x`,
`θ = 49/100`, `R = 13/10` the theorem gives back `FloorSum.levinson_floor`
(`levinson_floor_of_long`), since there `K ≥ 1` and `log K/R ≤ 2/3`.

The route. `lemma3_of_long` (Lemma 3 at `o(T)`, every `κ > 0`) → `mollMean_long` (the operator,
at `κ = 2R + 1 + 1/R`) → `unsmooth_near_levinson_long` → `floor_step_long` (one window) → the
sum below, `FloorSumTele.tele_floor` with `Re D[c](T) → K` (`FloorConst.re_dop_tendsto`, every
`θ > 0`). The sum is `FloorSum.levinson_floor`'s with `K` general: `max 1 K` replaces the
numeric `K ≥ 1`, and when `κ = 1 − log(max 1 K)/R ≤ ε` the claim is trivial (`lineCount ≥ 0`).

The sizes, checked before the proof. With `ε₁ = ε·min(R,1)/80`: the window's `max 1` and `ε₁`
cost `2ε₁/R ≤ ε/40` of the proportion (`log(max 1 K + 2ε₁) ≤ log(max 1 K) + 2ε₁`); the summed
errors `2ε₁ T log T ≤ (ε/40)·20 N T = (ε/2) N T` (`N T ≥ T log T/20`, `FloorSum.N_ge`); the
start `N T₁ ≤ (ε/3) N T` once `T ≥ 60 N T₁/ε`. Total `ε/40 + ε/2 + ε/3 < ε`. No factor of
`log T` is lost: the halving step is fixed, as in `levinson_floor`.

| name | content | status |
|---|---|---|
| `FloorLongErr.StmtLongErr` | the three error statements at length `θ`, every `κ > 0` | OPEN for `θ ≥ 1/2` |
| `logmax_long` | `log(max 1 x) ≤ log(max 1 K) + 2ε₁` for `x ≤ K + 2ε₁` | proved |
| `floor_of_long` | `StmtLongErr P θ R →` the floor `1 − log(max 1 K)/R`, every `θ > 0` | proved |
| `floor_lt_half` | the same, unconditional, for `0 < θ < 1/2` | proved |
| `levinson_floor_of_long` | `floor_of_long` at `P = X`, `θ = 49/100`, `R = 13/10`: `(1/3 − ε) N T ≤ lineCount T` | proved |

Where `θ < 1/2` enters the chain (the list, from `grep -n "θ < 1 / 2" Stage3/*.lean`): only
`Diagonal.diag_young` (`final_size_diag`, `SB_young`), `OffDiagClose.stmtOffDiag_holds`
(`final_size`, `Tpow_le`, `r_choice`) and `Stirling.stmtXAll_of'` (`size_X`, and calls of the
two before and of `SwapX.c1Y_bound`). Carried unused: `SdiagLead.stmtSdiagLead_holds`. Used as
`θ ≤ 1` only: `Operator.Ires_o`, `Unsmooth.dop_cY_bdd`, `FloorStep.floor_step` (re-proved for
every `θ` in `FloorLongMean`, `FloorLongStep`). Everything else takes `θ` as a parameter.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.FloorLongStep
import Stage3.FloorSum

namespace FloorLong

open Complex Filter Topology TwistedMoment FloorConst

/-- The window's `max 1` and `ε₁`, priced for any `K`: `log(max 1 x) ≤ log(max 1 K) + 2ε₁`. -/
theorem logmax_long {K x ε₁ : ℝ} (hε₁ : 0 < ε₁) (hx : x ≤ K + 2 * ε₁) :
    Real.log (max 1 x) ≤ Real.log (max 1 K) + 2 * ε₁ := by
  have hK1 : 1 ≤ max 1 K := le_max_left _ _
  have hK0 : 0 < max 1 K := by linarith
  have hm : max 1 x ≤ max 1 K + 2 * ε₁ :=
    max_le (by linarith) (by linarith [le_max_right 1 K])
  have h1 : Real.log (max 1 x) ≤ Real.log (max 1 K + 2 * ε₁) :=
    Real.log_le_log (by positivity) hm
  have h2 : Real.log (max 1 K + 2 * ε₁) - Real.log (max 1 K) ≤ 2 * ε₁ := by
    rw [← Real.log_div (by positivity) hK0.ne']
    have h3 := Real.log_le_sub_one_of_pos (show 0 < (max 1 K + 2 * ε₁) / max 1 K by positivity)
    have h4 : (max 1 K + 2 * ε₁) / max 1 K - 1 = 2 * ε₁ / max 1 K := by field_simp; ring
    have h5 : 2 * ε₁ / max 1 K ≤ 2 * ε₁ := div_le_self (by positivity) hK1
    linarith
  linarith

/-- **S13 B1, the floor for every length.** If the three error statements hold at length `θ`
(`StmtLongErr P θ R`), then for `P(0) = 0`, `P(1) = 1`, `θ > 0`, `R > 0`, every `ε > 0`, from
some height on, `(1 − log(max 1 K)/R − ε) N T ≤ lineCount T`,
`K = Kfl (∫P′²) (∫P′P) (∫P²) θ R`. -/
theorem floor_of_long (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) {R : ℝ} (hR : 0 < R) (hL : StmtLongErr P θ R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (1 - Real.log (max 1 (Kfl (Ar P) (Br P) (Cr P) θ R)) / R - ε) * riemannZeta.N T ≤
        (LineCount.lineCount T : ℝ) := by
  have hMM : Operator.StmtMollMeanO P θ R :=
    mollMean_long P hR (lemma3_of_long P hP0 hθ0 hL (by positivity))
  intro ε hε
  obtain ⟨K, hKdef⟩ : ∃ K : ℝ, K = Kfl (Ar P) (Br P) (Cr P) θ R := ⟨_, rfl⟩
  rw [← hKdef]
  obtain ⟨lam, hlamdef⟩ : ∃ lam : ℝ, lam = Real.log (max 1 K) := ⟨_, rfl⟩
  rw [← hlamdef]
  have hlam0 : 0 ≤ lam := by rw [hlamdef]; exact Real.log_nonneg (le_max_left _ _)
  obtain ⟨κ, hκdef⟩ : ∃ κ : ℝ, κ = 1 - lam / R := ⟨_, rfl⟩
  have hκ1 : κ ≤ 1 := by
    have : 0 ≤ lam / R := by positivity
    linarith
  have hlamR : 1 - lam / R - ε = κ - ε := by rw [hκdef]
  rw [hlamR]
  by_cases hκε : κ ≤ ε
  · refine ⟨0, fun T _ => ?_⟩
    have h1 : (κ - ε) * riemannZeta.N T ≤ 0 :=
      mul_nonpos_of_nonpos_of_nonneg (by linarith) (ArgCount.N_nonneg T)
    have h2 : (0 : ℝ) ≤ (LineCount.lineCount T : ℝ) := by
      exact_mod_cast LevinsonWindowNear.lineCount_nonneg T
    linarith
  push Not at hκε
  -- the window floor with proportion `c = κ − 2ε₁/R`
  obtain ⟨ε₁, hε₁def⟩ : ∃ ε₁ : ℝ, ε₁ = ε * min R 1 / 80 := ⟨_, rfl⟩
  have hm0 : 0 < min R 1 := lt_min hR one_pos
  have hε₁ : 0 < ε₁ := by rw [hε₁def]; positivity
  have hε₁1 : 2 * ε₁ ≤ ε / 40 := by
    rw [hε₁def]
    have := min_le_right R 1
    nlinarith
  obtain ⟨a, hadef⟩ : ∃ a : ℝ, a = 2 * ε₁ / R := ⟨_, rfl⟩
  have ha0 : 0 ≤ a := by rw [hadef]; positivity
  have haε : a ≤ ε / 40 := by
    rw [hadef, div_le_iff₀ hR, hε₁def]
    have := min_le_left R 1
    nlinarith
  obtain ⟨c, hcdef⟩ : ∃ c : ℝ, c = κ - a := ⟨_, rfl⟩
  have hc0 : 0 ≤ c := by rw [hcdef]; linarith
  have hc1 : c ≤ 1 := by rw [hcdef]; linarith
  have hstep : ∃ T₁ : ℝ, 1 ≤ T₁ ∧ ∀ T : ℝ, T₁ ≤ T →
      c * (riemannZeta.N T - riemannZeta.N (T / 2)) - ε₁ * T * Real.log T
        ≤ (LineCount.lineCount T : ℝ) - (LineCount.lineCount (T / 2) : ℝ) := by
    obtain ⟨T₂, h₂⟩ := floor_step_long P hP1 hθ0 hR hMM ε₁ hε₁
    have hlim := (re_dop_tendsto P hθ0 hR.ne').eventually
      (Iic_mem_nhds (lt_add_of_pos_right (Kfl (Ar P) (Br P) (Cr P) θ R) hε₁))
    obtain ⟨T₃, h₃⟩ := eventually_atTop.mp hlim
    refine ⟨max 1 (max T₂ T₃), le_max_left _ _, fun T hT => ?_⟩
    have hT1 : 1 ≤ T := (le_max_left _ _).trans hT
    have hT2 : T₂ ≤ T := (le_max_left _ _).trans ((le_max_right _ _).trans hT)
    have hT3 : T₃ ≤ T := (le_max_right _ _).trans ((le_max_right _ _).trans hT)
    have hs := h₂ T hT2
    have hD : (Operator.Dop (Real.log T) (cY P (Mof T θ) T)
        ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re ≤ K + ε₁ := by
      rw [hKdef]; exact h₃ T hT3
    have hl := logmax_long hε₁ (K := K) (x := (Operator.Dop (Real.log T) (cY P (Mof T θ) T)
        ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε₁) (by linarith)
    rw [← hlamdef] at hl
    have hlR : Real.log (max 1 ((Operator.Dop (Real.log T) (cY P (Mof T θ) T)
        ((-(R / Real.log T) : ℝ) : ℂ) ((-(R / Real.log T) : ℝ) : ℂ)).re + ε₁)) / R ≤
        lam / R + a := by
      rw [hadef, ← add_div]
      exact div_le_div_of_nonneg_right hl hR.le
    have hN : 0 ≤ riemannZeta.N T - riemannZeta.N (T / 2) := by
      have := ArgCount.N_mono (show T / 2 ≤ T by linarith)
      linarith
    have hm := mul_le_mul_of_nonneg_right hlR hN
    have e : c * (riemannZeta.N T - riemannZeta.N (T / 2)) =
        (riemannZeta.N T - riemannZeta.N (T / 2)) -
          (lam / R + a) * (riemannZeta.N T - riemannZeta.N (T / 2)) := by
      rw [hcdef, hκdef]; ring
    rw [e]
    linarith
  obtain ⟨T₁, hT₁, hst⟩ := hstep
  have hfl := FloorSum.tele_floor (f := fun T => (LineCount.lineCount T : ℝ))
    (g := riemannZeta.N) (c := c) (e := ε₁) hT₁ hε₁.le hc0
    (fun T => by exact_mod_cast LevinsonWindowNear.lineCount_nonneg T)
    (fun a b h => ArgCount.N_mono h) hst
  obtain ⟨T₄, h₄⟩ := eventually_atTop.mp
    (FloorSum.N_ge.and (Real.tendsto_log_atTop.eventually_ge_atTop 1))
  refine ⟨max (max T₁ T₄) (max 1 (60 * riemannZeta.N T₁ / ε)), fun T hT => ?_⟩
  have hTT₁ : T₁ ≤ T := (le_max_left _ _).trans ((le_max_left _ _).trans hT)
  have hTT₄ : T₄ ≤ T := (le_max_right _ _).trans ((le_max_left _ _).trans hT)
  have hT1 : 1 ≤ T := (le_max_left _ _).trans ((le_max_right _ _).trans hT)
  have hTN : 60 * riemannZeta.N T₁ / ε ≤ T :=
    (le_max_right _ _).trans ((le_max_right _ _).trans hT)
  have hfT : c * (riemannZeta.N T - riemannZeta.N T₁) - 2 * ε₁ * T * Real.log T ≤
      (LineCount.lineCount T : ℝ) := hfl T hTT₁
  obtain ⟨hNT, hlog1⟩ := h₄ T hTT₄
  have hN0 := ArgCount.N_nonneg T
  have hN10 := ArgCount.N_nonneg T₁
  rw [div_le_iff₀ hε] at hTN
  have hTL0 : 0 ≤ T * Real.log T := mul_nonneg (by linarith) (by linarith)
  have hTL : T ≤ T * Real.log T := by nlinarith
  -- the pieces
  have h1 : a * riemannZeta.N T ≤ ε / 40 * riemannZeta.N T :=
    mul_le_mul_of_nonneg_right haε hN0
  have h2 : c * riemannZeta.N T₁ ≤ riemannZeta.N T₁ := mul_le_of_le_one_left hN10 hc1
  have h3 : 2 * ε₁ * T * Real.log T ≤ ε / 40 * (T * Real.log T) := by
    rw [mul_assoc]; exact mul_le_mul_of_nonneg_right hε₁1 hTL0
  have h4 : ε / 40 * (T * Real.log T) ≤ ε / 2 * riemannZeta.N T := by
    have := mul_le_mul_of_nonneg_left hNT (show 0 ≤ ε / 40 by positivity)
    have e : ε / 40 * (T * Real.log T / 20) * 20 = ε / 40 * (T * Real.log T) := by ring
    nlinarith
  have h5 : riemannZeta.N T₁ ≤ ε / 3 * riemannZeta.N T := by
    have hA : ε * (T / 20) ≤ ε * riemannZeta.N T :=
      mul_le_mul_of_nonneg_left (by linarith) hε.le
    nlinarith
  have e1 : c * (riemannZeta.N T - riemannZeta.N T₁) =
      κ * riemannZeta.N T - a * riemannZeta.N T - c * riemannZeta.N T₁ := by
    rw [hcdef]; ring
  have e2 : (κ - ε) * riemannZeta.N T = κ * riemannZeta.N T - ε * riemannZeta.N T := by ring
  rw [e1] at hfT
  rw [e2]
  nlinarith

/-- **The floor for `0 < θ < 1/2`, unconditional**: `floor_of_long` with `longErr_of_lt_half`. -/
theorem floor_lt_half (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) (hP1 : P.eval 1 = 1) {θ : ℝ}
    (hθ0 : 0 < θ) (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
      (1 - Real.log (max 1 (Kfl (Ar P) (Br P) (Cr P) θ R)) / R - ε) * riemannZeta.N T ≤
        (LineCount.lineCount T : ℝ) :=
  floor_of_long P hP0 hP1 hθ0 hR (longErr_of_lt_half P hP0 hθ0 hθ R)

/-- **The consistency check**: `floor_of_long` at `P = X`, `θ = 49/100`, `R = 13/10`, with the
input from `longErr_of_lt_half`, gives `FloorSum.levinson_floor`'s statement. -/
theorem levinson_floor_of_long : ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    (1 / 3 - ε) * riemannZeta.N T ≤ (LineCount.lineCount T : ℝ) := by
  have h := floor_lt_half Polynomial.X Polynomial.eval_X Polynomial.eval_X
    (θ := 49 / 100) (by norm_num) (by norm_num) (R := 13 / 10) (by norm_num)
  rw [Ar_X, Br_X, Cr_X, max_eq_right FloorSum.K_ge_one] at h
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := h ε hε
  refine ⟨T₀, fun T hT => le_trans ?_ (hT₀ T hT)⟩
  have hK := FloorSum.log_K_le
  have hk : 1 / 3 - ε ≤ 1 - Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) / (13 / 10) - ε := by
    have e : Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) / (13 / 10) =
        Real.log (Kfl 1 (1 / 2) (1 / 3) (49 / 100) (13 / 10)) * (10 / 13) := by ring
    rw [e]
    linarith
  exact mul_le_mul_of_nonneg_right hk (ArgCount.N_nonneg T)

/-- info: 'FloorLong.logmax_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms logmax_long

/-- info: 'FloorLong.floor_of_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_of_long

/-- info: 'FloorLong.floor_lt_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms floor_lt_half

/-- info: 'FloorLong.levinson_floor_of_long' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_floor_of_long

end FloorLong
