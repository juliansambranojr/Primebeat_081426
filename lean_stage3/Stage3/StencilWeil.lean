/-
StencilWeil — block T4 of `lean_stage3/design/joints.md`. 2026-11-22.

The table's stencil inside Weil's form, and the restoring force read off a
mode of the table. In the variable `u = log x` one doubling is the shift by
`log 2`; `stencilTest d φ` is the depth-`d` stencil applied to a test function
`φ` along the doublings. It is again a test function, its transform is the
symbol to the depth times `φ`'s, and so each zero of ζ enters Weil's form on it
with weight the symbol at the zero times the symbol at its mirror point, to
the depth. On the line that weight is a square.

`restoringForce b ρ` is the imbalance between a mode of the table and its
mirror, in logarithms. It is `2·|Re ρ − 1/2|·log b`: zero exactly on the line,
proportional to the displacement, larger at larger `b`.

  stencilTest, restoringForce         the two definitions
  laplace_shift                       laplace (φ(· + a)) z = e^(za)·laplace φ z
  integrable_shift_term               IsTest L φ ⊢ φ(u + a)·e^(−zu) is integrable
  laplace_stencilTest                 IsTest L φ ⊢ laplace (stencilTest d φ) z
                                        = (1 − 2^z)^d · laplace φ z
  stencilTest_zero_outside            the stencil vanishes off its window
  isTest_stencilTest                  IsTest L φ ⊢ IsTest (L + 2·(d·log 2)) (stencilTest d φ)
  zeroForm_stencilTest                the form on the stencil, zero by zero
  mirror_symbol_on_line               ρ.re = 1/2 ⊢ the symbol pair is ‖1 − 2^(−ρ)‖²
  restoringForce_eq                   1 < b ⊢ restoringForce b ρ = 2·|ρ.re − 1/2|·log b
  restoringForce_eq_zero_iff          1 < b ⊢ restoringForce b ρ = 0 ↔ ρ.re = 1/2
  handshake_iff                       1 < b ⊢ ‖b^ρ‖ = ‖b^(1−ρ)‖ ↔ ρ.re = 1/2
  restoringForce_mono                 1 < b ≤ c ⊢ restoringForce b ρ ≤ restoringForce c ρ
  zeroForm_stencilTest_eq_primeSide   StmtWeilBridge ⊢ the form on the stencil is its prime side
  zeroForm_stencilTest_nonneg_of_RH   RH ⊢ the form on the stencil is nonnegative

What the next slice needs: positivity of the form on the stencil without RH,
or a zero off the line making it negative; neither is here.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.WeilBridgeLeaf

namespace StencilWeil

open Complex Set MeasureTheory WeilDetect Finset

noncomputable section

/-- The depth-`d` stencil applied to a test function along the doublings, in
the variable `u = log x`. -/
def stencilTest (d : ℕ) (φ : ℝ → ℂ) : ℝ → ℂ := fun u =>
  ∑ k ∈ range (d + 1), ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ) * φ (u + k * Real.log 2)

/-- The imbalance between a mode of the table and its mirror, in logarithms. -/
def restoringForce (b : ℝ) (ρ : ℂ) : ℝ :=
  |Real.log ‖(b : ℂ) ^ ρ‖ - Real.log ‖(b : ℂ) ^ (1 - ρ)‖|

/-- Shifting a function multiplies its transform by an exponential. -/
theorem laplace_shift (φ : ℝ → ℂ) (a : ℝ) (z : ℂ) :
    laplace (fun u => φ (u + a)) z = Complex.exp (z * (a : ℂ)) * laplace φ z := by
  obtain ⟨F, hF⟩ : ∃ F : ℝ → ℂ,
      F = fun v : ℝ => Complex.exp (z * (a : ℂ)) * (φ v * Complex.exp (-(z * (v : ℂ)))) := ⟨_, rfl⟩
  have hf : ∀ u : ℝ, φ (u + a) * Complex.exp (-(z * (u : ℂ))) = F (u + a) := by
    intro u
    rw [hF]
    simp only []
    have e : Complex.exp (-(z * (u : ℂ)))
        = Complex.exp (z * (a : ℂ)) * Complex.exp (-(z * ((u + a : ℝ) : ℂ))) := by
      rw [← Complex.exp_add]
      congr 1
      push_cast
      ring
    rw [e]
    ring
  unfold laplace
  calc ∫ u : ℝ, φ (u + a) * Complex.exp (-(z * (u : ℂ)))
      = ∫ u : ℝ, F (u + a) := integral_congr_ae (Filter.Eventually.of_forall hf)
    _ = ∫ v : ℝ, F v := integral_add_right_eq_self F a
    _ = Complex.exp (z * (a : ℂ)) * ∫ v : ℝ, φ v * Complex.exp (-(z * (v : ℂ))) := by
        rw [hF, integral_const_mul]

