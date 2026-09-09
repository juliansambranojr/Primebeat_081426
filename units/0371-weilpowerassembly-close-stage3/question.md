> Source: session transcript, 2026-09-09, after unit 0370

> One relay pass, go

From `lean_stage3/Stage3/WeilPowerAssembly.lean`, the three placeholders now with real signatures:

```
theorem near_nonneg {ε T h γ : ℝ} {m : ℕ} (hε : 0 < ε) (hT : 2 ≤ T) (hh : 0 < h) (hm : 1 ≤ m)
    (near_set : Finset ℂ) (h_near_sub : ↑near_set ⊆ WeilDetect.OffLineBox ε T)
    (h_pointwise : ∀ ρ ∈ near_set, 0 ≤ WeilPowerBands.termW h γ m ρ) :
    0 ≤ ∑ ρ ∈ near_set, WeilPowerBands.termW h γ m ρ
```

```
theorem far_moderate_le {ε T h γ : ℝ} {m : ℕ} (hε : 0 < ε) (hT : 2 ≤ T) (hh : 0 < h) (hm : 1 ≤ m)
    (fm_set : Finset ℂ) (h_fm_sub : ↑fm_set ⊆ WeilDetect.OffLineBox ε T)
    (h_fm_card : (fm_set.card : ℝ) ≤ 15 * Real.log T + 73)
    (U_mem : ℝ) (h_bound : ∀ ρ ∈ fm_set, |WeilPowerBands.termW h γ m ρ| ≤ (h/2)^2 * U_mem^2) :
    |∑ ρ ∈ fm_set, WeilPowerBands.termW h γ m ρ| ≤ (15 * Real.log T + 73) * ((h/2)^2 * U_mem^2)
```
