# What `ApproxBounds.log_norm_Gammaℝ_approx` rests on

[`ApproxBounds.log_norm_Gammaℝ_approx`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_norm_Gamma-_approx) in `lean_stage3/Stage3/ApproxBounds.lean`, line 485.

**Proves**

```lean
|Real.log ‖Gammaℝ w‖ - gRModel w| ≤ gErr (w.re / 2)
```

**Needs** (its hypotheses)

  - `` hw : 0 < w.re ``

Behind it: 20 theorems and 7 definitions in 1 file. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ApproxBounds</b><br/>log_norm_Gammaℝ_approx"]:::end_
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`ApproxBounds`](../lean_stage3/ApproxBounds.md) — 27

- [`ApproxBounds.fY`](../lean_stage3/ApproxBounds.md#ApproxBounds-fY) — *def*
- [`ApproxBounds.LY`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY) — *def*
- [`ApproxBounds.LY_hasDerivAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_hasDerivAt) — `` HasDerivAt (LY Y) (-2 * fY Y u) u ``
- [`ApproxBounds.fY_anti`](../lean_stage3/ApproxBounds.md#ApproxBounds-fY_anti) — `` fY Y b ≤ fY Y a ``
- [`ApproxBounds.fY_le_inv`](../lean_stage3/ApproxBounds.md#ApproxBounds-fY_le_inv) — `` fY Y u ≤ 1 / u ``
- [`ApproxBounds.LY_nonneg`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_nonneg) — `` 0 ≤ LY Y u ``
- [`ApproxBounds.LY_step`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_step) — `` 2 * (b - a) * fY Y b ≤ LY Y a - LY Y b ∧ LY Y a - LY Y b ≤ 2 * (b - a) * fY Y a ``
- [`ApproxBounds.sum_fY_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-sum_fY_le) — `` ∑ j ∈ Finset.range (n + 1), fY Y (x + j) ≤ fY Y x + LY Y x / 2 ``
- [`ApproxBounds.sum_fY_ge`](../lean_stage3/ApproxBounds.md#ApproxBounds-sum_fY_ge) — `` LY Y x / 2 - LY Y (x + ((n + 1 : ℕ) : ℝ)) / 2 ≤ ∑ j ∈ Finset.range (n + 1), fY Y (x + j) ``
- [`ApproxBounds.log_norm_add_I`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_norm_add_I) — `` Real.log ‖(a : ℂ) + Y * I‖ = Real.log a + LY Y a / 2 ``
- [`ApproxBounds.norm_GammaSeq`](../lean_stage3/ApproxBounds.md#ApproxBounds-norm_GammaSeq) — `` ‖GammaSeq s n‖ = ‖(n : ℂ) ^ s‖ * (n.factorial : ℝ) / ∏ j ∈ Finset.range (n + 1), ‖s + j‖ ``
- [`ApproxBounds.log_GammaSeq_sub`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_GammaSeq_sub) — `` Real.log ‖GammaSeq ((x : ℂ) + Y * I) n‖ - Real.log ‖GammaSeq (x : ℂ) n‖ = -(1 / 2) * ∑ j ∈ Finset.range (n + 1), LY Y (x + j) ``
- [`ApproxBounds.lg`](../lean_stage3/ApproxBounds.md#ApproxBounds-lg) — *def*
- [`ApproxBounds.tendsto_log_GammaSeq`](../lean_stage3/ApproxBounds.md#ApproxBounds-tendsto_log_GammaSeq) — `` Tendsto (fun n : ℕ => Real.log ‖GammaSeq ((x : ℂ) + Y * I) n‖ - Real.log ‖GammaSeq (x : ℂ) n‖) atTop (𝓝 (lg x Y)) ``
- [`ApproxBounds.LY_tendsto`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_tendsto) — `` Tendsto (fun n : ℕ => LY Y (x + ((n + 1 : ℕ) : ℝ))) atTop (𝓝 0) ``
- [`ApproxBounds.gamma_shift`](../lean_stage3/ApproxBounds.md#ApproxBounds-gamma_shift) — `` (x₂ - x₁) * (LY Y x₂ / 2) ≤ lg x₂ Y - lg x₁ Y ∧ lg x₂ Y - lg x₁ Y ≤ (x₂ - x₁) * (fY Y x₁ + LY Y x₁ / 2) ``
- [`ApproxBounds.lY`](../lean_stage3/ApproxBounds.md#ApproxBounds-lY) — *def*
- [`ApproxBounds.LY_eq`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_eq) — `` LY Y x = Real.log (x ^ 2 + Y ^ 2) - 2 * Real.log x ``
- [`ApproxBounds.LY_half_sub`](../lean_stage3/ApproxBounds.md#ApproxBounds-LY_half_sub) — `` |LY Y x / 2 - lY Y| ≤ |Real.log x| ``
- [`ApproxBounds.gamma_rel`](../lean_stage3/ApproxBounds.md#ApproxBounds-gamma_rel) — `` |lg x₂ Y - lg x₁ Y - (x₂ - x₁) * lY Y| ≤ (x₂ - x₁) * (1 / x₁ + |Real.log x₁| + |Real.log x₂|) ``
- [`ApproxBounds.gamma_half_norm_sq`](../lean_stage3/ApproxBounds.md#ApproxBounds-gamma_half_norm_sq) — `` ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ ^ 2 = Real.pi / Real.cosh (Real.pi * Y) ``
- [`ApproxBounds.log_cosh_bounds`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_cosh_bounds) — `` |x| - Real.log 2 ≤ Real.log (Real.cosh x) ∧ Real.log (Real.cosh x) ≤ |x| ``
- [`ApproxBounds.log_gamma_half`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_gamma_half) — `` |Real.log ‖Complex.Gamma (((1 / 2 : ℝ) : ℂ) + Y * I)‖ - (Real.log Real.pi - Real.pi * |Y|) / 2| ≤ Real.log 2 / 2 ``
- [`ApproxBounds.gModel`](../lean_stage3/ApproxBounds.md#ApproxBounds-gModel) — *def*
- ★ [`ApproxBounds.gErr`](../lean_stage3/ApproxBounds.md#ApproxBounds-gErr) — *def*
- ★ [`ApproxBounds.log_norm_Gamma_approx`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_norm_Gamma_approx) — `` |Real.log ‖Complex.Gamma z‖ - gModel z.re z.im| ≤ gErr z.re ``
- ★ [`ApproxBounds.gRModel`](../lean_stage3/ApproxBounds.md#ApproxBounds-gRModel) — *def*

