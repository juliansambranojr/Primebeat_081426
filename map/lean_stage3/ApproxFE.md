# `lean_stage3/Stage3/ApproxFE.lean`

> **Read from the source text.** This file changed after the last `python3 utilities/lean_map.py --dump`, so the arrows on this page are names occurring in each proof and have not been confirmed by Lean.

# ApproxFE — block S12 of `lean_stage3/design/stencil.md`, piece 1. 2026-11-25. Young's Lemma 4 (arXiv 1002.4403, §4): the approximate functional equation for `ζ(1/2+α+it)·ζ(1/2+β−it)` with the smoothing `G(s) = e^(s²)·p(s)`, `p(s) = ((α+β)² − (2s)²)/(α+β)²`.

35 theorems, 10 definitions, 766 lines. 

**Imports:** nothing in this tree  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ApproxShift`](../lean_stage3/ApproxShift.md)

## The picture

### Diagram 1 of 2: `uA_re` to `gamma_ne_off`

```mermaid
flowchart LR
  n0["<b>uA_re</b><br/>(uA α t).re = 1 / 2 + α.re"]:::cnt
  n1["<b>vB_re</b><br/>(vB β t).re = 1 / 2 + β.re"]:::cnt
  n2["<b>uA_im</b><br/>(uA α t).im = α.im + t"]:::cnt
  n3["<b>vB_im</b><br/>(vB β t).im = β.im - t"]:::cnt
  n4["<b>zeta_fe</b><br/>riemannZeta s = Gammaℝ (1 - s) / Gammaℝ s * riemannZeta (1 - s)"]:::thm
  n5["<b>zeta_prod_fe ■</b><br/>riemannZeta (uA α t) * riemannZeta (vB β t) = XY α β t * (rieman…"]:::thm
  n6["<b>Gammaℝ_uA_ne ■</b><br/>Gammaℝ (uA α t) ≠ 0"]:::cnt
  n7["<b>Gammaℝ_vB_ne ■</b><br/>Gammaℝ (vB β t) ≠ 0"]:::cnt
  n8["<b>ratio_aux</b><br/>P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D)) = P ^ k * (A…"]:::cnt
  n9["<b>XY_eq_young</b><br/>XY α β t = (Real.pi : ℂ) ^ (α + β) * (Gamma ((1 / 2 - α - t * I)…"]:::shp
  n10["<b>gY_eq_young ■</b><br/>gY α β t s = (Real.pi : ℂ) ^ (-s) * (Gamma ((1 / 2 + α + s + t *…"]:::shp
  n11["<b>coef_eq_young ■</b><br/>(x : ℂ) ^ (-uA α t) * (y : ℂ) ^ (-vB β t) = (x : ℂ) ^ (-(1 / 2 +…"]:::shp
  n12["<b>norm_Gamma_le</b><br/>‖Gamma z‖ ≤ Real.Gamma z.re"]:::shp
  n13["<b>norm_Gammaℝ_le ■</b><br/>‖Gammaℝ w‖ ≤ Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2)"]:::shp
  n14["<b>differentiableAt_Gammaℝ ■</b><br/>DifferentiableAt ℂ Gammaℝ s"]:::cnt
  n15["<b>norm_succ_cpow</b><br/>‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re"]:::cnt
  n16["<b>summable_succ_rpow</b><br/>Summable fun m : ℕ =＞ ((m : ℝ) + 1) ^ r"]:::shp
  n17["<b>summable_zeta_norm</b><br/>Summable fun n : ℕ =＞ ‖1 / ((n : ℂ) + 1) ^ w‖"]:::shp
  n18["<b>KY_bound</b><br/>∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp …"]:::shp
  n19["<b>KY_differentiableAt</b><br/>DifferentiableAt ℂ (KY α β t) s"]:::cnt
  n20["<b>KY_continuous_line</b><br/>Continuous fun y : ℝ =＞ KY α β t (c + y * I)"]:::shp
  n21["<b>tsum_pointwise</b><br/>∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-u) * ((p.2 : ℂ) + 1) ^ (-v) * …"]:::thm
  n22["<b>mellin_double_sum</b><br/>∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-…"]:::thm
  n23["<b>GY_neg</b><br/>GY α β (-s) = GY α β s"]:::cnt
  n24["<b>GY_swap</b><br/>GY (-β) (-α) s = GY α β s"]:::cnt
  n25["<b>uA_neg</b><br/>uA (-β) t = 1 - vB β t"]:::cnt
  n26["<b>vB_neg</b><br/>vB (-α) t = 1 - uA α t"]:::cnt
  n27["<b>gamma_mul_zeta</b><br/>Gammaℝ w * riemannZeta w = completedRiemannZeta w"]:::thm
  n28["<b>FY_reflect</b><br/>FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s)"]:::thm
  n29["<b>gamma_ne_off</b><br/>Gammaℝ (w + -((c : ℂ) + y * I)) ≠ 0"]:::shp
  x0(["<b>ApproxBounds</b><br/>9 theorems"]):::ext
  x1(["<b>ApproxDeriv</b><br/>4 theorems"]):::ext
  x2(["<b>ApproxDerivAll</b><br/>cont_gY"]):::ext
  x3(["<b>diagram 2</b><br/>approxFE_of_shift<br/>residue_zero<br/>vertInt_reflect"]):::ext
  x4(["<b>ApproxShift</b><br/>5 theorems"]):::ext
  x5(["<b>Diagonal</b><br/>7 theorems"]):::ext
  x6(["<b>SwapX</b><br/>S1_sharp<br/>S1_term_sharp"]):::ext
  x7(["<b>TwistedMoment</b><br/>5 theorems"]):::ext
  x8(["<b>StirlingX</b><br/>XY_eq_exp"]):::ext
  x9(["<b>OffDiagClose</b><br/>summable_major6"]):::ext
  n0 --> n18
  n0 --> n20
  n0 --> n22
  n0 --> n28
  n0 --> n5
  n0 --> n6
  n1 --> n18
  n1 --> n20
  n1 --> n22
  n1 --> n28
  n1 --> n5
  n1 --> n7
  n12 --> n13
  n15 --> n17
  n15 --> n22
  n16 --> n17
  n16 --> n22
  n17 --> n21
  n18 --> n22
  n19 --> n20
  n20 --> n22
  n21 --> n22
  n23 --> n28
  n24 --> n28
  n25 --> n28
  n26 --> n28
  n27 --> n28
  n4 --> n5
  n8 --> n10
  n8 --> n9
  n0 -.-> x0
  n0 -.-> x1
  n0 -.-> x2
  n0 -.-> x3
  n0 -.-> x4
  n0 -.-> x5
  n0 -.-> x6
  n0 -.-> x7
  n1 -.-> x0
  n1 -.-> x1
  n1 -.-> x2
  n1 -.-> x3
  n1 -.-> x4
  n1 -.-> x5
  n1 -.-> x6
  n1 -.-> x7
  n15 -.-> x5
  n15 -.-> x6
  n15 -.-> x7
  n16 -.-> x6
  n16 -.-> x7
  n16 -.-> x9
  n17 -.-> x5
  n18 -.-> x5
  n19 -.-> x0
  n2 -.-> x0
  n2 -.-> x1
  n2 -.-> x7
  n20 -.-> x5
  n22 -.-> x3
  n27 -.-> x4
  n28 -.-> x3
  n29 -.-> x3
  n3 -.-> x0
  n3 -.-> x1
  n3 -.-> x7
  n9 -.-> x8
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

### Diagram 2 of 2: `vertInt_reflect` to `approxFE_of_shift`

