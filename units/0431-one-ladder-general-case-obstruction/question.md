> Source: session transcript, 2026-11-22, after the merge of pull request 8

> The harder general case

No statement is pinned by this unit. The theorems it reads are in units 0429, 0430 and 0432. The one that carries the case which closes, from `lean_stage3/Stage3/LadderMean.lean`:

```
theorem mean_extract {ι : Type*} (w C : ι → ℂ) (hw : ∀ i, ‖w i‖ = 1)
    (hC : Summable fun i => ‖C i‖) (k : ι)
    (h : Tendsto (fun r : ℕ => ∑' i, C i * w i ^ r) atTop (𝓝 0)) :
    ∑' i, (if w i = w k then C i else 0) = 0 := by
```
