# `lean_stage3/Stage3/LowEdge.lean`

**What it does** (its own header): LowEdge — block E7d of `lean_stage3/design/joints.md`. 2026-11-22. The logarithmic derivative of ζ on the short segment `Re s = −1/4`, `|t| ≤ 2`, bounded by a numeral. `Glue.edge_left_bound` takes that supremum `Mc` from compactness. `EdgeBound.gz_partial_fraction` gives the bound at heights `≥ 2` because its right side is `C·log T′`; at heights in `[0, 2]` the same proof, with `BoxBounds.sq_zeta_band_explicit` above and `gz_c0_lower` below, gives a constant.

**Imports:** [`LowCount`](../lean_stage3/LowCount.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`EdgeNum`](../lean_stage3/EdgeNum.md).

```mermaid
flowchart LR
  n0["low_ball_count_wide<br/>⊢ (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toF…"]:::thm
  n1["gz_partial_fraction_low<br/>⊢ ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:…"]:::thm
  n2["logDerivZeta_low_edge<br/>⊢ ‖deriv riemannZeta u / riemannZeta u‖ ≤ 1620000"]:::thm
  n3["logDerivZeta_short_segment<br/>⊢ ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) / riemannZeta (((-…"]:::thm
  x0(["BoxBounds · sq_zeta_band_explicit"]):::ext
  x1(["ContourShift · zeta_ne_zero_of_re_mem"]):::ext
  x2(["EdgeBound · c0"]):::ext
  x3(["EdgeBound · c0_im"]):::ext
  x4(["EdgeBound · c0_re"]):::ext
  x5(["EdgeBound · deriv_zeta_conj"]):::ext
  x6(["EdgeBound · gz"]):::ext
  x7(["EdgeBound · gz_analytic"]):::ext
  x8(["EdgeBound · gz_logderiv"]):::ext
  x9(["EdgeBound · gz_zero_cases"]):::ext
  x10(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x11(["GlueNum · edge_left_sharp_num"]):::ext
  x12(["JensenCount · analyticOrderNatAt_fun_comp_affine"]):::ext
  x13(["LowCount · gz_c0_lower"]):::ext
  n0 --> n2
  n1 --> n2
  n2 --> n3
  n3 --> x11
  x0 --> n0
  x0 --> n1
  x1 --> n2
  x10 --> n0
  x10 --> n1
  x10 --> n2
  x12 --> n0
  x12 --> n1
  x13 --> n0
  x13 --> n1
  x2 --> n0
  x2 --> n1
  x2 --> n2
  x3 --> n0
  x3 --> n1
  x4 --> n0
  x4 --> n1
  x4 --> n2
  x5 --> n3
  x6 --> n0
  x6 --> n1
  x6 --> n2
  x7 --> n0
  x7 --> n1
  x8 --> n2
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
| `EdgeBound.low_ball_count_wide`<br/>theorem, line 35 | (∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0 : ℝ) ≤ 46 / 25)).toFinset, (analyticOrderNatAt gz w : ℝ)) ≤ 250 | h0 : 0 ≤ T'; h6 : T' ≤ 2 | Jensen's count at a low height, on the partial fraction's ball. | `BoxBounds.sq_zeta_band_explicit`, `EdgeBound.c0`, `EdgeBound.c0_im`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_analytic`, `EdgeBound.gz_zeros_ball_finite`, `Stage3.analyticOrderNatAt_fun_comp_affine`, `EdgeBound.gz_c0_lower` | `EdgeBound.logDerivZeta_low_edge` |
| `EdgeBound.gz_partial_fraction_low`<br/>theorem, line 173 | ‖deriv gz u / gz u - ∑ w ∈ (gz_zeros_ball_finite T' (by norm_num : (0:ℝ) ≤ 46/25)).toFinset, (analyticOrderNatAt gz w : ℂ) / (u - w)‖ ≤ 1617537 | h0T : 0 ≤ T'; h2T : T' ≤ 2; u : ℂ; him : u.im = T'; hre1 : -1/4 ≤ u.re; hre2 : u.re ≤ 2; hune : gz u ≠ 0 | The partial fraction at a low height, with a numeral. | `BoxBounds.sq_zeta_band_explicit`, `EdgeBound.c0`, `EdgeBound.c0_im`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_analytic`, `EdgeBound.gz_zeros_ball_finite`, `Stage3.analyticOrderNatAt_fun_comp_affine`, `EdgeBound.gz_c0_lower` | `EdgeBound.logDerivZeta_low_edge` |
| `EdgeBound.logDerivZeta_low_edge`<br/>theorem, line 382 | ‖deriv riemannZeta u / riemannZeta u‖ ≤ 1620000 | h0 : 0 ≤ t; h2 : t ≤ 2; hre : u.re = -1/4; him : u.im = t | The short segment, upper half. | `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.c0`, `EdgeBound.c0_re`, `EdgeBound.gz`, `EdgeBound.gz_logderiv`, `EdgeBound.gz_zero_cases`, `EdgeBound.gz_zeros_ball_finite`, `EdgeBound.gz_partial_fraction_low`, `EdgeBound.low_ball_count_wide` | `EdgeBound.logDerivZeta_short_segment` |
| `EdgeBound.logDerivZeta_short_segment`<br/>theorem, line 459 | ‖deriv riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I) / riemannZeta (((-1/4 : ℝ):ℂ) + t * Complex.I)‖ ≤ 1620000 | ht : \|t\| ≤ 2 | `Mc`, bounded by a numeral: the short segment, both signs. | `EdgeBound.deriv_zeta_conj`, `EdgeBound.logDerivZeta_low_edge` | `Glue.edge_left_sharp_num` |