/-- A shifted test function against the transform's kernel is integrable. -/
theorem integrable_shift_term {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (a : ℝ) (z : ℂ) :
    Integrable (fun u : ℝ => φ (u + a) * Complex.exp (-(z * (u : ℂ)))) := by
  have h1 : Continuous φ := hφ.2.1.continuous
  have hc : Continuous fun u : ℝ => φ (u + a) * Complex.exp (-(z * (u : ℂ))) :=
    (h1.comp (continuous_id.add continuous_const)).mul
      (Complex.continuous_exp.comp (continuous_const.mul Complex.continuous_ofReal).neg)
  have hs1 : HasCompactSupport (fun u : ℝ => φ (u + a)) :=
    hφ.2.2.1.comp_homeomorph (Homeomorph.addRight a)
  exact hc.integrable_of_hasCompactSupport hs1.mul_right

/-- **The stencil's transform is the symbol to the depth.** -/
theorem laplace_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) (z : ℂ) :
    laplace (stencilTest d φ) z = (1 - (2 : ℂ) ^ z) ^ d * laplace φ z := by
  have hlog : Complex.log 2 = ((Real.log 2 : ℝ) : ℂ) := by
    rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num, Complex.ofReal_log (by norm_num)]
  have h2 : ∀ k : ℕ, Complex.exp (z * (((k : ℝ) * Real.log 2 : ℝ) : ℂ)) = ((2 : ℂ) ^ z) ^ k := by
    intro k
    rw [Complex.cpow_def_of_ne_zero (by norm_num : (2 : ℂ) ≠ 0), ← Complex.exp_nat_mul, hlog]
    congr 1
    push_cast
    ring
  have hsum : ∀ u : ℝ, stencilTest d φ u * Complex.exp (-(z * (u : ℂ)))
      = ∑ k ∈ range (d + 1), ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ)
          * (φ (u + k * Real.log 2) * Complex.exp (-(z * (u : ℂ)))) := by
    intro u
    unfold stencilTest
    rw [Finset.sum_mul]
    exact Finset.sum_congr rfl fun k _ => by ring
  have hk : ∀ k : ℕ, (∫ u : ℝ, ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ)
        * (φ (u + k * Real.log 2) * Complex.exp (-(z * (u : ℂ)))))
      = ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ) * (((2 : ℂ) ^ z) ^ k * laplace φ z) := by
    intro k
    rw [integral_const_mul]
    have h := laplace_shift φ ((k : ℝ) * Real.log 2) z
    unfold laplace at h
    rw [h, h2 k]
    rfl
  calc laplace (stencilTest d φ) z
      = ∫ u : ℝ, ∑ k ∈ range (d + 1), ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ)
          * (φ (u + k * Real.log 2) * Complex.exp (-(z * (u : ℂ)))) := by
        unfold laplace
        exact integral_congr_ae (Filter.Eventually.of_forall hsum)
    _ = ∑ k ∈ range (d + 1), ∫ u : ℝ, ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ)
          * (φ (u + k * Real.log 2) * Complex.exp (-(z * (u : ℂ)))) :=
        integral_finsetSum _ fun k _ => (integrable_shift_term hφ _ z).const_mul _
    _ = ∑ k ∈ range (d + 1), ((((-1 : ℝ) ^ k * (d.choose k : ℝ) : ℝ)) : ℂ)
          * (((2 : ℂ) ^ z) ^ k * laplace φ z) := Finset.sum_congr rfl fun k _ => hk k
    _ = (1 - (2 : ℂ) ^ z) ^ d * laplace φ z := by
        rw [show (1 : ℂ) - (2 : ℂ) ^ z = -(2 : ℂ) ^ z + 1 by ring, add_pow, Finset.sum_mul]
        refine Finset.sum_congr rfl fun k _ => ?_
        rw [one_pow, mul_one, neg_pow]
        push_cast
        ring

