/-
PsiToPi — step 3: the transfer from ψ-error to π−Li error.

The classical chain: Mathlib's Abel-summation bridge
(`Chebyshev.primeCounting_eq_theta_div_log_add_integral`) writes
π(⌊x⌋) = θ(x)/log x + ∫₂ˣ θ(t)/(t·log²t) dt, and the same identity for
the logarithmic integral turns any bound on |θ − id| into a bound on
|π − Li|. Mathlib carries no li, so this module defines its own:

  Li x = x/log x + ∫₂ˣ dt/log²t

which differs from the literature's li by the constant
Li(2) − li(2) = 2/log 2 − li(2) ≈ 1.840 — an offset the weak family's
constants absorb. What this slice proves,
all integrability discharged:

  pi_sub_Li_eq        π(⌊x⌋) − Li x = (θx − x)/log x + ∫₂ˣ (θt − t)/(t·log²t)
                      — the EXACT decomposition, an identity
  abs_pi_sub_Li_le    the envelope transfer: any pointwise bound on
                      |θ − id| gives |π − Li| ≤ top/log x + ∫ env/(t·log²t)
  theta_err_of_psi    |θ − id| from |ψ − id| by Mathlib's |ψ−θ| ≤ 2√x·log x
  integral_A_rpow_le  the workhorse envelope integral: ∫₂ˣ A·t^(−1/2) ≤ 2A√x

