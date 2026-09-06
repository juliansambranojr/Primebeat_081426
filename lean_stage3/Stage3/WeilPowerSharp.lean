/-
WeilPowerSharp — the Gaussian bounds with the constant kept exact and the
tail sum sharp: the two lost factors of WeilPowerGauss removed. Rung 5,
eleventh slice. 2026-09-06. Unit 0346; the decision is unit 0345.

Unit 0333's lower bound at the target carried two losses against its upper
bound at any zero. The constant `cS m / D m` was bounded below by
`4/(π(m+1)(2m+3))` and above by `4/(π(m+1))`, a factor `2m+3`. The tail
sum `Σ_{j≥m+2} 1/j²` was bounded below by `(m+2)/(2m+3)²` and above by
`1/(m+1)`, a factor near 4 in the growth rate. With `m ~ h` the first is
polynomial in `h` and the second makes the target's proven rate a quarter
of a competitor's, so worksheet § 7's suppression only held for zeros a
constant factor below the target in `ε'² − Δ²`. Both are design failures
(CLAUDE.md § Rule — a lost factor is a design failure), and worksheet § 13's
averaging route needs them gone.

This module keeps `cS m / D m` unbounded on both sides and replaces the
tail-sum lower bound by the telescoping one `1/(j+1)² ≥ 1/((j+1)(j+2))`:

  sum_telescope         Σ_{j=m+1}^{n−1} 1/((j+1)(j+2)) = 1/(m+2) − 1/(n+1)      (m+1 ≤ n)
  sum_inv_sq_ge_sharp   1/(m+2) − 1/(n+1) ≤ Σ_{j=m+1}^{n−1} 1/(j+1)²            (m+1 ≤ n)
  Tr_ge_sharp           exp(s²/π² · (1/(m+2) − 1/(n+1)) − s⁴/(π⁴(m+1)³)) ≤ Tr m s n
  S_real_ge_sharp       0 < s:  (cS m/D m) · s · exp(s²/(π²(m+2)) − s⁴/(π⁴(m+1)³)) ≤ Re (S m s)
  norm_S_le_c_pos       0 ≤ Re(w²):
        ‖S m w‖ ≤ (cS m/D m) · ‖w‖ · exp(Re(w²)/(π²(m+1)) + ‖w‖⁴/(π⁴(m+1)³))
  norm_S_le_c_neg       Re(w²) ≤ 0:
        ‖S m w‖ ≤ (cS m/D m) · ‖w‖ · exp(Re(w²)(m+2)/(π²(2m+3)²) + ‖w‖⁴/(π⁴(m+1)³))
  compare_sharp         0 ≤ Re(w²), 0 < s, both in the regime `‖·‖² ≤ π²(m+2)²/2`:
        ‖S m w‖ ≤ (‖w‖/s) · exp((Re(w²) − s²)/(π²(m+1)) + s²/(π²(m+1)(m+2))
                                  + (‖w‖⁴ + s⁴)/(π⁴(m+1)³)) · Re (S m s)

The comparison's prefactor is `‖w‖/s` with no power of `m`; the exponent
difference is `(Re(w²) − s²)/(π²(m+1))` up to `s²/(π²(m+1)(m+2))`, which at
`s = εh`, `m+1 = λh` is the constant `ε²/(π²λ²)`, and the two quartic
errors. The limit in `S_real_ge_sharp` is taken with both sides moving
(`le_of_tendsto_of_tendsto`), since the sharp tail sum depends on `n`.

What the next slice needs: the same sharpening for `Re(w²) ≤ 0` (the `neg`
exponent still carries `(m+2)/(2m+3)²`), and the phase of the tail
product, a bound on `‖T m w n − 1‖`, for worksheet § 13.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerGauss

namespace WeilPowerSharp

noncomputable section

open Complex WeilPower WeilOddPower WeilPowerBounds WeilPowerGauss Real Filter Topology

/-- Telescoping sum over the tail. -/
theorem sum_telescope (m : ℕ) : ∀ n : ℕ, m + 1 ≤ n →
    ∑ j ∈ Finset.Ico (m + 1) n, 1 / (((j : ℝ) + 1) * ((j : ℝ) + 2))
      = 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) := by
  intro n hn
  induction n, hn using Nat.le_induction with
  | base =>
    simp only [Finset.Ico_self, Finset.sum_empty]
    push_cast
    ring
  | succ n hn ih =>
    rw [Finset.sum_Ico_succ_top hn, ih]
    push_cast
    field_simp
    ring

