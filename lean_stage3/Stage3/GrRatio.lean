/-
GrRatio — block S13 of `lean_stage3/design/stencil.md`, B4, the gamma ratio. 2026-11-25.

Pins: `PINS.md` § Current, "B4, the gamma ratio".

Discharges `MeanQ.StmtGrRatio n` for every `n`: for `T ≥ 16`, `i ≤ n`, `σ ∈ [1/4, 1]`,
`t ∈ [T/4, 2T]`, `‖(−1/L)^i grR i (σ + t i) − (−1/2)^i‖ ≤ C/L`, `L = log T`.

The device of `DigammaBoundIdentity`: with `a = L/2` and
`h_w(z) = Gammaℝ(z)/Gammaℝ(w) · e^{−a(z − w)}`, exactly `Gammaℝ = Gammaℝ(w) · h_w · e^{a(· − w)}`
(`Gammaℝ_eq`), so by Leibniz (`grR_eq`)

  `grR i w = Σ_j C(i,j) a^{i−j} h_w^{(j)}(w)`,
  `(−1/L)^i grR i w − (−1/2)^i = Σ_{j ≥ 1} C(i,j) (−1/2)^{i−j} (−1/L)^j h_w^{(j)}(w)`

(`(−1/L)·(L/2) = −1/2`, `h_w(w) = 1`). No derivative of the digamma enters.

**Sizes.** On the circle of radius `1/8` about `w`, `‖h_w‖ ≤ B` by `gamma_ratio8` (the tree's
`DigammaBoundSize.gamma_ratio` with the real-part floor lowered from `1/4` to `1/8`, since
the circle about `σ = 1/4` reaches `Re = 1/8`). Cauchy's estimate gives
`‖h_w^{(j)}(w)‖ ≤ j! B 8^j`, `8` fixed, so the `j`-th term is `C(i,j) j! B 8^j / L^j ≤ (…)/L`
for `j ≥ 1`, `L ≥ 1`: the radius does not shrink with `T`, and no factor growing with `T` is
lost. Numeric check before proving (scratchpad `grratio/check.py`, mpmath, `T = 10², 10⁴, 10⁸`,
`i ≤ 4`): `L·‖(−1/L)^i grR i − (−1/2)^i‖ ≤ 1.80`, and `‖h_w‖ ≤ 1.26` on the circles, flat in `T`.

  | name                 | statement                                                          | status |
  |----------------------|--------------------------------------------------------------------|--------|
  | `gErr_le16`          | `r ∈ [1/16, 7/2]` ⊢ `gErr r ≤ 110`                                   | PROVED |
  | `gamma_ratio8`       | `gamma_ratio` on `Re ∈ [1/8, 7]`                                     | PROVED |
  | `hw`                 | `h_w(z) = Gammaℝ z / Gammaℝ w · e^{−(L/2)(z − w)}`                    | def    |
  | `Gammaℝ_eq`          | `Gammaℝ w ≠ 0` ⊢ `Gammaℝ = fun z => Gammaℝ w · (h_w z · e^{(L/2)(z−w)})` | PROVED |
  | `grR_eq`             | `0 < Re w` ⊢ `grR i w = Σ_j C(i,j) h_w^{(j)}(w) (L/2)^{i−j}`           | PROVED |
  | `grR_sub`            | `L ≠ 0` ⊢ `(−1/L)^i grR i w − (−1/2)^i = Σ_{j<i} C(i,j+1)(−1/2)^{i−j−1}(−1/L)^{j+1} h_w^{(j+1)}(w)` | PROVED |
  | `stmtGrRatio_holds`  | `MeanQ.StmtGrRatio n`                                               | PROVED |
  | `window_V_lt_half'`  | `MeanQ.window_V_lt_half` without `hG`                               | PROVED |
  | `mollMeanV_long'`    | `MeanQ.mollMeanV_long` without `hG`                                 | PROVED |

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MeanQ
import Stage3.DigammaBoundSize

