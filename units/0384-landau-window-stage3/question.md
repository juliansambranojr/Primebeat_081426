> Source: session transcript, 2026-11-22, after reading Alpöge's note and archive

> Do 2 with 1 alongside

2, from the assistant's message before it: "Formalize the criterion in Stage 3 from scratch, as your own Landau-type theorem."

From `lean_stage3/Stage3/LandauWindow.lean`, the leaf and the pinned statement:

```
def StmtLandauWindow : Prop :=
  ∀ θ δ C : ℝ, 0 < θ → θ < 1 → 0 < δ → WindowBound θ δ C →
    ∀ s : ℂ, θ < s.re → riemannZeta s ≠ 0
```

```
theorem rh_of_window (hL : StmtLandauWindow)
    (hW : ∀ θ : ℝ, 1 / 2 < θ → θ < 1 → ∃ δ C : ℝ, 0 < δ ∧ WindowBound θ δ C) :
    RiemannHypothesis :=
```
