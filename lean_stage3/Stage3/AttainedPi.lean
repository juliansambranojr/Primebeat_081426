/-
AttainedPi — block C7 of `lean_stage3/design/carlson.md`. 2026-11-23.

The one-ladder converse for the count of primes when the largest real part of
the zeros of ζ is attained. Let `ρ₀` have the largest real part `Θ` among the
zeros. If the count of primes at the doublings `2^r` stays within `C·r²·√2^r`
of `Li`, then the Riemann hypothesis holds. There may be infinitely many zeros
off the line.

The proof follows `FiniteOffLinePi.finite_off_line_pi`. When `Θ ≤ 1/2` there is
nothing to prove. Otherwise put `q = 2^Θ`, let `S` be the zeros on the line
`Re ρ = Θ`, and `A(r) = Σ'_{ρ∈S} m(ρ)/ρ·(2^ρ)^r`. The zeros of `S` above
height `2^r` carry a tail of the summable weights, so their part of `A(r)/q^r`
tends to zero (dominated convergence). The zeros of `S` below `2^r` are, by the
identity of `PiZeros.pi_eq_zero_sum` at `x = 2^r`, minus `log x` times the
other zeros' parts, plus `π − Li`, plus remainders. The zeros with real part
at most `Θ − η` are smaller by a fixed ratio per row (`zinv_le_log`); the zeros
with real part in `(Θ − η, Θ)` carry total weight below any `ε` once `η` is
small (`band_small`). So `A(r)/q^r → 0`, which `line_not_fading_summable`
forbids.

  norm_ipart_le_of_le      0 < b ≤ c ≤ 1, 4 ≤ x ⊢ ‖ipart ρ x‖ ≤ (3√x + 4x^c/(c·log²x))/|ρ|
  norm_log_ipart_le        log x·‖ipart ρ x‖ ≤ (3√x·log x + 8x^(max b ½)/log x)/|ρ|
  norm_log_piMode_le       log x·‖piMode ρ x‖ ≤ (x^b + 3√x·log x + 8x^(max b ½)/log x)/|ρ|
  norm_log_piMode_low      b ≤ θ₁, ½ ≤ θ₁ ⊢ log x·‖piMode ρ x‖ ≤ (9x^θ₁ + 3√x·log x)/|ρ|
  norm_log_piMode_band     ½ < b ≤ Θ, 8 ≤ log x ⊢ log x·‖piMode ρ x‖ ≤ (2x^Θ + 3√x·log x)/|ρ|
  topRow                   the zeros below height 2^r with real part Θ
  slack, slack_isLittleO   the row's bound less its band part, and it is o((2^Θ)^r)
  fin_bound                one row: ‖Σ_{topRow} m(ρ)/ρ·(2^ρ)^r‖ ≤ slack + 2ε·(2^Θ)^r
  band_small               the weights of the zeros in (Θ − η, Θ) are below ε for small η
  fin_eventually           for every ε > 0, eventually ‖Σ_{topRow}‖ ≤ ε·(2^Θ)^r
  lineSet, term, tailTerm  the line, the normalized term, the part above height 2^r
  norm_term, norm_tailTerm_le   the sizes of the terms on the line
  tsum_split               Σ'_{ρ∈S} term = Σ_{topRow}/q^r + Σ' tailTerm
  tendsto_tail             Σ' tailTerm → 0
  attained_off_line_pi     the largest real part attained, π − Li at the doublings
                             within C·r²·√2^r ⊢ RiemannHypothesis

What the next slice needs: the case where the real parts of the zeros approach
their supremum and do not reach it ("Not in this plan" in the design).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.FiniteOffLinePi
import Stage3.ZeroSummable
import Stage3.LadderMean

namespace AttainedPi

open Finset Filter Topology Kadiri FiniteOffLine PiZeros PiRemainder MeasureTheory
  FiniteOffLinePi

noncomputable section

