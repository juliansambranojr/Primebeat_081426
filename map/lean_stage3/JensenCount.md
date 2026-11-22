# `lean_stage3/Stage3/JensenCount.lean`

**What it does** (its own header): JensenCount — `StmtLocalCount` discharged: the Backlund-style local zero count for `ζ`, with explicit constants.

**Imports:** [`ArgCrude`](../lean_stage3/ArgCrude.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ArgIdentity`](../lean_stage3/ArgIdentity.md), [`ContourShift`](../lean_stage3/ContourShift.md), [`LineBound`](../lean_stage3/LineBound.md), [`ReZetaCount`](../lean_stage3/ReZetaCount.md), [`WeilBands`](../lean_stage3/WeilBands.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md).

```mermaid
flowchart LR
  n0["zeta_centre_lower<br/>⊢ (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖"]:::thm
  n1["zeta_disk_upper<br/>⊢ ‖ζ w‖ ≤ 28 * T"]:::thm
  n2["zeta_centre_ne_zero<br/>⊢ ζ (2 + Complex.I * (T : ℂ)) ≠ 0"]:::thm
  n3["pole_away<br/>⊢ 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1"]:::thm
  n4["pole_away_centre<br/>⊢ v ≠ 1"]:::thm
  n5["zetaWindowTwo_finite<br/>⊢ {ρ : ℂ | ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite"]:::thm
  n6["zetaWindow<br/>(def)"]:::dfn
  n7["zetaWindow_finite<br/>⊢ (zetaWindow T).Finite"]:::thm
  n8["jensenF<br/>(def)"]:::dfn
  n9["zeta_comp_analytic<br/>⊢ AnalyticAt ℂ (fun z : ℂ =＞ ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w"]:::thm
  n10["jensenF_analytic<br/>⊢ AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1)"]:::thm
  n11["jensenF_zero_eq_one<br/>⊢ jensenF T 0 = 1"]:::thm
  n12["jensenF_zeros_finite<br/>⊢ (SetOfZeros 1 (jensenF T)).Finite"]:::thm
  n13["jensenF_bound<br/>⊢ ‖jensenF T z‖ ≤ 84 * T"]:::thm
  n14["analyticOrderNatAt_fun_comp_affine<br/>⊢ analyticOrderNatAt (fun w : ℂ =＞ g (a * w + b)) z = analyticOrderNatAt…"]:::thm
  n15["jensenF_order<br/>⊢ analyticOrderNatAt (jensenF T) w = analyticOrderNatAt ζ (2 * w + (2 + …"]:::thm
  n16["zeta_local_zero_count<br/>⊢ ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) ≤ …"]:::thm
  n17["zetaLocalCount<br/>(def)"]:::dfn
  n18["zetaLocalCount_eq<br/>⊢ zetaLocalCount T = ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrd…"]:::thm
  n19["localCount_holds<br/>⊢ StmtLocalCount zetaLocalCount 15 73"]:::thm
  x0(["Abscissa · logDerivZeta_crude_theta"]):::ext
  x1(["ArgCrude · StmtLocalCount"]):::ext
  x2(["ArgIdentity · backlundArg_of_sFromLocal"]):::ext
  x3(["ArgIdentity · rvM_of_sFromLocal"]):::ext
  x4(["ContourShift · goodT_exists"]):::ext
  x5(["ContourShift · mem_zetaWindow"]):::ext
  x6(["EdgeBound · ball_order_sum_le"]):::ext
  x7(["EdgeBound · gz_partial_fraction"]):::ext
  x8(["EdgeNum · ball_order_sum_le_num"]):::ext
  x9(["EdgeNum · gz_partial_fraction_num"]):::ext
  x10(["Glue · band_order_sum_le"]):::ext
  x11(["GlueNum · band_order_sum_le_num"]):::ext
  x12(["LineBound · logDerivZeta_crude"]):::ext
  x13(["LineBound · logDerivZeta_compact"]):::ext
  x14(["LowCount · low_ball_count"]):::ext
  x15(["LowEdge · gz_partial_fraction_low"]):::ext
  x16(["LowEdge · low_ball_count_wide"]):::ext
  x17(["ReZetaCount · F_bound"]):::ext
  x18(["ThetaLine · logDerivZeta_compact_theta"]):::ext
  x19(["WeilBands · band_count"]):::ext
  x20(["WeilBands · mem_zetaWindow_of_online"]):::ext
  n0 --> n13
  n0 --> x13
  n0 --> x18
  n1 --> n13
  n1 --> x17
  n10 --> n16
  n10 --> x0
  n10 --> x12
  n11 --> n16
  n11 --> x0
  n11 --> x12
  n12 --> n16
  n12 --> x0
  n12 --> x12
  n13 --> n16
  n13 --> x0
  n13 --> x12
  n14 --> n15
  n14 --> x14
  n14 --> x15
  n14 --> x16
  n14 --> x7
  n14 --> x9
  n15 --> n16
  n16 --> n19
  n16 --> x10
  n16 --> x11
  n16 --> x19
  n16 --> x4
  n16 --> x6
  n16 --> x8
  n17 --> n18
  n17 --> n19
  n17 --> x2
  n17 --> x3
  n18 --> n19
  n19 --> x3
  n2 --> n11
  n2 --> n12
  n2 --> n15
  n2 --> n16
  n2 --> n5
  n2 --> x0
  n2 --> x12
  n2 --> x13
  n2 --> x18
  n3 --> n9
  n4 --> n5
  n4 --> x0
  n4 --> x12
  n5 --> n12
  n5 --> n7
  n6 --> n16
  n6 --> n17
  n6 --> n7
  n6 --> x20
  n6 --> x5
  n7 --> n16
  n7 --> n18
  n7 --> x10
  n7 --> x11
  n7 --> x19
  n7 --> x4
  n7 --> x6
  n7 --> x8
  n8 --> n10
  n8 --> n11
  n8 --> n12
  n8 --> n13
  n8 --> n15
  n8 --> n16
  n8 --> x0
  n8 --> x12
  n9 --> n10
  n9 --> n15
  x1 --> n19
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
| `Stage3.zeta_centre_lower`<br/>theorem, line 75 | (1 : ℝ) / 3 ≤ ‖ζ (2 + Complex.I * T)‖ | T : ℝ | — | — | `Stage3.jensenF_bound`, `Slice4.logDerivZeta_compact`, `Stage3.logDerivZeta_compact_theta` |
| `Stage3.zeta_disk_upper`<br/>theorem, line 123 | ‖ζ w‖ ≤ 28 * T | hT : 2 ≤ T; hw : ‖w - (2 + Complex.I * (T : ℂ))‖ ≤ 15 / 8 | The majorant on the wide disk. `‖ζ w‖ ≤ 28 T` for `T ≥ 2` and `‖w - (2 + iT)‖ ≤ 15/8`; this is the `R = 15/16` radius of the Jensen step pulled back through `s = 2z + (2 + iT)`. On that disk `Re w ≥ 1/8 &gt; 0` and `Im w ≥ T - 15/8 ≥ 1/8`, so the pole at `s = 1` is avoided with room. | — | `Stage3.jensenF_bound`, `ReZetaCount.F_bound` |
| `Stage3.zeta_centre_ne_zero`<br/>theorem, line 197 | ζ (2 + Complex.I * (T : ℂ)) ≠ 0 | T : ℝ | The centre `2 + iT` has real part `2`, hence `ζ` does not vanish there. | — | `Stage3.logDerivZeta_crude_theta`, `Stage3.jensenF_order`, `Stage3.jensenF_zero_eq_one`, `Stage3.jensenF_zeros_finite`, `Stage3.zetaWindowTwo_finite`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude`, `Slice4.logDerivZeta_compact`, `Stage3.logDerivZeta_compact_theta` |
| `Stage3.pole_away`<br/>theorem, line 205 | 2 * z + (2 + Complex.I * (T : ℂ)) ≠ 1 | hT : 2 ≤ T; hz : ‖z‖ ≤ 11 / 10 | The pole stays outside the mapped ball. For `T ≥ 2` and `‖z‖ ≤ 11/10`, the point `2z + (2 + iT)` is never the pole `s = 1`. | — | `Stage3.zeta_comp_analytic` |
| `Stage3.pole_away_centre`<br/>theorem, line 218 | v ≠ 1 | hT : 2 ≤ T; hv : ‖v - (2 + Complex.I * (T : ℂ))‖ &lt; 11 / 5 | The pole stays outside the window. For `T ≥ 2`, every point within `11/5` of `2 + iT` differs from `1`. | — | `Stage3.logDerivZeta_crude_theta`, `Stage3.zetaWindowTwo_finite`, `Slice3.logDerivZeta_crude` |
| `Stage3.zetaWindowTwo_finite`<br/>theorem, line 232 | {ρ : ℂ \| ζ ρ = 0 ∧ ‖ρ - (2 + Complex.I * (T : ℂ))‖ ≤ 2}.Finite | hT : 2 ≤ T | `ζ` has finitely many zeros within `2` of the centre. | `Stage3.pole_away_centre`, `Stage3.zeta_centre_ne_zero` | `Stage3.jensenF_zeros_finite`, `Stage3.zetaWindow_finite` |
| `Stage3.zetaWindow`<br/>def, line 259 | Set ℂ | T : ℝ | The window. `ζ`'s zeros in the closed disk of radius `7/4` about `2 + iT`. On the critical line this disk covers `\|γ - T\| ≤ √(13/16)` ≈ `0.901`, an interval of positive length — which is what radius `3/2` fails to do, being tangent to the line and so catching only `γ = T`. | — | `ContourShift.mem_zetaWindow`, `Stage3.zetaLocalCount`, `Stage3.zetaWindow_finite`, `Stage3.zeta_local_zero_count`, `WeilBands.mem_zetaWindow_of_online` |
| `Stage3.zetaWindow_finite`<br/>theorem, line 262 | (zetaWindow T).Finite | hT : 2 ≤ T | — | `Stage3.zetaWindow`, `Stage3.zetaWindowTwo_finite` | `ContourShift.goodT_exists`, `EdgeBound.ball_order_sum_le`, `EdgeBound.ball_order_sum_le_num`, `Glue.band_order_sum_le`, `Glue.band_order_sum_le_num`, `Stage3.zetaLocalCount_eq`, `Stage3.zeta_local_zero_count`, `WeilBands.band_count` |
| `Stage3.jensenF`<br/>def, line 269 | ℂ → ℂ | T : ℝ | The normalised local model. `f z = ζ (2z + 2 + iT) / ζ (2 + iT)`; the closed unit ball maps onto `\|s - (2+iT)\| ≤ 2`. | — | `Stage3.logDerivZeta_crude_theta`, `Stage3.jensenF_analytic`, `Stage3.jensenF_bound`, `Stage3.jensenF_order`, `Stage3.jensenF_zero_eq_one`, `Stage3.jensenF_zeros_finite`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude` |
| `Stage3.zeta_comp_analytic`<br/>theorem, line 272 | AnalyticAt ℂ (fun z : ℂ =&gt; ζ (2 * z + (2 + Complex.I * (T : ℂ)))) w | hT : 2 ≤ T; hw : ‖w‖ ≤ 11 / 10 | — | `Stage3.pole_away` | `Stage3.jensenF_analytic`, `Stage3.jensenF_order` |
| `Stage3.jensenF_analytic`<br/>theorem, line 277 | AnalyticOnNhd ℂ (jensenF T) (Metric.closedBall (0 : ℂ) 1) | hT : 2 ≤ T | — | `Stage3.jensenF`, `Stage3.zeta_comp_analytic` | `Stage3.logDerivZeta_crude_theta`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude` |
| `Stage3.jensenF_zero_eq_one`<br/>theorem, line 284 | jensenF T 0 = 1 | T : ℝ | — | `Stage3.jensenF`, `Stage3.zeta_centre_ne_zero` | `Stage3.logDerivZeta_crude_theta`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude` |
| `Stage3.jensenF_zeros_finite`<br/>theorem, line 288 | (SetOfZeros 1 (jensenF T)).Finite | hT : 2 ≤ T | — | `Stage3.jensenF`, `Stage3.zetaWindowTwo_finite`, `Stage3.zeta_centre_ne_zero` | `Stage3.logDerivZeta_crude_theta`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude` |
| `Stage3.jensenF_bound`<br/>theorem, line 306 | ‖jensenF T z‖ ≤ 84 * T | hT : 2 ≤ T; hz : ‖z‖ ≤ 15 / 16 | — | `Stage3.jensenF`, `Stage3.zeta_centre_lower`, `Stage3.zeta_disk_upper` | `Stage3.logDerivZeta_crude_theta`, `Stage3.zeta_local_zero_count`, `Slice3.logDerivZeta_crude` |
| `Stage3.analyticOrderNatAt_fun_comp_affine`<br/>theorem, line 324 | analyticOrderNatAt (fun w : ℂ =&gt; g (a * w + b)) z = analyticOrderNatAt g (a * z + b) | g : ℂ → ℂ; b z : ℂ; ha : a ≠ 0 | The analytic order is unchanged by an invertible affine change of variable. | — | `EdgeBound.gz_partial_fraction`, `EdgeBound.gz_partial_fraction_num`, `Stage3.jensenF_order`, `EdgeBound.low_ball_count`, `EdgeBound.gz_partial_fraction_low`, `EdgeBound.low_ball_count_wide` |
| `Stage3.jensenF_order`<br/>theorem, line 336 | analyticOrderNatAt (jensenF T) w = analyticOrderNatAt ζ (2 * w + (2 + Complex.I * (T : ℂ))) | hT : 2 ≤ T; hw : ‖w‖ ≤ 11 / 10 | — | `Stage3.analyticOrderNatAt_fun_comp_affine`, `Stage3.jensenF`, `Stage3.zeta_centre_ne_zero`, `Stage3.zeta_comp_analytic` | `Stage3.zeta_local_zero_count` |
| `Stage3.zeta_local_zero_count`<br/>theorem, line 354 | ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) ≤ 15 * Real.log T + 73 | hT : 2 ≤ T | THE LOCAL ZERO COUNT. For every `T ≥ 2`, the total order of the zeros of `ζ` in the closed disk `\|s - (2 + iT)\| ≤ 7/4` — a disk which meets the critical line in the segment `\|γ - T\| ≤ √(13/16)` — is at most `15 log T + 73`. | `Stage3.jensenF`, `Stage3.jensenF_analytic`, `Stage3.jensenF_bound`, `Stage3.jensenF_order`, `Stage3.jensenF_zero_eq_one`, `Stage3.jensenF_zeros_finite`, `Stage3.zetaWindow`, `Stage3.zetaWindow_finite`, `Stage3.zeta_centre_ne_zero` | `ContourShift.goodT_exists`, `EdgeBound.ball_order_sum_le`, `EdgeBound.ball_order_sum_le_num`, `Glue.band_order_sum_le`, `Glue.band_order_sum_le_num`, `Stage3.localCount_holds`, `WeilBands.band_count` |
| `Stage3.zetaLocalCount`<br/>def, line 441 | ℝ | T : ℝ | The count function. Total zero order of `ζ` in `\|s - (2+iT)\| ≤ 7/4`. | `Stage3.zetaWindow` | `Stage3.backlundArg_of_sFromLocal`, `Stage3.rvM_of_sFromLocal`, `Stage3.localCount_holds`, `Stage3.zetaLocalCount_eq` |
| `Stage3.zetaLocalCount_eq`<br/>theorem, line 444 | zetaLocalCount T = ∑ ρ ∈ (zetaWindow_finite hT).toFinset, (analyticOrderNatAt ζ ρ : ℝ) | hT : 2 ≤ T | — | `Stage3.zetaLocalCount`, `Stage3.zetaWindow_finite` | `Stage3.localCount_holds` |
| `Stage3.localCount_holds`<br/>theorem, line 455 | StmtLocalCount zetaLocalCount 15 73 | — | THE LEAF, DISCHARGED. `StmtLocalCount` holds for the concrete zeta zero count with the explicit constants `A₁ = 15`, `A₃ = 73`. Entry 130's budget accepts `A₁ ≤ 100`, `A₃ ≤ 1000`, so these clear it with room; the widening from radius `3/2` to `7/4` cost roughly a factor of two in `A₁` and is paid out of that budget. | `Stage3.StmtLocalCount`, `Stage3.zetaLocalCount`, `Stage3.zetaLocalCount_eq`, `Stage3.zeta_local_zero_count` | `Stage3.rvM_of_sFromLocal` |
