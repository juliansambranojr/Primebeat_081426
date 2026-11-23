/-
JointWindowDial — joint 1 of `SECTIONS.md`: the Landau window onto the dial.
Block 1 of `lean_stage3/design/joints.md`. 2026-11-22.

The outlet of the Landau section, `LandauCriterion.stmtLandauWindow`, is the
inlet of the dial, `Stage3.StmtZeroFreeRight θ`. So a window bound on `G` at
`θ` gives everything the dial gives from a zero-free half-plane:

  zeroFreeRight_of_window        (0 < θ < 1) (0 < δ) (hW : WindowBound θ δ C) :
                                   StmtZeroFreeRight θ
  psiWeakTheta_of_window         (1/2 ≤ θ < 1) (0 < δ) (hW) :
                                   ∃ C' > 0, ∃ x₀, ∀ t ≥ x₀,
                                     |ψ(t) − t| ≤ C'·t^θ·log³t
  schoenfeldWeakTheta_of_window  (1/2 ≤ θ < 1) (0 < δ) (hW) :
                                   ∃ C' > 0, ∃ x₀, ∀ x ≥ x₀,
                                     |π(x) − Li(x)| ≤ C'·x^θ·log²x

No mathematics is added here. The window bound is a hypothesis and is proved
nowhere. `C'` and `x₀` are the dial's and are not explicit.

What the next slice needs: the last bound carried to the dyadic points
`x = 2^m`, the table's rows (joint 3).

Axioms: every pinned statement pins to [propext, Classical.choice, Quot.sound].
-/
import Stage3.LandauCriterion
import Stage3.ThetaPi

namespace JointWindowDial

noncomputable section

/-- For `0 < θ < 1` and `0 < δ`, a window bound on `G` at `θ` gives the zero-free half-plane
`StmtZeroFreeRight θ`: ζ has no zero with real part above `θ`. -/
theorem zeroFreeRight_of_window {θ δ C : ℝ} (hθ0 : 0 < θ) (hθ1 : θ < 1)
    (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
    Stage3.StmtZeroFreeRight θ :=
  fun s hs _ => LandauCriterion.stmtLandauWindow θ δ C hθ0 hθ1 hδ hW s hs

/-- For `1/2 ≤ θ < 1` and `0 < δ`, a window bound on `G` at `θ` gives `C' > 0` and `x₀` with
`|ψ(t) − t| ≤ C'·t^θ·log³ t` for all `t ≥ x₀`. -/
theorem psiWeakTheta_of_window {θ δ C : ℝ} (hθlo : 1 / 2 ≤ θ) (hθ1 : θ < 1)
    (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
    ∃ C' > 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t →
      |Chebyshev.psi t - t| ≤ C' * t ^ θ * Real.log t ^ 3 :=
  Stage3.psi_weak_of_theta (zeroFreeRight_of_window (by linarith) hθ1 hδ hW) hθlo hθ1

/-- For `1/2 ≤ θ < 1` and `0 < δ`, a window bound on `G` at `θ` gives `C' > 0` and `x₀` with
`|π(x) − Li(x)| ≤ C'·x^θ·log² x` for all `x ≥ x₀`. -/
theorem schoenfeldWeakTheta_of_window {θ δ C : ℝ} (hθlo : 1 / 2 ≤ θ)
    (hθ1 : θ < 1) (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
    ∃ C' > 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li :=
  Stage3.schoenfeldWeakTheta_of_zeroFree
    (zeroFreeRight_of_window (by linarith) hθ1 hδ hW) hθlo hθ1

/-- info: 'JointWindowDial.zeroFreeRight_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms zeroFreeRight_of_window

/-- info: 'JointWindowDial.psiWeakTheta_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms psiWeakTheta_of_window

/-- info: 'JointWindowDial.schoenfeldWeakTheta_of_window' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms schoenfeldWeakTheta_of_window

end

end JointWindowDial