/-- The sharp lower bound for the tail sum: `1/(m+2) − 1/(n+1)`. -/
theorem sum_inv_sq_ge_sharp (m : ℕ) {n : ℕ} (hn : m + 1 ≤ n) :
    1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
  rw [← sum_telescope m n hn]
  apply Finset.sum_le_sum
  intro j _
  have h1 : (0 : ℝ) < (j : ℝ) + 1 := by positivity
  have h2 : (0 : ℝ) < (j : ℝ) + 2 := by positivity
  rw [div_le_div_iff₀ (by positivity) (by positivity)]
  nlinarith

/-- Tail product lower bound with the sharp sum. -/
theorem Tr_ge_sharp {m : ℕ} {s : ℝ} (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    {n : ℕ} (hn : m + 1 ≤ n) :
    Real.exp (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1))
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n := by
  have hpi : 0 < Real.pi := Real.pi_pos
  have hx : ∀ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) ≤ 1 / 2 := by
    intro j hj
    have hjm := (Finset.mem_Ico.mp hj).1
    have hj' : (m : ℝ) + 2 ≤ (j : ℝ) + 1 := by
      have : m + 2 ≤ j + 1 := by omega
      exact_mod_cast this
    rw [div_le_iff₀ (by positivity)]
    calc s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 := hsmall
      _ ≤ Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2 / 2 := by gcongr
      _ = 1 / 2 * (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by ring
  have h1 : ∏ j ∈ Finset.Ico (m + 1) n, Real.exp (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
      - (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2) ≤ Tr m s n := by
    unfold Tr
    apply Finset.prod_le_prod (fun _ _ => (Real.exp_pos _).le)
    intro j hj
    exact exp_le_one_add (by positivity) (hx j hj)
  rw [← Real.exp_sum] at h1
  refine le_trans (Real.exp_le_exp.mpr ?_) h1
  rw [Finset.sum_sub_distrib]
  have hA : s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1))
      ≤ ∑ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2) := by
    have e : ∑ j ∈ Finset.Ico (m + 1) n, s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)
        = s ^ 2 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
    rw [e]
    exact mul_le_mul_of_nonneg_left (sum_inv_sq_ge_sharp m hn) (by positivity)
  have hB : ∑ j ∈ Finset.Ico (m + 1) n, (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2
      ≤ s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    have e : ∑ j ∈ Finset.Ico (m + 1) n, (s ^ 2 / (Real.pi ^ 2 * ((j : ℝ) + 1) ^ 2)) ^ 2
        = s ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 := by
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
      try ring
    rw [e]
    have hs4 : 0 ≤ s ^ 4 / Real.pi ^ 4 := by positivity
    calc s ^ 4 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
        ≤ s ^ 4 / Real.pi ^ 4 * (1 / ((m : ℝ) + 1) ^ 3) :=
          mul_le_mul_of_nonneg_left (sum_inv_pow4_le m n) hs4
      _ = _ := by field_simp
  linarith

/-- **Lower bound at the target, sharp.** The constant is `cS m / D m` itself and the
rate is `s²/(π²(m+2))`. -/
theorem S_real_ge_sharp {m : ℕ} {s : ℝ} (hs : 0 < s)
    (hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) :
    cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2))
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re := by
  have hne : QS m (s : ℂ) ≠ 0 := QS_ne_zero (by simpa using hs.ne')
  have hlim := (Complex.continuous_re.tendsto _).comp (tendsto_S hne)
  have h0 : Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat
  have h1 : Tendsto (fun n : ℕ => s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1))
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) atTop
      (𝓝 (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 0) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))) :=
    ((h0.const_sub _).const_mul _).sub_const _
  have e : s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 0) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)
      = s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    rw [sub_zero]
    field_simp
  rw [e] at h1
  have hlow := ((Real.continuous_exp.tendsto _).comp h1).const_mul (cS m / D m * s)
  apply le_of_tendsto_of_tendsto hlow hlim
  filter_upwards [eventually_ge_atTop (m + 1)] with n hn
  simp only [Function.comp]
  rw [T_ofReal]
  have e2 : (((cS m / D m : ℝ) : ℂ) * (s : ℂ) * ((Tr m s n : ℝ) : ℂ)).re = cS m / D m * s * Tr m s n := by
    have : ((cS m / D m : ℝ) : ℂ) * (s : ℂ) * ((Tr m s n : ℝ) : ℂ)
        = ((cS m / D m * s * Tr m s n : ℝ) : ℂ) := by push_cast; ring
    rw [this, Complex.ofReal_re]
  rw [e2]
  exact mul_le_mul_of_nonneg_left (Tr_ge_sharp hsmall hn) (mul_nonneg (cprime_pos m).le hs.le)

