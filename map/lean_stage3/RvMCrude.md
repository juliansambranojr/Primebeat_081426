# `lean_stage3/Stage3/RvMCrude.lean`

**What it does** (its own header): RvMCrude — hNT slice 1, corrected: Backlund's decomposition, assembled over an abstract continuous phase.

**Imports:** [`ZeroSum`](../lean_stage3/ZeroSum.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ArgCrude`](../lean_stage3/ArgCrude.md), [`Stirling`](../lean_stage3/Stirling.md).

```mermaid
flowchart LR
  n0["StmtBacklundPhase<br/>(def)"]:::dfn
  n1["StmtBacklundArg<br/>(def)"]:::dfn
  n2["RvM_of_phase_arg<br/>⊢ riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃')"]:::thm
  x0(["ArgCount · rvM_crude"]):::ext
  x1(["ArgCount · rvM_crude_of_good_two"]):::ext
  x2(["ArgCrude · argCrude_of_pieces"]):::ext
  x3(["ArgCrude · backlundArg_of_identity"]):::ext
  x4(["ArgCrude · rvM_of_stirling_and_pieces"]):::ext
  x5(["ArgIdentity · backlundArg_of_sFromLocal"]):::ext
  x6(["Stirling · backlundPhase_holds"]):::ext
  x7(["Stirling · backlundPhase_of_digammaLog"]):::ext
  x8(["Stirling · stmtDigammaLog_holds"]):::ext
  n0 --> n2
  n0 --> x4
  n0 --> x6
  n0 --> x7
  n0 --> x8
  n1 --> n2
  n1 --> x2
  n1 --> x3
  n1 --> x5
  n2 --> x0
  n2 --> x1
  n2 --> x4
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
| `Stage3.StmtBacklundPhase`<br/>def, line 61 | Prop | θ : ℝ → ℝ; B₁ B₃ : ℝ | The Stirling half of Backlund, against an abstract phase: the phase tracks the RvM main term. Pure Γ-asymptotics — no zeros involved; the discharge supplies a continuous phase and a generous explicit Stirling error. | — | `Stage3.rvM_of_stirling_and_pieces`, `Stage3.RvM_of_phase_arg`, `Stage3.backlundPhase_holds`, `Stage3.backlundPhase_of_digammaLog`, `Stage3.stmtDigammaLog_holds` |
| `Stage3.StmtBacklundArg`<br/>def, line 70 | Prop | θ : ℝ → ℝ; B₁ B₃ : ℝ | The argument-principle half of Backlund, against the same phase: the count tracks `θ(T)/π + 1` — this distance is `S(T)`, measured by O69 at under 2 windings in 10⁵. Any explicit constant works; Borel–Carathéodory plus the ZetaBounds growth estimates are the classical route. | — | `Stage3.argCrude_of_pieces`, `Stage3.backlundArg_of_identity`, `Stage3.backlundArg_of_sFromLocal`, `Stage3.RvM_of_phase_arg` |
| `Stage3.RvM_of_phase_arg`<br/>theorem, line 78 | riemannZeta.Riemann_vonMangoldt_bound (B₁ + B₁') 0 (B₃ + B₃') | hPhase : StmtBacklundPhase θ B₁ B₃; hArg : StmtBacklundArg θ B₁' B₃' | The assembly: Backlund's two halves give the RvM band, for any phase satisfying both. With `b₂ = 0` — a legitimate instance of `Riemann_vonMangoldt_bound`; entry 130's budget accepts any `B₁ + B₁′ ≤ 100`, `B₃ + B₃′ ≤ 1000`. | `Stage3.StmtBacklundArg`, `Stage3.StmtBacklundPhase` | `ArgCount.rvM_crude`, `ArgCount.rvM_crude_of_good_two`, `Stage3.rvM_of_stirling_and_pieces` |
