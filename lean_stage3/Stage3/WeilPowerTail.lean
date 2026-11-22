/-
WeilPowerTail — the tail bound: an upper bound on `‖S m w‖` for every `w`,
with no regime. Block 16a of `lean_stage3/design/rung5.md` (section 16, its
line T12). 2026-11-22. Priced in unit 0378.

Section 16 annihilates the cluster around the target with a polynomial
factor of the transform, and then every other zero has to be carried by an
upper bound on `S`. The tree had two: the Gaussian bound
`WeilPowerSharp.norm_S_le_c_neg`, inside the regime `‖w‖² ≤ π²(m+2)²/2`
and with the exponent `Re(w²)(m+2)/(π²(2m+3)²) + ‖w‖⁴/(π⁴(m+1)³)`, and the
far bound `WeilPowerBounds.norm_S_le_far`. Unit 0378 priced them at real
part offset `1/2`: the first stops closing at height distance `1.233` and
its regime ends at `2.164`; the second starts at `4.499`. This module is
the bound that covers the hole.

It is the product's own first two terms. `S m w = (cS m/D m)·w·∏_{j>m} g w j`
with `g w j = 1 + w²·hterm j` (`WeilPowerGauss.tendsto_S`), and for any
complex `z`, `‖1 + z‖ ≤ exp(Re z + ‖z‖²/2)`, because
`‖1 + z‖² = 1 + 2 Re z + ‖z‖² ≤ exp(2 Re z + ‖z‖²)`. Summing over the tail
gives `Re(w²)·sigma m` exactly and a quartic term bounded by a telescoping
sum of fourth powers.

  sum_inv_pow4_le_third   m + 1 ≤ n:
        Σ_{j=m+1}^{n−1} 1/(j+1)⁴ ≤ (1/3)·(1/(m+1)³ − 1/n³)
  sum_hterm_sq_le         Σ_{j=m+1}^{n−1} hterm j ² ≤ 1/(3π⁴(m+1)³)
  norm_one_add_le         ‖1 + z‖ ≤ exp(Re z + ‖z‖²/2)
  norm_g_le               ‖g w j‖ ≤ exp(Re(w²)·hterm j + ‖w‖⁴·hterm j ²/2)
  norm_T_le_tail          ‖T m w n‖ ≤ exp(Re(w²)·sigmaN m n + ‖w‖⁴/(6π⁴(m+1)³))
  norm_S_le_tail          QS m w ≠ 0:
        ‖S m w‖ ≤ (cS m/D m)·‖w‖·exp(Re(w²)·sigma m + ‖w‖⁴/(6π⁴(m+1)³))

The one hypothesis is `QS m w ≠ 0`, which `tendsto_S` needs; at an off-line
zero it is `WeilPowerBounds.QS_ne_zero` (`w.re ≠ 0`). The `1/6` is needed:
with the tree's `sum_inv_pow4_le`, whose constant is `1`, the quartic term
would be `‖w‖⁴/(2π⁴(m+1)³)` and at offset `1/2` the exponent would turn
positive at height distance `4.44`, below the far bound's `4.499`.

What the next slice needs: the multiplied window of section 16 (T1, T2),
whose term at a zero is `−p(s)²·what(s)²`; this bound is then applied to
`what` at every zero that is neither annihilated nor kept.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilPowerPhase

namespace WeilPowerTail

noncomputable section

open Complex WeilPower WeilOddPower WeilPowerBounds WeilPowerGauss WeilPowerSharp
  WeilPowerPhase Real Filter Topology

