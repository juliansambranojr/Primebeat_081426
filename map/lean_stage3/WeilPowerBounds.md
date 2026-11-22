# `lean_stage3/Stage3/WeilPowerBounds.lean`

**What it does** (its own header): WeilPowerBounds — bounds on the odd transform read off its polynomial. Rung 5, fourth slice. 2026-09-06.

**Imports:** [`WeilOddPower`](../lean_stage3/WeilOddPower.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerBackground`](../lean_stage3/WeilPowerBackground.md), [`WeilPowerBridge`](../lean_stage3/WeilPowerBridge.md), [`WeilPowerGauss`](../lean_stage3/WeilPowerGauss.md).

```mermaid
flowchart LR
  n0["factor_eq<br/>⊢ w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a …"]:::thm
  n1["norm_factor_ge<br/>⊢ w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖"]:::thm
  n2["QS_factor<br/>⊢ QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1…"]:::thm
  n3["norm_QS_ge<br/>⊢ (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖"]:::thm
  n4["QS_ne_zero<br/>⊢ QS m w ≠ 0"]:::thm
  n5["cS_pos<br/>⊢ 0 ＜ cS m"]:::thm
  n6["S_eq_div'<br/>⊢ S m w = (cS m : ℂ) * Complex.sinh w / QS m w"]:::thm
  n7["S_eq_div<br/>⊢ S m w = (cS m : ℂ) * Complex.sinh w / QS m w"]:::end_
  n8["norm_S_le'<br/>⊢ ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖"]:::thm
  n9["norm_S_le<br/>⊢ ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖"]:::end_
  n10["norm_factor_ge_far<br/>⊢ w.im ^ 2 / 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖"]:::thm
  n11["norm_QS_ge_far<br/>⊢ (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖"]:::thm
  n12["norm_S_le_far<br/>⊢ ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1)"]:::thm
  n13["Ps<br/>(def)"]:::dfn
  n14["Ps_pos<br/>⊢ 0 ＜ Ps m s"]:::thm
  n15["QS_ofReal<br/>⊢ QS m (s : ℂ) = ((Ps m s : ℝ) : ℂ)"]:::thm
  n16["S_real_eq<br/>⊢ S m (s : ℂ) = ((cS m * Real.sinh s / Ps m s : ℝ) : ℂ)"]:::thm
  n17["Ps_le<br/>⊢ Ps m s ≤ (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1)"]:::thm
  n18["sinh_ge<br/>⊢ Real.exp s / 4 ≤ Real.sinh s"]:::thm
  n19["S_real_ge<br/>⊢ cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (…"]:::end_
  x0(["WeilLobe · norm_sinh_le"]):::ext
  x1(["WeilOddPower · QS"]):::ext
  x2(["WeilOddPower · S"]):::ext
  x3(["WeilOddPower · S_mul_QS"]):::ext
  x4(["WeilOddPower · cS"]):::ext
  x5(["WeilPowerBackground · PsiW_le_far"]):::ext
  x6(["WeilPowerBands · cFarM_le"]):::ext
  x7(["WeilPowerBands · term_le_M"]):::ext
  x8(["WeilPowerBridge · far_sideband_le"]):::ext
  x9(["WeilPowerCompare · QS_ne_zero_wOf"]):::ext
  x10(["WeilPowerGauss · S_real_ge_gauss"]):::ext
  x11(["WeilPowerGauss · tendsto_S"]):::ext
  x12(["WeilPowerSharp · S_real_ge_sharp"]):::ext
  n0 --> n1
  n1 --> n3
  n10 --> n11
  n11 --> n12
  n12 --> x5
  n12 --> x8
  n13 --> n14
  n13 --> n15
  n13 --> n16
  n13 --> n17
  n13 --> n19
  n14 --> n16
  n14 --> n19
  n15 --> n16
  n16 --> n19
  n17 --> n19
  n18 --> n19
  n2 --> n11
  n2 --> n3
  n3 --> n4
  n4 --> n7
  n4 --> n9
  n4 --> x10
  n4 --> x12
  n4 --> x9
  n5 --> n12
  n5 --> n19
  n5 --> n8
  n5 --> x6
  n5 --> x7
  n6 --> n7
  n6 --> n8
  n6 --> x11
  n8 --> n12
  n8 --> n9
  x0 --> n8
  x1 --> n11
  x1 --> n12
  x1 --> n15
  x1 --> n2
  x1 --> n3
  x1 --> n4
  x1 --> n6
  x1 --> n7
  x1 --> n8
  x1 --> n9
  x2 --> n12
  x2 --> n16
  x2 --> n19
  x2 --> n6
  x2 --> n7
  x2 --> n8
  x2 --> n9
  x3 --> n16
  x3 --> n6
  x4 --> n12
  x4 --> n16
  x4 --> n19
  x4 --> n5
  x4 --> n6
  x4 --> n7
  x4 --> n8
  x4 --> n9
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
| `WeilPowerBounds.factor_eq`<br/>theorem, line 40 | w ^ 2 + (a : ℂ) ^ 2 = (w - Complex.I * (a : ℂ)) * (w + Complex.I * (a : ℂ)) | w : ℂ; a : ℝ | One factor of the product, factored: `w² + a² = (w − ia)(w + ia)`. | — | `WeilPowerBounds.norm_factor_ge` |
| `WeilPowerBounds.norm_factor_ge`<br/>theorem, line 45 | w.re ^ 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ | w : ℂ; a : ℝ | Each factor has norm at least `(Re w)²`. | `WeilPowerBounds.factor_eq` | `WeilPowerBounds.norm_QS_ge` |
| `WeilPowerBounds.QS_factor`<br/>theorem, line 57 | QS m w = ∏ j ∈ Finset.range (m + 1), (w ^ 2 + ((Real.pi * ((j : ℝ) + 1) : ℝ) : ℂ) ^ 2) | m : ℕ; w : ℂ | — | `WeilOddPower.QS` | `WeilPowerBounds.norm_QS_ge`, `WeilPowerBounds.norm_QS_ge_far` |
| `WeilPowerBounds.norm_QS_ge`<br/>theorem, line 66 | (w.re ^ 2) ^ (m + 1) ≤ ‖QS m w‖ | m : ℕ; w : ℂ | `‖QS m w‖ ≥ (Re w)^{2(m+1)}`. | `WeilOddPower.QS`, `WeilPowerBounds.QS_factor`, `WeilPowerBounds.norm_factor_ge` | `WeilPowerBounds.QS_ne_zero` |
| `WeilPowerBounds.QS_ne_zero`<br/>theorem, line 73 | QS m w ≠ 0 | hw : w.re ≠ 0 | — | `WeilOddPower.QS`, `WeilPowerBounds.norm_QS_ge` | `WeilPowerBounds.S_eq_div`, `WeilPowerBounds.norm_S_le`, `WeilPowerCompare.QS_ne_zero_wOf`, `WeilPowerGauss.S_real_ge_gauss`, `WeilPowerSharp.S_real_ge_sharp` |
| `WeilPowerBounds.cS_pos`<br/>theorem, line 80 | 0 &lt; cS m | m : ℕ | — | `WeilOddPower.cS` | `WeilPowerBands.cFarM_le`, `WeilPowerBands.term_le_M`, `WeilPowerBounds.S_real_ge`, `WeilPowerBounds.norm_S_le'`, `WeilPowerBounds.norm_S_le_far` |
| `WeilPowerBounds.S_eq_div'`<br/>theorem, line 85 | S m w = (cS m : ℂ) * Complex.sinh w / QS m w | hne : QS m w ≠ 0 | Wherever the product is nonzero the closed form is a quotient. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.S_mul_QS`, `WeilOddPower.cS` | `WeilPowerBounds.S_eq_div`, `WeilPowerBounds.norm_S_le'`, `WeilPowerGauss.tendsto_S` |
| `WeilPowerBounds.S_eq_div`<br/>theorem, line 90 | S m w = (cS m : ℂ) * Complex.sinh w / QS m w | hw : w.re ≠ 0 | — | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.QS_ne_zero`, `WeilPowerBounds.S_eq_div'` | — |
| `WeilPowerBounds.norm_S_le'`<br/>theorem, line 95 | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ | hne : QS m w ≠ 0 | The norm of the quotient, bounded by `cosh(Re w)` over the product's norm. | `WeilLobe.norm_sinh_le`, `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.S_eq_div'`, `WeilPowerBounds.cS_pos` | `WeilPowerBounds.norm_S_le`, `WeilPowerBounds.norm_S_le_far` |
| `WeilPowerBounds.norm_S_le`<br/>theorem, line 104 | ‖S m w‖ ≤ cS m * Real.cosh w.re / ‖QS m w‖ | hw : w.re ≠ 0 | Upper bound. `‖S m w‖ ≤ cS m · cosh(Re w) / ‖QS m w‖` for `Re w ≠ 0`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.QS_ne_zero`, `WeilPowerBounds.norm_S_le'` | — |
| `WeilPowerBounds.norm_factor_ge_far`<br/>theorem, line 109 | w.im ^ 2 / 2 ≤ ‖w ^ 2 + (a : ℂ) ^ 2‖ | hfar : 2 * (w.re ^ 2 + a ^ 2) ≤ w.im ^ 2 | Far up in height each factor is at least half the height squared. | — | `WeilPowerBounds.norm_QS_ge_far` |
| `WeilPowerBounds.norm_QS_ge_far`<br/>theorem, line 121 | (w.im ^ 2 / 2) ^ (m + 1) ≤ ‖QS m w‖ | hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2 | `‖QS m w‖ ≥ ((Im w)²/2)^{m+1}` when `2·((Re w)² + π²(m+1)²) ≤ (Im w)²`. | `WeilOddPower.QS`, `WeilPowerBounds.QS_factor`, `WeilPowerBounds.norm_factor_ge_far` | `WeilPowerBounds.norm_S_le_far` |
| `WeilPowerBounds.norm_S_le_far`<br/>theorem, line 142 | ‖S m w‖ ≤ cS m * Real.cosh w.re * (2 / w.im ^ 2) ^ (m + 1) | hfar : 2 * (w.re ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ w.im ^ 2 | Far bound. `‖S m w‖ ≤ cS m · cosh(Re w) · (2/(Im w)²)^{m+1}` when `2·((Re w)² + π²(m+1)²) ≤ (Im w)²`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.cS_pos`, `WeilPowerBounds.norm_QS_ge_far`, `WeilPowerBounds.norm_S_le'` | `WeilPowerBackground.PsiW_le_far`, `WeilPowerBridge.far_sideband_le` |
| `WeilPowerBounds.Ps`<br/>def, line 163 | ℝ | m : ℕ; s : ℝ | The real product `∏_{j=1}^{m+1}(s² + π²j²)`. | — | `WeilPowerBounds.Ps_le`, `WeilPowerBounds.Ps_pos`, `WeilPowerBounds.QS_ofReal`, `WeilPowerBounds.S_real_eq`, `WeilPowerBounds.S_real_ge` |
| `WeilPowerBounds.Ps_pos`<br/>theorem, line 166 | 0 &lt; Ps m s | m : ℕ; s : ℝ | — | `WeilPowerBounds.Ps` | `WeilPowerBounds.S_real_eq`, `WeilPowerBounds.S_real_ge` |
| `WeilPowerBounds.QS_ofReal`<br/>theorem, line 172 | QS m (s : ℂ) = ((Ps m s : ℝ) : ℂ) | m : ℕ; s : ℝ | — | `WeilOddPower.QS`, `WeilPowerBounds.Ps` | `WeilPowerBounds.S_real_eq` |
| `WeilPowerBounds.S_real_eq`<br/>theorem, line 178 | S m (s : ℂ) = ((cS m * Real.sinh s / Ps m s : ℝ) : ℂ) | m : ℕ; s : ℝ | At real `s` the transform is real: `cS m · sinh s / ∏(s² + π²j²)`. | `WeilOddPower.S`, `WeilOddPower.S_mul_QS`, `WeilOddPower.cS`, `WeilPowerBounds.Ps`, `WeilPowerBounds.Ps_pos`, `WeilPowerBounds.QS_ofReal` | `WeilPowerBounds.S_real_ge` |
| `WeilPowerBounds.Ps_le`<br/>theorem, line 188 | Ps m s ≤ (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1) | m : ℕ; s : ℝ | `Ps m s ≤ (s² + π²(m+1)²)^{m+1}`. | `WeilPowerBounds.Ps` | `WeilPowerBounds.S_real_ge` |
| `WeilPowerBounds.sinh_ge`<br/>theorem, line 203 | Real.exp s / 4 ≤ Real.sinh s | hs : 1 ≤ s | `sinh s ≥ e^s/4` for `s ≥ 1`. | — | `WeilPowerBounds.S_real_ge` |
| `WeilPowerBounds.S_real_ge`<br/>theorem, line 217 | cS m * Real.exp s / (4 * (s ^ 2 + Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ^ (m + 1)) ≤ (S m (s : ℂ)).re | hs : 1 ≤ s | Lower bound at the target. For `1 ≤ s`, `cS m · e^s / (4·(s² + π²(m+1)²)^{m+1}) ≤ Re (S m s)`. | `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.Ps`, `WeilPowerBounds.Ps_le`, `WeilPowerBounds.Ps_pos`, `WeilPowerBounds.S_real_eq`, `WeilPowerBounds.cS_pos`, `WeilPowerBounds.sinh_ge` | — |
