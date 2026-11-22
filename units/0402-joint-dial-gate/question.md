> Source: session transcript, 2026-11-22, after unit 0401

> Let's keep going

From `lean_stage3/Stage3/JointDialGate.lean`, the definition and the pinned statements:

```
def StmtRelErrWindow (f L : ℤ → ℝ) (r : ℤ) (n : ℕ) (ρ : ℝ) : Prop :=
  ∀ k ∈ range (n + 1),
    |f (r - k) - L (r - k)| ≤ ρ * (2 : ℝ) ^ ((r : ℝ) - k)
```

```
theorem powerSaving_relErr {f L : ℤ → ℝ} {r : ℤ} {n : ℕ} {A θ : ℝ}
    (hA : 0 ≤ A) (hθ : θ ≤ 1)
    (hP : ∀ k ∈ range (n + 1),
      |f (r - k) - L (r - k)| ≤ A * ((2 : ℝ) ^ ((r : ℝ) - k)) ^ θ) :
    StmtRelErrWindow f L r n (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ - 1))) := by
```

```
theorem relErrWindow_of_window {θ δ C₀ θ' : ℝ} (hθlo : 1 / 2 ≤ θ) (hθ1 : θ < 1)
    (hδ : 0 < δ) (hW : LandauWindow.WindowBound θ δ C₀) (hθ : θ < θ') (hθ' : θ' ≤ 1) :
    ∃ A x₀ : ℝ, 0 ≤ A ∧ ∀ (r : ℤ) (n : ℕ), x₀ ≤ (2 : ℝ) ^ ((r : ℝ) - n) →
      0 ≤ (r : ℝ) - n →
      StmtRelErrWindow
        (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
        (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r n
        (A * (2 : ℝ) ^ (((r : ℝ) - n) * (θ' - 1))) := by
```
