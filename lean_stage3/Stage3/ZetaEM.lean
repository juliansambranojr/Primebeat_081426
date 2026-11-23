/-
ZetaEM — block C3 of `lean_stage3/design/carlson.md`. 2026-11-23.

Euler–Maclaurin for the Riemann zeta function to any order `k ≥ 1` on `Re s > 0`, with
the remainder bounded. The periodic Bernoulli function `P_k(x) = B_k({x})` has right
derivative `k·P_{k-1}` everywhere and is continuous for `k ≠ 1`, so one integration by parts
on `[a, b]` needs no splitting at the integers. Passing `b → ∞` gives the step
`(k+1)·I_k = −B_{k+1}({a})·a^{−s−k} + (s+k)·I_{k+1}` for the tail integrals
`I_k(a, s) = ∫_{x>a} P_k(x)·x^{−s−k} dx`. The base case is PNT+'s `Zeta0EqZeta`, and the
induction on `k` gives the formula with the boundary terms `emTerm` and the remainder `emRem`.

  emInt                       I_k(N, s) = ∫_{x>N} B_k({x})·x^{−(s+k)}
  emCoef                      −s(s+1)⋯(s+k−1)/k!
  emTerm                      s(s+1)⋯(s+j−1)·B_{j+1}(0)/(j+1)!·N^{−(s+j)}
  emBoundary                  Σ_{1 ≤ j < k} emTerm j N s
  emRem                       emCoef k s · emInt k N s
  bernBound                   sup_{[0,1]} |B_k|
  emConst                     the constant A k of the corollary
  hasDerivWithinAt_fract      {x} has right derivative 1 everywhere
  continuous_bernoulliFun_fract   k ≠ 1 ⊢ x ↦ B_k({x}) is continuous
  abs_bernoulliFun_fract_le   |B_k({x})| ≤ bernBound k
  integrableOn_bern_cpow      Re w < −1, 0 < a ⊢ B_k({x})·x^w integrable on (a, ∞)
  norm_integral_bern_cpow_le  the same ⊢ ‖∫‖ ≤ bernBound k · a^{Re w+1}/(−(Re w+1))
  interval_ibp                (k+1)∫_a^b P_k x^{−(s+k)} = [P_{k+1} x^{−(s+k)}]_a^b
                                + (s+k)∫_a^b P_{k+1} x^{−(s+k+1)}
  tail_ibp                    the same on (a, ∞), boundary term at infinity gone
  emInt_step                  (k+1)·I_k = −B_{k+1}(0)·N^{−(s+k)} + (s+k)·I_{k+1}
  emRem_step                  emRem k = emTerm k + emRem (k+1)
  sum_range_succ_eq_sum_Icc   Σ_{n ≤ N} 1/n^s = Σ_{n ∈ [1,N]} n^{−s}
  sum_range_eq_sum_Icc        Σ_{n < N} 1/(n+1)^s = Σ_{n ∈ [1,N]} n^{−s}
  zeta_eq_em_one              the order-one formula, from `Zeta0EqZeta`
  zeta_eq_em                  the order-k formula, every k ≥ 1
  norm_emInt_le               ‖I_k‖ ≤ bernBound k · N^{1−σ−k}/(σ+k−1)
  norm_remainder_le           ‖emRem k‖ ≤ (∏_{i<k}‖s+i‖/k!)·bernBound k·N^{1−σ−k}/(σ+k−1)
  norm_emTerm_le              ‖emTerm j‖ ≤ ∏_{i<j}‖s+i‖·|B_{j+1}(0)|/(j+1)!·N^{−σ−j}
  norm_zeta_sub_partial_le    ‖s‖+k ≤ N ⊢ ‖ζ − P_N + N^{1−s}/(1−s)‖
                                ≤ A_k N^{−σ}(1 + (‖s‖+k)^k N^{1−k})

What the next slice needs: the corollary `norm_zeta_sub_partial_le` at a fixed large `k`
with `N = T^(1+ε)`, fed into the mean square of `ζ·M_X − 1` (block C4). It is not here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import PrimeNumberTheoremAnd.ZetaBounds
import Mathlib

namespace ZetaEM

open Complex MeasureTheory Set intervalIntegral Filter Topology

noncomputable section

/-- The order-`k` tail integral `∫_{x>N} B_k({x})·x^{−(s+k)}`. -/
def emInt (k N : ℕ) (s : ℂ) : ℂ :=
  ∫ x in Ioi (N:ℝ), ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k))

