/-
# FloorQGamma — block S13 of `lean_stage3/design/stencil.md`, B4 step 5, the assembly: the size of `V` far right and on the growth discs. 2026-11-25.

Pins: `PINS.md` § Current, "B4 step 5, the assembly".

The window for `V ψ` (`FloorQWindow`) puts its right edge at `Re s = X = log₂(A T) = O(L)`, far
outside the range `Re ∈ [1/4, 7]` of `DigammaBoundSize.gamma_ratio`. Its crude Stirling there
has error `gErr(X/2) ≍ X log X`, so used directly it would lose a factor `e^{O(L log L)}`: the
size, not the step, fails. The route taken loses nothing: shift by `2` with
`Gammaℝ (s + 2) = Gammaℝ s · s/(2π)` (Mathlib's `Gammaℝ_add_two`), so

  `GR(z + 2, w + 2) = GR(z, w) · ‖z‖/‖w‖`,  `GR(z, w) = ‖Γℝ z‖/‖Γℝ w‖ · e^{−(L/2)(Re z − Re w)}`,

and `‖z + 2j‖/‖w + 2j‖ ≤ 1 + 2/Im w` for `‖z − w‖ ≤ 2`. Down to `Re w ∈ [2, 4)` in
`n ≤ Re w/2 ≤ T/128` steps, the product is at most `(1 + 8/T)^n ≤ e`; up by one step for
`Re w < 2`, the factor `‖w‖/‖z‖ ≤ 2`. Then `GrRatio.gamma_ratio8` at bounded real part.

| name | content | status |
|---|---|---|
| `GR` | the shifted ratio | defined |
| `GR_add_two`, `GR_shift` | the shift by `2`, by `2n` | proved |
| `gamma_ratio_far` | `GR ≤ B` for `Re ∈ [1/16, T/64]`, `Im ∈ [T/4, 2T]`, nearby points | proved |
| `analyticAt_V_im` | `V` analytic on `Im > 0` | proved |
| `V_right_le` | `‖V(X + it) − Q(0) ζ(X + it)‖ ≤ C/L` for `3 ≤ X ≤ T/128` | proved |
| `V_disc_le` | `‖V w‖ ≤ C T` for `Re w ∈ [1/8, T/128]`, `Im w ∈ [T/4 + 1, 2T − 1]` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.GrRatio
import Stage3.DigammaBound
import Stage3.LevinsonMollEdge

noncomputable section

namespace FloorQ

open Complex Polynomial Metric Set

/-- The shifted ratio `‖Γℝ z‖/‖Γℝ w‖ · e^{−(log T/2)(Re z − Re w)}`. -/
def GR (T : ℝ) (z w : ℂ) : ℝ :=
  ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re))

theorem GR_nonneg (T : ℝ) (z w : ℂ) : 0 ≤ GR T z w := by
  unfold GR; positivity

/-- The shift by `2`. -/
theorem GR_add_two (T : ℝ) {z w : ℂ} (hz : 0 < z.re) (hw : 0 < w.re) :
    GR T (z + 2) (w + 2) = GR T z w * (‖z‖ / ‖w‖) := by
  have hz0 : z ≠ 0 := fun h => by rw [h, Complex.zero_re] at hz; exact lt_irrefl _ hz
  have hw0 : w ≠ 0 := fun h => by rw [h, Complex.zero_re] at hw; exact lt_irrefl _ hw
  have hGz : ‖Gammaℝ z‖ ≠ 0 := norm_ne_zero_iff.mpr (Gammaℝ_ne_zero_of_re_pos hz)
  have hGw : ‖Gammaℝ w‖ ≠ 0 := norm_ne_zero_iff.mpr (Gammaℝ_ne_zero_of_re_pos hw)
  have hwn : ‖w‖ ≠ 0 := norm_ne_zero_iff.mpr hw0
  have hre : (z + 2).re - (w + 2).re = z.re - w.re := by simp
  unfold GR
  rw [Gammaℝ_add_two hz0, Gammaℝ_add_two hw0, hre]
  simp only [norm_div, norm_mul]
  have hπ : ‖(Real.pi : ℂ)‖ ≠ 0 := by
    rw [Complex.norm_real]; exact norm_ne_zero_iff.mpr Real.pi_pos.ne'
  have h2 : ‖(2 : ℂ)‖ ≠ 0 := by norm_num
  field_simp

