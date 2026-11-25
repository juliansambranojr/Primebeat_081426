/-
StirlingSeriesPhase — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: the phase of
`Gammaℝ` on the line from Stirling's series, in a fixed number of balls. 2026-11-25.

`SignDataGamma.re_lambda_eq` reads the phase of `Γ(1/4 + it/2)` from `GammaSeq z n` with
`n ≥ (2‖z‖ + ‖z‖²)/(3/2) ≈ t²/6` factors, because its tail `tail_le` is `O(‖z‖²/n)`: the
lost factor is `‖z‖²`, one ball per factor. Here the tail is Stirling's remainder
(`StirlingSeriesLim.stirling_series`): with `z = zz t`, `Γ(z) = e^{S_K(z) + ½ log 2π + δ}` and
`‖δ‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}`, so

  Λ(1/2 + it) = κ · e^δ · e^{iφ_K(t)} · ζ(1/2 + it),   κ > 0,
  φ_K(t) = Im S_K(z) − (t/2) log π                                     (`stirPhase`),

and, `Λ` being real, `Re Λ = c · Re(e^{iφ_K} ζ)` with `c > 0` once `‖δ‖ ≤ 3/2`
(`re_lambda_eq_stir`). For `K = 3` (the terms `B₂/(12z)`, `B₄/(360z³)`), `bernBound 4 ≤ 1/30`
(`SignDataZeta.bernBound_four_le`) gives `‖δ‖ ≤ (2/5)/|t|³`, in particular `≤ 3/2` for
`|t| ≥ 1` (`delta3_le`). The phase itself is a closed form in `log(t/2)`, `π`, `log π` and the
series of `log(1 − i/(2t))` (`log_zz_eq`, `log_one_sub_ball`, `stirPhase3_ball`): a constant number
of real balls, whatever `t` is. So the Gamma side costs `O(K)` balls per point.

| name | content | status |
|---|---|---|
| `stirPhase`, `stirDir` | `φ_K(t) = Im S_K(zz t) − (t/2) log π`; `e^{iφ_K(t)}` | def |
| `re_of_real_factor` | `Λ` real, `Λ = κ e^δ X`, `κ > 0`, `‖δ‖ ≤ 3/2` ⊢ `∃ c > 0, Re Λ = c Re X` | proved |
| `re_lambda_eq_stir` | `‖logG z − S_K z − ½ log 2π‖ ≤ 3/2` ⊢ `∃ c > 0, Re Λ = c Re(stirDir K t · ζ)` | proved |
| `delta3_le`, `im_logG_ball` | `1 ≤ |t|` ⊢ `‖logG z − S₃ z − ½ log 2π‖ ≤ (2/5)/|t|³ ≤ 3/2`; the phase of `Γ` to `(2/5)/|t|³` | proved |
| `re_lambda_eq_stir3`, `re_lambda_pos_stir3`, `re_lambda_neg_stir3` | `1 ≤ |t|` ⊢ the sign of `Re Λ` from a ball for `stirDir 3 t · ζ` | proved |
| `stirSum3_im` | `Im S₃` correction as a rational function of `t` | proved |
| `log_zz_eq`, `log_one_sub_ball` | `log z = log(t/2) + iπ/2 + log(1 − i/(2t))`; the latter to `y⁶/(6(1−y))` | proved |
| `stirPhase3_ball` | `|φ₃(t) − φ₀| ≤ |t/2|(e_ℓ + τ + e_π) + (10^{−20}/2 + τ)/4` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesLim
import Stage3.SignDataGamma

namespace StirlingSeries

open Complex SignData

noncomputable section

/-- The Stirling phase `φ_K(t) = Im S_K(1/4 + it/2) − (t/2) log π`. -/
def stirPhase (K : ℕ) (t : ℝ) : ℝ := (stirMain K (zz t)).im - t / 2 * Real.log Real.pi

