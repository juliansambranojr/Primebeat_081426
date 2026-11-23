# `lean_stage3/Stage3/WholeChain.lean`

> **Read from the source text.** This file changed after the last `python3 utilities/lean_map.py --dump`, so the arrows on this page are names occurring in each proof and have not been confirmed by Lean.

WholeChain — block J8 of `lean_stage3/design/closedloop.md`. 2026-11-23. The closing theorem. `OneChain.one_chain` was written before the later blocks of the day. This file names them, so that every branch of the tree ends in one place.

3 theorems, 0 definitions, 94 lines. 

**Imports:** [`Compression`](../lean_stage3/Compression.md), [`RunTheorems`](../lean_stage3/RunTheorems.md), [`Saddle`](../lean_stage3/Saddle.md), [`SelfBound`](../lean_stage3/SelfBound.md), [`StepsBelow`](../lean_stage3/StepsBelow.md)  
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md)

## The picture

```mermaid
flowchart LR
  n0["<b>whole_chain ■</b><br/>(RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧ (SpiralLink.Spiral…"]:::thm
  n1["<b>table_side ■</b><br/>(∀ N : ℕ, 2 ≤ N → (Nat.primeCounting N : ℤ) = (Nat.primeCounting…"]:::shp
  n2["<b>steps_side ■</b><br/>(∀ ρ : NontrivialZeros, -(analyticOrderNatAt riemannZeta (ρ : ℂ)…"]:::thm
  x0(["<b>BandJoin</b><br/>spiralLink_iff_middle"]):::ext
  x1(["<b>HalfSieve</b><br/>spiralLink_iff_wobble"]):::ext
  x2(["<b>Saddle</b><br/>spiralLink_iff_centres<br/>spiralLink_iff_noRunaway"]):::ext
  x3(["<b>ShareLink</b><br/>spiralLink_iff_meet"]):::ext
  x4(["<b>CompositeSplit</b><br/>composites_no_signs"]):::ext
  x5(["<b>Compression</b><br/>compression"]):::ext
  x6(["<b>RunTheorems</b><br/>mode_fold"]):::ext
  x7(["<b>SelfBound</b><br/>self_bound"]):::ext
  x8(["<b>SieveExact</b><br/>pi_by_sieve"]):::ext
  x9(["<b>RateBelow</b><br/>rain_psi"]):::ext
  x10(["<b>StepsBelow</b><br/>rain_steps"]):::ext
  x11(["<b>StepsPole</b><br/>steps_pole_ne_zero"]):::ext
  x0 -.-> n0
  x1 -.-> n0
  x10 -.-> n2
  x11 -.-> n2
  x2 -.-> n0
  x3 -.-> n0
  x4 -.-> n1
  x5 -.-> n1
  x6 -.-> n1
  x7 -.-> n1
  x8 -.-> n1
  x9 -.-> n2
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "A is used in the proof of B". Green: counting, integers only. Violet: shape, analysis with no ζ. Blue: reads ζ. A name ending in ■ is an end: nothing else uses it. Red: contains `sorry`. Yellow: theorems in another file, counted; a dotted arrow crosses files. Definitions are not drawn; they are listed below the diagram.

## Theorems

<a name="WholeChain-whole_chain"></a>
### `WholeChain.whole_chain`

line 32 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The whole chain. The spiral link, and every face of it compiled in the tree, are one statement.

**Proves**

```lean
(RiemannHypothesis ↔ SpiralLink.SpiralLink) ∧ (SpiralLink.SpiralLink ↔ OneAtEachHeight) ∧ (SpiralLink.SpiralLink ↔ ∃ (C : ℝ) (r₀ : ℤ), CellResidual.CellsSqrt C r₀) ∧ (SpiralLink.SpiralLink ↔ HalfSieve.WobbleSqrt) ∧ (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖(2 : ℂ) ^ (-(ρ : ℂ))‖ = BandJoin.bandR (1 / 2)) ∧ (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖) ∧ (SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, Saddle.stretch ρ = 1) ∧ (SpiralLink.SpiralLink ↔ Saddle.NoRunaway)
```

**Fed by** (5 theorems its proof uses)

  - [`BandJoin.spiralLink_iff_middle`](../lean_stage3/BandJoin.md#BandJoin-spiralLink_iff_middle) (BandJoin) — `` SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖(2:ℂ) ^ (-(ρ:ℂ))‖ = bandR (1 / 2) ``
  - [`HalfSieve.spiralLink_iff_wobble`](../lean_stage3/HalfSieve.md#HalfSieve-spiralLink_iff_wobble) (HalfSieve) — `` SpiralLink.SpiralLink ↔ WobbleSqrt ``
  - [`Saddle.spiralLink_iff_centres`](../lean_stage3/Saddle.md#Saddle-spiralLink_iff_centres) (Saddle) — `` SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, stretch ρ = 1 ``
  - [`Saddle.spiralLink_iff_noRunaway`](../lean_stage3/Saddle.md#Saddle-spiralLink_iff_noRunaway) (Saddle) — `` SpiralLink.SpiralLink ↔ NoRunaway ``
  - [`ShareLink.spiralLink_iff_meet`](../lean_stage3/ShareLink.md#ShareLink-spiralLink_iff_meet) (ShareLink) — `` SpiralLink.SpiralLink ↔ ∀ ρ : NontrivialZeros, ‖((2 : ℝ) : ℂ) ^ (ρ : ℂ)‖ = ‖((2 : ℝ) : ℂ) ^ ((mirrorZ ρ : NontrivialZeros) : ℂ)‖ ``

**Definitions its proof touches:** [`BandJoin.bandR`](../lean_stage3/BandJoin.md#BandJoin-bandR), [`CellResidual.CellsSqrt`](../lean_stage3/CellResidual.md#CellResidual-CellsSqrt), [`HalfSieve.WobbleSqrt`](../lean_stage3/HalfSieve.md#HalfSieve-WobbleSqrt), [`Saddle.NoRunaway`](../lean_stage3/Saddle.md#Saddle-NoRunaway), [`Saddle.stretch`](../lean_stage3/Saddle.md#Saddle-stretch), [`SpiralLink.OneAtEachHeight`](../lean_stage3/SpiralLink.md#SpiralLink-OneAtEachHeight), [`SpiralLink.SpiralLink`](../lean_stage3/SpiralLink.md#SpiralLink-SpiralLink), [`SpiralLink.mirrorZ`](../lean_stage3/SpiralLink.md#SpiralLink-mirrorZ)

**Feeds:** nothing. It is an end.

<a name="WholeChain-table_side"></a>
### `WholeChain.table_side`

line 50 · arrows read from text

**Shape.** Uses real or complex analysis; nothing in it or beneath it reads ζ.

**Why.** The table's side. What is proved of the table at every `N`, with no zero in the statement.

**Proves**

```lean
(∀ N : ℕ, 2 ≤ N → (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 + ∑ T ∈ (SieveExact.smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ)) ∧ (∀ N : ℕ, ((Finset.Icc 2 N).filter (fun n => ¬ n.Prime)).card + (SieveExact.smallPrimes N).card = ∑ p ∈ SieveExact.smallPrimes N, CompositeSplit.rough N p) ∧ (∀ N : ℕ, N = Compression.smooth N + ∑ p ∈ Compression.newPrimes N, N / p) ∧ (∀ N : ℕ, ∑ k ∈ Finset.Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ)) = ∑ n ∈ Finset.Icc 1 N, Real.log (n : ℝ)) ∧ (∀ (ρ : ℂ) (k : ℤ), (2 : ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2 : ℂ) ^ ρ)
```

**Fed by** (5 theorems its proof uses)

  - [`CompositeSplit.composites_no_signs`](../lean_stage3/CompositeSplit.md#CompositeSplit-composites_no_signs) (CompositeSplit) — `` ((Icc 2 N).filter (fun n => ¬ n.Prime)).card + (smallPrimes N).card = ∑ p ∈ smallPrimes N, rough N p ``
  - [`Compression.compression`](../lean_stage3/Compression.md#Compression-compression) (Compression) — `` N = smooth N + ∑ p ∈ newPrimes N, N / p ``
  - [`RunTheorems.mode_fold`](../lean_stage3/RunTheorems.md#RunTheorems-mode_fold) (RunTheorems) — `` (2:ℂ) ^ (ρ + 2 * Real.pi * Complex.I * (k : ℂ) / (Real.log 2 : ℂ)) = (2:ℂ) ^ ρ ``
  - [`SelfBound.self_bound`](../lean_stage3/SelfBound.md#SelfBound-self_bound) (SelfBound) — `` ∑ k ∈ Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ)) = ∑ n ∈ Icc 1 N, Real.log (n : ℝ) ``
  - [`SieveExact.pi_by_sieve`](../lean_stage3/SieveExact.md#SieveExact-pi_by_sieve) (SieveExact) — `` (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 + ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) ``

**Definitions its proof touches:** [`CompositeSplit.rough`](../lean_stage3/CompositeSplit.md#CompositeSplit-rough), [`Compression.newPrimes`](../lean_stage3/Compression.md#Compression-newPrimes), [`Compression.smooth`](../lean_stage3/Compression.md#Compression-smooth), [`SieveExact.smallPrimes`](../lean_stage3/SieveExact.md#SieveExact-smallPrimes)

**Feeds:** nothing. It is an end.

<a name="WholeChain-steps_side"></a>
### `WholeChain.steps_side`

line 69 · arrows read from text

**Reads ζ.** It, or something it rests on, uses the zeta function, its zeros or the Riemann hypothesis.

**Why.** The steps' side. What a zero does: it carries weight that is not zero, it makes the staircase leave every bound below its rate, and it makes the turned steps to a cutoff do the same.

**Proves**

```lean
(∀ ρ : NontrivialZeros, -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0) ∧ (∀ (ρ₀ : NontrivialZeros) (θ : ℝ), θ < (ρ₀ : ℂ).re → ∀ (C : ℝ) (k : ℕ) (x₀ : ℝ), ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x|) ∧ (∀ (ρ₀ : NontrivialZeros) (s : ℂ), 0 < s.re → (ρ₀ : ℂ) ≠ s → ∀ δ : ℝ, 0 ≤ δ → δ < (ρ₀ : ℂ).re - s.re → ∀ (C : ℝ) (N₀ : ℕ), ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖)
```

**Fed by** (3 theorems its proof uses)

  - [`RateBelow.rain_psi`](../lean_stage3/RateBelow.md#RateBelow-rain_psi) (RateBelow) — `` ∃ x : ℝ, x₀ ≤ x ∧ C * x ^ θ * Real.log x ^ k < |Chebyshev.psi x - x| ``
  - [`StepsBelow.rain_steps`](../lean_stage3/StepsBelow.md#StepsBelow-rain_steps) (StepsBelow) — `` ∃ N : ℕ, N₀ ≤ N ∧ 2 ≤ N ∧ C * (N : ℝ) ^ δ < ‖StepsPeak.S N s - StepsPeak.K N s 1‖ ``
  - [`StepsPole.steps_pole_ne_zero`](../lean_stage3/StepsPole.md#StepsPole-steps_pole_ne_zero) (StepsPole) — `` -(analyticOrderNatAt riemannZeta (ρ : ℂ) : ℂ) / (ρ : ℂ) ≠ 0 ``

**Definitions its proof touches:** [`StepsPeak.K`](../lean_stage3/StepsPeak.md#StepsPeak-K), [`StepsPeak.S`](../lean_stage3/StepsPeak.md#StepsPeak-S)

**Feeds:** nothing. It is an end.

