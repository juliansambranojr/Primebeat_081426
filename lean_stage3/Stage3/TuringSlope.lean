/-
TuringSlope — block S14 of `lean_stage3/design/stencil.md`, Turing's slope term: the horizon's
slope sharpened from `97/t` to `π/(4t) + 17/(16t²)`, and Turing's certificate restated with it and
with `LittlewoodSharp.littlewood_sharp`. 2026-11-25. Pin "Turing's slope term", `PINS.md`.

**The lost term.** `Turing.theta_sub_le` bounds `θ(u) − θ(t) ≤ (u − t)(log(u/2) − log π + 97/t)/2`
from `Stage3.stmtDigammaLog_holds`, `|Re ψ(1/4 + iv/2) − log(v/2)| ≤ 97/v`, two-sided and crude.
In the certificate the `97/(2t)` enters `E` as `h·97/(4πT₁)`, and with the constants of
`littlewood_sharp` it is the largest term left (`checks/littlewoodsharp/budget.out` § 6).

**The route.** Only the upper side of `Re ψ` is needed. The telescope of
`Stage3.re_digamma_sub_log_le` with the one-sided step `log‖1 + w‖ ≤ Re w + ‖w‖²/2` and a sum–integral
comparison against `∫₀^∞ (x² + v²/4)⁻¹ = π/v` gives `Re ψ(1/4 + iv/2) ≤ log(v/2) + π/(2v) + 17/(8v²)`
(`TuringSlopePoint.phasePoint_le`), so for `1 ≤ t ≤ u`

  `θ(u) − θ(t) ≤ (u − t)·(½ log(u/(2π)) + π/(4t) + 17/(16t²))`        (`theta_sub_le_sharp'`),

`c = 1` from `t ≥ 5` (`theta_sub_le_sharp`), `c = 4/5` from `t ≥ 80` (`theta_sub_le_sharp80`).
The mean value theorem on the Stirling phase `stirMain` was the other route offered; it needs
`phaseTheta t = Im logG(zq t) − (t/2) log π`, which is not in the tree, and the direct integral of
`phasePoint` needs nothing new beyond the digamma series, so it was taken.

**The certificate.** `turingK'`, `turingErr'`, `turing_S_le'`, `defect_zero_of_signs'` are copies
of `Turing.turingK`, `turingErr`, `turing_S_le`, `defect_zero_of_signs` with
`K = ½ log((T₁ + 1 + h)/(2π)) + (4/5)/T₁` and `80 ≤ T₁`; `StmtClosingData'` and
`defect_zero_of_closing'` are `SignData.StmtClosingData`, `defect_zero_of_closing` with these and
`a = (3/2 + 113/4)/π`, `b = (2 + (3/2) log 9 + 128)/π`.

**The closing height** (`lean_stage3/checks/turingslope/closing_height_slope.py`, output
`closing_height_slope.out`, `c = 4/5`): ideal data `T₁ ≈ 439`, `h ≈ 78`, `≈ 228` sign points
below and `≈ 54` above (was `T₁ ≈ 1462`, `1037 + 84`); Gram data `n ≈ 884`, `g_n ≈ 1286`,
`h ≈ 112`, `885` below and `96` above (was `g_n ≈ 3243`, `2709 + 135`). With `c = 1`
(`closing_height_slope_c1.out`) the Gram crossing is `n ≈ 893`, `g_n ≈ 1296`.

