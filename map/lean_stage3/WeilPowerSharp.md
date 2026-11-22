# `lean_stage3/Stage3/WeilPowerSharp.lean`

**What it does** (its own header): WeilPowerSharp — the Gaussian bounds with the constant kept exact and the tail sum sharp: the two lost factors of WeilPowerGauss removed. Rung 5, eleventh slice. 2026-09-06. Unit 0346; the decision is unit 0345.

**Imports:** [`WeilPowerGauss`](../lean_stage3/WeilPowerGauss.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md), [`WeilPowerPhase`](../lean_stage3/WeilPowerPhase.md).

```mermaid
flowchart LR
  n0["sum_telescope<br/>⊢ ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / (((j : ℝ) + 1) * …"]:::thm
  n1["sum_inv_sq_ge_sharp<br/>⊢ 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 …"]:::thm
  n2["Tr_ge_sharp<br/>⊢ Real.exp (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)…"]:::thm
  n3["S_real_ge_sharp<br/>⊢ cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^…"]:::thm
  n4["norm_S_le_c_pos<br/>⊢ ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m…"]:::thm
  n5["norm_S_le_c_neg<br/>⊢ ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (R…"]:::end_
  n6["compare_sharp<br/>⊢ ‖S m w‖ ≤ ‖w‖ / s * Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((…"]:::end_
  x0(["WeilOddPower · QS"]):::ext
  x1(["WeilOddPower · S"]):::ext
  x2(["WeilOddPower · cS"]):::ext
  x3(["WeilPowerBounds · QS_ne_zero"]):::ext
  x4(["WeilPowerGauss · D"]):::ext
  x5(["WeilPowerGauss · T_ofReal"]):::ext
  x6(["WeilPowerGauss · Tr"]):::ext
  x7(["WeilPowerGauss · cprime_pos"]):::ext
  x8(["WeilPowerGauss · exp_le_one_add"]):::ext
  x9(["WeilPowerGauss · norm_T_le_neg"]):::ext
  x10(["WeilPowerGauss · norm_T_le_pos"]):::ext
  x11(["WeilPowerGauss · sum_inv_pow4_le"]):::ext
  x12(["WeilPowerGauss · tendsto_S"]):::ext
  x13(["WeilPowerPhase · sigma_ge"]):::ext
  n0 --> n1
  n1 --> n2
  n1 --> x13
  n2 --> n3
  n3 --> n6
  n4 --> n6
  x0 --> n3
  x0 --> n4
  x0 --> n5
  x0 --> n6
  x1 --> n3
  x1 --> n4
  x1 --> n5
  x1 --> n6
  x10 --> n4
  x11 --> n2
  x12 --> n3
  x12 --> n4
  x12 --> n5
  x2 --> n3
  x2 --> n4
  x2 --> n5
  x2 --> n6
  x3 --> n3
  x4 --> n3
  x4 --> n4
  x4 --> n5
  x4 --> n6
  x5 --> n3
  x6 --> n2
  x6 --> n3
  x7 --> n3
  x7 --> n4
  x7 --> n5
  x7 --> n6
  x8 --> n2
  x9 --> n5
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
| `WeilPowerSharp.sum_telescope`<br/>theorem, line 53 | ∀ n : ℕ, m + 1 ≤ n → ∑ j ∈ Finset.Ico (m + 1) n, 1 / (((j : ℝ) + 1) * ((j : ℝ) + 2)) = 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) | m : ℕ | Telescoping sum over the tail. | — | `WeilPowerSharp.sum_inv_sq_ge_sharp` |
| `WeilPowerSharp.sum_inv_sq_ge_sharp`<br/>theorem, line 69 | 1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1) ≤ ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 | m : ℕ; hn : m + 1 ≤ n | The sharp lower bound for the tail sum: `1/(m+2) − 1/(n+1)`. | `WeilPowerSharp.sum_telescope` | `WeilPowerPhase.sigma_ge`, `WeilPowerSharp.Tr_ge_sharp` |
| `WeilPowerSharp.Tr_ge_sharp`<br/>theorem, line 80 | Real.exp (s ^ 2 / Real.pi ^ 2 * (1 / ((m : ℝ) + 2) - 1 / ((n : ℝ) + 1)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ Tr m s n | hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hn : m + 1 ≤ n | Tail product lower bound with the sharp sum. | `WeilPowerGauss.Tr`, `WeilPowerGauss.exp_le_one_add`, `WeilPowerGauss.sum_inv_pow4_le`, `WeilPowerSharp.sum_inv_sq_ge_sharp` | `WeilPowerSharp.S_real_ge_sharp` |
| `WeilPowerSharp.S_real_ge_sharp`<br/>theorem, line 133 | cS m / D m * s * Real.exp (s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 2)) - s ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) ≤ (S m (s : ℂ)).re | hs : 0 &lt; s; hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | Lower bound at the target, sharp. The constant is `cS m / D m` itself and the rate is `s²/(π²(m+2))`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerBounds.QS_ne_zero`, `WeilPowerGauss.D`, `WeilPowerGauss.T_ofReal`, `WeilPowerGauss.Tr`, `WeilPowerGauss.cprime_pos`, `WeilPowerGauss.tendsto_S`, `WeilPowerSharp.Tr_ge_sharp` | `WeilPowerSharp.compare_sharp` |
| `WeilPowerSharp.norm_S_le_c_pos`<br/>theorem, line 163 | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re / (Real.pi ^ 2 * ((m : ℝ) + 1)) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hre : 0 ≤ (w ^ 2).re | Upper bound, `Re(w²) ≥ 0`, constant kept. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerGauss.cprime_pos`, `WeilPowerGauss.norm_T_le_pos`, `WeilPowerGauss.tendsto_S` | `WeilPowerSharp.compare_sharp` |
| `WeilPowerSharp.norm_S_le_c_neg`<br/>theorem, line 175 | ‖S m w‖ ≤ cS m / D m * ‖w‖ * Real.exp ((w ^ 2).re * ((m : ℝ) + 2) / (Real.pi ^ 2 * (2 * (m : ℝ) + 3) ^ 2) + ‖w‖ ^ 4 / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hre : (w ^ 2).re ≤ 0 | Upper bound, `Re(w²) ≤ 0`, constant kept. The exponent is unit 0333's. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerGauss.cprime_pos`, `WeilPowerGauss.norm_T_le_neg`, `WeilPowerGauss.tendsto_S` | — |
| `WeilPowerSharp.compare_sharp`<br/>theorem, line 190 | ‖S m w‖ ≤ ‖w‖ / s * Real.exp (((w ^ 2).re - s ^ 2) / (Real.pi ^ 2 * ((m : ℝ) + 1)) + s ^ 2 / (Real.pi ^ 2 * ((m : ℝ) + 1) * ((m : ℝ) + 2)) + (‖w‖ ^ 4 + s ^ 4) / (Real.pi ^ 4 * ((m : ℝ) + 1) ^ 3)) * (S m (s : ℂ)).re | hne : QS m w ≠ 0; hs : 0 &lt; s; hw : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hsm : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hre : 0 ≤ (w ^ 2).re | The comparison with no lost factor. For `0 ≤ Re(w²)`, `0 &lt; s`, both in the regime, `‖S m w‖ ≤ (‖w‖/s) · exp(E) · Re (S m s)` with `E = (Re(w²) − s²)/(π²(m+1)) + s²/(π²(m+1)(m+2)) + (‖w‖⁴ + s⁴)/(π⁴(m+1)³)`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerGauss.cprime_pos`, `WeilPowerSharp.S_real_ge_sharp`, `WeilPowerSharp.norm_S_le_c_pos` | — |
