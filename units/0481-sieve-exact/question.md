> Source: session transcript, 2026-11-23

> The runs should be theorems.



From `lean_stage3/Stage3/SieveExact.lean`, the pinned statements:

```
theorem sieve_sum (N : ℕ) :
    ((survivors N).card : ℤ) =
      ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) :=
```

```
theorem pi_by_sieve (N : ℕ) (hN : 2 ≤ N) :
    (Nat.primeCounting N : ℤ) = (Nat.primeCounting (Nat.sqrt N) : ℤ) - 1 +
      ∑ T ∈ (smallPrimes N).powerset, (-1 : ℤ) ^ T.card * ((N / ∏ p ∈ T, p : ℕ) : ℤ) :=
```

```
theorem row_by_sieve (r : ℕ) (hr : 1 ≤ r) :
    (Nat.primeCounting (2 ^ r) : ℤ) = (Nat.primeCounting (Nat.sqrt (2 ^ r)) : ℤ) - 1 +
      ∑ T ∈ (smallPrimes (2 ^ r)).powerset,
        (-1 : ℤ) ^ T.card * ((2 ^ r / ∏ p ∈ T, p : ℕ) : ℤ) :=
```

```
theorem level_card (N k : ℕ) :
    ((smallPrimes N).powersetCard k).card = ((smallPrimes N).card).choose k :=
```

```
theorem sieve_split (N : ℕ) : ((survivors N).card : ℚ) = smoothPart N - netRounding N :=
```

```
theorem smoothPart_eq_prod (N : ℕ) :
    smoothPart N = (N : ℚ) * ∏ p ∈ smallPrimes N, (1 - 1 / (p : ℚ)) :=
#print axioms netRounding_eq
```