noncomputable section

namespace GrRatio

open Complex Polynomial MeasureTheory Metric Filter Topology ApproxFE TwistedMoment Operator
  DiagMainStmt DiagonalO OffDiagClose Unsmooth

/-! ### `gamma_ratio` with the real-part floor at `1/8` -/

/-- The Stirling error is bounded on `[1/16, 7/2]`. -/
theorem gErr_le16 {r : ℝ} (h1 : 1 / 16 ≤ r) (h2 : r ≤ 7 / 2) : ApproxBounds.gErr r ≤ 110 := by
  unfold ApproxBounds.gErr
  have hr : 0 < r := by linarith
  have ha : |r - 1 / 2| ≤ 3 := by rw [abs_le]; constructor <;> linarith
  have hinv : 1 / r ≤ 16 := by rw [div_le_iff₀ hr]; linarith
  have hlog : |Real.log r| ≤ 16 := by
    rw [abs_le]
    constructor
    · have h := Real.log_le_sub_one_of_pos (inv_pos.mpr hr)
      rw [Real.log_inv] at h
      have : r⁻¹ ≤ 16 := by rw [inv_eq_one_div]; exact hinv
      linarith
    · have := Real.log_le_sub_one_of_pos hr
      linarith
  have hl2 : Real.log 2 ≤ 1 := by have := Real.log_two_lt_d9; linarith
  have hl20 : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  have hb : 0 ≤ 2 + 1 / r + |Real.log r| + Real.log 2 := by positivity
  have hm := mul_le_mul ha
    (show 2 + 1 / r + |Real.log r| + Real.log 2 ≤ 2 + 16 + 16 + 1 by linarith) hb (by norm_num)
  linarith

