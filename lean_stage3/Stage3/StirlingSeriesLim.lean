/-
StirlingSeriesLim — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: Stirling's
series for `log Γ` with an explicit remainder. 2026-11-25.

Summing `StirlingSeriesEM.stirMain_step` over `w = z + n`, `n ≤ N`:
`Σ_{n≤N} log(z+n) = S_{K+1}(z+N+1) − S_{K+1}(z) + P_N`, `P_N = Σ_{n≤N} J_{2K}(z+n)/(2K)`
(`sum_log_eq`). PNT+'s `logGammaSeq z N = z log N + log N! − Σ_{n≤N} log(z+n)`, so
`P_N = A_N + S_{K+1}(z) − logGammaSeq z N` with `A_N = z log N + log N! − S_{K+1}(z+N+1)`.
Mathlib's Stirling formula (`Stirling.tendsto_stirlingSeq_sqrt_pi`) and
`N log(1 + (z+1)/N) → z + 1` give `A_N → ½ log 2π` (`tendsto_A`), so `P_N` tends to
`½ log 2π + S_{K+1}(z) − logG z`, and `‖P_N‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}` for every
`N` (`norm_emJ_le`, `Stirling.sum_inv_normSq_le`) bounds the limit.

The size check. The remainder is `O(‖z‖^{2−2K}/|Im z|)`; in the sector `|Im z| ≥ ‖z‖/2` that is
`O(‖z‖^{1−2K})`, the order of the first omitted term of `S_K` (`stirling_series'`). No factor
grows with `N`: the bound on `P_N` is uniform.

| name | content | status |
|---|---|---|
| `sum_log_eq` | `Σ_{n≤N} log(z+n) = S_{K+1}(z+N+1) − S_{K+1}(z) + P_N` | proved |
| `tendsto_A` | `z log N + log N! − S_{K+1}(z+N+1) → ½ log 2π` | proved |
| `norm_P_le` | `‖P_N‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}` | proved |
| `stirling_series` | `0 < Re z`, `½ ≤ |Im z|`, `1 ≤ K` ⊢ `‖logG z − S_{K+1}(z) − ½ log 2π‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}` | proved |
| `stirling_series'` | the same for `S_K`, plus `‖c_K‖/‖z‖^{2K−1}` | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Stage3.StirlingSeriesEM

namespace StirlingSeries

open Complex Filter Topology

noncomputable section

/-- The remainder's partial sums `P_N = Σ_{n≤N} J_{2K}(z+n)/(2K)`. -/
def remP (K : ℕ) (z : ℂ) (N : ℕ) : ℂ :=
  ∑ n ∈ Finset.range (N + 1), emJ (2 * K) (z + (n : ℂ)) / (2 * K)

/-- `A_N = z log N + log N! − S_{K+1}(z + N + 1)`. -/
def seqA (K : ℕ) (z : ℂ) (N : ℕ) : ℂ :=
  z * (Real.log N : ℂ) + (Real.log (N.factorial) : ℂ) - stirMain (K + 1) (z + ((N + 1 : ℕ) : ℂ))

theorem re_add_nat_pos {z : ℂ} (hz : 0 < z.re) (n : ℕ) : 0 < (z + (n : ℂ)).re := by
  simp only [add_re, natCast_re]
  have : (0 : ℝ) ≤ n := Nat.cast_nonneg n
  linarith

