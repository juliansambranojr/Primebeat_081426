/-
ClosedLoopJoin — block J1 of `lean_stage3/design/closedloop.md`: the join between `lean_primebeat` and Stage 3. 2026-11-23.

Julian's closed loop (`lean_primebeat/PrimeBeat/primebeat_closed_loop.lean`,
Parts VII, VIII and XI) defines a restoring force `|2.5 − 5·(1/2 + ε)|`,
`ε = σ − 1/2`, and a Hermitian handshake `p^(−σ) = p^(−(1−σ))` at every prime
`p > 3`, and proves `structural_contradiction`: off `σ = 1/2` the force is
nonzero and the handshake fails. Those statements are about a real number `σ`.

Stage 3 has the same two objects on the modes of the table:
`StencilWeil.restoringForce b ρ`, the mirror imbalance of a mode, and the two
sides `‖b^ρ‖`, `‖b^(1−ρ)‖` of `MirrorArea`. This module ties them, and states
the closed loop's theorems on the zeros of zeta.

The two packages are separate (toolchains v4.28.0 and v4.32.2), so the closed
loop's four definitions are restated here word for word and nothing is
imported from it.

  force_eq                  restoringForce σ = 5·|σ − 1/2|
  force_join                1 < b ⊢ the mirror imbalance of a mode
                              = (2·log b / 5) · the closed loop's force
  handshake_iff_sides       the handshake at Re ρ ↔ at every prime p > 3 the
                              mode and its mirror have the same size
  handshake_iff_half        the handshake at σ ↔ σ = 1/2
  structural_contradiction  the closed loop's theorem, as there
  off_line_zero             a zero of zeta off the line: force nonzero,
                              handshake fails, imbalance nonzero at every
                              base, and one side longer than √b
  rh_iff_force_zero         RH ↔ the force is zero at every zero of zeta
  rh_iff_handshake          RH ↔ the handshake holds at every zero of zeta

What this does not contain: a statement that the force is zero, or the
handshake holds, at a zero of zeta. That is the Riemann hypothesis itself in
these terms, by the last two theorems.

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.MirrorArea
import Stage3.LandauWindow
import Stage3.FiniteOffLine

namespace ClosedLoopJoin

open Kadiri

/-- The displacement from one half. Restated from the closed loop, Part VII. -/
noncomputable def epsilon (σ : ℝ) : ℝ := σ - (1 / 2 : ℝ)

/-- The closed loop's restoring force. Restated from Part VII. -/
noncomputable def restoringForce (σ : ℝ) : ℝ :=
  |(2.5 : ℝ) - 5 * ((1 / 2 : ℝ) + epsilon σ)|

/-- The scaling weight of a prime. Restated from Part VIII. -/
noncomputable def primeWeight (p : ℕ) (σ : ℝ) : ℝ :=
  (p : ℝ) ^ (-σ)

/-- The Hermitian handshake. Restated from Part VIII. -/
def isHermitianHandshake (σ : ℝ) : Prop :=
  ∀ p : ℕ, Nat.Prime p → p > 3 → primeWeight p σ = primeWeight p (1 - σ)

/-- The closed loop's force is five times the distance from one half. -/
theorem force_eq (σ : ℝ) : restoringForce σ = 5 * |σ - 1 / 2| := by
  unfold restoringForce epsilon
  have e : (2.5 : ℝ) - 5 * ((1 / 2 : ℝ) + (σ - 1 / 2)) = -(5 * (σ - 1 / 2)) := by
    norm_num
    ring
  rw [e, abs_neg, abs_mul]
  norm_num

/-- **The two forces are one.** For a base above one, the mirror imbalance of a
mode of the table is the closed loop's restoring force at the mode's real part,
times a constant that depends on the base alone. -/
theorem force_join {b : ℝ} (hb : 1 < b) (ρ : ℂ) :
    StencilWeil.restoringForce b ρ = 2 * Real.log b / 5 * restoringForce ρ.re := by
  rw [StencilWeil.restoringForce_eq hb, force_eq]
  ring

/-- The closed loop's force is zero exactly at one half. -/
theorem force_eq_zero_iff (σ : ℝ) : restoringForce σ = 0 ↔ σ = 1 / 2 := by
  rw [force_eq]
  constructor
  · intro h
    have h1 : |σ - 1 / 2| = 0 := by linarith
    have h2 := abs_eq_zero.mp h1
    linarith
  · intro h
    rw [h]
    norm_num

/-- A prime's weight at the real part of a point is the reciprocal of the size
of the prime's mode there. -/
theorem primeWeight_eq_inv_side {p : ℕ} (hp : 0 < p) (ρ : ℂ) :
    primeWeight p ρ.re = (‖((p : ℝ) : ℂ) ^ ρ‖)⁻¹ := by
  have hp0 : (0 : ℝ) < (p : ℝ) := by exact_mod_cast hp
  unfold primeWeight
  rw [Complex.norm_cpow_eq_rpow_re_of_pos hp0, Real.rpow_neg hp0.le]

