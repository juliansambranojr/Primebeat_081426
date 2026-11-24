/-
LevinsonMollEdge — block S11 of `lean_stage3/design/stencil.md`, the mollifier's edge terms.
2026-11-24.

The edge terms of `LevinsonRight.levinson_right` for `f = G · ψ`, with `G = ζ + c ζ'`,
`0 ≤ c ≤ 1`, and the mollifier `ψ(s) = Σ_{h ∈ [1, M]} β h · h^(−s)`, `β 1 = 1`,
`‖β h‖ ≤ B` (the coefficient function is named `β`, since `b` is the top of the interval).

* The right edge, `Re s = X`. `‖ψ − 1‖ ≤ M B 2^(−X)` (the finite tail `h ∈ [2, M]`) and
  `‖G − 1‖ ≤ 8 · 2^(−X)` for `X ≥ 3` (the Dirichlet series of `LevinsonSize`, each term
  `n^(1−X) ≤ 2^(3−X) n^(−2)`). Hence `‖f − 1‖ ≤ δ(X) := 8/2^X · (1 + MB/2^X) + MB/2^X`
  (`tailDelta`), and `δ(X) ≤ 1/2` once `32 M B ≤ 2^X`. Then `Re f > 0` on the edge, `arg ∘ f` is
  a continuous argument, and `LevinsonTurn.lift_turn_eq_integral` turns
  `Re ∫_a^b logDeriv f (X + it) dt` into `arg f(X + ib) − arg f(X + ia)`, at most `π`.
  The log term is bounded pointwise: `|log ‖f‖| ≤ 2 δ(X)`, so `−∫_a^b log ‖f‖ ≤ (b − a) · ε(X)`
  with `ε(X) = 2 δ(X)`. This is the `(b − a) · ε(X)` form; the `O(1)` Dirichlet-series form
  of the log term is left open.
* The horizontal edges, height `T`, `σ ∈ [σ₀, X]`, `σ₀ ≥ 1/4`. Backlund's count on the disc
  of radius `X` about `X + iT`, scaled to the unit disc by `z ↦ X + iT + X z`; the generic
  Jensen count `real_zero_count_gen` (upstream `ZerosBound`) at `r = (4X − 1)/(4X)` (which
  reaches `Re = 1/4`) and `R = (8X − 1)/(8X)` (the growth disc, `Re ≥ 1/8`), with
  `1/log(R/r) ≤ 8X − 1`. The centre value `Re f(X + iT) ≥ 1/2` is the right-edge bound, so the
  same `X` serves both targets. Growth on `‖w − (X + iT)‖ ≤ X − 1/8`, for `2X ≤ T`:
  `‖ζ‖ ≤ 33 T` (upstream `ZetaAltFormula`, `Re ≥ 1/16`), `‖ζ'‖ ≤ 528 T` (Cauchy, radius `1/16`),
  `‖G‖ ≤ 561 T`, `‖ψ‖ ≤ M B`. One `Finset` of zeros of `Re f(x + iT)` on `(1/4, X)` serves
  every `σ`, through `ArgLegs.segment_im_integral_le` on `[σ, X]`.

  molli_norm_le         ‖β h‖ ≤ B, 0 ≤ Re s  ⊢ ‖ψ s‖ ≤ M B
  molli_sub_one_le      β 1 = 1, ‖β h‖ ≤ B, 1 ≤ M, Re s = X ≥ 0  ⊢ ‖ψ s − 1‖ ≤ M B / 2^X
  norm_G_sub_one_le_X   0 ≤ c ≤ 1, 3 ≤ X, Re s = X  ⊢ ‖ζ s + c ζ' s − 1‖ ≤ 8 / 2^X
  f_sub_one_le          the above  ⊢ ‖G s · ψ s − 1‖ ≤ tailDelta M B X
  molli_differentiable  ⊢ ψ entire
  f_analyticAt          w ≠ 1  ⊢ G ψ analytic at w
  tailDelta_le_half     1 ≤ M, 1 ≤ B, 32 M B ≤ 2^X  ⊢ tailDelta M B X ≤ 1/2
  log_norm_abs_le       ‖z − 1‖ ≤ δ ≤ 1/2  ⊢ |log ‖z‖| ≤ 2δ
  hasDerivAt_line_comp  f differentiable at X + it  ⊢ d/dt f(X + it) = f'(X + it) · i
  arg_term_le_of_pos    a ≤ b, f analytic on Re = X, Re f > 0 there
                          ⊢ |Re ∫_a^b logDeriv f (X + it) dt| ≤ π
  right_log_term_le     0 ≤ c ≤ 1, 1 ≤ M, β 1 = 1, ‖β h‖ ≤ B, 3 ≤ X, 32 M B ≤ 2^X, a ≤ b
                          ⊢ −∫_a^b log ‖f(X + it)‖ dt ≤ (b − a) · (2 tailDelta M B X)
  right_arg_term_le     same  ⊢ |Re ∫_a^b logDeriv f (X + it) dt| ≤ π
  right_terms_le        same, σ₀ ≤ X
                          ⊢ −∫_a^b log ‖f(X + it)‖ dt + (X − σ₀) · Re ∫_a^b logDeriv f (X + it) dt
                              ≤ (b − a) · (2 tailDelta M B X) + (X − σ₀) · π
  zeta_norm_le_sixteenth 1/16 ≤ Re u, 1 ≤ Im u  ⊢ ‖ζ u‖ ≤ 2 + 16‖u‖
  disc_facts_X          0 ≤ X, 0 ≤ T, ‖u − (X + iT)‖ ≤ d
                          ⊢ X − d ≤ Re u ∧ T − d ≤ Im u ∧ ‖u‖ ≤ d + X + T
  zeta_disc_X           1 ≤ X, 2X ≤ T, ‖u − (X + iT)‖ ≤ X − 1/16  ⊢ ‖ζ u‖ ≤ 33 T
  deriv_zeta_disc_X     1 ≤ X, 2X ≤ T, ‖w − (X + iT)‖ ≤ X − 1/8  ⊢ ‖ζ' w‖ ≤ 528 T
  G_disc_X              0 ≤ c ≤ 1, same  ⊢ ‖ζ w + c ζ' w‖ ≤ 561 T
  real_zero_count_gen   0 < r < R < 1, g differentiable on ‖z‖ < 11/10, 0 < m ≤ Re g 0,
                          ‖g‖ ≤ M on ‖z‖ ≤ R
                          ⊢ ∃ Z, (|x| ≤ r ∧ Re g x = 0 → x ∈ Z) ∧ |Z| ≤ log(M/m) / log(R/r)
  edge_le_gen           1 ≤ X, 2X ≤ T, F analytic off 1, 1/2 ≤ Re F(X + iT),
                          ‖F‖ ≤ Mf on ‖w − (X + iT)‖ ≤ X − 1/8, 1/4 ≤ σ ≤ X, F ≠ 0 on [σ, X] + iT
                          ⊢ |edgeH F X T σ| ≤ π ((8X − 1) log (2 Mf) + 1)
  horizontal_terms_le   0 ≤ c ≤ 1, 1 ≤ M, β 1 = 1, ‖β h‖ ≤ B, 3 ≤ X, 32 M B ≤ 2^X,
                          1/4 ≤ σ₀ ≤ X, 2X ≤ T, f ≠ 0 on [σ₀, X] + iT
                          ⊢ |∫_{σ₀}^X edgeH f X T σ dσ|
                              ≤ (X − σ₀) · π ((8X − 1)(log T + log M + log B + 8) + 1)

The trade-off in `X`: one `X` serves both targets, with `X ≥ 3` and `2^X ≥ 32 M B`
(`X₀ = 5 + log₂(M B)`; the statements carry `3 ≤ X` as well), at the price of `2X ≤ T`
and the factor `(8X − 1)(X − σ₀)` in the horizontal bound, and `(X − σ₀) π` in the right edge.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LevinsonRight
import Stage3.LevinsonEdge

namespace LevinsonMollEdge

open Complex MeasureTheory Set Littlewood
open scoped Interval

/-! ## The mollifier -/

/-- The mollifier `ψ(s) = Σ_{h ∈ [1, M]} β h · h^(−s)`. -/
noncomputable
def molli (M : ℕ) (β : ℕ → ℂ) (s : ℂ) : ℂ :=
  ∑ h ∈ Finset.Icc 1 M, β h * (h : ℂ) ^ (-s)

