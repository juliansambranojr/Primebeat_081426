/-
StirlingSeriesK5 — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: the phase of
`Γ(1/4 + it/2)` from Stirling's series with the four terms `B₂ … B₈` (`S₅`). 2026-11-25.

`StirlingSeriesBern.stirling_series_explicit` at `K = 4` bounds `logG z − S₅(z) − ½ log 2π` by
`4·8!/6⁸/8·(6/|Im z|)/‖z‖⁶ ≤ 10/|t|⁷` at `z = zz t`, `|t| ≥ 1` (`delta5_le`). The imaginary part of
`S_K(z)` is a closed form in `log(t/2)`, `π`, the series of `log(1 − i/(2t))` and
`σ_K = Im Σ_{k<K} c_k z^{1−2k}`, for any `K` (`im_stirMain_ball`); at `K = 5`,
`c = 1/12, −1/360, 1/1260, −1/1680` (`stirC_three`, `stirC_four`, from `B₆ = 1/42`, `B₈ = −1/30`)
and `σ₅` is a rational function of `t` (`sig5`, `stirSum5_im`). So
`|Im logG(zz t) − φ₀| ≤ E + 10/|t|⁷` with one real ball for `log(t/2)` (`gamma_phase_ball5`).

| name | content | status |
|---|---|---|
| `bernoulli'_six`, `bernoulli'_eight`, `stirC_three`, `stirC_four` | `B₆ = 1/42`, `B₈ = −1/30`; `c₃ = 1/1260`, `c₄ = −1/1680` | proved |
| `stirSum5_eq`, `sig5`, `stirSum5_im` | `S₅`'s correction, and its imaginary part at `zz t` | proved |
| `delta5_le` | `1 ≤ |t|` ⊢ `‖logG z − S₅ z − ½ log 2π‖ ≤ 10/|t|⁷` | proved |
| `im_stirMain_ball` | `|Im S_K(zz t) − φ₀| ≤ E` from the closed form, any `K`, given `σ_K` | proved |
| `gamma_phase_ball5` | `|Im logG(zz t) − φ₀| ≤ E + 10/|t|⁷` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesBern
import Stage3.StirlingSeriesPhase

namespace StirlingSeries

open Complex SignData

noncomputable section

theorem bernoulli'_five : bernoulli' 5 = 0 := bernoulli'_eq_zero_of_odd ⟨2, rfl⟩ (by norm_num)

theorem bernoulli'_seven : bernoulli' 7 = 0 := bernoulli'_eq_zero_of_odd ⟨3, rfl⟩ (by norm_num)

theorem bernoulli'_six : bernoulli' 6 = 1 / 42 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one,
    bernoulli'_two, bernoulli'_three, bernoulli'_four, bernoulli'_five]
  norm_num [Nat.choose]

