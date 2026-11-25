/-
ConreyCountLine — block S13 of `lean_stage3/design/stencil.md`, B4 step 1, the line function.
2026-11-25.

Levinson's count (`LevinsonArg`, `LevinsonTurn`) ran through `lineF c = Gammaℝ·(ζ + cζ′)` on the
line. Here the line function is `W = OperatorQ.W Q L` itself, and `V = W/Gammaℝ` takes the
place of `G = ζ + cζ′`.

* `W` is analytic off `{0, 1}` (a finite sum of derivatives of `Λ`,
  `OperatorQ.analyticOnNhd_xi`), and `V` is analytic where `W` is and `Gammaℝ ≠ 0`, in
  particular off the real axis (`Gammaℝ` has its zeros on it, Mathlib's `Gammaℝ_eq_zero_iff`,
  and `1/Gammaℝ` is entire, `differentiable_Gammaℝ_inv`).
* On the line `Re W = Q(1/2)·Λ` (`OperatorQ.re_W_line`), so a point where a continuous argument
  of `W` passes `π/2 mod π` is a zero of `ζ` (`OperatorQ.zeta_line_zero_iff_W`). With
  `LevinsonArg.crossings_of_arg` and `LevinsonArg.distinct_line_zeros_le_lineCount` this is
  `lineCount_ge_argW`, the analogue of `LevinsonArg.lineCount_ge_arg`, with `Q(1/2) ≠ 0` in place
  of the real factor `1 − c·Re g ≠ 0`.
* The turning of `W` along the segment is the `Gammaℝ` part plus the turning of `V`
  (`LevinsonTurn.line_turn_eq_integral`, `LevinsonTurn.turn_split`), since `W = Gammaℝ·V` on the
  open half-plane `Re s > 0` and so `logDeriv W = logDeriv (Gammaℝ·V)` there.

  | name                  | statement                                                         | status |
  |-----------------------|-------------------------------------------------------------------|--------|
  | `V`                   | `V Q L s = W Q L s / Gammaℝ s`                                     | def    |
  | `analyticAt_W`        | `s ≠ 0, s ≠ 1` ⊢ `AnalyticAt ℂ (W Q L) s`                          | PROVED |
  | `analyticAt_V`        | `s ≠ 0, s ≠ 1, Gammaℝ s ≠ 0` ⊢ `AnalyticAt ℂ (V Q L) s`             | PROVED |
  | `W_eq_gammaR_mul_V`   | `Gammaℝ s ≠ 0` ⊢ `W s = Gammaℝ s · V s`                            | PROVED |
  | `continuous_lineW`    | `t ↦ W(1/2 + t i)` is continuous                                    | PROVED |
  | `lineCount_ge_argW`   | `Q′` symmetric, `Q(1/2) ≠ 0`, `0 < a ≤ b ≤ T`, `φ` a continuous argument of `W` on the segment, `kπ ≤ |φ b − φ a|` ⊢ `k ≤ lineCount T` | PROVED |
  | `lineW_turn_eq`       | `V ≠ 0` on the segment, `φ` as above ⊢ `φ b − φ a = Re ∫ logDeriv Gammaℝ + Re ∫ logDeriv V` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCountIdentity
import Stage3.LevinsonTurn

noncomputable section

namespace ConreyCount

open Complex Polynomial LineCount

/-- Conrey's `V = W/Gammaℝ`, the analogue of `G = ζ + cζ′`: `V = Q(1/2 − (D + g)/L) ζ` with
`g = Gammaℝ′/Gammaℝ`. -/
def V (Q : ℝ[X]) (L : ℝ) (s : ℂ) : ℂ := OperatorQ.W Q L s / Gammaℝ s

