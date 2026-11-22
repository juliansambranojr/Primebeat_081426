# `lean_stage3/Stage3/WeilPowerNear.lean`

**What it does** (its own header): WeilPowerNear — the near members' sign. Rung 5, seventeenth slice; worksheet § 13 block 13g. 2026-09-07.

**Imports:** [`WeilPowerShell`](../lean_stage3/WeilPowerShell.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerAssembly`](../lean_stage3/WeilPowerAssembly.md).

```mermaid
flowchart LR
  n0["uLam_nonneg<br/>⊢ 0 ≤ WeilPowerGeomGen.uLam lam h"]:::thm
  n1["uLam_le<br/>⊢ WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)"]:::thm
  n2["cos_ge_lin<br/>⊢ 1 - 2 * θ / Real.pi ≤ Real.cos θ"]:::thm
  n3["bracket_nonneg<br/>⊢ 0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ"]:::thm
  n4["re_term_eq<br/>⊢ (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e *…"]:::thm
  n5["phase_le<br/>⊢ 4 * e' * D * WeilPowerGeomGen.uLam lam h ≤ 4 * e' * D * ((b : ℝ) / ((l…"]:::thm
  n6["term_nonneg<br/>⊢ 0 ≤ (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D…"]:::thm
  n7["shellSum_nonneg<br/>⊢ 0 ≤ WeilPowerShell.shellSum e' D e lam a b"]:::thm
  n8["shellSum_nonneg_abs<br/>⊢ 0 ≤ WeilPowerShell.shellSum e' D e lam a b"]:::end_
  x0(["WeilPowerGeomGen · uLam"]):::ext
  x1(["WeilPowerGeomGen · uLam_bracket"]):::ext
  x2(["WeilPowerPhase · sigma_ge"]):::ext
  x3(["WeilPowerShell · coef"]):::ext
  x4(["WeilPowerShell · shellSum"]):::ext
  x5(["WeilPowerShell · shellSum_neg"]):::ext
  x6(["WeilPowerShell · zOf"]):::ext
  x7(["WeilPowerShell · zOf_im"]):::ext
  x8(["WeilPowerShell · zOf_re"]):::ext
  n0 --> n6
  n1 --> n5
  n2 --> n3
  n3 --> n6
  n4 --> n6
  n5 --> n6
  n6 --> n7
  n7 --> n8
  x0 --> n0
  x0 --> n1
  x0 --> n5
  x0 --> n6
  x1 --> n1
  x2 --> n0
  x3 --> n4
  x3 --> n6
  x4 --> n7
  x4 --> n8
  x5 --> n8
  x6 --> n4
  x6 --> n6
  x7 --> n4
  x8 --> n4
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
| `WeilPowerNear.uLam_nonneg`<br/>theorem, line 61 | 0 ≤ WeilPowerGeomGen.uLam lam h | lam h : ℕ | The window's phase argument is nonnegative at every `h`. | `WeilPowerGeomGen.uLam`, `WeilPowerPhase.sigma_ge` | `WeilPowerNear.term_nonneg` |
| `WeilPowerNear.uLam_le`<br/>theorem, line 70 | WeilPowerGeomGen.uLam lam h ≤ (h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) | hl : 1 ≤ lam; hh : 1 ≤ h | The upper half of `uLam_bracket`, with the intercept absorbed: the correction `1/(2λ³π²(h+1))` is under `1/(2λ²π²)` exactly when `λ(h+1) ≥ 1`. | `WeilPowerGeomGen.uLam`, `WeilPowerGeomGen.uLam_bracket` | `WeilPowerNear.phase_le` |
| `WeilPowerNear.cos_ge_lin`<br/>theorem, line 84 | 1 - 2 * θ / Real.pi ≤ Real.cos θ | h0 : 0 ≤ θ; h1 : θ ≤ Real.pi / 2 | `cos` above its chord on `[0, π/2]`: `Real.mul_le_sin` at `π/2 − θ`. | — | `WeilPowerNear.bracket_nonneg` |
| `WeilPowerNear.bracket_nonneg`<br/>theorem, line 96 | 0 ≤ (e' ^ 2 - D ^ 2) * Real.cos θ - 2 * e' * D * Real.sin θ | h1 : 0 &lt; e'; h3 : 0 &lt; D; hD : D &lt; e'; h0 : 0 ≤ θ; hθ : θ * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2 | The bracket's sign under the crude condition N2. | `WeilPowerNear.cos_ge_lin` | `WeilPowerNear.term_nonneg` |
| `WeilPowerNear.re_term_eq`<br/>theorem, line 141 | (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * (u : ℂ))).re = Real.exp (2 * (e' ^ 2 - D ^ 2 - e ^ 2) * u) / e ^ 2 * ((e' ^ 2 - D ^ 2) * Real.cos (4 * e' * D * u) - 2 * e' * D * Real.sin (4 * e' * D * u)) | e' D e u : ℝ; he : e ≠ 0 | The weighted term's real part, explicit. | `WeilPowerShell.coef`, `WeilPowerShell.zOf`, `WeilPowerShell.zOf_im`, `WeilPowerShell.zOf_re` | `WeilPowerNear.term_nonneg` |
| `WeilPowerNear.phase_le`<br/>theorem, line 166 | 4 * e' * D * WeilPowerGeomGen.uLam lam h ≤ 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) | h1 : 0 &lt; e'; h3 : 0 &lt; D; hl : 1 ≤ lam; hh : 1 ≤ h; hhb : h ≤ b | The phase is largest at the top of the range. | `WeilPowerGeomGen.uLam`, `WeilPowerNear.uLam_le` | `WeilPowerNear.term_nonneg` |
| `WeilPowerNear.term_nonneg`<br/>theorem, line 177 | 0 ≤ (WeilPowerShell.coef e' D e * Complex.exp (WeilPowerShell.zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ))).re | h1 : 0 &lt; e'; h3 : 0 &lt; D; hD : D &lt; e'; h5 : 0 &lt; e; hl : 1 ≤ lam; hh : 1 ≤ h; hhb : h ≤ b; hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2 | One near member's term is nonnegative at every `h` in the range. | `WeilPowerGeomGen.uLam`, `WeilPowerNear.bracket_nonneg`, `WeilPowerNear.phase_le`, `WeilPowerNear.re_term_eq`, `WeilPowerNear.uLam_nonneg`, `WeilPowerShell.coef`, `WeilPowerShell.zOf` | `WeilPowerNear.shellSum_nonneg` |
| `WeilPowerNear.shellSum_nonneg`<br/>theorem, line 196 | 0 ≤ WeilPowerShell.shellSum e' D e lam a b | h1 : 0 &lt; e'; h3 : 0 &lt; D; hD : D &lt; e'; h5 : 0 &lt; e; hl : 1 ≤ lam; ha : 1 ≤ a; hN : 4 * e' * D * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (2 * e' * D + 2 * (e' ^ 2 - D ^ 2) / Real.pi) ≤ e' ^ 2 - D ^ 2 | The near member's shell sum is nonnegative: it helps the target. | `WeilPowerNear.term_nonneg`, `WeilPowerShell.shellSum` | `WeilPowerNear.shellSum_nonneg_abs` |
| `WeilPowerNear.shellSum_nonneg_abs`<br/>theorem, line 208 | 0 ≤ WeilPowerShell.shellSum e' D e lam a b | h1 : 0 &lt; e'; hD0 : D ≠ 0; hD : \|D\| &lt; e'; h5 : 0 &lt; e; hl : 1 ≤ lam; ha : 1 ≤ a; hN : 4 * e' * \|D\| * ((b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (2 * e' * \|D\| + 2 * (e' ^ 2 - \|D\| ^ 2) / Real.pi) ≤ e' ^ 2 - \|D\| ^ 2 | The same with `\|Δ\|`, the sign of `Δ` split off through `shellSum_neg`. | `WeilPowerNear.shellSum_nonneg`, `WeilPowerShell.shellSum`, `WeilPowerShell.shellSum_neg` | — |
