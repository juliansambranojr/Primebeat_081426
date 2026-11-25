# What `ApproxDerivAll.VY_iter_bound` rests on

[`ApproxDerivAll.VY_iter_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VY_iter_bound) in `lean_stage3/Stage3/ApproxDerivAll.lean`, line 913.

**Why.** Young's (4.3) for every `j ≥ 1`. For every `j ≥ 1` and `A > 0` there is `C` with `‖t^j ∂_t^j V_{α,β}(x,t)‖ ≤ C (1 + ‖α+β‖^(−2)) (1 + x/t)^(−A)`, uniformly in `‖α‖, ‖β‖ ≤ 1/10` with `α + β ≠ 0`, `t ≥ 1`, `x > 0`, and the line `c > 0` of `V`.

**Proves**

```lean
∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ‖(t : ℂ) ^ j * iteratedDeriv j (fun t => VY α β c x t) t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A)
```

**Needs** (its hypotheses)

  - `` hj : 1 ≤ j ``
  - `` hA : 0 < A ``

Behind it: 98 theorems and 21 definitions in 6 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ApproxFE</b><br/>13 used"]:::thm
  f1["<b>ContourShift</b><br/>6 used"]:::thm
  f2["<b>ApproxShift</b><br/>7 used"]:::thm
  f3["<b>ApproxBounds</b><br/>22 used"]:::thm
  f4["<b>ApproxDeriv</b><br/>26 used"]:::thm
  f5["<b>ApproxDerivAll</b><br/>VY_iter_bound"]:::end_
  f0 --> f2
  f1 --> f2
  f2 --> f3
  f3 --> f4
  f4 --> f5
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

### [`ApproxFE`](../lean_stage3/ApproxFE.md) — 13

- [`ApproxFE.uA`](../lean_stage3/ApproxFE.md#ApproxFE-uA) — *def*
- [`ApproxFE.vB`](../lean_stage3/ApproxFE.md#ApproxFE-vB) — *def*
- [`ApproxFE.GY`](../lean_stage3/ApproxFE.md#ApproxFE-GY) — *def*
- [`ApproxFE.gY`](../lean_stage3/ApproxFE.md#ApproxFE-gY) — *def*
- [`ApproxFE.KY`](../lean_stage3/ApproxFE.md#ApproxFE-KY) — *def*
- ★ [`ApproxFE.VY`](../lean_stage3/ApproxFE.md#ApproxFE-VY) — *def*
- [`ApproxFE.uA_re`](../lean_stage3/ApproxFE.md#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
- [`ApproxFE.vB_re`](../lean_stage3/ApproxFE.md#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``
- [`ApproxFE.uA_im`](../lean_stage3/ApproxFE.md#ApproxFE-uA_im) — `` (uA α t).im = α.im + t ``
- [`ApproxFE.vB_im`](../lean_stage3/ApproxFE.md#ApproxFE-vB_im) — `` (vB β t).im = β.im - t ``
- [`ApproxFE.KY_differentiableAt`](../lean_stage3/ApproxFE.md#ApproxFE-KY_differentiableAt) — `` DifferentiableAt ℂ (KY α β t) s ``
- [`ApproxFE.GY_zero`](../lean_stage3/ApproxFE.md#ApproxFE-GY_zero) — `` GY α β 0 = 1 ``
- [`ApproxFE.gY_zero`](../lean_stage3/ApproxFE.md#ApproxFE-gY_zero) — `` gY α β t 0 = 1 ``

### [`ContourShift`](../lean_stage3/ContourShift.md) — 6

- [`ContourShift.borderIntegrable_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-borderIntegrable_sum_poles) — `` RectangleBorderIntegrable (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w ``
- [`ContourShift.rectangleIntegral_sum_poles`](../lean_stage3/ContourShift.md#ContourShift-rectangleIntegral_sum_poles) — `` RectangleIntegral' (fun s ↦ ∑ p ∈ P, A p / (s - p)) z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_multi`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_multi) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.residue_rectangle_of_local`](../lean_stage3/ContourShift.md#ContourShift-residue_rectangle_of_local) — `` RectangleIntegral' f z w = ∑ p ∈ P, A p ``
- [`ContourShift.analyticAt_dslope`](../lean_stage3/ContourShift.md#ContourShift-analyticAt_dslope) — `` AnalyticAt ℂ (dslope f p) p ``
- [`ContourShift.div_sub_eq_dslope`](../lean_stage3/ContourShift.md#ContourShift-div_sub_eq_dslope) — `` f s / (s - p) = f p / (s - p) + dslope f p s ``

### [`ApproxShift`](../lean_stage3/ApproxShift.md) — 7

- [`ApproxShift.GY_norm_le`](../lean_stage3/ApproxShift.md#ApproxShift-GY_norm_le) — `` ‖GY α β s‖ ≤ Real.exp (c ^ 2 - s.im ^ 2) * ((‖α + β‖ ^ 2 + 4 * c ^ 2 + 4) / ‖α + β‖ ^ 2 * (1 + s.im ^ 2)) ``
- [`ApproxShift.gauss_atTop`](../lean_stage3/ApproxShift.md#ApproxShift-gauss_atTop) — `` Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) atTop (𝓝 0) ``
- [`ApproxShift.gauss_atBot`](../lean_stage3/ApproxShift.md#ApproxShift-gauss_atBot) — `` Tendsto (fun y : ℝ => Real.exp (-(1 / 2) * y ^ 2)) atBot (𝓝 0) ``
- [`ApproxShift.GY_analyticAt`](../lean_stage3/ApproxShift.md#ApproxShift-GY_analyticAt) — `` AnalyticAt ℂ (GY α β) p ``
- [`ApproxShift.local_simple`](../lean_stage3/ApproxShift.md#ApproxShift-local_simple) — `` ∃ h : ℂ → ℂ, AnalyticAt ℂ h p ∧ ∀ᶠ s in 𝓝[≠] p, f s = h s + A / (s - p) ``
- [`ApproxShift.rect_mem_nhds`](../lean_stage3/ApproxShift.md#ApproxShift-rect_mem_nhds) — `` Rectangle (↑(-c) - I * ↑T) (↑c + I * ↑T) ∈ 𝓝 p ``
- [`ApproxShift.rect_tendsto`](../lean_stage3/ApproxShift.md#ApproxShift-rect_tendsto) — `` Tendsto (fun T : ℝ => RectangleIntegral f (↑(-c) - I * T) (↑c + I * T)) atTop (𝓝 (VerticalIntegral f c - VerticalIntegral f (-c))) ``

### [`ApproxBounds`](../lean_stage3/ApproxBounds.md) — 22

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
- [`ApproxBounds.integrand_differentiableAt`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
- [`ApproxBounds.rpow_le_ends`](../lean_stage3/ApproxBounds.md#ApproxBounds-rpow_le_ends) — `` b ^ σ ≤ b ^ σ₀ + b ^ σ₁ ``
- [`ApproxBounds.rect_tendsto_ab`](../lean_stage3/ApproxBounds.md#ApproxBounds-rect_tendsto_ab) — `` Tendsto (fun T : ℝ => RectangleIntegral f (↑a - I * T) (↑b + I * T)) atTop (𝓝 (VerticalIntegral f b - VerticalIntegral f a)) ``
- [`ApproxBounds.VY_line_eq`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_line_eq) — `` VY α β c x t = VY α β c' x t ``
- [`ApproxBounds.integrand_differentiableAt'`](../lean_stage3/ApproxBounds.md#ApproxBounds-integrand_differentiableAt-) — `` DifferentiableAt ℂ (fun s => KY α β t s * (x : ℂ) ^ (-s)) s ``
- [`ApproxBounds.VY_residue`](../lean_stage3/ApproxBounds.md#ApproxBounds-VY_residue) — `` VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 ``
- [`ApproxBounds.rpow_quarter_le`](../lean_stage3/ApproxBounds.md#ApproxBounds-rpow_quarter_le) — `` b ^ (1 / 4 : ℝ) ≤ 1 + b ``

### [`ApproxDeriv`](../lean_stage3/ApproxDeriv.md) — 26

- [`ApproxDeriv.psiR`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-psiR) — *def*
- [`ApproxDeriv.ne_neg_nat_of_re_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-ne_neg_nat_of_re_pos) — `` z ≠ -(m : ℂ) ``
- [`ApproxDeriv.hasDerivAt_line`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasDerivAt_line) — `` HasDerivAt (fun t : ℝ => w₀ + (t : ℂ) * e) e t ``
- [`ApproxDeriv.dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY) — *def*
- [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds) — `` 1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧ 1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re ``
- [`ApproxDeriv.gY_hasDerivAt`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gY_hasDerivAt) — `` HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t ``
- [`ApproxDeriv.tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tau) — *def*
- [`ApproxDeriv.hasSum_tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tau) — `` HasSum (tau h w) (digamma (w + h) - digamma w) ``
- [`ApproxDeriv.norm_nat_add_ge`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_nat_add_ge) — `` ((n : ℝ) + a + Y) / 2 ≤ ‖(n : ℂ) + z‖ ``
- [`ApproxDeriv.tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tel) — *def*
- [`ApproxDeriv.hasSum_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tel) — `` HasSum (tel b) (1 / b) ``
- [`ApproxDeriv.sq_le_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-sq_le_tel) — `` 1 / ((n : ℝ) + b) ^ 2 ≤ (1 + 1 / b) * tel b n ``
- [`ApproxDeriv.nat_add_ne`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-nat_add_ne) — `` (n : ℂ) + z ≠ 0 ``
- [`ApproxDeriv.dY_hasSum`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasSum) — `` HasSum (fun n => I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)) (dY α β t s) ``
- [`ApproxDeriv.norm_I_half`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_I_half) — `` ‖I / 2‖ = 1 / 2 ``
- [`ApproxDeriv.poly_gauss`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-poly_gauss) — `` (1 + |y|) ^ k * Real.exp (-(1 / 2) * y ^ 2) ≤ (k.factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) ``
- [`ApproxDeriv.gauss_loc`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-gauss_loc) — `` Real.exp (-y ^ 2) * (1 + y ^ 2) * (1 + |y|) ^ k ≤ ((k + 2).factorial : ℝ) * Real.exp 2 * Real.exp (-(1 / 4) * y ^ 2) ``
- [`ApproxDeriv.norm_half_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_half_le) — `` ‖((σ : ℂ) + y * I) / 2‖ ≤ (1 + |σ|) * (1 + |y|) ``
- [`ApproxDeriv.KY_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-KY_local) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ, ‖KY α β t (σ + y * I)‖ ≤ C * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
- [`ApproxDeriv.norm_F_local`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_F_local) — `` ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤ C * x ^ (-σ) * (Real.exp (-y ^ 2) * (1 + y ^ 2)) ``
- [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds) — `` t / 5 ≤ |(uA α t / 2).im| ∧ t / 5 ≤ |(uA α t / 2 + ((σ : ℂ) + y * I) / 2).im| ∧ t / 5 ≤ |(vB β t / 2).im| ∧ t / 5 ≤ |(vB β t / 2 + ((σ : ℂ) + y * I) / 2).im| ``
- [`ApproxDeriv.b_facts`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-b_facts) — `` t * (1 / (1 / 20 + t / 5)) ≤ 5 ∧ 1 + 1 / (1 / 20 + t / 5) ≤ 6 ``
- [`ApproxDeriv.norm_VI_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_VI_le) — `` ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * ∫ y : ℝ, ‖f (σ + y * I)‖ ``
- [`ApproxDeriv.VI_gauss`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-VI_gauss) — `` ‖VerticalIntegral' f σ‖ ≤ 1 / (2 * Real.pi) * (B * Real.sqrt (Real.pi / (1 / 4))) ``
- ★ [`ApproxDeriv.assemble`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-assemble) — `` z ≤ (8 * Cm * 2 ^ A + Ca * 2 ^ A) * N * (1 + x / t) ^ (-A) ``
- [`ApproxDeriv.deriv_eq_of_eq_Ici`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-deriv_eq_of_eq_Ici) — `` f' = g' ``

### [`ApproxDerivAll`](../lean_stage3/ApproxDerivAll.md) — 45

- [`ApproxDerivAll.tauK`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-tauK) — *def*
- [`ApproxDerivAll.tauK_zero`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-tauK_zero) — `` tauK 0 h w n = tau h w n ``
- [`ApproxDerivAll.hasDerivAt_tauK_line`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-hasDerivAt_tauK_line) — `` HasDerivAt (fun t : ℝ => tauK k h (w₀ + t * e) n) (e * tauK (k + 1) h (w₀ + t * e) n) t ``
- [`ApproxDerivAll.norm_tauK_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_tauK_le) — `` ‖tauK k h w n‖ ≤ ((k + 1).factorial : ℝ) * ‖h‖ * 2 ^ (k + 2) * (1 / (a + Y)) ^ k * (1 / ((n : ℝ) + (a + Y)) ^ 2) ``
- [`ApproxDerivAll.dYterm`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYterm) — *def*
- [`ApproxDerivAll.dYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk) — *def*
- [`ApproxDerivAll.dYk_zero`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_zero) — `` dYk α β 0 t s = dY α β t s ``
- [`ApproxDerivAll.norm_pow_I_half`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_pow_I_half) — `` ‖(I / 2) ^ k‖ = (1 / 2) ^ k ``
- [`ApproxDerivAll.norm_pow_neg_I_half`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_pow_neg_I_half) — `` ‖(-(I / 2)) ^ k‖ = (1 / 2) ^ k ``
- [`ApproxDerivAll.norm_dYterm_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYterm_le) — `` ‖dYterm α β k t s n‖ ≤ 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k * (1 + 1 / (1 / 20 + Y)) * tel (1 / 20 + Y) n ``
- [`ApproxDerivAll.summable_dYterm`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-summable_dYterm) — `` Summable (dYterm α β k t s) ``
- [`ApproxDerivAll.norm_dYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_dYk_le) — `` ‖dYk α β k t s‖ ≤ 4 * ((k + 1).factorial : ℝ) * ‖s / 2‖ * (1 / (1 / 20 + Y)) ^ k * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) ``
- [`ApproxDerivAll.dYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_hasDerivAt) — `` HasDerivAt (fun t => dYk α β k t s) (dYk α β (k + 1) t s) t ``
- [`ApproxDerivAll.dYk_contDiff`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_contDiff) — `` ∀ k : ℕ, ContDiff ℝ n (fun t => dYk α β k t s) ``
- [`ApproxDerivAll.iteratedDeriv_dY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-iteratedDeriv_dY) — `` iteratedDeriv k (fun t => dY α β t s) = fun t => dYk α β k t s ``
- [`ApproxDerivAll.dY_contDiff`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dY_contDiff) — `` ContDiff ℝ ∞ (fun t => dY α β t s) ``
- [`ApproxDerivAll.Dc`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dc) — *def*
- [`ApproxDerivAll.Dk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dk) — *def*
- [`ApproxDerivAll.Dc_nonneg`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dc_nonneg) — `` 0 ≤ Dc k ``
- [`ApproxDerivAll.Dk_nonneg`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dk_nonneg) — `` 0 ≤ Dk k ``
- [`ApproxDerivAll.dYk_crude`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_crude) — `` ‖dYk α β k t (σ + y * I)‖ ≤ Dc k * ((1 + |σ|) * (1 + |y|)) ``
- [`ApproxDerivAll.dYk_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_bound) — `` t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖ ≤ Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) ``
- [`ApproxDerivAll.pow_key`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-pow_key) — `` (a * q) ^ i * a * q ^ (J - i + 1) ≤ (a * q) ^ (J + 1) ``
- [`ApproxDerivAll.leib_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-leib_bound) — `` ∃ M : ℝ, 0 ≤ M ∧ ∀ (H d : ℕ → ℂ) (G a q : ℝ), 1 ≤ a → 0 ≤ q → ‖H 0‖ ≤ G → (∀ j, H (j + 1) = ∑ i ∈ Finset.range (j + 1), (j.choose i : ℂ) * H i * d (j - i)) → (∀… ``
- [`ApproxDerivAll.gY_contDiff`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_contDiff) — `` ContDiff ℝ n (fun t => gY α β t s) ``
- [`ApproxDerivAll.gY_contDiff_top`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_contDiff_top) — `` ContDiff ℝ ∞ (fun t => gY α β t s) ``
- [`ApproxDerivAll.gY_iter_succ`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_succ) — `` iteratedDeriv (j + 1) (fun t => gY α β t s) t = ∑ i ∈ Finset.range (j + 1), (j.choose i : ℂ) * iteratedDeriv i (fun t => gY α β t s) t * dYk α β (j - i) t s ``
- [`ApproxDerivAll.gY_iter_crude`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_crude) — `` ∃ R : ℝ, 0 ≤ R ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t y : ℝ, ‖iteratedDeriv j (fun t => gY α β t (σ + y * I)) t‖ ≤ ‖gY α β t (σ + y * I)‖ * R * ((1 + |σ… ``
- [`ApproxDerivAll.gY_iter_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-gY_iter_bound) — `` ∃ M : ℝ, 0 ≤ M ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ y : ℝ, ‖iteratedDeriv j (fun t => gY α β t (σ + y * I)) t‖ ≤ ‖gY α β t (σ + y * I)‖… ``
- [`ApproxDerivAll.cont_gY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_gY) — `` Continuous fun y : ℝ => gY α β t (σ + y * I) ``
- [`ApproxDerivAll.cont_pre`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_pre) — `` Continuous fun y : ℝ => GY α β ((σ : ℂ) + y * I) / ((σ : ℂ) + y * I) ``
- [`ApproxDerivAll.cont_xpow`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-cont_xpow) — `` Continuous fun y : ℝ => (x : ℂ) ^ (-((σ : ℂ) + y * I)) ``
- [`ApproxDerivAll.meas_dYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_dYk) — `` AEStronglyMeasurable (fun y : ℝ => dYk α β k t (σ + y * I)) volume ``
- [`ApproxDerivAll.meas_gY_iter`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_gY_iter) — `` ∀ i ≤ J, AEStronglyMeasurable (fun y : ℝ => iteratedDeriv i (fun t => gY α β t (σ + y * I)) t) volume ``
- [`ApproxDerivAll.IYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk) — *def*
- [`ApproxDerivAll.VYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk) — *def*
- [`ApproxDerivAll.VYk_zero`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_zero) — `` VYk α β 0 c x t = VY α β c x t ``
- [`ApproxDerivAll.IYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk_hasDerivAt) — `` HasDerivAt (fun t => IYk α β x j t s) (IYk α β x (j + 1) t s) t ``
- [`ApproxDerivAll.norm_IYk_le`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-norm_IYk_le) — `` ‖IYk α β x j t s‖ ≤ ‖KY α β t s * (x : ℂ) ^ (-s)‖ * B ``
- [`ApproxDerivAll.meas_IYk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-meas_IYk) — `` AEStronglyMeasurable (fun y : ℝ => IYk α β x j t (σ + y * I)) volume ``
- [`ApproxDerivAll.IYk_local`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-IYk_local) — `` ∃ K : ℝ, 0 ≤ K ∧ ∀ t ∈ Metric.closedBall t₀ 1, ∀ y : ℝ, ‖IYk α β x j t (σ + y * I)‖ ≤ K * Real.exp (-(1 / 4) * y ^ 2) ``
- [`ApproxDerivAll.VYk_hasDerivAt`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_hasDerivAt) — `` HasDerivAt (fun t => VYk α β j σ x t) (VYk α β (j + 1) σ x t₀) t₀ ``
- ★ [`ApproxDerivAll.VYk_line_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_line_bound) — `` ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ‖(t : ℂ) ^ j * VYk α β j σ x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / … ``
- ★ [`ApproxDerivAll.VYk_lines`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-VYk_lines) — `` ∀ y : ℝ, 1 ≤ y → VYk α β (j + 1) c x y = VYk α β (j + 1) A x y ∧ VYk α β (j + 1) c x y = VYk α β (j + 1) (-(1 / 4)) x y ``
- ★ [`ApproxDerivAll.iteratedDeriv_VY_all`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-iteratedDeriv_VY_all) — `` iteratedDeriv j (fun t => VY α β c x t) = fun t => VYk α β j c x t ``

