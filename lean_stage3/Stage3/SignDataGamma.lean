/-
SignDataGamma — block S14 of `lean_stage3/design/stencil.md`, Turing's sign data: the phase of
`Gammaℝ` on the line, to within `π/2`. 2026-11-25.

On the line `Λ(1/2 + it)` is real (`HardyZ.xi_line_real`). Write `z = 1/4 + it/2` and
`Γ(z) = GammaSeq z n · e^δ` with `δ = logG z − logGammaSeq z n` (`Stirling.logG`,
PNT+'s `logGammaSeq`). The increments of `logGammaSeq` are `≤ (2‖z‖ + ‖z‖²)/(m+1)²` once
`m ≥ 2‖z‖` (the estimate inside PNT+'s `cauchySeq_logGammaSeq`, restated as `step_le`), so
`‖δ‖ ≤ (2‖z‖ + ‖z‖²)/n` (`tail_le`). With `GammaSeq z n = n^z n!/∏_{j≤n}(z+j)` and
`∏_{j≤n}(z+j) = n!·W`, `W = z ∏_{j<n}(1 + z/(j+1))` (`prod_shift`),

  Λ = κ · e^δ · X,   X = e^{i(t/2)(log n − log π)} · conj W · ζ(1/2 + it),   κ > 0.

Since `Λ` is real, `Re X = (Λ/κ)·e^{−Re δ} cos(Im δ)`, and `|Im δ| ≤ 3/2 < π/2` makes the cosine
positive: `Re Λ = c · Re X` with `c > 0` (`re_lambda_eq`). So the sign of `Λ(1/2 + it)` is the sign
of `Re X`, and `X` is a finite product of balls: the `n` factors `1 + z/(j+1)` are Gaussian
rationals, the phase is one exponential, and `ζ` comes from `SignDataZeta`.

| name | content | status |
|---|---|---|
| `zz`, `gammaDir` | `z = 1/4 + it/2`; `e^{i(t/2)(log n − log π)}·conj W` | def |
| `step_le` | `1 ≤ m`, `2‖z‖ ≤ m` ⊢ `‖logGammaSeq z (m+1) − logGammaSeq z m‖ ≤ (2‖z‖+‖z‖²)/(m+1)²` | proved |
| `tail_le` | `1 ≤ n`, `2‖z‖ ≤ n` ⊢ `‖logG z − logGammaSeq z n‖ ≤ (2‖z‖+‖z‖²)/n` | proved |
| `prod_shift` | `∏_{j<n+1}(z+j) = n!·(z·∏_{j<n}(1 + z/(j+1)))` | proved |
| `re_lambda_eq` | `1/2 + |t| ≤ n`, `2(1/4+|t|/2) + (1/4+|t|/2)² ≤ (3/2) n` ⊢ `∃ c > 0, Re Λ = c · Re(gammaDir t n · ζ)` | proved |
| `re_lambda_pos`, `re_lambda_neg` | the sign of `Re Λ` from a ball for `gammaDir t n · ζ` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingLog
import Stage3.HardyZ
import Stage3.SignDataZeta

namespace SignData

open Complex Filter Topology

noncomputable section

/-- `z = s/2 = 1/4 + it/2` on the line. -/
def zz (t : ℝ) : ℂ := 1 / 4 + ((t / 2 : ℝ) : ℂ) * I

/-- The direction of `Gammaℝ(1/2 + it)` up to `e^δ` and a positive factor. -/
def gammaDir (t : ℝ) (n : ℕ) : ℂ :=
  cexp ((((t / 2) * (Real.log n - Real.log Real.pi)) : ℝ) * I)
    * (starRingEnd ℂ) (zz t * ∏ j ∈ Finset.range n, (1 + zz t / ((j : ℂ) + 1)))

theorem zz_re (t : ℝ) : (zz t).re = 1 / 4 := by simp [zz]

theorem norm_zz_le (t : ℝ) : ‖zz t‖ ≤ 1 / 4 + |t| / 2 := by
  unfold zz
  refine (norm_add_le _ _).trans ?_
  rw [norm_mul, Complex.norm_I, mul_one, Complex.norm_real, Real.norm_eq_abs, abs_div,
    abs_two]
  norm_num

/-- One increment of `logGammaSeq` (the estimate of PNT+'s `cauchySeq_logGammaSeq`). -/
theorem step_le {z : ℂ} (hz : 0 < z.re) {n : ℕ} (hn1 : 1 ≤ n) (hn2R : 2 * ‖z‖ ≤ (n : ℝ)) :
    ‖Complex.logGammaSeq z (n + 1) - Complex.logGammaSeq z n‖
      ≤ (2 * ‖z‖ + ‖z‖ ^ 2) * (1 / ((n : ℝ) + 1) ^ 2) := by
  have hnR : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
  have hw : ‖z / ((n : ℂ) + 1)‖ = ‖z‖ / ((n : ℝ) + 1) := by
    rw [norm_div, norm_natCast_add_one]
  have hw2 : ‖z / ((n : ℂ) + 1)‖ ≤ 1 / 2 := by
    rw [hw, div_le_iff₀ (by positivity)]
    linarith
  rw [Complex.logGammaSeq_succ_sub hz n]
  have key : z * ((Real.log ((n : ℝ) + 1) - Real.log n : ℝ) : ℂ) - log (1 + z / ((n : ℂ) + 1))
      = z * ((Real.log ((n : ℝ) + 1) - Real.log n - ((n : ℝ) + 1)⁻¹ : ℝ) : ℂ)
        + (z / ((n : ℂ) + 1) - log (1 + z / ((n : ℂ) + 1))) := by
    push_cast
    ring
  rw [key]
  have hn0 : (0 : ℝ) < n := by linarith
  have hlog_est : |Real.log ((n : ℝ) + 1) - Real.log n - ((n : ℝ) + 1)⁻¹|
      ≤ 2 * (1 / ((n : ℝ) + 1) ^ 2) := by
    have hdiv : Real.log ((n : ℝ) + 1) - Real.log n = Real.log (((n : ℝ) + 1) / n) :=
      (Real.log_div (by positivity) (by positivity)).symm
    have l1 : Real.log ((n : ℝ) + 1) - Real.log n ≤ 1 / n := by
      rw [hdiv]
      have h := Real.log_le_sub_one_of_pos (show (0 : ℝ) < ((n : ℝ) + 1) / n by positivity)
      have he : ((n : ℝ) + 1) / n - 1 = 1 / n := by
        field_simp
        ring
      linarith
    have l2 : ((n : ℝ) + 1)⁻¹ ≤ Real.log ((n : ℝ) + 1) - Real.log n := by
      have h := Real.log_le_sub_one_of_pos (show (0 : ℝ) < (n : ℝ) / ((n : ℝ) + 1) by positivity)
      rw [Real.log_div hn0.ne' (by positivity)] at h
      have he : (n : ℝ) / ((n : ℝ) + 1) - 1 = -((n : ℝ) + 1)⁻¹ := by
        field_simp
        ring
      rw [he] at h
      linarith
    have hcomp : 1 / (n : ℝ) - ((n : ℝ) + 1)⁻¹ ≤ 2 * (1 / ((n : ℝ) + 1) ^ 2) := by
      have he : 1 / (n : ℝ) - ((n : ℝ) + 1)⁻¹ = 1 / ((n : ℝ) * ((n : ℝ) + 1)) := by
        field_simp
        ring
      rw [he, mul_one_div, div_le_div_iff₀ (by positivity) (by positivity)]
      nlinarith
    rw [abs_le]
    constructor
    · have : (0 : ℝ) ≤ 2 * (1 / ((n : ℝ) + 1) ^ 2) := by positivity
      linarith
    · linarith
  calc ‖z * ((Real.log ((n : ℝ) + 1) - Real.log n - ((n : ℝ) + 1)⁻¹ : ℝ) : ℂ)
        + (z / ((n : ℂ) + 1) - log (1 + z / ((n : ℂ) + 1)))‖
      ≤ ‖z * ((Real.log ((n : ℝ) + 1) - Real.log n - ((n : ℝ) + 1)⁻¹ : ℝ) : ℂ)‖
        + ‖z / ((n : ℂ) + 1) - log (1 + z / ((n : ℂ) + 1))‖ := norm_add_le _ _
    _ ≤ ‖z‖ * (2 * (1 / ((n : ℝ) + 1) ^ 2)) + ‖z‖ ^ 2 * (1 / ((n : ℝ) + 1) ^ 2) := by
        apply _root_.add_le_add
        · rw [norm_mul, norm_real, Real.norm_eq_abs]
          exact mul_le_mul_of_nonneg_left hlog_est (norm_nonneg z)
        · have hlt : ‖z / ((n : ℂ) + 1)‖ < 1 := lt_of_le_of_lt hw2 (by norm_num)
          have hb := norm_log_one_add_sub_self_le hlt
          rw [← norm_neg, neg_sub]
          calc ‖log (1 + z / ((n : ℂ) + 1)) - z / ((n : ℂ) + 1)‖
              ≤ ‖z / ((n : ℂ) + 1)‖ ^ 2 * (1 - ‖z / ((n : ℂ) + 1)‖)⁻¹ / 2 := hb
            _ ≤ ‖z / ((n : ℂ) + 1)‖ ^ 2 * 2 / 2 := by
                have h2 : (1 - ‖z / ((n : ℂ) + 1)‖)⁻¹ ≤ 2 := by
                  rw [← one_div]
                  have h3 := one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 1 / 2)
                    (by linarith : (1 : ℝ) / 2 ≤ 1 - ‖z / ((n : ℂ) + 1)‖)
                  simpa using h3
                gcongr
            _ = ‖z / ((n : ℂ) + 1)‖ ^ 2 := by ring
            _ = ‖z‖ ^ 2 * (1 / ((n : ℝ) + 1) ^ 2) := by
                rw [hw, div_pow]
                ring
    _ = (2 * ‖z‖ + ‖z‖ ^ 2) * (1 / ((n : ℝ) + 1) ^ 2) := by ring

/-- **The tail**: `‖logG z − logGammaSeq z n‖ ≤ (2‖z‖ + ‖z‖²)/n` for `n ≥ max(1, 2‖z‖)`. -/
theorem tail_le {z : ℂ} (hz : 0 < z.re) {n : ℕ} (hn1 : 1 ≤ n) (hn2 : 2 * ‖z‖ ≤ (n : ℝ)) :
    ‖Stirling.logG z - Complex.logGammaSeq z n‖ ≤ (2 * ‖z‖ + ‖z‖ ^ 2) / n := by
  set C := 2 * ‖z‖ + ‖z‖ ^ 2 with hC
  have hC0 : 0 ≤ C := by positivity
  set f : ℕ → ℂ := fun k => Complex.logGammaSeq z (k + n) with hf
  set d : ℕ → ℝ := fun k => C * (1 / (((k + n : ℕ) : ℝ) + 1) ^ 2) with hd
  have hfd : ∀ k, dist (f k) (f k.succ) ≤ d k := by
    intro k
    rw [dist_eq_norm, norm_sub_rev]
    have e : k.succ + n = (k + n) + 1 := by omega
    simp only [hf, hd, e]
    have hk1 : 1 ≤ k + n := by omega
    have hk2 : 2 * ‖z‖ ≤ ((k + n : ℕ) : ℝ) := by
      refine hn2.trans ?_
      exact_mod_cast (by omega : n ≤ k + n)
    exact step_le hz hk1 hk2
  have hsum : Summable d := by
    have h0 : Summable (fun m : ℕ => 1 / ((m : ℝ) + 1) ^ 2) := summable_one_div_natCast_add_one_sq
    have h1 := (summable_nat_add_iff n).mpr h0
    exact h1.mul_left C
  have hlim : Tendsto f atTop (𝓝 (Stirling.logG z)) :=
    (tendsto_add_atTop_iff_nat n).mpr (Stirling.tendsto_logG hz)
  have h := dist_le_tsum_of_dist_le_of_tendsto d hfd hsum hlim 0
  simp only [hf, zero_add] at h
  rw [dist_eq_norm, norm_sub_rev] at h
  refine h.trans ?_
  have ht := Complex.tsum_one_div_natCast_add_add_one_sq_le hn1
  simp only [hd]
  rw [tsum_mul_left]
  calc C * ∑' (m : ℕ), 1 / (((m + n : ℕ) : ℝ) + 1) ^ 2 ≤ C * (n : ℝ)⁻¹ :=
        mul_le_mul_of_nonneg_left ht hC0
    _ = C / n := by rw [div_eq_mul_inv]

/-- `∏_{j<n+1}(z+j) = n!·(z·∏_{j<n}(1 + z/(j+1)))`. -/
theorem prod_shift (z : ℂ) (n : ℕ) :
    ∏ j ∈ Finset.range (n + 1), (z + j)
      = (n.factorial : ℂ) * (z * ∏ j ∈ Finset.range n, (1 + z / ((j : ℂ) + 1))) := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.prod_range_succ, ih, Finset.prod_range_succ, Nat.factorial_succ]
    have hn : ((n : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero n
    push_cast
    field_simp
    ring

theorem lineS_div_two (t : ℝ) : lineS t / 2 = zz t := by
  unfold lineS zz; push_cast; ring

/-- **The phase of `Gammaℝ`, to within `π/2`.** -/
theorem re_lambda_eq (t : ℝ) {n : ℕ} (hn1 : 1 ≤ n) (h1 : 1 / 2 + |t| ≤ n)
    (h2 : 2 * (1 / 4 + |t| / 2) + (1 / 4 + |t| / 2) ^ 2 ≤ 3 / 2 * n) :
    ∃ c : ℝ, 0 < c ∧ (completedRiemannZeta (lineS t)).re
      = c * (gammaDir t n * riemannZeta (lineS t)).re := by
  set z := zz t with hzdef
  have hz : 0 < z.re := by rw [hzdef, zz_re]; norm_num
  have hnz := norm_zz_le t
  rw [← hzdef] at hnz
  have hnR : (1 : ℝ) ≤ n := by exact_mod_cast hn1
  have hn0 : (n : ℂ) ≠ 0 := by exact_mod_cast (by omega : n ≠ 0)
  -- the tail `δ`
  set δ := Stirling.logG z - Complex.logGammaSeq z n with hδ
  have hδle : ‖δ‖ ≤ 3 / 2 := by
    have h2z : 2 * ‖z‖ ≤ (n : ℝ) := by linarith
    have ht := tail_le hz hn1 h2z
    refine ht.trans ?_
    rw [div_le_iff₀ (by linarith)]
    have : 2 * ‖z‖ + ‖z‖ ^ 2 ≤ 2 * (1 / 4 + |t| / 2) + (1 / 4 + |t| / 2) ^ 2 := by
      have := norm_nonneg z
      nlinarith
    linarith
  -- `Γ(z) = GammaSeq z n · e^δ`
  have hG : Complex.Gamma z = Complex.GammaSeq z n * cexp δ := by
    rw [← Stirling.exp_logG hz, ← Complex.exp_logGammaSeq hz (by omega : n ≠ 0), ← Complex.exp_add,
      hδ]
    ring_nf
  -- the product
  set W := z * ∏ j ∈ Finset.range n, (1 + z / ((j : ℂ) + 1)) with hW
  have hzj : ∀ j : ℕ, z + j ≠ 0 := by
    intro j h
    have := congrArg Complex.re h
    simp only [add_re, natCast_re, zero_re] at this
    have : (0 : ℝ) ≤ j := Nat.cast_nonneg j
    linarith
  have hD : ∏ j ∈ Finset.range (n + 1), (z + j) ≠ 0 := Finset.prod_ne_zero_iff.mpr (fun j _ => hzj j)
  have hWne : W ≠ 0 := by
    intro h
    apply hD
    rw [prod_shift, ← hW, h, mul_zero]
  have hfac : (n.factorial : ℂ) ≠ 0 := by exact_mod_cast n.factorial_ne_zero
  have hGS : Complex.GammaSeq z n = (n : ℂ) ^ z / W := by
    unfold Complex.GammaSeq
    rw [prod_shift, ← hW]
    field_simp
  -- `π^{−z} n^z = ρ e^{iφ}`
  set L := Real.log n - Real.log Real.pi with hL
  set φ := (t / 2) * L with hφ
  have hnpos : (0 : ℝ) < n := by linarith
  have hpow : (Real.pi : ℂ) ^ (-z) * (n : ℂ) ^ z
      = ((Real.exp (L / 4) : ℝ) : ℂ) * cexp ((φ : ℂ) * I) := by
    have hpi0 : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
    rw [Complex.cpow_def_of_ne_zero hpi0, Complex.cpow_def_of_ne_zero hn0, ← Complex.exp_add,
      Complex.ofReal_exp, ← Complex.exp_add, ← Complex.ofReal_log Real.pi_pos.le,
      ← Complex.natCast_log]
    congr 1
    rw [hφ, hL, hzdef]
    unfold zz
    push_cast
    ring
  -- `Λ = Gammaℝ · ζ`
  set s := lineS t with hs
  have hs0 : s ≠ 0 := lineS_ne_zero t
  have hsre : 0 < s.re := by rw [hs, lineS_re]; norm_num
  have hGR : s.Gammaℝ ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hsre
  have hΛ : completedRiemannZeta s = s.Gammaℝ * riemannZeta s := by
    rw [riemannZeta_def_of_ne_zero hs0]
    field_simp
  have hGR' : s.Gammaℝ = (Real.pi : ℂ) ^ (-z) * Complex.Gamma z := by
    have hs2 : s / 2 = z := by rw [hs, hzdef, lineS_div_two]
    rw [Complex.Gammaℝ_def, neg_div, hs2]
  -- `1/W = conj W / normSq W`
  have hWinv : W⁻¹ = (starRingEnd ℂ) W * (((Complex.normSq W)⁻¹ : ℝ) : ℂ) := Complex.inv_def W
  have hnsq : 0 < Complex.normSq W := Complex.normSq_pos.mpr hWne
  set κ := Real.exp (L / 4) * (Complex.normSq W)⁻¹ with hκ
  have hκ0 : 0 < κ := by positivity
  set X := gammaDir t n * riemannZeta s with hX
  have hmain : completedRiemannZeta s = (κ : ℂ) * cexp δ * X := by
    rw [hΛ, hGR', hG, hGS, hX]
    have hgd : gammaDir t n = cexp ((φ : ℂ) * I) * (starRingEnd ℂ) W := rfl
    rw [hgd, div_eq_mul_inv, hWinv]
    have : (Real.pi : ℂ) ^ (-z) * ((n : ℂ) ^ z * ((starRingEnd ℂ) W
        * (((Complex.normSq W)⁻¹ : ℝ) : ℂ)) * cexp δ) * riemannZeta s
        = ((Real.pi : ℂ) ^ (-z) * (n : ℂ) ^ z) * (((Complex.normSq W)⁻¹ : ℝ) : ℂ) * cexp δ
          * ((starRingEnd ℂ) W * riemannZeta s) := by ring
    rw [this, hpow, hκ]
    simp only [Complex.ofReal_mul]
    ring
  -- reality
  have hreal : completedRiemannZeta s = ((completedRiemannZeta s).re : ℂ) := by
    apply Complex.ext
    · simp
    · simp only [ofReal_im]; rw [hs]; exact HardyZ.xi_line_real t
  have hXeq : X = (((completedRiemannZeta s).re / κ : ℝ) : ℂ) * cexp (-δ) := by
    have h3 : (κ : ℂ) * cexp δ ≠ 0 := mul_ne_zero (by exact_mod_cast hκ0.ne') (Complex.exp_ne_zero _)
    have h4 : X = completedRiemannZeta s / ((κ : ℂ) * cexp δ) := by
      rw [hmain, mul_div_cancel_left₀ _ h3]
    rw [h4, hreal, Complex.exp_neg]
    push_cast
    field_simp
    try simp
  -- the cosine
  have him : |δ.im| ≤ 3 / 2 := (Complex.abs_im_le_norm δ).trans hδle
  have hpi : 3 / 2 < Real.pi / 2 := by linarith [Real.pi_gt_three]
  have hcos : 0 < Real.cos (-δ.im) := by
    apply Real.cos_pos_of_mem_Ioo
    constructor <;> linarith [(abs_le.mp him).1, (abs_le.mp him).2]
  set μ := Real.exp (-δ.re) * Real.cos (-δ.im) with hμ
  have hμ0 : 0 < μ := mul_pos (Real.exp_pos _) hcos
  have hXre : X.re = (completedRiemannZeta s).re / κ * μ := by
    rw [hXeq, Complex.re_ofReal_mul, Complex.exp_re]
    simp [hμ]
  refine ⟨κ / μ, div_pos hκ0 hμ0, ?_⟩
  rw [hXre]
  field_simp

theorem re_lambda_pos (t : ℝ) {n : ℕ} (hn1 : 1 ≤ n) (h1 : 1 / 2 + |t| ≤ n)
    (h2 : 2 * (1 / 4 + |t| / 2) + (1 / 4 + |t| / 2) ^ 2 ≤ 3 / 2 * n) {a b r : ℝ}
    (hX : ‖gammaDir t n * riemannZeta (lineS t) - cx a b‖ ≤ r) (ha : r < a) :
    0 < (completedRiemannZeta (lineS t)).re := by
  obtain ⟨c, hc, h⟩ := re_lambda_eq t hn1 h1 h2
  rw [h]
  exact mul_pos hc (re_pos_of_ball hX ha)

theorem re_lambda_neg (t : ℝ) {n : ℕ} (hn1 : 1 ≤ n) (h1 : 1 / 2 + |t| ≤ n)
    (h2 : 2 * (1 / 4 + |t| / 2) + (1 / 4 + |t| / 2) ^ 2 ≤ 3 / 2 * n) {a b r : ℝ}
    (hX : ‖gammaDir t n * riemannZeta (lineS t) - cx a b‖ ≤ r) (ha : a < -r) :
    (completedRiemannZeta (lineS t)).re < 0 := by
  obtain ⟨c, hc, h⟩ := re_lambda_eq t hn1 h1 h2
  rw [h]
  exact mul_neg_of_pos_of_neg hc (re_neg_of_ball hX ha)

/-- The factor `1 + z/(j+1)` as an exact Gaussian rational. -/
theorem factor_ball (t : ℝ) (j : ℕ) :
    ‖(1 + zz t / ((j : ℂ) + 1)) - cx (1 + 1 / (4 * ((j : ℝ) + 1))) (t / (2 * ((j : ℝ) + 1)))‖ ≤ 0 := by
  have hj : ((j : ℝ) + 1) ≠ 0 := by positivity
  have hjC : ((j : ℂ) + 1) ≠ 0 := Nat.cast_add_one_ne_zero j
  have : (1 + zz t / ((j : ℂ) + 1)) = cx (1 + 1 / (4 * ((j : ℝ) + 1))) (t / (2 * ((j : ℝ) + 1))) := by
    have hc : ((j : ℂ) + 1) = (((j : ℝ) + 1 : ℝ) : ℂ) := by push_cast; rfl
    rw [hc]
    apply Complex.ext
    · simp [zz, cx, Complex.div_re, Complex.normSq]
      field_simp
      try ring
    · simp [zz, cx, Complex.div_im, Complex.normSq]
      field_simp
  rw [this, sub_self, norm_zero]

theorem prod_zero_ball (t : ℝ) :
    ‖∏ j ∈ Finset.range 0, (1 + zz t / ((j : ℂ) + 1)) - cx 1 0‖ ≤ 0 := by
  have : cx 1 0 = 1 := by apply Complex.ext <;> simp [cx]
  rw [this, Finset.prod_range_zero, sub_self, norm_zero]

theorem zz_ball (t : ℝ) : ‖zz t - cx (1 / 4) (t / 2)‖ ≤ 0 := by
  have : zz t = cx (1 / 4) (t / 2) := by apply Complex.ext <;> simp [zz, cx]
  rw [this, sub_self, norm_zero]

end

/-- info: 'SignData.tail_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tail_le

/-- info: 'SignData.re_lambda_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_lambda_eq

/-- info: 'SignData.re_lambda_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_lambda_pos

end SignData
