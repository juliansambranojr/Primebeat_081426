> Source: session transcript, 2026-11-24

> Prove to me it does all the way out please



From `lean_stage3/Stage3/NoHoles.lean`, the pinned statements:

```
theorem moebius_floor_inversion (f : ℕ → ℝ) {N : ℕ} (hN : 1 ≤ N) :
    ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * ∑ j ∈ Icc 1 (N / k), f (N / k / j) = f N :=
```

```
theorem psi_floor (N k : ℕ) :
    Chebyshev.psi ((N : ℝ) / (k : ℝ)) = Chebyshev.psi ((N / k : ℕ) : ℝ) :=
```

```
theorem psi_by_integers (N : ℕ) (hN : 1 ≤ N) :
    Chebyshev.psi (N : ℝ)
      = ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * ∑ n ∈ Icc 1 (N / k), Real.log (n : ℝ) :=
```

```
theorem log_factorial_close {M : ℕ} (hM : 1 ≤ M) :
    |∑ n ∈ Icc 1 M, Real.log (n : ℝ) - ((M : ℝ) * Real.log (M : ℝ) - (M : ℝ))|
      ≤ Real.log (M : ℝ) + 1 :=
```

```
theorem holes_resid (N : ℕ) (hN : 1 ≤ N) :
    Chebyshev.psi (N : ℝ)
      = ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * S (N / k)
        + ∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * e (N / k) :=
```

```
theorem holes_err_trivial (N : ℕ) :
    |∑ k ∈ Icc 1 N, ((moebius k : ℤ) : ℝ) * e (N / k)| ≤ ∑ k ∈ Icc 1 N, |e (N / k)| :=
```

