# `lean_stage3/Stage3/WeilPowerShell.lean`

**What it does** (its own header): WeilPowerShell — one shell member's weighted sum, explicit. Rung 5, sixteenth slice; worksheet § 13 block 13f. 2026-09-06.

**Imports:** [`WeilPowerGeomGen`](../lean_stage3/WeilPowerGeomGen.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerNear`](../lean_stage3/WeilPowerNear.md).

```mermaid
flowchart LR
  n0["zOf<br/>(def)"]:::dfn
  n1["coef<br/>(def)"]:::dfn
  n2["uSh<br/>(def)"]:::dfn
  n3["shellSum<br/>(def)"]:::dfn
  n4["zOf_re<br/>⊢ (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2)"]:::thm
  n5["zOf_im<br/>⊢ (zOf e' D e).im = 4 * e' * D"]:::thm
  n6["norm_zOf_le<br/>⊢ ‖zOf e' D e‖ ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2)"]:::thm
  n7["norm_coef<br/>⊢ ‖coef e' D e‖ = (e' ^ 2 + D ^ 2) / e ^ 2"]:::thm
  n8["uSh_bracket<br/>⊢ ∀ k : ℕ, 0 ≤ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2…"]:::thm
  n9["sum_uSh_eq<br/>⊢ ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((WeilPo…"]:::thm
  n10["im_alpha_le<br/>⊢ (zOf e' D e).im * (1 / ((lam : ℝ) * Real.pi ^ 2)) ≤ Real.pi / 2"]:::thm
  n11["norm_zOf_c_le<br/>⊢ ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) ≤ (a : ℝ) + 1"]:::thm
  n12["exp_end_le<br/>⊢ Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) +…"]:::thm
  n13["MabGen_le<br/>⊢ WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (…"]:::thm
  n14["inv_exp_le<br/>⊢ 1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) ≤ Rea…"]:::thm
  n15["geomBound_le<br/>⊢ WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^…"]:::thm
  n16["shellSum_le<br/>⊢ |shellSum e' D e lam a b| ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * e…"]:::thm
  n17["shellSum_neg<br/>⊢ shellSum e' (-D) e lam a b = shellSum e' D e lam a b"]:::thm
  n18["shellSum_le_abs<br/>⊢ |shellSum e' D e lam a b| ≤ (e' ^ 2 + |D| ^ 2) / e ^ 2 * Real.exp (2 *…"]:::end_
  x0(["WeilPowerGeomGen · MabGen"]):::ext
  x1(["WeilPowerGeomGen · geomBoundGen"]):::ext
  x2(["WeilPowerGeomGen · norm_sum_exp_u_le_gen"]):::ext
  x3(["WeilPowerGeomGen · uLam"]):::ext
  x4(["WeilPowerGeomGen · uLam_bracket"]):::ext
  x5(["WeilPowerNear · re_term_eq"]):::ext
  x6(["WeilPowerNear · shellSum_nonneg"]):::ext
  x7(["WeilPowerNear · shellSum_nonneg_abs"]):::ext
  x8(["WeilPowerNear · term_nonneg"]):::ext
  n0 --> n10
  n0 --> n11
  n0 --> n12
  n0 --> n13
  n0 --> n14
  n0 --> n15
  n0 --> n16
  n0 --> n17
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n0 --> n9
  n0 --> x5
  n0 --> x8
  n1 --> n16
  n1 --> n17
  n1 --> n3
  n1 --> n7
  n1 --> n9
  n1 --> x5
  n1 --> x8
  n10 --> n16
  n11 --> n16
  n12 --> n13
  n12 --> n15
  n13 --> n16
  n14 --> n15
  n15 --> n16
  n16 --> n18
  n17 --> n18
  n17 --> x7
  n2 --> n16
  n2 --> n8
  n2 --> n9
  n3 --> n16
  n3 --> n17
  n3 --> n18
  n3 --> x6
  n3 --> x7
  n4 --> n12
  n4 --> x5
  n5 --> n10
  n5 --> n15
  n5 --> n16
  n5 --> x5
  n6 --> n11
  n6 --> n14
  n6 --> n16
  n7 --> n16
  n8 --> n16
  n9 --> n16
  x0 --> n13
  x0 --> n16
  x1 --> n15
  x1 --> n16
  x2 --> n16
  x3 --> n16
  x3 --> n17
  x3 --> n2
  x3 --> n3
  x3 --> n9
  x4 --> n8
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
| `WeilPowerShell.zOf`<br/>def, line 82 | ℂ | e' D e : ℝ | The exponent's coefficient at the shell member `ζ = ε' + iΔ` against the target at `ε`: `z = 2(ζ² − ε²)`. | — | `WeilPowerNear.re_term_eq`, `WeilPowerNear.term_nonneg`, `WeilPowerShell.MabGen_le`, `WeilPowerShell.exp_end_le`, `WeilPowerShell.geomBound_le`, `WeilPowerShell.im_alpha_le`, `WeilPowerShell.inv_exp_le`, `WeilPowerShell.norm_zOf_c_le`, `WeilPowerShell.norm_zOf_le`, `WeilPowerShell.shellSum`, `WeilPowerShell.shellSum_le`, `WeilPowerShell.shellSum_neg`, `WeilPowerShell.sum_uSh_eq`, `WeilPowerShell.zOf_im`, `WeilPowerShell.zOf_re` |
| `WeilPowerShell.coef`<br/>def, line 85 | ℂ | e' D e : ℝ | The member's weight relative to the target: `ζ²/ε²`. | — | `WeilPowerNear.re_term_eq`, `WeilPowerNear.term_nonneg`, `WeilPowerShell.norm_coef`, `WeilPowerShell.shellSum`, `WeilPowerShell.shellSum_le`, `WeilPowerShell.shellSum_neg`, `WeilPowerShell.sum_uSh_eq` |
| `WeilPowerShell.uSh`<br/>def, line 89 | ℝ | lam k : ℕ | `uLam` patched at `0` to the affine value, so that the bracket G7 of block 13e holds at every `k` and not only at `k ≥ 1`. | `WeilPowerGeomGen.uLam` | `WeilPowerShell.shellSum_le`, `WeilPowerShell.sum_uSh_eq`, `WeilPowerShell.uSh_bracket` |
| `WeilPowerShell.shellSum`<br/>def, line 93 | ℝ | e' D e : ℝ; lam a b : ℕ | One shell member's weighted sum over the range `[a, b)`. | `WeilPowerGeomGen.uLam`, `WeilPowerShell.coef`, `WeilPowerShell.zOf` | `WeilPowerNear.shellSum_nonneg`, `WeilPowerNear.shellSum_nonneg_abs`, `WeilPowerShell.shellSum_le`, `WeilPowerShell.shellSum_le_abs`, `WeilPowerShell.shellSum_neg` |
| `WeilPowerShell.zOf_re`<br/>theorem, line 98 | (zOf e' D e).re = 2 * (e' ^ 2 - D ^ 2 - e ^ 2) | e' D e : ℝ | The real part of the exponent's coefficient. | `WeilPowerShell.zOf` | `WeilPowerNear.re_term_eq`, `WeilPowerShell.exp_end_le` |
| `WeilPowerShell.zOf_im`<br/>theorem, line 102 | (zOf e' D e).im = 4 * e' * D | e' D e : ℝ | The imaginary part of the exponent's coefficient: the phase's rate. | `WeilPowerShell.zOf` | `WeilPowerNear.re_term_eq`, `WeilPowerShell.geomBound_le`, `WeilPowerShell.im_alpha_le`, `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.norm_zOf_le`<br/>theorem, line 107 | ‖zOf e' D e‖ ≤ 2 * (e' ^ 2 + D ^ 2 + e ^ 2) | e' D e : ℝ | The size of the exponent's coefficient. | `WeilPowerShell.zOf` | `WeilPowerShell.inv_exp_le`, `WeilPowerShell.norm_zOf_c_le`, `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.norm_coef`<br/>theorem, line 121 | ‖coef e' D e‖ = (e' ^ 2 + D ^ 2) / e ^ 2 | e' D e : ℝ | The member's weight, in size. | `WeilPowerShell.coef` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.uSh_bracket`<br/>theorem, line 128 | ∀ k : ℕ, 0 ≤ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uSh lam k - ((k : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((k : ℝ) + 1) | hl : 1 ≤ lam | The bracket G7 for the patched sequence, at every `k` including `0`. | `WeilPowerGeomGen.uLam_bracket`, `WeilPowerShell.uSh` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.sum_uSh_eq`<br/>theorem, line 152 | ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((WeilPowerGeomGen.uLam lam h : ℝ) : ℂ)) = ∑ h ∈ Finset.Ico a b, coef e' D e * Complex.exp (zOf e' D e * ((uSh lam h : ℝ) : ℂ)) | e' D e : ℝ; lam : ℕ; ha : 1 ≤ a | The patch does not change the sum: over `Ico a b` with `1 ≤ a` no index is `0`. | `WeilPowerGeomGen.uLam`, `WeilPowerShell.coef`, `WeilPowerShell.uSh`, `WeilPowerShell.zOf` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.im_alpha_le`<br/>theorem, line 164 | (zOf e' D e).im * (1 / ((lam : ℝ) * Real.pi ^ 2)) ≤ Real.pi / 2 | h1 : 0 &lt; e'; h2 : e' ≤ 1 / 2; h3 : 0 &lt; D; h4 : D ≤ 1 / 2; hl : 1 ≤ lam | Jordan's hypothesis G3 holds at the shell's phase: `4ε'Δ ≤ 1` and `1/(λπ²) ≤ 1/9 &lt; π/2`. | `WeilPowerShell.zOf`, `WeilPowerShell.zOf_im` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.norm_zOf_c_le`<br/>theorem, line 178 | ‖zOf e' D e‖ * (1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2)) ≤ (a : ℝ) + 1 | h1 : 0 &lt; e'; h2 : e' ≤ 1 / 2; h3 : 0 &lt; D; h4 : D ≤ 1 / 2; h5 : 0 &lt; e; h6 : e ≤ 1 / 2; hl : 1 ≤ lam; a : ℕ | The hypothesis G6 holds: `‖z‖ ≤ 3/2` and `c ≤ 1/18`, so the product is under `1 ≤ a + 1`. | `WeilPowerShell.norm_zOf_le`, `WeilPowerShell.zOf` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.exp_end_le`<br/>theorem, line 201 | Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2) * (k : ℝ) + -1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))) ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) | h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta; h8 : 0 ≤ eta; hl : 1 ≤ lam; ha : 1 ≤ a; hak : a ≤ k; hkb : k ≤ b | The geometric factor at an interior index is at most `M = e^{2ηb/(λπ²)}`: the exponent is nonnegative and at most `αb`, and `z.re ≤ 2η`. | `WeilPowerShell.zOf`, `WeilPowerShell.zOf_re` | `WeilPowerShell.MabGen_le`, `WeilPowerShell.geomBound_le` |
| `WeilPowerShell.MabGen_le`<br/>theorem, line 242 | WeilPowerGeomGen.MabGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) | h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta; h8 : 0 ≤ eta; hl : 1 ≤ lam; ha : 1 ≤ a; hab : a ≤ b | The endpoint factor is at most `M`. | `WeilPowerGeomGen.MabGen`, `WeilPowerShell.exp_end_le`, `WeilPowerShell.zOf` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.inv_exp_le`<br/>theorem, line 251 | 1 / Real.exp ((zOf e' D e).re * (1 / ((lam : ℝ) * Real.pi ^ 2))) ≤ Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) | e' D e : ℝ; lam : ℕ | The reciprocal of the ratio's modulus, bounded by the size of `z`. | `WeilPowerShell.norm_zOf_le`, `WeilPowerShell.zOf` | `WeilPowerShell.geomBound_le` |
| `WeilPowerShell.geomBound_le`<br/>theorem, line 263 | WeilPowerGeomGen.geomBoundGen (zOf e' D e) (1 / ((lam : ℝ) * Real.pi ^ 2)) (-1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) a b ≤ Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * (lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) / (4 * e' * D) | h1 : 0 &lt; e'; h3 : 0 &lt; D; h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta; h8 : 0 ≤ eta; hl : 1 ≤ lam; ha : 1 ≤ a; hab : a ≤ b | The geometric part of the shell member's bound, explicit in `ε', Δ, ε, η, λ, b`. | `WeilPowerGeomGen.geomBoundGen`, `WeilPowerShell.exp_end_le`, `WeilPowerShell.inv_exp_le`, `WeilPowerShell.zOf`, `WeilPowerShell.zOf_im` | `WeilPowerShell.shellSum_le` |
| `WeilPowerShell.shellSum_le`<br/>theorem, line 316 | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) / (4 * e' * D) + 2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a) / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) | h1 : 0 &lt; e'; h2 : e' ≤ 1 / 2; h3 : 0 &lt; D; h4 : D ≤ 1 / 2; h5 : 0 &lt; e; h6 : e ≤ 1 / 2; h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta; h8 : 0 ≤ eta; hl : 1 ≤ lam; ha : 1 ≤ a; hab : a ≤ b | One shell member's weighted sum, explicit. The geometric part does not grow with the range; the correction grows like its logarithm. | `WeilPowerGeomGen.MabGen`, `WeilPowerGeomGen.geomBoundGen`, `WeilPowerGeomGen.norm_sum_exp_u_le_gen`, `WeilPowerGeomGen.uLam`, `WeilPowerShell.MabGen_le`, `WeilPowerShell.coef`, `WeilPowerShell.geomBound_le`, `WeilPowerShell.im_alpha_le`, `WeilPowerShell.norm_coef`, `WeilPowerShell.norm_zOf_c_le`, `WeilPowerShell.norm_zOf_le`, `WeilPowerShell.shellSum`, `WeilPowerShell.sum_uSh_eq`, `WeilPowerShell.uSh`, `WeilPowerShell.uSh_bracket`, `WeilPowerShell.zOf`, `WeilPowerShell.zOf_im` | `WeilPowerShell.shellSum_le_abs` |
| `WeilPowerShell.shellSum_neg`<br/>theorem, line 454 | shellSum e' (-D) e lam a b = shellSum e' D e lam a b | e' D e : ℝ; lam a b : ℕ | The sum is even in `Δ`: the member at `ε' − iΔ` is the conjugate of the member at `ε' + iΔ`, and the real part does not see the conjugation. | `WeilPowerGeomGen.uLam`, `WeilPowerShell.coef`, `WeilPowerShell.shellSum`, `WeilPowerShell.zOf` | `WeilPowerNear.shellSum_nonneg_abs`, `WeilPowerShell.shellSum_le_abs` |
| `WeilPowerShell.shellSum_le_abs`<br/>theorem, line 474 | \|shellSum e' D e lam a b\| ≤ (e' ^ 2 + \|D\| ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2)) * ((lam : ℝ) * Real.pi ^ 3 * Real.exp (2 * (e' ^ 2 + \|D\| ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2))) / (4 * e' * \|D\|) + 2 * (e' ^ 2 + \|D\| ^ 2 + e ^ 2) * (Real.log b - Real.log a) / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) | h1 : 0 &lt; e'; h2 : e' ≤ 1 / 2; hD0 : D ≠ 0; h4 : \|D\| ≤ 1 / 2; h5 : 0 &lt; e; h6 : e ≤ 1 / 2; h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta; h8 : 0 ≤ eta; hl : 1 ≤ lam; ha : 1 ≤ a; hab : a ≤ b | The bound at a signed `Δ`, through the evenness. | `WeilPowerShell.shellSum`, `WeilPowerShell.shellSum_le`, `WeilPowerShell.shellSum_neg` | — |
