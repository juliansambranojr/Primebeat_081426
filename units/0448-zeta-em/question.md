> Source: session transcript, 2026-11-23

> Prove Carlson's bound ourselves, which is a large project



From `lean_stage3/Stage3/ZetaEM.lean`, the pinned statements:

```
theorem zeta_eq_em {k : ℕ} (hk : 1 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 0 < s.re)
    (hs1 : s ≠ 1) :
    riemannZeta s = ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) - (N:ℂ) ^ (1 - s) / (1 - s)
      - (N:ℂ) ^ (-s) / 2 + emBoundary k N s + emRem k N s :=
```

```
theorem norm_remainder_le (k : ℕ) {N : ℕ} (hN : 0 < N) {s : ℂ} (hs : 1 < s.re + k) :
    ‖emRem k N s‖ ≤ (∏ i ∈ Finset.range k, ‖s + i‖) / k.factorial
      * (bernBound k * ((N:ℝ) ^ (1 - s.re - k) / (s.re + k - 1))) :=
```

```
theorem norm_zeta_sub_partial_le (k : ℕ) (hk : 2 ≤ k) {N : ℕ} (hN : 0 < N) {s : ℂ}
    (hσ : 0 < s.re) (hs1 : s ≠ 1) (hsN : ‖s‖ + k ≤ N) :
    ‖riemannZeta s - ∑ n ∈ Finset.Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)‖
      ≤ emConst k * (N : ℝ) ^ (-s.re) * (1 + (‖s‖ + k) ^ k * (N : ℝ) ^ (1 - (k : ℝ))) :=
```

