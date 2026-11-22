# `lean_stage3/Stage3/JointSymbol.lean`

**What it does** (its own header): JointSymbol — joint 9a of `SECTIONS.md`: the table of `G` along the doublings and the symbol, on the transform side. Block 9a of `lean_stage3/design/joints.md`. 2026-11-22.

**Imports:** [`LandauPoleLocal`](../lean_stage3/LandauPoleLocal.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md).

```mermaid
flowchart LR
  n0["dd<br/>(def)"]:::dfn
  n1["cutG<br/>(def)"]:::dfn
  n2["mellin_shift<br/>⊢ IntegrableOn (fun y : ℝ =＞ f (y / 2) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫…"]:::thm
  n3["mellin_dd<br/>⊢ (∀ y : ℝ, y ≤ 1 → dd f y = 0) ∧ IntegrableOn (fun y : ℝ =＞ dd f y * (y…"]:::thm
  n4["mellin_dd_iter_aux<br/>⊢ (∀ y : ℝ, y ≤ 1 → (dd^[d] f) y = 0) ∧ IntegrableOn (fun y : ℝ =＞ (dd^[…"]:::thm
  n5["mellin_dd_iter<br/>⊢ ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ…"]:::end_
  n6["dd_iter_rule<br/>⊢ (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2)"]:::end_
  n7["symPhi_principal_part<br/>⊢ ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, (1 - (2 : ℂ) ^ (-s)) ^…"]:::end_
  x0(["LandauMellinG · G_mellin_integrable"]):::ext
  x1(["LandauMellinG · Phi"]):::ext
  x2(["LandauMellinG · mellin_G"]):::ext
  x3(["LandauPoleLocal · Phi_principal_part"]):::ext
  x4(["LandauWindow · G"]):::ext
  n0 --> n3
  n0 --> n4
  n0 --> n5
  n0 --> n6
  n1 --> n5
  n2 --> n3
  n3 --> n4
  n4 --> n5
  x0 --> n5
  x1 --> n5
  x1 --> n7
  x2 --> n5
  x3 --> n7
  x4 --> n1
  x4 --> n5
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
| `JointSymbol.dd`<br/>def, line 42 | ℝ → ℂ | f : ℝ → ℂ | One difference along the doublings. | — | `JointSymbol.dd_iter_rule`, `JointSymbol.mellin_dd`, `JointSymbol.mellin_dd_iter`, `JointSymbol.mellin_dd_iter_aux` |
| `JointSymbol.cutG`<br/>def, line 45 | ℂ | y : ℝ | `G` on `y &gt; 1`, zero below: the row starts at the first regime. | `LandauWindow.G` | `JointSymbol.mellin_dd_iter` |
| `JointSymbol.mellin_shift`<br/>theorem, line 47 | IntegrableOn (fun y : ℝ =&gt; f (y / 2) * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), f (y / 2) * (y : ℂ) ^ (-s - 1) = (2 : ℂ) ^ (-s) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) | hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0; hint : IntegrableOn (fun y : ℝ =&gt; f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) | — | — | `JointSymbol.mellin_dd` |
| `JointSymbol.mellin_dd`<br/>theorem, line 105 | (∀ y : ℝ, y ≤ 1 → dd f y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; dd f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), dd f y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) | hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0; hint : IntegrableOn (fun y : ℝ =&gt; f y * (y : ℂ) ^ (-s - 1)) (Ioi 1) | `dd` keeps the two hypotheses and multiplies the transform by the symbol. | `JointSymbol.dd`, `JointSymbol.mellin_shift` | `JointSymbol.mellin_dd_iter_aux` |
| `JointSymbol.mellin_dd_iter_aux`<br/>theorem, line 120 | (∀ y : ℝ, y ≤ 1 → (dd^[d] f) y = 0) ∧ IntegrableOn (fun y : ℝ =&gt; (dd^[d] f) y * (y : ℂ) ^ (-s - 1)) (Ioi 1) ∧ ∫ y in Ioi (1 : ℝ), (dd^[d] f) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * ∫ y in Ioi (1 : ℝ), f y * (y : ℂ) ^ (-s - 1) | hf0 : ∀ y : ℝ, y ≤ 1 → f y = 0; hint : IntegrableOn (fun y : ℝ =&gt; f y * (y : ℂ) ^ (-s - 1)) (Ioi 1); d : ℕ | — | `JointSymbol.dd`, `JointSymbol.mellin_dd` | `JointSymbol.mellin_dd_iter` |
| `JointSymbol.mellin_dd_iter`<br/>theorem, line 136 | ∫ y in Ioi (1 : ℝ), (dd^[d] cutG) y * (y : ℂ) ^ (-s - 1) = (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s | hs : 1 &lt; s.re; d : ℕ | — | `JointSymbol.cutG`, `JointSymbol.dd`, `JointSymbol.mellin_dd_iter_aux`, `LandauMellinG.G_mellin_integrable`, `LandauMellinG.Phi`, `LandauMellinG.mellin_G`, `LandauWindow.G` | — |
| `JointSymbol.dd_iter_rule`<br/>theorem, line 153 | (dd^[d + 1] f) y = (dd^[d] f) y - (dd^[d] f) (y / 2) | f : ℝ → ℂ; d : ℕ; y : ℝ | — | `JointSymbol.dd` | — |
| `JointSymbol.symPhi_principal_part`<br/>theorem, line 158 | ∃ h : ℂ → ℂ, AnalyticAt ℂ h ρ ∧ ∀ᶠ s in 𝓝[≠] ρ, (1 - (2 : ℂ) ^ (-s)) ^ d * LandauMellinG.Phi s = h s + (1 - (2 : ℂ) ^ (-ρ)) ^ d * ((analyticOrderNatAt riemannZeta ρ : ℂ) / (ρ * (1 - ρ))) / (s - ρ) | h0 : ρ ≠ 0; h1 : ρ ≠ 1; hz : riemannZeta ρ = 0; d : ℕ | — | `LandauMellinG.Phi`, `LandauPoleLocal.Phi_principal_part` | — |
