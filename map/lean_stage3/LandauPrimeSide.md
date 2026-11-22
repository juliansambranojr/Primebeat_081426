# `lean_stage3/Stage3/LandauPrimeSide.lean`

**What it does** (its own header): LandauPrimeSide — the primes' reading of the Taylor coefficients of `Phi`, bounded from above by a window bound on `G`. Block 7a of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauTail`](../lean_stage3/LandauTail.md), [`LandauTaylor`](../lean_stage3/LandauTaylor.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauZeroSide`](../lean_stage3/LandauZeroSide.md).

```mermaid
flowchart LR
  n0["Ik<br/>(def)"]:::dfn
  n1["Ik_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ LandauWindow.G y * Real.log y ^ k * y ^ (-σ…"]:::thm
  n2["iteratedDeriv_Phi_eq_Ik<br/>⊢ iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) :…"]:::thm
  n3["Ik_le<br/>⊢ Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1)) + 8 * (Y ^ b * (k.facto…"]:::thm
  x0(["LandauChebyshev · G_le"]):::ext
  x1(["LandauCriterion · contradiction"]):::ext
  x2(["LandauKernel · log_pow_integrable"]):::ext
  x3(["LandauKernel · log_pow_integral"]):::ext
  x4(["LandauMellinG · Phi"]):::ext
  x5(["LandauTail · lower_tail_le"]):::ext
  x6(["LandauTail · upper_tail_le"]):::ext
  x7(["LandauTaylor · iteratedDeriv_Phi"]):::ext
  x8(["LandauTaylor · mellinLog_integrable"]):::ext
  x9(["LandauTaylor · mellinLog_real"]):::ext
  x10(["LandauWindow · G"]):::ext
  x11(["LandauZeroSide · zero_side"]):::ext
  n0 --> n2
  n0 --> n3
  n0 --> x1
  n0 --> x11
  n1 --> n3
  n2 --> x11
  n3 --> x1
  x0 --> n3
  x10 --> n0
  x10 --> n1
  x10 --> n3
  x2 --> n3
  x3 --> n3
  x4 --> n2
  x5 --> n3
  x6 --> n3
  x7 --> n2
  x8 --> n1
  x9 --> n2
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
| `LandauPrimeSide.Ik`<br/>def, line 39 | ℝ | σ : ℝ; k : ℕ | `∫₁^∞ G(y)·(log y)^k·y^(−σ−1) dy`. | `LandauWindow.G` | `LandauCriterion.contradiction`, `LandauPrimeSide.Ik_le`, `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`, `LandauZeroSide.zero_side` |
| `LandauPrimeSide.Ik_integrable`<br/>theorem, line 42 | IntegrableOn (fun y : ℝ =&gt; LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1)) (Ioi 1) | hσ : 1 &lt; σ; k : ℕ | — | `LandauTaylor.mellinLog_integrable`, `LandauWindow.G` | `LandauPrimeSide.Ik_le` |
| `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik`<br/>theorem, line 60 | iteratedDeriv k LandauMellinG.Phi (σ : ℂ) = (-1) ^ k * ((Ik σ k : ℝ) : ℂ) | hσ : 1 &lt; σ; k : ℕ | — | `LandauMellinG.Phi`, `LandauPrimeSide.Ik`, `LandauTaylor.iteratedDeriv_Phi`, `LandauTaylor.mellinLog_real` | `LandauZeroSide.zero_side` |
| `LandauPrimeSide.Ik_le`<br/>theorem, line 65 | Ik σ k ≤ C * (k.factorial / (σ - θ) ^ (k + 1)) + 8 * (Y ^ b * (k.factorial / (σ - 1 + b) ^ (k + 1))) + 8 * ((Y ^ (1 + δ)) ^ (-b') * (k.factorial / (σ - 1 - b') ^ (k + 1))) | hσ : 1 &lt; σ; hθ : θ &lt; σ; hC : 0 ≤ C; hY : 1 ≤ Y; hδ : 0 ≤ δ; hwin : ∀ y ∈ Icc Y (Y ^ (1 + δ)), LandauWindow.G y ≤ C * y ^ θ; hb : 0 &lt; b; hb' : 0 &lt; b'; hb'a : b' &lt; σ - 1; k : ℕ | — | `LandauChebyshev.G_le`, `LandauKernel.log_pow_integrable`, `LandauKernel.log_pow_integral`, `LandauPrimeSide.Ik`, `LandauPrimeSide.Ik_integrable`, `LandauTail.lower_tail_le`, `LandauTail.upper_tail_le`, `LandauWindow.G` | `LandauCriterion.contradiction` |
