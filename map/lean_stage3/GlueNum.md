# `lean_stage3/Stage3/GlueNum.lean`

**What it does** (its own header): GlueNum — block E8b of `lean_stage3/design/joints.md`. 2026-11-22. `Glue`'s theorems under the truncated explicit formula, and the formula itself, with their constants as definitions. Each proof is the original with its existence step replaced (`LOOP.md` § 3); the left edge takes `EdgeBound.logDerivZeta_short_segment` where the original called compactness. `Glue.lean` and `GlueFloor.lean` are untouched.

**Imports:** [`EdgeNum`](../lean_stage3/EdgeNum.md), [`GlueFloor`](../lean_stage3/GlueFloor.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`CellZeros`](../lean_stage3/CellZeros.md), [`RouteNum`](../lean_stage3/RouteNum.md).

```mermaid
flowchart LR
  n0["Csn<br/>(def)"]:::dfn
  n1["Csn_pos<br/>⊢ 0 ＜ Csn"]:::thm
  n2["Cpn<br/>(def)"]:::dfn
  n3["Cpn_pos<br/>⊢ 0 ＜ Cpn"]:::thm
  n4["Chn<br/>(def)"]:::dfn
  n5["Chn_pos<br/>⊢ 0 ＜ Chn"]:::thm
  n6["Dln<br/>(def)"]:::dfn
  n7["Dln_pos<br/>⊢ 0 ＜ Dln"]:::thm
  n8["c1n<br/>(def)"]:::dfn
  n9["c3n<br/>(def)"]:::dfn
  n10["c4n<br/>(def)"]:::dfn
  n11["c1n_nonneg<br/>⊢ 0 ≤ c1n"]:::thm
  n12["c3n_nonneg<br/>⊢ 0 ≤ c3n"]:::thm
  n13["c4n_nonneg<br/>⊢ 0 ≤ c4n"]:::thm
  n14["band_order_sum_le_num<br/>⊢ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 ＜ ρ.…"]:::thm
  n15["zeroPartialSum_swap_num<br/>⊢ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroParti…"]:::thm
  n16["zeta_logderiv_good_bound_num<br/>⊢ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0…"]:::thm
  n17["edge_horizontal_bound_num<br/>⊢ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, rieman…"]:::thm
  n18["edge_left_sharp_num<br/>⊢ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-…"]:::thm
  n19["explicit_formula_split_num<br/>⊢ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) +…"]:::thm
  x0(["Assembly · zeroPartialSum"]):::ext
  x1(["CellModes · cell_eq_modeSum"]):::ext
  x2(["CellZeros · cell_eq_zero_sum"]):::ext
  x3(["ContourShift · goodT_exists"]):::ext
  x4(["ContourShift · mem_zetaWindow"]):::ext
  x5(["ContourShift · residue_identity"]):::ext
  x6(["ContourShift · zeroGap"]):::ext
  x7(["ContourShift · zeroGap_le"]):::ext
  x8(["ContourShift · zeroGap_pos"]):::ext
  x9(["ContourShift · zeroPartialSum_eq_sum"]):::ext
  x10(["ContourShift · zeta_analyticAt"]):::ext
  x11(["ContourShift · zeta_ne_zero_of_re_mem"]):::ext
  x12(["ContourShift · zeta_order_conj"]):::ext
  x13(["ContourShift · zeta_order_reflect"]):::ext
  x14(["ContourShift · zeta_zeros_rectangle_finite"]):::ext
  x15(["EdgeBound · ball_zero_shape"]):::ext
  x16(["EdgeBound · deriv_zeta_conj"]):::ext
  x17(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x18(["EdgeNum · Cen"]):::ext
  x19(["EdgeNum · Cen_pos"]):::ext
  x20(["EdgeNum · edge_bound_core_num"]):::ext
  x21(["Glue · Gf"]):::ext
  x22(["JensenCount · zetaWindow_finite"]):::ext
  x23(["JensenCount · zeta_local_zero_count"]):::ext
  x24(["LowEdge · logDerivZeta_short_segment"]):::ext
  x25(["PerronKernel · explicit_formula_perron"]):::ext
  x26(["RouteNum · Chn_le"]):::ext
  x27(["RouteNum · Cpn_le"]):::ext
  x28(["RouteNum · Csn_le"]):::ext
  x29(["RouteNum · Dln_le"]):::ext
  x30(["RouteNum · c1n_le"]):::ext
  x31(["RouteNum · c3n_le"]):::ext
  x32(["RouteNum · c4n_le"]):::ext
  x33(["RouteNum · relErrWindow_route_num"]):::ext
  x34(["RouteNum · routeConst"]):::ext
  x35(["RouteNum · schoenfeldWeak_route_num"]):::ext
  x36(["RouteNum · stmtEF_split_num"]):::ext
  n0 --> n1
  n0 --> n14
  n0 --> n15
  n0 --> n19
  n0 --> n8
  n0 --> x28
  n1 --> n11
  n1 --> n15
  n1 --> n19
  n10 --> n13
  n10 --> n19
  n10 --> x1
  n10 --> x2
  n10 --> x32
  n10 --> x34
  n10 --> x36
  n11 --> x33
  n11 --> x35
  n12 --> x33
  n12 --> x35
  n13 --> x33
  n13 --> x35
  n14 --> n15
  n15 --> n19
  n16 --> n17
  n17 --> n19
  n18 --> n19
  n19 --> x2
  n19 --> x36
  n2 --> n16
  n2 --> n17
  n2 --> n3
  n2 --> n4
  n2 --> x27
  n3 --> n17
  n3 --> n5
  n4 --> n17
  n4 --> n19
  n4 --> n5
  n4 --> n8
  n4 --> x26
  n5 --> n11
  n5 --> n19
  n6 --> n10
  n6 --> n18
  n6 --> n19
  n6 --> n7
  n6 --> x29
  n7 --> n13
  n7 --> n19
  n8 --> n11
  n8 --> n19
  n8 --> x1
  n8 --> x2
  n8 --> x30
  n8 --> x34
  n8 --> x36
  n9 --> n12
  n9 --> n19
  n9 --> x1
  n9 --> x2
  n9 --> x31
  n9 --> x34
  n9 --> x36
  x0 --> n15
  x0 --> n19
  x10 --> n18
  x11 --> n15
  x11 --> n16
  x11 --> n18
  x12 --> n14
  x13 --> n14
  x14 --> n15
  x15 --> n16
  x15 --> n18
  x16 --> n16
  x16 --> n18
  x17 --> n16
  x17 --> n18
  x18 --> n16
  x18 --> n18
  x18 --> n2
  x18 --> n6
  x19 --> n16
  x19 --> n18
  x19 --> n3
  x19 --> n7
  x20 --> n16
  x20 --> n18
  x21 --> n17
  x21 --> n18
  x21 --> n19
  x22 --> n14
  x23 --> n14
  x24 --> n18
  x25 --> n19
  x3 --> n19
  x4 --> n14
  x5 --> n19
  x6 --> n16
  x6 --> n17
  x7 --> n16
  x8 --> n16
  x9 --> n15
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
| `Glue.Csn`<br/>def, line 34 | ℝ | — | The band count's constant. | — | `Glue.Csn_pos`, `Glue.band_order_sum_le_num`, `Glue.c1n`, `Glue.explicit_formula_split_num`, `Glue.zeroPartialSum_swap_num`, `RouteNum.Csn_le` |
| `Glue.Csn_pos`<br/>theorem, line 36 | 0 &lt; Csn | — | — | `Glue.Csn` | `Glue.c1n_nonneg`, `Glue.explicit_formula_split_num`, `Glue.zeroPartialSum_swap_num` |
| `Glue.Cpn`<br/>def, line 42 | ℝ | — | The good-height constant. | `EdgeBound.Cen` | `Glue.Chn`, `Glue.Cpn_pos`, `Glue.edge_horizontal_bound_num`, `Glue.zeta_logderiv_good_bound_num`, `RouteNum.Cpn_le` |
| `Glue.Cpn_pos`<br/>theorem, line 44 | 0 &lt; Cpn | — | — | `EdgeBound.Cen_pos`, `Glue.Cpn` | `Glue.Chn_pos`, `Glue.edge_horizontal_bound_num` |
| `Glue.Chn`<br/>def, line 51 | ℝ | — | The horizontal-edge constant. | `Glue.Cpn` | `Glue.Chn_pos`, `Glue.c1n`, `Glue.edge_horizontal_bound_num`, `Glue.explicit_formula_split_num`, `RouteNum.Chn_le` |
| `Glue.Chn_pos`<br/>theorem, line 53 | 0 &lt; Chn | — | — | `Glue.Chn`, `Glue.Cpn_pos` | `Glue.c1n_nonneg`, `Glue.explicit_formula_split_num` |
| `Glue.Dln`<br/>def, line 59 | ℝ | — | The left-edge constant. | `EdgeBound.Cen` | `Glue.Dln_pos`, `Glue.c4n`, `Glue.edge_left_sharp_num`, `Glue.explicit_formula_split_num`, `RouteNum.Dln_le` |
| `Glue.Dln_pos`<br/>theorem, line 61 | 0 &lt; Dln | — | — | `EdgeBound.Cen_pos`, `Glue.Dln` | `Glue.c4n_nonneg`, `Glue.explicit_formula_split_num` |
| `Glue.c1n`<br/>def, line 68 | ℝ | — | The explicit formula's three constants. | `Glue.Chn`, `Glue.Csn` | `CellModes.cell_eq_modeSum`, `CellZeros.cell_eq_zero_sum`, `Glue.c1n_nonneg`, `Glue.explicit_formula_split_num`, `RouteNum.c1n_le`, `Stage3.routeConst`, `Stage3.stmtEF_split_num` |
| `Glue.c3n`<br/>def, line 69 | ℝ | — | — | — | `CellModes.cell_eq_modeSum`, `CellZeros.cell_eq_zero_sum`, `Glue.c3n_nonneg`, `Glue.explicit_formula_split_num`, `RouteNum.c3n_le`, `Stage3.routeConst`, `Stage3.stmtEF_split_num` |
| `Glue.c4n`<br/>def, line 70 | ℝ | — | — | `Glue.Dln` | `CellModes.cell_eq_modeSum`, `CellZeros.cell_eq_zero_sum`, `Glue.c4n_nonneg`, `Glue.explicit_formula_split_num`, `RouteNum.c4n_le`, `Stage3.routeConst`, `Stage3.stmtEF_split_num` |
| `Glue.c1n_nonneg`<br/>theorem, line 72 | 0 ≤ c1n | — | — | `Glue.Chn_pos`, `Glue.Csn_pos`, `Glue.c1n` | `RouteNum.relErrWindow_route_num`, `Stage3.schoenfeldWeak_route_num` |
| `Glue.c3n_nonneg`<br/>theorem, line 78 | 0 ≤ c3n | — | — | `Glue.c3n` | `RouteNum.relErrWindow_route_num`, `Stage3.schoenfeldWeak_route_num` |
| `Glue.c4n_nonneg`<br/>theorem, line 82 | 0 ≤ c4n | — | — | `Glue.Dln_pos`, `Glue.c4n` | `RouteNum.relErrWindow_route_num`, `Stage3.schoenfeldWeak_route_num` |
| `Glue.band_order_sum_le_num`<br/>theorem, line 90 | ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ Csn * Real.log T | — | The band count: any finite set of strip zeros with `\|im\|` in `[T, T+1]` has total multiplicity `≤ C·log T` — two windows per sign, reflection for the left half, conjugation for the negative sign. | `ContourShift.mem_zetaWindow`, `ContourShift.zeta_order_conj`, `ContourShift.zeta_order_reflect`, `Glue.Csn`, `Stage3.zetaWindow_finite`, `Stage3.zeta_local_zero_count` | `Glue.zeroPartialSum_swap_num` |
| `Glue.zeroPartialSum_swap_num`<br/>theorem, line 316 | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ Csn * x * Real.log T / T | — | The swap: moving the zero sum from a height `T′ ∈ [T, T+1]` back to `T` costs `≤ C·x·log T / T`. | `Stage3.zeroPartialSum`, `ContourShift.zeroPartialSum_eq_sum`, `ContourShift.zeta_ne_zero_of_re_mem`, `ContourShift.zeta_zeros_rectangle_finite`, `Glue.Csn`, `Glue.Csn_pos`, `Glue.band_order_sum_le_num` | `Glue.explicit_formula_split_num` |
| `Glue.zeta_logderiv_good_bound_num`<br/>theorem, line 423 | ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riemannZeta u / riemannZeta u‖ ≤ Cpn * Real.log T ^ 2 | — | The pointwise good-height bound, both signs of the height. | `ContourShift.zeroGap`, `ContourShift.zeroGap_le`, `ContourShift.zeroGap_pos`, `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.ball_zero_shape`, `EdgeBound.deriv_zeta_conj`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.Cen`, `EdgeBound.Cen_pos`, `EdgeBound.edge_bound_core_num`, `Glue.Cpn` | `Glue.edge_horizontal_bound_num` |
| `Glue.edge_horizontal_bound_num`<br/>theorem, line 520 | ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 + 1/Real.log x) y‖ ≤ Chn * x * Real.log T ^ 2 / T | — | The horizontal-edge integral bound at a good height, both signs: `≤ C·x·log²T/T`. | `ContourShift.zeroGap`, `Glue.Gf`, `Glue.Chn`, `Glue.Cpn`, `Glue.Cpn_pos`, `Glue.zeta_logderiv_good_bound_num` | `Glue.explicit_formula_split_num` |
| `Glue.edge_left_sharp_num`<br/>theorem, line 621 | ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * Dln * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) | — | The left edge at its own size: `≤ 72·D·log²x·x^(−1/4)` for `T′ ≤ 2x²`. `Glue.edge_left_bound`'s proof, stopped before its last two steps. | `ContourShift.zeta_analyticAt`, `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.ball_zero_shape`, `EdgeBound.deriv_zeta_conj`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.Cen`, `EdgeBound.Cen_pos`, `EdgeBound.edge_bound_core_num`, `Glue.Gf`, `Glue.Dln`, `EdgeBound.logDerivZeta_short_segment` | `Glue.explicit_formula_split_num` |
| `Glue.explicit_formula_split_num`<br/>theorem, line 1004 | ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c1n * x * Real.log (x*T)^2 / T + c3n * Real.log x + c4n * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) | — | THE TRUNCATED EXPLICIT FORMULA — hEF's deliverable, in the `T ≤ x²` regime the consumer uses: constants exist with `‖ψ(x) − x + Σ_{\|γ\|&lt;T} m·x^ρ/ρ‖ ≤ c₁·x·log²(xT)/T + c₂·log x`. | `Stage3.zeroPartialSum`, `ContourShift.goodT_exists`, `ContourShift.residue_identity`, `Glue.Gf`, `Glue.Chn`, `Glue.Chn_pos`, `Glue.Csn`, `Glue.Csn_pos`, `Glue.Dln`, `Glue.Dln_pos`, `Glue.c1n`, `Glue.c3n`, `Glue.c4n`, `Glue.edge_horizontal_bound_num`, `Glue.edge_left_sharp_num`, `Glue.zeroPartialSum_swap_num`, `PerronKernel.explicit_formula_perron` | `CellZeros.cell_eq_zero_sum`, `Stage3.stmtEF_split_num` |
