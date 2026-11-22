# `lean_stage3/Stage3/CellModes.lean`

**What it does** (its own header): CellModes — block T1 of `lean_stage3/design/joints.md`, second part. 2026-11-22.

**Imports:** [`CellZeros`](../lean_stage3/CellZeros.md), [`Superposition`](../lean_stage3/TablePort_Superposition.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md).

```mermaid
flowchart LR
  n0["mode_two_int<br/>⊢ Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r"]:::thm
  n1["sym_two<br/>⊢ Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹"]:::thm
  n2["cell_eq_modeSum<br/>⊢ ‖CellZeros.stencil d (fun n : ℤ =＞ (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r …"]:::end_
  x0(["Chain · Sym"]):::ext
  x1(["Chain · mode"]):::ext
  x2(["Superposition · modeSum"]):::ext
  x3(["CellZeros · cell_eq_zero_sum"]):::ext
  x4(["CellZeros · stencil"]):::ext
  x5(["GlueNum · c1n"]):::ext
  x6(["GlueNum · c3n"]):::ext
  x7(["GlueNum · c4n"]):::ext
  n0 --> n2
  n1 --> n2
  x0 --> n1
  x0 --> n2
  x1 --> n0
  x1 --> n2
  x2 --> n2
  x3 --> n2
  x4 --> n2
  x5 --> n2
  x6 --> n2
  x7 --> n2
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
| `CellModes.mode_two_int`<br/>theorem, line 34 | Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r | ρ : ℂ; r : ℤ | — | `Chain.mode` | `CellModes.cell_eq_modeSum` |
| `CellModes.sym_two`<br/>theorem, line 42 | Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ | ρ : ℂ | — | `Chain.Sym` | `CellModes.cell_eq_modeSum` |
| `CellModes.cell_eq_modeSum`<br/>theorem, line 48 | ‖CellZeros.stencil d (fun n : ℤ =&gt; (Chebyshev.psi ((2:ℝ) ^ n) : ℂ)) r - Chain.Sym 2 1 ^ d * Chain.mode 2 1 (r : ℂ) + Superposition.modeSum 2 (fun ρ : {ρ : Kadiri.NontrivialZeros // \|(ρ : ℂ).im\| &lt; T} =&gt; ((ρ : Kadiri.NontrivialZeros) : ℂ)) (fun ρ =&gt; ((riemannZeta.order ((ρ : Kadiri.NontrivialZeros) : ℂ) : ℤ) : ℂ) / ((ρ : Kadiri.NontrivialZeros) : ℂ) * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d) Finset.univ (r : ℂ)‖ ≤ ∑ j ∈ range (d + 1), (d.choose j : ℝ) * (Glue.c1n * (2:ℝ) ^ (r - (j : ℤ)) * Real.log ((2:ℝ) ^ (r - (j : ℤ)) * T) ^ 2 / T + Glue.c3n * Real.log ((2:ℝ) ^ (r - (j : ℤ))) + Glue.c4n * ((Real.log ((2:ℝ) ^ (r - (j : ℤ)))) ^ 2 * ((2:ℝ) ^ (r - (j : ℤ))) ^ (-(1:ℝ) / 4))) | d : ℕ; r : ℤ; h16 : 16 ≤ (2:ℝ) ^ (r - (d : ℤ)); hT : 2 ≤ T; hTx : T ≤ ((2:ℝ) ^ (r - (d : ℤ))) ^ 2 | The cell as a reweighted sum of modes, one for each zero. | `Chain.Sym`, `Chain.mode`, `Superposition.modeSum`, `CellModes.mode_two_int`, `CellModes.sym_two`, `CellZeros.cell_eq_zero_sum`, `CellZeros.stencil`, `Glue.c1n`, `Glue.c3n`, `Glue.c4n` | — |
