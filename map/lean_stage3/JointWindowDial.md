# `lean_stage3/Stage3/JointWindowDial.lean`

**What it does** (its own header): JointWindowDial — joint 1 of `SECTIONS.md`: the Landau window onto the dial. Block 1 of `lean_stage3/design/joints.md`. 2026-11-22.

**Imports:** [`LandauCriterion`](../lean_stage3/LandauCriterion.md), [`ThetaPi`](../lean_stage3/ThetaPi.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`JointDialGate`](../lean_stage3/JointDialGate.md).

```mermaid
flowchart LR
  n0["zeroFreeRight_of_window<br/>⊢ Stage3.StmtZeroFreeRight θ"]:::thm
  n1["psiWeakTheta_of_window<br/>⊢ ∃ C' ＞ 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → |Chebyshev.psi t - t| ≤ C' * t ^…"]:::end_
  n2["schoenfeldWeakTheta_of_window<br/>⊢ ∃ C' ＞ 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀ (fun x =＞…"]:::thm
  x0(["Abscissa · StmtZeroFreeRight"]):::ext
  x1(["JointDialGate · relErrWindow_of_window"]):::ext
  x2(["LandauCriterion · stmtLandauWindow"]):::ext
  x3(["LandauWindow · WindowBound"]):::ext
  x4(["PsiToPi · Li"]):::ext
  x5(["ThetaPi · StmtSchoenfeldWeakTheta"]):::ext
  x6(["ThetaPi · schoenfeldWeakTheta_of_zeroFree"]):::ext
  x7(["ThetaPsi · psi_weak_of_theta"]):::ext
  n0 --> n1
  n0 --> n2
  n2 --> x1
  x0 --> n0
  x2 --> n0
  x3 --> n0
  x3 --> n1
  x3 --> n2
  x4 --> n2
  x5 --> n2
  x6 --> n2
  x7 --> n1
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
| `JointWindowDial.zeroFreeRight_of_window`<br/>theorem, line 33 | Stage3.StmtZeroFreeRight θ | hθ0 : 0 &lt; θ; hθ1 : θ &lt; 1; hδ : 0 &lt; δ; hW : LandauWindow.WindowBound θ δ C | — | `Stage3.StmtZeroFreeRight`, `LandauCriterion.stmtLandauWindow`, `LandauWindow.WindowBound` | `JointWindowDial.psiWeakTheta_of_window`, `JointWindowDial.schoenfeldWeakTheta_of_window` |
| `JointWindowDial.psiWeakTheta_of_window`<br/>theorem, line 38 | ∃ C' &gt; 0, ∃ x₀ : ℝ, ∀ t : ℝ, x₀ ≤ t → \|Chebyshev.psi t - t\| ≤ C' * t ^ θ * Real.log t ^ 3 | hθlo : 1 / 2 ≤ θ; hθ1 : θ &lt; 1; hδ : 0 &lt; δ; hW : LandauWindow.WindowBound θ δ C | — | `JointWindowDial.zeroFreeRight_of_window`, `LandauWindow.WindowBound`, `Stage3.psi_weak_of_theta` | — |
| `JointWindowDial.schoenfeldWeakTheta_of_window`<br/>theorem, line 44 | ∃ C' &gt; 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀ (fun x =&gt; (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li | hθlo : 1 / 2 ≤ θ; hθ1 : θ &lt; 1; hδ : 0 &lt; δ; hW : LandauWindow.WindowBound θ δ C | — | `JointWindowDial.zeroFreeRight_of_window`, `LandauWindow.WindowBound`, `Stage3.Li`, `Stage3.StmtSchoenfeldWeakTheta`, `Stage3.schoenfeldWeakTheta_of_zeroFree` | `JointDialGate.relErrWindow_of_window` |
