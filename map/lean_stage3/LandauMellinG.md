# `lean_stage3/Stage3/LandauMellinG.lean`

**What it does** (its own header): LandauMellinG — the Mellin transform of `G` on `Re s > 1`. Block 2b of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauMellin`](../lean_stage3/LandauMellin.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauPoleLocal`](../lean_stage3/LandauPoleLocal.md), [`LandauTaylor`](../lean_stage3/LandauTaylor.md).

```mermaid
flowchart LR
  n0["Phi<br/>(def)"]:::dfn
  n1["LSeries_vonMangoldt_real_ne_zero<br/>⊢ L ↗Λ (σ : ℂ) ≠ 0"]:::thm
  n2["rampSum_mellin_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-…"]:::thm
  n3["logPrim<br/>(def)"]:::dfn
  n4["hasDerivAt_logPrim<br/>⊢ HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y"]:::thm
  n5["log_cpow_norm_le<br/>⊢ ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖ ≤ y ^ ((s.re - 1) / 2 - s.re) / ((…"]:::thm
  n6["log_cpow_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1)"]:::thm
  n7["tendsto_logPrim<br/>⊢ Tendsto (logPrim s) atTop (𝓝 0)"]:::thm
  n8["log_cpow_integral<br/>⊢ ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ …"]:::thm
  n9["G_integrand_eq<br/>⊢ (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = (LandauWindow.rampSum y …"]:::thm
  n10["G_mellin_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)…"]:::thm
  n11["mellin_G<br/>⊢ ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi …"]:::thm
  x0(["JointSymbol · mellin_dd_iter"]):::ext
  x1(["JointSymbol · symPhi_principal_part"]):::ext
  x2(["LandauMellin · mellin_rampSum"]):::ext
  x3(["LandauPoleDisc · Phi_taylor_on_disc"]):::ext
  x4(["LandauPoleLocal · Phi_principal_part"]):::ext
  x5(["LandauPoleLocal · Phi_regular_at_one"]):::ext
  x6(["LandauPoleLocal · differentiableAt_Phi"]):::ext
  x7(["LandauPrimeSide · iteratedDeriv_Phi_eq_Ik"]):::ext
  x8(["LandauTaylor · iteratedDeriv_Phi"]):::ext
  x9(["LandauTaylor · mellinLog_integrable"]):::ext
  x10(["LandauWindow · G"]):::ext
  x11(["LandauWindow · rampSum"]):::ext
  n0 --> n11
  n0 --> x0
  n0 --> x1
  n0 --> x3
  n0 --> x4
  n0 --> x5
  n0 --> x6
  n0 --> x7
  n0 --> x8
  n1 --> n2
  n10 --> x0
  n10 --> x9
  n11 --> x0
  n11 --> x8
  n2 --> n10
  n2 --> n11
  n3 --> n4
  n3 --> n7
  n3 --> n8
  n4 --> n8
  n5 --> n6
  n6 --> n10
  n6 --> n11
  n6 --> n8
  n7 --> n8
  n8 --> n11
  n9 --> n10
  n9 --> n11
  x10 --> n10
  x10 --> n11
  x10 --> n9
  x11 --> n11
  x11 --> n2
  x11 --> n9
  x2 --> n11
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
| `LandauMellinG.Phi`<br/>def, line 43 | ℂ | s : ℂ | The Mellin transform of `G`: the `Φ` of the worksheet. | — | `JointSymbol.mellin_dd_iter`, `JointSymbol.symPhi_principal_part`, `LandauMellinG.mellin_G`, `LandauPoleDisc.Phi_taylor_on_disc`, `LandauPoleLocal.Phi_principal_part`, `LandauPoleLocal.Phi_regular_at_one`, `LandauPoleLocal.differentiableAt_Phi`, `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`, `LandauTaylor.iteratedDeriv_Phi` |
| `LandauMellinG.LSeries_vonMangoldt_real_ne_zero`<br/>theorem, line 47 | L ↗Λ (σ : ℂ) ≠ 0 | hσ : 1 &lt; σ | — | — | `LandauMellinG.rampSum_mellin_integrable` |
| `LandauMellinG.rampSum_mellin_integrable`<br/>theorem, line 77 | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) | hs : 1 &lt; s.re | — | `LandauMellin.mellin_rampSum`, `LandauMellinG.LSeries_vonMangoldt_real_ne_zero`, `LandauWindow.rampSum` | `LandauMellinG.G_mellin_integrable`, `LandauMellinG.mellin_G` |
| `LandauMellinG.logPrim`<br/>def, line 115 | ℂ | s : ℂ; t : ℝ | The primitive of `log y · y^(−s)`. | — | `LandauMellinG.hasDerivAt_logPrim`, `LandauMellinG.log_cpow_integral`, `LandauMellinG.tendsto_logPrim` |
| `LandauMellinG.hasDerivAt_logPrim`<br/>theorem, line 118 | HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y | hs1 : -s + 1 ≠ 0; hy : 0 &lt; y | — | `LandauMellinG.logPrim` | `LandauMellinG.log_cpow_integral` |
| `LandauMellinG.log_cpow_norm_le`<br/>theorem, line 137 | ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖ ≤ y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2) | hs : 1 &lt; s.re; hy : 1 &lt; y | — | — | `LandauMellinG.log_cpow_integrable` |
| `LandauMellinG.log_cpow_integrable`<br/>theorem, line 151 | IntegrableOn (fun y : ℝ =&gt; (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) | hs : 1 &lt; s.re | — | `LandauMellinG.log_cpow_norm_le` | `LandauMellinG.G_mellin_integrable`, `LandauMellinG.log_cpow_integral`, `LandauMellinG.mellin_G` |
| `LandauMellinG.tendsto_logPrim`<br/>theorem, line 166 | Tendsto (logPrim s) atTop (𝓝 0) | hs : 1 &lt; s.re | — | `LandauMellinG.logPrim` | `LandauMellinG.log_cpow_integral` |
| `LandauMellinG.log_cpow_integral`<br/>theorem, line 191 | ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2 | hs : 1 &lt; s.re | — | `LandauMellinG.hasDerivAt_logPrim`, `LandauMellinG.logPrim`, `LandauMellinG.log_cpow_integrable`, `LandauMellinG.tendsto_logPrim` | `LandauMellinG.mellin_G` |
| `LandauMellinG.G_integrand_eq`<br/>theorem, line 207 | (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) - (Real.log y : ℂ) * (y : ℂ) ^ (-s) + (1 + (Real.eulerMascheroniConstant : ℂ)) * (y : ℂ) ^ (-s) | s : ℂ; hy : 1 &lt; y | — | `LandauWindow.G`, `LandauWindow.rampSum` | `LandauMellinG.G_mellin_integrable`, `LandauMellinG.mellin_G` |
| `LandauMellinG.G_mellin_integrable`<br/>theorem, line 220 | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) | hs : 1 &lt; s.re | — | `LandauMellinG.G_integrand_eq`, `LandauMellinG.log_cpow_integrable`, `LandauMellinG.rampSum_mellin_integrable`, `LandauWindow.G` | `JointSymbol.mellin_dd_iter`, `LandauTaylor.mellinLog_integrable` |
| `LandauMellinG.mellin_G`<br/>theorem, line 229 | ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s | hs : 1 &lt; s.re | — | `LandauMellin.mellin_rampSum`, `LandauMellinG.G_integrand_eq`, `LandauMellinG.Phi`, `LandauMellinG.log_cpow_integrable`, `LandauMellinG.log_cpow_integral`, `LandauMellinG.rampSum_mellin_integrable`, `LandauWindow.G`, `LandauWindow.rampSum` | `JointSymbol.mellin_dd_iter`, `LandauTaylor.iteratedDeriv_Phi` |
