# `lean_stage3/Stage3/GlueFloor.lean`

**What it does** (its own header): GlueFloor — block E2 of `lean_stage3/design/joints.md`. 2026-11-22. `Glue.edge_left_bound` proves the left edge of the explicit formula's contour is at most `72·D·log²x·x^(−1/4)` and then rounds that to `C·log x` (unit 0408: that rounding is the whole of `c₂`). Three copies with a different last line each (`LOOP.md` § 3); `Glue.lean` is untouched.

**Imports:** [`AssemblyFloor`](../lean_stage3/AssemblyFloor.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`GlueNum`](../lean_stage3/GlueNum.md), [`JointFloorGate`](../lean_stage3/JointFloorGate.md).

```mermaid
flowchart LR
  n0["edge_left_sharp<br/>⊢ ∃ D : ℝ, 0 ＜ D ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral…"]:::thm
  n1["explicit_formula_split<br/>⊢ ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T →…"]:::thm
  n2["StmtExplicitFormulaSplit<br/>(def)"]:::dfn
  n3["stmtEF_split<br/>⊢ ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ StmtExplicitFormulaSplit c₁…"]:::thm
  n4["floorConstSplit<br/>(def)"]:::dfn
  n5["floorConstSplit_nonneg<br/>⊢ 0 ≤ floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀"]:::thm
  n6["psiWeak_floor_split<br/>⊢ StmtPsiWeak (floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀) 2 x₀"]:::thm
  n7["schoenfeldWeak_floor_split_of_RH<br/>⊢ ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSch…"]:::thm
  x0(["ArgCount · rvM_crude"]):::ext
  x1(["Assembly · norm_zeroPartialSum_le_logsq"]):::ext
  x2(["Assembly · zeroPartialSum"]):::ext
  x3(["AssemblyFloor · floorConst"]):::ext
  x4(["AssemblyFloor · floorConst_nonneg"]):::ext
  x5(["AssemblyFloor · floor_arith"]):::ext
  x6(["AssemblyFloor · rem_floor"]):::ext
  x7(["AssemblyFloor · zeroinner_floor"]):::ext
  x8(["ContourShift · goodT_exists"]):::ext
  x9(["ContourShift · residue_identity"]):::ext
  x10(["ContourShift · zeta_analyticAt"]):::ext
  x11(["ContourShift · zeta_ne_zero_of_re_mem"]):::ext
  x12(["EdgeBound · ball_zero_shape"]):::ext
  x13(["EdgeBound · deriv_zeta_conj"]):::ext
  x14(["EdgeBound · edge_bound_core"]):::ext
  x15(["EdgeBound · gz_zeros_ball_finite"]):::ext
  x16(["GateEval · routeConst_le"]):::ext
  x17(["Glue · Gf"]):::ext
  x18(["Glue · edge_horizontal_bound"]):::ext
  x19(["Glue · zeroPartialSum_swap"]):::ext
  x20(["JointFloorGate · relErrWindow_floor_of_RH"]):::ext
  x21(["PerronKernel · explicit_formula_perron"]):::ext
  x22(["PsiToPi · Li"]):::ext
  x23(["PsiToPi · StmtPsiWeak"]):::ext
  x24(["PsiToPi · schoenfeldWeak_of_psiWeak"]):::ext
  x25(["RouteGate · relErrWindow_route"]):::ext
  x26(["RouteNum · relErrWindow_route_num"]):::ext
  x27(["RouteNum · routeConst"]):::ext
  x28(["RouteNum · schoenfeldWeak_route_num"]):::ext
  x29(["RouteNum · stmtEF_split_num"]):::ext
  x30(["Statement · StmtSchoenfeldWeak"]):::ext
  n0 --> n1
  n1 --> n3
  n2 --> n3
  n2 --> n6
  n2 --> x29
  n3 --> n7
  n4 --> n5
  n4 --> n6
  n4 --> n7
  n4 --> x16
  n4 --> x20
  n4 --> x25
  n4 --> x27
  n5 --> n7
  n5 --> x20
  n5 --> x26
  n5 --> x28
  n6 --> n7
  n6 --> x28
  n7 --> x20
  x0 --> n7
  x1 --> n6
  x10 --> n0
  x11 --> n0
  x12 --> n0
  x13 --> n0
  x14 --> n0
  x15 --> n0
  x17 --> n0
  x17 --> n1
  x18 --> n1
  x19 --> n1
  x2 --> n1
  x2 --> n2
  x2 --> n6
  x21 --> n1
  x22 --> n7
  x23 --> n6
  x24 --> n7
  x3 --> n4
  x3 --> n6
  x30 --> n7
  x4 --> n5
  x5 --> n6
  x6 --> n6
  x7 --> n6
  x8 --> n1
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
| `Glue.edge_left_sharp`<br/>theorem, line 37 | ∃ D : ℝ, 0 &lt; D ∧ ∀ x T' : ℝ, 16 ≤ x → 2 ≤ T' → T' ≤ 2*x^2 → ‖VIntegral (Gf x) (-1/4) (-T') T'‖ ≤ 72 * D * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) | — | The left edge at its own size: `≤ 72·D·log²x·x^(−1/4)` for `T′ ≤ 2x²`. `Glue.edge_left_bound`'s proof, stopped before its last two steps. | `ContourShift.zeta_analyticAt`, `ContourShift.zeta_ne_zero_of_re_mem`, `EdgeBound.ball_zero_shape`, `EdgeBound.deriv_zeta_conj`, `EdgeBound.edge_bound_core`, `EdgeBound.gz_zeros_ball_finite`, `Glue.Gf` | `Glue.explicit_formula_split` |
| `Glue.explicit_formula_split`<br/>theorem, line 408 | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x T : ℝ, 16 ≤ x → 2 ≤ T → T ≤ x^2 → ‖(Chebyshev.psi x : ℂ) - (x:ℂ) + Stage3.zeroPartialSum x T‖ ≤ c₁ * x * Real.log (x*T)^2 / T + c₃ * Real.log x + c₄ * ((Real.log x)^2 * x ^ (-(1:ℝ)/4)) | — | THE TRUNCATED EXPLICIT FORMULA — hEF's deliverable, in the `T ≤ x²` regime the consumer uses: constants exist with `‖ψ(x) − x + Σ_{\|γ\|&lt;T} m·x^ρ/ρ‖ ≤ c₁·x·log²(xT)/T + c₂·log x`. | `Stage3.zeroPartialSum`, `ContourShift.goodT_exists`, `ContourShift.residue_identity`, `Glue.Gf`, `Glue.edge_horizontal_bound`, `Glue.zeroPartialSum_swap`, `Glue.edge_left_sharp`, `PerronKernel.explicit_formula_perron` | `Stage3.stmtEF_split` |
| `Stage3.StmtExplicitFormulaSplit`<br/>def, line 644 | Prop | c₁ c₃ c₄ x₁ : ℝ | The truncated explicit formula with the left edge as its own term. | `Stage3.zeroPartialSum` | `Stage3.psiWeak_floor_split`, `Stage3.stmtEF_split`, `Stage3.stmtEF_split_num` |
| `Stage3.stmtEF_split`<br/>theorem, line 650 | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ StmtExplicitFormulaSplit c₁ c₃ c₄ 16 | — | — | `Glue.explicit_formula_split`, `Stage3.StmtExplicitFormulaSplit` | `Stage3.schoenfeldWeak_floor_split_of_RH` |
| `Stage3.floorConstSplit`<br/>def, line 655 | ℝ | c₁ c₃ c₄ b₁ b₂ b₃ W x₀ : ℝ | The constant of the assembly at floor `x₀`, left edge at its own size. | `Stage3.floorConst` | `GateEval.routeConst_le`, `Stage3.floorConstSplit_nonneg`, `Stage3.psiWeak_floor_split`, `Stage3.schoenfeldWeak_floor_split_of_RH`, `JointFloorGate.relErrWindow_floor_of_RH`, `RouteGate.relErrWindow_route`, `Stage3.routeConst` |
| `Stage3.floorConstSplit_nonneg`<br/>theorem, line 658 | 0 ≤ floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀ | hc₁ : 0 ≤ c₁; hc₃ : 0 ≤ c₃; hc₄ : 0 ≤ c₄; hb₁ : 0 ≤ b₁; hb₂ : 0 ≤ b₂; hb₃ : 0 ≤ b₃; hW : 0 ≤ W; hx₀ : 16 ≤ x₀ | — | `Stage3.floorConst_nonneg`, `Stage3.floorConstSplit` | `Stage3.schoenfeldWeak_floor_split_of_RH`, `JointFloorGate.relErrWindow_floor_of_RH`, `RouteNum.relErrWindow_route_num`, `Stage3.schoenfeldWeak_route_num` |
| `Stage3.psiWeak_floor_split`<br/>theorem, line 672 | StmtPsiWeak (floorConstSplit c₁ c₃ c₄ b₁ b₂ b₃ W x₀) 2 x₀ | hRH : RiemannHypothesis; hc₁ : 0 ≤ c₁; hc₃ : 0 ≤ c₃; hc₄ : 0 ≤ c₄; hb₁ : 0 ≤ b₁; hb₂ : 0 ≤ b₂; hb₃ : 0 ≤ b₃; hWeq : W = weightedZeroHeightBucket; hRvM2 : 0 ≤ riemannZeta.RvM b₁ b₂ b₃ 2; hEF : StmtExplicitFormulaSplit c₁ c₃ c₄ x₁; hNT : riemannZeta.Riemann_vonMangoldt_bound b₁ b₂ b₃; hx₀ : 16 ≤ x₀; hx₁ : x₁ ≤ x₀ | The assembly at floor `x₀`, left edge at its own size. Under RH, the truncated explicit formula and the zero-count band, `\|ψ x − x\| ≤ floorConst … x₀ · √x · log²x` for `x ≥ x₀`. The height is the power of two in `(x²/2, x²]`. | `Stage3.norm_zeroPartialSum_le_logsq`, `Stage3.zeroPartialSum`, `Stage3.floorConst`, `Stage3.floor_arith`, `Stage3.rem_floor`, `Stage3.zeroinner_floor`, `Stage3.StmtExplicitFormulaSplit`, `Stage3.floorConstSplit`, `Stage3.StmtPsiWeak` | `Stage3.schoenfeldWeak_floor_split_of_RH`, `Stage3.schoenfeldWeak_route_num` |
| `Stage3.schoenfeldWeak_floor_split_of_RH`<br/>theorem, line 806 | ∃ c₁ c₃ c₄ : ℝ, 0 ≤ c₁ ∧ 0 ≤ c₃ ∧ 0 ≤ c₄ ∧ ∀ x₀ : ℝ, 16 ≤ x₀ → StmtSchoenfeldWeak (3 * floorConstSplit c₁ c₃ c₄ 112 0 698 weightedZeroHeightBucket x₀ + 13) 1 (max (x₀ ^ 2) 9) (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Li | hRH : RiemannHypothesis | From RH to the `π` side, floor a parameter, left edge at its own size. | `ArgCount.rvM_crude`, `Stage3.floorConstSplit`, `Stage3.floorConstSplit_nonneg`, `Stage3.psiWeak_floor_split`, `Stage3.stmtEF_split`, `Stage3.Li`, `Stage3.schoenfeldWeak_of_psiWeak`, `Stage3.StmtSchoenfeldWeak` | `JointFloorGate.relErrWindow_floor_of_RH` |