theorem bernoulli'_eight : bernoulli' 8 = -1 / 30 := by
  rw [bernoulli'_def]
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, bernoulli'_zero, bernoulli'_one,
    bernoulli'_two, bernoulli'_three, bernoulli'_four, bernoulli'_five, bernoulli'_six,
    bernoulli'_seven]
  norm_num [Nat.choose]

theorem stirC_three : stirC 3 = 1 / 1260 := by
  unfold stirC
  rw [show 2 * 3 = 6 from rfl, bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_six]
  push_cast
  norm_num

theorem stirC_four : stirC 4 = -1 / 1680 := by
  unfold stirC
  rw [show 2 * 4 = 8 from rfl, bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_eight]
  push_cast
  norm_num

theorem stirSum5_eq (w : ℂ) : stirSum 5 w = 1 / 12 * w⁻¹ - 1 / 360 * (w ^ 3)⁻¹
    + 1 / 1260 * (w ^ 5)⁻¹ - 1 / 1680 * (w ^ 7)⁻¹ := by
  unfold stirSum
  rw [Finset.sum_Ico_succ_top (by norm_num), Finset.sum_Ico_succ_top (by norm_num),
    Finset.sum_Ico_succ_top (by norm_num), Finset.sum_Ico_succ_top le_rfl, Finset.Ico_self,
    Finset.sum_empty, stirC_one, stirC_two, stirC_three, stirC_four]
  norm_num
  ring

/-- `Im` of `S₅`'s correction at `z = zz t`, with `p + iq = 1/z`. -/
def sig5 (t : ℝ) : ℝ :=
  let ρ := (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2
  let p := (1 / 4) / ρ
  let q := -(t / 2) / ρ
  1 / 12 * q - 1 / 360 * (3 * p ^ 2 * q - q ^ 3)
    + 1 / 1260 * (5 * p ^ 4 * q - 10 * p ^ 2 * q ^ 3 + q ^ 5)
    - 1 / 1680 * (7 * p ^ 6 * q - 35 * p ^ 4 * q ^ 3 + 21 * p ^ 2 * q ^ 5 - q ^ 7)

theorem zz_inv (t : ℝ) :
    (zz t)⁻¹ = cx ((1 / 4) / ((1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2))
      (-(t / 2) / ((1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2)) := by
  have hρ : (0 : ℝ) < (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2 := by positivity
  have hz0 : zz t ≠ 0 := by
    intro h; have := congrArg Complex.re h; rw [zz_re] at this; norm_num at this
  rw [inv_eq_one_div, div_eq_iff hz0]
  apply Complex.ext
  · simp [zz, cx]
    field_simp
    ring
  · simp [zz, cx]
    field_simp
    ring

theorem stirSum5_im (t : ℝ) : (stirSum 5 (zz t)).im = sig5 t := by
  rw [stirSum5_eq, ← inv_pow, ← inv_pow, ← inv_pow, zz_inv]
  simp only [sig5]
  simp [cx, pow_succ, pow_zero]
  ring

/-- **The remainder at `K = 5`**: `‖logG z − S₅ z − ½ log 2π‖ ≤ 10/|t|⁷` for `|t| ≥ 1`. -/
theorem delta5_le {t : ℝ} (ht : 1 ≤ |t|) :
    ‖Stirling.logG (zz t) - stirMain 5 (zz t) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ 10 / |t| ^ 7 := by
  have hz : 0 < (zz t).re := by rw [zz_re]; norm_num
  have him : |(zz t).im| = |t| / 2 := by rw [zz_im, abs_div, abs_two]
  have hY : 1 / 2 ≤ |(zz t).im| := by rw [him]; linarith
  have h := stirling_series_explicit hz hY (K := 4) (by norm_num)
  have ht0 : 0 < |t| := by linarith
  have hn := norm_zz_ge t
  rw [show 2 * 4 = 8 from rfl, show 8 - 2 = 6 from rfl,
    show (2 * ((4 : ℕ) : ℝ)) = 8 by norm_num, him] at h
  refine h.trans ?_
  have hz6 : (|t| / 2) ^ 6 ≤ ‖zz t‖ ^ 6 := pow_le_pow_left₀ (by positivity) hn 6
  have e1 : 4 * ((Nat.factorial 8 : ℕ) : ℝ) / 6 ^ 8 / 8 * (6 / (|t| / 2)) / ‖zz t‖ ^ 6
      ≤ 4 * ((Nat.factorial 8 : ℕ) : ℝ) / 6 ^ 8 / 8 * (6 / (|t| / 2)) / (|t| / 2) ^ 6 :=
    div_le_div_of_nonneg_left (by positivity) (by positivity) hz6
  refine e1.trans ?_
  rw [Nat.factorial]
  norm_num [Nat.factorial]
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  have e2 : 35 / 2916 * (6 / (|t| / 2)) * |t| ^ 7 = 35 / 2916 * 12 * |t| ^ 6 := by
    field_simp
    ring
  have e3 : (|t| / 2) ^ 6 = |t| ^ 6 / 64 := by ring
  have h6 : 0 < |t| ^ 6 := by positivity
  linarith

/-- **`Im S_K(zz t)` in closed form**, for any `K`, given `σ = Im Σ_{k<K} c_k z^{1−2k}`. -/
theorem im_stirMain_ball (K : ℕ) {t ℓ eℓ σ φ₀ E : ℝ} (ht : 0 < t) (hy1 : 1 / (2 * t) < 1)
    (hℓ : |Real.log (t / 2) - ℓ| ≤ eℓ) (hσ : (stirSum K (zz t)).im = σ)
    (hφ : |(t / 2) * (ℓ + (1 / (2 * t)) ^ 2 / 2 - (1 / (2 * t)) ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-(1 / (2 * t)) + (1 / (2 * t)) ^ 3 / 3
          - (1 / (2 * t)) ^ 5 / 5)) / 4 - t / 2 + σ - φ₀|
      + (t / 2) * (eℓ + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6)
      + (1 / 10 ^ 20 / 2 + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6) / 4 ≤ E) :
    |(stirMain K (zz t)).im - φ₀| ≤ E := by
  set y := 1 / (2 * t) with hy
  have hy0 : 0 ≤ y := by positivity
  set τ := y ^ 6 * (1 - y)⁻¹ / 6 with hτ
  have hL := log_one_sub_ball hy0 hy1
  rw [← hτ] at hL
  set Lw := log (1 + cx 0 (-y)) with hLw
  have hre : |Lw.re - (y ^ 2 / 2 - y ^ 4 / 4)| ≤ τ := by
    have := (Complex.abs_re_le_norm _).trans hL
    simpa [cx] using this
  have him : |Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5)| ≤ τ := by
    have := (Complex.abs_im_le_norm _).trans hL
    simpa [cx] using this
  have hlog := log_zz_eq ht
  rw [← hy, ← hLw] at hlog
  have hM : (stirMain K (zz t)).im
      = (t / 2) * (Real.log (t / 2) + Lw.re) - (Real.pi / 2 + Lw.im) / 4 - t / 2 + σ := by
    unfold stirMain
    rw [Complex.add_im, hσ, hlog]
    simp [zz]
    ring
  have hp := pi_ball
  rw [hM]
  have e : (t / 2) * (Real.log (t / 2) + Lw.re) - (Real.pi / 2 + Lw.im) / 4 - t / 2 + σ - φ₀
      = ((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + σ - φ₀)
        + (t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4)))
        - ((Real.pi - 3.14159265358979323846) / 2 + (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))) / 4 := by
    ring
  rw [e]
  have ht2 : 0 < t / 2 := by positivity
  have h1 : |(t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4)))|
      ≤ (t / 2) * (eℓ + τ) := by
    rw [abs_mul, abs_of_pos ht2]
    apply mul_le_mul_of_nonneg_left _ ht2.le
    have := abs_add_le (Real.log (t / 2) - ℓ) (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))
    linarith
  have h2 : |((Real.pi - 3.14159265358979323846) / 2 + (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))) / 4|
      ≤ (1 / 10 ^ 20 / 2 + τ) / 4 := by
    rw [abs_div, abs_of_pos (by norm_num : (0 : ℝ) < 4)]
    apply div_le_div_of_nonneg_right _ (by norm_num)
    have := abs_add_le ((Real.pi - 3.14159265358979323846) / 2)
      (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))
    rw [abs_div, abs_two] at this
    linarith
  have h3 := abs_add_le ((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + σ - φ₀)
    ((t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))))
  have h4 := abs_sub (((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + σ - φ₀)
      + (t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))))
    (((Real.pi - 3.14159265358979323846) / 2 + (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))) / 4)
  linarith

