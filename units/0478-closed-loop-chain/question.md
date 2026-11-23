> Source: session transcript, 2026-11-23

> Join the part to the tree.



From `lean_stage3/Stage3/ClosedLoopChain.lean`, the pinned statements:

```
theorem holyFamily_is_mirror_pair (hf : HolyFamily) : hf.M = 1 - hf.J :=
```

```
theorem holyFamily_pair_area (hf : HolyFamily) {b : ℝ} (hb : 0 < b) :
    b ^ hf.J * b ^ hf.M = b :=
```

```
theorem holyFamily_force (hf : HolyFamily) :
    restoringForce hf.J = 5 / 6 ∧ restoringForce hf.M = 5 / 6 :=
```

```
theorem row_at_midpoint {n : ℕ} (hn : 2 ≤ n) :
    Nat.primeCounting ⌊((Midpoint n : ℚ) : ℝ)⌋₊ = Nat.primeCounting (2 ^ n) :=
```

```
theorem primeBeatTerm_eq_im (t : ℝ) {p : ℕ} (hp : 0 < p) :
    primeBeatTerm t p
      = -(((p : ℝ) : ℂ) ^ (-((1 / 2 : ℂ) + (t : ℂ) * Complex.I))).im :=
```

