> Source: session transcript, 2026-11-23

> Not yet, prove



From `lean_stage3/Stage3/Readings.lean`, the pinned statements:

```
theorem half_rung_ratio (k : ℝ) :
    ((2 : ℝ) ^ (k / 2) - 2 ^ ((k - 1) / 2)) / 2 ^ (k / 2) = 1 - 1 / Real.sqrt 2 :=
```

```
theorem half_regime_shares (n : ℕ) :
    (Real.sqrt 2 * 2 ^ n - 2 ^ n) / 2 ^ n = Real.sqrt 2 - 1 ∧
      (2 ^ (n + 1) - Real.sqrt 2 * 2 ^ n) / (2 : ℝ) ^ n = 2 - Real.sqrt 2 :=
```

```
theorem net_is_sum_of_steps {D P : Finset ℕ} (g : ℕ → ℕ) (hg : ∀ d ∈ D, g d ∈ P)
    (f : ℕ → ℝ) :
    ∑ d ∈ D, f d = ∑ p ∈ P, ∑ d ∈ D.filter (fun d => g d = p), f d :=
```

```
theorem paper_lemma_zero (ε : ℝ) : |(2.5 : ℝ) - (6 * ε + 0.5)| = 0 ↔ ε = 1 / 3 :=
```

```
theorem paper_mid_rec (k : ℕ) : paperMid (k + 1) = 2 * paperMid k + 1 / 2 :=
```

```
theorem iv_exact (ρ : NontrivialZeros) (h : (ρ : ℂ).re ≠ 1 / 2) : ¬ Saddle.NoRunaway :=
```

```
theorem wire_holds_iff : SpiralLink.SpiralLink ↔ Saddle.NoRunaway :=
```

