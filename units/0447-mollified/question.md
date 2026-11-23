> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/Mollified.lean`, the pinned statements:

```
theorem prod_eq_sum (s : ℂ) (N X : ℕ) :
    (∑ m ∈ Icc 1 N, (m : ℂ) ^ (-s)) *
        (∑ d ∈ Ico 1 X, (ArithmeticFunction.moebius d : ℂ) * (d : ℂ) ^ (-s)) =
      ∑ n ∈ Icc 1 (N * X), (coef X N n : ℂ) * (n : ℂ) ^ (-s) :=
```

```
theorem sum_coef_sq_le (X N Y : ℕ) :
    ∑ n ∈ Icc 1 Y, (coef X N n : ℝ) ^ 2 ≤ Y * (1 + Real.log X) ^ 3 :=
```

```
theorem sum_coef_sq_weighted_le (u : ℝ) (hu : 1 / 2 < u) (X N Y : ℕ) (hX : 1 ≤ X) :
    ∑ n ∈ Icc X Y, (coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (-2 * u) ≤
      2 / (1 - (2 : ℝ) ^ (1 - 2 * u)) * (X : ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3 :=
```

