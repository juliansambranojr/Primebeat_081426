> Source: session transcript, 2026-11-25

> Yes to all



From `lean_stage3/Stage3/DiagonalO.lean`, the pinned statements:

```
theorem small_of_log {C ε T : ℝ} (hε : 0 < ε) (hT : 1 < T)
    (hTe : Real.exp (C / ε) ≤ T) : C * (T / Real.log T) ≤ ε * T :=
```

```
theorem errY_absorb {T : ℝ} (W : Weight T (Real.log T)) {K ε : ℝ} (hε : 0 < ε)
    (hT : 1 < T) (hTe : Real.exp (K / ε) ≤ T) : K * errY W ≤ ε * errO W :=
```

```
theorem T_le_errO {T L : ℝ} (W : Weight T L) (hT : 0 ≤ T) : T ≤ errO W :=
```

```
theorem what0_le {T L : ℝ} (W : Weight T L) (hT : 0 < T) : ‖(what0 W : ℂ)‖ ≤ 2 * T :=
```

```
theorem stmtDiagO_of_mainO (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMainO P θ R κ) : StmtDiagO P θ R κ :=
```

```
theorem lemma3_resO_of_parts {P : Polynomial ℝ} {θ R κ : ℝ} (hκ : 0 < κ)
    (hD : StmtDiagO P θ R κ) (hO : StmtOffDiagAll P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3resO P θ R κ :=
```

```
theorem lemma3_resO_of_mainO_X (P : Polynomial ℝ) {θ : ℝ} (hθ : θ < 1 / 2) (R : ℝ) {κ : ℝ}
    (hκ : 0 < κ) (hmain : StmtDiagMainO P θ R κ) (hX : StmtX P θ R κ) :
    StmtLemma3resO P θ R κ :=
```

