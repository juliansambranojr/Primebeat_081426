/-
LandauPrimeSide — the primes' reading of the Taylor coefficients of `Phi`,
bounded from above by a window bound on `G`.
Block 7a of `lean_stage3/design/landau.md`. 2026-11-22.

`Ik σ k = ∫₁^∞ G(y)·(log y)^k·y^(−σ−1) dy`, a real number, and for real `σ > 1`
the `k`-th derivative of `Phi` at `σ` is `(−1)^k·Ik σ k` (`LandauTaylor`). The
kernel `(log y)^k·y^(−σ−1)` is nonnegative on `(1, ∞)`, so upper bounds on `G`
give upper bounds on `Ik`: `G ≤ C·y^θ` on a window `[Y, Y^(1+δ)]`, and `G ≤ 8y`
everywhere (`LandauChebyshev.G_le`).

  Ik                        the integral (the one definition)
  Ik_integrable             (hσ : 1 < σ) (k) : its integrand is integrable on (1, ∞)
  iteratedDeriv_Phi_eq_Ik   (hσ : 1 < σ) (k) :
                              iteratedDeriv k Phi σ = (−1)^k · Ik σ k
  Ik_le                     (hσ : 1 < σ) (hθ : θ < σ) (hC : 0 ≤ C) (hY : 1 ≤ Y)
                            (hδ : 0 ≤ δ) (hwin : ∀ y ∈ Icc Y (Y^(1+δ)), G y ≤ C·y^θ)
                            (hb : 0 < b) (hb' : 0 < b') (hb'a : b' < σ − 1) (k) :
                              Ik σ k ≤ C·(k!/(σ−θ)^(k+1))
                                + 8·(Y^b·(k!/(σ−1+b)^(k+1)))
                                + 8·((Y^(1+δ))^(−b')·(k!/(σ−1−b')^(k+1)))

What the next slice needs: this bound against the zeros' reading of the same
coefficient (block 7b), with `b`, `b'` and `k` chosen as in the design of
block 7.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauTaylor
import Stage3.LandauTail

namespace LandauPrimeSide

noncomputable section

open MeasureTheory Set Filter

/-- `∫₁^∞ G(y)·(log y)^k·y^(−σ−1) dy`. -/
def Ik (σ : ℝ) (k : ℕ) : ℝ :=
  ∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)

theorem Ik_integrable {σ : ℝ} (hσ : 1 < σ) (k : ℕ) :
    IntegrableOn (fun y : ℝ => LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)) (Ioi 1) := by
  have hs : 1 < ((σ : ℝ) : ℂ).re := by simpa using hσ
  have hc := (LandauTaylor.mellinLog_integrable hs k).re
  have h2 := hc.const_mul ((-1 : ℝ) ^ k)
  refine IntegrableOn.congr_fun h2 (fun y hy => ?_) measurableSet_Ioi
  have hy0 : (0 : ℝ) ≤ y := by linarith [mem_Ioi.mp hy]
  have e : (y : ℂ) ^ (-(σ : ℂ) - 1) = ((y ^ (-σ - 1) : ℝ) : ℂ) := by
    rw [Complex.ofReal_cpow hy0]; push_cast; rfl
  have hval : (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-(σ : ℂ) - 1)
      = (((-1 : ℝ) ^ k * (LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)) : ℝ) : ℂ) := by
    rw [e, neg_pow]
    push_cast
    ring
  simp only [RCLike.re_to_complex]
  rw [hval, Complex.ofReal_re, ← mul_assoc, ← pow_add, ← two_mul, pow_mul]
  norm_num

theorem iteratedDeriv_Phi_eq_Ik {σ : ℝ} (hσ : 1 < σ) (k : ℕ) :
    iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) : ℂ) := by
  have hs : 1 < ((σ : ℝ) : ℂ).re := by simpa using hσ
  rw [LandauTaylor.iteratedDeriv_Phi k hs, LandauTaylor.mellinLog_real, Ik]

