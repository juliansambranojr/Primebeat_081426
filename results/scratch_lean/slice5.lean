/-
Slice 5 — the Dirichlet-series bound ABOVE the line.

`I₁`/`I₉` of the smoothed-Chebyshev contour sit at `σ₀ = 1 + 1/log X`, to the
RIGHT of `Re s = 1`, where the critical-line Jensen bound of slice 3 is
enormously wasteful.  There the Dirichlet series is absolutely convergent and
the bound is elementary: no contour, no zeros, no Jensen, no RH.

    ‖ζ'/ζ(s)‖ ≤ ∑ Λ(n) n^{-σ} ≤ 2/(σ-1) + 4/(σ-1)²        (σ = Re s > 1)

Scratch only.
-/
import Mathlib.NumberTheory.LSeries.Dirichlet
import Mathlib.Analysis.SumIntegralComparisons
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

open Set MeasureTheory Complex ArithmeticFunction

namespace Slice5

noncomputable section

local notation "ζ" => riemannZeta

/-! ### The p-series input -/

/-- Integral test: for `b > 0`, `∑_{n ≥ 2} n^{-1-b} ≤ 1/b`. -/
theorem pseries_tail_le {b : ℝ} (hb : 0 < b) :
    ∑' (n : ℕ), ((n + 1 + 1 : ℕ) : ℝ) ^ (-1 - b) ≤ 1 / b := by
  have hlt : (-1 - b) < -1 := by linarith
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-1 - b)) (Ici ((1:ℕ) : ℝ)) := by
    refine (Real.antitoneOn_rpow_Ioi_of_exponent_nonpos (by linarith)).mono ?_
    intro x hx
    simp only [Nat.cast_one, mem_Ici] at hx
    exact mem_Ioi.mpr (by linarith)
  have hint : IntegrableOn (fun x : ℝ => x ^ (-1 - b)) (Ioi ((1:ℕ) : ℝ)) := by
    simpa using integrableOn_Ioi_rpow_of_lt hlt (by norm_num : (0:ℝ) < 1)
  have hnn : ∀ t ∈ Ioi ((1:ℕ) : ℝ), (0:ℝ) ≤ t ^ (-1 - b) := by
    intro t ht
    simp only [Nat.cast_one, mem_Ioi] at ht
    positivity
  have key := AntitoneOn.tsum_comp_add_le_integral (f := fun x : ℝ => x ^ (-1 - b)) 1 hanti hint hnn
  have hI : ∫ (x : ℝ) in Ioi ((1:ℕ) : ℝ), x ^ (-1 - b) = 1 / b := by
    rw [Nat.cast_one, integral_Ioi_rpow_of_lt hlt (by norm_num : (0:ℝ) < 1)]
    rw [Real.one_rpow, show (-1 - b + 1) = -b by ring]
    field_simp
  rw [hI] at key
  exact key

/-- For `b > 0`, `∑_{n ≥ 0} n^{-1-b} ≤ 1 + 1/b` (the `n = 0` term is `0`). -/
theorem pseries_le {b : ℝ} (hb : 0 < b) :
    ∑' (n : ℕ), ((n : ℝ)) ^ (-1 - b) ≤ 1 + 1 / b := by
  have hlt : (-1 - b) < -1 := by linarith
  have hsum : Summable (fun n : ℕ => ((n : ℝ)) ^ (-1 - b)) := Real.summable_nat_rpow.mpr hlt
  have hsplit := (hsum.sum_add_tsum_nat_add 2)
  have hhead : ∑ i ∈ Finset.range 2, ((i : ℝ)) ^ (-1 - b) = 1 := by
    rw [Finset.sum_range_succ, Finset.sum_range_one]
    rw [Nat.cast_zero, Nat.cast_one, Real.zero_rpow (by linarith), Real.one_rpow]
    ring
  have htail : ∑' (n : ℕ), (((n + 2 : ℕ)) : ℝ) ^ (-1 - b) ≤ 1 / b := pseries_tail_le hb
  rw [hhead] at hsplit
  linarith [hsplit, htail]

/-! ### The Dirichlet-series bound -/