/-- The shift by `2n`, priced. -/
theorem GR_shift (T : ℝ) {z w : ℂ} (hz : 0 < z.re) (hw : 0 < w.re) (hzw : ‖z - w‖ ≤ 2)
    (hwi : 0 < w.im) (n : ℕ) :
    GR T (z + 2 * n) (w + 2 * n) ≤ GR T z w * (1 + 2 / w.im) ^ n := by
  induction n with
  | zero => simp
  | succ n ih =>
    have hzn : 0 < (z + 2 * (n : ℂ)).re := by simp; positivity
    have hwn : 0 < (w + 2 * (n : ℂ)).re := by simp; positivity
    have e1 : z + 2 * ((n + 1 : ℕ) : ℂ) = (z + 2 * (n : ℂ)) + 2 := by push_cast; ring
    have e2 : w + 2 * ((n + 1 : ℕ) : ℂ) = (w + 2 * (n : ℂ)) + 2 := by push_cast; ring
    rw [e1, e2, GR_add_two T hzn hwn]
    have hwim : (w + 2 * (n : ℂ)).im = w.im := by simp
    have hwnorm : w.im ≤ ‖w + 2 * (n : ℂ)‖ := by
      have := Complex.abs_im_le_norm (w + 2 * (n : ℂ))
      rw [hwim] at this
      linarith [le_abs_self w.im]
    have hwpos : 0 < ‖w + 2 * (n : ℂ)‖ := by linarith
    have hrat : ‖z + 2 * (n : ℂ)‖ / ‖w + 2 * (n : ℂ)‖ ≤ 1 + 2 / w.im := by
      rw [div_le_iff₀ hwpos]
      have h1 : ‖z + 2 * (n : ℂ)‖ ≤ ‖w + 2 * (n : ℂ)‖ + 2 := by
        have : z + 2 * (n : ℂ) = (w + 2 * (n : ℂ)) + (z - w) := by ring
        rw [this]
        exact (norm_add_le _ _).trans (by linarith)
      have h2 : 2 ≤ 2 / w.im * ‖w + 2 * (n : ℂ)‖ := by
        rw [div_mul_eq_mul_div, le_div_iff₀ hwi]
        linarith
      nlinarith
    rw [pow_succ, ← mul_assoc]
    exact mul_le_mul ih hrat (by positivity)
      (mul_nonneg (GR_nonneg T z w) (by positivity))

