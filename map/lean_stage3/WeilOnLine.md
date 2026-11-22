# `lean_stage3/Stage3/WeilOnLine.lean`

**What it does** (its own header): WeilOnLine — the on-line background, all heights. Rung 4b, second half, slice B3 of the detection ladder (units 0316–0323). 2026-09-06.

**Imports:** [`WeilSeries`](../lean_stage3/WeilSeries.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerOnLine`](../lean_stage3/WeilPowerOnLine.md).

```mermaid
flowchart LR
  n0["Psi_neg<br/>⊢ WeilTransform.Psi (-s) = -WeilTransform.Psi s"]:::thm
  n1["term_conj<br/>⊢ (laplace (phiC h γ) (-(starRingEnd ℂ) ρ) * laplace (phiC h γ) (-(1 - (…"]:::thm
  n2["conj_mem<br/>⊢ (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros"]:::thm
  n3["conjZ<br/>(def)"]:::dfn
  n4["conjZ_injective<br/>⊢ Function.Injective conjZ"]:::thm
  n5["weightedTerm_conjZ<br/>⊢ weightedTerm h γ (conjZ ρ) = weightedTerm h γ ρ"]:::thm
  n6["B<br/>(def)"]:::dfn
  n7["sum_upper_le<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ"]:::thm
  n8["sum_lower_le<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ"]:::thm
  n9["lowSet<br/>(def)"]:::dfn
  n10["lowU<br/>(def)"]:::dfn
  n11["lowU_preconnected<br/>⊢ IsPreconnected lowU"]:::thm
  n12["lowU_analytic<br/>⊢ AnalyticOnNhd ℂ riemannZeta lowU"]:::thm
  n13["lowSet_finite<br/>⊢ lowSet.Finite"]:::end_
  n14["lowCount<br/>(def)"]:::dfn
  n15["lowCount_nonneg<br/>⊢ 0 ≤ lowCount"]:::end_
  n16["sum_low_le<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount"]:::thm
  n17["onLineBound<br/>(def)"]:::dfn
  n18["sum_onLine_le<br/>⊢ ∑ ρ ∈ S, weightedTerm h γ ρ ≤ onLineBound h γ"]:::thm
  n19["OnLine<br/>(abbrev)"]:::dfn
  n20["sum_onLine_subtype_le<br/>⊢ ∑ ρ ∈ s, weightedTerm h γ ρ.1 ≤ onLineBound h γ"]:::thm
  n21["tsum_onLine_le<br/>⊢ ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ"]:::end_
  n22["summable_onLine<br/>⊢ Summable (fun ρ : OnLine =＞ weightedTerm h γ ρ.1)"]:::end_
  n23["A_le<br/>⊢ A h γ ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2)"]:::thm
  n24["onLineBound_le<br/>⊢ onLineBound h γ ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) *…"]:::end_
  x0(["WeilBackground · online_term_eq"]):::ext
  x1(["WeilBackground · online_term_le_near"]):::ext
  x2(["WeilBackground · phiC"]):::ext
  x3(["WeilBands · order_eq_analyticOrderNatAt"]):::ext
  x4(["WeilBands · weightedTerm"]):::ext
  x5(["WeilDetect · laplace"]):::ext
  x6(["WeilPowerAssembly · on_line_le"]):::ext
  x7(["WeilSeries · A"]):::ext
  x8(["WeilSeries · M"]):::ext
  x9(["WeilSeries · M_nonneg"]):::ext
  x10(["WeilSeries · bandSeries_le"]):::ext
  x11(["WeilSeries · bandSeries_summable"]):::ext
  x12(["WeilSeries · cFar"]):::ext
  x13(["WeilSeries · four_h_add_nonneg"]):::ext
  x14(["WeilSeries · idx_le"]):::ext
  x15(["WeilSeries · term_le_M"]):::ext
  x16(["WeilTiles · idx"]):::ext
  x17(["WeilTiles · sum_le_bandSeries"]):::ext
  x18(["WeilTiles · weightedTerm_nonneg"]):::ext
  x19(["WeilTransform · Psi"]):::ext
  n0 --> n1
  n1 --> n5
  n10 --> n11
  n10 --> n12
  n10 --> n13
  n11 --> n13
  n12 --> n13
  n14 --> n15
  n14 --> n16
  n14 --> n17
  n14 --> n18
  n14 --> n24
  n14 --> x6
  n16 --> n18
  n17 --> n18
  n17 --> n20
  n17 --> n21
  n17 --> n24
  n18 --> n20
  n19 --> n20
  n19 --> n21
  n19 --> n22
  n2 --> n3
  n20 --> n21
  n20 --> n22
  n23 --> n24
  n3 --> n4
  n3 --> n5
  n3 --> n8
  n4 --> n8
  n5 --> n8
  n6 --> n17
  n6 --> n18
  n6 --> n24
  n6 --> n7
  n6 --> n8
  n7 --> n18
  n7 --> n8
  n8 --> n18
  n9 --> n13
  x0 --> n1
  x1 --> n16
  x10 --> n7
  x11 --> n7
  x12 --> n23
  x12 --> n24
  x13 --> n23
  x14 --> n23
  x15 --> n7
  x16 --> n23
  x17 --> n7
  x18 --> n21
  x18 --> n22
  x19 --> n0
  x2 --> n1
  x2 --> n5
  x3 --> n16
  x4 --> n16
  x4 --> n18
  x4 --> n20
  x4 --> n21
  x4 --> n22
  x4 --> n5
  x4 --> n7
  x4 --> n8
  x5 --> n1
  x5 --> n5
  x7 --> n23
  x7 --> n24
  x7 --> n6
  x8 --> n7
  x9 --> n7
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
| `WeilOnLine.Psi_neg`<br/>theorem, line 50 | WeilTransform.Psi (-s) = -WeilTransform.Psi s | s : ℝ | `Ψ` is odd. | `WeilTransform.Psi` | `WeilOnLine.term_conj` |
| `WeilOnLine.term_conj`<br/>theorem, line 58 | (laplace (phiC h γ) (-(starRingEnd ℂ) ρ) * laplace (phiC h γ) (-(1 - (starRingEnd ℂ) ρ))).re = (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re | hh : 0 &lt; h; γ : ℝ; hρ : ρ.re = 1 / 2 | The on-line term is invariant under conjugation of the zero. | `WeilBackground.online_term_eq`, `WeilBackground.phiC`, `WeilDetect.laplace`, `WeilOnLine.Psi_neg` | `WeilOnLine.weightedTerm_conjZ` |
| `WeilOnLine.conj_mem`<br/>theorem, line 71 | (starRingEnd ℂ) (ρ : ℂ) ∈ Kadiri.NontrivialZeros | ρ : Kadiri.NontrivialZeros | Conjugates of nontrivial zeros are nontrivial zeros. | — | `WeilOnLine.conjZ` |
| `WeilOnLine.conjZ`<br/>def, line 81 | Kadiri.NontrivialZeros | ρ : Kadiri.NontrivialZeros | The conjugate, as a nontrivial zero. | `WeilOnLine.conj_mem` | `WeilOnLine.conjZ_injective`, `WeilOnLine.sum_lower_le`, `WeilOnLine.weightedTerm_conjZ` |
| `WeilOnLine.conjZ_injective`<br/>theorem, line 84 | Function.Injective conjZ | — | — | `WeilOnLine.conjZ` | `WeilOnLine.sum_lower_le` |
| `WeilOnLine.weightedTerm_conjZ`<br/>theorem, line 89 | weightedTerm h γ (conjZ ρ) = weightedTerm h γ ρ | hh : 0 &lt; h; γ : ℝ; ρ : Kadiri.NontrivialZeros; hρ : (ρ : ℂ).re = 1 / 2 | — | `WeilBackground.phiC`, `WeilBands.weightedTerm`, `WeilDetect.laplace`, `WeilOnLine.conjZ`, `WeilOnLine.term_conj` | `WeilOnLine.sum_lower_le` |
| `WeilOnLine.B`<br/>def, line 103 | ℝ | h γ : ℝ | One side's bound: `A h γ · π²/6`. | `WeilSeries.A` | `WeilOnLine.onLineBound`, `WeilOnLine.onLineBound_le`, `WeilOnLine.sum_lower_le`, `WeilOnLine.sum_onLine_le`, `WeilOnLine.sum_upper_le` |
| `WeilOnLine.sum_upper_le`<br/>theorem, line 106 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im | Finite on-line sums of height `≥ 11/10`. | `WeilBands.weightedTerm`, `WeilOnLine.B`, `WeilSeries.M`, `WeilSeries.M_nonneg`, `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.term_le_M`, `WeilTiles.sum_le_bandSeries` | `WeilOnLine.sum_lower_le`, `WeilOnLine.sum_onLine_le` |
| `WeilOnLine.sum_lower_le`<br/>theorem, line 118 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ B h γ | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ≤ -(11 / 10) | Negative heights. Finite on-line sums of height `≤ −11/10`, by conjugation onto the upper range. | `WeilBands.weightedTerm`, `WeilOnLine.B`, `WeilOnLine.conjZ`, `WeilOnLine.conjZ_injective`, `WeilOnLine.sum_upper_le`, `WeilOnLine.weightedTerm_conjZ` | `WeilOnLine.sum_onLine_le` |
| `WeilOnLine.lowSet`<br/>def, line 141 | Set ℂ | — | The on-line zeros of height `\|t\| ≤ 11/10`, as points. | — | `WeilOnLine.lowSet_finite` |
| `WeilOnLine.lowU`<br/>def, line 144 | Set ℂ | — | The half-plane `Re z &lt; 3/4`: open, convex, pole-free. | — | `WeilOnLine.lowSet_finite`, `WeilOnLine.lowU_analytic`, `WeilOnLine.lowU_preconnected` |
| `WeilOnLine.lowU_preconnected`<br/>theorem, line 146 | IsPreconnected lowU | — | — | `WeilOnLine.lowU` | `WeilOnLine.lowSet_finite` |
| `WeilOnLine.lowU_analytic`<br/>theorem, line 149 | AnalyticOnNhd ℂ riemannZeta lowU | — | — | `WeilOnLine.lowU` | `WeilOnLine.lowSet_finite` |
| `WeilOnLine.lowSet_finite`<br/>theorem, line 158 | lowSet.Finite | — | The low band is finite. | `WeilOnLine.lowSet`, `WeilOnLine.lowU`, `WeilOnLine.lowU_analytic`, `WeilOnLine.lowU_preconnected` | — |
| `WeilOnLine.lowCount`<br/>def, line 187 | ℝ | — | The low count. Total multiplicity of the on-line zeros of height `\|t\| ≤ 11/10`. Carried by name. | — | `WeilOnLine.lowCount_nonneg`, `WeilOnLine.onLineBound`, `WeilOnLine.onLineBound_le`, `WeilOnLine.sum_low_le`, `WeilOnLine.sum_onLine_le`, `WeilPowerAssembly.on_line_le` |
| `WeilOnLine.lowCount_nonneg`<br/>theorem, line 189 | 0 ≤ lowCount | — | — | `WeilOnLine.lowCount` | — |
| `WeilOnLine.sum_low_le`<br/>theorem, line 193 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ 4 * h ^ 2 * lowCount | hh : 0 &lt; h; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ \|(ρ : ℂ).im\| ≤ 11 / 10 | The low band. Finite on-line sums of height `\|t\| ≤ 11/10`. | `WeilBackground.online_term_le_near`, `WeilBands.order_eq_analyticOrderNatAt`, `WeilBands.weightedTerm`, `WeilOnLine.lowCount` | `WeilOnLine.sum_onLine_le` |
| `WeilOnLine.onLineBound`<br/>def, line 225 | ℝ | h γ : ℝ | The on-line background bound: `2·B h γ + 4h²·lowCount`. | `WeilOnLine.B`, `WeilOnLine.lowCount` | `WeilOnLine.onLineBound_le`, `WeilOnLine.sum_onLine_le`, `WeilOnLine.sum_onLine_subtype_le`, `WeilOnLine.tsum_onLine_le` |
| `WeilOnLine.sum_onLine_le`<br/>theorem, line 228 | ∑ ρ ∈ S, weightedTerm h γ ρ ≤ onLineBound h γ | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 | All heights. Any finite on-line sum is at most `onLineBound`. | `WeilBands.weightedTerm`, `WeilOnLine.B`, `WeilOnLine.lowCount`, `WeilOnLine.onLineBound`, `WeilOnLine.sum_low_le`, `WeilOnLine.sum_lower_le`, `WeilOnLine.sum_upper_le` | `WeilOnLine.sum_onLine_subtype_le` |
| `WeilOnLine.OnLine`<br/>abbrev, line 263 | Type | — | On-line zeros. | — | `WeilOnLine.sum_onLine_subtype_le`, `WeilOnLine.summable_onLine`, `WeilOnLine.tsum_onLine_le` |
| `WeilOnLine.sum_onLine_subtype_le`<br/>theorem, line 265 | ∑ ρ ∈ s, weightedTerm h γ ρ.1 ≤ onLineBound h γ | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; s : Finset OnLine | — | `WeilBands.weightedTerm`, `WeilOnLine.OnLine`, `WeilOnLine.onLineBound`, `WeilOnLine.sum_onLine_le` | `WeilOnLine.summable_onLine`, `WeilOnLine.tsum_onLine_le` |
| `WeilOnLine.tsum_onLine_le`<br/>theorem, line 278 | ∑' ρ : OnLine, weightedTerm h γ ρ.1 ≤ onLineBound h γ | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ | The on-line background. For `h &gt; 0` and `γ ≥ 11/10`, the full weighted sum over all on-line zeros is at most `onLineBound h γ`. | `WeilBands.weightedTerm`, `WeilOnLine.OnLine`, `WeilOnLine.onLineBound`, `WeilOnLine.sum_onLine_subtype_le`, `WeilTiles.weightedTerm_nonneg` | — |
| `WeilOnLine.summable_onLine`<br/>theorem, line 286 | Summable (fun ρ : OnLine =&gt; weightedTerm h γ ρ.1) | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ | The on-line series is summable. | `WeilBands.weightedTerm`, `WeilOnLine.OnLine`, `WeilOnLine.sum_onLine_subtype_le`, `WeilTiles.weightedTerm_nonneg` | — |
| `WeilOnLine.A_le`<br/>theorem, line 293 | A h γ ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) | hγ : 11 / 10 ≤ γ | — | `WeilSeries.A`, `WeilSeries.cFar`, `WeilSeries.four_h_add_nonneg`, `WeilSeries.idx_le`, `WeilTiles.idx` | `WeilOnLine.onLineBound_le` |
| `WeilOnLine.onLineBound_le`<br/>theorem, line 304 | onLineBound h γ ≤ 2 * (88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount | hγ : 11 / 10 ≤ γ | The on-line background, in `γ` and `h` alone. | `WeilOnLine.A_le`, `WeilOnLine.B`, `WeilOnLine.lowCount`, `WeilOnLine.onLineBound`, `WeilSeries.A`, `WeilSeries.cFar` | — |
