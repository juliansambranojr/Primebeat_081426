# `lean_stage3/Stage3/PerronKernel.lean`

**What it does** (its own header): # Slice 1a — the truncated Perron kernel bound (hEF's entry point) COMPLETE, 2026-08-29: every branch proved, no sorry. `perron_kernel_truncated` sits at `[propext, Classical.choice, Quot.sound]`. (Build order: entry 257; ledger: CONTEXT.md § hEF, roadmap D. This was hEF's load-bearing unknown — the piece both MediumPNT and StrongPNT were designed to avoid.)

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ContourShift`](../lean_stage3/ContourShift.md).

```mermaid
flowchart LR
  n0["perronI<br/>(def)"]:::dfn
  n1["perronδ<br/>(def)"]:::dfn
  n2["perronI_eq_VIntegral'<br/>⊢ perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T"]:::thm
  n3["kernel_holo<br/>⊢ HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ | 0 ＜ s.re}"]:::thm
  n4["rect_subset_right<br/>⊢ Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ…"]:::thm
  n5["perron_kernel_coarse_lt<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c"]:::thm
  n6["horiz_bound<br/>⊢ ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + …"]:::thm
  n7["perron_kernel_decay_lt<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|)"]:::thm
  n8["dslope_kernel_diff<br/>⊢ Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0)"]:::thm
  n9["rect_residue<br/>⊢ RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) (-(X:ℂ) - Complex.I *…"]:::thm
  n10["perron_kernel_decay_gt<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|)"]:::thm
  n11["perron_kernel_decay<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * |Real.log y|)"]:::thm
  n12["coarse_gt_ineq<br/>⊢ v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u"]:::thm
  n13["seg_inv_integral<br/>⊢ (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I) = 2 * Real.a…"]:::thm
  n14["cpow_sub_one_bound<br/>⊢ ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re"]:::thm
  n15["perron_kernel_coarse_gt<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c"]:::thm
  n16["perron_kernel_coarse<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c"]:::thm
  n17["perron_kernel_truncated<br/>⊢ ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * |Real.log y|))"]:::thm
  n18["one_sub_two_neg_rpow<br/>⊢ δ / 5 ≤ 1 - (2:ℝ) ^ (-δ)"]:::thm
  n19["vonMangoldt_rpow_partial<br/>⊢ ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real…"]:::thm
  n20["vonMangoldt_rpow_tsum<br/>⊢ ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Rea…"]:::thm
  n21["vonMangoldt_rpow_summable<br/>⊢ Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c…"]:::thm
  n22["far_terms_sum<br/>⊢ (∑' n : ℕ, if 1/2 ≤ |Real.log (x / n)| then ArithmeticFunction.vonMang…"]:::thm
  n23["abs_sub_one_le_two_abs_log<br/>⊢ |t - 1| / 2 ≤ |Real.log t|"]:::thm
  n24["near_diagonal_sum<br/>⊢ (∑' n : ℕ, if 0 ＜ |Real.log (x / n)| ∧ |Real.log (x / n)| ＜ 1/2 then A…"]:::thm
  n25["perronI_one_norm<br/>⊢ ‖perronI 1 c T‖ ≤ 1/2"]:::thm
  n26["kernel_sum_bound<br/>⊢ ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1…"]:::thm
  n27["delta_sum_close<br/>⊢ ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n :…"]:::thm
  n28["kernel_diff_summable<br/>⊢ Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perron…"]:::thm
  n29["perron_to_psi<br/>⊢ ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n :…"]:::thm
  n30["tsum_vonMangoldt_div_cpow<br/>⊢ (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * ((x / n : ℝ) : ℂ) …"]:::thm
  n31["perron_sum_eq_integral<br/>⊢ (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 +…"]:::thm
  n32["explicit_formula_perron<br/>⊢ ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)…"]:::thm
  x0(["Glue · explicit_formula_poly"]):::ext
  x1(["GlueFloor · explicit_formula_split"]):::ext
  x2(["GlueNum · explicit_formula_split_num"]):::ext
  n0 --> n10
  n0 --> n11
  n0 --> n15
  n0 --> n16
  n0 --> n17
  n0 --> n2
  n0 --> n25
  n0 --> n26
  n0 --> n28
  n0 --> n29
  n0 --> n31
  n0 --> n5
  n0 --> n7
  n10 --> n11
  n10 --> n15
  n11 --> n17
  n12 --> n15
  n13 --> n15
  n13 --> n25
  n14 --> n15
  n15 --> n16
  n16 --> n17
  n17 --> n26
  n17 --> n28
  n18 --> n22
  n19 --> n20
  n19 --> n21
  n2 --> n10
  n2 --> n5
  n2 --> n7
  n20 --> n22
  n21 --> n22
  n21 --> n26
  n21 --> n28
  n21 --> n31
  n22 --> n26
  n23 --> n24
  n24 --> n26
  n25 --> n26
  n25 --> n28
  n26 --> n29
  n27 --> n29
  n28 --> n29
  n29 --> n32
  n3 --> n5
  n3 --> n7
  n30 --> n31
  n31 --> n32
  n32 --> x0
  n32 --> x1
  n32 --> x2
  n4 --> n5
  n4 --> n7
  n5 --> n16
  n6 --> n10
  n6 --> n7
  n7 --> n11
  n8 --> n9
  n9 --> n10
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
| `PerronKernel.perronI`<br/>def, line 46 | ℂ | y c T : ℝ | The truncated Perron integral `(2πi)⁻¹ ∫_{c-iT}^{c+iT} y^s/s ds`, parametrised on the vertical segment. | — | `PerronKernel.kernel_diff_summable`, `PerronKernel.kernel_sum_bound`, `PerronKernel.perronI_eq_VIntegral'`, `PerronKernel.perronI_one_norm`, `PerronKernel.perron_kernel_coarse`, `PerronKernel.perron_kernel_coarse_gt`, `PerronKernel.perron_kernel_coarse_lt`, `PerronKernel.perron_kernel_decay`, `PerronKernel.perron_kernel_decay_gt`, `PerronKernel.perron_kernel_decay_lt`, `PerronKernel.perron_kernel_truncated`, `PerronKernel.perron_sum_eq_integral`, `PerronKernel.perron_to_psi` |
| `PerronKernel.perronδ`<br/>def, line 52 | ℂ | y : ℝ | The target of the kernel: the indicator of `1 &lt; y`. | — | — |
| `PerronKernel.perronI_eq_VIntegral'`<br/>theorem, line 55 | perronI y c T = VIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) c (-T) T | y c T : ℝ | `perronI` is PNT+'s right-edge `VIntegral'` of the kernel. | `PerronKernel.perronI` | `PerronKernel.perron_kernel_coarse_lt`, `PerronKernel.perron_kernel_decay_gt`, `PerronKernel.perron_kernel_decay_lt` |
| `PerronKernel.kernel_holo`<br/>theorem, line 69 | HolomorphicOn (fun s : ℂ ↦ (y : ℂ) ^ s / s) {s : ℂ \| 0 &lt; s.re} | hy : 0 &lt; y | The kernel is holomorphic on the open right half-plane. | — | `PerronKernel.perron_kernel_coarse_lt`, `PerronKernel.perron_kernel_decay_lt` |
| `PerronKernel.rect_subset_right`<br/>theorem, line 81 | Rectangle ((c : ℂ) - Complex.I * T) ((X : ℂ) + Complex.I * T) ⊆ {s : ℂ \| 0 &lt; s.re} | hc : 0 &lt; c; hcX : c ≤ X | A rectangle with left edge at `c &gt; 0` sits in the right half-plane. | — | `PerronKernel.perron_kernel_coarse_lt`, `PerronKernel.perron_kernel_decay_lt` |
| `PerronKernel.perron_kernel_coarse_lt`<br/>theorem, line 96 | ‖perronI y c T - perronδ y‖ ≤ y ^ c | hy : 0 &lt; y; hylt : y &lt; 1; hc : 0 &lt; c; hT : 1 ≤ T | K1, case `y &lt; 1`. A single finite rectangle of width `T`: crude endpoint bounds on all three far edges give `(2/π)·y^c` — no limits. | `PerronKernel.kernel_holo`, `PerronKernel.perronI`, `PerronKernel.perronI_eq_VIntegral'`, `PerronKernel.rect_subset_right` | `PerronKernel.perron_kernel_coarse` |
| `PerronKernel.horiz_bound`<br/>theorem, line 211 | ‖∫ σ in a..b, (y : ℂ) ^ ((σ : ℂ) + (T' : ℂ) * Complex.I) / ((σ : ℂ) + (T' : ℂ) * Complex.I)‖ ≤ max (y ^ a) (y ^ b) / (\|T'\| * \|Real.log y\|) | hy : 0 &lt; y; hy1 : y ≠ 1; hT : 1 ≤ \|T'\|; hab : a ≤ b | The shared horizontal-edge estimate: along `Im s = T'` with `\|T'\| ≥ 1`, the kernel's horizontal integral is controlled by the endpoint powers over `\|T'\|·\|log y\|`. Every rectangle in both decay cases consumes this. | — | `PerronKernel.perron_kernel_decay_gt`, `PerronKernel.perron_kernel_decay_lt` |
| `PerronKernel.perron_kernel_decay_lt`<br/>theorem, line 299 | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) | hy : 0 &lt; y; hylt : y &lt; 1; hc : 0 &lt; c; hT : 1 ≤ T | K2, case `y &lt; 1`. No pole; rectangles to `+∞` along the naturals, `horiz_bound` on both edges, the far vertical vanishes in the limit. | `PerronKernel.horiz_bound`, `PerronKernel.kernel_holo`, `PerronKernel.perronI`, `PerronKernel.perronI_eq_VIntegral'`, `PerronKernel.rect_subset_right` | `PerronKernel.perron_kernel_decay` |
| `PerronKernel.dslope_kernel_diff`<br/>theorem, line 409 | Differentiable ℂ (dslope (fun s : ℂ ↦ (y : ℂ) ^ s) 0) | hy : 0 &lt; y | The kernel's regular part at the pole: `dslope` of `y^s` at `0` is entire. | — | `PerronKernel.rect_residue` |
| `PerronKernel.rect_residue`<br/>theorem, line 428 | RectangleIntegral' (fun s : ℂ ↦ (y : ℂ) ^ s / s) (-(X:ℂ) - Complex.I * T) ((c:ℂ) + Complex.I * T) = 1 | hy : 0 &lt; y; hc : 0 &lt; c; hT : 0 &lt; T; hX : 0 &lt; X | The pole, crossed once: the rectangle boundary integral of the kernel around `0` is `1` after `(2πi)⁻¹` normalisation. | `PerronKernel.dslope_kernel_diff` | `PerronKernel.perron_kernel_decay_gt` |
| `PerronKernel.perron_kernel_decay_gt`<br/>theorem, line 461 | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) | hygt : 1 &lt; y; hc : 0 &lt; c; hT : 1 ≤ T | K2, case `y &gt; 1`. The rectangle to `−∞` collects the residue `1 = perronδ y`; `horiz_bound` on both edges, far vertical dies. | `PerronKernel.horiz_bound`, `PerronKernel.perronI`, `PerronKernel.perronI_eq_VIntegral'`, `PerronKernel.rect_residue` | `PerronKernel.perron_kernel_coarse_gt`, `PerronKernel.perron_kernel_decay` |
| `PerronKernel.perron_kernel_decay`<br/>theorem, line 585 | ‖perronI y c T - perronδ y‖ ≤ y ^ c / (T * \|Real.log y\|) | hy : 0 &lt; y; hy1 : y ≠ 1; hc : 0 &lt; c; hT : 1 ≤ T | K2 — the decay branch, assembled from its two cases. | `PerronKernel.perronI`, `PerronKernel.perron_kernel_decay_gt`, `PerronKernel.perron_kernel_decay_lt` | `PerronKernel.perron_kernel_truncated` |
| `PerronKernel.coarse_gt_ineq`<br/>theorem, line 595 | v * Real.exp u + Real.pi - Real.arctan (v / u) ≤ Real.pi * Real.exp u | hu : 0 &lt; u; hv0 : 0 &lt; v; hv1 : v ≤ 1 | The elementary two-variable inequality behind K1's `y &gt; 1` case, in multiplied (division-free) form: for `u = c·log y &gt; 0`, `v = T·log y ∈ (0,1]`, `v·e^u + π − arctan(v/u) ≤ π·e^u`. | — | `PerronKernel.perron_kernel_coarse_gt` |
| `PerronKernel.seg_inv_integral`<br/>theorem, line 639 | (∫ t in (-T)..T, ((c : ℂ) + Complex.I * t)⁻¹ * Complex.I) = 2 * Real.arctan (T / c) * Complex.I | hc : 0 &lt; c | The segment integral of `1/s`: pure real calculus — the odd part cancels by its antiderivative, the even part is the arctan derivative. | — | `PerronKernel.perronI_one_norm`, `PerronKernel.perron_kernel_coarse_gt` |
| `PerronKernel.cpow_sub_one_bound`<br/>theorem, line 716 | ‖(y : ℂ) ^ s - 1‖ ≤ ‖s‖ * Real.log y * y ^ s.re | hygt : 1 &lt; y; hre : 0 ≤ s.re | Mean-value bound: `‖y^s − 1‖ ≤ ‖s‖·log y·y^(re s)` for `y &gt; 1`. | — | `PerronKernel.perron_kernel_coarse_gt` |
| `PerronKernel.perron_kernel_coarse_gt`<br/>theorem, line 770 | ‖perronI y c T - perronδ y‖ ≤ y ^ c | hygt : 1 &lt; y; hc : 0 &lt; c; hT : 1 ≤ T | K1, case `y &gt; 1`. For `T·log y ≥ 1` this is the decay branch; below that, split off the exact `∫ ds/s`, mean-value the rest, and close with `coarse_gt_ineq`. | `PerronKernel.coarse_gt_ineq`, `PerronKernel.cpow_sub_one_bound`, `PerronKernel.perronI`, `PerronKernel.perron_kernel_decay_gt`, `PerronKernel.seg_inv_integral` | `PerronKernel.perron_kernel_coarse` |
| `PerronKernel.perron_kernel_coarse`<br/>theorem, line 921 | ‖perronI y c T - perronδ y‖ ≤ y ^ c | hy : 0 &lt; y; hy1 : y ≠ 1; hc : 0 &lt; c; hT : 1 ≤ T | K1 — the coarse branch, assembled from its two cases. | `PerronKernel.perronI`, `PerronKernel.perron_kernel_coarse_gt`, `PerronKernel.perron_kernel_coarse_lt` | `PerronKernel.perron_kernel_truncated` |
| `PerronKernel.perron_kernel_truncated`<br/>theorem, line 930 | ‖perronI y c T - perronδ y‖ ≤ y ^ c * min 1 (1 / (T * \|Real.log y\|)) | hy : 0 &lt; y; hy1 : y ≠ 1; hc : 0 &lt; c; hT : 1 ≤ T | Slice 1a — the truncated Perron kernel bound. Assembled from K1 and K2; the two branches are the whole of the missing mathematics. | `PerronKernel.perronI`, `PerronKernel.perron_kernel_coarse`, `PerronKernel.perron_kernel_decay` | `PerronKernel.kernel_diff_summable`, `PerronKernel.kernel_sum_bound` |
| `PerronKernel.one_sub_two_neg_rpow`<br/>theorem, line 950 | δ / 5 ≤ 1 - (2:ℝ) ^ (-δ) | h0 : 0 &lt; δ; h1 : δ ≤ 1 | Geometric-denominator bound: `δ/5 ≤ 1 − 2^(−δ)` for `0 &lt; δ ≤ 1`. | — | `PerronKernel.far_terms_sum` |
| `PerronKernel.vonMangoldt_rpow_partial`<br/>theorem, line 977 | ∑ n ∈ s, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) | hc1 : 1 &lt; c; s : Finset ℕ | The dyadic partial-sum bound: any finite piece of `Σ Λ(n)·n^(−c)` sits under `2(log 4 + 4)/(1 − 2^(1−c))`. | — | `PerronKernel.vonMangoldt_rpow_summable`, `PerronKernel.vonMangoldt_rpow_tsum` |
| `PerronKernel.vonMangoldt_rpow_tsum`<br/>theorem, line 1082 | ∑' n : ℕ, ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c) ≤ 2 * (Real.log 4 + 4) / (1 - (2:ℝ) ^ (1 - c)) | hc1 : 1 &lt; c | The full sum, as a tsum. | `PerronKernel.vonMangoldt_rpow_partial` | `PerronKernel.far_terms_sum` |
| `PerronKernel.vonMangoldt_rpow_summable`<br/>theorem, line 1090 | Summable (fun n : ℕ ↦ ArithmeticFunction.vonMangoldt n * (n : ℝ) ^ (-c)) | hc1 : 1 &lt; c | — | `PerronKernel.vonMangoldt_rpow_partial` | `PerronKernel.far_terms_sum`, `PerronKernel.kernel_diff_summable`, `PerronKernel.kernel_sum_bound`, `PerronKernel.perron_sum_eq_integral` |
| `PerronKernel.far_terms_sum`<br/>theorem, line 1098 | (∑' n : ℕ, if 1/2 ≤ \|Real.log (x / n)\| then ArithmeticFunction.vonMangoldt n * (x / n) ^ (1 + 1/Real.log x) / (T * \|Real.log (x / n)\|) else 0) ≤ 300 * x * Real.log (x * T) ^ 2 / T | hx : 16 ≤ x; hT : 1 ≤ T | Slice 1b — the far-terms sum. | `PerronKernel.one_sub_two_neg_rpow`, `PerronKernel.vonMangoldt_rpow_summable`, `PerronKernel.vonMangoldt_rpow_tsum` | `PerronKernel.kernel_sum_bound` |
| `PerronKernel.abs_sub_one_le_two_abs_log`<br/>theorem, line 1238 | \|t - 1\| / 2 ≤ \|Real.log t\| | h1 : 1/2 ≤ t; h2 : t ≤ 2 | `\|t − 1\|/2 ≤ \|log t\|` on `[1/2, 2]`. | — | `PerronKernel.near_diagonal_sum` |
| `PerronKernel.near_diagonal_sum`<br/>theorem, line 1261 | (∑' n : ℕ, if 0 &lt; \|Real.log (x / n)\| ∧ \|Real.log (x / n)\| &lt; 1/2 then ArithmeticFunction.vonMangoldt n * min 1 (1/(T * \|Real.log (x / n)\|)) else 0) ≤ 100 * x * Real.log (x * T) ^ 2 / T + 4 * Real.log x | hx : 16 ≤ x; hT : 1 ≤ T | Slice 1c — the near-diagonal sum. | `PerronKernel.abs_sub_one_le_two_abs_log` | `PerronKernel.kernel_sum_bound` |
| `PerronKernel.perronI_one_norm`<br/>theorem, line 1560 | ‖perronI 1 c T‖ ≤ 1/2 | hc : 0 &lt; c | The kernel at `y = 1`, directly: `‖perronI 1 c T‖ ≤ 1/2`. | `PerronKernel.perronI`, `PerronKernel.seg_inv_integral` | `PerronKernel.kernel_diff_summable`, `PerronKernel.kernel_sum_bound` |
| `PerronKernel.kernel_sum_bound`<br/>theorem, line 1595 | ‖(∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n)))‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 12 * Real.log x | hx : 16 ≤ x; hT : 1 ≤ T | Slice 1's analytic composition. The summed kernel error. | `PerronKernel.far_terms_sum`, `PerronKernel.near_diagonal_sum`, `PerronKernel.perronI`, `PerronKernel.perronI_one_norm`, `PerronKernel.perron_kernel_truncated`, `PerronKernel.vonMangoldt_rpow_summable` | `PerronKernel.perron_to_psi` |
| `PerronKernel.delta_sum_close`<br/>theorem, line 1895 | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronδ (x / n)‖ ≤ Real.log x | hx : 16 ≤ x | The δ-side of the composition: the indicator sum is `ψ` up to one von Mangoldt value at the possible integer point. | — | `PerronKernel.perron_to_psi` |
| `PerronKernel.kernel_diff_summable`<br/>theorem, line 2012 | Summable (fun n : ℕ ↦ (ArithmeticFunction.vonMangoldt n : ℂ) * (perronI (x/n) (1 + 1/Real.log x) T - perronδ (x/n))) | hx : 16 ≤ x; hT : 1 ≤ T | Summability of the kernel differences, via the crude majorant `Λ(n)·(x/n)^c` — sharp enough for convergence, everywhere. | `PerronKernel.perronI`, `PerronKernel.perronI_one_norm`, `PerronKernel.perron_kernel_truncated`, `PerronKernel.vonMangoldt_rpow_summable` | `PerronKernel.perron_to_psi` |
| `PerronKernel.perron_to_psi`<br/>theorem, line 2071 | ‖(Chebyshev.psi x : ℂ) - ∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 13 * Real.log x | hx : 16 ≤ x; hT : 1 ≤ T | Slice 1 — the Perron-to-ψ bound. The truncated Perron sum of the von Mangoldt function misses `ψ` by at most `600·x·log(xT)²/T + 13·log x`. | `PerronKernel.delta_sum_close`, `PerronKernel.kernel_diff_summable`, `PerronKernel.kernel_sum_bound`, `PerronKernel.perronI` | `PerronKernel.explicit_formula_perron` |
| `PerronKernel.tsum_vonMangoldt_div_cpow`<br/>theorem, line 2120 | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * ((x / n : ℝ) : ℂ) ^ s) = (- deriv riemannZeta s / riemannZeta s) * ((x:ℝ):ℂ) ^ s | hx0 : 0 &lt; x; hs : 1 &lt; s.re | The Dirichlet-series identity under the integral: at `re s = c &gt; 1`, `Σ Λ(n)·(x/n)^s = (−ζ′/ζ)(s)·x^s`. | — | `PerronKernel.perron_sum_eq_integral` |
| `PerronKernel.perron_sum_eq_integral`<br/>theorem, line 2171 | (∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) * perronI (x/n) (1 + 1/Real.log x) T) = (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)) * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I | hx : 16 ≤ x; hT : 1 ≤ T | The Fubini. The kernel sum IS the truncated `−ζ′/ζ` contour integral. | `PerronKernel.perronI`, `PerronKernel.tsum_vonMangoldt_div_cpow`, `PerronKernel.vonMangoldt_rpow_summable` | `PerronKernel.explicit_formula_perron` |
| `PerronKernel.explicit_formula_perron`<br/>theorem, line 2340 | ‖(Chebyshev.psi x : ℂ) - (2 * (Real.pi:ℂ) * Complex.I)⁻¹ * ∫ t in (-T)..T, (- deriv riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / riemannZeta (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t)) * ((x:ℝ):ℂ) ^ (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) / (((1 + 1/Real.log x : ℝ):ℂ) + Complex.I * t) * Complex.I‖ ≤ 600 * x * Real.log (x * T) ^ 2 / T + 13 * Real.log x | hx : 16 ≤ x; hT : 1 ≤ T | hEF, Perron form — the truncated explicit formula at the line `re = c`. `ψ` misses the truncated `−ζ′/ζ` integral by `600·x·log(xT)²/T + 13·log x`. | `PerronKernel.perron_sum_eq_integral`, `PerronKernel.perron_to_psi` | `Glue.explicit_formula_poly`, `Glue.explicit_formula_split`, `Glue.explicit_formula_split_num` |