/-- **The integral in one zero's part, against a larger exponent.** For a real
part `b > 0`, any `c` with `b ≤ c ≤ 1`, and `x ≥ 4`, the integral is at most
`(3√x + 4x^c/(c·log²x))/|ρ|`. -/
theorem norm_ipart_le_of_le {ρ : ℂ} (hb0 : 0 < ρ.re) {c : ℝ} (hbc : ρ.re ≤ c) (hc1 : c ≤ 1)
    {x : ℝ} (hx : 4 ≤ x) :
    ‖ipart ρ x‖ ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ c / (c * Real.log x ^ 2)) := by
  have hc0 : 0 < c := lt_of_lt_of_le hb0 hbc
  have hb1 : ρ.re ≤ 1 := hbc.trans hc1
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hx0 : 0 < x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have hL1 : 1 ≤ Real.log x := by
    have h4 : Real.log 4 = 2 * Real.log 2 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
      push_cast
      ring
    have := Real.log_le_log (by norm_num : (0:ℝ) < 4) hx
    linarith
  have hLpos : 0 < Real.log x := by linarith
  have hs2 : (2 : ℝ) ≤ Real.sqrt x := by
    have e : (2 : ℝ) = Real.sqrt 4 := by
      rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
    rw [e]
    exact Real.sqrt_le_sqrt hx
  have hspos : 0 < Real.sqrt x := by linarith
  have hss : Real.sqrt x * Real.sqrt x = x := Real.mul_self_sqrt hx0.le
  have hsx : Real.sqrt x ≤ x := by nlinarith
  have hlogs : Real.log (Real.sqrt x) = Real.log x / 2 := Real.log_sqrt hx0.le
  have hn0 : 0 ≤ ‖ρ‖⁻¹ := by positivity
  have hI := integrable_mul_wt hx2 (integrable_cpow hx2 ρ)
  have hmem : Real.sqrt x ∈ Set.uIcc (2 : ℝ) x := Set.mem_uIcc.mpr (Or.inl ⟨hs2, hsx⟩)
  have hI1 := hI.mono_set (Set.uIcc_subset_uIcc Set.left_mem_uIcc hmem)
  have hI2 := hI.mono_set (Set.uIcc_subset_uIcc hmem Set.right_mem_uIcc)
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hI1 hI2
  unfold ipart
  rw [← hsplit]
  -- the low piece
  have hlow : ‖∫ t in (2:ℝ)..Real.sqrt x, (t : ℂ) ^ ρ / ρ * wt t‖
      ≤ ‖ρ‖⁻¹ * (3 * Real.sqrt x) := by
    have hc := intervalIntegral.norm_integral_le_of_norm_le_const (a := 2) (b := Real.sqrt x)
      (C := ‖ρ‖⁻¹ * 3) (f := fun t => (t : ℂ) ^ ρ / ρ * wt t) (by
        intro t ht
        rw [Set.uIoc_of_le hs2] at ht
        have h2t : (2:ℝ) ≤ t := ht.1.le
        have ht0 : 0 < t := by linarith
        have hlt : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
        have hltpos : 0 < Real.log t := by linarith
        have hinv : (Real.log t ^ 2)⁻¹ ≤ 3 := by
          rw [inv_le_comm₀ (by positivity) (by norm_num)]
          nlinarith
        have htb : t ^ ρ.re ≤ t := by
          calc t ^ ρ.re ≤ t ^ (1:ℝ) := Real.rpow_le_rpow_of_exponent_le (by linarith) hb1
            _ = t := Real.rpow_one t
        rw [norm_integrand ρ h2t]
        apply mul_le_mul_of_nonneg_left _ hn0
        calc t ^ ρ.re * (t * Real.log t ^ 2)⁻¹ ≤ t * (t * Real.log t ^ 2)⁻¹ :=
              mul_le_mul_of_nonneg_right htb (by positivity)
          _ = (Real.log t ^ 2)⁻¹ := by
              rw [mul_inv, ← mul_assoc, mul_inv_cancel₀ ht0.ne', one_mul]
          _ ≤ 3 := hinv)
    have habs : |Real.sqrt x - 2| ≤ Real.sqrt x := by
      rw [abs_of_nonneg (by linarith)]
      linarith
    calc _ ≤ ‖ρ‖⁻¹ * 3 * |Real.sqrt x - 2| := hc
      _ ≤ ‖ρ‖⁻¹ * 3 * Real.sqrt x := mul_le_mul_of_nonneg_left habs (by positivity)
      _ = ‖ρ‖⁻¹ * (3 * Real.sqrt x) := by ring
  -- the high piece
  have hhigh : ‖∫ t in Real.sqrt x..x, (t : ℂ) ^ ρ / ρ * wt t‖
      ≤ ‖ρ‖⁻¹ * (4 * x ^ c / (c * Real.log x ^ 2)) := by
    have h0 : (0:ℝ) ∉ Set.uIcc (Real.sqrt x) x := by
      rw [Set.uIcc_of_le hsx]
      rintro ⟨h, _⟩
      linarith
    have hg : IntervalIntegrable
        (fun t : ℝ => (‖ρ‖⁻¹ * (4 / Real.log x ^ 2)) * t ^ (c - 1))
        volume (Real.sqrt x) x :=
      (intervalIntegral.intervalIntegrable_rpow (Or.inr h0)).const_mul _
    have hpt : ∀ᵐ t ∂volume, t ∈ Set.Ioc (Real.sqrt x) x →
        ‖(t : ℂ) ^ ρ / ρ * wt t‖ ≤ (‖ρ‖⁻¹ * (4 / Real.log x ^ 2)) * t ^ (c - 1) := by
      filter_upwards with t ht
      have hst : Real.sqrt x ≤ t := ht.1.le
      have ht0 : 0 < t := by linarith
      have h2t : (2:ℝ) ≤ t := by linarith
      have h1t : (1:ℝ) ≤ t := by linarith
      have hlt : Real.log x / 2 ≤ Real.log t := by
        rw [← hlogs]
        exact Real.log_le_log hspos hst
      have hinv : (Real.log t ^ 2)⁻¹ ≤ 4 / Real.log x ^ 2 := by
        have h1 : (Real.log x / 2) ^ 2 ≤ Real.log t ^ 2 :=
          pow_le_pow_left₀ (by linarith) hlt 2
        have h2 := inv_anti₀ (by positivity) h1
        calc (Real.log t ^ 2)⁻¹ ≤ ((Real.log x / 2) ^ 2)⁻¹ := h2
          _ = 4 / Real.log x ^ 2 := by rw [div_pow, inv_div]; norm_num
      have hbt : t ^ ρ.re ≤ t ^ c := Real.rpow_le_rpow_of_exponent_le h1t hbc
      have hrp : t ^ (c - 1) = t ^ c / t := Real.rpow_sub_one ht0.ne' _
      rw [norm_integrand ρ h2t, hrp]
      have e : t ^ ρ.re * (t * Real.log t ^ 2)⁻¹ = t ^ ρ.re / t * (Real.log t ^ 2)⁻¹ := by
        rw [mul_inv, div_eq_mul_inv]
        ring
      rw [e]
      have hq : 0 ≤ t ^ ρ.re / t := by positivity
      have hq2 : t ^ ρ.re / t ≤ t ^ c / t := div_le_div_of_nonneg_right hbt ht0.le
      calc ‖ρ‖⁻¹ * (t ^ ρ.re / t * (Real.log t ^ 2)⁻¹)
          ≤ ‖ρ‖⁻¹ * (t ^ c / t * (4 / Real.log x ^ 2)) :=
            mul_le_mul_of_nonneg_left (mul_le_mul hq2 hinv (by positivity) (by positivity))
              hn0
        _ = ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * (t ^ c / t) := by ring
    have hc := intervalIntegral.norm_integral_le_of_norm_le hsx hpt hg
    refine hc.trans ?_
    rw [intervalIntegral.integral_const_mul, integral_rpow (Or.inl (by linarith)),
      sub_add_cancel]
    have hsb : 0 ≤ Real.sqrt x ^ c := Real.rpow_nonneg hspos.le _
    have h1 : (x ^ c - Real.sqrt x ^ c) / c ≤ x ^ c / c :=
      div_le_div_of_nonneg_right (by linarith) hc0.le
    calc ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * ((x ^ c - Real.sqrt x ^ c) / c)
        ≤ ‖ρ‖⁻¹ * (4 / Real.log x ^ 2) * (x ^ c / c) :=
          mul_le_mul_of_nonneg_left h1 (by positivity)
      _ = ‖ρ‖⁻¹ * (4 * x ^ c / (c * Real.log x ^ 2)) := by ring
  have hn := norm_add_le (∫ t in (2:ℝ)..Real.sqrt x, (t : ℂ) ^ ρ / ρ * wt t)
    (∫ t in Real.sqrt x..x, (t : ℂ) ^ ρ / ρ * wt t)
  rw [mul_add]
  linarith

/-- `log x ≥ 1` for `x ≥ 4`. -/
theorem one_le_log {x : ℝ} (hx : 4 ≤ x) : 1 ≤ Real.log x := by
  have hl2 : (0.69 : ℝ) < Real.log 2 := by
    have := Real.log_two_gt_d9
    linarith
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4:ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    ring
  have := Real.log_le_log (by norm_num : (0:ℝ) < 4) hx
  linarith

/-- **`log x` times the integral in one zero's part.** For a real part `b` in
`(0, 1]` and `x ≥ 4`, with `c = max b (1/2)`, it is at most
`(3√x·log x + 8x^c/log x)/|ρ|`. -/
theorem norm_log_ipart_le {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {x : ℝ} (hx : 4 ≤ x) :
    Real.log x * ‖ipart ρ x‖ ≤ ‖ρ‖⁻¹ * (3 * (Real.sqrt x * Real.log x)
      + 8 * (x ^ max ρ.re (1 / 2) / Real.log x)) := by
  set c := max ρ.re (1 / 2) with hcdef
  have hc : ρ.re ≤ c := le_max_left _ _
  have hc1 : c ≤ 1 := max_le hb1 (by norm_num)
  have hc2 : 1 / 2 ≤ c := le_max_right _ _
  have hc0 : 0 < c := by linarith
  have hcne : c ≠ 0 := hc0.ne'
  have hL1 := one_le_log hx
  have hLpos : 0 < Real.log x := by linarith
  have hLne : Real.log x ≠ 0 := hLpos.ne'
  have h := norm_ipart_le_of_le hb0 hc hc1 hx
  have hn0 : 0 ≤ ‖ρ‖⁻¹ := by positivity
  have hxc : 0 ≤ x ^ c / Real.log x :=
    div_nonneg (Real.rpow_nonneg (by linarith) _) hLpos.le
  have e2 : Real.log x * (4 * x ^ c / (c * Real.log x ^ 2)) = 4 / c * (x ^ c / Real.log x) := by
    field_simp
    try ring
  have e : Real.log x * (‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ c / (c * Real.log x ^ 2)))
      = ‖ρ‖⁻¹ * (3 * (Real.sqrt x * Real.log x) + 4 / c * (x ^ c / Real.log x)) := by
    linear_combination ‖ρ‖⁻¹ * e2
  have h4 : 4 / c ≤ 8 := by
    rw [div_le_iff₀ hc0]
    linarith
  calc Real.log x * ‖ipart ρ x‖
      ≤ Real.log x * (‖ρ‖⁻¹ * (3 * Real.sqrt x + 4 * x ^ c / (c * Real.log x ^ 2))) :=
        mul_le_mul_of_nonneg_left h hLpos.le
    _ = _ := e
    _ ≤ _ := mul_le_mul_of_nonneg_left
        (add_le_add le_rfl (mul_le_mul_of_nonneg_right h4 hxc)) hn0

/-- **`log x` times one zero's part of the count.** For a real part `b` in
`(0, 1]` and `x ≥ 4`, with `c = max b (1/2)`, it is at most
`(x^b + 3√x·log x + 8x^c/log x)/|ρ|`. -/
theorem norm_log_piMode_le {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {x : ℝ} (hx : 4 ≤ x) :
    Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (x ^ ρ.re + 3 * (Real.sqrt x * Real.log x)
      + 8 * (x ^ max ρ.re (1 / 2) / Real.log x)) := by
  have hx0 : 0 < x := by linarith
  have hL1 := one_le_log hx
  have hLpos : 0 < Real.log x := by linarith
  have hLne : Real.log x ≠ 0 := hLpos.ne'
  have hmain : Real.log x * ‖(x : ℂ) ^ ρ / ρ / (Real.log x : ℂ)‖ = ‖ρ‖⁻¹ * x ^ ρ.re := by
    rw [norm_div, norm_div, Complex.norm_cpow_eq_rpow_re_of_pos hx0, Complex.norm_real,
      Real.norm_eq_abs, abs_of_pos hLpos]
    calc Real.log x * (x ^ ρ.re / ‖ρ‖ / Real.log x)
        = x ^ ρ.re / ‖ρ‖ * (Real.log x / Real.log x) := by ring
      _ = ‖ρ‖⁻¹ * x ^ ρ.re := by rw [div_self hLne, mul_one, div_eq_inv_mul]
  have hi := norm_log_ipart_le hb0 hb1 hx
  rw [piMode_eq]
  have hn := norm_add_le ((x : ℂ) ^ ρ / ρ / (Real.log x : ℂ)) (ipart ρ x)
  have h2 := mul_le_mul_of_nonneg_left hn hLpos.le
  rw [mul_add, hmain] at h2
  have e : ‖ρ‖⁻¹ * (x ^ ρ.re + 3 * (Real.sqrt x * Real.log x)
        + 8 * (x ^ max ρ.re (1 / 2) / Real.log x))
      = ‖ρ‖⁻¹ * x ^ ρ.re + ‖ρ‖⁻¹ * (3 * (Real.sqrt x * Real.log x)
        + 8 * (x ^ max ρ.re (1 / 2) / Real.log x)) := by ring
  rw [e]
  linarith

/-- **A zero at or left of `θ₁`.** For a real part `b` in `(0, θ₁]` with `θ₁ ≥ 1/2`
and `x ≥ 4`, `log x` times the zero's part is at most `(9x^θ₁ + 3√x·log x)/|ρ|`. -/
theorem norm_log_piMode_low {ρ : ℂ} (hb0 : 0 < ρ.re) (hb1 : ρ.re ≤ 1) {θ₁ : ℝ}
    (hθ : 1 / 2 ≤ θ₁) (hbθ : ρ.re ≤ θ₁) {x : ℝ} (hx : 4 ≤ x) :
    Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) := by
  have h := norm_log_piMode_le hb0 hb1 hx
  have hx1 : (1:ℝ) ≤ x := by linarith
  have hL1 := one_le_log hx
  have h1 : x ^ ρ.re ≤ x ^ θ₁ := Real.rpow_le_rpow_of_exponent_le hx1 hbθ
  have h2 : x ^ max ρ.re (1 / 2) ≤ x ^ θ₁ :=
    Real.rpow_le_rpow_of_exponent_le hx1 (max_le hbθ hθ)
  have h3 : x ^ max ρ.re (1 / 2) / Real.log x ≤ x ^ max ρ.re (1 / 2) :=
    div_le_self (Real.rpow_nonneg (by linarith) _) hL1
  refine h.trans (mul_le_mul_of_nonneg_left ?_ (by positivity))
  linarith

/-- **A zero in the band below the top line.** For a real part `b` in `(1/2, Θ]`,
`x ≥ 4` and `log x ≥ 8`, `log x` times the zero's part is at most
`(2x^Θ + 3√x·log x)/|ρ|`. -/
theorem norm_log_piMode_band {ρ : ℂ} (hb1 : ρ.re ≤ 1) {Θ : ℝ} (hb : 1 / 2 < ρ.re)
    (hbΘ : ρ.re ≤ Θ) {x : ℝ} (hx : 4 ≤ x) (hL8 : 8 ≤ Real.log x) :
    Real.log x * ‖piMode ρ x‖ ≤ ‖ρ‖⁻¹ * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) := by
  have h := norm_log_piMode_le (by linarith) hb1 hx
  rw [max_eq_left hb.le] at h
  have hx1 : (1:ℝ) ≤ x := by linarith
  have h1 : x ^ ρ.re ≤ x ^ Θ := Real.rpow_le_rpow_of_exponent_le hx1 hbΘ
  have hxΘ : 0 ≤ x ^ Θ := Real.rpow_nonneg (by linarith) _
  have hxb : 0 ≤ x ^ ρ.re := Real.rpow_nonneg (by linarith) _
  have h3 : x ^ ρ.re / Real.log x ≤ x ^ Θ / 8 := by
    rw [div_le_div_iff₀ (by linarith) (by norm_num)]
    nlinarith [mul_le_mul_of_nonneg_left hL8 hxΘ]
  refine h.trans (mul_le_mul_of_nonneg_left ?_ (by positivity))
  linarith

