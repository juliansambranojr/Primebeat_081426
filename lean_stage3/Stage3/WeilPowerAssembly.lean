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
                      (real/HasCompactSupport/tsupport closed on the pass;
                      ContDiff conjunct sorried on one try — the boundary
                      derivative-vanishing of q m (u/h)·cos(γu)·exp(-u/2)
                      at u = ±h needs P(±1) = 0 with m ≥ 1 pushed through
                      product/composition rules; one try per proof step)
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

Pins: target_lower, on_line_le, isTest_phiWC, near_nonneg,
far_moderate_le, far_large_le, detect_gap_exists.

Built under the relay (LOOP.md v21 § 4b, one try per proof step). Sorries
carried on this pass are declared in `values.tsv` under `sorries` and each
one keeps its goal as a comment beside the placeholder tactic.

What the next slice needs: (i) the ContDiff conjunct of isTest_phiWC —
either a boundary-derivative-vanishing computation on
`W h γ m u · exp(-u/2)` at `u = ±h`, or an intermediate lemma stating
q_deriv_vanishes_at_pm_one for m ≥ 1; (ii) the iterated
`WeilPowerNear.term_nonneg` inside near_nonneg, per member of the near
Finset; (iii) the exponential-vs-polynomial existence proof inside
detect_gap_exists using `Real.tendsto_exp_atTop`.

Axioms: `target_lower`, `on_line_le`, `far_moderate_le`, `far_large_le`
close to `[propext, Classical.choice, Quot.sound]`. `isTest_phiWC`,
`near_nonneg`, `detect_gap_exists` carry `sorryAx` by their declared
sorries; the pin docstrings match.
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

/-- The switched window `phiWC` is a `C¹` compactly supported real-valued
test function on `[-h, h]`, hence in the class `IsTest (2*h)`. Three of
the four conjuncts close on the relay pass (real-valuedness from
`phiWC_real`, compact support from `HasCompactSupport.intro` on
`Icc (-h) h`, tsupport ⊆ `Icc (-h) h` = `Icc (-(2h)/2) ((2h)/2)`). The
`ContDiff` conjunct wants `contDiff_one_indicator_Icc` at
`f u = W h γ m u · exp(-u/2)` on `Icc (-h) h`, whose boundary hypotheses
`f(±h) = 0` and `deriv f(±h) = 0` follow from `P(±1) = 0` (m ≥ 1) but do
not close on one try because the product-and-composition derivative of
`q m (u/h)·cos(γu)·exp(-u/2)` needs its own auxiliary lemma. Sorried
here with the goal in a comment per LOOP.md § 4b. -/
theorem isTest_phiWC {h : ℝ} (hh : 0 < h) (γ : ℝ) {m : ℕ} (_hm : 1 ≤ m) :
    IsTest (2 * h) (WeilPowerBackground.phiWC h γ m) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · -- goal: ∀ u, (WeilPowerBackground.phiWC h γ m u).im = 0
    exact WeilPowerBackground.phiWC_real h γ m
  · -- goal: ContDiff ℝ 1 (WeilPowerBackground.phiWC h γ m)
    -- The route: `phiWC = Complex.ofRealCLM ∘ phiW`, so it suffices to
    -- show `ContDiff ℝ 1 (phiW h γ m)`; and `phiW h γ m` is
    -- `Set.indicator (Icc (-h) h) (fun u => W h γ m u * Real.exp (-u/2))`,
    -- to which `contDiff_one_indicator_Icc` applies with the boundary-
    -- vanishing hypotheses. Those hypotheses are `f(-h) = 0`, `f(h) = 0`,
    -- `deriv f (-h) = 0`, `deriv f h = 0` for `f = W h γ m · exp(-·/2)`;
    -- each needs its own product/composition-derivative lemma tied to
    -- `q_neg_one_eq_zero`, `q_one_eq_zero`, `q'_neg_one_eq_zero`,
    -- `q'_one_eq_zero`. LOOP.md v21 § 4b: one try per proof step.
    sorry
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

/-- info: 'WeilPowerAssembly.isTest_phiWC' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms isTest_phiWC

/-- info: 'WeilPowerAssembly.detect_gap_exists' depends on axioms: [propext, sorryAx, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms detect_gap_exists

end

end WeilPowerAssembly
