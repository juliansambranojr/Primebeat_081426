# `lean_stage3/Stage3/BoxBounds.lean`

**What it does** (its own header): BoxBounds — blocks E7a and E7b of `lean_stage3/design/joints.md`. 2026-11-22. Two of the quantities the explicit-formula route took from existence statements, as numerals.

**Imports:** [`ZetaGrowth`](../lean_stage3/ZetaGrowth.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LowCount`](../lean_stage3/LowCount.md).

```mermaid
flowchart LR
  n0["norm_le_of_sq<br/>⊢ ‖z‖ ≤ c"]:::thm
  n1["sq_zeta_box<br/>⊢ ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135"]:::thm
  n2["sq_zeta_band_explicit<br/>⊢ ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + |s.im|) ^ 4"]:::thm
  n3["norm_zeta_three_halves_le<br/>⊢ ‖riemannZeta (3 / 2)‖ ≤ 7 / 2"]:::thm
  n4["one_le_norm_zeta_three<br/>⊢ 1 ≤ ‖riemannZeta 3‖"]:::thm
  n5["zeta_ratio_ge<br/>⊢ 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖"]:::thm
  x0(["EdgeNum · gz_partial_fraction_num"]):::ext
  x1(["LowCount · gz_c0_lower"]):::ext
  x2(["LowCount · low_ball_count"]):::ext
  x3(["LowCount · low_rect_count"]):::ext
  x4(["LowEdge · gz_partial_fraction_low"]):::ext
  x5(["LowEdge · low_ball_count_wide"]):::ext
  x6(["RouteNum · C1n_le"]):::ext
  x7(["ZetaGrowth · emA"]):::ext
  x8(["ZetaGrowth · stripRegion"]):::ext
  x9(["ZetaGrowth · tail_norm_le"]):::ext
  x10(["ZetaGrowth · zeta1"]):::ext
  x11(["ZetaGrowth · zeta1_eq_zeta_strip"]):::ext
  x12(["ZetaGrowth · zeta_growth_strip"]):::ext
  n0 --> n1
  n0 --> n2
  n0 --> x3
  n1 --> n2
  n2 --> x0
  n2 --> x2
  n2 --> x4
  n2 --> x5
  n3 --> n5
  n4 --> n5
  n5 --> x1
  n5 --> x6
  x10 --> n1
  x11 --> n1
  x12 --> n2
  x7 --> n1
  x8 --> n1
  x9 --> n1
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
| `BoxBounds.norm_le_of_sq`<br/>theorem, line 30 | ‖z‖ ≤ c | hc : 0 ≤ c; h : z.re ^ 2 + z.im ^ 2 ≤ c ^ 2 | — | — | `BoxBounds.sq_zeta_band_explicit`, `BoxBounds.sq_zeta_box`, `EdgeBound.low_rect_count` |
| `BoxBounds.sq_zeta_box`<br/>theorem, line 40 | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 | h1 : -1 / 2 ≤ s.re; h2 : s.re ≤ 4; ht : \|s.im\| ≤ 2 | The compact patch, with a numeral. | `BoxBounds.norm_le_of_sq`, `ZetaGrowth.emA`, `ZetaGrowth.stripRegion`, `ZetaGrowth.tail_norm_le`, `ZetaGrowth.zeta1`, `ZetaGrowth.zeta1_eq_zeta_strip` | `BoxBounds.sq_zeta_band_explicit` |
| `BoxBounds.sq_zeta_band_explicit`<br/>theorem, line 90 | ‖(s - 1) ^ 2 * riemannZeta s‖ ≤ 135 * (2 + \|s.im\|) ^ 4 | hσ1 : -1 / 2 ≤ s.re; hσ2 : s.re ≤ 4 | The band bound with its constant named. | `BoxBounds.norm_le_of_sq`, `BoxBounds.sq_zeta_box`, `ZetaGrowth.zeta_growth_strip` | `EdgeBound.gz_partial_fraction_num`, `EdgeBound.low_ball_count`, `EdgeBound.gz_partial_fraction_low`, `EdgeBound.low_ball_count_wide` |
| `BoxBounds.norm_zeta_three_halves_le`<br/>theorem, line 122 | ‖riemannZeta (3 / 2)‖ ≤ 7 / 2 | — | `‖ζ(3/2)‖ ≤ 7/2`, from the strip formula at its first level. | — | `BoxBounds.zeta_ratio_ge` |
| `BoxBounds.one_le_norm_zeta_three`<br/>theorem, line 165 | 1 ≤ ‖riemannZeta 3‖ | — | `1 ≤ ‖ζ 3‖`, from the Dirichlet series. | — | `BoxBounds.zeta_ratio_ge` |
| `BoxBounds.zeta_ratio_ge`<br/>theorem, line 184 | 2 / 7 ≤ ‖riemannZeta 3 / riemannZeta (3 / 2)‖ | — | `cζ`, bounded below by a numeral. | `BoxBounds.norm_zeta_three_halves_le`, `BoxBounds.one_le_norm_zeta_three` | `EdgeBound.gz_c0_lower`, `RouteNum.C1n_le` |
