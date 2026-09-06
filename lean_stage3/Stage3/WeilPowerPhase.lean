/-
WeilPowerPhase — the phase of the tail product: `S m w` is its principal
part `c·w·exp(w²σ)` up to a relative error `2q`, and `Re (S m w)²` has an
explicit lower bound. Rung 5, twelfth slice; worksheet § 13 requirement
(b). 2026-09-06. Unit 0347.

WeilPowerGauss controls the modulus of the tail product
`T m w n = ∏_{j=m+1}^{n−1} (1 + x_j)`, `x_j = w²/(π²(j+1)²)`; nothing so far
controls its argument, and the sign of a cluster member's term
`−Re (g²)` is a statement about the argument. This module writes the tail
product as an exponential and splits the exponent:

    T m w n = exp(w² σ_n) · exp(δ_n),
    σ_n = Σ_{j=m+1}^{n−1} 1/(π²(j+1)²),   δ_n = Σ (log(1+x_j) − x_j),
    ‖δ_n‖ ≤ Σ ‖x_j‖² ≤ q := ‖w‖⁴/(π⁴(m+1)³)

(Mathlib's `norm_log_one_add_sub_self_le` at `‖x_j‖ ≤ 1/2`, the regime).
With `σ = lim σ_n = Σ_{j≥m+2} 1/(π²j²)` and `P = exp(w²σ)`, the limit gives

  sigma_ge / sigma_le    1/(π²(m+2)) ≤ σ ≤ 1/(π²(m+1))
  T_eq_mul               T m w n = exp(w² σ_n) · exp(δ_n)
  norm_delta_le          ‖δ_n‖ ≤ q
  norm_S_sub_le          q ≤ 1:  ‖S m w − c·w·P‖ ≤ 2q · ‖c·w·P‖,   c = cS m / D m
  re_A_sq                Re (c·w·P)² = c² e^{2Re(w²)σ} (Re(w²) cos(2Im(w²)σ) − Im(w²) sin(2Im(w²)σ))
  re_S_sq_ge             q ≤ 1:
        Re (S m w)² ≥ c² e^{2Re(w²)σ} (Re(w²) cos(2Im(w²)σ) − Im(w²) sin(2Im(w²)σ))
                      − c² ‖w‖² e^{2Re(w²)σ} (4q + 4q²)

At `w = (ε' + iΔ)h` and `m + 1 = λh`, `2 Im(w²) σ ≈ 4ε'Δh/(π²λ)` is the
phase `ω h` of worksheet § 13 and the bracket is `h²[(ε'² − Δ²)cos − 2ε'Δ sin]`.
Both limits are taken with `le_of_tendsto_of_tendsto`, the sequences on
each side built from `tendsto_S` and the partial sums' convergence
(`Summable.tendsto_sum_tsum_nat` with the index shifted by `m+1`).

What the next slice needs: § 13 (c), the variation of the weighted
amplitude over the `h`-range, and the regime hypothesis `q ≤ 1` traced
back to `h` and `λ` (`q = ε⁴h/(π⁴λ³)`-size at `m+1 = λh`).

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerSharp

namespace WeilPowerPhase

noncomputable section

open Complex WeilPower WeilOddPower WeilPowerBounds WeilPowerGauss WeilPowerSharp Real Filter Topology

/-- The summand of the tail sum, `1/(π²(j+1)²)`. -/
def hterm (j : ℕ) : ℝ := 1 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)

/-- The partial tail sum `σ_n`. -/
def sigmaN (m n : ℕ) : ℝ := ∑ j ∈ Finset.Ico (m + 1) n, hterm j

/-- The full tail sum `σ = Σ_{j ≥ m+1} 1/(π²(j+1)²)`. -/
def sigma (m : ℕ) : ℝ := ∑' k : ℕ, hterm (k + (m + 1))

theorem summable_hterm : Summable hterm := by
  have h1 : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) := Real.summable_one_div_nat_pow.mpr one_lt_two
  have h2 : Summable (fun n : ℕ => 1 / ((n + 1 : ℕ) : ℝ) ^ 2) := (summable_nat_add_iff 1).mpr h1
  have h3 := h2.mul_left (1 / Real.pi ^ 2)
  refine h3.congr ?_
  intro n
  unfold hterm
  push_cast
  field_simp

theorem summable_shift (m : ℕ) : Summable (fun k : ℕ => hterm (k + (m + 1))) :=
  (summable_nat_add_iff (m + 1)).mpr summable_hterm

