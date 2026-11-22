# `lean_stage3/Stage3/WeilPower.lean`

**What it does** (its own header): WeilPower — the m-th power window's transform in closed form. Rung 5, second slice, first module of the switched window (units 0326–0328). 2026-09-06.

**Imports:** [`WeilLobe`](../lean_stage3/WeilLobe.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilOddPower`](../lean_stage3/WeilOddPower.md).

```mermaid
flowchart LR
  n0["c<br/>(def)"]:::dfn
  n1["P_eq_c_sq<br/>⊢ P x = c x ^ 2"]:::thm
  n2["P_pow<br/>⊢ P x ^ m = c x ^ (2 * m)"]:::thm
  n3["c_one<br/>⊢ c 1 = 0"]:::thm
  n4["c_neg_one<br/>⊢ c (-1) = 0"]:::thm
  n5["continuous_c<br/>⊢ Continuous c"]:::end_
  n6["c_pow_one<br/>⊢ c 1 ^ n = 0"]:::thm
  n7["c_pow_neg_one<br/>⊢ c (-1) ^ n = 0"]:::thm
  n8["hasDerivAt_c<br/>⊢ HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x"]:::thm
  n9["hasDerivAt_s<br/>⊢ HasDerivAt (fun y : ℝ =＞ Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c …"]:::thm
  n10["f1<br/>(def)"]:::dfn
  n11["f2<br/>(def)"]:::dfn
  n12["hasDerivAt_f<br/>⊢ HasDerivAt (fun y : ℝ =＞ c y ^ (k + 1)) (f1 k x) x"]:::thm
  n13["hasDerivAt_f1<br/>⊢ HasDerivAt (f1 (k + 1)) (f2 k x) x"]:::thm
  n14["continuous_f1<br/>⊢ Continuous (f1 k)"]:::thm
  n15["continuous_f2<br/>⊢ Continuous (f2 k)"]:::thm
  n16["f1_one<br/>⊢ f1 (k + 1) 1 = 0"]:::thm
  n17["f1_neg_one<br/>⊢ f1 (k + 1) (-1) = 0"]:::thm
  n18["K<br/>(def)"]:::dfn
  n19["hasDerivAt_E<br/>⊢ HasDerivAt (fun y : ℝ =＞ Complex.exp (w * (y : ℂ))) (w * Complex.exp (…"]:::thm
  n20["ibp_twice<br/>⊢ w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w…"]:::thm
  n21["K_succ<br/>⊢ K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) = ((m : …"]:::thm
  n22["Q<br/>(def)"]:::dfn
  n23["cK<br/>(def)"]:::dfn
  n24["Q_succ<br/>⊢ Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2)"]:::thm
  n25["cK_succ<br/>⊢ cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK …"]:::thm
  n26["K_zero_mul<br/>⊢ K 0 w * w = 2 * Complex.sinh w"]:::thm
  n27["K_mul_Q<br/>⊢ K m w * Q m w = (cK m : ℂ) * Complex.sinh w"]:::thm
  n28["cK_one<br/>⊢ cK 1 = Real.pi ^ 2"]:::thm
  n29["K_one_mul<br/>⊢ K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Comple…"]:::end_
  x0(["WeilOddPower · Q_succ_eq"]):::ext
  x1(["WeilOddPower · S_eq"]):::ext
  x2(["WeilOddPower · S_mul_QS"]):::ext
  x3(["WeilOddPower · cS_eq"]):::ext
  x4(["WeilOddPower · ibp_once"]):::ext
  x5(["WeilOddPower · q_eq"]):::ext
  x6(["WeilOddPower · sin_pi_mul"]):::ext
  x7(["WeilPowerAssembly · phiW_contDiff_one"]):::ext
  x8(["WeilWindow · P"]):::ext
  n0 --> n1
  n0 --> n10
  n0 --> n11
  n0 --> n12
  n0 --> n13
  n0 --> n2
  n0 --> n20
  n0 --> n21
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> n9
  n0 --> x1
  n0 --> x4
  n0 --> x6
  n0 --> x7
  n1 --> n2
  n10 --> n12
  n10 --> n13
  n10 --> n14
  n10 --> n16
  n10 --> n17
  n10 --> n20
  n10 --> x1
  n10 --> x4
  n10 --> x5
  n11 --> n13
  n11 --> n15
  n11 --> n20
  n11 --> n21
  n12 --> n13
  n12 --> n20
  n12 --> x4
  n13 --> n20
  n14 --> n20
  n14 --> x4
  n15 --> n20
  n16 --> n20
  n17 --> n20
  n18 --> n21
  n18 --> n26
  n18 --> n27
  n18 --> n29
  n18 --> x1
  n19 --> n20
  n19 --> x4
  n2 --> n21
  n2 --> x1
  n2 --> x5
  n20 --> n21
  n21 --> n27
  n22 --> n24
  n22 --> n27
  n22 --> n29
  n22 --> x0
  n23 --> n25
  n23 --> n27
  n23 --> n28
  n23 --> x2
  n23 --> x3
  n24 --> n27
  n25 --> n27
  n26 --> n27
  n27 --> n29
  n27 --> x2
  n28 --> n29
  n3 --> n16
  n3 --> n6
  n3 --> x7
  n4 --> n17
  n4 --> n7
  n4 --> x7
  n6 --> n20
  n6 --> x4
  n7 --> n20
  n7 --> x4
  n8 --> n12
  n8 --> x7
  n9 --> n13
  x8 --> n1
  x8 --> n18
  x8 --> n2
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
| `WeilPower.c`<br/>def, line 50 | ℝ | x : ℝ | The half-angle cosine `c(x) = cos(πx/2)`; `P = c²`. | — | `WeilOddPower.S_eq`, `WeilOddPower.ibp_once`, `WeilOddPower.sin_pi_mul`, `WeilPower.K_succ`, `WeilPower.P_eq_c_sq`, `WeilPower.P_pow`, `WeilPower.c_neg_one`, `WeilPower.c_one`, `WeilPower.c_pow_neg_one`, `WeilPower.c_pow_one`, `WeilPower.continuous_c`, `WeilPower.f1`, `WeilPower.f2`, `WeilPower.hasDerivAt_c`, `WeilPower.hasDerivAt_f`, `WeilPower.hasDerivAt_f1`, `WeilPower.hasDerivAt_s`, `WeilPower.ibp_twice`, `WeilPowerAssembly.phiW_contDiff_one` |
| `WeilPower.P_eq_c_sq`<br/>theorem, line 52 | P x = c x ^ 2 | x : ℝ | — | `WeilPower.c`, `WeilWindow.P` | `WeilPower.P_pow` |
| `WeilPower.P_pow`<br/>theorem, line 54 | P x ^ m = c x ^ (2 * m) | m : ℕ; x : ℝ | — | `WeilPower.P_eq_c_sq`, `WeilPower.c`, `WeilWindow.P` | `WeilOddPower.S_eq`, `WeilOddPower.q_eq`, `WeilPower.K_succ` |
| `WeilPower.c_one`<br/>theorem, line 57 | c 1 = 0 | — | — | `WeilPower.c` | `WeilPower.c_pow_one`, `WeilPower.f1_one`, `WeilPowerAssembly.phiW_contDiff_one` |
| `WeilPower.c_neg_one`<br/>theorem, line 60 | c (-1) = 0 | — | — | `WeilPower.c` | `WeilPower.c_pow_neg_one`, `WeilPower.f1_neg_one`, `WeilPowerAssembly.phiW_contDiff_one` |
| `WeilPower.continuous_c`<br/>theorem, line 64 | Continuous c | — | — | `WeilPower.c` | — |
| `WeilPower.c_pow_one`<br/>theorem, line 69 | c 1 ^ n = 0 | hn : n ≠ 0 | — | `WeilPower.c`, `WeilPower.c_one` | `WeilOddPower.ibp_once`, `WeilPower.ibp_twice` |
| `WeilPower.c_pow_neg_one`<br/>theorem, line 72 | c (-1) ^ n = 0 | hn : n ≠ 0 | — | `WeilPower.c`, `WeilPower.c_neg_one` | `WeilOddPower.ibp_once`, `WeilPower.ibp_twice` |
| `WeilPower.hasDerivAt_c`<br/>theorem, line 75 | HasDerivAt c (-(Real.pi / 2) * Real.sin (Real.pi * x / 2)) x | x : ℝ | — | `WeilPower.c` | `WeilPower.hasDerivAt_f`, `WeilPowerAssembly.phiW_contDiff_one` |
| `WeilPower.hasDerivAt_s`<br/>theorem, line 81 | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y / 2)) (Real.pi / 2 * c x) x | x : ℝ | — | `WeilPower.c` | `WeilPower.hasDerivAt_f1` |
| `WeilPower.f1`<br/>def, line 88 | ℝ | k : ℕ; x : ℝ | The derivative of `c^{k+1}`. | `WeilPower.c` | `WeilOddPower.S_eq`, `WeilOddPower.ibp_once`, `WeilOddPower.q_eq`, `WeilPower.continuous_f1`, `WeilPower.f1_neg_one`, `WeilPower.f1_one`, `WeilPower.hasDerivAt_f`, `WeilPower.hasDerivAt_f1`, `WeilPower.ibp_twice` |
| `WeilPower.f2`<br/>def, line 92 | ℝ | k : ℕ; x : ℝ | The second derivative of `c^{k+2}`. | `WeilPower.c` | `WeilPower.K_succ`, `WeilPower.continuous_f2`, `WeilPower.hasDerivAt_f1`, `WeilPower.ibp_twice` |
| `WeilPower.hasDerivAt_f`<br/>theorem, line 95 | HasDerivAt (fun y : ℝ =&gt; c y ^ (k + 1)) (f1 k x) x | k : ℕ; x : ℝ | — | `WeilPower.c`, `WeilPower.f1`, `WeilPower.hasDerivAt_c` | `WeilOddPower.ibp_once`, `WeilPower.hasDerivAt_f1`, `WeilPower.ibp_twice` |
| `WeilPower.hasDerivAt_f1`<br/>theorem, line 103 | HasDerivAt (f1 (k + 1)) (f2 k x) x | k : ℕ; x : ℝ | — | `WeilPower.c`, `WeilPower.f1`, `WeilPower.f2`, `WeilPower.hasDerivAt_f`, `WeilPower.hasDerivAt_s` | `WeilPower.ibp_twice` |
| `WeilPower.continuous_f1`<br/>theorem, line 116 | Continuous (f1 k) | k : ℕ | — | `WeilPower.f1` | `WeilOddPower.ibp_once`, `WeilPower.ibp_twice` |
| `WeilPower.continuous_f2`<br/>theorem, line 120 | Continuous (f2 k) | k : ℕ | — | `WeilPower.f2` | `WeilPower.ibp_twice` |
| `WeilPower.f1_one`<br/>theorem, line 125 | f1 (k + 1) 1 = 0 | k : ℕ | — | `WeilPower.c_one`, `WeilPower.f1` | `WeilPower.ibp_twice` |
| `WeilPower.f1_neg_one`<br/>theorem, line 128 | f1 (k + 1) (-1) = 0 | k : ℕ | — | `WeilPower.c_neg_one`, `WeilPower.f1` | `WeilPower.ibp_twice` |
| `WeilPower.K`<br/>def, line 132 | ℂ | m : ℕ; w : ℂ | The envelope's transform, `∫₋₁¹ P(x)^m e^{wx} dx`. | `WeilWindow.P` | `WeilOddPower.S_eq`, `WeilPower.K_mul_Q`, `WeilPower.K_one_mul`, `WeilPower.K_succ`, `WeilPower.K_zero_mul` |
| `WeilPower.hasDerivAt_E`<br/>theorem, line 135 | HasDerivAt (fun y : ℝ =&gt; Complex.exp (w * (y : ℂ))) (w * Complex.exp (w * (x : ℂ))) x | w : ℂ; x : ℝ | — | — | `WeilOddPower.ibp_once`, `WeilPower.ibp_twice` |
| `WeilPower.ibp_twice`<br/>theorem, line 143 | w ^ 2 * ∫ x in (-1 : ℝ)..1, ((c x ^ (k + 2) : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) = ∫ x in (-1 : ℝ)..1, ((f2 k x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ)) | k : ℕ; w : ℂ | The integral of `c^{k+2} e^{wx}` in terms of the second derivative: `w²·∫ c^{k+2} E = ∫ f2 k · E`. | `WeilPower.c`, `WeilPower.c_pow_neg_one`, `WeilPower.c_pow_one`, `WeilPower.continuous_f1`, `WeilPower.continuous_f2`, `WeilPower.f1`, `WeilPower.f1_neg_one`, `WeilPower.f1_one`, `WeilPower.f2`, `WeilPower.hasDerivAt_E`, `WeilPower.hasDerivAt_f`, `WeilPower.hasDerivAt_f1` | `WeilPower.K_succ` |
| `WeilPower.K_succ`<br/>theorem, line 185 | K (m + 1) w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) = ((m : ℂ) + 1) * (2 * (m : ℂ) + 1) * (Real.pi : ℂ) ^ 2 / 2 * K m w | m : ℕ; w : ℂ | The recurrence. `K (m+1) w · (w² + π²(m+1)²) = (m+1)(2m+1)π²/2 · K m w`. | `WeilPower.K`, `WeilPower.P_pow`, `WeilPower.c`, `WeilPower.f2`, `WeilPower.ibp_twice` | `WeilPower.K_mul_Q` |
| `WeilPower.Q`<br/>def, line 220 | ℂ | m : ℕ; w : ℂ | `w·∏_{j&lt;m}(w² + π²(j+1)²)`, the denominator of the closed form. | — | `WeilOddPower.Q_succ_eq`, `WeilPower.K_mul_Q`, `WeilPower.K_one_mul`, `WeilPower.Q_succ` |
| `WeilPower.cK`<br/>def, line 224 | ℝ | m : ℕ | `2·π^{2m}·(2m)!/4^m`, the numerator's constant. | — | `WeilOddPower.S_mul_QS`, `WeilOddPower.cS_eq`, `WeilPower.K_mul_Q`, `WeilPower.cK_one`, `WeilPower.cK_succ` |
| `WeilPower.Q_succ`<br/>theorem, line 226 | Q (m + 1) w = Q m w * (w ^ 2 + (Real.pi : ℂ) ^ 2 * ((m : ℂ) + 1) ^ 2) | m : ℕ; w : ℂ | — | `WeilPower.Q` | `WeilPower.K_mul_Q` |
| `WeilPower.cK_succ`<br/>theorem, line 232 | cK (m + 1) = ((m : ℝ) + 1) * (2 * (m : ℝ) + 1) * Real.pi ^ 2 / 2 * cK m | m : ℕ | — | `WeilPower.cK` | `WeilPower.K_mul_Q` |
| `WeilPower.K_zero_mul`<br/>theorem, line 243 | K 0 w * w = 2 * Complex.sinh w | w : ℂ | — | `WeilPower.K` | `WeilPower.K_mul_Q` |
| `WeilPower.K_mul_Q`<br/>theorem, line 255 | K m w * Q m w = (cK m : ℂ) * Complex.sinh w | m : ℕ; w : ℂ | The closed form, multiplied out. `K m w · w·∏_{j=1}^{m}(w² + π²j²) = 2·π^{2m}·(2m)!/4^m · sinh w`. | `WeilPower.K`, `WeilPower.K_succ`, `WeilPower.K_zero_mul`, `WeilPower.Q`, `WeilPower.Q_succ`, `WeilPower.cK`, `WeilPower.cK_succ` | `WeilOddPower.S_mul_QS`, `WeilPower.K_one_mul` |
| `WeilPower.cK_one`<br/>theorem, line 275 | cK 1 = Real.pi ^ 2 | — | At `m = 1`: `K 1 w · w(w² + π²) = π²·sinh w`, unit 0328's hand check. | `WeilPower.cK` | `WeilPower.K_one_mul` |
| `WeilPower.K_one_mul`<br/>theorem, line 280 | K 1 w * (w * (w ^ 2 + (Real.pi : ℂ) ^ 2)) = (Real.pi : ℂ) ^ 2 * Complex.sinh w | w : ℂ | — | `WeilPower.K`, `WeilPower.K_mul_Q`, `WeilPower.Q`, `WeilPower.cK_one` | — |
