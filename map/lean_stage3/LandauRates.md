# `lean_stage3/Stage3/LandauRates.lean`

**What it does** (its own header): LandauRates — the scalar inequalities of the assembly. Block 7c of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauCriterion`](../lean_stage3/LandauCriterion.md).

```mermaid
flowchart LR
  n0["key_ineq<br/>⊢ 4 * (lam - Real.log (1 - δ / 12)) ＜ (1 + δ) * (Real.log (1 + δ / 3) - …"]:::thm
  n1["exists_centre<br/>⊢ ∃ σ₀ : ℝ, 1 ＜ σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ＜ σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - …"]:::thm
  n2["exists_pow_small<br/>⊢ ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k ＜ ε"]:::thm
  x0(["LandauCriterion · contradiction"]):::ext
  x1(["LandauCriterion · stmtLandauWindow"]):::ext
  n0 --> x0
  n1 --> x1
  n2 --> x0
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
| `LandauRates.key_ineq`<br/>theorem, line 30 | 4 * (lam - Real.log (1 - δ / 12)) &lt; (1 + δ) * (Real.log (1 + δ / 3) - lam) ∧ 0 &lt; Real.log (1 + δ / 3) - lam ∧ 0 &lt; lam - Real.log (1 - δ / 12) | hδ0 : 0 &lt; δ; hδ1 : δ ≤ 1; hl0 : 0 ≤ lam; hl : lam ≤ δ ^ 2 / 240 | — | — | `LandauCriterion.contradiction` |
| `LandauRates.exists_centre`<br/>theorem, line 64 | ∃ σ₀ : ℝ, 1 &lt; σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ &lt; σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240) | hθ0 : 0 ≤ θ; hθ : θ &lt; ρ₀.re; h1 : ρ₀.re &lt; 1; hδ : 0 &lt; δ | — | — | `LandauCriterion.stmtLandauWindow` |
| `LandauRates.exists_pow_small`<br/>theorem, line 93 | ∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k &lt; ε | hq0 : 0 ≤ q; hq1 : q &lt; 1; hε : 0 &lt; ε | — | — | `LandauCriterion.contradiction` |
