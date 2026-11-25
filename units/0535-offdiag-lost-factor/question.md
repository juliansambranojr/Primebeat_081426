> Source: session transcript, 2026-11-25

> Yes to all of it please

From `lean_stage3/Stage3/TwistedMoment.lean`, the summed bound with two integrations by parts:

```
theorem offSum_bound :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ (T L : ℝ) (W : Weight T L), 8 ≤ T → 1 ≤ L →
      ∀ (M : ℕ) (a : ℕ → ℂ) (σ₀ : ℝ) (α β : ℂ), ‖α‖ ≤ 1 / 10 → ‖β‖ ≤ 1 / 10 → α + β ≠ 0 →
      ∀ c : ℝ, 0 < c →
        ‖offSum W M a σ₀ α β c‖ ≤ K * (1 + W.C1 + W.C2) * (1 + 1 / ‖α + β‖ ^ 2) * T *
          ((T / L) ^ 2)⁻¹ * (∑ h ∈ Finset.Icc 1 M, ‖a h‖ * (h : ℝ) ^ (1 - σ₀)) ^ 2 *
          offSeries T := by
```
