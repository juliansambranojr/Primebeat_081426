# `lean_stage3/Stage3/LandauTail.lean`

**What it does** (its own header): LandauTail — the kernel off the window: the integral of `(log y)^k·y^(−a−1)` over `(1, Y]` and over `(Z, ∞)`, each bounded by a shift of the exponent. Block 4b of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauKernel`](../lean_stage3/LandauKernel.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauPrimeSide`](../lean_stage3/LandauPrimeSide.md).

```mermaid
flowchart LR
  n0["kernel_nonneg<br/>⊢ 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))] fun y : ℝ =＞ Real.log y ^ k * y ^ …"]:::thm
  n1["lower_tail_le<br/>⊢ ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1) ≤ Y ^ b * (k.facto…"]:::thm
  n2["upper_tail_le<br/>⊢ ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1) ≤ Z ^ (-b) * (k.factorial …"]:::thm
  x0(["LandauKernel · log_pow_integrable"]):::ext
  x1(["LandauKernel · log_pow_integral"]):::ext
  x2(["LandauPrimeSide · Ik_le"]):::ext
  n0 --> n1
  n0 --> n2
  n1 --> x2
  n2 --> x2
  x0 --> n1
  x0 --> n2
  x1 --> n1
  x1 --> n2
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
| `LandauTail.kernel_nonneg`<br/>theorem, line 30 | 0 ≤ᵐ[volume.restrict (Ioi (1 : ℝ))] fun y : ℝ =&gt; Real.log y ^ k * y ^ (-a - 1) | a : ℝ; k : ℕ | — | — | `LandauTail.lower_tail_le`, `LandauTail.upper_tail_le` |
| `LandauTail.lower_tail_le`<br/>theorem, line 36 | ∫ y in Ioc (1 : ℝ) Y, Real.log y ^ k * y ^ (-a - 1) ≤ Y ^ b * (k.factorial / (a + b) ^ (k + 1)) | ha : 0 &lt; a; hb : 0 &lt; b; k : ℕ; hY : 1 ≤ Y | — | `LandauKernel.log_pow_integrable`, `LandauKernel.log_pow_integral`, `LandauTail.kernel_nonneg` | `LandauPrimeSide.Ik_le` |
| `LandauTail.upper_tail_le`<br/>theorem, line 71 | ∫ y in Ioi Z, Real.log y ^ k * y ^ (-a - 1) ≤ Z ^ (-b) * (k.factorial / (a - b) ^ (k + 1)) | hb : 0 &lt; b; hba : b &lt; a; k : ℕ; hZ : 1 ≤ Z | — | `LandauKernel.log_pow_integrable`, `LandauKernel.log_pow_integral`, `LandauTail.kernel_nonneg` | `LandauPrimeSide.Ik_le` |
