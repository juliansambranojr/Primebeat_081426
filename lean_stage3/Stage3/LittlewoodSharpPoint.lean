/-
LittlewoodSharpPoint — block S14 of `lean_stage3/design/stencil.md`, Turing at scale: sharper
Littlewood constants, part 2, the pointwise lower bound for `log|ζ|` with optimized radii.
2026-11-25.

The route of `TuringLWHorizPoint` (Blaschke quotient of `Stage3.jensenF T`, Borel–Carathéodory,
`ZerosBound`) with two changes, chosen by `checks/littlewoodsharp/budget.py`:

* **the radii.** Zeros are removed in `‖z‖ ≤ r = 25/32` (was `7/8`), the bound `84 T` is used on
  `‖z‖ ≤ R = 15/16`. The count is `N ≤ M/log(R/r) = M/log(6/5) ≤ (50/9) M` (was `15 M`),
  `M = log(84 T)`.
* **Borel–Carathéodory at the point.** `borelCaratheodory'` is applied at the radius `‖z‖`
  itself, so `log‖B z‖ ≥ −2M‖z‖/(r − ‖z‖)` (`log_blaschke_ge`); the uniform form at `3/4` would
  give `−2M(3/4)/(1/32) = −48 M`, while the pointwise weight integrates to about `7.2 M` over the
  segment (`LittlewoodSharpLog.integral_bcw`). The singularity at `‖z‖ = r` is outside the
  segment `‖z‖ ≤ 3/4`.
* each Blaschke numerator `‖R − z ρ̄/R‖ ≤ R + (3/4) r/R = 25/16` (was `2`).

Result, off the zeros, for `‖z‖ ≤ 3/4`:

  `log‖f z‖ ≥ −2M‖z‖/(25/32 − ‖z‖) − N log(25/16) + Σ_ρ m_ρ log‖z − ρ‖`   (`log_jensenF_ge`).

**Sizes.** Every term is a multiple of `M = log T + O(1)`; no factor grows faster. The
pointwise weight has a logarithmic singularity at `r`, at distance `1/32` from the segment's
end, and integrates to a constant (`(25/8) log 25 − 3`); that is the factor the radii trade
against the count `1/log(R/r)`.

| name | content | status |
|---|---|---|
| `zeroSet hT` | zeros of `jensenF T` in `‖z‖ ≤ 25/32` | def |
| `zeroMass hT` | their total order (real) | def |
| `zeroMass_le` | `zeroMass hT ≤ (50/9) log(84 T)` | proved |
| `log_blaschke_ge` | `‖z‖ ≤ 3/4 ⊢ −2M‖z‖/(25/32 − ‖z‖) ≤ log‖B z‖` | proved |
| `norm_numer_le` | `‖15/16 − z ρ̄/(15/16)‖ ≤ 25/16` | proved |
| `norm_blaschke_mul_le` | `‖B z‖ ∏‖z−ρ‖^m ≤ ‖f z‖ (25/16)^N` | proved |
| `log_jensenF_ge` | the lower bound above | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib
import PrimeNumberTheoremAnd.StrongPNT
import Stage3.JensenCount
import Stage3.LittlewoodSharpLog

namespace LittlewoodSharp

open Complex Stage3

noncomputable section

theorem h2532 : (25 : ℝ) / 32 < 1 := by norm_num

/-- The zeros of `jensenF T` in `‖z‖ ≤ 25/32`. -/
def zeroSet {T : ℝ} (hT : 2 ≤ T) : Finset ℂ :=
  (finiteSetOfZeros_mono h2532 (jensenF_zeros_finite hT)).toFinset

/-- Their total order. -/
def zeroMass {T : ℝ} (hT : 2 ≤ T) : ℝ :=
  ∑ ρ ∈ zeroSet hT, (analyticOrderNatAt (jensenF T) ρ : ℝ)

theorem log84T_pos {T : ℝ} (hT : 2 ≤ T) : 0 < Real.log (84 * T) :=
  Real.log_pos (by linarith)

/-- **The zero count at the radii `25/32 < 15/16`.** -/
theorem zeroMass_le {T : ℝ} (hT : 2 ≤ T) : zeroMass hT ≤ 50 / 9 * Real.log (84 * T) := by
  have hZB := ZerosBound (B := 84 * T) (r := 25 / 32) (R := 15 / 16) (f := jensenF T)
    (by norm_num) h2532 (by norm_num) (by norm_num) (jensenF_analytic hT)
    (jensenF_zero_eq_one T) (jensenF_zeros_finite hT) (fun z hz => jensenF_bound hT hz)
  rw [show (15 : ℝ) / 16 / (25 / 32) = 6 / 5 by norm_num] at hZB
  have hl := log65_ge
  have hlpos : (0 : ℝ) < Real.log (6 / 5) := by linarith
  have hinv : 1 / Real.log (6 / 5) ≤ 50 / 9 := by
    rw [div_le_iff₀ hlpos]
    linarith
  have hM := log84T_pos hT
  unfold zeroMass zeroSet
  rw [← Nat.cast_sum]
  calc _ ≤ 1 / Real.log (6 / 5) * Real.log (84 * T) := hZB
    _ ≤ 50 / 9 * Real.log (84 * T) := mul_le_mul_of_nonneg_right hinv hM.le

