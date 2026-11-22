/-
WeilBridge — the bridge to primes: the zero side of Weil's form at a test
function of Stage 3's class equals the prime side, proved against zeta23's
explicit formula. The third tree, `lean_bridge/`. 2026-11-22. The statement
is unit 0379's; the choice of a third tree is Julian's of the same day.

Stage 3 (`lean_stage3/Stage3/WeilDetect.lean`, Lean v4.32.2 with
PrimeNumberTheoremAnd) has `laplace G z = ∫ G(u) e^{−zu} du` and a zero form
whose term at a zero `ρ` is `laplace G (−ρ) · laplace G (−(1 − ρ))`. It has
no prime side: the explicit formula it would need is upstream with two
sorries. zeta23 (`anthropics/formal-math`, Lean v4.33.0-rc2, Mathlib only)
proves Weil's explicit formula with nothing left open,
`Zeta23.WeilEF.EF_lit_zetaZeroConfig`. This tree is on zeta23's toolchain,
requires it at a pinned commit, and proves the join in the kernel.

The dictionary. For `G` put `F(u) = G(u)·e^{u/2}` (`tiltF`) and
`k = F ⋆ F̃` (`kOf`, zeta23's `weilTest`), `F̃(u) = conj F(−u)`. Then

  laplace G (−ρ)       = paperFT F (gammaOf ρ)            laplace_neg_eq
  laplace G (−(1 − ρ)) = paperFT F (−gammaOf ρ)           laplace_reflect_eq
  conj (paperFT F (conj z)) = paperFT F (−z), F real      conj_paperFT_conj
  paperFT k (gammaOf ρ) = laplace G (−ρ)·laplace G (−(1−ρ))   paperFT_kOf

`IsTest` asks `ContDiff ℝ 1`; zeta23's formula asks `ContDiff ℝ 2` of `k`.
The convolution of two compactly supported `C¹` functions is `C²`
(`contDiff_two_convolution`), so no hypothesis is added.

  weil_bridge   IsTest L G →
      the zero side is summable, and
      Σ_ρ mult(ρ) · laplace G (−ρ) · laplace G (−(1 − ρ)) = primeSide (kOf G)

over the nontrivial zeros of Mathlib's `riemannZeta`, with multiplicity
`(analyticOrderAt riemannZeta ρ).toNat`. `primeSide k` is zeta23's
`literatureRHS k` written out: the pole terms, minus
`Σ Λ(n)/√n·(k(log n) + k(−log n))`, plus the archimedean integral.

`laplace` and `IsTest` are copied from Stage 3 character for character and
gated by `utilities/check_weld.py`. What Stage 3 still owes to use this: the
lemma that upstream's `riemannZeta.zeroes_sum` with `riemannZeta.order` is
the sum over this zero set with this multiplicity.

Axioms: every theorem pins to [propext, Classical.choice, Quot.sound].
-/
import Zeta23.WeilEF.Main

namespace Bridge

noncomputable section

open MeasureTheory Complex Set Zeta23 Zeta23.EF
open scoped Real Convolution ComplexConjugate ArithmeticFunction

/-- The two-sided Laplace transform. Copied from `Stage3/WeilDetect.lean`. -/
noncomputable def laplace (G : ℝ → ℂ) (z : ℂ) : ℂ :=
  ∫ u : ℝ, G u * Complex.exp (-(z * (u : ℂ)))

/-- The test-function class at support `L`. Copied from `Stage3/WeilDetect.lean`. -/
def IsTest (L : ℝ) (G : ℝ → ℂ) : Prop :=
  (∀ u, (G u).im = 0) ∧ ContDiff ℝ 1 G ∧ HasCompactSupport G ∧
    tsupport G ⊆ Set.Icc (-L / 2) (L / 2)

/-- `F(u) = G(u)·e^{u/2}`: the test function in zeta23's centred variable. -/
def tiltF (G : ℝ → ℂ) : ℝ → ℂ := fun u => G u * ((Real.exp (u / 2) : ℝ) : ℂ)

/-- `k = F ⋆ F̃`, the Weil test function of `G`. -/
def kOf (G : ℝ → ℂ) : ℝ → ℂ := weilTest (tiltF G) (tiltF G)

/-- zeta23's `literatureRHS`, written out. -/
def primeSide (k : ℝ → ℂ) : ℂ :=
  paperFT k (I / 2) + paperFT k (-I / 2)
  - ∑' n : ℕ, ((ArithmeticFunction.vonMangoldt n / Real.sqrt n : ℝ) : ℂ)
      * (k (Real.log n) + k (-Real.log n))
  + (1 / (2 * π) : ℂ) * ∫ r : ℝ, paperFT k r
      * (((Complex.digamma (1 / 4 + I * r / 2)).re - Real.log π : ℝ) : ℂ)

theorem primeSide_eq (k : ℝ → ℂ) : primeSide k = literatureRHS k := rfl

theorem tiltF_im {G : ℝ → ℂ} (hG : ∀ u, (G u).im = 0) (u : ℝ) : (tiltF G u).im = 0 := by
  unfold tiltF
  rw [Complex.mul_im, hG u, Complex.ofReal_im]
  ring

theorem contDiff_tiltF {G : ℝ → ℂ} (hG : ContDiff ℝ 1 G) : ContDiff ℝ 1 (tiltF G) := by
  unfold tiltF
  exact hG.mul (Complex.ofRealCLM.contDiff.comp
    (Real.contDiff_exp.comp (contDiff_id.div_const 2)))

theorem hasCompactSupport_tiltF {G : ℝ → ℂ} (hG : HasCompactSupport G) :
    HasCompactSupport (tiltF G) := by
  have h : tiltF G = G * fun u : ℝ => ((Real.exp (u / 2) : ℝ) : ℂ) := rfl
  rw [h]
  exact hG.mul_right

/-- The transform at `−ρ`, in zeta23's variable. -/
theorem laplace_neg_eq (G : ℝ → ℂ) (ρ : ℂ) :
    laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ) := by
  unfold laplace paperFT tiltF gammaOf
  refine integral_congr_ae (Filter.Eventually.of_forall fun u => ?_)
  simp only []
  have hI : (I : ℂ) ≠ 0 := Complex.I_ne_zero
  rw [Complex.ofReal_exp, mul_assoc, ← Complex.exp_add]
  congr 2
  push_cast
  field_simp
  ring

