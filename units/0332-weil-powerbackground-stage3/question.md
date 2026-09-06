> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `lean_stage3/Stage3/WeilBackground.lean`, the header of the module this one repeats for the switched window:

> WeilBackground — the window as a test function of the explicit formula, and
> the on-line terms of the zero side. Rung 4b, first half, of the detection
> ladder (units 0316–0319). 2026-09-06.

From `lean_stage3/Stage3/WeilPowerBackground.lean`, the statements as built:

```
theorem laplace_phiW {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
    laplace (phiWC h γ m) z = what h γ m (-z - 1 / 2) := by
```

```
theorem term_eq_neg_sq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (ρ : ℂ) :
    laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))
      = -(what h γ m (ρ - 1 / 2)) ^ 2 := by
```

```
theorem online_term_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) {ρ : ℂ} (hρ : ρ.re = 1 / 2) :
    laplace (phiWC h γ m) (-ρ) * laplace (phiWC h γ m) (-(1 - ρ))
      = (((h / 2) ^ 2 * (PsiW m (h * (ρ.im + γ)) + PsiW m (h * (ρ.im - γ))) ^ 2 : ℝ) : ℂ) := by
```
