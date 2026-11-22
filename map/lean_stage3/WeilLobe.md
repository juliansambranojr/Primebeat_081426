# `lean_stage3/Stage3/WeilLobe.lean`

**What it does** (its own header): WeilLobe — the 2γ lobe bounded above. Rung 4a of the detection ladder (units 0316–0318). 2026-09-06.

**Imports:** [`WeilTransform`](../lean_stage3/WeilTransform.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilBackground`](../lean_stage3/WeilBackground.md), [`WeilPower`](../lean_stage3/WeilPower.md).

```mermaid
flowchart LR
  n0["P_eq<br/>⊢ P x = (1 + Real.cos (Real.pi * x)) / 2"]:::thm
  n1["q<br/>(def)"]:::dfn
  n2["q1<br/>(def)"]:::dfn
  n3["q2<br/>(def)"]:::dfn
  n4["q_eq<br/>⊢ x * P x = q x"]:::thm
  n5["hasDerivAt_cos_pi<br/>⊢ HasDerivAt (fun y : ℝ =＞ Real.cos (Real.pi * y)) (-Real.sin (Real.pi *…"]:::thm
  n6["hasDerivAt_sin_pi<br/>⊢ HasDerivAt (fun y : ℝ =＞ Real.sin (Real.pi * y)) (Real.cos (Real.pi * …"]:::thm
  n7["hasDerivAt_q<br/>⊢ HasDerivAt q (q1 x) x"]:::thm
  n8["hasDerivAt_q1<br/>⊢ HasDerivAt q1 (q2 x) x"]:::thm
  n9["q_one<br/>⊢ q 1 = 0"]:::thm
  n10["q_neg_one<br/>⊢ q (-1) = 0"]:::thm
  n11["q1_one<br/>⊢ q1 1 = 0"]:::thm
  n12["q1_neg_one<br/>⊢ q1 (-1) = 0"]:::thm
  n13["continuous_q1<br/>⊢ Continuous q1"]:::thm
  n14["continuous_q2<br/>⊢ Continuous q2"]:::thm
  n15["q2_bound<br/>⊢ |q2 x| ≤ Real.pi + Real.pi ^ 2 / 2"]:::thm
  n16["norm_sinh_le<br/>⊢ ‖Complex.sinh z‖ ≤ Real.cosh z.re"]:::thm
  n17["SigmaC_eq_ibp<br/>⊢ SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Comple…"]:::thm
  n18["SigmaC_bound<br/>⊢ ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2"]:::thm
  n19["lobe_bound<br/>⊢ ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖ ≤ (2 * Real.p…"]:::thm
  x0(["WeilBackground · Psi_bound"]):::ext
  x1(["WeilOffLine · offline_term_le_explicit"]):::ext
  x2(["WeilPowerBounds · norm_S_le'"]):::ext
  x3(["WeilTransform · SigmaC"]):::ext
  x4(["WeilWindow · P"]):::ext
  n0 --> n4
  n1 --> n10
  n1 --> n17
  n1 --> n4
  n1 --> n7
  n1 --> n9
  n10 --> n17
  n11 --> n17
  n12 --> n17
  n13 --> n17
  n14 --> n17
  n15 --> n18
  n16 --> n18
  n16 --> x2
  n17 --> n18
  n18 --> n19
  n18 --> x0
  n19 --> x1
  n2 --> n11
  n2 --> n12
  n2 --> n13
  n2 --> n17
  n2 --> n7
  n2 --> n8
  n3 --> n14
  n3 --> n15
  n3 --> n17
  n3 --> n18
  n3 --> n8
  n4 --> n17
  n5 --> n7
  n5 --> n8
  n6 --> n8
  n7 --> n17
  n8 --> n17
  n9 --> n17
  x3 --> n17
  x3 --> n18
  x3 --> n19
  x4 --> n0
  x4 --> n17
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
| `WeilLobe.P_eq`<br/>theorem, line 43 | P x = (1 + Real.cos (Real.pi * x)) / 2 | x : ℝ | The half-angle form of the window. | `WeilWindow.P` | `WeilLobe.q_eq` |
| `WeilLobe.q`<br/>def, line 50 | ℝ | x : ℝ | The envelope `q(x) = x·P(x)` in half-angle form. | — | `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.hasDerivAt_q`, `WeilLobe.q_eq`, `WeilLobe.q_neg_one`, `WeilLobe.q_one` |
| `WeilLobe.q1`<br/>def, line 53 | ℝ | x : ℝ | `q'`. | — | `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.continuous_q1`, `WeilLobe.hasDerivAt_q`, `WeilLobe.hasDerivAt_q1`, `WeilLobe.q1_neg_one`, `WeilLobe.q1_one` |
| `WeilLobe.q2`<br/>def, line 56 | ℝ | x : ℝ | `q''`. | — | `WeilLobe.SigmaC_bound`, `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.continuous_q2`, `WeilLobe.hasDerivAt_q1`, `WeilLobe.q2_bound` |
| `WeilLobe.q_eq`<br/>theorem, line 58 | x * P x = q x | x : ℝ | — | `WeilLobe.P_eq`, `WeilLobe.q`, `WeilWindow.P` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.hasDerivAt_cos_pi`<br/>theorem, line 61 | HasDerivAt (fun y : ℝ =&gt; Real.cos (Real.pi * y)) (-Real.sin (Real.pi * x) * Real.pi) x | x : ℝ | — | — | `WeilLobe.hasDerivAt_q`, `WeilLobe.hasDerivAt_q1` |
| `WeilLobe.hasDerivAt_sin_pi`<br/>theorem, line 66 | HasDerivAt (fun y : ℝ =&gt; Real.sin (Real.pi * y)) (Real.cos (Real.pi * x) * Real.pi) x | x : ℝ | — | — | `WeilLobe.hasDerivAt_q1` |
| `WeilLobe.hasDerivAt_q`<br/>theorem, line 71 | HasDerivAt q (q1 x) x | x : ℝ | — | `WeilLobe.hasDerivAt_cos_pi`, `WeilLobe.q`, `WeilLobe.q1` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.hasDerivAt_q1`<br/>theorem, line 77 | HasDerivAt q1 (q2 x) x | x : ℝ | — | `WeilLobe.hasDerivAt_cos_pi`, `WeilLobe.hasDerivAt_sin_pi`, `WeilLobe.q1`, `WeilLobe.q2` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.q_one`<br/>theorem, line 86 | q 1 = 0 | — | — | `WeilLobe.q` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.q_neg_one`<br/>theorem, line 89 | q (-1) = 0 | — | — | `WeilLobe.q` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.q1_one`<br/>theorem, line 92 | q1 1 = 0 | — | — | `WeilLobe.q1` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.q1_neg_one`<br/>theorem, line 95 | q1 (-1) = 0 | — | — | `WeilLobe.q1` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.continuous_q1`<br/>theorem, line 99 | Continuous q1 | — | — | `WeilLobe.q1` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.continuous_q2`<br/>theorem, line 103 | Continuous q2 | — | — | `WeilLobe.q2` | `WeilLobe.SigmaC_eq_ibp` |
| `WeilLobe.q2_bound`<br/>theorem, line 107 | \|q2 x\| ≤ Real.pi + Real.pi ^ 2 / 2 | hx : \|x\| ≤ 1 | `\|q''(x)\| ≤ π + π²/2` on `[−1, 1]`. | `WeilLobe.q2` | `WeilLobe.SigmaC_bound` |
| `WeilLobe.norm_sinh_le`<br/>theorem, line 126 | ‖Complex.sinh z‖ ≤ Real.cosh z.re | z : ℂ | `‖sinh z‖ ≤ cosh(Re z)`. | — | `WeilLobe.SigmaC_bound`, `WeilPowerBounds.norm_S_le'` |
| `WeilLobe.SigmaC_eq_ibp`<br/>theorem, line 136 | SigmaC w = (1 / w ^ 2) * ∫ x in (-1 : ℝ)..1, ((q2 x : ℝ) : ℂ) * Complex.sinh (w * (x : ℂ)) | w : ℂ; hw : w ≠ 0 | Integration by parts, twice: `Σc(w) = w⁻²·∫ q''·sinh(w·)`. | `WeilLobe.continuous_q1`, `WeilLobe.continuous_q2`, `WeilLobe.hasDerivAt_q`, `WeilLobe.hasDerivAt_q1`, `WeilLobe.q`, `WeilLobe.q1`, `WeilLobe.q1_neg_one`, `WeilLobe.q1_one`, `WeilLobe.q2`, `WeilLobe.q_eq`, `WeilLobe.q_neg_one`, `WeilLobe.q_one`, `WeilTransform.SigmaC`, `WeilWindow.P` | `WeilLobe.SigmaC_bound` |
| `WeilLobe.SigmaC_bound`<br/>theorem, line 187 | ‖SigmaC w‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh w.re / ‖w‖ ^ 2 | w : ℂ; hw : w ≠ 0 | (†) `‖Σc(w)‖ ≤ (2π + π²)·cosh(Re w)/‖w‖²`. | `WeilLobe.SigmaC_eq_ibp`, `WeilLobe.norm_sinh_le`, `WeilLobe.q2`, `WeilLobe.q2_bound`, `WeilTransform.SigmaC` | `WeilBackground.Psi_bound`, `WeilLobe.lobe_bound` |
| `WeilLobe.lobe_bound`<br/>theorem, line 219 | ‖SigmaC (((ε : ℂ) + 2 * Complex.I * (γ : ℂ)) * (h : ℂ))‖ ≤ (2 * Real.pi + Real.pi ^ 2) * Real.cosh (ε * h) / (2 * γ * h) ^ 2 | hh : 0 &lt; h; hγ : 0 &lt; γ; ε : ℝ | The lobe at the off-line point: for `h, γ &gt; 0`, `‖Σc((ε + 2iγ)h)‖ ≤ (2π + π²)·cosh(εh)/(2γh)²`. | `WeilLobe.SigmaC_bound`, `WeilTransform.SigmaC` | `WeilOffLine.offline_term_le_explicit` |
