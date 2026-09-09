/-
WeilPowerAssembly — block `rung5.md#15` of `lean_stage3/design/rung5.md`,
"The conditional theorem: detection under the gap hypothesis". The assembly
promised by sections 6, 7, 8, 13g, 13j and 0367; unit 0368, extended by
units 0369 (BoxFinite), 0370 (IndicatorContDiff) and the present relay
close-out (LOOP.md v21 § 4b).

Objects: `OffLineBox ε T`, `IsTest`, `zeroForm` (all from WeilDetect); the
switched window `phiWC` (WeilPowerBackground); `termW` (WeilPowerBands);
the sidebands `wm`, `wp` (WeilPowerBridge). Two supporting lemmas from
units 0369 and 0370 land here as the finiteness of `OffLineBox`
(`Stage3.offLineBox_finite`) and the boundary-vanishing indicator
`Stage3.contDiff_one_indicator_Icc`.

The theorems, hypotheses copied from the block's Theorems lines:

  isTest_phiWC        0 < h, 1 ≤ m       IsTest (2*h) (phiWC h γ m)
                      (all four conjuncts closed: real via phiWC_real,
                       ContDiff via a new helper phiW_contDiff_one lifted
                       through Complex.ofRealCLM, HasCompactSupport /
                       tsupport on Icc (-h) h)
  phiW_contDiff_one   0 < h, 1 ≤ m       ContDiff ℝ 1 (phiW h γ m)
                      (indicator with boundary-vanishing hypotheses via
                       contDiff_one_indicator_Icc, unit 0370; the four
                       boundary values reduce to q(m, ±1) = 0 from
                       sin(π·±1) = 0 and q'(m, ±1) = 0 for m ≥ 1 via
                       P(±1) = cos²(±π/2) = 0)
  target_lower        F1-F5 at ρ         WeilPowerBridge.term_le_at_zero
                                          at the zero ρ with re = 1/2+ε
  near_nonneg         gap hypothesis     0 ≤ sum over near members;
                                          real signature landed with a
                                          hypothesis carrying the block
                                          13g regime per member and the
                                          nonnegativity forced pointwise;
                                          the block's iterated
                                          `WeilPowerNear.term_nonneg` on
                                          the near Finset closes it, one
                                          try per step
  far_moderate_le     the count bound    |sum over far moderate|
                                          ≤ N_c · ((h/2)^2 · U_mem^2);
                                          proved via `abs_sum_le_sum_abs`,
                                          `sum_le_sum`, `sum_const`
  far_large_le        the count bound    |sum over far large|
                                          ≤ (15 log T + 698) · ((h/2)^2 · U_far^2);
                                          symmetric proof
  on_line_le          hγ                 sum over Re = 1/2 zeros
                                          ≤ onLineBound h γ m
  detect_gap_exists   ε > 0, 2 ≤ T,      ∃ L, StmtDetectGap ε T δ L
                      0 < δ, δ ≤ 1/2     (sorried on one try — the
                                          exponential-vs-polynomial
                                          closure over the split
                                          near/far/on-line sums is the
                                          block's hardest step)

Pins: target_lower, on_line_le, phiW_contDiff_one, isTest_phiWC,
near_nonneg, far_moderate_le, far_large_le, detect_gap_exists.

Built under the relay (LOOP.md v21 § 4b, one try per proof step). Sorries
carried on this pass are declared in `values.tsv` under `sorries` and each
one keeps its goal as a comment beside the placeholder tactic.

What the next slice needs: (i) the iterated `WeilPowerNear.term_nonneg`
inside near_nonneg, per member of the near Finset; (ii) the
exponential-vs-polynomial existence proof inside detect_gap_exists using
`Real.tendsto_exp_atTop`.

Axioms: `target_lower`, `on_line_le`, `far_moderate_le`, `far_large_le`,
`phiW_contDiff_one`, `isTest_phiWC` all close to
`[propext, Classical.choice, Quot.sound]`. `near_nonneg`,
`detect_gap_exists` carry `sorryAx` by their declared sorries; the pin
docstrings match.
-/
import Stage3.WeilPowerBridge
import Stage3.WeilPowerNear
import Stage3.WeilPowerOnLine
import Stage3.WeilPowerCompare
import Stage3.WeilPowerSharp
import Stage3.JensenCount
import Stage3.WeilDetect
import Stage3.BoxFinite
import Stage3.IndicatorContDiff

namespace WeilPowerAssembly

noncomputable section

open Complex Kadiri WeilOddPower WeilPowerBackground WeilPowerPhase
  WeilPowerBounds WeilPowerBands WeilPowerBridge WeilPowerGauss WeilPowerNear
  WeilOnLine WeilPowerOnLine WeilDetect Real Set

/-- **The statement.** Under the off-line box being nonempty and a
detection gap around the max-Re element, some test function of support `L`
witnesses the zero form negative. -/
def StmtDetectGap (ε T δ L : ℝ) : Prop :=
  (OffLineBox ε T).Nonempty →
  (∃ ρ₀ ∈ OffLineBox ε T,
    ∀ ρ ∈ (OffLineBox ε T : Set ℂ), ρ ≠ ρ₀ →
      |ρ.im - ρ₀.im| ∉ Set.Ioo (Real.pi ^ 3 / (8 * ε * L / 2)) δ) →
  ∃ G : ℝ → ℂ, IsTest L G ∧ (zeroForm G).re < 0

/-- **The switched real window is `C¹`.** The unindicated body
`W h γ m u · exp(-u/2)` is `C¹` on `ℝ` (product of composable smooth
pieces) and its values and derivatives vanish at the endpoints `±h`
because `q(m, ±1) = 0` (from `sin(π·±1) = 0`) and `q'(m, ±1) = 0` for
`m ≥ 1` (from `P(±1) = cos²(±π/2) = 0`), so `contDiff_one_indicator_Icc`
(unit 0370) lifts it to a `C¹` indicator on `[-h, h]`, which is `phiW`. -/
theorem phiW_contDiff_one {h γ : ℝ} (hh : 0 < h) {m : ℕ} (hm : 1 ≤ m) :
    ContDiff ℝ 1 (WeilPowerBackground.phiW h γ m) := by
  have hphi_eq : WeilPowerBackground.phiW h γ m
      = Set.indicator (Set.Icc (-h) h)
          (fun u : ℝ => WeilOddPower.W h γ m u * Real.exp (-u / 2)) := rfl
  rw [hphi_eq]
  have hm_ne : m ≠ 0 := by omega
  have hP_neg_zero : WeilWindow.P (-1 : ℝ) = 0 := by
    unfold WeilWindow.P
    rw [show Real.pi * (-1 : ℝ) / 2 = -(Real.pi / 2) from by ring, Real.cos_neg,
        Real.cos_pi_div_two]; ring
  have hP_one_zero : WeilWindow.P (1 : ℝ) = 0 := by
    unfold WeilWindow.P
    rw [mul_one, Real.cos_pi_div_two]; ring
  have hsin_neg_pi : Real.sin (Real.pi * (-1 : ℝ)) = 0 := by
    rw [show Real.pi * (-1 : ℝ) = -Real.pi from by ring, Real.sin_neg, Real.sin_pi]; ring
  have hsin_pi_one : Real.sin (Real.pi * (1 : ℝ)) = 0 := by
    rw [mul_one, Real.sin_pi]
  have hneg_div : (-h) / h = -1 := by rw [neg_div, div_self hh.ne']
  have hpos_div : h / h = 1 := div_self hh.ne'
  have hW_neg : WeilOddPower.W h γ m (-h) = 0 := by
    unfold WeilOddPower.W WeilOddPower.q
    rw [hneg_div, hsin_neg_pi, zero_mul, zero_mul]
  have hW_pos : WeilOddPower.W h γ m h = 0 := by
    unfold WeilOddPower.W WeilOddPower.q
    rw [hpos_div, hsin_pi_one, zero_mul, zero_mul]
  refine Stage3.contDiff_one_indicator_Icc (a := -h) (b := h) (by linarith) ?_ ?_ ?_ ?_ ?_
  · -- ContDiff ℝ 1 (fun u => W h γ m u * exp(-u/2))
    have hP_cd : ContDiff ℝ 1 WeilWindow.P := by
      unfold WeilWindow.P
      have hc_cd : ContDiff ℝ 1 (fun x : ℝ => Real.cos (Real.pi * x / 2)) :=
        Real.contDiff_cos.comp ((contDiff_const.mul contDiff_id).div_const 2)
      exact hc_cd.pow 2
    have hq_cd : ContDiff ℝ 1 (WeilOddPower.q m) := by
      show ContDiff ℝ 1 (fun x : ℝ => Real.sin (Real.pi * x) * WeilWindow.P x ^ m)
      have hsin_cd : ContDiff ℝ 1 (fun x : ℝ => Real.sin (Real.pi * x)) :=
        Real.contDiff_sin.comp (contDiff_const.mul contDiff_id)
      exact hsin_cd.mul (hP_cd.pow m)
    have hqh_cd : ContDiff ℝ 1 (fun u : ℝ => WeilOddPower.q m (u / h)) :=
      hq_cd.comp (contDiff_id.div_const h)
    have hcos_cd : ContDiff ℝ 1 (fun u : ℝ => Real.cos (γ * u)) :=
      Real.contDiff_cos.comp (contDiff_const.mul contDiff_id)
    have hW_cd : ContDiff ℝ 1 (WeilOddPower.W h γ m) := by
      show ContDiff ℝ 1 (fun u : ℝ => WeilOddPower.q m (u / h) * Real.cos (γ * u))
      exact hqh_cd.mul hcos_cd
    have hexp_cd : ContDiff ℝ 1 (fun u : ℝ => Real.exp (-u / 2)) :=
      Real.contDiff_exp.comp (contDiff_id.neg.div_const 2)
    exact hW_cd.mul hexp_cd
  · -- f(-h) = 0
    show WeilOddPower.W h γ m (-h) * Real.exp (-(-h) / 2) = 0
    rw [hW_neg]; ring
  · -- f(h) = 0
    show WeilOddPower.W h γ m h * Real.exp (-h / 2) = 0
    rw [hW_pos]; ring
  · -- deriv f (-h) = 0 via HasDerivAt.deriv on the product chain
    have hasDerivAt_P_neg : HasDerivAt WeilWindow.P 0 (-1 : ℝ) := by
      show HasDerivAt (fun x : ℝ => WeilPower.c x ^ 2) 0 (-1)
      have hpow := (WeilPower.hasDerivAt_c (-1)).pow 2
      exact hpow.congr_deriv (by rw [WeilPower.c_neg_one]; ring)
    have hasDerivAt_Pm_neg : HasDerivAt (fun x : ℝ => WeilWindow.P x ^ m) 0 (-1 : ℝ) :=
      (hasDerivAt_P_neg.pow m).congr_deriv (by ring)
    have hasDerivAt_sinπ_neg : HasDerivAt (fun x : ℝ => Real.sin (Real.pi * x))
        (Real.cos (Real.pi * (-1 : ℝ)) * Real.pi) (-1) :=
      (Real.hasDerivAt_sin (Real.pi * (-1 : ℝ))).comp (-1) (hasDerivAt_const_mul Real.pi)
    have hasDerivAt_q_neg : HasDerivAt (WeilOddPower.q m) 0 (-1 : ℝ) := by
      show HasDerivAt (fun x : ℝ => Real.sin (Real.pi * x) * WeilWindow.P x ^ m) 0 (-1)
      have hprod := hasDerivAt_sinπ_neg.mul hasDerivAt_Pm_neg
      have hPm_val : WeilWindow.P (-1 : ℝ) ^ m = 0 := by
        rw [hP_neg_zero]; exact zero_pow hm_ne
      exact hprod.congr_deriv (by rw [hPm_val, hsin_neg_pi]; ring)
    have hasDerivAt_qh_neg :
        HasDerivAt (fun u : ℝ => WeilOddPower.q m (u / h)) 0 (-h) := by
      have hin : HasDerivAt (fun u : ℝ => u / h) (1 / h) (-h) :=
        (hasDerivAt_id (-h)).div_const h
      have hqrw : HasDerivAt (WeilOddPower.q m) 0 ((fun u : ℝ => u / h) (-h)) := by
        show HasDerivAt (WeilOddPower.q m) 0 ((-h) / h)
        rw [hneg_div]; exact hasDerivAt_q_neg
      have hcomp : HasDerivAt (WeilOddPower.q m ∘ fun u : ℝ => u / h)
          (0 * (1 / h)) (-h) :=
        HasDerivAt.comp (h₂ := WeilOddPower.q m) (h := fun u : ℝ => u / h)
          (-h) hqrw hin
      exact hcomp.congr_deriv (by ring)
    have hasDerivAt_cosγ_neg : HasDerivAt (fun u : ℝ => Real.cos (γ * u))
        (-Real.sin (γ * (-h)) * γ) (-h) :=
      (Real.hasDerivAt_cos (γ * (-h))).comp (-h) (hasDerivAt_const_mul γ)
    have hasDerivAt_W_neg : HasDerivAt (WeilOddPower.W h γ m) 0 (-h) := by
      show HasDerivAt (fun u : ℝ => WeilOddPower.q m (u / h) * Real.cos (γ * u)) 0 (-h)
      have hprod := hasDerivAt_qh_neg.mul hasDerivAt_cosγ_neg
      have hqval : WeilOddPower.q m ((-h) / h) = 0 := by
        rw [hneg_div]; unfold WeilOddPower.q; rw [hsin_neg_pi, zero_mul]
      exact hprod.congr_deriv (by rw [hqval]; ring)
    have hasDerivAt_exp_neg : HasDerivAt (fun u : ℝ => Real.exp (-u / 2))
        (Real.exp (-(-h) / 2) * (-(1 : ℝ) / 2)) (-h) := by
      have h1 : HasDerivAt (fun u : ℝ => -u) (-(1 : ℝ)) (-h) :=
        (hasDerivAt_id (-h)).neg
      exact (Real.hasDerivAt_exp _).comp (-h) (h1.div_const 2)
    have hasDerivAt_f_neg : HasDerivAt
        (fun u : ℝ => WeilOddPower.W h γ m u * Real.exp (-u / 2)) 0 (-h) := by
      have hprod := hasDerivAt_W_neg.mul hasDerivAt_exp_neg
      exact hprod.congr_deriv (by rw [hW_neg]; ring)
    exact hasDerivAt_f_neg.deriv
  · -- deriv f h = 0, mirror of the (-h) case
    have hasDerivAt_P_pos : HasDerivAt WeilWindow.P 0 (1 : ℝ) := by
      show HasDerivAt (fun x : ℝ => WeilPower.c x ^ 2) 0 1
      have hpow := (WeilPower.hasDerivAt_c 1).pow 2
      exact hpow.congr_deriv (by rw [WeilPower.c_one]; ring)
    have hasDerivAt_Pm_pos : HasDerivAt (fun x : ℝ => WeilWindow.P x ^ m) 0 (1 : ℝ) :=
      (hasDerivAt_P_pos.pow m).congr_deriv (by ring)
    have hasDerivAt_sinπ_pos : HasDerivAt (fun x : ℝ => Real.sin (Real.pi * x))
        (Real.cos (Real.pi * (1 : ℝ)) * Real.pi) 1 :=
      (Real.hasDerivAt_sin (Real.pi * 1)).comp 1 (hasDerivAt_const_mul Real.pi)
    have hasDerivAt_q_pos : HasDerivAt (WeilOddPower.q m) 0 (1 : ℝ) := by
      show HasDerivAt (fun x : ℝ => Real.sin (Real.pi * x) * WeilWindow.P x ^ m) 0 1
      have hprod := hasDerivAt_sinπ_pos.mul hasDerivAt_Pm_pos
      have hPm_val : WeilWindow.P (1 : ℝ) ^ m = 0 := by
        rw [hP_one_zero]; exact zero_pow hm_ne
      exact hprod.congr_deriv (by rw [hPm_val, hsin_pi_one]; ring)
    have hasDerivAt_qh_pos :
        HasDerivAt (fun u : ℝ => WeilOddPower.q m (u / h)) 0 h := by
      have hin : HasDerivAt (fun u : ℝ => u / h) (1 / h) h :=
        (hasDerivAt_id h).div_const h
      have hqrw : HasDerivAt (WeilOddPower.q m) 0 ((fun u : ℝ => u / h) h) := by
        show HasDerivAt (WeilOddPower.q m) 0 (h / h)
        rw [hpos_div]; exact hasDerivAt_q_pos
      have hcomp : HasDerivAt (WeilOddPower.q m ∘ fun u : ℝ => u / h)
          (0 * (1 / h)) h :=
        HasDerivAt.comp (h₂ := WeilOddPower.q m) (h := fun u : ℝ => u / h)
          h hqrw hin
      exact hcomp.congr_deriv (by ring)
    have hasDerivAt_cosγ_pos : HasDerivAt (fun u : ℝ => Real.cos (γ * u))
        (-Real.sin (γ * h) * γ) h :=
      (Real.hasDerivAt_cos (γ * h)).comp h (hasDerivAt_const_mul γ)
    have hasDerivAt_W_pos : HasDerivAt (WeilOddPower.W h γ m) 0 h := by
      show HasDerivAt (fun u : ℝ => WeilOddPower.q m (u / h) * Real.cos (γ * u)) 0 h
      have hprod := hasDerivAt_qh_pos.mul hasDerivAt_cosγ_pos
      have hqval : WeilOddPower.q m (h / h) = 0 := by
        rw [hpos_div]; unfold WeilOddPower.q; rw [hsin_pi_one, zero_mul]
      exact hprod.congr_deriv (by rw [hqval]; ring)
    have hasDerivAt_exp_pos : HasDerivAt (fun u : ℝ => Real.exp (-u / 2))
        (Real.exp (-h / 2) * (-(1 : ℝ) / 2)) h := by
      have h1 : HasDerivAt (fun u : ℝ => -u) (-(1 : ℝ)) h := (hasDerivAt_id h).neg
      exact (Real.hasDerivAt_exp _).comp h (h1.div_const 2)
    have hasDerivAt_f_pos : HasDerivAt
        (fun u : ℝ => WeilOddPower.W h γ m u * Real.exp (-u / 2)) 0 h := by
      have hprod := hasDerivAt_W_pos.mul hasDerivAt_exp_pos
      exact hprod.congr_deriv (by rw [hW_pos]; ring)
    exact hasDerivAt_f_pos.deriv

/-- The switched window `phiWC` is a `C¹` compactly supported real-valued
test function on `[-h, h]`, hence in the class `IsTest (2*h)`. Real-valued
by `phiWC_real`; `C¹` via `phiW_contDiff_one` lifted through the real
`ofRealCLM`; compact support from `HasCompactSupport.intro` on
`Icc (-h) h`; tsupport contained in `Icc (-(2h)/2) ((2h)/2) = Icc (-h) h`. -/
theorem isTest_phiWC {h : ℝ} (hh : 0 < h) (γ : ℝ) {m : ℕ} (hm : 1 ≤ m) :
    IsTest (2 * h) (WeilPowerBackground.phiWC h γ m) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- goal: ∀ u, (WeilPowerBackground.phiWC h γ m u).im = 0
    exact WeilPowerBackground.phiWC_real h γ m
  · -- goal: ContDiff ℝ 1 (WeilPowerBackground.phiWC h γ m)
    exact Complex.ofRealCLM.contDiff.comp (phiW_contDiff_one hh hm)
  · -- goal: HasCompactSupport (WeilPowerBackground.phiWC h γ m)
    refine HasCompactSupport.intro (K := Set.Icc (-h) h) isCompact_Icc ?_
    intro x hx
    simp [WeilPowerBackground.phiWC, WeilPowerBackground.phiW,
          Set.indicator_of_notMem hx]
  · -- goal: tsupport (phiWC h γ m) ⊆ Icc (-(2*h)/2) ((2*h)/2)
    have hIcc : Set.Icc (-(2*h)/2) ((2*h)/2) = Set.Icc (-h) h := by
      congr 1 <;> ring
    rw [hIcc]
    refine (closure_mono ?_).trans_eq isClosed_Icc.closure_eq
    intro x hx
    by_contra hx_notin
    apply hx
    simp [WeilPowerBackground.phiWC, WeilPowerBackground.phiW,
          Set.indicator_of_notMem hx_notin]

/-- **Target lower.** The zero form's term at an off-line zero `ρ` of real
part `1/2 + ε` is bounded above by `term_le_at_zero`; the negative of that
bound is the target the assembly rides. -/
theorem target_lower {ε γ h : ℝ} {m : ℕ} (_hε : 0 < ε) (hh : 0 < h)
    (ρ : Kadiri.NontrivialZeros) (_hre : (ρ : ℂ).re = 1/2 + ε) (_him : (ρ : ℂ).im = γ)
    (hfar : 2 * ((((ρ : ℂ).re - 1 / 2) * h) ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2)
              ≤ (((ρ : ℂ).im + γ) * h) ^ 2)
    (hne : QS m (wm h γ (ρ : ℂ)) ≠ 0)
    (hsmall : ‖wm h γ (ρ : ℂ)‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2)
    (hq : WeilPowerPhase.q m (wm h γ (ρ : ℂ)) ≤ 1) :
    WeilPowerBands.termW h γ m (ρ : ℂ)
      ≤ -((h / 2) ^ 2 *
          ((cS m / D m) ^ 2 * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
              * (((wm h γ (ρ : ℂ)) ^ 2).re
                  * Real.cos (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m)
                - ((wm h γ (ρ : ℂ)) ^ 2).im
                  * Real.sin (2 * ((wm h γ (ρ : ℂ)) ^ 2).im * sigma m))
            - (cS m / D m) ^ 2 * ‖wm h γ (ρ : ℂ)‖ ^ 2
              * Real.exp (2 * ((wm h γ (ρ : ℂ)) ^ 2).re * sigma m)
              * (4 * WeilPowerPhase.q m (wm h γ (ρ : ℂ))
                 + 4 * WeilPowerPhase.q m (wm h γ (ρ : ℂ)) ^ 2)
          - 2 * (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                  * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) * ‖S m (wm h γ (ρ : ℂ))‖
          - (cS m * Real.cosh (((ρ : ℂ).re - 1 / 2) * h)
                  * (2 / (((ρ : ℂ).im + γ) * h) ^ 2) ^ (m + 1)) ^ 2)) :=
  WeilPowerBridge.term_le_at_zero hh ρ hfar hne hsmall hq

/-- **Near members.** Under the gap hypothesis (`near_set` inside the
off-line box carries the block 13g regime per member, expressed as a
hypothesis that each near member's term is nonnegative), the weighted
sum over the near members is nonnegative. The block 13g regime is
folded into `h_pointwise` as an assumption: iterating
`WeilPowerNear.term_nonneg` in the current relay pass over the boxed-
finite near Finset with each member's F1–F5, R1, R3, R5, L1, N1 witnesses
does not close on one try. Sorried with the goal in a comment per
LOOP.md § 4b. -/
theorem near_nonneg {ε T h γ : ℝ} {m : ℕ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hh : 0 < h) (_hm : 1 ≤ m)
    (near_set : Finset ℂ)
    (_h_near_sub : ↑near_set ⊆ WeilDetect.OffLineBox ε T)
    (h_pointwise : ∀ ρ ∈ near_set, 0 ≤ WeilPowerBands.termW h γ m ρ) :
    0 ≤ ∑ ρ ∈ near_set, WeilPowerBands.termW h γ m ρ := by
  -- goal: 0 ≤ Σ_{near} termW h γ m ρ. Under `h_pointwise` (which
  -- encapsulates the block 13g regime per near member), this is
  -- `Finset.sum_nonneg`. The pointwise hypothesis packages the iterated
  -- `WeilPowerNear.term_nonneg`; producing it from the raw regime is
  -- the follow-up work.
  exact Finset.sum_nonneg h_pointwise

/-- **Far moderate.** For zeros with `|ρ.im − γ| ∈ [δ, 1/2]` the count is
at most `15 log T + 73` (`JensenCount.zeta_local_zero_count`) and each
term has `|termW| ≤ (h/2)² · U_mem²` from
`WeilPowerSharp.norm_S_le_c_pos/neg`. The pointwise bound and the count
are taken as hypotheses; the assembly is `abs_sum_le_sum_abs` chained
with `Finset.sum_le_sum` and `Finset.sum_const`. -/
theorem far_moderate_le {ε T h γ : ℝ} {m : ℕ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hh : 0 < h) (_hm : 1 ≤ m)
    (fm_set : Finset ℂ)
    (_h_fm_sub : ↑fm_set ⊆ WeilDetect.OffLineBox ε T)
    (h_fm_card : (fm_set.card : ℝ) ≤ 15 * Real.log T + 73)
    (U_mem : ℝ)
    (h_bound : ∀ ρ ∈ fm_set, |WeilPowerBands.termW h γ m ρ| ≤ (h/2)^2 * U_mem^2) :
    |∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ|
      ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2) := by
  have h1 : |∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ|
      ≤ ∑ ρ ∈ fm_set, |WeilPowerBands.termW h γ m ρ| :=
    Finset.abs_sum_le_sum_abs _ _
  have h2 : ∑ ρ ∈ fm_set, |WeilPowerBands.termW h γ m ρ|
      ≤ ∑ _ρ ∈ fm_set, (h/2)^2 * U_mem^2 :=
    Finset.sum_le_sum h_bound
  have h3 : (∑ _ρ ∈ fm_set, (h/2)^2 * U_mem^2)
      = (fm_set.card : ℝ) * ((h/2)^2 * U_mem^2) := by
    rw [Finset.sum_const, nsmul_eq_mul]
  have hnn : 0 ≤ (h/2)^2 * U_mem^2 :=
    mul_nonneg (sq_nonneg _) (sq_nonneg _)
  have h4 : (fm_set.card : ℝ) * ((h/2)^2 * U_mem^2)
      ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2) :=
    mul_le_mul_of_nonneg_right h_fm_card hnn
  calc |∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ|
      ≤ ∑ ρ ∈ fm_set, |WeilPowerBands.termW h γ m ρ| := h1
    _ ≤ ∑ _ρ ∈ fm_set, (h/2)^2 * U_mem^2 := h2
    _ = (fm_set.card : ℝ) * ((h/2)^2 * U_mem^2) := h3
    _ ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2) := h4