/-- **The phase of `Γ(1/4 + it/2)` in a ball, `K = 5`**: `|Im logG(zz t) − φ₀| ≤ E + 10/t⁷`. -/
theorem gamma_phase_ball5 {t ℓ eℓ φ₀ E : ℝ} (ht : 1 ≤ t) (hℓ : |Real.log (t / 2) - ℓ| ≤ eℓ)
    (hφ : |(t / 2) * (ℓ + (1 / (2 * t)) ^ 2 / 2 - (1 / (2 * t)) ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-(1 / (2 * t)) + (1 / (2 * t)) ^ 3 / 3
          - (1 / (2 * t)) ^ 5 / 5)) / 4 - t / 2 + sig5 t - φ₀|
      + (t / 2) * (eℓ + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6)
      + (1 / 10 ^ 20 / 2 + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6) / 4 ≤ E) :
    |(Stirling.logG (zz t)).im - φ₀| ≤ E + 10 / t ^ 7 := by
  have ht0 : 0 < t := by linarith
  have hy1 : 1 / (2 * t) < 1 := by rw [div_lt_one (by positivity)]; linarith
  have h1 := im_stirMain_ball 5 ht0 hy1 hℓ (stirSum5_im t) hφ
  have hat : |t| = t := abs_of_pos ht0
  have h2 := (Complex.abs_im_le_norm _).trans (delta5_le (t := t) (by rw [hat]; exact ht))
  rw [hat] at h2
  have e : (Stirling.logG (zz t) - stirMain 5 (zz t)
      - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)).im
      = (Stirling.logG (zz t)).im - (stirMain 5 (zz t)).im := by simp
  rw [e] at h2
  have := abs_add_le ((Stirling.logG (zz t)).im - (stirMain 5 (zz t)).im)
    ((stirMain 5 (zz t)).im - φ₀)
  rw [show (Stirling.logG (zz t)).im - (stirMain 5 (zz t)).im + ((stirMain 5 (zz t)).im - φ₀)
    = (Stirling.logG (zz t)).im - φ₀ by ring] at this
  linarith

end

/-- info: 'StirlingSeries.delta5_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms delta5_le

/-- info: 'StirlingSeries.gamma_phase_ball5' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_phase_ball5

end StirlingSeries
