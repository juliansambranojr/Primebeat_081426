# `lean_stage3/Stage3/WeilBridgeLeaf.lean`

**What it does** (its own header): WeilBridgeLeaf — the zero-set lemma and the bridge leaf: `zeroForm` gets a prime side. Block 1 of `lean_stage3/design/bridge.md`. 2026-11-22.

**Imports:** [`WeilDetect`](../lean_stage3/WeilDetect.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md).

```mermaid
flowchart LR
  n0["tiltF<br/>(def)"]:::dfn
  n1["ft<br/>(def)"]:::dfn
  n2["kOfM<br/>(def)"]:::dfn
  n3["primeSideM<br/>(def)"]:::dfn
  n4["StmtWeilBridge<br/>(def)"]:::dfn
  n5["order_eq_toNat<br/>⊢ riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ…"]:::thm
  n6["zeroes_rect_strip<br/>⊢ riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ = {ρ : ℂ | riemannZeta …"]:::thm
  n7["zeroForm_eq_strip<br/>⊢ zeroForm G = ∑' ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 ＜ ρ.re ∧ ρ.re ＜ 1},…"]:::thm
  n8["zeroForm_eq_primeSide<br/>⊢ zeroForm G = primeSideM (kOfM G)"]:::end_
  x0(["WeilDetect · IsTest"]):::ext
  x1(["WeilDetect · laplace"]):::ext
  x2(["WeilDetect · zeroForm"]):::ext
  n0 --> n2
  n1 --> n3
  n2 --> n4
  n2 --> n8
  n3 --> n4
  n3 --> n8
  n4 --> n8
  n5 --> n7
  n6 --> n7
  n7 --> n8
  x0 --> n4
  x0 --> n8
  x1 --> n4
  x1 --> n7
  x2 --> n7
  x2 --> n8
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
| `WeilBridgeLeaf.tiltF`<br/>def, line 44 | ℝ → ℂ | G : ℝ → ℂ | `F(u) = G(u)·e^{u/2}`: the test function in zeta23's centred variable. | — | `WeilBridgeLeaf.kOfM` |
| `WeilBridgeLeaf.ft`<br/>def, line 47 | ℂ | k : ℝ → ℂ; z : ℂ | The transform `∫ k(u) e^{izu} du`; zeta23's `paperFT`. | — | `WeilBridgeLeaf.primeSideM` |
| `WeilBridgeLeaf.kOfM`<br/>def, line 51 | ℝ → ℂ | G : ℝ → ℂ | `k = F ⋆ F̃` in Mathlib's convolution; zeta23's `weilTest` at `F = tiltF G`. | `WeilBridgeLeaf.tiltF` | `WeilBridgeLeaf.StmtWeilBridge`, `WeilBridgeLeaf.zeroForm_eq_primeSide` |
| `WeilBridgeLeaf.primeSideM`<br/>def, line 56 | ℂ | k : ℝ → ℂ | The prime side: the pole terms, minus the prime sum, plus the archimedean integral. | `WeilBridgeLeaf.ft` | `WeilBridgeLeaf.StmtWeilBridge`, `WeilBridgeLeaf.zeroForm_eq_primeSide` |
| `WeilBridgeLeaf.StmtWeilBridge`<br/>def, line 64 | Prop | — | The bridge, as a statement. | `WeilBridgeLeaf.kOfM`, `WeilBridgeLeaf.primeSideM`, `WeilDetect.IsTest`, `WeilDetect.laplace` | `WeilBridgeLeaf.zeroForm_eq_primeSide` |
| `WeilBridgeLeaf.order_eq_toNat`<br/>theorem, line 75 | riemannZeta.order ρ = (((analyticOrderAt riemannZeta ρ).toNat : ℕ) : ℤ) | hρ : ρ ≠ 1 | Upstream's order at a point other than the pole is the analytic order. | — | `WeilBridgeLeaf.zeroForm_eq_strip` |
| `WeilBridgeLeaf.zeroes_rect_strip`<br/>theorem, line 87 | riemannZeta.zeroes_rect (Set.Ioo 0 1) Set.univ = {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} | — | Upstream's rectangle over `(0, 1)` is the strip set. | — | `WeilBridgeLeaf.zeroForm_eq_strip` |
| `WeilBridgeLeaf.zeroForm_eq_strip`<br/>theorem, line 96 | zeroForm G = ∑' ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1}, (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) | G : ℝ → ℂ | The zero-set lemma. `zeroForm` over Mathlib's zero set and analytic order. | `WeilBridgeLeaf.order_eq_toNat`, `WeilBridgeLeaf.zeroes_rect_strip`, `WeilDetect.laplace`, `WeilDetect.zeroForm` | `WeilBridgeLeaf.zeroForm_eq_primeSide` |
| `WeilBridgeLeaf.zeroForm_eq_primeSide`<br/>theorem, line 117 | zeroForm G = primeSideM (kOfM G) | h : StmtWeilBridge; hG : IsTest L G | The prime side of Weil's form. | `WeilBridgeLeaf.StmtWeilBridge`, `WeilBridgeLeaf.kOfM`, `WeilBridgeLeaf.primeSideM`, `WeilBridgeLeaf.zeroForm_eq_strip`, `WeilDetect.IsTest`, `WeilDetect.zeroForm` | — |