theorem sigmaN_eq (m n : ℕ) :
    sigmaN m n = 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
  unfold sigmaN hterm
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  field_simp

theorem sigmaN_tendsto (m : ℕ) : Tendsto (fun n => sigmaN m n) atTop (𝓝 (sigma m)) := by
  unfold sigma
  have h := (summable_shift m).tendsto_sum_tsum_nat.comp (tendsto_sub_atTop_nat (m + 1))
  refine Tendsto.congr (fun n => ?_) h
  simp only [Function.comp, sigmaN]
  rw [Finset.sum_Ico_eq_sum_range]
  apply Finset.sum_congr rfl
  intro k _
  rw [add_comm]

theorem sigma_le (m : ℕ) : sigma m ≤ 1 / (Real.pi ^ 2 * ((m : ℝ) + 1)) := by
  apply le_of_tendsto (sigmaN_tendsto m)
  filter_upwards with n
  rw [sigmaN_eq]
  have h := sum_inv_sq_le m n
  have hpi : 0 < Real.pi := Real.pi_pos
  calc 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2
      ≤ 1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 1)) := mul_le_mul_of_nonneg_left h (by positivity)
    _ = _ := by field_simp

theorem sigma_ge (m : ℕ) : 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m := by
  have h0 : Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat
  have h1 : Tendsto (fun n : ℕ => 1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1))) atTop
      (𝓝 (1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 0))) := (h0.const_sub _).const_mul _
  have e : 1 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 0) = 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) := by
    rw [sub_zero]
    field_simp
  rw [e] at h1
  apply le_of_tendsto_of_tendsto h1 (sigmaN_tendsto m)
  filter_upwards [eventually_ge_atTop (m + 1)] with n hn
  rw [sigmaN_eq]
  exact mul_le_mul_of_nonneg_left (sum_inv_sq_ge_sharp m hn) (by positivity)

/-- `x_j = w²/(π²(j+1)²)`, so that `g w j = 1 + x w j`. -/
def x (w : ℂ) (j : ℕ) : ℂ := w ^ 2 / ((Real.pi : ℂ) ^ 2 * ((j : ℂ) + 1) ^ 2)

theorem g_eq (w : ℂ) (j : ℕ) : g w j = 1 + x w j := rfl

theorem x_eq_mul (w : ℂ) (j : ℕ) : x w j = w ^ 2 * ((hterm j : ℝ) : ℂ) := by
  unfold x hterm
  push_cast
  ring