/-- The zeros below height `2^r` with real part `Θ`. -/
def topRow (Θ : ℝ) (r : ℕ) : Finset NontrivialZeros :=
  (ZF ((2:ℝ) ^ r)).filter fun ρ => (ρ : ℂ).re = Θ

/-- The part of the row's bound that is small against `(2^Θ)^r` for fixed parameters. -/
def slack (Θ θ₁ C M ε : ℝ) (r : ℕ) : ℝ :=
  (C * Real.log 2 + Arem + 8 + 3 * (Mlow * 39000) + 3 * ε + 3 * M)
      * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
    + 9 * (Mlow * 39000) * ((r : ℝ) ^ 2 * ((2:ℝ) ^ θ₁) ^ r)
    + 8 * M / Real.log 2 * ((r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r)

/-- **The slack is small against the top line.** If `θ₁ < Θ` and `Θ > 1/2`, the
slack is `o((2^Θ)^r)`. -/
theorem slack_isLittleO {Θ θ₁ : ℝ} (hΘ : 1 / 2 < Θ) (hθ : θ₁ < Θ) (C M ε : ℝ) :
    (fun r : ℕ => slack Θ θ₁ C M ε r) =o[atTop] fun r : ℕ => ((2:ℝ) ^ Θ) ^ r := by
  have hsq : Real.sqrt 2 < (2:ℝ) ^ Θ := by
    rw [Real.sqrt_eq_rpow]
    exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hΘ
  have h3 : (fun r : ℕ => (r : ℝ) ^ 3 * Real.sqrt 2 ^ r) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ Θ) ^ r :=
    isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 3
      (by rw [Real.norm_of_nonneg (Real.sqrt_nonneg 2)]; exact hsq)
  have h2 : (fun r : ℕ => (r : ℝ) ^ 2 * ((2:ℝ) ^ θ₁) ^ r) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ Θ) ^ r :=
    isLittleO_pow_const_mul_const_pow_const_pow_of_norm_lt 2
      (by
        rw [Real.norm_of_nonneg (by positivity)]
        exact Real.rpow_lt_rpow_of_exponent_lt (by norm_num) hθ)
  have hinv : (fun r : ℕ => (r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r) =o[atTop]
      fun r : ℕ => ((2:ℝ) ^ Θ) ^ r := by
    have h1 : (fun r : ℕ => (r : ℝ)⁻¹) =o[atTop] fun _ : ℕ => (1:ℝ) :=
      (Asymptotics.isLittleO_one_iff ℝ).mpr (tendsto_inv_atTop_nhds_zero_nat (𝕜 := ℝ))
    have h2 := h1.mul_isBigO (Asymptotics.isBigO_refl (fun r : ℕ => ((2:ℝ) ^ Θ) ^ r) atTop)
    exact h2.congr_right (fun r => one_mul _)
  unfold slack
  exact ((h3.const_mul_left _).add (h2.const_mul_left _)).add (hinv.const_mul_left _)

/-- **The zeros of the top line below one row.** Let every zero have real part at
most `Θ > 1/2`, let `M` bound the weights on the line, and `ε` the weights of every
finite set in the band `(θ₁, Θ)`, with `θ₁ ≥ 1/2`. If `r ≥ 12` and the count of primes
at `2^r` is within `C·r²·√2^r` of `Li`, the sum of `m(ρ)/ρ·(2^ρ)^r` over the zeros
of the line below `2^r` is at most `slack + 2ε·(2^Θ)^r`. -/
theorem fin_bound {Θ θ₁ C M ε : ℝ} (hΘ : 1 / 2 < Θ) (hθ₁ : 1 / 2 ≤ θ₁)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ Θ)
    (hM : ∀ v : Finset NontrivialZeros, (∀ ρ ∈ v, Θ ≤ (ρ : ℂ).re) →
      ∑ ρ ∈ v, ZeroSummable.w ρ ≤ M)
    (hband : ∀ F : Finset NontrivialZeros, (∀ ρ ∈ F, θ₁ < (ρ : ℂ).re ∧ (ρ : ℂ).re < Θ) →
      ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ ε)
    {r : ℕ} (hr : 12 ≤ r)
    (hrow : |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
      ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    ‖∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r‖
      ≤ slack Θ θ₁ C M ε r + 2 * ε * ((2:ℝ) ^ Θ) ^ r := by
  classical
  have hM0 : 0 ≤ M := by simpa using hM ∅ (by simp)
  have hε0 : 0 ≤ ε := by simpa using hband ∅ (by simp)
  have hx256 : (256:ℝ) ≤ (2:ℝ) ^ r := by
    calc (256:ℝ) = 2 ^ 8 := by norm_num
      _ ≤ 2 ^ r := pow_le_pow_right₀ (by norm_num) (by omega)
  obtain ⟨x, hxdef⟩ : ∃ x : ℝ, x = (2:ℝ) ^ r := ⟨_, rfl⟩
  have hmemT : ∀ ρ, ρ ∈ topRow Θ r ↔ ρ ∈ ZF x ∧ (ρ : ℂ).re = Θ := fun ρ => by
    rw [topRow, Finset.mem_filter, hxdef]
  have hTsub : topRow Θ r ⊆ ZF x := fun ρ hρ => ((hmemT ρ).mp hρ).1
  rw [← hxdef] at hx256 hrow
  have hx4 : (4:ℝ) ≤ x := by linarith
  have hx2 : (2:ℝ) ≤ x := by linarith
  have hx0 : 0 < x := by linarith
  have hl2 : (0.69 : ℝ) < Real.log 2 := by linarith [Real.log_two_gt_d9]
  have hl2' : Real.log 2 < 1 := by linarith [Real.log_two_lt_d9]
  have hr12 : (12 : ℝ) ≤ (r : ℝ) := by exact_mod_cast hr
  have hr1 : (1 : ℝ) ≤ (r : ℝ) := by linarith
  have hr0 : (0 : ℝ) < (r : ℝ) := by linarith
  have hL : Real.log x = (r : ℝ) * Real.log 2 := by rw [hxdef, Real.log_pow]
  have hsx : Real.sqrt x = Real.sqrt 2 ^ r := by rw [hxdef]; exact sqrt_doubling r
  have hxb : ∀ b : ℝ, x ^ b = ((2:ℝ) ^ b) ^ r := fun b => by
    rw [hxdef]; exact rpow_doubling r b
  have hxc : ∀ ρ : ℂ, (x : ℂ) ^ ρ = ((2:ℂ) ^ ρ) ^ r := fun ρ => by
    rw [hxdef]; exact cpow_doubling r ρ
  have hL0 : 0 ≤ Real.log x := by rw [hL]; positivity
  have hLr : Real.log x ≤ (r : ℝ) := by rw [hL]; nlinarith
  have hL8 : 8 ≤ Real.log x := by rw [hL]; nlinarith
  have hLne : (Real.log x : ℂ) ≠ 0 := by
    have : Real.log x ≠ 0 := by rw [hL]; positivity
    exact_mod_cast this
  have hs0 : 0 ≤ Real.sqrt 2 ^ r := by positivity
  have hr3 : (r : ℝ) ≤ (r : ℝ) ^ 3 := by nlinarith
  have hL2r : Real.log x ^ 2 ≤ (r : ℝ) ^ 2 := pow_le_pow_left₀ hL0 hLr 2
  have hL3 : Real.log x ^ 3 ≤ (r : ℝ) ^ 3 := pow_le_pow_left₀ hL0 hLr 3
  have hLr3 : Real.log x ≤ (r : ℝ) ^ 3 := hLr.trans hr3
  have hM2 := two_le_Mlow
  have hq0 : 0 ≤ ((2:ℝ) ^ Θ) ^ r := by positivity
  have hq1 : 0 ≤ ((2:ℝ) ^ θ₁) ^ r := by positivity
  -- the count as a sum over the zeros, split four ways
  have hid := pi_eq_zero_sum hx2 x
  have hsplit : ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      + ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
        ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      + ∑ ρ ∈ topRow Θ r, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ ZF x, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x := by
    rw [Finset.sum_filter_add_sum_filter_not, Finset.sum_sdiff hTsub]
  have hSid : (Real.log x : ℂ)
        * ∑ ρ ∈ topRow Θ r, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
      = ∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r
        + (Real.log x : ℂ)
          * ∑ ρ ∈ topRow Θ r, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x := by
    rw [Finset.mul_sum, Finset.mul_sum, ← Finset.sum_add_distrib]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [piMode_eq, hxc, LadderMean.coef]
    have hρ0 : (ρ : ℂ) ≠ 0 := by
      intro h
      have := ρ.2.1.1
      rw [h, Complex.zero_re] at this
      exact lt_irrefl _ this
    have e : (Real.log x : ℂ) * (((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ) / (Real.log x : ℂ))
        = ((2:ℂ) ^ (ρ : ℂ)) ^ r / (ρ : ℂ) := by
      field_simp
    linear_combination ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * e
  set Z := ∑ ρ ∈ ZF x, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x with hZd
  set ZLo := ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x with hZLod
  set ZBd := ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
    ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x with hZBdd
  set ZT := ∑ ρ ∈ topRow Θ r, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x
    with hZTd
  set ZI := ∑ ρ ∈ topRow Θ r, ((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x
    with hZId
  set a := ∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r with had
  have key : a = (Real.log x : ℂ) * Z - (Real.log x : ℂ) * ZLo - (Real.log x : ℂ) * ZBd
      - (Real.log x : ℂ) * ZI := by
    linear_combination (Real.log x : ℂ) * hsplit - hSid
  -- the whole sum
  have hZ : ‖Z‖ ≤ |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
      + Arem * Real.sqrt x * Real.log x ^ 2 + 8 * Real.sqrt x := by
    have e : Z = -(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
        + tr (efRem x) x - tr psiTheta x := by
      linear_combination hid
    rw [e]
    have h1 := norm_tr_efRem_le_of hx256
    have h2 := norm_tr_psiTheta_le hx2
    have h3 := norm_sub_le (-(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ)
      + tr (efRem x) x) (tr psiTheta x)
    have h4 := norm_add_le (-(((Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x : ℝ) : ℂ))
      (tr (efRem x) x)
    rw [norm_neg, Complex.norm_real, Real.norm_eq_abs] at h4
    linarith
  have hZb : Real.log x * ‖Z‖
      ≤ (C * Real.log 2 + Arem + 8) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
    have t0 := mul_le_mul_of_nonneg_left hZ hL0
    have t1 : Real.log x * |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
        ≤ C * Real.log 2 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ ≤ Real.log x * (C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :=
            mul_le_mul_of_nonneg_left hrow hL0
        _ = _ := by rw [hL]; ring
    have t2 : Real.log x * (Arem * Real.sqrt x * Real.log x ^ 2)
        ≤ Arem * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ = Arem * (Real.log x ^ 3 * Real.sqrt 2 ^ r) := by rw [hsx]; ring
        _ ≤ _ := mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hL3 hs0) Arem_nonneg
    have t3 : Real.log x * (8 * Real.sqrt x) ≤ 8 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      calc _ = 8 * (Real.log x * Real.sqrt 2 ^ r) := by rw [hsx]; ring
        _ ≤ _ := mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hLr3 hs0) (by norm_num)
    have e : Real.log x * (|(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
          + Arem * Real.sqrt x * Real.log x ^ 2 + 8 * Real.sqrt x)
        = Real.log x * |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Stage3.Li x|
          + Real.log x * (Arem * Real.sqrt x * Real.log x ^ 2)
          + Real.log x * (8 * Real.sqrt x) := by ring
    have e2 : (C * Real.log 2 + Arem + 8) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
        = C * Real.log 2 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
          + Arem * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) + 8 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r) := by
      ring
    rw [e] at t0
    rw [e2]
    linarith
  -- the zeros at or left of θ₁
  have hlo : Real.log x * ‖ZLo‖ ≤ Mlow * 39000
      * (9 * ((r : ℝ) ^ 2 * ((2:ℝ) ^ θ₁) ^ r) + 3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)) := by
    have hK : 0 ≤ 9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x) := by
      have := Real.rpow_nonneg hx0.le θ₁
      positivity
    have hterm : ∀ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
        Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖
          ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) := by
      intro ρ hρ
      have hre : (ρ : ℂ).re ≤ θ₁ := (Finset.mem_filter.mp hρ).2
      rw [norm_order_mul]
      have h := norm_log_piMode_low ρ.2.1.1 ρ.2.1.2.le hθ₁ hre hx4
      calc Real.log x * (ordR ρ * ‖piMode (ρ : ℂ) x‖)
          = ordR ρ * (Real.log x * ‖piMode (ρ : ℂ) x‖) := by ring
        _ ≤ ordR ρ * (‖(ρ : ℂ)‖⁻¹ * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x))) :=
            mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)
        _ = _ := by ring
    have hsub : ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
        ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ zinv x :=
      Finset.sum_le_sum_of_subset_of_nonneg
        ((Finset.filter_subset _ _).trans Finset.sdiff_subset)
        (fun ρ _ _ => mul_nonneg (ordR_nonneg ρ) (by positivity))
    have hW := zinv_le_log hx4
    calc Real.log x * ‖ZLo‖
        ≤ Real.log x
          * ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
            ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ :=
          mul_le_mul_of_nonneg_left (norm_sum_le _ _) hL0
      _ = ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
            Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ := by
          rw [Finset.mul_sum]
      _ ≤ ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) :=
          Finset.sum_le_sum hterm
      _ = (∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => (ρ : ℂ).re ≤ θ₁),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) := by
          rw [Finset.sum_mul]
      _ ≤ zinv x * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) :=
          mul_le_mul_of_nonneg_right hsub hK
      _ ≤ (Mlow * 39000 * Real.log x ^ 2) * (9 * x ^ θ₁ + 3 * (Real.sqrt x * Real.log x)) :=
          mul_le_mul_of_nonneg_right hW hK
      _ = Mlow * 39000 * (9 * (Real.log x ^ 2 * ((2:ℝ) ^ θ₁) ^ r)
            + 3 * (Real.log x ^ 3 * Real.sqrt 2 ^ r)) := by rw [hxb, hsx]; ring
      _ ≤ _ := mul_le_mul_of_nonneg_left
          (add_le_add
            (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hL2r hq1) (by norm_num))
            (mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_right hL3 hs0) (by norm_num)))
          (by linarith)
  -- the zeros in the band (θ₁, Θ)
  have hbd : Real.log x * ‖ZBd‖
      ≤ ε * (2 * ((2:ℝ) ^ Θ) ^ r + 3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)) := by
    have hK : 0 ≤ 2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x) := by
      have := Real.rpow_nonneg hx0.le Θ
      positivity
    have hmemB : ∀ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
        θ₁ < (ρ : ℂ).re ∧ (ρ : ℂ).re < Θ := by
      intro ρ hρ
      obtain ⟨hρD, hre⟩ := Finset.mem_filter.mp hρ
      obtain ⟨hρZ, hρT⟩ := Finset.mem_sdiff.mp hρD
      refine ⟨lt_of_not_ge hre, lt_of_le_of_ne (hmax ρ) fun h => hρT ?_⟩
      exact (hmemT ρ).mpr ⟨hρZ, h⟩
    have hterm : ∀ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
        Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖
          ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) := by
      intro ρ hρ
      have hb : 1 / 2 < (ρ : ℂ).re := by linarith [(hmemB ρ hρ).1]
      rw [norm_order_mul]
      have h := norm_log_piMode_band ρ.2.1.2.le hb (hmax ρ) hx4 hL8
      calc Real.log x * (ordR ρ * ‖piMode (ρ : ℂ) x‖)
          = ordR ρ * (Real.log x * ‖piMode (ρ : ℂ) x‖) := by ring
        _ ≤ ordR ρ * (‖(ρ : ℂ)‖⁻¹ * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x))) :=
            mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)
        _ = _ := by ring
    have hsub := hband _ hmemB
    calc Real.log x * ‖ZBd‖
        ≤ Real.log x
          * ∑ ρ ∈ (ZF x \ topRow Θ r).filter
            (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
            ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ :=
          mul_le_mul_of_nonneg_left (norm_sum_le _ _) hL0
      _ = ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
            Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * piMode (ρ : ℂ) x‖ := by
          rw [Finset.mul_sum]
      _ ≤ ∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹ * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) :=
          Finset.sum_le_sum hterm
      _ = (∑ ρ ∈ (ZF x \ topRow Θ r).filter (fun ρ : NontrivialZeros => ¬ (ρ : ℂ).re ≤ θ₁),
            ordR ρ * ‖(ρ : ℂ)‖⁻¹) * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) := by
          rw [Finset.sum_mul]
      _ ≤ ε * (2 * x ^ Θ + 3 * (Real.sqrt x * Real.log x)) :=
          mul_le_mul_of_nonneg_right hsub hK
      _ = ε * (2 * ((2:ℝ) ^ Θ) ^ r + 3 * (Real.sqrt 2 ^ r * Real.log x)) := by
          rw [hxb, hsx]
      _ ≤ _ := mul_le_mul_of_nonneg_left
          (add_le_add le_rfl (mul_le_mul_of_nonneg_left
            (by
              rw [mul_comm (Real.sqrt 2 ^ r)]
              exact mul_le_mul_of_nonneg_right hLr3 hs0) (by norm_num)))
          hε0
  -- the integrals of the top line
  have hSI : Real.log x * ‖ZI‖ ≤ M * (3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
      + 8 / Real.log 2 * ((r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r)) := by
    have hK : 0 ≤ 3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x) := by
      have := Real.rpow_nonneg hx0.le Θ
      positivity
    have hterm : ∀ ρ ∈ topRow Θ r,
        Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x‖
          ≤ ordR ρ * ‖(ρ : ℂ)‖⁻¹
            * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x)) := by
      intro ρ hρ
      have hre : (ρ : ℂ).re = Θ := ((hmemT ρ).mp hρ).2
      rw [norm_order_mul]
      have h := norm_log_ipart_le ρ.2.1.1 ρ.2.1.2.le hx4
      rw [hre, max_eq_left hΘ.le] at h
      calc Real.log x * (ordR ρ * ‖ipart (ρ : ℂ) x‖)
          = ordR ρ * (Real.log x * ‖ipart (ρ : ℂ) x‖) := by ring
        _ ≤ ordR ρ * (‖(ρ : ℂ)‖⁻¹
            * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x))) :=
            mul_le_mul_of_nonneg_left h (ordR_nonneg ρ)
        _ = _ := by ring
    have hTw : ∑ ρ ∈ topRow Θ r, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ M := by
      have h := hM (topRow Θ r) (fun ρ hρ => ((hmemT ρ).mp hρ).2.ge)
      calc _ = ∑ ρ ∈ topRow Θ r, ZeroSummable.w ρ := Finset.sum_congr rfl fun ρ _ => by
            unfold ZeroSummable.w ordR
            rw [div_eq_mul_inv]
        _ ≤ M := h
    have hlog2 : Real.log 2 ≠ 0 := by positivity
    have e3 : 8 * (x ^ Θ / Real.log x)
        = 8 / Real.log 2 * ((r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r) := by
      rw [hxb, hL]
      field_simp
    calc Real.log x * ‖ZI‖
        ≤ Real.log x * ∑ ρ ∈ topRow Θ r,
            ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x‖ :=
          mul_le_mul_of_nonneg_left (norm_sum_le _ _) hL0
      _ = ∑ ρ ∈ topRow Θ r,
            Real.log x * ‖((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ) * ipart (ρ : ℂ) x‖ := by
          rw [Finset.mul_sum]
      _ ≤ ∑ ρ ∈ topRow Θ r, ordR ρ * ‖(ρ : ℂ)‖⁻¹
            * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x)) :=
          Finset.sum_le_sum hterm
      _ = (∑ ρ ∈ topRow Θ r, ordR ρ * ‖(ρ : ℂ)‖⁻¹)
            * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x)) := by
          rw [Finset.sum_mul]
      _ ≤ M * (3 * (Real.sqrt x * Real.log x) + 8 * (x ^ Θ / Real.log x)) :=
          mul_le_mul_of_nonneg_right hTw hK
      _ = M * (3 * (Real.sqrt 2 ^ r * Real.log x)
            + 8 / Real.log 2 * ((r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r)) := by
          rw [e3, hsx]
      _ ≤ _ := mul_le_mul_of_nonneg_left
          (add_le_add (mul_le_mul_of_nonneg_left
            (by
              rw [mul_comm (Real.sqrt 2 ^ r)]
              exact mul_le_mul_of_nonneg_right hLr3 hs0) (by norm_num)) le_rfl)
          hM0
  -- adding up
  have hnL : ∀ w : ℂ, ‖(Real.log x : ℂ) * w‖ = Real.log x * ‖w‖ := fun w => by
    rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg hL0]
  rw [key]
  have n1 := norm_sub_le ((Real.log x : ℂ) * Z - (Real.log x : ℂ) * ZLo
    - (Real.log x : ℂ) * ZBd) ((Real.log x : ℂ) * ZI)
  have n2 := norm_sub_le ((Real.log x : ℂ) * Z - (Real.log x : ℂ) * ZLo)
    ((Real.log x : ℂ) * ZBd)
  have n3 := norm_sub_le ((Real.log x : ℂ) * Z) ((Real.log x : ℂ) * ZLo)
  simp only [hnL] at n1 n2 n3
  have etot : slack Θ θ₁ C M ε r + 2 * ε * ((2:ℝ) ^ Θ) ^ r
      = (C * Real.log 2 + Arem + 8) * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
        + Mlow * 39000 * (9 * ((r : ℝ) ^ 2 * ((2:ℝ) ^ θ₁) ^ r)
          + 3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r))
        + ε * (2 * ((2:ℝ) ^ Θ) ^ r + 3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r))
        + M * (3 * ((r : ℝ) ^ 3 * Real.sqrt 2 ^ r)
          + 8 / Real.log 2 * ((r : ℝ)⁻¹ * ((2:ℝ) ^ Θ) ^ r)) := by
    unfold slack
    ring
  rw [etot]
  linarith

