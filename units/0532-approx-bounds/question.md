> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/ApproxBounds.lean`, the pinned statements:

```
theorem gamma_shift {x₁ x₂ : ℝ} (h1 : 0 < x₁) (h12 : x₁ ≤ x₂) (Y : ℝ) :
    (x₂ - x₁) * (LY Y x₂ / 2) ≤ lg x₂ Y - lg x₁ Y ∧
      lg x₂ Y - lg x₁ Y ≤ (x₂ - x₁) * (fY Y x₁ + LY Y x₁ / 2) :=
```

```
theorem log_norm_Gamma_approx {z : ℂ} (hz : 0 < z.re) :
    |Real.log ‖Complex.Gamma z‖ - gModel z.re z.im| ≤ gErr z.re :=
```

```
theorem log_norm_Gammaℝ_approx {w : ℂ} (hw : 0 < w.re) :
    |Real.log ‖Gammaℝ w‖ - gRModel w| ≤ gErr (w.re / 2) :=
```

```
theorem XY_log :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      |Real.log ‖XY α β t‖ - (α + β).re * (Real.log Real.pi - Real.log (t / 2))| ≤ K :=
```

```
theorem XY_size :
    ∃ C : ℝ, 0 < C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ‖XY α β t‖ ≤ C * (t / (2 * Real.pi)) ^ (-(α + β).re) ∧
        (t / (2 * Real.pi)) ^ (-(α + β).re) ≤ C * ‖XY α β t‖ :=
```

```
theorem gY_bound {σ₀ σ₁ : ℝ} (h0 : -(2 / 5) < σ₀) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ →
        ‖gY α β t (σ + y * I)‖ ≤ C * (t / (2 * Real.pi)) ^ σ *
          Real.exp ((Real.pi / 2 + (|σ₀| + |σ₁|) / 2 + 1 / 2) * |y|) :=
```

```
theorem integrand_bound {σ₀ σ₁ δ : ℝ} (h0 : -(2 / 5) < σ₀) (hδ : 0 < δ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ σ y : ℝ, σ₀ ≤ σ → σ ≤ σ₁ → δ ≤ ‖(σ : ℂ) + y * I‖ →
        ‖KY α β t (σ + y * I) * (x : ℂ) ^ (-((σ : ℂ) + y * I))‖ ≤
          C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) *
            Real.exp (-(1 / 2) * y ^ 2) :=
```

```
theorem VY_line_bound {σ : ℝ} (h0 : -(2 / 5) < σ) (hσ : σ ≠ 0) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x →
        ‖VY α β σ x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * ((t / (2 * Real.pi)) ^ σ * x ^ (-σ)) :=
```

```
theorem VY_line_eq {c c' : ℝ} (hc : 0 < c) (hcc : c ≤ c') {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10)
    (hβ : ‖β‖ ≤ 1 / 10) {t : ℝ} (ht : 1 ≤ t) {x : ℝ} (hx : 0 < x) :
    VY α β c x t = VY α β c' x t :=
```

```
theorem VY_residue {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0)
    {t : ℝ} (ht : 1 ≤ t) {x : ℝ} (hx : 0 < x) :
    VY α β (1 / 4) x t - VY α β (-(1 / 4)) x t = 1 :=
```

```
theorem VY_decay {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖VY α β c x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (t / x) ^ A :=
```

```
theorem VY_decay_young {A : ℝ} (hA : 0 < A) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 → ∀ t : ℝ, 1 ≤ t →
      ∀ x : ℝ, 0 < x → ∀ c : ℝ, 0 < c →
        ‖VY α β c x t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * (1 + x / t) ^ (-A) :=
```

```
theorem resY_small :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ α β : ℂ, ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → ∀ t : ℝ, 1 ≤ t →
      ‖resY α β t‖ ≤ C * (1 + 1 / ‖α + β‖ ^ 2) * Real.exp (-(t ^ 2 / 2)) :=
```

