/-
# Unsmooth — block S12 of `lean_stage3/design/stencil.md`, piece 4, unsmoothing: the sharp one-sided mean. 2026-11-25.

From the smoothed mollified mean (`Operator.stmtMollMeanO_holds`) to the sharp mean on a
window `[a′, b′]` with `a′ ∈ [T/2, T/2 + 1]`, `b′ ∈ [T − 1, T]`, one-sided:
`(1/(b′−a′)) ∫_{a′}^{b′} |G(σ₀+it) ψ(σ₀+it)|² dt ≤ Re D[c](−R/L, −R/L) + ε` from some height
on, `L = log T`, `σ₀ = 1/2 − R/L`, `G = ζ + ζ′/L`, `M = ⌊T^θ⌋`, Young's mollifier `aY`.

| name | content | status |
|---|---|---|
| `mollMean_re` | `Re mollMean = ∫ w |G|² |ψ|²` (the integrand is real) | proved |
| `continuous_Gpsi` | `t ↦ |G(σ₀+it)|² |ψ(σ₀+it)|²` is continuous, `σ₀ ≠ 1` | proved |
| `unsmooth_near` | the sharp one-sided mean, in `Gl`/`psi` form | proved |
| `unsmooth_near_levinson` | the same in the integrand of `LevinsonMultiple.levinson_window'`'s `hK`, at `σ = σ₀` | proved |

The route. The window `winNear` (`UnsmoothWin`) is `1` on `[T/2 − T/L, T] ⊇ [a′, b′]`, `0` off
`(T/2 − 2T/L, T + T/L)`, with `winW`'s constants `winC`. With `d = b′ − a′ ≥ T/2 − 2 ≥ T/4`:
`∫_{a′}^{b′} ≤ ∫ w|Gψ|² = Re mean ≤ Re D·ŵ(0) + ε₁(1 + C₁ + C₂)T`, and
`d ≤ ŵ(0) ≤ T/2 + 3T/L ≤ d + 3T/L + 2`, so `Re D·ŵ(0) ≤ Re D·d + K(3T/L + 2)` with
`‖D‖ ≤ K` (`UnsmoothCY.dop_cY_bdd`).

The size, checked before the proof: after dividing by `d ≥ T/4`, the window's excess costs
`K(3T/L + 2)/d ≤ 12K/L + 8K/T`, and Lemma 3's `o(T)` costs `4ε₁(1 + C₁ + C₂)`; both are
`o(1)`. The excess is `o(1)` only because `D[c] = O(1)`; a bound `D[c] = O(L)` (one Cauchy
radius `1/L` too many) would lose exactly the factor `L` the excess `T/L` leaves, so the bound
on `D` is proved, not assumed.

Not here (piece 5): the mean for `σ` in `[σ₀ − δ, σ₀]` (`levinson_window'`'s `hK` ranges over
it), and windows other than `a′ ≈ T/2`, `b′ ≈ T`.

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.UnsmoothWin
import Stage3.UnsmoothCY
import Stage3.LevinsonMollEdge

namespace Unsmooth

open Complex MeasureTheory Filter Topology TwistedMoment Operator OffDiagClose DiagMainStmt

