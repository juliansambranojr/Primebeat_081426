/-
TuringAvg — block S14 of `lean_stage3/design/stencil.md`, Turing's method, step 2: Turing's
lemma, the averaging of `S` over a length `h`. 2026-11-25.

**On paper.** `S u − S t = (N u − N t) − (θ u − θ t)/π`, exactly, from the definition. Let
`c` be any lower count of the zeros between: `c u ≤ N u − N t` on `[t, t + h]` (`c = 0` always
works, `N` being monotone; sign changes of `Z` found above `t` give a better `c`, step 3). Let
`θ u − θ t ≤ K (u − t)` there. Then for `u ∈ [t, t + h]`

  `S t ≤ S u − c u + K (u − t)/π`,

and averaging over `u ∈ [t, t + h]` (`avg_le`):

  `h · S t ≤ (S₁(t + h) − S₁ t) − ∫_t^{t+h} c + K h²/(2π)`.          (Turing)

With Littlewood's bound `S₁(t + h) − S₁ t ≤ a log(t + h) + b` this is

  `S t ≤ (a log(t + h) + b − ∫_t^{t+h} c)/h + K h/(2π)`,

the standard form `N t ≤ θ t/π + 1 + (a log(t + h) + b)/h + K h/(2π)` at `c = 0`
(`turing_S_le`). The slope: `θ′ = (ψ-part − log π)/2` and Stirling's
`|phasePoint v − log(v/2)| ≤ 97/v` (`Stage3.stmtDigammaLog_holds`) give, for `1 ≤ t ≤ u`,

  `θ u − θ t ≤ (u − t) · (log(u/2) − log π + 97/t)/2`             (`theta_sub_le`)

**Sizes.** At `c = 0` the error is `B/h + K h/(2π)`, at best `2√(K B/(2π))` with
`K ≈ ½ log(t/2π)`. With `B` of Trudgian's size (`a ≈ 0.06`, `b ≈ 2`, from memory) and
`t = 10³` this is about `2.2`, above the step of `2` that the parity of the defect allows, so
the `c = 0` form never certifies. The term `K h/(2π)` is the growth of the horizon over the
window, and it is cancelled only by the zeros counted in it, `∫ c ≈ K h²/(2π) − O(h)`. That is
why Turing's method needs the signs of `Z` above `t` as well as below, and why step 3 takes
both. Lost factor: none beyond the one recorded in `TuringS` (the crude `S₁`).

| name | content | status |
|---|---|---|
| `theta_sub_le` | `1 ≤ t ≤ u ⊢ θ u − θ t ≤ (u − t)(log(u/2) − log π + 97/t)/2` | proved |
| `avg_le` | `f t ≤ f u + e u` on `[t, t + h]` ⊢ `f t ≤ (∫ f + ∫ e)/h` | proved |
| `integral_lin` | `∫_t^{t+h} (u − t) K/π du = K h²/(2π)` | proved |
| `S_le_of_count` | (Turing) with a lower count `c` | proved |
| `turing_S_le` | `StmtLittlewood a b t₀`, `c = 0` ⊢ `S t ≤ (a log(t+h) + b)/h + K h/(2π)` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.TuringS

namespace Turing

open MeasureTheory

/-- **The slope of the horizon**, from Stirling's digamma bound. -/
theorem theta_sub_le {t u : ℝ} (ht : 1 ≤ t) (htu : t ≤ u) :
    Stage3.phaseTheta u - Stage3.phaseTheta t
      ≤ (u - t) * ((Real.log (u / 2) - Real.log Real.pi + 97 / t) / 2) := by
  have hsub : (∫ v in (0:ℝ)..u, Stage3.phasePoint v)
      - (∫ v in (0:ℝ)..t, Stage3.phasePoint v) = ∫ v in t..u, Stage3.phasePoint v :=
    intervalIntegral.integral_interval_sub_left
      (Stage3.intervalIntegrable_phasePoint 0 u) (Stage3.intervalIntegrable_phasePoint 0 t)
  have hkey : Stage3.phaseTheta u - Stage3.phaseTheta t
      = (1/2) * ((∫ v in (0:ℝ)..u, Stage3.phasePoint v)
        - (∫ v in (0:ℝ)..t, Stage3.phasePoint v)) - (u - t)/2 * Real.log Real.pi := by
    unfold Stage3.phaseTheta; ring
  have hpt : ∀ v ∈ Set.Icc t u,
      Stage3.phasePoint v ≤ Real.log (u / 2) + 97 / t := by
    intro v hv
    have hv1 : 1 ≤ v := le_trans ht hv.1
    have h := (abs_le.mp (Stage3.stmtDigammaLog_holds.1 v hv1)).2
    have hl : Real.log (v / 2) ≤ Real.log (u / 2) :=
      Real.log_le_log (by linarith) (by linarith [hv.2])
    have hd : 97 / v ≤ 97 / t := div_le_div_of_nonneg_left (by norm_num) (by linarith) hv.1
    linarith
  have hm := intervalIntegral.integral_mono_on htu (Stage3.intervalIntegrable_phasePoint t u)
    (intervalIntegrable_const (c := Real.log (u / 2) + 97 / t)) hpt
  rw [intervalIntegral.integral_const, smul_eq_mul] at hm
  rw [hkey, hsub]
  nlinarith

