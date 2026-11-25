> Source: session transcript, 2026-11-25

> Yes to all

From `lean_stage3/Stage3/DiagMain.lean`, the statement the main term now rests on:

```
def StmtSdiagLead (P : Polynomial ℝ) (θ R κ : ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ α β : ℂ, Regime κ T α β →
    ‖Sdiag (Mof T θ) (aY P T θ R) (sig0 T R) α β 0 -
      IY P (Mof T θ) α β / (Real.log (Mof T θ) : ℂ)‖ ≤ ε / Real.log T
```