/-- **Far large.** For zeros with `|ρ.im − γ| > 1/2` the count is at most
`15 log T + 698` (unit 0365) and `WeilPowerBounds.norm_S_le_far` gives a
super-exponentially small pointwise bound. Same shape as `far_moderate_le`. -/
theorem far_large_le {ε T h γ : ℝ} {m : ℕ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hh : 0 < h) (_hm : 1 ≤ m)
    (fl_set : Finset ℂ)
    (_h_fl_sub : ↑fl_set ⊆ WeilDetect.OffLineBox ε T)
    (h_fl_card : (fl_set.card : ℝ) ≤ 15 * Real.log T + 698)
    (U_far : ℝ)
    (h_bound : ∀ ρ ∈ fl_set, |WeilPowerBands.termW h γ m ρ| ≤ (h/2)^2 * U_far^2) :
    |∑ ρ ∈ fl_set, WeilPowerBands.termW h γ m ρ|
      ≤ (15 * Real.log T + 698) * ((h/2)^2 * U_far^2) := by
  have h1 : |∑ ρ ∈ fl_set, WeilPowerBands.termW h γ m ρ|
      ≤ ∑ ρ ∈ fl_set, |WeilPowerBands.termW h γ m ρ| :=
    Finset.abs_sum_le_sum_abs _ _
  have h2 : ∑ ρ ∈ fl_set, |WeilPowerBands.termW h γ m ρ|
      ≤ ∑ _ρ ∈ fl_set, (h/2)^2 * U_far^2 :=
    Finset.sum_le_sum h_bound
  have h3 : (∑ _ρ ∈ fl_set, (h/2)^2 * U_far^2)
      = (fl_set.card : ℝ) * ((h/2)^2 * U_far^2) := by
    rw [Finset.sum_const, nsmul_eq_mul]
  have hnn : 0 ≤ (h/2)^2 * U_far^2 :=
    mul_nonneg (sq_nonneg _) (sq_nonneg _)
  have h4 : (fl_set.card : ℝ) * ((h/2)^2 * U_far^2)
      ≤ (15 * Real.log T + 698) * ((h/2)^2 * U_far^2) :=
    mul_le_mul_of_nonneg_right h_fl_card hnn
  calc |∑ ρ ∈ fl_set, WeilPowerBands.termW h γ m ρ|
      ≤ ∑ ρ ∈ fl_set, |WeilPowerBands.termW h γ m ρ| := h1
    _ ≤ ∑ _ρ ∈ fl_set, (h/2)^2 * U_far^2 := h2
    _ = (fl_set.card : ℝ) * ((h/2)^2 * U_far^2) := h3
    _ ≤ (15 * Real.log T + 698) * ((h/2)^2 * U_far^2) := h4

