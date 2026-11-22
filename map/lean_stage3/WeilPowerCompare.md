# `lean_stage3/Stage3/WeilPowerCompare.lean`

**What it does** (its own header): WeilPowerCompare — the comparison at another off-line zero. Rung 5, ninth slice, worksheet section 7. 2026-09-06.

**Imports:** [`WeilPowerGauss`](../lean_stage3/WeilPowerGauss.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md), [`WeilPowerSelect`](../lean_stage3/WeilPowerSelect.md).

```mermaid
flowchart LR
  n0["cP<br/>(def)"]:::dfn
  n1["cE<br/>(def)"]:::dfn
  n2["cQ<br/>(def)"]:::dfn
  n3["cP_pos<br/>⊢ 0 ＜ cP m"]:::end_
  n4["cE_pos<br/>⊢ 0 ＜ cE m"]:::thm
  n5["cQ_pos<br/>⊢ 0 ＜ cQ m"]:::thm
  n6["cE_le_cP<br/>⊢ cE m ≤ cP m"]:::end_
  n7["Eup<br/>(def)"]:::dfn
  n8["Elow<br/>(def)"]:::dfn
  n9["norm_S_le_gauss<br/>⊢ ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w)"]:::thm
  n10["S_real_ge_low<br/>⊢ 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow…"]:::thm
  n11["S_real_pos<br/>⊢ 0 ＜ (S m (s : ℂ)).re"]:::thm
  n12["compare_le<br/>⊢ ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s…"]:::thm
  n13["wOf<br/>(def)"]:::dfn
  n14["wOf_re<br/>⊢ (wOf ε Δ h).re = ε * h"]:::thm
  n15["wOf_im<br/>⊢ (wOf ε Δ h).im = Δ * h"]:::thm
  n16["wOf_sq_re<br/>⊢ ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2"]:::thm
  n17["norm_wOf_sq<br/>⊢ ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2"]:::thm
  n18["norm_wOf_pow4<br/>⊢ ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2"]:::thm
  n19["QS_ne_zero_wOf<br/>⊢ QS m (wOf ε Δ h) ≠ 0"]:::thm
  n20["rate<br/>(def)"]:::dfn
  n21["qerr<br/>(def)"]:::dfn
  n22["exponent_eq<br/>⊢ Eup m (wOf ε' Δ h) - Elow m (ε * h) = rate m ε' Δ ε * h ^ 2 + qerr m ε…"]:::thm
  n23["rate_eq_of_le<br/>⊢ rate m ε' Δ ε = -(cE m * (Δ ^ 2 + ε ^ 2 - ε' ^ 2))"]:::thm
  n24["rate_neg_of_le<br/>⊢ rate m ε' Δ ε ＜ 0"]:::end_
  n25["rate_neg_of_ge<br/>⊢ rate m ε' Δ ε ＜ 0"]:::end_
  n26["qerr_pos<br/>⊢ 0 ＜ qerr m ε' Δ ε"]:::thm
  n27["rate_neg_of_qerr<br/>⊢ rate m ε' Δ ε ＜ 0"]:::end_
  n28["compare_suppressed<br/>⊢ ‖S m (wOf ε' Δ h)‖ ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) * Re…"]:::end_
  x0(["WeilOddPower · QS"]):::ext
  x1(["WeilOddPower · S"]):::ext
  x2(["WeilPowerBounds · QS_ne_zero"]):::ext
  x3(["WeilPowerGauss · S_real_ge_gauss"]):::ext
  x4(["WeilPowerGauss · norm_S_le_gauss_neg"]):::ext
  x5(["WeilPowerGauss · norm_S_le_gauss_pos"]):::ext
  n0 --> n20
  n0 --> n25
  n0 --> n3
  n0 --> n6
  n0 --> n7
  n0 --> n9
  n1 --> n10
  n1 --> n20
  n1 --> n23
  n1 --> n24
  n1 --> n25
  n1 --> n4
  n1 --> n6
  n1 --> n7
  n1 --> n8
  n1 --> n9
  n10 --> n11
  n10 --> n12
  n11 --> n28
  n12 --> n28
  n13 --> n14
  n13 --> n15
  n13 --> n16
  n13 --> n17
  n13 --> n18
  n13 --> n19
  n13 --> n22
  n13 --> n28
  n14 --> n16
  n14 --> n17
  n14 --> n19
  n15 --> n16
  n15 --> n17
  n16 --> n22
  n17 --> n18
  n17 --> n28
  n18 --> n22
  n19 --> n28
  n2 --> n10
  n2 --> n21
  n2 --> n26
  n2 --> n5
  n2 --> n7
  n2 --> n8
  n2 --> n9
  n20 --> n22
  n20 --> n23
  n20 --> n24
  n20 --> n25
  n20 --> n27
  n20 --> n28
  n21 --> n22
  n21 --> n26
  n21 --> n27
  n21 --> n28
  n22 --> n28
  n23 --> n24
  n26 --> n27
  n4 --> n24
  n5 --> n26
  n7 --> n12
  n7 --> n22
  n7 --> n28
  n7 --> n9
  n8 --> n10
  n8 --> n11
  n8 --> n12
  n8 --> n22
  n8 --> n28
  n9 --> n12
  x0 --> n12
  x0 --> n19
  x0 --> n28
  x0 --> n9
  x1 --> n10
  x1 --> n11
  x1 --> n12
  x1 --> n28
  x1 --> n9
  x2 --> n19
  x3 --> n10
  x4 --> n9
  x5 --> n9
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
| `WeilPowerCompare.cP`<br/>def, line 81 | ℝ | m : ℕ | The strong Gaussian coefficient `1/(π²(m+1))`: the exponent's rate where `Re(w²) ≥ 0`. | — | `WeilPowerCompare.Eup`, `WeilPowerCompare.cE_le_cP`, `WeilPowerCompare.cP_pos`, `WeilPowerCompare.norm_S_le_gauss`, `WeilPowerCompare.rate`, `WeilPowerCompare.rate_neg_of_ge` |
| `WeilPowerCompare.cE`<br/>def, line 85 | ℝ | m : ℕ | The weak Gaussian coefficient `(m+2)/(π²(2m+3)²)`: the rate where `Re(w²) ≤ 0`, and the one the target's lower bound carries. | — | `WeilPowerCompare.Elow`, `WeilPowerCompare.Eup`, `WeilPowerCompare.S_real_ge_low`, `WeilPowerCompare.cE_le_cP`, `WeilPowerCompare.cE_pos`, `WeilPowerCompare.norm_S_le_gauss`, `WeilPowerCompare.rate`, `WeilPowerCompare.rate_eq_of_le`, `WeilPowerCompare.rate_neg_of_ge`, `WeilPowerCompare.rate_neg_of_le` |
| `WeilPowerCompare.cQ`<br/>def, line 88 | ℝ | m : ℕ | The quartic error coefficient `1/(π⁴(m+1)³)`. | — | `WeilPowerCompare.Elow`, `WeilPowerCompare.Eup`, `WeilPowerCompare.S_real_ge_low`, `WeilPowerCompare.cQ_pos`, `WeilPowerCompare.norm_S_le_gauss`, `WeilPowerCompare.qerr`, `WeilPowerCompare.qerr_pos` |
| `WeilPowerCompare.cP_pos`<br/>theorem, line 90 | 0 &lt; cP m | m : ℕ | — | `WeilPowerCompare.cP` | — |
| `WeilPowerCompare.cE_pos`<br/>theorem, line 95 | 0 &lt; cE m | m : ℕ | — | `WeilPowerCompare.cE` | `WeilPowerCompare.rate_neg_of_le` |
| `WeilPowerCompare.cQ_pos`<br/>theorem, line 101 | 0 &lt; cQ m | m : ℕ | — | `WeilPowerCompare.cQ` | `WeilPowerCompare.qerr_pos` |
| `WeilPowerCompare.cE_le_cP`<br/>theorem, line 107 | cE m ≤ cP m | m : ℕ | `(m+1)(m+2) ≤ (2m+3)²`, so the weak coefficient is at most the strong one. | `WeilPowerCompare.cE`, `WeilPowerCompare.cP` | — |
| `WeilPowerCompare.Eup`<br/>def, line 116 | ℝ | m : ℕ; w : ℂ | The upper exponent, both signs of `Re(w²)` in one expression: `max _ 0` picks the strong coefficient where `Re(w²) ≥ 0` and the weak one elsewhere. | `WeilPowerCompare.cE`, `WeilPowerCompare.cP`, `WeilPowerCompare.cQ` | `WeilPowerCompare.compare_le`, `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.exponent_eq`, `WeilPowerCompare.norm_S_le_gauss` |
| `WeilPowerCompare.Elow`<br/>def, line 120 | ℝ | m : ℕ; s : ℝ | The lower exponent at the target, on the real axis. | `WeilPowerCompare.cE`, `WeilPowerCompare.cQ` | `WeilPowerCompare.S_real_ge_low`, `WeilPowerCompare.S_real_pos`, `WeilPowerCompare.compare_le`, `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.exponent_eq` |
| `WeilPowerCompare.norm_S_le_gauss`<br/>theorem, line 123 | ‖S m w‖ ≤ 4 / (Real.pi * ((m : ℝ) + 1)) * ‖w‖ * Real.exp (Eup m w) | hne : QS m w ≠ 0; hsmall : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | The Gaussian upper bound, both signs in one exponent. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilPowerCompare.Eup`, `WeilPowerCompare.cE`, `WeilPowerCompare.cP`, `WeilPowerCompare.cQ`, `WeilPowerGauss.norm_S_le_gauss_neg`, `WeilPowerGauss.norm_S_le_gauss_pos` | `WeilPowerCompare.compare_le` |
| `WeilPowerCompare.S_real_ge_low`<br/>theorem, line 150 | 4 / (Real.pi * ((m : ℝ) + 1) * (2 * (m : ℝ) + 3)) * s * Real.exp (Elow m s) ≤ (S m (s : ℂ)).re | hs : 0 &lt; s; hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | The Gaussian lower bound at the target, in the `Elow` form. | `WeilOddPower.S`, `WeilPowerCompare.Elow`, `WeilPowerCompare.cE`, `WeilPowerCompare.cQ`, `WeilPowerGauss.S_real_ge_gauss` | `WeilPowerCompare.S_real_pos`, `WeilPowerCompare.compare_le` |
| `WeilPowerCompare.S_real_pos`<br/>theorem, line 166 | 0 &lt; (S m (s : ℂ)).re | hs : 0 &lt; s; hsmall : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | The target's transform is positive on the real axis inside the regime. | `WeilOddPower.S`, `WeilPowerCompare.Elow`, `WeilPowerCompare.S_real_ge_low` | `WeilPowerCompare.compare_suppressed` |
| `WeilPowerCompare.compare_le`<br/>theorem, line 179 | ‖S m w‖ ≤ (2 * (m : ℝ) + 3) * (‖w‖ / s) * Real.exp (Eup m w - Elow m s) * (S m (s : ℂ)).re | hne : QS m w ≠ 0; hw : ‖w‖ ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hs : 0 &lt; s; hs2 : s ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | The comparison at another off-line zero. The transform at any point of the regime is at most `2m+3` times `‖w‖/s` times the exponential of the exponent difference, times the target's transform. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilPowerCompare.Elow`, `WeilPowerCompare.Eup`, `WeilPowerCompare.S_real_ge_low`, `WeilPowerCompare.norm_S_le_gauss` | `WeilPowerCompare.compare_suppressed` |
| `WeilPowerCompare.wOf`<br/>def, line 206 | ℂ | ε Δ h : ℝ | The point the window reads at a zero of real-part offset `ε` and height offset `Δ`: `w = (ε + iΔ)h`. | — | `WeilPowerCompare.QS_ne_zero_wOf`, `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.exponent_eq`, `WeilPowerCompare.norm_wOf_pow4`, `WeilPowerCompare.norm_wOf_sq`, `WeilPowerCompare.wOf_im`, `WeilPowerCompare.wOf_re`, `WeilPowerCompare.wOf_sq_re` |
| `WeilPowerCompare.wOf_re`<br/>theorem, line 208 | (wOf ε Δ h).re = ε * h | ε Δ h : ℝ | — | `WeilPowerCompare.wOf` | `WeilPowerCompare.QS_ne_zero_wOf`, `WeilPowerCompare.norm_wOf_sq`, `WeilPowerCompare.wOf_sq_re` |
| `WeilPowerCompare.wOf_im`<br/>theorem, line 211 | (wOf ε Δ h).im = Δ * h | ε Δ h : ℝ | — | `WeilPowerCompare.wOf` | `WeilPowerCompare.norm_wOf_sq`, `WeilPowerCompare.wOf_sq_re` |
| `WeilPowerCompare.wOf_sq_re`<br/>theorem, line 214 | ((wOf ε Δ h) ^ 2).re = (ε ^ 2 - Δ ^ 2) * h ^ 2 | ε Δ h : ℝ | — | `WeilPowerCompare.wOf`, `WeilPowerCompare.wOf_im`, `WeilPowerCompare.wOf_re` | `WeilPowerCompare.exponent_eq` |
| `WeilPowerCompare.norm_wOf_sq`<br/>theorem, line 218 | ‖wOf ε Δ h‖ ^ 2 = (ε ^ 2 + Δ ^ 2) * h ^ 2 | ε Δ h : ℝ | — | `WeilPowerCompare.wOf`, `WeilPowerCompare.wOf_im`, `WeilPowerCompare.wOf_re` | `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.norm_wOf_pow4` |
| `WeilPowerCompare.norm_wOf_pow4`<br/>theorem, line 222 | ‖wOf ε Δ h‖ ^ 4 = ((ε ^ 2 + Δ ^ 2) * h ^ 2) ^ 2 | ε Δ h : ℝ | — | `WeilPowerCompare.norm_wOf_sq`, `WeilPowerCompare.wOf` | `WeilPowerCompare.exponent_eq` |
| `WeilPowerCompare.QS_ne_zero_wOf`<br/>theorem, line 225 | QS m (wOf ε Δ h) ≠ 0 | hε : ε ≠ 0; hh : h ≠ 0 | — | `WeilOddPower.QS`, `WeilPowerBounds.QS_ne_zero`, `WeilPowerCompare.wOf`, `WeilPowerCompare.wOf_re` | `WeilPowerCompare.compare_suppressed` |
| `WeilPowerCompare.rate`<br/>def, line 232 | ℝ | m : ℕ; ε' Δ ε : ℝ | The quadratic rate of the exponent difference, per unit `h²`. | `WeilPowerCompare.cE`, `WeilPowerCompare.cP` | `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.exponent_eq`, `WeilPowerCompare.rate_eq_of_le`, `WeilPowerCompare.rate_neg_of_ge`, `WeilPowerCompare.rate_neg_of_le`, `WeilPowerCompare.rate_neg_of_qerr` |
| `WeilPowerCompare.qerr`<br/>def, line 236 | ℝ | m : ℕ; ε' Δ ε : ℝ | The quartic error of the exponent difference, per unit `h⁴`. | `WeilPowerCompare.cQ` | `WeilPowerCompare.compare_suppressed`, `WeilPowerCompare.exponent_eq`, `WeilPowerCompare.qerr_pos`, `WeilPowerCompare.rate_neg_of_qerr` |
| `WeilPowerCompare.exponent_eq`<br/>theorem, line 240 | Eup m (wOf ε' Δ h) - Elow m (ε * h) = rate m ε' Δ ε * h ^ 2 + qerr m ε' Δ ε * h ^ 4 | m : ℕ; ε' Δ ε h : ℝ | The exponent difference in the worksheet's variables, with no sign hypothesis: a quadratic rate against a quartic error. | `WeilPowerCompare.Elow`, `WeilPowerCompare.Eup`, `WeilPowerCompare.norm_wOf_pow4`, `WeilPowerCompare.qerr`, `WeilPowerCompare.rate`, `WeilPowerCompare.wOf`, `WeilPowerCompare.wOf_sq_re` | `WeilPowerCompare.compare_suppressed` |
| `WeilPowerCompare.rate_eq_of_le`<br/>theorem, line 253 | rate m ε' Δ ε = -(cE m * (Δ ^ 2 + ε ^ 2 - ε' ^ 2)) | m : ℕ; hsq : ε' ^ 2 ≤ Δ ^ 2 | At `Δ² ≥ ε'²` the rate is `−cE·(Δ² + ε² − ε'²)`. | `WeilPowerCompare.cE`, `WeilPowerCompare.rate` | `WeilPowerCompare.rate_neg_of_le` |
| `WeilPowerCompare.rate_neg_of_le`<br/>theorem, line 261 | rate m ε' Δ ε &lt; 0 | m : ℕ; hε : 0 &lt; ε; hsq : ε' ^ 2 ≤ Δ ^ 2 | A zero above the target in height is suppressed at every real part. `Δ² ≥ ε'²` and `0 &lt; ε` make the rate negative with no condition on `ε'`. | `WeilPowerCompare.cE`, `WeilPowerCompare.cE_pos`, `WeilPowerCompare.rate`, `WeilPowerCompare.rate_eq_of_le` | — |
| `WeilPowerCompare.rate_neg_of_ge`<br/>theorem, line 270 | rate m ε' Δ ε &lt; 0 | m : ℕ; hsq : Δ ^ 2 ≤ ε' ^ 2; hlt : cP m * (ε' ^ 2 - Δ ^ 2) &lt; cE m * ε ^ 2 | A zero inside the target's height is suppressed when its real part does not exceed the target's by the constant `cE/cP`. | `WeilPowerCompare.cE`, `WeilPowerCompare.cP`, `WeilPowerCompare.rate` | — |
| `WeilPowerCompare.qerr_pos`<br/>theorem, line 277 | 0 &lt; qerr m ε' Δ ε | m : ℕ; hε : 0 &lt; ε | The quartic error is positive at any target with `0 &lt; ε`. | `WeilPowerCompare.cQ`, `WeilPowerCompare.cQ_pos`, `WeilPowerCompare.qerr` | `WeilPowerCompare.rate_neg_of_qerr` |
| `WeilPowerCompare.rate_neg_of_qerr`<br/>theorem, line 284 | rate m ε' Δ ε &lt; 0 | hε : 0 &lt; ε; hh : 0 &lt; h; hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2 | The range condition on `h` already forces the rate negative. | `WeilPowerCompare.qerr`, `WeilPowerCompare.qerr_pos`, `WeilPowerCompare.rate` | — |
| `WeilPowerCompare.compare_suppressed`<br/>theorem, line 294 | ‖S m (wOf ε' Δ h)‖ ≤ (2 * (m : ℝ) + 3) * (‖wOf ε' Δ h‖ / (ε * h)) * Real.exp (rate m ε' Δ ε * h ^ 2 / 2) * (S m ((ε * h : ℝ) : ℂ)).re | hε : 0 &lt; ε; hh : 0 &lt; h; hε' : ε' ≠ 0; hq : qerr m ε' Δ ε * h ^ 2 ≤ -rate m ε' Δ ε / 2; hw : (ε' ^ 2 + Δ ^ 2) * h ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2; hs : (ε * h) ^ 2 ≤ Real.pi ^ 2 * ((m : ℝ) + 2) ^ 2 / 2 | Suppression at another off-line zero. For `h` in the range where the quartic error is at most half the rate — which by `rate_neg_of_qerr` already makes the rate negative — the transform at the other zero is an exponentially small multiple of the target's. | `WeilOddPower.QS`, `WeilOddPower.S`, `WeilPowerCompare.Elow`, `WeilPowerCompare.Eup`, `WeilPowerCompare.QS_ne_zero_wOf`, `WeilPowerCompare.S_real_pos`, `WeilPowerCompare.compare_le`, `WeilPowerCompare.exponent_eq`, `WeilPowerCompare.norm_wOf_sq`, `WeilPowerCompare.qerr`, `WeilPowerCompare.rate`, `WeilPowerCompare.wOf` | — |