/-- The right-edge distance `δ(X) = 8/2^X · (1 + MB/2^X) + MB/2^X` of `G ψ` from `1`. -/
noncomputable
def tailDelta (M : ℕ) (B X : ℝ) : ℝ :=
  8 / (2 : ℝ) ^ X * (1 + M * B / (2 : ℝ) ^ X) + M * B / (2 : ℝ) ^ X

/-- **The mollifier right of `Re = 0`.** `‖ψ s‖ ≤ M B`. -/
theorem molli_norm_le {M : ℕ} {β : ℕ → ℂ} {B : ℝ} (hβ : ∀ h, ‖β h‖ ≤ B) {s : ℂ}
    (hs : 0 ≤ s.re) : ‖molli M β s‖ ≤ M * B := by
  unfold molli
  refine (norm_sum_le _ _).trans ?_
  have hterm : ∀ h ∈ Finset.Icc 1 M, ‖β h * (h : ℂ) ^ (-s)‖ ≤ B := by
    intro h hh
    have h1 : 1 ≤ h := (Finset.mem_Icc.mp hh).1
    rw [norm_mul, Complex.norm_natCast_cpow_of_pos (by omega), Complex.neg_re]
    have hle : (h : ℝ) ^ (-s.re) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by exact_mod_cast h1) (by linarith)
    have hB0 : 0 ≤ B := le_trans (norm_nonneg _) (hβ h)
    calc ‖β h‖ * (h : ℝ) ^ (-s.re) ≤ B * 1 :=
          mul_le_mul (hβ h) hle (by positivity) hB0
      _ = B := mul_one B
  refine (Finset.sum_le_sum hterm).trans ?_
  rw [Finset.sum_const, Nat.card_Icc, nsmul_eq_mul]
  simp

/-- **The mollifier's tail on `Re = X`.** `‖ψ s − 1‖ ≤ M B / 2^X`. -/
theorem molli_sub_one_le {M : ℕ} {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1)
    (hβ : ∀ h, ‖β h‖ ≤ B) (hM : 1 ≤ M) {X : ℝ} {s : ℂ} (hs : s.re = X) (hX : 0 ≤ X) :
    ‖molli M β s - 1‖ ≤ M * B / (2 : ℝ) ^ X := by
  unfold molli
  rw [Finset.Icc_eq_cons_Ioc hM, Finset.sum_cons]
  have h1 : β 1 * ((1 : ℕ) : ℂ) ^ (-s) = 1 := by simp [hβ1]
  rw [h1, add_sub_cancel_left]
  refine (norm_sum_le _ _).trans ?_
  have hB0 : 0 ≤ B := le_trans (norm_nonneg _) (hβ 1)
  have hterm : ∀ h ∈ Finset.Ioc 1 M, ‖β h * (h : ℂ) ^ (-s)‖ ≤ B / (2 : ℝ) ^ X := by
    intro h hh
    have h2 : 2 ≤ h := (Finset.mem_Ioc.mp hh).1
    rw [norm_mul, Complex.norm_natCast_cpow_of_pos (by omega), Complex.neg_re, hs]
    have hle : (h : ℝ) ^ (-X) ≤ (2 : ℝ) ^ (-X) :=
      Real.rpow_le_rpow_of_nonpos (by norm_num) (by exact_mod_cast h2) (by linarith)
    rw [Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2)] at hle
    calc ‖β h‖ * (h : ℝ) ^ (-X) ≤ B * ((2 : ℝ) ^ X)⁻¹ :=
          mul_le_mul (hβ h) hle (by positivity) hB0
      _ = B / (2 : ℝ) ^ X := by rw [div_eq_mul_inv]
  refine (Finset.sum_le_sum hterm).trans ?_
  rw [Finset.sum_const, Nat.card_Ioc, nsmul_eq_mul]
  have hcard : ((M - 1 : ℕ) : ℝ) ≤ M := by exact_mod_cast Nat.sub_le M 1
  have hq : 0 ≤ B / (2 : ℝ) ^ X := div_nonneg hB0 (by positivity)
  calc ((M - 1 : ℕ) : ℝ) * (B / (2 : ℝ) ^ X) ≤ M * (B / (2 : ℝ) ^ X) :=
        mul_le_mul_of_nonneg_right hcard hq
    _ = M * B / (2 : ℝ) ^ X := by ring

/-- The mollifier is entire. -/
theorem molli_differentiable (M : ℕ) (β : ℕ → ℂ) : Differentiable ℂ (molli M β) := by
  intro s
  unfold molli
  refine DifferentiableAt.fun_sum fun h hh => ?_
  have hne : (h : ℂ) ≠ 0 := by
    have := (Finset.mem_Icc.mp hh).1
    exact_mod_cast (by omega : h ≠ 0)
  exact ((differentiableAt_id.neg).const_cpow (Or.inl hne)).const_mul _

/-! ## `G` on `Re = X` -/

