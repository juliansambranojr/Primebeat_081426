/-
LandauTail — the kernel off the window: the integral of `(log y)^k·y^(−a−1)`
over `(1, Y]` and over `(Z, ∞)`, each bounded by a shift of the exponent.
Block 4b of `lean_stage3/design/landau.md`. 2026-11-22.

The whole integral over `(1, ∞)` is `k!/a^(k+1)` (`LandauKernel.log_pow_integral`).
Below `Y`, `y^(−a−1) = y^b·y^(−(a+b)−1) ≤ Y^b·y^(−(a+b)−1)`. Above `Z`,
`y^(−a−1) = y^(−b)·y^(−(a−b)−1) ≤ Z^(−b)·y^(−(a−b)−1)`. The parameter `b` is free.

  lower_tail_le   (ha : 0 < a) (hb : 0 < b) (k) (hY : 1 ≤ Y) :
                    ∫ y in Ioc 1 Y, (log y)^k·y^(−a−1) ≤ Y^b · k!/(a+b)^(k+1)
  upper_tail_le   (hb : 0 < b) (hba : b < a) (k) (hZ : 1 ≤ Z) :
                    ∫ y in Ioi Z, (log y)^k·y^(−a−1) ≤ Z^(−b) · k!/(a−b)^(k+1)

What the next slice needs: these two with `b` chosen against the window
`[Y, Y^(1+δ)]` and the index `k`, in the assembly (block 7); the block's Sizes
line checks by hand that both ratios to `k!/a^(k+1)` then decay like
`e^(−cδ²k)`.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauKernel

namespace LandauTail

noncomputable section

open MeasureTheory Set Filter

/-- Helper: the kernel `(log y)^k·y^(−a−1)` is nonnegative almost everywhere on `(1, ∞)`. -/
private lemma kernel_nonneg (a : ℝ) (k : ℕ) :
    0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))] fun y : ℝ => Real.log y ^ k * y ^ (-a - 1) := by
  filter_upwards [ae_restrict_mem measurableSet_Ioi] with y hy
  have hy1 : 1 ≤ y := (mem_Ioi.mp hy).le
  exact mul_nonneg (pow_nonneg (Real.log_nonneg hy1) k) (Real.rpow_nonneg (by linarith) _)

/-- For `a > 0`, `b > 0` and `Y ≥ 1`, the integral of the kernel `(log y)^k·y^(−a−1)`
over `(1, Y]` is at most `Y^b · k!/(a+b)^(k+1)`. -/
theorem lower_tail_le {a b : ℝ} (ha : 0 < a) (hb : 0 < b) (k : ℕ) {Y : ℝ} (hY : 1 ≤ Y) :
    ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1)
      ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1)) := by
  have hab : 0 < a + b := by linarith
  have hf : IntegrableOn (fun y : ℝ => Real.log y ^ k * y ^ (-a - 1)) (Ioc 1 Y) :=
    (LandauKernel.log_pow_integrable ha k).mono_set Ioc_subset_Ioi_self
  have hgI : IntegrableOn (fun y : ℝ => Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1))) (Ioi 1) :=
    (LandauKernel.log_pow_integrable hab k).const_mul _
  have hg : IntegrableOn (fun y : ℝ => Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1))) (Ioc 1 Y) :=
    hgI.mono_set Ioc_subset_Ioi_self
  have hpt : ∀ y ∈ Ioc (1 : ℝ) Y,
      Real.log y ^ k * y ^ (-a - 1) ≤ Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) := by
    intro y hy
    have hy0 : 0 < y := by linarith [hy.1]
    have hLk : 0 ≤ Real.log y ^ k := pow_nonneg (Real.log_nonneg hy.1.le) k
    have e : y ^ (-a - 1) = y ^ b * y ^ (-(a + b) - 1) := by
      rw [← Real.rpow_add hy0]; congr 1; ring
    have hyb : y ^ b ≤ Y ^ b := Real.rpow_le_rpow hy0.le hy.2 hb.le
    have hQ : 0 ≤ y ^ (-(a + b) - 1) := Real.rpow_nonneg hy0.le _
    calc Real.log y ^ k * y ^ (-a - 1)
        = y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) := by rw [e]; ring
      _ ≤ Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) :=
          mul_le_mul_of_nonneg_right hyb (mul_nonneg hLk hQ)
  have hgnn : 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))]
      fun y : ℝ => Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) := by
    filter_upwards [kernel_nonneg (a + b) k] with y hy
    exact mul_nonneg (Real.rpow_nonneg (by linarith) _) hy
  calc ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1)
      ≤ ∫ y in Ioc (1 : ℝ) Y, Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) :=
        setIntegral_mono_on hf hg measurableSet_Ioc hpt
    _ ≤ ∫ y in Ioi (1 : ℝ), Y ^ b * (Real.log y ^ k * y ^ (-(a + b) - 1)) :=
        setIntegral_mono_set hgI hgnn (LE.le.eventuallyLE Ioc_subset_Ioi_self)
    _ = Y ^ b * (k.factorial / (a + b) ^ (k + 1)) := by
        rw [integral_const_mul, LandauKernel.log_pow_integral hab k]