/-- **The band below the top line carries little weight.** For `Θ > 1/2` and
`ε > 0` there is `η ∈ (0, (Θ − 1/2)/2]` such that every finite set of zeros with
real parts in `(Θ − η, Θ)` has `Σ m(ρ)/|ρ| ≤ ε`. -/
theorem band_small {Θ : ℝ} (hΘ : 1 / 2 < Θ) {ε : ℝ} (hε : 0 < ε) :
    ∃ η : ℝ, 0 < η ∧ η ≤ (Θ - 1 / 2) / 2 ∧ ∀ F : Finset NontrivialZeros,
      (∀ ρ ∈ F, Θ - η < (ρ : ℂ).re ∧ (ρ : ℂ).re < Θ) →
        ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹ ≤ ε := by
  classical
  have hσ : 1 / 2 < (1 / 2 + Θ) / 2 := by linarith
  have hs := ZeroSummable.summable_order_div hσ
  have hs' : Summable fun ρ : ({ρ : NontrivialZeros | (1 / 2 + Θ) / 2 ≤ (ρ : ℂ).re} :
      Set NontrivialZeros) => ordR (ρ : NontrivialZeros) * ‖((ρ : NontrivialZeros) : ℂ)‖⁻¹ := by
    simp only [div_eq_mul_inv] at hs
    exact hs
  have hg := (summable_subtype_iff_indicator
    (f := fun ρ : NontrivialZeros => ordR ρ * ‖(ρ : ℂ)‖⁻¹)
    (s := {ρ : NontrivialZeros | (1 / 2 + Θ) / 2 ≤ (ρ : ℂ).re})).mp hs'
  obtain ⟨F₀, hF₀⟩ := hg.vanishing (Iio_mem_nhds hε)
  set D : Finset ℝ := insert ((Θ - 1 / 2) / 2)
    ((F₀.filter fun ρ : NontrivialZeros => (ρ : ℂ).re < Θ).image
      fun ρ : NontrivialZeros => Θ - (ρ : ℂ).re) with hD
  have hDne : D.Nonempty := Finset.insert_nonempty _ _
  have hpos : ∀ d ∈ D, 0 < d := by
    intro d hd
    rw [hD] at hd
    rcases Finset.mem_insert.mp hd with h | h
    · rw [h]
      linarith
    · obtain ⟨ρ, hρ, rfl⟩ := Finset.mem_image.mp h
      have := (Finset.mem_filter.mp hρ).2
      linarith
  have hηle : D.min' hDne ≤ (Θ - 1 / 2) / 2 :=
    Finset.min'_le D _ (by rw [hD]; exact Finset.mem_insert_self _ _)
  have hle : ∀ ρ ∈ F₀, (ρ : ℂ).re < Θ → D.min' hDne ≤ Θ - (ρ : ℂ).re := by
    intro ρ hρ hlt
    refine Finset.min'_le D _ ?_
    rw [hD]
    exact Finset.mem_insert_of_mem
      (Finset.mem_image_of_mem _ (Finset.mem_filter.mpr ⟨hρ, hlt⟩))
  refine ⟨D.min' hDne, hpos _ (Finset.min'_mem D hDne), hηle, fun F hF => ?_⟩
  have hdisj : Disjoint F F₀ := Finset.disjoint_left.mpr fun ρ hρF hρ₀ => by
    have h1 := hF ρ hρF
    have h2 := hle ρ hρ₀ h1.2
    linarith [h1.1]
  have hlt := hF₀ F hdisj
  have heq : ∑ ρ ∈ F, ordR ρ * ‖(ρ : ℂ)‖⁻¹
      = ∑ ρ ∈ F, ({ρ : NontrivialZeros | (1 / 2 + Θ) / 2 ≤ (ρ : ℂ).re} :
          Set NontrivialZeros).indicator (fun ρ => ordR ρ * ‖(ρ : ℂ)‖⁻¹) ρ := by
    refine Finset.sum_congr rfl fun ρ hρ => ?_
    have h1 := (hF ρ hρ).1
    have hmem : (1 / 2 + Θ) / 2 ≤ (ρ : ℂ).re := by linarith
    rw [Set.indicator_of_mem (show ρ ∈ ({ρ : NontrivialZeros | (1 / 2 + Θ) / 2 ≤ (ρ : ℂ).re} :
      Set NontrivialZeros) from hmem)]
  rw [heq]
  exact (Set.mem_Iio.mp hlt).le