| name | content | status |
|---|---|---|
| `phasePoint_le` | `1 ≤ v ⊢ Re ψ(1/4 + iv/2) ≤ log(v/2) + π/(2v) + 17/(8v²)` (`TuringSlopePoint`) | proved |
| `theta_sub_le_sharp'` | `1 ≤ t ≤ u ⊢ θu − θt ≤ (u − t)(½ log(u/2π) + π/(4t) + 17/(16t²))` | proved |
| `theta_sub_le_sharp` | `5 ≤ t ≤ u ⊢ θu − θt ≤ (u − t)(½ log(u/2π) + 1/t)` | proved |
| `theta_sub_le_sharp80` | `80 ≤ t ≤ u ⊢ θu − θt ≤ (u − t)(½ log(u/2π) + (4/5)/t)` | proved |
| `turing_S_le'` | `StmtLittlewood a b t₀`, `80 ≤ t` ⊢ `S t ≤ (a log(t+h) + b)/h + h K/(2π)` | proved |
| `turing_S_le_sharp` | the same with `littlewood_sharp` | proved |
| `turingK'`, `turingErr'` | the new slope and error | def |
| `defect_zero_of_signs'` | `defect_zero_of_signs` with `turingErr'`, `80 ≤ T₁` | proved |
| `StmtClosingData' T₁ h` | sign data meeting `hnum'` with `littlewood_sharp`'s constants | def (open: `≈ 280`–`980` points) |
| `defect_zero_of_closing'` | `StmtClosingData' T₁ h`, `80 ≤ T₁`, `0 < h` ⊢ `∀ T ≤ T₁, defect T = 0` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringSlopePoint
import Stage3.TuringCert
import Stage3.LittlewoodSharp

namespace TuringSlope

open Complex MeasureTheory Kadiri LineCount Defect Turing
open scoped Classical

/-- **The slope of the horizon, sharp form.** -/
theorem theta_sub_le_sharp' {t u : ℝ} (ht : 1 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + Real.pi / (4 * t)
        + 17 / (16 * t ^ 2)) := by
  have ht0 : 0 < t := by linarith
  have hsub : (∫ v in (0:ℝ)..u, Stage3.phasePoint v)
      - (∫ v in (0:ℝ)..t, Stage3.phasePoint v) = ∫ v in t..u, Stage3.phasePoint v :=
    intervalIntegral.integral_interval_sub_left
      (Stage3.intervalIntegrable_phasePoint 0 u) (Stage3.intervalIntegrable_phasePoint 0 t)
  have hkey : Stage3.phaseTheta u - Stage3.phaseTheta t
      = (1/2) * ((∫ v in (0:ℝ)..u, Stage3.phasePoint v)
        - (∫ v in (0:ℝ)..t, Stage3.phasePoint v)) - (u - t)/2 * Real.log Real.pi := by
    unfold Stage3.phaseTheta; ring
  have hpt : ∀ v ∈ Set.Icc t u, Stage3.phasePoint v
      ≤ Real.log (u / 2) + Real.pi / (2 * t) + 17 / (8 * t ^ 2) := by
    intro v hv
    have hv1 : 1 ≤ v := le_trans ht hv.1
    have h := phasePoint_le hv1
    have hl : Real.log (v / 2) ≤ Real.log (u / 2) :=
      Real.log_le_log (by linarith) (by linarith [hv.2])
    have hd1 : Real.pi / (2 * v) ≤ Real.pi / (2 * t) :=
      div_le_div_of_nonneg_left Real.pi_pos.le (by positivity) (by linarith [hv.1])
    have hd2 : 17 / (8 * v ^ 2) ≤ 17 / (8 * t ^ 2) :=
      div_le_div_of_nonneg_left (by norm_num) (by positivity)
        (by nlinarith [hv.1])
    linarith
  have hm := intervalIntegral.integral_mono_on htu (Stage3.intervalIntegrable_phasePoint t u)
    (intervalIntegrable_const
      (c := Real.log (u / 2) + Real.pi / (2 * t) + 17 / (8 * t ^ 2))) hpt
  rw [intervalIntegral.integral_const, smul_eq_mul] at hm
  have hlog : Real.log (u / (2 * Real.pi)) = Real.log (u / 2) - Real.log Real.pi := by
    rw [show u / (2 * Real.pi) = (u / 2) / Real.pi by ring,
      Real.log_div (ne_of_gt (by linarith)) Real.pi_ne_zero]
  have key : (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + Real.pi / (4 * t)
        + 17 / (16 * t ^ 2))
      = (1 / 2) * ((u - t) * (Real.log (u / 2) + Real.pi / (2 * t) + 17 / (8 * t ^ 2)))
        - (u - t) / 2 * Real.log Real.pi := by
    rw [hlog]; field_simp; ring
  rw [hkey, hsub, key]
  linarith