/-- `log Γ` is bounded on `[1/16, 7/2]`. -/
theorem logGamma_bound16 : ∃ C : ℝ, ∀ r ∈ Set.Icc (1 / 16 : ℝ) (7 / 2),
    |Real.log (Real.Gamma r)| ≤ C := by
  have hc : ContinuousOn (fun r => Real.log (Real.Gamma r)) (Set.Icc (1 / 16 : ℝ) (7 / 2)) := by
    intro r hr
    have hr0 : 0 < r := by linarith [hr.1]
    have hd : DifferentiableAt ℝ Real.Gamma r := Real.differentiableAt_Gamma (fun m h => by
      have : (0 : ℝ) ≤ m := Nat.cast_nonneg m
      linarith)
    exact (hd.continuousAt.log (Real.Gamma_pos_of_pos hr0).ne').continuousWithinAt
  obtain ⟨C, hC⟩ := isCompact_Icc.exists_bound_of_continuousOn hc
  exact ⟨C, fun r hr => by simpa [Real.norm_eq_abs] using hC r hr⟩

/-- **The ratio of `Gammaℝ` at nearby heights, with the shift taken out**, on `Re ∈ [1/8, 7]`. -/
theorem gamma_ratio8 : ∃ B : ℝ, 0 < B ∧ ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
    1 / 8 ≤ z.re → z.re ≤ 7 → 1 / 8 ≤ w.re → w.re ≤ 7 →
    T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
    ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B := by
  obtain ⟨C, hC⟩ := logGamma_bound16
  refine ⟨Real.exp (2 * |C| + 264), Real.exp_pos _, ?_⟩
  intro T hT z w hz1 hz2 hw1 hw2 hzy1 hzy2 hwy1 hwy2 hzw
  have hzr : 0 < z.re := by linarith
  have hwr : 0 < w.re := by linarith
  have hGz : 0 < ‖Gammaℝ z‖ := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hzr)
  have hGw : 0 < ‖Gammaℝ w‖ := norm_pos_iff.mpr (Gammaℝ_ne_zero_of_re_pos hwr)
  have ez := abs_le.mp (ApproxBounds.log_norm_Gammaℝ_approx hzr)
  have ew := abs_le.mp (ApproxBounds.log_norm_Gammaℝ_approx hwr)
  have gz := gErr_le16 (r := z.re / 2) (by linarith) (by linarith)
  have gw := gErr_le16 (r := w.re / 2) (by linarith) (by linarith)
  have Cz := abs_le.mp (hC (z.re / 2) ⟨by linarith, by linarith⟩)
  have Cw := abs_le.mp (hC (w.re / 2) ⟨by linarith, by linarith⟩)
  have hCa : C ≤ |C| := le_abs_self C
  have lz := DigammaBound.lY_bounds hT hzy1 hzy2
  have lw := DigammaBound.lY_bounds hT hwy1 hwy2
  have hpi : Real.log Real.pi ≤ 3 := by
    have := Real.log_le_sub_one_of_pos Real.pi_pos
    linarith [Real.pi_lt_d2]
  have hpi0 : 0 ≤ Real.log Real.pi := Real.log_nonneg (by linarith [Real.pi_gt_three])
  have hmod : ApproxBounds.gRModel z - ApproxBounds.gRModel w
      - (Real.log T / 2) * (z.re - w.re) ≤ 2 * |C| + 44 := by
    unfold ApproxBounds.gRModel ApproxBounds.gModel
    rw [abs_of_pos (show 0 < z.im / 2 by linarith), abs_of_pos (show 0 < w.im / 2 by linarith)]
    have key : -(z.re / 2) * Real.log Real.pi +
          (Real.log (Real.Gamma (z.re / 2)) - Real.log (Real.Gamma (1 / 2)) +
            Real.log Real.pi / 2 - Real.pi * (z.im / 2) / 2 +
            (z.re / 2 - 1 / 2) * ApproxBounds.lY (z.im / 2)) -
        (-(w.re / 2) * Real.log Real.pi +
          (Real.log (Real.Gamma (w.re / 2)) - Real.log (Real.Gamma (1 / 2)) +
            Real.log Real.pi / 2 - Real.pi * (w.im / 2) / 2 +
            (w.re / 2 - 1 / 2) * ApproxBounds.lY (w.im / 2))) -
        Real.log T / 2 * (z.re - w.re)
        = (-(z.re - w.re) / 2) * Real.log Real.pi
          + (Real.log (Real.Gamma (z.re / 2)) - Real.log (Real.Gamma (w.re / 2)))
          - Real.pi / 4 * (z.im - w.im)
          + (z.re / 2 - 1 / 2) * (ApproxBounds.lY (z.im / 2) - Real.log T)
          - (w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T) := by ring
    rw [key]
    have t1 : (-(z.re - w.re) / 2) * Real.log Real.pi ≤ 4 * 3 :=
      mul_le_mul (by linarith) hpi hpi0 (by norm_num)
    have t3 : -(Real.pi / 4 * (z.im - w.im)) ≤ 1 := by
      have := abs_le.mp hzw
      nlinarith [Real.pi_lt_d2, Real.pi_pos]
    have t4 := DigammaBound.mul_le_of_abs (a := z.re / 2 - 1 / 2)
      (b := ApproxBounds.lY (z.im / 2) - Real.log T)
      (A := 3) (B := 3) (by rw [abs_le]; constructor <;> linarith)
      (by rw [abs_le]; constructor <;> linarith [lz.1, lz.2])
    have t5 := DigammaBound.mul_le_of_abs (a := -(w.re / 2 - 1 / 2))
      (b := ApproxBounds.lY (w.im / 2) - Real.log T)
      (A := 3) (B := 3) (by rw [abs_le]; constructor <;> linarith)
      (by rw [abs_le]; constructor <;> linarith [lw.1, lw.2])
    have e5 : -(w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T)
        = -((w.re / 2 - 1 / 2) * (ApproxBounds.lY (w.im / 2) - Real.log T)) := by ring
    rw [e5] at t5
    linarith [Cz.1, Cz.2, Cw.1, Cw.2]
  have hlog : Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖
      - (Real.log T / 2) * (z.re - w.re) ≤ 2 * |C| + 264 := by
    linarith [ez.1, ez.2, ew.1, ew.2]
  calc ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re))
      = Real.exp (Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖
          - (Real.log T / 2) * (z.re - w.re)) := by
        rw [show Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖ - (Real.log T / 2) * (z.re - w.re)
            = (Real.log ‖Gammaℝ z‖ - Real.log ‖Gammaℝ w‖)
              + (-(Real.log T / 2) * (z.re - w.re)) by ring,
          Real.exp_add, Real.exp_sub, Real.exp_log hGz, Real.exp_log hGw]
    _ ≤ Real.exp (2 * |C| + 264) := Real.exp_le_exp.mpr hlog

