> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/MollifiedMean.lean`, the pinned statements:

```
theorem sum_coef_sq_up_le (u : ℝ) (hu : 1 / 2 < u) (X N Y : ℕ) :
    ∑ n ∈ Icc 1 Y, (Mollified.coef X N n : ℝ) ^ 2 * (n : ℝ) ^ (1 - 2 * u) ≤
      4 * (1 + Real.log X) ^ 3 * (1 + Real.log Y) * max 1 ((Y : ℝ) ^ (2 - 2 * u)) :=
```

```
theorem mean_sq_main_le {X N : ℕ} (hX : 1 ≤ X) {u T : ℝ} (hu : 1 / 2 < u) (hT : 1 ≤ T) :
    ∫ t in (1:ℝ)..T,
        ‖∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-((u : ℂ) + Complex.I * (t : ℂ)))‖ ^ 2
      ≤ T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3
        + 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3
            * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u)) :=
```

```
theorem mean_sq_f_le (k : ℕ) (hk : 2 ≤ k) {X N : ℕ} (hX : 2 ≤ X) (hXN : X ≤ N) {u T : ℝ}
    (hu : 1 / 2 < u) (hu2 : u ≤ 2) (hT : 1 ≤ T) (hTN : T + 3 + k ≤ N) :
    ∫ t in (1:ℝ)..T, ‖f X ((u : ℂ) + Complex.I * (t : ℂ))‖ ^ 2
      ≤ 3 * (T * (2 / (1 - (2:ℝ) ^ (1 - 2 * u))) * (X:ℝ) ^ (1 - 2 * u) * (1 + Real.log X) ^ 3
            + 24 * (1 + Real.log ((N * X : ℕ) : ℝ)) ^ 2 * (1 + Real.log X) ^ 3
                * max 1 (((N * X : ℕ) : ℝ) ^ (2 - 2 * u))
            + (X:ℝ) ^ 2 * (N:ℝ) ^ (2 - 2 * u)
            + T * (X:ℝ) ^ 2 * ZetaEM.emConst k ^ 2 * (N:ℝ) ^ (-2 * u)
                * (1 + (T + 2 + k) ^ k * (N:ℝ) ^ (1 - (k:ℝ))) ^ 2) :=
```