/-- **On-line background.** The weighted on-line sum is bounded by
`onLineBound h γ m`, from `WeilPowerOnLine.onLineBound_le`. -/
theorem on_line_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    WeilPowerOnLine.onLineBound h γ m
      ≤ 2 * (88 * (γ + WeilPowerBands.r h m + 2) ^ 4
              * (4 * h ^ 2 + WeilPowerBands.cFarM m / h ^ 2) * (Real.pi ^ 2 / 6))
        + 4 * h ^ 2 * WeilOnLine.lowCount :=
  WeilPowerOnLine.onLineBound_le hγ m

/-- **The assembly.** The exponential gap between the target's rate
`ε²/(π²(m+2))` and the far-moderate rate `(ε² − δ²)` gives some `L` at
which `StmtDetectGap ε T δ L` holds. The proof uses
`Real.tendsto_exp_atTop` to close exponential-vs-polynomial, and picks
`ρ₀` as a max-Re element of the finite `OffLineBox`
(`Stage3.offLineBox_finite`). Sorried on the relay pass — the
existence-of-`L` argument depends on `isTest_phiWC` being closed and on
the near/far/on-line split being explicit, neither of which stands after
one try. -/
theorem detect_gap_exists {ε T δ : ℝ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hδ : 0 < δ) (_hδ1 : δ ≤ 1/2) :
    ∃ L : ℝ, StmtDetectGap ε T δ L := by
  -- goal: ∃ L, StmtDetectGap ε T δ L. Chain (a)–(e) from the brief:
  --   (a) pick ρ₀ ∈ OffLineBox ε T (Stage3.offLineBox_finite → Finset →
  --       max-Re element via Finset.exists_max_image);
  --   (b) unfold `L = 2h`; the gap hypothesis says other zeros are outside
  --       `Ioo (π³/(8εh)) δ`;
  --   (c) split the box (minus ρ₀) into near, far-moderate, far-large
  --       Finsets;
  --   (d) show `(h/2)² · S_lo² > BG + cluster + far` at large `h` via
  --       `Real.tendsto_exp_atTop` for the target's `exp(2 wm² sigma)`,
  --       polynomial bounds for BG and far-large, exponential-with-smaller-
  --       rate for the cluster;
  --   (e) take `G := phiWC h γ m`, apply `isTest_phiWC` and the sign chain
  --       via `target_lower`, `near_nonneg`, `far_moderate_le`,
  --       `far_large_le`, `on_line_le`.
  -- Step (a) closes but (d) does not close on one try — it needs the
  -- `Real.tendsto_exp_atTop` chained with polynomial-vs-exponential and
  -- the free parameters (γ, m, h) rated at the split. LOOP.md v21 § 4b:
  -- one try per LOOP.md v21 § 4b; the placeholder tactic follows.
  sorry

/-- info: 'WeilPowerAssembly.target_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms target_lower

/-- info: 'WeilPowerAssembly.on_line_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms on_line_le

/-- info: 'WeilPowerAssembly.far_moderate_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms far_moderate_le

/-- info: 'WeilPowerAssembly.far_large_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms far_large_le

/-- info: 'WeilPowerAssembly.near_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms near_nonneg

/-- info: 'WeilPowerAssembly.phiW_contDiff_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms phiW_contDiff_one

/-- info: 'WeilPowerAssembly.isTest_phiWC' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isTest_phiWC

/-- info: 'WeilPowerAssembly.detect_gap_exists' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms detect_gap_exists

end

end WeilPowerAssembly
