> Source: session transcript, 2026-09-06 (this session), the orchestrator's design turn for block 13f

> Ok go

> What would happen naturally if we keep going the way we planned. Meaning that route exists and if so, why? If it doesn’t close, why would it need to stay open? And if so what relies on it being open

> Ok log it but don’t start on 13f yet

From `lean_stage3/design/rung5.md` § 13 before this unit, the split the finding is about:

```
Members split by
`Δ_i h₀`: below `7` the phase is under `0.2·7 = 1.4` radians at `λ = 1` and
the term is negative; above, the phase turns and Abel summation bounds
`|Σ_h w_h|g_i|² cos 2φ_i|` by `(max + total variation of w_h|g_i|²)·π/ω_i`,
while the target contributes at least `H − h₀`.
```

From `lean_stage3/Stage3/ArgCrude.lean`, the statement the route now hangs on:

```
def StmtSCrude (S : ℝ → ℝ) (B₁ B₃ : ℝ) : Prop :=
  ∀ T : ℝ, 2 ≤ T → |S T| ≤ B₁ * Real.log T + B₃
```
