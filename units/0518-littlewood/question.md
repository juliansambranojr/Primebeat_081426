> Source: session transcript, 2026-11-24

> Go



From `lean_stage3/Stage3/Littlewood.lean`, the pinned statements:

```
theorem littlewood_rect {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    2 * Real.pi * ∑ ρ ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) ρ : ℤ) : ℝ) * (ρ.re - z.re)
      = (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) :=
```

```
theorem littlewood_rect_zero_free {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hnz : ∀ p ∈ Rectangle z w, f p ≠ 0) :
    (∫ t in z.im..w.im, Real.log ‖f (↑z.re + ↑t * I)‖)
        - (∫ t in z.im..w.im, Real.log ‖f (↑w.re + ↑t * I)‖)
        + (w.re - z.re) * (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
        + (∫ σ in z.re..w.re, edgeH f w.re z.im σ)
        - (∫ σ in z.re..w.re, edgeH f w.re w.im σ) = 0 :=
```

```
theorem integral_countRight {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    ∫ σ in z.re..w.re, countRight f z w σ =
      ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) * (p.re - z.re) :=
```

```
theorem two_pi_count_eq {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) {σ : ℝ} (hσ : σ ∈ Icc z.re w.re)
    (hgood : ∀ p ∈ (divisor_support_rectangle_finite f z w).toFinset, p.re ≠ σ) :
    2 * Real.pi * countRight f z w σ =
      (∫ x in σ..w.re, logDeriv f (↑x + ↑z.im * I)).im
      - (∫ x in σ..w.re, logDeriv f (↑x + ↑w.im * I)).im
      + (∫ t in z.im..w.im, logDeriv f (↑w.re + ↑t * I)).re
      - (∫ t in z.im..w.im, logDeriv f (↑σ + ↑t * I)).re :=
```

```
theorem integrableOn_logDeriv {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hfin : ∀ p ∈ Rectangle z w, meromorphicOrderAt f p ≠ ⊤) :
    IntegrableOn (logDeriv f) (Rectangle z w) volume :=
```

```
theorem integral_re_logDeriv_horizontal {z w : ℂ} (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    {t : ℝ} (ht : t ∈ [[z.im, w.im]]) (hnz : ∀ x ∈ [[z.re, w.re]], f (↑x + ↑t * I) ≠ 0) :
    ∫ x in z.re..w.re, (logDeriv f (↑x + ↑t * I)).re
      = Real.log ‖f (↑w.re + ↑t * I)‖ - Real.log ‖f (↑z.re + ↑t * I)‖ :=
```

