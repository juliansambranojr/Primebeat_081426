> Source: session transcript, 2026-11-23

> Yes and are you going to fix 1, 2, 3 and 4 on the list you just named too?



From `lean_stage3/Stage3/SieveResidual.lean`, the pinned statements:

```
theorem net_wobble (N : ℕ) (hN : 2 ≤ N) :
    ((netRounding N : ℚ) : ℝ) - smoothNet N
      = -(((Nat.primeCounting N : ℝ) - Stage3.Li (N : ℝ))
          - ((Nat.primeCounting (Nat.sqrt N) : ℝ) - Stage3.Li ((Nat.sqrt N : ℕ) : ℝ))) :=
```

```
theorem net_wobble_rows (m : ℕ) (hm : 1 ≤ m) :
    ((netRounding (2 ^ (2 * m)) : ℚ) : ℝ) - smoothNet (2 ^ (2 * m))
      = -(((Nat.primeCounting (2 ^ (2 * m)) : ℝ) - Stage3.Li (((2 ^ (2 * m) : ℕ) : ℝ)))
          - ((Nat.primeCounting (2 ^ m) : ℝ) - Stage3.Li (((2 ^ m : ℕ) : ℝ)))) :=
```

