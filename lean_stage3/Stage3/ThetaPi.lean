/-
ThetaPi — the ψ → π transfer at a general abscissa θ.

`PsiToPi.schoenfeldWeak_of_psiWeak` is hardwired to exponent `1/2`:
`StmtPsiWeak` carries a literal `Real.sqrt t`, and the envelope integral
`integral_A_rpow_le` integrates `t^(−1/2)` to `2A·√x`. This file is the
same proof with `x^θ` in place of `√x`, for `θ ∈ [1/2, 1)`:

  StmtPsiWeakTheta θ C k x₀        ∀ t ≥ x₀, |ψ t − t| ≤ C·t^θ·(log t)^k
  StmtSchoenfeldWeakTheta θ C k x₀ ∀ x ≥ x₀, |π x − Li x| ≤ C·x^θ·(log x)^k
  integral_A_rpow_theta_le         ∫ₐˣ A·t^(θ−1) ≤ 2A·x^θ        (θ ≥ 1/2)
  theta_err_of_psi_theta           |θ − id| ≤ E + 2·x^θ·log x     (√x ≤ x^θ)
  schoenfeldWeakTheta_of_psiWeakTheta
        (C, k, x₀) on the ψ side  →  (3C+13, k−1, max(x₀², 9)) on the π side
  schoenfeldWeakTheta_of_zeroFree
        StmtZeroFreeRight θ → ∃ C > 0, ∃ x₀, |π x − Li x| ≤ C·x^θ·(log x)²

The last is the census consumer's shape (entry 277: the gate reads
|π − li|/x < ε_d/log x, so any θ < 1 clears it at some R(d)). The
constant `2` in `2A·x^θ` is `1/θ ≤ 2`; the transfer's `3C+13` is
unchanged from PsiToPi.

Weld: `schoenfeldWeak_of_psiWeak_half` is `PsiToPi.schoenfeldWeak_of_psiWeak`'s
statement, obtained through the θ = 1/2 setting. Statement identity only,
per Stage3.lean.

`θ` in this file is the abscissa; Chebyshev's theta is written `ϑ`.
-/
import Stage3.ThetaPsi
import Stage3.PsiToPi

namespace Stage3

open MeasureTheory

local notation "ψ" => Chebyshev.psi
local notation "ϑ" => Chebyshev.theta

noncomputable section

/-- The ψ-side weak bound at exponent `θ`. `StmtPsiWeak` is the `θ = 1/2`
member, `√t` written as `t^(1/2)`. -/
def StmtPsiWeakTheta (θ C : ℝ) (k : ℕ) (x₀ : ℝ) : Prop :=
  ∀ t : ℝ, x₀ ≤ t → |ψ t - t| ≤ C * t ^ θ * Real.log t ^ k

/-- The π-side weak bound at exponent `θ`. -/
def StmtSchoenfeldWeakTheta (θ C : ℝ) (k : ℕ) (x₀ : ℝ) (pi li : ℝ → ℝ) : Prop :=
  ∀ x : ℝ, x₀ ≤ x → |pi x - li x| ≤ C * x ^ θ * Real.log x ^ k

theorem stmtPsiWeak_iff_theta_half {C : ℝ} {k : ℕ} {x₀ : ℝ} :
    StmtPsiWeak C k x₀ ↔ StmtPsiWeakTheta (1/2) C k x₀ := by
  unfold StmtPsiWeak StmtPsiWeakTheta
  refine forall_congr' fun t => imp_congr_right fun _ => ?_
  rw [Real.sqrt_eq_rpow]

theorem stmtSchoenfeldWeak_iff_theta_half {C : ℝ} {k : ℕ} {x₀ : ℝ} {pi li : ℝ → ℝ} :
    StmtSchoenfeldWeak C k x₀ pi li ↔ StmtSchoenfeldWeakTheta (1/2) C k x₀ pi li := by
  unfold StmtSchoenfeldWeak StmtSchoenfeldWeakTheta
  refine forall_congr' fun x => imp_congr_right fun _ => ?_
  rw [Real.sqrt_eq_rpow]