Next slice: instantiate env with the family shape C·√t·(log t)^k and
compute the delivered (C', k−1) — the transfer drops one log and
inflates the constant explicitly.

The weld caveat from Stage3.lean applies. Companion to notes entry 122.
-/
import Mathlib
import Stage3.Statement

namespace Stage3

open Chebyshev MeasureTheory
open scoped Chebyshev

noncomputable section

/-- The offset logarithmic integral: `Li x = x/log x + ∫₂ˣ dt/log²t`.
Differs from the literature's `li` by the constant
`2/log 2 − li(2) ≈ 1.840`. -/
def Li (x : ℝ) : ℝ := x / Real.log x + ∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2

/-- `1/log²t` is continuous on any interval right of `2`. -/
theorem continuousOn_inv_log_sq {a x : ℝ} (ha : 2 ≤ a) (hx : a ≤ x) :
    ContinuousOn (fun t : ℝ => 1 / Real.log t ^ 2) (Set.uIcc a x) := by
  rw [Set.uIcc_of_le hx]
  intro t ht
  have h2t : (2 : ℝ) ≤ t := le_trans ha ht.1
  have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
  exact continuousWithinAt_const.div
    (((Real.continuousAt_log (by linarith)).continuousWithinAt).pow 2)
    (pow_ne_zero 2 hlog)

/-- `(t·log²t)⁻¹` is continuous on any interval right of `2`. -/
theorem continuousOn_inv_mul_log_sq {a x : ℝ} (ha : 2 ≤ a) (hx : a ≤ x) :
    ContinuousOn (fun t : ℝ => (t * Real.log t ^ 2)⁻¹) (Set.uIcc a x) := by
  rw [Set.uIcc_of_le hx]
  intro t ht
  have h2t : (2 : ℝ) ≤ t := le_trans ha ht.1
  have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
  have hne : t * Real.log t ^ 2 ≠ 0 :=
    mul_ne_zero (by linarith) (pow_ne_zero 2 hlog)
  exact (continuousWithinAt_id.mul
    (((Real.continuousAt_log (by linarith)).continuousWithinAt).pow 2)).inv₀ hne

/-- `θ(t)/(t·log²t)` is interval integrable on `[2, x]`: `θ` is monotone,
the cofactor is continuous. -/
theorem integrable_theta_term {a x : ℝ} (ha : 2 ≤ a) (hx : a ≤ x) :
    IntervalIntegrable (fun t => θ t / (t * Real.log t ^ 2)) volume a x := by
  have hθ : IntervalIntegrable θ volume a x :=
    (theta_mono.monotoneOn _).intervalIntegrable
  have h := hθ.mul_continuousOn (continuousOn_inv_mul_log_sq ha hx)
  simpa [div_eq_mul_inv] using h

/-- `(θ(t) − t)/(t·log²t)` is interval integrable on `[2, x]`. -/
theorem integrable_err_term {a x : ℝ} (ha : 2 ≤ a) (hx : a ≤ x) :
    IntervalIntegrable (fun t => (θ t - t) / (t * Real.log t ^ 2)) volume a x := by
  have hθ : IntervalIntegrable θ volume a x :=
    (theta_mono.monotoneOn _).intervalIntegrable
  have hid : IntervalIntegrable (fun t : ℝ => t) volume a x :=
    (continuous_id.continuousOn).intervalIntegrable
  have h := (hθ.sub hid).mul_continuousOn (continuousOn_inv_mul_log_sq ha hx)
  simpa [div_eq_mul_inv] using h

/-- **The exact decomposition** — an identity, from Mathlib's Abel-summation
bridge and the definition of `Li`:
`π(⌊x⌋) − Li x = (θx − x)/log x + ∫₂ˣ (θt − t)/(t·log²t) dt`. -/
theorem pi_sub_Li_eq {x : ℝ} (hx : 2 ≤ x) :
    (Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x
      = (θ x - x) / Real.log x
        + ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) := by
  have hbridge := Chebyshev.primeCounting_eq_theta_div_log_add_integral hx
  have hAB : (∫ t in (2 : ℝ)..x, θ t / (t * Real.log t ^ 2))
        - ∫ t in (2 : ℝ)..x, 1 / Real.log t ^ 2
      = ∫ t in (2 : ℝ)..x, (θ t - t) / (t * Real.log t ^ 2) := by
    rw [← intervalIntegral.integral_sub (integrable_theta_term (by norm_num) hx)
      ((continuousOn_inv_log_sq (by norm_num) hx).intervalIntegrable)]
    apply intervalIntegral.integral_congr
    intro t ht
    rw [Set.uIcc_of_le hx] at ht
    have h2t : (2 : ℝ) ≤ t := ht.1
    have h0 : t ≠ 0 := by linarith
    have hlog : Real.log t ≠ 0 := ne_of_gt (Real.log_pos (by linarith))
    field_simp
  unfold Li
  linear_combination hbridge + hAB

/-- **The envelope transfer:** a pointwise bound on `|θ − id|` becomes a
bound on `|π − Li|`, top term plus envelope integral. -/
theorem abs_pi_sub_Li_le {x : ℝ} (hx : 2 ≤ x) {env : ℝ → ℝ}
    (hEnv : ∀ t ∈ Set.Icc (2 : ℝ) x, |θ t - t| ≤ env t)
    (hEnvInt : IntervalIntegrable
      (fun t => env t / (t * Real.log t ^ 2)) volume 2 x) :
    |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x|
      ≤ |θ x - x| / Real.log x
        + ∫ t in (2 : ℝ)..x, env t / (t * Real.log t ^ 2) := by
  rw [pi_sub_Li_eq hx]
  refine le_trans (abs_add_le _ _) (add_le_add ?_ ?_)
  · rw [abs_div, abs_of_pos (Real.log_pos (by linarith : (1 : ℝ) < x))]
  · rw [← Real.norm_eq_abs]
    refine intervalIntegral.norm_integral_le_of_norm_le
      (by linarith : (2 : ℝ) ≤ x) ?_ hEnvInt
    filter_upwards with t ht
    have h2t : (2 : ℝ) ≤ t := le_of_lt ht.1
    have htx : t ≤ x := ht.2
    have hpos : 0 < t * Real.log t ^ 2 :=
      mul_pos (by linarith)
        (pow_pos (Real.log_pos (by linarith)) 2)
    rw [Real.norm_eq_abs, abs_div, abs_of_pos hpos]
    gcongr
    exact hEnv t ⟨h2t, htx⟩

/-- **The workhorse envelope integral:** `∫₂ˣ A·t^(−1/2) dt ≤ 2A·√x`. -/
theorem integral_A_rpow_le {a x A : ℝ} (ha : 0 < a) (hx : a ≤ x) (hA : 0 ≤ A) :
    (∫ t in a..x, A * t ^ (-(1 : ℝ) / 2)) ≤ 2 * A * Real.sqrt x := by
  rw [intervalIntegral.integral_const_mul]
  have h0 : (0 : ℝ) ∉ Set.uIcc a x := by
    rw [Set.uIcc_of_le hx]
    rintro ⟨h0a, _⟩
    linarith
  rw [integral_rpow (Or.inl (by norm_num))]
  have hxs : x ^ (-(1 : ℝ) / 2 + 1) = Real.sqrt x := by
    rw [show (-(1 : ℝ) / 2 + 1) = 1 / 2 by norm_num, ← Real.sqrt_eq_rpow]
  have h2s : (0 : ℝ) ≤ a ^ (-(1 : ℝ) / 2 + 1) :=
    Real.rpow_nonneg ha.le _
  rw [hxs]
  have hs : 0 ≤ Real.sqrt x := Real.sqrt_nonneg x
  have expand : (Real.sqrt x - a ^ (-(1 : ℝ) / 2 + 1)) / (-(1 : ℝ) / 2 + 1)
      = 2 * (Real.sqrt x - a ^ (-(1 : ℝ) / 2 + 1)) := by
    ring
  rw [expand]
  nlinarith [mul_nonneg hA h2s]

/-- **`θ`-error from `ψ`-error**, by Mathlib's `|ψ − θ| ≤ 2√x·log x`. -/
theorem theta_err_of_psi {x E : ℝ} (hx : 1 ≤ x) (hψ : |ψ x - x| ≤ E) :
    |θ x - x| ≤ E + 2 * Real.sqrt x * Real.log x := by
  have h := Chebyshev.abs_psi_sub_theta_le_sqrt_mul_log hx
  calc |θ x - x| ≤ |θ x - ψ x| + |ψ x - x| := abs_sub_le _ _ _
    _ = |ψ x - θ x| + |ψ x - x| := by rw [abs_sub_comm]
    _ ≤ 2 * Real.sqrt x * Real.log x + E := add_le_add h hψ
    _ = E + 2 * Real.sqrt x * Real.log x := by ring

/-- **The ψ-side of the weak family:** what stage 5's assembly (hRH + hEF +
hNT) delivers. `ψ` is Mathlib's Chebyshev function. -/
def StmtPsiWeak (C : ℝ) (k : ℕ) (x₀ : ℝ) : Prop :=
  ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * Real.sqrt t * Real.log t ^ k

