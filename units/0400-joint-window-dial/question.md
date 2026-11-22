> Source: session transcript, 2026-11-22, after SECTIONS.md was written

> Go

From the assistant's message before it: "Ready for joint 1 when you are."

From `lean_stage3/Stage3/JointWindowDial.lean`, the pinned statements:

```
theorem zeroFreeRight_of_window {θ δ C : ℝ} (hθ0 : 0 < θ) (hθ1 : θ < 1)
    (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
    Stage3.StmtZeroFreeRight θ :=
```

```
theorem schoenfeldWeakTheta_of_window {θ δ C : ℝ} (hθlo : 1 / 2 ≤ θ)
    (hθ1 : θ < 1) (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C) :
    ∃ C' > 0, ∃ x₀ : ℝ, Stage3.StmtSchoenfeldWeakTheta θ C' 2 x₀
      (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li :=
```
