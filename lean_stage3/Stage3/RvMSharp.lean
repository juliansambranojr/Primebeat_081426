/-
RvMSharp — the Riemann–von Mangoldt bound with the Stirling half's `log T` removed.

`rvM_crude` reads `Riemann_vonMangoldt_bound 112 0 698`: `112 = 97 + 15`, the `97` from the first-order
digamma band. With `Stirling2.backlundPhase_const` (`B₁ = 0`, `B₃ = 26`) the same assembly gives
`b₁ = 15` (`rvM_sharp`).
-/
import Stage3.ArgCount
import Stage3.Stirling2

namespace Stage3

/-- **Riemann–von Mangoldt, `b₁ = 15`.** -/
theorem rvM_sharp : riemannZeta.Riemann_vonMangoldt_bound 15 0 626 := by
  have h := Stage3.RvM_of_phase_arg Stirling2.backlundPhase_const
    (Stage3.backlundArg_of_identity Stage3.stmtArgIdentity_holds ArgCount.sCrude_holds)
  norm_num at h
  exact h

end Stage3

/-- info: 'Stage3.rvM_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs in
#print axioms Stage3.rvM_sharp
