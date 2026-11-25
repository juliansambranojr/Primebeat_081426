# What `ApproxDerivAll.dY_iter_bound` rests on

[`ApproxDerivAll.dY_iter_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dY_iter_bound) in `lean_stage3/Stage3/ApproxDerivAll.lean`, line 450.

**Why.** Target 1. For every `k`, `t^(k+1) ‖∂_tᵏ dY α β t (σ+iy)‖ ≤ Dk k (1+|σ|)(1+|y|)^(k+2)`, uniformly in `‖α‖, ‖β‖ ≤ 1/10`, `σ ≥ −1/4`, `t ≥ 1`, with `∂_tᵏ` the iterated derivative of the smooth map `t ↦ dY` (`dY_contDiff`).

**Proves**

```lean
t ^ (k + 1) * ‖iteratedDeriv k (fun t => dY α β t (σ + y * I)) t‖ ≤ Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2)
```

**Needs** (its hypotheses)

  - `` hα : ‖α‖ ≤ 1 / 10 ``
  - `` hβ : ‖β‖ ≤ 1 / 10 ``
  - `` hσ0 : -(1 / 4) ≤ σ ``
  - `` k : ℕ ``
  - `` ht : 1 ≤ t ``
  - `` y : ℝ ``

Behind it: 30 theorems and 10 definitions in 3 files. Every one is listed below; Lean recorded each step.

## The files it passes through

```mermaid
flowchart LR
  f0["<b>ApproxFE</b><br/>6 used"]:::thm
  f1["<b>ApproxDeriv</b><br/>16 used"]:::thm
  f2["<b>ApproxDerivAll</b><br/>dY_iter_bound"]:::end_
  f0 --> f1
  f1 --> f2
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

### [`ApproxFE`](../lean_stage3/ApproxFE.md) — 6

- [`ApproxFE.uA`](../lean_stage3/ApproxFE.md#ApproxFE-uA) — *def*
- [`ApproxFE.vB`](../lean_stage3/ApproxFE.md#ApproxFE-vB) — *def*
- [`ApproxFE.uA_re`](../lean_stage3/ApproxFE.md#ApproxFE-uA_re) — `` (uA α t).re = 1 / 2 + α.re ``
- [`ApproxFE.vB_re`](../lean_stage3/ApproxFE.md#ApproxFE-vB_re) — `` (vB β t).re = 1 / 2 + β.re ``
- [`ApproxFE.uA_im`](../lean_stage3/ApproxFE.md#ApproxFE-uA_im) — `` (uA α t).im = α.im + t ``
- [`ApproxFE.vB_im`](../lean_stage3/ApproxFE.md#ApproxFE-vB_im) — `` (vB β t).im = β.im - t ``

### [`ApproxDeriv`](../lean_stage3/ApproxDeriv.md) — 16

- [`ApproxDeriv.ne_neg_nat_of_re_pos`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-ne_neg_nat_of_re_pos) — `` z ≠ -(m : ℂ) ``
- [`ApproxDeriv.hasDerivAt_line`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasDerivAt_line) — `` HasDerivAt (fun t : ℝ => w₀ + (t : ℂ) * e) e t ``
- ★ [`ApproxDeriv.dY`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY) — *def*
- [`ApproxDeriv.re_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-re_conds) — `` 1 / 20 ≤ (uA α t / 2).re ∧ 1 / 20 ≤ (uA α t / 2 + s / 2).re ∧ 1 / 20 ≤ (vB β t / 2).re ∧ 1 / 20 ≤ (vB β t / 2 + s / 2).re ``
- [`ApproxDeriv.tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tau) — *def*
- [`ApproxDeriv.hasSum_tau`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tau) — `` HasSum (tau h w) (digamma (w + h) - digamma w) ``
- [`ApproxDeriv.norm_nat_add_ge`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_nat_add_ge) — `` ((n : ℝ) + a + Y) / 2 ≤ ‖(n : ℂ) + z‖ ``
- [`ApproxDeriv.tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-tel) — *def*
- [`ApproxDeriv.hasSum_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-hasSum_tel) — `` HasSum (tel b) (1 / b) ``
- [`ApproxDeriv.sq_le_tel`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-sq_le_tel) — `` 1 / ((n : ℝ) + b) ^ 2 ≤ (1 + 1 / b) * tel b n ``
- [`ApproxDeriv.nat_add_ne`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-nat_add_ne) — `` (n : ℂ) + z ≠ 0 ``
- [`ApproxDeriv.dY_hasSum`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-dY_hasSum) — `` HasSum (fun n => I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n)) (dY α β t s) ``
- [`ApproxDeriv.norm_I_half`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_I_half) — `` ‖I / 2‖ = 1 / 2 ``
- [`ApproxDeriv.norm_half_le`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-norm_half_le) — `` ‖((σ : ℂ) + y * I) / 2‖ ≤ (1 + |σ|) * (1 + |y|) ``
- [`ApproxDeriv.im_conds`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-im_conds) — `` t / 5 ≤ |(uA α t / 2).im| ∧ t / 5 ≤ |(uA α t / 2 + ((σ : ℂ) + y * I) / 2).im| ∧ t / 5 ≤ |(vB β t / 2).im| ∧ t / 5 ≤ |(vB β t / 2 + ((σ : ℂ) + y * I) / 2).im| ``
- [`ApproxDeriv.b_facts`](../lean_stage3/ApproxDeriv.md#ApproxDeriv-b_facts) — `` t * (1 / (1 / 20 + t / 5)) ≤ 5 ∧ 1 + 1 / (1 / 20 + t / 5) ≤ 6 ``

### [`ApproxDerivAll`](../lean_stage3/ApproxDerivAll.md) — 18

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
- ★ [`ApproxDerivAll.iteratedDeriv_dY`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-iteratedDeriv_dY) — `` iteratedDeriv k (fun t => dY α β t s) = fun t => dYk α β k t s ``
- [`ApproxDerivAll.Dc`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dc) — *def*
- ★ [`ApproxDerivAll.Dk`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-Dk) — *def*
- [`ApproxDerivAll.dYk_crude`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_crude) — `` ‖dYk α β k t (σ + y * I)‖ ≤ Dc k * ((1 + |σ|) * (1 + |y|)) ``
- ★ [`ApproxDerivAll.dYk_bound`](../lean_stage3/ApproxDerivAll.md#ApproxDerivAll-dYk_bound) — `` t ^ (k + 1) * ‖dYk α β k t (σ + y * I)‖ ≤ Dk k * (1 + |σ|) * (1 + |y|) ^ (k + 2) ``

