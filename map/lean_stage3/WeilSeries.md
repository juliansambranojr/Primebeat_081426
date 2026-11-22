# `lean_stage3/Stage3/WeilSeries.lean`

**What it does** (its own header): WeilSeries — the band series made explicit. Rung 4b, second half, slice B2 of the detection ladder (units 0316–0322). 2026-09-06.

**Imports:** [`WeilTiles`](../lean_stage3/WeilTiles.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilOnLine`](../lean_stage3/WeilOnLine.md), [`WeilPowerBands`](../lean_stage3/WeilPowerBands.md).

```mermaid
flowchart LR
  n0["cFar<br/>(def)"]:::dfn
  n1["cFar_nonneg<br/>⊢ 0 ≤ cFar"]:::thm
  n2["M<br/>(def)"]:::dfn
  n3["M_nonneg<br/>⊢ 0 ≤ M h γ k"]:::thm
  n4["two_le_of_one_lt<br/>⊢ 2 ≤ |(k : ℝ) - (k0 : ℝ)|"]:::thm
  n5["dist_ge<br/>⊢ 9 / 5 * |(idx t : ℝ) - (idx γ : ℝ)| - 9 / 5 ≤ |t - γ|"]:::thm
  n6["term_le_M<br/>⊢ (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).…"]:::thm
  n7["A<br/>(def)"]:::dfn
  n8["four_h_add_nonneg<br/>⊢ 0 ≤ 4 * h ^ 2 + cFar / h ^ 2"]:::thm
  n9["A_nonneg<br/>⊢ 0 ≤ A h γ"]:::thm
  n10["weight_le<br/>⊢ 15 * Real.log (centre k) + 73 ≤ 88 * ((k : ℝ) + 1)"]:::thm
  n11["weight_nonneg<br/>⊢ 0 ≤ 15 * Real.log (centre k) + 73"]:::thm
  n12["bandTerm_le_A<br/>⊢ M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ / ((k : ℝ) + 1) ^ 3"]:::thm
  n13["summable_shift3<br/>⊢ Summable (fun k : ℕ =＞ 1 / ((k : ℝ) + 1) ^ 3)"]:::lone
  n14["summable_shift2<br/>⊢ Summable (fun k : ℕ =＞ 1 / ((k : ℝ) + 1) ^ 2)"]:::lone
  n15["bandSeries_summable<br/>⊢ Summable (fun k : ℕ =＞ M h γ k * (15 * Real.log (centre k) + 73))"]:::thm
  n16["tsum_shift2<br/>⊢ ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6"]:::thm
  n17["bandSeries_le<br/>⊢ ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ * (Real.pi…"]:::thm
  n18["idx_le<br/>⊢ (idx γ : ℝ) ≤ γ"]:::thm
  n19["tsum_upper_le_explicit<br/>⊢ ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ A h γ * (Real.pi ^ 2 / 6)"]:::thm
  n20["tsum_upper_le_explicit'<br/>⊢ ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + c…"]:::end_
  x0(["WeilBackground · online_term_le_far"]):::ext
  x1(["WeilBackground · online_term_le_near"]):::ext
  x2(["WeilBackground · phiC"]):::ext
  x3(["WeilBands · weightedTerm"]):::ext
  x4(["WeilDetect · laplace"]):::ext
  x5(["WeilOnLine · A_le"]):::ext
  x6(["WeilOnLine · B"]):::ext
  x7(["WeilOnLine · onLineBound_le"]):::ext
  x8(["WeilOnLine · sum_upper_le"]):::ext
  x9(["WeilPowerBands · A_le"]):::ext
  x10(["WeilPowerBands · bandSeries_le"]):::ext
  x11(["WeilPowerBands · bandTerm_le_A"]):::ext
  x12(["WeilPowerBands · term_le_M"]):::ext
  x13(["WeilTiles · Upper"]):::ext
  x14(["WeilTiles · bandSeries_nonneg"]):::ext
  x15(["WeilTiles · centre"]):::ext
  x16(["WeilTiles · idx"]):::ext
  x17(["WeilTiles · idx_spec"]):::ext
  x18(["WeilTiles · tsum_upper_le"]):::ext
  x19(["WeilTiles · two_le_centre"]):::ext
  n0 --> n1
  n0 --> n12
  n0 --> n2
  n0 --> n20
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> x5
  n0 --> x7
  n1 --> n12
  n1 --> n3
  n1 --> n8
  n10 --> n12
  n10 --> x11
  n11 --> n12
  n11 --> x11
  n12 --> n15
  n12 --> n17
  n15 --> n17
  n15 --> n19
  n15 --> x8
  n16 --> n17
  n16 --> x10
  n17 --> n19
  n17 --> x8
  n18 --> n20
  n18 --> x5
  n18 --> x9
  n19 --> n20
  n2 --> n12
  n2 --> n15
  n2 --> n17
  n2 --> n19
  n2 --> n3
  n2 --> n6
  n2 --> x8
  n3 --> n15
  n3 --> n19
  n3 --> x8
  n4 --> n12
  n4 --> n6
  n4 --> x11
  n4 --> x12
  n5 --> n6
  n5 --> x12
  n6 --> n19
  n6 --> x8
  n7 --> n12
  n7 --> n15
  n7 --> n17
  n7 --> n19
  n7 --> n20
  n7 --> n9
  n7 --> x5
  n7 --> x6
  n7 --> x7
  n8 --> n12
  n8 --> n20
  n8 --> n9
  n8 --> x5
  n9 --> n17
  x0 --> n6
  x1 --> n6
  x13 --> n19
  x13 --> n20
  x14 --> n15
  x15 --> n10
  x15 --> n11
  x15 --> n12
  x15 --> n15
  x15 --> n17
  x15 --> n5
  x16 --> n12
  x16 --> n18
  x16 --> n2
  x16 --> n20
  x16 --> n5
  x16 --> n6
  x16 --> n7
  x17 --> n5
  x18 --> n19
  x19 --> n10
  x19 --> n11
  x2 --> n6
  x3 --> n19
  x3 --> n20
  x4 --> n6
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
| `WeilSeries.cFar`<br/>def, line 44 | ℝ | — | The far constant `(2π+π²)²·(10/9)⁴`. | — | `WeilOnLine.A_le`, `WeilOnLine.onLineBound_le`, `WeilSeries.A`, `WeilSeries.M`, `WeilSeries.bandTerm_le_A`, `WeilSeries.cFar_nonneg`, `WeilSeries.four_h_add_nonneg`, `WeilSeries.term_le_M`, `WeilSeries.tsum_upper_le_explicit'` |
| `WeilSeries.cFar_nonneg`<br/>theorem, line 46 | 0 ≤ cFar | — | — | `WeilSeries.cFar` | `WeilSeries.M_nonneg`, `WeilSeries.bandTerm_le_A`, `WeilSeries.four_h_add_nonneg` |
| `WeilSeries.M`<br/>def, line 51 | ℝ | h γ : ℝ; k : ℕ | The dominating band series. | `WeilSeries.cFar`, `WeilTiles.idx` | `WeilOnLine.sum_upper_le`, `WeilSeries.M_nonneg`, `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.bandTerm_le_A`, `WeilSeries.term_le_M`, `WeilSeries.tsum_upper_le_explicit` |
| `WeilSeries.M_nonneg`<br/>theorem, line 55 | 0 ≤ M h γ k | h γ : ℝ; k : ℕ | — | `WeilSeries.M`, `WeilSeries.cFar_nonneg` | `WeilOnLine.sum_upper_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.tsum_upper_le_explicit` |
| `WeilSeries.two_le_of_one_lt`<br/>theorem, line 62 | 2 ≤ \|(k : ℝ) - (k0 : ℝ)\| | h : 1 &lt; \|(k : ℝ) - (k0 : ℝ)\| | A gap between naturals that exceeds `1` is at least `2`. | — | `WeilPowerBands.bandTerm_le_A`, `WeilPowerBands.term_le_M`, `WeilSeries.bandTerm_le_A`, `WeilSeries.term_le_M` |
| `WeilSeries.dist_ge`<br/>theorem, line 71 | 9 / 5 * \|(idx t : ℝ) - (idx γ : ℝ)\| - 9 / 5 ≤ \|t - γ\| | ht : 11 / 10 ≤ t; hγ : 11 / 10 ≤ γ | The distance from a height to `γ`, read off the band gap. | `WeilTiles.centre`, `WeilTiles.idx`, `WeilTiles.idx_spec` | `WeilPowerBands.term_le_M`, `WeilSeries.term_le_M` |
| `WeilSeries.term_le_M`<br/>theorem, line 89 | (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re ≤ M h γ (idx (ρ : ℂ).im) | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ; ρ : Kadiri.NontrivialZeros; hre : (ρ : ℂ).re = 1 / 2; him : 11 / 10 ≤ (ρ : ℂ).im | Domination. Every on-line term of height `≥ 11/10` is at most `M` at its band index. | `WeilBackground.online_term_le_far`, `WeilBackground.online_term_le_near`, `WeilBackground.phiC`, `WeilDetect.laplace`, `WeilSeries.M`, `WeilSeries.cFar`, `WeilSeries.dist_ge`, `WeilSeries.two_le_of_one_lt`, `WeilTiles.idx` | `WeilOnLine.sum_upper_le`, `WeilSeries.tsum_upper_le_explicit` |
| `WeilSeries.A`<br/>def, line 141 | ℝ | h γ : ℝ | The crude constant: `M k·(15·log (centre k) + 73) ≤ A/(k+1)³`. | `WeilSeries.cFar`, `WeilTiles.idx` | `WeilOnLine.A_le`, `WeilOnLine.B`, `WeilOnLine.onLineBound_le`, `WeilSeries.A_nonneg`, `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.bandTerm_le_A`, `WeilSeries.tsum_upper_le_explicit`, `WeilSeries.tsum_upper_le_explicit'` |
| `WeilSeries.four_h_add_nonneg`<br/>theorem, line 143 | 0 ≤ 4 * h ^ 2 + cFar / h ^ 2 | h : ℝ | — | `WeilSeries.cFar`, `WeilSeries.cFar_nonneg` | `WeilOnLine.A_le`, `WeilSeries.A_nonneg`, `WeilSeries.bandTerm_le_A`, `WeilSeries.tsum_upper_le_explicit'` |
| `WeilSeries.A_nonneg`<br/>theorem, line 148 | 0 ≤ A h γ | h γ : ℝ | — | `WeilSeries.A`, `WeilSeries.four_h_add_nonneg` | `WeilSeries.bandSeries_le` |
| `WeilSeries.weight_le`<br/>theorem, line 153 | 15 * Real.log (centre k) + 73 ≤ 88 * ((k : ℝ) + 1) | k : ℕ | The band weight, with `log x ≤ x − 1`. | `WeilTiles.centre`, `WeilTiles.two_le_centre` | `WeilPowerBands.bandTerm_le_A`, `WeilSeries.bandTerm_le_A` |
| `WeilSeries.weight_nonneg`<br/>theorem, line 161 | 0 ≤ 15 * Real.log (centre k) + 73 | k : ℕ | — | `WeilTiles.centre`, `WeilTiles.two_le_centre` | `WeilPowerBands.bandTerm_le_A`, `WeilSeries.bandTerm_le_A` |
| `WeilSeries.bandTerm_le_A`<br/>theorem, line 166 | M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ / ((k : ℝ) + 1) ^ 3 | hh : 0 &lt; h; k : ℕ | Comparison. Each band term is at most `A/(k+1)³`. | `WeilSeries.A`, `WeilSeries.M`, `WeilSeries.cFar`, `WeilSeries.cFar_nonneg`, `WeilSeries.four_h_add_nonneg`, `WeilSeries.two_le_of_one_lt`, `WeilSeries.weight_le`, `WeilSeries.weight_nonneg`, `WeilTiles.centre`, `WeilTiles.idx` | `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable` |
| `WeilSeries.summable_shift3`<br/>theorem, line 221 | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 3) | — | — | — | — |
| `WeilSeries.summable_shift2`<br/>theorem, line 229 | Summable (fun k : ℕ =&gt; 1 / ((k : ℝ) + 1) ^ 2) | — | — | — | — |
| `WeilSeries.bandSeries_summable`<br/>theorem, line 238 | Summable (fun k : ℕ =&gt; M h γ k * (15 * Real.log (centre k) + 73)) | hh : 0 &lt; h | Summability of the band series, by comparison with `A/(k+1)³`. | `WeilSeries.A`, `WeilSeries.M`, `WeilSeries.M_nonneg`, `WeilSeries.bandTerm_le_A`, `WeilTiles.bandSeries_nonneg`, `WeilTiles.centre` | `WeilOnLine.sum_upper_le`, `WeilSeries.bandSeries_le`, `WeilSeries.tsum_upper_le_explicit` |
| `WeilSeries.tsum_shift2`<br/>theorem, line 247 | ∑' k : ℕ, 1 / ((k : ℝ) + 1) ^ 2 = Real.pi ^ 2 / 6 | — | `Σ_{k≥0} 1/(k+1)² = π²/6`, from `hasSum_zeta_two`. | — | `WeilPowerBands.bandSeries_le`, `WeilSeries.bandSeries_le` |
| `WeilSeries.bandSeries_le`<br/>theorem, line 260 | ∑' k : ℕ, M h γ k * (15 * Real.log (centre k) + 73) ≤ A h γ * (Real.pi ^ 2 / 6) | hh : 0 &lt; h | The band series in closed form: at most `A·π²/6`. | `WeilSeries.A`, `WeilSeries.A_nonneg`, `WeilSeries.M`, `WeilSeries.bandSeries_summable`, `WeilSeries.bandTerm_le_A`, `WeilSeries.tsum_shift2`, `WeilTiles.centre` | `WeilOnLine.sum_upper_le`, `WeilSeries.tsum_upper_le_explicit` |
| `WeilSeries.idx_le`<br/>theorem, line 275 | (idx γ : ℝ) ≤ γ | hγ : 11 / 10 ≤ γ | The band index of `γ` is at most `γ`. | `WeilTiles.idx` | `WeilOnLine.A_le`, `WeilPowerBands.A_le`, `WeilSeries.tsum_upper_le_explicit'` |
| `WeilSeries.tsum_upper_le_explicit`<br/>theorem, line 285 | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ A h γ * (Real.pi ^ 2 / 6) | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ | Upper on-line background. For `h &gt; 0` and `γ ≥ 11/10`, the full weighted sum over on-line zeros of height `≥ 11/10` is at most `A·π²/6`. | `WeilBands.weightedTerm`, `WeilSeries.A`, `WeilSeries.M`, `WeilSeries.M_nonneg`, `WeilSeries.bandSeries_le`, `WeilSeries.bandSeries_summable`, `WeilSeries.term_le_M`, `WeilTiles.Upper`, `WeilTiles.tsum_upper_le` | `WeilSeries.tsum_upper_le_explicit'` |
| `WeilSeries.tsum_upper_le_explicit'`<br/>theorem, line 294 | ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ 88 * (γ + 3) ^ 4 * (4 * h ^ 2 + cFar / h ^ 2) * (Real.pi ^ 2 / 6) | hh : 0 &lt; h; hγ : 11 / 10 ≤ γ | Upper on-line background, in `γ` and `h` alone: `≤ 88·(γ+3)⁴·(4h² + cFar/h²)·π²/6`. | `WeilBands.weightedTerm`, `WeilSeries.A`, `WeilSeries.cFar`, `WeilSeries.four_h_add_nonneg`, `WeilSeries.idx_le`, `WeilSeries.tsum_upper_le_explicit`, `WeilTiles.Upper`, `WeilTiles.idx` | — |
