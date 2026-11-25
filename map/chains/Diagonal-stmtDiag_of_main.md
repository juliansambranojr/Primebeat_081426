# What `Diagonal.stmtDiag_of_main` rests on

[`Diagonal.stmtDiag_of_main`](../lean_stage3/Diagonal.md#Diagonal-stmtDiag_of_main) in `lean_stage3/Stage3/Diagonal.lean`, line 1779.

**Why.** `StmtDiag` from (c): `diag_young` and `StmtDiagMain` give Young's Lemma 6 for the diagonal, `diagSum = c₁(α,β) ŵ(0) + O(T/L)`, for every `θ < 1/2`, `κ > 0`.

**Proves**

```lean
StmtDiag P θ R κ
```

**Needs** (its hypotheses)

  - `` P : Polynomial ℝ ``
  - `` hθ : θ < 1 / 2 ``
  - `` R : ℝ ``
  - `` hκ : 0 < κ ``
  - `` hmain : StmtDiagMain P θ R κ ``

Behind it: 151 theorems and 41 definitions in 9 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ApproxFE</b><br/>17 used"]:::thm
  f1["<b>ContourShift</b><br/>8 used"]:::thm
  f2["<b>ApproxShift</b><br/>3 used"]:::thm
  f3["<b>ApproxBounds</b><br/>20 used"]:::thm
  f4["<b>ApproxDeriv</b><br/>29 used"]:::thm
  f5["<b>TwistedMoment</b><br/>16 used"]:::thm
  f6["<b>OffDiagClose</b><br/>1 used"]:::thm
  f7["<b>ZetaGrowth</b><br/>21 used"]:::thm
  f8["<b>Diagonal</b><br/>stmtDiag_of_main"]:::end_
  f0 --> f2
  f1 --> f2
  f2 --> f3
  f3 --> f4
  f4 --> f5
  f5 --> f6
  f1 --> f7
  f6 --> f8
  f7 --> f8
  classDef cnt fill:#dff5ec,stroke:#17694a,color:#111
  classDef shp fill:#f1ecfb,stroke:#5b3fa0,color:#111
  classDef rh fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef thm fill:#eef4ff,stroke:#335,color:#111
  classDef end_ fill:#e7f7e7,stroke:#2a7,color:#111,stroke-width:2px
  classDef lone fill:#fff,stroke:#999,color:#111,stroke-dasharray:4 3
  classDef bad fill:#ffe5e5,stroke:#c22,color:#111,stroke-width:2px
  classDef ext fill:#fff8e1,stroke:#b80,color:#111
```

An arrow A → B reads "B uses something proved or defined in A"; indirect arrows are left out. Green: the theorem itself. Yellow: a file in the other tree. The number is how many of that file's declarations are on the way.

## Every declaration on the way

Files in dependency order. ★ marks what the theorem's own proof uses directly.

### [`ApproxFE`](../lean_stage3/ApproxFE.md) — 17

- [`ApproxFE.uA`](../lean_stage3/ApproxFE.md#ApproxFE-uA) — *def*
- [`ApproxFE.vB`](../lean_stage3/ApproxFE.md#ApproxFE-vB) — *def*
- [`ApproxFE.GY`](../lean_stage3/ApproxFE.md#ApproxFE-GY) — *def*
- [`ApproxFE.gY`](../lean_stage3/ApproxFE.md#ApproxFE-gY) — *def*
- [`ApproxFE.KY`](../lean_stage3/ApproxFE.md#ApproxFE-KY) — *def*
- [`ApproxFE.VY`](../lean_stage3/ApproxFE.md#ApproxFE-VY) — *def*
- [`ApproxFE.uA_re`](../lean_stage3/ApproxFE.md#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
- [`ApproxFE.vB_re`](../lean_stage3/ApproxFE.md#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``
- [`ApproxFE.uA_im`](../lean_stage3/ApproxFE.md#ApproxFE-uA_im) — `` (uA α t).im = α.im + t ``
- [`ApproxFE.vB_im`](../lean_stage3/ApproxFE.md#ApproxFE-vB_im) — `` (vB β t).im = β.im - t ``
- [`ApproxFE.norm_succ_cpow`](../lean_stage3/ApproxFE.md#ApproxFE-norm_succ_cpow) — `` ‖((m : ℂ) + 1) ^ z‖ = ((m : ℝ) + 1) ^ z.re ``
- [`ApproxFE.summable_succ_rpow`](../lean_stage3/ApproxFE.md#ApproxFE-summable_succ_rpow) — `` Summable fun m : ℕ => ((m : ℝ) + 1) ^ r ``
- [`ApproxFE.summable_zeta_norm`](../lean_stage3/ApproxFE.md#ApproxFE-summable_zeta_norm) — `` Summable fun n : ℕ => ‖1 / ((n : ℂ) + 1) ^ w‖ ``
- [`ApproxFE.KY_bound`](../lean_stage3/ApproxFE.md#ApproxFE-KY_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ y : ℝ, ‖KY α β t (c + y * I)‖ ≤ C * Real.exp (-(1 / 2) * y ^ 2) ``
- [`ApproxFE.KY_differentiableAt`](../lean_stage3/ApproxFE.md#ApproxFE-KY_differentiableAt) — `` DifferentiableAt ℂ (KY α β t) s ``
- [`ApproxFE.KY_continuous_line`](../lean_stage3/ApproxFE.md#ApproxFE-KY_continuous_line) — `` Continuous fun y : ℝ => KY α β t (c + y * I) ``
- [`ApproxFE.gY_zero`](../lean_stage3/ApproxFE.md#ApproxFE-gY_zero) — `` gY α β t 0 = 1 ``

### [`ContourShift`](../lean_stage3/ContourShift.md) — 8

- [`ContourShift.zeta_analyticAt`](../lean_stage3/ContourShift.md#ContourShift-zeta_analyticAt) — `` AnalyticAt ℂ riemannZeta ρ ``
- [`ContourShift.borderIntegrable_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-borderIntegrable_sum_poles) — `` RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w ``
- [`ContourShift.rectangleIntegral_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-rectangleIntegral_sum_poles) — `` RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_multi`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_multi) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_of_local`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_of_local) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.analyticAt_dslope`](../lean_stage3/ContourShift.md#ContourShift-analyticAt_dslope) — `` AnalyticAt ℂ (dslope f p) p ``
- [`ContourShift.div_sub_eq_dslope`](../lean_stage3/ContourShift.md#ContourShift-div_sub_eq_dslope) — `` f s / (s - p) = f p / (s - p) + dslope f p s ``
- [`ContourShift.sq_mul_zeta_analyticAt_one`](../lean_stage3/ContourShift.md#ContourShift-sq_mul_zeta_analyticAt_one) — `` AnalyticAt ℂ (fun s ↦ (s - 1)^2 * riemannZeta s) 1 ``

### [`ApproxShift`](../lean_stage3/ApproxShift.md) — 3

- [`ApproxShift.GY_norm_le`](../lean_stage3/ApproxShift.md#ApproxShift-GY_norm_le) — `` ‖GY α β s‖ ≤ Real.exp (c ^ 2 - s.im ^ 2) * ((‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 * (1 + s.im ^ 2)) ``
- [`ApproxShift.GY_analyticAt`](../lean_stage3/ApproxShift.md#ApproxShift-GY_analyticAt) — `` AnalyticAt ℂ (GY α β) p ``
- [`ApproxShift.local_simple`](../lean_stage3/ApproxShift.md#ApproxShift-local_simple) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in 𝓝[≠] p, f s = h s + A / (s - p) ``

### [`ApproxBounds`](../lean_stage3/ApproxBounds.md) — 20

- [`ApproxBounds.lY`](../lean_stage3/ApproxBounds.md#ApproxBounds-lY) — *def*
- [`ApproxBounds.lY_neg`](../lean_stage3/ApproxBounds.md#ApproxBounds-lY_neg) — `` lY (-Y) = lY Y ``
- [`ApproxBounds.gModel`](../lean_stage3/ApproxBounds.md#ApproxBounds-gModel) — *def*
- [`ApproxBounds.gErr`](../lean_stage3/ApproxBounds.md#ApproxBounds-gErr) — *def*
- [`ApproxBounds.gRModel`](../lean_stage3/ApproxBounds.md#ApproxBounds-gRModel) — *def*
- [`ApproxBounds.gErr_nonneg`](../lean_stage3/ApproxBounds.md#ApproxBounds-gErr_nonneg) — `` 0 ≤ gErr r ``
- [`ApproxBounds.const_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-const_bound) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ r : ℝ, lo ≤ r → r ≤ hi → |Real.log (Real.Gamma r)| ≤ K ∧ gErr r ≤ K ``
- [`ApproxBounds.lY_near`](../lean_stage3/ApproxBounds.md#ApproxBounds-lY_near) — `` |lY Y - Real.log (t / 2)| ≤ 3 ``
- [`ApproxBounds.log_div_two_pi`](../lean_stage3/ApproxBounds.md#ApproxBounds-log_div_two_pi) — `` Real.log (t / (2 * Real.pi)) = Real.log (t / 2) - Real.log Real.pi ``
- [`ApproxBounds.lY_lip`](../lean_stage3/ApproxBounds.md#ApproxBounds-lY_lip) — `` |lY (Y + h) - lY Y| ≤ |h| ``
- [`ApproxBounds.gR_shift`](../lean_stage3/ApproxBounds.md#ApproxBounds-gR_shift) — `` Real.log ‖Gammaℝ (w + (σ + y * I))‖ - Real.log ‖Gammaℝ w‖ ≤ σ / 2 * (Real.log (t / 2) - Real.log Real.pi) + 2 * K + 2 * K' + 3 * |σ| / 2 + (Real.pi / 4 + |σ| / … ``
- [`ApproxBounds.gY_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-gY_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi)) ^ σ * R… ``
- [`ApproxBounds.gauss_absorb`](../lean_stage3/ApproxBounds.md#ApproxBounds-gauss_absorb) — `` Real.exp (-y ^ 2) * (1 + y ^ 2) * Real.exp (B * |y|) ≤ 4 * Real.exp (B ^ 2) * Real.exp (-(1 / 2) * y ^ 2) ``
- [`ApproxBounds.Q_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-Q_le) — `` (n ^ 2 + A) / n ^ 2 ≤ (A + 1) * (1 + 1 / n ^ 2) ``
- [`ApproxBounds.integrand_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → δ ≤ ‖(σ : ℂ) + y * I‖ → ‖KY α β t (σ + … ``
- [`ApproxBounds.norm_VY_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-norm_VY_le) — `` ‖VY α β σ x t‖ ≤ 1 / (2 * Real.pi) * ∫ y : ℝ, ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ``
- [`ApproxBounds.VY_line_bound`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ‖VY α β σ x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ … ``
- [`ApproxBounds.rpow_le_ends`](../lean_stage3/ApproxBounds.md#ApproxBounds-rpow_le_ends) — `` b ^ σ ≤ b ^ σ₀ + b ^ σ₁ ``
- [`ApproxBounds.rect_tendsto_ab`](../lean_stage3/ApproxBounds.md#ApproxBounds-rect_tendsto_ab) — `` Tendsto (fun T : ℝ => RectangleIntegral f (↑a - I * T) (↑b + I * T)) atTop (𝓝 (VerticalIntegral f b - VerticalIntegral f a)) ``
- [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``

### [`ApproxDeriv`](../lean_stage3/ApproxDeriv.md) — 29

- [`ApproxDeriv.psiR`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-psiR) — *def*
- [`ApproxDeriv.ne_neg_nat_of_re_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-ne_neg_nat_of_re_pos) — `` z ≠ -(m : ℂ) ``
- [`ApproxDeriv.hasDerivAt_line`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasDerivAt_line) — `` HasDerivAt (fun t : ℝ => w₀ + (t : ℂ) * e) e t ``
- [`ApproxDeriv.dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY) — *def*
- [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds) — `` 1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧ 1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re ``
- [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt) — `` HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t ``
- [`ApproxDeriv.tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tau) — *def*
- [`ApproxDeriv.hasSum_tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tau) — `` HasSum (tau h w) (digamma (w + h) - digamma w) ``
- [`ApproxDeriv.norm_nat_add_ge`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_nat_add_ge) — `` ((n : ℝ) + a + Y) / 2 ≤ ‖(n : ℂ) + z‖ ``
- [`ApproxDeriv.norm_tau_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_tau_le) — `` ‖tau h w n‖ ≤ 4 * ‖h‖ * (1 / ((n : ℝ) + (a + Y)) ^ 2) ``
- [`ApproxDeriv.tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tel) — *def*
- [`ApproxDeriv.hasSum_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tel) — `` HasSum (tel b) (1 / b) ``
- [`ApproxDeriv.sq_le_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-sq_le_tel) — `` 1 / ((n : ℝ) + b) ^ 2 ≤ (1 + 1 / b) * tel b n ``
- [`ApproxDeriv.dY_hasSum`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasSum) — `` HasSum (fun n => I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)) (dY α β t s) ``
- [`ApproxDeriv.norm_I_half`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_I_half) — `` ‖I / 2‖ = 1 / 2 ``
- [`ApproxDeriv.norm_dterm_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dterm_le) — `` ‖I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)‖ ≤ 4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n ``
- [`ApproxDeriv.norm_dY_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_dY_le) — `` ‖dY α β t s‖ ≤ 4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) ``
- [`ApproxDeriv.poly_gauss`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-poly_gauss) — `` (1 + |y|) ^ k * Real.exp (-(1 / 2) * y ^ 2) ≤ (k.factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) ``
- [`ApproxDeriv.gauss_loc`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gauss_loc) — `` Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ k ≤ ((k + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) ``
- [`ApproxDeriv.norm_half_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_half_le) — `` ‖((σ : ℂ) + y * I) / 2‖ ≤ (1 + |σ|) * (1 + |y|) ``
- [`ApproxDeriv.dY_crude`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_crude) — `` ‖dY α β t (σ + y * I)‖ ≤ 1680 * (1 + |σ|) * (1 + |y|) ``
- [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ, ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
- [`ApproxDeriv.cont_F`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-cont_F) — `` Continuous fun y : ℝ => KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I)) ``
- [`ApproxDeriv.re_half_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_half_pos) — `` 0 < ((uA α t + ((σ : ℂ) + y * I)) / 2).re ∧ 0 < ((vB β t + ((σ : ℂ) + y * I)) / 2).re ``
- [`ApproxDeriv.cont_dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-cont_dY) — `` Continuous fun y : ℝ => dY α β t (σ + y * I) ``
- [`ApproxDeriv.VY1`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY1) — *def*
- [`ApproxDeriv.norm_F_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_F_local) — `` ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
- [`ApproxDeriv.F_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-F_hasDerivAt) — `` HasDerivAt (fun t => KY α β t s * (x : ℂ) ^ (-s)) (KY α β t s * (x : ℂ) ^ (-s) * dY α β t s) t ``
- [`ApproxDeriv.VY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VY_hasDerivAt) — `` HasDerivAt (fun t => VY α β σ x t) (VY1 α β σ x t₀) t₀ ``

### [`TwistedMoment`](../lean_stage3/TwistedMoment.md) — 16

- [`TwistedMoment.Weight`](../lean_stage3/TwistedMoment.md#TwistedMoment-Weight) — *structure*
- ★ [`TwistedMoment.what0`](../lean_stage3/TwistedMoment.md#TwistedMoment-what0) — *def*
- [`TwistedMoment.continuous_VY`](../lean_stage3/TwistedMoment.md#TwistedMoment-continuous_VY) — `` Continuous fun t => VY α β c x t ``
- [`TwistedMoment.integrable_of_Icc`](../lean_stage3/TwistedMoment.md#TwistedMoment-integrable_of_Icc) — `` Integrable f ``
- ★ [`TwistedMoment.norm_integral_le_Icc`](../lean_stage3/TwistedMoment.md#TwistedMoment-norm_integral_le_Icc) — `` ‖∫ t, f t‖ ≤ K * (b - a) ``
- [`TwistedMoment.coefY`](../lean_stage3/TwistedMoment.md#TwistedMoment-coefY) — *def*
- [`TwistedMoment.Jint`](../lean_stage3/TwistedMoment.md#TwistedMoment-Jint) — *def*
- ★ [`TwistedMoment.diagSum`](../lean_stage3/TwistedMoment.md#TwistedMoment-diagSum) — *def*
- [`TwistedMoment.Jint_diag`](../lean_stage3/TwistedMoment.md#TwistedMoment-Jint_diag) — `` Jint W α β c h k m n = ∫ t, (W.w t : ℂ) * VY α β c ((m : ℝ) * n) t ``
- ★ [`TwistedMoment.Mof`](../lean_stage3/TwistedMoment.md#TwistedMoment-Mof) — *def*
- ★ [`TwistedMoment.sig0`](../lean_stage3/TwistedMoment.md#TwistedMoment-sig0) — *def*
- ★ [`TwistedMoment.aY`](../lean_stage3/TwistedMoment.md#TwistedMoment-aY) — *def*
- ★ [`TwistedMoment.c1Y`](../lean_stage3/TwistedMoment.md#TwistedMoment-c1Y) — *def*
- [`TwistedMoment.Regime`](../lean_stage3/TwistedMoment.md#TwistedMoment-Regime) — *def*
- ★ [`TwistedMoment.errY`](../lean_stage3/TwistedMoment.md#TwistedMoment-errY) — *def*
- ★ [`TwistedMoment.StmtDiag`](../lean_stage3/TwistedMoment.md#TwistedMoment-StmtDiag) — *def*

### [`OffDiagClose`](../lean_stage3/OffDiagClose.md) — 1

- [`OffDiagClose.N_le`](../lean_stage3/OffDiagClose.md#OffDiagClose-N_le) — `` 1 + 1 / ‖α + β‖ ^ 2 ≤ 1 + κ ^ 2 * Real.log T ^ 2 ``

### [`ZetaGrowth`](../lean_stage3/ZetaGrowth.md) — 21

- [`ZetaGrowth.emA`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA) — *def*
- [`ZetaGrowth.emA_nonneg`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_nonneg) — `` 0 ≤ emA x ``
- [`ZetaGrowth.emA_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_le) — `` emA x ≤ 1/8 ``
- [`ZetaGrowth.emA_natCast`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_natCast) — `` emA n = 0 ``
- [`ZetaGrowth.emA_eq_poly`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-emA_eq_poly) — `` emA x = ((x - n) - (x - n)^2)/2 ``
- [`ZetaGrowth.integrable_emA_tail`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-integrable_emA_tail) — `` IntegrableOn (fun x : ℝ ↦ (emA x : ℂ) * (x : ℂ) ^ (-(s+2))) (Ioi (N:ℝ)) ``
- [`ZetaGrowth.interval_ibp`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-interval_ibp) — `` ∫ x in (n:ℝ)..((n:ℝ)+1), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in (n:ℝ)..((n:ℝ)+1), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) ``
- [`ZetaGrowth.tail_ibp`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_ibp) — `` ∫ x in Ioi (N:ℝ), ((⌊x⌋ : ℂ) + 1/2 - (x:ℂ)) * (x:ℂ) ^ (-(s+1)) = (s+1) * ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2)) ``
- [`ZetaGrowth.zeta1`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1) — *def*
- [`ZetaGrowth.zeta1_eq_zeta`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta) — `` zeta1 N s = riemannZeta s ``
- [`ZetaGrowth.tail_differentiableAt`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_differentiableAt) — `` DifferentiableAt ℂ (fun w : ℂ ↦ ∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(w+2))) z ``
- [`ZetaGrowth.stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-stripRegion) — *def*
- [`ZetaGrowth.isOpen_stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-isOpen_stripRegion) — `` IsOpen stripRegion ``
- [`ZetaGrowth.preconnected_stripRegion`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-preconnected_stripRegion) — `` IsPreconnected stripRegion ``
- [`ZetaGrowth.zeta1_analyticOnNhd`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_analyticOnNhd) — `` AnalyticOnNhd ℂ (zeta1 N) stripRegion ``
- [`ZetaGrowth.zeta1_eq_zeta_strip`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta1_eq_zeta_strip) — `` Set.EqOn (zeta1 N) riemannZeta stripRegion ``
- [`ZetaGrowth.tail_norm_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-tail_norm_le) — `` ‖∫ x in Ioi (N:ℝ), (emA x : ℂ) * (x:ℂ) ^ (-(s+2))‖ ≤ (1/4) * (N:ℝ) ^ (-s.re - 1) ``
- [`ZetaGrowth.sum_norm_le`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-sum_norm_le) — `` ‖∑ n ∈ Finset.range N, 1 / ((n:ℂ) + 1) ^ s‖ ≤ (N:ℝ) * (N:ℝ) ^ ((1:ℝ)/2) ``
- [`ZetaGrowth.zeta_growth_strip`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-zeta_growth_strip) — `` ‖riemannZeta s‖ ≤ 15 * |s.im| ^ 2 ``
- [`ZetaGrowth.sq_mul_zeta_analytic`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_mul_zeta_analytic) — `` AnalyticAt ℂ (fun z : ℂ ↦ (z - 1)^2 * riemannZeta z) s ``
- [`ZetaGrowth.sq_zeta_band_bound`](../lean_stage3/ZetaGrowth.md#ZetaGrowth-sq_zeta_band_bound) — `` ∃ C : ℝ, 0 < C ∧ ∀ s : ℂ, -1/2 ≤ s.re → s.re ≤ 4 → ‖(s - 1)^2 * riemannZeta s‖ ≤ C * (2 + |s.im|) ^ 4 ``

### [`Diagonal`](../lean_stage3/Diagonal.md) — 77

- [`Diagonal.Chk`](../lean_stage3/Diagonal.md#Diagonal-Chk) — *def*
- [`Diagonal.Rhk`](../lean_stage3/Diagonal.md#Diagonal-Rhk) — *def*
- ★ [`Diagonal.Sdiag`](../lean_stage3/Diagonal.md#Diagonal-Sdiag) — *def*
- [`Diagonal.Zd`](../lean_stage3/Diagonal.md#Diagonal-Zd) — *def*
- [`Diagonal.Zhk`](../lean_stage3/Diagonal.md#Diagonal-Zhk) — *def*
- [`Diagonal.SB`](../lean_stage3/Diagonal.md#Diagonal-SB) — *def*
- [`Diagonal.gcd_facts`](../lean_stage3/Diagonal.md#Diagonal-gcd_facts) — `` 0 < Nat.gcd h k ∧ h = Nat.gcd h k * (h / Nat.gcd h k) ∧ k = Nat.gcd h k * (k / Nat.gcd h k) ∧ 1 ≤ h / Nat.gcd h k ∧ 1 ≤ k / Nat.gcd h k ∧ h / Nat.gcd h k ≤ h ∧ … ``
- [`Diagonal.diag_reindex`](../lean_stage3/Diagonal.md#Diagonal-diag_reindex) — `` ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then F (p.1 + 1) (p.2 + 1) else 0) = ∑' l : ℕ, F (k / Nat.gcd h k * (l + 1)) (h / Nat.gcd h k * (l + 1)) ``
- [`Diagonal.ncpow_mul`](../lean_stage3/Diagonal.md#Diagonal-ncpow_mul) — `` ((m * n : ℕ) : ℂ) ^ z = (m : ℂ) ^ z * (n : ℂ) ^ z ``
- [`Diagonal.ell_term`](../lean_stage3/Diagonal.md#Diagonal-ell_term) — `` ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) * (K * ((((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) : ℝ) : ℂ) ^ (-s))… ``
- [`Diagonal.pos_xl`](../lean_stage3/Diagonal.md#Diagonal-pos_xl) — `` 0 < ((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ) ``
- [`Diagonal.summable_cf`](../lean_stage3/Diagonal.md#Diagonal-summable_cf) — `` Summable fun l : ℕ => ‖((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β))‖ * (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)… ``
- [`Diagonal.ell_sum`](../lean_stage3/Diagonal.md#Diagonal-ell_sum) — `` ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l + 1) : ℕ) : ℝ)) t =… ``
- [`Diagonal.re_small'`](../lean_stage3/Diagonal.md#Diagonal-re_small-) — `` -(1 / 10) ≤ α.re ∧ α.re ≤ 1 / 10 ``
- [`Diagonal.im_small'`](../lean_stage3/Diagonal.md#Diagonal-im_small-) — `` -(1 / 10) ≤ α.im ∧ α.im ≤ 1 / 10 ``
- [`Diagonal.rpow_le_ends'`](../lean_stage3/Diagonal.md#Diagonal-rpow_le_ends-) — `` x ^ σ ≤ a ^ σ + b ^ σ ``
- [`Diagonal.gauss_exp`](../lean_stage3/Diagonal.md#Diagonal-gauss_exp) — `` Real.exp (-(1 / 2) * y ^ 2) * Real.exp (2 * |y|) ≤ Real.exp 4 * Real.exp (-(1 / 4) * y ^ 2) ``
- [`Diagonal.KY_bd`](../lean_stage3/Diagonal.md#Diagonal-KY_bd) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ y : ℝ, ‖KY α β t (σ + y * I)‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (t / (2 * Real.pi)) ^ σ… ``
- [`Diagonal.KY_joint_cont`](../lean_stage3/Diagonal.md#Diagonal-KY_joint_cont) — `` Continuous fun p : ℝ × ℝ => KY α β p.1 (σ + p.2 * I) ``
- [`Diagonal.joint_integrable`](../lean_stage3/Diagonal.md#Diagonal-joint_integrable) — `` Integrable (fun p : ℝ × ℝ => (W.w p.1 : ℂ) * (KY α β p.1 (σ + p.2 * I) * Z (σ + p.2 * I))) (volume.prod volume) ``
- [`Diagonal.wVI_integrable`](../lean_stage3/Diagonal.md#Diagonal-wVI_integrable) — `` Integrable fun t => (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Z s) σ ``
- [`Diagonal.norm_cpow_nat`](../lean_stage3/Diagonal.md#Diagonal-norm_cpow_nat) — `` ‖(n : ℂ) ^ z‖ = (n : ℝ) ^ z.re ``
- [`Diagonal.re_line`](../lean_stage3/Diagonal.md#Diagonal-re_line) — `` (-(x + ((σ : ℂ) + y * I))).re = -(x.re + σ) ``
- [`Diagonal.Rhk_norm`](../lean_stage3/Diagonal.md#Diagonal-Rhk_norm) — `` ‖Rhk α β h k (σ + y * I)‖ = ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ)) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ)) ``
- [`Diagonal.Rhk_norm_le`](../lean_stage3/Diagonal.md#Diagonal-Rhk_norm_le) — `` ‖Rhk α β h k (σ + y * I)‖ ≤ ((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + σ')) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.re + σ')) ``
- [`Diagonal.Sdiag_norm_le`](../lean_stage3/Diagonal.md#Diagonal-Sdiag_norm_le) — `` ‖Sdiag M a σ₀ α β (σ + y * I)‖ ≤ SB M a σ₀ α β σ' ``
- [`Diagonal.SB_nonneg`](../lean_stage3/Diagonal.md#Diagonal-SB_nonneg) — `` 0 ≤ SB M a σ₀ α β σ ``
- [`Diagonal.Rhk_differentiable`](../lean_stage3/Diagonal.md#Diagonal-Rhk_differentiable) — `` Differentiable ℂ (Rhk α β h k) ``
- [`Diagonal.Sdiag_differentiable`](../lean_stage3/Diagonal.md#Diagonal-Sdiag_differentiable) — `` Differentiable ℂ (Sdiag M a σ₀ α β) ``
- [`Diagonal.zeta_dirichlet_bound`](../lean_stage3/Diagonal.md#Diagonal-zeta_dirichlet_bound) — `` ‖riemannZeta w‖ ≤ ∑' n : ℕ, ((n : ℝ) + 1) ^ (-w.re) ``
- [`Diagonal.re_w`](../lean_stage3/Diagonal.md#Diagonal-re_w) — `` (1 + α + β + 2 * ((σ : ℂ) + y * I)).re = 1 + α.re + β.re + 2 * σ ``
- [`Diagonal.im_w`](../lean_stage3/Diagonal.md#Diagonal-im_w) — `` (1 + α + β + 2 * ((σ : ℂ) + y * I)).im = α.im + β.im + 2 * y ``
- [`Diagonal.w_ne_one`](../lean_stage3/Diagonal.md#Diagonal-w_ne_one) — `` 1 + α + β + 2 * ((σ : ℂ) + y * I) ≠ 1 ``
- [`Diagonal.zeta_line_cont`](../lean_stage3/Diagonal.md#Diagonal-zeta_line_cont) — `` Continuous fun y : ℝ => riemannZeta (1 + α + β + 2 * ((σ : ℂ) + y * I)) ``
- [`Diagonal.line_integrable`](../lean_stage3/Diagonal.md#Diagonal-line_integrable) — `` Integrable fun y : ℝ => KY α β t (c + y * I) * Z (c + y * I) ``
- [`Diagonal.vi_sum`](../lean_stage3/Diagonal.md#Diagonal-vi_sum) — `` ∑ i ∈ s, VerticalIntegral' (f i) σ = VerticalIntegral' (fun z => ∑ i ∈ s, f i z) σ ``
- [`Diagonal.Kz`](../lean_stage3/Diagonal.md#Diagonal-Kz) — *def*
- [`Diagonal.zeta_line_le`](../lean_stage3/Diagonal.md#Diagonal-zeta_line_le) — `` ‖riemannZeta (1 + α + β + 2 * ((c : ℂ) + y * I))‖ ≤ Kz α β c ``
- [`Diagonal.Kz_nonneg`](../lean_stage3/Diagonal.md#Diagonal-Kz_nonneg) — `` 0 ≤ Kz α β c ``
- [`Diagonal.Zhk_cont`](../lean_stage3/Diagonal.md#Diagonal-Zhk_cont) — `` Continuous fun y : ℝ => Zhk a σ₀ α β h k (σ + y * I) ``
- [`Diagonal.Zd_cont`](../lean_stage3/Diagonal.md#Diagonal-Zd_cont) — `` Continuous fun y : ℝ => Zd M a σ₀ α β (σ + y * I) ``
- [`Diagonal.Zhk_le`](../lean_stage3/Diagonal.md#Diagonal-Zhk_le) — `` ‖Zhk a σ₀ α β h k (c + y * I)‖ ≤ Kz α β c * (‖Chk a σ₀ h k‖ * (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + α.re + c)) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 2 + β.… ``
- [`Diagonal.le_exp_mul`](../lean_stage3/Diagonal.md#Diagonal-le_exp_mul) — `` K ≤ K * Real.exp (2 * |y|) ``
- [`Diagonal.inner_t`](../lean_stage3/Diagonal.md#Diagonal-inner_t) — `` ∑' l : ℕ, ((A * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + α)) * ((B * (l + 1) : ℕ) : ℂ) ^ (-(1 / 2 + β)) * ∫ t, (W.w t : ℂ) * VY α β c (((A * (l + 1) : ℕ) : ℝ) * ((B * (l … ``
- [`Diagonal.inner_hk`](../lean_stage3/Diagonal.md#Diagonal-inner_hk) — `` ∑' p : ℕ × ℕ, (if h * (p.1 + 1) = k * (p.2 + 1) then coefY a σ₀ α β h k (p.1 + 1) (p.2 + 1) * Jint W α β c h k (p.1 + 1) (p.2 + 1) else 0) = ∫ t, (W.w t : ℂ) * … ``
- [`Diagonal.diag_per_t`](../lean_stage3/Diagonal.md#Diagonal-diag_per_t) — `` diagSum W M a σ₀ α β c = ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ α β s) c ``
- [`Diagonal.zeta_bd`](../lean_stage3/Diagonal.md#Diagonal-zeta_bd) — `` ∃ Cz : ℝ, 0 ≤ Cz ∧ ∀ w : ℂ, -(1 / 2) ≤ w.re → w.re ≤ 4 → 3 / 10 ≤ ‖w - 1‖ → ‖riemannZeta w‖ ≤ Cz * Real.exp |w.im| ``
- [`Diagonal.Ez`](../lean_stage3/Diagonal.md#Diagonal-Ez) — *def*
- [`Diagonal.Ez_eq`](../lean_stage3/Diagonal.md#Diagonal-Ez_eq) — `` Ez w = (w - 1) * riemannZeta w ``
- [`Diagonal.Ez_differentiable`](../lean_stage3/Diagonal.md#Diagonal-Ez_differentiable) — `` Differentiable ℂ Ez ``
- [`Diagonal.Hf`](../lean_stage3/Diagonal.md#Diagonal-Hf) — *def*
- [`Diagonal.Hf_eq`](../lean_stage3/Diagonal.md#Diagonal-Hf_eq) — `` Hf α β t Z s = KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s) ``
- [`Diagonal.gY_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-gY_differentiableAt) — `` DifferentiableAt ℂ (gY α β t) s ``
- [`Diagonal.Kf`](../lean_stage3/Diagonal.md#Diagonal-Kf) — *def*
- [`Diagonal.Kf_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-Kf_differentiableAt) — `` DifferentiableAt ℂ (Kf α β t Z) s ``
- [`Diagonal.Hf_differentiableAt`](../lean_stage3/Diagonal.md#Diagonal-Hf_differentiableAt) — `` DifferentiableAt ℂ (Hf α β t Z) s ``
- [`Diagonal.Hf_local`](../lean_stage3/Diagonal.md#Diagonal-Hf_local) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h 0 ∧ ∀ᶠ s in 𝓝[≠] (0 : ℂ), Hf α β t Z s = h s + riemannZeta (1 + α + β) * Z 0 / (s - 0) ``
- [`Diagonal.orig_bound`](../lean_stage3/Diagonal.md#Diagonal-orig_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ (Z : ℂ → ℂ) (KZ : ℝ), ∀ σ y : ℝ, -(1 / 4) ≤ σ → σ ≤ 1 → 1 / 4 ≤ ‖(σ : ℂ) + y * I‖ →… ``
- [`Diagonal.gauss4_atTop`](../lean_stage3/Diagonal.md#Diagonal-gauss4_atTop) — `` Tendsto (fun y : ℝ => Real.exp (-(1 / 4) * y ^ 2)) atTop (𝓝 0) ``
- [`Diagonal.gauss4_atBot`](../lean_stage3/Diagonal.md#Diagonal-gauss4_atBot) — `` Tendsto (fun y : ℝ => Real.exp (-(1 / 4) * y ^ 2)) atBot (𝓝 0) ``
- [`Diagonal.shift_t`](../lean_stage3/Diagonal.md#Diagonal-shift_t) — `` VerticalIntegral' (fun s => KY α β t s * (riemannZeta (1 + α + β + 2 * s) * Z s)) 1 = riemannZeta (1 + α + β) * Z 0 + VerticalIntegral' (fun s => KY α β t s * (… ``
- [`Diagonal.zeta_left`](../lean_stage3/Diagonal.md#Diagonal-zeta_left) — `` ∃ Cz : ℝ, 0 ≤ Cz ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ y : ℝ, ‖riemannZeta (1 + α + β + 2 * (((-(1 / 4) : ℝ) : ℂ) + y * I))‖ ≤ Cz * Real.exp (2 * |y|) ``
- [`Diagonal.norm_VI_le`](../lean_stage3/Diagonal.md#Diagonal-norm_VI_le) — `` ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * ∫ y : ℝ, ‖f (σ + y * I)‖ ``
- [`Diagonal.diag_shift`](../lean_stage3/Diagonal.md#Diagonal-diag_shift) — `` diagSum W M a σ₀ α β 1 = (what0 W : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) + ∫ t, (W.w t : ℂ) * VerticalIntegral' (fun s => KY α β t s * Zd M a σ₀ … ``
- [`Diagonal.shifted_bound`](../lean_stage3/Diagonal.md#Diagonal-shifted_bound) — `` ∃ K0 : ℝ, 0 ≤ K0 ∧ ∀ (T L : ℝ) (W : Weight T L), 4 ≤ T → ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ‖∫ t, (W.w t : ℂ) * VerticalInt… ``
- [`Diagonal.aY_bound'`](../lean_stage3/Diagonal.md#Diagonal-aY_bound-) — `` ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R : ℝ) (h : ℕ), 1 ≤ h → h ≤ Mof T θ → ‖aY P T θ R h‖ * (h : ℝ) ^ (-sig0 T R) ≤ B * (h : ℝ) ^ (-(1 / 2) : ℝ) ``
- [`Diagonal.Chk_norm`](../lean_stage3/Diagonal.md#Diagonal-Chk_norm) — `` ‖Chk a σ₀ h k‖ = (‖a h‖ * (h : ℝ) ^ (-σ₀)) * (‖a k‖ * (k : ℝ) ^ (-σ₀)) ``
- [`Diagonal.pow_shift_le`](../lean_stage3/Diagonal.md#Diagonal-pow_shift_le) — `` (j : ℝ) ^ (-(1 / 2 + x + -(1 / 4))) ≤ Real.exp (κ / 2) * (j : ℝ) ^ (-(1 / 4) : ℝ) ``
- [`Diagonal.harm_le`](../lean_stage3/Diagonal.md#Diagonal-harm_le) — `` ∑ j ∈ Finset.Icc 1 M, ((j : ℝ))⁻¹ ≤ 1 + Real.log M ``
- [`Diagonal.sum34_le`](../lean_stage3/Diagonal.md#Diagonal-sum34_le) — `` ∑ j ∈ Finset.Icc 1 M, (j : ℝ) ^ (-(3 / 4) : ℝ) ≤ (M : ℝ) ^ (1 / 4 : ℝ) * (1 + Real.log M) ``
- [`Diagonal.gcd_term`](../lean_stage3/Diagonal.md#Diagonal-gcd_term) — `` (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) * (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ)) = ((Nat.gcd … ``
- [`Diagonal.gcd_sum`](../lean_stage3/Diagonal.md#Diagonal-gcd_sum) — `` ∑ h ∈ Finset.Icc 1 M, ∑ k ∈ Finset.Icc 1 M, (h : ℝ) ^ (-(1 / 2) : ℝ) * (k : ℝ) ^ (-(1 / 2) : ℝ) * (((k / Nat.gcd h k : ℕ) : ℝ) ^ (-(1 / 4) : ℝ) * ((h / Nat.gcd … ``
- [`Diagonal.SB_young`](../lean_stage3/Diagonal.md#Diagonal-SB_young) — `` ∃ B : ℝ, 0 ≤ B ∧ ∀ (T θ R κ : ℝ), 1 < T → θ < 1 / 2 → ∀ α β : ℂ, ‖α‖ ≤ κ / Real.log T → ‖β‖ ≤ κ / Real.log T → SB (Mof T θ) (aY P T θ R) (sig0 T R) α β (-(1 / 4… ``
- [`Diagonal.logpow_eps`](../lean_stage3/Diagonal.md#Diagonal-logpow_eps) — `` Real.log T ^ p ≤ (((p : ℝ) + 1) / ε) ^ p * T ^ ε ``
- [`Diagonal.final_size_diag`](../lean_stage3/Diagonal.md#Diagonal-final_size_diag) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ T : ℝ, Real.exp 1 ≤ T → ∀ M : ℕ, (M : ℝ) ≤ T ^ θ → (1 + κ ^ 2 * Real.log T ^ 2) * T * (T / (8 * Real.pi)) ^ (-(1 / 4) : ℝ) * ((M : ℝ) ^ (1 / … ``
- ★ [`Diagonal.StmtDiagMain`](../lean_stage3/Diagonal.md#Diagonal-StmtDiagMain) — *def*
- ★ [`Diagonal.diag_young`](../lean_stage3/Diagonal.md#Diagonal-diag_young) — `` ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ, Regime κ T α β → ‖diagSum W (Mof T θ) (aY P T θ R) (sig0 T R) α β 1 - (what0 W : ℂ… ``

