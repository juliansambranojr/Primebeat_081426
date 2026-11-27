/-
BasinChainCount — block S15 of `lean_stage3/design/stencil.md`, the chain from no right zeros,
steps 1 and 2: the hypothesis and the count with no losses. 2026-11-25.

Pins: `PINS.md` § Current, "the chain to the goal from no right zeros".

**Step 1, the hypothesis** (`StmtNoRightZeros Q T₀`): for every `T ≥ T₀`, `V = ConreyCount.V Q
(log T)` has no zero `s` with `1/2 < Re s ≤ 3` and `T/4 ≤ Im s ≤ 2T`. This is what the count
reads: `Littlewood.countRight V (1/2 + a i) (3 + b i) (1/2)` counts the zeros with `Re > 1/2` in
`[1/2, 3] × [a, b]`, and the window of `DigammaBound.conrey_count_window'` is `[a, b] ⊆ [T/4,
2T]`. The avoidance on the edges is not asked: at the heights `a`, `b` carrying no zero of `ζ`
(all but finitely many in a window), `V ≠ 0` at `1/2 + a i` (a zero of `V` on the line is a zero
of `ζ`, `V_line_ne`), `V ≠ 0` on the rest of the edges by the hypothesis, and `V ≠ 0` on
`Re s = 3` by its size (`V_near_one`). Non-vacuous: for `Q = 1`, `V = ζ`, and RH gives the
hypothesis (`noRightZeros_one_of_rh`).

**Step 2, the count with no losses** (`count_exact`): the proof of
`ConreyCount.conrey_count_sub` with every size left exact. The turning of the line function is
`θ b − θ a` (`LevinsonSize.gamma_part_eq`) plus the three edges of `V` less `πK`, and the floor
loses less than `1`:

  `lineCount b − lineCount a > (θ b − θ a + h(a) − h(b) + R)/π − 2·countRight − 1`,

`h(t) = Im ∫_{1/2}^{3} V′/V (x + it) dx` (`hEdge`), `R = Re ∫_a^b V′/V (3 + it) dt`. On the
right edge `‖V − 1‖ ≤ r = π²/6 − 1 + 1/100 < 1` (`V_near_one`, from `DigammaBound`'s
`‖V − ζ‖ ≤ 1/100` and `‖ζ(3 + it) − 1‖ ≤ π²/6 − 1`), so `|arg V| ≤ arcsin r` and
`|R| ≤ 2 arcsin r` (`right_edge_le_arcsin`); the crude `|R| ≤ π` of
`ConreyCount.right_edge_le_of_re_pos` would leave the constant at `2` and no margin
(`checks/basinchain/sizes.out` § 1). With `N = θ/π + 1 + S` this is the increment
(`increment_lt`, `increment_window`): at good heights `a < b` in `[T/4, 2T]`,

  `D b − D a < (S b + h(b)/π) − (S a + h(a)/π) + 1 + 2 arcsin(r)/π`.

  | name | statement | status |
  |---|---|---|
  | `StmtNoRightZeros` | the hypothesis | def |
  | `hEdge` | `h(t) = Im ∫_{1/2}^{3} V′/V (x + it) dx` | def |
  | `noRightZeros_one_of_rh` | RH ⊢ `StmtNoRightZeros 1 T₀` | PROVED |
  | `count_exact` | the exact count, avoidance as hypotheses | PROVED |
  | `abs_arg_le_arcsin` | `‖w − 1‖ ≤ r < 1` ⊢ `|arg w| ≤ arcsin r` | PROVED |
  | `right_edge_le_arcsin` | `‖G − 1‖ ≤ r < 1` on `3 + [a, b] i` ⊢ `|R| ≤ 2 arcsin r` | PROVED |
  | `V_near_one` | DigammaBound's range ⊢ `‖V(3 + it) − 1‖ ≤ π²/6 − 1 + 1/100` | PROVED |
  | `increment_lt` | the increment at good heights, `‖V − 1‖ ≤ r` on the right edge | PROVED |
  | `increment_window` | `∃ T₁`, the increment for `T ≥ T₁`, `[a, b] ⊆ [T/4, 2T]` | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ConreyCount
import Stage3.DigammaBound
import Stage3.TuringCert

noncomputable section

namespace BasinChain

open Complex Polynomial MeasureTheory Set Filter Topology Littlewood LineCount Kadiri
  LevinsonWindow LevinsonMultiple ConreyCount
open scoped Interval

/-- **The hypothesis.** From `T₀` on, `V = ConreyCount.V Q (log T)` has no zero with
`1/2 < Re s ≤ 3` and `T/4 ≤ Im s ≤ 2T`. -/
def StmtNoRightZeros (Q : ℝ[X]) (T₀ : ℝ) : Prop :=
  ∀ T : ℝ, T₀ ≤ T → ∀ s : ℂ, 1/2 < s.re → s.re ≤ 3 → T / 4 ≤ s.im → s.im ≤ 2 * T →
    V Q (Real.log T) s ≠ 0

/-- The horizontal edge at height `t`: `Im ∫_{1/2}^{3} V′/V (x + it) dx`, the turning of
`arg V` from `1/2 + it` to `3 + it`. -/
def hEdge (Q : ℝ[X]) (L t : ℝ) : ℝ :=
  (∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑t * I)).im

/-- For `Q = 1`, `W = Λ`. -/
theorem W_one (L : ℝ) : OperatorQ.W 1 L = completedRiemannZeta := by
  funext s
  simp [OperatorQ.W]

/-- **Non-vacuity.** For `Q = 1`, `V = ζ` on `Re s > 0`, and RH gives the hypothesis. -/
theorem noRightZeros_one_of_rh (hRH : RiemannHypothesis) (T₀ : ℝ) (hT₀ : 0 < T₀) :
    StmtNoRightZeros 1 T₀ := by
  intro T hT s hs1 hs3 hsT _ h0
  have hT0 : 0 < T := lt_of_lt_of_le hT₀ hT
  have hs0 : s ≠ 0 := by
    intro h; rw [h, Complex.zero_re] at hs1; linarith
  have hV : V 1 (Real.log T) s = riemannZeta s := by
    rw [V, W_one, riemannZeta_def_of_ne_zero hs0]
  rw [hV] at h0
  have hre := hRH s h0 (by
      rintro ⟨n, hn⟩
      have := congrArg Complex.re hn
      simp at this
      linarith [this, n.cast_nonneg (α := ℝ)])
    (by
      intro h1
      have := congrArg Complex.im h1
      simp at this
      linarith)
  linarith

