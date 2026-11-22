# `lean_stage3/Stage3/WeilPowerBackground.lean`

**What it does** (its own header): WeilPowerBackground — the switched window as a test function of the explicit formula, every term of the zero form as minus a square, and the on-line terms bounded. Rung 5, fifth slice. 2026-09-06.

**Imports:** [`WeilDetect`](../lean_stage3/WeilDetect.md), [`WeilPowerBounds`](../lean_stage3/WeilPowerBounds.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerBands`](../lean_stage3/WeilPowerBands.md).

```mermaid
flowchart LR
  n0["phiW<br/>(def)"]:::dfn
  n1["phiWC<br/>(def)"]:::dfn
  n2["phiWC_real<br/>⊢ (phiWC h γ m u).im = 0"]:::thm
  n3["laplace_phiW<br/>⊢ laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2)"]:::thm
  n4["S_eq_sinh<br/>⊢ S m w = ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.sinh (w * (x :…"]:::thm
  n5["S_neg<br/>⊢ S m (-w) = -S m w"]:::thm
  n6["what_neg<br/>⊢ what h γ m (-z) = -what h γ m z"]:::thm
  n7["term_eq_neg_sq<br/>⊢ laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = -(what…"]:::thm
  n8["term_re_eq<br/>⊢ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re = (…"]:::thm
  n9["PsiW<br/>(def)"]:::dfn
  n10["S_I_mul<br/>⊢ S m (Complex.I * (t : ℂ)) = Complex.I * (PsiW m t : ℂ)"]:::thm
  n11["what_I<br/>⊢ what h γ m (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((PsiW …"]:::thm
  n12["online_term_eq<br/>⊢ laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = (((h /…"]:::thm
  n13["online_term_nonneg<br/>⊢ 0 ≤ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re"]:::end_
  n14["abs_q_le_one<br/>⊢ |q m x| ≤ 1"]:::thm
  n15["PsiW_le_two<br/>⊢ |PsiW m t| ≤ 2"]:::thm
  n16["online_term_le_near<br/>⊢ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ 4…"]:::thm
  n17["PsiW_le_far<br/>⊢ |PsiW m t| ≤ cS m * (2 / t ^ 2) ^ (m + 1)"]:::thm
  n18["online_term_le_far<br/>⊢ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ (…"]:::end_
  x0(["WeilDetect · laplace"]):::ext
  x1(["WeilOddPower · S"]):::ext
  x2(["WeilOddPower · W"]):::ext
  x3(["WeilOddPower · cS"]):::ext
  x4(["WeilOddPower · continuous_q"]):::ext
  x5(["WeilOddPower · q"]):::ext
  x6(["WeilOddPower · q_odd"]):::ext
  x7(["WeilOddPower · what"]):::ext
  x8(["WeilOddPower · what_eq"]):::ext
  x9(["WeilPowerAssembly · isTest_phiWC"]):::ext
  x10(["WeilPowerAssembly · phiW_contDiff_one"]):::ext
  x11(["WeilPowerBounds · norm_S_le_far"]):::ext
  x12(["WeilPowerBridge · term_eq_sidebands"]):::ext
  x13(["WeilPowerOnLine · PsiW_neg"]):::ext
  x14(["WeilPowerOnLine · sum_low_le"]):::ext
  x15(["WeilPowerOnLine · term_conj"]):::ext
  x16(["WeilTransform · odd_integral_exp"]):::ext
  x17(["WeilWindow · P"]):::ext
  x18(["WeilWindow · P_le_one"]):::ext
  x19(["WeilWindow · P_nonneg"]):::ext
  n0 --> n1
  n0 --> n3
  n0 --> x10
  n0 --> x9
  n1 --> n12
  n1 --> n13
  n1 --> n16
  n1 --> n18
  n1 --> n2
  n1 --> n3
  n1 --> n7
  n1 --> n8
  n1 --> x9
  n10 --> n11
  n10 --> n17
  n11 --> n12
  n12 --> n13
  n12 --> n16
  n12 --> n18
  n12 --> x15
  n14 --> n15
  n15 --> n16
  n16 --> x14
  n17 --> n18
  n2 --> x9
  n3 --> n7
  n4 --> n10
  n4 --> n5
  n5 --> n6
  n6 --> n7
  n7 --> n12
  n7 --> n8
  n8 --> x12
  n9 --> n10
  n9 --> n11
  n9 --> n12
  n9 --> n15
  n9 --> n16
  n9 --> n17
  n9 --> n18
  n9 --> x13
  x0 --> n12
  x0 --> n13
  x0 --> n16
  x0 --> n18
  x0 --> n3
  x0 --> n7
  x0 --> n8
  x1 --> n10
  x1 --> n4
  x1 --> n5
  x11 --> n17
  x16 --> n4
  x17 --> n14
  x18 --> n14
  x19 --> n14
  x2 --> n0
  x2 --> n3
  x3 --> n17
  x3 --> n18
  x4 --> n4
  x5 --> n14
  x5 --> n15
  x5 --> n4
  x5 --> n9
  x6 --> n4
  x7 --> n11
  x7 --> n3
  x7 --> n6
  x7 --> n7
  x7 --> n8
  x8 --> n11
  x8 --> n6
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
| `WeilPowerBackground.phiW`<br/>def, line 48 | ℝ | h γ : ℝ; m : ℕ; u : ℝ | The window as a test function of the explicit formula: cut off to `[−h, h]`, times `e^{−u/2}`. Real-valued. | `WeilOddPower.W` | `WeilPowerAssembly.isTest_phiWC`, `WeilPowerAssembly.phiW_contDiff_one`, `WeilPowerBackground.laplace_phiW`, `WeilPowerBackground.phiWC` |
| `WeilPowerBackground.phiWC`<br/>def, line 52 | ℝ → ℂ | h γ : ℝ; m : ℕ | The complex-valued test function WeilDetect reads. | `WeilPowerBackground.phiW` | `WeilPowerAssembly.isTest_phiWC`, `WeilPowerBackground.laplace_phiW`, `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.online_term_le_far`, `WeilPowerBackground.online_term_le_near`, `WeilPowerBackground.online_term_nonneg`, `WeilPowerBackground.phiWC_real`, `WeilPowerBackground.term_eq_neg_sq`, `WeilPowerBackground.term_re_eq` |
| `WeilPowerBackground.phiWC_real`<br/>theorem, line 54 | (phiWC h γ m u).im = 0 | h γ : ℝ; m : ℕ; u : ℝ | — | `WeilPowerBackground.phiWC` | `WeilPowerAssembly.isTest_phiWC` |
| `WeilPowerBackground.laplace_phiW`<br/>theorem, line 59 | laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2) | hh : 0 &lt; h; γ : ℝ; m : ℕ; z : ℂ | The transform in the explicit formula's convention. `laplace φ z = what h γ m (−z − 1/2)`. | `WeilDetect.laplace`, `WeilOddPower.W`, `WeilOddPower.what`, `WeilPowerBackground.phiW`, `WeilPowerBackground.phiWC` | `WeilPowerBackground.term_eq_neg_sq` |
| `WeilPowerBackground.S_eq_sinh`<br/>theorem, line 81 | S m w = ∫ x in (-1 : ℝ)..1, ((q m x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) | m : ℕ; w : ℂ | The odd envelope's transform through `sinh`: unit 0318's odd-part lemma. | `WeilOddPower.S`, `WeilOddPower.continuous_q`, `WeilOddPower.q`, `WeilOddPower.q_odd`, `WeilTransform.odd_integral_exp` | `WeilPowerBackground.S_I_mul`, `WeilPowerBackground.S_neg` |
| `WeilPowerBackground.S_neg`<br/>theorem, line 87 | S m (-w) = -S m w | m : ℕ; w : ℂ | `S` is odd. | `WeilOddPower.S`, `WeilPowerBackground.S_eq_sinh` | `WeilPowerBackground.what_neg` |
| `WeilPowerBackground.what_neg`<br/>theorem, line 95 | what h γ m (-z) = -what h γ m z | hh : 0 &lt; h; γ : ℝ; m : ℕ; z : ℂ | The window's transform is odd. | `WeilOddPower.what`, `WeilOddPower.what_eq`, `WeilPowerBackground.S_neg` | `WeilPowerBackground.term_eq_neg_sq` |
| `WeilPowerBackground.term_eq_neg_sq`<br/>theorem, line 106 | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = -(what h γ m (ρ - 1 / 2)) ^ 2 | hh : 0 &lt; h; γ : ℝ; m : ℕ; ρ : ℂ | Every term is minus a square. | `WeilDetect.laplace`, `WeilOddPower.what`, `WeilPowerBackground.laplace_phiW`, `WeilPowerBackground.phiWC`, `WeilPowerBackground.what_neg` | `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.term_re_eq` |
| `WeilPowerBackground.term_re_eq`<br/>theorem, line 115 | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re = (what h γ m (ρ - 1 / 2)).im ^ 2 - (what h γ m (ρ - 1 / 2)).re ^ 2 | hh : 0 &lt; h; γ : ℝ; m : ℕ; ρ : ℂ | — | `WeilDetect.laplace`, `WeilOddPower.what`, `WeilPowerBackground.phiWC`, `WeilPowerBackground.term_eq_neg_sq` | `WeilPowerBridge.term_eq_sidebands` |
| `WeilPowerBackground.PsiW`<br/>def, line 122 | ℝ | m : ℕ; t : ℝ | `PsiW m t = ∫₋₁¹ q m x · sin(tx) dx`: the transform on the line, real. | `WeilOddPower.q` | `WeilPowerBackground.PsiW_le_far`, `WeilPowerBackground.PsiW_le_two`, `WeilPowerBackground.S_I_mul`, `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.online_term_le_far`, `WeilPowerBackground.online_term_le_near`, `WeilPowerBackground.what_I`, `WeilPowerOnLine.PsiW_neg` |
| `WeilPowerBackground.S_I_mul`<br/>theorem, line 125 | S m (Complex.I * (t : ℂ)) = Complex.I * (PsiW m t : ℂ) | m : ℕ; t : ℝ | `S m (it) = i·PsiW m t`. | `WeilOddPower.S`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.S_eq_sinh` | `WeilPowerBackground.PsiW_le_far`, `WeilPowerBackground.what_I` |
| `WeilPowerBackground.what_I`<br/>theorem, line 138 | what h γ m (Complex.I * (t : ℂ)) = Complex.I * ((h : ℂ) / 2) * ((PsiW m (h * (t + γ)) : ℂ) + (PsiW m (h * (t - γ)) : ℂ)) | hh : 0 &lt; h; γ : ℝ; m : ℕ; t : ℝ | The window's transform on the line: `what h γ m (it) = i(h/2)[PsiW(h(t+γ)) + PsiW(h(t−γ))]`. | `WeilOddPower.what`, `WeilOddPower.what_eq`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.S_I_mul` | `WeilPowerBackground.online_term_eq` |
| `WeilPowerBackground.online_term_eq`<br/>theorem, line 150 | laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ)) = (((h / 2) ^ 2 * (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) | hh : 0 &lt; h; γ : ℝ; m : ℕ; hρ : ρ.re = 1 / 2 | On the line the term is a real square. | `WeilDetect.laplace`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.phiWC`, `WeilPowerBackground.term_eq_neg_sq`, `WeilPowerBackground.what_I` | `WeilPowerBackground.online_term_le_far`, `WeilPowerBackground.online_term_le_near`, `WeilPowerBackground.online_term_nonneg`, `WeilPowerOnLine.term_conj` |
| `WeilPowerBackground.online_term_nonneg`<br/>theorem, line 164 | 0 ≤ (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re | hh : 0 &lt; h; γ : ℝ; m : ℕ; hρ : ρ.re = 1 / 2 | — | `WeilDetect.laplace`, `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.phiWC` | — |
| `WeilPowerBackground.abs_q_le_one`<br/>theorem, line 170 | \|q m x\| ≤ 1 | m : ℕ; x : ℝ | `\|q m x\| ≤ 1` on `[−1, 1]`. | `WeilOddPower.q`, `WeilWindow.P`, `WeilWindow.P_le_one`, `WeilWindow.P_nonneg` | `WeilPowerBackground.PsiW_le_two` |
| `WeilPowerBackground.PsiW_le_two`<br/>theorem, line 181 | \|PsiW m t\| ≤ 2 | m : ℕ; t : ℝ | `\|PsiW m t\| ≤ 2`. | `WeilOddPower.q`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.abs_q_le_one` | `WeilPowerBackground.online_term_le_near` |
| `WeilPowerBackground.online_term_le_near`<br/>theorem, line 196 | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ 4 * h ^ 2 | hh : 0 &lt; h; γ : ℝ; m : ℕ; hρ : ρ.re = 1 / 2 | Near the carrier: the on-line term is at most `4h²`. | `WeilDetect.laplace`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.PsiW_le_two`, `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.phiWC` | `WeilPowerOnLine.sum_low_le` |
| `WeilPowerBackground.PsiW_le_far`<br/>theorem, line 215 | \|PsiW m t\| ≤ cS m * (2 / t ^ 2) ^ (m + 1) | ht : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ t ^ 2 | `\|PsiW m t\| ≤ cS m·(2/t²)^{m+1}` when `2π²(m+1)² ≤ t²`: unit 0331's far bound at real part zero. | `WeilOddPower.cS`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.S_I_mul`, `WeilPowerBounds.norm_S_le_far` | `WeilPowerBackground.online_term_le_far` |
| `WeilPowerBackground.online_term_le_far`<br/>theorem, line 223 | (laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))).re ≤ (h / 2) ^ 2 * (cS m * (2 / (h * (ρ.im - γ)) ^ 2) ^ (m + 1) + cS m * (2 / (h * (ρ.im + γ)) ^ 2) ^ (m + 1)) ^ 2 | hh : 0 &lt; h; γ : ℝ; m : ℕ; hρ : ρ.re = 1 / 2; hfar1 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (ρ.im - γ)) ^ 2; hfar2 : 2 * (Real.pi ^ 2 * ((m : ℝ) + 1) ^ 2) ≤ (h * (ρ.im + γ)) ^ 2 | Away from the carrier: for `h\|γ_ρ ∓ γ\|` both at least `√2·π(m+1)`, the on-line term is at most `(h/2)²·[cS m·(2/(h(γ_ρ−γ))²)^{m+1} + cS m·(2/(h(γ_ρ+γ))²)^{m+1}]²`. | `WeilDetect.laplace`, `WeilOddPower.cS`, `WeilPowerBackground.PsiW`, `WeilPowerBackground.PsiW_le_far`, `WeilPowerBackground.online_term_eq`, `WeilPowerBackground.phiWC` | — |
