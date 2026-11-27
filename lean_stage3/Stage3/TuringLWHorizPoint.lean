/-
TuringLWHorizPoint — block S14 of `lean_stage3/design/stencil.md`, Turing's method, Littlewood's
pieces: the lower side `StmtHorizLower`, part 2, the pointwise lower bound for `log|ζ|` near the
segment. 2026-11-25.

The local model is the tree's `Stage3.jensenF T z = ζ(2z + 2 + iT)/ζ(2 + iT)`
(`Stage3/JensenCount.lean`): analytic on a neighbourhood of `‖z‖ ≤ 1`, `= 1` at `0`,
`‖·‖ ≤ 84 T` on `‖z‖ ≤ 15/16`. The segment `x + iT`, `x ∈ [1/2, 2]`, is `z = (x − 2)/2 ∈ [−3/4, 0]`.

**The route** (Titchmarsh §3.9, with upstream's StrongPNT machinery). `B = BlaschkeB (7/8) (15/16) f`
is `f` divided by `∏ (z − ρ)^{m_ρ}` over the zeros `ρ` with `‖ρ‖ ≤ 7/8` and multiplied by
`∏ (R − z ρ̄/R)^{m_ρ}`; it is analytic and zero-free on `‖z‖ ≤ 7/8` (`BlaschkeAnalytic`,
`BlaschkeNonzero`), `‖B‖ ≤ 84 T` on `‖z‖ ≤ 15/16` (`DiskBound`, maximum modulus), and
`‖B 0‖ ≥ ‖f 0‖ = 1`. `LogOfAnalyticFunction'` gives `J` analytic on `‖z‖ < 7/8`, `J 0 = 0`,
`Re J = log‖B‖ − log‖B 0‖ ≤ M := log(84 T)`. Borel–Carathéodory (`borelCaratheodory'`, radii
`3/4 < 7/8`) gives `‖J z‖ ≤ 2M(3/4)/(1/8) = 12 M` on `‖z‖ ≤ 3/4`, hence

  `log‖B z‖ ≥ −12 M`   (`log_blaschke_ge`).

Unfolding `B` off the zeros, each factor `‖R − z ρ̄/R‖ ≤ 2`, so `‖B z‖ ∏‖z − ρ‖^{m_ρ} ≤ ‖f z‖ 2^N`
with `N = Σ m_ρ` (`norm_blaschke_mul_le`), and

  `log‖f z‖ ≥ −12 M − N log 2 + Σ_ρ m_ρ log‖z − ρ‖`   (`log_jensenF_ge`).

`N ≤ 15 M` is `ZerosBound` at `r = 7/8`, `R = 15/16` (`zeroMass_le`, the computation of
`Stage3.zeta_local_zero_count` before its pull-back to `ζ`).

**Sizes.** Every term is `O(M) = O(log T)`: the Borel–Carathéodory loss is the factor
`2r/(R − r) = 12` on `M`, the Blaschke denominators cost `log 2` per zero, and the zero count
is `15 M`. No factor grows with `T` beyond `log T`.

| name | content | status |
|---|---|---|
| `zeroSet hT` | zeros of `jensenF T` in `‖z‖ ≤ 7/8`, a `Finset` | def |
| `zeroMass hT` | `Σ_{ρ ∈ zeroSet} m_ρ` (real) | def |
| `zeroMass_le` | `zeroMass hT ≤ 15 log(84 T)` | proved |
| `log_blaschke_ge` | `‖z‖ ≤ 3/4 ⊢ −12 log(84T) ≤ log‖B z‖` | proved |
| `norm_blaschke_mul_le` | `‖z‖ ≤ 3/4`, `f z ≠ 0` ⊢ `‖B z‖ ∏‖z−ρ‖^m ≤ ‖f z‖ 2^N` | proved |
| `log_jensenF_ge` | `‖z‖ ≤ 3/4`, `f z ≠ 0` ⊢ the lower bound above | proved |

Axioms: [propext, Classical.choice, Quot.sound], pinned below.
-/
import Mathlib
import PrimeNumberTheoremAnd.StrongPNT
import Stage3.JensenCount

namespace TuringLW

open Complex Stage3

noncomputable section

theorem h78 : (7 : ℝ) / 8 < 1 := by norm_num

/-- The zeros of `jensenF T` in `‖z‖ ≤ 7/8`. -/
def zeroSet {T : ℝ} (hT : 2 ≤ T) : Finset ℂ :=
  (finiteSetOfZeros_mono h78 (jensenF_zeros_finite hT)).toFinset

/-- Their total order. -/
def zeroMass {T : ℝ} (hT : 2 ≤ T) : ℝ :=
  ∑ ρ ∈ zeroSet hT, (analyticOrderNatAt (jensenF T) ρ : ℝ)

/-- `log 84 ≤ 4.86`. -/
theorem log84_le : Real.log 84 ≤ 4.86 := by
  have h128 : Real.log 84 ≤ Real.log 128 := Real.log_le_log (by norm_num) (by norm_num)
  have h2 : Real.log 128 = 7 * Real.log 2 := by
    rw [show (128 : ℝ) = 2 ^ (7 : ℕ) by norm_num, Real.log_pow]
    norm_num
  have h3 := Real.log_two_lt_d9
  linarith

/-- `log(84 T) = log 84 + log T > 0`. -/
theorem log84T_eq {T : ℝ} (hT : 2 ≤ T) : Real.log (84 * T) = Real.log 84 + Real.log T :=
  Real.log_mul (by norm_num) (by linarith)

theorem log84T_pos {T : ℝ} (hT : 2 ≤ T) : 0 < Real.log (84 * T) :=
  Real.log_pos (by linarith)

/-- **The zero count in the model's coordinates.** -/
theorem zeroMass_le {T : ℝ} (hT : 2 ≤ T) : zeroMass hT ≤ 15 * Real.log (84 * T) := by
  have hZB := ZerosBound (B := 84 * T) (r := 7 / 8) (R := 15 / 16) (f := jensenF T)
    (by norm_num) h78 (by norm_num) (by norm_num) (jensenF_analytic hT)
    (jensenF_zero_eq_one T) (jensenF_zeros_finite hT) (fun z hz => jensenF_bound hT hz)
  rw [show (15 : ℝ) / 16 / (7 / 8) = 15 / 14 by norm_num] at hZB
  have hlog1514 : (1 : ℝ) / 15 ≤ Real.log (15 / 14) := by
    have h1 : Real.log (14 / 15) ≤ 14 / 15 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
    rw [show (15 : ℝ) / 14 = ((14 : ℝ) / 15)⁻¹ by norm_num, Real.log_inv]
    linarith
  have hlog1514pos : (0 : ℝ) < Real.log (15 / 14) := by linarith
  have hinv : 1 / Real.log (15 / 14) ≤ 15 := by
    rw [div_le_iff₀ hlog1514pos]
    linarith
  have hM := log84T_pos hT
  unfold zeroMass zeroSet
  rw [← Nat.cast_sum]
  calc _ ≤ 1 / Real.log (15 / 14) * Real.log (84 * T) := hZB
    _ ≤ 15 * Real.log (84 * T) := mul_le_mul_of_nonneg_right hinv hM.le

/-- **Borel–Carathéodory on the Blaschke quotient.** -/
theorem log_blaschke_ge {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4) :
    -12 * Real.log (84 * T) ≤ Real.log ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) z‖ := by
  have hf0 : jensenF T 0 ≠ 0 := by rw [jensenF_zero_eq_one]; exact one_ne_zero
  have hBan := BlaschkeAnalytic (r := 7 / 8) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0
  have hBnz := BlaschkeNonzero (r := 7 / 8) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0
  have hBbd : ∀ w ∈ Metric.closedBall (0 : ℂ) (15 / 16),
      ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) w‖ ≤ 84 * T := fun w hw =>
    DiskBound (r := 7 / 8) (R := 15 / 16) (by norm_num) (by norm_num) (by norm_num)
      (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0 (fun z hz => jensenF_bound hT hz) hw
  have hB0 : ‖jensenF T 0‖ ≤ ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) 0‖ :=
    norm_fOfZero_le_norm_BlaschkeOfZero (r := 7 / 8) (R := 15 / 16) (by norm_num)
      (by norm_num) (by norm_num) (jensenF_zeros_finite hT) hf0
  rw [jensenF_zero_eq_one, norm_one] at hB0
  have hlogB0 : 0 ≤ Real.log ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) 0‖ :=
    Real.log_nonneg hB0
  obtain ⟨J, hJan, hJ0, -, hJre⟩ := LogOfAnalyticFunction' (r' := 3 / 4) (r := 7 / 8)
    (R := 15 / 16) (by norm_num) (by norm_num) (by norm_num) hBan hBnz
  have hM := log84T_pos hT
  have hre : ∀ w ∈ Metric.ball (0 : ℂ) (7 / 8), (J w).re ≤ Real.log (84 * T) := by
    intro w hw
    rw [← hJre w hw]
    have hwc : w ∈ Metric.closedBall (0 : ℂ) (7 / 8) := Metric.ball_subset_closedBall hw
    have hwR : w ∈ Metric.closedBall (0 : ℂ) (15 / 16) :=
      Metric.closedBall_subset_closedBall (by norm_num) hwc
    have hpos : 0 < ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) w‖ :=
      norm_pos_iff.mpr (hBnz w hwc)
    have := Real.log_le_log hpos (hBbd w hwR)
    linarith
  have hzc : z ∈ Metric.closedBall (0 : ℂ) (3 / 4) := by
    rw [mem_closedBall_iff_norm, sub_zero]; exact hz
  have hBC := borelCaratheodory' (M := Real.log (84 * T)) (r := 3 / 4) (R := 7 / 8) hM
    (by norm_num) (by norm_num) hJan.analyticOn hJ0 hre hzc
  have hzb : z ∈ Metric.ball (0 : ℂ) (7 / 8) := by
    rw [mem_ball_iff_norm, sub_zero]; linarith
  have hJz := hJre z hzb
  have hneg : -‖J z‖ ≤ (J z).re := by
    have := Complex.abs_re_le_norm (J z)
    have := neg_abs_le (J z).re
    linarith
  have hBCe : 2 * Real.log (84 * T) * (3 / 4) / (7 / 8 - 3 / 4) = 12 * Real.log (84 * T) := by
    ring
  rw [hBCe] at hBC
  linarith

