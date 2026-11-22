# `lean_stage3/Stage3/WeilWindow.lean`

**What it does** (its own header): WeilWindow — the raised-cosine window of entry 302, first two rungs of the detection ladder, crude constants. 2026-09-06.

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilTransform`](../lean_stage3/WeilTransform.md).

```mermaid
flowchart LR
  n0["P<br/>(def)"]:::dfn
  n1["m2<br/>(def)"]:::dfn
  n2["Sigma<br/>(def)"]:::dfn
  n3["P_nonneg<br/>⊢ 0 ≤ P x"]:::thm
  n4["P_le_one<br/>⊢ P x ≤ 1"]:::thm
  n5["P_one<br/>⊢ P 1 = 0"]:::end_
  n6["P_neg_one<br/>⊢ P (-1) = 0"]:::end_
  n7["continuous_P<br/>⊢ Continuous P"]:::thm
  n8["continuous_x2P<br/>⊢ Continuous fun x : ℝ =＞ x ^ 2 * P x"]:::thm
  n9["P_ge_half<br/>⊢ 1 / 2 ≤ P x"]:::thm
  n10["m2_le<br/>⊢ m2 ≤ 2 / 3"]:::end_
  n11["m2_ge<br/>⊢ 1 / 24 ≤ m2"]:::thm
  n12["mul_sinh_ge<br/>⊢ s * x ^ 2 ≤ x * Real.sinh (s * x)"]:::thm
  n13["Sigma_ge_mul<br/>⊢ s * m2 ≤ Sigma s"]:::thm
  n14["Sigma_ge<br/>⊢ s / 24 ≤ Sigma s"]:::end_
  x0(["WeilBackground · Psi_le_two"]):::ext
  x1(["WeilLobe · P_eq"]):::ext
  x2(["WeilLobe · SigmaC_eq_ibp"]):::ext
  x3(["WeilLobe · q_eq"]):::ext
  x4(["WeilOddPower · q"]):::ext
  x5(["WeilOffLine · offline_term_le"]):::ext
  x6(["WeilOffLine · offline_term_le_explicit"]):::ext
  x7(["WeilPower · K"]):::ext
  x8(["WeilPower · P_eq_c_sq"]):::ext
  x9(["WeilPower · P_pow"]):::ext
  x10(["WeilPowerAssembly · phiW_contDiff_one"]):::ext
  x11(["WeilPowerBackground · abs_q_le_one"]):::ext
  x12(["WeilTransform · G"]):::ext
  x13(["WeilTransform · P_even"]):::ext
  x14(["WeilTransform · Psi"]):::ext
  x15(["WeilTransform · SigmaC"]):::ext
  x16(["WeilTransform · SigmaC_ofReal"]):::ext
  x17(["WeilTransform · continuous_xP"]):::ext
  x18(["WeilTransform · ghat_eq"]):::ext
  x19(["WeilTransform · ghat_offline"]):::ext
  x20(["WeilTransform · xP_odd"]):::ext
  n0 --> n1
  n0 --> n10
  n0 --> n11
  n0 --> n2
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> n9
  n0 --> x0
  n0 --> x1
  n0 --> x10
  n0 --> x11
  n0 --> x12
  n0 --> x13
  n0 --> x14
  n0 --> x15
  n0 --> x17
  n0 --> x18
  n0 --> x2
  n0 --> x20
  n0 --> x3
  n0 --> x4
  n0 --> x7
  n0 --> x8
  n0 --> x9
  n1 --> n10
  n1 --> n11
  n1 --> n13
  n11 --> n14
  n12 --> n13
  n13 --> n14
  n2 --> n13
  n2 --> n14
  n2 --> x16
  n2 --> x19
  n2 --> x5
  n2 --> x6
  n3 --> n11
  n3 --> n13
  n3 --> x0
  n3 --> x11
  n4 --> n10
  n4 --> x0
  n4 --> x11
  n7 --> n13
  n7 --> n8
  n7 --> x17
  n8 --> n13
  n9 --> n11
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
| `WeilWindow.P`<br/>def, line 44 | ℝ | x : ℝ | The raised-cosine window, `cos²(πx/2)`, read on `[−1, 1]`. | — | `WeilBackground.Psi_le_two`, `WeilLobe.P_eq`, `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.q_eq`, `WeilOddPower.q`, `WeilPower.K`, `WeilPower.P_eq_c_sq`, `WeilPower.P_pow`, `WeilPowerAssembly.phiW_contDiff_one`, `WeilPowerBackground.abs_q_le_one`, `WeilTransform.G`, `WeilTransform.P_even`, `WeilTransform.Psi`, `WeilTransform.SigmaC`, `WeilTransform.continuous_xP`, `WeilTransform.ghat_eq`, `WeilTransform.xP_odd`, `WeilWindow.P_ge_half`, `WeilWindow.P_le_one`, `WeilWindow.P_neg_one`, `WeilWindow.P_nonneg`, `WeilWindow.P_one`, `WeilWindow.Sigma`, `WeilWindow.continuous_P`, `WeilWindow.continuous_x2P`, `WeilWindow.m2`, `WeilWindow.m2_ge`, `WeilWindow.m2_le` |
| `WeilWindow.m2`<br/>def, line 47 | ℝ | — | The second moment `∫₋₁¹ x²·P(x) dx`. | `WeilWindow.P` | `WeilWindow.Sigma_ge_mul`, `WeilWindow.m2_ge`, `WeilWindow.m2_le` |
| `WeilWindow.Sigma`<br/>def, line 50 | ℝ | s : ℝ | The odd-envelope integral `Σ(s) = ∫₋₁¹ x·P(x)·sinh(s x) dx`. | `WeilWindow.P` | `WeilOffLine.offline_term_le`, `WeilOffLine.offline_term_le_explicit`, `WeilTransform.SigmaC_ofReal`, `WeilTransform.ghat_offline`, `WeilWindow.Sigma_ge`, `WeilWindow.Sigma_ge_mul` |
| `WeilWindow.P_nonneg`<br/>theorem, line 52 | 0 ≤ P x | x : ℝ | — | `WeilWindow.P` | `WeilBackground.Psi_le_two`, `WeilPowerBackground.abs_q_le_one`, `WeilWindow.Sigma_ge_mul`, `WeilWindow.m2_ge` |
| `WeilWindow.P_le_one`<br/>theorem, line 55 | P x ≤ 1 | x : ℝ | — | `WeilWindow.P` | `WeilBackground.Psi_le_two`, `WeilPowerBackground.abs_q_le_one`, `WeilWindow.m2_le` |
| `WeilWindow.P_one`<br/>theorem, line 60 | P 1 = 0 | — | — | `WeilWindow.P` | — |
| `WeilWindow.P_neg_one`<br/>theorem, line 65 | P (-1) = 0 | — | — | `WeilWindow.P` | — |
| `WeilWindow.continuous_P`<br/>theorem, line 71 | Continuous P | — | — | `WeilWindow.P` | `WeilTransform.continuous_xP`, `WeilWindow.Sigma_ge_mul`, `WeilWindow.continuous_x2P` |
| `WeilWindow.continuous_x2P`<br/>theorem, line 74 | Continuous fun x : ℝ =&gt; x ^ 2 * P x | — | — | `WeilWindow.P`, `WeilWindow.continuous_P` | `WeilWindow.Sigma_ge_mul` |
| `WeilWindow.P_ge_half`<br/>theorem, line 78 | 1 / 2 ≤ P x | hx : \|x\| ≤ 1 / 2 | On `\|x\| ≤ 1/2` the window is at least `1/2`: `cos(πx/2) ≥ cos(π/4) = √2/2`. | `WeilWindow.P` | `WeilWindow.m2_ge` |
| `WeilWindow.m2_le`<br/>theorem, line 98 | m2 ≤ 2 / 3 | — | — | `WeilWindow.P`, `WeilWindow.P_le_one`, `WeilWindow.m2` | — |
| `WeilWindow.m2_ge`<br/>theorem, line 111 | 1 / 24 ≤ m2 | — | — | `WeilWindow.P`, `WeilWindow.P_ge_half`, `WeilWindow.P_nonneg`, `WeilWindow.m2` | `WeilWindow.Sigma_ge` |
| `WeilWindow.mul_sinh_ge`<br/>theorem, line 133 | s * x ^ 2 ≤ x * Real.sinh (s * x) | hs : 0 ≤ s; x : ℝ | `x·sinh(s x) ≥ s·x²` for every real `x`, when `s ≥ 0`. | — | `WeilWindow.Sigma_ge_mul` |
| `WeilWindow.Sigma_ge_mul`<br/>theorem, line 140 | s * m2 ≤ Sigma s | hs : 0 ≤ s | — | `WeilWindow.P_nonneg`, `WeilWindow.Sigma`, `WeilWindow.continuous_P`, `WeilWindow.continuous_x2P`, `WeilWindow.m2`, `WeilWindow.mul_sinh_ge` | `WeilWindow.Sigma_ge` |
| `WeilWindow.Sigma_ge`<br/>theorem, line 152 | s / 24 ≤ Sigma s | hs : 0 ≤ s | — | `WeilWindow.Sigma`, `WeilWindow.Sigma_ge_mul`, `WeilWindow.m2_ge` | — |
