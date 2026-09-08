> Source: session transcript, 2026-09-08, rung 5 after the count-to-argument step

> Let's work on this - Rung 5: gap-dependent L(ε,T,δ) unpriced; section 14 unverified on the two-sideband term (line 29). Nothing consumes StmtDetect. That what we were working on before we switched to h3, yes?

From `lean_stage3/Stage3/WeilPowerBridge.lean`, the object both scripts compute on:

```
theorem term_eq_sidebands {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    WeilPowerBands.termW h γ m ρ
      = -((h / 2) ^ 2 * (((S m (wm h γ ρ)) ^ 2).re
          + 2 * (S m (wp h γ ρ) * S m (wm h γ ρ)).re
          + ((S m (wp h γ ρ)) ^ 2).re))
```

From `lean_stage3/Stage3/WeilOddPower.lean`, the closed form the scripts evaluate:

```
theorem S_mul_QS (m : ℕ) (w : ℂ) : S m w * QS m w = (cS m : ℂ) * Complex.sinh w
```