/-- **The Dirichlet tail of `ζ + c ζ'` on `Re s = X ≥ 3`.** `‖G(s) − 1‖ ≤ 8 / 2^X`. -/
theorem norm_G_sub_one_le_X {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {X : ℝ} (hX : 3 ≤ X)
    {s : ℂ} (hs : s.re = X) :
    ‖riemannZeta s + c * deriv riemannZeta s - 1‖ ≤ 8 / (2 : ℝ) ^ X := by
  have hs1 : 1 < s.re := by rw [hs]; linarith
  have habs : LSeries.abscissaOfAbsConv 1 < (s.re : EReal) := by
    rw [LSeries.abscissaOfAbsConv_one]; exact_mod_cast hs1
  have hA : HasSum (LSeries.term 1 s) (riemannZeta s) := by
    rw [← LSeries_one_eq_riemannZeta hs1]
    exact (LSeriesSummable_one_iff.mpr hs1).LSeriesHasSum
  have hB : HasSum (LSeries.term (LSeries.logMul 1) s) (LSeries (LSeries.logMul 1) s) :=
    (LSeriesSummable_logMul_of_lt_re habs).LSeriesHasSum
  have hH : HasSum (fun n : ℕ => LSeries.term 1 s n
      - (c : ℂ) * LSeries.term (LSeries.logMul 1) s n - (if n = 1 then (1 : ℂ) else 0))
      (riemannZeta s + c * deriv riemannZeta s - 1) := by
    rw [LevinsonSize.deriv_zeta_eq_LSeries hs1]
    have h := (hA.sub (hB.mul_left (c : ℂ))).sub (hasSum_ite_eq 1 (1 : ℂ))
    have hv : riemannZeta s + ↑c * -LSeries (LSeries.logMul 1) s - 1
        = riemannZeta s - ↑c * LSeries (LSeries.logMul 1) s - 1 := by ring
    rw [hv]
    exact h
  have hR : HasSum (fun n : ℕ => 8 / (2 : ℝ) ^ X * (1 / (n : ℝ) ^ 2 - (if n = 1 then (1 : ℝ) else 0)))
      (8 / (2 : ℝ) ^ X * (Real.pi ^ 2 / 6 - 1)) :=
    (hasSum_zeta_two.sub (hasSum_ite_eq 1 (1 : ℝ))).mul_left _
  have hle := hH.norm_le_of_bounded hR (fun n => ?_)
  · have hpi : Real.pi ^ 2 / 6 - 1 ≤ 1 := by nlinarith [Real.pi_lt_d2, Real.pi_gt_three]
    have hq : 0 ≤ 8 / (2 : ℝ) ^ X := by positivity
    calc _ ≤ 8 / (2 : ℝ) ^ X * (Real.pi ^ 2 / 6 - 1) := hle
      _ ≤ 8 / (2 : ℝ) ^ X * 1 := mul_le_mul_of_nonneg_left hpi hq
      _ = 8 / (2 : ℝ) ^ X := mul_one _
  rcases Nat.lt_or_ge n 2 with hn | hn
  · interval_cases n <;> simp [LSeries.term_def, LSeries.logMul]
  · have hn0 : n ≠ 0 := by omega
    have hn1 : n ≠ 1 := by omega
    have hnpos : (0 : ℝ) < n := by exact_mod_cast (show 0 < n by omega)
    have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn
    have hlogc : Complex.log (n : ℂ) = ((Real.log n : ℝ) : ℂ) := by
      exact Complex.natCast_log.symm
    have hval : LSeries.term 1 s n - (c : ℂ) * LSeries.term (LSeries.logMul 1) s n
        - (if n = 1 then (1 : ℂ) else 0)
        = ((1 - c * Real.log n : ℝ) : ℂ) / (n : ℂ) ^ s := by
      simp only [LSeries.term_def, LSeries.logMul, if_neg hn0, if_neg hn1, Pi.one_apply,
        hlogc]
      push_cast
      ring
    rw [hval, if_neg hn1, sub_zero, norm_div, Complex.norm_real, Real.norm_eq_abs,
      Complex.norm_natCast_cpow_of_pos (by omega), hs]
    have hlog0 : 0 ≤ Real.log n := Real.log_nonneg (by exact_mod_cast (show 1 ≤ n by omega))
    have hlog1 : Real.log n ≤ n - 1 := Real.log_le_sub_one_of_pos hnpos
    have hnum : |1 - c * Real.log n| ≤ n := by
      rw [abs_le]
      constructor <;> nlinarith
    -- `n^X = n^3 · n^(X−3)`, `2^X = 8 · 2^(X−3)`, `2^(X−3) ≤ n^(X−3)`
    have hnX : (n : ℝ) ^ X = (n : ℝ) ^ (3 : ℕ) * (n : ℝ) ^ (X - 3) := by
      rw [← Real.rpow_natCast, ← Real.rpow_add hnpos]
      norm_num
    have h2X : (2 : ℝ) ^ X = 8 * (2 : ℝ) ^ (X - 3) := by
      rw [show (8 : ℝ) = (2 : ℝ) ^ (3 : ℕ) by norm_num, ← Real.rpow_natCast,
        ← Real.rpow_add (by norm_num)]
      norm_num
    have huv : (2 : ℝ) ^ (X - 3) ≤ (n : ℝ) ^ (X - 3) :=
      Real.rpow_le_rpow (by norm_num) hn2 (by linarith)
    have hu : 0 < (2 : ℝ) ^ (X - 3) := by positivity
    rw [hnX, h2X]
    have key : 8 / (8 * (2 : ℝ) ^ (X - 3)) * (1 / (n : ℝ) ^ 2)
        = 1 / ((2 : ℝ) ^ (X - 3) * (n : ℝ) ^ 2) := by
      field_simp
      try ring
    rw [key, div_le_div_iff₀ (by positivity) (by positivity)]
    have hA0 : 0 ≤ |1 - c * Real.log n| := abs_nonneg _
    calc |1 - c * Real.log n| * ((2 : ℝ) ^ (X - 3) * (n : ℝ) ^ 2)
        ≤ n * ((2 : ℝ) ^ (X - 3) * (n : ℝ) ^ 2) :=
          mul_le_mul_of_nonneg_right hnum (by positivity)
      _ = (n : ℝ) ^ (3 : ℕ) * (2 : ℝ) ^ (X - 3) := by ring
      _ ≤ (n : ℝ) ^ (3 : ℕ) * (n : ℝ) ^ (X - 3) :=
          mul_le_mul_of_nonneg_left huv (by positivity)
      _ = 1 * ((n : ℝ) ^ (3 : ℕ) * (n : ℝ) ^ (X - 3)) := by ring

/-- **`G ψ` on `Re = X`.** `‖G s · ψ s − 1‖ ≤ tailDelta M B X`. -/
theorem f_sub_one_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X : ℝ} (hX : 3 ≤ X)
    {s : ℂ} (hs : s.re = X) :
    ‖(riemannZeta s + c * deriv riemannZeta s) * molli M β s - 1‖ ≤ tailDelta M B X := by
  have hG := norm_G_sub_one_le_X hc0 hc1 hX hs
  have hψ := molli_sub_one_le hβ1 hβ hM hs (by linarith)
  have hψn : ‖molli M β s‖ ≤ 1 + M * B / (2 : ℝ) ^ X := by
    calc ‖molli M β s‖ = ‖(molli M β s - 1) + 1‖ := by rw [sub_add_cancel]
      _ ≤ ‖molli M β s - 1‖ + ‖(1 : ℂ)‖ := norm_add_le _ _
      _ ≤ 1 + M * B / (2 : ℝ) ^ X := by rw [norm_one]; linarith
  have heq : (riemannZeta s + c * deriv riemannZeta s) * molli M β s - 1
      = (riemannZeta s + c * deriv riemannZeta s - 1) * molli M β s
        + (molli M β s - 1) := by ring
  rw [heq]
  unfold tailDelta
  have hprod := mul_le_mul hG hψn (norm_nonneg _) (by positivity)
  calc _ ≤ ‖(riemannZeta s + c * deriv riemannZeta s - 1) * molli M β s‖
          + ‖molli M β s - 1‖ := norm_add_le _ _
    _ ≤ 8 / (2 : ℝ) ^ X * (1 + M * B / (2 : ℝ) ^ X) + M * B / (2 : ℝ) ^ X := by
        rw [norm_mul]
        linarith

/-- **`δ(X) ≤ 1/2` once `32 M B ≤ 2^X`.** -/
theorem tailDelta_le_half {M : ℕ} {B X : ℝ} (hM : 1 ≤ M) (hB : 1 ≤ B)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) : tailDelta M B X ≤ 1 / 2 := by
  have hM1 : (1 : ℝ) ≤ M := by exact_mod_cast hM
  have hP : 1 ≤ (M : ℝ) * B := by nlinarith
  have hq : 0 < (2 : ℝ) ^ X := by positivity
  have h1 : 8 / (2 : ℝ) ^ X ≤ 1 / 4 := by
    rw [div_le_iff₀ hq]; nlinarith
  have h2 : (M : ℝ) * B / (2 : ℝ) ^ X ≤ 1 / 32 := by
    rw [div_le_iff₀ hq]; nlinarith
  have h2' : 0 ≤ (M : ℝ) * B / (2 : ℝ) ^ X := by positivity
  unfold tailDelta
  have h3 : 8 / (2 : ℝ) ^ X * (1 + M * B / (2 : ℝ) ^ X) ≤ 1 / 4 * (1 + 1 / 32) :=
    mul_le_mul h1 (by linarith) (by positivity) (by norm_num)
  linarith

/-! ## The right edge -/

/-- `|log ‖z‖| ≤ 2δ` when `‖z − 1‖ ≤ δ ≤ 1/2`. -/
theorem log_norm_abs_le {z : ℂ} {δ : ℝ} (hz : ‖z - 1‖ ≤ δ) (hδ : δ ≤ 1 / 2) :
    |Real.log ‖z‖| ≤ 2 * δ := by
  have hδ0 : 0 ≤ δ := le_trans (norm_nonneg _) hz
  have h1 : ‖z‖ ≤ 1 + δ := by
    calc ‖z‖ = ‖(z - 1) + 1‖ := by rw [sub_add_cancel]
      _ ≤ ‖z - 1‖ + ‖(1 : ℂ)‖ := norm_add_le _ _
      _ ≤ 1 + δ := by rw [norm_one]; linarith
  have h2 : 1 - δ ≤ ‖z‖ := by
    have := norm_sub_norm_le (1 : ℂ) z
    rw [norm_one, norm_sub_rev] at this
    linarith
  have hpos : 0 < ‖z‖ := by linarith
  rw [abs_le]
  constructor
  · have h3 := Real.log_le_sub_one_of_pos (inv_pos.mpr hpos)
    rw [Real.log_inv] at h3
    have h4 : ‖z‖⁻¹ ≤ 1 + 2 * δ := by
      rw [inv_eq_one_div, div_le_iff₀ hpos]
      nlinarith [mul_nonneg hδ0 (by linarith : (0 : ℝ) ≤ 1 - 2 * δ)]
    linarith
  · have h3 := Real.log_le_sub_one_of_pos hpos
    linarith

/-- The line `Re s = X` as a path, and its derivative `i`. -/
theorem hasDerivAt_line_comp {f : ℂ → ℂ} {X t : ℝ}
    (hf : DifferentiableAt ℂ f (↑X + ↑t * I)) :
    HasDerivAt (fun y : ℝ => f (↑X + ↑y * I)) (deriv f (↑X + ↑t * I) * I) t := by
  have hlin : HasDerivAt (fun w : ℂ => (X : ℂ) + w * I) I (t : ℂ) := by
    have := ((hasDerivAt_id (t : ℂ)).mul_const I).const_add (X : ℂ)
    simpa using this
  have hcomp : HasDerivAt (fun w : ℂ => f ((X : ℂ) + w * I))
      (deriv f (↑X + ↑t * I) * I) (t : ℂ) :=
    HasDerivAt.comp (t : ℂ) (h₂ := f) (h := fun w : ℂ => (X : ℂ) + w * I)
      hf.hasDerivAt hlin
  exact hcomp.comp_ofReal

