> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonRight.lean`, the pinned statements:

```
theorem zeros_right_le {f : ℂ → ℂ} {z w : ℂ} {σ₁ : ℝ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    2 * Real.pi * (σ₁ - z.re) * countRight f z w σ₁
      ≤ (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) :=
```

```
theorem log_integral_le {g : ℝ → ℝ} {a b : ℝ} (hab : a < b)
    (hg : IntervalIntegrable g volume a b)
    (hlog : IntervalIntegrable (fun t => Real.log (g t)) volume a b)
    (hpos : ∀ t ∈ Icc a b, 0 < g t) :
    ∫ t in a..b, Real.log (g t) ≤ (b - a) * Real.log ((1 / (b - a)) * ∫ t in a..b, g t) :=
```

```
theorem log_integral_norm_le {F : ℂ → ℂ} {σ₀ a b : ℝ} (hab : a < b)
    (hc : ContinuousOn (fun t : ℝ => F (↑σ₀ + ↑t * I)) (Icc a b))
    (hnz : ∀ t ∈ Icc a b, F (↑σ₀ + ↑t * I) ≠ 0) :
    ∫ t in a..b, Real.log ‖F (↑σ₀ + ↑t * I)‖
      ≤ (b - a) / 2 * Real.log ((1 / (b - a)) * ∫ t in a..b, ‖F (↑σ₀ + ↑t * I)‖ ^ 2) :=
```

```
theorem countRight_mul_ge {G M : ℂ → ℂ} {z w : ℂ} (σ : ℝ)
    (hG : AnalyticOnNhd ℂ G (Rectangle z w)) (hM : AnalyticOnNhd ℂ M (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, G p * M p ≠ 0) :
    countRight G z w σ ≤ countRight (fun s => G s * M s) z w σ :=
```

```
theorem countRight_left_eq {f : ℂ → ℂ} {z z' w : ℂ} {σ : ℝ}
    (hzz : z.re ≤ z'.re) (hzσ : z'.re ≤ σ) (hzw : z'.re ≤ w.re) (him : z'.im = z.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w)) (hz : f z ≠ 0) :
    countRight f z' w σ = countRight f z w σ :=
```

```
theorem levinson_right {G M : ℂ → ℂ} {σ₀ X a b : ℝ} (hσ₀ : σ₀ < 1 / 2) (hX : 1 / 2 ≤ X)
    (hab : a < b)
    (hG : AnalyticOnNhd ℂ G (Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hM : AnalyticOnNhd ℂ M (Rectangle ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hB : ∀ p ∈ RectangleBorder ((σ₀ : ℂ) + a * I) ((X : ℂ) + b * I), G p * M p ≠ 0) :
    countRight G ((1 / 2 : ℂ) + a * I) ((X : ℂ) + b * I) (1 / 2)
      ≤ (1 / (2 * Real.pi * (1 / 2 - σ₀))) *
        ((b - a) / 2 * Real.log ((1 / (b - a)) *
            ∫ t in a..b, ‖G (↑σ₀ + ↑t * I) * M (↑σ₀ + ↑t * I)‖ ^ 2)
          - (∫ t in a..b, Real.log ‖G (↑X + ↑t * I) * M (↑X + ↑t * I)‖)
          + (X - σ₀) * (∫ t in a..b, logDeriv (fun s => G s * M s) (↑X + ↑t * I)).re
          + (∫ σ in σ₀..X, edgeH (fun s => G s * M s) X a σ)
          - (∫ σ in σ₀..X, edgeH (fun s => G s * M s) X b σ)) :=
```

