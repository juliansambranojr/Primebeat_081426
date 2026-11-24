/-
LevinsonCount — block S11 of `lean_stage3/design/stencil.md`, step 1 assembled. 2026-11-24.

Levinson's count on the line, assembled from steps 1a–1d. With `G = ζ + c ζ'`,
`0 ≤ c ≤ 1`, `4 ≤ a < b`, and `G` nonzero on the border of the rectangle with corners
`1/2 + a i` and `3 + b i`, a continuous argument `φ` of `LevinsonArg.lineF c = Gammaℝ · G`
along `[1/2 + a i, 1/2 + b i]` exists (`LevinsonArg.exists_arg_lift`), and it turns by

  φ b − φ a = Γpart + Gpart                              (`LevinsonTurn.lineF_turn_eq`)
  Gpart = −2π countG + horiz a − horiz b + right         (`LevinsonTurn.G_turn_eq`, X = 3)

with `|right| ≤ π` (`LevinsonSize.right_edge_le`), `|horiz T| ≤ 21π log T + 133π`
(`LevinsonEdge.horizontal_edge_le`, at `T = a` and `T = b`, `log a ≤ log b`), and
`Γpart ≥ π (N b − N a) − π (30 log b + 150)` (`LevinsonSize.gamma_part_count_le_gt_two`).
So `φ b − φ a ≥ π Q` with `Q = (N b − N a) − 2 countG − (72 log b + 417)`. With
`k = ⌊max 0 Q⌋₊`, `k π ≤ |φ b − φ a|`, and `LevinsonArg.lineCount_ge_arg` gives
`k ≤ lineCount b`; the floor costs at most `1`, so the constant is `418`.

The avoidance hypotheses (no zero of `G` on the border, the real factor nonzero on the
segment) stay hypotheses here.

  G_analyticOnNhd_rect    4 ≤ a ≤ b
                            ⊢ AnalyticOnNhd ℂ (ζ + c ζ') (Rectangle (1/2 + a i) (3 + b i))
  left_mem_border         a ≤ b, t ∈ [a, b]  ⊢ 1/2 + t i ∈ RectangleBorder (1/2 + a i) (3 + b i)
  bottom_mem_border       a ≤ b, x ∈ [1/2, 3]  ⊢ x + a i ∈ RectangleBorder (1/2 + a i) (3 + b i)
  top_mem_border          a ≤ b, x ∈ [1/2, 3]  ⊢ x + b i ∈ RectangleBorder (1/2 + a i) (3 + b i)
  levinson_count          0 ≤ c ≤ 1, 4 ≤ a < b,
                            ζ + c ζ' ≠ 0 on RectangleBorder (1/2 + a i) (3 + b i),
                            1 − c · Re(Gammaℝ'/Gammaℝ)(1/2 + t i) ≠ 0 for t ∈ [a, b]
                            ⊢ (N b − N a)
                                − 2 · countRight (ζ + c ζ') (1/2 + a i) (3 + b i) (1/2)
                                − (72 log b + 418) ≤ lineCount b

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonEdge

namespace LevinsonCount

open Complex LineCount

/-- `ζ + c ζ'` is analytic on the rectangle with corners `1/2 + a i`, `3 + b i`, `4 ≤ a ≤ b`:
every point has imaginary part at least `4`, so it avoids the pole. -/
theorem G_analyticOnNhd_rect (c : ℝ) {a b : ℝ} (ha : 4 ≤ a) (hab : a ≤ b) :
    AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I)) := by
  intro p hp
  have hre : ((1/2 : ℂ) + a * I).re ≤ ((3 : ℂ) + b * I).re := by simp; norm_num
  have him : ((1/2 : ℂ) + a * I).im ≤ ((3 : ℂ) + b * I).im := by simp; exact hab
  have h := (mem_Rect hre him p).mp hp
  have hpim : (4 : ℝ) ≤ p.im := by
    have h3 := h.2.2.1
    simp at h3
    linarith
  have hp1 : p ≠ 1 := by
    intro h1
    rw [h1, Complex.one_im] at hpim
    linarith
  exact LevinsonEdge.G_analyticAt c hp1

/-- The left edge lies on the border. -/
theorem left_mem_border {a b t : ℝ} (ht : t ∈ Set.Icc a b) :
    ((1/2 : ℂ) + t * I) ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) := by
  rw [RectangleBorder]
  left; left; right
  rw [mem_reProdIm]
  refine ⟨by simp, ?_⟩
  have hab : a ≤ b := le_trans ht.1 ht.2
  simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
    Complex.I_re, Complex.I_im]
  rw [Set.uIcc_of_le (by norm_num; exact hab)]
  constructor <;> norm_num <;> linarith [ht.1, ht.2]

/-- The bottom edge lies on the border. -/
theorem bottom_mem_border {a b x : ℝ} (hx : x ∈ Set.Icc (1/2 : ℝ) 3) :
    ((x : ℂ) + a * I) ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) := by
  rw [RectangleBorder]
  left; left; left
  rw [mem_reProdIm]
  refine ⟨?_, by simp⟩
  simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
    Complex.I_re, Complex.I_im]
  rw [Set.uIcc_of_le (by norm_num)]
  constructor <;> norm_num <;> linarith [hx.1, hx.2]

/-- The top edge lies on the border. -/
theorem top_mem_border {a b x : ℝ} (hx : x ∈ Set.Icc (1/2 : ℝ) 3) :
    ((x : ℂ) + b * I) ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) := by
  rw [RectangleBorder]
  left; right
  rw [mem_reProdIm]
  refine ⟨?_, by simp⟩
  simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
    Complex.I_re, Complex.I_im]
  rw [Set.uIcc_of_le (by norm_num)]
  constructor <;> norm_num <;> linarith [hx.1, hx.2]

