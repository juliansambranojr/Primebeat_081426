> Source: session transcript, 2026-09-06 to 2026-09-07, the first module built under the relay

> What I’m thinking is that you design the blocks. Opus executes at first pass. Then hands off the lean to you and you finish it. Then you signal to opus it’s done and he calls the checkers and you write the units.

> Go

> done, resume at § 5.

From `lean_stage3/Stage3/WeilPowerShell.lean`, the four pinned statements:

```
theorem uSh_bracket {lam : ℕ} (hl : 1 ≤ lam) :
```

```
theorem geomBound_le {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h3 : 0 < D)
```

```
theorem shellSum_le {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (h3 : 0 < D) (h4 : D ≤ 1 / 2) (h5 : 0 < e) (h6 : e ≤ 1 / 2)
    (h7 : e' ^ 2 - D ^ 2 - e ^ 2 ≤ eta) (h8 : 0 ≤ eta) (hl : 1 ≤ lam) (ha : 1 ≤ a)
    (hab : a ≤ b) :
    |shellSum e' D e lam a b|
      ≤ (e' ^ 2 + D ^ 2) / e ^ 2 * Real.exp (2 * eta * (b : ℝ) / ((lam : ℝ) * Real.pi ^ 2))
        * ((lam : ℝ) * Real.pi ^ 3
              * Real.exp (2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (1 / ((lam : ℝ) * Real.pi ^ 2)))
              / (4 * e' * D)
            + 2 * (e' ^ 2 + D ^ 2 + e ^ 2) * (Real.log b - Real.log a)
              / ((lam : ℝ) ^ 3 * Real.pi ^ 2)) := by
```

```
theorem shellSum_le_abs {e' D e eta : ℝ} {lam a b : ℕ} (h1 : 0 < e') (h2 : e' ≤ 1 / 2)
    (hD0 : D ≠ 0) (h4 : |D| ≤ 1 / 2) (h5 : 0 < e) (h6 : e ≤ 1 / 2)
```
