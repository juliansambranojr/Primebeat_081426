> Source: session transcript, 2026-11-22, after the reading of `The-Four-Zeros.md`, `The-Fold.md` and `Elephant.lean`

> This please "The statement I can now write is: RH holds if and only if the residual in every cell stays at square-root size as the table continues. One direction is provable with today's theorems. The other is joint 10"

From `lean_stage3/Stage3/CellResidual.lean`, the definitions and the pinned statements:

```
def resid (a : ℝ) (m : ℤ) : ℝ :=
  (Nat.primeCounting ⌊a * (2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ) - Stage3.Li (a * (2 : ℝ) ^ (m : ℝ))
```

```
def cellResid (a : ℝ) (r : ℤ) (d : ℕ) : ℝ := stencilR (d + 1) (resid a) r
```

```
def cellSize (r : ℤ) (d : ℕ) : ℝ :=
  (1 + (2 : ℝ) ^ (-(1 : ℝ) / 2)) ^ (d + 1) * ((r : ℝ) + 1) * (2 : ℝ) ^ ((r : ℝ) / 2)
```

```
def CellsSqrt (C : ℝ) (r₀ : ℤ) : Prop :=
  ∀ a ∈ Set.Icc (1 : ℝ) 2, ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
    |cellResid a r d| ≤ C * cellSize r d
```

```
theorem cells_of_schoenfeldWeak {C x₀ : ℝ} {r₀ : ℤ} (hC : 0 ≤ C) (hr₀ : 1 ≤ r₀)
    (hx₀ : x₀ ≤ (2 : ℝ) ^ (r₀ : ℝ))
    (h : StmtSchoenfeldWeak C 1 x₀ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li) :
    CellsSqrt (C * Real.sqrt 2 * Real.log 2) r₀ := by
```

```
theorem schoenfeldWeak_of_cells {C : ℝ} {r₀ : ℤ} (h : CellsSqrt C r₀) :
    ∃ C' x₁ : ℝ,
      StmtSchoenfeldWeak C' 1 x₁ (fun x => (Nat.primeCounting ⌊x⌋₊ : ℝ)) Stage3.Li := by
```

```
theorem RH_iff_cells : RiemannHypothesis ↔ ∃ (C : ℝ) (r₀ : ℤ), CellsSqrt C r₀ := by
```

```
theorem table_cell_eq (r : ℤ) (d : ℕ) :
    ((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
        - stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r
      = cellResid 1 r d := by
```

```
theorem table_cell_resid (hRH : RiemannHypothesis) :
    ∃ (C : ℝ) (r₀ : ℤ), ∀ (d : ℕ) (r : ℤ), r₀ + ((d + 1 : ℕ) : ℤ) ≤ r →
      |((Construction.tableFrom TableRoute.rowN r d : ℤ) : ℝ)
          - stencilR (d + 1) (fun m : ℤ => Stage3.Li ((2 : ℝ) ^ (m : ℝ))) r|
        ≤ C * cellSize r d := by
```