/-- **Upper bound, `Re(w²) ≥ 0`, constant kept.** -/
theorem norm_S_le_c_pos {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : 0 ≤ (w ^ 2).re) :
    ‖S m w‖ ≤ cS m / D m * ‖w‖
      * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  have hlim := (tendsto_S hne).norm
  apply le_of_tendsto hlim
  filter_upwards with n
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m)]
  exact mul_le_mul_of_nonneg_left (norm_T_le_pos hsmall hre n)
    (mul_nonneg (cprime_pos m).le (norm_nonneg _))

/-- **Upper bound, `Re(w²) ≤ 0`, constant kept.** The exponent is unit 0333's. -/
theorem norm_S_le_c_neg {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0)
    (hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : (w ^ 2).re ≤ 0) :
    ‖S m w‖ ≤ cS m / D m * ‖w‖
      * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2)
          + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  have hlim := (tendsto_S hne).norm
  apply le_of_tendsto hlim
  filter_upwards [eventually_ge_atTop (2 * m + 3)] with n hn
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m)]
  exact mul_le_mul_of_nonneg_left (norm_T_le_neg hsmall hre hn)
    (mul_nonneg (cprime_pos m).le (norm_nonneg _))

/-- **The comparison with no lost factor.** For `0 ≤ Re(w²)`, `0 < s`, both in the regime,
`‖S m w‖ ≤ (‖w‖/s) · exp(E) · Re (S m s)` with
`E = (Re(w²) − s²)/(π²(m+1)) + s²/(π²(m+1)(m+2)) + (‖w‖⁴ + s⁴)/(π⁴(m+1)³)`. -/
theorem compare_sharp {m : ℕ} {w : ℂ} {s : ℝ} (hne : QS m w ≠ 0) (hs : 0 < s)
    (hw : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hsm : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2) (hre : 0 ≤ (w ^ 2).re) :
    ‖S m w‖ ≤ ‖w‖ / s * Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((m : ℝ) + 1))
      + s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 1) * ((m : ℝ) + 2))
      + (‖w‖ ^ 4 + s ^ 4) / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) * (S m (s : ℂ)).re := by
  have hU := norm_S_le_c_pos hne hw hre
  have hL := S_real_ge_sharp hs hsm
  have hc := cprime_pos m
  have hpi : 0 < Real.pi := Real.pi_pos
  have hs0 : s ≠ 0 := hs.ne'
  have hBpos : 0 < Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2))
      - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := Real.exp_pos _
  have hE : Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))
      / Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))
      = Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((m : ℝ) + 1))
      + s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 1) * ((m : ℝ) + 2))
      + (‖w‖ ^ 4 + s ^ 4) / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
    rw [← Real.exp_sub]
    congr 1
    field_simp
    ring
  rw [← hE]
  calc ‖S m w‖
      ≤ cS m / D m * ‖w‖
        * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := hU
    _ = ‖w‖ / s * (Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))
          / Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)))
        * (cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2))
          - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))) := by
        field_simp
        try ring
    _ ≤ _ := by
        apply mul_le_mul_of_nonneg_left hL
        positivity

end

/-- info: 'WeilPowerSharp.sum_inv_sq_ge_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_inv_sq_ge_sharp

/-- info: 'WeilPowerSharp.S_real_ge_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms S_real_ge_sharp

/-- info: 'WeilPowerSharp.norm_S_le_c_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_c_pos

/-- info: 'WeilPowerSharp.compare_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms compare_sharp

end WeilPowerSharp
