> Source: session transcript, 2026-11-25

> Yes to all of it please



From `lean_stage3/Stage3/ApproxDeriv.lean`, the pinned statements:

```
theorem hasDerivAt_Gammaℝ {w : ℂ} (hw : 0 < w.re) :
    HasDerivAt Gammaℝ (Gammaℝ w * psiR w) w :=
```

```
theorem gY_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasDerivAt (fun t => gY α β t s) (gY α β t s * dY α β t s) t :=
```

```
theorem hasSum_tau {h w : ℂ} (hw : 0 < w.re) (hwh : 0 < (w + h).re) :
    HasSum (tau h w) (digamma (w + h) - digamma w) :=
```

```
theorem dY_hasSum {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasSum (fun n => I / 2 * (tau (s / 2) (uA α t / 2) n - tau (s / 2) (vB β t / 2) n))
      (dY α β t s) :=
```

```
theorem norm_dY_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) :
    ‖dY α β t s‖ ≤ 4 * ‖s / 2‖ * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) :=
```

```
theorem norm_d2Y_le {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) {Y : ℝ} (hY : 0 ≤ Y)
    (i1 : Y ≤ |(uA α t / 2).im|) (i2 : Y ≤ |(uA α t / 2 + s / 2).im|)
    (i3 : Y ≤ |(vB β t / 2).im|) (i4 : Y ≤ |(vB β t / 2 + s / 2).im|) :
    ‖d2Y α β t s‖ ≤ 8 * ‖s / 2‖ / (1 / 20 + Y) * (1 + 1 / (1 / 20 + Y)) * (1 / (1 / 20 + Y)) :=
```

```
theorem dY_hasDerivAt {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {s : ℂ}
    (hs : -(1 / 4) ≤ s.re) (t : ℝ) :
    HasDerivAt (fun t => dY α β t s) (d2Y α β t s) t :=
```

```
theorem dY_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t * ‖dY α β t (σ + y * I)‖ ≤ 3360 * (1 + |σ|) * (1 + |y|) ^ 2 :=
```

```
theorem d2Y_bound {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {σ : ℝ}
    (hσ0 : -(1 / 4) ≤ σ) {t : ℝ} (ht : 1 ≤ t) (y : ℝ) :
    t ^ 2 * ‖d2Y α β t (σ + y * I)‖ ≤ 268800 * (1 + |σ|) * (1 + |y|) ^ 3 :=
```

```
theorem VYj_line_bound {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖(t : ℂ) ^ 1 * VY1 α β σ x t‖ ≤
            C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) ∧
          ‖(t : ℂ) ^ 2 * VY2 α β σ x t‖ ≤
            C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) :=
```

```
theorem VYj_lines {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {x : ℝ} (hx : 0 < x) {c A : ℝ} (hc : 0 < c) (hA : 0 < A) {t : ℝ} (ht : 1 ≤ t) :
    VY1 α β c x t = VY1 α β A x t ∧ VY1 α β c x t = VY1 α β (-(1 / 4)) x t ∧
      VY2 α β c x t = VY2 α β A x t ∧ VY2 α β c x t = VY2 α β (-(1 / 4)) x t :=
```

```
theorem VY_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (t₀ : ℝ) :
    HasDerivAt (fun t => VY α β σ x t) (VY1 α β σ x t₀) t₀ :=
```

```
theorem VY1_hasDerivAt {σ : ℝ} (hσ0 : -(1 / 4) ≤ σ) (hσ : σ ≠ 0) {α β : ℂ}
    (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ} (hx : 0 < x) (t₀ : ℝ) :
    HasDerivAt (fun t => VY1 α β σ x t) (VY2 α β σ x t₀) t₀ :=
```

```
theorem iteratedDeriv_VY {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) {x : ℝ}
    (hx : 0 < x) {c : ℝ} (hc : 0 < c) :
    iteratedDeriv 1 (fun t => VY α β c x t) = (fun t => VY1 α β c x t) ∧
      iteratedDeriv 2 (fun t => VY α β c x t) = (fun t => VY2 α β c x t) :=
```

```
theorem VY_deriv_bound {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ t : ℝ, 1 ≤ t → ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c → ∀ j : ℕ, 1 ≤ j → j ≤ 2 →
        ‖(t : ℂ) ^ j * iteratedDeriv j (fun t => VY α β c x t) t‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) :=
```