/-- The stencil of a test function vanishes off the widened window. -/
theorem stencilTest_zero_outside {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) {u : ℝ}
    (hu : u ∉ Set.Icc (-(L + 2 * (d * Real.log 2)) / 2) ((L + 2 * (d * Real.log 2)) / 2)) :
    stencilTest d φ u = 0 := by
  have hlog : 0 ≤ Real.log 2 := Real.log_nonneg (by norm_num)
  unfold stencilTest
  refine Finset.sum_eq_zero fun k hk => ?_
  have hkd : (k : ℝ) ≤ d := by
    exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hk)
  have hk0 : (0 : ℝ) ≤ k := Nat.cast_nonneg k
  have hkl : (k : ℝ) * Real.log 2 ≤ d * Real.log 2 := mul_le_mul_of_nonneg_right hkd hlog
  have hkl0 : 0 ≤ (k : ℝ) * Real.log 2 := mul_nonneg hk0 hlog
  have hout : u + k * Real.log 2 ∉ tsupport φ := by
    intro hin
    have hI := hφ.2.2.2 hin
    apply hu
    constructor
    · linarith [hI.1]
    · linarith [hI.2]
  rw [image_eq_zero_of_notMem_tsupport hout, mul_zero]

/-- **The stencil of a test function is a test function**, on a window wider by
the stencil's reach. -/
theorem isTest_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    IsTest (L + 2 * (d * Real.log 2)) (stencilTest d φ) := by
  refine ⟨fun u => ?_, ?_, ?_, ?_⟩
  · unfold stencilTest
    rw [Complex.im_sum]
    refine Finset.sum_eq_zero fun k _ => ?_
    rw [Complex.im_ofReal_mul, hφ.1, mul_zero]
  · unfold stencilTest
    exact ContDiff.sum fun k _ =>
      contDiff_const.mul (hφ.2.1.comp (contDiff_id.add contDiff_const))
  · exact HasCompactSupport.intro isCompact_Icc fun u hu => stencilTest_zero_outside hφ d hu
  · refine closure_minimal ?_ isClosed_Icc
    exact Function.support_subset_iff'.mpr fun u hu => stencilTest_zero_outside hφ d hu

/-- **Weil's form on the stencil, zero by zero.** Each zero enters with the
symbol at the zero times the symbol at its mirror point, to the depth. -/
theorem zeroForm_stencilTest {L : ℝ} {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    zeroForm (stencilTest d φ)
      = riemannZeta.zeroes_sum (Set.Ioo 0 1) (Set.univ : Set ℝ)
          (fun ρ => ((1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ)))) ^ d
            * (laplace φ (-ρ) * laplace φ (-(1 - ρ)))) := by
  unfold zeroForm
  congr 1
  funext ρ
  rw [laplace_stencilTest hφ, laplace_stencilTest hφ, mul_pow]
  ring

/-- **On the line the handshake holds.** The symbol at a zero times the symbol
at its mirror point is the square of the symbol's size. -/
theorem mirror_symbol_on_line {ρ : ℂ} (h : ρ.re = 1 / 2) :
    (1 - (2 : ℂ) ^ (-ρ)) * (1 - (2 : ℂ) ^ (-(1 - ρ)))
      = ((‖1 - (2 : ℂ) ^ (-ρ)‖ ^ 2 : ℝ) : ℂ) := by
  have hconj : -(1 - ρ) = (starRingEnd ℂ) (-ρ) := by
    apply Complex.ext
    · simp [h]; norm_num
    · simp
  have harg : (2 : ℂ).arg ≠ Real.pi := by
    rw [show (2 : ℂ) = ((2 : ℝ) : ℂ) by norm_num, Complex.arg_ofReal_of_nonneg (by norm_num)]
    exact Real.pi_ne_zero.symm
  have hc : (2 : ℂ) ^ ((starRingEnd ℂ) (-ρ)) = (starRingEnd ℂ) ((2 : ℂ) ^ (-ρ)) := by
    rw [Complex.cpow_conj _ _ harg, map_ofNat]
  have e : (1 : ℂ) - (starRingEnd ℂ) ((2 : ℂ) ^ (-ρ)) = (starRingEnd ℂ) (1 - (2 : ℂ) ^ (-ρ)) := by
    simp
  rw [hconj, hc, e, Complex.mul_conj, Complex.normSq_eq_norm_sq]