/-- The coefficient `−s(s+1)⋯(s+k−1)/k!` of the order-`k` remainder. -/
def emCoef (k : ℕ) (s : ℂ) : ℂ :=
  -(∏ i ∈ Finset.range k, (s + i)) / (k.factorial : ℂ)

/-- The boundary term `s(s+1)⋯(s+j−1)·B_{j+1}(0)/(j+1)!·N^{−(s+j)}`. -/
def emTerm (j N : ℕ) (s : ℂ) : ℂ :=
  (∏ i ∈ Finset.range j, (s + i)) * (bernoulliFun (j+1) 0 : ℂ) / ((j+1).factorial : ℂ)
    * (N:ℂ) ^ (-(s + j))

/-- The boundary sum `Σ_{1 ≤ j < k} emTerm j N s`. -/
def emBoundary (k N : ℕ) (s : ℂ) : ℂ :=
  ∑ j ∈ Finset.Ico 1 k, emTerm j N s

/-- The order-`k` remainder `emCoef k s · emInt k N s`. -/
def emRem (k N : ℕ) (s : ℂ) : ℂ :=
  emCoef k s * emInt k N s

/-- The supremum of `|B_k|` on `[0, 1]`. -/
def bernBound (k : ℕ) : ℝ :=
  sSup ((fun x : ℝ ↦ |bernoulliFun k x|) '' Icc 0 1)

