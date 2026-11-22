# `lean_stage3/Stage3/EdgeNum.lean`

**What it does** (its own header): EdgeNum — block E8a of `lean_stage3/design/joints.md`. 2026-11-22. `EdgeBound`'s three edge theorems with their constants as definitions. Each proof is the original with its existence step replaced: the band bound is `BoxBounds.sq_zeta_band_explicit` in place of `sq_zeta_band_bound`, and each `refine ⟨<expression>, _, ?_⟩` is the definition unfolding to that expression (`LOOP.md` § 3). `EdgeBound.lean` is untouched.

**Imports:** [`LowEdge`](../lean_stage3/LowEdge.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`GlueNum`](../lean_stage3/GlueNum.md).

```mermaid
flowchart LR
  n0["C1n<br/>(def)"]:::dfn
  n1["C1n_pos<br/>⊢ 0 ＜ C1n"]:::thm
  n2["gz_partial_fraction_num<br/>⊢ ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u …"]:::thm
  n3["C2n<br/>(def)"]:::dfn
  n4["C2n_pos<br/>⊢ 0 ＜ C2n"]:::thm
  n5["ball_order_sum_le_num<br/>⊢ ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ…"]:::thm
  n6["Cen<br/>(def)"]:::dfn
  n7["Cen_pos<br/>⊢ 0 ＜ Cen"]:::thm
  n8["edge_bound_core_num<br/>⊢ ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZ…"]:::thm
  x0(["BoxBounds · sq_zeta_band_explicit"]):::ext
  x1(["ContourShift · mem_zetaWindow"]):::ext
  x2(["ContourShift · zeta_order_reflect"]):::ext
  x3(["ContourShift · zeta_zeros_rectangle_finite"]):::ext
  x4(["EdgeBound · ball_zero_shape"]):::ext
  x5(["EdgeBound · c0"]):::ext
  x6(["EdgeBound · c0_im"]):::ext
  x7(["EdgeBound · c0_re"]):::ext
  x8(["EdgeBound · gz"]):::ext
  x9(["EdgeBound · gz_analytic"]):::ext
  x10(["EdgeBound · gz_c0_ne"]):::ext
  x11(["EdgeBound · gz_logderiv"]):::ext
  x12(["EdgeBound · gz_lower"]):::ext
  x13(["EdgeBound · gz_order_eq"]):::ext
  x14(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x15(["EdgeBound · zeta_ratio_pos"]):::ext
  x16(["GlueNum · Cpn"]):::ext
  x17(["GlueNum · Cpn_pos"]):::ext
  x18(["GlueNum · Dln"]):::ext
  x19(["GlueNum · Dln_pos"]):::ext
  x20(["GlueNum · edge_left_sharp_num"]):::ext
  x21(["GlueNum · zeta_logderiv_good_bound_num"]):::ext
  x22(["JensenCount · analyticOrderNatAt_fun_comp_affine"]):::ext
  x23(["JensenCount · zetaWindow_finite"]):::ext
  x24(["JensenCount · zeta_local_zero_count"]):::ext
  x25(["RouteNum · C1n_le"]):::ext
  x26(["RouteNum · C2n_le"]):::ext
  x27(["RouteNum · Cen_le"]):::ext
  x28(["RouteNum · Cpn_le"]):::ext
  n0 --> n1
  n0 --> n2
  n0 --> n6
  n0 --> n8
  n0 --> x25
  n1 --> n7
  n1 --> n8
  n2 --> n8
  n3 --> n4
  n3 --> n5
  n3 --> n6
  n3 --> n8
  n3 --> x26
  n4 --> n7
  n4 --> n8
  n5 --> n8
  n6 --> n7
  n6 --> n8
  n6 --> x16
  n6 --> x18
  n6 --> x20
  n6 --> x21
  n6 --> x27
  n6 --> x28
  n7 --> x17
  n7 --> x19
  n7 --> x20
  n7 --> x21
  n7 --> x28
  n8 --> x20
  n8 --> x21
  x0 --> n2
  x1 --> n5
  x10 --> n2
  x11 --> n8
  x12 --> n2
  x13 --> n5
  x14 --> n2
  x14 --> n5
  x14 --> n8
  x15 --> n1
  x15 --> n2
  x2 --> n5
  x22 --> n2
  x23 --> n5
  x24 --> n5
  x3 --> n3
  x3 --> n4
  x3 --> n5
  x4 --> n5
  x5 --> n2
  x5 --> n5
  x6 --> n2
  x7 --> n2
  x8 --> n2
  x8 --> n5
  x8 --> n8
  x9 --> n2
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
| `EdgeBound.C1n`<br/>def, line 30 | ℝ | — | The partial fraction's constant. | — | `EdgeBound.C1n_pos`, `EdgeBound.Cen`, `EdgeBound.edge_bound_core_num`, `EdgeBound.gz_partial_fraction_num`, `RouteNum.C1n_le` |
| `EdgeBound.C1n_pos`<br/>theorem, line 35 | 0 &lt; C1n | — | — | `EdgeBound.zeta_ratio_pos`, `EdgeBound.C1n` | `EdgeBound.Cen_pos`, `EdgeBound.edge_bound_core_num` |
| `EdgeBound.gz_partial_fraction_num`<br/>theorem, line 54 | ∀ T' : ℝ, 2 ≤ T' → ∀ u : ℂ, u.im = T' → -1/4 ≤ u.re → u.re ≤ 2 → gz u ≠ 0 → ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ ≤ C1n * Real.log T' | — | The rescaled Landau partial fraction. At any height `T′ ≥ 2` and any `u` on the segment `re ∈ [−1/4, 2]` at that height that is not a `gz`-zero, the log-derivative of `gz` minus the simple-pole sum over `gz`-zeros within `46/25` of the center is `≤ C·log T′`. Transported from PNT+'s normalized `FinalBound` with radii `22/25 &lt; 23/25 &lt; 19/20 &lt; 49/50`. | `BoxBounds.sq_zeta_band_explicit`, `EdgeBound.c0`, `EdgeBound.c0_im`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_analytic`, `EdgeBound.gz_c0_ne`, `EdgeBound.gz_lower`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.zeta_ratio_pos`, `EdgeBound.C1n`, `Stage3.analyticOrderNatAt_fun_comp_affine` | `EdgeBound.edge_bound_core_num` |
| `EdgeBound.C2n`<br/>def, line 300 | ℝ | — | The ball count's constant. | `ContourShift.zeta_zeros_rectangle_finite` | `EdgeBound.C2n_pos`, `EdgeBound.Cen`, `EdgeBound.ball_order_sum_le_num`, `EdgeBound.edge_bound_core_num`, `RouteNum.C2n_le` |
| `EdgeBound.C2n_pos`<br/>theorem, line 305 | 0 &lt; C2n | — | — | `ContourShift.zeta_zeros_rectangle_finite`, `EdgeBound.C2n` | `EdgeBound.Cen_pos`, `EdgeBound.edge_bound_core_num` |
| `EdgeBound.ball_order_sum_le_num`<br/>theorem, line 317 | ∀ T' : ℝ, 2 ≤ T' → (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ C2n * Real.log T' | — | The ball order-count: the total multiplicity of `gz`-zeros in the `46/25`-ball at height `T′` is `≤ C·log T′` — four Jensen windows for `T′ ≥ 4` with the reflection charging left-zeros to partners, and a fixed-rectangle constant for `T′ &lt; 4`. | `ContourShift.mem_zetaWindow`, `ContourShift.zeta_order_reflect`, `ContourShift.zeta_zeros_rectangle_finite`, `EdgeBound.ball_zero_shape`, `EdgeBound.c0`, `EdgeBound.gz`, `EdgeBound.gz_order_eq`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.C2n`, `Stage3.zetaWindow_finite`, `Stage3.zeta_local_zero_count` | `EdgeBound.edge_bound_core_num` |
| `EdgeBound.Cen`<br/>def, line 583 | ℝ | — | The edge constant. | `EdgeBound.C1n`, `EdgeBound.C2n` | `EdgeBound.Cen_pos`, `EdgeBound.edge_bound_core_num`, `Glue.Cpn`, `Glue.Dln`, `Glue.edge_left_sharp_num`, `Glue.zeta_logderiv_good_bound_num`, `RouteNum.Cen_le`, `RouteNum.Cpn_le` |
| `EdgeBound.Cen_pos`<br/>theorem, line 585 | 0 &lt; Cen | — | — | `EdgeBound.C1n_pos`, `EdgeBound.C2n_pos`, `EdgeBound.Cen` | `Glue.Cpn_pos`, `Glue.Dln_pos`, `Glue.edge_left_sharp_num`, `Glue.zeta_logderiv_good_bound_num`, `RouteNum.Cpn_le` |
| `EdgeBound.edge_bound_core_num`<br/>theorem, line 597 | ∀ t : ℝ, 2 ≤ t → ∀ u : ℂ, u.im = t → -1/4 ≤ u.re → u.re ≤ 2 → riemannZeta u ≠ 0 → ∀ δ : ℝ, 0 &lt; δ → δ ≤ 1 → (∀ w ∈ (gz_zeros_ball_finite t (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, δ ≤ ‖u - w‖) → ‖deriv riemannZeta u / riemannZeta u‖ ≤ Cen * Real.log t / δ | — | The pointwise edge bound, unified. For `u` on the band `re ∈ [−1/4, 2]` at height `t ≥ 2`, with a lower bound `δ ≤ 1` on the distance from `u` to every ball zero: `‖ζ′/ζ(u)‖ ≤ C·(log t)/δ + C·log t`. Both edges specialize this: the left edge with `δ = 1/4`, the good horizontals with `δ = zeroGap T`. | `EdgeBound.gz`, `EdgeBound.gz_logderiv`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.C1n`, `EdgeBound.C1n_pos`, `EdgeBound.C2n`, `EdgeBound.C2n_pos`, `EdgeBound.Cen`, `EdgeBound.ball_order_sum_le_num`, `EdgeBound.gz_partial_fraction_num` | `Glue.edge_left_sharp_num`, `Glue.zeta_logderiv_good_bound_num` |
