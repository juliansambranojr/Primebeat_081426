# `lean_stage3/Stage3/LandauMellin.lean`

**What it does** (its own header): LandauMellin — the Mellin transform of the ramp sum on `Re s > 1`. Block 2 of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** [`LandauWindow`](../lean_stage3/LandauWindow.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauMellinG`](../lean_stage3/LandauMellinG.md).

```mermaid
flowchart LR
  n0["rampK<br/>(def)"]:::dfn
  n1["rampK_eq_indicator<br/>⊢ rampK s n y = (Ioi (n : ℝ)).indicator (fun t : ℝ =＞ (1 / (n : ℂ)) * (t…"]:::thm
  n2["two_powers_integrableOn<br/>⊢ IntegrableOn (fun t : ℝ =＞ (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ …"]:::thm
  n3["rampK_integrable<br/>⊢ IntegrableOn (rampK s n) (Ioi 1)"]:::thm
  n4["rampK_integral<br/>⊢ ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1))"]:::thm
  n5["rampK_integral_norm<br/>⊢ ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re …"]:::thm
  n6["rampSum_eq_tsum<br/>⊢ LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0"]:::thm
  n7["mellin_rampSum<br/>⊢ ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) …"]:::thm
  x0(["LandauMellinG · mellin_G"]):::ext
  x1(["LandauMellinG · rampSum_mellin_integrable"]):::ext
  x2(["LandauWindow · rampSum"]):::ext
  n0 --> n1
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> n7
  n1 --> n3
  n1 --> n4
  n2 --> n3
  n3 --> n7
  n4 --> n5
  n4 --> n7
  n5 --> n7
  n6 --> n7
  n7 --> x0
  n7 --> x1
  x2 --> n6
  x2 --> n7
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
| `LandauMellin.rampK`<br/>def, line 43 | ℂ | s : ℂ; n : ℕ; y : ℝ | The ramp kernel of one `n`: `max(y/n − 1, 0)·y^(−s−1)`. | — | `LandauMellin.mellin_rampSum`, `LandauMellin.rampK_eq_indicator`, `LandauMellin.rampK_integrable`, `LandauMellin.rampK_integral`, `LandauMellin.rampK_integral_norm` |
| `LandauMellin.rampK_eq_indicator`<br/>theorem, line 47 | rampK s n y = (Ioi (n : ℝ)).indicator (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y | s : ℂ; hn : 1 ≤ n; hy : 1 &lt; y | On `(1, ∞)` the kernel is the indicator of `(n, ∞)` times two powers. | `LandauMellin.rampK` | `LandauMellin.rampK_integrable`, `LandauMellin.rampK_integral` |
| `LandauMellin.two_powers_integrableOn`<br/>theorem, line 68 | IntegrableOn (fun t : ℝ =&gt; (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) | hs : 1 &lt; s.re; hn : 1 ≤ n | — | — | `LandauMellin.rampK_integrable` |
| `LandauMellin.rampK_integrable`<br/>theorem, line 78 | IntegrableOn (rampK s n) (Ioi 1) | hs : 1 &lt; s.re; hn : 1 ≤ n | — | `LandauMellin.rampK`, `LandauMellin.rampK_eq_indicator`, `LandauMellin.two_powers_integrableOn` | `LandauMellin.mellin_rampSum` |
| `LandauMellin.rampK_integral`<br/>theorem, line 85 | ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) | hs : 1 &lt; s.re; hn : 1 ≤ n | — | `LandauMellin.rampK`, `LandauMellin.rampK_eq_indicator` | `LandauMellin.mellin_rampSum`, `LandauMellin.rampK_integral_norm` |
| `LandauMellin.rampK_integral_norm`<br/>theorem, line 122 | ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) | hs : 1 &lt; s.re; hn : 1 ≤ n | — | `LandauMellin.rampK`, `LandauMellin.rampK_integral` | `LandauMellin.mellin_rampSum` |
| `LandauMellin.rampSum_eq_tsum`<br/>theorem, line 148 | LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0 | y : ℝ | — | `LandauWindow.rampSum` | `LandauMellin.mellin_rampSum` |
| `LandauMellin.mellin_rampSum`<br/>theorem, line 164 | ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) | hs : 1 &lt; s.re | — | `LandauMellin.rampK`, `LandauMellin.rampK_integrable`, `LandauMellin.rampK_integral`, `LandauMellin.rampK_integral_norm`, `LandauMellin.rampSum_eq_tsum`, `LandauWindow.rampSum` | `LandauMellinG.mellin_G`, `LandauMellinG.rampSum_mellin_integrable` |