/-- Crude linear bound below the family floor: `|θ − id| ≤ (1 + log 4)·t`,
from `0 ≤ θ t ≤ log 4 · t`. -/
theorem abs_theta_sub_le_linear {t : ℝ} (ht : 0 ≤ t) :
    |θ t - t| ≤ (1 + Real.log 4) * t := by
  have h1 := theta_nonneg t
  have h2 := theta_le_log4_mul_x ht
  have hl4 : 0 ≤ Real.log 4 := Real.log_nonneg (by norm_num)
  rw [abs_sub_le_iff]
  constructor <;> nlinarith

/-- The numeric fact carrying the low-range constant:
`1 + log 4 ≤ 5·log²2`, i.e. `(1 + log 4)/log²2 ≤ 5`. -/
theorem one_add_log_four_le : 1 + Real.log 4 ≤ 5 * Real.log 2 ^ 2 := by
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    push_cast
    ring
  have hlo := Real.log_two_gt_d9
  have hhi := Real.log_two_lt_d9
  nlinarith

/-- `t^(−1/2)` times the denominator is the √t envelope:
`t^(−1/2)·(t·log²t) = √t·log²t` on `t > 0`. -/
theorem rpow_neg_half_mul {t : ℝ} (ht : 0 < t) :
    t ^ (-(1 : ℝ) / 2) * (t * Real.log t ^ 2)
      = Real.sqrt t * Real.log t ^ 2 := by
  rw [show t ^ (-(1 : ℝ) / 2) * (t * Real.log t ^ 2)
      = t ^ (-(1 : ℝ) / 2) * t * Real.log t ^ 2 by ring,
    ← Real.rpow_add_one (ne_of_gt ht),
    show (-(1 : ℝ) / 2 + 1) = 1 / 2 by norm_num,
    ← Real.sqrt_eq_rpow]