/-- The slope constant: `π/(4t) + 17/(16t²) ≤ c/t` once `π/4 + 17/(16 t₀) ≤ c`. -/
theorem slope_const_le {t t₀ c : ℝ} (ht₀ : 0 < t₀) (ht : t₀ ≤ t)
    (hc : 3.1416 / 4 + 17 / (16 * t₀) ≤ c) :
    Real.pi / (4 * t) + 17 / (16 * t ^ 2) ≤ c / t := by
  have ht0 : 0 < t := by linarith
  have e : Real.pi / (4 * t) + 17 / (16 * t ^ 2) = (Real.pi / 4 + 17 / (16 * t)) / t := by
    field_simp
  rw [e]
  apply div_le_div_of_nonneg_right _ ht0.le
  have h1 : 17 / (16 * t) ≤ 17 / (16 * t₀) :=
    div_le_div_of_nonneg_left (by norm_num) (by positivity) (by linarith)
  linarith [Real.pi_lt_d4]

/-- **The slope of the horizon, `c = 1`**: `θ(u) − θ(t) ≤ (u − t)(½ log(u/2π) + 1/t)`, `5 ≤ t`. -/
theorem theta_sub_le_sharp {t u : ℝ} (ht : 5 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + 1 / t) := by
  have h := theta_sub_le_sharp' (by linarith : (1 : ℝ) ≤ t) htu
  have hc := slope_const_le (t₀ := 5) (c := 1) (by norm_num) ht (by norm_num)
  have hut : 0 ≤ u - t := by linarith
  have := mul_le_mul_of_nonneg_left hc hut
  nlinarith

/-- **The slope of the horizon, `c = 4/5`**, `80 ≤ t`. -/
theorem theta_sub_le_sharp80 {t u : ℝ} (ht : 80 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + (4 / 5) / t) := by
  have h := theta_sub_le_sharp' (by linarith : (1 : ℝ) ≤ t) htu
  have hc := slope_const_le (t₀ := 80) (c := 4 / 5) (by norm_num) ht (by norm_num)
  have hut : 0 ≤ u - t := by linarith
  have := mul_le_mul_of_nonneg_left hc hut
  nlinarith

/-- **Turing's lemma, the standard form, sharp slope.** -/
theorem turing_S_le' {a b t₀ t h : ℝ} (hL : StmtLittlewood a b t₀) (ht₀ : t₀ ≤ t)
    (ht : 80 ≤ t) (hh : 0 < h) :
    S t ≤ (a * Real.log (t + h) + b) / h
      + h * (Real.log ((t + h) / (2 * Real.pi)) / 2 + (4 / 5) / t) / (2 * Real.pi) := by
  set K := Real.log ((t + h) / (2 * Real.pi)) / 2 + (4 / 5) / t with hK_def
  have hK : ∀ u ∈ Set.Icc t (t + h),
      Stage3.phaseTheta u - Stage3.phaseTheta t ≤ (u - t) * K := by
    intro u hu
    have h1 := theta_sub_le_sharp80 ht hu.1
    have hl : Real.log (u / (2 * Real.pi)) ≤ Real.log ((t + h) / (2 * Real.pi)) :=
      Real.log_le_log (div_pos (by linarith [hu.1]) (by positivity))
        (div_le_div_of_nonneg_right (by linarith [hu.2]) (by positivity))
    have hut : 0 ≤ u - t := by linarith [hu.1]
    have : (u - t) * (Real.log (u / (2 * Real.pi)) / 2 + (4 / 5) / t) ≤ (u - t) * K :=
      mul_le_mul_of_nonneg_left (by rw [hK_def]; linarith) hut
    linarith
  have hc : IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume t (t + h) := intervalIntegrable_const
  have hcN : ∀ u ∈ Set.Icc t (t + h), (0 : ℝ) ≤ riemannZeta.N u - riemannZeta.N t :=
    fun u hu => by linarith [ArgCount.N_mono hu.1]
  have hT := S_le_of_count hh hK hc hcN
  rw [intervalIntegral.integral_zero, sub_zero] at hT
  have hS := (abs_le.mp (hL t (t + h) ht₀ (by linarith))).2
  have h2 : (S₁ (t + h) - S₁ t + K * h ^ 2 / (2 * Real.pi)) / h
      ≤ (a * Real.log (t + h) + b + K * h ^ 2 / (2 * Real.pi)) / h :=
    div_le_div_of_nonneg_right (by linarith) hh.le
  have h3 : (a * Real.log (t + h) + b + K * h ^ 2 / (2 * Real.pi)) / h
      = (a * Real.log (t + h) + b) / h + h * K / (2 * Real.pi) := by
    field_simp
  linarith

