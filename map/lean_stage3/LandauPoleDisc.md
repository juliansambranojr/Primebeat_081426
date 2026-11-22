# `lean_stage3/Stage3/LandauPoleDisc.lean`

**What it does** (its own header): LandauPoleDisc — the derivatives of `Phi` at a regular point, from the zeros of `ζ` in a disc around it. Block 3b2 of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauPoleLocal`](../lean_stage3/LandauPoleLocal.md), [`LandauPoleSub`](../lean_stage3/LandauPoleSub.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauZeroSide`](../lean_stage3/LandauZeroSide.md).

```mermaid
flowchart LR
  n0["Phi_taylor_on_disc<br/>⊢ ∃ (P : Finset ℂ) (C : ℝ), (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ rieman…"]:::thm
  x0(["LandauMellinG · Phi"]):::ext
  x1(["LandauPoleLocal · Phi_principal_part"]):::ext
  x2(["LandauPoleLocal · Phi_regular_at_one"]):::ext
  x3(["LandauPoleLocal · differentiableAt_Phi"]):::ext
  x4(["LandauPoleSub · exists_differentiableOn_sub_poles"]):::ext
  x5(["LandauPoleSub · taylor_coeff_sub_poles"]):::ext
  x6(["LandauZeroSide · zero_side"]):::ext
  n0 --> x6
  x0 --> n0
  x1 --> n0
  x2 --> n0
  x3 --> n0
  x4 --> n0
  x5 --> n0
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef dfn fill:#f2f2f2,stroke:#777,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111,stroke-dasharray:2 2
```

Blue: theorem. Green: a theorem nothing else uses (an end). Dashed white: connects to nothing. Grey: definition. Red: contains `sorry`. Yellow: in another file. An arrow A → B reads "A is used by B".

## Every declaration

| declaration | proves (output) | needs (input) | why (its own docstring) | uses | used by |
|---|---|---|---|---|---|
| `LandauPoleDisc.Phi_taylor_on_disc`<br/>theorem, line 36 | ∃ (P : Finset ℂ) (C : ℝ), (∀ ρ, ρ ∈ P ↔ ρ ∈ ball c R₂ ∧ ρ ≠ 1 ∧ riemannZeta ρ = 0) ∧ ∀ k : ℕ, ‖iteratedDeriv k LandauMellinG.Phi c - ∑ ρ ∈ P, (analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ)) * ((-1) ^ k * (k.factorial : ℂ) * (c - ρ) ^ (-1 - (k : ℤ)))‖ ≤ k.factorial * C / R ^ k | hR : 0 &lt; R; hRR : R &lt; R₂; hpos : closedBall c R₂ ⊆ {s : ℂ \| 0 &lt; s.re}; hc1 : c ≠ 1; hcz : riemannZeta c ≠ 0 | — | `LandauMellinG.Phi`, `LandauPoleLocal.Phi_principal_part`, `LandauPoleLocal.Phi_regular_at_one`, `LandauPoleLocal.differentiableAt_Phi`, `LandauPoleSub.exists_differentiableOn_sub_poles`, `LandauPoleSub.taylor_coeff_sub_poles` | `LandauZeroSide.zero_side` |
