# `lean_stage3/Stage3/WeilTiles.lean`

**What it does** (its own header): WeilTiles — the heights tiled by bands. Rung 4b, second half, slice B1 of the detection ladder (units 0316–0321). 2026-09-06.

**Imports:** [`WeilBands`](../lean_stage3/WeilBands.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilSeries`](../lean_stage3/WeilSeries.md).

```mermaid
flowchart LR
  n0["centre<br/>(def)"]:::dfn
  n1["idx<br/>(def)"]:::dfn
  n2["two_le_centre<br/>⊢ 2 ≤ centre k"]:::thm
  n3["idx_spec<br/>⊢ |t - centre (idx t)| ≤ 9 / 10"]:::thm
  n4["online_term_nonneg<br/>⊢ 0 ≤ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re"]:::thm
  n5["weightedTerm_nonneg<br/>⊢ 0 ≤ weightedTerm h γ ρ"]:::thm
  n6["sum_by_bands<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.Nontrivial…"]:::thm
  n7["bandSeries_nonneg<br/>⊢ 0 ≤ M k * (15 * Real.log (centre k) + 73)"]:::thm
  n8["sum_le_bandSeries<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k…"]:::thm
  n9["Upper<br/>(abbrev)"]:::dfn
  n10["tsum_upper_le<br/>⊢ ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (c…"]:::thm
  x0(["WeilBackground · online_term_eq"]):::ext
  x1(["WeilBackground · phiC"]):::ext
  x2(["WeilBands · band_sum_le"]):::ext
  x3(["WeilBands · weightedTerm"]):::ext
  x4(["WeilDetect · laplace"]):::ext
  x5(["WeilOnLine · A_le"]):::ext
  x6(["WeilOnLine · sum_upper_le"]):::ext
  x7(["WeilOnLine · summable_onLine"]):::ext
  x8(["WeilOnLine · tsum_onLine_le"]):::ext
  x9(["WeilPowerBands · A"]):::ext
  x10(["WeilPowerBands · A_le"]):::ext
  x11(["WeilPowerBands · M"]):::ext
  x12(["WeilPowerBands · bandSeries_le"]):::ext
  x13(["WeilPowerBands · bandSeries_summable"]):::ext
  x14(["WeilPowerBands · bandTerm_le_A"]):::ext
  x15(["WeilPowerBands · sum_by_bands"]):::ext
  x16(["WeilPowerBands · sum_le_bandSeries"]):::ext
  x17(["WeilPowerBands · termW_nonneg"]):::ext
  x18(["WeilPowerBands · term_le_M"]):::ext
  x19(["WeilPowerBands · tsum_upper_le"]):::ext
  x20(["WeilPowerBands · tsum_upper_le_explicit"]):::ext
  x21(["WeilPowerBands · tsum_upper_le_explicit'"]):::ext
  x22(["WeilSeries · A"]):::ext
  x23(["WeilSeries · M"]):::ext
  x24(["WeilSeries · bandSeries_le"]):::ext
  x25(["WeilSeries · bandSeries_summable"]):::ext
  x26(["WeilSeries · bandTerm_le_A"]):::ext
  x27(["WeilSeries · dist_ge"]):::ext
  x28(["WeilSeries · idx_le"]):::ext
  x29(["WeilSeries · term_le_M"]):::ext
  x30(["WeilSeries · tsum_upper_le_explicit"]):::ext
  x31(["WeilSeries · tsum_upper_le_explicit'"]):::ext
  x32(["WeilSeries · weight_le"]):::ext
  x33(["WeilSeries · weight_nonneg"]):::ext
  n0 --> n10
  n0 --> n2
  n0 --> n3
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> x12
  n0 --> x13
  n0 --> x14
  n0 --> x15
  n0 --> x16
  n0 --> x19
  n0 --> x24
  n0 --> x25
  n0 --> x26
  n0 --> x27
  n0 --> x32
  n0 --> x33
  n1 --> n10
  n1 --> n3
  n1 --> n6
  n1 --> n8
  n1 --> x10
  n1 --> x11
  n1 --> x14
  n1 --> x15
  n1 --> x16
  n1 --> x18
  n1 --> x19
  n1 --> x22
  n1 --> x23
  n1 --> x26
  n1 --> x27
  n1 --> x28
  n1 --> x29
  n1 --> x31
  n1 --> x5
  n1 --> x9
  n10 --> x30
  n2 --> n6
  n2 --> n7
  n2 --> x15
  n2 --> x32
  n2 --> x33
  n3 --> n6
  n3 --> x15
  n3 --> x27
  n4 --> n5
  n4 --> x17
  n5 --> n10
  n5 --> x7
  n5 --> x8
  n6 --> n8
  n7 --> n8
  n7 --> x13
  n7 --> x16
  n7 --> x25
  n8 --> n10
  n8 --> x6
  n9 --> n10
  n9 --> x19
  n9 --> x20
  n9 --> x21
  n9 --> x30
  n9 --> x31
  x0 --> n4
  x1 --> n10
  x1 --> n4
  x1 --> n6
  x1 --> n8
  x2 --> n6
  x3 --> n10
  x3 --> n5
  x3 --> n6
  x3 --> n8
  x4 --> n10
  x4 --> n4
  x4 --> n6
  x4 --> n8
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
| `WeilTiles.centre`<br/>def, line 41 | ℝ | k : ℕ | Band centres `2 + (9/5)·k`. | — | `WeilPowerBands.bandSeries_le`, `WeilPowerBands.bandSeries_summable`, `WeilPowerBands.bandTerm_le_A`, `WeilPowerBands.sum_by_bands`, `WeilPowerBands.sum_le_bandSeries`, `WeilPowerBands.tsum_upper_le`, `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.bandTerm_le_A`, `WeilSeries.dist_ge`, `WeilSeries.weight_le`, `WeilSeries.weight_nonneg`, `WeilTiles.bandSeries_nonneg`, `WeilTiles.idx_spec`, `WeilTiles.sum_by_bands`, `WeilTiles.sum_le_bandSeries`, `WeilTiles.tsum_upper_le`, `WeilTiles.two_le_centre` |
| `WeilTiles.idx`<br/>def, line 44 | ℕ | t : ℝ | Band index of a height `t`; meaningful for `t ≥ 11/10`. | — | `WeilOnLine.A_le`, `WeilPowerBands.A`, `WeilPowerBands.A_le`, `WeilPowerBands.M`, `WeilPowerBands.bandTerm_le_A`, `WeilPowerBands.sum_by_bands`, `WeilPowerBands.sum_le_bandSeries`, `WeilPowerBands.term_le_M`, `WeilPowerBands.tsum_upper_le`, `WeilSeries.A`, `WeilSeries.M`, `WeilSeries.bandTerm_le_A`, `WeilSeries.dist_ge`, `WeilSeries.idx_le`, `WeilSeries.term_le_M`, `WeilSeries.tsum_upper_le_explicit'`, `WeilTiles.idx_spec`, `WeilTiles.sum_by_bands`, `WeilTiles.sum_le_bandSeries`, `WeilTiles.tsum_upper_le` |
| `WeilTiles.two_le_centre`<br/>theorem, line 46 | 2 ≤ centre k | k : ℕ | — | `WeilTiles.centre` | `WeilPowerBands.sum_by_bands`, `WeilSeries.weight_le`, `WeilSeries.weight_nonneg`, `WeilTiles.bandSeries_nonneg`, `WeilTiles.sum_by_bands` |
| `WeilTiles.idx_spec`<br/>theorem, line 52 | \|t - centre (idx t)\| ≤ 9 / 10 | ht : 11 / 10 ≤ t | Every height `t ≥ 11/10` lies within `9/10` of its band centre. | `WeilTiles.centre`, `WeilTiles.idx` | `WeilPowerBands.sum_by_bands`, `WeilSeries.dist_ge`, `WeilTiles.sum_by_bands` |
| `WeilTiles.online_term_nonneg`<br/>theorem, line 67 | 0 ≤ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re | hh : 0 &lt; h; γ : ℝ; hρ : ρ.re = 1 / 2 | The on-line term is a real square, hence nonnegative. | `WeilBackground.online_term_eq`, `WeilBackground.phiC`, `WeilDetect.laplace` | `WeilPowerBands.termW_nonneg`, `WeilTiles.weightedTerm_nonneg` |
| `WeilTiles.weightedTerm_nonneg`<br/>theorem, line 72 | 0 ≤ weightedTerm h γ ρ | hh : 0 &lt; h; γ : ℝ; ρ : Kadiri.NontrivialZeros; hρ : (ρ : ℂ).re = 1 / 2 | — | `WeilBands.weightedTerm`, `WeilTiles.online_term_nonneg` | `WeilOnLine.summable_onLine`, `WeilOnLine.tsum_onLine_le`, `WeilTiles.tsum_upper_le` |
| `WeilTiles.sum_by_bands`<br/>theorem, line 81 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑ k ∈ S.image (fun ρ : Kadiri.NontrivialZeros =&gt; idx (ρ : ℂ).im), M k * (15 * Real.log (centre k) + 73) | S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im; M : ℕ → ℝ; hM0 : ∀ k, 0 ≤ M k; hM : ∀ ρ ∈ S, (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M (idx (ρ : ℂ).im) | Sum by bands. A finite set of on-line zeros of height `≥ 11/10`, split by band index, has weighted sum at most the band series over the indices that occur. | `WeilBackground.phiC`, `WeilBands.band_sum_le`, `WeilBands.weightedTerm`, `WeilDetect.laplace`, `WeilTiles.centre`, `WeilTiles.idx`, `WeilTiles.idx_spec`, `WeilTiles.two_le_centre` | `WeilTiles.sum_le_bandSeries` |
| `WeilTiles.bandSeries_nonneg`<br/>theorem, line 108 | 0 ≤ M k * (15 * Real.log (centre k) + 73) | M : ℕ → ℝ; hM0 : ∀ k, 0 ≤ M k; k : ℕ | — | `WeilTiles.centre`, `WeilTiles.two_le_centre` | `WeilPowerBands.bandSeries_summable`, `WeilPowerBands.sum_le_bandSeries`, `WeilSeries.bandSeries_summable`, `WeilTiles.sum_le_bandSeries` |
| `WeilTiles.sum_le_bandSeries`<br/>theorem, line 115 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) | S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im; M : ℕ → ℝ; hM0 : ∀ k, 0 ≤ M k; hM : ∀ ρ ∈ S, (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M (idx (ρ : ℂ).im); hsum : Summable (fun k : ℕ =&gt; M k * (15 * Real.log (centre k) + 73)) | A finite on-line sum of height `≥ 11/10` is at most the full band series. | `WeilBackground.phiC`, `WeilBands.weightedTerm`, `WeilDetect.laplace`, `WeilTiles.bandSeries_nonneg`, `WeilTiles.centre`, `WeilTiles.idx`, `WeilTiles.sum_by_bands` | `WeilOnLine.sum_upper_le`, `WeilTiles.tsum_upper_le` |
| `WeilTiles.Upper`<br/>abbrev, line 126 | Type | — | On-line zeros of height at least `11/10`. | — | `WeilPowerBands.tsum_upper_le`, `WeilPowerBands.tsum_upper_le_explicit`, `WeilPowerBands.tsum_upper_le_explicit'`, `WeilSeries.tsum_upper_le_explicit`, `WeilSeries.tsum_upper_le_explicit'`, `WeilTiles.tsum_upper_le` |
| `WeilTiles.tsum_upper_le`<br/>theorem, line 132 | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) | hh : 0 &lt; h; M : ℕ → ℝ; hM0 : ∀ k, 0 ≤ M k; hM : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re = 1 / 2 → 11 / 10 ≤ (ρ : ℂ).im → (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M (idx (ρ : ℂ).im); hsum : Summable (fun k : ℕ =&gt; M k * (15 * Real.log (centre k) + 73)) | Upper on-line sum. The full weighted sum over on-line zeros of height `≥ 11/10` is at most the band series, for any nonnegative summable `M` dominating the terms at their band indices. | `WeilBackground.phiC`, `WeilBands.weightedTerm`, `WeilDetect.laplace`, `WeilTiles.Upper`, `WeilTiles.centre`, `WeilTiles.idx`, `WeilTiles.sum_le_bandSeries`, `WeilTiles.weightedTerm_nonneg` | `WeilSeries.tsum_upper_le_explicit` |