theorem Ik_le {σ θ δ C Y b b' : ℝ} (hσ : 1 < σ) (hθ : θ < σ) (hC : 0 ≤ C) (hY : 1 ≤ Y)
    (hδ : 0 ≤ δ) (hwin : ∀ y ∈ Icc Y (Y ^ (1 + δ)), LandauWindow.G y ≤ C * y ^ θ)
    (hb : 0 < b) (hb' : 0 < b') (hb'a : b' < σ - 1) (k : ℕ) :
    Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1))
      + 8 * (Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1)))
      + 8 * ((Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1))) := by
  have ha : 0 < σ - 1 := by linarith
  have hσθ : 0 < σ - θ := by linarith
  have hY0 : 0 < Y := by linarith
  have hZ : 1 ≤ Y ^ (1 + δ) := Real.one_le_rpow hY (by linarith)
  -- the three majorants
  set K : ℝ → ℝ := fun y => Real.log y ^ k * y ^ (-(σ - 1) - 1) with hK
  set W : ℝ → ℝ := fun y => C * (Real.log y ^ k * y ^ (-(σ - θ) - 1)) with hW
  have hKint : IntegrableOn K (Ioi 1) := LandauKernel.log_pow_integrable ha k
  have hWint : IntegrableOn W (Ioi 1) := (LandauKernel.log_pow_integrable hσθ k).const_mul C
  have hLint : IntegrableOn ((Iic Y).indicator K) (Ioi 1) :=
    Integrable.indicator hKint measurableSet_Iic
  have hUint : IntegrableOn ((Ioi (Y ^ (1 + δ))).indicator K) (Ioi 1) :=
    Integrable.indicator hKint measurableSet_Ioi
  have hHint : IntegrableOn (fun y => W y + 8 * (Iic Y).indicator K y
      + 8 * (Ioi (Y ^ (1 + δ))).indicator K y) (Ioi 1) :=
    (hWint.add (hLint.const_mul 8)).add (hUint.const_mul 8)
  -- pointwise
  have hpt : ∀ y ∈ Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)
      ≤ W y + 8 * (Iic Y).indicator K y + 8 * (Ioi (Y ^ (1 + δ))).indicator K y := by
    intro y hy
    have hy1 : 1 ≤ y := (mem_Ioi.mp hy).le
    have hy0 : 0 < y := by linarith
    have hLk : 0 ≤ Real.log y ^ k := pow_nonneg (Real.log_nonneg hy1) k
    have hP : 0 ≤ y ^ (-σ - 1) := Real.rpow_nonneg hy0.le _
    have hKy : K y = y * (Real.log y ^ k * y ^ (-σ - 1)) := by
      have e : y ^ (-(σ - 1) - 1) = y * y ^ (-σ - 1) := by
        rw [mul_comm, ← Real.rpow_add_one hy0.ne']; congr 1; ring
      rw [hK]; simp only []; rw [e]; ring
    have hWy : W y = C * y ^ θ * (Real.log y ^ k * y ^ (-σ - 1)) := by
      have e : y ^ (-(σ - θ) - 1) = y ^ θ * y ^ (-σ - 1) := by
        rw [← Real.rpow_add hy0]; congr 1; ring
      rw [hW]; simp only []; rw [e]; ring
    have hKnn : 0 ≤ K y := by rw [hKy]; positivity
    have hWnn : 0 ≤ W y := by
      rw [hWy]; exact mul_nonneg (mul_nonneg hC (Real.rpow_nonneg hy0.le _)) (mul_nonneg hLk hP)
    have hLK : 0 ≤ Real.log y ^ k * y ^ (-σ - 1) := mul_nonneg hLk hP
    have hGeq : LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)
        = LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1)) := by ring
    rw [hGeq]
    by_cases h1 : y ≤ Y
    · -- below the window (or at its left end)
      have hG := LandauChebyshev.G_le hy1
      rw [Set.indicator_of_mem (mem_Iic.mpr h1)]
      have hU0 : 0 ≤ (Ioi (Y ^ (1 + δ))).indicator K y := Set.indicator_nonneg (fun _ _ => hKnn) y
      have : LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1)) ≤ 8 * K y := by
        rw [hKy]
        calc LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1))
            ≤ 8 * y * (Real.log y ^ k * y ^ (-σ - 1)) := mul_le_mul_of_nonneg_right hG hLK
          _ = 8 * (y * (Real.log y ^ k * y ^ (-σ - 1))) := by ring
      linarith
    · by_cases h2 : y ≤ Y ^ (1 + δ)
      · -- on the window
        have hG := hwin y ⟨(not_le.mp h1).le, h2⟩
        rw [Set.indicator_of_notMem (by simpa using h1),
          Set.indicator_of_notMem (by simpa using h2)]
        have : LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1)) ≤ W y := by
          rw [hWy]
          exact mul_le_mul_of_nonneg_right hG hLK
        linarith
      · -- above the window
        have hG := LandauChebyshev.G_le hy1
        rw [Set.indicator_of_notMem (by simpa using h1),
          Set.indicator_of_mem (mem_Ioi.mpr (not_le.mp h2))]
        have : LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1)) ≤ 8 * K y := by
          rw [hKy]
          calc LandauWindow.G y * (Real.log y ^ k * y ^ (-σ - 1))
              ≤ 8 * y * (Real.log y ^ k * y ^ (-σ - 1)) := mul_le_mul_of_nonneg_right hG hLK
            _ = 8 * (y * (Real.log y ^ k * y ^ (-σ - 1))) := by ring
        linarith
  have hmono := setIntegral_mono_on (Ik_integrable hσ k) hHint measurableSet_Ioi hpt
  -- the integral of the majorant
  have hI1 : ∫ y in Ioi (1 : ℝ), W y = C * (k.factorial / (σ - θ) ^ (k + 1)) := by
    rw [hW, integral_const_mul, LandauKernel.log_pow_integral hσθ k]
  have hI2 : ∫ y in Ioi (1 : ℝ), (Iic Y).indicator K y
      ≤ Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1)) := by
    rw [setIntegral_indicator measurableSet_Iic]
    have : Ioi (1 : ℝ) ∩ Iic Y = Ioc 1 Y := by ext y; simp [mem_Ioc]
    rw [this]
    exact LandauTail.lower_tail_le ha hb k hY
  have hI3 : ∫ y in Ioi (1 : ℝ), (Ioi (Y ^ (1 + δ))).indicator K y
      ≤ (Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1)) := by
    rw [setIntegral_indicator measurableSet_Ioi]
    have : Ioi (1 : ℝ) ∩ Ioi (Y ^ (1 + δ)) = Ioi (Y ^ (1 + δ)) :=
      inter_eq_right.mpr (Ioi_subset_Ioi hZ)
    rw [this]
    exact LandauTail.upper_tail_le hb' hb'a k hZ
  have hsplit : ∫ y in Ioi (1 : ℝ), (W y + 8 * (Iic Y).indicator K y
      + 8 * (Ioi (Y ^ (1 + δ))).indicator K y)
      = (∫ y in Ioi (1 : ℝ), W y) + 8 * (∫ y in Ioi (1 : ℝ), (Iic Y).indicator K y)
        + 8 * (∫ y in Ioi (1 : ℝ), (Ioi (Y ^ (1 + δ))).indicator K y) := by
    rw [integral_add (f := fun y => W y + 8 * (Iic Y).indicator K y)
        (hWint.add (hLint.const_mul 8)) (hUint.const_mul 8),
      integral_add hWint (hLint.const_mul 8), integral_const_mul (8 : ℝ) ((Iic Y).indicator K),
      integral_const_mul (8 : ℝ) ((Ioi (Y ^ (1 + δ))).indicator K)]
  rw [Ik]
  rw [hsplit, hI1] at hmono
  linarith

/-- info: 'LandauPrimeSide.Ik_integrable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ik_integrable

/-- info: 'LandauPrimeSide.iteratedDeriv_Phi_eq_Ik' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms iteratedDeriv_Phi_eq_Ik

/-- info: 'LandauPrimeSide.Ik_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Ik_le

end

end LandauPrimeSide
