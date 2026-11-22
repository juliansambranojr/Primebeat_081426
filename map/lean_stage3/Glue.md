# `lean_stage3/Stage3/Glue.lean`

**What it does** (its own header): # The glue — assembling StmtExplicitFormula from the four slices Pieces, in build order: - the band count and the `zeroPartialSum` swap (`T′ → T`), - the edge-integral estimates (S3's pointwise bounds integrated), - the rectangle-edge splitting matching S1's line integral, - the final assembly in the `T ≤ x²` regime + the consumer patch.

**Imports:** [`EdgeBound`](../lean_stage3/EdgeBound.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`AssemblyFloor`](../lean_stage3/AssemblyFloor.md).

```mermaid
flowchart LR
  n0["band_order_sum_le<br/>⊢ ∃ C : ℝ, 0 ＜ C ∧ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZet…"]:::thm
  n1["zeroPartialSum_swap<br/>⊢ ∃ C : ℝ, 0 ＜ C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → …"]:::thm
  n2["Gf<br/>(def)"]:::dfn
  n3["zeta_logderiv_good_bound<br/>⊢ ∃ C : ℝ, 0 ＜ C ∧ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, …"]:::thm
  n4["edge_horizontal_bound<br/>⊢ ∃ C : ℝ, 0 ＜ C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) →…"]:::thm
  n5["Gf_norm_conj<br/>⊢ ‖Gf x ((starRingEnd ℂ) u)‖ = ‖Gf x u‖"]:::end_
  n6["edge_left_bound<br/>⊢ ∃ C : ℝ, 0 ＜ C ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral…"]:::thm
  n7["explicit_formula_poly<br/>⊢ ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖…"]:::thm
  n8["stmtEF_poly<br/>⊢ ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ Stage3.StmtExplicitFormulaPoly c₁ c₂ 16"]:::thm
  x0(["Assembly · StmtExplicitFormulaPoly"]):::ext
  x1(["Assembly · zeroPartialSum"]):::ext
  x2(["AssemblyFloor · schoenfeldWeak_floor_of_RH"]):::ext
  x3(["ContourShift · goodT_exists"]):::ext
  x4(["ContourShift · mem_zetaWindow"]):::ext
  x5(["ContourShift · residue_identity"]):::ext
  x6(["ContourShift · zeroGap"]):::ext
  x7(["ContourShift · zeroGap_le"]):::ext
  x8(["ContourShift · zeroGap_pos"]):::ext
  x9(["ContourShift · zeroPartialSum_eq_sum"]):::ext
  x10(["ContourShift · zeta_analyticAt"]):::ext
  x11(["ContourShift · zeta_ne_zero_of_re_mem"]):::ext
  x12(["ContourShift · zeta_order_conj"]):::ext
  x13(["ContourShift · zeta_order_reflect"]):::ext
  x14(["ContourShift · zeta_zeros_rectangle_finite"]):::ext
  x15(["EdgeBound · ball_zero_shape"]):::ext
  x16(["EdgeBound · deriv_zeta_conj"]):::ext
  x17(["EdgeBound · edge_bound_core"]):::ext
  x18(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x19(["GlueFloor · edge_left_sharp"]):::ext
  x20(["GlueFloor · explicit_formula_split"]):::ext
  x21(["GlueNum · edge_horizontal_bound_num"]):::ext
  x22(["GlueNum · edge_left_sharp_num"]):::ext
  x23(["GlueNum · explicit_formula_split_num"]):::ext
  x24(["JensenCount · zetaWindow_finite"]):::ext
  x25(["JensenCount · zeta_local_zero_count"]):::ext
  x26(["PerronKernel · explicit_formula_perron"]):::ext
  n0 --> n1
  n1 --> n7
  n1 --> x20
  n2 --> n4
  n2 --> n5
  n2 --> n6
  n2 --> n7
  n2 --> x19
  n2 --> x20
  n2 --> x21
  n2 --> x22
  n2 --> x23
  n3 --> n4
  n4 --> n7
  n4 --> x20
  n6 --> n7
  n7 --> n8
  n8 --> x2
  x0 --> n8
  x1 --> n1
  x1 --> n7
  x10 --> n6
  x11 --> n1
  x11 --> n3
  x11 --> n6
  x12 --> n0
  x13 --> n0
  x14 --> n1
  x15 --> n3
  x15 --> n6
  x16 --> n3
  x16 --> n5
  x16 --> n6
  x17 --> n3
  x17 --> n6
  x18 --> n3
  x18 --> n6
  x24 --> n0
  x25 --> n0
  x26 --> n7
  x3 --> n7
  x4 --> n0
  x5 --> n7
  x6 --> n3
  x6 --> n4
  x7 --> n3
  x8 --> n3
  x9 --> n1
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
| `Glue.band_order_sum_le`<br/>theorem, line 19 | ∃ C : ℝ, 0 &lt; C ∧ ∀ T : ℝ, 2 ≤ T → ∀ F : Finset ℂ, (∀ ρ ∈ F, riemannZeta ρ = 0 ∧ (0 &lt; ρ.re ∧ ρ.re &lt; 1) ∧ T ≤ \|ρ.im\| ∧ \|ρ.im\| ≤ T + 1) → (∑ ρ ∈ F, (analyticOrderNatAt riemannZeta ρ : ℝ)) ≤ C * Real.log T | — | The band count: any finite set of strip zeros with `\|im\|` in `[T, T+1]` has total multiplicity `≤ C·log T` — two windows per sign, reflection for the left half, conjugation for the negative sign. | `ContourShift.mem_zetaWindow`, `ContourShift.zeta_order_conj`, `ContourShift.zeta_order_reflect`, `Stage3.zetaWindow_finite`, `Stage3.zeta_local_zero_count` | `Glue.zeroPartialSum_swap` |
| `Glue.zeroPartialSum_swap`<br/>theorem, line 242 | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T ≤ T' → T' ≤ T + 1 → ‖Stage3.zeroPartialSum x T' - Stage3.zeroPartialSum x T‖ ≤ C * x * Real.log T / T | — | The swap: moving the zero sum from a height `T′ ∈ [T, T+1]` back to `T` costs `≤ C·x·log T / T`. | `Stage3.zeroPartialSum`, `ContourShift.zeroPartialSum_eq_sum`, `ContourShift.zeta_ne_zero_of_re_mem`, `ContourShift.zeta_zeros_rectangle_finite`, `Glue.band_order_sum_le` | `Glue.explicit_formula_poly`, `Glue.explicit_formula_split` |
| `Glue.Gf`<br/>def, line 347 | ℂ → ℂ | x : ℝ | The contour integrand of the explicit formula. | — | `Glue.Gf_norm_conj`, `Glue.edge_horizontal_bound`, `Glue.edge_left_bound`, `Glue.explicit_formula_poly`, `Glue.edge_left_sharp`, `Glue.explicit_formula_split`, `Glue.edge_horizontal_bound_num`, `Glue.edge_left_sharp_num`, `Glue.explicit_formula_split_num` |
| `Glue.zeta_logderiv_good_bound`<br/>theorem, line 351 | ∃ C : ℝ, 0 &lt; C ∧ ∀ T T' : ℝ, 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ u : ℂ, \|u.im\| = T' → -1/4 ≤ u.re → u.re ≤ 2 → ‖deriv riemannZeta u / riemannZeta u‖ ≤ C * Real.log T ^ 2 | — | The pointwise good-height bound, both signs of the height. | `ContourShift.zeroGap`, `ContourShift.zeroGap_le`, `ContourShift.zeroGap_pos`, `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.ball_zero_shape`, `EdgeBound.deriv_zeta_conj`, `EdgeBound.edge_bound_core`, `EdgeBound.gz_zeros_ball_finite` | `Glue.edge_horizontal_bound` |
| `Glue.edge_horizontal_bound`<br/>theorem, line 442 | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T T' : ℝ, 16 ≤ x → 2 ≤ T → T' ∈ Set.Icc T (T+1) → (∀ ρ : ℂ, riemannZeta ρ = 0 → 0 &lt; ρ.re → ContourShift.zeroGap T ≤ \|ρ.im - T'\|) → ∀ y : ℝ, \|y\| = T' → ‖HIntegral (Gf x) (-1/4) (1 + 1/Real.log x) y‖ ≤ C * x * Real.log T ^ 2 / T | — | The horizontal-edge integral bound at a good height, both signs: `≤ C·x·log²T/T`. | `ContourShift.zeroGap`, `Glue.Gf`, `Glue.zeta_logderiv_good_bound` | `Glue.explicit_formula_poly`, `Glue.explicit_formula_split` |
| `Glue.Gf_norm_conj`<br/>theorem, line 535 | ‖Gf x ((starRingEnd ℂ) u)‖ = ‖Gf x u‖ | hx : 0 &lt; x; hu1 : u ≠ 1 | Conjugation symmetry of the integrand's norm. | `EdgeBound.deriv_zeta_conj`, `Glue.Gf` | — |
| `Glue.edge_left_bound`<br/>theorem, line 557 | ∃ C : ℝ, 0 &lt; C ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ C * Real.log x | — | The left-edge integral bound: `≤ C·log x` for `T′ ≤ x²`. | `ContourShift.zeta_analyticAt`, `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.ball_zero_shape`, `EdgeBound.deriv_zeta_conj`, `EdgeBound.edge_bound_core`, `EdgeBound.gz_zeros_ball_finite`, `Glue.Gf` | `Glue.explicit_formula_poly` |
| `Glue.explicit_formula_poly`<br/>theorem, line 979 | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₂ * Real.log x | — | THE TRUNCATED EXPLICIT FORMULA — hEF's deliverable, in the `T ≤ x²` regime the consumer uses: constants exist with `‖ψ(x) − x + Σ_{\|γ\|&lt;T} m·x^ρ/ρ‖ ≤ c₁·x·log²(xT)/T + c₂·log x`. | `Stage3.zeroPartialSum`, `ContourShift.goodT_exists`, `ContourShift.residue_identity`, `Glue.Gf`, `Glue.edge_horizontal_bound`, `Glue.edge_left_bound`, `Glue.zeroPartialSum_swap`, `PerronKernel.explicit_formula_perron` | `Glue.stmtEF_poly` |
| `Glue.stmtEF_poly`<br/>theorem, line 1195 | ∃ c₁ c₂ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₂ ∧ Stage3.StmtExplicitFormulaPoly c₁ c₂ 16 | — | hEF DISCHARGED: constants realizing the ledger's leaf. | `Stage3.StmtExplicitFormulaPoly`, `Glue.explicit_formula_poly` | `Stage3.schoenfeldWeak_floor_of_RH` |
