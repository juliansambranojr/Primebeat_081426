# `lean_stage3/Stage3/LandauPoleSub.lean`

**What it does** (its own header): LandauPoleSub — finitely many simple poles subtracted on an open set, and what that gives for the Taylor coefficients. Nothing here is about `ζ`. Block 3b1 of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauPoleDisc`](../lean_stage3/LandauPoleDisc.md).

```mermaid
flowchart LR
  n0["iteratedDeriv_inv_sub<br/>⊢ iteratedDeriv k (fun s : ℂ =＞ (s - q)⁻¹) c = (-1) ^ k * (k.factorial :…"]:::thm
  n1["exists_differentiableOn_sub_poles<br/>⊢ ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧ ∀ s, s ∉ P → g s = f s - ∑ q ∈ P…"]:::thm
  n2["taylor_coeff_sub_poles<br/>⊢ ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c - ∑ q ∈ P, A q * ((-1) ^ k * (k…"]:::thm
  x0(["LandauPoleDisc · Phi_taylor_on_disc"]):::ext
  n0 --> n2
  n1 --> x0
  n2 --> x0
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
| `LandauPoleSub.iteratedDeriv_inv_sub`<br/>theorem, line 35 | iteratedDeriv k (fun s : ℂ =&gt; (s - q)⁻¹) c = (-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)) | k : ℕ; q c : ℂ | — | — | `LandauPoleSub.taylor_coeff_sub_poles` |
| `LandauPoleSub.exists_differentiableOn_sub_poles`<br/>theorem, line 41 | ∃ g : ℂ → ℂ, DifferentiableOn ℂ g U ∧ ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) | hf : ∀ s ∈ U, s ∉ P → DifferentiableAt ℂ f s; hloc : ∀ p ∈ P, ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in 𝓝[≠] p, f s = h s + A p / (s - p) | — | — | `LandauPoleDisc.Phi_taylor_on_disc` |
| `LandauPoleSub.taylor_coeff_sub_poles`<br/>theorem, line 104 | ∃ C : ℝ, ∀ k : ℕ, ‖iteratedDeriv k f c - ∑ q ∈ P, A q * ((-1) ^ k * (k.factorial : ℂ) * (c - q) ^ (-1 - (k : ℤ)))‖ ≤ k.factorial * C / R ^ k | hR : 0 &lt; R; hU : IsOpen U; hball : closedBall c R ⊆ U; hcP : c ∉ P; hg : DifferentiableOn ℂ g U; hgf : ∀ s, s ∉ P → g s = f s - ∑ q ∈ P, A q / (s - q) | — | `LandauPoleSub.iteratedDeriv_inv_sub` | `LandauPoleDisc.Phi_taylor_on_disc` |
