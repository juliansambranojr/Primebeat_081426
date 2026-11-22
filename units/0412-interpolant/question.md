> Source: session transcript, 2026-11-22, after PR 6 merged

> the route's constants as numerals, the smooth interpolant the gate theorems assume,

From `lean/Interpolant.lean`, the definitions and three of the pinned statements:

```
/-- The antiderivative of `2^x/x` through the value `2/log 2` at `x = 1`. -/
def F (x : ℝ) : ℝ := 2 / Real.log 2 + ∫ t in (1 : ℝ)..x, Expansion.f2x t

/-- The interpolant: `F` cut off smoothly below one half. -/
def liRow (x : ℝ) : ℝ := Real.smoothTransition (4 * x - 1) * F x
```

```
theorem liRow_contDiff : ContDiff ℝ (⊤ : ℕ∞) liRow
```

```
theorem liRow_hasDerivAt {x : ℝ} (hx : x ∈ Ioi ((1 : ℝ) / 2)) :
    HasDerivAt liRow (Expansion.f2x x) x
```

```
theorem tableFrom_ne_zero_of_relErr_liRow {N : ℤ → ℤ} {f : ℤ → ℝ}
    {r : ℤ} {d : ℕ} {ρ : ℝ}
    (hrow : ∀ k ∈ Finset.range (d + 2),
      ((N (r - k) : ℤ) : ℝ) = Nonvanishing.bdiffZ f (r - k))
    (hS : RelativeGate.StmtRelErrWindow f (fun k : ℤ => liRow k) r (d + 1) ρ)
    (hbot : (1 : ℝ) ≤ (r : ℝ) - (d + 1))
    (hw : 2 * (d : ℝ) ≤ Real.log 2 * ((r : ℝ) - (d + 1)))
    (hρ : ρ < Real.log 2 ^ d / (2 * r * 3 ^ (d + 1))) :
    Construction.tableFrom N r d ≠ 0
```

