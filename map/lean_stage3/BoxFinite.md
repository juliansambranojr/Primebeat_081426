# `lean_stage3/Stage3/BoxFinite.lean`

**What it does** (its own header): BoxFinite — the off-line box of `WeilDetect` is a finite set of zeros (block 15 of rung5.md).

**Imports:** [`WeilDetect`](../lean_stage3/WeilDetect.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md).

```mermaid
flowchart LR
  n0["offLineBox_finite<br/>⊢ (WeilDetect.OffLineBox ε T).Finite"]:::end_
  x0(["WeilDetect · OffLineBox"]):::ext
  x0 --> n0
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
| `Stage3.offLineBox_finite`<br/>theorem, line 25 | (WeilDetect.OffLineBox ε T).Finite | ε T : ℝ | The off-line box is finite. `OffLineBox ε T` sits inside a compact rectangle in `ℂ` and the zeros of `riemannZeta` on any compact set are finite. | `WeilDetect.OffLineBox` | — |