/-- **The capstone of step 3: the transfer.** A ψ-side weak bound
`(C, k, x₀)` with `k ≥ 2, x₀ ≥ 2` delivers the π-side weak bound with
`C′ = 3C + 13`, exponent `k − 1`, floor `max(x₀², 9)` — one log dropped,
the constant inflated explicitly — and the conclusion is literally
`StmtSchoenfeldWeak`, so Statement.lean's window bridge applies to it. -/
theorem schoenfeldWeak_of_psiWeak {C : ℝ} {k : ℕ} {x₀ : ℝ}
    (hk : 2 ≤ k) (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C)
    (h : StmtPsiWeak C k x₀) :
    StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9)
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
      ≤ 2 * (C * L ^ (k - 2) + 3) * S := by
    have hA : (0 : ℝ) ≤ C * L ^ (k - 2) + 3 := by positivity
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (f := fun t => (θ t - t) / (t * Real.log t ^ 2))
      (g := fun t => (C * L ^ (k - 2) + 3) * t ^ (-(1 : ℝ) / 2)) hx₀x ?_ ?_
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
          ≤ C * Real.sqrt t * Real.log t ^ k + 2 * Real.sqrt t * Real.log t :=
        theta_err_of_psi (by linarith) (h t hx₀t)
      have hdecomp : Real.log t ^ k = Real.log t ^ (k - 2) * Real.log t ^ 2 := by
        rw [← pow_add]
        congr 1
        omega
      have hpow : Real.log t ^ (k - 2) ≤ L ^ (k - 2) :=
        pow_le_pow_left₀ hlt2.le hlogtx _
      have e1 : C * Real.sqrt t * Real.log t ^ k
          ≤ C * L ^ (k - 2) * (Real.sqrt t * Real.log t ^ 2) := by
        rw [hdecomp]
        have base : Real.sqrt t * Real.log t ^ (k - 2)
            ≤ Real.sqrt t * L ^ (k - 2) :=
          mul_le_mul_of_nonneg_left hpow hst
        calc C * Real.sqrt t * (Real.log t ^ (k - 2) * Real.log t ^ 2)
            = C * (Real.sqrt t * Real.log t ^ (k - 2)) * Real.log t ^ 2 := by
              ring
          _ ≤ C * (Real.sqrt t * L ^ (k - 2)) * Real.log t ^ 2 :=
              mul_le_mul_of_nonneg_right
                (mul_le_mul_of_nonneg_left base hC)
                (pow_nonneg hlt2.le 2)
          _ = C * L ^ (k - 2) * (Real.sqrt t * Real.log t ^ 2) := by ring
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
      calc |θ t - t| ≤ C * Real.sqrt t * Real.log t ^ k
            + 2 * Real.sqrt t * Real.log t := hnum
        _ ≤ (C * L ^ (k - 2) + 3) * (Real.sqrt t * Real.log t ^ 2) := by
            linarith
        _ = (C * L ^ (k - 2) + 3) * t ^ (-(1 : ℝ) / 2)
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
  have htop : |θ x - x| / L ≤ C * S * L ^ (k - 1) + 2 * S := by
    have hth : |θ x - x| ≤ C * S * L ^ k + 2 * S * L :=
      theta_err_of_psi (by linarith) (h x hx₀x)
    rw [div_le_iff₀ hLpos]
    have hdec : L ^ k = L ^ (k - 1) * L := by
      rw [← pow_succ]
      congr 1
      omega
    calc |θ x - x| ≤ C * S * L ^ k + 2 * S * L := hth
      _ = (C * S * L ^ (k - 1) + 2 * S) * L := by rw [hdec]; ring
  -- assemble
  show |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x| ≤ (3 * C + 13) * S * L ^ (k - 1)
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
  have hP1 : (1 : ℝ) ≤ L ^ (k - 1) := one_le_pow₀ hlx
  have hQP : L ^ (k - 2) ≤ L ^ (k - 1) :=
    pow_le_pow_right₀ hlx (by omega)
  have hSP : S ≤ S * L ^ (k - 1) := by nlinarith
  have hCSQP : C * (S * L ^ (k - 2)) ≤ C * (S * L ^ (k - 1)) :=
    mul_le_mul_of_nonneg_left
      (mul_le_mul_of_nonneg_left hQP hS) hC
  have hx₀S : 5 * x₀ ≤ 5 * S := by linarith
  nlinarith [htop, hp1, hp2, hSP, hCSQP, hx₀S]

end

/-! ## Axiom check

An axiom claim is only a claim unless the build checks it. Each `#guard_msgs`
block below pins the exact axiom list of one result: if a proof ever starts
depending on anything not listed, the docstring stops matching the compiler and
**`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.continuousOn_inv_log_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.continuousOn_inv_log_sq

/-- info: 'Stage3.continuousOn_inv_mul_log_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.continuousOn_inv_mul_log_sq

/-- info: 'Stage3.integrable_theta_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integrable_theta_term

/-- info: 'Stage3.integrable_err_term' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integrable_err_term

/-- info: 'Stage3.pi_sub_Li_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.pi_sub_Li_eq

/-- info: 'Stage3.abs_pi_sub_Li_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.abs_pi_sub_Li_le

/-- info: 'Stage3.integral_A_rpow_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integral_A_rpow_le

/-- info: 'Stage3.theta_err_of_psi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.theta_err_of_psi


/-- info: 'Stage3.abs_theta_sub_le_linear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.abs_theta_sub_le_linear

/-- info: 'Stage3.one_add_log_four_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.one_add_log_four_le

/-- info: 'Stage3.rpow_neg_half_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rpow_neg_half_mul

/-- info: 'Stage3.schoenfeldWeak_of_psiWeak' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeak_of_psiWeak

end Stage3