/-- **S11 step 1, assembled: Levinson's count.** For `0 ≤ c ≤ 1`, `4 ≤ a < b`,
`G = ζ + c ζ'` nonzero on the border of the rectangle with corners `1/2 + a i` and
`3 + b i`, and the real factor `1 − c · Re(Gammaℝ'/Gammaℝ)` nonzero along the segment
`[1/2 + a i, 1/2 + b i]`: the zeros of `ζ` on the line up to height `b`, with order,
number at least `(N b − N a) − 2 · (zeros of G in the rectangle, with order)
− (72 log b + 418)`. -/
theorem levinson_count {c a b : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) (ha : 4 ≤ a) (hab : a < b)
    (hB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I),
      riemannZeta p + c * deriv riemannZeta p ≠ 0)
    (hfac : ∀ t ∈ Set.Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
          ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 418) ≤ (lineCount b : ℝ) := by
  set C := Littlewood.countRight (fun s => riemannZeta s + c * deriv riemannZeta s)
    ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2) with hC
  have hπ : 0 < Real.pi := Real.pi_pos
  -- the left edge: `G ≠ 0`, so `lineF c ≠ 0`
  have hneL : ∀ t ∈ Set.Icc a b,
      riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I) ≠ 0 :=
    fun t ht => hB _ (left_mem_border ht)
  have hneF : ∀ t ∈ Set.Icc a b, LevinsonArg.lineF c t ≠ 0 := by
    intro t ht
    unfold LevinsonArg.lineF
    exact mul_ne_zero (Gammaℝ_ne_zero_of_re_pos (LevinsonLine.line_facts t).2.2) (hneL t ht)
  -- step 1: the lift
  obtain ⟨φ, hφc, hφ⟩ := LevinsonArg.exists_arg_lift hab.le
    (LevinsonArg.continuous_lineF c).continuousOn hneF
  -- step 2: the split
  have hturn := LevinsonTurn.lineF_turn_eq hab.le hneL hφc hφ
  -- step 3: the rectangle, at `X = 3`
  have hcast : ((3 : ℝ) : ℂ) = (3 : ℂ) := by norm_num
  have hGa : AnalyticOnNhd ℂ (fun s => riemannZeta s + c * deriv riemannZeta s)
      (Rectangle ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I)) := by
    rw [hcast]; exact G_analyticOnNhd_rect c ha hab.le
  have hB3 : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) (((3 : ℝ) : ℂ) + b * I),
      riemannZeta p + c * deriv riemannZeta p ≠ 0 := by
    rw [hcast]; exact hB
  have hG := LevinsonTurn.G_turn_eq (G := fun s => riemannZeta s + c * deriv riemannZeta s)
    (X := 3) (by norm_num) hab hGa hB3
  rw [hcast] at hG
  -- step 4: the sizes
  have hR := abs_le.mp (LevinsonSize.right_edge_le hc0 hc1 hab.le)
  have hHa := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0 hc1 ha
    (fun x hx => hB _ (bottom_mem_border hx)))
  have hHb := abs_le.mp (LevinsonEdge.horizontal_edge_le hc0 hc1 (by linarith)
    (fun x hx => hB _ (top_mem_border hx)))
  have hΓ := abs_le.mp (LevinsonSize.gamma_part_count_le_gt_two (by linarith) hab.le)
  have hlog : Real.log a ≤ Real.log b := Real.log_le_log (by linarith) hab.le
  have hlogπ : 21 * Real.pi * Real.log a ≤ 21 * Real.pi * Real.log b :=
    mul_le_mul_of_nonneg_left hlog (by positivity)
  -- step 5: the turning is at least `π Q`
  set Q := (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 417) with hQ
  have hdiff : Real.pi * Q ≤ φ b - φ a := by
    have e : Real.pi * Q = Real.pi * (riemannZeta.N b - riemannZeta.N a)
        - 2 * Real.pi * C - (72 * Real.pi * Real.log b + 417 * Real.pi) := by
      rw [hQ]; ring
    rw [e]
    linarith [hR.1, hHa.2, hHb.1, hΓ.1, hlogπ, hturn, hG]
  -- step 6: the floor
  set k : ℕ := ⌊max 0 Q⌋₊ with hk_def
  have hkle : (k : ℝ) ≤ max 0 Q := Nat.floor_le (le_max_left _ _)
  have hklt : max 0 Q < (k : ℝ) + 1 := Nat.lt_floor_add_one _
  have hmax : max 0 Q * Real.pi ≤ |φ b - φ a| := by
    rcases le_total Q 0 with h | h
    · rw [max_eq_left h, zero_mul]; exact abs_nonneg _
    · rw [max_eq_right h]
      linarith [le_abs_self (φ b - φ a)]
  have hk : (k : ℝ) * Real.pi ≤ |φ b - φ a| :=
    le_trans (mul_le_mul_of_nonneg_right hkle hπ.le) hmax
  have hcount := LevinsonArg.lineCount_ge_arg (by linarith) hab.le le_rfl hfac hφc hφ hk
  have hcountR : (k : ℝ) ≤ (lineCount b : ℝ) := by exact_mod_cast hcount
  have hQmax : Q ≤ max 0 Q := le_max_right _ _
  have e2 : (riemannZeta.N b - riemannZeta.N a) - 2 * C - (72 * Real.log b + 418) = Q - 1 := by
    rw [hQ]; ring
  rw [e2]
  linarith

/-- info: 'LevinsonCount.G_analyticOnNhd_rect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms G_analyticOnNhd_rect

/-- info: 'LevinsonCount.levinson_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms levinson_count

end LevinsonCount