/-- The Stirling direction `e^{iφ_K(t)}`. -/
def stirDir (K : ℕ) (t : ℝ) : ℂ := cexp (((stirPhase K t : ℝ) : ℂ) * I)

theorem zz_im (t : ℝ) : (zz t).im = t / 2 := by simp [zz]

/-- **A real number with a known factorization**: `Λ` real, `Λ = κ e^δ X`, `κ > 0`, `‖δ‖ ≤ 3/2`
⊢ `Re Λ = c · Re X` with `c > 0`. -/
theorem re_of_real_factor {Λ X δ : ℂ} {κ : ℝ} (hreal : Λ.im = 0) (hκ : 0 < κ)
    (hδ : ‖δ‖ ≤ 3 / 2) (h : Λ = (κ : ℂ) * cexp δ * X) : ∃ c : ℝ, 0 < c ∧ Λ.re = c * X.re := by
  have hΛ : Λ = (Λ.re : ℂ) := by
    apply Complex.ext
    · simp
    · simp [hreal]
  have h3 : (κ : ℂ) * cexp δ ≠ 0 := mul_ne_zero (by exact_mod_cast hκ.ne') (Complex.exp_ne_zero _)
  have hXeq : X = ((Λ.re / κ : ℝ) : ℂ) * cexp (-δ) := by
    have h4 : X = Λ / ((κ : ℂ) * cexp δ) := by
      rw [h, mul_div_cancel_left₀ _ h3]
    rw [h4, Complex.exp_neg]
    conv_lhs => rw [hΛ]
    push_cast
    field_simp
  have him : |δ.im| ≤ 3 / 2 := (Complex.abs_im_le_norm δ).trans hδ
  have hpi : 3 / 2 < Real.pi / 2 := by linarith [Real.pi_gt_three]
  have hcos : 0 < Real.cos (-δ.im) := by
    apply Real.cos_pos_of_mem_Ioo
    constructor <;> linarith [(abs_le.mp him).1, (abs_le.mp him).2]
  set μ := Real.exp (-δ.re) * Real.cos (-δ.im) with hμ
  have hμ0 : 0 < μ := mul_pos (Real.exp_pos _) hcos
  have hXre : X.re = Λ.re / κ * μ := by
    rw [hXeq, Complex.re_ofReal_mul, Complex.exp_re]
    simp [hμ]
  refine ⟨κ / μ, div_pos hκ hμ0, ?_⟩
  rw [hXre]
  field_simp

/-- **The phase of `Gammaℝ` from Stirling's series**: if the Stirling remainder at `z = zz t` is at
most `3/2`, the sign of `Re Λ(1/2 + it)` is the sign of `Re(e^{iφ_K(t)} ζ(1/2 + it))`. -/
theorem re_lambda_eq_stir (K : ℕ) (t : ℝ)
    (hδ : ‖Stirling.logG (zz t) - stirMain K (zz t) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ 3 / 2) :
    ∃ c : ℝ, 0 < c ∧ (completedRiemannZeta (lineS t)).re
      = c * (stirDir K t * riemannZeta (lineS t)).re := by
  set z := zz t with hzdef
  have hz : 0 < z.re := by rw [hzdef, zz_re]; norm_num
  set Lc : ℝ := Real.log (2 * Real.pi) / 2 with hLc
  set M := stirMain K z with hM
  set δ := Stirling.logG z - M - (Lc : ℂ) with hδdef
  have hG : Complex.Gamma z = cexp (M + (Lc : ℂ) + δ) := by
    rw [← Stirling.exp_logG hz, hδdef]
    ring_nf
  set s := lineS t with hs
  have hs0 : s ≠ 0 := lineS_ne_zero t
  have hsre : 0 < s.re := by rw [hs, lineS_re]; norm_num
  have hΛ : completedRiemannZeta s = s.Gammaℝ * riemannZeta s := by
    rw [riemannZeta_def_of_ne_zero hs0]
    have hGR : s.Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hsre
    field_simp
  have hGR' : s.Gammaℝ = (Real.pi : ℂ) ^ (-z) * Complex.Gamma z := by
    have hs2 : s / 2 = z := by rw [hs, hzdef, lineS_div_two]
    rw [Complex.Gammaℝ_def, neg_div, hs2]
  have hpi0 : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  set κ0 : ℝ := -(Real.log Real.pi / 4) + M.re + Lc with hκ0
  have hexp : log (Real.pi : ℂ) * (-z) + (M + (Lc : ℂ))
      = (κ0 : ℂ) + ((stirPhase K t : ℝ) : ℂ) * I := by
    rw [← Complex.ofReal_log Real.pi_pos.le]
    apply Complex.ext
    · simp [hzdef, zz, hκ0]
      ring
    · simp [hzdef, zz, stirPhase, hM]
      ring
  have hmain : completedRiemannZeta s
      = ((Real.exp κ0 : ℝ) : ℂ) * cexp δ * (stirDir K t * riemannZeta s) := by
    rw [hΛ, hGR', hG, Complex.cpow_def_of_ne_zero hpi0, ← Complex.exp_add]
    have : log (Real.pi : ℂ) * -z + (M + (Lc : ℂ) + δ)
        = (log (Real.pi : ℂ) * (-z) + (M + (Lc : ℂ))) + δ := by ring
    rw [this, hexp, Complex.exp_add, Complex.exp_add, Complex.ofReal_exp]
    unfold stirDir
    ring
  have hreal : (completedRiemannZeta s).im = 0 := by rw [hs]; exact HardyZ.xi_line_real t
  exact re_of_real_factor hreal (Real.exp_pos κ0) hδ hmain

theorem norm_zz_ge (t : ℝ) : |t| / 2 ≤ ‖zz t‖ := by
  have h := Complex.abs_im_le_norm (zz t)
  rw [zz_im, abs_div, abs_two] at h
  exact h

/-- **The remainder at `K = 3`**: for `|t| ≥ 1`, `‖logG z − S₃ z − ½ log 2π‖ ≤ (2/5)/|t|³`. -/
theorem delta3_le' {t : ℝ} (ht : 1 ≤ |t|) :
    ‖Stirling.logG (zz t) - stirMain 3 (zz t) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ 2 / 5 / |t| ^ 3 := by
  have hz : 0 < (zz t).re := by rw [zz_re]; norm_num
  have hY : 1 / 2 ≤ |(zz t).im| := by
    rw [zz_im, abs_div, abs_two]; linarith
  have h := stirling_series hz hY (K := 2) (by norm_num)
  have hB := SignData.bernBound_four_le
  have ht0 : 0 < |t| := by linarith
  have hn := norm_zz_ge t
  have him : |(zz t).im| = |t| / 2 := by rw [zz_im, abs_div, abs_two]
  rw [show 2 * 2 = 4 from rfl, show 4 - 2 = 2 from rfl,
    show (2 * ((2 : ℕ) : ℝ)) = 4 by norm_num, him] at h
  refine h.trans ?_
  have hz2 : (|t| / 2) ^ 2 ≤ ‖zz t‖ ^ 2 := pow_le_pow_left₀ (by positivity) hn 2
  have hB0 := ZetaEM.bernBound_nonneg 4
  have e1 : ZetaEM.bernBound 4 / 4 * (6 / (|t| / 2)) / ‖zz t‖ ^ 2
      ≤ (1 / 30) / 4 * (6 / (|t| / 2)) / (|t| / 2) ^ 2 := by
    apply div_le_div₀ (by positivity) _ (by positivity) hz2
    apply mul_le_mul_of_nonneg_right _ (by positivity)
    linarith
  refine e1.trans (le_of_eq ?_)
  field_simp
  ring

theorem delta3_le {t : ℝ} (ht : 1 ≤ |t|) :
    ‖Stirling.logG (zz t) - stirMain 3 (zz t) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ 3 / 2 := by
  refine (delta3_le' ht).trans ?_
  have h1 : 1 ≤ |t| ^ 3 := one_le_pow₀ ht
  rw [div_le_iff₀ (by positivity)]
  nlinarith

/-- **The phase of `Γ(1/4 + it/2)` to `(2/5)/|t|³`**: `|Im logG z − Im S₃ z| ≤ (2/5)/|t|³`. -/
theorem im_logG_ball {t : ℝ} (ht : 1 ≤ |t|) :
    |(Stirling.logG (zz t)).im - (stirMain 3 (zz t)).im| ≤ 2 / 5 / |t| ^ 3 := by
  have h := (Complex.abs_im_le_norm _).trans (delta3_le' ht)
  simpa using h

theorem re_lambda_eq_stir3 {t : ℝ} (ht : 1 ≤ |t|) :
    ∃ c : ℝ, 0 < c ∧ (completedRiemannZeta (lineS t)).re
      = c * (stirDir 3 t * riemannZeta (lineS t)).re :=
  re_lambda_eq_stir 3 t (delta3_le ht)

theorem re_lambda_pos_stir3 {t : ℝ} (ht : 1 ≤ |t|) {a b r : ℝ}
    (hX : ‖stirDir 3 t * riemannZeta (lineS t) - cx a b‖ ≤ r) (ha : r < a) :
    0 < (completedRiemannZeta (lineS t)).re := by
  obtain ⟨c, hc, h⟩ := re_lambda_eq_stir3 ht
  rw [h]
  exact mul_pos hc (re_pos_of_ball hX ha)

theorem re_lambda_neg_stir3 {t : ℝ} (ht : 1 ≤ |t|) {a b r : ℝ}
    (hX : ‖stirDir 3 t * riemannZeta (lineS t) - cx a b‖ ≤ r) (ha : a < -r) :
    (completedRiemannZeta (lineS t)).re < 0 := by
  obtain ⟨c, hc, h⟩ := re_lambda_eq_stir3 ht
  rw [h]
  exact mul_neg_of_pos_of_neg hc (re_neg_of_ball hX ha)

/-! ## The phase in closed form -/

theorem stirC_one : stirC 1 = 1 / 12 := by
  unfold stirC
  rw [show 2 * 1 = 2 from rfl, bernoulli_two]
  push_cast
  norm_num

theorem stirC_two : stirC 2 = -1 / 360 := by
  unfold stirC
  rw [show 2 * 2 = 4 from rfl, bernoulli_eq_bernoulli'_of_ne_one (by norm_num), bernoulli'_four]
  push_cast
  norm_num

theorem stirSum3_eq (w : ℂ) : stirSum 3 w = 1 / 12 * w⁻¹ - 1 / 360 * (w ^ 3)⁻¹ := by
  unfold stirSum
  rw [Finset.sum_Ico_succ_top (by norm_num), Finset.sum_Ico_succ_top le_rfl, Finset.Ico_self,
    Finset.sum_empty, stirC_one, stirC_two]
  norm_num
  ring

/-- `Im` of the correction `S₃ − ((z − ½) log z − z)` at `z = zz t`, with `p + iq = 1/z`. -/
def sig3 (t : ℝ) : ℝ :=
  let ρ := (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2
  let p := (1 / 4) / ρ
  let q := -(t / 2) / ρ
  1 / 12 * q - 1 / 360 * (3 * p ^ 2 * q - q ^ 3)

theorem stirSum3_im (t : ℝ) : (stirSum 3 (zz t)).im = sig3 t := by
  have hρ : (0 : ℝ) < (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2 := by positivity
  set ρ := (1 / 4 : ℝ) ^ 2 + (t / 2) ^ 2 with hρdef
  have hinv : (zz t)⁻¹ = cx ((1 / 4) / ρ) (-(t / 2) / ρ) := by
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
  rw [stirSum3_eq, ← inv_pow, hinv]
  simp only [sig3]
  simp [cx, pow_succ, pow_zero]
  ring

/-- `zz t = (t/2)·(i·(1 − i/(2t)))` and so `log z = log(t/2) + iπ/2 + log(1 − i/(2t))`, `t > 0`. -/
theorem log_zz_eq {t : ℝ} (ht : 0 < t) :
    log (zz t) = ((Real.log (t / 2) : ℝ) : ℂ) + ((Real.pi / 2 : ℝ) : ℂ) * I
      + log (1 + cx 0 (-(1 / (2 * t)))) := by
  have hw : (1 + cx 0 (-(1 / (2 * t)))).re = 1 := by simp [cx]
  have hu0 : 1 + cx 0 (-(1 / (2 * t))) ≠ 0 := by
    intro h; have := congrArg Complex.re h; rw [hw] at this; simp at this
  have e : zz t = ((t / 2 : ℝ) : ℂ) * (I * (1 + cx 0 (-(1 / (2 * t))))) := by
    apply Complex.ext
    · simp [zz, cx]
      field_simp
      norm_num
    · simp [zz, cx]
  have hIu : I * (1 + cx 0 (-(1 / (2 * t)))) ≠ 0 := mul_ne_zero I_ne_zero hu0
  rw [e, log_ofReal_mul (by positivity) hIu]
  have harg : |arg (1 + cx 0 (-(1 / (2 * t))))| < Real.pi / 2 :=
    abs_arg_lt_pi_div_two_iff.mpr (Or.inl (by rw [hw]; norm_num))
  have hmul : log (I * (1 + cx 0 (-(1 / (2 * t))))) = log I + log (1 + cx 0 (-(1 / (2 * t)))) := by
    apply (log_mul_eq_add_log_iff I_ne_zero hu0).mpr
    rw [arg_I]
    obtain ⟨h1, h2⟩ := abs_lt.mp harg
    constructor <;> linarith [Real.pi_pos]
  rw [hmul, log_I]
  push_cast
  ring

/-- The series of `log(1 − iy)` to degree five: `‖log(1 − iy) − (y²/2 − y⁴/4) − i(−y + y³/3 − y⁵/5)‖
≤ y⁶/(6(1 − y))` for `0 ≤ y < 1`. -/
theorem log_one_sub_ball {y : ℝ} (hy : 0 ≤ y) (hy1 : y < 1) :
    ‖log (1 + cx 0 (-y)) - cx (y ^ 2 / 2 - y ^ 4 / 4) (-y + y ^ 3 / 3 - y ^ 5 / 5)‖
      ≤ y ^ 6 * (1 - y)⁻¹ / 6 := by
  have hn : ‖cx 0 (-y)‖ = y := by
    have : cx 0 (-y) = ((-y : ℝ) : ℂ) * I := by apply Complex.ext <;> simp [cx]
    rw [this, norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs, abs_neg,
      abs_of_nonneg hy]
  have h := Complex.norm_log_sub_logTaylor_le 5 (z := cx 0 (-y)) (by rw [hn]; exact hy1)
  rw [hn] at h
  have hT : Complex.logTaylor (5 + 1) (cx 0 (-y))
      = cx (y ^ 2 / 2 - y ^ 4 / 4) (-y + y ^ 3 / 3 - y ^ 5 / 5) := by
    simp only [Complex.logTaylor, Finset.sum_range_succ, Finset.sum_range_zero]
    apply Complex.ext
    · simp [cx, pow_succ]
      ring
    · simp [cx, pow_succ]
      ring
  rw [hT] at h
  norm_num at h ⊢
  exact h

/-- **The Stirling phase at `K = 3` in closed form**, `t > 0`, `y = 1/(2t) < 1`: with
`|log(t/2) − ℓ| ≤ e_ℓ`, `|log π − c| ≤ e_π`, `|π − π₀| ≤ 10^{−20}`, `τ = y⁶/(6(1−y))`,
`|φ₃(t) − ((t/2)(ℓ + y²/2 − y⁴/4) − (π₀/2 − y + y³/3 − y⁵/5)/4 − t/2 + sig3 t − (t/2)c)|
≤ (t/2)(e_ℓ + τ + e_π) + (10^{−20}/2 + τ)/4`. -/
theorem stirPhase3_ball {t ℓ eℓ c eπ φ₀ E : ℝ} (ht : 0 < t) (hy1 : 1 / (2 * t) < 1)
    (hℓ : |Real.log (t / 2) - ℓ| ≤ eℓ) (hπ : |Real.log Real.pi - c| ≤ eπ)
    (hφ : |(t / 2) * (ℓ + (1 / (2 * t)) ^ 2 / 2 - (1 / (2 * t)) ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-(1 / (2 * t)) + (1 / (2 * t)) ^ 3 / 3
          - (1 / (2 * t)) ^ 5 / 5)) / 4 - t / 2 + sig3 t - t / 2 * c - φ₀|
      + (t / 2) * (eℓ + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6 + eπ)
      + (1 / 10 ^ 20 / 2 + (1 / (2 * t)) ^ 6 * (1 - 1 / (2 * t))⁻¹ / 6) / 4 ≤ E) :
    |stirPhase 3 t - φ₀| ≤ E := by
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
  have hM : (stirMain 3 (zz t)).im
      = (t / 2) * (Real.log (t / 2) + Lw.re) - (Real.pi / 2 + Lw.im) / 4 - t / 2 + sig3 t := by
    unfold stirMain
    rw [Complex.add_im, stirSum3_im, hlog]
    simp [zz]
    ring
  have hp := pi_ball
  unfold stirPhase
  rw [hM]
  have e : (t / 2) * (Real.log (t / 2) + Lw.re) - (Real.pi / 2 + Lw.im) / 4 - t / 2 + sig3 t
      - t / 2 * Real.log Real.pi - φ₀
      = ((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + sig3 t
        - t / 2 * c - φ₀)
        + (t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))
          - (Real.log Real.pi - c))
        - ((Real.pi - 3.14159265358979323846) / 2 + (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))) / 4 := by
    ring
  rw [e]
  have ht2 : 0 < t / 2 := by positivity
  have h1 : |(t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))
      - (Real.log Real.pi - c))| ≤ (t / 2) * (eℓ + τ + eπ) := by
    rw [abs_mul, abs_of_pos ht2]
    apply mul_le_mul_of_nonneg_left _ ht2.le
    have := abs_sub (Real.log (t / 2) - ℓ + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4)))
      (Real.log Real.pi - c)
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
  have h3 := abs_add_le (((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + sig3 t
        - t / 2 * c - φ₀)) ((t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))
          - (Real.log Real.pi - c)))
  have h4 := abs_sub (((t / 2) * (ℓ + y ^ 2 / 2 - y ^ 4 / 4)
        - (3.14159265358979323846 / 2 + (-y + y ^ 3 / 3 - y ^ 5 / 5)) / 4 - t / 2 + sig3 t
        - t / 2 * c - φ₀) + (t / 2) * ((Real.log (t / 2) - ℓ) + (Lw.re - (y ^ 2 / 2 - y ^ 4 / 4))
          - (Real.log Real.pi - c)))
    (((Real.pi - 3.14159265358979323846) / 2 + (Lw.im - (-y + y ^ 3 / 3 - y ^ 5 / 5))) / 4)
  linarith

end

/-- info: 'StirlingSeries.re_lambda_eq_stir' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_lambda_eq_stir

/-- info: 'StirlingSeries.re_lambda_pos_stir3' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_lambda_pos_stir3

/-- info: 'StirlingSeries.im_logG_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms im_logG_ball

/-- info: 'StirlingSeries.stirPhase3_ball' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirPhase3_ball

end StirlingSeries
