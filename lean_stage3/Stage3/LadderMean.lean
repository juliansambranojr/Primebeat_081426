/-
LadderMean — block J10c of `lean_stage3/design/joints.md`. 2026-11-22.

Joint 10 on the table's own ladder, third piece. `LadderFading` showed that
finitely many modes of one size cannot fade. Here the modes may be infinitely
many, with weights that are absolutely summable: averaging along the rows
picks out the weight of one folded class, so a sum that fades has every folded
class of weight zero. For the zeros of ζ on one vertical line the folded
classes have weight with positive real part, so they cannot fade.

  geom_mean_norm_le          ‖ξ‖ = 1 ⊢ the mean of ξ^r over r < N has norm ≤ 1
  geom_mean_tendsto_zero     ‖ξ‖ = 1, ξ ≠ 1 ⊢ that mean tends to 0
  mean_extract               ‖w i‖ = 1, Summable ‖C i‖, Σ' i, C i·w i^r → 0
                               ⊢ Σ' i, (if w i = w k then C i else 0) = 0
  coef, zOf                  coef ρ = m(ρ)/ρ, zOf ρ = 2^ρ
  line_not_fading_summable   S a set of zeros, Re ρ = β on S, ρ₀ ∈ S,
                               Summable ‖coef ρ‖ over S
                               ⊢ Σ' ρ ∈ S, coef ρ·Sym 2 ρ^d·mode 2 ρ r / (2^β)^r
                                 does not tend to 0

What the next slice needs: one line has to dominate. The case with no largest
real part is recorded as open in the decision unit beside this one.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LadderFading

namespace LadderMean

open Finset Filter Topology

noncomputable section