/-! ### The shift identity for `Gammaℝ` -/

/-- `h_w(z) = Gammaℝ(z)/Gammaℝ(w) · e^{−(L/2)(z − w)}`. -/
def hw (L : ℝ) (w z : ℂ) : ℂ := Gammaℝ z / Gammaℝ w * cexp (-((L / 2 : ℝ) : ℂ) * (z - w))

/-- `Gammaℝ = Gammaℝ(w) · h_w · e^{(L/2)(· − w)}`, exactly. -/
theorem Gammaℝ_eq (L : ℝ) {w : ℂ} (hGw : Gammaℝ w ≠ 0) :
    Gammaℝ = fun z => Gammaℝ w * (hw L w z * cexp (((L / 2 : ℝ) : ℂ) * (z - w))) := by
  funext z
  have hexp : cexp (-((L / 2 : ℝ) : ℂ) * (z - w)) * cexp (((L / 2 : ℝ) : ℂ) * (z - w)) = 1 := by
    rw [← Complex.exp_add, neg_mul, neg_add_cancel, Complex.exp_zero]
  unfold hw
  calc Gammaℝ z = Gammaℝ w * (Gammaℝ z / Gammaℝ w) *
      (cexp (-((L / 2 : ℝ) : ℂ) * (z - w)) * cexp (((L / 2 : ℝ) : ℂ) * (z - w))) := by
        rw [hexp]; field_simp
    _ = _ := by ring

theorem analyticAt_hw (L : ℝ) (w : ℂ) {z : ℂ} (hz : 0 < z.re) : AnalyticAt ℂ (hw L w) z := by
  have hGa := ConreyCount.analyticAt_Gammaℝ' (Gammaℝ_ne_zero_of_re_pos hz)
  have hE : AnalyticAt ℂ (fun u => cexp (-((L / 2 : ℝ) : ℂ) * (u - w))) z := by fun_prop
  exact (hGa.div_const (c := Gammaℝ w)).mul hE

theorem hw_self (L : ℝ) {w : ℂ} (hw0 : 0 < w.re) : hw L w w = 1 := by
  have hG : Gammaℝ w ≠ 0 := Gammaℝ_ne_zero_of_re_pos hw0
  unfold hw
  rw [sub_self, mul_zero, Complex.exp_zero, mul_one, div_self hG]

theorem norm_hw (L : ℝ) (w z : ℂ) : ‖hw L w z‖ =
    ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(L / 2) * (z.re - w.re)) := by
  have hre : (-((L / 2 : ℝ) : ℂ) * (z - w)).re = -(L / 2) * (z.re - w.re) := by
    simp [Complex.mul_re]
  unfold hw
  rw [norm_mul, norm_div, Complex.norm_exp, hre]

