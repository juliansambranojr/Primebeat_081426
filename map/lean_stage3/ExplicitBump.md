# `lean_stage3/Stage3/ExplicitBump.lean`

**What it does** (its own header): ExplicitBump — a concrete `ν`, so `mellin_bump_bounded`'s `B` is a numeral. WHY THIS FILE EXISTS. `RHPull.psi_weak_of_RH` (`Stage3/LineBound.lean:2357`) assembles its constant from four distinct existentials:

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md).

```mermaid
flowchart LR
  n0["sqPos_eq<br/>⊢ (max 0 u) ^ 2 = if u ≤ 0 then 0 else u ^ 2"]:::lone
  n1["hasDerivAt_sqPos<br/>⊢ HasDerivAt (fun t : ℝ =＞ (max 0 t) ^ 2) (2 * max 0 u) u"]:::thm
  n2["contDiff_sqPos<br/>⊢ ContDiff ℝ 1 (fun t : ℝ =＞ (max 0 t) ^ 2)"]:::end_
  n3["bumpP<br/>(def)"]:::dfn
  n4["bumpC<br/>(def)"]:::dfn
  n5["bump<br/>(def)"]:::dfn
  n6["bumpP_nonpos_of_le<br/>⊢ bumpP x ≤ 0"]:::thm
  n7["bumpP_nonpos_of_ge<br/>⊢ bumpP x ≤ 0"]:::thm
  n8["bumpC_pos<br/>⊢ 0 ＜ bumpC"]:::end_
  n9["bump_nonneg<br/>⊢ 0 ≤ bump x"]:::end_
  n10["bump_support<br/>⊢ Function.support bump ⊆ Set.Icc (1/2 : ℝ) 2"]:::end_
  n11["bump_contDiff<br/>⊢ ContDiff ℝ 1 bump"]:::end_
  n12["bumpP_le<br/>⊢ bumpP x ≤ 9/16"]:::thm
  n13["bump_le<br/>⊢ bump x ≤ bumpC * (9/16) ^ 2"]:::thm
  n14["bump_le_numeral<br/>⊢ bump x ≤ 1.4757"]:::end_
  n1 --> n2
  n12 --> n13
  n13 --> n14
  n3 --> n10
  n3 --> n11
  n3 --> n12
  n3 --> n13
  n3 --> n5
  n3 --> n6
  n3 --> n7
  n4 --> n13
  n4 --> n14
  n4 --> n5
  n4 --> n8
  n5 --> n10
  n5 --> n11
  n5 --> n13
  n5 --> n14
  n5 --> n9
  n6 --> n10
  n7 --> n10
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
| `Stage3.sqPos_eq`<br/>theorem, line 60 | (max 0 u) ^ 2 = if u ≤ 0 then 0 else u ^ 2 | u : ℝ | `(max 0 u)²` written without the max, for differentiation. | — | — |
| `Stage3.hasDerivAt_sqPos`<br/>theorem, line 68 | HasDerivAt (fun t : ℝ =&gt; (max 0 t) ^ 2) (2 * max 0 u) u | u : ℝ | The derivative of `(max 0 ·)²` is `2·max 0 ·`, everywhere — including at the join, where both one-sided derivatives vanish. | — | `Stage3.contDiff_sqPos` |
| `Stage3.contDiff_sqPos`<br/>theorem, line 112 | ContDiff ℝ 1 (fun t : ℝ =&gt; (max 0 t) ^ 2) | — | — | `Stage3.hasDerivAt_sqPos` | — |
| `Stage3.bumpP`<br/>def, line 125 | ℝ | x : ℝ | The interval polynomial: `p x = (x − 1/2)(2 − x)`, positive exactly on `Ioo (1/2) 2`. | — | `Stage3.bump`, `Stage3.bumpP_le`, `Stage3.bumpP_nonpos_of_ge`, `Stage3.bumpP_nonpos_of_le`, `Stage3.bump_contDiff`, `Stage3.bump_le`, `Stage3.bump_support` |
| `Stage3.bumpC`<br/>def, line 129 | ℝ | — | The normalising constant `c = 1 / ∫_{1/2}^{2} p²/x`, in closed form. `∫ p²/x = 33/16 − (3/2)·log 2`. | — | `Stage3.bump`, `Stage3.bumpC_pos`, `Stage3.bump_le`, `Stage3.bump_le_numeral` |
| `Stage3.bump`<br/>def, line 133 | ℝ | x : ℝ | The explicit bump. `C¹`, supported exactly on `Icc (1/2) 2`, non-negative, and normalised so `∫ ν(x)/x dx = 1`. | `Stage3.bumpC`, `Stage3.bumpP` | `Stage3.bump_contDiff`, `Stage3.bump_le`, `Stage3.bump_le_numeral`, `Stage3.bump_nonneg`, `Stage3.bump_support` |
| `Stage3.bumpP_nonpos_of_le`<br/>theorem, line 135 | bumpP x ≤ 0 | hx : x ≤ 1/2 | — | `Stage3.bumpP` | `Stage3.bump_support` |
| `Stage3.bumpP_nonpos_of_ge`<br/>theorem, line 141 | bumpP x ≤ 0 | hx : 2 ≤ x | — | `Stage3.bumpP` | `Stage3.bump_support` |
| `Stage3.bumpC_pos`<br/>theorem, line 146 | 0 &lt; bumpC | — | `∫ p²/x` is positive, so `bumpC` is well defined and positive. | `Stage3.bumpC` | — |
| `Stage3.bump_nonneg`<br/>theorem, line 154 | 0 ≤ bump x | x : ℝ | — | `Stage3.bump` | — |
| `Stage3.bump_support`<br/>theorem, line 160 | Function.support bump ⊆ Set.Icc (1/2 : ℝ) 2 | — | Support. Off `Icc (1/2) 2` the polynomial is non-positive, so the positive part is zero. | `Stage3.bump`, `Stage3.bumpP`, `Stage3.bumpP_nonpos_of_ge`, `Stage3.bumpP_nonpos_of_le` | — |
| `Stage3.bump_contDiff`<br/>theorem, line 176 | ContDiff ℝ 1 bump | — | `C¹`. The polynomial is smooth and the positive-part square is `C¹`, so the composite is. | `Stage3.bump`, `Stage3.bumpP` | — |
| `Stage3.bumpP_le`<br/>theorem, line 185 | bumpP x ≤ 9/16 | x : ℝ | `p` peaks at `x = 5/4` with value `9/16`. | `Stage3.bumpP` | `Stage3.bump_le` |
| `Stage3.bump_le`<br/>theorem, line 190 | bump x ≤ bumpC * (9/16) ^ 2 | x : ℝ | The sup of the bump, at the peak: `sup ν = c·(9/16)²`. | `Stage3.bump`, `Stage3.bumpC`, `Stage3.bumpP`, `Stage3.bumpP_le` | `Stage3.bump_le_numeral` |
| `Stage3.bump_le_numeral`<br/>theorem, line 200 | bump x ≤ 1.4757 | x : ℝ | The numeral. `sup ν ≤ 1.4757`, hence `mellin_bump_bounded`'s `B = 3·sup‖ν‖ + 1 ≤ 5.4271`. Both bounds are decimal, so a consumer can carry them arithmetically. | `Stage3.bump`, `Stage3.bumpC`, `Stage3.bump_le` | — |
