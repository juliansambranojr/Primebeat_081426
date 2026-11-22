# `lean_stage3/Stage3/ArgCount.lean`

**What it does** (its own header): ArgCount — block `hnt.md#H3` of `lean_stage3/design/hnt.md`, "The assembly: StmtSCrude argS, good heights by the identity, bad heights by a good one beside them".

**Imports:** [`ArgLegs`](../lean_stage3/ArgLegs.md), [`ReZetaCount`](../lean_stage3/ReZetaCount.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`AssemblyFloor`](../lean_stage3/AssemblyFloor.md).

```mermaid
flowchart LR
  n0["good<br/>(def)"]:::dfn
  n1["argS_le_of_good<br/>⊢ |Stage3.argS T| ≤ 15 * Real.log T + 73 + 3 / 2"]:::thm
  n2["N_eq_sum<br/>⊢ riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finit…"]:::thm
  n3["N_nonneg<br/>⊢ 0 ≤ riemannZeta.N T"]:::thm
  n4["N_mono<br/>⊢ riemannZeta.N T ≤ riemannZeta.N T'"]:::thm
  n5["N_eq_of_no_zero_between<br/>⊢ riemannZeta.N T = riemannZeta.N T₀"]:::thm
  n6["exists_good_below<br/>⊢ ∃ T : ℝ, a ＜ T ∧ T ＜ T₀ ∧ good T ∧ ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈…"]:::thm
  n7["phasePoint_bound_near<br/>⊢ ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, |Stage3.phasePoint t| ≤ M"]:::thm
  n8["phaseTheta_sub_le<br/>⊢ |Stage3.phaseTheta T₀ - Stage3.phaseTheta T| ≤ (T₀ - T) * (M / 2 + Rea…"]:::thm
  n9["argS_le_gt_two<br/>⊢ |Stage3.argS T| ≤ 15 * Real.log T + 75"]:::thm
  n10["mainTerm_abs_le<br/>⊢ |Kadiri.zetaCountingMainTerm T| ≤ 3"]:::thm
  n11["argS_two_le<br/>⊢ |Stage3.argS 2| ≤ 15 * Real.log 2 + 600"]:::thm
  n12["sCrude_holds_of_good_two<br/>⊢ Stage3.StmtSCrude Stage3.argS 15 75"]:::thm
  n13["sCrude_holds<br/>⊢ Stage3.StmtSCrude Stage3.argS 15 600"]:::thm
  n14["rvM_crude_of_good_two<br/>⊢ riemannZeta.Riemann_vonMangoldt_bound 112 0 173"]:::end_
  n15["rvM_crude<br/>⊢ riemannZeta.Riemann_vonMangoldt_bound 112 0 698"]:::thm
  x0(["ArgCrude · StmtSCrude"]):::ext
  x1(["ArgCrude · backlundArg_of_identity"]):::ext
  x2(["ArgIdentity · argS"]):::ext
  x3(["ArgIdentity · argS_eq_zetaArgContour"]):::ext
  x4(["ArgIdentity · stmtArgIdentity_holds"]):::ext
  x5(["ArgLegs · zetaArgContour_le"]):::ext
  x6(["AssemblyFloor · schoenfeldWeak_floor_of_RH"]):::ext
  x7(["GlueFloor · schoenfeldWeak_floor_split_of_RH"]):::ext
  x8(["ReZetaCount · card_reZeros_le"]):::ext
  x9(["ReZetaCount · mem_reZeros"]):::ext
  x10(["ReZetaCount · reZeros"]):::ext
  x11(["ReZetaCount · re_zeta_two_line_pos"]):::ext
  x12(["RouteNum · schoenfeldWeak_route_num"]):::ext
  x13(["RvMCrude · RvM_of_phase_arg"]):::ext
  x14(["Stirling · backlundPhase_holds"]):::ext
  x15(["Stirling · intervalIntegrable_phasePoint"]):::ext
  x16(["Stirling · phasePoint"]):::ext
  x17(["Stirling · phaseTheta"]):::ext
  n0 --> n1
  n0 --> n12
  n0 --> n14
  n0 --> n6
  n1 --> n11
  n1 --> n12
  n1 --> n9
  n10 --> n11
  n11 --> n13
  n12 --> n14
  n13 --> n15
  n15 --> x12
  n15 --> x6
  n15 --> x7
  n2 --> n3
  n2 --> n4
  n3 --> n11
  n4 --> n11
  n5 --> n9
  n6 --> n11
  n6 --> n9
  n7 --> n9
  n8 --> n9
  n9 --> n12
  n9 --> n13
  x0 --> n12
  x0 --> n13
  x1 --> n14
  x1 --> n15
  x10 --> n1
  x11 --> n1
  x13 --> n14
  x13 --> n15
  x14 --> n11
  x14 --> n14
  x14 --> n15
  x15 --> n8
  x16 --> n7
  x16 --> n8
  x17 --> n11
  x17 --> n8
  x17 --> n9
  x2 --> n1
  x2 --> n11
  x2 --> n12
  x2 --> n13
  x2 --> n9
  x3 --> n1
  x4 --> n14
  x4 --> n15
  x5 --> n1
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
| `ArgCount.good`<br/>def, line 67 | Prop | T : ℝ | A height with no zero of `ζ` of positive real part on it. | — | `ArgCount.argS_le_of_good`, `ArgCount.exists_good_below`, `ArgCount.rvM_crude_of_good_two`, `ArgCount.sCrude_holds_of_good_two` |
| `ArgCount.argS_le_of_good`<br/>theorem, line 70 | \|Stage3.argS T\| ≤ 15 * Real.log T + 73 + 3 / 2 | hT : 2 ≤ T; hg : good T | The good heights. The identity plus H1's legs and H2's count. | `ArgCount.good`, `Stage3.argS`, `Stage3.argS_eq_zetaArgContour`, `ArgLegs.zetaArgContour_le`, `ReZetaCount.card_reZeros_le`, `ReZetaCount.mem_reZeros`, `ReZetaCount.reZeros`, `ReZetaCount.re_zeta_two_line_pos` | `ArgCount.argS_le_gt_two`, `ArgCount.argS_two_le`, `ArgCount.sCrude_holds_of_good_two` |
| `ArgCount.N_eq_sum`<br/>theorem, line 84 | riemannZeta.N T = ∑ z ∈ (Kadiri.zeroes_rect_univ_positive_height_finite T).toFinset, (1 : ℝ) * (riemannZeta.order z : ℝ) | T : ℝ | `N T` as the finite sum of orders over the zero rectangle. | — | `ArgCount.N_mono`, `ArgCount.N_nonneg` |
| `ArgCount.N_nonneg`<br/>theorem, line 93 | 0 ≤ riemannZeta.N T | T : ℝ | Every order is at least one, so the count is nonnegative. | `ArgCount.N_eq_sum` | `ArgCount.argS_two_le` |
| `ArgCount.N_mono`<br/>theorem, line 103 | riemannZeta.N T ≤ riemannZeta.N T' | h : T ≤ T' | The count is monotone in the height. | `ArgCount.N_eq_sum` | `ArgCount.argS_two_le` |
| `ArgCount.N_eq_of_no_zero_between`<br/>theorem, line 119 | riemannZeta.N T = riemannZeta.N T₀ | hle : T ≤ T₀; hno : ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False | No zero with imaginary part in `[T, T₀)` means the count does not move. | — | `ArgCount.argS_le_gt_two` |
| `ArgCount.exists_good_below`<br/>theorem, line 139 | ∃ T : ℝ, a &lt; T ∧ T &lt; T₀ ∧ good T ∧ ∀ ρ : ℂ, riemannZeta ρ = 0 → ρ.im ∈ Set.Ico T T₀ → False | ha : 0 ≤ a; hlt : a &lt; T₀ | Below any height there is a good height with no zero between the two. | `ArgCount.good` | `ArgCount.argS_le_gt_two`, `ArgCount.argS_two_le` |
| `ArgCount.phasePoint_bound_near`<br/>theorem, line 175 | ∃ M : ℝ, 0 ≤ M ∧ ∀ t ∈ Set.Icc (T₀ - 1) T₀, \|Stage3.phasePoint t\| ≤ M | T₀ : ℝ | The phase integrand is bounded on the unit interval below any height. | `Stage3.phasePoint` | `ArgCount.argS_le_gt_two` |
| `ArgCount.phaseTheta_sub_le`<br/>theorem, line 185 | \|Stage3.phaseTheta T₀ - Stage3.phaseTheta T\| ≤ (T₀ - T) * (M / 2 + Real.log Real.pi / 2) | hle : T ≤ T₀; h1 : T₀ ≤ T + 1; hM : ∀ t ∈ Set.Icc (T₀ - 1) T₀, \|Stage3.phasePoint t\| ≤ M | The phase moves by at most the length times the integrand bound. | `Stage3.intervalIntegrable_phasePoint`, `Stage3.phasePoint`, `Stage3.phaseTheta` | `ArgCount.argS_le_gt_two` |
| `ArgCount.argS_le_gt_two`<br/>theorem, line 216 | \|Stage3.argS T\| ≤ 15 * Real.log T + 75 | hT : 2 &lt; T | The bad heights above 2. A good height just below, with the count equal and the phase moving by at most `π/2`. | `ArgCount.N_eq_of_no_zero_between`, `ArgCount.argS_le_of_good`, `ArgCount.exists_good_below`, `ArgCount.phasePoint_bound_near`, `ArgCount.phaseTheta_sub_le`, `Stage3.argS`, `Stage3.phaseTheta` | `ArgCount.sCrude_holds`, `ArgCount.sCrude_holds_of_good_two` |
| `ArgCount.mainTerm_abs_le`<br/>theorem, line 258 | \|Kadiri.zetaCountingMainTerm T\| ≤ 3 | h2 : 2 ≤ T; h3 : T ≤ 3 | The RvM main term is small on `[2, 3]`. | — | `ArgCount.argS_two_le` |
| `ArgCount.argS_two_le`<br/>theorem, line 278 | \|Stage3.argS 2\| ≤ 15 * Real.log 2 + 600 | — | The single point `T = 2`. A good height just above, with the count monotone and the Stirling phase bound. | `ArgCount.N_mono`, `ArgCount.N_nonneg`, `ArgCount.argS_le_of_good`, `ArgCount.exists_good_below`, `ArgCount.mainTerm_abs_le`, `Stage3.argS`, `Stage3.backlundPhase_holds`, `Stage3.phaseTheta` | `ArgCount.sCrude_holds` |
| `ArgCount.sCrude_holds_of_good_two`<br/>theorem, line 307 | Stage3.StmtSCrude Stage3.argS 15 75 | h2 : good 2 | StmtSCrude under `good 2`: `\|argS T\| ≤ 15 log T + 75`. | `ArgCount.argS_le_gt_two`, `ArgCount.argS_le_of_good`, `ArgCount.good`, `Stage3.StmtSCrude`, `Stage3.argS` | `ArgCount.rvM_crude_of_good_two` |
| `ArgCount.sCrude_holds`<br/>theorem, line 315 | Stage3.StmtSCrude Stage3.argS 15 600 | — | StmtSCrude unconditionally: `\|argS T\| ≤ 15 log T + 600`. | `ArgCount.argS_le_gt_two`, `ArgCount.argS_two_le`, `Stage3.StmtSCrude`, `Stage3.argS` | `ArgCount.rvM_crude` |
| `ArgCount.rvM_crude_of_good_two`<br/>theorem, line 324 | riemannZeta.Riemann_vonMangoldt_bound 112 0 173 | h2 : good 2 | The crude hNT band under `good 2`. | `ArgCount.good`, `ArgCount.sCrude_holds_of_good_two`, `Stage3.backlundArg_of_identity`, `Stage3.stmtArgIdentity_holds`, `Stage3.RvM_of_phase_arg`, `Stage3.backlundPhase_holds` | — |
| `ArgCount.rvM_crude`<br/>theorem, line 332 | riemannZeta.Riemann_vonMangoldt_bound 112 0 698 | — | The crude hNT band, unconditional. | `ArgCount.sCrude_holds`, `Stage3.backlundArg_of_identity`, `Stage3.stmtArgIdentity_holds`, `Stage3.RvM_of_phase_arg`, `Stage3.backlundPhase_holds` | `Stage3.schoenfeldWeak_floor_of_RH`, `Stage3.schoenfeldWeak_floor_split_of_RH`, `Stage3.schoenfeldWeak_route_num` |