set_option maxHeartbeats 800000 in
/-- **Levinson's count for `V = W/Gammaℝ`, exact form.** The proof of
`ConreyCount.conrey_count_sub` with the sizes left out: for `Q′(x) = Q′(1 − x)`, `Q(1/2) ≠ 0`,
`4 ≤ a < b`, `V` nonzero on the bottom, top and right edges of `[1/2, 3] × [a, b]` and
`ζ(1/2 + a i) ≠ 0`, the zeros of `ζ` on the line with height in `(a, b]` number more than
`(θ b − θ a + E)/π − 2·countRight − 1`, `E` the three edges of `V` (bottom − top + right),
exactly as the argument principle gives them. -/
theorem count_exact {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b : ℝ} (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0)
    (hRne : ∀ t ∈ Icc a b, V Q L (3 + t * I) ≠ 0) :
    ((Stage3.phaseTheta b - Stage3.phaseTheta a)
        + ((∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑a * I)).im
          - (∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑b * I)).im
          + (∫ t in a..b, logDeriv (V Q L) (3 + ↑t * I)).re)) / Real.pi
      - 2 * Littlewood.countRight (V Q L) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) - 1
        < (lineCount b : ℝ) - (lineCount a : ℝ) := by
  classical
  set G : ℂ → ℂ := V Q L with hG_def
  have hπ : 0 < Real.pi := Real.pi_pos
  -- the rectangle
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((3 : ℂ) + b * I).re = 3 := by simp
  have hwim : ((3 : ℂ) + b * I).im = b := by simp
  have hmemR : ∀ p, p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ↔
      1/2 ≤ p.re ∧ p.re ≤ 3 ∧ a ≤ p.im ∧ p.im ≤ b := by
    intro p
    rw [mem_Rect (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; exact hab.le), hzre, hzim,
      hwre, hwim]
  have hGa : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) := by
    intro p hp
    have h := (hmemR p).mp hp
    exact analyticAt_V_upper Q L (by linarith [h.2.2.1])
  have hlineR : ∀ t ∈ Icc a b, ((1/2 : ℂ) + t * I) ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) :=
    fun t ht => (hmemR _).mpr ⟨by rw [HardyZ.re_line], by rw [HardyZ.re_line]; norm_num,
      by simpa using ht.1, by simpa using ht.2⟩
  have hGz : G ((1/2 : ℂ) + a * I) ≠ 0 := by
    have h := hBot (1/2) ⟨le_rfl, by norm_num⟩
    push_cast at h
    exact h
  have hfinM := Littlewood.order_ne_top hGa hGz
  have hfin : ∀ p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      analyticOrderAt G p ≠ ⊤ := by
    intro p hp htop
    apply hfinM p hp
    rw [(hGa p hp).meromorphicOrderAt_eq, htop]
    rfl
  -- the zeros of `V` on the left edge
  set D : Finset ℂ := (divisor_support_rectangle_finite G ((1/2 : ℂ) + a * I)
    ((3 : ℂ) + b * I)).toFinset.filter (fun p => p.re = 1/2) with hD_def
  have hmemD : ∀ p, p ∈ D ↔
      p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ∧ G p = 0 ∧ p.re = 1/2 := by
    intro p
    rw [hD_def, Finset.mem_filter, Set.Finite.mem_toFinset,
      Littlewood.mem_support_divisor subset_rfl hGa hfinM, and_assoc]
  have hDprop : ∀ ρ ∈ D, ρ.re = 1/2 ∧ a < ρ.im ∧ ρ.im < b := by
    intro ρ hρ
    obtain ⟨hR', h0, hre⟩ := (hmemD ρ).mp hρ
    obtain ⟨-, -, h3, h4⟩ := (hmemR ρ).mp hR'
    have hρeq : ρ = ↑ρ.re + ↑ρ.im * I := (Complex.re_add_im ρ).symm
    refine ⟨hre, lt_of_le_of_ne h3 ?_, lt_of_le_of_ne h4 ?_⟩
    · intro he
      apply hBot ρ.re ⟨by linarith, by linarith⟩
      rw [he, ← hρeq]
      exact h0
    · intro he
      apply hTop ρ.re ⟨by linarith, by linarith⟩
      rw [← he, ← hρeq]
      exact h0
  have hρeq : ∀ ρ ∈ D, ρ = (1/2 : ℂ) + ↑ρ.im * I := by
    intro ρ hρ
    apply Complex.ext <;> simp [(hDprop ρ hρ).1]
  have hζD : ∀ ρ ∈ D, riemannZeta ρ = 0 := by
    intro ρ hρ
    obtain ⟨-, h0, -⟩ := (hmemD ρ).mp hρ
    have hG0 : Gammaℝ ((1/2 : ℂ) + ↑ρ.im * I) ≠ 0 :=
      Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts ρ.im).2.2
    have h := (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L ρ.im).mpr (by
        rw [W_eq_gammaR_mul_V Q L hG0, ← hρeq ρ hρ]
        show (Gammaℝ ρ * G ρ).re = 0
        rw [h0, mul_zero, Complex.zero_re])
    rwa [← hρeq ρ hρ] at h
  -- divide them out
  set n : ℂ → ℕ := fun p => (analyticOrderAt G p).toNat with hn_def
  have hn : ∀ ρ ∈ D, (n ρ : ℕ∞) = analyticOrderAt G ρ := fun ρ hρ =>
    ENat.coe_toNat (hfin ρ ((hmemD ρ).mp hρ).1)
  obtain ⟨H, hHa, hGPH⟩ := exists_prod_mul (S := Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I))
    n D G (fun ρ hρ => ((hmemD ρ).mp hρ).1) (fun p hp => hGa p hp) (fun ρ hρ => (hn ρ hρ).le)
  have hHne_of_G : ∀ p, G p ≠ 0 → H p ≠ 0 := fun p hp h => hp (by rw [hGPH p, h, mul_zero])
  have hHneD : ∀ ρ ∈ D, H ρ ≠ 0 := by
    intro ρ hρ
    have hR' := ((hmemD ρ).mp hρ).1
    have e : G = polyP D n * H := funext fun s => hGPH s
    have hord : analyticOrderAt G ρ = n ρ + analyticOrderAt H ρ := by
      rw [e, analyticOrderAt_mul (polyP_analyticAt D n ρ) (hHa ρ hR'), polyP_order n hρ]
    rw [← hn ρ hρ] at hord
    have h0 : analyticOrderAt H ρ = 0 := by
      cases h : analyticOrderAt H ρ with
      | top => rw [h] at hord; simp at hord
      | coe m =>
        rw [h] at hord
        have h1 : n ρ = n ρ + m := by exact_mod_cast hord
        have hm : m = 0 := by omega
        rw [hm]
        rfl
    exact (hHa ρ hR').analyticOrderAt_eq_zero.mp h0
  have hHline : ∀ t ∈ Icc a b, H (1/2 + t * I) ≠ 0 := by
    intro t ht
    by_cases hG0 : G (1/2 + t * I) = 0
    · apply hHneD
      rw [hmemD]
      exact ⟨hlineR t ht, hG0, HardyZ.re_line t⟩
    · exact hHne_of_G _ hG0
  have hGright : ∀ t ∈ Icc a b, G (3 + t * I) ≠ 0 := hRne
  have hHB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I), H p ≠ 0 := by
    intro p hp
    have hcases := LevinsonWindow.border_cases (by rw [hzre, hwre]; norm_num)
      (by rw [hzim, hwim]; exact hab.le) hp
    rw [hzre, hzim, hwre, hwim] at hcases
    have hp' : p = ↑p.re + ↑p.im * I := (Complex.re_add_im p).symm
    rcases hcases with ⟨him, hre⟩ | ⟨hre, him⟩ | ⟨him, hre⟩ | ⟨hre, him⟩
    · apply hHne_of_G
      rw [hp', him]
      exact hBot p.re hre
    · rw [hp', hre]
      push_cast
      exact hHline p.im him
    · apply hHne_of_G
      rw [hp', him]
      exact hTop p.re hre
    · apply hHne_of_G
      rw [hp', hre]
      push_cast
      exact hGright p.im him
  -- the argument principle for `H`
  have hcast : ((3 : ℝ) : ℂ) = (3 : ℂ) := by norm_num
  have hHa3 : AnalyticOnNhd ℂ H (Rectangle ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I)) := by
    rw [hcast]; exact hHa
  have hHB3 : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I), H p ≠ 0 := by
    rw [hcast]; exact hHB
  have hHturn := LevinsonTurn.G_turn_eq (G := H) (X := 3) (by norm_num) hab hHa3 hHB3
  rw [hcast] at hHturn
  have hHz : H ((1/2 : ℂ) + a * I) ≠ 0 := hHne_of_G _ hGz
  have hC : Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      = Littlewood.countRight H ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) :=
    countRight_eq_of_mul hGa hHa (fun p => polyP_analyticAt D n p)
      (fun p _ hσ => polyP_ne_zero n (fun hpD => by
        have := (hDprop p hpD).1
        linarith))
      (funext fun s => hGPH s) hGz hHz
  -- the edges: `V = P · H`
  have e : G = fun s => polyP D n s * H s := funext hGPH
  have hbotS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑a * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑a * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2, by simp,
        by simpa using hab.le⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.1; simp at this))
      (fun x hx => hHne_of_G _ (hBot x hx))
  have htopS : (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I))
      = (∫ x in (1/2:ℝ)..3, logDeriv (polyP D n) (↑x + ↑b * I))
        + ∫ x in (1/2:ℝ)..3, logDeriv H (↑x + ↑b * I) := by
    rw [e]
    exact integral_logDeriv_mul (by norm_num) (by fun_prop)
      (fun x _ => polyP_analyticAt D n _)
      (fun x hx => hHa _ ((hmemR _).mpr ⟨by simpa using hx.1, by simpa using hx.2,
        by simpa using hab.le, by simp⟩))
      (fun x _ => polyP_ne_zero n (fun hD => by have := (hDprop _ hD).2.2; simp at this))
      (fun x hx => hHne_of_G _ (hTop x hx))
  have hrtS : (∫ t in a..b, logDeriv G (3 + ↑t * I))
      = (∫ t in a..b, logDeriv (polyP D n) (3 + ↑t * I))
        + ∫ t in a..b, logDeriv H (3 + ↑t * I) := by
    rw [e]
    exact integral_logDeriv_mul hab.le (by fun_prop)
      (fun t _ => polyP_analyticAt D n _)
      (fun t ht => hHa _ ((hmemR _).mpr ⟨by simp; norm_num, by simp, by simpa using ht.1,
        by simpa using ht.2⟩))
      (fun t _ => polyP_ne_zero n (fun hD => by
        have := (hDprop _ hD).1
        simp at this
        norm_num at this))
      (fun t ht => hHne_of_G _ (hGright t ht))
  have hbot' := congrArg Complex.im hbotS
  have htop' := congrArg Complex.im htopS
  have hrt' := congrArg Complex.re hrtS
  rw [Complex.add_im] at hbot' htop'
  rw [Complex.add_re] at hrt'
  have hPE := polyP_edges hab.le n hDprop
  -- the line
  have hFa : ∀ t ∈ Icc a b, AnalyticAt ℂ
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) := fun t ht =>
    analyticAt_const.mul ((LevinsonTurn.analyticAt_Gammaℝ (LevinsonLine.line_facts t).2.2).mul
      (hHa _ (hlineR t ht)))
  have hFne : ∀ t ∈ Icc a b,
      (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) (1/2 + t * I) ≠ 0 := fun t ht =>
    mul_ne_zero (pow_ne_zero _ Complex.I_ne_zero)
      (mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hHline t ht))
  have hFc : ContinuousOn (fun t : ℝ => I ^ (∑ ρ ∈ D, n ρ) *
      (Gammaℝ (1/2 + t * I) * H (1/2 + t * I))) (Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (f := fun t : ℝ => (1/2 + t * I : ℂ)) (hFa t ht).continuousAt
      LevinsonTurn.continuous_line.continuousAt).continuousWithinAt
  obtain ⟨φ, hφc, hφ⟩ := LevinsonArg.exists_arg_lift hab.le hFc hFne
  have hturn1 := LevinsonTurn.line_turn_eq_integral
    (f := fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s)) hab.le hFa hFne hφc hφ
  have hld : (∫ t in a..b, logDeriv (fun s => I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ s * H s))
      (1/2 + t * I)) = ∫ t in a..b, logDeriv (fun s => Gammaℝ s * H s) (1/2 + t * I) :=
    intervalIntegral.integral_congr fun t _ =>
      logDeriv_const_mul _ _ (pow_ne_zero _ Complex.I_ne_zero)
  have hsplit := LevinsonTurn.turn_split (G := H) hab.le (fun t ht => hHa _ (hlineR t ht)) hHline
  rw [hld, hsplit] at hturn1
  -- the turning, exactly
  have hΓ := LevinsonSize.gamma_part_eq a b
  set C := Littlewood.countRight G ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) with hC_def
  set Kr : ℝ := ∑ ρ ∈ D, (n ρ : ℝ) with hKr
  set Qc := ((Stage3.phaseTheta b - Stage3.phaseTheta a)
        + ((∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I)).im
          - (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I)).im
          + (∫ t in a..b, logDeriv G (3 + ↑t * I)).re)) / Real.pi - 2 * C with hQc
  have hdiff : Real.pi * (Qc - Kr) ≤ φ b - φ a := by
    have e1 : Real.pi * (Qc - Kr) = (Stage3.phaseTheta b - Stage3.phaseTheta a)
        + ((∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑a * I)).im
          - (∫ x in (1/2:ℝ)..3, logDeriv G (↑x + ↑b * I)).im
          + (∫ t in a..b, logDeriv G (3 + ↑t * I)).re) - 2 * Real.pi * C - Real.pi * Kr := by
      rw [hQc]; field_simp
    rw [e1]
    rw [← hC] at hHturn
    linarith [hturn1, hHturn, hbot', htop', hrt', hPE, hΓ]
  -- the floor
  set k : ℕ := ⌊max 0 (Qc - Kr)⌋₊ with hk_def
  have hkle : (k : ℝ) ≤ max 0 (Qc - Kr) := Nat.floor_le (le_max_left _ _)
  have hklt : max 0 (Qc - Kr) < (k : ℝ) + 1 := Nat.lt_floor_add_one _
  have hmax : max 0 (Qc - Kr) * Real.pi ≤ |φ b - φ a| := by
    rcases le_total (Qc - Kr) 0 with h | h
    · rw [max_eq_left h, zero_mul]; exact abs_nonneg _
    · rw [max_eq_right h]
      linarith [le_abs_self (φ b - φ a)]
  have hk : (k : ℝ) * Real.pi ≤ |φ b - φ a| :=
    le_trans (mul_le_mul_of_nonneg_right hkle hπ.le) hmax
  obtain ⟨t, hmono, hmem, hcos⟩ := LevinsonArg.crossings_of_arg hab.le hφc k hk
  -- the real part of the line function vanishes at every crossing
  have hreFt : ∀ i, (I ^ (∑ ρ ∈ D, n ρ) * (Gammaℝ (1/2 + t i * I) * H (1/2 + t i * I))).re = 0 := by
    intro i
    rw [hφ _ (hmem i), Complex.re_ofReal_mul, Complex.exp_ofReal_mul_I_re, hcos i, mul_zero]
  -- every crossing is a zero of `ζ`
  have hζt : ∀ i, riemannZeta (1/2 + t i * I) = 0 := by
    intro i
    apply (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L (t i)).mpr
    have hid := line_identity hQ (fun ρ hρ => (hDprop ρ hρ).1) hGPH (L := L) (t i)
    rw [hreFt i, mul_zero, Complex.ofReal_zero] at hid
    rw [OperatorQ.re_W_line Q hQ L]
    have hz : completedRiemannZeta (1/2 + ↑(t i) * I) = 0 := by
      have hh : ((Q.eval (1/2 : ℝ) : ℝ) : ℂ) ≠ 0 := by
        rw [Ne, Complex.ofReal_eq_zero]; exact hQh
      exact (mul_eq_zero.mp hid).resolve_left hh
    rw [hz, Complex.zero_re, mul_zero]
  -- the count: crossings once, the zeros of `D` with weight `n ρ`, one more at a crossing
  set Γs : Finset ℝ := D.image (fun ρ => ρ.im) with hΓs
  set Cr : Finset ℝ := Finset.univ.image t with hCr
  set E : Finset ℝ := Cr ∪ Γs with hE
  have hmemCr : ∀ γ ∈ Cr, ∃ i, t i = γ := by
    intro γ hγ
    rw [hCr, Finset.mem_image] at hγ
    obtain ⟨i, -, hi⟩ := hγ
    exact ⟨i, hi⟩
  have hmemΓ : ∀ γ ∈ Γs, ∃ ρ ∈ D, ρ.im = γ := by
    intro γ hγ
    rw [hΓs, Finset.mem_image] at hγ
    exact hγ
  have hmemE : ∀ γ ∈ E, γ ∈ Cr ∨ γ ∈ Γs := fun γ hγ => Finset.mem_union.mp hγ
  have hEζ : ∀ γ ∈ E, riemannZeta (1/2 + γ * I) = 0 := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      exact hζt i
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      rw [← hρeq ρ hρ]; exact hζD ρ hρ
  have hEgt : ∀ γ ∈ E, a < γ := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      refine lt_of_le_of_ne (hmem i).1 fun he => hζa ?_
      rw [he]
      exact hζt i
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      exact (hDprop ρ hρ).2.1
  have hET : ∀ γ ∈ E, γ ≤ b := by
    intro γ hγ
    rcases hmemE γ hγ with hc | hd
    · obtain ⟨i, rfl⟩ := hmemCr γ hc
      exact (hmem i).2
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ γ hd
      exact (hDprop ρ hρ).2.2.le
  have hsum := LevinsonWindowNear.sum_order_le_lineCount_sub (by linarith) hab.le E hEgt hET hEζ
  have hord : ∀ γ ∈ E, (if γ ∈ Cr then (1 : ℤ) else 0)
      + (if γ ∈ Γs then (n (1/2 + γ * I) : ℤ) else 0)
      ≤ riemannZeta.order (1/2 + γ * I) := by
    intro γ hγ
    have hmemZ : ((1/2 : ℂ) + (γ : ℂ) * I) ∈ NontrivialZeros := by
      refine ⟨?_, Set.mem_univ _, hEζ γ hγ⟩
      rw [HardyZ.re_line]
      norm_num
    have hone : (1 : ℤ) ≤ riemannZeta.order (1/2 + γ * I) := by
      have := riemannZeta_one_le_order_nontrivialZero ⟨_, hmemZ⟩
      simpa using this
    by_cases hγΓ : γ ∈ Γs
    · obtain ⟨ρ, hρ, rfl⟩ := hmemΓ _ hγΓ
      have hR' := ((hmemD ρ).mp hρ).1
      have hge := zeta_order_ge_line hQ hQh (fun ρ' hρ' => (hDprop ρ' hρ').1) hGPH hρ (hHa ρ hR')
      rw [if_pos hγΓ, ← hρeq ρ hρ]
      by_cases hγC : ρ.im ∈ Cr
      · rw [if_pos hγC]
        obtain ⟨i, hi⟩ := hmemCr _ hγC
        have hF0 : (I ^ (∑ ρ' ∈ D, n ρ') * (Gammaℝ ρ * H ρ)).re = 0 := by
          have h := hreFt i
          rw [hi, ← hρeq ρ hρ] at h
          exact h
        linarith [hge.2 hF0]
      · rw [if_neg hγC]
        linarith [hge.1]
    · rw [if_neg hγΓ, add_zero]
      split_ifs
      · exact hone
      · linarith
  have hsumge : ((Cr.card : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ))
      ≤ ∑ γ ∈ E, riemannZeta.order (1/2 + γ * I) := by
    have h1 := Finset.sum_le_sum hord
    rw [Finset.sum_add_distrib, Finset.sum_ite_mem, Finset.sum_ite_mem,
      Finset.inter_eq_right.mpr Finset.subset_union_left,
      Finset.inter_eq_right.mpr Finset.subset_union_right, Finset.sum_const, nsmul_eq_mul,
      mul_one] at h1
    have h2 : ∑ γ ∈ Γs, (n (1/2 + γ * I) : ℤ) = ∑ ρ ∈ D, (n ρ : ℤ) := by
      rw [hΓs, Finset.sum_image]
      · exact Finset.sum_congr rfl fun ρ hρ => by rw [← hρeq ρ hρ]
      · intro ρ₁ h₁ ρ₂ h₂ he
        rw [hρeq ρ₁ h₁, hρeq ρ₂ h₂]
        simp only at he
        rw [he]
    rw [h2] at h1
    exact h1
  have hcardCr : Cr.card = k := by
    rw [hCr, Finset.card_image_of_injective _ hmono.injective, Finset.card_univ,
      Fintype.card_fin]
  have hfinal : ((k : ℤ) + ∑ ρ ∈ D, (n ρ : ℤ)) ≤ lineCount b - lineCount a := by
    rw [← hcardCr]
    linarith
  have hfinalR : (k : ℝ) + Kr ≤ (lineCount b : ℝ) - (lineCount a : ℝ) := by
    rw [hKr]
    exact_mod_cast hfinal
  have hQmax : Qc - Kr ≤ max 0 (Qc - Kr) := le_max_right _ _
  linarith
/-- **The argument near one.** `‖w − 1‖ ≤ r < 1` ⊢ `|arg w| ≤ arcsin r`. -/
theorem abs_arg_le_arcsin {w : ℂ} {r : ℝ} (hr : r < 1) (hw : ‖w - 1‖ ≤ r) :
    |Complex.arg w| ≤ Real.arcsin r := by
  have hr0 : 0 ≤ r := le_trans (norm_nonneg _) hw
  have hre : 1 - r ≤ w.re := by
    have h := Complex.abs_re_le_norm (w - 1)
    rw [Complex.sub_re, Complex.one_re] at h
    linarith [(abs_le.mp (le_trans h hw)).1]
  have hre0 : 0 < w.re := by linarith
  have hw0 : 0 < ‖w‖ := lt_of_lt_of_le hre0 (Complex.re_le_norm w)
  -- `Im w ^ 2 ≤ r ^ 2 ‖w‖ ^ 2`
  set x := w.re - 1 with hx
  set y := w.im with hy
  have hxy : x ^ 2 + y ^ 2 ≤ r ^ 2 := by
    have h1 : ‖w - 1‖ ^ 2 = x ^ 2 + y ^ 2 := by
      rw [Complex.sq_norm, Complex.normSq_apply, Complex.sub_re, Complex.sub_im,
        Complex.one_re, Complex.one_im, hx, hy]
      ring
    rw [← h1]
    exact pow_le_pow_left₀ (norm_nonneg _) hw 2
  have hnw : ‖w‖ ^ 2 = (1 + x) ^ 2 + y ^ 2 := by
    rw [Complex.sq_norm, Complex.normSq_apply, hx, hy]
    ring
  have hsq : y ^ 2 ≤ (r * ‖w‖) ^ 2 := by
    rw [mul_pow, hnw]
    have hr1 : 0 ≤ 1 - r ^ 2 := by nlinarith
    nlinarith [sq_nonneg (x + r ^ 2), mul_nonneg hr1 (sub_nonneg.mpr hxy)]
  have hy1 : |y| ≤ r * ‖w‖ := abs_le_of_sq_le_sq hsq (by positivity)
  have hq : |y / ‖w‖| ≤ r := by
    rw [abs_div, abs_of_pos hw0, div_le_iff₀ hw0]
    exact hy1
  rw [Complex.arg_of_re_nonneg hre0.le]
  obtain ⟨hq1, hq2⟩ := abs_le.mp hq
  rw [abs_le]
  constructor
  · rw [← Real.arcsin_neg]; exact Real.arcsin_le_arcsin hq1
  · exact Real.arcsin_le_arcsin hq2

/-- **The right edge near one.** Where `‖G − 1‖ ≤ r < 1` on `3 + [a, b] i`,
`|Re ∫_a^b G′/G (3 + it) dt| ≤ 2 arcsin r`. The proof of
`ConreyCount.right_edge_le_of_re_pos`, with `abs_arg_le_arcsin` at the two ends. -/
theorem right_edge_le_arcsin {G : ℂ → ℂ} {a b r : ℝ} (hab : a ≤ b)
    (hGa : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ G (3 + t * I)) (hr : r < 1)
    (hnear : ∀ t ∈ Set.Icc a b, ‖G (3 + t * I) - 1‖ ≤ r) :
    |(∫ t in a..b, logDeriv G (3 + t * I)).re| ≤ 2 * Real.arcsin r := by
  have hpos : ∀ t ∈ Set.Icc a b, 0 < (G (3 + t * I)).re := by
    intro t ht
    have h := Complex.abs_re_le_norm (G (3 + t * I) - 1)
    rw [Complex.sub_re, Complex.one_re] at h
    linarith [(abs_le.mp (le_trans h (hnear t ht))).1]
  have hne : ∀ t ∈ Set.Icc a b, G (3 + t * I) ≠ 0 := by
    intro t ht h
    have := hpos t ht
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hFc : ContinuousOn (fun t : ℝ => G (3 + t * I)) (Set.Icc a b) := fun t ht =>
    (ContinuousAt.comp (g := G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t ht).continuousAt LevinsonSize.continuous_three.continuousAt).continuousWithinAt
  have hF'c : ContinuousOn (fun t : ℝ => deriv G (3 + t * I) * I) (Set.Icc a b) := by
    intro t ht
    exact ((ContinuousAt.comp (g := deriv G) (f := fun t : ℝ => (3 + t * I : ℂ))
      (hGa t ht).deriv.continuousAt LevinsonSize.continuous_three.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have hslit : ∀ t ∈ Set.Icc a b, G (3 + t * I) ∈ Complex.slitPlane := fun t ht =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t ht))
  have hφc : ContinuousOn (fun t : ℝ => Complex.arg (G (3 + t * I))) (Set.Icc a b) := by
    intro t ht
    exact ContinuousAt.comp_continuousWithinAt (g := Complex.arg)
      (Complex.continuousAt_arg (hslit t ht)) (hFc t ht)
  have hφ : ∀ t ∈ Set.Icc a b, G (3 + t * I) =
      ‖G (3 + t * I)‖ * Complex.exp ((Complex.arg (G (3 + t * I)) : ℂ) * Complex.I) :=
    fun t _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun t : ℝ => G (3 + t * I))
    (F' := fun t : ℝ => deriv G (3 + t * I) * I)
    (φ := fun t : ℝ => Complex.arg (G (3 + t * I))) hab hFc
    (fun t ht => LevinsonSize.hasDerivAt_three_comp
      (hGa t (Set.Ioo_subset_Icc_self ht)).differentiableAt) hF'c hne hφc hφ
  have heq : (∫ t in a..b, deriv G (3 + t * I) * I / G (3 + t * I)) =
      ∫ t in a..b, logDeriv G (3 + t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im] at h
  rw [← h]
  have hb := abs_le.mp (abs_arg_le_arcsin hr (hnear b ⟨hab, le_rfl⟩))
  have ha := abs_le.mp (abs_arg_le_arcsin hr (hnear a ⟨le_rfl, hab⟩))
  rw [abs_le]
  constructor <;> linarith [ha.1, ha.2, hb.1, hb.2]

/-- **`V` near one on the right edge.** In the range of `DigammaBound.right_edge_ge`,
`‖V(3 + it) − 1‖ ≤ π²/6 − 1 + 1/100`. Its proof, ending at the triangle inequality. -/
theorem V_near_one (Q : ℝ[X]) (hQ0 : Q.eval 0 = 1) {B T t : ℝ} (hB : 0 < B)
    (hBr : ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
      1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
      T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
      ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B)
    (hT : 200 ≤ T) (hL : 8 + 400 * DigammaBound.KQ Q * B ≤ Real.log T)
    (ht : t ∈ Icc (T / 4) (2 * T)) :
    ‖V Q (Real.log T) (3 + t * I) - 1‖ ≤ Real.pi ^ 2 / 6 - 1 + 1 / 100 := by
  have hK := DigammaBound.KQ_nonneg Q
  have hL8 : 8 ≤ Real.log T := by nlinarith [mul_nonneg hK hB.le]
  have hLpos : 0 < Real.log T := by linarith
  set w : ℂ := 3 + t * I with hwdef
  have hwre : w.re = 3 := by simp [hwdef]
  have hwim : w.im = t := by simp [hwdef]
  have hw0 : 0 < w.re := by rw [hwre]; norm_num
  have hw1 : w ≠ 1 := by
    intro h; have := congrArg Complex.re h; rw [hwre, Complex.one_re] at this; norm_num at this
  have hpi2 : Real.pi ^ 2 / 6 ≤ 2 := by nlinarith [Real.pi_lt_d2, Real.pi_pos]
  have hd : DifferentiableOn ℂ (DigammaBound.H (Real.log T) w) (Metric.closedBall w 1) := by
    intro z hz
    rw [Metric.mem_closedBall, dist_eq_norm] at hz
    obtain ⟨hc1, hc2⟩ := abs_le.mp (DigammaBound.re_im_close hz).1
    rw [hwre] at hc1 hc2
    have hz1 : z ≠ 1 := by
      intro h; rw [h, Complex.one_re] at hc1; linarith
    exact (DigammaBound.differentiableAt_H _ w (by linarith) hz1).differentiableWithinAt
  have hM : ∀ z ∈ Metric.sphere w 1,
      ‖DigammaBound.H (Real.log T) w z‖ ≤ Real.pi ^ 2 / 6 * B := by
    intro z hz
    rw [Metric.mem_sphere, dist_eq_norm] at hz
    have hc := DigammaBound.re_im_close hz.le
    obtain ⟨hre1, hre2⟩ := abs_le.mp hc.1
    obtain ⟨him1, him2⟩ := abs_le.mp hc.2
    rw [hwre] at hre1 hre2
    rw [hwim] at him1 him2
    rw [DigammaBound.norm_H]
    have hr := hBr T (by linarith) z w (by linarith) (by linarith) (by rw [hwre]; norm_num)
      (by rw [hwre]; norm_num) (by linarith [ht.1]) (by linarith [ht.2])
      (by rw [hwim]; linarith [ht.1]) (by rw [hwim]; linarith [ht.2]) hc.2
    exact mul_le_mul (DigammaBound.zeta_norm_le_two (by linarith)) hr (by positivity)
      (by positivity)
  have hsub := DigammaBound.V_sub_le Q hLpos one_pos (by linarith) (by positivity) hw0 hw1 hd hM
  rw [Polynomial.coeff_zero_eq_eval_zero, hQ0, Complex.ofReal_one, one_mul, mul_one] at hsub
  have hsmall : DigammaBound.KQ Q * (Real.pi ^ 2 / 6 * B) / Real.log T ≤ 1 / 100 := by
    rw [div_le_iff₀ hLpos]
    have : DigammaBound.KQ Q * (Real.pi ^ 2 / 6 * B) ≤ DigammaBound.KQ Q * (2 * B) :=
      mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hpi2 hB.le) hK
    nlinarith [mul_nonneg hK hB.le]
  have hz := LevinsonSize.norm_G_sub_one_le (c := 0) le_rfl zero_le_one (s := 3 + t * I)
    (by simp)
  simp only [Complex.ofReal_zero, zero_mul, add_zero] at hz
  calc ‖V Q (Real.log T) w - 1‖
      = ‖(V Q (Real.log T) w - riemannZeta w) + (riemannZeta w - 1)‖ := by ring_nf
    _ ≤ ‖V Q (Real.log T) w - riemannZeta w‖ + ‖riemannZeta w - 1‖ := norm_add_le _ _
    _ ≤ 1 / 100 + (Real.pi ^ 2 / 6 - 1) := add_le_add (le_trans hsub hsmall) hz
    _ = Real.pi ^ 2 / 6 - 1 + 1 / 100 := by ring

/-- `r₀ = π²/6 − 1 + 1/100 < 1`. -/
theorem r0_lt_one : Real.pi ^ 2 / 6 - 1 + 1 / 100 < 1 := by
  nlinarith [Real.pi_lt_d2, Real.pi_pos]

/-- A zero of `V` on the line is a zero of `ζ`. -/
theorem V_line_ne {Q : ℝ[X]} (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (L t : ℝ) (hζ : riemannZeta ((1/2 : ℂ) + t * I) ≠ 0) :
    V Q L ((1/2 : ℂ) + t * I) ≠ 0 := by
  intro hV
  apply hζ
  have hG : Gammaℝ ((1/2 : ℂ) + t * I) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2
  apply (OperatorQ.zeta_line_zero_iff_W Q hQ hQh L t).mpr
  rw [W_eq_gammaR_mul_V Q L hG, hV, mul_zero, Complex.zero_re]

/-- At a height carrying no nontrivial zero, `ζ(1/2 + t i) ≠ 0`. -/
theorem zeta_line_ne_of_good {t : ℝ} (hg : ∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ t) :
    riemannZeta ((1/2 : ℂ) + t * I) ≠ 0 := by
  intro h0
  have hmem : ((1/2 : ℂ) + (t : ℂ) * I) ∈ NontrivialZeros := by
    refine ⟨?_, Set.mem_univ _, h0⟩
    rw [HardyZ.re_line]
    norm_num
  exact hg ⟨_, hmem⟩ (by simp)

/-- **The increment at good heights.** For `Q′` symmetric, `Q(1/2) ≠ 0`, `4 ≤ a < b` carrying
no nontrivial zero, `V = V Q L` with no zero right of the line in `[1/2, 3] × [a, b]` and
`‖V − 1‖ ≤ r < 1` on the right edge:
`D b − D a < (S b + h(b)/π) − (S a + h(a)/π) + 1 + 2 arcsin(r)/π`. -/
theorem increment_lt {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b r : ℝ} (ha : 4 ≤ a) (hab : a < b) (hr : r < 1)
    (hnear : ∀ t ∈ Icc a b, ‖V Q L (3 + t * I) - 1‖ ≤ r)
    (hfree : ∀ s : ℂ, 1/2 < s.re → s.re ≤ 3 → a ≤ s.im → s.im ≤ b → V Q L s ≠ 0)
    (hga : ∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ a) (hgb : ∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ b) :
    (Defect.defect b : ℝ) - (Defect.defect a : ℝ) <
      (Turing.S b + hEdge Q L b / Real.pi) - (Turing.S a + hEdge Q L a / Real.pi)
        + 1 + 2 * Real.arcsin r / Real.pi := by
  have hπ := Real.pi_pos
  have hζa := zeta_line_ne_of_good hga
  have hζb := zeta_line_ne_of_good hgb
  have hedge : ∀ c, a ≤ c → c ≤ b → riemannZeta ((1/2 : ℂ) + c * I) ≠ 0 →
      ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑c * I) ≠ 0 := by
    intro c hc1 hc2 hζc x hx
    rcases eq_or_lt_of_le hx.1 with h | h
    · rw [← h]
      push_cast
      exact V_line_ne hQ hQh L c hζc
    · exact hfree _ (by simpa using h) (by simpa using hx.2) (by simpa using hc1)
        (by simpa using hc2)
  have hBot := hedge a le_rfl hab.le hζa
  have hTop := hedge b hab.le le_rfl hζb
  have hRne : ∀ t ∈ Icc a b, V Q L (3 + t * I) ≠ 0 := by
    intro t ht h
    have := hnear t ht
    rw [h, zero_sub, norm_neg, norm_one] at this
    linarith
  -- no zero right of the line
  have hzre : ((1/2 : ℂ) + a * I).re = 1/2 := by simp
  have hzim : ((1/2 : ℂ) + a * I).im = a := by simp
  have hwre : ((3 : ℂ) + b * I).re = 3 := by simp
  have hwim : ((3 : ℂ) + b * I).im = b := by simp
  have hmemR : ∀ p, p ∈ Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) ↔
      1/2 ≤ p.re ∧ p.re ≤ 3 ∧ a ≤ p.im ∧ p.im ≤ b := by
    intro p
    rw [mem_Rect (by rw [hzre, hwre]; norm_num) (by rw [hzim, hwim]; exact hab.le), hzre, hzim,
      hwre, hwim]
  have hGa : AnalyticOnNhd ℂ (V Q L) (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) := by
    intro p hp
    have h := (hmemR p).mp hp
    exact analyticAt_V_upper Q L (by linarith [h.2.2.1])
  have hGz : V Q L ((1/2 : ℂ) + a * I) ≠ 0 := V_line_ne hQ hQh L a hζa
  have hfinM := Littlewood.order_ne_top hGa hGz
  have hC0 : Littlewood.countRight (V Q L) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) = 0 := by
    unfold Littlewood.countRight
    refine Finset.sum_eq_zero fun p hp => ?_
    split_ifs with hσ
    · exfalso
      have hpS := (divisor_support_rectangle_finite (V Q L) _ _).mem_toFinset.mp hp
      obtain ⟨hpR, hp0⟩ := (Littlewood.mem_support_divisor subset_rfl hGa hfinM p).mp hpS
      obtain ⟨-, h2, h3, h4⟩ := (hmemR p).mp hpR
      exact hfree p hσ h2 h3 h4 hp0
    · rfl
  have hcount := count_exact hQ hQh ha hab hBot hTop hζa hRne
  rw [hC0] at hcount
  have hRb := abs_le.mp (right_edge_le_arcsin hab.le
    (fun t ht => analyticAt_V_upper Q L (by simp; linarith [ht.1])) hr hnear)
  -- the defect at good heights
  have hNa := Defect.N_eq_allCount_of_no_zero_at hga
  have hNb := Defect.N_eq_allCount_of_no_zero_at hgb
  have hDa : (Defect.defect a : ℝ) = (allCount a : ℝ) - (lineCount a : ℝ) := by
    simp [Defect.defect]
  have hDb : (Defect.defect b : ℝ) = (allCount b : ℝ) - (lineCount b : ℝ) := by
    simp [Defect.defect]
  rw [hDa, hDb, ← hNa, ← hNb]
  unfold Turing.S hEdge
  set R := (∫ t in a..b, logDeriv (V Q L) (3 + ↑t * I)).re with hR
  set ea := (∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑a * I)).im with hea
  set eb := (∫ x in (1/2:ℝ)..3, logDeriv (V Q L) (↑x + ↑b * I)).im with heb
  have hRpi : -(2 * Real.arcsin r) / Real.pi ≤ R / Real.pi :=
    div_le_div_of_nonneg_right hRb.1 hπ.le
  have hsplit : ((Stage3.phaseTheta b - Stage3.phaseTheta a) + (ea - eb + R)) / Real.pi
      = Stage3.phaseTheta b / Real.pi - Stage3.phaseTheta a / Real.pi + ea / Real.pi
        - eb / Real.pi + R / Real.pi := by ring
  have hneg : -(2 * Real.arcsin r) / Real.pi = -(2 * Real.arcsin r / Real.pi) := by ring
  linarith [hcount, hsplit, hRpi, hneg]

