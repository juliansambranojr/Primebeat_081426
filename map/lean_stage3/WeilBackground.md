# `lean_stage3/Stage3/WeilBackground.lean`

**What it does** (its own header): WeilBackground — the window as a test function of the explicit formula, and the on-line terms of the zero side. Rung 4b, first half, of the detection ladder (units 0316–0319). 2026-09-06.

**Imports:** [`WeilDetect`](../lean_stage3/WeilDetect.md), [`WeilLobe`](../lean_stage3/WeilLobe.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilBands`](../lean_stage3/WeilBands.md), [`WeilOffLine`](../lean_stage3/WeilOffLine.md).

```mermaid
flowchart LR
  n0["phi<br/>(def)"]:::dfn
  n1["phiC<br/>(def)"]:::dfn
  n2["phiC_real<br/>⊢ (phiC h γ u).im = 0"]:::thm
  n3["laplace_phi<br/>⊢ laplace (phiC h γ) z = ghat h γ (-z - 1 / 2)"]:::thm
  n4["Psi_bound<br/>⊢ |WeilTransform.Psi s| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2"]:::thm
  n5["Psi_le_two<br/>⊢ |WeilTransform.Psi s| ≤ 2"]:::thm
  n6["online_term_eq<br/>⊢ laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = (((h / 2) ^ …"]:::thm
  n7["online_term_le_near<br/>⊢ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ 4 * h ^…"]:::thm
  n8["online_term_le_far<br/>⊢ (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ (h / 2)…"]:::thm
  x0(["WeilBands · band_sum_le"]):::ext
  x1(["WeilBands · weightedTerm"]):::ext
  x2(["WeilDetect · laplace"]):::ext
  x3(["WeilDetect · laplace_conj"]):::ext
  x4(["WeilLobe · SigmaC_bound"]):::ext
  x5(["WeilOffLine · offline_term_le"]):::ext
  x6(["WeilOffLine · offline_term_le_explicit"]):::ext
  x7(["WeilOffLine · term_eq_neg_sq"]):::ext
  x8(["WeilOffLine · term_re_eq"]):::ext
  x9(["WeilOnLine · sum_low_le"]):::ext
  x10(["WeilOnLine · term_conj"]):::ext
  x11(["WeilOnLine · weightedTerm_conjZ"]):::ext
  x12(["WeilSeries · term_le_M"]):::ext
  x13(["WeilTiles · online_term_nonneg"]):::ext
  x14(["WeilTiles · sum_by_bands"]):::ext
  x15(["WeilTiles · sum_le_bandSeries"]):::ext
  x16(["WeilTiles · tsum_upper_le"]):::ext
  x17(["WeilTransform · G"]):::ext
  x18(["WeilTransform · Psi"]):::ext
  x19(["WeilTransform · SigmaC"]):::ext
  x20(["WeilTransform · SigmaC_I_mul"]):::ext
  x21(["WeilTransform · ghat"]):::ext
  x22(["WeilTransform · ghat_ofReal_I"]):::ext
  x23(["WeilWindow · P"]):::ext
  x24(["WeilWindow · P_le_one"]):::ext
  x25(["WeilWindow · P_nonneg"]):::ext
  n0 --> n1
  n0 --> n3
  n1 --> n2
  n1 --> n3
  n1 --> n6
  n1 --> n7
  n1 --> n8
  n1 --> x0
  n1 --> x1
  n1 --> x10
  n1 --> x11
  n1 --> x12
  n1 --> x13
  n1 --> x14
  n1 --> x15
  n1 --> x16
  n1 --> x5
  n1 --> x6
  n1 --> x7
  n1 --> x8
  n2 --> n6
  n3 --> n6
  n3 --> x7
  n4 --> n8
  n5 --> n7
  n6 --> n7
  n6 --> n8
  n6 --> x10
  n6 --> x13
  n7 --> x12
  n7 --> x9
  n8 --> x12
  x17 --> n0
  x17 --> n3
  x18 --> n4
  x18 --> n5
  x18 --> n6
  x18 --> n7
  x18 --> n8
  x19 --> n4
  x2 --> n3
  x2 --> n6
  x2 --> n7
  x2 --> n8
  x20 --> n4
  x21 --> n3
  x22 --> n6
  x23 --> n5
  x24 --> n5
  x25 --> n5
  x3 --> n6
  x4 --> n4
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
| `WeilBackground.phi`<br/>def, line 51 | ℝ | h γ : ℝ; u : ℝ | The window as a test function of the explicit formula: cut off to `[−h, h]`, times `e^{−u/2}`. Real-valued. | `WeilTransform.G` | `WeilBackground.laplace_phi`, `WeilBackground.phiC` |
| `WeilBackground.phiC`<br/>def, line 55 | ℝ → ℂ | h γ : ℝ | The complex-valued test function WeilDetect reads. | `WeilBackground.phi` | `WeilBackground.laplace_phi`, `WeilBackground.online_term_eq`, `WeilBackground.online_term_le_far`, `WeilBackground.online_term_le_near`, `WeilBackground.phiC_real`, `WeilBands.band_sum_le`, `WeilBands.weightedTerm`, `WeilOffLine.offline_term_le`, `WeilOffLine.offline_term_le_explicit`, `WeilOffLine.term_eq_neg_sq`, `WeilOffLine.term_re_eq`, `WeilOnLine.term_conj`, `WeilOnLine.weightedTerm_conjZ`, `WeilSeries.term_le_M`, `WeilTiles.online_term_nonneg`, `WeilTiles.sum_by_bands`, `WeilTiles.sum_le_bandSeries`, `WeilTiles.tsum_upper_le` |
| `WeilBackground.phiC_real`<br/>theorem, line 57 | (phiC h γ u).im = 0 | h γ : ℝ; u : ℝ | — | `WeilBackground.phiC` | `WeilBackground.online_term_eq` |
| `WeilBackground.laplace_phi`<br/>theorem, line 62 | laplace (phiC h γ) z = ghat h γ (-z - 1 / 2) | hh : 0 &lt; h; γ : ℝ; z : ℂ | The transform in the explicit formula's convention. `laplace φ z = ghat h γ (−z − 1/2)`. | `WeilBackground.phi`, `WeilBackground.phiC`, `WeilDetect.laplace`, `WeilTransform.G`, `WeilTransform.ghat` | `WeilBackground.online_term_eq`, `WeilOffLine.term_eq_neg_sq` |
| `WeilBackground.Psi_bound`<br/>theorem, line 85 | \|WeilTransform.Psi s\| ≤ (2 * Real.pi + Real.pi ^ 2) / s ^ 2 | hs : s ≠ 0 | `\|Ψ(s)\| ≤ (2π + π²)/s²` for `s ≠ 0`: the lobe bound at a purely imaginary argument, where `cosh(Re w) = 1` and `‖w‖ = \|s\|`. | `WeilLobe.SigmaC_bound`, `WeilTransform.Psi`, `WeilTransform.SigmaC`, `WeilTransform.SigmaC_I_mul` | `WeilBackground.online_term_le_far` |
| `WeilBackground.Psi_le_two`<br/>theorem, line 103 | \|WeilTransform.Psi s\| ≤ 2 | s : ℝ | `\|Ψ(s)\| ≤ 2`: the integrand is at most `1` in absolute value on an interval of length `2`. | `WeilTransform.Psi`, `WeilWindow.P`, `WeilWindow.P_le_one`, `WeilWindow.P_nonneg` | `WeilBackground.online_term_le_near` |
| `WeilBackground.online_term_eq`<br/>theorem, line 125 | laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ)) = (((h / 2) ^ 2 * (WeilTransform.Psi (h * (ρ.im + γ)) + WeilTransform.Psi (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) | hh : 0 &lt; h; γ : ℝ; hρ : ρ.re = 1 / 2 | On the line the term is a squared modulus: for `Re ρ = 1/2`, `laplace φ(−ρ)·laplace φ(−(1−ρ)) = (h/2)²·[Ψ(h(γ_ρ + γ)) + Ψ(h(γ_ρ − γ))]²`. | `WeilBackground.laplace_phi`, `WeilBackground.phiC`, `WeilBackground.phiC_real`, `WeilDetect.laplace`, `WeilDetect.laplace_conj`, `WeilTransform.Psi`, `WeilTransform.ghat_ofReal_I` | `WeilBackground.online_term_le_far`, `WeilBackground.online_term_le_near`, `WeilOnLine.term_conj`, `WeilTiles.online_term_nonneg` |
| `WeilBackground.online_term_le_near`<br/>theorem, line 149 | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ 4 * h ^ 2 | hh : 0 &lt; h; γ : ℝ; hρ : ρ.re = 1 / 2 | Near the carrier: the on-line term is at most `4h²` (from `\|Ψ\| ≤ 2`). | `WeilBackground.Psi_le_two`, `WeilBackground.online_term_eq`, `WeilBackground.phiC`, `WeilDetect.laplace`, `WeilTransform.Psi` | `WeilOnLine.sum_low_le`, `WeilSeries.term_le_M` |
| `WeilBackground.online_term_le_far`<br/>theorem, line 168 | (laplace (phiC h γ) (-ρ) * laplace (phiC h γ) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * ((2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im - γ)) ^ 2 + (2 * Real.pi + Real.pi ^ 2) / (h * (ρ.im + γ)) ^ 2) ^ 2 | hh : 0 &lt; h; γ : ℝ; hρ : ρ.re = 1 / 2; hfar : 1 ≤ \|ρ.im - γ\|; hsum : 1 ≤ ρ.im + γ | Away from the carrier: for `\|γ_ρ − γ\| ≥ 1` and `γ_ρ + γ ≥ 1`, the on-line term is at most `(h/2)²·[C/(h(γ_ρ−γ))² + C/(h(γ_ρ+γ))²]²`, `C = 2π + π²`. | `WeilBackground.Psi_bound`, `WeilBackground.online_term_eq`, `WeilBackground.phiC`, `WeilDetect.laplace`, `WeilTransform.Psi` | `WeilSeries.term_le_M` |
