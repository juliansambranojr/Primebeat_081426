> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonTurn.lean`, the pinned statements:

```
theorem lift_turn_eq_integral {F F' : ℝ → ℂ} {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hFc : ContinuousOn F (Set.Icc a b))
    (hF : ∀ t ∈ Set.Ioo a b, HasDerivAt F (F' t) t)
    (hF'c : ContinuousOn F' (Set.Icc a b))
    (hne : ∀ t ∈ Set.Icc a b, F t ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, F t = ‖F t‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, F' t / F t).im :=
```

```
theorem line_turn_eq_integral {f : ℂ → ℂ} {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hf : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ f (1/2 + t * I))
    (hne : ∀ t ∈ Set.Icc a b, f (1/2 + t * I) ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b,
      f (1/2 + t * I) = ‖f (1/2 + t * I)‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, logDeriv f (1/2 + t * I)).re :=
```

```
theorem turn_split {G : ℂ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hG : ∀ t ∈ Set.Icc a b, AnalyticAt ℂ G (1/2 + t * I))
    (hne : ∀ t ∈ Set.Icc a b, G (1/2 + t * I) ≠ 0) :
    (∫ t in a..b, logDeriv (fun s => Gammaℝ s * G s) (1/2 + t * I)).re =
      (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re +
        (∫ t in a..b, logDeriv G (1/2 + t * I)).re :=
```

```
theorem lineF_turn_eq {c a b : ℝ} {φ : ℝ → ℝ} (hab : a ≤ b)
    (hne : ∀ t ∈ Set.Icc a b,
      riemannZeta (1/2 + t * I) + c * deriv riemannZeta (1/2 + t * I) ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b,
      LevinsonArg.lineF c t = ‖LevinsonArg.lineF c t‖ * Complex.exp (φ t * Complex.I)) :
    φ b - φ a = (∫ t in a..b, logDeriv Gammaℝ (1/2 + t * I)).re +
      (∫ t in a..b, logDeriv (fun s => riemannZeta s + c * deriv riemannZeta s)
        (1/2 + t * I)).re :=
```

```
theorem countRight_left_eq {f : ℂ → ℂ} {z w : ℂ} (hre : z.re < w.re) (him : z.im < w.im)
    (hf : AnalyticOnNhd ℂ f (Rectangle z w))
    (hB : ∀ p ∈ RectangleBorder z w, f p ≠ 0) :
    Littlewood.countRight f z w z.re =
      ∑ p ∈ (divisor_support_rectangle_finite f z w).toFinset,
        ((MeromorphicOn.divisor f (Rectangle z w) p : ℤ) : ℝ) :=
```

```
theorem G_turn_eq {G : ℂ → ℂ} {a b X : ℝ} (hX : 1/2 < X) (hab : a < b)
    (hG : AnalyticOnNhd ℂ G (Rectangle ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I)))
    (hB : ∀ p ∈ RectangleBorder ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I), G p ≠ 0) :
    (∫ t in a..b, logDeriv G (1/2 + t * I)).re =
      -(2 * Real.pi * Littlewood.countRight G ((1/2 : ℂ) + a * I) ((X : ℂ) + b * I) (1/2))
      + (∫ x in (1/2 : ℝ)..X, logDeriv G (↑x + ↑a * I)).im
      - (∫ x in (1/2 : ℝ)..X, logDeriv G (↑x + ↑b * I)).im
      + (∫ t in a..b, logDeriv G (↑X + ↑t * I)).re :=
```

