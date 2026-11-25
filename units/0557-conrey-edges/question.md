> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/DigammaBound.lean`, the pinned statements:

```
theorem right_edge_ge (Q : ℝ[X]) (hQ0 : Q.eval 0 = 1) {B T t : ℝ} (hB : 0 < B)
    (hBr : ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
      1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
      T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
      ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B)
    (hT : 200 ≤ T) (hL : 8 + 400 * KQ Q * B ≤ Real.log T) (ht : t ∈ Icc (T / 4) (2 * T)) :
    1 / 3 ≤ (ConreyCount.V Q (Real.log T) (3 + t * I)).re :=
```

```
theorem disc_le (Q : ℝ[X]) {B T t : ℝ} (hB : 0 < B)
    (hBr : ∀ T : ℝ, 16 ≤ T → ∀ z w : ℂ,
      1 / 4 ≤ z.re → z.re ≤ 7 → 1 / 4 ≤ w.re → w.re ≤ 7 →
      T / 8 ≤ z.im → z.im ≤ 3 * T → T / 8 ≤ w.im → w.im ≤ 3 * T → |z.im - w.im| ≤ 1 →
      ‖Gammaℝ z‖ / ‖Gammaℝ w‖ * Real.exp (-(Real.log T / 2) * (z.re - w.re)) ≤ B)
    (hT : 200 ≤ T) (hL : 8 ≤ Real.log T) (ht : t ∈ Icc (T / 4) (2 * T)) :
    ConreyCount.StmtVDisc Q (Real.log T) t (5 * KQ Q * B * t) :=
```

```
theorem stmtVEdges_holds (Q : ℝ[X]) (hQ0 : Q.eval 0 = 1) :
    ∃ A T₀ : ℝ, 0 < A ∧ ∀ T ≥ T₀, ConreyCount.StmtVEdges Q T A :=
```

