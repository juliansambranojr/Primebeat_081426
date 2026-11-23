> Source: session transcript, 2026-11-23

> Half is the difference that anything is differentiated at all



From `lean_stage3/Stage3/HalfSieve.lean`, the pinned statements:

```
theorem ignition_is_zeta_zero (n : ℕ) :
    ((ClosedLoopChain.Midpoint n : ℚ) : ℂ) - ((2 : ℂ) ^ n - 1) = - riemannZeta 0 :=
```

```
theorem netRounding_centered {N : ℕ} (hN : 4 ≤ N) :
    netRounding N = ∑ T ∈ (smallPrimes N).powerset,
      (-1 : ℚ) ^ T.card * (Int.fract ((N : ℚ) / ((∏ p ∈ T, p : ℕ) : ℚ)) - 1 / 2) :=
```

```
theorem resid_of_wobble {C : ℝ} (hC : 0 ≤ C)
    (h : ∀ N : ℕ, 2 ≤ N → |wobble N| ≤ C * Real.sqrt (N : ℝ) * Real.log (N : ℝ)) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ N : ℕ, 2 ≤ N →
      |resid N| ≤ K * Real.sqrt (N : ℝ) * Real.log (N : ℝ) :=
```

```
theorem spiralLink_iff_wobble : SpiralLink.SpiralLink ↔ WobbleSqrt :=
```

