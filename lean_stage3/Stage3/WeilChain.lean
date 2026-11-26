/-
# Stage3.WeilChain — the Riemann hypothesis from detection and Weil positivity

The pieces of the positivity route, joined so that the whole goal rests on two
named statements about ζ alone (session 2026-11-26, Julian: "what's the pieces and
the lean compiles").

| piece | statement | status |
|---|---|---|
| `WeilDetect.box_empty_of_positive_of_detect` | detection and positivity on one support empty the box | proved |
| `boxes_empty_rh` (here) | every off-line box empty gives `RiemannHypothesis` | proved here |
| `rh_of_detect_positive` (here) | detection at every box and positivity at every support give `RiemannHypothesis` | proved here |
| `hD : ∀ ε T, 0 < ε → 2 ≤ T → ∃ L, StmtDetect ε T L` | rung 5's T11, `lean_stage3/design/rung5.md` § 16 | OPEN, unconditional, to build |
| `hP : ∀ L, StmtWeilPositive L` | Weil positivity for ζ | OPEN, the core; equivalent to RH by `weilPositive_of_RH` |
-/
import Stage3.WeilDetect
import Stage3.ClosedLoopJoin

namespace WeilChain

open Complex WeilDetect

/-- An off-line zero with real part above one half sits in some box. -/
theorem mem_box_of_right {s : ℂ} (hz : riemannZeta s = 0) (hre : 1 / 2 < s.re)
    (hre1 : s.re < 1) :
    s ∈ OffLineBox ((s.re - 1 / 2) / 2) (max 2 (|s.im| + 1)) := by
  refine ⟨⟨by linarith, hre1.le⟩, ⟨?_, ?_⟩, hz⟩
  · have := neg_abs_le s.im
    have := le_max_right 2 (|s.im| + 1)
    linarith
  · have := le_abs_self s.im
    have := le_max_right 2 (|s.im| + 1)
    linarith

/-- **Every box empty gives the Riemann hypothesis.** A nontrivial zero off the
line, or its mirror `1 - ρ`, has real part above one half and lies in a box. -/
theorem boxes_empty_rh
    (h : ∀ ε T : ℝ, 0 < ε → 2 ≤ T → OffLineBox ε T = ∅) : RiemannHypothesis := by
  rw [ClosedLoopJoin.rh_iff_re_half]
  rintro ⟨ρ, ⟨⟨h0, h1⟩, -, hz⟩⟩
  simp only
  by_contra hne
  rcases lt_or_gt_of_ne hne with hlt | hgt
  · -- the mirror `1 - ρ` is a zero right of the line
    have hz' : riemannZeta (1 - ρ) = 0 := by
      have hn : ∀ n : ℕ, ρ ≠ -n := by
        intro n hn
        have := congrArg Complex.re hn
        simp at this
        linarith [show (0 : ℝ) ≤ n from Nat.cast_nonneg n]
      have h1' : ρ ≠ 1 := by
        intro h; rw [h] at h1; simp at h1
      rw [riemannZeta_one_sub hn h1']
      simp [show riemannZeta ρ = 0 from hz]
    have hre : 1 / 2 < (1 - ρ).re := by simp; linarith
    have hre1 : (1 - ρ).re < 1 := by simp; linarith
    have hmem := mem_box_of_right hz' hre hre1
    rw [h _ _ (by linarith) (le_max_left _ _)] at hmem
    exact hmem
  · have hmem := mem_box_of_right hz hgt h1
    rw [h _ _ (by linarith) (le_max_left _ _)] at hmem
    exact hmem

/-- **The chain.** Detection at every box and Weil positivity at every support give
Mathlib's `RiemannHypothesis`. -/
theorem rh_of_detect_positive
    (hD : ∀ ε T : ℝ, 0 < ε → 2 ≤ T → ∃ L, StmtDetect ε T L)
    (hP : ∀ L, StmtWeilPositive L) : RiemannHypothesis :=
  boxes_empty_rh fun ε T hε hT =>
    let ⟨L, hL⟩ := hD ε T hε hT
    box_empty_of_positive_of_detect hL (hP L)

end WeilChain

/-- info: 'WeilChain.boxes_empty_rh' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeilChain.boxes_empty_rh

/-- info: 'WeilChain.rh_of_detect_positive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms WeilChain.rh_of_detect_positive
