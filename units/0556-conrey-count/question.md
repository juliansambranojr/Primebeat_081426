> Source: session transcript, 2026-11-25

> Yes to all



From `lean_stage3/Stage3/ConreyCount.lean`, the pinned statements:

```
theorem conrey_count_sub {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {L a b M : ℝ} (ha : 4 ≤ a) (hab : a < b)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q L (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0)
    (hR : StmtVRight Q L a b) (hMa : StmtVDisc Q L a M) (hMb : StmtVDisc Q L b M) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (V Q L) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (30 * Real.log b + 42 * Real.log (3 * M) + 154)
        ≤ (lineCount b : ℝ) - (lineCount a : ℝ) :=
```

```
theorem conrey_count_window {Q : ℝ[X]}
    (hQ : ∀ x : ℝ, Q.derivative.eval x = Q.derivative.eval (1 - x))
    (hQh : Q.eval (1/2) ≠ 0) {T A a b : ℝ} (hA : 0 < A)
    (hTa : T / 4 ≤ a) (ha : 4 ≤ a) (hab : a < b) (hbT : b ≤ 2 * T)
    (hE : StmtVEdges Q T A)
    (hBot : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q (Real.log T) (↑x + ↑a * I) ≠ 0)
    (hTop : ∀ x ∈ Icc (1/2 : ℝ) 3, V Q (Real.log T) (↑x + ↑b * I) ≠ 0)
    (hζa : riemannZeta (1/2 + a * I) ≠ 0) :
    (riemannZeta.N b - riemannZeta.N a)
      - 2 * Littlewood.countRight (V Q (Real.log T)) ((1/2 : ℂ) + a * I) ((3 : ℂ) + b * I) (1/2)
      - (72 * Real.log b + 42 * Real.log (3 * A) + 154)
        ≤ (lineCount b : ℝ) - (lineCount a : ℝ) :=
```

