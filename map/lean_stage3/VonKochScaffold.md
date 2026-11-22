# `lean_stage3/Stage3/VonKochScaffold.lean`

**What it does** (its own header): # Von Koch converse — roadmap B1, COMPLETE (∃ C x₀, ∀ t ≥ x₀, |ψ t − t| ≤ C·√t·(log t)³) → RiemannHypothesis

**Imports:** [`LineBound`](../lean_stage3/LineBound.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`ThetaConverse`](../lean_stage3/ThetaConverse.md).

```mermaid
flowchart LR
  n0["E<br/>(def)"]:::dfn
  n1["F<br/>(def)"]:::dfn
  n2["Etr<br/>(def)"]:::dfn
  n3["measurable_psi'<br/>⊢ Measurable (fun t : ℝ ↦ ψ t)"]:::lone
  n4["Etr_measurable<br/>⊢ Measurable Etr"]:::end_
  n5["E_le_linear<br/>⊢ ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t"]:::thm
  n6["E_integral_eq_mellin<br/>⊢ ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s)"]:::thm
  n7["Etr_locallyIntegrable<br/>⊢ MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0)"]:::thm
  n8["F_differentiableAt<br/>⊢ DifferentiableAt ℂ F s"]:::thm
  n9["sum_Icc_vonMangoldt<br/>⊢ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n"]:::thm
  n10["psi_partial_bigO<br/>⊢ (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =…"]:::thm
  n11["measurable_psi<br/>⊢ Measurable (fun t : ℝ ↦ ψ t)"]:::thm
  n12["integrable_psi_cpow<br/>⊢ IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set…"]:::thm
  n13["F_eq_neg_logDeriv<br/>⊢ F s = -deriv riemannZeta s / riemannZeta s"]:::thm
  n14["region<br/>(def)"]:::dfn
  n15["isOpen_region<br/>⊢ IsOpen region"]:::thm
  n16["preconnected_region<br/>⊢ IsPreconnected region"]:::thm
  n17["zeta_analyticOnNhd<br/>⊢ AnalyticOnNhd ℂ riemannZeta region"]:::thm
  n18["F_analyticOnNhd<br/>⊢ AnalyticOnNhd ℂ F region"]:::thm
  n19["F_mul_zeta_add_deriv_eqOn_zero<br/>⊢ Set.EqOn (fun s : ℂ ↦ F s * riemannZeta s + deriv riemannZeta s) 0 reg…"]:::thm
  n20["F_eq_neg_logDeriv_ext<br/>⊢ F s = -deriv riemannZeta s / riemannZeta s"]:::end_
  n21["no_zero_right_of_half<br/>⊢ riemannZeta ρ ≠ 0"]:::thm
  n22["RH_of_no_zero_right_of_half<br/>⊢ RiemannHypothesis"]:::thm
  n23["RH_of_psiWeak<br/>⊢ RiemannHypothesis"]:::thm
  n24["RH_iff_psiWeak<br/>⊢ RiemannHypothesis ↔ ∃ C ＞ 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀"]:::end_
  x0(["LineBound · stmtPsiWeak_of_RH"]):::ext
  x1(["PsiToPi · StmtPsiWeak"]):::ext
  x2(["ThetaConverse · F_analyticOnNhd_theta"]):::ext
  x3(["ThetaConverse · F_differentiableAt_theta"]):::ext
  x4(["ThetaConverse · F_mul_zeta_add_deriv_eqOn_zero_theta"]):::ext
  x5(["ThetaConverse · RH_of_psiWeakTheta_half"]):::ext
  x6(["ThetaConverse · no_zero_right_of_theta"]):::ext
  x7(["ThetaConverse · regionθ_half"]):::ext
  x8(["ThetaConverse · zeroFreeRight_one_of_chebyshev"]):::ext
  n0 --> n1
  n0 --> n13
  n0 --> n2
  n0 --> n5
  n0 --> n6
  n0 --> n7
  n0 --> n8
  n0 --> x3
  n0 --> x8
  n1 --> n13
  n1 --> n18
  n1 --> n19
  n1 --> n20
  n1 --> n21
  n1 --> n8
  n1 --> x2
  n1 --> x3
  n1 --> x4
  n1 --> x6
  n10 --> n13
  n11 --> n12
  n12 --> n13
  n13 --> n19
  n13 --> x4
  n14 --> n15
  n14 --> n16
  n14 --> n17
  n14 --> n18
  n14 --> n19
  n14 --> n20
  n14 --> n21
  n14 --> x7
  n15 --> n17
  n15 --> n18
  n16 --> n19
  n16 --> n21
  n17 --> n19
  n17 --> n21
  n18 --> n19
  n19 --> n20
  n19 --> n21
  n2 --> n4
  n2 --> n6
  n2 --> n7
  n2 --> n8
  n2 --> x3
  n21 --> n23
  n22 --> n23
  n22 --> x5
  n23 --> n24
  n5 --> n7
  n5 --> x8
  n6 --> n8
  n6 --> x3
  n7 --> n8
  n7 --> x3
  n8 --> n18
  n8 --> n21
  n9 --> n10
  x0 --> n24
  x1 --> n24
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
| `VonKoch.E`<br/>def, line 31 | ℝ | x : ℝ | The error function. | — | `Stage3.F_differentiableAt_theta`, `Stage3.zeroFreeRight_one_of_chebyshev`, `VonKoch.E_integral_eq_mellin`, `VonKoch.E_le_linear`, `VonKoch.Etr`, `VonKoch.Etr_locallyIntegrable`, `VonKoch.F`, `VonKoch.F_differentiableAt`, `VonKoch.F_eq_neg_logDeriv` |
| `VonKoch.F`<br/>def, line 34 | ℂ | s : ℂ | The completed right-hand object: `s/(s−1) + s·∫₁^∞ E(x)·x^(−s−1) dx`. | `VonKoch.E` | `Stage3.F_analyticOnNhd_theta`, `Stage3.F_differentiableAt_theta`, `Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`, `Stage3.no_zero_right_of_theta`, `VonKoch.F_analyticOnNhd`, `VonKoch.F_differentiableAt`, `VonKoch.F_eq_neg_logDeriv`, `VonKoch.F_eq_neg_logDeriv_ext`, `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.no_zero_right_of_half` |
| `VonKoch.Etr`<br/>def, line 38 | ℝ → ℂ | — | The truncated error, as a function on `(0,∞)`: `E` on `(1,∞)`, zero below. | `VonKoch.E` | `Stage3.F_differentiableAt_theta`, `VonKoch.E_integral_eq_mellin`, `VonKoch.Etr_locallyIntegrable`, `VonKoch.Etr_measurable`, `VonKoch.F_differentiableAt` |
| `VonKoch.measurable_psi'`<br/>theorem, line 40 | Measurable (fun t : ℝ ↦ ψ t) | — | — | — | — |
| `VonKoch.Etr_measurable`<br/>theorem, line 47 | Measurable Etr | — | — | `VonKoch.Etr` | — |
| `VonKoch.E_le_linear`<br/>theorem, line 52 | ‖(E t : ℝ)‖ ≤ (Real.log 4 + 5) * t | ht : 0 ≤ t | Crude bound, no hypothesis: `\|E t\| ≤ (log 4 + 5)·t` for `t ≥ 0`. | `VonKoch.E` | `Stage3.zeroFreeRight_one_of_chebyshev`, `VonKoch.Etr_locallyIntegrable` |
| `VonKoch.E_integral_eq_mellin`<br/>theorem, line 60 | ∫ x in Set.Ioi (1:ℝ), (E x : ℂ) * (x : ℂ) ^ (-s - 1) = mellin Etr (-s) | s : ℂ | The E-integral IS the Mellin transform of `Etr` at `-s` — as raw integrals, no convergence needed. | `VonKoch.E`, `VonKoch.Etr` | `Stage3.F_differentiableAt_theta`, `VonKoch.F_differentiableAt` |
| `VonKoch.Etr_locallyIntegrable`<br/>theorem, line 80 | MeasureTheory.LocallyIntegrableOn Etr (Set.Ioi 0) | — | `Etr` is locally integrable on `(0,∞)`. | `VonKoch.E`, `VonKoch.E_le_linear`, `VonKoch.Etr` | `Stage3.F_differentiableAt_theta`, `VonKoch.F_differentiableAt` |
| `VonKoch.F_differentiableAt`<br/>theorem, line 118 | DifferentiableAt ℂ F s | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3; hs : 1/2 &lt; s.re; hs1 : s ≠ 1 | V1 — F is differentiable on `re s &gt; 1/2`, given the von Koch bound. The hypothesis is consumed here: `E = O(t^{1/2+δ})` at infinity makes the Mellin transform of `Etr` differentiable at `-s` whenever `re s &gt; 1/2 + δ`. | `VonKoch.E`, `VonKoch.E_integral_eq_mellin`, `VonKoch.Etr`, `VonKoch.Etr_locallyIntegrable`, `VonKoch.F` | `VonKoch.F_analyticOnNhd`, `VonKoch.no_zero_right_of_half` |
| `VonKoch.sum_Icc_vonMangoldt`<br/>theorem, line 196 | ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k = ψ n | n : ℕ | The partial sums of `Λ` over `Icc 1 n` are `ψ n`. | — | `VonKoch.psi_partial_bigO` |
| `VonKoch.psi_partial_bigO`<br/>theorem, line 203 | (fun n : ℕ ↦ ∑ k ∈ Finset.Icc 1 n, ArithmeticFunction.vonMangoldt k) =O[Filter.atTop] fun n : ℕ ↦ (n : ℝ) ^ (1:ℝ) | — | ψ is O(x) unconditionally, in big-O form on ℕ. | `VonKoch.sum_Icc_vonMangoldt` | `VonKoch.F_eq_neg_logDeriv` |
| `VonKoch.measurable_psi`<br/>theorem, line 217 | Measurable (fun t : ℝ ↦ ψ t) | — | The ψ-integrand is integrable on `Ioi 1` for `re s &gt; 1`. | — | `VonKoch.integrable_psi_cpow` |
| `VonKoch.integrable_psi_cpow`<br/>theorem, line 224 | IntegrableOn (fun t : ℝ ↦ ((ψ t : ℝ) : ℂ) * (t : ℂ) ^ (-(s + 1))) (Set.Ioi (1:ℝ)) | hs : 1 &lt; s.re | — | `VonKoch.measurable_psi` | `VonKoch.F_eq_neg_logDeriv` |
| `VonKoch.F_eq_neg_logDeriv`<br/>theorem, line 262 | F s = -deriv riemannZeta s / riemannZeta s | hs : 1 &lt; s.re | V2 — the identity on `re s &gt; 1`. The Mellin–Stieltjes representation is Mathlib's `LSeries_eq_mul_integral_of_nonneg` (partial sums `O(n^1)`, from unconditional Chebyshev); `LSeries_vonMangoldt_eq_deriv_riemannZeta_div` names the left side; `integral_Ioi_cpow_of_lt` evaluates the main term. | `VonKoch.E`, `VonKoch.F`, `VonKoch.integrable_psi_cpow`, `VonKoch.psi_partial_bigO` | `Stage3.F_mul_zeta_add_deriv_eqOn_zero_theta`, `VonKoch.F_mul_zeta_add_deriv_eqOn_zero` |
| `VonKoch.region`<br/>def, line 354 | Set ℂ | — | The working region: past the critical line, minus the pole. | — | `Stage3.regionθ_half`, `VonKoch.F_analyticOnNhd`, `VonKoch.F_eq_neg_logDeriv_ext`, `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.isOpen_region`, `VonKoch.no_zero_right_of_half`, `VonKoch.preconnected_region`, `VonKoch.zeta_analyticOnNhd` |
| `VonKoch.isOpen_region`<br/>theorem, line 356 | IsOpen region | — | — | `VonKoch.region` | `VonKoch.F_analyticOnNhd`, `VonKoch.zeta_analyticOnNhd` |
| `VonKoch.preconnected_region`<br/>theorem, line 363 | IsPreconnected region | — | — | `VonKoch.region` | `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.no_zero_right_of_half` |
| `VonKoch.zeta_analyticOnNhd`<br/>theorem, line 416 | AnalyticOnNhd ℂ riemannZeta region | — | — | `VonKoch.isOpen_region`, `VonKoch.region` | `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.no_zero_right_of_half` |
| `VonKoch.F_analyticOnNhd`<br/>theorem, line 420 | AnalyticOnNhd ℂ F region | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 | — | `VonKoch.F`, `VonKoch.F_differentiableAt`, `VonKoch.isOpen_region`, `VonKoch.region` | `VonKoch.F_mul_zeta_add_deriv_eqOn_zero` |
| `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`<br/>theorem, line 427 | Set.EqOn (fun s : ℂ ↦ F s * riemannZeta s + deriv riemannZeta s) 0 region | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 | The load-bearing identity: `F·ζ + ζ′` vanishes on the whole region. | `VonKoch.F`, `VonKoch.F_analyticOnNhd`, `VonKoch.F_eq_neg_logDeriv`, `VonKoch.preconnected_region`, `VonKoch.region`, `VonKoch.zeta_analyticOnNhd` | `VonKoch.F_eq_neg_logDeriv_ext`, `VonKoch.no_zero_right_of_half` |
| `VonKoch.F_eq_neg_logDeriv_ext`<br/>theorem, line 445 | F s = -deriv riemannZeta s / riemannZeta s | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3; hs : 1/2 &lt; s.re; hs1 : s ≠ 1; hz : riemannZeta s ≠ 0 | V3 — agreement extends to the punctured half-plane. From `F·ζ + ζ′ ≡ 0` on the region: divide by `ζ` where it does not vanish. | `VonKoch.F`, `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.region` | — |
| `VonKoch.no_zero_right_of_half`<br/>theorem, line 460 | riemannZeta ρ ≠ 0 | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3; hρ : 1/2 &lt; ρ.re; hρ1 : ρ ≠ 1 | V4 — no zeros right of the line. At a hypothetical zero `ρ`, factor `ζ = (z−ρ)^(k+1)·g` with `g ρ ≠ 0`. The identity `F·ζ + ζ′ = 0` factors as `(z−ρ)^k · [(k+1)·g + (z−ρ)·(F·g + g′)] = 0`; off `ρ` the power is nonzero, so the bracket vanishes on the punctured neighbourhood — yet it is continuous at `ρ` with value `(k+1)·g ρ ≠ 0`. (Order `⊤` would make `ζ` va… | `VonKoch.F`, `VonKoch.F_differentiableAt`, `VonKoch.F_mul_zeta_add_deriv_eqOn_zero`, `VonKoch.preconnected_region`, `VonKoch.region`, `VonKoch.zeta_analyticOnNhd` | `VonKoch.RH_of_psiWeak` |
| `VonKoch.RH_of_no_zero_right_of_half`<br/>theorem, line 550 | RiemannHypothesis | h : ∀ ρ : ℂ, 1/2 &lt; ρ.re → ρ ≠ 1 → riemannZeta ρ ≠ 0 | V5 — reflection. No zeros right of the line forces every nontrivial zero onto it: a zero at `re &lt; 1/2` inside the strip reflects through `riemannZeta_one_sub` to one at `re &gt; 1/2`. | — | `Stage3.RH_of_psiWeakTheta_half`, `VonKoch.RH_of_psiWeak` |
| `VonKoch.RH_of_psiWeak`<br/>theorem, line 632 | RiemannHypothesis | hbound : ∀ t : ℝ, x₀ ≤ t → \|ψ t - t\| ≤ C * Real.sqrt t * (Real.log t) ^ 3 | B1 — the converse, assembled from V1–V5. | `VonKoch.RH_of_no_zero_right_of_half`, `VonKoch.no_zero_right_of_half` | `VonKoch.RH_iff_psiWeak` |
| `VonKoch.RH_iff_psiWeak`<br/>theorem, line 641 | RiemannHypothesis ↔ ∃ C &gt; 0, ∃ x₀ : ℝ, Stage3.StmtPsiWeak C 3 x₀ | — | B2 — the equivalence. RH holds iff `ψ` satisfies the von Koch bound at one extra logarithm (von Koch's own exponent is `k = 2`; `k = 3` is the coarsened route's price). Forward is `RHPull.stmtPsiWeak_of_RH`; the converse is B1. | `RHPull.stmtPsiWeak_of_RH`, `Stage3.StmtPsiWeak`, `VonKoch.RH_of_psiWeak` | — |
