# `lean_stage3/Stage3/WeilPowerGeomGen.lean`

**What it does** (its own header): WeilPowerGeomGen — the geometric bound with a free slope, and `u` at general `λ`. Rung 5, fifteenth slice; worksheet § 13 block 13e. 2026-09-06.

**Imports:** [`WeilPowerGeom`](../lean_stage3/WeilPowerGeom.md), [`WeilPowerSigma`](../lean_stage3/WeilPowerSigma.md).
**Imported by:** [`Stage3`](../lean_stage3/Stage3.md), [`WeilPowerShell`](../lean_stage3/WeilPowerShell.md).

```mermaid
flowchart LR
  n0["MabGen<br/>(def)"]:::dfn
  n1["geomBoundGen<br/>(def)"]:::dfn
  n2["uLam<br/>(def)"]:::dfn
  n3["exp_shift_gen<br/>⊢ Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)) = Complex.exp (z * ((β₀…"]:::thm
  n4["sin_im_ge_gen<br/>⊢ 2 * (z.im * α) / Real.pi ≤ Real.sin (z.im * α)"]:::thm
  n5["rho_ne_one_gen<br/>⊢ Complex.exp (z * ((α : ℝ) : ℂ)) ≠ 1"]:::thm
  n6["norm_geom_le_gen<br/>⊢ ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖…"]:::thm
  n7["exp_lin_le_MabGen<br/>⊢ Real.exp (z.re * (α * (h : ℝ) + β₀)) ≤ MabGen z α β₀ a b"]:::thm
  n8["norm_corr_le_gen<br/>⊢ ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ…"]:::thm
  n9["norm_sum_exp_u_le_gen<br/>⊢ ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖ ≤ geomBoundGen z α…"]:::thm
  n10["uLam_eq<br/>⊢ uLam lam h = WeilPowerSigma.u (lam * h - 1) / (lam : ℝ) ^ 2"]:::thm
  n11["uLam_bracket<br/>⊢ 0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam …"]:::thm
  x0(["WeilPowerGeom · geom_Ico"]):::ext
  x1(["WeilPowerGeom · log_telescope"]):::ext
  x2(["WeilPowerGeom · norm_one_sub_exp_ge"]):::ext
  x3(["WeilPowerNear · phase_le"]):::ext
  x4(["WeilPowerNear · term_nonneg"]):::ext
  x5(["WeilPowerNear · uLam_le"]):::ext
  x6(["WeilPowerNear · uLam_nonneg"]):::ext
  x7(["WeilPowerPhase · sigma"]):::ext
  x8(["WeilPowerShell · MabGen_le"]):::ext
  x9(["WeilPowerShell · geomBound_le"]):::ext
  x10(["WeilPowerShell · shellSum"]):::ext
  x11(["WeilPowerShell · shellSum_le"]):::ext
  x12(["WeilPowerShell · shellSum_neg"]):::ext
  x13(["WeilPowerShell · sum_uSh_eq"]):::ext
  x14(["WeilPowerShell · uSh"]):::ext
  x15(["WeilPowerShell · uSh_bracket"]):::ext
  x16(["WeilPowerSigma · r_le"]):::ext
  x17(["WeilPowerSigma · r_pos"]):::ext
  x18(["WeilPowerSigma · u"]):::ext
  x19(["WeilPowerSigma · u_def"]):::ext
  n0 --> n7
  n0 --> n9
  n0 --> x11
  n0 --> x8
  n1 --> n6
  n1 --> n9
  n1 --> x11
  n1 --> x9
  n10 --> n11
  n11 --> x15
  n11 --> x5
  n2 --> n10
  n2 --> n11
  n2 --> x10
  n2 --> x11
  n2 --> x12
  n2 --> x13
  n2 --> x14
  n2 --> x3
  n2 --> x4
  n2 --> x5
  n2 --> x6
  n3 --> n6
  n4 --> n5
  n4 --> n6
  n5 --> n6
  n6 --> n9
  n7 --> n9
  n8 --> n9
  n9 --> x11
  x0 --> n6
  x1 --> n9
  x16 --> n11
  x17 --> n11
  x18 --> n10
  x18 --> n11
  x19 --> n10
  x2 --> n5
  x2 --> n6
  x7 --> n2
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
| `WeilPowerGeomGen.MabGen`<br/>def, line 81 | ℝ | z : ℂ; α β₀ : ℝ; a b : ℕ | The larger endpoint value of the geometric factor at a free slope. | — | `WeilPowerGeomGen.exp_lin_le_MabGen`, `WeilPowerGeomGen.norm_sum_exp_u_le_gen`, `WeilPowerShell.MabGen_le`, `WeilPowerShell.shellSum_le` |
| `WeilPowerGeomGen.geomBoundGen`<br/>def, line 88 | ℝ | z : ℂ; α β₀ : ℝ; a b : ℕ | The geometric sum's bound at a free slope: the two endpoint values over the separation of `ρ = exp(zα)` from `1`, which Jordan's inequality makes `2 z.im α/π` times `exp(z.re α)`. It does not grow with `b − a`, and it grows like `1/α` as the slope falls. | — | `WeilPowerGeomGen.norm_geom_le_gen`, `WeilPowerGeomGen.norm_sum_exp_u_le_gen`, `WeilPowerShell.geomBound_le`, `WeilPowerShell.shellSum_le` |
| `WeilPowerGeomGen.uLam`<br/>def, line 94 | ℝ | lam h : ℕ | The normalized tail sum at general `λ`: `uLam λ h = h²·σ(λh − 1)`, which is `u(λh − 1)/λ²` whenever `1 ≤ λh`. | `WeilPowerPhase.sigma` | `WeilPowerGeomGen.uLam_bracket`, `WeilPowerGeomGen.uLam_eq`, `WeilPowerNear.phase_le`, `WeilPowerNear.term_nonneg`, `WeilPowerNear.uLam_le`, `WeilPowerNear.uLam_nonneg`, `WeilPowerShell.shellSum`, `WeilPowerShell.shellSum_le`, `WeilPowerShell.shellSum_neg`, `WeilPowerShell.sum_uSh_eq`, `WeilPowerShell.uSh` |
| `WeilPowerGeomGen.exp_shift_gen`<br/>theorem, line 97 | Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ)) = Complex.exp (z * ((β₀ : ℝ) : ℂ)) * Complex.exp (z * ((α : ℝ) : ℂ)) ^ h | z : ℂ; α β₀ : ℝ; h : ℕ | The geometric factorization of the affine exponential. | — | `WeilPowerGeomGen.norm_geom_le_gen` |
| `WeilPowerGeomGen.sin_im_ge_gen`<br/>theorem, line 106 | 2 * (z.im * α) / Real.pi ≤ Real.sin (z.im * α) | hα : 0 &lt; α; hz1 : 0 &lt; z.im; hz3 : z.im * α ≤ Real.pi / 2 | Jordan's inequality at the phase `z.im·α`, linear in `z.im·α`. | — | `WeilPowerGeomGen.norm_geom_le_gen`, `WeilPowerGeomGen.rho_ne_one_gen` |
| `WeilPowerGeomGen.rho_ne_one_gen`<br/>theorem, line 118 | Complex.exp (z * ((α : ℝ) : ℂ)) ≠ 1 | hα : 0 &lt; α; hz1 : 0 &lt; z.im; hz3 : z.im * α ≤ Real.pi / 2 | The ratio `ρ = exp(zα)` is not `1`: its distance to `1` is at least `exp(z.re α)·2 z.im α/π &gt; 0`. | `WeilPowerGeom.norm_one_sub_exp_ge`, `WeilPowerGeomGen.sin_im_ge_gen` | `WeilPowerGeomGen.norm_geom_le_gen` |
| `WeilPowerGeomGen.norm_geom_le_gen`<br/>theorem, line 139 | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ geomBoundGen z α β₀ a b | hα : 0 &lt; α; hz1 : 0 &lt; z.im; hz3 : z.im * α ≤ Real.pi / 2; hab : a ≤ b | The geometric sum at a free slope is bounded independently of the range length. | `WeilPowerGeom.geom_Ico`, `WeilPowerGeom.norm_one_sub_exp_ge`, `WeilPowerGeomGen.exp_shift_gen`, `WeilPowerGeomGen.geomBoundGen`, `WeilPowerGeomGen.rho_ne_one_gen`, `WeilPowerGeomGen.sin_im_ge_gen` | `WeilPowerGeomGen.norm_sum_exp_u_le_gen` |
| `WeilPowerGeomGen.exp_lin_le_MabGen`<br/>theorem, line 216 | Real.exp (z.re * (α * (h : ℝ) + β₀)) ≤ MabGen z α β₀ a b | hα : 0 &lt; α; hah : a ≤ h; hhb : h ≤ b | The geometric factor at an interior `h` is at most its value at an endpoint: the exponent is affine and increasing in `h`, so the sign of `z.re` picks the end. | `WeilPowerGeomGen.MabGen` | `WeilPowerGeomGen.norm_sum_exp_u_le_gen` |
| `WeilPowerGeomGen.norm_corr_le_gen`<br/>theorem, line 230 | ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖ ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) | hzc : ‖z‖ * c ≤ (a : ℝ) + 1; hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀) ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1); hah : a ≤ h | One term's correction at a free scale, `2‖z‖·c/(h+1)` times the geometric factor. | — | `WeilPowerGeomGen.norm_sum_exp_u_le_gen` |
| `WeilPowerGeomGen.norm_sum_exp_u_le_gen`<br/>theorem, line 278 | ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖ ≤ geomBoundGen z α β₀ a b + 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) | hα : 0 &lt; α; hz1 : 0 &lt; z.im; hz3 : z.im * α ≤ Real.pi / 2; ha : 1 ≤ a; hab : a ≤ b; hzc : ‖z‖ * c ≤ (a : ℝ) + 1; hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀) ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1) | The averaged sum at a free slope: bounded by the range-free geometric bound plus a logarithm of the range. | `WeilPowerGeom.log_telescope`, `WeilPowerGeomGen.MabGen`, `WeilPowerGeomGen.exp_lin_le_MabGen`, `WeilPowerGeomGen.geomBoundGen`, `WeilPowerGeomGen.norm_corr_le_gen`, `WeilPowerGeomGen.norm_geom_le_gen` | `WeilPowerShell.shellSum_le` |
| `WeilPowerGeomGen.uLam_eq`<br/>theorem, line 334 | uLam lam h = WeilPowerSigma.u (lam * h - 1) / (lam : ℝ) ^ 2 | hl : 1 ≤ lam; hh : 1 ≤ h | `uLam` is `u` rescaled: `uLam λ h = u(λh − 1)/λ²`, the cast `((λh − 1 : ℕ) : ℝ) + 1 = λh` being the whole content. | `WeilPowerGeomGen.uLam`, `WeilPowerSigma.u`, `WeilPowerSigma.u_def` | `WeilPowerGeomGen.uLam_bracket` |
| `WeilPowerGeomGen.uLam_bracket`<br/>theorem, line 348 | 0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2) - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2)) ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1) | hl : 1 ≤ lam; hh : 1 ≤ h | The bracket for `uLam` at general `λ`: slope `1/(λπ²)`, intercept `−1/(2λ²π²)`, correction scale `1/(2λ³π²)`. | `WeilPowerGeomGen.uLam`, `WeilPowerGeomGen.uLam_eq`, `WeilPowerSigma.r_le`, `WeilPowerSigma.r_pos`, `WeilPowerSigma.u` | `WeilPowerNear.uLam_le`, `WeilPowerShell.uSh_bracket` |
