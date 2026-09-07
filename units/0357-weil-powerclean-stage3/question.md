> Source: session transcript, 2026-09-07, the third module under the relay

> lets do rung 5

> done, resume at § 5.

From `lean_stage3/Stage3/WeilPowerClean.lean`, two of the four pinned statements:

```
theorem blocked_card_le {a ρ lo hi d : ℝ} {W : ℕ} (B : Finset ℕ)
    (hρ : 1 ≤ ρ) (hlo : 0 < lo) (hW : hi < lo * ρ ^ (W + 1))
    (hB : ∀ k ∈ B, lo ≤ d * (a * ρ ^ k) ∧ d * (a * ρ ^ k) ≤ hi) :
    B.card ≤ W + 1 := by
```

```
theorem exists_unblocked {ι : Type*} [DecidableEq ι] (S : Finset ι)
    (B : ι → Finset ℕ) {K W : ℕ}
    (hB : ∀ j ∈ S, (B j).card ≤ W) (hK : S.card * W < K) :
    ∃ k, k < K ∧ ∀ j ∈ S, k ∉ B j := by
```
