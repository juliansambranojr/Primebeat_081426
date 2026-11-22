# `lean_stage3/Stage3/LandauKernel.lean`

**What it does** (its own header): LandauKernel — the kernel's integral: for `a > 0`, `∫₁^∞ (log y)^k · y^(−a−1) dy = k!/a^(k+1)`. Block 4a of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`JointDialGate`](../lean_stage3/JointDialGate.md), [`LandauTail`](../lean_stage3/LandauTail.md), [`LandauTaylor`](../lean_stage3/LandauTaylor.md).

```mermaid
flowchart LR
  n0["log_pow_le<br/>⊢ Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n"]:::thm
  n1["kernel_le<br/>⊢ Real.log y ^ n * y ^ (-a - 1) ≤ y ^ (-(a / 2) - 1) / (a / (2 * (n + 1)…"]:::thm
  n2["log_pow_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ Real.log y ^ n * y ^ (-a - 1)) (Ioi 1)"]:::thm
  n3["tendsto_log_pow_mul<br/>⊢ Tendsto (fun y : ℝ =＞ Real.log y ^ n * y ^ (-a)) atTop (𝓝 0)"]:::thm
  n4["hasDerivAt_prim<br/>⊢ HasDerivAt (fun t : ℝ =＞ -(Real.log t ^ (k + 1) * t ^ (-a)) / a) (Real…"]:::thm
  n5["log_pow_integral<br/>⊢ ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ …"]:::thm
  x0(["JointDialGate · log_absorbed"]):::ext
  x1(["LandauPrimeSide · Ik_le"]):::ext
  x2(["LandauTail · lower_tail_le"]):::ext
  x3(["LandauTail · upper_tail_le"]):::ext
  x4(["LandauTaylor · bound_integrable"]):::ext
  n0 --> n1
  n0 --> n3
  n0 --> x0
  n1 --> n2
  n2 --> n5
  n2 --> x1
  n2 --> x2
  n2 --> x3
  n2 --> x4
  n3 --> n5
  n4 --> n5
  n5 --> x1
  n5 --> x2
  n5 --> x3
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
| `LandauKernel.log_pow_le`<br/>theorem, line 33 | Real.log y ^ n ≤ y ^ (a / 2) / (a / (2 * (n + 1))) ^ n | ha : 0 &lt; a; n : ℕ; hy : 1 ≤ y | — | — | `JointDialGate.log_absorbed`, `LandauKernel.kernel_le`, `LandauKernel.tendsto_log_pow_mul` |
| `LandauKernel.kernel_le`<br/>theorem, line 56 | Real.log y ^ n * y ^ (-a - 1) ≤ y ^ (-(a / 2) - 1) / (a / (2 * (n + 1))) ^ n | ha : 0 &lt; a; n : ℕ; hy : 1 ≤ y | The kernel is at most a power of `y` with exponent below `−1`. | `LandauKernel.log_pow_le` | `LandauKernel.log_pow_integrable` |
| `LandauKernel.log_pow_integrable`<br/>theorem, line 66 | IntegrableOn (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a - 1)) (Ioi 1) | ha : 0 &lt; a; n : ℕ | — | `LandauKernel.kernel_le` | `LandauKernel.log_pow_integral`, `LandauPrimeSide.Ik_le`, `LandauTail.lower_tail_le`, `LandauTail.upper_tail_le`, `LandauTaylor.bound_integrable` |
| `LandauKernel.tendsto_log_pow_mul`<br/>theorem, line 84 | Tendsto (fun y : ℝ =&gt; Real.log y ^ n * y ^ (-a)) atTop (𝓝 0) | ha : 0 &lt; a; n : ℕ | — | `LandauKernel.log_pow_le` | `LandauKernel.log_pow_integral` |
| `LandauKernel.hasDerivAt_prim`<br/>theorem, line 102 | HasDerivAt (fun t : ℝ =&gt; -(Real.log t ^ (k + 1) * t ^ (-a)) / a) (Real.log y ^ (k + 1) * y ^ (-a - 1) - ((k : ℝ) + 1) / a * (Real.log y ^ k * y ^ (-a - 1))) y | ha : 0 &lt; a; k : ℕ; hy : 0 &lt; y | — | — | `LandauKernel.log_pow_integral` |
| `LandauKernel.log_pow_integral`<br/>theorem, line 118 | ∫ y in Ioi (1 : ℝ), Real.log y ^ k * y ^ (-a - 1) = k.factorial / a ^ (k + 1) | ha : 0 &lt; a; k : ℕ | — | `LandauKernel.hasDerivAt_prim`, `LandauKernel.log_pow_integrable`, `LandauKernel.tendsto_log_pow_mul` | `LandauPrimeSide.Ik_le`, `LandauTail.lower_tail_le`, `LandauTail.upper_tail_le` |
