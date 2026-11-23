> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/SquareMean.lean`, the pinned statements:

```
theorem sq_mean_lower {f : ℂ → ℂ} {c : ℂ} {δ : ℝ} (hδ : 0 < δ) {U : Set ℂ} (hU : IsOpen U)
    (hsub : (Icc (c.re - δ) (c.re + δ)) ×ℂ (Icc (c.im - δ) (c.im + δ)) ⊆ U)
    (hf : DifferentiableOn ℂ f U) :
    π * δ ^ 2 * ‖f c‖ ^ 2
      ≤ ∫ u in (c.re - δ)..(c.re + δ), ∫ t in (c.im - δ)..(c.im + δ),
          ‖f ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2 :=
```

