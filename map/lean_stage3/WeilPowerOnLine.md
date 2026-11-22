# `lean_stage3/Stage3/WeilPowerOnLine.lean`

**What it does** (its own header): WeilPowerOnLine — the switched window's on-line background, all heights. Rung 5, eighth slice. 2026-09-06.

**Imports:** [`WeilOnLine`](../lean_stage3/WeilOnLine.md), [`WeilPowerBands`](../lean_stage3/WeilPowerBands.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md).

```mermaid
flowchart LR
  n0["PsiW_neg<br/>⊢ PsiW m (-t) = -PsiW m t"]:::thm
  n1["term_conj<br/>⊢ termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ"]:::thm
  n2["weightedTermW_conjZ<br/>⊢ weightedTermW h γ m (conjZ ρ) = weightedTermW h γ m ρ"]:::thm
  n3["B<br/>(def)"]:::dfn
  n4["sum_upper_le<br/>⊢ ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m"]:::thm
  n5["sum_lower_le<br/>⊢ ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m"]:::thm
  n6["sum_low_le<br/>⊢ ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount"]:::thm
  n7["onLineBound<br/>(def)"]:::dfn
  n8["sum_onLine_le<br/>⊢ ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ onLineBound h γ m"]:::thm
  n9["sum_onLine_subtype_le<br/>⊢ ∑ ρ ∈ s, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m"]:::thm
  n10["tsum_onLine_le<br/>⊢ ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m"]:::end_
  n11["summable_onLine<br/>⊢ Summable (fun ρ : OnLine =＞ weightedTermW h γ m ρ.1)"]:::end_
  n12["onLineBound_le<br/>⊢ onLineBound h γ m ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM…"]:::thm
  x0(["WeilBands · order_eq_analyticOrderNatAt"]):::ext
  x1(["WeilOddPower · S"]):::ext
  x2(["WeilPowerAssembly · on_line_le"]):::ext
  x3(["WeilPowerBackground · PsiW"]):::ext
  x4(["WeilPowerBackground · online_term_eq"]):::ext
  x5(["WeilPowerBackground · online_term_le_near"]):::ext
  x6(["WeilPowerBands · A"]):::ext
  x7(["WeilPowerBands · A_le"]):::ext
  x8(["WeilPowerBands · M"]):::ext
  x9(["WeilPowerBands · M_nonneg"]):::ext
  x10(["WeilPowerBands · bandSeries_le"]):::ext
  x11(["WeilPowerBands · bandSeries_summable"]):::ext
  x12(["WeilPowerBands · cFarM"]):::ext
  x13(["WeilPowerBands · r"]):::ext
  x14(["WeilPowerBands · sum_le_bandSeries"]):::ext
  x15(["WeilPowerBands · termW"]):::ext
  x16(["WeilPowerBands · term_le_M"]):::ext
  x17(["WeilPowerBands · weightedTermW"]):::ext
  x18(["WeilPowerBands · weightedTermW_nonneg"]):::ext
  n0 --> n1
  n1 --> n2
  n12 --> x2
  n2 --> n5
  n3 --> n12
  n3 --> n4
  n3 --> n5
  n3 --> n7
  n3 --> n8
  n4 --> n5
  n4 --> n8
  n5 --> n8
  n6 --> n8
  n7 --> n10
  n7 --> n12
  n7 --> n8
  n7 --> n9
  n7 --> x2
  n8 --> n9
  n9 --> n10
  n9 --> n11
  x0 --> n6
  x1 --> n4
  x1 --> n5
  x1 --> n6
  x1 --> n8
  x10 --> n4
  x11 --> n4
  x12 --> n12
  x13 --> n12
  x14 --> n4
  x15 --> n1
  x15 --> n2
  x16 --> n4
  x17 --> n10
  x17 --> n11
  x17 --> n2
  x17 --> n4
  x17 --> n5
  x17 --> n6
  x17 --> n8
  x17 --> n9
  x18 --> n10
  x18 --> n11
  x3 --> n0
  x4 --> n1
  x5 --> n6
  x6 --> n12
  x6 --> n3
  x7 --> n12
  x8 --> n4
  x9 --> n4
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
| `WeilPowerOnLine.PsiW_neg`<br/>theorem, line 37 | PsiW m (-t) = -PsiW m t | m : ℕ; t : ℝ | `PsiW` is odd. | `WeilPowerBackground.PsiW` | `WeilPowerOnLine.term_conj` |
| `WeilPowerOnLine.term_conj`<br/>theorem, line 45 | termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ | hh : 0 &lt; h; γ : ℝ; m : ℕ; hρ : ρ.re = 1 / 2 | The on-line term is invariant under conjugation of the zero. | `WeilPowerBackground.online_term_eq`, `WeilPowerBands.termW`, `WeilPowerOnLine.PsiW_neg` | `WeilPowerOnLine.weightedTermW_conjZ` |
| `WeilPowerOnLine.weightedTermW_conjZ`<br/>theorem, line 56 | weightedTermW h γ m (conjZ ρ) = weightedTermW h γ m ρ | hh : 0 &lt; h; γ : ℝ; m : ℕ; ρ : Kadiri.NontrivialZeros; hρ : (ρ : ℂ).re = 1 / 2 | — | `WeilPowerBands.termW`, `WeilPowerBands.weightedTermW`, `WeilPowerOnLine.term_conj` | `WeilPowerOnLine.sum_lower_le` |
| `WeilPowerOnLine.B`<br/>def, line 67 | ℝ | h γ : ℝ; m : ℕ | One side's bound: `A h γ m · π²/6`. | `WeilPowerBands.A` | `WeilPowerOnLine.onLineBound`, `WeilPowerOnLine.onLineBound_le`, `WeilPowerOnLine.sum_lower_le`, `WeilPowerOnLine.sum_onLine_le`, `WeilPowerOnLine.sum_upper_le` |
| `WeilPowerOnLine.sum_upper_le`<br/>theorem, line 70 | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ 11 / 10 ≤ (ρ : ℂ).im | Finite on-line sums of height `≥ 11/10`. | `WeilOddPower.S`, `WeilPowerBands.M`, `WeilPowerBands.M_nonneg`, `WeilPowerBands.bandSeries_le`, `WeilPowerBands.bandSeries_summable`, `WeilPowerBands.sum_le_bandSeries`, `WeilPowerBands.term_le_M`, `WeilPowerBands.weightedTermW`, `WeilPowerOnLine.B` | `WeilPowerOnLine.sum_lower_le`, `WeilPowerOnLine.sum_onLine_le` |
| `WeilPowerOnLine.sum_lower_le`<br/>theorem, line 81 | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ B h γ m | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ (ρ : ℂ).im ≤ -(11 / 10) | Negative heights. | `WeilOddPower.S`, `WeilPowerBands.weightedTermW`, `WeilPowerOnLine.B`, `WeilPowerOnLine.sum_upper_le`, `WeilPowerOnLine.weightedTermW_conjZ` | `WeilPowerOnLine.sum_onLine_le` |
| `WeilPowerOnLine.sum_low_le`<br/>theorem, line 104 | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ 4 * h ^ 2 * lowCount | hh : 0 &lt; h; m : ℕ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 ∧ \|(ρ : ℂ).im\| ≤ 11 / 10 | The low band. Finite on-line sums of height `\|t\| ≤ 11/10`. | `WeilBands.order_eq_analyticOrderNatAt`, `WeilOddPower.S`, `WeilPowerBackground.online_term_le_near`, `WeilPowerBands.weightedTermW` | `WeilPowerOnLine.sum_onLine_le` |
| `WeilPowerOnLine.onLineBound`<br/>def, line 136 | ℝ | h γ : ℝ; m : ℕ | The on-line background bound: `2·B h γ m + 4h²·lowCount`. | `WeilPowerOnLine.B` | `WeilPowerAssembly.on_line_le`, `WeilPowerOnLine.onLineBound_le`, `WeilPowerOnLine.sum_onLine_le`, `WeilPowerOnLine.sum_onLine_subtype_le`, `WeilPowerOnLine.tsum_onLine_le` |
| `WeilPowerOnLine.sum_onLine_le`<br/>theorem, line 139 | ∑ ρ ∈ S, weightedTermW h γ m ρ ≤ onLineBound h γ m | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ; S : Finset Kadiri.NontrivialZeros; hS : ∀ ρ ∈ S, (ρ : ℂ).re = 1 / 2 | All heights. | `WeilOddPower.S`, `WeilPowerBands.weightedTermW`, `WeilPowerOnLine.B`, `WeilPowerOnLine.onLineBound`, `WeilPowerOnLine.sum_low_le`, `WeilPowerOnLine.sum_lower_le`, `WeilPowerOnLine.sum_upper_le` | `WeilPowerOnLine.sum_onLine_subtype_le` |
| `WeilPowerOnLine.sum_onLine_subtype_le`<br/>theorem, line 173 | ∑ ρ ∈ s, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ; s : Finset OnLine | — | `WeilPowerBands.weightedTermW`, `WeilPowerOnLine.onLineBound`, `WeilPowerOnLine.sum_onLine_le` | `WeilPowerOnLine.summable_onLine`, `WeilPowerOnLine.tsum_onLine_le` |
| `WeilPowerOnLine.tsum_onLine_le`<br/>theorem, line 186 | ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ | The on-line background of the switched window. | `WeilPowerBands.weightedTermW`, `WeilPowerBands.weightedTermW_nonneg`, `WeilPowerOnLine.onLineBound`, `WeilPowerOnLine.sum_onLine_subtype_le` | — |
| `WeilPowerOnLine.summable_onLine`<br/>theorem, line 194 | Summable (fun ρ : OnLine =&gt; weightedTermW h γ m ρ.1) | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; m : ℕ | The on-line series is summable. | `WeilPowerBands.weightedTermW`, `WeilPowerBands.weightedTermW_nonneg`, `WeilPowerOnLine.sum_onLine_subtype_le` | — |
| `WeilPowerOnLine.onLineBound_le`<br/>theorem, line 202 | onLineBound h γ m ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6)) + 4 * h ^ 2 * lowCount | hγ : 11 / 10 ≤ γ; m : ℕ | The on-line background, in `γ`, `h` and `m` alone. | `WeilPowerBands.A`, `WeilPowerBands.A_le`, `WeilPowerBands.cFarM`, `WeilPowerBands.r`, `WeilPowerOnLine.B`, `WeilPowerOnLine.onLineBound` | `WeilPowerAssembly.on_line_le` |