/-- **The top line below the rows is eventually small.** Let `Θ ∈ (1/2, 1]` bound the
real parts of all zeros, and let the count of primes at the doublings stay within
`C·r²·√2^r` of `Li`. Then for every `ε > 0`, from some row on, the sum of
`m(ρ)/ρ·(2^ρ)^r` over the zeros of the line `Re = Θ` below `2^r` is at most `ε·(2^Θ)^r`. -/
theorem fin_eventually {Θ C : ℝ} (hΘ : 1 / 2 < Θ) (hΘ1 : Θ ≤ 1)
    (hmax : ∀ ρ : NontrivialZeros, (ρ : ℂ).re ≤ Θ)
    (hrows : ∀ᶠ r : ℕ in atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) {ε : ℝ} (hε : 0 < ε) :
    ∀ᶠ r : ℕ in atTop, ‖∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r‖
      ≤ ε * ((2:ℝ) ^ Θ) ^ r := by
  obtain ⟨M, hM⟩ := ZeroSummable.sum_le_const hΘ hΘ1
  obtain ⟨η, hη0, hηle, hband⟩ := band_small hΘ (ε := ε / 4) (by positivity)
  have hθ₁ : 1 / 2 ≤ Θ - η := by linarith
  have hθΘ : Θ - η < Θ := by linarith
  have hG := slack_isLittleO hΘ hθΘ C M (ε / 4)
  have hGb := hG.bound (c := ε / 2) (by positivity)
  filter_upwards [hrows, eventually_ge_atTop 12, hGb] with r hrow hr hg
  have h := fin_bound hΘ hθ₁ hmax hM hband hr hrow
  have hq : 0 ≤ ((2:ℝ) ^ Θ) ^ r := by positivity
  rw [Real.norm_of_nonneg hq] at hg
  have h1 := le_abs_self (slack Θ (Θ - η) C M (ε / 4) r)
  rw [← Real.norm_eq_abs] at h1
  linarith

