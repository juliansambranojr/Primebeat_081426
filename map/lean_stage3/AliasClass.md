# `lean_stage3/Stage3/AliasClass.lean`

AliasClass — block J10a of `lean_stage3/design/joints.md`. 2026-11-22. Joint 10 on the table's own ladder, first piece. On the ladder `2^r` a zero `ρ` of ζ enters only through `z = 2^ρ`: its mode at row `r` is `z^r` and its symbol is `1 − z⁻¹`. Zeros with the same `z` have the same real part and heights that differ by a multiple of `2π/log 2`; the ladder folds them together. This module proves that folding never cancels: the zeros sharing a `z` contribute to the cell one mode whose weight is not zero, at every dept…

8 theorems, 0 definitions, 134 lines. Arrows are Lean's own record of what each proof uses.

**Imports:** [`CellModes`](../lean_stage3/CellModes.md)  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`CountEuler`](../lean_stage3/CountEuler.md), [`LadderFading`](../lean_stage3/LadderFading.md), [`ResidueRoute`](../lean_stage3/ResidueRoute.md)

## The picture

```mermaid
flowchart LR
  n0["<b>re_inv_pos</b><br/>0 ＜ (ρ⁻¹).re"]:::shp
  n1["<b>zero_re_pos</b><br/>0 ＜ (ρ : ℂ).re"]:::thm
  n2["<b>re_order_div_pos</b><br/>0 ＜ ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re"]:::thm
  n3["<b>sum_order_div_ne_zero</b><br/>∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0"]:::thm
  n4["<b>sym_eq_of_alias ■</b><br/>Chain.Sym 2 ρ = Chain.Sym 2 ρ'"]:::shp
  n5["<b>mode_eq_of_alias ■</b><br/>Chain.mode 2 ρ (r : ℂ) = Chain.mode 2 ρ' (r : ℂ)"]:::shp
  n6["<b>alias_weight</b><br/>∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Cha…"]:::thm
  n7["<b>alias_weight_ne_zero ■</b><br/>∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Cha…"]:::thm
  x0(["<b>LadderFading</b><br/>line_not_fading"]):::ext
  x1(["<b>LadderMean</b><br/>line_not_fading_summable"]):::ext
  x2(["<b>CountEuler</b><br/>re_ord_div_w_pos"]):::ext
  x3(["<b>FilterAttained</b><br/>filter_attained_false"]):::ext
  x4(["<b>ResidueRoute</b><br/>isolated_boundary_mode_false"]):::ext
  x5(["<b>CellModes</b><br/>mode_two_int<br/>sym_two"]):::ext
  n0 --> n2
  n1 --> n2
  n1 --> n7
  n2 --> n3
  n3 --> n7
  n6 --> n7
  n1 -.-> x0
  n1 -.-> x1
  n2 -.-> x1
  n2 -.-> x2
  n2 -.-> x3
  n2 -.-> x4
  n3 -.-> x0
  n6 -.-> x0
  x5 -.-> n4
  x5 -.-> n5
  x5 -.-> n6
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

## Theorems

<a name="AliasClass-re_inv_pos"></a>
### `AliasClass.re_inv_pos`

line 36

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The reciprocal of a point right of the imaginary axis is right of it too.

**Proves**

```lean
0 < (ρ⁻¹).re
```

**Needs** (its hypotheses)

  - `` h : 0 < ρ.re ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (1 that use it)

  - [`AliasClass.re_order_div_pos`](#AliasClass-re_order_div_pos) — `` 0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re ``

<a name="AliasClass-zero_re_pos"></a>
### `AliasClass.zero_re_pos`

line 42

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** A nontrivial zero of ζ has positive real part.

**Proves**

```lean
0 < (ρ : ℂ).re
```

**Needs** (its hypotheses)

  - `` ρ : Kadiri.NontrivialZeros ``

**Fed by:** no theorem of this repo; it stands on Mathlib.

**Feeds** (4 that use it)

  - [`AliasClass.alias_weight_ne_zero`](#AliasClass-alias_weight_ne_zero) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 ``
  - [`AliasClass.re_order_div_pos`](#AliasClass-re_order_div_pos) — `` 0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re ``
  - [`LadderFading.line_not_fading`](../lean_stage3/LadderFading.md#LadderFading-line_not_fading) (LadderFading) — `` ¬ Tendsto (fun r : ℕ => (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ)) … ``
  - [`LadderMean.line_not_fading_summable`](../lean_stage3/LadderMean.md#LadderMean-line_not_fading_summable) (LadderMean) — `` ¬ Tendsto (fun r : ℕ => (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r … ``

<a name="AliasClass-re_order_div_pos"></a>
### `AliasClass.re_order_div_pos`

line 45

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The coefficient a zero carries in the cell, `m(ρ)/ρ`, has positive real part.

**Proves**

```lean
0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re
```

**Needs** (its hypotheses)

  - `` ρ : Kadiri.NontrivialZeros ``

**Fed by** (2 theorems its proof uses)

  - [`AliasClass.re_inv_pos`](#AliasClass-re_inv_pos) — `` 0 < (ρ⁻¹).re ``
  - [`AliasClass.zero_re_pos`](#AliasClass-zero_re_pos) — `` 0 < (ρ : ℂ).re ``

**Feeds** (5 that use it)

  - [`AliasClass.sum_order_div_ne_zero`](#AliasClass-sum_order_div_ne_zero) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0 ``
  - [`CountEuler.re_ord_div_w_pos`](../lean_stage3/CountEuler.md#CountEuler-re_ord_div_w_pos) (CountEuler) — `` 0 < (ordC ρ * (1 / wz ρ)).re ``
  - [`FilterAttained.filter_attained_false`](../lean_stage3/FilterAttained.md#FilterAttained-filter_attained_false) (FilterAttained) — `` False ``
  - [`LadderMean.line_not_fading_summable`](../lean_stage3/LadderMean.md#LadderMean-line_not_fading_summable) (LadderMean) — `` ¬ Tendsto (fun r : ℕ => (∑' ρ : S, coef ρ * Chain.Sym 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) ^ d * Chain.mode 2 ((ρ : Kadiri.NontrivialZeros) : ℂ) (((r … ``
  - [`ResidueRoute.isolated_boundary_mode_false`](../lean_stage3/ResidueRoute.md#ResidueRoute-isolated_boundary_mode_false) (ResidueRoute) — `` ∃ E : ℝ, σ₀ ≤ E ∧ E < Θ ∧ ∀ σ : ℝ, E ≤ σ → ∀ ρ₁ : Kadiri.NontrivialZeros, σ < (ρ₁ : ℂ).re → (∃ ε : ℝ, 0 < ε ∧ ∀ u ∈ K σ, ‖u - (2:ℂ) ^ (-(ρ₁ : ℂ))‖ < ε… ``

<a name="AliasClass-sum_order_div_ne_zero"></a>
### `AliasClass.sum_order_div_ne_zero`

line 59

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** No set of zeros cancels. The coefficients `m(ρ)/ρ` of a nonempty finite set of zeros never add to zero: each has positive real part.

**Proves**

```lean
∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0
```

**Needs** (its hypotheses)

  - `` S : Finset Kadiri.NontrivialZeros ``
  - `` hS : S.Nonempty ``

**Fed by** (1 theorem its proof uses)

  - [`AliasClass.re_order_div_pos`](#AliasClass-re_order_div_pos) — `` 0 < ((((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)).re ``

**Feeds** (2 that use it)

  - [`AliasClass.alias_weight_ne_zero`](#AliasClass-alias_weight_ne_zero) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 ``
  - [`LadderFading.line_not_fading`](../lean_stage3/LadderFading.md#LadderFading-line_not_fading) (LadderFading) — `` ¬ Tendsto (fun r : ℕ => (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ)) … ``

<a name="AliasClass-sym_eq_of_alias"></a>
### `AliasClass.sym_eq_of_alias`

line 69

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Zeros the ladder folds together have the same symbol.

**Proves**

```lean
Chain.Sym 2 ρ = Chain.Sym 2 ρ'
```

**Needs** (its hypotheses)

  - `` h : (2 : ℂ) ^ ρ = (2 : ℂ) ^ ρ' ``

**Stated with:** [`Chain.Sym`](../lean/Chain.md#Chain-Sym)

**Fed by** (1 theorem its proof uses)

  - [`CellModes.sym_two`](../lean_stage3/CellModes.md#CellModes-sym_two) (CellModes) — `` Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ ``

**Feeds:** nothing. It is an end.

<a name="AliasClass-mode_eq_of_alias"></a>
### `AliasClass.mode_eq_of_alias`

line 74

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** Zeros the ladder folds together have the same mode at every row.

**Proves**

```lean
Chain.mode 2 ρ (r : ℂ) = Chain.mode 2 ρ' (r : ℂ)
```

**Needs** (its hypotheses)

  - `` h : (2 : ℂ) ^ ρ = (2 : ℂ) ^ ρ' ``
  - `` r : ℤ ``

**Stated with:** [`Chain.mode`](../lean/Chain.md#Chain-mode)

**Fed by** (1 theorem its proof uses)

  - [`CellModes.mode_two_int`](../lean_stage3/CellModes.md#CellModes-mode_two_int) (CellModes) — `` Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r ``

**Feeds:** nothing. It is an end.

<a name="AliasClass-alias_weight"></a>
### `AliasClass.alias_weight`

line 81

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** A folded class is one mode. Zeros sharing `2^ρ = z` contribute to the cell `(r, d)` their coefficients added, times the symbol at `z` to the depth, times `z^r`.

**Proves**

```lean
∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) = (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ)) * (1 - z⁻¹) ^ d * z ^ r
```

**Needs** (its hypotheses)

  - `` S : Finset Kadiri.NontrivialZeros ``
  - `` hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z ``
  - `` d : ℕ ``
  - `` r : ℤ ``

**Stated with:** [`Chain.Sym`](../lean/Chain.md#Chain-Sym), [`Chain.mode`](../lean/Chain.md#Chain-mode)

**Fed by** (2 theorems its proof uses)

  - [`CellModes.mode_two_int`](../lean_stage3/CellModes.md#CellModes-mode_two_int) (CellModes) — `` Chain.mode 2 ρ (r : ℂ) = ((2:ℂ) ^ ρ) ^ r ``
  - [`CellModes.sym_two`](../lean_stage3/CellModes.md#CellModes-sym_two) (CellModes) — `` Chain.Sym 2 ρ = 1 - ((2:ℂ) ^ ρ)⁻¹ ``

**Feeds** (2 that use it)

  - [`AliasClass.alias_weight_ne_zero`](#AliasClass-alias_weight_ne_zero) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0 ``
  - [`LadderFading.line_not_fading`](../lean_stage3/LadderFading.md#LadderFading-line_not_fading) (LadderFading) — `` ¬ Tendsto (fun r : ℕ => (∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (((r : ℤ)) : ℂ)) … ``

<a name="AliasClass-alias_weight_ne_zero"></a>
### `AliasClass.alias_weight_ne_zero`

line 93

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** Folding loses no zero. The mode a folded class contributes has weight not zero, at every depth and every row.

**Proves**

```lean
∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) ≠ 0
```

**Needs** (its hypotheses)

  - `` S : Finset Kadiri.NontrivialZeros ``
  - `` hS : S.Nonempty ``
  - `` hz : ∀ ρ ∈ S, (2 : ℂ) ^ (ρ : ℂ) = z ``
  - `` d : ℕ ``
  - `` r : ℤ ``

**Stated with:** [`Chain.Sym`](../lean/Chain.md#Chain-Sym), [`Chain.mode`](../lean/Chain.md#Chain-mode)

**Fed by** (3 theorems its proof uses)

  - [`AliasClass.alias_weight`](#AliasClass-alias_weight) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) * Chain.Sym 2 (ρ : ℂ) ^ d * Chain.mode 2 (ρ : ℂ) (r : ℂ) = (∑ ρ ∈ S, (((riemannZeta.order (… ``
  - [`AliasClass.sum_order_div_ne_zero`](#AliasClass-sum_order_div_ne_zero) — `` ∑ ρ ∈ S, (((riemannZeta.order (ρ : ℂ) : ℤ) : ℂ)) / (ρ : ℂ) ≠ 0 ``
  - [`AliasClass.zero_re_pos`](#AliasClass-zero_re_pos) — `` 0 < (ρ : ℂ).re ``

**Feeds:** nothing. It is an end.

