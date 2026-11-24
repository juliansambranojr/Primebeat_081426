# What `WindowsOfRH.const_eq_zero` rests on

[`WindowsOfRH.const_eq_zero`](../lean_stage3/WindowsOfRH.md#WindowsOfRH-const_eq_zero) in `lean_stage3/Stage3/WindowsOfRH.lean`, line 186.

**Why.** S4. The constant is zero. If `G y = c·y + r y` on `(1, ∞)` with `|r y| ≤ K·y^α` and `α < 1`, then `c = 0`: `Phi` is regular at `1`, so it has no pole `c/(s − 1)` there.

**Proves**

```lean
c = 0
```

**Needs** (its hypotheses)

  - `` hα : α < 1 ``
  - `` hK : 0 ≤ K ``
  - `` hG : ∀ y ∈ Set.Ioi (1 : ℝ), LandauWindow.G y = c * y + r y ``
  - `` hr : ∀ y ∈ Set.Ioi (1 : ℝ), |r y| ≤ K * y ^ α ``

Behind it: 21 theorems and 5 definitions in 5 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>LandauWindow</b><br/>2 used"]:::thm
  f1["<b>LandauMellin</b><br/>8 used"]:::thm
  f2["<b>LandauMellinG</b><br/>12 used"]:::thm
  f3["<b>LandauPoleLocal</b><br/>1 used"]:::thm
  f4["<b>WindowsOfRH</b><br/>const_eq_zero"]:::end_
  f0 --> f1
  f1 --> f2
  f2 --> f3
  f3 --> f4
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

### [`LandauWindow`](../lean_stage3/LandauWindow.md) — 2

- [`LandauWindow.rampSum`](../lean_stage3/LandauWindow.md#LandauWindow-rampSum) — *def*
- ★ [`LandauWindow.G`](../lean_stage3/LandauWindow.md#LandauWindow-G) — *def*

### [`LandauMellin`](../lean_stage3/LandauMellin.md) — 8

- [`LandauMellin.rampK`](../lean_stage3/LandauMellin.md#LandauMellin-rampK) — *def*
- [`LandauMellin.rampK_eq_indicator`](../lean_stage3/LandauMellin.md#LandauMellin-rampK_eq_indicator) — `` rampK s n y = (Ioi (n : ℝ)).indicator (fun t : ℝ => (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) y ``
- [`LandauMellin.two_powers_integrableOn`](../lean_stage3/LandauMellin.md#LandauMellin-two_powers_integrableOn) — `` IntegrableOn (fun t : ℝ => (1 / (n : ℂ)) * (t : ℂ) ^ (-s) - (t : ℂ) ^ (-s - 1)) (Ioi (n : ℝ)) ``
- [`LandauMellin.rampK_integrable`](../lean_stage3/LandauMellin.md#LandauMellin-rampK_integrable) — `` IntegrableOn (rampK s n) (Ioi 1) ``
- [`LandauMellin.rampK_integral`](../lean_stage3/LandauMellin.md#LandauMellin-rampK_integral) — `` ∫ y in Ioi (1 : ℝ), rampK s n y = (n : ℂ) ^ (-s) / (s * (s - 1)) ``
- [`LandauMellin.rampK_integral_norm`](../lean_stage3/LandauMellin.md#LandauMellin-rampK_integral_norm) — `` ∫ y in Ioi (1 : ℝ), ‖rampK s n y‖ = (n : ℝ) ^ (-s.re) / (s.re * (s.re - 1)) ``
- [`LandauMellin.rampSum_eq_tsum`](../lean_stage3/LandauMellin.md#LandauMellin-rampSum_eq_tsum) — `` LandauWindow.rampSum y = ∑' n : ℕ, Λ n * max (y / n - 1) 0 ``
- [`LandauMellin.mellin_rampSum`](../lean_stage3/LandauMellin.md#LandauMellin-mellin_rampSum) — `` ∫ y in Ioi (1 : ℝ), (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) = -deriv riemannZeta s / riemannZeta s / (s * (s - 1)) ``

### [`LandauMellinG`](../lean_stage3/LandauMellinG.md) — 12

- ★ [`LandauMellinG.Phi`](../lean_stage3/LandauMellinG.md#LandauMellinG-Phi) — *def*
- [`LandauMellinG.LSeries_vonMangoldt_real_ne_zero`](../lean_stage3/LandauMellinG.md#LandauMellinG-LSeries_vonMangoldt_real_ne_zero) — `` L ↗Λ (σ : ℂ) ≠ 0 ``
- [`LandauMellinG.rampSum_mellin_integrable`](../lean_stage3/LandauMellinG.md#LandauMellinG-rampSum_mellin_integrable) — `` IntegrableOn (fun y : ℝ => (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ``
- [`LandauMellinG.logPrim`](../lean_stage3/LandauMellinG.md#LandauMellinG-logPrim) — *def*
- [`LandauMellinG.hasDerivAt_logPrim`](../lean_stage3/LandauMellinG.md#LandauMellinG-hasDerivAt_logPrim) — `` HasDerivAt (logPrim s) ((Real.log y : ℂ) * (y : ℂ) ^ (-s)) y ``
- [`LandauMellinG.log_cpow_norm_le`](../lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_norm_le) — `` ‖(Real.log y : ℂ) * (y : ℂ) ^ (-s)‖ ≤ y ^ ((s.re - 1) / 2 - s.re) / ((s.re - 1) / 2) ``
- [`LandauMellinG.log_cpow_integrable`](../lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integrable) — `` IntegrableOn (fun y : ℝ => (Real.log y : ℂ) * (y : ℂ) ^ (-s)) (Ioi 1) ``
- [`LandauMellinG.tendsto_logPrim`](../lean_stage3/LandauMellinG.md#LandauMellinG-tendsto_logPrim) — `` Tendsto (logPrim s) atTop (𝓝 0) ``
- [`LandauMellinG.log_cpow_integral`](../lean_stage3/LandauMellinG.md#LandauMellinG-log_cpow_integral) — `` ∫ y in Ioi (1 : ℝ), (Real.log y : ℂ) * (y : ℂ) ^ (-s) = 1 / (s - 1) ^ 2 ``
- [`LandauMellinG.G_integrand_eq`](../lean_stage3/LandauMellinG.md#LandauMellinG-G_integrand_eq) — `` (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = (LandauWindow.rampSum y : ℂ) * (y : ℂ) ^ (-s - 1) - (Real.log y : ℂ) * (y : ℂ) ^ (-s) + (1 + (Real.eulerMascheroni… ``
- [`LandauMellinG.G_mellin_integrable`](../lean_stage3/LandauMellinG.md#LandauMellinG-G_mellin_integrable) — `` IntegrableOn (fun y : ℝ => (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ``
- [`LandauMellinG.mellin_G`](../lean_stage3/LandauMellinG.md#LandauMellinG-mellin_G) — `` ∫ y in Ioi (1 : ℝ), (LandauWindow.G y : ℂ) * (y : ℂ) ^ (-s - 1) = Phi s ``

### [`LandauPoleLocal`](../lean_stage3/LandauPoleLocal.md) — 1

- ★ [`LandauPoleLocal.Phi_regular_at_one`](../lean_stage3/LandauPoleLocal.md#LandauPoleLocal-Phi_regular_at_one) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 1 ∧ ∀ᶠ s in 𝓝[≠] 1, LandauMellinG.Phi s = h s ``

### [`WindowsOfRH`](../lean_stage3/WindowsOfRH.md) — 3

- [`WindowsOfRH.integral_cpow_neg`](../lean_stage3/WindowsOfRH.md#WindowsOfRH-integral_cpow_neg) — `` ∫ y in Set.Ioi (1 : ℝ), (y : ℂ) ^ (-(σ : ℂ)) = 1 / ((σ : ℂ) - 1) ``
- [`WindowsOfRH.mul_cpow_eq`](../lean_stage3/WindowsOfRH.md#WindowsOfRH-mul_cpow_eq) — `` (y : ℂ) * (y : ℂ) ^ (-(σ : ℂ) - 1) = (y : ℂ) ^ (-(σ : ℂ)) ``
- ★ [`WindowsOfRH.phi_sub_pole_le`](../lean_stage3/WindowsOfRH.md#WindowsOfRH-phi_sub_pole_le) — `` ‖LandauMellinG.Phi σ - c / ((σ : ℂ) - 1)‖ ≤ K / (σ - α) ``