/-- `W` is analytic off `{0, 1}`. -/
theorem analyticAt_W (Q : ℝ[X]) (L : ℝ) {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) :
    AnalyticAt ℂ (OperatorQ.W Q L) s := by
  have hk : ∀ k : ℕ, AnalyticAt ℂ (iteratedDeriv k completedRiemannZeta) s := by
    intro k
    rw [iteratedDeriv_eq_iterate]
    exact OperatorQ.analyticOnNhd_xi.iterated_deriv k s ⟨h0, h1⟩
  have e : OperatorQ.W Q L = fun s => ∑ k ∈ Finset.range (Q.natDegree + 1),
      (((taylor (1/2 : ℝ) Q).coeff k * (-1 / L) ^ k : ℝ) : ℂ) *
        iteratedDeriv k completedRiemannZeta s := rfl
  rw [e]
  exact Finset.analyticAt_fun_sum _ fun k _ => analyticAt_const.mul (hk k)

/-- `Gammaℝ` is analytic where it does not vanish. -/
theorem analyticAt_Gammaℝ' {s : ℂ} (hs : Gammaℝ s ≠ 0) : AnalyticAt ℂ Gammaℝ s := by
  have hinv : AnalyticAt ℂ (fun z : ℂ => (Gammaℝ z)⁻¹) s :=
    differentiable_Gammaℝ_inv.analyticAt s
  have h := hinv.inv (inv_ne_zero hs)
  have he : (fun z : ℂ => (Gammaℝ z)⁻¹)⁻¹ = Gammaℝ := by
    funext z
    simp
  rwa [he] at h

/-- `V` is analytic where `W` is and `Gammaℝ ≠ 0`. -/
theorem analyticAt_V (Q : ℝ[X]) (L : ℝ) {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hG : Gammaℝ s ≠ 0) : AnalyticAt ℂ (V Q L) s :=
  (analyticAt_W Q L h0 h1).div (analyticAt_Gammaℝ' hG) hG

/-- `Gammaℝ` has no zero off the real axis. -/
theorem Gammaℝ_ne_of_im {w : ℂ} (h : w.im ≠ 0) : Gammaℝ w ≠ 0 := by
  intro hw
  obtain ⟨n, hn⟩ := Gammaℝ_eq_zero_iff.mp hw
  apply h
  rw [hn]
  simp

/-- `W = Gammaℝ · V` where `Gammaℝ ≠ 0`. -/
theorem W_eq_gammaR_mul_V (Q : ℝ[X]) (L : ℝ) {s : ℂ} (hG : Gammaℝ s ≠ 0) :
    OperatorQ.W Q L s = Gammaℝ s * V Q L s := by
  unfold V
  field_simp

/-- The line function `t ↦ W(1/2 + t i)`. -/
def lineW (Q : ℝ[X]) (L t : ℝ) : ℂ := OperatorQ.W Q L (1/2 + t * I)

/-- `W` is analytic at every point of the line. -/
theorem analyticAt_W_line (Q : ℝ[X]) (L t : ℝ) :
    AnalyticAt ℂ (OperatorQ.W Q L) (1/2 + t * I) := by
  obtain ⟨h0, h1, -⟩ := LevinsonLine.line_facts t
  exact analyticAt_W Q L h0 h1

/-- The line function is continuous. -/
theorem continuous_lineW (Q : ℝ[X]) (L : ℝ) : Continuous (lineW Q L) := by
  rw [continuous_iff_continuousAt]
  intro t
  exact ContinuousAt.comp (g := OperatorQ.W Q L) (f := fun t : ℝ => (1/2 + t * I : ℂ))
    (analyticAt_W_line Q L t).continuousAt LevinsonTurn.continuous_line.continuousAt

/-- **The crossings of `W`.** If a continuous argument `φ` of `W` along
`[1/2 + a i, 1/2 + b i]` moves by at least `kπ`, and `Q(1/2) ≠ 0`, then at least `k` zeros of
`ζ` lie on the line up to height `T ≥ b`, with multiplicity. -/
theorem lineCount_ge_argW {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b T : ℝ} {φ : ℝ → ℝ} {k : ℕ}
    (ha : 0 < a) (hab : a ≤ b) (hbT : b ≤ T)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, lineW Q L t = ‖lineW Q L t‖ * Complex.exp (φ t * Complex.I))
    (hk : (k : ℝ) * Real.pi ≤ |φ b - φ a|) :
    (k : ℤ) ≤ lineCount T := by
  obtain ⟨t, hmono, hmem, hcos⟩ := LevinsonArg.crossings_of_arg hab hφc k hk
  have hζ : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    have hre : (lineW Q L (t i)).re = 0 := by
      rw [hφ _ (hmem i), Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i,
        mul_zero]
    exact (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L (t i)).mpr hre
  exact LevinsonArg.distinct_line_zeros_le_lineCount t hmono.injective
    (fun i => lt_of_lt_of_le ha (hmem i).1) (fun i => le_trans (hmem i).2 hbT) hζ

