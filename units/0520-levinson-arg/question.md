> Source: session transcript, 2026-11-24

> Yes



From `lean_stage3/Stage3/LevinsonArg.lean`, the pinned statements:

```
theorem exists_arg_lift {F : ℝ → ℂ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn F (Set.Icc a b)) (hne : ∀ t ∈ Set.Icc a b, F t ≠ 0) :
    ∃ φ : ℝ → ℝ, ContinuousOn φ (Set.Icc a b) ∧
      ∀ t ∈ Set.Icc a b, F t = ‖F t‖ * Complex.exp (φ t * Complex.I) :=
```

```
theorem crossings_of_arg {φ : ℝ → ℝ} {a b : ℝ} (hab : a ≤ b)
    (hc : ContinuousOn φ (Set.Icc a b)) (k : ℕ)
    (hk : (k : ℝ) * Real.pi ≤ |φ b - φ a|) :
    ∃ t : Fin k → ℝ, StrictMono t ∧ (∀ i, t i ∈ Set.Icc a b) ∧
      ∀ i, Real.cos (φ (t i)) = 0 :=
```

```
theorem continuous_lineF (c : ℝ) : Continuous (lineF c) :=
```

```
theorem lineCount_ge_arg {c a b T : ℝ} {φ : ℝ → ℝ} {k : ℕ}
    (ha : 0 < a) (hab : a ≤ b) (hbT : b ≤ T)
    (hfac : ∀ t ∈ Set.Icc a b,
      1 - c * (deriv Gammaℝ (1/2 + t * I) / Gammaℝ (1/2 + t * I)).re ≠ 0)
    (hφc : ContinuousOn φ (Set.Icc a b))
    (hφ : ∀ t ∈ Set.Icc a b, lineF c t = ‖lineF c t‖ * Complex.exp (φ t * Complex.I))
    (hk : (k : ℝ) * Real.pi ≤ |φ b - φ a|) :
    (k : ℤ) ≤ lineCount T :=
```

