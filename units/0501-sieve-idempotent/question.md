> Source: session transcript, 2026-11-23

> the reason the settling happens one slot at a time is idempotence. All the steps become f and scales at any x



From `lean_stage3/Stage3/SieveIdem.lean`, the pinned statements:

```
theorem sieveStep_idem (p : ℕ) (A : Finset ℕ) :
    sieveStep p (sieveStep p A) = sieveStep p A :=
```

```
theorem sieveStep_comm (p q : ℕ) (A : Finset ℕ) :
    sieveStep p (sieveStep q A) = sieveStep q (sieveStep p A) :=
```

```
theorem sieveBelow_succ {p : ℕ} (hp : p.Prime) (A : Finset ℕ) :
    sieveBelow (p + 1) A = sieveStep p (sieveBelow p A) :=
```

```
theorem rough_eq_card (N p : ℕ) :
    CompositeSplit.rough N p = (sieveBelow p (Icc 1 (N / p))).card :=
```

```
theorem settles_on_prime {m : ℕ} (hm : 2 ≤ m)
    (h : ∀ q : ℕ, q.Prime → q < m → ¬ q ∣ m) : m.Prime :=
```

