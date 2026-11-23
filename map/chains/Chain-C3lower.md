# What `Chain.C3lower` rests on

[`Chain.C3lower`](../lean/Chain.md#Chain-C3lower) in `lean/Chain.lean`, line 288.

**Why.** C3's decay half, unconditional. Same arrow as `C3lower_of_A4_C2` with both hypotheses supplied. With `C3` this is the paper's C3 in full: a mode's depth-`N` amplitude is trapped between `|1 − b^(−1/2)|^N` and `(1 + b^(−1/2))^N` times its undifferenced amplitude, at every rung and every `γ`.

**Proves**

```lean
StmtC3lower b
```

**Needs** (its hypotheses)

  - `` hb : 0 < b ``

Behind it: 11 theorems and 9 definitions in 2 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>EulerFactorChain</b><br/>4 used"]:::thm
  f1["<b>Chain</b><br/>C3lower"]:::end_
  f0 --> f1
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

### [`EulerFactorChain`](../lean/EulerFactorChain.md) — 4

- [`EulerFactorChain.sym`](../lean/EulerFactorChain.md#EulerFactorChain-sym) — *def*
- [`EulerFactorChain.symbol_of_backward_difference`](../lean/EulerFactorChain.md#EulerFactorChain-symbol_of_backward_difference) — `` (b : ℂ) ^ (r * ρ) - (b : ℂ) ^ ((r - 1) * ρ) = sym b ρ * (b : ℂ) ^ (r * ρ) ``
- [`EulerFactorChain.cpow_rect_on_critical_line`](../lean/EulerFactorChain.md#EulerFactorChain-cpow_rect_on_critical_line) — `` (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I)) = ((b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) : ℝ) : ℂ) + ((-(b ^ (-(1:ℝ)/2) * Real.sin (γ * Real.log b)) : ℝ) : ℂ) * I ``
- [`EulerFactorChain.gain_sq_on_critical_line`](../lean/EulerFactorChain.md#EulerFactorChain-gain_sq_on_critical_line) — `` ‖1 - (b : ℂ) ^ (-((1 : ℂ)/2 + γ * I))‖ ^ 2 = 1 - 2 * b ^ (-(1:ℝ)/2) * Real.cos (γ * Real.log b) + b ^ (-(1:ℝ)) ``

### [`Chain`](../lean/Chain.md) — 16

- [`Chain.Sym`](../lean/Chain.md#Chain-Sym) — *def*
- [`Chain.mode`](../lean/Chain.md#Chain-mode) — *def*
- [`Chain.bdiff`](../lean/Chain.md#Chain-bdiff) — *def*
- [`Chain.StmtA1`](../lean/Chain.md#Chain-StmtA1) — *def*
- [`Chain.StmtA4`](../lean/Chain.md#Chain-StmtA4) — *def*
- [`Chain.StmtC1`](../lean/Chain.md#Chain-StmtC1) — *def*
- [`Chain.StmtC2`](../lean/Chain.md#Chain-StmtC2) — *def*
- ★ [`Chain.StmtC3lower`](../lean/Chain.md#Chain-StmtC3lower) — *def*
- [`Chain.bdiff_smul`](../lean/Chain.md#Chain-bdiff_smul) — `` bdiff (fun r => k * f r) = fun r => k * bdiff f r ``
- [`Chain.A4_of_A1`](../lean/Chain.md#Chain-A4_of_A1) — `` StmtA4 b ρ ``
- [`Chain.C2_of_C1`](../lean/Chain.md#Chain-C2_of_C1) — `` StmtC2 b ``
- ★ [`Chain.C3lower_of_A4_C2`](../lean/Chain.md#Chain-C3lower_of_A4_C2) — `` StmtC3lower b ``
- [`Chain.C1`](../lean/Chain.md#Chain-C1) — `` StmtC1 b ``
- ★ [`Chain.C2`](../lean/Chain.md#Chain-C2) — `` StmtC2 b ``
- [`Chain.A1`](../lean/Chain.md#Chain-A1) — `` StmtA1 b ρ ``
- ★ [`Chain.A4`](../lean/Chain.md#Chain-A4) — `` StmtA4 b ρ ``