/-- **Leibniz**: `grR i w = Σ_j C(i,j) h_w^{(j)}(w) (L/2)^{i−j}`. -/
theorem grR_eq (L : ℝ) (i : ℕ) {w : ℂ} (hw0 : 0 < w.re) :
    MeanQ.grR i w = ∑ j ∈ Finset.range (i + 1),
      (i.choose j : ℂ) * iteratedDeriv j (hw L w) w * (((L / 2 : ℝ) : ℂ)) ^ (i - j) := by
  have hGw : Gammaℝ w ≠ 0 := Gammaℝ_ne_zero_of_re_pos hw0
  have hHa := analyticAt_hw L w hw0
  have hEa : AnalyticAt ℂ (fun z => cexp (((L / 2 : ℝ) : ℂ) * (z - w))) w := by fun_prop
  have hD : iteratedDeriv i Gammaℝ w = iteratedDeriv i
      (fun z => Gammaℝ w * (hw L w z * cexp (((L / 2 : ℝ) : ℂ) * (z - w)))) w :=
    congrArg (fun f => iteratedDeriv i f w) (Gammaℝ_eq L hGw)
  unfold MeanQ.grR
  rw [hD, iteratedDeriv_const_mul_field, iteratedDeriv_fun_mul hHa.contDiffAt hEa.contDiffAt,
    mul_div_cancel_left₀ _ hGw]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [DigammaBound.iteratedDeriv_E]

/-- The scalar identity `(−1/L)^{j+k} (L/2)^k = (−1/2)^k (−1/L)^j`. -/
theorem pow_shift {L : ℝ} (hL : L ≠ 0) {i j : ℕ} (hj : j ≤ i) :
    (-1 / L) ^ i * (L / 2) ^ (i - j) = (-1 / 2 : ℝ) ^ (i - j) * (-1 / L) ^ j := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hj
  rw [Nat.add_sub_cancel_left, pow_add, mul_assoc, ← mul_pow,
    show (-1 / L) * (L / 2) = (-1 / 2 : ℝ) by field_simp]
  ring

