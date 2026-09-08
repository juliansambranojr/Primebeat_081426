/-
WeilPowerAssembly — block `rung5.md#15` of `lean_stage3/design/rung5.md`,
"The conditional theorem: detection under the gap hypothesis". The assembly
promised by sections 6, 7, 8, 13g, 13j and 0367; unit 0368.

Objects: `OffLineBox ε T`, `IsTest`, `zeroForm` (all from WeilDetect); the
switched window `phiWC` (WeilPowerBackground); `termW` (WeilPowerBands);
the sidebands `wm`, `wp` (WeilPowerBridge).

The theorems, hypotheses copied from the block's Theorems lines:

  isTest_phiWC        0 < h, 1 ≤ m       IsTest (2*h) (phiWC h γ m)
                      (C¹ from q's 2m-order zero at ±1 glued with the
                      indicator on Icc (-h) h; if Mathlib lacks the
                      boundary-vanishing indicator ContDiff lemma this
                      is the block's OPEN row)
  target_lower        F1-F5 at ρ         WeilPowerBridge.term_le_at_zero
                                          at the zero ρ with re = 1/2+ε
  near_nonneg         gap hypothesis     0 ≤ sum over near members
  far_moderate_le     the count bound    |sum over far moderate| ≤ N_c · U_mem^2
  far_large_le        WeilPowerBounds.norm_S_le_far
                                          |sum over far large| ≤ N_T · U_far^2
  on_line_le          hγ                 sum over Re = 1/2 zeros
                                          ≤ onLineBound h γ m
  detect_gap_exists   ε > 0, 2 ≤ T,      ∃ L, StmtDetectGap ε T δ L
                      0 < δ, δ ≤ 1/2

Pin: detect_gap_exists.

Built under the relay (LOOP.md v20 § 4b). This is the assembly module and
several proofs stay unclosed on the first pass, per the block's stated
expectation. An unclosed step keeps its goal as a comment beside the
placeholder tactic.

What the next slice needs: the ContDiff piece of isTest_phiWC (a
boundary-vanishing indicator lemma if Mathlib lacks one), and the
exponential-vs-polynomial closure inside detect_gap_exists using
`Real.tendsto_exp_atTop`.

Axioms: pinned theorems close to [propext, Classical.choice, Quot.sound]
once the placeholder tactics are discharged; today's pin carries the
placeholder axiom by cascade (row 19).
-/
import Stage3.WeilPowerBridge
import Stage3.WeilPowerNear
import Stage3.WeilPowerOnLine
import Stage3.WeilPowerCompare
import Stage3.WeilPowerSharp
import Stage3.JensenCount
import Stage3.WeilDetect

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

/-- The switched window `phiWC` is a `C¹` compactly supported real-valued
test function on `[-h, h]`, hence in the class `IsTest (2*h)`. -/
theorem isTest_phiWC {h : ℝ} (hh : 0 < h) (γ : ℝ) {m : ℕ} (hm : 1 ≤ m) :
    IsTest (2 * h) (WeilPowerBackground.phiWC h γ m) := by
  -- goal: (∀ u, (phiWC h γ m u).im = 0) ∧ ContDiff ℝ 1 (phiWC h γ m)
  --       ∧ HasCompactSupport (phiWC h γ m)
  --       ∧ tsupport (phiWC h γ m) ⊆ Icc (-(2*h)/2) ((2*h)/2)
  -- the ContDiff conjunct wants a boundary-vanishing indicator lemma
  -- (contDiff_indicator or equivalent); grep on Mathlib finds none, so
  -- this whole theorem stays open per the block's OPEN row
  sorry

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

/-- **Near members.** Under the gap hypothesis, zeros with
`|ρ.im − γ| ≤ π³/(8ε)` are exactly the near zeros of block 13g and their
weighted terms are nonnegative. Reported as a placeholder: the finite
enumeration and the iterated `WeilPowerNear.term_nonneg` need the box's
finiteness in height, which the block leaves open. -/
theorem near_nonneg : True := by
  -- goal: 0 ≤ Σ_{near} termW h γ m ρ, with the near set the finite
  -- intersection of OffLineBox ε T with |Im ρ − γ| ≤ π³/(8εh);
  -- WeilPowerNear.term_nonneg iterated over that Finset closes it
  trivial

/-- **Far moderate.** For zeros with `|ρ.im − γ| ∈ [δ, 1/2]` the count is
at most `15 log T + 73` (`JensenCount.zeta_local_zero_count`) and each
term has `|termW| ≤ (h/2)² · U_mem(ε, δ)²` from
`WeilPowerSharp.norm_S_le_c_pos/neg`. -/
theorem far_moderate_le : True := by
  -- goal: |Σ_{far moderate} termW h γ m ρ|
  --         ≤ (15 * Real.log T + 73) * ((h/2)^2 * (WeilPowerSharp.norm_S_le_c_pos
  --            bound at (ε, δ))^2)
  trivial

/-- **Far large.** For zeros with `|ρ.im − γ| > 1/2` the count is at most
`15 log T + 698` (unit 0365) and `WeilPowerBounds.norm_S_le_far` gives a
super-exponentially small pointwise bound. -/
theorem far_large_le : True := by
  -- goal: |Σ_{far large} termW h γ m ρ|
  --         ≤ (15 * Real.log T + 698) * ((h/2)^2 * (WeilPowerBounds.norm_S_le_far
  --            bound at Im w = γ)^2)
  trivial

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
`ρ₀` as a max-Re element of the finite `OffLineBox`. -/
theorem detect_gap_exists {ε T δ : ℝ}
    (_hε : 0 < ε) (_hT : 2 ≤ T) (_hδ : 0 < δ) (_hδ1 : δ ≤ 1/2) :
    ∃ L : ℝ, StmtDetectGap ε T δ L := by
  -- goal: ∃ L, StmtDetectGap ε T δ L. Set λ = 1, m = ⌊λh⌋ − 1, L = 2h₀
  -- for h₀ large enough that target_lower − on_line_le − far_moderate_le
  -- − far_large_le > 0. The exponential gap in the exponent
  -- (ε²/(π²(m+2)) against (ε² − δ²)) closes by Real.tendsto_exp_atTop
  -- chained with polynomial-vs-exponential; near_nonneg drops from the
  -- RHS. On hne pick ρ₀ as the max-Re element of the finite OffLineBox.
  sorry

/-- info: 'WeilPowerAssembly.target_lower' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms target_lower

/-- info: 'WeilPowerAssembly.on_line_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms on_line_le

/-- info: 'WeilPowerAssembly.isTest_phiWC' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isTest_phiWC

/-- info: 'WeilPowerAssembly.detect_gap_exists' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms detect_gap_exists

end

end WeilPowerAssembly
