# `lean_stage3/Stage3/WeilPowerPhase.lean`

**What it does** (its own header): WeilPowerPhase — the phase of the tail product: `S m w` is its principal part `c·w·exp(w²σ)` up to a relative error `2q`, and `Re (S m w)²` has an explicit lower bound. Rung 5, twelfth slice; worksheet § 13 requirement (b). 2026-09-06. Unit 0347.

**Imports:** [`WeilPowerSharp`](../lean_stage3/WeilPowerSharp.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerBridge`](../lean_stage3/WeilPowerBridge.md), [`WeilPowerSigma`](../lean_stage3/WeilPowerSigma.md), [`WeilPowerTail`](../lean_stage3/WeilPowerTail.md).

```mermaid
flowchart LR
  n0["hterm<br/>(def)"]:::dfn
  n1["sigmaN<br/>(def)"]:::dfn
  n2["sigma<br/>(def)"]:::dfn
  n3["summable_hterm<br/>⊢ Summable hterm"]:::thm
  n4["summable_shift<br/>⊢ Summable (fun k : ℕ =＞ hterm (k + (m + 1)))"]:::thm
  n5["sigmaN_eq<br/>⊢ sigmaN m n = 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ…"]:::thm
  n6["sigmaN_tendsto<br/>⊢ Tendsto (fun n =＞ sigmaN m n) atTop (𝓝 (sigma m))"]:::thm
  n7["sigma_le<br/>⊢ sigma m ≤ 1 / (Real.pi ^ 2 * ((m : ℝ) + 1))"]:::end_
  n8["sigma_ge<br/>⊢ 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m"]:::thm
  n9["x<br/>(def)"]:::dfn
  n10["g_eq<br/>⊢ g w j = 1 + x w j"]:::thm
  n11["x_eq_mul<br/>⊢ x w j = w ^ 2 * ((hterm j : ℝ) : ℂ)"]:::thm
  n12["g_ne_zero<br/>⊢ g w j ≠ 0"]:::thm
  n13["T_eq_exp<br/>⊢ T m w n = Complex.exp (∑ j ∈ Finset.Ico (m + 1) n, Complex.log (g w j)…"]:::thm
  n14["delta<br/>(def)"]:::dfn
  n15["norm_log_sub_le<br/>⊢ ‖Complex.log (g w j) - x w j‖ ≤ ‖x w j‖ ^ 2"]:::thm
  n16["q<br/>(def)"]:::dfn
  n17["q_nonneg<br/>⊢ 0 ≤ q m w"]:::thm
  n18["norm_delta_le<br/>⊢ ‖delta m w n‖ ≤ q m w"]:::thm
  n19["T_eq_mul<br/>⊢ T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (…"]:::thm
  n20["norm_exp_delta_sub_one_le<br/>⊢ ‖Complex.exp (delta m w n) - 1‖ ≤ 2 * q m w"]:::thm
  n21["P<br/>(def)"]:::dfn
  n22["P_tendsto<br/>⊢ Tendsto (fun n =＞ Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))) atTop …"]:::thm
  n23["norm_S_sub_le<br/>⊢ ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖ ≤ 2 * q m w * ‖((cS m / D…"]:::thm
  n24["norm_A_sq<br/>⊢ ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 = (cS m / D m) ^ 2 * ‖w‖ ^ 2 …"]:::thm
  n25["re_A_sq<br/>⊢ ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re = (cS m / D m) ^ 2 * Rea…"]:::thm
  n26["re_sq_ge<br/>⊢ ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re - ‖((cS m / D m : ℝ) : ℂ…"]:::thm
  n27["re_S_sq_ge<br/>⊢ (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re *…"]:::thm
  x0(["WeilOddPower · QS"]):::ext
  x1(["WeilOddPower · S"]):::ext
  x2(["WeilOddPower · cS"]):::ext
  x3(["WeilPowerAssembly · isTest_phiWC"]):::ext
  x4(["WeilPowerAssembly · phiW_contDiff_one"]):::ext
  x5(["WeilPowerAssembly · target_lower"]):::ext
  x6(["WeilPowerBridge · term_le_at_zero"]):::ext
  x7(["WeilPowerGauss · D"]):::ext
  x8(["WeilPowerGauss · T"]):::ext
  x9(["WeilPowerGauss · cprime_pos"]):::ext
  x10(["WeilPowerGauss · g"]):::ext
  x11(["WeilPowerGauss · norm_x_le"]):::ext
  x12(["WeilPowerGauss · sum_inv_pow4_le"]):::ext
  x13(["WeilPowerGauss · sum_inv_sq_le"]):::ext
  x14(["WeilPowerGauss · tendsto_S"]):::ext
  x15(["WeilPowerGauss · x_norm"]):::ext
  x16(["WeilPowerGeomGen · uLam"]):::ext
  x17(["WeilPowerNear · uLam_nonneg"]):::ext
  x18(["WeilPowerSharp · sum_inv_sq_ge_sharp"]):::ext
  x19(["WeilPowerSigma · sigma_ge_amgm"]):::ext
  x20(["WeilPowerSigma · sigma_le_half"]):::ext
  x21(["WeilPowerSigma · u"]):::ext
  x22(["WeilPowerSigma · u_def"]):::ext
  n0 --> n1
  n0 --> n11
  n0 --> n19
  n0 --> n2
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n1 --> n19
  n1 --> n22
  n1 --> n23
  n1 --> n5
  n1 --> n6
  n10 --> n12
  n10 --> n15
  n11 --> n19
  n12 --> n13
  n13 --> n19
  n14 --> n18
  n14 --> n19
  n14 --> n20
  n14 --> n23
  n15 --> n18
  n16 --> n17
  n16 --> n18
  n16 --> n20
  n16 --> n23
  n16 --> n26
  n16 --> n27
  n16 --> x5
  n17 --> n26
  n18 --> n20
  n19 --> n23
  n2 --> n21
  n2 --> n24
  n2 --> n25
  n2 --> n27
  n2 --> n6
  n2 --> n7
  n2 --> n8
  n2 --> x16
  n2 --> x19
  n2 --> x20
  n2 --> x21
  n2 --> x22
  n2 --> x5
  n2 --> x6
  n20 --> n23
  n21 --> n22
  n21 --> n23
  n21 --> n24
  n21 --> n25
  n21 --> n26
  n22 --> n23
  n23 --> n26
  n24 --> n27
  n25 --> n27
  n26 --> n27
  n27 --> x6
  n3 --> n4
  n4 --> n6
  n5 --> n7
  n5 --> n8
  n5 --> x19
  n5 --> x20
  n6 --> n22
  n6 --> n7
  n6 --> n8
  n6 --> x19
  n6 --> x20
  n8 --> x17
  n9 --> n10
  n9 --> n11
  n9 --> n12
  n9 --> n14
  n9 --> n15
  n9 --> n18
  n9 --> n19
  n9 --> x3
  n9 --> x4
  x0 --> n23
  x0 --> n26
  x0 --> n27
  x1 --> n23
  x1 --> n26
  x1 --> n27
  x10 --> n10
  x10 --> n12
  x10 --> n13
  x10 --> n14
  x10 --> n15
  x10 --> n18
  x11 --> n12
  x11 --> n15
  x12 --> n18
  x13 --> n7
  x14 --> n23
  x15 --> n18
  x18 --> n8
  x2 --> n23
  x2 --> n24
  x2 --> n25
  x2 --> n26
  x2 --> n27
  x7 --> n23
  x7 --> n24
  x7 --> n25
  x7 --> n26
  x7 --> n27
  x8 --> n13
  x8 --> n19
  x9 --> n24
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
| `WeilPowerPhase.hterm`<br/>def, line 50 | ℝ | j : ℕ | The summand of the tail sum, `1/(π²(j+1)²)`. | — | `WeilPowerPhase.T_eq_mul`, `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.summable_hterm`, `WeilPowerPhase.summable_shift`, `WeilPowerPhase.x_eq_mul` |
| `WeilPowerPhase.sigmaN`<br/>def, line 53 | ℝ | m n : ℕ | The partial tail sum `σ_n`. | `WeilPowerPhase.hterm` | `WeilPowerPhase.P_tendsto`, `WeilPowerPhase.T_eq_mul`, `WeilPowerPhase.norm_S_sub_le`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.sigmaN_tendsto` |
| `WeilPowerPhase.sigma`<br/>def, line 56 | ℝ | m : ℕ | The full tail sum `σ = Σ_{j ≥ m+1} 1/(π²(j+1)²)`. | `WeilPowerPhase.hterm` | `WeilPowerAssembly.target_lower`, `WeilPowerBridge.term_le_at_zero`, `WeilPowerGeomGen.uLam`, `WeilPowerPhase.P`, `WeilPowerPhase.norm_A_sq`, `WeilPowerPhase.re_A_sq`, `WeilPowerPhase.re_S_sq_ge`, `WeilPowerPhase.sigmaN_tendsto`, `WeilPowerPhase.sigma_ge`, `WeilPowerPhase.sigma_le`, `WeilPowerSigma.sigma_ge_amgm`, `WeilPowerSigma.sigma_le_half`, `WeilPowerSigma.u`, `WeilPowerSigma.u_def` |
| `WeilPowerPhase.summable_hterm`<br/>theorem, line 58 | Summable hterm | — | — | `WeilPowerPhase.hterm` | `WeilPowerPhase.summable_shift` |
| `WeilPowerPhase.summable_shift`<br/>theorem, line 68 | Summable (fun k : ℕ =&gt; hterm (k + (m + 1))) | m : ℕ | — | `WeilPowerPhase.hterm`, `WeilPowerPhase.summable_hterm` | `WeilPowerPhase.sigmaN_tendsto` |
| `WeilPowerPhase.sigmaN_eq`<br/>theorem, line 71 | sigmaN m n = 1 / Real.pi ^ 2 * ∑ j ∈ Finset.Ico (m + 1) n, 1 / ((j : ℝ) + 1) ^ 2 | m n : ℕ | — | `WeilPowerPhase.hterm`, `WeilPowerPhase.sigmaN` | `WeilPowerPhase.sigma_ge`, `WeilPowerPhase.sigma_le`, `WeilPowerSigma.sigma_ge_amgm`, `WeilPowerSigma.sigma_le_half` |
| `WeilPowerPhase.sigmaN_tendsto`<br/>theorem, line 79 | Tendsto (fun n =&gt; sigmaN m n) atTop (𝓝 (sigma m)) | m : ℕ | — | `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN`, `WeilPowerPhase.summable_shift` | `WeilPowerPhase.P_tendsto`, `WeilPowerPhase.sigma_ge`, `WeilPowerPhase.sigma_le`, `WeilPowerSigma.sigma_ge_amgm`, `WeilPowerSigma.sigma_le_half` |
| `WeilPowerPhase.sigma_le`<br/>theorem, line 89 | sigma m ≤ 1 / (Real.pi ^ 2 * ((m : ℝ) + 1)) | m : ℕ | — | `WeilPowerGauss.sum_inv_sq_le`, `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.sigmaN_tendsto` | — |
| `WeilPowerPhase.sigma_ge`<br/>theorem, line 99 | 1 / (Real.pi ^ 2 * ((m : ℝ) + 2)) ≤ sigma m | m : ℕ | — | `WeilPowerPhase.sigma`, `WeilPowerPhase.sigmaN_eq`, `WeilPowerPhase.sigmaN_tendsto`, `WeilPowerSharp.sum_inv_sq_ge_sharp` | `WeilPowerNear.uLam_nonneg` |
| `WeilPowerPhase.x`<br/>def, line 114 | ℂ | w : ℂ; j : ℕ | `x_j = w²/(π²(j+1)²)`, so that `g w j = 1 + x w j`. | — | `WeilPowerAssembly.isTest_phiWC`, `WeilPowerAssembly.phiW_contDiff_one`, `WeilPowerPhase.T_eq_mul`, `WeilPowerPhase.delta`, `WeilPowerPhase.g_eq`, `WeilPowerPhase.g_ne_zero`, `WeilPowerPhase.norm_delta_le`, `WeilPowerPhase.norm_log_sub_le`, `WeilPowerPhase.x_eq_mul` |
| `WeilPowerPhase.g_eq`<br/>theorem, line 116 | g w j = 1 + x w j | w : ℂ; j : ℕ | — | `WeilPowerGauss.g`, `WeilPowerPhase.x` | `WeilPowerPhase.g_ne_zero`, `WeilPowerPhase.norm_log_sub_le` |
| `WeilPowerPhase.x_eq_mul`<br/>theorem, line 118 | x w j = w ^ 2 * ((hterm j : ℝ) : ℂ) | w : ℂ; j : ℕ | — | `WeilPowerPhase.hterm`, `WeilPowerPhase.x` | `WeilPowerPhase.T_eq_mul` |
| `WeilPowerPhase.g_ne_zero`<br/>theorem, line 123 | g w j ≠ 0 | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hj : m + 1 ≤ j | — | `WeilPowerGauss.g`, `WeilPowerGauss.norm_x_le`, `WeilPowerPhase.g_eq`, `WeilPowerPhase.x` | `WeilPowerPhase.T_eq_exp` |
| `WeilPowerPhase.T_eq_exp`<br/>theorem, line 132 | T m w n = Complex.exp (∑ j ∈ Finset.Ico (m + 1) n, Complex.log (g w j)) | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; n : ℕ | — | `WeilPowerGauss.T`, `WeilPowerGauss.g`, `WeilPowerPhase.g_ne_zero` | `WeilPowerPhase.T_eq_mul` |
| `WeilPowerPhase.delta`<br/>def, line 141 | ℂ | m : ℕ; w : ℂ; n : ℕ | `δ_n = Σ (log(1 + x_j) − x_j)`. | `WeilPowerGauss.g`, `WeilPowerPhase.x` | `WeilPowerPhase.T_eq_mul`, `WeilPowerPhase.norm_S_sub_le`, `WeilPowerPhase.norm_delta_le`, `WeilPowerPhase.norm_exp_delta_sub_one_le` |
| `WeilPowerPhase.norm_log_sub_le`<br/>theorem, line 144 | ‖Complex.log (g w j) - x w j‖ ≤ ‖x w j‖ ^ 2 | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hj : m + 1 ≤ j | — | `WeilPowerGauss.g`, `WeilPowerGauss.norm_x_le`, `WeilPowerPhase.g_eq`, `WeilPowerPhase.x` | `WeilPowerPhase.norm_delta_le` |
| `WeilPowerPhase.q`<br/>def, line 161 | ℝ | m : ℕ; w : ℂ | The quartic error `q = ‖w‖⁴/(π⁴(m+1)³)`. | — | `WeilPowerAssembly.target_lower`, `WeilPowerPhase.norm_S_sub_le`, `WeilPowerPhase.norm_delta_le`, `WeilPowerPhase.norm_exp_delta_sub_one_le`, `WeilPowerPhase.q_nonneg`, `WeilPowerPhase.re_S_sq_ge`, `WeilPowerPhase.re_sq_ge` |
| `WeilPowerPhase.q_nonneg`<br/>theorem, line 163 | 0 ≤ q m w | m : ℕ; w : ℂ | — | `WeilPowerPhase.q` | `WeilPowerPhase.re_sq_ge` |
| `WeilPowerPhase.norm_delta_le`<br/>theorem, line 167 | ‖delta m w n‖ ≤ q m w | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; n : ℕ | — | `WeilPowerGauss.g`, `WeilPowerGauss.sum_inv_pow4_le`, `WeilPowerGauss.x_norm`, `WeilPowerPhase.delta`, `WeilPowerPhase.norm_log_sub_le`, `WeilPowerPhase.q`, `WeilPowerPhase.x` | `WeilPowerPhase.norm_exp_delta_sub_one_le` |
| `WeilPowerPhase.T_eq_mul`<br/>theorem, line 193 | T m w n = Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ)) * Complex.exp (delta m w n) | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; n : ℕ | The split. `T m w n = exp(w² σ_n) · exp(δ_n)`. | `WeilPowerGauss.T`, `WeilPowerPhase.T_eq_exp`, `WeilPowerPhase.delta`, `WeilPowerPhase.hterm`, `WeilPowerPhase.sigmaN`, `WeilPowerPhase.x`, `WeilPowerPhase.x_eq_mul` | `WeilPowerPhase.norm_S_sub_le` |
| `WeilPowerPhase.norm_exp_delta_sub_one_le`<br/>theorem, line 207 | ‖Complex.exp (delta m w n) - 1‖ ≤ 2 * q m w | hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hq : q m w ≤ 1; n : ℕ | — | `WeilPowerPhase.delta`, `WeilPowerPhase.norm_delta_le`, `WeilPowerPhase.q` | `WeilPowerPhase.norm_S_sub_le` |
| `WeilPowerPhase.P`<br/>def, line 215 | ℂ | m : ℕ; w : ℂ | The principal part `P = exp(w² σ)`. | `WeilPowerPhase.sigma` | `WeilPowerPhase.P_tendsto`, `WeilPowerPhase.norm_A_sq`, `WeilPowerPhase.norm_S_sub_le`, `WeilPowerPhase.re_A_sq`, `WeilPowerPhase.re_sq_ge` |
| `WeilPowerPhase.P_tendsto`<br/>theorem, line 217 | Tendsto (fun n =&gt; Complex.exp (w ^ 2 * ((sigmaN m n : ℝ) : ℂ))) atTop (𝓝 (P m w)) | m : ℕ; w : ℂ | — | `WeilPowerPhase.P`, `WeilPowerPhase.sigmaN`, `WeilPowerPhase.sigmaN_tendsto` | `WeilPowerPhase.norm_S_sub_le` |
| `WeilPowerPhase.norm_S_sub_le`<br/>theorem, line 225 | ‖S m w - ((cS m / D m : ℝ) : ℂ) * w * P m w‖ ≤ 2 * q m w * ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hq : q m w ≤ 1 | The principal part carries `S` up to `2q`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerGauss.tendsto_S`, `WeilPowerPhase.P`, `WeilPowerPhase.P_tendsto`, `WeilPowerPhase.T_eq_mul`, `WeilPowerPhase.delta`, `WeilPowerPhase.norm_exp_delta_sub_one_le`, `WeilPowerPhase.q`, `WeilPowerPhase.sigmaN` | `WeilPowerPhase.re_sq_ge` |
| `WeilPowerPhase.norm_A_sq`<br/>theorem, line 245 | ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 = (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) | m : ℕ; w : ℂ | — | `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerGauss.cprime_pos`, `WeilPowerPhase.P`, `WeilPowerPhase.sigma` | `WeilPowerPhase.re_S_sq_ge` |
| `WeilPowerPhase.re_A_sq`<br/>theorem, line 258 | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re = (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m)) | m : ℕ; w : ℂ | The real part of the principal part squared, explicitly. | `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerPhase.P`, `WeilPowerPhase.sigma` | `WeilPowerPhase.re_S_sq_ge` |
| `WeilPowerPhase.re_sq_ge`<br/>theorem, line 285 | ((((cS m / D m : ℝ) : ℂ) * w * P m w) ^ 2).re - ‖((cS m / D m : ℝ) : ℂ) * w * P m w‖ ^ 2 * (4 * q m w + 4 * q m w ^ 2) ≤ ((S m w) ^ 2).re | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hq : q m w ≤ 1 | The lower bound on `Re (S m w)²`. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerPhase.P`, `WeilPowerPhase.norm_S_sub_le`, `WeilPowerPhase.q`, `WeilPowerPhase.q_nonneg` | `WeilPowerPhase.re_S_sq_ge` |
| `WeilPowerPhase.re_S_sq_ge`<br/>theorem, line 312 | (cS m / D m) ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * ((w ^ 2).re * Real.cos (2 * (w ^ 2).im * sigma m) - (w ^ 2).im * Real.sin (2 * (w ^ 2).im * sigma m)) - (cS m / D m) ^ 2 * ‖w‖ ^ 2 * Real.exp (2 * (w ^ 2).re * sigma m) * (4 * q m w + 4 * q m w ^ 2) ≤ ((S m w) ^ 2).re | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hq : q m w ≤ 1 | The deliverable. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilOddPower.cS`, `WeilPowerGauss.D`, `WeilPowerPhase.norm_A_sq`, `WeilPowerPhase.q`, `WeilPowerPhase.re_A_sq`, `WeilPowerPhase.re_sq_ge`, `WeilPowerPhase.sigma` | `WeilPowerBridge.term_le_at_zero` |