/-- `G ψ` is analytic away from the pole. -/
theorem f_analyticAt (c : ℝ) (M : ℕ) (β : ℕ → ℂ) {w : ℂ} (hw : w ≠ 1) :
    AnalyticAt ℂ (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s) w :=
  (LevinsonEdge.G_analyticAt c hw).mul ((molli_differentiable M β).analyticAt w)

/-- **Term (a), the log term.** `−∫_a^b log ‖f(X + it)‖ dt ≤ (b − a) · 2 δ(X)`. -/
theorem right_log_term_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hab : a ≤ b) :
    -(∫ t in a..b, Real.log ‖(riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I)‖)
      ≤ (b - a) * (2 * tailDelta M B X) := by
  have hB : 1 ≤ B := by
    have := hβ 1
    rw [hβ1, norm_one] at this
    exact this
  have hδ := tailDelta_le_half hM hB hXMB
  have hpt : ∀ t : ℝ, ‖Real.log ‖(riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
      * molli M β (↑X + ↑t * I)‖‖ ≤ 2 * tailDelta M B X := by
    intro t
    rw [Real.norm_eq_abs]
    exact log_norm_abs_le (f_sub_one_le hc0 hc1 hM hβ1 hβ hX (by simp)) hδ
  have h := intervalIntegral.norm_integral_le_of_norm_le_const (a := a) (b := b)
    (fun t _ => hpt t)
  rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hab)] at h
  have h2 := neg_le_abs (∫ t in a..b, Real.log ‖(riemannZeta (↑X + ↑t * I)
    + c * deriv riemannZeta (↑X + ↑t * I)) * molli M β (↑X + ↑t * I)‖)
  linarith

/-- **The argument term, generic.** For `f` analytic on `Re s = X` with `Re f > 0` there:
`|Re ∫_a^b logDeriv f (X + it) dt| ≤ π`; the proof of `LevinsonSize.right_edge_le` at `X`. -/
theorem arg_term_le_of_pos {f : ℂ → ℂ} {X a b : ℝ} (hab : a ≤ b)
    (hfa : ∀ t : ℝ, AnalyticAt ℂ f (↑X + ↑t * I))
    (hpos : ∀ t : ℝ, 0 < (f (↑X + ↑t * I)).re) :
    |(∫ t in a..b, logDeriv f (↑X + ↑t * I)).re| ≤ Real.pi := by
  have hne : ∀ t ∈ Set.Icc a b, f (↑X + ↑t * I) ≠ 0 := by
    intro t _ h
    have := hpos t
    rw [h, Complex.zero_re] at this
    exact lt_irrefl _ this
  have hline : Continuous (fun t : ℝ => ((X : ℂ) + t * I)) := by fun_prop
  have hFcont : Continuous (fun t : ℝ => f (↑X + ↑t * I)) := by
    rw [continuous_iff_continuousAt]
    intro t
    exact ContinuousAt.comp (g := f) (f := fun t : ℝ => ((X : ℂ) + t * I))
      (hfa t).continuousAt hline.continuousAt
  have hFc : ContinuousOn (fun t : ℝ => f (↑X + ↑t * I)) (Set.Icc a b) :=
    hFcont.continuousOn
  have hF'c : ContinuousOn (fun t : ℝ => deriv f (↑X + ↑t * I) * I) (Set.Icc a b) := by
    intro t _
    exact ((ContinuousAt.comp (g := deriv f) (f := fun t : ℝ => ((X : ℂ) + t * I))
      (hfa t).deriv.continuousAt hline.continuousAt).mul
        continuousAt_const).continuousWithinAt
  have hslit : ∀ t : ℝ, f (↑X + ↑t * I) ∈ Complex.slitPlane := fun t =>
    Complex.mem_slitPlane_iff.mpr (Or.inl (hpos t))
  have hφc : ContinuousOn (fun t : ℝ => Complex.arg (f (↑X + ↑t * I))) (Set.Icc a b) := by
    intro t _
    exact (ContinuousAt.comp (g := Complex.arg) (f := fun t : ℝ => f (↑X + ↑t * I))
      (Complex.continuousAt_arg (hslit t)) hFcont.continuousAt).continuousWithinAt
  have hφ : ∀ t ∈ Set.Icc a b, f (↑X + ↑t * I) =
      ‖f (↑X + ↑t * I)‖ * Complex.exp ((Complex.arg (f (↑X + ↑t * I)) : ℂ) * Complex.I) :=
    fun t _ => (Complex.norm_mul_exp_arg_mul_I _).symm
  have h := LevinsonTurn.lift_turn_eq_integral (F := fun t : ℝ => f (↑X + ↑t * I))
    (F' := fun t : ℝ => deriv f (↑X + ↑t * I) * I)
    (φ := fun t : ℝ => Complex.arg (f (↑X + ↑t * I))) hab hFc
    (fun t _ => hasDerivAt_line_comp (hfa t).differentiableAt) hF'c hne hφc hφ
  have heq : (∫ t in a..b, deriv f (↑X + ↑t * I) * I / f (↑X + ↑t * I)) =
      ∫ t in a..b, logDeriv f (↑X + ↑t * I) * I := by
    refine intervalIntegral.integral_congr (fun t _ => ?_)
    simp only [logDeriv_apply]
    ring
  rw [heq, intervalIntegral.integral_mul_const, Complex.mul_I_im] at h
  rw [← h]
  have hb := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos b))
  have ha := Complex.abs_arg_lt_pi_div_two_iff.mpr (Or.inl (hpos a))
  rw [abs_lt] at ha hb
  rw [abs_le]
  constructor <;> linarith [ha.1, ha.2, hb.1, hb.2]

/-- **Term (b), the argument term.** `|Re ∫_a^b logDeriv f (X + it) dt| ≤ π`. -/
theorem right_arg_term_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hab : a ≤ b) :
    |(∫ t in a..b, logDeriv (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s)
      (↑X + ↑t * I)).re| ≤ Real.pi := by
  have hB : 1 ≤ B := by
    have := hβ 1
    rw [hβ1, norm_one] at this
    exact this
  have hδ := tailDelta_le_half hM hB hXMB
  refine arg_term_le_of_pos hab (fun t => f_analyticAt c M β ?_) (fun t => ?_)
  · intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  · have h1 := f_sub_one_le hc0 hc1 hM hβ1 hβ hX (s := ↑X + ↑t * I) (by simp)
    have h2 := Complex.abs_re_le_norm
      ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    show 0 < ((riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I)).re
    linarith [h2.1]

/-- **Target 1, the two right-edge terms of `levinson_right`.** For `X ≥ 3` with
`2^X ≥ 32 M B`: the log term is at most `(b − a) · ε(X)`, `ε(X) = 2 tailDelta M B X → 0`,
and the argument term at most `(X − σ₀) π`. -/
theorem right_terms_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X σ₀ a b : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hσX : σ₀ ≤ X) (hab : a ≤ b) :
    -(∫ t in a..b, Real.log ‖(riemannZeta (↑X + ↑t * I) + c * deriv riemannZeta (↑X + ↑t * I))
        * molli M β (↑X + ↑t * I)‖)
      + (X - σ₀) * (∫ t in a..b, logDeriv
          (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s) (↑X + ↑t * I)).re
      ≤ (b - a) * (2 * tailDelta M B X) + (X - σ₀) * Real.pi := by
  have h1 := right_log_term_le hc0 hc1 hM hβ1 hβ hX hXMB hab
  have h2 := right_arg_term_le hc0 hc1 hM hβ1 hβ hX hXMB hab
  have h3 := mul_le_mul_of_nonneg_left (le_trans (le_abs_self _) h2) (sub_nonneg.mpr hσX)
  linarith

/-! ## The horizontal edges: growth on the disc about `X + iT` -/

