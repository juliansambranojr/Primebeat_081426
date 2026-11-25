> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/ApproxShift.lean`, the pinned statements:

```
theorem FL_bound (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| →
      ‖FL α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) :=
```

```
theorem FY_horiz_bound (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    ∃ C Y₀ : ℝ, 0 ≤ C ∧ 1 ≤ Y₀ ∧ ∀ s : ℂ, |s.re| ≤ c → Y₀ ≤ |s.im| →
      ‖FY α β t s‖ ≤ C * Real.exp (-(1 / 2) * s.im ^ 2) :=
```

```
theorem Lambda_bound (R : ℝ) :
    ∃ M : ℝ, 0 ≤ M ∧ ∀ w : ℂ, |w.re| ≤ R → 1 ≤ |w.im| →
      ‖completedRiemannZeta w‖ ≤ M * (6 + 4 * ‖w‖) :=
```

```
theorem FL_horiz_tendsto (α β : ℂ) (t : ℝ) {c : ℝ} (hc : 0 ≤ c) :
    Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, FL α β t (x + y * I)) atTop (𝓝 0) ∧
      Tendsto (fun y : ℝ => ∫ x : ℝ in (-c)..c, FL α β t (x + y * I)) atBot (𝓝 0) :=
```

```
theorem stmtShift_holds {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c)
    (hαβ : α + β ≠ 0) (huv : uA α t ≠ vB β t) : StmtShift α β t c :=
```

```
theorem approxFE {α β : ℂ} {t c : ℝ} (hα : α.re < 1 / 2) (hβ : β.re < 1 / 2)
    (hα' : -(1 / 2) < α.re) (hβ' : -(1 / 2) < β.re)
    (hcα : 1 / 2 + |α.re| < c) (hcβ : 1 / 2 + |β.re| < c)
    (hαβ : α + β ≠ 0) (huv : uA α t ≠ vB β t) :
    riemannZeta (uA α t) * riemannZeta (vB β t) =
      (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA α t) * ((p.2 : ℂ) + 1) ^ (-vB β t) *
        VY α β c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) +
      XY α β t * (∑' p : ℕ × ℕ, ((p.1 : ℂ) + 1) ^ (-uA (-β) t) *
        ((p.2 : ℂ) + 1) ^ (-vB (-α) t) *
        VY (-β) (-α) c (((p.1 : ℝ) + 1) * ((p.2 : ℝ) + 1)) t) - resY α β t :=
```