/-- **Borel–Carathéodory at the point**, on the Blaschke quotient. -/
theorem log_blaschke_ge {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4) :
    -(2 * Real.log (84 * T) * ‖z‖ / (25 / 32 - ‖z‖)) ≤
      Real.log ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ := by
  have hf0 : jensenF T 0 ≠ 0 := by rw [jensenF_zero_eq_one]; exact one_ne_zero
  have hBan := BlaschkeAnalytic (r := 25 / 32) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0
  have hBnz := BlaschkeNonzero (r := 25 / 32) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0
  have hBbd : ∀ w ∈ Metric.closedBall (0 : ℂ) (15 / 16),
      ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) w‖ ≤ 84 * T := fun w hw =>
    DiskBound (r := 25 / 32) (R := 15 / 16) (by norm_num) (by norm_num) (by norm_num)
      (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0 (fun z hz => jensenF_bound hT hz) hw
  have hB0 : ‖jensenF T 0‖ ≤ ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) 0‖ :=
    norm_fOfZero_le_norm_BlaschkeOfZero (r := 25 / 32) (R := 15 / 16) (by norm_num)
      (by norm_num) (by norm_num) (jensenF_zeros_finite hT) hf0
  rw [jensenF_zero_eq_one, norm_one] at hB0
  have hlogB0 : 0 ≤ Real.log ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) 0‖ :=
    Real.log_nonneg hB0
  obtain ⟨J, hJan, hJ0, -, hJre⟩ := LogOfAnalyticFunction' (r' := 3 / 4) (r := 25 / 32)
    (R := 15 / 16) (by norm_num) (by norm_num) (by norm_num) hBan hBnz
  have hM := log84T_pos hT
  have hre : ∀ w ∈ Metric.ball (0 : ℂ) (25 / 32), (J w).re ≤ Real.log (84 * T) := by
    intro w hw
    rw [← hJre w hw]
    have hwc : w ∈ Metric.closedBall (0 : ℂ) (25 / 32) := Metric.ball_subset_closedBall hw
    have hwR : w ∈ Metric.closedBall (0 : ℂ) (15 / 16) :=
      Metric.closedBall_subset_closedBall (by norm_num) hwc
    have hpos : 0 < ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) w‖ :=
      norm_pos_iff.mpr (hBnz w hwc)
    have := Real.log_le_log hpos (hBbd w hwR)
    linarith
  have hzc : z ∈ Metric.closedBall (0 : ℂ) ‖z‖ := by
    rw [mem_closedBall_iff_norm, sub_zero]
  have hBC := borelCaratheodory' (M := Real.log (84 * T)) (r := ‖z‖) (R := 25 / 32) hM
    (by norm_num) (by linarith) hJan.analyticOn hJ0 hre hzc
  have hzb : z ∈ Metric.ball (0 : ℂ) (25 / 32) := by
    rw [mem_ball_iff_norm, sub_zero]; linarith
  have hJz := hJre z hzb
  have hneg : -‖J z‖ ≤ (J z).re := by
    have := Complex.abs_re_le_norm (J z)
    have := neg_abs_le (J z).re
    linarith
  linarith

/-- Each Blaschke numerator factor is at most `25/16` on `‖z‖ ≤ 3/4`. -/
theorem norm_numer_le {z ρ : ℂ} (hz : ‖z‖ ≤ 3 / 4) (hρ : ‖ρ‖ ≤ 25 / 32) :
    ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ≤ 25 / 16 := by
  have h1 := norm_sub_le (((15 / 16 : ℝ) : ℂ)) (z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ))
  have h2 : ‖z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ = ‖z‖ * ‖ρ‖ / (15 / 16) := by
    rw [norm_div, norm_mul, Complex.norm_conj, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (by norm_num : (0 : ℝ) < 15 / 16)]
  have h3 : ‖(((15 / 16 : ℝ)) : ℂ)‖ = 15 / 16 := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by norm_num : (0 : ℝ) < 15 / 16)]
  have h4 : ‖z‖ * ‖ρ‖ ≤ 3 / 4 * (25 / 32) :=
    mul_le_mul hz hρ (norm_nonneg _) (by norm_num)
  rw [h2, h3] at h1
  have h5 : ‖z‖ * ‖ρ‖ / (15 / 16) ≤ 3 / 4 * (25 / 32) / (15 / 16) :=
    div_le_div_of_nonneg_right h4 (by norm_num)
  linarith