/-- **Averaging.** A pointwise comparison on `[t, t + h]` averages to a bound at `t`. -/
theorem avg_le {f e : ℝ → ℝ} {t h : ℝ} (hh : 0 < h)
    (hf : IntervalIntegrable f volume t (t + h)) (he : IntervalIntegrable e volume t (t + h))
    (hle : ∀ u ∈ Set.Icc t (t + h), f t ≤ f u + e u) :
    f t ≤ ((∫ u in t..t + h, f u) + ∫ u in t..t + h, e u) / h := by
  have hm := intervalIntegral.integral_mono_on (by linarith : t ≤ t + h)
    (intervalIntegrable_const (c := f t)) (hf.add he) hle
  rw [intervalIntegral.integral_const, smul_eq_mul,
    intervalIntegral.integral_add hf he] at hm
  rw [le_div_iff₀ hh]
  have : t + h - t = h := by ring
  rw [this] at hm
  linarith

/-- The linear weight integrates to `K h²/(2π)`. -/
theorem integral_lin (t h K : ℝ) :
    (∫ u in t..t + h, (u - t) * K / Real.pi) = K * h ^ 2 / (2 * Real.pi) := by
  have e1 : (fun u : ℝ => (u - t) * K / Real.pi) = fun u => (u - t) * (K / Real.pi) := by
    funext u; ring
  rw [e1, intervalIntegral.integral_mul_const,
    intervalIntegral.integral_comp_sub_right (fun x => x) t, integral_id]
  have hπ : Real.pi ≠ 0 := Real.pi_ne_zero
  field_simp
  ring

/-- The pointwise comparison behind Turing's lemma. -/
theorem S_le_pointwise {t u K c : ℝ} (hθ : Stage3.phaseTheta u - Stage3.phaseTheta t ≤ (u - t) * K)
    (hcN : c ≤ riemannZeta.N u - riemannZeta.N t) :
    S t ≤ S u + ((u - t) * K / Real.pi - c) := by
  have hπ : 0 < Real.pi := Real.pi_pos
  have h3 : (Stage3.phaseTheta u - Stage3.phaseTheta t) / Real.pi ≤ (u - t) * K / Real.pi :=
    div_le_div_of_nonneg_right hθ hπ.le
  have h4 : (Stage3.phaseTheta u - Stage3.phaseTheta t) / Real.pi
      = Stage3.phaseTheta u / Real.pi - Stage3.phaseTheta t / Real.pi := by ring
  unfold S
  linarith

/-- **Turing's lemma, with a lower count.** -/
theorem S_le_of_count {t h K : ℝ} {c : ℝ → ℝ} (hh : 0 < h)
    (hK : ∀ u ∈ Set.Icc t (t + h),
      Stage3.phaseTheta u - Stage3.phaseTheta t ≤ (u - t) * K)
    (hc : IntervalIntegrable c volume t (t + h))
    (hcN : ∀ u ∈ Set.Icc t (t + h), c u ≤ riemannZeta.N u - riemannZeta.N t) :
    S t ≤ ((S₁ (t + h) - S₁ t) - (∫ u in t..t + h, c u) + K * h ^ 2 / (2 * Real.pi)) / h := by
  have hlin : IntervalIntegrable (fun u : ℝ => (u - t) * K / Real.pi) volume t (t + h) := by
    apply Continuous.intervalIntegrable; fun_prop
  have hei : IntervalIntegrable (fun u : ℝ => (u - t) * K / Real.pi - c u) volume t (t + h) :=
    hlin.sub hc
  have hav := avg_le (f := S) hh (intervalIntegrable_S t (t + h)) hei
    (fun u hu => S_le_pointwise (hK u hu) (hcN u hu))
  have hI : (∫ u in t..t + h, ((u - t) * K / Real.pi - c u))
      = K * h ^ 2 / (2 * Real.pi) - ∫ u in t..t + h, c u := by
    rw [intervalIntegral.integral_sub hlin hc, integral_lin]
  rw [hI, ← S₁_sub] at hav
  calc S t ≤ (S₁ (t + h) - S₁ t + (K * h ^ 2 / (2 * Real.pi) - ∫ u in t..t + h, c u)) / h := hav
    _ = _ := by ring

/-- **Turing's lemma, the standard form**: Littlewood's bound and the slope of the horizon
bound `S` above at a point. -/
theorem turing_S_le {a b t₀ t h : ℝ} (hL : StmtLittlewood a b t₀) (ht₀ : t₀ ≤ t)
    (ht : 1 ≤ t) (hh : 0 < h) :
    S t ≤ (a * Real.log (t + h) + b) / h
      + h * ((Real.log ((t + h) / 2) - Real.log Real.pi + 97 / t) / 2) / (2 * Real.pi) := by
  set K := (Real.log ((t + h) / 2) - Real.log Real.pi + 97 / t) / 2 with hK_def
  have hK : ∀ u ∈ Set.Icc t (t + h),
      Stage3.phaseTheta u - Stage3.phaseTheta t ≤ (u - t) * K := by
    intro u hu
    have h1 := theta_sub_le ht hu.1
    have hl : Real.log (u / 2) ≤ Real.log ((t + h) / 2) :=
      Real.log_le_log (by linarith [hu.1]) (by linarith [hu.2])
    have hut : 0 ≤ u - t := by linarith [hu.1]
    have : (u - t) * ((Real.log (u / 2) - Real.log Real.pi + 97 / t) / 2) ≤ (u - t) * K :=
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

/-- info: 'Turing.theta_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms theta_sub_le

/-- info: 'Turing.S_le_of_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_le_of_count

/-- info: 'Turing.turing_S_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms turing_S_le

end Turing
