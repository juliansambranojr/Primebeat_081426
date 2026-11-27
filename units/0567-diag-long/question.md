> Source: session transcript, 2026-11-25

> Start the sign data and the diagonal please



From `lean_stage3/Stage3/DiagLong.lean`, the pinned statements:

```
theorem diag_split {T L : ℝ} (W : Weight T L) (hT : 4 ≤ T) (M : ℕ) (a : ℕ → ℂ) (σ₀ X : ℝ)
    {α β : ℂ} (hα : ‖α‖ ≤ 1 / 10) (hβ : ‖β‖ ≤ 1 / 10) (hαβ : α + β ≠ 0) :
    diagSum W M a σ₀ α β 1 =
      (what0 W : ℂ) * (riemannZeta (1 + α + β) * Sdiag M a σ₀ α β 0) +
        (Jsh W α β (Zc M (cF a σ₀ X) α β) + Jsh W α β (Zc M (cG a σ₀ X) α β)) :=
```

```
theorem short_part (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) :
    ∃ C T₀ : ℝ, 0 ≤ C ∧ ∀ T : ℝ, T₀ ≤ T → ∀ W : Weight T (Real.log T), ∀ α β : ℂ,
      Regime κ T α β →
        ‖Jsh W α β (Zc (Mof T θ) (cF (aY P T θ R) (sig0 T R) (T ^ (1 - η))) α β)‖ ≤
          C * (T / Real.log T) :=
```

```
theorem stmtDiagTail_of_le (P : Polynomial ℝ) {θ η : ℝ} (h : 2 * θ ≤ 1 - η)
    (R κ : ℝ) : StmtDiagTail P θ R κ η :=
```

```
theorem stmtDiagErr_of_tail (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) (ht : StmtDiagTail P θ R κ η) : FloorLong.StmtDiagErr P θ R κ :=
```

```
theorem tail_of_stmtDiagErr (P : Polynomial ℝ) {θ η : ℝ} (hθ : 0 ≤ θ) (hη : 0 < η) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) (hd : FloorLong.StmtDiagErr P θ R κ) : StmtDiagTail P θ R κ η :=
```

```
theorem stmtDiagErr_holds (P : Polynomial ℝ) {θ : ℝ} (hθ0 : 0 ≤ θ) (hθ : θ < 1 / 2) (R : ℝ)
    {κ : ℝ} (hκ : 0 < κ) : FloorLong.StmtDiagErr P θ R κ :=
```

