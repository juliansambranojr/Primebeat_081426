/-
PNTWeld — the prime number theorem read at the doublings.

`subst_doubling`: `∫ t in 1..m, 2^t/t = ∫ x in 2..2^m, 1/log x`, the substitution `x = 2^t`.
-/
import Mathlib
import PrimeNumberTheoremAnd.Consequences

namespace Stage3.PNTWeld
open Real Set

theorem subst_doubling (m : ℝ) :
    ∫ t in (1 : ℝ)..m, Real.exp (Real.log 2 * t) / t
      = ∫ x in (2 : ℝ)..Real.exp (Real.log 2 * m), 1 / Real.log x := by
  have hl : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have key := intervalIntegral.integral_comp_mul_deriv_of_deriv_nonneg (a := (1 : ℝ)) (b := m)
    (f := fun t => Real.exp (Real.log 2 * t)) (f' := fun t => Real.exp (Real.log 2 * t) * Real.log 2)
    (g := fun x => 1 / Real.log x)
    (Real.continuous_exp.comp (continuous_const.mul continuous_id)).continuousOn
    (fun t _ => by
      have := ((hasDerivAt_id t).const_mul (Real.log 2)).exp
      simpa [mul_comm] using this)
    (fun t _ => by positivity)
  simp only [Function.comp, mul_one, Real.exp_log (by norm_num : (0 : ℝ) < 2)] at key
  rw [← key]
  refine intervalIntegral.integral_congr fun t _ => ?_
  show Real.exp (Real.log 2 * t) / t = 1 / Real.log (Real.exp (Real.log 2 * t)) * (Real.exp (Real.log 2 * t) * Real.log 2)
  rw [Real.log_exp]
  by_cases ht : t = 0
  · subst ht; simp
  · field_simp

/-- The prime number theorem at the doublings: `|π(2^m) − liRow m| ≤ ε·2^m/m` past some row,
with `liRow m = 2/log 2 + ∫₁^m 2^t/t dt` written out. -/
def StmtPNTx : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ M : ℤ, ∀ m : ℤ, M ≤ m →
    |((Nat.primeCounting (2 ^ m.toNat) : ℕ) : ℝ)
        - (2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t)|
      ≤ ε * (2 : ℝ) ^ (m : ℝ) / m

/-- **The prime number theorem at the doublings, from PNT+.** -/
theorem stmtPNTx : StmtPNTx := by
  intro ε hε
  have hl : 0 < Real.log 2 := Real.log_pos (by norm_num)
  obtain ⟨c, hc, hπ⟩ := pi_alt
  obtain ⟨f, hf, hI⟩ := integral_div_log_asymptotic
  set δ : ℝ := ε * Real.log 2 / 4 with hδ
  have hδ0 : 0 < δ := by positivity
  have h1 := hc.bound hδ0
  have h2 := hf.bound hδ0
  have h3 := Real.isLittleO_log_id_atTop.bound (show 0 < δ * Real.log 2 / 2 by positivity)
  obtain ⟨X, hX⟩ := Filter.eventually_atTop.mp
    (h1.and (h2.and (h3.and (hI.and (Filter.eventually_ge_atTop (2 : ℝ))))))
  refine ⟨max 1 ⌈X⌉, fun m hm => ?_⟩
  have hm1 : (1 : ℤ) ≤ m := le_trans (le_max_left _ _) hm
  have hmX : X ≤ (m : ℝ) := by
    have := le_trans (le_max_right _ _) hm
    exact (Int.ceil_le.mp this)
  have hm0 : (0 : ℝ) < m := by exact_mod_cast (show (0 : ℤ) < m by omega)
  -- x = 2^m
  set x : ℝ := (2 : ℝ) ^ (m : ℝ) with hx
  have hmx : (m : ℝ) ≤ x := by
    have hmt : m = (m.toNat : ℤ) := (Int.toNat_of_nonneg (by omega)).symm
    rw [hx, hmt, Int.cast_natCast, Real.rpow_natCast]
    exact_mod_cast (Nat.lt_two_pow_self).le
  obtain ⟨hc', hf', hlog, hIx, hx2⟩ := hX x (le_trans hmX hmx)
  have hxpos : 0 < x := by positivity
  have hlogx : Real.log x = m * Real.log 2 := by
    rw [hx, Real.log_rpow (by norm_num)]
  have hlogpos : 0 < Real.log x := by rw [hlogx]; positivity
  -- the three pieces
  have hfl : ((Nat.primeCounting (2 ^ m.toNat) : ℕ) : ℝ) = Nat.primeCounting ⌊x⌋₊ := by
    congr 2
    have hmt : m = (m.toNat : ℤ) := (Int.toNat_of_nonneg (by omega)).symm
    rw [hx, hmt, Int.cast_natCast, Real.rpow_natCast]
    exact_mod_cast (Nat.floor_natCast (2 ^ m.toNat)).symm
  have hexp : Real.exp (Real.log 2 * (m : ℝ)) = x := by
    rw [hx, Real.rpow_def_of_pos (by norm_num)]
  have hint : ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t
      = ∫ t in Set.Icc 2 x, 1 / Real.log t := by
    rw [subst_doubling, hexp, intervalIntegral.integral_of_le hx2,
      ← MeasureTheory.integral_Icc_eq_integral_Ioc]
  rw [hfl, hint, hπ x, hIx]
  simp only [norm_eq_abs, abs_one, mul_one] at hc' hf' hlog
  have hlog' : Real.log x ≤ δ * Real.log 2 / 2 * x := by
    have e : |id x| = x := by simp [id, abs_of_pos hxpos]
    rw [e] at hlog; exact (le_abs_self _).trans hlog
  have hK : 2 / Real.log 2 ≤ δ * (x / Real.log x) := by
    rw [div_le_iff₀ hl]
    have : 2 * Real.log x ≤ δ * Real.log 2 * x := by linarith
    calc (2 : ℝ) = 2 * Real.log x / Real.log x := by field_simp
      _ ≤ δ * Real.log 2 * x / Real.log x := div_le_div_of_nonneg_right this hlogpos.le
      _ = δ * (x / Real.log x) * Real.log 2 := by ring
  have hq : 0 < x / Real.log x := div_pos hxpos hlogpos
  have hmain : |(1 + c x) * x / Real.log x - (2 / Real.log 2 + (1 + f x) * x / Real.log x)|
      ≤ 3 * δ * (x / Real.log x) := by
    have heq : (1 + c x) * x / Real.log x - (2 / Real.log 2 + (1 + f x) * x / Real.log x)
        = (c x - f x) * (x / Real.log x) - 2 / Real.log 2 := by ring
    rw [heq]
    have hcf : |c x - f x| ≤ 2 * δ := by
      calc |c x - f x| ≤ |c x| + |f x| := abs_sub _ _
        _ ≤ 2 * δ := by linarith
    calc |(c x - f x) * (x / Real.log x) - 2 / Real.log 2|
        ≤ |(c x - f x) * (x / Real.log x)| + |2 / Real.log 2| := abs_sub _ _
      _ = |c x - f x| * (x / Real.log x) + 2 / Real.log 2 := by
          rw [abs_mul, abs_of_pos hq, abs_of_pos (div_pos (by norm_num : (0:ℝ) < 2) hl)]
      _ ≤ 2 * δ * (x / Real.log x) + δ * (x / Real.log x) := by gcongr
      _ = 3 * δ * (x / Real.log x) := by ring
  refine hmain.trans (le_of_eq_of_le rfl ?_)
  rw [hlogx, hδ]
  have : 3 * (ε * Real.log 2 / 4) * (x / (m * Real.log 2)) = (3 / 4) * (ε * x / m) := by
    field_simp
  rw [this]
  have hpos : 0 ≤ ε * x / m := by positivity
  linarith

end Stage3.PNTWeld

/-- info: 'Stage3.PNTWeld.subst_doubling' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.PNTWeld.subst_doubling

/-- info: 'Stage3.PNTWeld.stmtPNTx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.PNTWeld.stmtPNTx