/-- For `0 < b < a` and `Z ≥ 1`, the integral of the kernel `(log y)^k·y^(−a−1)`
over `(Z, ∞)` is at most `Z^(−b) · k!/(a−b)^(k+1)`. -/
theorem upper_tail_le {a b : ℝ} (hb : 0 < b) (hba : b < a) (k : ℕ) {Z : ℝ} (hZ : 1 ≤ Z) :
    ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1)
      ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) := by
  have ha : 0 < a := by linarith
  have hab : 0 < a - b := by linarith
  have hZ0 : 0 < Z := by linarith
  have hsub : Ioi Z ⊆ Ioi (1 : ℝ) := Ioi_subset_Ioi hZ
  have hf : IntegrableOn (fun y : ℝ => Real.log y ^ k * y ^ (-a - 1)) (Ioi Z) :=
    (LandauKernel.log_pow_integrable ha k).mono_set hsub
  have hgI : IntegrableOn
      (fun y : ℝ => Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1))) (Ioi 1) :=
    (LandauKernel.log_pow_integrable hab k).const_mul _
  have hg : IntegrableOn
      (fun y : ℝ => Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1))) (Ioi Z) :=
    hgI.mono_set hsub
  have hpt : ∀ y ∈ Ioi Z,
      Real.log y ^ k * y ^ (-a - 1) ≤ Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) := by
    intro y hy
    have hZy : Z < y := mem_Ioi.mp hy
    have hy0 : 0 < y := by linarith
    have hy1 : 1 ≤ y := by linarith
    have hLk : 0 ≤ Real.log y ^ k := pow_nonneg (Real.log_nonneg hy1) k
    have e : y ^ (-a - 1) = y ^ (-b) * y ^ (-(a - b) - 1) := by
      rw [← Real.rpow_add hy0]; congr 1; ring
    have hyb : y ^ (-b) ≤ Z ^ (-b) := by
      rw [Real.rpow_neg hy0.le, Real.rpow_neg hZ0.le]
      exact inv_anti₀ (Real.rpow_pos_of_pos hZ0 b) (Real.rpow_le_rpow hZ0.le hZy.le hb.le)
    have hQ : 0 ≤ y ^ (-(a - b) - 1) := Real.rpow_nonneg hy0.le _
    calc Real.log y ^ k * y ^ (-a - 1)
        = y ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) := by rw [e]; ring
      _ ≤ Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) :=
          mul_le_mul_of_nonneg_right hyb (mul_nonneg hLk hQ)
  have hgnn : 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))]
      fun y : ℝ => Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) := by
    filter_upwards [kernel_nonneg (a - b) k] with y hy
    exact mul_nonneg (Real.rpow_nonneg hZ0.le _) hy
  calc ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1)
      ≤ ∫ y in Ioi Z, Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) :=
        setIntegral_mono_on hf hg measurableSet_Ioi hpt
    _ ≤ ∫ y in Ioi (1 : ℝ), Z ^ (-b) * (Real.log y ^ k * y ^ (-(a - b) - 1)) :=
        setIntegral_mono_set hgI hgnn (LE.le.eventuallyLE hsub)
    _ = Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) := by
        rw [integral_const_mul, LandauKernel.log_pow_integral hab k]

/-- info: 'LandauTail.lower_tail_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms lower_tail_le

/-- info: 'LandauTail.upper_tail_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms upper_tail_le

end

end LandauTail