/-- Each Blaschke numerator factor is at most `2` on `‖z‖ ≤ 3/4`. -/
theorem norm_numer_le {z ρ : ℂ} (hz : ‖z‖ ≤ 3 / 4) (hρ : ‖ρ‖ ≤ 7 / 8) :
    ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ≤ 2 := by
  have h1 := norm_sub_le (((15 / 16 : ℝ) : ℂ)) (z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ))
  have h2 : ‖z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ = ‖z‖ * ‖ρ‖ / (15 / 16) := by
    rw [norm_div, norm_mul, Complex.norm_conj, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (by norm_num : (0 : ℝ) < 15 / 16)]
  have h3 : ‖(((15 / 16 : ℝ)) : ℂ)‖ = 15 / 16 := by
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos (by norm_num : (0 : ℝ) < 15 / 16)]
  have h4 : ‖z‖ * ‖ρ‖ ≤ 3 / 4 * (7 / 8) :=
    mul_le_mul hz hρ (norm_nonneg _) (by norm_num)
  rw [h2, h3] at h1
  have h5 : ‖z‖ * ‖ρ‖ / (15 / 16) ≤ 3 / 4 * (7 / 8) / (15 / 16) :=
    div_le_div_of_nonneg_right h4 (by norm_num)
  linarith

/-- **Unfolding the Blaschke quotient off the zeros.** -/
theorem norm_blaschke_mul_le {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4)
    (hfz : jensenF T z ≠ 0) :
    ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) z‖ *
        ∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ
      ≤ ‖jensenF T z‖ * 2 ^ (∑ ρ ∈ zeroSet hT, analyticOrderNatAt (jensenF T) ρ) := by
  have hfin := finiteSetOfZeros_mono h78 (jensenF_zeros_finite hT)
  have hzn : z ∉ SetOfZeros (7 / 8) (jensenF T) := fun h => hfz h.2
  have hne : ∀ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ ≠ 0 := by
    intro ρ hρ
    refine pow_ne_zero _ (norm_ne_zero_iff.mpr (sub_ne_zero.mpr ?_))
    intro h
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact hzn (h ▸ hρ)
  have hP : (∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr hne
  have hB : ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) z‖ =
      ‖jensenF T z‖ / (∏ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ) *
        ∏ ρ ∈ zeroSet hT, ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ^
          analyticOrderNatAt (jensenF T) ρ := by
    unfold BlaschkeB Cf
    simp only [hfin, hzn, ↓reduceDIte, Complex.norm_mul, Complex.norm_div, norm_prod, norm_pow]
    rfl
  have hQ : (∏ ρ ∈ zeroSet hT,
      ‖((15 / 16 : ℝ) : ℂ) - z * (starRingEnd ℂ) ρ / ((15 / 16 : ℝ) : ℂ)‖ ^
        analyticOrderNatAt (jensenF T) ρ) ≤
      ∏ ρ ∈ zeroSet hT, (2 : ℝ) ^ analyticOrderNatAt (jensenF T) ρ := by
    refine Finset.prod_le_prod (fun ρ _ => by positivity) ?_
    intro ρ hρ
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact pow_le_pow_left₀ (norm_nonneg _) (norm_numer_le hz hρ.1) _
  rw [Finset.prod_pow_eq_pow_sum] at hQ
  rw [hB, div_mul_eq_mul_div, div_mul_cancel₀ _ hP]
  exact mul_le_mul_of_nonneg_left hQ (norm_nonneg _)