theorem g_ne_zero {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    {j : ℕ} (hj : m + 1 ≤ j) : g w j ≠ 0 := by
  rw [g_eq]
  intro h
  have hx : ‖x w j‖ ≤ 1 / 2 := norm_x_le hsmall hj
  have : x w j = -1 := by linear_combination h
  rw [this, norm_neg, norm_one] at hx
  norm_num at hx

theorem T_eq_exp {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (n : ℕ) :
    T m w n = Complex.exp (∑ j ∈ Finset.Ico (m + 1) n, Complex.log (g w j)) := by
  rw [Complex.exp_sum]
  unfold T
  apply Finset.prod_congr rfl
  intro j hj
  rw [Complex.exp_log (g_ne_zero hsmall (Finset.mem_Ico.mp hj).1)]

/-- `δ_n = Σ (log(1 + x_j) − x_j)`. -/
def delta (m : ℕ) (w : ℂ) (n : ℕ) : ℂ :=
  ∑ j ∈ Finset.Ico (m + 1) n, (Complex.log (g w j) - x w j)

theorem norm_log_sub_le {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    {j : ℕ} (hj : m + 1 ≤ j) :
    ‖Complex.log (g w j) - x w j‖ ≤ ‖x w j‖ ^ 2 := by
  have hx : ‖x w j‖ ≤ 1 / 2 := norm_x_le hsmall hj
  have hx1 : ‖x w j‖ < 1 := by linarith
  have h := Complex.norm_log_one_add_sub_self_le hx1
  rw [g_eq]
  refine h.trans ?_
  have h2 : (1 - ‖x w j‖)⁻¹ ≤ 2 := by
    rw [inv_le_comm₀ (by linarith) (by norm_num)]
    norm_num
    linarith
  have h3 : 0 ≤ ‖x w j‖ ^ 2 := by positivity
  calc ‖x w j‖ ^ 2 * (1 - ‖x w j‖)⁻¹ / 2 ≤ ‖x w j‖ ^ 2 * 2 / 2 := by gcongr
    _ = ‖x w j‖ ^ 2 := by ring

/-- The quartic error `q = ‖w‖⁴/(π⁴(m+1)³)`. -/
def q (m : ℕ) (w : ℂ) : ℝ := ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)

theorem q_nonneg (m : ℕ) (w : ℂ) : 0 ≤ q m w := by
  unfold q
  positivity

theorem norm_delta_le {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (n : ℕ) :
    ‖delta m w n‖ ≤ q m w := by
  unfold delta q
  refine (norm_sum_le _ _).trans ?_
  have h1 : ∑ j ∈ Finset.Ico (m + 1) n, ‖Complex.log (g w j) - x w j‖
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, (‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2 := by
    apply Finset.sum_le_sum
    intro j hj
    have := norm_log_sub_le hsmall (Finset.mem_Ico.mp hj).1
    rwa [show ‖x w j‖ = ‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) from x_norm w j] at this
  refine h1.trans ?_
  have e : ∑ j ∈ Finset.Ico (m + 1) n, (‖w‖ ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2
      = ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    field_simp
    try ring
  rw [e]
  have hs4 : 0 ≤ ‖w‖ ^ 4 / Real.pi ^ 4 := by positivity
  calc ‖w‖ ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ ‖w‖ ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3) :=
        mul_le_mul_of_nonneg_left (sum_inv_pow4_le m n) hs4
    _ = _ := by field_simp

/-- **The split.** `T m w n = exp(w² σ_n) · exp(δ_n)`. -/
theorem T_eq_mul {m : ℕ} {w : ℂ} (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (n : ℕ) :
    T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n) := by
  rw [T_eq_exp hsmall n, ← Complex.exp_add]
  congr 1
  unfold delta sigmaN
  rw [Finset.sum_sub_distrib]
  push_cast
  rw [Finset.mul_sum]
  have : ∑ j ∈ Finset.Ico (m + 1) n, x w j
      = ∑ j ∈ Finset.Ico (m + 1) n, w ^ 2 * ((hterm j : ℝ) : ℂ) :=
    Finset.sum_congr rfl (fun j _ => x_eq_mul w j)
  rw [this]
  ring

theorem norm_exp_delta_sub_one_le {m : ℕ} {w : ℂ}
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) (n : ℕ) :
    ‖Complex.exp (delta m w n) - 1‖ ≤ 2 * q m w := by
  have h1 := norm_delta_le hsmall n
  have h2 := Complex.norm_exp_sub_one_le (h1.trans hq)
  linarith

/-- The principal part `P = exp(w² σ)`. -/
def P (m : ℕ) (w : ℂ) : ℂ := Complex.exp (w ^ 2 * ((sigma m : ℝ) : ℂ))

theorem P_tendsto (m : ℕ) (w : ℂ) :
    Tendsto (fun n => Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))) atTop (𝓝 (P m w)) := by
  unfold P
  apply Filter.Tendsto.cexp
  apply Filter.Tendsto.const_mul
  exact (Complex.continuous_ofReal.tendsto _).comp (sigmaN_tendsto m)

/-- **The principal part carries `S` up to `2q`.** -/
theorem norm_S_sub_le {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
    ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖
      ≤ 2 * q m w * ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ := by
  have hT := tendsto_S hne
  have hP := (P_tendsto m w).const_mul (((cS m / D m : ℝ) : ℂ) * w)
  have hlim := (hT.sub hP).norm
  have hR := hP.norm.const_mul (2 * q m w)
  apply le_of_tendsto_of_tendsto hlim hR
  filter_upwards with n
  rw [T_eq_mul hsmall n]
  have e : ((cS m / D m : ℝ) : ℂ) * w
        * (Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n))
      - ((cS m / D m : ℝ) : ℂ) * w * Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))
      = ((cS m / D m : ℝ) : ℂ) * w * Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))
        * (Complex.exp (delta m w n) - 1) := by ring
  rw [e, norm_mul]
  exact (mul_comm _ _).le.trans
    (mul_le_mul_of_nonneg_right (norm_exp_delta_sub_one_le hsmall hq n) (norm_nonneg _))

theorem norm_A_sq (m : ℕ) (w : ℂ) :
    ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2
      = (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) := by
  unfold P
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m),
    Complex.norm_exp]
  have hre : (w ^ 2 * ((sigma m : ℝ) : ℂ)).re = (w ^ 2).re * sigma m := by
    simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, sub_zero]
  rw [hre, show 2 * (w ^ 2).re * sigma m = (w ^ 2).re * sigma m + (w ^ 2).re * sigma m by ring,
    Real.exp_add]
  ring