/-- **Unfolding the Blaschke quotient off the zeros.** -/
theorem norm_blaschke_mul_le {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4)
    (hfz : jensenF T z ≠ 0) :
    ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ *
        ∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ
      ≤ ‖jensenF T z‖ * (25 / 16) ^ (∑ ρ ∈ zeroSet hT, analyticOrderNatAt (jensenF T) ρ) := by
  have hfin := finiteSetOfZeros_mono h2532 (jensenF_zeros_finite hT)
  have hzn : z ∉ SetOfZeros (25 / 32) (jensenF T) := fun h => hfz h.2
  have hne : ∀ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ ≠ 0 := by
    intro ρ hρ
    refine pow_ne_zero _ (norm_ne_zero_iff.mpr (sub_ne_zero.mpr ?_))
    intro h
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact hzn (h ▸ hρ)
  have hP : (∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr hne
  have hB : ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ =
      ‖jensenF T z‖ / (∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ) *
        ∏ ρ ∈ zeroSet hT, ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ^
          analyticOrderNatAt (jensenF T) ρ := by
    unfold BlaschkeB Cf
    simp only [hfin, hzn, ↓reduceDIte, Complex.norm_mul, Complex.norm_div, norm_prod, norm_pow]
    rfl
  have hQ : (∏ ρ ∈ zeroSet hT,
      ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ^
        analyticOrderNatAt (jensenF T) ρ) ≤
      ∏ ρ ∈ zeroSet hT, ((25 / 16 : ℝ)) ^ analyticOrderNatAt (jensenF T) ρ := by
    refine Finset.prod_le_prod (fun ρ _ => by positivity) ?_
    intro ρ hρ
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact pow_le_pow_left₀ (norm_nonneg _) (norm_numer_le hz hρ.1) _
  rw [Finset.prod_pow_eq_pow_sum] at hQ
  rw [hB, div_mul_eq_mul_div, div_mul_cancel₀ _ hP]
  exact mul_le_mul_of_nonneg_left hQ (norm_nonneg _)

/-- **The pointwise lower bound in the model's coordinates, sharper radii.** -/
theorem log_jensenF_ge {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4)
    (hfz : jensenF T z ≠ 0) :
    -(2 * Real.log (84 * T) * ‖z‖ / (25 / 32 - ‖z‖)) - zeroMass hT * Real.log (25 / 16) +
        ∑ ρ ∈ zeroSet hT, (analyticOrderNatAt (jensenF T) ρ : ℝ) * Real.log ‖z - ρ‖
      ≤ Real.log ‖jensenF T z‖ := by
  have hzn : z ∉ SetOfZeros (25 / 32) (jensenF T) := fun h => hfz h.2
  have hne : ∀ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ ≠ 0 := by
    intro ρ hρ
    refine pow_ne_zero _ (norm_ne_zero_iff.mpr (sub_ne_zero.mpr ?_))
    intro h
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact hzn (h ▸ hρ)
  have hzc : z ∈ Metric.closedBall (0 : ℂ) (25 / 32) := by
    rw [mem_closedBall_iff_norm, sub_zero]; linarith
  have hf0 : jensenF T 0 ≠ 0 := by rw [jensenF_zero_eq_one]; exact one_ne_zero
  have hBnz := BlaschkeNonzero (r := 25 / 32) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0 z hzc
  have hBpos : 0 < ‖BlaschkeB (25 / 32) (15 / 16) (jensenF T) z‖ := norm_pos_iff.mpr hBnz
  have hPpos : 0 < ∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ :=
    Finset.prod_pos (fun ρ hρ => lt_of_le_of_ne (by positivity) (hne ρ hρ).symm)
  have hle := norm_blaschke_mul_le hT hz hfz
  have hlog := Real.log_le_log (mul_pos hBpos hPpos) hle
  rw [Real.log_mul hBpos.ne' hPpos.ne', Real.log_mul (norm_ne_zero_iff.mpr hfz)
    (by positivity), Real.log_prod hne, Real.log_pow] at hlog
  simp only [Real.log_pow] at hlog
  have hlb := log_blaschke_ge hT hz
  have hmass : zeroMass hT = ((∑ ρ ∈ zeroSet hT, analyticOrderNatAt (jensenF T) ρ : ℕ) : ℝ) := by
    unfold zeroMass; push_cast; rfl
  rw [hmass]
  linarith

end

/-- info: 'LittlewoodSharp.zeroMass_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroMass_le

/-- info: 'LittlewoodSharp.log_blaschke_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_blaschke_ge

/-- info: 'LittlewoodSharp.log_jensenF_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_jensenF_ge

end LittlewoodSharp