/-- **The handshake is the two sides agreeing.** The Hermitian handshake at the
real part of a point holds exactly when, at every prime above three, the mode
and its mirror have the same size. -/
theorem handshake_iff_sides (ρ : ℂ) :
    isHermitianHandshake ρ.re ↔
      ∀ p : ℕ, Nat.Prime p → p > 3 → ‖((p : ℝ) : ℂ) ^ ρ‖ = ‖((p : ℝ) : ℂ) ^ (1 - ρ)‖ := by
  have key : ∀ p : ℕ, Nat.Prime p →
      (primeWeight p ρ.re = primeWeight p (1 - ρ.re) ↔
        ‖((p : ℝ) : ℂ) ^ ρ‖ = ‖((p : ℝ) : ℂ) ^ (1 - ρ)‖) := by
    intro p hp
    have hre : (1 - ρ).re = 1 - ρ.re := by simp
    rw [primeWeight_eq_inv_side hp.pos ρ, ← hre, primeWeight_eq_inv_side hp.pos (1 - ρ)]
    exact inv_inj
  constructor
  · intro h p hp h3
    exact (key p hp).mp (h p hp h3)
  · intro h p hp h3
    exact (key p hp).mpr (h p hp h3)

/-- **The handshake holds exactly at one half.** -/
theorem handshake_iff_half (σ : ℝ) : isHermitianHandshake σ ↔ σ = 1 / 2 := by
  constructor
  · intro h
    have h5 := h 5 (by norm_num) (by norm_num)
    unfold primeWeight at h5
    have h5' : (5 : ℝ) ^ (-σ) = (5 : ℝ) ^ (-(1 - σ)) := by exact_mod_cast h5
    have hlog := congrArg Real.log h5'
    rw [Real.log_rpow (by norm_num), Real.log_rpow (by norm_num)] at hlog
    have h5pos : 0 < Real.log 5 := Real.log_pos (by norm_num)
    have hσ : -σ = -(1 - σ) := mul_right_cancel₀ h5pos.ne' hlog
    linarith
  · intro h p _ _
    rw [h]
    norm_num

/-- **The structural contradiction**, the closed loop's main theorem (Part XI):
away from one half the restoring force is nonzero and the handshake fails. -/
theorem structural_contradiction (σ : ℝ) (hσ : σ ≠ 1 / 2) :
    restoringForce σ ≠ 0 ∧ ¬ isHermitianHandshake σ :=
  ⟨fun h => hσ ((force_eq_zero_iff σ).mp h), fun h => hσ ((handshake_iff_half σ).mp h)⟩

/-- **The structural contradiction at a zero of zeta.** If a nontrivial zero is
off the line, then the closed loop's force there is nonzero, the handshake
fails, the mirror imbalance of its mode is nonzero at every base above one, and
one of the mode's two sides is longer than the square root of the base. -/
theorem off_line_zero (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) :
    restoringForce (ρ : ℂ).re ≠ 0 ∧ ¬ isHermitianHandshake (ρ : ℂ).re ∧
      ∀ b : ℝ, 1 < b → StencilWeil.restoringForce b (ρ : ℂ) ≠ 0 ∧
        Real.sqrt b < max ‖(b : ℂ) ^ (ρ : ℂ)‖ ‖(b : ℂ) ^ (1 - (ρ : ℂ))‖ := by
  obtain ⟨h1, h2⟩ := structural_contradiction _ h
  refine ⟨h1, h2, fun b hb => ⟨?_, MirrorArea.long_side_of_off_line hb h⟩⟩
  intro h0
  exact h ((StencilWeil.restoringForce_eq_zero_iff hb _).mp h0)

/-- The Riemann hypothesis is every nontrivial zero having real part one half. -/
theorem rh_iff_re_half :
    RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, (ρ : ℂ).re = 1 / 2 := by
  constructor
  · intro hRH ρ
    have hz : riemannZeta (ρ : ℂ) = 0 := ρ.2.2.2
    have hre0 : 0 < (ρ : ℂ).re := ρ.2.1.1
    have hre1 : (ρ : ℂ).re < 1 := ρ.2.1.2
    refine hRH (ρ : ℂ) hz ?_ ?_
    · rintro ⟨n, hn⟩
      have := congrArg Complex.re hn
      simp at this
      have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    · intro h1
      have := congrArg Complex.re h1
      simp at this
      linarith
  · intro h
    apply LandauWindow.rh_of_zeroFree_half
    intro s hs hz
    have hs1 : s.re < 1 := by
      by_contra hc
      exact riemannZeta_ne_zero_of_one_le_re (not_lt.mp hc) hz
    let ρ : NontrivialZeros := ⟨s, ⟨⟨by linarith, hs1⟩, Set.mem_univ _, hz⟩⟩
    have := h ρ
    have hρ : (ρ : ℂ).re = s.re := rfl
    linarith

/-- **The Riemann hypothesis is the force at rest.** RH holds exactly when the
closed loop's restoring force is zero at every nontrivial zero of zeta. -/
theorem rh_iff_force_zero :
    RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, restoringForce (ρ : ℂ).re = 0 := by
  rw [rh_iff_re_half]
  exact forall_congr' fun ρ => (force_eq_zero_iff _).symm

/-- **The Riemann hypothesis is the handshake.** RH holds exactly when the
Hermitian handshake holds at every nontrivial zero of zeta. -/
theorem rh_iff_handshake :
    RiemannHypothesis ↔ ∀ ρ : NontrivialZeros, isHermitianHandshake (ρ : ℂ).re := by
  rw [rh_iff_re_half]
  exact forall_congr' fun ρ => (handshake_iff_half _).symm

/-- info: 'ClosedLoopJoin.force_join' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms force_join

/-- info: 'ClosedLoopJoin.handshake_iff_sides' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms handshake_iff_sides

/-- info: 'ClosedLoopJoin.structural_contradiction' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms structural_contradiction

/-- info: 'ClosedLoopJoin.off_line_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms off_line_zero

/-- info: 'ClosedLoopJoin.rh_iff_force_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_force_zero

/-- info: 'ClosedLoopJoin.rh_iff_handshake' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms rh_iff_handshake

end ClosedLoopJoin