/-- **The error, exactly**:
`(−1/L)^i grR i w − (−1/2)^i = Σ_{j<i} C(i,j+1) (−1/2)^{i−j−1} (−1/L)^{j+1} h_w^{(j+1)}(w)`. -/
theorem grR_sub {L : ℝ} (hL : L ≠ 0) (i : ℕ) {w : ℂ} (hw0 : 0 < w.re) :
    (((-1 / L) ^ i : ℝ) : ℂ) * MeanQ.grR i w - (((-1 / 2 : ℝ) ^ i : ℝ) : ℂ) =
      ∑ j ∈ Finset.range i, (i.choose (j + 1) : ℂ) * (((-1 / 2 : ℝ) ^ (i - (j + 1)) : ℝ) : ℂ) *
        ((((-1 / L) ^ (j + 1) : ℝ) : ℂ) * iteratedDeriv (j + 1) (hw L w) w) := by
  have hterm : ∀ j ∈ Finset.range (i + 1),
      (((-1 / L) ^ i : ℝ) : ℂ) * ((i.choose j : ℂ) * iteratedDeriv j (hw L w) w *
        (((L / 2 : ℝ) : ℂ)) ^ (i - j)) =
      (i.choose j : ℂ) * (((-1 / 2 : ℝ) ^ (i - j) : ℝ) : ℂ) *
        ((((-1 / L) ^ j : ℝ) : ℂ) * iteratedDeriv j (hw L w) w) := by
    intro j hj
    have hji : j ≤ i := Nat.lt_succ_iff.mp (Finset.mem_range.mp hj)
    have e := congrArg (fun x : ℝ => (x : ℂ)) (pow_shift hL hji)
    push_cast at e
    push_cast
    linear_combination (i.choose j : ℂ) * iteratedDeriv j (hw L w) w * e
  rw [grR_eq L i hw0, Finset.mul_sum, Finset.sum_congr rfl hterm, Finset.sum_range_succ']
  rw [iteratedDeriv_zero, hw_self L hw0]
  push_cast
  simp

/-! ### The bound -/

/-- **`StmtGrRatio`, discharged.** -/
theorem stmtGrRatio_holds (n : ℕ) : MeanQ.StmtGrRatio n := by
  obtain ⟨B, hB0, hB⟩ := gamma_ratio8
  set K : ℕ → ℝ := fun i => ∑ j ∈ Finset.range i,
    (i.choose (j + 1) : ℝ) * (((j + 1).factorial : ℝ) * B / (1 / 8 : ℝ) ^ (j + 1)) with hK
  have hK0 : ∀ i, 0 ≤ K i := fun i => Finset.sum_nonneg fun _ _ => by positivity
  refine ⟨∑ i ∈ Finset.range (n + 1), K i, 16,
    Finset.sum_nonneg fun i _ => hK0 i, fun T hT i hi σ hσ t ht => ?_⟩
  have hT0 : 0 < T := by linarith
  have hL1 : 1 ≤ Real.log T := by
    have h := Real.log_le_log (Real.exp_pos 1) (show Real.exp 1 ≤ T by
      linarith [Real.exp_one_lt_d9])
    rwa [Real.log_exp] at h
  have hL0 : 0 < Real.log T := by linarith
  set L := Real.log T with hLdef
  set w : ℂ := (σ : ℂ) + t * I with hwdef
  have hwre : w.re = σ := by rw [hwdef]; simp
  have hwim : w.im = t := by rw [hwdef]; simp
  have hw0 : 0 < w.re := by rw [hwre]; linarith [hσ.1]
  have hR : (0 : ℝ) < 1 / 8 := by norm_num
  -- `h_w` on the closed disc and on the circle
  have hd : DiffContOnCl ℂ (hw L w) (ball w (1 / 8)) := by
    refine DifferentiableOn.diffContOnCl ?_
    rw [closure_ball w hR.ne']
    intro z hz
    have hzw : ‖z - w‖ ≤ 1 / 8 := by rw [← dist_eq_norm]; exact hz
    have hre := Complex.abs_re_le_norm (z - w)
    rw [Complex.sub_re] at hre
    have hz0 : 0 < z.re := by
      have := (abs_le.mp (hre.trans hzw)).1
      linarith [hσ.1]
    exact (analyticAt_hw L w hz0).differentiableAt.differentiableWithinAt
  have hM : ∀ z ∈ sphere w (1 / 8), ‖hw L w z‖ ≤ B := by
    intro z hz
    have hzw : ‖z - w‖ = 1 / 8 := by rw [← dist_eq_norm]; exact hz
    have hre := Complex.abs_re_le_norm (z - w)
    have him := Complex.abs_im_le_norm (z - w)
    rw [Complex.sub_re, hzw, hwre] at hre
    rw [Complex.sub_im, hzw, hwim] at him
    obtain ⟨hre1, hre2⟩ := abs_le.mp hre
    obtain ⟨him1, him2⟩ := abs_le.mp him
    rw [norm_hw]
    refine hB T hT z w (by linarith [hσ.1]) (by linarith [hσ.2]) (by linarith [hσ.1])
      (by linarith [hσ.2]) (by linarith [ht.1]) (by linarith [ht.2]) (by linarith [ht.1])
      (by linarith [ht.2]) (by rw [hwim, abs_le]; constructor <;> linarith)
  -- one term
  have hterm : ∀ j ∈ Finset.range i,
      ‖(i.choose (j + 1) : ℂ) * (((-1 / 2 : ℝ) ^ (i - (j + 1)) : ℝ) : ℂ) *
        ((((-1 / L) ^ (j + 1) : ℝ) : ℂ) * iteratedDeriv (j + 1) (hw L w) w)‖ ≤
      (i.choose (j + 1) : ℝ) * (((j + 1).factorial : ℝ) * B / (1 / 8 : ℝ) ^ (j + 1)) / L := by
    intro j _
    have hc := Complex.norm_iteratedDeriv_le_of_forall_mem_sphere_norm_le (j + 1) hR hd hM
    have hhalf : ‖(((-1 / 2 : ℝ) ^ (i - (j + 1)) : ℝ) : ℂ)‖ ≤ 1 := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_pow]
      exact pow_le_one₀ (abs_nonneg _) (by norm_num [abs_div])
    have hLp : ‖(((-1 / L) ^ (j + 1) : ℝ) : ℂ)‖ ≤ 1 / L := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_pow, abs_div, abs_neg, abs_one,
        abs_of_pos hL0, pow_succ]
      have h1 : (1 / L) ^ j ≤ 1 := pow_le_one₀ (by positivity) (by
        rw [div_le_one hL0]; exact hL1)
      have h2 : 0 ≤ 1 / L := by positivity
      nlinarith
    rw [norm_mul, norm_mul, norm_mul, Complex.norm_natCast]
    have hX : 0 ≤ ((j + 1).factorial : ℝ) * B / (1 / 8 : ℝ) ^ (j + 1) := by positivity
    calc (i.choose (j + 1) : ℝ) * ‖(((-1 / 2 : ℝ) ^ (i - (j + 1)) : ℝ) : ℂ)‖ *
          (‖(((-1 / L) ^ (j + 1) : ℝ) : ℂ)‖ * ‖iteratedDeriv (j + 1) (hw L w) w‖)
        ≤ (i.choose (j + 1) : ℝ) * 1 *
          (1 / L * (((j + 1).factorial : ℝ) * B / (1 / 8 : ℝ) ^ (j + 1))) := by
          gcongr
      _ = (i.choose (j + 1) : ℝ) * (((j + 1).factorial : ℝ) * B / (1 / 8 : ℝ) ^ (j + 1)) / L := by
          ring
  rw [grR_sub hL0.ne' i hw0]
  refine (norm_sum_le _ _).trans ((Finset.sum_le_sum hterm).trans ?_)
  rw [← Finset.sum_div]
  have hKi : K i ≤ ∑ i ∈ Finset.range (n + 1), K i :=
    Finset.single_le_sum (f := K) (fun j _ => hK0 j) (Finset.mem_range.mpr (by omega))
  exact div_le_div_of_nonneg_right hKi hL0.le

/-! ### The corollaries, without `hG` -/

open MeanQ in
/-- **`window_V_lt_half` without `hG`.** -/
theorem window_V_lt_half' (Q P : ℝ[X]) (hP0 : P.eval 0 = 0) {θ R : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (hR : 0 < R) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ a' b' : ℝ,
      T / 2 ≤ a' → a' ≤ T / 2 + 1 → T - 1 ≤ b' → b' ≤ T →
      (1 / (b' - a')) * ∫ t in a'..b',
          ‖ConreyCount.V Q (Real.log T) ((sig0 T R : ℂ) + t * I) *
            psi (Mof T θ) (aY P T θ R) ((sig0 T R : ℂ) + t * I)‖ ^ 2 ≤
        (DopQ Q (Real.log T) (cY P (Mof T θ) T) ((-(R / Real.log T) : ℝ) : ℂ)
          ((-(R / Real.log T) : ℝ) : ℂ)).re + ε :=
  MeanQ.window_V_lt_half Q P hP0 hθ0 hθ hR (stmtGrRatio_holds Q.natDegree)

open MeanQ in
/-- **`mollMeanV_long` without `hG`.** -/
theorem mollMeanV_long' (Q P : ℝ[X]) {θ R : ℝ} (hθ0 : 0 < θ) (hR : 0 < R)
    (hL3 : StmtLemma3resO P θ R (2 * R + 1 + 1 / R)) :
    StmtMollMeanV Q P θ R :=
  MeanQ.mollMeanV_long Q P hθ0 hR hL3 (stmtGrRatio_holds Q.natDegree)

/-- info: 'GrRatio.gamma_ratio8' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms gamma_ratio8

/-- info: 'GrRatio.grR_sub' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms grR_sub

/-- info: 'GrRatio.stmtGrRatio_holds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stmtGrRatio_holds

/-- info: 'GrRatio.window_V_lt_half'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms window_V_lt_half'

/-- info: 'GrRatio.mollMeanV_long'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mollMeanV_long'

end GrRatio

end
