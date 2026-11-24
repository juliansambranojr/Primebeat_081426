> Source: session transcript, 2026-11-24

> Ok, let's try it. It's possible



From `lean_stage3/Stage3/Doubling.lean`, the pinned statements:

```
theorem alt_scales (N : ℕ) :
    ∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * Chebyshev.psi ((N : ℝ) / (k : ℝ))
      = ∑ n ∈ Icc 1 N, Real.log n - 2 * ∑ n ∈ Icc 1 (N / 2), Real.log n :=
```

```
theorem alt_harmonic {N : ℕ} (hN : 1 ≤ N) :
    |∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) / (k : ℝ) - Real.log 2| ≤ 1 / (N : ℝ) :=
```

```
theorem alt_resid_small {N : ℕ} (hN : 2 ≤ N) :
    |∑ k ∈ Icc 1 N, (-1 : ℝ) ^ (k + 1) * (Chebyshev.psi ((N : ℝ) / (k : ℝ)) - (N : ℝ) / (k : ℝ))|
      ≤ 4 * Real.log N + 5 :=
```

