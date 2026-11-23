/-
SpiralLink — block J2 of `lean_stage3/design/closedloop.md`. 2026-11-23.

The link of Julian's paper, §6.3 ("The Phasor Mechanism"), stated in Lean:

  "the spiral can only converge at σ = 1/2".

The walk closing is a zero of zeta. The statement that it closes only where
the closed loop is at rest is `SpiralLink`: the Hermitian handshake holds at
every nontrivial zero. It is stated here, and tied to Julian's other form of
it: there is one zero, not two.

The mirror of a zero, `mirrorZ ρ = 1 − conj ρ`, is a zero at the same height
with the real part reflected in one half (the functional equation). A zero is
its own mirror exactly on the line. So an off-line zero is two zeros at one
height, and "one zero at each height" is the Riemann hypothesis.

  mirrorZ                  the mirror of a zero, as a zero
  mirrorZ_im, mirrorZ_re   same height; real part 1 − Re ρ
  mirrorZ_eq_iff           mirrorZ ρ = ρ ↔ Re ρ = 1/2
  mirror_pair_area         ‖b^ρ‖·‖b^(mirrorZ ρ)‖ = b: the pair keeps pace
  off_line_is_two          off the line: a second zero, same height, the
                             handshake failing at both
  SpiralLink               the handshake at every zero (§6.3's sentence)
  OneAtEachHeight          no two zeros share a height
  spiralLink_iff_one       the two statements are the same
  rh_iff_spiralLink        RH ↔ SpiralLink
  rh_iff_one_at_each_height  RH ↔ OneAtEachHeight

What this does not contain: a proof of `SpiralLink` or of `OneAtEachHeight`.
Each is the Riemann hypothesis in these terms.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.ClosedLoopJoin
import Stage3.WeilOnLine

namespace SpiralLink

open Kadiri ClosedLoopJoin

/-- The mirror point `1 − conj ρ` of a nontrivial zero is a nontrivial zero. -/
theorem mirror_mem (ρ : NontrivialZeros) :
    (1 - (starRingEnd ℂ) (ρ : ℂ)) ∈ NontrivialZeros := by
  have hc := WeilOnLine.conj_mem ρ
  set c : ℂ := (starRingEnd ℂ) (ρ : ℂ) with hcd
  have hcre : c.re = (ρ : ℂ).re := Complex.conj_re _
  have h0 : 0 < c.re := by rw [hcre]; exact ρ.2.1.1
  have h1 : c.re < 1 := by rw [hcre]; exact ρ.2.1.2
  have hz : riemannZeta c = 0 := hc.2.2
  have hne : ∀ n : ℕ, c ≠ -(n : ℂ) := by
    intro n hn
    have := congrArg Complex.re hn
    simp at this
    have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
    linarith
  have hc1 : c ≠ 1 := by
    intro h
    rw [h] at h1
    simp at h1
  have hfe := riemannZeta_one_sub hne hc1
  refine ⟨⟨?_, ?_⟩, Set.mem_univ _, ?_⟩
  · simp only [Complex.sub_re, Complex.one_re]
    linarith
  · simp only [Complex.sub_re, Complex.one_re]
    linarith
  · show riemannZeta (1 - c) = 0
    rw [hfe, hz, mul_zero]

/-- The mirror of a zero, as a zero. -/
def mirrorZ (ρ : NontrivialZeros) : NontrivialZeros :=
  ⟨1 - (starRingEnd ℂ) (ρ : ℂ), mirror_mem ρ⟩

/-- The mirror of a zero is at the same height. -/
theorem mirrorZ_im (ρ : NontrivialZeros) : ((mirrorZ ρ : NontrivialZeros) : ℂ).im = (ρ : ℂ).im := by
  show (1 - (starRingEnd ℂ) (ρ : ℂ)).im = (ρ : ℂ).im
  simp

/-- The mirror of a zero has its real part reflected in one half. -/
theorem mirrorZ_re (ρ : NontrivialZeros) :
    ((mirrorZ ρ : NontrivialZeros) : ℂ).re = 1 - (ρ : ℂ).re := by
  show (1 - (starRingEnd ℂ) (ρ : ℂ)).re = 1 - (ρ : ℂ).re
  simp

/-- **A zero is its own mirror exactly on the line.** -/
theorem mirrorZ_eq_iff (ρ : NontrivialZeros) : mirrorZ ρ = ρ ↔ (ρ : ℂ).re = 1 / 2 := by
  constructor
  · intro h
    have h1 := congrArg (fun z : NontrivialZeros => (z : ℂ).re) h
    simp only [mirrorZ_re] at h1
    linarith
  · intro h
    apply Subtype.ext
    apply Complex.ext
    · rw [mirrorZ_re]
      linarith
    · exact mirrorZ_im ρ

/-- **The pair keeps pace.** At any base, the size of a zero's mode times the
size of its mirror's mode is the base. -/
theorem mirror_pair_area {b : ℝ} (hb : 0 < b) (ρ : NontrivialZeros) :
    ‖(b : ℂ) ^ (ρ : ℂ)‖ * ‖(b : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ = b := by
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hb, Complex.norm_cpow_eq_rpow_re_of_pos hb,
    mirrorZ_re, ← Real.rpow_add hb]
  simp

/-- **Off the line a zero is two.** A nontrivial zero off the line has a mirror
that is a different zero at the same height, and the handshake fails at both. -/
theorem off_line_is_two (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    mirrorZ ρ ≠ ρ ∧ ((mirrorZ ρ : NontrivialZeros) : ℂ).im = (ρ : ℂ).im ∧
      ¬ isHermitianHandshake (ρ : ℂ).re ∧
      ¬ isHermitianHandshake ((mirrorZ ρ : NontrivialZeros) : ℂ).re := by
  refine ⟨fun he => h ((mirrorZ_eq_iff ρ).mp he), mirrorZ_im ρ,
    fun hh => h ((handshake_iff_half _).mp hh), fun hh => ?_⟩
  have := (handshake_iff_half _).mp hh
  rw [mirrorZ_re] at this
  exact h (by linarith)

/-- **The spiral link** (Julian's paper, §6.3): the walk closes only where the
closed loop is at rest. The Hermitian handshake holds at every nontrivial zero
of zeta. -/
def SpiralLink : Prop :=
  ∀ ρ : NontrivialZeros, isHermitianHandshake (ρ : ℂ).re

/-- **There is one zero.** No two nontrivial zeros share a height. -/
def OneAtEachHeight : Prop :=
  ∀ ρ ρ' : NontrivialZeros, (ρ : ℂ).im = (ρ' : ℂ).im → ρ = ρ'

/-- The Riemann hypothesis is the spiral link. -/
theorem rh_iff_spiralLink : RiemannHypothesis ↔ SpiralLink :=
  rh_iff_handshake

/-- **The Riemann hypothesis is that there is one zero at each height.** -/
theorem rh_iff_one_at_each_height : RiemannHypothesis ↔ OneAtEachHeight := by
  rw [rh_iff_re_half]
  constructor
  · intro h ρ ρ' him
    apply Subtype.ext
    apply Complex.ext
    · rw [h ρ, h ρ']
    · exact him
  · intro h ρ
    have he := h (mirrorZ ρ) ρ (mirrorZ_im ρ)
    exact (mirrorZ_eq_iff ρ).mp he

/-- The spiral link and "one zero at each height" are the same statement. -/
theorem spiralLink_iff_one : SpiralLink ↔ OneAtEachHeight :=
  rh_iff_spiralLink.symm.trans rh_iff_one_at_each_height

/-- info: 'SpiralLink.mirrorZ_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms mirrorZ_eq_iff

/-- info: 'SpiralLink.off_line_is_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms off_line_is_two

/-- info: 'SpiralLink.rh_iff_spiralLink' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_spiralLink

/-- info: 'SpiralLink.rh_iff_one_at_each_height' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_one_at_each_height

/-- info: 'SpiralLink.spiralLink_iff_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms spiralLink_iff_one

end SpiralLink
