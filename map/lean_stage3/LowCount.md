# `lean_stage3/Stage3/LowCount.lean`

**What it does** (its own header): LowCount — block E7c of `lean_stage3/design/joints.md`. 2026-11-22. The zeros of ζ below height six, counted. `EdgeBound.ball_order_sum_le` takes their number `M0` as a finite sum with no numeral; here it is bounded by Jensen's count (upstream `ZerosBound`) on six discs about `3/2 + i(j + 1/2)`, `j = 0, …, 5`, each of radius `8/5`, with the pole cleared (`gz`).

**Imports:** [`BoxBounds`](../lean_stage3/BoxBounds.md), [`EdgeBound`](../lean_stage3/EdgeBound.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LowEdge`](../lean_stage3/LowEdge.md).

```mermaid
flowchart LR
  n0["gz_c0_lower<br/>⊢ 1 / 14 ≤ ‖gz (c0 T')‖"]:::thm
  n1["low_ball_count<br/>⊢ (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFin…"]:::thm
  n2["low_rect_count<br/>⊢ (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ) ((1 : ℝ) + Co…"]:::thm
  x0(["BoxBounds · norm_le_of_sq"]):::ext
  x1(["BoxBounds · sq_zeta_band_explicit"]):::ext
  x2(["BoxBounds · zeta_ratio_ge"]):::ext
  x3(["ContourShift · zeta_zeros_rectangle_finite"]):::ext
  x4(["EdgeBound · c0"]):::ext
  x5(["EdgeBound · c0_im"]):::ext
  x6(["EdgeBound · c0_re"]):::ext
  x7(["EdgeBound · gz"]):::ext
  x8(["EdgeBound · gz_analytic"]):::ext
  x9(["EdgeBound · gz_order_eq"]):::ext
  x10(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x11(["JensenCount · analyticOrderNatAt_fun_comp_affine"]):::ext
  x12(["LowEdge · gz_partial_fraction_low"]):::ext
  x13(["LowEdge · low_ball_count_wide"]):::ext
  x14(["RouteNum · C2n_le"]):::ext
  n0 --> n1
  n0 --> x12
  n0 --> x13
  n1 --> n2
  n2 --> x14
  x0 --> n2
  x1 --> n1
  x10 --> n1
  x10 --> n2
  x11 --> n1
  x2 --> n0
  x3 --> n2
  x4 --> n0
  x4 --> n1
  x4 --> n2
  x5 --> n1
  x5 --> n2
  x6 --> n0
  x6 --> n1
  x6 --> n2
  x7 --> n0
  x7 --> n1
  x7 --> n2
  x8 --> n1
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
| `EdgeBound.gz_c0_lower`<br/>theorem, line 29 | 1 / 14 ≤ ‖gz (c0 T')‖ | T' : ℝ | The centre is bounded below at every height. | `BoxBounds.zeta_ratio_ge`, `EdgeBound.c0`, `EdgeBound.c0_re`, `EdgeBound.gz` | `EdgeBound.low_ball_count`, `EdgeBound.gz_partial_fraction_low`, `EdgeBound.low_ball_count_wide` |
| `EdgeBound.low_ball_count`<br/>theorem, line 51 | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 8 / 5)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 119 | h0 : 0 ≤ T'; h6 : T' ≤ 6 | Jensen's count at a low height. | `BoxBounds.sq_zeta_band_explicit`, `EdgeBound.c0`, `EdgeBound.c0_im`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_analytic`, `EdgeBound.gz_zeros_ball_finite`, `Stage3.analyticOrderNatAt_fun_comp_affine`, `EdgeBound.gz_c0_lower` | `EdgeBound.low_rect_count` |
| `EdgeBound.low_rect_count`<br/>theorem, line 189 | (∑ ρ ∈ (ContourShift.zeta_zeros_rectangle_finite (0 : ℂ) ((1 : ℝ) + Complex.I * (6 : ℝ))).toFinset, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ 714 | — | `M0`, bounded by a numeral. | `BoxBounds.norm_le_of_sq`, `ContourShift.zeta_zeros_rectangle_finite`, `EdgeBound.c0`, `EdgeBound.c0_im`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_order_eq`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.low_ball_count` | `RouteNum.C2n_le` |
