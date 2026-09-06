> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `lean_stage3/Stage3/WeilSeries.lean`, the header of the module this one repeats for the switched window:

> WeilSeries — the band series made explicit. Rung 4b, second half, slice B2
> of the detection ladder (units 0316–0322). 2026-09-06.

From `lean_stage3/Stage3/WeilPowerBands.lean`, the statements as built:

```
theorem term_le_M {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) (ρ : Kadiri.NontrivialZeros)
    (hre : (ρ : ℂ).re = 1 / 2) (him : 11 / 10 ≤ (ρ : ℂ).im) :
    termW h γ m ρ ≤ M h γ m (idx (ρ : ℂ).im) := by
```

```
theorem cFarM_le (m : ℕ) : cFarM m ≤ 1000 * ((m : ℝ) + 1) ^ 2 := by
```

```
theorem tsum_upper_le_explicit' {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    ∑' ρ : Upper, weightedTermW h γ m ρ.1
      ≤ 88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6) := by
```