/-- The transform at `−(1 − ρ)`, in zeta23's variable. -/
theorem laplace_reflect_eq (G : ℝ → ℂ) (ρ : ℂ) :
    laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ) := by
  unfold laplace paperFT tiltF gammaOf
  refine integral_congr_ae (Filter.Eventually.of_forall fun u => ?_)
  simp only []
  have hI : (I : ℂ) ≠ 0 := Complex.I_ne_zero
  rw [Complex.ofReal_exp, mul_assoc, ← Complex.exp_add]
  congr 2
  push_cast
  field_simp
  ring

/-- For a real-valued `F`, the conjugate-reflected transform is the transform at `−z`. -/
theorem conj_paperFT_conj {F : ℝ → ℂ} (hF : ∀ u, (F u).im = 0) (z : ℂ) :
    conj (paperFT F (conj z)) = paperFT F (-z) := by
  rw [← paperFT_tilde]
  have ht : tilde F = fun u => F (-u) := by
    funext u
    unfold tilde
    exact Complex.conj_eq_iff_im.mpr (hF (-u))
  rw [ht]
  unfold paperFT
  rw [← integral_neg_eq_self]
  refine integral_congr_ae (Filter.Eventually.of_forall fun u => ?_)
  simp only [neg_neg]
  congr 2
  push_cast
  ring

