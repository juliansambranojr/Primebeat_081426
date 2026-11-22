> Source: session transcript, 2026-11-22, after unit 0418

> Go on that

From the assistant's message before it: "Shall I go on to that, or stop the stretch here?"

From `lean_stage3/Stage3/RouteNum.lean`, the definition and the pinned statements:

```
def routeConst (x₀ : ℝ) : ℝ :=
  3 * floorConstSplit Glue.c1n Glue.c3n Glue.c4n 112 0 698 0 x₀ + 13
```

```
theorem relErrWindow_route_num (hRH : RiemannHypothesis) {x₀ : ℝ} (hx₀ : 16 ≤ x₀)
    (r : ℤ) (n : ℕ) (hbot : x₀ ^ 2 ≤ (2 : ℝ) ^ ((r : ℝ) - n)) :
    JointDialGate.StmtRelErrWindow
      (fun m : ℤ => (Nat.primeCounting ⌊(2 : ℝ) ^ (m : ℝ)⌋₊ : ℝ))
      (fun m : ℤ => 2 / Real.log 2
        + ∫ t in (1 : ℝ)..(m : ℝ), Real.exp (Real.log 2 * t) / t) r n
      (Stage3.routeConst x₀ * (Real.log 2 * r) ^ 1
        * (2 : ℝ) ^ (-(((r : ℝ) - n) / 2))) := by
```

```
theorem c1n_le : Glue.c1n ≤ 88216610000 := by
```

```
theorem c3n_le : Glue.c3n ≤ 15 := by
```

```
theorem c4n_le : Glue.c4n ≤ 6468930000 := by
```