/-- `√x ≤ x^θ` for `x ≥ 1`, `θ ≥ 1/2`. This is where `1/2 ≤ θ` enters the
transfer: Mathlib's `|ψ − ϑ| ≤ 2√x·log x` folds under the `x^θ` envelope. -/
theorem sqrt_le_rpow_theta {x θ : ℝ} (hx : 1 ≤ x) (hθlo : 1/2 ≤ θ) :
    Real.sqrt x ≤ x ^ θ := by
  rw [Real.sqrt_eq_rpow]
  exact Real.rpow_le_rpow_of_exponent_le hx hθlo

/-- **The envelope integral at `θ`:** `∫ₐˣ A·t^(θ−1) dt ≤ 2A·x^θ`. The exact
value is `A·(x^θ − a^θ)/θ`; `1/θ ≤ 2` keeps PsiToPi's constant. -/
theorem integral_A_rpow_theta_le {a x A θ : ℝ} (ha : 0 < a) (hx : a ≤ x)
    (hA : 0 ≤ A) (hθlo : 1/2 ≤ θ) :
    (∫ t in a..x, A * t ^ (θ - 1)) ≤ 2 * A * x ^ θ := by
  rw [intervalIntegral.integral_const_mul]
  have hθ0 : (0 : ℝ) < θ := by linarith
  rw [integral_rpow (Or.inl (by linarith))]
  rw [show θ - 1 + 1 = θ by ring]
  have hax : 0 ≤ a ^ θ := Real.rpow_nonneg ha.le _
  have hxθ : 0 ≤ x ^ θ := Real.rpow_nonneg (by linarith) _
  have h1 : (x ^ θ - a ^ θ) / θ ≤ 2 * x ^ θ := by
    rw [div_le_iff₀ hθ0]
    nlinarith [mul_nonneg hxθ (show (0:ℝ) ≤ 2 * θ - 1 by linarith), hax]
  calc A * ((x ^ θ - a ^ θ) / θ) ≤ A * (2 * x ^ θ) := mul_le_mul_of_nonneg_left h1 hA
    _ = 2 * A * x ^ θ := by ring

/-- **`ϑ`-error from `ψ`-error at `θ`**, by Mathlib's `|ψ − ϑ| ≤ 2√x·log x`
and `√x ≤ x^θ`. -/
theorem theta_err_of_psi_theta {x E θ : ℝ} (hx : 1 ≤ x) (hθlo : 1/2 ≤ θ)
    (hψ : |ψ x - x| ≤ E) :
    |ϑ x - x| ≤ E + 2 * x ^ θ * Real.log x := by
  have h := theta_err_of_psi hx hψ
  have hs : Real.sqrt x ≤ x ^ θ := sqrt_le_rpow_theta hx hθlo
  have hl : 0 ≤ Real.log x := Real.log_nonneg hx
  have : 2 * Real.sqrt x * Real.log x ≤ 2 * x ^ θ * Real.log x := by
    have := mul_le_mul_of_nonneg_right hs hl
    linarith
  linarith

/-- `t^(θ−1)` times the denominator is the `t^θ` envelope:
`t^(θ−1)·(t·log²t) = t^θ·log²t` on `t > 0`. -/
theorem rpow_theta_sub_one_mul {t θ : ℝ} (ht : 0 < t) :
    t ^ (θ - 1) * (t * Real.log t ^ 2) = t ^ θ * Real.log t ^ 2 := by
  rw [show t ^ (θ - 1) * (t * Real.log t ^ 2)
      = t ^ (θ - 1) * t * Real.log t ^ 2 by ring,
    ← Real.rpow_add_one (ne_of_gt ht), show θ - 1 + 1 = θ by ring]