/-- **The increment on a window.** For `Q′` symmetric, `Q(1/2) ≠ 0`, `Q(0) = 1` there is `T₁`
such that for `T ≥ T₁`, good heights `T/4 ≤ a < b ≤ 2T` and `V = V Q (log T)` with no zero right
of the line in `[1/2, 3] × [a, b]`, with `r₀ = π²/6 − 1 + 1/100`:
`D b − D a < (S b + h(b)/π) − (S a + h(a)/π) + 1 + 2 arcsin(r₀)/π`. -/
theorem increment_window {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) (hQ0 : Q.eval 0 = 1) :
    ∃ T₁ : ℝ, 200 ≤ T₁ ∧ ∀ {T a b : ℝ}, T₁ ≤ T → T / 4 ≤ a → a < b → b ≤ 2 * T →
      (∀ s : ℂ, 1/2 < s.re → s.re ≤ 3 → a ≤ s.im → s.im ≤ b → V Q (Real.log T) s ≠ 0) →
      (∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ a) → (∀ ρ : NontrivialZeros, (ρ : ℂ).im ≠ b) →
      (Defect.defect b : ℝ) - (Defect.defect a : ℝ) <
        (Turing.S b + hEdge Q (Real.log T) b / Real.pi)
          - (Turing.S a + hEdge Q (Real.log T) a / Real.pi)
          + 1 + 2 * Real.arcsin (Real.pi ^ 2 / 6 - 1 + 1 / 100) / Real.pi := by
  obtain ⟨B, hB, hBr⟩ := DigammaBound.gamma_ratio
  have hK := DigammaBound.KQ_nonneg Q
  refine ⟨200 + Real.exp (8 + 400 * DigammaBound.KQ Q * B),
    by linarith [Real.exp_pos (8 + 400 * DigammaBound.KQ Q * B)], ?_⟩
  intro T a b hT hTa hab hbT hfree hga hgb
  have hE := Real.exp_pos (8 + 400 * DigammaBound.KQ Q * B)
  have hT200 : 200 ≤ T := by linarith
  have hL : 8 + 400 * DigammaBound.KQ Q * B ≤ Real.log T := by
    have h := Real.log_le_log hE (show Real.exp (8 + 400 * DigammaBound.KQ Q * B) ≤ T by linarith)
    rwa [Real.log_exp] at h
  exact increment_lt hQ hQh (by linarith) hab r0_lt_one
    (fun t ht => V_near_one Q hQ0 hB hBr hT200 hL ⟨by linarith [ht.1], by linarith [ht.2]⟩)
    hfree hga hgb

/-- info: 'BasinChain.noRightZeros_one_of_rh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms noRightZeros_one_of_rh

/-- info: 'BasinChain.count_exact' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms count_exact

/-- info: 'BasinChain.abs_arg_le_arcsin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms abs_arg_le_arcsin

/-- info: 'BasinChain.right_edge_le_arcsin' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_edge_le_arcsin

/-- info: 'BasinChain.V_near_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms V_near_one

/-- info: 'BasinChain.increment_lt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms increment_lt

/-- info: 'BasinChain.increment_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms increment_window

end BasinChain

end