/-- The mean of the powers of a point on the unit circle is at most one in size. -/
theorem geom_mean_norm_le {ξ : ℂ} (hξ : ‖ξ‖ = 1) (N : ℕ) :
    ‖((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, ξ ^ r‖ ≤ 1 := by
  rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg N))]
  have hS : ‖∑ r ∈ range N, ξ ^ r‖ ≤ N := by
    calc ‖∑ r ∈ range N, ξ ^ r‖ ≤ ∑ r ∈ range N, ‖ξ ^ r‖ := norm_sum_le _ _
      _ = N := by simp [norm_pow, hξ]
  rcases Nat.eq_zero_or_pos N with rfl | hN
  · simp
  · have hN' : (0 : ℝ) < N := Nat.cast_pos.mpr hN
    calc (N : ℝ)⁻¹ * ‖∑ r ∈ range N, ξ ^ r‖
        ≤ (N : ℝ)⁻¹ * N := mul_le_mul_of_nonneg_left hS (inv_nonneg.mpr hN'.le)
      _ = 1 := inv_mul_cancel₀ hN'.ne'

/-- The mean of the powers of a point on the unit circle other than one tends
to zero: a rotation that is not the identity averages out. -/
theorem geom_mean_tendsto_zero {ξ : ℂ} (hξ : ‖ξ‖ = 1) (hne : ξ ≠ 1) :
    Tendsto (fun N : ℕ => ((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, ξ ^ r) atTop (𝓝 0) := by
  have hd : 0 < ‖ξ - 1‖ := norm_pos_iff.mpr (sub_ne_zero.mpr hne)
  refine squeeze_zero_norm (a := fun N : ℕ => (N : ℝ)⁻¹ * (2 / ‖ξ - 1‖)) (fun N => ?_) ?_
  · rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg (inv_nonneg.mpr (Nat.cast_nonneg N)),
      geom_sum_eq hne N, norm_div]
    have hnum : ‖ξ ^ N - 1‖ ≤ 2 := by
      calc ‖ξ ^ N - 1‖ ≤ ‖ξ ^ N‖ + ‖(1 : ℂ)‖ := norm_sub_le _ _
        _ = 2 := by rw [norm_pow, hξ, one_pow, norm_one]; norm_num
    exact mul_le_mul_of_nonneg_left (div_le_div_of_nonneg_right hnum hd.le)
      (inv_nonneg.mpr (Nat.cast_nonneg N))
  · have h := (tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop).mul_const
      (2 / ‖ξ - 1‖)
    simpa using h

/-- **Averaging along the rows picks out one folded class.** If an absolutely
summable sum of rotations tends to zero along the rows, then for every mode the
weights of all the modes equal to it add to zero. -/
theorem mean_extract {ι : Type*} (w C : ι → ℂ) (hw : ∀ i, ‖w i‖ = 1)
    (hC : Summable fun i => ‖C i‖) (k : ι)
    (h : Tendsto (fun r : ℕ => ∑' i, C i * w i ^ r) atTop (𝓝 0)) :
    ∑' i, (if w i = w k then C i else 0) = 0 := by
  classical
  have hwk : w k ≠ 0 := fun h0 => by
    have h1 := hw k
    rw [h0, norm_zero] at h1
    exact zero_ne_one h1
  have hξ : ∀ i, ‖w i / w k‖ = 1 := fun i => by rw [norm_div, hw i, hw k, div_one]
  have hsumr : ∀ r : ℕ, Summable fun i => C i * (w i / w k) ^ r := fun r =>
    Summable.of_norm_bounded hC (fun i => by
      rw [norm_mul, norm_pow, hξ i, one_pow, mul_one])
  have hu : Tendsto (fun r : ℕ => ∑' i, C i * (w i / w k) ^ r) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero] at h ⊢
    refine h.congr fun r => ?_
    have e : ∑' i, C i * (w i / w k) ^ r = (∑' i, C i * w i ^ r) * ((w k)⁻¹) ^ r := by
      rw [← tsum_mul_right]
      refine tsum_congr fun i => ?_
      rw [div_eq_mul_inv, mul_pow]
      ring
    rw [e, norm_mul, norm_pow, norm_inv, hw k, inv_one, one_pow, mul_one]
  have hces := hu.cesaro_smul
  have hmean : ∀ N : ℕ, ((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, ∑' i, C i * (w i / w k) ^ r
      = ∑' i, C i * (((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, (w i / w k) ^ r) := by
    intro N
    rw [← Summable.tsum_finsetSum (fun r _ => hsumr r),
      ← Summable.tsum_const_smul _ (summable_sum fun r _ => hsumr r)]
    refine tsum_congr fun i => ?_
    rw [← Finset.mul_sum, mul_smul_comm]
  have hdom : Tendsto
      (fun N : ℕ => ∑' i, C i * (((N : ℝ)⁻¹ : ℝ) • ∑ r ∈ range N, (w i / w k) ^ r))
      atTop (𝓝 (∑' i, (if w i = w k then C i else 0))) := by
    refine tendsto_tsum_of_dominated_convergence (bound := fun i => ‖C i‖) hC
      (fun i => ?_) (Eventually.of_forall fun N i => ?_)
    · by_cases hik : w i = w k
      · rw [if_pos hik]
        have h1 : w i / w k = 1 := by rw [hik, div_self hwk]
        refine tendsto_const_nhds.congr' ?_
        filter_upwards [eventually_gt_atTop 0] with N hN
        have hS : (∑ r ∈ range N, (1 : ℂ) ^ r) = (N : ℂ) := by simp
        have hNC : (N : ℂ) ≠ 0 := by exact_mod_cast hN.ne'
        rw [h1, hS, Complex.real_smul]
        push_cast
        rw [inv_mul_cancel₀ hNC, mul_one]
      · rw [if_neg hik]
        have hne : w i / w k ≠ 1 := fun h1 => hik ((div_eq_one_iff_eq hwk).mp h1)
        have h0 := (geom_mean_tendsto_zero (hξ i) hne).const_mul (C i)
        simpa using h0
    · rw [norm_mul]
      exact mul_le_of_le_one_right (norm_nonneg _) (geom_mean_norm_le (hξ i) N)
  exact tendsto_nhds_unique hdom (hces.congr hmean)

/-- The coefficient a zero carries in the cell: its multiplicity over the zero. -/
def coef (ρ : Kadiri.NontrivialZeros) : ℂ :=
  (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)

/-- The mode of a zero on the ladder: two to the zero. -/
def zOf (ρ : Kadiri.NontrivialZeros) : ℂ := (2 : ℂ) ^ (ρ : ℂ)

/-- **Infinitely many zeros on one line do not fade from the cells.** Take any
set of zeros of ζ with one real part `β`, with `Σ m(ρ)/|ρ|` finite over it, and
one zero in it. Their contribution to the cell `(r, d)` of the table's own
ladder, measured against `2^(rβ)`, does not tend to zero as the rows go on. -/
theorem line_not_fading_summable (S : Set Kadiri.NontrivialZeros) {β : ℝ}
    (hβ : ∀ ρ ∈ S, (ρ : ℂ).re = β) (ρ₀ : Kadiri.NontrivialZeros) (hρ₀ : ρ₀ ∈ S)
    (hsum : Summable fun ρ : S => ‖coef ρ‖) (d : ℕ) :
    ¬ Tendsto (fun r : ℕ =>
        (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d
          * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
  classical
  intro hlim
  have hRpos : (0 : ℝ) < (2 : ℝ) ^ β := Real.rpow_pos_of_pos (by norm_num) β
  have hR0 : ((((2 : ℝ) ^ β : ℝ)) : ℂ) ≠ 0 := by exact_mod_cast hRpos.ne'
  have hRn : ‖((((2 : ℝ) ^ β : ℝ)) : ℂ)‖ = (2 : ℝ) ^ β := by
    rw [Complex.norm_real, Real.norm_of_nonneg hRpos.le]
  have hzn : ∀ ρ : S, ‖zOf ρ‖ = (2 : ℝ) ^ β := fun ρ => by
    have h2 : ((2 : ℂ)) = ((2 : ℝ) : ℂ) := by norm_num
    unfold zOf
    rw [h2, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num), hβ ρ ρ.2]
  have hz1 : ∀ ρ : S, 1 < ‖zOf ρ‖ := fun ρ => by
    rw [hzn ρ, ← hβ ρ ρ.2]
    exact Real.one_lt_rpow (by norm_num) (AliasClass.zero_re_pos ρ)
  have hw : ∀ ρ : S, ‖zOf ρ / ((((2 : ℝ) ^ β : ℝ)) : ℂ)‖ = 1 := fun ρ => by
    rw [norm_div, hzn ρ, hRn, div_self hRpos.ne']
  -- the weights with the depth factor are summable
  have hsym : ∀ ρ : S, ‖(1 - (zOf ρ)⁻¹) ^ d‖ ≤ 2 ^ d := fun ρ => by
    rw [norm_pow]
    refine pow_le_pow_left₀ (norm_nonneg _) ?_ d
    have hinv : ‖(zOf ρ)⁻¹‖ ≤ 1 := by
      rw [norm_inv]
      exact inv_le_one_of_one_le₀ (hz1 ρ).le
    calc ‖(1 : ℂ) - (zOf ρ)⁻¹‖ ≤ ‖(1 : ℂ)‖ + ‖(zOf ρ)⁻¹‖ := norm_sub_le _ _
      _ ≤ 2 := by rw [norm_one]; linarith
  have hC : Summable fun ρ : S => ‖coef ρ * (1 - (zOf ρ)⁻¹) ^ d‖ := by
    refine Summable.of_nonneg_of_le (fun ρ => norm_nonneg _) (fun ρ => ?_)
      (hsum.mul_right ((2 : ℝ) ^ d))
    rw [norm_mul]
    exact mul_le_mul_of_nonneg_left (hsym ρ) (norm_nonneg _)
  -- the sum, as rotations
  have hrot : ∀ r : ℕ,
      (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d
          * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ β : ℝ)) : ℂ) ^ r
      = ∑' ρ : S, (coef ρ * (1 - (zOf ρ)⁻¹) ^ d)
          * (zOf ρ / ((((2 : ℝ) ^ β : ℝ)) : ℂ)) ^ r := by
    intro r
    rw [← tsum_div_const]
    refine tsum_congr fun ρ => ?_
    rw [CellModes.sym_two, CellModes.mode_two_int, zpow_natCast, div_pow]
    unfold zOf
    rw [mul_div_assoc]
  have hext := mean_extract (fun ρ : S => zOf ρ / ((((2 : ℝ) ^ β : ℝ)) : ℂ))
    (fun ρ : S => coef ρ * (1 - (zOf ρ)⁻¹) ^ d) hw hC ⟨ρ₀, hρ₀⟩
    (hlim.congr hrot)
  -- the class of ρ₀: common symbol, coefficients with positive real part
  have hK : (1 - (zOf ρ₀)⁻¹) ^ d ≠ 0 :=
    pow_ne_zero d (LadderFading.one_sub_inv_ne_zero (hz1 ⟨ρ₀, hρ₀⟩))
  have hcls : ∀ ρ : S,
      (if zOf ρ / ((((2 : ℝ) ^ β : ℝ)) : ℂ) = zOf ρ₀ / ((((2 : ℝ) ^ β : ℝ)) : ℂ)
        then coef ρ * (1 - (zOf ρ)⁻¹) ^ d else 0)
      = (if zOf ρ = zOf ρ₀ then coef ρ else 0) * (1 - (zOf ρ₀)⁻¹) ^ d := by
    intro ρ
    by_cases hz : zOf ρ = zOf ρ₀
    · rw [if_pos (by rw [hz]), if_pos hz, hz]
    · have hz' : ¬ (zOf ρ / ((((2 : ℝ) ^ β : ℝ)) : ℂ)
          = zOf ρ₀ / ((((2 : ℝ) ^ β : ℝ)) : ℂ)) := fun h => hz ((div_left_inj' hR0).mp h)
      rw [if_neg hz', if_neg hz, zero_mul]
  rw [tsum_congr hcls, tsum_mul_right] at hext
  have hzero : ∑' ρ : S, (if zOf ρ = zOf ρ₀ then coef ρ else 0) = 0 :=
    (mul_eq_zero.mp hext).resolve_right hK
  have hs : Summable fun ρ : S => (if zOf ρ = zOf ρ₀ then coef ρ else 0) :=
    Summable.of_norm_bounded hsum (fun ρ => by
      by_cases hz : zOf ρ = zOf ρ₀
      · rw [if_pos hz]
      · rw [if_neg hz, norm_zero]
        exact norm_nonneg _)
  have hre := Complex.re_tsum hs
  rw [hzero, Complex.zero_re] at hre
  have hpos : 0 < ∑' ρ : S, ((if zOf ρ = zOf ρ₀ then coef ρ else 0) : ℂ).re := by
    refine Summable.tsum_pos (Complex.hasSum_re hs.hasSum).summable (fun ρ => ?_)
      ⟨ρ₀, hρ₀⟩ ?_
    · by_cases hz : zOf ρ = zOf ρ₀
      · rw [if_pos hz]
        exact (AliasClass.re_order_div_pos ρ).le
      · rw [if_neg hz, Complex.zero_re]
    · rw [if_pos rfl]
      exact AliasClass.re_order_div_pos ρ₀
  linarith

/-- info: 'LadderMean.mean_extract' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mean_extract

/-- info: 'LadderMean.line_not_fading_summable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms line_not_fading_summable

end

end LadderMean
