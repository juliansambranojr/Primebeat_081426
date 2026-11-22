# `lean_stage3/Stage3/LandauChebyshev.lean`

**What it does** (its own header): LandauChebyshev — the bound on `G` of Chebyshev's order: `G y ≤ 8y` and `|G(y)| ≤ 8y(1 + log y)` for `y ≥ 1`. Block 5b of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauCrude`](../lean_stage3/LandauCrude.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauTaylor`](../lean_stage3/LandauTaylor.md).

```mermaid
flowchart LR
  n0["rampSum_le_log<br/>⊢ LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4))"]:::thm
  n1["log_four_lt_two<br/>⊢ Real.log 4 ＜ 2"]:::thm
  n2["G_le<br/>⊢ LandauWindow.G y ≤ 8 * y"]:::thm
  n3["neg_le_G<br/>⊢ -(y * Real.log y) ≤ LandauWindow.G y"]:::thm
  n4["abs_G_le_log<br/>⊢ |LandauWindow.G y| ≤ 8 * y * (1 + Real.log y)"]:::thm
  x0(["LandauCrude · rampSum_nonneg"]):::ext
  x1(["LandauPrimeSide · Ik_le"]):::ext
  x2(["LandauTaylor · integrand_norm_le"]):::ext
  x3(["LandauWindow · G"]):::ext
  x4(["LandauWindow · rampSum"]):::ext
  n0 --> n2
  n1 --> n2
  n2 --> n4
  n2 --> x1
  n3 --> n4
  n4 --> x2
  x0 --> n3
  x3 --> n2
  x3 --> n3
  x3 --> n4
  x4 --> n0
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
| `LandauChebyshev.rampSum_le_log`<br/>theorem, line 33 | LandauWindow.rampSum y ≤ y * (Real.log y + (Real.log 4 + 4)) | hy : 1 ≤ y | — | `LandauWindow.rampSum` | `LandauChebyshev.G_le` |
| `LandauChebyshev.log_four_lt_two`<br/>theorem, line 70 | Real.log 4 &lt; 2 | — | — | — | `LandauChebyshev.G_le` |
| `LandauChebyshev.G_le`<br/>theorem, line 76 | LandauWindow.G y ≤ 8 * y | hy : 1 ≤ y | — | `LandauChebyshev.log_four_lt_two`, `LandauChebyshev.rampSum_le_log`, `LandauWindow.G` | `LandauChebyshev.abs_G_le_log`, `LandauPrimeSide.Ik_le` |
| `LandauChebyshev.neg_le_G`<br/>theorem, line 84 | -(y * Real.log y) ≤ LandauWindow.G y | hy : 1 ≤ y | — | `LandauCrude.rampSum_nonneg`, `LandauWindow.G` | `LandauChebyshev.abs_G_le_log` |
| `LandauChebyshev.abs_G_le_log`<br/>theorem, line 93 | \|LandauWindow.G y\| ≤ 8 * y * (1 + Real.log y) | hy : 1 ≤ y | — | `LandauChebyshev.G_le`, `LandauChebyshev.neg_le_G`, `LandauWindow.G` | `LandauTaylor.integrand_norm_le` |
