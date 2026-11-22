# `lean_stage3/Stage3/ArgCrude.lean`

**What it does** (its own header): ArgCrude — hNT slice 2: the argument-principle half of Backlund, decomposed to the point where the Jensen zero-count is the only analytic content left.

**Imports:** [`RvMCrude`](../lean_stage3/RvMCrude.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ArgIdentity`](../lean_stage3/ArgIdentity.md), [`JensenCount`](../lean_stage3/JensenCount.md).

```mermaid
flowchart LR
  n0["StmtArgIdentity<br/>(def)"]:::dfn
  n1["StmtSCrude<br/>(def)"]:::dfn
  n2["StmtLocalCount<br/>(def)"]:::dfn
  n3["StmtSFromLocal<br/>(def)"]:::dfn
  n4["sCrude_of_local<br/>⊢ StmtSCrude S (a * A₁) (a * A₃ + b)"]:::thm
  n5["backlundArg_of_identity<br/>⊢ StmtBacklundArg θ B₁ B₃"]:::thm
  n6["argCrude_of_pieces<br/>⊢ StmtBacklundArg θ (a * A₁) (a * A₃ + b)"]:::thm
  n7["rvM_of_stirling_and_pieces<br/>⊢ riemannZeta.Riemann_vonMangoldt_bound (B₁ + a * A₁) 0 (B₃ + (a * A₃ + …"]:::thm
  x0(["ArgCount · rvM_crude"]):::ext
  x1(["ArgCount · rvM_crude_of_good_two"]):::ext
  x2(["ArgCount · sCrude_holds"]):::ext
  x3(["ArgCount · sCrude_holds_of_good_two"]):::ext
  x4(["ArgIdentity · backlundArg_of_sFromLocal"]):::ext
  x5(["ArgIdentity · rvM_of_sFromLocal"]):::ext
  x6(["ArgIdentity · stmtArgIdentity_holds"]):::ext
  x7(["JensenCount · localCount_holds"]):::ext
  x8(["RvMCrude · RvM_of_phase_arg"]):::ext
  x9(["RvMCrude · StmtBacklundArg"]):::ext
  x10(["RvMCrude · StmtBacklundPhase"]):::ext
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> x6
  n1 --> n4
  n1 --> n5
  n1 --> x2
  n1 --> x3
  n2 --> n4
  n2 --> n6
  n2 --> n7
  n2 --> x4
  n2 --> x7
  n3 --> n4
  n3 --> n6
  n3 --> n7
  n3 --> x4
  n3 --> x5
  n4 --> n6
  n5 --> n6
  n5 --> x0
  n5 --> x1
  n6 --> n7
  n6 --> x4
  n7 --> x5
  x10 --> n7
  x8 --> n7
  x9 --> n5
  x9 --> n6
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
| `Stage3.StmtArgIdentity`<br/>def, line 65 | Prop | θ S : ℝ → ℝ | The rectangle identity: the zero count is the phase plus one, plus `S`. Pure argument principle — no bound is asserted here, which is the point of naming it separately. | — | `Stage3.argCrude_of_pieces`, `Stage3.backlundArg_of_identity`, `Stage3.rvM_of_stirling_and_pieces`, `Stage3.stmtArgIdentity_holds` |
| `Stage3.StmtSCrude`<br/>def, line 70 | Prop | S : ℝ → ℝ; B₁ B₃ : ℝ | The crude argument bound: `\|S T\| ≤ B₁ log T + B₃`. This is `StmtBacklundArg`'s content once the identity is available. | — | `ArgCount.sCrude_holds`, `ArgCount.sCrude_holds_of_good_two`, `Stage3.backlundArg_of_identity`, `Stage3.sCrude_of_local` |
| `Stage3.StmtLocalCount`<br/>def, line 76 | Prop | cnt : ℝ → ℝ; A₁ A₃ : ℝ | The Jensen piece: a local zero count that grows like `log T`. Abstract in `cnt` so the discharge target is a statement, not a construction — upstream `ZerosBound` is what discharges it. | — | `Stage3.argCrude_of_pieces`, `Stage3.rvM_of_stirling_and_pieces`, `Stage3.sCrude_of_local`, `Stage3.backlundArg_of_sFromLocal`, `Stage3.localCount_holds` |
| `Stage3.StmtSFromLocal`<br/>def, line 81 | Prop | S cnt : ℝ → ℝ; a b : ℝ | Backlund's step: the argument is controlled by the local count. `a` and `b` are crude by design. | — | `Stage3.argCrude_of_pieces`, `Stage3.rvM_of_stirling_and_pieces`, `Stage3.sCrude_of_local`, `Stage3.backlundArg_of_sFromLocal`, `Stage3.rvM_of_sFromLocal` |
| `Stage3.sCrude_of_local`<br/>theorem, line 86 | StmtSCrude S (a * A₁) (a * A₃ + b) | ha : 0 ≤ a; hSF : StmtSFromLocal S cnt a b; hL : StmtLocalCount cnt A₁ A₃ | Count to argument bound. Needs `0 ≤ a`; the count enters positively. | `Stage3.StmtLocalCount`, `Stage3.StmtSCrude`, `Stage3.StmtSFromLocal` | `Stage3.argCrude_of_pieces` |
| `Stage3.backlundArg_of_identity`<br/>theorem, line 99 | StmtBacklundArg θ B₁ B₃ | hid : StmtArgIdentity θ S; hS : StmtSCrude S B₁ B₃ | Identity plus bound gives the Arg half. | `Stage3.StmtArgIdentity`, `Stage3.StmtSCrude`, `Stage3.StmtBacklundArg` | `ArgCount.rvM_crude`, `ArgCount.rvM_crude_of_good_two`, `Stage3.argCrude_of_pieces` |
| `Stage3.argCrude_of_pieces`<br/>theorem, line 113 | StmtBacklundArg θ (a * A₁) (a * A₃ + b) | ha : 0 ≤ a; hid : StmtArgIdentity θ S; hSF : StmtSFromLocal S cnt a b; hL : StmtLocalCount cnt A₁ A₃ | THE ASSEMBLY. The rectangle identity, the Jensen count and Backlund's step give the argument half of the decomposition, with every constant explicit. What remains open after this module is exactly: the identity, the step, and a concrete `cnt` discharged from upstream `ZerosBound`. | `Stage3.StmtArgIdentity`, `Stage3.StmtLocalCount`, `Stage3.StmtSFromLocal`, `Stage3.backlundArg_of_identity`, `Stage3.sCrude_of_local`, `Stage3.StmtBacklundArg` | `Stage3.rvM_of_stirling_and_pieces`, `Stage3.backlundArg_of_sFromLocal` |
| `Stage3.rvM_of_stirling_and_pieces`<br/>theorem, line 124 | riemannZeta.Riemann_vonMangoldt_bound (B₁ + a * A₁) 0 (B₃ + (a * A₃ + b)) | ha : 0 ≤ a; hPhase : StmtBacklundPhase θ B₁ B₃; hid : StmtArgIdentity θ S; hSF : StmtSFromLocal S cnt a b; hL : StmtLocalCount cnt A₁ A₃ | The full hNT band from the two halves, restated through this decomposition. With the Stirling half already discharged (`Stage3.backlundPhase_holds : StmtBacklundPhase phaseTheta 97 98`, entry 140), supplying the three pieces here delivers `Riemann_vonMangoldt_bound`. | `Stage3.StmtArgIdentity`, `Stage3.StmtLocalCount`, `Stage3.StmtSFromLocal`, `Stage3.argCrude_of_pieces`, `Stage3.RvM_of_phase_arg`, `Stage3.StmtBacklundPhase` | `Stage3.rvM_of_sFromLocal` |