/-- **The restoring force, in closed form**: twice the displacement from one
half, times the logarithm of the base. -/
theorem restoringForce_eq {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    restoringForce b ρ = 2 * |ρ.re - 1 / 2| * Real.log b := by
  have hb0 : 0 < b := by linarith
  have hlb : 0 < Real.log b := Real.log_pos hb
  unfold restoringForce
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb0, Complex.norm_cpow_eq_rpow_re_of_pos hb0,
    Real.log_rpow hb0, Real.log_rpow hb0]
  have e : ρ.re * Real.log b - (1 - ρ).re * Real.log b = 2 * (ρ.re - 1 / 2) * Real.log b := by
    simp only [Complex.sub_re, Complex.one_re]
    ring
  rw [e, abs_mul, abs_mul, abs_of_pos hlb]
  norm_num

/-- **The force is zero exactly on the line.** -/
theorem restoringForce_eq_zero_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    restoringForce b ρ = 0 ↔ ρ.re = 1 / 2 := by
  have hlb : 0 < Real.log b := Real.log_pos hb
  rw [restoringForce_eq hb]
  constructor
  · intro h
    have h1 : |ρ.re - 1 / 2| = 0 := by
      rcases mul_eq_zero.mp h with h' | h'
      · linarith
      · exact absurd h' hlb.ne'
    linarith [abs_eq_zero.mp h1]
  · intro h
    rw [h]
    simp

/-- **The handshake.** A mode of the table and its mirror have the same size
exactly when the zero is on the line. -/
theorem handshake_iff {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    ‖(b : ℂ) ^ ρ‖ = ‖(b : ℂ) ^ (1 - ρ)‖ ↔ ρ.re = 1 / 2 := by
  have hb0 : 0 < b := by linarith
  rw [← restoringForce_eq_zero_iff hb]
  constructor
  · intro h
    unfold restoringForce
    rw [h, sub_self, abs_zero]
  · intro h
    have hre := (restoringForce_eq_zero_iff hb ρ).mp h
    rw [Complex.norm_cpow_eq_rpow_re_of_pos hb0, Complex.norm_cpow_eq_rpow_re_of_pos hb0]
    congr 1
    simp only [Complex.sub_re, Complex.one_re]
    linarith

/-- **Stiffer further out.** At a larger base the same displacement gives a
larger force. -/
theorem restoringForce_mono {b c : ℝ} (hb : 1 < b) (hbc : b ≤ c) (ρ : ℂ) :
    restoringForce b ρ ≤ restoringForce c ρ := by
  rw [restoringForce_eq hb, restoringForce_eq (lt_of_lt_of_le hb hbc)]
  exact mul_le_mul_of_nonneg_left (Real.log_le_log (by linarith) hbc)
    (mul_nonneg (by norm_num) (abs_nonneg _))

/-- **The form on the stencil is its prime side**, given the bridge. -/
theorem zeroForm_stencilTest_eq_primeSide (h : WeilBridgeLeaf.StmtWeilBridge) {L : ℝ}
    {φ : ℝ → ℂ} (hφ : IsTest L φ) (d : ℕ) :
    zeroForm (stencilTest d φ)
      = WeilBridgeLeaf.primeSideM (WeilBridgeLeaf.kOfM (stencilTest d φ)) :=
  WeilBridgeLeaf.zeroForm_eq_primeSide h (isTest_stencilTest hφ d)

/-- Under the Riemann hypothesis the form on the stencil is nonnegative. -/
theorem zeroForm_stencilTest_nonneg_of_RH (hRH : RiemannHypothesis) {L : ℝ} {φ : ℝ → ℂ}
    (hφ : IsTest L φ) (d : ℕ) : 0 ≤ (zeroForm (stencilTest d φ)).re :=
  zeroForm_nonneg_of_RH hRH (isTest_stencilTest hφ d).1

/-- info: 'StencilWeil.laplace_stencilTest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms laplace_stencilTest

/-- info: 'StencilWeil.isTest_stencilTest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isTest_stencilTest

/-- info: 'StencilWeil.zeroForm_stencilTest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroForm_stencilTest

/-- info: 'StencilWeil.mirror_symbol_on_line' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mirror_symbol_on_line

/-- info: 'StencilWeil.restoringForce_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms restoringForce_eq

/-- info: 'StencilWeil.handshake_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms handshake_iff

/-- info: 'StencilWeil.zeroForm_stencilTest_eq_primeSide' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroForm_stencilTest_eq_primeSide

end

end StencilWeil