/-- On `Re s > 0`, `logDeriv W = logDeriv (Gammaℝ · V)`. -/
theorem logDeriv_W_eq (Q : ℝ[X]) (L : ℝ) {s : ℂ} (hs : 0 < s.re) :
    logDeriv (OperatorQ.W Q L) s = logDeriv (fun z => Gammaℝ z * V Q L z) s := by
  have hopen : IsOpen {z : ℂ | 0 < z.re} := isOpen_lt continuous_const Complex.continuous_re
  have hev : OperatorQ.W Q L =ᶠ[nhds s] fun z => Gammaℝ z * V Q L z := by
    filter_upwards [hopen.mem_nhds hs] with z hz
    exact W_eq_gammaR_mul_V Q L (Gammaℝ_ne_zero_of_re_pos hz)
  simp only [logDeriv_apply]
  rw [hev.deriv_eq, hev.eq_of_nhds]

/-- **The turning of `W`.** Where `V ≠ 0` along `[1/2 + a i, 1/2 + b i]`, a continuous argument of
`W` there turns by the `Gammaℝ` part plus the turning of `V`. -/
theorem lineW_turn_eq {Q : ℝ[X]} {L a b : ℝ} {φ : ℝ → ℝ} (hab : a ≤ b)
    (hne : ∀ t ∈ Set.Icc a b, V Q L (1/2 + t * I) ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, lineW Q L t = ‖lineW Q L t‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re +
      (∫ t in a..b, logDeriv (V Q L) (1/2 + t * I)).re := by
  have hre : ∀ t : ℝ, 0 < ((1/2 : ℂ) + t * I).re := fun t => (LevinsonLine.line_facts t).2.2
  have hGne : ∀ t : ℝ, Gammaℝ ((1/2 : ℂ) + t * I) ≠ 0 := fun t =>
    Gammaℝ_ne_zero_of_re_pos (hre t)
  have hWne : ∀ t ∈ Set.Icc a b, OperatorQ.W Q L (1/2 + t * I) ≠ 0 := by
    intro t ht
    rw [W_eq_gammaR_mul_V Q L (hGne t)]
    exact mul_ne_zero (hGne t) (hne t ht)
  have h := LevinsonTurn.line_turn_eq_integral (f := OperatorQ.W Q L) hab
    (fun t _ => analyticAt_W_line Q L t) hWne hφc hφ
  rw [h]
  have heq : (∫ t in a..b, logDeriv (OperatorQ.W Q L) (1/2 + t * I)) =
      ∫ t in a..b, logDeriv (fun z => Gammaℝ z * V Q L z) (1/2 + t * I) :=
    intervalIntegral.integral_congr fun t _ => logDeriv_W_eq Q L (hre t)
  rw [heq]
  have hVa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ (V Q L) (1/2 + t * I) := by
    intro t _
    obtain ⟨h0, h1, -⟩ := LevinsonLine.line_facts t
    exact analyticAt_V Q L h0 h1 (hGne t)
  exact LevinsonTurn.turn_split (G := V Q L) hab hVa hne

/-- info: 'ConreyCount.analyticAt_W' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analyticAt_W

/-- info: 'ConreyCount.analyticAt_V' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms analyticAt_V

/-- info: 'ConreyCount.W_eq_gammaR_mul_V' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms W_eq_gammaR_mul_V

/-- info: 'ConreyCount.continuous_lineW' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms continuous_lineW

/-- info: 'ConreyCount.lineCount_ge_argW' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineCount_ge_argW

/-- info: 'ConreyCount.lineW_turn_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lineW_turn_eq

end ConreyCount

end