/-- The zeros on the line `Re = Θ`. -/
def lineSet (Θ : ℝ) : Set NontrivialZeros := {ρ | (ρ : ℂ).re = Θ}

/-- A zero is on the line exactly when its real part is `Θ`. -/
theorem mem_lineSet {Θ : ℝ} {ρ : NontrivialZeros} : ρ ∈ lineSet Θ ↔ (ρ : ℂ).re = Θ :=
  Iff.rfl

/-- One zero's term at row `r`, measured against `(2^Θ)^r`. -/
def term (Θ : ℝ) (r : ℕ) (ρ : NontrivialZeros) : ℂ :=
  LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r / ((((2:ℝ) ^ Θ : ℝ)) : ℂ) ^ r

/-- One zero's term on the line, kept only above height `2^r`. -/
def tailTerm (Θ : ℝ) (r : ℕ) (ρ : NontrivialZeros) : ℂ :=
  if ρ ∈ ZF ((2:ℝ) ^ r) then 0 else (lineSet Θ).indicator (term Θ r) ρ

/-- A zero on the line has a term of size `m(ρ)/|ρ|` at every row. -/
theorem norm_term {Θ : ℝ} (r : ℕ) {ρ : NontrivialZeros} (hρ : ρ ∈ lineSet Θ) :
    ‖term Θ r ρ‖ = ‖LadderMean.coef ρ‖ := by
  have hqpos : 0 < (2:ℝ) ^ Θ := Real.rpow_pos_of_pos (by norm_num) Θ
  have hz : ‖(2:ℂ) ^ (ρ : ℂ)‖ = (2:ℝ) ^ Θ := by
    have h2 : (2:ℂ) = ((2:ℝ) : ℂ) := by norm_num
    rw [h2, Complex.norm_cpow_eq_rpow_re_of_pos (by norm_num), mem_lineSet.mp hρ]
  unfold term
  rw [norm_div, norm_mul, norm_pow, norm_pow, hz, Complex.norm_real,
    Real.norm_of_nonneg hqpos.le, mul_div_assoc, div_self (pow_ne_zero _ hqpos.ne'), mul_one]

/-- The part above height `2^r` of a zero's term is at most its weight on the line. -/
theorem norm_tailTerm_le (Θ : ℝ) (r : ℕ) (ρ : NontrivialZeros) :
    ‖tailTerm Θ r ρ‖ ≤ (lineSet Θ).indicator (fun ρ => ‖LadderMean.coef ρ‖) ρ := by
  unfold tailTerm
  split_ifs with h
  · rw [norm_zero]
    exact Set.indicator_nonneg (fun _ _ => norm_nonneg _) _
  · rw [norm_indicator_eq_indicator_norm]
    by_cases hρ : ρ ∈ lineSet Θ
    · rw [Set.indicator_of_mem hρ, Set.indicator_of_mem hρ, norm_term r hρ]
    · rw [Set.indicator_of_notMem hρ, Set.indicator_of_notMem hρ]

/-- For `Θ > 1/2` the weights on the line, as a function on all zeros, are summable. -/
theorem summable_line {Θ : ℝ} (hΘ : 1 / 2 < Θ) :
    Summable ((lineSet Θ).indicator fun ρ => ‖LadderMean.coef ρ‖) :=
  summable_subtype_iff_indicator.mp
    (ZeroSummable.summable_norm_coef (lineSet Θ) hΘ fun _ h => (mem_lineSet.mp h).ge)

/-- **The line's sum splits at height `2^r`.** For `Θ > 1/2`, the sum over the line of
the terms at row `r` is the sum over the zeros of the line below `2^r`, over `(2^Θ)^r`,
plus the sum of the parts above `2^r`. -/
theorem tsum_split {Θ : ℝ} (hΘ : 1 / 2 < Θ) (r : ℕ) :
    ∑' ρ : lineSet Θ, term Θ r ρ
      = (∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r)
          / ((((2:ℝ) ^ Θ : ℝ)) : ℂ) ^ r
        + ∑' ρ, tailTerm Θ r ρ := by
  classical
  have hb : Summable (tailTerm Θ r) :=
    Summable.of_norm_bounded (summable_line hΘ) (norm_tailTerm_le Θ r)
  have ha : Summable fun ρ =>
      if ρ ∈ ZF ((2:ℝ) ^ r) then (lineSet Θ).indicator (term Θ r) ρ else 0 :=
    summable_of_ne_finset_zero (s := ZF ((2:ℝ) ^ r)) fun ρ hρ => if_neg hρ
  have e1 : ∑' ρ, (lineSet Θ).indicator (term Θ r) ρ
      = ∑' ρ, ((if ρ ∈ ZF ((2:ℝ) ^ r) then (lineSet Θ).indicator (term Θ r) ρ else 0)
        + tailTerm Θ r ρ) := by
    refine tsum_congr fun ρ => ?_
    unfold tailTerm
    split_ifs <;> simp
  have hfin : ∑ ρ ∈ ZF ((2:ℝ) ^ r),
      (if ρ ∈ ZF ((2:ℝ) ^ r) then (lineSet Θ).indicator (term Θ r) ρ else 0)
      = (∑ ρ ∈ topRow Θ r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r)
          / ((((2:ℝ) ^ Θ : ℝ)) : ℂ) ^ r := by
    rw [topRow, Finset.sum_filter, Finset.sum_div]
    refine Finset.sum_congr rfl fun ρ hρ => ?_
    rw [if_pos hρ]
    by_cases h : (ρ : ℂ).re = Θ
    · rw [Set.indicator_of_mem (mem_lineSet.mpr h), if_pos h]
      rfl
    · rw [Set.indicator_of_notMem (fun h' => h (mem_lineSet.mp h')), if_neg h, zero_div]
  rw [tsum_subtype (lineSet Θ) (term Θ r), e1, ha.tsum_add hb,
    tsum_eq_sum (s := ZF ((2:ℝ) ^ r)) (fun ρ hρ => if_neg hρ), hfin]

