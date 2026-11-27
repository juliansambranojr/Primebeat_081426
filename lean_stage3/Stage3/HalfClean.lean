/-
# Stage3.HalfClean — the wobble with the prime squares taken out

Measured (scratch, exploratory, 2026-11-26, 1200 values of N from 10⁴ to 10⁷): the wobble's
steady offset, `0.105 √N` on average, is `0.091 √N` from the prime squares, `½ Li(√N) − ½ Li(N^¼)`,
the term of Riemann's explicit formula (1859) by which π(x) runs about `½ Li(√x)` below `Li(x)`.
Less it the wobble averages `0.013 √N` with spread `0.020 √N`. This file takes it out: the cleaned
wobble and the wobble differ by at most a constant times `√N`, so `WobbleSqrt` holds for one exactly
when it holds for the other.
-/
import Stage3.HalfSieve

namespace HalfClean

open Real

/-- `Li` is nonnegative and at most `4x` from `2` on. -/
theorem Li_bounds {x : ℝ} (hx : 2 ≤ x) : 0 ≤ Stage3.Li x ∧ Stage3.Li x ≤ 4 * x := by
  unfold Stage3.Li
  have hlog2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9; linarith
  have hlogx : Real.log 2 ≤ Real.log x := Real.log_le_log (by norm_num) hx
  have hlx : 0 < Real.log x := by linarith
  have hint_nonneg : 0 ≤ ∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2 := by
    apply intervalIntegral.integral_nonneg hx
    intro t _; positivity
  have hint_le : (∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2) ≤ ∫ t in (2 : ℝ)..x, 1 / Real.log 2 ^ 2 := by
    apply intervalIntegral.integral_mono_on hx
    · apply ContinuousOn.intervalIntegrable
      rw [Set.uIcc_of_le hx]
      apply ContinuousOn.div continuousOn_const
      · exact (Real.continuousOn_log.mono (fun t ht => by
          simp only [Set.mem_compl_iff, Set.mem_singleton_iff]; linarith [ht.1])).pow 2
      · intro t ht
        have : 0 < Real.log t := Real.log_pos (by linarith [ht.1])
        positivity
    · exact intervalIntegrable_const
    · intro t ht
      have h1 : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) ht.1
      have h2 : 0 < Real.log 2 := by linarith
      apply one_div_le_one_div_of_le (by positivity)
      exact pow_le_pow_left₀ h2.le h1 2
  rw [intervalIntegral.integral_const, smul_eq_mul] at hint_le
  have hdiv : x / Real.log x ≤ x / 0.69 := by
    apply div_le_div_of_nonneg_left (by linarith) (by norm_num); linarith
  have hsq : (0.47 : ℝ) < Real.log 2 ^ 2 := by nlinarith
  have hc : (x - 2) * (1 / Real.log 2 ^ 2) ≤ x / 0.47 := by
    rw [mul_one_div]
    apply le_trans (div_le_div_of_nonneg_right (by linarith : x - 2 ≤ x) (by positivity))
    apply div_le_div_of_nonneg_left (by linarith) (by norm_num) hsq.le
  constructor
  · have : 0 ≤ x / Real.log x := div_nonneg (by linarith) hlx.le
    linarith
  · have h1 : x / 0.69 ≤ 1.5 * x := by rw [div_le_iff₀ (by norm_num)]; nlinarith
    have h2 : x / 0.47 ≤ 2.5 * x := by rw [div_le_iff₀ (by norm_num)]; nlinarith
    linarith

/-- The prime squares' share of the wobble. -/
noncomputable def squares (N : ℕ) : ℝ :=
  (1 / 2) * Stage3.Li (Real.sqrt N) - (1 / 2) * Stage3.Li (Real.sqrt (Real.sqrt N))

/-- The wobble with the prime squares taken out. -/
noncomputable def cleanWobble (N : ℕ) : ℝ := HalfSieve.wobble N - squares N

/-- **The prime squares' share is at most `2√N`** from `N = 16` on. -/
theorem abs_squares_le {N : ℕ} (hN : 16 ≤ N) : |squares N| ≤ 2 * Real.sqrt N := by
  have h16 : (16 : ℝ) ≤ N := by exact_mod_cast hN
  have hs : (4 : ℝ) ≤ Real.sqrt N := by
    rw [show (4 : ℝ) = Real.sqrt 16 by rw [show (16 : ℝ) = 4 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]]
    exact Real.sqrt_le_sqrt h16
  have hss : (2 : ℝ) ≤ Real.sqrt (Real.sqrt N) := by
    rw [show (2 : ℝ) = Real.sqrt 4 by rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]]
    exact Real.sqrt_le_sqrt hs
  have hle : Real.sqrt (Real.sqrt N) ≤ Real.sqrt N := by
    rw [Real.sqrt_le_left]
    · nlinarith
    · linarith
  obtain ⟨a0, a1⟩ := Li_bounds (by linarith : (2 : ℝ) ≤ Real.sqrt N)
  obtain ⟨b0, b1⟩ := Li_bounds hss
  unfold squares
  rw [abs_le]; constructor <;> nlinarith

/-- **`WobbleSqrt` for the cleaned wobble gives it for the wobble.** -/
theorem wobbleSqrt_of_clean {C : ℝ} {N₀ : ℕ}
    (h : ∀ N ≥ N₀, |cleanWobble N| ≤ C * Real.sqrt N * Real.log N) : HalfSieve.WobbleSqrt := by
  refine ⟨C + 2, max N₀ 16, fun N hN => ?_⟩
  have hN0 : N₀ ≤ N := le_trans (le_max_left _ _) hN
  have hN16 : 16 ≤ N := le_trans (le_max_right _ _) hN
  have hlog : 1 ≤ Real.log N := by
    rw [Real.le_log_iff_exp_le (by positivity)]
    have : Real.exp 1 < 3 := lt_trans Real.exp_one_lt_d9 (by norm_num)
    have : (16 : ℝ) ≤ N := by exact_mod_cast hN16
    linarith
  have hsq : 0 ≤ Real.sqrt N := Real.sqrt_nonneg _
  have hw : HalfSieve.wobble N = cleanWobble N + squares N := by unfold cleanWobble; ring
  rw [hw]
  calc _ ≤ |cleanWobble N| + |squares N| := abs_add_le _ _
    _ ≤ C * Real.sqrt N * Real.log N + 2 * Real.sqrt N := add_le_add (h N hN0) (abs_squares_le hN16)
    _ ≤ (C + 2) * Real.sqrt N * Real.log N := by nlinarith

end HalfClean

/-- info: 'HalfClean.wobbleSqrt_of_clean' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms HalfClean.wobbleSqrt_of_clean