```mermaid
flowchart LR
  n0["<b>vertInt_reflect</b><br/>VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegra…"]:::thm
  n1["<b>GY_zero</b><br/>GY α β 0 = 1"]:::cnt
  n2["<b>gY_zero</b><br/>gY α β t 0 = 1"]:::cnt
  n3["<b>residue_zero ■</b><br/>Tendsto (fun s =＞ s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α…"]:::thm
  n4["<b>approxFE_of_shift</b><br/>riemannZeta (uA α t) * riemannZeta (vB β t) = (∑' p : ℕ × ℕ, ((p…"]:::thm
  x0(["<b>diagram 1</b><br/>5 theorems"]):::ext
  x1(["<b>ApproxBounds</b><br/>VY_residue"]):::ext
  x2(["<b>ApproxShift</b><br/>approxFE<br/>local_zero"]):::ext
  x3(["<b>Diagonal</b><br/>Hf_local"]):::ext
  n0 --> n4
  n1 --> n3
  n2 --> n3
  n1 -.-> x1
  n1 -.-> x2
  n2 -.-> x1
  n2 -.-> x3
  n4 -.-> x2
  x0 -.-> n0
  x0 -.-> n3
  x0 -.-> n4
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "A is used in the proof of B". Green: counting, integers only. Violet: shape, analysis with no ζ. Blue: reads ζ. A name ending in ■ is an end: nothing else uses it. Red: contains `sorry`. Yellow: theorems in another file, counted; a dotted arrow crosses files. Definitions are not drawn; they are listed below the diagram.

## Definitions

<a name="ApproxFE-uA"></a>
### `ApproxFE.uA`

def · line 51

- **Is:** `` uA (α : ℂ) (t : ℝ) : ℂ := 1 / 2 + α + t * I noncomputable ``
- **Used by 94:** [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log), [`ApproxBounds.XY_size`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_size), [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound), [`ApproxBounds.im_one_sub_uA`](../lean_stage3/ApproxBounds.md#ApproxBounds-im_one_sub_uA), [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt), [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-), [`ApproxBounds.re_one_sub_uA`](../lean_stage3/ApproxBounds.md#ApproxBounds-re_one_sub_uA), [`ApproxBounds.resY_T1`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T1), [`ApproxBounds.resY_T2`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T2), [`ApproxBounds.resY_T3`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T3), [`ApproxBounds.resY_T4`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T4), [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den), [`ApproxBounds.resY_small`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_small), [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local), [`ApproxDeriv.cont_dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-cont_dY), [`ApproxDeriv.d2Y`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-d2Y), [`ApproxDeriv.dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY), [`ApproxDeriv.dY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasDerivAt), [`ApproxDeriv.dY_hasSum`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasSum), [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt), [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds), [`ApproxDeriv.meas_d2Y`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-meas_d2Y), [`ApproxDeriv.norm_d2Y_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_d2Y_le), [`ApproxDeriv.norm_d2term_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_d2term_le), [`ApproxDeriv.norm_dY_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dY_le), [`ApproxDeriv.norm_dterm_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dterm_le), [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds), [`ApproxDeriv.re_half_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_half_pos), [`ApproxDeriv.summable_d2term`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-summable_d2term), [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY), [`ApproxDerivAll.dYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_hasDerivAt), [`ApproxDerivAll.dYterm`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYterm), [`ApproxDerivAll.meas_dYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_dYk), [`ApproxDerivAll.norm_dYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYk_le), [`ApproxDerivAll.norm_dYterm_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYterm_le), [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.Gammaℝ_uA_ne`](#ApproxFE-Gamma-_uA_ne), [`ApproxFE.KY_bound`](#ApproxFE-KY_bound), and 54 more (full list in `map/lean_map.json`)

<a name="ApproxFE-vB"></a>
### `ApproxFE.vB`

def · line 55

- **Is:** `` vB (β : ℂ) (t : ℝ) : ℂ := 1 / 2 + β - t * I noncomputable ``
- **Used by 94:** [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log), [`ApproxBounds.XY_size`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_size), [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound), [`ApproxBounds.im_one_sub_vB`](../lean_stage3/ApproxBounds.md#ApproxBounds-im_one_sub_vB), [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt), [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-), [`ApproxBounds.re_one_sub_vB`](../lean_stage3/ApproxBounds.md#ApproxBounds-re_one_sub_vB), [`ApproxBounds.resY_T1`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T1), [`ApproxBounds.resY_T2`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T2), [`ApproxBounds.resY_T3`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T3), [`ApproxBounds.resY_T4`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T4), [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den), [`ApproxBounds.resY_small`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_small), [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local), [`ApproxDeriv.cont_dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-cont_dY), [`ApproxDeriv.d2Y`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-d2Y), [`ApproxDeriv.dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY), [`ApproxDeriv.dY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasDerivAt), [`ApproxDeriv.dY_hasSum`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasSum), [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt), [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds), [`ApproxDeriv.meas_d2Y`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-meas_d2Y), [`ApproxDeriv.norm_d2Y_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_d2Y_le), [`ApproxDeriv.norm_d2term_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_d2term_le), [`ApproxDeriv.norm_dY_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dY_le), [`ApproxDeriv.norm_dterm_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dterm_le), [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds), [`ApproxDeriv.re_half_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_half_pos), [`ApproxDeriv.summable_d2term`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-summable_d2term), [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY), [`ApproxDerivAll.dYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_hasDerivAt), [`ApproxDerivAll.dYterm`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYterm), [`ApproxDerivAll.meas_dYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_dYk), [`ApproxDerivAll.norm_dYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYk_le), [`ApproxDerivAll.norm_dYterm_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYterm_le), [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.Gammaℝ_vB_ne`](#ApproxFE-Gamma-_vB_ne), [`ApproxFE.KY_bound`](#ApproxFE-KY_bound), and 54 more (full list in `map/lean_map.json`)

<a name="ApproxFE-XY"></a>
### `ApproxFE.XY`

def · line 59

- **Is:** `` XY (α β : ℂ) (t : ℝ) : ℂ := Gammaℝ (1 - uA α t) * Gammaℝ (1 - vB β t) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) noncomputable ``
- **Built from:** [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)
- **Used by 21:** [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log), [`ApproxBounds.XY_size`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_size), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.XY_eq_young`](#ApproxFE-XY_eq_young), [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift), [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect), [`ApproxFE.zeta_prod_fe`](#ApproxFE-zeta_prod_fe), [`ApproxShift.approxFE`](../lean_stage3/ApproxShift.md#ApproxShift-approxFE), [`Stirling.E_bound'`](../lean_stage3/StirlingX.md#Stirling-E_bound-), [`Stirling.StmtXStirlingRel`](../lean_stage3/StirlingX.md#Stirling-StmtXStirlingRel), [`Stirling.XY_eq_exp`](../lean_stage3/StirlingX.md#Stirling-XY_eq_exp), [`Stirling.stmtXAll_of'`](../lean_stage3/StirlingX.md#Stirling-stmtXAll_of-), [`Stirling.stmtXStirlingRel_holds`](../lean_stage3/StirlingX.md#Stirling-stmtXStirlingRel_holds), [`SwapX.E_bound`](../lean_stage3/SwapX.md#SwapX-E_bound), [`SwapX.StmtXStirling`](../lean_stage3/SwapX.md#SwapX-StmtXStirling), [`SwapX.integrable_IX`](../lean_stage3/SwapX.md#SwapX-integrable_IX), [`SwapX.stmtXAll_of`](../lean_stage3/SwapX.md#SwapX-stmtXAll_of), [`TwistedMoment.IX`](../lean_stage3/TwistedMoment.md#TwistedMoment-IX), [`TwistedMoment.I_split`](../lean_stage3/TwistedMoment.md#TwistedMoment-I_split), [`TwistedMoment.approxFE_small`](../lean_stage3/TwistedMoment.md#TwistedMoment-approxFE_small), [`TwistedMoment.integrand_split`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrand_split)

<a name="ApproxFE-GY"></a>
### `ApproxFE.GY`

def · line 64

- **Is:** `` GY (α β s : ℂ) : ℂ := cexp (s ^ 2) * (((α + β) ^ 2 - (2 * s) ^ 2) / (α + β) ^ 2) noncomputable ``
- **Used by 36:** [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.integrand_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_bound), [`ApproxBounds.resY_T1`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T1), [`ApproxBounds.resY_T2`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T2), [`ApproxBounds.resY_T3`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T3), [`ApproxBounds.resY_T4`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T4), [`ApproxBounds.resY_small`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_small), [`ApproxBounds.resY_term`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_term), [`ApproxDeriv.F_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-F_hasDerivAt), [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local), [`ApproxDerivAll.IYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk), [`ApproxDerivAll.IYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk_hasDerivAt), [`ApproxDerivAll.cont_pre`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_pre), [`ApproxDerivAll.norm_IYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_IYk_le), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.GY_neg`](#ApproxFE-GY_neg), [`ApproxFE.GY_swap`](#ApproxFE-GY_swap), [`ApproxFE.GY_zero`](#ApproxFE-GY_zero), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.KY_bound`](#ApproxFE-KY_bound), [`ApproxFE.KY_differentiableAt`](#ApproxFE-KY_differentiableAt), [`ApproxFE.resY`](#ApproxFE-resY), [`ApproxFE.residue_zero`](#ApproxFE-residue_zero), [`ApproxShift.FL`](../lean_stage3/ApproxShift.md#ApproxShift-FL), [`ApproxShift.FL_bound`](../lean_stage3/ApproxShift.md#ApproxShift-FL_bound), [`ApproxShift.FL_differentiableAt`](../lean_stage3/ApproxShift.md#ApproxShift-FL_differentiableAt), [`ApproxShift.GY_analyticAt`](../lean_stage3/ApproxShift.md#ApproxShift-GY_analyticAt), [`ApproxShift.GY_norm_le`](../lean_stage3/ApproxShift.md#ApproxShift-GY_norm_le), [`ApproxShift.local_zero`](../lean_stage3/ApproxShift.md#ApproxShift-local_zero), [`ApproxShift.resA`](../lean_stage3/ApproxShift.md#ApproxShift-resA), [`ApproxShift.stmtShift_holds`](../lean_stage3/ApproxShift.md#ApproxShift-stmtShift_holds), [`Diagonal.Hf_eq`](../lean_stage3/Diagonal.md#Diagonal-Hf_eq), [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont), [`Diagonal.diag_mellin`](../lean_stage3/Diagonal.md#Diagonal-diag_mellin), [`Diagonal.wVI_swap`](../lean_stage3/Diagonal.md#Diagonal-wVI_swap), [`TwistedMoment.resY_term_cAt`](../lean_stage3/TwistedMoment.md#TwistedMoment-resY_term_cAt)

<a name="ApproxFE-gY"></a>
### `ApproxFE.gY`

def · line 68

- **Is:** `` gY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ := Gammaℝ (uA α t + s) * Gammaℝ (vB β t + s) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) noncomputable ``
- **Built from:** [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)
- **Used by 28:** [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound), [`ApproxBounds.integrand_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_bound), [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local), [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt), [`ApproxDerivAll.IYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk), [`ApproxDerivAll.IYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk_hasDerivAt), [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY), [`ApproxDerivAll.gY_contDiff`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_contDiff), [`ApproxDerivAll.gY_contDiff_top`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_contDiff_top), [`ApproxDerivAll.gY_iter_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_bound), [`ApproxDerivAll.gY_iter_crude`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_crude), [`ApproxDerivAll.gY_iter_succ`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_succ), [`ApproxDerivAll.meas_gY_iter`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_gY_iter), [`ApproxDerivAll.norm_IYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_IYk_le), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.KY_bound`](#ApproxFE-KY_bound), [`ApproxFE.KY_differentiableAt`](#ApproxFE-KY_differentiableAt), [`ApproxFE.gY_eq_young`](#ApproxFE-gY_eq_young), [`ApproxFE.gY_zero`](#ApproxFE-gY_zero), [`ApproxFE.residue_zero`](#ApproxFE-residue_zero), [`ApproxShift.FY_eq_FL`](../lean_stage3/ApproxShift.md#ApproxShift-FY_eq_FL), [`Diagonal.Hf`](../lean_stage3/Diagonal.md#Diagonal-Hf), [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont), [`Diagonal.Kf`](../lean_stage3/Diagonal.md#Diagonal-Kf), [`Diagonal.Wg`](../lean_stage3/Diagonal.md#Diagonal-Wg), [`Diagonal.gY_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-gY_differentiableAt)

<a name="ApproxFE-KY"></a>
### `ApproxFE.KY`

def · line 73

- **Is:** `` KY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ := GY α β s / s * gY α β t s noncomputable ``
- **Built from:** [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.gY`](#ApproxFE-gY)
- **Used by 44:** [`ApproxBounds.VY_line_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_bound), [`ApproxBounds.VY_line_eq`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_eq), [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.integrand_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_bound), [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt), [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-), [`ApproxBounds.norm_VY_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-norm_VY_le), [`ApproxDeriv.F_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-F_hasDerivAt), [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local), [`ApproxDeriv.VY1`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY1), [`ApproxDeriv.VY1_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY1_hasDerivAt), [`ApproxDeriv.VY2`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY2), [`ApproxDeriv.VY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY_hasDerivAt), [`ApproxDeriv.VYj_line_bound`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VYj_line_bound), [`ApproxDeriv.cont_F`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-cont_F), [`ApproxDeriv.norm_F_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_F_local), [`ApproxDerivAll.IYk_local`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk_local), [`ApproxDerivAll.VYk_line_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_line_bound), [`ApproxDerivAll.VYk_zero`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_zero), [`ApproxDerivAll.norm_IYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_IYk_le), [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.KY_bound`](#ApproxFE-KY_bound), [`ApproxFE.KY_continuous_line`](#ApproxFE-KY_continuous_line), [`ApproxFE.KY_differentiableAt`](#ApproxFE-KY_differentiableAt), [`ApproxFE.VY`](#ApproxFE-VY), [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum), [`ApproxFE.residue_zero`](#ApproxFE-residue_zero), [`ApproxShift.FY_eq_FL`](../lean_stage3/ApproxShift.md#ApproxShift-FY_eq_FL), [`Diagonal.Hf_eq`](../lean_stage3/Diagonal.md#Diagonal-Hf_eq), [`Diagonal.KY_bd`](../lean_stage3/Diagonal.md#Diagonal-KY_bd), [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont), [`Diagonal.diag_per_t`](../lean_stage3/Diagonal.md#Diagonal-diag_per_t), [`Diagonal.diag_shift`](../lean_stage3/Diagonal.md#Diagonal-diag_shift), [`Diagonal.ell_sum`](../lean_stage3/Diagonal.md#Diagonal-ell_sum), [`Diagonal.inner_hk`](../lean_stage3/Diagonal.md#Diagonal-inner_hk), [`Diagonal.inner_t`](../lean_stage3/Diagonal.md#Diagonal-inner_t), [`Diagonal.joint_integrable`](../lean_stage3/Diagonal.md#Diagonal-joint_integrable), [`Diagonal.line_integrable`](../lean_stage3/Diagonal.md#Diagonal-line_integrable), [`Diagonal.orig_bound`](../lean_stage3/Diagonal.md#Diagonal-orig_bound), and 4 more (full list in `map/lean_map.json`)

<a name="ApproxFE-VY"></a>
### `ApproxFE.VY`

def · line 77

- **Is:** `` VY (α β : ℂ) (c x t : ℝ) : ℂ := VerticalIntegral' (fun s => KY α β t s * (x : ℂ) ^ (-s)) c noncomputable ``
- **Built from:** [`ApproxFE.KY`](#ApproxFE-KY)
- **Used by 41:** [`ApproxBounds.VY_decay`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_decay), [`ApproxBounds.VY_decay_young`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_decay_young), [`ApproxBounds.VY_line_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_bound), [`ApproxBounds.VY_line_eq`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_eq), [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue), [`ApproxBounds.norm_VY_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-norm_VY_le), [`ApproxDeriv.VY_deriv_bound`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY_deriv_bound), [`ApproxDeriv.VY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY_hasDerivAt), [`ApproxDeriv.VYj_lines`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VYj_lines), [`ApproxDeriv.iteratedDeriv_VY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-iteratedDeriv_VY), [`ApproxDerivAll.VY_contDiff`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VY_contDiff), [`ApproxDerivAll.VY_iter_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VY_iter_bound), [`ApproxDerivAll.VYk_lines`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_lines), [`ApproxDerivAll.VYk_zero`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_zero), [`ApproxDerivAll.iteratedDeriv_VY_all`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-iteratedDeriv_VY_all), [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift), [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum), [`ApproxShift.approxFE`](../lean_stage3/ApproxShift.md#ApproxShift-approxFE), [`Diagonal.ell_sum`](../lean_stage3/Diagonal.md#Diagonal-ell_sum), [`Diagonal.inner_hk`](../lean_stage3/Diagonal.md#Diagonal-inner_hk), [`Diagonal.inner_t`](../lean_stage3/Diagonal.md#Diagonal-inner_t), [`OffDiagClose.Fw_iter_bound`](../lean_stage3/OffDiagClose.md#OffDiagClose-Fw_iter_bound), [`OffDiagClose.Fw_iter_leibniz`](../lean_stage3/OffDiagClose.md#OffDiagClose-Fw_iter_leibniz), [`OffDiagClose.VY_iter_bound0`](../lean_stage3/OffDiagClose.md#OffDiagClose-VY_iter_bound0), [`OffDiagClose.VY_iter_on_supp`](../lean_stage3/OffDiagClose.md#OffDiagClose-VY_iter_on_supp), [`OffDiagClose.offdiag_term_iter`](../lean_stage3/OffDiagClose.md#OffDiagClose-offdiag_term_iter), [`SwapX.S1_term_sharp`](../lean_stage3/SwapX.md#SwapX-S1_term_sharp), [`TwistedMoment.Fw`](../lean_stage3/TwistedMoment.md#TwistedMoment-Fw), [`TwistedMoment.Fw1`](../lean_stage3/TwistedMoment.md#TwistedMoment-Fw1), [`TwistedMoment.Fw2`](../lean_stage3/TwistedMoment.md#TwistedMoment-Fw2), [`TwistedMoment.Fw2_bound`](../lean_stage3/TwistedMoment.md#TwistedMoment-Fw2_bound), [`TwistedMoment.Jint`](../lean_stage3/TwistedMoment.md#TwistedMoment-Jint), [`TwistedMoment.Jint_diag`](../lean_stage3/TwistedMoment.md#TwistedMoment-Jint_diag), [`TwistedMoment.S1`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1), [`TwistedMoment.S1_term_bound`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1_term_bound), [`TwistedMoment.S1term`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1term), [`TwistedMoment.continuous_VY`](../lean_stage3/TwistedMoment.md#TwistedMoment-continuous_VY), [`TwistedMoment.off_term_le`](../lean_stage3/TwistedMoment.md#TwistedMoment-off_term_le), [`TwistedMoment.offdiag_term`](../lean_stage3/TwistedMoment.md#TwistedMoment-offdiag_term), [`TwistedMoment.offdiag_term_young`](../lean_stage3/TwistedMoment.md#TwistedMoment-offdiag_term_young), and 1 more (full list in `map/lean_map.json`)

<a name="ApproxFE-FY"></a>
### `ApproxFE.FY`

def · line 82

- **Is:** `` FY (α β : ℂ) (t : ℝ) (s : ℂ) : ℂ := KY α β t s * (riemannZeta (uA α t + s) * riemannZeta (vB β t + s)) ``
- **Built from:** [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)
- **Used by 8:** [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect), [`ApproxFE.StmtShift`](#ApproxFE-StmtShift), [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum), [`ApproxFE.residue_zero`](#ApproxFE-residue_zero), [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect), [`ApproxShift.FY_eq_FL`](../lean_stage3/ApproxShift.md#ApproxShift-FY_eq_FL), [`ApproxShift.FY_horiz_bound`](../lean_stage3/ApproxShift.md#ApproxShift-FY_horiz_bound), [`ApproxShift.vertInt_FY_eq_FL`](../lean_stage3/ApproxShift.md#ApproxShift-vertInt_FY_eq_FL)

<a name="ApproxFE-resY"></a>
### `ApproxFE.resY`

def · line 679

- **Is:** `` resY (α β : ℂ) (t : ℝ) : ℂ := (GY α β (1 - uA α t) / (1 - uA α t) * completedRiemannZeta (vB β t + 1 - uA α t) + GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t) + GY α β (1 - vB β t) / (1 - vB β t) * completedRiemannZeta (uA α t + 1 - vB β t) + GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)) / (Gammaℝ (uA α t) * Gammaℝ (vB β t)) noncomputable ``
- **Built from:** [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)
- **Used by 12:** [`ApproxBounds.resY_small`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_small), [`ApproxFE.StmtShift`](#ApproxFE-StmtShift), [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift), [`ApproxShift.approxFE`](../lean_stage3/ApproxShift.md#ApproxShift-approxFE), [`ApproxShift.stmtShift_holds`](../lean_stage3/ApproxShift.md#ApproxShift-stmtShift_holds), [`TwistedMoment.I_split`](../lean_stage3/TwistedMoment.md#TwistedMoment-I_split), [`TwistedMoment.Ires`](../lean_stage3/TwistedMoment.md#TwistedMoment-Ires), [`TwistedMoment.Ires_small`](../lean_stage3/TwistedMoment.md#TwistedMoment-Ires_small), [`TwistedMoment.approxFE_small`](../lean_stage3/TwistedMoment.md#TwistedMoment-approxFE_small), [`TwistedMoment.continuousAt_resY`](../lean_stage3/TwistedMoment.md#TwistedMoment-continuousAt_resY), [`TwistedMoment.integrable_Ires`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrable_Ires), [`TwistedMoment.integrand_split`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrand_split)

<a name="ApproxFE-StmtShift"></a>
### `ApproxFE.StmtShift`

def · line 695

- **Is:** `` StmtShift (α β : ℂ) (t c : ℝ) : Prop := VerticalIntegral' (FY α β t) c - VerticalIntegral' (FY α β t) (-c) = riemannZeta (uA α t) * riemannZeta (vB β t) + resY α β t ``
- **Built from:** [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.resY`](#ApproxFE-resY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)
- **Used by 2:** [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift), [`ApproxShift.stmtShift_holds`](../lean_stage3/ApproxShift.md#ApproxShift-stmtShift_holds)

## Theorems

<a name="ApproxFE-uA_re"></a>
### `ApproxFE.uA_re`

line 85 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Proves**

```lean
(uA α t).re = 1 / 2 + α.re
```

**Needs** (its hypotheses)

  - `` α : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA)

**Feeds** (29 that use it)

  - [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue) (ApproxBounds) — `` VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 ``
  - [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log) (ApproxBounds) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| … ``
  - [`ApproxBounds.XY_size`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_size) (ApproxBounds) — `` ∃ C : ℝ, 0 < C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ‖XY α β t‖ ≤ C * (t / (2 * Real.pi)) ^ (-(α + β).re) ∧ (t / (2 * Real.pi)) … ``
  - [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound) (ApproxBounds) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi… ``
  - [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxBounds.resY_T2`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T2) (ApproxBounds) — `` ‖GY α β (-uA α t) / uA α t * completedRiemannZeta (vB β t - uA α t)‖ ≤ Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) * (1 + (t + 1 / 10… ``
  - [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den) (ApproxBounds) — `` Real.exp (-(2 * (2 * K + |Real.log (Real.Gamma (1 / 2))|)) - (Real.pi / 2 + 1) * (t + 1 / 10)) ≤ ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ ``
  - [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local) (ApproxDeriv) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ, ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
  - [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt) (ApproxDeriv) — `` HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t ``
  - [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds) (ApproxDeriv) — `` 1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧ 1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re ``
  - [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY) (ApproxDerivAll) — `` Continuous fun y : ℝ => gY α β t (σ + y * I) ``
  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``
  - [`ApproxFE.Gammaℝ_uA_ne`](#ApproxFE-Gamma-_uA_ne) — `` Gammaℝ (uA α t) ≠ 0 ``
  - [`ApproxFE.KY_bound`](#ApproxFE-KY_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2) ``
  - [`ApproxFE.KY_continuous_line`](#ApproxFE-KY_continuous_line) — `` Continuous fun y : ℝ => KY α β t (c + y * I) ``
  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`ApproxFE.residue_zero`](#ApproxFE-residue_zero) — `` Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) ``
  - [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect) — `` VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) ``
  - [`ApproxFE.zeta_prod_fe`](#ApproxFE-zeta_prod_fe) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I)) ``
  - [`ApproxShift.FL_bound`](../lean_stage3/ApproxShift.md#ApproxShift-FL_bound) (ApproxShift) — `` ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| → ‖FL α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) ``
  - [`ApproxShift.stmtShift_holds`](../lean_stage3/ApproxShift.md#ApproxShift-stmtShift_holds) (ApproxShift) — `` StmtShift α β t c ``
  - [`Diagonal.Hf_local`](../lean_stage3/Diagonal.md#Diagonal-Hf_local) (Diagonal) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ), Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) ``
  - [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont) (Diagonal) — `` Continuous fun p : ℝ × ℝ => KY α β p.1 (σ + p.2 * I) ``
  - [`Diagonal.gY_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-gY_differentiableAt) (Diagonal) — `` DifferentiableAt ℂ (gY α β t) s ``
  - [`SwapX.S1_term_sharp`](../lean_stage3/SwapX.md#SwapX-S1_term_sharp) (SwapX) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β 1 (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ CV * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2… ``
  - [`TwistedMoment.S1_term_bound`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1_term_bound) (TwistedMoment) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * B ^ 2 * (((… ``
  - [`TwistedMoment.continuousAt_resY`](../lean_stage3/TwistedMoment.md#TwistedMoment-continuousAt_resY) (TwistedMoment) — `` ContinuousAt (fun t => resY α β t) t ``
  - [`TwistedMoment.integrable_Imom`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrable_Imom) (TwistedMoment) — `` Integrable fun t => (W.w t : ℂ) * (riemannZeta (uA α t) * riemannZeta (vB β t)) * (msq M a σ₀ t : ℂ) ``

<a name="ApproxFE-vB_re"></a>
### `ApproxFE.vB_re`

line 88 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Proves**

```lean
(vB β t).re = 1 / 2 + β.re
```

**Needs** (its hypotheses)

  - `` β : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (29 that use it)

  - [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue) (ApproxBounds) — `` VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 ``
  - [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log) (ApproxBounds) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| … ``
  - [`ApproxBounds.XY_size`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_size) (ApproxBounds) — `` ∃ C : ℝ, 0 < C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ‖XY α β t‖ ≤ C * (t / (2 * Real.pi)) ^ (-(α + β).re) ∧ (t / (2 * Real.pi)) … ``
  - [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound) (ApproxBounds) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi… ``
  - [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxBounds.resY_T4`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_T4) (ApproxBounds) — `` ‖GY α β (-vB β t) / vB β t * completedRiemannZeta (uA α t - vB β t)‖ ≤ Real.exp (1 - (t - 1 / 10) ^ 2) * (9 * (1 + 1 / ‖α + β‖ ^ 2) * (1 + (t + 1 / 10… ``
  - [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den) (ApproxBounds) — `` Real.exp (-(2 * (2 * K + |Real.log (Real.Gamma (1 / 2))|)) - (Real.pi / 2 + 1) * (t + 1 / 10)) ≤ ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ ``
  - [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local) (ApproxDeriv) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ, ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
  - [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt) (ApproxDeriv) — `` HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t ``
  - [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds) (ApproxDeriv) — `` 1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧ 1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re ``
  - [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY) (ApproxDerivAll) — `` Continuous fun y : ℝ => gY α β t (σ + y * I) ``
  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``
  - [`ApproxFE.Gammaℝ_vB_ne`](#ApproxFE-Gamma-_vB_ne) — `` Gammaℝ (vB β t) ≠ 0 ``
  - [`ApproxFE.KY_bound`](#ApproxFE-KY_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2) ``
  - [`ApproxFE.KY_continuous_line`](#ApproxFE-KY_continuous_line) — `` Continuous fun y : ℝ => KY α β t (c + y * I) ``
  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`ApproxFE.residue_zero`](#ApproxFE-residue_zero) — `` Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) ``
  - [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect) — `` VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) ``
  - [`ApproxFE.zeta_prod_fe`](#ApproxFE-zeta_prod_fe) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I)) ``
  - [`ApproxShift.FL_bound`](../lean_stage3/ApproxShift.md#ApproxShift-FL_bound) (ApproxShift) — `` ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| → ‖FL α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) ``
  - [`ApproxShift.stmtShift_holds`](../lean_stage3/ApproxShift.md#ApproxShift-stmtShift_holds) (ApproxShift) — `` StmtShift α β t c ``
  - [`Diagonal.Hf_local`](../lean_stage3/Diagonal.md#Diagonal-Hf_local) (Diagonal) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ), Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) ``
  - [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont) (Diagonal) — `` Continuous fun p : ℝ × ℝ => KY α β p.1 (σ + p.2 * I) ``
  - [`Diagonal.gY_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-gY_differentiableAt) (Diagonal) — `` DifferentiableAt ℂ (gY α β t) s ``
  - [`SwapX.S1_term_sharp`](../lean_stage3/SwapX.md#SwapX-S1_term_sharp) (SwapX) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β 1 (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ CV * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2… ``
  - [`TwistedMoment.S1_term_bound`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1_term_bound) (TwistedMoment) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * B ^ 2 * (((… ``
  - [`TwistedMoment.continuousAt_resY`](../lean_stage3/TwistedMoment.md#TwistedMoment-continuousAt_resY) (TwistedMoment) — `` ContinuousAt (fun t => resY α β t) t ``
  - [`TwistedMoment.integrable_Imom`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrable_Imom) (TwistedMoment) — `` Integrable fun t => (W.w t : ℂ) * (riemannZeta (uA α t) * riemannZeta (vB β t)) * (msq M a σ₀ t : ℂ) ``

<a name="ApproxFE-uA_im"></a>
### `ApproxFE.uA_im`

line 91 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Proves**

```lean
(uA α t).im = α.im + t
```

**Needs** (its hypotheses)

  - `` α : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA)

**Feeds** (5 that use it)

  - [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log) (ApproxBounds) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| … ``
  - [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound) (ApproxBounds) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi… ``
  - [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den) (ApproxBounds) — `` Real.exp (-(2 * (2 * K + |Real.log (Real.Gamma (1 / 2))|)) - (Real.pi / 2 + 1) * (t + 1 / 10)) ≤ ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ ``
  - [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds) (ApproxDeriv) — `` t / 5 ≤ |(uA α t / 2).im| ∧ t / 5 ≤ |(uA α t / 2 + ((σ : ℂ) + y * I) / 2).im| ∧ t / 5 ≤ |(vB β t / 2).im| ∧ t / 5 ≤ |(vB β t / 2 + ((σ : ℂ) + y * I) /… ``
  - [`TwistedMoment.uA_ne_vB`](../lean_stage3/TwistedMoment.md#TwistedMoment-uA_ne_vB) (TwistedMoment) — `` uA α t ≠ vB β t ``

<a name="ApproxFE-vB_im"></a>
### `ApproxFE.vB_im`

line 94 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Proves**

```lean
(vB β t).im = β.im - t
```

**Needs** (its hypotheses)

  - `` β : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (5 that use it)

  - [`ApproxBounds.XY_log`](../lean_stage3/ApproxBounds.md#ApproxBounds-XY_log) (ApproxBounds) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| … ``
  - [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound) (ApproxBounds) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi… ``
  - [`ApproxBounds.resY_den`](../lean_stage3/ApproxBounds.md#ApproxBounds-resY_den) (ApproxBounds) — `` Real.exp (-(2 * (2 * K + |Real.log (Real.Gamma (1 / 2))|)) - (Real.pi / 2 + 1) * (t + 1 / 10)) ≤ ‖Gammaℝ (uA α t) * Gammaℝ (vB β t)‖ ``
  - [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds) (ApproxDeriv) — `` t / 5 ≤ |(uA α t / 2).im| ∧ t / 5 ≤ |(uA α t / 2 + ((σ : ℂ) + y * I) / 2).im| ∧ t / 5 ≤ |(vB β t / 2).im| ∧ t / 5 ≤ |(vB β t / 2 + ((σ : ℂ) + y * I) /… ``
  - [`TwistedMoment.uA_ne_vB`](../lean_stage3/TwistedMoment.md#TwistedMoment-uA_ne_vB) (TwistedMoment) — `` uA α t ≠ vB β t ``

<a name="ApproxFE-zeta_fe"></a>
### `ApproxFE.zeta_fe`

line 100 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The functional equation in Young's shape: `ζ s = Gammaℝ(1−s)/Gammaℝ s · ζ(1−s)`.

**Proves**

```lean
riemannZeta s = Gammaℝ (1 - s) / Gammaℝ s * riemannZeta (1 - s)
```

**Needs** (its hypotheses)

  - `` hs : Gammaℝ s ≠ 0 ``
  - `` h1 : 0 < (1 - s).re ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`ApproxFE.zeta_prod_fe`](#ApproxFE-zeta_prod_fe) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I)) ``

<a name="ApproxFE-zeta_prod_fe"></a>
### `ApproxFE.zeta_prod_fe`

line 117 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Piece 1. For `Re α, Re β < 1/2`, `ζ(1/2+α+it) ζ(1/2+β−it) = X_{α,β,t} · ζ(1/2−α−it) ζ(1/2−β+it)`.

**Proves**

```lean
riemannZeta (uA α t) * riemannZeta (vB β t) = XY α β t * (riemannZeta (1 / 2 - α - t * I) * riemannZeta (1 / 2 - β + t * I))
```

**Needs** (its hypotheses)

  - `` hα : α.re < 1 / 2 ``
  - `` hβ : β.re < 1 / 2 ``
  - `` hu : Gammaℝ (uA α t) ≠ 0 ``
  - `` hv : Gammaℝ (vB β t) ≠ 0 ``

**Fed by** (3 theorems its proof uses)

  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``
  - [`ApproxFE.zeta_fe`](#ApproxFE-zeta_fe) — `` riemannZeta s = Gammaℝ (1 - s) / Gammaℝ s * riemannZeta (1 - s) ``

**Definitions its proof touches:** [`ApproxFE.XY`](#ApproxFE-XY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-Gamma-_uA_ne"></a>
### `ApproxFE.Gammaℝ_uA_ne`

line 141 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `Gammaℝ (uA α t) ≠ 0` once `Re α > −1/2`.

**Proves**

```lean
Gammaℝ (uA α t) ≠ 0
```

**Needs** (its hypotheses)

  - `` t : ℝ ``
  - `` hα : -(1 / 2) < α.re ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-Gamma-_vB_ne"></a>
### `ApproxFE.Gammaℝ_vB_ne`

line 145 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `Gammaℝ (vB β t) ≠ 0` once `Re β > −1/2`.

**Proves**

```lean
Gammaℝ (vB β t) ≠ 0
```

**Needs** (its hypotheses)

  - `` t : ℝ ``
  - `` hβ : -(1 / 2) < β.re ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-ratio_aux"></a>
### `ApproxFE.ratio_aux`

line 149 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** A ratio of four `π`-powers times Gamma values.

**Proves**

```lean
P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D)) = P ^ k * (A * B) / (C * D)
```

**Needs** (its hypotheses)

  - `` P A B C D a b c d k : ℂ ``
  - `` hP : P ≠ 0 ``
  - `` hk : a + b = k + (c + d) ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (2 that use it)

  - [`ApproxFE.XY_eq_young`](#ApproxFE-XY_eq_young) — `` XY α β t = (Real.pi : ℂ) ^ (α + β) * (Gamma ((1 / 2 - α - t * I) / 2) * Gamma ((1 / 2 - β + t * I) / 2)) / (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((… ``
  - [`ApproxFE.gY_eq_young`](#ApproxFE-gY_eq_young) — `` gY α β t s = (Real.pi : ℂ) ^ (-s) * (Gamma ((1 / 2 + α + s + t * I) / 2) * Gamma ((1 / 2 + β + s - t * I) / 2)) / (Gamma ((1 / 2 + α + t * I) / 2) * G… ``

<a name="ApproxFE-XY_eq_young"></a>
### `ApproxFE.XY_eq_young`

line 165 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Young's form of `X_{α,β,t}`: `π^(α+β) Γ((1/2−α−it)/2) Γ((1/2−β+it)/2) / (Γ((1/2+α+it)/2) Γ((1/2+β−it)/2))`.

**Proves**

```lean
XY α β t = (Real.pi : ℂ) ^ (α + β) * (Gamma ((1 / 2 - α - t * I) / 2) * Gamma ((1 / 2 - β + t * I) / 2)) / (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2))
```

**Needs** (its hypotheses)

  - `` α β : ℂ ``
  - `` t : ℝ ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.ratio_aux`](#ApproxFE-ratio_aux) — `` P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D)) = P ^ k * (A * B) / (C * D) ``

**Definitions its proof touches:** [`ApproxFE.XY`](#ApproxFE-XY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`Stirling.XY_eq_exp`](../lean_stage3/StirlingX.md#Stirling-XY_eq_exp) (StirlingX) — `` XY α β t = cexp (log (Real.pi : ℂ) * (α + β) + ((logG (wm t + -α / 2) + logG (wp t + -β / 2)) - (logG (wp t + α / 2) + logG (wm t + β / 2)))) ``

<a name="ApproxFE-gY_eq_young"></a>
### `ApproxFE.gY_eq_young`

line 183 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Young's form of `g_{α,β}(s,t)`: `π^(−s) Γ((u+s)/2) Γ((v+s)/2) / (Γ(u/2) Γ(v/2))`.

**Proves**

```lean
gY α β t s = (Real.pi : ℂ) ^ (-s) * (Gamma ((1 / 2 + α + s + t * I) / 2) * Gamma ((1 / 2 + β + s - t * I) / 2)) / (Gamma ((1 / 2 + α + t * I) / 2) * Gamma ((1 / 2 + β - t * I) / 2))
```

**Needs** (its hypotheses)

  - `` α β : ℂ ``
  - `` t : ℝ ``
  - `` s : ℂ ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.ratio_aux`](#ApproxFE-ratio_aux) — `` P ^ a * A * (P ^ b * B) / (P ^ c * C * (P ^ d * D)) = P ^ k * (A * B) / (C * D) ``

**Definitions its proof touches:** [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-coef_eq_young"></a>
### `ApproxFE.coef_eq_young`

line 201 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The coefficients in Young's form: for `x, y > 0`, `x^(−u) y^(−v) = x^(−1/2−α) y^(−1/2−β) (x/y)^(−it)`.

**Proves**

```lean
(x : ℂ) ^ (-uA α t) * (y : ℂ) ^ (-vB β t) = (x : ℂ) ^ (-(1 / 2 + α)) * (y : ℂ) ^ (-(1 / 2 + β)) * ((x / y : ℝ) : ℂ) ^ (-(t * I))
```

**Needs** (its hypotheses)

  - `` α β : ℂ ``
  - `` t : ℝ ``
  - `` hx : 0 < x ``
  - `` hy : 0 < y ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-norm_Gamma_le"></a>
### `ApproxFE.norm_Gamma_le`

line 219 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** `‖Γ z‖ ≤ Γ(Re z)` right of zero (the Euler integral; PNT+ `norm_le_Gamma_re`).

**Proves**

```lean
‖Gamma z‖ ≤ Real.Gamma z.re
```

**Needs** (its hypotheses)

  - `` hz : 0 < z.re ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`ApproxFE.norm_Gammaℝ_le`](#ApproxFE-norm_Gamma-_le) — `` ‖Gammaℝ w‖ ≤ Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2) ``

<a name="ApproxFE-norm_Gamma-_le"></a>
### `ApproxFE.norm_Gammaℝ_le`

line 235 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** `‖Gammaℝ w‖ ≤ π^(−Re w/2) Γ(Re w/2)` right of zero.

**Proves**

```lean
‖Gammaℝ w‖ ≤ Real.pi ^ (-w.re / 2) * Real.Gamma (w.re / 2)
```

**Needs** (its hypotheses)

  - `` hw : 0 < w.re ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.norm_Gamma_le`](#ApproxFE-norm_Gamma_le) — `` ‖Gamma z‖ ≤ Real.Gamma z.re ``

**Feeds:** nothing. It is an end.

<a name="ApproxFE-differentiableAt_Gamma-"></a>
### `ApproxFE.differentiableAt_Gammaℝ`

line 246 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `Gammaℝ` is differentiable wherever it does not vanish.

**Proves**

```lean
DifferentiableAt ℂ Gammaℝ s
```

**Needs** (its hypotheses)

  - `` hs : Gammaℝ s ≠ 0 ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds:** nothing. It connects to nothing.

<a name="ApproxFE-norm_succ_cpow"></a>
### `ApproxFE.norm_succ_cpow`

line 254 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** The norm of a shifted natural power.

**Proves**

```lean
‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re
```

**Needs** (its hypotheses)

  - `` m : ℕ ``
  - `` z : ℂ ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (5 that use it)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`ApproxFE.summable_zeta_norm`](#ApproxFE-summable_zeta_norm) — `` Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖ ``
  - [`Diagonal.zeta_dirichlet_bound`](../lean_stage3/Diagonal.md#Diagonal-zeta_dirichlet_bound) (Diagonal) — `` ‖riemannZeta w‖ ≤ ∑' n : ℕ, ((n : ℝ) + 1) ^ (-w.re) ``
  - [`SwapX.S1_term_sharp`](../lean_stage3/SwapX.md#SwapX-S1_term_sharp) (SwapX) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β 1 (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ CV * (1 + 1 / ‖α + β‖ ^ 2) * t ^ (1 / 2… ``
  - [`TwistedMoment.S1_term_bound`](../lean_stage3/TwistedMoment.md#TwistedMoment-S1_term_bound) (TwistedMoment) — `` ‖((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * B ^ 2 * (((… ``

<a name="ApproxFE-summable_succ_rpow"></a>
### `ApproxFE.summable_succ_rpow`

line 260 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** `Σ (m+1)^r` converges for `r < −1`.

**Proves**

```lean
Summable fun m : ℕ => ((m : ℝ) + 1) ^ r
```

**Needs** (its hypotheses)

  - `` hr : r < -1 ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (5 that use it)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`ApproxFE.summable_zeta_norm`](#ApproxFE-summable_zeta_norm) — `` Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖ ``
  - [`OffDiagClose.summable_major6`](../lean_stage3/OffDiagClose.md#OffDiagClose-summable_major6) (OffDiagClose) — `` Summable major6 ``
  - [`SwapX.S1_sharp`](../lean_stage3/SwapX.md#SwapX-S1_sharp) (SwapX) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ‖α‖ ≤ η → ‖β‖ ≤ η → ∀ t : ℝ, 1 ≤ t → ‖S1 α β 1 t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * … ``
  - [`TwistedMoment.summable_major`](../lean_stage3/TwistedMoment.md#TwistedMoment-summable_major) (TwistedMoment) — `` Summable fun p : ℕ × ℕ => ((p.1 : ℝ) + 1) ^ (-(12 / 5) : ℝ) * ((p.2 : ℝ) + 1) ^ (-(12 / 5) : ℝ) ``

<a name="ApproxFE-summable_zeta_norm"></a>
### `ApproxFE.summable_zeta_norm`

line 268 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The Dirichlet series of `ζ` converges absolutely for `Re w > 1`.

**Proves**

```lean
Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖
```

**Needs** (its hypotheses)

  - `` hw : 1 < w.re ``

**Fed by** (2 theorems its proof uses)

  - [`ApproxFE.norm_succ_cpow`](#ApproxFE-norm_succ_cpow) — `` ‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re ``
  - [`ApproxFE.summable_succ_rpow`](#ApproxFE-summable_succ_rpow) — `` Summable fun m : ℕ => ((m : ℝ) + 1) ^ r ``

**Feeds** (3 that use it)

  - [`ApproxFE.tsum_pointwise`](#ApproxFE-tsum_pointwise) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-u) * ((p.2 : ℂ) + 1) ^ (-v) * (K * ((((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) : ℝ) : ℂ) ^ (-s)) = K * (riemannZeta (u + s) … ``
  - [`Diagonal.summable_cf`](../lean_stage3/Diagonal.md#Diagonal-summable_cf) (Diagonal) — `` Summable fun l : ℕ => ‖((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β))‖ * (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1)… ``
  - [`Diagonal.zeta_dirichlet_bound`](../lean_stage3/Diagonal.md#Diagonal-zeta_dirichlet_bound) (Diagonal) — `` ‖riemannZeta w‖ ≤ ∑' n : ℕ, ((n : ℝ) + 1) ^ (-w.re) ``

<a name="ApproxFE-KY_bound"></a>
### `ApproxFE.KY_bound`

line 275 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** On `Re s = c > 0` with `Re(u+s), Re(v+s) > 0`, the kernel `G(s)/s·g(s,t)` is at most a constant times `e^(−y²/2)`.

**Proves**

```lean
∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2)
```

**Needs** (its hypotheses)

  - `` hc : 0 < c ``
  - `` hu : 0 < 1 / 2 + α.re + c ``
  - `` hv : 0 < 1 / 2 + β.re + c ``

**Fed by** (2 theorems its proof uses)

  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (3 that use it)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`Diagonal.ell_sum`](../lean_stage3/Diagonal.md#Diagonal-ell_sum) (Diagonal) — `` ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ)… ``
  - [`Diagonal.line_integrable`](../lean_stage3/Diagonal.md#Diagonal-line_integrable) (Diagonal) — `` Integrable fun y : ℝ => KY α β t (c + y * I) * Z (c + y * I) ``

<a name="ApproxFE-KY_differentiableAt"></a>
### `ApproxFE.KY_differentiableAt`

line 366 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** The kernel is differentiable at `s ≠ 0` where `Gammaℝ(u+s), Gammaℝ(v+s) ≠ 0`.

**Proves**

```lean
DifferentiableAt ℂ (KY α β t) s
```

**Needs** (its hypotheses)

  - `` hs : s ≠ 0 ``
  - `` h1 : Gammaℝ (uA α t + s) ≠ 0 ``
  - `` h2 : Gammaℝ (vB β t + s) ≠ 0 ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (3 that use it)

  - [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-) (ApproxBounds) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
  - [`ApproxFE.KY_continuous_line`](#ApproxFE-KY_continuous_line) — `` Continuous fun y : ℝ => KY α β t (c + y * I) ``

<a name="ApproxFE-KY_continuous_line"></a>
### `ApproxFE.KY_continuous_line`

line 383 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** On `Re s = c > 0` with `Re(u+s), Re(v+s) > 0`, the kernel is continuous in `y`.

**Proves**

```lean
Continuous fun y : ℝ => KY α β t (c + y * I)
```

**Needs** (its hypotheses)

  - `` hc : 0 < c ``
  - `` hu : 0 < 1 / 2 + α.re + c ``
  - `` hv : 0 < 1 / 2 + β.re + c ``

**Fed by** (3 theorems its proof uses)

  - [`ApproxFE.KY_differentiableAt`](#ApproxFE-KY_differentiableAt) — `` DifferentiableAt ℂ (KY α β t) s ``
  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (3 that use it)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`Diagonal.ell_sum`](../lean_stage3/Diagonal.md#Diagonal-ell_sum) (Diagonal) — `` ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ)… ``
  - [`Diagonal.line_integrable`](../lean_stage3/Diagonal.md#Diagonal-line_integrable) (Diagonal) — `` Integrable fun y : ℝ => KY α β t (c + y * I) * Z (c + y * I) ``

<a name="ApproxFE-tsum_pointwise"></a>
### `ApproxFE.tsum_pointwise`

line 402 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The pointwise sum: `Σ m^(−u) n^(−v) K(s) (mn)^(−s) = K(s) ζ(u+s) ζ(v+s)`.

**Proves**

```lean
∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-u) * ((p.2 : ℂ) + 1) ^ (-v) * (K * ((((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) : ℝ) : ℂ) ^ (-s)) = K * (riemannZeta (u + s) * riemannZeta (v + s))
```

**Needs** (its hypotheses)

  - `` h1 : 1 < (u + s).re ``
  - `` h2 : 1 < (v + s).re ``

**Fed by** (1 theorem its proof uses)

  - [`ApproxFE.summable_zeta_norm`](#ApproxFE-summable_zeta_norm) — `` Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖ ``

**Feeds** (1 that use it)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``

<a name="ApproxFE-mellin_double_sum"></a>
### `ApproxFE.mellin_double_sum`

line 426 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Piece 2. For `c > 0` with `c + Re α > 1/2` and `c + Re β > 1/2`, `Σ_{m,n} m^(−1/2−α−it) n^(−1/2−β+it) V_c(mn,t) = (1/2πi) ∫_(c) G(s)/s g(s,t) ζ(u+s) ζ(v+s) ds`.

**Proves**

```lean
∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t) c
```

**Needs** (its hypotheses)

  - `` hc : 0 < c ``
  - `` hu : 1 / 2 < c + α.re ``
  - `` hv : 1 / 2 < c + β.re ``

**Fed by** (7 theorems its proof uses)

  - [`ApproxFE.KY_bound`](#ApproxFE-KY_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2) ``
  - [`ApproxFE.KY_continuous_line`](#ApproxFE-KY_continuous_line) — `` Continuous fun y : ℝ => KY α β t (c + y * I) ``
  - [`ApproxFE.norm_succ_cpow`](#ApproxFE-norm_succ_cpow) — `` ‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re ``
  - [`ApproxFE.summable_succ_rpow`](#ApproxFE-summable_succ_rpow) — `` Summable fun m : ℕ => ((m : ℝ) + 1) ^ r ``
  - [`ApproxFE.tsum_pointwise`](#ApproxFE-tsum_pointwise) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-u) * ((p.2 : ℂ) + 1) ^ (-v) * (K * ((((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1) : ℝ) : ℂ) ^ (-s)) = K * (riemannZeta (u + s) … ``
  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.VY`](#ApproxFE-VY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * (… ``

<a name="ApproxFE-GY_neg"></a>
### `ApproxFE.GY_neg`

line 499 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `G` is even.

**Proves**

```lean
GY α β (-s) = GY α β s
```

**Needs** (its hypotheses)

  - `` α β s : ℂ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.GY`](#ApproxFE-GY)

**Feeds** (1 that use it)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``

<a name="ApproxFE-GY_swap"></a>
### `ApproxFE.GY_swap`

line 504 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `G` for `(−β,−α)` is `G` for `(α,β)`.

**Proves**

```lean
GY (-β) (-α) s = GY α β s
```

**Needs** (its hypotheses)

  - `` α β s : ℂ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.GY`](#ApproxFE-GY)

**Feeds** (1 that use it)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``

<a name="ApproxFE-uA_neg"></a>
### `ApproxFE.uA_neg`

line 509 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** The swap `(α,β) ↦ (−β,−α)` sends `u` to `1 − v`.

**Proves**

```lean
uA (-β) t = 1 - vB β t
```

**Needs** (its hypotheses)

  - `` β : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``

<a name="ApproxFE-vB_neg"></a>
### `ApproxFE.vB_neg`

line 514 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** The swap `(α,β) ↦ (−β,−α)` sends `v` to `1 − u`.

**Proves**

```lean
vB (-α) t = 1 - uA α t
```

**Needs** (its hypotheses)

  - `` α : ℂ ``
  - `` t : ℝ ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``

<a name="ApproxFE-gamma_mul_zeta"></a>
### `ApproxFE.gamma_mul_zeta`

line 519 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** `Gammaℝ w · ζ w = Λ w` where `Gammaℝ w ≠ 0`.

**Proves**

```lean
Gammaℝ w * riemannZeta w = completedRiemannZeta w
```

**Needs** (its hypotheses)

  - `` hw : Gammaℝ w ≠ 0 ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (4 that use it)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``
  - [`ApproxShift.FY_eq_FL`](../lean_stage3/ApproxShift.md#ApproxShift-FY_eq_FL) (ApproxShift) — `` FY α β t s = FL α β t s ``
  - [`ApproxShift.Lambda_bound`](../lean_stage3/ApproxShift.md#ApproxShift-Lambda_bound) (ApproxShift) — `` ∃ M : ℝ, 0 ≤ M ∧ ∀ w : ℂ, |w.re| ≤ R → 1 ≤ |w.im| → ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖) ``
  - [`ApproxShift.local_zero`](../lean_stage3/ApproxShift.md#ApproxShift-local_zero) (ApproxShift) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] 0, FL α β t s = h s + riemannZeta (uA α t) * riemannZeta (vB β t) / (s - 0) ``

<a name="ApproxFE-FY_reflect"></a>
### `ApproxFE.FY_reflect`

line 529 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The left line in terms of the right: `FY(−s) = −X_{α,β,t} · FY_{−β,−α}(s)`.

**Proves**

```lean
FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s)
```

**Needs** (its hypotheses)

  - `` hα : α.re < 1 / 2 ``
  - `` hβ : β.re < 1 / 2 ``
  - `` hu : Gammaℝ (uA α t) ≠ 0 ``
  - `` hv : Gammaℝ (vB β t) ≠ 0 ``
  - `` hs0 : s ≠ 0 ``
  - `` h1 : 0 < (1 - uA α t + s).re ``
  - `` h2 : 0 < (1 - vB β t + s).re ``
  - `` hg1 : Gammaℝ (uA α t + -s) ≠ 0 ``
  - `` hg2 : Gammaℝ (vB β t + -s) ≠ 0 ``

**Fed by** (7 theorems its proof uses)

  - [`ApproxFE.GY_neg`](#ApproxFE-GY_neg) — `` GY α β (-s) = GY α β s ``
  - [`ApproxFE.GY_swap`](#ApproxFE-GY_swap) — `` GY (-β) (-α) s = GY α β s ``
  - [`ApproxFE.gamma_mul_zeta`](#ApproxFE-gamma_mul_zeta) — `` Gammaℝ w * riemannZeta w = completedRiemannZeta w ``
  - [`ApproxFE.uA_neg`](#ApproxFE-uA_neg) — `` uA (-β) t = 1 - vB β t ``
  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_neg`](#ApproxFE-vB_neg) — `` vB (-α) t = 1 - uA α t ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.XY`](#ApproxFE-XY), [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect) — `` VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) ``

<a name="ApproxFE-gamma_ne_off"></a>
### `ApproxFE.gamma_ne_off`

line 568 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Off the two heights `y = Im u` and `y = Im v`, the reflection's hypotheses hold on `Re s = c`.

**Proves**

```lean
Gammaℝ (w + -((c : ℂ) + y * I)) ≠ 0
```

**Needs** (its hypotheses)

  - `` hy : y ≠ w.im ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect) — `` VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) ``

<a name="ApproxFE-vertInt_reflect"></a>
### `ApproxFE.vertInt_reflect`

line 577 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The left line: `(1/2πi)∫_(−c) FY = −X_{α,β,t} · (1/2πi)∫_(c) FY_{−β,−α}`.

**Proves**

```lean
VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c)
```

**Needs** (its hypotheses)

  - `` hc : 0 < c ``
  - `` hα : α.re < 1 / 2 ``
  - `` hβ : β.re < 1 / 2 ``
  - `` hu : Gammaℝ (uA α t) ≠ 0 ``
  - `` hv : Gammaℝ (vB β t) ≠ 0 ``

**Fed by** (4 theorems its proof uses)

  - [`ApproxFE.FY_reflect`](#ApproxFE-FY_reflect) — `` FY α β t (-s) = -(XY α β t * FY (-β) (-α) t s) ``
  - [`ApproxFE.gamma_ne_off`](#ApproxFE-gamma_ne_off) — `` Gammaℝ (w + -((c : ℂ) + y * I)) ≠ 0 ``
  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.XY`](#ApproxFE-XY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxFE.approxFE_of_shift`](#ApproxFE-approxFE_of_shift) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * (… ``

<a name="ApproxFE-GY_zero"></a>
### `ApproxFE.GY_zero`

line 613 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `G(0) = 1` once `α + β ≠ 0`.

**Proves**

```lean
GY α β 0 = 1
```

**Needs** (its hypotheses)

  - `` h : α + β ≠ 0 ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.GY`](#ApproxFE-GY)

**Feeds** (3 that use it)

  - [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue) (ApproxBounds) — `` VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 ``
  - [`ApproxFE.residue_zero`](#ApproxFE-residue_zero) — `` Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) ``
  - [`ApproxShift.local_zero`](../lean_stage3/ApproxShift.md#ApproxShift-local_zero) (ApproxShift) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] 0, FL α β t s = h s + riemannZeta (uA α t) * riemannZeta (vB β t) / (s - 0) ``

<a name="ApproxFE-gY_zero"></a>
### `ApproxFE.gY_zero`

line 619 · arrows read from text

**Counting.** Integers only: nothing in its statement or proof, or in anything it rests on, uses analysis or ζ.

**Why.** `g(0,t) = 1` once `Gammaℝ u, Gammaℝ v ≠ 0`.

**Proves**

```lean
gY α β t 0 = 1
```

**Needs** (its hypotheses)

  - `` hu : Gammaℝ (uA α t) ≠ 0 ``
  - `` hv : Gammaℝ (vB β t) ≠ 0 ``

**Fed by:** no theorem of this repo; it stands on Mathlib and the definitions below.

**Definitions its proof touches:** [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (3 that use it)

  - [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue) (ApproxBounds) — `` VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 ``
  - [`ApproxFE.residue_zero`](#ApproxFE-residue_zero) — `` Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t))) ``
  - [`Diagonal.Hf_local`](../lean_stage3/Diagonal.md#Diagonal-Hf_local) (Diagonal) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ), Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) ``

<a name="ApproxFE-residue_zero"></a>
### `ApproxFE.residue_zero`

line 627 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The residue at `s = 0`: `s · FY(s) → ζ(u) ζ(v)`.

**Proves**

```lean
Tendsto (fun s => s * FY α β t s) (𝓝[≠] 0) (𝓝 (riemannZeta (uA α t) * riemannZeta (vB β t)))
```

**Needs** (its hypotheses)

  - `` hαβ : α + β ≠ 0 ``
  - `` hα : α.re < 1 / 2 ``
  - `` hβ : β.re < 1 / 2 ``
  - `` hu : Gammaℝ (uA α t) ≠ 0 ``
  - `` hv : Gammaℝ (vB β t) ≠ 0 ``

**Fed by** (4 theorems its proof uses)

  - [`ApproxFE.GY_zero`](#ApproxFE-GY_zero) — `` GY α β 0 = 1 ``
  - [`ApproxFE.gY_zero`](#ApproxFE-gY_zero) — `` gY α β t 0 = 1 ``
  - [`ApproxFE.uA_re`](#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
  - [`ApproxFE.vB_re`](#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``

**Definitions its proof touches:** [`ApproxFE.FY`](#ApproxFE-FY), [`ApproxFE.GY`](#ApproxFE-GY), [`ApproxFE.KY`](#ApproxFE-KY), [`ApproxFE.gY`](#ApproxFE-gY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds:** nothing. It is an end.

<a name="ApproxFE-approxFE_of_shift"></a>
### `ApproxFE.approxFE_of_shift`

line 704 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Young's Lemma 4, exact, given the shift. For `|Re α|, |Re β| < 1/2`, `c` with `c > 1/2 + |Re α|, 1/2 + |Re β|`: `ζ(1/2+α+it) ζ(1/2+β−it) = Σ_{m,n} m^(−1/2−α−it) n^(−1/2−β+it) V_{α,β}(mn,t) + X_{α,β,t} Σ_{m,n} m^(−1/2+β−it) n^(−1/2+α+it) V_{−β,−α}(mn,t) − resY`, both `V` read on the line `Re s = c`.

**Proves**

```lean
riemannZeta (uA α t) * riemannZeta (vB β t) = (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) + XY α β t * (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA (-β) t) * ((p.2 : ℂ) + 1) ^ (-vB (-α) t) * VY (-β) (-α) c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) - resY α β t
```

**Needs** (its hypotheses)

  - `` hα : α.re < 1 / 2 ``
  - `` hβ : β.re < 1 / 2 ``
  - `` hα' : -(1 / 2) < α.re ``
  - `` hβ' : -(1 / 2) < β.re ``
  - `` hcα : 1 / 2 + |α.re| < c ``
  - `` hcβ : 1 / 2 + |β.re| < c ``
  - `` hshift : StmtShift α β t c ``

**Fed by** (2 theorems its proof uses)

  - [`ApproxFE.mellin_double_sum`](#ApproxFE-mellin_double_sum) — `` ∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t = VerticalIntegral' (FY α β t… ``
  - [`ApproxFE.vertInt_reflect`](#ApproxFE-vertInt_reflect) — `` VerticalIntegral' (FY α β t) (-c) = -(XY α β t * VerticalIntegral' (FY (-β) (-α) t) c) ``

**Definitions its proof touches:** [`ApproxFE.StmtShift`](#ApproxFE-StmtShift), [`ApproxFE.VY`](#ApproxFE-VY), [`ApproxFE.XY`](#ApproxFE-XY), [`ApproxFE.resY`](#ApproxFE-resY), [`ApproxFE.uA`](#ApproxFE-uA), [`ApproxFE.vB`](#ApproxFE-vB)

**Feeds** (1 that use it)

  - [`ApproxShift.approxFE`](../lean_stage3/ApproxShift.md#ApproxShift-approxFE) (ApproxShift) — `` riemannZeta (uA α t) * riemannZeta (vB β t) = (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) * VY α β c (((p.1 : ℝ) + 1) * (… ``