/-- **The telescoped sum**: `Σ_{n≤N} log(z+n) = S_{K+1}(z+N+1) − S_{K+1}(z) + P_N`. -/
theorem sum_log_eq {K : ℕ} (hK : 1 ≤ K) {z : ℂ} (hz : 0 < z.re) (N : ℕ) :
    ∑ n ∈ Finset.range (N + 1), log (z + (n : ℂ))
      = stirMain (K + 1) (z + ((N + 1 : ℕ) : ℂ)) - stirMain (K + 1) z + remP K z N := by
  induction N with
  | zero =>
    have h := stirMain_step hK (re_add_nat_pos hz 0)
    simp only [Nat.cast_zero, add_zero] at h
    simp only [remP, zero_add, Finset.range_one, Finset.sum_singleton, Nat.cast_zero, add_zero,
      Nat.cast_one]
    linear_combination -h
  | succ N ih =>
    have h := stirMain_step hK (re_add_nat_pos hz (N + 1))
    rw [Finset.sum_range_succ, ih]
    have e : z + ((N + 1 : ℕ) : ℂ) + 1 = z + ((N + 1 + 1 : ℕ) : ℂ) := by push_cast; ring
    rw [e] at h
    simp only [remP]
    rw [Finset.sum_range_succ _ (N + 1)]
    linear_combination -h

/-- `log(z + N + 1) = log N + log(1 + (z+1)/N)` for `N ≥ 1`, `Re z ≥ 0`. -/
theorem log_shift_eq {z : ℂ} (hz : 0 ≤ z.re) {N : ℕ} (hN : 1 ≤ N) :
    log (z + ((N + 1 : ℕ) : ℂ)) = (Real.log N : ℂ) + log (1 + (z + 1) / (N : ℂ)) := by
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
  have hNC : (N : ℂ) ≠ 0 := by exact_mod_cast hN0.ne'
  have hx : 1 + (z + 1) / (N : ℂ) ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    have hre : (1 + (z + 1) / (N : ℂ)).re = 1 + (z.re + 1) / N := by
      rw [add_re, one_re, Complex.div_natCast_re]
      simp
    rw [hre, zero_re] at this
    have : 0 ≤ (z.re + 1) / N := by positivity
    linarith
  have e : z + ((N + 1 : ℕ) : ℂ) = ((N : ℝ) : ℂ) * (1 + (z + 1) / (N : ℂ)) := by
    rw [Complex.ofReal_natCast, mul_add, mul_one, mul_div_cancel₀ _ hNC]
    push_cast
    ring
  rw [e, log_ofReal_mul hN0 hx]

/-- `log N! = log(stirlingSeq N) + ½ log 2 + ½ log N + N log N − N` for `N ≥ 1`. -/
theorem log_factorial_eq {N : ℕ} (hN : 1 ≤ N) :
    Real.log (N.factorial) = Real.log (Stirling.stirlingSeq N) + Real.log 2 / 2
      + Real.log N / 2 + N * Real.log N - N := by
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
  have h := Stirling.log_stirlingSeq_formula N
  rw [Real.log_mul (by norm_num) hN0.ne', Real.log_div hN0.ne' (Real.exp_pos 1).ne',
    Real.log_exp] at h
  linarith

theorem tendsto_inv_pow_shift {z : ℂ} (hz : 0 ≤ z.re) {j : ℕ} (hj : 1 ≤ j) :
    Tendsto (fun N : ℕ => ((z + ((N + 1 : ℕ) : ℂ)) ^ j)⁻¹) atTop (𝓝 0) := by
  apply squeeze_zero_norm (a := fun N : ℕ => 1 / ((N : ℝ) + 1))
  · intro N
    have hN : (1 : ℝ) ≤ (N : ℝ) + 1 := by
      have : (0 : ℝ) ≤ N := Nat.cast_nonneg N
      linarith
    have hge : (N : ℝ) + 1 ≤ ‖z + ((N + 1 : ℕ) : ℂ)‖ := by
      refine le_trans ?_ (Complex.re_le_norm _)
      simp only [add_re, natCast_re]
      push_cast
      linarith
    rw [norm_inv, norm_pow]
    have h1 : (N : ℝ) + 1 ≤ ‖z + ((N + 1 : ℕ) : ℂ)‖ ^ j := by
      calc (N : ℝ) + 1 = ((N : ℝ) + 1) ^ 1 := (pow_one _).symm
        _ ≤ ((N : ℝ) + 1) ^ j := pow_le_pow_right₀ hN hj
        _ ≤ ‖z + ((N + 1 : ℕ) : ℂ)‖ ^ j := pow_le_pow_left₀ (by linarith) hge j
    rw [← one_div]
    exact one_div_le_one_div_of_le (by linarith) h1
  · exact tendsto_one_div_add_atTop_nhds_zero_nat