/-- The fractional part has right derivative `1` at every real `x`. -/
theorem hasDerivWithinAt_fract (x : ℝ) : HasDerivWithinAt Int.fract 1 (Ioi x) x := by
  have h1 : HasDerivWithinAt (fun y : ℝ ↦ y - (⌊x⌋ : ℝ)) 1 (Ioi x) x :=
    ((hasDerivAt_id' x).sub_const _).hasDerivWithinAt
  apply h1.congr_of_eventuallyEq
  · filter_upwards [Ioo_mem_nhdsGT (Int.lt_floor_add_one x)] with y hy
    have h2 : ⌊y⌋ = ⌊x⌋ := by
      rw [Int.floor_eq_iff]
      exact ⟨(Int.floor_le x).trans hy.1.le, hy.2⟩
    rw [Int.fract, h2]
  · rfl

/-- For `k ≠ 1` the periodic Bernoulli function `x ↦ B_k({x})` is continuous. -/
theorem continuous_bernoulliFun_fract {k : ℕ} (hk : k ≠ 1) :
    Continuous (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) :=
  ContinuousOn.comp_fract'' (continuous_bernoulliFun k).continuousOn
    (bernoulliFun_endpoints_eq_of_ne_one hk).symm

/-- The periodic Bernoulli function is bounded in absolute value by `bernBound k`. -/
theorem abs_bernoulliFun_fract_le (k : ℕ) (x : ℝ) :
    |bernoulliFun k (Int.fract x)| ≤ bernBound k := by
  have hb := (isCompact_Icc (a := (0:ℝ)) (b := 1)).bddAbove_image
    (f := fun x : ℝ ↦ |bernoulliFun k x|) (continuous_bernoulliFun k).abs.continuousOn
  exact le_csSup hb ⟨Int.fract x, ⟨Int.fract_nonneg x, (Int.fract_lt_one x).le⟩, rfl⟩

/-- The bound `bernBound k` is nonnegative. -/
theorem bernBound_nonneg (k : ℕ) : 0 ≤ bernBound k :=
  (abs_nonneg _).trans (abs_bernoulliFun_fract_le k 0)

/-- The periodic Bernoulli function is measurable. -/
theorem measurable_bern (k : ℕ) : Measurable (fun x : ℝ ↦ bernoulliFun k (Int.fract x)) :=
  (continuous_bernoulliFun k).measurable.comp measurable_fract

/-- For `Re w < −1` and `0 < a`, the function `B_k({x})·x^w` is integrable on `(a, ∞)`. -/
theorem integrableOn_bern_cpow (k : ℕ) {a : ℝ} (ha : 0 < a) {w : ℂ} (hw : w.re < -1) :
    IntegrableOn (fun x : ℝ ↦ ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w)
      (Ioi a) := by
  have hmeas : AEStronglyMeasurable
      (fun x : ℝ ↦ ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w)
      (volume.restrict (Ioi a)) := by
    apply AEStronglyMeasurable.mul
    · exact (Complex.measurable_ofReal.comp (measurable_bern k)).aestronglyMeasurable
    · apply ContinuousOn.aestronglyMeasurable ?_ measurableSet_Ioi
      intro x hx
      apply ContinuousAt.continuousWithinAt
      apply ContinuousAt.cpow Complex.continuous_ofReal.continuousAt continuousAt_const
      rw [Complex.ofReal_mem_slitPlane]
      exact lt_trans ha hx
  apply Integrable.mono' (g := fun x : ℝ ↦ bernBound k * x ^ w.re) ?_ hmeas
  · filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
    have hx0 : 0 < x := lt_trans ha hx
    rw [norm_mul, Complex.norm_real, Complex.norm_cpow_eq_rpow_re_of_pos hx0,
      Real.norm_eq_abs]
    exact mul_le_mul_of_nonneg_right (abs_bernoulliFun_fract_le k x)
      (Real.rpow_nonneg hx0.le _)
  · exact Integrable.const_mul (integrableOn_Ioi_rpow_of_lt hw ha) _

/-- For `Re w < −1` and `0 < a`, the integral of `B_k({x})·x^w` over `(a, ∞)` has norm at
most `bernBound k · a^{Re w + 1}/(−(Re w + 1))`. -/
theorem norm_integral_bern_cpow_le (k : ℕ) {a : ℝ} (ha : 0 < a) {w : ℂ} (hw : w.re < -1) :
    ‖∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w‖
      ≤ bernBound k * (-a ^ (w.re + 1) / (w.re + 1)) := by
  have hdom : IntegrableOn (fun x : ℝ ↦ bernBound k * x ^ w.re) (Ioi a) :=
    Integrable.const_mul (integrableOn_Ioi_rpow_of_lt hw ha) _
  calc ‖∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w‖
      ≤ ∫ x in Ioi a, ‖((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w‖ :=
        MeasureTheory.norm_integral_le_integral_norm _
    _ ≤ ∫ x in Ioi a, bernBound k * x ^ w.re := by
        apply MeasureTheory.integral_mono_of_nonneg
        · exact Filter.Eventually.of_forall (fun x ↦ norm_nonneg _)
        · exact hdom
        · filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx
          have hx0 : 0 < x := lt_trans ha hx
          rw [norm_mul, Complex.norm_real, Complex.norm_cpow_eq_rpow_re_of_pos hx0,
            Real.norm_eq_abs]
          exact mul_le_mul_of_nonneg_right (abs_bernoulliFun_fract_le k x)
            (Real.rpow_nonneg hx0.le _)
    _ = bernBound k * ∫ x in Ioi a, x ^ w.re := by
        rw [MeasureTheory.integral_const_mul]
    _ = bernBound k * (-a ^ (w.re + 1) / (w.re + 1)) := by
        rw [integral_Ioi_rpow_of_lt hw ha]

/-- **One integration by parts on `[a, b]`**: for `k ≥ 1`, `0 < a ≤ b` and `Re s + k > 1`,
`(k+1)·∫_a^b P_k x^{−(s+k)}` is the boundary term of `P_{k+1} x^{−(s+k)}` plus
`(s+k)·∫_a^b P_{k+1} x^{−(s+k+1)}`. -/
theorem interval_ibp {k : ℕ} (hk : 1 ≤ k) {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) {s : ℂ}
    (hs : 1 < s.re + k) :
    ((k:ℂ) + 1) * ∫ x in a..b, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k))
      = ((bernoulliFun (k+1) (Int.fract b) : ℝ) : ℂ) * (b:ℂ) ^ (-(s + k))
        - ((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ) * (a:ℂ) ^ (-(s + k))
        + (s + k) * ∫ x in a..b, ((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ)
            * (x:ℂ) ^ (-(s + ((k+1 : ℕ) : ℂ))) := by
  have hw1 : (-(s + (k:ℂ))).re < -1 := by simp; linarith
  have hw2 : (-(s + ((k+1 : ℕ) : ℂ))).re < -1 := by simp; linarith
  have hne : -(s + (k:ℂ)) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
    linarith
  have hii : ∀ (j : ℕ) (w : ℂ), w.re < -1 → IntervalIntegrable
      (fun x : ℝ ↦ ((bernoulliFun j (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ w) volume a b := by
    intro j w hw
    rw [intervalIntegrable_iff, Set.uIoc_of_le hab]
    exact (integrableOn_bern_cpow j ha hw).mono_set (fun x hx ↦ hx.1)
  have hi1 := hii k _ hw1
  have hi2 := hii (k+1) _ hw2
  have hcont : ContinuousOn (fun x : ℝ ↦ ((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ)
      * (x:ℂ) ^ (-(s + k))) (Icc a b) := by
    apply ContinuousOn.mul
    · exact (Complex.continuous_ofReal.comp
        (continuous_bernoulliFun_fract (by omega))).continuousOn
    · intro x hx
      apply ContinuousAt.continuousWithinAt
      apply ContinuousAt.cpow Complex.continuous_ofReal.continuousAt continuousAt_const
      rw [Complex.ofReal_mem_slitPlane]
      exact lt_of_lt_of_le ha hx.1
  have hderiv : ∀ x ∈ Ioo a b, HasDerivWithinAt
      (fun x : ℝ ↦ ((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)))
      (((k:ℂ) + 1) * (((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k)))
        - (s + k) * (((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ)
            * (x:ℂ) ^ (-(s + ((k+1 : ℕ) : ℂ))))) (Ioi x) x := by
    intro x hx
    have hx0 : 0 < x := lt_trans ha hx.1
    have hB := (hasDerivAt_bernoulliFun (k+1) (Int.fract x)).comp_hasDerivWithinAt x
      (hasDerivWithinAt_fract x)
    have hB2 := hB.ofReal_comp
    have hC := (hasDerivAt_ofReal_cpow_const hx0.ne' hne).hasDerivWithinAt (s := Ioi x)
    have hD := hB2.mul hC
    apply hD.congr_deriv
    have hexp : (x:ℂ) ^ (-(s + (k:ℂ)) - 1) = (x:ℂ) ^ (-(s + ((k+1 : ℕ) : ℂ))) := by
      congr 1
      push_cast
      ring
    rw [hexp]
    simp only [Function.comp_apply, Nat.add_sub_cancel, mul_one]
    push_cast
    ring
  have hFTC := intervalIntegral.integral_eq_sub_of_hasDeriv_right_of_le hab hcont hderiv
    ((hi1.const_mul ((k:ℂ) + 1)).sub (hi2.const_mul (s + k)))
  rw [intervalIntegral.integral_sub (hi1.const_mul _) (hi2.const_mul _),
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul] at hFTC
  linear_combination hFTC

/-- **The step on the tail**: for `k ≥ 1`, `0 < a` and `Re s + k > 1`,
`(k+1)·I_k(a) = −B_{k+1}({a})·a^{−(s+k)} + (s+k)·I_{k+1}(a)`. -/
theorem tail_ibp {k : ℕ} (hk : 1 ≤ k) {a : ℝ} (ha : 0 < a) {s : ℂ} (hs : 1 < s.re + k) :
    ((k:ℂ) + 1) * ∫ x in Ioi a, ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k))
      = -(((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ) * (a:ℂ) ^ (-(s + k)))
        + (s + k) * ∫ x in Ioi a, ((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ)
            * (x:ℂ) ^ (-(s + ((k+1 : ℕ) : ℂ))) := by
  have hw1 : (-(s + (k:ℂ))).re < -1 := by simp; linarith
  have hw2 : (-(s + ((k+1 : ℕ) : ℂ))).re < -1 := by simp; linarith
  have htend1 := MeasureTheory.intervalIntegral_tendsto_integral_Ioi a
    (integrableOn_bern_cpow k ha hw1) Filter.tendsto_id
  have htend2 := MeasureTheory.intervalIntegral_tendsto_integral_Ioi a
    (integrableOn_bern_cpow (k+1) ha hw2) Filter.tendsto_id
  have hg : Tendsto (fun b : ℝ ↦ ((bernoulliFun (k+1) (Int.fract b) : ℝ) : ℂ)
      * (b:ℂ) ^ (-(s + k))) atTop (𝓝 0) := by
    have hpos : 0 < s.re + k := by linarith
    have hr := (tendsto_rpow_neg_atTop hpos).const_mul (bernBound (k+1))
    rw [mul_zero] at hr
    apply squeeze_zero_norm' ?_ hr
    filter_upwards [Filter.eventually_gt_atTop 0] with b hb
    rw [norm_mul, Complex.norm_real, Complex.norm_cpow_eq_rpow_re_of_pos hb,
      Real.norm_eq_abs]
    have hre : (-(s + (k:ℂ))).re = -(s.re + k) := by simp
    rw [hre]
    exact mul_le_mul_of_nonneg_right (abs_bernoulliFun_fract_le (k+1) b)
      (Real.rpow_nonneg hb.le _)
  have hlim := (hg.sub_const (((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ)
      * (a:ℂ) ^ (-(s + k)))).add (htend2.const_mul (s + k))
  have hlim' : Tendsto (fun b : ℝ ↦ ((k:ℂ) + 1) * ∫ x in a..id b,
      ((bernoulliFun k (Int.fract x) : ℝ) : ℂ) * (x:ℂ) ^ (-(s + k))) atTop
      (𝓝 (0 - ((bernoulliFun (k+1) (Int.fract a) : ℝ) : ℂ) * (a:ℂ) ^ (-(s + k))
        + (s + k) * ∫ x in Ioi a, ((bernoulliFun (k+1) (Int.fract x) : ℝ) : ℂ)
            * (x:ℂ) ^ (-(s + ((k+1 : ℕ) : ℂ))))) := by
    apply hlim.congr'
    filter_upwards [Filter.eventually_ge_atTop a] with b hb
    exact (interval_ibp hk ha hb hs).symm
  have huniq := tendsto_nhds_unique (htend1.const_mul ((k:ℂ) + 1)) hlim'
  rw [huniq]
  ring

/-- **The recursion for the tail integrals**: for `k ≥ 1`, `0 < N` and `Re s + k > 1`,
`(k+1)·I_k(N, s) = −B_{k+1}(0)·N^{−(s+k)} + (s+k)·I_{k+1}(N, s)`. -/
theorem emInt_step {k : ℕ} (hk : 1 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 1 < s.re + k) :
    ((k:ℂ) + 1) * emInt k N s
      = -((bernoulliFun (k+1) 0 : ℂ) * (N:ℂ) ^ (-(s + k))) + (s + k) * emInt (k+1) N s := by
  have hN0 : (0:ℝ) < (N:ℝ) := by exact_mod_cast hN
  have h := tail_ibp hk hN0 hs
  rw [Int.fract_natCast] at h
  unfold emInt
  rw [h]
  push_cast
  ring

/-- **The remainder step**: the order-`k` remainder is the `k`-th boundary term plus the
order-`(k+1)` remainder, for `k ≥ 1`, `0 < N`, `Re s + k > 1`. -/
theorem emRem_step {k : ℕ} (hk : 1 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 1 < s.re + k) :
    emRem k N s = emTerm k N s + emRem (k+1) N s := by
  have h := emInt_step hk hN hs
  have hk1 : (k:ℂ) + 1 ≠ 0 := by exact_mod_cast Nat.succ_ne_zero k
  have hfac : (k.factorial : ℂ) ≠ 0 := by exact_mod_cast Nat.factorial_ne_zero k
  have hI : emInt k N s = (-((bernoulliFun (k+1) 0 : ℂ) * (N:ℂ) ^ (-(s + k)))
      + (s + k) * emInt (k+1) N s) / ((k:ℂ) + 1) := by
    rw [eq_div_iff hk1]
    linear_combination h
  unfold emRem emCoef emTerm
  rw [hI, Finset.prod_range_succ, Nat.factorial_succ]
  push_cast
  field_simp
  try ring

/-- The sum `Σ_{n ≤ N} 1/n^s` equals `Σ_{n ∈ [1, N]} n^{−s}` for `s ≠ 0`. -/
theorem sum_range_succ_eq_sum_Icc (N : ℕ) {s : ℂ} (hs : s ≠ 0) :
    ∑ n ∈ Finset.range (N + 1), 1 / (n : ℂ) ^ s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) := by
  rw [← Finset.Ico_add_one_right_eq_Icc, Finset.sum_Ico_eq_sum_range, Finset.sum_range_succ']
  have h0 : (1:ℂ) / ((0:ℕ):ℂ) ^ s = 0 := by
    rw [Nat.cast_zero, Complex.zero_cpow hs]
    simp
  rw [h0, add_zero, Nat.add_sub_cancel]
  apply Finset.sum_congr rfl
  intro n _
  rw [one_div_cpow_eq_cpow_neg, add_comm 1 n]

/-- The shifted sum `Σ_{n < N} 1/(n+1)^s` equals `Σ_{n ∈ [1, N]} n^{−s}`. -/
theorem sum_range_eq_sum_Icc (N : ℕ) (s : ℂ) :
    ∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) := by
  rw [← Finset.Ico_add_one_right_eq_Icc, Finset.sum_Ico_eq_sum_range, Nat.add_sub_cancel]
  apply Finset.sum_congr rfl
  intro n _
  rw [one_div_cpow_eq_cpow_neg]
  push_cast
  ring_nf

/-- **The order-one formula**: for `0 < N`, `Re s > 0`, `s ≠ 1`,
`ζ(s) = Σ_{n ∈ [1,N]} n^{−s} − N^{1−s}/(1−s) − N^{−s}/2 − s·I_1(N, s)`. -/
theorem zeta_eq_em_one {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 0 < s.re) (hs1 : s ≠ 1) :
    riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s)
      - (N:ℂ) ^ (-s) / 2 - s * emInt 1 N s := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    simp at hs
  rw [← Zeta0EqZeta hN hs hs1, riemannZeta0_apply, sum_range_succ_eq_sum_Icc N hs0]
  have hint : ∫ x in Ioi (N:ℝ), ((⌊x⌋ : ℂ) + 1 / 2 - (x:ℂ)) * (x:ℂ) ^ (-(s + 1))
      = -emInt 1 N s := by
    unfold emInt
    rw [← MeasureTheory.integral_neg]
    apply MeasureTheory.integral_congr_ae
    apply Filter.Eventually.of_forall
    intro x
    simp only [bernoulliFun_one, Int.fract, Nat.cast_one]
    push_cast
    ring
  rw [hint]
  ring

/-- **Euler–Maclaurin of order `k`**: for every `k ≥ 1`, `0 < N`, `Re s > 0`, `s ≠ 1`,
`ζ(s) = Σ_{n ∈ [1,N]} n^{−s} − N^{1−s}/(1−s) − N^{−s}/2 + emBoundary k N s + emRem k N s`. -/
theorem zeta_eq_em {k : ℕ} (hk : 1 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 0 < s.re)
    (hs1 : s ≠ 1) :
    riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s)
      - (N:ℂ) ^ (-s) / 2 + emBoundary k N s + emRem k N s := by
  induction k, hk using Nat.le_induction with
  | base =>
    rw [zeta_eq_em_one hN hs hs1]
    simp only [emBoundary, emRem, emCoef, Finset.Ico_self, Finset.sum_empty,
      Finset.prod_range_one, Nat.factorial_one, Nat.cast_zero, Nat.cast_one, add_zero, div_one]
    ring
  | succ k hk ih =>
    have hsk : 1 < s.re + k := by
      have : (1:ℝ) ≤ k := by exact_mod_cast hk
      linarith
    rw [ih, emRem_step hk hN hsk, emBoundary, emBoundary, Finset.sum_Ico_succ_top hk]
    ring

/-- The order-`k` tail integral has norm at most `bernBound k · N^{1−σ−k}/(σ+k−1)` when
`σ + k > 1`. -/
theorem norm_emInt_le (k : ℕ) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 1 < s.re + k) :
    ‖emInt k N s‖ ≤ bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1)) := by
  have hN0 : (0:ℝ) < (N:ℝ) := by exact_mod_cast hN
  have hw : (-(s + (k:ℂ))).re < -1 := by simp; linarith
  have h := norm_integral_bern_cpow_le k hN0 hw
  have hre : (-(s + (k:ℂ))).re = -s.re - k := by simp; ring
  rw [hre] at h
  have h2 : -(N:ℝ) ^ (-s.re - k + 1) / (-s.re - k + 1)
      = (N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1) := by
    rw [show (-s.re - k + 1 : ℝ) = -(s.re + k - 1) by ring, div_neg, neg_div, neg_neg,
      show (-(s.re + k - 1) : ℝ) = 1 - s.re - k by ring]
  rw [h2] at h
  exact h

/-- **The remainder bound**: for `σ + k > 1` and `0 < N`, the order-`k` remainder has norm at
most `(∏_{i<k}‖s+i‖/k!)·bernBound k·N^{1−σ−k}/(σ+k−1)`. -/
theorem norm_remainder_le (k : ℕ) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 1 < s.re + k) :
    ‖emRem k N s‖ ≤ (∏ i ∈ Finset.range k, ‖s + i‖) / k.factorial
      * (bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1))) := by
  unfold emRem emCoef
  rw [norm_mul, norm_div, norm_neg, norm_prod, Complex.norm_natCast]
  exact mul_le_mul_of_nonneg_left (norm_emInt_le k hN hs) (by positivity)

/-- The `j`-th boundary term has norm `∏_{i<j}‖s+i‖·|B_{j+1}(0)|/(j+1)!·N^{−σ−j}`. -/
theorem norm_emTerm (j : ℕ) {N : ℕ} (hN : 0 < N) (s : ℂ) :
    ‖emTerm j N s‖ = (∏ i ∈ Finset.range j, ‖s + i‖) * |bernoulliFun (j+1) 0|
      / (j+1).factorial * (N:ℝ) ^ (-s.re - j) := by
  unfold emTerm
  rw [norm_mul, norm_div, norm_mul, norm_prod, Complex.norm_real, Real.norm_eq_abs,
    Complex.norm_natCast, norm_natCast_cpow_of_pos hN]
  congr 2
  simp
  ring

/-- For `i < j ≤ k`, the product `∏_{i<j}‖s+i‖` is at most `(‖s‖+k)^j`. -/
theorem prod_norm_le (s : ℂ) {j k : ℕ} (hjk : j ≤ k) :
    ∏ i ∈ Finset.range j, ‖s + i‖ ≤ (‖s‖ + k) ^ j := by
  calc ∏ i ∈ Finset.range j, ‖s + i‖ ≤ ∏ _i ∈ Finset.range j, (‖s‖ + k) := by
        apply Finset.prod_le_prod (fun i _ ↦ norm_nonneg _)
        intro i hi
        rw [Finset.mem_range] at hi
        calc ‖s + i‖ ≤ ‖s‖ + ‖(i:ℂ)‖ := norm_add_le _ _
          _ = ‖s‖ + i := by rw [Complex.norm_natCast]
          _ ≤ ‖s‖ + k := by
              have : (i:ℝ) ≤ k := by exact_mod_cast (by omega : i ≤ k)
              linarith
    _ = (‖s‖ + k) ^ j := by rw [Finset.prod_const, Finset.card_range]

/-- The constant of the corollary: `1/2 + Σ_{1 ≤ j < k} |B_{j+1}(0)|/(j+1)! + bernBound k/k!`. -/
def emConst (k : ℕ) : ℝ :=
  1 / 2 + (∑ j ∈ Finset.Ico 1 k, |bernoulliFun (j+1) 0| / (j+1).factorial)
    + bernBound k / k.factorial

/-- **The corollary**: for `k ≥ 2`, `0 < N`, `Re s > 0`, `s ≠ 1` and `‖s‖ + k ≤ N`,
`‖ζ(s) − Σ_{n ∈ [1,N]} n^{−s} + N^{1−s}/(1−s)‖ ≤ A_k·N^{−σ}·(1 + (‖s‖+k)^k·N^{1−k})`. -/
theorem norm_zeta_sub_partial_le (k : ℕ) (hk : 2 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ}
    (hσ : 0 < s.re) (hs1 : s ≠ 1) (hsN : ‖s‖ + k ≤ N) :
    ‖riemannZeta s - ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)‖
      ≤ emConst k * (N : ℝ) ^ (-s.re) * (1 + (‖s‖ + k) ^ k * (N : ℝ) ^ (1 - (k : ℝ))) := by
  have hN0 : (0:ℝ) < (N:ℝ) := by exact_mod_cast hN
  have hk1 : (2:ℝ) ≤ k := by exact_mod_cast hk
  have hsk : 1 < s.re + k := by linarith
  have hz := zeta_eq_em (by omega : 1 ≤ k) hN hσ hs1
  have heq : riemannZeta s - ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)
      = -((N:ℂ) ^ (-s) / 2) + emBoundary k N s + emRem k N s := by
    rw [hz]
    ring
  rw [heq]
  set u : ℝ := (N:ℝ) ^ (-s.re) with hu
  have hu0 : 0 ≤ u := Real.rpow_nonneg hN0.le _
  set X : ℝ := (‖s‖ + k) ^ k * (N : ℝ) ^ (1 - (k : ℝ)) with hX
  have hX0 : 0 ≤ X := by positivity
  set c2 : ℝ := ∑ j ∈ Finset.Ico 1 k, |bernoulliFun (j+1) 0| / (j+1).factorial with hc2
  have hc20 : 0 ≤ c2 := Finset.sum_nonneg (fun j _ ↦ by positivity)
  have hc30 : 0 ≤ bernBound k / k.factorial := div_nonneg (bernBound_nonneg k) (by positivity)
  -- the half term
  have h1 : ‖-((N:ℂ) ^ (-s) / 2)‖ = (1/2) * u := by
    rw [norm_neg, norm_div, norm_natCast_cpow_of_pos hN]
    simp only [Complex.neg_re, Complex.norm_ofNat]
    rw [hu]
    ring
  -- the boundary terms
  have h2 : ‖emBoundary k N s‖ ≤ c2 * u := by
    unfold emBoundary
    rw [hc2, Finset.sum_mul]
    refine (norm_sum_le _ _).trans (Finset.sum_le_sum ?_)
    intro j hj
    rw [Finset.mem_Ico] at hj
    rw [norm_emTerm j hN s]
    have hP := prod_norm_le s (j := j) (k := k) hj.2.le
    have hP2 : (‖s‖ + k) ^ j ≤ (N:ℝ) ^ j :=
      pow_le_pow_left₀ (by positivity) hsN j
    have hNj : (0:ℝ) < (N:ℝ) ^ j := pow_pos hN0 j
    have hsplit : (N:ℝ) ^ (-s.re - j) = u / (N:ℝ) ^ j := by
      rw [Real.rpow_sub hN0, Real.rpow_natCast, hu]
    rw [hsplit]
    have hq : (∏ i ∈ Finset.range j, ‖s + i‖) / (N:ℝ) ^ j ≤ 1 :=
      div_le_one_of_le₀ (hP.trans hP2) hNj.le
    have hc : 0 ≤ |bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ) := by positivity
    calc (∏ i ∈ Finset.range j, ‖s + i‖) * |bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ)
          * (u / (N:ℝ) ^ j)
        = ((∏ i ∈ Finset.range j, ‖s + i‖) / (N:ℝ) ^ j)
            * (|bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ) * u) := by ring
      _ ≤ 1 * (|bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ) * u) :=
          mul_le_mul_of_nonneg_right hq (mul_nonneg hc hu0)
      _ = |bernoulliFun (j+1) 0| / ((j+1).factorial : ℝ) * u := one_mul _
  -- the remainder
  have h3 : ‖emRem k N s‖ ≤ bernBound k / k.factorial * u * X := by
    have hR := norm_remainder_le k hN hsk
    have hP := prod_norm_le s (le_refl k)
    have hden : 1 ≤ s.re + k - 1 := by linarith
    have hpow : (N:ℝ) ^ (1 - s.re - k) = u * (N:ℝ) ^ (1 - (k:ℝ)) := by
      rw [hu, ← Real.rpow_add hN0]
      congr 1
      ring
    have hv0 : 0 ≤ (N:ℝ) ^ (1 - s.re - k) := Real.rpow_nonneg hN0.le _
    have hdiv : (N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1) ≤ (N:ℝ) ^ (1 - s.re - k) :=
      div_le_self hv0 hden
    have hB0 := bernBound_nonneg k
    have hfac : (0:ℝ) < k.factorial := by exact_mod_cast Nat.factorial_pos k
    calc ‖emRem k N s‖
        ≤ (∏ i ∈ Finset.range k, ‖s + i‖) / k.factorial
            * (bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1))) := hR
      _ ≤ (‖s‖ + k) ^ k / k.factorial * (bernBound k * (N:ℝ) ^ (1 - s.re - k)) := by
          apply mul_le_mul (div_le_div_of_nonneg_right hP hfac.le)
            (mul_le_mul_of_nonneg_left hdiv hB0) (by positivity) (by positivity)
      _ = bernBound k / k.factorial * u * X := by
          rw [hpow, hX]
          ring
  have key : emConst k * u * (1 + X)
      = (1/2) * u + c2 * u + bernBound k / k.factorial * u * X
        + (((1/2) + c2) * u * X + bernBound k / k.factorial * u) := by
    rw [emConst, ← hc2]
    ring
  have hextra : 0 ≤ ((1/2) + c2) * u * X + bernBound k / k.factorial * u := by positivity
  calc ‖-((N:ℂ) ^ (-s) / 2) + emBoundary k N s + emRem k N s‖
      ≤ ‖-((N:ℂ) ^ (-s) / 2)‖ + ‖emBoundary k N s‖ + ‖emRem k N s‖ := norm_add₃_le
    _ ≤ (1/2) * u + c2 * u + bernBound k / k.factorial * u * X := by
        rw [h1]
        linarith
    _ ≤ emConst k * u * (1 + X) := by
        rw [key]
        linarith

/-- info: 'ZetaEM.zeta_eq_em' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeta_eq_em

/-- info: 'ZetaEM.norm_remainder_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_remainder_le

/-- info: 'ZetaEM.norm_zeta_sub_partial_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms norm_zeta_sub_partial_le

end

end ZetaEM