/-- **The transfer at `θ`.** A ψ-side weak bound `(C, k, x₀)` at exponent
`θ ≥ 1/2` with `k ≥ 2, x₀ ≥ 2` delivers the π-side weak bound at the same
exponent with `C′ = 3C + 13`, exponent `k − 1`, floor `max(x₀², 9)`. The
proof is `PsiToPi.schoenfeldWeak_of_psiWeak` with `x^θ` for `√x`. -/
theorem schoenfeldWeakTheta_of_psiWeakTheta {θ C : ℝ} {k : ℕ} {x₀ : ℝ}
    (hθlo : 1/2 ≤ θ) (hk : 2 ≤ k) (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C)
    (h : StmtPsiWeakTheta θ C k x₀) :
    StmtSchoenfeldWeakTheta θ (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  intro x hx
  have hx9 : (9 : ℝ) ≤ x := le_trans (le_max_right _ _) hx
  have hxx₀ : x₀ ^ 2 ≤ x := le_trans (le_max_left _ _) hx
  have hx2 : (2 : ℝ) ≤ x := by linarith
  have hx1 : (1 : ℝ) ≤ x := by linarith
  have hx₀x : x₀ ≤ x := by nlinarith
  have hS : 0 ≤ x ^ θ := Real.rpow_nonneg (by linarith) _
  have hsx : x₀ ≤ x ^ θ := by
    have h1 : x₀ ≤ Real.sqrt x := by
      rw [show x₀ = Real.sqrt (x₀ ^ 2) from (Real.sqrt_sq (by linarith)).symm]
      exact Real.sqrt_le_sqrt hxx₀
    exact le_trans h1 (sqrt_le_rpow_theta hx1 hθlo)
  have hlx : (1 : ℝ) ≤ Real.log x := by
    rw [Real.le_log_iff_exp_le (by linarith)]
    have := Real.exp_one_lt_d9
    linarith
  set L : ℝ := Real.log x with hL
  set S : ℝ := x ^ θ with hSdef
  -- split the integral at the family floor
  have hsplit : (∫ t in (2 : ℝ)..x, (ϑ t - t) / (t * Real.log t ^ 2))
      = (∫ t in (2 : ℝ)..x₀, (ϑ t - t) / (t * Real.log t ^ 2))
        + ∫ t in x₀..x, (ϑ t - t) / (t * Real.log t ^ 2) :=
    (intervalIntegral.integral_add_adjacent_intervals
      (integrable_err_term (by norm_num) hx₀)
      (integrable_err_term hx₀ hx₀x)).symm
  -- piece 1: constant bound below the floor (unchanged from PsiToPi)
  have hp1 : |∫ t in (2 : ℝ)..x₀, (ϑ t - t) / (t * Real.log t ^ 2)| ≤ 5 * x₀ := by
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (f := fun t => (ϑ t - t) / (t * Real.log t ^ 2))
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
      have hnum : |ϑ t - t| ≤ (1 + Real.log 4) * t :=
        abs_theta_sub_le_linear (by linarith)
      have hgrow : Real.log 2 ^ 2 ≤ Real.log t ^ 2 :=
        pow_le_pow_left₀ hl2.le hlt 2
      nlinarith [one_add_log_four_le]
  -- piece 2: family envelope above the floor, `t^θ` for `√t`
  have hp2 : |∫ t in x₀..x, (ϑ t - t) / (t * Real.log t ^ 2)|
      ≤ 2 * (C * L ^ (k - 2) + 3) * S := by
    have hA : (0 : ℝ) ≤ C * L ^ (k - 2) + 3 := by positivity
    have hb := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (f := fun t => (ϑ t - t) / (t * Real.log t ^ 2))
      (g := fun t => (C * L ^ (k - 2) + 3) * t ^ (θ - 1)) hx₀x ?_ ?_
    · rw [Real.norm_eq_abs] at hb
      exact le_trans hb (integral_A_rpow_theta_le (by linarith) hx₀x hA hθlo)
    · filter_upwards with t ht
      have hx₀t : x₀ ≤ t := le_of_lt ht.1
      have h2t : (2 : ℝ) ≤ t := le_trans hx₀ hx₀t
      have htx : t ≤ x := ht.2
      have hlt2 : (0 : ℝ) < Real.log t := Real.log_pos (by linarith)
      have hlogtx : Real.log t ≤ L := Real.log_le_log (by linarith) htx
      have hst : 0 ≤ t ^ θ := Real.rpow_nonneg (by linarith) _
      have hpos : 0 < t * Real.log t ^ 2 :=
        mul_pos (by linarith) (pow_pos hlt2 2)
      rw [Real.norm_eq_abs, abs_div, abs_of_pos hpos, div_le_iff₀ hpos]
      have hnum : |ϑ t - t|
          ≤ C * t ^ θ * Real.log t ^ k + 2 * t ^ θ * Real.log t :=
        theta_err_of_psi_theta (by linarith) hθlo (h t hx₀t)
      have hdecomp : Real.log t ^ k = Real.log t ^ (k - 2) * Real.log t ^ 2 := by
        rw [← pow_add]
        congr 1
        omega
      have hpow : Real.log t ^ (k - 2) ≤ L ^ (k - 2) :=
        pow_le_pow_left₀ hlt2.le hlogtx _
      have e1 : C * t ^ θ * Real.log t ^ k
          ≤ C * L ^ (k - 2) * (t ^ θ * Real.log t ^ 2) := by
        rw [hdecomp]
        have base : t ^ θ * Real.log t ^ (k - 2) ≤ t ^ θ * L ^ (k - 2) :=
          mul_le_mul_of_nonneg_left hpow hst
        calc C * t ^ θ * (Real.log t ^ (k - 2) * Real.log t ^ 2)
            = C * (t ^ θ * Real.log t ^ (k - 2)) * Real.log t ^ 2 := by
              ring
          _ ≤ C * (t ^ θ * L ^ (k - 2)) * Real.log t ^ 2 :=
              mul_le_mul_of_nonneg_right
                (mul_le_mul_of_nonneg_left base hC)
                (pow_nonneg hlt2.le 2)
          _ = C * L ^ (k - 2) * (t ^ θ * Real.log t ^ 2) := by ring
      have e2 : 2 * t ^ θ * Real.log t ≤ 3 * (t ^ θ * Real.log t ^ 2) := by
        have h2le : (2 : ℝ) ≤ 3 * Real.log t := by
          have hd9 := Real.log_two_gt_d9
          have : Real.log 2 ≤ Real.log t := Real.log_le_log (by norm_num) h2t
          linarith
        calc 2 * t ^ θ * Real.log t
            = 2 * (t ^ θ * Real.log t) := by ring
          _ ≤ (3 * Real.log t) * (t ^ θ * Real.log t) :=
              mul_le_mul_of_nonneg_right h2le
                (mul_nonneg hst hlt2.le)
          _ = 3 * (t ^ θ * Real.log t ^ 2) := by ring
      calc |ϑ t - t| ≤ C * t ^ θ * Real.log t ^ k
            + 2 * t ^ θ * Real.log t := hnum
        _ ≤ (C * L ^ (k - 2) + 3) * (t ^ θ * Real.log t ^ 2) := by
            linarith
        _ = (C * L ^ (k - 2) + 3) * t ^ (θ - 1)
            * (t * Real.log t ^ 2) := by
            rw [mul_assoc, rpow_theta_sub_one_mul (by linarith)]
    · apply ContinuousOn.intervalIntegrable
      apply ContinuousOn.mul continuousOn_const
      intro t ht
      rw [Set.uIcc_of_le hx₀x] at ht
      have ht0 : t ≠ 0 := ne_of_gt (lt_of_lt_of_le (by linarith) ht.1)
      exact (Real.continuousAt_rpow_const t _ (Or.inl ht0)).continuousWithinAt
  -- the top term
  have hLpos : (0 : ℝ) < L := by linarith
  have htop : |ϑ x - x| / L ≤ C * S * L ^ (k - 1) + 2 * S := by
    have hth : |ϑ x - x| ≤ C * S * L ^ k + 2 * S * L :=
      theta_err_of_psi_theta hx1 hθlo (h x hx₀x)
    rw [div_le_iff₀ hLpos]
    have hdec : L ^ k = L ^ (k - 1) * L := by
      rw [← pow_succ]
      congr 1
      omega
    calc |ϑ x - x| ≤ C * S * L ^ k + 2 * S * L := hth
      _ = (C * S * L ^ (k - 1) + 2 * S) * L := by rw [hdec]; ring
  -- assemble
  show |(Nat.primeCounting ⌊x⌋₊ : ℝ) - Li x| ≤ (3 * C + 13) * S * L ^ (k - 1)
  rw [pi_sub_Li_eq hx2, hsplit]
  have habs1 : |(ϑ x - x) / L
        + ((∫ t in (2 : ℝ)..x₀, (ϑ t - t) / (t * Real.log t ^ 2))
          + ∫ t in x₀..x, (ϑ t - t) / (t * Real.log t ^ 2))|
      ≤ |ϑ x - x| / L
        + (|∫ t in (2 : ℝ)..x₀, (ϑ t - t) / (t * Real.log t ^ 2)|
          + |∫ t in x₀..x, (ϑ t - t) / (t * Real.log t ^ 2)|) := by
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

/-! ## The weld at `θ = 1/2` -/

/-- **`PsiToPi.schoenfeldWeak_of_psiWeak` recovered** through the dial. -/
theorem schoenfeldWeak_of_psiWeak_half {C : ℝ} {k : ℕ} {x₀ : ℝ}
    (hk : 2 ≤ k) (hx₀ : 2 ≤ x₀) (hC : 0 ≤ C)
    (h : StmtPsiWeak C k x₀) :
    StmtSchoenfeldWeak (3 * C + 13) (k - 1) (max (x₀ ^ 2) 9)
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li :=
  stmtSchoenfeldWeak_iff_theta_half.mpr
    (schoenfeldWeakTheta_of_psiWeakTheta le_rfl hk hx₀ hC
      (stmtPsiWeak_iff_theta_half.mp h))

/-! ## The consumer's shape -/

/-- **From a zero-free half-plane to the π-side bound.** `StmtZeroFreeRight θ`
for `θ ∈ [1/2, 1)` gives `|π(⌊x⌋) − Li x| ≤ C·x^θ·(log x)²` beyond some
`x₀`. Constant `3C_ψ + 13` with `C_ψ` from `psi_weak_of_theta`. -/
theorem schoenfeldWeakTheta_of_zeroFree {θ : ℝ} (hθ : StmtZeroFreeRight θ)
    (hθlo : 1/2 ≤ θ) (hθhi : θ < 1) :
    ∃ C > 0, ∃ x₀ : ℝ, StmtSchoenfeldWeakTheta θ C 2 x₀
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  obtain ⟨C, hC, x₀, h⟩ := psi_weak_of_theta hθ hθlo hθhi
  have h' : StmtPsiWeakTheta θ C 3 (max x₀ 2) :=
    fun t ht => h t (le_trans (le_max_left _ _) ht)
  refine ⟨3 * C + 13, by positivity, max ((max x₀ 2) ^ 2) 9, ?_⟩
  have := schoenfeldWeakTheta_of_psiWeakTheta hθlo (k := 3) (by norm_num)
    (le_max_right _ _) hC.le h'
  simpa using this

/-- The same under RH at `θ = 1/2`: `|π − Li| ≤ C·√x·(log x)²`. -/
theorem schoenfeldWeak_of_RH_half (hRH : RiemannHypothesis) :
    ∃ C > 0, ∃ x₀ : ℝ, StmtSchoenfeldWeak C 2 x₀
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li := by
  obtain ⟨C, hC, x₀, h⟩ :=
    schoenfeldWeakTheta_of_zeroFree (θ := 1/2) (zeroFreeRight_of_RH hRH) le_rfl (by norm_num)
  exact ⟨C, hC, x₀, stmtSchoenfeldWeak_iff_theta_half.mpr h⟩

end

/-! ## Axiom check -/

/-- info: 'Stage3.integral_A_rpow_theta_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.integral_A_rpow_theta_le

/-- info: 'Stage3.theta_err_of_psi_theta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.theta_err_of_psi_theta

/-- info: 'Stage3.schoenfeldWeakTheta_of_psiWeakTheta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeakTheta_of_psiWeakTheta

/-- info: 'Stage3.schoenfeldWeak_of_psiWeak_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeak_of_psiWeak_half

/-- info: 'Stage3.schoenfeldWeakTheta_of_zeroFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeakTheta_of_zeroFree

/-- info: 'Stage3.schoenfeldWeak_of_RH_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.schoenfeldWeak_of_RH_half

end Stage3