theorem tendsto_stirSum_shift {z : ℂ} (hz : 0 ≤ z.re) (K : ℕ) :
    Tendsto (fun N : ℕ => stirSum K (z + ((N + 1 : ℕ) : ℂ))) atTop (𝓝 0) := by
  unfold stirSum
  rw [show (0 : ℂ) = ∑ k ∈ Finset.Ico 1 K, stirC k * 0 by simp]
  apply tendsto_finsetSum
  intro k hk
  rw [Finset.mem_Ico] at hk
  exact (tendsto_inv_pow_shift hz (by omega)).const_mul _

/-- **The constant**: `z log N + log N! − S_{K+1}(z+N+1) → ½ log 2π`. -/
theorem tendsto_A {z : ℂ} (hz : 0 ≤ z.re) (K : ℕ) :
    Tendsto (seqA K z) atTop (𝓝 ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)) := by
  set u : ℕ → ℂ := fun N => (z + 1) / (N : ℂ) with hu
  have hu0 : Tendsto u atTop (𝓝 0) := tendsto_const_div_atTop_nhds_zero_nat (z + 1)
  have h1 : (1 : ℂ) + 0 ∈ slitPlane := by simp
  have hLu : Tendsto (fun N => log (1 + u N)) atTop (𝓝 0) := by
    have := ((continuousAt_clog h1).tendsto).comp (tendsto_const_nhds.add hu0)
    rw [add_zero, log_one] at this
    exact this
  have hNLu : Tendsto (fun N : ℕ => (N : ℂ) * log (1 + u N)) atTop (𝓝 (z + 1)) := by
    apply Complex.tendsto_nat_mul_log_one_add_of_tendsto
    apply tendsto_const_nhds.congr'
    filter_upwards [eventually_ge_atTop 1] with N hN
    have hNC : (N : ℂ) ≠ 0 := by exact_mod_cast (by omega : N ≠ 0)
    simp only [hu]
    rw [mul_div_cancel₀ _ hNC]
  have hpi : 0 < Real.sqrt Real.pi := Real.sqrt_pos.mpr Real.pi_pos
  have hLs : Tendsto (fun N : ℕ => ((Real.log (Stirling.stirlingSeq N) : ℝ) : ℂ)) atTop
      (𝓝 ((Real.log (Real.sqrt Real.pi) : ℝ) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto _).comp
      (((Real.continuousAt_log hpi.ne').tendsto).comp Stirling.tendsto_stirlingSeq_sqrt_pi)
  have hS := tendsto_stirSum_shift hz (K + 1)
  have hall := ((((hLs.add_const ((Real.log 2 / 2 : ℝ) : ℂ)).add_const (z + 1)).sub hNLu).sub
    (hLu.const_mul (z + 1 / 2))).sub hS
  have hval : ((Real.log (Real.sqrt Real.pi) : ℝ) : ℂ) + ((Real.log 2 / 2 : ℝ) : ℂ) + (z + 1)
      - (z + 1) - (z + 1 / 2) * 0 - 0 = ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ) := by
    rw [Real.log_sqrt Real.pi_pos.le, Real.log_mul (by norm_num) Real.pi_pos.ne']
    push_cast
    ring
  rw [hval] at hall
  refine hall.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with N hN
  unfold seqA stirMain
  rw [log_shift_eq hz hN, log_factorial_eq hN]
  simp only [hu]
  push_cast
  ring

/-- `‖P_N‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}`. -/
theorem norm_P_le {K : ℕ} (hK : 1 ≤ K) {z : ℂ} (hz : 0 < z.re) (hY : 1 / 2 ≤ |z.im|) (N : ℕ) :
    ‖remP K z N‖ ≤ ZetaEM.bernBound (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) := by
  have hz0 : z ≠ 0 := by
    intro h; rw [h] at hz; simp at hz
  have hzn : 0 < ‖z‖ := norm_pos_iff.mpr hz0
  have hB := ZetaEM.bernBound_nonneg (2 * K)
  have hKpos : (0 : ℝ) < 2 * K := by
    have : (1 : ℝ) ≤ K := by exact_mod_cast hK
    linarith
  have hterm : ∀ n : ℕ, ‖emJ (2 * K) (z + (n : ℂ)) / (2 * K)‖
      ≤ ZetaEM.bernBound (2 * K) / (2 * K) / ‖z‖ ^ (2 * K - 2) * (1 / ‖z + (n : ℂ)‖ ^ 2) := by
    intro n
    have hre : 0 ≤ (z + (n : ℂ)).re := (re_add_nat_pos hz n).le
    have hne : z + (n : ℂ) ≠ 0 := by
      intro h; have := re_add_nat_pos hz n; rw [h] at this; simp at this
    have hJ := norm_emJ_le (2 * K) hre hne
    have hle : ‖z‖ ≤ ‖z + (n : ℂ)‖ := by
      have := norm_le_norm_add hz.le (x := (n : ℝ)) (Nat.cast_nonneg n)
      simpa using this
    have hwpos : 0 < ‖z + (n : ℂ)‖ := lt_of_lt_of_le hzn hle
    have hsplit : ‖z + (n : ℂ)‖ ^ (2 * K) = ‖z + (n : ℂ)‖ ^ (2 * K - 2) * ‖z + (n : ℂ)‖ ^ 2 := by
      rw [← pow_add]; congr 1; omega
    have hpow : ‖z‖ ^ (2 * K - 2) ≤ ‖z + (n : ℂ)‖ ^ (2 * K - 2) := pow_le_pow_left₀ hzn.le hle _
    rw [norm_div]
    have h2K : ‖(2 * (K : ℂ))‖ = 2 * K := by
      rw [show (2 * (K : ℂ)) = ((2 * K : ℝ) : ℂ) by push_cast; ring, Complex.norm_real,
        Real.norm_eq_abs, abs_of_pos hKpos]
    rw [h2K]
    calc ‖emJ (2 * K) (z + (n : ℂ))‖ / (2 * K)
        ≤ ZetaEM.bernBound (2 * K) / ‖z + (n : ℂ)‖ ^ (2 * K) / (2 * K) :=
          div_le_div_of_nonneg_right hJ hKpos.le
      _ = ZetaEM.bernBound (2 * K) / (2 * K) / ‖z + (n : ℂ)‖ ^ (2 * K - 2)
            * (1 / ‖z + (n : ℂ)‖ ^ 2) := by
          rw [hsplit]; field_simp
      _ ≤ ZetaEM.bernBound (2 * K) / (2 * K) / ‖z‖ ^ (2 * K - 2) * (1 / ‖z + (n : ℂ)‖ ^ 2) := by
          apply mul_le_mul_of_nonneg_right _ (by positivity)
          exact div_le_div_of_nonneg_left (by positivity) (by positivity) hpow
  unfold remP
  calc ‖∑ n ∈ Finset.range (N + 1), emJ (2 * K) (z + (n : ℂ)) / (2 * K)‖
      ≤ ∑ n ∈ Finset.range (N + 1), ‖emJ (2 * K) (z + (n : ℂ)) / (2 * K)‖ := norm_sum_le _ _
    _ ≤ ∑ n ∈ Finset.range (N + 1),
          ZetaEM.bernBound (2 * K) / (2 * K) / ‖z‖ ^ (2 * K - 2) * (1 / ‖z + (n : ℂ)‖ ^ 2) :=
        Finset.sum_le_sum fun n _ => hterm n
    _ = ZetaEM.bernBound (2 * K) / (2 * K) / ‖z‖ ^ (2 * K - 2)
          * ∑ n ∈ Finset.range (N + 1), 1 / ‖z + (n : ℂ)‖ ^ 2 := by rw [Finset.mul_sum]
    _ ≤ ZetaEM.bernBound (2 * K) / (2 * K) / ‖z‖ ^ (2 * K - 2) * (6 / |z.im|) :=
        mul_le_mul_of_nonneg_left (Stirling.sum_inv_normSq_le hz.le hY (N + 1)) (by positivity)
    _ = ZetaEM.bernBound (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) := by ring

/-- **Stirling's series with an explicit remainder**: for `Re z > 0`, `|Im z| ≥ ½`, `K ≥ 1`,
`‖logG z − S_{K+1}(z) − ½ log 2π‖ ≤ bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}`. -/
theorem stirling_series {z : ℂ} (hz : 0 < z.re) (hY : 1 / 2 ≤ |z.im|) {K : ℕ} (hK : 1 ≤ K) :
    ‖Stirling.logG z - stirMain (K + 1) z - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ ZetaEM.bernBound (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) := by
  set L : ℂ := ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ) with hL
  have hP : ∀ N, remP K z N = seqA K z N + stirMain (K + 1) z - Complex.logGammaSeq z N := by
    intro N
    have h := sum_log_eq hK hz N
    unfold seqA Complex.logGammaSeq
    linear_combination -h
  have hlim : Tendsto (remP K z) atTop (𝓝 (L + stirMain (K + 1) z - Stirling.logG z)) := by
    have := ((tendsto_A hz.le K).add_const (stirMain (K + 1) z)).sub (Stirling.tendsto_logG hz)
    refine this.congr' (Eventually.of_forall fun N => ?_)
    rw [hP N]
  have hn := hlim.norm
  have hbound := le_of_tendsto' hn (fun N => norm_P_le hK hz hY N)
  rw [← norm_neg]
  have e : -(Stirling.logG z - stirMain (K + 1) z - L) = L + stirMain (K + 1) z - Stirling.logG z := by
    ring
  rw [e]
  exact hbound

/-- **The form with `S_K`**: the remainder after the terms `k < K` is at most
`‖c_K‖/‖z‖^{2K−1} + bernBound(2K)/(2K)·(6/|Im z|)/‖z‖^{2K−2}`. -/
theorem stirling_series' {z : ℂ} (hz : 0 < z.re) (hY : 1 / 2 ≤ |z.im|) {K : ℕ} (hK : 1 ≤ K) :
    ‖Stirling.logG z - stirMain K z - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      ≤ ‖stirC K‖ / ‖z‖ ^ (2 * K - 1)
        + ZetaEM.bernBound (2 * K) / (2 * K) * (6 / |z.im|) / ‖z‖ ^ (2 * K - 2) := by
  have h := stirling_series hz hY hK
  have e : stirMain (K + 1) z = stirMain K z + stirC K * (z ^ (2 * K - 1))⁻¹ := by
    unfold stirMain stirSum
    rw [Finset.sum_Ico_succ_top hK]
    ring
  rw [e] at h
  have h2 : ‖stirC K * (z ^ (2 * K - 1))⁻¹‖ = ‖stirC K‖ / ‖z‖ ^ (2 * K - 1) := by
    rw [norm_mul, norm_inv, norm_pow, div_eq_mul_inv]
  calc ‖Stirling.logG z - stirMain K z - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖
      = ‖stirC K * (z ^ (2 * K - 1))⁻¹ + (Stirling.logG z - (stirMain K z
          + stirC K * (z ^ (2 * K - 1))⁻¹) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ))‖ := by
        congr 1; ring
    _ ≤ ‖stirC K * (z ^ (2 * K - 1))⁻¹‖ + ‖Stirling.logG z - (stirMain K z
          + stirC K * (z ^ (2 * K - 1))⁻¹) - ((Real.log (2 * Real.pi) / 2 : ℝ) : ℂ)‖ :=
        norm_add_le _ _
    _ ≤ _ := by rw [h2]; linarith

end

/-- info: 'StirlingSeries.tendsto_A' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tendsto_A

/-- info: 'StirlingSeries.stirling_series' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirling_series

/-- info: 'StirlingSeries.stirling_series'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms stirling_series'

end StirlingSeries
