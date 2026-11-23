> Source: session transcript, 2026-11-23

> Have you looked at the composite table for the answer?



From `lean_stage3/Stage3/CompositeSplit.lean`, the pinned statements:

```
theorem card_least_prime (N : ℕ) {p : ℕ} (hp : p.Prime) :
    ((Icc 2 N).filter (fun n => n.minFac = p)).card = rough N p :=
```

```
theorem composites_by_least_prime (N : ℕ) :
    ((Icc 2 N).filter (fun n => ¬ n.Prime)).card
      = ∑ p ∈ smallPrimes N,
          ((Icc 2 N).filter (fun n => ¬ n.Prime ∧ n.minFac = p)).card :=
```

```
theorem composites_no_signs (N : ℕ) :
    ((Icc 2 N).filter (fun n => ¬ n.Prime)).card + (smallPrimes N).card
      = ∑ p ∈ smallPrimes N, rough N p :=
```