/-- **`ζ` right of `Re = 1/16`, above `Im = 1`.** `‖ζ u‖ ≤ 2 + 16‖u‖`; the proof of
`LevinsonEdge.zeta_norm_le` with the margin `1/16`. -/
theorem zeta_norm_le_sixteenth {u : ℂ} (hre : 1 / 16 ≤ u.re) (him : 1 ≤ u.im) :
    ‖riemannZeta u‖ ≤ 2 + 16 * ‖u‖ := by
  have hrepos : 0 < u.re := by linarith
  have hu1 : u ≠ 1 := by
    intro h; rw [h, Complex.one_im] at him; linarith
  have hsub : 1 ≤ ‖u - 1‖ := by
    have h := Complex.abs_im_le_norm (u - 1)
    rw [Complex.sub_im, Complex.one_im, sub_zero, abs_of_nonneg (by linarith)] at h
    linarith
  have leadingTerms : ‖(1 : ℂ) + 1 / (u - 1)‖ ≤ 2 := by
    have h4 : ‖(1 : ℂ) / (u - 1)‖ ≤ 1 := by
      rw [norm_div, norm_one, div_le_iff₀ (by linarith : (0:ℝ) < ‖u - 1‖)]
      linarith
    calc ‖(1 : ℂ) + 1 / (u - 1)‖ ≤ ‖(1 : ℂ)‖ + ‖(1 : ℂ) / (u - 1)‖ := norm_add_le _ _
      _ ≤ 2 := by rw [norm_one]; linarith
  have domBound : ∀ {x : ℝ}, x ∈ Set.Ioi (1 : ℝ) →
      |Int.fract x| * ‖(x : ℂ) ^ (-u - 1)‖ ≤ x ^ (-u.re - 1) := by
    intro x hu
    rw [Set.mem_Ioi] at hu
    rw [Complex.norm_cpow_eq_rpow_re_of_pos (by linarith)]
    simp only [Complex.sub_re, Complex.neg_re, Complex.one_re, Int.abs_fract]
    exact mul_le_of_le_one_left (Real.rpow_nonneg (by linarith) _) (Int.fract_lt_one x).le
  have domIntegral : Integrable (fun x : ℝ => x ^ (-u.re - 1))
      (volume.restrict (Set.Ioi 1)) := integrableOn_Ioi_rpow_of_lt (by linarith) zero_lt_one
  have hint : ‖∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
      ≤ 1 / u.re := by
    refine (MeasureTheory.norm_integral_le_integral_norm _).trans ?_
    have hI := integral_Ioi_rpow_of_lt (a := -u.re - 1) (by linarith) one_pos
    simp only [sub_add_cancel, Real.one_rpow, neg_div_neg_eq] at hI
    simp only [Complex.norm_mul, Complex.norm_real, Real.norm_eq_abs, ← hI]
    refine integral_mono_ae (domIntegral.mono' (((measurable_fract.abs).mul
      ((Complex.measurable_ofReal.pow_const _).norm)).aestronglyMeasurable) ?_) domIntegral
      (by filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx using domBound hx)
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
    rw [norm_mul, Real.norm_eq_abs, abs_abs, norm_norm]
    exact domBound hx
  have hmul : ‖u * ∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
      ≤ 16 * ‖u‖ := by
    rw [norm_mul]
    have hinv : (1 : ℝ) / u.re ≤ 16 := by
      rw [div_le_iff₀ hrepos]; linarith
    calc ‖u‖ * ‖∫ (v : ℝ) in Set.Ioi 1, ((Int.fract v : ℝ) : ℂ) * (v : ℂ) ^ (-u - 1)‖
        ≤ ‖u‖ * 16 := mul_le_mul_of_nonneg_left (hint.trans hinv) (norm_nonneg _)
      _ = 16 * ‖u‖ := by ring
  rw [ZetaAltFormula hrepos hu1]
  exact norm_sub_le_of_le leadingTerms hmul

/-- Coordinates on the disc about `X + iT`. -/
theorem disc_facts_X {X T d : ℝ} (hX : 0 ≤ X) (hT : 0 ≤ T) {u : ℂ}
    (hu : ‖u - (↑X + ↑T * I)‖ ≤ d) :
    X - d ≤ u.re ∧ T - d ≤ u.im ∧ ‖u‖ ≤ d + X + T := by
  have hre : (u - (↑X + ↑T * I)).re = u.re - X := by simp
  have him : (u - (↑X + ↑T * I)).im = u.im - T := by simp
  have h1 : |u.re - X| ≤ d := by
    rw [← hre]; exact le_trans (Complex.abs_re_le_norm _) hu
  have h2 : |u.im - T| ≤ d := by
    rw [← him]; exact le_trans (Complex.abs_im_le_norm _) hu
  obtain ⟨h1a, -⟩ := abs_le.mp h1
  obtain ⟨h2a, -⟩ := abs_le.mp h2
  have hc : ‖(X : ℂ) + (T : ℂ) * I‖ ≤ X + T := by
    refine le_trans (norm_add_le _ _) (le_of_eq ?_)
    rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Complex.norm_real,
      Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hX, abs_of_nonneg hT]
  have hn : ‖u‖ ≤ ‖u - (↑X + ↑T * I)‖ + ‖(X : ℂ) + (T : ℂ) * I‖ := by
    calc ‖u‖ = ‖(u - (↑X + ↑T * I)) + (↑X + ↑T * I)‖ := by rw [sub_add_cancel]
      _ ≤ _ := norm_add_le _ _
  refine ⟨by linarith, by linarith, by linarith⟩

/-- **`ζ` on the disc of radius `X − 1/16` about `X + iT`.** `‖ζ u‖ ≤ 33 T` for `1 ≤ X`,
`2X ≤ T`. -/
theorem zeta_disc_X {X T : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T) {u : ℂ}
    (hu : ‖u - (↑X + ↑T * I)‖ ≤ X - 1 / 16) : ‖riemannZeta u‖ ≤ 33 * T := by
  obtain ⟨h1, h2, h3⟩ := disc_facts_X (by linarith) (by linarith) hu
  have h := zeta_norm_le_sixteenth (u := u) (by linarith) (by linarith)
  linarith

/-- **`ζ'` on the disc of radius `X − 1/8` about `X + iT`.** Cauchy's estimate on the circle
of radius `1/16`: `‖ζ' w‖ ≤ 16 · 33 T = 528 T`. -/
theorem deriv_zeta_disc_X {X T : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T) {w : ℂ}
    (hw : ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8) : ‖deriv riemannZeta w‖ ≤ 528 * T := by
  have hdz : DifferentiableOn ℂ riemannZeta {1}ᶜ := fun z hz =>
    (differentiableAt_riemannZeta hz).differentiableWithinAt
  have hnear : ∀ u : ℂ, ‖u - w‖ ≤ 1 / 16 → ‖u - (↑X + ↑T * I)‖ ≤ X - 1 / 16 := by
    intro u hu
    calc ‖u - (↑X + ↑T * I)‖ = ‖(u - w) + (w - (↑X + ↑T * I))‖ := by
          rw [sub_add_sub_cancel]
      _ ≤ ‖u - w‖ + ‖w - (↑X + ↑T * I)‖ := norm_add_le _ _
      _ ≤ X - 1 / 16 := by linarith
  have hsub : Metric.closedBall w (1 / 16) ⊆ ({1}ᶜ : Set ℂ) := by
    intro u hu h1
    rw [Metric.mem_closedBall, Complex.dist_eq] at hu
    obtain ⟨-, him, -⟩ := disc_facts_X (by linarith) (by linarith) (hnear u hu)
    rw [Set.mem_singleton_iff] at h1
    rw [h1, Complex.one_im] at him
    linarith
  have hd : DiffContOnCl ℂ riemannZeta (Metric.ball w (1 / 16)) :=
    hdz.diffContOnCl_ball hsub
  have hC : ∀ u ∈ Metric.sphere w (1 / 16), ‖riemannZeta u‖ ≤ 33 * T := by
    intro u hu
    rw [mem_sphere_iff_norm] at hu
    exact zeta_disc_X hX hXT (hnear u hu.le)
  have h := Complex.norm_deriv_le_of_forall_mem_sphere_norm_le (by norm_num) hd hC
  have heq : (33 * T) / (1 / 16 : ℝ) = 528 * T := by ring
  rw [heq] at h
  exact h