/-- **The gamma ratio far right.** For `T ≥ 64`, `Re z, Re w ≥ 1/16`, `|Re z − Re w| ≤ 1`,
`Re w ≤ T/64`, `Im z, Im w ∈ [T/4, 2T]` and `|Im z − Im w| ≤ 1`: `GR T z w ≤ B`. -/
theorem gamma_ratio_far : ∃ B : ℝ, 0 < B ∧ ∀ T : ℝ, 64 ≤ T → ∀ z w : ℂ,
    1 / 16 ≤ z.re → 1 / 16 ≤ w.re → |z.re - w.re| ≤ 1 → w.re ≤ T / 64 →
    T / 4 ≤ z.im → z.im ≤ 2 * T → T / 4 ≤ w.im → w.im ≤ 2 * T → |z.im - w.im| ≤ 1 →
    GR T z w ≤ B := by
  obtain ⟨B₀, hB₀, hB⟩ := GrRatio.gamma_ratio8
  refine ⟨3 * B₀, by positivity, ?_⟩
  intro T hT z w hz hw hzw hwT hzi1 hzi2 hwi1 hwi2 hzwi
  have hT0 : 0 < T := by linarith
  obtain ⟨h1, h2⟩ := abs_le.mp hzw
  have hnorm : ‖z - w‖ ≤ 2 := by
    refine (Complex.norm_le_abs_re_add_abs_im _).trans ?_
    simp only [Complex.sub_re, Complex.sub_im]
    linarith
  rcases lt_or_ge w.re 2 with hw2 | hw2
  · -- shift up once
    have hz' : 0 < z.re := by linarith
    have hw' : 0 < w.re := by linarith
    have hs := GR_add_two T hz' hw'
    have hb := hB T (by linarith) (z + 2) (w + 2) (by simp; linarith) (by simp; linarith)
      (by simp; linarith) (by simp; linarith) (by simp; linarith) (by simp; linarith)
      (by simp; linarith) (by simp; linarith) (by simp; exact hzwi)
    have hbGR : GR T (z + 2) (w + 2) ≤ B₀ := hb
    rw [hs] at hbGR
    have hzn : z.im ≤ ‖z‖ := (le_abs_self _).trans (Complex.abs_im_le_norm z)
    have hzpos : 0 < ‖z‖ := by linarith
    have hwz : ‖w‖ ≤ ‖z‖ + 2 := by
      have : w = z + (w - z) := by ring
      rw [this]
      refine (norm_add_le _ _).trans ?_
      rw [norm_sub_rev]; linarith
    have hratio : ‖w‖ / ‖z‖ ≤ 2 := by
      rw [div_le_iff₀ hzpos]; linarith
    have hwpos : 0 < ‖w‖ := by
      have : w.im ≤ ‖w‖ := (le_abs_self _).trans (Complex.abs_im_le_norm w)
      linarith
    have hq : 0 < ‖z‖ / ‖w‖ := by positivity
    have e : GR T z w = GR T z w * (‖z‖ / ‖w‖) * (‖w‖ / ‖z‖) := by
      field_simp
    rw [e]
    calc GR T z w * (‖z‖ / ‖w‖) * (‖w‖ / ‖z‖) ≤ B₀ * 2 :=
          mul_le_mul hbGR hratio (by positivity) hB₀.le
      _ ≤ 3 * B₀ := by linarith
  · -- shift down `n` times
    obtain ⟨n, hn⟩ : ∃ n : ℕ, n = ⌊(w.re - 2) / 2⌋₊ := ⟨_, rfl⟩
    have hn1 : (n : ℝ) ≤ (w.re - 2) / 2 := by rw [hn]; exact Nat.floor_le (by linarith)
    have hn2 : (w.re - 2) / 2 < (n : ℝ) + 1 := by rw [hn]; exact Nat.lt_floor_add_one _
    set z' : ℂ := z - 2 * (n : ℂ) with hz'
    set w' : ℂ := w - 2 * (n : ℂ) with hw'
    have hz're : z'.re = z.re - 2 * n := by rw [hz']; simp
    have hw're : w'.re = w.re - 2 * n := by rw [hw']; simp
    have hz'im : z'.im = z.im := by rw [hz']; simp
    have hw'im : w'.im = w.im := by rw [hw']; simp
    have hb := hB T (by linarith) z' w' (by rw [hz're]; linarith) (by rw [hz're]; linarith)
      (by rw [hw're]; linarith) (by rw [hw're]; linarith) (by rw [hz'im]; linarith)
      (by rw [hz'im]; linarith) (by rw [hw'im]; linarith) (by rw [hw'im]; linarith)
      (by rw [hz'im, hw'im]; exact hzwi)
    have hbGR : GR T z' w' ≤ B₀ := hb
    have hzw' : ‖z' - w'‖ ≤ 2 := by
      have : z' - w' = z - w := by rw [hz', hw']; ring
      rw [this]; exact hnorm
    have hsh := GR_shift T (z := z') (w := w') (by rw [hz're]; linarith) (by rw [hw're]; linarith)
      hzw' (by rw [hw'im]; linarith) n
    have e1 : z' + 2 * (n : ℂ) = z := by rw [hz']; ring
    have e2 : w' + 2 * (n : ℂ) = w := by rw [hw']; ring
    rw [e1, e2, hw'im] at hsh
    -- `(1 + 2/Im w)^n ≤ e ≤ 3`
    have hwi0 : 0 < w.im := by linarith
    have hx : 2 / w.im ≤ 8 / T := by
      rw [div_le_div_iff₀ hwi0 hT0]; linarith
    have hpow : (1 + 2 / w.im) ^ n ≤ Real.exp (n * (8 / T)) := by
      calc (1 + 2 / w.im) ^ n ≤ (Real.exp (8 / T)) ^ n := by
            apply pow_le_pow_left₀ (by positivity)
            have := Real.add_one_le_exp (8 / T)
            linarith
        _ = Real.exp (n * (8 / T)) := by rw [← Real.exp_nat_mul]
    have hn8 : (n : ℝ) * (8 / T) ≤ 1 := by
      have : (n : ℝ) ≤ T / 128 := by linarith
      rw [mul_div_assoc', div_le_one hT0]; linarith
    have he : Real.exp ((n : ℝ) * (8 / T)) ≤ 3 := by
      calc Real.exp ((n : ℝ) * (8 / T)) ≤ Real.exp 1 := Real.exp_le_exp.mpr hn8
        _ ≤ 3 := by linarith [Real.exp_one_lt_d9]
    calc GR T z w ≤ GR T z' w' * (1 + 2 / w.im) ^ n := hsh
      _ ≤ B₀ * 3 := mul_le_mul hbGR (hpow.trans he) (by positivity) hB₀.le
      _ = 3 * B₀ := by ring

/-- `V` is analytic on `Im > 0`. -/
theorem analyticAt_V_im (Q : ℝ[X]) (L : ℝ) {w : ℂ} (hw : 0 < w.im) :
    AnalyticAt ℂ (ConreyCount.V Q L) w := by
  have h0 : w ≠ 0 := fun h => by rw [h, Complex.zero_im] at hw; exact lt_irrefl _ hw
  have h1 : w ≠ 1 := fun h => by rw [h, Complex.one_im] at hw; exact lt_irrefl _ hw
  exact ConreyCount.analyticAt_V Q L h0 h1 (ConreyCount.Gammaℝ_ne_of_im hw.ne')

/-- **`V` far right.** For `Q` and `T ≥ max 64 (e)`, `3 ≤ X ≤ T/128`, `t ∈ [T/4 + 1, 2T − 1]`:
`‖V(X + it) − Q(0) ζ(X + it)‖ ≤ C_V / log T`, `C_V = 2 K_Q B`. -/
theorem V_right_le (Q : ℝ[X]) : ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, 64 ≤ T → 1 ≤ Real.log T →
    ∀ xR t : ℝ, 3 ≤ xR → xR ≤ T / 128 → T / 4 + 1 ≤ t → t ≤ 2 * T - 1 →
    ‖ConreyCount.V Q (Real.log T) ((xR : ℂ) + t * I) - (Q.coeff 0 : ℂ) *
      riemannZeta ((xR : ℂ) + t * I)‖ ≤ C / Real.log T := by
  obtain ⟨B, hB, hBr⟩ := gamma_ratio_far
  have hK := DigammaBound.KQ_nonneg Q
  refine ⟨DigammaBound.KQ Q * (2 * B), by positivity, ?_⟩
  intro T hT hL xR t hX3 hXT ht1 ht2
  set w : ℂ := (xR : ℂ) + t * I with hw
  have hwre : w.re = xR := by rw [hw]; simp
  have hwim : w.im = t := by rw [hw]; simp
  have hL0 : 0 < Real.log T := by linarith
  have hsph : ∀ z ∈ closedBall w 1, 2 ≤ z.re ∧ |z.re - w.re| ≤ 1 ∧ |z.im - w.im| ≤ 1 := by
    intro z hz
    rw [mem_closedBall, dist_eq_norm] at hz
    have h1 := (Complex.abs_re_le_norm (z - w)).trans hz
    have h2 := (Complex.abs_im_le_norm (z - w)).trans hz
    rw [Complex.sub_re] at h1
    rw [Complex.sub_im] at h2
    refine ⟨?_, h1, h2⟩
    have := (abs_le.mp h1).1
    linarith
  have hd : DifferentiableOn ℂ (DigammaBound.H (Real.log T) w) (closedBall w 1) := by
    intro z hz
    obtain ⟨h2, -, -⟩ := hsph z hz
    have hz1 : z ≠ 1 := fun h => by rw [h, Complex.one_re] at h2; linarith
    exact (DigammaBound.differentiableAt_H _ w (by linarith) hz1).differentiableWithinAt
  have hM : ∀ z ∈ sphere w 1, ‖DigammaBound.H (Real.log T) w z‖ ≤ 2 * B := by
    intro z hz
    obtain ⟨h2, h3, h4⟩ := hsph z (sphere_subset_closedBall hz)
    rw [DigammaBound.norm_H]
    have hz' := DigammaBound.zeta_norm_le_two h2
    have hπ : Real.pi ^ 2 / 6 ≤ 2 := by nlinarith [Real.pi_lt_d2, Real.pi_pos]
    obtain ⟨h4a, h4b⟩ := abs_le.mp h4
    have hg : GR T z w ≤ B := hBr T hT z w (by linarith) (by rw [hwre]; linarith) h3
      (by rw [hwre]; linarith) (by rw [hwim] at h4a; linarith) (by rw [hwim] at h4b; linarith)
      (by rw [hwim]; linarith) (by rw [hwim]; linarith) h4
    unfold GR at hg
    exact mul_le_mul (hz'.trans hπ) hg (by positivity) (by norm_num)
  have hw1 : w ≠ 1 := by
    intro h
    have h' := congrArg Complex.re h
    rw [hwre, Complex.one_re] at h'
    linarith
  have h := DigammaBound.V_sub_le Q hL0 one_pos (by linarith) (by positivity)
    (w := w) (by rw [hwre]; linarith) hw1 hd hM
  simpa only [mul_one] using h

/-- **`V` on the growth discs.** For `T ≥ 64` with `16 ≤ log T`, `Re w ∈ [1/8, T/128]`,
`Im w ∈ [T/4 + 1, 2T − 1]`: `‖V w‖ ≤ C_D T`, `C_D = 34 K_Q B`. -/
theorem V_disc_le (Q : ℝ[X]) : ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, 64 ≤ T → 16 ≤ Real.log T →
    ∀ w : ℂ, 1 / 8 ≤ w.re → w.re ≤ T / 128 → T / 4 + 1 ≤ w.im → w.im ≤ 2 * T - 1 →
    ‖ConreyCount.V Q (Real.log T) w‖ ≤ C * T := by
  obtain ⟨B, hB, hBr⟩ := gamma_ratio_far
  have hK := DigammaBound.KQ_nonneg Q
  refine ⟨DigammaBound.KQ Q * (34 * B), by positivity, ?_⟩
  intro T hT hL w hw1 hw2 hw3 hw4
  have hL0 : 0 < Real.log T := by linarith
  have hT0 : 0 < T := by linarith
  have hsph : ∀ z ∈ closedBall w (1 / 16), 1 / 16 ≤ z.re ∧ |z.re - w.re| ≤ 1 / 16 ∧
      |z.im - w.im| ≤ 1 / 16 ∧ ‖z‖ ≤ ‖w‖ + 1 := by
    intro z hz
    rw [mem_closedBall, dist_eq_norm] at hz
    have h1 := (Complex.abs_re_le_norm (z - w)).trans hz
    have h2 := (Complex.abs_im_le_norm (z - w)).trans hz
    rw [Complex.sub_re] at h1
    rw [Complex.sub_im] at h2
    refine ⟨?_, h1, h2, ?_⟩
    · have := (abs_le.mp h1).1
      linarith
    · have : z = w + (z - w) := by ring
      rw [this]
      exact (norm_add_le _ _).trans (by linarith)
  have hwn : ‖w‖ ≤ T / 128 + 2 * T := by
    refine (Complex.norm_le_abs_re_add_abs_im w).trans ?_
    rw [abs_of_pos (by linarith), abs_of_pos (by linarith)]
    linarith
  have hd : DifferentiableOn ℂ (DigammaBound.H (Real.log T) w) (closedBall w (1 / 16)) := by
    intro z hz
    obtain ⟨h1, -, h3, -⟩ := hsph z hz
    obtain ⟨h3a, -⟩ := abs_le.mp h3
    have hz1 : z ≠ 1 := fun h => by
      rw [h, Complex.one_im] at h3a; linarith
    exact (DigammaBound.differentiableAt_H _ w (by linarith) hz1).differentiableWithinAt
  have hM : ∀ z ∈ sphere w (1 / 16), ‖DigammaBound.H (Real.log T) w z‖ ≤ 34 * B * T := by
    intro z hz
    obtain ⟨h1, h2, h3, h4⟩ := hsph z (sphere_subset_closedBall hz)
    obtain ⟨h3a, h3b⟩ := abs_le.mp h3
    rw [DigammaBound.norm_H]
    have hz' := LevinsonMollEdge.zeta_norm_le_sixteenth h1 (by linarith)
    have hζ : ‖riemannZeta z‖ ≤ 34 * T := by nlinarith
    have hg : GR T z w ≤ B := hBr T hT z w h1 (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith) (by linarith) (by linarith) (by linarith)
    unfold GR at hg
    calc ‖riemannZeta z‖ * (‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) *
          (z.re - w.re))) ≤ (34 * T) * B := mul_le_mul hζ hg (by positivity) (by positivity)
      _ = 34 * B * T := by ring
  have hw1 : w ≠ 1 := by
    intro h
    have h' := congrArg Complex.im h
    rw [Complex.one_im] at h'
    linarith
  have h := DigammaBound.V_norm_le Q hL0 (R := 1 / 16) (by norm_num) (by linarith)
    (by positivity) (w := w) (by linarith) hw1 hd hM
  calc _ ≤ DigammaBound.KQ Q * (34 * B * T) := h
    _ = DigammaBound.KQ Q * (34 * B) * T := by ring

/-- info: 'FloorQ.GR_shift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms GR_shift

/-- info: 'FloorQ.gamma_ratio_far' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_ratio_far

/-- info: 'FloorQ.analyticAt_V_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analyticAt_V_im

/-- info: 'FloorQ.V_right_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_right_le

/-- info: 'FloorQ.V_disc_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_disc_le

end FloorQ

end