/-- `Λ n / n^σ ≤ (1/b) · n^{-1-b}` when `σ = 1 + 2b`, `b > 0`. -/
theorem vonMangoldt_term_le {b : ℝ} (hb : 0 < b) (n : ℕ) :
    ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) ((1 + 2 * b : ℝ) : ℂ) n‖
      ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) := by
  rcases eq_or_ne n 0 with rfl | hn
  · simp [Real.zero_rpow (show (-1 - b) ≠ 0 by linarith)]
  · have hnpos : (0:ℝ) < (n : ℝ) := by
      exact_mod_cast Nat.pos_of_ne_zero hn
    have hre : (((1 + 2 * b : ℝ) : ℂ)).re = 1 + 2 * b := by simp
    have hnorm : ‖((vonMangoldt n : ℝ) : ℂ)‖ = vonMangoldt n := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg vonMangoldt_nonneg]
    -- `log n ≤ n^b / b`
    have hlog : Real.log (n : ℝ) ≤ (n : ℝ) ^ b / b := by
      have h1 : Real.log ((n : ℝ) ^ b) ≤ (n : ℝ) ^ b - 1 :=
        Real.log_le_sub_one_of_pos (Real.rpow_pos_of_pos hnpos b)
      rw [Real.log_rpow hnpos] at h1
      rw [le_div_iff₀ hb]
      nlinarith [h1]
    have hΛ : vonMangoldt n ≤ (n : ℝ) ^ b / b := le_trans vonMangoldt_le_log hlog
    rw [LSeries.norm_term_eq, if_neg hn, hnorm, hre]
    have hden : (0:ℝ) < (n : ℝ) ^ (1 + 2 * b) := Real.rpow_pos_of_pos hnpos _
    rw [div_le_iff₀ hden]
    have hpow : ((n:ℝ)) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b) = (n : ℝ) ^ b := by
      rw [← Real.rpow_add hnpos]
      ring_nf
    calc vonMangoldt n ≤ (n : ℝ) ^ b / b := hΛ
      _ = (1 / b) * ((n : ℝ) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b)) := by rw [hpow]; ring
      _ = 1 / b * (n : ℝ) ^ (-1 - b) * (n : ℝ) ^ (1 + 2 * b) := by ring

/-- **Slice 5.**  For `Re s > 1`, elementary and RH-free:
`‖ζ'/ζ(s)‖ ≤ 2/(Re s - 1) + 4/(Re s - 1)²`. -/
theorem norm_logDerivZeta_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    ‖deriv ζ s / ζ s‖ ≤ 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 := by
  set b : ℝ := (s.re - 1) / 2 with hbdef
  have hb : 0 < b := by rw [hbdef]; linarith
  have hsre : s.re = 1 + 2 * b := by rw [hbdef]; ring
  -- the identity
  have hid := ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs
  have hnormeq : ‖deriv ζ s / ζ s‖
      = ‖LSeries (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s‖ := by
    rw [hid, neg_div, norm_neg]
  -- absolute summability
  have hsummable : LSeriesSummable (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt hs
  have hnsum : Summable (fun n : ℕ =>
      ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖) :=
    summable_norm_iff.mpr hsummable
  -- majorant
  have hmajsum : Summable (fun n : ℕ => (1 / b) * ((n : ℝ)) ^ (-1 - b)) :=
    (Real.summable_nat_rpow.mpr (by linarith)).mul_left _
  have hterm : ∀ n : ℕ,
      ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖
        ≤ (1 / b) * ((n : ℝ)) ^ (-1 - b) := by
    intro n
    have := vonMangoldt_term_le hb n
    rw [LSeries.norm_term_eq] at this ⊢
    simpa [hsre] using this
  calc ‖deriv ζ s / ζ s‖
      = ‖∑' n : ℕ, LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖ := hnormeq
    _ ≤ ∑' n : ℕ, ‖LSeries.term (fun k : ℕ => ((vonMangoldt k : ℝ) : ℂ)) s n‖ :=
        norm_tsum_le_tsum_norm hnsum
    _ ≤ ∑' n : ℕ, (1 / b) * ((n : ℝ)) ^ (-1 - b) := hnsum.tsum_le_tsum hterm hmajsum
    _ = (1 / b) * ∑' n : ℕ, ((n : ℝ)) ^ (-1 - b) := tsum_mul_left
    _ ≤ (1 / b) * (1 + 1 / b) := by
        exact mul_le_mul_of_nonneg_left (pseries_le hb) (by positivity)
    _ = 2 / (s.re - 1) + 4 / (s.re - 1) ^ 2 := by
        have hd : s.re - 1 ≠ 0 := by linarith
        rw [hbdef]
        field_simp
        ring

/-- **Corollary — the shape the `I₁`/`I₉` integrals consume.**
At the standard abscissa `σ₀ = 1 + 1/L` with `L ≥ 1`, uniformly in `t`:
`‖ζ'/ζ(σ₀ + it)‖ ≤ 2 L + 4 L²`. -/
theorem norm_logDerivZeta_sigma0 {L t : ℝ} (hL : 1 ≤ L) :
    ‖deriv ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ)) / ζ (((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))‖
      ≤ 2 * L + 4 * L ^ 2 := by
  have hLpos : (0:ℝ) < L := by linarith
  have hre : ((((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))).re = 1 + 1 / L := by simp
  have hs : 1 < ((((1 + 1 / L : ℝ) : ℂ) + I * (t : ℂ))).re := by
    rw [hre]
    have : (0:ℝ) < 1 / L := by positivity
    linarith
  have h := norm_logDerivZeta_of_one_lt_re hs
  rw [hre] at h
  refine le_trans h (le_of_eq ?_)
  have h1 : (1 + 1 / L - 1) = 1 / L := by ring
  rw [h1]
  field_simp

end

end Slice5

#check @Slice5.norm_logDerivZeta_of_one_lt_re
#check @Slice5.norm_logDerivZeta_sigma0
#print axioms Slice5.norm_logDerivZeta_of_one_lt_re
#print axioms Slice5.norm_logDerivZeta_sigma0
