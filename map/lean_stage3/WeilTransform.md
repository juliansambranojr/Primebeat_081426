# `lean_stage3/Stage3/WeilTransform.lean`

**What it does** (its own header): WeilTransform — the transform of the tuned window in closed form. Rung 3 of the detection ladder (units 0316, 0317). 2026-09-06.

**Imports:** [`WeilWindow`](../lean_stage3/WeilWindow.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilLobe`](../lean_stage3/WeilLobe.md).

```mermaid
flowchart LR
  n0["SigmaC<br/>(def)"]:::dfn
  n1["Psi<br/>(def)"]:::dfn
  n2["G<br/>(def)"]:::dfn
  n3["ghat<br/>(def)"]:::dfn
  n4["P_even<br/>⊢ P (-x) = P x"]:::thm
  n5["xP_odd<br/>⊢ (-x) * P (-x) = -(x * P x)"]:::thm
  n6["continuous_xP<br/>⊢ Continuous fun x : ℝ =＞ x * P x"]:::thm
  n7["SigmaC_ofReal<br/>⊢ SigmaC (s : ℂ) = (WeilWindow.Sigma s : ℂ)"]:::thm
  n8["SigmaC_I_mul<br/>⊢ SigmaC (Complex.I * (s : ℂ)) = Complex.I * (Psi s : ℂ)"]:::thm
  n9["odd_integral_exp<br/>⊢ (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = ∫ …"]:::thm
  n10["ghat_eq<br/>⊢ ghat h γ z = ((h : ℂ) / 2) * (SigmaC ((z + Complex.I * (γ : ℂ)) * (h :…"]:::thm
  n11["ghat_ofReal_I<br/>⊢ ghat h γ (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((Psi (h …"]:::thm
  n12["ghat_offline<br/>⊢ ghat h γ ((ε : ℂ) + Complex.I * (γ : ℂ)) = ((h : ℂ) / 2) * (SigmaC (((…"]:::thm
  x0(["WeilBackground · Psi_bound"]):::ext
  x1(["WeilBackground · Psi_le_two"]):::ext
  x2(["WeilBackground · laplace_phi"]):::ext
  x3(["WeilBackground · online_term_eq"]):::ext
  x4(["WeilBackground · online_term_le_far"]):::ext
  x5(["WeilBackground · online_term_le_near"]):::ext
  x6(["WeilBackground · phi"]):::ext
  x7(["WeilLobe · SigmaC_bound"]):::ext
  x8(["WeilLobe · SigmaC_eq_ibp"]):::ext
  x9(["WeilLobe · lobe_bound"]):::ext
  x10(["WeilOddPower · q_odd"]):::ext
  x11(["WeilOffLine · SigmaC_neg"]):::ext
  x12(["WeilOffLine · ghat_neg"]):::ext
  x13(["WeilOffLine · offline_term_le"]):::ext
  x14(["WeilOffLine · offline_term_le_explicit"]):::ext
  x15(["WeilOffLine · term_eq_neg_sq"]):::ext
  x16(["WeilOffLine · term_re_eq"]):::ext
  x17(["WeilOnLine · Psi_neg"]):::ext
  x18(["WeilPowerBackground · S_eq_sinh"]):::ext
  x19(["WeilWindow · P"]):::ext
  x20(["WeilWindow · Sigma"]):::ext
  x21(["WeilWindow · continuous_P"]):::ext
  n0 --> n10
  n0 --> n12
  n0 --> n7
  n0 --> n8
  n0 --> x0
  n0 --> x11
  n0 --> x13
  n0 --> x14
  n0 --> x7
  n0 --> x8
  n0 --> x9
  n1 --> n11
  n1 --> n8
  n1 --> x0
  n1 --> x1
  n1 --> x17
  n1 --> x3
  n1 --> x4
  n1 --> x5
  n10 --> n11
  n10 --> n12
  n10 --> x12
  n11 --> x3
  n12 --> x13
  n2 --> n10
  n2 --> n3
  n2 --> x2
  n2 --> x6
  n3 --> n10
  n3 --> n11
  n3 --> n12
  n3 --> x12
  n3 --> x15
  n3 --> x16
  n3 --> x2
  n4 --> n5
  n4 --> x10
  n5 --> n10
  n6 --> n10
  n7 --> n12
  n8 --> n11
  n8 --> x0
  n9 --> n10
  n9 --> x18
  x19 --> n0
  x19 --> n1
  x19 --> n10
  x19 --> n2
  x19 --> n4
  x19 --> n5
  x19 --> n6
  x20 --> n12
  x20 --> n7
  x21 --> n6
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
| `WeilTransform.SigmaC`<br/>def, line 48 | ℂ | w : ℂ | The odd envelope at complex argument, `∫₋₁¹ x·P(x)·sinh(w x) dx`. | `WeilWindow.P` | `WeilBackground.Psi_bound`, `WeilLobe.SigmaC_bound`, `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.lobe_bound`, `WeilOffLine.SigmaC_neg`, `WeilOffLine.offline_term_le`, `WeilOffLine.offline_term_le_explicit`, `WeilTransform.SigmaC_I_mul`, `WeilTransform.SigmaC_ofReal`, `WeilTransform.ghat_eq`, `WeilTransform.ghat_offline` |
| `WeilTransform.Psi`<br/>def, line 52 | ℝ | s : ℝ | `Ψ(s) = ∫₋₁¹ x·P(x)·sin(s x) dx`, entry 302's transform of the envelope. | `WeilWindow.P` | `WeilBackground.Psi_bound`, `WeilBackground.Psi_le_two`, `WeilBackground.online_term_eq`, `WeilBackground.online_term_le_far`, `WeilBackground.online_term_le_near`, `WeilOnLine.Psi_neg`, `WeilTransform.SigmaC_I_mul`, `WeilTransform.ghat_ofReal_I` |
| `WeilTransform.G`<br/>def, line 55 | ℝ | h γ : ℝ; u : ℝ | The tuned window: `(u/h)·P(u/h)·cos(γu)`, read on `[−h, h]`. | `WeilWindow.P` | `WeilBackground.laplace_phi`, `WeilBackground.phi`, `WeilTransform.ghat`, `WeilTransform.ghat_eq` |
| `WeilTransform.ghat`<br/>def, line 58 | ℂ | h γ : ℝ; z : ℂ | Its transform, `∫₋ₕʰ G(u)·e^{zu} du`. | `WeilTransform.G` | `WeilBackground.laplace_phi`, `WeilOffLine.ghat_neg`, `WeilOffLine.term_eq_neg_sq`, `WeilOffLine.term_re_eq`, `WeilTransform.ghat_eq`, `WeilTransform.ghat_ofReal_I`, `WeilTransform.ghat_offline` |
| `WeilTransform.P_even`<br/>theorem, line 61 | P (-x) = P x | x : ℝ | — | `WeilWindow.P` | `WeilOddPower.q_odd`, `WeilTransform.xP_odd` |
| `WeilTransform.xP_odd`<br/>theorem, line 65 | (-x) * P (-x) = -(x * P x) | x : ℝ | — | `WeilTransform.P_even`, `WeilWindow.P` | `WeilTransform.ghat_eq` |
| `WeilTransform.continuous_xP`<br/>theorem, line 68 | Continuous fun x : ℝ =&gt; x * P x | — | — | `WeilWindow.P`, `WeilWindow.continuous_P` | `WeilTransform.ghat_eq` |
| `WeilTransform.SigmaC_ofReal`<br/>theorem, line 72 | SigmaC (s : ℂ) = (WeilWindow.Sigma s : ℂ) | s : ℝ | `Σc` at a real argument is `Σ`. | `WeilTransform.SigmaC`, `WeilWindow.Sigma` | `WeilTransform.ghat_offline` |
| `WeilTransform.SigmaC_I_mul`<br/>theorem, line 80 | SigmaC (Complex.I * (s : ℂ)) = Complex.I * (Psi s : ℂ) | s : ℝ | `Σc(i s) = i·Ψ(s)`: `sinh(iθ) = i·sin θ`. | `WeilTransform.Psi`, `WeilTransform.SigmaC` | `WeilBackground.Psi_bound`, `WeilTransform.ghat_ofReal_I` |
| `WeilTransform.odd_integral_exp`<br/>theorem, line 94 | (∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.exp (w * (x : ℂ))) = ∫ x in (-1 : ℝ)..1, ((q x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) | q : ℝ → ℝ; hq : ∀ x, q (-x) = -q x; hc : Continuous q; w : ℂ | The odd-part lemma. For odd continuous `q` on `[−1, 1]`, `∫ q·e^{w·} = ∫ q·sinh(w·)`: the `cosh` part of `e^{w·}` pairs with `q` into an odd function, whose integral over the symmetric interval vanishes. | — | `WeilPowerBackground.S_eq_sinh`, `WeilTransform.ghat_eq` |
| `WeilTransform.ghat_eq`<br/>theorem, line 144 | ghat h γ z = ((h : ℂ) / 2) * (SigmaC ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + SigmaC ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) | hh : 0 &lt; h; γ : ℝ; z : ℂ | (★) The transform in closed form. | `WeilTransform.G`, `WeilTransform.SigmaC`, `WeilTransform.continuous_xP`, `WeilTransform.ghat`, `WeilTransform.odd_integral_exp`, `WeilTransform.xP_odd`, `WeilWindow.P` | `WeilOffLine.ghat_neg`, `WeilTransform.ghat_ofReal_I`, `WeilTransform.ghat_offline` |
| `WeilTransform.ghat_ofReal_I`<br/>theorem, line 195 | ghat h γ (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((Psi (h * (t + γ)) : ℂ) + (Psi (h * (t - γ)) : ℂ)) | hh : 0 &lt; h; γ t : ℝ | (★) on the real line: entry 302's `(ih/2)[Ψ(h(t+γ)) + Ψ(h(t−γ))]`. | `WeilTransform.Psi`, `WeilTransform.SigmaC_I_mul`, `WeilTransform.ghat`, `WeilTransform.ghat_eq` | `WeilBackground.online_term_eq` |
| `WeilTransform.ghat_offline`<br/>theorem, line 208 | ghat h γ ((ε : ℂ) + Complex.I * (γ : ℂ)) = ((h : ℂ) / 2) * (SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ)) + (WeilWindow.Sigma (ε * h) : ℂ)) | hh : 0 &lt; h; γ ε : ℝ | (★) at the off-line point `z = ε + iγ`: the main term `Σ(εh)` of unit 0317 plus the `2γ` lobe `Σc((ε + 2iγ)h)`. | `WeilTransform.SigmaC`, `WeilTransform.SigmaC_ofReal`, `WeilTransform.ghat`, `WeilTransform.ghat_eq`, `WeilWindow.Sigma` | `WeilOffLine.offline_term_le` |
