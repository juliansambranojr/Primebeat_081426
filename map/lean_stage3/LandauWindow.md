# `lean_stage3/Stage3/LandauWindow.lean`

**What it does** (its own header): LandauWindow — the Landau window criterion as a statement, and what it gives: a one-sided bound on one function of the primes, on long windows, implies Mathlib's `RiemannHypothesis`. Block 1 of `lean_stage3/design/landau.md`. 2026-11-22.

**Imports:** nothing in this tree.
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`LandauCrude`](../lean_stage3/LandauCrude.md), [`LandauMellin`](../lean_stage3/LandauMellin.md).

```mermaid
flowchart LR
  n0["rampSum<br/>(def)"]:::dfn
  n1["G<br/>(def)"]:::dfn
  n2["WindowBound<br/>(def)"]:::dfn
  n3["StmtLandauWindow<br/>(def)"]:::dfn
  n4["zeta_neg_nat_ne_zero<br/>⊢ riemannZeta (-(n : ℂ)) ≠ 0"]:::thm
  n5["rh_of_zeroFree_half<br/>⊢ RiemannHypothesis"]:::thm
  n6["zeroFree_half_of_window<br/>⊢ ∀ s : ℂ, 1 / 2 ＜ s.re → riemannZeta s ≠ 0"]:::thm
  n7["rh_of_window<br/>⊢ RiemannHypothesis"]:::thm
  x0(["JointDialGate · relErrWindow_of_window"]):::ext
  x1(["JointSymbol · cutG"]):::ext
  x2(["JointSymbol · mellin_dd_iter"]):::ext
  x3(["JointWindowDial · psiWeakTheta_of_window"]):::ext
  x4(["JointWindowDial · schoenfeldWeakTheta_of_window"]):::ext
  x5(["JointWindowDial · zeroFreeRight_of_window"]):::ext
  x6(["LandauChebyshev · G_le"]):::ext
  x7(["LandauChebyshev · abs_G_le_log"]):::ext
  x8(["LandauChebyshev · neg_le_G"]):::ext
  x9(["LandauChebyshev · rampSum_le_log"]):::ext
  x10(["LandauCriterion · contradiction"]):::ext
  x11(["LandauCriterion · rh_of_windows"]):::ext
  x12(["LandauCriterion · stmtLandauWindow"]):::ext
  x13(["LandauCrude · abs_G_le"]):::ext
  x14(["LandauCrude · rampSum_le"]):::ext
  x15(["LandauCrude · rampSum_nonneg"]):::ext
  x16(["LandauMellin · mellin_rampSum"]):::ext
  x17(["LandauMellin · rampSum_eq_tsum"]):::ext
  x18(["LandauMellinG · G_integrand_eq"]):::ext
  x19(["LandauMellinG · G_mellin_integrable"]):::ext
  x20(["LandauMellinG · mellin_G"]):::ext
  x21(["LandauMellinG · rampSum_mellin_integrable"]):::ext
  x22(["LandauPrimeSide · Ik"]):::ext
  x23(["LandauPrimeSide · Ik_integrable"]):::ext
  x24(["LandauPrimeSide · Ik_le"]):::ext
  x25(["LandauTaylor · integrand_norm_le"]):::ext
  x26(["LandauTaylor · mellinLog"]):::ext
  x27(["LandauTaylor · mellinLog_hasDerivAt"]):::ext
  x28(["LandauTaylor · mellinLog_integrable"]):::ext
  x29(["LandauTaylor · mellinLog_real"]):::ext
  n0 --> n1
  n0 --> x14
  n0 --> x15
  n0 --> x16
  n0 --> x17
  n0 --> x18
  n0 --> x20
  n0 --> x21
  n0 --> x9
  n1 --> n2
  n1 --> x1
  n1 --> x10
  n1 --> x13
  n1 --> x18
  n1 --> x19
  n1 --> x2
  n1 --> x20
  n1 --> x22
  n1 --> x23
  n1 --> x24
  n1 --> x25
  n1 --> x26
  n1 --> x27
  n1 --> x28
  n1 --> x29
  n1 --> x6
  n1 --> x7
  n1 --> x8
  n2 --> n3
  n2 --> n6
  n2 --> n7
  n2 --> x0
  n2 --> x11
  n2 --> x3
  n2 --> x4
  n2 --> x5
  n3 --> n6
  n3 --> n7
  n3 --> x12
  n4 --> n5
  n5 --> n7
  n6 --> n7
  n7 --> x11
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
| `LandauWindow.rampSum`<br/>def, line 49 | ℝ | y : ℝ | `Σ_{n ≤ y} Λ(n)·(y/n − 1)`, the von Mangoldt sum against the ramp. | — | `LandauChebyshev.rampSum_le_log`, `LandauCrude.rampSum_le`, `LandauCrude.rampSum_nonneg`, `LandauMellin.mellin_rampSum`, `LandauMellin.rampSum_eq_tsum`, `LandauMellinG.G_integrand_eq`, `LandauMellinG.mellin_G`, `LandauMellinG.rampSum_mellin_integrable`, `LandauWindow.G` |
| `LandauWindow.G`<br/>def, line 53 | ℝ | y : ℝ | The ramp sum with its main terms removed. | `LandauWindow.rampSum` | `JointSymbol.cutG`, `JointSymbol.mellin_dd_iter`, `LandauChebyshev.G_le`, `LandauChebyshev.abs_G_le_log`, `LandauChebyshev.neg_le_G`, `LandauCriterion.contradiction`, `LandauCrude.abs_G_le`, `LandauMellinG.G_integrand_eq`, `LandauMellinG.G_mellin_integrable`, `LandauMellinG.mellin_G`, `LandauPrimeSide.Ik`, `LandauPrimeSide.Ik_integrable`, `LandauPrimeSide.Ik_le`, `LandauTaylor.integrand_norm_le`, `LandauTaylor.mellinLog`, `LandauTaylor.mellinLog_hasDerivAt`, `LandauTaylor.mellinLog_integrable`, `LandauTaylor.mellinLog_real`, `LandauWindow.WindowBound` |
| `LandauWindow.WindowBound`<br/>def, line 57 | Prop | θ δ C : ℝ | The hypothesis: `G(y) ≤ C·y^θ` on a window `[Y, Y^(1+δ)]`, for arbitrarily large `Y`. | `LandauWindow.G` | `JointDialGate.relErrWindow_of_window`, `JointWindowDial.psiWeakTheta_of_window`, `JointWindowDial.schoenfeldWeakTheta_of_window`, `JointWindowDial.zeroFreeRight_of_window`, `LandauCriterion.rh_of_windows`, `LandauWindow.StmtLandauWindow`, `LandauWindow.rh_of_window`, `LandauWindow.zeroFree_half_of_window` |
| `LandauWindow.StmtLandauWindow`<br/>def, line 61 | Prop | — | The Landau window criterion, as a statement. | `LandauWindow.WindowBound` | `LandauCriterion.stmtLandauWindow`, `LandauWindow.rh_of_window`, `LandauWindow.zeroFree_half_of_window` |
| `LandauWindow.zeta_neg_nat_ne_zero`<br/>theorem, line 66 | riemannZeta (-(n : ℂ)) ≠ 0 | n : ℕ; hn : ¬∃ k : ℕ, n = 2 * (k + 1) | `ζ` does not vanish at a nonpositive integer other than a trivial zero. | — | `LandauWindow.rh_of_zeroFree_half` |
| `LandauWindow.rh_of_zeroFree_half`<br/>theorem, line 114 | RiemannHypothesis | h : ∀ s : ℂ, 1 / 2 &lt; s.re → riemannZeta s ≠ 0 | From a zero-free half-plane to the Riemann hypothesis. | `LandauWindow.zeta_neg_nat_ne_zero` | `LandauWindow.rh_of_window` |
| `LandauWindow.zeroFree_half_of_window`<br/>theorem, line 137 | ∀ s : ℂ, 1 / 2 &lt; s.re → riemannZeta s ≠ 0 | hL : StmtLandauWindow; hW : ∀ θ : ℝ, 1 / 2 &lt; θ → θ &lt; 1 → ∃ δ C : ℝ, 0 &lt; δ ∧ WindowBound θ δ C | The criterion and a window bound at every `θ` above `1/2` give a zero-free half-plane. | `LandauWindow.StmtLandauWindow`, `LandauWindow.WindowBound` | `LandauWindow.rh_of_window` |
| `LandauWindow.rh_of_window`<br/>theorem, line 152 | RiemannHypothesis | hL : StmtLandauWindow; hW : ∀ θ : ℝ, 1 / 2 &lt; θ → θ &lt; 1 → ∃ δ C : ℝ, 0 &lt; δ ∧ WindowBound θ δ C | The window bound gives the Riemann hypothesis, given the criterion. | `LandauWindow.StmtLandauWindow`, `LandauWindow.WindowBound`, `LandauWindow.rh_of_zeroFree_half`, `LandauWindow.zeroFree_half_of_window` | `LandauCriterion.rh_of_windows` |
