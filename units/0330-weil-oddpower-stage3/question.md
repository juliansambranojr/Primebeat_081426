> Source: session transcript, 2026-09-06 (this session), the decision that switched the window

> Ok let’s switch

CONTEXT.md: § Current state of the world (the Lean tree as of entry 170; this module postdates it).

NOTEPAD: no line yet.

From `units/0326-weil-offline-stage3/unit.md`, why the envelope has to be odd:

> The identity. `SigmaC_neg`: the odd envelope's transform is odd, because
> `sinh` is. `ghat_neg`: the window's transform is odd, both halves of unit
> 0318's closed form flipping sign. `term_eq_neg_sq`: for every `ρ`, the two
> factors of a term are the transform read at `ρ − 1/2` and at its negative,
> so the term is `−ghat h γ (ρ − 1/2)²`.

From `lean_stage3/Stage3/WeilOddPower.lean`, the statements as built:

```
theorem S_eq (m : ℕ) (w : ℂ) :
    S m w = 2 * w * K (m + 1) w / (((m : ℂ) + 1) * (Real.pi : ℂ)) := by
```

```
theorem S_mul_QS (m : ℕ) (w : ℂ) : S m w * QS m w = (cS m : ℂ) * Complex.sinh w := by
```

```
theorem what_eq {h : ℝ} (hh : 0 < h) (γ : ℝ) (m : ℕ) (z : ℂ) :
    what h γ m z = ((h : ℂ) / 2) *
      (S m ((z + Complex.I * (γ : ℂ)) * (h : ℂ)) + S m ((z - Complex.I * (γ : ℂ)) * (h : ℂ))) := by
```
