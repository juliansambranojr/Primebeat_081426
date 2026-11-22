# `lean/Nonvanishing.lean`

**What it does** (its own header): Nonvanishing — the arrow of O67's conditional theorem, in the house pattern. `papers/The-Four-Zeros.md` § I states: under RH, `cell(r,d) ≠ 0` for every `r ≥ R(d)`, which with O43's census makes the four zeros complete at every depth `d ≤ 15`. The proof has two analytic inputs and one arithmetic gap condition; everything joining them is algebra. Following `Chain.lean`'s design — take the antecedents as HYPOTHESES, prove the arrows, let the kernel check that the "therefore" is real — this module proves the joins:

**Imports:** [`Zeros`](../lean/Zeros.md), [`ZerosStencil`](../lean/ZerosStencil.md).
**Imported by:** [`MainTerm`](../lean/MainTerm.md), [`RelativeGate`](../lean/RelativeGate.md).

```mermaid
flowchart LR
  n0["bdiffZ<br/>(def)"]:::dfn
  n1["stencilR<br/>(def)"]:::dfn
  n2["iter_bdiffZ_eq_fwdDiff<br/>⊢ (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r"]:::thm
  n3["iter_bdiffZ_eq_stencilR<br/>⊢ (bdiffZ^[n]) g r = stencilR n g r"]:::thm
  n4["stencilR_row<br/>⊢ stencilR d (bdiffZ g) r = stencilR (d + 1) g r"]:::thm
  n5["stencilR_sub<br/>⊢ stencilR n (fun x =＞ f x - L x) r = stencilR n f r - stencilR n L r"]:::thm
  n6["Ehigh<br/>(def)"]:::dfn
  n7["StmtSchoenfeldWindow<br/>(def)"]:::dfn
  n8["window_term_le<br/>⊢ (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k…"]:::thm
  n9["error_bound<br/>⊢ |stencilR n (fun x =＞ f x - L x) r| ≤ Ehigh r n"]:::thm
  n10["Mlow<br/>(def)"]:::dfn
  n11["nonvanishing_of<br/>⊢ stencilR (d + 1) f r ≠ 0"]:::thm
  n12["tableFrom_ne_zero_of<br/>⊢ Construction.tableFrom N r d ≠ 0"]:::thm
  x0(["Construction · tableFrom"]):::ext
  x1(["Expansion · hD_of_window"]):::ext
  x2(["Expansion · tableFrom_ne_zero_of_li"]):::ext
  x3(["Interpolant · tableFrom_ne_zero_of_relErr_liRow"]):::ext
  x4(["MainTerm · stencilR_eq_iter"]):::ext
  x5(["MainTerm · stencilR_ge_of"]):::ext
  x6(["MainTerm · tableFrom_ne_zero_of_deriv"]):::ext
  x7(["RelativeGate · nonvanishing_of_relErr"]):::ext
  x8(["RelativeGate · relError_bound"]):::ext
  x9(["RelativeGate · relGate_iff"]):::ext
  x10(["RelativeGate · schoenfeldWindow_relErr"]):::ext
  x11(["RelativeGate · tableFrom_ne_zero_of_relErr"]):::ext
  x12(["RelativeLi · tableFrom_ne_zero_of_powerSaving"]):::ext
  x13(["RelativeLi · tableFrom_ne_zero_of_relErr_li"]):::ext
  x14(["RelativeLi · tableFrom_ne_zero_of_relErr_li'"]):::ext
  x15(["RouteCell · cell_ne_zero_of_route"]):::ext
  x16(["Schoenfeld · tableFrom_ne_zero_of_schoenfeld"]):::ext
  x17(["Schoenfeld · window_of_global"]):::ext
  x18(["ZerosStencil · stencil"]):::ext
  x19(["ZerosStencil · tableFrom_eq_stencil"]):::ext
  x20(["TableDepths · cell_ne_zero_gen"]):::ext
  x21(["TableRoute · cell_ne_zero_of_RH"]):::ext
  n0 --> n12
  n0 --> n2
  n0 --> n3
  n0 --> n4
  n0 --> x11
  n0 --> x12
  n0 --> x13
  n0 --> x14
  n0 --> x15
  n0 --> x16
  n0 --> x2
  n0 --> x20
  n0 --> x21
  n0 --> x3
  n0 --> x6
  n1 --> n11
  n1 --> n12
  n1 --> n3
  n1 --> n4
  n1 --> n5
  n1 --> n9
  n1 --> x11
  n1 --> x4
  n1 --> x5
  n1 --> x7
  n1 --> x8
  n10 --> n11
  n10 --> n12
  n10 --> x1
  n10 --> x11
  n10 --> x13
  n10 --> x16
  n10 --> x2
  n10 --> x6
  n10 --> x7
  n10 --> x9
  n11 --> n12
  n12 --> x6
  n2 --> n3
  n3 --> n4
  n4 --> n12
  n4 --> x11
  n5 --> n11
  n5 --> x7
  n6 --> n11
  n6 --> n12
  n6 --> n9
  n6 --> x16
  n6 --> x2
  n6 --> x6
  n7 --> n11
  n7 --> n12
  n7 --> n9
  n7 --> x10
  n7 --> x17
  n7 --> x2
  n7 --> x6
  n8 --> n9
  n9 --> n11
  x0 --> n12
  x18 --> n12
  x19 --> n12
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
| `Nonvanishing.bdiffZ`<br/>def, line 52 | ℤ → ℝ | g : ℤ → ℝ | Backward differencing on ℤ-indexed real sequences — `Chain.bdiff`'s twin one level down (ℤ index, ℝ values). | — | `Expansion.tableFrom_ne_zero_of_li`, `Interpolant.tableFrom_ne_zero_of_relErr_liRow`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.iter_bdiffZ_eq_fwdDiff`, `Nonvanishing.iter_bdiffZ_eq_stencilR`, `Nonvanishing.stencilR_row`, `Nonvanishing.tableFrom_ne_zero_of`, `RelativeGate.tableFrom_ne_zero_of_relErr`, `RelativeLi.tableFrom_ne_zero_of_powerSaving`, `RelativeLi.tableFrom_ne_zero_of_relErr_li`, `RelativeLi.tableFrom_ne_zero_of_relErr_li'`, `RouteCell.cell_ne_zero_of_route`, `Schoenfeld.tableFrom_ne_zero_of_schoenfeld`, `TableDepths.cell_ne_zero_gen`, `TableRoute.cell_ne_zero_of_RH` |
| `Nonvanishing.stencilR`<br/>def, line 56 | ℝ | n : ℕ; g : ℤ → ℝ; r : ℤ | The real alternating binomial stencil of order `n` on `g`, read at `r` downward. The ℝ twin of `Zeros.stencil`. | — | `MainTerm.stencilR_eq_iter`, `MainTerm.stencilR_ge_of`, `Nonvanishing.error_bound`, `Nonvanishing.iter_bdiffZ_eq_stencilR`, `Nonvanishing.nonvanishing_of`, `Nonvanishing.stencilR_row`, `Nonvanishing.stencilR_sub`, `Nonvanishing.tableFrom_ne_zero_of`, `RelativeGate.nonvanishing_of_relErr`, `RelativeGate.relError_bound`, `RelativeGate.tableFrom_ne_zero_of_relErr` |
| `Nonvanishing.iter_bdiffZ_eq_fwdDiff`<br/>theorem, line 61 | (bdiffZ^[n]) g r = (-1 : ℝ) ^ n * (fwdDiff (-1 : ℤ))^[n] g r | g : ℤ → ℝ; r : ℤ; n : ℕ | Backward differencing is `(−1)·fwdDiff` at step `−1` — the ℝ copy of `Zeros.tableFrom_eq_fwdDiff`'s bridge. | `Nonvanishing.bdiffZ` | `Nonvanishing.iter_bdiffZ_eq_stencilR` |
| `Nonvanishing.iter_bdiffZ_eq_stencilR`<br/>theorem, line 77 | (bdiffZ^[n]) g r = stencilR n g r | g : ℤ → ℝ; r : ℤ; n : ℕ | `n` differences are the stencil. `Zeros.tableFrom_eq_stencil` transplanted to ℝ: Mathlib's `fwdDiff_iter_eq_sum_shift` does the binomial bookkeeping. | `Nonvanishing.bdiffZ`, `Nonvanishing.iter_bdiffZ_eq_fwdDiff`, `Nonvanishing.stencilR` | `Nonvanishing.stencilR_row` |
| `Nonvanishing.stencilR_row`<br/>theorem, line 94 | stencilR d (bdiffZ g) r = stencilR (d + 1) g r | d : ℕ; g : ℤ → ℝ; r : ℤ | The Pascal step. The depth-`d` stencil on the row `x ↦ g(x) − g(x−1)` is the depth-`(d+1)` stencil on `g`. One more iterate, nothing else. | `Nonvanishing.bdiffZ`, `Nonvanishing.iter_bdiffZ_eq_stencilR`, `Nonvanishing.stencilR` | `Nonvanishing.tableFrom_ne_zero_of`, `RelativeGate.tableFrom_ne_zero_of_relErr` |
| `Nonvanishing.stencilR_sub`<br/>theorem, line 100 | stencilR n (fun x =&gt; f x - L x) r = stencilR n f r - stencilR n L r | n : ℕ; f L : ℤ → ℝ; r : ℤ | Linearity. Splitting `π = li + (π − li)` under the stencil. | `Nonvanishing.stencilR` | `Nonvanishing.nonvanishing_of`, `RelativeGate.nonvanishing_of_relErr` |
| `Nonvanishing.Ehigh`<br/>def, line 109 | ℝ | r : ℤ; n : ℕ | The error ceiling: `(log 2 · r / 8π) · 2^(r/2) · (1 + 2^(−1/2))^(n)`. | — | `Expansion.tableFrom_ne_zero_of_li`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.error_bound`, `Nonvanishing.nonvanishing_of`, `Nonvanishing.tableFrom_ne_zero_of`, `Schoenfeld.tableFrom_ne_zero_of_schoenfeld` |
| `Nonvanishing.StmtSchoenfeldWindow`<br/>def, line 117 | Prop | f L : ℤ → ℝ; r : ℤ; n : ℕ | Schoenfeld on the window, as a statement: each of the `n+1` values the stencil reads obeys the RH bound at `x = 2^(r−k)`, where `√x = 2^((r−k)/2)` and `log x = (r−k)·log 2`. This is the hypothesis Schoenfeld's theorem would discharge; it is not discharged here. | — | `Expansion.tableFrom_ne_zero_of_li`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.error_bound`, `Nonvanishing.nonvanishing_of`, `Nonvanishing.tableFrom_ne_zero_of`, `RelativeGate.schoenfeldWindow_relErr`, `Schoenfeld.window_of_global` |
| `Nonvanishing.window_term_le`<br/>theorem, line 125 | (Real.log 2 * ((r : ℝ) - k) / (8 * Real.pi)) * (2 : ℝ) ^ (((r : ℝ) - k) / 2) ≤ (Real.log 2 * r / (8 * Real.pi)) * (2 : ℝ) ^ ((r : ℝ) / 2) * ((2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ k | hr : (n : ℤ) ≤ r; k : ℕ; hk : k ∈ range (n + 1) | Each windowed Schoenfeld bound is at most the top-of-window bound times `2^(−k/2)`: `(r−k) ≤ r` handles the linear factor and `rpow_add` splits the power. Needs `0 ≤ r − k` inside the window, supplied by `hr`. | — | `Nonvanishing.error_bound` |
| `Nonvanishing.error_bound`<br/>theorem, line 152 | \|stencilR n (fun x =&gt; f x - L x) r\| ≤ Ehigh r n | hr : (n : ℤ) ≤ r; hS : StmtSchoenfeldWindow f L r n | The error bound. Triangle inequality, the per-term comparison, and the binomial theorem `Σ C(n,k) t^k = (1+t)^n` at `t = 2^(−1/2)`. | `Nonvanishing.Ehigh`, `Nonvanishing.StmtSchoenfeldWindow`, `Nonvanishing.stencilR`, `Nonvanishing.window_term_le` | `Nonvanishing.nonvanishing_of` |
| `Nonvanishing.Mlow`<br/>def, line 178 | ℝ | r : ℤ; d : ℕ | The main-term floor `0.5 · 2^(r−d−1) · (log 2)^d / r`. O67's step 3. | — | `Expansion.hD_of_window`, `Expansion.tableFrom_ne_zero_of_li`, `MainTerm.tableFrom_ne_zero_of_deriv`, `Nonvanishing.nonvanishing_of`, `Nonvanishing.tableFrom_ne_zero_of`, `RelativeGate.nonvanishing_of_relErr`, `RelativeGate.relGate_iff`, `RelativeGate.tableFrom_ne_zero_of_relErr`, `RelativeLi.tableFrom_ne_zero_of_relErr_li`, `Schoenfeld.tableFrom_ne_zero_of_schoenfeld` |
| `Nonvanishing.nonvanishing_of`<br/>theorem, line 185 | stencilR (d + 1) f r ≠ 0 | hr : ((d + 1 : ℕ) : ℤ) ≤ r; hS : StmtSchoenfeldWindow f L r (d + 1); hM : Mlow r d ≤ \|stencilR (d + 1) L r\|; hgap : Ehigh r (d + 1) &lt; Mlow r d | The arrow. If Schoenfeld holds on the window (`hS`), the smooth main term clears its floor (`hM` — stage 2's target), and the floor beats the error ceiling (`hgap` — O67's `r ≥ R(d)` table), then the depth-`(d+1)` stencil of the counting function does not vanish. | `Nonvanishing.Ehigh`, `Nonvanishing.Mlow`, `Nonvanishing.StmtSchoenfeldWindow`, `Nonvanishing.error_bound`, `Nonvanishing.stencilR`, `Nonvanishing.stencilR_sub` | `Nonvanishing.tableFrom_ne_zero_of` |
| `Nonvanishing.tableFrom_ne_zero_of`<br/>theorem, line 201 | Construction.tableFrom N r d ≠ 0 | hrow : ∀ k ∈ range (d + 2), ((N (r - k) : ℤ) : ℝ) = bdiffZ f (r - k); hr : ((d + 1 : ℕ) : ℤ) ≤ r; hS : StmtSchoenfeldWindow f L r (d + 1); hM : Mlow r d ≤ \|stencilR (d + 1) L r\|; hgap : Ehigh r (d + 1) &lt; Mlow r d | Onto the integer table. If the integer row is the backward difference of a counting function `f` across the window a cell reads (cast to ℝ), then the cell's vanishing is the depth-`(d+1)` stencil of `f` vanishing — so the arrow above forbids it. The cast bridge is `Zeros.tableFrom_eq_stencil` plus `push_cast`. | `Construction.tableFrom`, `Nonvanishing.Ehigh`, `Nonvanishing.Mlow`, `Nonvanishing.StmtSchoenfeldWindow`, `Nonvanishing.bdiffZ`, `Nonvanishing.nonvanishing_of`, `Nonvanishing.stencilR`, `Nonvanishing.stencilR_row`, `Zeros.stencil`, `Zeros.tableFrom_eq_stencil` | `MainTerm.tableFrom_ne_zero_of_deriv` |
