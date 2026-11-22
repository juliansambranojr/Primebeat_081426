# `lean_stage3/Stage3/WeilPowerSigma.lean`

**What it does** (its own header): WeilPowerSigma — the tail sum to order `1/m`: `σ(m) = Σ_{j≥m+2} 1/(π²j²)` bracketed sharply enough that `u m = (m+1)²σ(m)` is `(m+½)/π²` plus a correction of size `1/m`. Rung 5, thirteenth slice; worksheet § 13 block 13c. 2026-09-06.

**Imports:** [`WeilPowerPhase`](../lean_stage3/WeilPowerPhase.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerGeomGen`](../lean_stage3/WeilPowerGeomGen.md).

```mermaid
flowchart LR
  n0["sum_telescope_half<br/>⊢ ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2…"]:::thm
  n1["sum_upper_half<br/>⊢ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 2 / (2 * (m : ℝ) +…"]:::thm
  n2["sum_telescope_amgm<br/>⊢ ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, ((1 / ((j : ℝ) + 1) -…"]:::thm
  n3["sum_lower_amgm<br/>⊢ 1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / ((n : ℝ) + 1) - …"]:::thm
  n4["sigma_le_half<br/>⊢ sigma m ≤ 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3))"]:::thm
  n5["sigma_ge_amgm<br/>⊢ 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + …"]:::thm
  n6["u<br/>(def)"]:::dfn
  n7["u_def<br/>⊢ u m = ((m : ℝ) + 1) ^ 2 * sigma m"]:::thm
  n8["r_pos<br/>⊢ 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ u m - ((m : ℝ) + 1 / 2) / …"]:::thm
  n9["r_le<br/>⊢ u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (m : ℝ…"]:::thm
  n10["u_mono<br/>⊢ u m ≤ u (m + 1)"]:::end_
  x0(["WeilPowerGeomGen · uLam_bracket"]):::ext
  x1(["WeilPowerGeomGen · uLam_eq"]):::ext
  x2(["WeilPowerPhase · sigma"]):::ext
  x3(["WeilPowerPhase · sigmaN_eq"]):::ext
  x4(["WeilPowerPhase · sigmaN_tendsto"]):::ext
  n0 --> n1
  n1 --> n4
  n2 --> n3
  n3 --> n5
  n4 --> n9
  n5 --> n8
  n6 --> n10
  n6 --> n7
  n6 --> n8
  n6 --> n9
  n6 --> x0
  n6 --> x1
  n7 --> n8
  n7 --> n9
  n7 --> x1
  n8 --> n10
  n8 --> x0
  n9 --> n10
  n9 --> x0
  x2 --> n4
  x2 --> n5
  x2 --> n6
  x2 --> n7
  x3 --> n4
  x3 --> n5
  x4 --> n4
  x4 --> n5
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
| `WeilPowerSigma.sum_telescope_half`<br/>theorem, line 58 | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, (1 / ((j : ℝ) + 1 / 2) - 1 / ((j : ℝ) + 3 / 2)) = 1 / ((m : ℝ) + 3 / 2) - 1 / ((n : ℝ) + 1 / 2) | m : ℕ | Telescoping the half-shifted differences. | — | `WeilPowerSigma.sum_upper_half` |
| `WeilPowerSigma.sum_upper_half`<br/>theorem, line 73 | ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 ≤ 2 / (2 * (m : ℝ) + 3) | m : ℕ; hn : m + 1 ≤ n | The sharp upper bound for the tail sum, `2/(2m+3)`. | `WeilPowerSigma.sum_telescope_half` | `WeilPowerSigma.sigma_le_half` |
| `WeilPowerSigma.sum_telescope_amgm`<br/>theorem, line 98 | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, ((1 / ((j : ℝ) + 1) - 1 / ((j : ℝ) + 2)) + (1 / (2 * ((j : ℝ) + 1) ^ 2) - 1 / (2 * ((j : ℝ) + 2) ^ 2))) = (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) + (1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / (2 * ((n : ℝ) + 1) ^ 2)) | m : ℕ | Telescoping the AM–GM differences. | — | `WeilPowerSigma.sum_lower_amgm` |
| `WeilPowerSigma.sum_lower_amgm`<br/>theorem, line 116 | 1 / ((m : ℝ) + 2) + 1 / (2 * ((m : ℝ) + 2) ^ 2) - 1 / ((n : ℝ) + 1) - 1 / (2 * ((n : ℝ) + 1) ^ 2) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 | m : ℕ; hn : m + 1 ≤ n | The sharp lower bound for the tail sum, to order `1/n²` on both ends. | `WeilPowerSigma.sum_telescope_amgm` | `WeilPowerSigma.sigma_ge_amgm` |
| `WeilPowerSigma.sigma_le_half`<br/>theorem, line 140 | sigma m ≤ 2 / (Real.pi ^ 2 * (2 * (m : ℝ) + 3)) | m : ℕ | `σ` from above, `2/(π²(2m+3))`: sharper than unit 0347's `1/(π²(m+1))`. | `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.sigmaN_tendsto`, `WeilPowerSigma.sum_upper_half` | `WeilPowerSigma.r_le` |
| `WeilPowerSigma.sigma_ge_amgm`<br/>theorem, line 154 | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) + 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ sigma m | m : ℕ | `σ` from below, with the `1/m²` term: sharper than unit 0347's `1/(π²(m+2))`. | `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.sigmaN_tendsto`, `WeilPowerSigma.sum_lower_amgm` | `WeilPowerSigma.r_pos` |
| `WeilPowerSigma.u`<br/>def, line 187 | ℝ | m : ℕ | The normalized tail sum `u m = (m+1)²σ(m)`, the exponent's shape at `λ = 1`. | `WeilPowerPhase.sigma` | `WeilPowerGeomGen.uLam_bracket`, `WeilPowerGeomGen.uLam_eq`, `WeilPowerSigma.r_le`, `WeilPowerSigma.r_pos`, `WeilPowerSigma.u_def`, `WeilPowerSigma.u_mono` |
| `WeilPowerSigma.u_def`<br/>theorem, line 189 | u m = ((m : ℝ) + 1) ^ 2 * sigma m | m : ℕ | — | `WeilPowerPhase.sigma`, `WeilPowerSigma.u` | `WeilPowerGeomGen.uLam_eq`, `WeilPowerSigma.r_le`, `WeilPowerSigma.r_pos` |
| `WeilPowerSigma.r_pos`<br/>theorem, line 192 | 1 / (2 * Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2) ≤ u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 | m : ℕ | The correction is positive, at least `1/(2π²(m+2)²)`. | `WeilPowerSigma.sigma_ge_amgm`, `WeilPowerSigma.u`, `WeilPowerSigma.u_def` | `WeilPowerGeomGen.uLam_bracket`, `WeilPowerSigma.u_mono` |
| `WeilPowerSigma.r_le`<br/>theorem, line 208 | u m - ((m : ℝ) + 1 / 2) / Real.pi ^ 2 ≤ 1 / (Real.pi ^ 2 * (4 * (m : ℝ) + 6)) | m : ℕ | The correction is `O(1/m)`, at most `1/(π²(4m+6))`. | `WeilPowerSigma.sigma_le_half`, `WeilPowerSigma.u`, `WeilPowerSigma.u_def` | `WeilPowerGeomGen.uLam_bracket`, `WeilPowerSigma.u_mono` |
| `WeilPowerSigma.u_mono`<br/>theorem, line 223 | u m ≤ u (m + 1) | m : ℕ | `u` is increasing: the step `1/π²` beats the correction's whole range. | `WeilPowerSigma.r_le`, `WeilPowerSigma.r_pos`, `WeilPowerSigma.u` | — |
