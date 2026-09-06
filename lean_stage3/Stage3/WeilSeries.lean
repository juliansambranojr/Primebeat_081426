/-
WeilSeries — the band series made explicit. Rung 4b, second half, slice B2
of the detection ladder (units 0316–0322). 2026-09-06.

Unit 0322 bounds the on-line sum over heights `≥ 11/10` by any nonnegative
summable band series `M` that dominates the terms at their band indices.
This slice builds one from unit 0320's near and far bounds and sums it in
closed form:

  M h γ k
      `4h²` when band `k` is within one step of the band of `γ`
      (unit 0320's near bound), else `cFar / (h²·|k − idx γ|⁴)` with
      `cFar = (2π+π²)²·(10/9)⁴` (unit 0320's far bound, after the
      distance from a zero in band `k` to `γ` is read off the band gap:
      `|t − γ| ≥ (9/5)|k − k₀| − 9/5 ≥ (9/10)|k − k₀|` when `|k − k₀| ≥ 2`).
  term_le_M
      every on-line term of height `≥ 11/10` is at most `M` at its index.
  bandTerm_le_A
      `M k·(15·log (centre k) + 73) ≤ A/(k+1)³` with
      `A = 88·(idx γ + 3)⁴·(4h² + cFar/h²)`, using `log x ≤ x − 1` and
      `(k+1) ≤ |k − k₀|·(k₀+3)` off the near bands.
  bandSeries_summable, bandSeries_le
      hence the band series is summable and at most `A·π²/6`, by comparison
      with `Σ 1/(k+1)²` (`hasSum_zeta_two`).
  tsum_upper_le_explicit'
      the full weighted on-line sum over heights `≥ 11/10` is at most
      `88·(γ+3)⁴·(4h² + cFar/h²)·π²/6`, for `h > 0`, `γ ≥ 11/10`.

Crude-explicit throughout: the quartic in `γ` comes from `log x ≤ x` and the
lattice-to-index comparison, and is the price of a closed form with no
literature constant. Left for B3: heights below `11/10` and negative heights.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilTiles

namespace WeilSeries

noncomputable section

open Complex WeilDetect WeilBackground WeilBands WeilTiles Real

/-- The far constant `(2π+π²)²·(10/9)⁴`. -/
def cFar : ℝ := (2 * Real.pi + Real.pi ^ 2) ^ 2 * (10 / 9) ^ 4

theorem cFar_nonneg : 0 ≤ cFar := by
  unfold cFar
  positivity

/-- The dominating band series. -/
def M (h γ : ℝ) (k : ℕ) : ℝ :=
  if |(k : ℝ) - (idx γ : ℝ)| ≤ 1 then 4 * h ^ 2
  else cFar / (h ^ 2 * |(k : ℝ) - (idx γ : ℝ)| ^ 4)

theorem M_nonneg (h γ : ℝ) (k : ℕ) : 0 ≤ M h γ k := by
  unfold M
  split_ifs
  · positivity
  · exact div_nonneg cFar_nonneg (by positivity)

/-- A gap between naturals that exceeds `1` is at least `2`. -/
theorem two_le_of_one_lt {k k0 : ℕ} (h : 1 < |(k : ℝ) - (k0 : ℝ)|) :
    2 ≤ |(k : ℝ) - (k0 : ℝ)| := by
  have e : (k : ℝ) - (k0 : ℝ) = (((k : ℤ) - (k0 : ℤ) : ℤ) : ℝ) := by push_cast; ring
  rw [e, ← Int.cast_abs] at h ⊢
  have h' : (1 : ℤ) < |(k : ℤ) - (k0 : ℤ)| := by exact_mod_cast h
  have h2 : (1 : ℤ) + 1 ≤ |(k : ℤ) - (k0 : ℤ)| := Int.add_one_le_iff.mpr h'
  exact_mod_cast h2

/-- The distance from a height to `γ`, read off the band gap. -/
theorem dist_ge {t γ : ℝ} (ht : 11 / 10 ≤ t) (hγ : 11 / 10 ≤ γ) :
    9 / 5 * |(idx t : ℝ) - (idx γ : ℝ)| - 9 / 5 ≤ |t - γ| := by
  have h1 := abs_le.mp (idx_spec ht)
  have h2 := abs_le.mp (idx_spec hγ)
  have c1 : centre (idx t) = 2 + 9 / 5 * (idx t : ℝ) := rfl
  have c2 : centre (idx γ) = 2 + 9 / 5 * (idx γ : ℝ) := rfl
  rw [c1] at h1
  rw [c2] at h2
  have ha := le_abs_self (t - γ)
  have hb := neg_abs_le (t - γ)
  rcases le_or_gt 0 ((idx t : ℝ) - (idx γ : ℝ)) with hd | hd
  · rw [abs_of_nonneg hd]
    linarith
  · rw [abs_of_neg hd]
    linarith

/-- **Domination.** Every on-line term of height `≥ 11/10` is at most `M` at
its band index. -/
theorem term_le_M {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (ρ : Kadiri.NontrivialZeros)
    (hre : (ρ : ℂ).re = 1 / 2) (him : 11 / 10 ≤ (ρ : ℂ).im) :
    (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
      ≤ M h γ (idx (ρ : ℂ).im) := by
  unfold M
  split_ifs with hnear
  · exact online_term_le_near hh γ hre
  · push Not at hnear
    have h2 := two_le_of_one_lt hnear
    set d := |(idx (ρ : ℂ).im : ℝ) - (idx γ : ℝ)| with hd
    have hdist := dist_ge him hγ
    have hD : 9 / 10 * d ≤ |(ρ : ℂ).im - γ| := by linarith
    have hfar : 1 ≤ |(ρ : ℂ).im - γ| := by linarith
    have hsum : 1 ≤ (ρ : ℂ).im + γ := by linarith
    refine (online_term_le_far hh γ hre hfar hsum).trans ?_
    set c := 2 * Real.pi + Real.pi ^ 2 with hc
    have hc0 : 0 < c := by rw [hc]; positivity
    set t := (ρ : ℂ).im with ht
    have hd0 : 0 < d := by linarith
    have hh' : h ≠ 0 := hh.ne'
    have hne : t - γ ≠ 0 := by
      intro h0
      rw [h0, abs_zero] at hfar
      linarith
    have hA : (t - γ) ^ 2 ≤ (t + γ) ^ 2 := by nlinarith [him, hγ]
    have hB : c / (h * (t + γ)) ^ 2 ≤ c / (h * (t - γ)) ^ 2 := by
      apply div_le_div_of_nonneg_left hc0.le (by positivity)
      rw [mul_pow, mul_pow]
      exact mul_le_mul_of_nonneg_left hA (by positivity)
    have hS : c / (h * (t - γ)) ^ 2 + c / (h * (t + γ)) ^ 2
        ≤ 2 * (c / (h * (t - γ)) ^ 2) := by linarith
    have hS0 : 0 ≤ c / (h * (t - γ)) ^ 2 + c / (h * (t + γ)) ^ 2 := by positivity
    have h4 : (9 / 10 * d) ^ 4 ≤ (t - γ) ^ 4 := by
      rw [← abs_of_nonneg (by positivity : (0 : ℝ) ≤ (t - γ) ^ 4), abs_pow]
      exact pow_le_pow_left₀ (by positivity) hD 4
    calc (h / 2) ^ 2 * (c / (h * (t - γ)) ^ 2 + c / (h * (t + γ)) ^ 2) ^ 2
        ≤ (h / 2) ^ 2 * (2 * (c / (h * (t - γ)) ^ 2)) ^ 2 := by
          apply mul_le_mul_of_nonneg_left _ (by positivity)
          exact pow_le_pow_left₀ hS0 hS 2
      _ = c ^ 2 / (h ^ 2 * (t - γ) ^ 4) := by
          field_simp
          try ring
      _ ≤ c ^ 2 / (h ^ 2 * (9 / 10 * d) ^ 4) := by
          apply div_le_div_of_nonneg_left (by positivity) (by positivity)
          exact mul_le_mul_of_nonneg_left h4 (by positivity)
      _ = cFar / (h ^ 2 * d ^ 4) := by
          unfold cFar
          rw [hc]
          field_simp
          try ring

/-- The crude constant: `M k·(15·log (centre k) + 73) ≤ A/(k+1)³`. -/
def A (h γ : ℝ) : ℝ := 88 * ((idx γ : ℝ) + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2)

theorem four_h_add_nonneg (h : ℝ) : 0 ≤ 4 * h ^ 2 + cFar / h ^ 2 := by
  have h1 : 0 ≤ cFar / h ^ 2 := div_nonneg cFar_nonneg (sq_nonneg h)
  have h2 : 0 ≤ 4 * h ^ 2 := by positivity
  linarith

theorem A_nonneg (h γ : ℝ) : 0 ≤ A h γ := by
  unfold A
  exact mul_nonneg (mul_nonneg (by norm_num) (by positivity)) (four_h_add_nonneg h)

/-- The band weight, with `log x ≤ x − 1`. -/
theorem weight_le (k : ℕ) : 15 * Real.log (centre k) + 73 ≤ 88 * ((k : ℝ) + 1) := by
  have h1 : Real.log (centre k) ≤ centre k - 1 :=
    Real.log_le_sub_one_of_pos (by linarith [two_le_centre k])
  have hc : centre k = 2 + 9 / 5 * (k : ℝ) := rfl
  have hk : (0 : ℝ) ≤ k := Nat.cast_nonneg k
  rw [hc] at h1 ⊢
  linarith

theorem weight_nonneg (k : ℕ) : 0 ≤ 15 * Real.log (centre k) + 73 := by
  have := Real.log_nonneg (by linarith [two_le_centre k] : 1 ≤ centre k)
  linarith

/-- **Comparison.** Each band term is at most `A/(k+1)³`. -/
theorem bandTerm_le_A {h γ : ℝ} (hh : 0 < h) (k : ℕ) :
    M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ / ((k : ℝ) + 1) ^ 3 := by
  set K := (idx γ : ℝ) with hK
  have hK0 : 0 ≤ K := Nat.cast_nonneg _
  have hk0 : (0 : ℝ) ≤ k := Nat.cast_nonneg _
  have hw := weight_le k
  have hw0 := weight_nonneg k
  have hh' : h ≠ 0 := hh.ne'
  have hc4 := four_h_add_nonneg h
  unfold M A
  split_ifs with hnear
  · have hkK : (k : ℝ) ≤ K + 1 := by
      have := (abs_le.mp hnear).2
      linarith
    rw [le_div_iff₀ (by positivity)]
    have hk1 : (k : ℝ) + 1 ≤ K + 3 := by linarith
    have hp3 : ((k : ℝ) + 1) ^ 3 ≤ (K + 3) ^ 3 := pow_le_pow_left₀ (by positivity) hk1 3
    have hw' : 15 * Real.log (centre k) + 73 ≤ 88 * (K + 3) := by linarith
    calc 4 * h ^ 2 * (15 * Real.log (centre k) + 73) * ((k : ℝ) + 1) ^ 3
        ≤ 4 * h ^ 2 * (88 * (K + 3)) * (K + 3) ^ 3 := by
          apply mul_le_mul (mul_le_mul_of_nonneg_left hw' (by positivity)) hp3
            (by positivity) (by positivity)
      _ = 88 * (K + 3) ^ 4 * (4 * h ^ 2) := by ring
      _ ≤ 88 * (K + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) := by
          apply mul_le_mul_of_nonneg_left _ (by positivity)
          have := div_nonneg cFar_nonneg (sq_nonneg h)
          linarith
  · push Not at hnear
    have h2 := two_le_of_one_lt hnear
    set d := |(k : ℝ) - K| with hd
    have hkd : (k : ℝ) - K ≤ d := le_abs_self _
    have hk1 : (k : ℝ) + 1 ≤ d * (K + 3) := by nlinarith
    have hp : ((k : ℝ) + 1) ^ 4 ≤ d ^ 4 * (K + 3) ^ 4 := by
      rw [← mul_pow]
      exact pow_le_pow_left₀ (by positivity) hk1 4
    have hd0 : 0 < d := by linarith
    rw [div_mul_eq_mul_div, div_le_div_iff₀ (by positivity) (by positivity)]
    have hw' : cFar * (15 * Real.log (centre k) + 73) ≤ cFar * (88 * ((k : ℝ) + 1)) :=
      mul_le_mul_of_nonneg_left hw cFar_nonneg
    have e : 88 * (K + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (h ^ 2 * d ^ 4)
        = 88 * (K + 3) ^ 4 * d ^ 4 * cFar + 88 * (K + 3) ^ 4 * d ^ 4 * (4 * h ^ 4) := by
      field_simp
      ring
    rw [e]
    have hpos : 0 ≤ 88 * (K + 3) ^ 4 * d ^ 4 * (4 * h ^ 4) := by positivity
    have h88 : 0 ≤ 88 * cFar := mul_nonneg (by norm_num) cFar_nonneg
    calc cFar * (15 * Real.log (centre k) + 73) * ((k : ℝ) + 1) ^ 3
        ≤ cFar * (88 * ((k : ℝ) + 1)) * ((k : ℝ) + 1) ^ 3 :=
          mul_le_mul_of_nonneg_right hw' (by positivity)
      _ = 88 * cFar * ((k : ℝ) + 1) ^ 4 := by ring
      _ ≤ 88 * cFar * (d ^ 4 * (K + 3) ^ 4) := mul_le_mul_of_nonneg_left hp h88
      _ = 88 * (K + 3) ^ 4 * d ^ 4 * cFar := by ring
      _ ≤ 88 * (K + 3) ^ 4 * d ^ 4 * cFar + 88 * (K + 3) ^ 4 * d ^ 4 * (4 * h ^ 4) := by
          linarith

theorem summable_shift3 : Summable (fun k : ℕ => 1 / ((k : ℝ) + 1) ^ 3) := by
  have h := (summable_nat_add_iff 1).mpr
    (Real.summable_one_div_nat_pow.mpr (by norm_num : 1 < 3))
  refine h.congr ?_
  intro n
  push_cast
  ring

theorem summable_shift2 : Summable (fun k : ℕ => 1 / ((k : ℝ) + 1) ^ 2) := by
  have h := (summable_nat_add_iff 1).mpr
    (Real.summable_one_div_nat_pow.mpr (by norm_num : 1 < 2))
  refine h.congr ?_
  intro n
  push_cast
  ring

/-- **Summability** of the band series, by comparison with `A/(k+1)³`. -/
theorem bandSeries_summable {h γ : ℝ} (hh : 0 < h) :
    Summable (fun k : ℕ => M h γ k * (15 * Real.log (centre k) + 73)) := by
  apply Summable.of_nonneg_of_le (fun k => bandSeries_nonneg (M h γ) (M_nonneg h γ) k)
    (fun k => bandTerm_le_A hh k)
  refine (summable_shift3.mul_left (A h γ)).congr ?_
  intro k
  ring

/-- `Σ_{k≥0} 1/(k+1)² = π²/6`, from `hasSum_zeta_two`. -/
theorem tsum_shift2 : ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6 := by
  have h := hasSum_zeta_two
  have e := h.summable.tsum_eq_zero_add
  rw [h.tsum_eq] at e
  simp only [CharP.cast_eq_zero, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
    div_zero, zero_add] at e
  rw [e]
  congr 1
  ext n
  push_cast
  ring

/-- **The band series in closed form:** at most `A·π²/6`. -/
theorem bandSeries_le {h γ : ℝ} (hh : 0 < h) :
    ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ * (Real.pi ^ 2 / 6) := by
  have hA := A_nonneg h γ
  calc ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73)
      ≤ ∑' k : ℕ, A h γ * (1 / ((k : ℝ) + 1) ^ 2) := by
        apply (bandSeries_summable hh).tsum_le_tsum _ (summable_shift2.mul_left _)
        intro k
        refine (bandTerm_le_A hh k).trans ?_
        rw [mul_one_div]
        apply div_le_div_of_nonneg_left hA (by positivity)
        exact pow_le_pow_right₀ (by linarith [Nat.cast_nonneg (α := ℝ) k]) (by norm_num)
    _ = A h γ * ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 := tsum_mul_left
    _ = A h γ * (Real.pi ^ 2 / 6) := by rw [tsum_shift2]

/-- The band index of `γ` is at most `γ`. -/
theorem idx_le {γ : ℝ} (hγ : 11 / 10 ≤ γ) : (idx γ : ℝ) ≤ γ := by
  unfold idx
  have h0 : 0 ≤ (γ - 11 / 10) / (9 / 5) := by
    apply div_nonneg <;> linarith
  refine (Nat.floor_le h0).trans ?_
  rw [div_le_iff₀ (by norm_num)]
  linarith

/-- **Upper on-line background.** For `h > 0` and `γ ≥ 11/10`, the full
weighted sum over on-line zeros of height `≥ 11/10` is at most `A·π²/6`. -/
theorem tsum_upper_le_explicit {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ A h γ * (Real.pi ^ 2 / 6) := by
  refine (tsum_upper_le hh (M h γ) (M_nonneg h γ) ?_ (bandSeries_summable hh)).trans
    (bandSeries_le hh)
  intro ρ hre him
  exact term_le_M hh hγ ρ hre him

/-- **Upper on-line background, in `γ` and `h` alone:**
`≤ 88·(γ+3)⁴·(4h² + cFar/h²)·π²/6`. -/
theorem tsum_upper_le_explicit' {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) :
    ∑' ρ : Upper, weightedTerm h γ ρ.1
      ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) := by
  refine (tsum_upper_le_explicit hh hγ).trans ?_
  unfold A
  have hi := idx_le hγ
  have hK0 : (0 : ℝ) ≤ idx γ := Nat.cast_nonneg _
  have hp : ((idx γ : ℝ) + 3) ^ 4 ≤ (γ + 3) ^ 4 :=
    pow_le_pow_left₀ (by positivity) (by linarith) 4
  apply mul_le_mul_of_nonneg_right _ (by positivity)
  apply mul_le_mul_of_nonneg_right _ (four_h_add_nonneg h)
  exact mul_le_mul_of_nonneg_left hp (by norm_num)

end

/-- info: 'WeilSeries.term_le_M' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms term_le_M

/-- info: 'WeilSeries.bandSeries_summable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms bandSeries_summable

/-- info: 'WeilSeries.tsum_upper_le_explicit'' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms tsum_upper_le_explicit'

end WeilSeries
