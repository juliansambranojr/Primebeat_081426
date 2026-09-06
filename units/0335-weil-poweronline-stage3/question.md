> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `lean_stage3/Stage3/WeilOnLine.lean`, the header of the module this one repeats for the switched window:

> WeilOnLine — the on-line background, all heights. Rung 4b, second half,
> slice B3 of the detection ladder (units 0316–0323). 2026-09-06.

From `lean_stage3/Stage3/WeilPowerOnLine.lean`, the statements as built:

```
theorem term_conj {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    termW h γ m ((starRingEnd ℂ) ρ) = termW h γ m ρ := by
```

```
theorem tsum_onLine_le {h γ : ℝ} (hh : 0 < h) (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    ∑' ρ : OnLine, weightedTermW h γ m ρ.1 ≤ onLineBound h γ m := by
```

```
theorem onLineBound_le {h γ : ℝ} (hγ : 11 / 10 ≤ γ) (m : ℕ) :
    onLineBound h γ m
      ≤ 2 * (88 * (γ + r h m + 2) ^ 4 * (4 * h ^ 2 + cFarM m / h ^ 2) * (Real.pi ^ 2 / 6))
        + 4 * h ^ 2 * lowCount := by
```