/-- **The real part of the principal part squared, explicitly.** -/
theorem re_A_sq (m : ℕ) (w : ℂ) :
    ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re
      = (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
        * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m)
          - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m)) := by
  have e1 : (((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2
      = ((cS m / D m : ℝ) : ℂ) ^ 2
        * (w ^ 2 * Complex.exp (w ^ 2 * ((sigma m : ℝ) : ℂ) + w ^ 2 * ((sigma m : ℝ) : ℂ))) := by
    unfold P
    rw [Complex.exp_add]
    ring
  have hc_re : (((cS m / D m : ℝ) : ℂ) ^ 2).re = (cS m / D m) ^ 2 := by
    rw [← Complex.ofReal_pow, Complex.ofReal_re]
  have hc_im : (((cS m / D m : ℝ) : ℂ) ^ 2).im = 0 := by
    rw [← Complex.ofReal_pow, Complex.ofReal_im]
  have hz_re : (w ^ 2 * ((sigma m : ℝ) : ℂ) + w ^ 2 * ((sigma m : ℝ) : ℂ)).re
      = 2 * (w ^ 2).re * sigma m := by
    simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, sub_zero]
    ring
  have hz_im : (w ^ 2 * ((sigma m : ℝ) : ℂ) + w ^ 2 * ((sigma m : ℝ) : ℂ)).im
      = 2 * (w ^ 2).im * sigma m := by
    simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, mul_zero, zero_add]
    ring
  rw [e1, Complex.mul_re, Complex.mul_re, Complex.exp_re, Complex.exp_im, hc_re, hc_im, hz_re, hz_im]
  ring

/-- **The lower bound on `Re (S m w)²`.** -/
theorem re_sq_ge {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
    ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re
      - ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 * (4 * q m w + 4 * q m w ^ 2)
      ≤ ((S m w) ^ 2).re := by
  set A := ((cS m / D m : ℝ) : ℂ) * w * P m w with hA
  have hEn : ‖S m w - A‖ ≤ 2 * q m w * ‖A‖ := norm_S_sub_le hne hsmall hq
  set E := S m w - A with hE
  have hS : S m w = A + E := by rw [hE]; ring
  rw [hS]
  have e2 : ((A + E) ^ 2).re = (A ^ 2).re + (2 * A * E + E ^ 2).re := by
    rw [show (A + E) ^ 2 = A ^ 2 + (2 * A * E + E ^ 2) by ring, Complex.add_re]
  rw [e2]
  have h1 : |(2 * A * E + E ^ 2).re| ≤ ‖2 * A * E + E ^ 2‖ := Complex.abs_re_le_norm _
  have h2a : ‖(2 : ℂ)‖ = 2 := by norm_num
  have h2 : ‖2 * A * E + E ^ 2‖ ≤ 2 * ‖A‖ * ‖E‖ + ‖E‖ ^ 2 := by
    refine (norm_add_le _ _).trans ?_
    rw [norm_mul, norm_mul, norm_pow, h2a]
  have hA0 : 0 ≤ ‖A‖ := norm_nonneg _
  have hE0 : 0 ≤ ‖E‖ := norm_nonneg _
  have hq0 : 0 ≤ q m w := q_nonneg m w
  have h3 : 2 * ‖A‖ * ‖E‖ + ‖E‖ ^ 2 ≤ ‖A‖ ^ 2 * (4 * q m w + 4 * q m w ^ 2) := by
    nlinarith [mul_le_mul_of_nonneg_left hEn hA0, pow_le_pow_left₀ hE0 hEn 2]
  have h5 : -‖2 * A * E + E ^ 2‖ ≤ (2 * A * E + E ^ 2).re := neg_le_of_abs_le h1
  linarith

/-- **The deliverable.** -/
theorem re_S_sq_ge {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hq : q m w ≤ 1) :
    (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
        * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m)
          - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m))
      - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m)
        * (4 * q m w + 4 * q m w ^ 2)
      ≤ ((S m w) ^ 2).re := by
  have h := re_sq_ge hne hsmall hq
  rw [re_A_sq, norm_A_sq] at h
  exact h

end

/-- info: 'WeilPowerPhase.sigma_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sigma_ge

/-- info: 'WeilPowerPhase.T_eq_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms T_eq_mul

/-- info: 'WeilPowerPhase.norm_S_sub_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_sub_le

/-- info: 'WeilPowerPhase.re_S_sq_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms re_S_sq_ge

end WeilPowerPhase
