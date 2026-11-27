/-
PsiToPiSharp — the ψ-to-π transfer without the factor three.

`PsiToPi.schoenfeldWeak_of_psiWeak` delivers `3C + 13`: the pieces sum to
`C·√x·log x + (2C + 13)·√x`, and it charges the second against `log x ≥ 1`. At
the rows the census reads, `log x ≥ 52`. Here the floor's log `ℓ` is kept:
the constant is `C + (2C + 13)/ℓ`. Same proof, same pieces; the last step changes.
-/
import Mathlib
import Stage3.PsiToPi

namespace Stage3

open Chebyshev MeasureTheory
open scoped Chebyshev

noncomputable section

theorem schoenfeldWeak_of_psiWeak_sharp {C x₀ ℓ : ℝ}
    (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C) (hℓ : 0 < ℓ) (hℓx : ℓ ≤ Real.log (max (x₀ ^ 2) 9))
    (h : StmtPsiWeak C 2 x₀) :
    StmtSchoenfeldWeak (C + (2 * C + 13) / ℓ) 1 (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  intro x hx
  have hx9 : (9 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
  have hxx₀ : x₀ ^ 2 ≤ x := le_trans (le_max_left _ _) hx
  have hx2 : (2 : ℝ) ≤ x := by linarith
  have hx₀x : x₀ ≤ x := by nlinarith
  have hS : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  have hsx : x₀ ≤ Real.sqrt x := by
    rw [show x₀ = Real.sqrt (x₀ ^ 2) from (Real.sqrt_sq (by linarith)).symm]
    exact Real.sqrt_le_sqrt hxx₀
  have hlx : (1 : ℝ) ≤ Real.log x := by
    rw [Real.le_log_iff_exp_le (by linarith)]
    have := Real.exp_one_lt_d9
    linarith
  set L : ℝ := Real.log x with hL
  set S : ℝ := Real.sqrt x with hSdef
  -- split the integral at the family floor
  have hsplit : (∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2))
      = (∫ t in (2 : ℝ)..x₀, (θ t - t) / (t * Real.log t ^ 2))
        + ∫ t in x₀..x, (θ t - t) / (t * Real.log t ^ 2) :=
    (intervalIntegral.integral_add_adjacent_intervals
      (integrable_err_term (by norm_num) hx₀)
      (integrable_err_term hx₀ hx₀x)).symm
  -- piece 1: constant bound below the floor
  have hp1 : |∫ t in (2 : ℝ)..x₀, (θ t - t) / (t * Real.log t ^ 2)| ≤ 5 * x₀ := by
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (f := fun t => (θ t - t) / (t * Real.log t ^ 2))
      (g := fun _ => (5 : ℝ)) hx₀ ?_ intervalIntegrable_const
    · rw [Real.norm_eq_abs] at hb
      refine le_trans hb ?_
      rw [intervalIntegral.integral_const, smul_eq_mul]
      nlinarith
    · filter_upwards with t ht
      have h2t : (2 : ℝ) ≤ t := le_of_lt ht.1
      have hlt : Real.log 2 ≤ Real.log t :=
        Real.log_le_log (by norm_num) h2t
      have hl2 : (0 : ℝ) < Real.log 2 := Real.log_pos (by norm_num)
      have hpos : 0 < t * Real.log t ^ 2 :=
        mul_pos (by linarith) (pow_pos (by linarith) 2)
      rw [Real.norm_eq_abs, abs_div, abs_of_pos hpos]
      rw [div_le_iff₀ hpos]
      have hnum : |θ t - t| ≤ (1 + Real.log 4) * t :=
        abs_theta_sub_le_linear (by linarith)
      have hgrow : Real.log 2 ^ 2 ≤ Real.log t ^ 2 :=
        pow_le_pow_left₀ hl2.le hlt 2
      nlinarith [one_add_log_four_le]
  -- piece 2: family envelope above the floor
  have hp2 : |∫ t in x₀..x, (θ t - t) / (t * Real.log t ^ 2)|
      ≤ 2 * (C * L ^ (2 - 2) + 3) * S := by
    have hA : (0 : ℝ) ≤ C * L ^ (2 - 2) + 3 := by positivity
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (f := fun t => (θ t - t) / (t * Real.log t ^ 2))
      (g := fun t => (C * L ^ (2 - 2) + 3) * t ^ (-(1 : ℝ) / 2)) hx₀x ?_ ?_
    · rw [Real.norm_eq_abs] at hb
      exact le_trans hb (integral_A_rpow_le (by linarith) hx₀x hA)
    · filter_upwards with t ht
      have hx₀t : x₀ ≤ t := le_of_lt ht.1
      have h2t : (2 : ℝ) ≤ t := le_trans hx₀ hx₀t
      have htx : t ≤ x := ht.2
      have hlt2 : (0 : ℝ) < Real.log t := Real.log_pos (by linarith)
      have hlogtx : Real.log t ≤ L := Real.log_le_log (by linarith) htx
      have hst : 0 ≤ Real.sqrt t := Real.sqrt_nonneg t
      have hpos : 0 < t * Real.log t ^ 2 :=
        mul_pos (by linarith) (pow_pos hlt2 2)
      rw [Real.norm_eq_abs, abs_div, abs_of_pos hpos, div_le_iff₀ hpos]
      have hnum : |θ t - t|
          ≤ C * Real.sqrt t * Real.log t ^ 2 + 2 * Real.sqrt t * Real.log t :=
        theta_err_of_psi (by linarith) (h t hx₀t)
      have e1 : C * Real.sqrt t * Real.log t ^ 2
          ≤ C * L ^ (2 - 2) * (Real.sqrt t * Real.log t ^ 2) := by
        norm_num; exact le_of_eq (by ring)
      have e2 : 2 * Real.sqrt t * Real.log t
          ≤ 3 * (Real.sqrt t * Real.log t ^ 2) := by
        have h2le : (2 : ℝ) ≤ 3 * Real.log t := by
          have hd9 := Real.log_two_gt_d9
          have : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
          linarith
        calc 2 * Real.sqrt t * Real.log t
            = 2 * (Real.sqrt t * Real.log t) := by ring
          _ ≤ (3 * Real.log t) * (Real.sqrt t * Real.log t) :=
              mul_le_mul_of_nonneg_right h2le
                (mul_nonneg hst hlt2.le)
          _ = 3 * (Real.sqrt t * Real.log t ^ 2) := by ring
      calc |θ t - t| ≤ C * Real.sqrt t * Real.log t ^ 2
            + 2 * Real.sqrt t * Real.log t := hnum
        _ ≤ (C * L ^ (2 - 2) + 3) * (Real.sqrt t * Real.log t ^ 2) := by
            linarith
        _ = (C * L ^ (2 - 2) + 3) * t ^ (-(1 : ℝ) / 2)
            * (t * Real.log t ^ 2) := by
            rw [mul_assoc, rpow_neg_half_mul (by linarith)]
    · apply ContinuousOn.intervalIntegrable
      apply ContinuousOn.mul continuousOn_const
      intro t ht
      rw [Set.uIcc_of_le hx₀x] at ht
      have ht0 : t ≠ 0 := ne_of_gt (lt_of_lt_of_le (by linarith) ht.1)
      exact (Real.continuousAt_rpow_const t _ (Or.inl ht0)).continuousWithinAt
  -- the top term
  have hLpos : (0 : ℝ) < L := by linarith
  have htop : |θ x - x| / L ≤ C * S * L ^ (2 - 1) + 2 * S := by
    have hth : |θ x - x| ≤ C * S * L ^ 2 + 2 * S * L :=
      theta_err_of_psi (by linarith) (h x hx₀x)
    rw [div_le_iff₀ hLpos]
    have hdec : L ^ 2 = L ^ (2 - 1) * L := by norm_num; ring
    calc |θ x - x| ≤ C * S * L ^ 2 + 2 * S * L := hth
      _ = (C * S * L ^ (2 - 1) + 2 * S) * L := by rw [hdec]; ring
  -- assemble
  show |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x| ≤ (C + (2 * C + 13) / ℓ) * S * L ^ (2 - 1)
  rw [pi_sub_Li_eq hx2, hsplit]
  have habs1 : |(θ x - x) / L
        + ((∫ t in (2 : ℝ)..x₀, (θ t - t) / (t * Real.log t ^ 2))
          + ∫ t in x₀..x, (θ t - t) / (t * Real.log t ^ 2))|
      ≤ |θ x - x| / L
        + (|∫ t in (2 : ℝ)..x₀, (θ t - t) / (t * Real.log t ^ 2)|
          + |∫ t in x₀..x, (θ t - t) / (t * Real.log t ^ 2)|) := by
    refine le_trans (abs_add_le _ _) (add_le_add ?_ (abs_add_le _ _))
    rw [abs_div, abs_of_pos hLpos]
  refine le_trans habs1 ?_
  have hℓL : ℓ ≤ L := le_trans hℓx (Real.log_le_log (by positivity) hx)
  have hkey : (2 * C + 13) * S ≤ (2 * C + 13) / ℓ * S * L := by
    have h1 : 1 ≤ L / ℓ := by rw [le_div_iff₀ hℓ]; linarith
    have h0 : 0 ≤ (2 * C + 13) * S := by positivity
    calc (2 * C + 13) * S = (2 * C + 13) * S * 1 := by ring
      _ ≤ (2 * C + 13) * S * (L / ℓ) := mul_le_mul_of_nonneg_left h1 h0
      _ = (2 * C + 13) / ℓ * S * L := by field_simp
  have hx₀S : 5 * x₀ ≤ 5 * S := by linarith
  simp only [Nat.sub_self, pow_zero, mul_one] at htop hp2 ⊢
  nlinarith [htop, hp1, hp2, hx₀S, hkey]

end

end Stage3

/-- info: 'Stage3.schoenfeldWeak_of_psiWeak_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeak_of_psiWeak_sharp
