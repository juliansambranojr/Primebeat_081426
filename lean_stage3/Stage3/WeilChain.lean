/-
# Stage3.WeilChain — the Riemann hypothesis from detection and Weil positivity

The pieces of the positivity route, joined so that the whole goal rests on two
named statements about ζ alone (session 2026-11-26, Julian: "what's the pieces and
the lean compiles"). The chain is a conditional of the shape the tree already
has twelve times; its only new link is detection plus positivity on one support,
and `hP` is the Riemann hypothesis restated (`weilPositive_of_RH`). The piece with
content is `hD`, rung 5's T11, unconditional and not yet built.

| piece | statement | status |
|---|---|---|
| `WeilDetect.box_empty_of_positive_of_detect` | detection and positivity on one support empty the box | proved |
| `boxes_empty_rh` (here) | every off-line box empty gives `RiemannHypothesis`, on `LandauWindow.rh_of_zeroFree_half` | proved here, a corollary |
| `rh_of_detect_positive` (here) | detection at every box and positivity at every support give `RiemannHypothesis` | proved here |
| `hD : ∀ ε T, 0 < ε → 2 ≤ T → ∃ L, StmtDetect ε T L` | rung 5's T11, `lean_stage3/design/rung5.md` § 16 | OPEN, unconditional, to build |
| `hP : ∀ L, StmtWeilPositive L` | Weil positivity for ζ | OPEN, the core; equivalent to RH by `weilPositive_of_RH` |
-/
import Stage3.WeilDetect
import Stage3.LandauWindow

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

/-- **Every box empty gives the Riemann hypothesis.** Built on
`LandauWindow.rh_of_zeroFree_half`, which already turns "no zero right of one half"
into `RiemannHypothesis` (the mirror step lives there): a zero right of the line with
real part below one lies in a box, and none lies at real part one or more. -/
theorem boxes_empty_rh
    (h : ∀ ε T : ℝ, 0 < ε → 2 ≤ T → OffLineBox ε T = ∅) : RiemannHypothesis := by
  refine LandauWindow.rh_of_zeroFree_half fun s hs hz => ?_
  rcases lt_or_ge s.re 1 with h1 | h1
  · have hmem := mem_box_of_right hz hs h1
    rw [h _ _ (by linarith) (le_max_left _ _)] at hmem
    exact hmem
  · exact riemannZeta_ne_zero_of_one_le_re h1 hz

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
