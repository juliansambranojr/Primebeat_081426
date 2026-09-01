/-
Abscissa — the contour's abscissa as a parameter, with RH as one instance.

WHY THIS FILE EXISTS. `lean_stage3/Stage3/LineBound.lean:1091` defines

    noncomputable def σRH (X : ℝ) : ℝ := 1 / 2 + 1 / Real.log X

with `1/2` a LITERAL inside a `def`, and RH enters the whole apparatus
through one lemma, `zeta_ne_zero_of_RH` (`LineBound.lean:23`), whose
only job is `ζ ≠ 0` to the right of that abscissa. Everything
downstream — the Perron pull, the vertical `I₃₇` bound, the
horizontals, the Mellin work — is abscissa-agnostic arithmetic that
already compiles. So the hypothesis is welded into a definition rather
than carried as a parameter, and that is a choice, not a necessity.

This module parameterises it:

    σθ θ X = θ + 1/log X                the abscissa, with θ free
    StmtZeroFreeRight θ                 no zeros with re > θ (bar s = 1)
    zeta_ne_zero_right_of               the consumer lemma, from that Prop
    zeroFreeRight_of_RH                 RH ⟹ StmtZeroFreeRight (1/2)
    σθ_half                             σθ (1/2) = σRH, verbatim

`σθ_half` is the weld: at `θ = 1/2` the parameterised abscissa is
DEFINITIONALLY the old one, so nothing downstream regresses, and
`zeroFreeRight_of_RH` makes RH the `θ = 1/2` instance of a statement
that has other instances.

WHY THIS IS WORTH BUILDING. Entry 277 measured the census's real
requirement shape-free: it needs a POWER SAVING, and depth 6 is closed
by `|π − li| ≤ x^0.7464` — strictly weaker than RH and not known to
imply it. A θ-parameterised contour machine is the apparatus that
consumes such a hypothesis. Entry 283 showed the constants side is
measurable rather than notional.

THE CONVERSE. `StmtZeroFreeRight (1/2) → RiemannHypothesis` also holds
— a zero left of the line reflects through `ArgIdentity.xi_one_sub` to
one right of it — but it is NOT proved here and no theorem below
pretends to. Nothing consumes it: the machine only ever USES a
zero-free half-plane, never produces one, so proving it would buy an
`ArgIdentity` dependency and no caller.

WHAT THIS DOES NOT CLAIM. No `θ < 1` power saving is proved by anyone;
de la Vallée Poussin gives `exp(−c√log x)`, which is not a power, and
entry 277 recorded every proved zero-free region yielding
`depth_covered = 0`. The interval `(1/2, 1)` is open. This file does not
enter it — it removes the reason the existing machine could not be
pointed at it.

Companion to notes entries 230, 240, 277, 283, 284.
-/
import Mathlib
import Stage3.LineBound

namespace Stage3

open Complex

noncomputable section

local notation "ζ" => riemannZeta

/-! ## The abscissa, with the exponent free -/

/-- **The parameterised abscissa.** `σθ θ X = θ + 1/log X`. The existing
`RHPull.σRH` is the `θ = 1/2` case. -/
def σθ (θ X : ℝ) : ℝ := θ + 1 / Real.log X

/-- **The weld.** At `θ = 1/2` this is the abscissa the built machine
already uses, definitionally. -/
theorem σθ_half (X : ℝ) : σθ (1/2) X = RHPull.σRH X := rfl

theorem σθ_re (θ X t : ℝ) : ((σθ θ X : ℂ) + I * (t : ℂ)).re = σθ θ X := by
  simp [σθ]

/-! ## The hypothesis the abscissa actually needs -/

/-- **A zero-free half-plane at `θ`.** This is the whole content the
contour pull requires: nothing vanishes strictly to the right of `θ`,
the pole at `s = 1` excepted. RH is the case `θ = 1/2`. -/
def StmtZeroFreeRight (θ : ℝ) : Prop :=
  ∀ s : ℂ, θ < s.re → s ≠ 1 → ζ s ≠ 0

/-- **The consumer lemma, in the shape the machine uses.** Mirrors
`RHPull.zeta_ne_zero_of_RH` with the hypothesis carried as a parameter
rather than as RH. -/
theorem zeta_ne_zero_right_of {θ : ℝ} (hθ : StmtZeroFreeRight θ) {s : ℂ}
    (hs : θ < s.re) (hs1 : s ≠ 1) : ζ s ≠ 0 :=
  hθ s hs hs1

/-- **RH is the `θ = 1/2` instance.** The proof is
`RHPull.zeta_ne_zero_of_RH`'s, unchanged — which is the point: the
lemma never needed RH as such, only a zero-free half-plane. -/
theorem zeroFreeRight_of_RH (hRH : RiemannHypothesis) :
    StmtZeroFreeRight (1/2) := by
  intro s hs hs1
  exact RHPull.zeta_ne_zero_of_RH hRH hs hs1

/-- **A weaker exponent is a weaker hypothesis.** Moving the half-plane
right only removes obligations, so the family is monotone in `θ` — this
is what makes `θ` a dial rather than a relabelling. -/
theorem zeroFreeRight_mono {θ θ' : ℝ} (h : θ ≤ θ')
    (hθ : StmtZeroFreeRight θ) : StmtZeroFreeRight θ' :=
  fun s hs hs1 => hθ s (lt_of_le_of_lt h hs) hs1

/-- **The unconditional endpoint.** `θ = 1` holds outright, from
Mathlib's non-vanishing on the closed half-plane `1 ≤ re s`. So the
family is non-empty and the open question is exactly how far left of
`1` it can be pushed. -/
theorem zeroFreeRight_one : StmtZeroFreeRight 1 :=
  fun _ hs _ => riemannZeta_ne_zero_of_one_le_re (le_of_lt hs)

end

/-! ## Axiom check

Each `#guard_msgs` block pins the exact axiom list of one result: if a proof
ever starts depending on anything not listed, the docstring stops matching the
compiler and **`lake build` fails**. This is a check, not a printout.
-/

/-- info: 'Stage3.σθ_half' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.σθ_half

/-- info: 'Stage3.zeta_ne_zero_right_of' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeta_ne_zero_right_of

/-- info: 'Stage3.zeroFreeRight_of_RH' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_of_RH

/-- info: 'Stage3.zeroFreeRight_mono' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_mono

/-- info: 'Stage3.zeroFreeRight_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.zeroFreeRight_one

end Stage3
