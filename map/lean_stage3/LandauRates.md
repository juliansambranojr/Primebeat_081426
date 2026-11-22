# `lean_stage3/Stage3/LandauRates.lean`

LandauRates — the scalar inequalities of the assembly. Block 7c of `lean_stage3/design/landau.md`. 2026-11-22.

3 theorems, 0 definitions, 114 lines. Arrows are Lean's own record of what each proof uses.

**Imports:** nothing in this tree  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauCriterion`](../lean_stage3/LandauCriterion.md)

## The picture

```mermaid
flowchart LR
  n0["<b>key_ineq</b><br/>4 * (lam - Real.log (1 - δ / 12)) ＜ (1 + δ) * (Real.log (1 + δ /…"]:::thm
  n1["<b>exists_centre</b><br/>∃ σ₀ : ℝ, 1 ＜ σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ＜ σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ …"]:::thm
  n2["<b>exists_pow_small</b><br/>∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k ＜ ε"]:::thm
  x0(["<b>LandauCriterion</b><br/>contradiction<br/>stmtLandauWindow"]):::ext
  n0 -.-> x0
  n1 -.-> x0
  n2 -.-> x0
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "A is used in the proof of B". Blue: theorem. Green: a theorem nothing else uses (an end). Dashed: connects to nothing. Red: contains `sorry`. Yellow: theorems in another file, counted; a dotted arrow crosses files. Definitions are not drawn; they are listed below the diagram.

## Theorems

<a name="LandauRates-key_ineq"></a>
### `LandauRates.key_ineq`

line 30

**Proves**

```lean
4 * (lam - Real.log (1 - δ / 12)) < (1 + δ) * (Real.log (1 + δ / 3) - lam) ∧ 0 < Real.log (1 + δ / 3) - lam ∧ 0 < lam - Real.log (1 - δ / 12)
```

**Needs** (its hypotheses)

  - `` hδ0 : 0 < δ ``
  - `` hδ1 : δ ≤ 1 ``
  - `` hl0 : 0 ≤ lam ``
  - `` hl : lam ≤ δ ^ 2 / 240 ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`LandauCriterion.contradiction`](../lean_stage3/LandauCriterion.md#LandauCriterion-contradiction) (LandauCriterion) — `` False ``

<a name="LandauRates-exists_centre"></a>
### `LandauRates.exists_centre`

line 64

**Proves**

```lean
∃ σ₀ : ℝ, 1 < σ₀ ∧ ‖(σ₀ : ℂ) - ρ₀‖ < σ₀ - θ ∧ ‖(σ₀ : ℂ) - ρ₀‖ ≤ (σ₀ - 1) * (1 + δ ^ 2 / 240)
```

**Needs** (its hypotheses)

  - `` hθ0 : 0 ≤ θ ``
  - `` hθ : θ < ρ₀.re ``
  - `` h1 : ρ₀.re < 1 ``
  - `` hδ : 0 < δ ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`LandauCriterion.stmtLandauWindow`](../lean_stage3/LandauCriterion.md#LandauCriterion-stmtLandauWindow) (LandauCriterion) — `` LandauWindow.StmtLandauWindow ``

<a name="LandauRates-exists_pow_small"></a>
### `LandauRates.exists_pow_small`

line 93

**Proves**

```lean
∃ K : ℕ, ∀ k : ℕ, K ≤ k → c * q ^ k < ε
```

**Needs** (its hypotheses)

  - `` hq0 : 0 ≤ q ``
  - `` hq1 : q < 1 ``
  - `` hε : 0 < ε ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`LandauCriterion.contradiction`](../lean_stage3/LandauCriterion.md#LandauCriterion-contradiction) (LandauCriterion) — `` False ``

