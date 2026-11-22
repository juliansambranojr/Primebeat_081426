# `lean_stage3/Stage3/LandauTaylor.lean`

**What it does** (its own header): LandauTaylor — the derivatives of `Phi` on `Re s > 1`, from the primes: iteratedDeriv k Phi s = ∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy.

**Imports:** [`LandauChebyshev`](../lean_stage3/LandauChebyshev.md), [`LandauKernel`](../lean_stage3/LandauKernel.md), [`LandauMellinG`](../lean_stage3/LandauMellinG.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauPrimeSide`](../lean_stage3/LandauPrimeSide.md).

```mermaid
flowchart LR
  n0["mellinLog<br/>(def)"]:::dfn
  n1["integrand_norm_le<br/>⊢ ‖(LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)…"]:::thm
  n2["bound_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.l…"]:::thm
  n3["mellinLog_integrable<br/>⊢ IntegrableOn (fun y : ℝ =＞ (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)…"]:::thm
  n4["mellinLog_hasDerivAt<br/>⊢ HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s"]:::thm
  n5["iteratedDeriv_Phi<br/>⊢ iteratedDeriv k LandauMellinG.Phi s = mellinLog k s"]:::thm
  n6["mellinLog_real<br/>⊢ mellinLog k (σ : ℂ) = (-1) ^ k * ((∫ y in Ioi (1 : ℝ), LandauWindow.G …"]:::thm
  x0(["LandauChebyshev · abs_G_le_log"]):::ext
  x1(["LandauKernel · log_pow_integrable"]):::ext
  x2(["LandauMellinG · G_mellin_integrable"]):::ext
  x3(["LandauMellinG · Phi"]):::ext
  x4(["LandauMellinG · mellin_G"]):::ext
  x5(["LandauPrimeSide · Ik_integrable"]):::ext
  x6(["LandauPrimeSide · iteratedDeriv_Phi_eq_Ik"]):::ext
  x7(["LandauWindow · G"]):::ext
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n1 --> n3
  n1 --> n4
  n2 --> n3
  n2 --> n4
  n3 --> n4
  n3 --> x5
  n4 --> n5
  n5 --> x6
  n6 --> x6
  x0 --> n1
  x1 --> n2
  x2 --> n3
  x3 --> n5
  x4 --> n5
  x7 --> n0
  x7 --> n1
  x7 --> n3
  x7 --> n4
  x7 --> n6
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
| `LandauTaylor.mellinLog`<br/>def, line 40 | ℂ | k : ℕ; s : ℂ | `∫₁^∞ G(y)·(−log y)^k·y^(−s−1) dy`. | `LandauWindow.G` | `LandauTaylor.iteratedDeriv_Phi`, `LandauTaylor.mellinLog_hasDerivAt`, `LandauTaylor.mellinLog_real` |
| `LandauTaylor.integrand_norm_le`<br/>theorem, line 45 | ‖(LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)‖ ≤ 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1)) | has : 1 + a ≤ s.re; k : ℕ; hy : 1 &lt; y | The domination: for `Re s ≥ 1 + a` the integrand is at most this. | `LandauChebyshev.abs_G_le_log`, `LandauWindow.G` | `LandauTaylor.mellinLog_hasDerivAt`, `LandauTaylor.mellinLog_integrable` |
| `LandauTaylor.bound_integrable`<br/>theorem, line 70 | IntegrableOn (fun y : ℝ =&gt; 8 * (Real.log y ^ k * y ^ (-a - 1) + Real.log y ^ (k + 1) * y ^ (-a - 1))) (Ioi 1) | ha : 0 &lt; a; k : ℕ | — | `LandauKernel.log_pow_integrable` | `LandauTaylor.mellinLog_hasDerivAt`, `LandauTaylor.mellinLog_integrable` |
| `LandauTaylor.mellinLog_integrable`<br/>theorem, line 76 | IntegrableOn (fun y : ℝ =&gt; (LandauWindow.G y : ℂ) * (-(Real.log y : ℂ)) ^ k * (y : ℂ) ^ (-s - 1)) (Ioi 1) | hs : 1 &lt; s.re; k : ℕ | — | `LandauMellinG.G_mellin_integrable`, `LandauTaylor.bound_integrable`, `LandauTaylor.integrand_norm_le`, `LandauWindow.G` | `LandauPrimeSide.Ik_integrable`, `LandauTaylor.mellinLog_hasDerivAt` |
| `LandauTaylor.mellinLog_hasDerivAt`<br/>theorem, line 98 | HasDerivAt (mellinLog k) (mellinLog (k + 1) s) s | hs : 1 &lt; s.re; k : ℕ | — | `LandauTaylor.bound_integrable`, `LandauTaylor.integrand_norm_le`, `LandauTaylor.mellinLog`, `LandauTaylor.mellinLog_integrable`, `LandauWindow.G` | `LandauTaylor.iteratedDeriv_Phi` |
| `LandauTaylor.iteratedDeriv_Phi`<br/>theorem, line 140 | iteratedDeriv k LandauMellinG.Phi s = mellinLog k s | k : ℕ; hs : 1 &lt; s.re | — | `LandauMellinG.Phi`, `LandauMellinG.mellin_G`, `LandauTaylor.mellinLog`, `LandauTaylor.mellinLog_hasDerivAt` | `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik` |
| `LandauTaylor.mellinLog_real`<br/>theorem, line 155 | mellinLog k (σ : ℂ) = (-1) ^ k * ((∫ y in Ioi (1 : ℝ), LandauWindow.G y * Real.log y ^ k * y ^ (-σ - 1) : ℝ) : ℂ) | σ : ℝ; k : ℕ | — | `LandauTaylor.mellinLog`, `LandauWindow.G` | `LandauPrimeSide.iteratedDeriv_Phi_eq_Ik` |