/-- **The parts above height `2^r` fade.** For `Θ > 1/2`, the sum over the line of the
terms of the zeros above `2^r` tends to zero as the rows go on. -/
theorem tendsto_tail {Θ : ℝ} (hΘ : 1 / 2 < Θ) :
    Tendsto (fun r : ℕ => ∑' ρ, tailTerm Θ r ρ) atTop (𝓝 0) := by
  have h := tendsto_tsum_of_dominated_convergence (𝓕 := atTop)
    (f := fun r ρ => tailTerm Θ r ρ)
    (g := fun _ => (0:ℂ)) (summable_line hΘ) (fun ρ => ?_)
    (Eventually.of_forall fun r ρ => norm_tailTerm_le Θ r ρ)
  · rw [tsum_zero] at h
    exact h
  have hev : ∀ᶠ r : ℕ in atTop, ρ ∈ ZF ((2:ℝ) ^ r) := by
    have := (tendsto_pow_atTop_atTop_of_one_lt (by norm_num : (1:ℝ) < 2)).eventually_gt_atTop
      |(ρ : ℂ).im|
    filter_upwards [this] with r hr
    rw [mem_ZF]
    exact hr
  refine tendsto_const_nhds.congr' ?_
  filter_upwards [hev] with r hr
  unfold tailTerm
  rw [if_pos hr]

/-- **The largest real part attained, and the count of primes of square-root size at
the doublings: then the Riemann hypothesis holds.** Let `ρ₀` have the largest real part
among the zeros of ζ. If the count of primes at `2^r` stays within `C·r²·√2^r` of `Li`
from some row on, the Riemann hypothesis holds. -/
theorem attained_off_line_pi (ρ₀ : Kadiri.NontrivialZeros)
    (hmax : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re ≤ (ρ₀ : ℂ).re) (C : ℝ)
    (hrows : ∀ᶠ r : ℕ in Filter.atTop,
      |(Nat.primeCounting ⌊(2:ℝ) ^ r⌋₊ : ℝ) - Stage3.Li ((2:ℝ) ^ r)|
        ≤ C * (r : ℝ) ^ 2 * Real.sqrt 2 ^ r) :
    RiemannHypothesis := by
  classical
  by_cases hhalf : (ρ₀ : ℂ).re ≤ 1 / 2
  · apply LandauWindow.rh_of_zeroFree_half
    intro s hs hz
    have hs1 : s.re < 1 := by
      by_contra h
      exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp h) hz
    let ρ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
    have h : s.re ≤ (ρ₀ : ℂ).re := hmax ρ
    linarith
  have hΘ : 1 / 2 < (ρ₀ : ℂ).re := lt_of_not_ge hhalf
  have hΘ1 : (ρ₀ : ℂ).re ≤ 1 := ρ₀.2.1.2.le
  have hβ : ∀ ρ ∈ lineSet (ρ₀ : ℂ).re, (ρ : ℂ).re = (ρ₀ : ℂ).re := fun ρ h => mem_lineSet.mp h
  have hρ₀ : ρ₀ ∈ lineSet (ρ₀ : ℂ).re := mem_lineSet.mpr rfl
  have hsum : Summable fun ρ : lineSet (ρ₀ : ℂ).re => ‖LadderMean.coef ρ‖ :=
    ZeroSummable.summable_norm_coef _ hΘ fun ρ h => (mem_lineSet.mp h).ge
  have hqpos : 0 < (2:ℝ) ^ (ρ₀ : ℂ).re := Real.rpow_pos_of_pos (by norm_num) _
  -- the zeros of the line below the rows fade against the line
  have hfin : Tendsto (fun r : ℕ =>
      (∑ ρ ∈ topRow (ρ₀ : ℂ).re r, LadderMean.coef ρ * ((2:ℂ) ^ (ρ : ℂ)) ^ r)
        / ((((2:ℝ) ^ (ρ₀ : ℂ).re : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
    rw [Metric.tendsto_nhds]
    intro ε hε
    filter_upwards [fin_eventually hΘ hΘ1 hmax hrows (half_pos hε)] with r hr
    rw [dist_zero_right, norm_div, norm_pow, Complex.norm_real,
      Real.norm_of_nonneg hqpos.le, div_lt_iff₀ (pow_pos hqpos r)]
    have := mul_pos hε (pow_pos hqpos r)
    linarith
  have hlim : Tendsto (fun r : ℕ =>
      (∑' ρ : lineSet (ρ₀ : ℂ).re, LadderMean.coef ρ
          * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ 0
          * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r : ℤ)) : ℂ))
        / ((((2 : ℝ) ^ (ρ₀ : ℂ).re : ℝ)) : ℂ) ^ r) atTop (𝓝 0) := by
    have h := hfin.add (tendsto_tail hΘ)
    rw [add_zero] at h
    refine h.congr fun r => ?_
    rw [← tsum_split hΘ r, ← tsum_div_const]
    refine tsum_congr fun ρ => ?_
    rw [pow_zero, mul_one, CellModes.mode_two_int, zpow_natCast]
    rfl
  exact (LadderMean.line_not_fading_summable (lineSet (ρ₀ : ℂ).re) hβ ρ₀ hρ₀ hsum 0 hlim).elim

/-- info: 'AttainedPi.attained_off_line_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms attained_off_line_pi

/-- info: 'AttainedPi.fin_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms fin_bound

/-- info: 'AttainedPi.band_small' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms band_small

end

end AttainedPi
