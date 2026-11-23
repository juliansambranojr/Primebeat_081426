> Source: session transcript, 2026-11-23

> Primes are compression of the composites up to that step



From `lean_stage3/Stage3/Compression.lean`, the pinned statements:

```
theorem unique_new_prime {N n p q : ℕ} (hn1 : 1 ≤ n) (hn : n ≤ N) (hp : p.Prime) (hq : q.Prime)
    (hpN : Nat.sqrt N < p) (hqN : Nat.sqrt N < q) (hpn : p ∣ n) (hqn : q ∣ n) : p = q :=
```

```
theorem compression (N : ℕ) : N = smooth N + ∑ p ∈ newPrimes N, N / p :=
```

