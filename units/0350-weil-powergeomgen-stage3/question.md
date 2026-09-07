> Source: session transcript, 2026-09-06, the task given to this run

> Build one Lean module under the repo's module loop: block 13e of lean_stage3/design/rung5.md, module lean_stage3/Stage3/WeilPowerGeomGen.lean, and commit it through the pre-commit gate with its unit.

From `lean_stage3/Stage3/WeilPowerGeomGen.lean`, the definitions:

```
def MabGen (z : ℂ) (α β₀ : ℝ) (a b : ℕ) : ℝ :=
  max (Real.exp (z.re * (α * (a : ℝ) + β₀))) (Real.exp (z.re * (α * (b : ℝ) + β₀)))
```

```
def geomBoundGen (z : ℂ) (α β₀ : ℝ) (a b : ℕ) : ℝ :=
  (Real.exp (z.re * (α * (a : ℝ) + β₀)) + Real.exp (z.re * (α * (b : ℝ) + β₀))) * Real.pi
    / (2 * Real.exp (z.re * α) * z.im * α)
```

```
def uLam (lam h : ℕ) : ℝ := ((h : ℝ)) ^ 2 * WeilPowerPhase.sigma (lam * h - 1)
```

and the pinned statements:

```
theorem norm_geom_le_gen {z : ℂ} {α β₀ : ℝ} (hα : 0 < α) (hz1 : 0 < z.im)
    (hz3 : z.im * α ≤ Real.pi / 2) {a b : ℕ} (hab : a ≤ b) :
    ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
      ≤ geomBoundGen z α β₀ a b := by
```

```
theorem norm_corr_le_gen {z : ℂ} {α β₀ c : ℝ} {u : ℕ → ℝ} {a h : ℕ}
    (hzc : ‖z‖ * c ≤ (a : ℝ) + 1)
    (hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀)
      ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1))
    (hah : a ≤ h) :
    ‖Complex.exp (z * (u h : ℂ)) - Complex.exp (z * ((α * (h : ℝ) + β₀ : ℝ) : ℂ))‖
      ≤ Real.exp (z.re * (α * (h : ℝ) + β₀)) * (2 * ‖z‖) * (c / ((h : ℝ) + 1)) := by
```

```
theorem norm_sum_exp_u_le_gen {z : ℂ} {α β₀ c : ℝ} {u : ℕ → ℝ} {a b : ℕ}
    (hα : 0 < α) (hz1 : 0 < z.im) (hz3 : z.im * α ≤ Real.pi / 2)
    (ha : 1 ≤ a) (hab : a ≤ b) (hzc : ‖z‖ * c ≤ (a : ℝ) + 1)
    (hu : ∀ k : ℕ, 0 ≤ u k - (α * (k : ℝ) + β₀)
      ∧ u k - (α * (k : ℝ) + β₀) ≤ c / ((k : ℝ) + 1)) :
    ‖∑ h ∈ Finset.Ico a b, Complex.exp (z * (u h : ℂ))‖
      ≤ geomBoundGen z α β₀ a b
        + 2 * ‖z‖ * c * MabGen z α β₀ a b * (Real.log b - Real.log a) := by
```

```
theorem uLam_bracket {lam h : ℕ} (hl : 1 ≤ lam) (hh : 1 ≤ h) :
    0 ≤ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
        - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
      ∧ uLam lam h - ((h : ℝ) / ((lam : ℝ) * Real.pi ^ 2)
          - 1 / (2 * (lam : ℝ) ^ 2 * Real.pi ^ 2))
        ≤ 1 / (2 * (lam : ℝ) ^ 3 * Real.pi ^ 2) / ((h : ℝ) + 1) := by
```
