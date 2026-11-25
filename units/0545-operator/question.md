> Source: session transcript, 2026-11-25

> Yes to all



From `lean_stage3/Stage3/Operator.lean`, the pinned statements:

```
theorem Ires_o (P : Polynomial ℝ) {θ : ℝ} (hθ1 : θ ≤ 1) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) :
    ∀ ε : ℝ, 0 < ε → ∃ T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β → ‖Ires W (Mof T θ) (aY P T θ R) (sig0 T R) α β‖ ≤ ε * T :=
```

```
theorem stmtMollMeanO_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) {R : ℝ} (hR : 0 < R) : StmtMollMeanO P θ R :=
```