/-- `Re mollMean = ∫ w |G|² |ψ|²`. -/
theorem mollMean_re {T L : ℝ} (W : Weight T L) (M : ℕ) (a : ℕ → ℂ) (σ₀ L' : ℝ) :
    (mollMean W M a σ₀ L').re =
      ∫ t, W.w t * (‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t) := by
  unfold mollMean
  have e : (fun t : ℝ => (W.w t : ℂ) * ((‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 : ℝ) : ℂ) *
      (msq M a σ₀ t : ℂ)) =
      fun t : ℝ => ((W.w t * (‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t) : ℝ) : ℂ) := by
    funext t
    push_cast
    ring
  rw [e, integral_complex_ofReal, Complex.ofReal_re]

/-- `t ↦ |G(σ₀+it)|² |ψ(σ₀+it)|²` is continuous for `σ₀ ≠ 1`. -/
theorem continuous_Gpsi (M : ℕ) (a : ℕ → ℂ) {σ₀ : ℝ} (hσ : σ₀ ≠ 1) (L' : ℝ) :
    Continuous fun t : ℝ => ‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t := by
  have hc : Continuous fun t : ℝ => (σ₀ : ℂ) + t * I := by fun_prop
  have hne : ∀ t : ℝ, (σ₀ : ℂ) + t * I ∈ ({1}ᶜ : Set ℂ) := by
    intro t h
    have h1 := congrArg Complex.re (Set.mem_singleton_iff.mp h)
    simp at h1
    exact hσ h1
  have hG : Continuous fun t : ℝ => Gl L' ((σ₀ : ℂ) + t * I) := by
    unfold Gl
    exact (zeta_diffOn.continuousOn.comp_continuous hc hne).add
      ((dzeta_diffOn.continuousOn.comp_continuous hc hne).div_const _)
  exact (hG.norm.pow 2).mul (continuous_msq M a σ₀)

/-- `|G ψ|² = |G|² |ψ|²`. -/
theorem norm_Gpsi_sq (L' : ℝ) (M : ℕ) (a : ℕ → ℂ) (σ₀ t : ℝ) :
    ‖Gl L' ((σ₀ : ℂ) + t * I) * psi M a ((σ₀ : ℂ) + t * I)‖ ^ 2 =
      ‖Gl L' ((σ₀ : ℂ) + t * I)‖ ^ 2 * msq M a σ₀ t := by
  unfold msq
  rw [norm_mul, mul_pow]

/-- **The sharp one-sided mean.** For `P(0) = 0`, `0 < θ < 1/2`, `R > 0`, every `ε > 0`: from
some height on, for `a′ ∈ [T/2, T/2 + 1]`, `b′ ∈ [T − 1, T]`,
`(1/(b′−a′)) ∫_{a′}^{b′} |G(σ₀+it) ψ(σ₀+it)|² dt ≤ Re D[c](−R/L, −R/L) + ε`. -/
theorem unsmooth_near (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε := by
  intro ε hε
  obtain ⟨K, hK0, TK, hK⟩ := dop_cY_bdd P hθ0 hθ hR
  set C : ℝ := 1 + winC 1 + winC 2 with hCdef
  have hC : 0 < C := by
    have := winC_nonneg 1
    have := winC_nonneg 2
    positivity
  set ε₁ : ℝ := ε / (8 * C) with hε₁def
  have hε₁ : 0 < ε₁ := by positivity
  have hε₁C : ε₁ * C = ε / 8 := by rw [hε₁def]; field_simp
  obtain ⟨T1, hT1⟩ := stmtMollMeanO_holds P hP0 hθ0 hθ hR winC ε₁ hε₁
  refine ⟨max (max T1 TK) (max (max 16 (32 * K / ε)) (Real.exp (max 8 (48 * K / ε)))),
    fun T hT a' b' ha1 ha2 hb1 hb2 => ?_⟩
  simp only [max_le_iff] at hT
  obtain ⟨⟨hTa, hTb⟩, ⟨hT16, hTK⟩, hTe⟩ := hT
  have hT0 : 0 < T := by linarith
  have hLge : max 8 (48 * K / ε) ≤ Real.log T := (Real.le_log_iff_exp_le hT0).mpr hTe
  have hL8 : 8 ≤ Real.log T := le_trans (le_max_left _ _) hLge
  have hLK : 48 * K / ε ≤ Real.log T := le_trans (le_max_right _ _) hLge
  have hL0 : 0 < Real.log T := by linarith
  have hΔ : 0 < T / Real.log T := div_pos hT0 hL0
  have hΔ1 : T / Real.log T ≤ T / 8 := div_le_div_of_nonneg_left hT0.le (by norm_num) hL8
  set W : WeightAll T (Real.log T) := winNear T (Real.log T) hT0 hL8 with hWdef
  have hW := hT1 T hTa W (fun j => le_rfl)
  set D : ℂ := Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
      ((-(R / Real.log T) : ℝ) : ℂ) with hDdef
  have hDK : |D.re| ≤ K := (Complex.abs_re_le_norm D).trans (hK T hTb)
  set mm := mollMean W.toWeight (Mof T θ) (aY P T θ R) (sig0 T R) (Real.log T) with hmm
  set ŵ := what0 W.toWeight with hŵ
  have herr : errO W.toWeight = C * T := rfl
  -- the real part of the smoothed mean
  have hre : mm.re ≤ D.re * ŵ + ε₁ * (C * T) := by
    have h1 := Complex.re_le_norm (mm - D * (ŵ : ℂ))
    rw [Complex.sub_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero,
      sub_zero] at h1
    rw [← herr]
    linarith
  -- the window on `[a', b']`
  have hab : a' ≤ b' := by linarith
  have hone : ∀ t ∈ Set.Icc a' b', W.w t = 1 := by
    intro t ht
    show winNY T (Real.log T) t = 1
    exact winNY_one hΔ (by linarith [ht.1]) (by linarith [ht.2])
  set f : ℝ → ℝ := fun t => ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I)‖ ^ 2 *
      msq (Mof T θ) (aY P T θ R) (sig0 T R) t with hfdef
  have hσ1 : sig0 T R ≠ 1 := by
    unfold sig0
    have : 0 < R / Real.log T := by positivity
    intro h
    linarith
  have hfc : Continuous f := continuous_Gpsi (Mof T θ) (aY P T θ R) hσ1 (Real.log T)
  have hf0 : ∀ t, 0 ≤ f t := fun t => mul_nonneg (by positivity) (msq_nonneg _ _ _ _)
  have hint : ∫ t in a'..b', ‖Gl (Real.log T) ((sig0 T R : ℂ) + t * I) *
      psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 = ∫ t in a'..b', f t := by
    congr 1
    funext t
    exact norm_Gpsi_sq _ _ _ _ _
  have hsharp : ∫ t in a'..b', f t ≤ mm.re := by
    rw [hmm, mollMean_re]
    exact integral_le_of_one W.toWeight hfc hf0 hab hone
  -- `d ≤ ŵ(0) ≤ d + 3T/L + 2`
  set d := b' - a' with hd
  have hdT : T / 4 ≤ d := by linarith
  have hd0 : 0 < d := by linarith
  have hŵlo : d ≤ ŵ := by
    have h := integral_le_of_one W.toWeight (f := fun _ => (1 : ℝ)) continuous_const
      (fun _ => zero_le_one) hab hone
    rw [intervalIntegral.integral_const, smul_eq_mul, mul_one] at h
    simp only [mul_one] at h
    exact h
  have hŵhi : ŵ ≤ d + (3 * (T / Real.log T) + 2) := by
    have hlh : nearLo T (Real.log T) ≤ nearHi T (Real.log T) := by
      unfold nearLo nearHi; linarith
    have h := what0_le_of_zero W.toWeight hlh (fun t ht => by
      show winNY T (Real.log T) t = 0
      exact winNY_zero hΔ fun h' => ht ⟨h'.1.le, h'.2.le⟩)
    unfold nearLo nearHi at h
    linarith
  -- the excess
  have hexc : D.re * ŵ ≤ D.re * d + K * (3 * (T / Real.log T) + 2) := by
    have h1 : D.re * (ŵ - d) ≤ K * (ŵ - d) :=
      mul_le_mul_of_nonneg_right ((le_abs_self _).trans hDK) (by linarith)
    have h2 : K * (ŵ - d) ≤ K * (3 * (T / Real.log T) + 2) :=
      mul_le_mul_of_nonneg_left (by linarith) hK0
    have e : D.re * ŵ = D.re * d + D.re * (ŵ - d) := by ring
    linarith
  -- the sizes
  have hs1 : K * (3 * (T / Real.log T)) ≤ ε * T / 16 := by
    have h48 : 48 * K ≤ ε * Real.log T := by
      rw [div_le_iff₀ hε] at hLK
      linarith
    have e : K * (3 * (T / Real.log T)) = (48 * K) * T / (16 * Real.log T) := by
      field_simp
      try ring
    rw [e, div_le_iff₀ (by positivity)]
    have e2 : ε * T / 16 * (16 * Real.log T) = (ε * Real.log T) * T := by ring
    rw [e2]
    exact mul_le_mul_of_nonneg_right h48 hT0.le
  have hs2 : K * 2 ≤ ε * T / 16 := by
    rw [div_le_iff₀ hε] at hTK
    linarith
  have hs3 : ε₁ * (C * T) = ε * T / 8 := by
    rw [← mul_assoc, hε₁C]
    ring
  have hfin : ∫ t in a'..b', f t ≤ D.re * d + ε * d := by
    have h1 : ε * T / 4 ≤ ε * d := by
      have := mul_le_mul_of_nonneg_left hdT hε.le
      linarith
    nlinarith
  rw [hint, one_div_mul_eq_div, div_le_iff₀ hd0]
  linarith

/-- **The sharp one-sided mean in `levinson_window'`'s integrand**, at `σ = σ₀`:
`(ζ(s) + c ζ′(s)) · molli M β s` with `c = 1/log T`, `β = aY P T θ R`. -/
theorem unsmooth_near_levinson (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ c : ℝ, c = 1 / Real.log T →
      ∀ a' b' : ℝ, T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖(riemannZeta (↑(sig0 T R) + ↑t * I) + c * deriv riemannZeta (↑(sig0 T R) + ↑t * I))
            * LevinsonMollEdge.molli (Mof T θ) (aY P T θ R) (↑(sig0 T R) + ↑t * I)‖ ^ 2 ≤
        (Dop (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε := by
  intro ε hε
  obtain ⟨T₀, hT₀⟩ := unsmooth_near P hP0 hθ0 hθ hR ε hε
  refine ⟨T₀, fun T hT c hc a' b' ha1 ha2 hb1 hb2 => ?_⟩
  have e : ∀ s : ℂ, (riemannZeta s + c * deriv riemannZeta s) *
      LevinsonMollEdge.molli (Mof T θ) (aY P T θ R) s =
      Gl (Real.log T) s * psi (Mof T θ) (aY P T θ R) s := by
    intro s
    unfold Gl
    rw [hc]
    push_cast
    unfold LevinsonMollEdge.molli psi
    ring
  simp_rw [e]
  exact hT₀ T hT a' b' ha1 ha2 hb1 hb2

/-- info: 'Unsmooth.mollMean_re' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMean_re

/-- info: 'Unsmooth.unsmooth_near' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unsmooth_near

/-- info: 'Unsmooth.unsmooth_near_levinson' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms unsmooth_near_levinson

end Unsmooth