/-- The fourth-power tail, telescoped: `1/(k+1)⁴ ≤ (1/3)(1/k³ − 1/(k+1)³)`. -/
theorem sum_inv_pow4_le_third (m : ℕ) : ∀ n : ℕ, m + 1 ≤ n →
    ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
      ≤ 1 / 3 * (1 / ((m : ℝ) + 1) ^ 3 - 1 / (n : ℝ) ^ 3) := by
  intro n hn
  induction n, hn using Nat.le_induction with
  | base =>
    simp only [Finset.Ico_self, Finset.sum_empty]
    push_cast
    simp
  | succ k hk ih =>
    rw [Finset.sum_Ico_succ_top hk]
    have hk1 : 1 ≤ k := by omega
    have hk0 : (0 : ℝ) < (k : ℝ) := by exact_mod_cast hk1
    have e : 1 / 3 * (1 / (k : ℝ) ^ 3 - 1 / ((k : ℝ) + 1) ^ 3) - 1 / ((k : ℝ) + 1) ^ 4
        = (6 * (k : ℝ) ^ 2 + 4 * (k : ℝ) + 1) / (3 * (k : ℝ) ^ 3 * ((k : ℝ) + 1) ^ 4) := by
      field_simp
      try ring
    have hpos : 0 ≤ (6 * (k : ℝ) ^ 2 + 4 * (k : ℝ) + 1) / (3 * (k : ℝ) ^ 3 * ((k : ℝ) + 1) ^ 4) := by
      positivity
    push_cast
    linarith

/-- The squared tail weights sum to at most `1/(3π⁴(m+1)³)`. -/
theorem sum_hterm_sq_le (m n : ℕ) :
    ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2 ≤ 1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
  have hpi : (0 : ℝ) < Real.pi := Real.pi_pos
  have hm : (0 : ℝ) < (m : ℝ) + 1 := by positivity
  have e : ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2
      = 1 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4 := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro j _
    unfold hterm
    field_simp
  rw [e]
  by_cases hn : m + 1 ≤ n
  · have h := sum_inv_pow4_le_third m n hn
    have hn0 : (0 : ℝ) ≤ 1 / (n : ℝ) ^ 3 := by positivity
    have h2 : ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
        ≤ 1 / 3 * (1 / ((m : ℝ) + 1) ^ 3) := by linarith
    have hpi4 : (0 : ℝ) ≤ 1 / Real.pi ^ 4 := by positivity
    calc 1 / Real.pi ^ 4 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 4
        ≤ 1 / Real.pi ^ 4 * (1 / 3 * (1 / ((m : ℝ) + 1) ^ 3)) :=
          mul_le_mul_of_nonneg_left h2 hpi4
      _ = 1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
          field_simp
  · have hempty : Finset.Ico (m + 1) n = ∅ := Finset.Ico_eq_empty_of_le (by omega)
    rw [hempty, Finset.sum_empty, mul_zero]
    positivity

/-- `‖1 + z‖ ≤ exp(Re z + ‖z‖²/2)`, for every complex `z`. -/
theorem norm_one_add_le (z : ℂ) : ‖1 + z‖ ≤ Real.exp (z.re + ‖z‖ ^ 2 / 2) := by
  have h1 : ‖1 + z‖ ^ 2 = 1 + 2 * z.re + ‖z‖ ^ 2 := by
    rw [Complex.sq_norm, Complex.sq_norm, Complex.normSq_apply, Complex.normSq_apply]
    simp only [Complex.add_re, Complex.add_im, Complex.one_re, Complex.one_im]
    ring
  have h2 : 1 + 2 * z.re + ‖z‖ ^ 2 ≤ Real.exp (2 * z.re + ‖z‖ ^ 2) := by
    have := Real.add_one_le_exp (2 * z.re + ‖z‖ ^ 2)
    linarith
  have h3 : Real.exp (2 * z.re + ‖z‖ ^ 2) = Real.exp (z.re + ‖z‖ ^ 2 / 2) ^ 2 := by
    rw [← Real.exp_nat_mul]
    congr 1
    push_cast
    ring
  have h4 : ‖1 + z‖ ^ 2 ≤ Real.exp (z.re + ‖z‖ ^ 2 / 2) ^ 2 := by
    rw [h1, ← h3]
    exact h2
  have h5 := abs_le_of_sq_le_sq h4 (Real.exp_pos _).le
  rwa [abs_of_nonneg (norm_nonneg _)] at h5

