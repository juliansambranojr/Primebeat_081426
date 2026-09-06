> Source: session transcript, 2026-09-06 (this session), the bracket in which slice B1 was asked for

> Continue

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

Lab notebook:

> ## 2026-09-02 — Entry 303 — pricing a Weil-form leaf for Stage 3: the tree's explicit formula has no test-function argument, upstream states the Weil form (Kadiri Thm 3.1, q = 1) with two limit-manage

From `lean_stage3/Stage3/WeilTiles.lean`, the statements as built:

```
theorem idx_spec {t : ℝ} (ht : 11 / 10 ≤ t) : |t - centre (idx t)| ≤ 9 / 10 := by
```

```
theorem tsum_upper_le {h γ : ℝ} (hh : 0 < h) (M : ℕ → ℝ) (hM0 : ∀ k, 0 ≤ M k)
    (hM : ∀ ρ : Kadiri.NontrivialZeros, (ρ : ℂ).re = 1 / 2 → 11 / 10 ≤ (ρ : ℂ).im →
      (laplace (phiC h γ) (-(ρ : ℂ)) * laplace (phiC h γ) (-(1 - (ρ : ℂ)))).re
        ≤ M (idx (ρ : ℂ).im))
    (hsum : Summable (fun k : ℕ => M k * (15 * Real.log (centre k) + 73))) :
    ∑' ρ : Upper, weightedTerm h γ ρ.1 ≤ ∑' k : ℕ, M k * (15 * Real.log (centre k) + 73) := by
  apply Real.tsum_le_of_sum_le
```