/-- **The pointwise lower bound in the model's coordinates.** -/
theorem log_jensenF_ge {T : ℝ} (hT : 2 ≤ T) {z : ℂ} (hz : ‖z‖ ≤ 3 / 4)
    (hfz : jensenF T z ≠ 0) :
    -12 * Real.log (84 * T) - zeroMass hT * Real.log 2 +
        ∑ ρ ∈ zeroSet hT, (analyticOrderNatAt (jensenF T) ρ : ℝ) * Real.log ‖z - ρ‖
      ≤ Real.log ‖jensenF T z‖ := by
  have hfin := finiteSetOfZeros_mono h78 (jensenF_zeros_finite hT)
  have hzn : z ∉ SetOfZeros (7 / 8) (jensenF T) := fun h => hfz h.2
  have hne : ∀ ρ ∈ zeroSet hT, ‖z - ρ‖ ^ analyticOrderNatAt (jensenF T) ρ ≠ 0 := by
    intro ρ hρ
    refine pow_ne_zero _ (norm_ne_zero_iff.mpr (sub_ne_zero.mpr ?_))
    intro h
    rw [zeroSet, Set.Finite.mem_toFinset] at hρ
    exact hzn (h ▸ hρ)
  have hzc : z ∈ Metric.closedBall (0 : ℂ) (7 / 8) := by
    rw [mem_closedBall_iff_norm, sub_zero]; linarith
  have hf0 : jensenF T 0 ≠ 0 := by rw [jensenF_zero_eq_one]; exact one_ne_zero
  have hBnz := BlaschkeNonzero (r := 7 / 8) (R := 15 / 16) (by norm_num) (by norm_num)
    (by norm_num) (jensenF_zeros_finite hT) (jensenF_analytic hT) hf0 z hzc
  have hBpos : 0 < ‖BlaschkeB (7 / 8) (15 / 16) (jensenF T) z‖ := norm_pos_iff.mpr hBnz
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

/-- info: 'TuringLW.zeroMass_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroMass_le

/-- info: 'TuringLW.log_blaschke_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_blaschke_ge

/-- info: 'TuringLW.log_jensenF_ge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms log_jensenF_ge

end TuringLW
