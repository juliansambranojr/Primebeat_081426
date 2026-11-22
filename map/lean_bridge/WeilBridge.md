# `lean_bridge/Bridge/WeilBridge.lean`

**What it does** (its own header): WeilBridge — the bridge to primes: the zero side of Weil's form at a test function of Stage 3's class equals the prime side, proved against zeta23's explicit formula. The third tree, `lean_bridge/`. 2026-11-22. The statement is unit 0379's; the choice of a third tree is Julian's of the same day.

**Imports:** nothing in this tree.
**Imported by:** [`Bridge`](../lean_bridge/Bridge.md).

```mermaid
flowchart LR
  n0["that<br/>⊢ every theorem pins to [propext, Classical.choice, Quot.sound]. -/ impo…"]:::lone
  n1["laplace<br/>(def)"]:::dfn
  n2["IsTest<br/>(def)"]:::dfn
  n3["tiltF<br/>(def)"]:::dfn
  n4["kOf<br/>(def)"]:::dfn
  n5["primeSide<br/>(def)"]:::dfn
  n6["primeSide_eq<br/>⊢ primeSide k = literatureRHS k"]:::thm
  n7["tiltF_im<br/>⊢ (tiltF G u).im = 0"]:::thm
  n8["contDiff_tiltF<br/>⊢ ContDiff ℝ 1 (tiltF G)"]:::thm
  n9["hasCompactSupport_tiltF<br/>⊢ HasCompactSupport (tiltF G)"]:::thm
  n10["laplace_neg_eq<br/>⊢ laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ)"]:::thm
  n11["laplace_reflect_eq<br/>⊢ laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ)"]:::thm
  n12["conj_paperFT_conj<br/>⊢ conj (paperFT F (conj z)) = paperFT F (-z)"]:::thm
  n13["contDiff_two_convolution<br/>⊢ ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h)"]:::thm
  n14["contDiff_tilde<br/>⊢ ContDiff ℝ 1 (tilde g)"]:::thm
  n15["contDiff_kOf<br/>⊢ ContDiff ℝ 2 (kOf G)"]:::thm
  n16["hasCompactSupport_kOf<br/>⊢ HasCompactSupport (kOf G)"]:::thm
  n17["paperFT_kOf<br/>⊢ paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ))"]:::thm
  n18["weil_bridge<br/>⊢ Summable (fun ρ : {ρ : ℂ | riemannZeta ρ = 0 ∧ 0 ＜ ρ.re ∧ ρ.re ＜ 1} =＞…"]:::thm
  n19["ft<br/>(def)"]:::dfn
  n20["kOfM<br/>(def)"]:::dfn
  n21["primeSideM<br/>(def)"]:::dfn
  n22["StmtWeilBridge<br/>(def)"]:::dfn
  n23["kOfM_eq<br/>⊢ kOfM G = kOf G"]:::thm
  n24["primeSideM_eq<br/>⊢ primeSideM k = primeSide k"]:::thm
  n25["stmtWeilBridge_holds<br/>⊢ StmtWeilBridge"]:::end_
  n1 --> n10
  n1 --> n11
  n1 --> n17
  n1 --> n18
  n1 --> n22
  n10 --> n17
  n11 --> n17
  n12 --> n17
  n13 --> n15
  n14 --> n15
  n15 --> n18
  n16 --> n18
  n17 --> n18
  n18 --> n25
  n19 --> n21
  n2 --> n18
  n2 --> n22
  n20 --> n22
  n20 --> n23
  n21 --> n22
  n21 --> n24
  n22 --> n25
  n23 --> n25
  n24 --> n25
  n3 --> n10
  n3 --> n11
  n3 --> n20
  n3 --> n4
  n3 --> n7
  n3 --> n8
  n3 --> n9
  n4 --> n15
  n4 --> n16
  n4 --> n17
  n4 --> n18
  n4 --> n23
  n5 --> n18
  n5 --> n24
  n5 --> n6
  n6 --> n18
  n7 --> n17
  n8 --> n15
  n8 --> n17
  n9 --> n15
  n9 --> n16
  n9 --> n17
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
| `that`<br/>theorem, line 39 | every theorem pins to [propext, Classical.choice, Quot.sound]. -/ import Zeta23.WeilEF.Main | — | — | — | — |
| `Bridge.laplace`<br/>def, line 54 | ℂ | G : ℝ → ℂ; z : ℂ | The two-sided Laplace transform. Copied from `Stage3/WeilDetect.lean`. | — | `Bridge.StmtWeilBridge`, `Bridge.laplace_neg_eq`, `Bridge.laplace_reflect_eq`, `Bridge.paperFT_kOf`, `Bridge.weil_bridge` |
| `Bridge.IsTest`<br/>def, line 58 | Prop | L : ℝ; G : ℝ → ℂ | The test-function class at support `L`. Copied from `Stage3/WeilDetect.lean`. | — | `Bridge.StmtWeilBridge`, `Bridge.weil_bridge` |
| `Bridge.tiltF`<br/>def, line 63 | ℝ → ℂ | G : ℝ → ℂ | `F(u) = G(u)·e^{u/2}`: the test function in zeta23's centred variable. | — | `Bridge.contDiff_tiltF`, `Bridge.hasCompactSupport_tiltF`, `Bridge.kOf`, `Bridge.kOfM`, `Bridge.laplace_neg_eq`, `Bridge.laplace_reflect_eq`, `Bridge.tiltF_im` |
| `Bridge.kOf`<br/>def, line 66 | ℝ → ℂ | G : ℝ → ℂ | `k = F ⋆ F̃`, the Weil test function of `G`. | `Bridge.tiltF` | `Bridge.contDiff_kOf`, `Bridge.hasCompactSupport_kOf`, `Bridge.kOfM_eq`, `Bridge.paperFT_kOf`, `Bridge.weil_bridge` |
| `Bridge.primeSide`<br/>def, line 69 | ℂ | k : ℝ → ℂ | zeta23's `literatureRHS`, written out. | — | `Bridge.primeSideM_eq`, `Bridge.primeSide_eq`, `Bridge.weil_bridge` |
| `Bridge.primeSide_eq`<br/>theorem, line 76 | primeSide k = literatureRHS k | k : ℝ → ℂ | — | `Bridge.primeSide` | `Bridge.weil_bridge` |
| `Bridge.tiltF_im`<br/>theorem, line 78 | (tiltF G u).im = 0 | hG : ∀ u, (G u).im = 0; u : ℝ | — | `Bridge.tiltF` | `Bridge.paperFT_kOf` |
| `Bridge.contDiff_tiltF`<br/>theorem, line 83 | ContDiff ℝ 1 (tiltF G) | hG : ContDiff ℝ 1 G | — | `Bridge.tiltF` | `Bridge.contDiff_kOf`, `Bridge.paperFT_kOf` |
| `Bridge.hasCompactSupport_tiltF`<br/>theorem, line 88 | HasCompactSupport (tiltF G) | hG : HasCompactSupport G | — | `Bridge.tiltF` | `Bridge.contDiff_kOf`, `Bridge.hasCompactSupport_kOf`, `Bridge.paperFT_kOf` |
| `Bridge.laplace_neg_eq`<br/>theorem, line 95 | laplace G (-ρ) = paperFT (tiltF G) (gammaOf ρ) | G : ℝ → ℂ; ρ : ℂ | The transform at `−ρ`, in zeta23's variable. | `Bridge.laplace`, `Bridge.tiltF` | `Bridge.paperFT_kOf` |
| `Bridge.laplace_reflect_eq`<br/>theorem, line 108 | laplace G (-(1 - ρ)) = paperFT (tiltF G) (-gammaOf ρ) | G : ℝ → ℂ; ρ : ℂ | The transform at `−(1 − ρ)`, in zeta23's variable. | `Bridge.laplace`, `Bridge.tiltF` | `Bridge.paperFT_kOf` |
| `Bridge.conj_paperFT_conj`<br/>theorem, line 121 | conj (paperFT F (conj z)) = paperFT F (-z) | hF : ∀ u, (F u).im = 0; z : ℂ | For a real-valued `F`, the conjugate-reflected transform is the transform at `−z`. | — | `Bridge.paperFT_kOf` |
| `Bridge.contDiff_two_convolution`<br/>theorem, line 138 | ContDiff ℝ 2 (f ⋆[ContinuousLinearMap.mul ℝ ℂ, volume] h) | hf : ContDiff ℝ 1 f; hfs : HasCompactSupport f; hh : ContDiff ℝ 1 h; hhs : HasCompactSupport h | The convolution of two compactly supported `C¹` functions is `C²`. | — | `Bridge.contDiff_kOf` |
| `Bridge.contDiff_tilde`<br/>theorem, line 159 | ContDiff ℝ 1 (tilde g) | hg : ContDiff ℝ 1 g | — | — | `Bridge.contDiff_kOf` |
| `Bridge.contDiff_kOf`<br/>theorem, line 163 | ContDiff ℝ 2 (kOf G) | hG : ContDiff ℝ 1 G; hGs : HasCompactSupport G | — | `Bridge.contDiff_tilde`, `Bridge.contDiff_tiltF`, `Bridge.contDiff_two_convolution`, `Bridge.hasCompactSupport_tiltF`, `Bridge.kOf` | `Bridge.weil_bridge` |
| `Bridge.hasCompactSupport_kOf`<br/>theorem, line 169 | HasCompactSupport (kOf G) | hGs : HasCompactSupport G | — | `Bridge.hasCompactSupport_tiltF`, `Bridge.kOf` | `Bridge.weil_bridge` |
| `Bridge.paperFT_kOf`<br/>theorem, line 174 | paperFT (kOf G) (gammaOf ρ) = laplace G (-ρ) * laplace G (-(1 - ρ)) | hre : ∀ u, (G u).im = 0; hG : ContDiff ℝ 1 G; hGs : HasCompactSupport G; ρ : ℂ | The term at a zero, in both languages. | `Bridge.conj_paperFT_conj`, `Bridge.contDiff_tiltF`, `Bridge.hasCompactSupport_tiltF`, `Bridge.kOf`, `Bridge.laplace`, `Bridge.laplace_neg_eq`, `Bridge.laplace_reflect_eq`, `Bridge.tiltF_im` | `Bridge.weil_bridge` |
| `Bridge.weil_bridge`<br/>theorem, line 185 | Summable (fun ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1} =&gt; (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ))))) ∧ ∑' ρ : {ρ : ℂ \| riemannZeta ρ = 0 ∧ 0 &lt; ρ.re ∧ ρ.re &lt; 1}, (((analyticOrderAt riemannZeta (ρ : ℂ)).toNat : ℕ) : ℂ) * (laplace G (-(ρ : ℂ)) * laplace G (-(1 - (ρ : ℂ)))) = primeSide (kOf G) | hG : IsTest L G | The bridge. For a test function of Stage 3's class, the zero side of Weil's form, over the nontrivial zeros of `riemannZeta` with multiplicity, is summable and equals the prime side at `k = F ⋆ F̃`. | `Bridge.IsTest`, `Bridge.contDiff_kOf`, `Bridge.hasCompactSupport_kOf`, `Bridge.kOf`, `Bridge.laplace`, `Bridge.paperFT_kOf`, `Bridge.primeSide`, `Bridge.primeSide_eq` | `Bridge.stmtWeilBridge_holds` |
| `Bridge.ft`<br/>def, line 209 | ℂ | k : ℝ → ℂ; z : ℂ | The transform `∫ k(u) e^{izu} du`; zeta23's `paperFT`. | — | `Bridge.primeSideM` |
| `Bridge.kOfM`<br/>def, line 213 | ℝ → ℂ | G : ℝ → ℂ | `k = F ⋆ F̃` in Mathlib's convolution; zeta23's `weilTest` at `F = tiltF G`. | `Bridge.tiltF` | `Bridge.StmtWeilBridge`, `Bridge.kOfM_eq` |
| `Bridge.primeSideM`<br/>def, line 218 | ℂ | k : ℝ → ℂ | The prime side: the pole terms, minus the prime sum, plus the archimedean integral. | `Bridge.ft` | `Bridge.StmtWeilBridge`, `Bridge.primeSideM_eq` |
| `Bridge.StmtWeilBridge`<br/>def, line 226 | Prop | — | The bridge, as a statement. | `Bridge.IsTest`, `Bridge.kOfM`, `Bridge.laplace`, `Bridge.primeSideM` | `Bridge.stmtWeilBridge_holds` |
| `Bridge.kOfM_eq`<br/>theorem, line 236 | kOfM G = kOf G | G : ℝ → ℂ | — | `Bridge.kOf`, `Bridge.kOfM` | `Bridge.stmtWeilBridge_holds` |
| `Bridge.primeSideM_eq`<br/>theorem, line 238 | primeSideM k = primeSide k | k : ℝ → ℂ | — | `Bridge.primeSide`, `Bridge.primeSideM` | `Bridge.stmtWeilBridge_holds` |
| `Bridge.stmtWeilBridge_holds`<br/>theorem, line 241 | StmtWeilBridge | — | The bridge holds. | `Bridge.StmtWeilBridge`, `Bridge.kOfM_eq`, `Bridge.primeSideM_eq`, `Bridge.weil_bridge` | — |
