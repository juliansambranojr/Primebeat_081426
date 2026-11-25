> Source: session transcript, 2026-11-24

> The primes are when coupled add composite density to raise the floor and the primes sit at top until it reaches a threshold for a new basin on zeros

From `lean_stage3/Stage3/MollifiedMean.lean`, the mollified zeta the tree already builds:

```
theorem f_eq (s : ℂ) {X N : ℕ} (hX : 2 ≤ X) (hXN : X ≤ N) :
    f X s = ∑ n ∈ Icc 1 (N * X), (b X N n : ℂ) * (n : ℂ) ^ (-s)
      + (-((N : ℂ) ^ (1 - s) / (1 - s))) * M X s
      + (riemannZeta s - ∑ n ∈ Icc 1 N, (n : ℂ) ^ (-s) + (N : ℂ) ^ (1 - s) / (1 - s)) * M X s := by
```