/-- One factor of the tail product. -/
theorem norm_g_le (w : ℂ) (j : ℕ) :
    ‖g w j‖ ≤ Real.exp ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2) := by
  rw [g_eq, x_eq_mul]
  have h := norm_one_add_le (w ^ 2 * ((hterm j : ℝ) : ℂ))
  have hre : (w ^ 2 * ((hterm j : ℝ) : ℂ)).re = (w ^ 2).re * hterm j := by
    rw [mul_comm, Complex.re_ofReal_mul]
    ring
  have hnorm : ‖w ^ 2 * ((hterm j : ℝ) : ℂ)‖ ^ 2 = ‖w‖ ^ 4 * hterm j ^ 2 := by
    rw [norm_mul, norm_pow, Complex.norm_real, Real.norm_eq_abs, mul_pow, sq_abs]
    ring
  rw [hre, hnorm] at h
  exact h

/-- **The tail product, bounded with the partial tail sum.** -/
theorem norm_T_le_tail (m : ℕ) (w : ℂ) (n : ℕ) :
    ‖T m w n‖ ≤ Real.exp ((w ^ 2).re * sigmaN m n
      + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  unfold T
  rw [norm_prod]
  have hs : ∑ j ∈ Finset.Ico (m + 1) n, ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2)
      = (w ^ 2).re * sigmaN m n + ‖w‖ ^ 4 / 2 * ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2 := by
    unfold sigmaN
    rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]
    congr 1
    apply Finset.sum_congr rfl
    intro j _
    ring
  have h4 := sum_hterm_sq_le m n
  have hw : 0 ≤ ‖w‖ ^ 4 / 2 := by positivity
  have h5 : ‖w‖ ^ 4 / 2 * ∑ j ∈ Finset.Ico (m + 1) n, hterm j ^ 2
      ≤ ‖w‖ ^ 4 / 2 * (1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) :=
    mul_le_mul_of_nonneg_left h4 hw
  have e : ‖w‖ ^ 4 / 2 * (1 / (3 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))
      = ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3) := by
    have hpi : Real.pi ≠ 0 := Real.pi_ne_zero
    have hm : ((m : ℝ) + 1) ≠ 0 := by positivity
    field_simp
    try ring
  calc ∏ j ∈ Finset.Ico (m + 1) n, ‖g w j‖
      ≤ ∏ j ∈ Finset.Ico (m + 1) n,
          Real.exp ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2) :=
        Finset.prod_le_prod (fun j _ => norm_nonneg _) (fun j _ => norm_g_le w j)
    _ = Real.exp (∑ j ∈ Finset.Ico (m + 1) n,
          ((w ^ 2).re * hterm j + ‖w‖ ^ 4 * hterm j ^ 2 / 2)) := by
        rw [Real.exp_sum]
    _ ≤ Real.exp ((w ^ 2).re * sigmaN m n
          + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
        apply Real.exp_le_exp.mpr
        rw [hs]
        linarith

/-- **The tail bound.** For every `w` with `QS m w ≠ 0`, no regime:
`‖S m w‖ ≤ (cS m/D m)·‖w‖·exp(Re(w²)·sigma m + ‖w‖⁴/(6π⁴(m+1)³))`. -/
theorem norm_S_le_tail {m : ℕ} {w : ℂ} (hne : QS m w ≠ 0) :
    ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * sigma m
      + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) := by
  have hlim := (tendsto_S hne).norm
  have hc : Continuous (fun s : ℝ => cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * s
      + ‖w‖ ^ 4 / (6 * Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3))) := by
    fun_prop
  have hr := (hc.tendsto (sigma m)).comp (sigmaN_tendsto m)
  refine le_of_tendsto_of_tendsto hlim hr ?_
  filter_upwards with n
  simp only [Function.comp]
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, abs_of_pos (cprime_pos m)]
  exact mul_le_mul_of_nonneg_left (norm_T_le_tail m w n)
    (mul_nonneg (cprime_pos m).le (norm_nonneg _))

end

/-- info: 'WeilPowerTail.sum_inv_pow4_le_third' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms sum_inv_pow4_le_third

/-- info: 'WeilPowerTail.norm_one_add_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_one_add_le

/-- info: 'WeilPowerTail.norm_T_le_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_T_le_tail

/-- info: 'WeilPowerTail.norm_S_le_tail' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_S_le_tail

end WeilPowerTail