/-- The convolution of two compactly supported `C¹` functions is `C²`. -/
theorem contDiff_two_convolution {f h : ℝ → ℂ} (hf : ContDiff ℝ 1 f) (hfs : HasCompactSupport f)
    (hh : ContDiff ℝ 1 h) (hhs : HasCompactSupport h) :
    ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) := by
  have hd : ∀ x : ℝ, HasDerivAt (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h)
      ((deriv f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) x) x := fun x =>
    hfs.hasDerivAt_convolution_left (ContinuousLinearMap.mul ℝ ℂ) hf
      hh.continuous.locallyIntegrable x
  have hderiv : deriv (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h)
      = deriv f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h := funext fun x => (hd x).deriv
  have hcd : Continuous (deriv f) := (contDiff_one_iff_deriv.mp hf).2
  have hc1 : ContDiff ℝ 1 (deriv f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) := by
    have := hhs.contDiff_convolution_right (n := 1) (ContinuousLinearMap.mul ℝ ℂ) (μ := volume)
      hcd.locallyIntegrable (by exact_mod_cast hh)
    exact_mod_cast this
  rw [show (2 : WithTop ℕ∞) = 1 + 1 from one_add_one_eq_two.symm, contDiff_succ_iff_deriv]
  refine ⟨fun x => (hd x).differentiableAt, ?_, ?_⟩
  · intro h1
    exact absurd h1 (by decide)
  · rw [hderiv]
    exact hc1

theorem contDiff_tilde {g : ℝ → ℂ} (hg : ContDiff ℝ 1 g) : ContDiff ℝ 1 (tilde g) := by
  unfold tilde
  exact Complex.conjCLE.contDiff.comp (hg.comp contDiff_neg)

theorem contDiff_kOf {G : ℝ → ℂ} (hG : ContDiff ℝ 1 G) (hGs : HasCompactSupport G) :
    ContDiff ℝ 2 (kOf G) := by
  unfold kOf weilTest
  exact contDiff_two_convolution (contDiff_tiltF hG) (hasCompactSupport_tiltF hGs)
    (contDiff_tilde (contDiff_tiltF hG)) (hasCompactSupport_tilde (hasCompactSupport_tiltF hGs))

theorem hasCompactSupport_kOf {G : ℝ → ℂ} (hGs : HasCompactSupport G) :
    HasCompactSupport (kOf G) :=
  weilTest_hasCompactSupport (hasCompactSupport_tiltF hGs) (hasCompactSupport_tiltF hGs)

/-- **The term at a zero, in both languages.** -/
theorem paperFT_kOf {G : ℝ → ℂ} (hre : ∀ u, (G u).im = 0) (hG : ContDiff ℝ 1 G)
    (hGs : HasCompactSupport G) (ρ : ℂ) :
    paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ)) := by
  unfold kOf
  rw [paperFT_weilTest (contDiff_tiltF hG).continuous (contDiff_tiltF hG).continuous
      (hasCompactSupport_tiltF hGs) (hasCompactSupport_tiltF hGs),
    conj_paperFT_conj (tiltF_im hre), laplace_neg_eq, laplace_reflect_eq]

/-- **The bridge.** For a test function of Stage 3's class, the zero side of Weil's
form, over the nontrivial zeros of `riemannZeta` with multiplicity, is summable and
equals the prime side at `k = F ⋆ F̃`. -/
theorem weil_bridge {L : ℝ} {G : ℝ → ℂ} (hG : IsTest L G) :
    Summable (fun ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1} =>
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧
      ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 < ρ.re ∧ ρ.re < 1},
        (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ)
          * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))
        = primeSide (kOf G) := by
  obtain ⟨hre, hC1, hGs, -⟩ := hG
  have hEF := Zeta23.WeilEF.EF_lit_zetaZeroConfig (kOf G) (contDiff_kOf hC1 hGs)
    (hasCompactSupport_kOf hGs)
  have hterm : ∀ ρ : ℂ, paperFT (kOf G) (gammaOf ρ)
      = laplace G (-ρ) * laplace G (-(1 - ρ)) := paperFT_kOf hre hC1 hGs
  simp only [hterm] at hEF
  rw [primeSide_eq]
  exact hEF

end

/-- info: 'Bridge.conj_paperFT_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms conj_paperFT_conj

/-- info: 'Bridge.contDiff_two_convolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms contDiff_two_convolution

/-- info: 'Bridge.paperFT_kOf' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms paperFT_kOf

/-- info: 'Bridge.weil_bridge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms weil_bridge

end Bridge
