# `lean_stage3/Stage3/JointDialGate.lean`

**What it does** (its own header): JointDialGate — joints 3, 4, 5 of `SECTIONS.md`: the dial onto the table's gate. Block 3 of `lean_stage3/design/joints.md`. 2026-11-22.

**Imports:** [`JointWindowDial`](../lean_stage3/JointWindowDial.md), [`LandauKernel`](../lean_stage3/LandauKernel.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`JointFloorGate`](../lean_stage3/JointFloorGate.md).

```mermaid
flowchart LR
  n0["StmtRelErrWindow<br/>(def)"]:::dfn
  n1["thetaWindow_of_global<br/>⊢ ∀ j ∈ range (n + 1), |f (r - j) - L (r - j)| ≤ C * ((2 : ℝ) ^ ((r : ℝ)…"]:::thm
  n2["log_absorbed<br/>⊢ C * x ^ θ * Real.log x ^ k ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) …"]:::thm
  n3["powerSaving_relErr<br/>⊢ StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1)))"]:::thm
  n4["relErrWindow_of_theta<br/>⊢ StmtRelErrWindow f L r n (C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k…"]:::thm
  n5["relErrWindow_of_window<br/>⊢ ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) → …"]:::end_
  x0(["GateEval · gate_hyp_of_RH"]):::ext
  x1(["JointFloorGate · relErrWindow_floor_of_RH"]):::ext
  x2(["JointFloorGate · weakWindow_relErr"]):::ext
  x3(["JointWindowDial · schoenfeldWeakTheta_of_window"]):::ext
  x4(["LandauKernel · log_pow_le"]):::ext
  x5(["LandauWindow · WindowBound"]):::ext
  x6(["PsiToPi · Li"]):::ext
  x7(["RouteGate · relErrWindow_route"]):::ext
  x8(["RouteNum · relErrWindow_route_num"]):::ext
  x9(["ThetaPi · StmtSchoenfeldWeakTheta"]):::ext
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> x0
  n0 --> x1
  n0 --> x2
  n0 --> x7
  n0 --> x8
  n1 --> n4
  n2 --> n4
  n3 --> n4
  n4 --> n5
  x3 --> n5
  x4 --> n2
  x5 --> n5
  x6 --> n5
  x9 --> n1
  x9 --> n4
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
| `JointDialGate.StmtRelErrWindow`<br/>def, line 39 | Prop | f L : ℤ → ℝ; r : ℤ; n : ℕ; ρ : ℝ | Character-level copy of `RelativeGate.StmtRelErrWindow` from the bench tree (lean/RelativeGate.lean). The weld: utilities/check_weld.py verifies the two definition bodies are textually identical. | — | `GateEval.gate_hyp_of_RH`, `JointDialGate.powerSaving_relErr`, `JointDialGate.relErrWindow_of_theta`, `JointDialGate.relErrWindow_of_window`, `JointFloorGate.relErrWindow_floor_of_RH`, `JointFloorGate.weakWindow_relErr`, `RouteGate.relErrWindow_route`, `RouteNum.relErrWindow_route_num` |
| `JointDialGate.thetaWindow_of_global`<br/>theorem, line 43 | ∀ j ∈ range (n + 1), \|f (r - j) - L (r - j)\| ≤ C * ((2 : ℝ) ^ ((r : ℝ) - j)) ^ θ * Real.log ((2 : ℝ) ^ ((r : ℝ) - j)) ^ k | hpi : Stage3.StmtSchoenfeldWeakTheta θ C k x₀ pi li; hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)); hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)); hbot : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) | — | `Stage3.StmtSchoenfeldWeakTheta` | `JointDialGate.relErrWindow_of_theta` |
| `JointDialGate.log_absorbed`<br/>theorem, line 62 | C * x ^ θ * Real.log x ^ k ≤ C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * x ^ θ' | hC : 0 ≤ C; hθ : θ &lt; θ'; hx : 1 ≤ x | — | `LandauKernel.log_pow_le` | `JointDialGate.relErrWindow_of_theta` |
| `JointDialGate.powerSaving_relErr`<br/>theorem, line 83 | StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) | hA : 0 ≤ A; hθ : θ ≤ 1; hP : ∀ k ∈ range (n + 1), \|f (r - k) - L (r - k)\| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ | Statement identical to `RelativeGate.powerSaving_relErr` of the bench tree; reproved on this toolchain. | `JointDialGate.StmtRelErrWindow` | `JointDialGate.relErrWindow_of_theta` |
| `JointDialGate.relErrWindow_of_theta`<br/>theorem, line 103 | StmtRelErrWindow f L r n (C / (2 * (θ' - θ) / (2 * ((k : ℝ) + 1))) ^ k * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) | hpi : Stage3.StmtSchoenfeldWeakTheta θ C k x₀ pi li; hC : 0 ≤ C; hθ : θ &lt; θ'; hθ' : θ' ≤ 1; hf : ∀ m : ℤ, f m = pi ((2 : ℝ) ^ (m : ℝ)); hL : ∀ m : ℤ, L m = li ((2 : ℝ) ^ (m : ℝ)); hbot : x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n); hpos : 0 ≤ (r : ℝ) - n | — | `JointDialGate.StmtRelErrWindow`, `JointDialGate.log_absorbed`, `JointDialGate.powerSaving_relErr`, `JointDialGate.thetaWindow_of_global`, `Stage3.StmtSchoenfeldWeakTheta` | `JointDialGate.relErrWindow_of_window` |
| `JointDialGate.relErrWindow_of_window`<br/>theorem, line 122 | ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) → 0 ≤ (r : ℝ) - n → StmtRelErrWindow (fun m : ℤ =&gt; (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ)) (fun m : ℤ =&gt; Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) | hθlo : 1 / 2 ≤ θ; hθ1 : θ &lt; 1; hδ : 0 &lt; δ; hW : LandauWindow.WindowBound θ δ C₀; hθ : θ &lt; θ'; hθ' : θ' ≤ 1 | — | `JointDialGate.StmtRelErrWindow`, `JointDialGate.relErrWindow_of_theta`, `JointWindowDial.schoenfeldWeakTheta_of_window`, `LandauWindow.WindowBound`, `Stage3.Li` | — |
