# `lean_stage3/Stage3/LandauCrude.lean`

**What it does** (its own header): LandauCrude — a crude bound on `G`: `|G(y)| ≤ 2y(1 + log y)²` for `y ≥ 1`. Block 5 of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauWindow`](../lean_stage3/LandauWindow.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauChebyshev`](../lean_stage3/LandauChebyshev.md).

```mermaid
flowchart LR
  n0["rampSum_nonneg<br/>⊢ 0 ≤ LandauWindow.rampSum y"]:::thm
  n1["sum_inv_le<br/>⊢ ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ ≤ 1 + Real.log N"]:::thm
  n2["rampSum_le<br/>⊢ LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y)"]:::thm
  n3["abs_G_le<br/>⊢ |LandauWindow.G y| ≤ 2 * y * (1 + Real.log y) ^ 2"]:::end_
  x0(["LandauChebyshev · neg_le_G"]):::ext
  x1(["LandauWindow · G"]):::ext
  x2(["LandauWindow · rampSum"]):::ext
  n0 --> n3
  n0 --> x0
  n1 --> n2
  n2 --> n3
  x1 --> n3
  x2 --> n0
  x2 --> n2
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
| `LandauCrude.rampSum_nonneg`<br/>theorem, line 31 | 0 ≤ LandauWindow.rampSum y | y : ℝ | — | `LandauWindow.rampSum` | `LandauChebyshev.neg_le_G`, `LandauCrude.abs_G_le` |
| `LandauCrude.sum_inv_le`<br/>theorem, line 37 | ∑ n ∈ Finset.range (N + 1), ((n : ℝ))⁻¹ ≤ 1 + Real.log N | N : ℕ | The reciprocals up to `N`, with the term at `0` (which is `0`). | — | `LandauCrude.rampSum_le` |
| `LandauCrude.rampSum_le`<br/>theorem, line 47 | LandauWindow.rampSum y ≤ y * Real.log y * (1 + Real.log y) | hy : 1 ≤ y | — | `LandauCrude.sum_inv_le`, `LandauWindow.rampSum` | `LandauCrude.abs_G_le` |
| `LandauCrude.abs_G_le`<br/>theorem, line 83 | \|LandauWindow.G y\| ≤ 2 * y * (1 + Real.log y) ^ 2 | hy : 1 ≤ y | — | `LandauCrude.rampSum_le`, `LandauCrude.rampSum_nonneg`, `LandauWindow.G` | — |