/-- **Turing's lemma with the constants of `littlewood_sharp`.** -/
theorem turing_S_le_sharp {t h : ℝ} (ht : 80 ≤ t) (hh : 0 < h) :
    S t ≤ ((3 / 2 + 113 / 4) / Real.pi * Real.log (t + h)
        + (2 + (3 / 2) * Real.log 9 + 128) / Real.pi) / h
      + h * (Real.log ((t + h) / (2 * Real.pi)) / 2 + (4 / 5) / t) / (2 * Real.pi) :=
  turing_S_le' LittlewoodSharp.littlewood_sharp (by linarith) ht hh

noncomputable section

/-- The sharp slope of the horizon on `[T₁, T₁ + 1 + h]`. -/
def turingK' (T₁ h : ℝ) : ℝ := Real.log ((T₁ + 1 + h) / (2 * Real.pi)) / 2 + (4 / 5) / T₁

/-- Turing's error with the sharp slope. -/
def turingErr' (a b h T₁ : ℝ) {m : ℕ} (s : Fin (m + 1) → ℝ) : ℝ :=
  (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)) / h
    + h * turingK' T₁ h / (2 * Real.pi)

end

/-- **Turing's method, the analytic half, sharp slope.** -/
theorem defect_zero_of_signs' {k m : ℕ} {t : Fin (k + 1) → ℝ} {s : Fin (m + 1) → ℝ}
    {T₁ a b t₀ h : ℝ}
    (hbelow : StmtSignData k t) (htT : t (Fin.last k) ≤ T₁)
    (habove : StmtSignData m s) (hsT : T₁ < s 0) (hsh : s (Fin.last m) ≤ T₁ + h)
    (hL : StmtLittlewood a b t₀) (ha : 0 ≤ a) (ht₀ : t₀ ≤ T₁) (h1 : 80 ≤ T₁) (hh : 0 < h)
    (hnum : Stage3.phaseTheta T₁ / Real.pi + 1 + turingErr' a b h T₁ s < k + 2) :
    ∀ T ≤ T₁, defect T = 0 := by
  have hπ : 0 < Real.pi := Real.pi_pos
  have hk : (k : ℤ) ≤ lineCount T₁ :=
    signChanges_le_line_count t hbelow.1 hbelow.2.1 htT hbelow.2.2
  set E := turingErr' a b h T₁ s with hE
  set η := (k : ℝ) + 2 - (Stage3.phaseTheta T₁ / Real.pi + 1 + E) with hη
  have hη0 : 0 < η := by rw [hη]; linarith
  obtain ⟨T'', hT'', hno⟩ := exists_right T₁
  obtain ⟨δ, hδ, hδθ⟩ := Metric.continuous_iff.mp continuous_phaseTheta T₁ (Real.pi * η)
    (mul_pos hπ hη0)
  obtain ⟨d, hd0, hdδ, hdT, hds, hd1⟩ : ∃ d : ℝ, 0 < d ∧ d < δ ∧ T₁ + d < T'' ∧
      T₁ + d < s 0 ∧ d < 1 := by
    set D := min (min δ (T'' - T₁)) (min (s 0 - T₁) 1) with hD
    have hD0 : 0 < D := lt_min (lt_min hδ (by linarith)) (lt_min (by linarith) one_pos)
    have e1 : D ≤ δ := (min_le_left _ _).trans (min_le_left _ _)
    have e2 : D ≤ T'' - T₁ := (min_le_left _ _).trans (min_le_right _ _)
    have e3 : D ≤ s 0 - T₁ := (min_le_right _ _).trans (min_le_left _ _)
    have e4 : D ≤ 1 := (min_le_right _ _).trans (min_le_right _ _)
    exact ⟨D / 2, by linarith, by linarith, by linarith, by linarith, by linarith⟩
  set T' := T₁ + d with hT'
  have hT1T' : T₁ < T' := by linarith
  have hno' : ∀ z : ℂ, riemannZeta z = 0 → 0 < z.im → T₁ < z.im → T' < z.im :=
    fun z h0 hp hT => lt_trans hdT (hno z h0 hp hT)
  have hNT' := (N_eq_allCount_right hT1T' hno').1
  have hθT' : Stage3.phaseTheta T' < Stage3.phaseTheta T₁ + Real.pi * η := by
    have hdist : dist T' T₁ < δ := by
      rw [Real.dist_eq, abs_of_pos (by linarith)]; linarith
    have := hδθ T' hdist
    rw [Real.dist_eq] at this
    linarith [le_abs_self (Stage3.phaseTheta T' - Stage3.phaseTheta T₁)]
  -- Turing's lemma at `T'`
  set K := turingK' T₁ h with hK_def
  set c : ℝ → ℝ := fun u => ∑ j : Fin m, if s j.succ < u then (1 : ℝ) else 0 with hc_def
  have hK : ∀ u ∈ Set.Icc T' (T' + h),
      Stage3.phaseTheta u - Stage3.phaseTheta T' ≤ (u - T') * K := by
    intro u hu
    have h1' := theta_sub_le_sharp80 (by linarith : (80 : ℝ) ≤ T') hu.1
    have hl : Real.log (u / (2 * Real.pi)) ≤ Real.log ((T₁ + 1 + h) / (2 * Real.pi)) :=
      Real.log_le_log (div_pos (by linarith [hu.1]) (by positivity))
        (div_le_div_of_nonneg_right (by linarith [hu.2]) (by positivity))
    have hd45 : (4 / 5) / T' ≤ (4 / 5) / T₁ :=
      div_le_div_of_nonneg_left (by norm_num) (by linarith) hT1T'.le
    have hut : 0 ≤ u - T' := by linarith [hu.1]
    have : (u - T') * (Real.log (u / (2 * Real.pi)) / 2 + (4 / 5) / T') ≤ (u - T') * K :=
      mul_le_mul_of_nonneg_left (by rw [hK_def, turingK']; linarith) hut
    linarith
  have hcmono : Monotone c := by
    intro x y hxy
    refine Finset.sum_le_sum (fun j _ => ?_)
    split_ifs with h1' h2'
    · exact le_refl _
    · exact absurd (lt_of_lt_of_le h1' hxy) h2'
    · norm_num
    · exact le_refl _
  have hci : IntervalIntegrable c volume T' (T' + h) := hcmono.intervalIntegrable
  have hcN : ∀ u ∈ Set.Icc T' (T' + h), c u ≤ riemannZeta.N u - riemannZeta.N T' := by
    intro u hu
    rw [hNT']
    exact count_le_N_sub (by linarith) habove hsT (by linarith [hu.1])
  have hS := S_le_of_count hh hK hci hcN
  -- the integral of the count
  have hsj : ∀ j : Fin m, T' ≤ s j.succ ∧ s j.succ ≤ T' + h := by
    intro j
    refine ⟨?_, ?_⟩
    · have := habove.1.monotone (Fin.zero_le j.succ)
      linarith
    · have := habove.1.monotone (Fin.le_last j.succ)
      linarith
  have hint : (∫ u in T'..T' + h, c u) = ∑ j : Fin m, (T' + h - s j.succ) := by
    rw [hc_def, intervalIntegral.integral_finsetSum]
    · exact Finset.sum_congr rfl (fun j _ => integral_step (hsj j).1 (hsj j).2)
    · intro j _
      apply Monotone.intervalIntegrable
      intro x y hxy
      dsimp only
      split_ifs with h1' h2'
      · exact le_refl _
      · exact absurd (lt_of_lt_of_le h1' hxy) h2'
      · norm_num
      · exact le_refl _
  have hsum : ∑ j : Fin m, (T₁ + h - s j.succ) ≤ ∑ j : Fin m, (T' + h - s j.succ) :=
    Finset.sum_le_sum (fun j _ => by linarith)
  have hL' := (abs_le.mp (hL T' (T' + h) (by linarith) (by linarith))).2
  have hlog : Real.log (T' + h) ≤ Real.log (T₁ + 1 + h) :=
    Real.log_le_log (by linarith) (by linarith)
  have hlogA : a * Real.log (T' + h) ≤ a * Real.log (T₁ + 1 + h) :=
    mul_le_mul_of_nonneg_left hlog ha
  have hSE : S T' ≤ E := by
    rw [hint] at hS
    have h2 : (S₁ (T' + h) - S₁ T' - ∑ j : Fin m, (T' + h - s j.succ)
        + K * h ^ 2 / (2 * Real.pi)) / h
        ≤ (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)
          + K * h ^ 2 / (2 * Real.pi)) / h :=
      div_le_div_of_nonneg_right (by linarith) hh.le
    have h3 : (a * Real.log (T₁ + 1 + h) + b - ∑ j : Fin m, (T₁ + h - s j.succ)
          + K * h ^ 2 / (2 * Real.pi)) / h = E := by
      rw [hE, turingErr', ← hK_def]
      field_simp
    linarith
  -- the count at `T₁`
  have hall : (allCount T₁ : ℝ) < (k : ℝ) + 2 := by
    have e1 : (allCount T₁ : ℝ) = S T' + Stage3.phaseTheta T' / Real.pi + 1 := by
      rw [← hNT']; unfold Turing.S; ring
    have e2 : Stage3.phaseTheta T' / Real.pi < Stage3.phaseTheta T₁ / Real.pi + η := by
      rw [div_lt_iff₀ hπ]
      have : (Stage3.phaseTheta T₁ / Real.pi + η) * Real.pi
          = Stage3.phaseTheta T₁ + Real.pi * η := by field_simp
      rw [this]; exact hθT'
    rw [hη] at e2
    linarith
  have hallZ : allCount T₁ < (k : ℤ) + 2 := by exact_mod_cast hall
  have hd : defect T₁ < 2 := by unfold defect; omega
  exact defect_zero_below (defect_eq_zero_of_lt_two hd)

/-- **The open certificate, sharp slope and sharp Littlewood constants.** A finite computation,
open: by `checks/turingslope/closing_height_slope.py` it needs `T₁ ≳ 439` and `≈ 280`–`980`
certified signs. -/
def StmtClosingData' (T₁ h : ℝ) : Prop :=
  ∃ (k m : ℕ) (t : Fin (k + 1) → ℝ) (s : Fin (m + 1) → ℝ),
    StmtSignData k t ∧ t (Fin.last k) ≤ T₁ ∧
    StmtSignData m s ∧ T₁ < s 0 ∧ s (Fin.last m) ≤ T₁ + h ∧
    Stage3.phaseTheta T₁ / Real.pi + 1
      + turingErr' ((3 / 2 + 113 / 4) / Real.pi) ((2 + (3 / 2) * Real.log 9 + 128) / Real.pi)
          h T₁ s < k + 2

/-- **Turing's method with the sharp slope and `littlewood_sharp`**: the closing data give the
defect `0`. -/
theorem defect_zero_of_closing' {T₁ h : ℝ} (hd : StmtClosingData' T₁ h) (h80 : 80 ≤ T₁)
    (hh : 0 < h) : ∀ T ≤ T₁, Defect.defect T = 0 := by
  obtain ⟨k, m, t, s, hb, ht, ha, hs0, hsh, hnum⟩ := hd
  exact defect_zero_of_signs' hb ht ha hs0 hsh LittlewoodSharp.littlewood_sharp
    (by positivity) (by linarith) h80 hh hnum

/-- info: 'TuringSlope.theta_sub_le_sharp'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms theta_sub_le_sharp'

/-- info: 'TuringSlope.theta_sub_le_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms theta_sub_le_sharp

/-- info: 'TuringSlope.theta_sub_le_sharp80' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms theta_sub_le_sharp80

/-- info: 'TuringSlope.turing_S_le'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms turing_S_le'

/-- info: 'TuringSlope.turing_S_le_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms turing_S_le_sharp

/-- info: 'TuringSlope.defect_zero_of_signs'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_zero_of_signs'

/-- info: 'TuringSlope.defect_zero_of_closing'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms defect_zero_of_closing'

end TuringSlope