/-- **`G` on the disc of radius `X − 1/8` about `X + iT`.** `‖ζ w + c ζ' w‖ ≤ 561 T`. -/
theorem G_disc_X {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {X T : ℝ} (hX : 1 ≤ X)
    (hXT : 2 * X ≤ T) {w : ℂ} (hw : ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8) :
    ‖riemannZeta w + c * deriv riemannZeta w‖ ≤ 561 * T := by
  have h1 := zeta_disc_X hX hXT (le_trans hw (by linarith))
  have h2 := deriv_zeta_disc_X hX hXT hw
  have h3 : c * ‖deriv riemannZeta w‖ ≤ 1 * (528 * T) :=
    mul_le_mul hc1 h2 (norm_nonneg _) zero_le_one
  calc ‖riemannZeta w + c * deriv riemannZeta w‖
      ≤ ‖riemannZeta w‖ + ‖(c : ℂ) * deriv riemannZeta w‖ := norm_add_le _ _
    _ = ‖riemannZeta w‖ + c * ‖deriv riemannZeta w‖ := by
        rw [norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hc0]
    _ ≤ 561 * T := by linarith

/-! ## The Jensen count at general radii -/

/-- **The Jensen count, general radii.** `LevinsonEdge.real_zero_count` with `5/6`, `7/8`
replaced by any `0 < r < R < 1`: the real zeros of `Re g` in `[−r, r]` lie in a `Finset` of
size at most `log (M/m) / log (R/r)`. -/
theorem real_zero_count_gen {g : ℂ → ℂ} {m M r R : ℝ} (hr0 : 0 < r) (hrR : r < R)
    (hR1 : R < 1)
    (hd : DifferentiableOn ℂ g (Metric.ball (0 : ℂ) (11 / 10))) (hm : 0 < m)
    (h0 : m ≤ (g 0).re) (hM : ∀ z : ℂ, ‖z‖ ≤ R → ‖g z‖ ≤ M) :
    ∃ Z : Finset ℝ, (∀ x : ℝ, |x| ≤ r → (g x).re = 0 → x ∈ Z) ∧
      (Z.card : ℝ) ≤ 1 / Real.log (R / r) * Real.log (M / m) := by
  have hr1 : r < 1 := lt_trans hrR hR1
  have hs0 := LevinsonEdge.symm_zero g
  have hs0ne : LevinsonEdge.symm g 0 ≠ 0 := by
    rw [hs0, Complex.ofReal_ne_zero]
    exact ne_of_gt (by linarith)
  have hsd := LevinsonEdge.symm_differentiableOn hd
  have han : AnalyticOnNhd ℂ (LevinsonEdge.model g) (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    exact (hsd.analyticAt (Metric.isOpen_ball.mem_nhds hz)).div_const
  have hball1 : Metric.closedBall (0 : ℂ) 1 ⊆ Metric.ball (0 : ℂ) (11 / 10) := by
    intro z hz
    rw [Metric.mem_closedBall] at hz
    rw [Metric.mem_ball]
    linarith
  have hanc : AnalyticOnNhd ℂ (LevinsonEdge.model g) (Metric.closedBall (0 : ℂ) 1) :=
    han.mono hball1
  have hf0 : LevinsonEdge.model g 0 = 1 := div_self hs0ne
  have hfin : (SetOfZeros 1 (LevinsonEdge.model g)).Finite := by
    by_contra hinf
    rw [Set.not_finite] at hinf
    have hsub : SetOfZeros 1 (LevinsonEdge.model g) ⊆ Metric.closedBall (0 : ℂ) 1 :=
      fun x hx => by simpa only [Metric.mem_closedBall, dist_zero_right] using hx.1
    obtain ⟨x, hxK, hacc⟩ :=
      hinf.exists_accPt_of_subset_isCompact (isCompact_closedBall (0 : ℂ) 1) hsub
    have hfeq : Set.EqOn (LevinsonEdge.model g) 0 (Metric.ball (0 : ℂ) (11 / 10)) := by
      refine AnalyticOnNhd.eqOn_zero_of_preconnected_of_mem_closure han
        Metric.isPreconnected_ball (z₀ := x) (hball1 hxK) ?_
      simp only [mem_closure_iff_clusterPt, ← accPt_principal_iff_clusterPt]
      exact hacc.mono (Filter.principal_mono.mpr fun _ h => h.2)
    have h0' := hfeq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 11 / 10))
    rw [hf0] at h0'
    simp at h0'
  have hg0 : ‖g 0‖ ≤ M := hM 0 (by rw [norm_zero]; linarith)
  have hmM : m ≤ M := le_trans h0 (le_trans (Complex.re_le_norm _) hg0)
  have hn0 : m ≤ ‖LevinsonEdge.symm g 0‖ := by
    rw [hs0, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by linarith)]
    exact h0
  have hbound : ∀ z : ℂ, ‖z‖ ≤ R → ‖LevinsonEdge.model g z‖ ≤ M / m := by
    intro z hz
    have hsz := LevinsonEdge.norm_symm_le hM hz
    have hpos : 0 < ‖LevinsonEdge.symm g 0‖ := by linarith
    simp only [LevinsonEdge.model, norm_div]
    rw [div_le_div_iff₀ hpos hm]
    exact mul_le_mul hsz hn0 hm.le (by linarith)
  have hZB := ZerosBound (B := M / m) (r := r) (R := R) (f := LevinsonEdge.model g)
    hr0 hr1 hrR hR1 hanc hf0 hfin hbound
  rw [Nat.cast_sum] at hZB
  refine ⟨((finiteSetOfZeros_mono hr1 hfin).toFinset).image Complex.re, ?_, ?_⟩
  · intro x hx hx0
    refine Finset.mem_image.mpr ⟨(x : ℂ), ?_, Complex.ofReal_re x⟩
    rw [Set.Finite.mem_toFinset]
    refine ⟨?_, ?_⟩
    · rw [Complex.norm_real, Real.norm_eq_abs]
      exact hx
    · show LevinsonEdge.symm g (x : ℂ) / LevinsonEdge.symm g 0 = 0
      rw [LevinsonEdge.symm_real, hx0, Complex.ofReal_zero, zero_div]
  · have hball : AnalyticOnNhd ℂ (LevinsonEdge.model g) (Metric.ball (0 : ℂ) 1) :=
      hanc.mono Metric.ball_subset_closedBall
    have hone : ∀ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset,
        1 ≤ analyticOrderNatAt (LevinsonEdge.model g) ρ := by
      intro ρ hρ
      rw [Set.Finite.mem_toFinset] at hρ
      obtain ⟨hn, hz⟩ := hρ
      have hAn : AnalyticAt ℂ (LevinsonEdge.model g) ρ := by
        refine hanc ρ ?_
        rw [Metric.mem_closedBall, dist_zero_right]
        linarith
      have hne0 : analyticOrderAt (LevinsonEdge.model g) ρ ≠ 0 :=
        hAn.analyticOrderAt_ne_zero.mpr hz
      have hnetop : analyticOrderAt (LevinsonEdge.model g) ρ ≠ ⊤ := by
        intro htop
        have hev : ∀ᶠ z in nhds ρ, LevinsonEdge.model g z = 0 := analyticOrderAt_eq_top.mp htop
        have hmem : ρ ∈ Metric.ball (0 : ℂ) 1 := by
          rw [Metric.mem_ball, dist_zero_right]; linarith
        have heq : Set.EqOn (LevinsonEdge.model g) 0 (Metric.ball (0 : ℂ) 1) :=
          hball.eqOn_zero_of_preconnected_of_eventuallyEq_zero Metric.isPreconnected_ball hmem
            (by filter_upwards [hev] with z hz using hz)
        have h0' := heq (Metric.mem_ball_self (by norm_num : (0:ℝ) < 1))
        rw [hf0] at h0'
        simp at h0'
      rw [Nat.one_le_iff_ne_zero]
      intro h
      rcases ENat.toNat_eq_zero.mp h with h | h
      · exact hne0 h
      · exact hnetop h
    have hcard1 : (((finiteSetOfZeros_mono hr1 hfin).toFinset.image Complex.re).card : ℝ)
        ≤ ((finiteSetOfZeros_mono hr1 hfin).toFinset.card : ℝ) := by
      exact_mod_cast Finset.card_image_le
    have hsum : (((finiteSetOfZeros_mono hr1 hfin).toFinset).card : ℝ)
        ≤ ∑ ρ ∈ (finiteSetOfZeros_mono hr1 hfin).toFinset,
            (analyticOrderNatAt (LevinsonEdge.model g) ρ : ℝ) := by
      rw [Finset.card_eq_sum_ones ((finiteSetOfZeros_mono hr1 hfin).toFinset)]
      push_cast
      refine Finset.sum_le_sum ?_
      intro ρ hρ
      exact_mod_cast hone ρ hρ
    linarith

/-! ## The horizontal edge at every `σ ∈ [1/4, X]` -/

/-- **The edge, with the growth as a hypothesis.** For `1 ≤ X`, `2X ≤ T`, `F` analytic off
`1`, `Re F(X + iT) ≥ 1/2`, `‖F‖ ≤ Mf` on `‖w − (X + iT)‖ ≤ X − 1/8`, `1/4 ≤ σ ≤ X` and
`F ≠ 0` on `[σ, X] + iT`: `|edgeH F X T σ| ≤ π ((8X − 1) log (2 Mf) + 1)`. -/
theorem edge_le_gen {F : ℂ → ℂ} {X T Mf σ : ℝ} (hX : 1 ≤ X) (hXT : 2 * X ≤ T)
    (hFa : ∀ w : ℂ, w ≠ 1 → AnalyticAt ℂ F w)
    (h0 : 1 / 2 ≤ (F (↑X + ↑T * I)).re)
    (hM : ∀ w : ℂ, ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8 → ‖F w‖ ≤ Mf)
    (hσ : 1 / 4 ≤ σ) (hσX : σ ≤ X)
    (hne : ∀ x ∈ Set.Icc σ X, F (↑x + ↑T * I) ≠ 0) :
    |edgeH F X T σ| ≤ Real.pi * ((8 * X - 1) * Real.log (2 * Mf) + 1) := by
  have hX0 : X ≠ 0 := by intro h; rw [h] at hX; norm_num at hX
  have hXpos : 0 < X := by linarith
  have h8 : 8 * X - 1 ≠ 0 := by intro h; linarith
  set r : ℝ := (4 * X - 1) / (4 * X) with hr
  set R : ℝ := (8 * X - 1) / (8 * X) with hR
  have hr0 : 0 < r := by rw [hr]; apply div_pos <;> linarith
  have hrR : r < R := by
    rw [hr, hR, div_lt_div_iff₀ (by linarith) (by linarith)]; nlinarith
  have hR1 : R < 1 := by rw [hR, div_lt_one (by linarith)]; linarith
  -- the scaled map `z ↦ X + iT + X z`
  have hd : DifferentiableOn ℂ (fun z : ℂ => F (↑X + ↑T * I + ↑X * z))
      (Metric.ball (0 : ℂ) (11 / 10)) := by
    intro z hz
    rw [Metric.mem_ball, dist_zero_right] at hz
    have hw : (↑X + ↑T * I + ↑X * z : ℂ) ≠ 1 := by
      intro h
      have him : (↑X + ↑T * I + ↑X * z : ℂ).im = T + X * z.im := by simp
      rw [h, Complex.one_im] at him
      have hzi := abs_le.mp (le_trans (Complex.abs_im_le_norm z) hz.le)
      have := mul_le_mul_of_nonneg_left hzi.1 hXpos.le
      linarith
    have hf : DifferentiableAt ℂ (fun z : ℂ => ↑X + ↑T * I + ↑X * z) z := by fun_prop
    exact (DifferentiableAt.comp (g := F) (f := fun z : ℂ => ↑X + ↑T * I + ↑X * z) z
      (hFa _ hw).differentiableAt hf).differentiableWithinAt
  have hg0 : 1 / 2 ≤ ((fun z : ℂ => F (↑X + ↑T * I + ↑X * z)) 0).re := by
    show 1 / 2 ≤ (F (↑X + ↑T * I + ↑X * 0)).re
    rw [mul_zero, add_zero]
    exact h0
  have hgM : ∀ z : ℂ, ‖z‖ ≤ R → ‖(fun z : ℂ => F (↑X + ↑T * I + ↑X * z)) z‖ ≤ Mf := by
    intro z hz
    refine hM _ ?_
    rw [show (↑X + ↑T * I + ↑X * z : ℂ) - (↑X + ↑T * I) = ↑X * z by ring, norm_mul,
      Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg hXpos.le]
    have hXR : X * R = X - 1 / 8 := by
      rw [hR]
      field_simp
      try ring
    have := mul_le_mul_of_nonneg_left hz hXpos.le
    linarith
  obtain ⟨Z', hZ'mem, hZ'card⟩ := real_zero_count_gen hr0 hrR hR1 hd (by norm_num) hg0 hgM
  have hdiv : Mf / (1 / 2 : ℝ) = 2 * Mf := by ring
  rw [hdiv] at hZ'card
  -- the zeros of `Re F(x + iT)` on `(σ, X)`
  have hZ : ∀ x ∈ Set.Ioo σ X, ((fun y : ℝ => F (↑y + ↑T * I)) x).re = 0 →
      x ∈ Z'.image (fun y : ℝ => X * y + X) := by
    intro x hx hx0
    have hy : X * ((x - X) / X) = x - X := by
      field_simp
      try ring
    refine Finset.mem_image.mpr ⟨(x - X) / X, hZ'mem _ ?_ ?_, by linarith⟩
    · rw [abs_le]
      have e1 : (x - X) / X + r = (x - 1 / 4) / X := by
        rw [hr]
        field_simp
        try ring
      have e2 : 0 ≤ (x - 1 / 4) / X := div_nonneg (by linarith [hx.1]) hXpos.le
      have e3 : (x - X) / X ≤ 0 := div_nonpos_of_nonpos_of_nonneg (by linarith [hx.2]) hXpos.le
      constructor <;> linarith
    · show (F (↑X + ↑T * I + ↑X * (((x - X) / X : ℝ) : ℂ))).re = 0
      have hc : (↑X + ↑T * I + ↑X * (((x - X) / X : ℝ) : ℂ) : ℂ) = (x : ℂ) + (T : ℂ) * I := by
        rw [← Complex.ofReal_mul, hy]
        push_cast
        ring
      rw [hc]
      exact hx0
  have hcard : ((Z'.image (fun y : ℝ => X * y + X)).card : ℝ) ≤ (Z'.card : ℝ) := by
    exact_mod_cast Finset.card_image_le
  -- `1 / log (R/r) ≤ 8X − 1`
  have hrRq0 : r / R = (8 * X - 2) / (8 * X - 1) := by
    rw [hr, hR, div_div_div_eq,
      div_eq_div_iff (mul_pos (by linarith) (by linarith)).ne' h8]
    ring
  have hrRq : r / R = 1 - 1 / (8 * X - 1) := by
    rw [hrRq0, eq_sub_iff_add_eq, ← add_div, div_eq_one_iff_eq h8]
    ring
  have hlogrR : Real.log (r / R) ≤ r / R - 1 :=
    Real.log_le_sub_one_of_pos (div_pos hr0 (by linarith))
  have hL : 1 / (8 * X - 1) ≤ Real.log (R / r) := by
    rw [show R / r = (r / R)⁻¹ from (inv_div r R).symm, Real.log_inv]
    linarith
  have hLpos : 0 < Real.log (R / r) := lt_of_lt_of_le (by
    apply div_pos one_pos; linarith) hL
  have hinv : 1 / Real.log (R / r) ≤ 8 * X - 1 := by
    rw [div_le_iff₀ hLpos]
    have e : (8 * X - 1) * (1 / (8 * X - 1)) = 1 := by
      field_simp
      try ring
    have := mul_le_mul_of_nonneg_left hL (by linarith : (0 : ℝ) ≤ 8 * X - 1)
    linarith
  have hMf : 1 / 2 ≤ Mf := by
    have h1 := hM (↑X + ↑T * I) (by rw [sub_self, norm_zero]; linarith)
    linarith [Complex.re_le_norm (F (↑X + ↑T * I))]
  have hlog0 : 0 ≤ Real.log (2 * Mf) := Real.log_nonneg (by linarith)
  have hcardZ : ((Z'.image (fun y : ℝ => X * y + X)).card : ℝ)
      ≤ (8 * X - 1) * Real.log (2 * Mf) := by
    have := mul_le_mul_of_nonneg_right hinv hlog0
    linarith
  -- Backlund's step on `[σ, X]`
  have hne1 : ∀ x : ℝ, (x : ℂ) + (T : ℂ) * I ≠ 1 := by
    intro x h
    have h2 : ((x : ℂ) + (T : ℂ) * I).im = (1 : ℂ).im := by rw [h]
    simp at h2
    linarith
  have hder : ∀ x ∈ Set.Icc σ X,
      HasDerivAt (fun y : ℝ => F ((y : ℂ) + (T : ℂ) * I))
        (deriv F ((x : ℂ) + (T : ℂ) * I)) x := by
    intro x _
    have hz : HasDerivAt (fun w : ℂ => w + (T : ℂ) * I) 1 ((x : ℝ) : ℂ) := by
      simpa using (hasDerivAt_id ((x : ℝ) : ℂ)).add_const ((T : ℂ) * I)
    have hcomp :=
      ((((hFa _ (hne1 x)).differentiableAt).hasDerivAt).comp ((x : ℝ) : ℂ) hz).comp_ofReal
    simpa [Function.comp] using hcomp
  have hcg : ContinuousOn (fun x : ℝ => F ((x : ℂ) + (T : ℂ) * I)) (Set.Icc σ X) :=
    fun x hx => ((hder x hx).continuousAt).continuousWithinAt
  have hc : ContinuousOn (fun x : ℝ => deriv F ((x : ℂ) + (T : ℂ) * I)
      / F ((x : ℂ) + (T : ℂ) * I)) (Set.Icc σ X) := by
    intro x hx
    have hf : ContinuousAt (fun y : ℝ => (y : ℂ) + (T : ℂ) * I) x := by fun_prop
    have h1 := ContinuousAt.comp (g := deriv F) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hFa _ (hne1 x)).deriv.continuousAt hf
    have h2 := ContinuousAt.comp (g := F) (f := fun y : ℝ => (y : ℂ) + (T : ℂ) * I)
      (hFa _ (hne1 x)).continuousAt hf
    exact (h1.div h2 (hne x hx)).continuousWithinAt
  have key := ArgLegs.segment_im_integral_le
    (g := fun x : ℝ => F ((x : ℂ) + (T : ℂ) * I))
    (g' := fun x : ℝ => deriv F ((x : ℂ) + (T : ℂ) * I))
    hσX hder hne hc hcg _ hZ
  have hgoal : edgeH F X T σ
      = (∫ x in σ..X, deriv F ((x : ℂ) + (T : ℂ) * I) / F ((x : ℂ) + (T : ℂ) * I)).im := by
    simp only [edgeH, logDeriv_apply]
  rw [hgoal]
  refine le_trans key (mul_le_mul_of_nonneg_left ?_ Real.pi_pos.le)
  linarith

/-- **Target 2, the horizontal edge terms of `levinson_right`.** For `X ≥ 3` with
`2^X ≥ 32 M B`, `1/4 ≤ σ₀ ≤ X`, `2X ≤ T`, and `f = G ψ` nonzero on `[σ₀, X] + iT`:
`|∫_{σ₀}^X edgeH f X T σ dσ| ≤ (X − σ₀) π ((8X − 1)(log T + log M + log B + 8) + 1)`. -/
theorem horizontal_terms_le {c : ℝ} (hc0 : 0 ≤ c) (hc1 : c ≤ 1) {M : ℕ} (hM : 1 ≤ M)
    {β : ℕ → ℂ} {B : ℝ} (hβ1 : β 1 = 1) (hβ : ∀ h, ‖β h‖ ≤ B) {X σ₀ T : ℝ} (hX : 3 ≤ X)
    (hXMB : 32 * M * B ≤ (2 : ℝ) ^ X) (hσ₀ : 1 / 4 ≤ σ₀) (hσX : σ₀ ≤ X) (hXT : 2 * X ≤ T)
    (hne : ∀ x ∈ Set.Icc σ₀ X, (riemannZeta (↑x + ↑T * I) + c * deriv riemannZeta (↑x + ↑T * I))
      * molli M β (↑x + ↑T * I) ≠ 0) :
    |∫ σ in σ₀..X, edgeH (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s)
        X T σ|
      ≤ (X - σ₀) * (Real.pi * ((8 * X - 1)
          * (Real.log T + Real.log M + Real.log B + 8) + 1)) := by
  have hB : 1 ≤ B := by
    have := hβ 1
    rw [hβ1, norm_one] at this
    exact this
  have hδ := tailDelta_le_half hM hB hXMB
  have hX1 : 1 ≤ X := by linarith
  have hT0 : 0 < T := by linarith
  have hM0 : (0 : ℝ) < M := by exact_mod_cast hM
  have hB0 : 0 < B := by linarith
  -- the centre value
  have h0 : 1 / 2 ≤ ((riemannZeta (↑X + ↑T * I) + c * deriv riemannZeta (↑X + ↑T * I))
      * molli M β (↑X + ↑T * I)).re := by
    have h1 := f_sub_one_le hc0 hc1 hM hβ1 hβ hX (s := ↑X + ↑T * I) (by simp)
    have h2 := Complex.abs_re_le_norm
      ((riemannZeta (↑X + ↑T * I) + c * deriv riemannZeta (↑X + ↑T * I))
        * molli M β (↑X + ↑T * I) - 1)
    rw [Complex.sub_re, Complex.one_re, abs_le] at h2
    linarith [h2.1]
  -- the growth
  have hgrowth : ∀ w : ℂ, ‖w - (↑X + ↑T * I)‖ ≤ X - 1 / 8 →
      ‖(riemannZeta w + c * deriv riemannZeta w) * molli M β w‖ ≤ 561 * T * M * B := by
    intro w hw
    have hG := G_disc_X hc0 hc1 hX1 hXT hw
    obtain ⟨hre, -, -⟩ := disc_facts_X (by linarith) hT0.le hw
    have hψ := molli_norm_le (M := M) hβ (s := w) (by linarith)
    rw [norm_mul]
    have := mul_le_mul hG hψ (norm_nonneg _) (by linarith)
    calc _ ≤ 561 * T * (M * B) := this
      _ = 561 * T * M * B := by ring
  -- the logarithm of the growth
  have hlog : Real.log (2 * (561 * T * M * B))
      ≤ Real.log T + Real.log M + Real.log B + 8 := by
    have e : 2 * (561 * T * M * B) = 1122 * T * M * B := by ring
    rw [e, Real.log_mul (mul_pos (mul_pos (by norm_num) hT0) hM0).ne' hB0.ne',
      Real.log_mul (mul_pos (by norm_num) hT0).ne' hM0.ne',
      Real.log_mul (by norm_num) hT0.ne']
    have h1122 : Real.log 1122 ≤ 8 := by
      have h1 : Real.log 1122 ≤ Real.log 2048 := Real.log_le_log (by norm_num) (by norm_num)
      have h2 : Real.log 2048 = 11 * Real.log 2 := by
        rw [show (2048 : ℝ) = 2 ^ (11 : ℕ) by norm_num, Real.log_pow]
        norm_num
      have h3 := Real.log_two_lt_d9
      linarith
    linarith
  have hpt : ∀ σ ∈ Ι σ₀ X,
      ‖edgeH (fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s) X T σ‖
        ≤ Real.pi * ((8 * X - 1) * (Real.log T + Real.log M + Real.log B + 8) + 1) := by
    intro σ hσ
    rw [Set.uIoc_of_le hσX] at hσ
    rw [Real.norm_eq_abs]
    have h := edge_le_gen (F := fun s => (riemannZeta s + c * deriv riemannZeta s) * molli M β s)
      (Mf := 561 * T * M * B) hX1 hXT (fun w hw => f_analyticAt c M β hw) h0 hgrowth
      (by linarith [hσ.1]) hσ.2 (fun x hx => hne x ⟨by linarith [hσ.1, hx.1], hx.2⟩)
    refine le_trans h (mul_le_mul_of_nonneg_left ?_ Real.pi_pos.le)
    have := mul_le_mul_of_nonneg_left hlog (by linarith : (0 : ℝ) ≤ 8 * X - 1)
    linarith
  have h := intervalIntegral.norm_integral_le_of_norm_le_const hpt
  rw [Real.norm_eq_abs, abs_of_nonneg (sub_nonneg.mpr hσX)] at h
  linarith

/-- info: 'LevinsonMollEdge.molli_sub_one_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms molli_sub_one_le

/-- info: 'LevinsonMollEdge.f_sub_one_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms f_sub_one_le

/-- info: 'LevinsonMollEdge.right_log_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_log_term_le

/-- info: 'LevinsonMollEdge.right_arg_term_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_arg_term_le

/-- info: 'LevinsonMollEdge.right_terms_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms right_terms_le

/-- info: 'LevinsonMollEdge.real_zero_count_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms real_zero_count_gen

/-- info: 'LevinsonMollEdge.edge_le_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms edge_le_gen

/-- info: 'LevinsonMollEdge.horizontal_terms_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms horizontal_terms_le

end LevinsonMollEdge
