> Source: session transcript, 2026-11-23

> It holds because it is bounded by itself and never more or that wouldn't be the same number line.



From `lean_stage3/Stage3/SelfBound.lean`, the pinned statements:

```
theorem log_sum_eq (N : ℕ) :
    ∑ n ∈ Icc 1 N, Real.log (n : ℝ) = ∑ d ∈ Icc 1 N, vonMangoldt d * ((N / d : ℕ) : ℝ) :=
```

```
theorem self_bound (N : ℕ) :
    ∑ k ∈ Icc 1 N, Chebyshev.psi ((N : ℝ) / (k : ℝ)) = ∑ n ∈ Icc 1 N, Real.log (n : ℝ) :=
```

```
theorem self_bound_resid (N : ℕ) :
    ∑ k ∈ Icc 1 N, (Chebyshev.psi ((N : ℝ) / (k : ℝ)) - (N : ℝ) / (k : ℝ))
      = ∑ n ∈ Icc 1 N, Real.log (n : ℝ) - (N : ℝ) * ∑ k ∈ Icc 1 N, 1 / (k : ℝ) :=
```

