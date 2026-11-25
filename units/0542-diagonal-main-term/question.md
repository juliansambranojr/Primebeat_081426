> Source: session transcript, 2026-11-25

> Yes



From `lean_stage3/Stage3/SdiagLead.lean`, the pinned statements:

```
theorem stmtSdiagLead_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (_hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) (hA : StmtArith) :
    StmtSdiagLead P θ R κ :=
```

```
theorem stmtDiagMainO_holds (P : Polynomial ℝ) (hP0 : P.eval 0 = 0) {θ : ℝ} (hθ0 : 0 < θ)
    (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ} (hκ : 0 < κ) (hA : StmtArith) :
    StmtDiagMainO P θ R κ :=
```

