# `lean_stage3/Stage3/RouteNum.lean`

**What it does** (its own header): RouteNum — block E8c of `lean_stage3/design/joints.md`. 2026-11-22. The explicit-formula route at the gate with its three constants named, and a numeral above each constant in the chain.

**Imports:** [`GlueNum`](../lean_stage3/GlueNum.md), [`RouteGate`](../lean_stage3/RouteGate.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`GateEval`](../lean_stage3/GateEval.md).

```mermaid
flowchart LR
  n0["inv_log_two_le<br/>⊢ 1 / Real.log 2 ≤ 1.4428"]:::thm
  n1["C1n_le<br/>⊢ EdgeBound.C1n ≤ 1909224"]:::thm
  n2["C2n_le<br/>⊢ EdgeBound.C2n ≤ 2167"]:::thm
  n3["Cen_le<br/>⊢ EdgeBound.Cen ≤ 1911393"]:::thm
  n4["Cpn_le<br/>⊢ Glue.Cpn ≤ 6534550000"]:::thm
  n5["Chn_le<br/>⊢ Glue.Chn ≤ 44108300000"]:::thm
  n6["Csn_le<br/>⊢ Glue.Csn ≤ 1136"]:::thm
  n7["Dln_le<br/>⊢ Glue.Dln ≤ 89846200"]:::thm
  n8["c1n_le<br/>⊢ Glue.c1n ≤ 88216610000"]:::thm
  n9["c3n_le<br/>⊢ Glue.c3n ≤ 15"]:::thm
  n10["c4n_le<br/>⊢ Glue.c4n ≤ 6468930000"]:::thm
  n11["stmtEF_split_num<br/>⊢ StmtExplicitFormulaSplit Glue.c1n Glue.c3n Glue.c4n 16"]:::thm
  n12["routeConst<br/>(def)"]:::dfn
  n13["schoenfeldWeak_route_num<br/>⊢ StmtSchoenfeldWeak (routeConst x₀) 1 (max (x₀ ^ 2) 9) (fun x =＞ (Nat.p…"]:::thm
  n14["relErrWindow_route_num<br/>⊢ JointDialGate.StmtRelErrWindow (fun m : ℤ =＞ (Nat.primeCounting ⌊(2 : …"]:::thm
  x0(["ArgCount · rvM_crude"]):::ext
  x1(["BoxBounds · zeta_ratio_ge"]):::ext
  x2(["ContourShift · zeta_zeros_rectangle_finite"]):::ext
  x3(["EdgeNum · C1n"]):::ext
  x4(["EdgeNum · C2n"]):::ext
  x5(["EdgeNum · Cen"]):::ext
  x6(["EdgeNum · Cen_pos"]):::ext
  x7(["GateEval · gate_hyp_of_RH"]):::ext
  x8(["GateEval · routeConst_le"]):::ext
  x9(["GlueFloor · StmtExplicitFormulaSplit"]):::ext
  x10(["GlueFloor · floorConstSplit"]):::ext
  x11(["GlueFloor · floorConstSplit_nonneg"]):::ext
  x12(["GlueFloor · psiWeak_floor_split"]):::ext
  x13(["GlueNum · Chn"]):::ext
  x14(["GlueNum · Cpn"]):::ext
  x15(["GlueNum · Csn"]):::ext
  x16(["GlueNum · Dln"]):::ext
  x17(["GlueNum · c1n"]):::ext
  x18(["GlueNum · c1n_nonneg"]):::ext
  x19(["GlueNum · c3n"]):::ext
  x20(["GlueNum · c3n_nonneg"]):::ext
  x21(["GlueNum · c4n"]):::ext
  x22(["GlueNum · c4n_nonneg"]):::ext
  x23(["GlueNum · explicit_formula_split_num"]):::ext
  x24(["JointDialGate · StmtRelErrWindow"]):::ext
  x25(["JointFloorGate · weakWindow_relErr"]):::ext
  x26(["LowCount · low_rect_count"]):::ext
  x27(["PsiToPi · Li"]):::ext
  x28(["PsiToPi · schoenfeldWeak_of_psiWeak"]):::ext
  x29(["RowLeaves · Li_two_rpow"]):::ext
  x30(["RowLeaves · norm_logDerivZeta_zero"]):::ext
  x31(["Statement · StmtSchoenfeldWeak"]):::ext
  x32(["Statement · weakWindow_of_global"]):::ext
  x33(["TableDepths · cell_ne_zero_gen"]):::ext
  n0 --> n2
  n0 --> n3
  n0 --> n4
  n0 --> n6
  n0 --> n7
  n1 --> n3
  n10 --> x8
  n11 --> n13
  n12 --> n13
  n12 --> n14
  n12 --> x33
  n12 --> x7
  n12 --> x8
  n13 --> n14
  n14 --> x33
  n14 --> x7
  n2 --> n3
  n3 --> n4
  n3 --> n7
  n4 --> n5
  n5 --> n8
  n6 --> n8
  n7 --> n10
  n8 --> x8
  n9 --> x8
  x0 --> n13
  x1 --> n1
  x10 --> n12
  x11 --> n13
  x11 --> n14
  x12 --> n13
  x13 --> n5
  x14 --> n4
  x15 --> n6
  x16 --> n7
  x17 --> n11
  x17 --> n12
  x17 --> n8
  x18 --> n13
  x18 --> n14
  x19 --> n11
  x19 --> n12
  x19 --> n9
  x2 --> n2
  x20 --> n13
  x20 --> n14
  x21 --> n10
  x21 --> n11
  x21 --> n12
  x22 --> n13
  x22 --> n14
  x23 --> n11
  x24 --> n14
  x25 --> n14
  x26 --> n2
  x27 --> n13
  x27 --> n14
  x28 --> n13
  x29 --> n14
  x3 --> n1
  x30 --> n9
  x31 --> n13
  x32 --> n14
  x4 --> n2
  x5 --> n3
  x5 --> n4
  x6 --> n4
  x9 --> n11
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
| `RouteNum.inv_log_two_le`<br/>theorem, line 33 | 1 / Real.log 2 ≤ 1.4428 | — | — | — | `RouteNum.C2n_le`, `RouteNum.Cen_le`, `RouteNum.Cpn_le`, `RouteNum.Csn_le`, `RouteNum.Dln_le` |
| `RouteNum.C1n_le`<br/>theorem, line 38 | EdgeBound.C1n ≤ 1909224 | — | — | `BoxBounds.zeta_ratio_ge`, `EdgeBound.C1n` | `RouteNum.Cen_le` |
| `RouteNum.C2n_le`<br/>theorem, line 95 | EdgeBound.C2n ≤ 2167 | — | — | `ContourShift.zeta_zeros_rectangle_finite`, `EdgeBound.C2n`, `EdgeBound.low_rect_count`, `RouteNum.inv_log_two_le` | `RouteNum.Cen_le` |
| `RouteNum.Cen_le`<br/>theorem, line 115 | EdgeBound.Cen ≤ 1911393 | — | — | `EdgeBound.Cen`, `RouteNum.C1n_le`, `RouteNum.C2n_le`, `RouteNum.inv_log_two_le` | `RouteNum.Cpn_le`, `RouteNum.Dln_le` |
| `RouteNum.Cpn_le`<br/>theorem, line 123 | Glue.Cpn ≤ 6534550000 | — | — | `EdgeBound.Cen`, `EdgeBound.Cen_pos`, `Glue.Cpn`, `RouteNum.Cen_le`, `RouteNum.inv_log_two_le` | `RouteNum.Chn_le` |
| `RouteNum.Chn_le`<br/>theorem, line 139 | Glue.Chn ≤ 44108300000 | — | — | `Glue.Chn`, `RouteNum.Cpn_le` | `RouteNum.c1n_le` |
| `RouteNum.Csn_le`<br/>theorem, line 144 | Glue.Csn ≤ 1136 | — | — | `Glue.Csn`, `RouteNum.inv_log_two_le` | `RouteNum.c1n_le` |
| `RouteNum.Dln_le`<br/>theorem, line 153 | Glue.Dln ≤ 89846200 | — | — | `Glue.Dln`, `RouteNum.Cen_le`, `RouteNum.inv_log_two_le` | `RouteNum.c4n_le` |
| `RouteNum.c1n_le`<br/>theorem, line 163 | Glue.c1n ≤ 88216610000 | — | — | `Glue.c1n`, `RouteNum.Chn_le`, `RouteNum.Csn_le` | `GateEval.routeConst_le` |
| `RouteNum.c3n_le`<br/>theorem, line 169 | Glue.c3n ≤ 15 | — | — | `Glue.c3n`, `Stage3.norm_logDerivZeta_zero` | `GateEval.routeConst_le` |
| `RouteNum.c4n_le`<br/>theorem, line 180 | Glue.c4n ≤ 6468930000 | — | — | `Glue.c4n`, `RouteNum.Dln_le` | `GateEval.routeConst_le` |
| `Stage3.stmtEF_split_num`<br/>theorem, line 197 | StmtExplicitFormulaSplit Glue.c1n Glue.c3n Glue.c4n 16 | — | The explicit formula with its constants named. | `Stage3.StmtExplicitFormulaSplit`, `Glue.c1n`, `Glue.c3n`, `Glue.c4n`, `Glue.explicit_formula_split_num` | `Stage3.schoenfeldWeak_route_num` |
| `Stage3.routeConst`<br/>def, line 201 | ℝ | x₀ : ℝ | The route's constant on the `π` side, at floor `x₀`. | `Stage3.floorConstSplit`, `Glue.c1n`, `Glue.c3n`, `Glue.c4n` | `GateEval.gate_hyp_of_RH`, `GateEval.routeConst_le`, `RouteNum.relErrWindow_route_num`, `Stage3.schoenfeldWeak_route_num`, `TableDepths.cell_ne_zero_gen` |
| `Stage3.schoenfeldWeak_route_num`<br/>theorem, line 205 | StmtSchoenfeldWeak (routeConst x₀) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hRH : RiemannHypothesis; hx₀ : 16 ≤ x₀ | From RH to the `π` side, every constant named. | `ArgCount.rvM_crude`, `Stage3.floorConstSplit_nonneg`, `Stage3.psiWeak_floor_split`, `Glue.c1n_nonneg`, `Glue.c3n_nonneg`, `Glue.c4n_nonneg`, `Stage3.Li`, `Stage3.schoenfeldWeak_of_psiWeak`, `Stage3.routeConst`, `Stage3.stmtEF_split_num`, `Stage3.StmtSchoenfeldWeak` | `RouteNum.relErrWindow_route_num` |
| `RouteNum.relErrWindow_route_num`<br/>theorem, line 230 | JointDialGate.StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; 2 / Real.log 2 + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n (Stage3.routeConst x₀ * (Real.log 2 * r) ^ 1 * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) | hRH : RiemannHypothesis; hx₀ : 16 ≤ x₀; r : ℤ; n : ℕ; hbot : x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n) | The route at the gate, every constant named. | `Stage3.floorConstSplit_nonneg`, `Glue.c1n_nonneg`, `Glue.c3n_nonneg`, `Glue.c4n_nonneg`, `JointDialGate.StmtRelErrWindow`, `JointFloorGate.weakWindow_relErr`, `Stage3.Li`, `Stage3.routeConst`, `Stage3.schoenfeldWeak_route_num`, `Stage3.Li_two_rpow`, `Stage3.weakWindow_of_global` | `GateEval.gate_hyp_of_RH`, `TableDepths.cell_ne_zero_gen` |
